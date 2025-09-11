(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentMeasureOsmolality*)

DefineOptions[ExperimentMeasureOsmolality,
	Options:>{
		{
			OptionName->OsmolalityMethod,
			Default->VaporPressureOsmometry,
			Description->"The experimental technique or principle used to determine the osmolality of the samples. VaporPressureOsmometry infers solution osmolality by measuring the depression in vapor pressure (or related property) of a solution compared to pure solvent.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>OsmolalityMethodP
			]
		},
		{
			OptionName->Instrument,
			Default->Model[Instrument,Osmometer,"Vapro 5600"],
			Description->"The instrument used to measure the osmolality of a sample.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,Osmometer],Object[Instrument,Osmometer]}],
				ObjectTypes->{Model[Instrument,Osmometer],Object[Instrument,Osmometer]}
			]
		},
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description->"The total number of times to perform osmolality measurement using a new aliquot of sample each time, for each provided sample. If multiple readings are required on the same loaded aliquot, use the NumberOfReadings option.",
			AllowNull->True,
			Category->"General",
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterEqualP[2,1]
			]
		},
		{
			OptionName->PreClean,
			Default->False,
			Description->"Indicates if the osmometer thermocouple is to undergo an additional clean prior to experiment, before calibration. The instrument thermocouple is always cleaned after experiment.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			]
		},
		{
			OptionName->CleaningSolution,
			Default->Automatic,
			Description->"The solution used to wash the thermocouple head to remove any debris.",
			ResolutionDescription->"Automatically set to the manufacturer recommended cleaning solution of the instrument.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[Model[Sample,"Milli-Q water"]],
				PreparedSample->False,
				PreparedContainer->False,
				ObjectTypes->{Model[Sample]}
			]
		},
		{
			OptionName->PostRunInstrumentContaminationLevel,
			Default->True,
			Description->"Measure the contamination level of the osmometer thermocouple after measurements from this protocol are complete, and prior to routine cleaning of the thermocouple.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			]
		},

		(*Calibration*)
		IndexMatching[
			IndexMatchingParent->Calibrant,
			{
				OptionName->Calibrant,
				Default->Automatic,
				Description->"The solutions of known osmolality used by the instrument to determine the conversion from raw measurement to osmolality, in the order they are to be used. Standard calibrants for an instrument are located in the ManufacturerCalibrants field of the instrument Model/Object and in the ExperimentMeasureOsmolality help file.",
				ResolutionDescription->"Automatically set to the manufacturer recommended calibrants of the instrument.",
				AllowNull->False,
				Category->"Calibration",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					PreparedSample->False,
					PreparedContainer->False,
					ObjectTypes->{Model[Sample],Object[Sample]}
				]
			},
			{
				OptionName->CalibrantOsmolality,
				Default->Automatic,
				Description->"The osmolalities of the solutions used by the instrument to determine the conversion from raw measurement to osmolality. Standard calibrants for an instrument are located in the ManufacturerCalibrants field of the instrument Model/Object and in the ExperimentMeasureOsmolality help file.",
				ResolutionDescription->"Automatically set to the osmolalities of the manufacturer recommended calibrants.",
				AllowNull->False,
				Category->"Calibration",
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0 Milli Mole/Kilogram],
					Units->CompoundUnit[{1,{Millimole,{Millimole}}},{-1,{Kilogram,{Kilogram}}}]
				]
			},
			{
				OptionName->CalibrantVolume,
				Default->10 Microliter,
				Description->"The volume of calibrants used by the instrument to determine the conversion from raw measurement to osmolality.",
				AllowNull->False,
				Category->"Calibration",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[10 Microliter,10 Microliter],
					Units->Microliter
				]
			}
		],

		IndexMatching[
			IndexMatchingParent->Control,
			{
				OptionName->Control,
				Default->Automatic,
				Description->"The solutions of known osmolality used to verify the instrument calibration.",
				ResolutionDescription->"Automatically set to the first used calibrant.",
				AllowNull->True,
				Category->"Calibration",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					PreparedSample->False,
					PreparedContainer->False,
					ObjectTypes->{Model[Sample],Object[Sample]}
				]
			},
			{
				OptionName->ControlOsmolality,
				Default->Automatic,
				Description->"The osmolalities of the solutions used to verify the instrument calibration.",
				ResolutionDescription->"Automatically set to the osmolalities of the manufacturer recommended calibrant, if used.",
				AllowNull->True,
				Category->"Calibration",
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0 Milli Mole/Kilogram],
					Units->CompoundUnit[{1,{Millimole,{Millimole}}},{-1,{Kilogram,{Kilogram}}}]
				]
			},
			{
				OptionName->ControlVolume,
				Default->Automatic,
				Description->"The volume of controls used by the instrument to verify the instrument calibration.",
				ResolutionDescription->"Resolves to 10 microliter if not specified.",
				AllowNull->True,
				Category->"Calibration",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter,11 Microliter],
					Units->Microliter
				]
			},
			{
				OptionName->ControlTolerance,
				Default->Automatic,
				Description->"The amount that the measured osmolality is permitted to deviate from the corresponding ControlOsmolality for calibration to be deemed successful.",
				ResolutionDescription->"Automatically set to two times the repeatability of the instrument, if the control was used for calibration. If not used for calibration, the manufacturing tolerance of the calibrants and control are added in quadrature to two times the repeatability of the instrument.",
				AllowNull->True,
				Category->"Calibration",
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0 Milli Mole/Kilogram],
					Units->CompoundUnit[{1,{Millimole,{Millimole}}},{-1,{Kilogram,{Kilogram}}}]
				]
			},
			{
				OptionName->NumberOfControlReplicates,
				Default->Automatic,
				Description->"The total number of measurements that will be taken for each of the controls specified, which are then averaged, before comparison of the average value with the ControlOsmolality. If multiple individual comparisons to the ControlOsmolality for the same standard are desired, please specify the same standard multiple times using the Control option.",
				ResolutionDescription->"Resolves to 1 per control, if controls are run in the protocol.",
				AllowNull->True,
				Category->"Calibration",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,5,1]
				]
			}
		],

		{
			OptionName->MaxNumberOfCalibrations,
			Default->Automatic,
			Description->"The maximum number of times that calibration should be attempted to achieve a calibration where the measured osmolalities for all the Controls are within their respective ControlTolerance.",
			ResolutionDescription->"Resolves to 3 if a control is specified, otherwise 1.",
			AllowNull->False,
			Category->"Calibration",
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,5,1]
			]
		},

		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->ViscousLoading,
				Default->Automatic,
				Description->"Indicates if the sample is too resistant to flow for standard transfer and loading techniques.",
				ResolutionDescription->"Automatically set to True for highly viscous samples exceeding the threshold of 200 mPa s viscosity, otherwise set to False.",
				AllowNull->False,
				Category->"Sample Loading",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				]
			},
			{
				OptionName->InoculationPaper,
				Default->Automatic,
				Description->"The paper that is saturated with sample solution on sample loading, and holds the sample during measurement.",
				ResolutionDescription->"Automatically set to inoculation paper compatible with the specified instrument, unless viscousLoading resolves to True, where it is set to Null.",
				AllowNull->True,
				Category->"Sample Loading",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Item,InoculationPaper],Object[Item,InoculationPaper]}],
					ObjectTypes->{Model[Item,InoculationPaper],Object[Item,InoculationPaper]}
				]
			},
			{
				OptionName->SampleVolume,
				Default->10 Microliter,
				Description->"The volume of sample solution that is loaded into the instrument and used for the measurement of osmolality.",
				AllowNull->False,
				Category->"Sample Loading",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter,11 Microliter],
					Units->Microliter
				]
			},
			{
				OptionName->NumberOfReadings,
				Default->1,
				Description->"The number of osmolality readings to perform on the same aliquot once loaded into the instrument. If multiple aliquots of the same sample should be loaded and measured, use the NumberOfReplicates option.",
				AllowNull->False,
				Category->"Measurement",
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterEqualP[1,1]
				]
			},
			{
				OptionName->EquilibrationTime,
				Default->Automatic,
				Description->"The amount of time to wait after loading a sample before the osmolality measurement is performed.",
				ResolutionDescription->"Automatically set to an internal default value by the selected instrument if possible. Otherwise set to 60 seconds.",
				AllowNull->False,
				Category->"Measurement",
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[InternalDefault]
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0 Second,$MaxExperimentTime],
						Units->{Second,{Second,Minute}}
					]
				]
			}
		],
		(* Shared options *)
		ModifyOptions[
			ModelInputOptions,
			OptionName -> PreparedModelContainer
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 100 Microliter."
			}
		],
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		SimulationOption
	}
];

(* ::Subsubsection:: *)
(*ExperimentMeasureOsmolality Errors and Warnings*)
(* Messages thrown before options resolution *)

Error::OsmolalityNoVolume="In ExperimentMeasureOsmolality, the samples, `1`, do not have volume populated. Please specify samples with non-Null volume, or use ExperimentMeasureVolume to measure the volume of the samples.";
Error::OsmolalityCalibrantIncompatible="In ExperimentMeasureOsmolality, calibration with calibrants, `1`, is not supported by the instrument `2` as `2` does not support custom calibration. Only manufacturer calibrants, `3`, with `4` osmolalities are supported, in that order. Please specify calibrants compatible with the instrument.";
Error::OsmolalityControlOsmolalitiesIncompatible="In ExperimentMeasureOsmolality, the control osmolalities, `1` are not within the measurement range of the osmometer (`2`-`3`). Please specify a control with osmolality within the instrument's measurable range.";
Error::OsmolalityCalibrantOsmolalitiesIncompatible="In ExperimentMeasureOsmolality, calibration with calibrant osmolalities, `1`, is not supported by the instrument `2` as `2` does not support custom calibration. Only manufacturer calibrants, `3`, with `4` osmolalities are supported, in that order. Please specify calibrant osmolalities compatible with the instrument.";
Error::OsmolalityCalibrantsMisordered="In ExperimentMeasureOsmolality, calibration with, `1`, are compatible with the instrument `2` but the instrument must be calibrated will the full set of three calibrants in the following order: `3`. Please specify the three calibrants in the correct order.";
Error::OsmolalityCalibrantOsmolalitiesMisordered="In ExperimentMeasureOsmolality, the calibrant osmolalities, `1`, are compatible with the instrument `2` but the instrument must be calibrated will the full set of three calibrants in the following order: `3`. Please specify the three calibrant osmolalities in the correct order.";
Warning::OsmolalityLowSampleVolume="In ExperimentMeasureOsmolality, the sample volumes, `1`, are lower than the minimum recommended volume for a reliable reading with `2`, of `3`. Consider specifying a larger volume of sample, or take this into consideration when interpreting the result.";
Warning::OsmolalityLowControlVolume="In ExperimentMeasureOsmolality, the control volumes, `1`, are lower than the minimum recommended volume for a reliable reading with `2`, of `3`. Consider specifying a larger volume of control, or take this into consideration when interpreting the result.";
Warning::OsmolalityUnknownViscosity="In ExperimentMeasureOsmolality, the viscosity of the samples `1` could not be found to determine the appropriate loading procedure for the instrument. The standard loading procedure for low viscosity samples is assumed - if your sample is not viscous, set ViscousLoading to False to silence this warning. If your sample is viscous, set ViscousLoading to True to avoid issues with loading. If you are unsure whether your sample is highly viscous, consider running ExperimentMeasureViscosity.";
Error::OsmolalityTransferHighViscosity="In ExperimentMeasureOsmolality, the samples, `1`, are viscous, however ViscousLoading is set to False. Using standard loading techniques for viscous samples risks contaminating the thermocouple of the instrument, as the sample cannot be properly applied to the sample holder. Please consider setting ViscousLoading to True.";
Warning::OsmolalitySampleCarryOver="In ExperimentMeasureOsmolality, the samples, `1`, are not viscous, however ViscousLoading is set to True. Viscous loading techniques have a higher risk of carry-over error, and therefore should only be used when necessary. Please consider setting ViscousLoading to False if not required.";
Warning::OsmolalityNoInoculationPaper="In ExperimentMeasureOsmolality, the samples, `1`, are specified/resolved not to use viscous loading techniques, and it is specified not to use inoculation paper. If your sample is not viscous, consider using inoculation paper as it helps to ensure an even distribution of sample in the sample holder, producing a more reliable measurement.";
Warning::OsmolalityViscousTransferMinimumVolume="In ExperimentMeasureOsmolality, the samples, `1`, are specified/resolved to use viscous loading techniques which utilize a positive displacement pipette with a minimum measurable volume of 10 uL. The volumes `2` will not be measured accurately. If possible, consider specifying a sample volume of 10 uL or more.";
Warning::OsmolalityInoculationPaperHighViscosity="In ExperimentMeasureOsmolality, the samples, `1`, are specified/resolved to use viscous loading techniques, and it is specified to use inoculation paper. If your sample is viscous, consider not using sample paper as the sample may not be effectively absorbed by the paper and more even distribution may be achieved by application directly to the sample holder, producing a more reliable measurement.";
Error::OsmolalityReadingsExceedsMaximum="In ExperimentMeasureOsmolality, for the samples, `1`, the number of readings, `2`, exceeds the maximum that the instrument `3` can measure (`4`). Please specify a number of readings below the threshold. If you require more data, consider adding replicates.";
Warning::OsmolalityShortEquilibrationTime="In ExperimentMeasureOsmolality, the equilibration times for samples `1` on instrument `2` are timed manually by the operator and so short equilibration times, `3`, will have higher uncertainty. Please consider specifying a longer equilibration time if precise timing of the equilibration period is important.";
Error::OsmolalityEquilibrationTimeReadings="In ExperimentMeasureOsmolality, for the samples, `1`, the specified equilibration times and number of readings are in conflict `2`. The instrument, `3`, can only handle InternalDefault equilibration times if the number of readings is 1 or 10. Consider changing the number of readings to 1 or 10, specifying a manual equilibration time in seconds, or leaving equilibration times as default.";
Warning::OsmolalityControlOsmolalityDeviation="In ExperimentMeasureOsmolality, for the controls `1`, the specified target osmolalities `2` differ significantly from the database osmolalities for those standards `3`. Please check that this is intended and update the ControlOsmolality if required.";
Error::OsmolalityControlOsmolalityUnknown="In ExperimentMeasureOsmolality, for the controls `1`, target ControlOsmolalities could not be resolved. Please specify the ControlOsmolality option.";
Warning::OsmolalityControlTolerance="In ExperimentMeasureOsmolality, for the controls `1`, the specified tolerances `2` may not be reliably achieved as they are tighter than the estimated achievable tolerance (`3`). This value is computed based on 2x instrument repeatability (`4`) and, if the control is not used for calibration, the (estimated) tolerance of the calibrants (`5`) and control (`6`). Please specify wider ControlTolerance or be aware that the tolerance may not be met.";
Error::OsmolalityControlConflict="The options - `1` - are in conflict with the Control option. ControlOsmolality, ControlVolume and ControlTolerance may only be Null if Control is Null, and must be non-Null if control is specified or Automatic. Please correct the specified options or set them to Automatic.";

(* ::Subsubsection:: *)
(*ExperimentMeasureOsmolality*)

