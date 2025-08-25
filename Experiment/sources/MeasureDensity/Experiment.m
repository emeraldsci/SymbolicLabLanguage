(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentMeasureDensity*)


DefineOptions[ExperimentMeasureDensity,
	Options :> {
		{
			OptionName -> NumberOfReplicates,
			Default -> 5,
			Description -> "The number of times to repeat density measurement on each provided sample.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterEqualP[1,1]
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "The type of measurement performed to determine the density of the sample.",
				ResolutionDescription -> "Is automatically set to DensityMeter unless the volume is too low (below 2 mL) or the manual fixed volume weight method is specified.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[DensityMethodP,Automatic]
				]
			},
			{
				OptionName -> Volume,
				Default -> Automatic,
				Description -> "The volume of the liquid that will be used for density measurement.",
				ResolutionDescription -> "Is automatically set to 2 Milliliter (if total sample volume is sufficient, to allow the more accurate density meter method) or 90% of the sample, whichever is smaller.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[50 Microliter, 2 Milliliter],
					Units->Alternatives[Microliter, Milliliter]
				]
			},
			{
				OptionName -> Instrument,
				Default -> Automatic,
				Description -> "The instrument used to perform the density analysis.",
				ResolutionDescription -> "Is automatically set to DensityMeter unless the volume is too low (below 2 mL) or a manual method is specified (where a balance is automatically selected instead).",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Instrument, DensityMeter],Object[Instrument, DensityMeter],Model[Instrument,Balance],Object[Instrument,Balance]}],
					ObjectTypes->{Model[Instrument, DensityMeter],Object[Instrument, DensityMeter],Model[Instrument,Balance],Object[Instrument,Balance]}
				]
			},
			{
				OptionName -> RecoupSample,
				Default -> Automatic,
				Description -> "Indicates if the transferred liquid used for density measurement will be recouped (transferred back into the original container) or discarded.",
				ResolutionDescription -> "Is automatically set to False for samples with at least 100mL of volume (5mL for density meter), and to True for samples with less than 100mL of volume (5mL for density meter).",
				AllowNull->False,
				Category -> "General",
				Widget -> Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				]
			},

			(*Density meter only options*)
			{
				OptionName -> Temperature,
				Default -> Automatic,
				Description -> "Indicates the desired temperature used for density measurement (refers to the temperature inside the instrument chamber during measurement only).",
				ResolutionDescription -> "Is automatically set to 20 Celsius unless a different temperature is given.",
				AllowNull->True,
				Category -> "Method",
				Widget -> Widget[
					Type->Quantity,
					Pattern:> RangeP[0 Celsius, 100 Celsius],
					Units->Celsius
				]
			},
			{
				OptionName -> ViscosityCorrection,
				Default -> Automatic,
				Description -> "Determines if viscosity correction should be automatically applied during density meter measurement to provide the most accurate result.",
				ResolutionDescription -> "Is automatically set to true unless false is specified (usually for comparison to older instrument results).",
				AllowNull -> True,
				Category -> "Method",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> WashSolution,
				Default -> Automatic,
				Description -> "The solution used to perform the washing of the previous sample out of the instrument chamber (should be a good solvent for the sample).",
				ResolutionDescription -> "Is automatically set to Milli-Q water unless a specific solvent is chosen.",
				AllowNull -> True,
				Category -> "Method",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Water,Hexanes,Automatic]
				]
			},
			{
				OptionName -> SecondaryWashSolution,
				Default -> Automatic,
				Description -> "A fast-evaporating solution used to remove traces of the first wash solution and facilitate drying the instrument chamber (should be a good solvent for the first wash solution).",
				ResolutionDescription -> "Is automatically set to 95 % ethanol unless a specific solvent is chosen.",
				AllowNull -> True,
				Category -> "Method",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ethanol,Acetone,Automatic]
				]
			},
			{
				OptionName -> TertiaryWashSolution,
				Default -> Automatic,
				Description -> "A fast-evaporating solution used to remove traces of the second wash solution and facilitate drying the instrument chamber.",
				ResolutionDescription -> "Is automatically set to acetone unless a specific solvent is chosen.",
				AllowNull -> True,
				Category -> "Method",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ethanol,Acetone,Automatic]
				]
			},
			{
				OptionName -> WashVolume,
				Default -> Automatic,
				Description -> "The volume of each wash solution used for primary and secondary washing in between each sample run.",
				ResolutionDescription -> "Is automatically set to 10 mL unless a higher number is chosen (typically for samples more difficult to clean out of the chamber).",
				AllowNull -> True,
				Category -> "Method",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 Milliliter,50 Milliliter,10 Milliliter],
					Units->Milliliter
				]
			},
			{
				OptionName -> WashCycles,
				Default -> Automatic,
				Description -> "Number of wash cycles (using primary, secondary and tertiary wash solutions once per cycle) to perform in between each sample run.",
				ResolutionDescription -> "Is automatically set to 1 unless a higher number is chosen (typically for samples more difficult to clean out of the chamber) up to a maximum of 3 cycles.",
				AllowNull -> True,
				Category -> "Method",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1,3,1]
					]
			},
			{
				OptionName -> AirWaterCheck,
				Default -> Automatic,
				Description -> " If AirWaterCheck sets to be True, the density meter measures density of water and air before measuring the density of sample. This verifies how clean and dry the measuring tube is.",
				ResolutionDescription -> "Is automatically set to False if Method is set to DensityMeter.",
				AllowNull -> True,
				Category -> "Method",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			}
		],
		ModelInputOptions,
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		SimulationOption
	}
];

Warning::ModelDensityNotUpdated = "The Models `1` already have Density information and will not have their Density updated during the course of this protocol.";
Warning::ModelDensityOverwritten = "The Models `1` already have Density information, which will be overwritten as the result of this protocol.";
Warning::AmbientTemperatureMeasurement = "The Samples `1` will be transported at the temperature indicated by the TransportTemperature fields in their model, but samples will not remain at that temperature during density measurement.";
Error::MeasureDensityInsufficientVolume="The volume of `1` is `2`, but at least 50 Microliter is required to measure the density of this sample. Please select another sample or specify smaller values for the Volume or NumberOfReplicates options.";
Error::MeasureDensitySolidSample="The State of `1` is Solid. Only samples with Liquid state can have their density measured. Please remove these samples from the inputs.";
Error::MeasureDensityVolumeUnknown="The volume of `1` is unknown. This function cannot be performed unless volume information is provided.";
Error::MeasureDensityVentilatedSamples="MeasureDensity does not currently support samples when using the Density Meter. Please check: `1`";
Error::InvalidWashSolution="The selected WashSolution option(s) for samples `1` are not compatible with the method selected. This option must not be Null if DensityMeter is the Method, and must be Null if FixedVolumeWeight is the Method.";
Error::InvalidSecondaryWashSolution="The selected SecondaryWashSolution option(s) for samples `1` are not compatible with the method selected. This option must not be Null if DensityMeter is the Method, and must be Null if FixedVolumeWeight is the Method.";
Error::InvalidTertiaryWashSolution="The selected TertiaryWashSolution option(s) for samples `1` are not compatible with the method selected. This option must not be Null if DensityMeter is the Method, and must be Null if FixedVolumeWeight is the Method.";
Error::InvalidWashVolume="The selected WashVolume option(s) for samples `1` are not compatible with the method selected. This option must not be Null if DensityMeter is the Method, and must be Null if FixedVolumeWeight is the Method.";
Error::InvalidWashCycles="The selected WashCycles option(s) for samples `1` are not compatible with the method selected. This option must not be Null if DensityMeter is the Method, and must be Null if FixedVolumeWeight is the Method.";
Error::InvalidTemperature="The selected Temperature option(s) for samples `1` are not compatible with the method selected. This option must not be Null if DensityMeter is the Method, and must be Null if FixedVolumeWeight is the Method (FixedVolumeWeight samples can only be measured at Ambient temperature).";
Error::InvalidViscosityCorrection="The selected ViscosityCorrection option(s) for samples `1` are not compatible with the method selected. This option is must not be Null if DensityMeter is the Method, and must be Null if FixedVolumeWeight is the Method.";
Error::MeasureDensityIncompatibleInstrument="The selected balance instrument for samples `1` is not compatible with the FixedVolumeWeight method. Please change the selected option value to a supported microbalance or Automatic.";
Error::MeasureDensityIncompatibleVolume="A Volume option was specified for samples `1` that is not 2 Milliliter, but the DensityMeter method is a fixed volume instrument. Please specify 2 Milliliter or Automatic.";
Error::InvalidAirWaterCheck="The selected AirWaterCheck option for sample `1` is not compatible with the method selected. This option must be Null if Method is FixedVolumeWeight. Please change the option value to Null.";
Error::MeasureDensityVolumeTooLow=" The samples `1` do not have sufficient volume to be measured (at least 50 Microliter is required to measure density).";



ExperimentMeasureDensity[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[ExperimentMeasureDensity]]:=Module[
	{
		listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, updatedSimulation, containerToSampleResult, containerToSampleOutput, containerToSampleTests,
		containerToSampleSimulation, inputSamples, samplesOptions
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureDensity,
			ToList[myContainers],
			ToList[myOptions]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* convert the containers to samples, and also get the options index matched properly *)
	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentMeasureDensity,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentMeasureDensity,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->{Result,Simulation},
				Simulation->updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult,$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{inputSamples, samplesOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentMeasureDensity[inputSamples,ReplaceRule[samplesOptions,Simulation->containerToSampleSimulation]]
	]
];

