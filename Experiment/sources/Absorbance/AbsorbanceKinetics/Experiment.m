(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentAbsorbanceIntensity*)


(* ::Subsubsection::Closed:: *)
(*Options*)

DefineOptions[ExperimentAbsorbanceKinetics,
	Options :> {
		{
			OptionName->Instrument,
			Default->Automatic,
			Description->"The plate reader used to measure absorbance.",
			ResolutionDescription->"Resolves to the instrument capable of performing the requested sampling. If any instrument can be used, resolves to use the model with the most available instruments in the lab.",
			AllowNull->False,
			Widget-> Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,PlateReader],Object[Instrument,PlateReader]}]]
		},
		PlateReaderMixScheduleOption,
		AbsorbanceSharedOptions,
		{
			OptionName->RunTime,
			Default->45 Minute,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Minute, 24 Hour],Units:>{Hour,{Hour,Minute,Second}}],
			AllowNull->False,
			Description->"The length of time for which absorbance measurements are made.",
			Category->"Absorbance Measurement"
		},
		{
			OptionName->ReadOrder,
			Default->Parallel,
			Description->"Indicates if all measurements and injections are done for one well before advancing to the next (Serial) or in cycles in which each well is read once per cycle (Parallel).",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>ReadOrderP],
			Category->"Absorbance Measurement"
		},
		{
			OptionName -> Wavelength,
			Default -> Automatic,
			Description -> "The wavelength(s) at which absorbance is measured. All indicates that the full spectrum available to the plate reader is used.",
			ResolutionDescription -> "Automatically resolves to the wavelengths specified in the input samples' ExtinctionCoefficients field or 260 Nanometer if that field is not populated, for Serial ReadOrder or Matrix SamplingPattern. Otherwise automatically resolves to All.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type -> Enumeration,Pattern :> Alternatives[All]],
				Widget[Type -> Quantity,Pattern :> RangeP[220 Nanometer, 1000 Nanometer],Units -> Alternatives[Nanometer]],
				Adder[Widget[Type -> Quantity,Pattern :> RangeP[220 Nanometer, 1000 Nanometer],Units -> Alternatives[Nanometer]]],
				Span[
					Widget[Type -> Quantity,Pattern :> RangeP[220 Nanometer, 1000 Nanometer],Units -> Alternatives[Nanometer]],
					Widget[Type -> Quantity,Pattern :> RangeP[220 Nanometer, 1000 Nanometer],Units -> Alternatives[Nanometer]]
				]
			],
			Category -> "Absorbance Measurement"
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->TertiaryInjectionSample,
				Default->Null,
				Description->"The sample to be injected in the third round of injections. Note that only two unique samples can be injected in total. The corresponding injection times and volumes can be set with TertiaryInjectionTime and TertiaryInjectionVolume.",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
				Category->"Injections"
			},
			{
				OptionName->TertiaryInjectionVolume,
				Default->Null,
				Description->"The amount of the tertiary sample injected in the third round of injections.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0.5 Microliter,300 Microliter],Units->Microliter],
				Category->"Injections"
			},
			{
				OptionName->QuaternaryInjectionSample,
				Default->Null,
				Description->"The sample to be injected in the fourth round of injections. Note that only two unique samples can be injected in total. The corresponding injection times and volumes can be set with QuaternaryInjectionTime and QuaternaryInjectionVolume.",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
				Category->"Injections"
			},
			{
				OptionName->QuaternaryInjectionVolume,
				Default->Null,
				Description->"The amount of the quaternary sample injected in the fourth round of injections.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[0.5 Microliter,300 Microliter],Units->Microliter],
				Category->"Injections"
			}
		],
		{
			OptionName->TertiaryInjectionFlowRate,
			Default->Automatic,
			Description->"The speed at which to transfer injection samples into the assay plate in the third round of injections.",
			ResolutionDescription->"Defaults to 300 Microliter/Second if tertiary injections are specified.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BMGFlowRateP],
			Category->"Sample Handling"
		},
		{
			OptionName->QuaternaryInjectionFlowRate,
			Default->Automatic,
			Description->"The speed at which to transfer injection samples into the assay plate in the fourth round of injections.",
			ResolutionDescription->"Defaults to 300 Microliter/Second if quaternary injections are specified.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BMGFlowRateP],
			Category->"Sample Handling"
		},
		{
			OptionName->PrimaryInjectionTime,
			Default->Null,
			Description->"The time at which the first round of injections starts.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second, 24 Hour],Units:>{Hour,{Hour,Minute,Second}}],
			Category->"Injections"
		},
		{
			OptionName->SecondaryInjectionTime,
			Default->Null,
			Description->"The time at which the second round of injections starts.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second, 24 Hour],Units:>{Hour,{Hour,Minute,Second}}],
			Category->"Injections"
		},
		{
			OptionName->TertiaryInjectionTime,
			Default->Null,
			Description->"The time at which the third round of injections starts.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second, 24 Hour],Units:>{Hour,{Hour,Minute,Second}}],
			Category->"Injections"
		},
		{
			OptionName->QuaternaryInjectionTime,
			Default->Null,
			Description->"The time at which the fourth round of injections starts.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second, 24 Hour],Units:>{Hour,{Hour,Minute,Second}}],
			Category->"Injections"
		}
	}
];

