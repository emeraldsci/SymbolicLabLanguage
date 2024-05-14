(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentNephelometryKinetics*)


(* ::Subsubsection::Closed:: *)
(*Options*)

DefineOptions[ExperimentNephelometryKinetics,
	Options :> {

		{
			OptionName->ReadOrder,
			Default->Parallel,
			Description->"Indicates if all measurements and injections are done for one well before advancing to the next (Serial) or in cycles in which each well is read once per cycle (Parallel). Injections are performed in each well, then a measurement is taken for each cycle.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>ReadOrderP],
			Category->"Measurement"
		},
		{
			OptionName->PlateReaderMixSchedule,
			Default->Automatic,
			Description-> "Indicates the points at which mixing should occur in the plate reader.",
			ResolutionDescription->"If PlateReaderMix is True and injections are specified, automatically set to AfterInjections. If PlateReaderMix is True and no injection options are specified, automatically set to BeforeReadings.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>MixingScheduleP],
			Category->"Measurement"
		},
		{
			OptionName->RunTime,
			Default->Automatic,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Minute, 24 Hour],Units:>{Hour,{Hour,Minute,Second}}],
			AllowNull->False,
			Description->"The total length of time for which nephelometry measurements are made. RunTime should equal the total time for the KineticWindowDurations if specified. If KineticWindowDurations is All, RunTime will be set to 1 hour, unless otherwise specified.",
			ResolutionDescription->"Automatically determined based on the Total[KineticWindowDurations].",
			Category->"Measurement"
		},


		(* ------Cycling------ *)
		{
			OptionName->KineticWindowDurations,
			Default->All,
			Description->"The length of time to study different areas of the kinetic curve. Separate NumberOfCycles and CycleTime can be set for each window, in order to increase the density of measurements for areas of particular interest. All indicates that the same settings will be used for the entire experiment RunTime. For example, if you would like to measure the plate for 1 hour every 6 minutes, then every minute for 15 minutes, set KineticWindowDurations to {1 Hour, 15 Minute}, NumberOfCycles to {11, 15}, and CycleTime to {6 Minute, 1 Minute}.",
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->Quantity,Pattern:>RangeP[10Second,$MaxExperimentTime],Units:>{1,{Second,{Second,Minute,Hour}}}]],
				Widget[Type->Enumeration,Pattern:>Alternatives[All]]
			],
			Category->"Cycling"
		},
		IndexMatching[
			IndexMatchingParent->KineticWindowDurations,
			{
				OptionName->NumberOfCycles,
				Default->Automatic,
				Description->"For the length of each kinetic window duration, the number of times all wells in the plate are read.",
				ResolutionDescription->"Defaults to read every minute if RunTime is less than 1 hour, or read every 5 minutes if RunTime is longer than 1 hour, or to the number of cycles that will fit into the KineticWindowDuration if CycleTimes are specified.",
				AllowNull->False,
				Widget->Widget[Type->Number,Pattern:>RangeP[1,1000,1]],
				Category->"Cycling"
			},
			{
				OptionName->CycleTime,
				Default->Automatic,
				Description->"For each kinetic window duration, the duration of time between each plate measurement. These timings are approximate, as the plate reader must account for the time to move the plate into position for reading, as well as any shaking time or time to inject samples if applicable.",
				ResolutionDescription->"Defaults to every 1 minute for each KineticWindowDurations under 1 hour, or every 5 minutes for KineticWindowDurations longer than 1 hour, or to the cycle time that will fit into the KineticWindowDurations if NumberOfCycles are specified.",
				AllowNull->False,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[10Second, 10000Second],Units:>{1,{Second,{Second,Minute,Hour}}}],
				Category->"Cycling"
			}
		],
		


		(* ------Injection------- *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->TertiaryInjectionSample,
				Default->Null,
				Description->"The sample to be injected in the third round of injections. Note that only two unique samples can be injected in total. The corresponding injection times and volumes can be set with TertiaryInjectionTime and TertiaryInjectionVolume.  If DilutionCurve or SerialDilutionCurve is specified, TertiaryInjectionSample will be injected into all dilutions in the curve.",
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
				Description->"The sample to be injected in the fourth round of injections. Note that only two unique samples can be injected in total. The corresponding injection times and volumes can be set with QuaternaryInjectionTime and QuaternaryInjectionVolume. If DilutionCurve or SerialDilutionCurve is specified, QuaternaryInjectionSample will be injected into all dilutions in the curve.",
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
			Category->"Injections"
		},
		{
			OptionName->QuaternaryInjectionFlowRate,
			Default->Automatic,
			Description->"The speed at which to transfer injection samples into the assay plate in the fourth round of injections.",
			ResolutionDescription->"Defaults to 300 Microliter/Second if quaternary injections are specified.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BMGFlowRateP],
			Category->"Injections"
		},
		{
			OptionName->PrimaryInjectionTime,
			Default->Null,
			Description->"The time at which the first round of injections starts.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second, $MaxExperimentTime],Units:>{Hour,{Hour,Minute,Second}}],
			Category->"Injections"
		},
		{
			OptionName->SecondaryInjectionTime,
			Default->Null,
			Description->"The time at which the second round of injections starts.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second, $MaxExperimentTime],Units:>{Hour,{Hour,Minute,Second}}],
			Category->"Injections"
		},
		{
			OptionName->TertiaryInjectionTime,
			Default->Null,
			Description->"The time at which the third round of injections starts.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second, $MaxExperimentTime],Units:>{Hour,{Hour,Minute,Second}}],
			Category->"Injections"
		},
		{
			OptionName->QuaternaryInjectionTime,
			Default->Null,
			Description->"The time at which the fourth round of injections starts.",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Second, $MaxExperimentTime],Units:>{Hour,{Hour,Minute,Second}}],
			Category->"Injections"
		},

		{
			OptionName -> SamplingPattern,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ring,Spiral,Center]],
			Description -> "Indicates where in the well measurements are taken. Center indicates that measurements are taken from the center of the well. Ring indicates a ring within the well with a outer diameter of SamplingDistance. Spiral indicates a spiral from the diameter of SamplingDistance to the center of the well.",
			Category -> "Sampling"
		},

		NephelometrySharedOptions

	}
];


