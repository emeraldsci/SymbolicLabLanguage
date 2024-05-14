(* ::Section::Closed:: *)
(* AbsorbanceSharedOptions *)

DefineOptionSet[AbsorbanceSharedOptions :> {
	{
		OptionName->Temperature,
		Default->Automatic,
		Description->"Indicates the temperature the samples will held at prior to measuring absorbance and during data acquisition within the instrument.",
		ResolutionDescription->"Sets to Ambient if an instrument is capable of manipulating the temperature of the samples.",
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
		Description->"The length of time for which the samples equilibrate at the requested temperature before being read.",
		ResolutionDescription->"If an instrument is capable setting the temperature of the samples, sets to 0 second when Temperature is set to Ambient. Otherwise, it is set to 5 minutes.",
		AllowNull->True,
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[0 Second, 24 Hour],
			Units:>{1,{Minute,{Second,Minute,Hour}}}
		],
		Category->"Sample Handling"
	},
	{
		OptionName->NumberOfReadings,
		Default->Automatic,
		Description->"Number of redundant readings taken by the detector to determine a single averaged absorbance reading.",
		ResolutionDescription->"If an instrument capable of adjusting NumberOfReadings is selected, resolves to 100. Otherwise resolves to Null",
		AllowNull->True,
		Widget->Widget[Type->Number,Pattern:>RangeP[1,200]],
		Category->"Absorbance Measurement"
	},
	{
		OptionName->ReadDirection,
		Default->Automatic,
		Description->"Indicate the plate path the instrument will follow as it measures absorbance in each well, for instance reading all wells in a row before continuing on to the next row (Row).",
		ResolutionDescription->"Resolves to Row if a plate reader capable of adjusting read direction is selected.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>ReadDirectionP],
		Category->"Absorbance Measurement"
	},
	IndexMatching[
		IndexMatchingInput->"experiment samples",
		(* for manual primitives. *)
		{
			OptionName -> SampleLabel,
			Default -> Automatic,
			Description -> "A user defined word or phrase used to identify the samples that are being measured in absorbance experiments, for use in downstream unit operations.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget->Widget[
				Type->String,
				Pattern:>_String,
				Size->Line
			]
		},
		{
			OptionName -> SampleContainerLabel,
			Default -> Automatic,
			Description -> "A user defined word or phrase used to identify the sample's container that are being measured in absorbance experiments, for use in downstream unit operations.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget->Widget[
				Type->String,
				Pattern:>_String,
				Size->Line
			]
		},
		{
			OptionName->PrimaryInjectionSample,
			Default->Null,
			Description->"The sample to be injected in the first round of injections in order to introduce a time sensitive reagent/sample into the plate before/during absorbance measurement. The corresponding injection times and volumes can be set with PrimaryInjectionTime and PrimaryInjectionVolume.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Category->"Injections"
		},
		{
			OptionName->PrimaryInjectionVolume,
			Default->Null,
			Description->"The amount of the primary sample injected in the first round of injections.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.5 Microliter,300 Microliter],
				Units->Microliter
			],
			Category->"Injections"
		},
		{
			OptionName->SecondaryInjectionSample,
			Default->Null,
			Description->"The sample to be injected in the second round of injections. Set the corresponding injection times and volumes with SecondaryInjectionTime and SecondaryInjectionVolume.",
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Category->"Injections"
		},
		{
			OptionName->SecondaryInjectionVolume,
			Default->Null,
			Description->"The amount of the secondary sample injected in the second round of injections.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.5 Microliter,300 Microliter],
				Units->Microliter
			],
			Category->"Injections"
		}
	],
	{
		OptionName->PrimaryInjectionFlowRate,
		Default->Automatic,
		Description->"The speed at which to transfer injection samples into the assay plate in the first round of injections.",
		ResolutionDescription->"Defaults to 300 Microliter/Second if primary injections are specified.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>BMGFlowRateP],
		Category->"Injections"
	},
	{
		OptionName->SecondaryInjectionFlowRate,
		Default->Automatic,
		Description->"The speed at which to transfer injection samples into the assay plate in the second round of injections.",
		ResolutionDescription->"Defaults to 300 Microliter/Second if secondary injections are specified.",
		AllowNull->True,
		Widget->Widget[Type->Enumeration,Pattern:>BMGFlowRateP],
		Category->"Injections"
	},
	{
		OptionName->InjectionSampleStorageCondition,
		Default->Null,
		Description->"The non-default conditions under which any injection samples used by this experiment are stored after the protocol is completed.",
		AllowNull->True,
		Category->"Injections",
		Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
	},
	{
		OptionName->BlankAbsorbance,
		Default->True,
		Description->"For each members of SamplesIn, indicates if a corresponding blank measurement, which consists of a separate container (well, chamber, or cuvette) than SampleLink, will be performed, prior to measuring the absorbance of samples. If using Cuvettes, the BlankAbsorbance will be read at the same time as the SampleLink.",
		AllowNull->False,
		Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
		Category->"Data Processing"
	},
	IndexMatching[
		{
			OptionName->Blanks,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
			Description->"The object or source used to generate a blank sample (i.e. buffer only, water only, etc.) whose absorbance is subtracted as background from the absorbance readings of the SamplesIn to take accound for any artifacts.",
			ResolutionDescription->"Automatically set to Null if BlankMeasurement is False. Otherwise, automatically set to the value of Solvent in SamplesIn. If Solvent not specfied, set to Model[Sample, \"Milli-Q water\"].",
			Category->"Data Processing"
		},
		{
			OptionName->BlankVolumes,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Quantity,Pattern:>RangeP[1 Microliter,4000*Microliter],Units:>{1,{Microliter,{Microliter,Milliliter}}}],
			Description->"The amount of liquid of the Blank that should be transferred out and used to blank measurements. Set BlankVolume to Null to indicate blanks should be read inside their current containers.",
			ResolutionDescription->"If BlankMeasurement is True, automatically set to the value of AssayVolume if that was specified, or maximum volume of the container otherwise.",
			Category->"Data Processing"
		},
		IndexMatchingInput->"experiment samples"
	],
	BMGSamplingOptions,
	(* SamplingPattern overwrites value in BMGSamplingOptions since here we want to allow Null *)
	{
		OptionName -> SamplingPattern,
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[Type -> Enumeration, Pattern :> PlateReaderSamplingP],
		Description -> "Indicates where in the well measurements are taken.",
		ResolutionDescription->"When using the BMG plate readers, automatically set to Matrix if SamplingDimension is specified or Ring if SamplingDistance is specified. Otherwise set to Center.",
		Category -> "Sampling"
	},
	PlateReaderMixOptions,
	EvaporationOptions,
	FuntopiaSharedOptions,
	SamplesInStorageOptions,
	SimulationOption,
	PreparationOption,
	WorkCellOption,
	BlankLabelOptions,
	{
		OptionName -> NumberOfReplicates,
		Default -> Automatic,
		Description -> "The number of times to repeat absorbance reading on each provided sample. If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted. Note that when using the Lunatic, this indicates the number of independent times a 2 uL aliquot will be put into the Lunatic chips and read, and when using the BMG plate readers, this indicates the number of aliquots of the same sample that will be read.",
		ResolutionDescription -> "When using the BMG plate readers, automatically set to 3 if QuantifyConcentration is True for any experiment sample. When using the Lunatic, automatically set to 3 or 2 depending on the total number of the experiment samples and the blank samples if QuantifyConcentration is True. The total number of samples allowed in one Lunatic run is 94. Otherwise automatically set to Null.",
		AllowNull -> True,
		Widget -> Widget[
			Type -> Number,
			Pattern :> GreaterEqualP[2,1]
		]
	},
	{
		OptionName->LiquidHandler,
		Default->Null,
		AllowNull->True,
		Description->"Indication if this option will be used for ReadPlate primitive on a liquid handler.",
		Widget-> Widget[Type->Enumeration,Pattern:>BooleanP],
		Category->"Hidden"
	}
}];