ExperimentMeasureOsmolality[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedSamples,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedSimulation,safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,expandedSafeOps,
		cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,
		allSamplePackets,instrumentModelPacket,instrumentObjectPacket,calibrantsObjects,cacheOption,specifiedInstrumentObjects,osmometerInstrumentModels,allInstrumentModels,
		specifiedInstrumentModels,osmolalityStandardsList,inoculationPapersList,calibrantsModels,cleaningSolutionModels,allCalibrantModels,
		mySamplesWithPreparedSamplesFields,mySamplesWithPreparedSamplesModelFields,mySamplesWithPreparedSamplesContainerFields,mySamplesWithPreparedSamplesContainerModelFields,
		optionsWithObjects,userSpecifiedObjects,safeOptionsNamed,
		inoculationPapersPacket,calibrantObjectsPacket,calibrantModelsPacket,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,
		cleaningSolutionModelsPacket,allTipModelPacket,allPipetteModelPacket,resourcePackets,resourcePacketTests,
		controlsObjects,controlsModels,controlsObjectsPacket},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Make sure we're working with a list of options *)
	cacheOption=ToList[Lookup[listedOptions,Cache,{}]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureOsmolality,
			ToList[listedSamples],
			ToList[listedOptions]
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentMeasureOsmolality,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentMeasureOsmolality,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(*change all Names to objects *)
	{mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed,myOptionsWithPreparedSamplesNamed,Simulation->updatedSimulation];

	(* If the specified options don't match their patterns return $Failed *)
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
		ValidInputLengthsQ[ExperimentMeasureOsmolality,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentMeasureOsmolality,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
		ApplyTemplateOptions[ExperimentMeasureOsmolality,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentMeasureOsmolality,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
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

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentMeasureOsmolality,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];


	(* Create list of options that can take objects *)
	optionsWithObjects={Instrument,CleaningSolution,Calibrant,Control,InoculationPaper};

	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects=DeleteDuplicates[
		Cases[
			Flatten@Join[
				mySamplesWithPreparedSamples,
				(* All options that could have an object *)
				Lookup[expandedSafeOps,optionsWithObjects]
			],
			ObjectP[]
		]
	];


	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Any options whose values could be an object *)

	(* Get specified osmometer object/model *)
	specifiedInstrumentObjects=Cases[{Lookup[expandedSafeOps,Instrument]},ObjectP[Object[Instrument,Osmometer]]];
	specifiedInstrumentModels=Cases[{Lookup[expandedSafeOps,Instrument]},ObjectP[Model[Instrument,Osmometer]]];

	osmometerInstrumentModels=Search[Model[Instrument,Osmometer]];
	allInstrumentModels=Join[specifiedInstrumentModels,osmometerInstrumentModels];

	(* Get specified calibrants object/model *)
	calibrantsObjects=Cases[ToList@Lookup[expandedSafeOps,Calibrant],ObjectP[Object[Sample]]];
	calibrantsModels=Cases[ToList@Lookup[expandedSafeOps,Calibrant],ObjectP[Model[Sample]]];

	(* Get specified controls object/model *)
	controlsObjects=Cases[ToList@Lookup[expandedSafeOps,Control],ObjectP[Object[Sample]]];
	controlsModels=Cases[ToList@Lookup[expandedSafeOps,Control],ObjectP[Model[Sample]]];

	(* Get all osmolality standards in SLL *)
	osmolalityStandardsList={
		Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],
		Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"],
		Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]
	};

	allCalibrantModels=Join[calibrantsModels,controlsModels,osmolalityStandardsList];

	(* Get all inoculation papers in SLL *)
	inoculationPapersList=Search[Model[Item,InoculationPaper]];

	(* Get specified cleaning solution *)
	cleaningSolutionModels=Cases[{Lookup[expandedSafeOps,CleaningSolution]},ObjectP[Model[Sample]]];

	(* Download the required fields from our objects *)

	(* ContainerMaterials in SamplePreparationCacheFields is a computable field that should be removed once SamplePreparationCacheFields are updated *)
	mySamplesWithPreparedSamplesFields=Packet[
		(* For sample prep *)
		Sequence@@SamplePreparationCacheFields[Object[Sample]],
		(* For Experiment *)
		Viscosity,IncompatibleMaterials,Composition,StorageCondition,Density,
		(*Safety and transport*)
		Ventilated,BoilingPoint
	];

	mySamplesWithPreparedSamplesModelFields=Packet[Model[{
		(* For sample prep *)
		Sequence@@SamplePreparationCacheFields[Model[Sample]],
		(* For Experiment *)
		Viscosity,Notebook,IncompatibleMaterials,Composition,Name,Solvent,State,Deprecated,Sterile,Products,Dimensions,
		(* Transport *)
		TransportTemperature
	}]];

	mySamplesWithPreparedSamplesContainerFields=Packet[Container[{
		Sequence@@SamplePreparationCacheFields[Object[Container]]
	}]];

	mySamplesWithPreparedSamplesContainerModelFields=Packet[Container[Model][{
		(*For sample prep*)
		Sequence@@SamplePreparationCacheFields[Model[Container]],
		(* Experiment required *)
		MaxVolume,Name,DefaultStorageCondition,NumberOfWells,DestinationContainerModel
	}]];

	{
		allSamplePackets,
		instrumentObjectPacket,
		instrumentModelPacket,
		calibrantObjectsPacket,
		controlsObjectsPacket,
		calibrantModelsPacket,
		inoculationPapersPacket,
		cleaningSolutionModelsPacket,
		allTipModelPacket,
		allPipetteModelPacket
	}=Quiet[
		Download[
			{
				ToList[mySamplesWithPreparedSamples],
				specifiedInstrumentObjects,
				allInstrumentModels,
				calibrantsObjects,
				controlsObjects,
				allCalibrantModels,
				inoculationPapersList,
				cleaningSolutionModels,
				Search[Model[Item,Tips]],
				Search[Model[Instrument,Pipette]]
			},
			{
				(* Downloading from mySamplesWithPreparedSamples *)
				{
					(* Download the fields specified from each sample *)
					mySamplesWithPreparedSamplesFields,

					(* Download the fields specified from each model sample *)
					mySamplesWithPreparedSamplesModelFields,

					(* Download details of the sample's container object *)
					mySamplesWithPreparedSamplesContainerFields,

					(* Download details of the sample's container model *)
					mySamplesWithPreparedSamplesContainerModelFields,

					(* Sample composition *)
					Packet[Composition[[All,2]][{State,Viscosity}]],

					(* Storage condition *)
					Packet[StorageCondition[{StorageCondition}]]
				},

				(* Download from instrument objects *)
				{
					Packet[Model[{Object,Name(*,OsmolalityMethod,MinOsmolality,MaxOsmolality,MinSampleVolume,MaxSampleVolume,EquilibrationTime,CustomCalibrants*),ManufacturerCalibrants,(*ManufacturerCalibrantOsmolalities,CustomCleaningSolution,*)ManufacturerCleaningSolution,WettedMaterials(*,MeasurementTime*)}]]
				},

				(* Download from instrument models *)
				{
					Packet[Name,OsmolalityMethod,MinOsmolality,MaxOsmolality,MinSampleVolume,MaxSampleVolume,EquilibrationTime,CustomCalibrants,ManufacturerCalibrants,ManufacturerCalibrantOsmolalities,CustomCleaningSolution,ManufacturerCleaningSolution,WettedMaterials,MeasurementTime,ManufacturerOsmolalityRepeatability]
				},

				(* Download from calibrants objects *)
				{
					Packet[Model[{Object,Name,Composition,IncompatibleMaterials,Solvent,State,Density}]]
				},

				(* Download from controls objects *)
				{
					Packet[Model[{Object,Name,Composition,IncompatibleMaterials,Solvent,State,Density}]]
				},

				(* Download from calibrants models *)
				{
					Packet[Object,Name,Composition,IncompatibleMaterials,Solvent,State,Density,DefaultStorageCondition]
				},

				(* Download from potential inoculation papers *)
				{
					Packet[Object,Name,Shape,Diameter,PaperThickness]
				},

				(* Download from cleaning solution models *)
				{
					Packet[Name,Composition,IncompatibleMaterials,Solvent,State,Density]
				},

				(* Download all pipette tips *)
				{
					Packet[TipConnectionType,Resolution,Name,Sterile,TipType,Material,AspirationDepth,MinVolume,MaxVolume,NumberOfTips]
				},

				(* Download all pipettes *)
				{
					Packet[TipConnectionType,MinVolume,MaxVolume,CultureHandling,Resolution]
				}
			},
			Cache -> cacheOption,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField,Download::MissingCacheField}
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

	cacheBall=FlattenCachePackets[{
		allSamplePackets,instrumentObjectPacket,instrumentModelPacket,calibrantObjectsPacket,controlsObjectsPacket,calibrantModelsPacket,inoculationPapersPacket,cleaningSolutionModelsPacket,allTipModelPacket,allPipetteModelPacket
	}];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentMeasureOsmolalityOptions[
			mySamplesWithPreparedSamples,
			expandedSafeOps,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {
				resolveExperimentMeasureOsmolalityOptions[
					mySamplesWithPreparedSamples,
					expandedSafeOps,
					Cache -> cacheBall,
					Simulation -> updatedSimulation
			],
				{}
			},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentMeasureOsmolality,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentMeasureOsmolality,collapsedResolvedOptions],
			Preview->Null
		}]
	];


	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		experimentMeasureOsmolalityResourcePackets[
			ToList[mySamplesWithPreparedSamples],
			expandedSafeOps,
			resolvedOptions,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests}
		],
		{
			experimentMeasureOsmolalityResourcePackets[
				ToList[mySamplesWithPreparedSamples],
				expandedSafeOps,
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation
			],
			{}
		}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentMeasureOsmolality,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject=If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
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
			ConstellationMessage -> Object[Protocol,MeasureOsmolality],
			Cache -> cacheBall,
			Simulation -> updatedSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests(*,resourcePacketTests*)}],(*TODO: why is this commented? *)
		Options->RemoveHiddenOptions[ExperimentMeasureOsmolality,collapsedResolvedOptions],
		Preview->Null
	}
];

