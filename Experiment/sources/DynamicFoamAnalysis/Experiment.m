(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentDynamicFoamAnalysis*)


(* ::Subsubsection:: *)
(*ExperimentDynamicFoamAnalysis Options and Messages*)

DefineOptions[ExperimentDynamicFoamAnalysis,
	Options:>{
		{
			OptionName->Instrument,
			Default->Model[Instrument,DynamicFoamAnalyzer,"DFA 100"],
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,DynamicFoamAnalyzer],Object[Instrument,DynamicFoamAnalyzer]}]
			],
			AllowNull->False,
			Description->"Indicates the Dynamic Foam Analyzer instrument that should be used in this experiment.",
			Category->"General"
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			(*General experiment options*)
			{
				OptionName -> SampleVolume,
				Default -> Automatic,
				Description -> "The physical quantity of sample to load into the foam column for measurement.",
				ResolutionDescription->"If no options are provided, will default to the minimum volume allowed for the foam column.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 100 Milliliter],
					Units -> Milliliter
				],
				Category->"General"
			},
			{
				OptionName->Temperature,
				Default->Ambient,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[4 Celsius,90 Celsius],Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}],
					Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
				],
				AllowNull->False,
				Description->"The temperature at which the foam column containing the sample will be heated to during the duration of the experiment.",
				Category->"General"
			},
			{
				OptionName->TemperatureMonitoring,
				Default->Automatic,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				AllowNull->False,
				Description->"Indicates whether the sample temperature will be directly measured during the experiment, using a temperature probe inserted into the foam column.",
				ResolutionDescription->"If no options are provided, will default to True unless a Liquid Content Module is used or Agitation is Stir, in which case it will default to False.",
				Category->"Method"
			},
			{
				OptionName->DetectionMethod,
				Default->Automatic,
				Widget->Adder[Widget[
					Type->Enumeration,
					Pattern:>FoamDetectionMethodP
				]],
				AllowNull->False,
				Description->"The type of foam detection method(s) that will be used during the experiment. The foam detection methods are the Height Method (default method for the Dynamic Foam Analyzer), Liquid Conductivity Method, and Imaging Method. The Height Method provides information on foamability and foam height, the Liquid Conductivity Method provides information on the liquid content and drainage dynamics of foam, and then Imaging Method provides data on the size and distribution of foam bubbles.",
				ResolutionDescription->"If no options are provided, will default to the appropriate method(s) based on the experimental options selected. Height Method is always selected.",
				Category->"Method"
			},
			{
				OptionName->FoamColumn,
				Default->Automatic,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Container,FoamColumn],Model[Container,FoamColumn]}],
					PreparedSample->False
				],
				AllowNull->False,
				Description->"The foam column that will be used to contain the sample during the experiment.",
				ResolutionDescription->"If no options are provided, will default based on temperature/method requirements. If the detection method is the Foam Imaging Method, the column will default to a Foam Imaging Module-compatible column. If temperature measurements are required, the column will default to a double-jacketed temperature column.",
				Category->"Method"
			},
			{
				OptionName->FoamColumnLoading,
				Default->Dry,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Wet,Dry]
				],
				AllowNull->False,
				Description->"Indicates whether the foam column will be pre-wetted when the sample is loaded during the experiment. Wet indicates that the sides of the foam column will be wetted with the sample during sample loading. Dry indicates that the sample will be directly loaded to the bottom of the foam column, and the sides of the column will be left dry.",
				ResolutionDescription->"If no options are provided, will default to Dry.",
				Category->"Method"
			},
			{
				OptionName->LiquidConductivityModule,
				Default->Automatic,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Part,LiquidConductivityModule],Model[Part,LiquidConductivityModule]}]
				],
				AllowNull->True,
				Description->"The Liquid Conductivity Module object that will be used in the experiment if the Liquid Conductivity Method is selected. The Liquid Conductivity Module is an attachment for the Dynamic Foam Analyzer instrument that provides information on the liquid content and drainage dynamics over time at various positions along the foam column; this is achieved by recording changes in conductivity of the foam over time, which provides information on the amount of liquid vs gas that is present. This module can only be selected if the sparge agitation method is used, as the module is incompatible with stir blades.",
				ResolutionDescription->"If no options are provided, will default to the appropriate object based on the experimental options selected.",
				Category->"Detectors"
			},
			{
				OptionName->FoamImagingModule,
				Default->Automatic,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Part,FoamImagingModule],Model[Part,FoamImagingModule]}]
				],
				AllowNull->True,
				Description->"The Foam Imaging Module object that will be used in the experiment if the Imaging Method is selected. The Foam Imaging Module transmits light through a glass prism specially fitted on the side of a foam column, in order to ascertain the 2D structure of the foam based on the principles of total reflection. Since glass and liquid have comparable diffractive indices, light that hits a foam lamella will be partially diffracted and transmitted into the foam. On the other hand, glass and air have different diffractive indices, so light that hits within the air bubble will be fully reflected and sensed by the camera, allowing for construction of a 2D image of the layer of foam located at the edge of the prism.",
				ResolutionDescription->"If no options are provided, will default to the appropriate object based on the experimental options selected.",
				Category->"Detectors"
			},

			(* Detection options*)
			{
				OptionName->Wavelength,
				Default->Automatic,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[469*Nanometer,850*Nanometer]
				],
				AllowNull->False,
				Description->"The wavelength type that will be transmitted through the foam column and detected by the default Diode Array Module during the experiment. Two wavelength types are possible, visible (469 nanometer) and infrared (850 nanometer).",
				ResolutionDescription->"If no options are provided, will default to visible light if Height Method detection is selected.",
				Category->"Decay"
			},
			{
				OptionName->HeightIlluminationIntensity,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Percent,100*Percent],
					Units->Percent
				],
				AllowNull->False,
				Description->"The illumination intensity that will be used for foam height detection by the Diode Array Module. This refers to the intensity at which the light is shone through the sample.",
				ResolutionDescription->"If no options are provided, will default to 100% if Height Method detection is selected.",
				Category->"Decay"
			},
			{
				OptionName->CameraHeight,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[55*Millimeter,260*Millimeter],
					Units->Millimeter
				],
				AllowNull->True,
				Description->"The height along the column at which the camera used by the Foam Imaging Module will be positioned during the experiment if the Imaging Method is selected.",
				Category->"Detectors"
			},
			{
				OptionName->StructureIlluminationIntensity,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Percent,100*Percent],
					Units->Percent
				],
				AllowNull->True,
				Description->"The illumination intensity that will be used for foam structure detection by the Foam Imaging Module if the Imaging Method is selected. This refers to the intensity at which the light is shone through the sample.",
				ResolutionDescription->"If no options are provided, will default to 20%.",
				Category->"Detectors"
			},
			{
				OptionName->FieldOfView,
				Default->Automatic,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[(*85 Millimeter^2,*)140 Millimeter^2(*,285 Millimeter^2*)]
				],
				AllowNull->True,
				Description->"The size of the surface area that is observable at any given moment by the camera used by the Foam Imaging Module in the experiment if the Imaging Method is selected.",
				ResolutionDescription->"If no options are provided, will default to 140 millimeters squared if the Imaging Method is selected.",
				Category->"Detectors"
			},

			(*Agitation options*)
			{
				OptionName->Agitation,
				Default->Automatic,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FoamAgitationTypeP
				],
				AllowNull->False,
				Description->"The type of agitation (sparging or stirring) that will be used to generate foam during the experiment.",
				ResolutionDescription->"If no options are provided, will default based on whether any Stir or Sparge-related options are chosen. If all are Automatic, will default to Stir. Note that if Stir is selected, the Liquid Conductivity Module cannot be used.",
				Category->"Agitation"
			},
			{
				OptionName->AgitationTime,
				Default->5*Second,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Minute,$MaxExperimentTime,1 Second,Inclusive->Right],
					Units->Alternatives[Hour,Minute,Second]
				],
				AllowNull->False,
				Description->"The amount of time the dynamic foam analysis experiment will agitate the sample to induce the production of foam.",
				Category->"Agitation"
			},
			{
				OptionName->AgitationSamplingFrequency,
				Default->5 Hertz,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Hertz,20 Hertz],
					Units->Alternatives[Hertz,Millihertz,Microhertz]
				],
				AllowNull->False,
				Description->"The data sampling frequency during the agitation period in which foam is made. The data recorded for the Height Method are the foam and liquid heights over time. The data recorded for the Imaging Method are timelapse 2D snapshots of the foam in the camera field of view. The data recorded for the Liquid Conductivity Method are the resistances at sensors spaced along the length of the foam column.",
				Category->"Agitation"
			},
			{
				OptionName->SpargeFilter,
				Default->Automatic,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Part,SpargeFilter],Model[Part,SpargeFilter]}]
				],
				AllowNull->True,
				Description->"The sparging filter that will be used to introduce gas bubbles into the column during foam generation. The filter is a glass plate with pores for bubble generation. The size of the filter must match the size of the column selected in order to only flow gas within the confines of the column.",
				ResolutionDescription->"If no options are provided, will default based on the size of the foam column used in the experiment if agitation is set to sparge.",
				Category->"Agitation"
			},
			{
				OptionName->SpargeGas,
				Default->Automatic,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FoamSpargeGasP
				],
				AllowNull->True,
				Description->"The sparging gas that will be used during foam generation in the experiment if agitation is set to sparge.",
				ResolutionDescription->"If no options are provided, will default to Air in the experiment if agitation is set to sparge.",
				Category->"Agitation"
			},
			{
				OptionName->SpargeFlowRate,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.2 Liter/Minute,1 Liter/Minute],(*TODO: check this what is internal vs extenal gas*)
					Units->Liter/Minute
				],
				AllowNull->True,
				Description->"The flow rate of the sparging gas that will be used during foam generation in the experiment if agitation is set to sparge.",
				ResolutionDescription->"If no options are provided, will default to 1 Liter/Minute in the experiment if agitation is set to sparge.",
				Category->"Agitation"
			},
			{
				OptionName->StirBlade,
				Default->Automatic,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Part,StirBlade],Model[Part,StirBlade]}]
				],
				AllowNull->True,
				Description->"The stir blade that will be used during foam generation in the experiment if agitation is set to stir.",
				ResolutionDescription->"If no options are provided, will default to stir blade in the experiment if agitation is set to stir.",(*TODO: pick a model*)
				Category->"Agitation"
			},
			{
				OptionName->StirRate,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 RPM,8000 RPM],
					Units->RPM
				],
				AllowNull->True,
				Description->"The stir rate of the stir blade that will be used during foam generation in the experiment if agitation is set to stir.",
				ResolutionDescription->"If no options are provided, will default to 5000 RPM in the experiment if agitation is set to stir.",
				Category->"Agitation"
			},
			{
				OptionName->StirOscillationPeriod,
				Default->Automatic,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Second,59 Second],
					Units->Second
				],
				AllowNull->True,
				Description->"The oscillation period setting for the stir blade that will be used during foam generation in the experiment if agitation is set to stir. This refers to the time after which the stirring blade changes stirring direction.",
				ResolutionDescription->"If no options are provided, will default to 0 second in the experiment if agitation is set to stir.",
				Category->"Agitation"
			},

			(*Decay options*)
			{
				OptionName->DecayTime,
				Default->100 Second,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Minute,$MaxExperimentTime],(*TODO: what is the range?*)
					Units->Alternatives[Hour,Minute,Second]
				],
				AllowNull->False,
				Description->"The amount of time the dynamic foam analysis experiment will allow the foam bubbles to drain and coalesce, during which experimental measurements will be taken.",
				Category->"Decay"
			},
			{
				OptionName->DecaySamplingFrequency,
				Default->1 Hertz,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Hertz,20 Hertz],
					Units->Alternatives[Hertz,Millihertz,Microhertz]
				],
				AllowNull->False,
				Description->"The data sampling frequency during the period in which the foam column undergoes decay, involving liquid draining, bubble coalescence, and foam column height decrease. The data recorded for the Height Method are the foam and liquid heights over time. The data recorded for the Imaging Method are timelapse 2D snapshots of the foam in the camera field of view. The data recorded for the Liquid Conductivity Method are the resistances at sensors spaced along the length of the foam column.",
				Category->"Decay"
			},

			(*Wash options*)
			{
				OptionName->NumberOfWashes,
				Default->Automatic,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,10,1]
				],
				AllowNull->True,
				Description->"The number of washes that will be used to clean the column and/or the stir blade/filter plate after the experiment is run.",
				ResolutionDescription->"If no options are provided, will default to the PreferredNumberOfWashes for the FoamColumn.",
				Category->"Wash"
			},

			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples that are being measured in ExperimentDynamicFoamAnalysis, for use in downstream unit operations.",
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
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the containers of the samples that are being measured in ExperimentDynamicFoamAnalysis, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			}
		],
		(*Shared options*)
		AnalyticalNumberOfReplicatesOption,
		SamplesInStorageOptions,
		NonBiologyFuntopiaSharedOptions,
		SimulationOption,
		ModelInputOptions
	}
];

(* ::Subsubsection:: *)
(*ExperimentDynamicFoamAnalysis Errors and Warnings*)

Error::DynamicFoamAnalysisNoVolume="In ExperimentDynamicFoamAnalysis, the following samples `1` do not have their Volume field populated. The Volume of the sample must be known in order to determine if a dynamic foam analysis experiment can be run on the sample.";
(*
Error DynamicFoamAnalysisNotLiquid="In ExperimentDynamicFoamAnalysis, the following samples `1` are not liquid. The State of the sample must be liquid in order for a dynamic foam analysis experiment to be run on the sample.";
*)
Error::DFAHeightMethodRequiredMismatch="In ExperimentDynamicFoamAnalysis, the DetectionMethod must be Automatic or contain HeightMethod (`1`), which conflicts for the following samples: `2`.";
Error::DFAImagingMethodOnlyMismatch="In ExperimentDynamicFoamAnalysis, the DetectionMethod (`1`) must be Automatic or contain ImagingMethod for the option values FoamImagingModule (`2`), CameraHeight (`3`), StructureIlluminationIntensity (`4`), FieldOfViews (`5`) to be set, which conflicts for the following samples: `6`.";
Error::DFALiquidConductivityOnlyMismatch="In ExperimentDynamicFoamAnalysis, the DetectionMethod (`1`) must be Automatic or contain LiquidConductivityMethod for the option value LiquidConductivityModule (`2`) to be set, which conflicts for the following samples: `3`.";
Error::DFAstirLiquidConductivityMismatch="In ExperimentDynamicFoamAnalysis, the Agitation (`1`) must not be Stir and Stir-related option values StirBlade (`2`), StirRate (`3`), StirOscillationPeriod (`4`) cannot be selected, for DetectionMethod (`5`) to contain LiquidConductivityMethod or for the LiquidConductivityModule (`6`) to be set, which conflicts for the following samples: `7`.";
Error::DFAStirOnlyMismatch="In ExperimentDynamicFoamAnalysis, the Agitation (`1`) must be Automatic or Stir for the option values StirBlade (`2`), StirRate (`3`), StirOscillationPeriod (`4`) to be set, which conflicts for the following samples: `5`.";
Error::DFASpargeOnlyMismatch="In ExperimentDynamicFoamAnalysis, the Agitation (`1`) must be Automatic or Sparge for the option values SpargeFilter (`2`), SpargeGas (`3`), SpargeFlowRate (`4`) to be set, which conflicts for the following samples: `5`.";
Error::DFAAgitationMethodsMismatch="In ExperimentDynamicFoamAnalysis, options that correspond to Agitation of Stir and Sparge (`1`) cannot be simultaneously selected, which conflicts for the following samples:`2`.";
Error::DFAImagingMethodNullMismatch="In ExperimentDynamicFoamAnalysis, if the DetectionMethod (`1`) contains ImagingMethod, the option values FoamImagingModule (`2`), CameraHeight (`3`), StructureIlluminationIntensity (`4`), FieldOfView (`5`) must not be Null, which conflicts for the following samples: `6`.";
Error::DFALiquidConductivityMethodNullMismatch="In ExperimentDynamicFoamAnalysis, if the DetectionMethod (`1`) contains LiquidConductivityMethod, the option value LiquidConductivityModule (`2`) must not be Null, which conflicts for the following samples: `3`.";
Error::DFAStirNullMismatch="In ExperimentDynamicFoamAnalysis, if the Agitation (`1`) is Stir, the option values StirRate (`2`), StirBlade (`3`), StirOscillationPeriod (`4`) must not be Null, which conflicts for the following samples: `5`.";
Error::DFASpargeNullMismatch="In ExperimentDynamicFoamAnalysis, if the Agitation (`1`) is Sparge, the option values SpargeFilter (`2`), SpargeGas (`3`), SpargeFlowRate (`4`) must not be Null, which conflicts for the following samples: `5`.";
(*
Error DFASampleVolumeLowError="In ExperimentDynamicFoamAnalysis, samples must have the total volume from SampleVolume and NumberOfReplicates (`1`) greater than the available volume of the sample, which conflicts for the following samples: `2`.";
*)
Error::DFASampleVolumeFoamColumnError="In ExperimentDynamicFoamAnalysis, samples must have the SampleVolume (`1`) larger than the MinSampleVolume allowed by the Foam Column, which conflicts for the following samples: `2`.";
Error::DFATemperatureMonitoringError="In ExperimentDynamicFoamAnalysis, temperature monitoring (`1`) cannot be run with the Liquid Conductivity Method as one of the DetectionMethods (`2`), or with Agitation (`3`) as Stir, which conflicts for the following samples: `2`.";
Error::DFAImagingColumnError="In ExperimentDynamicFoamAnalysis, if the DetectionMethod (`1`) includes Imaging Method, foam columns (`2`) that contain prisms must be used, which conflicts for the following samples: `3`.";
Error::DFATemperatureColumnError="In ExperimentDynamicFoamAnalysis, experiments run at a non-ambient Temperature (`1`) must have foam columns (`2`) that are double jacketed, which conflicts for the following samples: `3`.";
Warning::DFAAgitationTime="In ExperimentDynamicFoamAnalysis, the AgitationTime selected (`1`) is <2 second or >1 minute, which is outside the suggested range for this experiment: `2`.";
Warning::DFAAgitationSamplingFrequencyLow="In ExperimentDynamicFoamAnalysis, the AgitationSamplingFrequency selected (`1`) is low, and would cause data to be sampled only once during the specified AgitationTime (`2`) for this experiment: `3`.";
Warning::DFADecayTime="In ExperimentDynamicFoamAnalysis, the DecayTime selected (`1`) is <5 second, which is lower than the suggested range for this experiment: `2`.";
Warning::DFADecaySamplingFrequencyLow="In ExperimentDynamicFoamAnalysis, the DecaySamplingFrequency (`1`) selected is low, and would cause data to be sampled only once during the specified DecayTime (`2`) for this experiment: `3`.";
Warning::DFANumberOfWashesLow="In ExperimentDynamicFoamAnalysis, the NumberOfWashes selected (`1`) is low, and could cause the foam column to be inadequately washed between samples for this experiment: `2`.";

