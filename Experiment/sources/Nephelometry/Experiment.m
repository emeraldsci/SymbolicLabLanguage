(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentNephelometry*)


(* ::Subsubsection::Closed:: *)
(*Options*)

DefineOptions[ExperimentNephelometry,
	Options :> {
		NephelometrySharedOptions,
		{
			OptionName -> SamplingPattern,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> PlateReaderSamplingP],
			Description -> "Indicates where in the well measurements are taken. Center indicates that measurements are taken from the center of the well. Ring indicates a ring within the well with a outer diameter of SamplingDistance. Spiral indicates a spiral from the diameter of SamplingDistance to the center of the well. Matrix indicates a grid of readings matching SamplingDimension, filling SamplingDistance. If any part of the grid falls outside of the well, it will not be included in the measurements. Additionally, Spiral will return a much higher background and should only be used bacteria and yeast with a high propensity to clump.",
			ResolutionDescription -> "Resolves to Ring if SamplingDistance is set, and resolves to Matrix if SamplingDimension is set, otherwise resolves to Center.",
			Category -> "Sampling"
		},
		{
			OptionName -> SamplingDimension,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Number, Pattern :> RangeP[2,30]],
			Description -> "Specifies the size of the grid used for Matrix sampling to fill to SamplingDistance. For example, SamplingDimension->5 will scan a 5 x 5 grid.",
			ResolutionDescription -> "Automatically set to 5 if SamplingPattern->Matrix, and Null otherwise.",
			Category -> "Sampling"
		}
	}
];

Error::NephelometryPreparedPlateContainerInvalid = "When using a prepared plate, the samples must all be in plates that are compatible with the instrument. Please transfer the samples or set PreparedPlate->False so the samples will be transferred automatically.";
Error::NephelometryPreparedPlateInvalidOptions = "When PreparedPlate->True, MoatBuffer, MoatSize, MoatVolume, Dilutions, and BlankVolume cannot be specified. Please set these options to Null or leave these options as Automatic, or set PreparedPlate to False.";
Error::NephelometryPreparedPlateBlanksInvalid = "PreparedPlate and BlankMeasurement are both True, but the assay plates do not contain all of the blanks. The Blank `1` are not in the Contents of the assay plates. Please set PreparedPlate to False to transfer the desired blanks into the plate, or set Blank to samples that are contained in the plate(s) already, or set BlankMeasurement to False if blanking is not necessary.";
Error::NephelometryNoStandardCurve = "The following sample(s), `1`, do not have an Analyte specified that is a Model[Cell] with a StandardCurve that relates NephelometricTurbidityUnit to Cell/mL. When Method->CellCount, a StandardCurve must already be defined for the cell sample. To obtain a StandardCurve, please call ExperimentQuantifyCells.";
Error::NephelometryNonCellAnalyte = "The following sample(s), `1`, have Analyte(s) specified that are not Model[Cell]s. When Method is set to CellCount, the sample's Analyte must be a Model[Cell]. If you wish to quantify both cell and non-cell samples, please submit two experiments.";
Error::NephelometrySampleMustContainAnalyte = "The Analyte option is specified for substance(s) that are not components of the following input sample(s): `1`.  Please specify analytes that are component(s) of the sample(s), or leave this option as Automatic.";
Error::NephelometryMethodQuantificationMismatch = "When Method is `2`, QuantifyCellCount cannot be True. Please change the value of QuantifyCellCount for samples `1` or leave as Automatic, or change the Method to CellCount.";
Error::NephelometryAnalyteMissing = "The Analyte option could not be automatically determined from the Analytes field or from the Composition of the sample. Please specify an analyte for samples `1`.";
Error::NephelometryConflictingDilutionCurveTypes = "A DilutionCurve `1` and SerialDilutionCurve `2` are specified for samples `3`. Only one type of dilution can be specified for each sample; please specify either DilutionCurve or SerialDilutionCurve for each sample.";
Error::NephelometryMissingDiluent = "A DilutionCurve or SerialDilutionCurve is specified `1` but no Diluent is given `2` for samples `3`. Please specify a Diluent for these samples, or leave Diluent to be set automatically.";
Error::NephelometryMissingDilutionCurve = "A Diluent `1` is specified, but DilutionCurve or SerialDilutionCurve is Null `2` for the samples `3`. Please set Diluent to Null, or leave DilutionCurve to be set automatically.";
Error::NephelometryDilutionVolumeTooLarge = "The total volume needed to make the dilutions for DilutionCurve `1` and/or SerialDilutionCurve `2` plus the injection volumes if any, are more than the container's maximum volume `3`. Please specify smaller volumes for injections and/or dilutions.";
Error::NephelometryIntegrationTimeTooLarge = "When SamplingPattern is `1` and SamplingDistance is `2`, IntegrationTime must be less than `3`. Please specify an IntegrationTime that is less than `3` or set SamplingDistance to a larger value to allow for a longer IntegrationTime, or allow IntegrationTime to be set automatically.";
Warning::NephelometryIncomputableConcentration="For sample(s) `1`, the input analyte concentration cannot be calculated because the analyte(s) `2` do not have `3` fields populated.";

(* Kinetics specific error messages *)
Error::NephelometryKineticsCycleTimeTooLong = "If KineticWindowDurations are not All, the total CycleTime `1` multiplied by the corresponding NumberOfCycles `3` (subracting 1 cycle from the first NumberOfCycles to account for a measurement at time 0) cannot be longer than the corresponding KineticWindowDurations `2`. Please change the CycleTime, NumberOfCycles, or KineticWindowDurations accordingly, or leave NumberOfCycles or CycleTime as Automatic.";
Error::NephelometryKineticsTooManyKineticWindowDurations = "The instrument cannot accommodate more than 4 KineticWindowDurations. Please specify fewer KineticWindowDurations or specify as All.";
Error::NephelometryKineticsTooManyCycles = "The instrument cannot accommodate more than a total of 1000 NumberOfCycles across all KineticWindowDurations, but the NumberOfCycles totals to `1`, which is greater than 1000. Please specify fewer NumberOfCycles.";
Error::NephelometryKineticsCycleTimingIncompatible = "The CycleTime `1` multiplied by the NumberOfCycles `2` must be equal to the KineticWindowDurations `3` for the timing to be valid. Please change these values or leave either the CycleTime or NumberOfCycles as Automatic to be calculated automatically.";
Error::NephelometryKineticsRunTimeIncompatible = "The RunTime `2` must be equal to the total of the KineticWindowDurations `1`. Please change these values or leave the RunTime as Automatic to be calculated automatically.";



(* ::Subsubsection:: *)
(*Constants*)


$BMGFlushVolume = 22.5 Milliliter;
$BMGPrimeVolume = 1 Milliliter;