(*------------------------------*)
(*----Main Function Overload----*)
(*------------------------------*)

ExperimentNephelometryKinetics[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedSamples,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,
		mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed,
		mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		uniqueInjectionSamples,uniqueBlankSamples,possibleAliquotContainers,analyte,downloadAnalytes,analyteFields,analyteFieldPacket,standardCurveFields,
		containerModelPreparationPackets,sampleAnalyteAllFields,sampleAnalytePackets,
		listedInjectionSamplePackets, listedBlankPackets, listedAliquotContainerPackets, analytePacket,
		samplePackets,sampleModelPackets,sampleContainerPackets,sampleContainerModelPackets,sampleCompositionPackets,
		analytePackets,estimatedRunTime,
		updatedSimulation,safeOps,safeOpsTests,validLengths,validLengthTests,returnEarlyQ,performSimulationQ,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,
		nephelometryKineticsOptionsAssociation,samplePrepOptions,nephelometryKineticsOptions,
		samplePreparationPackets,sampleModelPreparationPackets,containerPreparationPackets,compositionPackets,
		allSamplePackets, resolvedOptionsResult,simulatedProtocol, simulation,
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
			ExperimentNephelometryKinetics,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentNephelometryKinetics,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentNephelometryKinetics,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* change Named version of objects into ID version *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed];


	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentNephelometryKinetics,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentNephelometryKinetics,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
		ApplyTemplateOptions[ExperimentNephelometryKinetics,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentNephelometryKinetics,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentNephelometryKinetics,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(*Convert list of rules to Association so we can Lookup, Append, Join as usual*)
	nephelometryKineticsOptionsAssociation=Association[expandedSafeOps];

	(* Seperate out our Nephelometry options from our Sample Prep options. *)
	{samplePrepOptions,nephelometryKineticsOptions}=splitPrepOptions[expandedSafeOps];

	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall={};

	(* Get our unique injection samples for download *)
	uniqueInjectionSamples=DeleteDuplicates[
		Download[
			Cases[
				Lookup[nephelometryKineticsOptionsAssociation,{PrimaryInjectionSample,SecondaryInjectionSample,TertiaryInjectionSample,QuaternaryInjectionSample},Automatic],
				ObjectP[Object]
			],
			Object
		]
	];

	(* Get our unique blanks for download *)
	uniqueBlankSamples=DeleteDuplicates[Download[Cases[Lookup[nephelometryKineticsOptionsAssociation,Blank],ObjectP[Object]],Object]];

	(* Get the container we'll use for any aliquots - either the user's or we'll default to first compatible *)
	possibleAliquotContainers=Append[
		DeleteDuplicates[Cases[Flatten[Lookup[samplePrepOptions,AliquotContainer],1],ObjectP[]]],
		First[BMGCompatiblePlates[Nephelometry]]
	];

	(* figure out what analytes to download from *)
	analyte = Lookup[nephelometryKineticsOptionsAssociation, Analyte];

	(* replace Automatic with an empty list so the download works *)
	downloadAnalytes = Flatten[analyte/. Automatic->{}];

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
		analytePacket
	}=Quiet[
		Download[
			{
				mySamplesWithPreparedSamples,
				mySamplesWithPreparedSamples,
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
				{SamplePreparationCacheFields[Model[Container], Format -> Packet]},
				{analyteFieldPacket}
			}],
			Cache->Lookup[expandedSafeOps, Cache, {}],
			Simulation->updatedSimulation,
			Date->Now
		],
		Download::FieldDoesntExist
	];


	(*Extract the sample-related packets*)
	samplePackets=allSamplePackets[[All,1]];
	sampleModelPackets=allSamplePackets[[All,2]];
	sampleContainerPackets=allSamplePackets[[All,3]];
	sampleContainerModelPackets=allSamplePackets[[All,4]];
	sampleCompositionPackets=allSamplePackets[[All,5]];
	analytePackets=If[MatchQ[analytePacket,{}],sampleAnalytePackets,analytePacket];


	(* Combine our downloaded and simulated cache. *)
	cacheBall=FlattenCachePackets[{
		allSamplePackets,
		sampleAnalytePackets,
		listedInjectionSamplePackets,
		listedBlankPackets,
		listedAliquotContainerPackets,
		analytePacket
	}];


	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentNephelometryOptions[Object[Protocol,NephelometryKinetics],ToList[mySamples],expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentNephelometryOptions[Object[Protocol,NephelometryKinetics],ToList[mySamples],expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentNephelometryKinetics,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentNephelometryKinetics,collapsedResolvedOptions],
			Preview->Null
		}]
	];


	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentNephelometryKinetics,collapsedResolvedOptions],
			Preview->Null,
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* Build packets with resources *)
	(* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
	{resourcePackets,resourcePacketTests}=If[returnEarlyQ,
		{$Failed, {}},
		If[gatherTests,
			nephelometryResourcePackets[Object[Protocol,NephelometryKinetics],ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
			{nephelometryResourcePackets[Object[Protocol,NephelometryKinetics],ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],{}}
		]
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateReadPlateExperiment[
			Object[Protocol,NephelometryKinetics],
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				resourcePackets[[1]] (* protocolPacket *)
			],
			If[MatchQ[resourcePackets, $Failed],
				$Failed,
				ToList[resourcePackets[[2]]] (* unitOperationPackets *)
			],
			ToList[mySamplesWithPreparedSamples],
			expandedSafeOps,
			Cache->cacheBall,
			Simulation->updatedSimulation
		],
		{Null, Null}
	];

	estimatedRunTime = 15 Minute +
		(Lookup[resolvedOptions,PlateReaderMixTime]/.Null->0 Minute) +
		(Lookup[resolvedOptions,RunTime]/.Null->0 Minute) +
		(* Add time needed to clean/prime each each injection line *)
		(If[!MatchQ[Lookup[resolvedOptions,PrimaryInjectionSample],Null|{}],15*Minute,0*Minute]);

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentNephelometryKinetics,collapsedResolvedOptions],
			Preview -> Null,
			Simulation->simulation,
			RunTime -> estimatedRunTime
		}]
	];

	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
	protocolObject = Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[resourcePackets,$Failed] || MatchQ[resolvedOptionsResult,$Failed],
		$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if Upload->False. *)
		MatchQ[Lookup[resolvedOptions,Preparation],Robotic]&&MatchQ[Lookup[safeOps,Upload],False],
		resourcePackets[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call RCP or RSP with our primitive. *)
		MatchQ[Lookup[resolvedOptions,Preparation],Robotic],
		Module[{primitive, nonHiddenOptions,experimentFunction},
			(* Create our primitive to feed into RoboticSamplePreparation. *)
			primitive=NephelometryKinetics@@Join[
				{
					Sample->mySamples
				},
				RemoveHiddenPrimitiveOptions[NephelometryKinetics,ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions=RemoveHiddenOptions[ExperimentNephelometryKinetics,collapsedResolvedOptions];

			(* Nephelometry can only be done on bioSTAR/microbioSTAR, so call RCP *)
			experimentFunction = ExperimentRoboticCellPreparation;

			(* Memoize the value of ExperimentNephelometryKinetics so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentNephelometryKinetics, $PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache=<||>;

				DownValues[ExperimentNephelometryKinetics]={};

				ExperimentNephelometryKinetics[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
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
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,NephelometryKinetics],
			Cache->cacheBall,
			Simulation->updatedSimulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests(*,resourcePacketTests*)}],
		Options -> RemoveHiddenOptions[ExperimentNephelometryKinetics,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedRunTime
	}
];


(*--------------------------*)
(*----Container overload----*)
(*--------------------------*)

ExperimentNephelometryKinetics[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedContainers,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,containerToSampleSimulation,
		updatedSimulation,containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links. *)
	{listedContainers, listedOptions}=sanitizeInputs[ToList[myContainers], ToList[myOptions]];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentNephelometryKinetics,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
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
			ExperimentNephelometryKinetics,
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
				ExperimentNephelometryKinetics,
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
		ExperimentNephelometryKinetics[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];