ExperimentMeasureDensity[myInput:ObjectP[{Object[Sample],Model[Sample]}],myOptions:OptionsPattern[ExperimentMeasureDensity]]:=ExperimentMeasureDensity[ToList[myInput],myOptions];
ExperimentMeasureDensity[myInputs:{ObjectP[{Object[Sample],Model[Sample]}]..},myOptions:OptionsPattern[ExperimentMeasureDensity]]:=Module[
	{listedOptions,listedInput,cacheOption,output,outputSpecification,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,updatedSimulation,allSamplePackets,safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,
		inheritedOptions,expandedSafeOps,uploadOption,confirmOption,canaryBranchOption,parentProtocolOption,rawEmailOption,emailOption,samplePackets,modelDensity,
		resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,cacheBall,
		resourcePacket,resourcePacketTests,allTests,protocolObject,specifiedBalanceModels, specifiedBalanceObjs, allDownloadValues,
		mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed
	},

(* Check that all options are singletons or match the length of their index-matched associate *)
	listedOptions = ToList[myOptions];
	cacheOption = ToList[Lookup[listedOptions,Cache,{}]];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedInput, listedOptions} = removeLinks[ToList[myInputs], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureDensity,
			listedInput,
			listedOptions
		],
		$Failed,
	 	{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentMeasureDensity,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentMeasureDensity,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],Null}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	(* delete the PreparedResources because of Cam's thing*)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentMeasureDensity,{mySamplesWithPreparedSamples},safeOps,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentMeasureDensity,{mySamplesWithPreparedSamples},safeOps],Null}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentMeasureDensity,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentMeasureDensity,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps = Last@ExpandIndexMatchedInputs[ExperimentMeasureDensity,{ToList[mySamplesWithPreparedSamples]},inheritedOptions];

	(* Lookup some standard options from the safe options*)
	{uploadOption,confirmOption,canaryBranchOption,parentProtocolOption,rawEmailOption}=Lookup[
		inheritedOptions,
		{Upload,Confirm,CanaryBranch,ParentProtocol,Email}
	];

	(* adjust the email option based on the upload option *)
	emailOption=If[!MatchQ[emailOption, Automatic],rawEmailOption,
		If[And[uploadOption, MemberQ[output, Result]],True,False]
	];

	(*Set all sample prep and sample fields to be downloaded to a variable*)

	allSamplePackets={
		(* Sample Information *)
		Packet[
			(*Sample prep fields*)
			Sequence@@SamplePreparationCacheFields[Object[Sample]],
			(* For MeasureDensity *)
			Density,State,DensityLog,RequestedResources,Notebook,
			(*Transport and fume hood info previously from model*)
			TransportTemperature,Ventilated,IncompatibleMaterials
		],

		(* Sample Model information *)
		Packet[Model[{
			Name,Density,Notebook,Deprecated
		}]],

		(* Sample's Container packet information *)
		Packet[Container[{
			(*Sample container prep fields*)
			Sequence@@SamplePreparationCacheFields[Object[Container]]
		}]],

		(* Container Model Packet *)
		Packet[Container[Model][{
			(*Sample container model prep fields*)
			Sequence@@SamplePreparationCacheFields[Model[Container]],
			(* MeasureDensity required *)
			AspirationDepth,InternalDepth,WellDimensions,WellDiameter,WellDepth,
			(* Cache required *)
			VolumeCalibrations
		}]]

	};

	(* get any specified balance models *)
	specifiedBalanceModels = DeleteDuplicates[Cases[expandedSafeOps, ObjectReferenceP[Model[Instrument, Balance]], Infinity]];
	specifiedBalanceObjs = DeleteDuplicates[Cases[expandedSafeOps, ObjectReferenceP[Object[Instrument, Balance]], Infinity]];

	(* Download all the needed things *)
	allDownloadValues = Quiet[
		Download[
			{
				mySamplesWithPreparedSamples,
				specifiedBalanceModels,
				specifiedBalanceObjs
			},
			{
				allSamplePackets,
				{Packet[Mode]},
				{
					Packet[Model],
					Packet[Model[Mode]]
				}
			},
			Cache->cacheOption,
			Simulation->updatedSimulation,
			Date->Now
		],
		Download::FieldDoesntExist
	];

	samplePackets = allDownloadValues[[1, All, 1]];
	modelDensity = allDownloadValues[[1, All, 2]];

	(* Add the new packets to the cache *)
	cacheBall = FlattenCachePackets[{cacheOption, allDownloadValues}];

	(* Do a quick error check to flag any Models will either not be updated or have their Density overwritten *)
	(* Only check if this is being run by a User. If it's a subprotocol, ignore this check *)
	If[And[NullQ[parentProtocolOption],!MatchQ[$ECLApplication,Engine]],
		Module[
			{publicModelsWithDensity,privateModelsWithDensity},

			(* Gather the models that will not have their density updated *)
			publicModelsWithDensity = Cases[modelDensity,KeyValuePattern[{Density->Except[Null],Notebook->Null}]];

			(* Gather the models that will have their density updated but should have their warning thrown *)
			privateModelsWithDensity = Cases[modelDensity,KeyValuePattern[{Density->Except[Null],Notebook->Except[Null]}]];

			If[And[!MatchQ[publicModelsWithDensity,{}],!MatchQ[$ECLApplication,Engine]],Message[Warning::ModelDensityNotUpdated,Download[publicModelsWithDensity,Object]]];
			If[And[!MatchQ[privateModelsWithDensity,{}],!MatchQ[$ECLApplication,Engine]],Message[Warning::ModelDensityOverwritten,Download[privateModelsWithDensity,Object]]];
		]
	];

	(* resolve the options*)
	resolvedOptionsResult = Check[
		{resolvedOptions,resolvedOptionsTests}=If[gatherTests,
			resolveMeasureDensityOptions[Flatten[samplePackets],expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
			{resolveMeasureDensityOptions[Flatten[samplePackets],expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->Result],Null}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentMeasureDensity,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentMeasureDensity,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePacket,resourcePacketTests} = If[gatherTests,
		measureDensityResourcePackets[Flatten[samplePackets],resolvedOptions,templatedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
		{measureDensityResourcePackets[Flatten[samplePackets],resolvedOptions,templatedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->Result],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentMeasureDensity,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* combine all the tests *)
	allTests=DeleteCases[Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],Null];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePacket,$Failed],
		UploadProtocol[
			resourcePacket,(* This is the protocol packet *)
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			CanaryBranch->Lookup[safeOps,CanaryBranch],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
 			StartDate->Lookup[safeOps,StartDate],
 			HoldOrder->Lookup[safeOps,HoldOrder],
 			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,MeasureDensity],
			Simulation->updatedSimulation
		],
		$Failed
	];

	(* return the result, depending on the output option *)
	outputSpecification/.{
		Tests->allTests,
		Options->RemoveHiddenOptions[ExperimentMeasureDensity,resolvedOptions],
		Result->protocolObject,
		Preview->Null
	}
];


(* ::Subsubsection:: *)
(*resolveMeasureDensityOptions - Options*)


DefineOptions[
	resolveMeasureDensityOptions,
	Options:>{
		CacheOption,
		OutputOption,
		SimulationOption
	}
];


(* ::Subsection::Closed:: *)
(*resolveMeasureDensityOptions*)


resolveMeasureDensityOptions[mySamples:ListableP[PacketP[{Object[Sample]}]],myUnresolvedOptions:{_Rule..},ops:OptionsPattern[resolveMeasureDensityOptions]]:=Module[
	{
		outputSpecification,output,gatherTests,messages,cache,simulation,samplePrepOptions,measureDensityOptions,simulatedSamples,
		resolvedSamplePrepOptions,updatedSimulation,measureDensityOptionsAssociation,numReplicates,parentProtocol,
		samplePackets,modelParameters,fullCache,discardedSamplePackets,discardedInvalidInputs,discardedTests,
		solidSamplePackets,solidInvalidInputs,solidSampleTests,roundedOps,precisionTests,nullVolSamplePackets,
		nullVolInvalidInputs,nullVolSampleTests,tooLowVolPackets,tooLowVolInvalidInputs,tooLowVolSampleTests,lowVolumeBool,
		mapThreadFriendlyOptions,imageSample,recoupSampleOps,measurementVolumes,insufficientVolumeErrors,
		invalidViscosityCorrectionErrors,invalidWashSolutionOptions,invalidSecondaryWashSolutionOptions,invalidTertiaryWashSolutionOptions,
		invalidWashVolumeOptions,invalidWashCyclesOptions,invalidTemperatureOptions,invalidViscosityCorrectionOptions,
		incompatibleInstrumentOptions,incompatibleVolumeOptions,invalidWashSolutionTests,invalidSecondaryWashSolutionTests,
		invalidTertiaryWashSolutionTests,invalidWashVolumeTests,invalidWashCyclesTests,
		invalidTemperatureTests,invalidViscosityCorrectionTests,incompatibleInstrumentTests,incompatibleVolumeTests,
		transportedAtTempObjects,transportedAtTempPackets,transportedAtTempInvalidInputs,transportedAtTempTests,
		ventilatedSamples,methodVentilatedErrors,instrumentVentilatedErrors,resolvedAliquotOptions,aliquotTests,
		invalidVentilatedInstrumentSamps,invalidVentilatedMethodSamps,invalidVentilatedOptions,invalidVentilatedInstrumentTests,
		invalidVentilatedMethodTests,insufficientVolumeInvalidOptions,insufficientVolumeTests,invalidInputs,invalidOptions,allTests,
		invalidWashSolutionErrors,invalidSecondaryWashSolutionErrors,invalidTertiaryWashSolutionErrors,invalidWashVolumeErrors,
		invalidWashCyclesErrors,invalidTemperatureErrors,incompatibleInstrumentErrors,incompatibleVolumeErrors,
		resolvedPostProcessingOptions,requiredAliquotAmounts,densityMeterModel,fastAssoc,compatibleMaterialsInvalidInputs,
		compatibleMaterialsBool,compatibleMaterialsTests,viscosityCorrections,measurementMethods,measurementTemperatures,instruments,
		firstWashSolutions,secondaryWashSolutions,tertiaryWashSolutions,washCycles,washVolumes,airWaterChecks,invalidAirWaterCheckErrors,
		invalidAirWaterCheckOptions,invalidAirWaterCheckTests
	},

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[ops],Cache,{}];
	simulation = Lookup[ToList[ops],Simulation,{}];

	(* Separate out our Measure Density options from our Sample Prep options. *)
	{samplePrepOptions,measureDensityOptions} = splitPrepOptions[myUnresolvedOptions];

	(* Resolve our sample prep options *)
	{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation}=resolveSamplePrepOptionsNew[ExperimentMeasureDensity,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->Result];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	measureDensityOptionsAssociation = Association[measureDensityOptions];

	(* Determine if there's a parent protocol. If there is, our behavior (particularly around errors) will be change *)
	parentProtocol = Lookup[measureDensityOptionsAssociation,ParentProtocol];

	(* Gather NumberOfReplicates from safeOps *)
	numReplicates = Lookup[measureDensityOptionsAssociation,NumberOfReplicates];

	(* Extract the packets that we need from our downloaded cache. *)
	{samplePackets,modelParameters}=Quiet[
		Transpose@Download[
			ToList[simulatedSamples],
			{
				(* Sample packet information *)
				Packet[Status,Model,State,Volume,Density,Count,TransportTemperature,Ventilated,IncompatibleMaterials],

				(* Model information packets *)
				Packet[Model[{Density,Notebook}]]
			},
			Simulation->updatedSimulation,
			Cache->cache
		],
		Download::FieldDoesntExist
	];

	(* make a fastAssoc from everything *)
	fastAssoc = makeFastAssocFromCache[FlattenCachePackets[{cache, samplePackets, modelParameters}]];

	(* -- Check Ventilated Samples -- *)
	ventilatedSamples = PickList[simulatedSamples,samplePackets,_?(TrueQ[Lookup[#,Ventilated]]&)];

	(* Store the full cache so lower functions (like PreferredVessel) don't need to go to the DB *)
	fullCache = Join[cache,Flatten[{samplePackets,modelParameters}]];

	(*-- INPUT VALIDATION CHECKS --*)
	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[samplePackets,KeyValuePattern[Status -> Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded. *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are discard samples in the inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Simulation->updatedSimulation]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Simulation->updatedSimulation]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* ---Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument --- *)

	(* Get the model of the density meter *)
	(*TODO: Note that this is hardcoded for now since there is only one model, update if more instrument models are added. Can also only check if samples will be measured using the density meter*)
	densityMeterModel=Model[Instrument,DensityMeter,"id:P5ZnEjdbXEbE"];

	(* call CompatibleMaterialsQ and figure out if materials are compatible *)
	{compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
		CompatibleMaterialsQ[densityMeterModel, simulatedSamples, Cache -> cache, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		{CompatibleMaterialsQ[densityMeterModel, simulatedSamples, Cache -> cache, Simulation -> updatedSimulation, Messages -> !gatherTests], {}}
	];

	(* If the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidInputs = If[Not[compatibleMaterialsBool] && messages,
		Download[mySamples, Object],
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	compatibleMaterialsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[compatibleMaterialsInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[compatibleMaterialsInvalidInputs,Simulation->updatedSimulation]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[compatibleMaterialsInvalidInputs]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,compatibleMaterialsInvalidInputs],Simulation->updatedSimulation]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Get the samples from mySamples that are solids. *)
	solidSamplePackets=Cases[samplePackets,KeyValuePattern[State -> Solid]];

	(* Set solidInvalidInputs to the input objects whose states are Solid *)
	(* NOTE: We permit silencing this error if we're in a subprotocol as ExperimentMeasureDensity will exclude these samples from the measurement automatically *)
	(*       We must still throw an error if we're not in a sub protocol however as we need the user to know we cannot measure volume their solid samples *)
	solidInvalidInputs=If[MatchQ[solidSamplePackets,{}],
		{},
		Lookup[solidSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[
		And[
			Length[solidInvalidInputs]>0,
			!gatherTests,
			NullQ[parentProtocol]
		],
		Message[Error::MeasureDensitySolidSample, ObjectToString[solidInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	solidSampleTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[solidInvalidInputs]==0,
				Nothing,
				Test["The input sample(s) "<>ObjectToString[solidInvalidInputs,Simulation->updatedSimulation]<>" are not solids:",True,False]
			];

			passingTest=If[Length[solidInvalidInputs]==Length[mySamples],
				Nothing,
				Test["The input sample(s) "<>ObjectToString[Complement[mySamples,solidInvalidInputs],Simulation->updatedSimulation]<>" are not solids:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Get the samples from mySamples that have a Null volume. *)
	nullVolSamplePackets=Cases[samplePackets,KeyValuePattern[Volume -> Null]];

	(* Set nullVolInvalidInputs to the input objects whose volumes are Null *)
	(* NOTE: We permit silencing this error if we're in a subprotocol as ExperimentMeasureDensity will exclude these samples from the measurement automatically *)
	(*       We must still throw an error if we're not in a sub protocol however as we need the user to know we can measure volume of the null volume samples *)
	nullVolInvalidInputs=If[MatchQ[nullVolSamplePackets,{}],
		{},
		Lookup[nullVolSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[
		And[
			Length[nullVolInvalidInputs]>0,
			!gatherTests,
			NullQ[parentProtocol]
		],

		Message[Error::MeasureDensityVolumeUnknown, nullVolInvalidInputs]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nullVolSampleTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nullVolInvalidInputs]==0,
				Nothing,
				Test["The input sample(s) "<>ObjectToString[nullVolInvalidInputs,Simulation->updatedSimulation]<>" have volumes:",True,False]
			];

			passingTest=If[Length[nullVolInvalidInputs]==Length[mySamples],
				Nothing,
				Test["The input sample(s) "<>ObjectToString[Complement[mySamples,nullVolInvalidInputs],Simulation->updatedSimulation]<>" have volumes:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(*get a boolean for which samples are low volume*)
	lowVolumeBool=Map[
		If[NullQ[#],False,MatchQ[Lookup[#,Volume],LessP[50 Microliter]]] &,
		samplePackets];


	(* Get the samples from mySamples that have volumes which are too low. *)
	tooLowVolPackets=PickList[samplePackets,lowVolumeBool,True];

	(* Set tooLowVolInvalidInputs to the input objects whose volume is null *)
	(* NOTE: We permit silencing this error if we're in a subprotocol as ExperimentMeasureDensity will exclude these samples from the measurement automatically *)
	(*       We must still throw an error if we're not in a sub protocol however as we need the user to know we can measure volume of the null volume samples *)
	tooLowVolInvalidInputs=If[MatchQ[tooLowVolPackets,{}],
		{},
		Lookup[tooLowVolPackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[
		And[
			Length[tooLowVolInvalidInputs]>0,
			!gatherTests,
			NullQ[parentProtocol]
		],

		Message[Error::MeasureDensityVolumeTooLow, tooLowVolInvalidInputs]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooLowVolSampleTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[tooLowVolInvalidInputs]==0,
				Nothing,
				Test["The input sample(s) "<>ObjectToString[tooLowVolInvalidInputs,Simulation->updatedSimulation]<>" have at least 50 Microliter of volume:",True,False]
			];

			passingTest=If[Length[tooLowVolInvalidInputs]==Length[mySamples],
				Nothing,
				Test["The input sample(s) "<>ObjectToString[Complement[mySamples,tooLowVolInvalidInputs],Simulation->updatedSimulation]<>" have at least 50 Microliter of volume:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Get the samples from mySamples that have a transported temperature other than ambient. *)
	transportedAtTempObjects = Download[Cases[samplePackets,KeyValuePattern[TransportTemperature->TemperatureP]],Object];
	transportedAtTempPackets = Cases[samplePackets,KeyValuePattern[Object -> ObjectP[transportedAtTempObjects]]];

	(* Set transportedAtTempInvalidInputs to the input objects whose transport temperatures are not ambient *)
	(* NOTE: We permit silencing this error if we're in a subprotocol as ExperimentMeasureDensity will exclude these samples from the measurement automatically *)
	(*       We must still throw an error if we're not in a sub protocol however as we need the user to know the samples will not be run at the transport temperature *)
	transportedAtTempInvalidInputs=If[MatchQ[transportedAtTempPackets,{}],
		{},
		Lookup[transportedAtTempPackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[
		And[
			Length[transportedAtTempInvalidInputs]>0,
			!gatherTests,
			NullQ[parentProtocol]
		],

		Message[Warning::AmbientTemperatureMeasurement, transportedAtTempInvalidInputs]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	transportedAtTempTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[transportedAtTempInvalidInputs]==0,
				Nothing,
				Warning["The input sample(s) "<>ObjectToString[transportedAtTempInvalidInputs,Simulation->updatedSimulation]<>" will be measured at their transport temperature:",True,False];
			];

			passingTest=If[Length[tooLowVolInvalidInputs]==Length[mySamples],
				Nothing,
				Warning["The input sample(s) "<>ObjectToString[Complement[mySamples,transportedAtTempInvalidInputs],Simulation->updatedSimulation]<>" will be measured at their transport temperature:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	(* Volume Option *)
	{roundedOps,precisionTests}=If[gatherTests,
		RoundOptionPrecision[measureDensityOptionsAssociation,{Volume, Temperature}, {1 Microliter, 10^-2 Celsius},Output->{Result,Tests}],
		{RoundOptionPrecision[measureDensityOptionsAssociation,{Volume, Temperature}, {1 Microliter, 10^-2 Celsius}],Null}
];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Resolve ImageSample *)
	imageSample = Which[
		(* If we're in a subprotocol, Automatic -> False *)
		And[
			MatchQ[Lookup[measureDensityOptionsAssociation,ImageSample],Automatic],
			!NullQ[parentProtocol]
		],
			False,

		(* If we're not in a subprotocol, Automatic -> True *)
		And[
			MatchQ[Lookup[measureDensityOptionsAssociation,ImageSample],Automatic],
			NullQ[parentProtocol]
		],
			True,

		(* Otherwise, do whatever we were told *)
		True,
			Lookup[measureDensityOptionsAssociation,ImageSample]
	];

	(* MapThread-ify my options such that we can investigate each option value corresponding to the sample we're resolving around *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentMeasureDensity,roundedOps];

	(* MapThread over each of our samples. *)
	{
		recoupSampleOps,
		insufficientVolumeErrors,
		invalidWashSolutionErrors,
		invalidSecondaryWashSolutionErrors,
		invalidTertiaryWashSolutionErrors,
		invalidWashVolumeErrors,
		invalidWashCyclesErrors,
		invalidTemperatureErrors,
		invalidViscosityCorrectionErrors,
		incompatibleInstrumentErrors,
		incompatibleVolumeErrors,
		methodVentilatedErrors,
		instrumentVentilatedErrors,
		measurementMethods,
		measurementTemperatures,
		instruments,
		viscosityCorrections,
		firstWashSolutions,
		secondaryWashSolutions,
		tertiaryWashSolutions,
		washCycles,
		washVolumes,
		measurementVolumes,
		invalidAirWaterCheckErrors,
		airWaterChecks
	}=Transpose[
		MapThread[
			Function[{mySample,myMapThreadOptions},
				Module[{ventilatedSamp,recoupSample,measurementVolume,insufficientVolumeError,invalidWashSolutionError,invalidSecondaryWashSolutionError,invalidTertiaryWashSolutionError,invalidWashVolumeError,invalidWashCyclesError,invalidViscosityCorrectionError,
					invalidTemperatureError,incompatibleInstrumentError,incompatibleVolumeError,unResolvedMeasurementVolume,sampleVol,numberOfReplicates,methodVentilatedError,instrumentVentilatedError,
					viscosityCorrection,unResolvedMethod,resolvedMethod, microBalanceSpecifiedQ, measurementTemperature,
					unResolvedInstrument,resolvedInstrument,firstWashSolution,secondaryWashSolution, tertiaryWashSolution,
					washCycle,washVolume, invalidAirWaterCheckError, airWaterCheck},

					(* Setup our error tracking variables *)
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{insufficientVolumeError}=ConstantArray[False,1];
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{invalidWashSolutionError}=ConstantArray[False,1];
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{invalidSecondaryWashSolutionError}=ConstantArray[False,1];
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{invalidTertiaryWashSolutionError}=ConstantArray[False,1];
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{invalidWashVolumeError}=ConstantArray[False,1];
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{invalidWashCyclesError}=ConstantArray[False,1];
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{invalidTemperatureError}=ConstantArray[False,1];
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{invalidViscosityCorrectionError}=ConstantArray[False,1];
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{incompatibleInstrumentError}=ConstantArray[False,1];
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{incompatibleVolumeError}=ConstantArray[False,1];
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{methodVentilatedError}=ConstantArray[False,1];
					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{instrumentVentilatedError}=ConstantArray[False,1];

					(* Set to a constant array of False to conserve functionality between resolvers in case options and errors expand here *)
					{invalidAirWaterCheckError}=ConstantArray[False,1];

					(*MASTER SWITCH RESOLUTION: Resolve which measurement method to use for the experiment*)

					(* Stash whether this sample must be ventilated *)
					ventilatedSamp = TrueQ[Lookup[mySample,Ventilated,Null]];

					(*Stash the method if the user provided one*)
					unResolvedMethod=Lookup[myMapThreadOptions,Method];

					(*Stash the instrument if the user provided one*)
					unResolvedInstrument=Lookup[myMapThreadOptions,Instrument];

					(* Stash what Volume for this sample is pre-resolution *)
					unResolvedMeasurementVolume = Lookup[myMapThreadOptions,Volume];

					(*Stash the number of replicates*)
					numberOfReplicates=Lookup[myMapThreadOptions,NumberOfReplicates];

					(* Stash the sample's volume *)
					sampleVol = Lookup[mySample,Volume]/.Null->0 Milliliter;

					(* determine if a micro balance was specified so I don't have to hard code what balances I'm checking against *)
					microBalanceSpecifiedQ = Switch[unResolvedInstrument,
						ObjectP[Model[Instrument]], MatchQ[fastAssocLookup[fastAssoc, unResolvedInstrument, Mode], Micro],
						ObjectP[Object[Instrument]], MatchQ[fastAssocLookup[fastAssoc, unResolvedInstrument, {Model, Mode}], Micro],
						_, False
					];

					(*Resolve measurement method*)
					resolvedMethod=Which[

						(*If the user requested Method->DensityMeter but the sample is Ventilated, use that method but throw an error *)
						MatchQ[unResolvedMethod,DensityMeter]&&TrueQ[ventilatedSamp], methodVentilatedError=True; unResolvedMethod,

						(*If the user provided a measurement method, use that*)
						MatchQ[unResolvedMethod,Except[Automatic]],unResolvedMethod,

						(*Did the user specify an instrument?*)
						(*If it's a density meter, pick that as the method*)
						MatchQ[unResolvedInstrument,ObjectP[{Object[Instrument,DensityMeter],Model[Instrument,DensityMeter]}]],DensityMeter,
						(*If it's a balance, pick FixedVolumeWeight as the method*)
						MatchQ[unResolvedInstrument,ObjectP[{Object[Instrument,Balance],Model[Instrument,Balance]}]],FixedVolumeWeight,
						(*If it's automatic and a volume other than 2 Milliliter is specified, pick FixedVolumeWeight as the method*)
						MatchQ[unResolvedInstrument,Automatic]&&MatchQ[unResolvedMeasurementVolume,Except[Alternatives[Automatic,2 Milliliter]]],FixedVolumeWeight,
						(*If it's automatic and the sample is ventilated, use FixedVolumeWeight *)
						MatchQ[unResolvedInstrument,Automatic]&&TrueQ[ventilatedSamp],FixedVolumeWeight,
						(*If it's automatic and the volume is sufficient (>= 2 mL), pick DensityMeter as the method*)
						MatchQ[unResolvedInstrument,Automatic]&&GreaterEqualQ[sampleVol,2 Milliliter],DensityMeter,
						(*If it's automatic and the volume is NOT sufficient (<2 mL), pick FixedVolumeWeight as the method*)
						MatchQ[unResolvedInstrument,Automatic]&&LessQ[sampleVol,2 Milliliter],FixedVolumeWeight

					];

					(*Resolve instrument*)
					resolvedInstrument=Which[

						(* If the user provided an instrument that is a desnity meter, but the sample is ventilated, use DensityMeter but throw an error *)
						MatchQ[unResolvedInstrument,ObjectP[{Object[Instrument,DensityMeter],Model[Instrument,DensityMeter]}]]&&TrueQ[ventilatedSamp], instrumentVentilatedError=True; unResolvedInstrument,
						(*If the user provided an instrument that is a density meter, use that*)
						MatchQ[unResolvedInstrument,Except[Automatic]]&&MatchQ[resolvedMethod,DensityMeter]&&MatchQ[unResolvedInstrument,ObjectP[{Object[Instrument,DensityMeter],Model[Instrument,DensityMeter]}]],unResolvedInstrument,
						(*If the user provided an instrument that is a microbalance, use that*)
						MatchQ[unResolvedInstrument,Except[Automatic]]&&MatchQ[resolvedMethod,FixedVolumeWeight]&&microBalanceSpecifiedQ,unResolvedInstrument,
						(*If the user provided an instrument that is an incompatible balance, throw an error and return the model/object*)
						MatchQ[unResolvedInstrument,Except[Automatic]]&&MatchQ[resolvedMethod,FixedVolumeWeight]&&MatchQ[unResolvedInstrument,ObjectP[{Object[Instrument,Balance],Model[Instrument,Balance]}]],incompatibleInstrumentError=True;unResolvedInstrument,

						(*If the user did not provide an instrument, look at the method to pick the correct one*)
						MatchQ[unResolvedInstrument,Automatic]&&MatchQ[resolvedMethod,DensityMeter],Model[Instrument,DensityMeter,"id:P5ZnEjdbXEbE"],
						MatchQ[unResolvedInstrument,Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight],Model[Instrument,Balance,"id:54n6evKx08XN"]
					];

					(*Resolve temperature*)
					measurementTemperature=Which[
						(*If the user provided a temperature of Null and the method is DensityMeter, throw an error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,Temperature],Null]&&MatchQ[resolvedMethod,DensityMeter],invalidTemperatureError=True;Lookup[myMapThreadOptions,Temperature],
						(*If the user provided a temperature (other than Null) and the method is DensityMeter, use that*)
						MatchQ[Lookup[myMapThreadOptions,Temperature],Except[Alternatives[Automatic,Null]]]&&MatchQ[resolvedMethod,DensityMeter],Lookup[myMapThreadOptions,Temperature],
						(*If the user provided a temperature and the method is FixedVolumeWeight, throw an error and return the volume*)
						MatchQ[Lookup[myMapThreadOptions,Temperature],Except[Automatic]]&&MatchQ[resolvedMethod,FixedVolumeWeight],invalidTemperatureError=True;Lookup[myMapThreadOptions,Temperature],
						(*If the user did NOT provide a temperature, set to 20 C for density meter*)
						MatchQ[Lookup[myMapThreadOptions,Temperature],Automatic]&&MatchQ[resolvedMethod,DensityMeter],20.000 Celsius,
						(*If the user did NOT provide a temperature, set to Null for fixed volume weight*)
						MatchQ[Lookup[myMapThreadOptions,Temperature],Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight],Null
					];

					(*Resolve viscosityCorrection*)
					viscosityCorrection=Which[
						(*If the user specified whether to correct for viscosity as Null and the method is DensityMeter, throw an error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,ViscosityCorrection],Null]&&MatchQ[resolvedMethod,DensityMeter],invalidViscosityCorrectionError=True;Lookup[myMapThreadOptions,ViscosityCorrection],
						(*If the user specified whether to correct for viscosity (other than Null) and the method is DensityMeter, use whatever they picked*)
						MatchQ[Lookup[myMapThreadOptions,ViscosityCorrection],Except[Alternatives[Automatic,Null]]]&&MatchQ[resolvedMethod,DensityMeter],Lookup[myMapThreadOptions,ViscosityCorrection],
						(*If the user specified whether to correct for viscosity and the method is FixedVolumeWeight, throw an error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,ViscosityCorrection],Except[Automatic]]&&MatchQ[resolvedMethod,FixedVolumeWeight],invalidViscosityCorrectionError=True;Lookup[myMapThreadOptions,ViscosityCorrection],
						(*If the user did NOT specify viscosity correction, set to True for density meter*)
						MatchQ[Lookup[myMapThreadOptions,ViscosityCorrection],Automatic]&&MatchQ[resolvedMethod,DensityMeter],True,
						(*If the user did NOT specify viscosity correction, set to Null for fixed volume weight*)
						MatchQ[Lookup[myMapThreadOptions,ViscosityCorrection],Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight],Null
					];

					(*Resolve firstWashSolution*)
					firstWashSolution=Which[
						(*If the user provided a wash solution of Null and the method is DensityMeter, throw an error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,WashSolution],Null]&&MatchQ[resolvedMethod,DensityMeter],invalidWashSolutionError=True;Lookup[myMapThreadOptions,WashSolution],
						(*If the user provided a wash solution of water and the method is DensityMeter, use that*)
						MatchQ[Lookup[myMapThreadOptions,WashSolution],Water]&&MatchQ[resolvedMethod,DensityMeter],Model[Sample,"Milli-Q water"],
						(*If the user provided a wash solution of hexanes and the method is DensityMeter, use that*)
						MatchQ[Lookup[myMapThreadOptions,WashSolution],Hexanes]&&MatchQ[resolvedMethod,DensityMeter],Model[Sample,"Hexanes"],
						(*If the user provided a wash solution and the method is FixedVolumeWeight, throw an error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,WashSolution],Except[Automatic]]&&MatchQ[resolvedMethod,FixedVolumeWeight],invalidWashSolutionError=True;Lookup[myMapThreadOptions,WashSolution],
						(*If the user did NOT provide a wash solution, set to Milli-Q water for density meter*)
						MatchQ[Lookup[myMapThreadOptions,WashSolution],Automatic]&&MatchQ[resolvedMethod,DensityMeter],Model[Sample,"Milli-Q water"],
						(*If the user did NOT provide a wash solution, set to Null for fixed volume weight*)
						MatchQ[Lookup[myMapThreadOptions,WashSolution],Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight],Null
					];

					(*Resolve secondaryWashSolution*)
					secondaryWashSolution=Which[
						(*If the user provided a secondary wash solution of Null and the method is DensityMeter, throw an error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,SecondaryWashSolution],Null]&&MatchQ[resolvedMethod,DensityMeter],invalidSecondaryWashSolutionError=True;Lookup[myMapThreadOptions,SecondaryWashSolution],
						(*If the user provided a secondary wash solution of Ethanol and the method is DensityMeter, use that*)
						MatchQ[Lookup[myMapThreadOptions,SecondaryWashSolution],Ethanol]&&MatchQ[resolvedMethod,DensityMeter],Model[Sample,"Ethanol, Reagent Grade"],
						(*If the user provided a secondary wash solution Acetone and the method is DensityMeter, use that*)
						MatchQ[Lookup[myMapThreadOptions,SecondaryWashSolution],Acetone]&&MatchQ[resolvedMethod,DensityMeter],Model[Sample, "Acetone, Reagent Grade"],
						(*If the user provided a secondary wash solution and the method is FixedVolumeWeight, throw an error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,SecondaryWashSolution],Except[Automatic]]&&MatchQ[resolvedMethod,FixedVolumeWeight],invalidSecondaryWashSolutionError=True;Lookup[myMapThreadOptions,SecondaryWashSolution],
						(*If the user did NOT provide a secondary wash solution, set to 95% ethanol for density meter*)
						MatchQ[Lookup[myMapThreadOptions,SecondaryWashSolution],Automatic]&&MatchQ[resolvedMethod,DensityMeter],Model[Sample,"Ethanol, Reagent Grade"],
						(*If the user did NOT provide a secondary wash solution, set to Null for fixed volume weight*)
						MatchQ[Lookup[myMapThreadOptions,SecondaryWashSolution],Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight],Null
					];

					(*Resolve tertiaryWashSolution*)
					tertiaryWashSolution=Which[
						(*If the user provided a secondary wash solution of Ethanol and the method is DensityMeter, use that*)
						MatchQ[Lookup[myMapThreadOptions,TertiaryWashSolution],Ethanol]&&MatchQ[resolvedMethod,DensityMeter],Model[Sample,"Ethanol, Reagent Grade"],
						(*If the user provided a secondary wash solution Acetone and the method is DensityMeter, use that*)
						MatchQ[Lookup[myMapThreadOptions,TertiaryWashSolution],Acetone]&&MatchQ[resolvedMethod,DensityMeter],Model[Sample, "Acetone, Reagent Grade"],
						(*If the user provided a secondary wash solution and the method is FixedVolumeWeight, throw an error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,TertiaryWashSolution],Except[Automatic|Null]]&&MatchQ[resolvedMethod,FixedVolumeWeight],invalidTertiaryWashSolutionError=True;Lookup[myMapThreadOptions,TertiaryWashSolution],
						(*If the user did NOT provide a secondary wash solution, set to 95% ethanol for density meter*)
						MatchQ[Lookup[myMapThreadOptions,TertiaryWashSolution],Automatic]&&MatchQ[resolvedMethod,DensityMeter],Model[Sample,"Acetone, Reagent Grade"],
						(*If the user did NOT provide a secondary wash solution, set to Null for fixed volume weight*)
						MatchQ[Lookup[myMapThreadOptions,TertiaryWashSolution],Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight],Null
					];

					(*Resolve washCycles*)
					washCycle=Which[
						(*If the user provided a number of wash cycles as Null and the method is DensityMeter, throw an error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,WashCycles],Null]&&MatchQ[resolvedMethod,DensityMeter],invalidWashCyclesError=True;Lookup[myMapThreadOptions,WashCycles],
						(*If the user provided a number of wash cycles (other than Null) and the method is DensityMeter, use that*)
						MatchQ[Lookup[myMapThreadOptions,WashCycles],Except[Alternatives[Automatic,Null]]]&&MatchQ[resolvedMethod,DensityMeter],Lookup[myMapThreadOptions,WashCycles],
						(*If the user provided a number of wash cycles and the method is FixedVolumeWeight, throw an error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,WashCycles],Except[Automatic]]&&MatchQ[resolvedMethod,FixedVolumeWeight],invalidWashCyclesError=True;Lookup[myMapThreadOptions,WashCycles],
						(*If the user did NOT provide a number of wash cycles, set to 1 for density meter*)
						MatchQ[Lookup[myMapThreadOptions,WashCycles],Automatic]&&MatchQ[resolvedMethod,DensityMeter],1,
						(*If the user did NOT provide a number of wash cycles, set to Null for fixed volume weight*)
						MatchQ[Lookup[myMapThreadOptions,WashCycles],Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight],Null
					];

					(*Resolve washVolume*)
					washVolume=Which[
						(*If the user provided a wash volume of Null and the method is DensityMeter, throw an error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,WashVolume],Null]&&MatchQ[resolvedMethod,DensityMeter],invalidWashVolumeError=True;Lookup[myMapThreadOptions,WashVolume],
						(*If the user provided a wash volume (other than Null) and the method is DensityMeter, use that*)
						MatchQ[Lookup[myMapThreadOptions,WashVolume],Except[Alternatives[Automatic,Null]]]&&MatchQ[resolvedMethod,DensityMeter],Lookup[myMapThreadOptions,WashVolume],
						(*If the user provided a wash volume and the method is FixedVolumeWeight, throw and error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,WashVolume],Except[Automatic]]&&MatchQ[resolvedMethod,FixedVolumeWeight],invalidWashVolumeError=True;Lookup[myMapThreadOptions,WashVolume],
						(*If the user did NOT provide a wash volume, set to 10 mL for density meter*)
						MatchQ[Lookup[myMapThreadOptions,WashVolume],Automatic]&&MatchQ[resolvedMethod,DensityMeter],10 Milliliter,
						(*If the user did NOT provide a wash volume, set to Null for fixed volume weight*)
						MatchQ[Lookup[myMapThreadOptions,WashVolume],Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight],Null
					];

					(*Resolve AirWaterCheck*)
					airWaterCheck = Which[

						(*If the user provided AirWaterCheck and the method is DensityMeter, use that*)
						MatchQ[Lookup[myMapThreadOptions,AirWaterCheck],Except[Alternatives[Automatic,Null]]]&&MatchQ[resolvedMethod,DensityMeter],Lookup[myMapThreadOptions,AirWaterCheck],

						(*If the user provided AirWaterCheck and the method is FixedVolumeWeight, throw and error and return the value*)
						MatchQ[Lookup[myMapThreadOptions,AirWaterCheck],True]&&MatchQ[resolvedMethod,FixedVolumeWeight],invalidAirWaterCheckError=True;Lookup[myMapThreadOptions,AirWaterCheck],

						(*If the user did NOT provide AirWaterCheck, set to False for density meter*)
						MatchQ[Lookup[myMapThreadOptions,AirWaterCheck],Automatic]&&MatchQ[resolvedMethod,DensityMeter],False,

						(*If the user did NOT provide AirWaterCheck, set to Null for fixed volume weight*)
						MatchQ[Lookup[myMapThreadOptions,AirWaterCheck],Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight],Null
					];

					(* Resolve recoupSample *)
					recoupSample=Which[
						(*If the user specified recoup sample, use whatever they picked*)
						MatchQ[Lookup[myMapThreadOptions,RecoupSample],Except[Automatic]],Lookup[myMapThreadOptions,RecoupSample],

						(*If the user did NOT specify anything for recoup sample, choose based on the method and total volume of the sample*)

						(*If recoup sample is automatic, the method is density meter, and the total sample volume is >=5 Milliliter, set to false*)
						MatchQ[Lookup[myMapThreadOptions,RecoupSample],Automatic]&&MatchQ[resolvedMethod,DensityMeter]&&GreaterEqualQ[sampleVol,5 Milliliter],False,
						(*If recoup sample is automatic, the method is density meter, and the total sample volume is <5 Milliliter, set to True*)
						MatchQ[Lookup[myMapThreadOptions,RecoupSample],Automatic]&&MatchQ[resolvedMethod,DensityMeter]&&LessQ[sampleVol,5 Milliliter],True,

						(*If recoup sample is automatic, the method is fixed volume weight, and the total sample volume is >=5 Milliliter, set to false*)
						MatchQ[Lookup[myMapThreadOptions,RecoupSample],Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight]&&GreaterEqualQ[sampleVol,5 Milliliter],False,
						(*If recoup sample is automatic, the method is fixed volume weight, and the total sample volume is <5 Milliliter, set to True*)
						MatchQ[Lookup[myMapThreadOptions,RecoupSample],Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight]&&LessQ[sampleVol,5 Milliliter],True
					];

					(* Resolve measurementVolume *)
					measurementVolume=Which[

						(*If the user provided a measurement volume, check if an insufficientvolumeerror needs to be thrown and return the volume*)

						(*User provided volume resolution*)
						(*If the user provided a measurement volume that is greater than the sample volume with recoupsample set to true, throw an error and return the volume*)
						MatchQ[unResolvedMeasurementVolume,Except[Automatic]]&&TrueQ[recoupSample]&&GreaterQ[unResolvedMeasurementVolume,sampleVol],insufficientVolumeError=True;unResolvedMeasurementVolume,
						(*If the method is density meter, and the sample volume is not 2 mL, throw an error and return the volume*)
						MatchQ[unResolvedMeasurementVolume,Except[Automatic]]&&MatchQ[resolvedMethod,DensityMeter]&&!MatchQ[unResolvedMeasurementVolume,2 Milliliter],incompatibleVolumeError=True;unResolvedMeasurementVolume,
						(*If the user provided a measurement volume that is greater than (sample volume/number of replicates) with recoupsample set to false, throw an error and return the volume*)
						MatchQ[unResolvedMeasurementVolume,Except[Automatic]]&&!TrueQ[recoupSample]&&GreaterQ[unResolvedMeasurementVolume,(sampleVol/numberOfReplicates)],insufficientVolumeError=True;unResolvedMeasurementVolume,
						(*If the user provided a measurement volume that is less than the sample volume with recoupsample set to true, return the volume*)
						MatchQ[unResolvedMeasurementVolume,Except[Automatic]]&&TrueQ[recoupSample]&&LessEqualQ[unResolvedMeasurementVolume,sampleVol],unResolvedMeasurementVolume,
						(*If the user provided a measurement volume that is less than the (sample volume/number of replicates) with recoupsample set to false, return the volume*)
						MatchQ[unResolvedMeasurementVolume,Except[Automatic]]&&!TrueQ[recoupSample]&&LessEqualQ[unResolvedMeasurementVolume,(sampleVol/numberOfReplicates)],unResolvedMeasurementVolume,


						(*If the user did NOT provide a measurement volume (or picked automatic), check which method is being used to determine the volume*)
						(*Automatic volume resolution*)

						(*For density meter*)
						(*If the method is density meter, recoup sample is true, and the sample volume is >2 mL, set the volume to 2 mL*)
						MatchQ[unResolvedMeasurementVolume,Automatic]&&MatchQ[resolvedMethod,DensityMeter]&&TrueQ[recoupSample]&&GreaterEqualQ[sampleVol,2 Milliliter],2 Milliliter,
						(*If the method is density meter, recoup sample is false, and the (sample volume/number of replicates) is >2 mL, set the volume to 2 mL*)
						MatchQ[unResolvedMeasurementVolume,Automatic]&&MatchQ[resolvedMethod,DensityMeter]&&!TrueQ[recoupSample]&&GreaterEqualQ[(sampleVol/numberOfReplicates),2 Milliliter],2 Milliliter,
						(*If the method is density meter, recoup sample is true, and the sample volume is <2 mL, throw an error and set the volume to 2 mL*)
						MatchQ[unResolvedMeasurementVolume,Automatic]&&MatchQ[resolvedMethod,DensityMeter]&&TrueQ[recoupSample]&&LessQ[sampleVol,2 Milliliter],insufficientVolumeError=True;2 Milliliter,
						(*If the method is density meter, recoup sample is false, and the (sample volume/number of replicates) is <2 mL, throw an error and set the volume to 2 mL*)
						MatchQ[unResolvedMeasurementVolume,Automatic]&&MatchQ[resolvedMethod,DensityMeter]&&!TrueQ[recoupSample]&&LessQ[(sampleVol/numberOfReplicates),2 Milliliter],insufficientVolumeError=True;2 Milliliter,

						(*For fixed volume weight*)
						(*If the method is fixed volume weight and recoup sample is true, set the volume to the least of 800 uL and (0.9*sample volume) *)
						MatchQ[unResolvedMeasurementVolume,Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight]&&TrueQ[recoupSample],Min[800 Microliter,Round[Convert[0.9*sampleVol,Microliter],1]],
						(*If the method is fixed volume weight and recoup sample is false, set the volume to the least of 800 uL and (0.9*sample volume/number of replicates) *)
						MatchQ[unResolvedMeasurementVolume,Automatic]&&MatchQ[resolvedMethod,FixedVolumeWeight]&&!TrueQ[recoupSample],Min[800 Microliter,Round[Convert[0.9*(sampleVol/numberOfReplicates),Microliter],1]]

					];

					(* Gather MapThread results *)
					{
						recoupSample,
						insufficientVolumeError,
						invalidWashSolutionError,
						invalidSecondaryWashSolutionError,
						invalidTertiaryWashSolutionError,
						invalidWashVolumeError,
						invalidWashCyclesError,
						invalidTemperatureError,
						invalidViscosityCorrectionError,
						incompatibleInstrumentError,
						incompatibleVolumeError,
						methodVentilatedError,
						instrumentVentilatedError,
						resolvedMethod,
						measurementTemperature,
						resolvedInstrument,
						viscosityCorrection,
						firstWashSolution,
						secondaryWashSolution,
						tertiaryWashSolution,
						washCycle,
						washVolume,
						measurementVolume,
						invalidAirWaterCheckError,
						airWaterCheck
					}
				]
			],
			{samplePackets,mapThreadFriendlyOptions}
		]
	];

	(* Unmeasurable sample error check *)
	insufficientVolumeInvalidOptions=If[Or@@insufficientVolumeErrors&&!gatherTests,
		Module[{invalidSamples},
		(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,insufficientVolumeErrors];

			(* Throw the corresponding error. *)
			Message[Error::MeasureDensityInsufficientVolume,ObjectToString[invalidSamples,Simulation->updatedSimulation],ToString[Download[invalidSamples,Volume, Simulation->updatedSimulation]]];

			(* Return our invalid options. *)
			{Volume}
		],
		{}
	];

	(* Create the corresponding test for the unmeasurable container error. *)
	insufficientVolumeTests=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,insufficientVolumeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", have enough volume for the specified Volume of :",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have enough volume for the specified Volume of :",True,True],
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

	(* Invalid wash solution options error check *)
	invalidWashSolutionOptions=If[Or@@invalidWashSolutionErrors&&!gatherTests,
		Module[{invalidSamples,invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,invalidWashSolutionErrors];
			invalidOptions=invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::InvalidWashSolution,ObjectToString[invalidSamples,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{WashSolution}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	invalidWashSolutionTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,invalidWashSolutionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,True],
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

	(* Stash invalid Ventilated samples as they pertain to the Instrument and Method options *)
	invalidVentilatedInstrumentSamps = PickList[simulatedSamples,instrumentVentilatedErrors];
	invalidVentilatedMethodSamps = PickList[simulatedSamples,methodVentilatedErrors];
	(* Invalid Method and Instrument Ventilated Sample check *)
	invalidVentilatedOptions = If[MatchQ[Join[invalidVentilatedInstrumentSamps,invalidVentilatedMethodSamps],{ObjectP[]..}]&&!gatherTests,
		Module[{combinedInvalidOps},

			combinedInvalidOps = DeleteDuplicates@Join[invalidVentilatedInstrumentSamps,invalidVentilatedMethodSamps];

			(* Throw the corresponding error. *)
			Message[Error::MeasureDensityVentilatedSamples,ObjectToString[combinedInvalidOps,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{
				(* If Instrument was specified in an invalid way, add Instrument to invalid options *)
				If[Length[invalidVentilatedInstrumentSamps]>0,Instrument,Nothing],

				(* If Instrument was specified in an invalid way, add Instrument to invalid options *)
				If[Length[invalidVentilatedMethodSamps]>0,Method,Nothing]
			}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	invalidVentilatedInstrumentTests=If[gatherTests&&Length[ventilatedSamples]>0,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputTest},

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[ventilatedSamples,invalidVentilatedInstrumentSamps];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[invalidVentilatedInstrumentSamps]>0,
				Test["The following samples, "<>ObjectToString[invalidVentilatedInstrumentSamps,Simulation->updatedSimulation]<>", have a ventilated instrument compatible their sample handling requirements:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have a ventilated instrument compatible their sample handling requirements:",True,True],
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
	(* Create the corresponding test for the invalid options. *)
	invalidVentilatedMethodTests=If[gatherTests&&Length[ventilatedSamples]>0,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputTest},

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[ventilatedSamples,invalidVentilatedMethodSamps];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[invalidVentilatedMethodSamps]>0,
				Test["The following samples, "<>ObjectToString[invalidVentilatedMethodSamps,Simulation->updatedSimulation]<>", have a measurement method compatible their sample handling requirements:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have a measurement method compatible their sample handling requirements:",True,True],
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


	(* Invalid secondary wash solution options error check *)
	invalidSecondaryWashSolutionOptions=If[Or@@invalidSecondaryWashSolutionErrors&&!gatherTests,
		Module[{invalidSamples,invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,invalidSecondaryWashSolutionErrors];
			invalidOptions=invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::InvalidSecondaryWashSolution,ObjectToString[invalidSamples,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{SecondaryWashSolution}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	invalidSecondaryWashSolutionTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,invalidSecondaryWashSolutionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,True],
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

	(* Invalid secondary wash solution options error check *)
	invalidTertiaryWashSolutionOptions=If[Or@@invalidTertiaryWashSolutionErrors&&!gatherTests,
		Module[{invalidSamples,invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,invalidTertiaryWashSolutionErrors];
			invalidOptions=invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::InvalidTertiaryWashSolution,ObjectToString[invalidSamples,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{TertiaryWashSolution}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	invalidTertiaryWashSolutionTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,invalidTertiaryWashSolutionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,True],
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

	(* Invalid wash volume options error check *)
	invalidWashVolumeOptions=If[Or@@invalidWashVolumeErrors&&!gatherTests,
		Module[{invalidSamples,invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,invalidWashVolumeErrors];
			invalidOptions=invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::InvalidWashVolume,ObjectToString[invalidSamples,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{WashVolume}
		],
		{}
	];

	(* Create the corresponding test for the invalid options. *)
	invalidWashVolumeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,invalidWashVolumeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,True],
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

	(* Invalid AirWaterCheck options error check *)
	invalidAirWaterCheckOptions=If[Or@@invalidAirWaterCheckErrors&&!gatherTests,
		Module[{invalidSamples,invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,invalidAirWaterCheckErrors];
			invalidOptions=invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::InvalidAirWaterCheck,ObjectToString[invalidSamples,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{AirWaterCheck}
		],
		{}
	];

	(* Create the corresponding test for the invalid options. *)
	invalidAirWaterCheckTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,invalidAirWaterCheckErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", have AirWaterCheck option compatible with the method selected",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have AirWaterCheck option compatible with the method selected",True,True],
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

	(* Invalid wash cycles options error check *)
	invalidWashCyclesOptions=If[Or@@invalidWashCyclesErrors&&!gatherTests,
		Module[{invalidSamples,invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,invalidWashCyclesErrors];
			invalidOptions=invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::InvalidWashCycles,ObjectToString[invalidSamples,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{WashCycles}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	invalidWashCyclesTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,invalidWashCyclesErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,True],
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
	(* Invalid temperature options error check *)
	invalidTemperatureOptions=If[Or@@invalidTemperatureErrors&&!gatherTests,
		Module[{invalidSamples,invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,invalidTemperatureErrors];
			invalidOptions=invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::InvalidTemperature,ObjectToString[invalidSamples,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{Temperature}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	invalidTemperatureTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,invalidTemperatureErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,True],
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
	(* Invalid viscosity correction options error check *)
	invalidViscosityCorrectionOptions=If[Or@@invalidViscosityCorrectionErrors&&!gatherTests,
		Module[{invalidSamples,invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,invalidViscosityCorrectionErrors];
			invalidOptions=invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::InvalidViscosityCorrection,ObjectToString[invalidSamples,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{ViscosityCorrection}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	invalidViscosityCorrectionTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,invalidViscosityCorrectionErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,True],
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
	(* Incompatible instrument options error check *)
	incompatibleInstrumentOptions=If[Or@@incompatibleInstrumentErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,incompatibleInstrumentErrors];

			(* Throw the corresponding error. *)
			Message[Error::MeasureDensityIncompatibleInstrument,ObjectToString[invalidSamples,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{Instrument}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	incompatibleInstrumentTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,incompatibleInstrumentErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,True],
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
	(* Incompatible volume options error check *)
	incompatibleVolumeOptions=If[Or@@incompatibleVolumeErrors&&!gatherTests,
		Module[{invalidSamples,invalidOptions},
			(* Get the samples that correspond to this error. *)
			invalidSamples=PickList[simulatedSamples,incompatibleVolumeErrors];
			invalidOptions=invalidSamples;

			(* Throw the corresponding error. *)
			Message[Error::MeasureDensityIncompatibleVolume,ObjectToString[invalidSamples,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{Volume}
		],
		{}
	];
	(* Create the corresponding test for the invalid options. *)
	incompatibleVolumeTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,incompatibleVolumeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", have selected options compatible with the method selected",True,True],
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


	(* Determine how much volume the protocol will require. This ONLY applies if MeasureDensity -> True and RecoupSample -> False *)
	requiredAliquotAmounts = MapThread[
		Function[
			{reocoupSample,measurementVol},
			If[
				!TrueQ[reocoupSample],
				measurementVol * numReplicates,
				Null
			]
		],
		{recoupSampleOps,measurementVolumes}
	];

	(* Resolve our aliquot options. *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentMeasureDensity,
			mySamples,
			simulatedSamples,
			ReplaceRule[myUnresolvedOptions, resolvedSamplePrepOptions],
			Simulation->updatedSimulation,
			Cache->cache,
			RequiredAliquotAmounts -> requiredAliquotAmounts,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentMeasureDensity,
				mySamples,
				simulatedSamples,
				ReplaceRule[myUnresolvedOptions, resolvedSamplePrepOptions],
				Simulation->updatedSimulation,
				Cache->cache,
				RequiredAliquotAmounts -> requiredAliquotAmounts,
				Output->Result
			],
			{}
		}
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,solidInvalidInputs,nullVolInvalidInputs,tooLowVolInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{insufficientVolumeInvalidOptions,invalidWashSolutionOptions,invalidSecondaryWashSolutionOptions,invalidTertiaryWashSolutionOptions,invalidWashVolumeOptions,invalidWashCyclesOptions,
		invalidTemperatureOptions,invalidViscosityCorrectionOptions,incompatibleInstrumentOptions,incompatibleVolumeOptions,invalidVentilatedOptions,invalidAirWaterCheckOptions}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,invalidInputs]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* Generate a flat list of all tests generated above *)
	allTests=Flatten[{discardedTests,solidSampleTests,nullVolSampleTests,tooLowVolSampleTests,precisionTests,invalidWashSolutionTests,invalidSecondaryWashSolutionTests,invalidTertiaryWashSolutionTests,invalidWashVolumeTests,invalidWashCyclesTests,
		invalidTemperatureTests,invalidViscosityCorrectionTests,incompatibleInstrumentTests,incompatibleVolumeTests,invalidVentilatedInstrumentTests,invalidVentilatedMethodTests,invalidAirWaterCheckTests}];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myUnresolvedOptions];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> Join[
			resolvedSamplePrepOptions,
			{
				Volume -> measurementVolumes,
				NumberOfReplicates -> numReplicates,
				RecoupSample -> recoupSampleOps,
				Method-> measurementMethods,
				Temperature-> measurementTemperatures,
				Instrument-> instruments,
				ViscosityCorrection-> viscosityCorrections,
				WashSolution->firstWashSolutions,
				SecondaryWashSolution->secondaryWashSolutions,
				TertiaryWashSolution->tertiaryWashSolutions,
				WashCycles->washCycles,
				WashVolume->washVolumes,
				AirWaterCheck -> airWaterChecks
			},
			resolvedAliquotOptions,
			{
				ParentProtocol -> Lookup[myUnresolvedOptions,ParentProtocol],
				Upload -> Lookup[myUnresolvedOptions,Upload],
				Confirm -> Lookup[myUnresolvedOptions,Confirm],
				CanaryBranch -> Lookup[myUnresolvedOptions,CanaryBranch],
				Template -> Lookup[myUnresolvedOptions,Template],
				PreparatoryUnitOperations->Lookup[myUnresolvedOptions,PreparatoryUnitOperations],
				Name -> Lookup[myUnresolvedOptions,Name],
				ImageSample -> imageSample,
				MeasureWeight -> Lookup[resolvedPostProcessingOptions,MeasureWeight],
				MeasureVolume -> Lookup[resolvedPostProcessingOptions,MeasureVolume],
				SamplesInStorageCondition->Lookup[myUnresolvedOptions,SamplesInStorageCondition]
			}
		],

		Tests -> Flatten[{
			discardedTests,
			solidSampleTests,
			invalidWashSolutionTests,
			invalidSecondaryWashSolutionTests,
			invalidTertiaryWashSolutionTests,
			invalidWashVolumeTests,
			invalidWashCyclesTests,
			invalidTemperatureTests,
			invalidViscosityCorrectionTests,
			incompatibleInstrumentTests,
			incompatibleVolumeTests,
			nullVolSampleTests,
			tooLowVolSampleTests,
			transportedAtTempTests,
			precisionTests,
			insufficientVolumeTests,
			compatibleMaterialsTests
		}]
	}
];

DefineOptions[
	measureDensityResourcePackets,
	Options :>{
		CacheOption,
		OutputOption,
		SimulationOption
	}
];

measureDensityResourcePackets[mySamples:{PacketP[Object[Sample]]..},myResolvedOptions:{_Rule..},myUnresolvedOptions:Alternatives[{_Rule..},{}],myOptions:OptionsPattern[]] := Module[
	{
		safeOps,outputSpecification,output,gatherTests,inheritedCache,parentProtocol,resolvedOptionsNoHidden,
		simulatedSampObjects,simulatedSamps,updatedSimulation,bigPipetteModel,smallPipetteModel,bigTipModel,smallTipModel,
		allPossibleTips,modelContainerFVWPacks,listedTipPackets,tipPackets,fullCache,numberOfReplicates,myExpandedSimulatedSamples,myExpandedOptions,
		myExpandedFVWSamples,myExpandedSimulatedContainerFVWModels,samplesInResources,measurementContainerResources,expandedSamplesInResources,
		myExpandedDensityMeterOptions,myExpandedFVWOptions,resolvedInstrument,resolvedBalance,resolvedDensityMeter,
		bigPipette,defaultPipetteModel,defaultTipModel,compatibleTipBools,
		resolvedPipettes,resolvedTips,tipResources,pipetteResources,protocolPacket,sharedFieldPacket,finalizedPacket,
		allResourceBlobs,fulfillable,frqTests,previewRule,optionsRule,testsRule,resultRule,
		densityMeterSampleSyringes,densityMeterSamples,densityMeterWashSyringes,
		densityMeterSecondaryWashSyringes,densityMeterTertiaryWashSyringes,batchedDensityMeterWashSyringes,
		batchedDensityMeterSecondaryWashSyringes,batchedDensityMeterTertiaryWashSyringes,
		fixedVolWeightSamples,fixedVolWeightSamplePositions,densityMeterSamplePositions,
		densityMeterSampleOptions,fixedVolWeightSampleOptions,myExpandedDensityMeterSamples,
		samplesInObjects,myExpandedSamples,samplesInFVWResources,densityMeterSampleNeedles,resortedSampleNeedleResources,
		samplesInDensityMeterResources,containersInObjects,
		firstWashSolutions,secondaryWashSolutions,tertiaryWashSolutions,batchedSamples,batchedSampleOptions,
		myExpandedBatchedSamples,myExpandedBatchedSampleOptions,batchedSamplesInResources,
		resortedMeasurementContainerResources,resortedSampleSyringeResources,
		batchedTipResources,resortedTipResources,resortedFirstWashSolutions,resortedSecondaryWashSolutions,resortedTertiaryWashSolutions,
		densityMeterSampleOptionsNoKeys,fixedVolWeightSampleOptionsNoKeys, preWashSolution,secondaryPreWashSolution,tertiaryPreWashSolution,
		airWaterCheckSolution,densityMeterWashSyringesLookup,densityMeterPreWashSyringes,densityMeterSecondaryPreWashSyringes,
		densityMeterTertiaryPreWashSyringes,densityMeterAirWaterCheckSyringe,simulation
	},

	(* Stash safe options *)
	safeOps = SafeOptions[measureDensityResourcePackets,ToList[myOptions]];

	(* Determine the requested output format of this function. *)
	outputSpecification = Lookup[safeOps,Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];

	(* get the cache that was passed from the main function *)
	inheritedCache = Lookup[safeOps,Cache,{}];
	simulation=Lookup[safeOps,Simulation];

	(* Store the ParentProtocol of the protocol being created *)
	parentProtocol = Lookup[myResolvedOptions,ParentProtocol];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentMeasureDensity,
		RemoveHiddenOptions[ExperimentMeasureDensity, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Regenerate the simulations done in the option resolver *)
	{simulatedSampObjects,updatedSimulation}=simulateSamplesResourcePacketsNew[ExperimentMeasureDensity,mySamples,myResolvedOptions,Cache->inheritedCache,Simulation->simulation];

	(* Pull the sample packets from the simulated cache *)
	simulatedSamps = Flatten@Quiet[Download[
		simulatedSampObjects,
		{Packet[Name, Container, State, StorageCondition, Well, Density, DensityLog, RequestedResources, Notebook,
			(*Transport and fume hood info previously from model*)
			TransportTemperature, Ventilated, IncompatibleMaterials]},
		Cache -> inheritedCache,
		Simulation -> updatedSimulation
	],{Download::FieldDoesntExist}];

	(*Batching calculations based on DensityMeter or FixedVolumeWeight method*)
	(*Separate the samples to be measured with the density meter from those measured by the fixed volume weight method,
	so each set of samples can be measured all at once on the same instrument without going back and forth for each sample*)

	(*Find the index positions of each sample with the densitymeter method*)
	densityMeterSamplePositions=Position[
		Lookup[myResolvedOptions,Method],
		DensityMeter
	];
	(*Find the index positions of each sample with the fixedvolumeweight method*)
	fixedVolWeightSamplePositions=Position[
		Lookup[myResolvedOptions,Method],
		FixedVolumeWeight
	];

	(*Extract all samples with the densitymeter method*)
	densityMeterSamples=Extract[
		simulatedSamps,
		densityMeterSamplePositions
	];
	(*Extract all samples with the fixedvolumeweight method*)
	fixedVolWeightSamples=Extract[
		simulatedSamps,
		fixedVolWeightSamplePositions
	];

	(*Extract all options for densitymeter samples*)
	(*First get all the index-matched options in order*)
	densityMeterSampleOptionsNoKeys=If[MatchQ[densityMeterSamplePositions,{}],
		(*To preserve threading capability, give a list of empty lists matching the number of options if no density meter samples are present*)
		Repeat[{},12],
		Partition[Flatten[
			Map[
				Function[{optionValues}, Extract[optionValues, densityMeterSamplePositions]],
				Lookup[myResolvedOptions, {Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck}]
			]],
			Length[densityMeterSamplePositions]
		]
	];
	(*Now recombine with the keys to form the correct list of options*)
	densityMeterSampleOptions=If[MatchQ[densityMeterSamplePositions,{}],
		(*To preserve threading capability, give a list of empty lists matching the number of options if no density meter samples are present*)
		Repeat[{},12],
		MapThread[
			Rule[#1,#2]&,
			{
				{Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck},
				densityMeterSampleOptionsNoKeys
			}
		]
	];

	(*Extract all options for fixedvolumeweight samples*)
	(*First get all the index-matched options in order*)
	fixedVolWeightSampleOptionsNoKeys=If[MatchQ[fixedVolWeightSamplePositions,{}],
		(*To preserve threading capability, give a list of empty lists matching the number of options if no FVW samples are present*)
		Repeat[{},12],
		Partition[Flatten[
			Map[
				Function[{optionValues}, Extract[optionValues, fixedVolWeightSamplePositions]],
				Lookup[myResolvedOptions, {Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck}]
			]],
			Length[fixedVolWeightSamplePositions]
		]
	];
	(*Now recombine with the keys to form the correct list of options*)
	fixedVolWeightSampleOptions=If[MatchQ[fixedVolWeightSamplePositions,{}],
		(*To preserve threading capability, give a list of empty lists matching the number of options if no FVW samples are present*)
		Repeat[{},12],
		MapThread[
			Rule[#1,#2]&,
			{
				{Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck},
				fixedVolWeightSampleOptionsNoKeys
			}
		]
	];

	(*Recombine the two re-ordered lists to give a single list of the batched samples for new batched index matching*)
	batchedSamples=Join[densityMeterSamples,fixedVolWeightSamples];
	(*Recombine the two re-ordered lists to give a single list of the batched sample options for new batched index matching*)
	batchedSampleOptions= MapThread[
		Rule[#1,#2]&,
		{
			{Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck},
			Join@@@Transpose[{densityMeterSampleOptionsNoKeys,fixedVolWeightSampleOptionsNoKeys}]
		}
	];

	(* Download the tip models *)
	(* These models are hardcoded because they are tips of positive displacement pipettes, which are
			the most accurate pipetting devices the ECL currently stocks*)
	{bigPipetteModel,smallPipetteModel,bigTipModel,smallTipModel} = {
		Model[Instrument,Pipette,"id:E8zoYvNe7LNv"],
		Model[Instrument,Pipette,"id:Y0lXejMGAmr1"],
		Model[Item,Tips,"id:WNa4ZjKROWBE"],
		Model[Item,Tips,"id:P5ZnEjd4eYJn"]
	};

	(* Download a list of potential pipette tips we could use *)
	allPossibleTips = Join[{bigTipModel,smallTipModel},TransferDevices[{Model[Item,Tips]},All][[All,1]]];

	(* Download the information of the model containers our samples are in *)
	{modelContainerFVWPacks,listedTipPackets}=Quiet[
		Download[
			{
				fixedVolWeightSamples,
				allPossibleTips
			},
			{
				(* Container Model Packets *)
				{Packet[Container[Model][{Aperture,InternalDepth,WellDimensions,WellDiameter,WellDepth}]]},
				(* Tip packets *)
				{Packet[AspirationDepth,Name,Dimensions,MinVolume,MaxVolume,Resolution,Reusable,Filtered,NumberOfTips]}
			},
			Cache->inheritedCache,
			Simulation->updatedSimulation
		],
		Download::FieldDoesntExist
	];

	tipPackets = Flatten[listedTipPackets,1];

	fullCache = Join[modelContainerFVWPacks,tipPackets];

	(* Get our NumberOfReplicates option. *)
	numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates,1]/.{Null->1};

	(* Expand our input samples and resolved options. *)
	myExpandedSamples=Flatten[(ConstantArray[#,numberOfReplicates]&)/@mySamples];
	myExpandedSimulatedSamples=Flatten[(ConstantArray[#,numberOfReplicates]&)/@simulatedSamps];
	myExpandedSimulatedContainerFVWModels=Flatten[(ConstantArray[#,numberOfReplicates]&)/@modelContainerFVWPacks];
	myExpandedOptions = MapThread[
		Rule[#1,
			Flatten[
				Map[
					Function[{optionVal},
						ConstantArray[optionVal, numberOfReplicates]
						],
					#2]
				]
		]&,
		{
			{Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck},
			Lookup[myResolvedOptions, {Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck}]
		}
	];

	myExpandedFVWSamples=Flatten[(ConstantArray[#,numberOfReplicates]&)/@fixedVolWeightSamples];
	myExpandedDensityMeterSamples=Flatten[(ConstantArray[#,numberOfReplicates]&)/@densityMeterSamples];
	myExpandedBatchedSamples=Flatten[(ConstantArray[#,numberOfReplicates]&)/@batchedSamples];
	myExpandedDensityMeterOptions=If[MatchQ[densityMeterSamples,{}],
		{},
		MapThread[
			Rule[
				#1,
				Flatten[
					Map[
						Function[{optionVal},ConstantArray[optionVal,numberOfReplicates]],
						#2
					]
				]
			]&,
			{
				{Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck},
				Lookup[densityMeterSampleOptions, {Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck}]
			}
		]
	];
	myExpandedFVWOptions= If[MatchQ[fixedVolWeightSamples,{}],
		{},
		MapThread[
			Rule[
				#1,
				Flatten[
					Map[
						Function[{optionVal},ConstantArray[optionVal,numberOfReplicates]],
						#2
					]
				]
			]&,
			{
				{Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck},
				Lookup[fixedVolWeightSampleOptions, {Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck}]
			}
		]
	];
	myExpandedBatchedSampleOptions=MapThread[
		Rule[
			#1,
			Flatten[
				Map[
					Function[{optionVal},ConstantArray[optionVal,numberOfReplicates]],
					#2
				]
			]
		]&,
		{
			{Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck},
			Lookup[batchedSampleOptions, {Method,Volume,RecoupSample,Temperature,ViscosityCorrection,WashSolution,SecondaryWashSolution,TertiaryWashSolution,WashCycles,WashVolume,Instrument,AirWaterCheck}]
		}
	];
	samplesInObjects= Download[mySamples,Object];
	containersInObjects = DeleteDuplicates@Download[Lookup[mySamples,Container],Object];

	resolvedInstrument=DeleteDuplicates[Lookup[myExpandedBatchedSampleOptions,Instrument]];
	resolvedBalance=Cases[resolvedInstrument,ObjectP[{Object[Instrument,Balance],Model[Instrument,Balance]}]];
	resolvedDensityMeter=Cases[resolvedInstrument,ObjectP[{Object[Instrument,DensityMeter],Model[Instrument,DensityMeter]}]];

	samplesInResources=Map[
		Link[Resource[Sample->#, Name->ToString[Unique[]]],Protocols]&,
		samplesInObjects
	];

	expandedSamplesInResources=Flatten[(ConstantArray[#,numberOfReplicates]&)/@samplesInResources];

	samplesInDensityMeterResources=Flatten[(ConstantArray[#,numberOfReplicates]&)/@Extract[samplesInResources,densityMeterSamplePositions]];
	samplesInFVWResources=Flatten[(ConstantArray[#,numberOfReplicates]&)/@Extract[samplesInResources,fixedVolWeightSamplePositions]];
	batchedSamplesInResources=Join[samplesInDensityMeterResources,samplesInFVWResources];

	measurementContainerResources=PadLeft[
		(Table[
			Link[Resource[Sample->Model[Container,Vessel,"id:3em6Zv9NjjN8"],Name->ToString[Unique[]]]],
			Length[samplesInFVWResources]
		]),
		Length[batchedSamplesInResources],
		Null
	];

	(*DensityMeter resources*)
	(*Need syringes for the samples (One 3mL syringe*numberOfDensityMeterSamples), syringes for washing (One per wash solution type), &
	wash solutions (with a volume of WashVolume*WashCycles*numberOfDensityMeterSamples for each)*)

	(*Sample syringes*)
	(*currently 3 mL disposable luerlock syringes, could replace with 2 mL disposable syringes in the future*)
	densityMeterSampleSyringes=PadRight[
		Table[
			Link[Resource[Sample->Model[Container, Syringe, "id:01G6nvkKrrKY"],Name->ToString[Unique[]]]],
			(*Need only one syringe per sample measured with the density meter, so look at how many samples are being measured with the densitymeter method*)
			Length[myExpandedDensityMeterSamples]
		],
		Length[myExpandedSamples],
		Null
	];

	(*Sample syringe needles*)
	(*currently reusuable stainless steel needles, could change to disposable ones in the future if washing ends up being time-intensive*)
	(*TODO:Possibly change to different longer needles using similar logic to pipette tip picking to see if they reach container bottoms if we encounter any very large containers (> 6-8" deep with narrow apertures*)
	densityMeterSampleNeedles=PadRight[
		Table[
			Link[Resource[Sample->Model[Item, Needle, "id:L8kPEjNLDD1A"],Name->ToString[Unique[]],Rent->True]],
			(*Need only one needle per sample measured with the density meter, so look at how many samples are being measured with the densitymeter method*)
			Length[myExpandedDensityMeterSamples]
		],
		Length[myExpandedSamples],
		Null
	];



	(*Wash solutions*)
	(*Usually water and reagent grade ethanol, need enough of each solution for all wash cycles to be performed*)

	(*Resolve first wash solution and pre-wash solution resources*)
	{firstWashSolutions,preWashSolution,airWaterCheckSolution}=Module[
		{
			solutions,firstWashVolumes,firstWashCycles,totalFirstWashVolumes,firstWashSolutionList,gatheredFirstWashVolumes,
			firstWashSolutionContainers,firstWashSolutionResources,finalFirstWashSolutions,totaledFirstWashVolumes,finalPreWashSolution,
			firstWashSolutionResourcesLookup, waterCheckSolution
		},

		(*Get the wash solution(s) from the options (usually Milli-Q water,possibly more than one)*)
		If[
			MatchQ[densityMeterSamples,{}],
			(*If there are no density meter samples, just set this to Null*)
			{finalFirstWashSolutions,finalPreWashSolution,waterCheckSolution}={Null,Null,Null},
			(*If there is at least one density meter sample, resolve the resources*)
			solutions=Sort[DeleteDuplicates[Join[Lookup[myExpandedDensityMeterOptions,WashSolution],{Model[Sample,"Milli-Q water"]}]]];
			firstWashSolutionList=Lookup[myExpandedDensityMeterOptions,WashSolution];
			firstWashVolumes=Ceiling[Lookup[myExpandedDensityMeterOptions,WashVolume],10 Milliliter];
			firstWashCycles=Lookup[myExpandedDensityMeterOptions,WashCycles];
			(*Get the total volume needed for each first wash*)
			totalFirstWashVolumes=firstWashVolumes*firstWashCycles;
			(*Combine the lists of wash solutions with the required volumes, and gather all the same solutions together*)
			(*10 Milliliter of water for preWash plus 2mL for each air water check*)
			gatheredFirstWashVolumes=Sort[GatherBy[
				Transpose[{Join[firstWashSolutionList,{Model[Sample,"Milli-Q water"]}],Join[totalFirstWashVolumes,{(11 Milliliter+Count[Lookup[myExpandedDensityMeterOptions,AirWaterCheck],True] * 3 Milliliter)}]}],
				First
			]];
			(*Sum all the same solutions together to see how much total volume of each is required*)
			totaledFirstWashVolumes=(Total[#]&/@gatheredFirstWashVolumes)[[All,2]];

			(*Find beakers for all wash solutions (with a wide opening for easy syringing out of) big enough to contain the total volume needed for all specified washes*)
			firstWashSolutionContainers= Map[
				If[MatchQ[#,RangeP[1 Milliliter, 100 Milliliter]],
					(*If the total volume of the wash solution needed is between 1 and 100 mL, round up to use at least a 100 mL glass bottle. This can avoid some extremely small containers to avoid difficulty in liquid handling *)
					PreferredContainer[100 Milliliter],
					(*Otherwise, go with preferred container*)
					PreferredContainer[#]
				]&,
				totaledFirstWashVolumes
			];
			(*Turn the first wash solutions into resources with the appropriate solvents in correctly sized containers*)
			firstWashSolutionResources=MapThread[
				Link[Resource[Sample -> #1, Container -> #2, Amount -> #3, Name->ToString[Unique[]]]] &,
				{solutions, firstWashSolutionContainers, totaledFirstWashVolumes}
			];

			firstWashSolutionResourcesLookup=AssociationThread[solutions->firstWashSolutionResources];

			(*Create an index-matched (to batchedsamples) list of wash solution resources pointing to the large beakers containing the whole solution volume*)
			finalFirstWashSolutions=PadRight[(firstWashSolutionList/.firstWashSolutionResourcesLookup),Length[myExpandedBatchedSamples],Null];
			finalPreWashSolution = Model[Sample,"Milli-Q water"]/.firstWashSolutionResourcesLookup;
			waterCheckSolution = If[
				MemberQ[Lookup[myExpandedDensityMeterOptions,AirWaterCheck],True],
				Model[Sample,"Milli-Q water"]/.firstWashSolutionResourcesLookup,
				Null
			];
			{finalFirstWashSolutions,finalPreWashSolution,waterCheckSolution}
		]
	];

	(*Resolve secondary wash solution and resources*)
	{secondaryWashSolutions,secondaryPreWashSolution}=Module[
		{
			solutions,secondaryWashVolumes,secondaryWashCycles,totalSecondaryWashVolumes,secondaryWashSolutionList,gatheredSecondaryWashVolumes,
			totaledSecondaryWashVolumes,secondaryWashSolutionContainers,finalSecondaryWashSolutions,secondaryWashSolutionResources,
			airWaterCheckBool,finalSecondaryPreWashSolution
		},

		(*Get the wash solution(s) from the options (usually Milli-Q water,possibly more than one)*)

		If[MatchQ[densityMeterSamples,{}],
			(*If there are no density meter samples, just set this to Null*)
			{finalSecondaryWashSolutions,finalSecondaryPreWashSolution}={Null,Null},
			(*If there is at least one density meter sample, resolve the resources*)
			solutions=Sort[DeleteDuplicates[Join[Lookup[myExpandedDensityMeterOptions,SecondaryWashSolution],{Model[Sample,"Ethanol, Reagent Grade"]}]]];
			secondaryWashSolutionList=Lookup[myExpandedDensityMeterOptions,SecondaryWashSolution];
			airWaterCheckBool = Lookup[myExpandedDensityMeterOptions, AirWaterCheck];
			secondaryWashVolumes=Ceiling[Lookup[myExpandedDensityMeterOptions,WashVolume],10 Milliliter];
			secondaryWashCycles=Lookup[myExpandedDensityMeterOptions,WashCycles];
			(*Get the total volume needed for each secondary wash*)
			totalSecondaryWashVolumes=MapThread[
				If[
					#1,
					#2*#3+10Milliliter,
					#2*#3
				]&,
				{airWaterCheckBool,secondaryWashVolumes,secondaryWashCycles}
			];
			(*Combine the lists of wash solutions with the required volumes, and gather all the same solutions together*)
			gatheredSecondaryWashVolumes=Sort[GatherBy[
				Transpose[{Join[secondaryWashSolutionList,{Model[Sample,"Ethanol, Reagent Grade"]}],Join[totalSecondaryWashVolumes,{10 Milliliter}]}],
				First
			]];
			(*Sum all the same solutions together to see how much total volume of each is required*)
			totaledSecondaryWashVolumes=(Total[#]&/@gatheredSecondaryWashVolumes)[[All,2]];

			(*Find beakers for all wash solutions (with a wide opening for easy syringing out of) big enough to contain the total volume needed for all specified washes*)
			secondaryWashSolutionContainers=
					If[MatchQ[#,RangeP[1 Milliliter, 100 Milliliter]],
						(*If the total volume of the wash solution needed is between 1 and 100 mL, round up to use at least a 100 mL glass bottle. This can avoid some extremely small containers to avoid difficulty in liquid handling *)
						PreferredContainer[100 Milliliter],
						(*Otherwise, go with preferred container*)
						PreferredContainer[#]
					]&/@totaledSecondaryWashVolumes;
			(*Turn the secondary wash solutions into resources with the appropriate solvents in correctly sized containers*)
			secondaryWashSolutionResources=MapThread[
				Link[Resource[Sample -> #1, Container -> #2, Amount -> #3, Name->ToString[Unique[]]]] &,
				{solutions, secondaryWashSolutionContainers,totaledSecondaryWashVolumes}
			];
			(*Create an index-matched (to batchedsamples) list of wash solution resources pointing to the large beakers containing the whole solution volume*)
			{finalSecondaryWashSolutions,finalSecondaryPreWashSolution}={
				PadRight[(secondaryWashSolutionList/.AssociationThread[solutions->secondaryWashSolutionResources]),Length[myExpandedBatchedSamples],Null],
				Model[Sample,"Ethanol, Reagent Grade"]/.AssociationThread[solutions -> secondaryWashSolutionResources]
			}
		]
	];

	(*Resolve secondary wash solution and resources*)
	{tertiaryWashSolutions,tertiaryPreWashSolution}=Module[
		{
			solutions,tertiaryWashVolumes,tertiaryWashCycles,totalTertiaryWashVolumes,tertiaryWashSolutionList,gatheredTertiaryWashVolumes,
			totaledTertiaryWashVolumes,tertiaryWashSolutionContainers,finalTertiaryWashSolutions,tertiaryWashSolutionResources,
			finalTertiaryPreWashSolution
		},

		(*Get the wash solution(s) from the options (usually Milli-Q water,possibly more than one)*)

		If[MatchQ[densityMeterSamples,{}],
			(*If there are no density meter samples, just set this to Null*)
			{finalTertiaryWashSolutions,finalTertiaryPreWashSolution}={Null,Null},
			(*If there is at least one density meter sample, resolve the resources*)
			solutions=Sort[DeleteCases[DeleteDuplicates[Join[Lookup[myExpandedDensityMeterOptions,TertiaryWashSolution],{Model[Sample,"Acetone, Reagent Grade"]}]],Null]];
			tertiaryWashSolutionList=Lookup[myExpandedDensityMeterOptions,TertiaryWashSolution];
			tertiaryWashVolumes=Ceiling[PickList[Lookup[myExpandedDensityMeterOptions,WashVolume],Lookup[myExpandedDensityMeterOptions,TertiaryWashSolution],Except[Null]],10 Milliliter];
			tertiaryWashCycles=PickList[Lookup[myExpandedDensityMeterOptions,WashCycles],Lookup[myExpandedDensityMeterOptions,TertiaryWashSolution],Except[Null]];
			(*Get the total volume needed for each secondary wash*)
			totalTertiaryWashVolumes=MapThread[
				#1*#2&,
				{tertiaryWashVolumes,tertiaryWashCycles}
			];

			(*Combine the lists of wash solutions with the required volumes, and gather all the same solutions together*)
			gatheredTertiaryWashVolumes=DeleteCases[Sort[GatherBy[
				Transpose[{Join[DeleteCases[tertiaryWashSolutionList,Null],{Model[Sample,"Acetone, Reagent Grade"]}],Join[totalTertiaryWashVolumes,{10 Milliliter}]}],
				First
			]],{{Null, _} ..}];

			(*Sum all the same solutions together to see how much total volume of each is required*)
			totaledTertiaryWashVolumes=(Total[#]&/@gatheredTertiaryWashVolumes)[[All,2]];

			(*Find beakers for all wash solutions (with a wide opening for easy syringing out of) big enough to contain the total volume needed for all specified washes*)
			tertiaryWashSolutionContainers=
					If[MatchQ[#,RangeP[1 Milliliter, 100 Milliliter]],
						(*If the total volume of the wash solution needed is between 1 and 100 mL, round up to use at least a 100 mL glass bottle. This can avoid some extremely small containers to avoid difficulty in liquid handling *)
						PreferredContainer[100 Milliliter],
						(*Otherwise, go with preferred container*)
						PreferredContainer[#]
				]&/@totaledTertiaryWashVolumes;



			(*Turn the secondary wash solutions into resources with the appropriate solvents in correctly sized containers*)
			tertiaryWashSolutionResources=MapThread[
				Link[Resource[Sample -> #1, Container -> #2, Amount -> #3, Name->ToString[Unique[]]]] &,
				{solutions, tertiaryWashSolutionContainers,totaledTertiaryWashVolumes}
			];
			(*Create an index-matched (to batchedsamples) list of wash solution resources pointing to the large beakers containing the whole solution volume*)
			{finalTertiaryWashSolutions,finalTertiaryPreWashSolution}={
				PadRight[(tertiaryWashSolutionList/.AssociationThread[solutions->tertiaryWashSolutionResources]),Length[myExpandedBatchedSamples],Null],
				Model[Sample,"Acetone, Reagent Grade"]/.AssociationThread[solutions -> tertiaryWashSolutionResources]
			}
		]
	];

	(*Wash solution syringes*)
	(*Should always be 10 mL disposable luerlock syringes, if the washvolume is larger than 10mL just refill the same syringe and use 10 mL at a time*)
	densityMeterWashSyringes= Table[
			Link[Resource[Sample->Model[Container, Syringe, "id:4pO6dMWvnn7z"],Name->ToString[Unique[]]]],
			(*Need to have one syringe per different wash solution, so look at the total number of primary wash solutions to determine how many are needed*)
			Length[
				Flatten[DeleteDuplicates[
					Join[
						Lookup[myExpandedBatchedSampleOptions,WashSolution],
						Lookup[myExpandedBatchedSampleOptions,SecondaryWashSolution],
						Lookup[myExpandedBatchedSampleOptions,TertiaryWashSolution],
						{Model[Sample,"Milli-Q water"],Model[Sample,"Ethanol, Reagent Grade"],Model[Sample,"Acetone, Reagent Grade"]}(*pre wash solutions*)
					]/.{Null->Nothing}
				]]
			]
	];

	densityMeterWashSyringesLookup=MapThread[
		Rule[#1, #2] &,
		{
			Flatten[DeleteDuplicates[
				Join[
					Lookup[myExpandedBatchedSampleOptions,WashSolution],
					Lookup[myExpandedBatchedSampleOptions,SecondaryWashSolution],
					Lookup[myExpandedBatchedSampleOptions,TertiaryWashSolution],
					{Model[Sample,"Milli-Q water"],Model[Sample,"Ethanol, Reagent Grade"],Model[Sample,"Acetone, Reagent Grade"]}(*pre wash solutions*)
				]/.{Null->Nothing}
			]],
			densityMeterWashSyringes
		}
	];

	densityMeterWashSyringes=If[
		MatchQ[Lookup[myExpandedBatchedSampleOptions,WashSolution],{}|Null|Nothing],
		Null,
		Lookup[myExpandedBatchedSampleOptions,WashSolution]/.densityMeterWashSyringesLookup
	];

	densityMeterSecondaryWashSyringes=If[
		MatchQ[Lookup[myExpandedBatchedSampleOptions,SecondaryWashSolution],{}|Null|Nothing],
		Null,
		Lookup[myExpandedBatchedSampleOptions,SecondaryWashSolution]/.densityMeterWashSyringesLookup
	];

	densityMeterTertiaryWashSyringes=If[
		MatchQ[Lookup[myExpandedBatchedSampleOptions,TertiaryWashSolution],{}|Null|Nothing],
		Null,
		Lookup[myExpandedBatchedSampleOptions,TertiaryWashSolution]/.densityMeterWashSyringesLookup
	];

	(*Batched Wash solution syringes*)
	(*Should always be 10 mL disposable luerlock syringes, if the washvolume is larger than 10mL just refill the same syringe and use 10 mL at a time*)
	batchedDensityMeterWashSyringes=If[
		MatchQ[firstWashSolutions,{}|Null|Nothing],
		Null,
		(If[MatchQ[#,Null],Null,First[#][Sample]] & /@firstWashSolutions)/.densityMeterWashSyringesLookup
	];

	(*Batched Secondary wash solution syringes*)
	(*Should always be 10 mL disposable luerlock syringes, if the washvolume is larger than 10mL just refill the same syringe and use 10 mL at a time*)
	batchedDensityMeterSecondaryWashSyringes=If[
		MatchQ[secondaryWashSolutions,{}|Null|Nothing],
		Null,
		(If[MatchQ[#,Null],Null,First[#][Sample]] & /@secondaryWashSolutions)/.densityMeterWashSyringesLookup
	];

	(*Batched Tertiary wash solution syringes*)
	(*Should always be 10 mL disposable luerlock syringes, if the washvolume is larger than 10mL just refill the same syringe and use 10 mL at a time*)
	batchedDensityMeterTertiaryWashSyringes=If[
		MatchQ[tertiaryWashSolutions,{}|Null|Nothing],
		Null,
		(If[MatchQ[#,Null],Null,First[#][Sample]] & /@tertiaryWashSolutions)/.densityMeterWashSyringesLookup
	];

	densityMeterPreWashSyringes=If[
		MatchQ[preWashSolution,{}|Null|Nothing],
		Null,
		Model[Sample,"Milli-Q water"]/.densityMeterWashSyringesLookup
	];

	(*Batched Secondary wash solution syringes*)
	(*Should always be 10 mL disposable luerlock syringes, if the washvolume is larger than 10mL just refill the same syringe and use 10 mL at a time*)
	densityMeterSecondaryPreWashSyringes=If[
		MatchQ[secondaryPreWashSolution,{}|Null|Nothing],
		Null,
		Model[Sample,"Ethanol, Reagent Grade"]/.densityMeterWashSyringesLookup
	];

	(*Batched Tertiary wash solution syringes*)
	(*Should always be 10 mL disposable luerlock syringes, if the washvolume is larger than 10mL just refill the same syringe and use 10 mL at a time*)
	densityMeterTertiaryPreWashSyringes=If[
		MatchQ[tertiaryPreWashSolution,{}|Null|Nothing],
		Null,
		Model[Sample,"Acetone, Reagent Grade"]/.densityMeterWashSyringesLookup
	];

	densityMeterAirWaterCheckSyringe=If[
		MemberQ[Lookup[myExpandedDensityMeterOptions,AirWaterCheck],True],
		Model[Sample,"Milli-Q water"]/.densityMeterWashSyringesLookup,
		Null
	];

	(*End of DensityMeter resources*)

	(*Start of FixedVolumeWeight resources*)

	(* Determine if we can default to the larger pipette *)
	bigPipette=AllTrue[Map[
			#>100 Microliter&,
			Lookup[myExpandedFVWOptions,Volume]
		],TrueQ
	];

	(* Default our pipette choices. These will be used in 90% of cases and are our most accurate pipetting devices *)
	defaultPipetteModel = If[bigPipette,bigPipetteModel,smallPipetteModel];
	defaultTipModel = If[bigPipette,bigTipModel,smallTipModel];

	(* Check that the pipette default can be used with the containers involved *)
	compatibleTipBools = tipsReachContainerBottomQ[
		defaultTipModel,
		#,
		{FirstCase[tipPackets,KeyValuePattern[Object->defaultTipModel]]}
	]&/@myExpandedSimulatedContainerFVWModels;

	(* Choose a pipette/tip that can reach into our containers *)
	{resolvedPipettes,resolvedTips}=If[
		MatchQ[myExpandedFVWSamples,{}],
		{{},{}},
	 Transpose@MapThread[
		Function[{defaultBool,containerMod,measureVol},
			If[defaultBool,

				(* If defaultBool==True, then we can use our pipette defaults *)
				{defaultPipetteModel,defaultTipModel},

				(* Otherwise the pipette default doesn't work so we must find a pipette that does work *)
				Module[{compatibleTip},
					(* Get all gilson pipets and serological pipets with their transfer ranges *)
					compatibleTip = SelectFirst[
						TransferDevices[{Model[Item,Tips]},measureVol][[All,1]],
						tipsReachContainerBottomQ[
							#,
							containerMod,
							{FirstCase[
								fullCache,
								KeyValuePattern[
									Object -> #
								]
							]}
						]&
					];


					{pipetForTips[compatibleTip],compatibleTip}
				]
			]
		],
		{
			compatibleTipBools,
			myExpandedSimulatedContainerFVWModels,
			Lookup[myExpandedFVWOptions,Volume]
		}
		]
	];
	(* Build resources for all the tips we will use *)
	tipResources = Module[
		{tipTallies,tipsPerBox,allGeneratedResources,outputList},

		(* Determine how many of each tip model we need *)
		tipTallies = Tally[resolvedTips];

		(* Lookup the number of tips in a box of each model of tips *)
		tipsPerBox = Lookup[
			FirstCase[tipPackets,ObjectP[#]],
			NumberOfTips
		]&/@(tipTallies[[All,1]]);

		(* Generate a list of resources where each resource for a box of tips is repeated N times where N is the number
		 of tips used in the box. *)
		(* This is in the form of {Model,Resource,Count}, as we'll recurse over this list to find the first instance of the model
		and replace it with the resource involved, then decrement that resource accordingly*)
		allGeneratedResources =If[MatchQ[myExpandedFVWSamples,{}],
			{},
       MapThread[
			Function[{tipMod,tipCount,tipPerBox},
				Sequence@@Map[
					{
						tipMod,
						(* If the pipette is individually wrapped, don't request an amount *)
						If[tipPerBox==1,
							Resource[
								Sample -> tipMod,
								Name -> ToString[Unique[]]
							],
							Resource[
								Sample -> tipMod,
								Amount -> #,
								Name -> ToString[Unique[]]
							]
						],
						# (* Number of times this resource can be used *)
					}&,
					QuantityPartition[tipCount,tipPerBox]
				]
			],
			Append[Transpose@tipTallies,tipsPerBox]
		]];

		(* Recurse over our list of resolved tips, replacing each tip with a resource until that resource has been used
		N times, where N is the number of tips the resource is responsible for *)
		(* This is necessary because the Tally call above unsorted our list of tips, and we must replace the tip objects
		with resources at the positions necessary for the containers being used *)
		outputList = {};
		Map[
			Function[{objectToReplace},
				Module[
					{pos},
					pos = FirstPosition[allGeneratedResources,{objectToReplace,_,GreaterP[0]}];
					outputList = Append[
						outputList,
						Extract[allGeneratedResources,pos][[2]](* The resource is the second index *)
					];
					allGeneratedResources = ReplacePart[
						allGeneratedResources,
						pos->{
							Extract[allGeneratedResources,pos][[1]],
							Extract[allGeneratedResources,pos][[2]],
							Extract[allGeneratedResources,pos][[3]]-1
						}
					];
				]
			],
			resolvedTips
		];

		(* Return the built list of resources *)
		outputList
	];

	batchedTipResources=PadLeft[
		tipResources,
		Length[myExpandedBatchedSamples],
		Null
		];

	pipetteResources = If[MatchQ[myExpandedFVWSamples,{}],
		{},
		MapThread[
		#1 -> Link[
			Resource[
				Instrument->#1,
				Time->(5 Minute)*#2,
				Name->ToString[Unique[]]
			]
		]&,
		Transpose[Tally[DeleteDuplicates[resolvedPipettes]]]
	]];
	(*Resort the resources and options lists to populate the non-batched user-visible lists with the resources generated*)
	resortedMeasurementContainerResources=Extract[measurementContainerResources,Flatten[Position[batchedSamplesInResources,#]&/@DeleteDuplicates[expandedSamplesInResources],1]];
	resortedTipResources=Extract[batchedTipResources,Flatten[Position[batchedSamplesInResources,#]&/@DeleteDuplicates[expandedSamplesInResources],1]];
	resortedSampleSyringeResources=Extract[densityMeterSampleSyringes,Flatten[Position[batchedSamplesInResources,#]&/@DeleteDuplicates[expandedSamplesInResources],1]];
	resortedSampleNeedleResources=Extract[densityMeterSampleNeedles,Flatten[Position[batchedSamplesInResources,#]&/@DeleteDuplicates[expandedSamplesInResources],1]];

	resortedFirstWashSolutions=If[
		MatchQ[firstWashSolutions,Null],
		Null,
		Lookup[myExpandedOptions,WashSolution]/.MapThread[Rule[#1, #2] &,{Lookup[myExpandedBatchedSampleOptions,WashSolution],firstWashSolutions}]
		];
	resortedSecondaryWashSolutions=If[
		MatchQ[secondaryWashSolutions,Null],
		Null,
		Lookup[myExpandedOptions,SecondaryWashSolution]/.MapThread[Rule[#1, #2] &,{Lookup[myExpandedBatchedSampleOptions,SecondaryWashSolution],secondaryWashSolutions}]
	];
	resortedTertiaryWashSolutions=If[
		MatchQ[tertiaryWashSolutions,Null],
		Null,
		Lookup[myExpandedOptions,TertiaryWashSolution]/.MapThread[Rule[#1, #2] &,{Lookup[myExpandedBatchedSampleOptions,TertiaryWashSolution],tertiaryWashSolutions}]
	];

		(* Generate our protocol packet *)
	protocolPacket = Association[
		Type->Object[Protocol, MeasureDensity],
		Object->CreateID[Object[Protocol, MeasureDensity]],
		Replace[SamplesIn]-> expandedSamplesInResources,
		Replace[BatchLengths]->{Length[myExpandedDensityMeterSamples],Length[myExpandedFVWSamples]}/.{0->Nothing},
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@containersInObjects,
		Replace[DensityMethods]->Lookup[myExpandedOptions,Method],
		Replace[BatchedMethods]->DeleteDuplicates[Lookup[myExpandedBatchedSampleOptions,Method]],
		Replace[RecoupSample]->Lookup[myExpandedOptions,RecoupSample],
		Replace[BatchedRecoupSample]->Lookup[myExpandedBatchedSampleOptions,RecoupSample],
		Replace[Volumes]->Lookup[myExpandedOptions,Volume],
		Replace[BatchedVolumes]->Lookup[myExpandedBatchedSampleOptions,Volume],
		Replace[Temperature]->Lookup[myExpandedOptions,Temperature],
		Replace[BatchedTemperature]->Lookup[myExpandedBatchedSampleOptions,Temperature],
		Replace[ViscosityCorrection]->Lookup[myExpandedOptions,ViscosityCorrection],
		Replace[BatchedViscosityCorrection]->Lookup[myExpandedBatchedSampleOptions,ViscosityCorrection],
		Replace[WashSolution]->resortedFirstWashSolutions,
		Replace[BatchedWashSolution]->firstWashSolutions,
		Replace[SecondaryWashSolution]->resortedSecondaryWashSolutions,
		Replace[BatchedSecondaryWashSolution]->secondaryWashSolutions,
		Replace[TertiaryWashSolution]->resortedTertiaryWashSolutions,
		Replace[BatchedTertiaryWashSolution]->tertiaryWashSolutions,
		Replace[WashCycles]->Lookup[myExpandedOptions,WashCycles],
		Replace[BatchedWashCycles]->Lookup[myExpandedBatchedSampleOptions,WashCycles],
		Replace[WashVolume]->Lookup[myExpandedOptions,WashVolume],
		Replace[BatchedWashVolume]->Lookup[myExpandedBatchedSampleOptions,WashVolume],
		Replace[MeasurementContainers]->resortedMeasurementContainerResources,
		Replace[BatchedMeasurementContainers]->measurementContainerResources,
		Replace[PipetteTips]->resortedTipResources,
		Replace[BatchedPipetteTips]->batchedTipResources,
		Replace[SampleSyringes]->resortedSampleSyringeResources,
		Replace[BatchedSampleSyringes]->densityMeterSampleSyringes,
		Replace[Needles]->resortedSampleNeedleResources,
		Replace[BatchedNeedles]->densityMeterSampleNeedles,
		Replace[WashSyringes]->densityMeterWashSyringes,
		Replace[SecondaryWashSyringes]->densityMeterSecondaryWashSyringes,
		Replace[TertiaryWashSyringes]->densityMeterTertiaryWashSyringes,
		Replace[PreWashSyringe]->densityMeterPreWashSyringes,
		Replace[SecondaryPreWashSyringe]->densityMeterSecondaryPreWashSyringes,
		Replace[TertiaryPreWashSyringe]->densityMeterTertiaryPreWashSyringes,
		Replace[AirWaterCheckSyringe]->densityMeterAirWaterCheckSyringe,
		Replace[BatchedWashSyringes]->batchedDensityMeterWashSyringes,
		Replace[BatchedSecondaryWashSyringes]->batchedDensityMeterSecondaryWashSyringes,
		Replace[BatchedTertiaryWashSyringes]->batchedDensityMeterTertiaryWashSyringes,
		Replace[Pipettes]->DeleteDuplicates[resolvedPipettes]/.pipetteResources,
		Replace[AirWaterChecks]->Lookup[myExpandedOptions,AirWaterCheck],
		Replace[BatchedAirWaterChecks]->Lookup[myExpandedBatchedSampleOptions,AirWaterCheck],
		AirWaterCheckSolution -> airWaterCheckSolution, (*prewash and air water check are both water*)
		PreWashSolution -> preWashSolution,
		SecondaryPreWashSolution -> secondaryPreWashSolution,
		TertiaryPreWashSolution -> tertiaryPreWashSolution,
		Balance->
			If[MatchQ[myExpandedFVWSamples,{}],
				Null,
				Link[Resource[(Instrument->DeleteDuplicates[resolvedBalance]/.{obj:ObjectP[Object[Instrument]]}:>obj),Time->(5 Minute)*Length[samplesInFVWResources]]]
			],
		Instrument->
			If[MatchQ[myExpandedDensityMeterSamples,{}],
				Null,
				Link[Resource[(Instrument->DeleteDuplicates[resolvedDensityMeter]/.{obj:ObjectP[Object[Instrument]]}:>obj),Time->(10 Minute)*Length[samplesInDensityMeterResources]]]
			],
		(* used to collect any samples not being recouped or if the density meter is used for any sample*)
		WasteContainer->If[Or[Nand@@(Take[Lookup[myExpandedBatchedSampleOptions,RecoupSample],Length[myExpandedFVWSamples]]),MemberQ[Lookup[myExpandedBatchedSampleOptions,Method],DensityMeter]],
			Link[Resource[Name->ToString[Unique[]],Sample->Model[Container,Vessel,"id:R8e1PjRDbbOv"],Rent->True]],
			(* No need for a beaker if we are recouping all samples and not using density meter *)
			Null
		],
		ResolvedOptions->resolvedOptionsNoHidden,
		UnresolvedOptions->RemoveHiddenOptions[ExperimentMeasureDensity,myUnresolvedOptions],
		MeasureVolume -> Lookup[myResolvedOptions,MeasureVolume],
		MeasureWeight -> Lookup[myResolvedOptions,MeasureWeight],
		ImageSample -> Lookup[myResolvedOptions,ImageSample],
		NumberOfReplicates -> numberOfReplicates,


		Replace[Checkpoints]->{
			{"Picking Resources",5 Minute,"Samples required to execute this protocol are gathered from storage.",
				Resource[Operator -> $BaselineOperator,Time -> 5 Minute]},
			{"Measuring Density",(10 Minute*Length[expandedSamplesInResources]),"Density measurements of the provided samples are made.",
				Resource[Operator -> $BaselineOperator,Time -> (10 Minute*Length[expandedSamplesInResources])]},
			{"Sample Post-Processing",1 Minute ,"Any measuring of volume, weight, or sample imaging post experiment is performed.",
				Resource[Operator -> $BaselineOperator,Time -> 1 Minute]},
			{"Returning Materials",5 Minute,"Samples are returned to storage.",
				Resource[Operator -> $BaselineOperator,Time -> 5 Minute]}
		}
	];

	(* Get the prep options to populate resources and field values *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions,Cache->inheritedCache,Simulation->updatedSimulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[protocolPacket,sharedFieldPacket];

	(* Gather the resources blobs we've created *)
	allResourceBlobs = DeleteDuplicates[Cases[Values[finalizedPacket], _Resource, Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache,Simulation->updatedSimulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->!gatherTests,Cache->inheritedCache,Simulation->updatedSimulation],Null}
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
	outputSpecification /. {previewRule,optionsRule,resultRule,testsRule}
];


DefineOptions[ExperimentMeasureDensityOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions :> {ExperimentMeasureDensity}
];


ExperimentMeasureDensityOptions[myInput:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options for DropShipSamples *)
	options = ExperimentMeasureDensity[myInput, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentMeasureDensity],
		options
	]
];


ExperimentMeasureDensityPreview[myInput:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ExperimentMeasureDensity]]:=
		ExperimentMeasureDensity[myInput,Append[ToList[myOptions],Output->Preview]];


DefineOptions[ValidExperimentMeasureDensityQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions :> {ExperimentMeasureDensity}
];


ValidExperimentMeasureDensityQ[myInput:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentMeasureDensityQ]]:=Module[
	{listedOptions, listedInput, noOutputOptions, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedInput = ToList[myInput];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentMeasureDensity *)
	filterTests = ExperimentMeasureDensity[myInput, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[filterTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings, testResults},

		(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[listedInput, OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{listedInput, validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, filterTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentMassSpectrometryQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentMeasureDensityQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentMeasureDensityQ"]
];


(* ::Section:: *)
(*End Private*)