(* this is different from Abs/Fluor as the well color needs to be clear in order for laser to pass through sample *)
(* the well bottom must also be flat and the wells must be round to minimize meniscus effects *)
BMGCompatiblePlates[Nephelometry] := BMGCompatiblePlates[Nephelometry] = Module[
	{compatiblePlates},

	(* get all the compatible plates; they don't even necessarily need to be liquid handleable *)
	compatiblePlates = Search[
		Model[Container, Plate],

		And[
			(* the 36 well plate is for the weird testing plate; it is treated like a 96 well plate elsewhere so we're just going to do so now too*)
			NumberOfWells == (96 | 384 | 36),
			Opaque != True,
			Dimensions[[3]] <= 2.0 Centimeter,
			Footprint == Plate,
			WellColor == Clear,
			WellBottom == FlatBottom,
			WellDiameter != Null
		]
	];

	(* for now deleting filter plates and irregular plates because those won't work here, but I don't want to set SubTypes -> False in the Search call because there could in the future be acceptable subtypes *)
	DeleteCases[compatiblePlates, ObjectP[{Model[Container, Plate, Filter], Model[Container, Plate, Irregular]}]]

];

BMGPlateModelLookup[Null]:=Null;
BMGPlateModelLookup[{}]:={};
BMGPlateModelLookup[plateModel:ObjectP[Model[Container, Plate]]]:=First[BMGPlateModelLookup[{plateModel}]];
BMGPlateModelLookup[plateModels:{ObjectP[Model[Container, Plate]]..}]:=Module[
	{platePackets},

	platePackets = Download[plateModels, Packet[BMGLayout, NumberOfWells],Date->Now];

	Map[
		Which[
			StringQ[Lookup[#, BMGLayout]], Lookup[#, BMGLayout],
			MatchQ[Lookup[#, NumberOfWells], 96|36], "GREINER 96 F-BOTTOM",
			MatchQ[Lookup[#, NumberOfWells], 384], "GREINER 384",
			True, Null
		]&,
		platePackets
	]
];
BMGCompatiblePlatesP[Nephelometry] := Alternatives@@BMGCompatiblePlates[Nephelometry];




(*------------------------------*)
(*----Main Function Overload----*)
(*------------------------------*)

ExperimentNephelometry[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedSamples,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,
		mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed,
		mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,estimatedRunTime,
		updatedSimulation,safeOps,safeOpsTests,validLengths,validLengthTests,returnEarlyQBecauseFailure,performSimulationQ,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,nephelometryOptionsAssociation,
		samplePrepOptions,nephelometryOptions,uniqueInjectionSamples,uniqueBlankSamples,possibleAliquotContainers,
		analyte,downloadAnalytes,specifiedInstruments,analyteFields,analyteFieldPacket,standardCurveFields,containerModelPreparationPackets,sampleAnalyteAllFields,
		listedInjectionSamplePackets, listedBlankPackets, listedAliquotContainerPackets, analytePacket,specifiedInstrumentPackets,
		samplePreparationPackets, sampleModelPreparationPackets, containerPreparationPackets,
		sampleCompositionPackets, allSamplePackets,samplePackets,sampleModelPackets,sampleContainerPackets, sampleAnalytePackets,
		compositionPackets, sampleContainerModelPackets, optionsResolverOnly, returnEarlyQBecauseOptionsResolverOnly,
		cacheBall, resolvedOptionsResult,simulatedProtocol, simulation,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links. *)
	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentNephelometry,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentNephelometry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentNephelometry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* change Named version of objects into ID version *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed,Simulation->updatedSimulation];
	
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
		ValidInputLengthsQ[ExperimentNephelometry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentNephelometry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
		ApplyTemplateOptions[ExperimentNephelometry,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentNephelometry,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentNephelometry,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(*Convert list of rules to Association so we can Lookup, Append, Join as usual*)
	nephelometryOptionsAssociation=Association[expandedSafeOps];

	(* Separate out our Nephelometry options from our Sample Prep options. *)
	{samplePrepOptions,nephelometryOptions}=splitPrepOptions[expandedSafeOps];

	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall={};

	(* Get our unique injection samples for download *)
	uniqueInjectionSamples=DeleteDuplicates[
		Download[
			Cases[
				Lookup[nephelometryOptionsAssociation,{PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample},Automatic],
				ObjectP[Object]
			],
			Object
		]
	];

	(* Get our unique blanks for download *)
	uniqueBlankSamples=DeleteDuplicates[Download[Cases[Lookup[nephelometryOptionsAssociation,Blank],ObjectP[Object]],Object]];

	(* Get the container we'll use for any aliquots - either the user's or we'll default to first compatible *)
	possibleAliquotContainers=Append[
		DeleteDuplicates[Cases[Flatten[Lookup[samplePrepOptions,AliquotContainer],1],ObjectP[]]],
		First[BMGCompatiblePlates[Nephelometry]]
	];

	(* figure out what analytes to download from *)
	analyte = Lookup[nephelometryOptionsAssociation, Analyte];

	(* replace Automatic with an empty list so the download works *)
	downloadAnalytes = Flatten[analyte/. Automatic->{}];

	(* get all specified instruments *)
	specifiedInstruments = DeleteDuplicates[Cases[Flatten[Lookup[nephelometryOptionsAssociation, {Instrument}]], ObjectP[{Object[Instrument], Model[Instrument]}]]];

	(* pick out the fields to download from the analytes *)
	analyteFields={StandardCurves,IncubationTemperature,Molecule,MolecularWeight,Density};
	analyteFieldPacket=Packet@@analyteFields;
	standardCurveFields={StandardDataUnits};

	(* decide what to download *)
	samplePreparationPackets = Packet[SamplePreparationCacheFields[Object[Sample], Format->Sequence], IncompatibleMaterials, Well];
	sampleModelPreparationPackets = Packet[Model[Flatten[{Deprecated, Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample]]}]]];
	containerPreparationPackets = Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], ModelName, MaxVolume, MinVolume, NumberOfWells, WellDiameter, WellDimensions, WellColor}]]];
	containerModelPreparationPackets = Packet[Container[Model][SamplePreparationCacheFields[Model[Container]]]];
	compositionPackets = Packet[Field[Composition[[All,2]][analyteFields]]];
	sampleAnalyteAllFields={
		Packet[Field[Composition[[All,2]][analyteFields]]],
		Packet[Field[Composition[[All,2]][StandardCurves][standardCurveFields]]]
	};

	(* Extract the packets that we need from our downloaded cache. *)
	{
		allSamplePackets,
		sampleAnalytePackets,
		listedInjectionSamplePackets,
		listedBlankPackets,
		listedAliquotContainerPackets,
		analytePacket,
		specifiedInstrumentPackets
	}=Quiet[
		Download[
			{
				mySamplesWithPreparedSamples,
				mySamplesWithPreparedSamples,
				uniqueInjectionSamples,
				uniqueBlankSamples,
				possibleAliquotContainers,
				downloadAnalytes,
				specifiedInstruments
			},
			Evaluate[{
				{
					samplePreparationPackets,
					sampleModelPreparationPackets,
					containerPreparationPackets,
					containerModelPreparationPackets,
					compositionPackets
				},
				sampleAnalyteAllFields,
				{Packet[IncompatibleMaterials, Well, RequestedResources, SamplePreparationCacheFields[Object[Sample], Format -> Sequence]]},
				{Packet[Container, State],Packet[Container[{Model}]],Packet[Container[Model][{MaxVolume}]]},
				{Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence], RecommendedFillVolume]},
				{analyteFieldPacket},
				{Packet[Model, IntegratedLiquidHandler, IntegratedLiquidHandlers], Packet[IntegratedLiquidHandler[Model]], Packet[IntegratedLiquidHandler[Model][Object]], Packet[IntegratedLiquidHandlers[Object]]}
			}],
			Cache->Lookup[expandedSafeOps, Cache, {}],
			Simulation->updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(*Extract the sample-related packets*)
	samplePackets=allSamplePackets[[All,1]];
	sampleModelPackets=allSamplePackets[[All,2]];
	sampleContainerPackets=allSamplePackets[[All,3]];
	sampleContainerModelPackets=allSamplePackets[[All,4]];
	sampleCompositionPackets=allSamplePackets[[All,5]];

	(* Combine our downloaded and simulated cache. *)
	cacheBall=FlattenCachePackets[{
		allSamplePackets,
		sampleAnalytePackets,
		listedInjectionSamplePackets,
		listedBlankPackets,
		listedAliquotContainerPackets,
		analytePacket,
		specifiedInstrumentPackets
	}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentNephelometryOptions[Object[Protocol,Nephelometry],mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentNephelometryOptions[Object[Protocol,Nephelometry],mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentNephelometry,
		resolvedOptions,
		Ignore->myOptionsWithPreparedSamples,
		Messages->False
	];


	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentNephelometry,collapsedResolvedOptions],
			Preview->Null,
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyQBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result | Simulation]];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQBecauseFailure = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ = MemberQ[output, Result|Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[(returnEarlyQBecauseFailure || returnEarlyQBecauseOptionsResolverOnly) && !performSimulationQ,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentNephelometry,collapsedResolvedOptions],
			Preview->Null,
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* Build packets with resources *)
	(* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
	{resourcePackets,resourcePacketTests}=Which[
		MatchQ[resolvedOptionsResult,$Failed],
			{$Failed, {}},
		gatherTests,
			nephelometryResourcePackets[Object[Protocol,Nephelometry],ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
		True,
			{nephelometryResourcePackets[Object[Protocol,Nephelometry],ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],{}}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateReadPlateExperiment[
			Object[Protocol,Nephelometry],
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				resourcePackets[[1]] (* protocolPacket *)
			],
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				ToList[resourcePackets[[2]]] (* unitOperationPackets *)
			],
			ToList[mySamplesWithPreparedSamples],
			resolvedOptions,
			Cache->cacheBall,
			Simulation->updatedSimulation
		],
		{Null, Null}
	];

	estimatedRunTime = 15 Minute +
		(Lookup[resolvedOptions,PlateReaderMixTime]/.Null->0 Minute) +
		(* Add time needed to clean/prime each each injection line *)
		(If[!MatchQ[Lookup[resolvedOptions,PrimaryInjectionSample],Null|{}],15*Minute,0*Minute]);

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentNephelometry,collapsedResolvedOptions],
			Preview -> Null,
			Simulation->simulation,
			RunTime -> estimatedRunTime
		}]
	];

	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure->True or return a real protocol that's ready to be run. *)
	protocolObject = Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[resourcePackets,$Failed] || MatchQ[resolvedOptionsResult,$Failed],
		$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if Upload->False. *)
		MatchQ[Lookup[resolvedOptions,Preparation],Robotic]&&MatchQ[Lookup[safeOps,Upload],False],
		resourcePackets[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call RCP or RSP with our primitive. *)
		MatchQ[Lookup[resolvedOptions,Preparation],Robotic],
		Module[{primitive, nonHiddenOptions, samplesMaybeWithModels, allCellTypes, experimentFunction},

			(* convert the samples to models if we had model inputs originally *)
			(* if we don't have a simulation or a single prep unit op, then we know we didn't have a model input *)
			(* NOTE: this is important. Need to use updatedSimulation here and not simulation.  This is because mySamples needs to get converted to model via the simulation _before_ SimulateResources is called in simulateExperimentFilter *)
			(* otherwise, the same label will point at two different IDs, and that's going to cause problems *)
			samplesMaybeWithModels = If[NullQ[updatedSimulation] || Not[MatchQ[Lookup[resolvedOptions, PreparatoryUnitOperations], {_[_LabelSample]}]],
				mySamples,
				simulatedSamplesToModels[
					Lookup[resolvedOptions, PreparatoryUnitOperations][[1, 1]],
					updatedSimulation,
					mySamples
				]
			];

			(* Create our primitive to feed into RoboticSamplePreparation. *)
			primitive=Nephelometry@@Join[
				{
					Sample -> samplesMaybeWithModels
				},
				RemoveHiddenPrimitiveOptions[Nephelometry,ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions=RemoveHiddenOptions[ExperimentNephelometry,collapsedResolvedOptions];

			(* Since Neph always uses the microbioSTAR or bioSTAR, use cell type to decide whether to call RSP or RCP *)
			(* Get all of our CellTypes *)
			allCellTypes=Lookup[samplePackets,CellType];

			(* Nephelometry can only be done on bioSTAR/microbioSTAR, so call RCP *)
			experimentFunction = ExperimentRoboticCellPreparation;

			(* Memoize the value of ExperimentNephelometry so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentNephelometry, $PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache=<||>;

				DownValues[ExperimentNephelometry]={};

				ExperimentNephelometry[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
					(* Lookup the output specification the framework is asking for. *)
					frameworkOutputSpecification=Lookup[ToList[options], Output];

					frameworkOutputSpecification/.{
						Result -> resourcePackets[[2]],
						Options -> nonHiddenOptions,
						Preview -> Null,
						Simulation -> simulation,
						RunTime -> estimatedRunTime
					}
				];

				experimentFunction[
					{primitive},
					Name->Lookup[safeOps,Name],
					Upload->Lookup[safeOps,Upload],
					Confirm->Lookup[safeOps,Confirm],
					CanaryBranch->Lookup[safeOps,CanaryBranch],
					ParentProtocol->Lookup[safeOps,ParentProtocol],
					Priority->Lookup[safeOps,Priority],
					StartDate->Lookup[safeOps,StartDate],
					HoldOrder->Lookup[safeOps,HoldOrder],
					QueuePosition->Lookup[safeOps,QueuePosition],
					Cache->cacheBall
				]
			]
		],

		(* Actually upload our protocol object. *)
		True,
		UploadProtocol[
			resourcePackets[[1]], (* protocolPacket *)
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			CanaryBranch->Lookup[safeOps,CanaryBranch],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,Nephelometry],
			Cache->cacheBall,
			Simulation->updatedSimulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentNephelometry,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedRunTime
	}
];


(*--------------------------*)
(*----Container overload----*)
(*--------------------------*)

ExperimentNephelometry[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedContainers,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,containerToSampleSimulation,
		updatedSimulation,containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links. *)
	{listedContainers, listedOptions}={ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentNephelometry,
			listedContainers,
			listedOptions,
			(* Note:the default input options are also in NephelometrySharedOptions, if these values are updated, please update resolution description in the shared options as well *)
			DefaultPreparedModelAmount -> 100 Microliter,
			DefaultPreparedModelContainer -> Model[Container, Plate, "id:n0k9mGzRaaBn"]
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentNephelometry,
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
				ExperimentNephelometry,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Simulation->updatedSimulation
			],
			$Failed,
			{Error::EmptyContainer}
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
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentNephelometry[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];

(*---------------------------------------*)
(*----ExperimentNephelometry resolver----*)
(*---------------------------------------*)

DefineOptions[
	resolveExperimentNephelometryOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentNephelometryOptions[
	myType : (Object[Protocol, Nephelometry] | Object[Protocol, NephelometryKinetics]),
	mySamples:{ObjectP[Object[Sample]]...},
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentNephelometryOptions]]:=
 Module[
	{
		outputSpecification,output,gatherTests,messages,cache,simulation,samplePrepOptions,nephelometryOptions,simulatedSamples,
		resolvedSamplePrepOptions,updatedSimulation,samplePrepTests,experimentFunction,experimentMode,
		nephelometryOptionsAssociation,fastTrack, name, parentProtocol,preparationResult,allowedPreparation,preparationTest,resolvedPreparation,
		resolvedWorkCell,

		(* Download section *)
		samplePreparationPackets, sampleModelPreparationPackets, containerPreparationPackets, standardCurveFields,
		sampleCompositionPackets, allSamplePackets,samplePackets,sampleModelPackets,sampleContainerPackets, compositionPackets,
		downloadAnalytes, analyteFields, analyteFieldPacket, sampleAnalyteAllFields, sampleAnalytePackets,
		uniqueInjectionSamples,uniqueBlankSamples, possibleAliquotContainers,
		listedInjectionSamplePackets, listedBlankPackets, listedAliquotContainerPackets,
		injectionSamplePackets,blankSamplePackets,blankContainerPackets,aliquotContainerModelPacket,
		containerModelPreparationPackets,sampleContainerModelPackets,analytePacket,

		cacheBall,fastAssoc,notInEngine,

		(* non-rounded options *)
		instrument, method, preparedPlate, analyte, quantifyCellCount,dilutions,
		plateReaderMix, plateReaderMixMode, moatSize, moatBuffer, readDirection,
		primaryInjection, secondaryInjection, primaryInjectionSample, secondaryInjectionSample, primaryInjectionFlowRate, secondaryInjectionFlowRate,
		primaryInjectionSampleStorageCondition, secondaryInjectionSampleStorageCondition, blankMeasurement, blank,
		numberOfReplicates, samplingPattern, samplingDimension,
		(* kinetics only *)
		readOrder, plateReaderMixSchedule, numberOfCycles, tertiaryInjectionSample, quaternaryInjectionSample,

		(* invalid input checks *)
		samplingDistance,resolvedSamplingPattern,samplingRequested,validSamplingCombo, validSamplingComboTest,
		discardedSamplePackets, discardedInvalidInputs, discardedTest,
		nonLiquidSamplePackets, nonLiquidSampleInvalidInputs, nonLiquidSampleTest,
		sampleModelPacketsToCheck, deprecatedSampleModelPackets,deprecatedInvalidInputs,deprecatedTest,
		sampleContainerModel,sampleContainerObject,validPreparedPlateContainerQ,preparedPlateInvalidContainerInputs,
		incompatiblePlateModels,validPreparedPlateContainerTest,compatiblePlateQ,
		compatibleMaterialsBool,compatibleMaterialsTests,compatibleMaterialsInvalidOption,

		(* rounded options *)
		unroundedDilutionCurve,separatedUnroundedDilutionCurve,roundedDilutionCurveOption, dilutionPrecisionTests,roundedDilutionCurveOptions,
		unroundedSerialDilutionCurve,roundedSerialDilutionCurveOptions,serialDilutionPrecisionTests,roundedNephelometryOptionsNoDilutions,precisionTestsNoDilutions,
		roundedNephelometryOptionsList,roundedNephelometryKineticsOptionsList,roundedNephelometryOptionsPrecisions,roundedNephelometryKineticsOptionsPrecisions,
		roundedNephelometryOptions, precisionTests,
		beamAperture, beamIntensity, temperature, equilibrationTime, targetCarbonDioxideLevel, targetOxygenLevel,
		plateReaderMixTime, plateReaderMixRate, moatVolume,
		settlingTime, readStartTime, integrationTime,
		primaryInjectionVolume, secondaryInjectionVolume, blankVolumes,
		(* kinetics *)
		kineticWindowDurations, cycleTime, runTime, tertiaryInjectionVolume, quaternaryInjectionVolume,
		primaryInjectionTime, secondaryInjectionTime, tertiaryInjectionTime, quaternaryInjectionTime,

		(* conflicting options *)
		validNameQ, nameInvalidOptions, validNameTest,
		separateSamplesAndBlanksQ,blanksInvalidTest,blanksInvalidOptions,
		specifiedRetainCover,validRetainCover,retainCoverTest,retainCoverInvalidOptions,
		plateReaderMixOptionInvalidities,plateReaderMixTests,
		specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume,invalidDiluents,invalidDilutionCurves,invalidSerialDilutionCurves,
		validPreparedPlateOptionsQ,invalidBlankVolumes,invalidMoats,preparedPlateInvalidOptions,validPreparedPlateTest,
		containersInContents,blanksInPlateQ,preparedPlateBlanksContainerOptions,validPreparedPlateBlanksContainerTest,
		suppliedDilutionCurve,suppliedSerialDilutionCurve,conflictingDilutionCurve,conflictingDilutionCurveOptions,conflictingDilutionCurveInputs,
		conflictingDilutionCurveInvalidOptions,conflictingDilutionCurveTest,suppliedDiluent,missingDiluent,
		missingDiluentOptions,missingDiluentInputs,missingDiluentInvalidOptions,missingDiluentTest,
		missingDilutionCurve,missingDilutionCurveOptions,missingDilutionCurveInputs,missingDilutionCurveTest,
		totalCycleTime,cycleTimeTooHighErrors,cycleTimeTooHighTest,cycleTimeTooHighOptions, zeroTimeNumberOfCycles,
		tooManyKineticWindowsError,tooManyKineticWindowsTest,tooManyKineticWindowsOptions,
		tooManyCyclesError,tooManyCyclesTest,tooManyCyclesOptions,dilutionErrorsQ,
		validCycleTimingQ,cycleTimingError,cycleTimingTest,cycleTimingOptions,
		runTimeKineticWindowError,runTimeKineticWindowTest,runTimeKineticWindowOptions,
		resolvedACUTests,resolvedACUInvalidOptions,

		(* independent options resolution *)
		resolvedACUOptions, roundedMixRate,roundedMixTime,mixOptions,resolvedPlateReaderMix,anyInjectionsQ,
		resolvedRunTime,resolvedKineticWindowDurations,listedCycleTime,listedNumberOfCycles,resolvedCycleTimes,calculatedNumberOfCycles,resolvedNumberOfCycles,
		defaultMixingRate,defaultMixingTime,defaultMixingMode,defaultMixingSchedule, kineticWindowTimingsErrors,
		resolvedPlateReaderMixRate,resolvedPlateReaderMixTime,resolvedPlateReaderMixMode,resolvedPlateReaderMixSchedule,
		suppliedPrimaryFlowRate,suppliedSecondaryFlowRate,suppliedTertiaryFlowRate,suppliedQuaternaryFlowRate,
		primaryInjectionsQ,secondaryInjectionQ,tertiaryInjectionQ,quaternaryInjectionQ,
		resolvedPrimaryFlowRate,resolvedSecondaryFlowRate,resolvedTertiaryFlowRate,resolvedQuaternaryFlowRate,
		suppliedAliquotBooleans,suppliedAliquotVolumes,suppliedAssayVolumes,suppliedTargetConcentrations,suppliedAssayBuffers,suppliedAliquotContainers, suppliedConsolidateAliquots,
		automaticAliquotingBooleans,uniqueContainers,
		numberOfAliquotContainers,tooManyAliquotContainers,replicateAliquotsRequired,replicatesError,replicatesWarning,
		sampleRepeatAliquotsRequired,sampleRepeatError,sampleRepeatWarning,bmgAliquotRequired,specifiedBlanks,specifiedBlankVolumes,
		preresolvedNumReplicates,blanksWithVolumesToMove,numberOfTransferBlanks,replicatesAliquotTest,sampleRepeatTest,invalidAliquotOption,blankAliquotRequired,
		mapThreadFriendlyOptions,analyteCellTypeQ,missingStandardCurveBools,noStandardCurveQ,resolvedMethod,noStandardCurveTest, noStandardCurveInvalidOptions,
		roundedBeamIntensity,resolvedBeamIntensity,nonCellAnalyteInvalidOptions,nonCellAnalyteTest,nonCellAnalyteQ,
		roundedTemperature,incubationTemperaturesMean,incubationTemperature,resolvedTemperature,incubationTemperaturesFromPackets,
		roundedEquilibrationTime,resolvedTemperatureEquilibriumTime,
		plateReaderTemperatureNoEquilibrationWarning, plateReaderTemperatureNoEquilibrationTest,
		resolvedAnalytes, resolvedAnalyteTests,analytePackets,
		updatedMapThreadFriendlyOptions,

		(* map thread *)
		resolvedOptionsPackets, resolvedMapThreadErrorTrackerPackets,
		allResolvedMapThreadOptionsAssociation,allErrorTrackersAssociation,

		(* unresolvable options checks *)
		mapThreadQuantifyCellCount,methodQuantificationMismatchTest, methodQuantificationMismatchInvalidOptions,
		mapThreadBlank,mapThreadBlankVolume,blankAliquotError,blankContainerErrorTest,incompatibleBlankVolumesInvalidOptions,
		blankContainerWarningTest,incompatibleBlankInvalidOptions,incompatibleBlankOptionTests,selectedBlanks,nonLiquidBlanksBoolean,
		nonLiquidBlanks,blankStateWarning,blankStateWarningTest,
		skippedInjectionError,injectionQList,injectionOptionList,skippedInjectionIndex,invalidSkippedInjection,skippedInjectionErrorTest,
		quantRequiresBlankingInvalidOptions,quantRequiresBlankingTest,
		sampleContainsAnalyteErrors,sampleContainsAnalyteOptions,sampleContainsAnalyteOptionTests,
		analyteMissingErrors,mapThreadAnalyte,analyteMissingOptions,analyteMissingOptionTests,flatAnalytePackets,
		sampleCompositions,analyteCompositions,analyteConcentrations,sampleDensities,inputConcentrations,analyteConcentrationsConverted,unresolvableAnalyteConcentrationTuples,
		mapThreadDiluents,mapThreadDilutionCurves, mapThreadSerialDilutionCurves, containerMaxVolume,dilutionVolumeTooLarge,serialDilutionVolumeTooLarge,dilutionVolumeTooLargeInvalidOptions,dilutionVolumeTooLargeTest,

		(* post Map Thread option resolution *)
		resolvedNumberOfReplicates,intNumReplicates,
		blankObjects,numBlanks,numOfBlankAdditions,totalNumSamples,invalidMoatOptions,moatTests,
		resolvedMoatBuffer,resolvedMoatVolume,resolvedMoatSize,preresolvedAliquot,
		validPlateModelsList,resolutionAliquotContainer,requiredAliquotContainers,suppliedDestinationWells,plateWells,moatWells,impliedMoat,
		suppliedDestinationWellsNoAutomatic,duplicateDestinationWells,duplicateDestinationWellOption,duplicateDestinationWellTest,
		invalidDestinationWellLengthQ,invalidDestinationWellLengthOption,invalidDestinationWellLengthTest,
		resolvedDestinationWells, requiredAliquotAmounts,aliquotWarningMessage,resolvedConsolidateAliquots,preresolvedAliquotOptions,resolveAliquotOptionsTests,
		resolvedIntegrationTime, integrationTimeError,invalidIntegrationTimeOption,invalidIntegrationTimeTest,
		sampleVolumes,sampleObjs,notEqualBlankVolumes,notEqualSamples,notEqualBlankVolumesWarning,notEqualBlankVolumesWarningTest,
		assayContainerModelPacket,invalidInjectionOptions,validInjectionTests,
		resolvedPostProcessingOptions,email,resolvedSamplingDistance,resolvedSamplingDimension,
		invalidInputs,invalidOptions,resolvedAliquotOptions,resolvedOptions,allTests,testsRule,resultRule,

		resolvedSampleLabels, resolvedSampleContainerLabels, resolvedBlankLabels
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation];

	(* Separate out our Nephelometry options from our Sample Prep options. *)
	{samplePrepOptions,nephelometryOptions}=splitPrepOptions[myOptions];

	(* get the experiment function that we care about *)
	{experimentFunction,experimentMode} = Switch[myType,
		Object[Protocol, Nephelometry], {ExperimentNephelometry, Nephelometry},
		Object[Protocol, NephelometryKinetics], {ExperimentNephelometryKinetics, NephelometryKinetics}
	];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentNephelometry,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentNephelometry,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	nephelometryOptionsAssociation = Association[nephelometryOptions];

	(*Pull out the Nephelometry options that are defaulted or specified that don't have precision*)
	{
		instrument,
		method,
		preparedPlate,
		analyte,
		quantifyCellCount,
		plateReaderMix,
		plateReaderMixMode,
		moatSize,
		moatBuffer,
		readDirection,
		primaryInjection,
		secondaryInjection,
		primaryInjectionSample,
		secondaryInjectionSample,
		primaryInjectionFlowRate,
		secondaryInjectionFlowRate,
		primaryInjectionSampleStorageCondition,
		secondaryInjectionSampleStorageCondition,
		blankMeasurement,
		blank,
		numberOfReplicates,
		samplingPattern,
		fastTrack,
		name,
		parentProtocol
	}=Lookup[
		nephelometryOptionsAssociation,
		{
			Instrument,
			Method,
			PreparedPlate,
			Analyte,
			QuantifyCellCount,
			PlateReaderMix,
			PlateReaderMixMode,
			MoatSize,
			MoatBuffer,
			ReadDirection,
			PrimaryInjection,
			SecondaryInjection,
			PrimaryInjectionSample,
			SecondaryInjectionSample,
			PrimaryInjectionFlowRate,
			SecondaryInjectionFlowRate,
			PrimaryInjectionSampleStorageCondition,
			SecondaryInjectionSampleStorageCondition,
			BlankMeasurement,
			Blank,
			NumberOfReplicates,
			SamplingPattern,
			FastTrack,
			Name,
			ParentProtocol
		}
	];

	(*Pull out the NephelometryKinetics specific options that are defaulted or specified that don't have precision*)
	{
		readOrder,
		plateReaderMixSchedule,
		numberOfCycles,
		tertiaryInjectionSample,
		quaternaryInjectionSample
	}=Lookup[
		nephelometryOptionsAssociation,
		{
			ReadOrder,
			PlateReaderMixSchedule,
			NumberOfCycles,
			TertiaryInjectionSample,
			QuaternaryInjectionSample
		}
	];

	(* Get our unique injection samples for download *)
	uniqueInjectionSamples=DeleteDuplicates[
		Download[
			Cases[
				Lookup[nephelometryOptionsAssociation,{PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample},Automatic],
				ObjectP[Object]
			],
			Object
		]
	];

	(* Get our unique blanks for download *)
	uniqueBlankSamples=DeleteDuplicates[Download[Cases[Lookup[nephelometryOptionsAssociation,Blank],ObjectP[Object]],Object]];

	(* Get the container we'll use for any aliquots - either the user's or we'll default to first compatible *)
	possibleAliquotContainers=Append[
		DeleteDuplicates[Cases[Flatten[Lookup[samplePrepOptions,AliquotContainer],1],ObjectP[]]],
		First[BMGCompatiblePlates[Nephelometry]]
	];


	(* ---------------------- *)
	(* -- DOWNLOAD SECTION -- *)
	(* ---------------------- *)

	(* replace Automatic with an empty list so the download works *)
	downloadAnalytes = Flatten[analyte/. Automatic->{}];

	(* pick out the fields to download from the analytes *)
	analyteFields={StandardCurves,IncubationTemperature,Molecule,MolecularWeight,Density};
	analyteFieldPacket=Packet@@analyteFields;
	standardCurveFields={StandardDataUnits};

	(* decide what to download *)
	samplePreparationPackets = Packet[SamplePreparationCacheFields[Object[Sample], Format->Sequence], IncompatibleMaterials, Well, Density];
	sampleModelPreparationPackets = Packet[Model[Flatten[{Deprecated, Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample]]}]]];
	containerPreparationPackets = Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], ModelName, MaxVolume, MinVolume, NumberOfWells, WellDiameter, WellDimensions, WellColor}]]];
	containerModelPreparationPackets = Packet[Container[Model][SamplePreparationCacheFields[Model[Container]]]];
	compositionPackets = Packet[Field[Composition[[All,2]][analyteFields]]];
	sampleAnalyteAllFields={
		Packet[Field[Composition[[All,2]][analyteFields]]],
		Packet[Field[Composition[[All,2]][StandardCurves][standardCurveFields]]]
	};

	(* Extract the packets that we need from our downloaded cache. *)
	{
		allSamplePackets,
		sampleAnalytePackets,
		listedInjectionSamplePackets,
		listedBlankPackets,
		listedAliquotContainerPackets,
		analytePacket
	}=Quiet[
		Download[
			{
				ToList[simulatedSamples],
				ToList[simulatedSamples],
				uniqueInjectionSamples,
				uniqueBlankSamples,
				possibleAliquotContainers,
				downloadAnalytes
			},
			Evaluate[{
				{
					samplePreparationPackets,
					sampleModelPreparationPackets,
					containerPreparationPackets,
					containerModelPreparationPackets,
					compositionPackets
				},
				sampleAnalyteAllFields,
				{Packet[IncompatibleMaterials, Well, RequestedResources, SamplePreparationCacheFields[Object[Sample], Format -> Sequence]]},
				{Packet[Container, State],Packet[Container[{Model}]],Packet[Container[Model][{MaxVolume}]]},
				{Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence], RecommendedFillVolume]},
				{analyteFieldPacket}
			}],
			Cache->cache,
			Simulation->updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];


	(*Extract the sample-related packets*)
	samplePackets=allSamplePackets[[All,1]];
	sampleModelPackets=allSamplePackets[[All,2]];
	sampleContainerPackets=allSamplePackets[[All,3]];
	sampleContainerModelPackets=allSamplePackets[[All,4]];
	sampleCompositionPackets=Cases[#, PacketP[]]&/@allSamplePackets[[All,5]];

	(* extract injection packets *)
	injectionSamplePackets=listedInjectionSamplePackets[[All,1]];

	(* extract blank packets *)
	blankSamplePackets=listedBlankPackets[[All,1]];
	blankContainerPackets=listedBlankPackets[[All,2]];

	(* extract aliquot model container packet *)
	aliquotContainerModelPacket = listedAliquotContainerPackets[[1,1]];


	(* Combine our downloaded and simulated cache. *)
	cacheBall=FlattenCachePackets[{
		allSamplePackets,
		sampleAnalytePackets,
		listedInjectionSamplePackets,
		listedBlankPackets,
		listedAliquotContainerPackets,
		analytePacket
	}];

	fastAssoc=makeFastAssocFromCache[cacheBall];

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)
	(*Determine if we are in Engine or not, in Engine we silence warnings*)
	notInEngine=!MatchQ[$ECLApplication,Engine];

	(*-----------INPUT VALIDATION CHECKS-----------*)

	(* Resolve our preparation option. *)
	preparationResult=Check[
		{allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
			{
				Experiment`Private`resolveReadPlateMethod[mySamples, myType, ReplaceRule[Normal@nephelometryOptionsAssociation, {Cache->cacheBall, Output->Result}], {Cache -> cacheBall, Output -> Result, Simulation -> simulation}],
				{}
			},
			Experiment`Private`resolveReadPlateMethod[mySamples, myType, ReplaceRule[Normal@nephelometryOptionsAssociation, {Cache->cacheBall, Output->{Result, Tests}}], {Cache -> cacheBall, Output -> {Result, Tests}, Simulation -> simulation}]
		],
		False
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation=If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* Resolve our WorkCell option. Do this after resolving the Preparation option, as this is only relevant if the experiment will be performed robotically.*)
	resolvedWorkCell = If[MatchQ[resolvedPreparation, Robotic],
		FirstOrDefault@Experiment`Private`resolveReadPlateWorkCell[experimentFunction,mySamples,ReplaceRule[Normal@nephelometryOptionsAssociation, {Cache->cacheBall, Preparation->resolvedPreparation}]],
		Null
	];

	(* ------- Validate Sampling options-------- *)
	(* - Check if SamplingDistance, SamplingDimension and SamplingPattern are compatible - *)

	(* SamplingPattern *)
	(* look up sampling distance and dimension. Replace samplingDimension with Automatic if it's not found aka its a kinetics experiment *)
	samplingDistance = Lookup[nephelometryOptionsAssociation,SamplingDistance];
	samplingDimension = Lookup[nephelometryOptionsAssociation,SamplingDimension,Automatic];

	(* If SamplingDistance is set to a value resolve to Ring somewhat arbitrarily - this is the first thing in BMG's dropdown *)
	resolvedSamplingPattern = Switch[{samplingPattern,samplingDistance,samplingDimension},
		{Except[Automatic],_,_},samplingPattern,
		{_,_,_Integer},Matrix,
		{_,DistanceP[],Null|Automatic},Ring,
		_,Center
	];

	(* Determine if the user set anything suggesting they actually want to do sampling *)
	samplingRequested = MemberQ[{samplingPattern,samplingDistance,samplingDimension},Except[Automatic]];

	(* SamplingDistance must be Null if using Center, can't be Null if using any other pattern *)
	(* SamplingDimension only applies to Matrix scans *)
	(* If at least 2 options are left Automatic then we can resolve the other appropriately *)
	validSamplingCombo = MatchQ[
		{samplingPattern,samplingDistance,samplingDimension},
		Alternatives[
			{Center,Null|Automatic,Null|Automatic},
			{Matrix,DistanceP|Automatic,Automatic|_Integer},
			{Except[Matrix,PlateReaderSamplingP],DistanceP,Automatic|Null},
			{Automatic,DistanceP,_Integer},
			{Automatic,DistanceP,Null},
			{Null,Null|Automatic,Null|Automatic},
			_?(Length[Cases[#,Automatic]]>=2&)
		]
	];

	(* Create test *)
	validSamplingComboTest=If[gatherTests,
		Test["A SamplingDistance is provided if and only if the SamplingPattern is set to Matrix, Ring or Spiral and SamplingDimension is only set if using a Matrix sampling pattern:",validSamplingCombo,True]
	];

	(* Throw message only if we are not gathering tests *)
	If[!validSamplingCombo&&!gatherTests,
		Message[Error::SamplingCombinationUnavailable]
	];

	(* --- Discarded samples check --- *)
	(* get the samples that are discarded *)
	discardedSamplePackets = Select[samplePackets, MatchQ[Lookup[#, Status], Discarded]&];

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
				Test["Provided input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[simulatedSamples],
				Nothing,
				(* this Download[simulatedSamples, Object] call can become just simulatedSamples once we guarantee that the ID is always returned and not the Name anymore *)
				Test["Provided input samples " <> ObjectToString[Complement[Download[simulatedSamples, Object], discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* SOLID SAMPLES ARE NOT OK *)

	(* Get the samples that are not liquids,cannot filter those *)
	nonLiquidSamplePackets=If[Not[MatchQ[Lookup[#, State], Alternatives[Liquid, Null]]],
		#,
		Nothing
	] & /@ samplePackets;

	(* Keep track of samples that are not liquid *)
	nonLiquidSampleInvalidInputs=If[MatchQ[nonLiquidSamplePackets,{}],{},Lookup[nonLiquidSamplePackets,Object]];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidSampleInvalidInputs]>0&&messages,
		Message[Error::NonLiquidSample,ObjectToString[nonLiquidSampleInvalidInputs,Cache->cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonLiquidSampleTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nonLiquidSampleInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[nonLiquidSampleInvalidInputs,Cache->cacheBall]<>" have a Liquid State:",True,False]
			];

			passingTest=If[Length[nonLiquidSampleInvalidInputs]==Length[samplePackets],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[Lookup[samplePackets,Object],nonLiquidSampleInvalidInputs],Cache->cacheBall]<>" have a Liquid State:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(* --- Check if the input samples have Deprecated inputs --- *)

	(* get all the model packets together that are going to be checked for whether they are deprecated *)
	(* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
	sampleModelPacketsToCheck = Cases[sampleModelPackets, PacketP[Model[Sample]]];

	(* get the samples that are deprecated; if on the FastTrack, don't bother checking *)
	deprecatedSampleModelPackets = If[Not[fastTrack],
		Select[sampleModelPacketsToCheck, TrueQ[Lookup[#, Deprecated]]&],
		{}
	];

	(*Set deprecatedInvalidInputs to the input objects whose models are Deprecated*)
	deprecatedInvalidInputs=If[MatchQ[deprecatedSampleModelPackets,{}],
		{},
		Lookup[deprecatedSampleModelPackets,Object]
	];

	(*If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs*)
	If[Length[deprecatedInvalidInputs]>0&&messages,
		Message[Error::DeprecatedModels,ObjectToString[deprecatedInvalidInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["Provided samples have models " <> ObjectToString[deprecatedInvalidInputs, Cache -> cacheBall] <> " that are not deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedInvalidInputs] == Length[sampleModelPacketsToCheck],
				Nothing,
				Test["Provided samples have models " <> ObjectToString[Download[Complement[sampleModelPacketsToCheck,deprecatedInvalidInputs], Object], Cache -> cacheBall] <> " that are not deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(*--PreparedPlate Container check--*)

	(* look up sample container model and object *)
	sampleContainerModel = If[NullQ[#], Null, Lookup[#, Model][Object]]& /@ sampleContainerPackets;
	sampleContainerObject = If[NullQ[#], Null, Lookup[#, Object]]& /@ sampleContainerPackets;

	(* check if sample container models are compatible with nephelometer *)
	compatiblePlateQ = AllTrue[MemberQ[BMGCompatiblePlates[Nephelometry],#]&/@sampleContainerModel,TrueQ];

	(* check if PreparedPlate -> True *)
	(* in this case, check that the samples are all in BMG compatible plates *)
	validPreparedPlateContainerQ = If[
		Or[(preparedPlate&&compatiblePlateQ),
			!preparedPlate
		],
		True,
		False
	];

	(* If prepared plate test fails, set the invalid inputs to samples in containers that are not BMG compatible *)
	incompatiblePlateModels = PickList[sampleContainerModel,MemberQ[BMGCompatiblePlates[Nephelometry],#]&/@sampleContainerModel,False];

	preparedPlateInvalidContainerInputs = If[!preparedPlate||compatiblePlateQ,
		{},
		PickList[ToList[mySamples],MemberQ[incompatiblePlateModels, #]&/@sampleContainerModel]
	];

	(* throw error if the prepared plate check is false *)
	If[!validPreparedPlateContainerQ&&messages,
		Message[Error::NephelometryPreparedPlateContainerInvalid]
	];

	(*If we are gathering tests, create a test for a prepared plate error*)
	validPreparedPlateContainerTest=If[gatherTests,
		Test["When PreparedPlate -> True, the input samples are all in plates that are compatible with the instrument:",
			validPreparedPlateContainerQ,
			True
		],
		Nothing
	];



	(* ----Compatible Materials check---- *)
	(*---Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument---*)
	{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[instrument,simulatedSamples,Output->{Result,Tests},Cache->cacheBall],
		{CompatibleMaterialsQ[instrument,simulatedSamples,Messages->messages,Cache->cacheBall],{}}
	];

	(*if the materials are incompatible, then the Instrument is invalid*)
	compatibleMaterialsInvalidOption=If[!compatibleMaterialsBool&&messages,
		{Instrument},
		{}
	];


	(*-- OPTION PRECISION CHECKS --*)
	(*Transform and round dilution curve options*)
	unroundedDilutionCurve = Lookup[nephelometryOptionsAssociation, DilutionCurve];

	(*make a list of associations*)
	separatedUnroundedDilutionCurve = Map[Association[DilutionCurve -> #] &, unroundedDilutionCurve];

	(*round each association*)
	{roundedDilutionCurveOption, dilutionPrecisionTests} = Transpose[If[gatherTests,
		MapThread[RoundOptionPrecision[#1, DilutionCurve, If[MatchQ[#2, {{VolumeP, VolumeP} ..}], {10^-1 Microliter, 10^-1 Microliter}, { 10^-1 Microliter, 10^-2}], Output -> {Result, Tests}]
			&,{separatedUnroundedDilutionCurve,unroundedDilutionCurve}],
		MapThread[{RoundOptionPrecision[#1, DilutionCurve, If[MatchQ[#2, {{VolumeP, VolumeP} ..}], {10^-1 Microliter, 10^-1 Microliter}, { 10^-1 Microliter, 10^-2}]],{}}&,
			{separatedUnroundedDilutionCurve,unroundedDilutionCurve}]
	]];

	(*put them back together*)
	roundedDilutionCurveOptions = Which[
		MatchQ[Flatten[Values[#], 1],{Automatic}], Automatic,
		MatchQ[Flatten[Values[#], 1],{Null}], Null,
		True,Flatten[Values[#], 1]] & /@ roundedDilutionCurveOption;

	(*get the unrounded serial dilution curve values*)
	unroundedSerialDilutionCurve = If[MatchQ[Lookup[nephelometryOptionsAssociation,SerialDilutionCurve],{VolumeP,VolumeP,_Integer}|Automatic|{VolumeP,{_Real,_Integer}}|{VolumeP,{_Real..}}],
		{Lookup[nephelometryOptionsAssociation,SerialDilutionCurve]},
		Lookup[nephelometryOptionsAssociation,SerialDilutionCurve]
	];

	(*round the volume portion of each curve*)
	roundedSerialDilutionCurveOptions = Which[
		MatchQ[#,Automatic|Null],#,

		MatchQ[#,{VolumeP, VolumeP, _Integer}],
		RoundOptionPrecision[<|SerialDilutionCurve->Most[#]|>, SerialDilutionCurve, 10^-1 Microliter];
		Join[{SafeRound[First[#],10^-1Microliter]},{SafeRound[#[[2]],10^-1Microliter]},{Last[#]}],

		True,
		RoundOptionPrecision[<|SerialDilutionCurve->First[#]|>, SerialDilutionCurve, 10^-1 Microliter];
		Join[{SafeRound[First[#],10^-1Microliter]},Rest[#]]
	]&/@unroundedSerialDilutionCurve;

	(*gather the tests*)
	serialDilutionPrecisionTests = Which[
		MatchQ[#,Automatic|Null],{},

		MatchQ[#,{VolumeP, VolumeP, _Integer}],
		If[gatherTests,
			Last[RoundOptionPrecision[<|SerialDilutionCurve->Most[#]|>, SerialDilutionCurve, 10^-1 Microliter,Output->{Result,Tests}]],
			{}],

		True,
		If[gatherTests,
			Last[RoundOptionPrecision[<|SerialDilutionCurve->First[#]|>, SerialDilutionCurve, 10^-1 Microliter,Output->{Result,Tests}]],
			{}]
	]&/@unroundedSerialDilutionCurve;


	(* list rounded nephelometry options *)
	roundedNephelometryOptionsList = {
		BeamAperture, BeamIntensity, Temperature, EquilibrationTime, TargetCarbonDioxideLevel, TargetOxygenLevel, AtmosphereEquilibrationTime,
		PlateReaderMixTime, PlateReaderMixRate, MoatVolume,
		SettlingTime, ReadStartTime, IntegrationTime,
		PrimaryInjectionVolume, SecondaryInjectionVolume, BlankVolume, SamplingDistance
	};

	(* list rounded kinetics options only *)
	roundedNephelometryKineticsOptionsList = {
		KineticWindowDurations, CycleTime, RunTime, TertiaryInjectionVolume, QuaternaryInjectionVolume,
		PrimaryInjectionTime, SecondaryInjectionTime, TertiaryInjectionTime, QuaternaryInjectionTime
	};

	(* list nephelometry precisions *)
	roundedNephelometryOptionsPrecisions = {
		10^-1 Millimeter,1 Percent, 1 Celsius, 1 Second, 10^-1 Percent, 10^-1 Percent, 1 Second,
		1 Second, 1 RPM, 1 Microliter,
		10^-1 Second, 10^-1 Second, 10^-2 Second,
		0.5 Microliter, 0.5 Microliter, 1 Microliter, 1 Millimeter
	};

	(* list kinetics only precisions *)
	roundedNephelometryKineticsOptionsPrecisions = {
		1 Second, 1 Second, 1 Second, 0.5 Microliter, 0.5 Microliter,
		1 Second, 1 Second, 1 Second, 1 Second
	};


	(* ensure that all the numerical options have the proper precision. only include kinetics specific options if in kinetics experiment *)
	{roundedNephelometryOptionsNoDilutions, precisionTestsNoDilutions} = If[gatherTests,
		RoundOptionPrecision[
			nephelometryOptionsAssociation,
			If[MatchQ[myType,Object[Protocol,Nephelometry]],roundedNephelometryOptionsList,Join[roundedNephelometryOptionsList,roundedNephelometryKineticsOptionsList]],
			If[MatchQ[myType,Object[Protocol,Nephelometry]],roundedNephelometryOptionsPrecisions,Join[roundedNephelometryOptionsPrecisions,roundedNephelometryKineticsOptionsPrecisions]],
			Output -> {Result, Tests}
		],
		{
			RoundOptionPrecision[
				nephelometryOptionsAssociation,
				If[MatchQ[myType,Object[Protocol,Nephelometry]],roundedNephelometryOptionsList,Join[roundedNephelometryOptionsList,roundedNephelometryKineticsOptionsList]],
				If[MatchQ[myType,Object[Protocol,Nephelometry]],roundedNephelometryOptionsPrecisions,Join[roundedNephelometryOptionsPrecisions,roundedNephelometryKineticsOptionsPrecisions]]
			],
			{}
		}
	];

	(*all the rounding together*)
	roundedNephelometryOptions = Join[
		roundedNephelometryOptionsNoDilutions,
		<|DilutionCurve->roundedDilutionCurveOptions|>,
		<|SerialDilutionCurve->roundedSerialDilutionCurveOptions|>
	];


	(* Join all tests together *)
	precisionTests = Join[
		precisionTestsNoDilutions,
		serialDilutionPrecisionTests,
		dilutionPrecisionTests
	];

	(*Pull out the rounded options*)
	{
		beamAperture, beamIntensity, temperature, equilibrationTime, targetCarbonDioxideLevel, targetOxygenLevel,
		plateReaderMixTime, plateReaderMixRate, moatVolume,
		settlingTime, readStartTime, integrationTime,
		primaryInjectionVolume, secondaryInjectionVolume, blankVolumes, samplingDistance,
		kineticWindowDurations, cycleTime, runTime, tertiaryInjectionVolume, quaternaryInjectionVolume,
		primaryInjectionTime, secondaryInjectionTime, tertiaryInjectionTime, quaternaryInjectionTime,
		suppliedDilutionCurve, suppliedSerialDilutionCurve
	}=Lookup[
		roundedNephelometryOptions,
		{
			BeamAperture, BeamIntensity, Temperature, EquilibrationTime, TargetCarbonDioxideLevel, TargetOxygenLevel,
			PlateReaderMixTime, PlateReaderMixRate, MoatVolume,
			SettlingTime, ReadStartTime, IntegrationTime,
			PrimaryInjectionVolume, SecondaryInjectionVolume, BlankVolume, SamplingDistance,
			KineticWindowDurations, CycleTime, RunTime, TertiaryInjectionVolume, QuaternaryInjectionVolume,
			PrimaryInjectionTime, SecondaryInjectionTime, TertiaryInjectionTime, QuaternaryInjectionTime,
			DilutionCurve, SerialDilutionCurve
		}
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* --- Make sure the Name isn't currently in use --- *)

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[name, _String],
		If[MatchQ[myType,Object[Protocol, Nephelometry]],
			Not[DatabaseMemberQ[Object[Protocol, Nephelometry, name]]],
			Not[DatabaseMemberQ[Object[Protocol, NephelometryKinetics, name]]]
		],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messages,
		(
			Message[Error::DuplicateName, If[MatchQ[myType,Object[Protocol, Nephelometry]],"Nephelometry protocol","NephelometryKinetics protocol"]];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name,_String],
		Test[If[
				MatchQ[myType,Object[Protocol, Nephelometry]],
				"If specified, Name is not already a Nephelometry object name:",
				"If specified, Name is not already a NephelometryKinetics object name:"
			],
			validNameQ,
			True
		],
		Null
	];


	(* --- Check to make sure there are no input samples in the Blank field *)

	(* make sure there are no blanks that are also samples *)
	(* note that in this case I am deliberately NOT using simulated samples since this depends on what the user specifies for the blanks vis a vis the samples they specify *)
	separateSamplesAndBlanksQ = If[MatchQ[Lookup[roundedNephelometryOptions, Blank], ListableP[Null | Automatic] | {}],
		True,
		ContainsNone[Lookup[blankSamplePackets,Object,{}], Lookup[samplePackets, Object]]
	];

	(* generate tests for cases where some of the specified samples are also the specified blanks *)
	blanksInvalidTest = If[gatherTests,
		{Test["None of the provided samples are also provided as a Blank:",
			separateSamplesAndBlanksQ,
			True
		]},
		Null
	];

	(* throw an error if SamplesIn are also appearing in Blank *)
	(* note that we are returning $Failed below because we need _something_ for the resolved options *)
	blanksInvalidOptions = If[Not[separateSamplesAndBlanksQ] && messages,
		(
			Message[Error::BlanksContainSamplesIn, ObjectToString[Select[Lookup[samplePackets, Object], MemberQ[Lookup[blankSamplePackets, Object], #]&],Cache->cacheBall]];
			{Blank}
		),
		{}
	];


	(* - Validate Injections x RetainCover - *)
	(* If there are any injections, RetainCover must be set to False - otherwise it can be set to anything *)
	anyInjectionsQ=MemberQ[Flatten[Lookup[nephelometryOptionsAssociation,{PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume}]],VolumeP];

	specifiedRetainCover=Lookup[nephelometryOptionsAssociation,RetainCover];
	validRetainCover=(anyInjectionsQ&&MatchQ[specifiedRetainCover,False])||(!anyInjectionsQ);

	(* Create test *)
	retainCoverTest=If[gatherTests,
		Test["If RetainCover is set to True, injections cannot be specified:",validRetainCover,True]
	];

	(* Throw message *)
	retainCoverInvalidOptions = If[Not[validRetainCover] && messages,
		(
			Message[Error::CoveredInjections];
			{RetainCover}
		),
		{}
	];


	(* Dilution curve error checks *)
	(* Check for two types of DilutionCurves *)
	conflictingDilutionCurve = MapThread[
		Function[{dilutionCurve,serialDilutionCurve,sampleObject},
			(* If both DilutionCurve and SerialDilutionCurve are specified to not Null, return the options that mismatch and the input for which they mismatch. *)
			If[MatchQ[dilutionCurve,Except[Null|Automatic]]&&MatchQ[serialDilutionCurve,Except[Null|Automatic]],
				{{dilutionCurve,serialDilutionCurve},sampleObject},
				Nothing
			]
		],
		{suppliedDilutionCurve,suppliedSerialDilutionCurve,simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{conflictingDilutionCurveOptions,conflictingDilutionCurveInputs}=If[MatchQ[conflictingDilutionCurve,{}],
		{{},{}},
		Transpose[conflictingDilutionCurve]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	conflictingDilutionCurveInvalidOptions=If[Length[conflictingDilutionCurveOptions]>0&&!gatherTests,
		Message[
			Error::NephelometryConflictingDilutionCurveTypes,
			First[#]&/@conflictingDilutionCurveOptions,Last[#]&/@conflictingDilutionCurveOptions,
			ObjectToString[conflictingDilutionCurveInputs,Cache->cacheBall]
		];
		{DilutionCurve, SerialDilutionCurve},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	conflictingDilutionCurveTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,conflictingDilutionCurveInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["If a DilutionCurve is specified, SerialDilutionCurve is not specified, for the inputs "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[conflictingDilutionCurveInputs]>0,
				Test["If a DilutionCurve is specified, SerialDilutionCurve is not specified, for the inputs "<>ObjectToString[conflictingDilutionCurveInputs,Cache->cacheBall]<>" :",True,False],
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

	(* Missing Diluent *)
	suppliedDiluent = Lookup[roundedNephelometryOptions,Diluent];

	missingDiluent = MapThread[
		Function[{dilutionCurve,serialdilutionCurve,diluent,sampleObject},
			(* If there is a dilution in DilutionCurve and Diluent is Null, return the options that mismatch and the input for which they mismatch. *)
			If[Or[MatchQ[dilutionCurve,Except[Null]],MatchQ[serialdilutionCurve,Except[Null]]]&&MatchQ[diluent,Null],
				{{dilutionCurve,serialdilutionCurve,diluent},sampleObject},
				Nothing
			]
		],
		{suppliedDilutionCurve,suppliedSerialDilutionCurve,suppliedDiluent,simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{missingDiluentOptions,missingDiluentInputs}=If[MatchQ[missingDiluent,{}],
		{{},{}},
		Transpose[missingDiluent]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	missingDiluentInvalidOptions = If[Length[missingDiluentOptions]>0&&!gatherTests,
		Message[
			Error::NephelometryMissingDiluent,
			Join[missingDiluentOptions[[All,1]],missingDiluentOptions[[All,2]]],missingDiluentOptions[[All,3]],
			ObjectToString[missingDiluentInputs,Cache->cacheBall]
		];
		{DilutionCurve,SerialDilutionCurve,Diluent},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	missingDiluentTest = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,missingDiluentInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["If a Dilution is specified, Diluent is not Null, for the inputs "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingDiluentInputs]>0,
				Test["If a Dilution is specified, Diluent is not Null, for the inputs "<>ObjectToString[missingDiluentInputs,Cache->cacheBall]<>" :",True,False],
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

	(* Missing Dilution Curve *)
	missingDilutionCurve = MapThread[
		Function[{dilutionCurve,serialdilutionCurve,diluent,sampleObject},
			(* If the Diluent is set and DilutionCurve is Null, return the options that mismatch and the input for which they mismatch. *)
			If[And[MatchQ[diluent,Except[Null]],MatchQ[dilutionCurve,Null],MatchQ[serialdilutionCurve,Null]],
				{{dilutionCurve,serialdilutionCurve,diluent},sampleObject},
				Nothing
			]
		],
		{suppliedDilutionCurve,suppliedSerialDilutionCurve,suppliedDiluent,simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{missingDilutionCurveOptions,missingDilutionCurveInputs}=If[MatchQ[missingDilutionCurve,{}],
		{{},{}},
		Transpose[missingDilutionCurve]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[missingDilutionCurveOptions]>0&&!gatherTests &&!MatchQ[$ECLApplication, Engine],
		Message[
			Error::NephelometryMissingDilutionCurve,
			Last[#]&/@missingDilutionCurveOptions,Most[#]&/@missingDilutionCurveOptions,
			ObjectToString[missingDilutionCurveInputs,Cache->cacheBall]
		]
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	missingDilutionCurveTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,missingDilutionCurveInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["If a Diluent is specified, DilutionCurve is not Null, for the inputs "<>ObjectToString[passingInputs,Cache->cacheBall]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[missingDilutionCurveInputs]>0,
				Test["If a Diluent is specified, DilutionCurve is not Null, for the inputs "<>ObjectToString[missingDilutionCurveInputs,Cache->cacheBall]<>" :",True,False],
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

	(* if there are any dilution errors, set a universal switch *)
	dilutionErrorsQ = If[Length[conflictingDilutionCurveOptions]>0||Length[missingDiluentOptions]>0||Length[missingDilutionCurveOptions]>0,True,False];


	(* Kinetics only- Check if CycleTime is longer than KineticWindowDurations if durations are not All *)
	(* total cycle time is CycleTime*NumberOfCycles *)
	zeroTimeNumberOfCycles = If[MatchQ[myType,Object[Protocol,NephelometryKinetics]]&&MatchQ[numberOfCycles,Except[ListableP[Automatic]]],
		Flatten[Append[{First[Flatten[{numberOfCycles}]]-1}, Rest[Flatten[{numberOfCycles}]]]],
		Nothing
	];

	totalCycleTime = If[MatchQ[myType,Object[Protocol,NephelometryKinetics]]&&MatchQ[cycleTime,Except[ListableP[Automatic]]]&&MatchQ[numberOfCycles,Except[ListableP[Automatic]]],
		MapThread[#1*#2&,{Flatten[{cycleTime}],zeroTimeNumberOfCycles}],
		Nothing
	];

	(* determine if the total cycle time is higher than the kineticWindowDurations *)
	cycleTimeTooHighErrors = If[
		MatchQ[myType,Object[Protocol, NephelometryKinetics]]&&AllTrue[Flatten[{TimeQ[kineticWindowDurations]}],TrueQ]&&MatchQ[cycleTime,Except[ListableP[Automatic]]],
		MapThread[
			If[#1>#2, True, False]&,
			{totalCycleTime/.Nothing->cycleTime,kineticWindowDurations}
		],
		{False}
	];

	(* generate tests for cases where CycleTimes are greater than KineticWindowDurations *)
	cycleTimeTooHighTest = If[gatherTests,
		{Test["None of the CycleTimes are higher than the corresponding KineticWindowDurations:",
			MemberQ[cycleTimeTooHighErrors,True],
			False
		]},
		Null
	];

	(* throw an error if CycleTime is higher than KineticWindowDurations *)
	cycleTimeTooHighOptions = If[MemberQ[cycleTimeTooHighErrors,True] && messages,
		(
			Message[Error::NephelometryKineticsCycleTimeTooLong,cycleTime,kineticWindowDurations,numberOfCycles];
			{CycleTime,KineticWindowDurations}
		),
		{}
	];


	(* Kinetics only- Check for more than 4 kinetic windows- no more than 4 allowed by instrument software *)
	tooManyKineticWindowsError = If[
		MatchQ[myType,Object[Protocol, NephelometryKinetics]],
		If[
			Length[kineticWindowDurations]>4,
			True,
			False
		],
		False
	];

	(* generate tests for cases where there are more than 4 KineticWindowDurations *)
	tooManyKineticWindowsTest = If[gatherTests,
		{Test["No more than 4 KineticWindowDurations are specified:",
			tooManyKineticWindowsError,
			False
		]},
		Null
	];

	(* throw an error if there are too many KineticWindowDurations *)
	tooManyKineticWindowsOptions = If[tooManyKineticWindowsError && messages,
		(
			Message[Error::NephelometryKineticsTooManyKineticWindowDurations];
			{KineticWindowDurations}
		),
		{}
	];


	(* Kinetics only- Check for more than 1000 cycles total, which is not allowed by instrument *)
	tooManyCyclesError = If[
		MatchQ[myType,Object[Protocol,NephelometryKinetics]]&&MatchQ[numberOfCycles,Except[Null|{}|ListableP[Automatic]]],
		If[
			Total[numberOfCycles]>1000,
			True,
			False
		],
		False
	];

	(* generate tests for cases where there are more than 1000 cycles *)
	tooManyCyclesTest = If[gatherTests,
		{Test["No more than 1000 cycles total are specified:",
			tooManyCyclesError,
			False
		]},
		Null
	];

	(* throw an error if CycleTime is higher than KineticWindowDurations *)
	tooManyCyclesOptions = If[tooManyCyclesError && messages,
		(
			Message[Error::NephelometryKineticsTooManyCycles,Total[numberOfCycles]];
			{NumberOfCycles}
		),
		{}
	];


	(* Kinetics only- Check for CycleTime and KineticWindowDurations timing mismatches *)
	(* CycleTime*NumberOfCycles must equal KineticWindowDurations to be valid *)
	validCycleTimingQ = If[
		And[
			MatchQ[myType,Object[Protocol, NephelometryKinetics]],
			MatchQ[numberOfCycles,Except[ListableP[Automatic]]],
			MatchQ[cycleTime,Except[ListableP[Automatic]]],
			MatchQ[kineticWindowDurations,Except[ListableP[All]]]
		],

		MapThread[Function[{numberOfCycles,cycleTime,kineticWindowDuration},
			If[Equal[cycleTime*numberOfCycles,kineticWindowDuration],True,False]],

			(* subtract 1 cycle from the first number of cycles to account for measurement at time 0 *)
			{Flatten[Append[{First[numberOfCycles]-1}, Rest[numberOfCycles]]],cycleTime,kineticWindowDurations}
		],

		{True}
	];

	(* check for errors *)
	cycleTimingError = If[
		MatchQ[myType,Object[Protocol, NephelometryKinetics]]&&!AllTrue[validCycleTimingQ,TrueQ],
		True,
		False
	];

	(* generate tests for cases where CycleTime*NumberOfCycles is not equal to KineticWindowDurations *)
	cycleTimingTest = If[gatherTests,
		{Test["CycleTime*NumberOfCycles must equal KineticWindowDurations if specified:",
			cycleTimingError,
			False
		]},
		Null
	];

	(* throw an error if CycleTime*NumberOfCycles is not equal to KineticWindowDurations *)
	cycleTimingOptions = If[cycleTimingError && messages,
		(
			Message[
				Error::NephelometryKineticsCycleTimingIncompatible,
				PickList[cycleTime,validCycleTimingQ],
				PickList[numberOfCycles,validCycleTimingQ],
				PickList[kineticWindowDurations,validCycleTimingQ]
			];
			{NumberOfCycles,CycleTime,KineticWindowDurations}
		),
		{}
	];


	(* Kinetics only- Check that RunTime=Total[KineticWindowDurations] *)
	runTimeKineticWindowError = If[
		MatchQ[myType,Object[Protocol, NephelometryKinetics]]&&MatchQ[kineticWindowDurations,Except[ListableP[All]]]&&TimeQ[runTime],
		If[
			Total[kineticWindowDurations]==runTime,
			False,
			True
		],
		False
	];

	(* generate tests for cases where RunTime!=Total[KineticWindowDurations] *)
	runTimeKineticWindowTest = If[gatherTests,
		{Test["RunTime is equal to the total time of the KineticWindowDurations if specified:",
			runTimeKineticWindowError,
			False
		]},
		Null
	];

	(* throw an error if RunTime!=Total[KineticWindowDurations] *)
	runTimeKineticWindowOptions = If[runTimeKineticWindowError && messages,
		(
			Message[Error::NephelometryKineticsRunTimeIncompatible,Total[kineticWindowDurations],runTime];
			{RunTime,KineticWindowDurations}
		),
		{}
	];

	kineticWindowTimingsErrors = runTimeKineticWindowError||cycleTimingError||tooManyCyclesError||tooManyKineticWindowsError||MemberQ[cycleTimeTooHighErrors,True];


	(* - Validate PlateReaderMix options - *)
	(* Do checks for BMG plate reader mixing, use helper function in FluorescenceIntensity *)
	{plateReaderMixOptionInvalidities,plateReaderMixTests}=If[gatherTests,
		validPlateReaderMixing[experimentFunction,nephelometryOptionsAssociation,Output->{Options,Tests}],
		{validPlateReaderMixing[experimentFunction,nephelometryOptionsAssociation,Output->Options],{}}
	];


	(*--PreparedPlate Invalid Options--*)
	{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume} = Lookup[nephelometryOptionsAssociation,{MoatSize,MoatBuffer,MoatVolume}];

	(* check if DilutionCurve, SerialDilutionCurve, Diluent, Moats, or BlankVolumes were specified.
	   In this situation, PreparedPlate should be left as Automatic or set to False *)
	validPreparedPlateOptionsQ=If[
		Or[
			MatchQ[preparedPlate,False],
			(
				MatchQ[preparedPlate,Automatic|True] &&
				MatchQ[suppliedDiluent,ListableP[Null]|ListableP[Automatic]] &&
        		MatchQ[suppliedDilutionCurve,ListableP[Null]|ListableP[Automatic]] &&
            	MatchQ[suppliedSerialDilutionCurve,ListableP[Null]|ListableP[Automatic]] &&
              	MatchQ[blankVolumes,ListableP[Null]|ListableP[Automatic]] &&
			    AllTrue[MatchQ[#,Alternatives[Null,Automatic]]& /@{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume},TrueQ]
			)
		],
		True,
		False
	];

	invalidBlankVolumes = PickList[blankVolumes,MemberQ[#,Except[Null|Automatic]]&/@blankVolumes];
	invalidDiluents = PickList[suppliedDiluent,MemberQ[#,Except[Null|Automatic]]&/@suppliedDiluent];
	invalidDilutionCurves = PickList[suppliedDilutionCurve,MemberQ[#,Except[Null|Automatic]]&/@suppliedDilutionCurve];
	invalidSerialDilutionCurves = PickList[suppliedSerialDilutionCurve,MemberQ[#,Except[Null|Automatic]]&/@suppliedSerialDilutionCurve];
	invalidMoats = PickList[{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume},MatchQ[#,Except[Null|Automatic]]&/@{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume}];

	(* If prepared plate test fails, treat all of the input samples as invalid *)
	preparedPlateInvalidOptions = If[!validPreparedPlateOptionsQ,
		Join[invalidBlankVolumes,invalidDiluents,invalidDilutionCurves,invalidSerialDilutionCurves,invalidMoats],
		{}
	];

	(* throw error if the prepared plate check is false *)
	If[!validPreparedPlateOptionsQ&&messages,
		Message[Error::NephelometryPreparedPlateInvalidOptions]
	];

	(*If we are gathering tests, create a test for a prepared plate error*)
	validPreparedPlateTest=If[gatherTests,
		Test["When PreparedPlate -> True, Dilution options, Moat options, and BlankVolume are not specified:",
			validPreparedPlateOptionsQ,
			True
		],
		Nothing
	];

	(* --- Independent option resolution --- *)

	(* Resolve TargetCarbonDioxideLevel *)
	{{resolvedACUOptions, resolvedACUInvalidOptions}, resolvedACUTests} = If[gatherTests,
		resolveACUOptions[
			myType,
			simulatedSamples,
			Association[roundedNephelometryOptions,
				{
					Cache -> cacheBall,
					Simulation -> updatedSimulation,
					Output -> {Result, Tests}
				}
			]
		],
		{
			resolveACUOptions[
				myType,
				simulatedSamples,
				Association[roundedNephelometryOptions,
					{
						Cache -> cacheBall,
						Simulation -> updatedSimulation,
						Output -> Result
					}
				]
			],
			{}
		}
	];

	(* KINETICS ONLY *)
	(* Resolve RunTime, KineticWindowDurations, CycleTime, and NumberOfCycles *)
	resolvedRunTime = If[MatchQ[myType,Object[Protocol,NephelometryKinetics]],
		Which[
			(* If RunTime is specified, accept it. Error checking for timing is done previously *)
			MatchQ[runTime,Except[Automatic]],runTime,
			(* If RunTime is Automatic and KineticWindowDurations is not All, set to the total time of durations *)
			MatchQ[runTime,Automatic]&&MatchQ[kineticWindowDurations,Except[All]],Total[kineticWindowDurations],
			(* If RunTime is Automatic and CycleTime and NumberOfCycles is set, total the CycleTime times the NumberOfCycles *)
			MatchQ[runTime,Automatic]&&MatchQ[cycleTime,Except[ListableP[Automatic]]]&&MatchQ[numberOfCycles,Except[ListableP[Automatic]]],Total[MapThread[#1*#2&,{cycleTime,numberOfCycles}]],
			(* If RunTime is Automatic and CycleTime is set but NumberOfCycles is Automatic, total the CycleTime times 20 which is the default NumberOfCycles *)
			MatchQ[runTime,Automatic]&&MatchQ[cycleTime,Except[ListableP[Automatic]]],Total[ToList[cycleTime]*20],
			(* If no timings are set, default to 1 hour *)
			True,1 Hour
		],
		Nothing
	];

	resolvedKineticWindowDurations = If[MatchQ[myType,Object[Protocol,NephelometryKinetics]],
		Which[
			(* If kineticWindowDurations is specified, accept it. Error checking for timing is done previously *)
			MatchQ[kineticWindowDurations,Except[All]],kineticWindowDurations,
			(* If KineticWindowDurations is All, set to the resolvedRunTime *)
			MatchQ[kineticWindowDurations,All],{resolvedRunTime},
			(* If no timings are set, default to 1 hour *)
			True, {1 Hour}
		],
		Nothing
	];

	listedCycleTime = If[MatchQ[cycleTime,Automatic],
		Automatic/.Automatic->ConstantArray[Automatic,Length[resolvedKineticWindowDurations]],
		Flatten[{cycleTime}]
	];

	listedNumberOfCycles = If[MatchQ[numberOfCycles,Automatic],
		Automatic/.Automatic->ConstantArray[Automatic,Length[resolvedKineticWindowDurations]],
		Flatten[{numberOfCycles}]
	];

	resolvedCycleTimes = If[MatchQ[myType,Object[Protocol,NephelometryKinetics]]&&!kineticWindowTimingsErrors,
		MapThread[
			Function[{cycleTime,numberOfCycles,kineticWindowDuration},
				Which[
					(* If CycleTime is specified, accept it. Error checking for timing is done previously *)
					MatchQ[cycleTime,Except[Automatic]],cycleTime,
					(* If CycleTime is Automatic and NumberOfCycles is specified, calculate the CycleTime needed to meet the duration *)
					MatchQ[cycleTime,Automatic]&&MatchQ[numberOfCycles,Except[Automatic]],SafeRound[kineticWindowDuration/numberOfCycles,1Second],
					(* If CycleTime is Automatic and KineticWindowDurations is less than 1 hour, set to 60 Second *)
					MatchQ[cycleTime,Automatic]&&Less[kineticWindowDuration,1 Hour],60 Second,
					(* If CycleTime is Automatic and KineticWindowDurations is greater than 1 hour, set to 300 Second *)
					MatchQ[cycleTime,Automatic]&&GreaterEqual[kineticWindowDuration,1 Hour],300 Second,
					(* If no timings are set, default to 1 minute *)
					True,60 Second
				]],
			{listedCycleTime,listedNumberOfCycles,resolvedKineticWindowDurations}
		],
		Nothing
	];

	calculatedNumberOfCycles = If[MatchQ[myType,Object[Protocol,NephelometryKinetics]]&&!kineticWindowTimingsErrors,
		MapThread[
			Function[{numberOfCycles,cycleTime,kineticWindowDuration},
				Which[
					(* If NumberOfCycles is specified, accept it. Error checking for timing is done previously *)
					MatchQ[numberOfCycles,Except[Automatic]],numberOfCycles,
					(* If NumberOfCycles is Automatic, calculate the NumberOfCycles needed to meet the time *)
					MatchQ[numberOfCycles,Automatic],Round[kineticWindowDuration/cycleTime],
					(* If no timings are set, default to 20 *)
					True,20
				]],
				{listedNumberOfCycles,resolvedCycleTimes,resolvedKineticWindowDurations}
			],
		Nothing
	];

	(* Add 1 to the first number of the list of NumberOfCycles to account for the measurement at time 0 if it wasn't specified already *)
	resolvedNumberOfCycles = If[MatchQ[myType,Object[Protocol,NephelometryKinetics]]&&!kineticWindowTimingsErrors,
		If[MatchQ[listedNumberOfCycles,Except[ListableP[Automatic]]],calculatedNumberOfCycles,Flatten[Append[{First[calculatedNumberOfCycles]+1}, Rest[calculatedNumberOfCycles]]]],
		Nothing
	];



	 (* -- Resolve Plate Reader Mixing options -- *)
	(* look up rounded options *)
	{roundedMixRate,roundedMixTime} = Lookup[roundedNephelometryOptions,{PlateReaderMixRate,PlateReaderMixTime}];

	mixOptions = If[MatchQ[experimentMode,Nephelometry],
		{roundedMixRate,roundedMixTime,plateReaderMixMode},
		{roundedMixRate,roundedMixTime,plateReaderMixMode,plateReaderMixSchedule}
	];

	resolvedPlateReaderMix=Which[
		MatchQ[plateReaderMix,BooleanP],plateReaderMix,
		MemberQ[mixOptions,Except[Automatic|Null]],True,
		True,False
	];

	(* - Resolve PlateReaderMix Parameters - *)
	(* Mixing defaults for automatic resolution *)
	defaultMixingRate=700 RPM;
	defaultMixingTime=30 Second;
	defaultMixingMode=DoubleOrbital;
	defaultMixingSchedule=If[anyInjectionsQ,
		AfterInjections,
		If[MatchQ[Lookup[nephelometryOptionsAssociation,ReadOrder,Null],Serial],
			BeforeReadings,(* In Serial mode mixing is only allowed before reads begin *)
			BetweenReadings
		]
	];

	(* If we're mixing replace Automatics with defaults, otherwise replace with Null *)
	{resolvedPlateReaderMixRate,resolvedPlateReaderMixTime,resolvedPlateReaderMixMode,resolvedPlateReaderMixSchedule}=If[resolvedPlateReaderMix,
		{
			Replace[roundedMixRate,Automatic->defaultMixingRate],
			Replace[roundedMixTime,Automatic->defaultMixingTime],
			Replace[plateReaderMixMode,Automatic->defaultMixingMode],
			Replace[plateReaderMixSchedule,Automatic->defaultMixingSchedule]
		},
		{
			Replace[roundedMixRate,Automatic->Null],
			Replace[roundedMixTime,Automatic->Null],
			Replace[plateReaderMixMode,Automatic->Null],
			Replace[plateReaderMixSchedule,Automatic->Null]
		}
	];


	(* - Resolve InjectionFlowRate Option - *)
	(* Defaults to Null as Tertiary/Quaternary injections are not available for non-kinetics experiments. *)
	{suppliedPrimaryFlowRate,suppliedSecondaryFlowRate,suppliedTertiaryFlowRate,suppliedQuaternaryFlowRate}=Lookup[nephelometryOptionsAssociation,{PrimaryInjectionFlowRate,SecondaryInjectionFlowRate,TertiaryInjectionFlowRate,QuaternaryInjectionFlowRate},Null];

	{primaryInjectionsQ,secondaryInjectionQ,tertiaryInjectionQ,quaternaryInjectionQ}=Map[
		MemberQ[Lookup[nephelometryOptionsAssociation,#,{}],VolumeP]&,
		{PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume}
	];

	(* Default to 300uL/s if we're injecting, Null if we're not *)
	{resolvedPrimaryFlowRate,resolvedSecondaryFlowRate,resolvedTertiaryFlowRate,resolvedQuaternaryFlowRate}=MapThread[
		Which[
			MatchQ[#1,Automatic]&&TrueQ[#2],300 Microliter/Second,
			MatchQ[#1,Automatic]&&!TrueQ[#2],Null,
			True,#1
		]&,
		{{suppliedPrimaryFlowRate,suppliedSecondaryFlowRate,suppliedTertiaryFlowRate,suppliedQuaternaryFlowRate},{primaryInjectionsQ,secondaryInjectionQ,tertiaryInjectionQ,quaternaryInjectionQ}}
	];


	(* - Pre-resolve Aliquot Options - *)

	(* Lookup relevant options *)
	{suppliedAliquotBooleans,suppliedAliquotVolumes,suppliedAssayVolumes,suppliedTargetConcentrations,suppliedAssayBuffers,suppliedAliquotContainers, suppliedConsolidateAliquots}=Lookup[
		samplePrepOptions,
		{Aliquot,AliquotAmount,AssayVolume,TargetConcentration,AssayBuffer,AliquotContainer, ConsolidateAliquots}
	];

	(* Determine if all the core aliquot options are left automatic for a given sample (note that although we pulled out ConsolidateAliquots above, that does NOT count as a core aliquot option and isn't checked here) *)
	(* If no aliquot options are specified for a sample we want to be able to warn that it will be aliquoted if that comes up *)
	automaticAliquotingBooleans=MapThread[
		Function[{aliquot,aliquotVolume,assayVolume,targetConcentration,assayBuffer,aliquotContainer},
			MatchQ[{aliquot,assayVolume,aliquotVolume,targetConcentration,assayBuffer,aliquotContainer},{Automatic..}]
		],
		{suppliedAliquotBooleans,suppliedAliquotVolumes,suppliedAssayVolumes,suppliedTargetConcentrations,suppliedAssayBuffers,suppliedAliquotContainers}
	];

	(* -- Gather potential errors, then throw a single message -- *)

	(* - Check source container count - *)
	(* Number of simulated sample containers *)
	uniqueContainers=DeleteDuplicates[sampleContainerPackets];

	(* - Check aliquot container count - *)
	(* Get the number of unique aliquot containers requested *)
	(* Convert any links/names to objects for fair comparison *)
	numberOfAliquotContainers=Length[
		DeleteCases[
			DeleteDuplicates[
				Replace[suppliedAliquotContainers,{{id_Integer,object:ObjectP[]}:>{id,Download[object,Object]},object:ObjectP[]:>Download[object,Object]},{1}]
			],
			Automatic
		]
	];

	(* If we're aliquoting some samples we can go wrong is if:
		Aliquot->False for some samples, Aliquot->True for others (or something like AliquotAmount->Null, but we'll ignore and use error thrown by resolveAliquotOptions when we send in Aliquot->True)
		If AliquotContainer -> multiple distinct containers
		If there are multiple unique containers and Aliquot->False in some cases
	*)
	tooManyAliquotContainers=Or[
		(* If user is specifying aliquots they can only request a single unique container *)
		Length[numberOfAliquotContainers]>1,

		(* Can't request some sample be aliquoted and others not *)
		MemberQ[suppliedAliquotBooleans,True]&&MemberQ[suppliedAliquotBooleans,False],

		(* If we have more than one container in play then some things are set to be aliquoted or there are multiple sources *)
		(* In either case these then means everything must be aliquoted *)
		MemberQ[suppliedAliquotBooleans,False]&&Length[uniqueContainers]>1
	];

	(* - Check Aliquot and NumberOfReplicates for a conflict - *)
	(* We're interpreting N NumberOfReplicates to mean we should read N aliquots of each sample, so Aliquot must be set to True if we're doing replicates on the BMG *)

	(* Must be aliquoting if we're doing replicates on a BMG reader *)
	(* Warn them if there are any samples which don't have any aliquoting info specified *)
	replicateAliquotsRequired=!MatchQ[numberOfReplicates,Null|Automatic];
	replicatesError=MemberQ[suppliedAliquotBooleans,False]&&replicateAliquotsRequired;
	replicatesWarning=MemberQ[automaticAliquotingBooleans,True]&&!replicatesError&&replicateAliquotsRequired;


	(* - Check Aliquot and Sample Repeats for a conflict - *)
	(* Must be aliquoting if we have repeated samples on a BMG reader *)

	sampleRepeatAliquotsRequired=!DuplicateFreeQ[Lookup[samplePackets,Object]];
	sampleRepeatError=MemberQ[suppliedAliquotBooleans,False]&&sampleRepeatAliquotsRequired;
	sampleRepeatWarning=MemberQ[automaticAliquotingBooleans,True]&&!sampleRepeatError&&sampleRepeatAliquotsRequired;

	(* Since we can only put one container into the plate reader everything must be in a single supported plate or we will need to aliquot all samples *)
	(* RequiredAliquotContainer will throw message if there's a problem with that container *)
	(* Moat, replicates and repeated samples also all require us to create aliquots with current set-up *)
	(* if dilutions are happening, don't bother throwing errors since samples will be transferred to a new plate anyway *)
	bmgAliquotRequired = If[Or[
			(* dilutions are happening *)
			!NullQ[suppliedDiluent],
			MemberQ[suppliedDilutionCurve,Except[Null|Automatic]],
			MemberQ[suppliedDilutionCurve,Except[Null|Automatic]],
			(* dilutions are required for CellCountParameterizaton method *)
			MatchQ[resolvedMethod,CellCount]
		],
		False,
		Or[
			sampleRepeatAliquotsRequired,
			replicateAliquotsRequired,
			(*because invalidMoatOptions is not generated at this point for impliedMoat, we use MemberQ[{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume},Except[Null|Automatic]] to skip the moat error checking.*)
			(*impliedMoat*)
			MemberQ[{specifiedMoatSize,specifiedMoatBuffer,specifiedMoatVolume},Except[Null|Automatic]]
		]
	];

	(* - Validate we have enough space for our blanks - *)

	(* Get the specified options *)
	{specifiedBlanks,specifiedBlankVolumes}=Lookup[roundedNephelometryOptions,{Blank,BlankVolume}];

	(* convert numberOfReplicates such that Null|Automatic -> 1 *)
	(* We'll assume this for now but resolve to 3 for quantification runs if we find we have enough space after blank resolution *)
	preresolvedNumReplicates=numberOfReplicates/.{(Null|Automatic)->1};

	(* Figure out how many blanks will need to be moved *)
	(* We'll move any sample with BlankVolume specified (and throw an error below if blank needs to move and Volume->Null) *)
	blanksWithVolumesToMove=MapThread[
		Function[{blank,blankVolume,samplePacket},
			Module[{blankPacket,blankContainer},
				(* Find the sample packet for our blank, then get its container *)
				blankPacket=SelectFirst[blankSamplePackets,MatchQ[Lookup[#,Object],ObjectP[blank]]&,<||>];
				blankContainer=Lookup[blankPacket,Container];

				(* Count as needing transfer if a volume has been specified or if left Automatic and we detect transfer is needed *)
				Which[
					MatchQ[blankMeasurement,False],Nothing,
					MatchQ[blankVolume,VolumeP],{blank,blankVolume},
					(MatchQ[blankVolume,Automatic]&&(!MatchQ[First[sampleContainerPackets],ObjectP[blankContainer]]||bmgAliquotRequired)),{blank,Min[Cases[{Lookup[samplePacket,Volume],300*Microliter}, VolumeP]]},
					True,Nothing
				]
			]
		],
		{specifiedBlanks,specifiedBlankVolumes,samplePackets}
	];

	(* We also make replicates for blanks so account for this in our total *)
	numberOfTransferBlanks=preresolvedNumReplicates*Length[DeleteDuplicates[blanksWithVolumesToMove]];

	(* Create tests but wait to throw our messages until we've done some final error checking post resolution *)
	replicatesAliquotTest=If[gatherTests,
		Test["If replicate readings are to be done, the samples may be aliquoted in order to create replicate samples for these readings:",replicatesError,False]
	];

	sampleRepeatTest=If[gatherTests,
		Test["If any samples are repeated in the input then they are set to be aliquoted since repeat readings are performed on aliquots of the input samples:",sampleRepeatError,False]
	];

	invalidAliquotOption=If[replicatesError||sampleRepeatError,
		Aliquot,
		{}
	];

	(* Aliquot if we have to make replicate samples *)
	blankAliquotRequired = replicateAliquotsRequired;

	(* --- Resolve the index matched options --- *)

	(* MapThread the options so that we can do our big MapThread *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[experimentFunction,Normal[roundedNephelometryOptions]];

	(* decide the potential analytes to use; specifying the Analyte here will pre-empt warnings thrown by this function *)
	{resolvedAnalytes, resolvedAnalyteTests} = If[gatherTests,
		Experiment`Private`selectAnalyteFromSample[samplePackets, Analyte -> Lookup[nephelometryOptionsAssociation, Analyte], Cache -> cacheBall, Output -> {Result, Tests}],
		{Experiment`Private`selectAnalyteFromSample[samplePackets, Analyte -> Lookup[nephelometryOptionsAssociation, Analyte], Cache -> cacheBall, Output -> Result], Null}
	];

	(* get the packets for our resolved analytes *)
	analytePackets = (fetchPacketFromFastAssoc[#, fastAssoc]&)/@resolvedAnalytes;

	(* ----Resolve Method---- *)
	(* do we have any cell analytes? *)
	analyteCellTypeQ = MemberQ[analytePackets,ObjectP[Model[Cell]]];

	(* are we missing any standard curves that relate neph (RFU) <-> Cells/mL in our analyte objects? *)
	missingStandardCurveBools=Map[
		Function[{analytePacket},
			Or[
				!MatchQ[analytePacket, PacketP[Model[Cell]]],
				!MemberQ[fastAssocLookup[fastAssoc, analytePacket, {StandardCurves, StandardDataUnits}], {UnitsP[RelativeNephelometricUnit], UnitsP[Cell/Milliliter]}]
			]
		],
		analytePackets
	];

	(* resolve Method *)
	resolvedMethod = Which[
		(* if there are no samples that are cells, Method cannot be CellCount *)
		!MatchQ[method,Automatic],
			method,
		(* if no sample types are cells, set to Solubility *)
		!analyteCellTypeQ,
			Solubility,
		(* if any samples are cells and any samples do not have StandardCurve informed, set to Solubility *)
		analyteCellTypeQ&&Or@@missingStandardCurveBools,
			Solubility,
		(* If we have cells and all of them have standard curves that relate RFUs -> Cell/mL, then we don't need to do parameterization. *)
		True,
			CellCount
	];

	(* noStandardCurveQ checking *)
	(* check if Method->CellCount but the analyte does not have StandardCurve informed *)
	noStandardCurveQ=MatchQ[method, CellCount] && Or@@missingStandardCurveBools;

	(* generate tests if there are any methodInvalidErrors *)
	noStandardCurveTest = If[gatherTests,
		{Test["If Method->CellCount, all Analytes must be Model[Cell]s with StandardCurves that relate RNU to Cell/mL (otherwise, call ExperimentQuantifyCells to first acquire the standard curve):",
			noStandardCurveQ,
			False
		]},
		Null
	];

	(* if noStandardCurveQ=True, throw error and find Analytes with StandardCurve not informed *)
	noStandardCurveInvalidOptions = If[noStandardCurveQ && messages,
		Message[Error::NephelometryNoStandardCurve, ObjectToString[PickList[simulatedSamples,missingStandardCurveBools],Cache->cacheBall]];
		{Analyte,Method},
		{}
	];

	(* nonCellAnalyteQ checking *)
	(* check if Method->CellCount but the analyte does not have StandardCurve informed *)
	nonCellAnalyteQ=MatchQ[method, CellCount] && MemberQ[resolvedAnalytes, Except[ObjectP[Model[Cell]]]];

	(* generate tests if there are any methodInvalidErrors *)
	nonCellAnalyteTest = If[gatherTests,
		{Test["When Method is set to CellCount, the sample's Analyte must be a Model[Cell]:",
			nonCellAnalyteQ,
			False
		]},
		Null
	];

	(* if noStandardCurveQ=True, throw error and find Analytes with StandardCurve not informed *)
	nonCellAnalyteInvalidOptions = If[nonCellAnalyteQ && messages,
		Message[Error::NephelometryNonCellAnalyte, ObjectToString[PickList[simulatedSamples,missingStandardCurveBools],Cache->cacheBall]];
		{Analyte,Method},
		{}
	];

	(* ----Resolve BeamIntensity---- *)
	(* look up the rounded beam intensity *)
	roundedBeamIntensity = Lookup[roundedNephelometryOptions,BeamIntensity];

	(* resolve beam intensity based on Method *)
	resolvedBeamIntensity = Which[
		(* if a beam intensity is specified, accept it *)
		MatchQ[roundedBeamIntensity,PercentP],roundedBeamIntensity,
		(* if automatic, if Method is Solubility, set to 80% *)
		MatchQ[resolvedMethod,Solubility]&&MatchQ[roundedBeamIntensity,Automatic],80 Percent,
		(* if automatic, if Method is CellCount, set to 10% *)
		MatchQ[resolvedMethod,CellCount]&&MatchQ[roundedBeamIntensity,Automatic],10 Percent,
		True,10 Percent
	];

	(* ----Resolve Temperature---- *)
	(* get the rounded temperature value *)
	roundedTemperature = Lookup[roundedNephelometryOptions,Temperature];

	(* look up the incubation temperatures from the analyte packets *)
	incubationTemperaturesFromPackets = If[NullQ[analytePackets],
		Null,
		Flatten[Lookup[#,IncubationTemperature]&/@analytePackets]
	];

	incubationTemperaturesMean = If[
		MatchQ[Mean[incubationTemperaturesFromPackets],_Real],
		SafeRound[Mean[incubationTemperaturesFromPackets],1Celsius],
		37 Celsius
	];

	incubationTemperature = If[analyteCellTypeQ,incubationTemperaturesMean,$AmbientTemperature];

	(* get the resolved temperature based on the IncubationTemperature of the sample analyte *)
	resolvedTemperature=Which[
		MatchQ[roundedTemperature,Except[Automatic]],roundedTemperature/.(Null|Ambient->Null),
		MatchQ[roundedTemperature,Automatic]&&MatchQ[resolvedMethod,Solubility],$AmbientTemperature,
		MatchQ[roundedTemperature,Automatic]&&MatchQ[resolvedMethod,Alternatives[CellCount]],incubationTemperature,
		True,$AmbientTemperature
	];

	(* get the rounded temperature equilibrium time value *)
	roundedEquilibrationTime = Lookup[roundedNephelometryOptions,EquilibrationTime];

	(* get the resolved temperature equilibrium time *)
	resolvedTemperatureEquilibriumTime = Which[
		MatchQ[roundedEquilibrationTime,Except[Automatic]],roundedEquilibrationTime,
		MatchQ[roundedEquilibrationTime,Automatic]&&MatchQ[resolvedTemperature,GreaterP[$AmbientTemperature]],5*Minute,
		MatchQ[roundedEquilibrationTime,Automatic],0*Minute,
		True,roundedEquilibrationTime
	];

	(* Check if Temperature is specified but EquilibrationTime was specified zero. Need to warn the user that there might be fluctuations. *)
	plateReaderTemperatureNoEquilibrationWarning = If[And[
		MatchQ[resolvedTemperature,GreaterP[$AmbientTemperature]],
		EqualQ[resolvedTemperatureEquilibriumTime, 0 Minute]],
		True,
		False
	];

	(* Throw message *)
	If[TrueQ[plateReaderTemperatureNoEquilibrationWarning]&&messages&&notInEngine,
		Message[Warning::TemperatureNoEquilibration, resolvedTemperature, resolvedTemperatureEquilibriumTime]
	];

	(*If we are gathering tests, create a test for Quantification and Method mismatch*)
	plateReaderTemperatureNoEquilibrationTest=If[gatherTests,
		Test["If Temperature is Solubility, EquilibriumTime is above 0 Minute:",
			plateReaderTemperatureNoEquilibrationWarning,
			False
		],
		Nothing
	];


	(* update map thread options *)
	updatedMapThreadFriendlyOptions = MapThread[
		Function[{optionSet,analyte},
			(* update the options and make sure they are an association*)
			Association@@ReplaceRule[Normal[optionSet], {Analyte -> analyte, Method -> resolvedMethod, BeamIntensity->resolvedBeamIntensity, Temperature->resolvedTemperature, EquilibrationTime->resolvedTemperatureEquilibriumTime}]
		],
		{mapThreadFriendlyOptions,resolvedAnalytes}
	];


	(* get the valid container models that can be used with this experiment *)
	validPlateModelsList = BMGCompatiblePlates[Nephelometry];

	(* MapThread *)
	{
		resolvedOptionsPackets,
		resolvedMapThreadErrorTrackerPackets
	}=Transpose[MapThread[
		Function[{samplePacket,containerPacket,compositionPackets,resolvedAnalyte,options},
			Module[
				{
					(* errors *)
					incompatibleBlankOptionsError, sampleContainsAnalyteError,
					blankContainerError, blankContainerWarning, methodQuantificationMismatchError, analyteMissingError,

					(* specified options *)
					specifiedQuantifyCellCount, specifiedMethod,
					blankMeasurement, specifiedBlank, specifiedBlankVolume,
					specifiedDiluent, specifiedDilutionCurve, specifiedSerialDilutionCurve,

					(* resolve options *)
					resolvedQuantifyCellCount, resolvedBlank,analytePacket, solvent,
					blankSamplePacket,blankContainerPacket,badBlankContainer,containerMaxVolume,containerRecommendedVolume, resolvedBlankVolume,
					bestInitialGuessBlankContainerModel,bestGuessBlankContainerModel,
					resolvedDiluent, resolvedSerialDilutionCurve, resolvedDilutionCurve,

					(* output packets *)
					resolvedOptionsPacket, mapThreadErrorTrackerPacket
				},

				(*Initialize the error-tracking variables*)
				{
					methodQuantificationMismatchError,
					analyteMissingError,
					sampleContainsAnalyteError,
					incompatibleBlankOptionsError,
					blankContainerError,
					blankContainerWarning
				} = {False, False, False, False, False, False};

				analyteMissingError = MatchQ[resolvedAnalyte, Null];

				(*Pull out what is specified *)
				{
					specifiedQuantifyCellCount,
					specifiedMethod,
					blankMeasurement,
					specifiedBlank,
					specifiedBlankVolume,
					specifiedDiluent,
					specifiedDilutionCurve,
					specifiedSerialDilutionCurve

				}=Lookup[
					options,
					{
						QuantifyCellCount,
						Method,
						BlankMeasurement,
						Blank,
						BlankVolume,
						Diluent,
						DilutionCurve,
						SerialDilutionCurve
					}
				];

				(*--Resolve QuantifyCellCount--*)
				resolvedQuantifyCellCount = Which[
					(* if specified as False, accept it, do not have to quantify *)
					MatchQ[specifiedQuantifyCellCount,False],specifiedQuantifyCellCount,
					(* if specified as True, make sure the Method matches *)
					MatchQ[specifiedQuantifyCellCount,True]&&MatchQ[specifiedMethod,CellCount],specifiedQuantifyCellCount,
					(* if specified as True, and Method doesn't match, throw error *)
					MatchQ[specifiedQuantifyCellCount,True]&&MatchQ[specifiedMethod,Solubility],methodQuantificationMismatchError=True;specifiedQuantifyCellCount,
					(* if Automatic and Method is CellCount, then True *)
					MatchQ[specifiedQuantifyCellCount,Automatic]&&MatchQ[specifiedMethod,CellCount],True,
					(* if Automatic and Method is not CellCount, then False *)
					MatchQ[specifiedQuantifyCellCount,Automatic]&&MatchQ[specifiedMethod,Solubility],False,
					(* otherwise, False *)
					True,False
				];

				(* get the quantification analyte packets *)
				analytePacket = If[NullQ[resolvedAnalyte],
					Null,
					SelectFirst[compositionPackets, Not[NullQ[#]] && MatchQ[resolvedAnalyte, ObjectP[Lookup[#, Object]]]&, Null]
				];

				(* determine if the resolved quantification analyte is a component of the sample *)
				sampleContainsAnalyteError = If[MatchQ[resolvedAnalyte, IdentityModelP],
					Not[MemberQ[Lookup[compositionPackets,Object], ObjectP[resolvedAnalyte]]],
					False
				];

				(* determine the solvent to use for blank *)
				solvent = Download[Lookup[samplePacket,Solvent,Null],Object];

				(*--Resolve Blank options--*)
				(* resolve the Blank option, and return what the re-assigned incompatibleBlankOptionsError value is (note that we are passing the previous value of incompatibleBlankOptionsError down; I am only explicitly setting it if marking as True) *)
				{resolvedBlank, incompatibleBlankOptionsError} = Which[
					(* if BlankMeasurement -> True, but the specified blank is Null, throw the error *)
					TrueQ[blankMeasurement] && NullQ[specifiedBlank], {Null, True},
					(* if BlankAbsorbance -> True and we're Robotic, pick the first sample in the plate. *)
					TrueQ[blankMeasurement] && MatchQ[resolvedPreparation, Robotic] && MatchQ[specifiedBlank, Automatic],
					{
						FirstCase[
							Download[Lookup[containerPacket, Contents][[All,2]], Object],
							Except[ObjectP[simulatedSamples]],
							FirstOrDefault[simulatedSamples]
						],
						False
					},
					(* if BlankMeasurement -> True and Blank -> Automatic and solvent is informed, resolve to solvent *)
					TrueQ[blankMeasurement] && MatchQ[specifiedBlank, Automatic] && MatchQ[solvent,ObjectP[Model[Sample]]], {solvent, False},
					(* if BlankMeasurement -> True and Blank -> Automatic but solvent isn't informed, resolve to water *)
					TrueQ[blankMeasurement] && MatchQ[specifiedBlank, Automatic], {Model[Sample, "Milli-Q water"], False},
					(* if BlankMeasurement -> True and Blank is something else, stick with that something else *)
					TrueQ[blankMeasurement]&&MatchQ[specifiedBlank,ObjectP[{Object[Sample],Model[Sample]}]], {specifiedBlank, False},
					(* if BlankMeasurement -> False and Blank is Automatic or Null, then resolve to Null *)
					MatchQ[blankMeasurement, False] && MatchQ[specifiedBlank, Automatic | Null], {Null, False},
					(* if BlankMeasurement -> False and Blank is specified as something besides Automatic or Null, throw the error *)
					MatchQ[blankMeasurement, False] && Not[MatchQ[specifiedBlank, Automatic | Null]], {specifiedBlank, True},
					(* catch-all for some weird case where none of the above applied; if this happens definitely throw the error *)
					True, {specifiedBlank, True}
				];

				(* BMG blank objects must be in a supported container if they aren't going to be moved into one (i.e. if BlankVolume->Null) *)
				(* Just check the container - we'll do a global check below to see if any aliquoting needs to happen *)
				blankSamplePacket=SelectFirst[blankSamplePackets,MatchQ[Lookup[#,Object],ObjectP[resolvedBlank]]&,<||>];
				blankContainerPacket=SelectFirst[blankContainerPackets,MatchQ[Lookup[#,Object],ObjectP[Lookup[blankSamplePacket,Container]]]&,<||>];

				badBlankContainer=If[MatchQ[specifiedBlank,ObjectP[Object]],
					!MemberQ[validPlateModelsList,ObjectP[Lookup[blankContainerPacket,Model]]],
					(* All models need a volume *)
					True
				];

				(* this is a bit janky, but we are trying to guess which container we will be using for the experiment here. We don't have _all_ the information we need to know for sure since it needs info for all samples *)
				bestInitialGuessBlankContainerModel = Which[
					MemberQ[validPlateModelsList, ObjectP[FirstCase[Flatten[suppliedAliquotContainers], ObjectP[]]]], FirstCase[Flatten[suppliedAliquotContainers], ObjectP[]],
					True, First[validPlateModelsList]
				];

				bestGuessBlankContainerModel = If[MemberQ[validPlateModelsList, ObjectP[Download[Lookup[blankContainerPacket, Model], Object]]],
					Download[Lookup[blankContainerPacket, Model], Object],
					bestInitialGuessBlankContainerModel
				];

				(* Get the model container's max volume to do comparisons later *)
				containerMaxVolume = Lookup[fetchPacketFromCache[bestGuessBlankContainerModel, cache], MaxVolume, Null] /. {Null | $Failed -> 300 * Microliter};

				containerRecommendedVolume = Lookup[fetchPacketFromCache[bestGuessBlankContainerModel, cache], RecommendedFillVolume, Null] /. {Null | $Failed -> 0.2 * containerMaxVolume};


				(*--Resolve Dilution options--*)
				(* Diluent depends on DilutionCurve if specified *)
				resolvedDiluent = If[
					(* if diluent is specified, use that *)
					MatchQ[specifiedDiluent, Except[Automatic]], specifiedDiluent,

					(* if a dilution curve is specified and diluent is Automatic, set to the solvent/water, or Null otherwise *)
					If[MatchQ[specifiedSerialDilutionCurve,Except[Null|Automatic]]||MatchQ[specifiedDilutionCurve,Except[Null|Automatic]],
						If[MatchQ[solvent,ObjectP[Model[Sample]]],
							solvent,
							Model[Sample, "Milli-Q water"]
						],
						Null
					]
				];

				(*Resolve DilutionCurve options*)
				{resolvedSerialDilutionCurve,resolvedDilutionCurve} = Switch[
					{specifiedSerialDilutionCurve,specifiedDilutionCurve,resolvedDiluent,dilutionErrorsQ},

					(* if there are any errors, just accept what the curves are set at, errors are already thrown *)
					{_,_,_,True},
					{specifiedSerialDilutionCurve, specifiedDilutionCurve},

					(* if diluent is Null, and both are Automatic, set both to Null *)
					{Automatic|Null,Automatic|Null,Null,False},
					{Null, Null},

					(* if diluent is not Null and either is specified, accept it *)
					{Except[Automatic|Null],Automatic|Null,Except[Null],False},
					{specifiedSerialDilutionCurve, Null},

					{Automatic|Null,Except[Automatic|Null],Except[Null],False},
					{Null, specifiedDilutionCurve},

					(* if diluent is not Null and SerialDilutionCurve is Null but DilutionCurve is Automatic, set dilution curve with
					SampleAmount as {0.75, 0.5, 0.25}*container max volume (sample volume if smaller, and DiluentVolume as {0.25, 0.5, 0.75}*container max volume *)
					{Null,Automatic,Except[Null],False},
					{
						Null,
						{
							{SafeRound[0.75*(Min[Cases[{Lookup[samplePacket,Volume],containerMaxVolume},VolumeP]]),1Microliter], SafeRound[0.25*(Min[Cases[{Lookup[samplePacket,Volume],containerMaxVolume},VolumeP]]),1Microliter]},
							{SafeRound[0.5*(Min[Cases[{Lookup[samplePacket,Volume],containerMaxVolume},VolumeP]]),1Microliter], SafeRound[0.5*(Min[Cases[{Lookup[samplePacket,Volume],containerMaxVolume},VolumeP]]),1Microliter]},
							{SafeRound[0.25*(Min[Cases[{Lookup[samplePacket,Volume],containerMaxVolume},VolumeP]]),1Microliter], SafeRound[0.75*(Min[Cases[{Lookup[samplePacket,Volume],containerMaxVolume},VolumeP]]),1Microliter]}
						}
					},

					(* if diluent is not Null and both are Automatic or DilutionCurve is Null but SerialDilutionCurve is Automatic, set serial dilution curve with
					TransferVolume as one tenth of smallest of sample volume or container max volume,
					DiluentVolume as smallest of sample volume or container max volume, and Number of Dilutions as 3 *)
					{Automatic,Automatic|Null,Except[Null],False},
					{{SafeRound[0.1*(Min[Cases[{Lookup[samplePacket,Volume],containerMaxVolume},VolumeP]]),1Microliter], Min[Cases[{Lookup[samplePacket,Volume],containerMaxVolume},VolumeP]], 3}, Null}
				];

				(* set blankAliquotRequired to True if dilutions are occurring since blanks will have to be aliquoted *)
				blankAliquotRequired = !NullQ[resolvedDiluent];


				(* resolve the BlankVolume option, and return what the reassigned error values are *)
				{resolvedBlankVolume,incompatibleBlankOptionsError,blankContainerError,blankContainerWarning}=Which[
					(* if BlankMeasurement -> True, BlankVolume -> Automatic, and we are using a BMG plate reader,
					BlankVolume resolves to the current volume of the sample or 300 Microliter, whichever is smaller;
					note that this is the same as the RequiredAliquotAmount stuff below *)
					TrueQ[blankMeasurement]&&MatchQ[specifiedBlankVolume,Automatic],
					{
						If[badBlankContainer||blankAliquotRequired,
							Max[{Min[Cases[{Lookup[samplePacket,Volume],containerMaxVolume},VolumeP]],containerRecommendedVolume}],
							Null
						],
						incompatibleBlankOptionsError,
						blankContainerError,
						blankContainerWarning
					},

					(* if BlankMeasurement -> True, BlankVolumes is Null, and sample needs to be moved then we have an error *)
					TrueQ[blankMeasurement]&&NullQ[specifiedBlankVolume]&&badBlankContainer,{Null,incompatibleBlankOptionsError,True,blankContainerWarning},

					(* if BlankMeasurement -> True, BlankVolumes is Null and sample doesn't needs to be moved then we are okay *)
					TrueQ[blankMeasurement]&&NullQ[specifiedBlankVolume]&&!badBlankContainer,{Null,incompatibleBlankOptionsError,blankContainerError,blankContainerWarning},

					(* if BlankMeasurement -> True, BlankVolumes is not Null or Automatic, warn the user that they're making an unnecessary transfer *)
					TrueQ[blankMeasurement]&&Not[MatchQ[specifiedBlankVolume,Null|Automatic]]&&!(badBlankContainer||blankAliquotRequired),{specifiedBlankVolume,incompatibleBlankOptionsError,blankContainerError,True},

					(* if BlankMeasurement -> True, BlankVolumes is not Null or Automatic, use the user specified value *)
					TrueQ[blankMeasurement]&&Not[MatchQ[specifiedBlankVolume,Null|Automatic]]&&(badBlankContainer||blankAliquotRequired),{specifiedBlankVolume,incompatibleBlankOptionsError,blankContainerError,blankContainerWarning},

					(* if BlankMeasurement -> False and BlankVolumes is Automatic or Null, resolve to Null *)
					MatchQ[blankMeasurement,False]&&MatchQ[specifiedBlankVolume,Automatic|Null],{Null,incompatibleBlankOptionsError,blankContainerError,blankContainerWarning},

					(* if BlankMeasurement -> False and BlankVolumes is not Null, throw error *)
					MatchQ[blankMeasurement,False]&&Not[MatchQ[specifiedBlankVolume,Automatic|Null]],{specifiedBlankVolume,True,blankContainerError,blankContainerWarning},

					(* catch-all for some weird case where none of the above applied; if this happens we are definitely in an erroneous state *)
					True,{specifiedBlankVolume,True,blankContainerError,blankContainerWarning}
				];



				(* Return resolved options and error trackers packet *)
				resolvedOptionsPacket = <|
					QuantifyCellCount -> resolvedQuantifyCellCount,
					Blank -> resolvedBlank,
					BlankVolume -> resolvedBlankVolume,
					Diluent -> resolvedDiluent,
					DilutionCurve -> resolvedDilutionCurve,
					SerialDilutionCurve -> resolvedSerialDilutionCurve
				|>;

				mapThreadErrorTrackerPacket = <|
					MethodQuantificationMismatchErrors -> methodQuantificationMismatchError,
					AnalyteMissingErrors -> analyteMissingError,
					SampleContainsAnalyteErrors -> sampleContainsAnalyteError,
					IncompatibleBlankOptionsErrors -> incompatibleBlankOptionsError,
					BlankContainerErrors -> blankContainerError,
					BlankContainerWarnings -> blankContainerWarning
				|>;

				{resolvedOptionsPacket, mapThreadErrorTrackerPacket}
			]
		],
		{samplePackets,sampleContainerPackets,sampleCompositionPackets,resolvedAnalytes,updatedMapThreadFriendlyOptions}
	]];

	(* merge the resolved options and error trackers *)
	allResolvedMapThreadOptionsAssociation = MapThread[Append[#1, #2] &, {updatedMapThreadFriendlyOptions, resolvedOptionsPackets}];
	allErrorTrackersAssociation = resolvedMapThreadErrorTrackerPackets;


	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* QuantifyCellCount is not True if Method is not CellCount *)
	mapThreadQuantifyCellCount = Lookup[allResolvedMapThreadOptionsAssociation, QuantifyCellCount];

	(* Throw message in the simple case where MethodQuantificationMismatchErrors is True indicating QuantifyCellCount is True but Method is not CellCount *)
	methodQuantificationMismatchInvalidOptions = If[MemberQ[Lookup[allErrorTrackersAssociation,MethodQuantificationMismatchErrors],True]&&messages,
		Message[Error::NephelometryMethodQuantificationMismatch,PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,MethodQuantificationMismatchErrors],True],resolvedMethod];
		{QuantifyCellCount,Method},
		{}
	];

	(*If we are gathering tests, create a test for Quantification and Method mismatch*)
	methodQuantificationMismatchTest=If[gatherTests,
		Test["If Method is Solubility, QuantifyCellCount cannot be True:",
			MemberQ[Lookup[allErrorTrackersAssociation,MethodQuantificationMismatchErrors],True],
			False
		],
		Nothing
	];


	(* - BlankVolumes is specified if blanks need to be moved - *)
	mapThreadBlank = Lookup[allResolvedMapThreadOptionsAssociation, Blank];
	mapThreadBlankVolume = Lookup[allResolvedMapThreadOptionsAssociation, BlankVolume];

	(* Throw message in the simple case where blankContainerErrors is True indicating BlankVolume->Null and container is incompatible *)
	If[MemberQ[Lookup[allErrorTrackersAssociation,BlankContainerErrors],True]&&messages,
		Message[Error::InvalidBlankContainer,"a container compatible with the plate reader",PickList[mapThreadBlank,Lookup[allErrorTrackersAssociation,BlankContainerErrors],True]]
	];

	(* If we have to aliquot must throw an error if we're missing volume information about how to do that aliquot for the blanks *)
	blankAliquotError=blankMeasurement&&blankAliquotRequired&&MemberQ[mapThreadBlankVolume,Null]&&!MemberQ[Lookup[allErrorTrackersAssociation,BlankContainerErrors],True];

	(* Throw message *)
	If[messages&&blankAliquotError,
		Message[Error::BlankAliquotRequired,"in order to generate replicate blanks",PickList[mapThreadBlank,mapThreadBlankVolume,Null]]
	];

	(* Create test *)
	blankContainerErrorTest=If[gatherTests,
		Test["BlankVolume is specified for any blank samples which must be moved from their current containers in order to perform the blank measurement on the instrument:",MemberQ[Lookup[allErrorTrackersAssociation,BlankContainerErrors],True],False]
	];

	(* Track invalid option *)
	incompatibleBlankVolumesInvalidOptions=If[MemberQ[Lookup[allErrorTrackersAssociation,BlankContainerErrors],True]||blankAliquotError,BlankVolumes];

	(* - Verify BlankVolumes is not specified if Blanks don't need to be moved  - *)

	(* Throw message *)
	If[MemberQ[Lookup[allErrorTrackersAssociation,BlankContainerWarnings],True]&&messages&&notInEngine,
		Message[Warning::UnnecessaryBlankTransfer,PickList[mapThreadBlank,Lookup[allErrorTrackersAssociation,BlankContainerWarnings],True]]
	];


	(* Create test *)
	blankContainerWarningTest=If[gatherTests,
		Warning["BlankVolume is not specified for any samples which could be left in their current containers:",MemberQ[Lookup[allErrorTrackersAssociation,BlankContainerWarnings],True],False]
	];

	(* Check for incompatible blank options errors *)
	incompatibleBlankInvalidOptions=If[MemberQ[Lookup[allErrorTrackersAssociation,IncompatibleBlankOptionsErrors],True]&&messages,
		(
			Message[Error::IncompatibleBlankOptions];
			{BlankMeasurement,Blank,BlankVolume}
		),
		{}
	];

	(* Generate the incompatible blank options tests *)
	incompatibleBlankOptionTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* get the inputs, blank volumes, and blanks that fail this test *)
			failingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,IncompatibleBlankOptionsErrors]];

			(* get the inputs, blank volumes, and blanks that pass this test *)
			passingSamples=PickList[simulatedSamples,Lookup[allErrorTrackersAssociation,IncompatibleBlankOptionsErrors],False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["The Blank and BlankVolume options are compatible with each other for the following samples: "<>ObjectToString[failingSamples,Cache->cacheBall]<>" when BlankMeasurement -> "<>ObjectToString[blankMeasurement]<>":",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["The Blank and BlankVolume options are compatible with each other for the following samples: "<>ObjectToString[passingSamples,Cache->cacheBall]<>" when BlankMeasurement -> "<>ObjectToString[blankMeasurement]<>":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}

		]
	];

	(* - Verify the state of Blank if there is no incompatibleBlankOptionsError - *)
	(* find object or model in blanks *)
	selectedBlanks=Select[mapThreadBlank,ObjectQ];

	(* if there are blank objects, track the invalid ones that are not Liquid *)
	nonLiquidBlanksBoolean=If[!MatchQ[selectedBlanks,{}],
		(!MatchQ[#,Liquid])&/@Download[selectedBlanks, State, Cache->cacheBall, Simulation->simulation],
		{}
	];

	(* Track the invalid ones that are not liquid *)
	nonLiquidBlanks=PickList[selectedBlanks,nonLiquidBlanksBoolean];

	blankStateWarning=Length[nonLiquidBlanks]>0;

	(* Throw message *)
	If[blankStateWarning&&messages&&notInEngine,
		Message[Warning::BlankStateWarning,nonLiquidBlanks]
	];

	(* Create test *)
	blankStateWarningTest=If[gatherTests,
		Warning["The states of the blanks are Liquid:",blankStateWarning,False]
	];



	(*--PreparedPlate Blanks in Container check--*)
	(* get sample objects in the contents of the containers in *)
	containersInContents = Flatten[Download[Map[#[[All, 2]]&, Lookup[(sampleContainerPackets/.Null -> <||>), Contents, {}]], Object]];

	(* check if blanks are in containers when PreparedPlate->True *)
	blanksInPlateQ = If[preparedPlate&&blankMeasurement,
		AllTrue[MemberQ[containersInContents,#]&/@mapThreadBlank,TrueQ],
		True
	];

	(* If blanks in containers test fails, set the invalid inputs to blanks not in containers *)
	preparedPlateBlanksContainerOptions = If[!preparedPlate||!blankMeasurement||blanksInPlateQ,
		{},
		PickList[mapThreadBlank,MemberQ[#,containersInContents]&/@mapThreadBlank,False]
	];

	(* throw error if the prepared plate check is false *)
	If[!blanksInPlateQ&&messages,
		(Message[Error::NephelometryPreparedPlateBlanksInvalid,preparedPlateBlanksContainerOptions];
		{PreparedPlate,Blank,BlankMeasurement})
	];

	(*If we are gathering tests, create a test for a prepared plate error*)
	validPreparedPlateBlanksContainerTest=If[gatherTests,
		Test["When PreparedPlate -> True and BlankMeasurement-> True, the Blanks are all in plates containing samples to be read:",
			blanksInPlateQ,
			True
		],
		Nothing
	];

	(* - Throw an error if the order of the injections are not correct. e.g. error out if it has a secondary injection without a primary injection. - *)

	(* Do the check only if we have any injections *)
	skippedInjectionError=If[Or[primaryInjectionsQ,secondaryInjectionQ,tertiaryInjectionQ,quaternaryInjectionQ],
		!((primaryInjectionsQ&&!secondaryInjectionQ&&!tertiaryInjectionQ&&!quaternaryInjectionQ)||(primaryInjectionsQ&&secondaryInjectionQ&&!tertiaryInjectionQ&&!quaternaryInjectionQ)||(primaryInjectionsQ&&secondaryInjectionQ&&tertiaryInjectionQ&&!quaternaryInjectionQ)||(primaryInjectionsQ&&secondaryInjectionQ&&tertiaryInjectionQ&&quaternaryInjectionQ)),
		False
	];

	(* Track invalid options *)
	injectionQList={primaryInjectionsQ,secondaryInjectionQ,tertiaryInjectionQ,quaternaryInjectionQ};

	injectionOptionList={PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume};

	skippedInjectionIndex=If[skippedInjectionError,
		Module[{lastTrueInjection},
			lastTrueInjection=First[Last[Position[injectionQList,True]]];
			Flatten[Position[injectionQList[[1;;lastTrueInjection]],False]]
		]
	];

	invalidSkippedInjection=If[skippedInjectionError,
		injectionOptionList[[#]]&/@skippedInjectionIndex
	];

	(* Throw message *)
	If[skippedInjectionError&&messages,
		Message[Error::SkippedInjectionError,invalidSkippedInjection,injectionOptionList[[Last[skippedInjectionIndex]+1]]]
	];

	(* Create test *)
	skippedInjectionErrorTest=If[gatherTests,
		Test["Primary, Secondary, Tertiary, or Quaternary injections are specified in order without skipping:",skippedInjectionError,False]
	];



	(* check to ensure that if QuantifyCellCount -> True, BlankMeasurement is also True *)
	quantRequiresBlankingInvalidOptions=If[MemberQ[mapThreadQuantifyCellCount,True]&&Not[blankMeasurement]&&messages,
		(
			Message[Error::QuantificationRequiresBlanking];
			{QuantifyCellCount,BlankMeasurement}
		),
		{}
	];

	(* generate tests for when quantification requires blanking *)
	quantRequiresBlankingTest=If[gatherTests,
		Test["If QuantifyCellCount -> True for any sample, BlankMeasurement is not False:",
			If[MemberQ[mapThreadQuantifyCellCount,True],
				Not[MatchQ[blankMeasurement,False]],
				True
			],
			True
		],
		Null
	];


	(* throw an error if the Analyte option couldn't be determined *)
	analyteMissingErrors = Lookup[allErrorTrackersAssociation,AnalyteMissingErrors];

	mapThreadAnalyte = Lookup[allResolvedMapThreadOptionsAssociation, Analyte];

	analyteMissingOptions = If[MemberQ[analyteMissingErrors, True] && messages,
		(
			Message[Error::NephelometryAnalyteMissing, ObjectToString[PickList[simulatedSamples, analyteMissingErrors], Cache -> cacheBall]];
			{Analyte}
		),
		{}
	];

	(* make a test for if we need to have the analyte populated *)
	analyteMissingOptionTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, analyteMissingErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, analyteMissingErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["Analyte is specified or automatically determined for the following sample(s):" <> ObjectToString[failingSamples, Cache -> cacheBall] <> ":",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["Analyte is specified or automatically determined for the following sample(s):" <> ObjectToString[passingSamples, Cache -> cacheBall] <> ":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}

		],
		Null
	];


	(* throw an error if the Analyte option isn't in the corresponding sample's composition *)
	sampleContainsAnalyteErrors = Lookup[allErrorTrackersAssociation,SampleContainsAnalyteErrors];

	sampleContainsAnalyteOptions = If[MemberQ[sampleContainsAnalyteErrors, True] && messages,
		(
			Message[Error::NephelometrySampleMustContainAnalyte, ObjectToString[PickList[simulatedSamples, sampleContainsAnalyteErrors], Cache -> cacheBall]];
			{Analyte}
		),
		{}
	];


	(* make a test to ensure the sample contains the analyte in its composition *)
	sampleContainsAnalyteOptionTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[simulatedSamples, sampleContainsAnalyteErrors];

			(* get the inputs that pass this test *)
			passingSamples = PickList[simulatedSamples, sampleContainsAnalyteErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["Analyte is contained in the Composition field of the following sample(s):" <> ObjectToString[failingSamples, Cache -> cacheBall] <> ":",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["Analyte is contained in the Composition field of the following sample(s):" <> ObjectToString[passingSamples, Cache -> cacheBall] <> ":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}

		],
		Null
	];

	(* ---Figure out sample concentrations--- *)

	(* get the sample compositions *)
	sampleCompositions = Lookup[#, Composition] & /@ samplePackets;

	(* get the cases from the sample compositions that correspond to the analytes *)
	analyteCompositions = MapThread[FirstCase[#1, {_, LinkP[#2], _}, {Null,Null,Null}] &, {sampleCompositions, mapThreadAnalyte}];

	(* get the concentration of the analyte from the composition *)
	analyteConcentrations = analyteCompositions[[All,1]];

	(* lookup the densities needed for calculations *)
	sampleDensities = Lookup[samplePackets,Density];

	inputConcentrations = Lookup[nephelometryOptionsAssociation,InputConcentration];

	flatAnalytePackets = FlattenCachePackets[sampleAnalytePackets];

	(* convert analyte concentrations to molarity, as that's what parser expects *)
	{analyteConcentrationsConverted,unresolvableAnalyteConcentrationTuples}=Reap[
		MapThread[
			Function[{inputConcentration,sampleAnalyte,analyteConcentration,sampleDensity,inputSample},
				Module[{analyteDensity,molecularWeight},

					(* Lookup density and MW if the sampleAnalyte is not Null *)
					{analyteDensity,molecularWeight}=If[!MatchQ[sampleAnalyte,Null],
						Lookup[fetchPacketFromCache[sampleAnalyte,flatAnalytePackets],{Density,MolecularWeight}],
						{Null,Null}
					];

					(* Resolve the concentration *)
					Which[

						(* If there is no analyte, no concentration *)
						MatchQ[sampleAnalyte,Null],Null,

						(* If the concentration is specified, use it *)
						MatchQ[inputConcentration,Except[Null|Automatic]],inputConcentration,

						(* If the units are in terms of concentration already, accept it *)
						ConcentrationQ[analyteConcentration],analyteConcentration,

						(* If the units are in terms of density, convert to molarity using molecular weight *)
						DensityQ[analyteConcentration]&&MolecularWeightQ[molecularWeight],Convert[Convert[analyteConcentration,Gram/Liter]/molecularWeight,Mole/Liter],

						(* If the units are in MassPercent and sample density is known, convert to molarity by converting to Percent and multiplying by sample density, then dividing by molecular weight *)
						MassPercentQ[analyteConcentration]&&DensityQ[sampleDensity]&&MolecularWeightQ[molecularWeight],Convert[(Unitless[analyteConcentration]*sampleDensity)/molecularWeight,Mole/Liter],

						(* If the units are in VolumePercent and analyte density is known, convert to molarity by multiplying by component density, then dividing by molecular weight *)
						VolumePercentQ[analyteConcentration]&&DensityQ[analyteDensity]&&MolecularWeightQ[molecularWeight],Convert[(Unitless[analyteConcentration]*analyteDensity)/molecularWeight,Mole/Liter],

						(* If the units are in VolumePercent or MassPercent and analyte density is not known, save the input sample for error checking and return Null *)
						Or[VolumePercentQ[analyteConcentration],MassPercentQ[analyteConcentration]]&&!DensityQ[analyteDensity],Module[{},
							Sow[{ObjectToString[inputSample,Cache->samplePackets],ObjectToString[sampleAnalyte,Cache->samplePackets],Density},resolveExperimentNephelometryOptions];
							Null
						],

						(* If the units are in density or in VolumePercent/MassPercent with known density, but the MW is not known, save the input sample for error checking and return Null *)
						Or[DensityQ[analyteConcentration],MassPercentQ[analyteConcentration],VolumePercentQ[analyteConcentration]]&&!MolecularWeightQ[molecularWeight],Module[{},
							Sow[{ObjectToString[inputSample,Cache->samplePackets],ObjectToString[sampleAnalyte,Cache->samplePackets],MolecularWeight},resolveExperimentNephelometryOptions];
							Null
						],

						(* Otherwise, just go with Null *)
						True,Null
					]
				]
			],
			{inputConcentrations,mapThreadAnalyte,analyteConcentrations,sampleDensities,mySamples}
		],
		resolveExperimentNephelometryOptions
	];

	If[
		MatchQ[unresolvableAnalyteConcentrationTuples,Except[{}]]&&messages&&notInEngine,
		Message[Warning::NephelometryIncomputableConcentration,Sequence@@Transpose[Flatten[unresolvableAnalyteConcentrationTuples,1]]]
	];

	(* ---Dilution volume error checking--- *)
	(* Total dilution volume plus injection volume cannot be more than MaxVolume of plate *)
	(* lookup the dilution curves *)
	mapThreadDilutionCurves = Lookup[allResolvedMapThreadOptionsAssociation,DilutionCurve];
	mapThreadSerialDilutionCurves = Lookup[allResolvedMapThreadOptionsAssociation,SerialDilutionCurve];

	(* Get the model container's max volume *)
	containerMaxVolume = Lookup[
		fetchPacketFromCache[
			Download[Lookup[(sampleContainerPackets/.Null -> <||>),Model, Null],Object],
			cacheBall
		],
		MaxVolume,
		300*Microliter(*largest volume of the microtiter plates*)
	];

	{serialDilutionVolumeTooLarge,dilutionVolumeTooLarge} = If[NullQ[Lookup[allResolvedMapThreadOptionsAssociation,Diluent]],
		{{False},{False}},
		Module[{
			calculatedDilutionVolumes,calculatedSerialDilutionVolumes,totalDilutionVolumes,totalSerialDilutionVolumes,
			totalInjectionVolumes,expandedInjectionVolumes,expandedInjectionVolumesSerial,totalVolumes,totalSerialVolumes,
			serialDilutionVolumeTooLarge,dilutionVolumeTooLarge,expandedTotalInjectionVolumes,expandedTotalInjectionVolumesSerial
			},
			(* use helper function to determine the volumes of the dilutions, replace Nulls *)
			calculatedDilutionVolumes = Map[
				Transpose,
				Map[
					calculateDilutionVolumes,
					mapThreadDilutionCurves
				]/.{ListableP[Null]}->{0Microliter,0Microliter}
			];

			calculatedSerialDilutionVolumes = Map[
				Transpose,
				Map[
					calculateDilutionVolumes,
					mapThreadSerialDilutionCurves
				]/.{ListableP[Null]}->{0Microliter,0Microliter}
			];

			(* get the total volume per dilution well by mapping total at level spec 2 *)
			totalDilutionVolumes = If[
				NullQ[Lookup[allResolvedMapThreadOptionsAssociation,Diluent]],
				{0Microliter},
				Map[Total,calculatedDilutionVolumes,{2}]
			];

			totalSerialDilutionVolumes = If[
				NullQ[Lookup[allResolvedMapThreadOptionsAssociation,Diluent]],
				{0Microliter},
				Map[Total,calculatedSerialDilutionVolumes,{2}]
			];

			(* get the total injection volumes *)
			totalInjectionVolumes = If[MatchQ[experimentFunction,ExperimentNephelometry],
				If[anyInjectionsQ,Map[Total,{primaryInjectionVolume/.Null-> 0Microliter,(secondaryInjectionVolume/.Null-> 0Microliter)}], {0Microliter}],
				If[anyInjectionsQ,Map[Total,{primaryInjectionVolume/.Null-> 0Microliter,(secondaryInjectionVolume/.Null-> 0Microliter),(tertiaryInjectionVolume/.Null-> 0Microliter),(quaternaryInjectionVolume/.Null-> 0Microliter)}], {0Microliter}]
			];

			(* expand the injection volumes to the length of the dilution series, as injections will be added to all dilution series members *)
			expandedInjectionVolumes = Map[Function[{dilutions},
				Map[ConstantArray[#, Length[dilutions]] &, totalInjectionVolumes]],
				totalDilutionVolumes
			];

			expandedInjectionVolumesSerial = Map[Function[{serialDilutions},
				Map[ConstantArray[#, Length[serialDilutions]] &, totalInjectionVolumes]],
				totalSerialDilutionVolumes
			];

			(* total the expanded volumes *)
			expandedTotalInjectionVolumes = Map[Total, Map[Transpose, expandedInjectionVolumes], {2}];
			expandedTotalInjectionVolumesSerial = Map[Total, Map[Transpose, expandedInjectionVolumesSerial], {2}];

			(* total the dilution total volume and the injection volume total *)
			totalVolumes = MapThread[Total[{#1, #2}]&, {totalDilutionVolumes,expandedTotalInjectionVolumes}];
			totalSerialVolumes = MapThread[Total[{#1, #2}]&, {totalSerialDilutionVolumes,expandedTotalInjectionVolumesSerial}];

			(* determine if the total volume to make the dilution and injections is over the max volume of the wells *)
			dilutionVolumeTooLarge = Map[Greater[If[MatchQ[#,_List],Normal@@#,#],containerMaxVolume]&,totalVolumes,{2}];
			serialDilutionVolumeTooLarge = Map[Greater[If[MatchQ[#,_List],Normal@@#,#],containerMaxVolume]&,totalSerialVolumes,{2}];

			{serialDilutionVolumeTooLarge,dilutionVolumeTooLarge}
		]
	];

	(* Throw message for volumes that are too large *)
	dilutionVolumeTooLargeInvalidOptions = If[MemberQ[Flatten[dilutionVolumeTooLarge],True]||MemberQ[Flatten[serialDilutionVolumeTooLarge],True]&&messages,
		Message[
			Error::NephelometryDilutionVolumeTooLarge,
			PickList[mapThreadDilutionCurves,MemberQ[#,True]&/@dilutionVolumeTooLarge,True],
			PickList[mapThreadSerialDilutionCurves,MemberQ[#,True]&/@serialDilutionVolumeTooLarge,True],
			containerMaxVolume
		];
		{DilutionCurve,SerialDilutionCurve},
		{}
	];

	(*If we are gathering tests, create a test for dilution volume too large *)
	dilutionVolumeTooLargeTest=If[gatherTests,
		Test["The total volume after dilutions and injections must not go over the max volume of the container:",
			Normal@@(MemberQ[#,True]&/@dilutionVolumeTooLarge)||Normal@@(MemberQ[#,True]&/@serialDilutionVolumeTooLarge),
			False
		],
		Nothing
	];

	(* -----Resolve Independent Options----- *)

	(* - Validate Moat options - *)
	(* We must first know total number of samples *)
	(* figure out how many unique blanks there are *)
	blankObjects=Download[mapThreadBlank,Object];
	numBlanks=Length[DeleteDuplicates[blankObjects]];
	numOfBlankAdditions=Length[DeleteDuplicates[Transpose[{blankObjects,mapThreadBlankVolume}]]];

	(* Figure out if the combination of (NumberOfReplicates * number of samples) + (2* number of blanks) (if we're blanking), or NumberOfReplicates * Number of samples if we are not *)
	(* Note Moat sample space gets checked below by validMoat *)
	totalNumSamples=If[blankMeasurement,
		(preresolvedNumReplicates*Length[simulatedSamples])+(numOfBlankAdditions*preresolvedNumReplicates),
		preresolvedNumReplicates*Length[simulatedSamples]
	];

	(* Do all the checks to make sure our moat options are valid *)
	{invalidMoatOptions,moatTests} = If[gatherTests,
		validMoat[totalNumSamples,aliquotContainerModelPacket,Join[nephelometryOptionsAssociation,Association[samplePrepOptions]],Output->{Options,Tests}],
		{validMoat[totalNumSamples,aliquotContainerModelPacket,Join[nephelometryOptionsAssociation,Association[samplePrepOptions]],Output->Options],{}}
	];

	(* - Resolve Moat Options - *)
	(* call helper function in Experiment/sources/BMGResources *)
	{resolvedMoatBuffer,resolvedMoatVolume,resolvedMoatSize} = resolveMoatOptions[myType,aliquotContainerModelPacket,moatBuffer,moatVolume,moatSize];


	(* Resolve NumberOfReplicates *)
	resolvedNumberOfReplicates=Which[
		MatchQ[numberOfReplicates,_Integer],
		numberOfReplicates,

		MatchQ[numberOfReplicates,Automatic]&&MemberQ[mapThreadQuantifyCellCount,True],
		(* If we're quantifying concentration, resolve to 3 *)
		3,

		True,
		Null
	];

	(* convert numberOfReplicates such that Null|Automatic -> 1 *)
	intNumReplicates=resolvedNumberOfReplicates/.{Null->1};

	(* --- Resolve Aliquot options --- *)

	(* Throw a single message or error if we have to aliquot for some reason *)
	Which[
		messages&&replicatesError,Message[Error::ReplicateAliquotsRequired],
		messages&&sampleRepeatError,Message[Error::RepeatedPlateReaderSamples],


		(* If any aliquot options are set, count is not reliable since simulation will mimic putting samples into vessels during the aliquot so only complain if no aliquoting is happening *)
		messages&&notInEngine&&replicatesWarning&&MatchQ[automaticAliquotingBooleans,{True..}],Message[Warning::ReplicateAliquotsRequired],
		messages&&notInEngine&&sampleRepeatWarning&&MatchQ[automaticAliquotingBooleans,{True..}],Message[Warning::RepeatedPlateReaderSamples]
	];

	(* Set Aliquot->True if some other action was requested that will require aliquots *)
	preresolvedAliquot=Map[
		If[bmgAliquotRequired&&MatchQ[#,Automatic],
			True,
			#
		]&,
		suppliedAliquotBooleans
	];

	(* - Preresolve aliquot container - *)

	(* If the user gave us a valid container to aliquot into use that same container for any other aliquoting *)
	(* This will make sure it ends up all in one plate when possible *)
	(* User could have specified as {{1,container}..}, sneakily flatten so we can pull out object *)
	resolutionAliquotContainer = If[MemberQ[validPlateModelsList,ObjectP[FirstCase[Flatten[suppliedAliquotContainers],ObjectP[]]]],
		First[suppliedAliquotContainers],
		First[BMGCompatiblePlates[Nephelometry]]
	];

	(* get the target containers: if the samples are already in a valid container, just pick that one; otherwise pick UV-star plate *)
	requiredAliquotContainers = MapThread[
		Which[
			MatchQ[#2,False|Null],Null,
			MemberQ[validPlateModelsList,ObjectP[#1]],#1,
			True,resolutionAliquotContainer
		]&,
		{Download[sampleContainerModelPackets,Object],suppliedAliquotBooleans}
	];

	(* - Resolve DestinationWells - *)

	suppliedDestinationWells=Lookup[samplePrepOptions,DestinationWell];

	(* Get all wells in the plate *)
	plateWells=AllWells[aliquotContainerModelPacket];

	(* Get wells that will be taken up by the moat *)
	impliedMoat=AllTrue[{moatSize,moatBuffer,moatVolume},MatchQ[Except[Null|0]]];

	moatWells=If[impliedMoat,
		getMoatWells[plateWells,resolvedMoatSize],
		{}
	];

	(* - Validate DestinationWell Option - *)
	(* Check whether the supplied DestinationWell have duplicated members. PlateReader experiment only allows one plate so we should not aliquot two samples into the same well. *)
	suppliedDestinationWellsNoAutomatic = DeleteCases[ToList[suppliedDestinationWells], Automatic | NullP];
	duplicateDestinationWells = Cases[Tally[suppliedDestinationWellsNoAutomatic], {well_, GreaterP[1]} :> well];

	duplicateDestinationWellOption=If[!MatchQ[duplicateDestinationWells,{}]&&!gatherTests,
		Message[Error::PlateReaderDuplicateDestinationWell,ToString[DeleteDuplicates[duplicateDestinationWells]]];{DestinationWell},
		{}
	];
	duplicateDestinationWellTest=If[gatherTests,
		Test["The specified DestinationWell should not have duplicated members:",MatchQ[duplicateDestinationWells,{}],True],
		{}
	];

	(* Check whether the supplied DestinationWell is the same length as samples with replicates. We cannot aliquot to the same well for duplicates. *)
	invalidDestinationWellLengthQ=If[!MatchQ[suppliedDestinationWells,{Automatic..}]&&MatchQ[preresolvedAliquot,{True..}],
		TrueQ[Length[suppliedDestinationWells]!=(intNumReplicates*Length[simulatedSamples])],
		False
	];
	invalidDestinationWellLengthOption=If[invalidDestinationWellLengthQ,
		Message[Error::InvalidDestinationWellLength,ToString[(intNumReplicates*Length[simulatedSamples])]];{DestinationWell},
		{}
	];
	invalidDestinationWellLengthTest=If[gatherTests,
		Test["The specified DestinationWell must be the same length as the number of all aliquots (the number of input samples multiplied by the specified NumberOfReplicates.",invalidDestinationWellLengthQ,False],
		{}
	];

	(* Try to resolve destination wells unless we know there's not enough room or we've detected overlap *)
	resolvedDestinationWells=If[MatchQ[suppliedDestinationWells,{Automatic..}]&&MatchQ[preresolvedAliquot,{True..}],
		Module[{readDirection,orderedWells,availableAssayWells},

			(* Re-order the wells based on read direction *)
			readDirection=Lookup[nephelometryOptionsAssociation,ReadDirection];
			orderedWells=Which[
				MatchQ[readDirection,Row],
				Flatten[plateWells],
				MatchQ[readDirection,Column],
				Flatten[Transpose[plateWells]],
				MatchQ[readDirection,SerpentineRow],
				Flatten[MapThread[
					If[OddQ[#2],#1,Reverse[#1]]&,
					{plateWells,Range[Length[plateWells]]}
				]],
				MatchQ[readDirection,SerpentineColumn],
				Flatten[MapThread[
					If[OddQ[#2],#1,Reverse[#1]]&,
					{Transpose[plateWells],Range[Length[Transpose[plateWells]]]}
				]]
			];


			(* Remove any moat wells from our possible wells - use DeleteCases to avoid rearranging *)
			availableAssayWells=DeleteCases[orderedWells,Alternatives@@moatWells];

			(* Use the first n wells *)
			If[Length[availableAssayWells]>=(intNumReplicates*Length[simulatedSamples]),
				Take[availableAssayWells,(intNumReplicates*Length[simulatedSamples])],
				suppliedDestinationWells
			]
		],
		suppliedDestinationWells
	];

	(* get the RequiredAliquotAmount *)
	(* round to 0.1 Microliter precision to avoid rounding error when resolving aliquot options *)
	requiredAliquotAmounts = If[Length[nonLiquidSampleInvalidInputs]>0,
		(* If there's non-liquid samples, don't bother about the volume as it will error out. We also don't want to throw error about amount-state conflict because amount is resolved by us.*)
		Automatic,
		SafeRound[
			MapThread[
				Min[Cases[
					{
						Lookup[#1, Volume, Null],
						Lookup[
							FirstCase[
								Flatten[listedAliquotContainerPackets],
								ObjectP[Download[#2, Object]],
								<||>
							],
							MaxVolume,
							If[MatchQ[#2, ObjectP[{Object[Container], Model[Container]}]],
								Download[#2, MaxVolume],
								300 Microliter
							]
						]
					},
					VolumeP]
				]&,
				{samplePackets, requiredAliquotContainers}
			],
			0.1Microliter
		]
	];

	(* make the AliquotWarningMessage value.  This sends the message indicating why we need to use specific kinds of containers *)
	aliquotWarningMessage= "because the given samples are in containers that are not compatible with the BMG plate readers.  You may set how much volume you wish to be aliquoted using the AliquotAmount option.";

	(* resolve ConsolidateAliquots to False if using the BMGs *)
	resolvedConsolidateAliquots = Which[
		BooleanQ[suppliedConsolidateAliquots], suppliedConsolidateAliquots,
		True, False
	];

	preresolvedAliquotOptions=ReplaceRule[myOptions,
		Join[
			{
				Aliquot->preresolvedAliquot,
				DestinationWell->resolvedDestinationWells,
				NumberOfReplicates->resolvedNumberOfReplicates,
				ConsolidateAliquots -> resolvedConsolidateAliquots
			},
			resolvedSamplePrepOptions
		]
	];

	(* resolve the aliquot options *)
	{resolvedAliquotOptions,resolveAliquotOptionsTests}=Quiet[If[gatherTests,
		resolveAliquotOptions[
			experimentFunction,
			Download[mySamples,Object],
			simulatedSamples,
			preresolvedAliquotOptions,
			Cache->cacheBall,
			Simulation->updatedSimulation,
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AliquotWarningMessage->aliquotWarningMessage,
			Output->{Result,Tests}
		],
		{resolveAliquotOptions[
			experimentFunction,
			Download[mySamples,Object],
			simulatedSamples,
			preresolvedAliquotOptions,
			Cache->cacheBall,
			Simulation->updatedSimulation,
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AliquotWarningMessage->aliquotWarningMessage,
			Output->Result
		],{}}
	],{Error::MissingRequiredAliquotAmounts,Error::SolidSamplesUnsupported,Error::InvalidInput}];


	(* - Verify the sample volume and blank volume - *)
	(* Note: We will throw a warning, if a BlankVolume is not equal to the sample volume. *)
	(* Obtain all sample volumes: if the samples are aliquoted, take the aliquot amount *)
	sampleVolumes=If[MemberQ[Flatten[{Lookup[resolvedAliquotOptions,Aliquot]}],False],
		Lookup[samplePackets,Volume],
		Lookup[resolvedAliquotOptions,AssayVolume]
	];

	(* Find sample objects *)
	sampleObjs=Lookup[samplePackets,Object];

	(* Track the invalid blank volumes *)
	mapThreadDiluents = Lookup[allResolvedMapThreadOptionsAssociation,Diluent];

	(* Do this only if blankVolumes is not {}|Null *)
	(* don't throw this warning if dilutions are happening *)
	{notEqualBlankVolumes,notEqualSamples}=If[MatchQ[mapThreadDiluents,{ObjectP[]...}],
		{{},{}},
		Module[{notEqualVolumeQ},
			If[!MatchQ[mapThreadBlankVolume,Null|{}],
				notEqualVolumeQ=Map[
					And[
						Not[Equal[sampleVolumes[[#]],mapThreadBlankVolume[[#]]]],
						!MatchQ[Lookup[mapThreadFriendlyOptions,BlankVolume][[#]],Automatic]
					]&,
					Range[Length[mapThreadBlankVolume]]
				];
				{PickList[mapThreadBlankVolume, notEqualVolumeQ],PickList[sampleObjs, notEqualVolumeQ]},
				{{},{}}
			]
		]
	];

	notEqualBlankVolumesWarning=Length[notEqualBlankVolumes]>0;

	(* Throw message *)
	If[notEqualBlankVolumesWarning&&messages&&notInEngine,
		Message[Warning::NotEqualBlankVolumes,notEqualBlankVolumes,notEqualSamples]
	];

	(* Create test *)
	notEqualBlankVolumesWarningTest=If[gatherTests,
		Warning["The blank volume is equivalent to the index-matched sample volume:",notEqualBlankVolumesWarning,False]
	];

	(* - Validate the injection samples - *)
	(* These checks must be done after aliquot options are resolved because we need to know AssayVolume *)
	(* Run a series of tests to make sure our injection options are properly specified *)

	(* If we aren't aliquoting, samples are all required to be in one container *)
	assayContainerModelPacket=If[MatchQ[Lookup[resolvedAliquotOptions,Aliquot],{True..}],
		aliquotContainerModelPacket,
		FirstCase[sampleContainerModelPackets,PacketP[],<||>]
	];

	{invalidInjectionOptions,validInjectionTests}=If[gatherTests,
		validPlateReaderInjections[myType,samplePackets,injectionSamplePackets,assayContainerModelPacket,ReplaceRule[Normal[nephelometryOptionsAssociation],Join[resolvedAliquotOptions,{RunTime->resolvedRunTime},{Diluent->mapThreadDiluents}]],Output->{Result,Tests}],
	 	{validPlateReaderInjections[myType,samplePackets,injectionSamplePackets,assayContainerModelPacket,ReplaceRule[Normal[nephelometryOptionsAssociation],Join[resolvedAliquotOptions,{RunTime->resolvedRunTime},{Diluent->mapThreadDiluents}]]],{}}
	];



	(* ----Resolve Remaining Independent Options---- *)

	(* SamplingDistance *)
	(* Resolve to Null if SamplingPattern->Center, else to 80% of the well diameter *)
	resolvedSamplingDistance=Switch[{resolvedSamplingPattern,samplingDistance},
		{_,Except[Automatic]},samplingDistance,
		{Center,_},Null,
		(* Use 80% of the well diameter, but make sure that's within the bounds allowed by BMG *)
		_,Clip[SafeRound[Lookup[assayContainerModelPacket,WellDiameter]*.8,1 Millimeter],{1 Millimeter,6 Millimeter}]
	];

	(* Use BMG's default if we're doing Matrix scanning otherwise this should be Null *)
	resolvedSamplingDimension=Switch[{resolvedSamplingPattern,samplingDimension},
		{_,Except[Automatic]},samplingDimension,
		{Matrix,_},3,
		_,Null
	];

	(* IntegrationTime *)
	(* write helper function to determine max integration time based on sampling pattern and distance *)
	maxIntegrationTime[samplingPattern_Symbol,samplingDistance_Quantity]:= Switch[{samplingPattern,samplingDistance},
		{Ring,1 Millimeter},0.08 Second,
		{Ring,2 Millimeter},0.16 Second,
		{Ring,3 Millimeter},0.26 Second,
		{Ring,4 Millimeter},0.34 Second,
		{Ring,5 Millimeter},0.44 Second,
		{Ring,6 Millimeter},0.52 Second,

		{Spiral,1 Millimeter},0.08 Second,
		{Spiral,2 Millimeter},0.26 Second,
		{Spiral,3 Millimeter},0.52 Second,
		{Spiral,4 Millimeter},0.86 Second,
		{Spiral,5 Millimeter},1.26 Second,
		{Spiral,6 Millimeter},1.76 Second,

		{_,_},10 Second
	];

	(* write helper function to determine if integration time is valid based on sampling pattern and distance *)
	validIntegrationTime[integrationTime_Quantity] := Greater[integrationTime,maxIntegrationTime[resolvedSamplingPattern,resolvedSamplingDistance]];

	(* resolve integration time *)
	{resolvedIntegrationTime, integrationTimeError} = Switch[{resolvedSamplingPattern,integrationTime,resolvedSamplingDistance},
		(* if SamplingPattern is Center, Null, or Matrix, and IntegrationTime is specified, accept it and set error to false *)
		{Null|Center|Matrix,Except[Automatic],_},
		{integrationTime,False},

		(* if SamplingPattern is Center, Null, or Matrix, and IntegrationTime is Automatic, set it to 1 Second and set error to false *)
		{Null|Center|Matrix,Automatic,_},
		{1 Second,False},

		(* if SamplingPattern is Ring or Spiral, and IntegrationTime is specified, check that it is not too long with helper function *)
		{Ring|Spiral,Except[Automatic],_},
		{integrationTime,validIntegrationTime[integrationTime]},

		(* if SamplingPattern is Ring or Spiral, and IntegrationTime is Automatic, set it based on BMG limits *)
		{Ring,Automatic,_}, {maxIntegrationTime[resolvedSamplingPattern,resolvedSamplingDistance], False},
		{Spiral,Automatic,1 Millimeter|2 Millimeter|3 Millimeter|4 Millimeter}, {maxIntegrationTime[resolvedSamplingPattern,resolvedSamplingDistance], False},
		(* for max integration time above 1 Second, just set it to 1 Second *)
		{Spiral,Automatic,5 Millimeter|6 Millimeter}, {1 Second, False},

		{_,_,_},{1 Second, False}
	];

	(* Throw error if integrationTimeError is True *)
	invalidIntegrationTimeOption=If[integrationTimeError,
		Message[Error::NephelometryIntegrationTimeTooLarge,resolvedSamplingPattern,resolvedSamplingDistance,maxIntegrationTime[resolvedSamplingPattern,resolvedSamplingDistance]];{IntegrationTime},
		{}
	];
	invalidIntegrationTimeTest=If[gatherTests,
		Test["The specified IntegrationTime must be less than the maximum integration time allowed by the instrument when SamplingPattern->Ring or Spiral.",integrationTimeError,False],
		{}
	];


	(* -- Resolve label options -- *)
	resolvedSampleLabels=Module[
		{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		suppliedSampleObjects = Download[mySamples, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["absorbance sample"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[object, Object]], _String],
					LookupObjectLabel[simulation, Download[object, Object]],
					True,
					Lookup[preResolvedSampleLabelRules, Download[object, Object]]
				]
			],
			{suppliedSampleObjects, Lookup[nephelometryOptionsAssociation, SampleLabel]}
		]
	];

	resolvedSampleContainerLabels=Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["absorbance sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preresolvedSampleContainerLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[object, Object]], _String],
					LookupObjectLabel[simulation, Download[object, Object]],
					True,
					Lookup[preResolvedContainerLabelRules, Download[object, Object]]
				]
			],
			{suppliedContainerObjects, Lookup[nephelometryOptionsAssociation, SampleContainerLabel]}
		]
	];

	resolvedBlankLabels = Module[{suppliedBlankObjects, uniqueBlanks, preResolvedUniqueBlankLabels, preResolvedBlankLabelRules},
		suppliedBlankObjects = Download[blankObjects,Object];
		uniqueBlanks = DeleteDuplicates[Cases[suppliedBlankObjects, ObjectP[]]];
		preResolvedUniqueBlankLabels = Table[CreateUniqueLabel["blank sample"], Length[uniqueBlanks]];
		preResolvedBlankLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueBlanks, preResolvedUniqueBlankLabels}
		];

		MapThread[
			Function[{blankObject, blankLabel},
				Which[
					MatchQ[blankLabel, Except[Automatic]],
					blankLabel,
					MatchQ[blankObject, Null],
					Null,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[blankObject, Object]], _String],
					LookupObjectLabel[simulation, Download[blankObject, Object]],
					True,
					Lookup[preResolvedBlankLabelRules, Download[blankObject, Object]]
				]
			],
			{suppliedBlankObjects, Lookup[nephelometryOptionsAssociation, BlankLabel]}
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* get the resolved Email option; for this experiment, the default is True *)
	email=If[MatchQ[Lookup[myOptions,Email],Automatic],
		True,
		Lookup[myOptions,Email]
	];

	(* Invalid input checks *)
	(* combine all the invalid options together *)
	invalidOptions=DeleteCases[
		DeleteDuplicates[Flatten[{
			nameInvalidOptions,
			compatibleMaterialsInvalidOption,
			blanksInvalidOptions,
			preparedPlateInvalidOptions,
			preparedPlateBlanksContainerOptions,
			noStandardCurveInvalidOptions,
			nonCellAnalyteInvalidOptions,
			incompatibleBlankVolumesInvalidOptions,
			incompatibleBlankInvalidOptions,
			quantRequiresBlankingInvalidOptions,
			plateReaderMixOptionInvalidities,
			dilutionVolumeTooLargeInvalidOptions,
			conflictingDilutionCurveInvalidOptions,
			missingDiluentInvalidOptions,
			missingDilutionCurveOptions,
			invalidMoatOptions,
			invalidIntegrationTimeOption,
			invalidSkippedInjection,
			invalidAliquotOption,
			invalidInjectionOptions,
			analyteMissingOptions,
			methodQuantificationMismatchInvalidOptions,
			(*cellCountQuantKineticsMismatchInvalidOptions,*)
			sampleContainsAnalyteOptions,
			cycleTimeTooHighOptions,
			tooManyKineticWindowsOptions,
			tooManyCyclesOptions,
			cycleTimingOptions,
			runTimeKineticWindowOptions,
			retainCoverInvalidOptions,
			resolvedACUInvalidOptions,
			duplicateDestinationWellOption,
			invalidDestinationWellLengthOption
		}]],
		Null
	];

	(* if there are any invalid options, throw Error::InvalidOption *)
	If[Not[MatchQ[invalidOptions,{}]]&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* combine all the invalid inputs together *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,nonLiquidSampleInvalidInputs, deprecatedInvalidInputs,preparedPlateInvalidContainerInputs}]];

	(* if there are any invalid inputs, throw Error::InvalidInput *)
	If[Not[MatchQ[invalidInputs,{}]]&&messages,
		Message[Error::InvalidInput,invalidInputs]
	];


	(* get the final resolved options, pre-collapsed (that is only happening outside this function) *)
	resolvedOptions=ReplaceRule[
		(* Recreate full set of options - necessary since we're using Append->False *)
		Join[Normal[roundedNephelometryOptions],samplePrepOptions],
		Join[
			{
				Instrument->instrument,
				Method->resolvedMethod,
				PreparedPlate->preparedPlate,
				BeamAperture->beamAperture,
				BeamIntensity->resolvedBeamIntensity,
				Temperature->resolvedTemperature,
				EquilibrationTime->resolvedTemperatureEquilibriumTime,
				Diluent->Lookup[allResolvedMapThreadOptionsAssociation,Diluent],
				DilutionCurve->Lookup[allResolvedMapThreadOptionsAssociation,DilutionCurve],
				SerialDilutionCurve->Lookup[allResolvedMapThreadOptionsAssociation,SerialDilutionCurve],
				ReadDirection->readDirection,
				PrimaryInjectionFlowRate->resolvedPrimaryFlowRate,
				SecondaryInjectionFlowRate->resolvedSecondaryFlowRate,
				TertiaryInjectionFlowRate->resolvedTertiaryFlowRate,
				QuaternaryInjectionFlowRate->resolvedQuaternaryFlowRate,
				PrimaryInjectionStorageCondition->primaryInjectionSampleStorageCondition,
				SecondaryInjectionStorageCondition->secondaryInjectionSampleStorageCondition,
				MoatBuffer->resolvedMoatBuffer,
				MoatVolume->resolvedMoatVolume,
				MoatSize->resolvedMoatSize,
				QuantifyCellCount->mapThreadQuantifyCellCount,
				Analyte->mapThreadAnalyte,
				InputConcentration->analyteConcentrationsConverted,
				BlankMeasurement->blankMeasurement,
				Blank->mapThreadBlank,
				BlankVolume->mapThreadBlankVolume,
				NumberOfReplicates->resolvedNumberOfReplicates,
				PlateReaderMix->resolvedPlateReaderMix,
				PlateReaderMixRate->resolvedPlateReaderMixRate,
				PlateReaderMixTime->resolvedPlateReaderMixTime,
				PlateReaderMixMode->resolvedPlateReaderMixMode,
				SamplingDistance -> resolvedSamplingDistance,
				SamplingPattern -> resolvedSamplingPattern,
				SamplingDimension -> resolvedSamplingDimension,
				IntegrationTime -> resolvedIntegrationTime,
				RetainCover -> specifiedRetainCover,
				Preparation->resolvedPreparation,
				WorkCell->resolvedWorkCell,
				SampleLabel->resolvedSampleLabels,
				SampleContainerLabel->resolvedSampleContainerLabels,
				BlankLabel->resolvedBlankLabels,
				Name->name,
				Email->email,
				Cache->cacheBall,
				Simulation->updatedSimulation,
				(* kinetics specific *)
				PlateReaderMixSchedule->resolvedPlateReaderMixSchedule,
				ReadOrder->readOrder,
				NumberOfCycles->resolvedNumberOfCycles,
				KineticWindowDurations->resolvedKineticWindowDurations,
				RunTime->resolvedRunTime,
				CycleTime->resolvedCycleTimes,
				TertiaryInjectionSample->tertiaryInjectionSample,
				QuaternaryInjectionSample->quaternaryInjectionSample
			},
			resolvedACUOptions,
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		],
		(* If one of our replacements isn't in our original set of options, this means it's experiment specific, so just drop it here by using Append->False *)
		Append->False
	];


	(* combine all the tests together  *)
	allTests=Cases[
		Flatten[{
			validSamplingComboTest,
			discardedTest,
			nonLiquidSampleTest,
			deprecatedTest,
			validPreparedPlateContainerTest,
			compatibleMaterialsTests,
			precisionTests,
			preparationTest,
			validNameTest,
			blanksInvalidTest,
			cycleTimeTooHighTest,
			plateReaderMixTests,
			retainCoverTest,
			validPreparedPlateTest,
			validPreparedPlateBlanksContainerTest,
			replicatesAliquotTest,
			sampleRepeatTest,
			resolvedAnalyteTests,
			noStandardCurveTest,
			nonCellAnalyteTest,
			methodQuantificationMismatchTest,
			blankContainerErrorTest,
			blankContainerWarningTest,
			incompatibleBlankOptionTests,
			blankStateWarningTest,
			skippedInjectionErrorTest,
			quantRequiresBlankingTest,
			analyteMissingOptionTests,
			sampleContainsAnalyteOptionTests,
			dilutionVolumeTooLargeTest,
			(*cellCountQuantKineticsMismatchTest,*)
			moatTests,
			notEqualBlankVolumesWarningTest,
			conflictingDilutionCurveTest,
			missingDiluentTest,
			missingDilutionCurveTest,
			validInjectionTests,
			resolvedACUTests,
			tooManyKineticWindowsTest,
			tooManyCyclesTest,
			cycleTimingTest,
			runTimeKineticWindowTest,
			invalidIntegrationTimeTest,
			duplicateDestinationWellTest,
			invalidDestinationWellLengthTest,
			plateReaderTemperatureNoEquilibrationTest
		}],
		_EmeraldTest
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		allTests,
		Null
	];


	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just Null *)
	resultRule=Result->If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(* return the output as we desire it *)
	outputSpecification/.{resultRule,testsRule}

];





(* ::Subsubsection:: *)
(*nephelometryResourcePackets (private helper) *)
DefineOptions[nephelometryResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];


(* private function to generate the list of protocol packets containing resource blobs *)
nephelometryResourcePackets[
	myType : (Object[Protocol, Nephelometry] | Object[Protocol, NephelometryKinetics]),
	mySamples : {ObjectP[Object[Sample]]..},
	myUnresolvedOptions : {___Rule},
	myResolvedOptions : {___Rule},
	ops:OptionsPattern[]
]:= Module[
	{
		expandedResolvedOptions,outputSpecification,output,gatherTests,messages,numReplicates,samplesInWithReplicates,simulation,updatedSimulation,
		liquidHandlerContainers,liquidHandlerContainerMaxVolumes,liquidHandlerContainerDownload,sampleCompositionPackets,samplePackets, analytePackets,
		instrumentOpt,injectionObjects,uniqueInjectionSamples,resolvedBlanks,blanksWithReplicates,blankVolumesWithReplicates,resolvedBlankVolumesFinal,
		blankMeasurement,maxNumBlankPlates,blankContainerModel,blankContainersResources,wasteContainer,secondaryWasteContainer,
		listedInstrumentPackets,instrumentModelPacket,instrumentModel,quantConcsWithReplicates,
		resolvedOptionsNoHidden,previewRule,optionsRule,testsRule,resultRule,simulationRule,allResourceBlobs,fulfillable,frqTests,
		expandedInputs,plateModels,injectionContainers,injectionContainerModels,method,
		quantAnalytesWithReplicates,injectionContainerLookup,containerModelLookup,aliquotQ,sampleVolumes,
		cache,sampleVolumeRules,sampleResourceReplaceRules,samplesInResources,maxVolumeContainerModelPackets,downloadedInjectionValues,
		blankContainerModelPackets,blankContainerModelPacket,numOccupiedWells,numberOfCycles,runTime,
		containersIn,estimatedReadingTime,readStartTime,equilibrationTime,plateReaderMixTime,kineticWindowDurations,cycleTimes,allBlankResources,
		numReplicatesNoNull,expandReplicatesFunction,finalizedPacket,pairedSamplesInAndVolumes,
		aliquotQWithReplicates,aliquotVolumeWithReplicates,simulatedSamples,
		pairedDilutionSamplesInAndVolumes,dilutionSampleVolumeRules,dilutionSampleResourceReplaceRules,dilutionSamplesInResources,
		listedSimulatedContainerPackets,listedSampleContainers,simulatedContainerPackets,containerObjs,
		pairedDiluentsAndVolumes,diluentVolumeRules,uniqueResources,uniqueObjects,uniqueObjectResourceReplaceRules,diluentResources,
		dilutionCurves,serialDilutionCurves,dilutionVolumes,serialDilutionVolumes,diluents,preparedPlate,requiredSampleVolumes,requiredDiluentVolumes,
		expandedSamplesInStorage,populateInjectionFieldFunction,primaryInjections,dilutionsAndInjectionsQ,
		dilutionCurveLengths,serialDilutionCurveLengths,numberOfDilutions,expandedPrimaryInjections,expandedSecondaryInjections,expandedTertiaryInjections,expandedQuaternaryInjections,allExpandedInjections,
		secondaryInjections,tertiaryInjections,quaternaryInjections,injectionSampleVolumeAssociation,allowedInjectionContainers,
		injectionSampleToResourceLookup,primaryInjectionWithResources,secondaryInjectionsWithResources,tertiaryInjectionsWithResources,
		quaternaryInjectionsWithResources,anyInjectionsQ,numberOfInjectionContainers,washVolume,sampleLabelsWithReplicates,blankLabelsWithReplicates,
		moatBuffer,moatVolume,moatSize,numberOfMoatWells,numberOfPlates,totalMoatVolume,moatBufferResource, analytes,
		totalDilutionWells,totalSerialDilutionWells,numberOfDilutionWells,requiredWells,maxNumDilutionPlates,dilutionContainersResources,
		line1PrimaryPurgingSolvent,line2PrimaryPurgingSolvent, line1SecondaryPurgingSolvent, line2SecondaryPurgingSolvent, injectorCleaningFields,experimentFunction,primitiveHead,
		resolvedPreparation,nonHiddenOptions,unitOperationPackets,rawResourceBlobs,resourcesWithoutName,resourceToNameReplaceRules,resourcesOk,resourceTests
	},

	(* get the experiment function that we care about *)
	{experimentFunction,primitiveHead} = Switch[myType,
		Object[Protocol, Nephelometry], {ExperimentNephelometry,Nephelometry},
		Object[Protocol, NephelometryKinetics], {ExperimentNephelometryKinetics,NephelometryKinetics}
	];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[experimentFunction, {mySamples}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		experimentFunction,
		RemoveHiddenOptions[experimentFunction, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* pull out the Output option and make it a list *)
	outputSpecification = OptionDefault[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* lookup cache and simulation *)
	simulation = Lookup[ToList[ops], Simulation];
	cache = Lookup[ToList[ops], Cache];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* pull out the Instrument option *)
	instrumentOpt = Lookup[expandedResolvedOptions, Instrument];

	(* Get unique list of all samples to be injected *)
	injectionObjects=DeleteCases[Flatten[Lookup[expandedResolvedOptions,{PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample},Null],1],Null];
	uniqueInjectionSamples=Download[Cases[injectionObjects,ObjectP[Object]],Object];

	(* simulate the samples after they go through all the sample prep *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[experimentFunction, mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation];

	(* Get all containers which can fit on the liquid handler *)
	liquidHandlerContainers = Experiment`Private`hamiltonAliquotContainers["Memoization"];

	(* look up the analytes *)
	analytes = Lookup[expandedResolvedOptions,Analyte];

	(* make a Download call to get the sample, container, and instrument packets *)
	{
		listedSimulatedContainerPackets,
		listedSampleContainers,
		listedInstrumentPackets,
		maxVolumeContainerModelPackets,
		downloadedInjectionValues,
		liquidHandlerContainerDownload,
		sampleCompositionPackets,
		samplePackets,
		analytePackets
	} = Quiet[
		Download[
			{
				simulatedSamples,
				mySamples,
				{instrumentOpt},
				Flatten[{BMGCompatiblePlates[Nephelometry]}],
				uniqueInjectionSamples,
				liquidHandlerContainers,
				mySamples,
				mySamples,
				analytes
			},
			{
				{Packet[Container[Model]]},
				{Container[Object]},
				{Packet[Model]},
				{Packet[MaxVolume]},
				{Container[Object],Container[Model][Object]},
				{MaxVolume},
				{Packet[Field[Composition]]},
				{Packet[Density,Volume]},
				{Packet[Density,MolecularWeight]}
			},
			Cache -> cache,
			Simulation->updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];


	(* extract out the packets *)
	simulatedContainerPackets = Flatten[listedSimulatedContainerPackets];
	containerObjs = Flatten[listedSampleContainers];
	instrumentModelPacket = listedInstrumentPackets[[1, 1]];

	(* Find the MaxVolume of all of the liquid handler compatible containers *)
	liquidHandlerContainerMaxVolumes = Flatten[liquidHandlerContainerDownload,1];

	(* Flatten our simulated information so that we can fetch it from cache. *)
	cache=FlattenCachePackets[{
		cache,
		listedSimulatedContainerPackets,
		listedSampleContainers,
		listedInstrumentPackets,
		maxVolumeContainerModelPackets,
		downloadedInjectionValues
	}];

	(* Get the instrument model *)
	instrumentModel = If[MatchQ[instrumentOpt, ObjectP[Model[Instrument, Nephelometer]]],
		instrumentOpt,
		Lookup[instrumentModelPacket, Model]
	];

	(* get the blank container model packets *)
	blankContainerModelPackets = Flatten[maxVolumeContainerModelPackets];

	(* get the plate models that we are currently in; don't need to check for validity because that already happened in the options function *)
	plateModels = Map[
		If[MatchQ[#, PacketP[]],
			Lookup[#, Model],
			Null
		]&,
		containerPackets
	];

	(* Get the injection containers and their models *)
	{injectionContainers,injectionContainerModels}={downloadedInjectionValues[[All,1]],downloadedInjectionValues[[All,2]]};

	(* Create lookups that will give container for each injection sample, model for each injection container *)
	injectionContainerLookup=AssociationThread[uniqueInjectionSamples,injectionContainers];
	containerModelLookup=AssociationThread[injectionContainers,injectionContainerModels];

	(* figure out if we are aliquoting or not *)
	aliquotQ = TrueQ[#]& /@ Lookup[expandedResolvedOptions, Aliquot];



	(* --- Make resources for SamplesIn --- *)

	(* get the number of replicates *)
	(* if NumberOfReplicates -> Null, replace that with 1 for the purposes of the math below *)
	numReplicates = Lookup[expandedResolvedOptions, NumberOfReplicates];
	numReplicatesNoNull = numReplicates /. {Null -> 1};

	expandReplicatesFunction[value_]:=Flatten[
		ConstantArray[#,numReplicatesNoNull]&/@value
	];

	(* get the SamplesIn accounting for the number of replicates *)
	samplesInWithReplicates = expandReplicatesFunction[Download[mySamples, Object]];

	(* get aliquotQ index matched with the SamplesIn with replicates *)
	aliquotQWithReplicates = expandReplicatesFunction[aliquotQ];

	(* get the aliquotVolume with replicates *)
	aliquotVolumeWithReplicates = expandReplicatesFunction[Lookup[expandedResolvedOptions, AliquotAmount]];

	(* get the sample volumes we need to reserve with each sample, accounting for the number of replicates and whether we're aliquoting *)
	sampleVolumes = MapThread[
		Function[{aliquot, volume},
			If[aliquot, volume, Null]
		],
		{aliquotQWithReplicates, aliquotVolumeWithReplicates}
	];

	(* make rules correlating the volumes with each sample in *)
	(* note that we CANNOT use AssociationThread here because there might be duplicate keys (we will Merge them down below), and so we're going to lose duplicate volumes *)
	pairedSamplesInAndVolumes = MapThread[#1 -> #2&, {samplesInWithReplicates, sampleVolumes}];

	(* merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	(* need to do this with thing with Nulls in our Merge because otherwise we'll end up with Total[{Null, Null}], which would end up being 2*Null, which I don't want *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, If[NullQ[#], Null, Total[DeleteCases[#, Null]]]&];

	(* make replace rules for the samples and its resources *)
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


	(* --- Generate the fields for blanks --- *)

	(* pull out the resolved BlankMeasurement, Blanks, and BlankVolumes options *)
	{blankMeasurement, resolvedBlanks, resolvedBlankVolumesFinal} = Lookup[expandedResolvedOptions, {BlankMeasurement, Blank, BlankVolume}];

	(* get the Blanks accounting for the number of replicates *)
	(* need to Download Object as well *)
	blanksWithReplicates = If[MatchQ[resolvedBlanks, {Null...} | Null],
		{},
		expandReplicatesFunction[Download[resolvedBlanks, Object]]
	];

	(* get the blank volumes with the number of replicates *)
	blankVolumesWithReplicates = expandReplicatesFunction[resolvedBlankVolumesFinal];

	(* expand the analytes to the QuantifyCellCount *)
	quantConcsWithReplicates = expandReplicatesFunction[Lookup[expandedResolvedOptions, QuantifyCellCount]];
	quantAnalytesWithReplicates = Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
		Lookup[expandedResolvedOptions, Analyte]
	]];

	(* --- Make resources for the rack + blank plate --- *)

	(* get the number of blank plates I need; at most, will need one plate for every 96 blanks, though we could need less if there are empty wells in the plate once we get to run time *)
	(* only need these if we are  blanking *)
	maxNumBlankPlates = If[blankMeasurement,
		Ceiling[Length[samplesInWithReplicates] / 96],
		0
	];

	(* get the blank container model *)
	(* if not blanking, just Null *)
	(* otherwise use whatever the simulated sample's container model is *)
	blankContainerModel = If[Not[blankMeasurement],
		Null,
		Download[Lookup[First[simulatedContainerPackets], Model], Object]
	];

	(* get the blank container model packet *)
	blankContainerModelPacket = If[NullQ[blankContainerModel],
		Null,
		FirstCase[blankContainerModelPackets, ObjectP[blankContainerModel], Null]
	];

	(* make resources for the BlankContainers if we are using BMG; use whatever plate model we were already using *)
	blankContainersResources = If[maxNumBlankPlates == 0,
		{},
		ConstantArray[Resource[Sample -> blankContainerModel, Rent -> False], maxNumBlankPlates]
	];

	(* get the number of wells occupied *)
	numOccupiedWells = (Length[samplesInResources] + Length[blanksWithReplicates]);

	(* get the containers in from the sample's containers *)
	containersIn = DeleteDuplicates[containerObjs];

	(* Calculate instrument time *)
	(* look up relevant times *)
	(* shared options *)
	{readStartTime,equilibrationTime,plateReaderMixTime} = Lookup[expandedResolvedOptions, {ReadStartTime, EquilibrationTime, PlateReaderMixTime}];

	(* kinetics options *)
	{kineticWindowDurations,cycleTimes,numberOfCycles,runTime} = If[
		MatchQ[myType],Object[Protocol,NephelometryKinetics],
		Lookup[expandedResolvedOptions, {KineticWindowDurations, CycleTime, NumberOfCycles, RunTime}],
		{{0Second}, {0Second}, {0}, 0 Second}
	];

	(* get the estimated reading time *)
	estimatedReadingTime = Total[{
		(5 * Minute * Length[containersIn]),
		readStartTime,
		equilibrationTime,
		plateReaderMixTime,
		runTime,
		10 * Minute}/.Null->0Second
	];

	(* --- Make resources for the blanks --- *)
	allBlankResources = Module[
		{blankVolumeRules, mergedBlankVolumes, blanksNoDupes, talliedBlankResources, blankPositions, blankResourceReplaceRules},

		(* need to combine the blanks and how much volume we need for each of them together *)
		(* Remove any duplicate sample-volume pairs since we only need one instance for blanking *)
		blankVolumeRules = DeleteDuplicates[
			MapThread[
				#1 -> #2&,
				{Download[resolvedBlanks,Object],resolvedBlankVolumesFinal}
			]
		];

		(* group and sum the volumes where the blank model is the same *)
		mergedBlankVolumes = Merge[blankVolumeRules, Total];

		(* get the blanks without dupes *)
		blanksNoDupes = Keys[mergedBlankVolumes];

		(* create a resource for each of the different kinds of blanks for each split protocol *)
		talliedBlankResources = KeyValueMap[
			(* doing this With call to ensure that I only have to call AchievableResolution once per loop since it is kind of slow *)
			(* we're going to make as many blanks as replicates so must multiply volume by this amount *)
			With[{achievableResolution = AchievableResolution[#2 * 1.1 * numReplicatesNoNull, Messages -> False]},
				If[MatchQ[#1,Null],
					#1,
					Resource@@{
						Sample -> #1,
						If[MatchQ[achievableResolution,VolumeP],
							Amount -> achievableResolution,
							Nothing
						],
						If[MatchQ[#1,ObjectP[Model]],
							Container -> PreferredContainer[achievableResolution],
							Nothing
						],
						Name -> ToString[Unique[]]
					}
				]
			]&,
			mergedBlankVolumes
		];

		(* get the position of each of the models in the list of blanks *)
		blankPositions = Map[
			Position[blanksWithReplicates, #]&,
			blanksNoDupes
		];

		(* make replace rules converting the blank models to their resources to be used in ReplacePart below *)
		blankResourceReplaceRules = MapThread[
			#1 -> #2&,
			{blankPositions, talliedBlankResources}
		];

		(* use ReplacePart to return the blank resources *)
		ReplacePart[blanksWithReplicates, blankResourceReplaceRules]

	];

	(* expand SamplesInStorage with NumberOfReplicates *)
	expandedSamplesInStorage=expandReplicatesFunction[Lookup[expandedResolvedOptions, SamplesInStorageCondition]];

	(* == Define Function: populateInjectionFieldFunction == *)
	(* Format a set of injection options into the structure used for the corresponding injection field *)
	(* Kinetics overload - field formatted as {{time, sample, volume}..}*)
	populateInjectionFieldFunction[Object[Protocol,NephelometryKinetics],injectionVolumesNoReplicates_,injectionSamplesNoReplicates_,injectionTime_]:=Module[
		{injectionVolumes,injectionSamples,injectionSampleObjects,injectionSample,injectionTuples,injectionFieldValue},

		injectionVolumes=expandReplicatesFunction[injectionVolumesNoReplicates];
		injectionSamples=expandReplicatesFunction[injectionSamplesNoReplicates];

		injectionSampleObjects=Download[injectionSamples,Object];

		(* Sample we're injecting (injectionSampleObjects will be a mix of Nulls and repeated object) *)
		injectionSample=FirstCase[injectionSampleObjects,ObjectP[]];

		injectionTuples=Prepend[#,injectionTime]&/@Transpose[{injectionSampleObjects,injectionVolumes}];

		injectionFieldValue=If[MemberQ[injectionVolumes,VolumeP],
			(* Replace {Null,Null,Null} with {time, sample, 0 Microliter} as a placeholder to keep index-matching *)
			Replace[injectionTuples, {TimeP,Null, Null} :> {injectionTime, Null, 0 Microliter}, {1}],
			{}
		]
	];

	(* == Define Function: populateInjectionFieldFunction == *)
	(* Format a set of injection options into the structure used for the corresponding injection field *)
	(* Nephelometry overload - field formatted as {{sample, volume}..} *)
	populateInjectionFieldFunction[Object[Protocol,Nephelometry],injectionVolumesNoReplicates_,injectionSamplesNoReplicates_,injectionTimeNoReplicates_]:=Module[
		{injectionVolumes,injectionSamples,injectionTime,injectionSampleObjects,injectionSample,injectionFieldValue},

		injectionVolumes=expandReplicatesFunction[injectionVolumesNoReplicates];
		injectionSamples=expandReplicatesFunction[injectionSamplesNoReplicates];
		injectionTime=expandReplicatesFunction[injectionTimeNoReplicates];

		injectionSampleObjects=Download[injectionSamples,Object];

		injectionSample=FirstCase[injectionSampleObjects,ObjectP[]];

		injectionFieldValue=If[MemberQ[injectionVolumes,VolumeP],
			(* Replace {Null,Null} with {sample, 0 Microliter} as a placeholder to keep index-matching *)
			Replace[Transpose[{injectionSampleObjects,injectionVolumes}], {Null, Null} :> {Null, 0 Microliter}, {1}],
			{}
		]
	];

	(* lookup dilution curves *)
	dilutionCurves = Lookup[expandedResolvedOptions,DilutionCurve];
	serialDilutionCurves = Lookup[expandedResolvedOptions,SerialDilutionCurve];
	diluents = Lookup[expandedResolvedOptions,Diluent];

	(* determine the number of dilutions *)
	dilutionCurveLengths = If[NullQ[diluents],Null,Map[Length,dilutionCurves/.Null->{}]];
	serialDilutionCurveLengths = If[NullQ[diluents],Null,Map[serialNumberOfDilutions,serialDilutionCurves]];

	(* Thread the lengths together to get the number of dilutions *)
	numberOfDilutions = If[NullQ[diluents],Null,MapThread[If[MatchQ[#1,0],#2,#1]&,{dilutionCurveLengths,serialDilutionCurveLengths}]];

	(* Track whether or not we're injecting anything *)
	anyInjectionsQ=MemberQ[Flatten[Lookup[expandedResolvedOptions,{PrimaryInjectionVolume,SecondaryInjectionVolume,TertiaryInjectionVolume,QuaternaryInjectionVolume}]],VolumeP];

	(* determine if there are injections and dilutions *)
	dilutionsAndInjectionsQ = If[anyInjectionsQ&&!NullQ[diluents],True,False];

	(* Format injections as tuples index-matched to samples in. These will look different depending on the experiment:
		NephKinetics is in the form {{time, sample, volume}..}
		Neph is in the form {{sample, volume}..}
	*)
	(* Note: wells which aren't receiving injections will have sample=Null, volume=0 Microliter *)
	primaryInjections=populateInjectionFieldFunction[myType,Lookup[expandedResolvedOptions,PrimaryInjectionVolume],Lookup[expandedResolvedOptions,PrimaryInjectionSample],Lookup[expandedResolvedOptions,PrimaryInjectionTime]];
	secondaryInjections=populateInjectionFieldFunction[myType,Lookup[expandedResolvedOptions,SecondaryInjectionVolume],Lookup[expandedResolvedOptions,SecondaryInjectionSample],Lookup[expandedResolvedOptions,SecondaryInjectionTime]];
	tertiaryInjections=populateInjectionFieldFunction[myType,Lookup[expandedResolvedOptions,TertiaryInjectionVolume],Lookup[expandedResolvedOptions,TertiaryInjectionSample],Lookup[expandedResolvedOptions,TertiaryInjectionTime]];
	quaternaryInjections=populateInjectionFieldFunction[myType,Lookup[expandedResolvedOptions,QuaternaryInjectionVolume],Lookup[expandedResolvedOptions,QuaternaryInjectionSample],Lookup[expandedResolvedOptions,QuaternaryInjectionTime]];

	(* expand the injections if there are dilutions and injections, as injections will go in all dilution wells indexed to samples in, so that extra volume needs to be accounted for *)
	expandedPrimaryInjections = If[!dilutionsAndInjectionsQ,{},Flatten[MapThread[ConstantArray[#1,#2]&,{primaryInjections,numberOfDilutions}],1]];
	expandedSecondaryInjections = If[MatchQ[secondaryInjections,{}]||!dilutionsAndInjectionsQ,{},Flatten[MapThread[ConstantArray[#1,#2]&,{secondaryInjections,numberOfDilutions}],1]];
	expandedTertiaryInjections = If[MatchQ[tertiaryInjections,{}]||!dilutionsAndInjectionsQ,{},Flatten[MapThread[ConstantArray[#1,#2]&,{tertiaryInjections,numberOfDilutions}],1]];
	expandedQuaternaryInjections = If[MatchQ[quaternaryInjections,{}]||!dilutionsAndInjectionsQ,{},Flatten[MapThread[ConstantArray[#1,#2]&,{quaternaryInjections,numberOfDilutions}],1]];

	(* join the expanded injections *)
	allExpandedInjections = Join[expandedPrimaryInjections,expandedSecondaryInjections,expandedTertiaryInjections,expandedTertiaryInjections,expandedQuaternaryInjections];

	(* Get assoc in the form <|(sample -> total volume needed)..|> *)
	(* Note: regardless of experiment, second to last entry will be sample, last entry will be volume *)
	(* if there are dilutions, use the expanded form *)
	injectionSampleVolumeAssociation=KeyDrop[GroupBy[If[NullQ[diluents],Join[primaryInjections,secondaryInjections,tertiaryInjections,quaternaryInjections],allExpandedInjections],(#[[-2]]&)->(#[[-1]]&), Total],Null];

	(* Track containers which can be used to hold injection samples - plate readers have spots for 2mL, 15mL and 50mL tubes *)
	allowedInjectionContainers=Search[Model[Container, Vessel],Footprint==(Conical50mLTube|Conical15mLTube|MicrocentrifugeTube)&&Deprecated!=True];

	(* Create a single resource for each unique injection sample *)
	injectionSampleToResourceLookup=KeyValueMap[
		Module[{sample,volume,injectionContainer,injectionContainerModel,resource},
			{sample,volume}={#1,#2};

			(* Lookup sample's container model *)
			injectionContainer=Lookup[injectionContainerLookup,sample];
			injectionContainerModel=Lookup[containerModelLookup,injectionContainer,Null];

			(* Create a resource for the sample *)
			resource=If[MatchQ[sample,Null],
				Null,
				Resource@@{
					Sample->sample,
					(* Include volume lost due to priming lines (compiler sets to 1mL)
					- prime should account for all needed dead volume - prime fluid stays in syringe/line (which have vol of ~750 uL) *)
					Amount->(volume + $BMGPrimeVolume),

					(* Specify a container if we're working with a model or if current container isn't workable *)
					If[MatchQ[injectionContainerModel,ObjectP[allowedInjectionContainers]],
						Nothing,
						Container -> PreferredContainer[(volume + $BMGPrimeVolume),Type->Vessel]
					],
					Name->ToString[sample]
				}
			];
			sample->resource
		]&,
		injectionSampleVolumeAssociation
	];

	(* Replace injection samples with resources for those samples *)
	{primaryInjectionWithResources,secondaryInjectionsWithResources,tertiaryInjectionsWithResources,quaternaryInjectionsWithResources}=Map[
		Function[{injectionEntries},
			If[MatchQ[injectionEntries,{}],
				{},
				Module[{injectionSample,injectionResource},
					(* Get injection sample for the group  - regardless of experiment, second to last entry will be sample, last entry will be volume *)
					injectionSample=FirstCase[injectionEntries[[All,-2]],ObjectP[]];

					(* Find resource created for that sample *)
					injectionResource=Lookup[injectionSampleToResourceLookup,injectionSample];

					(* Replace any injection objects with corresponding resource *)
					Replace[injectionEntries,{time___,ObjectP[],volume___}:>{time,injectionResource,volume},{1}]
				]
			]
		],
		{primaryInjections,secondaryInjections,tertiaryInjections,quaternaryInjections}
	];

	(*  --- Create resources to clean the injectors and lines --- *)

	(* injectionSampleVolumeAssociation gives unique injection samples *)
	numberOfInjectionContainers = Length[injectionSampleVolumeAssociation];

	(* Wash each line being used with the flush volume - request a little extra to avoid air in the lines *)
	(* Always multiply by 2 - either we'll use same resource for prepping and flushing or we have two lines to flush *)
	washVolume=($BMGFlushVolume + 2.5 Milliliter) * 2;

	(* look up method *)
	method = Lookup[expandedResolvedOptions,Method];

	(* Create solvent resources to clean the lines *)
	line1PrimaryPurgingSolvent=Resource@@{
		Sample->If[
			MatchQ[method,CellCount], (* If we have cell samples, use bleach to clean the lines just in case *)
			Model[Sample, StockSolution, "id:qdkmxzq7lWRp"], (* 10% Bleach *)
			Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"] (* 70% Ethanol *)
		],
		Amount->washVolume,
		Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
		Name->"Line1 Primary Purging Solvent"
	};
	line2PrimaryPurgingSolvent = If[numberOfInjectionContainers==2,
		Resource@@{
			Sample->If[
				MatchQ[method,CellCount], (* If we have cell samples, use bleach to clean the lines just in case *)
				Model[Sample, StockSolution, "id:qdkmxzq7lWRp"], (* 10% Bleach *)
				Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"] (* 70% Ethanol *)
			],
			Amount->washVolume,
			Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
			Name->"Line2 Primary Purging Solvent"
		},
		Null
	];

	line1SecondaryPurgingSolvent=Resource@@{
		Sample->Model[Sample,"id:8qZ1VWNmdLBD"] (*Milli-Q water *),
		Amount->washVolume,
		Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
		Name->"Line1 Secondary Purging Solvent"
	};
	line2SecondaryPurgingSolvent = If[numberOfInjectionContainers==2,
		Resource@@{
			Sample->Model[Sample,"id:8qZ1VWNmdLBD"] (*Milli-Q water *),
			Amount->washVolume,
			Container->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
			Name->"Line2 Secondary Purging Solvent"
		},
		Null
	];


	(* Populate fields needed to clean the lines before/after the run *)
	(* If we're only cleaning 1 line we can use a single 50mL to hold prepping and flushing solvent *)
	injectorCleaningFields=If[anyInjectionsQ,
		<|
			Line1PrimaryPurgingSolvent->line1PrimaryPurgingSolvent,
			Line2PrimaryPurgingSolvent->line2PrimaryPurgingSolvent,
			Line1SecondaryPurgingSolvent->line1SecondaryPurgingSolvent,
			Line2SecondaryPurgingSolvent ->line2SecondaryPurgingSolvent
		|>,
		<||>
	];

	(* If we're doing injections, make waste beaker resources *)
	{wasteContainer,secondaryWasteContainer}=Which[
		MatchQ[primaryInjections,{}],
		{Null,Null},

		(* Making waste samples in two 100 mL Pyrex beakers for Nephelostar with multiple unique injections *)
		Length[uniqueInjectionSamples]>1,
		{Resource[Sample -> Model[Container,Vessel,"id:aXRlGnZmOOJk"], Rent -> True], Resource[Sample->Model[Container,Vessel,"id:aXRlGnZmOOJk"],Rent->True]},

		(* Making waste samples in one beaker *)
		True,
		{Resource[Sample -> Model[Container,Vessel,"id:aXRlGnZmOOJk"], Rent -> True], Null}
	];


	(* Diluent Resource *)

	(* determine dilution volumes *)
	dilutionVolumes = If[NullQ[diluents],Null,Map[Transpose,calculateDilutionVolumes[#]&/@dilutionCurves]];
	serialDilutionVolumes = If[NullQ[diluents],Null,Map[Transpose,calculateDilutionVolumes[#]&/@serialDilutionCurves]];

	(* lookup diluents *)
	preparedPlate = Lookup[expandedResolvedOptions,PreparedPlate];

	(* Set up a MapThread to determine required volumes *)
	{requiredSampleVolumes,requiredDiluentVolumes} = If[
		NullQ[diluents],
		{ConstantArray[0Microliter,Length[diluents]],ConstantArray[0Microliter,Length[diluents]]},

		Transpose[
			MapThread[
				Function[{serialDilutionCurve, dilutionCurve},
					Module[{requiredSampleVolume,requiredDiluentVolume},

						(*Determine the liquid volumes needed *)
						{requiredSampleVolume,requiredDiluentVolume}=Which[

							(*Is a serial Dilution specified?*)
							MatchQ[serialDilutionCurve,Except[Null]], {
								(*the first curve volume*)
								First[First[calculateDilutionVolumes[serialDilutionCurve]]],

								(*all the diluent volumes used for mixing*)
								Total[Last[calculateDilutionVolumes[serialDilutionCurve]]]
							},

							(*Is a custom Dilution specified?*)
							MatchQ[dilutionCurve,Except[Null]],{
								(*all the sample volumes added together*)
								Total[First[calculateDilutionVolumes[dilutionCurve]]],

								(*all the diluent volumes added together*)
								Total[Last[calculateDilutionVolumes[dilutionCurve]]]
							},

							(*Is the plate prepared*)
							preparedPlate, {0Microliter,0Microliter},

							(*Is there no diluting*)
							True,{0Microliter,0Microliter}
						];

						{requiredSampleVolume,requiredDiluentVolume}
					]
				],
				{serialDilutionCurves, dilutionCurves}
			]
		]
	];

	(* -- Generate resources for the SamplesIn if Dilutions are happening -- *)
	(* Pair the SamplesIn and their Volumes *)
	pairedDilutionSamplesInAndVolumes = If[NullQ[diluents],Null,MapThread[
		#1 -> SafeRound[#2*1.1,10^-1 Microliter]&,
		{samplesInWithReplicates, requiredSampleVolumes}
	]];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	dilutionSampleVolumeRules = If[NullQ[diluents],Null,Merge[pairedDilutionSamplesInAndVolumes, Total]];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	dilutionSampleResourceReplaceRules = If[NullQ[diluents],Null,KeyValueMap[
		Function[{sample, volume},
			If[VolumeQ[volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]]]
			]
		],
		dilutionSampleVolumeRules
	]];

	(* Use the replace rules to get the sample resources *)
	dilutionSamplesInResources = If[NullQ[diluents],Null,Replace[samplesInWithReplicates, dilutionSampleResourceReplaceRules, {1}]];


	(* Pair the diluents and their Volumes *)
	pairedDiluentsAndVolumes = MapThread[
		#1 -> SafeRound[#2*1.1,10^-1 Microliter]&,
		{diluents, requiredDiluentVolumes}
	];

	(* Merge the diluent volumes together to get the total volume of each sample's resource, getting rid of any Rules with the pattern Null->_ or __->0*Microliter *)
	diluentVolumeRules = DeleteCases[
		KeyDrop[
			Merge[pairedDiluentsAndVolumes, Total],
			Null
		],
		0*Microliter
	];

	(* - Use this association to make Resources for each unique Object or Model Key - *)
	uniqueResources = KeyValueMap[
		Module[{amount,containers},
			amount=#2;
			containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];
			Link[Resource[Sample->#1,Amount->amount,Container->containers,Name->ToString[Unique[]]]]
		]&,
		diluentVolumeRules
	];

	(* -- Define a list of replace rules for the unique Model and Objects with the corresponding Resources --*)
	(* - Find a list of the unique Object/Model Keys - *)
	uniqueObjects = Keys[diluentVolumeRules];

	(* - Make a list of replace rules, replacing unique objects with their respective Resources - *)
	uniqueObjectResourceReplaceRules = MapThread[
		(#1->#2)&,
		{uniqueObjects,uniqueResources}
	];

	(* -- Use the unique object replace rules to make lists of the resources of the inputs and the options / fields that are objects -- *)
	(* - For the inputs and options that are lists, Map over replacing the options with the replace rules at level {1} to get the corresponding list of resources - *)
	{diluentResources} = Map[
		Replace[#,uniqueObjectResourceReplaceRules,{1}]&,
		{diluents}
	];


	(* Dilution Containers Resource *)
	(* determine the number of wells for dilution curves *)
	totalDilutionWells = If[!NullQ[dilutionCurves],
		Total[Map[Length, dilutionCurves/.Null->{}]],
		0
	];

	totalSerialDilutionWells = If[!NullQ[serialDilutionCurves],
		Total[Map[serialNumberOfDilutions, serialDilutionCurves]],
		0
	];

	(* total the number of wells for serial and normal dilution *)
	numberOfDilutionWells = Total[{totalDilutionWells,totalSerialDilutionWells}];

	(*get how many dilution wells are needed for the dilution of the sample be multiplying the required wells for the curve by the number of replicates*)
	requiredWells = numberOfDilutionWells*If[MatchQ[numReplicates,Null],1,numReplicates];

	(* get the number of dilution plates I need; at most, will need one plate for every 96 dilution wells *)
	(* only need these if dilutions are happening *)
	maxNumDilutionPlates = If[!NullQ[diluents],
		Ceiling[requiredWells / 96],
		0
	];

	(* make resources for the DilutionContainers; use whatever plate model we used for blanks *)
	dilutionContainersResources = If[maxNumDilutionPlates == 0,
		{},
		ConstantArray[Resource[Sample -> blankContainerModel, Rent -> False], maxNumDilutionPlates]
	];


	(* -- Moat Buffer Resource -- *)
	(* look up relevant info *)
	{moatBuffer,moatVolume,moatSize} = Lookup[expandedResolvedOptions,{MoatBuffer,MoatVolume,MoatSize}];

	(* use helper function to determine how many wells will be filled with moat buffer *)
	numberOfMoatWells = If[NullQ[moatBuffer],0,Length[Flatten[getMoatWells[AllWells[blankContainerModel],moatSize]]]];

	(* figure out the number of plates that will be used to get the total number of moat wells *)
	(* if there are diluents, use dilution plates, if not, count containers in. add in blank plates *)
	numberOfPlates = If[NullQ[diluents],Total[Length[containersIn],maxNumBlankPlates],Total[maxNumDilutionPlates,maxNumBlankPlates]];

	(* calculate the total volume needed plus some extra *)
	totalMoatVolume = (moatVolume*numberOfMoatWells*numberOfPlates*1.1);

	(* - Make resource for moat buffer - *)
	moatBufferResource = If[NullQ[moatBuffer],
		Null,
		Link[
			Resource[
				Sample-> moatBuffer,
				Amount-> totalMoatVolume,
				Container-> First[PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[totalMoatVolume]]],
				Name->ToString[Unique[]]
			]
		]
	];


	(* Lookup if we're doing the experiment robotically, if so, we need to make waste container resources here and create label->resource rules *)
	resolvedPreparation = Lookup[myResolvedOptions,Preparation];

	(* -- Generate our unit operation packet -- *)

	(* get the non hidden options *)
	nonHiddenOptions=Lookup[
		Cases[OptionDefinition[experimentFunction], KeyValuePattern["Category"->Except["Hidden"]]],
		"OptionSymbol"
	];

	(* expand sample labels for replicates *)
	sampleLabelsWithReplicates = expandReplicatesFunction[Lookup[myResolvedOptions, SampleLabel]];
	blankLabelsWithReplicates = expandReplicatesFunction[Lookup[myResolvedOptions, BlankLabel]];

	(* --- Generate our protocol packet --- *)
	{finalizedPacket, unitOperationPackets}=If[MatchQ[resolvedPreparation, Manual],
		Module[{standardFields,nephSpecificFields,kineticsFields,protocolPacket,sharedFieldPacket},
			(* fill in the protocol packet with all the resources *)
			(* Fields shared between Object[Protocol,Nephelometry] and Object[Protocol,NephelometryKinetics] *)
			standardFields = <|
				(* ---Shared options--- *)
				Object -> CreateID[myType],
				Type -> myType,
				Template -> If[MatchQ[Lookup[resolvedOptionsNoHidden, Template], FieldReferenceP[]],
					Link[Most[Lookup[resolvedOptionsNoHidden, Template]], ProtocolsTemplated],
					Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated]
				],
				UnresolvedOptions -> myUnresolvedOptions,
				ResolvedOptions -> resolvedOptionsNoHidden,
				Replace[SamplesIn] -> (Link[#, Protocols]& /@ If[NullQ[diluents],samplesInResources,dilutionSamplesInResources]),
				Operator->Link[Lookup[myResolvedOptions,Operator]],
				Replace[Checkpoints] -> {
					{"Preparing Samples", 30 Minute, "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
					{"Picking Resources", 20 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 20 Minute]]},
					{"Preparing Assay Plate", If[NullQ[diluentResources]||NullQ[Lookup[expandedResolvedOptions, MoatBuffer]],0 Minute, 30 Minute], "The plate is prepared with moats and dilutions as specified.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
					{"Acquiring Data", estimatedReadingTime, "Nephelometry measurements are taken for samples.", Link[Resource[Operator -> $BaselineOperator, Time -> estimatedReadingTime]]},
					{"Sample Post-Processing", 30 Minute, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 5 * Minute]]},
					{"Returning Materials", 20 Minute, "Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 * Minute]]}
				},
				Replace[ContainersIn] -> (Link[Resource[Sample -> #], Protocols]&) /@ containersIn,
				ImageSample -> Lookup[expandedResolvedOptions, ImageSample],
				Replace[SamplesInStorage] -> expandedSamplesInStorage,

				(* ---General--- *)
				Instrument -> Link[Resource[Instrument -> instrumentOpt, Time -> estimatedReadingTime]],
				DataCollectionTime -> estimatedReadingTime,
				Method -> Lookup[myResolvedOptions,Method],
				PreparedPlate -> Lookup[myResolvedOptions,PreparedPlate],
				Replace[Analytes] -> (Link[#]& /@expandReplicatesFunction[Lookup[expandedResolvedOptions, Analyte]]),
				NumberOfReplicates -> numReplicates,
				RetainCover -> Lookup[expandedResolvedOptions,RetainCover],

				(* ---Optics--- *)
				BeamAperture -> Lookup[myResolvedOptions,BeamAperture],
				BeamIntensity -> Lookup[myResolvedOptions,BeamIntensity],

				(* ---Quantification--- *)
				Replace[QuantifyCellCount] -> Lookup[expandedResolvedOptions, QuantifyCellCount],

				(* ---Sample Preparation--- *)
				Replace[Dilutions] -> dilutionVolumes/.{ListableP[Null]} -> Null,
				Replace[SerialDilutions] -> serialDilutionVolumes/.{ListableP[Null]} -> Null,
				Replace[Diluents] -> diluentResources,
				Replace[DilutionContainers] -> dilutionContainersResources,
				Replace[SampleAmounts] -> If[NullQ[diluentResources],Null,requiredSampleVolumes],
				Replace[TotalVolumes] -> {MapThread[Total[{#1, #2}]&, {requiredSampleVolumes, requiredDiluentVolumes}]},
				Replace[InputConcentrations] -> expandReplicatesFunction[Lookup[expandedResolvedOptions, InputConcentration]],

				(* ---Measurement--- *)
				Temperature -> Lookup[expandedResolvedOptions, Temperature],
				EquilibrationTime -> Lookup[expandedResolvedOptions, EquilibrationTime],
				TargetCarbonDioxideLevel -> Lookup[myResolvedOptions, TargetCarbonDioxideLevel],
				TargetOxygenLevel -> Lookup[myResolvedOptions, TargetOxygenLevel],
				AtmosphereEquilibrationTime -> Lookup[myResolvedOptions, AtmosphereEquilibrationTime],
				PlateReaderMix -> Lookup[expandedResolvedOptions, PlateReaderMix],
				PlateReaderMixRate -> Lookup[expandedResolvedOptions, PlateReaderMixRate],
				PlateReaderMixTime -> Lookup[expandedResolvedOptions, PlateReaderMixTime],
				PlateReaderMixMode -> Lookup[expandedResolvedOptions, PlateReaderMixMode],
				MoatBuffer -> moatBufferResource,
				MoatSize -> Lookup[expandedResolvedOptions, MoatSize],
				MoatVolume -> Lookup[expandedResolvedOptions, MoatVolume],
				ReadDirection -> Lookup[expandedResolvedOptions,ReadDirection],
				SettlingTime -> Lookup[expandedResolvedOptions,SettlingTime],
				ReadStartTime -> Lookup[expandedResolvedOptions,ReadStartTime],
				(*PauseTime->SafeRound[(Lookup[expandedResolvedOptions,ReadStartTime]-Lookup[expandedResolvedOptions,SettlingTime]),0.1Second],*)
				IntegrationTime -> Lookup[expandedResolvedOptions,IntegrationTime],

				(* ---Injections--- *)
				PrimaryInjectionSample->Link[First[Lookup[expandedResolvedOptions,PrimaryInjectionSample]]],
				SecondaryInjectionSample->Link[First[Lookup[expandedResolvedOptions,SecondaryInjectionSample]]],
				Replace[PrimaryInjections]->primaryInjectionWithResources,
				Replace[SecondaryInjections]->secondaryInjectionsWithResources,
				PrimaryInjectionFlowRate->Lookup[expandedResolvedOptions,PrimaryInjectionFlowRate],
				SecondaryInjectionFlowRate->Lookup[expandedResolvedOptions,SecondaryInjectionFlowRate],
				PrimaryInjectionStorageCondition->Lookup[expandedResolvedOptions,PrimaryInjectionSampleStorageCondition],
				SecondaryInjectionStorageCondition->Lookup[expandedResolvedOptions,SecondaryInjectionSampleStorageCondition],
				SolventWasteContainer->wasteContainer,
				SecondarySolventWasteContainer->secondaryWasteContainer,

				(* ---Data Processing--- *)
				Replace[Blanks] -> (Link[#] & /@ allBlankResources),
				Replace[BlankVolumes] -> If[MatchQ[blankVolumesWithReplicates,{Null..}],
					{},
					blankVolumesWithReplicates
				],
				Replace[BlankContainers] -> (Link[#]& /@ blankContainersResources),

				(* ---Sampling--- *)
				(* SamplingPattern pattern of field is different for neph and kinetics, but they both have the field *)
				SamplingPattern->Lookup[expandedResolvedOptions,SamplingPattern],
				SamplingDistance->Lookup[expandedResolvedOptions,SamplingDistance]
			|>;

			(* Fields only found in Object[Protocol,Nephelometry] *)
			nephSpecificFields=<|
				SamplingDimension->Lookup[expandedResolvedOptions,SamplingDimension]
			|>;

			(* Fields only found in Object[Protocol,NephelometryKinetics] *)
			kineticsFields=<|
				(* ---Measurement--- *)
				RunTime->Lookup[expandedResolvedOptions, RunTime],
				ReadOrder->Lookup[expandedResolvedOptions,ReadOrder],
				PlateReaderMixSchedule->Lookup[expandedResolvedOptions,PlateReaderMixSchedule],

				(* ---Cycling--- *)
				Replace[KineticWindowDurations] -> Lookup[expandedResolvedOptions, KineticWindowDurations],
				Replace[NumberOfCycles]->Lookup[expandedResolvedOptions, NumberOfCycles],
				Replace[CycleTimes] -> Lookup[expandedResolvedOptions,CycleTime],


				(* ---Injections--- *)
				Replace[TertiaryInjections]->tertiaryInjectionsWithResources,
				Replace[QuaternaryInjections]->quaternaryInjectionsWithResources,
				TertiaryInjectionFlowRate->Lookup[expandedResolvedOptions,TertiaryInjectionFlowRate],
				QuaternaryInjectionFlowRate->Lookup[expandedResolvedOptions,QuaternaryInjectionFlowRate]

			|>;

			protocolPacket=If[MatchQ[myType,Object[Protocol,NephelometryKinetics]],
				Join[standardFields,injectorCleaningFields,kineticsFields],
				Join[standardFields,injectorCleaningFields,nephSpecificFields]
			];

			(* generate a packet with the shared fields *)
			sharedFieldPacket = populateSamplePrepFields[mySamples, expandedResolvedOptions, Cache -> cache, Simulation -> updatedSimulation];

			(* Merge the shared fields with the specific fields *)
			{
				Join[sharedFieldPacket, protocolPacket],
				{}
			}
		],
		(* Robotic branch *)
		Module[{newLabelSampleUO, oldResourceToNewResourceRules, labelSampleAndUnitOpPacket, labelSamplePacket, unitOpPacket,unitOperationPacketWithLabeledObjects},

			(* get the new label sample unit operation if it exists; need to replace the models in it with the sample resources we've already created/simulated *)
			{newLabelSampleUO, oldResourceToNewResourceRules} = If[MatchQ[Lookup[myResolvedOptions, PreparatoryUnitOperations], {_[_LabelSample]}],
				generateLabelSampleUO[
					Lookup[myResolvedOptions, PreparatoryUnitOperations][[1, 1]],
					updatedSimulation,
					samplesInResources
				],
				{Null, {}}
			];

			labelSampleAndUnitOpPacket = UploadUnitOperation[{
				If[NullQ[newLabelSampleUO], Nothing, newLabelSampleUO],
				primitiveHead@@Join[
					{
						Sample -> samplesInResources /. oldResourceToNewResourceRules
					},
					ReplaceRule[
						Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
						{
							Instrument -> Resource[Instrument -> instrumentOpt, Time -> estimatedReadingTime],
							Blank -> allBlankResources,
							Diluent -> diluentResources,
							MoatBuffer -> moatBufferResource,
							(* injection sample resources are always in second to last position for all experiments *)
							PrimaryInjectionSample->If[Length[primaryInjectionWithResources[[All,-2]]]==0,
								ConstantArray[Null, Length[mySamples]],
								primaryInjectionWithResources[[All,-2]]
							],
							SecondaryInjectionSample->If[Length[secondaryInjectionsWithResources[[All,-2]]]==0,
								ConstantArray[Null, Length[mySamples]],
								secondaryInjectionsWithResources[[All,-2]]
							],
							(* kinetics only *)
							If[MatchQ[experimentFunction,ExperimentNephelometryKinetics],
								TertiaryInjectionSample->If[Length[tertiaryInjectionsWithResources[[All,-2]]]==0,
									ConstantArray[Null, Length[mySamples]],
									tertiaryInjectionsWithResources[[All,-2]]
								],
								Nothing
							],
							If[MatchQ[experimentFunction,ExperimentNephelometryKinetics],
								QuaternaryInjectionSample->If[Length[quaternaryInjectionsWithResources[[All,-2]]]==0,
									ConstantArray[Null, Length[mySamples]],
									quaternaryInjectionsWithResources[[All,-2]]
								],
								Nothing
							],
							(* NOTE: Don't pass Name down. *)
							Name->Null
						}
					],
					{
						SampleLabel->sampleLabelsWithReplicates,
						BlankLabel->blankLabelsWithReplicates
					}
				]},
				Preparation->Robotic,
				UnitOperationType->Output,
				FastTrack->True,
				Upload->False
			];

			(* split out the LabelSample and Nephelometry UOs *)
			{labelSamplePacket, unitOpPacket} = If[Length[labelSampleAndUnitOpPacket] == 2,
				labelSampleAndUnitOpPacket,
				{Null, First[labelSampleAndUnitOpPacket]}
			];

			(* Add the LabeledObjects field to the Robotic unit operation packet. *)
			(* NOTE: This will be stripped out of the UnitOperation packet by the framework and only stored at the top protocol level. *)
			unitOperationPacketWithLabeledObjects=Append[
				unitOpPacket,
				Replace[LabeledObjects]->DeleteDuplicates@Join[
					Cases[
						Transpose[{sampleLabelsWithReplicates, If[NullQ[diluents],samplesInResources /. oldResourceToNewResourceRules,dilutionSamplesInResources]}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample], Model[Sample]}]]]}
					],
					Cases[
						Transpose[{DeleteDuplicates@Lookup[myResolvedOptions, SampleContainerLabel], (Resource[Sample -> #]& /@ containersIn)}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Container], Model[Container]}]]]}
					],

					If[!MatchQ[allBlankResources,ListableP[Null]|{}],
						Cases[
							Transpose[{blankLabelsWithReplicates, allBlankResources}],
							{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample], Model[Sample]}]]]}
						],
						{}
					]
				]
			];

			(* Return our unit operation packets with labeled objects. *)
			{
				Null,
				{If[NullQ[labelSamplePacket], Nothing, labelSamplePacket], unitOperationPacketWithLabeledObjects}
			}
		]
	];

	(* make list of all the resources we need to check in FRQ *)
	rawResourceBlobs=DeleteDuplicates[Cases[Flatten[{Normal[finalizedPacket], Normal[unitOperationPackets]}],_Resource,Infinity]];

	(* Get all resources without a name. *)
	(* NOTE: Don't try to consolidate operator resources. *)
	resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False] && !KeyExistsQ[#, Operator]&)]]];

	resourceToNameReplaceRules=MapThread[#1->#2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@resourcesWithoutName}];
	allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		MatchQ[$ECLApplication,Engine],
		{True,{}},
		(* When Preparation->Robotic, the framework will call FRQ for us. *)
		MatchQ[resolvedPreparation, Robotic],
		{True, {}},
		gatherTests,
		Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Simulation->simulation,Cache->cache],
		True,
		{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Simulation->simulation,Cache->cache],Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule=Preview->Null;

	(* Generate the options output rule *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		resourceTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
		{finalizedPacket, unitOperationPackets}/.resourceToNameReplaceRules,
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];


(* ::Subsection::Closed:: *)
(* Helper functions *)

(* ::Subsubsection::Closed:: *)
(* serialNumberOfDilutions helper function *)
(* calculate number of dilutions for serial curve *)
(* for non constant dilution factors *)
serialNumberOfDilutions[myCurve:{VolumeP, {RangeP[0, 1] ..}}
] := Module[
	{dilutionFactorCurve, numberOfDilutions},

	(* Get the list of dilution factors *)
	dilutionFactorCurve = Last[myCurve];

	(* the number of dilutions is the length of the factor list *)
	numberOfDilutions = Length[dilutionFactorCurve];

	numberOfDilutions
];

(* constant dilution factors *)
serialNumberOfDilutions[myCurve:{VolumeP, {RangeP[0, 1], GreaterP[1, 1]}}
] := Module[
	{numberOfDilutions},

	(* the number of dilutions is the last number in the second list *)
	numberOfDilutions = Last[Last[myCurve]];

	numberOfDilutions
];

(* for constant dilution volumes *)
serialNumberOfDilutions[myCurve:{VolumeP, VolumeP, GreaterP[1, 1]}
] := Module[
	{numberOfDilutions},

	(* the number of dilutions is the last number in the list *)
	numberOfDilutions = Last[myCurve];

	numberOfDilutions
];

serialNumberOfDilutions[Null] := 0;


(* ::Subsubsection::Closed:: *)
(* calculateDilutionVolumes Helper Function *)
(*Find the series of transfer volumes and diluent volumes needed to create the serial dilution curves with a pure sample included in serial dilutions*)
(*for non constant dilution factors*)
calculateDilutionVolumes[myCurve : {VolumeP, {RangeP[0, 1] ..}}] := Module[
	{
		transferVolumes, diluentVolumes, sampleVolume,
		dilutionFactorCurve, lastTransferVolume, recTransferVolumeFunction
	},

		(* Get the volume of each sample after the transfers *)
		sampleVolume = First[myCurve];

		(* Get the list of dilution factors *)
		dilutionFactorCurve = Last[myCurve];

		(* Calculate the last transfer volume performed DilutionFactors=transferIn/Totalvolume *)
		lastTransferVolume = SafeRound[Last[dilutionFactorCurve]*sampleVolume,10^-1 Microliter];

		(*Calculate the rest of the transfers with recursion TotalVolume=TransferIn+Diluent-transferOut, Dilutionfactor=transferin/(tranferIn+diluent)*)
		recTransferVolumeFunction[{_Real | _Integer}] :=
			{lastTransferVolume};

		recTransferVolumeFunction[factorList_List] := Join[
			{SafeRound[First[factorList]*(sampleVolume + First[recTransferVolumeFunction[Rest[factorList]]]),10^-1 Microliter]},
			recTransferVolumeFunction[Rest[factorList]]
		];

		transferVolumes = recTransferVolumeFunction[dilutionFactorCurve];

		(*calculate the corresponding diluent volumes, DilutionFactors=transferIn/(transferIn + diluent*)
		diluentVolumes = SafeRound[
			MapThread[
				If[MatchQ[#1, 0],
					sampleVolume,
					#2*(1 - #1)/#1] &,
				{dilutionFactorCurve, transferVolumes}
			],
			10^-1 Microliter
		];

		(* return the transfer volumes and diluent volumes *)
		{
			transferVolumes,
			diluentVolumes
			(*Join[{sampleVolume+First[transferVolumes]},transferVolumes],
			Join[{0 Microliter},diluentVolumes]*)
		}
];

(*constant dilution factors, this could be an overload to the function above, but it is computationally faster to use this function*)
calculateDilutionVolumes[myCurve : {VolumeP, {RangeP[0, 1], GreaterP[1, 1]}}] :=
	Module[{sampleVolume, dilutionFactor, dilutionNumber, transferVolumes, diluentVolumes},

		(*Get the final volume after transfers*)
		sampleVolume = First[myCurve];

		(*Get the dilution volume*)
		dilutionFactor = First[Last[myCurve]];

		(*Get the number of dilutions*)
		dilutionNumber = Last[Last[myCurve]];

		(*Get the transfer volume, DilutionFactor=transferin/(transferin+diluent), sampleVolume=transferin+dilunent-transfer out=diluent*)
		transferVolumes = If[MatchQ[dilutionFactor, 1],
			Reverse[Table[sampleVolume + i*sampleVolume, {i, dilutionNumber}]],
			ConstantArray[
				SafeRound[
					dilutionFactor*sampleVolume/(1 - dilutionFactor),
					10^-1 Microliter
				],
				dilutionNumber
			]
		];

		diluentVolumes = If[MatchQ[dilutionFactor, 1],
			ConstantArray[0 Microliter, dilutionNumber],
			ConstantArray[sampleVolume, dilutionNumber]
		];

		(*return the transfer volumes and diluent volumes*)
		{
			transferVolumes,
			diluentVolumes
			(*Join[{sampleVolume+First[transferVolumes]},transferVolumes],
			Join[{0 Microliter},diluentVolumes]*)
		}
	];

(*for constant dilution volumes*)
calculateDilutionVolumes[myCurve : {VolumeP, VolumeP, GreaterP[1, 1]}] :=
	Module[{transferVolumes, diluentVolumes},

		(*make arrays of all the volumes*)
		transferVolumes = ConstantArray[First[myCurve], Last[myCurve]];
		diluentVolumes = ConstantArray[myCurve[[2]], Last[myCurve]];

		(*return the transfer volumes and diluent volumes*)
		{
			transferVolumes,
			diluentVolumes
			(*Join[{myCurve[[2]]+First[transferVolumes]},transferVolumes],
			Join[{0 Microliter},diluentVolumes]*)
		}
	];

(*for a non-serial dilution with volumes given*)
calculateDilutionVolumes[myCurve : {{VolumeP, VolumeP}...}] :=
	Module[{sampleVolumes, diluentVolumes},

		(*make arrays of all the volumes*)
		sampleVolumes = First[#]&/@myCurve;
		diluentVolumes = Last[#]&/@myCurve;

		(*return the transfer volumes and diluent volumes*)
		{sampleVolumes, diluentVolumes}
	];

(*for a non-serial dilution with dilution factors given*)
calculateDilutionVolumes[myCurve : {{VolumeP, RangeP[0,1]}...}] :=
	Module[{sampleVolumes, diluentVolumes},

		(*make arrays of all the volumes*)
		(*DF=sample /sample +diluent, Volume=sample+diluent*)
		sampleVolumes = SafeRound[First[#]*Last[#],10^-1 Microliter]&/@myCurve;
		diluentVolumes = SafeRound[First[#]*(1 - Last[#]), 10^-1 Microliter] & /@ myCurve;

		(*return the transfer volumes and diluentvolumes*)
		{sampleVolumes, diluentVolumes}
	];

calculateDilutionVolumes[Null] :={{Null}, {Null}};


(* ::Subsubsection:: *)
(*resolveACUOptions*)
(* this helper resolves TargetCarbonDioxideLevel/TargetOxygenLevel options for plate reader atmospheric control unit, and does error checking *)

Error::IncompatibleGasLevels = "The specified TargetCarbonDioxideLevel and TargetOxygenLevel are incompatible with the instrument due to gas displacement properties, where ambient oxygen levels are 19% and ambient carbon dioxide levels are 0%. If the TargetOxygenLevel is below 1%, please set the TargetCarbonDioxideLevel to below 5%. If the TargetCarbonDioxideLevel is above 5%, please set the TargetOxygenLevel to below 18%, or leave TargetOxygenLevel as Null and TargetCarbonDioxideLevel as Automatic.";
Error::NoACUOnInstrument = "The specified instrument, `1`, does not have a atmospheric control unit (ACU) that is capable of achieving TargetOxygenLevel of `2` and TargetCarbonDioxideLevel of `3`. Please consider using Model[Instrument, PlateReader, \"id:zGj91a7Ll0Rv\"] instead to control gas levels, or setting gas level options to Null."

resolveACUOptions[myType_, mySample:ObjectP[Object[Sample]], myOptions:{__Rule} | _Association] := resolveACUOptions[myType, {mySample}, myOptions];
resolveACUOptions[myType_, mySamples:{ObjectP[Object[Sample]]..}, myOptions:{__Rule} | _Association] := Module[
	{
		output, gatherTests, messages, cache, simulation, acuDownloads, cacheBall, fastCacheBall, cellTypes, sortedCellTypes, majorCellType, resolvedTargetO2Level, highOxygenLevelQ,
		specifiedInstrument, specifiedInstrumentModel, resolvedTargetCO2Level, resolvedAtmosphereEquilibrationTime, validCO2O2LevelsQ, carbonDioxideOxygenLevelsCompatibleTest,
		carbonDioxideOxygenLevelsCompatibleOptions, validInstrumentSelectionQ, instrumentNoACUTest, instrumentNoACUOptions, invalidOptions, allTests, resultRule, testRule
	},

	(* determine the requested return value for the function *)
	output = Lookup[myOptions, Output];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;

	(* get the cache and simulation *)
	cache = Lookup[myOptions, Cache, {}];
	simulation = Lookup[myOptions, Simulation, Null];

	(* --- Download --- *)

	(* get the specified instrument *)
	specifiedInstrument = Lookup[myOptions, Instrument];

	acuDownloads = Quiet[
		Download[
			{
				mySamples,
				Cases[ToList[specifiedInstrument], ObjectP[Object[Instrument]]]
			},
			{
				{Packet[Analytes, Composition, CellType], Packet[Composition[[All, 2]][CellType]]},
				{Packet[Model]}
			},
			Cache -> cache,
			Simulation -> simulation
		],
		{Download::FieldDoesntExist, Download::MissingField, Download::MissingCacheField}
	];

	(* make fastCacheBall *)
	cacheBall = FlattenCachePackets[{acuDownloads, cache}];
	fastCacheBall = makeFastAssocFromCache[cacheBall];

	(* get cellTypes, from sample packets *)
	cellTypes = Map[
		(* if CellType is directly specified for the sample, then we consider that as the major cell type *)
		If[MatchQ[fastAssocLookup[fastCacheBall, #, CellType], CellTypeP],
			fastAssocLookup[fastCacheBall, #, CellType],
			(* otherwise try to lookup the major cell type from composition *)
			Module[{mainCellModel},
				mainCellModel = selectMainCellFromSample[#, Cache -> cacheBall, Simulation -> simulation];
				(* get the cell type *)
				fastAssocLookup[fastCacheBall, First[mainCellModel], CellType]
			]
		]&,
		(* this transforms any packets that were fed as an input into object reference *)
		Download[mySamples, Object]
	];

	(* sort and gather cell types *)
	sortedCellTypes = SortBy[Gather[Cases[cellTypes, CellTypeP]], Length];

	(* take the last list of cell types, as it will be the longest, then the first item on the list to get the major cell type. if there are no non-Null cell types, return an empty list *)
	majorCellType = If[MatchQ[sortedCellTypes, {}], {}, First[Last[sortedCellTypes]]];

	(* --- get the resolved target oxygen level - the option is default to Null, so we only need to look it up from options --- *)
	resolvedTargetO2Level = Lookup[myOptions, TargetOxygenLevel, Null];

	(* determine if the oxygen level is too high to allow CO2 to be set at 5 percent or higher *)
	highOxygenLevelQ = MatchQ[resolvedTargetO2Level, GreaterEqualP[18 * Percent]];

	(* get the model of the specified instrument model *)
	specifiedInstrumentModel = If[MatchQ[specifiedInstrument, ObjectP[Model[Instrument]] | Automatic],
		specifiedInstrument,
		fastAssocLookup[fastCacheBall, specifiedInstrument, Model]
	];

	(* --- Resolve the CO2 level based on the majority cell type --- *)
	resolvedTargetCO2Level = Which[
		(* respect user input *)
		MatchQ[Lookup[myOptions, TargetCarbonDioxideLevel, Null], Except[Automatic]],
		Lookup[myOptions, TargetCarbonDioxideLevel, Null],
		(* if the specified instrument does not have an ACU, then this makes no sense *)
		!MatchQ[myType, Object[Protocol, Nephelometry] | Object[Protocol, NephelometryKinetics]] && !MatchQ[specifiedInstrumentModel, Automatic | ObjectP[Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"]]], (* Model[Instrument, PlateReader, "CLARIOstar Plus with ACU"] *)
		Null,
		(* set to something if we are dealing with mam cell *)
		MatchQ[majorCellType, NonMicrobialCellTypeP] && !highOxygenLevelQ,
		5 Percent,
		(* set to something if we are dealing with mam cell *)
		MatchQ[majorCellType, NonMicrobialCellTypeP] && highOxygenLevelQ,
		4 Percent,
		(* otherwise Null *)
		True,
		Null
	];

	(* --- resolve the AtmosphereEquilibrationTime --- *)
	resolvedAtmosphereEquilibrationTime = Which[
		(* respect user input always *)
		MatchQ[Lookup[myOptions, AtmosphereEquilibrationTime, Automatic], Except[Automatic]],
		Lookup[myOptions, AtmosphereEquilibrationTime],
		(* if we are not setting O2/CO2 set to Null *)
		NullQ[resolvedTargetO2Level] && NullQ[resolvedTargetCO2Level],
		Null,
		(* otherwise default to 5 minute *)
		True,
		5 * Minute
	];

	(* === ERROR CHECKING === *)

	(* ---Check for incompatible CO2 and O2 levels--- *)
	(* O2 below 1%, CO2 can only go from 0.1-5% *)
	(* high CO2 displaces oxygen, can't get high CO2 and high O2 *)
	(* CO2 at 5% limits O2 to 18% *)

	(* Check compatibility if both CO2 and O2 levels are set *)
	validCO2O2LevelsQ = If[
		MatchQ[resolvedTargetCO2Level, PercentP] && MatchQ[resolvedTargetO2Level, PercentP],
		And[
			If[resolvedTargetO2Level < 1Percent, resolvedTargetCO2Level <= 5Percent, True],
			If[resolvedTargetCO2Level >= 5Percent, resolvedTargetO2Level <= 18Percent, True]
		],
		True
	];

	(* generate tests for cases where there are more than 4 KineticWindowDurations *)
	carbonDioxideOxygenLevelsCompatibleTest = If[gatherTests,
		Test["The specified oxygen and carbon dioxide levels are compatible with each other:",
			validCO2O2LevelsQ,
			True
		],
		Nothing
	];

	(* throw an error if CycleTime is higher than KineticWindowDurations *)
	carbonDioxideOxygenLevelsCompatibleOptions = If[!validCO2O2LevelsQ && messages,
		(
			Message[Error::IncompatibleGasLevels];
			{TargetCarbonDioxideLevel, TargetOxygenLevel}
		),
		{}
	];

	(* --- If this is a plate reader instrument, check if it has an ACU at all --- *)
	(* this check is not necessary for nephelometry since all nephelometers have ACU *)
	validInstrumentSelectionQ = Or[
		(* we must use an instrument with ACU if Target O2/CO2 level is specified *)
		And[
			MatchQ[resolvedTargetO2Level, PercentP] || MatchQ[resolvedTargetCO2Level, PercentP],
			(* need to check instrument model for all other plate reader experiments  *)
			MatchQ[specifiedInstrumentModel, Automatic | ObjectP[Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"]]] (* Model[Instrument, PlateReader, "CLARIOstar Plus with ACU"] *)
		],
		(* or we are not using ACU then dont care about this check *)
		NullQ[resolvedTargetO2Level] && NullQ[resolvedTargetCO2Level],
		(* or if we are doing neph instrument is always valid since all nephelometers have ACU *)
		MatchQ[myType, Object[Protocol, Nephelometry] | Object[Protocol, NephelometryKinetics]]
	];

	(* make tests *)
	instrumentNoACUTest = If[gatherTests,
		Test["Specified instrument is capable of controlling atmospheric parameters with an Atmospheric Control Unit if TargetCarbonDioxideLevel/TargetOxygenLevel is specified:",
			validInstrumentSelectionQ,
			True
		],
		Nothing
	];

	(* throw messages *)
	instrumentNoACUOptions = If[!validInstrumentSelectionQ && messages,
		(
			Message[Error::NoACUOnInstrument, specifiedInstrument, resolvedTargetO2Level, resolvedTargetCO2Level];
			{Instrument, TargetCarbonDioxideLevel, TargetOxygenLevel}
		),
		{}
	];

	(* gather invalid options and tests *)
	invalidOptions = DeleteDuplicates[Flatten[{carbonDioxideOxygenLevelsCompatibleOptions, instrumentNoACUOptions}]];
	allTests = Flatten[{carbonDioxideOxygenLevelsCompatibleTest, instrumentNoACUTest}];

	(* we return the resolved ACU option rules, and any invalid option found during error checking *)
	resultRule = Result -> {
		{
			TargetCarbonDioxideLevel -> resolvedTargetCO2Level,
			TargetOxygenLevel -> resolvedTargetO2Level,
			AtmosphereEquilibrationTime -> resolvedAtmosphereEquilibrationTime
		},
		invalidOptions
	};
	testRule = Tests -> allTests;

	(* return *)
	output /. {resultRule, testRule}
];