Error::AbsorbanceKineticsTooManySamples="There is not enough space in the plate for the samples (including any replicates, blanks and moat samples). Please consider splitting this into two experiment calls.";
Error::BlankAliquotRequired="Blanks and assay samples must be aliquoted `1`. Please specify BlankVolumes for `2` so that this aliquot can be performed.";
Error::InsufficientBlankSpace="All blanks and assay samples must be in a single container. Since there are not enough empty wells in the assay container to transfer in the blank samples, everything must be aliquoted into a new container. Please specify fewer unique blanks by decreasing the number of unique blank volumes of a given blank sample or allow Aliquot to resolve automatically.";
Warning::InsufficientBlankSpace="There are not enough empty wells in the assay container to transfer in the blank samples so everything must be aliquoted into a new container.";
Error::MultipleWavelengthsUnsupported="When using ReadOrder->Serial it's not possible to read over a span of wavelengths. Please specify a fixed number of wavelengths.";

(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceKinetics (sample input)*)


(* --- Core Function --- *)
ExperimentAbsorbanceKinetics[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[ExperimentAbsorbanceKinetics]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, messages, safeOptions, safeOptionTests, upload,
		confirm, fastTrack, parentProt, unresolvedOptions, unresolvedOptionsTests, combinedOptions, resolveOptionsResult,
		resolvedOptionsNoHidden, allTests, estimatedRunTime, fastCacheBall,
		resourcePackets, resourcePacketTests, simulatedProtocol, simulation,
		resultRule, resolvedOptions, resolutionTests, returnEarlyQ, performSimulationQ, validLengths, validLengthTests, expandedCombinedOptions, downloadFields, protocolObject,
		cache, newCache, allPackets, userSpecifiedObjects, objectsExistQs, listedSamples, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationSimulation,
		mySamplesWithPreparedSamplesNamed,safeOptionsNamed, myOptionsWithPreparedSamplesNamed},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
	(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentAbsorbanceKinetics,
			listedSamples,
			listedOptions
		],
		$Failed,
	 	{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
	(* Return early. *)
	(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentAbsorbanceKinetics, myOptionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentAbsorbanceKinetics, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	(* Sanitize Inputs *)
	{mySamplesWithPreparedSamples, safeOptions, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed, myOptionsWithPreparedSamplesNamed];

	(* If the specified options don't match their patterns or if the option lengths are invalid, return $Failed*)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* call ValidInputLengthsQ to make sure all the options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentAbsorbanceKinetics, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentAbsorbanceKinetics, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[Not[validLengths],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* get assorted hidden options *)
	{upload, confirm, fastTrack, parentProt, cache} = Lookup[safeOptions, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];

	(* apply the template options *)
	(* need to specify the definition number (we are number 1 for samples at this point) *)
	{unresolvedOptions, unresolvedOptionsTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentAbsorbanceKinetics, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentAbsorbanceKinetics, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> Result], Null}
	];

	(* If couldn't apply the template, return $Failed (or the tests up to this point) *)
	If[MatchQ[unresolvedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthTests, unresolvedOptionsTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* expand the combined options *)
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentAbsorbanceKinetics, {mySamplesWithPreparedSamples}, combinedOptions]];

	(* get all the Download fields *)
	downloadFields = {
		{
			Packet[IncompatibleMaterials, Well, RequestedResources, SamplePreparationCacheFields[Object[Sample], Format -> Sequence]],
			Packet[Container[SamplePreparationCacheFields[Object[Container]]]],
			Packet[Field[Composition[[All, 2]][{Molecule, ExtinctionCoefficients, PolymerType, MolecularWeight}]]]
		}
	};

	(* make the up front Download call *)
	allPackets = Check[
		Quiet[
			Download[
				{
					mySamplesWithPreparedSamples
				},
				Evaluate[downloadFields],
				Cache -> cache,
				Simulation -> samplePreparationSimulation,
				Date -> Now
			],
			{Download::FieldDoesntExist}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(* Return early if objects do not exist *)
	If[MatchQ[allPackets, $Failed],
		Return[$Failed]
	];

	(* Download information we need in both the Options and ResourcePackets functions *)
	newCache = FlattenCachePackets[{cache, allPackets, standardPlatesDownloadCache["Memoization"]}];

	(* Before going to resolver, check whether any of the specified objects does not exist. This is done early to avoid tons of errors later. *)
	userSpecifiedObjects=DeleteDuplicates[
		Cases[
			Flatten@Join[
				mySamplesWithPreparedSamples,
				Values[expandedCombinedOptions]
			],
			ObjectP[]
		]
	];

	(* Check that the specified objects exist or are visible to the current user *)
	(* NOTE: Since we can be called by ExperimentSM which uses degenerate cache balling with Simulated->True, we need to check for that as well *)
	(* as the new simulation style using PreparatoryUOs. *)
	fastCacheBall = makeFastAssocFromCache[newCache];
	objectsExistQs=MapThread[
		Or[#1, #2]&,
		{
			(MatchQ[Lookup[fetchPacketFromFastAssoc[#, fastCacheBall], Simulated], True]&)/@userSpecifiedObjects,
			DatabaseMemberQ[
				userSpecifiedObjects,
				Simulation->samplePreparationSimulation
			]
		}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs),
		Message[Error::ObjectDoesNotExist,PickList[userSpecifiedObjects,objectsExistQs,False]];
		Message[Error::InvalidInput,PickList[userSpecifiedObjects,objectsExistQs,False]];
		Return[$Failed],
		Nothing
	];

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult=If[gatherTests,

		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolutionTests} = resolveAbsorbanceOptions[Object[Protocol, AbsorbanceKinetics], mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> {Result, Tests}, Cache -> newCache, Simulation->samplePreparationSimulation];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolutionTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolutionTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolutionTests} = {resolveAbsorbanceOptions[Object[Protocol, AbsorbanceKinetics], mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> Result, Cache -> newCache, Simulation->samplePreparationSimulation], Null},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveAbsorbanceOptions doesn't have access to myOptionsWithPreparedSamples *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentAbsorbanceKinetics,
		RemoveHiddenOptions[ExperimentAbsorbanceKinetics, resolvedOptions],
		Ignore -> myOptionsWithPreparedSamples,
		Messages -> False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolveOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolutionTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Options -> resolvedOptionsNoHidden,
			Preview -> Null,
			Tests -> Flatten[{safeOptionTests, unresolvedOptionsTests, resolutionTests}],
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* call the absorbanceResourcePackets function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	{resourcePackets, resourcePacketTests} = Which[
		MatchQ[resolveOptionsResult, $Failed],
			{$Failed,{}},
		gatherTests,
			absorbanceResourcePackets[
				Object[Protocol, AbsorbanceKinetics],
				Download[mySamplesWithPreparedSamples, Object],
				unresolvedOptions,
				ReplaceRule[resolvedOptions, {Output -> {Result, Tests}, Cache -> newCache, Simulation->samplePreparationSimulation}]
			],
		True,
			{
				absorbanceResourcePackets[
					Object[Protocol, AbsorbanceKinetics],
					Download[mySamplesWithPreparedSamples, Object],
					unresolvedOptions,
					ReplaceRule[resolvedOptions, {Output -> Result, Cache -> newCache, Simulation->samplePreparationSimulation}]],
				Null
			}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateReadPlateExperiment[
			Object[Protocol, AbsorbanceKinetics],
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
			Cache->newCache,
			Simulation->samplePreparationSimulation
		],
		{Null, Null}
	];

	(* --- Packaging the return value --- *)

	(* get all the tests together *)
	allTests = Cases[Flatten[{safeOptionTests, unresolvedOptionsTests, resolutionTests, resourcePacketTests}], _EmeraldTest];

	estimatedRunTime = 15 Minute +
		(Lookup[resolvedOptions,PlateReaderMixTime]/.Null->0 Minute) +
		(Lookup[resolvedOptions,RunTime]/.Null->0 Minute) +
		(* Add time needed to clean/prime each each injection line *)
		(If[!MatchQ[Lookup[resolvedOptions,PrimaryInjectionSample],Null|{}],15*Minute,0*Minute]);

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification /.{
			Result -> Null,
			Tests -> allTests,
			Options -> resolvedOptionsNoHidden,
			Preview -> Null,
			Simulation -> simulation,
			RunTime -> estimatedRunTime
		}]
	];

	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
	protocolObject=Which[

		(* If resource packets could not be generated or options could not be resolved, can't generate a protocol, return $Failed *)
		MatchQ[resourcePackets,$Failed] || MatchQ[resolveOptionsResult,$Failed],
		$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if Upload->False. *)
		MatchQ[Lookup[resolvedOptions,Preparation],Robotic]&&MatchQ[upload,False],
		resourcePackets[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call RCP or RSP with our primitive. *)
		MatchQ[Lookup[resolvedOptions,Preparation],Robotic],
		Module[{primitive, nonHiddenOptions,experimentFunction},
			(* Create our primitive to feed into RoboticSamplePreparation. *)
			primitive=AbsorbanceKinetics@@Join[
				{
					Sample->mySamples
				},
				RemoveHiddenPrimitiveOptions[AbsorbanceKinetics,ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions=RemoveHiddenOptions[ExperimentAbsorbanceKinetics,resolvedOptionsNoHidden];

			(* determine which work cell will be used (determined with the readPlateWorkCellResolver) to decide whether to call RSP or RCP *)
			experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[resolvedOptions, WorkCell]];

			(* Memoize the value of ExperimentAbsorbanceKinetics so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentAbsorbanceKinetics, $PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache=<||>;

				DownValues[ExperimentAbsorbanceKinetics]={};

				ExperimentAbsorbanceKinetics[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
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
					Name->Lookup[safeOptions,Name],
					Upload->Lookup[safeOptions,Upload],
					Confirm->Lookup[safeOptions,Confirm],
					ParentProtocol->Lookup[safeOptions,ParentProtocol],
					Priority->Lookup[safeOptions,Priority],
					StartDate->Lookup[safeOptions,StartDate],
					HoldOrder->Lookup[safeOptions,HoldOrder],
					QueuePosition->Lookup[safeOptions,QueuePosition],
					Cache->newCache
				]
			]
		],

		(* Actually upload our protocol object. *)
		True,
		If[Length[resourcePackets[[2]]]==0,
			UploadProtocol[
				resourcePackets[[1]], (* protocolPacket *)
				Upload->Lookup[safeOptions,Upload],
				Confirm->Lookup[safeOptions,Confirm],
				ParentProtocol->Lookup[safeOptions,ParentProtocol],
				Priority->Lookup[safeOptions,Priority],
				StartDate->Lookup[safeOptions,StartDate],
				HoldOrder->Lookup[safeOptions,HoldOrder],
				QueuePosition->Lookup[safeOptions,QueuePosition],
				ConstellationMessage->Object[Protocol,AbsorbanceIntensity],
				Cache -> newCache,
				Simulation -> samplePreparationSimulation
			],
			UploadProtocol[
				resourcePackets[[1]], (* protocolPacket *)
				resourcePackets[[2]], (* unitOperationPackets *)
				Upload->Lookup[safeOptions,Upload],
				Confirm->Lookup[safeOptions,Confirm],
				ParentProtocol->Lookup[safeOptions,ParentProtocol],
				Priority->Lookup[safeOptions,Priority],
				StartDate->Lookup[safeOptions,StartDate],
				HoldOrder->Lookup[safeOptions,HoldOrder],
				QueuePosition->Lookup[safeOptions,QueuePosition],
				ConstellationMessage->Object[Protocol,AbsorbanceIntensity],
				Cache -> newCache,
				Simulation -> samplePreparationSimulation
			]
		]

	];

	(* return the output as we desire it *)
	outputSpecification /. {
		Result -> protocolObject,
		Tests -> allTests,
		Options -> resolvedOptionsNoHidden,
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedRunTime
	}

];



(* ::Subsubsection::Closed:: *)
(* ExperimentAbsorbanceKinetics (container input) *)


ExperimentAbsorbanceKinetics[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String|{LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions : OptionsPattern[ExperimentAbsorbanceKinetics]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, containerToSampleResult,containerToSampleSimulation,
		containerToSampleTests, inputSamples, messages, listedContainers, validSamplePreparationResult, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, samplePreparationSimulation,containerToSampleOutput, sampleOptions},

(* make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];
	listedContainers = ToList[myContainers];

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
	(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentAbsorbanceKinetics,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
	(* Return early. *)
	(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentAbsorbanceKinetics,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->samplePreparationSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentAbsorbanceKinetics,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Simulation->samplePreparationSimulation
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[ToList[containerToSampleResult],{$Failed..}],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{inputSamples,sampleOptions}=containerToSampleOutput;

		(* call ExperimentAbsorbanceKinetics and get all its outputs *)
		ExperimentAbsorbanceKinetics[inputSamples, ReplaceRule[sampleOptions, Simulation->containerToSampleSimulation]]
	]
];


(* ::Subsection:: *)
(*ExperimentAbsorbanceKineticsPreview*)


DefineOptions[ExperimentAbsorbanceKineticsPreview,
	SharedOptions :> {ExperimentAbsorbanceKinetics}
];

ExperimentAbsorbanceKineticsPreview[myInput:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],myOptions:OptionsPattern[ExperimentAbsorbanceKineticsPreview]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentAbsorbanceKinetics[myInput,ReplaceRule[listedOptions,Output->Preview]]
];


(* ::Subsection:: *)
(*ExperimentAbsorbanceKineticsOptions*)


DefineOptions[ExperimentAbsorbanceKineticsOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentAbsorbanceKinetics}
];

ExperimentAbsorbanceKineticsOptions[myInput:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],myOptions:OptionsPattern[ExperimentAbsorbanceKineticsOptions]]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentAbsorbanceKinetics[myInput,preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentAbsorbanceKinetics],
		resolvedOptions
	]
];


(* ::Subsection:: *)
(*ValidExperimentAbsorbanceKineticsQ*)


DefineOptions[ValidExperimentAbsorbanceKineticsQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentAbsorbanceKinetics}
];

ValidExperimentAbsorbanceKineticsQ[myInput:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],myOptions:OptionsPattern[ValidExperimentAbsorbanceKineticsQ]]:=Module[
	{listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	listedInput=ToList[myInput];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentAbsorbanceKinetics[myInput,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[listedInput,_String],OutputFormat->Boolean];
			voqWarnings=MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{DeleteCases[listedInput,_String],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[{initialTest},functionTests,voqWarnings]
		]
	];

	(* Lookup test running options *)
	safeOps=SafeOptions[ValidExperimentAbsorbanceKineticsQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"AK"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"AK"
	]
];
