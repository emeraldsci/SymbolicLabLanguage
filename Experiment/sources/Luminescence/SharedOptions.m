(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

DefineOptionSet[LuminescenceOptions:>
	{
		{
			OptionName->Instrument,
			Default->Automatic,
			Description->"The plate reader used to measure luminescence intensity.",
			ResolutionDescription->"The first plate reader model capable of providing the requested wavelengths is used.",
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Instrument,PlateReader],Object[Instrument,PlateReader]}]],
			Category->"Optics"
		},
		{
			OptionName->IntegrationTime,
			Default->1 Second,
			Description->"The amount of time over which luminescence measurements should be integrated. Select a higher time to increase the reading intensity.",
			AllowNull->True,
			Category->"Optics",
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0.01 Second,100 Second],Units:>{1,{Second,{Microsecond,Millisecond,Second}}}]
		},
		{
			OptionName->ReadLocation,
			Default->Automatic,
			Description->"Indicates if luminescence is measured using an optic above the plate or one below the plate.",
			ResolutionDescription->"Defaults to Bottom if RetainCover is set to True, otherwise defaults to Top.",
			AllowNull->False,
			Category->"Optics",
			Widget->Widget[Type->Enumeration,Pattern:>ReadLocationP]
		},

		{
			OptionName->RetainCover,
			Default->False,
			Description->"Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation. When this option is set to True, injections cannot be performed as it's not possible to inject samples through the cover.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName->Temperature,
			Default->Ambient,
			Description->"The temperature at which the plate reader chamber should be held.",
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Quantity,Pattern:>RangeP[$AmbientTemperature,45 Celsius],Units:>{1,{Celsius,{Celsius,Fahrenheit}}}],
				Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
			],
			Category->"Sample Handling"
		},
		{
			OptionName->EquilibrationTime,
			Default->Automatic,
			Description->"The length of time for which the assay plates should equilibrate at the requested temperature in the plate reader before being read.",
			ResolutionDescription->"Defaults to 0 Second if Temperature is set to Ambient. Otherwise defaults to 5 Minute.",
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[0 Minute,1 Hour],Units:>{1,{Minute,{Second,Minute,Hour}}}],
			Category->"Sample Handling"
		},
		{
			OptionName->TargetCarbonDioxideLevel,
			Default->Automatic,
			Description->"The target amount of carbon dioxide in the atmosphere in the plate reader chamber.",
			ResolutionDescription->"Automatically set to 5% for mammalian cells, and Null otherwise.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.1Percent,20 Percent],
				Units:>{Percent,{Percent}}
			],
			Category->"Sample Handling"
		},
		{
			OptionName->TargetOxygenLevel,
			Default->Null,
			Description->"The target amount of oxygen in the atmosphere in the plate reader chamber. If specified, nitrogen gas is pumped into the chamber to force oxygen in ambient air out of the chamber until the desired level is reached.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.1Percent,20 Percent],
				Units:>{Percent,{Percent}}
			],
			Category->"Sample Handling"
		},
		{
			OptionName->AtmosphereEquilibrationTime,
			Default->Automatic,
			Description->"The length of time for which the samples equilibrate at the requested oxygen and carbon dioxide level before being read.",
			ResolutionDescription->"Automatically set to 5 Minute if TargetCarbonDioxideLevel or TargetOxygenLevel is specified. Otherwise, set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Second, 24 Hour],
				Units:>{1,{Minute,{Second,Minute,Hour}}}
			],
			Category->"Sample Handling"
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
				Description->"The sample to be injected in the first round of injections in order to introduce a time sensitive reagent/sample into the plate before/during luminescence measurement. Set the corresponding times and volumes with PrimaryInjectionTime and PrimaryInjectionVolume. times and volumes with PrimaryInjectionTime and PrimaryInjectionVolume.",
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
				Category->"Sample Handling"
			},
			{
				OptionName->SecondaryInjectionSample,
				Default->Null,
				Description->"The sample to be injected in the second round of injections. Set the corresponding injection times and volumes with SecondaryInjectionTime and SecondaryInjectionVolume.",
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
		{
			OptionName->ReadDirection,
			Default->Row,
			Description->"Indicate the plate path the instrument should follow as it measures luminescence in each well, for instance reading all wells in a row before continuing on to the next row (Row).",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>ReadDirectionP],
			Category->"Sample Handling"
		},
		{
			OptionName->MoatSize,
			Default->Automatic,
			Description->"Indicates the number of concentric perimeters of wells which should be should be filled with MoatBuffer in order to decrease evaporation from the assay samples during the run.",
			ResolutionDescription->"Defaults to 1 if any other moat options are specified.",
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern:>GreaterP[0,1]],
			Category->"Sample Handling"
		},
		{
			OptionName->MoatVolume,
			Default->Automatic,
			Description->"Indicates the volume which should be added to each moat well.",
			ResolutionDescription->"Defaults to the min volume of the assay plate if any other moat options are specified.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterP[0 Microliter],
				Units->Microliter
			],
			Category->"Sample Handling"
		},
		{
			OptionName->MoatBuffer,
			Default->Automatic,
			Description->"Indicates the buffer which should be used to fill each moat well.",
			ResolutionDescription->"Defaults to Milli-Q water if any other moat options are specified.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
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
		BMGSamplingOptions,
		SamplesInStorageOption,
		ModelInputOptions,
		NonBiologyFuntopiaSharedOptions,
		SimulationOption,
		PreparationOption,
		WorkCellOption,
		(* Overwrite ConsolidateAliquots pattern since it can never be set to True for FI/FK *)
		{
			OptionName -> ConsolidateAliquots,
			Default -> Automatic,
			Description -> "Indicates if identical aliquots should be prepared in the same container/position.",
			AllowNull -> True,
			Category -> "Aliquoting",
			Widget -> Widget[Type->Enumeration,Pattern:>Alternatives[False]]
		},
		AnalyticalNumberOfReplicatesOption
	}
];

