(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* Shared Option Sets *)


(* - Shared General and Loading Options - *)
DefineOptionSet[WesSharedLoadingOptions:>{
	(* First, "General" options which are important for the user to see first in command center, even though they could fit into a few separate categories, will be master switches *)
	{
		OptionName->MolecularWeightRange,
		Default->Automatic,
		Description->"The range of protein sizes for which good resolution can be expected in this experiment. LowMolecularWeight corresponds to 2-40 kDa, MidMolecularWeight corresponds to 12-230 kDa, and HighMolecularWeight corresponds to 66-440 kDa. This molecular weight range determines which western assay plate, the specialized plate that is inserted into the western instrument, will be used in the experiment.",
		ResolutionDescription->"In ExperimentWestern, the MolecularWeightRange is automatically set to be MidMolecularWeight if the average Expected MolecularWeight of the input PrimaryAntibodies are between 12 and 120 kDa, LowMolecularweight if between 0 and 12 kDa, and HighMolecularWeight if greater than 120 kDa. In ExperimentTotalProteinDetection, the MolecularWeightRange is automatically set depending on the Ladder option.",
		AllowNull->False,
		Category->"General",
		Widget->Widget[
			Type->Enumeration,
			Pattern:>WesternMolecularWeightRangeP
		]
	},
	{
		OptionName->Instrument,
		Default->Model[Instrument,Western,"Wes"],
		Description->"The Western instrument used for this experiment. The instrument loads the input samples into the capillaries, and performs the sample separation, antibody or biotin labeling reagent incubation, and signal detection after being loaded with a specialized western assay plate containing the input samples, antibodies or biotin labeling reagent, buffers, and other detection reagents.",
		AllowNull->False,
		Category->"General",
		Widget->Widget[
			Type->Object,
			Pattern:>ObjectP[{Object[Instrument,Western],Model[Instrument,Western]}]
		]
	},
	{
		OptionName->NumberOfReplicates,
		Default->Null,
		Description->"The number of capillaries each input sample will be run though. For example, ExperimentFunction[{input2,input2}, NumberOfReplicates->2] is equivalent to ExperimentFunction[{input1,input1,input2,input2}].",
		AllowNull->True,
		Category->"General",
		Widget->Widget[
			Type->Number,
			Pattern:>GreaterEqualP[2,1]
		]
	},
	(* Denaturation *)
	{
		OptionName->Denaturing,
		Default->Automatic,
		Description->"Indicates if the mixture of input samples and prepared master mix will be denatured by heating before preparing the samples for loading. The Denaturation options control the temperature and duration of this denaturation.",
		ResolutionDescription->"The Denaturing is automatically set to False if DenaturingTemperature, DenaturingTime, or Denaturant is specified to be Null. Otherwise, the option is set to True.",
		AllowNull->False,
		Category->"Denaturation",
		Widget->Widget[
			Type->Enumeration,
			Pattern:>BooleanP
		]
	},
	{
		OptionName->DenaturingTemperature,
		Default->Automatic,
		Description->"The temperature which the mixture of input samples and loading buffer will be heated to before being transferred to the western assay plate (the specialized plate that is inserted into the western instrument).",
		ResolutionDescription->"The DenaturingTemperature is automatically set to 95 Celsius if Denaturing is True, and to Null if Denaturing is False.",
		AllowNull->True,
		Category->"Denaturation",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[$AmbientTemperature,95*Celsius],
			Units:>{1,{Celsius,{Fahrenheit,Celsius}}}
		]
	},
	{
		OptionName->DenaturingTime,
		Default->Automatic,
		Description->"The duration which the mixture of input samples and loading buffer will be heated to DenaturingTemperature before being transferred to the western assay plate (the specialized plate that is inserted into the western instrument).",
		ResolutionDescription->"The DenaturingTime is automatically set to 5 minutes if Denaturing is True, and to Null if Denaturing is False.",
		AllowNull->True,
		Category->"Denaturation",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[1*Minute,120*Minute],
			Units:>Minute
		]
	},
	(* Matrix and Sample Loading *)
	{
		OptionName->SeparatingMatrixLoadTime,
		Default->200*Second,
		Description->"The duration for which the separating matrix will be loaded into the capillary. The Matrix and Sample Loading options determine the composition of the matrix inside the capillary, the sample preparation parameters, and the amount of sample loaded into the capillary.",
		AllowNull->False,
		Category->"Matrix & Sample Loading",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[1*Second,300*Second],
			Units:>Second
		]
	},
	{
		OptionName->StackingMatrixLoadTime,
		Default->Automatic,
		Description->"The duration for which the stacking matrix will be loaded into the capillary.",
		ResolutionDescription->"The StackingMatrixLoadTime is automatically set to 15 seconds if the MolecularWeightRange is MidMolecularWeight, and to 12 seconds otherwise.",
		AllowNull->False,
		Category->"Matrix & Sample Loading",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[1*Second,25*Second],
			Units:>Second
		]
	},
	IndexMatching[
		IndexMatchingInput->"experiment samples",
		{
			OptionName->SampleVolume,
			Default->8*Microliter,
			Description->"The amount of each input sample that will be mixed with the LoadingBuffer before the mixture is denatured, and a portion of the mixture, the LoadingVolume, is loaded into the western assay plate (the specialized plate that is inserted into the western instrument).",
			AllowNull->False,
			Category->"Matrix & Sample Loading",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[7*Microliter,10*Microliter],
				Units:>Microliter
			]
		}
	],
	{
		OptionName->ConcentratedLoadingBuffer,
		Default->Automatic,
		Description->"The control protein and sample buffer-containing solution, provided by the instrument supplier, that will be mixed with either the Denaturant or deionized water to make the LoadingBuffer, before a portion of the mixture, the LoadingBufferVolume, is mixed with the SampleVolumes.",
		ResolutionDescription->"The ConcentratedLoadingBuffer is automatically set to be a Simple Western 10X Sample Buffer and Fluorescent Standards Solution from the same kit as the Ladder if the Ladder is set. If the Ladder is not set, the ConcentratedLoadingBuffer is automatically set to be a Simple Western 10X Sample Buffer and Fluorescent Standards Solution which covers the molecular weight span of the MolecularWeightRange.",
		AllowNull->False,
		Category->"Matrix & Sample Loading",
		Widget->Widget[
			Type->Object,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
		]
	},
	{
		OptionName->ConcentratedLoadingBufferVolume,
		Default->40*Microliter,
		Description->"The amount of the ConcentratedLoadingBuffer that will be mixed with either the Denaturant or deionized water, depending on if Denaturing is True or False.",
		ResolutionDescription->"The ConcentratedLoadingBufferVolume is automatically set to be 40 uL.",
		AllowNull->False,
		Category->"Matrix & Sample Loading",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[0*Microliter,40*Microliter],
			Units:>Microliter
		]
	},
	{
		OptionName->Denaturant,
		Default->Automatic,
		Description->"The solution, containing the protein denaturing agent used to denature proteins present in the input samples, that will be mixed with ConcentratedLoadingBuffer to make the LoadingBuffer.",
		ResolutionDescription->"The Denaturant is automatically set to be a Model[Sample,StockSolution,\"Simple Western 400 mM DTT\"] from the same kit as the ConcentratedLoadingBuffer if the ConcentratedLoadingBuffer is set. Otherwise, it automatically resolves to be the 400mM DTT solution from EZ Standard Pack 1, 3 or 5, depending on the MolecularWeightRange.",
		AllowNull->True,
		Category->"Matrix & Sample Loading",
		Widget->Widget[
			Type->Object,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
		]
	},
	{
		OptionName->DenaturantVolume,
		Default->Automatic,
		Description->"The amount of Denaturant that will be mixed with ConcentratedLoadingBuffer.",
		ResolutionDescription->"The DenaturantVolume is automatically set to be Null if the Denaturant is Null, or to 40 uL otherwise.",
		AllowNull->True,
		Category->"Matrix & Sample Loading",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[0*Microliter,40*Microliter],
			Units:>Microliter
		]
	},
	{
		OptionName->WaterVolume,
		Default->Automatic,
		Description->"The amount of deionized water that will be mixed with the ConcentratedLoadingBuffer in lieu of the Denaturant if Denaturing is set to False.",
		ResolutionDescription->"The WaterVolume is automatically set to be 40 uL if Denaturing is False, and Null otherwise.",
		AllowNull->True,
		Category->"Matrix & Sample Loading",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[0*Microliter,40*Microliter],
			Units:>Microliter
		]
	},
	IndexMatching[
		IndexMatchingInput->"experiment samples",
		{
			OptionName->LoadingBufferVolume,
			Default->2*Microliter,
			Description->"The amount of prepared LoadingBuffer (with ConcentratedLoadingBuffer and either Denaturant or deionized water already added) that will be mixed with each input sample before the mixture is denatured, and a portion of the mixture, the LoadingVolume, is loaded into the western assay plate (the specialized plate that is inserted into the western instrument).",
			AllowNull->False,
			Category->"Matrix & Sample Loading",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Microliter,2.5*Microliter],
				Units:>Microliter
			]
		}
	],
	{
		OptionName->LoadingVolume,
		Default->6*Microliter,
		Description->"The amount of each mixture of input sample and LoadingBuffer that will be loaded into the western assay plate after sample denaturation.",
		AllowNull->False,
		Category->"Matrix & Sample Loading",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[5*Microliter,9*Microliter],
			Units:>Microliter
		]
	},
	{
		OptionName->Ladder,
		Default->Automatic,
		Description->"The biotinylated ladder, provided by the instrument supplier, which will be used as a standard reference ladder in the Experiment. After electrophoretic separation, the ladder will be labeled with the LadderPeroxidaseReagent in ExperimentWestern or the PeroxidaseReagent in ExperimentTotalProteinDetection so that each protein band is visible during the signal detection step.",
		ResolutionDescription->"The Ladder is automatically set to be a Simple Western Biotinylated Ladder Solution from the same kit as the ConcentratedLoadingBuffer if the ConcentratedLoadingBuffer is set. If the ConcentratedLoadingBuffer is not set, the Ladder is automatically set to be a Simple Western Biotinylated Ladder Solution which covers the molecular weight span of the MolecularWeightRange. ",
		AllowNull->False,
		Category->"Matrix & Sample Loading",
		Widget->Widget[
			Type->Object,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
		]
	},
	{
		OptionName->LadderVolume,
		Default->7*Microliter,
		Description->"The volume of the Ladder to be aliquotted into its well in the western assay plate (the specialized plate that is inserted into the western instrument).",
		AllowNull->False,
		Category->"Matrix & Sample Loading",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[3*Microliter,10*Microliter],
			Units:>Microliter
		]
	},
	{
		OptionName->SampleLoadTime,
		Default->Automatic,
		Description->"The duration for which the samples and ladder will be loaded into their respective capillaries.",
		ResolutionDescription->"The SampleLoadTime is automatically set to 8 seconds if the MolecularWeightRange is HighMolecularWeight, and to 9 seconds otherwise. For more information on how the SampleLoadTime affects the experiment, please refer to Object[Report, Literature, \"Simple Western Size Assay Development Guide\"].",
		AllowNull->False,
		Category->"Matrix & Sample Loading",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[1*Second,15*Second],
			Units:>Second
		]
	},
	(* Separation *)
	{
		OptionName->Voltage,
		Default->Automatic,
		Description->"The voltage applied during the electrophoretic separation step. The separation and immobilization options set the instrument parameters that control the size-dependent separation of proteins present in the input samples and ladder, and the UV light-induced crosslinking of proteins to the capillary after separation.",
		ResolutionDescription->"The Voltage is automatically set to 475 volts if the MolecularWeightRange is HighMolecularWeight, and to 375 volts otherwise.",
		AllowNull->False,
		Category->"Separation & Immobilization",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[1*Volt,500*Volt,1*Volt],
			Units:>Volt
		]
	},
	{
		OptionName->SeparationTime,
		Default->Automatic,
		Description->"The duration for which the Voltage is applied during electrophoretic sample separation.",
		ResolutionDescription->"The SeparationTime is automatically set to 1620 seconds, 1500 seconds, or 1800 seconds if the MolecularWeightRange is set to LowMolecularWeight, MidMolecularWeight, or HighMolecularWeight, respectively. For more information on how the SeparationTime affects the experiment, please refer to Object[Report, Literature, \"Simple Western Size Assay Development Guide\"].",
		AllowNull->False,
		Category->"Separation & Immobilization",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[1*Second,3600*Second],
			Units:>Second
		]
	},
	{
		OptionName->UVExposureTime,
		Default->Automatic,
		Description->"The duration for which the capillary will be exposed to UV-light for protein cross-linking to the capillary.",
		ResolutionDescription->"The UVExposureTime is automatically set to 150 seconds if the MolecularWeightRange is HighMolecularWeight, and to 200 seconds otherwise.",
		AllowNull->False,
		Category->"Separation & Immobilization",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[1*Second,400*Second],
			Units:>Second
		]
	},
	{
		OptionName->WashBuffer,
		Default->Model[Sample,"Simple Western Wash Buffer"],
		Description->"The buffer that will be incubated with the capillary between blocking and labeling steps to remove excess reagents.",
		AllowNull->False,
		Category->"Separation & Immobilization",
		Widget->Widget[
			Type->Object,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
		]
	},
	{
		OptionName->WashBufferVolume,
		Default->500*Microliter,
		Description->"The amount of WashBuffer to be loaded into each of the 15 appropriate wells of the western assay plate (the specialized plate that is inserted into the western instrument).",
		AllowNull->False,
		Category->"Separation & Immobilization",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[250*Microliter,500*Microliter],
			Units:>Microliter
		]
	}
}];

(* - Shared Imaging Options - *)
DefineOptionSet[WesSharedImagingOptions:>{
	(* Imaging *)
	{
		OptionName->LuminescenceReagent,
		Default->Automatic,
		Description->"The solution, which defaults to a mixture of luminol and peroxide, that reacts with the horseradish peroxidase (HRP) attached to the SecondaryAntibody in ExperimentWestern or the PeroxidaseReagent in ExperimentTotalProteinLabeling to give off chemiluminesence which is observed during the SignalDetectionTimes.",
		ResolutionDescription->"In ExperimentWestern, the LuminescenceReagent is automatically set to Model[Sample,StockSolution,\"SimpleWestern Luminescence Reagent\"]. In ExperimentTotalProteinDetection, the LuminescenceReagent is automatically set to Model[Sample,StockSolution,\"SimpleWestern Luminescence Reagent - Total Protein Kit\"].",
		AllowNull->False,
		Category->"Imaging",
		Widget->Widget[
			Type->Object,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
		]
	},
	{
		OptionName->LuminescenceReagentVolume,
		Default->15*Microliter,
		Description->"The amount of the LuminescenceReagent that will be aliquotted into each of the 25 appropriate wells of the western assay plate (the specialized plate that is inserted into the western instrument). The LuminescenceReagent reacts with the horseradish peroxidase (HRP) attached to the SecondaryAntibody in ExperimentWestern or the PeroxidaseReagent in ExperimentTotalProteinLabeling to give off chemiluminesence which is observed during the SignalDetectionTimes.",
		AllowNull->False,
		Category->"Imaging",
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[5*Microliter,15*Microliter],
			Units:>Microliter
		]
	},
	{
		OptionName->SignalDetectionTimes,
		Default->{1*Second,2*Second,4*Second,8*Second,16*Second,32*Second,64*Second,128*Second,512*Second},
		Description->"The list of (9) exposure times in seconds for chemiluminescent signal. It is highly recommended to leave the SignalDetectionTimes as the default times, as these are the only times from which the High Dynamic Range (HDR) Detection Profile can be calculated. The HDR Detection Profile increases the dynamic range of the experiment by two orders of magnitude.",
		AllowNull->False,
		Category->"Imaging",
		Widget->List[
			"First Exposure"->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,512*Second],
				Units:>Second
			],
			"Second Exposure"->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,512*Second],
				Units:>Second
			],
			"Third Exposure"->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,512*Second],
				Units:>Second
			],
			"Fourth Exposure"->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,512*Second],
				Units:>Second
			],
			"Fifth Exposure"->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,512*Second],
				Units:>Second
			],
			"Sixth Exposure"->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,512*Second],
				Units:>Second
			],
			"Seventh Exposure"->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,512*Second],
				Units:>Second
			],
			"Eighth Exposure"->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,512*Second],
				Units:>Second
			],
			"Ninth Exposure"->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,512*Second],
				Units:>Second
			]
		]
	}
}];



(* ::Subsection:: *)
(* ExperimentTotalProteinDetection *)


(* ::Subsubsection:: *)
(* ExperimentTotalProteinDetection Options *)


DefineOptions[ExperimentTotalProteinDetection,
	Options:>{
		WesSharedLoadingOptions,
		(* Total Protein Labeling *)
		{
			OptionName->LabelingReagent,
			Default->Model[Sample,StockSolution,"Simple Western Total Protein Labeling Solution - Total Protein Kit"],
			Description->"The biotin-containing reagent used to label all proteins present in the input sample(s) The Total Protein Labeling Options describe the biotin and streptavidin-HRP labeling of the protein population present in the input sample(s).",
			AllowNull->False,
			Category->"Total Protein Labeling",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},
		{
			OptionName->LabelingReagentVolume,
			Default->10*Microliter,
			Description->"The amount of LabelingReagent that will be aliquotted into each appropriate well of the western assay plate (the specialized plate that is inserted into the western instrument).",
			AllowNull->False,
			Category->"Total Protein Labeling",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[5*Microliter,11*Microliter],
				Units:>Microliter
			]
		},
		{
			OptionName->LabelingTime,
			Default->1800*Second,
			Description->"The duration for which the capillary is incubated with the LabelingReagent.",
			AllowNull->False,
			Category->"Total Protein Labeling",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Second,7200*Second],
				Units:>Second
			]
		},
		{
			OptionName->BlockingBuffer,
			Default->Model[Sample,"Simple Western Antibody Diluent 2 - Total Protein Kit"],
			Description->"The buffer to be incubated with the capillary after LabelingWashTime.",
			AllowNull->False,
			Category->"Total Protein Labeling",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},
		{
			OptionName->BlockingBufferVolume,
			Default->10*Microliter,
			Description->"The amount of BlockingBuffer that will be aliquotted into the appropriate wells of the western assay plate (the specialized plate that is inserted into the western instrument).",
			AllowNull->False,
			Category->"Total Protein Labeling",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[5*Microliter,20*Microliter],
				Units:>Microliter
			]
		},
		{
			OptionName->LadderBlockingBuffer,
			Default->Model[Sample,"Simple Western Antibody Diluent 2 - Total Protein Kit"],
			Description->"The buffer that will be incubated with the capillary containing the Ladder during both the LabelingTime and the BlockingTime.",
			AllowNull->False,
			Category->"Blocking",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},
		{
			OptionName->LadderBlockingBufferVolume,
			Default->10*Microliter,
			Description->"The amount of LadderBlockingBuffer that will be aliquotted into each of the two appropriate wells of the western assay plate (the specialized plate that is inserted into the western instrument).",
			AllowNull->False,
			Category->"Blocking",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Microliter,20*Microliter],
				Units:>Microliter
			]
		},
		{
			OptionName->BlockingTime,
			Default->1800*Second,
			Description->"The duration of the BlockingBuffer incubation after the LabelingWashTime.",
			AllowNull->False,
			Category->"Total Protein Labeling",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Second,7200*Second],
				Units:>Second
			]
		},
		{
			OptionName->PeroxidaseReagent,
			Default->Model[Sample,"Simple Western Total Protein Streptavidin-HRP - Total Protein Kit"],
			Description->"The sample or model of streptavidin-containing HRP solution which will bind to proteins that have been labeled with biotin and the biotinylated ladder.",
			AllowNull->False,
			Category->"Total Protein Labeling",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},
		{
			OptionName->PeroxidaseReagentStorageCondition,
			Default->Null,
			Description->"The non-default storage condition under which the PeroxidaseReagent of this experiment should be stored after the protocol is completed. If left unset, the PeroxidaseReagent will be stored according to its current StorageCondition.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
			],
			Category->"Total Protein Labeling"
		},
		{
			OptionName->PeroxidaseReagentVolume,
			Default->8*Microliter,
			Description->"The amount of PeroxidaseReagent that will be added to the appropriate well(s) of the western assay plate (the specialized plate that is inserted into the western instrument).",
			AllowNull->False,
			Category->"Total Protein Labeling",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[5*Microliter,100*Microliter],
				Units:>Microliter
			]
		},
		{
			OptionName->PeroxidaseIncubationTime,
			Default->1800*Second,
			Description->"The duration for which the capillary is incubated with the PeroxidaseReagent.",
			AllowNull->False,
			Category->"Total Protein Labeling",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Second,7200*Second],
				Units:>Second
			]
		},
		WesSharedImagingOptions,
		FuntopiaSharedOptions,
		SamplesInStorageOptions,
		SubprotocolDescriptionOption
	}
];



(* ::Subsubsection:: *)
(* TotalProteinDetection and Western Messages *)
(* Messages before the option resolution *)


Error::TooManyInputsForWes="The maximum number of input samples for one protocol is 24. Please enter fewer input samples, or queue an additional experiment for the excess input samples.";
Error::NumberOfReplicatesTooHighForNumberOfWesInputSamples="There are `1` input samples, and NumberOfReplicates is set to `2`. The product of the number of input samples and the NumberOfReplicates option cannot be larger than 24. Please reduce either the NumberOfReplicates or the number of input samples.";
Warning::WesTotalProteinConcentrationNotInformed="The following primary input, `1`, does not have TotalProteinConcentration informed. TotalProteinConcentration is required to determine if the input samples are too concentrated.";
Error::WesOptionVolumeTooLow="The following members of `1`, `2`, are invalid. The `1` volume cannot be between 0 and `3`. Please set these values above the limit, or consider letting this option automatically resolve.";
Error::ConflictingWesDenaturingOptions="The following Denaturing-related options are in conflict and cannot be resolved, `1`. Please make sure Denaturing, DenaturingTemperature, and DenaturingTime are set correctly, or consider allowing these options to automatically resolve.";
Error::ConflictingWesSystemStandardOptions="The provided SystemStandard-related options, `1`, are in conflict with each other and cannot be resolved. Please consider only setting SystemStandard and letting the other options automatically resolve.";
Error::ConflictingWesNullOptions="The following options, `1`, cannot be resolved, as one member is Null and its corresponding option is set to a value other than Null or Automatic. Please consider allowing these options to automatically resolve.";
Error::WesternLoadingVolumeTooLarge="For the following input samples, `1`, the LoadingVolume is larger than the sum of the SampleVolume and the LoadingBufferVolume. Please consider leaving these options as their default values.";
Error::ConflictingWesternAntibodyDiluentOptions="The PrimaryAntibodyDilutionFactor is set to 1, but either the PrimaryAntibodyDiluent or PrimaryAntibodyDiluentVolume option has been set to a value other than Automatic or Null for the following inputs, `1`. Please consider setting the PrimaryAntibodyDilutionFactor and letting the related options automatically resolve.";
(* Messages during option resolution *)
Warning::WesHighDynamicRangeImagingNotPossible="Since the user-supplied SignalDetectionTimes, `1`, are not the default values, High Dynamic Range (HDR) image processing is not possible. If this is not desired, please leave the SignalDetectionTimes as their default values, {1*Second,2*Second,4*Second,8*Second,16*Second,32*Second,64*Second,128*Second,512*Second}.";
Warning::NonOptimalUserSuppliedWesMolecularWeightRange="The user-supplied MolecularWeightRange option, `1`, is not optimal for the average ExpectedMolecularWeight of the input antibodies, `2`. Please double check that the MolecularWeightRange option and antibody inputs are set as desired.";
Warning::WesLadderNotOptimalForMolecularWeightRange="The user-supplied Ladder option, `1`, is not optimal for the MolecularWeightRange option, `2`. Use of a non-default Ladder will lead to instrument and data miscalibration. Please consider allowing the Ladder option to automatically resolve.";
Warning::WesWashBufferNotOptimal="The user-supplied WashBuffer option, `1`, is not optimal for the Experiment and may lead to non-optimal labeling and signal detection. Please consider using the default WashBuffer, Model[Sample,\"Simple Western Wash Buffer\"].";
Warning::WesConcentratedLoadingBufferNotOptimal="The user-supplied ConcentratedLoadingBuffer option, `1`, is not optimal for the MolecularWeightRange option, `2`. Use of a non-default ConcentratedLoadingBuffer will lead to instrument and data miscalibration. Please consider allowing the ConcentratedLoadingBuffer option to automatically resolve.";
(* Messages after option resolution *)
Warning::WesternPrimaryAntibodyVolumeLarge="The following resolved or user-supplied PrimaryAntibodyVolumes, `1`, are 4 uL or larger. To conserve PrimaryAntibody, consider lowering the PrimaryAntibodyVolume and PrimaryAntibodyDiluentVolumes, `2`, while preserving the ratio between them. Alternatively, consider using the PreparatoryUnitOperations option to pre-dilute the PrimaryAntibody to the desired concentration, and set the PrimaryAntibodyDilutionFactor to 1.";
Error::InvalidWesternDilutedPrimaryAntibodyVolume="The sum of the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, and StandardPrimaryAntibodyVolumes, `1`, is not between 35 and 275 uL for the following pairs of input samples and antibodies, `2`. Please ensure that the sum of these volumes is between 35 and 270 uL, or consider letting these options automatically resolve.";
Error::NotEnoughWesLoadingBuffer="The experiment requires `1` of LoadingBuffer, but the sum of the ConcentratedLoadingBuffer, DenaturantVolume, and WaterVolume options is only `2`. Please consider letting these options all automatically resolve.";
Warning::NonIdealWesternSecondaryAntibody="The following SecondaryAntibodies, `1`, are not the ideal SecondaryAntibodies for the Organism of the PrimaryAntibody of the following pairs of input samples and antibodies, `2`. Please consider letting the SecondaryAntibody option automatically resolve.";
Warning::NonIdealWesternStandardPrimaryAntibody="The following StandardPrimaryAntibodies, `1`, are not the ideal StandardPrimaryAntibodies for the Organism of the PrimaryAntibody of the following pairs of input samples and antibodies, `2`. Please consider letting the StandardPrimaryAntibody option automatically resolve.";
Warning::NonIdealWesternStandardSecondaryAntibody="The following StandardSecondaryAntibodies, `1`, are not the ideal StandardSecondaryAntibodies for the StandardPrimaryAntibody and the Organism of the PrimaryAntibody of the following pairs of input samples and antibodies, `2`. Please consider letting the StandardSecondaryAntibody option automatically resolve.";
Warning::NonIdealWesternBlockingBuffer="The following BlockingBuffers, `1`, are not the ideal BlockingBuffers for the Organism of the PrimaryAntibody of the following pairs of input samples and antibodies, `2`. Please consider letting the BlockingBuffer option automatically resolve.";
Warning::NonIdealWesternPrimaryAntibodyDiluent="The following user-supplied PrimaryAntibodyDiluents, `1`, are not the ideal PrimaryAntibodyDiluents for the Organism of the PrimaryAntibody of the following pairs of input samples and antibodies, `2`. Please consider letting the PrimaryAntibodyDiluent option automatically resolve.";
Warning::WesternSecondaryAntibodyVolumeLow="The sum of the SecondaryAntibodyVolume and StandardSecondaryAntibodyVolume, `1`, is less than the ideal 10 uL for the following pairs of input samples and antibodies, `2`. Please consider letting the SecondaryAntibodyVolume and StandardSecondaryAntibodyVolume options automatically resolve, or making sure that the sum of these two volumes is at least 10 uL.";
Warning::WesternStandardPrimaryAntibodyVolumeRatioNonIdeal="For the following pairs of input samples and antibodies, `1`, the StandardPrimaryAntibodyVolume, `2`, is not between 7-13% of the sum of the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, and the StandardPrimaryAntibodyVolume, `3`. Please consider letting these options automatically resolve.";
Error::ConflictingWesternPrimaryAntibodyDilutionFactorOptions="For the following pairs of input samples and antibodies, `1`, the PrimaryAntibodyDilutionFactor, `2`, is not equal to the DilutionFactor calculated by taking the ratio of the PrimaryAntibodyVolume to the sum of the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, and StandardPrimaryAntibodyVolume, `3`, when each is rounded to the thousandths place. Please consider only setting the PrimaryAntibodyDilutionFactor and the PrimaryAntibodyVolume, and letting the other options automatically resolve.";
Warning::WesInputsShouldBeDiluted="The following inputs, `1`, have TotalProteinConcentrations greater than 3 mg/mL and are not being diluted with the aliquot sample preparation options. It is highly recommended that lysate samples be diluted with Model[Sample,StockSolution,\"Simple Western 0.1X Sample Buffer\"] to a TotalProteinConcentration below 2-3 mg/mL, or the amount of sample loaded into the capillary will be too large and data will be adversely affected.";
Error::WesConflictingStandardPrimaryAntibodyStorageOptions="The following inputs, `1`, have a StandardPrimaryAntibody of Null, but a StandardPrimaryAntibodyStorageCondition which is not Null. Please ensure that these options are not in conflict.";
Error::WesConflictingStandardSecondaryAntibodyStorageOptions="The following inputs, `1`, have a StandardSecondaryAntibody of Null, but a StandardSecondaryAntibodyStorageCondition which is not Null. Please ensure that these options are not in conflict.";

(* ::Subsubsection:: *)
(* ExperimentTotalProteinDetection Source Code *)


(* - Container to Sample Overload - *)

ExperimentTotalProteinDetection[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,
		containerToSampleResult,containerToSampleOutput,updatedCache,samples,sampleOptions,containerToSampleTests,sampleCache},

(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
	(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentTotalProteinDetection,
			ToList[myContainers],
			ToList[myOptions]
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
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
			ExperimentTotalProteinDetection,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests},
			Cache->samplePreparationCache
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

	(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			containerToSampleOutput=containerToSampleOptions[
				ExperimentTotalProteinDetection,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->Result,
				Cache->samplePreparationCache
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* Update our cache with our new simulated values. *)
	updatedCache=Flatten[{
		samplePreparationCache,
		Lookup[listedOptions,Cache,{}]
	}];

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
		{samples,sampleOptions, sampleCache}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentTotalProteinDetection[samples,ReplaceRule[sampleOptions,Cache->Flatten[{updatedCache,sampleCache}]]]
	]
];

(* - Main Sample Overload - *)

ExperimentTotalProteinDetection[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,messages,listedSamples,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,
		safeOps,safeOpsTests,validLengths,validLengthTests,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed,samplePreparationCacheNamed,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,totalProteinDetectionOptionsAssociation,ladderOption,washBufferOption,concentratedLoadingBufferOption,
		instrumentOption,blockingBufferOption,ladderDownloadFields,
		washBufferDownloadFields,concentratedLoadingBufferDownloadFields,listedBlockingBuffer,uniqueBlockingBufferObjects,uniqueBlockingBufferModels,objectSamplePacketFields,modelSamplePacketFields,
		objectContainerFields,modelContainerFields,modelContainerPacketFields,samplesContainerModelPacketFields,liquidHandlerContainers,
		listedSampleContainerPackets,listedModelInstrumentPackets,listedLadderOptionPackets,listedWashBufferOptionPackets,listedConcentratedLoadingBufferOptionPackets,
		listedBlockingBufferObjectPackets,listedBlockingBufferModelPackets,objectsInOrder,liquidHandlerContainerPackets,cacheBall,inputObjects,
		resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Remove temporal links and named objects. *)
	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
	(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed}=simulateSamplePreparationPackets[
			ExperimentTotalProteinDetection,
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
		SafeOptions[ExperimentTotalProteinDetection,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentTotalProteinDetection,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Sanitize the samples and options using sanitizInput funciton*)
	{mySamplesWithPreparedSamples, {safeOps, myOptionsWithPreparedSamples, samplePreparationCache}} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, {safeOpsNamed, myOptionsWithPreparedSamplesNamed, samplePreparationCacheNamed}];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentTotalProteinDetection,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentTotalProteinDetection,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
		ApplyTemplateOptions[ExperimentTotalProteinDetection,{ToList[mySamplesWithPreparedSamples]},ToList[myOptionsWithPreparedSamples],Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentTotalProteinDetection,{ToList[mySamplesWithPreparedSamples]},ToList[myOptionsWithPreparedSamples]],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentTotalProteinDetection,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Turn the expanded safe ops into an association so we can lookup information from it*)
	totalProteinDetectionOptionsAssociation=Association[expandedSafeOps];

	(* Pull the info out of the options that we need to download from*)
	{ladderOption,washBufferOption,concentratedLoadingBufferOption,instrumentOption,blockingBufferOption}
		=Lookup[totalProteinDetectionOptionsAssociation,{Ladder,WashBuffer,ConcentratedLoadingBuffer,Instrument,BlockingBuffer}];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
	(* - Ladder Option - *)
	ladderDownloadFields=Switch[ladderOption,
		ObjectP[Object[Sample]],
			Packet[Model[{Name}]],
		ObjectP[Model[Sample]],
			Packet[],
		_,
			{}
	];

	(* - WashBuffer Option - *)
	washBufferDownloadFields=Switch[washBufferOption,
		ObjectP[Object[Sample]],
			Packet[Model[{Name}]],
		ObjectP[Model[Sample]],
			Packet[],
		_,
			{}
	];

	(* - ConcentratedLoadingBuffer Option - *)
	concentratedLoadingBufferDownloadFields=Switch[concentratedLoadingBufferOption,
		ObjectP[Object[Sample]],
			Packet[Model[{Name}]],
		ObjectP[Model[Sample]],
			Packet[],
		_,
			{}
	];

	(* - BlockingBuffer Option- *)
	listedBlockingBuffer=ToList[blockingBufferOption];
	uniqueBlockingBufferObjects=DeleteDuplicates[Cases[ToList[listedBlockingBuffer],ObjectP[Object]]];
	uniqueBlockingBufferModels=DeleteDuplicates[Cases[ToList[listedBlockingBuffer],ObjectP[Model]]];

	(* - Determine which fields we need to download from the input Objects - *)
	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{TotalProteinConcentration,IncompatibleMaterials,RequestedResources,SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerFields=SamplePreparationCacheFields[Object[Container]];
	modelContainerFields=SamplePreparationCacheFields[Model[Container]];
	modelContainerPacketFields=Packet@@Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];
	samplesContainerModelPacketFields=Packet[Container[Model[Flatten[{Object,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container]]}]]]];

	(* - All liquid handler compatible containers (for resources and Aliquot) - *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* - Big download call - *)
	{
		listedSampleContainerPackets,listedModelInstrumentPackets,listedLadderOptionPackets,listedWashBufferOptionPackets,listedConcentratedLoadingBufferOptionPackets,
		listedBlockingBufferObjectPackets,listedBlockingBufferModelPackets,objectsInOrder,liquidHandlerContainerPackets
	}=Quiet[
		Download[
			{
				ToList[mySamplesWithPreparedSamples],
				{instrumentOption},
				{(ladderOption/.{Automatic->Null})},
				{(washBufferOption/.{Automatic->Null})},
				{(concentratedLoadingBufferOption/.{Automatic->Null})},
				uniqueBlockingBufferObjects,
				uniqueBlockingBufferModels,
				ToList[mySamples],
				liquidHandlerContainers
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Container[objectContainerFields]],
					Packet[Container[Model][modelContainerFields]],
					Packet[Composition[[All,2]][MolecularWeight]],
					Packet[Container[{Model, Contents, Name, Status, Sterile, TareWeight,RequestedResources}]],
					samplesContainerModelPacketFields
				},
				{Packet[Model, Status, WettedMaterials]},
				{ladderDownloadFields},
				{washBufferDownloadFields},
				{concentratedLoadingBufferDownloadFields},
				(* BlockingBuffer fields *)
				{Packet[Model[{Name}]]},
				{Packet[]},
				(* input objects *)
				{Packet[Object]},
				{modelContainerPacketFields}
			},
			Cache->Flatten[{Lookup[expandedSafeOps,Cache,{}],samplePreparationCache}],
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	cacheBall=FlattenCachePackets[
		{
			samplePreparationCache,listedSampleContainerPackets,listedModelInstrumentPackets,listedLadderOptionPackets,listedWashBufferOptionPackets,listedConcentratedLoadingBufferOptionPackets,
			listedBlockingBufferObjectPackets,listedBlockingBufferModelPackets,liquidHandlerContainerPackets
		}
	];

	(* Get a list of the inputs by ID *)
	inputObjects=Lookup[Flatten[objectsInOrder],Object];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveWesExperimentOptions[inputObjects,{},expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveWesExperimentOptions[inputObjects,{},expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentTotalProteinDetection,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentTotalProteinDetection,collapsedResolvedOptions],
			Preview->Null
		}]
	];


	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		wesResourcePackets[inputObjects,{},templatedOptions,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{wesResourcePackets[inputObjects,{},templatedOptions,resolvedOptions,Cache->cacheBall,Output->Result],{}}
	];


	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentTotalProteinDetection,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			ConstellationMessage->Object[Protocol,TotalProteinDetection],
			Cache->cacheBall
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentTotalProteinDetection,collapsedResolvedOptions],
		Preview -> Null
	}
];



