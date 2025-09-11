(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentIRSpectroscopy*)


(* ::Subsubsection:: *)
(*Options*)


DefineOptions[ExperimentIRSpectroscopy,
	Options :> {
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, Spectrophotometer, "Bruker ALPHA"],
			Description -> "The spectrometer used for this Infrared (IR) spectroscopy measurement.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, Spectrophotometer], Object[Instrument, Spectrophotometer]}]
			],
			Category->"Protocol"
		},
		{
			OptionName -> SampleModule,
			Default -> Automatic,
			Description -> "The type of instrument apparatus used to hold the sample for this Infrared (IR) measurement. Affects the manner of the IR beam through the sample and the amount required.",
			AllowNull -> False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SpectrophotometerModuleP (*Reflection|Transmission*)
			],
			ResolutionDescription -> "For samples with enough volume and requisite chemical compatibility, the Reflection module will be picked. This entails directly measuring the sample on an Attenuated total reflection (ATR) surface. Low volume/mass samples can otherwise be measured using KBr or ZnSe plates.",
			Category->"Protocol"
		},
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			Description -> "The number of times to repeat spectroscopy reading on each provided sample. If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterEqualP[2,1]
			],
			Category->"Protocol"
		},

		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleAmount,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> (RangeP[1 Microliter, 500 Microliter]|RangeP[1 Milligram, 500 Milligram]),
					Units:>Alternatives[
						{1,{Microliter,{Microliter,Milliliter}}},
						{1,{Milligram,{Milligram,Gram,Microgram}}}
						]
				],
				Description -> "The volume or mass of the sample that will be used for measurement.",
				ResolutionDescription -> "Automatically resolves to 20 uL is the sample state is a Liquid; otherwise, resolves to 20 mg.",
				Category->"Sample Handling"
			},
			{
				OptionName -> PressSample,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
				Description -> "Indicates if the sample should have pressure application through measurement on the ATR measurement surface.",
				ResolutionDescription -> "Automatically resolves to False for liquid samples and solid samples with a specified SuspensionSolution. Resolves to True for solid samples without a SuspensionSolution specified.",
				Category->"Sample Handling"
			},
			{
				OptionName->SuspensionSolution,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Description->"The model or sample (e.g. mineral oil), which will be directly added after the input sample and pipette mixed on the sampling apparatus before measurement.",
				ResolutionDescription->"Resolves to mineral oil if a SuspensionSolutionVolume is supplied, otherwise Null.",
				Category->"Sample Handling"
			},
			{
				OptionName->SuspensionSolutionVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 Microliter, 500 Microliter],
					Units :> {1,{Microliter,{Microliter,Milliliter}}}
				],
				Description->"The model or sample (e.g. mineral oil), which will be directly added to the input sample and pipette mixed on the sampling apparatus before measurement.",
				ResolutionDescription->"Automatically resolves to Null if SuspensionSoluton is Null. Otherwise, resolves to 20 microliters.",
				Category->"Sample Handling"
			},
			{
				OptionName->Blanks,
				Default->Automatic,
				AllowNull->True,
				Widget -> Alternatives[
					"Single Blank"->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}],ObjectTypes->{Model[Sample],Object[Sample]}],
					"Separate Blanks"->{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic, Null]
							]
						],
						"Sample" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
								ObjectTypes -> {Model[Sample], Object[Sample]}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic, Null]
							]
						]
					}
				],
				Description->"The model or sample whose absorbance will be subtract as background from the absorbance measurement of the SamplesIn. The numeric index indicates when these subtracting samples are shared for different input samples.",
				ResolutionDescription -> "Automatically set to the so that Blank index matches across samples. If no Blank is specified, then set to Null.",
				Category->"Sample Handling"
			},
			{
				OptionName -> BlankAmounts,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> (RangeP[20 Microliter,500 Microliter]|RangeP[20 Milligram, 500 Milligram]),
					Units:>Alternatives[
						{1,{Microliter,{Microliter,Milliliter}}},
						{1,{Milligram,{Milligram,Gram,Microgram}}}
					]
				],
				Description -> "The amount of the Blanks that should be used for the background measurement.",
				ResolutionDescription -> "Automatically resolves to Null if Blanks is Null. Otherwise, resolves to SampleAmount + SuspensionSolutionVolume (if defined).",
				Category->"Sample Handling"
			},
			{
				OptionName -> PressBlank,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
				Description -> "Indicates if the Blanks should have pressure application through measurement on the ATR measurement surface.",
				ResolutionDescription -> "Automatically resolves to False for liquid Blanks samples. Resolves to True for solid samples.",
				Category->"Sample Handling"
			},
			{
				OptionName -> RecoupSample,
				Default -> False,
				AllowNull->False,
				Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
				Description -> "Indicates if the transferred liquid used for IR measurement will be recouped or transferred back into the original container upon completing the measurement.",
				Category -> "Sample Handling"
			},
			{
				OptionName->IntegrationTime,
				Default->Automatic,
				Description->"The amount of time for which the spectroscopy measurement reading should occur for a given sample and background measurement. Readings occur in discrete readings. The resulting spectrum is the averaged reading for each discrete reading.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:> RangeP[0.1 Minute, 10 Minute], Units:>{1,{Minute,{Minute,Second}}}],
				ResolutionDescription -> "If neither IntegrationTime nor NumberOfReadings are set, then IntegrationTime is resolved to 1 minute. If NumberOfReadings is set, IntegrationTime is resolved to Null.",
				Category->"Absorbance Parameters"
			},
			{
				OptionName->NumberOfReadings,
				Default->Null,
				Description->"Number of redundant readings which should be taken by the detector to determine a single averaged IR spectrum measurement. Either IntegrationTime or NumberofReadings can be set but not both.",
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern:>RangeP[1,200,1]],
				Category->"Absorbance Parameters"
			},
			{
				OptionName -> MinWavenumber,
				Default -> Automatic,
				Description -> "The minimum wavenumber of the spectrum range to be measured and viewed. Either MinWavenumber or MaxWavelength can be specified but not both.",
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[100 (Centimeter)^(-1),8000 (Centimeter)^(-1)], Units:>{-1,{Centimeter,{Centimeter,Millimeter,Micrometer}}}],
				ResolutionDescription -> "If neither MinWavenumber nor MaxWavelength are set, then MinWavenumber is resolved to 400 1/centimeter. If MaxWavelength is set, MinWavenumber is resolved to Null.",
				Category->"Absorbance Parameters"
			},
			{
				OptionName -> MaxWavenumber,
				Default -> Automatic,
				Description -> "The maximum wavenumber of the spectrum range to be measured and viewed. Either MinWavenumber or MaxWavelength can be specified but not both.",
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[100 (Centimeter)^(-1),8000 (Centimeter)^(-1)], Units:>{-1,{Centimeter,{Centimeter,Millimeter,Micrometer}}}],
				ResolutionDescription -> "If neither MaxWavenumber nor MinWavelength are set, then MaxWavenumber is resolved to 4000/centimeter. If MinWavelength is set, MaxWavenumber is resolved to Null.",
				Category->"Absorbance Parameters"
			},
			{
				OptionName -> MinWavelength,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1250 Nanometer,100 Micrometer], Units:>{1,{Nanometer,{Nanometer,Centimeter,Millimeter,Micrometer}}}],
				ResolutionDescription -> "If neither IntegrationTime nor NumberOfReadings are set, then NumberOfReadings is resolved to Null because IntegrationTime will be set. If IntegrationTime is set, NumberOfReadings is resolved to Null.",

				Description -> "The minimum wavelength of the spectrum range to be measured and viewed. Either MinWavenumber or MinWavelength can be set but not both. This value will be convert to Wavenumber for measurement.",
				Category->"Absorbance Parameters"
			},
			{
				OptionName -> MaxWavelength,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1250 Nanometer,100 Micrometer], Units:>{1,{Nanometer,{Nanometer,Centimeter,Millimeter,Micrometer}}}],
				Description -> "The maximum wavelength of the spectrum range to measured and viewed. Either MaxWavenumber or ManWavelength can be set but not both. This value will be convert to Wavenumber for measurement.",
				Category->"Absorbance Parameters"
			},
			{
				OptionName -> WavenumberResolution,
				Default -> 4 (Centimeter)^(-1),
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[2 (Centimeter)^(-1),256 (Centimeter)^(-1)], Units:>{-1,{Centimeter,{Centimeter,Millimeter,Micrometer}}}],
				Description -> "The delta of wavenumbers to measure Infrared over.",
				Category->"Absorbance Parameters"
			}
		],
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		SimulationOption,
		ModifyOptions[
			ModelInputOptions,
			OptionName -> PreparedModelContainer
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 0.5 Milliliter."
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentIRSpectroscopy (sample input)*)


(*Invalid Input error*)
Error::DiscardedSamples="The following input samples `1` are discarded and thereby cannot be used for the experiment.";
Error::ImproperSampleAmount="The following sample(s) `1` have an incompatible specified SampleAmount. If SampleAmount is a mass, Mass of the sample(s) should be informed. If SampleAmount is a volume, Volume of the sample(s) should be informed.";
Error::ImproperBlankAmount="The following sample(s) `1` have an incompatible specified BlankAmount. If SampleAmount is a mass, Mass of the sample(s) should be informed. If SampleAmount is a volume, Volume of the sample(s) should be informed.";
Error::SampleHasNoQuantity="The following sample(s) `1` should have either the Mass or Volume fields informed; measurement cannot proceed otherwise. Please enqueue MeasureVolume or MeasureWeight.";
Error::BlankHasNoQuantity="The following Blanks samples `1` should have either the Mass or Volume fields informed; measurement cannot proceed otherwise. Please enqueue MeasureVolume or MeasureWeight.";
Error::NotEnoughSample="The following input samples `1` do not have sufficient quantity in order to perform measurement for the experiment.";
Error::IncompatibleSample="The input sample(s) `1` are chemically incompatible with any instrument. The experiment cannot be performed with these samples.";
Error::IncompatibleBlanks="The input sample(s) `1` have specified Blanks `2` that are chemically incompatible with any instrument. The experiment cannot be performed with these Blanks, please specify another.";
Error::IncompatibleSuspensionSolution="The input sample(s) `1`  have specified SuspensionSolution `2` that are chemically incompatible with any instrument. The experiment cannot be performed with these SuspensionSolution, please specify another.";
Error::UnsuitableInstrument="The specified Instrument `1` cannot measure Infrared. Please specify an IR-capable instrument or leave Instrument unspecified.";
Error::IRSpectroscopyTooManySamples="The (number of input samples * NumberOfReplicates) exceeds the threshold for measurement for this protocol.  Please select fewer than `1` samples to run this protocol.";

(*Errors from resolution*)
Error::SuspensionVolumeNull="The SuspensionSolutionVolume cannot be Null when a SuspensionSolution is specified for the following sample(s): `1`."; (*suspensionSolutionSpecifiedVolumeNull*)
Error::SuspensionSolutionNull="The SuspensionSolution cannot be Null when SuspensionSolutionVolume is specified for the following sample(s): `1`.";
Error::BlankSpecifiedNull="For the following samples `1`, Blanks and BlanksAmount must both be specified or both be Null.";
Error::NoBlanks="For the following samples `1`, the PressBlank option was specified without the Blanks options and suitable blanks couldn't be resolved. Please specify the Blanks options or leave PressBlank as automatic.";
Error::BlankIndexSpecifiedNull="For the following options `1`, the object and index within Blanks must both be specified or both be Null.";
Error::SameBlankIndexDifferentObjects="For the following options `1`, the same blank index was used, but the specified Blank sample was different.";
Error::IntegrationReadingsNull="For the following sample(s): `1`, IntegrationTime and NumberOfReadings is set to Null. Please specify one or set IntegrationTime to Automatic."; (*integrationTimeNumberOfReadingsBothNull*)
Error::IntegrationReadingsSpecified="For the following sample(s): `1`, IntegrationTime and NumberOfReadings is specified. Please specify one or set IntegrationTime to Automatic."; (*integrationTimeNumberOfReadingsBothSpecified*)
Error::MinWavenumberMaxWavelengthBothNull="For the following sample(s): `1`, MinWavenumber and MaxWavelength is set to Null. Please specify one or set MinWavenumber to Automatic."; (*minWavenumberMaxWavelengthBothNull*)
Error::MinWavenumberMaxWavelengthBothSpecified="For the following sample(s): `1`, MinWavenumber and MaxWavelength is set to Null. Please specify one or set MinWavenumber to Automatic."; (*minWavenumberMaxWavelengthBothSpecified*)
Error::MaxWavenumberMinWavelengthBothNull="For the following sample(s): `1`, MaxWavenumber and MinWavelength is set to Null. Please specify one or set MaxWavenumber to Automatic."; (*maxWavenumberMinWavelengthBothNull*)
Error::MaxWavenumberMinWavelengthBothSpecified="For the following sample(s): `1`, MaxWavenumber and MinWavelength is set to Null. Please specify one or set MaxWavenumber to Automatic."; (*maxWavenumberMinWavelengthBothSpecified*)
Error::MinWavenumberGreaterThanMax="For the following sample(s): `1`, the calculated min. wavenumber is greater than the max wavenumber. Please adjust MinWavenumber/MaxWavenumber (or MaxWavelength/MinWavelength) accordingly."; (*minWavenumberGreaterThanMax*)
Error::IndexDifferentSameObject="For the following sample(s): a Blanks object sample is shared, but the specified Index is different. This will be ignored.";

Warning::RecoupSuspensionSolution="For the following sample(s): `1`, Recouping is requested along with a SuspensionSolution. This will add the SuspensionSolution to the input sample.";
Warning::ReflectionOnly="Transmission sample module was requested. Currently, we only offer Reflection sample module for the sample loading and measurement. The experiment function will proceed with this.";
Warning::PressureApplicationWithFluidSample="Pressure application was requested for `1` sample(s), which will be liquid/wetted upon measurement. Pressure application may adversely affect measurement.";
Warning::PressureApplicationWithFluidSampleBlanks="Pressure application was requested for `1` Blanks, which are/is liquid. Pressure application may adversely affect measurement.";
Warning::DryNoPressure="Pressure application was not requested for the following dry `1` sample(s). The lack of pressure may adversely affect measurement.";
Warning::DryNoPressureBlanks="Pressure application was not requested for the following `1` Blanks. The lack of pressure may adversely affect measurement.";
Warning::SuspensionSolutionResolved="Suspension solutions of `1` were resolved for the samples `2`. The aliquot of sample used for measurement will be mixed with this solution and additional peaks may be observed in the spectrum.";

