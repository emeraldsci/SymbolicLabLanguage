(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)



DefineOptionSet[FluorescenceBaseOptions:>{
	{
		OptionName->ReadLocation,
		Default->Automatic,
		Description->"Indicates if fluorescence should be measured using an optic above the plate or one below the plate.",
		ResolutionDescription->"Defaults to Bottom if RetainCover is set to True, otherwise defaults to Top.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>ReadLocationP]
	},
	{
		OptionName->Temperature,
		Default->Ambient,
		Description->"The temperature at which the experiment will be performed, if using a plate reader with temperature incubation controls.",
		AllowNull->False,
		Widget->Alternatives[
			Widget[Type->Quantity,Pattern:>RangeP[$AmbientTemperature,45 Celsius],Units:>{1,{Celsius,{Celsius,Fahrenheit}}}],
			Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
		]
	},
	{
		OptionName->EquilibrationTime,
		Default->Automatic,
		Description->"The length of time for which the assay plates should equilibrate at the assay temperature in the plate reader before being read.",
		ResolutionDescription->"Defaults to 0 Second if Temperature is set to Ambient. Otherwise defaults to 5 Minute.",
		AllowNull->False,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Minute,1 Hour],Units:>{1,{Minute,{Second,Minute,Hour}}}]
	},
	{
		OptionName->NumberOfReadings,
		Default->100,
		Description->"Number of redundant readings which should be taken by the detector to determine a single averaged fluorescence intensity reading.",
		AllowNull->False,
		Widget->Widget[Type->Number,Pattern:>RangeP[1,200]]
	},
	IndexMatching[
		IndexMatchingInput->"experiment samples",
		(* for manual primitives. *)
		{
			OptionName -> SampleLabel,
			Default -> Automatic,
			Description->"A user defined word or phrase used to identify the samples that will be analyzed, for use in downstream unit operations.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget->Widget[
				Type->String,
				Pattern:>_String,
				Size->Line
			],
			UnitOperation->True
		},
		{
			OptionName -> SampleContainerLabel,
			Default -> Automatic,
			Description->"A user defined word or phrase used to identify the containers of the samples that will be analyzed, for use in downstream unit operations.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget->Widget[
				Type->String,
				Pattern:>_String,
				Size->Line
			],
			UnitOperation->True
		},
		{
			OptionName->PrimaryInjectionSample,
			Default->Null,
			Description->"The sample to be injected in the first round of injections in order to introduce a time sensitive reagent/sample into the plate before/during fluorescence measurement.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Category->"Sample Handling"
		},
		{
			OptionName->SecondaryInjectionSample,
			Default->Null,
			Description->"The sample to be injected in the second round of injections.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Category->"Sample Handling"
		},
		{
			OptionName->PrimaryInjectionVolume,
			Default->Null,
			Description->"The amount of the primary sample which should be injected in the first round of injections.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.5 Microliter,300 Microliter],
				Units->Microliter
			],
			Category->"Sample Handling"
		},
		{
			OptionName->SecondaryInjectionVolume,
			Default->Null,
			Description->"The amount of the secondary sample which should be injected in the second round of injections.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.5 Microliter,300 Microliter],
				Units->Microliter
			],
			Category->"Sample Handling"
		}
	],
	{
		OptionName->PrimaryInjectionFlowRate,
		Default->Automatic,
		Description->"The speed at which to transfer injection samples into the assay plate in the first round of injections.",
		ResolutionDescription->"Defaults to 300 Microliter/Second if primary injections are specified.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>BMGFlowRateP],
		Category->"Sample Handling"
	},
	{
		OptionName->SecondaryInjectionFlowRate,
		Default->Automatic,
		Description->"The speed at which to transfer injection samples into the assay plate in the second round of injections.",
		ResolutionDescription->"Defaults to 300 Microliter/Second if secondary injections are specified.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>BMGFlowRateP],
		Category->"Sample Handling"
	},
	PlateReaderMixOptions,
	BMGSamplingOptions,
	{
		OptionName->ReadDirection,
		Default->Row,
		Description->"Indicates the order in which wells should be read by specifying the plate path the instrument should follow when measuring fluorescence.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>ReadDirectionP],
		Category->"Sample Handling"
	},
	{
		OptionName -> InjectionSampleStorageCondition,
		Default -> Null,
		Description -> "The non-default conditions under which any injection samples used by this experiment should be stored after the protocol is completed.",
		AllowNull -> True,
		Category -> "Sample Handling",
		Widget -> Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
	},
	SamplesInStorageOption,
	SimulationOption,
	WorkCellOption,
	PreparationOption
}];


DefineOptionSet[FluorescenceOptions:>{
	{
		OptionName->Instrument,
		Default->Automatic,
		Description->"The plate reader used to measure fluorescence intensity.",
		AllowNull->False,
		Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,PlateReader],Object[Instrument,PlateReader]}]],
		Category -> "Optics"
	},
	{
		OptionName->RetainCover,
		Default->False,
		Description->"Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation. When this option is set to True, injections cannot be performed as it's not possible to inject samples through the cover.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
	},
	MoatOptions,
	FluorescenceBaseOptions,
	FuntopiaSharedOptions,
	(* Overwrite ConsolidateAliquots pattern since it can never be set to True since we will never read the same well multiple times *)
	{
		OptionName -> ConsolidateAliquots,
		Default -> Automatic,
		Description -> "Indicates if identical aliquots should be prepared in the same container/position.",
		AllowNull -> True,
		Category -> "Aliquoting",
		Widget -> Widget[Type->Enumeration,Pattern:>Alternatives[False]]
	},
	AnalyticalNumberOfReplicatesOption
}];