(* ::Subsection:: *)
(* resolveWesExperimentOptions *)


DefineOptions[
	resolveWesExperimentOptions,
	Options:>{HelperOutputOption,CacheOption}
];

resolveWesExperimentOptions[mySamples:{ObjectP[Object[Sample]]...},myAntibodies:ListableP[ObjectP[{Object[Sample], Model[Sample]}]]|{},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveWesExperimentOptions]]:=Module[
	{
		totalProteinDetectionSpecificOptions,westernSpecificOptions,westernQ,outputSpecification,output,gatherTests,messages,notInEngine,cache,samplePrepOptions,experimentOptions,simulatedSamples,resolvedSamplePrepOptions,
		simulatedCache,experimentOptionsAssociation,suppliedInstrument,numberOfReplicates,suppliedDenaturing,suppliedDenaturingTemperature,suppliedDenaturingTime,
		suppliedName,suppliedSystemStandard,suppliedStandardPrimaryAntibody,suppliedStandardPrimaryAntibodyVolume,suppliedStandardSecondaryAntibody,suppliedStandardSecondaryAntibodyVolume,
		suppliedPrimaryAntibodyDiluent,suppliedPrimaryAntibodyDiluentVolume,suppliedMolecularWeightRange,suppliedLadder,suppliedLadderVolume,suppliedSeparatingMatrixLoadTime,suppliedStackingMatrixLoadTime,
		suppliedSampleLoadTime,suppliedVoltage,suppliedSeparationTime,suppliedUVExposureTime,suppliedBlockingBufferVolume,suppliedBlockingTime,suppliedWashBuffer,suppliedWashBufferVolume,suppliedConcentratedLoadingBuffer,
		suppliedConcentratedLoadingBufferVolume,suppliedDenaturant,suppliedDenaturantVolume,suppliedWaterVolume,suppliedLabelingReagent,suppliedLabelingReagentVolume,suppliedLabelingTime,suppliedBlockingBuffer,
		suppliedPeroxidaseReagent,suppliedPeroxidaseReagentVolume,suppliedPeroxidaseIncubationTime,suppliedPrimaryIncubationTime,suppliedLadderPeroxidaseReagent,suppliedLadderPeroxidaseReagentVolume,
		suppliedSecondaryIncubationTime,suppliedSecondaryAntibodies,suppliedLadderBlockingBuffer,suppliedLuminescenceReagent,
		suppliedPeroxidaseReagentStorageCondition,suppliedPrimaryAntibodyStorageCondition,suppliedStandardPrimaryAntibodyStorageCondition,
		suppliedSecondaryAntibodyStorageCondition,suppliedStandardSecondaryAntibodyStorageCondition,suppliedLadderPeroxidaseStorageCondition,
		suppliedSamplesInStorageCondition,suppliedPrimaryAntibodyLoadingVolume,suppliedSampleVolume,suppliedLoadingBufferVolume,
		suppliedLoadingVolume,suppliedPrimaryAntibodyDilutionFactor,suppliedSignalDetectionTimes,roundedPrimaryAntibodyDiluentVolumes,roundedStandardPrimaryAntibodyVolumes,roundedStandardSecondaryAntibodyVolumes,
		primaryAntibodyDiluentVolumesOnlyVolumes,standardPrimaryAntibodyVolumesOnlyVolumes,standardSecondaryAntibodyVolumesOnlyVolumes,invalidPrimaryAntibodyDiluentVolumes,
		validPrimaryAntibodyDiluentVolumes,invalidPrimaryAntibodyDiluentVolumeOption,invalidPrimaryAntibodyDiluentVolumeTests,
		invalidStandardPrimaryAntibodyVolumes,validStandardPrimaryAntibodyVolumes,invalidStandardPrimaryAntibodyVolumeOption,invalidStandardPrimaryAntibodyVolumeTests,
		invalidStandardSecondaryAntibodyVolumes,validStandardSecondaryAntibodyVolumes,invalidStandardSecondaryAntibodyVolumeOption,invalidStandardSecondaryAntibodyVolumeTests,
		suppliedLadderBlockingBufferVolume,ladderDownloadFields,washBufferDownloadFields,concentratedLoadingBufferDownloadFields,uniqueSecondaryAntibodyObjects,uniqueSecondaryAntibodyModels,
		uniqueStandardPrimaryAbObjects,uniqueStandardPrimaryAbModels,uniqueStandardSecondaryAbObjects,uniqueStandardSecondaryAbModels,listedBlockingBuffer,uniqueBlockingBufferObjects,
		uniqueBlockingBufferModels,uniquePrimaryAntibodyDiluentObjects,uniquePrimaryAntibodyDiluentModels,primaryAntibodyObjectInputs,primaryAntibodyModelInputs,objectSamplePacketFields,modelSamplePacketFields,
		modelContainerPacketFields,samplesContainerModelPacketFields,liquidHandlerContainers,
		listedSampleContainerPackets,listedAntibodyObjectInputPackets,listedModelInstrumentPackets,listedLadderOptionPackets,listedWashBufferOptionPackets,listedConcentratedLoadingBufferOptionPackets,
		listedSecondaryAbObjectPackets,listedSecondaryAbModelPackets,listedStandardPrimaryAbObjectPackets,listedStandardPrimaryAbModelPackets,listedStandardSecondaryAbObjectPackets,
		listedStandardSecondaryAbModelPackets,listedBlockingBufferObjectPackets,listedBlockingBufferModelPackets,listedPrimaryAntibodyDiluentObjectPackets,listedPrimaryAntibodyDiluentModelPackets,
		listedPrimaryAntibodyCompositionPackets,liquidHandlerContainerPackets,
		primaryAntibodyDiluentObjectReplaceRules,primaryAntibodyDiluentModelReplaceRules,primaryAntibodyDiluentReplaceRules,primaryAbDiluentModels,
		samplePackets,sampleModelPackets,sampleComponentPackets,sampleContainerPackets,antibodyObjectInputObjectPackets,antibodyObjectInputModelPackets,
		primaryAntibodyComponentsPackets,primaryAntibodyComponentsTargetPackets,primaryAntibodyComponentsPacketsNoNull,primaryAntibodyMoleculeRecommendedDilutionPackets,primaryAntibodyRecommendedDilutions,
		primaryAntibodyMoleculeOrganismPackets,primaryAntibodyOrganisms,allTargetPackets,allMolecularWeightPackets,averageTargetMolecularWeight,
		instrumentPacket,ladderOptionPacket,washBufferOptionPacket,concentratedLoadingBufferOptionPacket,
		secondaryAbObjectPacketModels,secondaryAbModelPacketModels,secondaryAbObjectReplaceRules,secondaryAbModelReplaceRules,secondaryAbReplaceRules,secondaryAbModels,
		standardPrimaryAbObjectPacketModels,standardPrimaryAbModelPacketModels,standardPrimaryAbObjectReplaceRules,standardPrimaryAbModelReplaceRules,standardPrimaryAbReplaceRules,
		standardPrimaryAbModels,standardSecondaryAbObjectPacketModels,standardSecondaryAbModelPacketModels,standardSecondaryAbObjectReplaceRules,standardSecondaryAbModelReplaceRules,
		standardSecondaryAbReplaceRules,standardSecondaryAbModels,blockingBufferObjectPacketModels,blockingBufferModelPacketModels,blockingBufferObjectReplaceRules,
		blockingBufferModelReplaceRules,blockingBufferReplaceRules,blockingBufferModels,primaryAntibodyDiluentObjectPacketModels,primaryAntibodyDiluentModelPacketModels,
		discardedSamplePackets,discardedAntibodyPackets,
		discardedInputPackets,discardedInvalidInputs,discardedTests,simulatedSampleContainers,validSamplesInStorageBools,samplesInStorageTests,
		invalidSamplesInStorageConditionOptions,tooManyInvalidInputs,tooManyInputsTests,
		totalProteinConcList,missingTotalProteinLysates,
		informedTotalProteinLysates,missingTotalProteinConcentrationTests,
		sharedOptionPrecisions,westernOptionPrecisions,totalProteinDetectionOptionPrecisions,
		roundedExperimentOptions,optionPrecisionTests,roundedExperimentOptionsList,allOptionsRounded,validNameQ,nameInvalidOption,validNameTest,compatibleMaterialsBool,compatibleMaterialsTests,compatibleMaterialsInvalidOption,
		intNumberOfReplicates,numberOfSamples,numberOfSampleCapillaries,smallCartridgeQ,numberOfReplicatesInvalidOption,
		numberOfReplicatesTests,invalidDenaturingOptions,conflictingDenaturingOptionsTests,conflictingSystemStandardOptionsQ,
		invalidSystemStandardOptions,conflictingSystemStandardOptionsTests,conflictingNullPrimaryAntibodyDiluentOptionsQ,conflictingNullStandardSecondaryAntibodyOptionsQ,
		invalidConflictingNullOptions,validConflictingNullOptions,conflictingNullOptionsTests,expandedLoadingVolume,loadingVolumeTooLargeSamples,loadingVolumeFineSamples,invalidLoadingVolumeOptions,loadingVolumeTooLargeTests,
		conflictingDilutionFactorOptionsQ,conflictingAbDilutionSamples,nonConflictingAbDilutionSamples,invalidAntibodyDilutionOptions,conflictingAntibodyDilutionTests,idealSignalDetectionTimesBoolean,
		nonOptimalSignalDetectionTimesTests,acceptableMWRangeP,ladderOptionModel,
		resolvedDenaturing,nonOptimalMolecularWeightRangeTests,resolvedDenaturingTemperature,resolvedDenaturingTime,resolvedLadder,nonOptimalLadderQ,
		resolvedLuminescenceReagent,nonOptimalLadderTests,
		resolvedStackingMatrixLoadTime,resolvedSampleLoadTime,resolvedVoltage,resolvedSeparationTime,resolvedUVExposureTime,washBufferOptionModel,nonOptimalWashBufferQ,
		nonOptimalWashBufferTests,concentratedLoadingBufferOptionModel,resolvedConcentratedLoadingBuffer,nonOptimalConcentratedLoadingBufferQ,nonOptimalConcentratedLoadingBufferTests,resolvedDenaturant,resolvedDenaturantVolume,
		resolvedWaterVolume,westernMapThreadFriendlyOptions,
		resolvedSecondaryAntibody,resolvedStandardPrimaryAntibody,resolvedStandardSecondaryAntibody,resolvedBlockingBuffer,resolvedSecondaryAntibodyVolume,resolvedStandardSecondaryAntibodyVolume,resolvedPrimaryAntibodyDiluent,
		resolvedPrimaryAntibodyDilutionFactor,resolvedPrimaryAntibodyVolume,resolvedPrimaryAntibodyDiluentVolume,resolvedStandardPrimaryAntibodyVolume,nonIdealSecondaryAntibodyWarnings,nonIdealStandardPrimaryAntibodyWarnings,
		nonIdealStandardSecondaryAntibodyWarnings,nonIdealBlockingBufferWarnings,nonIdealPrimaryAntibodyDiluentWarnings,conflictingPrimaryAbDilutionFactorErrors,
		standardPrimaryAntibodyStorageConditionErrors,standardSecondaryAntibodyStorageConditionErrors,
		resolvedPrimaryAntibodyDiluentVolumeNoNull,resolvedStandardPrimaryAntibodyVolumeNoNull,totalPrimaryAntibodyMixtureVolumes,inputsAndAntibodyTuples,tooLowAutomaticTotalAntibodyVolumeTuples,tooLowSetTotalAntibodyVolumeTuples,
		resolvedPrimaryAntibodyLoadingVolume,invalidTotalPrimaryAntibodyMixtureVolumes,validTotalPrimaryAntibodyMixtureVolumes,invalidTotalPrimaryAntibodyMixtureVolumeInputs,
		validTotalPrimaryAntibodyMixtureVolumeInputs,invalidPrimaryAntibodyDilutionOptions,invalidPrimaryAntibodyDilutionTests,dilutedPrimaryAntibodyVolumes,
		largeDilutedPrimaryAntibodyVolumes,largeDilutedPrimaryAntibodyVolumeTest,largeDilutedPrimaryAntibodyDiluentVolumes,
		totalLoadingBufferVolume,totalSuppliedLoadingBufferVolume,totalExtraLoadingBufferVolume,
		totalRequiredLoadingBufferVolume,invalidLoadingBufferVolumeOptions,notEnoughLoadingBufferTests,
		westernUnresolvableOptionTests,invalidDilutionFactorOptions,conflictingStandardPrimaryAntibodyStorageOptions,
		conflictingStandardSecondaryAntibodyStorageOptions,requiredAliquotAmounts,liquidHandlerContainerModels,liquidHandlerContainerMaxVolumes,
		potentialAliquotContainers,simulatedSamplesContainerModels,
		resolvedMolecularWeightRange,nonOptimalAntibodyQ,
		invalidInputs,invalidOptions,requiredAliquotContainers,resolvedAliquotOptions,aliquotTests,resolvedAliquotBooleans,totalProteinConcListNoNull,inputLysateAndAntibodyTuples,
		aliquotFailureBools,failingLysateAliquotTuples,passingLysateAliquotTuples,lysateDilutionTests,
		resolvedPostProcessingOptions,email,realBlockingBuffer,resolvedOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Get options specific to the experiment functions. *)
	totalProteinDetectionSpecificOptions=ToExpression[Complement[Keys[Options[ExperimentTotalProteinDetection]],Keys[Options[ExperimentWestern]]]];
	westernSpecificOptions=ToExpression[Complement[Keys[Options[ExperimentWestern]],Keys[Options[ExperimentTotalProteinDetection]]]];

	(* Set a Boolean that determines if we are in ExperimentWestern or not *)
	westernQ=If[Length[myAntibodies]==0,
		False,
		True
	];

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages=!gatherTests;

	(* Determine if we are in Engine or not, in Engine we silence warnings *)
	notInEngine=Not[MatchQ[$ECLApplication,Engine]];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Separate out our <Type> options from our Sample Prep options. *)
	{samplePrepOptions,experimentOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{simulatedSamples,resolvedSamplePrepOptions,simulatedCache}=resolveSamplePrepOptions[ExperimentTotalProteinDetection,mySamples,samplePrepOptions,Cache->cache];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	experimentOptionsAssociation = Association[experimentOptions];

	(* --- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --- *)
	(* Pull out information from the non-quantity or number options that we might need - later, after rounding, we will Lookup the rounded options *)
	{
		suppliedInstrument,numberOfReplicates,suppliedDenaturing,suppliedName,suppliedSystemStandard,suppliedStandardPrimaryAntibody,suppliedStandardSecondaryAntibody,suppliedPrimaryAntibodyDiluent,
		suppliedMolecularWeightRange,suppliedLadder,suppliedWashBuffer,suppliedConcentratedLoadingBuffer,suppliedDenaturant,suppliedLabelingReagent,suppliedBlockingBuffer,
		suppliedPeroxidaseReagent,suppliedLadderPeroxidaseReagent,suppliedSecondaryAntibodies,suppliedLadderBlockingBuffer,suppliedLuminescenceReagent,
		suppliedPeroxidaseReagentStorageCondition,suppliedPrimaryAntibodyStorageCondition,suppliedStandardPrimaryAntibodyStorageCondition,
		suppliedSecondaryAntibodyStorageCondition,suppliedStandardSecondaryAntibodyStorageCondition,suppliedLadderPeroxidaseStorageCondition,
		suppliedSamplesInStorageCondition
	}
			=Lookup[experimentOptionsAssociation,
		{
			Instrument,NumberOfReplicates,Denaturing,Name,SystemStandard,StandardPrimaryAntibody,StandardSecondaryAntibody,PrimaryAntibodyDiluent,MolecularWeightRange,Ladder,WashBuffer,ConcentratedLoadingBuffer,
			Denaturant,LabelingReagent,BlockingBuffer,PeroxidaseReagent,LadderPeroxidaseReagent,SecondaryAntibody,LadderBlockingBuffer,LuminescenceReagent,
			PeroxidaseReagentStorageCondition,PrimaryAntibodyStorageCondition,StandardPrimaryAntibodyStorageCondition,SecondaryAntibodyStorageCondition,
			StandardSecondaryAntibodyStorageCondition,LadderPeroxidaseStorageCondition,SamplesInStorageCondition
		},
		Null
	];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
	(* - Ladder Option - *)
	ladderDownloadFields=Switch[suppliedLadder,
		ObjectP[Object[Sample]],
			Packet[Model[{Name}]],
		ObjectP[Model[Sample]],
			Packet[],
		_,
			{}
	];

	(* - WashBuffer Option - *)
	washBufferDownloadFields=Switch[suppliedWashBuffer,
		ObjectP[Object[Sample]],
			Packet[Model[{Name}]],
		ObjectP[Model[Sample]],
			Packet[],
		_,
			{}
	];

	(* - ConcentratedLoadingBuffer Option - *)
	concentratedLoadingBufferDownloadFields=Switch[suppliedConcentratedLoadingBuffer,
		ObjectP[Object[Sample]],
			Packet[Model[{Name}]],
		ObjectP[Model[Sample]],
			Packet[],
		_,
			{}
	];

	(* - SecondaryAntibody Option - *)
	(* Since SecondaryAntibody is index matched, we will need to download packets from Object and Sample inputs separately, then reconstruct a list of the SecondaryAntibody Models by ID after *)
	(* Create lists of the SecondaryAntibodies that are unique Objects and Models*)
	uniqueSecondaryAntibodyObjects=DeleteDuplicates[Cases[ToList[suppliedSecondaryAntibodies],ObjectP[Object]]];
	uniqueSecondaryAntibodyModels=DeleteDuplicates[Cases[ToList[suppliedSecondaryAntibodies],ObjectP[Model]]];

	(* - StandardPrimaryAntibody Option - *)
	(* Since StandardPrimaryAntibody is index matched, we will need to download packets from Object and Sample inputs separately, then reconstruct a list of the StandardPrimaryAntibody Models by ID after *)
	uniqueStandardPrimaryAbObjects=DeleteDuplicates[Cases[ToList[suppliedStandardPrimaryAntibody],ObjectP[Object]]];
	uniqueStandardPrimaryAbModels=DeleteDuplicates[Cases[ToList[suppliedStandardPrimaryAntibody],ObjectP[Model]]];

	(* - StandardSecondaryAntibody Option - *)
	(* Since StandardSecondaryAntibody is index matched, we will need to download packets from Object and Sample inputs separately, then reconstruct a list of the StandardSecondaryAntibody Models by ID after *)
	uniqueStandardSecondaryAbObjects=DeleteDuplicates[Cases[ToList[suppliedStandardSecondaryAntibody],ObjectP[Object]]];
	uniqueStandardSecondaryAbModels=DeleteDuplicates[Cases[ToList[suppliedStandardSecondaryAntibody],ObjectP[Model]]];

	(* - BlockingBuffer Option - *)
	(* Since StandardSecondaryAntibody is index matched in Western and single in TotalProteinLabeling , we will need to download packets from Object and Sample inputs separately, then reconstruct a list of the StandardSecondaryAntibody Models by ID after *)
	listedBlockingBuffer=ToList[suppliedBlockingBuffer];
	uniqueBlockingBufferObjects=DeleteDuplicates[Cases[ToList[listedBlockingBuffer],ObjectP[Object]]];
	uniqueBlockingBufferModels=DeleteDuplicates[Cases[ToList[listedBlockingBuffer],ObjectP[Model]]];

	(* - PrimaryAntibodyDiluent Option - *)
	(* Since PrimaryAntibodyDiluent is index matched, we will need to download packets from Object and Sample inputs separately, then reconstruct a list of the PrimaryAntibodyDiluent Models by ID after *)
	uniquePrimaryAntibodyDiluentObjects=DeleteDuplicates[Cases[ToList[suppliedPrimaryAntibodyDiluent],ObjectP[Object]]];
	uniquePrimaryAntibodyDiluentModels=DeleteDuplicates[Cases[ToList[suppliedPrimaryAntibodyDiluent],ObjectP[Model]]];

	(* -- PrimaryAntibody input -- *)
	(* - Depending on if the secondary input is an object, we need to download different fields - *)
	primaryAntibodyObjectInputs=Cases[myAntibodies,ObjectP[Object[Sample]]];
	primaryAntibodyModelInputs=Cases[myAntibodies,ObjectP[Model[Sample]]];

	(* - Determine which fields we need to download from the input Objects - *)
	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{TotalProteinConcentration,IncompatibleMaterials,RequestedResources,SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
	modelContainerPacketFields=Packet@@Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];
	samplesContainerModelPacketFields=Packet[Container[Model[Flatten[{Object,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container]]}]]]];

	(* - All liquid handler compatible containers (for resources and Aliquot) - *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* --- Assemble Download --- *)
	{
		listedSampleContainerPackets,listedAntibodyObjectInputPackets,listedModelInstrumentPackets,listedLadderOptionPackets,listedWashBufferOptionPackets,listedConcentratedLoadingBufferOptionPackets,
		listedSecondaryAbObjectPackets,listedSecondaryAbModelPackets,listedStandardPrimaryAbObjectPackets,listedStandardPrimaryAbModelPackets,listedStandardSecondaryAbObjectPackets,
		listedStandardSecondaryAbModelPackets,listedBlockingBufferObjectPackets,listedBlockingBufferModelPackets,listedPrimaryAntibodyDiluentObjectPackets,
		listedPrimaryAntibodyDiluentModelPackets,listedPrimaryAntibodyCompositionPackets,liquidHandlerContainerPackets
	}=Quiet[
		Download[
			{
				(* Inputs *)
				simulatedSamples,
				primaryAntibodyObjectInputs,

				(* Options *)
				{suppliedInstrument},
				{(suppliedLadder/.{Automatic->Null})},
				{(suppliedWashBuffer/.{Automatic->Null})},
				{(suppliedConcentratedLoadingBuffer/.{Automatic->Null})},
				uniqueSecondaryAntibodyObjects,
				uniqueSecondaryAntibodyModels,
				uniqueStandardPrimaryAbObjects,
				uniqueStandardPrimaryAbModels,
				uniqueStandardSecondaryAbObjects,
				uniqueStandardSecondaryAbModels,
				uniqueBlockingBufferObjects,
				uniqueBlockingBufferModels,
				uniquePrimaryAntibodyDiluentObjects,
				uniquePrimaryAntibodyDiluentModels,
				myAntibodies,
				liquidHandlerContainers
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Composition[[All,2]][MolecularWeight]],
					Packet[Container[{Model, Contents, Name, Status, Sterile, TareWeight,RequestedResources}]],
					samplesContainerModelPacketFields
				},
				{
					objectSamplePacketFields,
					modelSamplePacketFields
				},

				(* Options *)
				{Packet[Model, Status, WettedMaterials]},
				{ladderDownloadFields},
				{washBufferDownloadFields},
				{concentratedLoadingBufferDownloadFields},
				(* Secondary Ab fields *)
				{Packet[Model[{Name}]]},
				{Packet[]},
				(* Standard Primary Ab fields *)
				{Packet[Model[{Name}]]},
				{Packet[]},
				(* Standard Secondary Ab fields *)
				{Packet[Model[{Name}]]},
				{Packet[]},
				(* BlockingBuffer fields *)
				{Packet[Model[{Name}]]},
				{Packet[]},
				(* PrimaryAntibodyDiluent fields *)
				{Packet[Model[{Name}]]},
				{Packet[]},

				(* PrimaryAntibodies Composition *)
				{
					Packet[Composition[[All,2]][{RecommendedDilution,Organism,Targets}]],
					Packet[Composition[[All,2]][Targets][MolecularWeight]]
				},
				{modelContainerPacketFields}
			},
			Cache->simulatedCache,
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* --- Extract out the packets from the download --- *)
	(* -- sample packets -- *)
	samplePackets=listedSampleContainerPackets[[All,1]];
	sampleModelPackets=listedSampleContainerPackets[[All,2]];
	sampleComponentPackets=listedSampleContainerPackets[[All,3]];
	sampleContainerPackets=listedSampleContainerPackets[[All,4]];

	(* -- Antibody packets -- *)
	(* The first two are packets downloaded from myAntibodies that are Objects *)
	antibodyObjectInputObjectPackets=listedAntibodyObjectInputPackets[[All,1]];
	antibodyObjectInputModelPackets=listedAntibodyObjectInputPackets[[All,2]];

	(* -- New Antibody packets with Compositions etc --*)
	(* Downloaded from PrimaryAntibodies *)
	primaryAntibodyComponentsPackets=listedPrimaryAntibodyCompositionPackets[[All,1]];
	primaryAntibodyComponentsTargetPackets=listedPrimaryAntibodyCompositionPackets[[All,2]];

	(* From the primaryAntibodyComponentsPackets, get rid of any Nulls (anytime there is a Null in the Composition list) *)
	primaryAntibodyComponentsPacketsNoNull=Map[
		Cases[#,PacketP[]]&,
		primaryAntibodyComponentsPackets
	];

	(* - RecommendedDilution - *)
	(* From this list of list of Packets, choose the ones that are from a Model[Molecule,Protein,Antibody] and whose RecommendedDilution is not Null *)
	primaryAntibodyMoleculeRecommendedDilutionPackets=Map[
		Function[{associationList},
			Select[associationList,(MatchQ[Lookup[#, Object], ObjectP[Model[Molecule, Protein, Antibody]]]&&MatchQ[Lookup[#, RecommendedDilution], Except[Null]])&]
		],
		primaryAntibodyComponentsPacketsNoNull
	];

	(* Create a list of the averaged RecommendedDilutions of the PrimaryAntibody inputs, or 1 if there are no Model[Molecule,Protein,Antibody]s in the Composition field *)
	primaryAntibodyRecommendedDilutions=Map[
		If[
			(* IF there are no Components that are Model[Molecule,Protein,Antibody]s with a RecommendedDilution *)
			MatchQ[#,{}],

			(* THEN we set the RecommendedDilution to 1 *)
			1,

			(* ELSE we average the RecommendedDilutions of the Composition components *)
			RoundOptionPrecision[Mean[Lookup[#,RecommendedDilution]],10^-3]
		]&,
		primaryAntibodyMoleculeRecommendedDilutionPackets
	];

	(* - Organism - *)
	(* From the list of PrimaryAntibody Composition packets, choose the ones that are Model[Molecule,Protein,Antibody] and whose Organism is not Null *)
	primaryAntibodyMoleculeOrganismPackets=Map[
		Function[{associationList},
			Select[associationList,(MatchQ[Lookup[#, Object], ObjectP[Model[Molecule, Protein, Antibody]]]&&MatchQ[Lookup[#, Organism], Except[Null]])&]
		],
		primaryAntibodyComponentsPacketsNoNull
	];

	(* Create a list of the First Organism listed in the Antibody Components of the PrimaryAntibody, or Null if there are no Model[Molecule,Protein,Antibody] in the Composition field *)
	primaryAntibodyOrganisms=Map[
		If[
			(* IF there are no Components that are Model[Molecule,Protein,Antibody]s with an Organism *)
			MatchQ[#,{}],

			(* THEN we set the Organism to Null *)
			Null,

			(* ELSE we pick the first Organism listed in the Model[Molecule,Protein,Antibody] packets (rare that this will be more than one) *)
			First[Lookup[#,Organism]]
		]&,
		primaryAntibodyMoleculeOrganismPackets
	];

	(* - Targets - *)
	(* We want to use the Targets field of the Model[Molecule,Protein,Antibody]s in the Composition of the primary antibody inputs to determine the correct molecular weight range *)
	(* Get a list of all of the Model[Molecule,Protein] packets present in the Target fields of all of the Components of the primary antibodies *)
	allTargetPackets=Cases[Flatten[primaryAntibodyComponentsTargetPackets],PacketP[]];

	(* From this list of packets, pick choose the ones that have a MolecularWeight *)
	allMolecularWeightPackets=Select[allTargetPackets,MatchQ[Lookup[#, MolecularWeight], Except[Null]]&];

	(* Average all of the Target MolecularWeights *)
	averageTargetMolecularWeight=If[Length[allMolecularWeightPackets]==0,
		Null,
		RoundOptionPrecision[Mean[Lookup[allMolecularWeightPackets,MolecularWeight]],10^0*(Gram/Mole)]
	];

	(* instrument packets *)
	instrumentPacket=listedModelInstrumentPackets[[1,1]];

	(* make the ladderOptionPacket an empty association if the Option is set to automatic *)
	ladderOptionPacket=FirstOrDefault[ReplaceAll[FirstOrDefault[listedLadderOptionPackets],{Null-><||>}],<||>];

	(* make the washBufferOptionPacket an empty association if the Option is set to automatic *)
	washBufferOptionPacket=FirstOrDefault[ReplaceAll[FirstOrDefault[listedWashBufferOptionPackets],{Null-><||>}],<||>];

	(* make the concentratedLoadingBufferOptionPacket an empty association if the Option is set to automatic *)
	concentratedLoadingBufferOptionPacket=FirstOrDefault[ReplaceAll[FirstOrDefault[listedConcentratedLoadingBufferOptionPackets],{Null-><||>}],<||>];

	(* - We need to create a list of the secondary antibody option inputs by Model ID, index matched to inputs - *)
	(* First, create lists of the SecondaryAntibody's Model by ID, if they were given as an Object or a Model as input *)
	secondaryAbObjectPacketModels=Lookup[ReplaceAll[Flatten[listedSecondaryAbObjectPackets],{Null->{}}],Object,{}];
	secondaryAbModelPacketModels=Lookup[Flatten[listedSecondaryAbModelPackets],Object,{}];

	(* Write replace rules for the SecondaryAntibody Model and Object inputs - goal is to get an index-matched list of SecondaryAntibody inputs by Model ID *)
	secondaryAbObjectReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueSecondaryAntibodyObjects,secondaryAbObjectPacketModels}
	];
	secondaryAbModelReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueSecondaryAntibodyModels,secondaryAbModelPacketModels}
	];

	(* Define the SecondaryAb replace rules, combining the two previous list of rules with Automatic->Null *)
	secondaryAbReplaceRules=Join[secondaryAbObjectReplaceRules,secondaryAbModelReplaceRules,{Automatic->Null}];

	(* Finally, use the replace rules to define a list of the SecondaryAntibody inputs by Model ID, with Automatic being Null *)
	secondaryAbModels=suppliedSecondaryAntibodies/.secondaryAbReplaceRules;

	(* - We need to create a list of the StandardPrimaryAntibody option inputs by Model ID, index matched to inputs - *)
	(* First, create lists of the StandardPrimaryAntibody's Model by ID, if they were given as an Object or a Model as input *)
	standardPrimaryAbObjectPacketModels=Lookup[ReplaceAll[Flatten[listedStandardPrimaryAbObjectPackets],{Null->{}}],Object,{}];
	standardPrimaryAbModelPacketModels=Lookup[Flatten[listedStandardPrimaryAbModelPackets],Object,{}];

	(* Write replace rules for the StandardPrimaryAntibody Model and Object inputs - goal is to get an index-matched list of StandardPrimaryAntibody inputs by Model ID *)
	standardPrimaryAbObjectReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueStandardPrimaryAbObjects,standardPrimaryAbObjectPacketModels}
	];
	standardPrimaryAbModelReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueStandardPrimaryAbModels,standardPrimaryAbModelPacketModels}
	];

	(* Define the StandardPrimaryAntibody replace rules, combining the two previous list of rules with Automatic->Null *)
	standardPrimaryAbReplaceRules=Join[standardPrimaryAbObjectReplaceRules,standardPrimaryAbModelReplaceRules,{Automatic->Null}];

	(* Finally, use the replace rules to define a list of the SecondaryAntibody inputs by Model ID, with Automatic being Null *)
	standardPrimaryAbModels=suppliedStandardPrimaryAntibody/.standardPrimaryAbReplaceRules;

	(* - We need to create a list of the StandardSecondaryAntibody option inputs by Model ID, index matched to inputs - *)
	(* First, create lists of the StandardSecondaryAntibody's Model by ID, if they were given as an Object or a Model as input *)
	standardSecondaryAbObjectPacketModels=Lookup[ReplaceAll[Flatten[listedStandardSecondaryAbObjectPackets],{Null->{}}],Object,{}];
	standardSecondaryAbModelPacketModels=Lookup[Flatten[listedStandardSecondaryAbModelPackets],Object,{}];

	(* Write replace rules for the StandardSecondaryAntibody Model and Object inputs - goal is to get an index-matched list of StandardSecondaryAntibody inputs by Model ID *)
	standardSecondaryAbObjectReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueStandardSecondaryAbObjects,standardSecondaryAbObjectPacketModels}
	];
	standardSecondaryAbModelReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueStandardSecondaryAbModels,standardSecondaryAbModelPacketModels}
	];

	(* Define the StandardSecondaryAntibody replace rules, combining the two previous list of rules with Automatic->Null *)
	standardSecondaryAbReplaceRules=Join[standardSecondaryAbObjectReplaceRules,standardSecondaryAbModelReplaceRules,{Automatic->Null}];

	(* Finally, use the replace rules to define a list of the SecondaryAntibody inputs by Model ID, with Automatic being Null *)
	standardSecondaryAbModels=suppliedStandardSecondaryAntibody/.standardSecondaryAbReplaceRules;

	(* - We need to create a list of the BlockingBuffer option inputs by Model ID, index matched to inputs - *)
	(* First, create lists of the BlockingBuffer's Model by ID, if they were given as an Object or a Model as input *)
	blockingBufferObjectPacketModels=Lookup[ReplaceAll[Flatten[listedBlockingBufferObjectPackets],{Null->{}}],Object,{}];
	blockingBufferModelPacketModels=Lookup[Flatten[listedBlockingBufferModelPackets],Object,{}];

	(* Write replace rules for the BlockingBuffer Model and Object inputs - goal is to get an index-matched list of BlockingBuffer inputs by Model ID *)
	blockingBufferObjectReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueBlockingBufferObjects,blockingBufferObjectPacketModels}
	];
	blockingBufferModelReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueBlockingBufferModels,blockingBufferModelPacketModels}
	];

	(* Define the BlockingBuffer replace rules, combining the two previous list of rules with Automatic->Null *)
	blockingBufferReplaceRules=Join[blockingBufferObjectReplaceRules,blockingBufferModelReplaceRules,{Automatic->Null}];

	(* Finally, use the replace rules to define a list of the SecondaryAntibody inputs by Model ID, with Automatic being Null *)
	blockingBufferModels=listedBlockingBuffer/.blockingBufferReplaceRules;

	(* - We need to create a list of the PrimaryAntibodyDiluent option inputs by Model ID, index matched to inputs - *)
	(* First, create lists of the PrimaryAntibodyDiluent's Model by ID, if they were given as an Object or a Model as input *)
	primaryAntibodyDiluentObjectPacketModels=Lookup[ReplaceAll[Flatten[listedPrimaryAntibodyDiluentObjectPackets],{Null->{}}],Object,{}];
	primaryAntibodyDiluentModelPacketModels=Lookup[Flatten[listedPrimaryAntibodyDiluentModelPackets],Object,{}];

	(* Write replace rules for the PrimaryAntibodyDiluent Model and Object inputs - goal is to get an index-matched list of PrimaryAntibodyDiluent inputs by Model ID *)
	primaryAntibodyDiluentObjectReplaceRules=MapThread[
		(#1->#2)&,
		{uniquePrimaryAntibodyDiluentObjects,primaryAntibodyDiluentObjectPacketModels}
	];
	primaryAntibodyDiluentModelReplaceRules=MapThread[
		(#1->#2)&,
		{uniquePrimaryAntibodyDiluentModels,primaryAntibodyDiluentModelPacketModels}
	];

	(* Define the PrimaryAntibodyDiluent replace rules, combining the two previous list of rules with Automatic->Null *)
	primaryAntibodyDiluentReplaceRules=Join[primaryAntibodyDiluentObjectReplaceRules,primaryAntibodyDiluentModelReplaceRules,{Automatic->Null}];

	(* Finally, use the replace rules to define a list of the PrimaryAntibodyDiluent inputs by Model ID, with Automatic being Null *)
	primaryAbDiluentModels=suppliedPrimaryAntibodyDiluent/.primaryAntibodyDiluentReplaceRules;

	(* --- INPUT VALIDATION CHECKS --- *)
	(* Get the samples from simulatedSamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Get the antibody inputs that are discarded *)
	discardedAntibodyPackets=Cases[Flatten[antibodyObjectInputObjectPackets],KeyValuePattern[Status->Discarded]];

	(* Join these two lists of discarded packets *)
	discardedInputPackets=Join[discardedSamplePackets,discardedAntibodyPackets];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs= If[MatchQ[discardedInputPackets,{}],
		{},
		Lookup[discardedInputPackets,Object]
	];

	(* If there are discarded invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["The input samples "<>ObjectToString[discardedInvalidInputs,Cache->simulatedCache]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["The input samples "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs],Cache->simulatedCache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Throw an error if the SamplesInStorageCondition is in conflict with the samples in continers *)
	(* Find the containers of the simulated samples *)
	simulatedSampleContainers=Lookup[sampleContainerPackets,Object];

	(* Check to see if the SamplesInStorageCondition is valid *)
	{validSamplesInStorageBools,samplesInStorageTests}=If[gatherTests,
		ValidContainerStorageConditionQ[simulatedSamples,suppliedSamplesInStorageCondition,Cache->simulatedCache,Output->{Result,Tests}],
		{ValidContainerStorageConditionQ[simulatedSamples, suppliedSamplesInStorageCondition, Output -> Result, Cache -> simulatedCache], {}}
	];

	(* Set the invalid options variable *)
	invalidSamplesInStorageConditionOptions=If[

		(* IF the list of bools contains any False *)
		ContainsAny[ToList[validSamplesInStorageBools],{False}],

		(* THEN the options are invalid *)
		{SamplesInStorageCondition},

		(* ELSE its fine *)
		{}
	];

	(* If there are more than 24 input samples, set all of the samples to tooManyInvalidInputs *)
	tooManyInvalidInputs=If[Length[simulatedSamples]>24,
		Lookup[Flatten[samplePackets],Object,Null],
		{}
	];

	(* If there are too many input samples and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	If[Length[tooManyInvalidInputs]>0&&messages,
		Message[Error::TooManyInputsForWes]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyInputsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[tooManyInvalidInputs]==0,
				Nothing,
				Test["There are 24 or fewer input samples in "<>ObjectToString[tooManyInvalidInputs,Cache->simulatedCache],True,False]
			];

			passingTest=If[Length[tooManyInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["There are 24 or fewer input samples.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to make sure that all inputs have TotalProteinConcentration informed - *)
	(* Create a list of the TotalProteinConcentration Fields from the packets of these sample objects *)
	totalProteinConcList=Lookup[samplePackets,TotalProteinConcentration,{}];

	(* Create lists - one of the simulatedSamples that have TotalProteinConcentration = Null and the other where it is informed *)
	missingTotalProteinLysates=PickList[simulatedSamples,totalProteinConcList,Null];
	informedTotalProteinLysates=PickList[simulatedSamples,totalProteinConcList,Except[Null]];

	(* If there are any primary inputs that do not have TotalProteinConcentration informed, throw a warning, as we cannot warn them that the samples may be too concentrated *)
	If[Length[missingTotalProteinLysates]>0&&messages&&notInEngine&&westernQ,
		Message[Warning::WesTotalProteinConcentrationNotInformed,ObjectToString[missingTotalProteinLysates,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	missingTotalProteinConcentrationTests=If[gatherTests&&westernQ,
		Module[{failingTest,passingTest},
			failingTest=If[Length[missingTotalProteinLysates]==0,
				Nothing,
				Warning["The following primary inputs have TotalProteinConcentration informed "<>ObjectToString[missingTotalProteinLysates,Cache->simulatedCache],True,False]
			];

			passingTest=If[Length[informedTotalProteinLysates]==0,
				Nothing,
				Warning["The following primary inputs have TotalProteinConcentration informed "<>ObjectToString[informedTotalProteinLysates,Cache->simulatedCache],True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	(* First, define the option precisions that need to be checked for Western and TotalProteinDetection *)

	(* The options that both Western and TotalProteinDetectionShare *)
	sharedOptionPrecisions={
		{DenaturingTemperature,10^0*Celsius},
		{DenaturingTime,10^0*Second},
		{SeparatingMatrixLoadTime,10^-1*Second},
		{StackingMatrixLoadTime,10^-1*Second},
		{SampleVolume,10^-1*Microliter},
		{ConcentratedLoadingBufferVolume,10^-1*Microliter},
		{DenaturantVolume,10^-1*Microliter},
		{WaterVolume,10^-1*Microliter},
		{LoadingBufferVolume,10^-1*Microliter},
		{LoadingVolume,10^-1*Microliter},
		{LadderVolume,10^-1*Microliter},
		{SampleLoadTime,10^-1*Second},
		{SeparationTime,10^-1*Second},
		{UVExposureTime,10^-1*Second},
		{WashBufferVolume,10^-1*Microliter},
		{LuminescenceReagentVolume,10^-1*Microliter},
		{SignalDetectionTimes,10^-1*Second},
		{BlockingBufferVolume,10^-1*Microliter},
		{LadderBlockingBufferVolume,10^-1*Microliter},
		{BlockingTime,10^-1*Second}
	};

	(* Define the option precision list for ExperimentWestern *)
	westernOptionPrecisions=Join[
		sharedOptionPrecisions,
		{
			{PrimaryAntibodyVolume,10^-1*Microliter},
			{PrimaryAntibodyDilutionFactor,10^-3},
			{PrimaryAntibodyDiluentVolume,10^-1*Microliter},
			{StandardPrimaryAntibodyVolume,10^-1*Microliter},
			{PrimaryAntibodyLoadingVolume,10^-1*Microliter},
			{PrimaryIncubationTime,10^-1*Second},
			{SecondaryAntibodyVolume,10^-1*Microliter},
			{StandardSecondaryAntibodyVolume,10^-1*Microliter},
			{SecondaryIncubationTime,10^-1*Second},
			{LadderPeroxidaseReagentVolume,10^-1*Microliter}
		}
	];

	(* Define the option precision list for ExperimentTotalProteinDetection *)
	totalProteinDetectionOptionPrecisions=Join[
		sharedOptionPrecisions,
		{
			{LabelingReagentVolume,10^0*Microliter},
			{LabelingTime,10^-1*Second},
			{PeroxidaseReagentVolume,10^0*Microliter},
			{PeroxidaseIncubationTime,10^-1*Second}
		}
	];

	(* Verify that the experiment options are not overly precise *)
	{roundedExperimentOptions,optionPrecisionTests}=Switch[{westernQ,gatherTests},

		(* If we are in ExperimentWestern and are gathering tests *)
		{True,True},
			RoundOptionPrecision[experimentOptionsAssociation,westernOptionPrecisions[[All,1]],westernOptionPrecisions[[All,2]],Output->{Result,Tests}],

		(* If we are in ExperimentWestern and are not gathering tests *)
		{True,False},
			{RoundOptionPrecision[experimentOptionsAssociation,westernOptionPrecisions[[All,1]],westernOptionPrecisions[[All,2]]],{}},

		(* If we are in ExperimentTotalProteinDetection and are gathering tests *)
		{False,True},
			RoundOptionPrecision[experimentOptionsAssociation,totalProteinDetectionOptionPrecisions[[All,1]],totalProteinDetectionOptionPrecisions[[All,2]],Output->{Result,Tests}],

		(* If we are in ExperimentTotalProteinDetection and are not gathering Tests *)
		{False,False},
			{RoundOptionPrecision[experimentOptionsAssociation,totalProteinDetectionOptionPrecisions[[All,1]],totalProteinDetectionOptionPrecisions[[All,2]]],{}}
	];

	(* For option resolution below, Lookup the options that can be quantities or numbers from roundedExperimentOptions *)
	{
		suppliedDenaturingTemperature,suppliedDenaturingTime,suppliedStandardPrimaryAntibodyVolume,suppliedStandardSecondaryAntibodyVolume,
		suppliedPrimaryAntibodyDiluentVolume,suppliedLadderVolume,suppliedSeparatingMatrixLoadTime,suppliedStackingMatrixLoadTime,suppliedSampleLoadTime,suppliedVoltage,suppliedSeparationTime,suppliedUVExposureTime,
		suppliedBlockingBufferVolume,suppliedBlockingTime,suppliedWashBufferVolume,suppliedConcentratedLoadingBufferVolume,suppliedDenaturantVolume,suppliedWaterVolume,suppliedLabelingReagentVolume,suppliedLabelingTime,
		suppliedPeroxidaseReagentVolume,suppliedPeroxidaseIncubationTime,suppliedPrimaryIncubationTime,suppliedLadderPeroxidaseReagentVolume,suppliedSecondaryIncubationTime,suppliedPrimaryAntibodyLoadingVolume,
		suppliedSampleVolume,suppliedLoadingBufferVolume,suppliedLoadingVolume,suppliedPrimaryAntibodyDilutionFactor,suppliedLadderBlockingBufferVolume,suppliedSignalDetectionTimes,
		roundedPrimaryAntibodyDiluentVolumes,roundedStandardPrimaryAntibodyVolumes,roundedStandardSecondaryAntibodyVolumes
	}
			=Lookup[roundedExperimentOptions,
		{
			DenaturingTemperature,DenaturingTime,StandardPrimaryAntibodyVolume,StandardSecondaryAntibodyVolume,PrimaryAntibodyDiluentVolume,LadderVolume,SeparatingMatrixLoadTime,
			StackingMatrixLoadTime,SampleLoadTime,Voltage,SeparationTime,UVExposureTime,BlockingBufferVolume,BlockingTime,WashBufferVolume,ConcentratedLoadingBufferVolume,DenaturantVolume,WaterVolume,LabelingReagentVolume,
			LabelingTime,PeroxidaseReagentVolume,PeroxidaseIncubationTime,PrimaryIncubationTime,LadderPeroxidaseReagentVolume,SecondaryIncubationTime,PrimaryAntibodyLoadingVolume,SampleVolume,LoadingBufferVolume,LoadingVolume,
			PrimaryAntibodyDilutionFactor,LadderBlockingBufferVolume,SignalDetectionTimes,PrimaryAntibodyDiluentVolume,StandardPrimaryAntibodyVolume,StandardSecondaryAntibodyVolume
		}
	];
	(* Turn the output of RoundOptionPrecision[experimentOptionsAssociation] into a list *)
	roundedExperimentOptionsList=Normal[roundedExperimentOptions];

	(* Replace the rounded options in myOptions *)
	allOptionsRounded=ReplaceRule[
		myOptions,
		roundedExperimentOptionsList,
		Append->False
	];

	(* --- CONFLICTING OPTIONS CHECKS --- *)
	(* -- First, check to make sure that the Volume options that will be used for Macro/Micro liquid handling are not between 0-1 or 0-0.5uL -- *)
	(* Get rid of any Nulls or Automatics in the lists of Volumes *)
	primaryAntibodyDiluentVolumesOnlyVolumes=Cases[roundedPrimaryAntibodyDiluentVolumes,VolumeP];
	standardPrimaryAntibodyVolumesOnlyVolumes=Cases[roundedStandardPrimaryAntibodyVolumes,VolumeP];
	standardSecondaryAntibodyVolumesOnlyVolumes=Cases[roundedStandardSecondaryAntibodyVolumes,VolumeP];

	(* -- Define the invalid and valid volumes in the above lists (invalid for the first two lists is between 0 and 1 uL, and between 0 and 0.5 uL in the second list - *)
	(* - PrimaryAntibodyDiluentVolumes - *)
	invalidPrimaryAntibodyDiluentVolumes=Cases[primaryAntibodyDiluentVolumesOnlyVolumes,RangeP[0*Microliter,1*Microliter,Inclusive->None]];
	validPrimaryAntibodyDiluentVolumes=Cases[primaryAntibodyDiluentVolumesOnlyVolumes,Except[Alternatives@@invalidPrimaryAntibodyDiluentVolumes]];
	invalidPrimaryAntibodyDiluentVolumeOption=If[Length[invalidPrimaryAntibodyDiluentVolumes]>0,
		{PrimaryAntibodyDiluentVolume},
		{}
	];

	(* Throw Error if there are any invalid volumes, and define the tests *)
	If[Length[invalidPrimaryAntibodyDiluentVolumes]>0&&messages,
		Message[Error::WesOptionVolumeTooLow,PrimaryAntibodyDiluentVolume,invalidPrimaryAntibodyDiluentVolumes,ToString[1*Microliter]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidPrimaryAntibodyDiluentVolumeTests=If[gatherTests&&Length[invalidPrimaryAntibodyDiluentVolumes]>0,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidPrimaryAntibodyDiluentVolumes]==0,
				Nothing,
				Test["The following members of PrimaryAntibodyDiluentVolume, "<>ToString[invalidPrimaryAntibodyDiluentVolumes]<>", are not between 0 and 1 uL:",True,False]
			];

			passingTest=If[Length[validPrimaryAntibodyDiluentVolumes]==0,
				Nothing,
				Test["The following members of PrimaryAntibodyDiluentVolume, "<>ToString[validPrimaryAntibodyDiluentVolumes]<>", are not between 0 and 1 uL:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* StandardPrimaryAntibodyVolumes *)
	invalidStandardPrimaryAntibodyVolumes=Cases[standardPrimaryAntibodyVolumesOnlyVolumes,RangeP[0*Microliter,1*Microliter,Inclusive->None]];
	validStandardPrimaryAntibodyVolumes=Cases[standardPrimaryAntibodyVolumesOnlyVolumes,Except[Alternatives@@invalidStandardPrimaryAntibodyVolumes]];
	invalidStandardPrimaryAntibodyVolumeOption=If[Length[invalidStandardPrimaryAntibodyVolumes]>0,
		{StandardPrimaryAntibodyVolume},
		{}
	];

	(* Throw Error if there are any invalid volumes, and define the tests *)
	If[Length[invalidStandardPrimaryAntibodyVolumes]>0&&messages,
		Message[Error::WesOptionVolumeTooLow,StandardPrimaryAntibodyVolume,invalidStandardPrimaryAntibodyVolumes,ToString[1*Microliter]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidStandardPrimaryAntibodyVolumeTests=If[gatherTests&&Length[invalidStandardPrimaryAntibodyVolumes]>0,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidStandardPrimaryAntibodyVolumes]==0,
				Nothing,
				Test["The following members of StandardPrimaryAntibodyVolume, "<>ToString[invalidStandardPrimaryAntibodyVolumes]<>", are not between 0 and 1 uL:",True,False]
			];

			passingTest=If[Length[validStandardPrimaryAntibodyVolumes]==0,
				Nothing,
				Test["The following members of StandardPrimaryAntibodyVolume, "<>ToString[validStandardPrimaryAntibodyVolumes]<>", are not between 0 and 1 uL:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* StandardSecondaryAntibodyVolumes *)
	invalidStandardSecondaryAntibodyVolumes=Cases[standardSecondaryAntibodyVolumesOnlyVolumes,RangeP[0*Microliter,0.5*Microliter,Inclusive->None]];
	validStandardSecondaryAntibodyVolumes=Cases[standardSecondaryAntibodyVolumesOnlyVolumes,Except[Alternatives@@invalidStandardSecondaryAntibodyVolumes]];
	invalidStandardSecondaryAntibodyVolumeOption=If[Length[invalidStandardSecondaryAntibodyVolumes]>0,
		{StandardSecondaryAntibodyVolume},
		{}
	];

	(* Throw Error if there are any invalid volumes, and define the tests *)
	If[Length[invalidStandardSecondaryAntibodyVolumes]>0&&messages,
		Message[Error::WesOptionVolumeTooLow,StandardSecondaryAntibodyVolume,invalidStandardSecondaryAntibodyVolumes,ToString[0.5*Microliter]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidStandardSecondaryAntibodyVolumeTests=If[gatherTests&&Length[invalidStandardSecondaryAntibodyVolumes]>0,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidStandardSecondaryAntibodyVolumes]==0,
				Nothing,
				Test["The following members of StandardSecondaryAntibodyVolume, "<>ToString[invalidStandardSecondaryAntibodyVolumes]<>", are not between 0 and 0.5 uL:",True,False]
			];

			passingTest=If[Length[validStandardSecondaryAntibodyVolumes]==0,
				Nothing,
				Test["The following members of StandardSecondaryAntibodyVolume, "<>ToString[validStandardSecondaryAntibodyVolumes]<>", are not between 0 and 0.5 uL:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(* - Check to see if the Name option is properly specified - *)
	validNameQ=Which[

		(* If we are in ExperimentWestern and the supplied Name is a string, check to see if this name exists in the Database already *)
		westernQ&&MatchQ[suppliedName,_String],
			Not[DatabaseMemberQ[Object[Protocol,Western,suppliedName]]],

		(* If we are in ExperimentWestern and the supplied Name is not string (it is Null), the name option is valid *)
		westernQ,
			True,

		(* If we are in ExperimentTotalProteinDetection and the supplied Name is a string, check to see if this name exists in the Database already *)
		!westernQ&&MatchQ[suppliedName,_String],
			Not[DatabaseMemberQ[Object[Protocol,TotalProteinDetection,suppliedName]]],

		(* If we are in ExperimentTotalProteinDetection and the supplied Name is not string (it is Null), the name option is valid *)
		!westernQ,
			True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOption=Which[

		(* If we are in Western and the name is invalid and we are throwing messages, do so and set nameInvalidOption to {Name} *)
		westernQ&&messages&&!validNameQ,
			(
				Message[Error::DuplicateName,"Western protocol"];
				{Name}
			),

		(* Otherwise, if we are in Western, set the invalid option to {} *)
		westernQ,
			{},

		(* If we are in TotalProteinDetection and the name is invalid and we are throwing messages, do so and set nameInvalidOption to {Name} *)
		!westernQ&&messages&&!validNameQ,
			(
				Message[Error::DuplicateName,"TotalProteinDetection protocol"];
				{Name}
			),

		(* Otherwise, if we are in TotalProteinDetection, set the invalid option to {} *)
		!westernQ,
			{}
	];

	(* Generate Test for Name Check *)
	validNameTest=Which[

		(* If we are not gathering tests, No Test *)
		!gatherTests,
			Nothing,

		(* If the name option was not specified, No Test *)
		!MatchQ[suppliedName,_String],
			Nothing,

		(* If we are in Western, define test *)
		westernQ,
			Test["If specified, Name is not already a Western protocol object name:",validNameQ,True],

		(* If we are in TotalProteinDetection, define the test *)
		!westernQ,
			Test["If specified, Name is not already a TotalProteinDetection protocol object name:",validNameQ,True]
	];

	(* - Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument - *)
	{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[suppliedInstrument,Join[simulatedSamples,myAntibodies],Cache->simulatedCache,Output->{Result,Tests}],
		{CompatibleMaterialsQ[suppliedInstrument,Join[simulatedSamples,myAntibodies],Cache->simulatedCache,Messages->messages],{}}
	];

	(* If the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidOption=If[Not[compatibleMaterialsBool]&&messages,
		{Instrument},
		{}
	];

	(* - Check to see if the NumberOfReplicates Option works with the number of input samples - *)
	(* Convert numberOfReplicates such that Null->1 *)
	intNumberOfReplicates=numberOfReplicates/.{Null->1};

	(* Find the number of primary input samples *)
	numberOfSamples=Length[simulatedSamples];

	(* Figure out how many sample capillaries there will be *)
	numberOfSampleCapillaries=(numberOfSamples*intNumberOfReplicates);

	(* If we have more than 12 capillaries designated for samples and their replicates, then we will need the 25 capillary cartridge and more of the fixed-aliquot resources - otherwise, the 13 capillary cartridge and one each of the fixed-aliquot resources *)
	smallCartridgeQ=If[numberOfSampleCapillaries>12,
		False,
		True
	];

	(* If NumberOfReplicates is too large for the number of input samples, then the option is invalid *)
	numberOfReplicatesInvalidOption=Which[

		(* If there are more than 24 input samples, it is the inputs and not the NumberOfReplicates that is invalid *)
		numberOfSamples>24,
			{},

		(* If the number of replicates times number of input samples is greater than 24, the NumberOfReplicates is invalid *)
		(numberOfSamples*intNumberOfReplicates)>24,
			{NumberOfReplicates},

		(* Otherwise, the NumberOfReplicates option is fine *)
		True,{}
	];

	(* If number of replicates is too high, and we are throwing messages, throw an error *)
	If[Length[numberOfReplicatesInvalidOption]!=0&&messages,
		Message[Error::NumberOfReplicatesTooHighForNumberOfWesInputSamples,numberOfSamples,intNumberOfReplicates]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	numberOfReplicatesTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[numberOfReplicatesInvalidOption]==0,
				Nothing,
				Test["The product of the number of input samples and the NumberOfReplicates option is not greater than 24",True,False]
			];
			passingTest=If[Length[numberOfReplicatesInvalidOption]!=0,
				Nothing,
				Test["The product of the number of input samples and the NumberOfReplicates option is not greater than 24",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to see if the Denaturing, DenaturingTemperature, and DenaturingTime options are compatible with eachother - *)
	invalidDenaturingOptions=Switch[{suppliedDenaturing,suppliedDenaturingTemperature,suppliedDenaturingTime},

		(* If Denaturing is Automatic, and neither DenaturingTime/Temperature are Null, there is no issue *)
		{Automatic,Except[Null],Except[Null]},
			{},

		(* If Denaturing is Automatic, and one of DenaturingTime/Temp is Null and the other is Automatic, there is no issue *)
		{Automatic,Null,Automatic},
			{},
		{Automatic,Automatic,Null},
			{},

		(* If Denaturing is Automatic, DenaturingTemperature is Null, and DenaturingTime is set to anything besides Null|Automatic, the options are in conflict *)
		{Automatic,Null,Except[Null|Automatic]},
			{DenaturingTemperature,DenaturingTime},

		(* If Denaturing is Automatic, DenaturingTime is Null, and DenaturingTemperature is set to anything besides Null|Automatic, the options are in conflict *)
		{Automatic,Except[Null|Automatic],Null},
			{DenaturingTemperature,DenaturingTime},

		(* If Denaturing is set to False, and both DenaturingTemperature and DenaturingTime are Null|Automatic, there is no issue *)
		{False,Null|Automatic,Null|Automatic},
			{},

		(* If Denaturing is set to False, and DenaturingTime OR DenaturingTime is set to anything besides Automatic|Null, the options are in conflict*)
		{False,Except[Null|Automatic],_},
			{Denaturing,DenaturingTemperature,DenaturingTime},
		{False,_,Except[Null|Automatic]},
			{Denaturing,DenaturingTemperature,DenaturingTime},

		(* If Denaturing is set to True, and neither DenaturingTemperature nor DenaturingTime are set to Null, there is no issue *)
		{True,Except[Null],Except[Null]},
			{},

		(* If Denaturing is set to True, and either DenaturingTemperature or DenaturingTime are set to Null, the options are in conflict *)
		{True,Null,_},
			{Denaturing,DenaturingTemperature,DenaturingTime},
		{True,_,Null},
			{Denaturing,DenaturingTemperature,DenaturingTime}
	];

	(* If the Denaturing-related options are in conflict, and we are throwing messages, throw an error *)
	If[Length[invalidDenaturingOptions]!=0&&messages,
		Message[Error::ConflictingWesDenaturingOptions,invalidDenaturingOptions]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingDenaturingOptionsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidDenaturingOptions]==0,
				Nothing,
				Test["The Denaturing, DenaturingTemperature, and DenaturingTime options are in conflict with each other.",True,False]
			];
			passingTest=If[Length[invalidDenaturingOptions]!=0,
				Nothing,
				Test["The Denaturing, DenaturingTemperature, and DenaturingTime options are in conflict with each other.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(* - Check to make sure that the SystemStandard options will be able to be resolved - *)
	(* First, define a helper function that will make sure the SystemStandard, StandardPrimaryAntibody, StandardPrimaryAntibodyVolume,StandardSecondaryAntibody, and StandardSecondaryAntibodyVolumes will be able to be resolved for each input *)
	conflictingWesSystemStandardOptions[systemStandard_,standardPrimaryAb_,standardPrimaryAbVolume_,standardSecondaryAb_,standardSecondaryAbVolume_]:=Module[
		{optionsConflictingQ},

		(* In the following Switch statement, determine if Standard options for this given replicate are conflicting *)
		optionsConflictingQ=Switch[{systemStandard,standardPrimaryAb,standardPrimaryAbVolume,standardSecondaryAb,standardSecondaryAbVolume},

			(* If SystemStandard is False, all of the Standard Antibody-related options must be Null or Automatic, otherwise they are conflicting *)
			{False,Null|Automatic,Null|Automatic,Null|Automatic,Null|Automatic},
				False,
			{False,_,_,_,_},
				True,

			(* If SystemStandard is True, the StandardPrimaryAntibody-related options cannot be Null (the Secondary ones can be Null, depending on the Organism of the primary Ab, so won't check that here *)
			{True,Except[Null],Except[Null],_,_},
				False,
			{True,_,_,_,_},
				True
		];

		(* Return optionsConflictingQ *)
		optionsConflictingQ
	];

	(* Define a boolean that determines if the SystemStandard options are in conflict for any of the inputs, if we are in Western, or TotalProteinDetection (where these options do not exist) *)
	conflictingSystemStandardOptionsQ=If[

		(* If we are in ExperimentTotalProteinDetection then these options do not exist, and so they are not conflicting *)
		!westernQ,False,

		(* Otherwise, we are in ExperimentWestern, check to see if conflictingSystemStandardOptions returns True for the SystemStandard Options for any input *)
		MemberQ[
			MapThread[
				conflictingWesSystemStandardOptions,{suppliedSystemStandard,suppliedStandardPrimaryAntibody,suppliedStandardPrimaryAntibodyVolume,suppliedStandardSecondaryAntibody,suppliedStandardSecondaryAntibodyVolume}
			],
			True
		]
	];

	(* If the system standard options are conflicting, define them so we can throw error *)
	invalidSystemStandardOptions=If[conflictingSystemStandardOptionsQ,
		{SystemStandard,StandardPrimaryAntibody,StandardPrimaryAntibodyVolume,StandardSecondaryAntibody,StandardSecondaryAntibodyVolume},
		{}
	];

	(* If we are in ExperimentWestern and throwing messages, throw an error if the SystemStandard Options cannot be resolved *)
	If[westernQ&&conflictingSystemStandardOptionsQ&&messages,
		Message[Error::ConflictingWesSystemStandardOptions,invalidSystemStandardOptions]
	];

	(* If we are gathering tests and are in ExperimentWestern, create a passing and/or failing test with the appropriate result. *)
	conflictingSystemStandardOptionsTests=If[gatherTests&&westernQ,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidSystemStandardOptions]==0,
				Nothing,
				Test["The SystemStandard-related options, {SystemStandard,StandardPrimaryAntibody,StandardPrimaryAntibodyVolume,StandardSecondaryAntibody,StandardSecondaryAntibodyVolume}, are not in conflict and can be resolved.",True,False]
			];
			passingTest=If[Length[invalidSystemStandardOptions]!=0,
				Nothing,
				Test["The SystemStandard-related options, {SystemStandard,StandardPrimaryAntibody,StandardPrimaryAntibodyVolume,StandardSecondaryAntibody,StandardSecondaryAntibodyVolume}, are not in conflict and can be resolved.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to make sure that the pairs of related Object/Volume options will be able to be resolved (one cannot be Null while the other is set) - *)
	(* First, write a helper function that we will MapThread over that lists of paired options and check if they are in conflict before resolution *)
	conflictingWesNullOptions[option1_,option2_]:=Module[
		{optionsConflictingQ},

		(* In the following Switch statement, determine if options for this given replicate are conflicting *)
		optionsConflictingQ=Switch[{option1,option2},

			(* If option1 is Null and option2 is set, they are in conflict *)
			{Null,Except[Null|Automatic]},
				True,
			{Except[Null|Automatic]},
				True,

			(* In all other cases, the options will be able to be resolved *)
			{_,_},
				False
		];

		(* Return optionsConflictingQ *)
		optionsConflictingQ
	];

	(* Determine if PrimaryAntibodyDiluent and PrimaryAntibodyDiluentVolume options are in conflict*)
	conflictingNullPrimaryAntibodyDiluentOptionsQ=If[

		(* If we are in ExperimentTotalProteinDetection then these options do not exist, and so they are not conflicting *)
		!westernQ,False,

		(* Otherwise, we are in ExperimentWestern, check to see if conflictingWesNullOptions returns True for any input *)
		MemberQ[
			MapThread[
				conflictingWesNullOptions,{suppliedPrimaryAntibodyDiluent,suppliedPrimaryAntibodyDiluentVolume}
			],
			True
		]
	];

	(* Do not need to perform this check for StandardPrimaryAntibody/Volume options because the above SystemStandard conflicting options contains this check *)
	(* Determine if StandardSecondaryAntibody and StandardSecondaryAntibodyVolume options are in conflict*)
	conflictingNullStandardSecondaryAntibodyOptionsQ=If[

	(* If we are in ExperimentTotalProteinDetection then these options do not exist, and so they are not conflicting *)
		!westernQ,False,

	(* Otherwise, we are in ExperimentWestern, check to see if conflictingWesNullOptions returns True for any input *)
		MemberQ[
			MapThread[
				conflictingWesNullOptions,{suppliedStandardSecondaryAntibody,suppliedStandardSecondaryAntibodyVolume}
			],
			True
		]
	];

	(* Define a list of the options that cannot be resolved because one is Null and the other is set *)
	{invalidConflictingNullOptions,validConflictingNullOptions}=Which[

		(* If we are in ExperimentTotalProteinDetection, none of these are conflicting because they don't exist *)
		!westernQ,
			{{},{}},

		(* In Western, if both pairs of options are conflicting, define all 4 options as invalid *)
		conflictingNullPrimaryAntibodyDiluentOptionsQ&&conflictingNullStandardSecondaryAntibodyOptionsQ,
			{{PrimaryAntibodyDiluent,PrimaryAntibodyDiluentVolume,StandardSecondaryAntibody,StandardSecondaryAntibodyVolume},{}},

		(* If only the antibodydiluent options are conflicting, or only the standard secondary antibody ones, define them *)
		conflictingNullPrimaryAntibodyDiluentOptionsQ,
			{{PrimaryAntibodyDiluent,PrimaryAntibodyDiluentVolume},{StandardSecondaryAntibody,StandardSecondaryAntibodyVolume}},

		conflictingNullStandardSecondaryAntibodyOptionsQ,
			{{StandardSecondaryAntibody,StandardSecondaryAntibodyVolume},{PrimaryAntibodyDiluent,PrimaryAntibodyDiluentVolume}},

		(* Otherwise, none of the options are conflicting *)
		True,
			{{},{PrimaryAntibodyDiluent,PrimaryAntibodyDiluentVolume,StandardSecondaryAntibody,StandardSecondaryAntibodyVolume}}
	];

	(* If we are throwing messages, throw an error if there are any conflicting Null option pairs that cannot be resolved *)
	If[Length[invalidConflictingNullOptions]>0&&messages,
		Message[Error::ConflictingWesNullOptions,invalidConflictingNullOptions]
	];

	(* If we are gathering tests and are in ExperimentWestern, create a passing and/or failing test with the appropriate result. *)
	conflictingNullOptionsTests=If[gatherTests&&westernQ,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidConflictingNullOptions]==0,
				Nothing,
				Test["The following option pairs are conflicting because one is Null and its partner is set to a value other than Null or Automatic "<>ToString[invalidConflictingNullOptions],True,False]
			];
			passingTest=If[Length[validConflictingNullOptions]==0,
				Nothing,
				Test["The following option pairs are conflicting because one is Null and its partner is set to a value other than Null or Automatic "<>ToString[validConflictingNullOptions],True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to see that the LoadingVolume is larger than the sum of the SampleVolume and the LoadingBufferVolume for each input - *)
	(* First, make a list of the samples for which the LoadingVolume is less than the sum of the SampleVolume and the LoadingBufferVolume *)
	expandedLoadingVolume=ConstantArray[suppliedLoadingVolume,numberOfSamples];

	(* Make a list of the samples that have loading volumes that are too large and those that are okay - this will never be a problem unless the user changes the default values *)
	loadingVolumeTooLargeSamples=PickList[simulatedSamples,((suppliedSampleVolume+suppliedLoadingBufferVolume)-expandedLoadingVolume),LessP[0*Microliter]];
	loadingVolumeFineSamples=PickList[simulatedSamples,((suppliedSampleVolume+suppliedLoadingBufferVolume)-expandedLoadingVolume),GreaterEqualP[0*Microliter]];

	(* Define invalid LoadingVolume options *)
	invalidLoadingVolumeOptions=If[Length[loadingVolumeTooLargeSamples]>0,
		{SampleVolume,LoadingBufferVolume,LoadingVolume},
		{}
	];

	(* If we are throwing messages, throw an error if there are any samples in loadingVolumeTooLargeSamples - will for sure yield undesired results *)
	If[messages&&Length[invalidLoadingVolumeOptions]>0,
		Message[Error::WesternLoadingVolumeTooLarge,ObjectToString[loadingVolumeTooLargeSamples,Cache->simulatedCache]]
	];

	(* If we are gathering tests, write a passing/failing test for the WesternLoadingVolumeTooLarge Warning message *)
	loadingVolumeTooLargeTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[Length[loadingVolumeTooLargeSamples]==0,
				Nothing,
				Test["The LoadingVolume is smaller than the sum of the SampleVolume and the LoadingBufferVolume for the following input samples, "<>ObjectToString[loadingVolumeTooLargeSamples,Cache->simulatedCache],True,False]
			];
			passingTest=If[Length[loadingVolumeFineSamples]==0,
				Nothing,
				Test["The LoadingVolume is smaller than the sum of the SampleVolume and the LoadingBufferVolume for the following input samples, "<>ObjectToString[loadingVolumeFineSamples,Cache->simulatedCache],True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to make sure that if the PrimaryAntibodyDilutionFactor is set to 1, the PrimaryAntibodyDiluent and PrimaryAntibodyDiluent must both be Null or Automatic - *)
	(* MapThread over a function that checks whether the 3 options are copacetic to give a list of Booleans *)
	conflictingDilutionFactorOptionsQ=If[westernQ,
		MapThread[
			Function[{primaryAntibodyDilutionFactor,primaryAntibodyDiluent,primaryAntibodyDiluentVolume},

				Module[{dilutionFactorIsOneQ,conflictingOptionsQ},
					(* Determine if the Dilution Factor is equal to 1 - Automatic gives False *)
					dilutionFactorIsOneQ=MatchQ[primaryAntibodyDilutionFactor,_?(Equal[#, 1] &)];

					conflictingOptionsQ=Which[

						(* If the dilution factor is 1 and the primary Ab Diluent is set, that is a problem *)
						dilutionFactorIsOneQ&&MatchQ[primaryAntibodyDiluent,
							Except[Null|Automatic]],True,

						(* If the dilution factor is 1 and the primary Ab Diluent volume is set, that is a problem *)
						dilutionFactorIsOneQ&&MatchQ[primaryAntibodyDiluentVolume,
							Except[Null|Automatic]],True,

						(* Otherwise, its all good - the options will be able to be resolved *)
						True,
							False
					];

					(* Return conflictingOptionsQ *)
					conflictingOptionsQ
				]
			],
			{suppliedPrimaryAntibodyDilutionFactor,suppliedPrimaryAntibodyDiluent,suppliedPrimaryAntibodyDiluentVolume}
		],
		{}
	];

	(* Create a list of the samples for which these three options are conflicting and for which they're alright *)
	conflictingAbDilutionSamples=If[westernQ,
		PickList[simulatedSamples,conflictingDilutionFactorOptionsQ,True],
		{}
	];
	nonConflictingAbDilutionSamples=If[westernQ,
		PickList[simulatedSamples,conflictingDilutionFactorOptionsQ,False],
		{}
	];

	(* Define the PrimaryAntibodyDilution options that are invalid *)
	invalidAntibodyDilutionOptions=If[Length[conflictingAbDilutionSamples]>0,
		{PrimaryAntibodyDilutionFactor,PrimaryAntibodyDiluent,PrimaryAntibodyDiluentVolume},
		{}
	];

	(* If we are throwing messages, throw an error if there are any samples in conflictingAbDilutionSamples *)
	If[messages&&westernQ&&Length[invalidAntibodyDilutionOptions]>0,
		Message[Error::ConflictingWesternAntibodyDiluentOptions,ObjectToString[conflictingAbDilutionSamples,Cache->simulatedCache]]
	];

	(* If we are gathering tests and are in ExperimentWestern, define the user-facing tests for the above error *)
	conflictingAntibodyDilutionTests=If[gatherTests&&westernQ,
		Module[{failingTest,passingTest},

			failingTest=If[Length[conflictingAbDilutionSamples]==0,
				Nothing,
				Test["If the PrimaryAntibodyDilutionFactor is set to 1, the PrimaryAntibodyDiluent and PrimaryAntibodyDiluentVolume options are both left as Null or Automatic for the following input samples, "<>ObjectToString[conflictingAbDilutionSamples,Cache->simulatedCache],True,False]
			];
			passingTest=If[Length[nonConflictingAbDilutionSamples]==0,
				Nothing,
				Test["If the PrimaryAntibodyDilutionFactor is set to 1, the PrimaryAntibodyDiluent and PrimaryAntibodyDiluentVolume options are both left as Null or Automatic for the following input samples, "<>ObjectToString[nonConflictingAbDilutionSamples,Cache->simulatedCache],True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to make sure the SignalDetectionTimes are the default value, otherwise throw a warning because high dynamic range (HDR) image processing will not occur - *)
	(* First, set a boolean that just checks if they are the default or not *)
	idealSignalDetectionTimesBoolean=If[

		(* IF the SignalDetectionTimes are the default values *)
		Equal[suppliedSignalDetectionTimes,{1*Second,2*Second,4*Second,8*Second,16*Second,32*Second,64*Second,128*Second,512*Second}],

		(* THEN they are ideal *)
		True,

		(* ELSE, they are not and we will need to throw a warning about the HDR imaging *)
		False
	];

	(* If we are throwing messages, throw a warning if the SignalDetectionTimes are not the default times *)
	If[messages&&!idealSignalDetectionTimesBoolean,
		Message[Warning::WesHighDynamicRangeImagingNotPossible,suppliedSignalDetectionTimes]
	];

	(* If we are gathering tests, define the user-facing tests for the above error *)
	nonOptimalSignalDetectionTimesTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[idealSignalDetectionTimesBoolean,
				Nothing,
				Warning["The SignalDetectionTimes, "<>ToString[suppliedSignalDetectionTimes]<>", are the default values and can be used for High Dynamic Range (HDR) image processing.",True,False]
			];

			passingTest=If[!idealSignalDetectionTimesBoolean,
				Nothing,
				Warning["The SignalDetectionTimes, "<>ToString[suppliedSignalDetectionTimes]<>", are the default values and can be used for High Dynamic Range (HDR) image processing.",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- RESOLVE EXPERIMENT OPTIONS --- *)
	(* - Define the patterns that will be used below for option resolution -*)
	(* This is the pattern for determining whether or not a user-specified MolecularWeightRange is ideal for the Antibodies provided *)
	acceptableMWRangeP=Alternatives[
		{LowMolecularWeight,RangeP[0*Kilogram/Mole,40*Kilogram/Mole]},
		{MidMolecularWeight,RangeP[12*Kilogram/Mole,120*Kilogram/Mole]},
		{HighMolecularWeight,GreaterP[66*Kilogram/Mole]},
		{_,Null}
	];

	(* - Variables to set to make sure resolution below works with both Model or Object Option inputs - *)

	(* Set ladderOptionModel to be the Model (by ID) of the input Ladder - Null if Automatic *)
	ladderOptionModel=Lookup[ladderOptionPacket,Object,Null];

	(* -- Master switch resolution -- *)
	(* - Resolve Denaturing option - *)
	resolvedDenaturing=Switch[{suppliedDenaturing,suppliedDenaturingTime,suppliedDenaturingTemperature,suppliedDenaturant},

		(* If the user has set the Denaturing option, we accept their option *)
		{Except[Automatic],_,_,_},
			suppliedDenaturing,

		(* If Denaturing is Automatic, and either DenaturingTime, DenaturingTemperature, or Denaturant is Null, we resolve Denaturing to False *)
		{Automatic,Null,_,_},
			False,
		{Automatic,_,Null,_},
			False,
		{Automatic,_,_,Null},
			False,

		(* Otherwise, we resolve Denaturing to True as this is the case in most experiments *)
		{_,_,_,_},
			True
	];

	(* - Resolve the MolecularWeightRange - *)
	(* Resolve the MolecularWeightRange option, and set an error boolean if the user-set MWR option is not ideal for the input antibodies *)
	{resolvedMolecularWeightRange,nonOptimalAntibodyQ}=If[westernQ,

		(* If we are in ExperimentWestern, we resolve MolecularWeightRange based on the ExpectedMolecularWeight of the input Antibodies average ExpectedMolecularWeight *)
		Switch[{suppliedMolecularWeightRange,averageTargetMolecularWeight},
			(* In the case the user does not supply a MolecularWeightRange, we resolve the option based on the averageTargetMolecularWeight of the input antibodies *)
			{Automatic,RangeP[12*Kilogram/Mole,120*Kilogram/Mole]},
				{MidMolecularWeight,False},
			{Automatic,RangeP[0*Kilogram/Mole,12*Kilogram/Mole]},
				{LowMolecularWeight,False},
			{Automatic,GreaterP[120*Kilogram/Mole]},
				{HighMolecularWeight,False},

			(* In the case where none of the antibody inputs have ExpectedMolecularWeight populated, default to MidMolecularWeight *)
			{Automatic,Null},
				{MidMolecularWeight,False},

			(* If the user has set the MolecularWeightRange, we accept their option, but define a warning bool if the range specified doesn't include the averageTargetMolecularWeight of the antibody inputs *)
			{Except[Automatic],_},
				{suppliedMolecularWeightRange,If[MatchQ[{suppliedMolecularWeightRange,averageTargetMolecularWeight},acceptableMWRangeP],
					False,
					True
				]}
		],

		(* If we are in ExperimentTotalProteinDetection, we resolve MolecularWeightRange based on the protein average MW or the ladder *)
		Switch[{suppliedMolecularWeightRange,ladderOptionModel},

			(* In the case that the MolecularWeightRange was set, we accept the user's option, and do not need to do a further check *)
			{Except[Automatic],_},
				{suppliedMolecularWeightRange,False},


			(* In the cases where the MolecularWeightRange is Automatic and the Ladder was set as one of the standard ladders, set the MolecularWeightRange based on the ladder *)
			{Automatic,Alternatives[Model[Sample, StockSolution, "id:9RdZXv19qm0a"],Model[Sample, StockSolution, "id:GmzlKjPRDqlN"]]},
				{HighMolecularWeight,False},
			{Automatic,Alternatives[Model[Sample, StockSolution, "id:N80DNj1kKeeo"],Model[Sample, StockSolution, "id:eGakldJDAjle"]]},
				{MidMolecularWeight,False},
			{Automatic,Alternatives[Model[Sample, StockSolution, "id:1ZA60vLP1eJ8"]]},
				{LowMolecularWeight,False},

			(* In any other cases (if the Ladder is left as Automatic, or is not set as one of the preferred ladders), we resolve MolecularWeightRange to MidMolecularWeight *)
			{Automatic,_},
				{MidMolecularWeight,False}
		]
	];

	(* If we are in Western and throwing messages, throw a warning if we have determined that the user-supplied MolecularWeightRange is not optimal *)
	If[nonOptimalAntibodyQ&&westernQ&&messages&&notInEngine,
		Message[Warning::NonOptimalUserSuppliedWesMolecularWeightRange,suppliedMolecularWeightRange,averageTargetMolecularWeight]
	];

	(* If we are gathering tests, define the user-facing tests for NonOptimalUserSuppliedWesMolecularWeightRange *)
	nonOptimalMolecularWeightRangeTests=If[gatherTests&&westernQ,
		Module[{failingTest,passingTest},

			failingTest=If[!nonOptimalAntibodyQ,
				Nothing,
				Warning["The MolecularWeightRangeOption, "<>ToString[resolvedMolecularWeightRange]<>", is ideal for the input Antibodies ExpectedMolecularWeights",True,False]
			];

			passingTest=If[nonOptimalAntibodyQ,
				Nothing,
				Warning["The MolecularWeightRangeOption, "<>ToString[resolvedMolecularWeightRange]<>", is ideal for the input Antibodies ExpectedMolecularWeights",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Resolve independent options -- *)
	(* - Resolve the DenaturingTemperature - *)
	resolvedDenaturingTemperature=Switch[{suppliedDenaturingTemperature,resolvedDenaturing},

		(* In the case where the user has set the DenaturingTemperature, we accept their option (we have already done error checking above) *)
		{Except[Automatic],_},
			suppliedDenaturingTemperature,

		(* In the case where DenaturingTemperature is left as automatic, we resolve DenaturingTemperature based on if we have resolved Denaturing to True or False *)
		{Automatic,True},
			95*Celsius,
		{Automatic,False},
			Null
	];

	(* - Resolve the DenaturingTime - *)
	resolvedDenaturingTime=Switch[{suppliedDenaturingTime,resolvedDenaturing},

		(* In the case where the user has set the DenaturingTime, we accept their option (we have already done error checking above) *)
		{Except[Automatic],_},
			suppliedDenaturingTime,

		(* In the case where DenaturingTime is left as automatic, we resolve DenaturingTime based on if we have resolved Denaturing to True or False *)
		{Automatic,True},
			5*Minute,
		{Automatic,False},
			Null
	];

	(* - Resolve the Ladder - *)

	(* First, set a variable that is the Model (by ID) of the ConcentratedLoadingBuffer Option - Null if Automatic *)
	concentratedLoadingBufferOptionModel=Lookup[concentratedLoadingBufferOptionPacket,Object,Null];

	(* Resolve Ladder and set warning boolean *)
	{resolvedLadder,nonOptimalLadderQ}=Switch[{ladderOptionModel,concentratedLoadingBufferOptionModel,resolvedMolecularWeightRange},

		(* - In the case where the user has not set the Ladder Option (suppliedLadder is Automatic and ladderOptionModel is Null), we resolve it based on the either the Model of the supplied ConcentratedLoadingBuffer, or the MolecularWeightRange we have resolved to - *)
		(* First, we check if the ConcentratedLoadingBuffer has been set to one of the SimpleWestern kit versions - if it is, we resolve the ladder to the same kit version, so the user doesn't have to buy multiple kits *)
		(* EZ Standard Pack 1 *)
		{Null,Model[Sample, StockSolution, "id:R8e1PjpY5X5d"],_},
			{Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 12-230 kDa) - EZ Standard Pack 1"],False},

		(* EZ Standard Pack 2 *)
		{Null,Model[Sample, StockSolution, "id:4pO6dM5jeENB"],_},
			{Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 12-230 kDa) - EZ Standard Pack 2"],False},

		(* EZ Standard Pack 3 *)
		{Null,Model[Sample, StockSolution, "id:4pO6dM5jewLo"],_},
			{Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 66-440 kDa) - EZ Standard Pack 3"],False},

		(* EZ Standard Pack 4 *)
		{Null,Model[Sample, StockSolution, "id:XnlV5jKO0R1P"],_},
			{Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 66-440 kDa) - EZ Standard Pack 4"],False},

		(* EZ Standard Pack 5 *)
		{Null,Model[Sample, StockSolution, "id:n0k9mG8K3Ydp"],_},
			{Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 2-40 kDa) - EZ Standard Pack 5"],False},

		(* Next, if the ConcentratedLoadingBuffer has not been set, or is not one of the optimal loading buffers, we resolve the Ladder option based on the resolvedMolecularWeightRange *)
		{Null,_,LowMolecularWeight},
			{Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 2-40 kDa) - EZ Standard Pack 5"] ,False},
		{Null,_,MidMolecularWeight},
			{Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 12-230 kDa) - EZ Standard Pack 1"],False},
		{Null,_,HighMolecularWeight},
			{Model[Sample,StockSolution,"Simple Western Biotinylated Ladder Solution (MW 66-440 kDa) - EZ Standard Pack 3"],False},

		(* In cases where the supplied Ladder is one of the optimal ladders for the MolecularWeightRange, we accept it and there will be no warning *)
		{Alternatives[Model[Sample, StockSolution, "id:1ZA60vLP1eJ8"]],_,LowMolecularWeight},
			{suppliedLadder,False},
		{Alternatives[Model[Sample, StockSolution, "id:N80DNj1kKeeo"],Model[Sample, StockSolution, "id:eGakldJDAjle"]],_,MidMolecularWeight},
			{suppliedLadder,False},
		{Alternatives[Model[Sample, StockSolution, "id:9RdZXv19qm0a"],Model[Sample, StockSolution, "id:GmzlKjPRDqlN"]],_,HighMolecularWeight},
			{suppliedLadder,False},

		(* In other cases, where the user has set the Ladder option but its not ideal for the resolved MolecularWeightRange, we accept their option, but will throw a warning *)
		{_,_,_},
			{suppliedLadder,True}
	];

	(* If we are throwing messages, throw a warning if the user-supplied ladder is not optimal for the resolved MolecularWeightRange *)
	If[nonOptimalLadderQ&&messages&&notInEngine,
		Message[Warning::WesLadderNotOptimalForMolecularWeightRange,suppliedLadder,resolvedMolecularWeightRange]
	];

	(* If we are gathering tests, define the user-facing tests for WesLadderNotOptimalForMolecularWeightRange *)
	nonOptimalLadderTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[!nonOptimalLadderQ,
				Nothing,
				Warning["The Ladder option, "<>ToString[resolvedLadder]<>", is optimal for the MolecularWeightRange option, "<>ToString[resolvedMolecularWeightRange],True,False]
			];

			passingTest=If[nonOptimalLadderQ,
				Nothing,
				Warning["The Ladder option, "<>ToString[resolvedLadder]<>", is optimal for the MolecularWeightRange option, "<>ToString[resolvedMolecularWeightRange],True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Resolve the LuminescenceReagent - *)
	resolvedLuminescenceReagent=Which[

		(* If the user has set the LuminescenceReagent, we accept their choice *)
		MatchQ[suppliedLuminescenceReagent,Except[Automatic]],
			suppliedLuminescenceReagent,

		(* Otherwise, we resolve the Luminescence reagent based on if we are in ExperimentWestern or ExperimentTotalProteinDetection *)
		westernQ,
			Model[Sample,StockSolution,"SimpleWestern Luminescence Reagent"],

		(* In TotalProteinDetection, we need to use the reagents that come in the TotalProtein Kit *)
		True,
			Model[Sample,StockSolution,"SimpleWestern Luminescence Reagent - Total Protein Kit"]
	];

	(* - Resolve the StackingMatrixLoadTime - *)
	resolvedStackingMatrixLoadTime=Switch[{suppliedStackingMatrixLoadTime,resolvedMolecularWeightRange},

		(* If the user has specified a StackingMatrixLoadTime, we accept their option *)
		{Except[Automatic],_},
			suppliedStackingMatrixLoadTime,

		(* Otherwise, we resolve the option based on the MolecularWeightRange *)
		{Automatic,MidMolecularWeight},
			15*Second,
		{Automatic,_},
			12*Second
	];

	(* - Resolve the SampleLoadTime - *)
	resolvedSampleLoadTime=Switch[{suppliedSampleLoadTime,resolvedMolecularWeightRange},

		(* If the user has specified a SampleLoadTime, we accept their option *)
		{Except[Automatic],_},
			suppliedSampleLoadTime,

		(* Otherwise, we resolve the option based on the MolecularWeightRange *)
		{Automatic,HighMolecularWeight},
			8*Second,
		{Automatic,_},
			9*Second
	];

	(* - Resolve the Voltage - *)
	resolvedVoltage=Switch[{suppliedVoltage,resolvedMolecularWeightRange},

		(* If the user has specified a Voltage, we accept their option *)
		{Except[Automatic],_},
			suppliedVoltage,

		(* Otherwise, we resolve the option based on the MolecularWeightRange *)
		{Automatic,HighMolecularWeight},
			475*Volt,
		{Automatic,_},
			375*Volt
	];

	(* - Resolve the SeparationTime - *)
	resolvedSeparationTime=Switch[{suppliedSeparationTime,resolvedMolecularWeightRange},

		(* If the user has specified a SeparationTime, we accept their option *)
		{Except[Automatic],_},
			suppliedSeparationTime,

		(* Otherwise, we resolve the option based on the MolecularWeightRange *)
		{Automatic,LowMolecularWeight},
			1620*Second,
		{Automatic,MidMolecularWeight},
			1500*Second,
		{Automatic,HighMolecularWeight},
			1800*Second
	];

	(* - Resolve the UVExposureTime - *)
	resolvedUVExposureTime=Switch[{suppliedUVExposureTime,resolvedMolecularWeightRange},

		(* If the user has specified a UVExposureTime, we accept their option *)
		{Except[Automatic],_},
			suppliedUVExposureTime,

		(* Otherwise, we resolve the option based on the MolecularWeightRange *)
		{Automatic,HighMolecularWeight},
			150*Second,
		{Automatic,_},
			200*Second
	];

	(* - WashBuffer does not need to be resolved, but we should check to make sure the WashBuffer option is of the optimal Model - *)
	(* First, set a variable that is the Model (by ID) of the WashBuffer Option *)
	washBufferOptionModel=Lookup[washBufferOptionPacket,Object,Null];

	(* Set a boolean that says whether the supplied wash buffer is of the ideal model or not *)
	nonOptimalWashBufferQ=If[MatchQ[washBufferOptionModel,Model[Sample, "id:WNa4ZjKM4zMR"]],
		False,
		True
	];

	(* If the WashBuffer is non optimal and we are throwing messages, throw a warning *)
	If[nonOptimalWashBufferQ&&messages&&notInEngine,
		Message[Warning::WesWashBufferNotOptimal,suppliedWashBuffer]
	];

	(* If we are gathering tests, define the user-facing tests for WesWashBufferNotOptimal *)
	nonOptimalWashBufferTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[!nonOptimalWashBufferQ,
				Nothing,
				Warning["The WashBuffer option, "<>ToString[suppliedWashBuffer]<>", is optimal for the Experiment",True,False]
			];

			passingTest=If[nonOptimalWashBufferQ,
				Nothing,
				Warning["The WashBuffer option, "<>ToString[suppliedWashBuffer]<>", is optimal for the Experiment",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Resolve the ConcentratedLoadingBuffer - *)
	(* Resolve ConcentratedLoadingBuffer and set warning boolean *)
	{resolvedConcentratedLoadingBuffer,nonOptimalConcentratedLoadingBufferQ}=Switch[{concentratedLoadingBufferOptionModel,ladderOptionModel,resolvedMolecularWeightRange},

		(* - In the case where the user has not set the ConcentratedLoadingBuffer Option (suppliedConcentratedLoadingBuffer is Automatic and concentratedLoadingBufferOptionModel is Null), we resolve it based on the either the Model of the supplied Ladder, or the MolecularWeightRange we have resolved to - *)
		(* First, we check if the Ladder has been set to one of the SimpleWestern kit versions - if it is, we resolve the ladder to the same kit version, so the user doesn't have to buy multiple kits *)
		(* EZ Standard Pack 1 *)
		{Null,Model[Sample, StockSolution, "id:N80DNj1kKeeo"],_},
			{Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 29 kDa System Control - EZ Standard Pack 1"],False},

		(* EZ Standard Pack 2 *)
		{Null,Model[Sample, StockSolution, "id:eGakldJDAjle"],_},
			{Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 180 kDa System Control - EZ Standard Pack 2"],False},

		(* EZ Standard Pack 3 *)
		{Null,Model[Sample, StockSolution, "id:9RdZXv19qm0a"],_},
			{Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 90 kDa System Control - EZ Standard Pack 3"],False},

		(* EZ Standard Pack 4 *)
		{Null,Model[Sample, StockSolution, "id:GmzlKjPRDqlN"],_},
			{Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 200 kDa System Control - EZ Standard Pack 4"],False},

		(* EZ Standard Pack 4 *)
		{Null,Model[Sample, StockSolution, "id:1ZA60vLP1eJ8"],_},
			{Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 26 kDa System Control - EZ Standard Pack 5"],False},

		(* Next, if the Ladder has not been set, or is not one of the optimal ladders, we resolve the ConcentratedLoadingBuffer option based on the resolvedMolecularWeightRange *)
		{Null,_,LowMolecularWeight},
			{Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 26 kDa System Control - EZ Standard Pack 5"],False},
		{Null,_,MidMolecularWeight},
			{Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 29 kDa System Control - EZ Standard Pack 1"],False},
		{Null,_,HighMolecularWeight},
			{Model[Sample,StockSolution,"Simple Western 10X Sample Buffer and Fluorescent Standards Solution with 90 kDa System Control - EZ Standard Pack 3"],False},

		(* In cases where the supplied ConcentratedLoadingBuffer is one of the optimal ConcentratedLoadingBuffers for the MolecularWeightRange, we accept it and there will be no warning *)
		{Alternatives[Model[Sample, StockSolution, "id:n0k9mG8K3Ydp"]],_,LowMolecularWeight},
			{suppliedConcentratedLoadingBuffer,False},
		{Alternatives[Model[Sample, StockSolution, "id:R8e1PjpY5X5d"],Model[Sample, StockSolution, "id:4pO6dM5jeENB"]],_,MidMolecularWeight},
			{suppliedConcentratedLoadingBuffer,False},
		{Alternatives[Model[Sample, StockSolution, "id:4pO6dM5jewLo"],Model[Sample, StockSolution, "id:XnlV5jKO0R1P"]],_,HighMolecularWeight},
			{suppliedConcentratedLoadingBuffer,False},

		(* In other cases, where the user has set the ConcentratedLoadingBuffer option but it is not ideal for the resolved MolecularWeightRange, we accept their option, but will throw a warning *)
		{_,_,_},
			{suppliedConcentratedLoadingBuffer,True}
	];

	(* If we are throwing messages, throw a warning if the user-supplied ConcentratedLoadingBuffer is not optimal for the resolved MolecularWeightRange *)
	If[nonOptimalConcentratedLoadingBufferQ&&messages&&notInEngine,
		Message[Warning::WesConcentratedLoadingBufferNotOptimal,suppliedConcentratedLoadingBuffer,resolvedMolecularWeightRange]
	];

	(* If we are gathering tests, define the user-facing tests for WesConcentratedLoadingBufferNotOptimal *)
	nonOptimalConcentratedLoadingBufferTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[!nonOptimalConcentratedLoadingBufferQ,
				Nothing,
				Warning["The ConcentratedLoadingBuffer option, "<>ToString[resolvedConcentratedLoadingBuffer]<>", is optimal for the MolecularWeightRange option, "<>ToString[resolvedMolecularWeightRange],True,False]
			];

			passingTest=If[nonOptimalConcentratedLoadingBufferQ,
				Nothing,
				Warning["The ConcentratedLoadingBuffer option, "<>ToString[resolvedConcentratedLoadingBuffer]<>", is optimal for the MolecularWeightRange option, "<>ToString[resolvedMolecularWeightRange],True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Resolve the Denaturant - *)
	resolvedDenaturant=Switch[{suppliedDenaturant,resolvedDenaturing,concentratedLoadingBufferOptionModel,resolvedMolecularWeightRange},

		(* In the case where the user sets the Denaturant option, we accept it *)
		{Except[Automatic],_,_,_},
			suppliedDenaturant,

		(* - In the cases where the Denaturant is left as Automatic, and we have resolved Denaturing to True, we resolve to a model of 400 mM DTT based on which kit we will be using - *)
		(* If the concentratedLoadingBufferOptionModel has been set, we resolve the DTT model based on the kit the ConcentratedLoadingBuffer comes from *)
		(* EZ Standard Pack 1 *)
		{Automatic,True,Model[Sample, StockSolution, "id:R8e1PjpY5X5d"],_},
			Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 1"],

		(* EZ Standard Pack 2 *)
		{Automatic,True,Model[Sample, StockSolution, "id:4pO6dM5jeENB"],_},
			Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 2"],

		(* EZ Standard Pack 3 *)
		{Automatic,True,Model[Sample, StockSolution, "id:4pO6dM5jewLo"],_},
			Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 3"],

		(* EZ Standard Pack 4 *)
		{Automatic,True,Model[Sample, StockSolution, "id:XnlV5jKO0R1P"],_},
			Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 4"],

		(* EZ Standard Pack 5 *)
		{Automatic,True,Model[Sample, StockSolution, "id:n0k9mG8K3Ydp"],_},
			Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 5"],

		(* If the concentratedLoadingBufferOptionModel is Null or is not one of the standard ConcentratedLoadingBuffers, we resolve the DTT model based on the resolvedMolecularWeightRange *)
		{Automatic,True,_,LowMolecularWeight},
			Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 5"],
		{Automatic,True,_,MidMolecularWeight},
			Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 1"],
		{Automatic,True,_,HighMolecularWeight},
			Model[Sample,StockSolution,"Simple Western 400 mM DTT - EZ Standard Pack 3"],

	(* In the case that Denaturing has resolved to False, we resolve the Denaturant to Null *)
		{Automatic,False,_,_},
			Null
	];

	(* - Resolve the DenaturantVolume - *)
	resolvedDenaturantVolume=Switch[{suppliedDenaturantVolume,resolvedDenaturant,smallCartridgeQ},

		(* In the case where the user sets the DenaturantVolume option, we accept it *)
		{Except[Automatic],_,_},
			suppliedDenaturantVolume,

		(* In the cases where the DenaturantVolume is left as Automatic, we resolve it based on the resolved Denaturant option and on if we will be using 13 or 25-capillary cartridge - I've changed this so we use two foil capped tubes either way  *)
		{Automatic,Null,_},
			Null,
		{Automatic,_,True},
			40*Microliter,
		{Automatic,_,False},
			40*Microliter
	];

	(* - Resolve the WaterVolume - *)
	resolvedWaterVolume=Switch[{suppliedWaterVolume,resolvedDenaturing,smallCartridgeQ},

		(* In the case where the user sets the WaterVolume option, we accept it *)
		{Except[Automatic],_,_},
			suppliedWaterVolume,

		(* In the cases where the WaterVolume is left as Automatic, we resolve it based on the resolved Denaturing option *)
		{Automatic,True,_},
			Null,
		{Automatic,False,True},
			40*Microliter,
		{Automatic,False,False},
			40*Microliter
	];

	(* -- Resolve the options that are specific to ExperimentTotalProteinDetection -- *)
	(* Do not need to resolve LabelingReagent, LabelingReagentVolume, LabelingTime, PeroxidaseReagent, PeroxidaseReagentVolume, PeroxidaseIncubationTime, and BlockingBuffer (will need to for ExperimentWestern),  *)

	(* -- Resolve the non-index matched options that are specific to ExperimentWestern -- *)
	(* Do not need to resolve PrimaryIncubationTime, LadderPeroxidaseReagent, LadderPeroxidaseReagentVolume, and SecondaryIncubationTime *)

	(* --Resolve the index-matchd options that are specific to ExperimentWestern -- *)
	(* Convert our options into a MapThread friendly version - if we are in ExperimentTotalProteinDetection just set this as an empty list *)
	westernMapThreadFriendlyOptions=If[westernQ,
		OptionsHandling`Private`mapThreadOptions[ExperimentWestern,roundedExperimentOptions],
		{}
	];

	(* Resolve the index-matched options specific to ExperimentWestern - here we will call a helper function if we are in Western, or just set the variables to Null (or maybe a list of Null) if we are in TotalProteinDetection *)
	{
		resolvedSecondaryAntibody,resolvedStandardPrimaryAntibody,resolvedStandardSecondaryAntibody,resolvedBlockingBuffer,resolvedSecondaryAntibodyVolume,resolvedStandardSecondaryAntibodyVolume,resolvedPrimaryAntibodyDiluent,
		resolvedPrimaryAntibodyDilutionFactor,resolvedPrimaryAntibodyVolume,resolvedPrimaryAntibodyDiluentVolume,resolvedStandardPrimaryAntibodyVolume,nonIdealSecondaryAntibodyWarnings,nonIdealStandardPrimaryAntibodyWarnings,
		nonIdealStandardSecondaryAntibodyWarnings,nonIdealBlockingBufferWarnings,nonIdealPrimaryAntibodyDiluentWarnings,conflictingPrimaryAbDilutionFactorErrors,
		standardPrimaryAntibodyStorageConditionErrors,standardSecondaryAntibodyStorageConditionErrors
	} =If[westernQ,
		Transpose[resolveIndexMatchedWesternOptions[
			samplePackets,primaryAntibodyRecommendedDilutions,primaryAntibodyOrganisms,westernMapThreadFriendlyOptions,secondaryAbModels,standardPrimaryAbModels,
			standardSecondaryAbModels,blockingBufferModels,primaryAbDiluentModels
		]],
		ConstantArray[Null,19]
	];

	(* -- Resolve the single options specific to Western that rely on the index-matched option resolution -- *)
	(* - Resolve the PrimaryLoadingVolume - this only exists in ExperimentWestern - *)
	(* For PrimaryLoadingVolume resolution and error checking, we need to replace Nulls in the list of PrimaryAntibodyDiluentVolumes and StandardPrimaryAntibodyVolumes with 0 uL so our addition works *)
	resolvedPrimaryAntibodyDiluentVolumeNoNull=If[westernQ,
		resolvedPrimaryAntibodyDiluentVolume/.(Null->0*Microliter),
		{}
	];
	resolvedStandardPrimaryAntibodyVolumeNoNull=If[westernQ,
		resolvedStandardPrimaryAntibodyVolume/.(Null->0*Microliter),
		{}
	];

	(* Calculate the sum of the resolvedPrimaryAntibodyVolume, the resolvedPrimaryAntibodyDiluentVolumeNoNull, and the resolvedStandardPrimaryAntibodyVolumeNoNull - this is the total volume of PrimaryAntibody diluted mixture *)
	totalPrimaryAntibodyMixtureVolumes=If[westernQ,
		Plus[resolvedPrimaryAntibodyVolume,resolvedPrimaryAntibodyDiluentVolumeNoNull,resolvedStandardPrimaryAntibodyVolumeNoNull],
		{}
	];

	(* - Make a list of the simulated samples / antibody pairs for which the totalPrimaryAntibodyMixtureVolume is less than 10 uL - will need to throw warnings about these -  *)
	(* First, make a list of simulated sample / antibody tuples *)
	inputsAndAntibodyTuples=If[westernQ,
		MapThread[
			{#1,#2}&,
			{simulatedSamples,myAntibodies}
		],
		{}
	];

	(* Make a list of the input tuples whose corresponding total primary antibody mixture volumes is less than 10 uL, when PrimaryLoadingVolume is Automatic  *)
	tooLowAutomaticTotalAntibodyVolumeTuples=If[MatchQ[suppliedPrimaryAntibodyLoadingVolume,Automatic],
		PickList[inputsAndAntibodyTuples,totalPrimaryAntibodyMixtureVolumes,LessP[10*Microliter]],
		{}
	];

	(* - Make a list of the simulated sample / antibody tuples for which the totalPrimaryAntibodyMixtureVolume is less than the supplied PrimaryLoadingVolume, when the PrimaryLoadingVolume is not Automatic - *)
	tooLowSetTotalAntibodyVolumeTuples=If[MatchQ[suppliedPrimaryAntibodyLoadingVolume,Except[Automatic|Null]],
		PickList[inputsAndAntibodyTuples,totalPrimaryAntibodyMixtureVolumes,LessP[suppliedPrimaryAntibodyLoadingVolume]],
		{}
	];

	(* Resolve the PrimaryLoadingVolume *)
	resolvedPrimaryAntibodyLoadingVolume=Switch[{westernQ,suppliedPrimaryAntibodyLoadingVolume,tooLowAutomaticTotalAntibodyVolumeTuples},

		(* - ExperimentWestern - *)
		(* If the user has left the PrimaryAntibodyLoadingVolume option as Automatic, we resolve it to 10 uL, unless there is a member of totalPrimaryAntibodyMixtureVolumes that is less than 10 uL, then we resolve it to the lowest value in that list *)
		{True,Automatic,{}},
			10*Microliter,
		{True,Automatic,Except[{}]},
			First[Sort[totalPrimaryAntibodyMixtureVolumes]],

		(* If the user has set the PrimaryAntibodyLoadingVolume, we accept it, but may throw a warning after this *)
		{True,Except[Automatic],_},
			suppliedPrimaryAntibodyLoadingVolume,

		(* This option does not exist in ExperimentTotalProteinDetection *)
		{False,_,_},
			Null
	];

	(* -- Throw a warning if the any PrimaryAntibodyVolume is larger than 4*Microliter if the corresponding PrimaryAntibodyDilutionFactor is not 1 -- *)
	(* First, find the PrimaryAntibodyVolumes that are 4 uL or larger*)

	dilutedPrimaryAntibodyVolumes=PickList[resolvedPrimaryAntibodyVolume,resolvedPrimaryAntibodyDilutionFactor,Except[Alternatives[1,1.]]];

	largeDilutedPrimaryAntibodyVolumes=Cases[dilutedPrimaryAntibodyVolumes,GreaterEqualP[4*Microliter]];


	(* Find the PrimaryAntibodyDiluentVolumes that correspond to the largeDilutedPrimaryAntibodyVolumes (so that we can write an informative warning message) *)
	largeDilutedPrimaryAntibodyDiluentVolumes=PickList[
		PickList[resolvedPrimaryAntibodyDiluentVolume,resolvedPrimaryAntibodyDilutionFactor,Except[Alternatives[1,1.]]],
		dilutedPrimaryAntibodyVolumes,
		GreaterEqualP[4*Microliter]
	];


	(* If we are throwing messages and are not in engine, throw a warning with suggestions about how to conserve PrimaryAntibody *)
	If[messages&&notInEngine&&Length[largeDilutedPrimaryAntibodyVolumes]>0,
		Message[Warning::WesternPrimaryAntibodyVolumeLarge,largeDilutedPrimaryAntibodyVolumes,largeDilutedPrimaryAntibodyDiluentVolumes]
	];

	(* If we are gathering tests and there are any diluted PrimaryAnitbodies whose PrimaryAntibodyVolume is larger than 4 uL, define the tests*)
	largeDilutedPrimaryAntibodyVolumeTest=If[gatherTests&&westernQ&&Length[largeDilutedPrimaryAntibodyVolumes]>0,
		Module[{failingTest},

			failingTest=If[Length[largeDilutedPrimaryAntibodyVolumes]>0,
				Warning["The following resolved or user-supplied PrimaryAntibodyVolumes, "<>ToString[largeDilutedPrimaryAntibodyVolumes]<>", are 4 uL or larger. To conserve PrimaryAntibody, consider lowering the PrimaryAntibodyVolume and PrimaryAntibodyDiluentVolumes, "<>ToString[largeDilutedPrimaryAntibodyDiluentVolumes]<>", while preserving the ratio between them. Alternatively, consider using the PreparatoryUnitOperations option to pre-dilute the PrimaryAntibody to the desired concentration, and set the PrimaryAntibodyDilutionFactor to 1.",True,False],
				Nothing
			];
			{failingTest}
		],
		Nothing
	];

	(* --- UNRESOLVABLE OPTION CHECKS --- *)
	(* -- Check here to make sure that the sum of the PrimaryAntibody,PrimaryAntibodyDiluent, and StandardPrimaryAntibody is at least 35 uL and no more than 275 uL for each input -- *)
	(* Define the invalid and validTotalPrimaryAntibodyMixtureVolumes *)
	invalidTotalPrimaryAntibodyMixtureVolumes=Cases[totalPrimaryAntibodyMixtureVolumes,Except[RangeP[35*Microliter,275*Microliter]]];
	validTotalPrimaryAntibodyMixtureVolumes=Cases[totalPrimaryAntibodyMixtureVolumes,RangeP[35*Microliter,275*Microliter]];

	(* Define the corresponding invalid and validTotalPrimaryAntibodyMixtureVolumeInputs *)
	invalidTotalPrimaryAntibodyMixtureVolumeInputs=PickList[inputsAndAntibodyTuples,totalPrimaryAntibodyMixtureVolumes,Except[RangeP[35*Microliter,200*Microliter]]];
	validTotalPrimaryAntibodyMixtureVolumeInputs=PickList[inputsAndAntibodyTuples,totalPrimaryAntibodyMixtureVolumes,RangeP[35*Microliter,200*Microliter]];

	invalidPrimaryAntibodyDilutionOptions=If[Length[invalidTotalPrimaryAntibodyMixtureVolumeInputs]>0,
		{PrimaryAntibodyVolume,PrimaryAntibodyDiluentVolume,StandardPrimaryAntibodyVolume},
		{}
	];

	(* If we are throwing messages and there are any invalidTotalPrimaryAntibodyMixtureVolumeInputs, throw an Error *)
	If[messages&&Length[invalidTotalPrimaryAntibodyMixtureVolumeInputs]>0,
		Message[Error::InvalidWesternDilutedPrimaryAntibodyVolume,ToString[invalidTotalPrimaryAntibodyMixtureVolumes],ObjectToString[invalidTotalPrimaryAntibodyMixtureVolumeInputs,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create failing Tests for the above Errors - not creating passing tests here because the input samples and antibodies will so often be the same, so doing Cases here doesn't make sense *)
	invalidPrimaryAntibodyDilutionTests=If[gatherTests&&Length[invalidTotalPrimaryAntibodyMixtureVolumeInputs]>0,
		Module[{failingTest},

			failingTest=If[Length[invalidTotalPrimaryAntibodyMixtureVolumeInputs]>0,
				Test["The sum of the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, and StandardPrimaryAntibodyVolume options, "<>ToString[invalidTotalPrimaryAntibodyMixtureVolumes]<>", is not between 35 and 275 uL for the following pairs of input samples and antibodies, "<>ObjectToString[invalidTotalPrimaryAntibodyMixtureVolumeInputs,Cache->simulatedCache],True,False],
				Nothing
			];
			failingTest
		],
		Nothing
	];

	(* -- Here, we need to check that there is enough LoadingBuffer for all of the wells and the extra wells -- *)
	(* First, find the total volume of the inputs of the LoadingBuffer, this is the total volume of LoadingBuffer we will have to work with *)
	totalLoadingBufferVolume=Total[{suppliedConcentratedLoadingBufferVolume,resolvedDenaturantVolume,resolvedWaterVolume}/.(Null->0*Microliter)];

	(* Next, add all of the LoadingBufferVolumes + 1uL for each unused capillary to determine how much LoadingBuffer we will require *)

	(* The amount of loading buffer required from the explictly set LoadingBufferVolume and the number of replicates *)
	totalSuppliedLoadingBufferVolume=(Total[suppliedLoadingBufferVolume]*intNumberOfReplicates);

	(* The amount of LoadingBuffer we will require for unused capillaries (1 uL for each) *)
	totalExtraLoadingBufferVolume=RoundOptionPrecision[(1*Microliter*(24-(numberOfSamples*intNumberOfReplicates))),10^-1*Microliter];

	(* Add these two together to get the total amount needed for the experiment *)
	totalRequiredLoadingBufferVolume=Plus[totalSuppliedLoadingBufferVolume,totalExtraLoadingBufferVolume];

	(* - If we require more LoadingBuffer than we have, a few options are invalid - *)
	invalidLoadingBufferVolumeOptions=If[totalLoadingBufferVolume<totalRequiredLoadingBufferVolume,
		{ConcentratedLoadingBufferVolume,WaterVolume,DenaturantVolume,LoadingBufferVolume},
		{}
	];

	(* If there are invalid LoadingBufferVolume options and we are throwing messages, throw an Error *)
	If[messages&&Length[invalidLoadingBufferVolumeOptions]>0,
		Message[Error::NotEnoughWesLoadingBuffer,ToString[totalRequiredLoadingBufferVolume],ToString[totalSuppliedLoadingBufferVolume]]
	];

	(* If we are gathering tests, write the user-facing tests for Error::NotEnoughWesLoadingBuffer *)
	notEnoughLoadingBufferTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[Length[invalidLoadingBufferVolumeOptions]==0,
				Nothing,
				Test["The sum of the ConcentratedLoadingBufferVolume, WaterVolume, and DenaturantVolume options, "<>ToString[totalLoadingBufferVolume]<>", is larger than the LoadingBuffer volume required for this experiment, "<>ToString[totalRequiredLoadingBufferVolume]<>".",True,False]
			];

			passingTest=If[Length[invalidLoadingBufferVolumeOptions]>0,
				Nothing,
				Test["The sum of the ConcentratedLoadingBufferVolume, WaterVolume, and DenaturantVolume options, "<>ToString[totalLoadingBufferVolume]<>", is larger than the LoadingBuffer volume required for this experiment, "<>ToString[totalRequiredLoadingBufferVolume]<>".",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- In the section below, we do all of the unresolvable / conflicting options tests / Warnings / Errors. These only exist in ExperimentWestern -- *)
	(* - The output of this Module will be a list of the user-facing Tests and a list of invalid options - within the module Errors and Warnings will be thrown if applicable *)
	{
		westernUnresolvableOptionTests,invalidDilutionFactorOptions,conflictingStandardPrimaryAntibodyStorageOptions,
		conflictingStandardSecondaryAntibodyStorageOptions
	}=If[westernQ,

		(* If we are in ExperimentWestern, all of this error checking will take place*)
		Module[
			{
				passingNonIdealSecondaryAntibodyInputs,failingNonIdealSecondaryAntibodyInputs,idealSecondaryAntibodies,nonIdealSecondaryAntibodies,nonIdealSecondaryAntibodyTests,passingNonIdealStandardPrimaryAntibodyInputs,
				failingNonIdealStandardPrimaryAntibodyInputs,idealStandardPrimaryAntibodies,nonIdealStandardPrimaryAntibodies,nonIdealStandardPrimaryAntibodyTests,passingNonIdealStandardSecondaryAntibodyInputs,
				failingNonIdealStandardSecondaryAntibodyInputs,idealStandardSecondaryAntibodies,nonIdealStandardSecondaryAntibodies,nonIdealStandardSecondaryAntibodyTests,passingNonIdealBlockingBufferInputs,
				failingNonIdealBlockingBufferInputs,idealBlockingBuffers,nonIdealBlockingBuffers,nonIdealBlockingBufferTests,passingNonIdealPrimaryAntibodyDiluentInputs,failingNonIdealPrimaryAntibodyDiluentInputs,
				idealPrimaryAntibodyDiluents,nonIdealPrimaryAntibodyDiluents,nonIdealPrimaryAntibodyDiluentTests,resolvedStandardSecondaryAntibodyVolumeNoNull,totalSecondaryAntibodyVolumes,passingSecondaryAntibodyVolumeInputs,
				failingSecondaryAntibodyVolumeInputs,idealSecondaryAntibodyVolumes,nonIdealSecondaryAntibodyVolumes,lowSecondaryAntibodyVolumeTests,nonNullStandardPrimaryAntibodyVolumeInputs,nonNullStandardPrimaryAntibodyVolumes,
				nonNullTotalPrimaryAntibodyMixtureVolumes,nonNullStandardPrimaryAntibodyVolumeRatios,passingStandardAntibodyRatioInputs,failingStandardAntibodyRatioInputs,idealStandardPrimaryAntibodyVolumes,
				nonIdealStandardPrimaryAntibodyVolumes,idealTotalPrimaryAntibodyMixtureRatioVolumes,nonIdealTotalPrimaryAntibodyMixtureRatioVolumes,standardPrimaryAntibodyRatioTests,calculatedPrimaryAntibodyRatios,
				roundedResolvedPrimaryAntibodyDilutionFactors,filteredInputsAndAntibodyTuples,filteredCalculatedPrimaryAntibodyRatios,filteredRoundedResolvedPrimaryAntibodyDilutionFactor,equalDilutionFactorQ,
				failingEqualDilutionInputs,passingEqualDilutionInputs,nonEqualCalculatedDilutionFactors,equalCalculatedDilutionFactors,nonEqualRoundedDilutionFactors,equalRoundedDilutionFactors,
				invalidDilutionFactorOptions,invalidDilutionFactorTests,standardPrimaryAntibodyStorageConditionErrorQ,failingConflictingStandardPrimaryAntibodyStorageSamples,
				passingConflictingStandardPrimaryAntibodyStorageSamples,invalidStandardPrimaryAntibodyStorageOptions,conflictingStandardPrimaryAntibodyStorageTests,
				standardSecondaryAntibodyStorageConditionErrorQ,failingConflictingStandardSecondaryAntibodyStorageSamples,passingConflictingStandardSecondaryAntibodyStorageSamples,
				invalidStandardSecondaryAntibodyStorageOptions,conflictingStandardSecondaryAntibodyStorageTests
			},

			(* - nonIdealSecondaryAntibodyWarning Message and Tests - *)
			(* Create lists of the input sample/antibody tuples that are False and True for nonIdealSecondaryAntibodyWarning *)
			passingNonIdealSecondaryAntibodyInputs=PickList[inputsAndAntibodyTuples,nonIdealSecondaryAntibodyWarnings,False];
			failingNonIdealSecondaryAntibodyInputs=PickList[inputsAndAntibodyTuples,nonIdealSecondaryAntibodyWarnings,True];

			(* Create lists of the resolvedSecondaryAntibodies that are and are not optimal *)
			idealSecondaryAntibodies=PickList[resolvedSecondaryAntibody,nonIdealSecondaryAntibodyWarnings,False];
			nonIdealSecondaryAntibodies=PickList[resolvedSecondaryAntibody,nonIdealSecondaryAntibodyWarnings,True];

			(* If we are throwing messages, throw a warning if there are any failingNonIdealSecondaryAntibodyInputs *)
			If[messages&&notInEngine&&Length[failingNonIdealSecondaryAntibodyInputs]>0,
				Message[Warning::NonIdealWesternSecondaryAntibody,ObjectToString[nonIdealSecondaryAntibodies,Cache->simulatedCache],ObjectToString[failingNonIdealSecondaryAntibodyInputs,Cache->simulatedCache]]
			];

			(* If we are gathering tests, define the user-facing tests for NonIdealWesternSecondaryAntibody *)
			nonIdealSecondaryAntibodyTests=If[gatherTests,
				Module[{failingTest,passingTest},

					failingTest=If[Length[failingNonIdealSecondaryAntibodyInputs]==0,
						Nothing,
						Warning["The SecondaryAntibodies, "<>ObjectToString[nonIdealSecondaryAntibodies,Cache->simulatedCache]<>", are ideal for the Organism of the PrimaryAntibodies of the following pairs on input samples and antibodies, "<>ObjectToString[failingNonIdealSecondaryAntibodyInputs,Cache->simulatedCache],True,False]
					];
					passingTest=If[Length[passingNonIdealSecondaryAntibodyInputs]==0,
						Nothing,
						Warning["The SecondaryAntibodies, "<>ObjectToString[idealSecondaryAntibodies,Cache->simulatedCache]<>", are ideal for the Organism of the PrimaryAntibodies of the following pairs on input samples and antibodies, "<>ObjectToString[passingNonIdealSecondaryAntibodyInputs,Cache->simulatedCache],True,True]
					];
					{failingTest,passingTest}
				],
				Nothing
			];

			(* - nonIdealStandardPrimaryAntibodyWarnings Message and Tests - *)
			(* Create lists of the input sample/antibody tuples that are False and True for nonIdealStandardPrimaryAntibodyWarning *)
			passingNonIdealStandardPrimaryAntibodyInputs=PickList[inputsAndAntibodyTuples,nonIdealStandardPrimaryAntibodyWarnings,False];
			failingNonIdealStandardPrimaryAntibodyInputs=PickList[inputsAndAntibodyTuples,nonIdealStandardPrimaryAntibodyWarnings,True];

			(* Create lists of the resolvedStandardPrimaryAntibodies that are and are not optimal *)
			idealStandardPrimaryAntibodies=PickList[resolvedStandardPrimaryAntibody,nonIdealStandardPrimaryAntibodyWarnings,False];
			nonIdealStandardPrimaryAntibodies=PickList[resolvedStandardPrimaryAntibody,nonIdealStandardPrimaryAntibodyWarnings,True];

			(* If we are throwing messages, throw a warning if there are any failingNonIdealSecondaryAntibodyInputs *)
			If[messages&&notInEngine&&Length[failingNonIdealStandardPrimaryAntibodyInputs]>0,
				Message[Warning::NonIdealWesternStandardPrimaryAntibody,ObjectToString[nonIdealStandardPrimaryAntibodies,Cache->simulatedCache],ObjectToString[failingNonIdealStandardPrimaryAntibodyInputs,Cache->simulatedCache]]
			];

			(* If we are gathering tests, define the user-facing tests for NonIdealWesternStandardPrimaryAntibody *)
			nonIdealStandardPrimaryAntibodyTests=If[gatherTests,
				Module[{failingTest,passingTest},

					failingTest=If[Length[failingNonIdealStandardPrimaryAntibodyInputs]==0,
						Nothing,
						Warning["The StandardPrimaryAntibodies, "<>ObjectToString[nonIdealStandardPrimaryAntibodies,Cache->simulatedCache]<>", are ideal for the Organism of the PrimaryAntibodies of the following pairs on input samples and antibodies, "<>ObjectToString[failingNonIdealStandardPrimaryAntibodyInputs,Cache->simulatedCache],True,False]
					];
					passingTest=If[Length[passingNonIdealStandardPrimaryAntibodyInputs]==0,
						Nothing,
						Warning["The StandardPrimaryAntibodies, "<>ObjectToString[idealStandardPrimaryAntibodies,Cache->simulatedCache]<>", are ideal for the Organism of the PrimaryAntibodies of the following pairs on input samples and antibodies, "<>ObjectToString[passingNonIdealStandardPrimaryAntibodyInputs,Cache->simulatedCache],True,True]
					];
					{failingTest,passingTest}
				],
				Nothing
			];

			(* - nonIdealStandardSecondaryAntibodyWarnings Message and Tests - *)
			(* Create lists of the input sample/antibody tuples that are False and True for nonIdealStandardSecondaryAntibodyWarning *)
			passingNonIdealStandardSecondaryAntibodyInputs=PickList[inputsAndAntibodyTuples,nonIdealStandardSecondaryAntibodyWarnings,False];
			failingNonIdealStandardSecondaryAntibodyInputs=PickList[inputsAndAntibodyTuples,nonIdealStandardSecondaryAntibodyWarnings,True];

			(* Create lists of the resolvedStandardSecondaryAntibodies that are and are not optimal *)
			idealStandardSecondaryAntibodies=PickList[resolvedStandardSecondaryAntibody,nonIdealStandardSecondaryAntibodyWarnings,False];
			nonIdealStandardSecondaryAntibodies=PickList[resolvedStandardSecondaryAntibody,nonIdealStandardSecondaryAntibodyWarnings,True];

			(* If we are throwing messages, throw a warning if there are any failingNonIdealStandardSecondaryAntibodyInputs *)
			If[messages&&notInEngine&&Length[failingNonIdealStandardSecondaryAntibodyInputs]>0,
				Message[Warning::NonIdealWesternStandardSecondaryAntibody,ObjectToString[nonIdealStandardSecondaryAntibodies,Cache->simulatedCache],ObjectToString[failingNonIdealStandardSecondaryAntibodyInputs,Cache->simulatedCache]]
			];

			(* If we are gathering tests, define the user-facing tests for NonIdealWesternStandardSecondaryAntibody *)
			nonIdealStandardSecondaryAntibodyTests=If[gatherTests,
				Module[{failingTest,passingTest},

					failingTest=If[Length[failingNonIdealStandardSecondaryAntibodyInputs]==0,
						Nothing,
						Warning["The StandardSecondaryAntibodies, "<>ObjectToString[nonIdealStandardSecondaryAntibodies,Cache->simulatedCache]<>", are ideal for the StandardPrimaryAntibody and the Organism of the PrimaryAntibodies of the following pairs on input samples and antibodies, "<>ObjectToString[failingNonIdealStandardSecondaryAntibodyInputs,Cache->simulatedCache],True,False]
					];
					passingTest=If[Length[passingNonIdealStandardSecondaryAntibodyInputs]==0,
						Nothing,
						Warning["The StandardSecondaryAntibodies, "<>ObjectToString[idealStandardSecondaryAntibodies,Cache->simulatedCache]<>", are ideal for the StandardPrimaryAntibody and the Organism of the PrimaryAntibodies of the following pairs on input samples and antibodies, "<>ObjectToString[passingNonIdealStandardSecondaryAntibodyInputs,Cache->simulatedCache],True,True]
					];
					{failingTest,passingTest}
				],
				Nothing
			];

			(* - nonIdealBlockingBufferWarnings Message and Tests - *)
			(* Create lists of the input sample/antibody tuples that are False and True for nonIdealBlockingBufferWarning *)
			passingNonIdealBlockingBufferInputs=PickList[inputsAndAntibodyTuples,nonIdealBlockingBufferWarnings,False];
			failingNonIdealBlockingBufferInputs=PickList[inputsAndAntibodyTuples,nonIdealBlockingBufferWarnings,True];

			(* Create lists of the resolvedBlockingBuffers that are and are not optimal *)
			idealBlockingBuffers=PickList[resolvedBlockingBuffer,nonIdealBlockingBufferWarnings,False];
			nonIdealBlockingBuffers=PickList[resolvedBlockingBuffer,nonIdealBlockingBufferWarnings,True];

			(* If we are throwing messages, throw a warning if there are any failingNonIdealBlockingBufferInputs *)
			If[messages&&notInEngine&&Length[failingNonIdealBlockingBufferInputs]>0,
				Message[Warning::NonIdealWesternBlockingBuffer,ObjectToString[nonIdealBlockingBuffers,Cache->simulatedCache],ObjectToString[failingNonIdealBlockingBufferInputs,Cache->simulatedCache]]
			];

			(* If we are gathering tests, define the user-facing tests for NonIdealWesternBlockingBuffer *)
			nonIdealBlockingBufferTests=If[gatherTests,
				Module[{failingTest,passingTest},

					failingTest=If[Length[failingNonIdealBlockingBufferInputs]==0,
						Nothing,
						Test["The BlockingBuffers, "<>ObjectToString[nonIdealBlockingBuffers,Cache->simulatedCache]<>", are ideal for the Organism of the PrimaryAntibodies of the following pairs on input samples and antibodies, "<>ObjectToString[failingNonIdealBlockingBufferInputs,Cache->simulatedCache],True,False]
					];
					passingTest=If[Length[passingNonIdealBlockingBufferInputs]==0,
						Nothing,
						Test["The BlockingBuffers, "<>ObjectToString[idealBlockingBuffers,Cache->simulatedCache]<>", are ideal for the Organism of the PrimaryAntibodies of the following pairs on input samples and antibodies, "<>ObjectToString[passingNonIdealBlockingBufferInputs,Cache->simulatedCache],True,True]
					];
					{failingTest,passingTest}
				],
				Nothing
			];

			(* - nonIdealPrimaryAntibodyDiluentWarnings Message and Tests - *)
			(* Create lists of the input sample/antibody tuples that are False and True for nonIdealPrimaryAntibodyDiluentWarning *)
			passingNonIdealPrimaryAntibodyDiluentInputs=PickList[inputsAndAntibodyTuples,nonIdealPrimaryAntibodyDiluentWarnings,False];
			failingNonIdealPrimaryAntibodyDiluentInputs=PickList[inputsAndAntibodyTuples,nonIdealPrimaryAntibodyDiluentWarnings,True];

			(* Create lists of the resolvedPrimaryAntibodyDiluents that are and are not optimal *)
			idealPrimaryAntibodyDiluents=PickList[resolvedPrimaryAntibodyDiluent,nonIdealPrimaryAntibodyDiluentWarnings,False];
			nonIdealPrimaryAntibodyDiluents=PickList[resolvedPrimaryAntibodyDiluent,nonIdealPrimaryAntibodyDiluentWarnings,True];

			(* If we are throwing messages, throw a warning if there are any failingNonIdealPrimaryAntibodyDiluentInputs *)
			If[messages&&notInEngine&&Length[failingNonIdealPrimaryAntibodyDiluentInputs]>0,
				Message[Warning::NonIdealWesternPrimaryAntibodyDiluent,ObjectToString[nonIdealPrimaryAntibodyDiluents,Cache->simulatedCache],ObjectToString[failingNonIdealPrimaryAntibodyDiluentInputs,Cache->simulatedCache]]
			];

			(* If we are gathering tests, define the user-facing tests for NonIdealWesternPrimaryAntibodyDiluent *)
			nonIdealPrimaryAntibodyDiluentTests=If[gatherTests,
				Module[{failingTest,passingTest},

					failingTest=If[Length[failingNonIdealPrimaryAntibodyDiluentInputs]==0,
						Nothing,
						Warning["The PrimaryAntibodyDiluents, "<>ObjectToString[nonIdealPrimaryAntibodyDiluents,Cache->simulatedCache]<>", are ideal for the Organism of the PrimaryAntibodies of the following pairs on input samples and antibodies, "<>ObjectToString[failingNonIdealPrimaryAntibodyDiluentInputs,Cache->simulatedCache],True,False]
					];
					passingTest=If[Length[passingNonIdealPrimaryAntibodyDiluentInputs]==0,
						Nothing,
						Warning["The PrimaryAntibodyDiluents, "<>ObjectToString[idealPrimaryAntibodyDiluents,Cache->simulatedCache]<>", are ideal for the Organism of the PrimaryAntibodies of the following pairs on input samples and antibodies, "<>ObjectToString[passingNonIdealPrimaryAntibodyDiluentInputs,Cache->simulatedCache],True,True]
					];
					{failingTest,passingTest}
				],
				Nothing
			];

			(* - Check to make sure the sum of the SecondaryAntibody and StandardSecondaryAntibody is at least 10 uL for each input - *)
			(* First, we need a list of the StandardSecondaryAntibodyVolumes with any Nulls replaced with 0 uL, so that it can be added to a list of the SecondaryAntibodyVolumes *)
			resolvedStandardSecondaryAntibodyVolumeNoNull=resolvedStandardSecondaryAntibodyVolume/.(Null->0*Microliter);

			(* Next, add the SecondaryAntibodyVolumes to the resolvedStandardSecondaryAntibodyVolumeNoNull to find the total volumes of the secondary Ab solutions *)
			totalSecondaryAntibodyVolumes=Plus[resolvedSecondaryAntibodyVolume,resolvedStandardSecondaryAntibodyVolumeNoNull];

			(* Create lists of the input sample/antibody tuples that have total secondary Ab solutions euqal to or greater than 10 uL and those that don't *)
			passingSecondaryAntibodyVolumeInputs=PickList[inputsAndAntibodyTuples,totalSecondaryAntibodyVolumes,GreaterEqualP[10*Microliter]];
			failingSecondaryAntibodyVolumeInputs=PickList[inputsAndAntibodyTuples,totalSecondaryAntibodyVolumes,LessP[10*Microliter]];

			(* Create lists of the totalSecondaryAntibodyVolumes that are >=10*Microliter and those that are <10*Microliter *)
			idealSecondaryAntibodyVolumes=PickList[totalSecondaryAntibodyVolumes,totalSecondaryAntibodyVolumes,GreaterEqualP[10*Microliter]];
			nonIdealSecondaryAntibodyVolumes=PickList[totalSecondaryAntibodyVolumes,totalSecondaryAntibodyVolumes,LessP[10*Microliter]];

			(* If we are throwing messages, throw a warning if there are any failingSecondaryAntibodyVolumeInputs *)
			If[messages&&notInEngine&&Length[failingSecondaryAntibodyVolumeInputs]>0,
				Message[Warning::WesternSecondaryAntibodyVolumeLow,ToString[nonIdealSecondaryAntibodyVolumes],ObjectToString[failingSecondaryAntibodyVolumeInputs,Cache->simulatedCache]]
			];

			(* If we are gathering tests, define the user-facing tests for WesternSecondaryAntibodyVolumeLow *)
			lowSecondaryAntibodyVolumeTests=If[gatherTests,
				Module[{failingTest,passingTest},

					failingTest=If[Length[failingSecondaryAntibodyVolumeInputs]==0,
						Nothing,
						Warning["The sum of the SecondaryAntibodyVolume and StandardSecondaryAntibodyVolume, "<>ToString[nonIdealSecondaryAntibodyVolumes]<>", is at least 10 uL for the following pairs on input samples and antibodies, "<>ObjectToString[failingSecondaryAntibodyVolumeInputs,Cache->simulatedCache],True,False]
					];
					passingTest=If[Length[passingSecondaryAntibodyVolumeInputs]==0,
						Nothing,
						Warning["The sum of the SecondaryAntibodyVolume and StandardSecondaryAntibodyVolume, "<>ToString[idealSecondaryAntibodyVolumes]<>", is at least 10 uL for the following pairs on input samples and antibodies, "<>ObjectToString[passingSecondaryAntibodyVolumeInputs,Cache->simulatedCache],True,True]
					];
					{failingTest,passingTest}
				],
				Nothing
			];

			(* - Check whether the StandardPrimaryAntibodyVolume is 10% of the total diluted primary antibody solution (the ideal ratio) when the StandardPrimaryAntibodyVolume is not Null - *)
			(* First, make a list of the input sample/antibody tuples that have StandardPrimaryAntibodyVolumes that are not Null *)
			nonNullStandardPrimaryAntibodyVolumeInputs=PickList[inputsAndAntibodyTuples,resolvedStandardPrimaryAntibodyVolume,Except[Null]];

			(* Next, make a list of the resolvedStandardPrimaryAntibodyVolumes without Nulls *)
			nonNullStandardPrimaryAntibodyVolumes=PickList[resolvedStandardPrimaryAntibodyVolume,resolvedStandardPrimaryAntibodyVolume,Except[Null]];

			(* Next, make a list of the total primary antibody solution volumes for the inputs where the StandardPrimaryAntibodyVolume is not Null *)
			nonNullTotalPrimaryAntibodyMixtureVolumes=PickList[totalPrimaryAntibodyMixtureVolumes,resolvedStandardPrimaryAntibodyVolume,Except[Null]];

			(* Make a list of the ratios of StandardPrimaryAntibodyVolume to TotalPrimaryAntibodyMixtureVolume for the inputs whose StandardPrimaryAntibodyVolume are not Null *)
			nonNullStandardPrimaryAntibodyVolumeRatios=RoundOptionPrecision[(nonNullStandardPrimaryAntibodyVolumes/nonNullTotalPrimaryAntibodyMixtureVolumes),10^-2];

			(* Make a list of the input sample/antibody tuples for which the StandardPrimaryAntibodyVolume makes up 9-11% of the total antibody solution volume, and a list for the tuples whose ratio is outside of this range *)
			passingStandardAntibodyRatioInputs=PickList[nonNullStandardPrimaryAntibodyVolumeInputs,nonNullStandardPrimaryAntibodyVolumeRatios,RangeP[0.07,0.13]];
			failingStandardAntibodyRatioInputs=PickList[nonNullStandardPrimaryAntibodyVolumeInputs,nonNullStandardPrimaryAntibodyVolumeRatios,Except[RangeP[0.07,0.13]]];

			(* Make lists of the StandardPrimaryAntibodyVolumes for which this volume makes up 9-11% of the total antibody solution volume, and a list for the volumes whose ratio is outside of this range *)
			idealStandardPrimaryAntibodyVolumes=PickList[nonNullStandardPrimaryAntibodyVolumes,nonNullStandardPrimaryAntibodyVolumeRatios,RangeP[0.07,0.13]];
			nonIdealStandardPrimaryAntibodyVolumes=PickList[nonNullStandardPrimaryAntibodyVolumes,nonNullStandardPrimaryAntibodyVolumeRatios,Except[RangeP[0.07,0.13]]];

			(* Make lists of the TotalPrimaryAntibodyVolumes for which the StandardPrimaryAntibodyVolume makes up 9-11% of the total antibody solution volume, and a list for the volumes whose ratio is outside of this range *)
			idealTotalPrimaryAntibodyMixtureRatioVolumes=PickList[nonNullTotalPrimaryAntibodyMixtureVolumes,nonNullStandardPrimaryAntibodyVolumeRatios,RangeP[0.07,0.13]];
			nonIdealTotalPrimaryAntibodyMixtureRatioVolumes=PickList[nonNullTotalPrimaryAntibodyMixtureVolumes,nonNullStandardPrimaryAntibodyVolumeRatios,Except[RangeP[0.07,0.13]]];

			(* If we are throwing messages, throw a warning if there are any failingStandardAntibodyRatioInputs *)
			If[messages&&notInEngine&&Length[failingStandardAntibodyRatioInputs]>0,
				Message[Warning::WesternStandardPrimaryAntibodyVolumeRatioNonIdeal,ObjectToString[failingStandardAntibodyRatioInputs,Cache->simulatedCache],ToString[nonIdealStandardPrimaryAntibodyVolumes],ToString[nonIdealTotalPrimaryAntibodyMixtureRatioVolumes]]
			];

			(* If we are gathering tests, define the user-facing tests for WesternStandardPrimaryAntibodyVolumeRatioNonIdeal *)
			standardPrimaryAntibodyRatioTests=If[gatherTests,
				Module[{failingTest,passingTest},

					failingTest=If[Length[failingStandardAntibodyRatioInputs]==0,
						Nothing,
						Warning["For the following pairs of input samples and antibodies,"<>ObjectToString[failingStandardAntibodyRatioInputs,Cache->simulatedCache]<>", the StandardPrimaryAntibodyVolume, "<>ToString[nonIdealStandardPrimaryAntibodyVolumes]<>", is between 7-13% of the sum of the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, and the StandardPrimaryAntibodyVolume,"<>ToString[nonIdealTotalPrimaryAntibodyMixtureRatioVolumes],True,False]
					];
					passingTest=If[Length[passingStandardAntibodyRatioInputs]==0,
						Nothing,
						Warning["For the following pairs of input samples and antibodies,"<>ObjectToString[passingStandardAntibodyRatioInputs,Cache->simulatedCache]<>", the StandardPrimaryAntibodyVolume, "<>ToString[idealStandardPrimaryAntibodyVolumes]<>", is between 7-13% of the sum of the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, and the StandardPrimaryAntibodyVolume,"<>ToString[idealTotalPrimaryAntibodyMixtureRatioVolumes],True,True]
					];
					{failingTest,passingTest}
				],
				Nothing
			];

			(* -- Main error check to makes sure that the resolved PrimaryAntibodyDilutionFactor is the ratio of the resolved PrimaryAntibodyVolume over the sum of the PrimaryAntibodyVolume, the PrimaryAntibodyDiluentVolume, and the StandardPrimaryAntibodyVolume -- *)
			(* We are ignoring the inputs where the PrimaryAntibodyDilutionFactor has resolved to 1 (really only the ready-to-use control PrimaryAntibody that ProteinSimple sells). This is because when SystemStandard is True (a rare event), we will need to add the StandardPrimaryAntibody which messes with the ratio, but the dilution factor cannot be accurately resolved in certain cases when other options are left as Automatic *)
			(* First, make a list of the dilution factors calculated by dividing resolved PrimaryAntibodyVolume by the sum of the PrimaryAntibodyVolume, the PrimaryAntibodyDiluentVolume, and the StandardPrimaryAntibodyVolume for each input*)
			calculatedPrimaryAntibodyRatios=RoundOptionPrecision[(resolvedPrimaryAntibodyVolume)/(resolvedPrimaryAntibodyVolume+resolvedPrimaryAntibodyDiluentVolumeNoNull+resolvedStandardPrimaryAntibodyVolumeNoNull),10^-3];

			(* Next, round the resolvedPrimaryAntibodyDilutionFactors to the same precision as the calculated ratios above, to the 0.001 - so we can make a direct comparison *)
			roundedResolvedPrimaryAntibodyDilutionFactors=RoundOptionPrecision[resolvedPrimaryAntibodyDilutionFactor,10^-3];

			(* Here, we filter out the inputs, calculated ratios, and rounded resolved ratios for which the resolvedPrimaryAntibodyDilutionFactor is 1 - making 3 lists *)
			filteredInputsAndAntibodyTuples=PickList[inputsAndAntibodyTuples,resolvedPrimaryAntibodyDilutionFactor,Except[_?(Equal[#, 1] &)]];
			filteredCalculatedPrimaryAntibodyRatios=PickList[calculatedPrimaryAntibodyRatios,resolvedPrimaryAntibodyDilutionFactor,Except[_?(Equal[#, 1] &)]];
			filteredRoundedResolvedPrimaryAntibodyDilutionFactor=PickList[roundedResolvedPrimaryAntibodyDilutionFactors,resolvedPrimaryAntibodyDilutionFactor,Except[_?(Equal[#, 1] &)]];

			(* Make a list of Booleans that tests whether or not the calculatedPrimaryAntibodyRatio is equal to the roundedResolvedPrimaryAntibodyDilutionFactor for each of the filtered list *)
			equalDilutionFactorQ=MapThread[
				Equal[#1,#2]&,
				{filteredCalculatedPrimaryAntibodyRatios,filteredRoundedResolvedPrimaryAntibodyDilutionFactor}
			];

			(* Create lists of the input/antibody tuples for which equalDilutionFactorQ is True or False *)
			failingEqualDilutionInputs=PickList[filteredInputsAndAntibodyTuples,equalDilutionFactorQ,False];
			passingEqualDilutionInputs=PickList[filteredInputsAndAntibodyTuples,equalDilutionFactorQ,True];

			(* Create lists of the calculatedDilutionFactors for which equalDilutionFactorQ is True or False *)
			nonEqualCalculatedDilutionFactors=PickList[filteredCalculatedPrimaryAntibodyRatios,equalDilutionFactorQ,False];
			equalCalculatedDilutionFactors=PickList[filteredCalculatedPrimaryAntibodyRatios,equalDilutionFactorQ,True];

			(* Create lists of the roundedDilutionFactors for which equalDilutionFactorQ is True or False *)
			nonEqualRoundedDilutionFactors=PickList[filteredRoundedResolvedPrimaryAntibodyDilutionFactor,equalDilutionFactorQ,False];
			equalRoundedDilutionFactors=PickList[filteredRoundedResolvedPrimaryAntibodyDilutionFactor,equalDilutionFactorQ,True];

			(* Set the invalid options if failingEqualDilutionInputs contains anything *)
			invalidDilutionFactorOptions=If[Length[failingEqualDilutionInputs]>0,
				{PrimaryAntibodyDilutionFactor,PrimaryAntibodyVolume,PrimaryAntibodyDiluentVolume,StandardPrimaryAntibodyVolume},
				{}
			];

			(* If we are throwing messages, throw a warning if there are any failingEqualDilutionInputs *)
			If[messages&&Length[failingEqualDilutionInputs]>0,
				Message[Error::ConflictingWesternPrimaryAntibodyDilutionFactorOptions,ObjectToString[failingEqualDilutionInputs,Cache->simulatedCache],ToString[nonEqualRoundedDilutionFactors],ToString[nonEqualCalculatedDilutionFactors]]
			];

			(* If we are gathering tests, define the user-facing tests for WesternStandardPrimaryAntibodyVolumeRatioNonIdeal *)
			invalidDilutionFactorTests=If[gatherTests,
				Module[{failingTest,passingTest},

					failingTest=If[Length[failingEqualDilutionInputs]==0,
						Nothing,
						Test["For the following pairs of input samples and antibodies,"<>ObjectToString[failingEqualDilutionInputs,Cache->simulatedCache]<>", the PrimaryAntibodyDilutionFactor, "<>ToString[nonEqualRoundedDilutionFactors]<>", is equal to the DilutionFactor calculated by taking the ratio of the PrimaryAntibodyVolume to the sum of the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, and StandardPrimaryAntibodyVolume, "<>ToString[nonEqualCalculatedDilutionFactors]<>", when each is rounded to the thousandths place.",True,False]
					];
					passingTest=If[Length[passingEqualDilutionInputs]==0,
						Nothing,
						Test["For the following pairs of input samples and antibodies,"<>ObjectToString[passingEqualDilutionInputs,Cache->simulatedCache]<>", the PrimaryAntibodyDilutionFactor, "<>ToString[equalRoundedDilutionFactors]<>", is equal to the DilutionFactor calculated by taking the ratio of the PrimaryAntibodyVolume to the sum of the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, and StandardPrimaryAntibodyVolume, "<>ToString[equalCalculatedDilutionFactors]<>", when each is rounded to the thousandths place.",True,True]
					];
					{failingTest,passingTest}
				],
				Nothing
			];

			(* - Throw Error for standardPrimaryAntibodyStorageConditionErrors - *)
			(* First, determine if we need to throw this Error *)
			standardPrimaryAntibodyStorageConditionErrorQ=MemberQ[standardPrimaryAntibodyStorageConditionErrors,True];

			(* Create lists of the input samples that have the standardPrimaryAntibodyStorageConditionError set to True and to False *)
			failingConflictingStandardPrimaryAntibodyStorageSamples=PickList[simulatedSamples,standardPrimaryAntibodyStorageConditionErrors,True];
			passingConflictingStandardPrimaryAntibodyStorageSamples=PickList[simulatedSamples,standardPrimaryAntibodyStorageConditionErrors,False];

			(* Define the invalid option variable related to the Error below *)
			invalidStandardPrimaryAntibodyStorageOptions=If[standardPrimaryAntibodyStorageConditionErrorQ,
				{StandardPrimaryAntibody,StandardPrimaryAntibodyStorageCondition},
				{}
			];

			(* Throw an error message if we are throwing messages, and there are some input samples that caused standardPrimaryAntibodyStorageConditionErrors to be set to True *)
			If[standardPrimaryAntibodyStorageConditionErrorQ&&messages,
				Message[Error::WesConflictingStandardPrimaryAntibodyStorageOptions,ObjectToString[failingConflictingStandardPrimaryAntibodyStorageSamples,Cache->simulatedCache]]
			];

			(* Define the tests the user will see for the above message *)
			conflictingStandardPrimaryAntibodyStorageTests=If[gatherTests,
				Module[{failingTest,passingTest},
					failingTest=If[standardPrimaryAntibodyStorageConditionErrorQ,
						Test["For the following samples, the StandardPrimaryAntibody and StandardPrimaryAntibodyStorageCondition options are in conflict, "<>ObjectToString[failingConflictingStandardPrimaryAntibodyStorageSamples,Cache->simulatedCache]<>":",True,False],
						Nothing
					];
					passingTest=If[Length[passingConflictingStandardPrimaryAntibodyStorageSamples]>0,
						Test["For the following samples, the StandardPrimaryAntibody and StandardPrimaryAntibodyStorageCondition options are not in conflict, "<>ObjectToString[passingConflictingStandardPrimaryAntibodyStorageSamples,Cache->simulatedCache]<>":",True,True],
						Nothing
					];
					{failingTest,passingTest}
				],
				Nothing
			];
			(* - Throw Error for standardSecondaryAntibodyStorageConditionErrors - *)
			(* First, determine if we need to throw this Error *)
			standardSecondaryAntibodyStorageConditionErrorQ=MemberQ[standardSecondaryAntibodyStorageConditionErrors,True];

			(* Create lists of the input samples that have the standardSecondaryAntibodyStorageConditionError set to True and to False *)
			failingConflictingStandardSecondaryAntibodyStorageSamples=PickList[simulatedSamples,standardSecondaryAntibodyStorageConditionErrors,True];
			passingConflictingStandardSecondaryAntibodyStorageSamples=PickList[simulatedSamples,standardSecondaryAntibodyStorageConditionErrors,False];

			(* Define the invalid option variable related to the Error below *)
			invalidStandardSecondaryAntibodyStorageOptions=If[standardSecondaryAntibodyStorageConditionErrorQ,
				{StandardSecondaryAntibody,StandardSecondaryAntibodyStorageCondition},
				{}
			];

			(* Throw an error message if we are throwing messages, and there are some input samples that caused standardSecondaryAntibodyStorageConditionErrors to be set to True *)
			If[standardSecondaryAntibodyStorageConditionErrorQ&&messages,
				Message[Error::WesConflictingStandardSecondaryAntibodyStorageOptions,ObjectToString[failingConflictingStandardSecondaryAntibodyStorageSamples,Cache->simulatedCache]]
			];

			(* Define the tests the user will see for the above message *)
			conflictingStandardSecondaryAntibodyStorageTests=If[gatherTests,
				Module[{failingTest,passingTest},
					failingTest=If[standardSecondaryAntibodyStorageConditionErrorQ,
						Test["For the following samples, the StandardSecondaryAntibody and StandardSecondaryAntibodyStorageCondition options are in conflict, "<>ObjectToString[failingConflictingStandardSecondaryAntibodyStorageSamples,Cache->simulatedCache]<>":",True,False],
						Nothing
					];
					passingTest=If[Length[passingConflictingStandardSecondaryAntibodyStorageSamples]>0,
						Test["For the following samples, the StandardSecondaryAntibody and StandardSecondaryAntibodyStorageCondition options are not in conflict, "<>ObjectToString[passingConflictingStandardSecondaryAntibodyStorageSamples,Cache->simulatedCache]<>":",True,True],
						Nothing
					];
					{failingTest,passingTest}
				],
				Nothing
			];

			(* Return a flattened list of the tests defined in this module, and the invalid dilution factor options *)
			{
				Flatten[
					{
						nonIdealSecondaryAntibodyTests, nonIdealStandardPrimaryAntibodyTests, nonIdealStandardSecondaryAntibodyTests, nonIdealBlockingBufferTests, nonIdealPrimaryAntibodyDiluentTests,
						lowSecondaryAntibodyVolumeTests, standardPrimaryAntibodyRatioTests,invalidDilutionFactorTests,conflictingStandardPrimaryAntibodyStorageTests,
						conflictingStandardSecondaryAntibodyStorageTests
					}
				],
				invalidDilutionFactorOptions,
				invalidStandardPrimaryAntibodyStorageOptions,
				invalidStandardSecondaryAntibodyStorageOptions
			}
		],
		(* Otherwise, we are in ExperimentTotalProteinDetection and none of this conflicting option checks need to happen, and we return an empty list for the tests, and no Warnings or Errors will be thrown *)
		{{},{},{},{}}
	];

	(* - Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. - *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,tooManyInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[
		{
			invalidPrimaryAntibodyDiluentVolumeOption,invalidStandardPrimaryAntibodyVolumeOption,invalidStandardSecondaryAntibodyVolumeOption,
			nameInvalidOption,compatibleMaterialsInvalidOption,numberOfReplicatesInvalidOption,invalidDenaturingOptions,invalidSystemStandardOptions,
			invalidConflictingNullOptions,invalidLoadingVolumeOptions,invalidAntibodyDilutionOptions,invalidPrimaryAntibodyDilutionOptions,invalidLoadingBufferVolumeOptions,invalidDilutionFactorOptions,
			invalidSamplesInStorageConditionOptions,conflictingStandardPrimaryAntibodyStorageOptions,
			conflictingStandardSecondaryAntibodyStorageOptions
		}
	]];

	(*  Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* - Resolve Aliquot Options - *)
	(* Set the RequiredAliquotAmount option to pass to resolveAliquotOptions, which is the sample volume plus 15 uL *)
	requiredAliquotAmounts=(suppliedSampleVolume+15*Microliter);

	(* - Make a list of the smallest liquid handler compatible container that can potentially hold the needed volume for each sample - *)
	(* First, find the Models and the MaxVolumes of the liquid handler compatible containers *)
	{liquidHandlerContainerModels,liquidHandlerContainerMaxVolumes}=Transpose[Lookup[
		Flatten[liquidHandlerContainerPackets,1],
		{Object,MaxVolume}
	]];

	(* Define the container we would transfer into for each sample, if Aliquotting needed to happen *)
	potentialAliquotContainers=First[
		PickList[
			liquidHandlerContainerModels,
			liquidHandlerContainerMaxVolumes,
			GreaterEqualP[#]
		]
	]&/@requiredAliquotAmounts;

	(* Find the ContainerModel for each input sample *)
	simulatedSamplesContainerModels=Lookup[sampleContainerPackets,Model,{}][Object];

	(* Define the RequiredAliquotContainers - we have to aliquot if the samples are not in a liquid handler compatible container *)
	requiredAliquotContainers=MapThread[
		If[
			MatchQ[#1,Alternatives@@liquidHandlerContainerModels],
			Automatic,
			#2
		]&,
		{simulatedSamplesContainerModels,potentialAliquotContainers}
	];

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=Which[
		westernQ&&gatherTests,
			resolveAliquotOptions[
				ExperimentWestern,
				mySamples,
				simulatedSamples,
				ReplaceRule[allOptionsRounded,resolvedSamplePrepOptions],
				Cache -> simulatedCache,
				RequiredAliquotContainers->requiredAliquotContainers,
				RequiredAliquotAmounts->requiredAliquotAmounts,
				AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
				Output->{Result,Tests}
			],
		westernQ&&!gatherTests,
			{
				resolveAliquotOptions[
					ExperimentWestern,
					mySamples,
					simulatedSamples,
					ReplaceRule[allOptionsRounded,resolvedSamplePrepOptions],
					Cache -> simulatedCache,
					RequiredAliquotContainers->requiredAliquotContainers,
					RequiredAliquotAmounts->requiredAliquotAmounts,
					AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
					Output->Result],{}
			},
		!westernQ&&gatherTests,
			resolveAliquotOptions[
				ExperimentTotalProteinDetection,
				mySamples,
				simulatedSamples,
				ReplaceRule[allOptionsRounded,resolvedSamplePrepOptions],
				Cache -> simulatedCache,
				RequiredAliquotContainers->requiredAliquotContainers,
				RequiredAliquotAmounts->requiredAliquotAmounts,
				AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
				Output->{Result,Tests}
			],
		!westernQ&&!gatherTests,
			{
				resolveAliquotOptions[
					ExperimentTotalProteinDetection,
					mySamples,
					simulatedSamples,
					ReplaceRule[allOptionsRounded,resolvedSamplePrepOptions],
					Cache -> simulatedCache,
					RequiredAliquotContainers->requiredAliquotContainers,
					RequiredAliquotAmounts->requiredAliquotAmounts,
					AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
					Output->Result],{}
			}
	];

	(* -- Here we do a check to make sure Aliquot is set to True if the TotalProteinConcentration of Lysate samples is > 3mg/mL -- *)
	(* Pull out the resolved Aliquot Option from resolvedAliquotOptions *)
	resolvedAliquotBooleans=Lookup[resolvedAliquotOptions,Aliquot];

	(* Make a list of total protein concentrations where Null is replaced by 0 mg/mL *)
	totalProteinConcListNoNull=totalProteinConcList/.(Null->0*Milligram/Milliliter);

	(* Make a list of the input sample/antibody tuples that have lysate inputs *)
	inputLysateAndAntibodyTuples=If[westernQ,
		PickList[inputsAndAntibodyTuples,simulatedSamples,ObjectP[Object[Sample]]],
		{}
	];


	(* Make a list of booleans that checks whether Aliquot is False AND the TotalProteinConcentration is greater than 3 mg/mL for each input lysate sample  *)
	aliquotFailureBools=MapThread[
			If[Or[#1,LessEqual[#2,3*Milligram/Milliliter]],
				False,
				True
			]&,
		{resolvedAliquotBooleans,totalProteinConcListNoNull}
	];


	(* Make a list of the lysate/antibody tuples for which Aliquot is False AND the TotalProteinConcentration is greater than 3 mg/mL *)
	failingLysateAliquotTuples=If[westernQ,
		PickList[inputsAndAntibodyTuples,aliquotFailureBools,True],
		PickList[simulatedSamples,aliquotFailureBools,True]
	];

	(* Make a list of the lysate/antibody tuples for which either Aliquot is True OR the TotalProteinConcentration is less than or equal to 3 mg/mL *)
	passingLysateAliquotTuples=If[westernQ,
		PickList[inputsAndAntibodyTuples,aliquotFailureBools,False],
		PickList[simulatedSamples,aliquotFailureBools,False]
	];

	(* If we are throwing messages and any of the lysate input samples have TotalProteinConcentrations greater than 3 mg/mL and are not being Aliquotted, throw a warning *)
	If[messages&&notInEngine&&Length[failingLysateAliquotTuples]>0,
		Message[Warning::WesInputsShouldBeDiluted,ObjectToString[failingLysateAliquotTuples,Cache->simulatedCache]]
	];

	(* If we are gathering tests, define the user-facing passing and failing tests *)
	lysateDilutionTests=If[gatherTests,
		Module[{failingTest,passingTest},

			failingTest=If[Length[failingLysateAliquotTuples]==0,
				Nothing,
				Test["The following inputs, "<>ObjectToString[failingLysateAliquotTuples,Cache->simulatedCache]<>", have TotalProteinConcentrations greater than 3 mg/mL that are not being diluted with the sample preparation aliquot options.",True,False]
			];
			passingTest=If[Length[passingLysateAliquotTuples]==0,
				Nothing,
				Test["The following inputs, "<>ObjectToString[passingLysateAliquotTuples,Cache->simulatedCache]<>", either have TotalProteinConcentrations less than or equal to 3 mg/mL, or TotalProteinConcentrations greater than 3 mg/mL that are being diluted with the sample preparation aliquot options.",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[allOptionsRounded];

	(* get the resolved Email option; for this experiment. the default is True *)
	email=If[MatchQ[Lookup[allOptionsRounded,Email],Automatic],
		True,
		Lookup[allOptionsRounded,Email]
	];

	(* Determine which blockingBuffer to output, depending on the Experiment function *)
	realBlockingBuffer=If[westernQ,

		(* In ExperimentWestern, we had to resolve the BlockingBuffer option *)
		resolvedBlockingBuffer,

		(* In ExperimentTotalProteinDetection, BlockingBuffer is not Automatic *)
		suppliedBlockingBuffer
	];

	(* Define the resolved options that we will output, taking into account ExperimentWestern versus ExperimentTotalProteinDetection *)
	resolvedOptions=ReplaceRule[
		allOptionsRounded,
		Join[
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			{
				Denaturing->resolvedDenaturing,
				MolecularWeightRange->resolvedMolecularWeightRange,
				DenaturingTemperature->resolvedDenaturingTemperature,
				DenaturingTime->resolvedDenaturingTime,
				Ladder->resolvedLadder,
				LuminescenceReagent->resolvedLuminescenceReagent,
				StackingMatrixLoadTime->resolvedStackingMatrixLoadTime,
				SampleLoadTime->resolvedSampleLoadTime,
				Voltage->resolvedVoltage,
				SeparationTime->resolvedSeparationTime,
				UVExposureTime->resolvedUVExposureTime,
				ConcentratedLoadingBuffer->resolvedConcentratedLoadingBuffer,
				Denaturant->resolvedDenaturant,
				DenaturantVolume->resolvedDenaturantVolume,
				ConcentratedLoadingBufferVolume->suppliedConcentratedLoadingBufferVolume,
				WaterVolume->resolvedWaterVolume,
				SecondaryAntibody->resolvedSecondaryAntibody,
				StandardPrimaryAntibody->resolvedStandardPrimaryAntibody,
				StandardSecondaryAntibody->resolvedStandardSecondaryAntibody,
				BlockingBuffer->realBlockingBuffer,
				SecondaryAntibodyVolume->resolvedSecondaryAntibodyVolume,
				StandardSecondaryAntibodyVolume->resolvedStandardSecondaryAntibodyVolume,
				PrimaryAntibodyDiluent->resolvedPrimaryAntibodyDiluent,
				PrimaryAntibodyDilutionFactor->resolvedPrimaryAntibodyDilutionFactor,
				PrimaryAntibodyVolume->resolvedPrimaryAntibodyVolume,
				PrimaryAntibodyDiluentVolume->resolvedPrimaryAntibodyDiluentVolume,
				StandardPrimaryAntibodyVolume->resolvedStandardPrimaryAntibodyVolume,
				PrimaryAntibodyLoadingVolume->resolvedPrimaryAntibodyLoadingVolume,
				Email->email
			}
		],
		(* Append-> False so that *)
		Append->False
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> Cases[Flatten[
			{
				discardedTests,samplesInStorageTests,tooManyInputsTests,missingTotalProteinConcentrationTests,numberOfReplicatesTests,optionPrecisionTests,invalidPrimaryAntibodyDiluentVolumeTests,
				invalidStandardPrimaryAntibodyVolumeTests,invalidStandardSecondaryAntibodyVolumeTests,validNameTest,compatibleMaterialsTests,conflictingDenaturingOptionsTests,
				conflictingSystemStandardOptionsTests,conflictingNullOptionsTests,nonOptimalSignalDetectionTimesTests,nonOptimalMolecularWeightRangeTests,nonOptimalLadderTests,nonOptimalWashBufferTests,nonOptimalConcentratedLoadingBufferTests,
				loadingVolumeTooLargeTests,largeDilutedPrimaryAntibodyVolumeTest,conflictingAntibodyDilutionTests,invalidPrimaryAntibodyDilutionTests,notEnoughLoadingBufferTests,westernUnresolvableOptionTests,lysateDilutionTests
			}
		],_EmeraldTest]
	}
];



(* ::Subsubsection:: *)
(* resolveIndexMatchedWesternOptions *)


resolveIndexMatchedWesternOptions[
	mySamplePackets_,myRecommendedDilutions_,myPrimaryOrganisms_,myOptions_,mySecondaryAbModels_,myStandardPrimaryAbModels_,
	myStandardSecondaryAbModels_,myBlockingBufferModels_,myPrimaryAbDiluentModels_
]:=MapThread[
	Function[
		{
			samplePacket,recommendedDilution,primaryOrganism,options,secondaryAbModel,standardPrimaryAbModel,standardSecondaryAbModel,
			blockingBufferModel,primaryAbDiluentModel
		},
		Module[
			{
				secondaryAntibody,standardPrimaryAntibody,standardSecondaryAntibody,blockingBuffer,secondaryAntibodyVolume,standardSecondaryAntibodyVolume,primaryAntibodyDiluent,primaryAntibodyDilutionFactor,
				primaryAntibodyVolume,primaryAntibodyDiluentVolume,standardPrimaryAntibodyVolume,nonIdealSecondaryAntibodyWarning,nonIdealStandardPrimaryAntibodyWarning,nonIdealStandardSecondaryAntibodyWarning,
				nonIdealBlockingBufferWarning,nonIdealPrimaryAntibodyDiluentWarning,conflictingPrimaryAbDilutionFactorError,standardPrimaryAntibodyStorageConditionMismatchError,
				standardSecondaryAntibodyStorageConditionMismatchError,suppliedSecondaryAntibody,suppliedStandardPrimaryAntibody,
				suppliedSystemStandard,suppliedStandardSecondaryAntibody,suppliedBlockingBuffer,suppliedSecondaryAntibodyVolume,suppliedPrimaryAntibodyDiluent,suppliedPrimaryAntibodyDilutionFactor,
				suppliedPrimaryAntibodyVolume,suppliedPrimaryAntibodyDiluentVolume,suppliedStandardPrimaryAntibodyVolume,suppliedStandardSecondaryAntibodyVolume,sampleType,
				standardPrimaryAntibodyStorageCondition,standardSecondaryAntibodyStorageCondition
			},

			(* Set up error tracking variables *)
			{
				nonIdealSecondaryAntibodyWarning,nonIdealStandardPrimaryAntibodyWarning,nonIdealStandardSecondaryAntibodyWarning,
				nonIdealBlockingBufferWarning,nonIdealPrimaryAntibodyDiluentWarning,conflictingPrimaryAbDilutionFactorError,
				standardPrimaryAntibodyStorageConditionMismatchError,standardSecondaryAntibodyStorageConditionMismatchError
			}=ConstantArray[False,8];

			(* - Look up information we need for resolver from the samplePacket, sampleModelPacket,, antibodyModelPacket, and options - *)
			(* First, get the supplied options *)
			{
				suppliedSecondaryAntibody,suppliedStandardPrimaryAntibody,suppliedSystemStandard,suppliedStandardSecondaryAntibody,suppliedBlockingBuffer,suppliedSecondaryAntibodyVolume,suppliedPrimaryAntibodyDiluent,
				suppliedPrimaryAntibodyDilutionFactor,suppliedPrimaryAntibodyVolume,suppliedPrimaryAntibodyDiluentVolume,suppliedStandardPrimaryAntibodyVolume,suppliedStandardSecondaryAntibodyVolume,
				standardPrimaryAntibodyStorageCondition,standardSecondaryAntibodyStorageCondition
			}=Lookup[options,
				{
					SecondaryAntibody,StandardPrimaryAntibody,SystemStandard,StandardSecondaryAntibody,BlockingBuffer,SecondaryAntibodyVolume,PrimaryAntibodyDiluent,PrimaryAntibodyDilutionFactor,PrimaryAntibodyVolume,
					PrimaryAntibodyDiluentVolume,StandardPrimaryAntibodyVolume,StandardSecondaryAntibodyVolume,StandardPrimaryAntibodyStorageCondition,
					StandardSecondaryAntibodyStorageCondition
				}
			];

			(* Next, get information from the main input samples *)
			{sampleType}=Lookup[samplePacket,{Type}
			];

			(* -- Resolve the Independent options -- *)
			(* - Resolve the SecondaryAntibody option, and return the re-assigned nonIdealSecondaryAntibodyWarning - *)
			{secondaryAntibody,nonIdealSecondaryAntibodyWarning}=Switch[{suppliedSecondaryAntibody,primaryOrganism,secondaryAbModel},

				(* In the case where the user has left the SecondaryAntibody option as Automatic, we resolve it based on the Organism of the primary antibody input *)
				{Automatic,Rabbit,_},
					{Model[Sample,"Simple Western Goat-AntiRabbit-HRP"],False},
				{Automatic,Mouse,_},
					{Model[Sample,"Simple Western Goat-AntiMouse-HRP"],False},
				{Automatic,Human,_},
					{Model[Sample,"Simple Western Goat-AntiHuman-IgG-HRP"],False},
				{Automatic,Goat,_},
					{Model[Sample,"Simple Western Donkey-AntiGoat-HRP"],False},

				(* In the case where the PrimaryAntibody organism is not known, or if the field does not exist in the primary antibody input type (if its a chemical or stock solution - a no primary Ab control), we resolve to blocking buffer *)
				{Automatic,_,_},
					{Model[Sample,"Simple Western Antibody Diluent 2"],False},

				(* In the cases where the user has specified the Secondary antibody, and its Model is the ideal Model for the primary antibody's Organism (as listed above), we accept it, and no warning is thrown *)
				{Except[Automatic],Rabbit,Model[Sample, "id:dORYzZJdjE9p"]},
					{suppliedSecondaryAntibody,False},
				{Except[Automatic],Mouse,Model[Sample, "id:01G6nvwDLeK7"]},
					{suppliedSecondaryAntibody,False},
				{Except[Automatic],Human,Model[Sample, "id:jLq9jXvOnaL1"]},
					{suppliedSecondaryAntibody,False},
				{Except[Automatic],Goat,Model[Sample, "id:L8kPEjnOVKql"]},
					{suppliedSecondaryAntibody,False},

				(* In the case where the Secondary Antibody has been specified by the user, and it is either not an antibody, or is not ideal for the organism of the primary antibody, or the primary antibody is not an antibody, we accept it but throw a warning *)
				{_,_,_},
					{suppliedSecondaryAntibody,True}
			];

			(* - Resolve the StandardPrimaryAntibodyOption, and return the re-assigned nonIdealStandardPrimaryAntibodyWarning - *)
			{standardPrimaryAntibody,nonIdealStandardPrimaryAntibodyWarning}=Switch[{suppliedStandardPrimaryAntibody,suppliedSystemStandard,primaryOrganism,standardPrimaryAbModel},

				(* In the case where the user has left the StandardPrimaryAntibody option as Automatic, and the SystemStandard option is False, we resolve to Null *)
				{Automatic,False,_,_},
					{Null,False},

				(* In the case where the user has left the StandardPrimaryAntibody option as Automatic and the SystemStandard option is True, we resolve based on the organism of the primary antibody *)
				(* If Primary is a Mouse, we use the mouse standard primary Ab, otherwise we use rabbit *)
				{Automatic,True,Mouse,_},
					{Model[Sample,"Simple Western 10X System Control Primary Antibody-Mouse"],False},
				{Automatic,True,_,_},
					{Model[Sample,"Simple Western 10X System Control Primary Antibody-Rabbit"],False},

				(* In the case where the user sets the option as Null, we accept this, and no error is thrown *)
				{Null,_,_,_},
					{suppliedStandardPrimaryAntibody,False},

				(* In cases where the user has set the StandardPrimaryAntibody, we make sure it is optimal for the Organism of the Primary Antibody *)
				{Except[Null|Automatic],True,Mouse,Model[Sample, "id:dORYzZJdjP55"]},
					{suppliedStandardPrimaryAntibody,False},
				{Except[Null|Automatic],True,_,Model[Sample, "id:BYDOjvGRx4Vq"]},
					{suppliedStandardPrimaryAntibody,False},

				(* If the StandardPrimaryAntibody is not ideal for the Organism of the PrimaryAntibody (or if Primary Ab is not an Ab), we throw a warning *)
				{_,_,_,_},
					{suppliedStandardPrimaryAntibody,True}
			];

			(* - Set the standardPrimaryAntibodyStorageConditionMismatchError - *)
			standardPrimaryAntibodyStorageConditionMismatchError=If[

				(* IF the StandardPrimaryAntibodyStorageCondition is NOT Null but the StandardPrimaryAntibody IS Null*)
				And[
					MatchQ[standardPrimaryAntibodyStorageCondition,Except[Null]],
					MatchQ[standardPrimaryAntibody,Null]
				],

				(* THEN the options are mismatched and we need to throw an Error *)
				True,

				(* ELSE it's fine *)
				False
			];

			(* - Resolve the StandardSecondaryAntibody option, and return the re-assigned nonIdealStandardPrimaryAntibodyWarning - *)
			{standardSecondaryAntibody,nonIdealStandardSecondaryAntibodyWarning}=Switch[{suppliedStandardSecondaryAntibody,standardPrimaryAntibody,standardPrimaryAbModel,primaryOrganism,standardSecondaryAbModel},

				(* In the case where the user has left the StandardSecondaryAntibody Automatic, and standardPrimaryAntibody has resolved to Null, resolve StandardSecondaryAntibody to Null as well (most cases) *)
				{Automatic,Null,_,_,_},
					{Null,False},

				(* If the user has left the StandardSecondaryAntibody as Automatic, and the standardPrimaryAntibody is not Null, we base the StandardSecondaryAntibody on the Model of the standardPrimaryAntibody (which is either the standardPrimaryAntibody, or the standardPrimaryAbModel if the StandardPrimaryAntibody was given as an Object and not a Model) and the Organism of the Primary Antibody *)
				(* If the PrimaryStandardAntibody has resolved to the Mouse System Control Primary Antibody, and the primary antibody is from a mouse, we don't need a standard secondary, as the main secondary will detect the Mouse StandardPrimaryAb *)
				{Automatic,Model[Sample,"Simple Western 10X System Control Primary Antibody-Mouse"],_,Mouse,_},
					{Null,False},
				{Automatic,_,Model[Sample, "id:dORYzZJdjP55"],Mouse,_},
					{Null,False},

				(* If the PrimaryStandardAntibody has resolved to the Rabbit System Control Primary Antibody, and the primary antibody is from a rabbit, we don't need a standard secondary, as the main secondary will detect the Mouse StandardPrimaryAb *)
				{Automatic,Model[Sample,"Simple Western 10X System Control Primary Antibody-Rabbit"],_,Rabbit,_},
					{Null,False},
				{Automatic,_,Model[Sample, "id:BYDOjvGRx4Vq"],Rabbit,_},
					{Null,False},

				(* If the PrimaryStandardAntibody has resolved to the Rabbit System Control Primary Antibody, and the primary antibody is not from a Rabbit, we need the Anti-Rabbit StandardSecondaryAb to detect the StandardPrimaryAb *)
				{Automatic,Model[Sample,"Simple Western 10X System Control Primary Antibody-Rabbit"],_,_,_},
					{Model[Sample, "Simple Western 20X Goat-AntiRabbit-HRP"],False},
				{Automatic,_,Model[Sample, "id:BYDOjvGRx4Vq"],_,_},
					{Model[Sample, "Simple Western 20X Goat-AntiRabbit-HRP"],False},

				(* If the StandardSecondaryAntibody is automatic, but the StandardPrimaryAntibody is not one of the default standard antibodies, we resolve the StandardSecondaryAb to the Anti-Rabbit HRP, but throw a warning *)
				{Automatic,_,_,_,_},
					{Model[Sample, "Simple Western 20X Goat-AntiRabbit-HRP"],True},

				(* In the case where the user has set the StandardSecondaryAntibody as Null, we accept this and no error is thrown *)
				{Null,_,_,_,_},
					{suppliedStandardSecondaryAntibody,False},

				(* If the uer has set the StandardSecondaryAntibody, we need to check that it is ideal for the standardPrimaryAntibody and primary antibody Organism *)
				(* In the cases where the primaryStandardAntibody is the Mouse System Control, and the primary Ab is from a mouse, we don't need a standard Secondary, so throw a warning*)
				{Except[Null|Automatic],Model[Sample,"Simple Western 10X System Control Primary Antibody-Mouse"],_,Mouse,_},
					{suppliedStandardSecondaryAntibody,True},
				{Except[Null|Automatic],_,Model[Sample, "id:dORYzZJdjP55"],Mouse,_},
					{suppliedStandardSecondaryAntibody,True},

				(* In the cases where the primaryStandardAntibody is the Rabbit System Control, and the primary Ab is from a rabbit, we don't need a standard Secondary, so throw a warning *)
				{Except[Null|Automatic],Model[Sample,"Simple Western 10X System Control Primary Antibody-Rabbit"],_,Rabbit,_},
					{suppliedStandardSecondaryAntibody,True},
				{Except[Null|Automatic],_,Model[Sample, "id:BYDOjvGRx4Vq"],Rabbit,_},
					{suppliedStandardSecondaryAntibody,True},

				(* In cases where the StandardSecondaryAb is set but the primaryStandardAntibody has resolved to Null, accept it but throw a warning *)
				{Except[Null|Automatic],Null,_,_,_},
					{suppliedStandardSecondaryAntibody,True},

				(* If the set StandardSecondaryAb is the 20X Anti-Rabbit, we accept this and don't throw an error *)
				{_,_,_,_,Model[Sample, "id:n0k9mG8K7BYk"]},
					{suppliedStandardSecondaryAntibody,False},

				(* In all other cases, we accept the input StandardSecondaryAntibody but throw an error *)
				{_,_,_,_,_},
					{suppliedStandardSecondaryAntibody,True}
			];

			(* - Set the standardSecondaryAntibodyStorageConditionMismatchError - *)
			standardSecondaryAntibodyStorageConditionMismatchError=If[

				(* IF the StandardSecondaryAntibodyStorageCondition is NOT Null but the StandardSecondaryAntibody IS Null*)
				And[
					MatchQ[standardSecondaryAntibodyStorageCondition,Except[Null]],
					MatchQ[standardSecondaryAntibody,Null]
				],

				(* THEN the options are mismatched and we need to throw an Error *)
				True,

				(* ELSE it's fine *)
				False
			];

			(* - Resolve the BlockingBuffer option, and return the re-assigned nonIdealBlockingBufferWarning - *)
			{blockingBuffer,nonIdealBlockingBufferWarning}=Switch[{suppliedBlockingBuffer,primaryOrganism,blockingBufferModel},

				(* If the user has left the BlockingBuffer option as Automatic, we resolve it based on the Organism of the PrimaryAntibody input *)
				{Automatic,Goat,_},
					{Model[Sample,"Simple Western Milk-Free Antibody Diluent"],False},
				{Automatic,_,_},
					{Model[Sample,"Simple Western Antibody Diluent 2"],False},

				(* If the user has set the BlockingBuffer option, we must check that is the default for the Organism of the primary antibody, otherwise we should throw a warning *)
				(* The default for Goat PrimaryAntibody is the Milk-free diluent*)
				{Except[Automatic],Goat,Model[Sample, "id:1ZA60vLzED4q"]},
					{suppliedBlockingBuffer,False},
				{Except[Automatic],Goat,_},
					{suppliedBlockingBuffer,True},

				(* The default for all other PrimaryAntibodies is PrimaryDiluent 2*)
				{Except[Automatic],_,Model[Sample, "id:Y0lXejMrXxja"]},
					{suppliedBlockingBuffer,False},
				{Except[Automatic],_,_},
					{suppliedBlockingBuffer,True}
			];

			(* - Resolve the SecondaryAntibodyVolume option - *)
			secondaryAntibodyVolume=Switch[{suppliedSecondaryAntibodyVolume,standardSecondaryAntibody,suppliedStandardSecondaryAntibodyVolume},

				(* If the user left the SecondaryAntibodyVolume Automatic, resolve it to 10 uL if standardSecondaryAntibody is Null, and 9.5*Microliter or 19 times the supplied standard secondary antibody volume otherwise *)
				{Automatic,Null,_},
					10*Microliter,
				{Automatic,_,Automatic},
					9.5*Microliter,
				{Automatic,_,Except[Automatic]},
					RoundOptionPrecision[(19*suppliedStandardSecondaryAntibodyVolume),10^-1*Microliter,AvoidZero->True],

				(* If the user has set the SecondaryAntibodyVolume, we accept it, and do not throw any messages *)
				{Except[Automatic],_,_},
					suppliedSecondaryAntibodyVolume
			];

			(* - Resolve the StandardSecondaryAntibodyVolume option - *)
			standardSecondaryAntibodyVolume=Switch[{suppliedStandardSecondaryAntibodyVolume,standardSecondaryAntibody,secondaryAntibodyVolume},

				(* If the user left the StandardSecondaryAntibodyVolume Automatic, resolve it based on the secondaryAntibodyVolume and if the standardSecondaryAntibody is Null *)
				{Automatic,Null,_},
					Null,
				{Automatic,_,_},
					Max[RoundOptionPrecision[(secondaryAntibodyVolume/19),10^-1*Microliter,AvoidZero->True],0.5*Microliter],

				(* If the user has set the StandardSecondaryAntibodyVolume, we accept it, and do not throw any messages *)
				{Except[Automatic],_,_},
					suppliedStandardSecondaryAntibodyVolume
			];

			(* - Resolve the PrimaryAntibodyDiluent - *)
			{primaryAntibodyDiluent,nonIdealPrimaryAntibodyDiluentWarning}=Switch[{suppliedPrimaryAntibodyDiluent,suppliedPrimaryAntibodyDilutionFactor,suppliedPrimaryAntibodyDiluentVolume,recommendedDilution,primaryOrganism,primaryAbDiluentModel},

				(* Cases where the user has left the PrimaryAntibodyDiluent as Automatic *)
				(* The various cases we should resolve to Null - if the user has specified dilution factor as 1, if the diluent volume is 0 or Null, or if the recommended dilution of the primary antibody is 1 and the other two options were left as automatic *)
				{Automatic,_?(Equal[#, 1] &),_,_,_,_},
					{Null,False},
				{Automatic,_,Null|_?(Equal[#, 0*Microliter]&),_,_,_},
					{Null,False},
				{Automatic,Automatic,Automatic,_?(Equal[#, 1] &),_,_},
					{Null,False},

				(* In other cases where the PrimaryAntibodyDiluent is left as Automatic (when dilution will actually have to occur), we resolve based on the Organism of the primary antibody *)
				(* If primary Ab comes from a Goat, we resolve to the Milk-Free Antibody Diluent, otherwise, Ab Diluent 2*)
				{Automatic,_,_,_,Goat,_},
					{Model[Sample,"Simple Western Milk-Free Antibody Diluent"],False},
				{Automatic,_,_,_,_,_},
					{Model[Sample,"Simple Western Antibody Diluent 2"],False},

				(* Cases where the user has set the PrimaryAntibodyDiluent *)
				(* If the PrimaryAntibodyDiluent is set to Null, we accept this, and throw no warning *)
				{Null,_,_,_,_,_},
					{suppliedPrimaryAntibodyDiluent,False},

				(* If the user has set the PrimaryAntibodyDiluent to something, we just check that it is the default for the PrimaryAntibody's organism *)
				(* The default for Goat PrimaryAntibody is the Milk-free diluent*)
				{_,_,_,_,Goat,Model[Sample, "id:1ZA60vLzED4q"]},
					{suppliedPrimaryAntibodyDiluent,False},
				{_,_,_,_,Goat,_},
					{suppliedPrimaryAntibodyDiluent,True},

				(* The default for all other PrimaryAntibodies is PrimaryDiluent 2*)
				{_,_,_,_,_,Model[Sample, "id:Y0lXejMrXxja"]},
					{suppliedPrimaryAntibodyDiluent,False},
				{_,_,_,_,_,_},
					{suppliedPrimaryAntibodyDiluent,True}
			];

			(* - Resolve the PrimaryAntibodyDilutionFactor. The PrimaryAntibodyDilutionFactor is the ratio of PrimaryAntibodyVolume to the total Volume (PrimaryAntiBodyVolume plus PrimaryAntibodyDiluentVolume (when not Null), and the StandardPrimaryAntibodyVolume (when SystemStandard is True) - *)
			{primaryAntibodyDilutionFactor,conflictingPrimaryAbDilutionFactorError}=Switch[{suppliedPrimaryAntibodyDilutionFactor,suppliedSystemStandard,primaryAntibodyDiluent,suppliedPrimaryAntibodyVolume,suppliedPrimaryAntibodyDiluentVolume,suppliedStandardPrimaryAntibodyVolume,recommendedDilution},

				(* -- Cases where the user has left the PrimaryAntibodyDilutionFactor as Automatic -- *)
				(* - If SystemStandard is False, we need to check if the PrimaryAntibodyVolume and PrimaryAntibodyDiluentVolume are both set (and check if PrimaryAntibodyDiluent is Null or not) - based on these results we either resolve to the Recommended Dilution of the PrimaryAntibody, or calculate the DilutionFactor from the volumes - *)
				(* If the primaryAntibodyDiluent is Null, and SystemStandard is False, then the dilution factor must be 1 - no dilution is occurring *)
				{Automatic,False,Null,_,_,_,_},
					{1,False},

				(* If the PrimaryAntibodyVolume and PrimaryAntibodyDiluentVolume are both set, we calculate the PrimaryAntibodyDilutionFactor from these two variables *)
				{Automatic,False,_,Except[Automatic],Null,_,_},
					{1,False},
				{Automatic,False,_,Except[Automatic],Except[Null|Automatic],_,_},
					{Max[RoundOptionPrecision[(suppliedPrimaryAntibodyVolume/(suppliedPrimaryAntibodyVolume+suppliedPrimaryAntibodyDiluentVolume)),10^-5,AvoidZero->True],0.005],False},

				(* If the PrimaryAntibodyVolume has been left as automatic, but the PrimaryAntibodyDiluentVolume has been set, we calculate the dilution factor assuming that the PrimaryAntibodyVolume will resolve to 1 uL below*)
				{Automatic,False,_,Automatic,Except[Null|Automatic],_,_},
					{Max[RoundOptionPrecision[1*Microliter/(1*Microliter+suppliedPrimaryAntibodyDiluentVolume),10^-5,AvoidZero->True],0.005],False},

				(* If the Recommended Dilution is Null or $Failed, (if PrimaryAntibody is a control and not an Antibody), we resolve to 1 *)
				{Automatic,False,_,_,_,_,Null|$Failed},
					{1,False},

				(* Otherwise, resolve the PrimaryAntibodyDilutionFactor to the recommended dilution of the antibody *)
				{Automatic,False,_,_,_,_,_},
					{Max[recommendedDilution,0.005],False},

				(* - If the SystemStandard is True, there is similar resolution to above, but we also need to take account the StandardPrimaryAntibodyVolume into our calculations - *)
				(* This will have to be a special case going forward, where one of the ready-to-use antibodies is given (dilution factor of 1), but we are using a StandardPrimaryAntibody - will still resolve to 1 as Dilution factor, but ignore these cases in later error checking *)
				(* If the primaryAntibodyDiluent is Null, and SystemStandard is True, then the dilution factor must be 1 - no dilution is occurring (except for StandardPrimaryAntibody dilution - but we don't know about that yet) *)
				{Automatic,True,Null,_,_,_,_},
					{1,False},

				(* If the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, StandardPrimaryAntibodyVolume are all set, we calculate the PrimaryAntibodyDilutionFactor from these three variables *)
				(* If the PrimaryAntibodyDiluentVolume is Null, the only dilution occurs from StandardPrimaryAntibodyVolume, so we set dilution factor to 1  *)
				{Automatic,True,_,_,Null,_,_},
					{1,False},
				{Automatic,True,_,Except[Automatic],Except[Null|Automatic],Except[Null|Automatic],_},
					{Max[RoundOptionPrecision[(suppliedPrimaryAntibodyVolume/(suppliedPrimaryAntibodyVolume+suppliedPrimaryAntibodyDiluentVolume+suppliedStandardPrimaryAntibodyVolume)),10^-5,AvoidZero->True],0.005],False},

				(* If the PrimaryAntibodyVolume is left as Automatic, resolve the PrimaryAntibodyDilutionFactor taking into account the other variables, and assuming that the PrimaryAntibodyVolume will be 1*Microliter *)
				(* In this case, both the PrimaryAntibodyDiluentVolume and StandardPrimaryAntibodyVolume are set, use them to calculate the PrimaryAntibodyDilutionFactor *)
				{Automatic,True,_,Automatic,Except[Automatic|Null],Except[Automatic|Null],_},
					{Max[RoundOptionPrecision[(1*Microliter/(1*Microliter+suppliedPrimaryAntibodyDiluentVolume+suppliedStandardPrimaryAntibodyVolume)),10^-5,AvoidZero->True],0.005],False},

				(* In this case, only the PrimaryAntibodyDiluentVolume is set, use it, and assume that the StandardPrimaryAntibodyVolume is 10% of the total volume, and the PrimaryAntibodyVolume is 1 uL, to calculate the dilution factor. Solving for D where D=9x/(10x+10y) *)
				{Automatic,True,_,Automatic,Except[Automatic|Null],Automatic,_},
					{Max[RoundOptionPrecision[(9*Microliter)/(10*Microliter+(10*suppliedPrimaryAntibodyDiluentVolume)),10^-5,AvoidZero->True],0.005],False},

				(* If the PrimaryAntibodyVolume and PrimaryAntibodyDiluentVolume are set, but the StandardPrimaryAntibodyVolume has been left as automatic, calculate  the PrimaryAnitbodyDilutionFactor assuming the StandardPrimaryAntibodyVolume will be 10% of the total volume. Solving for D where D= 10x/(11x+11y)*)
				{Automatic,True,_,Except[Null|Automatic],Except[Null|Automatic],Automatic,_},
					{Max[RoundOptionPrecision[((10/11)*(suppliedPrimaryAntibodyVolume)/(suppliedPrimaryAntibodyVolume+suppliedPrimaryAntibodyDiluentVolume)),10^-5,AvoidZero->True],0.005],False},

				(* If the Recommended Dilution is Null or $Failed, (if PrimaryAntibody is a control and not an Antibody), we resolve to 1 *)
				{Automatic,True,_,_,_,_,Null|$Failed},
					{1,False},

				(* Otherwise, resolve the PrimaryAntibodyDilutionFactor to the recommended dilution of the antibody *)
				{Automatic,True,_,_,_,_,_},
					{Max[recommendedDilution,0.005],False},

				(* -- Cases where the user has set the PrimaryAntibodyDilutionFactor - we accept it always, but might need to throw an error -- *)
				(* - If SystemStandard is False, we need to check if the PrimaryAntibodyVolume and PrimaryAntibodyDiluentVolume, and if they are, if the supplied dilution factor makes sense, if not, error - *)
				(* If the primaryAntibodyDiluent is Null, and SystemStandard is False, then the dilution factor must be 1 - no dilution is occurring - error check later *)
				{Except[Automatic],False,Null,_,_,_,_},
					{suppliedPrimaryAntibodyDilutionFactor,False},

				(* If both PrimaryAntibodyVolume and PrimaryAntibodyDiluentVolume are set, check to make sure the supplied dilution factor makes sense (round the given Dilution factor and the volume ratios to the same precision and compare them) *)
				{Except[Automatic],False,_,Except[Automatic],Except[Null|Automatic],_,_},
					{suppliedPrimaryAntibodyDilutionFactor,
						If[Equal[RoundOptionPrecision[suppliedPrimaryAntibodyDilutionFactor,10^-3,AvoidZero->True],RoundOptionPrecision[(suppliedPrimaryAntibodyVolume/(suppliedPrimaryAntibodyVolume+suppliedPrimaryAntibodyDiluentVolume)),10^-3,AvoidZero->True]],
							False,
							True
						]},

				(* Otherwise, if they are not both set, we accept their given dilution factor and do not throw an error later *)
				{Except[Automatic],False,_,_,_,_,_},
					{suppliedPrimaryAntibodyDilutionFactor,False},

				(* - If SystemStandard is True, there is a similar resolution to above, but we also need to take account the StandardPrimaryAntibodyVolume into our calculations - *)
				(* If the primaryAntibodyDiluent is Null, and SystemStandard is False, then we accept their dilution factor *)
				{Except[Automatic],True,Null,_,_,_},
					{suppliedPrimaryAntibodyDilutionFactor,False},

				(* If all three of the PrimaryAntibodyVolume, PrimaryAntibodyDilutionFactor, and StandardPrimaryAntibodyVolume are set, we accept their given dilution factor but check to make sure it fits with the other given variables, if not we will have to throw an error *)
				{Except[Automatic],True,_,Except[Automatic],Except[Null|Automatic],Except[Null|Automatic],_},
					{suppliedPrimaryAntibodyDilutionFactor,
						If[Equal[RoundOptionPrecision[suppliedPrimaryAntibodyDilutionFactor,10^-3,AvoidZero->True],RoundOptionPrecision[(suppliedPrimaryAntibodyVolume/(suppliedPrimaryAntibodyVolume+suppliedPrimaryAntibodyDiluentVolume+suppliedStandardPrimaryAntibodyVolume)),10^-3,AvoidZero->True]],
							False,
							True
						]},

				(* Otherwise, if not all three are set, we accept their given dilution factor and do not throw an error later *)
				{Except[Automatic],True,_,_,_,_,_},
					{suppliedPrimaryAntibodyDilutionFactor,False}
			];

			(* - Resolve the PrimaryAntibodyVolume. When possible and when it makes sense to (when dilution factor does not equal 1), we are resolving for a total volume of 200 uL of diluted primary with diluent and standard - make sure that we resolve to at least 1*Microliter - *)
			primaryAntibodyVolume=Switch[{suppliedPrimaryAntibodyVolume,suppliedSystemStandard,primaryAntibodyDilutionFactor,suppliedPrimaryAntibodyDiluentVolume,suppliedStandardPrimaryAntibodyVolume,primaryAntibodyDiluent},

				(* -- Cases where the user has left the PrimaryAntibodyVolume option as automatic -- *)
				(* - If SystemStandard is False, we resolve the PrimaryAntibodyVolume based on the primaryAntibodyDilutionFactor the suppliedPrimaryAntibodyDiluentVolume, amd the primaryAntibodyDiluent (if it is Null) - *)
				(* In the case that the primaryAntibodyDiluent is Null, we resolve to 36*Microliter, need enough PrimaryAntibody to be able to pipette in and out of the Antibody-prep plate *)
				{Automatic,False,_,_,_,Null},
					36*Microliter,

				(* If the PrimaryAntibodyDiluentVolume is left as Automatic, calculate the PrimaryAntibodyVolume based on the primaryAntibodyDilutionFactor aiming for a total volume of 200 uL, (except if the dilution factor is 1, then we resolve to 36*Microliter) *)
				{Automatic,False,_?(Equal[#, 1] &),Automatic,_,_},
					36*Microliter,
				{Automatic,False,_,Automatic,_,_},
					Min[Max[RoundOptionPrecision[(primaryAntibodyDilutionFactor*200)*Microliter,10^-1*Microliter,AvoidZero->True],1*Microliter],200*Microliter],

				(* If the PrimaryAntibodyDiluentVolume is set by the user, use it and the primaryAntibodyDilutionFactor to calculate the PrimaryAntibodyVolume (simple algebra required) *)
				{Automatic,False,_,Except[Automatic],_,_},
					Min[Max[RoundOptionPrecision[((primaryAntibodyDilutionFactor*suppliedPrimaryAntibodyDiluentVolume)/(1-primaryAntibodyDilutionFactor)),10^-1*Microliter,AvoidZero->True],1*Microliter],200*Microliter],

				(* - If SystemStandard is True, we resolve the PrimaryAntibodyVolume based on the primaryAntibodyDilutionFactor, the suppliedPrimaryAntibodyDiluentVolume, the suppliedStandardPrimaryAntibodyVolume, and the primaryAntibodyDiluent (if it is Null) - *)
				(* In the case that the primaryAntibodyDiluent is Null, we resolve to 36*Microliter, need enough PrimaryAntibody to be able to pipette in and out of the Antibody-prep plate, and want to add 4*Microliter of 10X standard later to make a total volume of 40 uL *)
				{Automatic,True,_,_,_,Null},
					36*Microliter,

				(* If the PrimaryAntibodyDiluentVolume and the StandardPrimaryAntibodyVolume are BOTH left as Automatic, calculate the PrimaryAntibodyVolume based on the primaryAntibodyDilutionFactor aiming for a total volume of 200 uL, (except if the dilution factor is 1, then we resolve to 36*Microliter, and only need to check that the diluent volume is automatic) *)
				{Automatic,True,_?(Equal[#, 1] &),Automatic,_,_},
					36*Microliter,
				{Automatic,True,_,Automatic,Automatic,_},
					Min[Max[RoundOptionPrecision[(primaryAntibodyDilutionFactor*200)*Microliter,10^-1*Microliter,AvoidZero->True],1*Microliter],200*Microliter],

				(* If the PrimaryAntibodyDiluentVolume and the StandardPrimaryAntibodyVolume are BOTH set values, use them and the primaryAntibodyDilutionFactor to calculate the PrimaryAntibodyVolume (simple algebra required) *)
				{Automatic,True,_,Except[Automatic],Except[Automatic],_},
					Min[Max[RoundOptionPrecision[(((primaryAntibodyDilutionFactor*suppliedPrimaryAntibodyDiluentVolume)+(primaryAntibodyDilutionFactor*suppliedStandardPrimaryAntibodyVolume))/(1-primaryAntibodyDilutionFactor)),10^-1*Microliter,AvoidZero->True],1*Microliter],200*Microliter],

				(* If only the PrimaryAntibodyDiluentVolume is set, and the StandardPrimaryAntibodyVolume is left as automatic, calculate the PrimaryAntibodyVolume based on the assumption that the StandardPrimaryAntibodyVolume will take up 10% of the total volume (that is what the defaults have) (slightly more complicated algebra required) Solving for x where D = 9x/(10x+10y) *)
				{Automatic,True,_,Except[Automatic],Automatic,_},
					Min[Max[RoundOptionPrecision[((-10*primaryAntibodyDilutionFactor*suppliedPrimaryAntibodyDiluentVolume)/((10*primaryAntibodyDilutionFactor)-9)),10^-1*Microliter,AvoidZero->True],1*Microliter],200*Microliter],

				(* If only the StandardPrimaryAntibodyVolume is set (why would anyone ever do this), and the PrimaryAntibodyDiluentVolume is left as automatic, calculate  the PrimaryAntibodyVolume based on the assumption that the StandardPrimaryAntibodyVolume will take up 10% of the total volume (that is what the defaults have) (easier algebra, since no x in denominator), solving for x where D=x/(10*z)  *)
				{Automatic,True,_,Automatic,Except[Automatic],_},
					Min[Max[RoundOptionPrecision[(10*primaryAntibodyDilutionFactor*suppliedStandardPrimaryAntibodyVolume),10^-1*Microliter,AvoidZero->True],1*Microliter],200*Microliter],

				(* -- Cases where the user has explicitly set the PrimaryAntibodyVolume Option - we don't need to do error checking here, as some error checking is done above in resolving the dilution factor, and others will be done below after the mapthread -- *)
				{_,_,_,_,_,_},
					suppliedPrimaryAntibodyVolume
			];

			(* - Resolve the PrimaryAntibodyDiluentVolume. When possible and when it makes sense to (when dilution factor does not equal 1), we are resolving for a total volume of 200 uL of diluted primary with diluent and standard - ensure that we resolve to a minimum of 1*Microliter - *)
			primaryAntibodyDiluentVolume=Switch[{suppliedPrimaryAntibodyDiluentVolume,suppliedSystemStandard,suppliedStandardPrimaryAntibodyVolume,primaryAntibodyDiluent},

				(* -- Cass where the user has left the PrimaryAntibodyDiluentVolume option as Automatic -- *)
				(* - If SystemStandard is False, we resolve the PrimaryAntibodyDiluentVolume based on the primaryAntibodyDiluent, the primaryAntibodyVolume, and the primaryAntibodyDilutionFactor - *)
				(* In the case where the primaryAntibodyDiluent is Null, we resolve to Null (when dilution factor is 1) *)
				{Automatic,False,_,Null},
					Null,

				(* Otherwise, we calculate the required PrimaryAntibodyDiluentVolume from the primaryAntibodyVolume and the primaryAntibodyDilutionFactor (simple algebra, solving for y where D = x/(x+y) *)
				{Automatic,False,_,_},
					Min[Max[RoundOptionPrecision[((primaryAntibodyVolume/primaryAntibodyDilutionFactor)-primaryAntibodyVolume),10^-1*Microliter,AvoidZero->True],1*Microliter],200*Microliter],

				(* - If SystemStandard is True, we resolve the PrimaryAntibodyDiluentVolume based on the primaryAntibodyDiluent, the primaryAntibodyVolume, the primaryAntibodyDilutionFactor, and the suppliedStandardPrimaryAntibodyVolume - *)
				(* In the case where the primaryAntibodyDiluent is Null, we resolve to Null (when dilution factor is 1) *)
				{Automatic,True,_,Null},
					Null,

				(* In the case where the suppliedStandardPrimaryAntibodyVolume is a set value, we calculate the PrimaryAntibodyDiluentVolume based on the suppliedStandardPrimaryAntibodyVolume, the primaryAntibodyVolume, and the primaryAntibodyDilutionFactor, solving for y where D = x/(x+y+z) *)
				{Automatic,True,Except[Automatic],_},
					Min[Max[RoundOptionPrecision[((primaryAntibodyVolume/primaryAntibodyDilutionFactor)-primaryAntibodyVolume-suppliedStandardPrimaryAntibodyVolume),10^-1*Microliter,AvoidZero->True],1*Microliter],200*Microliter],

				(* In the case where the suppliedStandardPrimaryAntibodyVolume has been left as Automatic, we calculate the PrimaryAntibodyDiluentVolume based on the primaryAntibodyVolume and the primaryAntibodyDilutionFactor, with the assumption that the StandardPrimaryAntibodyVolume will be 10% of the total volume (default value), slightly more complicated algebra required, solving for y where D = 9x/(10x+10y) (z is x/9 + y/9 and gets substituted in) *)
				{Automatic,True,Automatic,_},
					Min[Max[RoundOptionPrecision[(((9*primaryAntibodyVolume)-(10*primaryAntibodyVolume*primaryAntibodyDilutionFactor))/(10*primaryAntibodyDilutionFactor)),10^-1*Microliter,AvoidZero->True],1*Microliter],200*Microliter],

				(* -- Cases where the user has explicitly set the PrimaryAntibodyDiluentVolume Option - we don't need to do error checking here, as some error checking is done above in resolving the dilution factor, and others will be done below after the mapthread -- *)
				{_,_,_,_},
					suppliedPrimaryAntibodyDiluentVolume

			];

			(* - Resolve the StandardPrimaryAntibodyVolume - later we will check to make sure its 10% of the total volume - *)
			standardPrimaryAntibodyVolume=Switch[{suppliedStandardPrimaryAntibodyVolume,suppliedSystemStandard,primaryAntibodyDilutionFactor},

				(* - Cases where users have left the StandardPrimaryAntibodyVolume option as automatic - *)
				(* If SystemStandard is False, we resolve StandardPrimaryAntibodyVolume to Null *)
				{Automatic,False,_},
					Null,

				(* If System Standard is True, we calculate the StandardPrimaryAntibodyVolume from the primaryAntibodyVoulume, the primaryAmtibodyDilutionFactor,and the primaryAntibodyDiluentVolume *)
				(* If the primaryAntibodyDilutionFactor is 1, then we calculate the StandardPrimaryAntibodyVolume to be 10% of the primary antibody volume, since there will be no diluent *)
				{Automatic,True,_?(Equal[#, 1] &)},
					Min[Max[RoundOptionPrecision[(primaryAntibodyVolume/9),10^-1*Microliter,AvoidZero->True],1*Microliter],200*Microliter],
				{Automatic,True,_},
					Min[Max[RoundOptionPrecision[(((-primaryAntibodyDilutionFactor*primaryAntibodyVolume)-(primaryAntibodyDilutionFactor*primaryAntibodyDiluentVolume)+primaryAntibodyVolume)/primaryAntibodyDilutionFactor),10^-1*Microliter,AvoidZero->True],1*Microliter],200*Microliter],

				(* - In the case where the user has for some reason specified the StandardPrimaryAntibodyVolume instead of letting it automatically resolve, we accept their value and don't need to error check. we will error check after the mapthread - *)
				{_,_,_},
					suppliedStandardPrimaryAntibodyVolume
			];

			(* Return the resolved options *)
			{
				secondaryAntibody,standardPrimaryAntibody,standardSecondaryAntibody,blockingBuffer,secondaryAntibodyVolume,standardSecondaryAntibodyVolume,primaryAntibodyDiluent,primaryAntibodyDilutionFactor,
				primaryAntibodyVolume,primaryAntibodyDiluentVolume,standardPrimaryAntibodyVolume,nonIdealSecondaryAntibodyWarning,nonIdealStandardPrimaryAntibodyWarning,nonIdealStandardSecondaryAntibodyWarning,
				nonIdealBlockingBufferWarning,nonIdealPrimaryAntibodyDiluentWarning,conflictingPrimaryAbDilutionFactorError,standardPrimaryAntibodyStorageConditionMismatchError,
				standardSecondaryAntibodyStorageConditionMismatchError
			}
		]
	],
	{
		mySamplePackets,myRecommendedDilutions,myPrimaryOrganisms,myOptions,mySecondaryAbModels,myStandardPrimaryAbModels,
		myStandardSecondaryAbModels,myBlockingBufferModels,myPrimaryAbDiluentModels
	}
];



(* ::Subsubsection:: *)
(* wesResourcePackets *)


(* --- wesResourcePackets --- *)

DefineOptions[
	wesResourcePackets,
	Options:>{HelperOutputOption,CacheOption}
];

wesResourcePackets[mySamples:ListableP[ObjectP[Object[Sample]]],myAntibodies:ListableP[ObjectP[{Object[Sample], Model[Sample]}]]|{},myTemplatedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{
		resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,westernQ,protocolID,type,unCollapsedResolvedOptions,cache,listedSampleContainers,liquidHandlerContainerDownload,
		sampleContainersIn,liquidHandlerContainerMaxVolumes,numberOfReplicates,instrument,denaturing,name,
		molecularWeightRange,ladder,washBuffer,concentratedLoadingBuffer,denaturant,labelingReagent,peroxidaseReagent,ladderPeroxidaseReagent,
		denaturingTemperature,denaturingTime,luminescenceReagent,luminescenceReagentVolume,luminescenceReagentVolumeRule,
		ladderVolume,separatingMatrixLoadTime,stackingMatrixLoadTime,sampleLoadTime,voltage,separationTime,uvExposureTime,
		blockingBufferVolume,blockingTime,washBufferVolume,concentratedLoadingBufferVolume,denaturantVolume,waterVolume,labelingReagentVolume,labelingTime,peroxidaseReagentVolume,peroxidaseIncubationTime,
		primaryIncubationTime,ladderPeroxidaseReagentVolume,secondaryIncubationTime,primaryAntibodyLoadingVolume,loadingVolume,parentProtocol,signalDetectionTimes,ladderBlockingBuffer,ladderBlockingBufferVolume,
		peroxidaseReagentStorageCondition,ladderPeroxidaseReagentStorageCondition,
		intNumberOfReplicates,numberOfSampleCapillaries,smallCartridgeQ,samplesWithReplicates,primaryAntibodiesWithReplicates,optionsWithReplicates,
		expandedSampleVolumes,expandedLoadingBufferVolumes,sometimesExpandedBlockingBuffers,expandedPrimaryAntibodyVolumes,expandedPrimaryAntibodyDiluents,expandedPrimaryAntibodyDiluentVolumes,
		expandedPrimaryAntibodyDilutionFactors,expandedSystemStandards,expandedStandardPrimaryAntibodies,expandedStandardPrimaryAntibodyVolumes,expandedSecondaryAntibodies,expandedSecondaryAntibodyVolumes,
		expandedStandardSecondaryAntibodies,expandedStandardSecondaryAntibodyVolumes,expandedAliquotAmounts,expandedSamplesInStorage,
		expandedPrimaryAntibodyStorageCondition,expandedStandardPrimaryAntibodyStorageCondition,expandedSecondaryAntibodyStorageCondition,
		expandedStandardSecondaryAntibodyStorageCondition,expandedSampleOrAliquotVolumes,
		sampleVolumeRules,uniqueSampleVolumeRules,sampleResourceReplaceRules,
		primaryAntibodyVolumeRules,expandedBlockingBufferVolume,blockingBufferVolumeRules,expandedPrimaryAntibodyDiluentVolumesNoNull,primaryAntibodyDiluentVolumeRules,
		expandedStandardPrimaryAntibodyVolumesNoNull,standardPrimaryAntibodyVolumeRules,secondaryAntibodyVolumeRules,expandedStandardSecondaryAntibodyVolumesNoNull,standardSecondaryAntibodyVolumeRules,
		ladderVolumeRule,washBufferVolumeRule,concentratedLoadingBufferVolumeRule,denaturantVolumeRule,labelingReagentVolumeRule,peroxidaseReagentVolumeRule,ladderPeroxidaseReagentVolumeRule,
		sampleReplacementVolumeRule,extraCapillaryBuffer,extraCapillaryVolumeRule,ladderBufferVolumeRule,liquidHandlerContainers,
		allVolumeRules,twomLTubeVolumeRules,uniqueObjectsAndVolumesAssociation,twomLTubeObjectsAndVolumesAssociation,uniqueResources,twomLTubeResources,
		uniqueObjects,twomLTubeObjects,uniqueObjectResourceReplaceRules,twomLTubeObjectResourceReplaceRules,samplesInResources,
		primaryAntibodyResources,blockingBufferResources,primaryAntibodyDiluentResources,standardPrimaryAntibodyResources,secondaryAntibodyResources,standardSecondaryAntibodyResources,ladderResource,
		washBufferResource,concentratedLoadingBufferResource,denaturantResource,labelingReagentResource,peroxidaseReagentResource,ladderPeroxidaseReagentResource,
		extraCapillarySampleReplacementResource,extraCapillaryBufferReplacementResource,ladderCapillaryBufferResource,luminescenceReagentResource,bufferWaterResource,
		samplePlateResource,assayPlateResource,antibodyPlateResource,instrumentResource,capillaryCartridgeResource,pipetteTipResource,blockWashTime,numberOfBlockWashes,
		pipetteResource,secondaryPipetteTipsResource,
		protocolPacket,specificFields,prepPacket,finalizedPacket,allResourceBlobs,resourcesOk,resourceTests,previewRule,optionsRule,resultRule,testsRule
	},

(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=If[westernQ,
		CollapseIndexMatchedOptions[
			ExperimentWestern,
			RemoveHiddenOptions[ExperimentWestern,myResolvedOptions],
			Ignore->myTemplatedOptions,
			Messages->False
		],
		CollapseIndexMatchedOptions[
			ExperimentTotalProteinDetection,
			RemoveHiddenOptions[ExperimentTotalProteinDetection,myResolvedOptions],
			Ignore->myTemplatedOptions,
			Messages->False
		]
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Set a Boolean that determines if we are in ExperimentWestern or ExperimentTotalProteinDetection *)
	westernQ=If[Length[myAntibodies]==0,
		False,
		True
	];

	(* Generate an ID for the new protocol *)
	protocolID=If[westernQ,
		CreateID[Object[Protocol,Western]],
		CreateID[Object[Protocol,TotalProteinDetection]]
	];

	(* Define the Protocol Type of the Experiment *)
	type=If[westernQ,
		Object[Protocol,Western],
		Object[Protocol,TotalProteinDetection]
	];

	(* Expand the resolved options if they weren't expanded already *)
	unCollapsedResolvedOptions=If[westernQ,
		Last[ExpandIndexMatchedInputs[ExperimentWestern,{mySamples,myAntibodies},myResolvedOptions]],
		Last[ExpandIndexMatchedInputs[ExperimentTotalProteinDetection,{mySamples},myResolvedOptions]]
	];

	(* Get the cache *)
	cache=Lookup[ToList[ops],Cache];

	(* Get all containers which can fit on the liquid handler - many of our resources are in one of these containers *)
	(* In case we need to prepare the resource add 0.5mL tube in 2 mL skirt to the beginning of the list (Engine uses the first requested container if it has to transfer or make a stock solution) *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* Make a Download call to get the containers of the input samples *)
	{listedSampleContainers,liquidHandlerContainerDownload}=Quiet[
		Download[
			{
				mySamples,
				liquidHandlerContainers
			},
			{
				{Container[Object]},
				{MaxVolume}
			},
			Cache->cache,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* Find the list of input sample and antibody containers *)
	sampleContainersIn=DeleteDuplicates[Flatten[listedSampleContainers]];

	(* Find the MaxVolume of all of the liquid handler compatible containers *)
	liquidHandlerContainerMaxVolumes=Flatten[liquidHandlerContainerDownload,1];

	(* Pull out relevant non-index matched options from the re-expanded options *)
	{
		numberOfReplicates,instrument,denaturing,name,molecularWeightRange,ladder,washBuffer,concentratedLoadingBuffer,
		denaturant,labelingReagent,peroxidaseReagent,ladderPeroxidaseReagent,denaturingTemperature,denaturingTime,luminescenceReagent,luminescenceReagentVolume,
		ladderVolume,separatingMatrixLoadTime,stackingMatrixLoadTime,sampleLoadTime,voltage,separationTime,uvExposureTime,
		blockingBufferVolume,blockingTime,washBufferVolume,concentratedLoadingBufferVolume,denaturantVolume,waterVolume,labelingReagentVolume,labelingTime,peroxidaseReagentVolume,peroxidaseIncubationTime,
		primaryIncubationTime,ladderPeroxidaseReagentVolume,secondaryIncubationTime,primaryAntibodyLoadingVolume,loadingVolume,parentProtocol,signalDetectionTimes,ladderBlockingBuffer,ladderBlockingBufferVolume,
		peroxidaseReagentStorageCondition,ladderPeroxidaseReagentStorageCondition
	}=
     Lookup[unCollapsedResolvedOptions,
			 {
				 NumberOfReplicates,Instrument,Denaturing,Name,MolecularWeightRange,Ladder,WashBuffer,ConcentratedLoadingBuffer,
				 Denaturant,LabelingReagent,PeroxidaseReagent,LadderPeroxidaseReagent,DenaturingTemperature,DenaturingTime,LuminescenceReagent,LuminescenceReagentVolume,
				 LadderVolume,SeparatingMatrixLoadTime,StackingMatrixLoadTime,SampleLoadTime,Voltage,SeparationTime,UVExposureTime,
				 BlockingBufferVolume,BlockingTime,WashBufferVolume,ConcentratedLoadingBufferVolume,DenaturantVolume,WaterVolume,LabelingReagentVolume,LabelingTime,PeroxidaseReagentVolume,PeroxidaseIncubationTime,
				 PrimaryIncubationTime,LadderPeroxidaseReagentVolume,SecondaryIncubationTime,PrimaryAntibodyLoadingVolume,LoadingVolume,ParentProtocol,SignalDetectionTimes,LadderBlockingBuffer,
				 LadderBlockingBufferVolume,PeroxidaseReagentStorageCondition,LadderPeroxidaseReagentStorageCondition
			 },
			 Null
		 ];

	(* -- Expand inputs and index-matched options to take into account the NumberOfReplicates option -- *)
	(* intNumberOfReplicates replaces Null with 1 for calculation purposes in number of replicates *)
	intNumberOfReplicates=numberOfReplicates/.{Null->1};

	(* Figure out how many sample capillaries there will be *)
	numberOfSampleCapillaries=(Length[mySamples]*intNumberOfReplicates);

	(* If we have more than 12 capillaries designated for samples and their replicates, then we will need the 25 capillary cartridge and more of the fixed-aliquot resources - otherwise, the 13 capillary cartridge and one each of the fixed-aliquot resources *)
	smallCartridgeQ=If[numberOfSampleCapillaries>12,
		False,
		True
	];

	(* -  Expand the input antibodies - *)
	primaryAntibodiesWithReplicates=Flatten[Table[#,intNumberOfReplicates]&/@myAntibodies];

	(* - Expand the index-matched inputs for the NumberOfReplicates - *)
	{samplesWithReplicates,optionsWithReplicates}=If[westernQ,
		(* If we are in ExperimentWestern, give the *)
		expandNumberOfReplicates[ExperimentWestern,mySamples,unCollapsedResolvedOptions],
		expandNumberOfReplicates[ExperimentTotalProteinDetection,mySamples,unCollapsedResolvedOptions]
	];

	(* Lookup the expanded options we will need to use to make resources *)
	{
		expandedSampleVolumes,expandedLoadingBufferVolumes,sometimesExpandedBlockingBuffers,expandedPrimaryAntibodyVolumes,expandedPrimaryAntibodyDiluents,expandedPrimaryAntibodyDiluentVolumes,
		expandedPrimaryAntibodyDilutionFactors,expandedSystemStandards,expandedStandardPrimaryAntibodies,expandedStandardPrimaryAntibodyVolumes,expandedSecondaryAntibodies,expandedSecondaryAntibodyVolumes,
		expandedStandardSecondaryAntibodies,expandedStandardSecondaryAntibodyVolumes,expandedAliquotAmounts,expandedSamplesInStorage,
		expandedPrimaryAntibodyStorageCondition,expandedStandardPrimaryAntibodyStorageCondition,expandedSecondaryAntibodyStorageCondition,
		expandedStandardSecondaryAntibodyStorageCondition
	}=
	Lookup[optionsWithReplicates,
		{
			SampleVolume,LoadingBufferVolume,BlockingBuffer,PrimaryAntibodyVolume,PrimaryAntibodyDiluent,PrimaryAntibodyDiluentVolume,PrimaryAntibodyDilutionFactor,SystemStandard,StandardPrimaryAntibody,
			StandardPrimaryAntibodyVolume,SecondaryAntibody,SecondaryAntibodyVolume,StandardSecondaryAntibody,StandardSecondaryAntibodyVolume,AliquotAmount,SamplesInStorageCondition,
			PrimaryAntibodyStorageCondition,StandardPrimaryAntibodyStorageCondition,SecondaryAntibodyStorageCondition,StandardSecondaryAntibodyStorageCondition
		},
		Null
	];

	(* --- To make resources, we need to find the input Objects and Models that are unique, and to request the total volume of them that is needed ---*)
	(* --  For each index-matched input or option object/volume pair, make a list of rules - ask for a bit more than requested in the cases it makes sense to, to take into account dead volumes etc -- *)
	(* - samplesWithReplicates and expandedSampleVolumes  - *)
	(* First, we need to make a list of volumes that are index matched to the samples in, with the SampleVolume if no Aliquotting is ocurring, or the AliquotAmount if Aliquotting is happening *)
	expandedSampleOrAliquotVolumes=MapThread[
		If[MatchQ[#2,Null],
			(#1+5*Microliter),
			#2
		]&,
		{expandedSampleVolumes,expandedAliquotAmounts}
	];

	(* Then, we use this list to create the volume rules for the input samples *)
	sampleVolumeRules=MapThread[
		(#1->#2)&,
		{samplesWithReplicates,expandedSampleOrAliquotVolumes}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	uniqueSampleVolumeRules=Merge[sampleVolumeRules, Total];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			If[VolumeQ[volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume ],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]]]
			]
		],
		uniqueSampleVolumeRules
	];

	(* Use the replace rules to get the sample resources *)
	samplesInResources = Replace[samplesWithReplicates, sampleResourceReplaceRules, {1}];

	(* - PrimaryAntibody and expandedPrimaryAntibodyVolumes only make rules in ExperimentWestern - *)
	primaryAntibodyVolumeRules=If[westernQ,
		MapThread[
			(#1->#2)&,
			{primaryAntibodiesWithReplicates,RoundOptionPrecision[((expandedPrimaryAntibodyVolumes*1.1)+0.5*Microliter),10^-1*Microliter]}
		],
		{}
	];

	(* - sometimesExpandedBlockingBuffers and BlockingBufferVolume - *)
	(* Define expandedBlockingBuffer separately for each function. In Western, to figure out how much of each blocking buffer we need, we expand the blockingBufferVolume option (single, unlisted) to be the same length as samples*number of replicates. For TotalProteinDetection, we multiply blocking buffer volume times samples*number of replicates *)
	expandedBlockingBufferVolume=If[westernQ,
		ConstantArray[blockingBufferVolume,numberOfSampleCapillaries],
		ToList[RoundOptionPrecision[(blockingBufferVolume*numberOfSampleCapillaries),10^-1*Microliter,AvoidZero->True]]
	];

	(* Define the list of rules with the newly defined expandedBlockingBufferVolume *)
	blockingBufferVolumeRules=MapThread[
		(#1->#2)&,
		{ToList[sometimesExpandedBlockingBuffers],(expandedBlockingBufferVolume+20*Microliter)}
	];

	(* - expandedPrimaryAntibodyDiluents and expandedPrimaryAntibodyDiluentVolumesNoNull - *)
	(* First, replace any Nulls in the expanded volume list with 0*Microliter *)
	expandedPrimaryAntibodyDiluentVolumesNoNull=expandedPrimaryAntibodyDiluentVolumes/.(Null->0*Microliter);

	(* Define the list of rules with the newly defined expandedPrimaryAntibodyDiluentVolumesNoNull *)
	primaryAntibodyDiluentVolumeRules=If[westernQ,
		MapThread[
			(#1->#2)&,
			{expandedPrimaryAntibodyDiluents,(expandedPrimaryAntibodyDiluentVolumesNoNull+20*Microliter)}
		],
		{}
	];

	(* - expandedStandardPrimaryAntibodies and expandedStandardPrimaryAntibodyVolumesNoNull - *)
	(* First, replace any Nulls in the expanded volume list with 0*Microliter *)
	expandedStandardPrimaryAntibodyVolumesNoNull=expandedStandardPrimaryAntibodyVolumes/.(Null->0*Microliter);

	(* Define the list of rules with the newly defined expandedPrimaryAntibodyDiluentVolumesNoNull *)
	standardPrimaryAntibodyVolumeRules=If[westernQ,
		MapThread[
			(#1->#2)&,
			{expandedStandardPrimaryAntibodies,(expandedStandardPrimaryAntibodyVolumesNoNull+20*Microliter)}
		],
		{}
	];

	(* - expandedSecondaryAntibodies and expandedSecondaryAntibodyVolumes - *)
	secondaryAntibodyVolumeRules=If[westernQ,
		MapThread[
			(#1->#2)&,
			{expandedSecondaryAntibodies,(expandedSecondaryAntibodyVolumes+20*Microliter)}
		],
		{}
	];

	(* - expandedStandardSecondaryAntibodies and expandedStandardSecondaryAntibodyVolumesNoNull - *)
	(* First, replace any Nulls in the expanded volume list with 0*Microliter *)
	expandedStandardSecondaryAntibodyVolumesNoNull=expandedStandardSecondaryAntibodyVolumes/.(Null->0*Microliter);

	(* Define the list of rules with the newly defined expandedStandardSecondaryAntibodyVolumesNoNull *)
	standardSecondaryAntibodyVolumeRules=If[westernQ,
		MapThread[
			(#1->#2)&,
			{expandedStandardSecondaryAntibodies,(expandedStandardSecondaryAntibodyVolumesNoNull+20*Microliter)}
		],
		{}
	];

	(* --  For each non index-matched option object/volume pair, make a list of rules -- *)
	(* Ladder and LadderVolume *)
	(* If we are using the 13-capillary cartridge, only need one fixed aliquot, otherwise we need 2 (to make sure we use up all components of kits at same time) *)
	ladderVolumeRule=If[smallCartridgeQ,
		{ladder->40*Microliter},
		{ladder->40*Microliter}
	];

	(* WashBuffer and WashBufferVolume - depends on which capillary cartridge we are using *)
	washBufferVolumeRule=If[smallCartridgeQ,
		{washBuffer->RoundOptionPrecision[((washBufferVolume*9)+5*Milliliter),10^-1*Microliter]},
		{washBuffer->RoundOptionPrecision[((washBufferVolume*16)+5*Milliliter),10^-1*Microliter]}
	];

	(* ConcentratedLoadingBuffer and ConcentratedLoadingBufferVolume - not asking for more because default is 20 uL and stock solution contains a fixed aliquot dissolved in 20 uL *)
	concentratedLoadingBufferVolumeRule={concentratedLoadingBuffer->concentratedLoadingBufferVolume};

	(* Denaturant and DenaturantVolume *)
	denaturantVolumeRule={denaturant->((denaturantVolume*1.5)/.(Null->0*Microliter))};

	(* Labeling Reagent and LabelingReagentVolume - for Western volume is Null, for TotalProteinDetection, it is the volume option times the number of sample capillaries *)
	labelingReagentVolumeRule=If[!westernQ,
		{labelingReagent->270*Microliter},
		{}
	];

	(* PeroxidaseReagent and PeroxidaseReagentVolume - Null in Western, and volume option times the number of sample capillaries plus one (ladder) for totalProteinDetection*)
	peroxidaseReagentVolumeRule=If[!westernQ,
		{peroxidaseReagent->RoundOptionPrecision[(peroxidaseReagentVolume*(numberOfSampleCapillaries+1)+20*Microliter),10^-1*Microliter]},
		{}
	];

	(* LadderPeroxidaseReagent and LadderPeroxidaseReagentVolume - Null in TotalProteinDetection *)
	ladderPeroxidaseReagentVolumeRule=If[westernQ,
		{ladderPeroxidaseReagent->ladderPeroxidaseReagentVolume+20*Microliter},
		{}
	];

	(* luminescenceReagent and luminescenceReagentVolume*)
	luminescenceReagentVolumeRule=If[smallCartridgeQ,
		{luminescenceReagent->RoundOptionPrecision[((luminescenceReagentVolume*13)+100*Microliter),10^-1*Microliter]},
		{luminescenceReagent->RoundOptionPrecision[((luminescenceReagentVolume*25)+50*Microliter),10^-1*Microliter]}
	];

	(* -- For the other buffers and such that we will need to fill the entire assay plate (the capillaries not used by samples, and the blocking buffer and primaryab/labelingreagent for ladder capillary -- *)
	(* - The Sample Replacement for input samples will be Model[Sample,StockSolution,"Simple Western 0.1X Sample Buffer"] in the capillaries without input samples - *)
	sampleReplacementVolumeRule=If[MatchQ[numberOfSampleCapillaries,Alternatives[12,24]],
		{},
		{Model[Sample,StockSolution,"Simple Western 0.1X Sample Buffer"]->RoundOptionPrecision[(4*Microliter*(24-numberOfSampleCapillaries)+50*Microliter),10^-1*Microliter]}
	];

	(* The buffer that will go into the 3 rows below the sample inputs will depend on if we are in Western or total protein detection) *)
	extraCapillaryBuffer=If[westernQ,
		Model[Sample,"Simple Western Antibody Diluent 2"],
		Model[Sample,"Simple Western Antibody Diluent 2 - Total Protein Kit"]
	];

	(* - The three rows below the sample inputs for no-sample capillaries will be filled with 10 or 8 uL of Model[Sample,"Simple Western Antibody Diluent 2"] instead of LabelingReagent/PeroxidaseReagent/PrimaryAb/SecondaryAb/BlockingBuffer- *)
	extraCapillaryVolumeRule=If[numberOfSampleCapillaries==24,
		{},
		{extraCapillaryBuffer->RoundOptionPrecision[(10*Microliter*(3*(24-numberOfSampleCapillaries))+50*Microliter),10^-1*Microliter]}
	];

	(* - The BlockingBuffer and PrimaryAb/LabelingReagent wells for the ladder will be filled with 10 uL of Model[Sample,"Simple Western Antibody Diluent 2"] - *)
	ladderBufferVolumeRule={ladderBlockingBuffer->((ladderBlockingBufferVolume*2)+50*Microliter)};


	(* --- Make the resources --- *)
	(* -- We want to make the resources for each unique Object or Model Input, for the total volume required for the experiment for each --*)
	(* - First, join the lists of most of the rules above (we are treating the LuminescenceReagent and LabelingReagent separately because these are made in 2 mL tubes and we don't want an extra unnecessary transfer step (not sure this is actually necessary)), and get rid of any Rules with the pattern _->0*Microliter or Null->_ - *)
	allVolumeRules=Cases[
		Join[
			primaryAntibodyVolumeRules,standardPrimaryAntibodyVolumeRules,secondaryAntibodyVolumeRules,standardSecondaryAntibodyVolumeRules,
			peroxidaseReagentVolumeRule,ladderPeroxidaseReagentVolumeRule,
			sampleReplacementVolumeRule,primaryAntibodyDiluentVolumeRules,blockingBufferVolumeRules,washBufferVolumeRule,ladderBufferVolumeRule,extraCapillaryVolumeRule,
			ladderVolumeRule,concentratedLoadingBufferVolumeRule,denaturantVolumeRule,luminescenceReagentVolumeRule,labelingReagentVolumeRule
		],
		Except[Alternatives[_->0*Microliter,Null->_]]
	];

	(* - Make an association whose keys are the unique Object and Model Keys in the list of allVolumeRules, and whose values are the total volume of each of those unique keys - *)
	uniqueObjectsAndVolumesAssociation=Merge[allVolumeRules,Total];

	(* - Use this association to make Resources for each unique Object or Model Key - *)
	uniqueResources=KeyValueMap[
		Module[{amount,containers},
			amount=#2;
			containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];
			Resource[Sample->#1,Amount->amount,Container->containers,Name->ToString[#1]]
		]&,
		uniqueObjectsAndVolumesAssociation
	];

	(* -- Define a list of replace rules for the unique Model and Objects with the corresponding Resources --*)
	(* - Find a list of the unique Object/Model Keys - *)
	uniqueObjects=Keys[uniqueObjectsAndVolumesAssociation];

	(* - Make a list of replace rules, replacing unique objects with their respective Resources - *)
	uniqueObjectResourceReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueObjects,uniqueResources}
	];

	(* -- Use the unique object replace rules to make lists of the resources of the inputs and the options / fields that are objects -- *)
	(* - For the inputs and options that are index-matched to the inputs, Map over replacing the options with the replace rules at level {1} to get the corresponding list of resources - *)
	{
		primaryAntibodyResources,standardPrimaryAntibodyResources,secondaryAntibodyResources,standardSecondaryAntibodyResources,primaryAntibodyDiluentResources
	}=Map[
		Replace[#,uniqueObjectResourceReplaceRules,{1}]&,
		{
			primaryAntibodiesWithReplicates,expandedStandardPrimaryAntibodies,expandedSecondaryAntibodies,expandedStandardSecondaryAntibodies,expandedPrimaryAntibodyDiluents
		}
	];

	(* - For the options that are single objects, Map over replacing the option with the replace rules to get the corresponding resources - *)
	{
		peroxidaseReagentResource,ladderPeroxidaseReagentResource,
		extraCapillarySampleReplacementResource,washBufferResource,ladderCapillaryBufferResource,extraCapillaryBufferReplacementResource,
		ladderResource,concentratedLoadingBufferResource,denaturantResource,luminescenceReagentResource,labelingReagentResource
	}=Map[
			Replace[#,uniqueObjectResourceReplaceRules]&,
			{
				peroxidaseReagent,ladderPeroxidaseReagent,Model[Sample,StockSolution,"Simple Western 0.1X Sample Buffer"],
				washBuffer,ladderBlockingBuffer,extraCapillaryBuffer,ladder,concentratedLoadingBuffer,denaturant,luminescenceReagent,labelingReagent
			}
		];

	(* - BlockingBuffer(s) - for Western, we want a list of resources, for TotalProteinDetection we just want a resource, no list - *)
	blockingBufferResources=If[westernQ,
		Replace[sometimesExpandedBlockingBuffers,uniqueObjectResourceReplaceRules,{1}],
		Replace[sometimesExpandedBlockingBuffers,uniqueObjectResourceReplaceRules]
	];


	(* - Make the buffer water resource separately, as we need the container - *)
	bufferWaterResource=If[MatchQ[waterVolume,Null],
		Null,
		Resource[
			Sample->Model[Sample, "id:8qZ1VWNmdLBD"],
			Amount->100*Microliter,
			Container->PreferredContainer[0.4*Milliliter],
			Name->ToString[Unique[]]
		]
	];

	(* -- Make resources for other things needed for the experiment -- *)
	(* - Make resources for the intermediate Plates that will be used - *)
	(* SamplePlate - Model[Container, Plate, "384-well qPCR Optical Reaction Plate"] *)
	samplePlateResource = Resource[Sample -> Model[Container, Plate, "id:pZx9jo83G0VP"]];

	(* AssayPlate - depends on MolecularWeightRange - when I define these objects in SLL, can fill them in *)
	assayPlateResource=Switch[molecularWeightRange,
		LowMolecularWeight,
			Resource[Sample->Model[Container,Plate,Irregular,"Simple Western LowMolecularWeight (2-40 kDa) assay plate"]],
		MidMolecularWeight,
			Resource[Sample->Model[Container,Plate,Irregular,"Simple Western MidMolecularWeight (12-230 kDa) assay plate"]],
		HighMolecularWeight,
			Resource[Sample->Model[Container,Plate,Irregular,"Simple Western HighMolecularWeight (66-440 kDa) assay plate"]]
	];

	(* AntibodyPlate - Model[Container, Plate, "96-well Round Bottom Plate"] in Western, nothing in TotalProteinDetection *)
	antibodyPlateResource=If[westernQ,
		Resource[Sample->Model[Container, Plate, "id:1ZA60vwjbbqa"]],
		Null
	];

	(* - Make the resource packet for the instrument - *)
	instrumentResource=Resource[
		Instrument->instrument,
		Time->If[westernQ,
			(blockingTime+primaryIncubationTime+secondaryIncubationTime+6*Hour),
			(blockingTime+labelingTime+peroxidaseIncubationTime+6*Hour)
		]
	];

	(* Make a resource for the capillary cartridge *)
	capillaryCartridgeResource=If[smallCartridgeQ,
		(* IF we have 12 or fewer capillaries needed for input samples, THEN we use the 13-capillary cartridge *)
		Resource[
			Sample->Model[Item, Consumable, "id:N80DNj1BZG76"]
		],
		(* ELSE, we use the 25-capillary cartridge *)
		Resource[
			Sample->Model[Item,Consumable,"id:GmzlKjPRoMqM"]
		]
	];

	(* Make a resource for the 1 mL tip that we will use to pop any bubbles in the Separation Matrix wells of the AssayPlate *)
	pipetteTipResource=Resource[
		Sample->Model[Item,Tips,"1000 uL reach tips, sterile"],
		Amount->1
	];

	(* We can no longer control these two - but it depends on if we are in Western or not *)
	blockWashTime=150*Second;

	numberOfBlockWashes=2;

	(* - If we are in ExperimentTotalProteinDetection, we need to make resources for the pipette and tips that we will
	 use to load the LabelingReagent into the appropriate wells of the AssayPlate - *)
	(* Pipette *)
	pipetteResource=If[
		westernQ,
		Null,
		Resource[
			Instrument->Model[Instrument, Pipette, "Eppendorf Research Plus P20"],
			Time->1*Hour
		]
	];

	(* Secondary pipette tips *)
	secondaryPipetteTipsResource=If[
		westernQ,
		Null,
		Resource[
			Sample->Model[Item, Tips, "20 uL barrier tips, sterile"],
			Amount->2
		]
	];

	(* --- Create the protocol packet ---*)
	(* -- Create a packet for fields that exist in both protocol objects -- *)
	protocolPacket=<|
		Type->type,
		Object->protocolID,
		Author->If[MatchQ[parentProtocol,Null],
			Link[$PersonID,ProtocolsAuthored]
		],
		ParentProtocol->If[MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],
			Link[parentProtocol,Subprotocols]
		],
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@sampleContainersIn,
		Replace[SamplesIn]->(Link[#,Protocols]&/@samplesInResources),

		UnresolvedOptions->If[westernQ,
			RemoveHiddenOptions[ExperimentWestern,myTemplatedOptions],
			RemoveHiddenOptions[ExperimentTotalProteinDetection,myTemplatedOptions]
		],
		ResolvedOptions->myResolvedOptions,

		Name->name,

		MolecularWeightRange->molecularWeightRange,
		Instrument->Link[instrumentResource],
		DetectionMode->Chemiluminescence,
		NumberOfReplicates->numberOfReplicates,
		Denaturing->denaturing,
		DenaturingTemperature->denaturingTemperature,
		DenaturingTime->denaturingTime,
		SeparatingMatrixLoadTime->separatingMatrixLoadTime,
		StackingMatrixLoadTime->stackingMatrixLoadTime,
		Replace[SampleVolumes]->expandedSampleVolumes,
		ConcentratedLoadingBuffer->Link[concentratedLoadingBufferResource],
		ConcentratedLoadingBufferVolume->concentratedLoadingBufferVolume,
		Denaturant->Link[denaturantResource],
		DenaturantVolume->denaturantVolume,
		LoadingBufferDiluent->Link[bufferWaterResource],
		(* For these two, make sure the field is Null if there are 12 or 24 capillaries so we don't cause a ResourcePicking error*)
		PlaceholderBuffer->If[MatchQ[numberOfSampleCapillaries,Alternatives[12,24]],Null,Link[extraCapillarySampleReplacementResource]],
		PlaceholderBlockingBuffer->If[MatchQ[numberOfSampleCapillaries,Alternatives[12,24]],Null,Link[extraCapillaryBufferReplacementResource]],

		LadderBlockingBuffer->Link[ladderCapillaryBufferResource],
		LadderBlockingBufferVolume->ladderBlockingBufferVolume,
		WaterVolume->waterVolume,
		Replace[LoadingBufferVolumes]->expandedLoadingBufferVolumes,
		LoadingVolume->loadingVolume,
		Ladder->Link[ladderResource],
		LadderVolume->ladderVolume,
		SamplePlate->Link[samplePlateResource],
		AssayPlate->Link[assayPlateResource],
		PipetteTips->Link[pipetteTipResource],
		CapillaryCartridge->Link[capillaryCartridgeResource],
		SampleLoadTime->sampleLoadTime,
		Voltage->voltage,
		SeparationTime->separationTime,
		UVExposureTime->uvExposureTime,
		WashBuffer->Link[washBufferResource],
		WashBufferVolume->washBufferVolume,
		BlockingBufferVolume->blockingBufferVolume,
		BlockingTime->blockingTime,
		LuminescenceReagent->Link[luminescenceReagentResource],
		LuminescenceReagentVolume->luminescenceReagentVolume,
		Replace[SignalDetectionTimes]->signalDetectionTimes,
		Replace[SamplesInStorage]->expandedSamplesInStorage
	|>;

	(* Populate fields specific to one protocol type *)
	specificFields=If[westernQ,

		(* If in ExperimentWestern, only include the relevant fields *)
		<|
			Replace[BlockingBuffers]->(Link[#]&/@blockingBufferResources),
			Replace[PrimaryAntibodies]->(Link[#]&/@primaryAntibodyResources),
			Replace[PrimaryAntibodyVolumes]->expandedPrimaryAntibodyVolumes,
			Replace[PrimaryAntibodyStorageConditions]->expandedPrimaryAntibodyStorageCondition,
			Replace[PrimaryAntibodyDiluents]->(Link[#]&/@primaryAntibodyDiluentResources),
			Replace[PrimaryAntibodyDilutionFactors]->expandedPrimaryAntibodyDilutionFactors,
			Replace[PrimaryAntibodyDiluentVolumes]->expandedPrimaryAntibodyDiluentVolumes,
			Replace[SystemStandards]->expandedSystemStandards,
			Replace[StandardPrimaryAntibodies]->(Link[#]&/@standardPrimaryAntibodyResources),
			Replace[StandardPrimaryAntibodyVolumes]->expandedStandardPrimaryAntibodyVolumes,
			Replace[StandardPrimaryAntibodyStorageConditions]->expandedStandardPrimaryAntibodyStorageCondition,
			PrimaryAntibodyLoadingVolume->primaryAntibodyLoadingVolume,
			AntibodyPlate->Link[antibodyPlateResource],
			PrimaryIncubationTime->primaryIncubationTime,
			PrimaryWashTime->150*Second,
			NumberOfPrimaryWashes->2,
			Replace[SecondaryAntibodies]->(Link[#]&/@secondaryAntibodyResources),
			Replace[SecondaryAntibodyVolumes]->expandedSecondaryAntibodyVolumes,
			Replace[SecondaryAntibodyStorageConditions]->expandedSecondaryAntibodyStorageCondition,
			Replace[StandardSecondaryAntibodies]->(Link[#]&/@standardSecondaryAntibodyResources),
			Replace[StandardSecondaryAntibodyVolumes]->expandedStandardSecondaryAntibodyVolumes,
			Replace[StandardSecondaryAntibodyStorageConditions]->expandedStandardSecondaryAntibodyStorageCondition,
			SecondaryIncubationTime->secondaryIncubationTime,
			SecondaryWashTime->150*Second,
			NumberOfSecondaryWashes->3,
			LadderPeroxidaseReagent->Link[ladderPeroxidaseReagentResource],
			LadderPeroxidaseReagentStorageCondition->ladderPeroxidaseReagentStorageCondition,
			LadderPeroxidaseReagentVolume->ladderPeroxidaseReagentVolume,
			Replace[Checkpoints]->{
				{"Preparing Samples",15*Minute,"Preprocessing, such as incubation, centrifugation, filtration, and aliquotting, is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 15 Minute]]},
				{"Picking Resources",1*Hour,"Samples and plates required to execute this protocol are gathered from storage and stock solutions are freshly prepared.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Hour]]},
				{"Preparing Assay Plate",1*Hour,"The SamplePlate, AntibodyPlate, and AssayPlate are loaded with the specified reagents.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Hour]]},
				{"Preparing Instrumentation",20*Minute,"The instrument is configured for the protocol.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 20 Minute]]},
				{"Acquiring Data",3*Hour,"Samples are loaded into the capillaries, labeled with antibodies, and chemoluminescent signal is detected.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 3Hour]]},
				{"Returning Materials",1*Hour,"Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Hour]]}
			}
		|>,

		(* ELSE we are in ExperimentTotalProteinDetection, and only include the relevant fields *)
		<|
			BlockingBuffer->Link[blockingBufferResources],
			Pipette->pipetteResource,
			SecondaryPipetteTips->secondaryPipetteTipsResource,
			LabelingReagent->Link[labelingReagentResource],
			LabelingReagentVolume->labelingReagentVolume,
			LabelingTime->labelingTime,
			BlockWashTime->blockWashTime,
			NumberOfBlockWashes->numberOfBlockWashes,
			PeroxidaseReagent->Link[peroxidaseReagentResource],
			PeroxidaseReagentStorageCondition->peroxidaseReagentStorageCondition,
			PeroxidaseReagentVolume->peroxidaseReagentVolume,
			PeroxidaseIncubationTime->peroxidaseIncubationTime,
			PeroxidaseWashTime->150*Second,
			NumberOfPeroxidaseWashes->3,
			Replace[Checkpoints]->{
				{"Preparing Samples",15*Minute,"Preprocessing, such as incubation, centrifugation, filtration, and aliquotting, is performed.",Null},
				{"Picking Resources",1*Hour,"Samples and plates required to execute this protocol are gathered from storage and stock solutions are freshly prepared.",Null},
				{"Preparing Assay Plate",1*Hour,"The SamplePlate and AssayPlate are loaded with the specified reagents.",Null},
				{"Preparing Instrumentation",20*Minute,"The instrument is configured for the protocol.",Null},
				{"Acquiring Data",3*Hour,"Samples are loaded into the capillaries, labeled with biotin/streptavidin-horseradish peroxidase, and chemoluminescent signal is detected.",Null},
				{"Returning Materials",1*Hour,"Samples are returned to storage.",Null}
			}
		|>
	];


	(* - Populate prep field - send in initial samples and options since this handles NumberOfReplicates on its own - *)
	prepPacket=populateSamplePrepFields[mySamples,myResolvedOptions];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[protocolPacket,specificFields,prepPacket];

	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		MatchQ[$ECLApplication,Engine],
			{True,{}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache],Null}
	];


	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule=Preview->Null;

	(* Generate the options output rule *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		resourceTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
		finalizedPacket,
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];
