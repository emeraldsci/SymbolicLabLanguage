(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentVapro5600Training*)

DefineOptions[ExperimentVapro5600Training,
	Options:>{
		{
			OptionName->Instrument,
			Default->Model[Instrument,Osmometer,"Vapro 5600"],
			Description->"The instrument used to measure the osmolality of the sample.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,Osmometer,"Vapro 5600"],Object[Instrument,Osmometer]}],
				ObjectTypes->{Model[Instrument,Osmometer],Object[Instrument,Osmometer]}
			]
		},
		{
			OptionName->Sample,
			Default->Automatic,
			Description->"The solution to be repeatedly measured by the operator to verify their repeatability.",
			ResolutionDescription->"Automatically set to 290 mmol/kg optimole standard.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				PreparedSample->False,
				PreparedContainer->False,
				ObjectTypes->{Model[Sample],Object[Sample]}
			]
		},
		{
			OptionName->SampleVolume,
			Default->10 Microliter,
			Description->"The volume of sample to repeatedly pipette to verify operator repeatability.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Microliter,11 Microliter],
				Units->Microliter
			]
		},
		{
			OptionName->Repeatability,
			Default->Automatic,
			Description->"The standard deviation of osmolality measurements that an operator must achieve over RepeatabilityNumberOfMeasurements to pass.",
			ResolutionDescription->"Automatically set to two times the repeatability of the instrument.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterEqualP[0 Milli Mole/Kilogram],
				Units->CompoundUnit[{1,{Millimole,{Millimole}}},{-1,{Kilogram,{Kilogram}}}]
			]
		},
		{
			OptionName->RepeatabilityNumberOfMeasurements,
			Default->3,
			Description->"The number of most recent readings for which the operator repeatability is calculated on a rolling basis.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,5,1]
			]
		},
		{
			OptionName->MaxNumberOfMeasurements,
			Default->Automatic,
			Description->"The maximum number of readings that the operator will perform before the protocol ends, if the repeatability is not met.",
			ResolutionDescription->"Automatically resolves to 3 times the RepeatabilityNumberOfMeasurements.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,15,1]
			]
		},
		{
			OptionName->Pipette,
			Default->Automatic,
			Description->"The instrument used to load sample into the instrument.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,Pipette],Object[Instrument,Pipette]}],
				ObjectTypes->{Model[Instrument,Pipette],Object[Instrument,Pipette]}
			]
		},
		{
			OptionName->InoculationPaper,
			Default->Automatic,
			Description->"The paper sample disks used to load sample in the osmometer.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Item,InoculationPaper],Object[Item,InoculationPaper]}],
				ObjectTypes->{Model[Item,InoculationPaper],Object[Item,InoculationPaper]}
			]
		},
		{
			OptionName->Tweezers,
			Default->Automatic,
			Description->"The instrument used to load sample the InoculationPapers into the instrument.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Item,Tweezer],Object[Item,Tweezer]}],
				ObjectTypes->{Model[Item,Tweezer],Object[Item,Tweezer]}
			]
		},
		ProtocolOptions
	}
];

(* ::Subsubsection:: *)
(*ExperimentVapro5600Training Errors and Warnings*)
Warning::Vapro5600LowSampleVolume="In Vapro5600Training, the sample volumes, `1`, are lower than the minimum recommended volume for a reliable reading with `2`, of `3`. Consider specifying a larger volume of sample, or take this into consideration when interpreting the result.";
Error::Vapro5600InstrumentIncompatible="In Vapro5600Training, the instrument specified, `1` is not a Model[Instrument,Osmometer,\"Vapro 5600\"]. Please specify an instrument of the correct model";
Error::Vapro5600SampleIncompatible="In Vapro5600Training, the specified sample `1` is of model `2` which is not supported. Please specify one of the Vapro 5600 calibrants (`3`).";
Warning::Vapro5600Repeatability="In Vapro5600Training, the repeatability specified, `1`, is less than the nominal instrument repeatability of `2`. The specified value may not be reliably achievable.";
Error::Vapro5600MaxNumberOfMeasurementsIncompatible="In Vapro5600Training, the max number of measurements, `1`, is less than the number of measurements to assess `2`. Please increase the max number of measurements, or leave as Automatic.";

(* Engine overload *)
ExperimentVapro5600Training[myOperator:{ObjectP[Object[User,Emerald]]},myOptions:OptionsPattern[]]:=ExperimentVapro5600Training[First[myOperator],myOptions];

