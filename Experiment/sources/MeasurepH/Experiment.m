(* ::Package:: *)

(* ::Title:: *)
(*Experiment MeasurepH: Source*)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentMeasurepH*)


(* ::Subsection::Closed:: *)
(*Options*)


DefineOptions[
	ExperimentMeasurepH,
	Options :> {
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->Instrument,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Instrument, pHMeter], Model[Instrument, pHMeter]}]
				],
				Description->"For each member of 'items', the pH meter to be used for measurement.",
				ResolutionDescription->"For each member of 'items', the pH meter chosen is based suitability to sample volume and container.",
				Category->"General"
			},
			{
				OptionName->ProbeType,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>pHProbeTypeP
				],
				Description->"For each member of 'items', the type of pH meter (Surface or Immersion) to be used for measurement.",
				ResolutionDescription->"For each member of 'items', the type of pH meter is chosen based on minimizing the aliquot volume.",
				Category->"Hidden"
			},
			{
				OptionName->Probe,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Part, pHProbe],Model[Part, pHProbe]}]
				],
				Description->"The pH probe which is immersed in each sample for conductivity measurement.",
				ResolutionDescription->"If the sample volume is small, a surface or microprobe will be chosen. Otherwise, set to the large immersion probe.",
				Category->"General"
			},
			{
				OptionName -> AcquisitionTime,
				Default -> Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Quantity, Pattern:>RangeP[0 Second,30 Minute],Units->{1,{Minute,{Minute,Second}}}],
				Description -> "The amount of time that data from the pH sensor should be acquired. 0 Second indicates that the pH sensor should be pinged instantaneously, collecting only 1 data point. When set, SensorNet pings the instrument in 1 second intervals. This option cannot be set for the non-SensorNet pH instruments since they only provide a single pH reading.",
				ResolutionDescription -> "Resolves to 5 Second if the probe is connected to our SensorNet system; otherwise, set to Null.",
				Category -> "General"
			},
			{
				OptionName -> TemperatureCorrection,
				Default -> Automatic,
				AllowNull->True,
				Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Linear,Off]],
				Description -> "Defines the relationship between temperature and pH. Linear: Use for the temperature correction of medium and highly conductive solutions. NonLinear: Use for natural water (only for temperature between 0\[Ellipsis]36 \[Degree]C). Off: The pH value at the current temperature is displayed.",
				ResolutionDescription -> "Set to Linear if the instrument is capable; otherwise, Null.",
				Category -> "General"
			},
			{
				OptionName -> RecoupSample,
				Default -> False,
				AllowNull->False,
				Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
				Description -> "Indicates if the transferred liquid used for pH measurement will be recouped or transferred back into the original container after pH measurement. If ProbeType->Immersion, the sample will be returned to the container before aliquotting occurred, if applicable, since aliquotting is automatically turned on for this measurement type.",
				ResolutionDescription -> "Resolves to False unless explicitly set to True.",
				Category -> "General"
			}
		],
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description -> "The number of times to repeat the experiment on each provided 'item'. If specified, the recorded replicate measurements will be averaged for determining the final pH of the sample(s). Note that specifying NumberOfReplicates is identical to providing duplicated input.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>RangeP[2,10,1]],
			Category->"General"
		},
		{
			OptionName -> WashSolution,
			Default -> Model[Sample,"Milli-Q water"],
			AllowNull->False,
			Widget -> Widget[Type->Object, Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Description -> "The solution that should be used to wash the pH probe between measurements. For Surface and Immersion probes, if WashSolution is not Model[Sample,\"Milli-Q water\"], probe with be washed with a wash bottle containing Milli-Q water and then washed in a clean 600ml beaker containing 400ml of Milli-Q water. If WashSolution is not Model[Sample,\"Milli-Q water\"], two aliquots of the wash solutions will be created. The probe will first be washed in a \"dirty\" solution and then washed in a \"clean\" solution.",
			Category -> "General"
		},
		{
			OptionName->LowCalibrationBuffer,
			Default->Model[Sample, "id:BYDOjvGjGxGr"],  (*Note: if changing this default, please change the resource packet and cacheBall sampleModelsToDownload in AdjustpH as well.*)
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
			],
			Description->"The low pH buffer that should be used to calibrate the pH probe. Only SensorNet-based probes can have non-standard calibration buffers.",
			Category->"Calibration"
		},
		{
			OptionName->LowCalibrationBufferpH,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[0,14]
			],
			Description->"The pH of the LowCalibrationBuffer that should be used to calibrate the pH probe. Only SensorNet-based probes can have non-standard calibration buffers.",
			ResolutionDescription->"Resolves to the pH of the LowCalibrationBuffer, if known.",
			Category->"Calibration"
		},
		{
			OptionName->MediumCalibrationBuffer,
			Default->Model[Sample, "id:vXl9j57j7OVd"], (*Note: if changing this default, please change the resource packet and cacheBall sampleModelsToDownload in AdjustpH as well.*)
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
			],
			Description->"The medium pH buffer that should be used to calibrate the pH probe. This buffer is optional and may be set to Null if a calibration using two reference buffers (low and high) is desired).",
			Category->"Calibration"
		},
		{
			OptionName->MediumCalibrationBufferpH,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[0,14]
			],
			Description->"The pH of the MediumCalibrationBuffer, if provided, that should be used to calibrate the pH probe. Only SensorNet-based probes can have non-standard calibration buffers.",
			ResolutionDescription->"Resolves to the pH of the MediumCalibrationBuffer, if known.",
			Category->"Calibration"
		},
		{
			OptionName->HighCalibrationBuffer,
			Default->Model[Sample, "id:n0k9mG8m8dMn"], (* Note: if changing any of these defaults please change the resource packet and cacheBall sampleModelsToDownload  in AdjustpH as well.*)
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
			],
			Description->"The medium pH buffer that should be used to calibrate the pH probe. This buffer is optional and may be set to Null if a calibration using two reference buffers (low and high) is desired). Only SensorNet-based probes can have non-standard calibration buffers.",
			Category->"Calibration"
		},
		{
			OptionName->HighCalibrationBufferpH,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[0,14]
			],
			Description->"The pH of the HighCalibrationBuffer, if provided, that should be used to calibrate the pH probe. Only SensorNet-based probes can have non-standard calibration buffers.",
			ResolutionDescription->"Resolves to the pH of the HighCalibrationBuffer, if known.",
			Category->"Calibration"
		},
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 35 Milliliter."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"50mL Tube\"]."
			}
		],
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOption,
		InSituOption,
		SimulationOption
	}
];


(* ::Subsection:: *)
(*Main Function*)


(* ::Subsubsection::Closed:: *)
(*Container Overload*)


(*ExperimentMeasurepH - Error Message *)

(*Invalid Input error*)
Error::NoVolume="The following samples `1` do not have their Volume field populated. The Volume of the sample must be known in order to determine if there is enough liquid to perform a pH measurement.";
Error::IncompatibleSample="The following sample(s) `1` is not chemically compatible with any pH probe. Please choose different samples to be measured.";
Error::IncompatibleSampleInstrument="The following sample(s) `1` is not chemically compatible with the specified instrument(s) `2`. Either leave the Instrument option to be automatically resolved or choose different samples to be measured.";
Error::InsufficientVolume="The following sample(s) `1` has insufficient volume for measurement. These samples must have at least `2` in order to be measured. Please choose different samples to be measured.";

(* Invalid Options errors and warnings (prior to resolving options)*)
Error::ConflictingInstrumentProbeType="The specified Instrument and ProbeType conflict for samples(s): `1`. Please change the value of these options or let them be automatically resolved.";
Warning::SurfaceAliquotConflict="ProbeType is set to Surface while Aliquot has been explicitly set to false for samples(s): `1`. Please note that these measurements require removal of a sample for measurement.";
Error::AcquisitionTimeConflict="The sample(s), `1`, have their AcquisitionTime->`2` but Instrument->`3`. AcquisitionTime can only be set for capable instruments and must otherwise be Null.";

(*Issues after resolving the options*)
Error::IncompatibleInstrument="The following sample(s) `1` cannot be measured with the specified instrument `2` due to a problem with physical dimensions (e.g. probe can't reach or fit the opening). Please choose a different instrument or choose a different sample to be measured.";
Error::NoAvailablepHInstruments="The following sample(s) `1`, though chemically compatible with some available instruments, cannot find compatible instruments to meet all the specified and resolved options for physical (e.g. liquid level too short, probe cannot reach) or chemical reasons. Consider running ExperimentMeasurepHOptions with relaxed options to find compatible instruments or setting Aliquot->True.";
Error::ConflictingReferencepHValues="The given pH values for the option(s), `1`, do not agree with the pH field in the corresponding reference buffer(s) pH field. Either leave this option alone for it to be automatically resolved or update the pH in the Model[Sample] to accurately reflect the pH of the buffer.";
Error::MediumCalibrationOptionsRequiredTogether="The options `1` must either both be specified or both not be specified (both set to Null). Please change the value of these options.";
Error::LowAndHighpHValuesMustBeSpecified="The options {LowCalibrationBufferpH,HighCalibrationBufferpH} are current set to `1`. These options cannot be set to Null. Please either inform the pH field in the Model[Sample] of your reference solutions (for the function to automatically resolve the values) or manually specify them.";
Error::pHProbeConflict="The specified pH Probe `1` is not available with the specified instrument `2`. Consider allowing one or both options to automatically set.";
Error::TemperatureCorrectionConflict="TemperatureCorrection can not be set for the current instrument `1`. Consider letting the Instrument option set automatically.";
Error::CertainpHCalibrationRequired="The SevenExcellence instrument requires 3 calibration buffers with pH values of 4, 7, and 10. Please use a different instrument or allow the Calibration buffers to set.";
Error::RecoupSampleAliquotConflict="Aliquot must not be False if RecoupSample is True. Consider allowing Aliquot to automatically set.";


(*valid containers for direct measurement pattern*)
measurepHContainerP=ObjectP[{Object[Container,Vessel]}];
measurepHContainerModelsP=ObjectP[{Model[Container,Vessel]}];