ExperimentIRSpectroscopy[mySamples:ListableP[NonSelfContainedSampleP],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed,
		safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,
		inheritedCache, cacheBall,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,
		optionsWithObjects,

		(*Needed for the download*)
		allSpectrometerModels, potentialContainers,samplesAsList,blanksLookup,blanksModels,suspensionSolutionLookup,
		blanksObjects,suspensionSolutionModels,suspensionSolutionObjects, objectSampleFields, objectModelFields, objectModelContainerFields,
		modelBlankFields,blankSampleFields,blankModelFields,suspensionSampleFields,suspensionModelFields,potentialContainersFields,
		listedSamples, updatedSimulation
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentIRSpectroscopy,
			listedSamples,
			listedOptions
		],
		$Failed,
	 	{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentIRSpectroscopy,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentIRSpectroscopy,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Sanitize Inputs *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentIRSpectroscopy,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentIRSpectroscopy,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentIRSpectroscopy,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentIRSpectroscopy,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentIRSpectroscopy,{mySamplesWithPreparedSamples},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(*samples*)
	samplesAsList=mySamplesWithPreparedSamples;

	(*search for all instruments*)
	allSpectrometerModels=Search[Model[Instrument, Spectrophotometer]];

	(*look up information about the specified blanks. If tupled, we only care about the objects*)
	blanksLookup=(#/.{_,obj_}:>obj)&/@Lookup[myOptionsWithPreparedSamples,Blanks];

	(*look up information about the specified SuspensionSolution*)
	suspensionSolutionLookup=Lookup[myOptionsWithPreparedSamples,SuspensionSolution];

	(*get all of the model objects and add the water object*)
	blanksModels=DeleteDuplicates@Join[Cases[blanksLookup,ObjectP[Model[Sample]]],{Model[Sample,"Milli-Q water"]}];

	(*get all of the blank objects*)
	blanksObjects=DeleteDuplicates[Cases[blanksLookup,ObjectP[Object[Sample]]]];

	(*get all of the suspension solution models and objects*)
	suspensionSolutionModels=DeleteDuplicates[Cases[suspensionSolutionLookup,ObjectP[Model[Sample]]]];
	suspensionSolutionObjects=DeleteDuplicates[Cases[suspensionSolutionLookup,ObjectP[Object[Sample]]]];

	(* Get all the potential aliquot containers*)
	potentialContainers=PreferredContainer[All];

	(*Create list of fields to download for object samples*)
	objectSampleFields = Packet@@Union[SamplePreparationCacheFields[Object[Sample]], {Analytes, Density, State, pH, IncompatibleMaterials}];
	objectModelFields = Union[SamplePreparationCacheFields[Model[Sample]],{Products, FillToVolumeSolvent}];
	objectModelContainerFields = Union[SamplePreparationCacheFields[Model[Container]], {VolumeCalibrations, OpenContainer}];

	(*Create list of fields to download for blank models*)
	modelBlankFields = Packet@@Union[SamplePreparationCacheFields[Model[Sample]], {Density, IncompatibleMaterials, Products}];

	(*Create list of fields to download for blank objects*)
	blankSampleFields = Packet@@Union[SamplePreparationCacheFields[Object[Sample]], {Analytes, Density, State, IncompatibleMaterials}];
	blankModelFields = Union[SamplePreparationCacheFields[Model[Sample]], {Density}];

	(*Create list of fields to download for suspension solution objects*)
	suspensionSampleFields = Packet@@Union[SamplePreparationCacheFields[Object[Sample]], {Analytes, State, IncompatibleMaterials}];
	suspensionModelFields = Union[SamplePreparationCacheFields[Model[Sample]], {Density}];

	(*Create list of fields to download for potential containers*)
	potentialContainersFields = Packet@@Union[SamplePreparationCacheFields[Model[Container]]];

	(* Create list of options that can take objects *)
	optionsWithObjects={Instrument,SuspensionSolution,Blanks};

	inheritedCache = Lookup[safeOps, Cache, {}];

	cacheBall=Cases[FlattenCachePackets[{
		inheritedCache,
		Quiet[Download[
			{
				samplesAsList,
				allSpectrometerModels,
				blanksModels,
				blanksObjects,
				suspensionSolutionModels,
				suspensionSolutionObjects,
				potentialContainers
			},
			{
				{
					objectSampleFields,
					Packet[Model[objectModelFields]],
					Packet[Container[Model][objectModelContainerFields]],
					Packet[Model[FillToVolumeSolvent][{Object,Name}]],
					Packet[Field[Composition[[All,2]]][{Object, Name, MolecularWeight}]]
				},
				{
					Packet[Name,Objects,WettedMaterials,ElectromagneticRange(*TODO: add this to the model- InstrumentModule,MinSampleVolume*)],
					Packet[Objects[{Name,Status,Model,Balance (*TODO: will need the sampling module type*)}]]
				},
				{
					modelBlankFields
				},
				{
					blankSampleFields,
					Packet[Model[blankModelFields]]
				},
				{
					Packet[Name,State,IncompatibleMaterials]
				},
				{
					suspensionSampleFields,
					Packet[Model[suspensionModelFields]]
				},
				{
					potentialContainersFields
				}
			},
			Cache -> inheritedCache,
			Simulation -> updatedSimulation,
			Date -> Now
		],{Download::FieldDoesntExist,Download::NotLinkField}]
	}],_Association]; (* Quiet[Download[...],Download::FieldDoesntExist] *)

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentIRSpectroscopyOptions[mySamplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {resolveExperimentIRSpectroscopyOptions[mySamplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation], {}},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentIRSpectroscopy,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentIRSpectroscopy,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets, resourcePacketTests} = If[gatherTests,
		irSpectroscopyResourcePackets[mySamplesWithPreparedSamples, templatedOptions, resolvedOptions, collapsedResolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		{irSpectroscopyResourcePackets[mySamplesWithPreparedSamples, templatedOptions, resolvedOptions, collapsedResolvedOptions, Cache -> cacheBall, Simulation -> updatedSimulation], {}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentIRSpectroscopy,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			CanaryBranch->Lookup[safeOps,CanaryBranch],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,IRSpectroscopy],
			Cache -> cacheBall,
			Simulation -> updatedSimulation
	],
	$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests(*,resourcePacketTests*)}],
		Options -> RemoveHiddenOptions[ExperimentIRSpectroscopy,collapsedResolvedOptions],
		Preview -> Null
	}
];

