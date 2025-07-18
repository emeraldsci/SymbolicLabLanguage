(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentAbsorbanceIntensity*)


(* ::Subsubsection::Closed:: *)
(*Options*)


DefineOptions[ExperimentAbsorbanceIntensity,
	Options :> {
		{
			OptionName -> Methods,
			Default -> Automatic,
			Description -> "Indicates the type of vessel to be used to measure the absorbance of SamplesIn. PlateReaders utilize an open well container that transverses light from top to bottom. Cuvette uses a square container with transparent sides to transverse light from the front to back at a fixed path length. Microfluidic uses small channels to load samples which are then gravity-driven towards chambers where light transverse from top to bottom and measured at a fixed path length.",
			ResolutionDescription -> "If any of the SamplesIn provided has a volume less than 500 Micro Liter, set to microfluidic. Otherwise, if there are less 8 samples, set to Cuvette. If none of options are true, set to PlateReader",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> AbsorbanceMethodP
			]
		},
		{
			OptionName -> Instrument,
			Default -> Automatic,
			Description -> "The plate reader used for this absorbance experiment.",
			ResolutionDescription -> "Automatically resolves to Model[Instrument, PlateReader, \"FLUOstar Omega\"] if Temperature, EquilibrationTime, or any of the PlateReaderMix options are specified, or Model[Instrument, PlateReader, \"Lunatic\"] otherwise.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, PlateReader], Object[Instrument, PlateReader], Object[Instrument,Spectrophotometer], Model[Instrument,Spectrophotometer]}]
			]
		},
		{
			OptionName->MicrofluidicChipLoading,
			Default->Automatic,
			AllowNull->True,
			Description->"When using Lunatic, indicates if Lunatic Microfluidic Chips are loaded by a robotic liquid handler or manually.",
			ResolutionDescription -> "When using the Lunatic plate readers, automatically set to Robotic. When using the BMG plate reader, automatically set to Null.",
			Widget-> Widget[Type->Enumeration,Pattern:>Alternatives[Robotic, Manual]],
			Category->"Sample Handling"
		},
		{
			OptionName->SpectralBandwidth,
			Default->Automatic,
			AllowNull->True,
			Description->"When using the Cuvette Method, indicates the physical size of the slit from which light passes out from the monochromator. The narrower the bandwidth, the greater the resolution in measurements.",
			ResolutionDescription -> "When using the Cuvette Method, automatically set 1.0 Nanometer. If using plate reader, set to Null.",
			Widget-> Widget[Type->Quantity,Pattern:>RangeP[0.5 Nanometer, 5 Nanometer],Units:>Nanometer],
			Category->"Absorbance Measurement"
		},
		{
			OptionName -> TemperatureMonitor,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration,Pattern :> Alternatives[CuvetteBlock, ImmersionProbe]],
			Description -> "When using Cuvette Method (Cary 3500), indicates which device (probe or block) will be used to monitor temperature during the Experiment.",
			ResolutionDescription -> "When using the Cuvette Method, automatically set to CuvetteBlock. If using plate reader, set to Null.",
			Category -> "Absorbance Measurement"
		},
		{
			OptionName->AcquisitionMixRate,
			Default->Automatic,
			AllowNull->True,
			Description->"When using the Cuvette Method, indicates the rate at which the samples within the cuvette should be mixed with a stir bar during data acquisition.",
			ResolutionDescription -> "If AcquisitionMix is True, automatically set AcquisitionMixRate 400 RPM.",
			Widget-> Widget[Type->Quantity,Pattern:>RangeP[400 RPM, 1400 RPM],Units->RPM],
			Category->"Absorbance Measurement"
		},
		{
			OptionName->AdjustMixRate,
			Default->Automatic,
			AllowNull->True,
			Description->"When using a stir bar, if specified AcquisitionMixRate does not provide a stable or consistent circular rotation of the magnetic bar, indicates if mixing should continue up to MaxStirAttempts in attempts to stir the samples. If stir bar is wiggling, decrease AcquisitionMixRate by AcquisitionMixRateIncrements and check if the stir bar is still wiggling. If it is, decrease by AcquisitionMixRateIncrements again. If still wiggling, repeat decrease until MaxStirAttempts. If the stir bar is not moving/stationary, increase the AcquisitionMixRate by AcquisitionMixRateIncrements and check if the stir bar is still stationary. If it is, increase by AcquisitionMixRateIncrements again. If still stationary, repeat increase until MaxStirAttempts. Mixing will occur during data acquisition. After MaxStirAttempts, if stable stirring was not achieved, StirringError will be set to True in the protocol object.",
			ResolutionDescription -> "Automatically set to True if AcquisitionMix is True.",
			Widget-> Widget[Type->Enumeration,Pattern:>BooleanP],
			Category->"Absorbance Measurement"
		},
		{
			OptionName->MinAcquisitionMixRate,
			Default->Automatic,
			AllowNull->True,
			Description->"Sets the lower limit stirring rate to be decreased to for sample mixing in the cuvette while attempting to mix the samples with a stir bar if AdjustMixRate is True.",
			ResolutionDescription->"Automatically sets to 20% RPM lower than AcquisitionMixRate if AdjustMixRate is True.",
			Widget->Widget[Type->Quantity,Pattern:>RangeP[400 RPM,1400 RPM],Units->RPM],
			Category->"Absorbance Measurement"
		},
		{
			OptionName->MaxAcquisitionMixRate,
			Default->Automatic,
			AllowNull->True,
			Description->"Sets the upper limit stirring rate to be increased to for sample mixing in the cuvette while attempting to mix the samples with a stir bar if AdjustMixRate is True.",
			ResolutionDescription -> "Automatically sets to 20% RPM greater than AcquisitionMixRate if AdjustMixRate is True.",
			Widget-> Widget[Type->Quantity,Pattern:>RangeP[400 RPM, 1400 RPM],Units->RPM],
			Category->"Absorbance Measurement"
		},
		{
			OptionName->AcquisitionMixRateIncrements,
			Default->Automatic,
			AllowNull->True,
			Description->"Indicates the value to increase or decrease the mixing rate by in a stepwise fashion while attempting to mix the samples with a stir bar.",
			ResolutionDescription->"Automatically sets to 50 RPM if AdjustMixRate is True.",
			Widget->Widget[Type->Quantity,Pattern:>RangeP[50 RPM,500 RPM],Units->RPM],
			Category->"Absorbance Measurement"
		},
		{
			OptionName->MaxStirAttempts,
			Default->Automatic,
			AllowNull->True,
			Description->"Indicates the maximum number of attempts to mix the samples with a stir bar. One attempt designates each time AdjustMixRate changes the AcquisitionMixRate (i.e. each decrease/increase is equivalent to 1 attempt.",
			ResolutionDescription->"If AdjustMixRate is True, automatically sets to 10.",
			Widget->Widget[Type->Number,Pattern:>RangeP[1,40]],
			Category->"Absorbance Measurement"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName->AcquisitionMix,
				Default->Automatic,
				AllowNull->True,
				Description->"When using the Cuvette Method, indicates whether the samples within the cuvette should be mixed with a stir bar during data acquisition.",
				ResolutionDescription -> "When using the Cuvette Method, automatically set to False.",
				Widget-> Widget[Type->Enumeration,Pattern:>BooleanP],
				Category->"Absorbance Measurement"
			},
			{
				OptionName->StirBar,
				Default->Automatic,
				AllowNull->True,
				Description->"When using the Cuvette Method, indicates which model stir bar to be inserted into the cuvette to mix the sample.",
				ResolutionDescription -> "If AcquisitionMix is True, StirBar (model xxxx) must be specified. Automatically set to Null.",
				Widget-> Widget[Type->Object,
					Pattern:>ObjectP[{Model[Part,StirBar],Object[Part,StirBar]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments","Mixing Devices", "Stir Bars"
						}
					}
				],
				Category->"Absorbance Measurement"
			},
			{
				OptionName->RecoupSample,
				Default->False,
				AllowNull->True,
				Widget->Widget[Type->Enumeration, Pattern:>BooleanP],
				Description->"Indicates if the aliquot used to measure the absorbance should be returned to source container after each reading.",
				Category->"General"
			},
			{
				OptionName->ContainerOut,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[{Model[Container],Object[Container]}]
				],
				Description->"The desired container generated samples should be transferred into by the end of the experiment, with indices indicating grouping of samples in the same plates.",
				ResolutionDescription->"Automatically selected from ECL's stocked containers based on the volume of solution being prepared.",
				Category->"General"
			}
		],
		IndexMatching[
			{
				OptionName -> Wavelength,
				Default -> Automatic,
				Description -> "The specific wavelength(s) which should be used to measure absorbance in the samples.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[200 Nanometer, 1000 Nanometer],
					Units -> Alternatives[Nanometer]
				],
				ResolutionDescription -> "Automatically resolves to the shortest wavelength specified in the input samples' ExtinctionCoefficients field, and 260 Nanometer if that field is not populated.",
				Category -> "Optics"
			},
			{
				OptionName -> QuantificationAnalyte,
				Default -> Automatic,
				Description -> "The substance whose concentration should be determined during this experiment.",
				ResolutionDescription -> "Automatically set to the first value in the Analytes field of the input sample, or, if not populated, to the first analyte in the Composition field of the input sample.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[List @@ IdentityModelTypeP]
				],
				Category -> "Quantification"
			},
			{
				OptionName -> QuantifyConcentration,
				Default -> Automatic,
				Description -> "Indicates if the concentration of the samples should be determined.",
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				ResolutionDescription -> "Automatically resolves to True if QuantificationWavelength is specified and calling ExperimentAbsorbanceSpectroscopy, and resolves to False if calling ExperimentAbsorbanceIntensity.",
				Category -> "Quantification"
			},
			IndexMatchingInput -> "experiment samples"
		],
		AbsorbanceSharedOptions,
		SamplesOutStorageOptions
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceIntensity (sample input)*)