ExperimentVapro5600Training[myOperator:ObjectP[Object[User,Emerald]],myOptions:OptionsPattern[]]:=Module[
	{
		listedOperator,listedOptions,outputSpecification,output,gatherTests,cacheOption,safeOptionsNamed,safeOpsTests,
		operator,safeOps,templatedOptions,templateTests,expandedSafeOps,inheritedOptions,optionsWithObjects,
		userSpecifiedObjects,objectsExistQs,objectsExistTests,osmometerInstrumentModels,inoculationPapersList,
		pipettesList,tweezersList,specifiedInstrumentObjects,specifiedInstrumentModels,allInstrumentModels,specifiedSampleObjects,
		specifiedSampleModels,osmolalityStandardsList,allStandardsModels,tipsList,allPackets,specifiedPipetteObjects,
		specifiedPipetteModels,allPipetteModels,instrumentObjectPackets,instrumentModelPackets,sampleObjectPackets,
		sampleModelPackets,cacheBall,specifiedInoculationPaperObjects,specifiedInoculationPaperModels,allInoculationPapersModels,
		specifiedPipetteTipsObjects,specifiedPipetteTipsModels,allPipetteTipsModels,inoculationPaperPackets,inoculationPaperModelPackets,
		pipetteTipsPackets,pipetteTipsModelPackets,pipettePackets,pipetteModelPackets,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,resourcePackets,resourcePacketTests,protocolObject
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedOperator,listedOptions}=removeLinks[ToList[myOperator],ToList[myOptions]];

	(* Make sure we're working with a list of options *)
	cacheOption=ToList[Lookup[listedOptions,Cache,{}]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentVapro5600Training,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentVapro5600Training,listedOptions,AutoCorrect->False],{}}
	];

	(*change all Names to objects *)
	{{operator},safeOps}=sanitizeInputs[listedOperator,safeOptionsNamed];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentVapro5600Training,{ToList[operator]},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentVapro5600Training,{ToList[operator]},listedOptions],Null}
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

	(* No options to expand *)
	expandedSafeOps=inheritedOptions;

	(* Create list of options that can take objects *)
	optionsWithObjects={Instrument,Sample,Pipette,InoculationPaper,Tweezers};

	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects=DeleteDuplicates[
		Cases[
			Flatten@Join[
				{operator},
				(* All options that could have an object *)
				Lookup[expandedSafeOps,optionsWithObjects]
			],
			ObjectP[]
		]
	];

	(* Check that the specified objects exist or are visible to the current user *)
	objectsExistQs=DatabaseMemberQ[
		userSpecifiedObjects
	];

	(* Build tests for object existence *)
	objectsExistTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[!MemberQ[objectsExistQs,False],
				Nothing,
				Test["The specified objects "<>ToString[PickList[userSpecifiedObjects,objectsExistQs,False]]<>" exist in the database:",True,False]
			];

			passingTest=If[!MemberQ[objectsExistQs,True],
				Nothing,
				Test["The specified objects "<>ToString[PickList[userSpecifiedObjects,objectsExistQs,True]]<>" exist in the database:",True,True]
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs),
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist,PickList[userSpecifiedObjects,objectsExistQs,False]];
			Message[Error::InvalidInput,PickList[userSpecifiedObjects,objectsExistQs,False]]
		];
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,objectsExistTests],
			Options->$Failed,
			Preview->Null
		}]
	];


	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Any options whose values could be an object *)

	(* Perform a big search *)
	{
		osmometerInstrumentModels,
		inoculationPapersList,
		pipettesList,
		tweezersList,
		tipsList
	}=Search[
		{
			{Model[Instrument,Osmometer]},
			{Model[Item,InoculationPaper]},
			{Model[Instrument,Pipette]},
			{Model[Item,Tweezer],Object[Item,Tweezer]},
			{Model[Item,Tips]}
		}
	];

	(* Get specified osmometer object/model *)
	specifiedInstrumentObjects=Cases[{Lookup[expandedSafeOps,Instrument]},ObjectP[Object[Instrument,Osmometer]]];
	specifiedInstrumentModels=Cases[{Lookup[expandedSafeOps,Instrument]},ObjectP[Model[Instrument,Osmometer]]];

	allInstrumentModels=If[MatchQ[specifiedInstrumentModels,{}]&&MatchQ[specifiedInstrumentObjects,{}],osmometerInstrumentModels,specifiedInstrumentModels];

	(* Same for pipettes *)
	specifiedPipetteObjects=Cases[{Lookup[expandedSafeOps,Pipette]},ObjectP[Object[Instrument,Pipette]]];
	specifiedPipetteModels=Cases[{Lookup[expandedSafeOps,Pipette]},ObjectP[Model[Instrument,Pipette]]];

	allPipetteModels=If[MatchQ[specifiedPipetteModels,{}]&&MatchQ[specifiedPipetteObjects,{}],pipettesList,specifiedPipetteModels];

	(* Same for pipette tips *)
	specifiedPipetteTipsObjects=Cases[{Lookup[expandedSafeOps,PipetteTips]},ObjectP[Object[Instrument,PipetteTips]]];
	specifiedPipetteTipsModels=Cases[{Lookup[expandedSafeOps,PipetteTips]},ObjectP[Model[Instrument,PipetteTips]]];

	allPipetteTipsModels=If[MatchQ[specifiedPipetteTipsModels,{}]&&MatchQ[specifiedPipetteTipsObjects,{}],tipsList,specifiedPipetteTipsModels];

	(* Get specified calibrants object/model *)
	specifiedSampleObjects=Cases[ToList@Lookup[expandedSafeOps,Sample],ObjectP[Object[Sample]]];
	specifiedSampleModels=Cases[ToList@Lookup[expandedSafeOps,Sample],ObjectP[Model[Sample]]];

	(* Get all osmolality standards in SLL *)
	osmolalityStandardsList={
		Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],
		Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"],
		Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]
	};

	allStandardsModels=DeleteDuplicates[Join[specifiedSampleModels,osmolalityStandardsList]];

	(* Inoculation papers *)
	specifiedInoculationPaperObjects=Cases[{Lookup[expandedSafeOps,InoculationPaper]},ObjectP[Object[Instrument,InoculationPaper]]];
	specifiedInoculationPaperModels=Cases[{Lookup[expandedSafeOps,InoculationPaper]},ObjectP[Model[Instrument,InoculationPaper]]];

	allInoculationPapersModels=If[MatchQ[specifiedInoculationPaperModels,{}]&&MatchQ[specifiedInoculationPaperObjects,{}],inoculationPapersList,specifiedInoculationPaperModels];

	(* Download the required fields from our objects *)


	allPackets={
		instrumentObjectPackets,
		instrumentModelPackets,
		sampleObjectPackets,
		sampleModelPackets,
		inoculationPaperPackets,
		inoculationPaperModelPackets,
		pipetteTipsPackets,
		pipetteTipsModelPackets,
		pipettePackets,
		pipetteModelPackets
	}=Quiet[
		Download[
			{
				specifiedInstrumentObjects,
				allInstrumentModels,
				specifiedSampleObjects,
				allStandardsModels,
				specifiedInoculationPaperObjects,
				allInoculationPapersModels,
				specifiedPipetteTipsObjects,
				allPipetteTipsModels,
				specifiedPipetteObjects,
				allPipetteModels
			},
			{
				(* Download from instrument objects *)
				{
					Packet[Model],
					Packet[Model[{Name,MinOsmolality,MaxOsmolality,MinSampleVolume,MaxSampleVolume,EquilibrationTime,CustomCalibrants,ManufacturerCalibrants,ManufacturerCalibrantOsmolalities,CustomCleaningSolution,ManufacturerCleaningSolution,WettedMaterials,MeasurementTime,ManufacturerOsmolalityRepeatability}]]
				},

				(* Download from instrument models *)
				{
					Packet[Name,MinOsmolality,MaxOsmolality,MinSampleVolume,MaxSampleVolume,EquilibrationTime,CustomCalibrants,ManufacturerCalibrants,ManufacturerCalibrantOsmolalities,CustomCleaningSolution,ManufacturerCleaningSolution,WettedMaterials,MeasurementTime,ManufacturerOsmolalityRepeatability]
				},

				(* Download from sample objects *)
				{
					Packet[Model,Container,Status],
					Packet[Model[{Object,Name,Composition,IncompatibleMaterials,Solvent,State,Density}]]
				},

				(* Download from standards models *)
				{
					Packet[Object,Name,Composition,IncompatibleMaterials,Solvent,State,Density]
				},

				(* Download from potential inoculation paper objects *)
				{
					Packet[Model],
					Packet[Model[{Object,Name,Shape,Diameter,PaperThickness}]]
				},

				(* Download from potential inoculation papers *)
				{
					Packet[Object,Name,Shape,Diameter,PaperThickness]
				},

				(* Download all pipette tips *)
				{
					Packet[Model[{TipConnectionType,Resolution}]]
				},

				{
					Packet[TipConnectionType,Resolution]
				},

				{
					Packet[Model],
					Packet[Model[{TipConnectionType,MinVolume,MaxVolume,CultureHandling,Resolution}]]
				},

				(* Download all pipettes *)
				{
					Packet[TipConnectionType,MinVolume,MaxVolume,CultureHandling,Resolution]
				}
			},
			Cache->Flatten[{cacheOption}],
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField,Download::MissingCacheField}
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

	cacheBall=FlattenCachePackets[allPackets];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentVapro5600TrainingOptions[operator,expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentVapro5600TrainingOptions[operator,expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,objectsExistTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentVapro5600Training,resolvedOptions],
			Preview->Null
		}]
	];


	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		experimentVapro5600TrainingResourcePackets[operator,expandedSafeOps,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{experimentVapro5600TrainingResourcePackets[operator,expandedSafeOps,resolvedOptions,Cache->cacheBall],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,templateTests,objectsExistTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentVapro5600Training,resolvedOptions],
			Preview->Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject=If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,Vapro5600Training],
			Cache->cacheBall
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,templateTests,objectsExistTests,resolvedOptionsTests,resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentVapro5600Training,resolvedOptions],
		Preview->Null
	}
];