(* ::Subsection:: *)
(*IntensityAndKineticsOptions*)


(* ::Section:: *)
(*AdditionalInjectionsOptions*)

DefineOptionSet[AdditionalInjectionsOptions:>{
	IndexMatching[
		IndexMatchingInput->"experiment samples",
		{
			OptionName->TertiaryInjectionSample,
			Default->Null,
			Description->"The sample to be injected in the third round of injections.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Category->"Sample Handling"
		},
		{
			OptionName->QuaternaryInjectionSample,
			Default->Null,
			Description->"The sample to be injected in the fourth round of injections.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Category->"Sample Handling"
		},
		{
			OptionName->TertiaryInjectionVolume,
			Default->Null,
			Description->"The amount of the tertiary sample which should be injected in the third round of injections.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.5 Microliter,300 Microliter],
				Units->Microliter
			],
			Category->"Sample Handling"
		},
		{
			OptionName->QuaternaryInjectionVolume,
			Default->Null,
			Description->"The amount of the quaternary sample which should be injected in the fourth round of injections.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.5 Microliter,300 Microliter],
				Units->Microliter
			],
			Category->"Sample Handling"
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
	}
}];


(* ::Subsection:: *)
(*TimeResolvedOptions*)

DefineOptionSet[TimeResolvedOptions:>{
	{
		OptionName->DelayTime,
		Default->Automatic,
		Description->"The amount of time which should be allowed to pass after excitation and before fluorescence measurement begins.",
		AllowNull->True,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Microsecond,8000 Microsecond],Units:>{1,{Microsecond,{Microsecond,Millisecond,Second}}}]
	},
	{
		OptionName->ReadTime,
		Default->Automatic,
		Description->"The amount of time for which the fluorescence measurement reading should occur.",
		AllowNull->True,
		Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Microsecond,10000 Microsecond],Units:>{1,{Microsecond,{Microsecond,Millisecond,Second}}}]
	}
}];


(* ::subSection:: *)
(*IntensityAndKineticsOptions*)


DefineOptionSet[IntensityAndKineticsBaseOptions:>{
	{
		OptionName->Mode,
		Default->Automatic,
		Description->"The type of fluorescence reading which should be performed.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>Fluorescence|TimeResolvedFluorescence]
	},
	{
		OptionName->WavelengthSelection,
		Default->Automatic,
		Description->"Indicates if the emission and excitation wavelengths should be obtained by filters or monochromators.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>WavelengthSelectionP]
	},
	IndexMatching[
		{
			OptionName->ExcitationWavelength,
			Default->Automatic,
			Description->"The wavelength(s) which should be used to excite fluorescence in the samples.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
			Category -> "Optics"
		},
		{
			OptionName->EmissionWavelength,
			Default->Automatic,
			Description->"The wavelength(s) at which fluorescence emitted from the sample should be measured.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
			Category -> "Optics"
		},
		{
			OptionName->DualEmissionWavelength,
			Default->Automatic,
			Description->"The wavelength at which fluorescence emitted from the sample should be measured with the secondary detector (simultaneous to the measurement at the emission wavelength done by the primary detector).",
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
			Category -> "Optics"
		},
		{
			OptionName->Gain,
			Default->Automatic,
			Description->"The gain which should be applied to the signal reaching the primary detector. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
			ResolutionDescription->"If unspecified defaults to 90% if an adjustment sample is provided or if the instrument can scan the entire plate to determine gain. Otherwise defaults to 2500 Microvolt",
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[1 Percent,95 Percent],Units:>Percent],
				Widget[Type->Quantity,Pattern:>RangeP[1 Microvolt,4095 Microvolt],Units:>Microvolt]
			]
		},
		{
			OptionName->DualEmissionGain,
			Default->Automatic,
			Description->"The gain to apply to the signal reaching the secondary detector. This may be specified either as a direct voltage, or as a percentage relative to the AdjustmentSample option.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[1 Percent,95 Percent],Units:>Percent],
				Widget[Type->Quantity,Pattern:>RangeP[1 Microvolt,4095 Microvolt],Units:>Microvolt]
			]
		},
		{
			OptionName->AdjustmentSample,
			Default->Automatic,
			Description->"The sample which should be used to perform automatic adjustments of gain and/or focal height values at run time. The focal height will be set so that the highest signal-to-noise ratio can be achieved for the AdjustmentSample. The gain will be set such that the AdjustmentSample fluoresces at the specified percentage of the instrument's dynamic range. When multiple aliquots of the same sample is used in the experiment, an index can be specified to use the desired aliquot for adjustments. When set to FullPlate, all wells of the assay plate are scanned and the well of the highest fluorescence intensity if perform gain and focal height adjustments.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[FullPlate]],
				Widget[Type->Object,Pattern:>ObjectP[Object[Sample]]],
				{
					"Index"->Widget[Type->Number,Pattern:>RangeP[1,384,1]],
					"Sample"->Widget[Type->Object,Pattern:>ObjectP[Object[Sample]]]
				}
			]
		},
		{
			OptionName->FocalHeight,
			Default->Automatic,
			Description->"The distance from the bottom of the plate carrier to the focal point. If set to Automatic, the focal height will be adjusted based on the Gain adjustment, which will occur only if the gain values are set to percentages.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[0 Millimeter,25 Millimeter],Units:>Millimeter],
				Widget[Type->Enumeration,Pattern:>Alternatives[Auto]]
			]
		},
		IndexMatchingParent->ExcitationWavelength
	],
	TimeResolvedOptions
}];

DefineOptionSet[IntensityAndKineticsOptions:> {
	IntensityAndKineticsBaseOptions,
	FluorescenceOptions
}]
