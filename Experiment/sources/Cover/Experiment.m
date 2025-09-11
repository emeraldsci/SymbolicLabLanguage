(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Cover*)


(* ::Subsubsection:: *)
(*ExperimentCover Options*)


DefineOptions[ExperimentCover,
	Options :> {
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples that are being covered, for use in downstream unit operations.",
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
				Description->"A user defined word or phrase used to identify the containers of the samples that are being covered, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> CoverType,
				Default -> Automatic,
				Description -> "The type of cover (Crimp, Seal, Screw, Snap, AluminumFoil, Pry, or Place) that should be used to cover the container.",
				ResolutionDescription -> "Automatically set to the first cover type in the field CoverTypes from the Model of the Object[Container] that is to be covered.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CoverTypeP
				]
			},
			{
				OptionName -> UsePreviousCover,
				Default -> Automatic,
				Description -> "Indicates if the previous cover should be used to re-cover this container. Note that the previous cover cannot be used if it is discarded or if CoverType->Crimp|Seal.",
				ResolutionDescription -> "Automatically set to True if the PreviousCover field is set in Object[Container] and the PreviousCover is not Discarded or on another container. Automatically set to Null if the container has a built in cover.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> Opaque,
				Default -> Automatic,
				Description -> "Indicates if an opaque cover is used to cover the container.",
				ResolutionDescription -> "Automatically set based on the Cover that is specified by the user. Otherwise, resolves to False.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> Cover,
				Default -> Automatic,
				Description -> "The cap, lid, or plate seal that should be secured to the top of the given container.",
				ResolutionDescription -> "Automatically set to a cover that matches the calculated CoverType, Opaque, and UsePreviousCover options. This cover must also be compatible with the given container's CoverFootprints.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Item, Lid],
						Object[Item, Lid],
						Model[Item, Cap],
						Object[Item, Cap],
						Model[Item, PlateSeal],
						Object[Item, PlateSeal]
					}],
					PreparedSample -> True,
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Plate Lids & Seals"
						}
					}
				]
			},
			{
				OptionName -> CoverLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the covers that are being used in the experiment, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> Septum,
				Default -> Automatic,
				Description -> "The septum that is used in conjunction with the cover to secure the top of the given container.",
				ResolutionDescription -> "Automatically set a Model[Item, Septum] with the same CoverFootprint as the calculated Cover, if CoverType->Crimp and the calculated Cover requires a septum (SeptumRequired->True in Model[Item, Cap]).",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Item, Septum],
						Object[Item, Septum]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Plate Lids & Seals"
						}
					}
				]
			},
			{
				OptionName -> Stopper,
				Default -> Null,
				Description -> "The stopper that is used in conjunction with the crimped cover and septum to secure the top of the given container.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Item, Stopper],
						Object[Item, Stopper]
					}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Plate Lids & Seals"
						}
					}
				]
			},
			{
				OptionName -> Instrument,
				Default -> Automatic,
				Description -> "The device used to help secure the cover to the top of the container.",
				ResolutionDescription -> "Automatically set to a Model[Instrument, Crimper] that has the same CoverFootprint as the calculated Cover if CoverType->Crimp or set to a Model[Instrument, PlateSealer] that has the same CoverFootprint as the calculated Cover if CoverType->Seal. Otherwise, is set to Null.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Instrument, Crimper],
						Object[Instrument, Crimper],

						Model[Instrument, PlateSealer],
						Object[Instrument, PlateSealer]
					}]
				]
			},
			{
				OptionName -> CrimpingHead,
				Default -> Automatic,
				Description -> "The part that is attached to the Object[Instrument, Crimper] that transfers the pneumatic pressure from the crimping instrument to secure the crimped cap to the top of the container.",
				ResolutionDescription -> "Automatically set to a Model[Part, CrimpingHead] that has the same with the CoverFootprint and CrimpType as the Cover, if the Cover is a Model[Item,Cap] with CoverType->Crimp.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Part, CrimpingHead],
						Object[Part, CrimpingHead]
					}]
				]
			},
			{
				OptionName -> DecrimpingHead,
				Default -> Automatic,
				Description -> "Used in conjunction with the CrimpingHead to remove the crimped cap from the covered container, if the crimp was not successful. Successful crimps are (1) level with the bottom of the container and (2) not over or under tightened to the top of the container. If the previous crimping attempt is not successful, the operator will decrimp and recrimp until they have a successful crimp.",
				ResolutionDescription -> "Automatically set to a Model[Part, DecrimpingHead] that has the same with the CoverFootprint as the Cover, if the Cover is a Model[Item,Cap] with CoverType->Crimp.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Part, DecrimpingHead],
						Object[Part, DecrimpingHead]
					}]
				]
			},
			{
				OptionName -> CrimpingPressure,
				Default -> Automatic,
				Description -> "The pressure of the gas that is connected to the pneumatic Model[Instrument, Crimper] that determines the strength used to crimp or decrimp the crimped cap.",
				ResolutionDescription -> "Automatically set to the CrimpingPressure field in the Model[Item, Cap] if CoverType->Crimp. If this field is empty, set to 20 PSI. Otherwise, if CoverType is not Crimp, set to Null.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 PSI, 90 PSI],
					Units -> PSI
				]
			},
			{
				OptionName -> Temperature,
				Default -> Automatic,
				Description -> "The temperature that will be used to heat the seal for sealing a plate when using heat-activated adhesive seal.",
				ResolutionDescription -> "Automatically set to 180 Celsius or 185 Celsius if the Cover option resolves to a heat-activated adhesive plate seal .",
				AllowNull -> True,
				Widget -> Widget[Type->Quantity,
					Pattern :> RangeP[100 Celsius,190 Celsius],
					Units -> {Celsius,{Celsius,Kelvin,Fahrenheit}}
				],
				Category -> "General"
			},
			{
				OptionName -> Time,
				Default -> Automatic,
				Description -> "The duration of time used for applying Temperature to seal the plate when using heat-activated adhesive seal.",
				ResolutionDescription -> "Automatically set to 3.5 Second if the Cover option resolves to a heat-activated adhesive plate seal for SBS plates.",
				AllowNull -> True,
				Widget -> Widget[Type->Quantity,
					Pattern :> RangeP[0.5 Second,10 Second],
					Units -> {Second,{Milli*Second,Second,Minute}}
				],
				Category -> "General"
			},
			{
				OptionName -> Parafilm,
				Default -> Automatic,
				Description -> "Indicates if Parafilm should be used to secure the cover after it is attached to the container.",
				ResolutionDescription -> "Automatically set based on the Parafilm field in Model[Container], Object[Container], Model[Sample] or Object[Sample]. If the field in these objects is not set, parafilm is not used unless explicitly specified by the user.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> KeckClamp,
				Default -> Automatic,
				Description -> "The Keck Clamp that is used to secure a tapered stopper Cover to the tapered ground glass joint opening of the Container.",
				ResolutionDescription -> "If the Cover has a specified TaperGroundJointSize, automatically set to a Model[Item, Clamp] that has the same TaperGroundJointSize.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Item, Clamp], Object[Item, Clamp]}]
				]
			},
			{
				OptionName -> PlateSealAdapter,
				Default -> Automatic,
				Description -> "Used to raise the SBS-format microplate inside of a PlateSealer instrument so that the plate is able to reach the height requirement of PlateSealer.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Container,Rack], Object[Container,Rack]}]]
			},
			{
				OptionName -> PlateSealPaddle,
				Default -> Automatic,
				Description -> "Used to apply adhesive PlateSeal to the top of the plate firmly.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Item,PlateSealRoller], Object[Item,PlateSealRoller]}]]
			},
			{
				OptionName -> AluminumFoil,
				Default -> Automatic,
				Description -> "Indicates if Aluminum Foil should be wrapped around the entire container after the cover is attached in order to protect the container's contents from light. Note that this option is NOT to use an aluminum foil cover; in order to specify that, CoverType must be set to AluminumFoil.",
				ResolutionDescription -> "Automatically set based on the AluminumFoil field in Model[Container], Object[Container], Model[Sample] or Object[Sample]. If the field in these objects is not set, aluminum foil is not used unless explicitly specified by the user.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> KeepCovered,
				Default -> Automatic,
				Description -> "Indicates if the cover on this container should be \"peaked\" off when transferred into/out of instead of taken off completely when performing Manual Transfers. When performing robotic manipulations, this indicates that the container should be re-covered after any manipulation that uncovers it is completed.",
				ResolutionDescription -> "Automatically set based on the KeepCovered field in Object[Container]. If the field in this object is not set, the option will be set to False.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> Environment,
				Default -> Automatic,
				ResolutionDescription -> "Automatically set to the specific BSC, fume hood, glove box, or bench that the sample is currently on (if applicable). Otherwise, if SterileTechnique->True, this option will be set to a BSC. Otherwise, defaults to a fume hood.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Instrument],
						Model[Container, Bench],
						Model[Container, OperatorCart],

						Object[Instrument],
						Object[Container, Bench],
						Object[Container, OperatorCart]
					}],
					PreparedContainer -> False
				],
				Description -> "The environment in which the covering should be performed (Biosafety Cabinet, Fume Hood, Glove Box, or Benchtop Handling Station). This option will be set to Null when Preparation->Robotic (the covering will be performed inside of the Liquid Handler enclosure).",
				Category -> "General"
			},
			ModifyOptions[
				SterileTechniqueOption,
				Category->"General"
			]
		],
		{
			OptionName -> AluminumFoilRoll,
			Default -> Automatic,
			Description -> "Indicates the model or object of aluminum foil that is used to wrap around containers (if AluminumFoil is set to True), or to create AluminumFoil lids (if CoverType is set to AluminumFoil).",
			ResolutionDescription -> "Automatically set to Model[Item, Consumable, \"Aluminum Foil\"] if AluminumFoil is set to True, or if CoverType is AluminumFoil for any sample. If this option is set but AluminumFoil is False and CoverType is not set to AluminumFoil for all samples, then an error is thrown.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Consumable], Object[Item, Consumable]}]
			]
		},
		(*===Shared Options===*)
		FastTrackOption,
		PreparationOption,
		ProtocolOptions,
		ModifyOptions[WorkCellOption,
			{Widget ->
					Widget[Type -> Enumeration,
						Pattern :> STAR | bioSTAR | microbioSTAR],
			Category->"Hidden"}
		],
		NonBiologyPostProcessingOptions,
		SimulationOption,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions
	}
];

(* ::Subsubsection::Closed:: *)
(* ExperimentCover Source Code *)

(* ExperimentCover *)

(* NOTE: No Container to Sample overload since we have to be able to cover/uncover empty containers. *)
(* NOTE: Internal to the experiment function, we actually convert samples into containers since we care about the container, not the sample. *)