DefineOptions[
	resolveExperimentVapro5600TrainingOptions,
	Options:>{HelperOutputOption,CacheOption}
];

resolveExperimentVapro5600TrainingOptions[myOperator:ObjectP[Object[User,Emerald]],myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentVapro5600TrainingOptions]]:=Module[
	{
		outputSpecification,output,gatherTests,cache,vapro5600TrainingOptionsAssociation,
		instrument,sample,sampleVolume,repeatability,repeatabilityNumberOfMeasurements,maxNumberOfMeasurements,pipette,
		pipetteTips,inoculationPaper,tweezers,osmometerInstrumentModels,inoculationPapersList,pipettesList,tweezersList,
		tipsList,specifiedInstrumentObjects,specifiedInstrumentModels,allInstrumentModels,specifiedPipetteObjects,name,
		specifiedPipetteModels,allPipetteModels,specifiedPipetteTipsObjects,specifiedPipetteTipsModels,allPipetteTipsModels,
		specifiedSampleObjects,specifiedSampleModels,osmolalityStandardsList,allStandardsModels,specifiedInoculationPaperObjects,
		specifiedInoculationPaperModels,allInoculationPapersModels,allPackets,instrumentObjectPackets,instrumentModelPackets,
		sampleObjectPackets,sampleModelPackets,inoculationPaperPackets,inoculationPaperModelPackets,pipetteTipsPackets,
		pipetteTipsModelPackets,pipettePackets,pipetteModelPackets,instrumentModelPacket,instrumentModel,instrumentRepeatability,
		discardedSamplePackets,discardedInvalidInputs,discardedTest,containerlessSamplePackets,containerlessInvalidInputs,
		containerlessTest,optionsChecks,optionsPrecisions,roundedExperimentOptions,precisionTests,roundedExperimentOptionsList,
		allOptionsRounded,allOptionsPrecisionTests,validNameQ,nameInvalidOption,validNameTest,lowSampleVolumeWarningConflictOptions,
		lowSampleVolumeWarningOptions,lowSampleVolumeWarningTest,instrumentObjectPacket,resolvedInstrument,
		instrumentCompatibilityErrorConflictOptions,instrumentCompatibilityErrorOptions,instrumentCompatibilityErrorTest,
		resolvedSample,sampleCompatibilityErrorConflictOptions,sampleCompatibilityErrorOptions,sampleCompatibilityErrorTest,
		resolvedRepeatability,repeatabilityWarningConflictOptions,repeatabilityWarningOptions,resolvedRepeatabilityNumberOfMeasurements,
		resolvedMaxNumberOfMeasurements,maxNumberOfMeasurementsCompatibilityErrorConflictOptions,maxNumberOfMeasurementsCompatibilityErrorOptions,
		maxNumberOfMeasurementsCompatibilityErrorTest,resolvedPipette,resolvedInoculationPaper,resolvedTweezers,
		emailOption,uploadOption,nameOption,confirmOption,parentProtocolOption,fastTrackOption,templateOption,operator,
		invalidOptions,allTests,resolvedEmail,resolvedOptions,discardedInvalidOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	vapro5600TrainingOptionsAssociation=Association[myOptions];

	(* Set options variables *)
	{
		instrument,sample,repeatability,repeatabilityNumberOfMeasurements,maxNumberOfMeasurements,
		pipette,pipetteTips,inoculationPaper,tweezers,name
	}=Lookup[vapro5600TrainingOptionsAssociation,
		{
			Instrument,Sample,Repeatability,RepeatabilityNumberOfMeasurements,MaxNumberOfMeasurements,
			Pipette,PipetteTips,InoculationPaper,Tweezers,Name
		}
	];

	(* Any options whose values could be an object *)

	(* Perform a big search *)
	{
		osmometerInstrumentModels,
		inoculationPapersList,
		pipettesList,
		tweezersList,
		tipsList
	}=Search[
		{
			{Model[Instrument,Osmometer]},
			{Model[Item,InoculationPaper]},
			{Model[Instrument,Pipette]},
			{Model[Item,Tweezer],Object[Item,Tweezer]},
			{Model[Item,Tips]}
		}
	];

	(* Get specified osmometer object/model *)
	specifiedInstrumentObjects=Cases[{Lookup[vapro5600TrainingOptionsAssociation,Instrument]},ObjectP[Object[Instrument,Osmometer]]];
	specifiedInstrumentModels=Cases[{Lookup[vapro5600TrainingOptionsAssociation,Instrument]},ObjectP[Model[Instrument,Osmometer]]];

	allInstrumentModels=If[MatchQ[specifiedInstrumentModels,{}]&&MatchQ[specifiedInstrumentObjects,{}],osmometerInstrumentModels,specifiedInstrumentModels];

	(* Same for pipettes *)
	specifiedPipetteObjects=Cases[{Lookup[vapro5600TrainingOptionsAssociation,Pipette]},ObjectP[Object[Instrument,Pipette]]];
	specifiedPipetteModels=Cases[{Lookup[vapro5600TrainingOptionsAssociation,Pipette]},ObjectP[Model[Instrument,Pipette]]];

	allPipetteModels=If[MatchQ[specifiedPipetteModels,{}]&&MatchQ[specifiedPipetteObjects,{}],pipettesList,specifiedPipetteModels];

	(* Same for pipette tips *)
	specifiedPipetteTipsObjects=Cases[{Lookup[vapro5600TrainingOptionsAssociation,PipetteTips]},ObjectP[Object[Instrument,PipetteTips]]];
	specifiedPipetteTipsModels=Cases[{Lookup[vapro5600TrainingOptionsAssociation,PipetteTips]},ObjectP[Model[Instrument,PipetteTips]]];

	allPipetteTipsModels=If[MatchQ[specifiedPipetteTipsModels,{}]&&MatchQ[specifiedPipetteTipsObjects,{}],tipsList,specifiedPipetteTipsModels];

	(* Get specified calibrants object/model *)
	specifiedSampleObjects=Cases[ToList@Lookup[vapro5600TrainingOptionsAssociation,Sample],ObjectP[Object[Sample]]];
	specifiedSampleModels=Cases[ToList@Lookup[vapro5600TrainingOptionsAssociation,Sample],ObjectP[Model[Sample]]];

	(* Get all osmolality standards in SLL *)
	osmolalityStandardsList={
		Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],
		Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"],
		Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]
	};

	allStandardsModels=DeleteDuplicates[Join[specifiedSampleModels,osmolalityStandardsList]];

	(* Inoculation papers *)
	specifiedInoculationPaperObjects=Cases[{Lookup[vapro5600TrainingOptionsAssociation,InoculationPaper]},ObjectP[Object[Instrument,InoculationPaper]]];
	specifiedInoculationPaperModels=Cases[{Lookup[vapro5600TrainingOptionsAssociation,InoculationPaper]},ObjectP[Model[Instrument,InoculationPaper]]];

	allInoculationPapersModels=If[MatchQ[specifiedInoculationPaperModels,{}]&&MatchQ[specifiedInoculationPaperObjects,{}],inoculationPapersList,specifiedInoculationPaperModels];

	(* Download the required fields from our objects *)


	allPackets={
		instrumentObjectPackets,
		instrumentModelPackets,
		sampleObjectPackets,
		sampleModelPackets,
		inoculationPaperPackets,
		inoculationPaperModelPackets,
		pipetteTipsPackets,
		pipetteTipsModelPackets,
		pipettePackets,
		pipetteModelPackets
	}=Quiet[
		Download[
			{
				specifiedInstrumentObjects,
				allInstrumentModels,
				specifiedSampleObjects,
				allStandardsModels,
				specifiedInoculationPaperObjects,
				allInoculationPapersModels,
				specifiedPipetteTipsObjects,
				allPipetteTipsModels,
				specifiedPipetteObjects,
				allPipetteModels
			},
			{
				(* Download from instrument objects *)
				{
					Packet[Model],
					Packet[Model[{Name,MinOsmolality,MaxOsmolality,MinSampleVolume,MaxSampleVolume,EquilibrationTime,CustomCalibrants,ManufacturerCalibrants,ManufacturerCalibrantOsmolalities,CustomCleaningSolution,ManufacturerCleaningSolution,WettedMaterials,MeasurementTime,ManufacturerOsmolalityRepeatability}]]
				},

				(* Download from instrument models *)
				{
					Packet[Name,MinOsmolality,MaxOsmolality,MinSampleVolume,MaxSampleVolume,EquilibrationTime,CustomCalibrants,ManufacturerCalibrants,ManufacturerCalibrantOsmolalities,CustomCleaningSolution,ManufacturerCleaningSolution,WettedMaterials,MeasurementTime,ManufacturerOsmolalityRepeatability]
				},

				(* Download from sample objects *)
				{
					Packet[Model,Container,Status],
					Packet[Model[{Object,Name,Composition,IncompatibleMaterials,Solvent,State,Density}]]
				},

				(* Download from standards models *)
				{
					Packet[Object,Name,Composition,IncompatibleMaterials,Solvent,State,Density]
				},

				(* Download from potential inoculation paper objects *)
				{
					Packet[Model],
					Packet[Model[{Object,Name,Shape,Diameter,PaperThickness}]]
				},

				(* Download from potential inoculation papers *)
				{
					Packet[Object,Name,Shape,Diameter,PaperThickness]
				},

				(* Download all pipette tips *)
				{
					Packet[Model[{TipConnectionType,Resolution}]]
				},

				{
					Packet[TipConnectionType,Resolution]
				},

				{
					Packet[Model],
					Packet[Model[{TipConnectionType,MinVolume,MaxVolume,CultureHandling,Resolution}]]
				},

				(* Download all pipettes *)
				{
					Packet[TipConnectionType,MinVolume,MaxVolume,CultureHandling,Resolution]
				}
			},
			Cache->cache,
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* -- Instrument packet --*)
	(* - Find the Model of the instrument, if it was specified - *)
	{instrumentModelPacket,instrumentObjectPacket}=If[MatchQ[instrumentObjectPackets,{}],
		{instrumentModelPackets[[1,1]],Null},
		{instrumentObjectPackets[[1,2]],instrumentObjectPackets[[1,1]]}
	];

	(* Lookup instrument model variables *)
	{instrumentModel,instrumentRepeatability}=Lookup[instrumentModelPacket,{Object,ManufacturerOsmolalityRepeatability},Null];

	(*-- INPUT VALIDATION CHECKS --*)

	(* Check that none of the samples are discarded *)

	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[{sampleObjectPackets}],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=Lookup[discardedSamplePackets,Object,{}];

	discardedInvalidOptions=If[Length[discardedInvalidInputs]==0,Nothing,Sample];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->cache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["The Sample "<>ObjectToString[sample,Cache->cache]<>" is not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==1,
				Nothing,
				Test["The Sample "<>ObjectToString[sample,Cache->cache]<>" is not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Check that all samples are in a container *)

	(* Get the samples from mySamples that are not in a container *)
	containerlessSamplePackets=Cases[Flatten[{sampleObjectPackets}],KeyValuePattern[Container->Null]];

	(* Set containerlessInvalidInputs to the input objects who have no container *)
	containerlessInvalidInputs=Lookup[containerlessSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[containerlessInvalidInputs]>0&&!gatherTests,
		Message[Error::ContainerlessSamples,ObjectToString[containerlessInvalidInputs,Cache->cache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	containerlessTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[containerlessInvalidInputs]==0,
				Nothing,
				Test["The Sample "<>ObjectToString[sample,Cache->cache]<>" is located in a container:",True,False]
			];

			passingTest=If[Length[containerlessInvalidInputs]==1,
				Nothing,
				Test["The Sample "<>ObjectToString[sample,Cache->cache]<>" is located in a container:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	(* Round the sample volume *)
	optionsChecks={
		(*1*)SampleVolume
	};

	optionsPrecisions={
		(*1*)10^-7 Liter
	};

	(* Round the options *)
	{roundedExperimentOptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[vapro5600TrainingOptionsAssociation,optionsChecks,optionsPrecisions,Output->{Result,Tests}],
		{RoundOptionPrecision[vapro5600TrainingOptionsAssociation,optionsChecks,optionsPrecisions],Null}
	];

	(* Convert association of rounded options to a list of rules *)
	roundedExperimentOptionsList=Normal[roundedExperimentOptions];

	(* Replace the raw options with rounded values in full set of options, myOptions *)
	allOptionsRounded=ReplaceRule[
		myOptions,
		roundedExperimentOptionsList,
		Append->False
	];

	(* Gather tests *)
	allOptionsPrecisionTests=precisionTests;

	(* Get some variables *)
	{sampleVolume}=Lookup[allOptionsRounded,{SampleVolume}];

	(*-- CONFLICTING OPTIONS CHECKS --*)
	validNameQ=If[MatchQ[name,_String],

		(* If the name was specified, make sure it's not a duplicate name *)
		Not[DatabaseMemberQ[Object[Protocol,Vapro5600Training,name]]],

		(* Otherwise, its all good *)
		True
	];

	(* If validNameQ is False and we are throwing messages, then throw the message and make nameInvalidOptions={Name}; otherwise, {} is fine *)
	nameInvalidOption=If[!validNameQ&&!gatherTests,
		(
			Message[Error::DuplicateName,"MeasureOsmolality protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already a Vapro5600Training protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* Check that all sample volumes are sufficient for an accurate measurement by the instrument *)
	lowSampleVolumeWarningConflictOptions=Cases[ToList[sampleVolume],LessP[Lookup[instrumentModelPacket,MinSampleVolume]]];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	lowSampleVolumeWarningOptions=If[Length[lowSampleVolumeWarningConflictOptions]>0,
		(* Store the errant options for later InvalidOption checks *)
		{SampleVolume,Instrument},
		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[Length[lowSampleVolumeWarningConflictOptions]>0&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::Vapro5600LowSampleVolume,lowSampleVolumeWarningConflictOptions,ObjectToString[instrument,Cache->cache],First[Lookup[instrumentModelPacket,MinSampleVolume]]]
	];

	(* Build a test for whether the sample volumes are above the minimum recommended for the instrument *)
	lowSampleVolumeWarningTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[lowSampleVolumeWarningConflictOptions]==0,
				Nothing,
				Test["The provided values for SampleVolume and Instrument are not in conflict with each other:",
					True,
					False
				]
			];

			passingTest=If[Length[lowSampleVolumeWarningConflictOptions]!=0,
				Nothing,
				Test["The provided values for SampleVolume and Instrument are not in conflict with each other:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Instrument*)
	(* Supplied or defaulted. Verify that any objects supplied are Vapro 5600s *)
	{resolvedInstrument,instrumentCompatibilityErrorConflictOptions}=Which[
		(* If we didn't specify an Object[Instrument], return the Vapro 5600 model *)
		!MatchQ[instrument,ObjectP[Object]],
		{instrumentModel,Null},

		(* If we supplied the Object[Instrument] and its model is the Vapro 5600, we're good *)
		MatchQ[Lookup[instrumentObjectPacket,Model],ObjectP[Model[Instrument,Osmometer,"Vapro 5600"]]],
		{Download[Lookup[instrumentObjectPacket,Object],Object],Null},

		(* Otherwise, we've got an Object[Instrument] specified with the wrong model, so throw an error *)
		True,
		{Null,Download[Lookup[instrumentObjectPacket,Model],Object]}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	instrumentCompatibilityErrorOptions=If[!NullQ[instrumentCompatibilityErrorConflictOptions],
		(* Store the errant options for later InvalidOption checks *)
		{Instrument},
		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[!NullQ[instrumentCompatibilityErrorConflictOptions]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Error::Vapro5600InstrumentIncompatible,instrumentCompatibilityErrorConflictOptions]
	];

	(* Build a test for whether the sample volumes are above the minimum recommended for the instrument *)
	instrumentCompatibilityErrorTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[instrumentCompatibilityErrorConflictOptions]==0,
				Nothing,
				Test["The provided Instrument is a compatible Vapro 5600:",
					True,
					False
				]
			];

			passingTest=If[Length[instrumentCompatibilityErrorConflictOptions]!=0,
				Nothing,
				Test["The provided instrument is a compatible Vapro 5600:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Sample *)
	{resolvedSample,sampleCompatibilityErrorConflictOptions}=Which[
		(* If option is automatic, resolve to 290 mmol/kg standard *)
		MatchQ[sample,Automatic],
		{Model[Sample,"id:D8KAEvGLvEAR"],{}},

		(* If specified standard was a valid model standard, use it *)
		MatchQ[sample,ObjectP[osmolalityStandardsList]],
		{sample,{}},

		(* If specified standard was an object with a valid model, use it *)
		MatchQ[sample,ObjectP[Object]]&&MatchQ[Lookup[sampleObjectPackets[[1,1]],Model],ObjectP[osmolalityStandardsList]],
		{sample,{}},

		(* Otherwise, throw an error with an object *)
		MatchQ[sample,ObjectP[Object]],
		{sample,Lookup[sampleObjectPackets[[1,1]],Model]/.{link_Link:>Download[link,Object]}},

		(* Or with a model *)
		True,
		{sample,sample}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	sampleCompatibilityErrorOptions=If[!MatchQ[sampleCompatibilityErrorConflictOptions,{}],
		(* Store the errant options for later InvalidOption checks *)
		{Sample},
		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[!MatchQ[sampleCompatibilityErrorConflictOptions,{}]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Error::Vapro5600SampleIncompatible,sample,sampleCompatibilityErrorConflictOptions,ObjectToString[osmolalityStandardsList,Cache->cache]]
	];

	(* Build a test for whether the sample volumes are above the minimum recommended for the sample *)
	sampleCompatibilityErrorTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[sampleCompatibilityErrorConflictOptions]==0,
				Nothing,
				Test["The provided Sample is supported for Vapro 5600 training:",
					True,
					False
				]
			];

			passingTest=If[Length[sampleCompatibilityErrorConflictOptions]!=0,
				Nothing,
				Test["The provided sample is supported for Vapro 5600 training:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* Repeatability *)
	instrumentRepeatability=Lookup[instrumentModelPacket,ManufacturerOsmolalityRepeatability];

	{resolvedRepeatability,repeatabilityWarningConflictOptions}=Which[
		(* If option is automatic, resolve to the instrument repeatability *)
		MatchQ[repeatability,Automatic],
		{instrumentRepeatability,Null},

		(* If specified repeatability is less than the instrument repeatability, throw a warning *)
		LessQ[repeatability,instrumentRepeatability],
		{repeatability,repeatability},

		(* Otherwise, we're good *)
		True,
		{repeatability,Null}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Warning::InvalidOptions. *)
	repeatabilityWarningOptions=If[!NullQ[repeatabilityWarningConflictOptions],
		(* Store the errant options for later InvalidOption checks *)
		{Repeatability},
		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[!NullQ[repeatabilityWarningConflictOptions]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::Vapro5600Repeatability,repeatability,instrumentRepeatability]
	];


	(* Repeatability number of measurements *)
	resolvedRepeatabilityNumberOfMeasurements=repeatabilityNumberOfMeasurements;
	
	
	(* MaxNumberOfMeasurements *)
	{resolvedMaxNumberOfMeasurements,maxNumberOfMeasurementsCompatibilityErrorConflictOptions}=Which[
		(* If option is automatic, resolve to 3x the repeatability number of measurements *)
		MatchQ[maxNumberOfMeasurements,Automatic],
		{3*resolvedRepeatabilityNumberOfMeasurements,Null},

		(* If the specified number is less than repeatability number of measurements, throw an error *)
		LessQ[maxNumberOfMeasurements,resolvedRepeatabilityNumberOfMeasurements],
		{maxNumberOfMeasurements,maxNumberOfMeasurements},

		(* Otherwise, we're good *)
		True,
		{maxNumberOfMeasurements,Null}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	maxNumberOfMeasurementsCompatibilityErrorOptions=If[!NullQ[maxNumberOfMeasurementsCompatibilityErrorConflictOptions],
		(* Store the errant options for later InvalidOption checks *)
		{MaxNumberOfMeasurements},
		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[!NullQ[maxNumberOfMeasurementsCompatibilityErrorConflictOptions]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Error::Vapro5600MaxNumberOfMeasurementsIncompatible,maxNumberOfMeasurements,resolvedRepeatabilityNumberOfMeasurements]
	];

	(* Build a test for whether the maxNumberOfMeasurements volumes are above the minimum recommended for the maxNumberOfMeasurements *)
	maxNumberOfMeasurementsCompatibilityErrorTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[maxNumberOfMeasurementsCompatibilityErrorConflictOptions]==0,
				Nothing,
				Test["The provided MaxNumberOfMeasurements is less than the RepeatabilityNumberOfMeasurements:",
					True,
					False
				]
			];

			passingTest=If[Length[maxNumberOfMeasurementsCompatibilityErrorConflictOptions]!=0,
				Nothing,
				Test["The provided MaxNumberOfMeasurements is less than the RepeatabilityNumberOfMeasurements:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* Pipette *)
	resolvedPipette=pipette/.Automatic->Model[Instrument,Pipette,"id:lYq9jRxYbBVX"];


	(* Inoculation paper *)
	resolvedInoculationPaper=inoculationPaper/.Automatic->Model[Item,InoculationPaper,"id:bq9LA0JqY0zb"];


	(* Tweezers *)
	resolvedTweezers=tweezers/.Automatic->Model[Item,Tweezer,"id:bq9LA0JqYMez"];


	(* Pull out Miscellaneous options *)
	{
		emailOption,uploadOption,nameOption,confirmOption,parentProtocolOption,fastTrackOption,templateOption,operator
	}=Lookup[allOptionsRounded,
		{
			Email,Upload,Name,Confirm,ParentProtocol,FastTrack,Template,Operator
		}
	];

	(* We've limited the sample, so don't need to check for compatibility *)

	(* No incompatible sample inputs *)

	(*-- UNRESOLVABLE OPTION CHECKS --*)
	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidOptions=DeleteDuplicates[Flatten[{discardedInvalidOptions,nameInvalidOption,instrumentCompatibilityErrorOptions,
		sampleCompatibilityErrorOptions,maxNumberOfMeasurementsCompatibilityErrorOptions}]];

	allTests=Flatten[{
		discardedTest,containerlessTest,allOptionsPrecisionTests,validNameTest,lowSampleVolumeWarningTest,instrumentCompatibilityErrorTest,
		sampleCompatibilityErrorTest,maxNumberOfMeasurementsCompatibilityErrorTest
	}];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* Resolve Email option *)
	resolvedEmail=If[!MatchQ[emailOption,Automatic],
		(* If Email is specified, use the supplied value *)
		emailOption,
		(* Otherwise, default to False *)
		False
	];

	(* All resolved options *)
	resolvedOptions=ReplaceRule[
		allOptionsRounded,
		{
			Instrument->resolvedInstrument,
			Sample->resolvedSample,
			SampleVolume->sampleVolume,
			Repeatability->resolvedRepeatability,
			RepeatabilityNumberOfMeasurements->resolvedRepeatabilityNumberOfMeasurements,
			MaxNumberOfMeasurements->resolvedMaxNumberOfMeasurements,
			Pipette->resolvedPipette,
			InoculationPaper->resolvedInoculationPaper,
			Tweezers->resolvedTweezers,
			Confirm->confirmOption,
			Name->name,
			Template->templateOption,
			Cache->cache,
			Email->resolvedEmail,
			FastTrack->fastTrackOption,
			Operator->operator,
			ParentProtocol->parentProtocolOption,
			Upload->uploadOption
		},
		Append->False
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result->resolvedOptions,
		Tests->allTests
	}

];


(* ::Subsubsection:: *)
(*vapro5600TrainingResourcePackets*)


DefineOptions[
	experimentVapro5600TrainingResourcePackets,
	Options:>{OutputOption,CacheOption}
];


experimentVapro5600TrainingResourcePackets[myOperator:ObjectP[Object[User,Emerald]],myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
	{
		resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,operatorWithoutLinks,
		instrument,sample,sampleVolume,repeatability,repeatabilityNumberOfMeasurements,maxNumberOfMeasurements,
		pipette,inoculationPaper,tweezers,tipModelPackets,pipetteModelPackets,instrumentModelPackets,allPackets,
		instrumentFields,pipetteFields,pipetteModelPacket,instrumentModelPacket,totalSampleVolume,sampleResource,
		pipetteResource,protocolTime,pipetteTips,pipetteTipsResource,inoculationPaperResource,tweezerResource,
		protocolPacket,instrumentResource,allResourceBlobs,fulfillable,frqTests,previewRule,optionsRule,testsRule,
		resultRule
	},

	resolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentVapro5600Training,myResolvedOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache=Lookup[ToList[ops],Cache];

	(* Get rid of link around operator *)
	operatorWithoutLinks=myOperator/.{link_Link:>Download[link,Object]};

	(* Options Lookup *)
	{
		instrument,sample,sampleVolume,repeatability,repeatabilityNumberOfMeasurements,maxNumberOfMeasurements,
		pipette,inoculationPaper,tweezers
	}=Lookup[resolvedOptionsNoHidden,
		{
			Instrument,Sample,SampleVolume,Repeatability,RepeatabilityNumberOfMeasurements,MaxNumberOfMeasurements,
			Pipette,InoculationPaper,Tweezers
		}
	];

	instrumentFields=If[MatchQ[instrument,ObjectP[Object]],
		Packet[Model[{MeasurementTime}]],
		Packet[MeasurementTime]
	];

	pipetteFields=If[MatchQ[pipette,ObjectP[Object]],
		Packet[Model[{TipConnectionType,MinVolume,MaxVolume,CultureHandling,Resolution}]],
		Packet[TipConnectionType,MinVolume,MaxVolume,CultureHandling,Resolution]
	];

	(* --- Make our one big Download call --- *)
	allPackets={
		tipModelPackets,
		pipetteModelPackets,
		instrumentModelPackets
	}=Quiet[Download[
		{
			Search[Model[Item,Tips]],
			{pipette},
			{instrument}
		},
		{
			{
				Packet[TipConnectionType,Resolution]
			},
			{
				pipetteFields
			},
			{
				instrumentFields
			}
		},
		Cache->inheritedCache,
		Date->Now
	],
		Download::FieldDoesntExist
	];

	pipetteModelPacket=pipetteModelPackets[[1,1]];
	instrumentModelPacket=instrumentModelPackets[[1,1]];

	(* -- Generate resource for the sample -- *)
	totalSampleVolume=maxNumberOfMeasurements*sampleVolume;

	(* Round up the volume to the nearest 400 microliter to ensure that a fresh vial of standard if picked by the training protocol *)
	(* (Ensures that it doesn't poach the calibrant or control from the parent Object[Protocol,MeasureOsmolality]) *)
	sampleResource=Resource[
		Sample->sample,
		Amount->Ceiling[totalSampleVolume,400 Microliter]
	];

	(* Estimate protocol time *)
	protocolTime=(Lookup[instrumentModelPacket,MeasurementTime]+5 Minute)*maxNumberOfMeasurements;

	(* Instrument resource *)
	instrumentResource=Resource[
		Instrument->instrument,
		Time->protocolTime
	];


	(* Pipette resource *)
	pipetteResource=Resource[
		Instrument->pipette,
		Time->protocolTime
	];

	(* Choose some tips *)
	pipetteTips=FirstOrDefault[FirstOrDefault[TransferDevices[Model[Item,Tips],10 Microliter]]];

	(* Tips resource *)
	pipetteTipsResource=Resource[
		Sample->pipetteTips,
		Amount->maxNumberOfMeasurements,
		UpdateCount->False
	];

	(* Inoculation paper resource *)
	inoculationPaperResource=Resource[
		Sample->inoculationPaper,
		Amount->maxNumberOfMeasurements
	];

	(* Tweezer resource *)
	tweezerResource=Resource[
		Sample->tweezers,
		Rent->True
	];

	(* Generate the protocol packet *)
	protocolPacket=<|
		Type->Object[Protocol,Vapro5600Training],
		Object->CreateID[Object[Protocol,Vapro5600Training]],
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->myResolvedOptions,
		Instrument->Link[instrumentResource],
		Sample->Link[sampleResource],
		SampleVolume->sampleVolume,
		Repeatability->repeatability,
		RepeatabilityNumberOfMeasurements->repeatabilityNumberOfMeasurements,
		MaxNumberOfMeasurements->maxNumberOfMeasurements,
		AttemptNumber->1,
		Pipette->Link[pipetteResource],
		PipetteTips->Link[pipetteTipsResource],
		InoculationPapers->Link[inoculationPaperResource],
		Tweezers->Link[tweezerResource],

		Replace[Checkpoints]->{
			{"Picking Resources",10 Minute,"Samples, solutions and equipment required to execute this protocol are gathered from storage.",Link[Resource[Operator->myOperator,Time->15 Minute]]},
			{"Vapro 5600 Training",protocolTime,"Perform measurements with the Vapro 5600.",Link[Resource[Operator->myOperator,Time->protocolTime]]},
			{"Returning Materials",10 Minute,"Samples are returned to storage.",Link[Resource[Operator->myOperator,Time->10 Minute]]}
		}
	|>;

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache],Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule=Preview->Null;

	(* Generate the options output rule *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
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

	(* return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];