(* ::Subsubsection:: *)
(*ExperimentDynamicFoamAnalysis*)

ExperimentDynamicFoamAnalysis[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedSamplesNamed,listedOptionsNamed,cacheOption,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		mySamplesWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed,messages,
		samplePreparationCache,safeOps,safeOpsTests,validLengths,validLengthTests,
		unresolvedOptions,unresolvedOptionsTests,combinedOptions,expandedCombinedOptions,cacheBall,resolvedOptionsResult,
		resolvedOptions,resolutionTests,resolvedOptionsNoHidden,protocolObject,resourcePackets,resourcePacketTests,
		optionsWithObjects,dfaInstrumentModels,allInstrumentModels,objectContainerPacketFields,modelContainerPacketFields,allSamplePackets,allPackets,previewRule,optionsRule,testsRule,
		instrumentModelPacket,instrumentObjectPacket,potentialColumnObjectPacket,potentialColumnModelPacket,
		objectSamplePacketFields,modelSamplePacketFields,instrumentObjects,userSpecifiedObjects,userSpecifiedItems,simulatedSampleQ,objectsExistQs,objectsExistTests,returnEarlyQ,allTests,validQ,
		modelInstrumentObjects,potentialColumnModels,columnObjects,modelColumnObjects,allColumnModels,updatedSimulation,performSimulationQ,simulatedProtocol,simulation
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links *)
	{listedSamplesNamed,listedOptionsNamed}=removeLinks[ToList[mySamples],ToList[myOptions]];

	(* Make sure we're working with a list of options *)
	cacheOption=ToList[Lookup[listedOptionsNamed,Cache,{}]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentDynamicFoamAnalysis,
			listedSamplesNamed,
			listedOptionsNamed
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentDynamicFoamAnalysis,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentDynamicFoamAnalysis,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentDynamicFoamAnalysis,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentDynamicFoamAnalysis,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{unresolvedOptions,unresolvedOptionsTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentDynamicFoamAnalysis,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentDynamicFoamAnalysis,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[unresolvedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,unresolvedOptionsTests],
			Options->$Failed,
			Preview->Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	combinedOptions=ReplaceRule[safeOps,unresolvedOptions];

	(* Expand index-matching options *)
	expandedCombinedOptions=Last[ExpandIndexMatchedInputs[ExperimentDynamicFoamAnalysis,{ToList[mySamplesWithPreparedSamples]},combinedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

	(* Any options whose values could be an object *)
	optionsWithObjects={
		Instrument,
		FoamColumn,
		LiquidConductivityModule,
		FoamImagingModule,
		SpargeFilter,
		StirBlade
	};

	(*all instruments*)
	instrumentObjects=Cases[Flatten[Lookup[expandedCombinedOptions,optionsWithObjects]],ObjectP[Object[Instrument,DynamicFoamAnalyzer]]];
	modelInstrumentObjects=Cases[Flatten[Lookup[expandedCombinedOptions,optionsWithObjects]],ObjectP[Model[Instrument,DynamicFoamAnalyzer]]];
	dfaInstrumentModels=Search[Model[Instrument,DynamicFoamAnalyzer]];
	allInstrumentModels=DeleteDuplicates@Cases[Join[modelInstrumentObjects,dfaInstrumentModels],ObjectReferenceP[]];

	(*all possible foam columns*)
	columnObjects=Cases[Flatten[Lookup[expandedCombinedOptions,optionsWithObjects]],ObjectP[Object[Container,FoamColumn]]];
	modelColumnObjects=Cases[Flatten[Lookup[expandedCombinedOptions,optionsWithObjects]],ObjectP[Model[Container,FoamColumn]]];
	potentialColumnModels=Search[Model[Container,FoamColumn]];
	allColumnModels=DeleteDuplicates@Cases[Join[modelColumnObjects,potentialColumnModels],ObjectReferenceP[]];

	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet[
		(*For sample prep*)
		Sequence@@SamplePreparationCacheFields[Object[Sample]],
		(* For Experiment *)
		Density,RequestedResources,Notebook,IncompatibleMaterials,
		(*Safety and transport, previously from model*)
		Ventilated
	];

	modelSamplePacketFields=Packet[Model[Join[SamplePreparationCacheFields[Model[Sample]],{Notebook,
		IncompatibleMaterials,Density,Products}]]];

	objectContainerPacketFields=Packet[Container[SamplePreparationCacheFields[Object[Container]]]];

	modelContainerPacketFields=Packet[Container[Model][{
		Sequence@@SamplePreparationCacheFields[Model[Container]]
	}]];

	(*(* get any specified objects *)
	userSpecifiedItems = DeleteDuplicates[Cases[Flatten[Lookup[ToList[combinedOptions],{FoamColumn,SpargeFilter,StirBlade},{}]],ObjectP[]]];

	(* Extract any other objects that the user has explicitly specified *)
	userSpecifiedObjects=Complement[
		DeleteDuplicates@Cases[
			Flatten@Join[ToList[mySamplesWithPreparedSamples],Lookup[ToList[combinedOptions],optionsWithObjects,{}]],
			ObjectP[]
		],
		userSpecifiedItems
	];

	(* Check that the specified objects exist or are visible to the current user *)
	simulatedSampleQ=MemberQ[Download[Lookup[updatedSimulation[[1]], Packets],Object], #] &/@userSpecifiedObjects;
	objectsExistQs=DatabaseMemberQ[PickList[userSpecifiedObjects,simulatedSampleQ,False]];

	(* Build tests for object existence *)
	objectsExistTests=If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
			{PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs),
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist,PickList[PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs,False]];
			Message[Error::InvalidInput,PickList[PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs,False]]
		];
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOptionTests,validLengthTests,unresolvedOptionsTests,objectsExistTests],
			Options->$Failed,
			Preview->Null
		}]
	];*)

	allPackets=Check[
		Quiet[
			Download[
				{
					ToList[mySamplesWithPreparedSamples],
					instrumentObjects,
					allInstrumentModels,
					columnObjects,
					allColumnModels
				},
				{
					{
						objectSamplePacketFields,
						modelSamplePacketFields,
						objectContainerPacketFields,
						modelContainerPacketFields
					},
					{    (*Object[Instrument]*)
						Packet[Object,Name,Status,Model],
						Packet[Model[{Object,WettedMaterials,Name,DetectionMethods,MinTemperature,MaxTemperature,AgitationTypes,AvailableGases,MinFlowRate,MaxFlowRate,MinStirRate,MaxStirRate,MinOscillationPeriod,MaxOscillationPeriod,IlluminationWavelengths,MinFoamHeightSamplingFrequency,MaxFoamHeightSamplingFrequency}]]
					},
					{    (*Model[Instrument]*)
						Packet[Object,WettedMaterials,Name,DetectionMethods,MinTemperature,MaxTemperature,AgitationTypes,AvailableGases,MinFlowRate,MaxFlowRate,MinStirRate,MaxStirRate,MinOscillationPeriod,MaxOscillationPeriod,IlluminationWavelengths,MinFoamHeightSamplingFrequency,MaxFoamHeightSamplingFrequency]
					},
					{
						(*Object[Container,FoamColumn]*)
						Packet[Object,Model],
						Packet[Model[{Object,Objects,WettedMaterials,Detector,Jacketed,Prism,MinSampleVolume,MaxSampleVolume,PreferredWashSolvent,PreferredNumberOfWashes}]]
					},
					{ (*Potential Columns models*)
						Packet[Object,Objects,WettedMaterials,Detector,Jacketed,Prism,MinSampleVolume,MaxSampleVolume,PreferredWashSolvent,PreferredNumberOfWashes],
						Packet[Objects[{Model,Status,Restricted}]]
					}
				},
				Cache->FlattenCachePackets[{samplePreparationCache,cacheOption}],
				Simulation->updatedSimulation,
				Date->Now
			],
			{Download::FieldDoesntExist,Download::NotLinkField}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(* Return early if objects do not exist *)
	If[MatchQ[allPackets, $Failed],
		Return[$Failed]
	];

	(* otherwise, split up the packets in the download call*)
	{
		allSamplePackets,
		instrumentObjectPacket,
		instrumentModelPacket,
		potentialColumnObjectPacket,
		potentialColumnModelPacket
	}=allPackets;

	cacheBall=FlattenCachePackets[{
		samplePreparationCache,cacheOption,allSamplePackets,instrumentModelPacket,instrumentObjectPacket,potentialColumnObjectPacket,potentialColumnModelPacket
	}];

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolvedOptionsResult = Check[
		{resolvedOptions, resolutionTests} = If[gatherTests,
			resolveExperimentDynamicFoamAnalysisOptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> {Result, Tests},Simulation->updatedSimulation, Cache -> cacheBall],
			{resolveExperimentDynamicFoamAnalysisOptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> Result, Simulation->updatedSimulation, Cache -> cacheBall], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveAbsorbanceOptions doesn't have access to listedOptions *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentDynamicFoamAnalysis,
		RemoveHiddenOptions[ExperimentDynamicFoamAnalysis, resolvedOptions],
		Ignore -> myOptionsWithPreparedSamples,
		Messages -> False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ=Which[
		MatchQ[resolvedOptionsResult,$Failed],True,
		gatherTests,Not[RunUnitTest[<|"Tests"->resolutionTests|>,Verbose->False,OutputFormat->SingleBoolean]],
		True,False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,unresolvedOptionsTests,resolutionTests],
			Options->RemoveHiddenOptions[ExperimentDynamicFoamAnalysis,resolvedOptionsNoHidden],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	(* Build packets with resources *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	{resourcePackets,resourcePacketTests}=If[returnEarlyQ,
		{$Failed,{}},
		If[gatherTests,
		dynamicFoamAnalysisResourcePackets[ToList[mySamplesWithPreparedSamples],expandedCombinedOptions,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
		{dynamicFoamAnalysisResourcePackets[ToList[mySamplesWithPreparedSamples],expandedCombinedOptions,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],Null}
	]];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentDynamicFoamAnalysis[FirstOrDefault[resourcePackets,$Failed],ToList[mySamplesWithPreparedSamples],resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],
		{Null, Null}
	];

	(* get all the tests together *)
	allTests=Cases[Flatten[{safeOpsTests,validLengthTests,unresolvedOptionsTests,resolutionTests,resourcePacketTests}],_EmeraldTest];

	(* figure out if we are returning $Failed for the Result option *)
	(* the tricky part is that if the Output option includes Tests _and_ Result, messages will be suppressed.
		Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed
		Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ=Which[
		(* needs to be MemberQ because could possibly generate multiple protocols *)
		MatchQ[resourcePackets,$Failed],
		False,
		gatherTests&&MemberQ[output,Result],
		RunUnitTest[<|"Tests"->allTests|>,OutputFormat->SingleBoolean,Verbose->False],
		True,
		True
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
		allTests,
		Null
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->allTests,
			Options->RemoveHiddenOptions[ExperimentDynamicFoamAnalysis,resolvedOptionsNoHidden],
			Preview->Null,
			Simulation->simulation
		}]
	];

	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
	protocolObject=Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[resourcePackets,$Failed]||MatchQ[resolvedOptionsResult,$Failed],
		$Failed,

		(* If we're in simulation mode, we want to upload our simulation to the global simulation. *)
		(* Were we asked to simulate the procedure? *)
		MatchQ[Lookup[safeOps, SimulateProcedure], True],
		dynamicFoamAnalysisSimulationPackets[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Cache->cacheBall,
			Simulation->updatedSimulation
		],

		True,
		UploadProtocol[
			(*protocol packet*)
			resourcePackets[[1]],
			(* unit operation packets*)
			Flatten@{resourcePackets[[2]]},
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			CanaryBranch->Lookup[safeOps,CanaryBranch],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,DynamicFoamAnalysis],
			Simulation->updatedSimulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->allTests,
		Options->RemoveHiddenOptions[ExperimentDynamicFoamAnalysis,resolvedOptionsNoHidden],
		Preview->Null
	}
];

(* Note: The container overload should come after the sample overload. *)
ExperimentDynamicFoamAnalysis[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedContainers,listedOptionsNamed,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		samplePreparationCache,containerToSampleResult,containerToSampleOutput,containerToSampleSimulation,samples,sampleOptions,containerToSampleTests,updatedSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedContainers,listedOptionsNamed}={ToList[myContainers],ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentDynamicFoamAnalysis,
			ToList[listedContainers],
			ToList[listedOptionsNamed]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
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
		{containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
			ExperimentDynamicFoamAnalysis,
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
				ExperimentDynamicFoamAnalysis,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
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
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentDynamicFoamAnalysis[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];

(* ::Subsubsection:: *)
(*resolveExperimentDynamicFoamAnalysisOptions *)

DefineOptions[
	resolveExperimentDynamicFoamAnalysisOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentDynamicFoamAnalysisOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentDynamicFoamAnalysisOptions]]:=Module[
	{
		(*Boilerplate variables*)
		outputSpecification,output,gatherTests,cache,unresolvedPrepOptions,unresolvedExperimentOptions,simulatedSamples,resolvedSamplePrepOptions,simulatedCache,samplePrepTests,
		dynamicFoamAnalysisOptionsAssociation,invalidInputs,invalidOptions,targetContainers,resolvedAliquotOptions,aliquotTests,resultRule,testsRule,messages,

		(* Sample, container, and instrument packets to download*)
		instrumentDownloadFields,listedSampleContainerPackets,instrumentPackets,samplePackets,sampleContainerPackets,sampleContainerModelPackets,sampleModelPackets,
		simulatedSampleContainerModels,simulatedSampleContainerObjects,foamColumnDownloadFields,foamColumnPackets,sampleObjectPrepFields,sampleModelPrepFields,sampleContainerFields,

		(* Input validation *)
		discardedSamplePackets,discardedInvalidInputs,discardedTest,noVolumeSamplePackets,noVolumeInvalidInputs,noVolumeTest,
		notLiquidInvalidInputs,notLiquidSamplePackets,notLiquidTest,

		(* for option rounding *)
		roundedExperimentOptions,optionsPrecisionTests,allOptionsRounded,

		(* options that do not need to be rounded *)
		consolidateAliquots,instrument,name,numberOfReplicates,downloadFoamColumn,temperature,agitationTime,agitationSamplingFrequency,decayTime,decaySamplingFrequency,foamColumnLoading,

		(* conflicting options *)
		validNameQ,nameInvalidOption,validNameTest,
		heightMethodRequiredMismatches,heightMethodRequiredMismatchInputs,heightMethodRequiredMismatchOptions,heightMethodRequiredInvalidOptions,heightMethodRequiredTest,
		imagingMethodOnlyMismatches,imagingMethodOnlyMismatchInputs,imagingMethodOnlyMismatchOptions,imagingMethodOnlyInvalidOptions,imagingMethodOnlyTest,
		liquidConductivityOnlyMismatches,liquidConductivityOnlyMismatchOptions,liquidConductivityOnlyMismatchInputs,liquidConductivityOnlyInvalidOptions,liquidConductivityOnlyTest,
		stirLiquidConductivityMismatches,stirLiquidConductivityMismatchOptions,stirLiquidConductivityMismatchInputs,stirLiquidConductivityInvalidOptions,stirLiquidConductivityTest,
		stirOnlyMismatches,stirOnlyMismatchOptions,stirOnlyMismatchInputs,stirOnlyInvalidOptions,stirOnlyTest,
		spargeOnlyMismatches,spargeOnlyMismatchOptions,spargeOnlyMismatchInputs,spargeOnlyInvalidOptions,spargeOnlyTest,
		agitationMethodsMismatches,agitationMethodsMismatchOptions,agitationMethodsMismatchInputs,agitationMethodsInvalidOptions,agitationMethodsTest,
		imagingMethodNullMismatches,imagingMethodNullMismatchOptions,imagingMethodNullMismatchInputs,imagingMethodNullInvalidOptions,imagingMethodNullTest,
		liquidConductivityMethodNullMismatches,liquidConductivityMethodNullMismatchOptions,liquidConductivityMethodNullMismatchInputs,liquidConductivityMethodNullInvalidOptions,liquidConductivityMethodNullTest,
		stirNullMismatches,stirNullMismatchOptions,stirNullMismatchInputs,stirNullInvalidOptions,stirNullTest,spargeNullMismatches,spargeNullMismatchOptions,spargeNullMismatchInputs,spargeNullInvalidOptions,spargeNullTest,

		(* map thread*)
		mapThreadFriendlyOptions,resolvedSampleVolumes,resolvedTemperatureMonitoring,resolvedDetectionMethod,resolvedFoamColumn,resolvedLiquidConductivityModule,resolvedFoamImagingModule,
		resolvedWavelength,resolvedHeightIlluminationIntensity,resolvedCameraHeight,resolvedStructureIlluminationIntensity,resolvedFieldOfView,resolvedSpargeFilter,
		resolvedAgitation,resolvedSpargeGas,resolvedSpargeFlowRate,resolvedStirBlade,resolvedStirRate,resolvedStirOscillationPeriod,
		resolvedNumberOfWashes,volumes,

		(* Errors and Testing *)
		sampleVolumeLowErrors,sampleVolumeLowInvalidOptions,sampleVolumeLowTest,temperatureMonitoringErrors,temperatureMonitoringInvalidOptions,temperatureMonitoringTest,
		sampleVolumeFoamColumnErrors,sampleVolumeFoamColumnInvalidOptions,sampleVolumeFoamColumnTest,
		imagingColumnErrors,imagingColumnInvalidOptions,imagingColumnTest,temperatureColumnErrors,temperatureColumnInvalidOptions,temperatureColumnTest,
		agitationTimeWarnings,agitationTimeWarningTest,agitationSamplingFrequencyLowWarnings,agitationSamplingFrequencyLowTest,
		decayTimeWarnings,decayTimeWarningTest,decaySamplingFrequencyLowWarnings,decaySamplingFrequencyLowTest,
		numberOfWashesLowWarnings,numberOfWashesLowTest,allTests,

		resolvedOptions,resolvedPostProcessingOptions,resolvedEmail,

		(* compatible materials check *)
		compatibleMaterialsBool,compatibleMaterialsTests,compatibleMaterialsInvalidOption,materials,compatibilityFoamColumns,

		(* misc options *)
		emailOption,uploadOption,nameOption,confirmOption,canaryBranchOption,parentProtocolOption,fastTrackOption,templateOption,samplesInStorageOption,operator,
		validSampleStorageConditionQ,validSampleStorageTests,invalidStorageConditionOptions,simulation,updatedSimulation,resolvedSampleLabel,resolvedSampleContainerLabel


	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];

	(*Fetch our simmulation from the parent function*)
	simulation=Lookup[ToList[myResolutionOptions],Simulation,Null];

	(* Separate out our DynamicFoamAnalysis options from our Sample Prep options. *)
	{unresolvedPrepOptions,unresolvedExperimentOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentDynamicFoamAnalysis,mySamples,unresolvedPrepOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentDynamicFoamAnalysis,mySamples,unresolvedPrepOptions,Cache->cache,Simulation->simulation,Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	dynamicFoamAnalysisOptionsAssociation=Association[unresolvedExperimentOptions];

	(* DOWNLOAD: Extract the packets that we need from our downloaded cache. *)

	(* Get the instrument *)
	instrument=Lookup[dynamicFoamAnalysisOptionsAssociation,Instrument]/.Automatic->Null;
	downloadFoamColumn=Lookup[dynamicFoamAnalysisOptionsAssociation,FoamColumn]/.Automatic->Null;
	name=Lookup[dynamicFoamAnalysisOptionsAssociation,Name];

	(* Get our ConsolidateAliquots option. Replace Automatic with False since this is how it'll be resolved in the aliquot resolver. *)
	consolidateAliquots=Lookup[myOptions,ConsolidateAliquots]/.{Automatic->False};

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)

	instrumentDownloadFields=If[
		(* If instrument is an object, download fields from the Model *)
		MatchQ[instrument,ObjectP[Object[Instrument]]],
		Packet[Model[{Object,WettedMaterials,DetectionMethods,MinTemperature,MaxTemperature,AgitationTypes,AvailableGases,MinFlowRate,MaxFlowRate,MinStirRate,MaxStirRate,MinOscillationPeriod,MaxOscillationPeriod,IlluminationWavelengths,MinFoamHeightSamplingFrequency,MaxFoamHeightSamplingFrequency}]],

		(* If instrument is a Model, download fields*)
		Packet[Object,WettedMaterials,DetectionMethods,MinTemperature,MaxTemperature,AgitationTypes,AvailableGases,MinFlowRate,MaxFlowRate,MinStirRate,MaxStirRate,MinOscillationPeriod,MaxOscillationPeriod,IlluminationWavelengths,MinFoamHeightSamplingFrequency,MaxFoamHeightSamplingFrequency]
	];

	foamColumnDownloadFields=Flatten[If[
		(* If instrument is an object, download fields from the Model *)
		MatchQ[Sequence@@Flatten@{#},ObjectP[Object[Container,FoamColumn]]],
		{Packet[Model[{Object,Objects,Detector,Jacketed,Prism,MinSampleVolume,MaxSampleVolume,PreferredWashSolvent,PreferredNumberOfWashes}]],
		Packet[Model]},

		(* If instrument is a Model, download fields*)
		Packet[Object,Objects,Detector,Jacketed,Prism,MinSampleVolume,MaxSampleVolume,PreferredWashSolvent,PreferredNumberOfWashes]
	]&/@downloadFoamColumn];

	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamples, using our updatedSimulation *)

	(* Remember to download from simulatedSamples *)
	sampleObjectPrepFields = Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence], IncompatibleMaterials, RequestedResources, State,Model,Status, Volume, Tablet];
	sampleModelPrepFields = Packet[Model[Flatten[{SamplePreparationCacheFields[Object[Sample], Format -> Sequence], State,Products, IncompatibleMaterials, RequestedResources, Volume, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, Deprecated, Tablet}]]];
	sampleContainerFields = Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], Model}]]];

	{listedSampleContainerPackets,instrumentPackets,foamColumnPackets}=Quiet[Download[
		{
			simulatedSamples,
			{instrument},
			downloadFoamColumn
		},
		{
			{
				sampleObjectPrepFields,
				sampleModelPrepFields,
				sampleContainerFields
			},
			{
				instrumentDownloadFields
			},

				foamColumnDownloadFields

		},
		Simulation->updatedSimulation,
		Cache->cache,
		Date->Now
	],
		{Download::FieldDoesntExist,Download::NotLinkField,Download::MissingCacheField}
	];

	(* add downloaded packets to cache *)
	cache=FlattenCachePackets[{cache,Flatten[{listedSampleContainerPackets,instrumentPackets,foamColumnPackets}]}];

	(* --- Extract out the packets from the download --- *)
	(* -- sample packets -- *)
	samplePackets=listedSampleContainerPackets[[All,1]];
	sampleModelPackets=listedSampleContainerPackets[[All,2]];
	sampleContainerPackets=listedSampleContainerPackets[[All,3]];
	simulatedSampleContainerModels=Lookup[sampleContainerPackets,Model][Object];
	simulatedSampleContainerObjects=Lookup[sampleContainerPackets,Object,{}];

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)

	(*- 1. Check if samples are discarded -*)
	(* Get the samples from simulatedSamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->cache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->cache]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs],Cache->cache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*- 2. Check if the samples have volume -*)
	(* Get the samples from simulatedSamples that do not have volume populated. *)
	noVolumeSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Volume->NullP]];
	noVolumeInvalidInputs=Lookup[noVolumeSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[noVolumeInvalidInputs]>0&&!gatherTests,
		Message[Error::DynamicFoamAnalysisNoVolume,ObjectToString[noVolumeInvalidInputs,Cache->cache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[noVolumeInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[noVolumeInvalidInputs,Cache->cache]<>" have volume populated:",True,False]
			];

			passingTest=If[Length[noVolumeInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,noVolumeInvalidInputs],Cache->cache]<>" have volume populated:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*(*- 3. Check if the samples are liquid -*)
	(*Get the samples from simulatedSamples that are not liquid*)
	notLiquidSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[State->Solid|Gas|Null]];
	notLiquidInvalidInputs=Lookup[notLiquidSamplePackets,Object,{}];
	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[notLiquidInvalidInputs]>0&&!gatherTests,
		Message[Error DynamicFoamAnalysisNotLiquid,ObjectToString[notLiquidInvalidInputs,Cache->cache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	notLiquidTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[notLiquidInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[notLiquidInvalidInputs,Cache->cache]<>" are liquid:",True,False]
			];

			passingTest=If[Length[notLiquidInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[simulatedSamples,notLiquidInvalidInputs],Cache->cache]<>" are liquid:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];*)

	(*-- OPTION PRECISION CHECKS --*)
	{roundedExperimentOptions,optionsPrecisionTests}=If[gatherTests,
		RoundOptionPrecision[
			dynamicFoamAnalysisOptionsAssociation,
			{
				Temperature,
				CameraHeight,
				StructureIlluminationIntensity,
				AgitationTime,
				AgitationSamplingFrequency,
				SpargeFlowRate,
				StirRate,
				StirOscillationPeriod,
				DecayTime,
				DecaySamplingFrequency,
				HeightIlluminationIntensity,
				SampleVolume
			},
			{
				1 Celsius,
				1 Millimeter,
				1 Percent,
				1 Second,
				0.1 Hertz,
				0.01 Liter/Minute,
				1 RPM,
				1 Second,
				1 Second,
				0.1 Hertz,
				1 Percent,
				1 Milliliter
			},
			AvoidZero->{True,True,True,True,True,True,True,False,True,True,True,True},
			Output->{Result,Tests}
		],
		{
			RoundOptionPrecision[
				dynamicFoamAnalysisOptionsAssociation,
				{
					Temperature,
					CameraHeight,
					StructureIlluminationIntensity,
					AgitationTime,
					AgitationSamplingFrequency,
					SpargeFlowRate,
					StirRate,
					StirOscillationPeriod,
					DecayTime,
					DecaySamplingFrequency,
					HeightIlluminationIntensity,
					SampleVolume
				},
				{
					1 Celsius,
					1 Millimeter,
					1 Percent,
					1 Second,
					0.1 Hertz,
					0.01 Liter/Minute,
					1 RPM,
					1 Second,
					1 Second,
					0.1 Hertz,
					1 Percent,
					1 Milliliter
				}],
			Null
		}
	];

	allOptionsRounded=ReplaceRule[
		myOptions,
		Normal[roundedExperimentOptions],
		Append->False
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* 1. Check that the protocol name is unique *)
	validNameQ=If[MatchQ[name,_String],
		(* If the name was specified, make sure its not a duplicate name *)
		Not[DatabaseMemberQ[Object[Protocol,DynamicFoamAnalysis,name]]],
		(* Otherwise, its all good *)
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOption=If[!validNameQ&&!gatherTests,
		(
			Message[Error::DuplicateName,"DynamicFoamAnalysis protocol"];
			{Name}
		),
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already a DynamicFoamAnalysis protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* 2. HeightMethod must also be selected for DetectionMethod *)
	heightMethodRequiredMismatches=MapThread[
		Function[{detectionMethod,sampleObject},
			(* DetectionMethod must be Automatic or include HeightMethod *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[!MemberQ[Flatten[{detectionMethod}],HeightMethod|Automatic],
				{{detectionMethod},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DetectionMethod],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{heightMethodRequiredMismatchOptions,heightMethodRequiredMismatchInputs}=If[MatchQ[heightMethodRequiredMismatches,{}],
		{{},{}},
		Transpose[heightMethodRequiredMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	heightMethodRequiredInvalidOptions=If[Length[heightMethodRequiredMismatchOptions]>0&&!gatherTests,
		Message[Error::DFAHeightMethodRequiredMismatch,heightMethodRequiredMismatchOptions,heightMethodRequiredMismatchInputs];
		{DetectionMethod},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	heightMethodRequiredTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,heightMethodRequiredMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The option DetectionMethod must be Automatic or contains HeightMethod, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[heightMethodRequiredMismatchInputs]>0,
				Test["The option DetectionMethod must be Automatic or contains HeightMethod, for the input(s) "<>ObjectToString[heightMethodRequiredMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 3. ImagingMethod and FoamImagingModule/CameraHeight/StructureIlluminationIntensity/FieldOfView are compatible *)
	imagingMethodOnlyMismatches=MapThread[
		Function[{detectionMethod,foamImagingModule,cameraHeight,structureIlluminationIntensity,fieldOfView,sampleObject},
			(* FoamImagingModule/CameraHeight/StructureIlluminationIntensity/FieldOfView can only be set when DetectionMethod is Automatic or includes ImagingMethod *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[foamImagingModule,Except[Null|Automatic]]||MatchQ[cameraHeight,Except[Null|Automatic]]||MatchQ[structureIlluminationIntensity,Except[Null|Automatic]]||MatchQ[fieldOfView,Except[Null|Automatic]])&&!MemberQ[Flatten[{detectionMethod}],ImagingMethod|Automatic],
				{{detectionMethod,foamImagingModule,cameraHeight,structureIlluminationIntensity,fieldOfView},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DetectionMethod],Lookup[allOptionsRounded,FoamImagingModule],Lookup[allOptionsRounded,CameraHeight],Lookup[allOptionsRounded,StructureIlluminationIntensity],Lookup[allOptionsRounded,FieldOfView],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{imagingMethodOnlyMismatchOptions,imagingMethodOnlyMismatchInputs}=If[MatchQ[imagingMethodOnlyMismatches,{}],
		{{},{}},
		Transpose[imagingMethodOnlyMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	imagingMethodOnlyInvalidOptions=If[Length[imagingMethodOnlyMismatchOptions]>0&&!gatherTests,
		Message[Error::DFAImagingMethodOnlyMismatch,Sequence@@Sequence@@imagingMethodOnlyMismatchOptions,imagingMethodOnlyMismatchInputs];
		{DetectionMethod,FoamImagingModule,CameraHeight,StructureIlluminationIntensity,FieldOfView},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	imagingMethodOnlyTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,imagingMethodOnlyMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options FoamImagingModule, CameraHeight, StructureIlluminationIntensity, and FieldOfView are only set when DetectionMethod is Automatic or contains ImagingMethod, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[imagingMethodOnlyMismatchInputs]>0,
				Test["The options FoamImagingModule, CameraHeight, StructureIlluminationIntensity, and FieldOfView are only set when DetectionMethod is Automatic or contains ImagingMethod, for the input(s) "<>ObjectToString[imagingMethodOnlyMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 4. LiquidConductivityMethod and LiquidConductivityModule are compatible *)
	liquidConductivityOnlyMismatches=MapThread[
		Function[{detectionMethod,liquidConductivityModule,sampleObject},
			(* LiquidConductivityModule can only be set when DetectionMethod is Automatic or includes LiquidConductivityMethod *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[liquidConductivityModule,Except[Null|Automatic]])&&!MemberQ[Flatten[{detectionMethod}],LiquidConductivityMethod|Automatic],
				{{detectionMethod,liquidConductivityModule},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DetectionMethod],Lookup[allOptionsRounded,LiquidConductivityModule],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{liquidConductivityOnlyMismatchOptions,liquidConductivityOnlyMismatchInputs}=If[MatchQ[liquidConductivityOnlyMismatches,{}],
		{{},{}},
		Transpose[liquidConductivityOnlyMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	liquidConductivityOnlyInvalidOptions=If[Length[liquidConductivityOnlyMismatchOptions]>0&&!gatherTests,
		Message[Error::DFALiquidConductivityOnlyMismatch,Sequence@@Sequence@@liquidConductivityOnlyMismatchOptions,liquidConductivityOnlyMismatchInputs];
		{DetectionMethod,LiquidConductivityModule},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	liquidConductivityOnlyTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,liquidConductivityOnlyMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The option LiquidConductivityModule is only set when DetectionMethod is Automatic or contains LiquidConductivityMethod, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[liquidConductivityOnlyMismatchInputs]>0,
				Test["The option LiquidConductivityModule is only set when DetectionMethod is Automatic or contains LiquidConductivityMethod, for the input(s) "<>ObjectToString[liquidConductivityOnlyMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 5. Agitation can only be Sparge and stir-specific options can only be picked, if DetectionMethod does not contain LiquidConductivityMethod and LiquidConductivityModule is not picked *)
	stirLiquidConductivityMismatches=MapThread[
		Function[{detectionMethod,agitation,stirBlade,stirRate,stirOscillationPeriod,liquidConductivityModule,sampleObject},
			(* Agitation can only be Stir when DetectionMethod does not includes LiquidConductivityMethod and LiquidConductivityModule is not picked*)
			(* If Agitation is Stir and/or stir-options are picked, and DetectionMethod includes LiquidConductivityMethod and/or Liquid conductivity module is picked, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[agitation,Stir]||MatchQ[stirBlade,Except[Null|Automatic]]||MatchQ[stirRate,Except[Null|Automatic]]||MatchQ[stirOscillationPeriod,Except[Null|Automatic]])&&(MemberQ[Flatten[{detectionMethod}],LiquidConductivityMethod]||MatchQ[liquidConductivityModule,Except[Null|Automatic]]),
				{{agitation,stirBlade,stirRate,stirOscillationPeriod,detectionMethod,liquidConductivityModule},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DetectionMethod],Lookup[allOptionsRounded,Agitation],Lookup[allOptionsRounded,StirBlade],Lookup[allOptionsRounded,StirRate],Lookup[allOptionsRounded,StirOscillationPeriod],Lookup[allOptionsRounded,LiquidConductivityModule],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{stirLiquidConductivityMismatchOptions,stirLiquidConductivityMismatchInputs}=If[MatchQ[stirLiquidConductivityMismatches,{}],
		{{},{}},
		Transpose[stirLiquidConductivityMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	stirLiquidConductivityInvalidOptions=If[Length[stirLiquidConductivityMismatchOptions]>0&&!gatherTests,
		Message[Error::DFAstirLiquidConductivityMismatch,Sequence@@Sequence@@stirLiquidConductivityMismatchOptions,stirLiquidConductivityMismatchInputs];
		{Agitation,StirBlade,StirRate,StirOscillationPeriod,DetectionMethod,LiquidConductivityModule},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	stirLiquidConductivityTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,stirLiquidConductivityMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The option Agitation must not be Stir and stir-related options cannot be selected, if DetectionMethod contains LiquidConductivityMethod or LiquidConductivityModule is selected, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[stirLiquidConductivityMismatchInputs]>0,
				Test["The option Agitation must not be Stir and stir-related options cannot be selected, if DetectionMethod contains LiquidConductivityMethod or LiquidConductivityModule is selected, for the input(s) "<>ObjectToString[stirLiquidConductivityMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 7. Stir and StirBlade, StirRate, StirOscillationPeriod are compatible *)
	stirOnlyMismatches=MapThread[
		Function[{agitation,stirBlade,stirRate,stirOscillationPeriod,sampleObject},
			(* StirBlade, StirRate, StirOscillationPeriod can only be set when Agitation is Automatic or Stir *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[stirBlade,Except[Null|Automatic]]||MatchQ[stirRate,Except[Null|Automatic]]||MatchQ[stirOscillationPeriod,Except[Null|Automatic]])&&!MatchQ[agitation,Stir|Automatic],
				{{agitation,stirBlade,stirRate,stirOscillationPeriod},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,Agitation],Lookup[allOptionsRounded,StirBlade],Lookup[allOptionsRounded,StirRate],Lookup[allOptionsRounded,StirOscillationPeriod],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{stirOnlyMismatchOptions,stirOnlyMismatchInputs}=If[MatchQ[stirOnlyMismatches,{}],
		{{},{}},
		Transpose[stirOnlyMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	stirOnlyInvalidOptions=If[Length[stirOnlyMismatchOptions]>0&&!gatherTests,
		Message[Error::DFAStirOnlyMismatch,Sequence@@Sequence@@stirOnlyMismatchOptions,stirOnlyMismatchInputs];
		{Agitation,StirBlade,StirRate,StirOscillationPeriod},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	stirOnlyTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,stirOnlyMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options StirBlade, StirRate, and StirOscillationPeriod are only set when Agitation is Automatic or Stir, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[stirOnlyMismatchInputs]>0,
				Test["The options StirBlade, StirRate, and StirOscillationPeriod are only set when Agitation is Automatic or Stir, for the input(s) "<>ObjectToString[stirOnlyMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 8. Sparge and SpargeFilter, SpargeGas, SpargeFlowRate are compatible *)
	spargeOnlyMismatches=MapThread[
		Function[{agitation,spargeFilter,spargeGas,spargeFlowRate,sampleObject},
			(* SpargeFilter, SpargeGas, SpargeFlowRate can only be set when Agitation is Automatic or Sparge *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[spargeFilter,Except[Null|Automatic]]||MatchQ[spargeGas,Except[Null|Automatic]]||MatchQ[spargeFlowRate,Except[Null|Automatic]])&&!MatchQ[agitation,Sparge|Automatic],
				{{agitation,spargeFilter,spargeGas,spargeFlowRate},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,Agitation],Lookup[allOptionsRounded,SpargeFilter],Lookup[allOptionsRounded,SpargeGas],Lookup[allOptionsRounded,SpargeFlowRate],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{spargeOnlyMismatchOptions,spargeOnlyMismatchInputs}=If[MatchQ[spargeOnlyMismatches,{}],
		{{},{}},
		Transpose[spargeOnlyMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	spargeOnlyInvalidOptions=If[Length[spargeOnlyMismatchOptions]>0&&!gatherTests,
		Message[Error::DFASpargeOnlyMismatch,Sequence@@Sequence@@spargeOnlyMismatchOptions,spargeOnlyMismatchInputs];
		{Agitation,SpargeFilter,SpargeGas,SpargeFlowRate},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	spargeOnlyTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,spargeOnlyMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options SpargeFilter, SpargeGas, and SpargeFlowRate are only set when Agitation is Automatic or Sparge, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[spargerOnlyMismatchInputs]>0,
				Test["The options SpargeFilter, SpargeGas, and SpargeFlowRate are only set when Agitation is Automatic or Sparge, for the input(s) "<>ObjectToString[spargeOnlyMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 9. No conflicting options from the agitation methods are picked at the same time *)
	agitationMethodsMismatches=MapThread[
		Function[{stirBlade,stirRate,stirOscillationPeriod,spargeFilter,spargeGas,spargeFlowRate,sampleObject},
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)
			Module[{spargeOptionsSet,stirOptionsSet},

				(*Get the options that are set*)
				stirOptionsSet=Select[{StirBlade->stirBlade,StirRate->stirRate,StirOscillationPeriod->stirOscillationPeriod},(MatchQ[#[[2]],Except[Null|Automatic]]&)];
				spargeOptionsSet=Select[{SpargeFilter->spargeFilter,SpargeGas->spargeGas,SpargeFlowRate->spargeFlowRate},(MatchQ[#[[2]],Except[Null|Automatic]]&)];

				(* Do we have a conflict? *)
				If[Length[stirOptionsSet]>0&&Length[spargeOptionsSet]>0,
					{{stirOptionsSet,spargeOptionsSet},sampleObject},
					Nothing
				]
			]
		],
		{
			Lookup[allOptionsRounded,StirBlade],Lookup[allOptionsRounded,StirRate],Lookup[allOptionsRounded,StirOscillationPeriod],Lookup[allOptionsRounded,SpargeFilter],Lookup[allOptionsRounded,SpargeGas],Lookup[allOptionsRounded,SpargeFlowRate],simulatedSamples
		}
	];

	(* Transpose our result if there were mismatches. *)
	{agitationMethodsMismatchOptions,agitationMethodsMismatchInputs}=If[MatchQ[agitationMethodsMismatches,{}],
		{{},{}},
		Transpose[agitationMethodsMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	agitationMethodsInvalidOptions=If[Length[agitationMethodsMismatchOptions]>0&&!gatherTests,
		Message[Error::DFAAgitationMethodsMismatch,agitationMethodsMismatchOptions,ObjectToString[agitationMethodsMismatchInputs,Cache->cache]];
		First/@Flatten[agitationMethodsMismatchOptions],

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	agitationMethodsTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,agitationMethodsMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following object(s) do not have conflicting information in their options that would cause DetectionMethod to be ambiguously resolved "<>ObjectToString[passingInputs,Cache->cache]<>":",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[agitationMethodsMismatchInputs]>0,
				Test["The following object(s) do not have conflicting information in their options that would cause DetectionMethod to be ambiguously resolved "<>ObjectToString[agitationMethodsMismatchInputs,Cache->cache]<>":",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 10. If ImagingMethod, FoamImagingModule/CameraHeight/StructureIlluminationIntensity/FieldOfView must not be null *)
	imagingMethodNullMismatches=MapThread[
		Function[{detectionMethod,foamImagingModule,cameraHeight,structureIlluminationIntensity,fieldOfView,sampleObject},
			(* FoamImagingModule/CameraHeight/StructureIlluminationIntensity/FieldOfView must not be Null when DetectionMethod includes ImagingMethod *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[foamImagingModule,Null]||MatchQ[cameraHeight,Null]||MatchQ[structureIlluminationIntensity,Null]||MatchQ[fieldOfView,Null])&&MemberQ[Flatten[{detectionMethod}],ImagingMethod],
				{{detectionMethod,foamImagingModule,cameraHeight,structureIlluminationIntensity,fieldOfView},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DetectionMethod],Lookup[allOptionsRounded,FoamImagingModule],Lookup[allOptionsRounded,CameraHeight],Lookup[allOptionsRounded,StructureIlluminationIntensity],Lookup[allOptionsRounded,FieldOfView],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{imagingMethodNullMismatchOptions,imagingMethodNullMismatchInputs}=If[MatchQ[imagingMethodNullMismatches,{}],
		{{},{}},
		Transpose[imagingMethodNullMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	imagingMethodNullInvalidOptions=If[Length[imagingMethodNullMismatchOptions]>0&&!gatherTests,
		Message[Error::DFAImagingMethodNullMismatch,Sequence@@Sequence@@imagingMethodNullMismatchOptions,imagingMethodNullMismatchInputs];
		{DetectionMethod,FoamImagingModule,CameraHeight,StructureIlluminationIntensity,FieldOfView},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	imagingMethodNullTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,imagingMethodNullMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options FoamImagingModule, CameraHeight, StructureIlluminationIntensity, and FieldOfView cannot be Null when DetectionMethod contains ImagingMethod, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[imagingMethodNullMismatchInputs]>0,
				Test["The options FoamImagingModule, CameraHeight, StructureIlluminationIntensity, and FieldOfView cannot be Null when DetectionMethod contains ImagingMethod, for the input(s) "<>ObjectToString[imagingMethodNullMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 12. If LiquidConductivityMethod, LiquidConductivityModule must not be null *)
	liquidConductivityMethodNullMismatches=MapThread[
		Function[{detectionMethod,liquidConductivityModule,sampleObject},
			(* LiquidCOnductivityModule must not be Null when DetectionMethod includes LiquidConductivityMethod *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[liquidConductivityModule,Null])&&MemberQ[Flatten[{detectionMethod}],LiquidConductivityMethod],
				{{detectionMethod,liquidConductivityModule},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,DetectionMethod],Lookup[allOptionsRounded,LiquidConductivityModule],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{liquidConductivityMethodNullMismatchOptions,liquidConductivityMethodNullMismatchInputs}=If[MatchQ[liquidConductivityMethodNullMismatches,{}],
		{{},{}},
		Transpose[liquidConductivityMethodNullMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	liquidConductivityMethodNullInvalidOptions=If[Length[liquidConductivityMethodNullMismatchOptions]>0&&!gatherTests,
		Message[Error::DFALiquidConductivityMethodNullMismatch,Sequence@@Sequence@@liquidConductivityMethodNullMismatchOptions,liquidConductivityMethodNullMismatchInputs];
		{DetectionMethod,LiquidConductivityModule},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	liquidConductivityMethodNullTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,liquidConductivityMethodNullMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The option LiquidConductivityModule cannot be Null when DetectionMethod contains LiquidConductivityMethod, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[liquidConductivityMethodNullMismatchInputs]>0,
				Test["The option LiquidConductivityModule cannot be Null when DetectionMethod contains LiquidConductivityMethod, for the input(s) "<>ObjectToString[liquidConductivityMethodNullMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 13. If Stir, StirRate/StirBlade/StirOscillationPeriod must not be null *)
	stirNullMismatches=MapThread[
		Function[{agitation,stirRate,stirBlade,stirOscillationPeriod,sampleObject},
			(* StirRate/StirBlade/StirOscillationPeriod must not be Null when Agitation is Stir *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[stirRate,Null]||MatchQ[stirBlade,Null]||MatchQ[stirOscillationPeriod,Null])&&MatchQ[agitation,Stir],
				{{agitation,stirRate,stirBlade,stirOscillationPeriod},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,Agitation],Lookup[allOptionsRounded,StirRate],Lookup[allOptionsRounded,StirBlade],Lookup[allOptionsRounded,StirOscillationPeriod],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{stirNullMismatchOptions,stirNullMismatchInputs}=If[MatchQ[stirNullMismatches,{}],
		{{},{}},
		Transpose[stirNullMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	stirNullInvalidOptions=If[Length[stirNullMismatchOptions]>0&&!gatherTests,
		Message[Error::DFAStirNullMismatch,Sequence@@Sequence@@stirNullMismatchOptions,stirNullMismatchInputs];
		{Agitation,StirRate,StirBlade,StirOscillationPeriod},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	stirNullTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,stirNullMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options StirRate, StirBlade, StirOscillationPeriod cannot be Null when Agitation is Stir, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[stirNullMismatchInputs]>0,
				Test["The options StirRate, StirBlade, StirOscillationPeriod cannot be Null when Agitation is Stir, for the input(s) "<>ObjectToString[stirNullMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 14. If Sparge, SpargeFilter/SpargeGas/SpargeFlowRate must not be null *)
	spargeNullMismatches=MapThread[
		Function[{agitation,spargeFilter,spargeGas,spargeFlowRate,sampleObject},
			(* SpargeFilter/SpargeGas/SpargeFlowRate must not be Null when Agitation is Stir *)
			(* If they don't match, return the options that mismatch and the input for which they mismatch. *)

			If[(MatchQ[spargeFilter,Null]||MatchQ[spargeGas,Null]||MatchQ[spargeFlowRate,Null])&&MatchQ[agitation,Sparge],
				{{agitation,spargeFilter,spargeGas,spargeFlowRate},sampleObject},
				Nothing
			]
		],
		{Lookup[allOptionsRounded,Agitation],Lookup[allOptionsRounded,SpargeFilter],Lookup[allOptionsRounded,SpargeGas],Lookup[allOptionsRounded,SpargeFlowRate],simulatedSamples}
	];

	(* Transpose our result if there were mismatches. *)
	{spargeNullMismatchOptions,spargeNullMismatchInputs}=If[MatchQ[spargeNullMismatches,{}],
		{{},{}},
		Transpose[spargeNullMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	spargeNullInvalidOptions=If[Length[spargeNullMismatchOptions]>0&&!gatherTests,
		Message[Error::DFASpargeNullMismatch,Sequence@@Sequence@@spargeNullMismatchOptions,spargeNullMismatchInputs];
		{Agitation,SpargeFilter,SpargeGas,SpargeFlowRate},

		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	spargeNullTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,spargeNullMismatchInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options SpargeFilter, SpargeGas, SpargeFlowRate cannot be Null when Agitation is Sparge, for the input(s) "<>ObjectToString[passingInputs,Cache->cache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[spargeNullMismatchInputs]>0,
				Test["The options SpargeFilter, SpargeGas, SpargeFlowRate cannot be Null when Agitation is Sparge, for the input(s) "<>ObjectToString[spargeNullMismatchInputs,Cache->cache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

		(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(* Pull out all the options *)
	(* These options are defaulted and are outside of the main map thread *)
	name=Lookup[allOptionsRounded,Name,Null];
	instrument=Lookup[allOptionsRounded,Instrument];
	temperature=Lookup[allOptionsRounded,Temperature]/.Ambient->$AmbientTemperature;
	agitationTime=Lookup[allOptionsRounded,AgitationTime];
	agitationSamplingFrequency=Lookup[allOptionsRounded,AgitationSamplingFrequency];
	decayTime=Lookup[allOptionsRounded,DecayTime];
	decaySamplingFrequency=Lookup[allOptionsRounded,DecaySamplingFrequency];
	numberOfReplicates=Lookup[allOptionsRounded,NumberOfReplicates];
	foamColumnLoading=Lookup[allOptionsRounded,FoamColumnLoading];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentDynamicFoamAnalysis,allOptionsRounded];

	(* MapThread over each of our samples. *)
	{
		resolvedSampleVolumes,
		resolvedTemperatureMonitoring,
		resolvedDetectionMethod,
		resolvedFoamColumn,
		resolvedLiquidConductivityModule,
		resolvedFoamImagingModule,
		resolvedWavelength,
		resolvedHeightIlluminationIntensity,
		resolvedCameraHeight,
		resolvedStructureIlluminationIntensity,
		resolvedFieldOfView,
		resolvedAgitation,
		resolvedSpargeFilter,
		resolvedSpargeGas,
		resolvedSpargeFlowRate,
		resolvedStirBlade,
		resolvedStirRate,
		resolvedStirOscillationPeriod,
		resolvedNumberOfWashes,

		(* Resolved Error Bools *)
		sampleVolumeLowErrors,
		sampleVolumeFoamColumnErrors,
		temperatureMonitoringErrors,
		temperatureColumnErrors,
		imagingColumnErrors,
		agitationTimeWarnings,
		agitationSamplingFrequencyLowWarnings,
		decayTimeWarnings,
		decaySamplingFrequencyLowWarnings,
		numberOfWashesLowWarnings,
		volumes
	}=Transpose[MapThread[Function[{myMapThreadFriendlyOptions,mySample,myColumnPackets},
		Module[{
			sampleVolume,
			temperatureMonitoring,
			detectionMethod,
			foamColumn,
			foamColumnModel,
			liquidConductivityModule,
			foamImagingModule,
			wavelength,
			heightIlluminationIntensity,
			cameraHeight,
			structureIlluminationIntensity,
			fieldOfView,
			agitation,
			spargeFilter,
			spargeGas,
			spargeFlowRate,
			stirBlade,
			stirRate,
			stirOscillationPeriod,
			numberOfWashes,

			(*other variables*)
			originalSampleVolume,
			minColumnSampleVolume,
			initialDetectionMethod,
			initialFoamColumn,
			temperatureValue,
			agitationTimeValue,
			agitationSamplingFrequencyValue,
			decayTimeValue,
			decaySamplingFrequencyValue,

			(* supplied option values *)
			supSampleVolume,
			supTemperatureMonitoring,
			supDetectionMethod,
			supFoamColumn,
			supLiquidConductivityModule,
			supFoamImagingModule,
			supWavelength,
			supHeightIlluminationIntensity,
			supCameraHeight,
			supStructureIlluminationIntensity,
			supFieldOfView,
			supAgitation,
			supSpargeFilter,
			supSpargeGas,
			supSpargeFlowRate,
			supStirBlade,
			supStirRate,
			supStirOscillationPeriod,
			supNumberOfWashes,

			(* Error checking booleans *)
			sampleVolumeLowError,
			sampleVolumeFoamColumnError,
			temperatureMonitoringError,
			temperatureColumnError,
			imagingColumnError,
			agitationTimeWarning,
			agitationSamplingFrequencyLowWarning,
			decayTimeWarning,
			decaySamplingFrequencyLowWarning,
			numberOfWashesLowWarning
		},

			(* Setup our error tracking variables *)
			{
				sampleVolumeLowError,
				sampleVolumeFoamColumnError,
				temperatureMonitoringError,
				temperatureColumnError,
				imagingColumnError,
				agitationTimeWarning,
				agitationSamplingFrequencyLowWarning,
				decayTimeWarning,
				decaySamplingFrequencyLowWarning,
				numberOfWashesLowWarning
			}=ConstantArray[False,10];

			(* Store our options in their variables*)
			{
				supSampleVolume,
				supTemperatureMonitoring,
				supDetectionMethod,
				supFoamColumn,
				supLiquidConductivityModule,
				supFoamImagingModule,
				supWavelength,
				supHeightIlluminationIntensity,
				supCameraHeight,
				supStructureIlluminationIntensity,
				supFieldOfView,
				supAgitation,
				supSpargeFilter,
				supSpargeGas,
				supSpargeFlowRate,
				supStirBlade,
				supStirRate,
				supStirOscillationPeriod,
				supNumberOfWashes
			}=Lookup[
				myMapThreadFriendlyOptions,
				{
					SampleVolume,
					TemperatureMonitoring,
					DetectionMethod,
					FoamColumn,
					LiquidConductivityModule,
					FoamImagingModule,
					Wavelength,
					HeightIlluminationIntensity,
					CameraHeight,
					StructureIlluminationIntensity,
					FieldOfView,
					Agitation,
					SpargeFilter,
					SpargeGas,
					SpargeFlowRate,
					StirBlade,
					StirRate,
					StirOscillationPeriod,
					NumberOfWashes
				}
			];

			(* Store values for our defaulted variables that we will not resolve here, but use for error checking*)
			{
				temperatureValue,
				agitationTimeValue,
				agitationSamplingFrequencyValue,
				decayTimeValue,
				decaySamplingFrequencyValue
			}=Lookup[
				myMapThreadFriendlyOptions,
				{
					Temperature,
					AgitationTime,
					AgitationSamplingFrequency,
					DecayTime,
					DecaySamplingFrequency
				}
			]/.Ambient->$AmbientTemperature;

			(* Get the original volume of the sample. If the volume is missing, default to 0. We will have thrown an error above *)
			originalSampleVolume=Max[Replace[Lookup[mySample,Volume],Null->0*Milli*Liter]];

			(* Independent options resolution *)

			(*Is the DetectionMethod specified by the user*)
			detectionMethod=If[MatchQ[supDetectionMethod,Except[Automatic]],
				(*if yes, keep supplied method*)
				supDetectionMethod,

				(*if no, resolve based on what other method-specific options have been selected
				note that detection method can be a list of more than one method*)
				(*set up an initial list to build on - this includes HeightMethod because HeightMethod is required*)
				initialDetectionMethod={HeightMethod};

				(*was a liquid conductivity module selected? if so add it in to our building list*)
				If[MatchQ[supLiquidConductivityModule,Except[Automatic|Null]],
					initialDetectionMethod=Append[initialDetectionMethod,LiquidConductivityMethod]];

				(*was a imaging method option selected? if so add it in to our building list*)
				If[MatchQ[supFoamImagingModule,Except[Automatic|Null]]||MatchQ[supCameraHeight,Except[Automatic|Null]]||MatchQ[supStructureIlluminationIntensity,Except[Automatic|Null]]||MatchQ[supFieldOfView,Except[Automatic|Null]],
					initialDetectionMethod=Append[initialDetectionMethod,ImagingMethod]];

				(*If nothing has been selected yet select as long as the options were not null*)
				If[MatchQ[initialDetectionMethod,{}],

					Which[
						!(MatchQ[supFoamImagingModule,Null]||MatchQ[supCameraHeight,Null]||MatchQ[supStructureIlluminationIntensity,Null]||MatchQ[supFieldOfView,Null]),
							initialDetectionMethod=Append[initialDetectionMethod,ImagingMethod],
						!MatchQ[supLiquidConductivityModule,Null],
							initialDetectionMethod=Append[initialDetectionMethod,LiquidConductivityMethod]
					]
				];

				(*save our built list*)
				initialDetectionMethod
			];

			(*we will now be resolving the options related to the detectors. First save all as the supplied. We will be saving over these again, but this way every variable is saved as something*)
			{
				wavelength,
				heightIlluminationIntensity,
				temperatureMonitoring,
				liquidConductivityModule,
				foamImagingModule,
				cameraHeight,
				structureIlluminationIntensity,
				fieldOfView
			}={
				supWavelength,
				supHeightIlluminationIntensity,
				supTemperatureMonitoring,
				supLiquidConductivityModule,
				supFoamImagingModule,
				supCameraHeight,
				supStructureIlluminationIntensity,
				supFieldOfView
			};

			(* will resolve options related to each method after we resolve agitation, since we need agitation to resolve TemperatureMonitoring*)

			(*Is foam column specified?*)
			foamColumn=If[MatchQ[supFoamColumn,Except[Automatic]],

				(*Is ImagingMethod among the detection methods? if so must be a column with a prism*)
				imagingColumnError=If[MemberQ[detectionMethod,ImagingMethod],
					If[MatchQ[First@Lookup[myColumnPackets,Prism],Except[True]],
						True,
						False
					],
					False
				];

				(*Is Temperature not set to Ambient? if so must be a column with temperature control*)
				temperatureColumnError=If[MatchQ[temperatureValue,Except[$AmbientTemperature]],
					If[MatchQ[First@Lookup[myColumnPackets,Jacketed],Except[True]],
						True,
						False
					],
					False
				];

				(*save the specified foam column*)
				supFoamColumn,

				(*If not specified by user, save based on other options*)

				(*Is foam imaging specified?*)
				initialFoamColumn=If[MemberQ[detectionMethod,ImagingMethod],

					(*If yes: select a foam imaging column*)
					(*Is temperature not ambient? if so must be a column with temp control*)
					If[MatchQ[temperatureValue,Except[$AmbientTemperature]],
						(*need temp control*)
						Model[Container,FoamColumn,"CY4575 Temperature Prism Column"],
						(*do not need temp control*)
						Model[Container,FoamColumn,"CY4572 Prism Column"]
					],

					(*If no: select a non foam imaging column*)
					(*Is temperature not ambient? if so must be a column with temp control. For temp control we are selecting the temperature prism column regardless, since it has the attachments on it. *)
					If[MatchQ[temperatureValue,Except[$AmbientTemperature]],
						(*need temp control*)
						Model[Container,FoamColumn,"CY4575 Temperature Prism Column"],
						(*do not need temp control*)
						Model[Container,FoamColumn,"CY4501 Basic Column"]
					]
				];

				(*save the foam column*)
				initialFoamColumn
			];

			(* find the minimum sample volume allowed by the foam column. We will use this in error checking*)
			minColumnSampleVolume=Which[
				(* look up value if the foam column was a model *)
				MatchQ[foamColumn,ObjectP[Model[Container,FoamColumn]]],
				Lookup[cacheLookup[cache,foamColumn],MinSampleVolume],

				(* look up value if the foam column was an object*)
				MatchQ[foamColumn,ObjectP[Object[Container,FoamColumn]]],
				foamColumnModel=Lookup[cacheLookup[cache,foamColumn],Model];
				Lookup[cacheLookup[cache,foamColumnModel],MinSampleVolume]
			];

			(* Is the SampleVolume specified by the user *)
			sampleVolume=If[MatchQ[supSampleVolume,Except[Automatic]],

				(* if yes, keep supplied sample volume but check if sampleVolume*NumberOfReplicates is greater than what we actually have in the original sample volume and throw an error if it is*)
				(*sampleVolumeLowError=If[GreaterEqual[originalSampleVolume,(supSampleVolume*numberOfReplicates/.Null->1)],
					False,
					True
				];*)

				(*check if it is smaller than the min sample volume allowed in the foam column and throw an error if it is*)
				sampleVolumeFoamColumnError=If[supSampleVolume<minColumnSampleVolume,
					True,
					False
				];

				(* save the supplied sample volume *)
				supSampleVolume,

				(* if not specified, resolve to the minimum sample volume allowed in the foam column (again checking first to see if we actually have that much in the original sample volume *)
				(*sampleVolumeLowError=If[GreaterEqual[originalSampleVolume,(minColumnSampleVolume*numberOfReplicates/.Null->1)],
					False,
					True
				];*)

				(* save the minimum sample volume*)
				minColumnSampleVolume
			];

			(*we will now be resolving the options related to agitation. First save all as the supplied. We will be saving over these again, but this way every variable is saved as something*)
			{
				stirBlade,
				stirRate,
				stirOscillationPeriod,
				spargeFilter,
				spargeGas,
				spargeFlowRate
			}={
				supStirBlade,
				supStirRate,
				supStirOscillationPeriod,
				supSpargeFilter,
				supSpargeGas,
				supSpargeFlowRate
			};

			(*Is agitation specified? Resolve based on whether agitation-related methods are specified. If none are, save as Stir*)
			agitation=If[MatchQ[supAgitation,Except[Automatic]],
				supAgitation,

				Which[
					(*if either stir or sparge specific options are set, grab that agitation. If these conflict we will have thrown an error above. Also, if TemperatureMonitoring is true, save as Sparge*)
					MatchQ[supStirBlade,Except[Automatic|Null]]||MatchQ[supStirRate,Except[Automatic|Null]]||MatchQ[supStirOscillationPeriod,Except[Automatic|Null]],
						Stir,
					MatchQ[supSpargeFilter,Except[Automatic|Null]]||MatchQ[supSpargeGas,Except[Automatic|Null]]||MatchQ[supSpargeFlowRate,Except[Automatic|Null]]||MatchQ[supTemperatureMonitoring,True],
						Sparge,

					(*If none are set, grab agitation option as long as none of the specific options are Null. Only grab stir if liquid conductivity module is not set and detection method does not contain liquid conductivity method, *)
					!(MatchQ[supStirBlade,Null]||MatchQ[supStirRate,Null]||MatchQ[supStirOscillationPeriod,Null]||MatchQ[supLiquidConductivityModule,Except[Automatic|Null]]||MemberQ[detectionMethod,LiquidConductivityMethod]),
						Stir,
					!(MatchQ[supSpargeFilter,Null]||MatchQ[supSpargeGas,Null]||MatchQ[supSpargeFlowRate,Null]),
						Sparge
				]
			];

			(* now that we have agitation, we will hop over to resolve DetectionMethod-related options *)

			(*resolve options related to HeightMethod - will enter this thread if any of the members of detectionMethod are HeightMethod*)
			If[MemberQ[detectionMethod,HeightMethod],

				(*Is wavelength specified? If not save as visible*)
				wavelength=If[MatchQ[supWavelength,Except[Automatic]],
					supWavelength,
					469*Nanometer
				];

				(*Is HeightIlluminationIntensity specified? If not save as 40%*)
				heightIlluminationIntensity=If[MatchQ[supHeightIlluminationIntensity,Except[Automatic]],
					supHeightIlluminationIntensity,
					100 Percent
				];

				(*Is TemperatureMonitoring specified? If not save depending on whether LiquidConductivityMethod is also selected and whether agitation is stir/sparge*)
				temperatureMonitoring=If[MatchQ[supTemperatureMonitoring,Except[Automatic]],
					(*If specified, check for error. Agitation cannot be Stir, so throw an error if temperature monitoring is true and agitation is stir*)
					temperatureMonitoringError=If[MatchQ[supTemperatureMonitoring,True]&&MatchQ[agitation,Stir],
						True,
						False
					];
					(*save specified value anyway*)
					supTemperatureMonitoring,

					(*check for liquid conductivity method. If liquid conductivity method is used or if agitation is stir, cannot do temperature monitoring*)
					If[MemberQ[detectionMethod,LiquidConductivityMethod]||MatchQ[agitation,Stir],
						False,
						True
					]
				];
			];

			(*resolve options related to LiquidConductivityMethod - will enter this thread if any of the members of detectionMethod are LiquidConductivityMethod*)
			If[MemberQ[detectionMethod,LiquidConductivityMethod],

				(*Is LiquidConductivityModule specified? if not save*)
				liquidConductivityModule=If[MatchQ[supLiquidConductivityModule,Except[Automatic]],
					supLiquidConductivityModule,
					Model[Part,LiquidConductivityModule,"DFA100 LCM"]
				];

				(*Is TemperatureMonitoring specified? If not save as no since it is not compatible with LiquidConductivityMethod*)
				temperatureMonitoring=If[MatchQ[supTemperatureMonitoring,Except[Automatic]],

					(*If specified, check for error. Cannot be set to True*)
					temperatureMonitoringError=If[MatchQ[supTemperatureMonitoring,True],
						True,
						False
					];
					(*save specified value anyway*)
					supTemperatureMonitoring,

					(*If no, save as false: cannot do temperature monitoring*)
					False
				];
			];

			(*resolve options related to ImagingMethod - will enter this thread if any of the members of detectionMethod are ImagingMethod*)
			If[MemberQ[detectionMethod,ImagingMethod],

				(*Is FoamImagingModule specified? if not save*)
				foamImagingModule=If[MatchQ[supFoamImagingModule,Except[Automatic]],
					supFoamImagingModule,
					Model[Part,FoamImagingModule,"DFA100 FSM"]
				];

				(*Is CameraHeight specified? if not save*)
				cameraHeight=If[MatchQ[supCameraHeight,Except[Automatic]],
					supCameraHeight,
					150 Millimeter
				];

				(*Is StructureIlluminationIntensity specified? if not save*)
				structureIlluminationIntensity=If[MatchQ[supStructureIlluminationIntensity,Except[Automatic]],
					supStructureIlluminationIntensity,
					20 Percent
				];

				(*Is FieldOfView specified? if not save*)
				fieldOfView=If[MatchQ[supFieldOfView,Except[Automatic]],
					supFieldOfView,
					140 Millimeter^2
				];

				(*Is TemperatureMonitoring specified? If not save as true*)
				temperatureMonitoring=If[MatchQ[supTemperatureMonitoring,Except[Automatic]],
					(*If specified, check for error. Agitation cannot be Stir, so throw an error if temperature monitoring is true and agitation is stir*)
					temperatureMonitoringError=If[MatchQ[supTemperatureMonitoring,True]&&MatchQ[agitation,Stir],
						True,
						False
					];
					(*save specified value anyway*)
					supTemperatureMonitoring,

					(*check for liquid conductivity method. If liquid conductivity method is used or if agitation is stir, cannot do temperature monitoring*)
					If[MemberQ[detectionMethod,LiquidConductivityMethod]||MatchQ[agitation,Stir],
						False,
						True
					]
				];
			];

			(*at this point the detector options have been resolved - any that were not were because that method was not chosen.*)
			(*Null out remaining automatic options that were not resolved - these will not be needed*)
			{
				wavelength,
				heightIlluminationIntensity,
				temperatureMonitoring,
				liquidConductivityModule,
				foamImagingModule,
				cameraHeight,
				structureIlluminationIntensity,
				fieldOfView
			}={
				wavelength,
				heightIlluminationIntensity,
				temperatureMonitoring,
				liquidConductivityModule,
				foamImagingModule,
				cameraHeight,
				structureIlluminationIntensity,
				fieldOfView
			}/.Automatic->Null;

			(*Is agitation stir? Resolve options related to Agitation=Stir*)
			If[MatchQ[agitation,Stir],

				(*Is the stir blade specified*)
				stirBlade=If[MatchQ[supStirBlade,Except[Automatic]],
					supStirBlade,
					Model[Part,StirBlade,"SR4501 Standard Agitator Blade"]
				];

				(*Is the stir rate specified*)
				stirRate=If[MatchQ[supStirRate,Except[Automatic]],
					supStirRate,
					5000 RPM
				];

				(*Is the stir oscillation period specified*)
				stirOscillationPeriod=If[MatchQ[supStirOscillationPeriod,Except[Automatic]],
					supStirOscillationPeriod,
					0 Second
				];
			];

			(*Is agitation sparge? Resolve options related to Agitation=Stir*)
			If[MatchQ[agitation,Sparge],

				(*Is the sparge filter specified*)
				spargeFilter=If[MatchQ[supSpargeFilter,Except[Automatic]],
					supSpargeFilter,
					Model[Part,SpargeFilter,"FL4533"]
				];

				(*Is the sparge gas specified*)
				spargeGas=If[MatchQ[supSpargeGas,Except[Automatic]],
					supSpargeGas,
					Air
				];

				(*Is the sparge flow rate specified*)
				spargeFlowRate=If[MatchQ[supSpargeFlowRate,Except[Automatic]],
					supSpargeFlowRate,
					1 Liter/Minute
				];
			];

			(*at this point all of the agitation options have been resolved - any that were not were because that method was not chosen.*)
			(*Null out remaining options that were not set*)
			{
				stirBlade,
				stirRate,
				stirOscillationPeriod,
				spargeFilter,
				spargeGas,
				spargeFlowRate
			}={
				stirBlade,
				stirRate,
				stirOscillationPeriod,
				spargeFilter,
				spargeGas,
				spargeFlowRate
			}/.Automatic->Null;

			(*checking for warnings/error for defaults for agitation/decay*)
			(*is the agitation time <2 second or > 1 minute? throw warning if true*)
			agitationTimeWarning=If[agitationTimeValue<2*Second||agitationTimeValue>1*Minute,
				True,
				False
			];

			(*is the agitation sampling frequency less than would occur more than once in the agitaitontime? throw warning if true*)
			agitationSamplingFrequencyLowWarning=If[agitationSamplingFrequencyValue*agitationTimeValue<=1,
				True,
				False
			];

			(*is the decay time <5 second? throw warning if true*)
			decayTimeWarning=If[decayTimeValue<5*Second,
				True,
				False
			];

			(*is the decay sampling frequency less than would occur more than once in the decaytime? throw warning if true*)
			decaySamplingFrequencyLowWarning=If[decaySamplingFrequencyValue*decayTimeValue<=1,
				True,
				False
			];

			(*Is number of washes specified? If not take the value from the foamcolum*)
			numberOfWashes=If[MatchQ[supNumberOfWashes,Except[Automatic]],

				(*check if the number of washes is less than 3 - if so, throw warning*)
				numberOfWashesLowWarning=If[supNumberOfWashes<3,
					True,
					False
				];

				(*save specified value*)
				supNumberOfWashes,
				(*Sequence@@First@Lookup[myColumnPackets,PreferredNumberOfWashes]*)
				(*If not specified, take the value from the selected foam column*)
				Which[
					(* look up value if the foam column was a model *)
					MatchQ[foamColumn,ObjectP[Model[Container,FoamColumn]]],
					Sequence@@Lookup[cacheLookup[cache,foamColumn],PreferredNumberOfWashes],

					(* look up value if the foam column was an object*)
					MatchQ[foamColumn,ObjectP[Object[Container,FoamColumn]]],
					foamColumnModel=Lookup[cacheLookup[cache,foamColumn],Model];
					Sequence@@Lookup[cacheLookup[cache,foamColumnModel],PreferredNumberOfWashes]
				]
			];

			(* Gather MapThread results *)
			{
				sampleVolume,
				temperatureMonitoring,
				detectionMethod,
				foamColumn,
				liquidConductivityModule,
				foamImagingModule,
				wavelength,
				heightIlluminationIntensity,
				cameraHeight,
				structureIlluminationIntensity,
				fieldOfView,
				agitation,
				spargeFilter,
				spargeGas,
				spargeFlowRate,
				stirBlade,
				stirRate,
				stirOscillationPeriod,
				numberOfWashes,

				sampleVolumeLowError,
				sampleVolumeFoamColumnError,
				temperatureMonitoringError,
				temperatureColumnError,
				imagingColumnError,
				agitationTimeWarning,
				agitationSamplingFrequencyLowWarning,
				decayTimeWarning,
				decaySamplingFrequencyLowWarning,
				numberOfWashesLowWarning,
				originalSampleVolume
			}
		]
	],
		{mapThreadFriendlyOptions,samplePackets,foamColumnPackets}
	]];

	(* Pull out Miscellaneous options *)
	{emailOption,uploadOption,nameOption,confirmOption,canaryBranchOption,parentProtocolOption,fastTrackOption,templateOption,samplesInStorageOption,operator}=
		Lookup[allOptionsRounded,
			{Email,Upload,Name,Confirm,CanaryBranch,ParentProtocol,FastTrack,Template,SamplesInStorageCondition,Operator}];

	(* check if the provided sampleStorageCondtion is valid*)
	{validSampleStorageConditionQ,validSampleStorageTests}=If[gatherTests,
		ValidContainerStorageConditionQ[simulatedSamples,samplesInStorageOption,Cache->cache,Output->{Result,Tests}],
		{ValidContainerStorageConditionQ[simulatedSamples,samplesInStorageOption,Cache->cache,Output->Result],{}}
	];

	(* if the test above passes, there's no invalid option, otherwise, SamplesInStorageCondition will be an invalid option *)
	invalidStorageConditionOptions=If[Not[And@@validSampleStorageConditionQ],
		{SamplesInStorageCondition},
		{}
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)
	(* --- Call CompatibleMaterialsQ to determine if the samples/wash solutions are chemically compatible with the foam column --- *)
	(* call CompatibleMaterialsQ and figure out if materials are compatible *)

	materials=DeleteDuplicates[simulatedSamples];

	{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[instrument,materials,Output->{Result,Tests},Cache->cache,Simulation->updatedSimulation],
		{CompatibleMaterialsQ[instrument,materials,Messages->messages,Cache->cache,Simulation->updatedSimulation],{}}
	];

	(* if the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidOption=If[Not[compatibleMaterialsBool]&&messages,
		{SamplesIn},
		{}
	];

	(*Generate the error messages and warnings from the errors and warnings*)
	(*(* (1) Check for sample volume low errors *)
	sampleVolumeLowInvalidOptions=If[MemberQ[sampleVolumeLowErrors,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Module[{sampleVolumeLowInvalidSamples,myResolvedSampleVolumes,myTotalSampleVolumes},
			(* Get the samples that correspond to this error. *)
			sampleVolumeLowInvalidSamples=PickList[simulatedSamples,sampleVolumeLowErrors];

			(* Get the volumes of these samples. *)
			myResolvedSampleVolumes=PickList[resolvedSampleVolumes,sampleVolumeLowErrors];

			(* get the total volumes of these samples *)
			myTotalSampleVolumes=#*(numberOfReplicates/.Null->1)&/@myResolvedSampleVolumes;

			(* Throw the corresopnding error. *)
			Message[Error DFASampleVolumeLowError,ObjectToString[myTotalSampleVolumes],ObjectToString[sampleVolumeLowInvalidSamples,Cache->cache]];

			{SampleVolume}
		],
		{}
	];

	(* Create the corresponding test for the sample volume error. *)
	sampleVolumeLowTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,sampleVolumeLowErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,sampleVolumeLowErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The specified SampleVolume with NumberOfReplicates of the following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" are larger than the sample's recorded volume.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The specified SampleVolume with NumberOfReplicates of the following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" are larger than the sample's recorded volume.",True,True],
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
	];*)

	(* (1b) Check for sample volume foam column errors *)
	sampleVolumeFoamColumnInvalidOptions=If[MemberQ[sampleVolumeFoamColumnErrors,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Module[{sampleVolumeFoamColumnInvalidSamples,myResolvedSampleVolumes,myTotalSampleVolumes},
			(* Get the samples that correspond to this error. *)
			sampleVolumeFoamColumnInvalidSamples=PickList[simulatedSamples,sampleVolumeFoamColumnErrors];

			(* Get the volumes of these samples. *)
			myResolvedSampleVolumes=PickList[resolvedSampleVolumes,sampleVolumeFoamColumnErrors];

			(* get the total volumes of these samples *)
			myTotalSampleVolumes=#*(numberOfReplicates/.Null->1)&/@myResolvedSampleVolumes;

			(* Throw the corresopnding error. *)
			Message[Error::DFASampleVolumeFoamColumnError,ObjectToString[myTotalSampleVolumes],ObjectToString[sampleVolumeFoamColumnInvalidSamples,Cache->cache]];

			{SampleVolume}
		],
		{}
	];

	(* Create the corresponding test for the sample volume error. *)
	sampleVolumeFoamColumnTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,sampleVolumeFoamColumnErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,sampleVolumeFoamColumnErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The SampleVolume of the following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" are smaller than the minimum volume allowed by the FoamColumn.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The SampleVolume of the following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" are smaller than the minimum volume allowed by the FoamColumn.",True,True],
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

	(* (2) Check for temperature monitoring errors *)
	temperatureMonitoringInvalidOptions=If[MemberQ[temperatureMonitoringErrors,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Module[{temperatureMonitoringInvalidSamples,detectionMethodInvalid,agitationInvalid,temperatureMonitoringInvalid},
			(* Get the samples that correspond to this error. *)
			temperatureMonitoringInvalidSamples=PickList[simulatedSamples,temperatureMonitoringErrors];

			(* Get the temperature monitoring of these samples. *)
			temperatureMonitoringInvalid=PickList[resolvedTemperatureMonitoring,temperatureMonitoringErrors];

			(* Get the detection methods of these samples. *)
			detectionMethodInvalid=PickList[resolvedDetectionMethod,temperatureMonitoringErrors];

			(* Get the agitation of these samples. *)
			agitationInvalid=PickList[resolvedAgitation,temperatureMonitoringErrors];

			(* Throw the corresopnding error. *)
			Message[Error::DFATemperatureMonitoringError,ObjectToString[temperatureMonitoringInvalid],ObjectToString[detectionMethodInvalid],ObjectToString[agitationInvalid],ObjectToString[temperatureMonitoringInvalidSamples,Cache->cache]];

			{TemperatureMonitoring,DetectionMethods,Agitation}
		],
		{}
	];

	(* Create the corresponding test for the temperature monitoring error. *)
	temperatureMonitoringTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,temperatureMonitoringErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,temperatureMonitoringErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" can be run with TemperatureMonitoring on, since they are not using the Liquid Conductivity Method and Agitation is not Stir.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" can be run with TemperatureMonitoring on, since they are not using the Liquid Conductivity Method and Agitation is not Stir.",True,True],
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

	(* (3) Check for imaging module column errors *)
	imagingColumnInvalidOptions=If[MemberQ[imagingColumnErrors,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Module[{imagingColumnInvalidSamples,imagingColumnInvalid,detectionMethodInvalid},
			(* Get the samples that correspond to this error. *)
			imagingColumnInvalidSamples=PickList[simulatedSamples,imagingColumnErrors];

			(* Get the foam column of these samples. *)
			imagingColumnInvalid=PickList[resolvedFoamColumn,imagingColumnErrors];

			(* Get the detectionMethod of these samples. *)
			detectionMethodInvalid=PickList[resolvedDetectionMethod,imagingColumnErrors];

			(* Throw the corresponding error. *)
			Message[Error::DFAImagingColumnError,ObjectToString[detectionMethodInvalid],ObjectToString[imagingColumnInvalid],ObjectToString[imagingColumnInvalidSamples,Cache->cache]];

			{DetectionMethod,FoamColumn}
		],
		{}
	];

	(* Create the corresponding test for the imaging module column error. *)
	imagingColumnTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,imagingColumnErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,imagingColumnErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" must be run in a FoamColumn with a Prism, to be compatible with the Imaging Method.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" must be run in a FoamColumn with a Prism, to be compatible with the Imaging Method.",True,True],
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

	(* (4) Check for temperature column errors *)
	temperatureColumnInvalidOptions=If[MemberQ[temperatureColumnErrors,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Module[{temperatureColumnInvalidSamples,temperatureInvalid,temperatureColumnInvalid},
			(* Get the samples that correspond to this error. *)
			temperatureColumnInvalidSamples=PickList[simulatedSamples,temperatureColumnErrors];

			(* Get the foam column of these samples. *)
			temperatureColumnInvalid=PickList[resolvedFoamColumn,temperatureColumnErrors];

			(* Get the temperature of these samples. *)
			temperatureInvalid=PickList[temperature,temperatureColumnErrors];

			(* Throw the corresopnding error. *)
			Message[Error::DFATemperatureColumnError,ObjectToString[temperatureInvalid],ObjectToString[temperatureColumnInvalid],ObjectToString[imagingColumnInvalidSamples,Cache->cache]];

			{FoamColumn}
		],
		{}
	];

	(* Create the corresponding test for the temperature column error. *)
	temperatureColumnTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,temperatureColumnErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,temperatureColumnErrors,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" must be run in a FoamColumn that is double jacketed, to be compatible with running an experiment at a non-ambient temperature.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" must be run in a FoamColumn that is double jacketed, to be compatible with running an experiment at a non-ambient temperature.",True,True],
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

	(* (5) Check for agitation time warnings *)
	If[MemberQ[agitationTimeWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Module[{agitationTimeWarningSamples,agitationTimeInvalid},
			(* Get the samples that correspond to this error. *)
			agitationTimeWarningSamples=PickList[simulatedSamples,agitationTimeWarnings];

			(* Get the foam column of these samples. *)
			agitationTimeInvalid=PickList[agitationTime,agitationTimeWarnings];

			(* Throw the corresopnding error. *)
			Message[Warning::DFAAgitationTime,ObjectToString[agitationTimeInvalid],ObjectToString[agitationTimeWarningSamples,Cache->cache]]
		]
	];

	(* Create the corresponding test for the agitation time warning. *)
	agitationTimeWarningTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,agitationTimeWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,agitationTimeWarnings,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" have AgitationTime that is <2 second or > 1 minute, which is outside the recommended range for an average experiment.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" have AgitationTime that is <2 second or > 1 minute, which is outside the recommended range for an average experiment.",True,True],
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

	(* (6) Check for agitation sampling frequency warnings *)
	If[MemberQ[agitationSamplingFrequencyLowWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Module[{agitationSamplingFrequencyLowSamples,agitationSamplingFrequencyInvalid,agitationTimeInvalid},
			(* Get the samples that correspond to this error. *)
			agitationSamplingFrequencyLowSamples=PickList[simulatedSamples,agitationTimeWarnings];

			(* Get the agitation sampling frequency of these samples. *)
			agitationSamplingFrequencyInvalid=PickList[agitationSamplingFrequency,agitationTimeWarnings];

			(* Get the agitation time of these samples. *)
			agitationTimeInvalid=PickList[agitationTime,agitationTimeWarnings];

			(* Throw the corresopnding error. *)
			Message[Warning::DFAAgitationSamplingFrequencyLow,ObjectToString[agitationSamplingFrequencyInvalid],ObjectToString[agitationTimeInvalid],ObjectToString[agitationSamplingFrequencyLowSamples,Cache->cache]]
		]
	];

	(* Create the corresponding test for the agitation sampling frequency warning. *)
	agitationSamplingFrequencyLowTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,agitationSamplingFrequencyLowWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,agitationSamplingFrequencyLowWarnings,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" have AgitationSamplingFrequency that is low and would cause data to be only sampled once during the specified AgitationTime.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" have AgitationSamplingFrequency that is low and would cause data to be only sampled once during the specified AgitationTime.",True,True],
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

	(* (7) Check for decay time warnings *)
	If[MemberQ[decayTimeWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Module[{decayTimeWarningSamples,decayTimeInvalid},
			(* Get the samples that correspond to this error. *)
			decayTimeWarningSamples=PickList[simulatedSamples,decayTimeWarnings];

			(* Get the foam column of these samples. *)
			decayTimeInvalid=PickList[decayTime,decayTimeWarnings];

			(* Throw the corresopnding error. *)
			Message[Warning::DFADecayTime,ObjectToString[decayTimeInvalid],ObjectToString[decayTimeWarningSamples,Cache->cache]]
		]
	];

	(* Create the corresponding test for the agitation time warning. *)
	decayTimeWarningTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,decayTimeWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,decayTimeWarnings,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" have DecayTime that is <5 seconds, which is shorter than the recommended range for an average experiment.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" have DecayTime that is <5 seconds, which is shorter than the recommended range for an average experiment.",True,True],
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

	(* (8) Check for decay sampling frequency warnings *)
	If[MemberQ[decaySamplingFrequencyLowWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Module[{decaySamplingFrequencyLowSamples,decaySamplingFrequencyInvalid,decayTimeInvalid},
			(* Get the samples that correspond to this error. *)
			decaySamplingFrequencyLowSamples=PickList[simulatedSamples,decaySamplingFrequencyLowWarnings];

			(* Get the decay sampling frequency of these samples. *)
			decaySamplingFrequencyInvalid=PickList[decaySamplingFrequency,decaySamplingFrequencyLowWarnings];

			(* Get the decay time of these samples. *)
			decayTimeInvalid=PickList[decayTime,decaySamplingFrequencyLowWarnings];

			(* Throw the corresopnding error. *)
			Message[Warning::DFADecaySamplingFrequencyLow,ObjectToString[decaySamplingFrequencyInvalid],ObjectToString[decayTimeInvalid],ObjectToString[decaySamplingFrequencyLowSamples,Cache->cache]]
		]
	];

	(* Create the corresponding test for the agitation sampling frequency warning. *)
	decaySamplingFrequencyLowTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,decaySamplingFrequencyLowWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,decaySamplingFrequencyLowWarnings,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" have DecaySamplingFrequency that is low and would cause data to be only sampled once during the specified AgitationTime.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" have DecaySamplingFrequency that is low and would cause data to be only sampled once during the specified AgitationTime.",True,True],
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

	(* (9) Check for number of washes low warnings *)
	If[MemberQ[numberOfWashesLowWarnings,True]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
		Module[{numberOfWashesLowSamples,numberOfWashesInvalid},
			(* Get the samples that correspond to this error. *)
			numberOfWashesLowSamples=PickList[simulatedSamples,numberOfWashesLowWarnings];

			(* Get the foam column of these samples. *)
			numberOfWashesInvalid=PickList[resolvedNumberOfWashes,numberOfWashesLowWarnings];

			(* Throw the corresponding error. *)
			Message[Warning::DFANumberOfWashesLow,ObjectToString[numberOfWashesInvalid],ObjectToString[numberOfWashesLowSamples,Cache->cache]]
		]
	];

	(* Create the corresponding test for the agitation sampling frequency warning. *)
	numberOfWashesLowTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,numberOfWashesLowWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[simulatedSamples,numberOfWashesLowWarnings,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" have NumberOfWashes that is low and could cause the FoamColumn to be inadequately washed in between samples.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" have NumberOfWashes that is low and could cause the FoamColumn to be inadequately washed in between samples.",True,True],
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

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		noVolumeInvalidInputs (*,
		notLiquidInvalidInputs*)}]];

	invalidOptions=DeleteDuplicates[Flatten[{
		(*from conflicting options check*)
		nameInvalidOption,
		heightMethodRequiredInvalidOptions,
		imagingMethodOnlyInvalidOptions,
		liquidConductivityOnlyInvalidOptions,
		stirLiquidConductivityInvalidOptions,
		stirOnlyInvalidOptions,
		spargeOnlyInvalidOptions,
		agitationMethodsInvalidOptions,
		imagingMethodNullInvalidOptions,
		liquidConductivityMethodNullInvalidOptions,
		stirNullInvalidOptions,
		spargeNullInvalidOptions,
		(*from mapthread*)
		(*sampleVolumeLowInvalidOptions,*)
		sampleVolumeFoamColumnInvalidOptions,
		temperatureMonitoringInvalidOptions,
		imagingColumnInvalidOptions,
		temperatureColumnInvalidOptions,
		(*misc*)
		compatibleMaterialsInvalidOption
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* combine all the tests together. Make sure we only have tests in the final lists (no Nulls etc) *)
	allTests=Cases[
		Flatten[{
			discardedTest,
			noVolumeTest,
			(*notLiquidTest,*)
			optionsPrecisionTests,
			validNameTest,
			heightMethodRequiredTest,
			imagingMethodOnlyTest,
			liquidConductivityOnlyTest,
			stirLiquidConductivityTest,
			stirOnlyTest,
			spargeOnlyTest,
			agitationMethodsTest,
			imagingMethodNullTest,
			liquidConductivityMethodNullTest,
			stirNullTest,
			spargeNullTest,
			(*sampleVolumeLowTest,*)
			sampleVolumeFoamColumnTest,
			temperatureMonitoringTest,
			imagingColumnTest,
			temperatureColumnTest,
			agitationTimeWarningTest,
			agitationSamplingFrequencyLowTest,
			decayTimeWarningTest,
			decaySamplingFrequencyLowTest,
			numberOfWashesLowTest,
			compatibleMaterialsTests
		}],_EmeraldTest];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(*---Resolve aliquot options---*)

	(*Resolve RequiredAliquotContainers as Null, since samples must be transferred into the foam column accepted by the instrument*)
	targetContainers=Null;

	(*Resolve aliquot options and make tests*)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentDynamicFoamAnalysis,
			Download[mySamples,Object],
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache->cache,
			Simulation->updatedSimulation,
			RequiredAliquotAmounts->Null,
			RequiredAliquotContainers->targetContainers,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentDynamicFoamAnalysis,
				Download[mySamples,Object],
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
				Cache->cache,
				Simulation->updatedSimulation,
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->targetContainers,
				Output->Result],
			{}
		}
	];

	(* Resolve Label Options *)
	resolvedSampleLabel=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		suppliedSampleObjects = Download[simulatedSamples, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["dynamic foam analysis sample"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
					LookupObjectLabel[updatedSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedSampleLabelRules, Download[object, Object]]
				]
			],
			{suppliedSampleObjects, Lookup[allOptionsRounded, SampleLabel]}
		]
	];

	resolvedSampleContainerLabel=Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["dynamic foam analysis sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preresolvedSampleContainerLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
					LookupObjectLabel[updatedSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedContainerLabelRules, Download[object, Object]]
				]
			],
			{suppliedContainerObjects, Lookup[allOptionsRounded, SampleContainerLabel]}
		]
	];

	(* Resolve Email option *)
	resolvedEmail=If[!MatchQ[emailOption,Automatic],
		(* If Email is specified, use the supplied value *)
		emailOption,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[uploadOption,MemberQ[output,Result]],
			True,
			False
		]
	];

	(* Resolve Post Processing Options *)
	(*resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];*)
	(*We are overriding the standard post processing options. We are not doing any of this because we don't want the sample to thaw*)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* all resolved options *)
	resolvedOptions=ReplaceRule[Normal[allOptionsRounded],
		Join[
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			resolvedSamplePrepOptions,
			{
				Instrument->instrument,
				Temperature->temperature,
				SampleVolume->resolvedSampleVolumes,
				NumberOfReplicates->numberOfReplicates,
				Agitation->resolvedAgitation,
				AgitationTime->agitationTime,
				AgitationSamplingFrequency->agitationSamplingFrequency,
				DecayTime->decayTime,
				DecaySamplingFrequency->decaySamplingFrequency,
				TemperatureMonitoring->resolvedTemperatureMonitoring,
				DetectionMethod->resolvedDetectionMethod,
				FoamColumn->resolvedFoamColumn,
				FoamColumnLoading->foamColumnLoading,
				LiquidConductivityModule->resolvedLiquidConductivityModule,
				FoamImagingModule->resolvedFoamImagingModule,
				Wavelength->resolvedWavelength,
				HeightIlluminationIntensity->resolvedHeightIlluminationIntensity,
				CameraHeight->resolvedCameraHeight,
				StructureIlluminationIntensity->resolvedStructureIlluminationIntensity,
				FieldOfView->resolvedFieldOfView,
				SpargeFilter->resolvedSpargeFilter,
				SpargeGas->resolvedSpargeGas,
				SpargeFlowRate->resolvedSpargeFlowRate,
				StirBlade->resolvedStirBlade,
				StirRate->resolvedStirRate,
				StirOscillationPeriod->resolvedStirOscillationPeriod,
				NumberOfWashes->resolvedNumberOfWashes,
				Confirm->confirmOption,
				CanaryBranch->canaryBranchOption,
				Name->name,
				Email->resolvedEmail,
				ParentProtocol->parentProtocolOption,
				Upload->uploadOption,
				FastTrack->fastTrackOption,
				Operator->operator,
				SamplesInStorageCondition->samplesInStorageOption,
				Template->templateOption,
				Cache->cache,
				SampleLabel->resolvedSampleLabel,
				SampleContainerLabel->resolvedSampleContainerLabel
			}
		],
		Append->False
	];

	(* generate the Result output rule *)
	(* if we're not returning results, Results rule is just Null *)
	resultRule=Result->If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(* generate the tests rule. If we're not gathering tests, the rule is just Null *)
	testsRule=Tests->If[gatherTests,
		allTests,
		Null
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{resultRule,testsRule}
];


(* ::Subsubsection:: *)
(*Resource Packets*)


DefineOptions[dynamicFoamAnalysisResourcePackets,
	Options:>{
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];


dynamicFoamAnalysisResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs,expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,cache,
		sampleDownloads,samplePackets,pairedSamplesInAndVolumes,sampleVolumeRules,sampleResourceReplaceRules,samplesInResources,
		instrument,foamColumn,liquidConductivityModule,foamImagingModule,spargeFilter,stirBlade,filterCleanerModel,agitationModule,
		instrumentTime,instrumentResource,liquidConductivityModuleResource,foamImagingModuleResource,spargeFilterResource,stirBladeResource,
		filterCleanerResource,agitationModuleResource,protocolPacket,sharedFieldPacket,finalizedPacket,foamImagingModuleNoDuplicate,
		allResourceBlobs,fulfillable,frqTests,testsRule,resultRule,previewRule,optionsRule,wasteContainerResource,oRing1Resource,oRing2Resource,uniqueSyringeResource,uniqueNeedleResource,syringeResource,needleResource,
		containersInResources,foamColumnExpandedResource,liquidConductivityModuleNoDuplicate,spargeFilterNoDuplicate,stirBladeNoDuplicates,
		agitationModuleNoDuplicates,oRingSparge1,oRingSparge2,oRingStir,recirculatingPumpResource,
		numberOfSamples,totalMeasurementTimes,simulation,simulatedSamples,updatedSimulation,
		numReplicates,resolvedSampleVolume,integerNumberOfReplicates,listOfExpandedSamples,samplesInLinks,resourceSamplesIn,
		expandedSamplesWithNumReplicates,optionsWithReplicates,diodeArrayModuleIRResource,diodeArrayModuleVisibleResource,groupedBatches,batchSampleLengths,
		rawDfaParameters,batchSampleIndexes,unitOperationIDs,unitOperationPackets,possibleFoamColumnDuplicates,newDfaParameters,groupedBatchDfaParameters,finalUnitOperationParameters,finalIndexes,finalBatchLengths,remainingAssociation,remainingIndexes,remainingLengths,
		cacheBall,sampleMeasurementTimes
	},
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs,expandedResolvedOptions}=ExpandIndexMatchedInputs[ExperimentDynamicFoamAnalysis,{mySamples},myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentDynamicFoamAnalysis,
		RemoveHiddenOptions[ExperimentDynamicFoamAnalysis,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];
	cache = Lookup[ToList[ops], Cache];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Fetch our cache and simulation from the parent function. *)
	inheritedCache=Lookup[myResolvedOptions,Cache];
	cacheBall = FlattenCachePackets[{cache, inheritedCache}];
	simulation=Lookup[ToList[ops],Simulation];

	(* Get our simulated samples (we have to figure out sample groupings here). *)
	{simulatedSamples,updatedSimulation}=simulateSamplesResourcePacketsNew[ExperimentDynamicFoamAnalysis,mySamples,myResolvedOptions,Cache->inheritedCache,Simulation -> simulation];

	(* --- Make our one big Download call --- *)
	{
		sampleDownloads
	}=Quiet[Download[
		{
			mySamples
		},
		{
			{
				Packet[Container,Volume,Object]
			}
		},
		Cache->inheritedCache
	],
		Download::FieldDoesntExist
	];

	(* add what we Downloaded to the new cache *)
	cache=FlattenCachePackets[{inheritedCache,Flatten[sampleDownloads]}];

	samplePackets=Flatten[sampleDownloads];

	(* --- Make all the resources needed in the experiment --- *)

	(* -- Generate resources for the SamplesIn -- *)

	(* Get the number of replicates *)
	{numReplicates,resolvedSampleVolume} = Lookup[myResolvedOptions,{NumberOfReplicates,SampleVolume}];

	(* convert NumberOfReplicates such that Null->1*)
	integerNumberOfReplicates = numReplicates/.{Null->1};

	(* make a variable that is the number of input samples *)
	numberOfSamples = Length[mySamples];

	(* Expand the samples according to the number of replicates *)
	{expandedSamplesWithNumReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentDynamicFoamAnalysis,mySamples,expandedResolvedOptions];

	(* Pair the SamplesIn and their Volumes *)
	(* Pair the SamplesIn and their Volumes - this combines anything with a volume listed*)
	pairedSamplesInAndVolumes=MapThread[
		If[MatchQ[#3,Except[Null]],
			#1->#3,
			#1->#2
		]&,
		{expandedSamplesWithNumReplicates,Lookup[optionsWithReplicates,SampleVolume],Lookup[optionsWithReplicates,AliquotAmount]}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleVolumeRules=Merge[pairedSamplesInAndVolumes,Total];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules=KeyValueMap[
		Function[{sample,volume},
			If[VolumeQ[volume],
				sample->Resource[Sample->sample,Name->ToString[Unique[]],Amount->volume],
				sample->Resource[Sample->sample,Name->ToString[Unique[]]]
			]
		],
		sampleVolumeRules
	];

	(* Make the SamplesIn links *)
	samplesInLinks=Link[listOfExpandedSamples,Protocols];

	(* make resourceSamplesIn *)
	resourceSamplesIn=samplesInLinks/.sampleResourceReplaceRules;

	(* Use the replace rules to get the sample resources *)
	samplesInResources = Replace[expandedSamplesWithNumReplicates, sampleResourceReplaceRules, {1}];

	(* ContainersIn *)
	containersInResources=(Link[Resource[Sample->#],Protocols]&)/@Lookup[samplePackets,Container][Object];

	(* -- Generate instrument resources -- *)

	(* Get the objects*)
	{
		instrument,
		foamColumn,
		liquidConductivityModule,
		foamImagingModule,
		spargeFilter,
		stirBlade
	}=Lookup[optionsWithReplicates,
		{
			Instrument,
			FoamColumn,
			LiquidConductivityModule,
			FoamImagingModule,
			SpargeFilter,
			StirBlade
		}];

	(* Set the filter cleaner model *)
	filterCleanerModel=Model[Instrument,SpargeFilterCleaner,"TO4511 Filter Cleaner"];

	(*Set the agitation module depending on whether agitation is stir or sparge*)
	agitationModule=Map[
		Which[
			MatchQ[#,Stir],
			Model[Container,FoamAgitationModule,"DFA100 Stir"],
			MatchQ[#,Sparge],
			Model[Container,FoamAgitationModule,"DFA100 Sparge"]
		]&,
		Lookup[optionsWithReplicates,Agitation]
	];

	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
		this will probably look like set-up time + time/sample + tear-down time *)
	(*instrumentTime*)
	(* Determine the measurement times for each sample *)
	sampleMeasurementTimes=Lookup[optionsWithReplicates,AgitationTime]+Lookup[optionsWithReplicates,DecayTime];

	(*Determine measurement times*)
	totalMeasurementTimes=Total[sampleMeasurementTimes];

	(* Estimate the time needed to run an experiment *)
	instrumentTime=Plus[

		(* Time spent actually measuring the sample is equal to the sum of the agitation and decay times *)
		totalMeasurementTimes,

		(* transferring sample into and out of the instrument is approximately 5 minutes *)
		80 Minute*numberOfSamples,

		(* processing time *)
		5 Minute

	];

	(*make resources for INSTRUMENT*)
	instrumentResource=Resource[Instrument->instrument,Time->instrumentTime];

	(* if the following are needed, make their resources. Otherwise save as Null*)

	(* LIQUID CONDUCTIVITY MODULE *)
	(* delete duplicates*)
	liquidConductivityModuleNoDuplicate=(#->Resource[Sample->#,Name->ToString[Unique[]]])&/@DeleteDuplicates[Cases[Flatten[liquidConductivityModule],Except[Null]]];

	(* if needed, then save the single resource we made. If not needed, store Null *)
	liquidConductivityModuleResource=If[!MatchQ[#,Null],
		Lookup[liquidConductivityModuleNoDuplicate,#],
		Null
	]&/@Flatten[liquidConductivityModule];

	(* FOAM IMAGING MODULE *)
	(* delete duplicates *)
	foamImagingModuleNoDuplicate=(#->Resource[Sample->#,Name->ToString[Unique[]]])&/@DeleteDuplicates[Cases[Flatten[foamImagingModule],Except[Null]]];

	(* if needed, then save the single resource we made. If not needed, store Null *)
	foamImagingModuleResource=If[!MatchQ[#,Null],
		Lookup[foamImagingModuleNoDuplicate,#],
		Null
	]&/@Flatten[foamImagingModule];

	(* SPARGE FILTER *)
	(* delete duplicates *)
	spargeFilterNoDuplicate=(#->Resource[Sample->#,Name->ToString[Unique[]]])&/@DeleteDuplicates[Cases[Flatten[spargeFilter],Except[Null]]];

	(* if needed, then save the single resource we made. If not needed, store Null *)
	spargeFilterResource=If[!MatchQ[#,Null],
		Lookup[spargeFilterNoDuplicate,#],
		Null
	]&/@Flatten[spargeFilter];

	(* STIR BLADE *)
	(* delete duplicates *)
	stirBladeNoDuplicates=(#->Resource[Sample->#,Name->ToString[Unique[]]])&/@DeleteDuplicates[Cases[Flatten[stirBlade],Except[Null]]];

	(* if needed, then save the single resource we made. If not needed, store Null *)
	stirBladeResource=If[!MatchQ[#,Null],
		Lookup[stirBladeNoDuplicates,#],
		Null
	]&/@Flatten[stirBlade];

	(* FILTER CLEANER RESOURCE *)
	(* this is like instrument - only one is picked, and it's either picked or not picked so we don't need to worry about duplicates*)
	filterCleanerResource=If[MemberQ[Lookup[optionsWithReplicates,Agitation],Sparge],
		Resource[Instrument->filterCleanerModel,Name->ToString[Unique[]],Time->15 Minute],
		Null
	];

	(* RECIRCULATING PUMP RESOURCE *)
	(* this is like instrument - only one is picked, and it's either picked or not picked so we don't need to worry about duplicates*)
	recirculatingPumpResource=If[MemberQ[Lookup[optionsWithReplicates,Temperature],Except[$AmbientTemperature]],
		Resource[Instrument->Model[Instrument,RecirculatingPump,"PolyScience SD07R-20"],Name->ToString[Unique[]],Time->instrumentTime],
		Null
	];

	(* DIODE ARRAY MODULE RESOURCE *)
	(* only need to pick these if infrared is used. *)
	{diodeArrayModuleIRResource,diodeArrayModuleVisibleResource}=If[MemberQ[Lookup[optionsWithReplicates,Wavelength],850 Nanometer],
		{
			Resource[Sample->Model[Part,DiodeArrayModule,"Infrared DiodeArrayModule"],Name->ToString[Unique[]]],
			Resource[Sample->Model[Part,DiodeArrayModule,"Visible DiodeArrayModule"],Name->ToString[Unique[]]]
		},
		{Null,Null}
	];

	(* WASTE CONTAINER RESOURCE *)
	(* this is like instrument - only one is picked, and it's either picked or not picked so we don't need to worry about duplicates*)
	wasteContainerResource=Resource[Sample->Model[Container,Vessel,"1000mL Glass Beaker"],Rent->True];

	(* AGITATION MODULE RESOURCE *)
	(* delete duplicates since the samples reuse the same agitation modules *)
	agitationModuleNoDuplicates=(#->Resource[Sample->#,Name->ToString[Unique[]]])&/@DeleteDuplicates[Flatten[agitationModule]];

	(* this is the expanded version to be used in looping *)
	agitationModuleResource=Map[
		Lookup[agitationModuleNoDuplicates,#]&,
		agitationModule
	];

	(* ORINGS RESOURCES - will grab separately based on what agitation is used *)
	oRingStir=Resource[Sample->Model[Part,ORing,"Nitrile Rubber 0.139in x 2.625in O-Ring"],Name->ToString[Unique[]]]; (* "Nitrile Rubber 0.139in x 2.625in O-Ring" -- this is the newer, thicker o-ring  *)
	oRingSparge1=Resource[Sample->Model[Part,ORing,"DFA100 ORing Sparge"],Name->ToString[Unique[]]];
	oRingSparge2=Resource[Sample->Model[Part,ORing,"DFA100 ORing Sparge"],Name->ToString[Unique[]]];

	oRing1Resource=Which[
		MatchQ[#,Sparge],
		oRingSparge1,
		MatchQ[#,Stir],
		oRingStir
	]&/@Lookup[optionsWithReplicates,Agitation];

	oRing2Resource=Which[
		MatchQ[#,Sparge],
		oRingSparge2,
		MatchQ[#,Stir],
		Null
	]&/@Lookup[optionsWithReplicates,Agitation];

	(* SYRINGE AND NEEDLE RESOURCES *)
	(* Prepare Syringe and Needle Resource - Use one syringe and one needle for each sample - same for replicates of one sample *)
	uniqueSyringeResource=Resource[Sample->#,Name->ToString[Unique[]]]&/@Table[Model[Container, Syringe, "id:AEqRl9Kz1VD1"],Length[mySamples]];

	uniqueNeedleResource=Resource[Sample->#,Name->ToString[Unique[]],Rent->True]&/@Table[Model[Item, Needle, "id:O81aEBZaXOBx"],Length[mySamples]];

	(* SYRINGE RESOURCES expanded *)
	syringeResource=Flatten[Table[#,integerNumberOfReplicates]&/@uniqueSyringeResource];

	(* NEEDLE RESOURCES expanded *)
	needleResource=Flatten[Table[#,integerNumberOfReplicates]&/@uniqueNeedleResource];

	(* ---- BATCHING CALCULATIONS FOR MULTIPLE COLUMNS---- *)
	(* Group batches by foam column. THis is the only one we care about since the batching is just to allow foam column washing *)
	groupedBatches=GatherBy[
		Transpose[{
			(*1*)samplesInResources,

			(*2*)foamColumn,
			(*3*)Lookup[optionsWithReplicates,SampleVolume],
			(*4*)Lookup[optionsWithReplicates,FoamColumnLoading],
			(*5*)Lookup[optionsWithReplicates,Temperature],
			(*6*)Lookup[optionsWithReplicates,TemperatureMonitoring],
			(*7*)Lookup[optionsWithReplicates,DetectionMethod],
			(*8*)liquidConductivityModuleResource,
			(*9*)foamImagingModuleResource,
			(*10*)Lookup[optionsWithReplicates,Wavelength],
			(*11*)Lookup[optionsWithReplicates,CameraHeight],
			(*12*)Lookup[optionsWithReplicates,FieldOfView],
			(*13*)Lookup[optionsWithReplicates,Agitation],
			(*14*)spargeFilterResource,
			(*15*)stirBladeResource,
			(*16*)agitationModuleResource,
			(*17*)Lookup[optionsWithReplicates,NumberOfWashes],
			(*18*)syringeResource,
			(*19*)needleResource,
			(*20*)oRing1Resource,
			(*21*)oRing2Resource,
			(*22*)Range[Length[expandedSamplesWithNumReplicates]], (* this is the index of the sample *)
			(*23*)Lookup[optionsWithReplicates,AgitationTime],
			(*24*)Lookup[optionsWithReplicates,DecayTime],
			(*25*)sampleMeasurementTimes
		}],

		(* Group by the foam columns*)
		#[[2]]&
	];

	(* calculate the batches *)
	{batchSampleLengths,batchSampleIndexes,rawDfaParameters}=Transpose@Map[
		Function[{groupedFoamBatch},
			Module[{batch,groupedSamples,groupFoamColumn,myFoamColumnObjects,potentialFoamColumnObjects,potentialFoamColumnStatus,groupedColumnNumbers,potentialFoamColumnRestricted,numberOfSamples,regroupedBatch,regroupedSamples,rearrangedRegroupedBatch,groupedSampleIndexes,batchAssociation},

				(* get all the things in the batch *)
				batch=Transpose@groupedFoamBatch;

				(* Get the samples. *)
				groupedSamples=groupedFoamBatch[[All,1]];

				(* Get the foam columns *)
				(* Batches are grouped by the foam columns so this must be length 1. Take its first *)
				groupFoamColumn=DeleteDuplicates[groupedFoamBatch[[All,2]]][[1]];

				(* look up the possible foam column objects from the cache if it is a model. IF not a model just store that object *)
				myFoamColumnObjects=If[MatchQ[groupFoamColumn,ObjectP[Model[Container,FoamColumn]]],
					(* Find all potential objects from cache *)
					potentialFoamColumnObjects=Download[Lookup[cacheLookup[cache,groupFoamColumn],Objects],Object];
					(* Check the column status and Restricted so we can ignore them for batching and resource fulfillment *)
					potentialFoamColumnStatus=Lookup[cacheLookup[cache,#],Status]&/@potentialFoamColumnObjects;
					potentialFoamColumnRestricted=Lookup[cacheLookup[cache,#],Restricted]&/@potentialFoamColumnObjects;
					(* Pick the ones that are not discarded and not restricted *)
					PickList[potentialFoamColumnObjects,Transpose[{potentialFoamColumnStatus,potentialFoamColumnRestricted}],{Except[Discarded],Except[True]}],
					{groupFoamColumn}
				];

				(* figure out how many possible foam column objects there are so we can batch correctly *)
				(* if there are _zero_, we want to just set it to 1 directly here so that we don't trainwreck; FRQ should still throw an error for us *)
				groupedColumnNumbers=Length[myFoamColumnObjects] /. {0 -> 1};

				(* make a variable that is the number of input samples *)
				numberOfSamples=Length[groupedSamples];

				(*Partition the samples based on how many containers can be run in each batch*)
				regroupedBatch=PartitionRemainder[#,groupedColumnNumbers]&/@batch;
				rearrangedRegroupedBatch=Transpose@regroupedBatch;

				(* pull out the samples from the rearranged regrouped batch *)
				regroupedSamples=rearrangedRegroupedBatch[[All,1]];

				(*determine the index of working samples these batched samples correspond to, so we can pull it out later*)
				(* we have to use the helper index because we might have the sample sample several times in mySamples *)
				groupedSampleIndexes=rearrangedRegroupedBatch[[All,22]];

				(* build the batch association*)
				batchAssociation=Map[
					<|
						(*1*)Replace[Sample]->Link/@Flatten@#[[1]],
						(*2*)FoamColumn->Flatten@#[[2]], (* Note; the replace rule here will get fixed later *)
						(*3*)Replace[SampleVolume]->Flatten@#[[3]],
						(*4*)Replace[FoamColumnLoading]->Flatten@#[[4]],
						(*5*)Replace[Temperature]->Flatten@#[[5]],
						(*6*)Replace[TemperatureMonitoring]->Flatten@#[[6]],
						(*7*)Replace[DetectionMethod]->Flatten@#[[7]],
						(*8*)Replace[LiquidConductivityModule]->Flatten@#[[8]],
						(*9*)Replace[FoamImagingModule]->Flatten@#[[9]],
						(*10*)Replace[Wavelength]->Flatten@#[[10]],
						(*11*)Replace[CameraHeight]->Flatten@#[[11]],
						(*12*)Replace[FieldOfView]->Flatten@#[[12]],
						(*13*)Replace[Agitation]->Flatten@#[[13]],
						(*14*)Replace[SpargeFilter]->Flatten@#[[14]],
						(*15*)Replace[StirBlade]->Flatten@#[[15]],
						(*16*)Replace[FoamAgitationModule]->Flatten@#[[16]],
						(*17*)Replace[NumberOfWashes]->Flatten@#[[17]],
						(*18*)Replace[Syringes]->Flatten@#[[18]],
						(*19*)Replace[Needles]->Flatten@#[[19]],
						(*20*)Replace[ORing]->Flatten@#[[20]],
						(*21*)Replace[SecondaryORing]->Flatten@#[[21]],
						(*23*)Replace[AgitationTime]->Flatten@#[[23]],
						(*24*)Replace[DecayTime]->Flatten@#[[24]],
						(*25*)Replace[MeasurementTime]->Flatten@#[[25]]
					|>&,
					rearrangedRegroupedBatch
				];

				{{Length[#]& /@ Lookup[batchAssociation, FoamColumn]},groupedSampleIndexes,batchAssociation}
			]
		],
		groupedBatches
	];

	(* make resources for FOAM COLUMN *)
	(* make an array with *)
	possibleFoamColumnDuplicates=Map[
		Function[{myFoamColumn},
			Module[{myFoamColumnObjects,potentialFoamColumnObjects,potentialFoamColumnStatus,potentialFoamColumnRestricted,myFoamColumnObjectLengths,myFoamColumnResources},
				(* look up the possible foam column objects from the cache if it is a model. IF not a model just store that object *)
				myFoamColumnObjects=If[MatchQ[myFoamColumn,ObjectP[Model[Container,FoamColumn]]],
					(* Find all potential objects from cache *)
					potentialFoamColumnObjects=Download[Lookup[cacheLookup[cache,myFoamColumn],Objects],Object];
					(* Check the column status and Restricted so we can ignore them for batching and resource fulfillment *)
					potentialFoamColumnStatus=Lookup[cacheLookup[cache,#],Status]&/@potentialFoamColumnObjects;
					potentialFoamColumnRestricted=Lookup[cacheLookup[cache,#],Restricted]&/@potentialFoamColumnObjects;
					(* Pick the ones that are not discarded and not restricted *)
					PickList[potentialFoamColumnObjects,Transpose[{potentialFoamColumnStatus,potentialFoamColumnRestricted}],{Except[Discarded],Except[True]}],
					{myFoamColumn}
				];

				(* figure out how many possible foam column objects there are*)
				(* don't trainwreck if we have nothing *)
				myFoamColumnObjectLengths=Length[myFoamColumnObjects] /. {0 -> 1};

				(* make a resource for each possible object in the list*)
				myFoamColumnResources=Resource[Sample->#,Name->ToString[Unique[]]]&/@ConstantArray[myFoamColumn,myFoamColumnObjectLengths];

				(* make a rule of constant array of the foam column, with the length of the possible objects. Using a string to look up later*)
				ObjectToString[myFoamColumn]->myFoamColumnResources
			]
		],
		DeleteDuplicates[Flatten[foamColumn]]
	];

	(* replace FoamColumn in the batching parameters with the column resources we made *)
	newDfaParameters=Map[
		Function[{myDfaParameters},
			Module[{myFoamObjects,myFoamObjectLength,myFoamObjectResources,myFoamObject,myFoamObjectResourceAssoc},

				Map[
					Function[{myInnerDfaParameters},
						(* look up the foam column we want from the batch association*)
						myFoamObjects=Lookup[myInnerDfaParameters,FoamColumn];

						(* figure out how many objects we have in this batch *)
						myFoamObjectLength=Length[Flatten@myFoamObjects];

						(* my single foam object string for looking up*)
						myFoamObject=ObjectToString[Sequence@@DeleteDuplicates[Flatten@myFoamObjects]];

						(* grab the right number of the resources we made *)
						myFoamObjectResources=Take[Lookup[possibleFoamColumnDuplicates,myFoamObject],myFoamObjectLength];

						(* make an association with this resource*)
						myFoamObjectResourceAssoc=<|FoamColumn->myFoamObjectResources,Replace[FoamColumn]->myFoamObjectResources|>;

						(* replace this into the batch association *)
						Join[myInnerDfaParameters,myFoamObjectResourceAssoc]],
					myDfaParameters]
			]
		],
		rawDfaParameters
	];

	(* this is the expanded version to be saved as the foam column in the packets, that index matches to the samples *)
	(* rearrange to index match properly *)
	foamColumnExpandedResource=(Flatten@Lookup[Flatten@newDfaParameters,FoamColumn])[[Ordering@Flatten@batchSampleIndexes]];

	(* --- MAKE THE FINAL UNIT OPERATION PACKETS ---*)

	(* first we want to combine batches that aren't using the same foam columns - this will let us build even bigger batches *)
	groupedBatchDfaParameters=GatherBy[Transpose@{newDfaParameters,batchSampleIndexes,batchSampleLengths},Lookup[#[[1]],FoamColumn] &];

	{finalUnitOperationParameters,finalIndexes,finalBatchLengths}=Module[{loopList,combineList,newAssociation,tempLength,newLengths,newIndexes,remainingList},

		(* store initial empty lists for the new association, batch lengths, and indexes*)
		newAssociation={};
		newLengths={};
		newIndexes={};

		(* save the initial loop list as our grouped batch parameters*)
		loopList=First/@groupedBatchDfaParameters;

		(* build the new packets - this is the meat of the function here*)
		While[True,

			(* save the new association, merging it together to combine elements*)
			newAssociation=Append[newAssociation,Flatten/@Merge[First/@First/@loopList,List]];

			(* get the new batch lengths*)
			tempLength=Total@(First@First@#[[3, All]] & /@ loopList);
			newLengths=Append[newLengths,tempLength];

			(* get the new batch indexes*)

			newIndexes=Append[newIndexes,First/@(#[[2, All]] & /@ loopList)];

			(* the remaining elements out of each grouped set and replace any empty lists with nothing, to remove the empty lists*)
			remainingAssociation=(Rest /@ First /@ loopList)/.{}->Nothing;

			remainingIndexes=Rest/@(#[[2, All]] & /@ loopList)/.{}->Nothing;
			remainingLengths=(Rest/@#[[3, All]] & /@ loopList)/.{{}}->Nothing;

			(* if the remaining list still has something in it, we go back into the While loop. If it is left empty, it means we're done and break out of the loop *)
			If[Length[remainingAssociation]>0,
				(* build the remaining list and save it again for the loop*)
				remainingList=Transpose@{remainingAssociation,remainingIndexes,remainingLengths};
				loopList=remainingList,

				(*otherwise if no more left, then break out of the loop*)
				Break[]]
		];

		(* return our newly built combined association, indexes, and lengths*)
		{newAssociation,newIndexes,newLengths}
	];

	(* make IDs for the unit operation packets *)
	unitOperationIDs=CreateID[ConstantArray[Object[UnitOperation,DynamicFoamAnalysis],Length@finalUnitOperationParameters]];

	(* make the unit operation packets *)
	unitOperationPackets=MapThread[
		Function[{myIDs,myParameters},
			Join[
				<|Object->myIDs|>,
				KeyDrop[myParameters,FoamColumn]
			]
		],
		{unitOperationIDs,finalUnitOperationParameters}
	];

	(* --- GENERATE THE PROTOCOL PACKET --- *)
	protocolPacket=Join[<|
		(*Organizational information/options handling*)
		Type->Object[Protocol,DynamicFoamAnalysis],
		Object->CreateID[Object[Protocol,DynamicFoamAnalysis]],
		Replace[SamplesIn]->samplesInResources,
		Replace[ContainersIn]->containersInResources,
		Replace[SamplesInStorage]->Lookup[optionsWithReplicates,SamplesInStorageCondition],
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->myResolvedOptions,
		Operator->Link[Lookup[myResolvedOptions,Operator]],

		(* protocol specific fields that are picked *)
		Replace[Instrument]->instrumentResource,
		Replace[FoamColumn]->Flatten@foamColumnExpandedResource,
		Replace[LiquidConductivityModule]->liquidConductivityModuleResource,
		Replace[FoamImagingModule]->foamImagingModuleResource,
		Replace[SpargeFilter]->spargeFilterResource,
		Replace[StirBlade]->stirBladeResource,

		(* protocol specific fields that are not picked *)
		Replace[FoamColumnLoading]->Lookup[optionsWithReplicates,FoamColumnLoading],
		Replace[Temperature]->Lookup[optionsWithReplicates,Temperature],
		Replace[TemperatureMonitoring]->Lookup[optionsWithReplicates,TemperatureMonitoring],
		Replace[DetectionMethod]->Lookup[optionsWithReplicates,DetectionMethod],
		Replace[Wavelength]->Lookup[optionsWithReplicates,Wavelength],
		Replace[HeightIlluminationIntensity]->Lookup[optionsWithReplicates,HeightIlluminationIntensity],
		Replace[CameraHeight]->Lookup[optionsWithReplicates,CameraHeight],
		Replace[StructureIlluminationIntensity]->Lookup[optionsWithReplicates,StructureIlluminationIntensity],
		Replace[FieldOfView]->Lookup[optionsWithReplicates,FieldOfView],
		Replace[MeasurementTime]->sampleMeasurementTimes,
		Replace[Agitation]->Lookup[optionsWithReplicates,Agitation],
		Replace[AgitationTime]->Lookup[optionsWithReplicates,AgitationTime],
		Replace[AgitationSamplingFrequency]->Lookup[optionsWithReplicates,AgitationSamplingFrequency],
		Replace[SpargeGas]->Lookup[optionsWithReplicates,SpargeGas],
		Replace[SpargeFlowRate]->Lookup[optionsWithReplicates,SpargeFlowRate],
		Replace[StirRate]->Lookup[optionsWithReplicates,StirRate],
		Replace[StirOscillationPeriod]->Lookup[optionsWithReplicates,StirOscillationPeriod],
		Replace[DecayTime]->Lookup[optionsWithReplicates,DecayTime],
		Replace[DecaySamplingFrequency]->Lookup[optionsWithReplicates,DecaySamplingFrequency],
		Replace[NumberOfWashes]->Lookup[optionsWithReplicates,NumberOfWashes],
		Replace[SampleVolume]->Lookup[optionsWithReplicates,SampleVolume],

		(* other needed resources not in options*)
		Replace[SpargeFilterCleaner]->filterCleanerResource,
		Replace[FoamAgitationModule]->agitationModuleResource,
		Replace[WasteContainer]->wasteContainerResource,
		Replace[ORing]->oRing1Resource,
		Replace[SecondaryORing]->oRing2Resource,
		Replace[Syringes]->syringeResource,
		Replace[Needles]->needleResource,
		Replace[RecirculatingPump]->recirculatingPumpResource,
		Replace[DiodeArrayModuleIR]->diodeArrayModuleIRResource,
		Replace[DiodeArrayModuleVisible]->diodeArrayModuleVisibleResource,

		(* batching things *)
		Replace[BatchedSampleLengths]->Flatten@finalBatchLengths,
		Replace[BatchedSampleIndexes]->Flatten@finalIndexes,
		Replace[BatchedUnitOperations]->Link[unitOperationIDs,Protocol],

		(*Resources*)
		Replace[Checkpoints]->{
			{"Preparing Samples",15 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->$BaselineOperator,Time->30 Minute]]},
			{"Picking Resources",15 Minute,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->$BaselineOperator,Time->5 Minute]]},
			{"Dynamic Foam Analysis",instrumentTime,"Samples are placed into the instrument and then a dynamic foam analysis experiment is run.",Link[Resource[Operator->$BaselineOperator,Time->instrumentTime]]},
			{"Returning Materials",20 Minute,"Samples are returned to storage.",Link[Resource[Operator->$BaselineOperator,Time->20*Minute]]}
		}
	|>
	];

	(* generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cache,Simulation->updatedSimulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[{Values[finalizedPacket],unitOperationPackets}],_Resource,Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache,Simulation->updatedSimulation],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache,Simulation->updatedSimulation],Null}
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
		{finalizedPacket,unitOperationPackets},
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];


(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*ExperimentDynamicFoamAnalysisPreview*)


DefineOptions[ExperimentDynamicFoamAnalysisPreview,
	SharedOptions:>{ExperimentDynamicFoamAnalysis}
];


ExperimentDynamicFoamAnalysisPreview[sampleIn:(ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String),myOptions:OptionsPattern[]]:=ExperimentDynamicFoamAnalysisPreview[{sampleIn},myOptions];

ExperimentDynamicFoamAnalysisPreview[samplesIn:{(ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
	{listedOptionsNamed,noOutputOptions},

	(* get the options as a list *)
	listedOptionsNamed=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptionsNamed,Output->_];

	(* return only the preview for ExperimentDynamicFoamAnalysis *)
	ExperimentDynamicFoamAnalysis[samplesIn,Append[noOutputOptions,Output->Preview]]
];



(* ::Subsection::Closed:: *)
(*ExperimentDynamicFoamAnalysisOptions*)


DefineOptions[ExperimentDynamicFoamAnalysisOptions,
	SharedOptions:>{ExperimentDynamicFoamAnalysis},
	{
		OptionName->OutputFormat,
		Default->Table,
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
		Description->"Determines whether the function returns a table or a list of the options."
	}
];

ExperimentDynamicFoamAnalysisOptions[sampleIn:(ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String),myOptions:OptionsPattern[]]:=ExperimentDynamicFoamAnalysisOptions[{sampleIn},myOptions];

ExperimentDynamicFoamAnalysisOptions[samplesIn:{(ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String)..},myOptions:OptionsPattern[]]:=Module[
	{listedOptionsNamed,noOutputOptions,options},

	(* get the options as a list *)
	listedOptionsNamed=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptionsNamed,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentDynamicFoamAnalysis *)
	options=ExperimentDynamicFoamAnalysis[samplesIn,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptionsNamed,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentDynamicFoamAnalysis],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentDynamicFoamAnalysisQ*)


DefineOptions[ValidExperimentDynamicFoamAnalysisQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentDynamicFoamAnalysis}
];


ValidExperimentDynamicFoamAnalysisQ[myInput:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentDynamicFoamAnalysisQ]]:=Module[
	{listedInput,listedOptionsNamed,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	listedInput=ToList[myInput];
	listedOptionsNamed=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptionsNamed,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentDynamicFoamAnalysis[myInput,preparedOptions];

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
	safeOps=SafeOptions[ValidExperimentDynamicFoamAnalysisQ,Normal@KeyTake[listedOptionsNamed,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentDynamicFoamAnalysis"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"ExperimentDynamicFoamAnalysis"
	]
];



(* ::Subsection::Closed:: *)
(* simulateExperimentDynamicFoamAnalysis *)

DefineOptions[
	simulateExperimentDynamicFoamAnalysis,
	Options:>{CacheOption,SimulationOption}
];

simulateExperimentDynamicFoamAnalysis[myResourcePacket:(PacketP[Object[Protocol, DynamicFoamAnalysis], {Object, ResolvedOptions}]|$Failed), mySamples:{ObjectP[Object[Sample]]...},myResolvedOptions:{_Rule...},myResolutionOptions:OptionsPattern[simulateExperimentDynamicFoamAnalysis]]:=Module[
	{cache, simulation, samplePackets, protocolObject, fulfillmentSimulation, simulationWithLabels},


	(* Lookup our cache and simulation. *)
	cache=Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Download containers from our sample packets. *)
	samplePackets=Download[
		mySamples,
		Packet[Container],
		Cache->Lookup[ToList[myResolutionOptions], Cache, {}],
		Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
	];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=If[MatchQ[myResourcePacket, $Failed],
		SimulateCreateID[Object[Protocol,DynamicFoamAnalysis]],
		Lookup[myResourcePacket, Object]
	];


	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	fulfillmentSimulation=If[MatchQ[myResourcePacket, $Failed],
		SimulateResources[
			<|
				Object->protocolObject,
				Replace[SamplesIn]->(Resource[Sample->#,Name -> CreateUUID[]]&)/@mySamples,
				ResolvedOptions->myResolvedOptions
			|>,
			Cache->cache,
			Simulation->simulation
		],
		SimulateResources[
			myResourcePacket,
			Cache->cache,
			Simulation->simulation
		]
	];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[Sample[[#]]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[Sample[[#]][Container]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			]
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[fulfillmentSimulation, simulationWithLabels]
	}
];



(* ::Section:: *)
(*End Private*)