(* -- Main Overload --*)
ExperimentCover[myInputs:ListableP[ObjectP[{Object[Sample], Object[Container]}]],myOptions:OptionsPattern[]]:=Module[
	{
		cache, cacheBall, collapsedResolvedOptions, expandedSafeOps, gatherTests, inheritedOptions, listedOptions,
		listedInputs, messages, myOptionsWithPreparedSamples, myOptionsWithPreparedSamplesNamed, myInputsWithPreparedSamples,
		myInputsWithPreparedSamplesNamed, output, outputSpecification, coverCache, performSimulationQ,
		protocolObject, resolvedOptions, resolvedOptionsResult, resolvedOptionsTests, resourceResult, resourcePacketTests,
		optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ, safeOps, safeOpsNamed, safeOpsTests, templatedOptions, templateTests, resolvedPreparation,
		samplePreparationSimulation, validLengths, validLengthTests, validSamplePreparationResult, simulatedProtocol, simulation,
		listedContainers, objectContainerFields, objectContainerPacketFields, modelContainerFields, objectSampleFields,
		modelSampleFields, optionsWithoutCache
	},

	(* Determine the requested return value from the function. *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests. *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Remove temporal links. *)
	{listedInputs, listedOptions}=removeLinks[ToList[myInputs], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{myInputsWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentCover,
			listedInputs,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentCover,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentCover,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitize-inputs to clean any named objects. *)
	{myInputsWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[myInputsWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed. *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length. *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentCover,{myInputsWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentCover,{myInputsWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point). *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions. *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentCover,{ToList[myInputsWithPreparedSamples]},ToList[myOptionsWithPreparedSamples],Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentCover,{ToList[myInputsWithPreparedSamples]},ToList[myOptionsWithPreparedSamples]],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options. *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentCover,{ToList[myInputsWithPreparedSamples]},inheritedOptions]];

	(* Fetch the cache from expandedSafeOps. *)
	cache=ToList[Lookup[expandedSafeOps, Cache, {}]];

	(* Drop the cache from myOptions. *)
	optionsWithoutCache=Normal[KeyDrop[ToList[myOptions], Cache], Association];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Normalize our inputs all into containers. This is because Cover cares about the container, not about the sample. *)
	listedContainers=If[Length[Cases[myInputsWithPreparedSamples, ObjectP[Object[Sample]]]]>0,
		Module[{samplePackets},
			(* Get the packets of any sample inputs we have. *)
			samplePackets=Download[
				Cases[myInputsWithPreparedSamples, ObjectP[Object[Sample]]],
				Packet[Container],
				Simulation->samplePreparationSimulation
			];

			(* Replace samples with their container. *)
			myInputsWithPreparedSamples/.Rule@@@Transpose[{ObjectP/@Lookup[samplePackets, Object], Download[Lookup[samplePackets, Container], Object]}]
		],
		myInputsWithPreparedSamples
	];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
	objectContainerFields=DeleteDuplicates[Flatten[{PreviousCover,Cover,Septum,Parafilm,AluminumFoil,KeepCovered,TaperGroundJointSize,Hermetic,StoreInverted,SamplePreparationCacheFields[Object[Container]], Notebook}]];
	objectContainerPacketFields=Packet@@objectContainerFields;
	modelContainerFields=DeleteDuplicates[Flatten[{BuiltInCover,CoverTypes,CoverFootprints,Parafilm,AluminumFoil,ExternalDimensions3D,TaperGroundJointSize,StoreInverted,SamplePreparationCacheFields[Model[Container]]}]];
	objectSampleFields=DeleteDuplicates[Flatten[{Parafilm,AluminumFoil,SamplePreparationCacheFields[Object[Sample]]}]];
	modelSampleFields=DeleteDuplicates[Flatten[{Parafilm,AluminumFoil,SamplePreparationCacheFields[Model[Sample]]}]];

	coverCache=Flatten@Quiet[
		Download[
			{
				listedContainers,
				listedContainers,
				listedContainers,
				listedContainers,
				Cases[optionsWithoutCache, ObjectReferenceP[Object[Instrument, Crimper]], Infinity],
				Cases[optionsWithoutCache, ObjectReferenceP[Object[Part, CrimpingHead]], Infinity],
				Cases[optionsWithoutCache, ObjectReferenceP[Object[Part, DecrimpingHead]], Infinity],
				Cases[optionsWithoutCache, ObjectReferenceP[Object[Instrument, PlateSealer]], Infinity],
				Cases[optionsWithoutCache, ObjectReferenceP[Object[Item, Cap]], Infinity],
				Cases[optionsWithoutCache, ObjectReferenceP[Object[Item, Cap]], Infinity],
				Cases[optionsWithoutCache, ObjectReferenceP[Object[Item, Lid]], Infinity],
				Cases[optionsWithoutCache, ObjectReferenceP[Object[Item, PlateSeal]], Infinity],
				Cases[optionsWithoutCache, ObjectReferenceP[Object[Item, Septum]], Infinity],
				Cases[optionsWithoutCache, ObjectReferenceP[Object[Item, PlateSealRoller]], Infinity],
				listedContainers,
				ToList@Lookup[safeOps,ParentProtocol]
			},
			{
				List@objectContainerPacketFields,
				List@Packet[Model[modelContainerFields]],
				List@Packet[Contents[[All,2]][objectSampleFields]],
				List@Packet[Contents[[All,2]][Model][modelSampleFields]],
				List@Packet[Model[{MinPressure, MaxPressure}]],
				List@Packet[Model[{CoverFootprint, CrimpType, Name}]],
				List@Packet[Model[{CoverFootprint, Name}]],
				List@Packet[Model[{CoverFootprint, TemperatureActivated, MinTemperature, MaxTemperature, MinDuration, MaxDuration, Name}]],
				List@Packet[Model,Container,Name],
				List@Packet[Model[{CoverType, CoverFootprint, CrimpType, SeptumRequired, TaperGroundJointSize, Opaque, Reusable, EngineDefault, Barcode, CrimpingPressure, Name}]],
				List@Packet[Model[{CoverType, CoverFootprint, Opaque, Dimensions, NotchPositions, Reusable, EngineDefault, Name}]],
				List@Packet[Model[{CoverType, CoverFootprint, Opaque, Pierceable, Dimensions, NotchPositions, Reusable, EngineDefault, Name}]],
				List@Packet[Model[{CoverFootprint, Pierceable, EngineDefault, Barcode, Name}]],
				List@Packet[Model[{Name}]],
				{
					Packet[PreviousCover[{Model, Status, CoveredContainer, Container, Name}]],
					Packet[PreviousCover[Model][{CoverType, CoverFootprint, Opaque, CrimpType, SeptumRequired, Reusable, EngineDefault, Barcode, CrimpingPressure, Name}]]
				},
				{Packet[ActiveCart]}
			},
			Cache->cache,
			Simulation->samplePreparationSimulation
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* Combine our downloaded and passed cache. *)
	cacheBall=FlattenCachePackets[{cache,coverCache}];

	(* Build the resolved options. *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentCoverOptions[
			listedInputs,
			listedContainers,
			expandedSafeOps,
			Cache->cacheBall,
			Simulation->samplePreparationSimulation,
			Output->{Result,Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={
				resolveExperimentCoverOptions[
					listedInputs,
					listedContainers,
					expandedSafeOps,
					Cache->cacheBall,
					Simulation->samplePreparationSimulation
				],
				{}
			},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options. *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentCover,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation = Lookup[resolvedOptions, Preparation];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* Run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early. *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	performSimulationQ = Or[
		MemberQ[output, Simulation],
		And[
			MemberQ[output, Result],
			MatchQ[resolvedPreparation, Robotic]
		]
	];

	(* If option resolution failed, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentCover,collapsedResolvedOptions],
			Preview->Null,
			Simulation -> Simulation[]
		}]
	];


	(* Build packets with resources. *)
	(* NOTE: resourceResult is either $Failed or {protocolPacket, unitOperationPackets} where protocolPacket will be Null if *)
	(* Preparation->Robotic. *)
	{resourceResult, resourcePacketTests} = Which[
		MatchQ[resolvedOptionsResult, $Failed],
			{$Failed, {}},
		gatherTests,
			coverResourcePackets[
				listedInputs,
				listedContainers,
				templatedOptions,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->samplePreparationSimulation,
				Output->{Result,Tests}
			],
		True,
			{
				coverResourcePackets[
					listedInputs,
					listedContainers,
					templatedOptions,
					resolvedOptions,
					Cache->cacheBall,
					Simulation->samplePreparationSimulation
				],
				{}
			}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = Which[
		!performSimulationQ,
			{Null, samplePreparationSimulation},
		True,
			simulateExperimentCover[
				If[MatchQ[resourceResult, $Failed],
					$Failed,
					resourceResult[[1]]
				],
				If[MatchQ[resourceResult, $Failed],
					$Failed,
					resourceResult[[2]]
				],
				listedInputs,
				listedContainers,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->samplePreparationSimulation,
				ParentProtocol->Lookup[safeOps,ParentProtocol]
			]
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentCover,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation,
			(* The time to cover is the cover times in that group plus 10 seconds per container. *)
			(* So compute this value for each group then sum *)
			RunTime -> (10 Second) * Length[listedInputs]
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourceResult,$Failed],
			$Failed,

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps,Upload], False],
			resourceResult[[2]], (* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive. *)
		MatchQ[resolvedPreparation, Robotic],
			Module[{primitive, nonHiddenOptions},
				(* Create our transfer primitive to feed into RoboticSamplePreparation. *)
				primitive=Cover@@Join[
					{
						Sample->Download[ToList[listedInputs], Object]
					},
					RemoveHiddenPrimitiveOptions[Cover,ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions=RemoveHiddenOptions[ExperimentCover,collapsedResolvedOptions];

				(* Memoize the value of ExperimentCover so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentCover, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentCover]={};

					ExperimentCover[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification=Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Result -> resourceResult[[2]],
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> simulation,
							(* Covering should only take 10 seconds at the max per container. *)
							RunTime -> (10 Second) * Length[listedInputs]
						}
					];
					Module[{experimentFunction,resolvedWorkCell},
						(* look up which workcell we've chosen *)
						resolvedWorkCell = Lookup[resolvedOptions, WorkCell];

						(* pick the corresponding function from the association above *)
						experimentFunction=Lookup[$WorkCellToExperimentFunction, resolvedWorkCell];

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
				]
			],
		(* Actually upload our protocol object. We are being called as a subprotcol in ExperimentManualSamplePreparation. *)
		True,
			UploadProtocol[
				resourceResult[[1]],
				resourceResult[[2]],
				Upload->Lookup[safeOps,Upload],
				Confirm->Lookup[safeOps,Confirm],
				CanaryBranch->Lookup[safeOps,CanaryBranch],
				ParentProtocol->Lookup[safeOps,ParentProtocol],
				Priority->Lookup[safeOps,Priority],
				StartDate->Lookup[safeOps,StartDate],
				HoldOrder->Lookup[safeOps,HoldOrder],
				QueuePosition->Lookup[safeOps,QueuePosition],
				ConstellationMessage->Object[Protocol,Cover],
				Cache->cache,
				Simulation-> simulation
			]
	];
	(* Return requested output. *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentCover,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> (10 Second) * Length[listedInputs]
	}
];

(* ::Subsection:: *)
(* resolveCoverMethod *)

DefineOptions[resolveCoverMethod,
	SharedOptions:>{
		ExperimentCover,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* NOTE: myContainers can be Automatic when the user has not yet specified a value for autofill. *)
resolveCoverMethod[
	myContainers:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions, outputSpecification, output, gatherTests, allModelContainerPackets, modelCoverPackets, objectCoverPackets,
		allModelCoverPackets, modelInstrumentPackets, objectInstrumentPackets, allModelInstrumentPackets,
		manualRequirementStrings, roboticRequirementStrings, result, tests},

	(* Get our safe options. *)
	safeOptions=SafeOptions[resolveCoverMethod, ToList[myOptions]];

	(* Determine the requested return value from the function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests. *)
	gatherTests=MemberQ[output,Tests];

	(* Download information that we need from our inputs and/or options. *)
	{
		allModelContainerPackets,
		modelCoverPackets,
		objectCoverPackets,
		modelInstrumentPackets,
		objectInstrumentPackets
	}=Flatten/@Quiet[
		Download[
			{
				Cases[ToList[myContainers], ObjectP[]],
				Cases[Lookup[ToList[myOptions], Cover, {}], ObjectP[Model[]]],
				Cases[Lookup[ToList[myOptions], Cover, {}], ObjectP[Object[]]],
				Cases[Lookup[ToList[myOptions], Instrument, {}], ObjectP[Model[]]],
				Cases[Lookup[ToList[myOptions], Instrument, {}], ObjectP[Object[]]]
			},
			{
				{Packet[Name, Object, Model], Packet[Model[{Name, Footprint, Dimensions}]]},
				{Packet[Name, Dimensions, NotchPositions, Object]},
				{Packet[Name, Object, Model], Packet[Model[{Name, Dimensions, NotchPositions, Object}]]},
				{Packet[Name]},
				{Packet[Name, Object, Model]}
			},
			Cache->Lookup[ToList[myOptions], Cache, {}],
			Simulation->Lookup[ToList[myOptions], Simulation, Null]
		],
		{Download::NotLinkField, Download::FieldDoesntExist, Download::MissingCacheField}
	];

	allModelCoverPackets=Cases[Flatten[{modelCoverPackets, objectCoverPackets}], ObjectP[Model[]]];
	allModelInstrumentPackets=Cases[Flatten[{modelInstrumentPackets, objectInstrumentPackets}], ObjectP[Model[]]];

	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings={
		Module[{manualOnlyOptions},
			manualOnlyOptions=Select[
				{ImageSample, MeasureVolume, MeasureWeight, Septum, Stopper, CrimpingHead, DecrimpingHead, CrimpingPressure, Parafilm, AluminumFoil, KeckClamp},
				(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|False|Automatic]]&)
			];

			If[Length[manualOnlyOptions]>0,
				"the following Manual-only options were specified "<>ToString[manualOnlyOptions],
				Nothing
			]
		],
		(* NOTE: temperature, time, or plateSealAdapter are only compatible with temperature-activated adhesive plate seals. *)
		(* plateSealPaddle is only compatible with adhesive seal for crystallization. *)
		(* error message if they specify this options when Preparation->Robotic. *)
		Module[{manualSealOptions},
			manualSealOptions=Select[
				{Temperature, Time, PlateSealAdapter, PlateSealPaddle},
				(!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|False|Automatic]]&)
			];

			If[Length[manualSealOptions]>0,
				"the following Manual-only options were specified "<>ToString[manualSealOptions]<> "(Temperature,Time and PlateSealAdapter are only specified when temperature-activated adhesive plate seal is used and PlateSealPaddle is only specified when manual sealed crystallization seal is used)",
				Nothing
			]
		],
		(* Only lids and plateseals can be used to cover robotically. *)
		Module[{manualOnlyCovers},
			manualOnlyCovers=Select[
				allModelCoverPackets,
				(
					And[
						!MatchQ[#, ObjectP[Model[Item, Lid, "id:N80DNj16AaKA"]]], (* Universal Black Lid *)
						!MatchQ[#, ObjectP[Model[Item, PlateSeal, "id:R8e1PjpEDbea"]]], (* Hamilton Optically Clear Plate Seal *)
						!MatchQ[#, ObjectP[Model[Item, PlateSeal, "id:O81aEBZzkJ1D"]]], (* Hamilton Aluminum Plate Seal *)
						Or[
							!MatchQ[#, ObjectP[{Model[Item, Lid], Model[Item, PlateSeal]}]],
							!MatchQ[#, ObjectP[Model[Item, Lid]]] && MatchQ[Lookup[#, Dimensions], {RangeP[12.6 Centimeter, 12.8 Centimeter], RangeP[8.4 Centimeter, 8.6 Centimeter], RangeP[0.6 Centimeter, 2 Centimeter]}],
							!MatchQ[Lookup[#, NotchPositions], {}]
						]
					]
				&)
			];

			If[Length[manualOnlyCovers]>0,
				"the following Manual only Cover(s) were specified "<>ObjectToString[Lookup[manualOnlyCovers, Object], Cache->manualOnlyCovers] <> " (in order for a cover to be used robotically, 1) it must be a lid or a hamilton compatible plate seal, 2) its dimensions must be match {RangeP[12.6 Centimeter, 12.8 Centimeter], RangeP[8.4 Centimeter, 8.6 Centimeter], RangeP[0.6 Centimeter, 2 Centimeter]} or SBS  and 3) it must not have any NotchPositions)",
				Nothing
			]
		],
		(* Only plates can be covered robotically. *)
		Module[{modelContainerOrderedPackets,manualOnlyPlates,manualOnlyContainers},
			(* Rearrange the allModelContainerPackets so it has the same order as input container. *)
			modelContainerOrderedPackets=fetchModelPacketFromCache[#,allModelContainerPackets]&/@Cases[ToList[myContainers], ObjectP[]];
			(* All plates can be covered by lid robotically with CoverType Place. *)
			(* Only plates between 13.6mm and 16.2mm can be covered by plate seal robotically with CoverType Seal. *)
			manualOnlyPlates= If[!MatchQ[Position[Lookup[ToList[myOptions],CoverType,{}],Seal],{}],
				Select[Take[modelContainerOrderedPackets,#]&/@Position[Lookup[ToList[myOptions],CoverType],Seal],
					MatchQ[Lookup[#, Footprint], Plate]&&!MatchQ[Lookup[#, Dimensions], {_, _, RangeP[$MinRoboticPlateSealHeight,$MaxRoboticPlateSealHeight]}]&],
				{}
			];
			(* Containers other than plates can only be covered manually. *)
			manualOnlyContainers=Join[Select[modelContainerOrderedPackets,!MatchQ[Lookup[#, Footprint], Plate]&],manualOnlyPlates];

			If[Length[manualOnlyContainers]>0,
				"the following Manual only Container(s) were specified "<>ObjectToString[Lookup[manualOnlyContainers, Object], Cache->manualOnlyContainers] <> " (in order for a cover to be used robotically, 1) the container has to be a plate, 2) the height of plate must be between 13.6mm and 16.2mm)",
				Nothing
			]
		],
		(* Only CoverType Place and Seal can be used for robotic preparation. *)
		Module[{manualOnlyCoverTypes},
			manualOnlyCoverTypes=Cases[Lookup[safeOptions, CoverType], Except[Place|Seal|Automatic]];

			If[Length[manualOnlyCoverTypes]>0,
				"the following Manual only CoverType(s) were specified"<>ToString[manualOnlyCoverTypes],
				Nothing
			]
		],
		(* Kebby Pneumatic Power Crimper and Bio-rad PlateSealer can only be used for manual preparation. *)
		Module[{manualOnlyInstruments},
			manualOnlyInstruments=Select[allModelInstrumentPackets, MatchQ[#, ObjectP[{Model[Instrument, PlateSealer,"id:AEqRl9KEXbkd"], Model[Instrument, Crimper, "id:P5ZnEjdkMe9O"]}]]&];
			If[Length[manualOnlyInstruments]>0,
				"the following Manual only Instrument(s) were specified "<>ObjectToString[Lookup[manualOnlyInstruments, Object], Cache->manualOnlyInstruments],
				Nothing
			]
		],
		(* Incubate, centrifuge, filter and aliquot can only be done with manual operation. *)
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[IncubatePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Incubate Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[CentrifugePrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Centrifuge Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[FilterPrepOptionsNew], "OptionSymbol"], Except[ListableP[False|Null|Automatic]]]],
			"the Filter Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		If[MemberQ[safeOptions, Verbatim[Rule][Alternatives@@Lookup[OptionDefinition[AliquotOptions], "OptionSymbol"], Except[ListableP[False|Null|Automatic|{Automatic..}]]]],
			"the Aliquot Sample Preparation stage is set to True (Sample Preparation is only supported Manually)",
			Nothing
		],
		(* If the user set the preparation to be manual. *)
		If[MatchQ[Lookup[safeOptions, Preparation], Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		]
	};
	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings={
		If[MatchQ[Lookup[safeOptions, Preparation], Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		]
	};

	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
		(* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
		Block[{$MessagePrePrint},
			Message[
				Error::ConflictingUnitOperationMethodRequirements,
				listToString[manualRequirementStrings],
				listToString[roboticRequirementStrings]
			]
		]
	];

	(* Return our result and tests. *)
	result=Which[
		!MatchQ[Lookup[safeOptions, Preparation], Automatic],
			Lookup[safeOptions, Preparation],
		Length[manualRequirementStrings]>0,
			Manual,
		Length[roboticRequirementStrings]>0,
			Robotic,
		True,
			{Manual, Robotic}
	];

	tests=If[MatchQ[gatherTests, False],
		{},
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the Cover primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
		}
	];

	outputSpecification/.{Result->result, Tests->tests}
];

(* ::Subsubsection::Closed:: *)
(* resolveExperimentCoverWorkCell *)

resolveExperimentCoverWorkCell[
	myContainers:ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
	myOptions:OptionsPattern[resolveExperimentCoverWorkCell]
]:=If[Or[
		MemberQ[ToList[Lookup[ToList[myOptions], Instrument]], ObjectP[{Model[Instrument, PlateSealer],Object[Instrument,PlateSealer]}]],
		MemberQ[ToList[Lookup[ToList[myOptions], Cover]], ObjectP[{Model[Item, PlateSeal],Object[Item,PlateSeal]}]],
		MemberQ[ToList[Lookup[ToList[myOptions], CoverType]], Seal]
		],
			{bioSTAR,microbioSTAR},
			{STAR,bioSTAR,microbioSTAR}
	];

(* NOTE: We also cache our search because we will do it multiple times. *)
coverModelsSearch[fakeString_]:=coverModelsSearch[fakeString]=Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`coverModelsSearch],
		AppendTo[$Memoization, Experiment`Private`coverModelsSearch]
	];

	Search[
		{
			{Model[Instrument, Crimper]},
			{Model[Part, Decrimper]},
			{Model[Part, CrimpingHead]},
			{Model[Part, DecrimpingHead]},
			{Model[Part, CapPrier]},
			{Model[Instrument, PlateSealer]},
			{Model[Item, Cap]},
			{Model[Item, Lid]},
			{Model[Item, PlateSeal]},
			{Model[Item, Septum]},
			{Model[Item, Clamp]},
			{Model[Part, AmpouleOpener]}
		},
		{
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True && TaperGroundJointSize != Null,
			Deprecated != True && DeveloperObject != True && MinVolume != Null && MaxVolume != Null
		}
	]
];

(* Cache our crimping jig packets as well. *)
getCrimpingJigPackets[fakeString_]:=getCrimpingJigPackets[fakeString]=Module[{},
	If[!MemberQ[$Memoization, getCrimpingJigPackets],
		AppendTo[$Memoization, getCrimpingJigPackets]
	];

	Download[
		Search[Model[Part, CrimpingJig], Deprecated!=True && DeveloperObject!=True],
		Packet[Name, VialHeight, VialFootprint]
	]
];

(* Cache PCR plate models *)
allPCRPlatesSearch[fakeString_] := allPCRPlatesSearch[fakeString] = Module[{},
	(* Add allPCRPlatesSearch to list of Memoized functions *)
	If[!MemberQ[$Memoization, Experiment`Private`allPCRPlatesSearch],
		AppendTo[$Memoization, Experiment`Private`allPCRPlatesSearch]
	];

	Search[Model[Container, Plate], StringContainsQ[Name, "PCR"]]
];

(* ::Subsection:: *)
(* coverModelPackets *)

(* NOTE: This function will try to find deprecated or developer object models in our option list and explicitly call download to get them. *)
(* Then, it combines it with the non-deprecated model packets that we always download and have previously cached, for speed. *)
coverModelPackets[myOptions_List]:=Module[
	{searchResult, allModelsFromOptions, modelsNotInSearch, suppliedDownloadResult},

	(* Search for all transfer models in the lab to download from. *)
	searchResult=coverModelsSearch["Memoization"];

	(* Get all the object models of interest from our options. *)
	allModelsFromOptions=Download[
		DeleteDuplicates@Cases[
			KeyDrop[myOptions, {Cache, Simulation}],
			ObjectP[{Model[Item], Model[Instrument]}],
			Infinity
		],
		Object
	];

	(* Find the objects for which we do not have packets for. *)
	modelsNotInSearch=Complement[allModelsFromOptions, Flatten[searchResult]];

	(* Download packets for these models. *)
	(* NOTE: Keep this in the same order of packets from nonDeprecatedCoverModelPackets. *)
	suppliedDownloadResult=Quiet[
		Download[
			{
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Instrument, Crimper]]]]
				],
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Part, Decrimper]]]]
				],
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Part, CrimpingHead]]]]
				],
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Part, DecrimpingHead]]]]
				],
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Part, CapPrier]]]]
				],
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Instrument, PlateSealer]]]]
				],
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Item, Cap]]]]
				],
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Item, Lid]]]]
				],
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Item, PlateSeal]]]]
				],
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Item, Septum]]]]
				],
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Item, Clamp]]]]
				],
				DeleteDuplicates[
					Flatten[Cases[modelsNotInSearch, ObjectP[Model[Part, AmpouleOpener]]]]
				]
			},
			{
				Packet[MinPressure, MaxPressure],
				Packet[CoverFootprint, CapDiameter, Name],
				Packet[CoverFootprint, CrimpType, Name],
				Packet[CoverFootprint, Name],
				Packet[CoverFootprint, Name],
				Packet[CoverFootprint, TemperatureActivated, MinTemperature, MaxTemperature, MinDuration, MaxDuration, Name],
				Packet[CoverType, CoverFootprint, CrimpType, SeptumRequired, TaperGroundJointSize, Opaque, Reusable, EngineDefault, Barcode, CrimpingPressure, Name],
				Packet[CoverType, CoverFootprint, InternalDimensions2D, Opaque, Dimensions, NotchPositions, Reusable, EngineDefault, Name],
				Packet[CoverType, CoverFootprint, SealType, Opaque, Pierceable, Dimensions, Reusable, EngineDefault, Name],
				Packet[CoverFootprint, Pierceable, EngineDefault, Barcode, Name],
				Packet[TaperGroundJointSize],
				Packet[MinVolume, MaxVolume, Name]
			}
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];
	suppliedDownloadResult=Flatten/@suppliedDownloadResult;

	MapThread[
		Flatten[{#1, #2}]&,
		{suppliedDownloadResult, nonDeprecatedCoverModelPackets["Memoization"]}
	]
];

(* NOTE: These are the non-deprecated model packets that we ALWAYS download so we memoize it. *)
nonDeprecatedCoverModelPackets[fakeString_]:=nonDeprecatedCoverModelPackets[fakeString]=Module[
	{crimperInstrumentModels, crimpingHeadPartModels, decrimpingHeadPartModels, plateSealerInstrumentModels, capModels, lidModels,
		plateSealModels, septumModels, capPrierInstrumentModels, keckClampModels, decrimperPartModels, ampouleOpenerModels},

	(* Add nonDeprecatedCoverModelPackets to list of Memoized functions. *)
	If[!MemberQ[$Memoization, Experiment`Private`nonDeprecatedCoverModelPackets],
		AppendTo[$Memoization, Experiment`Private`nonDeprecatedCoverModelPackets]
	];

	(* Search for all transfer models in the lab to download from. *)
	{
		crimperInstrumentModels,
		decrimperPartModels,
		crimpingHeadPartModels,
		decrimpingHeadPartModels,
		capPrierInstrumentModels,
		plateSealerInstrumentModels,
		capModels,
		lidModels,
		plateSealModels,
		septumModels,
		keckClampModels,
		ampouleOpenerModels
	}=coverModelsSearch["Memoization"];

	(* Download the fields that we need. *)
	(* need to Flatten /@ because the listedness has an extra layer at this point that we don't need (because every different set of models is only getting one packet *)
	(* but if we don't have that list, we'll download ALL those packets for every different list of models (which is how it used to be and is not how we should do it) *)
	Flatten /@ Quiet[
		Download[
			{
				crimperInstrumentModels,
				decrimperPartModels,
				crimpingHeadPartModels,
				decrimpingHeadPartModels,
				capPrierInstrumentModels,
				plateSealerInstrumentModels,
				capModels,
				lidModels,
				plateSealModels,
				septumModels,
				keckClampModels,
				ampouleOpenerModels
			},
			{
				{Packet[CoverFootprint, CrimpType, Name]},
				{Packet[CoverFootprint, CapDiameter, Name]},
				{Packet[CoverFootprint, CrimpType, Name]},
				{Packet[CoverFootprint, Name]},
				{Packet[CoverFootprint, Name]},
				{Packet[CoverFootprint, MinTemperature, MaxTemperature, MinDuration, MaxDuration, Model, Name]},
				{Packet[CoverType, CoverFootprint, CrimpType, SeptumRequired, TaperGroundJointSize, Opaque, Reusable, EngineDefault, Barcode, CrimpingPressure, Name]},
				{Packet[CoverType, CoverFootprint, Opaque, Dimensions, InternalDimensions2D, NotchPositions, Reusable, EngineDefault, Name]},
				{Packet[CoverType, CoverFootprint, SealType, Opaque, Dimensions, Reusable, EngineDefault, Name, NotchPositions]},
				{Packet[CoverFootprint, Pierceable, EngineDefault, Barcode, Name]},
				{Packet[TaperGroundJointSize]},
				{Packet[MinVolume, MaxVolume, Name]}
			}
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	]
];

(* ::Subsection:: *)
(* resolveExperimentCoverOptions *)

DefineOptions[
	resolveExperimentCoverOptions,
	Options:>{
		HelperOutputOption,
		CacheOption,
		SimulationOption
	}
];

Error::NoSeptumGiven="A Septum must/can only be given if the Cover that is selected has SeptumRequired->True indicated in the Model[Item, Cap]. At indicies, `1`, the Septum option is set to, `2`, for Covers, `3`. Please let these options resolve automatically or fix these conflicts.";
Error::SterileTechniqueEnvironmentConflict="If SterileTechnique->True, the Environment option must be set to a BiosafetyCabinet. At indices, `1`, the SterileTechnique option is set to `2` but the Environment option is set to `3`. Please let these options resolve automatically.";
Error::CoverOptionsConflict="The Cover option must match the specified options CoverType and Opaque. At indices, `1`, the Cover option is set to `2` (which has CoverType->`3` and Opaque->`4`) but the CoverType option is set to `5` and the Opaque option is set to `6`. Please fix these options.";
Error::KeepCoveredConflict="The KeepCovered option can only be set to True if the cover that we're using is not a Crimp or a Seal. In order to samples to be aspirated from containers with Crimped or Sealed covers, these covers must be fully removed -- therefore the KeepCovered option does not apply. At indices, `1`, the KeepCovered option is set to `2` but the CoverType option is set to `3`.";
Error::PlateSealerInstrumentConflict="When a heat-activated plate seal is specified as a Cover, a plate sealer instrument must be set in the Instrument option. When a plate sealer instrument is specified as a Instrument, the plate seal (Cover) must be compatible with the plate sealer. At indices, `1`, the Cover option is set to `2` but the Instrument option is set to `3`. Please resolve these conflicts.";
Error::PlateSealAdapterConflict="When a Biorad PlateSealer instrument is set, specific PlateSealAdapter must be set based on container type. At indicies, `1`, the PlateSealAdapter option is set to `2` while the container is set to `3`. They do not work with together. Please resolve these conflicts.";
Error::PlateSealPaddleConflict="When a PlateSealPaddle is set, specific PlateSeal must be set. At indicies, `1`, the PlateSealPaddle option is set to `2` while the cover is set to `3`. They do not work with together. Please resolve these conflicts.";
Error::PlateSealerHeightConflict="When a plate sealer is specified as instrument for SBS plate, the container must be a plate with specific dimensions. At indicies, `1`,the container option is set to be `2`, but the height is beyond the range of height accepted by  `3`. Please resolve these conflicts.";
Error::CrimperConflict="The container(s) at indices, `1`, require crimpers, however the Instrument option is set to `2` and the CrimpingHead/DecrimpingHead options are set to `3` and `4`. When using a crimped cap as a cover, (1) a crimper instrument must be specified in the Instrument option, (2) a crimping head that matches the cover's CoverFootprint and CrimpType must be specified, and (3) a decrimping head that matches the cover's CoverFootprint must be specified.";
Error::UsePreviousCoverConflict="When UsePreviousCover->True, the Cover option should be set to the previous cover that was used for the container. At indices, `1`, the UsePreviousCover option is set to True, but the Cover option is set to `2`. This either 1) does not match the PreviousCover field in the given Object[Container], 2) there is no PreviousCover, or 3) the PreviousCover is already Discarded and cannot be used. Please let the UsePreviousCover option resolve automatically.";
Error::ContainerIsAlreadyCovered="The container(s), `1`, already have covers on them. In order to put on a new cover, the container must first be uncovered. All unit operations will automatically Cover and Uncover containers, if necessary. Please only call the Cover and Uncover if you'd like to override the default behavior of the unit operations.";
Error::BuiltInCover="The container(s) at indices, `1`, have built in covers (BuiltInCover->True in Model[Container]) and therefore cannot have the Cover options specified. Please let the Cover option automatically get set to Null so that the built in cover can be used to cover the container.";
Error::StopperConflict="The container(s) at indices, `1`, have the Stopper option set as `2` but the Cover option set as `3`. In order for a Stopper to be used, the Cover must be a Crimped Cap. This is because Stoppers must go under a crimped cap to be secured to the top of the container.";
Error::KeckClampConflict="The container(s) at indices, `1`, have the KeckClamp option set to `2` but the Cover option set as `3`. If a Cover is a tapered stopper with a TaperGroundJointSize, a KeckClamp with the same TaperGroundJointSize must be specified to secure the Cover to the specified container. Covers and KeckClamps with different TaperGroundJointSizes cannot be used together.";
Error::CoverContainerConflict="The container(s) at indices, `1`, have covers, `2`, that are not compatible with the container. The container(s) have CoverFootprints->`3`, but the Covers have CoverFootprint->`4`. The container(s) have CoverTypes->`5`, but the Covers have CoverType->`6`. If the Cover option was not specified, this indicates that there are no compatible Covers for the given container model.";
Error::ContainerLidIncompatible="The container(s) `1` cannot be covered with Model[Item, Lid, \"Universal Black Lid\"] robotically because the top dimensions of the containers are larger than the internal dimensions of the lid (with 0.5 mm extra space). Please consider changing the CoverType to Seal using a work cell with plate sealer or perform the Cover request manually.";
Error::CapPrierConflict="The container(s) at indices, `1`, have priers, `2`, that are not compatible with the caps `3`. If the Instrument option was not specified, a cap prier that matches the CoverFootprint of the cover is not available.";
Error::AluminumFoilRollConflict="The specified AluminumFoilRoll `1` conflicts with the resolved CoverType (`2`) and/or the resolved AluminumFoil (`3`) options.  AluminumFoilRoll can only be specified if AluminumFoil is set to True, or if CoverType is set to AluminumFoil.  Additionally, if these options are specified, AluminumFoilRoll may not be Null (unless the relevant AluminumFoil cover is specified as an Object[Item, Lid], in which case Null is fine).  Please allow AluminumFoilRoll to be set automatically.";
Warning::LiveCellsCoverConflict = "The container(s) at indices, `1`, contain live cell samples, but the covers, `2`, are not breathable and sterile. Live cell samples are prone to contamination and often require gas exchange to remain viable. Unless you are covering solid cell cultures, please use breathable and sterile covers such as Model[Item, PlateSeal, \"AeraSeal Plate Seal, Breathable Sterile\"] for optimal sample integrity.";
Error::SterileTechniqueConflict = "The container(s) at indices, `1`, and covers, `2`, contain live cell samples and must be used with sterile technique to prevent contamination of the samples or surroundings. Please set the SterileTechnique options, `3`, to True, or let them resolve automatically.";

(* These are universal constants. *)
(* The height constraint for plate was measured in lab. *)
(* The robotic constants are for Hamilton Plate Sealer. *)
(* The manual constants are for BioRad Plate Sealer. *)
$MinRoboticPlateSealHeight=13.6 Millimeter;
$MaxRoboticPlateSealHeight=16.1 Millimeter;
$MinManualHeatPlateSealHeight=9.4 Millimeter;
$MaxManualHeatPlateSealHeight=16.3 Millimeter;

resolveExperimentCoverOptions[
	myInputs:{ObjectP[{Object[Container], Object[Sample]}]..},
	myContainers:{ObjectP[Object[Container]]..},
	myOptions:{_Rule..},
	myResolutionOptions:OptionsPattern[resolveExperimentCoverOptions]
]:=Module[
	{
		outputSpecification,output,gatherTests,messagesQ,warningsQ,cache,currentSimulation,samplePrepOptions,coverOptions,
		objectContainerFields,objectContainerPacketFields,modelContainerFields,objectSampleFields,modelSampleFields,
		objectContainerPackets,modelContainerPackets,objectSamplePacketList,modelSamplePacketList,crimperInstrumentModelPackets,
		crimpingHeadPartModelPackets,decrimpingHeadPartModelPackets,plateSealerInstrumentModelPackets,capModelPackets,
		lidModelPackets,septumModelPackets,keckClampModelPackets,specifiedCrimperInstrumentObjectPackets,specifiedCrimpingHeadPartObjectPackets,
		specifiedDecrimpingHeadPartObjectPackets,specifiedPlateSealerInstrumentObjectPackets,specifiedCapObjectPackets,specifiedPlateSealRollerObjectPackets, specifiedKeckClampObjectPackets,
		specifiedLidObjectPackets,specifiedSeptumObjectPackets,defaultCrimperInstrumentModelPackets,defaultCrimpingHeadPartModelPackets,
		defaultPlateSealerInstrumentModelPackets,defaultCapModelPackets,defaultLidModelPackets,defaultSeptumModelPackets,defaultKeckClampModelPackets,
		previousCoverObjectPackets,cacheBall,fastCacheBall,preparationResult,allowedPreparation,preparationTest,resolvedPreparation,
		containerToCoverListRules,lidInternalDimensions2D,mapThreadFriendlyOptions,resolvedSampleLabels,resolvedSampleContainerLabels,resolvedCoverTypes,resolvedUsePreviousCovers,
		resolvedOpaques,resolvedCovers,resolvedCoverLabels,resolvedSeptums,resolvedInstruments,resolvedTemperatures,resolvedTimes,
		resolvedParafilms,resolvedAluminumFoils, resolvedKeckClamps, resolvedKeepCovereds, resolvedEnvironments,resolvedSterileTechniques,resolvedCoverModelPackets,
		resolvedPlateSealAdapters,resolvedPlateSealPaddles,containerLidCompatibleErrors,resolvedPostProcessingOptions,resolvedOptions,mapThreadFriendlyResolvedOptions,
		conflictingSeptumErrors,conflictingSeptumTest,containsLiveCellsQs,plateSealSafeUseQs,liveCellsCoverWarnings,liveCellsCoverTest,sterileTechniqueConflictErrors,sterileTechniqueConflictTest,sterileTechniqueErrors,sterileTechniqueTest,coverErrors,coverTest,keepCoveredErrors,
		keepCoveredTest,plateSealerErrors,plateHeightErrors,plateSealAdapterErrors,plateSealPaddleErrors,specifiedAluminumFoilRoll,
		resolvedAluminumFoilRoll, needAluminumFoilQ, aluminumFoilRollError, aluminumFoilRollTest, defaultDecrimperPartModelPackets,
		plateSealerTest,crimperTest,crimperErrors,usePreviousCoverErrors,usePreviousCoverTest,objectContainerRepeatedContainerList,
		alreadyCoveredTest,alreadyCoveredErrors,invalidInputs,invalidOptions,defaultPlateSealModelPackets,specifiedPlateSealObjectPackets,
		plateSealModelPackets,defaultCapPrierInstrumentModelPackets,builtInCoverErrors,builtInCoverTest,conflictingStopperErrors,
		conflictingStopperTest,conflictingKeckClampErrors, conflictingKeckClampTest,coverContainerTest,containerLidCompatibleTests,containerLidCompatibleInvalidOptions,coverContainerErrors,resolvedCrimpingHeads,resolvedDecrimpingHeads,resolvedCrimpingPressures,
		activeCartPackets,activeCart,defaultDecrimpingHeadPartModelPackets, defaultAmpuoleOpenerPackets, roboticPrimitiveQ,allowedWorkCells,resolvedWorkCell
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	(* warnings assume we're not in engine; if we are they are not surfaced *)
	gatherTests = MemberQ[output,Tests];
	messagesQ = !gatherTests;
	warningsQ = !gatherTests && !MatchQ[$ECLApplication, Engine];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Lookup our simulation. *)
	currentSimulation=Lookup[ToList[myResolutionOptions],Simulation];

	(* Separate out our <Type> options from our Sample Prep options. *)
	{samplePrepOptions, coverOptions}=splitPrepOptions[myOptions];

	(* ExperimentCover does not have sample prep options so we are skipping those. *)

	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectContainerFields=DeleteDuplicates[Flatten[{PreviousCover,Cover,Septum,Parafilm,AluminumFoil,KeepCovered,Hermetic,StoreInverted,SamplePreparationCacheFields[Object[Container]]}]];
	objectContainerPacketFields=Packet@@objectContainerFields;
	modelContainerFields=DeleteDuplicates[Flatten[{BuiltInCover,NumberOfWells,Dimensions,CoverTypes,CoverFootprints,Parafilm,AluminumFoil,ExternalDimensions3D,StoreInverted,SamplePreparationCacheFields[Model[Container]]}]];
	objectSampleFields=DeleteDuplicates[Flatten[{Parafilm,AluminumFoil,SamplePreparationCacheFields[Object[Sample]]}]];
	modelSampleFields=DeleteDuplicates[Flatten[{Parafilm,AluminumFoil,SamplePreparationCacheFields[Model[Sample]]}]];

	(* Get our default instrument, cover, and septum packets. *)
	{
		defaultCrimperInstrumentModelPackets,
		defaultDecrimperPartModelPackets,
		defaultCrimpingHeadPartModelPackets,
		defaultDecrimpingHeadPartModelPackets,
		defaultCapPrierInstrumentModelPackets,
		defaultPlateSealerInstrumentModelPackets,
		defaultCapModelPackets,
		defaultLidModelPackets,
		defaultPlateSealModelPackets,
		defaultSeptumModelPackets,
		defaultKeckClampModelPackets,
		defaultAmpuoleOpenerPackets (* NOTE: Used only in uncover. *)
	}=coverModelPackets[myOptions];

	(* - Big Download to make cacheBall and get the inputs in order by ID - *)
	{
		objectContainerPackets,
		modelContainerPackets,
		objectContainerRepeatedContainerList,
		objectSamplePacketList,
		modelSamplePacketList,
		specifiedCrimperInstrumentObjectPackets,
		specifiedCrimpingHeadPartObjectPackets,
		specifiedDecrimpingHeadPartObjectPackets,
		specifiedPlateSealerInstrumentObjectPackets,
		specifiedCapObjectPackets,
		specifiedLidObjectPackets,
		specifiedPlateSealObjectPackets,
		specifiedSeptumObjectPackets,
		specifiedPlateSealRollerObjectPackets,
		specifiedKeckClampObjectPackets,
		previousCoverObjectPackets,
		activeCartPackets
	}=Quiet[
		Download[
			{
				myContainers,
				myContainers,
				myContainers,
				myContainers,
				myContainers,
				Cases[ToList[myOptions], ObjectP[Object[Instrument, Crimper]], Infinity],
				Cases[ToList[myOptions], ObjectP[Object[Part, CrimpingHead]], Infinity],
				Cases[ToList[myOptions], ObjectP[Object[Part, DecrimpingHead]], Infinity],
				Cases[ToList[myOptions], ObjectP[Object[Instrument, PlateSealer]], Infinity],
				Cases[ToList[myOptions], ObjectP[Object[Item, Cap]], Infinity],
				Cases[ToList[myOptions], ObjectP[Object[Item, Lid]], Infinity],
				Cases[ToList[myOptions], ObjectP[Object[Item, PlateSeal]], Infinity],
				Cases[ToList[myOptions], ObjectP[Object[Item, Septum]], Infinity],
				Cases[ToList[myOptions], ObjectP[Object[Item, PlateSealRoller]], Infinity],
				Cases[ToList[myOptions], ObjectP[Object[Item, KeckClamp]], Infinity],
				myContainers,
				{Lookup[myOptions,ParentProtocol]}
			},
			{
				List@objectContainerPacketFields,
				List@Packet[Model[modelContainerFields]],
				{Container..},
				List@Packet[Contents[[All,2]][objectSampleFields]],
				List@Packet[Contents[[All,2]][Model][modelSampleFields]],
				{Packet[Model, Name], Packet[Model[{MinPressure, MaxPressure, Name}]]},
				{Packet[Model, Name], Packet[Model[{CoverFootprint, CrimpType, Name}]]},
				{Packet[Model, Name], Packet[Model[{CoverFootprint, Name}]]},
				{Packet[Model, Name], Packet[Model[{CoverFootprint, TemperatureActivated, MinTemperature, MaxTemperature, MinDuration, MaxDuration, Barcode, Name}]]},
				{Packet[Model, Name], Packet[Model[{CoverType, CoverFootprint, CrimpType, SeptumRequired, TaperGroundJointSize, Opaque, Reusable, EngineDefault, Container, Barcode, CrimpingPressure, Name}]]},
				{Packet[Model, Name], Packet[Model[{CoverType, CoverFootprint, Opaque, Dimensions, NotchPositions, Reusable, EngineDefault, Name}]]},
				{Packet[Model, Name], Packet[Model[{CoverType, CoverFootprint, SealType, Opaque, Pierceable, Dimensions, Reusable, EngineDefault, Name}]]},
				{Packet[Model, Name], Packet[Model[{CoverFootprint, Pierceable, EngineDefault, Barcode, Name}]]},
				{Packet[Model, Name], Packet[Model[{Name}]]},
				{Packet[Model, Name], Packet[Model[{TaperGroundJointSize, Name}]]},
				{
					Packet[PreviousCover[{Model, Status, CoveredContainer, Container, Name}]],
					Packet[PreviousCover[Model][{CoverType, CoverFootprint, Opaque, CrimpType, SeptumRequired, Reusable, EngineDefault, Barcode, Name, Connectors, NotchPositions}]]
				},
				{Packet[ActiveCart]}
			},
			Cache->cache,
			Simulation->currentSimulation
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	{
		crimperInstrumentModelPackets,
		crimpingHeadPartModelPackets,
		decrimpingHeadPartModelPackets,
		plateSealerInstrumentModelPackets,
		capModelPackets,
		lidModelPackets,
		plateSealModelPackets,
		septumModelPackets,
		keckClampModelPackets
	}={
		Flatten[{
			defaultCrimperInstrumentModelPackets,
			Cases[Flatten@specifiedCrimperInstrumentObjectPackets, PacketP[Model[Instrument]]]
		}],
		Flatten[{
			defaultCrimpingHeadPartModelPackets,
			Cases[Flatten@specifiedCrimpingHeadPartObjectPackets, PacketP[Model[Part]]]
		}],
		Flatten[{
			defaultDecrimpingHeadPartModelPackets,
			Cases[Flatten@specifiedDecrimpingHeadPartObjectPackets, PacketP[Model[Part]]]
		}],
		Flatten[{
			defaultPlateSealerInstrumentModelPackets,
			Cases[Flatten@specifiedPlateSealerInstrumentObjectPackets, PacketP[Model[Instrument]]]
		}],
		Flatten[{
			defaultCapModelPackets,
			Cases[Flatten@specifiedCapObjectPackets, PacketP[Model[Item, Cap]]],
			Cases[Flatten@previousCoverObjectPackets, PacketP[Model[Item, Cap]]]
		}],
		Flatten[{
			defaultLidModelPackets,
			Cases[Flatten@specifiedLidObjectPackets, PacketP[Model[Item, Lid]]],
			Cases[Flatten@previousCoverObjectPackets, PacketP[Model[Item, Lid]]]
		}],
		Flatten[{
			defaultPlateSealModelPackets,
			Cases[Flatten@specifiedPlateSealObjectPackets, PacketP[Model[Item, PlateSeal]]],
			Cases[Flatten@previousCoverObjectPackets, PacketP[Model[Item, PlateSeal]]]
		}],
		Flatten[{
			defaultSeptumModelPackets,
			Cases[Flatten@specifiedSeptumObjectPackets, PacketP[Model[Item, Septum]]],
			Cases[Flatten@previousCoverObjectPackets, PacketP[Model[Item, Septum]]]
		}],
		Flatten[{
			defaultKeckClampModelPackets,
			Cases[Flatten@specifiedKeckClampObjectPackets, PacketP[Model[Item, Clamp]]]
		}]
	};

	{
		objectContainerRepeatedContainerList,
		objectSamplePacketList,
		modelSamplePacketList
	}=Map[
		Flatten,
		{
			objectContainerRepeatedContainerList,
			objectSamplePacketList,
			modelSamplePacketList
		},
		{2}
	];

	{
		objectContainerPackets,
		modelContainerPackets,
		specifiedCrimperInstrumentObjectPackets,
		specifiedCrimpingHeadPartObjectPackets,
		specifiedDecrimpingHeadPartObjectPackets,
		specifiedPlateSealerInstrumentObjectPackets,
		specifiedCapObjectPackets,
		specifiedLidObjectPackets,
		specifiedSeptumObjectPackets,
		specifiedPlateSealRollerObjectPackets,
		previousCoverObjectPackets
	}=Flatten/@{
		objectContainerPackets,
		modelContainerPackets,
		specifiedCrimperInstrumentObjectPackets,
		specifiedCrimpingHeadPartObjectPackets,
		specifiedDecrimpingHeadPartObjectPackets,
		specifiedPlateSealerInstrumentObjectPackets,
		specifiedCapObjectPackets,
		specifiedLidObjectPackets,
		specifiedSeptumObjectPackets,
		specifiedPlateSealRollerObjectPackets,
		previousCoverObjectPackets
	};

	(* We've had to download with extra lists, clean this up. *)
	activeCart=If[MatchQ[activeCartPackets,{Null}],
		Null,
		Lookup[activeCartPackets[[1,1]],ActiveCart]
	];

	cacheBall=FlattenCachePackets[{
		objectContainerPackets,
		modelContainerPackets,
		objectContainerRepeatedContainerList,
		objectSamplePacketList,
		modelSamplePacketList,
		specifiedCrimperInstrumentObjectPackets,
		specifiedCrimpingHeadPartObjectPackets,
		specifiedDecrimpingHeadPartObjectPackets,
		specifiedPlateSealerInstrumentObjectPackets,
		specifiedCapObjectPackets,
		specifiedLidObjectPackets,
		specifiedPlateSealObjectPackets,
		specifiedSeptumObjectPackets,
		specifiedPlateSealRollerObjectPackets,
		previousCoverObjectPackets,
		defaultCrimperInstrumentModelPackets,
		defaultCrimpingHeadPartModelPackets,
		defaultDecrimpingHeadPartModelPackets,
		defaultCapPrierInstrumentModelPackets,
		defaultPlateSealerInstrumentModelPackets,
		defaultCapModelPackets,
		defaultLidModelPackets,
		defaultPlateSealModelPackets,
		defaultSeptumModelPackets,
		defaultKeckClampModelPackets
	}];

	(* Make the fast association. *)
	fastCacheBall = makeFastAssocFromCache[cacheBall];

	(* Resolve our preparation option. *)
	preparationResult=Check[
		{allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
			{
				resolveCoverMethod[myContainers, ReplaceRule[coverOptions, {Cache->cacheBall, Output->Result}]],
				{}
			},
			resolveCoverMethod[myContainers, ReplaceRule[coverOptions, {Cache->cacheBall, Output->{Result, Tests}}]]
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation=If[MatchQ[allowedPreparation, _List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* build a short hand for robotic primitive*)
	roboticPrimitiveQ=MatchQ[resolvedPreparation, Robotic];

	(*figure out a list of possible work cells *)
	allowedWorkCells=If[roboticPrimitiveQ,
		resolveExperimentCoverWorkCell[myContainers, ReplaceRule[coverOptions, {Cache->cacheBall, Output->Result}]]];

	resolvedWorkCell=Which[
		(*choose user selected workcell if the user selected one *)
		MatchQ[Lookup[myOptions, WorkCell,Automatic], Except[Automatic]],
			Lookup[myOptions, WorkCell],
		(*if we are doing the protocol by hand, then there is no robotic workcell *)
		MatchQ[resolvedPreparation, Manual],
			Null,
		(*choose the first workcell that is presented *)
		Length[allowedWorkCells]>0,
			First[allowedWorkCells],
		(*if none of the above, then the default is the most common workcell, the STAR *)
		True,
			STAR
	];
	(* Track cover labels for repeated containers *)
	(* If we have repeated container objects in objectContainerPackets, we should use the same cover (cover label) since this is one single Cover UO - i.e., no uncover in between. We cannot and should not cover the same container with multiple covers *)
	containerToCoverListRules = <||>;

	(* Prepare the Lid information *)
	lidInternalDimensions2D=Lookup[
		(* Default Lid *)
		fetchPacketFromCache[Model[Item, Lid, "id:N80DNj16AaKA"],cacheBall],
		InternalDimensions2D,
		Null
	]/.(Null->{200Millimeter,200Millimeter});

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentCover,Normal@coverOptions];
	(* Resolve our map thread options. *)
	{
		resolvedSampleLabels,
		resolvedSampleContainerLabels,
		resolvedCoverTypes,
		resolvedUsePreviousCovers,
		resolvedOpaques,
		resolvedCovers,
		resolvedCoverLabels,
		resolvedSeptums,
		resolvedInstruments,
		resolvedCrimpingHeads,
		resolvedDecrimpingHeads,
		resolvedCrimpingPressures,
		resolvedTemperatures,
		resolvedTimes,
		resolvedParafilms,
		resolvedAluminumFoils,
		resolvedKeckClamps,
		resolvedKeepCovereds,
		resolvedEnvironments,
		resolvedSterileTechniques,
		resolvedCoverModelPackets,
		resolvedPlateSealAdapters,
		resolvedPlateSealPaddles,
		containerLidCompatibleErrors,
		containsLiveCellsQs,
		plateSealSafeUseQs
	}=Transpose@MapThread[
		Function[{originalInputObject, containerPacket, containerModelPacket, objectSamplePackets, modelSamplePackets, containerRepeatedContainers, options},
			Module[
				{containerLidCompatibleQ,usePreviousCover, preResolvedCover, coverType, opaque, cover, coverModelPacket, coverLabel, septum,
					instrument, instrumentModel, temperature, time, plateSealPaddle, parafilm, aluminumFoil, keckClamp, keepCovered, environment, sterileTechnique, sampleLabel,
					sampleContainerLabel, crimpingHead, decrimpingHead, crimpingPressure, containerContainer, plateSealAdapter,
					previousCover, previousCoverModel, containerLidCompatibleError, containsLiveCellsQ, plateSealSafeUseQ},

				(* Pre-check the container's size to determine if it can fit our default black lid *)
				containerLidCompatibleQ=If[MatchQ[containerModelPacket,PacketP[Model[Container,Plate]]]&&MatchQ[Lookup[containerModelPacket,Footprint],Plate],
					(* For Plate, check for its dimensions *)
					MatchQ[
						(* Top dimensions is at the largest z *)
						LastOrDefault[SortBy[Lookup[containerModelPacket,ExternalDimensions3D],Last],Null],
						Alternatives[
							Null,
							(* 0.5mm smaller on both x and y *)
							{LessEqualP[lidInternalDimensions2D[[1]]-0.5Millimeter],LessEqualP[lidInternalDimensions2D[[2]]-0.5Millimeter],_}
						]
					],
					(* Always compatible for non-plate since we should never use the lid *)
					True
				];

				(* Indicates whether the container contains live cells for cell culture *)
				containsLiveCellsQ = And[
					(* Check for cells *)
					MemberQ[
						Experiment`Private`selectMainCellFromSample[
							Lookup[objectSamplePackets, Object],
							Simulation -> currentSimulation
						],
						ObjectP[Model[Cell]]
					],
					(* Check if cells are living *)
					MemberQ[Lookup[objectSamplePackets, Living], True],
					(* Exclude PCR plates, as all cells are lysed for PCR, but the Living field of samples may not have been updated after sample preparation *)
					!MatchQ[
						Lookup[containerModelPacket, Object],
						ObjectP[allPCRPlatesSearch["Memoization"]]
					]
				];

				(* For cell culture plates, can't use a plate seal if we are inverting (solid cultures) *)
				plateSealSafeUseQ = If[MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]],
					!And[
						MatchQ[Lookup[containerPacket, StoreInverted, Lookup[containerModelPacket, StoreInverted]], True],
						MemberQ[Lookup[objectSamplePackets, State], Solid]
					],
					False
				];

				(* determine the previous cover and previous cover model because we use it a lot below *)
				previousCover = Download[Lookup[containerPacket, PreviousCover], Object];
				previousCoverModel = If[MatchQ[previousCover, ObjectP[]],
					cacheLookup[previousCoverObjectPackets, previousCover, Model],
					Null
				];

				(* Resolve the UsePreviousCover option. *)
				usePreviousCover=Which[
					!MatchQ[Lookup[options, UsePreviousCover], Automatic],
						Lookup[options, UsePreviousCover],
					(* Is the Cover option already set? If so, is it set to a cover that is not the PreviousCover field? *)
					And[
						MatchQ[Lookup[options, Cover], ObjectP[]],
						!MatchQ[Lookup[options, Cover], ObjectP[previousCover]]
					],
						False,
					(* Set to Null if we have a built in cover. *)
					MatchQ[Lookup[containerModelPacket, BuiltInCover], True],
						Null,
					(* If we're doing Robotic, do not use the previous cover if it is anything besides the universal black lid *)
					And[
						MatchQ[resolvedPreparation, Robotic],
						MatchQ[previousCover, ObjectP[Object[Item]]],
						Not[MatchQ[previousCoverModel, ObjectP[Model[Item, Lid, "id:N80DNj16AaKA"]]]] (* "Universal Black Lid" *)
					],
						False,
					(* Is the PreviousCover field in the Object[Container] set, the PreviousCover is not discarded or on another container, *)
					(* and the previous cover isn't the temporary hamilton lid (that can't be used for long term storage)? *)
					And[
						MatchQ[Lookup[containerPacket, PreviousCover], ObjectP[Object[Item]]],
						MatchQ[
							Lookup[fetchPacketFromCache[previousCover, previousCoverObjectPackets], Status],
							Except[Discarded]
						],
						MatchQ[
							Lookup[fetchPacketFromCache[previousCover, previousCoverObjectPackets], CoveredContainer],
							Null
						],
						(* Never re-use aspiration caps, unless it's specified. We don't have a specific field informing whether the cap is aspiration caps or not, so we look at the following two criteria: *)
						(* Model Name should not container 'Aspiration' *)
						Or[
							!StringContainsQ[Lookup[fetchPacketFromCache[Download[previousCoverModel, Object], previousCoverObjectPackets], Name], "Aspiration", IgnoreCase -> True],
							NullQ[Lookup[fetchPacketFromCache[Download[previousCoverModel, Object], previousCoverObjectPackets], Name]]
						],
						(* Does not have any Connectors defined *)
						Length[Lookup[fetchPacketFromCache[Download[previousCoverModel, Object], previousCoverObjectPackets], Connectors]] == 0,
						Or[
							(* we allow black lid for a lunatic chip because this is the only cover we can use on it while we are working with it. *)
							And[
								MatchQ[
									Download[Lookup[containerPacket, Model], Object],
									Model[Container, Plate, "id:O81aEBZ4EMXj"] (* "Lunatic Chip Plate" *)
								],
								MatchQ[
									previousCoverModel,
									ObjectP[Model[Item, Lid, "id:N80DNj16AaKA"]] (* "Universal Black Lid" *)
								]
							],
							(* we also allow black lid if we are in a big Robotic run and would like to cover a plate multiple times. *)
							(* The status of the cover can be InUse or Available during simulation stage *)
							(* When the cover is first used, we do a simulated object and set it to InUse; When it is repeatedly used, during simulation, we update the resource to be Available again *)
							And[
								MatchQ[resolvedPreparation,Robotic],
								MatchQ[
									Lookup[fetchPacketFromCache[Lookup[containerPacket, PreviousCover], previousCoverObjectPackets], Status],
									(InUse|Available)
								],
								MatchQ[
									Lookup[fetchPacketFromCache[Lookup[containerPacket, PreviousCover], previousCoverObjectPackets], Model],
									ObjectP[Model[Item, Lid, "id:N80DNj16AaKA"]] (* "Universal Black Lid" *)
								]
							],
							!MatchQ[
								previousCoverModel,
								ObjectP[Model[Item, Lid, "id:N80DNj16AaKA"]] (* "Universal Black Lid" *)
							]
						]
					],
						True,
					True,
						False
				];

				(* Pre-resolve the cover option. This will be set if 1) the user gave us a cover, 2) we're using the previous cover *)
				(* or 3) the user gave us a cover label that points to an object. 4)the user required us to place lid robotically. *)
				preResolvedCover=Which[
					MatchQ[Lookup[options, Cover], ObjectP[]],
						Lookup[options, Cover],
					(* Cover will be Null if we have a built in cover. *)
					MatchQ[Lookup[containerModelPacket, BuiltInCover], True],
						Null,
					MatchQ[usePreviousCover, True] && MatchQ[previousCover, ObjectP[]],
						previousCover,
					And[
						MatchQ[Lookup[options, CoverLabel], _String],
						MatchQ[currentSimulation, SimulationP],
						MemberQ[Lookup[currentSimulation[[1]], Labels][[All,1]], Lookup[options, CoverLabel]]
					],
						Lookup[Lookup[currentSimulation[[1]], Labels], Lookup[options, CoverLabel]],
					And[
						MatchQ[resolvedPreparation, Robotic],
						Or[
							MatchQ[Lookup[options, CoverType], Place],
							MatchQ[Lookup[options, CoverType], Automatic] && TrueQ[containerLidCompatibleQ]  && MatchQ[Lookup[containerModelPacket, Dimensions], {_, _, RangeP[0,$MinRoboticPlateSealHeight]|GreaterP[$MaxRoboticPlateSealHeight]}]
						]
					],
						Model[Item, Lid, "id:N80DNj16AaKA"], (* "Universal Black Lid" *)
					(* We do not automatically resolve to the heat-seal seal, even for SealGCR96 (digital PCR cartridge) since it is very difficult to remove the heat-activated seal. We should only do this when specifically asked to do so. *)
					(*
					And[
						!MatchQ[resolvedPreparation, Robotic],
						MemberQ[Lookup[containerModelPacket, CoverFootprints], SealGCR96](* Bio-rad GCR96 Digital PCR Cartridge is one example*)
					],
						Model[Item, PlateSeal, "id:wqW9BP7mw0jJ"], (* "GCR96 PCR Plate Seal, Pierceable Heat-Sealed Aluminum" *)
					*)
					True,
						Automatic
				];
				(* Get the Model of instrument if this option is set by user. *)
				instrumentModel=If[MatchQ[Lookup[options, Instrument],ObjectP[Object[Instrument]]],
					Lookup[fetchPacketFromCache[Lookup[options, Instrument], cacheBall],Model],
					Lookup[options, Instrument]
				];
				(* Resolve the CoverType option. *)
				coverType=Which[
					!MatchQ[Lookup[options, CoverType], Automatic],
						Lookup[options, CoverType],
					(* Did the user give us a cover to use? *)
					MatchQ[preResolvedCover, ObjectP[]],
						Module[{coverTypeFromModel},
							(* Try to get the CoverType from the CoverType field. *)
							coverTypeFromModel=If[MatchQ[preResolvedCover, ObjectP[Object[]]],
								Lookup[
									fetchPacketFromCache[
										Lookup[fetchPacketFromCache[preResolvedCover, cacheBall], Model],
										cacheBall
									],
									CoverType,
									Null
								],
								Lookup[fetchPacketFromCache[preResolvedCover, cacheBall], CoverType, Null]
							];

							(* If we found the CoverType field, use that. Otherwise, if it was Null, just set it based on the container type. *)
							Which[
								MatchQ[coverTypeFromModel, CoverTypeP],
									coverTypeFromModel,
								MatchQ[Lookup[containerPacket, Object], Object[Container, Plate]],
									Place,
								True,
									Screw
							]
						],
					(* We can only use Septa with Crimp caps. *)
					MatchQ[Lookup[options, Septum], ObjectP[]],
						Crimp,
					(* Did the user give us an instrument? *)
					MatchQ[Lookup[options, Instrument], ObjectP[]],
						Switch[Lookup[options, Instrument],
							ObjectP[{Model[Instrument, Crimper], Object[Instrument, Crimper]}],
								Crimp,
							ObjectP[{Model[Instrument, PlateSealer], Object[Instrument, PlateSealer]}],
								Seal,
							True,
								Null
						],
					(* Did the user give us Time, Temperature, and PlateSealAdapter? These can only be used with the Plate Sealer. *)
					MatchQ[Lookup[options, Time], Except[Automatic|Null]] || MatchQ[Lookup[options, Temperature], Except[Automatic|Null]] || MatchQ[Lookup[options, PlateSealAdapter], ObjectP[]],
						Seal,
					(* If we have a lid spacer required, place the cover on top. *)
					MatchQ[Lookup[containerModelPacket, LidSpacerRequired], True],
						Place,
					(* Resolve to Seal to use the breathable & sterile seal for live cell samples *)
					And[
						containsLiveCellsQ,
						plateSealSafeUseQ,
						MemberQ[Lookup[containerModelPacket, CoverTypes], Seal]
					],
						Seal,
					(* Otherwise, try to get the compatible cover types from the container model. *)
					True,
						Module[{compatibleCoverTypes},
							compatibleCoverTypes=Lookup[containerModelPacket, CoverTypes];

							Which[
								MatchQ[Lookup[containerModelPacket, BuiltInCover], True],
									Null,
								(* NOTE: If we're in Robotic, we can only Place or Seal covers. *)
								(* If we can either Place or Seal the container plate, we prioritize CoverType Place, unless the lid is too tight for the plate. *)
								(* If there are multiple CoverTypes we can use, use the first one in the list. *)
								MatchQ[compatibleCoverTypes, _List] && MatchQ[resolvedPreparation, Robotic] && MemberQ[compatibleCoverTypes, Place] && TrueQ[containerLidCompatibleQ],
									Place,
								MatchQ[compatibleCoverTypes, _List] && MatchQ[resolvedPreparation, Robotic] && MemberQ[compatibleCoverTypes, Seal] && MatchQ[Lookup[containerModelPacket, Dimensions], {_, _, RangeP[$MinRoboticPlateSealHeight,$MaxRoboticPlateSealHeight]}],
									Seal,
								(* If we can only do Place, still resolve to Place even if the lid is too tight. We will have error message later *)
								MatchQ[compatibleCoverTypes, _List] && MatchQ[resolvedPreparation, Robotic] && MemberQ[compatibleCoverTypes, Place],
									Place,
								(* if we can do aluminum foil, do that before just arbitrarily taking the first one *)
								MatchQ[compatibleCoverTypes, _List] && MemberQ[compatibleCoverTypes, AluminumFoil],
									AluminumFoil,
								MatchQ[compatibleCoverTypes, _List] && MatchQ[Length[compatibleCoverTypes], GreaterP[0]],
									First[compatibleCoverTypes],
								True,
									Screw
							]
						]
				];

				(* Resolve the Cover option. *)
				cover=Which[
					(* This will be set if 1) the user gave us a cover, 2) we're using the previous cover *)
					(* or 3) the user gave us a cover label that points to an object. *)
					MatchQ[preResolvedCover, ObjectP[]],
						preResolvedCover,
					(* Cover will be Null if we have a built in cover. *)
					MatchQ[Lookup[containerModelPacket, BuiltInCover], True],
						Null,
					(* Cover will be crystal clear sealing film if the paddle is set in options. *)
					MatchQ[Lookup[options, PlateSealPaddle],ObjectP[]],
						Model[Item, PlateSeal, "id:8qZ1VWZNLJPp"],(* "Crystal Clear Sealing Film" *)
					(* Use the breathable & sterile seal for plates with live cells *)
					And[
						MatchQ[coverType, Seal],
						containsLiveCellsQ,
						!MatchQ[resolvedWorkCell, STAR | bioSTAR | microbioSTAR] (* Hamilton has its own set of compatible seals; can't use the breathable & sterile AeraSeal *)
					],
						Model[Item, PlateSeal, "id:BYDOjvG74Abm"], (* "AeraSeal Plate Seal, Breathable Sterile" *)
					(* Do we have a 96 well DWP? If so, default the cover to the press seal. All PressFit CoverType plate seals are not opaque. *)
					(* Deep-well plate dimension is 4.44 cm so make sure we don't include other types of plates. *)
					And[
						MatchQ[coverType, Seal],
						And[
							!MatchQ[Lookup[options, Instrument], ObjectP[]],
							!MatchQ[Lookup[options, Time], TimeP],
							!MatchQ[Lookup[options, Temperature], TemperatureP],
							!MatchQ[Lookup[options, PlateSealAdapter], ObjectP[]],
							!MatchQ[resolvedPreparation,Robotic]
						],
						MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]],
						MatchQ[Lookup[containerModelPacket, Dimensions], {_, _, GreaterP[4.0 Centimeter]}],
						MatchQ[Lookup[containerModelPacket, NumberOfWells], 96],
						MemberQ[Lookup[containerModelPacket, CoverFootprints], SealSBS96SquareWell]
					],
						If[MatchQ[Lookup[options, Opaque], True],
							Model[Item, PlateSeal, "id:dORYzZJMop8e"],(* "Plate Seal, Aluminum" we have a lot of them stocked *)
							Model[Item, PlateSeal, "id:pZx9jo8MJAXM"] (* "Plate Seal, 96-Well Square" with CoverType PressFit *)
						],
					(* Do we have 96 well plate following SBS with a height around 14 mm?  *)
					(* We can cover robotically or manually using Hamilton PlateSealer *)
					And[
						Or[
							MatchQ[resolvedPreparation, Robotic],
							MatchQ[Lookup[options,Instrument],ObjectP[Object[Instrument,PlateSealer]]]&&MatchQ[fetchModelPacketFromCache[Lookup[options,Instrument],fastCacheBall],ObjectP[Model[Instrument, PlateSealer, "id:eGakldJ91zEE"]]],(*"Hamilton Plate Sealer"*)
							MatchQ[Lookup[options,Instrument],ObjectP[Model[Instrument, PlateSealer, "id:eGakldJ91zEE"]]]
						],
						MatchQ[coverType, Seal],
						MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]],
						MatchQ[Lookup[containerModelPacket, Dimensions], {_, _, RangeP[$MinRoboticPlateSealHeight,$MaxRoboticPlateSealHeight]}],
						MatchQ[Lookup[containerModelPacket, NumberOfWells], 96],
						MemberQ[Lookup[containerModelPacket, CoverFootprints], SealSBS]
					],
						If[MatchQ[Lookup[options, Opaque], False],
							Model[Item, PlateSeal, "id:R8e1PjpEDbea"],(* "Optically Clear Plate Seals for Hamilton" *)
							Model[Item, PlateSeal, "id:O81aEBZzkJ1D"](* "Aluminum Plate Seals for Hamilton" *)
						],
					(* Do we have a 96 well non-DWP plate to cover manually without instrument? If so, default the cover to the zone free seal. *)
					And[
						MatchQ[coverType, Seal],
						And[
							!MatchQ[Lookup[options, Instrument], ObjectP[]],
							!MatchQ[Lookup[options, Time], TimeP],
							!MatchQ[Lookup[options, Temperature], TemperatureP],
							!MatchQ[Lookup[options, PlateSealAdapter], ObjectP[]]
						],
						MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]],
						MatchQ[Lookup[containerModelPacket, Dimensions], {_, _, LessEqualP[4.0 Centimeter]}],
						MatchQ[Lookup[containerModelPacket, NumberOfWells], 96],
						MemberQ[Lookup[containerModelPacket, CoverFootprints], SealSBS]
					],
						If[MatchQ[Lookup[options, Opaque], True],
							Model[Item, PlateSeal, "id:dORYzZJMop8e"],(* "Plate Seal, Aluminum" we have a lot of them stocked *)
							Model[Item, PlateSeal, "id:1ZA60vLqbXO6"](* "96-Well Plate Seal, EZ-Pierce Zone-Free " *)
						],
					And[
						MatchQ[coverType, Seal],
						And[
							!MatchQ[Lookup[options, Instrument], ObjectP[]],
							!MatchQ[Lookup[options, Time], TimeP],
							!MatchQ[Lookup[options, Temperature], TemperatureP],
							!MatchQ[Lookup[options, PlateSealAdapter], ObjectP[]]
						],
						MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]],
						MatchQ[Lookup[containerModelPacket, NumberOfWells], 384],
						MemberQ[Lookup[containerModelPacket, CoverFootprints], SealSBS]
					],
						If[MatchQ[Lookup[options, Opaque], True],
							Model[Item, PlateSeal, "id:dORYzZJMop8e"],(* "Plate Seal, Aluminum" we have a lot of them stocked *)
							Model[Item, PlateSeal, "id:L8kPEjnvlDrN"](* qPCR Plate Seal, Clear *)
						],
					MatchQ[coverType, AluminumFoil],
						Model[Item, Lid, "id:7X104v1N35pw"], (* "Aluminum Foil Cover" *)
					(* Find a compatible cover based on CoverType/Opaque and the container's CoverFootprints. *)
					True,
						Module[{compatibleCoverFootprints,allCovers,engineDefaultCovers,nonHeatCovers,heatCovers},
							(* Get the container's compatible cover footprints. *)
							compatibleCoverFootprints=Lookup[containerModelPacket, CoverFootprints];

							(* First, get all of our compatible covers. *)
							allCovers=Cases[
								Flatten[{capModelPackets, lidModelPackets,plateSealModelPackets}],
								KeyValuePattern[{
									CoverType->coverType,
									CoverFootprint->Alternatives@@compatibleCoverFootprints,
									Opaque->If[MatchQ[Lookup[options, Opaque], BooleanP], Lookup[options, Opaque], _]
								}]
							];

							(* In case we have to use a heat-activated cover, if possible we prefer to use EngineDefault cover. *)
							heatCovers=Module[{temporaryHeatCovers},
								temporaryHeatCovers=Cases[engineDefaultCovers, KeyValuePattern[{SealType->TemperatureActivatedAdhesive}]];

								If[Length[temporaryHeatCovers]==0,
									Cases[allCovers, KeyValuePattern[{SealType->TemperatureActivatedAdhesive}]],
									temporaryHeatCovers
								]
								];

							(* We first prefer to use EngineDefault covers. *)
							engineDefaultCovers=Module[{temporaryEngineDefaultCovers},
								temporaryEngineDefaultCovers=Cases[allCovers, KeyValuePattern[{EngineDefault->True}]];

								If[Length[temporaryEngineDefaultCovers]==0,
									allCovers,
									temporaryEngineDefaultCovers
								]
							];

							(* We prefer to use a non-heat cover if possible so we can skip using plate sealer unnecessarily. *)
							(* Get covers that fulfill our requirements and not temperature activated. *)
							nonHeatCovers=Module[{temporaryNonHeatCovers},
								temporaryNonHeatCovers=Cases[engineDefaultCovers, PacketP[{Model[Item, Lid], Model[Item, Cap]}]|KeyValuePattern[{SealType->Except[TemperatureActivatedAdhesive]}]];

								If[Length[temporaryNonHeatCovers]==0,
									engineDefaultCovers,
									temporaryNonHeatCovers
								]
							];
							(* If the user specified to use a Bio Rad Plate Sealer. *)
							If[
								Or[
									MatchQ[instrumentModel, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]],(* Bio Rad Plate Sealer *)
									MatchQ[Lookup[options, Time], TimeP],
									MatchQ[Lookup[options, Temperature], TemperatureP],
									MatchQ[Lookup[options, PlateSealAdapter], ObjectP[]]
								],
								Lookup[
									FirstOrDefault[
										heatCovers,
										<|Object->Null|>
									],
									Object
								],
								Lookup[
									FirstOrDefault[
										nonHeatCovers,
										<|Object->Null|>
									],
								Object
								]
							]
						]
				];

				(* Get the cover model packet for easy use later. *)
				coverModelPacket=Which[
					MatchQ[cover, Null],
						<||>,
					MatchQ[cover,ObjectP[Model[]]],
						fetchPacketFromCache[cover, cacheBall],
					True,
						fetchModelPacketFromCache[cover, cacheBall]
				];

				(* Resolve the Opaque option. *)
				opaque=If[MatchQ[Lookup[options, Opaque], Except[Automatic]],
					Lookup[options, Opaque],
					Lookup[coverModelPacket, Opaque, $Failed]/.{$Failed|Null->False}
				];

				(* Resolve the Septum option. *)
				septum=Which[
					MatchQ[Lookup[options, Septum], Except[Automatic]],
						Lookup[options, Septum],
					MatchQ[coverType, Crimp] && MatchQ[Lookup[coverModelPacket, SeptumRequired], True],
						Module[{allSepta, engineDefaultSepta},
							allSepta=Cases[
								septumModelPackets,
								KeyValuePattern[{CoverFootprint->Lookup[coverModelPacket, CoverFootprint]}]
							];

							engineDefaultSepta=Cases[
								allSepta,
								KeyValuePattern[{EngineDefault->True}]
							];

							If[Length[engineDefaultSepta]==0,
								Lookup[FirstOrDefault[allSepta, <||>], Object, Null],
								Lookup[FirstOrDefault[engineDefaultSepta, <||>], Object, Null]
							]
						],
					True,
						Null
				];

				(* Resolve the instrument option. *)
				instrument=Which[
					MatchQ[Lookup[options, Instrument], Except[Automatic]],
						Lookup[options, Instrument],

					MatchQ[resolvedPreparation, Robotic] && MatchQ[coverType, Place],
						Null,

					(* If we're using a crimp cap, we need to get a crimping instrument. *)
					MatchQ[coverType, Crimp],
						Lookup[
							FirstOrDefault[crimperInstrumentModelPackets, <|Object->Null|>],
							Object
						],

					(* If we're using a temperature-activated adhesive plate seal, we must use a plate sealing instrument. *)
					MatchQ[coverType, Seal] && MatchQ[coverModelPacket, PacketP[Model[Item, PlateSeal]]] && MatchQ[Lookup[coverModelPacket, SealType], TemperatureActivatedAdhesive],
						Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"],(* Bio Rad Plate Sealer *)
					(* If we are given time, temperature or BioRad PlateSealAdapter for temperature-activated adhesive plate sealer, we must use a plate sealing instrument. *)
					Or[
						MatchQ[Lookup[options, Time], TimeP],
						MatchQ[Lookup[options, Temperature], TemperatureP],
						MatchQ[Lookup[options, PlateSealAdapter], ObjectP[]]
						],
						Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"],(* Bio Rad Plate Sealer *)
					(* If we want to seal robotically, we must use a Hamilton plate sealing instrument. *)
					MatchQ[coverType, Seal] && MatchQ[resolvedPreparation, Robotic],
						Model[Instrument, PlateSealer, "id:eGakldJ91zEE"],(* Hamilton Plate Sealer *)

					(* Otherwise, we don't need an instrument. *)
					True,
						Null
				];

				(* Resolve the crimping head option. *)
				crimpingHead=Which[
					MatchQ[Lookup[options, CrimpingHead], Except[Automatic]],
						Lookup[options, CrimpingHead],

					MatchQ[resolvedPreparation, Robotic],
						Null,

					(* If we're using a crimp cap, we need to get a crimping head. *)
					MatchQ[coverType, Crimp],
						Lookup[
							FirstCase[
								crimpingHeadPartModelPackets,
								KeyValuePattern[{CoverFootprint->Lookup[coverModelPacket, CoverFootprint], CrimpType->Lookup[coverModelPacket, CrimpType]}],
								<|Object->Null|>
							],
							Object
						],

					(* Otherwise, we don't need a crimping head. *)
					True,
						Null
				];

				(* Resolve the decrimping head option. *)
				decrimpingHead=Which[
					MatchQ[Lookup[options, DecrimpingHead], Except[Automatic]],
						Lookup[options, DecrimpingHead],

					MatchQ[resolvedPreparation, Robotic],
						Null,

					(* If we're using a crimp cap, we need to get a decrimping head. *)
					MatchQ[coverType, Crimp],
						Lookup[
							FirstCase[
								decrimpingHeadPartModelPackets,
								KeyValuePattern[{CoverFootprint->Lookup[coverModelPacket, CoverFootprint]}],
								<|Object->Null|>
							],
							Object
						],

					(* Otherwise, we don't need a decrimping head. *)
					True,
						Null
				];

				(* Resolve the crimping pressure option. *)
				crimpingPressure=Which[
					MatchQ[Lookup[options, CrimpingPressure], Except[Automatic]],
						Lookup[options, CrimpingPressure],

					MatchQ[resolvedPreparation, Robotic],
						Null,

					(* If we're using a crimp cap, we need to get a decrimping head. *)
					MatchQ[coverType, Crimp],
						If[MatchQ[Lookup[coverModelPacket, CrimpingPressure], GreaterEqualP[0 PSI]],
							Lookup[coverModelPacket, CrimpingPressure],
							20 PSI
						],

					(* Otherwise, we don't need a crimping pressure. *)
					True,
						Null
				];

				(* Resolve the PlateSealAdapter option. *)
				(* If the PlateSealAdapter is specified or the instrument is set to Biorad PlateSealer. *)
				plateSealAdapter=Which[
					MatchQ[Lookup[options, PlateSealAdapter], ObjectP[]],
						Lookup[options, PlateSealAdapter],
					And[
						Or[
							MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]],(* BioRad PlateSealer *)
							MatchQ[instrumentModel, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]]
						],
						MemberQ[Lookup[containerModelPacket, CoverFootprints], SealSBS]
					],
						Model[Container, Rack, "id:01G6nvGk5vrm"],(* "PX1 sealer adapter for low profile SBS plate" *)
					And[
						Or[
							MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]],(* BioRad PlateSealer *)
							MatchQ[instrumentModel, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]]
						],
						MemberQ[Lookup[containerModelPacket, CoverFootprints], SealGCR96]
					],
						Model[Container, Rack, "id:bq9LA0JNZrOr"],(* "PX1 sealer adapter for GCR96 droplet cartridge" *)
					True,
						Null
				];


				(* If we use BioRad platesealer, resolve Temperature to 180 C. *)
				temperature=Which[
					MatchQ[Lookup[options, Temperature], Except[Automatic]],
						Lookup[options, Temperature],
					Or[
						MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]],(* BioRad PlateSealer *)
						MatchQ[instrumentModel, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]]
						],
						If[MatchQ[opaque,True],
							180 Celsius,
							185 Celsius
							],
					True,
						Null
				];

				(* If we use biorad platesealer, resolve Time to 3.5 Second for SBS plates and 5 Second for digital PCR cartridge. *)
				time=Which[
					MatchQ[Lookup[options, Time], Except[Automatic]],
						Lookup[options, Time],
					Or[
						MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]],(* BioRad PlateSealer *)
						MatchQ[instrumentModel, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]]
					],
						If[MatchQ[Lookup[containerModelPacket, Object], ObjectP[Model[Container,Plate,DropletCartridge]]],
							5 Second,
							3.5 Second
						],
					True,
						Null
				];

				(* Resolve the PlateSealPaddle option. *)
				(* If the PlateSealPaddle is specified or Crystal Clear Sealing Film is used. *)
				plateSealPaddle=Which[
					MatchQ[Lookup[options, PlateSealPaddle], ObjectP[]],
						Lookup[options, PlateSealPaddle],
					MatchQ[Lookup[coverModelPacket, Object],ObjectP[Model[Item, PlateSeal, "id:8qZ1VWZNLJPp"]]],(* "Crystal Clear Sealing Film" *)
						Model[Item, PlateSealRoller, "id:XnlV5jlmLBYB"],(* "Film Sealing Paddle" *)
					True,
						Null
				];
				(* Resolve the Parafilm option based on the Parafilm field in Model[Container], Object[Container], Model[Sample] or Object[Sample]. *)
				(* If the field in these objects are not set, parafilm is not used unless explicitly specified by the user. *)
				parafilm=Which[
					MatchQ[Lookup[options, Parafilm], Except[Automatic]],
						Lookup[options, Parafilm],
					MatchQ[resolvedPreparation, Robotic],
						False,
					Or[
						MatchQ[Lookup[containerModelPacket, Parafilm], True],
						MatchQ[Lookup[containerPacket, Parafilm], True],
						And[MatchQ[modelSamplePackets, {PacketP[]..}], MemberQ[(Lookup[#, Parafilm]&)/@modelSamplePackets, True]],
						And[MatchQ[objectSamplePackets, {PacketP[]..}], MemberQ[(Lookup[#, Parafilm]&)/@objectSamplePackets, True]]
					],
						True,
					True,
						False
				];

				(* Resolve the AluminumFoil option based on the AluminumFoil field in Model[Container], Object[Container], Model[Sample] or Object[Sample]. *)
				(* If the field in these objects are not set, aluminum foil is not used unless explicitly specified by the user. *)
				aluminumFoil=Which[
					MatchQ[Lookup[options, AluminumFoil], Except[Automatic]],
						Lookup[options, AluminumFoil],
					MatchQ[resolvedPreparation, Robotic],
						False,
					Or[
						MatchQ[Lookup[containerModelPacket, AluminumFoil], True],
						MatchQ[Lookup[containerPacket, AluminumFoil], True],
						And[MatchQ[modelSamplePackets, {PacketP[]..}], MemberQ[(Lookup[#, AluminumFoil]&)/@modelSamplePackets, True]],
						And[MatchQ[objectSamplePackets, {PacketP[]..}], MemberQ[(Lookup[#, AluminumFoil]&)/@objectSamplePackets, True]]
					],
						True,
					True,
						False
				];

				(* Resolve the KeckClamp option based on the TaperGroundJointSize field in the resolved Cover. *)
				keckClamp = Which[
					(* user specified *)
					MatchQ[Lookup[options, KeckClamp], Except[Automatic]],
						Lookup[options, KeckClamp],

					(* the resolved Cover has a TaperGroundJointSize *)
					MatchQ[Lookup[coverModelPacket, TaperGroundJointSize], GroundGlassJointSizeP],
						Module[{jointSize, keckClampPacket},
							(* get the joint size of the tapered stopper cap *)
							jointSize = Lookup[coverModelPacket, TaperGroundJointSize];

							(* get the packet for the keck clamp that can fit this size *)
							keckClampPacket= SelectFirst[keckClampModelPackets, MemberQ[Lookup[#, TaperGroundJointSize], jointSize]&, <||>];

							(* If we found a good one, return that one, otherwise Null *)
							If[!MatchQ[keckClampPacket, <||>],
								Lookup[keckClampPacket, Object],
								Null
							]
						],

					(* Otherwise, Null *)
					True,
						Null
				];

				(* Resolve the KeepCovered field. If it's already set to True in Object[Container] keep it that way. Otherwise, don't set it. *)
				keepCovered=Which[
					MatchQ[Lookup[options, KeepCovered], Except[Automatic]],
						Lookup[options, KeepCovered],
					(* NOTE: We have to fully remove these types of covers in order to access the samples underneath. *)
					MatchQ[Lookup[containerPacket, KeepCovered], True] && !MatchQ[coverType, Crimp|Seal],
						True,
					True,
						Null
				];

				containerContainer=First[containerRepeatedContainers,Null];

				(* Resolve the environment option. *)
				(* Send in updated Prep value for proper environment determination. *)
				environment = Module[{calculateCoverEnvironmentOptions},
					(* Pass SterileTechnique->True for containers with live cells, since calculateCoverEnvironment relies on SterileTechnique->True to resolve to BSCs *)
					calculateCoverEnvironmentOptions = If[
						And[
							containsLiveCellsQ,
							MatchQ[Lookup[options, SterileTechnique], Automatic]
						],
						ReplacePart[options, Key[SterileTechnique] -> True],
						options
					];

					calculateCoverEnvironment[
						objectSamplePackets,
						containerRepeatedContainers,
						Join[calculateCoverEnvironmentOptions, <|Preparation -> resolvedPreparation, ActiveCart -> activeCart|>]
					]
				];

				(* Resolve the SterileTechnique option to True if we have cells in our sample. *)
				sterileTechnique=Which[
					MatchQ[Lookup[options, SterileTechnique], Except[Automatic]],
						Lookup[options, SterileTechnique],

					(* If the user has told us to use a BSC, use sterile technique. *)
					MatchQ[environment, ObjectP[{Model[Instrument, BiosafetyCabinet], Object[Instrument, BiosafetyCabinet], Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]],
						True,

					(* Otherwise, no sterile technique. *)
					True,
						False
				];

				(* Resolve the CoverLabel option. *)
				coverLabel=Which[
					MatchQ[Lookup[options, CoverLabel], Except[Automatic]],
						Lookup[options, CoverLabel],
					MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Download[cover, Object]], _String],
						LookupObjectLabel[currentSimulation, Download[cover, Object]],
					MemberQ[Keys[containerToCoverListRules],Lookup[containerPacket,Object]]&&MatchQ[resolvedPreparation,Robotic],
						Lookup[containerToCoverListRules,Lookup[containerPacket,Object]],
					True,
						CreateUniqueLabel["cover"]
				];

				(* Add our label to the tracking *)
				AppendTo[containerToCoverListRules,Lookup[containerPacket,Object]->coverLabel];

				(* Resolve the SampleLabel option. *)
				sampleLabel=Which[
					MatchQ[Lookup[options, SampleLabel], Except[Automatic]],
						Lookup[options, SampleLabel],
					And[
						MatchQ[originalInputObject, ObjectP[Object[Sample]]],
						MatchQ[currentSimulation, SimulationP],
						MatchQ[LookupObjectLabel[currentSimulation, Download[originalInputObject, Object]], _String]
					],
						LookupObjectLabel[currentSimulation, Download[originalInputObject, Object]],
					MatchQ[originalInputObject, ObjectP[Object[Sample]]],
						CreateUniqueLabel["covered sample"],
					True,
						Null
				];

				(* Resolve the SampleContainerLabel option. *)
				sampleContainerLabel=Which[
					MatchQ[Lookup[options, SampleContainerLabel], Except[Automatic]],
						Lookup[options, SampleContainerLabel],
					MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, Lookup[containerPacket, Object]], _String],
						LookupObjectLabel[currentSimulation, Lookup[containerPacket, Object]],
					True,
						CreateUniqueLabel["covered container"]
				];

				(* Error checking for Lid covering *)
				containerLidCompatibleError=And[
					(* Lid cannot cover plate *)
					MatchQ[containerLidCompatibleQ,False],
					(* We have resolved to use Lid (meaning that we don't have other choices *)
					MatchQ[coverType,Place],
					MatchQ[coverModelPacket,PacketP[Model[Item,Lid]]]
				];

				{
					sampleLabel,
					sampleContainerLabel,
					coverType,
					usePreviousCover,
					opaque,
					cover,
					coverLabel,
					septum,
					instrument,
					crimpingHead,
					decrimpingHead,
					crimpingPressure,
					temperature,
					time,
					parafilm,
					aluminumFoil,
					keckClamp,
					keepCovered,
					environment,
					sterileTechnique,
					coverModelPacket,
					plateSealAdapter,
					plateSealPaddle,
					containerLidCompatibleError,
					containsLiveCellsQ,
					plateSealSafeUseQ
				}
			]
		],
		{myInputs, objectContainerPackets, modelContainerPackets, objectSamplePacketList, modelSamplePacketList, objectContainerRepeatedContainerList, mapThreadFriendlyOptions}
	];

	(* Need to determine if we need to pick an aluminum foil roll.  We need to get some in the following circumstances: *)
	(* 1.) AluminumFoil is True (remember this is for wrapping the flask) *)
	(* 2.) CoverType is AluminumFoil and Cover for that corresponding container is a Model[Item, Lid] *)
	(* Importantly, if CoverType is AluminumFoil but the corresponding container is an Object, then we don't need to get a roll because we don't need to make a new cover; we just use an existing one *)
	needAluminumFoilQ = Or[
		MemberQ[resolvedAluminumFoils, True],
		MemberQ[
			PickList[resolvedCovers, resolvedCoverTypes, AluminumFoil],
			ObjectP[Model[Item, Lid]]
		]
	];

	(* now resolve AluminumFoilRoll *)
	specifiedAluminumFoilRoll = Lookup[myOptions, AluminumFoilRoll];
	resolvedAluminumFoilRoll = Which[
		(* if we specified it, go with that *)
		Not[MatchQ[specifiedAluminumFoilRoll, Automatic]], specifiedAluminumFoilRoll,
		(* if AluminumFoil has True or CoverType has AluminumFoil, then set to Model[Item, Consumable, "Aluminum Foil"] *)
		needAluminumFoilQ, Model[Item, Consumable, "id:xRO9n3vk166w"],
		True, Null
	];

	(* flip an error switch if we need aluminum foil and we're set to Null, or we don't need it and it is specified *)
	aluminumFoilRollError = Or[
		NullQ[resolvedAluminumFoilRoll] && needAluminumFoilQ,
		MatchQ[resolvedAluminumFoilRoll, ObjectP[]] && Not[needAluminumFoilQ]
	];

	(* Resolve Post Processing Options. *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[ReplaceRule[myOptions, Preparation->resolvedPreparation]];

	(* Gather these options together in a list. *)
	resolvedOptions=ReplaceRule[
		myOptions,
		{
			Preparation->resolvedPreparation,
			SampleLabel->resolvedSampleLabels,
			SampleContainerLabel->resolvedSampleContainerLabels,
			CoverType->resolvedCoverTypes,
			UsePreviousCover->resolvedUsePreviousCovers,
			Opaque->resolvedOpaques,
			WorkCell->resolvedWorkCell,
			Cover->resolvedCovers,
			CoverLabel->resolvedCoverLabels,
			Septum->resolvedSeptums,
			Stopper->Lookup[myOptions, Stopper],
			Instrument->resolvedInstruments,
			CrimpingHead->resolvedCrimpingHeads,
			DecrimpingHead->resolvedDecrimpingHeads,
			CrimpingPressure->resolvedCrimpingPressures,
			Temperature->resolvedTemperatures,
			Time->resolvedTimes,
			Parafilm->resolvedParafilms,
			AluminumFoil->resolvedAluminumFoils,
			AluminumFoilRoll -> resolvedAluminumFoilRoll,
			KeckClamp -> resolvedKeckClamps,
			PlateSealAdapter->resolvedPlateSealAdapters,
			PlateSealPaddle->resolvedPlateSealPaddles,
			KeepCovered->resolvedKeepCovereds,
			Environment->resolvedEnvironments,
			SterileTechnique->resolvedSterileTechniques,

			Name->Lookup[myOptions, Name],
			ImageSample -> Lookup[resolvedPostProcessingOptions, ImageSample],
			MeasureVolume -> Lookup[resolvedPostProcessingOptions, MeasureVolume],
			MeasureWeight -> Lookup[resolvedPostProcessingOptions, MeasureWeight],
			SamplesInStorageCondition -> Lookup[myOptions, SamplesInStorageCondition]
		}
	];

	mapThreadFriendlyResolvedOptions=OptionsHandling`Private`mapThreadOptions[ExperimentCover,resolvedOptions];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Septum can only be given/must be given if the cover has SeptumRequired->True. *)
	conflictingSeptumErrors=MapThread[
		Function[{septum, cover, coverModelPacket, index},
			If[Or[
					And[
						MatchQ[septum, Except[Null]],
						MatchQ[Lookup[coverModelPacket, SeptumRequired, False]/.{$Failed->False}, False]
					],
					And[
						MatchQ[septum, Null],
						MatchQ[Lookup[coverModelPacket, SeptumRequired, False]/.{$Failed->False}, True]
					]
				],
				{septum, cover, index},
				Nothing
			]
		],
		{resolvedSeptums, resolvedCovers, resolvedCoverModelPackets, Range[Length[myContainers]]}
	];

	conflictingSeptumTest=If[Length[conflictingSeptumErrors]==0,
		Test["If a Septum is required for a crimped cover (SeptumRequired->True is set in the Model[Item, Cap]), a Septum is specified:",True,True],
		Test["If a Septum is required for a crimped cover (SeptumRequired->True is set in the Model[Item, Cap]), a Septum is specified:",False,True]
	];

	If[Length[conflictingSeptumErrors] > 0 && messagesQ,
		Message[
			Error::NoSeptumGiven,
			conflictingSeptumErrors[[All,3]],
			ObjectToString[conflictingSeptumErrors[[All,1]], Cache->cacheBall],
			ObjectToString[conflictingSeptumErrors[[All,2]], Cache->cacheBall]
		]
	];

	(* Stoppers can only be used if the Cover we're using is a Crimped Cap. *)
	conflictingStopperErrors=MapThread[
		Function[{stopper, coverModelPacket, index},
			If[And[
					MatchQ[stopper, ObjectP[]],
					!MatchQ[Lookup[coverModelPacket, CoverType], Crimp]
				],
				{stopper, Lookup[coverModelPacket, Object], index},
				Nothing
			]
		],
		{Lookup[mapThreadFriendlyOptions, Stopper], resolvedCoverModelPackets, Range[Length[myContainers]]}
	];

	conflictingStopperTest=If[Length[conflictingStopperErrors]==0,
		Test["If a Stopper is requested to be used for the covering, the cover model that we're using must be CoverType->Crimp:",True,True],
		Test["If a Stopper is requested to be used for the covering, the cover model that we're using must be CoverType->Crimp:",False,True]
	];

	If[Length[conflictingStopperErrors] > 0 && messagesQ,
		Message[
			Error::StopperConflict,
			conflictingStopperErrors[[All,3]],
			ObjectToString[conflictingStopperErrors[[All,1]], Cache->cacheBall],
			ObjectToString[conflictingStopperErrors[[All,2]], Cache->cacheBall]
		]
	];


	(* Keck Clamps can only be used if the Cover we're using is a Model[Item, Cap] with a TaperGroundJointSize. *)
	conflictingKeckClampErrors=MapThread[
		Function[{keckClamp, coverModelPacket, index},
			Module[{keckClampModelPacket},
				keckClampModelPacket=Which[
					MatchQ[keckClamp, ObjectP[Object[Item, Clamp]]],
						fetchModelPacketFromFastAssoc[keckClamp, fastCacheBall],
					MatchQ[keckClamp, ObjectP[Model[Item, Clamp]]],
						fetchPacketFromFastAssoc[keckClamp, fastCacheBall],
					True,
						<||>
				];

				If[Or[
						(* If the cover requires a clamp (TaperGroundJointSize is populated) but we don't have one. *)
						And[
							MatchQ[Lookup[coverModelPacket, TaperGroundJointSize], GroundGlassJointSizeP],
							MatchQ[keckClampModelPacket, <||>]
						],

						(* OR we have a clamp but it isn't compatible with the cover given. *)
						And[
							MatchQ[keckClampModelPacket, PacketP[Model[Item, Clamp]]],
							!MemberQ[Lookup[keckClampModelPacket, TaperGroundJointSize], Lookup[coverModelPacket, TaperGroundJointSize]]
						]
					],
					{index, keckClamp, Lookup[coverModelPacket, Object]},
					Nothing
				]
			]
		],
		{resolvedKeckClamps, resolvedCoverModelPackets, Range[Length[myContainers]]}
	];

	conflictingKeckClampTest=If[Length[conflictingKeckClampErrors]==0,
		Test["If a Cover is a tapered stopper with a TaperGroundJointSize, a KeckClamp with the same TaperGroundJointSize must be specified to secure the Cover to the specified container. Covers and KeckClamps with different TaperGroundJointSizes cannot be used together:",True,True],
		Test["If a Cover is a tapered stopper with a TaperGroundJointSize, a KeckClamp with the same TaperGroundJointSize must be specified to secure the Cover to the specified container. Covers and KeckClamps with different TaperGroundJointSizes cannot be used together:",False,True]
	];

	If[Length[conflictingKeckClampErrors] > 0 && messagesQ,
		Message[
			Error::KeckClampConflict,
			conflictingKeckClampErrors[[All,1]],
			ObjectToString[conflictingKeckClampErrors[[All,2]], Cache->cacheBall],
			ObjectToString[conflictingKeckClampErrors[[All,3]], Cache->cacheBall]
		]
	];

	(* If the container is a plate that contains live cells, cover is breathable & sterile (if applicable) *)
	liveCellsCoverWarnings = Module[{breathableSterileCovers},
		breathableSterileCovers = {
			Model[Item, PlateSeal, "id:BYDOjvG74Abm"] (* "AeraSeal Plate Seal, Breathable Sterile" *)
		};

		MapThread[Function[{index, containerModelPacket, cover, coverModelPacket, containsLiveCellsQ, plateSealSafeUseQ},
			If[
				And[
					(* Throw the warning if: *)
					MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]],
					containsLiveCellsQ,
					plateSealSafeUseQ,
					!MatchQ[{resolvedPreparation, resolvedWorkCell}, {Robotic, STAR | bioSTAR | microbioSTAR}],
					(* and the cover is not breathable & sterile *)
					!MatchQ[coverModelPacket, ObjectP[breathableSterileCovers]]
				],
				{index, cover},
				Nothing
			]],
			{Range[Length[myContainers]], modelContainerPackets, resolvedCovers, resolvedCoverModelPackets, containsLiveCellsQs, plateSealSafeUseQs}
		]
	];

	liveCellsCoverTest = If[Length[liveCellsCoverWarnings] == 0,
		Warning["If the container is a plate that contains live cells, the cover is breathable & sterile (if applicable):", True, True],
		Warning["If the container is a plate that contains live cells, the cover is breathable & sterile (if applicable):", False, True]
	];

	If[Length[liveCellsCoverWarnings] > 0 && messagesQ,
		Message[
			Warning::LiveCellsCoverConflict,
			liveCellsCoverWarnings[[All, 1]],
			ObjectToString[liveCellsCoverWarnings[[All, 2]], Cache -> cacheBall]
		]
	];

	(* If using a cover that requires sterile technique, the SterileTechnique option must be set to True *)
	sterileTechniqueConflictErrors = If[MatchQ[resolvedPreparation, Robotic],
		{},
		Module[{sterileTechniqueCovers},
			sterileTechniqueCovers = {
				Model[Item, PlateSeal, "id:BYDOjvG74Abm"] (* "AeraSeal Plate Seal, Breathable Sterile" *)
			};

			MapThread[Function[{index, cover, coverModelPacket, sterileTechnique},
				If[
					And[
						MatchQ[coverModelPacket, ObjectP[sterileTechniqueCovers]],
						!sterileTechnique
					],
					{index, cover, sterileTechnique},
					Nothing
				]],
				{Range[Length[myContainers]], resolvedCovers, resolvedCoverModelPackets, resolvedSterileTechniques}
			]
		]
	];

	sterileTechniqueConflictTest = If[Length[sterileTechniqueConflictErrors] == 0,
		Test["If using a cover that requires sterile technique, the SterileTechnique option must be set to True:", True, True],
		Test["If using a cover that requires sterile technique, the SterileTechnique option must be set to True:", False, True]
	];

	If[Length[sterileTechniqueConflictErrors] > 0 && messagesQ,
		Message[
			Error::SterileTechniqueConflict,
			sterileTechniqueConflictErrors[[All, 1]],
			ObjectToString[sterileTechniqueConflictErrors[[All, 2]], Cache -> cacheBall],
			ObjectToString[sterileTechniqueConflictErrors[[All, 3]], Cache -> cacheBall]
		]
	];

	(* If SterileTechnique->True, Environment has to be a BSC (unless robotic). *)
	sterileTechniqueErrors=If[MatchQ[resolvedPreparation, Robotic],
		{},
		MapThread[
			Function[{sterileTechnique, environment, index},
				If[MatchQ[sterileTechnique, True] && !MatchQ[environment, ObjectP[{Model[Instrument, BiosafetyCabinet], Object[Instrument, BiosafetyCabinet], Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]],
					{sterileTechnique, environment, index},
					Nothing
				]
			],
			{resolvedSterileTechniques, resolvedEnvironments, Range[Length[myContainers]]}
		]
	];

	sterileTechniqueTest=If[Length[sterileTechniqueErrors]==0,
		Test["If SterileTechnique->True, the Environment option must be set to a BiosafetyCabinet:",True,True],
		Test["If SterileTechnique->True, the Environment option must be set to a BiosafetyCabinet:",False,True]
	];

	If[Length[sterileTechniqueErrors] > 0 && messagesQ,
		Message[
			Error::SterileTechniqueEnvironmentConflict,
			sterileTechniqueErrors[[All,3]],
			ObjectToString[sterileTechniqueErrors[[All,1]], Cache->cacheBall],
			ObjectToString[sterileTechniqueErrors[[All,2]], Cache->cacheBall]
		]
	];

	(* Cover has to match CoverFootprints and CoverTypes in Model[Container]. *)
	coverContainerErrors=MapThread[
		Function[{cover, coverModelPacket, containerModelPacket, index, coverType},
			If[And[
					(* Cover -> Null is okay if we have a BuiltInCover *)
					!(MatchQ[Lookup[containerModelPacket, BuiltInCover], True] && MatchQ[cover, Null]),
					Or[
						!MatchQ[Lookup[coverModelPacket, CoverFootprint], Alternatives@@Lookup[containerModelPacket, CoverFootprints]],
						!MemberQ[Lookup[containerModelPacket, CoverTypes], Lookup[coverModelPacket, CoverType]]
					],
					!MatchQ[coverType, AluminumFoil] (* Do not check error for Aluminum foil, it's meant to be a temporary cover which should fit everything *)
				],
				{index, cover, Lookup[containerModelPacket, CoverFootprints], Lookup[coverModelPacket, CoverFootprint, Null], Lookup[containerModelPacket, CoverTypes], Lookup[coverModelPacket, CoverType, Null]},
				Nothing
			]
		],
		{resolvedCovers, resolvedCoverModelPackets, modelContainerPackets, Range[Length[myContainers]], resolvedCoverTypes}
	];

	coverContainerTest=If[Length[coverContainerErrors]==0,
		Test["The Cover specified must match the container model's CoverFootprints and CoverTypes fields:",True,True],
		Test["The Cover specified must match the container model's CoverFootprints and CoverTypes fields:",False,True]
	];

	If[Length[coverContainerErrors] > 0 && messagesQ,
		Message[
			Error::CoverContainerConflict,
			coverContainerErrors[[All,1]],
			ObjectToString[coverContainerErrors[[All,2]], Cache->cacheBall],
			coverContainerErrors[[All,3]],
			coverContainerErrors[[All,4]],
			coverContainerErrors[[All,5]],
			coverContainerErrors[[All,6]]
		]
	];

	(* Lid does not fit Plate *)
	containerLidCompatibleTests=Module[{passingInputs, passingInputsTest, nonPassingInputsTest, nonPassingInputs},
		(* Get the inputs that pass this test. *)
		nonPassingInputs = PickList[myContainers, containerLidCompatibleErrors, True];
		passingInputs = PickList[myContainers, containerLidCompatibleErrors, False];
		(* Create a test for the passing inputs. *)
		passingInputsTest = If[Length[passingInputs] > 0,
			Test["If Lid is required for Place cover,  the inputs " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " can fit into the lids:", True, True],
			Nothing
		];
		(* Create a test for the non-passing inputs. *)
		nonPassingInputsTest = If[Length[nonPassingInputs] > 0,
			Test["If Lid is required for Place cover,  the input plates " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " can fit into the lids:", True, False],
			Nothing
		];
		(* Return our created tests. *)
		{passingInputsTest, nonPassingInputsTest}
	];

	containerLidCompatibleInvalidOptions=If[MemberQ[containerLidCompatibleErrors,True] && messagesQ,
		Message[
			Error::ContainerLidIncompatible,
			ObjectToString[PickList[myContainers, containerLidCompatibleErrors, True], Cache->cacheBall]
		];
		{Preparation,CoverType},
		{}
	];

	(* Cover has to match CoverType, Opaque. *)
	coverErrors=MapThread[
		Function[{cover, coverModelPacket, coverType, opaque, index},
			If[And[
					Or[
						!MatchQ[Lookup[coverModelPacket, CoverType], coverType],
						!MatchQ[Lookup[coverModelPacket, Opaque]/.{Null|$Failed->False}, opaque]
					],
					!MatchQ[cover, Null]
				],
				{index, cover, Lookup[coverModelPacket, CoverType], Lookup[coverModelPacket, Opaque], coverType, opaque},
				Nothing
			]
		],
		{resolvedCovers, resolvedCoverModelPackets, resolvedCoverTypes, resolvedOpaques, Range[Length[myContainers]]}
	];

	coverTest=If[Length[coverErrors]==0,
		Test["The Cover option matches the options CoverType and Opaque:",True,True],
		Test["The Cover option matches the options CoverType and Opaque:",False,True]
	];

	If[Length[coverErrors] > 0 && messagesQ,
		Message[
			Error::CoverOptionsConflict,
			coverErrors[[All,1]],
			ObjectToString[coverErrors[[All,2]], Cache->cacheBall],
			coverErrors[[All,3]],
			coverErrors[[All,4]],
			coverErrors[[All,5]],
			coverErrors[[All,6]]
		]
	];

	(* Cannot use a cover if BuiltInCover->True. *)
	builtInCoverErrors=MapThread[
		Function[{cover, coverType, containerModelPacket, index},
			If[MatchQ[Lookup[containerModelPacket, BuiltInCover], True] && (!MatchQ[cover, Null] || !MatchQ[coverType, Null]),
				index,
				Nothing
			]
		],
		{resolvedCovers, resolvedCoverTypes, modelContainerPackets, Range[Length[myContainers]]}
	];

	builtInCoverTest=If[Length[builtInCoverErrors]==0,
		Test["A Cover can only be specified if the container being covered does not have BuiltInCover->True in its model:",True,True],
		Test["A Cover can only be specified if the container being covered does not have BuiltInCover->True in its model:",False,True]
	];

	If[Length[builtInCoverErrors] > 0 && messagesQ,
		Message[
			Error::BuiltInCover,
			builtInCoverErrors
		]
	];

	(* Cannot KeepCovered if CoverType is Crimp or Seal. *)
	keepCoveredErrors=MapThread[
		Function[{keepCovered, coverType, index},
			If[MatchQ[keepCovered, True] && MatchQ[coverType, Crimp|Seal],
				{index, keepCovered, coverType},
				Nothing
			]
		],
		{resolvedKeepCovereds, resolvedCoverTypes, Range[Length[myContainers]]}
	];

	keepCoveredTest=If[Length[keepCoveredErrors]==0,
		Test["The KeepCovered option can only be set to True if the cover that we're using is not a Crimp or Seal:",True,True],
		Test["The KeepCovered option can only be set to True if the cover that we're using is not a Crimp or Seal:",False,True]
	];

	If[Length[keepCoveredErrors] > 0 && messagesQ,
		Message[
			Error::KeepCoveredConflict,
			keepCoveredErrors[[All,1]],
			keepCoveredErrors[[All,2]],
			keepCoveredErrors[[All,3]]
		]
	];

	(* PlateSealer must match the cover. *)
	Module[{resolvedInstrumentModels,resolvedCoverModels},
		resolvedInstrumentModels=If[MatchQ[#, ObjectP[Object[Instrument]]], Lookup[fetchPacketFromCache[#, cacheBall], Model], #]&/@resolvedInstruments;
		resolvedCoverModels=If[MatchQ[#, ObjectP[Object[Item]]], Lookup[fetchPacketFromCache[#, cacheBall], Model], #]&/@resolvedCovers;

		plateSealerErrors=If[MatchQ[resolvedPreparation, Robotic],
			MapThread[
				Function[{instrument, cover, index},
					(* Using Hamilton Plate Sealer has to use compatible Hamilton Plate Seals *)
					If[MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:eGakldJ91zEE"]]] && (* Hamilton Plate Sealer *)
								!MatchQ[cover, ObjectP[{Model[Item, PlateSeal, "id:R8e1PjpEDbea"], Model[Item, PlateSeal, "id:O81aEBZzkJ1D"]}]],(* Hamilton Plate Seals *)
						{index, cover, instrument},
						Nothing
					]
				],
				{resolvedInstrumentModels, resolvedCoverModels, Range[Length[myContainers]]}
			],
			MapThread[
				Function[{instrument, cover, coverModelPacket, index},
					If[
						Or[
							(* Using BioRad Plate Sealer has to use TemperatureActivatedAdhesive Plate Seals. *)
							And[
								MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]],(* BioRad Plate Sealer *)
								Or[
									!MatchQ[cover, ObjectP[Model[Item, PlateSeal]]],
									!MatchQ[Lookup[coverModelPacket, SealType], TemperatureActivatedAdhesive]
								]
							],
							(* Using TemperatureActivatedAdhesive Plate Seals has to use BioRad Plate Sealer. *)
							And[
								!MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]],(* BioRad Plate Sealer *)
								MatchQ[cover, ObjectP[Model[Item, PlateSeal]]],
								MatchQ[Lookup[coverModelPacket, SealType], TemperatureActivatedAdhesive]
							],
							(* Using adhesive plateseal to cover manually, the instrument can only be Null or Hamilton Plate Sealer(as a stand-alone instrument). *)
							And[
								!MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:eGakldJ91zEE"]]|Null],(* Hamilton Plate Sealer or press by hand. *)
								MatchQ[cover, ObjectP[Model[Item, PlateSeal]]],
								MatchQ[Lookup[coverModelPacket, SealType], Adhesive]
							],
							And[
								MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:eGakldJ91zEE"]]], (* Hamilton Plate Sealer *)
								!MatchQ[cover, ObjectP[{Model[Item, PlateSeal, "id:R8e1PjpEDbea"], Model[Item, PlateSeal, "id:O81aEBZzkJ1D"]}]](* Not Hamilton Plate Seals *)
							]
						],
						{index, cover, instrument},
						Nothing
					]
				],
				{resolvedInstrumentModels, resolvedCoverModels, resolvedCoverModelPackets, Range[Length[myContainers]]}
			]
		];
	];

	plateSealerTest=If[Length[plateSealerErrors]==0,
		Test["When using a temperature activated adhesive or Hamilton adhesive plate seal, instrument must be specified in the Instrument option. When using a plate sealer Instrument, the cover (plate seal) must be compatible with the plate sealer:",True,True],
		Test["When using a temperature activated adhesive or Hamilton adhesive plate seal, instrument must be specified in the Instrument option. When using a plate sealer Instrument, the cover (plate seal) must be compatible with the plate sealer:",False,True]
	];

	If[Length[plateSealerErrors] > 0 && messagesQ,
		Message[
			Error::PlateSealerInstrumentConflict,
			plateSealerErrors[[All,1]],
			ObjectToString[plateSealerErrors[[All,2]], Cache->cacheBall],
			ObjectToString[plateSealerErrors[[All,3]], Cache->cacheBall]
		]
	];

	(* Plate to be covered by PlateSealer must match the height limit. *)
	Module[{resolvedInstrumentModels},
		resolvedInstrumentModels=If[MatchQ[#, ObjectP[Object[Instrument]]], Lookup[fetchPacketFromCache[#, cacheBall], Model], #]&/@resolvedInstruments;

		plateHeightErrors= MapThread[
				Function[{instrument, container, index},
					If[
						Or[
							(* Using Hamilton Plate Sealer has to use compatible-height SBS container *)
							And[
								MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:eGakldJ91zEE"]]], (* Hamilton Plate Sealer *)
								!MatchQ[Lookup[container, Dimensions], {_,_,RangeP[$MinRoboticPlateSealHeight,$MaxRoboticPlateSealHeight]}]
							],
							(* Using BioRad PlateSealer for regular SBS plate has to be within height limit *)
							And[
								MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]]&&!MatchQ[container[Object], ObjectP[Model[Container,Plate,DropletCartridge]]], (* BioRad Plate Sealer *)
								!MatchQ[Lookup[container, Dimensions], {_,_,RangeP[$MinManualHeatPlateSealHeight,$MaxManualHeatPlateSealHeight]}]
							]
						],
						{index, Lookup[container,Object], instrument},
						Nothing
					]
				],
				{resolvedInstrumentModels, modelContainerPackets, Range[Length[myContainers]]}
		];
	];

	If[Length[plateHeightErrors] > 0 && messagesQ,
		Message[
			Error::PlateSealerHeightConflict,
			plateHeightErrors[[All,1]],
			ObjectToString[plateHeightErrors[[All,2]], Cache->cacheBall],
			ObjectToString[plateHeightErrors[[All,3]], Cache->cacheBall]
		]
	];

	(* Plate to be covered by BioRad PlateSealer must have the right adapter. *)
	Module[{resolvedInstrumentModels,resolvedPlateSealAdapterModels},
		resolvedInstrumentModels=If[MatchQ[#, ObjectP[Object[Instrument]]], Lookup[fetchPacketFromCache[#, cacheBall], Model], #]&/@resolvedInstruments;
		resolvedPlateSealAdapterModels=If[MatchQ[#, ObjectP[Object[Container,Rack]]], Lookup[fetchPacketFromCache[#, cacheBall], Model], #]&/@resolvedPlateSealAdapters;

		plateSealAdapterErrors= MapThread[
				Function[{instrument, plateSealAdapter, container, index},
					If[
						Or[
							(* Using BioRad Plate Sealer has to use compatible-height adapter *)
							And[
								MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]], (* BioRad Plate Sealer *)
								!MatchQ[plateSealAdapter,ObjectP[{Model[Container, Rack, "PX1 sealer adapter for GCR96 droplet cartridge"],Model[Container, Rack, "PX1 sealer adapter for low profile SBS plate"]}]]
							],
							(* Using BioRad Plate Sealer adapter has to use the plate sealer instrument *)
							And[
								!MatchQ[instrument, ObjectP[Model[Instrument, PlateSealer, "id:AEqRl9KEXbkd"]]], (* BioRad Plate Sealer *)
								MatchQ[plateSealAdapter,ObjectP[]]
							],
							(* Using BioRad PlateSealer for regular SBS plate has to be within height limit *)
							And[
								MatchQ[plateSealAdapter,ObjectP[Model[Container, Rack, "PX1 sealer adapter for low profile SBS plate"]]],
								!MatchQ[container[Dimensions], {_,_,RangeP[$MinManualHeatPlateSealHeight,$MaxManualHeatPlateSealHeight]}]
							],
							(* Using BioRad PlateSealer for digitalPCR plate has to use GCR96 adapter *)
							And[
								MatchQ[plateSealAdapter,ObjectP[Model[Container, Rack, "PX1 sealer adapter for GCR96 droplet cartridge"]]],
								!MatchQ[Lookup[container,Object], ObjectP[Model[Container,Plate,DropletCartridge]]]
							]
						],
						{index, plateSealAdapter, Lookup[container,Object], instrument},
						Nothing
					]
				],
				{resolvedInstrumentModels, resolvedPlateSealAdapterModels, modelContainerPackets, Range[Length[myContainers]]}
			];
		];

	If[Length[plateSealAdapterErrors] > 0 && messagesQ,
		Message[
			Error::PlateSealAdapterConflict,
			plateSealAdapterErrors[[All,1]],
			ObjectToString[plateSealAdapterErrors[[All,2]], Cache->cacheBall],
			ObjectToString[plateSealAdapterErrors[[All,3]], Cache->cacheBall]
		]
	];

	(* Some PlateSeal must have the right PlateSealPaddle to apply. *)
	Module[{resolvedCoverModels,resolvedPlateSealPaddleModels},
		resolvedCoverModels=If[MatchQ[#, ObjectP[Object[Item]]], Lookup[fetchPacketFromCache[#, cacheBall], Model], #]&/@resolvedCovers;
		resolvedPlateSealPaddleModels=If[MatchQ[#, ObjectP[Object[Item,PlateSealRoller]]], Lookup[fetchPacketFromCache[#, cacheBall], Model], #]&/@resolvedPlateSealPaddles;

		plateSealPaddleErrors= MapThread[
			Function[{plateSealPaddle, cover, index},
				If[
					Or[
						(* We have to use platesealpaddle to apply crystal clear sealing film and only this film. *)
						And[
							MatchQ[cover, ObjectP[Model[Item, PlateSeal, "id:8qZ1VWZNLJPp"]]],(* "Crystal Clear Sealing Film" *)
							!MatchQ[plateSealPaddle,ObjectP[Model[Item, PlateSealRoller, "id:XnlV5jlmLBYB"]]](* "Film Sealing Paddle" *)
						],
						And[
							!MatchQ[cover, ObjectP[Model[Item, PlateSeal, "id:8qZ1VWZNLJPp"]]],(* "Crystal Clear Sealing Film" *)
							MatchQ[plateSealPaddle,ObjectP[Model[Item, PlateSealRoller, "id:XnlV5jlmLBYB"]]](* "Film Sealing Paddle" *)
						]
					],
					{index, plateSealPaddle, cover},
					Nothing
				]
			],
			{resolvedPlateSealPaddleModels, resolvedCoverModelPackets, Range[Length[myContainers]]}
		];
	];

	If[Length[plateSealPaddleErrors] > 0 && messagesQ,
		Message[
			Error::PlateSealPaddleConflict,
			plateSealPaddleErrors[[All,1]],
			ObjectToString[plateSealPaddleErrors[[All,2]], Cache->cacheBall],
			ObjectToString[plateSealPaddleErrors[[All,3]], Cache->cacheBall]
		]
	];

	(* CrimpingHead and DecrimpingHead must match the cover. *)
	crimperErrors=If[MatchQ[resolvedPreparation, Robotic],
		{},
		MapThread[
			Function[{instrument, crimpingHead, decrimpingHead, cover, coverType, coverModelPacket, index},
				If[
					Or[
						And[
							MatchQ[coverType, Crimp],
							Or[
								(* If we're supposed to be crimping and don't have the crimper, crimping head, or decrimping head, we can't proceed. *)
								!MatchQ[instrument, ObjectP[{Model[Instrument, Crimper], Object[Instrument, Crimper]}]],
								!MatchQ[crimpingHead, ObjectP[{Model[Part, CrimpingHead], Object[Part, CrimpingHead]}]],
								!MatchQ[decrimpingHead, ObjectP[{Model[Part, DecrimpingHead], Object[Part, DecrimpingHead]}]],

								(* If we have all these things, but they don't match the CoverFootprint/CrimpType of the cover model, then we can't proceed. *)
								!MatchQ[Lookup[fetchPacketFromFastAssoc[crimpingHead, fastCacheBall], {CoverFootprint, CrimpType}], Lookup[coverModelPacket, {CoverFootprint, CrimpType}]],
								!MatchQ[Lookup[fetchPacketFromFastAssoc[decrimpingHead, fastCacheBall], {CoverFootprint}], Lookup[coverModelPacket, {CoverFootprint}]]
							]
						],
						And[
							!MatchQ[coverType, Crimp],
							Or[
								(* If we're supposed to be crimping and don't have the crimper, crimping head, or decrimping head, we can't proceed. *)
								MatchQ[instrument, ObjectP[{Model[Instrument, Crimper], Object[Instrument, Crimper]}]],
								MatchQ[crimpingHead, ObjectP[{Model[Part, CrimpingHead], Object[Part, CrimpingHead]}]],
								MatchQ[decrimpingHead, ObjectP[{Model[Part, DecrimpingHead], Object[Part, DecrimpingHead]}]]
							]
						]
					],
					{index, instrument, crimpingHead, decrimpingHead},
					Nothing
				]
			],
			{resolvedInstruments, resolvedCrimpingHeads, resolvedDecrimpingHeads, resolvedCovers, resolvedCoverTypes, resolvedCoverModelPackets, Range[Length[myContainers]]}
		]
	];

	crimperTest=If[Length[crimperErrors]==0,
		Test["When using a crimped cap as a cover, (1) a crimper instrument must be specified in the Instrument option, (2) a crimping head that matches the cover's CoverFootprint and CrimpType must be specified, and (3) a decrimping head that matches the cover's CoverFootprint must be specified:",True,True],
		Test["When using a crimped cap as a cover, (1) a crimper instrument must be specified in the Instrument option, (2) a crimping head that matches the cover's CoverFootprint and CrimpType must be specified, and (3) a decrimping head that matches the cover's CoverFootprint must be specified:",False,True]
	];

	If[Length[crimperErrors] > 0 && messagesQ,
		Message[
			Error::CrimperConflict,
			crimperErrors[[All,1]],
			ObjectToString[crimperErrors[[All,2]], Cache->cacheBall],
			ObjectToString[crimperErrors[[All,3]], Cache->cacheBall],
			ObjectToString[crimperErrors[[All,4]], Cache->cacheBall]
		]
	];

	(* UsePreviousCover is set but the PreviousCover is not the same as the Cover. *)
	usePreviousCoverErrors=MapThread[
		Function[{usePreviousCover, cover, containerPacket, index},
			If[And[
					MatchQ[usePreviousCover, True],
					Or[
						!MatchQ[Lookup[containerPacket, PreviousCover], ObjectP[cover]],
						MatchQ[Lookup[fetchPacketFromCache[previousCoverObjectPackets, Lookup[containerPacket, PreviousCover]], Status], Discarded]
					]
				],
				{index, cover},
				Nothing
			]
		],
		{resolvedUsePreviousCovers, resolvedCovers, objectContainerPackets, Range[Length[myContainers]]}
	];

	usePreviousCoverTest=If[Length[usePreviousCoverErrors]==0,
		Test["When UsePreviousCover->True, the Cover option should be set to the previous cover that was used for the container:",True,True],
		Test["When UsePreviousCover->True, the Cover option should be set to the previous cover that was used for the container:",False,True]
	];

	If[Length[usePreviousCoverErrors] > 0 && messagesQ,
		Message[
			Error::UsePreviousCoverConflict,
			usePreviousCoverErrors[[All,1]],
			ObjectToString[usePreviousCoverErrors[[All,2]], Cache->cacheBall]
		]
	];

	(* If the Cover field is already set in the Object[Container], it already has a cover and cannot be re-covered. *)
	(* NOTE: ExperimentTransfer sets FastTrack->True which indicates that Cover shouldn't look at the current cover state. *)
	alreadyCoveredErrors=If[MatchQ[Lookup[ToList[myOptions], FastTrack, False], True],
		{},
		Flatten[{
			MapThread[
				Function[{containerPacket, index},
					If[MatchQ[Lookup[containerPacket, Cover], ObjectP[]],
						Lookup[containerPacket, Object],
						Nothing
					]
				],
				{objectContainerPackets, Range[Length[myContainers]]}
			],
			(* If we have repeated container objects in myContainers for RSP, it may be because samples in a plate were provided as input instead of container. This is OK as we will just do one uncover in RSP *)
			If[!MatchQ[resolvedPreparation,Robotic],
				Cases[Tally[myContainers], {_, GreaterP[1]}][[All, 1]],
				{}
			]
		}]
	];

	alreadyCoveredTest=If[Length[alreadyCoveredErrors]==0,
		Test["The containers that are to be covered cannot already have a cover on them:",True,True],
		Test["The containers that are to be covered cannot already have a cover on them:",False,True]
	];

	If[Length[alreadyCoveredErrors] > 0 && messagesQ,
		Message[
			Error::ContainerIsAlreadyCovered,
			ObjectToString[alreadyCoveredErrors, Cache->cacheBall]
		]
	];

	aluminumFoilRollTest = If[aluminumFoilRollError,
		Test["AluminumFoilRoll is only specified if AluminumFoil is needed to wrap the container or create a lid:", True, False],
		Test["AluminumFoilRoll is only specified if AluminumFoil is needed to wrap the container or create a lid:", True, True]
	];

	If[aluminumFoilRollError && messagesQ,
		Message[
			Error::AluminumFoilRollConflict,
			resolvedAluminumFoilRoll,
			resolvedCoverTypes,
			resolvedAluminumFoils
		]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		If[Length[alreadyCoveredErrors]>0,
			alreadyCoveredErrors,
			Nothing
		]
	}]];

	invalidOptions=DeleteDuplicates[Flatten[{
		If[Length[conflictingSeptumErrors]>0,
			{Septum},
			Nothing
		],
		If[Length[sterileTechniqueConflictErrors] > 0,
			{SterileTechnique, Cover},
			Nothing
		],
		If[Length[sterileTechniqueErrors]>0,
			{SterileTechnique, Environment},
			Nothing
		],
		If[Length[conflictingStopperErrors]>0,
			{Stopper, Cover},
			Nothing
		],
		If[Length[coverErrors]>0,
			{Cover, CoverType, Opaque},
			Nothing
		],
		If[Length[coverContainerErrors]>0,
			{Cover},
			Nothing
		],
		If[Length[keepCoveredErrors]>0,
			{KeepCovered, CoverType},
			Nothing
		],
		If[Length[builtInCoverErrors]>0,
			{Cover},
			Nothing
		],
		If[Length[plateSealerErrors]>0,
			{Instrument, Cover},
			Nothing
		],
		If[Length[plateHeightErrors]>0,
			{Instrument, Container},
			Nothing
		],
		If[Length[plateSealAdapterErrors]>0,
			{PlateSealAdapter, Container},
			Nothing
		],
		If[Length[plateSealPaddleErrors]>0,
			{PlateSealPaddle, Cover},
			Nothing
		],
		If[Length[crimperErrors]>0,
			{Instrument, Cover},
			Nothing
		],
		If[Length[usePreviousCoverErrors]>0,
			{UsePreviousCover, Cover},
			Nothing
		],
		If[Length[conflictingKeckClampErrors]>0,
			{KeckClamp},
			Nothing
		],
		If[MatchQ[preparationResult, $Failed],
			{Preparation},
			Nothing
		],
		If[aluminumFoilRollError,
			{AluminumFoilRoll},
			Nothing
		],
		containerLidCompatibleInvalidOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> Flatten[{
			resolvedOptions,
			resolvedPostProcessingOptions
		}],
		Tests -> Flatten[{
			conflictingSeptumTest,
			liveCellsCoverTest,
			sterileTechniqueConflictTest,
			sterileTechniqueTest,
			conflictingStopperTest,
			coverContainerTest,
			containerLidCompatibleTests,
			coverTest,
			keepCoveredTest,
			builtInCoverTest,
			plateSealerTest,
			crimperTest,
			usePreviousCoverTest,
			alreadyCoveredTest,
			preparationTest,
			aluminumFoilRollTest
		}]
	}
];

(* ::Subsection:: *)
(* coverResourcePackets *)

DefineOptions[
	coverResourcePackets,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

coverResourcePackets[
	myInputs:{ObjectP[{Object[Sample], Object[Container]}]..},
	myContainers:{ObjectP[Object[Container]]..},
	myTemplatedOptions:{(_Rule|_RuleDelayed)...},
	myResolvedOptions:{(_Rule|_RuleDelayed)..},
	ops:OptionsPattern[]
]:=Module[
	{
		expandedInputs, expandedResolvedOptions, outputSpecification, output, gatherTests, messages, inheritedCache, simulation,
		resolvedPreparation, mapThreadFriendlyResolvedOptions, protocolPacket, unitOperationPackets, rawResourceBlobs,
		resourcesWithoutName, resourceToNameReplaceRules, allResourceBlobs, resourcesOk, resourceTests, testsRule, resultRule,
		containerModelPackets, containerPackets, coverPackets, crimpingJigPackets
	},

	(* -- SHARED LOGIC BETWEEN ROBOTIC AND MANUAL -- *)

	(* Expand the resolved options if they weren't expanded already. *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentCover, {myContainers}, myResolvedOptions];

	(* Determine the requested return value from the function. *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if True, then silence the messages. *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Get the inherited cache. *)
	inheritedCache = Lookup[ToList[ops],Cache];
	simulation = Lookup[ToList[ops],Simulation];

	(* Lookup the Preparation option. *)
	resolvedPreparation = Lookup[myResolvedOptions, Preparation];

	(* Get a map thread friendly version of our resolved options. *)
	mapThreadFriendlyResolvedOptions=OptionsHandling`Private`mapThreadOptions[ExperimentCover, myResolvedOptions];

	(* Download information about our container model. *)
	{containerPackets, coverPackets, containerModelPackets}=Flatten/@Quiet[
		Download[
			{
				myContainers,
				Cases[Lookup[myResolvedOptions, Cover], ObjectP[Object[Item]]],
				myContainers
			},
			{
				{Packet[Name, Contents, Notebook]},
				{Packet[Container, Model, Name], Packet[Model[{Name, Barcode}]]},
				{Packet[Model[{Dimensions, Footprint, ExternalDimensions3D, Name}]]}
			},
			Simulation->simulation,
			Cache->inheritedCache
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* Get information about our crimping jigs as well. *)
	crimpingJigPackets=getCrimpingJigPackets["Memoization"];

	(* Are we making resources for Manual or Robotic? *)
	{protocolPacket, unitOperationPackets}=If[MatchQ[resolvedPreparation, Manual],
		Module[
			{
				sampleResources, containerNotebooks, coverResources, septumResources, stopperResources, uniqueKeckClampResources,
				keckClampResources, uniqueInstrumentResources, uniqueEnvironmentResources, aluminumFoilResource,
				uniquePlateSealAdapterResources, uniquePlateSealPaddleResources, coverManualUnitOperationPackets, manualProtocolPacket, sharedFieldPacket,
				finalizedPacket, specifiedCoverPackets, capRacks, specifiedCoverModelPackets, mapThreadOptionsWithResources, groupedMapThreadOptionsWithResources,
				nonHiddenCoverOptions, uniqueCrimpingHeadResources, uniqueDecrimpingHeadResources, crimpingJigs, uniqueCrimpingJigResources,
				resolvedCoverType, resolvedCover, resolvedAluminum, pickAluminumFoilQ
			},

			(* Create resources for our samples and containers. *)
			(* NOTE: If the object is already in our environment, we don't actually resource pick it to save time. This can lead to *)
			(* incorrect outstanding resource errors downstream. *)
			sampleResources=(Which[
				MatchQ[#, ObjectP[Model[]]],
					Resource[Sample->#],
				MatchQ[#, ObjectP[Object[]]],
					Link[Download[#, Object]],
				True,
					Null
			]&)/@myInputs;

			(* Retrieve the notebooks of the samples being covered *)
			containerNotebooks = containerPackets[[All,3]];

			(* Create resources for our covers. Pass on Rent -> True if the cover is covering a public container *)
			(* NOTE: If the object is already in our environment, we don't actually resource pick it to save time. This can lead to *)
			(* incorrect outstanding resource errors downstream. *)
			(* if we're doing CoverType -> AluminumFoil, we need to just put the model in here, not a resource since we have to do some shenanigans because we are creating aluminum foil lids fresh, not finding old ones. In simulateExperimentCover, it will be temporarily swapped to a Resource[] form in order to simulate resources and generate the UploadCover packets for simulation. *)
			coverResources = Flatten@MapThread[
				Function[{cover, notebook, coverType},
					Which[
						MatchQ[cover, ObjectP[]] && MatchQ[coverType, AluminumFoil], Link[cover],
						MatchQ[cover, ObjectP[]] && NullQ[notebook], Resource[Sample -> cover, Name -> CreateUUID[], Rent -> True],
						MatchQ[cover, ObjectP[]] && !NullQ[notebook], Resource[Sample -> cover, Name -> CreateUUID[]],
						True, Null
					]
				],
				{Lookup[myResolvedOptions, Cover], containerNotebooks, Lookup[myResolvedOptions, CoverType]}
			];

			(* Create resources for our septa. *)
			septumResources=(If[MatchQ[#, ObjectP[]], Resource[Sample->#, Name->CreateUUID[]], Null]&)/@Lookup[myResolvedOptions, Septum];

			(* Create resources for our stoppers. *)
			stopperResources=(If[MatchQ[#, ObjectP[]], Resource[Sample->#, Name->CreateUUID[]], Null]&)/@Lookup[myResolvedOptions, Stopper];

			(* make a single resource for aluminum foil if we need for the cover itself or if we are covering the outside of the flask *)
			aluminumFoilResource = If[MatchQ[Lookup[myResolvedOptions, AluminumFoilRoll], ObjectP[]],
				(* Model[Item, Consumable, "Aluminum Foil"] *)
				Resource[Sample -> Lookup[myResolvedOptions, AluminumFoilRoll], Name -> CreateUUID[]],
				Null
			];

			(* Create resources for our keck clamps. *)
			(* Keck Clamps are counted items (like tips) where we sticker the bag but not the individual items inside (because they're too small to be stickered). *)
			(* If we need multiple keck clamps of the same model, combine them into the same resource request so that we don't have to get multiple bags. *)
			uniqueKeckClampResources=Map[
				Function[{clampAndCount},
					clampAndCount[[1]] -> Resource[Sample->clampAndCount[[1]], Amount->clampAndCount[[2]], Name->CreateUUID[]]
				],
				Tally[Download[Cases[Lookup[myResolvedOptions, KeckClamp], ObjectP[]], Object]]
			];

			keckClampResources=(If[MatchQ[#, ObjectP[]], Lookup[uniqueKeckClampResources, #], Null]&)/@Download[Lookup[myResolvedOptions, KeckClamp], Object];

			(* Create resources for our instruments. *)
			uniqueInstrumentResources=(#->Which[
				MatchQ[#, ObjectP[{Model[Instrument], Object[Instrument]}]],
					Resource[Instrument->#, Time->(5 Minute * Length[Cases[Lookup[myResolvedOptions, Instrument], #]]), Name->CreateUUID[]],
				True,
					Null
			]&)/@DeleteDuplicates[Lookup[myResolvedOptions, Instrument]];

			(* Create resources for our crimping heads. *)
			uniqueCrimpingHeadResources=(#->Which[
				MatchQ[#, ObjectP[{Model[Part], Object[Part]}]],
					Resource[Sample->#, Name->CreateUUID[]],
				True,
					Null
			]&)/@DeleteDuplicates[Lookup[myResolvedOptions, CrimpingHead]];

			(* Create resources for our decrimping heads. *)
			uniqueDecrimpingHeadResources=(#->Which[
				MatchQ[#, ObjectP[{Model[Part], Object[Part]}]],
					Resource[Sample->#, Name->CreateUUID[]],
				True,
					Null
			]&)/@DeleteDuplicates[Lookup[myResolvedOptions, DecrimpingHead]];

			(* Create resources for each of our environments. *)
			uniqueEnvironmentResources=(#->Which[
				(* special treatment for fumehood, we do not really care which model to use for uncovering if we are really going to use a fumehood, so just allow all models *)
				MatchQ[#, ObjectP[Model[Instrument, HandlingStation, FumeHood, "id:1ZA60vzEmYv0"]]],
					With[{currentFumeHoodModels= Cases[transferModelsSearch["Memoization"][[23]], ObjectP[Model[Instrument, HandlingStation, FumeHood]]]},
						Resource[Instrument -> currentFumeHoodModels]
					],
				MatchQ[#, ObjectP[{Model[Container], Object[Container]}]],
					Resource[Sample->#],
				MatchQ[#, ObjectP[{Model[Instrument], Object[Instrument]}]],
					Resource[Instrument->#],
				True,
					Null
			]&)/@DeleteDuplicates[Lookup[myResolvedOptions, Environment]];

			(* Create PlateSealAdapter resources. *)
			uniquePlateSealAdapterResources=(#->Which[
				MatchQ[#, ObjectP[{Model[Container,Rack],Object[Container,Rack]}]],
					Resource[Sample->#, Name->CreateUUID[]],
				True,
					Null
			]&)/@DeleteDuplicates[Lookup[myResolvedOptions, PlateSealAdapter]];

			(* Create PlateSealPaddle resources. *)
			uniquePlateSealPaddleResources=(#->Which[
				MatchQ[#, ObjectP[{Model[Item,PlateSealRoller],Object[Item,PlateSealRoller]}]],
				Resource[Sample->#, Name->CreateUUID[]],
				True,
				Null
			]&)/@DeleteDuplicates[Lookup[myResolvedOptions, PlateSealPaddle]];

			(* Fetch the Cover and Model packet. *)
			specifiedCoverPackets=If[!MatchQ[#, ObjectP[Object[Item, Cap]]],Null,fetchPacketFromCache[#,coverPackets]]&/@Lookup[myResolvedOptions,Cover];
			specifiedCoverModelPackets=If[!MatchQ[#, ObjectP[Object[Item, Cap]]],Null,fetchModelPacketFromCache[#,coverPackets]]&/@Lookup[myResolvedOptions,Cover];

			(* Link to the cap rack that the cover is on if the cover we're taking off is a cap that has Barcode->False|Null. *)
			capRacks=MapThread[Function[{innerCoverPacket,innerCoverModelPacket},
				If[
					And[
						If[NullQ[innerCoverPacket],False,MatchQ[Download[Lookup[innerCoverPacket, Object],Object], ObjectP[Object[Item, Cap]]]],
						If[NullQ[innerCoverModelPacket],False,MatchQ[Lookup[innerCoverModelPacket, Barcode], False|Null]],
						MatchQ[Lookup[innerCoverPacket,Container], ObjectP[Object[Container, Rack]]]
					],
					Download[Lookup[innerCoverPacket,Container],Object],
					Null
				]],
				{
					specifiedCoverPackets,
					specifiedCoverModelPackets
				}
			];

			(* Create resources for our crimping jigs. *)
			crimpingJigs=MapThread[
				Function[{containerModelPacket, crimpingHead},
					If[MatchQ[crimpingHead, ObjectP[]],
						Lookup[
							FirstCase[
								crimpingJigPackets,
								KeyValuePattern[{
									VialHeight->Lookup[containerModelPacket, Dimensions][[3]],
									VialFootprint-> If[NullQ[Lookup[containerModelPacket, Footprint, Null]],
										(* Find a jig that will fit the x dimension if the footprint is not imformative *)
										Symbol["Vial" <> ToString[Ceiling[Unitless[Lookup[containerModelPacket, Dimensions][[1]], Millimeter], 2]] <> "mm"],
										Lookup[containerModelPacket, Footprint]
									]
								}],
								FirstOrDefault[crimpingJigPackets, <|Object->Null|>]
							],
							Object
						],
						Null
					]
				],
				{containerModelPackets, Lookup[myResolvedOptions, CrimpingHead]}
			];

			uniqueCrimpingJigResources=(#->Which[
				MatchQ[#, ObjectP[{Model[Part], Object[Part]}]],
					Resource[Sample->#, Name->CreateUUID[]],
				True,
					Null
			]&)/@DeleteDuplicates[crimpingJigs];

			(* Replace our option values with these resources in our map threaded options. *)
			mapThreadOptionsWithResources=MapThread[
				Function[{originalOptions, newOptionsWithResources},
					ReplaceRule[Normal[originalOptions], Normal[newOptionsWithResources]]
				],
				{
					mapThreadFriendlyResolvedOptions,
					(AssociationThread[
						{
							Sample,
							Cover,
							Septum,
							Stopper,
							Instrument,
							Environment,
							PlateSealAdapter,
							PlateSealPaddle,
							CapRack,
							CrimpingHead,
							DecrimpingHead,
							CrimpingJig,
							KeckClamp
						},
						#
					]&)/@Transpose[{
						sampleResources,
						coverResources,
						septumResources,
						stopperResources,
						Lookup[uniqueInstrumentResources, #]&/@Lookup[myResolvedOptions, Instrument],
						Lookup[uniqueEnvironmentResources, #]&/@Lookup[myResolvedOptions, Environment],
						Lookup[uniquePlateSealAdapterResources, #]&/@Lookup[myResolvedOptions, PlateSealAdapter],
						Lookup[uniquePlateSealPaddleResources, #]&/@Lookup[myResolvedOptions, PlateSealPaddle],
						capRacks,
						(Lookup[uniqueCrimpingHeadResources, #]&)/@Lookup[myResolvedOptions, CrimpingHead],
						(Lookup[uniqueDecrimpingHeadResources, #]&)/@Lookup[myResolvedOptions, DecrimpingHead],
						(Lookup[uniqueCrimpingJigResources, #]&)/@crimpingJigs,
						keckClampResources
					}]
				}
			];

			(* Group these map threaded options by the CoverType, Environment, and Instrument. *)
			(* NOTE: Screw, Snap, Place, and Pry are all treated the same in Cover but they are not the same as Null, which is BuiltInCover and do not require pick or verify cap *)
			(* There are basically four different types of covers to consider, as in the task "03a16e47-1432-490a-9fa7-3b1adf82088c" - Crimp, Seal, Screw/Snap/Place/Pry, Null *)
			(* note that all the AluminumFoil covers MUST be in the same unit operation, or else uploadCoverExecute won't work.  If we change the logic here, we need to change it in uploadCoverExecute *)
			groupedMapThreadOptionsWithResources=Values@GroupBy[
				mapThreadOptionsWithResources,
				({Lookup[#, CoverType]/.{(Screw|Snap|Place|Pry)->Screw}, Lookup[#, Instrument], Lookup[#, Environment], Lookup[#, CrimpingHead], Lookup[#, DecrimpingHead], Lookup[#, CrimpingPressure]}&)
			];

			(* Only include non-hidden options from Cover. Include some special non-options. *)
			nonHiddenCoverOptions=Complement[
				Join[
					Lookup[
						Cases[OptionDefinition[ExperimentCover], KeyValuePattern["Category"->Except["Hidden"]]],
						"OptionSymbol"
					],
					{
						Sample,
						Cover,
						Septum,
						Stopper,
						Instrument,
						Environment,
						PlateSealAdapter,
						PlateSealPaddle,
						CapRack,
						CrimpingJig
					}
				],
				{
					ImageSample,
					MeasureVolume,
					MeasureWeight,
					Template
				}
			];

			(* For each of our environments, *)
			coverManualUnitOperationPackets=UploadUnitOperation[
				Map[
					Function[{options},
						(* NOTE: Our options are still a list of map thread friendly options at this point, we need to merge them into *)
						(* a single unit operation. *)
						Cover@Cases[Normal@Merge[options, Join], Verbatim[Rule][Alternatives@@nonHiddenCoverOptions, _]]
					],
					groupedMapThreadOptionsWithResources
				],
				UnitOperationType->Batched,
				Preparation->Manual,
				FastTrack->True,
				Upload->False
			];

			(* Return our final protocol packet. *)
			manualProtocolPacket=<|
				Object->CreateID[Object[Protocol, Cover]],

				Replace[SamplesIn]->(Link[#, Protocols]&)/@DeleteDuplicates@Download[Cases[Lookup[containerPackets, Contents], ObjectP[Object[Sample]], Infinity], Object],
				Replace[ContainersIn]->(Link[#, Protocols]&)/@DeleteDuplicates[myContainers],

				Replace[BatchedUnitOperations]->(Link[#, Protocol]&)/@Lookup[coverManualUnitOperationPackets, Object],

				Replace[CoverTypes]->Lookup[myResolvedOptions, CoverType],
				Replace[UsePreviousCovers]->Lookup[myResolvedOptions, UsePreviousCover],
				Replace[Opaque]->Lookup[myResolvedOptions, Opaque],
				Replace[Covers]->coverResources,
				Replace[CapRacks]->Link[capRacks],
				Replace[Septa]->septumResources,
				Replace[Stoppers]->stopperResources,
				Replace[PlateSealAdapter]->(Lookup[uniquePlateSealAdapterResources, #]&)/@Lookup[myResolvedOptions, PlateSealAdapter],
				Replace[PlateSealPaddle]->(Lookup[uniquePlateSealPaddleResources, #]&)/@Lookup[myResolvedOptions, PlateSealPaddle],
				Replace[Instruments]->(Lookup[uniqueInstrumentResources, #]&)/@Lookup[myResolvedOptions, Instrument],
				Replace[CrimpingHeads]->(Lookup[uniqueCrimpingHeadResources, #]&)/@Lookup[myResolvedOptions, CrimpingHead],
				Replace[DecrimpingHeads]->(Lookup[uniqueDecrimpingHeadResources, #]&)/@Lookup[myResolvedOptions, DecrimpingHead],
				Replace[CrimpingPressures]->Lookup[myResolvedOptions, CrimpingPressure],
				Replace[Environment]->Link/@((Lookup[uniqueEnvironmentResources,#]&)/@Lookup[myResolvedOptions,Environment]),
				Replace[Temperatures]->Lookup[myResolvedOptions, Temperature],
				Replace[Times]->Lookup[myResolvedOptions, Time],
				Replace[Parafilm]->Lookup[myResolvedOptions, Parafilm],
				Replace[AluminumFoil]->Lookup[myResolvedOptions, AluminumFoil],
				Replace[AluminumFoilRoll] -> Link[aluminumFoilResource],
				Replace[KeepCovered]->Lookup[myResolvedOptions, KeepCovered],
				Replace[SterileTechnique]->Lookup[myResolvedOptions, SterileTechnique],
				Replace[CrimpingJigs]->(Lookup[uniqueCrimpingJigResources, #]&)/@crimpingJigs,

				Replace[Checkpoints]->{
					{"Performing Covering",1*Minute*Length[coverManualUnitOperationPackets],"The containers are covered.",Link[Resource[Operator -> $BaselineOperator, Time -> (1*Minute*Length[coverManualUnitOperationPackets])]]}
				},

				Author->If[MatchQ[Lookup[myResolvedOptions, ParentProtocol],Null],
					Link[$PersonID,ProtocolsAuthored]
				],
				ParentProtocol->If[MatchQ[Lookup[myResolvedOptions, ParentProtocol],ObjectP[ProtocolTypes[Output -> Short]]],
					Link[Lookup[myResolvedOptions, ParentProtocol],Subprotocols]
				],

				UnresolvedOptions->RemoveHiddenOptions[ExperimentCover,myTemplatedOptions],
				ResolvedOptions->myResolvedOptions,

				Name->Lookup[myResolvedOptions, Name]
			|>;

			(* Generate a packet with the shared fields. *)
			sharedFieldPacket = populateSamplePrepFields[myContainers, myResolvedOptions, Cache -> inheritedCache];

			(* Merge the shared fields with the specific fields. *)
			finalizedPacket = Join[sharedFieldPacket, manualProtocolPacket];

			(* Return our protocol packet and unit operation packets. *)
			{finalizedPacket, coverManualUnitOperationPackets}
		],
		Module[
			{inputResources, containerResources, containerNotebooks, coverResources, uniqueInstruments, uniqueInstrumentsResources, instrumentResources,
				coverUnitOperationPacket, coverUnitOperationPacketWithLabeledObjects},

			(* Create resources for our samples and containers. *)
			inputResources=(Resource[Sample->#]&)/@myInputs;
			containerResources=(Resource[Sample->#]&)/@myContainers;

			(* Retrieve the notebooks of the samples being covered *)
			containerNotebooks = containerPackets[[All,3]];

			(* Create resources for our covers. Pass on Rent -> True if the cover is covering a public container
			and pass on the CoverLabel as the name for the resource if we have a model. No need to use label as the name if we are pointing to an object already. *)
			(* This is critical in RSP if we have repeated cover/uncover and want to use the same lid. The first Cover UO has the label pointing to a model while the remaining UOs should point to the simulated lid object. We cannot use the same name for multiple different resource requests - model vs object *)
			(* Object reference is already unique so the label is not really critical here *)
			coverResources=Flatten@MapThread[
				Which[
					(* Give name to the  *)
					MatchQ[#1, ObjectP[Model]] && StringQ[#2] && NullQ[#3], Resource[Sample -> #1, Name -> #2, Rent -> True],
					MatchQ[#1, ObjectP[Object]] && StringQ[#2] && NullQ[#3], Resource[Sample -> #1, Name -> CreateUUID[], Rent -> True],
					MatchQ[#1, ObjectP[Model]] && StringQ[#2] && !NullQ[#3], Resource[Sample -> #1, Name -> #2],
					MatchQ[#1, ObjectP[Object]] && StringQ[#2] && !NullQ[#3], Resource[Sample -> #1, Name -> CreateUUID[]],
					MatchQ[#1, ObjectP[]] && NullQ[#3], Resource[Sample -> #1, Name -> CreateUUID[], Rent -> True],
					MatchQ[#1, ObjectP[]] && !NullQ[#3], Resource[Sample -> #1, Name -> CreateUUID[]],
					True, Null
				]&,
				{Lookup[myResolvedOptions, Cover], Lookup[myResolvedOptions, CoverLabel], containerNotebooks}
			];

			uniqueInstruments=DeleteDuplicates[Download[Lookup[myResolvedOptions,Instrument],Object]];
			uniqueInstrumentsResources=Map[
				#->If[MatchQ[#,ObjectP[{Model[Instrument],Object[Instrument]}]],
					Resource[Instrument->#, Name->CreateUUID[]],
					Null
				]&,
				uniqueInstruments
			];
			instrumentResources=Lookup[myResolvedOptions,Instrument]/.uniqueInstrumentsResources;

			(* Upload our UnitOperation with the Source/Destination/Tips options replaced with resources. *)
			coverUnitOperationPacket=Module[{nonHiddenCoverOptions},
				(* Only include non-hidden options from Cover. *)
				nonHiddenCoverOptions=Lookup[
					Cases[OptionDefinition[ExperimentCover], KeyValuePattern["Category"->Except["Hidden"]]],
					"OptionSymbol"
				];

				UploadUnitOperation[
					Cover@@Join[
						{
							Sample->containerResources
						},
						(* NOTE: We allow for MultichannelCoverName (developer field) since it's used in the exporter. *)
						ReplaceRule[
							Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenCoverOptions, _]],
							{
								Cover->coverResources,
								Instrument->instrumentResources,
								(* NOTE: Don't pass Name down. *)
								Name->Null
							}
						]
					],

					Preparation->Robotic,
					UnitOperationType->Output,
					FastTrack->True,
					Upload->False
				]
			];
			(* Add the LabeledObjects field to the Robotic unit operation packet. *)
			(* NOTE: This will be stripped out of the UnitOperation packet by the framework and only stored at the top protocol level. *)
			coverUnitOperationPacketWithLabeledObjects=Append[
				coverUnitOperationPacket,
				Replace[LabeledObjects]->DeleteDuplicates@Join[
					Cases[
						Transpose[{Lookup[myResolvedOptions, SampleLabel], inputResources}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample], Model[Sample]}]]]}
					],
					Cases[
						Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], containerResources}],
						{_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Container], Model[Container]}]]]}
					],

					Cases[
						Transpose[{Lookup[myResolvedOptions, CoverLabel], coverResources}],
						{_String, _Resource}
					]
				]
			];

			(* Return our protocol packet (we don't have one) and our unit operation packet. *)
			{Null, {coverUnitOperationPacketWithLabeledObjects}}
		]
	];

	(* Make list of all the resources we need to check in FRQ. *)
	rawResourceBlobs=DeleteDuplicates[Cases[Flatten[{Normal[protocolPacket], Normal[unitOperationPackets]}],_Resource,Infinity]];

	(* Get all resources without a name. *)
	(* NOTE: Don't try to consolidate operator resources. *)
	resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False] && !KeyExistsQ[#, Operator]&)]]];

	resourceToNameReplaceRules=MapThread[#1->#2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@resourcesWithoutName}];
	allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;

	(* Verify we can satisfy all our resources. *)
	{resourcesOk,resourceTests}=Which[
		MatchQ[$ECLApplication,Engine],
			{True,{}},
		(* When Preparation->Robotic, the framework will call FRQ for us. *)
		MatchQ[resolvedPreparation, Robotic],
			{True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Simulation->simulation,Cache->inheritedCache],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Simulation->simulation,Cache->inheritedCache],Null}
	];

	(* --- Output --- *)

	(* Generate the tests rule. *)
	testsRule=Tests->If[gatherTests,
		resourceTests,
		{}
	];

	(* Generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed. *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
		{protocolPacket, unitOperationPackets}/.resourceToNameReplaceRules,
		$Failed
	];

	(* Return the output as we desire it. *)
	outputSpecification/.{resultRule,testsRule}
];

(* ::Subsection::Closed:: *)
(* Simulation *)

DefineOptions[
	simulateExperimentCover,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentCover[
	myProtocolPacket:(PacketP[Object[Protocol, Cover], {Object, ResolvedOptions}]|$Failed|Null),
	myUnitOperationPackets:({PacketP[]..}|$Failed),
	myInputs:{ObjectP[{Object[Sample], Object[Container]}]..},
	myContainers:{ObjectP[Object[Container]]..},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentCover]
]:=Module[
	{protocolObject,aluminumFoilInCoversPositions, mapThreadFriendlyOptions, resolvedPreparation, currentSimulation, unitOperationField,
		simulatedUnitOperationPackets, simulatedCovers, uploadCoverPackets, keepCoveredUpdates, simulationWithLabels},

	(* Initiate a list to keep track of which positions in covers of protocol packet we simulated aluminum foil resources. This is for replace Model with simulated objects later in calculating uploadCoverPackets. Trying to avoid diving deep into batched unit operations and replacing there will affect actual lab operation. *)
	aluminumFoilInCoversPositions = {};

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=Which[
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		MatchQ[Lookup[myResolvedOptions, Preparation], Robotic],
			SimulateCreateID[Object[Protocol,RoboticSamplePreparation]],
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket, $Failed],
			SimulateCreateID[Object[Protocol,Cover]],
		True,
			Lookup[myProtocolPacket, Object]
	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentCover,
		myResolvedOptions
	];

	(* Lookup our resolved preparation option. *)
	resolvedPreparation=Lookup[myResolvedOptions, Preparation];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation=Which[
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		MatchQ[myProtocolPacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
			Module[{protocolPacket},
				protocolPacket=<|
					Object->protocolObject,
					Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[myUnitOperationPackets, Object],
					(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
					(* simulate resources will NOT simulate them for you. *)
					(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
					Replace[RequiredObjects]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Except[Object[Resource, Instrument]]]], Infinity]
					],
					Replace[RequiredInstruments]->DeleteDuplicates[
						Cases[myUnitOperationPackets, Resource[KeyValuePattern[Type->Object[Resource, Instrument]]], Infinity]
					],
					ResolvedOptions->{},
					UnresolvedOptions -> {}
				|>;

				SimulateResources[protocolPacket, myUnitOperationPackets, ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]]
			],

		(* Otherwise, if we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
		(* and skipped resource packet generation. *)
		MatchQ[myProtocolPacket, $Failed],
			SimulateResources[
					<|
						Object->protocolObject,
						Replace[ContainersIn]->(Link[Resource[Sample->#]]&)/@DeleteDuplicates[myContainers],
						ResolvedOptions->myResolvedOptions,
						UnresolvedOptions -> {}
					|>,
					Cache->Lookup[ToList[myResolutionOptions], Cache, {}],
					Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
				],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol, Cover]. *)
		True,
		(* In case of using aluminum foil, the Cover field still has a Model instead of Resource. For SimulateResources to work properly and generate the uploadcover packets downstream, we need to do a replace in the protocol packets to fake a cover resource just for this simulation. No need to worry about the unit operation packets because aluminum foil cover is not Robotic-compatible *)
		Module[{coverResources, aluminumFoilUpdatedCoverResources,aluminumCoverResourceUpdatedProtocolPacket},
			(* Get the calculated Cover field generated by the resource packet*)
			coverResources = Lookup[myProtocolPacket, Replace[Covers]];
			(*For those still a Model, generate a Resource of it instead*)
			aluminumFoilUpdatedCoverResources = MapIndexed[
				Function[{cover,index},
					If[MatchQ[cover, LinkP[Model]],
						AppendTo[aluminumFoilInCoversPositions,First[index]];
						Resource[Sample ->LinkedObject[cover],Name -> CreateUUID[]],
						cover
					]
				],
				coverResources
			];
			(* Update the packet for input into SimulateResources*)
			aluminumCoverResourceUpdatedProtocolPacket = Append[
				myProtocolPacket,
				<|Replace[Covers] -> aluminumFoilUpdatedCoverResources|>];
			(* Call SimulateResources *)
			SimulateResources[aluminumCoverResourceUpdatedProtocolPacket, myUnitOperationPackets, Simulation -> Lookup[ToList[myResolutionOptions], Simulation, Null]]
		]
	];

	(* Figure out what field to download from. *)
	unitOperationField=If[MatchQ[protocolObject, ObjectP[Object[Protocol, Cover]]],
		BatchedUnitOperations,
		OutputUnitOperations
	];

	(* Download information from our simulated resources. *)
	{simulatedUnitOperationPackets,simulatedCovers}=Quiet[
		With[{insertMe=unitOperationField},
			Download[
				protocolObject,
				{
					Packet[insertMe[{CoverLink}]],
					Covers
				},
				Simulation->currentSimulation
			]
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* Call UploadSampleCover on our containers and covers. *)
	uploadCoverPackets=If[MatchQ[myProtocolPacket, $Failed],
		{},
		Module[{containersAndCovers, uoCovers, updatedCovers},
			(*Grab the list of simulated covers from the unit operation packets*)
			uoCovers = Flatten[Lookup[simulatedUnitOperationPackets, CoverLink, $Failed]];
			(*In case there is any aluminum foil that stays as a model, replace it with the simulated object*)
			updatedCovers = If[MatchQ[simulatedCovers, {ObjectP[]..}] && Length[aluminumFoilInCoversPositions] > 0,
				RiffleAlternatives[
					Cases[uoCovers,ObjectP[Object]],
					simulatedCovers[[aluminumFoilInCoversPositions]],
					MatchQ[#, ObjectP[Object]]& /@ uoCovers
				],
				uoCovers
			];
			containersAndCovers=Cases[
				Transpose[{myContainers, updatedCovers}],
				{_, ObjectP[{Object[Item, Cap], Object[Item,PlateSeal],Object[Item, Lid]}]}
			];

			If[Length[containersAndCovers]>0,
				UploadCover[
					containersAndCovers[[All,1]],
					Cover->containersAndCovers[[All,2]],
					Upload->False,
					Simulation->currentSimulation
				],
				{}
			]
		]
	];

	(* Set KeepCovered if the option is True|False. *)
	keepCoveredUpdates=MapThread[
		Function[{container, keepCovered},
			If[MatchQ[keepCovered, BooleanP],
				<|Object->container, KeepCovered->keepCovered|>,
				Nothing
			]
		],
		{myContainers, Lookup[myResolvedOptions, KeepCovered]}
	];

	(* Update our simulation. *)
	currentSimulation=UpdateSimulation[currentSimulation, Simulation[Flatten[{uploadCoverPackets, keepCoveredUpdates}]]];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the SamplesIn field. *)
	simulationWithLabels=Simulation[
		Labels->Rule@@@Join[
			Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], myInputs}],
				{_String, ObjectP[Object[Sample]]}
			],
			Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], myContainers}],
				{_String, ObjectP[Object[Container]]}
			],

			If[!MatchQ[myProtocolPacket, $Failed],
				Cases[
					Transpose[{Lookup[myResolvedOptions, CoverLabel], Flatten[Download[Lookup[simulatedUnitOperationPackets, CoverLink], Object]]}],
					{_String, ObjectP[]}
				],
				{}
			]
		],
		LabelFields->If[MatchQ[resolvedPreparation, Manual],
			Rule@@@Join[
				Cases[
					Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&)/@Range[Length[myContainers]]}],
					{_String, _}
				],
				Cases[
					Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&)/@Range[Length[myContainers]]}],
					{_String, _}
				],

				Cases[
					Transpose[{Lookup[myResolvedOptions, CoverLabel], (Field[CoverLink[[#]]]&)/@Range[Length[myContainers]]}],
					{_String, _}
				]
			],
			{}
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}
];