(* Note: The container overload should come after the sample overload. *)
ExperimentMeasureOsmolality[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedContainers,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, containerToSampleSimulation,
		updatedSimulation,containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedContainers,listedOptions}= {ToList[myContainers],ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentMeasureOsmolality,
			listedContainers,
			listedOptions,
			DefaultPreparedModelAmount -> 100 Microliter
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentMeasureOsmolality,
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
				ExperimentMeasureOsmolality,
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
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentMeasureOsmolality[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];


DefineOptions[
	resolveExperimentMeasureOsmolalityOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentMeasureOsmolalityOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentMeasureOsmolalityOptions]]:=Module[{
	outputSpecification,output,gatherTests,cache,simulation,samplePrepOptions,measureOsmolalityOptions,simulatedSamples,resolvedSamplePrepOptions,updatedSimulation,samplePrepTests,
	measureOsmolalityOptionsAssociation,invalidInputs,invalidOptions,resolvedAliquotOptions,aliquotTests,incompatibleInputs,
	(* Download *)
	instrumentDownloadFields,listedSampleContainerPackets,instrumentPacket,calibrantsPackets,
	samplePackets,sampleModelPackets,sampleContainerPackets,sampleComponentPackets,simulatedSampleContainerModels,simulatedSampleContainerObjects,osmolalityStandardsList,
	calibrantsObjectsPackets,controlsObjectsPackets,instrumentModel,specifiedCalibrantModels,specifiedControlModels,
	specifiedCalibrantObjectToModelAssociation,specifiedControlObjectToModelAssociation,controlVolumes,
	rawControls,rawControlOsmolalities,rawControlVolumes,rawControlTolerances,
	(* Invalid Input Tests*)
	discardedSamplePackets,discardedInvalidInputs,discardedTest,
	containerlessSamplePackets,containerlessInvalidInputs,containerlessTest,
	nonLiquidSamplePackets,nonLiquidInvalidInputs,
	noVolumeSamplePackets,noVolumeInvalidInputs,noVolumeTest,

	(* Options Precision Tests *)
	osmolalityOptionsChecks,osmolalityOptionsPrecisions,roundedExperimentOptions,precisionTests,
	roundedExperimentOptionsList,allOptionsRounded,allOptionsPrecisionTests,

	(* Conflicting options checks *)
	validNameQ,name,nameInvalidOption,validNameTest,
	manufacturerCalibrantsAllP,manufacturerCalibrantsOrP,
	manufacturerCalibrantOsmolalitiesAllP,manufacturerCalibrantOsmolalitiesOrP,
	calibrantIncompatibleConflictOptions,calibrantIncompatibleInvalidOptions,calibrantIncompatibleInvalidTest,
	calibrantOrderingConflictOptions,calibrantOrderingInvalidOptions,calibrantOrderingInvalidTest,resolvedCalibrants,
	calibrantOsmolalityIncompatibleConflictOptions,calibrantOsmolalityIncompatibleInvalidOptions,calibrantOsmolalityIncompatibleInvalidTest,resolvedCalibrantOsmolalities,
	calibrantOsmolalityOrderingConflictOptions,calibrantOsmolalityOrderingInvalidOptions,calibrantOsmolalityOrderingInvalidTest,
	lowSampleVolumeWarningConflictOptions,lowSampleVolumeWarningOptions,lowSampleVolumeWarningTest,
	readingsExceedsMaximumConflicts,readingsExceedsMaximumConflictInputs,readingsExceedsMaximumConflictOptions,readingsExceedsMaximumInvalidOptions,readingsExceedsMaximumInvalidTest,
	equilibrationTimeReadingsConflicts,equilibrationTimeReadingsConflictInputs,equilibrationTimeReadingsConflictOptions,equilibrationTimeReadingsInvalidOptions,equilibrationTimeReadingsInvalidTest,
	minInstrumentOsmolality,maxInstrumentOsmolality,controlOsmolalities,controlIncompatibleConflictOptions,controlIncompatibleInvalidOptions,controlIncompatibleInvalidTest,
	resolvedControls,osmolalityLookupTable,osmolalityToleranceLookupTable,resolvedControlOsmolalities,controlOsmolalityDeviationWarnings,failingControlOsmolalityDeviationVars,
	controlOsmolalityUnknownErrors,failingControlOsmolalityUnknownVars,resolvedControlsModels,resolvedMaxNumberOfCalibrations,
	resolvedControlTolerances,controlToleranceWarnings,failingControlToleranceVars,controlTolerances,
	knownControlsQ,controlUsedForCalibrationQ,resolvedControlVolumes,
	lowControlVolumeWarningConflictOptions,lowControlVolumeWarningOptions,lowControlVolumeWarningTest,
	controlOptionsInvalidOptions,controlOptionsInvalidTest,

	(* Map Thread *)
	mapThreadFriendlyOptions,
	(*Already defaulted options*)
	osmolalityMethod,instrument,numberOfReplicates,preClean,cleaningSolution,postRunInstrumentContaminationLevel,
	calibrants,calibrantOsmolalities,calibrantVolume,sampleVolume,numberOfReadings,numberOfControlReplicates,
	controls,rawNumberOfControlReplicates,
	(* Options resolution *)
	resolvedCleaningSolution,resolvedNumberOfControlReplicates,
	(*Map Thread Variables*)
	resolvedSampleViscosities,resolvedViscousLoadings,resolvedInoculationPapers,resolvedEquilibrationTimes,
	(*Error tracking Booleans*)
	unknownViscosityWarnings,transferHighViscosityErrors,sampleCarryOverWarnings,noInoculationPaperWarnings,viscousTransferMinimumVolumeWarnings,inoculationPaperHighViscosityWarnings,shortEquilibrationTimeWarnings,
	(*Failing Options*)
	failingUnknownViscosityVars,failingTransferHighViscosityVars,failingSampleCarryOverVars,failingViscousTransferMinimumVolumeVars,failingNoInoculationPaperVars,failingInoculationPaperHighViscosityVars,failingShortEquilibrationTimeVars,
	failingUnknownViscosityInputs,failingTransferHighViscosityInputs,failingSampleCarryOverInputs,failingViscousTransferMinimumVolumeInputs,failingNoInoculationPaperInputs,failingInoculationPaperHighViscosityInputs,failingShortEquilibrationTimeInputs,
	failingUnknownViscosityOptions,failingTransferHighViscosityOptions,failingSampleCarryOverOptions,failingViscousTransferMinimumVolumeOptions,failingNoInoculationPaperOptions,failingInoculationPaperHighViscosityOptions,failingShortEquilibrationTimeOptions,
	failingShortEquilibrationTimeInstruments,failingShortEquilibrationTimeTimes,failingControlOsmolalityDeviationInputs,failingControlOsmolalityDeviationOptions,
	failingControlOsmolalityUnknownInputs,failingControlOsmolalityUnknownOptions,
	failingControlToleranceInputs,failingControlToleranceOptions,controlToleranceParameterWarningOptions,
	(*Error resolving*)
	unknownViscosityParameterWarningOptions,transferHighViscosityParameterErrorOptions,sampleCarryOverParameterWarningOptions,viscousTransferMinimumVolumeOptions,noInoculationPaperParameterWarningOptions,inoculationPaperHighViscosityParameterWarningOptions,shortEquilibrationTimeWarningOptions,
	controlOsmolalityDeviationParameterWarningOptions,controlOsmolalityUnknownParameterErrorOptions,
	(*Error resolving tests*)
	unknownViscosityWarningTests,transferHighViscosityErrorTests,sampleCarryOverWarningTests,viscousTransferMinimumVolumeWarningTests,noInoculationPaperWarningTests,inoculationPaperHighViscosityWarningTests,shortEquilibrationTimeWarningTests,
	controlOsmolalityDeviationWarningTests,controlOsmolalityUnknownWarningTests,controlToleranceWarningTests,

	(* Misc options *)
	allTests,emailOption,uploadOption,nameOption,confirmOption,canaryBranchOption,parentProtocolOption,fastTrackOption,templateOption,samplesInStorageCondition,samplesOutStorageCondition,operator,imageSample,measureWeight,measureVolume,
	validSampleStorageConditionQ,validSampleStorageTests,invalidStorageConditionOptions,maxNumberOfCalibrations,

	(* Finishing up *)
	compatibleMaterialsBool,compatibleMaterialsTests,
	resolvedEmail,resolvedPostProcessingOptions,
	resolvedOptions
},


	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache and simulation from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation=Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our MeasureOsmolality options from our Sample Prep options. *)
	{samplePrepOptions,measureOsmolalityOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentMeasureOsmolality,mySamples,samplePrepOptions,Cache->cache,Simulation -> simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentMeasureOsmolality,mySamples,samplePrepOptions,Cache->cache,Simulation -> simulation,Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	measureOsmolalityOptionsAssociation=Association[measureOsmolalityOptions];

	(* Set options variables *)
	{instrument,calibrants,rawControls,name,rawControlOsmolalities,rawControlVolumes,rawControlTolerances,maxNumberOfCalibrations,rawNumberOfControlReplicates}=Lookup[measureOsmolalityOptionsAssociation,{Instrument,Calibrant,Control,Name,ControlOsmolality,ControlVolume,ControlTolerance,MaxNumberOfCalibrations,NumberOfControlReplicates}];

	{controls,controlOsmolalities,controlVolumes,controlTolerances,numberOfControlReplicates}=ToList/@{rawControls,rawControlOsmolalities,rawControlVolumes,rawControlTolerances,rawNumberOfControlReplicates};

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)

	instrumentDownloadFields=Which[
		(* If instrument is an object, download fields from the Model *)
		MatchQ[instrument,ObjectP[Object[Instrument]]],
		Packet[Model[{Object,Model,OsmolalityMethod,CustomCalibrants,ManufacturerCalibrants,ManufacturerCalibrantOsmolalities,MinSampleVolume,MaxSampleVolume,MinOsmolality,MaxOsmolality,CustomCleaningSolution,ManufacturerCleaningSolution,WettedMaterials,MeasurementTime,ManufacturerOsmolalityRepeatability}]],

		(* If instrument is a Model, download fields*)
		MatchQ[instrument,ObjectP[Model[Instrument]]],
		Packet[Object,OsmolalityMethod,CustomCalibrants,ManufacturerCalibrants,ManufacturerCalibrantOsmolalities,MinSampleVolume,MaxSampleVolume,MinOsmolality,MaxOsmolality,CustomCleaningSolution,ManufacturerCleaningSolution,WettedMaterials,MeasurementTime,ManufacturerOsmolalityRepeatability],

		True,
		Nothing
	];

	(* Get all osmolality standards in SLL *)
	osmolalityStandardsList={
		Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"],
		Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"],
		Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]
	};

	(* Extract the packets that we need from our downloaded cache. *)

	{
		listedSampleContainerPackets,
		{instrumentPacket},
		calibrantsObjectsPackets,
		controlsObjectsPackets,
		calibrantsPackets
	}=Quiet[Download[
		(* Samples *)
		{
			simulatedSamples,
			{instrument},
			Cases[calibrants,ObjectP[Object[Sample]]],
			Cases[controls,ObjectP[Object[Sample]]],
			osmolalityStandardsList
		},
		(* Fields *)
		{
			{
				(* sample object/model/container fields *)
				Packet[Model,Status,Container,Density,State,Solvent,Volume,Viscosity,StorageCondition],
				Packet[Model[{State,Solvent,Viscosity}]],
				Packet[Container[{Model,Contents}]],
				Packet[Composition[[All,2]][{State}]]
			},
			{
				instrumentDownloadFields
			},
			(* Download from calibrants objects *)
			{
				Packet[Model[{Object,Name,Composition,IncompatibleMaterials,Solvent,Density,DefaultStorageCondition}]]
			},
			(* Download from controls objects *)
			{
				Packet[Model[{Object,Name,Composition,IncompatibleMaterials,Solvent,Density,DefaultStorageCondition}]]
			},
			(* Download from calibrants models *)
			{
				Packet[Object,Name,Composition,IncompatibleMaterials,Solvent,Density,DefaultStorageCondition]
			}
		},
		Simulation -> updatedSimulation,
		Date->Now
	],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];


	(* --- Extract out the packets from the download --- *)
	(* -- sample packets -- *)
	samplePackets=listedSampleContainerPackets[[All,1]];
	sampleModelPackets=listedSampleContainerPackets[[All,2]];
	sampleContainerPackets=listedSampleContainerPackets[[All,3]];
	sampleComponentPackets=listedSampleContainerPackets[[All,4]];
	simulatedSampleContainerModels=If[NullQ[#],Null,Download[Lookup[#,Model],Object]]&/@sampleContainerPackets;
	simulatedSampleContainerObjects=Download[Lookup[samplePackets,Container],Object];

	(* -- Instrument packet --*)
	(* - Find the Model of the instrument, if it was specified - *)
	instrumentModel=If[
		MatchQ[instrumentPacket,{}],
		Null,
		FirstOrDefault[Lookup[Flatten[instrumentPacket],Object]]
	];

	(* Collect the models of the calibrants in order, if specified *)
	(* Associate calibrant object with model *)
	specifiedCalibrantObjectToModelAssociation=AssociationThread[Cases[ToList[calibrants],ObjectP[Object[Sample]]],Lookup[calibrantsObjectsPackets[[All,1]],Object]];

	(* Replace calibrant objects in options with models *)
	specifiedCalibrantModels=ReplaceAll[ToList[calibrants],specifiedCalibrantObjectToModelAssociation];

	(* Associate control object with model *)
	specifiedControlObjectToModelAssociation=AssociationThread[Cases[ToList[controls],ObjectP[Object[Sample]]],Lookup[controlsObjectsPackets[[All,1]],Object]];

	(* Replace control objects in options with models *)
	specifiedControlModels=ReplaceAll[ToList[controls],specifiedControlObjectToModelAssociation];

	(*-- INPUT VALIDATION CHECKS --*)

	(* Check that none of the samples are discarded *)

	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=Lookup[discardedSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs, Simulation -> updatedSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Simulation -> updatedSimulation]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs,SameTest->(MatchQ[#1,ObjectP[#2]]&)],Simulation -> updatedSimulation]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Check that all samples are in a container *)

	(* Get the samples from mySamples that are not in a container *)
	containerlessSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Container->Null]];

	(* Set containerlessInvalidInputs to the input objects who have no container *)
	containerlessInvalidInputs=Lookup[containerlessSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[containerlessInvalidInputs]>0&&!gatherTests,
		Message[Error::ContainerlessSamples,ObjectToString[containerlessInvalidInputs,Simulation -> updatedSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	containerlessTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[containerlessInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[containerlessInvalidInputs,Simulation -> updatedSimulation]<>" are located in a container:",True,False]
			];

			passingTest=If[Length[containerlessInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,containerlessInvalidInputs,SameTest->(MatchQ[#1,ObjectP[#2]]&)],Simulation -> updatedSimulation]<>" are located in a container:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(* Check that all samples are liquid state *)
	(* Error is now raised in resolveAliquotOptions - check for internal use *)

	(* Get the samples from mySamples that are not liquid *)
	nonLiquidSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[State->Except[Liquid]]];

	(* Set nonLiquidInvalidInputs to the input objects whose state are non-liquid *)
	nonLiquidInvalidInputs=Lookup[nonLiquidSamplePackets,Object,{}];


	(* Check that all have a non-Null volume *)

	(* Get the samples from mySamples that have Null volume*)
	noVolumeSamplePackets=If[Length[nonLiquidInvalidInputs]>0,
		(* If sample is solid, don't check volume *)
		{},
		Cases[Flatten[samplePackets],KeyValuePattern[Volume->NullP]]
	];

	(* Set noVolumeInvalidInputs to the input objects who have no volume *)
	noVolumeInvalidInputs=Lookup[noVolumeSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[noVolumeInvalidInputs]>0&&!gatherTests,
		Message[Error::OsmolalityNoVolume,ObjectToString[noVolumeInvalidInputs,Simulation -> updatedSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[noVolumeInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[noVolumeInvalidInputs,Simulation -> updatedSimulation]<>" have volume populated:",True,False]
			];

			passingTest=If[Length[noVolumeInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,noVolumeInvalidInputs,SameTest->(MatchQ[#1,ObjectP[#2]]&)],Simulation -> updatedSimulation]<>" have volume populated.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	osmolalityOptionsChecks={
		(*1*)CalibrantVolume,
		(*2*)SampleVolume,
		(*3*)EquilibrationTime,
		(*4*)ControlVolume
	};

	osmolalityOptionsPrecisions={
		(*1*)10^-7 Liter,
		(*2*)10^-7 Liter,
		(*3*)1 Second,
		(*4*)10^-7 Liter
	};

	(* Round the options *)
	{roundedExperimentOptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[measureOsmolalityOptionsAssociation,osmolalityOptionsChecks,osmolalityOptionsPrecisions,Output->{Result,Tests}],
		{RoundOptionPrecision[measureOsmolalityOptionsAssociation,osmolalityOptionsChecks,osmolalityOptionsPrecisions],Null}
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

	(*-- CONFLICTING OPTIONS CHECKS --*)
	validNameQ=If[MatchQ[name,_String],

		(* If the name was specified, make sure it's not a duplicate name *)
		Not[DatabaseMemberQ[Object[Protocol,MeasureOsmolality,name]]],

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
		Test["If specified, Name is not already an MeasureOsmolality protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];


	(* Check that the specified calibrants are compatible with the instrument specified, and specified in the correct order *)

	(* Get a pattern version of the manufacturer calibrants *)
	manufacturerCalibrantsAllP=ObjectReferenceP[#[Object]]&/@(First@Lookup[instrumentPacket,ManufacturerCalibrants]);
	manufacturerCalibrantsOrP=Alternatives@@manufacturerCalibrantsAllP;

	{
		calibrantIncompatibleConflictOptions,
		calibrantOrderingConflictOptions
	}=Which[
		(* If calibrants are not specified, skip the check *)
		MatchQ[calibrants,ListableP[Automatic]],
		{Null,Null},

		(* If the instrument supports custom calibrants, skip the check *)
		First[Lookup[instrumentPacket,CustomCalibrants]],
		{Null,Null},

		(* If calibrants are specified and instrument cannot accept custom calibrants, the calibrants must be the instrument calibrants *)
		(* If the wrong number of calibrants are specified*)
		!SameLengthQ[calibrants,manufacturerCalibrantsAllP],
		{calibrants,Null},

		(* If the calibrants match perfectly *)
		MatchQ[specifiedCalibrantModels,manufacturerCalibrantsAllP],
		{Null,Null},

		(* If the calibrants are specified but not in the right order/right way *)
		And@@(MatchQ[#,manufacturerCalibrantsOrP]&/@specifiedCalibrantModels),
		{Null,calibrants},

		(* Else, if the calibrants don't all match *)
		!And@@(MatchQ[#,manufacturerCalibrantsOrP]&/@specifiedCalibrantModels),
		{Cases[calibrants,Except[manufacturerCalibrantsOrP]],Null}
	];


	(* If there are incompatible calibrant conflicts, store the problematic options *)
	calibrantIncompatibleInvalidOptions=If[Length[calibrantIncompatibleConflictOptions]>0,
		(* Store the problem options *)
		{Calibrant,Instrument},
		(* Else, just initialize the empty list *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[Length[calibrantIncompatibleConflictOptions]>0&&!gatherTests,
		Message[Error::OsmolalityCalibrantIncompatible,ObjectToString[#,Simulation -> updatedSimulation]&/@calibrantIncompatibleConflictOptions,ObjectToString[Lookup[allOptionsRounded,Instrument],Simulation -> updatedSimulation],ObjectToString[Download[First@Lookup[instrumentPacket,ManufacturerCalibrants],Object],Simulation -> updatedSimulation],First@Lookup[instrumentPacket,ManufacturerCalibrantOsmolalities]]
	];

	(* Build a test for whether the calibrants specified are compatible with the instrument *)
	calibrantIncompatibleInvalidTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[calibrantIncompatibleConflictOptions]==0,
				Nothing,
				Test["The provided values for Calibrants/CalibrantOsmolalities and Instrument are not in conflict with each other:",
					True,
					False
				]
			];

			passingTest=If[Length[calibrantIncompatibleConflictOptions]!=0,
				Nothing,
				Test["The provided values for Calibrants/CalibrantOsmolalities and Instrument are not in conflict with each other:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* If there are mis-ordered conflicts, store the problematic options and resolve to correct order *)
	calibrantOrderingInvalidOptions=If[Length[calibrantOrderingConflictOptions]>0,
		(* Store the problem options *)
		{Calibrant,Instrument},
		(* Else, just initialize the empty list *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[Length[calibrantOrderingConflictOptions]>0&&!gatherTests,
		Message[Error::OsmolalityCalibrantsMisordered,{ObjectToString[First[#],Simulation -> updatedSimulation],Last[#]}&/@calibrantOrderingConflictOptions,ObjectToString[Lookup[allOptionsRounded,Instrument],Simulation -> updatedSimulation],ObjectToString[Download[First@Lookup[instrumentPacket,ManufacturerCalibrants],Object],Simulation -> updatedSimulation]]
	];

	(* Build a test for whether the calibrants specified are compatible with the instrument *)
	calibrantOrderingInvalidTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[calibrantOrderingConflictOptions]==0,
				Nothing,
				Test["The provided values for Calibrants and Instrument are not in conflict with each other:",
					True,
					False
				]
			];

			passingTest=If[Length[calibrantOrderingConflictOptions]!=0,
				Nothing,
				Test["The provided values for Calibrants and Instrument are not in conflict with each other:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* Check that the specified osmolalities are compatible with the instrument, if specified *)
	calibrantOsmolalities=ToList[Lookup[allOptionsRounded,CalibrantOsmolality]];

	(* Get a pattern version of the manufacturer calibrants *)
	manufacturerCalibrantOsmolalitiesAllP=EqualP[#]&/@(First@Lookup[instrumentPacket,ManufacturerCalibrantOsmolalities]);
	manufacturerCalibrantOsmolalitiesOrP=Alternatives@@manufacturerCalibrantOsmolalitiesAllP;


	{
		calibrantOsmolalityIncompatibleConflictOptions,
		calibrantOsmolalityOrderingConflictOptions
	}=Which[
		(* If calibrant osmolalities are not specified, skip the check *)
		MatchQ[calibrantOsmolalities,ListableP[Automatic]],
		{Null,Null},

		(* If the instrument supports custom calibrants, skip the check *)
		First[Lookup[instrumentPacket,CustomCalibrants]],
		{Null,Null},

		(* If calibrant osmolalities are specified and instrument cannot accept custom calibrants, the calibrant osmolalities must be the instrument calibrant osmolalities *)
		(* If the wrong number of calibrant osmolalities are specified - don't throw an error - we already threw one for wrong number of calibrants *)
		!SameLengthQ[calibrantOsmolalities,manufacturerCalibrantOsmolalitiesAllP],
		{Null,Null},

		(* If the calibrant osmolalities match perfectly *)
		MatchQ[calibrantOsmolalities,manufacturerCalibrantOsmolalitiesAllP],
		{Null,Null},

		(* If the calibrant osmolalities are specified but not in the right order/right way *)
		And@@(MatchQ[#,manufacturerCalibrantOsmolalitiesOrP]&/@calibrantOsmolalities),
		{Null,calibrantOsmolalities},

		(* Else, if the calibrant osmolalities don't all match *)
		!And@@(MatchQ[#,manufacturerCalibrantOsmolalitiesOrP]&/@calibrantOsmolalities),
		{Cases[calibrantOsmolalities,Except[manufacturerCalibrantOsmolalitiesOrP]],Null}
	];

	(* If there are incompatible calibrant osmolality conflicts, store the problematic options *)
	calibrantOsmolalityIncompatibleInvalidOptions=If[Length[calibrantOsmolalityIncompatibleConflictOptions]>0,
		(* Store the problem options *)
		{CalibrantOsmolality,Instrument},
		(* Else, just initialize the empty list *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[Length[calibrantOsmolalityIncompatibleConflictOptions]>0&&!gatherTests,
		Message[Error::OsmolalityCalibrantOsmolalitiesIncompatible,calibrantOsmolalityIncompatibleConflictOptions,ObjectToString[Lookup[allOptionsRounded,Instrument],Simulation -> updatedSimulation],ObjectToString[Download[First@Lookup[instrumentPacket,ManufacturerCalibrants],Object],Simulation -> updatedSimulation],First@Lookup[instrumentPacket,ManufacturerCalibrantOsmolalities]]
	];

	(* Build a test for whether the calibrants specified are compatible with the instrument *)
	calibrantOsmolalityIncompatibleInvalidTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[calibrantOsmolalityIncompatibleConflictOptions]==0,
				Nothing,
				Test["The provided values for CalibrantOsmolality and Instrument are not in conflict with each other:",
					True,
					False
				]
			];

			passingTest=If[Length[calibrantOsmolalityIncompatibleConflictOptions]!=0,
				Nothing,
				Test["The provided values for CalibrantOsmolality and Instrument are not in conflict with each other:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* If there are mis-ordered conflicts, store the problematic options and resolve to correct order *)
	calibrantOsmolalityOrderingInvalidOptions=If[Length[calibrantOsmolalityOrderingConflictOptions]>0,
		(* Store the problem options *)
		{CalibrantOsmolality,Instrument},
		(* Else, just initialize the empty list *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[Length[calibrantOsmolalityOrderingConflictOptions]>0&&!gatherTests,
		Message[Error::OsmolalityCalibrantOsmolalitiesMisordered,calibrantOsmolalityOrderingConflictOptions,ObjectToString[Lookup[allOptionsRounded,Instrument],Simulation -> updatedSimulation],First@Lookup[instrumentPacket,ManufacturerCalibrantOsmolalities]]
	];

	(* Build a test for whether the calibrants specified are compatible with the instrument *)
	calibrantOsmolalityOrderingInvalidTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[calibrantOsmolalityOrderingConflictOptions]==0,
				Nothing,
				Test["The provided ordering of the values for Calibrant Osmolalities, and Instrument are not in conflict with each other:",
					True,
					False
				]
			];

			passingTest=If[Length[calibrantOsmolalityOrderingConflictOptions]!=0,
				Nothing,
				Test["The provided ordering of the values for Calibrant Osmolalities, and Instrument are not in conflict with each other:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Check that the control related options are valid *)
	(* Check that if a control osmolality is provided, that it's capable of being measured by the specified instrument *)
	{minInstrumentOsmolality,maxInstrumentOsmolality}=Lookup[instrumentPacket[[1]],{MinOsmolality,MaxOsmolality},Null];

	(* Check for any control osmolalities that are specified and out of range *)
	controlIncompatibleConflictOptions=Cases[ToList[controlOsmolalities],Except[Alternatives[RangeP[minInstrumentOsmolality,maxInstrumentOsmolality],Automatic]]];

	(* If there are incompatible control conflicts, store the problematic options *)
	controlIncompatibleInvalidOptions=If[Length[controlIncompatibleConflictOptions]>0,
		(* Store the problem options *)
		{ControlOsmolality},
		(* Else, just initialize the empty list *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[Length[controlIncompatibleInvalidOptions]>0&&!gatherTests,
		Message[Error::OsmolalityControlOsmolalitiesIncompatible,controlIncompatibleConflictOptions,minInstrumentOsmolality,maxInstrumentOsmolality]
	];

	(* Build a test for whether the control osmolalities specified are compatible with the instrument *)
	controlIncompatibleInvalidTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[controlIncompatibleConflictOptions]==0,
				Nothing,
				Test["The provided values for ControlOsmolality and Instrument are not in conflict with each other:",
					True,
					False
				]
			];

			passingTest=If[Length[controlIncompatibleConflictOptions]!=0,
				Nothing,
				Test["The provided values for CalibrantOsmolality and Instrument are not in conflict with each other:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Check that control options are specified if and only iff we have controls *)
	controlOptionsInvalidOptions=If[MatchQ[controls,Alternatives[{ObjectP[]..},ListableP[Automatic]]],
		(* If controls are specified or automatic, return the names of any options that are Null *)
		PickList[{ControlOsmolality,ControlVolume,ControlTolerance,NumberOfControlReplicates},{controlOsmolalities,controlVolumes,controlTolerances,numberOfControlReplicates},NullP],

		(* Otherwise, we have an empty list, so return options that are not Null *)
		PickList[{ControlOsmolality,ControlVolume,ControlTolerance,NumberOfControlReplicates},{controlOsmolalities,controlVolumes,controlTolerances,numberOfControlReplicates},Except[Alternatives[NullP,ListableP[Automatic]]]]
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[Length[controlOptionsInvalidOptions]>0&&!gatherTests,
		Message[Error::OsmolalityControlConflict,controlOptionsInvalidOptions]
	];

	(* Build a test for whether the control osmolalities specified are compatible with the instrument *)
	controlOptionsInvalidTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[controlOptionsInvalidOptions]==0,
				Nothing,
				Test["The provided values for Control and the control options (ControlOsmolality, Control Volume, ControlTolerance, NumberOfControlReplicates) are not in conflict with each other:",
					True,
					False
				]
			];

			passingTest=If[Length[controlOptionsInvalidOptions]!=0,
				Nothing,
				Test["The provided values for Control and the control options (ControlOsmolality, Control Volume, ControlTolerance, NumberOfControlReplicates) are not in conflict with each other:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* Check that all sample volumes are sufficient for an accurate measurement by the instrument *)
	lowSampleVolumeWarningConflictOptions=Cases[ToList[Lookup[allOptionsRounded,SampleVolume]],LessP[First[Lookup[instrumentPacket,MinSampleVolume]]]];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	lowSampleVolumeWarningOptions=If[Length[lowSampleVolumeWarningConflictOptions]>0,
		(* Store the errant options for later InvalidOption checks *)
		{SampleVolume,Instrument},
		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[Length[lowSampleVolumeWarningConflictOptions]>0&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::OsmolalityLowSampleVolume,lowSampleVolumeWarningConflictOptions,ObjectToString[Lookup[allOptionsRounded,Instrument],Simulation -> updatedSimulation],First[Lookup[instrumentPacket,MinSampleVolume]]]
	];

	(* Build a test for whether the sample volumes are above the minimum recommended for the instrument *)
	lowSampleVolumeWarningTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[lowSampleVolumeWarningConflictOptions]==0,
				Nothing,
				Test["The provided values for SampleVolumes and Instrument are not in conflict with each other:",
					True,
					False
				]
			];

			passingTest=If[Length[lowSampleVolumeWarningConflictOptions]!=0,
				Nothing,
				Test["The provided values for SampleVolumes and Instrument are not in conflict with each other:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* Check that all control volumes are sufficient for an accurate measurement by the instrument *)
	lowControlVolumeWarningConflictOptions=Cases[ToList[Lookup[allOptionsRounded,ControlVolume]],LessP[First[Lookup[instrumentPacket,MinSampleVolume]]]];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	lowControlVolumeWarningOptions=If[Length[lowControlVolumeWarningConflictOptions]>0,
		(* Store the errant options for later InvalidOption checks *)
		{ControlVolume,Instrument},
		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[Length[lowControlVolumeWarningConflictOptions]>0&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::OsmolalityLowControlVolume,lowControlVolumeWarningConflictOptions,ObjectToString[Lookup[allOptionsRounded,Instrument],Simulation -> updatedSimulation],First[Lookup[instrumentPacket,MinSampleVolume]]]
	];

	(* Build a test for whether the sample volumes are above the minimum recommended for the instrument *)
	lowControlVolumeWarningTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[lowControlVolumeWarningConflictOptions]==0,
				Nothing,
				Test["The provided values for ControlVolumes and Instrument are not in conflict with each other:",
					True,
					False
				]
			];

			passingTest=If[Length[lowControlVolumeWarningConflictOptions]!=0,
				Nothing,
				Test["The provided values for ControlVolumes and Instrument are not in conflict with each other:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Check that all specified numbers of readings are compatible with the instrument *)
	readingsExceedsMaximumConflicts=MapThread[
		If[#1>32,
			{#1,#2},
			Nothing
		]&,
		{Lookup[allOptionsRounded,NumberOfReadings],ToList[simulatedSamples]}
	];

	(* Transpose our result if there were mismatches. *)
	{readingsExceedsMaximumConflictOptions,readingsExceedsMaximumConflictInputs}=If[MatchQ[readingsExceedsMaximumConflicts,{}],
		{{},{}},
		Transpose[readingsExceedsMaximumConflicts]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	readingsExceedsMaximumInvalidOptions=If[Length[readingsExceedsMaximumConflictOptions]>0,
		(* Store the errant options for later InvalidOption checks *)
		{NumberOfReadings,Instrument},
		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[Length[readingsExceedsMaximumConflictOptions]>0&&!gatherTests,
		Message[Error::OsmolalityReadingsExceedsMaximum,ObjectToString[readingsExceedsMaximumConflictInputs,Simulation -> updatedSimulation],readingsExceedsMaximumConflictOptions,ObjectToString[Lookup[allOptionsRounded,Instrument],Simulation -> updatedSimulation],32]
	];

	(* Build a test for whether the sample volumes are above the minimum recommended for the instrument *)
	readingsExceedsMaximumInvalidTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[readingsExceedsMaximumConflictOptions]==0,
				Nothing,
				Test["The provided values for NumberOfReadings and Instrument are not in conflict with each other:",
					True,
					False
				]
			];

			passingTest=If[Length[readingsExceedsMaximumConflictOptions]!=0,
				Nothing,
				Test["The provided values for NumberOfReadings and Instrument are not in conflict with each other:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* Check that the equilibration times are compatible with the number of readings *)
	equilibrationTimeReadingsConflicts=MapThread[
		If[MatchQ[{#2,#1},{Except[Alternatives[1,10]],InternalDefault}],
			{{#1,#2},#3},
			Nothing
		]&,
		{Lookup[allOptionsRounded,EquilibrationTime],Lookup[allOptionsRounded,NumberOfReadings],ToList[simulatedSamples]}
	];

	(* Transpose our result if there were mismatches. *)
	{equilibrationTimeReadingsConflictOptions,equilibrationTimeReadingsConflictInputs}=If[MatchQ[equilibrationTimeReadingsConflicts,{}],
		{{},{}},
		Transpose[equilibrationTimeReadingsConflicts]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	equilibrationTimeReadingsInvalidOptions=If[Length[equilibrationTimeReadingsConflictOptions]>0,
		(* Store the errant options for later InvalidOption checks *)
		{EquilibrationTime,NumberOfReadings},
		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* If there are invalid options and we are throwing error, throw an error *)
	If[Length[equilibrationTimeReadingsConflictOptions]>0&&!gatherTests,
		Message[Error::OsmolalityEquilibrationTimeReadings,ObjectToString[equilibrationTimeReadingsConflictInputs,Simulation -> updatedSimulation],equilibrationTimeReadingsConflictOptions,ObjectToString[Lookup[allOptionsRounded,Instrument],Simulation -> updatedSimulation]]
	];

	(* Build a test for whether the sample volumes are above the minimum recommended for the instrument *)
	equilibrationTimeReadingsInvalidTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[equilibrationTimeReadingsConflictOptions]==0,
				Nothing,
				Test["The provided values for NumberOfReadings and EquilibrationTime are not in conflict with each other:",
					True,
					False
				]
			];

			passingTest=If[Length[equilibrationTimeReadingsConflictOptions]!=0,
				Nothing,
				Test["The provided values for NumberOfReadings and EquilibrationTime are not in conflict with each other:",
					True,
					True
				]
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(* Options already defaulted *)
	{
		name,osmolalityMethod,instrument,numberOfReplicates,preClean,cleaningSolution,
		calibrantVolume,sampleVolume,numberOfReadings,postRunInstrumentContaminationLevel
	}=Lookup[allOptionsRounded,
		{
			Name,OsmolalityMethod,Instrument,NumberOfReplicates,PreClean,CleaningSolution,
			CalibrantVolume,SampleVolume,NumberOfReadings,PostRunInstrumentContaminationLevel
		},
		Null
	];

	(* Options to be resolved outside of Map Thread *)
	(* Resolve the cleaning solution *)
	resolvedCleaningSolution=If[MatchQ[cleaningSolution,Automatic],
		Download[First[Lookup[instrumentPacket,ManufacturerCleaningSolution]],Object,Simulation -> updatedSimulation],
		cleaningSolution
	];

	(* Resolve the calibrants *)
	resolvedCalibrants=If[MatchQ[calibrants,ListableP[Automatic]],
		Download[First@Lookup[instrumentPacket,ManufacturerCalibrants],Object],
		calibrants
	];

	(* Resolve the calibrant osmolalities *)
	resolvedCalibrantOsmolalities=If[MatchQ[calibrantOsmolalities,ListableP[Automatic]],
		First@Lookup[instrumentPacket,ManufacturerCalibrantOsmolalities],
		calibrantOsmolalities
	];

	(* Resolve the control - use the first of the calibrants if not specified *)
	resolvedControls=If[MatchQ[controls,ListableP[Automatic]],
		{First[resolvedCalibrants]},
		controls/.{Null}->{}
	];

	(* Resolve the control volumes *)
	resolvedControlVolumes=If[MatchQ[resolvedControls,{}],
		{},
		controlVolumes/.(Automatic->10 Microliter)
	];

	(* Resolve the number of calibration attempts *)
	resolvedMaxNumberOfCalibrations=Which[
		(* If automatic and we have no controls, set to 1 *)
		MatchQ[maxNumberOfCalibrations,Automatic]&&MatchQ[resolvedControls,{}],
		1,
		(* Otherwise if it's automatic, set to 3 *)
		MatchQ[maxNumberOfCalibrations,Automatic],
		3,
		(* Otherwise, use the user value *)
		True,
		maxNumberOfCalibrations
	];

	(* Get all of the control models *)
	resolvedControlsModels=resolvedControls/.(x:ObjectP[Object[Sample]]:>Download[x,Model[Object],Cache->controlsObjectsPackets]);

	(* Known osmolality standards - move to the database when supported *)
	(* lookup table for the models -> known concentration *)
	osmolalityLookupTable={
		(* Calibrants *)
		ObjectP[Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]]->100 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"]]->290 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]]->1000 Millimole/Kilogram,

		(*from the kit: Object[Product, "Advanced Instruments Osmolality Standards Linearity Set Sodium Chloride"]*)
		ObjectP[Model[Sample,"Osmolality Linearity Standard 100 mmol/kg Sodium Chloride"]]->100 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Linearity Standard 500 mmol/kg Sodium Chloride"]]->500 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Linearity Standard 900 mmol/kg Sodium Chloride"]]->900 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Linearity Standard 1500 mmol/kg Sodium Chloride"]]->1500 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Linearity Standard 2000 mmol/kg Sodium Chloride"]]->2000 Millimole/Kilogram,

		(*Object[Product, "Advanced Instruments Osmolality Standards Protein-Based"]*)
		ObjectP[Model[Sample,"Osmolality Standard 240 mmol/kg Protein Based"]]->240 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Standard 280 mmol/kg Protein Based"]]->280 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Standard 320 mmol/kg Protein Based"]]->320 Millimole/Kilogram,

		(* Object[Product, "Advanced Instruments Osmolality Standards Urine-Based"] *)
		ObjectP[Model[Sample,"Osmolality Standard 300 mmol/kg Urine Based"]]->300 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Standard 800 mmol/kg Urine Based"]]->800 Millimole/Kilogram
	};


	(* lookup table for the models -> manufacturing tolerance *)
	osmolalityToleranceLookupTable={
		(* Calibrants *)
		ObjectP[Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]]->2 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"]]->3 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]]->5 Millimole/Kilogram,

		(*from the kit: Object[Product, "Advanced Instruments Osmolality Standards Linearity Set Sodium Chloride"]*)
		ObjectP[Model[Sample,"Osmolality Linearity Standard 100 mmol/kg Sodium Chloride"]]->2 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Linearity Standard 500 mmol/kg Sodium Chloride"]]->2.5 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Linearity Standard 900 mmol/kg Sodium Chloride"]]->4.5 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Linearity Standard 1500 mmol/kg Sodium Chloride"]]->7.5 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Linearity Standard 2000 mmol/kg Sodium Chloride"]]->10.0 Millimole/Kilogram,

		(*Object[Product, "Advanced Instruments Osmolality Standards Protein-Based"]*)
		ObjectP[Model[Sample,"Osmolality Standard 240 mmol/kg Protein Based"]]->7.0 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Standard 280 mmol/kg Protein Based"]]->7.0 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Standard 320 mmol/kg Protein Based"]]->7.0 Millimole/Kilogram,

		(* Object[Product, "Advanced Instruments Osmolality Standards Urine-Based"] *)
		ObjectP[Model[Sample,"Osmolality Standard 300 mmol/kg Urine Based"]]->10.0 Millimole/Kilogram,
		ObjectP[Model[Sample,"Osmolality Standard 800 mmol/kg Urine Based"]]->10.0 Millimole/Kilogram
	};

	(* Check if each control is a known standard *)
	knownControlsQ=MatchQ[#,Alternatives@@Keys[osmolalityLookupTable]]&/@resolvedControlsModels;

	(* Check if each control is used in the calibration *)
	controlUsedForCalibrationQ=MatchQ[#,ObjectP[resolvedCalibrants]]&/@resolvedControlsModels;

	(* Error check and resolve the control osmolalities *)
	{
		resolvedControlOsmolalities,
		controlOsmolalityDeviationWarnings,failingControlOsmolalityDeviationVars,
		controlOsmolalityUnknownErrors,failingControlOsmolalityUnknownVars
	}=If[!MatchQ[resolvedControls,{}],
		Transpose@MapThread[
			Function[
				{control,osmolality,knownQ},
				Switch[{knownQ,osmolality},

					(* If control osmolality is specified, and it's not a known calibrant, proceed *)
					{False,GreaterEqualP[0 Millimole/Kilogram]},
					{
						osmolality,
						False,{Null,{}},
						False,{Null,{}}
					},

					(* If the control osmolality is specified, it's a known calibrant, and it agrees with the database value (within 5 %), proceed *)
					{True,RangeP[(control/.osmolalityLookupTable)*0.95,(control/.osmolalityLookupTable)*1.05]},
					{
						osmolality,
						False,{Null,{}},
						False,{Null,{}}
					},

					(* If the control osmolality is not specified and it's a known calibrant, set the database value *)
					{True,Automatic},
					{
						control/.osmolalityLookupTable,
						False,{Null,{}},
						False,{Null,{}}
					},

					(* If the control osmolality is specified, it's a known calibrant, and it disagrees with the database value (within 5 %), throw a warning *)
					{True,_},
					{
						osmolality,
						True,{control,{osmolality,control/.osmolalityLookupTable}},
						False,{Null,{}}
					},

					(* Otherwise, the control osmolality wasn't specified and it's an unknown calibrant, so we must throw an error *)
					{_,_},
					{
						Null,
						False,{Null,{}},
						True,{control,{osmolality}}
					}
				]
			],
			{resolvedControlsModels,ToList[controlOsmolalities],knownControlsQ}
		],
		{
			{},
			{False},{{Null,{}}},
			{False},{{Null,{}}}
		}
	];

	(* Resolve the number of control replicates *)
	resolvedNumberOfControlReplicates=If[MatchQ[resolvedControls,{}|{Null}],Null,numberOfControlReplicates/.Automatic->1];

	(* Error check and resolve the control tolerances *)
	{
		resolvedControlTolerances,
		controlToleranceWarnings,failingControlToleranceVars
	}=If[!MatchQ[resolvedControls,{}],
		Transpose@MapThread[
			Function[
				{control,tolerance,knownQ,calibrantQ},
				Module[{instrumentRepeatabilityDoubled,computedPrecision,calibrantTolerances,controlTolerance},
					(* Compute the precision we can get - sum uncertainties in quadrature *)
					instrumentRepeatabilityDoubled=2*Lookup[instrumentPacket[[1]],ManufacturerOsmolalityRepeatability];
					calibrantTolerances=If[calibrantQ,0 Millimole/Kilogram,Replace[Max[calibrants/.osmolalityToleranceLookupTable],(Except[GreaterP[0 Millimole/Kilogram]]->3 Millimole/Kilogram)]];
					controlTolerance=If[calibrantQ,0 Millimole/Kilogram,Replace[control/.osmolalityToleranceLookupTable,(Except[GreaterP[0 Millimole/Kilogram]]->5 Millimole/Kilogram)]];

					computedPrecision=Sqrt[Total[{
						(* 2 x Instrument repeatability *)
						instrumentRepeatabilityDoubled,
						(* Calibrant uncertainty *)
						calibrantTolerances,
						(* Control uncertainty *)
						controlTolerance
					}^2]];

					Switch[{knownQ,tolerance},

						(* If control tolerance is specified, and it's not a known calibrant, and it's wider than the precision threshold, proceed *)
						{False,GreaterEqualP[computedPrecision]},
						{
							tolerance,
							False,{Null,{}}
						},

						(* If control tolerance is specified, and it's not a known calibrant, and it's less than the precision threshold, throw a warning about instrument precision *)
						{False,LessP[computedPrecision]},
						{
							tolerance,
							True,{control,{tolerance,computedPrecision,instrumentRepeatabilityDoubled,calibrantTolerances,controlTolerance}}
						},

						(* If the control tolerance is specified, it's a known calibrant, and it's wider than the precision threshold, proceed *)
						{True,GreaterEqualP[computedPrecision]},
						{
							tolerance,
							False,{Null,{}}
						},

						(* If the control tolerance is not specified and it's a known calibrant, set the database value + instrument repeatability *)
						{True,Automatic},
						{
							computedPrecision,
							False,{Null,{}}
						},

						(* If the control tolerance is specified, it's a known calibrant, and it disagrees with the database value + instrument repeatability, throw a warning *)
						{True,LessP[computedPrecision]},
						{
							tolerance,
							True,{control,{tolerance,computedPrecision,instrumentRepeatabilityDoubled,calibrantTolerances,controlTolerance}}
						},

						(* Otherwise it means we have an unknown calibrant and the threshold hasn't been specified, so set the default *)
						{_,_},
						{
							tolerance,
							False,{Null,{}}
						}
					]]
			],
			{resolvedControlsModels,controlTolerances,knownControlsQ,controlUsedForCalibrationQ}
		],
		{
			{},
			{False},{{Null,{}}}
		}
	];


	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentMeasureOsmolality,allOptionsRounded];

	(* Map Thread *)
	{
		(* Resolved variables *)
		resolvedSampleViscosities,
		resolvedViscousLoadings,
		resolvedInoculationPapers,
		resolvedEquilibrationTimes,

		(* Set up error tracking booleans *)
		unknownViscosityWarnings,
		transferHighViscosityErrors,
		sampleCarryOverWarnings,
		noInoculationPaperWarnings,
		viscousTransferMinimumVolumeWarnings,
		inoculationPaperHighViscosityWarnings,
		shortEquilibrationTimeWarnings,

		failingUnknownViscosityVars,
		failingTransferHighViscosityVars,
		failingSampleCarryOverVars,
		failingNoInoculationPaperVars,
		failingViscousTransferMinimumVolumeVars,
		failingInoculationPaperHighViscosityVars,
		failingShortEquilibrationTimeVars
	}=Transpose@MapThread[
		Function[{myMapThreadFriendlyOptions,mySample},
			Module[{
				(* Variables for resolving *)
				viscousSample,
				viscousLoading,
				inoculationPaper,
				equilibrationTime,
				mySampleObject,
				(* Error tracking Booleans *)
				unknownViscosityWarning,
				transferHighViscosityError,
				sampleCarryOverWarning,
				noInoculationPaperWarning,
				inoculationPaperHighViscosityWarning,
				viscousTransferMinimumVolumeWarning,
				shortEquilibrationTimeWarning,
				(* Failing Options *)
				failingUnknownViscosity,
				failingTransferHighViscosity,
				failingSampleCarryOver,
				failingNoInoculationPaper,
				failingInoculationPaperHighViscosity,
				failingViscousTransferMinimumVolume,
				failingShortEquilibrationTime,
				(* Supplied option values *)
				supViscousLoading,
				supInoculationPaper,
				supEquilibrationTime,
				supNumberOfReadings,
				supSampleVolume
			},

				(* Initialize our error tracking variables *)
				{
					unknownViscosityWarning,
					transferHighViscosityError,
					sampleCarryOverWarning,
					inoculationPaperHighViscosityWarning,
					viscousTransferMinimumVolumeWarning
				}=ConstantArray[False,5];

				(* Store our options in their variables *)
				{
					supViscousLoading,
					supInoculationPaper,
					supEquilibrationTime,
					supSampleVolume,
					supNumberOfReadings
				}=Lookup[myMapThreadFriendlyOptions,
					{
						ViscousLoading,
						InoculationPaper,
						EquilibrationTime,
						SampleVolume,
						NumberOfReadings
					}
				];

				(* Shortcut to sample object *)
				mySampleObject=Lookup[mySample,Object];

				(* Resolve sample loading options *)

				(* Check sample viscosity *)
				viscousSample=Switch[Lookup[mySample,Viscosity,Null],

					(* If viscosity cannot be determined *)
					Null,Null,

					(* Low viscosity *)
					RangeP[0 Milli Pascal Second,200 Milli Pascal Second],False,

					(* High viscosity *)
					GreaterEqualP[200 Milli Pascal Second],True,

					(* Catch errors in stored data - this option shouldn't be triggered *)
					_,Null
				];

				(* Viscous loading Master Switch *)
				{
					viscousLoading,
					unknownViscosityWarning,failingUnknownViscosity,
					sampleCarryOverWarning,failingSampleCarryOver,
					transferHighViscosityError,failingTransferHighViscosity
				}=Switch[supViscousLoading,

					(* Resolve ViscousLoading set to Automatic *)
					Automatic,

					(* If sample is viscous, set Viscous Loading to True, else set to false *)
					Switch[viscousSample,

						(* Sample is unknown viscosity, set standard loading and set warning boolean *)
						Null,
						{
							False,
							True,{mySampleObject,{supViscousLoading}},
							False,{Null,{}},
							False,{Null,{}}
						},

						(* Sample is not viscous, set standard loading *)
						False,
						{
							False,
							False,{Null,{}},
							False,{Null,{}},
							False,{Null,{}}
						},

						(* Sample is viscous, set viscous loading *)
						True,
						{
							True,
							False,{Null,{}},
							False,{Null,{}},
							False,{Null,{}}
						}
					],


					(* Error check if ViscousLoading set to True *)
					True,

					(* If sample is not viscous, warn of increased carry over contamination *)
					{
						supViscousLoading,
						False,{Null,{}},
						TrueQ[!viscousSample],If[TrueQ[!viscousSample],{mySampleObject,{supViscousLoading}},{Null,{}}],
						False,{Null,{}}
					},


					(* Error check if ViscousLoading set to False *)
					False,

					(* If sample is viscous, raise error for increased risk of instrument contamination *)
					{
						supViscousLoading,
						False,{Null,{}},
						False,{Null,{}},
						TrueQ[viscousSample],If[TrueQ[viscousSample],{mySampleObject,{supViscousLoading}},{Null,{}}]
					}
				];

				(* Log conflict warning if viscous loading is true, but sample volume is less than 10 uL. No positive displacement
				 pipette can currently transfer accurately below 10 uL of sample *)
				viscousTransferMinimumVolumeWarning=And[TrueQ[viscousLoading]&&MatchQ[supSampleVolume,LessP[10 Microliter]]];

				(* Track Error variables for loading/sample volume error *)
				failingViscousTransferMinimumVolume=If[viscousTransferMinimumVolumeWarning,
					{mySampleObject,{supSampleVolume}},
					{Null,{}}
				];


				(* Resolve inoculation paper based on viscous loading *)
				{
					inoculationPaper,
					inoculationPaperHighViscosityWarning,failingInoculationPaperHighViscosity,
					noInoculationPaperWarning,failingNoInoculationPaper
				}=If[TrueQ[viscousLoading],

					(* If viscous loading has resolved to True, resolve inoculation paper or set warnings *)
					Switch[supInoculationPaper,

						(* Automatic InoculationPaper, resolve to Null *)
						Automatic,
						{
							Null,
							False,{Null,{}},
							False,{Null,{}}
						},

						(* Null InoculationPaper, set to supplied value *)
						Null,
						{
							supInoculationPaper,
							False,{Null,{}},
							False,{Null,{}}
						},

						(* Not null Inoculation paper, warn that Inoculation Paper and Viscous Samples may be unsuitable *)
						Except[Null],
						{
							supInoculationPaper,
							True,{mySampleObject,{viscousLoading,supInoculationPaper}},
							False,{Null,{}}
						}

					],

					(* If viscous loading has resolved to False, resolve inoculation paper *)
					Switch[supInoculationPaper,

						(* Automatic InoculationPaper, resolve to default paper type *)
						Automatic,
						{
							Model[Item,InoculationPaper,"6.7mm diameter solute free paper"],
							False,{Null,{}},
							False,{Null,{}}
						},

						(* Null InoculationPaper, warn that inoculation paper is recommended for a non-viscous sample *)
						Null,
						{
							supInoculationPaper,
							False,{Null,{}},
							True,{mySampleObject,{viscousLoading,supInoculationPaper}}
						},

						(* Not null Inoculation paper, no problem *)
						Except[Null],
						{
							supInoculationPaper,
							False,{Null,{}},
							False,{Null,{}}
						}

					]
				];

				(* Resolve EquilibrationTime *)
				equilibrationTime=If[MatchQ[supEquilibrationTime,Automatic],

					(* Resolve equilibration time *)
					Which[

						(* If the number of readings is 1 or 10, use the instrument default time *)
						MatchQ[supNumberOfReadings,Alternatives[1,10]],
						InternalDefault,

						(* If it's a custom number of readings, set equilibration time explicitly based on viscosity *)
						TrueQ[viscousSample],
						60 Second,

						!TrueQ[viscousSample],
						60 Second

					],

					(* If equilibration time is set by the user, set the supplied value *)
					supEquilibrationTime
				];

				(* Warn for short equilibration times *)
				{
					shortEquilibrationTimeWarning,
					failingShortEquilibrationTime
				}=If[
					(* If the equilibration time is numeric and less than 10 seconds *)
					MatchQ[equilibrationTime,LessP[10 Second]],

					(* Return the warning for a short equilibration time *)
					{True,{mySampleObject,{instrument,equilibrationTime}}},

					(* Else don't raise an error *)
					{False,{Null,{}}}
				];


				(* Gather map thread results *)
				{
					(* Resolved variables *)
					viscousSample,
					viscousLoading,
					inoculationPaper,
					equilibrationTime,

					(* Error tracking booleans. Silence if sample is solid, else return the failures *)
					Sequence@@If[MatchQ[Lookup[mySample,State],Except[Liquid]],
						ConstantArray[False,6],
						{
							unknownViscosityWarning,
							transferHighViscosityError,
							sampleCarryOverWarning,
							noInoculationPaperWarning,
							viscousTransferMinimumVolumeWarning,
							inoculationPaperHighViscosityWarning
						}
					],
					shortEquilibrationTimeWarning,

					(* Failing options for error tracking. Silence if sample is solid, else return the failures *)
					Sequence@@If[MatchQ[Lookup[mySample,State],Except[Liquid]],
						ConstantArray[{Null,{}},6],
						{
							failingUnknownViscosity,
							failingTransferHighViscosity,
							failingSampleCarryOver,
							failingNoInoculationPaper,
							failingViscousTransferMinimumVolume,
							failingInoculationPaperHighViscosity
						}
					],
					failingShortEquilibrationTime
				}
			]
		],
		(* MapThread over index-matched lists *)
		{mapThreadFriendlyOptions,samplePackets}
	];


	(* Parse the error variables *)
	{failingUnknownViscosityInputs,failingUnknownViscosityOptions}=Transpose[failingUnknownViscosityVars]/.{Null->Nothing,{}->Nothing};
	{failingTransferHighViscosityInputs,failingTransferHighViscosityOptions}=Transpose[failingTransferHighViscosityVars]/.{Null->Nothing,{}->Nothing};
	{failingSampleCarryOverInputs,failingSampleCarryOverOptions}=Transpose[failingSampleCarryOverVars]/.{Null->Nothing,{}->Nothing};
	{failingNoInoculationPaperInputs,failingNoInoculationPaperOptions}=Transpose[failingNoInoculationPaperVars]/.{Null->Nothing,{}->Nothing};
	{failingViscousTransferMinimumVolumeInputs,failingViscousTransferMinimumVolumeOptions}=Transpose[failingViscousTransferMinimumVolumeVars]/.{Null->Nothing,{}->Nothing};
	{failingInoculationPaperHighViscosityInputs,failingInoculationPaperHighViscosityOptions}=Transpose[failingInoculationPaperHighViscosityVars]/.{Null->Nothing,{}->Nothing};
	{failingShortEquilibrationTimeInputs,failingShortEquilibrationTimeOptions}=Transpose[failingShortEquilibrationTimeVars]/.{Null->Nothing,{}->Nothing};

	(* For the controls *)
	{failingControlOsmolalityDeviationInputs,failingControlOsmolalityDeviationOptions}=Transpose[failingControlOsmolalityDeviationVars]/.{Null->Nothing,{}->Nothing};
	{failingControlOsmolalityUnknownInputs,failingControlOsmolalityUnknownOptions}=Transpose[failingControlOsmolalityUnknownVars]/.{Null->Nothing,{}->Nothing};
	{failingControlToleranceInputs,failingControlToleranceOptions}=Transpose[failingControlToleranceVars]/.{Null->Nothing,{}->Nothing};



	(* Generate errors and warnings from the map thread *)

	(* 1 Unknown viscosity warning *)
	If[MemberQ[unknownViscosityWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::OsmolalityUnknownViscosity,ObjectToString[failingUnknownViscosityInputs,Simulation -> updatedSimulation]]
	];

	(* Generate the tests *)
	unknownViscosityWarningTests=If[gatherTests,
		Module[{failingSamples,failingViscosities,passingSamples,passingViscosities,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,unknownViscosityWarnings];
			failingViscosities=PickList[resolvedSampleViscosities,unknownViscosityWarnings];

			(* get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,unknownViscosityWarnings,False];
			passingViscosities=PickList[resolvedSampleViscosities,unknownViscosityWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Simulation -> updatedSimulation]<>", if viscous loading is not specified, the viscosity field ("<>ObjectToString[failingViscosities,Simulation -> updatedSimulation]<>") is populated:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Simulation -> updatedSimulation]<>", if viscous loading is not specified, the viscosity field ("<>ObjectToString[passingViscosities,Simulation -> updatedSimulation]<>") is populated:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Stash the failing options for this error *)
	unknownViscosityParameterWarningOptions=If[MemberQ[unknownViscosityWarnings,True],
		{ViscousLoading},
		Nothing
	];


	(* 2 Transfer high viscosity error *)
	If[MemberQ[transferHighViscosityErrors,True]&&!gatherTests,
		Message[Error::OsmolalityTransferHighViscosity,ObjectToString[failingTransferHighViscosityInputs,Simulation -> updatedSimulation]]
	];

	(* Generate the tests *)
	transferHighViscosityErrorTests=If[gatherTests,
		Module[{failingSamples,failingViscosities,failingViscousLoadings,passingSamples,passingViscosities,passingViscousLoadings,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,transferHighViscosityErrors];
			failingViscosities=PickList[resolvedSampleViscosities,transferHighViscosityErrors];
			failingViscousLoadings=PickList[resolvedViscousLoadings,transferHighViscosityErrors];

			(* get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,transferHighViscosityErrors,False];
			passingViscosities=PickList[resolvedSampleViscosities,transferHighViscosityErrors,False];
			passingViscousLoadings=PickList[resolvedViscousLoadings,transferHighViscosityErrors,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Simulation -> updatedSimulation]<>", the value for viscous loading, "<>ObjectToString[failingViscousLoadings,Simulation -> updatedSimulation]<>", is True if the sample is high viscosity ("<>ObjectToString[failingViscosities,Simulation -> updatedSimulation]<>"):",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Simulation -> updatedSimulation]<>", the value for viscous loading, "<>ObjectToString[passingViscousLoadings,Simulation -> updatedSimulation]<>", is True if the sample is high viscosity ("<>ObjectToString[passingViscosities,Simulation -> updatedSimulation]<>"):",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Stash the failing options for this error *)
	transferHighViscosityParameterErrorOptions=If[MemberQ[transferHighViscosityErrors,True],
		{ViscousLoading},
		Nothing
	];


	(* 3 Sample carry over warning *)
	If[MemberQ[sampleCarryOverWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::OsmolalitySampleCarryOver,ObjectToString[failingSampleCarryOverInputs,Simulation -> updatedSimulation]]
	];

	(* Generate the tests *)
	sampleCarryOverWarningTests=If[gatherTests,
		Module[{failingSamples,failingViscosities,failingViscousLoadings,passingSamples,passingViscosities,passingViscousLoadings,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,sampleCarryOverWarnings];
			failingViscosities=PickList[resolvedSampleViscosities,sampleCarryOverWarnings];
			failingViscousLoadings=PickList[resolvedViscousLoadings,sampleCarryOverWarnings];

			(* get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,sampleCarryOverWarnings,False];
			passingViscosities=PickList[resolvedSampleViscosities,sampleCarryOverWarnings,False];
			passingViscousLoadings=PickList[resolvedViscousLoadings,sampleCarryOverWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Simulation -> updatedSimulation]<>", the value for viscous loading, "<>ObjectToString[failingViscousLoadings,Simulation -> updatedSimulation]<>", is False if the sample viscosity "<>ObjectToString[failingViscosities,Simulation -> updatedSimulation]<>" is False:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Simulation -> updatedSimulation]<>", the value for viscous loading, "<>ObjectToString[passingViscousLoadings,Simulation -> updatedSimulation]<>", is False if the sample viscosity "<>ObjectToString[passingViscosities,Simulation -> updatedSimulation]<>" is False:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Stash the failing options for this error *)
	sampleCarryOverParameterWarningOptions=If[MemberQ[sampleCarryOverWarnings,True],
		{ViscousLoading},
		Nothing
	];


	(* 4 No inoculation paper warning *)
	If[MemberQ[noInoculationPaperWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::OsmolalityNoInoculationPaper,ObjectToString[failingNoInoculationPaperInputs,Simulation -> updatedSimulation]]
	];

	(* Generate the tests *)
	noInoculationPaperWarningTests=If[gatherTests,
		Module[{failingSamples,failingInoculationPapers,failingViscousLoadings,passingSamples,passingInoculationPapers,passingViscousLoadings,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,noInoculationPaperWarnings];
			failingInoculationPapers=PickList[resolvedInoculationPapers,noInoculationPaperWarnings];
			failingViscousLoadings=PickList[resolvedViscousLoadings,noInoculationPaperWarnings];

			(* get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,noInoculationPaperWarnings,False];
			passingInoculationPapers=PickList[resolvedInoculationPapers,noInoculationPaperWarnings,False];
			passingViscousLoadings=PickList[resolvedViscousLoadings,noInoculationPaperWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Simulation -> updatedSimulation]<>", the value for inoculation paper, "<>ObjectToString[failingInoculationPapers,Simulation -> updatedSimulation]<>" is not Null if viscous loading "<>ObjectToString[failingViscousLoadings,Simulation -> updatedSimulation]<>" is False:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Simulation -> updatedSimulation]<>", the value for inoculation paper, "<>ObjectToString[passingInoculationPapers,Simulation -> updatedSimulation]<>" is not Null if viscous loading "<>ObjectToString[passingViscousLoadings,Simulation -> updatedSimulation]<>" is False:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Stash the failing options for this error *)
	noInoculationPaperParameterWarningOptions=If[MemberQ[noInoculationPaperWarnings,True],
		{ViscousLoading,InoculationPaper},
		Nothing
	];


	(* 5 viscous loading, low sample volume warning *)
	If[MemberQ[viscousTransferMinimumVolumeWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::OsmolalityViscousTransferMinimumVolume,ObjectToString[failingViscousTransferMinimumVolumeInputs,Simulation -> updatedSimulation],First/@failingViscousTransferMinimumVolumeOptions]
	];

	(* Generate the tests *)
	viscousTransferMinimumVolumeWarningTests=If[gatherTests,
		Module[{failingSamples,failingSampleVolumes,failingViscousLoadings,passingSamples,passingSampleVolumes,passingViscousLoadings,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,viscousTransferMinimumVolumeWarnings];
			failingSampleVolumes=PickList[sampleVolume,viscousTransferMinimumVolumeWarnings];
			failingViscousLoadings=PickList[resolvedViscousLoadings,viscousTransferMinimumVolumeWarnings];

			(* get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,viscousTransferMinimumVolumeWarnings,False];
			passingSampleVolumes=PickList[sampleVolume,viscousTransferMinimumVolumeWarnings,False];
			passingViscousLoadings=PickList[resolvedViscousLoadings,viscousTransferMinimumVolumeWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Simulation -> updatedSimulation]<>", the sample volume, "<>ObjectToString[failingSampleVolumes,Simulation -> updatedSimulation]<>" is greater or equal to 10 uL if viscous loading "<>ObjectToString[failingViscousLoadings,Simulation -> updatedSimulation]<>" is True:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Simulation -> updatedSimulation]<>", the sample volume, "<>ObjectToString[passingSampleVolumes,Simulation -> updatedSimulation]<>" is greater or equal to 10 uL if viscous loading "<>ObjectToString[passingViscousLoadings,Simulation -> updatedSimulation]<>" is True:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Stash the failing options for this error *)
	viscousTransferMinimumVolumeOptions=If[MemberQ[viscousTransferMinimumVolumeWarnings,True],
		{SampleVolume,ViscousLoading},
		Nothing
	];


	(* 6 inoculation paper high viscosity warning *)
	If[MemberQ[inoculationPaperHighViscosityWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::OsmolalityInoculationPaperHighViscosity,ObjectToString[failingInoculationPaperHighViscosityInputs,Simulation -> updatedSimulation]]
	];

	(* Generate the tests *)
	inoculationPaperHighViscosityWarningTests=If[gatherTests,
		Module[{failingSamples,failingInoculationPapers,failingViscousLoadings,passingSamples,passingInoculationPapers,passingViscousLoadings,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,inoculationPaperHighViscosityWarnings];
			failingInoculationPapers=PickList[resolvedInoculationPapers,inoculationPaperHighViscosityWarnings];
			failingViscousLoadings=PickList[resolvedViscousLoadings,inoculationPaperHighViscosityWarnings];

			(* get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,inoculationPaperHighViscosityWarnings,False];
			passingInoculationPapers=PickList[resolvedInoculationPapers,inoculationPaperHighViscosityWarnings,False];
			passingViscousLoadings=PickList[resolvedViscousLoadings,inoculationPaperHighViscosityWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Simulation -> updatedSimulation]<>", the value for inoculation paper, "<>ObjectToString[failingInoculationPapers,Simulation -> updatedSimulation]<>" is Null if viscous loading "<>ObjectToString[failingViscousLoadings,Simulation -> updatedSimulation]<>" is True:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Simulation -> updatedSimulation]<>", the value for inoculation paper, "<>ObjectToString[passingInoculationPapers,Simulation -> updatedSimulation]<>" is Null if viscous loading "<>ObjectToString[passingViscousLoadings,Simulation -> updatedSimulation]<>" is True:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Stash the failing options for this error *)
	inoculationPaperHighViscosityParameterWarningOptions=If[MemberQ[inoculationPaperHighViscosityWarnings,True],
		{ViscousLoading,InoculationPaper},
		Nothing
	];


	(* 7 short equilibration time warning *)
	If[MemberQ[shortEquilibrationTimeWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		(* Reorganize failing options *)
		{failingShortEquilibrationTimeInstruments,failingShortEquilibrationTimeTimes}=Transpose[failingShortEquilibrationTimeOptions];
		Message[Warning::OsmolalityShortEquilibrationTime,ObjectToString[failingShortEquilibrationTimeInputs,Simulation -> updatedSimulation],ObjectToString[Lookup[allOptionsRounded,Instrument],Simulation -> updatedSimulation],failingShortEquilibrationTimeTimes]
	];

	(* Generate the tests *)
	shortEquilibrationTimeWarningTests=If[gatherTests,
		Module[{failingSamples,failingEquilibrationTimes,passingSamples,passingEquilibrationTimes,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[simulatedSamples,shortEquilibrationTimeWarnings];
			failingEquilibrationTimes=PickList[resolvedEquilibrationTimes,shortEquilibrationTimeWarnings];

			(* get the inputs that pass this test *)
			passingSamples=PickList[simulatedSamples,shortEquilibrationTimeWarnings,False];
			passingEquilibrationTimes=PickList[resolvedEquilibrationTimes,shortEquilibrationTimeWarnings,False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>ObjectToString[failingSamples,Simulation -> updatedSimulation]<>", the value for equilibration time, "<>ObjectToString[failingEquilibrationTimes,Simulation -> updatedSimulation]<>" is more than 10 seconds when the instrument is "<>ObjectToString[instrument,Simulation -> updatedSimulation],
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>ObjectToString[passingSamples,Simulation -> updatedSimulation]<>", the value for equilibration time, "<>ObjectToString[passingEquilibrationTimes,Simulation -> updatedSimulation]<>" is more than 10 seconds when the instrument is "<>ObjectToString[instrument,Simulation -> updatedSimulation],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Stash the failing options for this error *)
	shortEquilibrationTimeWarningOptions=If[MemberQ[shortEquilibrationTimeWarnings,True],
		{Instrument,EquilibrationTimes},
		Nothing
	];

	(* Control warnings *)

	(* 8 Warn that the target osmolality given for a control differs from the db value *)
	If[MemberQ[controlOsmolalityDeviationWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::OsmolalityControlOsmolalityDeviation,ObjectToString[failingControlOsmolalityDeviationInputs,Simulation -> updatedSimulation],First/@failingControlOsmolalityDeviationOptions,Last/@failingControlOsmolalityDeviationOptions]
	];

	(* Generate the tests *)
	controlOsmolalityDeviationWarningTests=If[gatherTests,
		Module[{failingControls,failingOsmolalities,passingControls,passingOsmolalities,failingControlTests,passingControlTests},

			(* get the inputs that fail this test *)
			failingControls=PickList[resolvedControls,controlOsmolalityDeviationWarnings];
			failingOsmolalities=PickList[resolvedControlOsmolalities,controlOsmolalityDeviationWarnings];

			(* get the inputs that pass this test *)
			passingControls=PickList[resolvedControls,controlOsmolalityDeviationWarnings,False];
			passingOsmolalities=PickList[resolvedControlOsmolalities,controlOsmolalityDeviationWarnings,False];

			(* create a test for the non-passing inputs *)
			failingControlTests=If[Length[failingControls]>0,
				Test["For the provided controls "<>ObjectToString[failingControls,Simulation -> updatedSimulation]<>", the provided control osmolalities ("<>ToString[failingOsmolalities]<>") agree with database values:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingControlTests=If[Length[passingControls]>0,
				Test["For the provided controls "<>ObjectToString[passingControls,Simulation -> updatedSimulation]<>", the provided control osmolalities ("<>ToString[passingOsmolalities]<>") agree with database values:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingControlTests,failingControlTests}
		]
	];

	(* Stash the failing options for this error *)
	controlOsmolalityDeviationParameterWarningOptions=If[MemberQ[controlOsmolalityDeviationWarnings,True],
		{ControlOsmolality},
		Nothing
	];

	
	(* 9 Warn that the target osmolality given for a control differs from the db value *)
	If[MemberQ[controlOsmolalityUnknownErrors,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Error::OsmolalityControlOsmolalityUnknown,ObjectToString[failingControlOsmolalityUnknownInputs,Simulation -> updatedSimulation],First/@failingControlOsmolalityUnknownOptions]
	];

	(* Generate the tests *)
	controlOsmolalityUnknownWarningTests=If[gatherTests,
		Module[{failingControls,failingOsmolalities,passingControls,passingOsmolalities,failingControlTests,passingControlTests},

			(* get the inputs that fail this test *)
			failingControls=PickList[resolvedControls,controlOsmolalityUnknownErrors];
			failingOsmolalities=PickList[resolvedControlOsmolalities,controlOsmolalityUnknownErrors];

			(* get the inputs that pass this test *)
			passingControls=PickList[resolvedControls,controlOsmolalityUnknownErrors,False];
			passingOsmolalities=PickList[resolvedControlOsmolalities,controlOsmolalityUnknownErrors,False];

			(* create a test for the non-passing inputs *)
			failingControlTests=If[Length[failingControls]>0,
				Test["For the provided controls "<>ObjectToString[failingControls,Simulation -> updatedSimulation]<>", the control osmolalities ("<>ToString[failingOsmolalities]<>") could be resolved:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingControlTests=If[Length[passingControls]>0,
				Test["For the provided controls "<>ObjectToString[passingControls,Simulation -> updatedSimulation]<>", the control osmolalities ("<>ToString[passingOsmolalities]<>") could be resolved:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingControlTests,failingControlTests}
		]
	];

	(* Stash the failing options for this error *)
	controlOsmolalityUnknownParameterErrorOptions=If[MemberQ[controlOsmolalityUnknownErrors,True],
		{ControlOsmolality},
		Nothing
	];


	(* 10 Warn that the specified control tolerance is below the repeatability of the instrument and tolerances of the standards *)
	If[MemberQ[controlToleranceWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Warning::OsmolalityControlTolerance,ObjectToString[failingControlToleranceInputs,Simulation -> updatedSimulation],#[[1]]&/@failingControlToleranceOptions,SafeRound[#[[2]],0.1]&/@failingControlToleranceOptions,#[[3]]&/@failingControlToleranceOptions,#[[4]]&/@failingControlToleranceOptions,#[[5]]&/@failingControlToleranceOptions]
	];

	(* Generate the tests *)
	controlToleranceWarningTests=If[gatherTests,
		Module[{failingControls,failingTolerances,passingControls,passingTolerances,failingControlTests,passingControlTests},

			(* get the inputs that fail this test *)
			failingControls=PickList[resolvedControls,controlToleranceWarnings];
			failingTolerances=PickList[resolvedControlTolerances,controlToleranceWarnings];

			(* get the inputs that pass this test *)
			passingControls=PickList[resolvedControls,controlToleranceWarnings,False];
			passingTolerances=PickList[resolvedControlTolerances,controlToleranceWarnings,False];

			(* create a test for the non-passing inputs *)
			failingControlTests=If[Length[failingControls]>0,
				Test["For the provided controls "<>ObjectToString[failingControls,Simulation -> updatedSimulation]<>", the provided control tolerances ("<>ToString[failingTolerances]<>") do not exceed the manufacturing standard of the calibrants and the repeatability of the instrument:",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingControlTests=If[Length[passingControls]>0,
				Test["For the provided controls "<>ObjectToString[passingControls,Simulation -> updatedSimulation]<>", the provided control tolerances ("<>ToString[passingTolerances]<>") do not exceed the manufacturing standard of the calibrants and the repeatability of the instrument:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingControlTests,failingControlTests}
		]
	];

	(* Stash the failing options for this error *)
	controlToleranceParameterWarningOptions=If[MemberQ[controlToleranceWarnings,True],
		{ControlTolerance},
		Nothing
	];


	(* Pull out Miscellaneous options *)
	{emailOption,uploadOption,nameOption,confirmOption,canaryBranchOption,parentProtocolOption,fastTrackOption,templateOption,samplesInStorageCondition,samplesOutStorageCondition,operator,imageSample,measureWeight,measureVolume}=
		Lookup[allOptionsRounded,
			{Email,Upload,Name,Confirm,CanaryBranch,ParentProtocol,FastTrack,Template,SamplesInStorageCondition,SamplesOutStorageCondition,Operator,ImageSample,MeasureWeight,MeasureVolume}
		];

	(* check if the provided sampleStorageCondtion is valid*)
	{validSampleStorageConditionQ,validSampleStorageTests}=If[gatherTests,
		ValidContainerStorageConditionQ[simulatedSamples,samplesInStorageCondition,Cache->cache,Simulation -> updatedSimulation,Output->{Result,Tests}],
		{ValidContainerStorageConditionQ[simulatedSamples,samplesInStorageCondition,Cache->cache,Simulation -> updatedSimulation,Output->Result],{}}
	];

	(* if the test above passes, there's no invalid option, otherwise, SamplesInStorageCondition will be an invalid option *)
	invalidStorageConditionOptions=If[Not[And@@validSampleStorageConditionQ],
		{SamplesInStorageCondition},
		{}
	];

	(* CompatibleMaterialsQ. Verify that the samples are compatible with the instrument *)
	{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[First[Lookup[instrumentPacket,Object],{}],simulatedSamples,Cache->cache,Simulation -> updatedSimulation,Output->{Result,Tests}],
		{CompatibleMaterialsQ[First[Lookup[instrumentPacket,Object],{}],simulatedSamples,Cache->cache,Simulation -> updatedSimulation,Messages->!gatherTests],{}}
	];

	(*Get all the incompatible samples*)
	incompatibleInputs=If[Not[compatibleMaterialsBool]&&!gatherTests,
		mySamples,
		{}
	];

	(* If there are incompatible inputs and we are throwing messages, throw an error message .*)
	If[Length[incompatibleInputs]>0&&!gatherTests,
		Message[Error::OsmolalityIncompatibleSample,ObjectToString[incompatibleInputs,Simulation -> updatedSimulation]]
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)
	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,containerlessInvalidInputs,noVolumeInvalidInputs,incompatibleInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{nameInvalidOption,calibrantIncompatibleInvalidOptions,calibrantOrderingInvalidOptions,calibrantOsmolalityIncompatibleInvalidOptions,
		calibrantOsmolalityOrderingInvalidOptions,invalidStorageConditionOptions,transferHighViscosityParameterErrorOptions,
		readingsExceedsMaximumInvalidOptions,equilibrationTimeReadingsInvalidOptions,controlIncompatibleInvalidOptions,
		controlOsmolalityUnknownParameterErrorOptions,controlOptionsInvalidOptions
	}]
	];

	allTests=Flatten[{
		(* Invalid input tests *)
		samplePrepTests,discardedTest,containerlessTest,noVolumeTest,compatibleMaterialsTests,

		(* Precision tests *)
		allOptionsPrecisionTests,

		(* Conflicting options tests *)
		validNameTest,calibrantIncompatibleInvalidTest,calibrantOrderingInvalidTest,calibrantOsmolalityIncompatibleInvalidTest,calibrantOsmolalityOrderingInvalidTest,
		lowSampleVolumeWarningTest,readingsExceedsMaximumInvalidTest,validSampleStorageTests,controlIncompatibleInvalidTest,lowControlVolumeWarningTest,
		controlOptionsInvalidTest,

		(* Map thread tests *)
		unknownViscosityWarningTests,transferHighViscosityErrorTests,sampleCarryOverWarningTests,viscousTransferMinimumVolumeWarningTests,noInoculationPaperWarningTests,
		inoculationPaperHighViscosityWarningTests,shortEquilibrationTimeWarningTests,controlOsmolalityDeviationWarningTests,
		controlToleranceWarningTests
	}];

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
	(*targetContainers=(
		(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
		(* When you do not want an aliquot to happen for the corresponding simulated sample, make the corresponding index of targetContainers Null. *)
		(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)
	);*)
	(* No automatic aliquoting is required as the instrument as the container is not installed in the instrument *)

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		(* Note: Also include AllowSolids\[Rule]True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		resolveAliquotOptions[
			ExperimentMeasureOsmolality,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache -> cache,
			Simulation -> updatedSimulation,
			RequiredAliquotContainers  -> simulatedSampleContainerModels,
			RequiredAliquotAmounts -> Null,
			Output -> {Result, Tests}
		],
		{resolveAliquotOptions[
			ExperimentMeasureOsmolality,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache -> cache,
			Simulation -> updatedSimulation,
			RequiredAliquotContainers -> simulatedSampleContainerModels,
			RequiredAliquotAmounts -> Null,
			Output -> Result],
			{}
		}
	];

	(* Resolve Email option *)
	resolvedEmail=If[!MatchQ[emailOption,Automatic],
		(* If Email is specified, use the supplied value *)
		emailOption,
		(* If both Upload->True and Result is a member of Output, send emails. Otherwise, do not send emails *)
		If[And[uploadOption,MemberQ[output,Result]],
			True,
			False
		]
	];


	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* All resolved options *)
	resolvedOptions=ReplaceRule[
		allOptionsRounded,
		Join[
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			{
				OsmolalityMethod->osmolalityMethod,
				Instrument->instrument,
				PreClean->preClean,
				NumberOfReplicates->numberOfReplicates,
				CleaningSolution->resolvedCleaningSolution,
				Calibrant->resolvedCalibrants/.{}->Null,
				CalibrantOsmolality->resolvedCalibrantOsmolalities/.{}->Null,
				CalibrantVolume->calibrantVolume/.{}->Null,
				Control->resolvedControls/.{}->Null,
				ControlOsmolality->resolvedControlOsmolalities/.{}->Null,
				ControlVolume->resolvedControlVolumes/.{}->Null,
				ControlTolerance->resolvedControlTolerances/.{}->Null,
				ViscousLoading->resolvedViscousLoadings,
				InoculationPaper->resolvedInoculationPapers,
				SampleVolume->sampleVolume,
				NumberOfReadings->numberOfReadings,
				EquilibrationTime->resolvedEquilibrationTimes,
				Confirm->confirmOption,
				CanaryBranch->canaryBranchOption,
				Name->name,
				Template->templateOption,
				Cache->cache,
				Email->resolvedEmail,
				FastTrack->fastTrackOption,
				Operator->operator,
				ParentProtocol->parentProtocolOption,
				Upload->uploadOption,
				SamplesInStorageCondition->samplesInStorageCondition,
				SamplesOutStorageCondition->samplesOutStorageCondition,
				ImageSample->imageSample,
				MeasureWeight->measureWeight,
				MeasureVolume->measureVolume,
				MaxNumberOfCalibrations->resolvedMaxNumberOfCalibrations,
				PostRunInstrumentContaminationLevel->postRunInstrumentContaminationLevel,
				NumberOfControlReplicates->resolvedNumberOfControlReplicates
			}
		],
		Append->False
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result->resolvedOptions,
		Tests->allTests
	}

];


(* ::Subsubsection:: *)
(*measureViscosityResourcePackets*)


DefineOptions[
	experimentMeasureOsmolalityResourcePackets,
	Options:>{OutputOption,CacheOption,SimulationOption}
];


experimentMeasureOsmolalityResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs,expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache, simulation,
		samplePackets,expandedAliquotVolume,pairedSamplesInAndVolumes,
		sampleResourceReplaceRules,instrument,instrumentTime,instrumentResource,protocolPacket,sharedFieldPacket,finalizedPacket,
		allResourceBlobs,fulfillable,frqTests,testsRule,resultRule,

		(* Options *)
		osmolalityMethod,numberOfReplicates,preClean,cleaningSolution,calibrants,calibrantVolume,calibrantOsmolalities,
		viscousLoading,inoculationPaper,sampleVolume,equilibrationTime,numberOfReadings,maxNumberOfCalibrations,controlTolerances,
		numberOfControlReplicates,

		(* Download *)
		samplesWithoutLinks,samplesWithReplicates,optionsWithReplicates,
		sampleDownloads,allTipModelPacket,allPipetteModelPackets,instrumentPacket,

		(* Get resources *)
		cleaningSolutionVolume,cleaningSolutionResource,wasteWeight,wasteAssociation,intNumberOfReplicates,
		controls,controlOsmolalities,controlVolumes,
		pipetteTipsCalibrants,pipetteTipsControls,pipettesCalibrants,pipettesControls,
		pipetteTipsCalibrantsResourcesExpanded,pipetteTipsControlsResourcesExpanded,pipetteCalibrantsResourcesExpanded,pipetteControlsResourcesExpanded,
		inoculationPapersCalibrants,tweezersCalibrants,inoculationPapersControls,tweezersControls,
		inoculationPapersCalibrantsResourcesExpanded,tweezerCalibrantsResourcesExpanded,inoculationPapersControlsResourcesExpanded,tweezerControlsResourcesExpanded,
		numberOfExpandedSamples,totalInoculationPaper,
		expandedForNumberOfReplicatesSampleVolumes,sampleVolumesNeeded,gatheredSamplesInAndVolumes,sampleResources,
		sampleResourceAssociations,orderedSamples,samplesInLinks,resourceSamplesIn,pipetteTipsData,pipetteTips,pipetteTipsSamples,pipettesSamples,pipettesResolutionSamples,
		pipettes,pipetteResources,pipetteResourceAssociations,pipetteResourcesExpanded,talliedTips,pipetteTipsResources,
		pipetteTipsResourcesExpanded,pipetteTipsResourceAssociations,inoculationPaperResources,talliedInoculationPapers,
		inoculationPaperResourceAssociations,inoculationPaperResourcesExpanded,tweezerResources,tweezerResourceAssociations,tweezerResourcesExpanded,tweezers,tweezersSamples,
		operator,numericEquilibrationTimes,internalDefaultEquilibrationTimes,containersInResources,resolvedInstrumentMode,
		standards,standardVolumes,expandedForNumberOfCalibrationCyclesStandardVolumes,pairedStandardsAndVolumes,gatheredStandardsAndVolumes,
		standardResources,standardResourceAssociations,orderedStandards,standardResourceReplaceRules,calibrantsResources,controlsResources,
		postRunContaminationStandardResource,postRunInstrumentContaminationLevel,inoculationPapersContamination,inoculationPapersContaminationResources,
		tweezersContamination,tweezersContaminationResources,pipetteContamination,pipetteContaminationResources,pipetteTipsContamination,
		pipetteTipsContaminationResources,expandControlReplicates,controlsReplicates,controlVolumesReplicates,

		(* Timing *)
		sampleLoadingTime,internalCleaningTime,dataExportTime,benchTransferTime,totalCalibrationTime,measurementTimes,totalMeasurementTime,instrumentSetupTime,instrumentTearDownTime,processingTime,

		previewRule,optionsRule
	},
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs,expandedResolvedOptions}=ExpandIndexMatchedInputs[ExperimentMeasureOsmolality,{mySamples},myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentMeasureOsmolality,
		RemoveHiddenOptions[ExperimentMeasureOsmolality,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache = Lookup[ToList[ops], Cache, {}];
	simulation = Lookup[ToList[ops], Simulation, {}];

	(* Get rid of links in mySamples *)
	samplesWithoutLinks=mySamples/.{link_Link:>Download[link,Object]};

	(* Expand our samples and options according to NumberOfReplicates. *)
	{samplesWithReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentMeasureOsmolality,samplesWithoutLinks,expandedResolvedOptions];

	(* --- Make our one big Download call --- *)
	{sampleDownloads,allTipModelPacket,allPipetteModelPackets,instrumentPacket}=Quiet[Download[
		{
			mySamples,
			Search[Model[Item,Tips]],
			Search[Model[Instrument,Pipette]],
			{Lookup[myResolvedOptions,Instrument]}
		},
		{
			{
				Packet[Container,Volume,Object,Density,State,Viscosity,BoilingPoint]
			},
			{
				Packet[TipConnectionType,Resolution]
			},
			{
				Packet[TipConnectionType,MinVolume,MaxVolume,CultureHandling,Resolution]
			},
			{
				Packet[MeasurementTime]
			}
		},
		Cache -> inheritedCache,
		Simulation -> simulation,
		Date -> Now
	],
		Download::FieldDoesntExist
	];

	samplePackets=Flatten[sampleDownloads];

	(* --- Make all the resources needed in the experiment --- *)

	(* Options Lookup - use expanded options *)
	{
		osmolalityMethod,instrument,numberOfReadings,numberOfReplicates,preClean,cleaningSolution,calibrants,calibrantVolume,calibrantOsmolalities,
		viscousLoading,inoculationPaper,sampleVolume,equilibrationTime,operator,controls,controlVolumes,controlOsmolalities,maxNumberOfCalibrations,
		controlTolerances,postRunInstrumentContaminationLevel,numberOfControlReplicates
	}=Lookup[optionsWithReplicates,
		{
			OsmolalityMethod,Instrument,NumberOfReadings,NumberOfReplicates,PreClean,CleaningSolution,Calibrant,CalibrantVolume,CalibrantOsmolality,
			ViscousLoading,InoculationPaper,SampleVolume,EquilibrationTime,Operator,Control,ControlVolume,ControlOsmolality,MaxNumberOfCalibrations,
			ControlTolerance,PostRunInstrumentContaminationLevel,NumberOfControlReplicates
		}
	];


	(* -- Generate resources for the SamplesIn -- *)

	(* Parse the number of replicates, runs etc *)

	(* Convert NumberOfReplicates such that Null->1*)
	intNumberOfReplicates=numberOfReplicates/.{Null->1};

	(* Total number of samples to run, accounting for replicates *)
	numberOfExpandedSamples=Length[samplesWithReplicates];

	(* Total up the total volume of each sample used, accounting for replicates *)
	expandedForNumberOfReplicatesSampleVolumes=(# intNumberOfReplicates)&/@Lookup[myResolvedOptions,SampleVolume];

	(* Pull out the AliquotAmount option *)
	expandedAliquotVolume=Lookup[myResolvedOptions,AliquotAmount];


	(* Get the sample volume; if we're aliquoting, use that amount; otherwise use the minimum volume the experiment will require *)
	(* Template Note: Only include a volume if the experiment is actually consuming some amount *)
	(* The volume of the samples we need is either the sampleVolume times the NumberOfReplicates or, if we are aliquoting, the aliquot volume*)
	sampleVolumesNeeded=MapThread[
		Function[{sampleVolume,aliquotVolume},
			If[VolumeQ[aliquotVolume],
				aliquotVolume,
				sampleVolume
			]
		],
		{expandedForNumberOfReplicatesSampleVolumes,expandedAliquotVolume}
	];

	(* Pair the SamplesIn and their Volumes *)
	pairedSamplesInAndVolumes=MapThread[
		Function[{sample,volume},
			sample->volume
		],
		{samplesWithoutLinks,sampleVolumesNeeded}
	];

	(* Gather duplicate samples - i.e. any experiments that use the sample sample (may not be replicates as options may be different *)
	gatheredSamplesInAndVolumes=GatherBy[pairedSamplesInAndVolumes,First];

	(* Make a list of the sampleResources, combining any of the samplesIn that are duplicates. One resource for a single sample object,
	 regardless of whether it is used for replicates or not *)
	sampleResources=Function[{sampleType},
		Resource[
			Sample->First[Keys[sampleType]],
			Amount->Total[Values[sampleType]],
			Name->ToString[Unique[]]
		]
	]/@gatheredSamplesInAndVolumes;

	(* Get the raw associations underlying the resources *)
	sampleResourceAssociations=sampleResources[[All,1]];

	(* Extract the unique sample names *)
	orderedSamples=Lookup[sampleResourceAssociations,Sample];

	(* Make the sample resource replace rules *)
	sampleResourceReplaceRules=AssociationThread[
		orderedSamples->sampleResources
	];

	(* Make the SamplesIn links *)
	samplesInLinks=Link[samplesWithReplicates,Protocols];

	(* make resourceSamplesIn *)
	resourceSamplesIn=samplesInLinks/.sampleResourceReplaceRules;

	(* Use the replace rules to get the sample resources *)
	(*samplesInResources=Replace[samplesWithReplicates,sampleResourceReplaceRules,{1}];*)

	(* -- Generate instrument resources -- *)

	(* Pipette and tips *)

	(* Map across all sample volumes, including all replicates, to select appropriate tip *)
	pipetteTipsData=MapThread[
		If[#2,
			(* If viscous loading, use positive displacement pipette/tips *)
			Model[Item,Tips,"100 uL positive displacement tips, sterile"],

			(* Otherwise, get the preferred tip for the volume *)
			FirstOrDefault[FirstOrDefault[TransferDevices[Model[Item,Tips],#1]]]
		]&,
		{sampleVolume,viscousLoading}
	];

	(* Process the pipette tips information and get appropriate pipette *)
	{pipetteTipsSamples,pipettesSamples}=Transpose@MapThread[
		Function[{tip,volume},

			Module[{pipette},

				(* Select pipette *)
				pipette=Switch[{tip,volume},
					(* If using the positive displacement tips, get the positive displacement pipette *)
					{ObjectReferenceP[Model[Item,Tips,"100 uL positive displacement tips, sterile"]],_},Model[Instrument,Pipette,"Pos-D MR-100"],

					(* If transferring 10 uL, use the specialized 10 uL Vapro 5600 pipette *)
					{_,EqualP[10 Microliter]},Model[Instrument,Pipette,"AC-037 10 uL Pipette, Vapro 5600"],

					(* Otherwise, get the best pipette compatible with the tips *)
					{_,_},First[Experiment`Private`compatiblePipettes[tip,First/@allTipModelPacket,First/@allPipetteModelPackets,volume]]

				];
				(* Return key data *)
				{tip,pipette}
			]
		],
		{pipetteTipsData,sampleVolume}
	];

	pipettesResolutionSamples=Lookup[fetchPacketFromCache[#,allPipetteModelPackets]&/@pipettesSamples,Resolution];

	(* Add pipette & tips for calibration and control runs. We need to gather resources for the maximum number of calibrations *)
	(* Max number of calibrations - maxNumberOfCalibrations *)

	(* Expand the controls by the NumberOfControlReplicates *)
	expandControlReplicates[field_List]:=MapThread[Sequence@@ConstantArray[#1,#2]&,{field,numberOfControlReplicates}];
	expandControlReplicates[Null]:={};

	controlsReplicates=expandControlReplicates[controls];
	controlVolumesReplicates=expandControlReplicates[controlVolumes];


	(* Combine controls and calibrants to allow for duplicates *)
	standards=Join[calibrants,controlsReplicates];
	standardVolumes=Join[calibrantVolume,controlVolumesReplicates];


	(* Total up the total volume of each standard used, accounting for number of calibration cycles *)
	expandedForNumberOfCalibrationCyclesStandardVolumes=(# maxNumberOfCalibrations)&/@standardVolumes;


	(* Pair the standards and their Volumes *)
	pairedStandardsAndVolumes=MapThread[
		Function[{sample,volume},
			sample->volume
		],
		{standards,expandedForNumberOfCalibrationCyclesStandardVolumes}
	];

	(* Gather duplicate standards - i.e. any calibrant or standard *)
	gatheredStandardsAndVolumes=GatherBy[pairedStandardsAndVolumes,First];

	(* Make a list of the standardResources, combining any of the calibrants/controls that are duplicates *)
	standardResources=Function[{sampleType},
		Resource[
			Sample->First[Keys[sampleType]],
			Amount->Total[Values[sampleType]],
			Name->ToString[Unique[]]
		]
	]/@gatheredStandardsAndVolumes;

	(* Get the raw associations underlying the resources *)
	standardResourceAssociations=standardResources[[All,1]];

	(* Extract the unique sample names *)
	orderedStandards=Lookup[standardResourceAssociations,Sample];

	(* Make the sample resource replace rules *)
	standardResourceReplaceRules=AssociationThread[
		orderedStandards->standardResources
	];

	(* Make the calibrant resources *)
	calibrantsResources=calibrants/.standardResourceReplaceRules;

	(* Make the control resources *)
	controlsResources=controlsReplicates/.standardResourceReplaceRules;


	(* Get normal pipette tips for calibrants, based on volume *)
	pipetteTipsCalibrants=FirstOrDefault[FirstOrDefault[TransferDevices[Model[Item,Tips],#]]]&/@calibrantVolume;

	(* Get normal pipette tips for controls, based on volume *)
	pipetteTipsControls=FirstOrDefault[FirstOrDefault[TransferDevices[Model[Item,Tips],#]]]&/@controlVolumesReplicates;

	(* TC Clean *)
	pipetteTipsContamination=If[postRunInstrumentContaminationLevel,First[First[TransferDevices[Model[Item,Tips],10 Microliter]]],Null];

	(* Get the pipette for the calibrants *)
	pipettesCalibrants=MapThread[Function[
		{tip,volume},
		If[EqualQ[volume,10 Microliter],
			Model[Instrument,Pipette,"AC-037 10 uL Pipette, Vapro 5600"],
			First[Experiment`Private`compatiblePipettes[tip,First/@allTipModelPacket,First/@allPipetteModelPackets,volume]]
		]
	],
		{pipetteTipsCalibrants,calibrantVolume}
	];

	(* Get the pipette for the calibrants *)
	pipettesControls=MapThread[Function[
		{tip,volume},
		If[EqualQ[volume,10 Microliter],
			Model[Instrument,Pipette,"AC-037 10 uL Pipette, Vapro 5600"],
			First[Experiment`Private`compatiblePipettes[tip,First/@allTipModelPacket,First/@allPipetteModelPackets,volume]]
		]
	],
		{pipetteTipsControls,controlVolumesReplicates}
	];

	(* TC clean *)
	pipetteContamination=If[postRunInstrumentContaminationLevel,Model[Instrument,Pipette,"AC-037 10 uL Pipette, Vapro 5600"],Null];


	(* Total all the pipettes and tips across calibrants, controls and samples. Correct calibrants and controls for max number of retries *)
	pipetteTips=Join[pipetteTipsSamples,Table[Sequence@@pipetteTipsCalibrants,maxNumberOfCalibrations],Table[Sequence@@pipetteTipsControls,maxNumberOfCalibrations],{pipetteTipsContamination/.Null->Nothing}];
	pipettes=Join[pipettesSamples,pipettesCalibrants,pipettesControls,{pipetteContamination/.Null->Nothing}];

	(* Create pipette tips resources. Unique tip for each use *)
	(* Tally tips specified *)
	talliedTips=Tally[pipetteTips];

	(* Create the resources. Tip will not be Null *)
	pipetteTipsResources=Resource[
		Sample->First[#],
		Amount->Last[#],
		Name->ToString[Unique[]],
		UpdateCount->False
	]&/@talliedTips;

	(* Associate pipette resource with correct samples *)
	pipetteTipsResourceAssociations=pipetteTipsResources[[All,1]];

	(* Samples *)
	pipetteTipsResourcesExpanded=pipetteTipsSamples/.AssociationThread[Lookup[pipetteTipsResourceAssociations,Sample]->pipetteTipsResources];

	(* Calibrants *)
	pipetteTipsCalibrantsResourcesExpanded=pipetteTipsCalibrants/.AssociationThread[Lookup[pipetteTipsResourceAssociations,Sample]->pipetteTipsResources];

	(* Controls *)
	pipetteTipsControlsResourcesExpanded=pipetteTipsControls/.AssociationThread[Lookup[pipetteTipsResourceAssociations,Sample]->pipetteTipsResources];

	(* TC clean *)
	pipetteTipsContaminationResources=pipetteTipsContamination/.AssociationThread[Lookup[pipetteTipsResourceAssociations,Sample]->pipetteTipsResources];


	(* Create inoculation paper resources *)
	(* Define fixed papers *)
	(* Calibrants *)
	inoculationPapersCalibrants=Model[Item,InoculationPaper,"6.7mm diameter solute free paper"]&/@calibrants;

	(* Controls *)
	inoculationPapersControls=Model[Item,InoculationPaper,"6.7mm diameter solute free paper"]&/@controlsReplicates;

	(* TC contamination *)
	inoculationPapersContamination=If[postRunInstrumentContaminationLevel,Model[Item,InoculationPaper,"6.7mm diameter solute free paper"],Null];

	(* Total inoculation papers - allow for max number of retries *)
	totalInoculationPaper=Join[inoculationPaper,Table[Sequence@@inoculationPapersCalibrants,maxNumberOfCalibrations],Table[Sequence@@inoculationPapersControls,maxNumberOfCalibrations],{inoculationPapersContamination/.Null->Nothing}];

	(* Tally inoculation papers specified *)
	talliedInoculationPapers=Tally[totalInoculationPaper];

	(* Create the resources *)
	inoculationPaperResources=If[!NullQ[First[#]],
		Resource[
			Sample->First[#],
			Amount->Last[#],
			Name->ToString[Unique[]]
		],
		Nothing
	]&/@talliedInoculationPapers;

	(* Associate inoculation paper resource with correct samples *)
	inoculationPaperResourceAssociations=inoculationPaperResources[[All,1]];

	(* Samples *)
	inoculationPaperResourcesExpanded=inoculationPaper/.AssociationThread[Lookup[inoculationPaperResourceAssociations,Sample]->inoculationPaperResources];

	(* Calibrants *)
	inoculationPapersCalibrantsResourcesExpanded=inoculationPapersCalibrants/.AssociationThread[Lookup[inoculationPaperResourceAssociations,Sample]->inoculationPaperResources];

	(* Controls *)
	inoculationPapersControlsResourcesExpanded=inoculationPapersControls/.AssociationThread[Lookup[inoculationPaperResourceAssociations,Sample]->inoculationPaperResources];

	(* TC contamination *)
	inoculationPapersContaminationResources=inoculationPapersContamination/.AssociationThread[Lookup[inoculationPaperResourceAssociations,Sample]->inoculationPaperResources];

	(* Tweezer Resources *)

	(* Get tweezers if any inoculation paper specified *)
	(* Samples *)
	tweezersSamples=inoculationPaper/.ObjectP[{Object,Model}]->Model[Item,Tweezer,"AC-036 Forceps, Vapro 5600"];

	(* Calibrants *)
	tweezersCalibrants=inoculationPapersCalibrants/.ObjectP[{Object,Model}]->Model[Item,Tweezer,"AC-036 Forceps, Vapro 5600"];

	(* Controls *)
	tweezersControls=inoculationPapersControls/.ObjectP[{Object,Model}]->Model[Item,Tweezer,"AC-036 Forceps, Vapro 5600"];

	(* TC contamination *)
	tweezersContamination=If[postRunInstrumentContaminationLevel,Model[Item,Tweezer,"AC-036 Forceps, Vapro 5600"],Null];

	(* Add tweezers for calibration and control runs *)
	tweezers=Join[tweezersSamples,tweezersCalibrants,tweezersControls,{tweezersContamination/.Null->Nothing}];

	(* Get the tweezer resource *)
	tweezerResources=If[!NullQ[#],
		Resource[
			Sample->#,
			Name->ToString[Unique[]],
			Rent->True
		],
		Nothing
	]&/@DeleteDuplicates[tweezers,MatchQ[#1,ObjectP[#2]]&];

	(* Associate tweezer resource with correct samples *)
	tweezerResourceAssociations=tweezerResources[[All,1]];

	(* Samples *)
	tweezerResourcesExpanded=tweezersSamples/.AssociationThread[Lookup[tweezerResourceAssociations,Sample]->tweezerResources];

	(* Calibrants *)
	tweezerCalibrantsResourcesExpanded=tweezersCalibrants/.AssociationThread[Lookup[tweezerResourceAssociations,Sample]->tweezerResources];

	(* Controls *)
	tweezerControlsResourcesExpanded=tweezersControls/.AssociationThread[Lookup[tweezerResourceAssociations,Sample]->tweezerResources];

	(* TC contamination *)
	tweezersContaminationResources=tweezersContamination/.AssociationThread[Lookup[tweezerResourceAssociations,Sample]->tweezerResources];

	(* Get cleaning solution resource *)
	(* Volume of solution dependent on whether there is a pre-clean or not *)
	cleaningSolutionVolume=If[preClean,70 Milliliter,50 Milliliter];

	(* Top up the supply and empty waste each time. Deep clean on regular basis *)
	cleaningSolutionResource=Resource[
		Sample->cleaningSolution,
		Amount->cleaningSolutionVolume,
		Container->Model[Container,Vessel,"100 mL Glass Bottle"]
	];

	(* If we're doing a post-run contamination reading, create the 100 mmol/kg standard resource and associated resources *)
	postRunContaminationStandardResource=If[postRunInstrumentContaminationLevel,
		Resource[
			Sample->Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"],
			Amount->FirstOrDefault[calibrantVolume,10 Microliter],
			Name->ToString[Unique[]]
		],
		Null
	];

	(* Generate resource for the waste *)
	(* Assume contaminants in wash waste are negligible, i.e. approximately pure water *)
	wasteWeight=N[cleaningSolutionVolume (1 Gram/Milliliter)];

	(* Create waste resource *)
	wasteAssociation=<|Waste->Link[Model[Sample,"Chemical Waste"]],Weight->wasteWeight|>;

	(* Desiccant cartridge addressed during compile *)

	(* Parse EquilibrationTimes *)
	(* Get Booleans for whether the internal default equilibration is requested *)
	internalDefaultEquilibrationTimes=Replace[equilibrationTime,{InternalDefault->True,Except[InternalDefault]->False},1];

	(* Get the numeric values *)
	numericEquilibrationTimes=Replace[equilibrationTime,{InternalDefault->Null},1];

	(* Parse instrument mode *)
	resolvedInstrumentMode=MapThread[Switch[{#1,#2},
		(* If default equilibration times, and 1 reading, use normal mode *)
		{True,EqualP[1]},Normal,

		(* If default equilibration times and 10 readings, auto repeat *)
		{True,EqualP[10]},AutoRepeat,

		(* If manual equilibration times, process-delay *)
		{False,_},ProcessDelay
	]&,{internalDefaultEquilibrationTimes,numberOfReadings}];

	(* Timing *)
	(* Using the 3 beep method *)

	(* Time to remove previous sample, clean sample holder, load sample paper, load sample, and close measurement chamber *)
	sampleLoadingTime=1 Minute;
	internalCleaningTime=8.5 Minute;
	dataExportTime=5 Minute;
	benchTransferTime=3 Minute;
	(*instrumentReadingTime=30 Second;
	instrumentEquilibrationTime=60 Second;
	instrumentChamberDryTime=3 Minute;*)

	(* Time to actually perform the readings on a loaded sample *)
	(* Create helpers *)
	readingTime[numberOfReadings:Alternatives[1,10],equilibrationTime:InternalDefault]:=Switch[numberOfReadings,
		1,First[Lookup[First[instrumentPacket],MeasurementTime]],
		10,Module[{initialReadTime,readTime,dryTime},
			initialReadTime=90 Second;
			readTime=30 Second;
			dryTime=3 Minute;
			initialReadTime+9(dryTime+readTime)
		]
	];

	readingTime[numberOfReadings:_Integer,equilibrationTime:GreaterEqualP[0 Second]]:=Module[{initialReadTime,readTime,dryTime},
		initialReadTime=90 Second;
		readTime=30 Second;
		dryTime=2 Minute;
		initialReadTime+(numberOfReadings (dryTime+equilibrationTime+readTime))
	];

	(* Total time for calibration and control check *)
	totalCalibrationTime=Total[
		Join[
			{benchTransferTime},
			(sampleLoadingTime+readingTime[Sequence@@#])&/@ConstantArray[{1,InternalDefault},Length[calibrants]],
			{benchTransferTime},
			(sampleLoadingTime+readingTime[Sequence@@#]+dataExportTime)&/@ConstantArray[{1,InternalDefault},Length[controlsReplicates]]
		]
	];

	(* Total time for taking readings from a sample *)
	measurementTimes=MapThread[(sampleLoadingTime+readingTime[#1,#2]+dataExportTime)&,
		{numberOfReadings,equilibrationTime}
	];

	totalMeasurementTime=Total[
		Join[
			{benchTransferTime},
			measurementTimes
		]];

	(* Time to get the instrument ready for calibration. Including topping up water, running diagnostic tests, cleaning if specified. *)
	instrumentSetupTime=3 Minute+If[TrueQ[preClean],
		internalCleaningTime+5 Minute,(* 5 minutes temperature equilibration time *)
		0
	];

	(* Time to clean the instrument after measurement session, including cleaning the thermocouple. Emptying waste *)
	instrumentTearDownTime=internalCleaningTime;

	(* Total measuring time *)
	processingTime=totalCalibrationTime+totalMeasurementTime;

	(* Total instrument time *)
	instrumentTime=instrumentSetupTime+processingTime+instrumentTearDownTime;
	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
	this will probably look like set-up time + time/sample + tear-down time *)


	(* Create the osmometer resource *)
	instrumentResource=Resource[
		Instrument->instrument,
		Time->instrumentTime,
		Name->ToString[Unique[]]
	];

	(* Create pipette resources. Only one required for multiple uses *)
	pipetteResources=Resource[
		Instrument->#,
		Name->ToString[Unique[]],
		Time->instrumentTime
	]&/@DeleteDuplicates[pipettes,MatchQ[#1,ObjectP[#2]]&];

	(* Associate pipette resource with correct samples *)
	pipetteResourceAssociations=pipetteResources[[All,1]];

	(* Samples *)
	pipetteResourcesExpanded=pipettesSamples/.AssociationThread[Lookup[pipetteResourceAssociations,Instrument]->pipetteResources];

	(* Calibrants *)
	pipetteCalibrantsResourcesExpanded=pipettesCalibrants/.AssociationThread[Lookup[pipetteResourceAssociations,Instrument]->pipetteResources];

	(* Controls *)
	pipetteControlsResourcesExpanded=pipettesControls/.AssociationThread[Lookup[pipetteResourceAssociations,Instrument]->pipetteResources];

	(* TC Clean *)
	pipetteContaminationResources=pipetteContamination/.AssociationThread[Lookup[pipetteResourceAssociations,Instrument]->pipetteResources];


	(* ContainersIn *)
	containersInResources=(Link[Resource[Sample->#],Protocols]&)/@Lookup[samplePackets,Container][Object];

	(* --- Generate the protocol packet --- *)
	protocolPacket=<|
		(* General *)
		Type->Object[Protocol,MeasureOsmolality],
		Object->CreateID[Object[Protocol,MeasureOsmolality]],
		Replace[SamplesIn]->resourceSamplesIn,
		Replace[ContainersIn]->containersInResources,
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->myResolvedOptions,
		NumberOfReplicates->numberOfReplicates,
		Replace[NumberOfReadings]->numberOfReadings,
		SampleReadingCounter->1,

		(* Osmolality set up *)
		Instrument->Link[instrumentResource],
		OsmolalityMethod->osmolalityMethod,
		PreClean->preClean,
		Replace[Calibrants]->Link/@calibrantsResources,
		Replace[CalibrantOsmolalities]->calibrantOsmolalities,
		Replace[CalibrantVolumes]->calibrantVolume,
		Replace[CalibrantInoculationPapers]->Link/@inoculationPapersCalibrantsResourcesExpanded,
		Replace[CalibrantTweezers]->Link/@tweezerCalibrantsResourcesExpanded,
		Replace[CalibrantPipettes]->Link/@pipetteCalibrantsResourcesExpanded,
		Replace[CalibrantPipetteTips]->Link/@pipetteTipsCalibrantsResourcesExpanded,
		Replace[Controls]->Link/@controlsResources,
		Replace[ControlVolumes]->controlVolumesReplicates,
		Replace[ControlOsmolalities]->controlOsmolalities,
		Replace[ControlInoculationPapers]->Link/@inoculationPapersControlsResourcesExpanded,
		Replace[ControlTweezers]->Link/@tweezerControlsResourcesExpanded,
		Replace[ControlPipettes]->Link/@pipetteControlsResourcesExpanded,
		Replace[ControlPipetteTips]->Link/@pipetteTipsControlsResourcesExpanded,
		MaxNumberOfCalibrations->maxNumberOfCalibrations,
		Replace[ControlTolerances]->controlTolerances,
		Replace[NumberOfControlReplicates]->numberOfControlReplicates,

		(* Sample loading *)
		Replace[Pipettes]->Link/@pipetteResourcesExpanded,
		Replace[PipetteTips]->Link/@pipetteTipsResourcesExpanded,
		Replace[InoculationPapers]->Link/@inoculationPaperResourcesExpanded,
		Replace[Tweezers]->Link/@tweezerResourcesExpanded,
		Replace[ViscousLoadings]->viscousLoading,

		(* Measure *)
		Replace[SampleVolumes]->sampleVolume,
		Replace[EquilibrationTimes]->numericEquilibrationTimes,
		Replace[InternalDefaultEquilibrationTimes]->internalDefaultEquilibrationTimes,
		Replace[InstrumentModes]->resolvedInstrumentMode,
		Replace[MeasurementTime]->Total[measurementTimes],

		(* Instrument cleaning *)
		CleaningSolution->Link[cleaningSolutionResource],

		PostRunInstrumentContaminationStandard->Link[postRunContaminationStandardResource],
		PostRunInstrumentContaminationInoculationPapers->Link[inoculationPapersContaminationResources],
		PostRunInstrumentContaminationTweezers->Link[tweezersContaminationResources],
		PostRunInstrumentContaminationPipettes->Link[pipetteContaminationResources],
		PostRunInstrumentContaminationPipetteTips->Link[pipetteTipsContaminationResources],

		Replace[SamplesInStorage]->Lookup[optionsWithReplicates,SamplesInStorageCondition],

		ImageSample->Lookup[optionsWithReplicates,ImageSample],
		MeasureVolume->Lookup[optionsWithReplicates,MeasureVolume],
		MeasureWeight->Lookup[optionsWithReplicates,MeasureWeight],

		(* Waste *)
		Replace[WasteGenerated]->{wasteAssociation},

		Replace[Checkpoints]->{
			{"Desiccant Cartridge Check",3 Minute,"Visually check whether the desiccant cartridge of the osmometer is exhausted and needs replacing.",Link[Resource[Operator->$BaselineOperator,Time->1 Minute]]},
			{"Picking Resources",15 Minute,"Samples, solutions and equipment required to execute this protocol are gathered from storage.",Link[Resource[Operator->$BaselineOperator,Time->10 Minute]]},
			{"Preparing Samples",5 Minute,"Preprocessing, such as incubation, mixing, centrifugation, filtration, and aliquotting, is performed.",Link[Resource[Operator->$BaselineOperator,Time->1 Minute]]},
			{"Prepare Instrumentation",instrumentSetupTime,"The instrument is configured for the protocol and internal tests are performed.",Link[Resource[Operator->$BaselineOperator,Time->instrumentSetupTime]]},
			{"Calibration and Control",totalCalibrationTime,"Osmolality measurements to calibrate and verify the calibration of the instrument.",Link[Resource[Operator->$BaselineOperator,Time->totalCalibrationTime]]},
			{"Measuring Osmolality",totalMeasurementTime,"Measure the osmolality of the SamplesIn.",Resource[Operator->$BaselineOperator,Time->totalMeasurementTime]},
			{"Sample Post-Processing",1 Hour,"Data parsing and any measuring of volume, weight, or sample imaging post experiment is performed.",Link[Resource[Operator->$BaselineOperator,Time->1*Hour]]},
			{"Returning Materials",10 Minute,"Samples are returned to storage.",Link[Resource[Operator->$BaselineOperator,Time->10*Minute]]}
		}
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Simulation -> simulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache,Simulation->simulation],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache,Simulation->simulation],Null}
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
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];






(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureOsmolality: Sister Functions*)


(* ------------- *)
(* -- OPTIONS -- *)
(* ------------- *)

DefineOptions[ExperimentMeasureOsmolalityOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentMeasureOsmolality}
];

ExperimentMeasureOsmolalityOptions[myInput:ListableP[ObjectP[{Object[Sample],Object[Container],Model[Sample]}]|_String],myOptions:OptionsPattern[ExperimentMeasureOsmolalityOptions]]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentMeasureOsmolality[myInput,preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentMeasureOsmolality],
		resolvedOptions
	]
];



(* ------------- *)
(* -- PREVIEW -- *)
(* ------------- *)


DefineOptions[ExperimentMeasureOsmolalityPreview,
	SharedOptions:>{ExperimentMeasureOsmolality}
];

ExperimentMeasureOsmolalityPreview[myInput:ListableP[ObjectP[{Object[Sample],Object[Container], Model[Sample]}]|_String],myOptions:OptionsPattern[ExperimentMeasureOsmolalityPreview]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentMeasureOsmolality[myInput,ReplaceRule[listedOptions,Output->Preview]]
];

(* ---------------------- *)
(* -- VALIDExperimentQ -- *)
(* ---------------------- *)


DefineOptions[ValidExperimentMeasureOsmolalityQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentMeasureOsmolality}
];

ValidExperimentMeasureOsmolalityQ[myInput:ListableP[ObjectP[{Object[Sample],Object[Container], Model[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentMeasureOsmolalityQ]]:=Module[
	{listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	listedInput=ToList[myInput];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentMeasureOsmolality[myInput,preparedOptions];

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
	safeOps=SafeOptions[ValidExperimentMeasureOsmolalityQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentMeasureOsmolality"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"ExperimentMeasureOsmolality"
	]
];






(* ::Subsection:: *)
(*Helpers*)