(* --- Core Function --- *)
ExperimentAbsorbanceIntensity[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[ExperimentAbsorbanceIntensity]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, messages, safeOptions, safeOptionTests, upload,
		confirm, canaryBranch, fastTrack, parentProt, unresolvedOptions, unresolvedOptionsTests, combinedOptions, resolveOptionsResult,
		resolvedOptionsNoHidden, allTests, estimatedRunTime,
		resourcePackets, resourcePacketTests, simulatedProtocol, simulation,
		resolvedOptions, resolutionTests, returnEarlyQBecauseFailure, performSimulationQ, validLengths, validLengthTests, expandedCombinedOptions, specifiedInstruments, protocolObject,
		cache, newCache, allPackets, listedSamples, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
		samplePreparationSimulation, downloadFields, mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed, optionsResolverOnly, returnEarlyQBecauseOptionsResolverOnly
	},

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
			ExperimentAbsorbanceIntensity,
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

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentAbsorbanceIntensity, myOptionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentAbsorbanceIntensity, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, safeOptions, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

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
		ValidInputLengthsQ[ExperimentAbsorbanceIntensity, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentAbsorbanceIntensity, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
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
	{upload, confirm, canaryBranch, fastTrack, parentProt, cache} = Lookup[safeOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* apply the template options *)
	(* need to specify the definition number (we are number 1 for samples at this point) *)
	{unresolvedOptions, unresolvedOptionsTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentAbsorbanceIntensity, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentAbsorbanceIntensity, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> Result], Null}
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
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentAbsorbanceIntensity, {mySamplesWithPreparedSamples}, combinedOptions]];

	(* get all specified instruments *)
	specifiedInstruments = DeleteDuplicates[Cases[Flatten[Lookup[combinedOptions, {Instrument}]], ObjectP[{Object[Instrument], Model[Instrument]}]]];

	(* get all the Download fields *)
	downloadFields = {
		{
			Packet[IncompatibleMaterials, Well, RequestedResources, SamplePreparationCacheFields[Object[Sample], Format -> Sequence]],
			Packet[Container[SamplePreparationCacheFields[Object[Container]]]],
			Packet[Field[Composition[[All, 2]][{Molecule, ExtinctionCoefficients, PolymerType, MolecularWeight}]]]
		},
		{
			Packet[Model, Status, IntegratedLiquidHandler, WettedMaterials, PlateReaderMode, SamplingPatterns, IntegratedLiquidHandlers],
			Packet[Model[{WettedMaterials, PlateReaderMode, SamplingPatterns}]],
			Packet[IntegratedLiquidHandler[Model]],
			Packet[IntegratedLiquidHandler[Model][Object]],
			Packet[IntegratedLiquidHandlers[Object]]
		}
	};

	(* make the up front Download call *)
	allPackets = Check[
		Quiet[
			Download[
				{
					mySamplesWithPreparedSamples,
					specifiedInstruments
				},
				Evaluate[downloadFields],
				Cache -> cache,
				Simulation -> samplePreparationSimulation,
				Date -> Now
			],
			{Download::FieldDoesntExist, Download::NotLinkField}
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

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult=If[gatherTests,

		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolutionTests} = resolveAbsorbanceOptions[Object[Protocol, AbsorbanceIntensity], mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> {Result, Tests}, Cache -> newCache, Simulation->samplePreparationSimulation];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolutionTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolutionTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolutionTests} = {resolveAbsorbanceOptions[Object[Protocol, AbsorbanceIntensity], mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> Result, Cache -> newCache, Simulation->samplePreparationSimulation], Null},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveAbsorbanceOptions doesn't have access to listedOptions *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentAbsorbanceIntensity,
		RemoveHiddenOptions[ExperimentAbsorbanceIntensity, resolvedOptions],
		Ignore -> ToList[myOptionsWithPreparedSamples],
		Messages -> False
	];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyQBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result | Simulation]];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQBecauseFailure = Which[
		MatchQ[resolveOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolutionTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[(returnEarlyQBecauseFailure || returnEarlyQBecauseOptionsResolverOnly) && !performSimulationQ,
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
				Object[Protocol, AbsorbanceIntensity],
				Download[mySamplesWithPreparedSamples, Object],
				unresolvedOptions,
				ReplaceRule[resolvedOptions, {Output -> {Result, Tests}, Cache -> newCache, Simulation->samplePreparationSimulation}]
			],
		True,
			{
				absorbanceResourcePackets[
					Object[Protocol, AbsorbanceIntensity],
					Download[mySamplesWithPreparedSamples, Object],
					unresolvedOptions,
					ReplaceRule[resolvedOptions, {Output -> Result, Cache -> newCache, Simulation->samplePreparationSimulation}]],
				Null
			}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateReadPlateExperiment[
			Object[Protocol, AbsorbanceIntensity],
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

	estimatedRunTime = 15 Minute +
		(Lookup[resolvedOptions,PlateReaderMixTime]/.Null->0 Minute) +
		(* Add time needed to clean/prime each each injection line *)
		(If[!MatchQ[Lookup[resolvedOptions,PrimaryInjectionSample],Null|{}],15*Minute,0*Minute]);

	(* --- Packaging the return value --- *)

	(* get all the tests together *)
	allTests = Cases[Flatten[{safeOptionTests, unresolvedOptionsTests, resolutionTests, resourcePacketTests}], _EmeraldTest];

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
			primitive=AbsorbanceIntensity@@Join[
				{
					Sample->mySamples
				},
				RemoveHiddenPrimitiveOptions[AbsorbanceIntensity,ToList[myOptions]]
			];

			(* Remove any hidden options before returning. *)
			nonHiddenOptions=RemoveHiddenOptions[ExperimentAbsorbanceIntensity,resolvedOptionsNoHidden];

			(* determine which work cell will be used (determined with the readPlateWorkCellResolver) to decide whether to call RSP or RCP *)
			experimentFunction = Lookup[$WorkCellToExperimentFunction, Lookup[resolvedOptions, WorkCell]];

			(* Memoize the value of ExperimentAbsorbanceIntensity so the framework doesn't spend time resolving it again. *)
			Internal`InheritedBlock[{ExperimentAbsorbanceIntensity, $PrimitiveFrameworkResolverOutputCache},
				$PrimitiveFrameworkResolverOutputCache=<||>;

				DownValues[ExperimentAbsorbanceIntensity]={};

				ExperimentAbsorbanceIntensity[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
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
					CanaryBranch->Lookup[safeOptions,CanaryBranch],
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
		UploadProtocol[
			resourcePackets[[1]], (* protocolPacket *)
			Upload->Lookup[safeOptions,Upload],
			Confirm->Lookup[safeOptions,Confirm],
			CanaryBranch->Lookup[safeOptions,CanaryBranch],
			ParentProtocol->Lookup[safeOptions,ParentProtocol],
			Priority->Lookup[safeOptions,Priority],
			StartDate->Lookup[safeOptions,StartDate],
			HoldOrder->Lookup[safeOptions,HoldOrder],
			QueuePosition->Lookup[safeOptions,QueuePosition],
			ConstellationMessage->Object[Protocol,AbsorbanceIntensity],
			Cache -> newCache,
			Simulation -> samplePreparationSimulation
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

(* cache the information about our common plates/containers that could be used for these experiments *)
standardPlatesDownloadCache[string_]:=standardPlatesDownloadCache[string]=Module[{},
	(* Handle memoization *)
	If[!MemberQ[$Memoization, Experiment`Private`standardPlatesDownloadCache],
		AppendTo[$Memoization, Experiment`Private`standardPlatesDownloadCache]
	];

	Quiet[
		Download[
			Flatten[{validModelsForLunaticLoading[],BMGCompatiblePlates[Absorbance]}],
			Evaluate[{SamplePreparationCacheFields[Model[Container],Format->Packet]}]
		],
		{Download::FieldDoesntExist}
	]
];


(* ::Subsubsection::Closed:: *)
(* ExperimentAbsorbanceIntensity (container input) *)


ExperimentAbsorbanceIntensity[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String|{LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions : OptionsPattern[ExperimentAbsorbanceIntensity]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, containerToSampleResult,containerToSampleSimulation,
		containerToSampleTests, inputSamples, messages, listedContainers, validSamplePreparationResult, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, samplePreparationSimulation,containerToSampleOutput,sampleOptions},

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
			ExperimentAbsorbanceIntensity,
			listedContainers,
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

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentAbsorbanceIntensity,
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
				ExperimentAbsorbanceIntensity,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->{Result,Simulation},
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

		(* call ExperimentAbsorbanceIntensity and get all its outputs *)
		ExperimentAbsorbanceIntensity[inputSamples, ReplaceRule[sampleOptions, Simulation->containerToSampleSimulation]]
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentAbsorbanceIntensityQ*)


DefineOptions[ValidExperimentAbsorbanceIntensityQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentAbsorbanceIntensity}
];


(* samples overloads *)
ValidExperimentAbsorbanceIntensityQ[mySamples : ListableP[_String | ObjectP[Object[Sample]]], myOptions : OptionsPattern[ValidExperimentAbsorbanceIntensityQ]] := Module[
	{listedOptions, preparedOptions, absSpecTests, initialTestDescription, allTests, verbose, outputFormat, listedSamples},

	(* get the options as a list *)
	(* also get the samples as a list *)
	listedOptions = ToList[myOptions];
	listedSamples = ToList[mySamples];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentAbsorbanceIntensity *)
	absSpecTests = ExperimentAbsorbanceIntensity[listedSamples, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[absSpecTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[DeleteCases[listedSamples, _String], Object], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ObjectToString[#1], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[DeleteCases[listedSamples, _String], Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, absSpecTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentAbsorbanceIntensityQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	(* do NOT use the symbol here because that will force RunUnitTest to call the SymbolSetUp/SymbolTearDown for this function's unit tests  *)
	Lookup[RunUnitTest[<|"ValidExperimentAbsorbanceIntensityQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentAbsorbanceIntensityQ"]

];


(* plates overloads *)
ValidExperimentAbsorbanceIntensityQ[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ValidExperimentAbsorbanceIntensityQ]] := Module[
	{listedOptions, preparedOptions, absSpecTests, initialTestDescription, allTests, verbose, outputFormat, listedContainers},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedContainers = ToList[myContainers];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentAbsorbanceIntensity *)
	absSpecTests = ExperimentAbsorbanceIntensity[listedContainers, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[absSpecTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[DeleteCases[listedContainers, _String], Object], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ObjectToString[#1], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[DeleteCases[listedContainers, _String], Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, absSpecTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentAbsorbanceIntensityQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	(* do NOT use the symbol here because that will force RunUnitTest to call the SymbolSetUp/SymbolTearDown for this function's unit tests *)
	Lookup[RunUnitTest[<|"ValidExperimentAbsorbanceIntensityQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentAbsorbanceIntensityQ"]

];


(* ::Subsection::Closed:: *)
(*ExperimentAbsorbanceIntensityOptions*)


DefineOptions[ExperimentAbsorbanceIntensityOptions,
	SharedOptions :> {ExperimentAbsorbanceIntensity},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];

(* samples overloads *)
ExperimentAbsorbanceIntensityOptions[mySamples : ListableP[_String | ObjectP[Object[Sample]]], myOptions : OptionsPattern[ExperimentAbsorbanceIntensityOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentAbsorbanceIntensity *)
	options = ExperimentAbsorbanceIntensity[mySamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentAbsorbanceIntensity],
		options
	]
];


(* containers overloads *)
ExperimentAbsorbanceIntensityOptions[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ExperimentAbsorbanceIntensityOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentAbsorbanceIntensity *)
	options = ExperimentAbsorbanceIntensity[myContainers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentAbsorbanceIntensity],
		options
	]
];



(* ::Subsection::Closed:: *)
(*ExperimentAbsorbanceIntensityPreview*)


DefineOptions[ExperimentAbsorbanceIntensityPreview,
	SharedOptions :> {ExperimentAbsorbanceIntensity}
];


(* samples overloads *)
ExperimentAbsorbanceIntensityPreview[mySamples : ListableP[_String | ObjectP[Object[Sample]]], myOptions : OptionsPattern[ExperimentAbsorbanceIntensityPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	ExperimentAbsorbanceIntensity[mySamples, Append[noOutputOptions, Output -> Preview]]
];


(* container overloads *)
ExperimentAbsorbanceIntensityPreview[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ExperimentAbsorbanceIntensityPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	ExperimentAbsorbanceIntensity[myContainers, Append[noOutputOptions, Output -> Preview]]
];