(*container overload function*)
ExperimentMeasurepH[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,sampleCache,
	updatedSimulation,containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests,updatedCache,containerToSampleSimulation},
	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasurepH,
			ToList[myContainers],
			ToList[myOptions],
			DefaultPreparedModelAmount -> 35 Milliliter,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "50mL Tube"]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentMeasurepH,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentMeasurepH,
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
	If[MatchQ[containerToSampleResult,$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentMeasurepH[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];



(* ::Subsubsection::Closed:: *)
(*Sample Overload*)


(*main function*)
ExperimentMeasurepH[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,updatedSimulation,safeOps,safeOpsTests,validLengths,validLengthTests,allInstrumentModels,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,specifiedInstrumentModels,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,objectSamplePacketFields,
		(*Everything needed for downloading*)
		mySamplesList,pHInstrumentsModels,instrumentLookup,specifiedInstrumentObjects,potentialContainers,aliquotContainerLookup,
		potentialContainersWAliquot,referenceBuffers,specifiedProbeObjects, specifiedProbeModels, probeLookup, listedSamples,
		mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed, washSolution,parentProtocol
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentMeasurepH,
			listedSamples,
			listedOptions
		],
		$Failed,
	 	{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentMeasurepH,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentMeasurepH,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitize-inputs to clean any named objects *)
	{mySamplesWithPreparedSamples,safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentMeasurepH,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentMeasurepH,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentMeasurepH,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentMeasurepH,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentMeasurepH,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*listify the samples as needed*)
	mySamplesList=mySamplesWithPreparedSamples;

	(*check if the user supplied a instrument that's not in our list (e.g. a developer object)*)
	{instrumentLookup,probeLookup}=Lookup[myOptionsWithPreparedSamples,{Instrument,Probe}];

	(* Get any objects that were specified in the instrument list. *)
	specifiedInstrumentObjects=Cases[ToList[instrumentLookup],ObjectP[Object[Instrument,pHMeter]]];
	specifiedInstrumentModels=Cases[ToList[instrumentLookup],ObjectP[Model[Instrument,pHMeter]]];
	specifiedProbeObjects=Cases[ToList[probeLookup],ObjectP[Object[Part,pHProbe]]];
	specifiedProbeModels=Cases[ToList[probeLookup],ObjectP[Model[Part,pHProbe]]];

	(* Get all non deprecated pH models including the developer ones, for testing purposes. *)
	pHInstrumentsModels=Search[Model[Instrument,pHMeter],Deprecated!=True];
	allInstrumentModels=Join[pHInstrumentsModels,specifiedInstrumentModels];

	(* Get all the potential preferred containers*)
	potentialContainers=preferredpHContainer[All];

	(*obtain other needed look ups*)
	aliquotContainerLookup=Lookup[listedOptions,AliquotContainer];

	(*if it's a compatible type, then add to the download*)
	potentialContainersWAliquot=If[MatchQ[aliquotContainerLookup,measurepHContainerModelsP],Union[potentialContainers,{aliquotContainerLookup}],potentialContainers];

	(* Lookup our reference buffers. *)
	referenceBuffers=Lookup[safeOps,{LowCalibrationBuffer,MediumCalibrationBuffer,HighCalibrationBuffer}]/.{Null->Nothing};

	objectSamplePacketFields=Packet@@Union[Flatten[{pH,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}]];

	washSolution={Lookup[safeOps,WashSolution]};

	parentProtocol = {Lookup[safeOps,ParentProtocol]};

	(* Download our information. *)
	cacheBall=FlattenCachePackets[{
		Quiet[Download[
			{
				mySamplesList,
				allInstrumentModels,
				specifiedInstrumentObjects,
				specifiedProbeObjects,
				specifiedProbeModels,
				potentialContainersWAliquot,
				Cases[referenceBuffers,ObjectP[Object[Sample]]],
				Cases[referenceBuffers,ObjectP[Model[Sample]]],
				washSolution,
				Cases[parentProtocol, ObjectP[Object[Protocol, AdjustpH]]]
			},
			{
				{
					objectSamplePacketFields,
					Packet[Container[Model][SamplePreparationCacheFields[Model[Container]]]],
					Packet[Container[Model][VolumeCalibrations][{LiquidLevelDetectorModel,CalibrationFunction,DateCreated}]]
				},
				{
					Packet[Name,Object,Objects,TemperatureCorrection,WettedMaterials,Dimensions,ProbeLengths,ProbeDiameters,MinpHs,MaxpHs,MinDepths,MinSampleVolumes,ProbeTypes,AssociatedAccessories, TemperatureCorrection, AcquisitionTimeControl],
					(*get all of the pH probe information*)
					Packet[AssociatedAccessories[[All, 1]][{Object,ProbeType,ShaftLength,ShaftDiameter,MinSampleVolume,MinpH,MaxpH,MinDepth,WettedMaterials,SupportedInstruments}]]
				},
				{
					Packet[Name,Model]
				},
				{
					Packet[Name,Model],
					Packet[Model[{Object,ProbeType,ShaftLength,ShaftDiameter,MinSampleVolume,MinpH,MaxpH,MinDepth,WettedMaterials,SupportedInstruments}]]
				},
				{
					Packet[Object,ProbeType,ShaftLength,ShaftDiameter,MinSampleVolume,MinpH,MaxpH,MinDepth,WettedMaterials,SupportedInstruments]
				},
				{
					Packet[SamplePreparationCacheFields[Model[Container]]],
					Packet[VolumeCalibrations[{LiquidLevelDetectorModel,CalibrationFunction,DateCreated}]]
				},
				{
					Packet[pH,TransportTemperature,Name,Sterile,LiquidHandlerIncompatible,Tablet,SolidUnitWeight,State]
				},
				{
					Packet[pH,TransportTemperature,Name,Deprecated,Sterile,LiquidHandlerIncompatible,Tablet,SolidUnitWeight,State]
				},
				{
					Packet[Model,Volume]
				},
				{
					Packet[WasteBeaker]
				}
			},
			Cache -> Lookup[safeOps, Cache, {}],
			Simulation -> updatedSimulation,
			Date -> Now
			(*some containers don't have a link to VolumeCalibrations. Need to silence those.*)
		],
		{Download::FieldDoesntExist,Download::NotLinkField}]
	}];


	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
	(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentMeasurepHOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation -> updatedSimulation, Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

	(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentMeasurepHOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation -> updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

		(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentMeasurepH,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentMeasurepH,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		measurepHResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall,Simulation -> updatedSimulation,Output->{Result,Tests}],
		{measurepHResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall, Simulation -> updatedSimulation],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentMeasurepH,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload -> Lookup[safeOps,Upload],
			Confirm -> Lookup[safeOps,Confirm],
			CanaryBranch -> Lookup[safeOps,CanaryBranch],
			ParentProtocol -> Lookup[safeOps,ParentProtocol],
			Priority -> Lookup[safeOps,Priority],
 			StartDate -> Lookup[safeOps,StartDate],
 			HoldOrder -> Lookup[safeOps,HoldOrder],
 			QueuePosition -> Lookup[safeOps,QueuePosition],
			ConstellationMessage -> Object[Protocol,MeasurepH],
			Cache -> cacheBall,
			Simulation -> updatedSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests(*,resourcePacketTests*)}],
		Options -> RemoveHiddenOptions[ExperimentMeasurepH,collapsedResolvedOptions],
		Preview -> Null
	}
];


(* ::Subsubsection:: *)
(*Resolver*)


DefineOptions[
	resolveExperimentMeasurepHOptions,
	Options:>{
		{InternalUsage -> False, BooleanP, "Indicates if this function is being called from another function (e.g. ExperimentAdjustpH) or not."},
		HelperOutputOption,CacheOption,SimulationOption
	}
];

resolveExperimentMeasurepHOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentMeasurepHOptions]]:=Module[
	{outputSpecification,output,gatherTests,cache,samplePrepOptions,measurepHOptions,simulatedSamples,consolidateAliquots,
	resolvedSamplePrepOptions,updatedSimulation,measurepHOptionsAssociation,invalidInputs,invalidOptions,acquisitionTimeLookup,objectSamplePacketFields, internalUsage, internalUsageQ,

		(*download variables*)
		cacheFailedRemoved,probeLookup,specifiedProbeObjects, specifiedProbeModels,
		specifiedInstrumentObjects,potentialContainers,potentialContainersWAliquot,referenceBuffers,
		samplePackets,containerModelPackets,allDownloadValues,allSampleDownloadValues,allInstrumentObjDownloadValues,allInstrumentModelDownloadValues,potentialContainerDownloadValues,
		referenceObjectDownloadValues,referenceModelDownloadValues,lowBufferLookup,mediumBufferLookup,highBufferLookup,
		instrumentObjectPackets,volumeCalibrationPackets,latestVolumeCalibrationPacket,combinedContainerPackets,instrumentModelPackets,potentialContainerPackets,
		potentialContainerModelPackets,firstPotentialCalibration,combinedPotentialContainerPackets,incompatibleWithInstrumentBool,pHProbeConflictBool,
		pHProbeConflictOptions, pHProbeConflictTests,certainCalibrationRequiredOptions, certainCalibrationRequiredTests,washSolution, washSolutionDownloadValues,
		incompatibleRoboticInstrumentBool, incompatibleInputsRoboticInstrument, incompatibleInputsRoboticInstrumentOptions, incompatibleInputsRoboticInstrumentTests,

		(*Input validation variables*)
		lowestVolume,minVolumeLookup,discardedSampleBool,discardedSamplePackets,discardedInvalidInputs,discardedTests,lowVolumeBool,lowVolumePackets,lowVolumeInvalidInputs,lowVolumeInputsTests,
		sampleInstrumentCombinations,incompatibleBool,incompatibleBoolMatrix,incompatibleInputsBool,incompatibleInputsAnyInstrument,incompatibleInputsAnyInstrumentTests,
		incompatibleInputsSpecificInstrument,incompatibleInputsSpecificInstrumentOptions,incompatibleInputsSpecificInstrumentTests,
		instrumentLookup,instrumentLookupModels,volumeMeasuredBool,noVolumePackets,noVolumeInputs,noVolumeInputsTests,
		instrumentLookupModelPackets,probeLookupModels,probeLookupModelPackets,aliquotLookup,aliquotBool,aliquotVolumeLookup,probeTypeLookup,instrumentTypeLookup,probeInstrumentBool,probeInstrumentConflictInputs,probeInstrumentConflictOptions,
		surfaceAliquotConflictBool,surfaceAliquotConflictInputs,instruments,allProbeObjectDownloadValues, allProbeModelDownloadValues,
		pHInstrumentsModels,aliquotOptionNames, aliquotTuples, deprecatedInstrumentQ, deprecatedInstrumentOptions, deprecatedInstrumentTest,
		acquisitionConflictResults,acquisitionConflictInvalidInputs,acquisitionConflictInvalidOptions,acquisitionConflictTests,
		lowReferenceBufferModel,mediumReferenceBufferModel,highReferenceBufferModel,lowpHValue,mediumpHValue,highpHValue,resolvedLowpHValue,resolvedMediumpHValue,
		resolvedHighpHValue,invalidLowpHValueOptions,invalidMediumpHValueOptions,invalidHighpHValueOptions,invalidpHOptions,matchingReferencepHTest,invalidMediumCalibrationOptions,mediumCalibrationpHTest,

		(*for the mapping*)
		probeTypeList,acquisitionTimeList,defaultInstrument,nonstandardCalibrantsQ,
		aliquotContainerLookup,aliquotVolumeList,potentialAliquotContainersList,instrumentList,incompatibleWInstrumentErrorList,
		noSuitableInstrumentErrorList,immersionInstrumentModels,immersionGlobalMinDepth,immersionGlobalMinVol,
		surfaceInstrumentModels, surfaceGlobalMinVol,
		resolvedProbeList, resolvedTemperatureCorrectionList, acquisitionTimeConflictBool,
		temperatureCorrectionConflictBool,temperatureCorrectionLookup,

		targetContainers,resolvedAliquotOptions,
		incompatibleWInstrumentInputs,incompatibleWInstrumentOptions,noSuitableInstrumentInputs,immersionGlobalMinReach,
		incompatibleWInstrumentTests,noSuitableInstrumentTests,invalidLowHighpHOptions,invalidLowHighpHTest,
		temperatureCorrectionConflictOptions, temperatureCorrectionTests,

		(*for final resolution*)
		resolvedInstrumentModelPackets,minVolumeInstrument,resolvedProbePackets,minVolumeContainer,minDepth,displacedVolume,
		calibrationFunction,minDepthToVolume,minVolume,requiredAliquotAmounts,
		name, confirm, canaryBranch, template, samplesInStorageCondition, originalCache, operator, parentProtocol, upload, outputOption, email, imageSample,resolvedEmail,resolvedImageSample,
		surfaceRecoupWarningSamples, numberOfReplicates,allTests,testsRule,resolvedOptions,resultRule,resolvedPostProcessingOptions,
		recoupAliquotConflictBool, recoupAliquotConflictOptions, recoupAliquotConflictTests, recoupProbeConflictTest, simulation
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine whether this function is just for internal usage (for AdjustpH) or not *)
	internalUsage = OptionValue[InternalUsage];
	internalUsageQ = MatchQ[internalUsage, True];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation,Simulation[]];

	(*There is a chance that the container has no volume calibration. Remove such and check if we can resolve SamplePrepOptions*)
	cacheFailedRemoved = Cases[cache,Except[$Failed]];

	(* Separate out our MeasurepH options from our Sample Prep options. *)
	{samplePrepOptions,measurepHOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation}=resolveSamplePrepOptionsNew[ExperimentMeasurepH,mySamples,samplePrepOptions,Simulation -> simulation, Cache->cacheFailedRemoved(*cache*)];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	measurepHOptionsAssociation = Association[measurepHOptions];

	(* Get all non deprecated pH models including the developer ones, for testing purposes. *)
	pHInstrumentsModels=Search[Model[Instrument,pHMeter],Deprecated!=True];

	(*check if the user supplied a instrument that's not in our list (e.g. a developer object)*)
	{instrumentLookup,probeLookup}=Lookup[myOptions,{Instrument,Probe}];

	(* Get our NumberOfReplicates option. *)
	numberOfReplicates=Lookup[myOptions,NumberOfReplicates]/.{Null->1};

	(* Get our ConsolidateAliquots option. Replace Automatic with False since this is how it'll be resolved in the aliquot resolver. *)
	consolidateAliquots=Lookup[myOptions,ConsolidateAliquots]/.{Automatic->False};

	(* Get our AcquisitionTime option. *)
	acquisitionTimeLookup=Lookup[myOptions,AcquisitionTime];

	(* Get any objects that were specified in the instrument list. *)
	specifiedInstrumentObjects=Cases[instrumentLookup,ObjectP[Object[Instrument,pHMeter]]];
	specifiedProbeObjects=Cases[probeLookup,ObjectP[Object[Part,pHProbe]]];
	specifiedProbeModels=Cases[probeLookup,ObjectP[Model[Part,pHProbe]]];

	(* Get all the potential preferred containers*)
	potentialContainers=preferredpHContainer[All];

	(*obtain other needed look ups*)
	aliquotContainerLookup=Lookup[myOptions,AliquotContainer];

	(*if it's a compatible type, then add to the download*)
	potentialContainersWAliquot=If[MatchQ[aliquotContainerLookup,measurepHContainerModelsP],Union[potentialContainers,{aliquotContainerLookup}],potentialContainers];

	(* Lookup our reference buffers. *)
	referenceBuffers=Lookup[myOptions,{LowCalibrationBuffer,MediumCalibrationBuffer,HighCalibrationBuffer}]/.{Null->Nothing};

	objectSamplePacketFields=Packet@@Union[Flatten[{pH,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}]];

	washSolution={Lookup[myOptions,WashSolution]};


	(* Extract the packets that we need from our downloaded cache. *)
	allDownloadValues=Replace[Quiet[
		Download[
			{
				simulatedSamples,
				pHInstrumentsModels,
				specifiedInstrumentObjects,
				specifiedProbeObjects,
				specifiedProbeModels,
				potentialContainersWAliquot,
				Cases[referenceBuffers,ObjectP[Object[Sample]]],
				Cases[referenceBuffers,ObjectP[Model[Sample]]],
				washSolution
			},
			{
				{
					objectSamplePacketFields,
					Packet[Container[Model][{Name,VolumeCalibrations,MaxVolume, Aperture, Dimensions, IncompatibleMaterials, WellDiameter, WellDimensions}]],
					Packet[Container[Model][VolumeCalibrations][{LiquidLevelDetectorModel,CalibrationFunction,DateCreated}]]
				},
				{
					Packet[Name,Object,Objects,WettedMaterials,Dimensions,ProbeLengths,ProbeDiameters,MinpHs,MaxpHs,MinDepths,MinSampleVolumes,ProbeTypes,TemperatureCorrection,AcquisitionTimeControl],
					Packet[AssociatedAccessories[[All, 1]][{Object,ProbeType,ShaftLength,ShaftDiameter,MinSampleVolume,MinpH,MaxpH,MinDepth,WettedMaterials,SupportedInstruments}]]
				},
				{
					Packet[Name,Model],
					Packet[Model[{Name,Object,Objects,WettedMaterials,Dimensions,ProbeLengths,ProbeDiameters,MinpHs,MaxpHs,MinDepths,MinSampleVolumes,ProbeTypes,TemperatureCorrection,AcquisitionTimeControl}]],
					Packet[Model[AssociatedAccessories[[All, 1]][{Object,ProbeType,ShaftLength,ShaftDiameter,MinSampleVolume,MinpH,MaxpH,MinDepth,WettedMaterials,SupportedInstruments}]]]
				},
				{
					Packet[Name,Model],
					Packet[Model[{Object,ProbeType,ShaftLength,ShaftDiameter,MinSampleVolume,MinpH,MaxpH,MinDepth,WettedMaterials,SupportedInstruments}]]
				},
				{
					Packet[Object,ProbeType,ShaftLength,ShaftDiameter,MinSampleVolume,MinpH,MaxpH,MinDepth,WettedMaterials,SupportedInstruments]
				},
				{
					Packet[Name, MaxVolume, Aperture, Dimensions, WellDiameter, WellDimensions],
					Packet[VolumeCalibrations[{LiquidLevelDetectorModel,CalibrationFunction,DateCreated}]]
				},
				{
					Packet[pH,TransportTemperature,Name,Deprecated,Sterile,LiquidHandlerIncompatible,Tablet,SolidUnitWeight,State]
				},
				{
					Packet[pH,TransportTemperature,Name,Deprecated,Sterile,LiquidHandlerIncompatible,Tablet,SolidUnitWeight,State]
				},
				{
					Packet[Model,Volume]
				}
			},
			Cache -> cacheFailedRemoved,
			Simulation -> updatedSimulation
		]
	],$Failed->Nothing,1];
	(*split the download packet based on object type*)
	{
		allSampleDownloadValues,
		allInstrumentModelDownloadValues,
		allInstrumentObjDownloadValues,
		allProbeObjectDownloadValues,
		allProbeModelDownloadValues,
		potentialContainerDownloadValues,
		referenceObjectDownloadValues,
		referenceModelDownloadValues,
		washSolutionDownloadValues
	}=allDownloadValues;

	(*pull out all the sample/sample model/container/container model packets*)
	samplePackets=allSampleDownloadValues[[All,1]];
	containerModelPackets=allSampleDownloadValues[[All,2]];
	volumeCalibrationPackets=allSampleDownloadValues[[All,3]];

	(*only consider the calibration packets with a liquid level monitor*)
	latestVolumeCalibrationPacket=Map[If[Length[#]>0,FirstCase[#,KeyValuePattern[LiquidLevelDetectorModel->Except[Null]]],Null]&,volumeCalibrationPackets];

	(*combine the calibration information into the container model packets.*)
	combinedContainerPackets=MapThread[If[Not[NullQ[#2]],
		Append[#1,CalibrationFunction->Lookup[#2,CalibrationFunction]],
		Append[#1,CalibrationFunction->Null]
		]&,
		{containerModelPackets,latestVolumeCalibrationPacket}
	];

	(*pull out the instrument object/model information*)
	instrumentModelPackets=allInstrumentModelDownloadValues[[All,1]];
	instrumentObjectPackets=allInstrumentObjDownloadValues[[All,1]];

	(*if the user specified objects*)

	(*pull out the potential container information*)
	potentialContainerPackets=potentialContainerDownloadValues[[All,1]];
	potentialContainerModelPackets=potentialContainerDownloadValues[[All,2]];

	(*get the latest calibration for the potential containers*)
	firstPotentialCalibration=Map[
		If[Length[#]>0,
			Last[
				Cases[#,KeyValuePattern[LiquidLevelDetectorModel->Except[Null]]]
			],
			Null
		]&,
		potentialContainerModelPackets
	];

	(*combine the calibration information into the packet*)
	combinedPotentialContainerPackets=MapThread[If[Not[NullQ[#2]],
		Append[#1,CalibrationFunction->Lookup[#2,CalibrationFunction]],
		Append[#1,CalibrationFunction->Null]
		]&,
		{potentialContainerPackets,firstPotentialCalibration}];

	(*-- INPUT VALIDATION CHECKS --*)

	(* DISCARDED SAMPLES *)

	(* Get a boolean for which samples are discarded *)
	discardedSampleBool=Map[
		If[NullQ[#],
			False,
			MatchQ[#,KeyValuePattern[Status->Discarded]]
		]
				&,samplePackets];

	(* Get the sample packets that are discarded. *)
	discardedSamplePackets=PickList[samplePackets,discardedSampleBool,True];

	(*  keep track of the invalid inputs *)
	discardedInvalidInputs=If[Length[discardedSamplePackets]>0,
		Lookup[Flatten[discardedSamplePackets],Object],
	(* if there are no discarded inputs, the list is empty *)
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
			(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[discardedInvalidInputs,Simulation -> updatedSimulation]<>" is/are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
			(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs],Simulation -> updatedSimulation]<>" is/are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* DEPRECATED INSTRUMENT *)

	deprecatedInstrumentQ=If[MemberQ[instrumentLookup,ObjectP[Model[Instrument]]],
		!IntersectingQ[pHInstrumentsModels,Download[Cases[instrumentLookup,ObjectP[Model[Instrument]]],Object]],
		False
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[deprecatedInstrumentQ&&!gatherTests,
		Message[Error::DeprecatedInstrumentModel,ObjectToString[instrumentLookup,Simulation -> updatedSimulation]]
	];

	deprecatedInstrumentOptions=If[deprecatedInstrumentQ,{Instrument},{}];

	deprecatedInstrumentTest=If[gatherTests,
		Test["If the Instrument is specified, then it is not deprecated:",
			deprecatedInstrumentQ,
			False
		],
		Nothing
	];

	(* INCOMPATIBLE SAMPLE *)

	(*2a. Check if sample is compatible with all available instruments*)

	(*generate the material compatibility combination of instruments and samples*)
	sampleInstrumentCombinations=Map[{#,samplePackets}&,instrumentModelPackets];

	(*get boolean for which sample/instrument combinations are incompatible (based on material and pH). *)
	incompatibleBool=Map[compatiblepHMeterQ[First[#],Last[#], Cache -> cache, Simulation -> updatedSimulation, OutputFormat -> Boolean]&,sampleInstrumentCombinations];

	(*arrange into matrix where each column is the sample and the rows are the instruments*)
	incompatibleBoolMatrix=Map[Not,incompatibleBool,{2}];

	(*check to see if any of the samples are compatible with no instrument*)
	incompatibleInputsBool=Map[And@@#&,Transpose[incompatibleBoolMatrix]];

	(*2b. If the user specifies an instrument, need to make sure that the sample is compatible with specified instrument model*)
	(*if the user specified an object, we take the model. *)
	instrumentLookupModels=Map[
		If[MatchQ[#,ObjectP[Object[Instrument]]],
			Lookup[fetchPacketFromCache[#,instrumentObjectPackets],Model]/.{link_Link:>Download[link, Object]},
			#
		]&,
		instrumentLookup
	];
	
	(*now get the model packets for each instrument *)
	instrumentLookupModelPackets=Map[
		If[MatchQ[#,ObjectP[Model[Instrument]]],
			fetchPacketFromCache[#,instrumentModelPackets],
			#
		]&,
		instrumentLookupModels
	];

	probeLookupModels=Map[
		If[MatchQ[#,ObjectP[Object[Part]]],
			Lookup[fetchPacketFromCache[#,cache],Model]/.{link_Link:>Download[link,Object]},
			#
		]&,
		probeLookup
	];

	(*now get the model packets for each probe model *)
	probeLookupModelPackets=Map[
		If[MatchQ[#,ObjectP[Model[Part]]],
			fetchPacketFromCache[#,cache],
			#
		]&,
		probeLookupModels
	];

	(*see if the model is incompatible with the given sample*)

	incompatibleWithInstrumentBool=MapThread[
		Which[
			MatchQ[#1,ObjectP[Model[Part,pHProbe]]], Not[compatiblepHMeterQ[#1,#3,Cache -> cache, Simulation -> updatedSimulation]],
			MatchQ[#2,ObjectP[Model[Instrument,pHMeter]]], Not[compatiblepHMeterQ[#2,#3,Cache -> cache, Simulation -> updatedSimulation]],
			True,False
		]&,
		{probeLookupModelPackets,instrumentLookupModelPackets,samplePackets}
	];

	(*get the samples that are incompatible with any instrument*)
	incompatibleInputsAnyInstrument=PickList[Lookup[samplePackets,Object],incompatibleInputsBool];

	(* If there are incompatible samples and we are throwing messages, throw an error message *)
	If[Length[incompatibleInputsAnyInstrument]>0&&!gatherTests,
	 Message[Error::IncompatibleSample,ObjectToString[incompatibleInputsAnyInstrument,Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleInputsAnyInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleInputsAnyInstrument]==0,
				(* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[incompatibleInputsAnyInstrument,Simulation -> updatedSimulation]<>" is/are chemically compatible with an available pH Meter:",True,False]
			];
			passingTest=If[Length[incompatibleInputsAnyInstrument]==Length[simulatedSamples],
				(* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,incompatibleInputsAnyInstrument],Simulation -> updatedSimulation]<>" is/are chemically compatible with an available pH Meter:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*get the samples that are incompatible with the specified instrument*)
	incompatibleInputsSpecificInstrument=PickList[Lookup[samplePackets,Object],incompatibleWithInstrumentBool];

	(* If it is compatible with specific instrument, throw an error *)
	incompatibleInputsSpecificInstrumentOptions=If[Length[incompatibleInputsSpecificInstrument]>0&&!gatherTests,
		Message[Error::IncompatibleSampleInstrument,ObjectToString[incompatibleInputsSpecificInstrument,Simulation -> updatedSimulation],ObjectToString[PickList[instrumentLookup,incompatibleWithInstrumentBool],Simulation -> updatedSimulation]];
		{Instrument},
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleInputsSpecificInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleInputsSpecificInstrument]==0,
				(* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[incompatibleInputsSpecificInstrument,Simulation -> updatedSimulation]<>" is/are chemically compatible with the specified pH Meter, if it indeed was specified:",True,False]
			];
			passingTest=If[Length[incompatibleInputsSpecificInstrument]==Length[simulatedSamples],
				(* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,incompatibleInputsSpecificInstrument],Simulation -> updatedSimulation]<>" is/are chemically compatible with the specified pH Meter, if it indeed was specified:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];


	(*We only allow robotic mode in AdjustpH,so if InternalUsage is not Ture,give a conflict for given model/object of Model[Instrument,pHMeter,"SevenExcellence (for pH) for Robotic Titration"]*)
	incompatibleRoboticInstrumentBool = If[!internalUsageQ,
		MapThread[
			Which[
				MatchQ[#1,ObjectP[Model[Instrument,pHMeter]]],MatchQ[#1, ObjectP[Model[Instrument, pHMeter, "id:R8e1PjeAn4B4"]]],
				MatchQ[#1,ObjectP[Object[Instrument,pHMeter]]], MatchQ[#2, ObjectP[Model[Instrument, pHMeter, "id:R8e1PjeAn4B4"]]],
				True,False
			]&,
			{instrumentLookup,instrumentLookupModels}
		],
		ConstantArray[False, Length[samplePackets]]
	];
	(*get the samples that correspond to incompatible robotic instrument*)
	incompatibleInputsRoboticInstrument=PickList[Lookup[samplePackets,Object],incompatibleRoboticInstrumentBool];

	(* If there are samples specified with robotic instrument but not in AdjustpH, throw an error *)
	incompatibleInputsRoboticInstrumentOptions=If[Length[incompatibleInputsRoboticInstrument]>0&&!gatherTests,
		Message[Error::IncompatibleRoboticInstrument,ObjectToString[incompatibleInputsRoboticInstrument,Simulation -> updatedSimulation],ObjectToString[PickList[instrumentLookup,incompatibleRoboticInstrumentBool],Simulation -> updatedSimulation]];
		{Instrument},
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleInputsRoboticInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleInputsRoboticInstrument]==0,
				(* when not a single sample is given robotic pHMeter, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[incompatibleInputsRoboticInstrument,Simulation -> updatedSimulation]<>" can not use pH Meter that is under robotic mode unless in AdjustpH:",True,False]
			];
			passingTest=If[Length[incompatibleInputsRoboticInstrument]==Length[simulatedSamples],
				(* when ALL samples are given robotic pHMeter, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,incompatibleInputsRoboticInstrument],Simulation -> updatedSimulation]<>" can not use pH Meter that is under robotic mode unless in AdjustpH:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*3. Check VOLUME is not null.*)

	(*find the packets where Volume==Null*)
	volumeMeasuredBool=Map[NullQ,Lookup[samplePackets,Volume]];

	(*get the packets with no volume and where measure==False*)
	noVolumePackets=PickList[samplePackets,volumeMeasuredBool,True];

	(*get the inputs with no volume*)
	noVolumeInputs=If[Length[noVolumePackets]>0,
		Lookup[Flatten[noVolumePackets],Object],
		(* if there are no discarded inputs, the list is empty *)
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noVolumeInputsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[noVolumeInputs]==0,
				(* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[noVolumeInputs,Simulation -> updatedSimulation]<>" have an associated volume value:",True,False]
			];
			passingTest=If[Length[noVolumeInputs]==Length[simulatedSamples],
				(* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,noVolumeInputs],Simulation -> updatedSimulation]<>" have an associated volume value:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*throw the error if we're not gathering tests*)
	If[Length[noVolumeInputs]>0&&!gatherTests,
		Message[Error::NoVolume,ObjectToString[noVolumeInputs,Simulation -> updatedSimulation]]
	];

	(*CHECK INSTRUMENT AND PROBETYPE CONFLICT*)

	(*look up the instrument type if the user specified it*)
	probeTypeLookup=Lookup[myOptions,ProbeType];

	(*get the probetype of the instrument model inputs*)
	instrumentTypeLookup=Map[If[MatchQ[#,ObjectP[Model[Instrument,pHMeter]]],Lookup[#,ProbeTypes],Null]&,instrumentLookupModelPackets];

	(*check where there is a conflict and indicate true if so*)
	probeInstrumentBool=MapThread[If[And[MatchQ[#1,{pHProbeTypeP..}],MatchQ[#2,pHProbeTypeP]],Not[MemberQ[#1,#2]],False]&,{instrumentTypeLookup,probeTypeLookup}];

	(*find inputs where the conflict occurs*)
	probeInstrumentConflictInputs=PickList[samplePackets,probeInstrumentBool,True];

	(*keep track of the invalid options*)

	probeInstrumentConflictOptions=If[Length[probeInstrumentConflictInputs]>0&&!gatherTests,
		Message[Error::ConflictingInstrumentProbeType,ObjectToString[probeInstrumentConflictInputs,Simulation -> updatedSimulation]];
		{Instrument,ProbeType},
		{}
	];

	(* 4. LOW VOLUME SAMPLES *)

	(*lookup the lowest volume from the instrument model packets*)
	minVolumeLookup=Flatten[Lookup[instrumentModelPackets,MinSampleVolumes],1];

	(*get the lowest possible volume for measurement*)
	lowestVolume=Min[Cases[minVolumeLookup,GreaterP[0 Milli Liter]]];

	(*get a boolean for which samples are low volume*)
	lowVolumeBool=Map[
		If[NullQ[#],False,MatchQ[Lookup[#,Volume],LessP[lowestVolume]]] &,
		samplePackets];

	(*get the packets that are low volume*)
	lowVolumePackets=PickList[samplePackets,lowVolumeBool,True];

	(*  keep track of the invalid inputs *)
	lowVolumeInvalidInputs=If[Length[lowVolumePackets]>0,
		Lookup[Flatten[lowVolumePackets],Object],
		(* if there are no discarded inputs, the list is empty *)
		{}
	];

	(* If there are low volumes and we are throwing messages, throw an error message *)
	If[Length[lowVolumeInvalidInputs]>0&&!gatherTests,
		Message[Error::InsufficientVolume,ObjectToString[lowVolumeInvalidInputs,Simulation -> updatedSimulation],ObjectToString[lowestVolume]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	lowVolumeInputsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[lowVolumeInvalidInputs]==0,
				(* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[lowVolumeInvalidInputs,Simulation -> updatedSimulation]<>" do have sufficient volume for measurement:",True,False]
			];
			passingTest=If[Length[noVolumeInputs]==Length[simulatedSamples],
				(* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,lowVolumeInvalidInputs],Simulation -> updatedSimulation]<>" do have sufficient volume for measurement:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];


	(*5. LOW ALIQUOT VOLUME SAMPLES*)

	(*get all of the aliquot option names -- AliquotPreparation,ConsolidateAliquots are impertinent *)
	aliquotOptionNames=Complement[Map[ToExpression,Keys@Options[AliquotOptions]],{AliquotPreparation,ConsolidateAliquots}];

	(*get the aliquot options for each sample*)
	aliquotTuples=MapThread[List,Lookup[samplePrepOptions,aliquotOptionNames]];

	(*check get the Aliquot option value*)
	aliquotLookup=Lookup[samplePrepOptions,Aliquot];

	(*If any of the aliquot options were set positively, then this should be true*)
	(*of if recoup sample was set true, then should be set*)
	aliquotBool=MapThread[
		Function[{aliquotOptionsGroup,recoupSampleQ, aliquotQ},
			If[MatchQ[aliquotQ,Automatic],
				Or[
					MemberQ[aliquotOptionsGroup, Except[False | Null | Automatic]],
					recoupSampleQ
				],
				aliquotQ
			]
		],
		{
			aliquotTuples,
			Lookup[measurepHOptionsAssociation,RecoupSample],
			aliquotLookup
		}
	];

	(*check if there is a conflict between recoup sample and aliquot*)
	recoupAliquotConflictBool=MapThread[
		Function[{aliquotQ,recoupSampleQ},
			And[MatchQ[aliquotQ,False],recoupSampleQ]
		],
		{
			aliquotLookup,
			Lookup[measurepHOptionsAssociation,RecoupSample]
		}
	];

	recoupAliquotConflictOptions=If[Or@@recoupAliquotConflictBool,
		Message[Error::RecoupSampleAliquotConflict];
		{RecoupSample,Aliquot},
		{}
	];

	recoupAliquotConflictTests=If[gatherTests,
		Test["If RecoupSample is True, Aliquot is not False:",
			Or@@recoupAliquotConflictBool,
			False
		],
		Nothing
	];

	(*Look up the AliquotAmount or take the Assay Volume if that's specified instead*)
	aliquotVolumeLookup= MapThread[
	Function[{assayVolume,aliquotAmount},
	  If[MatchQ[assayVolume,GreaterP[0*Milliliter]],
		assayVolume,
		aliquotAmount
	  ]
	],Lookup[samplePrepOptions, {AssayVolume, AliquotAmount}]
	];

	(*-- OPTION PRECISION CHECKS --*)

	(* There are no option precision checks beyond what is done in the Shared options *)

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(*define some needed globals first*)
	(* look at immersion instruments *)
	immersionInstrumentModels=Select[instrumentModelPackets,MemberQ[Lookup[#,ProbeTypes],Immersion]&];

	probePropertyFunction[modelPacket_,field_,probeType:(Surface|Immersion)]:=If[MatchQ[Lookup[modelPacket,field],{}],
		{},
		PickList[
			Lookup[modelPacket,field],
			Lookup[modelPacket,ProbeTypes],
			probeType
		]
	];

	(*Look up the global minimum depth from the immersion instrument models provided*)
	immersionGlobalMinDepth=Min[Cases[Map[probePropertyFunction[#,MinDepths,Immersion]&,immersionInstrumentModels],GreaterP[0 Millimeter],2]];

	(*look up the global minimum reach for the immersion instrument models provided*)
	immersionGlobalMinReach=Min[Cases[Map[probePropertyFunction[#,ProbeLengths,Immersion]&,immersionInstrumentModels],GreaterP[0 Millimeter],2]];

	(*Look up the global minimum volume for the immersion instrument models provided*)
	immersionGlobalMinVol=Min[Cases[Map[probePropertyFunction[#,MinSampleVolumes,Immersion]&,immersionInstrumentModels],GreaterP[0 Milliliter],2]];

	(* look at surface instruments *)
	surfaceInstrumentModels=Select[instrumentModelPackets,MemberQ[Lookup[#,ProbeTypes],Surface]&];

	(*Look up the global minimum volume for the surface instrument models provided*)
	surfaceGlobalMinVol=Min[Cases[Map[probePropertyFunction[#,MinSampleVolumes,Surface]&,surfaceInstrumentModels],GreaterP[0 Milliliter],2]];

	(*look up the replicate information*)
	numberOfReplicates=Lookup[myOptions,NumberOfReplicates];

	(* Lookup our instrument option. *)
	instruments=Lookup[myOptions,Instrument];

	{temperatureCorrectionLookup}=Lookup[measurepHOptionsAssociation,{TemperatureCorrection}];

	(* Resolve our pH target values based on our reference buffers. *)
	{lowBufferLookup,mediumBufferLookup,highBufferLookup}=Download[Lookup[myOptions,{LowCalibrationBuffer,MediumCalibrationBuffer,HighCalibrationBuffer}],Object];

	(* From our buffer models, get the pH values, if found in the packet. *)
	lowpHValue=Lookup[fetchPacketFromCache[lowBufferLookup,cache],pH];
	mediumpHValue=If[MatchQ[mediumBufferLookup,Null],
		Null,
		Lookup[fetchPacketFromCache[mediumBufferLookup,cache],pH]
	];
	highpHValue=Lookup[fetchPacketFromCache[highBufferLookup,cache],pH];

	(* Lookup our given pH values. If they are conflicting, set an error. *)
	{resolvedLowpHValue,invalidLowpHValueOptions}=If[MatchQ[Lookup[myOptions,LowCalibrationBufferpH],Except[Automatic]],
		If[!Equal[Lookup[myOptions,LowCalibrationBufferpH],lowpHValue]&&!MatchQ[lowpHValue,Null],
			{Lookup[myOptions,LowCalibrationBufferpH],LowCalibrationBufferpH},
			{Lookup[myOptions,LowCalibrationBufferpH],{}}
		],
		{lowpHValue,{}}
	];

	(* Lookup our given pH values. If they are conflicting, set an error. *)
	{resolvedMediumpHValue,invalidMediumpHValueOptions}=If[MatchQ[Lookup[myOptions,MediumCalibrationBufferpH],Except[Automatic]],
		If[!Equal[Lookup[myOptions,MediumCalibrationBufferpH],mediumpHValue]&&!MatchQ[lowpHValue,Null],
			{Lookup[myOptions,MediumCalibrationBufferpH],MediumCalibrationBufferpH},
			{Lookup[myOptions,MediumCalibrationBufferpH],{}}
		],
		{mediumpHValue,{}}
	];

	(* Lookup our given pH values. If they are conflicting, set an error. *)
	{resolvedHighpHValue,invalidHighpHValueOptions}=If[MatchQ[Lookup[myOptions,HighCalibrationBufferpH],Except[Automatic]],
		If[!Equal[Lookup[myOptions,HighCalibrationBufferpH],highpHValue]&&!MatchQ[highpHValue,Null],
			{Lookup[myOptions,HighCalibrationBufferpH],HighCalibrationBufferpH},
			{Lookup[myOptions,HighCalibrationBufferpH],{}}
		],
		{highpHValue,{}}
	];

	(*indicate the nonstandard calibration being used *)
	nonstandardCalibrantsQ=If[!MemberQ[{lowpHValue,mediumpHValue,highpHValue},Null],
		!And[ MatchQ[resolvedLowpHValue,RangeP[3.99,4.02]], MatchQ[resolvedMediumpHValue,RangeP[6.99,7.01]], MatchQ[resolvedHighpHValue,RangeP[9.99,10.02]]],
		True
	];

	(*define the default instrument if available*)
	defaultInstrument= Which[
		nonstandardCalibrantsQ,Download[Model[Instrument, pHMeter, "Mettler Toledo InLab Micro"], Object],
		True,Download[Model[Instrument, pHMeter, "SevenExcellence (for pH)"], Object]
	];

	(* Convert our options into a MapThread friendly version. *)
	{
		aliquotVolumeList,
		potentialAliquotContainersList,
		instrumentList,
		probeTypeList,
		resolvedProbeList,
		acquisitionTimeList,
		resolvedTemperatureCorrectionList,
		incompatibleWInstrumentErrorList,
		noSuitableInstrumentErrorList,
		acquisitionTimeConflictBool,
		temperatureCorrectionConflictBool,
		pHProbeConflictBool
	}=Transpose[MapThread[
		Function[
			{
				samplePacket,
				sampleContainerPacket,
				aliquotVolume,
				instrumentPacket,
				rawInstrument,
				aliquotOption,
				aliquotContainer,
				probe,
				probeType,
				probeModelPacket,
				acquisitionTime,
				temperatureCorrection,
				incompatibleInputBool,
				alreadyIncompatibleWithInstrumentQ
			},
			Module[{instrumentProbeType,resolvedProbeType,workingVolume,workingContainerPacket,selectedContainer,selectedCalibration,
				minimumVolumeRequired,aliquotContainerResolve,incompatibleWInstrumentError,noSuitableInstrumentsError,instrument,aliquotVolumeRes,instrumentModelRes,instrumentSelectionProblems,
				resolvedAcquisitionTime,resolvedInstrument,probeResolution, resolvedInstrumentModelPacket, resolvedTemperatureCorrection, defaultInstrumentQ,
				temperatureCorrectionConflictQ, acquisitionTimeConflictQ, pHProbeConflictQ, defaultVolume},

				(*MASTER SWITCH RESOLUTION*)

				(* try to get the instrument probe type to use in our probe resolution *)
				(* if the instrument has only one probe type we'll know that's the desired probe type *)
				instrumentProbeType=If[MatchQ[instrumentPacket,ObjectP[Model[Instrument,pHMeter]]],
					If[MatchQ[Length[Lookup[instrumentPacket, ProbeTypes]],1],
						First[Lookup[instrumentPacket, ProbeTypes]],
						Null
					],
					Null
				];

				(*Were we given an instrument ProbeType?*)
				resolvedProbeType=Which[
					(* we can resolve based on the instrument probe *)
					MatchQ[instrumentProbeType,pHProbeTypeP],instrumentProbeType,
					(* were we directly given a probe to use? *)
					MatchQ[probeModelPacket,PacketP[]],Lookup[probeModelPacket,ProbeType],
					(* Were we given an explicit probe type? *)
					MatchQ[probeType,pHProbeTypeP], probeType,
					(* Sample volume or aliquot volume is too small for immersion probe *)
					(* Use Surface probe to read droplets *)
					(* Use TrueQ and Quiet in case we have no volume info at all (we will have already thrown an error) *)
					TrueQ[Quiet[Min[Cases[{aliquotVolume,Lookup[samplePacket,Volume]},VolumeP]]<immersionGlobalMinVol,Less::nord2]],Surface,
					True, Immersion
				];

				(*INDIVIDUAL RESOLUTION*)

				(* do our preselection of the instrument *)
				(*if one was specified, then go with that*)
				instrument=Which[
					MatchQ[instrumentPacket,ObjectP[Model[Instrument,pHMeter]]], Lookup[instrumentPacket,Object],
					(*if the user wants temperature correct, then we go with that*)
					True,Null
				];

				(* Resolve several options based on our resolved probe type. *)
				(* Resolve aliquot and instrument options. *)
				{aliquotVolumeRes,aliquotContainerResolve,instrumentModelRes,probeResolution,instrumentSelectionProblems}= Module[{desiredAliquotVolume,resolvedAliquotVolume,resolvedAliquotContainer,resolvedContainerPacket,relevantInstrumentModels,resolvedInstrument,instrumentResolutionProblems,
							returnedInstruments,returnedProbeLists,issuesWInstruments,resolvedProbe, instrumentModelPreselectionPackets,volumeToPass,
							defaultProbe,secondInstrumentPreselectionPackets},
							(* Pre-resolve AliquotVolume and AliquotContainer based on the information that we were given. *)
							{desiredAliquotVolume,resolvedAliquotContainer}= If[aliquotOption,
								Switch[{resolvedProbeType,MatchQ[aliquotVolume, GreaterP[0 Milliliter]], MatchQ[aliquotContainer, ObjectP[{Object[Container], Model[Container]}]]},
									(*if specified both, then that's our resolution*)
									{Surface|Immersion, True, True}, {aliquotVolume, aliquotContainer},
									(*if only volume specified, find an appropriate container based on the specified volume*)
									{Surface|Immersion, True, False}, {aliquotVolume, preferredpHContainer[aliquotVolume]},
									(*if only the container specified, or if nothing is specified, find the volume based on the calibration function, if it exists*)
									{Immersion, False, _},
										Module[{containerPacket, calibrationFunction, bestVolume, containerHeight, minHeight},
											(*extract the packet *)
											(* if no container was specified, send in 1 microliter so we get our smallest standard container *)
											containerPacket = If[MatchQ[aliquotContainer,ObjectP[]],
												First@Cases[combinedPotentialContainerPackets, KeyValuePattern[Object -> ObjectP[Download[aliquotContainer, Object]]]],
												First@Cases[combinedPotentialContainerPackets, KeyValuePattern[Object -> ObjectP[preferredpHContainer[1 Microliter]]]]
											];
											(*Lookup the calibration function*)
											calibrationFunction = Lookup[containerPacket, CalibrationFunction];
											(*look up the height of the container*)
											containerHeight = Last@Lookup[containerPacket, Dimensions];
											(*get the minimum liquid height needed for all of the probes*)
											minHeight = containerHeight - immersionGlobalMinReach + immersionGlobalMinDepth;
											(*If there is a calibration function we'll use that. Otherwise, a fraction of the max volume. Always do larger than the allowed minimum of Immersion probe*)
											bestVolume = Max[
												If[Or[NullQ[calibrationFunction], calibrationFunction[immersionGlobalMinDepth] < 0 Milliliter],
													0.25 * Lookup[containerPacket, MaxVolume],
													Max[
														calibrationFunction[immersionGlobalMinDepth],
														calibrationFunction[minHeight]
													]
												],
												immersionGlobalMinVol
											];
											(* If we are consolidating aliquots, then we should only ask for bestVolume/NumberOfReplicates since the replicates will all be combined. *)
											If[consolidateAliquots,
												{N[bestVolume / numberOfReplicates], If[MatchQ[aliquotContainer,ObjectP[]],aliquotContainer,preferredpHContainer[bestVolume]]},
												{bestVolume, If[MatchQ[aliquotContainer,ObjectP[]],aliquotContainer,preferredpHContainer[bestVolume]]}
											]
										],
									{Surface, False, True},
										Module[{containerPacket,bestContainerVolume,bestVolume},
											(*extract the packet *)
											containerPacket = First@Cases[combinedPotentialContainerPackets, KeyValuePattern[Object -> ObjectP[Download[aliquotContainer, Object]]]];

											(* Fill the requested container if we can so long as it doesn't take too much of the user's input sample volume *)
											bestContainerVolume=Min[{Lookup[containerPacket, MaxVolume],.25*Lookup[samplePacket,Volume]}];

											(* Make sure we have enough volume for the surface probe, but try to make more generous aliquots if we can since we'll consume the surfaceGlobalMinVol *)
											bestVolume=Max[surfaceGlobalMinVol*1.1,bestContainerVolume];

											{bestVolume, aliquotContainer}
										],
									(*if neither are specified, default to a sensible volume volume and the appropriate container*)
									(* Immersion,False,False case has been covered earlier so really no reason to talk about that here again *)
									{Surface, False, False},
										(
											defaultVolume=Which[
												Lookup[samplePacket,Volume]>10Milliliter,1*Milliliter,
												MatchQ[resolvedProbeType,Immersion],immersionGlobalMinVol,
												(* TODO is there a better way of doing this? *)
												(* Leave the user with a good amount of sample left over if we can *)
												MatchQ[resolvedProbeType,Surface],If[surfaceGlobalMinVol*10>Lookup[samplePacket,Volume],
													Min[surfaceGlobalMinVol*10,Lookup[samplePacket,Volume]],
													Min[surfaceGlobalMinVol*5,Lookup[samplePacket,Volume]]
												]
											];
											{defaultVolume, preferredpHContainer[defaultVolume]}
										)
								],
								(*if not aliquoting, leave these Null*)
								{Null,Null}
							];

							(* We may have picked an aliquot volume without considering the sample volume. *)
							(* If we aren't working with a user requested volume update to use sample volume if we're trying to requesting an aliquot volume greater than sample volume *)
							(* This way pHDevices will throw the error and not the aliquot resolver about an option the user didn't set *)
							(* desiredAliquotVolume may be Null so use TrueQ to force evaluation *)
							resolvedAliquotVolume=If[!MatchQ[aliquotOption,VolumeP]&&TrueQ[desiredAliquotVolume>Lookup[samplePacket,Volume]],
								Lookup[samplePacket,Volume],
								desiredAliquotVolume
							];

							(*get the container pack corresponding to our container resolution*)
							resolvedContainerPacket=If[!NullQ[resolvedAliquotContainer],
								fetchPacketFromCache[resolvedAliquotContainer,combinedPotentialContainerPackets],
								sampleContainerPacket
							];

							(* Consider surface and immersion probe instruments - we will filter out based on probe type in the pHDevices function *)
							relevantInstrumentModels=DeleteDuplicates[Join[immersionInstrumentModels,surfaceInstrumentModels]];

							(*do a preselection of the instruments*)
							instrumentModelPreselectionPackets=Which[
								MatchQ[probe,ObjectP[Model[Part]]],
									Cases[relevantInstrumentModels,KeyValuePattern[Object->ObjectP[Download[Lookup[fetchPacketFromCache[Download[probe,Object],Flatten@allProbeModelDownloadValues],SupportedInstruments],Object]]] ],
								(*if temperature correction is desired, then we get the capable models*)
								MatchQ[temperatureCorrection,Except[Null|Automatic]],
									Cases[relevantInstrumentModels,KeyValuePattern[TemperatureCorrection->Except[Null|{}|{None}]]],
								MatchQ[acquisitionTime,Except[Automatic|Null]],
									Cases[relevantInstrumentModels,KeyValuePattern[AcquisitionTimeControl->True]],
								(*otherwise, we take everything*)
								True,relevantInstrumentModels
							];

							(*do another preselection -- we don't want the seven excellence if doing non-standard calibration*)
							secondInstrumentPreselectionPackets=If[nonstandardCalibrantsQ,
								DeleteCases[instrumentModelPreselectionPackets,KeyValuePattern[Object->ObjectP[Model[Instrument, pHMeter, "SevenExcellence (for pH)"]]]],
								instrumentModelPreselectionPackets
							];

							(*get the volume to send, if aliquotVolume send that; otherwise, send the sample volume*)
							volumeToPass=If[MatchQ[resolvedAliquotVolume,Automatic|Null],Lookup[samplePacket,Volume],resolvedAliquotVolume];

							{returnedInstruments,returnedProbeLists,issuesWInstruments}=pHDevices[
								samplePacket,
								volumeToPass,
								resolvedContainerPacket,
								If[MatchQ[instrument,ObjectP[{Object[Instrument,pHMeter],Model[Instrument,pHMeter]}]],
									{instrument},
									Lookup[secondInstrumentPreselectionPackets,Object]
								],
								If[MatchQ[probe,Automatic|Null],
									resolvedProbeType,
									probe
								],
								Cache -> cache,
								Simulation -> updatedSimulation
							];

							(*check if it's in the returned list*)
							defaultInstrumentQ=MemberQ[Download[returnedInstruments,Object],defaultInstrument];

							(*grab the probe if possible*)
							defaultProbe=If[defaultInstrumentQ&&!MatchQ[Flatten@returnedProbeLists,{}],
								Part[returnedProbeLists,First@FirstPosition[Download[returnedInstruments,Object],defaultInstrument],1]
							];

							(*Did the user specify the instrument, if so use that. Otherwise use the function.*)
							{resolvedInstrument,resolvedProbe,instrumentResolutionProblems}=If[MatchQ[instrument,ObjectP[{Object[Instrument,pHMeter],Model[Instrument,pHMeter]}]],
								If[Length[returnedInstruments]>0,
									{
										rawInstrument,
										If[!NullQ[probe], FirstOrDefault[First@returnedProbeLists]],
										{}
									},
									{rawInstrument,probe/.{Automatic->Null},issuesWInstruments}
								],
								If[Length[returnedInstruments]>0,
									If[defaultInstrumentQ,
										{defaultInstrument,defaultProbe,{}},
										{First[returnedInstruments],FirstOrDefault[First@returnedProbeLists],{}}
									],
									{Null,probe/.{Automatic->Null},issuesWInstruments}
								]
							];

							{resolvedAliquotVolume,resolvedAliquotContainer,resolvedInstrument,resolvedProbe,instrumentResolutionProblems}
						];

				resolvedInstrument=If[MatchQ[rawInstrument,Except[Automatic]],
					rawInstrument,
					(*if we don't have an instrument, use the default and throw errors later*)
					If[!NullQ[instrumentModelRes], instrumentModelRes, defaultInstrument]
				];

				(*get our resolved instrument packet*)
				resolvedInstrumentModelPacket=If[MatchQ[resolvedInstrument,ObjectP[Model[Instrument]]],
					fetchPacketFromCache[resolvedInstrument, cache],
					fetchPacketFromCache[Lookup[fetchPacketFromCache[instrumentModelRes,Flatten[allInstrumentObjDownloadValues]],Model], cache]
				];

				(* Resolve AcquisitionTime based on our resolved probe type. Resolve to 5 Second if Immersion/Surface *)
				(* Account for AcquisitionTimeControl->Null in our checks *)
				{resolvedAcquisitionTime,acquisitionTimeConflictQ}=If[MatchQ[acquisitionTime,Except[Automatic]],
					{
						acquisitionTime,
						If[MatchQ[acquisitionTime,Except[Null]],
							!TrueQ[Lookup[resolvedInstrumentModelPacket,AcquisitionTimeControl,True]],
							(* User doesn't want AcquisitionTimeControl - there's a conflict if instrument has it *)
							TrueQ[Lookup[resolvedInstrumentModelPacket,AcquisitionTimeControl,False]]
						]
					},
					Which[
						MatchQ[Lookup[resolvedInstrumentModelPacket,AcquisitionTimeControl,False],True],{5 Second,False},
						True,{Null,False}
					]
				];

				(*resolve the temperature correction based on specification and availability*)
				(*need to check to see if we have a conflict with the instrument capability*)
				{resolvedTemperatureCorrection,temperatureCorrectionConflictQ}=If[MatchQ[temperatureCorrection,Except[Automatic]],
					{
						temperatureCorrection,
						If[!NullQ[temperatureCorrection]||MatchQ[temperatureCorrection,Off],
							MatchQ[Lookup[resolvedInstrumentModelPacket, TemperatureCorrection], {} | Null | {None}]
						]
					},
					Which[
						MatchQ[Lookup[resolvedInstrumentModelPacket,TemperatureCorrection],Except[{}|Null|{None}]],{Linear,False},
						True,{Null,False}
					]
				];

				(*check if the user's chosen instrument worked*)
				incompatibleWInstrumentError=And[
					MatchQ[instrument,ObjectP[Model[Instrument,pHMeter]]],
					Or[Length[FirstOrDefault[instrumentSelectionProblems,{}]]>0,NullQ[instrumentModelRes]],
					Not[alreadyIncompatibleWithInstrumentQ]
				];

				(*check if there wasn't a suitable instrument, and that it's not due to chemical reasons or because it's too low globally*)
				noSuitableInstrumentsError=And[
					(*check if the instrument is null, or all of the associated probes are*)
					Or[
						NullQ[instrumentModelRes],
						If[!NullQ[instrumentModelRes],
							And[
								(Count[Lookup[resolvedInstrumentModelPacket, AssociatedAccessories],{ObjectP[Model[Part, pHProbe]], _}]>0),
								NullQ[probeResolution]
							],
							False
						]
					],
					(*we don't want to throw this error when any of the following errors are set or if the instrument was specified*)
					Not[MatchQ[instrument,ObjectP[Model[Instrument,pHMeter]]]],
					Not[incompatibleInputBool],
					Not[deprecatedInstrumentQ],
					MatchQ[Lookup[samplePacket,Volume],GreaterP[lowestVolume]]
				];

				(*see if the specified probe is not in the specified instrument or probe is Null and the instrument requires it*)
				pHProbeConflictQ=Or[
					MemberQ[instrumentSelectionProblems,"Probe not in the instrument"|"The specified instrument list is not compatible with the specified probe."],
					(Length[Flatten@instrumentSelectionProblems]==0)&&NullQ[probe]&&(Count[Lookup[resolvedInstrumentModelPacket, AssociatedAccessories],{ObjectP[Model[Part, pHProbe]], _}]>0)
				];

				{
					aliquotVolumeRes,
					aliquotContainerResolve,
					resolvedInstrument,
					resolvedProbeType,
					probeResolution,
					resolvedAcquisitionTime,
					resolvedTemperatureCorrection,
					incompatibleWInstrumentError,
					noSuitableInstrumentsError,
					acquisitionTimeConflictQ,
					temperatureCorrectionConflictQ,
					pHProbeConflictQ
				}
			]
		],
		(*Everything needed to resolve our experimental options.*)
		{
			samplePackets,
			combinedContainerPackets,
			aliquotVolumeLookup,
			instrumentLookupModelPackets,
			instruments,
			aliquotBool,
			aliquotContainerLookup,
			probeLookup,
			probeTypeLookup,
			probeLookupModelPackets,
			acquisitionTimeLookup,
			temperatureCorrectionLookup,
			incompatibleInputsBool,
			incompatibleWithInstrumentBool
		}
	]];

	(*DROPLET Aliquot warning -- If the user is telling us Aliquot\[Rule]False (explicitly) but ProbeType\[Rule]Surface, we're going to aliquot out into the droplet. Warn them that we're going to do this. *)

	(*Find where Surface and Aliquot conflict (Surface->True and Aliquot->False)*)
	surfaceAliquotConflictBool=MapThread[MatchQ[#1,Surface]&&MatchQ[#2,False]&,{probeTypeList,aliquotLookup}];

	(*Get the inputs where ProbeType is set to Surface and Aliquot is false*)
	surfaceAliquotConflictInputs=PickList[Lookup[samplePackets,Object],surfaceAliquotConflictBool];

	(*If there are inputs where these options are conflicting, specify the options*)
	If[Length[surfaceAliquotConflictInputs]>0&&!gatherTests&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::SurfaceAliquotConflict,ObjectToString[surfaceAliquotConflictInputs,Simulation -> updatedSimulation]];
	];

	(* Gather the invalid options. *)
	invalidpHOptions=Flatten[{invalidLowpHValueOptions,invalidMediumpHValueOptions,invalidHighpHValueOptions}];

	(* Throw an error if necessary. *)
	If[Length[invalidpHOptions]>0,
		Message[Error::ConflictingReferencepHValues,ObjectToString[invalidpHOptions,Simulation -> updatedSimulation]];
	];

	(* Create a test. *)
	matchingReferencepHTest=If[gatherTests,
		If[Length[invalidpHOptions]==0,
				Test["The given pHs of the reference buffers match the pH information in the Model[Sample], if available:",True,True],
				Test["The given pHs of the reference buffers match the pH information in the Model[Sample], if available:",True,False]
			],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* Make sure that the low and high pH options are not set to Null. *)
	invalidLowHighpHOptions=If[MatchQ[resolvedLowpHValue,Null]||MatchQ[resolvedHighpHValue,Null],
		Message[Error::LowAndHighpHValuesMustBeSpecified,ObjectToString[{resolvedLowpHValue,resolvedHighpHValue}]];
		{LowCalibrationBufferpH,HighCalibrationBufferpH},
		{}
	];

	invalidLowHighpHTest=If[gatherTests,
		If[MatchQ[resolvedLowpHValue,Null]||MatchQ[resolvedHighpHValue,Null],
				Test["The options LowCalibrationBufferpH and HighCalibrationBufferpH are both specified:",True,True],
				Test["The options LowCalibrationBufferpH and HighCalibrationBufferpH are both specified:",True,True,True,False]
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* Make sure that both MediumCalibrationBuffer and MediumCalibrationBufferpH are specified, if given. *)
	invalidMediumCalibrationOptions=If[(MatchQ[mediumBufferLookup,Null]&&MatchQ[resolvedMediumpHValue,Except[Null]])||(MatchQ[mediumBufferLookup,Except[Null]]&&MatchQ[resolvedMediumpHValue,Null]),
		{MediumCalibrationBuffer,MediumCalibrationBufferpH},
		{}
	];

	(* Throw an error if necessary. *)
	If[Length[invalidMediumCalibrationOptions]>0,
		Message[Error::MediumCalibrationOptionsRequiredTogether,ObjectToString[invalidMediumCalibrationOptions,Cache->cache]];
	];

	(* Create a test. *)
	mediumCalibrationpHTest=If[gatherTests,
		If[Length[invalidMediumCalibrationOptions]==0,
				Test["The options MediumCalibrationBuffer and MediumCalibrationBufferpH are either both specified or both not specified:",True,True],
				Test["The options MediumCalibrationBuffer and MediumCalibrationBufferpH are either both specified or both not specified:",True,False]
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	temperatureCorrectionConflictOptions=If[Or@@temperatureCorrectionConflictBool,
		Message[Error::TemperatureCorrectionConflict,ObjectToString@PickList[instrumentList,temperatureCorrectionConflictBool]];
		{Instrument,TemperatureCorrection},
		{}
	];

	temperatureCorrectionTests=If[gatherTests,
		Test["If TemperatureCorrection is set, then it's compatible with the instrument:",
			Or@@temperatureCorrectionConflictBool,
			False
		],
		Nothing
	];

	pHProbeConflictOptions=If[Or@@pHProbeConflictBool,
		Message[Error::pHProbeConflict,ObjectToString@PickList[resolvedProbeList,pHProbeConflictBool],ObjectToString@PickList[instrumentList,pHProbeConflictBool]];
		{Instrument,Probe},
		{}
	];

	pHProbeConflictTests=If[gatherTests,
		Test["If Probe and Instrument is set, then they're compatible:",
			Or@@pHProbeConflictBool,
			False
		],
		Nothing
	];

	(* Get the sample packets that are incompatible with a specified instrument and container. *)
	incompatibleWInstrumentInputs=PickList[Lookup[samplePackets,Object],incompatibleWInstrumentErrorList,True];

	(*check if incompatible with specified instrument and container*)
	incompatibleWInstrumentOptions=If[Length[incompatibleWInstrumentInputs]>0&&!gatherTests,
		Message[Error::IncompatibleInstrument,ObjectToString[incompatibleWInstrumentInputs,Simulation -> updatedSimulation],ObjectToString[PickList[instrumentLookup,incompatibleWInstrumentErrorList,True],Simulation -> updatedSimulation]];
		{Instrument,AliquotContainer},
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleWInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleWInstrumentInputs]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["If the input sample(s) "<>ObjectToString[incompatibleWInstrumentInputs,Simulation -> updatedSimulation]<>" have a specified Instrument, the instrument can physical reach the sample based on the aliquot options:",True,False]
			];
			passingTest=If[Length[incompatibleWInstrumentInputs]==Length[simulatedSamples],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["If the input sample(s) "<>ObjectToString[Complement[simulatedSamples,incompatibleWInstrumentInputs],Simulation -> updatedSimulation]<>" have a specified Instrument, the instrument can physical reach the sample based on the aliquot options:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* Get the sample packets that are physically incompatible with a specified instrument and container. *)
	(* don't double complain if we already indicated the instrument was deprecated *)
	noSuitableInstrumentInputs=If[deprecatedInstrumentQ,
		{},
		PickList[Lookup[samplePackets,Object],noSuitableInstrumentErrorList,True]
	];

	(* output an error if the container is too big for any instrument *)
	(* don't double complain if we already indicated the instrument was deprecated *)
	If[Length[noSuitableInstrumentInputs]>0&&!gatherTests&&!deprecatedInstrumentQ,
		Message[Error::NoAvailablepHInstruments,ObjectToString[noSuitableInstrumentInputs,Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noSuitableInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[noSuitableInstrumentInputs]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["If the input sample(s) "<>ObjectToString[noSuitableInstrumentInputs,Simulation -> updatedSimulation]<>" have specified options, there exists instruments meeting these options for both physical (e.g. probe reaching the liquid) and chemical reasons:",True,False]
			];
			passingTest=If[Length[noSuitableInstrumentInputs]==Length[simulatedSamples],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["If the input sample(s) "<>ObjectToString[Complement[simulatedSamples,noSuitableInstrumentInputs],Simulation -> updatedSimulation]<>" have specified options, there exists instruments meeting these options for both physical (e.g. probe reaching the liquid) and chemical reasons:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* -- Acquisition time and probe type conflict. -- *)

	(*get the resolved instrument model packets*)
	resolvedInstrumentModelPackets=Map[
		If[MatchQ[#,ObjectP[Object[Instrument]]],
			fetchPacketFromCache[Lookup[fetchPacketFromCache[#,cache],Model],cache],
			fetchPacketFromCache[#,cache]
		]&
		,instrumentList];

	(* AcquisitionTime must be specified when ProbeType->Immersion/Surface. *)
	acquisitionConflictResults=MapThread[
		Function[{sample,acquisitionTime,instrumentModelPacket,conflictQ},
			Which[
				conflictQ, {sample,acquisitionTime,Lookup[instrumentModelPacket,Object]},
				MatchQ[{acquisitionTime,Lookup[instrumentModelPacket,AcquisitionTimeControl,Ignore]},{TimeP,True}|{Null,False|Null}|{_,Ignore}], Nothing,
				True, {sample,acquisitionTime,Lookup[instrumentModelPacket,Object]}
			]
		],
		{mySamples,acquisitionTimeList,resolvedInstrumentModelPackets, acquisitionTimeConflictBool}
	];

	(* Gather the invalid inputs. *)
	acquisitionConflictInvalidInputs=If[Length[acquisitionConflictResults]>0,
		acquisitionConflictResults[[All,1]],
		{}
	];

	(* Gather the invalid options. *)
	acquisitionConflictInvalidOptions=If[Length[acquisitionConflictResults]>0,
		{AcquisitionTime,Instrument},
		{}
	];

	(* Throw an error if needed. *)
	If[Length[acquisitionConflictResults]>0&&!gatherTests,
		Message[Error::AcquisitionTimeConflict,ObjectToString[acquisitionConflictResults[[All,1]],Simulation -> updatedSimulation],ObjectToString[acquisitionConflictResults[[All,2]],Simulation -> updatedSimulation],ObjectToString[acquisitionConflictResults[[All,3]],Simulation -> updatedSimulation]];
	];

	(* Gather tests. *)
	acquisitionConflictTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[acquisitionConflictResults]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[acquisitionConflictResults[[All,1]],Simulation -> updatedSimulation]<>" have valid specified acquisition times:",True,False]
			];
			passingTest=If[Length[acquisitionConflictResults]==Length[simulatedSamples],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,acquisitionConflictResults[[All,1]]],Simulation -> updatedSimulation]<>" have valid specified acquisition times:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*The SevenExcellence must have 3 calibration buffers and all of them must be pH 4, 7, and 10*)
	certainCalibrationRequiredOptions=If[
		And[
			MemberQ[Download[resolvedInstrumentModelPackets,Object],Download[Model[Instrument, pHMeter, "SevenExcellence (for pH)"],Object]],
			nonstandardCalibrantsQ
		],
		{Instrument,LowCalibrationBufferpH,MediumCalibrationBufferpH,HighCalibrationBufferpH},
		{}
	];

	If[Length[certainCalibrationRequiredOptions]>0&&!gatherTests,
		Message[Error::CertainpHCalibrationRequired]
	];

	certainCalibrationRequiredTests=If[gatherTests,
		Test["If the SevenExcellence system is used, all three calibration buffers are used with pH values of 4, 7, and 10:",
			Length[certainCalibrationRequiredOptions]>0,
			False
		],
		Nothing
	];


	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,noVolumeInputs,incompatibleInputsAnyInstrument,incompatibleInputsSpecificInstrument,lowVolumeInvalidInputs,incompatibleWInstrumentInputs,noSuitableInstrumentInputs,acquisitionConflictInvalidInputs}]];

	invalidOptions=DeleteDuplicates[Flatten[{deprecatedInstrumentOptions,incompatibleInputsSpecificInstrumentOptions,incompatibleInputsRoboticInstrumentOptions, probeInstrumentConflictOptions,incompatibleWInstrumentOptions,acquisitionConflictInvalidOptions,invalidpHOptions,invalidMediumCalibrationOptions,invalidLowHighpHOptions,
		temperatureCorrectionConflictOptions,pHProbeConflictOptions,certainCalibrationRequiredOptions, recoupAliquotConflictOptions}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Simulation -> updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	targetContainers=potentialAliquotContainersList;

	(*figure out the required amounts*)
	resolvedProbePackets=Map[fetchPacketFromCache[#,cache]&,resolvedProbeList];
	minVolumeInstrument=MapThread[
		Which[
			MatchQ[#1,PacketP[]]&&VolumeQ[Lookup[#1,MinSampleVolume]],Lookup[#1,MinSampleVolume],
			MemberQ[Lookup[#2,MinSampleVolumes],VolumeP],Min[Cases[Lookup[#2,MinSampleVolumes],VolumeP]],
			True,Null
		]&,
		{resolvedProbePackets,resolvedInstrumentModelPackets}
	];

	(*look up the min volume required by the container*)
	minVolumeContainer=MapThread[
		If[NullQ[#2],Null,
			(*only matters if the ProbeType is immersion*)
			If[MatchQ[Lookup[#2,ProbeType],Except[Immersion]],0*Milliliter,
				(*get the min height from the instrument model field*)
				minDepth=Lookup[#2,MinDepth];
				(*calculate the displaced volume from the probe insertion*)
				displacedVolume=UnitConvert[minDepth*Pi*(Lookup[#2,ProbeDiameter]/2)^2,Milliliter];
				(*get the calibration function from the packet*)
				calibrationFunction=If[NullQ[#1],Null,Lookup[fetchPacketFromCache[#1,combinedPotentialContainerPackets],CalibrationFunction]];

				(*If the calibration function is Null, return 0*mL*)
				If[NullQ[calibrationFunction]||NullQ[minDepth],
					0*Milliliter,
					(*figure out the volume this translates to for the container using the calibration function*)
					minDepthToVolume=calibrationFunction[minDepth];
					(*calculate the minimum sample volume for this container*)
					minVolume=minDepthToVolume-displacedVolume
				]
			]
		]&,
		{targetContainers,resolvedInstrumentModelPackets}
	];

	(* Get the minimum amount of volume we can possible use *)
	requiredAliquotAmounts=MapThread[
		Which[
			(*see if we have restrictions based on the instrument/container*)
			(* During resolution of aliquotVolumeList, we already try to get the best volume possible. This also reflects user options so we should do that *)
			MemberQ[{#1,#2},GreaterP[0*Milliliter]],Max[Cases[{#1,#2,#3},GreaterP[0*Milliliter]]],
			(*otherwise take the resolution*)
			MatchQ[#3,GreaterP[0*Milliliter]],#3,
			(*take the whole amount otherwise*)
			True,lowestVolume
		]&,
		{minVolumeInstrument,minVolumeContainer,aliquotVolumeList}
	];

	(* Resolve Aliquot Options *)

	resolvedAliquotOptions = resolveAliquotOptions[
		ExperimentMeasurepH,
		mySamples,
		simulatedSamples,
		ReplaceRule[myOptions, resolvedSamplePrepOptions],
		Cache -> cache,
		Simulation -> updatedSimulation,
		RequiredAliquotContainers -> targetContainers,
		RequiredAliquotAmounts -> RoundOptionPrecision[requiredAliquotAmounts, 1 Microliter, Round -> Down],
		AliquotWarningMessage -> Null
	];

	(* RecoupSample x ProbeType *)

	(* If RecoupSample has been requested and using SurfaceProbe indicate droplet used in measurement cannot be recouped *)
	surfaceRecoupWarningSamples=MapThread[
		If[MatchQ[#2,Surface]&&MatchQ[{#3,#4},{True,True}],
			#1,
			Nothing
		]&,
		{mySamples,resolvedProbeList,resolvedProbeList,Lookup[measurepHOptionsAssociation,RecoupSample],Lookup[resolvedAliquotOptions,Aliquot]}
	];

	If[!MatchQ[surfaceRecoupWarningSamples,{}],
		Message[Warning::SurfaceProbeRecoupWarning,surfaceRecoupWarningSamples]
	];

	recoupProbeConflictTest=Warning[
		"If RecoupSample is set the surface probe is not being used since the small amount used for measurement cannot be recouped:",
		MatchQ[surfaceRecoupWarningSamples,{}],
		True
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* pull out all the shared options from the input options *)
	{name, confirm, canaryBranch, template, samplesInStorageCondition, originalCache, operator, parentProtocol, upload, outputOption, email, imageSample} = Lookup[myOptions, {Name, Confirm, CanaryBranch, Template, SamplesInStorageCondition, Cache, Operator, ParentProtocol, Upload, Output, Email, ImageSample}];

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

	(* resolve the ImageSample option if Automatic; for this experiment, the default is False *)
	resolvedImageSample = If[MatchQ[imageSample, Automatic],
		False,
		imageSample
	];

	resolvedOptions = ReplaceRule[measurepHOptions,
		Join[
			{
				Instrument -> instrumentList,
				Probe->resolvedProbeList,
				ProbeType->probeTypeList,
				TemperatureCorrection -> resolvedTemperatureCorrectionList,
				LowCalibrationBufferpH->resolvedLowpHValue,
				MediumCalibrationBufferpH->resolvedMediumpHValue,
				HighCalibrationBufferpH->resolvedHighpHValue,
				AcquisitionTime->acquisitionTimeList,
				NumberOfReplicates -> numberOfReplicates,
				Confirm -> confirm,
				CanaryBranch -> canaryBranch,
				ImageSample -> resolvedImageSample,
				Name -> name,
				Template -> template,
				SamplesInStorageCondition -> samplesInStorageCondition,
				Cache -> originalCache,
				Email -> resolvedEmail,
				Operator -> operator,
				Output -> outputOption,
				ParentProtocol -> parentProtocol,
				Upload -> upload
			},
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		]
	];

	(* combine all the tests together. Make sure we only have tests in the final lists (no Nulls etc) *)
	allTests=Cases[
		Flatten[{
			discardedTests,
			incompatibleInputsAnyInstrumentTests,
			incompatibleInputsSpecificInstrumentTests,
			incompatibleInputsRoboticInstrumentTests,
			noVolumeInputsTests,
			lowVolumeInputsTests,
			incompatibleWInstrumentTests,
			noSuitableInstrumentTests,
			acquisitionConflictTests,
			matchingReferencepHTest,
			mediumCalibrationpHTest,
			invalidLowHighpHTest,
			deprecatedInstrumentTest,
			temperatureCorrectionTests,
			pHProbeConflictTests,
			certainCalibrationRequiredTests,
			recoupAliquotConflictTests,
			recoupProbeConflictTest
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

	(* Return our resolved options and/or tests. *)
	outputSpecification/. {resultRule,testsRule}
];


(* ::Subsubsection:: *)
(*Resource Packets*)


DefineOptions[measurepHResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];


measurepHResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},myCollapsedResolvedOptions:{___Rule},myOptions:OptionsPattern[]]:=Module[
	{outputSpecification, output, gatherTests, safeOps, cache, samplesWithoutLinks, probeTypes, instruments, instrumentObjects,
		probePositions, aquisitionTimes, probeSamples, probeInstruments, groupedProbeResult, groupedProbeSamples, probeNumberOfAcquisitions,
		groupedProbeInstruments, groupedProbePositions, probeResult, batchSamples, batchLengths, uuid, id, instrumentResource, optionsWithReplicates, instrumentResources, probeBatchLengths,
		probeInstrumentResources, insitu, lowCalibrationBufferProbe, mediumCalibrationBufferProbe, highCalibrationBufferProbe, protocolPacket, probeRecoupSample, recoupSample, numberOfReplicates, samplesWithReplicates, washSolution, probeDirtyWashSolution,
		probeCleanWashSolution, probeDirtyPipetteBulb, probeCleanPipetteBulb, resourceIndices, probeRelease, probeSelect, allResourceBlobs,
		fulfillable, frqTests, resultRule, testsRule, probes, temperatureCorrections, probeSampleNames, probeObjects, groupedProbes, probesForUpload, probeForGroup,
		probeMeasurementOrder, orderedProbeSamples, wasteBeaker, wasteBeakerResource, washSolutionModel, washSolutionResource, simulation,parentProtocol, parentProtocolPacket
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Get the safe options for this function *)
	safeOps = SafeOptions[measurepHResourcePackets, ToList[myOptions]];

	(* Lookup helper options *)
	{cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

	parentProtocol=Lookup[myResolvedOptions,ParentProtocol];
	(* Extract the packets that we need from our downloaded cache. *)
	{parentProtocolPacket}=Replace[Quiet[Download[
		{
			Cases[{parentProtocol}, ObjectP[Object[Protocol, AdjustpH]]]
		},
		{
			{Packet[WasteBeaker]}
		},
		Cache->cache,
		Simulation->simulation]],$Failed->Nothing,1];

	wasteBeaker = If[!NullQ[parentProtocol]&&MatchQ[parentProtocol,ObjectP[Object[Protocol, AdjustpH]]],
		Lookup[fetchPacketFromCache[parentProtocol, Flatten[parentProtocolPacket]], WasteBeaker],
		Null
	];

	wasteBeakerResource = If[MatchQ[wasteBeaker, LinkP[Object[Container]]],
		Link[wasteBeaker[Object]],
		Resource[Sample->Model[Container,Vessel,"id:O81aEB4kJJJo"], Rent -> True]
	];

	(* Get rid of the links in mySamples. *)
	samplesWithoutLinks=mySamples/.{link_Link:>Download[link, Object]};

	(* Get our number of replicates. *)
	numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates]/.{Null->1};

	(* Expand our samples and options according to NumberOfReplicates. *)
	{samplesWithReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentMeasurepH,samplesWithoutLinks,myResolvedOptions];

	(* Lookup some of our options that were expanded. *)
	{probeTypes,instruments,recoupSample,aquisitionTimes,probes,temperatureCorrections}=Lookup[optionsWithReplicates,
		{ProbeType,Instrument,RecoupSample,AcquisitionTime,Probe,TemperatureCorrection}];

	(* Make sure our instruments are objects. *)
	instrumentObjects=Download[instruments,Object];
	probeObjects=probes/.{x:ObjectP[]:>Download[x,Object]};

	(* Get the positions of the Immersion/Surface probe types *)
	(* These are both traditional probes which can be hooked up to the same meter *)
	probePositions=Flatten[Position[probeTypes,Immersion|Surface]];

	probeSamples=samplesWithReplicates[[probePositions]];

	(* Get the instruments that correspond with our samples. *)
	probeInstruments=instrumentObjects[[probePositions]];
	probes=probeObjects[[probePositions]];

	(* For our Probe types, see if we should recoup the samples *)
	probeRecoupSample=recoupSample[[probePositions]];
	(* Compute our number of acquisitions for the probe samples, according to the 1 Second SensorNet heartbeat. *)
	probeNumberOfAcquisitions= If[!NullQ[#], (1+IntegerPart[QuantityMagnitude[UnitConvert[#,Second]]])]&/@(aquisitionTimes[[probePositions]]);

	(* First group our probe samples by the instrument and probes they are going to use. *)
	groupedProbeResult=GatherBy[Transpose[{probeSamples,probeInstruments,probes,probePositions}],(#[[2;;3]]&)];

	(* For each group, get the samples, instruments, and positions. *)
	groupedProbeSamples=(#[[All,1]]&)/@groupedProbeResult;
	groupedProbeInstruments=(#[[All,2]]&)/@groupedProbeResult;
	groupedProbes=(#[[All,3]]&)/@groupedProbeResult;
	groupedProbePositions=(#[[All,4]]&)/@groupedProbeResult;
	probeMeasurementOrder=Flatten[groupedProbePositions,1];

	(* Group our samples into groups of 10. *)
	(* This will return {{batchLengths,instrumentResources,probe}..} for each group, grouped by instrument. *)
	probeResult=MapThread[
		Function[{groupedSamples,groupedInstrument,probeGroup},
			(* Batch our samples into groups of 10, with the remainder making up their own group. *)
			batchSamples=Partition[groupedSamples,UpTo[10]];

			(* From these batched samples, figure out our batch lengths. *)
			batchLengths=Length/@batchSamples;

			(* Name the instrument based on its model. This was we will use the same instrument whenever models match (even if we're using multiple probes on that instrument) *)
			id=ToString[First[groupedInstrument]];

			(* Create the pooled instrument resource. *)
			instrumentResource=ConstantArray[Resource[Instrument->First[groupedInstrument],Name->id,Time->30Minute*Length[batchLengths]],Length[batchLengths]];

			probeForGroup=Table[FirstOrDefault[probeGroup],Length[batchSamples]];

			(* Return our batch lengths and instrument resources. *)
			{
				batchLengths,
				instrumentResource,
				probeForGroup
			}
		],
		{groupedProbeSamples,groupedProbeInstruments,groupedProbes}
	];

	(* If we have a result, transpose. *)
	{probeBatchLengths,probeInstrumentResources,probesForUpload}=If[Length[probeResult]>0,
		Flatten/@Transpose[probeResult],
		{{},{},{}}
	];

	insitu=Lookup[myResolvedOptions,InSitu];

	(* Create resources for our probe reference solutions. *)
	lowCalibrationBufferProbe=If[Length[probeBatchLengths]>0&&!insitu,
		Resource[Sample->Lookup[myResolvedOptions,LowCalibrationBuffer],Amount->20 Milliliter],
		Null
	];

	mediumCalibrationBufferProbe=If[Length[probeBatchLengths]>0&&!MatchQ[Lookup[myResolvedOptions,MediumCalibrationBuffer],Null]&&!insitu,
		Resource[Sample->Lookup[myResolvedOptions,MediumCalibrationBuffer],Amount->20 Milliliter],
		Null
	];

	highCalibrationBufferProbe=If[Length[probeBatchLengths]>0&&!insitu,
		Resource[Sample->Lookup[myResolvedOptions,HighCalibrationBuffer],Amount->20 Milliliter],
		Null
	];

	(* Compute whether each probe instrument should be released. *)
	probeRelease=MapThread[Function[{instrumentIndex,instrument},
			(* A vortex should be released if it's the last instance that we are going to use that vortex. *)
			(* We can tell if the vortex is the same by comparing the resources (the same vortex will be inidicated by the same resource). *)

			(* Get all of the positions in which this resource appears. *)
			resourceIndices=Flatten[Position[probeInstrumentResources,instrument,1]];

			(* Are we at the last instance of this resource appearing? If so, we should release the vortex. *)
			MatchQ[Last[resourceIndices],instrumentIndex]
		],
		{Range[Length[probeInstrumentResources]],probeInstrumentResources}
	];

	(* Compute whether each probe instrument should be selected. *)
	probeSelect=MapThread[Function[{instrumentIndex,instrument},
			(* A probe instrument should be selected if it's the first instance that we are going to use that vortex. *)
			(* We can tell if the probe instrument is the same by comparing the resources (the same vortex will be inidicated by the same resource). *)

			(* Get all of the positions in which this resource appears. *)
			resourceIndices=Flatten[Position[probeInstrumentResources,instrument,1]];

			(* Are we at the first instance of this resource appearing? If so, we should select the vortex. *)
			MatchQ[First[resourceIndices],instrumentIndex]
		],
		{Range[Length[probeInstrumentResources]],probeInstrumentResources}
	];

	(* Create resources for our wash solutions. *)
	(* Lookup our wash solution. *)

	washSolution=Lookup[myResolvedOptions,WashSolution]/.{link_Link:>Download[link,Object]};
	washSolutionModel=If[MatchQ[washSolution,ObjectP[Model[Sample]]],
		washSolution,
		fetchPacketFromCache[washSolution,cache][Model]
	];

	washSolutionResource=Which[
		(*If WashSolution is Model[Sample,"Milli-Q water"], put 400ml of water to 600ml beaker*)
		Length[probeBatchLengths]>0&&MatchQ[washSolution,ObjectP[Model[Sample,"Milli-Q water"]]],
		Link[Resource[Sample -> washSolution,Amount -> 400 Milliliter,Container -> Model[Container, Vessel, "id:R8e1PjRDbbOv"],RentContainer->True]],

		(*If WashSolution is an Object[Sample] whose Model is Model[Sample,"Milli-Q water"], use that object*)
		Length[probeBatchLengths]>0&&MatchQ[washSolution,ObjectP[Object[Sample]]]&&MatchQ[washSolutionModel,ObjectP[Model[Sample,"Milli-Q water"]]],
		Link[Resource[Sample -> washSolution]],

		(*In other cases, populate whatever the resolved option is but do not make a resource of it-- we'll split the resource into ProbeDirtyWashSolution and ProbeCleanWashSolution*)
		True,
		Link[washSolution]
	];

	probeDirtyWashSolution=If[Length[probeBatchLengths]>0&&!MatchQ[washSolutionModel,ObjectP[Model[Sample,"Milli-Q water"]]],
		Link[Resource[Sample->washSolution,Amount->40Milliliter,Name->CreateUUID[],Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"]]],
		Null
	];
	probeCleanWashSolution=If[Length[probeBatchLengths]>0&&!MatchQ[washSolutionModel,ObjectP[Model[Sample,"Milli-Q water"]]],
		Link[Resource[Sample->washSolution,Amount->40Milliliter,Name->CreateUUID[],Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"]]],
		Null
	];
	probeDirtyPipetteBulb=If[Length[probeBatchLengths]>0&&!MatchQ[washSolutionModel,ObjectP[Model[Sample,"Milli-Q water"]]],
		Link[Resource[Sample->Model[Item,Consumable,"id:bq9LA0J1xmBd"]]],
		Null
	];
	probeCleanPipetteBulb=If[Length[probeBatchLengths]>0&&!MatchQ[washSolutionModel,ObjectP[Model[Sample,"Milli-Q water"]]],
		Link[Resource[Sample->Model[Item,Consumable,"id:bq9LA0J1xmBd"]]],
		Null
	];

	(*we only need this for the SevenExcellence system, but nonetheless make it for everything*)
	probeSampleNames=Flatten[Table[StringPadLeft[ToString[x], 2, "0"], {x, 1, #}] & /@ probeBatchLengths];

	orderedProbeSamples=probeSamples[[probeMeasurementOrder]];

	(* Create our protocol packet. *)
	protocolPacket=Join[
		<|
			Type->Object[Protocol,MeasurepH],
			Object->CreateID[Object[Protocol,MeasurepH]],
			Replace[SamplesIn]->(Resource[Sample->#]&)/@samplesWithReplicates,
			Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@DeleteDuplicates[Lookup[fetchPacketFromCache[#,cache],Container]&/@samplesWithReplicates],

			(* Protocol specific fields. *)
			Replace[ProbeSamples]->(Resource[Sample->#]&)/@orderedProbeSamples,
			Replace[ProbeIndices]->probePositions[[probeMeasurementOrder]],
			Replace[ProbeBatchLength]->probeBatchLengths,
			Replace[ProbeInstruments]->probeInstrumentResources,
			Replace[ProbeLowCalibrationBuffer]->lowCalibrationBufferProbe,
			Replace[ProbeMediumCalibrationBuffer]->mediumCalibrationBufferProbe,
			Replace[ProbeHighCalibrationBuffer]->highCalibrationBufferProbe,
			Replace[ProbeRecoupSample]->probeRecoupSample[[probeMeasurementOrder]],
			Replace[ProbeInstrumentsSelect]->probeSelect,
			Replace[ProbeInstrumentsRelease]->probeRelease,
			Replace[ProbeAcquisitionTimes]->aquisitionTimes[[probePositions]][[probeMeasurementOrder]],
			Replace[ProbeNumberOfAcquisitions]->probeNumberOfAcquisitions[[probeMeasurementOrder]],
			(*these are not resource picked because they're always with the instrument*)
			Replace[Probes]->Link/@probesForUpload,
			Replace[TemperatureCorrection]->temperatureCorrections[[probePositions]][[probeMeasurementOrder]],
			Replace[DataFilePath]->ConstantArray[Null, Length[probeInstrumentResources]],
			Replace[CalibrationFilePath]->ConstantArray[Null, Length[probeInstrumentResources]],
			Replace[InitialDataFilePath]->ConstantArray[Null, Length[probeInstrumentResources]],
			Replace[InitialCalibrationFilePath]->ConstantArray[Null, Length[probeInstrumentResources]],
			Replace[ProbePorts]->ConstantArray[Null, Length[probeInstrumentResources]],
			Replace[ProbeBatchName]->ConstantArray[Null, Length[probeInstrumentResources]],

			InSitu->Lookup[myResolvedOptions,InSitu],
			WasteBeaker-> wasteBeakerResource,

			ProbeDirtyWashSolution->probeDirtyWashSolution,
			ProbeCleanWashSolution->probeCleanWashSolution,
			WashSolution -> washSolutionResource,
			ProbeDirtyPipetteBulb->probeDirtyPipetteBulb,
			ProbeCleanPipetteBulb->probeCleanPipetteBulb,
			Replace[ProbeParameters]->MapThread[
				Function[{sample,numberOfAcquisitions,recoupBool,sampleName,probeType},
					<|
						Sample->Link[Resource[Sample->sample]],
						NumberOfAcquisitions->numberOfAcquisitions,
						RecoupPrimitive->Null,
						RecoupSample->recoupBool,
						SampleName -> sampleName,
						DropletContainer -> If[MatchQ[probeType,Surface],
							Link[Resource[Sample->Model[Container, Vessel, "Glass Droplet Container"],Rent->True]]
						],
						DropletPrimitive->Null
					|>
				],
				{
					orderedProbeSamples,
					probeNumberOfAcquisitions[[probeMeasurementOrder]],
					probeRecoupSample[[probeMeasurementOrder]],
					probeSampleNames,
					probeTypes[[probePositions]][[probeMeasurementOrder]]
				}
			],
			Replace[Checkpoints]->{
				{"Picking Resources",10 Minute,"Samples required to execute this protocol are gathered from storage.",Resource[Operator->$BaselineOperator,Time->10 Minute]},
				{"Preparing Samples",0 Minute,"Preprocessing, such as incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Resource[Operator->$BaselineOperator,Time->0 Minute]},
				{"Measuring pH",30Minute*(Length[probeBatchLengths]),"The pH of the requested samples is measured.",Resource[Operator->$BaselineOperator,Time->30Minute*(Length[probeBatchLengths])]},
				{"Sample Postprocessing",0 Minute,"The samples are imaged and volumes are measured.",Resource[Operator->$BaselineOperator,Time->0 Minute]}
			},
			ResolvedOptions->myCollapsedResolvedOptions,
			UnresolvedOptions->myUnresolvedOptions
		|>,
		populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation]
	];

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],
			{True,{}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache, Simulation -> simulation],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->Not[gatherTests],Cache->cache, Simulation -> simulation],Null}
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		protocolPacket,
		$Failed
	];

	(* Return our result. *)
	outputSpecification/.{resultRule,testsRule}
];


(* ::Subsubsection:: *)
(*Devices Function*)


(*compatiblepHmeterQ*)
DefineOptions[compatiblepHMeterQ,
	Options:>{
		CacheOption,
		SimulationOption,
		{OutputFormat->SingleBoolean,SingleBoolean|Boolean,"Determines the format of the return value. Boolean returns a pass/fail for each entry. SingleBoolean returns a single pass/fail boolean for all the inputs. TestSummary returns the EmeraldTestSummary object for each input."}
	}
];

compatiblepHMeterQ[deviceModelPacket:PacketP[{Model[Instrument,pHMeter],Model[Part,pHProbe]}],samplePacket:ObjectP[Object[Sample]],myOptions:OptionsPattern[]]:=compatiblepHMeterQ[deviceModelPacket,{samplePacket},myOptions];

(*internal function for pHmeter compatibility. Checks for material and pH compatibility.*)
compatiblepHMeterQ[deviceModelPacket:PacketP[{Model[Instrument,pHMeter],Model[Part,pHProbe]}],samplePackets:{ObjectP[Object[Sample]]..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions,cache,simulation,isCompatible,pHCompatibilities,minpHValue,maxpHValue,samplepHs,materialCompatibilities,outputFormat},

	(* Make sure we're working with a list of options *)
	(* SPEED: this is a lot faster than SafeOptions *)
	listedOptions=ToList[myOptions];

	(* assign the option values to local variables *)
	cache=Lookup[listedOptions,Cache,{}];
	simulation=Lookup[listedOptions,Simulation,Simulation[]];

	(* assigned the OutputFormat to local variable *)
	outputFormat=Lookup[listedOptions,OutputFormat,SingleBoolean];

	(*check the material compatibility*)
	materialCompatibilities=Quiet[CompatibleMaterialsQ[deviceModelPacket,samplePackets,Cache->cache,Simulation -> simulation,OutputFormat->outputFormat]];
	(*get the relevant pH values*)
	(* if given a probe then there's one clear Min *)
	(* if given an instrument it should have only one probe, but take the min to see if there's any probe that will work *)
	minpHValue=If[MatchQ[deviceModelPacket,ObjectP[Model[Part,pHProbe]]],
		Lookup[deviceModelPacket,MinpH],
		Min[Lookup[deviceModelPacket,MinpHs]]
	];

	(* if given a probe then there's one clear Min *)
	(* if given an instrument it should have only one probe, but take the max to see if there's any probe that will work *)
	maxpHValue=If[MatchQ[deviceModelPacket,ObjectP[Model[Part,pHProbe]]],
		Lookup[deviceModelPacket,MaxpH],
		Max[Lookup[deviceModelPacket,MaxpHs]]
	];
	(* Note sample packets is a list here so samplepHs will be a list as well *)
	samplepHs=Lookup[samplePackets,pH];

	(*check pH compatibility if the pH value is not Null*)
	(* If MinpHs/MaxpHs were empty lists we'll have -Infinity/Infinity which will be okay in our comparision below (but doesn't work with usual RangeP,GreaterP etc.) *)
	pHCompatibilities=If[Not[Or[NullQ[#],NullQ[minpHValue],NullQ[maxpHValue]]],
		#>=minpHValue&&#<=maxpHValue,
		True
	]&/@samplepHs;

	(*overall compatibility-- depending on outputforamt either we return a single Boolean or a list of booleans index-matched to the samples*)
	isCompatible=If[MatchQ[outputFormat,SingleBoolean],
		And@@Flatten[{materialCompatibilities,pHCompatibilities}],
		MapThread[And[##]&,{materialCompatibilities,pHCompatibilities}]
		]
];

(*internal function to find the preferred container. Only difference is to use a 15 mL Tube when between 2 mL and 10 mL*)
(*TODO: handle if light sensitive and figure out with packets/caching*)

preferredpHContainer[input:Alternatives[GreaterP[0 Milliliter],All]]:=Module[{},

	(*if the input requests All, then provide all the containers including the 15 mL*)
	If[MatchQ[input,All],

		(*provide everything including the 15mL*)
		Union[PreferredContainer[All],{Model[Container,Vessel,"id:xRO9n3vk11pw"]}],

		(* Default to 15mL tubes if the volume is appropriate. *)
		(* PreferredContainer doesn't include 15 mL because it's not liquid handler compatible *)
		If[MatchQ[input,RangeP[2 Milliliter,10 Milliliter]],
		  Model[Container,Vessel,"id:xRO9n3vk11pw"](*"15mL Tube"*),

			(*otherwise, use the preferred container*)
		  PreferredContainer[input]
		]
	]
];


(*pHDevices*)
DefineOptions[pHDevices,
	Options:>{
		CacheOption,
		SimulationOption
	}
];

Authors[pHDevices] := {"ben", "dima"};

(*user facing overload where they can specify sample(s) to figure out compatible pH instruments*)
(*not online*)
pHDevices[sample:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,cache,simulation,instrumentList,sampleList,sampleContainerPackets,instrumentPackets,samplePackets,containerModelPackets,volumeCalibrationPackets,
		combinedContainerPackets,latestVolumeCalibrationPacket,instrumentModelPackets, objectSamplePacketFields},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* assign the option values to local variables *)
	cache = Lookup[listedOptions, Cache, {}];
	simulation = Lookup[listedOptions, Simulation, Simulation[]];

	(*get a list of instruments*)
	instrumentList=Search[Model[Instrument,pHMeter],Deprecated!=True&&TitrationInstrument == Null];

	(*convert to a list*)
	sampleList=ToList[sample];

	objectSamplePacketFields=Packet@@Union[Flatten[{pH,SamplePreparationCacheFields[Object[Sample]]}]];

	(*download the packets*)
	{sampleContainerPackets,instrumentPackets}=Download[{sampleList,instrumentList},
		{
			{
				objectSamplePacketFields,
				Packet[Container[Model][{Name,IncompatibleMaterials,VolumeCalibrations, MaxVolume, Aperture, WellDiameter, WellDimensions, Dimensions}]],
				Packet[Container[Model][VolumeCalibrations][{CalibrationFunction,DateCreated}]]
			},
			{
				Packet[Name,Object,Objects,WettedMaterials,Dimensions,ProbeLength,ProbeDiameter,MinpH,MaxpH,MinDepth,MinSampleVolume,ProbeTypes]
			}
		},
		Cache -> cache,
		Simulation -> simulation
	];

	(*pull out all the sample/container/container model packets*)
	samplePackets=sampleContainerPackets[[All,1]];
	containerModelPackets=sampleContainerPackets[[All,2]];
	volumeCalibrationPackets=sampleContainerPackets[[All,3]];

	(*only consider the latest calibration*)
	latestVolumeCalibrationPacket=Map[If[Length[#]>0,Last[#],Null]&,volumeCalibrationPackets];

	(*append the calibration information to each container*)
	(*combine the calibration information into the container model packets.*)
	combinedContainerPackets=MapThread[If[Not[NullQ[#2]],
		Append[#1,CalibrationFunction->Lookup[#2,CalibrationFunction]],
		Append[#1,CalibrationFunction->Null]
	]&,
		{containerModelPackets,latestVolumeCalibrationPacket}];

	(*pull out the instrument object/model information*)
	instrumentModelPackets=instrumentPackets[[All,1]];

	(*map across the sample list and use the devices function*)
	MapThread[pHDevices[#1,Lookup[#1,Volume],#2,instrumentModelPackets,Cache->cache,Simulation->simulation]&,{samplePackets,combinedContainerPackets}]

];


(*Devices function will return a list of compatible instruments for a given sample, container, and instrument list.*)
pHDevices[sample:ObjectP[Object[Sample]],workingVolume:GreaterEqualP[0 Milli Liter]|Null,containerModelPacket:PacketP[Model[Container]],instrumentModelInput:Automatic|ListableP[ObjectP[Model[Instrument,pHMeter]]],probe:Automatic|Null|pHProbeTypeP|ObjectP[{Object[Part,pHProbe],Model[Part,pHProbe]}],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,cache,simulation,instrumentModels,mappingResult,problemList,suitableInstruments,validInstrumentBool,instrumentModelPackets,
		probesForEachModel,probePacketsForEachModel,filteredProbePacketsForEachModel,filteredProbesForEachModel,samplePacket,
		specifiedProbePacket,validProbeNestedList,suitableProbes,combinedSimulationAndCache},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* assign the option values to local variables *)
	cache = Lookup[listedOptions, Cache, {}];
	simulation = Lookup[listedOptions, Simulation, Simulation[]];
	combinedSimulationAndCache = FlattenCachePackets[{cache, Lookup[FirstOrDefault[simulation, <||>], Packets, {}]}];

	(*if both the probe or instrument list are automatic/Null, then return right now*)
	If[MatchQ[probe,Null|Automatic]&&MatchQ[instrumentModelInput,Automatic],
		Return[{{},{},{"No instrument nor probe specified."}}]
	];

	(*if we have a specified probe, then get that*)
	(*get the model for it*)
	specifiedProbePacket=Switch[probe,
		ObjectP[Object[Part,pHProbe]],fetchPacketFromCache[Download[Lookup[fetchPacketFromCache[Download[probe,Object],combinedSimulationAndCache],Model],Object],combinedSimulationAndCache],
		ObjectP[Model[Part,pHProbe]],fetchPacketFromCache[Download[probe,Object],combinedSimulationAndCache],
		_,Null
	];

	(*if the probe is specified, make sure that instrument is within in or automatic*)
	If[!NullQ[specifiedProbePacket]&&MatchQ[instrumentModelInput,Except[Automatic]],
		If[!IntersectingQ[Download[instrumentModelInput,Object],Lookup[specifiedProbePacket, SupportedInstruments] /. x_Link :> Download[x, Object]],
			Return[{{},{},{"The specified instrument list is not compatible with the specified probe."}}]
		]
	];

	(*listify the instrument models if need be.*)
	instrumentModels=Which[
		MatchQ[instrumentModelInput,Automatic],
			Lookup[specifiedProbePacket, SupportedInstruments] /. x_Link :> Download[x, Object],
		!NullQ[specifiedProbePacket],
		{First@Intersection[Download[instrumentModelInput,Object],Lookup[specifiedProbePacket, SupportedInstruments] /. x_Link :> Download[x, Object]]},
		True,
			ToList[instrumentModelInput]
	];

	(*get all of our instrument models*)
	instrumentModelPackets=Map[
		fetchPacketFromCache[#,combinedSimulationAndCache]&,
		instrumentModels
	];

	(*build a list of associated probes to go along with each instrument*)
	(*if we have a specified probe we only consider that and we're assuming that we're only considering that instrument*)
	probesForEachModel= If[!NullQ[specifiedProbePacket],
		List[
			{Lookup[specifiedProbePacket,Object]}
		],
		Map[
			Cases[First /@ Lookup[#, AssociatedAccessories], ObjectP[Model[Part, pHProbe]]] /. {x_Link :> Download[x, Object]}&,
			instrumentModelPackets
		]
	];

	(* We have a list composed of lists of probes. Map at {All,All} to apply fetchPacketFromCache to each probe object *)
	probePacketsForEachModel=Map[
		Function[probes,
			Map[
				fetchPacketFromCache[#,combinedSimulationAndCache]&,
				probes
			]
		],
		probesForEachModel
	];

	(* Get only the probes that match our requested probe type (f we were given one) *)
	filteredProbePacketsForEachModel=Map[
		Function[probePackets,
			If[MatchQ[probe,pHProbeTypeP],
				Select[probePackets,MatchQ[Lookup[#,ProbeType],probe]&],
				probePackets
			]
		],
		probePacketsForEachModel
	];

	(* Convert back to probe objects *)
	filteredProbesForEachModel=Download[filteredProbePacketsForEachModel,Object];

	(*get our sample packet*)
	samplePacket=fetchPacketFromCache[Download[sample,Object],combinedSimulationAndCache];

	(*map over the instrument model list, if there is one. might not be the case if the probe is not in the specified instrument*)
	mappingResult= If[Length[instrumentModels]>0,
		MapThread[
			Function[{instrumentModelPacket,availableProbes},
				Module[
					{instrumentBool,problems,sampleCompatible,compatibilityProblem,probeTypes,
					apertureBigEnough,probeTooBigProblem,enoughSampleVolume,enoughSampleProblem,canReach,tooShortProblem,availableProbePackets,multipleProbesQ,
					minVolume,minDepthToVolume,minHeightSample,volAtMinHeight,
					currentProbePacket, probeApertureBigEnoughBool,
					probeEnoughSampleVolumeBool, probeCanReachBool, suitableProbesBool},

					(* Initialize a boolean that indicates that this instrument is compatible. *)
					instrumentBool=True;

					(* Initialize a list to keep track of the problems we find with this instrument. *)
					problems={};

					(*1. Check that the sample is compatible with the instrument*)
					sampleCompatible = compatiblepHMeterQ[instrumentModelPacket, samplePacket, Cache->cache, Simulation -> simulation];

					(*if not compatible, describe the problem*)
					compatibilityProblem=If[!sampleCompatible,
						{"Sample is chemically incompatible with instrument."},
						Nothing
					];

					(*get the probeType*)
					probeTypes=Lookup[instrumentModelPacket,ProbeTypes];

					(*get all of the packets for any available probes*)
					availableProbePackets=Map[
						fetchPacketFromCache[#,combinedSimulationAndCache]&,
						availableProbes
					];

					(*check if we have probes for this instrument*)
					multipleProbesQ=Length[availableProbes]>0;

					(*If the instrument is an Immersion style, we must do additional checking*)
					(*The whole instrument is just one probe so probeTypes just a list with one element *)
					{apertureBigEnough,enoughSampleVolume,canReach}=If[MatchQ[probeTypes,{Immersion}],
						Module[{minDepth,displacedVolume,calibrationFunction,containerHeight,
						probeLength,isProbeShorter,enoughSampleVolumeCheck,apertureBigEnoughCheck,canReachCheck},

							(*2. Check the aperture size and make sure congruent with probe*)
							(*is the probe diameter smaller than the container aperture?*)
							(*this depends if it's an instrument or if we're considering the probes directly*)
							apertureBigEnoughCheck= If[multipleProbesQ&&Not[NullQ[Lookup[instrumentModelPacket,ProbeDiameters]]],
								MemberQ[Lookup[instrumentModelPacket, ProbeDiameters], LessP[measurepHApertureLookup[containerModelPacket]]],
								True
							];

							(*get the min height from the instrument model field*)
							minDepth=Min[Lookup[instrumentModelPacket,MinDepths]];
							(*calculate the displaced volume from the probe insertion*)
							displacedVolume=UnitConvert[minDepth*Pi*(Max[Lookup[instrumentModelPacket,ProbeDiameters]]/2)^2,Milliliter];
							(*get the calibration function from the packet*)
							calibrationFunction=Lookup[containerModelPacket,CalibrationFunction];
							(*3. Check to see if the liquid height is enough*)
							(*if there is a calibration function we can use it to figure out if there is enough*)
							enoughSampleVolumeCheck=If[Not[NullQ[calibrationFunction]]&&multipleProbesQ&&Not[NullQ[Lookup[instrumentModelPacket,ProbeDiameters]]],
									(*figure out the volume this translates to for the container using the calibration function*)
									minDepthToVolume=calibrationFunction[minDepth];
									(*calculate the minimum sample volume for this container*)
									minVolume=minDepthToVolume-displacedVolume;
									(*check to see if the sample volume exceeds this threshold*)
									MatchQ[workingVolume,GreaterEqualP[minVolume]]
								,
								True
							];
							(*4. Check to see that the probe can reach into the liquid for a large container*)
							(*get the container height and probe length*)
							containerHeight=Last[Lookup[containerModelPacket,Dimensions]];
							probeLength=Max[Lookup[instrumentModelPacket,ProbeLengths]];
							(*see if the probe length is shorter than the container height*)
							isProbeShorter=MatchQ[probeLength,LessP[containerHeight]];
							(*If shorter, go through module to see if probe can reach the liquid*)
							canReachCheck=If[And[isProbeShorter,Not[NullQ[calibrationFunction]],multipleProbesQ],
								(
									(*calculate the minimum height the liquid can be*)
									minHeightSample=containerHeight-probeLength+minDepth;
									(*calculate the needed volume here*)
									volAtMinHeight=calibrationFunction[minHeightSample]-displacedVolume;
									(*does the sample volume exceed this?*)
									MatchQ[workingVolume,GreaterEqualP[volAtMinHeight]]
								),
								True
							];

							(*return the values*)
							{apertureBigEnoughCheck,enoughSampleVolumeCheck,canReachCheck}
						],
						(* ELSE: We are not dealing with an immersion probe so these problems cannot exist. *)
						{True,True,True}
					];

					(*do the same thing if we have probes*)
					{
						probeApertureBigEnoughBool,
						probeEnoughSampleVolumeBool,
						probeCanReachBool
					}= If[multipleProbesQ,
						Transpose@Map[
							Function[{currentProbe},
								(*get the packet*)
								currentProbePacket=fetchPacketFromCache[currentProbe, combinedSimulationAndCache];
								If[MatchQ[Lookup[currentProbePacket,ProbeType],Immersion],
									Module[{probeApertureBigEnoughQ,minDepth,displacedVolume,calibrationFunction,enoughSampleVolumeQ,
										containerHeight,probeLength,isProbeShorter,canReachCheckQ},

										(*check if the aperture is big enough*)
										probeApertureBigEnoughQ=MatchQ[Lookup[currentProbePacket, ShaftDiameter], LessP[measurepHApertureLookup[containerModelPacket]]];
										(*get the min height from the instrument model field*)
										minDepth=Lookup[currentProbePacket,MinDepth];
										(*calculate the displaced volume from the probe insertion*)
										displacedVolume=UnitConvert[minDepth*Pi*(Lookup[currentProbePacket,ShaftDiameter]/2)^2,Milliliter];
										(*get the calibration function from the packet*)
										calibrationFunction=Lookup[containerModelPacket,CalibrationFunction];
										(*3. Check to see if the liquid height is enough*)
										(*if there is a calibration function we can use it to figure out if there is enough*)
										enoughSampleVolumeQ=If[Not[NullQ[calibrationFunction]],
											(*figure out the volume this translates to for the container using the calibration function*)
											minDepthToVolume=calibrationFunction[minDepth];
											(*calculate the minimum sample volume for this container*)
											minVolume=minDepthToVolume-displacedVolume;
											(*check to see if the sample volume exceeds this threshold*)
											MatchQ[workingVolume,GreaterEqualP[minVolume]],
											True
										];
										(*4. Check to see that the probe can reach into the liquid for a large container*)
										(*get the container height and probe length*)
										containerHeight=Last[Lookup[containerModelPacket,Dimensions]];
										probeLength=Lookup[instrumentModelPacket,ShaftLength];
										(*see if the probe length is shorter than the container height*)
										isProbeShorter=MatchQ[probeLength,LessP[containerHeight]];
										(*If shorter, go through module to see if probe can reach the liquid*)
										canReachCheckQ=If[And[isProbeShorter,Not[NullQ[calibrationFunction]],multipleProbesQ],
											(
												(*calculate the minimum height the liquid can be*)
												minHeightSample=containerHeight-probeLength+minDepth;
												(*calculate the needed volume here*)
												volAtMinHeight=calibrationFunction[minHeightSample]-displacedVolume;
												(*does the sample volume exceed this?*)
												MatchQ[workingVolume,GreaterEqualP[volAtMinHeight]]
											),
											True
										];
										(*return the values*)
										{probeApertureBigEnoughQ,enoughSampleVolumeQ,canReachCheckQ}
									],
									Module[{probeApertureBigEnoughQ,canReachCheckQ,enoughSampleVolumeQ},
										probeApertureBigEnoughQ=True;
										canReachCheckQ=True;
										enoughSampleVolumeQ=Lookup[currentProbePacket,MinSampleVolume]<=workingVolume;
										{probeApertureBigEnoughQ,enoughSampleVolumeQ,canReachCheckQ}
									]
								]
							],
							availableProbes
						],
						List[
							{},{},{}
						]
					];

					(*if the instrument doesn't have probes, then we consider from the stand point of the instrument; otherwise, we do the probes*)

					(*If too short, return an error*)
					tooShortProblem=Which[
						multipleProbesQ&&Not[canReach], {"The liquid level cannot be reached by the probe."},
						multipleProbesQ&&And@@Map[Not,probeCanReachBool], {"The liquid level cannot be reached by the probe."},
						True,{}
					];

					(*if probe is too big, describe the problem*)
					probeTooBigProblem=Which[
						multipleProbesQ&&Not[apertureBigEnough],{"Probe is too big for container."},
						multipleProbesQ&&And@@Map[Not,probeApertureBigEnoughBool],{"Probe is too big for container."},
						True,{}
					];

					(*if not enough sample, describe the problem*)
					enoughSampleProblem=Which[
						multipleProbesQ&&Not[enoughSampleVolume],{"The volume is not enough for measurement. Note that for immersion probes the volume must be sufficient to reach a certain height on the probe."},
						multipleProbesQ&&And@@Map[Not,probeEnoughSampleVolumeBool],{"The volume is not enough for measurement. Note that for immersion probes the volume must be sufficient to reach a certain height on the probe."},
						True,{}
					];


					(*Find all of the suitable probes if there are any*)
					suitableProbesBool=If[multipleProbesQ,
						Map[
							And@@#&,
							Transpose[
								{
									probeApertureBigEnoughBool,
									probeEnoughSampleVolumeBool,
									probeCanReachBool
								}
							]
						],
						{}
					];

					(* Return a boolean that indicates if the sample is compatible and a list of problems, if any were found. *)
					{
						And[sampleCompatible,apertureBigEnough,enoughSampleVolume,canReach],
						If[multipleProbesQ,PickList[availableProbes,suitableProbesBool],{}],
						Flatten[{compatibilityProblem,probeTooBigProblem,enoughSampleProblem,tooShortProblem}]
					}
				]
			],
			{
				instrumentModelPackets,
				filteredProbesForEachModel
			}
		]
	];

	(*break up the mapped results*)
	{validInstrumentBool,validProbeNestedList,problemList}= If[Length[instrumentModels]>0, Transpose[mappingResult], {{},{},{"Probe not in the instrument"}}];

	(*Get all of the suitable instruments and probes; otherwise, return an empty list*)
	{suitableInstruments,suitableProbes}=If[Or@@validInstrumentBool,
		{
			PickList[instrumentModels,validInstrumentBool],
			PickList[validProbeNestedList,validInstrumentBool]
		},
		{{},{}}
	];

	{suitableInstruments,suitableProbes,problemList}
];



(* ::Subsection::Closed:: *)
(*ExperimentMeasurepHOptions*)


DefineOptions[ExperimentMeasurepHOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"General"
		}
	},
	SharedOptions :> {ExperimentMeasurepH}
];


ExperimentMeasurepHOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options *)
	options = ExperimentMeasurepH[myInputs, Append[noOutputOptions, Output -> Options]];


	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentMeasurepH],
		options
	]
];



(* ::Subsection::Closed:: *)
(*ExperimentMeasurepHPreview*)


(* currently we only accept either a list of containers, or a list of samples *)
ExperimentMeasurepHPreview[myInput:ListableP[ObjectP[{Object[Container], Model[Sample]}]] | ListableP[ObjectP[Object[Sample]]|_String],myOptions:OptionsPattern[ExperimentMeasurepH]]:=
		ExperimentMeasurepH[myInput,Append[ToList[myOptions],Output->Preview]];



(* ::Subsection::Closed:: *)
(*ValidExperimentMeasurepHQ*)


DefineOptions[ValidExperimentMeasurepHQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions :> {ExperimentMeasurepH}
];

(* currently we only accept either a list of containers, or a list of samples *)
ValidExperimentMeasurepHQ[myInput:ListableP[ObjectP[{Object[Container], Model[Sample]}]] | ListableP[ObjectP[Object[Sample]]|_String],myOptions:OptionsPattern[ValidExperimentMeasurepHQ]]:=Module[
	{listedOptions, listedInput, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedInput = ToList[myInput];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentMeasurepH *)
	filterTests = ExperimentMeasurepH[myInput, Append[preparedOptions, Output -> Tests]];

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
	(* like if I ran OptionDefault[OptionValue[ValidExperimentMeasurepHQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentMeasurepHQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentMeasurepHQ"]
];


measurepHApertureLookup[containerModelPacket:PacketP[]]:=If[MatchQ[containerModelPacket,ObjectP[Model[Container,Plate]]],
	(* WellDiameter is set for round wells. Otherwise WellDimensions is in the form {width, depth}. Join up, from the depth then take whatever's set *)
	FirstCase[Most[Flatten[Lookup[containerModelPacket,{WellDiameter, WellDimensions}]]],Except[Null]],
	Lookup[containerModelPacket,Aperture]
];