ExperimentIRSpectroscopy[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
	containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests,updatedCache,sampleCache, updatedSimulation, containerToSampleSimulation
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentIRSpectroscopy,
			ToList[myContainers],
			ToList[myOptions],
			DefaultPreparedModelAmount -> 0.5 Milliliter
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
	(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests, containerToSampleSimulation}=containerToSampleOptions[
			ExperimentIRSpectroscopy,
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
			{containerToSampleOutput, containerToSampleSimulation}=containerToSampleOptions[
				ExperimentIRSpectroscopy,
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
		{samples,sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentIRSpectroscopy[samples,ReplaceRule[sampleOptions,Simulation -> containerToSampleSimulation]]
	]
];


(* ::Subsection:: *)
(*resolveExperimentIRSpectroscopyOptions*)


DefineOptions[
	resolveExperimentIRSpectroscopyOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentIRSpectroscopyOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentIRSpectroscopyOptions]]:=Module[
	{outputSpecification,output,gatherTests,cache,cacheFailedRemoved,samplePrepOptions,irSpectroscopyOptions,simulatedSamples,
		resolvedSamplePrepOptions,irSpectroscopyOptionsAssociation,allSpectrometerModels,
		instrumentLookup,infraredInstrumentModelPackets,
		invalidInputs,invalidOptions,
		allDownloadValues,allSampleDownloadValues,instrumentDownloadValues,blankModelDownloadValues,blankObjectDownloadValues,suspensionSolutionModelDownloadValues,suspensionSolutionObjectDownloadValues,
		samplePackets,sampleModelPackets,sampleContainerModelPackets,sampleSolventModelPackets,instrumentModelPackets,instrumentObjectPackets,
		blankModelPackets,blankObjectPackets,blankObjectModelPackets,suspensionSolutionModelPackets,suspensionSolutionObjectPackets,suspensionSolutionObjectModelPackets,
		discardedSampleBool,discardedSamplePackets,discardedInvalidInputs,discardedTests,
		quantityNotDefinedBool,quantityNotDefinedPackets,quantityNotDefinedInputs,quantityNotDefinedTests,
		blankQuantityNotDefinedBool,blankQuantityNotDefinedOptions,blankQuantityNotDefinedTests,blankPacketFetch,blankQuantityNotDefinedBlanks,
		incompatibleUnitBool,incompatibleUnitSampleAmountInputs,incompatibleUnitSampleAmountTests,
		incompatibleBlankUnitBool,incompatibleBlankAmountInputs,incompatibleBlankAmountOptions,incompatibleBlankUnitSampleAmountTests,
		indexedBlankPackets,blankInstrumentCombinations,incompatibleBlankBool,incompatibleBlankBoolMatrix,incompatibleBlanksInputsBool,incompatibleBlanksInputsAnyInstrument,
		incompatibleBlanksOptionsAnyInstrument,incompatibleInputBlanksAnyInstrumentTests,
		incompatibleBlanksAnyInstrument,indexedSuspensionSolutionModelPackets,suspensionSolutionInstrumentCombinations,incompatibleSuspensionSolutionBool,
		incompatibleSuspensionSolutionBoolMatrix,incompatibleSuspensionSolutionInputsBool,incompatibleSuspensionSolutionInputsAnyInstrument,incompatibleSuspensionSolutionsAnyInstrument,
		incompatibleSuspensionSolutionOptionsAnyInstrument,incompatibleSuspensionSolutionAnyInstrumentTests,
		globalMinVolume,lowSampleVolumeBool,lowSampleAmountInputs,lowSampleVolumeTest,lowSampleAmountPackets,
		globalMinMass,lowSampleMassBool,lowSampleAmountBool,
		measurementLimit,numberOfReplicatesNumber,numberOfMeasurements,tooManyMeasurementQ,tooManyMeasurementsTest,tooManyMeasurementsInputs,
		blankState,resolvedBlankPressure,blankDensityLookup,
		sampleInstrumentCombinations,incompatibleBool,incompatibleBoolMatrix,incompatibleInputsBool,incompatibleInputsAnyInstrument,incompatibleInputsAnyInstrumentTests,
		instrumentLookupModel,instrumentLookupModelPacket,instrumentIncapableBool,instrumentIncapableOptions,instrumentIncapableTest, sampleVolumeMassNullTest,
		sampleVolumeMassQuantityTest,suspensionSolutionResolvedPackets,suspensionSolutionResolvedInputs,suspensionSolutionResolvedSolutions,
		optionsWithRoundedVolumesMasses,optionsWithRoundedVolumes,precisionTestsVolumes,precisionTestsVolumesMasses,resolverResults,suspensionSolutionResolvedList,
		resolvedSampleModule,resolvedSampleAmounts,resolvedSuspensionSolutionVolumes,resolvedIntegrationTimes,resolvedMinWavenumbers,resolvedMaxWavenumbers,resolvedSuspensionSolutions,
		sampleAmountAsVolumeWithoutDensityList,suspensionSolutionSpecifiedVolumeNullList,suspensionSolutionVolumeSpecifiedSuspensionNullList,integrationTimeNumberOfReadingsBothNullList,
		integrationTimeNumberOfReadingsBothSpecifiedList,minWavenumberMaxWavelengthBothNullList,minWavenumberMaxWavelengthBothSpecifiedList,maxWavenumberMinWavelengthBothNullList,
		maxWavenumberMinWavelengthBothSpecifiedList,minWavenumberGreaterThanMaxList,blankAndBlankAmountsSpecifiedAndNullList,blankAmountAsVolumeWithoutDensityList,
		sampleModuleWarningQ, pressBlankWithNoBlanksList, pressBlankWithNoBlanksPackets, pressBlankWithNoBlanksInputs, pressBlankWithNoBlanksOptions, pressBlankWithNoBlanksTest,
		blanksIndexLookup,blankNullSpecifiedBool,nullSpecifiedBlanks,nullSpecifiedBlankOptions,nullSpecifiedBlankTest,
		blanksTupled,groupedBlankIndexAssociation,blankIndexCollapsedAssociation,indicesWithMultipleObjectsBool,multipleIndicesBlanks,multipleIndicesOptions,multipleIndicesTest,
		groupedBlankSampleAssociation,collapsedBlankSampleAssociation,multipleObjectBlankBool,multipleObjectsBlanks,multipleObjectsOptions,multipleObjectsTest,
		resolvedAliquotOptions,resolvedOptions,allTests,
		blanksModels,blanksObjects,suspensionSolutionModels,suspensionSolutionObjects,blankPressureLookup,samplePressureLookup,blankStatesLookup,
		sampleAmountLookup,suspensionSolutionVolumeLookup,blankAmountsLookup,integrationTimeLookup,numberOfReadingsLookup,minWavenumberLookup,maxWavelengthLookup,maxWavenumberLookup,minWavelengthLookup,
		blanksLookup,blankSampleLookup,suspensionSolutionLookup,sampleModuleLookup,semiResolvedBlanks,resolvedBlankAmounts,
		semiResolvedTuple,groupedSemiTuple,resolverDictionary,userRuleDictionary,resolvedBlanks,resolveFromUser,semiResolvedBlankIndices,countAutomatics,maximumIndex,integerCases,
		blankTupledAmounts,resolvedBlank,resolvedBlankAmount,semiResolvedBlankAmounts,
		newIndices,resolvedBlankIndices,resolvedBlanksTuple,userObjectDictionary,resolvedSamplePressures,samplePressureWithLiquidList,noSamplePressureSolidList,
		blankPressureWithLiquidList,noBlankPressureSolidList,temporaryDictionary,automaticsDictionary,replacedAutomaticsDictionary,simulatedSampleFields,simulatedModelFields,
		simulatedModelContainerFields,modelBlankFields,blankSampleFields,blankModelFields,suspensionSampleFields, suspensionModelFields,

		(*Map thread error checking*)
		suspensionSolutionSpecifiedVolumeNullPackets,suspensionSolutionSpecifiedVolumeNullInputs,suspensionSolutionSpecifiedVolumeNullOptions,suspensionSolutionSpecifiedVolumeNullTest,
		suspensionSolutionVolumeSpecifiedSuspensionNullPackets,suspensionSolutionVolumeSpecifiedSuspensionNullInputs,suspensionSolutionVolumeSpecifiedSuspensionNullOptions,suspensionSolutionVolumeSpecifiedSuspensionNullTest,
		integrationTimeNumberOfReadingsBothNullPackets,integrationTimeNumberOfReadingsBothNullInputs,integrationTimeNumberOfReadingsBothNullOptions,integrationTimeNumberOfReadingsBothNullTest,
		integrationTimeNumberOfReadingsBothSpecifiedPackets,integrationTimeNumberOfReadingsBothSpecifiedInputs,integrationTimeNumberOfReadingsBothSpecifiedOptions,integrationTimeNumberOfReadingsBothSpecifiedTest,
		minWavenumberMaxWavelengthBothNullPackets,minWavenumberMaxWavelengthBothNullInputs,minWavenumberMaxWavelengthBothNullOptions,minWavenumberMaxWavelengthBothNullTest,
		minWavenumberMaxWavelengthBothSpecifiedPackets,minWavenumberMaxWavelengthBothSpecifiedInputs,minWavenumberMaxWavelengthBothSpecifiedOptions,minWavenumberMaxWavelengthBothSpecifiedTest,
		maxWavenumberMinWavelengthBothNullPackets,maxWavenumberMinWavelengthBothNullInputs,maxWavenumberMinWavelengthBothNullOptions,maxWavenumberMinWavelengthBothNullTest,
		maxWavenumberMinWavelengthBothSpecifiedPackets,maxWavenumberMinWavelengthBothSpecifiedInputs,maxWavenumberMinWavelengthBothSpecifiedOptions,maxWavenumberMinWavelengthBothSpecifiedTest,
		minGreaterThanMinOptions,minGreaterThanMaxTest,minWavenumberGreaterThanMaxPackets,minGreaterThanMinInputs,recoupSuspensionBool,recoupSuspensionPackets,recoupSuspensionInputs,
		blankAndBlankAmountsSpecifiedAndNullPackets,blankAndBlankAmountsSpecifiedAndNullInputs,blankAndBlankAmountsSpecifiedAndNullOptions,blankAndBlankAmountsSpecifiedAndNullTest,
		samplePressureWithLiquidPackets,samplePressureWithLiquidInputs,noSamplePressureSolidPackets,noSamplePressureSolidInputs,
		blankPressureWithLiquidPackets,blankPressureWithLiquidInputs,noBlankPressureSolidPackets,noBlankPressureSolidInputs,

		(*final resolution*)
		sampleVolumes,sampleMasses,bestAliquotAmount,
		name, confirm, canaryBranch, template, samplesInStorageCondition, originalCache, operator, parentProtocol, upload, outputOption, email, imageSample,recoupSample,
		resolvedImageSample,resolvedEmail,resolvedPostProcessingOptions,numberOfReplicates,resultRule,testsRule,
		samplePrepTests, cacheBall, simulation, updatedSimulation
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache and simulation from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(*There is a chance that the container has no solvent packet. Remove such and check if we can resolve SamplePrepOptions*)
	cacheFailedRemoved=Cases[cache,Except[$Failed]];

	(* Separate out our IRSpectroscopy options from our Sample Prep options. *)
	{samplePrepOptions,irSpectroscopyOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentIRSpectroscopy, mySamples, samplePrepOptions, Cache -> cacheFailedRemoved, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentIRSpectroscopy, mySamples, samplePrepOptions, Cache -> cacheFailedRemoved, Simulation -> simulation, Output -> Result], {}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	irSpectroscopyOptionsAssociation=Association[irSpectroscopyOptions];

	(*search for all of the instruments that can perform IR*)
	allSpectrometerModels=Search[Model[Instrument, Spectrophotometer]]; (*[[{Object,ElectromagneticRange}]];*)

	(*look up information about the specified blanks*)
	blanksLookup=Lookup[irSpectroscopyOptionsAssociation,Blanks];

	(*separate the specific sample informatin*)
	blankSampleLookup=(#/.{_,obj_}:>obj)&/@blanksLookup;

	(*look up information about the specified SuspensionSolution*)
	suspensionSolutionLookup=Lookup[irSpectroscopyOptionsAssociation,SuspensionSolution];

	(*get all of the model objects and add the water object*)
	blanksModels=DeleteDuplicates@Join[Cases[blankSampleLookup,ObjectP[Model[Sample]]],{Model[Sample,"Milli-Q water"]}];

	(*get all of the blank objects*)
	blanksObjects=DeleteDuplicates[Cases[blankSampleLookup,ObjectP[Object[Sample]]]];

	(*get all of the suspension solution models and objects*)
	suspensionSolutionModels=DeleteDuplicates[Cases[suspensionSolutionLookup,ObjectP[Model[Sample]]]];
	suspensionSolutionObjects=DeleteDuplicates[Cases[suspensionSolutionLookup,ObjectP[Object[Sample]]]];

	(*Create Packet of fields to download from simulated samples*)
	simulatedSampleFields = Packet@@Union[SamplePreparationCacheFields[Object[Sample]],{State, pH, Density, IncompatibleMaterials, Analytes}];
	simulatedModelFields =  Union[SamplePreparationCacheFields[Model[Sample]],{Products, FillToVolumeSolvent}];
	simulatedModelContainerFields =  Union[SamplePreparationCacheFields[Model[Container]], {VolumeCalibrations}];

	(*Create Packet of fields to download for blank models*)
	modelBlankFields =  Packet@@Union[SamplePreparationCacheFields[Model[Sample]], {Density, IncompatibleMaterials}];

	(*Create Packet of fields to download for blank objects*)
	blankSampleFields =  Packet@@Union[SamplePreparationCacheFields[Object[Sample]], {Analytes, Density, State, IncompatibleMaterials}];
	blankModelFields =  Union[SamplePreparationCacheFields[Model[Sample]], {Density}];

	(*Create Packet of fields to download for suspension solution objects*)
	suspensionSampleFields =  Packet@@Union[SamplePreparationCacheFields[Object[Sample]], {State, IncompatibleMaterials, Analytes}];
	suspensionModelFields =  Union[SamplePreparationCacheFields[Model[Sample]], {Density}];

	(* Extract the packets that we need from our downloaded cache. *)
	allDownloadValues=Replace[Quiet[
		Download[
			{
				simulatedSamples ,
				allSpectrometerModels,
				blanksModels,
				blanksObjects,
				suspensionSolutionModels,
				suspensionSolutionObjects
			},
			{
				{
					simulatedSampleFields ,
					Packet[Model[simulatedModelFields]],
					Packet[Container[Model][simulatedModelContainerFields]],
					Packet[Model[FillToVolumeSolvent][{Object,Name}]]
				},
				{
					Packet[Name,Objects,WettedMaterials,ElectromagneticRange],
					Packet[Objects[{Name,Model,Balance}]]
				},
				{
					modelBlankFields
				},
				{
					blankSampleFields,
					Packet[Model[blankModelFields]]
				},
				{
					Packet[Name,State,IncompatibleMaterials]
				},
				{
					suspensionSampleFields,
					Packet[Model[suspensionModelFields]]
				}
			},
			Cache -> cacheFailedRemoved,
			Simulation -> updatedSimulation
		]
	],$Failed->Nothing,1];

	(* Combine the cache together *)
	cacheBall = FlattenCachePackets[{
		cacheFailedRemoved,
		allDownloadValues
	}];

	(*split the download packet based on object type*)
	{allSampleDownloadValues,instrumentDownloadValues,blankModelDownloadValues,blankObjectDownloadValues,suspensionSolutionModelDownloadValues,suspensionSolutionObjectDownloadValues}=allDownloadValues;

		(*pull out all the sample/sample model/container/container model packets*)
	samplePackets=allSampleDownloadValues[[All,1]];
	sampleModelPackets=allSampleDownloadValues[[All,2]];
	sampleContainerModelPackets=allSampleDownloadValues[[All,3]];
	sampleSolventModelPackets=allSampleDownloadValues[[All,4]];

	(*separate out the instrument model/objects*)
	instrumentModelPackets=instrumentDownloadValues[[All,1]];
	instrumentObjectPackets=instrumentDownloadValues[[All,2]];

	(*separate out the blank model/object packets*)
	blankModelPackets=blankModelDownloadValues[[All,1]];
	blankObjectPackets=blankObjectDownloadValues[[All,1]];
	blankObjectModelPackets=blankObjectDownloadValues[[All,2]];

	(*separate out the suspension solution model/object packets*)
	suspensionSolutionModelPackets=suspensionSolutionModelDownloadValues[[All,1]];
	suspensionSolutionObjectPackets=suspensionSolutionObjectDownloadValues[[All,1]];
	suspensionSolutionObjectModelPackets=suspensionSolutionObjectDownloadValues[[All,2]];


	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)

	(* 1. DISCARDED SAMPLES *)

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
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[discardedInvalidInputs,Cache->cacheBall]<>" is/are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs],Cache->cacheBall]<>" is/are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*Check whether we have a quantity defined for the sample*)

	quantityNotDefinedBool=Map[(!Or[QuantityQ[Lookup[#,Mass]],QuantityQ[Lookup[#,Volume]]])&,samplePackets];

	(*see which samples have a problems*)
	quantityNotDefinedPackets=PickList[samplePackets,quantityNotDefinedBool,True];

	(*  keep track of the invalid inputs *)
	quantityNotDefinedInputs=If[Length[quantityNotDefinedPackets]>0,
		Lookup[Flatten[quantityNotDefinedPackets],Object],
		(* if there are no discarded inputs, the list is empty *)
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[quantityNotDefinedInputs]>0&&!gatherTests,
		Message[Error::SampleHasNoQuantity,ObjectToString[quantityNotDefinedInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	quantityNotDefinedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[quantityNotDefinedInputs]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[quantityNotDefinedInputs,Cache->cacheBall]<>" have a quantity informed (Mass or Volume):",True,False]
			];
			passingTest=If[Length[quantityNotDefinedInputs]==Length[simulatedSamples],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,quantityNotDefinedInputs],Cache->cacheBall]<>" have a quantity informed (Mass or Volume):",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*blank object samples without a quantity*)

	blankQuantityNotDefinedBool=Map[(
		If[
			(*if it's an Object Sample, we'll apply our test*)
			MatchQ[#,ObjectP[Object[Sample]]],
				blankPacketFetch=fetchPacketFromCache[#,blankObjectPackets];
				!Or[QuantityQ[Lookup[blankPacketFetch,Mass]],QuantityQ[Lookup[blankPacketFetch,Volume]]],
			False
		]
		)&,
		blankSampleLookup];

	(*see which samples have a problems*)
	blankQuantityNotDefinedBlanks=PickList[blanksLookup,blankQuantityNotDefinedBool,True];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	blankQuantityNotDefinedOptions=If[Length[blankQuantityNotDefinedBlanks]>0&&!gatherTests,
		Message[Error::BlankHasNoQuantity,ObjectToString[blankQuantityNotDefinedBlanks,Cache->cacheBall]];
		{Blanks},
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	blankQuantityNotDefinedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[blankQuantityNotDefinedBlanks]==0,
			(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input Blanks(s) "<>ObjectToString[blankQuantityNotDefinedBlanks,Cache->cacheBall]<>" have a Blanks informed (Mass or Volume):",True,False]
			];
			passingTest=If[Length[blankQuantityNotDefinedBlanks]==Length[simulatedSamples],
			(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input Blanks(s) "<>ObjectToString[Complement[blanksLookup,blankQuantityNotDefinedBlanks],Cache->cacheBall]<>" have a Blanks quantity informed (Mass or Volume):",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*is the SampleAmount defined well? can we accommodate it (does the sample have the quantity?)*)
	incompatibleUnitBool=MapThread[(
		Which[
			(*if we're already through an error for quantityNotDefined, no reason to throw again*)
			#3,False,
			(*check if sample amount is a mass and whether we have mass or density info*)
			MatchQ[#2,GreaterP[0*Gram]], And[!QuantityQ[Lookup[#1,Density]],!QuantityQ[Lookup[#1,Mass]]],
			(*check if sample amount is a volume and whether we have volume or density info*)
			MatchQ[#2,GreaterP[0*Liter]], And[!QuantityQ[Lookup[#1,Density]],!QuantityQ[Lookup[#1,Volume]]],
			(*otherwise throw a false*)
			True,False
		]
	)&,{samplePackets,Lookup[irSpectroscopyOptionsAssociation,SampleAmount],quantityNotDefinedBool}];

	(*see which samples have a problems*)
	incompatibleUnitSampleAmountInputs=PickList[Lookup[samplePackets,Object],incompatibleUnitBool,True];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[incompatibleUnitSampleAmountInputs]>0&&!gatherTests,
		Message[Error::ImproperSampleAmount,ObjectToString[incompatibleUnitSampleAmountInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleUnitSampleAmountTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleUnitSampleAmountInputs]==0,
				(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[incompatibleUnitSampleAmountInputs,Cache->cacheBall]<>" have a quantity informed (Mass or Volume) compatible with the defined SampleAmount:",True,False]
			];
			passingTest=If[Length[incompatibleUnitSampleAmountInputs]==Length[simulatedSamples],
				(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,incompatibleUnitSampleAmountInputs],Cache->cacheBall]<>" have a quantity informed (Mass or Volume) compatible with the defined SampleAmount:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*is the BlankAmounts defined well? can we accommodate it (does the sample have the quantity?)*)
	incompatibleBlankUnitBool=MapThread[(
		Which[
			(*if we're already through an error for blankQuantityNotDefined, no reason to throw again*)
			#3,False,
			(*check if blank amount is a mass and whether we have mass or density info*)
			MatchQ[#1,ObjectP[Object[Sample]]]&&MatchQ[#2,GreaterP[0*Gram]],
				blankPacketFetch=fetchPacketFromCache[#,blankObjectPackets];
				And[!QuantityQ[Lookup[blankPacketFetch,Density]],!QuantityQ[Lookup[blankPacketFetch,Mass]]],
			(*check if blank amount is a volume and whether we have volume or density info*)
			MatchQ[#1,ObjectP[Object[Sample]]]&&MatchQ[#2,GreaterP[0*Liter]],
				blankPacketFetch=fetchPacketFromCache[#,blankObjectPackets];
				And[!QuantityQ[Lookup[blankPacketFetch,Density]],!QuantityQ[Lookup[blankPacketFetch,Volume]]],
			(*otherwise throw a false*)
			True,False
		]
	)&,{blankSampleLookup,Lookup[irSpectroscopyOptionsAssociation,BlankAmounts],blankQuantityNotDefinedBool}];

	(*see which samples have a problems*)
	incompatibleBlankAmountInputs=PickList[Lookup[samplePackets,Object],incompatibleBlankUnitBool,True];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	incompatibleBlankAmountOptions=If[Length[incompatibleBlankAmountInputs]>0&&!gatherTests,
		Message[Error::ImproperBlankAmount,ObjectToString[incompatibleBlankAmountInputs,Cache->cacheBall]];
		{Blanks,BlankAmounts},
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleBlankUnitSampleAmountTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleBlankAmountInputs]==0,
			(* when not a single sample is discarded, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input Blanks "<>ObjectToString[incompatibleBlankAmountInputs,Cache->cacheBall]<>" have a quantity informed (Mass or Volume) compatible with the defined BlankAmounts:",True,False]
			];
			passingTest=If[Length[incompatibleBlankAmountInputs]==Length[simulatedSamples],
			(* when ALL samples are discarded, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input Blanks "<>ObjectToString[Complement[simulatedSamples,incompatibleBlankAmountInputs],Cache->cacheBall]<>" have a quantity informed (Mass or Volume) compatible with the defined BlankAmounts:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* NOT enough sample*)

	(*TODO: be sure to add this to the instrument models and pull from there*)

	(*get the global minimum volume for sample*)
	globalMinVolume=20 Microliter;
	globalMinMass=20 Milligram;

	(*TODO: if the user specified an instrument, then use that one specifically*)
	(*TODO: if the sample is a mass, should check that as well*)

	(*check in the sample packets where the volume or mass is too small*)
	lowSampleVolumeBool=Map[MatchQ[Lookup[#,Volume],LessP[globalMinVolume]]&,samplePackets];
	lowSampleMassBool=Map[MatchQ[Lookup[#,Mass],LessP[globalMinMass]]&,samplePackets];

	(*find the positions that are true for either*)
	lowSampleAmountBool=MapThread[Or,{lowSampleVolumeBool,lowSampleMassBool}];

	(*get the sample objects that are low volume*)

	lowSampleAmountPackets=PickList[samplePackets,lowSampleAmountBool,True];

	lowSampleAmountInputs=If[Length[lowSampleAmountPackets]>0,
		Lookup[Flatten[lowSampleAmountPackets],Object],
	(* if there are no discarded inputs, the list is empty *)

		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[lowSampleAmountInputs]>0&&!gatherTests,
		Message[Error::NotEnoughSample,ObjectToString[lowSampleAmountInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)

	lowSampleVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[lowSampleAmountInputs]==0,
				(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[lowSampleAmountInputs,Cache->cacheBall]<>" have enough quantity for measurement:",True,False]
			];
			passingTest=If[Length[lowSampleAmountInputs]==Length[simulatedSamples],
				(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,lowSampleAmountInputs],Cache->cacheBall]<>" have enough quantity for measurement:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*3. Incompatible sample*)

	(*TODO: once we have the sample modules set up, this code will need to be changed to check when not Automatic*)

	(*get only the instrument packets for Infrared instruments*)
	infraredInstrumentModelPackets=Select[instrumentModelPackets,MemberQ[Lookup[#,ElectromagneticRange],Infrared]&];

	(*generate the material compatibility combination of instruments and samples*)
	sampleInstrumentCombinations=Tuples[{infraredInstrumentModelPackets,samplePackets}];

	(*get boolean for which sample/instrument combinations are incompatible (based on material). *)
	incompatibleBool=Map[Not[Quiet[CompatibleMaterialsQ[First[#],Last[#],Cache->cacheBall]]]&,sampleInstrumentCombinations];

	(*arrange into matrix where each column is the sample and the rows are the instruments*)
	incompatibleBoolMatrix=Partition[incompatibleBool,Length[samplePackets]];

	(*check to see if any of the samples are compatible with no instrument*)
	incompatibleInputsBool=Map[And@@#&,Transpose[incompatibleBoolMatrix]];

	(*get the samples that are incompatible with any instrument*)
	incompatibleInputsAnyInstrument=PickList[Lookup[samplePackets,Object],incompatibleInputsBool];

	(* If there are incompatible samples and we are throwing messages, throw an error message *)
	If[Length[incompatibleInputsAnyInstrument]>0&&!gatherTests,
		Message[Error::IncompatibleSample,ObjectToString[incompatibleInputsAnyInstrument,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleInputsAnyInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleInputsAnyInstrument]==0,
				(* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
				Nothing,
			 (* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[incompatibleInputsAnyInstrument,Cache->cacheBall]<>" is/are chemically compatible with an available pH Meter:",True,False]
			];
			passingTest=If[Length[incompatibleInputsAnyInstrument]==Length[simulatedSamples],
				(* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,incompatibleInputsAnyInstrument],Cache->cacheBall]<>" is/are chemically compatible with an available pH Meter:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*Incompatible Blanks*)

	(*create list of blank model packets that's index arrayed to the input sample list*)
	indexedBlankPackets=Map[If[MatchQ[#,ObjectP[Model[Sample]]],
		(*If a model, get from the Model cache*)
		fetchPacketFromCache[#,blankModelPackets],
		(*else if its an object*)
		If[MatchQ[#,ObjectP[Object[Sample]]],
			(*fetch from the Object cache*)
			fetchPacketFromCache[#,blankObjectPackets],
			(*otherwise, we don't care*)
			#
		]]&,blankSampleLookup];

	(*generate the material compatibility combination of instruments and Blanks*)
	blankInstrumentCombinations=Tuples[{infraredInstrumentModelPackets,indexedBlankPackets}];

	(*get boolean for which blank/instrument combinations are incompatible (based on material). *)
	incompatibleBlankBool=Map[If[MatchQ[Last[#],ObjectP[]],
		(*if we have an object packet for the blank, then we check compatibility *)
		Not[Quiet[CompatibleMaterialsQ[First[#],Last[#],Cache->cacheBall]]],
		(*otherwise, this is False automatically *)
		False
	]&,	blankInstrumentCombinations];

	(*arrange into matrix where each column is the blank and the rows are the instruments*)
	incompatibleBlankBoolMatrix=Partition[incompatibleBlankBool,Length[indexedBlankPackets]];

	(*check to see if any of the blank are compatible with no instrument*)
	incompatibleBlanksInputsBool=Map[And@@#&,Transpose[incompatibleBlankBoolMatrix]];

	(*get the samples that are incompatible with any instrument*)
	incompatibleBlanksInputsAnyInstrument=PickList[Lookup[samplePackets,Object],incompatibleBlanksInputsBool];

	(*get the offending Blanks*)
	incompatibleBlanksAnyInstrument=PickList[blanksLookup,incompatibleBlanksInputsBool];

	(* If there are incompatible samples and we are throwing messages, throw an error message *)
	incompatibleBlanksOptionsAnyInstrument=If[Length[incompatibleBlanksInputsAnyInstrument]>0&&!gatherTests,
		Message[Error::IncompatibleBlanks,ObjectToString[incompatibleBlanksInputsAnyInstrument,Cache->cacheBall],ObjectToString[incompatibleBlanksAnyInstrument,Cache->Flatten[allDownloadValues]]];
		{Blanks},
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleInputBlanksAnyInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleBlanksInputsAnyInstrument]==0,
			(* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[incompatibleBlanksInputsAnyInstrument,Cache->cacheBall]<>", if have a Blank specified, then Blank is chemically compatible with the instruments:",True,False]
			];
			passingTest=If[Length[incompatibleBlanksInputsAnyInstrument]==Length[simulatedSamples],
			(* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,incompatibleBlanksInputsAnyInstrument],Cache->cacheBall]<>", if have a Blank specified, then Blank is chemically compatible with the instruments:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*4b. Incompatible SuspensionSolution*)

	(*create list of suspensionSolution model packets that's index arrayed to the input sample list*)
	indexedSuspensionSolutionModelPackets=Map[If[MatchQ[#,ObjectP[Object[Sample]]],
		(*If an object, get from the Object cache*)
		fetchPacketFromCache[#,suspensionSolutionObjectPackets],
		(*else is it already a model?*)
		If[MatchQ[#,ObjectP[Model[Sample]]],
			(*if so directly fetch from the model cache*)
			fetchPacketFromCache[#,suspensionSolutionModelPackets],
			(*otherwise, we don't care*)
			#
		]]&,suspensionSolutionLookup];

	(*generate the material compatibility combination of instruments and SuspensionSolution*)
	suspensionSolutionInstrumentCombinations=Tuples[{infraredInstrumentModelPackets,indexedSuspensionSolutionModelPackets}];

	(*get boolean for which blank/instrument combinations are incompatible (based on material). *)
	incompatibleSuspensionSolutionBool=Map[If[MatchQ[Last[#],ObjectP[]],
	(*if we have an object packet for the blank, then we check compatibility *)
		Not[Quiet[CompatibleMaterialsQ[First[#],Last[#],Cache->cacheBall]]],
	(*otherwise, this is False automatically *)
		False
	]&,	suspensionSolutionInstrumentCombinations];

	(*arrange into matrix where each column is the blank and the rows are the instruments*)
	incompatibleSuspensionSolutionBoolMatrix=Partition[incompatibleSuspensionSolutionBool,Length[indexedSuspensionSolutionModelPackets]];

	(*check to see if any of the blank are compatible with no instrument*)
	incompatibleSuspensionSolutionInputsBool=Map[And@@#&,Transpose[incompatibleSuspensionSolutionBoolMatrix]];

	(*get the samples that are incompatible with any instrument*)
	incompatibleSuspensionSolutionInputsAnyInstrument=PickList[Lookup[samplePackets,Object],incompatibleSuspensionSolutionInputsBool];

	(*get the offending suspension solutions*)
	incompatibleSuspensionSolutionsAnyInstrument=PickList[suspensionSolutionLookup,incompatibleSuspensionSolutionInputsBool];

	(* If there are incompatible samples and we are throwing messages, throw an error message *)
	incompatibleSuspensionSolutionOptionsAnyInstrument=If[Length[incompatibleSuspensionSolutionInputsAnyInstrument]>0&&!gatherTests,
		Message[Error::IncompatibleSuspensionSolution,ObjectToString[incompatibleSuspensionSolutionInputsAnyInstrument,Cache->cacheBall],ObjectToString[incompatibleSuspensionSolutionsAnyInstrument,Cache->cacheBall]];
		{SuspensionSolution},
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleSuspensionSolutionAnyInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleSuspensionSolutionInputsAnyInstrument]==0,
			(* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all discarded samples *)
				Test["The input sample(s) "<>ObjectToString[incompatibleSuspensionSolutionInputsAnyInstrument,Cache->cacheBall]<>", if have a SuspensionSolution specified, then SuspensionSolution is chemically compatible with the instruments:",True,False]
			];
			passingTest=If[Length[incompatibleSuspensionSolutionInputsAnyInstrument]==Length[simulatedSamples],
			(* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-discarded samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,incompatibleSuspensionSolutionInputsAnyInstrument],Cache->cacheBall]<>", if have a SuspensionSolution specified, then SuspensionSolution is chemically compatible with the instruments:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];


	(*Improper instrument specification - make sure the user specified a spectrophotometer capable of IR measurement*)

	(*get anything that user specified*)
	instrumentLookup=Lookup[irSpectroscopyOptionsAssociation,Instrument];

	(*if the user specified an object, we take the model. *)
	instrumentLookupModel=If[MatchQ[instrumentLookup,ObjectP[Object[Instrument]]],
		Lookup[fetchPacketFromCache[instrumentLookup,Flatten@instrumentObjectPackets],Model]/.{link_Link:>Download[link, Object]},
		instrumentLookup];

	(*now get the model packet for the model*)
	instrumentLookupModelPacket=If[MatchQ[instrumentLookupModel,ObjectP[Model[Instrument]]],
		fetchPacketFromCache[instrumentLookupModel,Flatten@instrumentModelPackets],
		instrumentLookupModel];

	(*check that Infrared is not within the model packet*)
	instrumentIncapableBool=Not@MemberQ[Lookup[instrumentLookupModelPacket,ElectromagneticRange],Infrared];

	(* If there are invalid options and we are throwing messages, throw an error message *)
	instrumentIncapableOptions=If[instrumentIncapableBool&&!gatherTests,
		Message[Error::UnsuitableInstrument,ObjectToString[instrumentLookup,Cache->cacheBall]];
		{Instrument},
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)

	instrumentIncapableTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Not[instrumentIncapableBool],
				(* when the Instrument is capable, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test  *)
				Test["If specified, the Instrument can measure Infrared:",True,False]
			];
			passingTest=If[instrumentIncapableBool,
				(* when the MaxWavenumber is less than MinWavenumber, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test  *)
				Test["If specified, the Instrument can measure Infrared:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*Too many measurements are requested. For now, 20 samples is the threshold. Will adjust this as we get a plate capable instrument.*)

	(*declare a threshold*)
	measurementLimit=20;

	(*get the number of replicates and convert a Null to 1*)
	numberOfReplicatesNumber=Lookup[myOptions,NumberOfReplicates]/.Null:>1;

	(*calculate the total number of measurements needed*)
	numberOfMeasurements=Length[mySamples]*numberOfReplicatesNumber;
	tooManyMeasurementQ=numberOfMeasurements>measurementLimit;

	(*get all of the excess inputs*)
	tooManyMeasurementsInputs=If[tooManyMeasurementQ,Drop[Lookup[samplePackets,Object],measurementLimit],{}];

	If[tooManyMeasurementQ&&!gatherTests,
		Message[Error::IRSpectroscopyTooManySamples,ToString[numberOfMeasurements-measurementLimit]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyMeasurementsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Not[tooManyMeasurementQ],
			(* when the Instrument is capable, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test  *)
				Test["The number of measurements requested is less than 20:",True,False]
			];
			passingTest=If[tooManyMeasurementQ,
			(* when the MaxWavenumber is less than MinWavenumber, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test  *)
				Test["The number of measurements requested is less than 20:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*7. Blank index errors.  *)
	(*7a. find combinations where one is Null and the other is specified*)

	(*Look up the index portion of the Blanks*)
	blanksIndexLookup=Map[If[MatchQ[#,{_,_}],First[#],Automatic]&,blanksLookup];

	(*check to see where the sample is specified and the index is Null*)
	blankNullSpecifiedBool=MapThread[MatchQ[{#1,#2},{Null,ObjectP[]}]&,{blanksIndexLookup,blankSampleLookup}];

	(*get the offending inputs*)
	nullSpecifiedBlanks=PickList[blanksLookup,blankNullSpecifiedBool];

	(*throw errors if we are*)
	nullSpecifiedBlankOptions=If[Length[nullSpecifiedBlanks]>0&&!gatherTests,
		Message[Error::BlankIndexSpecifiedNull,ObjectToString[nullSpecifiedBlanks,Cache->cacheBall]];
		{Blanks},
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nullSpecifiedBlankTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nullSpecifiedBlanks]==0,
				(* when good, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test  *)
				Test["If Blank indices are specified, the index or sample is not Null while the other is specified:",True,False]
			];
			passingTest=If[Length[nullSpecifiedBlanks]==Length[simulatedSamples],
				(* when all bad, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test  *)
				Test["If Blank indices are specified, the index or sample is not Null while the other is specified:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*7b. first whether the same index was used for different objects/models*)

	(*make the list of tuples again*)
	blanksTupled=MapThread[List,{blanksIndexLookup,blankSampleLookup}];

	(*gather by the same blank index if integer into an association*)
	groupedBlankIndexAssociation=GroupBy[Select[blanksTupled,IntegerQ[First[#]]&],First];

	(*then collapse into object/models/null for each Blank index*)
	blankIndexCollapsedAssociation=DeleteDuplicates/@(groupedBlankIndexAssociation/.{_Integer,x_}->x/.Automatic->Nothing);

	(*a list of boolean where the indices have multiple objects/models*)
	indicesWithMultipleObjectsBool=blanksIndexLookup/.Map[Length[#]>1&,blankIndexCollapsedAssociation]/.Automatic|Null->False;

	(*get the offending inputs*)
	multipleIndicesBlanks=PickList[blanksLookup,indicesWithMultipleObjectsBool];

	(*throw errors if we are*)
	multipleIndicesOptions=If[Length[multipleIndicesBlanks]>0&&!gatherTests,
		Message[Error::SameBlankIndexDifferentObjects,ObjectToString[multipleIndicesBlanks,Cache->cacheBall]];
		{Blanks},
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	multipleIndicesTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[multipleIndicesBlanks]==0,
				(* when good, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test  *)
				Test["If Blank indices are specified, multiple objects/models do not correspond to the same index:",True,False]
			];
			passingTest=If[Length[multipleIndicesBlanks]==Length[simulatedSamples],
				(* when all bad, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test  *)
				Test["If Blank indices are specified, multiple objects/models do not correspond to the same index:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*7c whether the same object corresponds to multiple indices *)

	(*gather by the same blank object into an association*)
	groupedBlankSampleAssociation=GroupBy[Select[blanksTupled,IntegerQ[First[#]]&&MatchQ[Last[#],ObjectP[Object[Sample]]]&],Last];

	(*then collapse*)
	collapsedBlankSampleAssociation=DeleteDuplicates/@(groupedBlankSampleAssociation/.{x_Integer,_}->x);

	(*find where our blank options are off*)
	multipleObjectBlankBool=blankSampleLookup/.Map[Length[#]>1&,collapsedBlankSampleAssociation]/.Automatic|Null->False/.x:ObjectP[Model[Sample]]->False;

	(*get the offending inputs*)
	multipleObjectsBlanks=PickList[blanksLookup,multipleObjectBlankBool];

	(*throw errors if we are*)
	multipleObjectsOptions=If[Length[multipleObjectsBlanks]>0&&!gatherTests,
		Message[Error::IndexDifferentSameObject,ObjectToString[multipleObjectsBlanks,Cache->cacheBall]];
		{Blanks},
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	multipleObjectsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[multipleObjectsBlanks]==0,
				(* when good, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test  *)
				Test["If Blank indices are specified, multiple indices do not correspond to the same objects:",True,False]
			];
			passingTest=If[Length[multipleObjectsBlanks]==Length[simulatedSamples],
				(* when all bad, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test  *)
				Test["If Blank indices are specified, multiple indices do not correspond to the same objects:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)

	(*we first round assuming that SampleAmount and BlankAmounts are volumes*)
	{optionsWithRoundedVolumes,precisionTestsVolumes}=If[gatherTests,
		RoundOptionPrecision[irSpectroscopyOptionsAssociation,{SampleAmount,SuspensionSolutionVolume,BlankAmounts,MinWavenumber,MaxWavenumber,MaxWavelength,MinWavelength,WavenumberResolution,IntegrationTime},{1 Microliter,1 Microliter,1 Microliter,1 (Centimeter)^(-1),1 (Centimeter)^(-1),1 Nanometer,1 Nanometer,1 (Centimeter)^(-1),1 Second},Output->{Result,Tests}],
		{RoundOptionPrecision[irSpectroscopyOptionsAssociation,{SampleAmount,SuspensionSolutionVolume,BlankAmounts,MinWavenumber,MaxWavenumber,MaxWavelength,MinWavelength,WavenumberResolution,IntegrationTime},{1 Microliter,1 Microliter,1 Microliter,1 (Centimeter)^(-1),1 (Centimeter)^(-1),1 Nanometer,1 Nanometer,1 (Centimeter)^(-1),1 Second}],Null}
	];

	(*Then we do SampleAmount and BlankAmounts assuming that they are masses*)
	{optionsWithRoundedVolumesMasses,precisionTestsVolumesMasses}=If[gatherTests,
		RoundOptionPrecision[optionsWithRoundedVolumes,{SampleAmount,BlankAmounts},{1 Milligram,1 Milligram},Output->{Result,Tests}],
		{RoundOptionPrecision[optionsWithRoundedVolumes,{SampleAmount,BlankAmounts},{1 Milligram,1 Milligram}],Null}
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(*We need to get the blank state information*)
	blankStatesLookup=Map[If[MatchQ[#,ObjectP[Object[Sample]]],
		(*If an object, fetch from the Object cache*)
		Lookup[fetchPacketFromCache[#,blankObjectPackets],State],
		(*else is it a model?*)
		If[MatchQ[#,ObjectP[Model[Sample]]],
			(*fetch from the model cache*)
			Lookup[fetchPacketFromCache[#,blankModelPackets],State],
			(*otherwise, we don't care what it is*)
			#
		]]&,blankSampleLookup];

	(*We need to get the blank density information*)
	blankDensityLookup=Map[If[MatchQ[#,ObjectP[Object[Sample]]],
		(*If an object, get from the Object cache*)
		Lookup[fetchPacketFromCache[#,blankObjectPackets],Density],
		(*else is it a model?*)
		If[MatchQ[#,ObjectP[Model[Sample]]],
		(*if so, fetch from the model cache*)
			Lookup[fetchPacketFromCache[#,blankModelPackets],Density],
		(*otherwise, we don't care what it is*)
			#
		]]&,blankSampleLookup];

	(*SampleModule *)
	{sampleModuleLookup,sampleAmountLookup,samplePressureLookup,suspensionSolutionVolumeLookup,blankAmountsLookup,blankPressureLookup,integrationTimeLookup,numberOfReadingsLookup,minWavenumberLookup,maxWavelengthLookup,maxWavenumberLookup,minWavelengthLookup}=Lookup[optionsWithRoundedVolumesMasses,
		{SampleModule,SampleAmount,PressSample,SuspensionSolutionVolume,BlankAmounts,PressBlank,IntegrationTime,NumberOfReadings,MinWavenumber,MaxWavelength,MaxWavenumber,MinWavelength}];

	(*For now, we'll just have one type of sample module until the second one is online*)
	resolvedSampleModule=If[MatchQ[sampleModuleLookup,Automatic],Reflection,sampleModuleLookup];

	resolverResults=Transpose[MapThread[
		Function[{samplePacket,sampleSolventModelPacket,blanksOpt,blankAmountsOpt,blankStateFound,blankDensityFound,blankPressureOpt,sampleAmountOpt,samplePressureOpt,suspensionSolutionOpt,suspensionSolutionVolumeOpt,integrationTimeOpt,numberOfReadingsOpt,minWavenumberOpt,maxWavelengthOpt,maxWavenumberOpt,minWavelengthOpt},Module[
			{sampleState,sampleDensity,resolvedBlank,resolvedBlankAmount,solventLookup,resolvedSampleAmount,resolvedSampleModule,resolvedSuspensionSolutionVolume,
				resolvedIntegrationTime,suspensionSolutionModel,suggestedBlanks,suggestedBlankAmounts,resolvedSamplePressure,resolvedSuspensionSolution,
				(*Error checking variables*)
				sampleAmountAsVolumeWithoutDensity,suspensionSolutionSpecifiedVolumeNull,suspensionSolutionVolumeSpecifiedSuspensionNull,blankAndBlankAmountsSpecifiedAndNull,
				blankAmountAsVolumeWithoutDensity,integrationTimeNumberOfReadingsBothNull,integrationTimeNumberOfReadingsBothSpecified,minWavenumberMaxWavelengthBothNull,
				minWavenumberMaxWavelengthBothSpecified,maxWavenumberMinWavelengthBothNull,maxWavenumberMinWavelengthBothSpecified,minWavenumberGreaterThanMax,
				samplePressureWithLiquid,noSamplePressureSolid,blankAmountFromSample,pressBlankWithNoBlanks,suspensionSolutionResolved,
				resolvedMinWavenumber,tempMinWavenumber,resolvedMaxWavenumber,tempMaxWavenumber,errorList,resolutionList
			},

			(*get the sample state,density*)
			{sampleState,sampleDensity}=Lookup[samplePacket,{State,Density}];

			(*check to see if the sample amount is a volume while the sample state is a solid and no density info is given*)
			sampleAmountAsVolumeWithoutDensity=And[MatchQ[sampleState,Solid],NullQ[sampleDensity],MatchQ[sampleAmountOpt,GreaterP[0 Milliliter]]];

			(*Is the sample amount set?*)
			resolvedSampleAmount=Which[
				(*If so, then use that and check*)
				QuantityQ[sampleAmountOpt],sampleAmountOpt,
				(*otherwise do we have a volume defined*)
				QuantityQ[Lookup[samplePacket,Volume]],globalMinVolume,
				True,globalMinMass
			];

			(* Resolve the suspension solution, if left as automatic *)
			{resolvedSuspensionSolution, suspensionSolutionResolved} = Switch[{suspensionSolutionOpt,sampleState,suspensionSolutionVolumeOpt},
				(* If a suspension solution volume was supplied, resolve the suspension to mineral oil, regardless of sample state. And raise warning *)
				{Automatic,_,GreaterP[0 Milliliter]},{Model[Sample,"id:kEJ9mqR8MnBe"],True},
				(* Otherwise resolve to Null *)
				{Automatic,_,_},{Null,False},
				(* If suspension solution is specified, take it *)
				{_,_,_},{suspensionSolutionOpt,False}
			];

			(*resolve the suspension solution volume amount and check for errors*)
			{resolvedSuspensionSolutionVolume,suspensionSolutionSpecifiedVolumeNull,suspensionSolutionVolumeSpecifiedSuspensionNull}=Switch[{resolvedSuspensionSolution,suspensionSolutionVolumeOpt},

				(*if both are specified, go with the specification*)
				{ObjectP[{Object[Sample],Model[Sample]}],GreaterP[0 Milliliter]},{suspensionSolutionVolumeOpt,False,False},
				(*if the user specifies the solution but not volume, then use the Minimum*)
				{ObjectP[{Object[Sample],Model[Sample]}],Automatic},{globalMinVolume,False,False},
				(*if the user gives a solution but Null for the volume, that's an error*)
				{ObjectP[{Object[Sample],Model[Sample]}],Null},{Null,True,False},
				(*if the user gives a solution volume but Null for the solution, that's another error*)
				{Null,GreaterP[0 Milliliter]},{suspensionSolutionVolumeOpt,False,True},
				(*for the default conditions, it becomes null*)
				{Null,Automatic},{Null,False,False},
				{Null,Null},{Null,False,False}
			];

			(*resolve the sample pressure application*)
			{resolvedSamplePressure,samplePressureWithLiquid,noSamplePressureSolid}=Switch[{samplePressureOpt,sampleState,resolvedSuspensionSolutionVolume},

				(*if the user specified something go with it, but do some error checking*)
				(*If True, check if dry sample with suspension solution, or liquid state*)
				{True,Solid,Except[Null]},{True,True,False},
				(*Now check if in liquid-ish state*)
				{True,Except[Solid|Null],_},{True,True,False},
				(*other true cases are good!*)
				{True,_,_},{True,False,False},
				(*find the adverse false cases*)
				(*Adverse case is a solid without suspension solution *)
				{False,Solid,Null},{False,False,True},
				(*everything else is ok*)
				{False,_,_},{False,False,False},
				(*now for the actual resolution*)
				{_,Solid,Null},{True,False,False},
				{_,_,_},{False,False,False}
			];

			(*based on systems' review. it's best to not use any blanks*)
			{suggestedBlanks,suggestedBlankAmounts}={Null,Null};

			(*there is a small chance that blank and sample state are different*)
			blankAmountFromSample=If[MatchQ[blankStateFound,sampleState],resolvedSampleAmount,
				(*If different then some slight logic*)
				Switch[{blankStateFound,sampleState},
					{Solid,Liquid},resolvedSampleAmount*1 Milligram/(1 Microliter),
					{Liquid,Solid},resolvedSampleAmount*1 Microliter/(1 Milligram),
					{_,_},resolvedSampleAmount
				]
			];

			(*check whether specified blank amount is specified as a volume and blank is a solid without density information*)
			blankAmountAsVolumeWithoutDensity=And[MatchQ[blankStateFound,Solid],MatchQ[blankAmountsOpt,GreaterP[0 Milliliter]],!MatchQ[blankDensityFound,GreaterP[0 Gram/Liter]]];

			(*Resolving the blanks and errors*)
			{resolvedBlank,resolvedBlankAmount,blankAndBlankAmountsSpecifiedAndNull}=Switch[{blanksOpt,blankAmountsOpt},
				(*For automatic, go with suggestion*)
				{Automatic,Automatic},{suggestedBlanks,suggestedBlankAmounts,False},
				(*For both specified, stick with it*)
				{ObjectP[{Object[Sample],Model[Sample]}],(GreaterP[0 Milliliter]|GreaterP[0 Milligram])},{blanksOpt,blankAmountsOpt,False},
				(*If one is specified and the other is null, stick with it but throw the error*)
				{ObjectP[{Object[Sample],Model[Sample]}],Null},{blanksOpt,blankAmountsOpt,True},
				{Null,(GreaterP[0 Milliliter]|GreaterP[0 Milligram])},{blanksOpt,blankAmountsOpt,True},
				(*Blanks is specified, but the amount is automatic. Stick with the Blanks and for the amount use the sample amount*)
				{ObjectP[{Object[Sample],Model[Sample]}],Automatic},{blanksOpt,blankAmountFromSample,False},
				(*if the volume is specified, use the suggested blank, but if the suggested blank is Null, use water instead*)
				{Automatic,(GreaterP[0 Milliliter]|GreaterP[0 Milligram])},{If[NullQ[suggestedBlanks],Model[Sample,"Milli-Q water"],suggestedBlanks],blankAmountsOpt,False},
				(*Or or the other is Null*)
				{Automatic,Null},{Null,Null,False},
				{Null,Automatic},{Null,Null,False}
			];


			(*resolving the integration time/number of reads and catch errors*)
			{resolvedIntegrationTime,integrationTimeNumberOfReadingsBothNull,integrationTimeNumberOfReadingsBothSpecified}=Switch[{integrationTimeOpt,numberOfReadingsOpt},
				(*nothing changed, stick with default options*)
				{Automatic,Null},{1 Minute,False,False},
				(*user shouldn't be setting both Null*)
				{Null,Null},{Null,True,False},
				(*user shouldn't be setting both either*)
				{GreaterP[0 Minute],_Integer},{integrationTimeOpt,False,True},
				(*if NumberofReads is set and other is Automatic/Null*)
				{(Automatic|Null),_Integer},{Null,False,False},
				(*if Integration Time is specified*)
				{GreaterP[0 Minute],Null},{integrationTimeOpt,False,False}
			];

			(*resolving the MinWavenumber/MaxWavelength*)
			{resolvedMinWavenumber,tempMinWavenumber,minWavenumberMaxWavelengthBothNull,minWavenumberMaxWavelengthBothSpecified}=Switch[{minWavenumberOpt,maxWavelengthOpt},
				(*default and unchanged*)
				{Automatic,Null},{400*1/Centimeter,400*1/Centimeter,False,False},
				(*user sets both to null. the temp value needs to be small enough to not trigger another error*)
				{Null,Null},{minWavenumberOpt,0*1/Centimeter,True,False},
				(*user sets values to both*)
				{GreaterP[0*1/Centimeter],GreaterP[0 Nanometer]},{minWavenumberOpt,minWavenumberOpt,False,True},
				(*wavenumber is automatic/null and wavelength is set*)
				{(Automatic|Null),GreaterP[0 Nanometer]},{Null,UnitConvert[1/maxWavelengthOpt,1/Centimeter],False,False},
				(*the user only sets the wavenumber*)
				{GreaterP[0*1/Centimeter],Null},{minWavenumberOpt,minWavenumberOpt,False,False}
			];

			(*resolving the MinWavenumber/MaxWavelength*)
			{resolvedMaxWavenumber,tempMaxWavenumber,maxWavenumberMinWavelengthBothNull,maxWavenumberMinWavelengthBothSpecified}=Switch[{maxWavenumberOpt,minWavelengthOpt},
				(*default and unchanged*)
				{Automatic,Null},{4000*1/Centimeter,4000*1/Centimeter,False,False},
				(*user sets both to null, the temp value just needs to big enough to not trigger an error*)
				{Null,Null},{maxWavenumberOpt,20000*1/Centimeter,True,False},
				(*user sets values to both*)
				{GreaterP[0*1/Centimeter],GreaterP[0 Nanometer]},{maxWavenumberOpt,maxWavenumberOpt,False,True},
				(*wavenumber is automatic/null and wavelength is set*)
				{(Automatic|Null),GreaterP[0 Nanometer]},{Null,UnitConvert[1/minWavelengthOpt,1/Centimeter],False,False},
				(*the user only sets the wavenumber*)
				{GreaterP[0*1/Centimeter],Null},{maxWavenumberOpt,maxWavenumberOpt,False,False}
			];

			(*check if the minWavenumber is greater than the max*)
			minWavenumberGreaterThanMax=MatchQ[tempMinWavenumber,GreaterP[tempMaxWavenumber]];

			(*compile the resolved variables*)
			resolutionList={
				resolvedBlank,
				resolvedBlankAmount,
				resolvedSampleAmount,
				resolvedSuspensionSolution,
				resolvedSuspensionSolutionVolume,
				resolvedIntegrationTime,
				resolvedMinWavenumber,
				resolvedMaxWavenumber,
				resolvedSamplePressure
			};

			(*compile the error list*)
			errorList={
				sampleAmountAsVolumeWithoutDensity,
				suspensionSolutionResolved,
				suspensionSolutionSpecifiedVolumeNull,
				suspensionSolutionVolumeSpecifiedSuspensionNull,
				integrationTimeNumberOfReadingsBothNull,
				integrationTimeNumberOfReadingsBothSpecified,
				minWavenumberMaxWavelengthBothNull,
				minWavenumberMaxWavelengthBothSpecified,
				maxWavenumberMinWavelengthBothNull,
				maxWavenumberMinWavelengthBothSpecified,
				minWavenumberGreaterThanMax,
				blankAndBlankAmountsSpecifiedAndNull,
				blankAmountAsVolumeWithoutDensity,
				samplePressureWithLiquid,
				noSamplePressureSolid
			};

			Join[resolutionList,errorList]
		]]
	,{samplePackets,sampleSolventModelPackets,blankSampleLookup,blankAmountsLookup,blankStatesLookup,blankDensityLookup,blankPressureLookup,sampleAmountLookup,samplePressureLookup,suspensionSolutionLookup,suspensionSolutionVolumeLookup,integrationTimeLookup,numberOfReadingsLookup,minWavenumberLookup,maxWavelengthLookup,maxWavenumberLookup,minWavelengthLookup}]];

	(*split our resolver results*)
	{
		semiResolvedBlanks,
		semiResolvedBlankAmounts,
		resolvedSampleAmounts,
		resolvedSuspensionSolutions,
		resolvedSuspensionSolutionVolumes,
		resolvedIntegrationTimes,
		resolvedMinWavenumbers,
		resolvedMaxWavenumbers,
		resolvedSamplePressures,
		sampleAmountAsVolumeWithoutDensityList,
		suspensionSolutionResolvedList,
		suspensionSolutionSpecifiedVolumeNullList,
		suspensionSolutionVolumeSpecifiedSuspensionNullList,
		integrationTimeNumberOfReadingsBothNullList,
		integrationTimeNumberOfReadingsBothSpecifiedList,
		minWavenumberMaxWavelengthBothNullList,
		minWavenumberMaxWavelengthBothSpecifiedList,
		maxWavenumberMinWavelengthBothNullList,
		maxWavenumberMinWavelengthBothSpecifiedList,
		minWavenumberGreaterThanMaxList,
		blankAndBlankAmountsSpecifiedAndNullList,
		blankAmountAsVolumeWithoutDensityList,
		samplePressureWithLiquidList,
		noSamplePressureSolidList
	}=resolverResults;

	(*we also need to resolve our tupled blank stuff. there may be scenarios where the same number is specified, but the resolved blank is different. that's what we must fix.*)

	(*first create a new tuple*)
	semiResolvedTuple=MapThread[List,{blanksIndexLookup,semiResolvedBlanks}];

	(*create a resolved rule set for each number index. We take the first number for each*)
	groupedSemiTuple=GroupBy[Select[semiResolvedTuple,IntegerQ[First[#]]&],First];
	resolverDictionary=First/@groupedSemiTuple/.{_Integer,x_}->x;

	(*we also need the dictionary that the user defined*)
	temporaryDictionary=Map[If[Length[#]>0,First[#],Automatic]&,blankIndexCollapsedAssociation];

	(*there is a chance that we still have some automatics (e.g. the user has 1,Automatic). So we accede to the blank resolutions for such cases*)
	automaticsDictionary=Select[temporaryDictionary,MatchQ[#,Automatic]&];

	(*Now replace all the automatics in the dictionary with the first resolution*)
	replacedAutomaticsDictionary=Association@@Map[
		#->First@semiResolvedBlanks[[FirstPosition[blanksIndexLookup,#]]]
				&,Keys[automaticsDictionary]];

	(*now make the user rule dictionary*)
	userRuleDictionary=Merge[{temporaryDictionary,replacedAutomaticsDictionary},Last];

	(*make a new blank tuple with the amounts*)
	blankTupledAmounts=MapThread[Append[#1,#2]&,{blanksTupled,blankAmountsLookup}];

	(*now we make our final resolved Blanks and BlankAmounts. If the user provides a integer, but automatic blank, we look up the value in our dictionary. otherwise, we stick to the resolution*)
	{resolvedBlanks,resolvedBlankAmounts}=Transpose@MapThread[
		Switch[#1,
			(*whenever we have these patterns, the resolution is Nulls*)
			{Null,Automatic,Automatic},{Null,Null},
		 (*here is more tricky, *)
			{_Integer,Automatic,_},
				(*we should first check if the user already defined it in another option*)
				resolveFromUser=First[#1]/.userRuleDictionary;
				(*if it's not an integer, we're good, otherwise use the resolver dictionary to figure out what it should be*)
				resolvedBlank=If[!IntegerQ[resolveFromUser],resolveFromUser,First[#1]/.resolverDictionary];
				(*now for the amount. if user defined, use that*)
				resolvedBlankAmount=If[MatchQ[Last[#1],Except[Automatic]],Last[#1],
					(*if not user defined. some logic *)
					Switch[{resolvedBlank,#3},
						{Null,Null},Null,
						(*in case we have a conflict, heed to the blank*)
						{_,Null},globalMinMass (*TODO: may be better to do a dictionary of the amounts*),
						(*in all other cases, we just take the semi resolved*)
						{_,_},#3
					]
				];
				(*return the amount*)
				{resolvedBlank,resolvedBlankAmount}
			,
			(*anything else, can just use from the resolver*)
			{_,_,_},{#2,#3}
		]&,{blankTupledAmounts,semiResolvedBlanks,semiResolvedBlankAmounts}];

	(* Throw an error if Null blanks were resolved, but PressBlank was specified *)
	pressBlankWithNoBlanksList = MapThread[And[!MatchQ[resolvedBlank, ObjectP[]], BooleanQ[resolvedBlankPressure]],{resolvedBlanks,blankPressureLookup}];

	(*oh, but we're not done. still need to resolve our blank indices*)

	(*we need the user object dictionary*)
	userObjectDictionary=First/@collapsedBlankSampleAssociation;

	(*let's go ahead and set {Automatic,Null} to Null for the indices and check for instances of repeating objects. Objects can only be user defined, so we'll use the earlier dictionary*)
	semiResolvedBlankIndices=MapThread[
		Switch[{#1,#2},
			(*check if (Automatic,Null)*)
			{Automatic,Null},Null,
			(*check if Object type, then replace according to user dictionary (might not change)*)
			{Automatic,ObjectP[Object[Sample]]},#1/.userObjectDictionary,
			(*All other instances, stick with what we have so far*)
			{_,_},#1

		]&,{blanksIndexLookup,resolvedBlanks}];

	(*count the number of automatics in our blanks index lookup*)
	countAutomatics=Count[semiResolvedBlankIndices,Automatic];

	(*get all the cases of integers*)
	integerCases=Cases[semiResolvedBlankIndices,_Integer];

	(*get the maximum integer*)
	maximumIndex=If[Length[integerCases]>0,Max[integerCases],0];

	(*make the new indices*)
	newIndices=Range[maximumIndex+1,maximumIndex+countAutomatics];


	(*now place into the automatic positions*)
	resolvedBlankIndices=semiResolvedBlankIndices;
	resolvedBlankIndices[[Sequence@@@Position[resolvedBlankIndices,Automatic]]]=newIndices;

	(*finally form our resolved blank tuple*)
	resolvedBlanksTuple=MapThread[List,{resolvedBlankIndices,resolvedBlanks}];

	(*we now need to resolve the blank pressure. If user specified, it's easy*)
	{resolvedBlankPressure,blankPressureWithLiquidList,noBlankPressureSolidList}=Transpose@MapThread[(

		(*get the state*)
		blankState=Switch[#1,
			ObjectP[Object[Sample]],Lookup[fetchPacketFromCache[#1,blankObjectPackets],State],
			ObjectP[Model[Sample]],Lookup[fetchPacketFromCache[#1,blankModelPackets],State],
			Null,Null,
			_,Liquid
		];

		Switch[{#2,blankState,#1},
			(* If BlankPress was not specified, and blanks resolved to Null, we're good *)
			{Except[BooleanP],_,NullP},{Null,False,False},
			(*if the user specified True and it's a liquid, throw the warning*)
			{True,Except[Solid|Null],_},{True,True,False},
			(*check for the other error, solid without pressure application*)
			{False,Solid,_},{False,False,True},
			(*for all other non-automatic conditions, go with user's selection*)
			{Except[Automatic],_,_},{#2,False,False},
			(*If a solid, it's true*)
			{_,Solid,_},{True,False,False},
			(*Otherwise, false*)
			{_,_,_},{False,False,False}
		]

	)&,{resolvedBlanks,blankPressureLookup}];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(*2. When the SuspensionSolution is specified but SuspensionSolutionVolume is null*)

	suspensionSolutionSpecifiedVolumeNullPackets=PickList[samplePackets,suspensionSolutionSpecifiedVolumeNullList,True];

	{suspensionSolutionSpecifiedVolumeNullInputs,suspensionSolutionSpecifiedVolumeNullOptions}=If[Length[suspensionSolutionSpecifiedVolumeNullPackets]>0,
		{Lookup[Flatten[suspensionSolutionSpecifiedVolumeNullPackets],Object],{SuspensionSolution,SuspensionSolutionVolume}},
	(* if there are no discarded inputs, the list is empty *)
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[suspensionSolutionSpecifiedVolumeNullInputs]>0&&!gatherTests,
		Message[Error::SuspensionVolumeNull,ObjectToString[suspensionSolutionSpecifiedVolumeNullInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)

	suspensionSolutionSpecifiedVolumeNullTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[suspensionSolutionSpecifiedVolumeNullInputs]==0,
			(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[suspensionSolutionSpecifiedVolumeNullInputs,Cache->cacheBall]<>", if have SuspensionSolution specified do not have SuspensionSolutionVolume set to Null:",True,False]
			];
			passingTest=If[Length[suspensionSolutionSpecifiedVolumeNullInputs]==Length[simulatedSamples],
			(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,suspensionSolutionSpecifiedVolumeNullInputs],Cache->cacheBall]<>", if have SuspensionSolution specified do not have SuspensionSolutionVolume set to Null:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*3. When the SuspensionSolutionVolume is specified but SuspensionSolution is null*)

	suspensionSolutionVolumeSpecifiedSuspensionNullPackets=PickList[samplePackets,suspensionSolutionVolumeSpecifiedSuspensionNullList,True];

	{suspensionSolutionVolumeSpecifiedSuspensionNullInputs,suspensionSolutionVolumeSpecifiedSuspensionNullOptions}=If[Length[suspensionSolutionVolumeSpecifiedSuspensionNullPackets]>0,
		{Lookup[Flatten[suspensionSolutionVolumeSpecifiedSuspensionNullPackets],Object],{SuspensionSolution,SuspensionSolutionVolume}},
	(* if there are no discarded inputs, the list is empty *)
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[suspensionSolutionVolumeSpecifiedSuspensionNullInputs]>0&&!gatherTests,
		Message[Error::SuspensionSolutionNull,ObjectToString[suspensionSolutionVolumeSpecifiedSuspensionNullInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)

	suspensionSolutionVolumeSpecifiedSuspensionNullTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[suspensionSolutionVolumeSpecifiedSuspensionNullInputs]==0,
			(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[suspensionSolutionVolumeSpecifiedSuspensionNullInputs,Cache->cacheBall]<>", if have SuspensionSolutionVolume specified do not have SuspensionSolution set to Null:",True,False]
			];
			passingTest=If[Length[suspensionSolutionVolumeSpecifiedSuspensionNullInputs]==Length[simulatedSamples],
			(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,suspensionSolutionVolumeSpecifiedSuspensionNullInputs],Cache->cacheBall]<>", if have SuspensionSolutionVolume specified do not have SuspensionSolution set to Null:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*4. check when the IntegrationTime and NumberOfReadings are both Null*)

	integrationTimeNumberOfReadingsBothNullPackets=PickList[samplePackets,integrationTimeNumberOfReadingsBothNullList,True];

	{integrationTimeNumberOfReadingsBothNullInputs,integrationTimeNumberOfReadingsBothNullOptions}=If[Length[integrationTimeNumberOfReadingsBothNullPackets]>0,
		{Lookup[Flatten[integrationTimeNumberOfReadingsBothNullPackets],Object],{IntegrationTime,NumberOfReadings}},
	(* if there are no discarded inputs, the list is empty *)
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[integrationTimeNumberOfReadingsBothNullInputs]>0&&!gatherTests,
		Message[Error::IntegrationReadingsNull,ObjectToString[integrationTimeNumberOfReadingsBothNullInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)

	integrationTimeNumberOfReadingsBothNullTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[integrationTimeNumberOfReadingsBothNullInputs]==0,
			(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[integrationTimeNumberOfReadingsBothNullInputs,Cache->cacheBall]<>" do not have IntegrationTime and NumberOfReadings both set to Null:",True,False]
			];
			passingTest=If[Length[integrationTimeNumberOfReadingsBothNullInputs]==Length[simulatedSamples],
			(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,integrationTimeNumberOfReadingsBothNullInputs],Cache->cacheBall]<>" do not have IntegrationTime and NumberOfReadings both set to Null:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*5. check when the IntegrationTime and NumberOfReadings are both Specified*)

	integrationTimeNumberOfReadingsBothSpecifiedPackets=PickList[samplePackets,integrationTimeNumberOfReadingsBothSpecifiedList,True];

	{integrationTimeNumberOfReadingsBothSpecifiedInputs,integrationTimeNumberOfReadingsBothSpecifiedOptions}=If[Length[integrationTimeNumberOfReadingsBothSpecifiedPackets]>0,
		{Lookup[Flatten[integrationTimeNumberOfReadingsBothSpecifiedPackets],Object],{IntegrationTime,NumberOfReadings}},
	(* if there are no discarded inputs, the list is empty *)
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[integrationTimeNumberOfReadingsBothSpecifiedInputs]>0&&!gatherTests,
		Message[Error::IntegrationReadingsSpecified,ObjectToString[integrationTimeNumberOfReadingsBothSpecifiedInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)

	integrationTimeNumberOfReadingsBothSpecifiedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[integrationTimeNumberOfReadingsBothSpecifiedInputs]==0,
			(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[integrationTimeNumberOfReadingsBothSpecifiedInputs,Cache->cacheBall]<>" do not have IntegrationTime and NumberOfReadings both Specified:",True,False]
			];
			passingTest=If[Length[integrationTimeNumberOfReadingsBothSpecifiedInputs]==Length[simulatedSamples],
			(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,integrationTimeNumberOfReadingsBothSpecifiedInputs],Cache->cacheBall]<>" do not have IntegrationTime and NumberOfReadings both Specified:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*6. check if MinWavenumber and MaxWavelength are both Null*)
	minWavenumberMaxWavelengthBothNullPackets=PickList[samplePackets,minWavenumberMaxWavelengthBothNullList,True];

	{minWavenumberMaxWavelengthBothNullInputs,minWavenumberMaxWavelengthBothNullOptions}=If[Length[minWavenumberMaxWavelengthBothNullPackets]>0,
		{Lookup[Flatten[minWavenumberMaxWavelengthBothNullPackets],Object],{MinWavenumber,MaxWavelength}},
	(* if there are no discarded inputs, the list is empty *)
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[minWavenumberMaxWavelengthBothNullInputs]>0&&!gatherTests,
		Message[Error::MinWavenumberMaxWavelengthBothNull,ObjectToString[minWavenumberMaxWavelengthBothNullInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)

	minWavenumberMaxWavelengthBothNullTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[minWavenumberMaxWavelengthBothNullInputs]==0,
			(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[minWavenumberMaxWavelengthBothNullInputs,Cache->cacheBall]<>" do not have MinWavenumber and MaxWavelength both Null:",True,False]
			];
			passingTest=If[Length[minWavenumberMaxWavelengthBothNullInputs]==Length[simulatedSamples],
			(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,minWavenumberMaxWavelengthBothNullInputs],Cache->cacheBall]<>" do not have MinWavenumber and MaxWavelength both Null:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*7. check if MinWavenumber and MaxWavelength are both Specified*)
	minWavenumberMaxWavelengthBothSpecifiedPackets=PickList[samplePackets,minWavenumberMaxWavelengthBothSpecifiedList,True];

	{minWavenumberMaxWavelengthBothSpecifiedInputs,minWavenumberMaxWavelengthBothSpecifiedOptions}=If[Length[minWavenumberMaxWavelengthBothSpecifiedPackets]>0,
		{Lookup[Flatten[minWavenumberMaxWavelengthBothSpecifiedPackets],Object],{MinWavenumber,MaxWavelength}},
	(* if there are no discarded inputs, the list is empty *)
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[minWavenumberMaxWavelengthBothSpecifiedInputs]>0&&!gatherTests,
		Message[Error::MinWavenumberMaxWavelengthBothSpecified,ObjectToString[minWavenumberMaxWavelengthBothSpecifiedInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)

	minWavenumberMaxWavelengthBothSpecifiedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[minWavenumberMaxWavelengthBothSpecifiedInputs]==0,
			(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[minWavenumberMaxWavelengthBothSpecifiedInputs,Cache->cacheBall]<>" do not have MinWavenumber and MaxWavelength both Specified:",True,False]
			];
			passingTest=If[Length[minWavenumberMaxWavelengthBothSpecifiedInputs]==Length[simulatedSamples],
			(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,minWavenumberMaxWavelengthBothSpecifiedInputs],Cache->cacheBall]<>" do not have MinWavenumber and MaxWavelength both Specified:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*8. check if MaxWavenumber and MinWavelength are both Null*)
	maxWavenumberMinWavelengthBothNullPackets=PickList[samplePackets,maxWavenumberMinWavelengthBothNullList,True];

	{maxWavenumberMinWavelengthBothNullInputs,maxWavenumberMinWavelengthBothNullOptions}=If[Length[maxWavenumberMinWavelengthBothNullPackets]>0,
		{Lookup[Flatten[maxWavenumberMinWavelengthBothNullPackets],Object],{MaxWavenumber,MinWavelength}},
	(* if there are no discarded inputs, the list is empty *)
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[maxWavenumberMinWavelengthBothNullInputs]>0&&!gatherTests,
		Message[Error::MaxWavenumberMinWavelengthBothNull,ObjectToString[maxWavenumberMinWavelengthBothNullInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)

	maxWavenumberMinWavelengthBothNullTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[maxWavenumberMinWavelengthBothNullInputs]==0,
			(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[maxWavenumberMinWavelengthBothNullInputs,Cache->cacheBall]<>" do not have MaxWavenumber and MinWavelength both Null:",True,False]
			];
			passingTest=If[Length[maxWavenumberMinWavelengthBothNullInputs]==Length[simulatedSamples],
			(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,maxWavenumberMinWavelengthBothNullInputs],Cache->cacheBall]<>" do not have MaxWavenumber and MinWavelength both Null:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*9. check if MaxWavenumber and MinWavelength are both Specified*)
	maxWavenumberMinWavelengthBothSpecifiedPackets=PickList[samplePackets,maxWavenumberMinWavelengthBothSpecifiedList,True];

	{maxWavenumberMinWavelengthBothSpecifiedInputs,maxWavenumberMinWavelengthBothSpecifiedOptions}=If[Length[maxWavenumberMinWavelengthBothSpecifiedPackets]>0,
		{Lookup[Flatten[maxWavenumberMinWavelengthBothSpecifiedPackets],Object],{MaxWavenumber,MinWavelength}},
	(* if there are no discarded inputs, the list is empty *)
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[maxWavenumberMinWavelengthBothSpecifiedInputs]>0&&!gatherTests,
		Message[Error::MaxWavenumberMinWavelengthBothSpecified,ObjectToString[maxWavenumberMinWavelengthBothSpecifiedInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	maxWavenumberMinWavelengthBothSpecifiedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[maxWavenumberMinWavelengthBothSpecifiedInputs]==0,
			(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[maxWavenumberMinWavelengthBothSpecifiedInputs,Cache->cacheBall]<>" do not have MaxWavenumber and MinWavelength both Specified:",True,False]
			];
			passingTest=If[Length[minWavenumberMaxWavelengthBothSpecifiedInputs]==Length[simulatedSamples],
			(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,maxWavenumberMinWavelengthBothSpecifiedInputs],Cache->cacheBall]<>" do not have MaxWavenumber and MinWavelength both Specified:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*10. MaxWavenumber less than MinWavenumber*)
	minWavenumberGreaterThanMaxPackets=PickList[samplePackets,minWavenumberGreaterThanMaxList,True];

	{minGreaterThanMinInputs,minGreaterThanMinOptions}=If[Length[minWavenumberGreaterThanMaxPackets]>0,
		{Lookup[Flatten[minWavenumberGreaterThanMaxPackets],Object],{MaxWavenumber,MinWavenumber,MinWavelength,MaxWavelength}},
		(* if there are no discarded inputs, the list is empty *)
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[minGreaterThanMinInputs]>0&&!gatherTests,
		Message[Error::MinWavenumberGreaterThanMax,ObjectToString[minGreaterThanMinInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	minGreaterThanMaxTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[minGreaterThanMinInputs]==0,
			(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[minGreaterThanMinInputs,Cache->cacheBall]<>", if specified, have a MaxWavenumber greater than MinWavenumber or MaxWavelength greater than MinWavelength:",True,False]
			];
			passingTest=If[Length[minGreaterThanMinInputs]==Length[simulatedSamples],
			(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,minGreaterThanMinInputs],Cache->cacheBall]<>", if specified, have a MaxWavenumber greater than MinWavenumber or MaxWavelength greater than MinWavelength:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*11. Blank and BlankAmounts not both as Specified or as Null*)
	blankAndBlankAmountsSpecifiedAndNullPackets=PickList[samplePackets,blankAndBlankAmountsSpecifiedAndNullList,True];

	{blankAndBlankAmountsSpecifiedAndNullInputs,blankAndBlankAmountsSpecifiedAndNullOptions}=If[Length[blankAndBlankAmountsSpecifiedAndNullPackets]>0,
		{Lookup[Flatten[blankAndBlankAmountsSpecifiedAndNullPackets],Object],{Blanks,BlankAmounts}},
	(* if there are no discarded inputs, the list is empty *)
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[blankAndBlankAmountsSpecifiedAndNullInputs]>0&&!gatherTests,
		Message[Error::BlankSpecifiedNull,ObjectToString[blankAndBlankAmountsSpecifiedAndNullInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	blankAndBlankAmountsSpecifiedAndNullTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[blankAndBlankAmountsSpecifiedAndNullInputs]==0,
			(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
			(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[blankAndBlankAmountsSpecifiedAndNullInputs,Cache->cacheBall]<>", if specified, have both Blanks and BlanksAmount as both specified or Null:",True,False]
			];
			passingTest=If[Length[blankAndBlankAmountsSpecifiedAndNullInputs]==Length[simulatedSamples],
			(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
			(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,blankAndBlankAmountsSpecifiedAndNullInputs],Cache->cacheBall]<>", if specified, have both Blanks and BlanksAmount as both specified or Null:",True,True]
			];
			{failingTest,passingTest}
		],
	(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(*12. PressBlank specified when blanks are Null*)
	pressBlankWithNoBlanksPackets=PickList[samplePackets,pressBlankWithNoBlanksList,True];

	{pressBlankWithNoBlanksInputs,pressBlankWithNoBlanksOptions}=If[Length[pressBlankWithNoBlanksPackets]>0,
		{Lookup[Flatten[pressBlankWithNoBlanksPackets],Object],{PressBlank}},
		(* if there are no discarded inputs, the list is empty *)
		{{},{}}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[pressBlankWithNoBlanksInputs]>0&&!gatherTests,
		Message[Error::NoBlanks, ObjectToString[pressBlankWithNoBlanksInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	pressBlankWithNoBlanksTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[pressBlankWithNoBlanksInputs]==0,
				(* when not a single sample is low volume, we know we don't need to throw any failing test *)
				Nothing,
				(* otherwise, we throw one failing test for all low volume samples *)
				Test["The input sample(s) "<>ObjectToString[pressBlankWithNoBlanksInputs,Cache->cacheBall]<>", if specified, have Blanks if PressBlank is specified:",True,False]
			];
			passingTest=If[Length[pressBlankWithNoBlanksInputs]==Length[simulatedSamples],
				(* when ALL samples are low volume, we know we don't need to throw any passing test *)
				Nothing,
				(* otherwise, we throw one passing test for all non-low volume samples *)
				Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,pressBlankWithNoBlanksInputs],Cache->cacheBall]<>", if specified, have Blanks if PressBlank is specified:",True,True]
			];
			{failingTest,passingTest}
		],
		(* if we're not gathering tests, do Nothing *)
		Nothing
	];

	(* pull out all the shared options from the input options *)
	{name, confirm, canaryBranch, template, samplesInStorageCondition, originalCache, operator, parentProtocol, upload, outputOption, email, imageSample, numberOfReplicates, recoupSample} = Lookup[myOptions, {Name, Confirm, CanaryBranch, Template, SamplesInStorageCondition, Cache, Operator, ParentProtocol, Upload, Output, Email, ImageSample, NumberOfReplicates,RecoupSample}];

	(*Resolution warnings*)

	(*If the resolution generates a suspension solution and recouping was requested, we should throw a warning*)

	(*indexed matched boolean list that indicates where this warning would occur*)
	recoupSuspensionBool=MapThread[And[MatchQ[#1,ObjectP[]],#2]&,{resolvedSuspensionSolutions,recoupSample}];

	(*get the inputs*)
	recoupSuspensionPackets=PickList[samplePackets,recoupSuspensionBool,True];
	recoupSuspensionInputs=If[Length[recoupSuspensionPackets]>0,Lookup[Flatten[recoupSuspensionPackets],Object],{}];

	(* Throw the warning if we are. *)
	If[Length[recoupSuspensionInputs]>0&&!gatherTests,
		Message[Warning::RecoupSuspensionSolution,ObjectToString[recoupSuspensionInputs,Cache->cacheBall]]
	];

	(*Sample Module warning*)

	(*find where the sample module was not set to Reflectin*)
	sampleModuleWarningQ=MatchQ[resolvedSampleModule,Except[Reflection]];

	(* Throw the warning if we are. *)
	If[sampleModuleWarningQ&&!gatherTests,
		Message[Warning::ReflectionOnly]
	];

	(*Sample Pressure with liquid warning*)
	(*get the inputs*)
	samplePressureWithLiquidPackets=PickList[samplePackets,samplePressureWithLiquidList,True];
	samplePressureWithLiquidInputs=If[Length[samplePressureWithLiquidPackets]>0,Lookup[Flatten[samplePressureWithLiquidPackets],Object],{}];

	(* Throw the warning if we are. *)
	If[Length[samplePressureWithLiquidInputs]>0&&!gatherTests,
		Message[Warning::PressureApplicationWithFluidSample,ObjectToString[samplePressureWithLiquidInputs,Cache->cacheBall]]
	];

	(*No Sample Pressure with solid warning*)
	(*get the inputs*)
	noSamplePressureSolidPackets=PickList[samplePackets,noSamplePressureSolidList,True];
	noSamplePressureSolidInputs=If[Length[noSamplePressureSolidPackets]>0,Lookup[Flatten[noSamplePressureSolidPackets],Object],{}];

	(* Throw the warning if we are. *)
	If[Length[noSamplePressureSolidInputs]>0&&!gatherTests,
		Message[Warning::DryNoPressure,ObjectToString[noSamplePressureSolidInputs,Cache->cacheBall]]
	];

	(*Blank Pressure with liquid warning*)
	(*get the inputs*)
	blankPressureWithLiquidPackets=PickList[samplePackets,blankPressureWithLiquidList,True];
	blankPressureWithLiquidInputs=If[Length[blankPressureWithLiquidPackets]>0,Lookup[Flatten[blankPressureWithLiquidPackets],Object],{}];

	(* Throw the warning if we are. *)
	If[Length[blankPressureWithLiquidInputs]>0&&!gatherTests,
		Message[Warning::PressureApplicationWithFluidSampleBlanks,ObjectToString[blankPressureWithLiquidInputs,Cache->cacheBall]]
	];

	(*No Blank Pressure with solid  warning*)
	(*get the inputs*)
	noBlankPressureSolidPackets=PickList[samplePackets,noBlankPressureSolidList,True];
	noBlankPressureSolidInputs=If[Length[noBlankPressureSolidPackets]>0,Lookup[Flatten[noBlankPressureSolidPackets],Object],{}];

	(* Throw the warning if we are. *)
	If[Length[noBlankPressureSolidInputs]>0&&!gatherTests,
		Message[Warning::DryNoPressureBlanks,ObjectToString[noBlankPressureSolidInputs,Cache->cacheBall]]
	];

	(* Throw a warning if the suspension solution was resolved to something *)
	suspensionSolutionResolvedPackets=PickList[samplePackets,suspensionSolutionResolvedList,True];
	suspensionSolutionResolvedInputs=If[Length[suspensionSolutionResolvedPackets]>0,Lookup[Flatten[suspensionSolutionResolvedPackets],Object],{}];
	suspensionSolutionResolvedSolutions=If[Length[suspensionSolutionResolvedPackets]>0,PickList[resolvedSuspensionSolutions,suspensionSolutionResolvedList]];

	(* If there are invalid inputs and we are throwing messages, throw an error message *)
	If[Length[suspensionSolutionResolvedInputs]>0&&!gatherTests,
		Message[Warning::SuspensionSolutionResolved,ObjectToString[suspensionSolutionResolvedSolutions,Cache->cacheBall],ObjectToString[suspensionSolutionResolvedInputs,Cache->cacheBall]]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,lowSampleAmountInputs,incompatibleInputsAnyInstrument,tooManyMeasurementsInputs,quantityNotDefinedInputs,incompatibleUnitSampleAmountInputs,pressBlankWithNoBlanksInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{minGreaterThanMinOptions,instrumentIncapableOptions,suspensionSolutionSpecifiedVolumeNullOptions,suspensionSolutionVolumeSpecifiedSuspensionNullOptions,integrationTimeNumberOfReadingsBothNullOptions,integrationTimeNumberOfReadingsBothSpecifiedOptions,minWavenumberMaxWavelengthBothNullOptions,minWavenumberMaxWavelengthBothSpecifiedOptions,maxWavenumberMinWavelengthBothNullOptions,maxWavenumberMinWavelengthBothSpecifiedOptions,blankAndBlankAmountsSpecifiedAndNullOptions,incompatibleSuspensionSolutionOptionsAnyInstrument,incompatibleBlanksOptionsAnyInstrument,multipleIndicesOptions,nullSpecifiedBlankOptions,multipleObjectsOptions,blankQuantityNotDefinedOptions,incompatibleBlankAmountOptions,pressBlankWithNoBlanksOptions}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	(*targetContainers=targetAliquotContainerList;*)
	(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
	(* When you do not want an aliquot to happen for the corresopnding simulated sample, make the corresponding index of targetContainers Null. *)
	(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)

	(*figure out the required aliquot amounts*)

	(*first get the volume and mass of our original samples (not simulated)*)
	{sampleVolumes,sampleMasses}=Transpose@(Lookup[fetchPacketFromCache[#,cache],{Volume,Mass}]&/@mySamples);

	(*get the best aliquot amount based on the available amount*)
	bestAliquotAmount=MapThread[Which[
		MatchQ[#1,GreaterP[0*Liter]],globalMinVolume*1.25,
		MatchQ[#2,GreaterP[0*Gram]],globalMinMass*1.25,

		(*this is utterly nonsensical*)
		True,globalMinVolume

	]&,{sampleVolumes,sampleMasses}];

	(* Resolve Aliquot Options *)
	resolvedAliquotOptions=resolveAliquotOptions[
		ExperimentIRSpectroscopy,
		mySamples,
		simulatedSamples,
		ReplaceRule[myOptions,resolvedSamplePrepOptions],
		Cache -> cacheBall,
		Simulation->updatedSimulation,
		AllowSolids->True,
		RequiredAliquotAmounts->bestAliquotAmount,
		AliquotWarningMessage->Null
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];


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

	resolvedOptions = ReplaceRule[irSpectroscopyOptions,
		Join[
			{

				Instrument->instrumentLookup,
				SampleAmount->resolvedSampleAmounts,
				SampleModule->resolvedSampleModule,
				PressSample->resolvedSamplePressures,
				SuspensionSolution->resolvedSuspensionSolutions,
				SuspensionSolutionVolume->resolvedSuspensionSolutionVolumes,
				WavenumberResolution->Lookup[optionsWithRoundedVolumesMasses,WavenumberResolution],
				MinWavenumber->resolvedMinWavenumbers,
				MaxWavenumber->resolvedMaxWavenumbers,
				MinWavelength->Lookup[optionsWithRoundedVolumesMasses,MinWavelength],
				MaxWavelength->Lookup[optionsWithRoundedVolumesMasses,MaxWavelength],
				Blanks->resolvedBlanksTuple,
				BlankAmounts->resolvedBlankAmounts,
				PressBlank->resolvedBlankPressure,
				IntegrationTime->resolvedIntegrationTimes,
				NumberOfReadings->Lookup[optionsWithRoundedVolumesMasses,NumberOfReadings],
				RecoupSample->recoupSample,
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
			lowSampleVolumeTest,
			minGreaterThanMaxTest,
			incompatibleInputsAnyInstrumentTests,
			incompatibleInputBlanksAnyInstrumentTests,
			incompatibleSuspensionSolutionAnyInstrumentTests,
			instrumentIncapableTest,
			precisionTestsVolumes,
			precisionTestsVolumesMasses,
			sampleVolumeMassNullTest,
			sampleVolumeMassQuantityTest,
			suspensionSolutionSpecifiedVolumeNullTest,
			suspensionSolutionVolumeSpecifiedSuspensionNullTest,
			integrationTimeNumberOfReadingsBothNullTest,
			integrationTimeNumberOfReadingsBothSpecifiedTest,
			minWavenumberMaxWavelengthBothNullTest,
			minWavenumberMaxWavelengthBothSpecifiedTest,
			maxWavenumberMinWavelengthBothNullTest,
			maxWavenumberMinWavelengthBothSpecifiedTest,
			blankAndBlankAmountsSpecifiedAndNullTest,
			tooManyMeasurementsTest,
			multipleIndicesTest,
			nullSpecifiedBlankTest,
			multipleObjectsTest,
			blankQuantityNotDefinedTests,
			quantityNotDefinedTests,
			incompatibleUnitSampleAmountTests,
			incompatibleBlankUnitSampleAmountTests
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
	outputSpecification/.{
		resultRule,
		testsRule
	}
];



(* ::Subsubsection::Closed:: *)
(*Resource Packets*)


DefineOptions[irSpectroscopyResourcePackets,
	Options:>{
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];

irSpectroscopyResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},myCollapsedResolvedOptions:{___Rule},myOptions:OptionsPattern[]]:=Module[
	{outputSpecification,output,gatherTests,cache,samplesWithoutLinks,numberOfReplicates,samplesWithReplicates,optionsWithReplicates,
		instrument,recoupSample,blanks,blankTupleWithAmounts,gatheredBlanks,
		blankResourcesDictionary,blankIndices,blankSamples,blankAmountList,totalBlankAmount,blankResourceIndices,blanksResources,sampleResources,
		sampleAmounts,suspensionSolutions,blankAmounts,minWavenumbers,maxWavenumbers,minWavelengths,maxWavelengths,numberOfReadings,integrationTime,
		suspensionSolutionVolumes,wavenumberResolutions,samplePressures,blankPressures,minWavenumbersConverted,maxWavenumbersConverted,
		suspensionSolutionResources,instrumentResource,
		protocolPacket,allResourceBlobs,fulfillable,frqTests,resultRule,testsRule,
		gatherResourcesTime, simulation, updatedSimulation, simulatedSamples, samplePackets
	},
	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myOptions],Cache];
	(*cache=Download[myOptions,Cache];*)
	simulation = Lookup[ToList[myOptions], Simulation, Simulation[]];

	(* simulate the samples after they go through all the sample prep *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentIRSpectroscopy, mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation];

	(* Get rid of the links in mySamples. *)
	samplesWithoutLinks=mySamples/.{link_Link:>Download[link, Object]};

	(* Get our number of replicates. *)
	numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates]/.{Null->1};

	(*Get our instrument*)
	instrument=Lookup[myResolvedOptions,Instrument];

	(* Expand our samples and options according to NumberOfReplicates. *)
	{samplesWithReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentIRSpectroscopy,samplesWithoutLinks,myResolvedOptions];

	(* Lookup some of our options that were expanded.*)
	{recoupSample,blanks,sampleAmounts,suspensionSolutions,blankAmounts,minWavenumbers,maxWavenumbers,minWavelengths,maxWavelengths,numberOfReadings,integrationTime,suspensionSolutionVolumes,wavenumberResolutions,samplePressures,blankPressures}
			=Lookup[optionsWithReplicates,{RecoupSample,Blanks,SampleAmount,SuspensionSolution,BlankAmounts,MinWavenumber,MaxWavenumber,MinWavelength,MaxWavelength,NumberOfReadings,IntegrationTime,SuspensionSolutionVolume,WavenumberResolution,PressSample,PressBlank}];

	(*add the blank amounts to the blanks tuple*)
	blankTupleWithAmounts=MapThread[Append[#1,#2]&,{blanks,blankAmounts}];

	(*then we gather by the index*)
	gatheredBlanks=GatherBy[blankTupleWithAmounts,First];

	(*for the minWavenumber we need to potentially convert from the maxWavelength*)
	minWavenumbersConverted=MapThread[If[QuantityQ[#1],#1,RoundOptionPrecision[UnitConvert[1/#2,1/Centimeter],1/Centimeter]]&,{minWavenumbers,maxWavelengths}];

	(*for the maxWavenumber we need to potentially convert from the minWavelength*)
	maxWavenumbersConverted=MapThread[If[QuantityQ[#1],#1,RoundOptionPrecision[UnitConvert[1/#2,1/Centimeter],1/Centimeter]]&,{maxWavenumbers,minWavelengths}];

	(*now get the resources needed for the procedure*)

	(*create a blank resources dictionary*)
	blankResourcesDictionary=Map[(
		(*split everything up*)
		{blankIndices,blankSamples,blankAmountList}=Transpose[#];
		(*not going to do any checking, assuming we're good and that the units are compatible*)

		(*get the total amount and Nulls add up to Null*)
		totalBlankAmount=Total[blankAmountList]/.{a_Integer*Null->Null};

		(*make the resource if not Null*)
		If[!NullQ[First[blankSamples]],
			(*make the resource*)
			First[blankIndices]->Resource[Sample->First[blankSamples],
				(*grab a little bit more of the blank*)
				Amount->totalBlankAmount*1.3,
				Container->PreferredContainer[totalBlankAmount],
				Name->("Blank index "<>ToString[First[blankIndices]]<>" resource")
			],
			Null->Null
		]

	)&,gatheredBlanks];

	(*put the resources into an index matched form*)
	blankResourceIndices=(#/.{x_,_}:>x)&/@blanks;
	blanksResources=blankResourceIndices/.blankResourcesDictionary;

	(*get the suspension solution resources*)
	suspensionSolutionResources=MapThread[
		If[MatchQ[#1,ObjectP[Model[Sample]]],
			(*if it's a model, we'll take a new container and take a little bit more*)
			Resource[Sample->#1,Amount->#2*1.3,Container->PreferredContainer[#2]],
			(*otherwise, we'll want to directly sample from our container*)
			If[MatchQ[#1,ObjectP[Object[Sample]]],
				Resource[Sample->#1,Amount->#2],
				(*nothing here means that there is no suspension solution*)
				Null]]
				&,{suspensionSolutions,suspensionSolutionVolumes}];

	(*get the instrument resources. we will assume 30 minutes per sample for the instrument*)
	instrumentResource=Resource[Instrument->instrument,Time->(30 Minute)*Length[samplesWithReplicates]];

	(*roughly calculate the time required to gather resources*)
	gatherResourcesTime=(10 Minute)*(Length[samplesWithoutLinks]+Length[Cases[suspensionSolutions,Except[Null]]]+Length[blankResourcesDictionary]);

	(*create the sample resources*)
	sampleResources=MapThread[Resource[Sample->#1,Amount->#2]&,{samplesWithReplicates,sampleAmounts}];

	(* Create our protocol packet. *)
	protocolPacket=Join[<|
		Type->Object[Protocol,IRSpectroscopy],
		Object->CreateID[Object[Protocol,IRSpectroscopy]],
		Replace[SamplesIn]->sampleResources,
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@DeleteDuplicates[Lookup[fetchPacketFromCache[#,cache],Container]&/@samplesWithReplicates],

		Replace[RecoupSample]->recoupSample,
		Replace[NumberOfReadings]->numberOfReadings,
		Replace[IntegrationTime]->integrationTime,
		Replace[MinWavenumber]->minWavenumbersConverted,
		Replace[MaxWavenumber]->maxWavenumbersConverted,
		Replace[WavenumberResolution]->wavenumberResolutions,
		Replace[SampleAmount]->sampleAmounts,
		Replace[PressSample]->samplePressures,
		Replace[BlankAmounts]->blankAmounts,
		Replace[PressBlank]->blankPressures,
		Replace[SuspensionSolutionVolume]->suspensionSolutionVolumes,
		Instrument->instrumentResource,
		Replace[Blanks]->blanksResources,
		Replace[SuspensionSolutions]->suspensionSolutionResources,

		Replace[Checkpoints]->{
			{"Preparing Samples",0 Minute,"Preprocessing, such as incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Resource[Operator->$BaselineOperator,Time->0 Minute]},
			{"Picking Resources",gatherResourcesTime,"Samples required to execute this protocol are gathered from storage.",Resource[Operator->$BaselineOperator,Time->10 Minute]},
			{"Measuring Infrared",30 Minute*(Length[samplesWithReplicates]),"The Infrared spectra of the requested samples is measured.",Resource[Operator->$BaselineOperator,Time->30Minute*(Length[samplesWithoutLinks])]},
			{"Sample Postprocessing",0 Minute,"The samples are imaged and volumes are measured.",Resource[Operator->$BaselineOperator,Time->0 Minute]}
		},
		ResolvedOptions->myCollapsedResolvedOptions,
		UnresolvedOptions->myUnresolvedOptions
		|>,
		populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cache]
	];

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	(*TODO: probably need to fix*)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],
		{True,{}},
		gatherTests,
		Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache -> cache, Simulation -> updatedSimulation],
		True,
		{Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->Not[gatherTests],Cache -> cache, Simulation -> updatedSimulation],Null}
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



(* ::Subsection::Closed:: *)
(*ExperimentIRSpectroscopyOptions*)


DefineOptions[ExperimentIRSpectroscopyOptions,
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
	SharedOptions :> {ExperimentIRSpectroscopy}
];


ExperimentIRSpectroscopyOptions[myInputs:ListableP[ObjectP[{Object[Container], Model[Sample]}]] | ListableP[NonSelfContainedSampleP | _String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options *)
	options = ExperimentIRSpectroscopy[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentIRSpectroscopy],
		options
	]
];



(* ::Subsection::Closed:: *)
(*ExperimentIRSpectroscopyPreview*)


(* currently we only accept either a list of containers, or a list of samples *)
ExperimentIRSpectroscopyPreview[myInput:ListableP[ObjectP[{Object[Container], Model[Sample]}]] | ListableP[NonSelfContainedSampleP | _String],myOptions:OptionsPattern[ExperimentIRSpectroscopy]]:=
		ExperimentIRSpectroscopy[myInput,Append[ToList[myOptions],Output->Preview]];



(* ::Subsection::Closed:: *)
(*ValidExperimentIRSpectroscopyQ*)


DefineOptions[ValidExperimentIRSpectroscopyQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions :> {ExperimentIRSpectroscopy}
];

(* currently we only accept either a list of containers, or a list of samples *)
ValidExperimentIRSpectroscopyQ[myInput:ListableP[ObjectP[{Object[Container], Model[Sample]}]] | ListableP[NonSelfContainedSampleP | _String],myOptions:OptionsPattern[ValidExperimentIRSpectroscopyQ]]:=Module[
	{listedOptions, listedInput, oOutputOptions, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedInput = ToList[myInput];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentMeasurepH *)
	filterTests = ExperimentIRSpectroscopy[myInput, Append[preparedOptions, Output -> Tests]];

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
			validObjectBooleans = ValidObjectQ[DeleteCases[listedInput, _String],OutputFormat->Boolean];
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
	Lookup[RunUnitTest[<|"ValidExperimentIRSpectroscopyQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentIRSpectroscopyQ"]


];