DefineOptionSet[LuminescenceIntensityAndKineticsOptions:>{
		{
			OptionName->WavelengthSelection,
			Default->Automatic,
			Description->"Indicates if the emission wavelengths should be obtained by filters or monochromators.",
			ResolutionDescription->"Resolves to use filters provided all of the requested wavelengths can be achieved with the current set of filters.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>LuminescenceWavelengthSelectionP],
			Category->"Optics"
		},
		IndexMatching[
			IndexMatchingParent->EmissionWavelength,
			{
				OptionName->EmissionWavelength,
				Default->Automatic,
				Description->"The wavelength(s) at which luminescence emitted from the sample should be measured.",
				ResolutionDescription->"Defaults to NoFilter unless DualEmissionWavelengths are specified.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
					Widget[Type->Enumeration,Pattern:>Alternatives[NoFilter]]
				],
				Category->"Optics"
			},
			{
				OptionName->AdjustmentSample,
				Default->Automatic,
				Description->"The sample which should be used to perform automatic adjustments of gain and/or focal height values at run time. The focal height will be set so that the highest signal-to-noise ratio can be achieved for the AdjustmentSample. The gain will be set such that the AdjustmentSample fluoresces at the specified percentage of the instrument's dynamic range. When multiple aliquots of the same sample is used in the experiment, an index can be specified to use the desired aliquot for adjustments. When set to FullPlate, all wells of the assay plate are scanned and the well of the highest fluorescence intensity if perform gain and focal height adjustments.",
				ResolutionDescription->"Defaults to FullPlate when using an instrument capable of scanning the full plate during gain adjustments (Model[Instrument,PlateReader,\"CLARIOstar\"] or Model[Instrument,PlateReader,\"PHERAstar FS\"]). Otherwise the sample with the highest concentration will be used.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[FullPlate]],
					Widget[Type->Object,Pattern:>ObjectP[Object[Sample]]],
					{
						"Index"->Widget[Type->Number,Pattern:>RangeP[1,384,1]],
						"Sample"->Widget[Type->Object,Pattern:>ObjectP[Object[Sample]]]
					}
				],
				Category->"Optics"
			},
			{
				OptionName->FocalHeight,
				Default->Automatic,
				Description->"The distance from the bottom of the plate carrier to the focal point where light from the sample is directed onto the detector. If set to Auto the height which corresponds to the highest AdjustmentSample signal will be used.",
				ResolutionDescription->"If an adjustment sample is provided the height which corresponds to the highest AdjustmentSample signal will be used (as indicated by Auto). Otherwise defaults to 7 Millimeter.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[0 Millimeter,25 Millimeter],Units:>Millimeter],
					Widget[Type->Enumeration,Pattern:>Alternatives[Auto]]
				],
				Category->"Optics"
			},
			{
				OptionName->Gain,
				Default->Automatic,
				Description->"The gain which should be applied to the signal reaching the primary detector. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample intensity is at the specified percentage of the instrument's dynamic range).",
				ResolutionDescription->"Defaults to 90% if AdjustmentSamples is set or if using Model[Instrument,PlateReader,\"CLARIOstar\"] or Model[Instrument,PlateReader,\"PHERAstar FS\"] which can scan the entire plate and thus don't require an AdjustmentSample to set the gain. Otherwise defaults to 2500 Microvolt.",
				AllowNull->False,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[1 Percent,95 Percent],Units:>Percent],
					Widget[Type->Quantity,Pattern:>RangeP[1 Microvolt,4095 Microvolt],Units:>Microvolt]
				],
				Category->"Optics"
			},
			{
				OptionName->DualEmissionWavelength,
				Default->Automatic,
				Description->"The wavelength at which luminescence emitted from the sample should be measured with the secondary detector (simultaneous to the measurement at the emission wavelength done by the primary detector).",
				ResolutionDescription->"Uses the second emission wavelength provided by the optic module being used.",
				AllowNull->True,
				Widget->Widget[Type->Quantity,Pattern:>RangeP[320 Nanometer,740 Nanometer],Units:>Nanometer],
				Category->"Optics"
			},
			{
				OptionName->DualEmissionGain,
				Default->Automatic,
				Description->"The gain which should be applied to the signal reaching the secondary detector. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample intensity is at the specified percentage of the instrument's dynamic range).",
				ResolutionDescription->"If dual emission readings are requested defaults to 90% if an adjustment sample is provided or if the instrument can scan the entire plate to determine gain. Otherwise defaults to 2500 Microvolt.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern:>RangeP[1 Percent,95 Percent],Units:>Percent],
					Widget[Type->Quantity,Pattern:>RangeP[1 Microvolt,4095 Microvolt],Units:>Microvolt]
				],
				Category->"Optics"
			}
		],
		LuminescenceOptions
	}
]
