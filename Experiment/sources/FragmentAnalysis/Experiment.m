(* ::Package:: *)

(* ::Section:: *)
(* Source Code *)


(* ::Subsection:: *)
(* ExperimentFragmentAnalysis*)


(* ::Subsubsection::Closed:: *)
(* ExperimentFragmentAnalysis Options and Messages *)


DefineOptions[ExperimentFragmentAnalysis,
	Options:> {
		(*===General===*)
		{
			OptionName->Instrument,
			Default->Automatic,
			Description->"The array-based capillary electrophoresis instrument used for parallel qualitative or quantitative analysis of nucleic acids via separation based on analyte fragment size of up to 84 samples in a single run.",
			(*ResolutionDescription->"Automatically set to Model[Instrument,FragmentAnalyzer,\"Agilent Fragment Analyzer 5200\"] if number of SamplesIn is less than 12. Otherwise, set to Model[Instrument,FragmentAnalyzer,\"Agilent Fragment Analyzer 5300\"].", *)
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,FragmentAnalyzer],Object[Instrument,FragmentAnalyzer]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Instruments",
						"Electrophoresis"
					},
					{
						Object[Catalog,"Root"],
						"Instruments",
						"Fragment Analysis"
					}
				}
			],
			Category->"General"
		},
		{
			OptionName->NumberOfCapillaries,
			Default->Automatic,
			Description -> "The number of extremely thin, hollow tubes per bundle in the CapillaryArray used in the course of the experiment. Determines the maximum number of samples ran in parallel in a single injection, including a ladder sample which is recommended for every run.",
			ResolutionDescription -> "If the CapillaryArray is specified, automatically set to the NumberOfCapillaries field of the CapillaryArray option. Otherwise, automatically set based on the number of SamplesIn, Ladders (if specified) and Blank (if specified).",
			AllowNull-> False,
			Widget->Widget[
				Type-> Enumeration,
				Pattern:> FragmentAnalyzerNumberOfCapillariesP
			],
			Category->"General"
		},
		{
			OptionName->CapillaryArrayLength,
			Default->Short,
			Description->"The length (Short) of the extremely thin hollow tubes (capillary arrays) that is used by the instrument for analyte separation. Short capillaries have shorter separation run times, as well as improved peak efficiency and sensitivity, but yield lower separation resolution. Long capillaries have longer run times but are ideal if a higher separation resolution is desired. For a Short capillary array, the length from the sample inlet end until the detector window (EffectiveLength) is 33 Centimeter, while the length from the sample inlet until outlet end to the reservoir (TotalLength) is 55 Centimeter. For an illustration, see Figure 2.1.1 under Instrumentation.",
			(*Add Ultrashort, Long to CapillaryArrayLength Description once we carry them*)
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:> FragmentAnalyzerCapillaryArrayLengthP
			],
			Category->"General"
		},
		{
			OptionName->CapillaryArray,
			Default->Automatic,
			Description->"The ordered bundle of extremely thin, hollow tubes (capillary array) that is used by the instrument for analyte separation. Each CapillaryArray has a specific NumberOfCapillaries (96) which indicates the maximum number of samples that are ran in parallel. Each capillary in the array also has a designated CapillaryArrayLength (Short) which affects the separation run times and resolution. Short capillaries have shorter run times, as well as improved peak efficiency and sensitivity, but yield lower separation resolution, and are used by default. Long capillaries have longer run times but are ideal if a higher separation resolution is desired.",
			(*Add 12,48 to NumberOfCapillaries Description once we carry them*)
			ResolutionDescription ->"If NumberOfCapillaries is set to 96, set to Model[Part, CapillaryArray, \"96-Capillary Array Short\"].",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Part,CapillaryArray],Model[Part,CapillaryArray]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Fragment Analysis",
						"Capillary Array"
					}
				}
			],
			Category -> "General"
		},
		{
			OptionName -> AnalysisMethod,
			Default -> Automatic,
			Description -> "The method object that contains a set of option values optimized and recommended by the instrument manufacturer that is used as a template for the parameters of the experiment. If not specified by User, an AnalysisMethod is selected from a list of methods for either standard dsDNA or RNA samples according to a selection criteria based on AnalysisStrategy, CapillaryArrayLength and sample information: type of analyte (DNA or RNA), analyte concentrations (High Sensitiviy (Picogram/Microliter) or Standard Sensitivity (Nanogram/Microliter)) and fragment size range (ReadLength, in base pairs or number of nucleotides) of the sample. For more specialized samples (eg DNA smears, plasmid DNA, cfDNA, NGS libraries, samples for CRISPR/Cas9, genomic DNA), it is recommended that AnalysisMethod is selected and specified. For a selection criteria guide on determining the appropriate AnalysisMethod, refer to Figure 3.1 under AnalysisMethod of Experiment Options. Default option values for each AnalysisMethod, including reagents (SeparationGel, LoadingBuffer, Ladder, Blank, Marker, PreMarkerRinseBuffer, PreSampleRinseBuffer), as well as specific parameters of the experiment categories (eg. Sample Preparation, Capillary Conditioning, Capillary Equilibration, Pre-Marker Rinse, Marker Injection, Pre-Sample Rinse, Sample Injection, Separation) are specified in fields of the various Object[Method, FragmentAnalysis] objects available.",
			ResolutionDescription-> "Automatically set to appropriate Object[Method,FragmentAnalysis] based on AnalysisStrategy, CapillaryArrayLength and sample information: type of analyte (equal to TargetAnalyteType field in the AnalysisMethod), analyte concentration (greater than MinTargetConcentration field and less than MaxTargetConcentration field of AnalysisMethod) and fragment size range (MinReadLength greater than or equal to MinTargetReadLength field and MaxReadLength less than or equal to MaxTargetReadLength field of the AnalysisMethod), if available. For a selection criteria guide on determining the appropriate AnalysisMethod, refer to Figure 3.1 under AnalysisMethod of Experiment Options.",
			AllowNull -> False,
			Widget -> Alternatives[
				"Agilent Method Objects" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Method,FragmentAnalysis]}],
					OpenPaths->{
						{
							Object[Catalog,"Root"],
							"Materials",
							"Fragment Analysis",
							"Analysis Methods"
						}
					}
				],
				"Custom Method Objects" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Method,FragmentAnalysis]}]
				]
			],
			Category -> "General"
		},
		{
			OptionName->PreparedPlate,
			Default->False,
			Description->"Indicates if SamplesIn are in an instrument-compatible plate (Model[Container, Plate, \"96-well Semi-Skirted PCR Plate for FragmentAnalysis\"]) that contain all other necessary components (Ladders, Blanks, LoadingBuffer (if applicable)). If PreparedPlate is True, Ladders and Blanks, if any, are designated by Well Position(s) that contain ladder or blank solutions. All wells contain a solution of least 24 Microliter volume to avoid damage to the capillary array. Prepared plates are directly placed in the sample drawer of the instrument, ready for injection, and does not involve any plate preparation steps. Options including SampleVolume, SampleDiluent, SampleDiluentVolume, SampleLoadingBuffer, SampleLoadingBufferVolume, LadderVolume, LadderLoadingBuffer and LadderLoadingBufferVolume are not applicable and are set to Null.",

			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"General"
		},
		{
			OptionName->MaxNumberOfRetries,
			Default->1,
			Description->"The maximum number of separation runs that can be performed for contents of the sample plate when the raw data (electropherogram) for a sample or ladder indicates no peak(s) detected as assessed by the lack of any baseline-corrected signal above 100 RFU. For each separation run retry, resources such as SeparationGel, Dye and ConditioningSolution are re-prepared by preparing new solutions in new containers. Plate resources (SamplePlate,RunningBufferPlate,PreMarkerRinseBufferPlate and PreSampleRinseBufferPlate) are re-prepared by moving the contents to a new plate with a newly re-assigned well position for any sample(s)/ladder(s) that are affected, as well as their index-matched counterparts (RunningBuffer, PreMarkerRinseBuffer, PreSampleRinseBuffer). The well re-assignment is to avoid the underperforming capillary array assigned in the previous run. Note that the MarkerPlate is not re-prepared and is used as-is for every retry, if applicable, due to the oil-layer that prevents effective reusability of the transferred components.",
			AllowNull->True,
			Category->"General",
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,3]
			]
		},
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description->"The number of wells each input sample is loaded into. For example {input 1, input 2} with NumberOfReplicates->2 will act like {input 1, input 1, input 2, input 2}.",
			AllowNull->True,
			Category->"General",
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterEqualP[2,1]
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleAnalyteType,
				Default->Automatic,
				Description->"The nucleic acid type (DNA or RNA) of the analytes in the sample that are separated based on fragment size.",
				ResolutionDescription->"Automatically set to the most PolymerType that is either DNA or RNA that can be found under Analytes. If Analytes is not populated, automatically set to the most PolymerType that is either DNA or RNA that can be found under Composition. Otherwise, set to DNA.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FragmentAnalysisAnalyteTypeP
				],
				Category->"General"
			},
			{
				OptionName->MinReadLength,
				Default->Automatic,
				Description->"The number (or estimated number) of base pairs or nucleotides of the shortest fragment analyte in the sample.",
				ResolutionDescription->"Automatically set to the lowest number of base pairs or nucleotides of identity models of PolymerType DNA or RNA under the Composition field of the sample, as determined by SequenceLength. Otherwise, automatically set to Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,60000,1]
				],
				Category->"General"
			},
			{
				OptionName->MaxReadLength,
				Default->Automatic,
				Description->"The number (or estimated number) of base pairs or nucleotides of the longest fragment analyte in the sample.",
				ResolutionDescription->"Automatically set to the highest number of base pairs or nucleotides of identity models of PolymerType DNA or RNA under the Composition field of the sample, as determined by SequenceLength. Otherwise, automatically set to Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,60000,1]
				],
				Category->"General"
			}
		],
		{
			OptionName->AnalysisStrategy,
			Default->Qualitative,
			Description->"The objective of the analysis of the samples. Qualitative performs quality assessment of samples and outputs include gel image, electropherogram, total concentration and sample quality number (DNA Quality Number (DQN) or RNA Quality Number (RQN)). Quantitative performs everything a Qualitative analysis does, with the exception of the default loading buffer added to the sample(s) or ladder(s) containing quantified markers that serve as internal standard and allows measurement analyte concentration with better accuracy than Qualitative methods.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>FragmentAnalysisStrategyP
			],
			Category->"General"
		},
		(*===Method Saving===*)
		{
			OptionName->AnalysisMethodName,
			Default->Null,
			AllowNull->True,
			Widget->Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line,
				BoxText -> Null
			],
			Description->"The name that is given to the Object[Method,FragmentAnalysis] that is generated from options specified in the experiment and is uploaded after the experiment is done. Note that if no AnalysisMethodName is provided, no Object[Method,FragmentAnalysis] is saved.",
			Category->"Method Saving"
		},
		(*===Sample Preparation===*)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleVolume,
				Default->Automatic,
				Description->"The volume of sample (after aliquoting, if applicable) that is transferred into the plate, prior to addition of SampleDiluent (if applicable) and SampleLoadingBuffer (if applicable), and before loading into the instrument. Each sample is dispensed from Position A1 onwards (from A1, A2, A3...). If PreparedPlate is True, this option is not applicable and is set to Null.",
				ResolutionDescription->"If SampleDilution is False, automatically set to the TargetSampleVolume field of the AnalysisMethod. If SampleDilution is True, automatically determined based on the concentration of the first identity model of PolymerType DNA or RNA under Composition, and the MaxTargetMassConcentration field of the AnalysisMethod. Otherwise, automatically set to 2 Microliter. If PreparedPlate is True, automatically set to Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:> RangeP[0 Microliter, 200 Microliter],
					Units->{Microliter, {Microliter,Milliliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->SampleDilution,
				Default->False,
				Description->"Indicates if SampleDiluent is added to the sample (after aliquoting, if applicable) to reduce the sample concentration prior to addition of the SampleLoadingBuffer and loading into the instrument. If PreparedPlate is True, this option is not applicable and is set to False.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->SampleDiluent,
				Default->Automatic,
				Description->"The buffer solution added to the sample to reduce the sample concentration prior to addition of the SampleLoadingBuffer and loading into the instrument. If PreparedPlate is True, this option is not applicable and is set to Null.",
				ResolutionDescription->"If SampleDilution is set to True, automatically set to Model[Sample, \"1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis\"]. If PreparedPlate is True OR SampleDilution is set to False, automatically set to Null.",
				AllowNull-> True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->SampleDiluentVolume,
				Default->Automatic,
				Description->"The volume of buffer solution added to the sample to reduce the sample concentration prior to addition of the SampleLoadingBuffer and loading into the instrument. If PreparedPlate is True, this option is not applicable and is set to Null.",
				ResolutionDescription->"If SampleDilution is set to True, automatically determined based on the concentration of the identity models of PolymerType matching SampleAnalyteType under Composition, and the MaxTargetMassConcentration field of the AnalysisMethod. Otherwise, automatically set to the difference between SampleVolume and TargetSampleVolume. If PreparedPlate is True, automatically set to Null.",
				AllowNull-> True,
				Widget->Widget[
					Type-> Quantity,
					Pattern:> RangeP[0 Microliter, 200 Microliter],
					Units->{Microliter, {Microliter,Milliliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->SampleLoadingBuffer,
				Default->Automatic,
				Description->"The solution added to the sample (after aliquoting, if applicable), to either add markers (Quantitative) or further dilute (Qualitative) the sample prior to loading into the instrument. If PreparedPlate is True, this option is not applicable and is set to Null.",
				ResolutionDescription->"Automatically set to the SampleLoadingBuffer field of the AnalysisMethod. If PreparedPlate is True, automatically set to Null. For a list of the default SampleLoadingBuffer for each AnalysisMethod, see Figure 3.2 under SampleLoadingBuffer of Experiment Options.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					OpenPaths->{
						{
							Object[Catalog,"Root"],
							"Materials",
							"Fragment Analysis",
							"Loading Buffers"
						}
					}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->SampleLoadingBufferVolume,
				Default->Automatic,
				Description->"The volume of SampleLoadingBuffer added to the sample (after aliquoting, if applicable), to either add markers to (Quantitative) or further dilute (Qualitative) the sample prior to loading into the instrument. If PreparedPlate is True, this option is not applicable and is set to Null.",
				ResolutionDescription->"Automatically set to the SampleLoadingBufferVolume field of the AnalysisMethod. If PreparedPlate is True, automatically set to Null. For a list of the default SampleLoadingBufferVolume for each AnalysisMethod, see Figure 3.2 under SampleLoadingBuffer of Experiment Options.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter, 200 Microliter],
					Units->{Microliter, {Microliter,Milliliter}}
				],
				Category->"Sample Preparation"
			}
		],
		IndexMatching[
			IndexMatchingParent->Ladder,
			{
				OptionName->Ladder,
				Default->Automatic,
				Description->"The solution(s) that contain nucleic acids of known lengths used for qualitative or quantitative data analysis. One ladder solution, which is dispensed to Position H12 (for a 96-capillary array), is recommended for each run of the capillary array. If multiple ladders are specified, each ladder is dispensed on the sample plate to occupy successive wells up until Position H12 (for a 96-capillary array). For example, with a 96-capillary array with 3 specified ladders, the first ladder is dispensed to Position H10, the second ladder to Position H11 and the third ladder to position H12. If PreparedPlate is set to True, Ladder is specified as the Well Position(s) the ladder solution(s) has been dispensed to, and are consecutive Well Positions to end in H12 (for example, if there are three ladder solutions in the PreparedPlate, Ladder is set to H10, H11 and H12).",
				ResolutionDescription->"If PreparedPlate is False, automatically set to the Ladder field of the AnalysisMethod and is dispensed to occupy successive wells until Position H12 for a 96-capillary array. If PreparedPlate is True, automatically set to {\"H12\"} unless Well Position(s) are specified. For a list of the default Ladders for each AnalysisMethod, see Figure 3.3 under Ladder of Experiment Options. At ladder is always required at Position H12.",
				AllowNull->True,
				Widget->Alternatives[
					"Ladder Solution"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
						OpenPaths->{
							{
								Object[Catalog,"Root"],
								"Materials",
								"Fragment Analysis",
								"Ladders"
							},
							{
								Object[Catalog,"Root"],
								"Materials",
								"Electrophoresis",
								"Ladders",
								"Fragment Analysis"
							}
						}
					],
					"Prepared Plate Well"->Widget[
						Type->Enumeration,
						Pattern:>Alternatives @@ Flatten[AllWells[NumberOfWells -> 96]],
						PatternTooltip -> "Enumeration must be any well from A1 to H12."
					]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->LadderVolume,
				Default->Automatic,
				Description->"The volume of ladder that is transferred into the plate, prior to addition of  LadderLoadingBuffer, and before loading into the instrument. If PreparedPlate is True, this option is not applicable and is set to Null.",
				ResolutionDescription->"Automatically set to the LadderVolume field of the AnalysisMethod. If PreparedPlate is True, automatically set to Null. For a list of the default LadderVolume for each AnalysisMethod, see Figure 3.3 under Ladder of Experiment Options.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:> RangeP[0 Microliter, 200 Microliter],
					Units->{Microliter, {Microliter,Milliliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->LadderLoadingBuffer,
				Default->Automatic,
				Description->"The solution added to the Ladder, to either add markers to or further dilute the Ladder prior to loading into the instrument. If PreparedPlate is True, this option is not applicable and is set to Null.",
				ResolutionDescription->"Automatically set to the LadderLoadingBuffer field of the AnalysisMethod. If PreparedPlate is True, automatically set to Null. For a list of the default LadderLoadingBuffer for each AnalysisMethod, see Figure 3.4 under LadderLoadingBuffer of Experiment Options.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					OpenPaths->{
						{
							Object[Catalog,"Root"],
							"Materials",
							"Fragment Analysis",
							"Loading Buffers"
						}
					}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->LadderLoadingBufferVolume,
				Default->Automatic,
				Description->"The volume of LadderLoadingBuffer added to the Ladder (after aliquoting, if applicable), to either add markers to or further dilute the Ladder prior to loading into the instrument. If PreparedPlate is True, this option is not applicable and is set to Null.",
				ResolutionDescription->"Automatically set to the LadderLoadingBufferVolume field of the AnalysisMethod. If PreparedPlate is True, automatically set to Null. For a list of the default LoadingBufferVolume for each AnalysisMethod, see Figure 3.4 under LadderLoadingBuffer of Experiment Options.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Microliter, 200 Microliter],
					Units->{Microliter, {Microliter,Milliliter}}
				],
				Category->"Sample Preparation"
			}
		],
		IndexMatching[
			IndexMatchingParent -> Blank,
			{
				OptionName->Blank,
				Default->Automatic,
				Description->"The solution that is dispensed in the well(s) of the sample plate required to be filled that are not filled by a sample or a ladder. For example, for a run using a 96-capillary array, if there are only 79 samples and 1 ladder, 16 wells are filled with Blank.). Wells filled with Blank each contain a volume equal to the total volume of TargetSampleVolume and LoadingBufferVolume of the AnalysisMethod. If PreparedPlate is set to True, Blank is specified as the Well Position(s) the blank solution(s) have been dispensed to.",
				ResolutionDescription->"Automatically set to the Blank field of the AnalysisMethod if there are wells unoccupied by the samples or ladders. If PreparedPlate is True and Blank is not specified, automatically set to  Null. For a list of the default Blank for each AnalysisMethod, see Figure 3.5 under Blank of Experiment Options.",
				AllowNull->True,
				Widget->Alternatives[
					"Blank Solution"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
						OpenPaths->{
							{
								Object[Catalog,"Root"],
								"Materials",
								"Fragment Analysis",
								"Blanks"
							}
						}
					],
					"Prepared Plate Well"->Widget[
						Type->Enumeration,
						Pattern:>Alternatives @@ Flatten[AllWells[NumberOfWells -> 96]],
						PatternTooltip -> "Enumeration must be any well from A1 to H12."
					]
				],

				Category->"Sample Preparation"
			}
		],
		(*===Capillary Conditioning===*)
		{
			OptionName->SeparationGel,
			Default->Automatic,
			Description->"The gel reagent that serves as sieving matrix to facilitate the optimal separation of the analyte fragments in each sample by size. Each capillary in the array is flushed with the ConditioningSolution followed by filling with a mixture of the SeparationGel and the Dye prior to sample runs.",
			ResolutionDescription->"Automatically set to the SeparationGel field of the AnalysisMethod. For a list of the default SeparationGel for each AnalysisMethod, see Figure 3.6 under SeparationGel of Experiment Options.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Fragment Analysis",
						"Separation Gels"
					},
					{
						Object[Catalog,"Root"],
						"Materials",
						"Electrophoresis",
						"Gels",
						"Fragment Analysis"
					}
				}
			],
			Category->"Capillary Conditioning"
		},
		{
			OptionName->Dye,
			Default->Automatic,
			Description->"The solution of a dye molecule that fluoresces when bound to DNA or RNA fragments in the sample and is used in the detection of the analyte fragments as it passes through the detection window of the capillary. Each capillary in the array is flushed with the ConditioningSolution followed by filling with a mixture of the SeparationGel and the Dye prior to sample runs.",
			ResolutionDescription->"Automatically set to the Dye field of the AnalysisMethod. The default Dye for most AnalysisMethod is Model[Sample, \"Intercalating Dye for ExperimentFragmentAnalysis\"]",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Fragment Analysis",
						"Dyes"
					},
					{
						Object[Catalog,"Root"],
						"Materials",
						"Electrophoresis",
						"Loading Dyes"
					}
				}
			],
			Category->"Capillary Conditioning"
		},
		{
			OptionName->ConditioningSolution,
			Default->Automatic,
			Description->"The solution used in the priming of the capillaries before filling with the SeparationGel and Dye prior to a sample run. The flushing of the capillary array with the conditioning solution restores capillary performance and helps maintain the low and reproducible electroosmotic flow for more precise analyte mobilities and migration times by stabilizing buffer pH and background electrolyte levels. This step also acts to flush out unwanted molecules or reagents from previous runs to minimize contamination of samples.",
			ResolutionDescription->"Automatically set to the ConditioningSolution field of the AnalysisMethod. The default conditioning solution for most AnalysisMethod is Model[Sample, StockSolution, \"1X Conditioning Solution for ExperimentFragmentAnalysis\"]",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Fragment Analysis",
						"Conditioning Solutions"
					}
				}
			],
			Category->"Capillary Conditioning"
		},
		(*===Optional Capillary Flush Step===*)
		{
			OptionName->CapillaryFlush,
			Default->Automatic,
			Description->"Indicates if an optional CapillaryFlush procedure is performed prior to a sample run. A CapillaryFlush step involves running specified CapillaryFlushSolution(s) through the capillaries and into a Waste Plate. CapillaryFlush is False by default since a capillary conditioning step (which also has the effect of washing the capillaries) is always performed prior to every sample run.",
			ResolutionDescription->"If NumberOfCapillaries is set to a number between 1 to 3, automatically set to True. Otherwise, set to False.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->NumberOfCapillaryFlushes,
			Default->Automatic,
			Description->"The number of CapillaryFlush steps that are performed prior to the sample run, where the specified CapillaryFlushSolution for each step runs through the capillaries and into the Waste Plate.",
			ResolutionDescription->"If CapillaryFlush is set to True, automatically set to 1.",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,3,1] (*Minimum and Maximum Values are set by the Instrument*)
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->PrimaryCapillaryFlushSolution,
			Default->Automatic,
			Description->"The solution that runs through the capillaries and into the Waste Plate during the first CapillaryFlush step.",
			ResolutionDescription->"If CapillaryFlush is set to True, automatically set to Model[Sample, StockSolution, \"1X Conditioning Solution for ExperimentFragmentAnalysis\"].",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				OpenPaths-> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Fragment Analysis",
						"Conditioning Solutions"
					}
				}
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->PrimaryCapillaryFlushPressure,
			Default->Automatic,
			Description->"The positive pressure applied at the capillaries' destination by a high pressure syringe pump that drives the PrimaryCapillaryFlushSolution through the capillaries backwards from the reservoir and into the Waste Plate during the first CapillaryFlush step.",
			ResolutionDescription->"If CapillaryFlush is set to True, automatically set to 280 PSI.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.1 PSI, 300 PSI], (*Minimum and Maximum Values are set by the Instrument*)
				Units->{PSI, {Pascal,Kilopascal,PSI,Millibar,Bar}}
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->PrimaryCapillaryFlushFlowRate,
			Default->Automatic,
			Description->"The flow rate of the PrimaryCapillaryFlushSolution as it runs through the capillaries and into the Waste Plate during the first CapillaryFlush step.",
			ResolutionDescription->"If CapillaryFlush is set to True, automatically set to 200 Microliter/Second.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Microliter/Second, 1000 Microliter/Second], (*Minimum and Maximum Values are set by the Instrument*)
				Units -> CompoundUnit[
							{1,{Milliliter,{Microliter,Milliliter}}},
							{-1,{Second,{Second,Minute}}}
						]
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->PrimaryCapillaryFlushTime,
			Default->Automatic,
			Description->"The duration for which the PrimaryCapillaryFlushSolution runs through the capillaries and into the Waste Plate during the first CapillaryFlush step.",
			ResolutionDescription->"If CapillaryFlush is set to True, automatically set to 180 Second.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Minute, 240 Minute], (*Minimum and Maximum Values are set by the Instrument*)
				Units->{Second, {Second,Minute}}
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->SecondaryCapillaryFlushSolution,
			Default->Automatic,
			Description->"The solution that runs through the capillaries and into the Waste Plate during the second CapillaryFlush step.",
			ResolutionDescription->"If NumberOfCapillaryFlushes is greater than 1, automatically set to Model[Sample,\"Agilent Conditioning Solution for Fragment Analysis\"].",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				OpenPaths-> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Fragment Analysis",
						"Conditioning Solutions"
					}
				}
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->SecondaryCapillaryFlushPressure,
			Default->Automatic,
			Description->"The positive pressure applied at the capillaries' destination by a high pressure syringe pump that drives the SecondaryCapillaryFlushSolution through the capillaries backwards from the reservoir and into the Waste Plate during the second CapillaryFlush step.",
			ResolutionDescription->"If NumberOfCapillaryFlushes is greater than 1, automatically set to 280 PSI.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 PSI, 300 PSI], (*Minimum and Maximum Values are set by the Instrument*)
				Units->{PSI, {Pascal,Kilopascal,PSI,Millibar,Bar}}
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->SecondaryCapillaryFlushFlowRate,
			Default->Automatic,
			Description->"The flow rate of the SecondaryCapillaryFlushSolution as it runs through the capillaries and into the Waste Plate during the second CapillaryFlush step.",
			ResolutionDescription->"If NumberOfCapillaryFlushes is greater than 1, automatically set to 200 Microliter/Second.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Microliter/Second, 1000 Microliter/Second], (*Minimum and Maximum Values are set by the Instrument*)
				Units -> CompoundUnit[
							{1,{Milliliter,{Microliter,Milliliter}}},
							{-1,{Second,{Second,Minute}}}
						]
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->SecondaryCapillaryFlushTime,
			Default->Automatic,
			Description->"The duration for which the SecondaryCapillaryFlushSolution runs through the capillaries and into the Waste Plate during the second CapillaryFlush step.",
			ResolutionDescription->"If NumberOfCapillaryFlushes is greater than 1, automatically set to 180 Second.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Minute, 240 Minute], (*Minimum and Maximum Values are set by the Instrument*)
				Units->{Second, {Second,Minute}}
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->TertiaryCapillaryFlushSolution,
			Default->Automatic,
			Description->"The solution that runs through the capillaries and into the Waste Plate during the third CapillaryFlush step.",
			ResolutionDescription->"If NumberOfCapillaryFlushes is 3, automatically set to Model[Sample,\"Agilent Conditioning Solution for Fragment Analysis\"].",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				OpenPaths-> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Fragment Analysis",
						"Conditioning Solutions"
					}
				}
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->TertiaryCapillaryFlushPressure,
			Default->Automatic,
			Description->"The positive pressure applied at the capillaries' destination by a high pressure syringe pump that drives the TertiaryCapillaryFlushSolution through the capillaries backwards from the reservoir and into the Waste Plate during the third CapillaryFlush step.",
			ResolutionDescription->"If NumberOfCapillaryFlushes is 3, automatically set to 280 PSI.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 PSI, 300 PSI], (*Minimum and Maximum Values are set by the Instrument*)
				Units->{PSI, {Pascal,Kilopascal,PSI,Millibar,Bar}}
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->TertiaryCapillaryFlushFlowRate,
			Default->Automatic,
			Description->"The flow rate of the TertiaryCapillaryFlushSolution as it runs through the capillaries and into the Waste Plate during the third CapillaryFlush step.",
			ResolutionDescription->"If NumberOfCapillaryFlushes is 3, automatically set to 200 Microliter/Second.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Microliter/Second, 1000 Microliter/Second], (*Minimum and Maximum Values are set by the Instrument*)
				Units -> CompoundUnit[
							{1,{Milliliter,{Microliter,Milliliter}}},
							{-1,{Second,{Second,Minute}}}
						]
			],
			Category->"Capillary Flush"
		},
		{
			OptionName->TertiaryCapillaryFlushTime,
			Default->Automatic,
			Description->"The duration for which the TertiaryCapillaryFlushSolution runs through the capillaries and into the Waste Plate during the third CapillaryFlush step.",
			ResolutionDescription->"If NumberOfCapillaryFlushes is 3, automatically set to 180 Second.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Minute, 240 Minute], (*Minimum and Maximum Values are set by the Instrument*)
				Units-> {Second, {Second,Minute}}
			],
			Category->"Capillary Flush"
		},
		(*===Capillary Equilibration*)
		{
			OptionName->CapillaryEquilibration,
			Default->True,
			Description->"Indicates if a voltage is run through the capillaries as the source tips of the capillaries are immersed in the wells of the RunningBufferPlate in order to prepare the gel inside the capillaries and normalize the electroosmotic flow for more precise analyte mobilities and migration times during separation. If applicable, this is done after the introduction of the SeparationGel and Dye into the capillaries.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"Capillary Equilibration"
		},
		{
			OptionName->PreparedRunningBufferPlate,
			Default->Null,
			Description->"The pre-prepared 96-well plate which contains the buffer solutions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments. The tips of the capillaries are immersed in the wells of the RunningBufferPlate during the CapillaryEquilibration and Separation steps. The contents of the wells matching the well position of the Samples, Ladder(s) and Blank(s) serve as the SampleRunningBuffer, LadderRunningBuffer (if applicable) and BlankRunningBuffer (if applicable).  In order for the capillary tips to reach the solution, a minimum volume of 1 Milliliter of buffer solution is required in the each well of the plate and must be in plate model Model[Container, Plate, \"96-well 1mL Deep Well Plate (Short) for FragmentAnalysis\"].",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[Object[Container,Plate]]
			],
			Category->"Capillary Equilibration"
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleRunningBuffer,
				Default->Automatic,
				Description->"The buffer solution that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments in the sample. The tips of the capillaries are immersed in the wells of a RunningBufferPlate during the CapillaryEquilibration and Separation steps. If PreparedRunningBufferPlate is not specified, a new 96-well plate that contains the SampleRunningBuffer in the matching WellPosition(s) of the SamplesIn is prepared.",
				ResolutionDescription->"If PreparedRunningBufferPlate is specified, set to the content(s) of the well matching the well position of the SamplesIn. If PreparedRunningBufferPlate is Null, automatically set to the SampleRunningBuffer field of the AnalysisMethod. Otherwise, automatically set to Model[Sample, StockSolution, \"1x Running Buffer for ExperimentFragmentAnalysis\"].",
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					OpenPaths->{
						{
							Object[Catalog,"Root"],
							"Materials",
							"Fragment Analysis",
							"Running Buffers"
						}
					}
				],
				Category->"Capillary Equilibration"
			}
		],
		IndexMatching[
			IndexMatchingParent->Ladder,
			{
				OptionName->LadderRunningBuffer,
				Default->Automatic,
				Description->"The buffer solution that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of fragments in the ladder. The tips of the capillaries are immersed in the wells of a RunningBufferPlate during the CapillaryEquilibration and Separation steps. If PreparedRunningBufferPlate is not specified, a new 96-well plate that contains the LadderRunningBuffer in the matching WellPosition(s) of the Ladder is prepared.",
				ResolutionDescription->"If PreparedRunningBufferPlate is specified and Ladder is not Null, set to the content(s) of the well matching the well position of the Ladder(s). If PreparedRunningBufferPlate is Null and Ladder is not Null, automatically set to the LadderRunningBuffer field of the AnalysisMethod.",
				AllowNull->True,
				Widget-> Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					OpenPaths->{
						{
							Object[Catalog,"Root"],
							"Materials",
							"Fragment Analysis",
							"Running Buffers"
						}
					}
				],
				Category->"Capillary Equilibration"
			}
		],
		IndexMatching[
			IndexMatchingParent -> Blank,
			{
				OptionName->BlankRunningBuffer,
				Default->Automatic,
				Description->"The buffer solution that contains ions that help conduct current through the gel in the capillaries that contain the blank. The tips of the capillaries are immersed in the wells of a RunningBufferPlate during the CapillaryEquilibration and Separation steps. If PreparedRunningBufferPlate is not specified, a new 96-well plate that contains the BlankRunningBuffer in the matching WellPosition(s) of the Blank is prepared.",
				ResolutionDescription->"If PreparedRunningBufferPlate is specified and Blank is not Null, set to the content(s) of the well matching the well position of the Blank(s). If PreparedRunningBufferPlate is Null and Blank is not Null, automatically set to the BlankRunningBuffer field of the AnalysisMethod.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					OpenPaths->{
						{
							Object[Catalog,"Root"],
							"Materials",
							"Fragment Analysis",
							"Running Buffers"
						}
					}
				],
				Category->"Capillary Equilibration"
			}
		],
		{
			OptionName->RunningBufferPlateStorageCondition,
			Default->Refrigerator,
			AllowNull->False,
			Widget->Widget[
				Type -> Enumeration,
				Pattern :> SampleStorageTypeP|Disposal
			],
			Description->"The non-default condition under which the RunningBufferPlate is stored after the protocol is completed.",
			Category->"Capillary Equilibration"
		},
		{
			OptionName->EquilibrationVoltage,
			Default->Automatic,
			Description->"The electric potential applied across the capillaries as the capillaries are immersed in the RunningBuffer to condition the gel inside the capillaries and normalize the electroosmotic flow for more precise analyte mobilities and migration times prior to a Pre-Marker Rinse or a Pre-Sample Rinse step.",
			ResolutionDescription->"If CapillaryEquilibration is set to False, automatically set to Null. If CapillaryEquilibration is set to True and EquilibrationVoltage field of the AnalysisMethod is  not Null, set to the EquilibrationVoltage field of the AnalysisMethod. If CapillaryEquilibration is set to True and EquilibrationVoltage field of the AnalysisMethod is  Null, set to the 8.0 Kilovolt.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Kilovolt, 15 Kilovolt], (*Minimum and Maximum Values are set by the Instrument*)
				Units -> {Kilovolt, {Volt, Kilovolt}}
			],
			Category->"Capillary Equilibration"
		},
		{
			OptionName->EquilibrationTime,
			Default->Automatic,
			Description->"The duration for which electric potential (EquilibrationVoltage) is applied across the capillaries as the capillaries are immersed in the RunningBuffer to condition the gel inside the capillaries and normalize the electroosmotic flow for more precise analyte mobilities and migration times.",
			ResolutionDescription->"If CapillaryEquilibration is True and AnalysisMethod is specified, automatically set to the EquilibrationTime field of the AnalysisMethod.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Second, 20 Minute], (*Minimum and Maximum Values are set by the Instrument*)
				Units-> {Second, {Second,Minute}}
			],
			Category->"Capillary Equilibration"
		},
		(*===Pre-Marker Rinse===*)
		{
			OptionName->PreMarkerRinse,
			Default->Automatic,
			Description->"Indicates if the tips of the capillaries are rinsed by dipping them in and out of the PreMarkerRinseBuffer contained in the wells of a compatible 96-well plate in order to wash off any previous reagents the capillaries may have come in contact with. This step precedes the MarkerInjection step.",
			ResolutionDescription->"If the AnalysisMethod is specified, automatically set to the PreMarkerRinse field of the AnalysisMethod. Otherwise, automatically set to False.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"Pre-Marker Rinse"
		},
		{
			OptionName->NumberOfPreMarkerRinses,
			Default->Automatic,
			Description->"The number of dips of the capillary tips in and out of the PreMarkerRinseBuffer contained in the wells of a compatible 96-well plate prior to MarkerInjection in order to wash off any previous reagents the capillaries may have come in contact with. This step precedes the MarkerInjection step.",
			ResolutionDescription->"If PreMarkerRinse is True, automatically set to the NumberOfPreMarkerRinses field of the AnalysisMethod. If PreMarkerRinse is True and the NumberOfPreMarkerRinses field of the AnalysisMethod is Null, automatically set to 1. If PreMarkerRinse is False, automatically set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,20,1] (*Minimum and Maximum Values are set by the Instrument*)
			],
			Category->"Pre-Marker Rinse"
		},
		{
			OptionName->PreMarkerRinseBuffer,
			Default->Automatic,
			Description->"The buffer solution that is used to rinse the capillary tips by dipping them in and out of the PreMarkerRinseBuffer contained in the wells of a compatible 96-well plate in order to wash off any previous reagents the sample capillaries may have come in contact with. This step precedes the MarkerInjection step.",
			ResolutionDescription->"If PreMarkerRinse is True, automatically set to the PreMarkerRinseBuffer field of the AnalysisMethod. For a list of the default PreMarkerRinseBuffer for each AnalysisMethod, see Figure 3.8 under PreMarkerRinse of Experiment Options.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Fragment Analysis",
						"Rinse Buffers"
					}
				}
			],
			Category->"Pre-Marker Rinse"
		},
		{
			OptionName->PreMarkerRinseBufferPlateStorageCondition,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type -> Enumeration,
				Pattern :> SampleStorageTypeP|Disposal
			],
			Description->"The non-default condition under which the PreMarkerRinseBuffer (contained in the PreMarkerRinseBufferPlate) is stored after the protocol is completed.",
			ResolutionDescription->"If PreMarkerRinseBuffer is not Null, automatically set to Disposal. Otherwise, set to Null.",
			Category->"Pre-Marker Rinse"
		},
		(*===Marker Injection===*)
		{
			OptionName->MarkerInjection,
			Default->Automatic,
			Description->"Indicates if injection of SampleMarker, LadderMarker (if applicable) and BlankMarker (if applicable) into the capillaries is performed prior to a sample run. SampleMarker, LadderMarker and BlankMarker are solutions contained in a MarkerPlate that contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size.",
			ResolutionDescription->"If the AnalysisMethod is specified, automatically set to the MarkerInjection field of the AnalysisMethod. Otherwise, automatically set to False.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"Marker Injection"
		},
		{
			OptionName->PreparedMarkerPlate,
			Default->Null,
			Description->"The pre-prepared 96-well plate which contains the marker solutions that contain upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. The contents of the wells matching the well position of the Samples, Ladder(s) and Blank(s) serve as the SampleMarker, LadderMarker (if applicable) and BlankMarker (if applicable). In order for the capillary tips to reach the solution, a minimum volume of 50 Microliter of solution is required in the each well of the plate.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[Object[Container,Plate]]
			],
			Category->"Marker Injection"
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleMarker,
				Default->Automatic,
				Description->"The solution that contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. Tha SampleMarker is injected into the capillaries during MarkerInjection and runs with the samples during Separation. If PreparedMarkerPlate is not specified, a new 96-well plate that contains the SampleMarker in the matching WellPosition(s) of the SamplesIn is prepared.",
				ResolutionDescription->"If PreparedMarkerPlate is specified, set to the content(s) of the well matching the WellPosition of the SamplesIn. If PreparedMarkerPlate is Null and MarkerInjection is True, automatically set to the SampleMarker field of the AnalysisMethod, if not Null. If PreparedMarkerPlate is Null and MarkerInjection is True and SampleMarker field of AnalysisMethod is Null, automatically set to Model[Sample, \"35 bp and 5000 bp Markers for ExperimentFragmentAnalysis\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					OpenPaths->{
						{
							Object[Catalog,"Root"],
							"Materials",
							"Fragment Analysis",
							"Markers"
						}
					}
				],
				Category->"Marker Injection"
			}
		],
		IndexMatching[
			IndexMatchingParent->Ladder,
			{
				OptionName->LadderMarker,
				Default->Automatic,
				Description->"The solution that contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. Tha LadderMarker is injected into the capillaries during MarkerInjection and runs with the Ladder(s) during Separation. If PreparedMarkerPlate is not specified, a new 96-well plate that contains the LadderMarker in the matching WellPosition(s) of the Ladder(s) is prepared.",
				ResolutionDescription->"If PreparedMarkerPlate is specified, set to the content(s) of the well matching the WellPosition of the Ladder. If PreparedMarkerPlate is Null, MarkerInjection is True and Ladder is not Null, automatically set to the LadderMarker field of the AnalysisMethod, if not Null. If PreparedMarkerPlate is Null, MarkerInjection is True, Ladder is not Null and LadderMarker field of AnalysisMethod is Null, automatically set to Model[Sample, \"100-3000 bp DNA Ladder for ExperimentFragmentAnalysis\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					OpenPaths->{
						{
							Object[Catalog,"Root"],
							"Materials",
							"Fragment Analysis",
							"Running Buffers"
						}
					}
				],
				Category->"Marker Injection"
			}
		],
		IndexMatching[
			IndexMatchingParent -> Blank,
			{
				OptionName->BlankMarker,
				Default->Automatic,
				Description->"The solution that contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size. Tha BlankMarker is injected into the capillaries during MarkerInjection and runs with the Blank(s) during Separation. If PreparedMarkerPlate is not specified, a new 96-well plate that contains the BlankMarker in the matching WellPosition(s) of the Blank(s) is prepared.",
				ResolutionDescription->"If PreparedMarkerPlate is specified, set to the content(s) of the well matching the WellPosition of the Blank. If PreparedMarkerPlate is Null, MarkerInjection is True and Blank is not Null, automatically set to the BlankMarker field of the AnalysisMethod, if not Null. If PreparedMarkerPlate is Null, MarkerInjection is True, Blank is not Null and BlankMarker field of AnalysisMethod is Null, automatically set to Model[Sample, \"100-3000 bp DNA Ladder for ExperimentFragmentAnalysis\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
					OpenPaths->{
						{
							Object[Catalog,"Root"],
							"Materials",
							"Fragment Analysis",
							"Running Buffers"
						}
					}
				],
				Category->"Marker Injection"
			}
		],
		{
			OptionName->MarkerInjectionTime,
			Default->Automatic,
			Description->"The duration an electric potential (VoltageInjection) is applied across the capillaries to drive the Marker into the capillaries. In VoltageInjection, the injected volume is proportional to the MarkerInjectionTime. In addition, a short InjectionTime reduces band broadening while a longer InjectionTime can serve to minimize voltage or pressure variability during injection.",
			ResolutionDescription->"If the AnalysisMethod is specified, automatically set to the MarkerInjectionTime field of the AnalysisMethod. If MarkerInjection is True and AnalysisMethod is not specified, automatically set to 5 Second. For a list of the default MarkerInjectionTime for each AnalysisMethod, see Figure 3.9 under MarkerInjection of Experiment Options.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Second, 20 Minute], (*Minimum and Maximum Values are set by the Instrument*)
				Units-> {Second, {Second,Minute}}
			],
			Category->"Marker Injection"
		},
		{
			OptionName->MarkerInjectionVoltage,
			Default->Automatic,
			Description->"The electric potential applied across the capillaries to drive the Marker forward into the capillaries, from the Marker Plate to the capillary inlet, during the MarkerInjection step. The injected volume is proportional to the MarkerInjectionVoltage, where the higher the MarkerInjectionVoltage, the higher the injected volume. For a list of the default MarkerInjectionVoltage for each AnalysisMethod, see Figure 3.9 under MarkerInjection of Experiment Options.",
			ResolutionDescription->"If the AnalysisMethod is specified, automatically set to the MarkerInjectionVoltage field of the AnalysisMethod. If MarkerInjection is True, OR AnalysisMethod is not specified, set to 3 Kilovolt.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Kilovolt, 149.7 Kilovolt], (*Minimum and Maximum Values are set by the Instrument*)
				Units -> {Kilovolt, {Volt, Kilovolt}}
			],
			Category->"Marker Injection"
		},
		{
			OptionName->MarkerPlateStorageCondition,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type -> Enumeration,
				Pattern :> SampleStorageTypeP|Disposal
			],
			Description->"The non-default condition under which the MarkerPlate is stored after the protocol is completed.",
			ResolutionDescription->"If SampleMarker, LadderMarker OR BlankMarker is Not Null, automatically set to Refrigerator. Otherwise, set to Null.",
			Category->"Marker Injection"
		},
		(*===Pre-Sample Rinse===*)
		{
			OptionName->PreSampleRinse,
			Default->Automatic,
			Description->"Indicates if the tips of the capillaries are rinsed by dipping them in and out of the PreSampleRinseBuffer contained in the wells of a compatible 96-well plate in order to wash off any previous reagents the capillaries may have come in contact with. This step precedes the sampleInjection step.",
			ResolutionDescription->"If the AnalysisMethod is specified, automatically set to the PreSampleRinse field of the AnalysisMethod. Otherwise, automatically set to False.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			(*
			Widget->Alternatives[
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[RunningBufferPlate,MarkerPlate]
				],
				Widget[
					Type->Object,
					Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
					(*OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Fragment Analysis",
						"Rinse Buffers"
					}
				}*)
				]
			],
			*)
			Category->"Pre-Sample Rinse"
		},
		{
			OptionName->NumberOfPreSampleRinses,
			Default->Automatic,
			Description->"The number of dips of the capillary tips in and out of the PreSampleRinseBuffer contained in the wells of a compatible 96-well plate prior to MarkerInjection in order to wash off any previous reagents the capillaries may have come in contact with. This step precedes the SampleInjection step.",
			ResolutionDescription->"If PreSampleRinse is True, automatically set to the NumberOfPreSampleRinses field of the AnalysisMethod. If PreSampleRinse is True and the NumberOfPreSampleRinses field of the AnalysisMethod is Null, automatically set to 1. If PreSampleRinse is False, automatically set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1, 20, 1] (*Minimum and Maximum Values are set by the Instrument*)
			],
			Category->"Pre-Sample Rinse"
		},
		{
			OptionName->PreSampleRinseBuffer,
			Default->Automatic,
			Description->"The buffer solution that is used to rinse the capillary tips by dipping them in and out of the PreSampleRinseBuffer contained in the wells of a compatible 96-well plate in order to wash off any previous reagents the sample capillaries may have come in contact with. This step precedes the SampleInjection step. The recommended buffer used for rinsing (Tris-EDTA buffer) maintains the ideal pH for nucleic acid solubilization (Tris buffer), as well as protects the analyte from degradation by DNAses/RNAses (EDTA).",
			ResolutionDescription->"If PreSampleRinse is True, automatically set to the PreSampleRinseBuffer field of the AnalysisMethod. For a list of the default PreSampleRinseBuffer for each AnalysisMethod, see Figure 3.10 under PreSampleRinse of Experiment Options.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Materials",
						"Fragment Analysis",
						"Rinse Buffers"
					}
				}
			],
			Category->"Pre-Sample Rinse"
		},
		{
			OptionName->PreSampleRinseBufferPlateStorageCondition,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type -> Enumeration,
				Pattern :> SampleStorageTypeP|Disposal
			],
			Description->"The non-default condition under which the PreSampleRinseBuffer (contained in the Pre-Sample Rinse Plate) is stored after the protocol is completed.",
			ResolutionDescription->"If PreSampleRinseBuffer is not Null, automatically set to Disposal. Otherwise, set to Null.",
			Category->"Pre-Sample Rinse"
		},
		(*===Sample Injection===*)
		{
			OptionName->SampleInjectionTime,
			Default->Automatic,
			Description->"The duration a electric potential (VoltageInjection) is applied across the capillaries to drive the samples into the capillaries. The injected volume is proportional to the SampleInjectionTime. In addition, a short InjectionTime reduces band broadening while a longer InjectionTime can serve to minimize voltage or pressure variability during injection.",
			ResolutionDescription->"Automatically set to the SampleInjectionTime field of the AnalysisMethod. For a list of the default SampleInjectionTime for each AnalysisMethod, see Figure 3.11 under SampleInjectionTime of Experiment Options.",
			AllowNull->False,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Second, 20 Minute], (*Minimum and Maximum Values are set by the Instrument*)
				Units-> {Second, {Second,Minute}}
			],
			Category->"Sample Injection"
		},
		{
			OptionName->SampleInjectionVoltage,
			Default->Automatic,
			Description->"The electric potential applied across the capillaries to drive the samples or ladders forward into the capillaries, from the Sample Plate to the capillary inlet, during the SampleInjection step. The injected volume is proportional to the SampleInjectionVoltage, where the higher the SampleInjectionVoltage, the higher the injected volume.",
			ResolutionDescription->"Automatically set to the SampleInjectionVoltage field of the AnalysisMethod. For a list of the default SampleInjectionVoltage for each AnalysisMethod, see Figure 3.12 under SampleInjectionVoltage of Experiment Options.",
			AllowNull->False,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Kilovolt, 149.7 Kilovolt], (*Minimum and Maximum Values are set by the Instrument*)
				Units -> {Kilovolt, {Volt, Kilovolt}}
			],
			Category->"Sample Injection"
		},
		(*===Separation===*)
		{
			OptionName->SeparationTime,
			Default->Automatic,
			Description->"The duration for which the SeparationVoltage is applied across the capillaries in order for migration of analytes to occur. There should be sufficient SeparationTime for the analytes to migrate from the capillary inlet end to the capillary outlet end for a complete analysis. The higher the SeparationVoltage, the shorter the SeparationTime necessary for complete migration of analytes through the capillaries.",
			ResolutionDescription->"Automatically set to the SeparationTime field of the AnalysisMethod. For a list of the default SeparationTime for each AnalysisMethod, see Figure 3.13 under SeparationTime of Experiment Options.",
			AllowNull->False,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1 Minute, 240 Minute], (*Minimum and Maximum Values are set by the Instrument but Agilent recommends that going beyond 4 hours will damage the high voltage power supply and is not recommended*)
				Units-> {Second, {Second,Minute, Hour}}
			],
			Category->"Separation"
		},
		{
			OptionName -> SeparationVoltage,
			Default -> Automatic,
			Description -> "The electric potential applied across the capillaries as the sample analytes migrate through the capillaries during the sample run. Higher SeparationVoltage results in faster separations and higher separation efficiencies but can also cause overheating of sample solutions if set too high.",
			ResolutionDescription -> "Automatically set to the SeparationVoltage field of the AnalysisMethod. For a list of the default SeparationVoltage for each AnalysisMethod, see Figure 3.14 under SeparationVoltage of Experiment Options.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Kilovolt, 15 Kilovolt],(*Minimum and Maximum Values are set by the Instrument but Agilent recommends that going beyond 15 kV will damage the high voltage power supply and is not recommended*)
				Units -> {Kilovolt, {Volt, Kilovolt}}
			],
			Category -> "Separation"
		},

		(*===Storage===*)
		(*need to figure this out*)
		ModelInputOptions,
		NonBiologyFuntopiaSharedOptions,
		ProtocolOptions,
		SimulationOption,
		OutputOption,
		CacheOption

	}
];

Error::DiscardedSamples="The samples `1` are discarded.";
Warning::AnalysisMethodAnalysisStrategyMismatchWarning="The AnalysisMethod (`1`) is not optimal for the selected AnalysisStrategy (`2`). Please check the Selection Criteria Guide to determine list of AnalysisMethod that are better suited for Quantitative Analysis.";
Warning::SampleAnalyteTypeAnalysisMethodMismatch="The SampleAnalyteType of the following samples (`1`) do(es) not match the TargetAnalyteType of the AnalysisMethod and may yield less than optimal results. Please double check the Selection Criteria Guide and specify the appropriate AnalysisMethod or SampleAnalyteType.";
Warning::CantDetermineSampleAnalyteType="SampleAnalyteType cannot be determined for the following samples (`1`) and has defaulted to DNA. Please indicate a SampleAnalyteType for the given sample for an optimized resolution of the AnalysisMethod, OR specify an AnalysisMethod best suited for the sample(s).";
Warning::CantDetermineReadLengths="MinReadLength and MaxReadLength cannot be determined for the following samples (`1`) and has defaulted to Null. Please indicate a MinReadLength and MaxReadLength for the given sample(s) for an optimized resolution of the AnalysisMethod, OR specify an AnalysisMethod best suited for the sample(s).";
Warning::AnalysisMethodNotOptimized="The determined AnalysisMethod is not optimized for some of the samples (`1`) specified. Please review the Selection Criteria Guide for AnalysisMethod, group samples accordingly, and specify the best suited AnalysisMethod to achieve optimized results.";
Error::CapillaryFlushNumberOfCapillaryFlushesMismatchError="The CapillaryFlush (`1`) and NumberOfCapillaryFlushes (`2`) are mismatched. If CapillaryFlush is False, NumberOfCapillaryFlushes must be Null. If CapillaryFlush is True, NumberOfCapillaryFlushes must either be 1,2 or 3. Please set CapillaryFlush and/or NumberOfCapillaryFlushes accordingly.";
Error::PrimaryCapillaryFlushMismatchError="The options PrimaryCapillaryFlushSolution, PrimaryCapillaryFlushPressure, PrimaryCapillaryFlushFlowRate and PrimaryCapillaryFlushTime can only be Null if, and only if, CapillaryFlush is False. Please change the following option(s) (`1`) to Null if CapillaryFlush is False, OR Except[Null] if CapillaryFlush is True.";
Error::SecondaryCapillaryFlushMismatchError="The options SecondaryCapillaryFlushSolution, SecondaryCapillaryFlushPressure, SecondaryCapillaryFlushFlowRate and SecondaryCapillaryFlushTime can only be Null if, and only if, NumberOfCapillaryFlushes is less than 2 OR Null. Please change the following option(s) (`1`) to Null if NumberOfCapillaryFlushes is less than 2 OR Null, OR Except[Null] if NumberOfCapillaryFlushes is greater than 1.";
Error::TertiaryCapillaryFlushMismatchError="The options TertiaryCapillaryFlushSolution, TertiaryCapillaryFlushPressure, TertiaryCapillaryFlushFlowRate and TertiaryCapillaryFlushTime can only be Null if, and only if, NumberOfCapillaryFlushes is less than 3 OR Null. Please change the following option(s) (`1`) to Null if NumberOfCapillaryFlushes is less than 3 OR Null, OR Except[Null] if NumberOfCapillaryFlushes is greater than 2.";
Warning::AnalysisMethodOptionsMismatch="The values of the following options `1` do(es) not match the suggested field value(s) from the AnalysisMethod and may not yield optimized results. Please check the appropriate Tables of Option Values for different AnalysisMethods under Experiment Options.";
Error::CapillaryEquilibrationOptionsMismatchErrors="The following Capillary Equilibration options are mismatched `1` with CapillaryEquilibration (`2`). If CapillaryEquilibration is False, EquilibrationVoltage and EquilibrationTime must be Null. If CapillaryEquilibration is True, EquilibrationVoltage and EquilibrationTime must be not be Null.";
Error::PreMarkerRinseOptionsMismatchErrors="The following values `1` of the PreMarker Rinse options `2` are mismatched. If PreMarkerRinse is False, NumberOfPreMarkerRinses, PreMarkerRinseBuffer and PreMarkerRinseBufferPlateStorageCondition must be Null. If PreMarkerRinse is True, NumberOfPreMarkerRinses, PreMarkerRinseBuffer and PreMarkerRinseBufferPlateStorageCondition must not be Null.";
Error::MarkerInjectionOptionsMismatchErrors="The following Marker Injection option(s) `1` are mismatched with MarkerInjection (`2`). If MarkerInjection is False, MarkerInjectionVoltage and MarkerInjectionTime must be Null. If MarkerInjection is True, MarkerInjectionVoltage and MarkerInjectionTime must not be Null.";
Error::MarkerInjectionPreparedMarkerPlateMismatchError="PreparedMarkerPlate cannot be an object if MarkerInjection is False. If MarkerInjection is False, PreparedMarkerPlate must be Null.";
Error::PreSampleRinseOptionsMismatchErrors="The following values `1` of the PreSample Rinse options `2` are mismatched. If PreSampleRinse is False, NumberOfPreSampleRinses, PreSampleRinseBuffer and PreSampleRinseBufferPlateStorageCondition must be Null. If PreSampleRinse is True, NumberOfPreSampleRinses, PreSampleRinseBuffer and PreSampleRinseBufferPlateStorageCondition must not be Null.";
Error::LadderPreparedPlateMismatchError="The Ladder `1` and PreparedPlate (`2`) options are mismatched. If PreparedPlate is False, Ladder can only be an Model[Sample] or Object[Sample] or Null. If PreparedPlate is True, Ladder can only be a WellPositionP or Null.";
Error::BlankPreparedPlateMismatchError="The Blank `1` and PreparedPlate (`2`) options are mismatched. If PreparedPlate is False, Blank can only be an Model[Sample] or Object[Sample] or Null. If PreparedPlate is True, Blank can only be a WellPositionP or Null.";
Error::LadderOptionsPreparedPlateMismatchError="The following options `1` for ladder`2`,respectively, are mismatched. If PreparedPlate is True, ladder related options including LadderVolume,LadderLoadingBuffer, and LadderLoadingBufferVolume are not applicable and must be Null.";
Error::LadderVolumeMismatchError="The following LadderVolume `1` is incompatible with the respective Ladder `2`. LadderVolume cannot be Null if Ladder is a specified object.";
Error::LadderLoadingBufferMismatchError="The following LadderLoadingBuffer `1` is incompatible with the respective Ladder `2`. LadderLoadingBuffer cannot be an object if Ladder is a Null.";
Error::LadderLoadingBufferVolumeMismatchError="The following LadderLoadingBufferVolume `1` is incompatible with the respective LadderLoadingBuffer `2`. LadderLoadingBufferVolume cannot be Null if Ladder is a specified object.";
Error::MaxLadderVolumeError="The total volume(s) `1` for the following option(s) `2` of the Ladder `3` are above the maximum volume limit (200 Microliter).";
Error::LadderRunningBufferMismatchError="The following LadderRunningBuffer `1` is incompatible with the respective Ladder `2`. LadderRunningBuffer can only be Null if, and only if, Ladder is Null.";
Error::BlankRunningBufferMismatchError="The following BlankRunningBuffer `1` is incompatible with the respective Blank `2`. BlankRunningBuffer can only be Null if, and only if, Blank is Null.";
Error::LadderMarkerMismatchError="The following LadderMarker `1` is incompatible with the respective Ladder `2`. If Ladder is Null, LadderMarker must be Null.";
Error::BlankMarkerMismatchError="The following BlankMarker `1` is incompatible with the respective Blank `2`. If Blank is Null, BlankMarker must be Null.";
Error::DuplicateWells="The following wells `1` are duplicated and found assigned for the following: `2`. Each Sample, Ladder or Blank must be assigned to a unique well. Please make changes to the relevant options to avoid duplicates.";
Warning::AnalysisMethodLadderOptionsMismatch="The values of the following option(s) `1` for the following Ladder(s) `2`  do(es) not match the suggested field value(s) from the AnalysisMethod and may not yield optimized results. Please check the appropriate Tables of Option Values for different AnalysisMethods under Experiment Options.";
Warning::AnalysisMethodBlankOptionsMismatch="The values of the following option(s) `1` for the following Blank(s) `2`  do(es) not match the suggested field value(s) from the AnalysisMethod and may not yield optimized results. Please check the appropriate Tables of Option Values for different AnalysisMethods under Experiment Options.";
Warning::AnalysisMethodLadderMismatch="The following Ladder(s) `1` do(es) not match the recommended Ladder of the AnalysisMethod and may not yield optimized results. Please check the appropriate Tables of Option Values for different AnalysisMethods under Experiment Options.";
Warning::AnalysisMethodBlankMismatch="The following Blank(s) `1` do(es) not match the recommended Blank of the AnalysisMethod and may not yield optimized results. Please check the appropriate Tables of Option Values for different AnalysisMethods under Experiment Options.";
Warning::CantCalculateSampleVolume="The SampleVolume for following samples `2` cannot be calculated based on sample information and has defaulted to the following `1`.";
Warning::CantCalculateSampleDiluentVolume="The SampleDiluentVolume for following samples `2` cannot be calculated based on sample information and has defaulted to the following `1`.";
Error::SampleOptionsPreparedPlateMismatchError="The value(s) of the following options `1` is incompatible with PreparedPlate (`2`) for the following samples: `3`. If PreparedPlate is True, SampleDilution must be False and sample-related options (SampleDiluent,SampleVolume,SampleDiluentVolume,SampleLoadingBuffer,SampleLoadingBufferVolume) must be Null.";
Error::SampleDilutionMismatch="The option(s) `1` is incompatible with SampleDilution `2` for the following sample(s) `3`.";
Error::SampleLoadingBufferVolumeMismatchError="The SampleLoadingBufferVolume `1` for the corresponding SampleLoadingBuffer `2` of the following samples `3` are incompatible. If SampleLoadingBuffer is Null, SampleLoadingBufferVolume must be Null. If SampleLoadingBuffer is an object, SampleLoadingBufferVolume must be a quantity.";
Error::MaxSampleVolumeError="The total volume(s) `1` for the following option(s) `2` of the Sample(s) `3` are above the maximum volume limit (200 Microliter).";
Warning::AnalysisMethodSampleOptionsMismatch="The values of the following option(s) `1` for the following sample(s) `2`  do(es) not match the suggested field value(s) from the AnalysisMethod and may not yield optimized results.  Please check the appropriate Tables of Option Values for different AnalysisMethods under Experiment Options.";
Error::TooManySolutionsForInjection="The total number of samples (`1`), Ladder (`2`) and Blank (`3`) are greater than 96. Please consider removing some to get to a total of 96 solutions for injection. A minimum of 11 blank solution(s) is set by default.";
Error::NotEnoughSolutionsForInjection="The total number of samples (`1`), Ladder (`2`) and Blank (`3`) are less than 96. If PreparedPlate is True, the total number of solutions for injection must be equal to 96. Please specify more samples or wells for Ladder or Blank to reach a total of 96.";
Error::PreparedPlateAliquotMismatchError="If PreparedPlate is True, Aliquot must all be False. Please change conflicting options or allow to resolve automatically.";
Error::SampleVolumeError="The following SampleVolume `1` for the following samples `2` are invalid. If PreparedPlate is False, SampleVolume must be a quantity.";
Error::PreparedPlateModelError="The following container(s) `1` that holds the input samples is not valid if PreparedPlate is True. If PreparedPlate is True, samples must all be in the same container and the plate must be Instrument-compatible.";
Error::PreparedRunningBufferPlateModelError="The following container(s) `1` that holds the running buffer solutions is not valid. If PreparedRunningBufferPlate is specified, the plate must be Instrument-compatible and of this model: Model[Container, Plate, \"96-well 1mL Deep Well Plate (Short) for FragmentAnalysis\"].";
Error::PreparedMarkerPlateModelError="The following container(s) `1` that holds the marker solutions is not valid. If PreparedMarkerPlate is specified, the plate must be Instrument-compatible and of this model: \"96-well Semi-Skirted PCR Plate for FragmentAnalysis\"].";
Error::PreparedRunningBufferPlateError="The following options `1` conflict with PreparedRunningBufferPlate. If PreparedRunningBufferPlate is specified, SampleRunningBuffer,LadderRunningBuffer (if applicable), BlankRunningBuffer (if applicable) must match the contents of the corresponding PreparedRunningBufferPlate wells. If PreparedRunningBufferPlate is specified, please allow RunningBuffer options to be set to Automatic.";
Error::PreparedMarkerPlateError="The following options `1` conflict with PreparedMarkerPlate. If PreparedMarkerPlate is specified, SampleMarker,LadderMarker (if applicable), BlankMarker (if applicable) must match the contents of the corresponding PreparedMarkerPlate wells. If PreparedMarkerPlate is specified, please allow Marker options to be set to Automatic.";

(* ::Subsubsection::Closed:: *)
(*ExperimentFragmentAnalysis (Sample Input/ Core Overload)*)

ExperimentFragmentAnalysis[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:= Module[
	{
		(*built in*)
		outputSpecification,
		output,
		gatherTests,
		validSamplePreparationResult,
		mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,
		updatedSimulation,
		safeOps,
		safeOpsTests,
		validLengths,
		validLengthTests,
		performSimulationQ,
		templatedOptions,
		templateTests,
		inheritedOptions,
		expandedSafeOps,
		fragmentAnalysisOptionsAssociation,
		upload,
		confirm,
		canaryBranch,
		fastTrack,
		parentProtocol,
		cache,
		cacheBall,
		resolvedOptionsResult,
		simulatedProtocol,
		simulation,
		resolvedOptions,
		resolvedOptionsTests,
		collapsedResolvedOptions,
		optionsResolverOnly,
		returnEarlyBecauseOptionsResolverOnly,
		returnEarlyBecauseFailuresQ,
		protocolObject,
		resourcePackets,
		resourcePacketTests,
		listedSamplesNamed,
		listedOptionsNamed,
		mySamplesWithPreparedSamplesNamed,
		safeOpsNamed,
		myOptionsWithPreparedSamplesNamed,
		
		(*suppliedOption*)
		suppliedPrimaryCapillaryFlushSolution,
		suppliedSecondaryCapillaryFlushSolution,
		suppliedTertiaryCapillaryFlushSolution,
		suppliedAnalysisMethod,
		suppliedBlank,
		suppliedLadder,
		suppliedSeparationGel,
		suppliedDye,
		suppliedConditioningSolution,
		suppliedPreMarkerRinseBuffer,
		suppliedPreSampleRinseBuffer,
		suppliedSampleDiluent,
		suppliedSampleLoadingBuffer,
		suppliedLadderLoadingBuffer,
		suppliedSampleRunningBuffer,
		suppliedLadderRunningBuffer,
		suppliedBlankRunningBuffer,
		suppliedPreparedRunningBufferPlate,
		suppliedPreparedMarkerPlate,
		suppliedSampleMarker,
		suppliedLadderMarker,
		suppliedBlankMarker,
		suppliedCapillaryArray,
		suppliedInstrument,
		suppliedAliquotContainer,
		suppliedNumberOfReplicates,
		
		(*download Objects and Fields*)
		possibleAnalysisMethodObjects,
		analysisMethodObjects,
		analysisMethodFields,
		primaryCapillaryFlushSolutionObjects,
		primaryCapillaryFlushSolutionFields,
		secondaryCapillaryFlushSolutionObjects,
		secondaryCapillaryFlushSolutionFields,
		tertiaryCapillaryFlushSolutionObjects,
		tertiaryCapillaryFlushSolutionFields,
		blankObjects,
		blankFields,
		preparedRunningBufferPlateObject,
		sampleRunningBufferObjects,
		sampleRunningBufferFields,
		ladderRunningBufferObjects,
		ladderRunningBufferFields,
		blankRunningBufferObjects,
		blankRunningBufferFields,
		preparedMarkerPlateObject,
		sampleMarkerObjects,
		sampleMarkerFields,
		ladderMarkerObjects,
		ladderMarkerFields,
		blankMarkerObjects,
		blankMarkerFields,
		separationGelObjects,
		separationGelFields,
		dyeObjects,
		dyeFields,
		conditioningSolutionObjects,
		conditioningSolutionFields,
		preMarkerRinseBufferObjects,
		preMarkerRinseBufferFields,
		preSampleRinseBufferObjects,
		preSampleRinseBufferFields,
		ladderObjects,
		ladderFields,
		ladderLoadingBufferObjects,
		ladderLoadingBufferFields,
		sampleDiluentObjects,
		sampleDiluentFields,
		sampleLoadingBufferObjects,
		sampleLoadingBufferFields,
		possibleCapillaryArrayModels,
		capillaryArrayObjects,
		capillaryArrayFields,
		possibleInstrumentModels,
		instrumentObjects,
		instrumentFields,
		aliquotContainerObjects,
		aliquotContainerFields,
		roboticCompatibleContainerModels,
		roboticCompatibleContainerFields,
		mySamplePackets,
		analysisMethodPackets,
		conditioningSolutionPacket,
		primaryCapillaryFlushSolutionPacket,
		secondaryCapillaryFlushSolutionPacket,
		tertiaryCapillaryFlushSolutionPacket,
		separationGelPacket,
		dyePacket,
		preparedRunningBufferPlatePacket,
		sampleRunningBufferPacket,
		ladderRunningBufferPacket,
		blankRunningBufferPacket,
		preparedMarkerPlatePacket,
		sampleMarkerPacket,
		ladderMarkerPacket,
		blankMarkerPacket,
		preMarkerRinseBufferPacket,
		preSampleRinseBufferPacket,
		ladderPacket,
		blankPacket,
		sampleLoadingBufferPacket,
		ladderLoadingBufferPacket,
		sampleDiluentPacket,
		capillaryArrayPacket,
		instrumentPacket,
		aliquotContainersPacket,
		roboticCompatibleContainersPacket,
		
		
		downloadedStuff,
		
		(*others*)
		estimatedRunTime
	},
	
	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];
	
	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	
	(* Remove temporal links. *)
	{listedSamplesNamed, listedOptionsNamed}=removeLinks[ToList[mySamples], ToList[myOptions]];
	
	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentFragmentAnalysis,
			listedSamplesNamed,
			listedOptionsNamed
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];
	
	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If	[gatherTests,
		SafeOptions[ExperimentFragmentAnalysis,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentFragmentAnalysis,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];
	
	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed,Simulation -> updatedSimulation];
	
	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation->Null
		}]
	];
	
	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentFragmentAnalysis,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentFragmentAnalysis,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	
	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation->Null
		}]
	];
	
	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentFragmentAnalysis,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentFragmentAnalysis,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation->Null
		}]
	];
	
	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentFragmentAnalysis,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];
    
	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	fragmentAnalysisOptionsAssociation=Association[expandedSafeOps];

	(*get supplied option values (if any) for those that may require a download and assign as suppliedOptionBlah*)
	{
		suppliedPrimaryCapillaryFlushSolution,
		suppliedSecondaryCapillaryFlushSolution,
		suppliedTertiaryCapillaryFlushSolution,
		suppliedAnalysisMethod,
		suppliedBlank,
		suppliedLadder,
		suppliedSeparationGel,
		suppliedDye,
		suppliedConditioningSolution,
		suppliedPreMarkerRinseBuffer,
		suppliedPreSampleRinseBuffer,
		suppliedSampleDiluent,
		suppliedSampleLoadingBuffer,
		suppliedLadderLoadingBuffer,
		suppliedPreparedRunningBufferPlate,
		suppliedPreparedMarkerPlate,
		suppliedSampleRunningBuffer,
		suppliedLadderRunningBuffer,
		suppliedBlankRunningBuffer,
		suppliedSampleMarker,
		suppliedLadderMarker,
		suppliedBlankMarker,
		suppliedCapillaryArray,
		suppliedInstrument,
		suppliedAliquotContainer,
		suppliedNumberOfReplicates
	}=Lookup[
		fragmentAnalysisOptionsAssociation,
		{
			PrimaryCapillaryFlushSolution,
			SecondaryCapillaryFlushSolution,
			TertiaryCapillaryFlushSolution,
			AnalysisMethod,
			Blank,
			Ladder,
			SeparationGel,
			Dye,
			ConditioningSolution,
			PreMarkerRinseBuffer,
			PreSampleRinseBuffer,
			SampleDiluent,
			SampleLoadingBuffer,
			LadderLoadingBuffer,
			PreparedRunningBufferPlate,
			PreparedMarkerPlate,
			SampleRunningBufferSolution,
			LadderRunningBufferSolution,
			BlankRunningBufferSolution,
			SampleMarker,
			LadderMarker,
			BlankMarker,
			CapillaryArray,
			Instrument,
			AliquotContainer,
			NumberOfReplicates
		}
	];
	
	(*AnalysisMethod Download - determine Object and Fields to download based on the supplied option value*)
	possibleAnalysisMethodObjects = Search[Object[Method, FragmentAnalysis], AnalysisMethodAuthor == Manufacturer];
	analysisMethodObjects = If[MatchQ[suppliedAnalysisMethod, Automatic],
		possibleAnalysisMethodObjects,
		ToList[suppliedAnalysisMethod]
	];
	
	analysisMethodFields = {Packet[
		AnalysisMethodAuthor,
		AnalysisStrategy,
		Blank,
		BlankMarker,
		BlankRunningBuffer,
		CapillaryArrayLength,
		CapillaryEquilibration,
		ConditioningSolution,
		DeveloperObject,
		Dye,
		EquilibrationTime,
		EquilibrationVoltage,
		ID,
		Ladder,
		LadderLoadingBuffer,
		LadderLoadingBufferVolume,
		LadderMarker,
		LadderRunningBuffer,
		LadderVolume,
		LadderLoading,
		MarkerInjection,
		MarkerInjectionTime,
		MarkerInjectionVoltage,
		MaxTargetMassConcentration,
		MaxTargetReadLength,
		MinTargetMassConcentration,
		MinTargetReadLength,
		Name,
		NumberOfPreMarkerRinses,
		NumberOfPreSampleRinses,
		Object,
		PreMarkerRinse,
		PreMarkerRinseBuffer,
		PreSampleRinse,
		PreSampleRinseBuffer,
		SampleInjectionTime,
		SampleInjectionVoltage,
		SampleLoadingBuffer,
		SampleLoadingBufferVolume,
		SampleMarker,
		SampleRunningBuffer,
		SeparationGel,
		SeparationTime,
		SeparationVoltage,
		TargetAnalyteType,
		TargetSampleVolume,
		Type
	]};
	
	(*Download - determine Object and Fields to download based on the supplied option value*)
	{
		{primaryCapillaryFlushSolutionObjects,primaryCapillaryFlushSolutionFields},
		{secondaryCapillaryFlushSolutionObjects,secondaryCapillaryFlushSolutionFields},
		{tertiaryCapillaryFlushSolutionObjects,tertiaryCapillaryFlushSolutionFields},
		{separationGelObjects,separationGelFields},
		{dyeObjects,dyeFields},
		{conditioningSolutionObjects,conditioningSolutionFields},
		{preMarkerRinseBufferObjects,preMarkerRinseBufferFields},
		{preSampleRinseBufferObjects,preSampleRinseBufferFields},
		{sampleRunningBufferObjects,sampleRunningBufferFields},
		{blankObjects,blankFields},
		{ladderRunningBufferObjects,ladderRunningBufferFields},
		{blankRunningBufferObjects,blankRunningBufferFields},
		{sampleMarkerObjects,sampleMarkerFields},
		{ladderMarkerObjects,ladderMarkerFields},
		{blankMarkerObjects,blankMarkerFields},
		{ladderObjects,ladderFields},
		{ladderLoadingBufferObjects,ladderLoadingBufferFields},
		{sampleDiluentObjects,sampleDiluentFields},
		{sampleLoadingBufferObjects,sampleLoadingBufferFields}
		
	}=Map[
		If[MemberQ[ToList[#], ObjectP[Object[Sample]]],
			{Cases[ToList[#], ObjectP[Object[Sample]]],{Packet[Model]}},
			{{}, {}}
		]&,
		{
			suppliedPrimaryCapillaryFlushSolution,
			suppliedSecondaryCapillaryFlushSolution,
			suppliedTertiaryCapillaryFlushSolution,
			suppliedSeparationGel,
			suppliedDye,
			suppliedConditioningSolution,
			suppliedPreMarkerRinseBuffer,
			suppliedPreSampleRinseBuffer,
			suppliedSampleRunningBuffer,
			suppliedBlank,
			suppliedLadderRunningBuffer,
			suppliedBlankRunningBuffer,
			suppliedSampleMarker,
			suppliedLadderMarker,
			suppliedBlankMarker,
			suppliedLadder,
			suppliedLadderLoadingBuffer,
			suppliedSampleDiluent,
			suppliedSampleLoadingBuffer
		}
	];
	
	(*PreparedMarkerPlate*)
	preparedMarkerPlateObject = If[MatchQ[suppliedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]],
		suppliedPreparedMarkerPlate,
		Null
	];
	
	(*RunningBuffer*)
	(*PreparedRunningBufferPlate*)
	preparedRunningBufferPlateObject = If[MatchQ[suppliedPreparedRunningBufferPlate, ObjectP[Object[Container, Plate]]],
		suppliedPreparedRunningBufferPlate,
		Null
	];
	
	(*CapillaryArray Download*)
	possibleCapillaryArrayModels = Search[Model[Part, CapillaryArray]];
	
	capillaryArrayObjects = If[MatchQ[suppliedCapillaryArray, Automatic],
		ToList[possibleCapillaryArrayModels],
		ToList[suppliedCapillaryArray]
	];
	
	capillaryArrayFields =
		Which[
			(*If Automatic, get information from selection of Models*)
			MatchQ[suppliedCapillaryArray, Automatic],
			{Packet[NumberOfCapillaries, CapillaryArrayLength, CompatibleInstrument, Objects]},
			
			(* If CapillaryArray is an object, download fields from the Model, as well as fields from Object*)
			MatchQ[suppliedCapillaryArray, ObjectP[Object[Part, CapillaryArray]]],
			{
				Packet[Model[{NumberOfCapillaries, CapillaryArrayLength, CompatibleInstrument}]],
				Packet[Model, NumberOfCapillaries, CapillaryArrayLength, Instrument]
			},
			
			(* If instrument is a Model, download fields*)
			MatchQ[suppliedCapillaryArray, ObjectP[Model[Part, CapillaryArray]]],
			{Packet[NumberOfCapillaries, CapillaryArrayLength, CompatibleInstrument]}
		];
	
	(*Instrument Download*)
	possibleInstrumentModels = Search[Model[Instrument, FragmentAnalyzer]];
	
	instrumentObjects = If[MatchQ[suppliedInstrument, Automatic],
		ToList[possibleInstrumentModels],
		ToList[suppliedInstrument]
	];
	
	instrumentFields = Which[
		(*If Automatic, get information from selection of Models*)
		MatchQ[suppliedInstrument, Automatic],
		{Packet[SupportedNumberOfCapillaries, SupportedCapillaryArrayLength, SupportedCapillaryArray, Objects]},
		
		MatchQ[suppliedInstrument, ObjectP[Object[Instrument, FragmentAnalyzer]]],
		{
			Packet[Model[{SupportedNumberOfCapillaries, SupportedCapillaryArrayLength, SupportedCapillaryArray}]],
			Packet[Model, SupportedNumberOfCapillaries, SupportedCapillaryArrayLength, CapillaryArray]
		},
		
		(* If instrument is a Model, download fields*)
		MatchQ[suppliedInstrument, ObjectP[Model[Instrument, FragmentAnalyzer]]],
		{Packet[SupportedNumberOfCapillaries, SupportedCapillaryArrayLength, SupportedCapillaryArray]}
	];
	
	(*AliquotContainer Download*)
	aliquotContainerObjects = Cases[ToList[suppliedAliquotContainer], ObjectP[Object[Sample]]];
	aliquotContainerFields = {Packet[Model]};
	
	(*Liquid-Handler compatible Models*)
	roboticCompatibleContainerModels = hamiltonAliquotContainers["Memoization"];
	roboticCompatibleContainerFields = {Packet[MinVolume, MaxVolume]};
	
	(* Download all the things *)
	{
		(*01*)mySamplePackets,
		(*02*)analysisMethodPackets,
		(*03*)conditioningSolutionPacket,
		(*04*)primaryCapillaryFlushSolutionPacket,
		(*05*)secondaryCapillaryFlushSolutionPacket,
		(*06*)tertiaryCapillaryFlushSolutionPacket,
		(*07*)separationGelPacket,
		(*08*)dyePacket,
		(*09*)preparedRunningBufferPlatePacket,
		(*10*)sampleRunningBufferPacket,
		(*11*)ladderRunningBufferPacket,
		(*12*)blankRunningBufferPacket,
		(*13*)preparedMarkerPlatePacket,
		(*14*)sampleMarkerPacket,
		(*15*)ladderMarkerPacket,
		(*16*)blankMarkerPacket,
		(*17*)preMarkerRinseBufferPacket,
		(*18*)preSampleRinseBufferPacket,
		(*19*)ladderPacket,
		(*20*)blankPacket,
		(*21*)sampleLoadingBufferPacket,
		(*22*)ladderLoadingBufferPacket,
		(*23*)sampleDiluentPacket,
		(*24*)capillaryArrayPacket,
		(*25*)instrumentPacket,
		(*26*)aliquotContainersPacket,
		(*27*)roboticCompatibleContainersPacket
	}
		= Quiet[Download[
		(*Inputs*)
		{
			(*01*)mySamplesWithPreparedSamples,
			(*02*)analysisMethodObjects,
			(*03*)conditioningSolutionObjects,
			(*04*)primaryCapillaryFlushSolutionObjects,
			(*05*)secondaryCapillaryFlushSolutionObjects,
			(*06*)tertiaryCapillaryFlushSolutionObjects,
			(*07*)separationGelObjects,
			(*08*)dyeObjects,
			(*09*)ToList[preparedRunningBufferPlateObject],
			(*10*)sampleRunningBufferObjects,
			(*11*)ladderRunningBufferObjects,
			(*12*)blankRunningBufferObjects,
			(*13*)ToList[preparedMarkerPlateObject],
			(*14*)sampleMarkerObjects,
			(*15*)ladderMarkerObjects,
			(*16*)blankMarkerObjects,
			(*17*)preMarkerRinseBufferObjects,
			(*18*)preSampleRinseBufferObjects,
			(*19*)ladderObjects,
			(*20*)blankObjects,
			(*21*)sampleLoadingBufferObjects,
			(*22*)ladderLoadingBufferObjects,
			(*23*)sampleDiluentObjects,
			(*24*)capillaryArrayObjects,
			(*25*)instrumentObjects,
			(*26*)aliquotContainerObjects,
			(*27*)roboticCompatibleContainerModels
		},
		{
			(*1*){
				Packet[Name, Status, Composition, Container, Well,Volume,Position],
				Packet[Composition[[All, 2]][{PolymerType, Molecule, MolecularWeight}]],
				Packet[Container[{Model, Contents}]],
				Packet[Container[Model][{MinVolume, MaxVolume}]]
			},
			(*2*)analysisMethodFields,
			(*3*)conditioningSolutionFields,
			(*4*)primaryCapillaryFlushSolutionFields,
			(*5*)secondaryCapillaryFlushSolutionFields,
			(*6*)tertiaryCapillaryFlushSolutionFields,
			(*7*)separationGelFields,
			(*8*)dyeFields,
			(*9*){
				Packet[Model, Contents],
				Packet[Contents[[All, 2]][{Model, Volume}]]
			},
			(*10*)sampleRunningBufferFields,
			(*11*)ladderRunningBufferFields,
			(*12*)blankRunningBufferFields,
			(*13*){
				Packet[Model, Contents],
				Packet[Contents[[All, 2]][{Model, Volume}]]
			},
			(*14*)sampleMarkerFields,
			(*15*)ladderMarkerFields,
			(*16*)blankMarkerFields,
			(*17*)preMarkerRinseBufferFields,
			(*18*)preSampleRinseBufferFields,
			(*19*)ladderFields,
			(*20*)blankFields,
			(*21*)sampleLoadingBufferFields,
			(*22*)ladderLoadingBufferFields,
			(*23*)sampleDiluentFields,
			(*24*)capillaryArrayFields,
			(*25*)instrumentFields,
			(*26*)aliquotContainerFields,
			(*27*)roboticCompatibleContainerFields
		},
		Cache -> cache,
		Simulation -> updatedSimulation,
		Date -> Now
	], {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}];
	
	downloadedStuff={
		mySamplePackets,
		analysisMethodPackets,
		conditioningSolutionPacket,
		primaryCapillaryFlushSolutionPacket,
		secondaryCapillaryFlushSolutionPacket,
		tertiaryCapillaryFlushSolutionPacket,
		separationGelPacket,
		dyePacket,
		preparedRunningBufferPlatePacket,
		sampleRunningBufferPacket,
		ladderRunningBufferPacket,
		blankRunningBufferPacket,
		preparedMarkerPlatePacket,
		sampleMarkerPacket,
		ladderMarkerPacket,
		blankMarkerPacket,
		preMarkerRinseBufferPacket,
		preSampleRinseBufferPacket,
		ladderPacket,
		blankPacket,
		sampleLoadingBufferPacket,
		ladderLoadingBufferPacket,
		sampleDiluentPacket,
		capillaryArrayPacket,
		instrumentPacket,
		aliquotContainersPacket,
		roboticCompatibleContainersPacket
	};
	
	(* get all the cache and put it together *)
	cacheBall=FlattenCachePackets[{cache,Cases[Flatten[downloadedStuff], PacketP[]]}];
	
	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentFragmentAnalysisOptions[
			mySamplesWithPreparedSamples,
			expandedSafeOps,
			Cache->cacheBall,
			Simulation->updatedSimulation,
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
				resolveExperimentFragmentAnalysisOptions[
					mySamplesWithPreparedSamples,
					expandedSafeOps,
					Cache->cacheBall,
					Simulation->updatedSimulation
				],
				{}
			},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];
	
	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentFragmentAnalysis,
		resolvedOptions,
		Ignore->ToList[listedOptionsNamed],
		Messages->False
	];
	
	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];
	
	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed],
		True,
		
		gatherTests,
		Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		
		True,
		False
	];
	
	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ = MemberQ[output, Simulation];
	
	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> RemoveHiddenOptions[ExperimentFragmentAnalysis, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];
	
	(* Build packets with resources *)
	{resourcePackets, resourcePacketTests} = Which[
		returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
		{$Failed, {}},

		gatherTests,
		fragmentAnalysisResourcePackets[
			mySamplesWithPreparedSamples,
			templatedOptions,
			resolvedOptions,
			collapsedResolvedOptions,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests}
		],

		True,
		{
			fragmentAnalysisResourcePackets[
				mySamplesWithPreparedSamples,
				templatedOptions,
				resolvedOptions,
				collapsedResolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation,
				Output -> Result
			],
			{}
		}
	];
	

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentFragmentAnalysis[
			resourcePackets,
			ToList[mySamplesWithPreparedSamples],
			resolvedOptions,
			Cache->cacheBall,
			Simulation->updatedSimulation
		],
		{Null, updatedSimulation}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentFragmentAnalysis,collapsedResolvedOptions],
			Preview -> Null,
			Simulation->simulation
		}]
	];
	
	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
	protocolObject = Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[resourcePackets,$Failed] || MatchQ[resolvedOptionsResult,$Failed],
			$Failed,
		
		(* Otherwise, upload a real protocol that's ready to be run. *)
		True,
			UploadProtocol[
				resourcePackets,
				Upload->Lookup[safeOps,Upload],
				Confirm->Lookup[safeOps,Confirm],
				CanaryBranch->Lookup[safeOps,CanaryBranch],
				ParentProtocol->Lookup[safeOps,ParentProtocol],
				ConstellationMessage->Object[Protocol,FragmentAnalysis],
				Simulation->simulation
			]
	];
	
	estimatedRunTime = 4 Hour;
	
	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentFragmentAnalysis,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedRunTime
	}
];

(* Note: The container overload should come after the sample overload. *)
ExperimentFragmentAnalysis[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{
		listedContainers,
		listedOptions,
		outputSpecification,
		output,
		gatherTests,
		validSamplePreparationResult,
		mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,
		containerToSampleSimulation,
		updatedSimulation,
		containerToSampleResult,
		containerToSampleOutput,
		samples,
		sampleOptions,
		containerToSampleTests,
		sampleOptionsAssociation,
		preparedPlate,
		preparedPlateLadderOption,
		preparedPlateBlankOption,
		ladderWells,
		blankWells,
		sampleWells,
		wellContents,
		updatedSamples
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* pass listed containers and options. *)
	{listedContainers, listedOptions}={ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentFragmentAnalysis,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentFragmentAnalysis,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentFragmentAnalysis,
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
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation->Null,
			InvalidInputs -> {},
			InvalidOptions -> {}
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(*If PreparedPlate is True, list of samples are updated by removing the contents of the wells of the plate assigned as Ladder or Blank*)

		sampleOptionsAssociation=Association[sampleOptions];

		preparedPlate=Lookup[sampleOptionsAssociation,PreparedPlate];

		(*If PreparedPlate is True and user specified the Ladder and Blank options correctly, these should be a WellPositionP or a list of WellPositionP; otherwise, an error in the resolver is thrown*)
		preparedPlateLadderOption=If[MatchQ[preparedPlate,True],
			Lookup[sampleOptionsAssociation,Ladder,Automatic],
			Null
		];
		preparedPlateBlankOption=If[MatchQ[preparedPlate,True],
			Lookup[sampleOptionsAssociation,Blank],
			Null
		];

		ladderWells=Which[
			(* If resolvedPreparedPlate is True and Ladder is Automatic, the H12 position is automatically resolved as a Ladder *)
			MatchQ[preparedPlate,True]&&MatchQ[preparedPlateLadderOption,Automatic],
			{"H12"},

			MatchQ[preparedPlateLadderOption,WellPositionP|{WellPositionP..}],
			ToList[preparedPlateLadderOption],

			True,
			Null
		];

		blankWells=If[MatchQ[preparedPlateBlankOption,WellPositionP|{WellPositionP..}],
			ToList[preparedPlateBlankOption],
			Null
		];

		sampleWells=If[MatchQ[preparedPlate,True],
			Select[Flatten[AllWells[]], ! MemberQ[Flatten[{ladderWells,blankWells}], #] &],
			Null
		];

		wellContents=If[MatchQ[preparedPlate,True],
			Download[samples,{Position,Object},Simulation->updatedSimulation],
			Null
		];

		updatedSamples=If[MatchQ[preparedPlate,True],
			Cases[wellContents,{Alternatives@@sampleWells,_}][[All,2]],
			samples
		];
		(* Call our main function with our samples and converted options. *)
		ExperimentFragmentAnalysis[updatedSamples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];


(* ::Subsubsection:: *)
(*resolveExperimentFragmentAnalysisOptions*)

DefineOptions[
	resolveExperimentFragmentAnalysisOptions,
	Options:>{HelperOutputOption,SimulationOption,CacheOption}
];

resolveExperimentFragmentAnalysisOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentFragmentAnalysisOptions]]:= Module[
	{
		(*built-in*)
		outputSpecification,
		output,
		gatherTests,
		messages,
		notInEngine,
		cache,
		simulation,
		samplePrepOptions,
		fragmentAnalysisOptions,
		simulatedSamples,
		resolvedSamplePrepOptions,
		updatedSimulation,
		resolvedPostProcessingOptions,
		samplePrepTests,
		cacheBall,
		fragmentAnalysisOptionsAssociation,
		optionPrecisions,
		optionPrecisionTests,
		roundedExperimentFragmentAnalysisOptions,
		roundedExperimentFragmentAnalysisOptionsList,
		mapThreadFriendlyOptions,
		allOptionsRounded,
		resolvedOptions,
		allTests,
		(*suppliedOptions*)
		(*suppliedOptions that need to be downloaded*)
		suppliedPreparedPlate,
		suppliedPrimaryCapillaryFlushSolution,
		suppliedSecondaryCapillaryFlushSolution,
		suppliedTertiaryCapillaryFlushSolution,
		suppliedAnalysisMethod,
		suppliedBlank,
		suppliedSeparationGel,
		suppliedDye,
		suppliedConditioningSolution,
		suppliedPreMarkerRinseBuffer,
		suppliedPreSampleRinseBuffer,
		suppliedSampleDiluent,
		suppliedLadder,
		suppliedSampleLoadingBuffer,
		suppliedLadderLoadingBuffer,
		suppliedPreparedRunningBufferPlate,
		suppliedSampleRunningBuffer,
		suppliedLadderRunningBuffer,
		suppliedBlankRunningBuffer,
		suppliedPreparedMarkerPlate,
		suppliedSampleMarker,
		suppliedLadderMarker,
		suppliedBlankMarker,
		suppliedCapillaryArray,
		suppliedInstrument,
		suppliedAliquot,
		suppliedAliquotContainer,
		suppliedAliquotAmount,
		suppliedConsolidateAliquots,
		resolvedConsolidateAliquots,
		(*suppliedOptions that need to be rounded*)
		suppliedSampleVolume,
		suppliedLadderVolume,
		suppliedSampleDiluentVolume,
		suppliedSampleLoadingBufferVolume,
		suppliedLadderLoadingBufferVolume,
		suppliedPrimaryCapillaryFlushPressure,
		suppliedPrimaryCapillaryFlushFlowRate,
		suppliedPrimaryCapillaryFlushTime,
		suppliedSecondaryCapillaryFlushPressure,
		suppliedSecondaryCapillaryFlushFlowRate,
		suppliedSecondaryCapillaryFlushTime,
		suppliedTertiaryCapillaryFlushPressure,
		suppliedTertiaryCapillaryFlushFlowRate,
		suppliedTertiaryCapillaryFlushTime,
		suppliedEquilibrationVoltage,
		suppliedEquilibrationTime,
		suppliedMarkerInjectionTime,
		suppliedMarkerInjectionVoltage,
		suppliedSampleInjectionTime,
		suppliedSampleInjectionVoltage,
		suppliedSeparationTime,
		suppliedSeparationVoltage,

		(*other suppliedOptions*)
		suppliedMaxNumberOfRetries,
		suppliedAnalysisMethodName,
		suppliedCapillaryFlush,
		suppliedNumberOfCapillaryFlushes,
		suppliedAnalysisStrategy,
		suppliedCapillaryArrayLength,
		suppliedSampleAnalyteType,
		suppliedMinReadLength,
		suppliedMaxReadLength,
		suppliedCapillaryEquilibration,
		suppliedPreMarkerRinse,
		suppliedNumberOfPreMarkerRinses,
		suppliedMarkerInjection,
		suppliedPreSampleRinse,
		suppliedNumberOfPreSampleRinses,
		suppliedSampleDilution,
		suppliedRunningBufferPlateStorageCondition,
		suppliedPreMarkerRinseBufferPlateStorageCondition,
		suppliedMarkerPlateStorageCondition,
		suppliedPreSampleRinseBufferPlateStorageCondition,
		suppliedNumberOfCapillaries,
		suppliedNumberOfReplicates,

		(*Download Objects,Fields,Packets,FastAssoc*)
		invalidInputs,
		invalidOptions,
		resolvedAliquotOptions,
		aliquotTests,
		discardedSamplePackets,
		discardedInvalidInputs,
		fastAssoc,
		
		(*Resolved Options*)
		resolvedAnalysisMethodName,
		resolvedMaxNumberOfRetries,
		resolvedPreparedPlate,
		resolvedCapillaryArrayLength,
		resolvedAnalysisStrategy,
		resolvedSampleAnalyteTypes,
		resolvedMinReadLength,
		resolvedMaxReadLength,
		resolvedSampleAnalysisMethod,
		resolvedAnalysisMethod,
		resolvedBlank,
		listedResolvedBlank,
		resolvedSeparationGel,
		resolvedDye,
		resolvedConditioningSolution,
		resolvedCapillaryFlush,
		resolvedNumberOfCapillaryFlushes,
		resolvedPrimaryCapillaryFlushSolution,
		resolvedPrimaryCapillaryFlushPressure,
		resolvedPrimaryCapillaryFlushFlowRate,
		resolvedPrimaryCapillaryFlushTime,
		resolvedSecondaryCapillaryFlushSolution,
		resolvedSecondaryCapillaryFlushPressure,
		resolvedSecondaryCapillaryFlushFlowRate,
		resolvedSecondaryCapillaryFlushTime,
		resolvedTertiaryCapillaryFlushSolution,
		resolvedTertiaryCapillaryFlushPressure,
		resolvedTertiaryCapillaryFlushFlowRate,
		resolvedTertiaryCapillaryFlushTime,
		resolvedCapillaryEquilibration,
		resolvedEquilibrationVoltage,
		resolvedEquilibrationTime,
		resolvedPreMarkerRinse,
		resolvedNumberOfPreMarkerRinses,
		resolvedPreMarkerRinseBuffer,
		resolvedMarkerInjection,
		resolvedMarkerInjectionTime,
		resolvedMarkerInjectionVoltage,
		resolvedPreSampleRinse,
		resolvedNumberOfPreSampleRinses,
		resolvedPreSampleRinseBuffer,
		resolvedSampleInjectionTime,
		resolvedSampleInjectionVoltage,
		resolvedSeparationTime,
		resolvedSeparationVoltage,
		resolvedLadder,
		resolvedLadderVolume,
		resolvedLadderLoadingBuffer,
		resolvedLadderLoadingBufferVolume,
		resolvedLadderRunningBuffer,
		resolvedLadderMarker,
		mapResolvedLadderVolume,
		mapResolvedLadderLoadingBuffer,
		mapResolvedLadderLoadingBufferVolume,
		mapResolvedLadderRunningBuffer,
		mapResolvedLadderMarker,
		resolvedBlankRunningBuffer,
		resolvedBlankMarker,
		mapResolvedBlankRunningBuffer,
		mapResolvedBlankMarker,
		resolvedBlankPreparedPlateMismatchError,
		resolvedBlankRunningBufferMismatchError,
		resolvedBlankMarkerMismatchError,
		resolvedAnalysisMethodBlankMismatchWarning,
		resolvedAnalysisMethodBlankOptionsMismatchList,
		resolvedAnalysisMethodBlankOptionsMismatchWarning,
		resolvedPreparedBlankRunningBufferMismatchCheck,
		resolvedPreparedBlankMarkerMismatchCheck,
		resolvedPreparedRunningBufferPlate,
		resolvedPreparedRunningBufferPlateModel,
		resolvedPreparedMarkerPlateModel,
		resolvedPreparedMarkerPlate,
		resolvedRunningBufferPlateStorageCondition,
		resolvedPreMarkerRinseBufferPlateStorageCondition,
		resolvedPreSampleRinseBufferPlateStorageCondition,
		resolvedSampleDilution,
		resolvedSampleDiluent,
		resolvedSampleVolume,
		resolvedSampleDiluentVolume,
		resolvedSampleLoadingBuffer,
		resolvedSampleLoadingBufferVolume,
		resolvedSampleRunningBuffer,
		resolvedSampleMarker,
		resolvedNumberOfCapillaries,
		resolvedCapillaryArray,
		resolvedInstrument,
		resolvedMarkerPlateStorageCondition,
		resolvedAliquot,
		ladderWells,
		blankWells,
		sampleWells,
		(*Warnings and Errors*)
		validNameError,
		resolvedCantDetermineSampleAnalyteTypeWarning,
		sampleAnalyteTypeAnalysisMethodMismatchWarnings,
		sampleAnalyteTypeAnalysisMethodMismatchSamples,
		resolvedCantDetermineMinReadLengthWarning,
		resolvedCantDetermineMaxReadLengthWarning,
		cantDetermineSampleAnalyteTypeSamples,
		cantDetermineReadLengthSamples,
		analysisMethodMismatch,
		analysisMethodMismatchSamples,
		primaryCapillaryFlushMismatchErrors,
		secondaryCapillaryFlushMismatchErrors,
		tertiaryCapillaryFlushMismatchErrors,
		analysisMethodObjectsOptionsMismatchList,
		analysisMethodNonObjectsOptionsMismatchWarnings,
		analysisMethodNonObjectsOptionsMismatchList,
		analysisMethodOptionsMismatchList,
		analysisMethodAnalysisStrategy,
		analysisMethodAnalysisStrategyMismatchWarning,
		capillaryEquilibrationMismatchErrors,
		preMarkerRinseMismatchErrors,
		markerInjectionMismatchErrors,
		markerInjectionPreparedMarkerPlateMismatchError,
		preSampleRinseMismatchErrors,
		resolvedLadderPreparedPlateMismatchError,
		resolvedLadderOptionsPreparedPlateErrors,
		ladderOptionsPreparedPlateMismatchTests,
		resolvedLadderVolumeMismatchError,
		resolvedLadderLoadingBufferMismatchError,
		resolvedLadderLoadingBufferVolumeMismatchError,
		resolvedLadderRunningBufferMismatchError,
		resolvedLadderMarkerMismatchError,
		resolvedAnalysisMethodLadderMismatchWarning,
		resolvedLadderOptionsPreparedPlateMismatchOptions,
		resolvedAnalysisMethodLadderOptionsMismatchList,
		resolvedAnalysisMethodLadderOptionsMismatchWarning,
		resolvedSampleOptionsPreparedPlateMismatchOptions,
		resolvedSampleOptionsPreparedPlateError,
		resolvedSampleVolumeErrors,
		resolvedSampleLoadingBufferVolumeMismatchError,
		resolvedAnalysisMethodSampleOptionsMismatchList,
		resolvedAnalysisMethodSampleOptionsMismatchWarning,
		resolvedTotalSampleSolutionVolume,
		resolvedMaxSampleVolumeError,
		resolvedMaxSampleVolumeBadOptions,
		resolvedTotalLadderSolutionVolume,
		resolvedMaxLadderVolumeError,
		resolvedMaxLadderVolumeBadOptions,
		resolvedCantCalculateSampleVolumeWarning,
		resolvedCantCalculateSampleDiluentVolumeWarning,
		resolvedSampleDilutionMismatchOptions,
		resolvedSampleDilutionMismatchErrors,
		allOrNothingMarkerError,
		allOrNothingRunningBufferError,
		tooManySolutionsForInjectionError,
		notEnoughSolutionsForInjectionError,
		preparedPlateAliquotMismatchError,
		duplicateWellsError,
		plateModelError,
		preparedRunningBufferPlateModelError,
		preparedMarkerPlateModelError,
		(*Tests*)
		discardedTests,
		tooManySamplesTests,
		capillaryFlushNumberOfCapillaryFlushesMismatchTests,
		primaryCapillaryFlushMismatchTests,
		secondaryCapillaryFlushMismatchTests,
		tertiaryCapillaryFlushMismatchTests,
		capillaryEquilibrationMismatchTests,
		preMarkerRinseMismatchTests,
		ladderPreparedPlateMismatchTests,
		preSampleRinseMismatchTests,
		sampleOptionsPreparedPlateMismatchTests,
		blankRunningBufferMismatchTests,
		blankMarkerMismatchTests,
		sampleVolumeErrorTests,
		sampleDilutionMismatchTests,
		sampleLoadingBufferVolumeMismatchTests,
		blankPreparedPlateMismatchTests,
		allOrNothingMarkerTests,
		notEnoughMarkerTests,
		notEnoughRunningBufferTests,
		allOrNothingRunningBufferTests,
		tooManySolutionsForInjectionTests,
		notEnoughSolutionsForInjectionTests,
		preparedPlateAliquotMismatchTests,
		assayVolumeSampleVolumeMismatchTests,
		plateModelTests,
		preparedRunningBufferPlateModelTests,
		preparedMarkerPlateModelTests,
		duplicateWellsTests,
		markerInjectionMismatchTests,
		markerInjectionPreparedPlateMismatchTest,
		(*Invalid Options*)
		analysisMethodNameInvalidOptions,
		capillaryFlushNumberOfCapillaryFlushesMismatchInvalidOptions,
		primaryCapillaryFlushMismatchInvalidOptions,
		secondaryCapillaryFlushMismatchInvalidOptions,
		tertiaryCapillaryFlushMismatchInvalidOptions,
		capillaryEquilibrationMismatchInvalidOptions,
		preMarkerRinseMismatchInvalidOptions,
		markerInjectionMismatchInvalidOptions,
		markerInjectionPreparedMarkerPlateMismatchInvalidOptions,
		preSampleRinseMismatchInvalidOptions,
		ladderPreparedPlateMismatchInvalidOptions,
		ladderVolumeMismatchInvalidOptions,
		ladderLoadingBufferMismatchInvalidOptions,
		sampleVolumeErrorInvalidOptions,
		sampleOptionsPreparedPlateMismatchInvalidOptions,
		sampleLoadingBufferVolumeMismatchInvalidOptions,
		blankRunningBufferMismatchInvalidOptions,
		blankMarkerMismatchInvalidOptions,
		ladderLoadingBufferVolumeMismatchInvalidOptions,
		maxLadderVolumeInvalidOptions,
		ladderRunningBufferMismatchInvalidOptions,
		ladderMarkerMismatchInvalidOptions,
		sampleDilutionMismatchInvalidOptions,
		maxSampleVolumeInvalidOptions,
		blankPreparedPlateMismatchInvalidOptions,
		allOrNothingMarkerInvalidOptions,
		notEnoughMarkerInvalidOptions,
		notEnoughRunningBufferInvalidOptions,
		allOrNothingRunningBufferInvalidOptions,
		tooManySolutionsForInjectionInvalidOptions,
		notEnoughSolutionsForInjectionInvalidOptions,
		preparedPlateAliquotMismatchInvalidOptions,
		duplicateWellsInvalidOptions,
		plateModelInvalidOptions,
		preparedRunningBufferPlateModelInvalidOptions,
		preparedMarkerPlateModelInvalidOptions,
		ladderOptionsPreparedPlateMismatchInvalidOptions,
		(*Others*)
		analysisMethodEquilibrationVoltage,
		analysisMethodEquilibrationTime,
		analysisMethodNumberOfPreMarkerRinses,
		analysisMethodMarkerInjectionTime,
		analysisMethodMarkerInjectionVoltage,
		analysisMethodNumberOfPreSampleRinses,
		analysisMethodPreMarkerRinse,
		analysisMethodPreMarkerRinseBuffer,
		analysisMethodPreSampleRinse,
		analysisMethodPreSampleRinseBuffer,
		analysisMethodBlank,
		analysisMethodLadder,
		ladderOptions,
		ladderOptionValues,
		ladderMapThreadFriendlyOptions,
		listedResolvedLadder,
		resolvedSampleAnalyteConcentration,
		analysisMethodOptionsCheckFunction,
		intNumberOfReplicates,
		numberOfSamples,
		numberOfLadders,
		numberOfBlanks,
		numberOfSolutionsForInjection,
		analysisMethodObjectsOptionsMismatchCheck,
		assignedWells,
		duplicatedWells,
		optionsWithDuplicatedWellCheck,
		markerList,
		runningBufferList,
		aliquotWarningMessage,
		allSampleContainers,
		uniqueSampleContainers,
		uniqueSampleContainerModels,
		preparedRunningBufferPlateContentsObjects,
		preparedLadderRunningBufferObjects,
		preparedMarkerPlateContentsObjects,
		preparedLadderMarkerObjects,
		preparedBlankRunningBufferObjects,
		preparedBlankMarkerObjects,
		blankOptions,
		blankOptionValues,
		blankMapThreadFriendlyOptions,
		preparedSampleRunningBufferObjects,
		preparedSampleMarkerObjects,
		resolvedPreparedLadderRunningBufferMismatchCheck,
		resolvedPreparedLadderMarkerMismatchCheck,
		preparedLadderRunningBufferPlateMismatchError,
		preparedRunningBufferPlateMismatchInvalidOptions,
		preparedMarkerPlateMismatchInvalidOptions,
		resolvedPreparedSampleRunningBufferMismatchCheck,
		resolvedPreparedSampleMarkerMismatchCheck,
		preparedSampleRunningBufferPlateMismatchError,
		preparedRunningBufferPlateIncompatibleOptionsList,
		preparedMarkerPlateIncompatibleOptionsList,
		preparedBlankRunningBufferPlateMismatchError,
		preparedLadderMarkerPlateMismatchError,
		preparedSampleMarkerPlateMismatchError,
		preparedBlankMarkerPlateMismatchError,
		roboticCompatibleContainerModels,
		suppliedAliquotContainerModels,
		resolvedRequiredAliquotContainers,
		resolvedRequiredAliquotAmounts,
		sampleContainers,
		sampleContainerModels,
		sampleToVolumeRules,
		mergedSampleToVolumeRules,
		mergedSampleToRequiredContainerRules,
		simulatedSamplePackets,
		validNameTest
	},
	
	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	
	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];
	
	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	
	(* Determine if we are throwing messages or not *)
	messages = Not[gatherTests];
	
	(* Determine if we are in Engine or not, in Engine we silence warnings *)
	notInEngine = Not[MatchQ[$ECLApplication, Engine]];
	
	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];
	
	(* Separate out our FragmentAnalysis options from our Sample Prep options. *)
	{samplePrepOptions, fragmentAnalysisOptions} = splitPrepOptions[myOptions];
	
	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentFragmentAnalysis, mySamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentFragmentAnalysis, mySamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];
	
	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	fragmentAnalysisOptionsAssociation = Association[fragmentAnalysisOptions];
	
	(*get supplied option values that may require download and set as suppliedBlah*)
	{
		suppliedPreparedPlate,
		suppliedPrimaryCapillaryFlushSolution,
		suppliedSecondaryCapillaryFlushSolution,
		suppliedTertiaryCapillaryFlushSolution,
		suppliedAnalysisMethod,
		suppliedBlank,
		suppliedSeparationGel,
		suppliedDye,
		suppliedConditioningSolution,
		suppliedPreMarkerRinseBuffer,
		suppliedPreSampleRinseBuffer,
		suppliedLadder,
		suppliedSampleDiluent,
		suppliedSampleLoadingBuffer,
		suppliedLadderLoadingBuffer,
		suppliedPreparedRunningBufferPlate,
		suppliedSampleRunningBuffer,
		suppliedLadderRunningBuffer,
		suppliedBlankRunningBuffer,
		suppliedPreparedMarkerPlate,
		suppliedSampleMarker,
		suppliedLadderMarker,
		suppliedBlankMarker,
		suppliedCapillaryArray,
		suppliedInstrument
	} = Lookup[
		fragmentAnalysisOptionsAssociation,
		{
			PreparedPlate,
			PrimaryCapillaryFlushSolution,
			SecondaryCapillaryFlushSolution,
			TertiaryCapillaryFlushSolution,
			AnalysisMethod,
			Blank,
			SeparationGel,
			Dye,
			ConditioningSolution,
			PreMarkerRinseBuffer,
			PreSampleRinseBuffer,
			Ladder,
			SampleDiluent,
			SampleLoadingBuffer,
			LadderLoadingBuffer,
			PreparedRunningBufferPlate,
			SampleRunningBuffer,
			LadderRunningBuffer,
			BlankRunningBuffer,
			PreparedMarkerPlate,
			SampleMarker,
			LadderMarker,
			BlankMarker,
			CapillaryArray,
			Instrument
		}
	];
	
	(*Get the supplied Aliquot, AliquotContainer and AliquotAmount values - we will need this to effectively resolveAliquotOptions*)
	{
		suppliedAliquot,
		suppliedAliquotContainer,
		suppliedAliquotAmount,
		suppliedConsolidateAliquots
	} = Lookup[
		samplePrepOptions,
		{
			Aliquot,
			AliquotContainer,
			AliquotAmount,
			ConsolidateAliquots
		}
	];
	
	(* Extract the packets that we need from our downloaded cache. *)
	simulatedSamplePackets = Quiet[
		Download[
			(*Inputs*)
			simulatedSamples,
			{
				Packet[Name, Status, Composition, Container, Well,Position],
				Packet[Composition[[All, 2]][{PolymerType, Molecule, MolecularWeight}]],
				Packet[Container[{Model, Contents}]],
				Packet[Container[Model][{MinVolume, MaxVolume}]]
			},
			Simulation -> updatedSimulation
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];
	
	(* Remember to download from simulatedSamples, using our simulatedCache *)
	(* Quiet[Download[..., Cache\[Rule]cache, Simulation\[Rule]updatedSimulation],Download::FieldDoesntExist] *)
	
	(*combine the cache together*)
	cacheBall = FlattenCachePackets[{
		cache,
		simulatedSamplePackets
	}];
	
	(*Liquid-Handler compatible Models*)
	roboticCompatibleContainerModels = hamiltonAliquotContainers["Memoization"];
	
	(*generate a fast cache association*)
	fastAssoc = makeFastAssocFromCache[cacheBall];
	
	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)
	
	(*-- INPUT VALIDATION CHECKS --*)
	(* Get the samples from simulatedSamples that are discarded. *)
	discardedSamplePackets = Cases[Flatten[simulatedSamplePackets], KeyValuePattern[Status -> Discarded]];
	
	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
		{},
		Lookup[discardedSamplePackets, Object]
	];
	
	(* If there are discarded invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall]]
	];
	
	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
			];
			
			passingTest = If[Length[discardedInvalidInputs] == Length[simulatedSamples],
				Nothing,
				Test["The input samples " <> ObjectToString[Complement[simulatedSamples, discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(*-- OPTION PRECISION CHECKS --*)
	(* First, define the option precisions that need to be checked for FragmentAnalysis *)
	optionPrecisions = {
		{SampleVolume, 10^-1 * Microliter},
		{SampleDiluentVolume, 10^-1 * Microliter},
		{SampleLoadingBufferVolume, 10^-1 * Microliter},
		{LadderLoadingBufferVolume, 10^-1 * Microliter},
		{PrimaryCapillaryFlushPressure, 1 PSI},
		{PrimaryCapillaryFlushFlowRate, 1 Microliter / Second},
		{PrimaryCapillaryFlushTime, 10^-1 Minute},
		{SecondaryCapillaryFlushPressure, 1 PSI},
		{SecondaryCapillaryFlushFlowRate, 1 Microliter / Second},
		{SecondaryCapillaryFlushTime, 10^-1 Minute},
		{TertiaryCapillaryFlushPressure, 1 PSI},
		{TertiaryCapillaryFlushFlowRate, 1 Microliter / Second},
		{TertiaryCapillaryFlushTime, 10^-1 Minute},
		{EquilibrationVoltage, 10^-1 Kilovolt},
		{EquilibrationTime, 1 Second},
		{MarkerInjectionTime, 1 Second},
		
		{MarkerInjectionVoltage, 10^-2 Kilovolt},
		{SampleInjectionTime, 1 Second},
		
		{SampleInjectionVoltage, 10^-2 Kilovolt},
		{SeparationTime, 10^-2 Minute},
		{SeparationVoltage, 10^-1 Kilovolt}
	};
	
	(* Verify that the experiment options are not overly precise *)
	{roundedExperimentFragmentAnalysisOptions, optionPrecisionTests} = If[gatherTests,
		
		(*If we are gathering tests *)
		RoundOptionPrecision[fragmentAnalysisOptionsAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
		
		(* Otherwise *)
		{RoundOptionPrecision[fragmentAnalysisOptionsAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], {}}
	];
	
	(* --- set the option variables that will be used during option resolution that need to be rounded as suppliedBlah--- *)
	{
		suppliedSampleVolume,
		suppliedSampleDiluentVolume,
		suppliedSampleLoadingBufferVolume,
		suppliedLadderVolume,
		suppliedLadderLoadingBufferVolume,
		suppliedPrimaryCapillaryFlushPressure,
		suppliedPrimaryCapillaryFlushFlowRate,
		suppliedPrimaryCapillaryFlushTime,
		suppliedSecondaryCapillaryFlushPressure,
		suppliedSecondaryCapillaryFlushFlowRate,
		suppliedSecondaryCapillaryFlushTime,
		suppliedTertiaryCapillaryFlushPressure,
		suppliedTertiaryCapillaryFlushFlowRate,
		suppliedTertiaryCapillaryFlushTime,
		suppliedEquilibrationVoltage,
		suppliedEquilibrationTime,
		suppliedMarkerInjectionTime,
		suppliedMarkerInjectionVoltage,
		suppliedSampleInjectionTime,
		suppliedSampleInjectionVoltage,
		suppliedSeparationTime,
		suppliedSeparationVoltage
	} = Lookup[roundedExperimentFragmentAnalysisOptions,
		{
			SampleVolume,
			SampleDiluentVolume,
			SampleLoadingBufferVolume,
			LadderVolume,
			LadderLoadingBufferVolume,
			PrimaryCapillaryFlushPressure,
			PrimaryCapillaryFlushFlowRate,
			PrimaryCapillaryFlushTime,
			SecondaryCapillaryFlushPressure,
			SecondaryCapillaryFlushFlowRate,
			SecondaryCapillaryFlushTime,
			TertiaryCapillaryFlushPressure,
			TertiaryCapillaryFlushFlowRate,
			TertiaryCapillaryFlushTime,
			EquilibrationVoltage,
			EquilibrationTime,
			MarkerInjectionTime,
			MarkerInjectionVoltage,
			SampleInjectionTime,
			SampleInjectionVoltage,
			SeparationTime,
			SeparationVoltage
		}
	];
	
	(* Turn the output of RoundOptionPrecision[experimentOptionsAssociation] into a list *)
	roundedExperimentFragmentAnalysisOptionsList = Normal[roundedExperimentFragmentAnalysisOptions];
	
	(* Replace the rounded options in myOptions *)
	allOptionsRounded = ReplaceRule[
		myOptions,
		roundedExperimentFragmentAnalysisOptionsList,
		Append -> False
	];
	
	(*set all other options from fragmentAnalysisOptionsAssociation as suppliedBlah*)
	{
		suppliedMaxNumberOfRetries,
		suppliedAnalysisMethodName,
		suppliedCapillaryFlush,
		suppliedNumberOfCapillaryFlushes,
		suppliedAnalysisStrategy,
		suppliedCapillaryArrayLength,
		suppliedSampleAnalyteType,
		suppliedMinReadLength,
		suppliedMaxReadLength,
		suppliedCapillaryEquilibration,
		suppliedPreMarkerRinse,
		suppliedNumberOfPreMarkerRinses,
		suppliedMarkerInjection,
		suppliedPreSampleRinse,
		suppliedNumberOfPreSampleRinses,
		suppliedSampleDilution,
		suppliedRunningBufferPlateStorageCondition,
		suppliedPreMarkerRinseBufferPlateStorageCondition,
		suppliedMarkerPlateStorageCondition,
		suppliedPreSampleRinseBufferPlateStorageCondition,
		suppliedNumberOfCapillaries,
		suppliedNumberOfReplicates
	} = Lookup[
		fragmentAnalysisOptionsAssociation,
		{
			MaxNumberOfRetries,
			AnalysisMethodName,
			CapillaryFlush,
			NumberOfCapillaryFlushes,
			AnalysisStrategy,
			CapillaryArrayLength,
			SampleAnalyteType,
			MinReadLength,
			MaxReadLength,
			CapillaryEquilibration,
			PreMarkerRinse,
			NumberOfPreMarkerRinses,
			MarkerInjection,
			PreSampleRinse,
			NumberOfPreSampleRinses,
			SampleDilution,
			RunningBufferPlateStorageCondition,
			PreMarkerRinseBufferPlateStorageCondition,
			MarkerPlateStorageCondition,
			PreSampleRinseBufferPlateStorageCondition,
			NumberOfCapillaries,
			NumberOfReplicates
		}
	];
	
	(* convert numberOfReplicates such that Null->1 *)
	intNumberOfReplicates=suppliedNumberOfReplicates/.{Null->1};

	(* identify the numberOfSamples in consideration of NumberOfReplicates option *)
	numberOfSamples=(Length[simulatedSamples]*intNumberOfReplicates);

	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(*AnalysisMethodName Resolution*)
	resolvedAnalysisMethodName = suppliedAnalysisMethodName;
	
	(*PreparedPlate Resolution*)
	resolvedPreparedPlate = suppliedPreparedPlate;
	
	(*MaxNumberOfRetries Resolution*)
	resolvedMaxNumberOfRetries = suppliedMaxNumberOfRetries;
	
	(*Capillary Flush Options Resolution*)
	(*CapillaryFlush Resolution*)
	resolvedCapillaryFlush = Which[
		(*if suppliedOption is not Automatic, set to suppliedOption*)
		MatchQ[suppliedCapillaryFlush, Except[Automatic]],
		suppliedCapillaryFlush,
		
		(*If NumberOfCapillaryFlushes is specified as a Number, set to True*)
		NumberQ[suppliedNumberOfCapillaryFlushes],
		True,
		
		(*If NumberOfCapillaryFlushes is not a Number, set to False*)
		!NumberQ[suppliedNumberOfCapillaryFlushes],
		False
	];
	
	(*NumberOfCapillaryFlushes Resolution*)
	resolvedNumberOfCapillaryFlushes = Which[
		(*if suppliedOption is not Automatic, set to suppliedOption*)
		MatchQ[suppliedNumberOfCapillaryFlushes, Except[Automatic]],
		suppliedNumberOfCapillaryFlushes,
		
		(*If resolvedCapillaryFlush is False, set to Null*)
		MatchQ[resolvedCapillaryFlush, False],
		Null,
		
		(*If resolvedCapillaryFlush is False, set to 1*)
		MatchQ[resolvedCapillaryFlush, True],
		1
	];
	
	(*PrimaryCapillaryFlushSolution Resolution*)
	resolvedPrimaryCapillaryFlushSolution = Which[
		MatchQ[suppliedPrimaryCapillaryFlushSolution, Except[Automatic]],
		suppliedPrimaryCapillaryFlushSolution,
		
		MatchQ[resolvedCapillaryFlush, False],
		Null,
		
		MatchQ[resolvedCapillaryFlush, True],
		Model[Sample, StockSolution, "id:Vrbp1jbpD4lx"](*Model[Sample, StockSolution, "1X Conditioning Solution for ExperimentFragmentAnalysis"]*)
	];
	
	(*PrimaryCapillaryFlushPressure Resolution*)
	resolvedPrimaryCapillaryFlushPressure = Which[
		MatchQ[suppliedPrimaryCapillaryFlushPressure, Except[Automatic]],
		suppliedPrimaryCapillaryFlushPressure,
		
		MatchQ[resolvedCapillaryFlush, False],
		Null,
		
		MatchQ[resolvedCapillaryFlush, True],
		280 PSI
	];
	
	(*PrimaryCapillaryFlushFlowRate Resolution*)
	resolvedPrimaryCapillaryFlushFlowRate = Which[
		MatchQ[suppliedPrimaryCapillaryFlushFlowRate, Except[Automatic]],
		suppliedPrimaryCapillaryFlushFlowRate,
		
		MatchQ[resolvedCapillaryFlush, False],
		Null,
		
		MatchQ[resolvedCapillaryFlush, True],
		200 Microliter / Second
	];
	
	(*PrimaryCapillaryFlushTime Resolution*)
	resolvedPrimaryCapillaryFlushTime = Which[
		MatchQ[suppliedPrimaryCapillaryFlushTime, Except[Automatic]],
		suppliedPrimaryCapillaryFlushTime,
		
		MatchQ[resolvedCapillaryFlush, False],
		Null,
		
		MatchQ[resolvedCapillaryFlush, True],
		180 Second
	];
	
	(*SecondaryCapillaryFlushSolution Resolution*)
	resolvedSecondaryCapillaryFlushSolution = Which[
		MatchQ[suppliedSecondaryCapillaryFlushSolution, Except[Automatic]],
		suppliedSecondaryCapillaryFlushSolution,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, LessP[2] | Null],
		Null,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, GreaterP[1]],
		Model[Sample, StockSolution, "id:Vrbp1jbpD4lx"](*Model[Sample, StockSolution, "1X Conditioning Solution for ExperimentFragmentAnalysis"]*)
	];
	
	(*SecondaryCapillaryFlushPressure Resolution*)
	resolvedSecondaryCapillaryFlushPressure = Which[
		MatchQ[suppliedSecondaryCapillaryFlushPressure, Except[Automatic]],
		suppliedSecondaryCapillaryFlushPressure,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, LessP[2] | Null],
		Null,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, GreaterEqualP[2]],
		280 PSI
	];
	
	(*SecondaryCapillaryFlushFlowRate Resolution*)
	resolvedSecondaryCapillaryFlushFlowRate = Which[
		MatchQ[suppliedSecondaryCapillaryFlushFlowRate, Except[Automatic]],
		suppliedSecondaryCapillaryFlushFlowRate,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, LessP[2] | Null],
		Null,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, GreaterEqualP[2]],
		200 Microliter / Second
	];
	
	(*SecondaryCapillaryFlushTime Resolution*)
	resolvedSecondaryCapillaryFlushTime = Which[
		MatchQ[suppliedSecondaryCapillaryFlushTime, Except[Automatic]],
		suppliedSecondaryCapillaryFlushTime,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, LessP[2] | Null],
		Null,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, GreaterEqualP[2]],
		180 Second
	];
	
	(*TertiaryCapillaryFlushSolution Resolution*)
	resolvedTertiaryCapillaryFlushSolution = Which[
		MatchQ[suppliedTertiaryCapillaryFlushSolution, Except[Automatic]],
		suppliedTertiaryCapillaryFlushSolution,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, LessP[3] | Null],
		Null,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, EqualP[3]],
		Model[Sample, StockSolution, "id:Vrbp1jbpD4lx"](*Model[Sample, StockSolution, "1X Conditioning Solution for ExperimentFragmentAnalysis"]*)
	];
	
	(*TertiaryCapillaryFlushPressure Resolution*)
	resolvedTertiaryCapillaryFlushPressure = Which[
		MatchQ[suppliedTertiaryCapillaryFlushPressure, Except[Automatic]],
		suppliedTertiaryCapillaryFlushPressure,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, LessP[3] | Null],
		Null,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, EqualP[3]],
		280 PSI
	];
	
	(*TertiaryCapillaryFlushFlowRate Resolution*)
	resolvedTertiaryCapillaryFlushFlowRate = Which[
		MatchQ[suppliedTertiaryCapillaryFlushFlowRate, Except[Automatic]],
		suppliedTertiaryCapillaryFlushFlowRate,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, LessP[3] | Null],
		Null,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, EqualP[3]],
		200 Microliter / Second
	];
	
	(*TertiaryCapillaryFlushTime Resolution*)
	resolvedTertiaryCapillaryFlushTime = Which[
		MatchQ[suppliedTertiaryCapillaryFlushTime, Except[Automatic]],
		suppliedTertiaryCapillaryFlushTime,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, LessP[3] | Null],
		Null,
		
		MatchQ[resolvedNumberOfCapillaryFlushes, EqualP[3]],
		180 Second
	];
	
	(*CapillaryArrayLength Resolution*)
	(*Short by Default*)
	resolvedCapillaryArrayLength = suppliedCapillaryArrayLength;
	
	(*AnalysisStrategy Resolution*)
	(*Qualitative by Default*)
	resolvedAnalysisStrategy = suppliedAnalysisStrategy;

	
	(*SampleAnalyteType, MinReadLength, MaxReadLength and AnalysisMethod Resolution via MapThread*)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentFragmentAnalysis, roundedExperimentFragmentAnalysisOptions];
	(* MapThread over packets inside sampleCompositionPackets - we need PolymerType and Molecule to determine shortlistAnalysisMethod for each sample.*)
	{
		resolvedSampleAnalyteTypes,
		resolvedCantDetermineSampleAnalyteTypeWarning,
		resolvedMinReadLength,
		resolvedMaxReadLength,
		resolvedCantDetermineMinReadLengthWarning,
		resolvedCantDetermineMaxReadLengthWarning,
		resolvedSampleAnalysisMethod,
		resolvedSampleAnalyteConcentration
	} =
		Transpose[MapThread[Function[{mapThreadSamples, mapThreadOptions},
			Module[
				{
					sampleCompositionPackets,
					cantDetermineSampleAnalyteTypeWarning,
					sampleAnalyteType,
					minReadLength,
					maxReadLength,
					listOfDNAPackets,
					listOfSequences,
					listOfRNAPackets,
					analytePackets,
					listOfMolecules,
					listOfSequenceLengths,
					cantDetermineMinReadLengthWarning,
					cantDetermineMaxReadLengthWarning,
					defaultMethodChoice,
					sampleObjectPacket,
					analyteComposition,
					analyteConcentrations,
					massConcentrationList,
					analysisMethodPackets,
					sampleAnalyteConcentration,
					sampleAnalysisMethod,
					compatibleMethods,
					requiresDilutionMethods,
					inRangeReadLengthMethods
				},
				
				(* Setup our error tracking variables *)
				{cantDetermineSampleAnalyteTypeWarning, cantDetermineMinReadLengthWarning, cantDetermineMaxReadLengthWarning} = ConstantArray[False, 3];
				
				(*get the sampleCompositionPacket from samplePacket - includes PolymerType and Molecule of each Model in the Composition*)
				sampleCompositionPackets = mapThreadSamples[[2]];
				
				(*pick out models from the sampleCompositionPackets that have PolymerType DNA or RNA*)
				listOfDNAPackets = Cases[sampleCompositionPackets, KeyValuePattern[PolymerType -> DNA]];
				listOfRNAPackets = Cases[sampleCompositionPackets, KeyValuePattern[PolymerType -> RNA]];
				
				(*resolvedSampleAnalyteTypes*)
				sampleAnalyteType = Which[
					(*user-specified*)
					MatchQ[Lookup[mapThreadOptions, SampleAnalyteType], Except[Automatic]],
					Lookup[mapThreadOptions, SampleAnalyteType],
					
					(*need to resolve Automatic*)
					MatchQ[Length[listOfRNAPackets],GreaterP[Length[listOfDNAPackets]]],
					RNA,
					
					True,
					DNA
				];
				
				(*resolvedCantDetermineSampleAnalyteTypeWarnings*)
				(*If there are no RNA or DNA types, throw Warning*)
				cantDetermineSampleAnalyteTypeWarning=Which[
					MatchQ[Lookup[mapThreadOptions, SampleAnalyteType], Except[Automatic]],
					False,
					
					MatchQ[Length[listOfDNAPackets],EqualP[0]]  && MatchQ[Length[listOfRNAPackets],EqualP[0]],
					True,
					
					True,
					False
				];
				
				(*pick out Models under Composition where PolymerType \[Equal] sampleAnalyteType: may be required for resolution of resolvedMinReadLength, resolvedMaxReadLength and resolvedSampleAnalysisMethod*)
				analytePackets = Cases[sampleCompositionPackets, KeyValuePattern[{PolymerType -> sampleAnalyteType}]];
				
				(*get the Molecule for each packet, and delete those that are Null*)
				listOfMolecules = DeleteCases[Lookup[analytePackets, Molecule, Null], Null];
				
				listOfSequences = If[MatchQ[Length[listOfMolecules],GreaterP[0]],
					ToSequence[#]& /@ listOfMolecules,
					{}
				];
				
				listOfSequenceLengths =If[MatchQ[Length[listOfSequences],GreaterP[0]],
					SequenceLength[#]& /@ Flatten[listOfSequences],
					{}
				];
				
				(*resolvedMinReadLengths,resolvedMaxReadLengths*)
				minReadLength=Which[
					MatchQ[Lookup[mapThreadOptions, MinReadLength, Null], Except[Automatic]],
					Lookup[mapThreadOptions, MinReadLength],
					
					MatchQ[Length[listOfMolecules],GreaterP[0]],
					Min[listOfSequenceLengths],
					
					True,
					Null
				];
				
				maxReadLength=Which[
					MatchQ[Lookup[mapThreadOptions, MaxReadLength, Null], Except[Automatic]],
					Lookup[mapThreadOptions, MaxReadLength],
					
					MatchQ[Length[listOfMolecules],GreaterP[0]],
					Max[listOfSequenceLengths],
					
					True,
					Null
				];
				
				(*resolvedCantDetermineMinReadLengthWarning*)
				(*If MinReadLength is Null, throw Warning*)
				cantDetermineMinReadLengthWarning=Which[
					MatchQ[Lookup[mapThreadOptions, MinReadLength], Except[Automatic]],
					False,
					
					MatchQ[minReadLength,Null],
					True,
					
					True,
					False
				];
				
				(*resolvedCantDetermineMaxReadLengthWarning*)
				(*If MaxReadLength is Null, throw Warning*)
				
				cantDetermineMaxReadLengthWarning=Which[
					MatchQ[Lookup[mapThreadOptions, MaxReadLength], Except[Automatic]],
					False,
					
					MatchQ[maxReadLength,Null],
					True,
					
					True,
					False
				];
				
				(*get sampleAnalyteConcentration, if any, which will be used to narrow down the suitable AnalysisMethod*)
				(*get the sampleObjectPacket for each sample to get the Composition Amount and Models*)
				sampleObjectPacket = mapThreadSamples[[1]];
				
				(*get the list of {Amount,Models} under Composition that have PolymerType\[Equal]sampleAnalyteType*)
				analyteComposition = Flatten[Cases[Lookup[sampleObjectPacket, Composition, {}], {_, Link[#, _], _}]& /@ Lookup[analytePackets, Object, {}], 1];
				
				(*put together the list of Amounts that fall under MassConcentrationP and ConcentrationP, where all ConcentrationP are converted to MassConcentrationP via MolecularWeight*)
				analyteConcentrations=Which[
					MatchQ[Length[analyteComposition], GreaterP[0]],
					Map[
						Which[
							MatchQ[#[[1]], MassConcentrationP],
							#[[1]],
							
							MatchQ[#[[1]], ConcentrationP],
							#[[1]] * fastAssocLookup[fastAssoc, First[#[[2]]], MolecularWeight],
							
							True,
							Null
						]&,
						analyteComposition
					],
					
					True,
					{}
				];
				
				(*get all concentrations that match MassConcentrationP - this is needed to compare with the TargetMassConcentration of the AnalysisMethods*)
				massConcentrationList = Cases[analyteConcentrations, MassConcentrationP];
				
				(*If there are sample analyte concentrations to check, first get a total mass concentration, then compare with the TargetMassConcentrations of the analysis methods*)
				sampleAnalyteConcentration = If[MatchQ[Length[massConcentrationList],GreaterP[0]],
					Plus @@ massConcentrationList,
					Null
				];
				
				(*get packets of all Method objects*)
				analysisMethodPackets = DeleteDuplicates[Cases[fastAssoc, KeyValuePattern[Type -> Object[Method, FragmentAnalysis]]]];
				
				(*select method choices that satisfy all conditions*)
				compatibleMethods=Lookup[
					Cases[
						analysisMethodPackets,
						KeyValuePattern[{
							TargetAnalyteType->sampleAnalyteType,
							CapillaryArrayLength->resolvedCapillaryArrayLength,
							AnalysisStrategy->_?(MemberQ[#,resolvedAnalysisStrategy]&),
							Name->_?(StringContainsQ[#,"dsDNA"|"RNA"]&),
							MinTargetReadLength->_?(LessEqual[#,minReadLength]&),
							MaxTargetReadLength->_?(GreaterEqual[#,maxReadLength]&),
							AnalysisMethodAuthor->Manufacturer,
							MinTargetMassConcentration->_?(LessEqual[#,sampleAnalyteConcentration]&),
							MaxTargetMassConcentration->_?(GreaterEqual[#,sampleAnalyteConcentration]&)
						}]
					],
					Object,
					{}
				];
				
				(*next best method object options are those where dilution can satisy optimum conditions*)
				requiresDilutionMethods=If[MatchQ[Length[compatibleMethods],GreaterP[0]],
					{},
					Lookup[
						Cases[
							analysisMethodPackets,
							KeyValuePattern[{
								TargetAnalyteType->sampleAnalyteType,
								CapillaryArrayLength->resolvedCapillaryArrayLength,
								AnalysisStrategy->_?(MemberQ[#,resolvedAnalysisStrategy]&),
								Name->_?(StringContainsQ[#,"dsDNA"|"RNA"]&),
								MinTargetReadLength->_?(LessEqual[#,minReadLength]&),
								MaxTargetReadLength->_?(GreaterEqual[#,maxReadLength]&),
								AnalysisMethodAuthor->Manufacturer,
								MinTargetMassConcentration->_?(LessEqual[#,sampleAnalyteConcentration]&)
							}]
						],
						Object,
						{}
					]
				];
				
				(*if no method objects can satisfy concentration conditions, narrow down to those where ReadLengths are within range*)
				inRangeReadLengthMethods=If[MatchQ[Length[compatibleMethods],GreaterP[0]],
					{},
					Lookup[
						Cases[
							analysisMethodPackets,
							KeyValuePattern[{
								TargetAnalyteType->sampleAnalyteType,
								CapillaryArrayLength->resolvedCapillaryArrayLength,
								AnalysisStrategy->_?(MemberQ[#,resolvedAnalysisStrategy]&),
								Name->_?(StringContainsQ[#,"dsDNA"|"RNA"]&),
								MinTargetReadLength->_?(LessEqual[#,minReadLength]&),
								MaxTargetReadLength->_?(GreaterEqual[#,maxReadLength]&),
								AnalysisMethodAuthor->Manufacturer
							}]
						],
						Object,
						{}
					]
				];
				
				(*Default method are methods of the widest read length range*)
				defaultMethodChoice=Which[
					MatchQ[sampleAnalyteType,RNA],
					Lookup[
						Cases[
							analysisMethodPackets,
							KeyValuePattern[{
								TargetAnalyteType->sampleAnalyteType,
								CapillaryArrayLength->resolvedCapillaryArrayLength,
								AnalysisStrategy->_?(MemberQ[#,resolvedAnalysisStrategy]&),
								Name->_?(StringContainsQ[#,"Standard"]&),
								AnalysisMethodAuthor->Manufacturer,
								MinTargetReadLength->_?(LessEqual[#,200]&),
								MaxTargetReadLength->_?(GreaterEqual[#,6000]&)
							}]
						],
						Object,
						(*If no cases come up, use as default for RNA Object[Method, FragmentAnalysis, "RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"]*)
						{Object[Method, FragmentAnalysis, "id:pZx9jox9zjk4"]}
					],
					
					MatchQ[sampleAnalyteType,DNA],
					Lookup[
						Cases[
							analysisMethodPackets,
							KeyValuePattern[{
								TargetAnalyteType->sampleAnalyteType,
								CapillaryArrayLength->resolvedCapillaryArrayLength,
								AnalysisStrategy->_?(MemberQ[#,resolvedAnalysisStrategy]&),
								Name->_?(StringContainsQ[#,"dsDNA"]&&StringContainsQ[#,"Standard"]&),
								AnalysisMethodAuthor->Manufacturer,
								MinTargetReadLength->_?(LessEqual[#,75]&),
								MaxTargetReadLength->_?(GreaterEqual[#,20000]&)
							}]
						],
						Object,
						(*If no cases come up, use as default for DNA Object[Method, FragmentAnalysis, "dsDNA (75 - 20000 bp) - Standard Sensitivity (ng/uL) - Short"]*)
						{Object[Method, FragmentAnalysis, "id:wqW9BPW9kB4A"]}
					]
				];
				
				sampleAnalysisMethod=Which[
					MatchQ[suppliedAnalysisMethod, Except[Automatic]],
					suppliedAnalysisMethod,
					
					(*If there is only one compatible method, set to the object of this method*)
					MatchQ[Length[compatibleMethods],1],
					compatibleMethods[[1]],
					
					(*If multiple methods can accommodate the concentration and read length range, select the optimum read length range*)
					MatchQ[Length[compatibleMethods],GreaterP[1]],
					Module[
						{differenceMinReadLength,differenceMaxReadLength,lowestDifference},
						differenceMinReadLength = minReadLength - fastAssocLookup[fastAssoc, #, MinTargetReadLength]& /@ compatibleMethods;
						differenceMaxReadLength = fastAssocLookup[fastAssoc, #, MaxTargetReadLength] - maxReadLength& /@ compatibleMethods;
						lowestDifference = Min[MapThread[#1 + #2&, {differenceMinReadLength, differenceMaxReadLength}]];
						Select[
							compatibleMethods,
							Plus[minReadLength - fastAssocLookup[fastAssoc, #, MinTargetReadLength], fastAssocLookup[fastAssoc, #, MaxTargetReadLength] - maxReadLength] == lowestDifference&
						][[1]]
					],
					
					(*if no methods can accommodate the concentration range, select the method that can be satisfied by dilution*)
					MatchQ[Length[requiresDilutionMethods],GreaterEqualP[1]],
					requiresDilutionMethods[[1]],
					
					(*If no methods are identified to be within concentration range, select from methods that are within Readlength range*)
					MatchQ[Length[inRangeReadLengthMethods],1],
					inRangeReadLengthMethods[[1]],
					
					(*If multiple methods can accommodate the read length range, select the optimum read length range*)
					MatchQ[Length[inRangeReadLengthMethods],GreaterP[1]],
					Module[
						{differenceMinReadLength,differenceMaxReadLength,lowestDifference},
						differenceMinReadLength = minReadLength - fastAssocLookup[fastAssoc, #, MinTargetReadLength]& /@ inRangeReadLengthMethods;
						differenceMaxReadLength = fastAssocLookup[fastAssoc, #, MaxTargetReadLength] - maxReadLength& /@ inRangeReadLengthMethods;
						lowestDifference = Min[MapThread[#1 + #2&, {differenceMinReadLength, differenceMaxReadLength}]];
						Select[
							inRangeReadLengthMethods,
							Plus[minReadLength - fastAssocLookup[fastAssoc, #, MinTargetReadLength], fastAssocLookup[fastAssoc, #, MaxTargetReadLength] - maxReadLength] == lowestDifference&
						][[1]]
					],
					
					True,
					defaultMethodChoice[[1]]
				];
				(* Gather MapThread results *)
				{
					sampleAnalyteType,
					cantDetermineSampleAnalyteTypeWarning,
					minReadLength,
					maxReadLength,
					cantDetermineMinReadLengthWarning,
					cantDetermineMaxReadLengthWarning,
					sampleAnalysisMethod,
					sampleAnalyteConcentration
				}
			]
		],
			{simulatedSamplePackets, mapThreadFriendlyOptions}
		]];
	
	(*Determine the AnalysisMethod of the most number from the resolvedSampleAnalysisMethodList and set as resolvedAnalysisMethod*)
	resolvedAnalysisMethod = First[Keys[TakeLargest[Counts[resolvedSampleAnalysisMethod], 1]]];
	
	(*-- Non-index matched options related to AnalysisMethod --*)
	
	(*ConditioningSolution Resolution*)
	resolvedConditioningSolution = Which[
		(*if user-specified, set to suppliedConditioningSolution*)
		MatchQ[suppliedConditioningSolution, Except[Automatic]],
		suppliedConditioningSolution,
		
		(*if not User-specified, set to field value of AnalysisMethod*)
		MatchQ[fastAssocLookup[fastAssoc, resolvedAnalysisMethod, ConditioningSolution], ObjectP[]],
		fastAssocLookup[fastAssoc, resolvedAnalysisMethod, ConditioningSolution],
		
		True,
		Model[Sample, StockSolution, "id:Vrbp1jbpD4lx"](*Model[Sample, StockSolution, "1X Conditioning Solution for ExperimentFragmentAnalysis"]*)
	];
	
	(*SeparationGel Resolution*)
	resolvedSeparationGel = If[MatchQ[suppliedSeparationGel, Except[Automatic]],
		(*if user-specified, set to suppliedSeparationGel*)
		suppliedSeparationGel,
		(*if not User-specified, set to field value of AnalysisMethod*)
		fastAssocLookup[fastAssoc, resolvedAnalysisMethod, SeparationGel]
	];
	
	(*Dye Resolution*)
	resolvedDye = If[MatchQ[suppliedDye, Except[Automatic]],
		(*if user-specified, set to suppliedDye*)
		suppliedDye,
		(*if not User-specified, set to field value of AnalysisMethod*)
		fastAssocLookup[fastAssoc, resolvedAnalysisMethod, Dye]
	];
	
	(*PreparedRunningBufferPlate*)
	resolvedPreparedRunningBufferPlate = suppliedPreparedRunningBufferPlate;
	
	(*PreparedMarkerPlatePacket*)
	resolvedPreparedMarkerPlate = suppliedPreparedMarkerPlate;
	
	(*RunningBufferPlateStorageCondition Resolution*)
	(*Either user-supplied or defaults to Disposal*)
	resolvedRunningBufferPlateStorageCondition = suppliedRunningBufferPlateStorageCondition;
	
	(*Capillary Equilibration Options*)
	(*CapillaryEquilibration Resolution*)
	resolvedCapillaryEquilibration = If[MatchQ[suppliedCapillaryEquilibration, Except[Automatic]],
		(*if user-specified, set to suppliedCapillaryEquilibration*)
		suppliedCapillaryEquilibration,
		
		(*if not User-specified, set to field value of AnalysisMethod*)
		fastAssocLookup[fastAssoc, resolvedAnalysisMethod, CapillaryEquilibration]
	];
	
	(*EquilibrationVoltage Resolution*)
	(*look up value of relevant field in AnalysisMethod and use this for resolution if suppliedOption is Automatic*)
	analysisMethodEquilibrationVoltage = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, EquilibrationVoltage];
	resolvedEquilibrationVoltage = Which[
		(*if user-specified, set to suppliedEquilibrationVoltage*)
		MatchQ[suppliedEquilibrationVoltage, Except[Automatic]],
		suppliedEquilibrationVoltage,
		
		(*If CapillaryEquilibration is False, automatically set to Null, despite field value in AnalysisMethod.*)
		MatchQ[resolvedCapillaryEquilibration, False],
		Null,
		
		(*If CapillaryEquilibration is True, automatically set to field value of AnalysisMethod as long as it is not Null.*)
		MatchQ[analysisMethodEquilibrationVoltage, Except[Null]],
		analysisMethodEquilibrationVoltage,
		
		(*If CapillaryEquilibration is True but field value of AnalysisMethod is Null, set to a reasonable value.*)
		MatchQ[analysisMethodEquilibrationVoltage, Null],
		8.0 Kilovolt
	];
	
	(*EquilibrationTime Resolution*)
	(*look up value of relevant field in AnalysisMethod and use this for resolution if suppliedOption is Automatic*)
	analysisMethodEquilibrationTime = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, EquilibrationTime];
	
	resolvedEquilibrationTime = Which[
		(*if user-specified, set to suppliedEquilibrationVoltage*)
		MatchQ[suppliedEquilibrationTime, Except[Automatic]],
		suppliedEquilibrationTime,
		
		(*If CapillaryEquilibration is False, automatically set to Null, despite field value in AnalysisMethod.*)
		MatchQ[resolvedCapillaryEquilibration, False],
		Null,
		
		(*If CapillaryEquilibration is True, automatically set to field value of AnalysisMethod as long as it is not Null.*)
		MatchQ[analysisMethodEquilibrationTime, Except[Null]],
		analysisMethodEquilibrationTime,
		
		(*If CapillaryEquilibration is True but field value of AnalysisMethod is Null, set to a reasonable value.*)
		MatchQ[analysisMethodEquilibrationTime, Null],
		30 Second
	];
	
	(*PreMarker Rinse Options*)
	(*PreMarkerRinse Resolution*)
	analysisMethodPreMarkerRinse = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, PreMarkerRinse];
	resolvedPreMarkerRinse = Which[
		(*if user-specified, set to suppliedPreMarkerRinse*)
		MatchQ[suppliedPreMarkerRinse, Except[Automatic]],
		suppliedPreMarkerRinse,
		
		(*If suppliedPreMarkerRinse is Automatic and suppliedNumberOfPreMarkerRinses is a number, set PreMarkerRinse to True*)
		MatchQ[suppliedNumberOfPreMarkerRinses, NumberP],
		True,
		
		(*If suppliedPreMarkerRinse is Automatic and suppliedNumberOfPreMarkerRinses is Null, set PreMarkerRinse to False*)
		MatchQ[suppliedNumberOfPreMarkerRinses, Null],
		False,
		
		(*If suppliedPreMarkerRinse is Automatic and suppliedNumberOfPreMarkerRinses is not a number, set PreMarkerRinse to field value in AnalysisMethod*)
		MatchQ[suppliedPreMarkerRinse, Automatic] && MatchQ[suppliedNumberOfPreMarkerRinses, Automatic],
		analysisMethodPreMarkerRinse
	];
	
	(*NumberOfPreMarkerRinses Resolution*)
	(*look up value of relevant field in AnalysisMethod and use this for resolution if suppliedOption is Automatic*)
	analysisMethodNumberOfPreMarkerRinses = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, NumberOfPreMarkerRinses];
	resolvedNumberOfPreMarkerRinses = Which[
		(*if user-specified, set to suppliedEquilibrationVoltage*)
		MatchQ[suppliedNumberOfPreMarkerRinses, Except[Automatic]],
		suppliedNumberOfPreMarkerRinses,
		
		(*If PreMarkerRinse is False, automatically set to Null, despite field value in AnalysisMethod.*)
		MatchQ[resolvedPreMarkerRinse, False],
		Null,
		
		(*If PreMarkerRinse is True, automatically set to field value of AnalysisMethod as long as it is not Null.*)
		MatchQ[analysisMethodNumberOfPreMarkerRinses, Except[Null]],
		analysisMethodNumberOfPreMarkerRinses,
		
		(* If field value of AnalysisMethod is Null, set to a reasonable value (1).*)
		MatchQ[analysisMethodNumberOfPreMarkerRinses, Null],
		1
	];
	
	(*PreMarkerRinseBuffer Resolution*)
	(*look up value of relevant field in AnalysisMethod and use this for resolution if suppliedOption is Automatic*)
	analysisMethodPreMarkerRinseBuffer = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, PreMarkerRinseBuffer];
	resolvedPreMarkerRinseBuffer = Which[
		(*if user-specified, set to suppliedPreMarkerRinseBuffer*)
		MatchQ[suppliedPreMarkerRinseBuffer, Except[Automatic]],
		suppliedPreMarkerRinseBuffer,
		
		(*if suppliedPreMarkerRinseBuffer is Automatic AND resolvedPreMarkerRinse is False,set to Null despite field value of AnalysisMethod*)
		MatchQ[resolvedPreMarkerRinse, False],
		Null,
		
		(*if suppliedPreMarkerRinseBuffer is Automatic AND resolvedPreMarkerRinse is True,set to field value of AnalysisMethod if not Null*)
		MatchQ[analysisMethodPreMarkerRinseBuffer, Except[Null]],
		analysisMethodPreMarkerRinseBuffer,
		
		(*if suppliedPreMarkerRinseBuffer is Automatic AND resolvedPreMarkerRinse is True AND field value of AnalysisMethod is Null, set to reasonable value*)
		MatchQ[analysisMethodPreMarkerRinseBuffer, Null],
		Model[Sample, "0.25x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"]
	];
	
	
	(*PreMarkerRinseBufferPlateStorageCondition Resolution*)
	resolvedPreMarkerRinseBufferPlateStorageCondition = Which[
		(*if user specified, set to suppliedPreMarkerRinseBufferPlateStorageCondition*)
		MatchQ[suppliedPreMarkerRinseBufferPlateStorageCondition, Except[Automatic]],
		suppliedPreMarkerRinseBufferPlateStorageCondition,
		
		(*if suppliedPreMarkerRinseBufferPlateStorageCondition is Automatic and PreMarkerRinseBuffer is Null, set to Null*)
		MatchQ[resolvedPreMarkerRinseBuffer, Null],
		Null,
		
		(*if suppliedPreMarkerRinseBufferPlateStorageCondition is Automatic and PreMarkerRinseBuffer is not Null, set to Disposal*)
		MatchQ[resolvedPreMarkerRinseBuffer, Except[Null]],
		Disposal
	];
	
	(*MarkerInjection Options*)
	(*MarkerInjection Resolution*)
	resolvedMarkerInjection = If[MatchQ[suppliedMarkerInjection, Except[Automatic]],
		(*if user-specified, set to suppliedMarkerInjection*)
		suppliedMarkerInjection,
		(*if not User-specified, set to field value of AnalysisMethod*)
		fastAssocLookup[fastAssoc, resolvedAnalysisMethod, MarkerInjection]
	];
	
	(*MarkerInjectionTime Resolution*)
	(*look up value of relevant field in AnalysisMethod and use this for resolution if suppliedOption is Automatic*)
	analysisMethodMarkerInjectionTime = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, MarkerInjectionTime];
	resolvedMarkerInjectionTime = Which[
		(*if user-specified, set to suppliedMarkerInjectionTime*)
		MatchQ[suppliedMarkerInjectionTime, Except[Automatic]],
		suppliedMarkerInjectionTime,
		
		(*If MarkerInjection is False, automatically set to Null, despite field value in AnalysisMethod.*)
		MatchQ[resolvedMarkerInjection, False],
		Null,
		
		(*If MarkerInjection is True, automatically set to field value of AnalysisMethod as long as it is not Null.*)
		MatchQ[analysisMethodMarkerInjectionTime, Except[Null]],
		analysisMethodMarkerInjectionTime,
		
		(* If field value of AnalysisMethod is Null, set to a reasonable value.*)
		MatchQ[analysisMethodMarkerInjectionTime, Null],
		5 Second
	];
	
	(*MarkerInjectionVoltage Resolution*)
	(*look up value of relevant field in AnalysisMethod and use this for resolution if suppliedOption is Automatic*)
	analysisMethodMarkerInjectionVoltage = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, MarkerInjectionVoltage];
	resolvedMarkerInjectionVoltage = Which[
		(*if user-specified, set to suppliedMarkerInjectionTime*)
		MatchQ[suppliedMarkerInjectionVoltage, Except[Automatic]],
		suppliedMarkerInjectionVoltage,
		
		(*If MarkerInjection is False, automatically set to Null, despite field value in AnalysisMethod.*)
		MatchQ[resolvedMarkerInjection, False],
		Null,
		
		
		(* If MarkerInjection is True, automatically set to field value of AnalysisMethod as long as it is not Null.*)
		MatchQ[analysisMethodMarkerInjectionVoltage, Except[Null]],
		analysisMethodMarkerInjectionVoltage,
		
		(* If MarkerInjection is True and field value of AnalysisMethod is Null, set to a reasonable value.*)
		MatchQ[analysisMethodMarkerInjectionVoltage, Null],
		3 Kilovolt
	];
	
	(*PreSample Rinse Options*)
	(*PreSampleRinse Resolution*)
	analysisMethodPreSampleRinse = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, PreSampleRinse];
	
	resolvedPreSampleRinse = Which[
		(*if user-specified, set to suppliedPreSampleRinse*)
		MatchQ[suppliedPreSampleRinse, Except[Automatic]],
		suppliedPreSampleRinse,
		
		(*If suppliedPreSampleRinse is Automatic and suppliedNumberOfPreSampleRinses is a number, set PreSampleRinse to True*)
		MatchQ[suppliedNumberOfPreSampleRinses, NumberP],
		True,
		
		(*If suppliedPreSampleRinse is Automatic and suppliedNumberOfPreSampleRinses is Null, set PreSampleRinse to True*)
		MatchQ[suppliedNumberOfPreSampleRinses, Null],
		False,
		
		(*If suppliedPreSampleRinse is Automatic and suppliedNumberOfPreSampleRinses is not a number, set PreSampleRinse to field value in AnalysisMethod*)
		MatchQ[suppliedNumberOfPreSampleRinses, Automatic],
		analysisMethodPreSampleRinse
	];
	
	(*NumberOfPreSampleRinses Resolution*)
	(*look up value of relevant field in AnalysisMethod and use this for resolution if suppliedOption is Automatic*)
	analysisMethodNumberOfPreSampleRinses = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, NumberOfPreSampleRinses];
	resolvedNumberOfPreSampleRinses = Which[
		(*if user-specified, set to suppliedNumberOfPreSampleRinses*)
		MatchQ[suppliedNumberOfPreSampleRinses, Except[Automatic]],
		suppliedNumberOfPreSampleRinses,
		
		(*If PreSampleRinse is False, automatically set to Null, despite field value in AnalysisMethod.*)
		MatchQ[resolvedPreSampleRinse, False],
		Null,
		
		(*If PreSampleRinse is True, automatically set to field value of AnalysisMethod as long as it is not Null.*)
		MatchQ[analysisMethodNumberOfPreSampleRinses, Except[Null]],
		analysisMethodNumberOfPreSampleRinses,
		
		(* If field value of AnalysisMethod is Null, set to a reasonable value (1).*)
		MatchQ[analysisMethodNumberOfPreSampleRinses, Null],
		1
	];
	
	(*PreSampleRinseBuffer Resolution*)
	analysisMethodPreSampleRinseBuffer = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, PreSampleRinseBuffer];
	resolvedPreSampleRinseBuffer = Which[
		(*if user-specified, set to suppliedPreSampleRinseBuffer*)
		MatchQ[suppliedPreSampleRinseBuffer, Except[Automatic]],
		suppliedPreSampleRinseBuffer,
		
		(*if suppliedPreSampleRinseBuffer is Automatic AND resolvedPreSampleRinse is False,set to Null despite field value of AnalysisMethod*)
		MatchQ[resolvedPreSampleRinse, False],
		Null,
		
		(*if suppliedPreSampleRinseBuffer is Automatic AND resolvedPreSampleRinse is True,set to field value of AnalysisMethod if not Null*)
		MatchQ[analysisMethodPreSampleRinseBuffer, Except[Null]],
		analysisMethodPreSampleRinseBuffer,
		
		(*if suppliedPreSampleRinseBuffer is Automatic AND resolvedPreSampleRinse is True AND field value of AnalysisMethod is Null, set to reasonable value*)
		MatchQ[analysisMethodPreSampleRinseBuffer, Null],
		Model[Sample, "0.25x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"]
	];
	
	(*PreSampleRinseBufferPlateStorageCondition Resolution*)
	resolvedPreSampleRinseBufferPlateStorageCondition = Which[
		(*if user specified, set to suppliedPreSampleRinseBufferPlateStorageCondition*)
		MatchQ[suppliedPreSampleRinseBufferPlateStorageCondition, Except[Automatic]],
		suppliedPreSampleRinseBufferPlateStorageCondition,
		
		(*if suppliedPreSampleRinseBufferPlateStorageCondition is Automatic and PreSampleRinseBuffer is Null, set to Null*)
		MatchQ[resolvedPreSampleRinseBuffer, Null],
		Null,
		
		(*if suppliedPreSampleRinseBufferPlateStorageCondition is Automatic and PreSampleRinseBuffer is not Null, set to Disposal*)
		MatchQ[resolvedPreSampleRinseBuffer, Except[Null]],
		Disposal
	];
	
	(*SampleInjection Options*)
	(*SampleInjectionTime Resolution*)
	resolvedSampleInjectionTime = If[MatchQ[suppliedSampleInjectionTime, Except[Automatic]],
		(*if user-specified, set to suppliedSampleInjectionTime*)
		suppliedSampleInjectionTime,
		
		(*if Automatic, set to field value of AnalysisMethod*)
		fastAssocLookup[fastAssoc, resolvedAnalysisMethod, SampleInjectionTime]
	];
	
	(*SampleInjectionVoltage Resolution*)
	resolvedSampleInjectionVoltage = If[MatchQ[suppliedSampleInjectionVoltage, Except[Automatic]],
		(*if user-specified, set to suppliedSampleInjectionVoltage*)
		suppliedSampleInjectionVoltage,
		
		(*if Automatic, set to field value of AnalysisMethod*)
		fastAssocLookup[fastAssoc, resolvedAnalysisMethod, SampleInjectionVoltage]
	];
	
	(*Separation Options*)
	(*SeparationTime Resolution*)
	resolvedSeparationTime = If[MatchQ[suppliedSeparationTime, Except[Automatic]],
		(*if user-specified, set to suppliedSeparationTime*)
		suppliedSeparationTime,
		
		(*if Automatic, set to field value of AnalysisMethod*)
		fastAssocLookup[fastAssoc, resolvedAnalysisMethod, SeparationTime]
	];
	
	(*SeparationVoltage Resolution*)
	resolvedSeparationVoltage = If[MatchQ[suppliedSeparationVoltage, Except[Automatic]],
		(*if user-specified, set to suppliedSeparationVoltage*)
		suppliedSeparationVoltage,
		
		(*if Automatic, set to field value of AnalysisMethod*)
		fastAssocLookup[fastAssoc, resolvedAnalysisMethod, SeparationVoltage]
	];
	
	(*Internal function which checks whether option values are the same with the field value of the selected AnalysisMethod - will be used in checks inside ladder and sample mapthreads*)
	analysisMethodOptionsCheckFunction[option_Symbol, resolvedOption_] := Module[{analysisMethodOption},
		analysisMethodOption = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, option];
		
		(*Compare the resolvedOption with the corresponding field value in the AnalysisMethod based on whether the values are Objects or Models*)
		Which[
			(*If the resolvedOption and analysisMethodOption are both Models, compare directly*)
			MatchQ[resolvedOption, ObjectP[Model[Sample]]] && MatchQ[analysisMethodOption, ObjectP[Model[Sample]]],
			!MatchQ[resolvedOption, ObjectP[analysisMethodOption]],
			
			(*If the resolvedOption is a Model and analysisMethodOption is an Object, cannot compare and thus Warning is True - this only happens if the AnalysisMethod set is authored by User*)
			MatchQ[resolvedOption, ObjectP[Model[Sample]]] && MatchQ[analysisMethodOption, ObjectP[Object[Sample]]],
			True,
			
			(*If resolvedOption is an Object and analysisMethodOption is a Model, get the Model of the resolvedOption(if any) then compare the Models*)
			MatchQ[resolvedOption, ObjectP[Object[Sample]]] && MatchQ[analysisMethodOption, ObjectP[Model[Sample]]],
			!MatchQ[fastAssocLookup[fastAssoc, resolvedOption, Model], ObjectP[analysisMethodOption]],
			
			(*If both resolvedOption and analysisMethodOption is a Object, compare directly*)
			MatchQ[resolvedOption, ObjectP[Object[Sample]]] && MatchQ[analysisMethodOption, ObjectP[Object[Sample]]],
			!MatchQ[resolvedOption, ObjectP[analysisMethodOption]],
			
			(*If any of the resolvedOption or analysisMethodOption is Null, compare directly*)
			MatchQ[resolvedOption, Null] || MatchQ[analysisMethodOption, Null],
			!MatchQ[resolvedOption, analysisMethodOption],
			
			(*If any of the resolvedOption or analysisMethodOption is not an Object, compare directly*)
			MatchQ[resolvedOption, Except[ObjectP[]]] || MatchQ[analysisMethodOption, Except[ObjectP[]]],
			!MatchQ[resolvedOption, EqualP[analysisMethodOption]]
		]
	];
	
	(*PreparedRunningBufferPlate Contents*)
	(*If PreparedRunningBufferPlate is an plate object, the contents are checked/index-matched against ladder, samples and blanks*)
	preparedRunningBufferPlateContentsObjects = If[MatchQ[resolvedPreparedRunningBufferPlate, ObjectP[]],
		fastAssocLookup[fastAssoc, resolvedPreparedRunningBufferPlate,Contents][[All, 2]][[All, 1]],
		{}
	];
	
	(*PreparedMarkerPlate Contents*)
	(*If PreparedMarkerPlate is an plate object, the contents are checked/index-matched against ladder, samples and blanks*)
	preparedMarkerPlateContentsObjects = If[MatchQ[resolvedPreparedMarkerPlate, ObjectP[]],
		fastAssocLookup[fastAssoc, resolvedPreparedMarkerPlate,Contents][[All, 2]][[All, 1]],
		{}
	];
	
	(*Index-matched Ladder options*)

	analysisMethodLadder = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, Ladder];
	resolvedLadder = Which[
		!MemberQ[ToList[suppliedLadder],Automatic],
		suppliedLadder,

		(* if suppliedLadder is Automatic and PreparedPlate is True, set to H12 well *)
		MatchQ[suppliedLadder,Automatic]&&MatchQ[resolvedPreparedPlate,True],
		"H12",

		(* if given a list with Automatic and PreparedPlate is False, replace any Automatic with analysisMethodLadder *)
		MatchQ[resolvedPreparedPlate,False],
		suppliedLadder/.Automatic->analysisMethodLadder,

		(* if given a list with Automatic and PreparedPlate is True, replace any Automatic with analysisMethodLadder *)
		MatchQ[resolvedPreparedPlate,True],
		suppliedLadder/.Automatic->Null
	];

	(*Turn the resolvedLadder input into a list so it can be used in a MapThread resolution*)
	listedResolvedLadder = ToList[resolvedLadder];

	numberOfLadders = Length[DeleteCases[listedResolvedLadder,Null]];
	
	(*Set-up the list of Ladder-related options (keys) that are indexed-matched and needs to be resolved in a map thread*)
	ladderOptions = {LadderVolume, LadderLoadingBuffer, LadderLoadingBufferVolume, LadderRunningBuffer, LadderMarker};
	
	(*Lookup the values for the options and create a transposed list that groups key-values for each ladder*)
	ladderOptionValues = If[!MatchQ[Length[Transpose[Lookup[roundedExperimentFragmentAnalysisOptions, ladderOptions]]],Length[listedResolvedLadder]],
		ConstantArray[Transpose[Lookup[roundedExperimentFragmentAnalysisOptions, ladderOptions]],Length[listedResolvedLadder]],
		Transpose[Lookup[roundedExperimentFragmentAnalysisOptions, ladderOptions]]
	];
	
	(*If PreparedRunningBufferPlate is an object, pick out the relevant objects that are index-matched to Ladder(s)*)
	preparedLadderRunningBufferObjects = If[MatchQ[suppliedPreparedRunningBufferPlate, ObjectP[Object[Container, Plate]]] && MatchQ[numberOfLadders,GreaterP[0]],
		Take[preparedRunningBufferPlateContentsObjects, -Length[listedResolvedLadder]],
		Table[Null, Length[listedResolvedLadder]]
	];
	
	(*If PreparedMarkerPlate is an object, pick out the relevant objects that are index-matched to Ladder(s)*)
	preparedLadderMarkerObjects = If[MatchQ[suppliedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]] && MatchQ[numberOfLadders,GreaterP[0]],
		Take[preparedMarkerPlateContentsObjects, -Length[listedResolvedLadder]],
		Table[Null, Length[listedResolvedLadder]]
	];
	
	(*Create the ladderMapThreadFriendlyOptions that can be used for resolution in a MapThread*)
	ladderMapThreadFriendlyOptions = MapThread[
		Function[optionFields, Association[MapThread[#1 -> #2&, {ladderOptions, optionFields}]]],
		{ladderOptionValues}
	];
	
	(*Resolution of Index-Matched AnalysisMethod Options of Ladder*)
	(* MapThread over each of our ladders.*)
	{
		mapResolvedLadderVolume,
		mapResolvedLadderLoadingBuffer,
		mapResolvedLadderLoadingBufferVolume,
		mapResolvedLadderRunningBuffer,
		mapResolvedLadderMarker,
		resolvedLadderPreparedPlateMismatchError,
		resolvedLadderOptionsPreparedPlateMismatchOptions,
		resolvedLadderOptionsPreparedPlateErrors,
		resolvedLadderVolumeMismatchError,
		resolvedLadderLoadingBufferMismatchError,
		resolvedLadderLoadingBufferVolumeMismatchError,
		resolvedLadderRunningBufferMismatchError,
		resolvedLadderMarkerMismatchError,
		resolvedTotalLadderSolutionVolume,
		resolvedMaxLadderVolumeError,
		resolvedMaxLadderVolumeBadOptions,
		resolvedAnalysisMethodLadderMismatchWarning,
		resolvedAnalysisMethodLadderOptionsMismatchList,
		resolvedAnalysisMethodLadderOptionsMismatchWarning,
		resolvedPreparedLadderRunningBufferMismatchCheck,
		resolvedPreparedLadderMarkerMismatchCheck
	} =
		Transpose[MapThread[Function[
			{
				myMapLadder,
				myMapOptions,
				myPreparedLadderRunningBuffer,
				myPreparedLadderMarker
			},
			Module[
				{(*suppliedLadderOptions*)
					suppliedLadderVolume,
					suppliedLadderLoadingBuffer,
					suppliedLadderLoadingBufferVolume,
					suppliedLadderRunningBuffer,
					suppliedLadderMarker,
					(*analysisMethodLadderOptions*)
					analysisMethodLadderVolume,
					analysisMethodLadderLoadingBuffer,
					analysisMethodLadderLoadingBufferVolume,
					analysisMethodLadderRunningBuffer,
					analysisMethodLadderMarker,
					(*resolvedLadderOptions*)
					ladderVolume,
					ladderLoadingBuffer,
					ladderLoadingBufferVolume,
					ladderRunningBuffer,
					ladderMarker,
					(*ladderOptionsErrors*)
					ladderPreparedPlateMismatchError,
					ladderOptionsPreparedPlateMismatchOptions,
					ladderOptionsPreparedPlateErrors,
					ladderVolumeMismatchError,
					ladderLoadingBufferMismatchError,
					ladderLoadingBufferVolumeMismatchError,
					ladderRunningBufferMismatchError, totalLadderSolutionVolume,
					maxLadderVolumeError,
					maxLadderVolumeBadOptions,
					analysisMethodLadderMismatchWarning,
					analysisMethodLadderOptionsMismatchCheck,
					analysisMethodLadderOptionsMismatchList,
					analysisMethodLadderOptionsMismatchWarning,
					ladderMarkerMismatchError,
					preparedLadderRunningBufferMismatchCheck,
					preparedLadderMarkerMismatchCheck
				},
				
				(* Setup our error tracking variables *)
				{
					ladderPreparedPlateMismatchError,
					ladderOptionsPreparedPlateErrors,
					ladderVolumeMismatchError,
					ladderLoadingBufferVolumeMismatchError,
					ladderRunningBufferMismatchError,
					maxLadderVolumeError,
					analysisMethodLadderMismatchWarning,
					analysisMethodLadderOptionsMismatchWarning,
					ladderMarkerMismatchError
				} = ConstantArray[False, 9];
				
				(*get supplied values*)
				suppliedLadderVolume = Lookup[myMapOptions, LadderVolume];
				suppliedLadderLoadingBuffer = Lookup[myMapOptions, LadderLoadingBuffer];
				suppliedLadderLoadingBufferVolume = Lookup[myMapOptions, LadderLoadingBufferVolume];
				suppliedLadderRunningBuffer = Lookup[myMapOptions, LadderRunningBuffer];
				suppliedLadderMarker = Lookup[myMapOptions, LadderMarker];
				
				(*get the field values in the resolvedAnalysisMethod*)
				{
					analysisMethodLadderVolume,
					analysisMethodLadderLoadingBuffer,
					analysisMethodLadderLoadingBufferVolume,
					analysisMethodLadderRunningBuffer,
					analysisMethodLadderMarker
				} =
					fastAssocLookup[fastAssoc, resolvedAnalysisMethod, #]& /@ {
						LadderVolume,
						LadderLoadingBuffer,
						LadderLoadingBufferVolume,
						LadderRunningBuffer,
						LadderMarker
					};

				(*LadderVolume Resolution*)
				ladderVolume = Which[
					(*If not Automatic, set to suppliedLadderVolume*)
					MatchQ[suppliedLadderVolume, Except[Automatic]],
					suppliedLadderVolume,
					
					(*If suppliedLadderVolume is Automatic AND, resolvedPreparedPlate is True OR ladder is Null, option is not applicable and is set to Null*)
					MatchQ[resolvedPreparedPlate, True] || MatchQ[myMapLadder, Null],
					Null,
					
					(*If suppliedLadderVolume is Automatic AND resolvedPreparedPlate is False AND there is a specified Ladder AND analysisMethodLadderVolume is Not Null, set to field value in AnalysisMethod*)
					MatchQ[analysisMethodLadderVolume, Except[Null]],
					analysisMethodLadderVolume,
					
					(*If suppliedLadderVolume is Automatic AND resolvedPreparedPlate is False AND there is a specified Ladder AND analysisMethodLadderVolume is Null, set to a reasonable value*)
					MatchQ[analysisMethodLadderVolume, Null],
					24 Microliter
				];
				
				(*LadderLoadingBuffer Resolution*)
				ladderLoadingBuffer = Which[
					(*If not Automatic, set to suppliedLadderLoadingBuffer*)
					MatchQ[suppliedLadderLoadingBuffer, Except[Automatic]],
					suppliedLadderLoadingBuffer,
					
					(*If suppliedLadderLoadingBuffer is Automatic AND resolvedPreparedPlate is True, option is not applicable and is set to Null*)
					MatchQ[resolvedPreparedPlate, True],
					Null,
					
					(*If suppliedLadderLoadingBuffer is Automatic AND resolvedPreparedPlate is False AND there is no specified Ladder, set to Null*)
					MatchQ[myMapLadder, Null],
					Null,
					
					(*If suppliedLadderLoadingBuffer is Automatic AND resolvedPreparedPlate is False AND there is a specified Ladder, set to field value in AnalysisMethod*)
					MatchQ[myMapLadder, Except[Null]],
					analysisMethodLadderLoadingBuffer
				];
				
				(*LadderLoadingBufferVolume Resolution*)
				ladderLoadingBufferVolume = Which[
					(*If not Automatic, set to suppliedLadderLoadingBufferVolume*)
					MatchQ[suppliedLadderLoadingBufferVolume, Except[Automatic]],
					suppliedLadderLoadingBufferVolume,
					
					(*If suppliedLadderLoadingBufferVolume is Automatic AND resolvedPreparedPlate is True, option is not applicable and is set to Null*)
					MatchQ[resolvedPreparedPlate, True],
					Null,
					
					(*If suppliedLadderLoadingBufferVolume is Automatic AND resolvedPreparedPlate is False AND there is no specified LadderLoadingBuffer, set to Null*)
					MatchQ[ladderLoadingBuffer, Null],
					Null,
					
					(*If suppliedLadderLoadingBufferVolume is Automatic AND resolvedPreparedPlate is False AND there is a specified LadderLoadingBuffer AND the analysisMethodLadderLoadingBufferVolume is Not Null, set to field value in AnalysisMethod*)
					MatchQ[analysisMethodLadderLoadingBufferVolume, Except[Null]],
					analysisMethodLadderLoadingBufferVolume,
					
					(*If suppliedLadderLoadingBufferVolume is Automatic AND resolvedPreparedPlate is False AND there is a specified LadderLoadingBuffer AND the analysisMethodLadderLoadingBufferVolume is Null, set to a reasonable value*)
					True,
					18 Microliter
				];
				
				(*LadderRunningBuffer Resolution*)
				ladderRunningBuffer = Which[
					(*If not Automatic, set to suppliedLadderRunningBuffer*)
					MatchQ[suppliedLadderRunningBuffer, Except[Automatic]],
					suppliedLadderRunningBuffer,
					
					(*If suppliedLadderRunningBuffer is Automatic AND there is no specified Ladder, set to Null*)
					MatchQ[myMapLadder, Null],
					Null,
					
					(*If suppliedLadderRunningBuffer is Automatic AND suppliedPreparedRunningBufferPlate is an Object[Container,Plate]*)
					MatchQ[resolvedPreparedRunningBufferPlate, ObjectP[Object[Container, Plate]]],
					myPreparedLadderRunningBuffer,
					
					(*If suppliedLadderRunningBuffer is Automatic AND there is a specified Ladder AND analysisMethodLadderRunningBuffer is Not Null, set to field value in AnalysisMethod*)
					MatchQ[analysisMethodLadderRunningBuffer, Except[Null]],
					analysisMethodLadderRunningBuffer,
					
					(*If suppliedLadderRunningBuffer is Automatic AND there is a specified Ladder AND analysisMethodLadderRunningBuffer is Null, set to a reasonable value - LadderRunningBuffer is required for Ladder*)
					True,
					Model[Sample, StockSolution, "1x Running Buffer for ExperimentFragmentAnalysis"]
				];
				
				(*LadderMarker Resolution*)
				ladderMarker = Which[
					(*If not Automatic, set to suppliedLadderMarker*)
					MatchQ[suppliedLadderMarker, Except[Automatic]],
					suppliedLadderMarker,
					
					(*If suppliedLadderMarker is Automatic AND suppliedPreparedMarkerPlate is an Object[Container,Plate]*)
					MatchQ[resolvedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]],
					myPreparedLadderMarker,
					
					(*If suppliedLadderMarker is Automatic AND, there is no specified Ladder OR resolvedMarkerInjection is False, set to Null*)
					MatchQ[myMapLadder, Null] || MatchQ[resolvedMarkerInjection, False],
					Null,
					
					(*If suppliedLadderMarker is Automatic AND there is a specified Ladder, set to field value in AnalysisMethod; LadderMarker is not required for Ladder*)
					MatchQ[analysisMethodLadderMarker, Except[Null]],
					analysisMethodLadderMarker,
					
					(*If suppliedLadderMarker is Automatic AND there is a specified Ladder, set to field value in AnalysisMethod; LadderMarker is not required for Ladder so a Null value can be in the AnalysisMethod*)
					True,
					Model[Sample, "75 bp and 20000 bp Markers for ExperimentFragmentAnalysis"]
				];
				
				(*Error Checking*)
				(*If PreparedPlate is True AND Ladder is an object, throw and Error*)
				(*If PreparedPlate is False AND Ladder is a WellPositionP, throw an Error*)
				ladderPreparedPlateMismatchError = Or[
					MatchQ[resolvedPreparedPlate, True] && MatchQ[myMapLadder, ObjectP[]],
					MatchQ[resolvedPreparedPlate, False] && MatchQ[myMapLadder, WellPositionP]
				];
				
				(*If PreparedPlate is True, LadderVolume,LadderLoadingBuffer,LadderLoadingBufferVolume must be Null,otherwise throw an Error for the Ladder*)
				ladderOptionsPreparedPlateMismatchOptions = If[MatchQ[resolvedPreparedPlate, True] && MemberQ[{ladderVolume, ladderLoadingBuffer, ladderLoadingBufferVolume}, Except[Null]],
					(*list of erroneous options - those that are not Null*)
					PickList[{LadderVolume, LadderLoadingBuffer, LadderLoadingBufferVolume}, Map[MatchQ[#, Except[Null]]&, {ladderVolume, ladderLoadingBuffer, ladderLoadingBufferVolume}]],
					(*all relevant options are Null*)
					{}
				];
				
				ladderOptionsPreparedPlateErrors = Length[ladderOptionsPreparedPlateMismatchOptions] > 0;
				
				(*If PreparedPlate is False AND Ladder is Null AND LadderVolume is not Null, throw an error*)
				(*If PreparedPlate is False AND Ladder is not Null AND LadderVolume is Null, throw an error*)
				ladderVolumeMismatchError = Or[
					MatchQ[resolvedPreparedPlate, False] && MatchQ[myMapLadder, Null] && MatchQ[ladderVolume, Except[Null]],
					MatchQ[resolvedPreparedPlate, False] && MatchQ[myMapLadder, Except[Null]] && MatchQ[ladderVolume, Null]
				];
				
				(*If PreparedPlate is False AND Ladder is Null AND LadderLoadingBuffer is not Null, throw an error*)
				ladderLoadingBufferMismatchError = MatchQ[resolvedPreparedPlate, False] && MatchQ[myMapLadder, Null] && MatchQ[ladderLoadingBuffer, Except[Null]];
				
				(*If PreparedPlate is False AND LadderLoadingBuffer is Null AND LadderLoadingBufferVolume is not Null, throw an error*)
				(*If PreparedPlate is False AND LadderLoadingBuffer is not Null AND LadderLoadingBufferVolume is Null, throw an error*)
				ladderLoadingBufferVolumeMismatchError = Or[
					MatchQ[resolvedPreparedPlate, False] && MatchQ[ladderLoadingBuffer, Null] && MatchQ[ladderLoadingBufferVolume, Except[Null]],
					MatchQ[resolvedPreparedPlate, False] && MatchQ[ladderLoadingBuffer, Except[Null]] && MatchQ[ladderLoadingBufferVolume, Null]
				];
				
				(*LadderRunningBuffer is required is Ladder is not Null*)
				(*If Ladder is Null AND LadderRunningBuffer is not Null, throw an error*)
				(*If Ladder is not Null AND LadderRunningBuffer is Null, throw an error*)
				ladderRunningBufferMismatchError = Or[
					MatchQ[myMapLadder, Null] && MatchQ[ladderRunningBuffer, Except[Null]],
					MatchQ[myMapLadder, Except[Null]] && MatchQ[ladderRunningBuffer, Null]
				];
				
				(*LadderMarker is not required if Ladder is not Null*)
				(*If Ladder is Null AND LadderMarker is not Null, throw an error*)
				ladderMarkerMismatchError = MatchQ[myMapLadder, Null] && MatchQ[ladderMarker, Except[Null]];
				
				(*get the total solution volume that goes in the well, if any*)
				totalLadderSolutionVolume = Plus @@ Select[{ladderVolume, ladderLoadingBufferVolume}, QuantityQ];
				
				(*If totalLadderSolutionVolume is a Quantity AND greater than 200 Microliter, throw an Error*)
				maxLadderVolumeError = If[QuantityQ[totalLadderSolutionVolume],
					MatchQ[totalLadderSolutionVolume, GreaterP[200 Microliter]],
					False
				];
				
				(*If totalLadderSolutionVolume is greater than 200 Microliter, identify the options with quantity values and assign as bad options*)
				maxLadderVolumeBadOptions = If[MatchQ[maxLadderVolumeError, True],
					PickList[{LadderVolume, LadderLoadingBuffer}, Map[QuantityQ[#]&, {ladderVolume, ladderLoadingBufferVolume}]],
					{}
				];
				
				(*If the Ladder does not match the Ladder value in the AnalysisMethod, throw a Warning. This check is not applicable for a PreparedPlate.*)
				analysisMethodLadderMismatchWarning = If[resolvedPreparedPlate,
					False,
					analysisMethodOptionsCheckFunction[Ladder, myMapLadder]
				];
				
				(*Check each relevant option if it matches the AnalysisMethod. Set Check to True for each option that does not match.*)
				analysisMethodLadderOptionsMismatchCheck = Which[
					(*If PreparedPlate is True AND there is a specified Ladder, check values of LadderRunningBuffer and LadderMarker*)
					(*Options LadderVolume,LadderLoadingBuffer,LadderLoadingBufferVolume are not applicable in a PreparedPlate and will not be checked*)
					resolvedPreparedPlate && MatchQ[myMapLadder, Except[Null]],
					MapThread[analysisMethodOptionsCheckFunction[#1, #2]&, {{LadderRunningBuffer, LadderMarker}, {ladderRunningBuffer, ladderMarker}}],
					
					(*If PreparedPlate is True AND there is no specified Ladder, no need to check against AnalysisMethod*)
					resolvedPreparedPlate && MatchQ[myMapLadder, Null],
					{False, False},
					
					(*If PreparedPlate is False, check LadderVolume,LadderLoadingBuffer,LadderLoadingBufferVolume,LadderRunningBuffer,LadderMarker*)
					!resolvedPreparedPlate,
					MapThread[analysisMethodOptionsCheckFunction[#1, #2]&, {{LadderVolume, LadderLoadingBuffer, LadderLoadingBufferVolume, LadderRunningBuffer, LadderMarker}, {ladderVolume, ladderLoadingBuffer, ladderLoadingBufferVolume, ladderRunningBuffer, ladderMarker}}]
				];
				
				(*Identify the relevant options that does not match the AnalysisMethod*)
				analysisMethodLadderOptionsMismatchList = Which[
					(*If none of the mismatch checks is True, return empty list of mismatched options*)
					MatchQ[MemberQ[analysisMethodLadderOptionsMismatchCheck, True], False],
					{},
					
					(*If PreparedPlate is False and one or more of the mismatch checks is True, return list of relevant options that did not match the AnalysisMethod*)
					MatchQ[MemberQ[analysisMethodLadderOptionsMismatchCheck, True], True] && MatchQ[resolvedPreparedPlate, False],
					PickList[{LadderVolume, LadderLoadingBuffer, LadderLoadingBufferVolume, LadderRunningBuffer, LadderMarker}, analysisMethodLadderOptionsMismatchCheck],
					
					(*If PreparedPlate is True and one or more of the mismatch checks is True, return list of relevant options that did not match the AnalysisMethod*)
					MatchQ[MemberQ[analysisMethodLadderOptionsMismatchCheck, True], True] && MatchQ[resolvedPreparedPlate, True],
					PickList[{LadderRunningBuffer, LadderMarker}, analysisMethodLadderOptionsMismatchCheck]
				];
				
				(*Throw a Warning for each Ladder that have relevant option(s) that does not match the AnalysisMethod*)
				analysisMethodLadderOptionsMismatchWarning = Length[analysisMethodLadderOptionsMismatchList] > 0;
				
				(*If resolvedPreparedRunningBufferPlate is an Object[Container,Plate], ladderRunningBuffer and ladderMarker must match the Contents*)
				preparedLadderRunningBufferMismatchCheck = If[MatchQ[ladderRunningBuffer,Null],
					!MatchQ[myPreparedLadderRunningBuffer, Null],
					!MatchQ[myPreparedLadderRunningBuffer, ObjectP[ladderRunningBuffer]]
				];
				
				preparedLadderMarkerMismatchCheck = If[MatchQ[ladderMarker,Null],
					!MatchQ[myPreparedLadderMarker, Null],
					!MatchQ[myPreparedLadderMarker, ObjectP[ladderMarker]]
				];
				
				(* Gather MapThread results *)
				{
					ladderVolume,
					ladderLoadingBuffer,
					ladderLoadingBufferVolume,
					ladderRunningBuffer,
					ladderMarker,
					ladderPreparedPlateMismatchError,
					ladderOptionsPreparedPlateMismatchOptions,
					ladderOptionsPreparedPlateErrors,
					ladderVolumeMismatchError,
					ladderLoadingBufferMismatchError,
					ladderLoadingBufferVolumeMismatchError,
					ladderRunningBufferMismatchError,
					ladderMarkerMismatchError,
					totalLadderSolutionVolume,
					maxLadderVolumeError,
					maxLadderVolumeBadOptions,
					analysisMethodLadderMismatchWarning,
					analysisMethodLadderOptionsMismatchList,
					analysisMethodLadderOptionsMismatchWarning,
					preparedLadderRunningBufferMismatchCheck,
					preparedLadderMarkerMismatchCheck
				}
			]
		],
			{listedResolvedLadder, ladderMapThreadFriendlyOptions, preparedLadderRunningBufferObjects, preparedLadderMarkerObjects}
		]];
	
	preparedSampleRunningBufferObjects = If[MatchQ[suppliedPreparedRunningBufferPlate, ObjectP[Object[Container, Plate]]],
		Take[preparedRunningBufferPlateContentsObjects, Length[simulatedSamples]],
		Table[Null, Length[simulatedSamples]]
	];
	
	preparedSampleMarkerObjects = If[MatchQ[suppliedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]],
		Take[preparedMarkerPlateContentsObjects, Length[simulatedSamples]],
		Table[Null, Length[simulatedSamples]]
	];
	
	(*Resolution of Index-Matched AnalysisMethod Options of Samples*)
	(* MapThread over each of our samples.*)
	{
		resolvedSampleDilution,
		resolvedSampleDiluent,
		resolvedSampleVolume,
		resolvedCantCalculateSampleVolumeWarning,
		resolvedSampleDiluentVolume,
		resolvedCantCalculateSampleDiluentVolumeWarning,
		resolvedSampleLoadingBuffer,
		resolvedSampleLoadingBufferVolume,
		resolvedSampleRunningBuffer,
		resolvedSampleMarker,
		resolvedSampleOptionsPreparedPlateMismatchOptions,
		resolvedSampleOptionsPreparedPlateError,
		resolvedSampleDilutionMismatchOptions,
		resolvedSampleDilutionMismatchErrors,
		resolvedSampleLoadingBufferVolumeMismatchError,
		resolvedTotalSampleSolutionVolume,
		resolvedMaxSampleVolumeError,
		resolvedMaxSampleVolumeBadOptions,
		resolvedAnalysisMethodSampleOptionsMismatchList,
		resolvedAnalysisMethodSampleOptionsMismatchWarning,
		resolvedPreparedSampleRunningBufferMismatchCheck,
		resolvedPreparedSampleMarkerMismatchCheck,
		resolvedSampleVolumeErrors
	} =
		Transpose[MapThread[Function[{myMapThreadSamples, myMapThreadOptions, myMapSampleConcentrations, myPreparedSampleRunningBuffers, myPreparedSampleMarkers},
			Module[
				{(*suppliedOptions*)suppliedSampleVolume, suppliedSampleDilution, suppliedSampleDiluent, suppliedSampleDiluentVolume, suppliedSampleLoadingBuffer, suppliedSampleLoadingBufferVolume, suppliedSampleRunningBuffer, suppliedSampleMarker, (*analysisMethodOptions*)analysisMethodSampleLoadingBuffer, analysisMethodSampleLoadingBufferVolume, analysisMethodSampleRunningBuffer, analysisMethodSampleMarker, (*resolvedOptions*)sampleDilution, sampleDiluent, sampleVolume, targetSampleVolume, sampleDiluentVolume, maxTargetMassConcentration, cantCalculateSampleVolumeWarning, cantCalculateSampleDiluentVolumeWarning, sampleLoadingBuffer, sampleLoadingBufferVolume, sampleRunningBuffer, sampleMarker, sampleOptionsPreparedPlateMismatchCheck, sampleOptionsPreparedPlateMismatchOptions, sampleOptionsPreparedPlateError, sampleDilutionMismatchOptions, sampleVolumeError,
					sampleDilutionMismatchErrors, sampleLoadingBufferVolumeMismatchError, dilutedSampleVolume, totalSampleSolutionVolume, maxSampleVolumeError, maxSampleVolumeBadOptions, analysisMethodSampleOptionsMismatchCheck, analysisMethodSampleOptionsMismatchList, analysisMethodSampleOptionsMismatchWarning, preparedSampleRunningBufferMismatchCheck, preparedSampleMarkerMismatchCheck},
				
				
				(* Setup our error tracking variables
				{}=ConstantArray[False,1];
				*)
				(*get supplied values*)
				suppliedSampleVolume = Lookup[myMapThreadOptions, SampleVolume];
				suppliedSampleDilution = Lookup[myMapThreadOptions, SampleDilution];
				suppliedSampleDiluent = Lookup[myMapThreadOptions, SampleDiluent];
				suppliedSampleDiluentVolume = Lookup[myMapThreadOptions, SampleDiluentVolume];
				suppliedSampleLoadingBuffer = Lookup[myMapThreadOptions, SampleLoadingBuffer];
				suppliedSampleLoadingBufferVolume = Lookup[myMapThreadOptions, SampleLoadingBufferVolume];
				suppliedSampleRunningBuffer = Lookup[myMapThreadOptions, SampleRunningBuffer];
				suppliedSampleMarker = Lookup[myMapThreadOptions, SampleMarker];
				
				(*get the field values in the resolvedAnalysisMethod*)
				{
					analysisMethodSampleLoadingBuffer,
					analysisMethodSampleLoadingBufferVolume,
					analysisMethodSampleRunningBuffer,
					analysisMethodSampleMarker
				} =
					fastAssocLookup[fastAssoc, resolvedAnalysisMethod, #]& /@ {
						SampleLoadingBuffer,
						SampleLoadingBufferVolume,
						SampleRunningBuffer,
						SampleMarker
					};
				
				(*SampleDilution Resolution*)
				sampleDilution = suppliedSampleDilution;
				
				(*SampleDiluent Resolution*)
				sampleDiluent = Which[
					(*If not Automatic, set to suppliedSampleDiluent*)
					MatchQ[suppliedSampleDiluent, Except[Automatic]],
					suppliedSampleDiluent,
					
					(*If suppliedSampleDiluent is Automatic AND, resolvedPreparedPlate is True OR sampleDilution is False, option is not applicable and is set to Null*)
					MatchQ[resolvedPreparedPlate, True] || MatchQ[sampleDilution, False],
					Null,
					
					(*If suppliedSampleDiluent is Automatic AND sampleDilution is True, set to a reasonable default*)
					True,
					Model[Sample, "id:pZx9jox9zPK5"](*Model[Sample, "1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"]*)
				];
				
				(*In order to resolve SampleVolume and SampleDiluentVolume, find TargetSampleVolume and MaxTargetMassConcentration fields of the resolvedAnalysisMethod*)
				targetSampleVolume = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, TargetSampleVolume];
				maxTargetMassConcentration = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, MaxTargetMassConcentration];
				
				(*SampleVolume Resolution*)
				sampleVolume = Which[
					(*If not Automatic, set to suppliedSampleVolume*)
					MatchQ[suppliedSampleVolume, Except[Automatic]],
					suppliedSampleVolume,
					
					(*If suppliedSampleVolume is Automatic AND resolvedPreparedPlate is True, option is not applicable and is set to Null*)
					MatchQ[resolvedPreparedPlate, True],
					Null,
					
					(*If suppliedSampleVolume is Automatic AND resolvedPreparedPlate is False AND sampleDilution is False, set to TargetSampleVolume of the AnalysisMethod*)
					MatchQ[sampleDilution, False],
					targetSampleVolume,
					
					(*If sampleDilution is True AND myMapSampleConcentrations (including Null and 0) is not greater than maxTargetMassConcentration, set to Null and throw Warning*)
					!MatchQ[myMapSampleConcentrations, GreaterP[maxTargetMassConcentration]],
					cantCalculateSampleVolumeWarning = True;
					targetSampleVolume,
					
					(*If sampleDilution is True AND myMapSampleConcentrations is greater than maxTargetMassConcentration AND suppliedSampleDiluentVolume is Automatic, calculate sampleVolume based on sampleAnalyteConcentration, field values (TargetSampleVolume, and MaxTargetMassConcentration) of the AnalysisMethod*)
					MatchQ[myMapSampleConcentrations, GreaterP[maxTargetMassConcentration]] && MatchQ[suppliedSampleDiluentVolume, Automatic],
					maxTargetMassConcentration * targetSampleVolume / myMapSampleConcentrations,
					
					(*If sampleDilution is True AND myMapSampleConcentrations is greater than maxTargetMassConcentration AND suppliedSampleDiluentVolume is a volume quantity, calculate sampleVolume based on sampleAnalyteConcentration, suppliedSampleDiluentVolume and maxTargetMassConcentration*)
					MatchQ[myMapSampleConcentrations, GreaterP[maxTargetMassConcentration]] && MatchQ[suppliedSampleDiluentVolume, VolumeP],
					maxTargetMassConcentration * suppliedSampleDiluentVolume / (myMapSampleConcentrations - maxTargetMassConcentration),
					
					(*If sampleDilution is True AND myMapSampleConcentrations is greater than maxTargetMassConcentration AND suppliedSampleDiluentVolume is not a volume quantity (Null), set to Null and throw Error*)
					MatchQ[myMapSampleConcentrations, GreaterP[maxTargetMassConcentration]] && !MatchQ[suppliedSampleDiluentVolume, VolumeP],
					cantCalculateSampleVolumeWarning = True;
					targetSampleVolume
				];
				
				(*SampleDiluentVolume Resolution*)
				sampleDiluentVolume = Which[
					(*If not Automatic, set to suppliedSampleDiluentVolume*)
					MatchQ[suppliedSampleDiluentVolume, Except[Automatic]],
					suppliedSampleDiluentVolume,
					
					(*If suppliedSampleDiluentVolume is Automatic AND resolvedPreparedPlate is True, OR If suppliedSampleDiluentVolume is Automatic AND sampleDilution is False, option is not applicable and is set to Null*)
					MatchQ[resolvedPreparedPlate, True],
					Null,
					
					MatchQ[sampleDilution, False],
					Null,
					
					(*If suppliedSampleDiluentVolume is Automatic AND resolvedPreparedPlate is False AND sampleDilution is True AND sampleVolume is less than targetSampleVolume, calculate using sampleVolume and targetSampleVolume*)
					MatchQ[sampleVolume, LessP[targetSampleVolume]],
					targetSampleVolume - sampleVolume,
					
					(*If suppliedSampleDiluentVolume is Automatic AND resolvedPreparedPlate is False AND sampleDilution is True AND sampleVolume (including Null) is not less than targetSampleVolume, set to targetSampleVolume*)
					!MatchQ[sampleVolume, LessP[targetSampleVolume]],
					cantCalculateSampleDiluentVolumeWarning = True;
					targetSampleVolume
				];
				
				(*SampleLoadingBuffer Resolution*)
				sampleLoadingBuffer = Which[
					(*If not Automatic, set to suppliedSampleLoadingBuffer*)
					MatchQ[suppliedSampleLoadingBuffer, Except[Automatic]],
					suppliedSampleLoadingBuffer,
					
					(*If suppliedSampleLoadingBuffer is Automatic AND resolvedPreparedPlate is True, option is not applicable and is set to Null*)
					MatchQ[resolvedPreparedPlate, True],
					Null,
					
					(*If suppliedSampleLoadingBuffer is Automatic AND suppliedSampleLoadingBufferVolume is Null, option is not applicable and is set to Null*)
					MatchQ[suppliedSampleLoadingBufferVolume, Null],
					Null,
					
					(*If suppliedSampleLoadingBuffer is Automatic AND resolvedPreparedPlate is False, set to field value in AnalysisMethod*)
					True,
					fastAssocLookup[fastAssoc, resolvedAnalysisMethod, SampleLoadingBuffer]
				];
				
				(*SampleLoadingBufferVolume Resolution*)
				sampleLoadingBufferVolume = Which[
					(*If not Automatic, set to suppliedSampleLoadingBufferVolume*)
					MatchQ[suppliedSampleLoadingBufferVolume, Except[Automatic]],
					suppliedSampleLoadingBufferVolume,
					
					(*If suppliedSampleLoadingBufferVolume is Automatic AND, resolvedPreparedPlate is True OR there is no specified SampleLoadingBuffer, option is not applicable and is set to Null*)
					MatchQ[resolvedPreparedPlate, True],
					Null,
					
					MatchQ[sampleLoadingBuffer, Null],
					Null,
					
					(*If suppliedSampleLoadingBufferVolume is Automatic AND resolvedPreparedPlate is False AND there is a specified SampleLoadingBuffer, set to field value in AnalysisMethod, if not Null*)
					MatchQ[analysisMethodSampleLoadingBufferVolume, Except[Null]],
					analysisMethodSampleLoadingBufferVolume,
					
					(*If suppliedSampleLoadingBufferVolume is Automatic AND resolvedPreparedPlate is False AND there is a specified SampleLoadingBuffer BUT the value of analysisMethodSampleLoadingBufferVolume is Null, set to a reasonable default*)
					True,
					22 Microliter
				];
				
				(*SampleRunningBuffer Resolution*)
				sampleRunningBuffer = Which[
					(*If not Automatic, set to suppliedSampleRunningBuffer*)
					MatchQ[suppliedSampleRunningBuffer, Except[Automatic]],
					suppliedSampleRunningBuffer,
					
					(*If suppliedSampleRunningBuffer is Automatic AND suppliedPreparedRunningBufferPlate is an Object[Container,Plate]*)
					MatchQ[resolvedPreparedRunningBufferPlate, ObjectP[Object[Container, Plate]]],
					myPreparedSampleRunningBuffers,
					
					(*If suppliedSampleRunningBuffer is Automatic, set to field value in AnalysisMethod*)
					True,
					fastAssocLookup[fastAssoc, resolvedAnalysisMethod, SampleRunningBuffer]
				];
				
				(*SampleMarker Resolution*)
				sampleMarker = Which[
					(*If not Automatic, set to suppliedSampleMarker*)
					MatchQ[suppliedSampleMarker, Except[Automatic]],
					suppliedSampleMarker,
					
					(*If suppliedSampleMarker is Automatic AND suppliedPreparedMarkerPlate is an Object[Container,Plate]*)
					MatchQ[resolvedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]],
					myPreparedSampleMarkers,
					
					(*If suppliedSampleMarker is Automatic AND resolvedMarkerInjection is False, set to Null*)
					MatchQ[resolvedMarkerInjection, False],
					Null,
					
					(*If suppliedSampleMarker is Automatic AND resolvedMarkerInjection is True and analysisMethodSampleMarker is Not Null, set to field value of AnalysisMethod*)
					MatchQ[analysisMethodSampleMarker, Except[Null]],
					analysisMethodSampleMarker,
					
					(*If suppliedSampleMarker is Automatic AND resolvedMarkerInjection is True and analysisMethodSampleMarker is Null, set to a reasonable value*)
					True,
					Model[Sample, "id:pZx9jox9zPK5"](*Model[Sample, "1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"]*)
				];
				
				(*Error Checking*)
				
				(*If PreparedPlate is True, SampleDilution must be False and SampleDiluent,SampleVolume,SampleDiluentVolume,SampleLoadingBuffer, and SampleLoadingBufferVolume must be Null,otherwise throw an Error for the Sample*)
				sampleOptionsPreparedPlateMismatchCheck = Join[{MatchQ[sampleDilution, True]}, Map[MatchQ[#, Except[Null]]&, {sampleDiluent, sampleVolume, sampleDiluentVolume, sampleLoadingBuffer, sampleLoadingBufferVolume}]];
				
				sampleOptionsPreparedPlateMismatchOptions = If[MatchQ[resolvedPreparedPlate, True],
					PickList[{SampleDilution, SampleDiluent, SampleVolume, SampleDiluentVolume, SampleLoadingBuffer, SampleLoadingBufferVolume}, sampleOptionsPreparedPlateMismatchCheck],
					{}
				];
				
				sampleOptionsPreparedPlateError = Length[sampleOptionsPreparedPlateMismatchOptions] > 0;
				
				(*If PreparedPlate is False and SampleVolume is not a Quantity, throw an Error*)
				sampleVolumeError = MatchQ[resolvedPreparedPlate, False] && !QuantityQ[sampleVolume];
				
				(*If sampleDilution is True, sampleDiluent and sampleDiluentVolume must not be Null*)
				(*If sampleDilution is False, sampleDiluent and sampleDiluentVolume must be Null*)
				sampleDilutionMismatchOptions = Which[
					MatchQ[sampleDilution, True],
					PickList[{SampleDiluent, SampleDiluentVolume}, Map[MatchQ[#, Null]&, {sampleDiluent, sampleDiluentVolume}]],
					
					MatchQ[sampleDilution, False],
					PickList[{SampleDiluent, SampleDiluentVolume}, Map[MatchQ[#, Except[Null]]&, {sampleDiluent, sampleDiluentVolume}]]
				];
				
				(*If there are any sampleDilutionMismatchOptions, throw an Error*)
				sampleDilutionMismatchErrors = Length[sampleDilutionMismatchOptions] > 0;
				
				(*If SampleLoadingBuffer is Null AND SampleLoadingBufferVolume is Not Null, throw an Error*)
				(*If SampleLoadingBuffer is Not Null AND SampleLoadingBufferVolume is Null, throw an Error*)
				sampleLoadingBufferVolumeMismatchError = Or[
					MatchQ[sampleLoadingBuffer, Null] && MatchQ[sampleLoadingBufferVolume, Except[Null]],
					MatchQ[sampleLoadingBuffer, Except[Null]] && MatchQ[sampleLoadingBufferVolume, Null]
				];
				
				(*get the total solution volume that goes in the well, if any*)
				totalSampleSolutionVolume = Plus @@ Select[{sampleVolume, sampleDiluentVolume, sampleLoadingBufferVolume}, QuantityQ];
				
				(*If totalSampleSolutionVolume is a Quantity AND greater than 200 Microliter, throw an Error*)
				maxSampleVolumeError = MatchQ[totalSampleSolutionVolume, GreaterP[200 Microliter]];
				
				(*If totalSampleSolutionVolume is greater than 200 Microliter, identify the options with quantity values and assign as bad options*)
				maxSampleVolumeBadOptions = If[MatchQ[maxSampleVolumeError, True],
					PickList[{SampleVolume, SampleDiluentVolume, SampleLoadingBufferVolume}, Map[QuantityQ[#]&, {sampleVolume, sampleDiluentVolume, sampleLoadingBufferVolume}]],
					{}
				];
				
				(*If both SampleVolume and SampleDiluentVolume have Volumes, add to get the dilutedSampleVolume and check against TargetSampleVolume*)
				dilutedSampleVolume = If[QuantityQ[sampleDiluentVolume] && QuantityQ[sampleVolume],
					sampleVolume + sampleDiluentVolume,
					sampleVolume
				];
				
				analysisMethodSampleOptionsMismatchCheck = Which[
					MatchQ[resolvedPreparedPlate, True],
					MapThread[analysisMethodOptionsCheckFunction[#1, #2]&, {{SampleRunningBuffer, SampleMarker}, {sampleRunningBuffer, sampleMarker}}],
					
					(*If SampleDiluentVolume is not a Quantity, only check SampleVolume and warning thrown only for SampleVolume*)
					!MatchQ[resolvedPreparedPlate, True] && !QuantityQ[sampleDiluentVolume],
					MapThread[analysisMethodOptionsCheckFunction[#1, #2]&, {{TargetSampleVolume, SampleLoadingBuffer, SampleLoadingBufferVolume, SampleRunningBuffer, SampleMarker}, {dilutedSampleVolume, sampleLoadingBuffer, sampleLoadingBufferVolume, sampleRunningBuffer, sampleMarker}}],
					
					(*If SampleDiluentVolume is a Quantity, only check dilutedSampleVolume twice (once for SampleVolume, once for SampleDiluentVolume) and warning thrown both SampleVolume and SampleDiluentVolume options*)
					!MatchQ[resolvedPreparedPlate, True] && QuantityQ[sampleDiluentVolume],
					MapThread[analysisMethodOptionsCheckFunction[#1, #2]&, {{TargetSampleVolume, TargetSampleVolume, SampleLoadingBuffer, SampleLoadingBufferVolume, SampleRunningBuffer, SampleMarker}, {dilutedSampleVolume, dilutedSampleVolume, sampleLoadingBuffer, sampleLoadingBufferVolume, sampleRunningBuffer, sampleMarker}}]
				];
				
				analysisMethodSampleOptionsMismatchList = Which[
					MatchQ[MemberQ[analysisMethodSampleOptionsMismatchCheck, True], False],
					{},
					
					(*If SampleDiluentVolume is not a Quantity, only check SampleVolume and warning thrown only for SampleVolume*)
					MatchQ[MemberQ[analysisMethodSampleOptionsMismatchCheck, True], True] && MatchQ[resolvedPreparedPlate, False] && !QuantityQ[sampleDiluentVolume],
					PickList[{SampleVolume, SampleLoadingBuffer, SampleLoadingBufferVolume, SampleRunningBuffer, SampleMarker}, analysisMethodSampleOptionsMismatchCheck],
					
					(*If SampleDiluentVolume is a Quantity, only check dilutedSampleVolume twice (once for SampleVolume, once for SampleDiluentVolume) and warning thrown both SampleVolume and SampleDiluentVolume options*)
					MatchQ[MemberQ[analysisMethodSampleOptionsMismatchCheck, True], True] && MatchQ[resolvedPreparedPlate, False] && QuantityQ[sampleDiluentVolume],
					PickList[{SampleVolume, SampleDiluentVolume, SampleLoadingBuffer, SampleLoadingBufferVolume, SampleRunningBuffer, SampleMarker}, analysisMethodSampleOptionsMismatchCheck],
					
					MatchQ[MemberQ[analysisMethodSampleOptionsMismatchCheck, True], True] && MatchQ[resolvedPreparedPlate, True],
					PickList[{SampleRunningBuffer, SampleMarker}, analysisMethodSampleOptionsMismatchCheck]
				];
				
				analysisMethodSampleOptionsMismatchWarning = Length[analysisMethodSampleOptionsMismatchList] > 0;
				
				(*If resolvedPreparedRunningBufferPlate is an Object[Container,Plate], sampleRunningBuffer and sampleMarker must match the Contents*)
				preparedSampleRunningBufferMismatchCheck = !MatchQ[myPreparedSampleRunningBuffers, ObjectP[sampleRunningBuffer] | sampleRunningBuffer];
				
				(*If resolvedPreparedMarkerPlate is an Object[Container,Plate], sampleMarker must match the Contents*)
				preparedSampleMarkerMismatchCheck = !MatchQ[myPreparedSampleMarkers, ObjectP[sampleMarker] | sampleMarker];
				
				(* Gather MapThread results *)
				{
					sampleDilution,
					sampleDiluent,
					sampleVolume,
					cantCalculateSampleVolumeWarning,
					sampleDiluentVolume,
					cantCalculateSampleDiluentVolumeWarning,
					sampleLoadingBuffer,
					sampleLoadingBufferVolume,
					sampleRunningBuffer,
					sampleMarker,
					sampleOptionsPreparedPlateMismatchOptions,
					sampleOptionsPreparedPlateError,
					sampleDilutionMismatchOptions,
					sampleDilutionMismatchErrors,
					sampleLoadingBufferVolumeMismatchError,
					totalSampleSolutionVolume,
					maxSampleVolumeError,
					maxSampleVolumeBadOptions,
					analysisMethodSampleOptionsMismatchList,
					analysisMethodSampleOptionsMismatchWarning,
					preparedSampleRunningBufferMismatchCheck,
					preparedSampleMarkerMismatchCheck,
					sampleVolumeError
				}
			]
		],
			{simulatedSamples, mapThreadFriendlyOptions, resolvedSampleAnalyteConcentration, preparedSampleRunningBufferObjects, preparedSampleMarkerObjects}
		]];
	
	(* For non-prepared plate, there is a minimum of 11 blanks required to account for required retry positions *)
	numberOfBlanks = Which[

		(* if WellPositionP or list of WellPositionP, we count all wells specified *)
		MatchQ[suppliedBlank,WellPositionP|{WellPositionP..}],
		Length[ToList[suppliedBlank]],
		
		(* if suppliedBlank is a single ObjectP[] and blanks are needed, we calculate the needed blanks; the suppliedBlank is later expanded to a list with length numberOfBlanks*)
		MatchQ[suppliedBlank, ObjectP[]] && MatchQ[numberOfSamples + numberOfLadders, LessEqualP[85]],
		96 - numberOfSamples - numberOfLadders,

		(* if suppliedBlank is a single ObjectP[] and numberOfSamples + numberOfLadders > 85, set to 11 and TooManySolutionsForInjection is thrown later *)
		MatchQ[suppliedBlank, ObjectP[]],
		11,

		MatchQ[suppliedBlank,Null],
		0,
		
		(* anything else, turn to list and count *)
		MatchQ[suppliedBlank,Except[Automatic]],
		Length[ToList[suppliedBlank]],

		(* suppliedBlank is Automatic *)
		(*If PreparedPlate is True and no WellPositions are supplied in the Blank field, set to 0*)
		MatchQ[resolvedPreparedPlate, True],
		0,

		(*numberOfBlanks is dependent on how many samples and ladders are specified*)
		(* 85 is the max total of ladders and samples combined since 11 wells are always alotted for blanks *)
		MatchQ[numberOfSamples + numberOfLadders, LessEqualP[85]],
		96 - numberOfSamples - numberOfLadders,
		
		True,
		11 (* 11 wells are reserved for blanks, and also for samples to be moved into during the compiler if the selected CapillaryArray has CloggedChannels *)
	];
	
	ladderWells = Which[
		(* If using PreparedPlate and Ladder is Automatic, H12 is designated as a LadderWell *)
		MatchQ[resolvedPreparedPlate,True]&&MatchQ[suppliedLadder,Automatic],
		{"H12"},

		MatchQ[resolvedPreparedPlate, True],
		ToList[suppliedLadder]/.Automatic->Null,
		
		MatchQ[numberOfLadders,GreaterP[0]],
		(* ladders can only be placed from A1 to G12 and H12 since H1 to H11 is reserved for blanks, if only one ladder is requested, it goes to H12 by default*)
		Take[Flatten[Join[AllWells[][[1 ;; 7]], {"H12"}]], -numberOfLadders],
		
		True,
		{}
	];
	
	sampleWells = Which[
		MatchQ[resolvedPreparedPlate, True]&&plateModelError,
		fastAssocLookup[fastAssoc, #, Well]& /@ mySamples,
		
		MatchQ[resolvedPreparedPlate, True],
		fastAssocLookup[fastAssoc, #, Position]& /@ mySamples,
		
		True,
		Drop[DeleteElements[Flatten[AllWells[]], ladderWells], -numberOfBlanks]
	];
	
	blankWells = Which[
		(*If suppliedBlank is a well position or a list of well positions, take as is*)
		MatchQ[resolvedPreparedPlate,True]&&MatchQ[suppliedBlank,{WellPositionP..}|WellPositionP],
		ToList[suppliedBlank],

		MatchQ[resolvedPreparedPlate,True]&&MatchQ[suppliedBlank,Except[Automatic]],
		ToList[suppliedBlank]/.{Automatic->Null,ObjectP[]->Null},

		(*suppliedBlank is Automatic*)
		(* if resolvedPreparedPlate is True, no BlankWells*)
		MatchQ[resolvedPreparedPlate,True],
		{},
		
		True,
		DeleteElements[Flatten[AllWells[]],Join[{ladderWells,sampleWells}]]
	];
	
	numberOfSolutionsForInjection = numberOfSamples + numberOfLadders + numberOfBlanks;
	
	(*Blank Resolution*)
	(*Lookup the Blank from AnalysisMethod*)
	analysisMethodBlank = fastAssocLookup[fastAssoc, resolvedAnalysisMethod, Blank];
	
	resolvedBlank = Which[
		(* NO Automatics, take as is *)
		!MemberQ[ToList[suppliedBlank],Automatic],
		suppliedBlank,
		
		(*  Not Automatic (list with Automatic, Null or {Null..}), and resolvedPreparedPlate is True -  take as is and if there are any Automatic, replace with Null *)
		MatchQ[suppliedBlank,Except[Automatic]]&&MatchQ[resolvedPreparedPlate,True],
		suppliedBlank/.Automatic->Null,

		(* Not Automatic (list with Automatic, Null or {Null..}) and resolvedPreparedPlate is False, take as is and replace any Automatic with analysisMethodBlank if not Null *)
		MatchQ[suppliedBlank,Except[Automatic]]&&MatchQ[analysisMethodBlank,Except[Null]],
		suppliedBlank/.Automatic->analysisMethodBlank,

		(* Not Automatic (list with Automatic, Null or {Null..}) and resolvedPreparedPlate is False, take as is and replace any Automatic with reasonable value *)
		MatchQ[suppliedBlank,Except[Automatic]],
		suppliedBlank/.Automatic->Model[Sample, "1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"],

		(* suppliedBlank is Automatic *)
		(* If PreparedPlate is True and no well positions are specified as blanks, set to Null *)
		MatchQ[resolvedPreparedPlate,True],
		Null,
		
		(*if not User-specified AND resolvedPreparedPlate is False AND numberOfSolutionsForInjection is less than 96, set to field value of AnalysisMethod,if Not Null, and expand*)
		MatchQ[analysisMethodBlank, Except[Null]],
		ConstantArray[analysisMethodBlank,numberOfBlanks],
		
		(*if not User-specified AND resolvedPreparedPlate is False AND numberOfSolutionsForInjection is less than 96 AND field value of AnalysisMethod is Null, set to a reasonable value, and expand*)
		True,
		ConstantArray[Model[Sample, "1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"],numberOfBlanks]
	];
	
	listedResolvedBlank = ToList[resolvedBlank];

	(* Identify the contents matched to blanks of a PreparedRunningBufferPlate, if specified. Otherwise, create a list of Nulls to work with mapthread *)
	preparedBlankRunningBufferObjects = If[MatchQ[suppliedPreparedRunningBufferPlate, ObjectP[Object[Container, Plate]]]&&MatchQ[numberOfBlanks,GreaterP[0]],
		Drop[Drop[preparedRunningBufferPlateContentsObjects, numberOfSamples], -numberOfLadders],
		Table[Null, Length[listedResolvedBlank]]
	];
	
	(* Identify the contents matched to blanks of a PreparedMarkerPlate, if specified. Otherwise, create a list of Nulls to work with mapthread *)
	preparedBlankMarkerObjects = If[MatchQ[suppliedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]]&&MatchQ[numberOfBlanks,GreaterP[0]],
		Drop[Drop[preparedMarkerPlateContentsObjects, numberOfSamples], -numberOfLadders],
		Table[Null, Length[listedResolvedBlank]]
	];
	
	(*Index-matched Blank options*)
	(*use the listedResolvedBlank for the MapThread resolution*)

	(*Set-up the list of Blank-related options (keys) that are indexed-matched and needs to be resolved in a map thread*)
	blankOptions = {BlankRunningBuffer, BlankMarker};

	(*Lookup the values for the options and create a transposed list that groups key-values for each blank*)
	(* For cases of singleton Blank input that has been expanded to match the numberOfBlanks required, also expand the blankOptionValues to match*)
	blankOptionValues = If[!MatchQ[Length[Transpose[Lookup[roundedExperimentFragmentAnalysisOptions, blankOptions]]],Length[listedResolvedBlank]],
		ConstantArray[Transpose[Lookup[roundedExperimentFragmentAnalysisOptions, blankOptions]],Length[listedResolvedBlank]],
		Transpose[Lookup[roundedExperimentFragmentAnalysisOptions, blankOptions]]
	];

	(*Create the blankMapThreadFriendlyOptions that can be used for resolution in a MapThread*)
	blankMapThreadFriendlyOptions = MapThread[Function[optionFields, Association[MapThread[#1 -> #2&, {blankOptions, optionFields}]]], {blankOptionValues}];

	(*Resolution of Index-Matched AnalysisMethod Options of Blank*)
	(* MapThread over each of our blanks.*)
	{
		mapResolvedBlankRunningBuffer,
		mapResolvedBlankMarker,
		resolvedBlankPreparedPlateMismatchError,
		resolvedBlankRunningBufferMismatchError,
		resolvedBlankMarkerMismatchError,
		resolvedAnalysisMethodBlankMismatchWarning,
		resolvedAnalysisMethodBlankOptionsMismatchList,
		resolvedAnalysisMethodBlankOptionsMismatchWarning,
		resolvedPreparedBlankRunningBufferMismatchCheck,
		resolvedPreparedBlankMarkerMismatchCheck
	} = Transpose[MapThread[Function[
			{
				myBlank,
				myMapOptions,
				myPreparedBlankRunningBuffer,
				myPreparedBlankMarker
			},
			Module[
				{
					(*suppliedBlankOptions*)
					suppliedBlankRunningBuffer,
					suppliedBlankMarker,
					(*analysisMethodBlankOptions*)
					analysisMethodBlank,
					analysisMethodBlankRunningBuffer,
					analysisMethodBlankMarker,
					(*resolvedBlankOptions*)
					blankRunningBuffer,
					blankMarker,
					(*blankOptionsErrors*)
					blankPreparedPlateMismatchError,
					blankRunningBufferMismatchError,
					analysisMethodBlankMismatchWarning,
					analysisMethodBlankOptionsMismatchCheck,
					analysisMethodBlankOptionsMismatchList,
					analysisMethodBlankOptionsMismatchWarning,
					blankMarkerMismatchError,
					preparedBlankRunningBufferMismatchCheck,
					preparedBlankMarkerMismatchCheck
				},

				(* Setup our error tracking variables *)
				{
					blankPreparedPlateMismatchError,
					blankRunningBufferMismatchError,
					analysisMethodBlankMismatchWarning,
					analysisMethodBlankOptionsMismatchWarning,
					blankMarkerMismatchError
				} = ConstantArray[False, 5];

				(*get supplied values*)
				suppliedBlankRunningBuffer = Lookup[myMapOptions, BlankRunningBuffer];
				suppliedBlankMarker = Lookup[myMapOptions, BlankMarker];

				(*get the field values in the resolvedAnalysisMethod*)
				{
					analysisMethodBlank,
					analysisMethodBlankRunningBuffer,
					analysisMethodBlankMarker
				} =
					fastAssocLookup[fastAssoc, resolvedAnalysisMethod, #]& /@ {
						Blank,
						BlankRunningBuffer,
						BlankMarker
					};

				(*BlankRunningBuffer Resolution*)
				blankRunningBuffer = Which[
					(*If not Automatic, set to suppliedBlankRunningBuffer*)
					MatchQ[suppliedBlankRunningBuffer, Except[Automatic]],
					suppliedBlankRunningBuffer,

					(*If suppliedBlankRunningBuffer is Automatic AND there is no specified Blank, set to Null*)
					MatchQ[myBlank, Null],
					Null,

					(*If suppliedBlankRunningBuffer is Automatic AND suppliedPreparedRunningBufferPlate is an Object[Container,Plate]*)
					MatchQ[resolvedPreparedRunningBufferPlate, ObjectP[Object[Container, Plate]]],
					myPreparedBlankRunningBuffer,

					(*If suppliedBlankRunningBuffer is Automatic AND there is a specified Blank AND analysisMethodBlankRunningBuffer is Not Null, set to field value in AnalysisMethod*)
					MatchQ[analysisMethodBlankRunningBuffer, Except[Null]],
					analysisMethodBlankRunningBuffer,

					(*If suppliedBlankRunningBuffer is Automatic AND there is a specified Blank AND analysisMethodBlankRunningBuffer is Null, set to a reasonable value - BlankRunningBuffer is required for Blank*)
					True,
					Model[Sample, StockSolution, "1x Running Buffer for ExperimentFragmentAnalysis"]
				];

				(*BlankMarker Resolution*)
				blankMarker = Which[
					(*If not Automatic, set to suppliedBlankMarker*)
					MatchQ[suppliedBlankMarker, Except[Automatic]],
					suppliedBlankMarker,

					(*If suppliedBlankMarker is Automatic AND suppliedPreparedMarkerPlate is an Object[Container,Plate]*)
					MatchQ[resolvedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]],
					myPreparedBlankMarker,

					(*If suppliedBlankMarker is Automatic AND, there is no specified Blank OR resolvedMarkerInjection is False, set to Null*)
					MatchQ[myBlank, Null] || MatchQ[resolvedMarkerInjection, False],
					Null,

					(*If suppliedBlankMarker is Automatic AND there is a specified Blank, set to field value in AnalysisMethod; BlankMarker is not required for Blank*)
					MatchQ[analysisMethodBlankMarker, Except[Null]],
					analysisMethodBlankMarker,

					(*If suppliedBlankMarker is Automatic AND there is a specified Blank, set to field value in AnalysisMethod; BlankMarker is not required for Ladder so a Null value can be in the AnalysisMethod*)
					True,
					Model[Sample, "75 bp and 20000 bp Markers for ExperimentFragmentAnalysis"]
				];

				(*Error Checking*)
				(*If PreparedPlate is True AND Blank is an object, throw and Error*)
				(*If PreparedPlate is False AND Blank is a WellPositionP, throw an Error*)
				blankPreparedPlateMismatchError = Or[
					MatchQ[resolvedPreparedPlate, True] && MatchQ[myBlank, ObjectP[]],
					MatchQ[resolvedPreparedPlate, False] && MatchQ[myBlank, WellPositionP]
				];


				(*BlankRunningBuffer is required is Blank is not Null*)
				(*If Blank is Null AND BlankRunningBuffer is not Null, throw an error*)
				(*If Blank is not Null AND BlankRunningBuffer is Null, throw an error*)
				blankRunningBufferMismatchError = Or[
					MatchQ[myBlank, Null] && MatchQ[blankRunningBuffer, Except[Null]],
					MatchQ[myBlank, Except[Null]] && MatchQ[blankRunningBuffer, Null]
				];

				(*BlankMarker is not required if Blank is not Null*)
				(*If Blank is Null AND BlankMarker is not Null, throw an error*)
				blankMarkerMismatchError = MatchQ[myBlank, Null] && MatchQ[blankMarker, Except[Null]];

				(*If the Blank does not match the Blank value in the AnalysisMethod, throw a Warning. This check is not applicable for a PreparedPlate.*)
				analysisMethodBlankMismatchWarning = If[resolvedPreparedPlate,
					False,
					analysisMethodOptionsCheckFunction[Blank, myBlank]
				];

				(*Check each relevant option if it matches the AnalysisMethod. Set Check to True for each option that does not match.*)
				analysisMethodBlankOptionsMismatchCheck = If[
					(*If there is no specified Blank, no need to check against AnalysisMethod*)
					resolvedPreparedPlate && MatchQ[myBlank, Null],
					{False, False},

					(*If there is a specified Blank, check values of BlankRunningBuffer and BlankMarker*)
					MapThread[analysisMethodOptionsCheckFunction[#1, #2]&, {{BlankRunningBuffer, BlankMarker}, {blankRunningBuffer, blankMarker}}]
				];

				(*Identify the relevant options that does not match the AnalysisMethod*)
				analysisMethodBlankOptionsMismatchList = PickList[{BlankRunningBuffer, BlankMarker}, analysisMethodBlankOptionsMismatchCheck];

				(*Throw a Warning for each Blank that have relevant option(s) that does not match the AnalysisMethod*)
				analysisMethodBlankOptionsMismatchWarning = Length[analysisMethodBlankOptionsMismatchList] > 0;

				(*If resolvedPreparedRunningBufferPlate is an Object[Container,Plate], blankRunningBuffer and blankMarker must match the Contents*)
				preparedBlankRunningBufferMismatchCheck = If[MatchQ[blankRunningBuffer,Null],
					!MatchQ[myPreparedBlankRunningBuffer, Null],
					!MatchQ[myPreparedBlankRunningBuffer, ObjectP[blankRunningBuffer]]
				];

				(*If resolvedPreparedRunningBufferPlate is an Object[Container,Plate], blankRunningBuffer and blankMarker must match the Contents*)
				preparedBlankMarkerMismatchCheck = If[MatchQ[blankMarker,Null],
					!MatchQ[myPreparedBlankMarker, Null],
					!MatchQ[myPreparedBlankMarker, ObjectP[blankMarker]]
				];

				(* Gather MapThread results *)
				{
					blankRunningBuffer,
					blankMarker,
					blankPreparedPlateMismatchError,
					blankRunningBufferMismatchError,
					blankMarkerMismatchError,
					analysisMethodBlankMismatchWarning,
					analysisMethodBlankOptionsMismatchList,
					analysisMethodBlankOptionsMismatchWarning,
					preparedBlankRunningBufferMismatchCheck,
					preparedBlankMarkerMismatchCheck
				}
			]
		],
			{listedResolvedBlank, blankMapThreadFriendlyOptions, preparedBlankRunningBufferObjects, preparedBlankMarkerObjects}
		]];

	(* create a runningBufferList to check that includes applicable RunningBuffer associated with Sample, Ladder or Blank. This is also to verify that the correct number of RunningBuffer has been resolved (equal to 96) *)
	runningBufferList = Which[
		MatchQ[listedResolvedBlank, {Null..}] && MatchQ[resolvedLadder, Except[Null | {Null..}]],
		Join[ToList[resolvedSampleRunningBuffer], ToList[mapResolvedLadderRunningBuffer]],

		MatchQ[listedResolvedBlank, {Null..}] && MatchQ[resolvedLadder, Null | {Null..}],
		ToList[resolvedSampleRunningBuffer],

		MatchQ[resolvedLadder, {Null..}] && MatchQ[listedResolvedBlank, Except[Null | {Null..}]],
		Join[ToList[resolvedSampleRunningBuffer], ToList[mapResolvedBlankRunningBuffer]],

		MatchQ[listedResolvedBlank, Except[{Null..}]] && MatchQ[resolvedLadder, Except[Null | {Null..}]],
		Join[ToList[resolvedSampleRunningBuffer], ToList[mapResolvedLadderRunningBuffer], ToList[mapResolvedBlankRunningBuffer]]
	];

	(* create a markerList to check that includes applicable RunningBuffer associated with Sample, Ladder or Blank. This is also to verify that the correct number of RunningBuffer has been resolved (equal to 96) *)
	markerList = Which[
		MatchQ[listedResolvedBlank, {Null..}] && MatchQ[resolvedLadder, Except[Null | {Null..}]],
		Join[ToList[resolvedSampleMarker], ToList[mapResolvedLadderMarker]],
		
		MatchQ[listedResolvedBlank, {Null..}] && MatchQ[resolvedLadder, Null | {Null..}],
		ToList[resolvedSampleMarker],
		
		MatchQ[resolvedLadder, {Null..}] && MatchQ[listedResolvedBlank, Except[Null | {Null..}]],
		Join[ToList[resolvedSampleMarker], ToList[mapResolvedBlankMarker]],
		
		MatchQ[listedResolvedBlank, Except[{Null..}]] && MatchQ[resolvedLadder, Except[Null | {Null..}]],
		Join[ToList[resolvedSampleMarker], ToList[mapResolvedLadderMarker], ToList[mapResolvedBlankMarker]]
	];
	
	(*MarkerPlateStorageCondition Resolution*)
	(* Markers are ideally stored in the refrigerator*)
	resolvedMarkerPlateStorageCondition = Which[
		MatchQ[suppliedMarkerPlateStorageCondition, Except[Automatic]],
		suppliedMarkerPlateStorageCondition,
		
		MemberQ[markerList, ObjectP[] | WellPositionP],
		Refrigerator,
		
		MemberQ[markerList, Null],
		Null
	];
	
	(*NumberOfCapillaries Resolution*)
	resolvedNumberOfCapillaries = If[MatchQ[suppliedNumberOfCapillaries, Except[Automatic]],
		suppliedNumberOfCapillaries,
		96
	];
	
	(*CapillaryArray Resolution*)
	resolvedCapillaryArray = Which[
		MatchQ[suppliedCapillaryArray, Except[Automatic]],
		suppliedCapillaryArray,
		
		MatchQ[suppliedInstrument, ObjectP[Object[Instrument, FragmentAnalyzer]]],
		fastAssocLookup[fastAssoc, suppliedInstrument, CapillaryArray][[1]],
		
		True,
		Lookup[
			Cases[
				fastAssoc,
				KeyValuePattern[{
					Type->Model[Part,CapillaryArray],
					NumberOfCapillaries->resolvedNumberOfCapillaries,
					CapillaryArrayLength->resolvedCapillaryArrayLength
				}]
			],
			Object
		][[1]]
	];
	
	(*Instrument Resolution*)
	resolvedInstrument = Which[
		MatchQ[suppliedInstrument, Except[Automatic]],
		suppliedInstrument,
		
		(*If the resolvedCapillaryArray is an object, it will use the Instrument currently attached to that CapillaryArray*)
		MatchQ[resolvedCapillaryArray, ObjectP[Object[Part, CapillaryArray]]],
		fastAssocLookup[fastAssoc, resolvedCapillaryArray, Instrument][[1]],
		
		(*If the resolvedCapillaryArray is a Model, it will use the first CompatibleInstrument model of that CapillaryArray model*)
		MatchQ[resolvedCapillaryArray, ObjectP[Model[Part, CapillaryArray]]],
		First[fastAssocLookup[fastAssoc, resolvedCapillaryArray, CompatibleInstrument]][[1]]
		
	];
	
	(*-- CONFLICTING OPTIONS CHECKS --*)
	
	(* ---AnalysisMethodName Conflicting Options check--- *)
	(* If the specified AnalysisMethodName is not in the database, it is valid *)
	validNameError = If[MatchQ[suppliedAnalysisMethodName, _String],
		DatabaseMemberQ[Object[Method, FragmentAnalysis, resolvedAnalysisMethodName]],
		False
	];
	
	(* if validNameError is True AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make analysisMethodNameInvalidOptions = {AnalysisMethodName}; otherwise, {} is fine *)
	analysisMethodNameInvalidOptions = If[validNameError && !gatherTests,
		Message[Error::DuplicateName, "FragmentAnalysis Method"];
		{AnalysisMethodName},
		{}
	];
	
	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[resolvedAnalysisMethodName, _String],
		Test["If specified, AnalysisMethodName is not already a ExperimentFragmentAnalysis method object name:",
			validNameError,
			True
		],
		Nothing
	];
	
	(*PreparedPlate Model Check*)
	(*If PreparedPlate is True, check if the plate that all the samples are in are the same and if the plate is compatible with the Instrument*)
	(*If all the samples are in the same plate, uniqueSampleContainers will only be one value*)
	
	allSampleContainers=fastAssocLookup[fastAssoc, #, Container]& /@ mySamples;
	uniqueSampleContainers=DeleteDuplicates[allSampleContainers[[All,1]]];
	uniqueSampleContainerModels = fastAssocLookup[fastAssoc, #, Model]& /@ uniqueSampleContainers;
	
	plateModelError = Which[
		MatchQ[resolvedPreparedPlate,False],
		False,
		
		MatchQ[Length[uniqueSampleContainers],Except[1]],
		True,
		
		MatchQ[Length[uniqueSampleContainers],1] && MatchQ[fastAssocLookup[fastAssoc, First[uniqueSampleContainers], Model], ObjectP[Model[Container, Plate, "id:vXl9j5lLdjW5"]]],
		False,
		
		True,
		True
	];
	
	plateModelInvalidOptions = If[plateModelError && messages,
		Message[Error::PreparedPlateModelError, ObjectToString[uniqueSampleContainers, Cache -> cacheBall]];
		{PreparedPlate},
		{}
	];
	
	(* Generate Test for CapillaryFlush and NumberOfCapillaryFlushes Options check *)
	plateModelTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[plateModelInvalidOptions] == 0,
				Nothing,
				Test["If PreparedPlate is True, the samples must all be in the same Instrument-compatible container plate:", True, False]
			];
			passingTest = If[Length[plateModelInvalidOptions] != 0,
				Nothing,
				Test["If PreparedPlate is True, the samples must all be in the same Instrument-compatible container plate:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(*PreparedRunningBufferPlate Model Check*)
	(*If PreparedRunningBufferPlate is an object, check if the plate is compatible with the Instrument*)
	resolvedPreparedRunningBufferPlateModel=fastAssocLookup[fastAssoc, resolvedPreparedRunningBufferPlate, Model];
 
	preparedRunningBufferPlateModelError = Which[
		MatchQ[resolvedPreparedRunningBufferPlate,Except[ObjectP[]]],
		False,
		
		(*RunningBufferPlate is required to be Model[Container,Plate,"96-well 1mL Deep Well Plate (Short) for FragmentAnalysis"] in order to be compatible with the instrument*)
		MatchQ[resolvedPreparedRunningBufferPlateModel,Except[ObjectP[Model[Container, Plate, "id:Vrbp1jb6R1dx"]]]],
		True,
		
		True,
		False
	];
	
	preparedRunningBufferPlateModelInvalidOptions = If[preparedRunningBufferPlateModelError && messages,
		Message[Error::PreparedRunningBufferPlateModelError, ObjectToString[resolvedPreparedRunningBufferPlate, Cache -> cacheBall]];
		{PreparedRunningBufferPlate},
		{}
	];
	
	(* Generate Test for CapillaryFlush and NumberOfCapillaryFlushes Options check *)
	preparedRunningBufferPlateModelTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[preparedRunningBufferPlateModelInvalidOptions] == 0,
				Nothing,
				Test["If PreparedRunningBufferPlate is an object, it must be an Instrument-compatible container plate:", True, False]
			];
			passingTest = If[Length[preparedRunningBufferPlateModelInvalidOptions] != 0,
				Nothing,
				Test["If PreparedRunningBufferPlate is an object, it must be an Instrument-compatible container plate:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(*PreparedMarkerPlate Model Check*)
	(*If PreparedMarkerPlate is True, check if the plate is compatible with the Instrument*)
	resolvedPreparedMarkerPlateModel=fastAssocLookup[fastAssoc, resolvedPreparedMarkerPlate, Model];
	
	preparedMarkerPlateModelError = Which[
		MatchQ[resolvedPreparedMarkerPlate,Except[ObjectP[]]],
		False,
		
		(*MarkerPlate is required to be Model[Container,Plate,96-well Semi-Skirted PCR Plate for FragmentAnalysis] in order to be compatible with the instrument*)
		MatchQ[resolvedPreparedMarkerPlateModel,Except[ObjectP[Model[Container, Plate, "id:vXl9j5lLdjW5"]]]],
		True,
		
		True,
		False
	];
	
	preparedMarkerPlateModelInvalidOptions = If[preparedMarkerPlateModelError && messages,
		Message[Error::PreparedMarkerPlateModelError, ObjectToString[resolvedPreparedMarkerPlate, Cache -> cacheBall]];
		{PreparedMarkerPlate},
		{}
	];
	
	(* Generate Test for CapillaryFlush and NumberOfCapillaryFlushes Options check *)
	preparedMarkerPlateModelTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[preparedMarkerPlateModelInvalidOptions] == 0,
				Nothing,
				Test["If PreparedMarkerPlate is an object, it must be an Instrument-compatible container plate:", True, False]
			];
			passingTest = If[Length[preparedMarkerPlateModelInvalidOptions] != 0,
				Nothing,
				Test["If PreparedMarkerPlate is an object, it must be an Instrument-compatible container plate:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(* ---CapillaryFlush Options Conflicting Options check--- *)
	(*NumberOfCapillaryFlushes is Null if and only if CapillaryFlush is False*)
	capillaryFlushNumberOfCapillaryFlushesMismatchInvalidOptions =If[Or[
		MatchQ[resolvedCapillaryFlush, False] && MatchQ[resolvedNumberOfCapillaryFlushes, Alternatives[1, 2, 3]],
		MatchQ[resolvedCapillaryFlush, True] && MatchQ[resolvedNumberOfCapillaryFlushes, Null]],
		{CapillaryFlush, NumberOfCapillaryFlushes},
		{}
	];
	
	If[MatchQ[Length[capillaryFlushNumberOfCapillaryFlushesMismatchInvalidOptions],GreaterP[0]]  && messages,
		Message[Error::CapillaryFlushNumberOfCapillaryFlushesMismatchError, resolvedCapillaryFlush, resolvedNumberOfCapillaryFlushes];,
		Nothing
	];
	
	(* Generate Test for CapillaryFlush and NumberOfCapillaryFlushes Options check *)
	capillaryFlushNumberOfCapillaryFlushesMismatchTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[capillaryFlushNumberOfCapillaryFlushesMismatchInvalidOptions] == 0,
				Nothing,
				Test["The option NumberOfCapillaries can only be Null if, and only if, CapillaryFlush is False.:", True, False]
			];
			passingTest = If[Length[capillaryFlushNumberOfCapillaryFlushesMismatchInvalidOptions] != 0,
				Nothing,
				Test["The option NumberOfCapillaries can only be Null if, and only if, CapillaryFlush is False.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(*PrimaryCapillaryFlush Options are Null if and only if CapillaryFlush is False*)
	primaryCapillaryFlushMismatchErrors = If[Or[MatchQ[resolvedCapillaryFlush, False] && MatchQ[#, Except[Null]], MatchQ[resolvedCapillaryFlush, True] && MatchQ[#, Null]],
		True,
		False
	]& /@ {resolvedPrimaryCapillaryFlushSolution, resolvedPrimaryCapillaryFlushPressure, resolvedPrimaryCapillaryFlushFlowRate, resolvedPrimaryCapillaryFlushTime};
	
	(* if primaryCapillaryFlushMismatchErrors has any True AND we are throwing messages *)
	primaryCapillaryFlushMismatchInvalidOptions = PickList[
		{PrimaryCapillaryFlushSolution, PrimaryCapillaryFlushPressure, PrimaryCapillaryFlushFlowRate, PrimaryCapillaryFlushTime},
		primaryCapillaryFlushMismatchErrors
	];
	
	If[MemberQ[primaryCapillaryFlushMismatchErrors, True] && messages,
		Message[Error::PrimaryCapillaryFlushMismatchError, primaryCapillaryFlushMismatchInvalidOptions];,
		Nothing
	];
	
	(* Generate Test for PrimaryCapillaryFlush Options check *)
	primaryCapillaryFlushMismatchTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[primaryCapillaryFlushMismatchInvalidOptions] == 0,
				Nothing,
				Test["The options PrimaryCapillaryFlushSolution, PrimaryCapillaryFlushPressure, PrimaryCapillaryFlushFlowRate and PrimaryCapillaryFlushTime can only be Null if, and only if, CapillaryFlush is False.:", True, False]
			];
			passingTest = If[Length[primaryCapillaryFlushMismatchInvalidOptions] != 0,
				Nothing,
				Test["The options PrimaryCapillaryFlushSolution, PrimaryCapillaryFlushPressure, PrimaryCapillaryFlushFlowRate and PrimaryCapillaryFlushTime can only be Null if, and only if, CapillaryFlush is False.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(*SecondaryCapillaryFlush Options are Null if and only if NumberOfCapillaryFlushes is less than 2*)
	secondaryCapillaryFlushMismatchErrors = If[Or[MatchQ[resolvedNumberOfCapillaryFlushes, LessP[2] | Null] && MatchQ[#, Except[Null]], MatchQ[resolvedNumberOfCapillaryFlushes, GreaterP[1]] && MatchQ[#, Null]],
		True,
		False
	]& /@ {resolvedSecondaryCapillaryFlushSolution, resolvedSecondaryCapillaryFlushPressure, resolvedSecondaryCapillaryFlushFlowRate, resolvedSecondaryCapillaryFlushTime};
	
	(* if capillaryFlushNumberOfCapillaryFlushesMismatchError is True AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make capillaryFlushNumberOfCapillaryFlushesMismatchInvalidOptions = {resolvedCapillaryFlush,resolvedNumberOfCapillaryFlushes}; otherwise, {} is fine *)
	secondaryCapillaryFlushMismatchInvalidOptions = PickList[
		{SecondaryCapillaryFlushSolution, SecondaryCapillaryFlushPressure, SecondaryCapillaryFlushFlowRate, SecondaryCapillaryFlushTime},
		secondaryCapillaryFlushMismatchErrors
	];
	
	If[MemberQ[secondaryCapillaryFlushMismatchErrors, True] && messages,
		Message[Error::SecondaryCapillaryFlushMismatchError, secondaryCapillaryFlushMismatchInvalidOptions];,
		Nothing
	];
	
	(* Generate Test for PrimaryCapillaryFlush Options check *)
	secondaryCapillaryFlushMismatchTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[secondaryCapillaryFlushMismatchInvalidOptions] == 0,
				Nothing,
				Test["The options SecondaryCapillaryFlushSolution, SecondaryCapillaryFlushPressure, SecondaryCapillaryFlushFlowRate and SecondaryCapillaryFlushTime can only be Null if, and only if, NumberOfCapillaryFlushes is less than 2 OR Null.:", True, False]
			];
			passingTest = If[Length[secondaryCapillaryFlushMismatchInvalidOptions] != 0,
				Nothing,
				Test["The options SecondaryCapillaryFlushSolution, SecondaryCapillaryFlushPressure, SecondaryCapillaryFlushFlowRate and SecondaryCapillaryFlushTime can only be Null if, and only if, NumberOfCapillaryFlushes is less than 2 OR Null.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(*TertiaryCapillaryFlush Options are Null if and only if NumberOfCapillaryFlushes is less than 3*)
	tertiaryCapillaryFlushMismatchErrors = If[Or[MatchQ[resolvedNumberOfCapillaryFlushes, LessP[3] | Null] && MatchQ[#, Except[Null]], MatchQ[resolvedNumberOfCapillaryFlushes, GreaterP[2]] && MatchQ[#, Null]],
		True,
		False
	]& /@ {resolvedTertiaryCapillaryFlushSolution, resolvedTertiaryCapillaryFlushPressure, resolvedTertiaryCapillaryFlushFlowRate, resolvedTertiaryCapillaryFlushTime};
	
	(* if capillaryFlushNumberOfCapillaryFlushesMismatchError is True AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make capillaryFlushNumberOfCapillaryFlushesMismatchInvalidOptions = {resolvedCapillaryFlush,resolvedNumberOfCapillaryFlushes}; otherwise, {} is fine *)
	tertiaryCapillaryFlushMismatchInvalidOptions = PickList[
		{TertiaryCapillaryFlushSolution, TertiaryCapillaryFlushPressure, TertiaryCapillaryFlushFlowRate, TertiaryCapillaryFlushTime},
		tertiaryCapillaryFlushMismatchErrors
	];
	
	If[MemberQ[tertiaryCapillaryFlushMismatchErrors, True] && !gatherTests,
		Message[Error::TertiaryCapillaryFlushMismatchError, tertiaryCapillaryFlushMismatchInvalidOptions];,
		Nothing
	];
	
	(* Generate Test for PrimaryCapillaryFlush Options check *)
	tertiaryCapillaryFlushMismatchTests = If[gatherTests && MemberQ[tertiaryCapillaryFlushMismatchErrors, True],
		Module[{failingTest, passingTest},
			failingTest = If[Length[tertiaryCapillaryFlushMismatchInvalidOptions] == 0,
				Nothing,
				Test["The options TertiaryCapillaryFlushSolution, TertiaryCapillaryFlushPressure, TertiaryCapillaryFlushFlowRate and TertiaryCapillaryFlushTime can only be Null if, and only if, NumberOfCapillaryFlushes is less than 3 OR Null.:", True, False]
			];
			passingTest = If[Length[tertiaryCapillaryFlushMismatchInvalidOptions] != 0,
				Nothing,
				Test["The options TertiaryCapillaryFlushSolution, TertiaryCapillaryFlushPressure, TertiaryCapillaryFlushFlowRate and TertiaryCapillaryFlushTime can only be Null if, and only if, NumberOfCapillaryFlushes is less than 3 OR Null.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(* --- AnalysisStrategy Conflicting Options check--- *)
	analysisMethodAnalysisStrategy = First[fastAssocLookup[fastAssoc, resolvedAnalysisMethod, AnalysisStrategy]];
	(*If suppliedAnalysisMethod is not Automatic AND resolvedAnalysisStrategy is Quantitative AND the AnalysisStrategy field of the resolvedAnalysisMethod is Qualitative, throw a Warning - AnalysisMethod that are Qualitative will not yield reliable Quantitation*)
	analysisMethodAnalysisStrategyMismatchWarning = MatchQ[suppliedAnalysisMethod, Except[Automatic]] && MatchQ[resolvedAnalysisStrategy, Quantitative] && MatchQ[analysisMethodAnalysisStrategy, Qualitative];
	
	If[analysisMethodAnalysisStrategyMismatchWarning && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[
			Warning::AnalysisMethodAnalysisStrategyMismatchWarning,
			ObjectToString[resolvedAnalysisMethod,Cache -> cacheBall], ToString[resolvedAnalysisStrategy]
		],
		Nothing
	];
	
	(* --- CapillaryArrayLength Conflicting Options check--- *)
	(*Update once we carry more types of capillary arrays*)
	
	(* --- SampleAnalyteType Conflicting Options check--- *)
	(* throw warning if there are samples where SampleAnalyteType cannot be determined and defaulted to DNA*)
	cantDetermineSampleAnalyteTypeSamples = PickList[simulatedSamples, resolvedCantDetermineSampleAnalyteTypeWarning];
	
	If[MemberQ[resolvedCantDetermineSampleAnalyteTypeWarning, True] && messages && Not[MatchQ[$ECLApplication, Engine]] && MatchQ[suppliedAnalysisMethod, Automatic],
		Message[
			Warning::CantDetermineSampleAnalyteType,
			ObjectToString[cantDetermineSampleAnalyteTypeSamples, Cache -> cacheBall]
		]
	];
	
	(*Check if any of the SampleAnalyteType does not match the TargetAnalyteType field of the AnalysisMethod specified by User then throw warning*)
	sampleAnalyteTypeAnalysisMethodMismatchWarnings = If[MatchQ[suppliedAnalysisMethod, Except[Automatic]],
		Map[!MatchQ[#1, fastAssocLookup[fastAssoc, resolvedAnalysisMethod, TargetAnalyteType]]&, resolvedSampleAnalyteTypes],
		{}
	];
	
	(*determined which samples have an AnalyteType Mismatch*)
	sampleAnalyteTypeAnalysisMethodMismatchSamples = If[MatchQ[suppliedAnalysisMethod, Except[Automatic]],
		PickList[simulatedSamples, sampleAnalyteTypeAnalysisMethodMismatchWarnings],
		{}
	];
	
	If[MemberQ[sampleAnalyteTypeAnalysisMethodMismatchWarnings, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[
			Warning::SampleAnalyteTypeAnalysisMethodMismatch,
			ObjectToString[sampleAnalyteTypeAnalysisMethodMismatchSamples, Cache -> cacheBall]
		]
	];
	
	(* --- MinReadLength and MaxReadLength Conflicting Options check--- *)
	(* throw warning if there are samples where MinReadLength and MaxReadLength cannot be determined and defaulted to Null*)
	cantDetermineReadLengthSamples = PickList[simulatedSamples, resolvedCantDetermineMinReadLengthWarning];
	
	If[MemberQ[resolvedCantDetermineMinReadLengthWarning, True] && messages && Not[MatchQ[$ECLApplication, Engine]] && MatchQ[suppliedAnalysisMethod, Automatic],
		Message[
			Warning::CantDetermineReadLengths,
			ObjectToString[cantDetermineReadLengthSamples, Cache -> cacheBall]
		]
	];
	
	(* --- AnalysisMethod Conflicting Options check--- *)
	(*If AnalysisMethod is Automatic, determine the samples that have a resolvedSampleAnalysisMethod that does not match the final resolvedAnalysisMethod, then throw Warning*)
	analysisMethodMismatch = (!MatchQ[resolvedAnalysisMethod, #])& /@ resolvedSampleAnalysisMethod;
	analysisMethodMismatchSamples = PickList[simulatedSamples, analysisMethodMismatch];
	
	If[MemberQ[analysisMethodMismatch, True] && messages && Not[MatchQ[$ECLApplication, Engine]] && MatchQ[suppliedAnalysisMethod, Automatic],
		Message[
			Warning::AnalysisMethodNotOptimized,
			ObjectToString[analysisMethodMismatchSamples, Cache -> cacheBall]
		]
	];
	
	(* ---Non-Object/Model Options Analysis Method Mismatch check--- *)
	(*check if the resolvedOption does not match the value of the corresponding field from the resolvedAnalysisMethod*)
	analysisMethodNonObjectsOptionsMismatchWarnings = MapThread[
		!MatchQ[#1, fastAssocLookup[fastAssoc, resolvedAnalysisMethod, #2]]&,
		{
			{
				resolvedCapillaryEquilibration,
				resolvedEquilibrationVoltage,
				resolvedEquilibrationTime,
				resolvedPreMarkerRinse,
				resolvedNumberOfPreMarkerRinses,
				resolvedMarkerInjection,
				resolvedMarkerInjectionTime,
				resolvedMarkerInjectionVoltage,
				resolvedPreSampleRinse,
				resolvedNumberOfPreSampleRinses,
				resolvedSampleInjectionTime,
				resolvedSampleInjectionVoltage,
				resolvedSeparationTime,
				resolvedSeparationVoltage
			},
			{
				CapillaryEquilibration,
				EquilibrationVoltage,
				EquilibrationTime,
				PreMarkerRinse,
				NumberOfPreMarkerRinses,
				MarkerInjection,
				MarkerInjectionTime,
				MarkerInjectionVoltage,
				PreSampleRinse,
				NumberOfPreSampleRinses,
				SampleInjectionTime,
				SampleInjectionVoltage,
				SeparationTime,
				SeparationVoltage
			}
		}
	];
	
	(* create a list of options that does not match that of the corresponding field in the AnalysisMethod *)
	analysisMethodNonObjectsOptionsMismatchList = PickList[
		{CapillaryEquilibration, EquilibrationVoltage, EquilibrationTime, PreMarkerRinse, NumberOfPreMarkerRinses, MarkerInjection, MarkerInjectionTime, MarkerInjectionVoltage, PreSampleRinse, NumberOfPreSampleRinses, SampleInjectionTime, SampleInjectionVoltage, SeparationTime, SeparationVoltage},
		analysisMethodNonObjectsOptionsMismatchWarnings
	];
	
	(* ---Object/Model Options (Blank,SeparationGel,Dye,ConditioningSolution) Analysis Method Mismatch check--- *)
	analysisMethodObjectsOptionsMismatchCheck = MapThread[
		analysisMethodOptionsCheckFunction[#1, #2]&,
		{
			{SeparationGel, Dye, ConditioningSolution, PreMarkerRinseBuffer, PreSampleRinseBuffer},
			{resolvedSeparationGel, resolvedDye, resolvedConditioningSolution, resolvedPreMarkerRinseBuffer, resolvedPreSampleRinseBuffer}
		}
	];
	
	(* create a list of options that does not match that of the corresponding field in the AnalysisMethod *)
	analysisMethodObjectsOptionsMismatchList = PickList[
		{SeparationGel, Dye, ConditioningSolution, PreMarkerRinseBuffer, PreSampleRinseBuffer},
		analysisMethodObjectsOptionsMismatchCheck
	];
	
	analysisMethodOptionsMismatchList = Join[analysisMethodObjectsOptionsMismatchList, analysisMethodNonObjectsOptionsMismatchList];
	
	(* if analysisMethodOptionsMismatchWarnings has any True AND we are throwing messages *)
	If[MatchQ[Length[analysisMethodOptionsMismatchList],GreaterP[0]] && messages,
		Message[Warning::AnalysisMethodOptionsMismatch, ToString[analysisMethodOptionsMismatchList]];,
		Nothing
	];

	(* ---Capillary Equilibration Conflicting Options check--- *)
	capillaryEquilibrationMismatchErrors = Map[
		Or[MatchQ[resolvedCapillaryEquilibration, False] && MatchQ[#1, Except[Null]], MatchQ[resolvedCapillaryEquilibration, True] && MatchQ[#1, Null]]&,
		{resolvedEquilibrationVoltage, resolvedEquilibrationTime}
	];
	
	capillaryEquilibrationMismatchInvalidOptions = If[MemberQ[capillaryEquilibrationMismatchErrors, True] && messages,
		Message[Error::CapillaryEquilibrationOptionsMismatchErrors, PickList[{resolvedEquilibrationVoltage, resolvedEquilibrationTime}, capillaryEquilibrationMismatchErrors], resolvedCapillaryEquilibration];
		Join[PickList[{EquilibrationVoltage, EquilibrationTime}, capillaryEquilibrationMismatchErrors], {CapillaryEquilibration}],
		{}
	];
	
	(* Generate Test for CapillaryEquilibration Options check *)
	capillaryEquilibrationMismatchTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[capillaryEquilibrationMismatchInvalidOptions] == 0,
				Nothing,
				Test["The options EquilibrationVoltage and EquilibrationTime can only be Null if, and only if, CapillaryEquilibration is False.:", True, False]
			];
			passingTest = If[Length[capillaryEquilibrationMismatchInvalidOptions] != 0,
				Nothing,
				Test["The options EquilibrationVoltage and EquilibrationTime can only be Null if, and only if, CapillaryEquilibration is False.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(* ---PreMarker Rinse Conflicting Options check--- *)
	(*If PreMarkerRinse related options (PreMarkerRinseBuffer,NumberOfPreMarkerRinses,PreMarkerRinseBufferPlateStorageCondition) can only be Null if, and only if, PreMarkerRinse is False*)
	preMarkerRinseMismatchErrors = Map[
		Or[MatchQ[resolvedPreMarkerRinse, False] && MatchQ[#1, Except[Null]], MatchQ[resolvedPreMarkerRinse, True] && MatchQ[#1, Null]]&,
		{resolvedPreMarkerRinseBuffer, resolvedNumberOfPreMarkerRinses, resolvedPreMarkerRinseBufferPlateStorageCondition}
	];
	
	preMarkerRinseMismatchInvalidOptions = If[MemberQ[preMarkerRinseMismatchErrors, True] && messages,
		Message[Error::PreMarkerRinseOptionsMismatchErrors, ObjectToString[Join[PickList[{resolvedPreMarkerRinseBuffer, resolvedNumberOfPreMarkerRinses, resolvedPreMarkerRinseBufferPlateStorageCondition}, preMarkerRinseMismatchErrors], {resolvedPreMarkerRinse}],Cache -> cacheBall], Join[PickList[{PreMarkerRinseBuffer, NumberOfPreMarkerRinses, PreMarkerRinseBufferPlateStorageCondition}, preMarkerRinseMismatchErrors], {PreMarkerRinse}]];
		Join[PickList[{PreMarkerRinseBuffer, NumberOfPreMarkerRinses, PreMarkerRinseBufferPlateStorageCondition}, preMarkerRinseMismatchErrors], {PreMarkerRinse}],
		{}
	];
	
	(* Generate Test for PreMarkerRinse Options check *)
	preMarkerRinseMismatchTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[preMarkerRinseMismatchInvalidOptions] == 0,
				Nothing,
				Test["The options PreMarkerRinseBuffer, NumberOfPreMarkerRinses, and PreMarkerRinseBufferPlateStorageCondition can only be Null if, and only if, PreMarkerRinse is False.:", True, False]
			];
			passingTest = If[Length[preMarkerRinseMismatchInvalidOptions] != 0,
				Nothing,
				Test["The options PreMarkerRinseBuffer, NumberOfPreMarkerRinses, and PreMarkerRinseBufferPlateStorageCondition can only be Null if, and only if, PreMarkerRinse is False.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(* ---Marker Injection Conflicting Options check--- *)
	markerInjectionMismatchErrors = Map[
		Or[MatchQ[resolvedMarkerInjection, False] && MatchQ[#1, Except[Null]], MatchQ[resolvedMarkerInjection, True] && MatchQ[#1, Null]]&,
		{resolvedMarkerInjectionVoltage, resolvedMarkerInjectionTime}
	];
	
	markerInjectionMismatchInvalidOptions = If[MemberQ[markerInjectionMismatchErrors, True] && messages,
		Message[Error::MarkerInjectionOptionsMismatchErrors, PickList[{MarkerInjectionVoltage, MarkerInjectionTime}, markerInjectionMismatchErrors], resolvedMarkerInjection];
		Join[PickList[{MarkerInjectionVoltage, MarkerInjectionTime}, markerInjectionMismatchErrors], {MarkerInjection}],
		{}
	];
	
	(* Generate Test for Marker Injection Options check *)
	markerInjectionMismatchTests = If[gatherTests && MemberQ[markerInjectionMismatchErrors, True],
		Module[{failingTest, passingTest},
			failingTest = If[Length[markerInjectionMismatchInvalidOptions] == 0,
				Nothing,
				Test["The options MarkerInjectionVoltage and MarkerInjectionTime can only be Null if, and only if, CapillaryEquilibration is False.:", True, False]
			];
			passingTest = If[Length[markerInjectionMismatchInvalidOptions] != 0,
				Nothing,
				Test["The options MarkerInjectionVoltage and MarkerInjectionTime can only be Null if, and only if, CapillaryEquilibration is False.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	markerInjectionPreparedMarkerPlateMismatchError = If[MatchQ[resolvedMarkerInjection,False]&&MatchQ[resolvedPreparedMarkerPlate,ObjectP[]],
		True,
		False
	];
	
	markerInjectionPreparedMarkerPlateMismatchInvalidOptions = If[MatchQ[markerInjectionPreparedMarkerPlateMismatchError,True] && messages,
		Message[Error::MarkerInjectionPreparedMarkerPlateMismatchError];
		{MarkerInjection,PreparedMarkerPlate},
		{}
	];
	
	(* Generate Test for Marker Injection Options check *)
	markerInjectionPreparedPlateMismatchTest = If[gatherTests && MatchQ[markerInjectionPreparedMarkerPlateMismatchError, True],
		Module[{failingTest, passingTest},
			failingTest = If[Length[markerInjectionPreparedMarkerPlateMismatchInvalidOptions] == 0,
				Nothing,
				Test["The option PreparedMarkerPlate can only be Not Null if, and only if, MarkerInjection is True.:", True, False]
			];
			passingTest = If[Length[markerInjectionPreparedMarkerPlateMismatchInvalidOptions] != 0,
				Nothing,
				Test["The option PreparedMarkerPlate can only be Not Null if, and only if, MarkerInjection is True.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(* ---PreSample Rinse Conflicting Options check--- *)
	
	(* ---PreSample Rinse Conflicting Options check--- *)
	(*If PreSampleRinse related options (PreSampleRinseBuffer,NumberOfPreSampleRinses,PreSampleRinseBufferPlateStorageCondition) can only be Null if, and only if, PreSampleRinse is False*)
	preSampleRinseMismatchErrors = Map[
		Or[MatchQ[resolvedPreSampleRinse, False] && MatchQ[#1, Except[Null]], MatchQ[resolvedPreSampleRinse, True] && MatchQ[#1, Null]]&,
		{resolvedPreSampleRinseBuffer, resolvedNumberOfPreSampleRinses, resolvedPreSampleRinseBufferPlateStorageCondition}
	];
	
	preSampleRinseMismatchInvalidOptions = If[MemberQ[preSampleRinseMismatchErrors, True] && messages,
		Message[Error::PreSampleRinseOptionsMismatchErrors, ObjectToString[Join[PickList[{resolvedPreSampleRinseBuffer, resolvedNumberOfPreSampleRinses, resolvedPreSampleRinseBufferPlateStorageCondition}, preSampleRinseMismatchErrors], {resolvedPreSampleRinse}],Cache -> cacheBall], Join[PickList[{PreSampleRinseBuffer, NumberOfPreSampleRinses, PreSampleRinseBufferPlateStorageCondition}, preSampleRinseMismatchErrors], {PreSampleRinse}]];
		Join[PickList[{PreSampleRinseBuffer, NumberOfPreSampleRinses, PreSampleRinseBufferPlateStorageCondition}, preSampleRinseMismatchErrors], {PreSampleRinse}],
		{}
	];
	
	(* Generate Test for PreSampleRinse Options check *)
	preSampleRinseMismatchTests = If[gatherTests && MemberQ[preSampleRinseMismatchErrors, True],
		Module[{failingTest, passingTest},
			failingTest = If[Length[preSampleRinseMismatchInvalidOptions] == 0,
				Nothing,
				Test["The options PreSampleRinseBuffer, NumberOfPreSampleRinses, and PreSampleRinseBufferPlateStorageCondition can only be Null if, and only if, PreSampleRinse is False.:", True, False]
			];
			passingTest = If[Length[preSampleRinseMismatchInvalidOptions] != 0,
				Nothing,
				Test["The options PreSampleRinseBuffer, NumberOfPreSampleRinses, and PreSampleRinseBufferPlateStorageCondition can only be Null if, and only if, PreSampleRinse is False.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(* Generate Test for CapillaryEquilibration Options check *)
	preSampleRinseMismatchTests = If[gatherTests && MemberQ[preSampleRinseMismatchErrors, True],
		Module[{failingTest, passingTest},
			failingTest = If[Length[preSampleRinseMismatchInvalidOptions] == 0,
				Nothing,
				Test["The options PreSampleRinseBuffer and NumberOfPreSampleRinses can only be Null if, and only if, PreSampleRinse is False.:", True, False]
			];
			passingTest = If[Length[preSampleRinseMismatchInvalidOptions] != 0,
				Nothing,
				Test["The options PreSampleRinseBuffer and NumberOfPreSampleRinses can only be Null if, and only if, PreSampleRinse is False.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	ladderPreparedPlateMismatchInvalidOptions = If[MemberQ[resolvedLadderPreparedPlateMismatchError, True] && messages,
		Message[Error::LadderPreparedPlateMismatchError, ObjectToString[PickList[listedResolvedLadder, resolvedLadderPreparedPlateMismatchError],Cache -> cacheBall], resolvedPreparedPlate];
		{Ladder, PreparedPlate},
		{}
	];
	
	(* Generate Test for Ladder and PreparedPlate check *)
	ladderPreparedPlateMismatchTests = If[gatherTests && MemberQ[resolvedLadderPreparedPlateMismatchError, True],
		Module[{failingTest, passingTest},
			failingTest = If[Length[ladderPreparedPlateMismatchInvalidOptions] == 0,
				Nothing,
				Test["Ladder value can only have pattern WellPositionP if PreparedPlate is True.:", True, False]
			];
			passingTest = If[Length[ladderPreparedPlateMismatchInvalidOptions] != 0,
				Nothing,
				Test["Ladder value can only have pattern WellPositionP if PreparedPlate is True.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	ladderOptionsPreparedPlateMismatchInvalidOptions = If[MemberQ[resolvedLadderOptionsPreparedPlateErrors, True] && messages,
		Message[Error::LadderOptionsPreparedPlateMismatchError, resolvedLadderOptionsPreparedPlateMismatchOptions, ObjectToString[PickList[listedResolvedLadder, resolvedLadderOptionsPreparedPlateErrors],Cache -> cacheBall]];
		DeleteDuplicates[Flatten[Join[resolvedLadderOptionsPreparedPlateMismatchOptions, {Ladder}]]],
		{}
	];
	
	(* Generate Test for Ladder Options and PreparedPlate check *)
	ladderOptionsPreparedPlateMismatchTests = If[gatherTests && MemberQ[resolvedLadderOptionsPreparedPlateErrors, True],
		Module[{failingTest, passingTest},
			failingTest = If[Length[ladderOptionsPreparedPlateMismatchInvalidOptions] == 0,
				Nothing,
				Test["if PreparedPlate is True, options LadderVolume,LadderLoadingBuffer,LadderLoadingBufferVolume, LadderRunningBuffer,LadderMarker must be Null.:", True, False]
			];
			passingTest = If[Length[ladderOptionsPreparedPlateMismatchInvalidOptions] != 0,
				Nothing,
				Test["if PreparedPlate is True, options LadderVolume,LadderLoadingBuffer,LadderLoadingBufferVolume, LadderRunningBuffer,LadderMarker must be Null.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	ladderVolumeMismatchInvalidOptions = If[MemberQ[resolvedLadderVolumeMismatchError, True] && messages,
		Message[Error::LadderVolumeMismatchError, PickList[mapResolvedLadderVolume, resolvedLadderVolumeMismatchError], PickList[listedResolvedLadder, resolvedLadderVolumeMismatchError]];
		{Ladder, LadderVolume},
		{}
	];
	
	ladderLoadingBufferMismatchInvalidOptions = If[MemberQ[resolvedLadderLoadingBufferMismatchError, True] && messages,
		Message[Error::LadderLoadingBufferMismatchError, PickList[mapResolvedLadderLoadingBuffer, resolvedLadderLoadingBufferMismatchError], PickList[listedResolvedLadder, resolvedLadderLoadingBufferMismatchError]];
		{Ladder, LadderLoadingBuffer},
		{}
	];
	
	ladderLoadingBufferVolumeMismatchInvalidOptions = If[MemberQ[resolvedLadderLoadingBufferVolumeMismatchError, True] && messages,
		Message[Error::LadderLoadingBufferVolumeMismatchError, PickList[mapResolvedLadderLoadingBufferVolume, resolvedLadderLoadingBufferVolumeMismatchError], PickList[mapResolvedLadderLoadingBuffer, resolvedLadderLoadingBufferVolumeMismatchError]];
		{LadderLoadingBuffer, LadderLoadingBufferVolume},
		{}
	];
	
	maxLadderVolumeInvalidOptions = If[MemberQ[resolvedMaxLadderVolumeError, True] && messages,
		Message[Error::MaxLadderVolumeError, PickList[resolvedTotalLadderSolutionVolume, resolvedMaxLadderVolumeError], PickList[resolvedMaxLadderVolumeBadOptions, resolvedMaxLadderVolumeError], ObjectToString[PickList[listedResolvedLadder, resolvedMaxLadderVolumeError],Cache -> cacheBall]];
		PickList[resolvedMaxLadderVolumeBadOptions, resolvedMaxLadderVolumeError],
		{}
	];
	
	ladderRunningBufferMismatchInvalidOptions = If[MemberQ[resolvedLadderRunningBufferMismatchError, True] && messages,
		Message[Error::LadderRunningBufferMismatchError, PickList[mapResolvedLadderRunningBuffer, resolvedLadderRunningBufferMismatchError], PickList[listedResolvedLadder, resolvedLadderRunningBufferMismatchError]];
		{LadderRunningBuffer, Ladder},
		{}
	];
	
	ladderMarkerMismatchInvalidOptions = If[MemberQ[resolvedLadderMarkerMismatchError, True] && messages,
		Message[Error::LadderMarkerMismatchError, PickList[mapResolvedLadderMarker, resolvedLadderMarkerMismatchError], PickList[listedResolvedLadder, resolvedLadderMarkerMismatchError]];
		{LadderMarker, Ladder},
		{}
	];
	
	blankRunningBufferMismatchInvalidOptions = If[MemberQ[resolvedBlankRunningBufferMismatchError, True] && messages,
		Message[Error::BlankRunningBufferMismatchError, PickList[mapResolvedBlankRunningBuffer, resolvedBlankRunningBufferMismatchError], PickList[resolvedBlank, resolvedBlankRunningBufferMismatchError]];
		{BlankRunningBuffer, Blank},
		{}
	];

	blankMarkerMismatchInvalidOptions = If[MemberQ[resolvedBlankMarkerMismatchError, True] && messages,
		Message[Error::BlankMarkerMismatchError, PickList[mapResolvedBlankMarker, resolvedBlankMarkerMismatchError], PickList[resolvedBlank, resolvedBlankMarkerMismatchError]];
		{BlankMarker, Blank},
		{}
	];

	If[MemberQ[resolvedAnalysisMethodLadderMismatchWarning, True] && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::AnalysisMethodLadderMismatch, ObjectToString[PickList[listedResolvedLadder, resolvedAnalysisMethodLadderMismatchWarning],Cache -> cacheBall]],
		Nothing
	];

	If[MemberQ[resolvedAnalysisMethodBlankMismatchWarning, True] && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::AnalysisMethodBlankMismatch, ObjectToString[PickList[resolvedBlank, resolvedAnalysisMethodBlankMismatchWarning],Cache -> cacheBall]],
		Nothing
	];
	
	If[MemberQ[resolvedAnalysisMethodLadderOptionsMismatchWarning, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::AnalysisMethodLadderOptionsMismatch, PickList[resolvedAnalysisMethodLadderOptionsMismatchList, resolvedAnalysisMethodLadderOptionsMismatchWarning], ObjectToString[PickList[listedResolvedLadder, resolvedAnalysisMethodLadderOptionsMismatchWarning],Cache -> cacheBall]],
		Nothing
	];

	If[MemberQ[resolvedAnalysisMethodBlankOptionsMismatchWarning, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::AnalysisMethodBlankOptionsMismatch, PickList[resolvedAnalysisMethodBlankOptionsMismatchList, resolvedAnalysisMethodBlankOptionsMismatchWarning], ObjectToString[PickList[resolvedBlank, resolvedAnalysisMethodBlankOptionsMismatchWarning],Cache -> cacheBall]],
		Nothing
	];
	
	If[MemberQ[resolvedCantCalculateSampleVolumeWarning, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::CantCalculateSampleVolume, PickList[resolvedSampleVolume, resolvedCantCalculateSampleVolumeWarning], ObjectToString[PickList[simulatedSamples, resolvedCantCalculateSampleVolumeWarning],Cache -> cacheBall]],
		Nothing
	];
	
	If[MemberQ[resolvedCantCalculateSampleDiluentVolumeWarning, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::CantCalculateSampleDiluentVolume, PickList[resolvedSampleDiluentVolume, resolvedCantCalculateSampleDiluentVolumeWarning], ObjectToString[PickList[simulatedSamples, resolvedCantCalculateSampleDiluentVolumeWarning],Cache -> cacheBall]],
		Nothing
	];
	
	sampleOptionsPreparedPlateMismatchInvalidOptions = If[MemberQ[resolvedSampleOptionsPreparedPlateError, True] && messages,
		Message[Error::SampleOptionsPreparedPlateMismatchError, resolvedSampleOptionsPreparedPlateMismatchOptions, resolvedPreparedPlate, ObjectToString[PickList[simulatedSamples, resolvedSampleOptionsPreparedPlateError],Cache -> cacheBall]];
		Join[Flatten[resolvedSampleOptionsPreparedPlateMismatchOptions], {PreparedPlate}],
		{}
	];
	
	(* Generate Test for Sample Options and PreparedPlate check *)
	sampleOptionsPreparedPlateMismatchTests = If[gatherTests && MemberQ[resolvedSampleOptionsPreparedPlateError, True],
		Module[{failingTest, passingTest},
			failingTest = If[Length[sampleOptionsPreparedPlateMismatchInvalidOptions] == 0,
				Nothing,
				Test["If PreparedPlate is True, SampleDilution must be False and options SampleDiluent,SampleVolume,SampleDiluentVolume,SampleLoadingBuffer, and SampleLoadingBufferVolume must be Null.:", True, False]
			];
			passingTest = If[Length[sampleOptionsPreparedPlateMismatchInvalidOptions] != 0,
				Nothing,
				Test["If PreparedPlate is True, SampleDilution must be False and options SampleDiluent,SampleVolume,SampleDiluentVolume,SampleLoadingBuffer, and SampleLoadingBufferVolume must be Null.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	sampleVolumeErrorInvalidOptions = If[MemberQ[resolvedSampleVolumeErrors, True] && messages,
		Message[Error::SampleVolumeError, PickList[resolvedSampleVolume, resolvedSampleVolumeErrors], ObjectToString[PickList[simulatedSamples, resolvedSampleVolumeErrors],Cache -> cacheBall]];
		Join[PickList[resolvedSampleVolume, resolvedSampleVolumeErrors], {SampleVolume}],
		{}
	];
	
	(* Generate Test for SampleVolume check *)
	sampleVolumeErrorTests = If[gatherTests,
		Module[{failingInputs, passingInputs, failingOptions, passingOptions, passingInputsTest, failingInputTest},
			
			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, resolvedSampleVolumeErrors];
			passingInputs = PickList[simulatedSamples, resolvedSampleVolumeErrors, False];
			failingOptions = PickList[resolvedSampleVolume, resolvedSampleVolumeErrors];
			passingOptions = PickList[resolvedSampleVolume, resolvedSampleVolumeErrors, False];
			
			(* Create the passing and failing tests *)
			failingInputTest = If[MatchQ[Length[failingInputs],GreaterP[0]],
				Test["The " <> ToString[failingOptions] <> " not valid for the following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ". If PreparedPlate is False, SampleVolume cannot be Null.:", True, False],
				Nothing
			];
			
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The SampleVolume are valid for the following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			
			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];
	
	sampleDilutionMismatchInvalidOptions = If[MemberQ[resolvedSampleDilutionMismatchErrors, True] && messages,
		Message[Error::SampleDilutionMismatch, PickList[resolvedSampleDilutionMismatchOptions, resolvedSampleDilutionMismatchErrors], PickList[resolvedSampleDilution, resolvedSampleDilutionMismatchErrors], PickList[simulatedSamples, resolvedSampleDilutionMismatchErrors]];
		Join[PickList[resolvedSampleDilutionMismatchOptions, resolvedSampleDilutionMismatchErrors], {SampleDilution}],
		{}
	];
	
	(* Generate Test for Sample Dilution Options check *)
	sampleDilutionMismatchTests = If[gatherTests,
		Module[{failingInputs, passingInputs, failingOptions, passingOptions, passingInputsTest, failingInputTest},
			
			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, resolvedSampleDilutionMismatchErrors];
			passingInputs = PickList[simulatedSamples, resolvedSampleDilutionMismatchErrors, False];
			failingOptions = PickList[resolvedSampleDilutionMismatchOptions, resolvedSampleDilutionMismatchErrors];
			passingOptions = PickList[resolvedSampleDilutionMismatchOptions, resolvedSampleDilutionMismatchErrors, False];
			
			(* Create the passing and failing tests *)
			failingInputTest = If[MatchQ[Length[failingInputs],GreaterP[0]],
				Test["The " <> ToString[failingOptions] <> " are mismatched with SampleDilution for following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ":", True, False],
				Nothing
			];
			
			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The SampleDiluent and SampleDiluentVolume are compatible with SampleDilution for following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ":", True, True],
				Nothing
			];
			
			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];
	
	sampleLoadingBufferVolumeMismatchInvalidOptions = If[MemberQ[resolvedSampleLoadingBufferVolumeMismatchError, True] && messages,
		Message[Error::SampleLoadingBufferVolumeMismatchError, PickList[resolvedSampleLoadingBufferVolume, resolvedSampleLoadingBufferVolumeMismatchError], ObjectToString[PickList[resolvedSampleLoadingBuffer, resolvedSampleLoadingBufferVolumeMismatchError],Cache -> cacheBall], PickList[simulatedSamples, resolvedSampleLoadingBufferVolumeMismatchError]];
		{SampleLoadingBuffer, SampleLoadingBufferVolume},
		{}
	];
	
	(* Generate Test for SampleLoadingBufferVolume and SampleLoadingBuffer check *)
	sampleLoadingBufferVolumeMismatchTests = If[gatherTests && MemberQ[resolvedSampleLoadingBufferVolumeMismatchError, True],
		Module[{failingTest, passingTest},
			failingTest = If[Length[sampleLoadingBufferVolumeMismatchInvalidOptions] == 0,
				Nothing,
				Test["SampleLoadingBufferVolume can only be Null if, and only if, SampleLoadingBuffer is Null.:", True, False]
			];
			passingTest = If[Length[sampleLoadingBufferVolumeMismatchInvalidOptions] != 0,
				Nothing,
				Test["SampleLoadingBufferVolume can only be Null if, and only if, SampleLoadingBuffer is Null.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	maxSampleVolumeInvalidOptions = If[MemberQ[resolvedMaxSampleVolumeError, True] && messages,
		Message[Error::MaxSampleVolumeError, PickList[resolvedTotalSampleSolutionVolume, resolvedMaxSampleVolumeError], PickList[resolvedMaxSampleVolumeBadOptions, resolvedMaxSampleVolumeError], ObjectToString[PickList[simulatedSamples, resolvedMaxSampleVolumeError]],Cache -> cacheBall];
		PickList[resolvedMaxSampleVolumeBadOptions, resolvedMaxSampleVolumeError],
		{}
	];

	If[MemberQ[resolvedAnalysisMethodSampleOptionsMismatchWarning, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::AnalysisMethodSampleOptionsMismatch, PickList[resolvedAnalysisMethodSampleOptionsMismatchList, resolvedAnalysisMethodSampleOptionsMismatchWarning], ObjectToString[PickList[simulatedSamples, resolvedAnalysisMethodSampleOptionsMismatchWarning],Cache -> cacheBall]],
		Nothing
	];
	
	blankPreparedPlateMismatchInvalidOptions = If[MemberQ[resolvedBlankPreparedPlateMismatchError, True] && messages,
		Message[Error::BlankPreparedPlateMismatchError, ObjectToString[PickList[ToList[resolvedBlank], resolvedBlankPreparedPlateMismatchError],Cache -> cacheBall], resolvedPreparedPlate];
		{Blank, PreparedPlate},
		{}
	];
	
	(* Generate Test for Blank and PreparedPlate check *)
	blankPreparedPlateMismatchTests = If[gatherTests && MemberQ[resolvedBlankPreparedPlateMismatchError, True],
		Module[{failingTest, passingTest},
			failingTest = If[Length[blankPreparedPlateMismatchInvalidOptions] == 0,
				Nothing,
				Test["Blank value can only have pattern WellPositionP if PreparedPlate is True.:", True, False]
			];
			passingTest = If[Length[blankPreparedPlateMismatchInvalidOptions] != 0,
				Nothing,
				Test["Blank value can only have pattern WellPositionP if PreparedPlate is True.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(*Check if total number of Samples,Ladder and Blanks is greater than 96*)
	(*if total number of samples is already greater than 96, no need to check since an error will already be thrown as TooManySamples*)
	tooManySolutionsForInjectionError = If[MatchQ[numberOfSamples, LessEqualP[96]]&&MatchQ[resolvedPreparedPlate,False],
		MatchQ[numberOfSolutionsForInjection, GreaterP[96]],
		False
	];
	
	tooManySolutionsForInjectionInvalidOptions = Which[
		!tooManySolutionsForInjectionError,
		{},
		
		MatchQ[resolvedBlank, {WellPositionP..} | WellPositionP],
		Message[Error::TooManySolutionsForInjection, numberOfSamples, numberOfLadders, numberOfBlanks, numberOfSolutionsForInjection];
		{Ladder, Blank},
		
		!MatchQ[resolvedBlank, {WellPositionP..} | WellPositionP],
		Message[Error::TooManySolutionsForInjection, numberOfSamples, numberOfLadders, numberOfBlanks, numberOfSolutionsForInjection];
		{Ladder}
	];
	
	(* Generate Test for SampleLoadingBufferVolume and SampleLoadingBuffer check *)
	tooManySolutionsForInjectionTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[tooManySolutionsForInjectionInvalidOptions] == 0,
				Nothing,
				Test["The total number of samples, Ladder and Blank must be less than 96:", True, False]
			];
			passingTest = If[Length[tooManySolutionsForInjectionInvalidOptions] != 0,
				Nothing,
				Test["The total number of samples, Ladder and Blank must be less than 96:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(*If PreparedPlate is True, check if total number of Samples,Ladder and Blanks is less than 96*)
	notEnoughSolutionsForInjectionError = MatchQ[numberOfSolutionsForInjection, LessP[96]];
	
	notEnoughSolutionsForInjectionInvalidOptions = If[notEnoughSolutionsForInjectionError,
		Message[Error::NotEnoughSolutionsForInjection, numberOfSamples, numberOfLadders, numberOfBlanks, numberOfSolutionsForInjection];
		{Ladder, Blank},
		{}
	];
	
	(* Generate Test for SampleLoadingBufferVolume and SampleLoadingBuffer check *)
	notEnoughSolutionsForInjectionTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[notEnoughSolutionsForInjectionInvalidOptions] == 0,
				Nothing,
				Test["If PreparedPlate is True, the total number of samples, Ladder and Blank must be equal to 96:", True, False]
			];
			passingTest = If[Length[tooManySolutionsForInjectionInvalidOptions] != 0,
				Nothing,
				Test["If PreparedPlate is True, the total number of samples, Ladder and Blank must be equal to 96:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	(*If PreparedRunningBufferPlate is an Object[Container,Plate], SampleRunningBuffer, LadderRunningBuffer and BlankRunningBuffer must be the contents of the Object[Container,Plate] or Null (if applicable)*)
	preparedLadderRunningBufferPlateMismatchError = If[!MatchQ[resolvedPreparedRunningBufferPlate, ObjectP[Object[Container, Plate]]],
		False,
		MemberQ[resolvedPreparedLadderRunningBufferMismatchCheck, True]
	];
	
	preparedSampleRunningBufferPlateMismatchError = If[!MatchQ[resolvedPreparedRunningBufferPlate, ObjectP[Object[Container, Plate]]],
		False,
		MemberQ[resolvedPreparedSampleRunningBufferMismatchCheck, True]
	];
	
	preparedBlankRunningBufferPlateMismatchError = If[!MatchQ[resolvedPreparedRunningBufferPlate, ObjectP[Object[Container, Plate]]],
		False,
		MemberQ[resolvedPreparedBlankRunningBufferMismatchCheck, True]
	];
	
	preparedRunningBufferPlateIncompatibleOptionsList = PickList[{SampleRunningBuffer, LadderRunningBuffer, BlankRunningBuffer}, {preparedSampleRunningBufferPlateMismatchError, preparedLadderRunningBufferPlateMismatchError, preparedBlankRunningBufferPlateMismatchError}];
	
	preparedRunningBufferPlateMismatchInvalidOptions = If[MatchQ[Length[preparedRunningBufferPlateIncompatibleOptionsList], GreaterP[0]],
		Message[Error::PreparedRunningBufferPlateError, preparedRunningBufferPlateIncompatibleOptionsList];
		Flatten[{PreparedRunningBufferPlate, preparedRunningBufferPlateIncompatibleOptionsList}],
		{}
	];
	
	(*If PreparedMarkerPlate is an Object[Container,Plate], SampleMarker, LadderMarker and BlankMarker must be the contents of the Object[Container,Plate] or Null (if applicable)*)
	preparedLadderMarkerPlateMismatchError = Which[
		!MatchQ[resolvedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]],
		False,
		
		MatchQ[suppliedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]],
		MemberQ[resolvedPreparedLadderMarkerMismatchCheck, True]
	];
	
	preparedSampleMarkerPlateMismatchError = Which[
		!MatchQ[resolvedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]],
		False,
		
		MatchQ[suppliedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]],
		MemberQ[resolvedPreparedSampleMarkerMismatchCheck, True]
	];
	
	preparedBlankMarkerPlateMismatchError = Which[
		!MatchQ[resolvedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]],
		False,

		MatchQ[suppliedPreparedMarkerPlate, ObjectP[Object[Container, Plate]]],
		MemberQ[resolvedPreparedBlankMarkerMismatchCheck, True]
	];
	
	preparedMarkerPlateIncompatibleOptionsList = PickList[{SampleMarker, LadderMarker, BlankMarker}, {preparedSampleMarkerPlateMismatchError, preparedLadderMarkerPlateMismatchError, preparedBlankMarkerPlateMismatchError}];
	
	preparedMarkerPlateMismatchInvalidOptions = If[MatchQ[Length[preparedMarkerPlateIncompatibleOptionsList], GreaterP[0]],
		Message[Error::PreparedMarkerPlateError, preparedMarkerPlateIncompatibleOptionsList];
		Flatten[{PreparedMarkerPlate, preparedMarkerPlateIncompatibleOptionsList}],
		{}
	];
	
	(*Aliquot Options Resolution*)
	(*Aliquot Resolution*)
	(*Samples must be in LH-compatible container prior to transfer to SamplePlate since Robotic preparation is required to handle small volumes in a more reproducible way*)
	(*If sample is not in an LH-compatible container, Aliquot is required*)
	sampleContainers = Map[fastAssocLookup[fastAssoc, #, Container]&, mySamples];
	sampleContainerModels = Map[fastAssocLookup[fastAssoc, #, Model]&, sampleContainers];
	
	resolvedAliquot = MapThread[
		Which[
			(*if suppliedAliquot is not Automatic, use supplied value*)
			MatchQ[#1, Except[Automatic]],
			#1,
			
			(*Resolution if suppliedAliquot is Automatic*)
			
			(*if AliquotContainer is an Object OR if there is a specified AliquotAmount, set to True*)
			MatchQ[#3, ObjectP[]] || QuantityQ[#4],
			True,
			
			(*if PreparedPlate is True, Aliquot is not allowed*)
			MatchQ[resolvedPreparedPlate, True],
			False,
			
			(*If the sample is already in an LH-compatible container model, Aliquot is False*)
			MemberQ[roboticCompatibleContainerModels, ObjectP[#2]],
			False,
			
			(*If the sample is NOT in an LH-compatible model, Aliquot is required and set to True*)
			True,
			True
		]&,
		{suppliedAliquot, sampleContainerModels, suppliedAliquotContainer, suppliedAliquotAmount}
	];
	
	(*This code sets the minmimum required aliquot to the required SampleVolume or 20 Microliter whichever is higher but does not take into account the possibility that for ConsolidateAliquot -> True, in which case there will be a lot of excess *)
	(*In order to make sure that the sample plate preparation can be successfully done via Robotic means, whenever a sample source is not in an LH-compatible container, RequiredAliquotAmount will be set to a quantity in order to force aliquoting - whichever is higher: resolvedSampleVolume*1.1 or 20 microliter*)
	(*20 Microliter is the minimum volume that will ensure proper robotic transfer of samples that will most likely be around 2 Microliter*)
	resolvedRequiredAliquotAmounts = MapThread[
		Which[
			(*If the container of the Sample is not LH-compatible, set to at least 20 Microliter - this is the lowest amount for a reliable transfer using LH*)
			!MemberQ[roboticCompatibleContainerModels, ObjectP[#1]],
			If[MatchQ[#2, GreaterP[20 Microliter]],
				#2 * 1.1,
				20 Microliter
			],
			(*If resolvedAliquot is set to True, set to at least 20 Microliter - this is the lowest amount for a reliable transfer using LH*)
			MatchQ[#3, True],
			If[MatchQ[#2, GreaterP[20 Microliter]],
				#2 * 1.1,
				20 Microliter
			],
			(*Otherwise (in case of Null or anything else), set to Null*)
			(*If sample is in LH-compatible container and Aliquot is False, we won't be able to check here if there is enough sample to the resolvedSampleVolume effectively into the SamplePlate - this is checked via resource packet*)
			True,
			Null
		]&,
		{
			sampleContainerModels,
			resolvedSampleVolume,
			resolvedAliquot
		}
	];
	
	(*Consider ConsolidateAliquots*)
	resolvedConsolidateAliquots = If[MatchQ[suppliedConsolidateAliquots, Except[Automatic]],
		suppliedConsolidateAliquots,
		False
	];
	
	sampleToVolumeRules = MapThread[
		#1 -> #2&,
		{
			mySamples,
			resolvedRequiredAliquotAmounts
		}
	];
	
	mergedSampleToVolumeRules = Merge[sampleToVolumeRules, Total];
	
	mergedSampleToRequiredContainerRules = KeyValueMap[
		#1 -> PreferredContainer[#2, LiquidHandlerCompatible -> True]&,
		mergedSampleToVolumeRules
	];
	
	(*RequiredAliquotContainer Resolution*)
	(*Get the list of models associated with each member of RequiredAliquotContainers*)
	suppliedAliquotContainerModels = Map[
		If[MatchQ[#, ObjectP[Object[Container]]],
			fastAssocLookup[fastAssoc, #, Model],
			#
		]&,
		suppliedAliquotContainer
	];
	
	(*If sample is in a non-LH compatible container, Aliquot is required - we make sure of this by setting the RequiredAliquotContainer to an LH-compatible one*)
	resolvedRequiredAliquotContainers = MapThread[
		Which[
			(*If resolvedAliquot is False and sample is in LH-compatible container, set to Null*)
			MatchQ[#1, False] && MemberQ[roboticCompatibleContainerModels, ObjectP[#2]],
			Null,
			
			(*If resolvedAliquot is False and sample is in non LH-compatible container, set to preferred container based on resolvedRequiredAliquotAmount*)
			(*ConsolidateAliquots is True*)
			MatchQ[#1, False] && !MemberQ[roboticCompatibleContainerModels, ObjectP[#2]] && MatchQ[suppliedConsolidateAliquots, True],
			Lookup[mergedSampleToRequiredContainerRules, #6],
			(*ConsolidateAliquots is False*)
			MatchQ[#1, False] && !MemberQ[roboticCompatibleContainerModels, ObjectP[#2]],
			PreferredContainer[#3, LiquidHandlerCompatible -> True],
			
			(*If resolvedAliquot is True and AliquotContainer is specified and model is LH-compatible, set to the specified AliquotContainer*)
			MatchQ[#1, True] && MemberQ[roboticCompatibleContainerModels, ObjectP[#4]],
			#5,
			
			(*If resolvedAliquot is True and AliquotContainer is specified and model is Not LH-compatible, set to preferred container based on resolvedRequiredAliquotAmount*)
			(*ConsolidateAliquots is True*)
			MatchQ[#1, True] && !MemberQ[roboticCompatibleContainerModels, ObjectP[#4]] && MatchQ[suppliedConsolidateAliquots, True],
			Lookup[mergedSampleToRequiredContainerRules, #6],
			(*ConsolidateAliquots is False*)
			MatchQ[#1, True] && !MemberQ[roboticCompatibleContainerModels, ObjectP[#4]],
			PreferredContainer[#3, LiquidHandlerCompatible -> True],
			
			(*If resolvedAliquot is True and AliquotContainer is not specified, set to preferred container based on resolvedRequiredAliquotAmount*)
			(*ConsolidateAliquots is True*)
			MatchQ[#5, Automatic] && MatchQ[suppliedConsolidateAliquots, True],
			Lookup[mergedSampleToRequiredContainerRules, #6],
			(*ConsolidateAliquots is False*)
			MatchQ[#5, Automatic],
			PreferredContainer[#3, LiquidHandlerCompatible -> True]
		]&,
		{
			(*1*)    resolvedAliquot,
			(*2*)    sampleContainerModels,
			(*3*)    resolvedRequiredAliquotAmounts,
			(*4*)    suppliedAliquotContainerModels,
			(*5*)    suppliedAliquotContainer,
			(*6*)    mySamples
		}
	];
	
	(*If PreparedPlate is True and Aliquot has a True, throw error*)
	preparedPlateAliquotMismatchError = MatchQ[resolvedPreparedPlate, True] && MemberQ[resolvedAliquot, True];
	
	preparedPlateAliquotMismatchInvalidOptions = If[preparedPlateAliquotMismatchError && messages,
		Message[Error::PreparedPlateAliquotMismatchError];
		{PreparedPlate, Aliquot},
		{}
	];
	
	(* Generate Test for PreparedPlate and Aliquot check *)
	preparedPlateAliquotMismatchTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[preparedPlateAliquotMismatchInvalidOptions] == 0,
				Nothing,
				Test["If PreparedPlate is True, Aliquot must all be False, and vice versa.:", True, False]
			];
			passingTest = If[Length[preparedPlateAliquotMismatchInvalidOptions] != 0,
				Nothing,
				Test["If PreparedPlate is True, Aliquot must all be False, and vice versa.:", True, True]
			];
			
			{failingTest, passingTest}
		],
		Nothing
	];
	
	aliquotWarningMessage = "because the given samples are in containers that are not compatible with the FragmentAnalyzer. If aliquoting a sample, the resulting AssayVolume must match the desired SampleVolume.";
	
	(*Resolve aliquot options and make tests*)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[
			ExperimentFragmentAnalysis,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions, Join[resolvedSamplePrepOptions, {Aliquot -> resolvedAliquot, ConsolidateAliquots -> resolvedConsolidateAliquots}]],
			Cache -> cache,
			Simulation -> simulation,
			RequiredAliquotAmounts -> resolvedRequiredAliquotAmounts,
			RequiredAliquotContainers -> resolvedRequiredAliquotContainers,
			AliquotWarningMessage -> aliquotWarningMessage,
			Output -> {Result, Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentFragmentAnalysis,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions, Join[resolvedSamplePrepOptions, {Aliquot -> resolvedAliquot}]],
				Cache -> cache,
				Simulation -> simulation,
				RequiredAliquotAmounts -> resolvedRequiredAliquotAmounts,
				RequiredAliquotContainers -> resolvedRequiredAliquotContainers,
				AliquotWarningMessage -> aliquotWarningMessage,
				Output -> Result],
			{}
		}
	];
	
	(*DuplicateWells Check*)
	(*Get the list of all assigned wells dedicated to samples, ladders, and blanks*)
	assignedWells = If[MatchQ[resolvedPreparedPlate, True],
		Join[Cases[ToList[sampleWells], _String], Cases[listedResolvedLadder, _String], Cases[ToList[resolvedBlank], _String]],
		{}
	];
	
	(*Check if there are any duplicated wells*)
	duplicatedWells = If[MatchQ[resolvedPreparedPlate, True],
		DeleteDuplicates[
			Flatten[Select[Gather[assignedWells],
				Length[#] > 1 &]]
		],
		{}
	];
	
	(*Check which options have duplicated wells in order to indicate this in the Error message*)
	optionsWithDuplicatedWellCheck = If[MatchQ[resolvedPreparedPlate, True],
		ContainsAny[#, duplicatedWells]& /@ {sampleWells, listedResolvedLadder, ToList[resolvedBlank]},
		{}
	];
	
	(*Check if we need to throw a duplicate wells error*)
	duplicateWellsError = !DuplicateFreeQ[assignedWells];
	
	duplicateWellsInvalidOptions = If[duplicateWellsError && messages,
		Message[Error::DuplicateWells, duplicatedWells, PickList[{Sample, Ladder, Blank}, optionsWithDuplicatedWellCheck]];
		PickList[{Ladder, Blank}, Drop[optionsWithDuplicatedWellCheck, 1]],
		{}
	];
	
	duplicateWellsTests = If[gatherTests,
		Module[{failingTest, passingTest},
			
			failingTest = If[Length[duplicateWellsInvalidOptions] == 0,
				Nothing,
				Test["All WellPosition should be unique. Sample DestinationWell, Ladder (if PreparedPlate is True) and Blank (if PreparedPlate is True) should not have any duplicate wells.:", True, False]
			];
			passingTest = If[Length[duplicateWellsInvalidOptions] != 0,
				Nothing,
				Test["All WellPosition should be unique. Sample DestinationWell, Ladder (if PreparedPlate is True) and Blank (if PreparedPlate is True) should not have any duplicate wells:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];
	
	
	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs}]];
	invalidOptions = DeleteDuplicates[Flatten[{
		analysisMethodNameInvalidOptions,
		capillaryFlushNumberOfCapillaryFlushesMismatchInvalidOptions,
		primaryCapillaryFlushMismatchInvalidOptions,
		secondaryCapillaryFlushMismatchInvalidOptions,
		tertiaryCapillaryFlushMismatchInvalidOptions,
		capillaryEquilibrationMismatchInvalidOptions,
		preMarkerRinseMismatchInvalidOptions,
		markerInjectionMismatchInvalidOptions,
		markerInjectionPreparedMarkerPlateMismatchInvalidOptions,
		preSampleRinseMismatchInvalidOptions,
		ladderPreparedPlateMismatchInvalidOptions,
		ladderVolumeMismatchInvalidOptions,
		ladderLoadingBufferMismatchInvalidOptions,
		sampleOptionsPreparedPlateMismatchInvalidOptions,
		sampleLoadingBufferVolumeMismatchInvalidOptions,
		blankRunningBufferMismatchInvalidOptions,
		blankMarkerMismatchInvalidOptions,
		ladderLoadingBufferVolumeMismatchInvalidOptions,
		maxLadderVolumeInvalidOptions,
		ladderRunningBufferMismatchInvalidOptions,
		ladderMarkerMismatchInvalidOptions,
		sampleDilutionMismatchInvalidOptions,
		maxSampleVolumeInvalidOptions,
		blankPreparedPlateMismatchInvalidOptions,
		tooManySolutionsForInjectionInvalidOptions,
		notEnoughSolutionsForInjectionInvalidOptions,
		preparedPlateAliquotMismatchInvalidOptions,
		duplicateWellsInvalidOptions,
		plateModelInvalidOptions,
		preparedRunningBufferPlateModelInvalidOptions,
		preparedMarkerPlateModelInvalidOptions,
		ladderOptionsPreparedPlateMismatchInvalidOptions,
		preparedRunningBufferPlateMismatchInvalidOptions,
		preparedMarkerPlateMismatchInvalidOptions,
		sampleVolumeErrorInvalidOptions
	}]];
	
	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs] > 0 && !gatherTests,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];
	
	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions] > 0 && !gatherTests,
		Message[Error::InvalidOption, invalidOptions]
	];
	
	(* get the final values for the resolved options related to Ladder and Blank *)
	{
		resolvedLadderVolume,
		resolvedLadderLoadingBuffer,
		resolvedLadderLoadingBufferVolume,
		resolvedLadderRunningBuffer,
		resolvedLadderMarker
	} = MapThread[
		If[MatchQ[#1,Except[Automatic]]&&!MemberQ[ToList[#1],Automatic],
			#1,

			(* if resolvedLadder is not a List (singleton input), related resolved option also returns singleton from the map resolution *)
			If[MatchQ[resolvedLadder,Except[_List]],
				#2[[1]],
				#2
			]
		]&,
		{
			{
				suppliedLadderVolume,
				suppliedLadderLoadingBuffer,
				suppliedLadderLoadingBufferVolume,
				suppliedLadderRunningBuffer,
				suppliedLadderMarker
			},
			{

				mapResolvedLadderVolume,
				mapResolvedLadderLoadingBuffer,
				mapResolvedLadderLoadingBufferVolume,
				mapResolvedLadderRunningBuffer,
				mapResolvedLadderMarker
			}
		}
	];

	{
		resolvedBlankRunningBuffer,
		resolvedBlankMarker
	} = MapThread[
		If[MatchQ[#1,Except[Automatic]]&&!MemberQ[ToList[#1],Automatic],
			#1,

			(* if resolvedBlank is not a List (singleton input), related resolved option also returns singleton from the map resolution *)
			If[MatchQ[resolvedBlank,Except[_List]],
				#2[[1]],
				#2
			]
		]&,
		{
			{
				suppliedBlankRunningBuffer,
				suppliedBlankMarker
			},
			{
				mapResolvedBlankRunningBuffer,
				mapResolvedBlankMarker
			}
		}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];
	resolvedOptions = ReplaceRule[
		allOptionsRounded,
		Join[
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			{
				AnalysisMethodName -> resolvedAnalysisMethodName,
				PreparedPlate -> resolvedPreparedPlate,
				MaxNumberOfRetries->resolvedMaxNumberOfRetries,
				AnalysisStrategy -> resolvedAnalysisStrategy,
				CapillaryArrayLength -> resolvedCapillaryArrayLength,
				SampleAnalyteType -> resolvedSampleAnalyteTypes,
				MinReadLength -> resolvedMinReadLength,
				MaxReadLength -> resolvedMaxReadLength,
				AnalysisMethod -> resolvedAnalysisMethod,
				SeparationGel -> resolvedSeparationGel,
				Dye -> resolvedDye,
				ConditioningSolution -> resolvedConditioningSolution,
				RunningBufferPlateStorageCondition -> resolvedRunningBufferPlateStorageCondition,
				CapillaryFlush -> resolvedCapillaryFlush,
				NumberOfCapillaryFlushes -> resolvedNumberOfCapillaryFlushes,
				PrimaryCapillaryFlushSolution -> resolvedPrimaryCapillaryFlushSolution,
				PrimaryCapillaryFlushPressure -> resolvedPrimaryCapillaryFlushPressure,
				PrimaryCapillaryFlushFlowRate -> resolvedPrimaryCapillaryFlushFlowRate,
				PrimaryCapillaryFlushTime -> resolvedPrimaryCapillaryFlushTime,
				SecondaryCapillaryFlushSolution -> resolvedSecondaryCapillaryFlushSolution,
				SecondaryCapillaryFlushPressure -> resolvedSecondaryCapillaryFlushPressure,
				SecondaryCapillaryFlushFlowRate -> resolvedSecondaryCapillaryFlushFlowRate,
				SecondaryCapillaryFlushTime -> resolvedSecondaryCapillaryFlushTime,
				TertiaryCapillaryFlushSolution -> resolvedTertiaryCapillaryFlushSolution,
				TertiaryCapillaryFlushPressure -> resolvedTertiaryCapillaryFlushPressure,
				TertiaryCapillaryFlushFlowRate -> resolvedTertiaryCapillaryFlushFlowRate,
				TertiaryCapillaryFlushTime -> resolvedTertiaryCapillaryFlushTime,
				CapillaryEquilibration -> resolvedCapillaryEquilibration,
				EquilibrationVoltage -> resolvedEquilibrationVoltage,
				EquilibrationTime -> resolvedEquilibrationTime,
				PreMarkerRinse -> resolvedPreMarkerRinse,
				NumberOfPreMarkerRinses -> resolvedNumberOfPreMarkerRinses,
				PreMarkerRinseBuffer -> resolvedPreMarkerRinseBuffer,
				PreMarkerRinseBufferPlateStorageCondition -> resolvedPreMarkerRinseBufferPlateStorageCondition,
				MarkerInjection -> resolvedMarkerInjection,
				MarkerInjectionTime -> resolvedMarkerInjectionTime,
				MarkerInjectionVoltage -> resolvedMarkerInjectionVoltage,
				PreSampleRinse -> resolvedPreSampleRinse,
				NumberOfPreSampleRinses -> resolvedNumberOfPreSampleRinses,
				PreSampleRinseBuffer -> resolvedPreSampleRinseBuffer,
				PreSampleRinseBufferPlateStorageCondition -> resolvedPreSampleRinseBufferPlateStorageCondition,
				SampleInjectionTime -> resolvedSampleInjectionTime,
				SampleInjectionVoltage -> resolvedSampleInjectionVoltage,
				SeparationTime -> resolvedSeparationTime,
				SeparationVoltage -> resolvedSeparationVoltage,
				PreparedRunningBufferPlate -> resolvedPreparedRunningBufferPlate,
				PreparedMarkerPlate -> resolvedPreparedMarkerPlate,
				Ladder -> resolvedLadder,
				LadderVolume -> resolvedLadderVolume,
				LadderLoadingBuffer -> resolvedLadderLoadingBuffer,
				LadderLoadingBufferVolume -> resolvedLadderLoadingBufferVolume,
				LadderRunningBuffer -> resolvedLadderRunningBuffer,
				LadderMarker -> resolvedLadderMarker,
				SampleDilution -> resolvedSampleDilution,
				SampleDiluent -> resolvedSampleDiluent,
				SampleVolume -> resolvedSampleVolume,
				SampleDiluentVolume -> resolvedSampleDiluentVolume,
				SampleLoadingBuffer -> resolvedSampleLoadingBuffer,
				SampleLoadingBufferVolume -> resolvedSampleLoadingBufferVolume,
				SampleRunningBuffer -> resolvedSampleRunningBuffer,
				SampleMarker -> resolvedSampleMarker,
				Blank -> resolvedBlank,
				BlankRunningBuffer -> resolvedBlankRunningBuffer,
				BlankMarker -> resolvedBlankMarker,
				MarkerPlateStorageCondition -> resolvedMarkerPlateStorageCondition,
				NumberOfCapillaries -> resolvedNumberOfCapillaries,
				CapillaryArray -> resolvedCapillaryArray,
				Instrument -> resolvedInstrument
			}
		],
		Append -> False
	];
	
	allTests = Cases[
		Flatten[{
			discardedTests,
			tooManySamplesTests,
			capillaryFlushNumberOfCapillaryFlushesMismatchTests,
			primaryCapillaryFlushMismatchTests,
			secondaryCapillaryFlushMismatchTests,
			tertiaryCapillaryFlushMismatchTests,
			capillaryEquilibrationMismatchTests,
			preMarkerRinseMismatchTests,
			markerInjectionMismatchTests,
			markerInjectionPreparedPlateMismatchTest,
			ladderPreparedPlateMismatchTests,
			preSampleRinseMismatchTests,
			sampleOptionsPreparedPlateMismatchTests,
			blankRunningBufferMismatchTests,
			blankMarkerMismatchTests,
			sampleDilutionMismatchTests,
			sampleLoadingBufferVolumeMismatchTests,
			blankPreparedPlateMismatchTests,
			tooManySolutionsForInjectionTests,
			notEnoughSolutionsForInjectionTests,
			preparedPlateAliquotMismatchTests,
			assayVolumeSampleVolumeMismatchTests,
			plateModelTests,
			preparedRunningBufferPlateModelTests,
			preparedMarkerPlateModelTests,
			duplicateWellsTests
		}],
		TestP
	];
	
	(* Return our resolved options and/or tests. *)
	outputSpecification /. {
		Result -> resolvedOptions,
		Tests -> allTests
	}
];


(* ::Subsection:: *)
(*fragmentAnalysisResourcePackets*)

DefineOptions[fragmentAnalysisResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];

fragmentAnalysisResourcePackets[mySamples : {ObjectP[Object[Sample]]..}, myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule}, myCollapsedResolvedOptions : {___Rule}, myOptions : OptionsPattern[]]:=Module[
	{	(*built in*)
		safeOps,
		outputSpecification,
		output,
		expandedInputs,
		expandedResolvedOptions,
		resolvedOptionsNoHidden,
		gatherTests,
		messages,
		cache,
		simulation,
		fastAssoc,
		simulatedSamples,
		sampleInformation,
		ladderLoading,
		updatedSimulation,
		simulatedSampleContainers,
		protocolPacket,
		sharedFieldPacket,
		finalizedPacket,
		allResourceBlobs,
		fulfillable,
		frqTests,
		previewRule,
		optionsRule,
		testsRule,
		resultRule,
		samplesWithReplicates,
		optionsWithReplicates,
		(*resolved Options*)
		resolvedAnalysisMethodName,
		resolvedMaxNumberOfRetries,
		resolvedPreparedPlate,
		resolvedCapillaryFlush,
		resolvedNumberOfCapillaryFlushes,
		resolvedPrimaryCapillaryFlushSolution,
		resolvedPrimaryCapillaryFlushPressure,
		resolvedPrimaryCapillaryFlushFlowRate,
		resolvedPrimaryCapillaryFlushTime,
		resolvedSecondaryCapillaryFlushSolution,
		resolvedSecondaryCapillaryFlushPressure,
		resolvedSecondaryCapillaryFlushFlowRate,
		resolvedSecondaryCapillaryFlushTime,
		resolvedTertiaryCapillaryFlushSolution,
		resolvedTertiaryCapillaryFlushPressure,
		resolvedTertiaryCapillaryFlushFlowRate,
		resolvedTertiaryCapillaryFlushTime,
		resolvedAnalysisStrategy,
		resolvedCapillaryArrayLength,
		resolvedSampleAnalyteType,
		resolvedMinReadLength,
		resolvedMaxReadLength,
		resolvedAnalysisMethod,
		resolvedCapillaryEquilibration,
		resolvedEquilibrationVoltage,
		resolvedEquilibrationTime,
		resolvedPreMarkerRinse,
		resolvedNumberOfPreMarkerRinses,
		resolvedMarkerInjection,
		resolvedMarkerInjectionTime,
		resolvedMarkerInjectionVoltage,
		resolvedPreSampleRinse,
		resolvedNumberOfPreSampleRinses,
		resolvedSampleInjectionTime,
		resolvedSampleInjectionVoltage,
		resolvedSeparationTime,
		resolvedSeparationVoltage,
		resolvedBlank,
		resolvedSeparationGel,
		resolvedDye,
		resolvedConditioningSolution,
		resolvedPreMarkerRinseBuffer,
		resolvedPreSampleRinseBuffer,
		resolvedBlankRunningBuffer,
		resolvedBlankMarker,
		resolvedLadder,
		resolvedLadderVolume,
		resolvedLadderLoadingBuffer,
		resolvedLadderLoadingBufferVolume,
		resolvedLadderRunningBuffer,
		resolvedLadderMarker,
		resolvedSampleVolume,
		resolvedSampleDilution,
		resolvedSampleDiluent,
		resolvedSampleDiluentVolume,
		resolvedSampleLoadingBuffer,
		resolvedSampleLoadingBufferVolume,
		resolvedSampleRunningBuffer,
		resolvedSampleMarker,
		resolvedRunningBufferPlateStorageCondition,
		resolvedPreMarkerRinseBufferPlateStorageCondition,
		resolvedMarkerPlateStorageCondition,
		resolvedPreSampleRinseBufferPlateStorageCondition,
		resolvedNumberOfCapillaries,
		resolvedCapillaryArray,
		resolvedInstrument,
		resolvedAliquotAmount,
		resolvedAliquotContainer,
		resolvedPreparedRunningBufferPlate,
		resolvedPreparedMarkerPlate,
		(*Resources*)
		instrumentSetupAndTeardownTimeUsed,
		instrumentSeparationTimeUsed,
		instrumentCapillaryFlushTimeUsed,
		instrumentRetryTimeUsed,
		totalInstrumentTimeUsed,
		instrumentResource,
		primaryCapillaryFlushSolutionResource,
		secondaryCapillaryFlushSolutionResource,
		tertiaryCapillaryFlushSolutionResource,
		primaryCapillaryFlushSolutionContainerRackResource,
		secondaryCapillaryFlushSolutionContainerRackResource,
		tertiaryCapillaryFlushSolutionContainerRackResource,
		blankResource,
		separationGelResource,
		gelDyeContainerRackResource,
		dyeResource,
		conditioningSolutionResource,
		conditioningSolutionContainerRackResource,
		preMarkerRinseBufferResource,
		preSampleRinseBufferResource,
		blankRunningBufferResource,
		blankMarkerResource,
		ladderResource,
		finalLadderVolumes,
		ladderLoadingBufferResource,
		finalLadderLoadingBufferVolumes,
		ladderRunningBufferResource,
		ladderMarkerResource,
		mineralOilResource,
		sampleDiluentResource,
		sampleLoadingBufferResource,
		sampleRunningBufferResource,
		sampleMarkerResource,
		conditioningLinePlaceholderRackResource,
		primaryGelLinePlaceholderRackResource,
		secondaryGelLinePlaceholderRackResource,
		preMarkerRinseBufferPlateResource,
		preSampleRinseBufferPlateResource,
		preMarkerRinseBufferPlateCoverResource,
		preSampleRinseBufferPlateCoverResource,
		runningBufferPlateResource,
		runningBufferPlateCoverResource,
		markerPlateResource,
		markerPlateCoverResource,
		samplePlateResource,
		samplePlateCoverResource,
		(*protocol packet*)
		fragmentAnalysisID,
		(*Others*)
		conditioningSolutionAmount,
		primaryCapillaryFlushSolutionAmount,
		secondaryCapillaryFlushSolutionAmount,
		tertiaryCapillaryFlushSolutionAmount,
		isolatedConditioningSolutionContainer,
		isolatedPrimaryCapillaryFlushSolutionContainer,
		isolatedSecondaryCapillaryFlushSolutionContainer,
		isolatedTertiaryCapillaryFlushSolutionContainer,
		sampleLoadingBufferToVolumeRules,
		mergedSampleLoadingBufferToVolumeRules,
		sampleLoadingBufferResources,
		sampleLoadingBufferResourceRules,
		blankToVolumeRules,
		mergedBlankToVolumeRules,
		blankResources,
		blankResourceRules,
		resolvedSampleRunningBufferObjects,
		resolvedLadderRunningBufferObjects,
		resolvedBlankRunningBufferObjects,
		resolvedSampleMarkerObjects,
		resolvedLadderMarkerObjects,
		resolvedBlankMarkerObjects,
		sampleRunningBufferToVolumeRules,
		ladderToVolumeRules,
		mergedLadderToVolumeRules,
		mergedMarkerToVolumeRules,
		ladderResources,
		ladderResourceRules,
		ladderLoadingBufferToVolumeRules,
		mergedLadderLoadingBufferToVolumeRules,
		ladderLoadingBufferResources,
		ladderLoadingBufferResourceRules,
		ladderRunningBufferToVolumeRules,
		blankRunningBufferToVolumeRules,
		mergedRunningBufferToVolumeRules,
		runningBufferResourceRules,
		markerResourceRules,
		runningBufferResources,
		markerResources,
		sampleMarkerToVolumeRules,
		mergedSampleMarkerToVolumeRules,
		sampleMarkerResources,
		sampleMarkerResourceRules,
		ladderMarkerToVolumeRules,
		mergedLadderMarkerToVolumeRules,
		ladderMarkerResources,
		ladderMarkerResourceRules,
		blankMarkerToVolumeRules,
		mergedBlankMarkerToVolumeRules,
		blankMarkerResources,
		blankMarkerResourceRules,
		sampleDiluentToVolumeRules,
		mergedSampleDiluentToVolumeRules,
		sampleDiluentResources,
		sampleDiluentResourceRules,
		containersIn,
		preparedPlateContainer,
		containersInContents,
		wellToContentRules,
		numberOfBlanks,
		numberOfSamples,
		numberOfLadders,
		expandedResolvedBlank,
		expandedResolvedBlankRunningBuffer,
		expandedResolvedBlankMarker,
		sampleWells,
		ladderWells,
		blankWells,
		targetBlankVolume,
		mySamplesToVolumeRules,
		mergedSamplesToVolumeRules,
		mySamplesResources,
		mySamplesResourceRules,
		simulatedSampleContainerWells,
		simulatedSampleVolumes,
		simulatedSamplePositions,
		wastePlateResource,
		samplesInResource
	},

	(* get the safe options for this function *)
	safeOps = SafeOptions[fragmentAnalysisResourcePackets, ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Expand the resolved options *)
	{expandedInputs,expandedResolvedOptions}=ExpandIndexMatchedInputs[ExperimentFragmentAnalysis,{mySamples},myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentFragmentAnalysis,
		RemoveHiddenOptions[ExperimentFragmentAnalysis,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* decide if we are gathering tests or throwing messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Get the inherited cache and simulation *)
	cache = Lookup[ToList[myOptions],Cache];
	simulation = Lookup[ToList[myOptions],Simulation];

	(* make the fast association *)
	fastAssoc = makeFastAssocFromCache[cache];
	
	(* -- Expand inputs and index-matched options to take into account the NumberOfReplicates option -- *)
	(* - Expand the index-matched inputs for the NumberOfReplicates - *)
	{samplesWithReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentFragmentAnalysis,mySamples,expandedResolvedOptions];
	
	(* simulate the sample preparation stuff so we have the right containers if we are aliquoting*)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentFragmentAnalysis, samplesWithReplicates, optionsWithReplicates, Cache -> cache, Simulation -> simulation];

	(*Lookup Option Values*)
	{
		resolvedAnalysisMethodName,
		resolvedMaxNumberOfRetries,
		resolvedPreparedPlate,
		resolvedCapillaryFlush,
		resolvedNumberOfCapillaryFlushes,
		resolvedPrimaryCapillaryFlushSolution,
		resolvedPrimaryCapillaryFlushPressure,
		resolvedPrimaryCapillaryFlushFlowRate,
		resolvedPrimaryCapillaryFlushTime,
		resolvedSecondaryCapillaryFlushSolution,
		resolvedSecondaryCapillaryFlushPressure,
		resolvedSecondaryCapillaryFlushFlowRate,
		resolvedSecondaryCapillaryFlushTime,
		resolvedTertiaryCapillaryFlushSolution,
		resolvedTertiaryCapillaryFlushPressure,
		resolvedTertiaryCapillaryFlushFlowRate,
		resolvedTertiaryCapillaryFlushTime,
		resolvedAnalysisStrategy,
		resolvedCapillaryArrayLength,
		resolvedSampleAnalyteType,
		resolvedMinReadLength,
		resolvedMaxReadLength,
		resolvedAnalysisMethod,
		resolvedCapillaryEquilibration,
		resolvedEquilibrationVoltage,
		resolvedEquilibrationTime,
		resolvedPreMarkerRinse,
		resolvedNumberOfPreMarkerRinses,
		resolvedMarkerInjection,
		resolvedMarkerInjectionTime,
		resolvedMarkerInjectionVoltage,
		resolvedPreSampleRinse,
		resolvedNumberOfPreSampleRinses,
		resolvedSampleInjectionTime,
		resolvedSampleInjectionVoltage,
		resolvedSeparationTime,
		resolvedSeparationVoltage,
		resolvedBlank,
		resolvedSeparationGel,
		resolvedDye,
		resolvedConditioningSolution,
		resolvedPreMarkerRinseBuffer,
		resolvedPreSampleRinseBuffer,
		resolvedBlankRunningBuffer,
		resolvedBlankMarker,
		resolvedLadder,
		resolvedLadderVolume,
		resolvedLadderLoadingBuffer,
		resolvedLadderLoadingBufferVolume,
		resolvedLadderRunningBuffer,
		resolvedLadderMarker,
		resolvedSampleVolume,
		resolvedSampleDilution,
		resolvedSampleDiluent,
		resolvedSampleDiluentVolume,
		resolvedSampleLoadingBuffer,
		resolvedSampleLoadingBufferVolume,
		resolvedSampleRunningBuffer,
		resolvedSampleMarker,
		resolvedRunningBufferPlateStorageCondition,
		resolvedPreMarkerRinseBufferPlateStorageCondition,
		resolvedMarkerPlateStorageCondition,
		resolvedPreSampleRinseBufferPlateStorageCondition,
		resolvedNumberOfCapillaries,
		resolvedCapillaryArray,
		resolvedInstrument,
		resolvedAliquotAmount,
		resolvedAliquotContainer,
		resolvedPreparedRunningBufferPlate,
		resolvedPreparedMarkerPlate
	}=Lookup[optionsWithReplicates,
		{
			AnalysisMethodName,
			MaxNumberOfRetries,
			PreparedPlate,
			CapillaryFlush,
			NumberOfCapillaryFlushes,
			PrimaryCapillaryFlushSolution,
			PrimaryCapillaryFlushPressure,
			PrimaryCapillaryFlushFlowRate,
			PrimaryCapillaryFlushTime,
			SecondaryCapillaryFlushSolution,
			SecondaryCapillaryFlushPressure,
			SecondaryCapillaryFlushFlowRate,
			SecondaryCapillaryFlushTime,
			TertiaryCapillaryFlushSolution,
			TertiaryCapillaryFlushPressure,
			TertiaryCapillaryFlushFlowRate,
			TertiaryCapillaryFlushTime,
			AnalysisStrategy,
			CapillaryArrayLength,
			SampleAnalyteType,
			MinReadLength,
			MaxReadLength,
			AnalysisMethod,
			CapillaryEquilibration,
			EquilibrationVoltage,
			EquilibrationTime,
			PreMarkerRinse,
			NumberOfPreMarkerRinses,
			MarkerInjection,
			MarkerInjectionTime,
			MarkerInjectionVoltage,
			PreSampleRinse,
			NumberOfPreSampleRinses,
			SampleInjectionTime,
			SampleInjectionVoltage,
			SeparationTime,
			SeparationVoltage,
			Blank,
			SeparationGel,
			Dye,
			ConditioningSolution,
			PreMarkerRinseBuffer,
			PreSampleRinseBuffer,
			BlankRunningBuffer,
			BlankMarker,
			Ladder,
			LadderVolume,
			LadderLoadingBuffer,
			LadderLoadingBufferVolume,
			LadderRunningBuffer,
			LadderMarker,
			SampleVolume,
			SampleDilution,
			SampleDiluent,
			SampleDiluentVolume,
			SampleLoadingBuffer,
			SampleLoadingBufferVolume,
			SampleRunningBuffer,
			SampleMarker,
			RunningBufferPlateStorageCondition,
			PreMarkerRinseBufferPlateStorageCondition,
			MarkerPlateStorageCondition,
			PreSampleRinseBufferPlateStorageCondition,
			NumberOfCapillaries,
			CapillaryArray,
			Instrument,
			AliquotAmount,
			AliquotContainer,
			PreparedRunningBufferPlate,
			PreparedMarkerPlate
		}
	];
	
	(* additional Download - get simulated sample information and LadderLoading specified in method object *)
	{
		sampleInformation,
		{
			{ladderLoading}
		}
	}=Download[
		{
			simulatedSamples,
			{resolvedAnalysisMethod}
		},
		{
			{
				Container[Object],
				Well,
				Volume,
				Position
			},
			{
				LadderLoading
			}
			
		},
		Cache -> cache,
		Simulation -> updatedSimulation
	];
	
	{
		simulatedSampleContainers,
		simulatedSampleContainerWells,
		simulatedSampleVolumes,
		simulatedSamplePositions
	}=Transpose[sampleInformation];

	(* pull out the container the sample is in*)
	containersIn = Download[Map[
		fastAssocLookup[fastAssoc, #, Container]&,
		samplesWithReplicates
	], Object];

	(*If resolvedPreparedPlate is True, identify all contents in the plate*)
	(*All samples should be in the same Container if resolvedPreparedPlate is True and DeleteDuplicates should end up with a single Container*)
	preparedPlateContainer=DeleteDuplicates[containersIn][[1]];

	(*This gives a list of contents {{well,Link[Object[Sample]]},...}*)
	containersInContents = If[MatchQ[resolvedPreparedPlate,True],
		fastAssocLookup[fastAssoc, preparedPlateContainer, Contents],
		{}
	];

	(*This gives a list of well to sample assignments {well->Link[Object[Sample]],...}*)
	wellToContentRules = If[MatchQ[resolvedPreparedPlate,True],
		Map[
			#[[1]]->#[[2]]&,
			containersInContents
		],
		{}
	];

	numberOfSamples=Length[simulatedSamples];

	(*This ensures that numberOfLadders is always an Integer*)
	(*In the case of PreparedPlate is True, it counts the WellPositions specified*)
	(*In the case of PreparedPlate is False, it counts the solutions (Model[Sample]/Object[Sample]) specified*)
	numberOfLadders=Length[Cases[ToList[resolvedLadder],Except[Null]]];

	numberOfBlanks=If[MatchQ[resolvedBlank,Null],
		0,
		96 - numberOfSamples - numberOfLadders
	];

	(* resolvedBlank and other related options can require expansion if resolvedValue is a singleton but numberOfBlanks is not 0*)
	expandedResolvedBlank = If[MatchQ[resolvedBlank,ObjectP[]],
		(* list of objects/models *)
		ConstantArray[resolvedBlank,numberOfBlanks],
		(* list of objects/models OR list of wells OR {}*)
		DeleteCases[ToList[resolvedBlank],Null]
	];

	ladderWells=Which[
		(*If suppliedLadder is a list of WellPositions, we count these - this is only valid if PreparedPlate is True*)
		MatchQ[resolvedLadder,WellPositionP|{WellPositionP..}],
		ToList[resolvedLadder],

		(*If PreparedPlate is True and no WellPositions are supplied in the Ladder field, then there are no Ladders*)
		MatchQ[resolvedPreparedPlate,True],
		Null,

		(*If PreparedPlate is False and numberOfLadders is greater than 0, it will be the last X wells of the 96-well plate*)
		MatchQ[numberOfLadders,GreaterP[0]],
		Take[Flatten[AllWells[]],-numberOfLadders],

		True,
		{}
	];

	blankWells=Which[
		(*If suppliedBlank is a list of WellPositions, we count these - this is only valid if PreparedPlate is True*)
		MatchQ[expandedResolvedBlank,{WellPositionP..}],
		expandedResolvedBlank,

		(*If PreparedPlate is False, blankWells are dependent on the positions of samples and ladders*)
		(*If the numberOfSamples and numberOfLadders is greater than 0, then the Blanks are assigned between samples and ladders*)
		MatchQ[numberOfBlanks,GreaterP[0]]&&MatchQ[numberOfLadders,GreaterP[0]],
		Drop[Drop[Flatten[AllWells[]],-numberOfLadders],numberOfSamples],

		(*If there are blanks required but no ladders, blanks are wells not assigned to samples*)
		MatchQ[numberOfBlanks,GreaterP[0]],
		Drop[Flatten[AllWells[]],numberOfSamples],

		True,
		{}
	];

	sampleWells=If[MatchQ[resolvedPreparedPlate,True],
		Select[Flatten[AllWells[]], ! MemberQ[Flatten[{ladderWells,blankWells}], #] &],
		Drop[Drop[Flatten[AllWells[]],-numberOfLadders],-numberOfBlanks]
	];

	(*Resources*)
	(*ConditioningSolution and CapillaryFlushSolution Resources*)
	(*get the amounts required for each solution*)
	conditioningSolutionAmount = 50 Milliliter;

	(*For the CapillaryFlushSolution, if FlowRate or FlushTime is Null, set Amount to Null. Otherwise, set to 50 Milliliter - the range of values required to run a single flush is always between 31 mL to 37 mL, 50 mL when we add line priming, but there is no way to estimate based on options available according to Agilent so were setting it to the max required to ensure we always provide enough volume*)
	primaryCapillaryFlushSolutionAmount = If[NullQ[resolvedPrimaryCapillaryFlushFlowRate]||NullQ[resolvedPrimaryCapillaryFlushTime],
		Null,
		50 Milliliter
	];
	secondaryCapillaryFlushSolutionAmount = If[NullQ[resolvedSecondaryCapillaryFlushFlowRate]||NullQ[resolvedSecondaryCapillaryFlushTime],
		Null,
		50 Milliliter
	];
	tertiaryCapillaryFlushSolutionAmount = If[NullQ[resolvedTertiaryCapillaryFlushFlowRate]||NullQ[resolvedTertiaryCapillaryFlushTime],
		Null,
		50 Milliliter
	];

	(*FlushSolution Containers*)
	(*Identify containers to be used for each solution if none will be combined*)
	{isolatedConditioningSolutionContainer,isolatedPrimaryCapillaryFlushSolutionContainer,isolatedSecondaryCapillaryFlushSolutionContainer}=Map[
		Which[
			(*If there is no indicated solution, set to Null*)
			MatchQ[#,Null],
			Null,

			(*Always  uses the 250mL Centrifuge tube that specifically fits with the specialized tube caps attached to the lines*)
			True,
			Model[Container, Vessel, "id:dORYzZRqJrzR"] (*Model[Container, Vessel, "250mL Centrifuge Tube For ExperimentFragmentAnalysis"]*)
		]&,
		{conditioningSolutionAmount,primaryCapillaryFlushSolutionAmount,secondaryCapillaryFlushSolutionAmount}
	];

	(*If there is no indicated solution, set to Null. Otherwise, set to the 50 mL tube. We're using the 50mL since this is what fits the last slot in the side compartment of the  FA Instrument and the solution needed never goes above 37 mL for a single use*)
	isolatedTertiaryCapillaryFlushSolutionContainer=If[MatchQ[tertiaryCapillaryFlushSolutionAmount,Null],
		Null,
		Model[Container, Vessel, "id:bq9LA0dBGGR6"](*Model[Container, Vessel, "50mL Tube"]*)
	];

	(*ConditioningSolution Resource*)
	conditioningSolutionResource = Resource[
		Sample->resolvedConditioningSolution,
		Amount->50 Milliliter, (* 40 mL required for the separation to run, 10 mL min volume for the container for the liquid to be picked-up properly *)
		Container->isolatedConditioningSolutionContainer
	];
	
	conditioningSolutionContainerRackResource = Resource[
		Sample->Model[Container, Rack, "id:01G6nvwXDYBr"],(*250/500 mL CrossFlowContainer Rack*)
		Rent->True
	];

	(*PrimaryCapillaryFlushSolution Resource*)
	primaryCapillaryFlushSolutionResource = If[MatchQ[resolvedCapillaryFlush,True],
		Resource[
			Sample->resolvedPrimaryCapillaryFlushSolution,
			Amount->primaryCapillaryFlushSolutionAmount,
			Container->isolatedPrimaryCapillaryFlushSolutionContainer
		],
		Null
	];
	
	primaryCapillaryFlushSolutionContainerRackResource=If[MatchQ[resolvedCapillaryFlush,True],
		Resource[
			Sample->Model[Container, Rack, "id:01G6nvwXDYBr"],(*250/500 mL CrossFlowContainer Rack*)
			Rent->True
		],
		Null
	];

	(*SecondaryCapillaryFlushSolution Resource*)
	secondaryCapillaryFlushSolutionResource = If[MatchQ[resolvedNumberOfCapillaryFlushes,GreaterP[1]],
		Resource[
		Sample->resolvedSecondaryCapillaryFlushSolution,
		Amount->secondaryCapillaryFlushSolutionAmount,
		Container->isolatedSecondaryCapillaryFlushSolutionContainer
		],
		Null
	];
	
	secondaryCapillaryFlushSolutionContainerRackResource = If[MatchQ[resolvedNumberOfCapillaryFlushes,GreaterP[1]],
		Resource[
			Sample->Model[Container, Rack, "id:01G6nvwXDYBr"],(*250/500 mL CrossFlowContainer Rack*)
			Rent->True
		],
		Null
	];

	(*TertiaryCapillaryFlushSolution Resource*)
	tertiaryCapillaryFlushSolutionResource = If[MatchQ[resolvedNumberOfCapillaryFlushes,3],
		Resource[
		Sample->resolvedTertiaryCapillaryFlushSolution,
		Amount->tertiaryCapillaryFlushSolutionAmount,
		Container->isolatedTertiaryCapillaryFlushSolutionContainer
		],
		Null
	];
	
	tertiaryCapillaryFlushSolutionContainerRackResource = If[MatchQ[resolvedNumberOfCapillaryFlushes,3],
		Resource[
			Sample->Model[Container, Rack, "id:01G6nvwXDYBr"],(*250/500 mL CrossFlowContainer Rack*)
			Rent->True
		],
		Null
	];

	(*SeparationGel Resource*)
	separationGelResource = Resource[
			Sample->resolvedSeparationGel,
			Amount->50 Milliliter, (* 40 mL required for the separation to run, 10 mL min volume for the container for the liquid to be picked-up properly *)
			Container->Model[Container, Vessel, "id:dORYzZRqJrzR"](*Model[Container, Vessel, "250mL Centrifuge Tube For ExperimentFragmentAnalysis"]*)
	];
	
	gelDyeContainerRackResource = Resource[
		Sample->Model[Container, Rack, "id:01G6nvwXDYBr"],(*250/500 mL CrossFlowContainer Rack*)
		Rent->True
	];

	(*Dye Resource*)
	(*We prefer to not aliquot the dye unless necessary since the total volume of each product is low*)
	dyeResource=If[MatchQ[resolvedDye,ObjectP[Model[Sample,"Milli-Q water"]]],
		Resource[
			Sample->resolvedDye,
			Amount->5 Microliter,
			Container->PreferredContainer[5 Microliter]
		],
		Resource[
			Sample->resolvedDye,
			Amount->5 Microliter
		]
	];

	(*Rack Resources*)
	(*The containers that go in the side compartment of the instrument are all non-self-standing. In order to do efficient switching of the containers of required solutions and the placeholders, rack resources are called for the placeholder containers.*)

	(*ConditioningLinePlaceholderRack is always required since the slot it occupies is used for the ConditioningSolutionContainer and is always required by the protocol.*)
	conditioningLinePlaceholderRackResource = Resource[
		Sample->Model[Container, Rack, "id:01G6nvwXDYBr"],(*250/500 mL CrossFlowContainer Rack*)
		Rent->True
	];

	(*PrimaryGelLinePlaceholderRack is always required since the slot it occupies is used for the GelDyeContainer and is always required by the protocol.*)
	primaryGelLinePlaceholderRackResource = Resource[
		Sample->Model[Container, Rack, "id:01G6nvwXDYBr"],(*250/500 mL CrossFlowContainer Rack*)
		Rent->True
	];

	(*SecondaryGelLinePlaceholderRack is optional and depends on whether a TertiaryCapillaryFlushSolution resource is needed.*)
	secondaryGelLinePlaceholderRackResource = If[MatchQ[tertiaryCapillaryFlushSolutionResource,Except[Null]],
		Resource[
			Sample->Model[Container, Rack, "id:GmzlKjY5EEdE"],(*50mL Tube Stand*)
			Rent->True
		],
		Null
	];

	(*Sample Plate Resource*)
	samplePlateResource=If[MatchQ[resolvedPreparedPlate,True],
		Link[First[DeleteDuplicates[containersIn]]],
		Link[Resource[Sample->Model[Container, Plate, "id:vXl9j5lLdjW5"]]] (*Model[Container,Plate,"96-well Semi-Skirted PCR Plate for FragmentAnalysis"] is required since the measurements are specifically compatible with the capillary array*)
	];

	samplePlateCoverResource=If[MatchQ[resolvedPreparedPlate,True],
		Null,
		Resource[Sample->Model[Item, PlateSeal, "MicroAmp PCR Plate Seal, Clear"]]
	];

	(*Samples Resource*)
	(*Set-up Rules for Solution->required Volume while also removing Nulls - the volume either represents the AliquotAmount needed to make the Aliquot OR the sample volume to be placed in the SamplePlate*)
	mySamplesToVolumeRules = If[MatchQ[resolvedPreparedPlate,True],
		{},
		MapThread[
			Which[

				(*If resolvedAliquotAmount is Null and resolvedSampleVolume is a quantity, no aliquoting is performed and sample is in LH-compatible container, thus volume required is resolvedSampleVolume*1.1 - extra buffer amount to ensure good transfer*)
				MatchQ[#3,Null]&&QuantityQ[#2],
				#1->#2,

				(*If resolvedAliquotAmount is a quantity, volume must be the resolvedAliquotAmount - no buffer is needed as this is already accounted for in RequiredAliquotAmounts of resolvedAliquotOptions function*)
				QuantityQ[#3],
				#1->#3,

				(*If something goes wrong, it will default to asking for 2.2 Microliter of the sample since this is the most likely SampleVolume+extra required to be transferred to the plate*)
				True,
				#1->2 Microliter
			]&,
			{
				samplesWithReplicates,
				resolvedSampleVolume,
				resolvedAliquotAmount
			}
		]
	];

	(*merge Solutions that are identical (that's why conversion to Object ID is necessary here - Same Objects but identified as Link or Name will not be identified as identical) and Total the Amount to identify a single Resource for similar solutions*)
	mergedSamplesToVolumeRules = If[MatchQ[resolvedPreparedPlate,True],
		{},
		Merge[mySamplesToVolumeRules, Total]
	];

	(*Set-up Resources for the unique sample solutions*)
	mySamplesResources=If[MatchQ[resolvedPreparedPlate,True],
		{},
		KeyValueMap[
			Resource[Sample -> #1, Amount -> SafeRound[#2 * 1.1,10^-1 Microliter],Name->CreateUniqueLabel["simulatedSample"]]&,
			mergedSamplesToVolumeRules
		]
	];

	(*Set-up rules for ID of unique solution to corresponding Resource*)
	mySamplesResourceRules = If[MatchQ[resolvedPreparedPlate,True],
		{},
		AssociationThread[Keys[mergedSamplesToVolumeRules], mySamplesResources]
	];

	samplesInResource=If[MatchQ[resolvedPreparedPlate,True],
		Link[samplesWithReplicates,Protocols],
		samplesWithReplicates/.mySamplesResourceRules
	];


	(*SampleDiluentResource*)
	(*Set-up Rules for Solution->Amount while also removing Nulls*)
	sampleDiluentToVolumeRules = MapThread[
		#1 -> #2&,
		{
			DeleteCases[resolvedSampleDiluent,Null],
			DeleteCases[resolvedSampleDiluentVolume,Null]
		}
	];

	(*merge Solutions that are identical (that's why conversion to Object ID is necessary here - Same Objects but identified as Link or Name will not be identified as identical) and Total the Amount to identify a single Resource for similar solutions*)
	mergedSampleDiluentToVolumeRules = Merge[sampleDiluentToVolumeRules, Total];

	(*Set-up Resources for the unique solutions*)
	sampleDiluentResources=KeyValueMap[
		Resource[Sample -> #1, Amount -> SafeRound[#2 * 1.1,10^-1 Microliter],Container->PreferredContainer[SafeRound[#2*1.1,10^-1 Microliter],LiquidHandlerCompatible->True],Name->CreateUniqueLabel["sampleDiluent"]]&,
		mergedSampleDiluentToVolumeRules
	];

	(*Set-up rules for ID of unique solution to corresponding Resource*)
	sampleDiluentResourceRules = AssociationThread[Keys[mergedSampleDiluentToVolumeRules], sampleDiluentResources];

	sampleDiluentResource=resolvedSampleDiluent/.sampleDiluentResourceRules;

	(*SampleLoadingBuffer Resource*)
	(*Set-up Rules for Solution->Amount while also removing Nulls*)
	sampleLoadingBufferToVolumeRules = MapThread[
		#1 -> #2&,
		{
			DeleteCases[resolvedSampleLoadingBuffer,Null],
			DeleteCases[resolvedSampleLoadingBufferVolume,Null]
		}
	];

	(*merge Solutions that are identical (that's why conversion to Object ID is necessary here - Same Objects but identified as Link or Name will not be identified as identical) and Total the Amount to identify a single Resource for similar solutions*)
	mergedSampleLoadingBufferToVolumeRules = Merge[sampleLoadingBufferToVolumeRules, Total];

	(*Set-up Resources for the unique solutions*)
	sampleLoadingBufferResources=KeyValueMap[
		Resource[Sample -> #1, Amount -> SafeRound[#2 * 1.1,10^-1 Microliter],Container->PreferredContainer[SafeRound[#2*1.1,10^-1 Microliter],LiquidHandlerCompatible->True],Name->CreateUniqueLabel["sampleLoadingBuffer"]]&,
		mergedSampleLoadingBufferToVolumeRules
	];

	(*Set-up rules for ID of unique solution to corresponding Resource*)
	sampleLoadingBufferResourceRules = AssociationThread[Keys[mergedSampleLoadingBufferToVolumeRules], sampleLoadingBufferResources];

	sampleLoadingBufferResource=resolvedSampleLoadingBuffer/.sampleLoadingBufferResourceRules;
	
	(*Blank Resource*)
	(*The amount of blank per well is equal to the expected volume found in a sample well*)
	targetBlankVolume = Which[
		MatchQ[fastAssocLookup[fastAssoc,resolvedAnalysisMethod,TargetSampleVolume],_?QuantityQ]&&MatchQ[fastAssocLookup[fastAssoc,resolvedAnalysisMethod,SampleLoadingBufferVolume],_?QuantityQ],
		fastAssocLookup[fastAssoc,resolvedAnalysisMethod,TargetSampleVolume] + fastAssocLookup[fastAssoc,resolvedAnalysisMethod,SampleLoadingBufferVolume],
		
		MatchQ[fastAssocLookup[fastAssoc,resolvedAnalysisMethod,TargetSampleVolume],_?QuantityQ],
		fastAssocLookup[fastAssoc,resolvedAnalysisMethod,TargetSampleVolume],
		
		True,
		24 Microliter
	];
	
	(*Set-up Rules for Solution->Amount while also removing Nulls*)
	blankToVolumeRules = If[MatchQ[resolvedPreparedPlate,True],
		{},
		Map[
			# -> targetBlankVolume&,
			expandedResolvedBlank
		]
	];

	(*merge Solutions that are identical (that's why conversion to Object ID is necessary here - Same Objects but identified as Link or Name will not be identified as identical) and Total the Amount to identify a single Resource for similar solutions*)
	mergedBlankToVolumeRules = Merge[blankToVolumeRules, Total];

	blankResources=KeyValueMap[
		Resource[Sample -> #1, Amount -> SafeRound[#2 * 1.1,10^-1 Microliter],Container->PreferredContainer[SafeRound[#2*1.1,10^-1 Microliter],LiquidHandlerCompatible->True],Name->CreateUniqueLabel["blank"]]&,
		mergedBlankToVolumeRules
	];

	(*Set-up rules for ID of unique solution to corresponding Resource*)
	blankResourceRules = AssociationThread[Keys[mergedBlankToVolumeRules], blankResources];

	blankResource=If[MatchQ[resolvedPreparedPlate,True],
		Link[expandedResolvedBlank/.wellToContentRules],
		(expandedResolvedBlank/.blankResourceRules)
	];

	(*Ladder Resource*)
	(*Set-up Rules for Solution->Amount while also removing Nulls*)
	(* Wrap resolvedLadder and resolvedLadderVolume in lists since resolved values can be the singleton inputs *)
	ladderToVolumeRules = If[MatchQ[resolvedPreparedPlate,True],
		{},
		MapThread[
			#1 -> #2&,
			{
				DeleteCases[ToList[resolvedLadder],Null],
				DeleteCases[ToList[resolvedLadderVolume],Null]
			}
		]
	];

	(*merge Solutions that are identical (that's why conversion to Object ID is necessary here - Same Objects but identified as Link or Name will not be identified as identical) and Total the Amount to identify a single Resource for similar solutions*)
	mergedLadderToVolumeRules = Merge[ladderToVolumeRules, Total];
	
	ladderResources= KeyValueMap[
		Resource[
			Sample -> #1,
			Amount -> If[MatchQ[#2*1.1, GreaterP[800 Microliter]],
				SafeRound[#2*1.1 + 100 Microliter,1 Microliter],
				SafeRound[#2*1.1 + 5 Microliter,10^-1 Microliter]
			],
			Container -> If[MatchQ[#2*1.1, GreaterP[800 Microliter]],
				PreferredContainer[
					SafeRound[#2*1.1 + 100 Microliter,1 Microliter],
					LiquidHandlerCompatible -> If[MatchQ[ladderLoading,Robotic],
						True,
						False
					]
				],
				PreferredContainer[
					SafeRound[#2*1.1 + 5 Microliter,10^-1 Microliter],
					LiquidHandlerCompatible -> If[MatchQ[ladderLoading,Robotic],
						True,
						Automatic
					]
				]
			]
		]&,
		mergedLadderToVolumeRules
	];

	(*Set-up rules for ID of unique solution to corresponding Resource*)
	ladderResourceRules = AssociationThread[Keys[mergedLadderToVolumeRules], ladderResources];

	(* final field value is a list *)
	ladderResource=If[MatchQ[resolvedPreparedPlate,True],
		Link[DeleteCases[ToList[resolvedLadder],Null]/.wellToContentRules],
		DeleteCases[ToList[resolvedLadder],Null]/.ladderResourceRules
	];

	(* LadderVolume *)
	finalLadderVolumes = If[MatchQ[ladderResource,{}],
		{},
		ToList[resolvedLadderVolume]
	];

	(*LadderLoadingBuffer Resource*)
	(*Set-up Rules for Solution->Amount while also removing Nulls*)
	ladderLoadingBufferToVolumeRules = MapThread[
		#1 -> #2&,
		{
			DeleteCases[ToList[resolvedLadderLoadingBuffer],Null],
			DeleteCases[ToList[resolvedLadderLoadingBufferVolume],Null]
		}
	];

	(*merge Solutions that are identical (that's why conversion to Object ID is necessary here - Same Objects but identified as Link or Name will not be identified as identical) and Total the Amount to identify a single Resource for similar solutions*)
	mergedLadderLoadingBufferToVolumeRules = Merge[ladderLoadingBufferToVolumeRules, Total];

	(*Set-up Resources for the unique solutions*)
	ladderLoadingBufferResources=KeyValueMap[
		Resource[Sample -> #1, Amount -> SafeRound[#2 * 1.1,10^-1 Microliter],Container->PreferredContainer[SafeRound[#2 * 1.1,10^-1 Microliter],LiquidHandlerCompatible->True],Name->CreateUniqueLabel["ladderLoadingBuffer"]]&,
		mergedLadderLoadingBufferToVolumeRules
	];

	(*Set-up rules for ID of unique solution to corresponding Resource*)
	ladderLoadingBufferResourceRules = AssociationThread[Keys[mergedLadderLoadingBufferToVolumeRules], ladderLoadingBufferResources];

	(* final field value is a list *)
	ladderLoadingBufferResource=If[MatchQ[ladderResource,{}],
		{},
		ToList[resolvedLadderLoadingBuffer]/.ladderLoadingBufferResourceRules
	];

	(* LadderLoadingBufferVolume *)
	finalLadderLoadingBufferVolumes = Which[
		(* if ladderResource is {}, related options are also {} - this covers cases where these options can have a direct input/resolved value of Null but we cannot do a direct Null->{} replacement since there are cases of non-empty ladder but with actual Null value for options *)
		MatchQ[ladderResource,{}],
		{},

		(* If ladderResource is not {}, create an index-matched list for Null or ObjectP[] resolvedValue *)
		MatchQ[resolvedLadderLoadingBufferVolume,(Null|ObjectP[])],
		ConstantArray[resolvedLadderLoadingBufferVolume,Length[ladderResource]],

		True,
		resolvedLadderLoadingBufferVolume
	];

	(*RunningBuffer Resources*)
	(*Set-up Rules for Solution->Amount while also removing Nulls*)
	(*the resolvedRunningBuffer can potentially be links since they are fields of the analysis method (SampleRunningBuffer,LadderRunningBuffer, BlankRunningBuffer). In order to be able to successfully merge resource for similar models for these three, Links are removed.*)

	expandedResolvedBlankRunningBuffer = If[MatchQ[resolvedBlankRunningBuffer,ObjectP[]],
		(* list of objects/models *)
		ConstantArray[resolvedBlankRunningBuffer,numberOfBlanks],
		(* list of objects/models OR {} *)
		DeleteCases[ToList[resolvedBlankRunningBuffer],Null]
	];

	resolvedSampleRunningBufferObjects=Download[ToList[resolvedSampleRunningBuffer],Object];
	resolvedLadderRunningBufferObjects=Download[ToList[resolvedLadderRunningBuffer],Object];
	resolvedBlankRunningBufferObjects=Download[expandedResolvedBlankRunningBuffer,Object];
	
	sampleRunningBufferToVolumeRules = If[MatchQ[resolvedPreparedRunningBufferPlate,ObjectP[Object[Container,Plate]]],
		{},
		Map[
			#1 -> 1 Milliliter&,
			resolvedSampleRunningBufferObjects
		]
	];
	
	ladderRunningBufferToVolumeRules = If[MatchQ[resolvedPreparedRunningBufferPlate,ObjectP[Object[Container,Plate]]],
		{},
		Map[
			# -> 1 Milliliter&,
			DeleteCases[resolvedLadderRunningBufferObjects,Null]
		]
	];
	
	blankRunningBufferToVolumeRules = If[MatchQ[resolvedPreparedRunningBufferPlate,ObjectP[Object[Container,Plate]]],
		{},
		Map[
			# -> 1 Milliliter&,
			resolvedBlankRunningBufferObjects
		]
	];

	(*merge Solutions that are identical (that's why conversion to Object ID is necessary here - Same Objects but identified as Link or Name will not be identified as identical) and Total the Amount to identify a single Resource for similar solutions*)
	mergedRunningBufferToVolumeRules = Merge[Flatten[{sampleRunningBufferToVolumeRules,ladderRunningBufferToVolumeRules,blankRunningBufferToVolumeRules}], Total];

	(*Set-up Resources for the unique solutions*)
	runningBufferResources= KeyValueMap[
		If[MatchQ[SafeRound[#2 * 1.1,10^-1 Microliter],GreaterP[50 Milliliter]],
			Resource[
				Sample -> #1,
				Amount -> SafeRound[#2 + 25 Milliliter,10^-1 Microliter],
				Container->Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"],
				Name->CreateUniqueLabel["runningBuffer"]
			],
			Resource[
				Sample -> #1,
				Amount -> SafeRound[#2 * 1.1,10^-1 Microliter],
				Container->PreferredContainer[SafeRound[#2 * 1.1,10^-1 Microliter],LiquidHandlerCompatible->True],
				Name->CreateUniqueLabel["runningBuffer"]
			]
		]&,
		mergedRunningBufferToVolumeRules
	];

	(*Set-up rules for ID of unique solution to corresponding Resource*)
	runningBufferResourceRules = AssociationThread[Keys[mergedRunningBufferToVolumeRules], runningBufferResources];
	
	(*SampleRunningBuffer Resource*)
	sampleRunningBufferResource= Link[#]&/@(resolvedSampleRunningBufferObjects/.runningBufferResourceRules);

	(*BlankRunningBuffer Resource*)
	blankRunningBufferResource=If[MatchQ[blankResource, {}],
		{},
		Link[#]&/@resolvedBlankRunningBufferObjects/.runningBufferResourceRules
	];

	(*LadderRunningBuffer Resource*)
	(* if ladderResource is {}, related options are also {} - this covers cases where these options can have a direct input/resolved value of Null but we cannot do a direct Null->{} replacement since there are cases of non-empty ladder but with actual Null value for options *)
	ladderRunningBufferResource=If[MatchQ[ladderResource,{}],
		{},
		Link[#]&/@(resolvedLadderRunningBufferObjects/.runningBufferResourceRules)
	];

	(*RunningBufferPlate Resource*)
	(*RunningBufferPlate is required to be Model[Container,Plate,"96-well 1mL Deep Well Plate (Short) for FragmentAnalysis"] in order to be compatible with the instrument*)
	runningBufferPlateResource=If[MatchQ[resolvedPreparedRunningBufferPlate,ObjectP[Object[Container,Plate]]],
		Link[Resource[Sample->resolvedPreparedRunningBufferPlate]],
		Resource[Sample->Model[Container, Plate, "id:Vrbp1jb6R1dx"]]
	];

	(*RunningBufferPlateCover Resource*)
	runningBufferPlateCoverResource=If[MatchQ[resolvedPreparedRunningBufferPlate,ObjectP[Object[Container,Plate]]],
		Null,
		Resource[Sample->Model[Item, PlateSeal, "MicroAmp PCR Plate Seal, Clear"]]
	];

	(*Marker Resources*)
	(*Set-up Rules for Solution->Amount while also removing Nulls*)
	(*the resolvedMarker can potentially be links since they are fields of the analysis method (SampleMarker,LadderMarker, BlankMarker). In order to be able to successfully merge resource for similar models for these three, Links are removed.*)

	expandedResolvedBlankMarker = Which[
		(* if there are no blanks, there are also no blank markers - this indirectly converts the Null option value to an empty list *)
		MatchQ[blankResource,{}],
		{},

		(* if Blank and BlankMarker are already index-matched, keep as is *)
		MatchQ[Length[blankResource],Length[resolvedBlankMarker]],
		resolvedBlankMarker,

		(* if there are blanks, we need to expand the resolvedBlankMarker (which can be a Null) to the length of the blanks *)
		True,
		ConstantArray[resolvedBlankMarker,numberOfBlanks]
	];

	resolvedSampleMarkerObjects=Download[ToList[resolvedSampleMarker],Object];
	resolvedLadderMarkerObjects=Download[ToList[resolvedLadderMarker],Object];
	resolvedBlankMarkerObjects=Download[expandedResolvedBlankMarker,Object];

	sampleMarkerToVolumeRules = If[MatchQ[resolvedPreparedMarkerPlate,ObjectP[Object[Container,Plate]]],
		{},
		Map[
			# -> 30 Microliter&,
			DeleteCases[resolvedSampleMarkerObjects,Null]
		]
	];

	ladderMarkerToVolumeRules = If[MatchQ[resolvedPreparedMarkerPlate,ObjectP[Object[Container,Plate]]],
		{},
		Map[
			# -> 30 Microliter&,
			DeleteCases[resolvedLadderMarkerObjects,Null]
		]
	];

	blankMarkerToVolumeRules = If[MatchQ[resolvedPreparedMarkerPlate,ObjectP[Object[Container,Plate]]],
		{},
		Map[
			# -> 30 Microliter&,
			DeleteCases[resolvedBlankMarkerObjects,Null]
		]
	];

	(*merge Solutions that are identical (that's why conversion to Object ID is necessary here - Same Objects but identified as Link or Name will not be identified as identical) and Total the Amount to identify a single Resource for similar solutions*)
	mergedMarkerToVolumeRules = Merge[Flatten[{sampleMarkerToVolumeRules,ladderMarkerToVolumeRules,blankMarkerToVolumeRules}], Total];

	(*Set-up Resources for the unique solutions*)
	markerResources= KeyValueMap[
		Resource[
			Sample -> #1,
			Amount -> SafeRound[#2 * 1.1,10^-1 Microliter],
			Container->PreferredContainer[SafeRound[#2 * 1.1,10^-1 Microliter],LiquidHandlerCompatible->True],
			Name->CreateUniqueLabel["marker"]
		]&,
		mergedMarkerToVolumeRules
	];

	(*Set-up rules for ID of unique solution to corresponding Resource*)
	markerResourceRules = AssociationThread[Keys[mergedMarkerToVolumeRules], markerResources];

	(*SampleMarker Resource*)
	sampleMarkerResource= Link[#]&/@(resolvedSampleMarkerObjects/.markerResourceRules);
	
	(*BlankMarker Resource*)
	blankMarkerResource=If[MatchQ[blankResource, {}],
		{},
		(Link[#]&/@resolvedBlankMarkerObjects)/.markerResourceRules
	];

	(*LadderMarker Resource*)
	ladderMarkerResource=If[MatchQ[ladderResource, {}],
		{},
		Link[#]&/@(resolvedLadderMarkerObjects/.markerResourceRules)
	];
	
	(* MineralOil Resource *)
	(* MineralOil resource is only necessary if a new MarkerPlate needs to be prepared, such as in cases where PreparedMarkerPlate is not an object and MarkerInjection is True*)
	mineralOilResource=Which[
		MatchQ[resolvedPreparedMarkerPlate,ObjectP[Object[Container,Plate]]],
		Null,
		
		MatchQ[resolvedMarkerInjection,False],
		Null,
		
		True,
		Resource[
			Sample->Model[Sample, "id:XnlV5jlVzM0n"],
			Amount->10 Milliliter, (*20 Microliter per well of 96-well plate + buffer amount - need a huge excess to allow for proper dispensing*)
			Container->PreferredContainer[10 Milliliter,LiquidHandlerCompatible->True]
		]
	];
	
	(*MarkerPlate Resource*)
	markerPlateResource=Which[
		MatchQ[resolvedPreparedMarkerPlate,ObjectP[Object[Container,Plate]]],
		Link[resolvedPreparedMarkerPlate],

		MatchQ[resolvedSampleMarker,{Null..}],
		Null,

		True,
		Resource[Sample->Model[Container, Plate, "id:vXl9j5lLdjW5"]]
	];

	markerPlateCoverResource=If[MatchQ[resolvedPreparedMarkerPlate,ObjectP[Object[Container,Plate]]]||MatchQ[resolvedSampleMarker,{Null..}],
		Null,
		Resource[Sample->Model[Item, PlateSeal, "MicroAmp PCR Plate Seal, Clear"]]
	];


	(*PreMarkerRinseBuffer Resource*)
	(*200 Microliter per well for a 96 well plate with allowance*)
	preMarkerRinseBufferResource=Which[
		NullQ[resolvedPreMarkerRinseBuffer],
		Null,

		MatchQ[resolvedPreMarkerRinseBuffer,ObjectP[Model[Sample,"Milli-Q water"]]],
		Resource[
			Sample->resolvedPreMarkerRinseBuffer,
			Amount->21 Milliliter,
			Container->PreferredContainer[21 Milliliter,LiquidHandlerCompatible->True]
		],

		MatchQ[resolvedPreMarkerRinseBuffer,ObjectP[]],
		Resource[
			Sample->resolvedPreMarkerRinseBuffer,
			Amount->21 Milliliter,
			Container->PreferredContainer[21 Milliliter,LiquidHandlerCompatible->True]
		]
	];

	(*PreMarkerRinseBufferPlate Resource*)
	preMarkerRinseBufferPlateResource=If[MatchQ[resolvedPreMarkerRinseBuffer,ObjectP[]],
		Resource[Sample->Model[Container, Plate, "id:vXl9j5lLdjW5"]],
		Null
	];

	preMarkerRinseBufferPlateCoverResource=If[MatchQ[preMarkerRinseBufferPlateResource,Except[Null]],
		Resource[Sample->Model[Item, PlateSeal, "MicroAmp PCR Plate Seal, Clear"]],
		Null
	];

	(*PreSampleRinseBuffer Resource*)
	preSampleRinseBufferResource=Which[

		MatchQ[resolvedPreSampleRinseBuffer,ObjectP[]],
		Resource[
			Sample->resolvedPreSampleRinseBuffer,
			Amount->21 Milliliter,
			Container->PreferredContainer[21 Milliliter,LiquidHandlerCompatible->True]
		],

		True,
		Null

	];

	(*PreSampleRinseBufferPlate Resource*)
	preSampleRinseBufferPlateResource=If[MatchQ[resolvedPreSampleRinseBuffer,ObjectP[]],
		Resource[Sample->Model[Container, Plate, "id:vXl9j5lLdjW5"]],
		Null
	];

	preSampleRinseBufferPlateCoverResource=If[MatchQ[preSampleRinseBufferPlateResource,Except[Null]],
		Resource[Sample->Model[Item, PlateSeal, "MicroAmp PCR Plate Seal, Clear"]],
		Null
	];
	
	(*Model[Container, Plate, "96-well 1mL Deep Well Plate (Short) for FragmentAnalysis"] is required since the height is specifically compatible with the capillary array*)
	wastePlateResource=Resource[Sample->Model[Container, Plate, "id:Vrbp1jb6R1dx"]];

	(*Instrument Resource*)
	instrumentSetupAndTeardownTimeUsed = 90 Minute;
	instrumentSeparationTimeUsed = resolvedSeparationTime;
	instrumentCapillaryFlushTimeUsed = If[MatchQ[resolvedCapillaryFlush,True],
		30 Minute * resolvedNumberOfCapillaryFlushes,
		0 Minute
	];
	instrumentRetryTimeUsed = If[MatchQ[resolvedMaxNumberOfRetries,GreaterEqualP[1]],
		resolvedMaxNumberOfRetries * (instrumentSetupAndTeardownTimeUsed + instrumentSeparationTimeUsed),
		0 Minute
	];
	
	totalInstrumentTimeUsed = instrumentSetupAndTeardownTimeUsed + instrumentSeparationTimeUsed +instrumentCapillaryFlushTimeUsed + instrumentRetryTimeUsed;
	
	instrumentResource= Resource[
			Instrument->resolvedInstrument,
			Time-> totalInstrumentTimeUsed,
			Name->"FragmentAnalyzer"
	];
	

	(* create the FragmentAnalysis ID *)
	fragmentAnalysisID=CreateID[Object[Protocol,FragmentAnalysis]];

	(* Blank and Ladder related options become lists in the protocol object, resolvedBLAH values are turned into {} *)
	protocolPacket=<|
		Type->Object[Protocol,FragmentAnalysis],
		Object->fragmentAnalysisID,
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions->myResolvedOptions,
		(*SamplesIn*)
		Replace[SamplesIn]->samplesInResource,
		(*ContainersIn*)
		Replace[ContainersIn]->(Link[Resource[Sample -> #],Protocols]&)/@ToList[containersIn],
		Instrument->instrumentResource,
		CapillaryArray->Link[resolvedCapillaryArray],
		ConditioningSolution->conditioningSolutionResource,
		ConditioningSolutionContainerRack->Link[conditioningSolutionContainerRackResource],
		PrimaryCapillaryFlushSolution->primaryCapillaryFlushSolutionResource,
		SecondaryCapillaryFlushSolution->secondaryCapillaryFlushSolutionResource,
		TertiaryCapillaryFlushSolution->tertiaryCapillaryFlushSolutionResource,
		PrimaryCapillaryFlushSolutionContainerRack->Link[primaryCapillaryFlushSolutionContainerRackResource],
		SecondaryCapillaryFlushSolutionContainerRack->Link[secondaryCapillaryFlushSolutionContainerRackResource],
		TertiaryCapillaryFlushSolutionContainerRack->Link[tertiaryCapillaryFlushSolutionContainerRackResource],
		ConditioningLinePlaceholderRack->Link[conditioningLinePlaceholderRackResource],
		PrimaryGelLinePlaceholderRack->Link[primaryGelLinePlaceholderRackResource],
		SecondaryGelLinePlaceholderRack->Link[secondaryGelLinePlaceholderRackResource],
		SeparationGel->separationGelResource,
		GelDyeContainerRack->Link[gelDyeContainerRackResource],
		Dye->dyeResource,
		PreMarkerRinseBuffer->preMarkerRinseBufferResource,
		PreMarkerRinseBufferPlate->preMarkerRinseBufferPlateResource,
		PreMarkerRinseBufferPlateStorageCondition->resolvedPreMarkerRinseBufferPlateStorageCondition,
		PreMarkerRinseBufferPlateCover->preMarkerRinseBufferPlateCoverResource,
		PreSampleRinseBuffer->preSampleRinseBufferResource,
		PreSampleRinseBufferPlate->preSampleRinseBufferPlateResource,
		PreSampleRinseBufferPlateStorageCondition->resolvedPreSampleRinseBufferPlateStorageCondition,
		PreSampleRinseBufferPlateCover->preSampleRinseBufferPlateCoverResource,
		SamplePlate->samplePlateResource,
		SamplePlateStorageCondition->Refrigerator,
		SamplePlateCover->samplePlateCoverResource,
		RunningBufferPlate->runningBufferPlateResource,
		RunningBufferPlateStorageCondition->resolvedRunningBufferPlateStorageCondition,
		RunningBufferPlateCover->runningBufferPlateCoverResource,
		MarkerPlate->markerPlateResource,
		MarkerPlateStorageCondition->resolvedMarkerPlateStorageCondition,
		MarkerPlateCover->markerPlateCoverResource,
		WastePlate->Link[wastePlateResource],
		Replace[SampleDiluents]->sampleDiluentResource,
		Replace[SampleLoadingBuffers]->sampleLoadingBufferResource,
		Replace[SampleRunningBuffers]->sampleRunningBufferResource,
		Replace[Ladders]->ladderResource,
		Replace[LadderLoadingBuffers]->ladderLoadingBufferResource,
		Replace[LadderRunningBuffers]->ladderRunningBufferResource,
		Replace[SampleMarkers]->sampleMarkerResource,
		Replace[LadderMarkers]->ladderMarkerResource,
		Replace[MineralOil]->mineralOilResource,
		Replace[Blanks]->blankResource,
		Replace[BlankRunningBuffers]->blankRunningBufferResource,
		Replace[BlankMarkers]->blankMarkerResource,
		Replace[SampleWells]->sampleWells,
		Replace[LadderWells]->ladderWells,
		Replace[BlankWells]->blankWells,
		AnalysisMethod->Link[resolvedAnalysisMethod],
		AnalysisMethodName->resolvedAnalysisMethodName,
		AnalysisStrategy->resolvedAnalysisStrategy,
		CapillaryArrayLength->resolvedCapillaryArrayLength,
		CapillaryEquilibration->resolvedCapillaryEquilibration,
		EquilibrationVoltage->resolvedEquilibrationVoltage,
		EquilibrationTime->resolvedEquilibrationTime,
		CapillaryFlush->resolvedCapillaryFlush,
		Replace[LadderLoadingBufferVolumes]->finalLadderLoadingBufferVolumes,
		MarkerInjection->resolvedMarkerInjection,
		MarkerInjectionTime->resolvedMarkerInjectionTime,
		MarkerInjectionVoltage->resolvedMarkerInjectionVoltage,
		Replace[MaxReadLength]->resolvedMaxReadLength,
		Replace[MinReadLength]->resolvedMinReadLength,
		NumberOfCapillaries->resolvedNumberOfCapillaries,
		NumberOfCapillaryFlushes->resolvedNumberOfCapillaryFlushes,
		NumberOfPreMarkerRinses->resolvedNumberOfPreMarkerRinses,
		NumberOfPreSampleRinses->resolvedNumberOfPreSampleRinses,
		PreSampleRinse->resolvedPreSampleRinse,
		PreMarkerRinse->resolvedPreMarkerRinse,
		MaxNumberOfRetries->resolvedMaxNumberOfRetries,
		PreparedPlate->resolvedPreparedPlate,
		PrimaryCapillaryFlushFlowRate->resolvedPrimaryCapillaryFlushFlowRate,
		PrimaryCapillaryFlushPressure->resolvedPrimaryCapillaryFlushPressure,
		PrimaryCapillaryFlushTime->resolvedPrimaryCapillaryFlushTime,
		SecondaryCapillaryFlushFlowRate->resolvedSecondaryCapillaryFlushFlowRate,
		SecondaryCapillaryFlushPressure->resolvedSecondaryCapillaryFlushPressure,
		SecondaryCapillaryFlushTime->resolvedSecondaryCapillaryFlushTime,
		TertiaryCapillaryFlushFlowRate->resolvedTertiaryCapillaryFlushFlowRate,
		TertiaryCapillaryFlushPressure->resolvedTertiaryCapillaryFlushPressure,
		TertiaryCapillaryFlushTime->resolvedTertiaryCapillaryFlushTime,
		Replace[SampleAnalyteType]->resolvedSampleAnalyteType,
		Replace[SampleDiluentVolumes]->resolvedSampleDiluentVolume,
		Replace[SampleDilutions]->resolvedSampleDilution,
		SampleInjectionTime->resolvedSampleInjectionTime,
		SampleInjectionVoltage->resolvedSampleInjectionVoltage,
		Replace[SampleLoadingBufferVolumes]->resolvedSampleLoadingBufferVolume,
		Replace[SampleVolumes]->resolvedSampleVolume,
		Replace[LadderVolumes]->finalLadderVolumes,
		SeparationTime->resolvedSeparationTime,
		SeparationVoltage->resolvedSeparationVoltage,
		Replace[Checkpoints] -> {
			{"Picking Resources",30 Minute, "Samples and Containers required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
			{"Preparing Samples", 15 Minute, "Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 15 Minute]]},
			{"Preparing SeparationGel and Dye in GelDyeContainer", 15 Minute, "A mixture of SeparationGel and Dye are mixed and transferred in the GelDyeContainer.", Link[Resource[Operator -> $BaselineOperator, Time -> 15 Minute]]},
			{"Preparing Plates", 30 Minute, "RunningBufferPlate, MarkerPlate (if applicable), PreMarkerRinseBufferPlate (if applicable) and PreSampleRinseBufferPlate (if applicable) are prepared, if not already in PreparedPlate form.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
			{"Preparing SamplePlate", 15 Minute, "Samples, Ladders and Blanks, as well as SampleDiluents and LoadingBuffers  are loaded into the SamplePlate. SamplePlate is now ready to be placed in the Instrument.", Link[Resource[Operator -> $BaselineOperator, Time -> 15 Minute]]},
			{"Preparing Instrument",15 Minute,"Setting up the instrument and software in preparation for Capillary Flush (if applicable) and sample run.",Link[Resource[Operator->$BaselineOperator,Time->15 Minute]]},
			{"Capillary Flush",1 Hour,"The instrument's physical components and software are prepared for a capillary flush run and a flush is performed.",Link[Resource[Operator->$BaselineOperator,Time->20 Minute]]},
			{"Preparing Instrument for Sample Separation",20 Minute,"The instrument's physical components and software are prepared for a sample separation run.",Link[Resource[Operator->$BaselineOperator,Time->20 Minute]]},
			{"Sample Separation", (resolvedSeparationTime), "Separation Method is ran in the Instrument.", Link[Resource[Operator -> $BaselineOperator, Time -> (resolvedSeparationTime)]]},
			{"Data Processing", 15 Minute, "Raw Data is copied, processed and stored in the appropriate folders.", Link[Resource[Operator -> $BaselineOperator, Time -> 15 Minute]]},
			{"Data Parsing", 15 Minute, "Processed data is uploaded into the database.", Link[Resource[Operator -> $BaselineOperator, Time -> 15 Minute]]},
			{"Instrument Teardown",20 Minute,"Containers and plates are removed from the instrument and instrument is reset to ground state.",Link[Resource[Operator->$BaselineOperator,Time->20 Minute]]},
			{"Sample Post-Processing", 30 Minute , "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
			{"Returning Materials", 30 Minute, "Storage Conditions are fulfilled for RunningBufferPlate, MarkerPlate, PreMarkerRinsePlate, PreSampleRinsePlate.", Link[Resource[Operator -> $BaselineOperator   , Time -> 30 Minute]]}
		}
	|>;

	(* Generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[samplesWithReplicates,myResolvedOptions,Cache->cache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* get all of the resource out of the packet so they can be tested*)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];



	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine],
		{True, {}},
		gatherTests,
		Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> updatedSimulation, Cache -> cache],
		True,
		{Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> updatedSimulation, Messages -> messages, Cache -> cache], Null}
	];


	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule,optionsRule,resultRule,testsRule}

];

(* ::Subsection:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentFragmentAnalysis,
	Options:>{CacheOption,SimulationOption}
];

(* This simulation function simulates resource picking, sample prep and transfers into the assay plate, and placement of
all reagents into the instrument. No samples are discarded, no caps are placed to cover their containers,
and no containers are moved out of the instrument *)
simulateExperimentFragmentAnalysis[
	myProtocolPacket : PacketP[Object[Protocol, FragmentAnalysis]] | $Failed | Null,
	mySamples : {ObjectP[Object[Sample]]..},
	myResolvedOptions : {_Rule...},
	myResolutionOptions : OptionsPattern[simulateExperimentFragmentAnalysis]
]:=
	Module[
		{
			cache,
			simulation,
			protocolObject,
			currentSimulation,
			simulatedSamples,
			samplePreparationSimulation,
			conditioningSolutionObject,
			conditioningSolutionContainerObject,
			primaryCapillaryFlushSolutionObject,
			primaryCapillaryFlushSolutionContainerObject,
			secondaryCapillaryFlushSolutionObject,
			secondaryCapillaryFlushSolutionContainerObject,
			tertiaryCapillaryFlushSolutionObject,
			tertiaryCapillaryFlushSolutionContainerObject,
			sampleWells,
			ladderWells,
			blankWells,
			prepareRunningBufferPlateQ,
			preparedRunningBufferPlateObject,
			runningBufferPlateStorageCondition,
			wellToRunningBufferRules,
			runningBufferPlateObject,
			runningBufferPlateDestinationSamples,
			runningBufferPlateDestinationSamplesObject,
			sampleRunningBuffersObjects,
			ladderRunningBuffersObjects,
			blankRunningBuffersObjects,
			sampleRunningBufferDestinationObjects,
			ladderRunningBufferDestinationObjects,
			blankRunningBufferDestinationObjects,
			sampleRunningBufferTransferPacket,
			ladderRunningBufferTransferPacket,
			blankRunningBufferTransferPacket,
			runningBufferPlateToWasteTransferPacket,
			markerInjection,
			prepareMarkerPlateQ,
			preparedMarkerPlateObject,
			markerPlateStorageCondition,
			wellToMarkerRules,
			markerPlateObject,
			markerPlateDestinationSamples,
			markerPlateDestinationSamplesObject,
			sampleMarkersObjects,
			ladderMarkersObjects,
			blankMarkersObjects,
			sampleMarkerDestinationObjects,
			sampleMarkerTransferPacket,
			ladderMarkerDestinationObjects,
			ladderMarkerTransferPacket,
			blankMarkerDestinationObjects,
			blankMarkerTransferPacket,
			markerPlateToWasteTransferPacket,
			separationGelObject,
			dyeObject,
			gelDyeContainerObject,
			gelDyeTransferPacket,
			preMarkerRinseBufferPlateObject,
			preMarkerRinseBufferPlateDestinationSamples,
			preMarkerRinseBufferPlateDestinationSamplesObject,
			preMarkerRinseBufferObject,
			preMarkerRinseBufferTransferPacket,
			preSampleRinseBufferPlateObject,
			preSampleRinseBufferPlateDestinationSamples,
			preSampleRinseBufferPlateDestinationSamplesObject,
			preSampleRinseBufferObject,
			preSampleRinseBufferTransferPacket,
			aliquotSampleVolumes,
			samplesInObjects,
			samplesInVolumes,
			sampleObjectToAliquotVolume,
			ladderVolumes,
			sampleLoadingBufferVolumes,
			ladderLoadingBufferVolumes,
			samplesInNewVolumes,
			samplesInPostAliquotVolumePacket,
			samplesInToAliquotVolumeRules,
			aliquotSampleQ,
			samplesInObjectsForAliquot,
			simulatedSamplesWithAliquot,
			mergedSamplesInToAliquotVolume,
			uniqueSamplesInToAliquot,
			samplePlateObject,
			sampleVolumes,
			preparedPlate,
			samplePlateDestinationSamples,
			samplePlateDestinationSamplesObject,
			wellToSampleRules,
			sampleDestinationObjects,
			sampleToPlateTransferPacket,
			ladderObjects,
			ladderDestinationObjects,
			ladderToPlateTransferPacket,
			blankObjects,
			blankDestinationObjects,
			blankToPlateTransferPacket,
			sampleLoadingBufferObjects,
			sampleLoadingBufferToPlateTransferPacket,
			ladderLoadingBufferObjects,
			ladderLoadingBufferToPlateTransferPacket,
			sampleLoadingBufferDestinationObjects,
			ladderLoadingBufferDestinationObjects,
			sampleDiluentVolumes,
			sampleDiluentObjects,
			sampleDiluentDestinationObjects,
			sampleDiluentToPlateTransferPacket,
			wasteObjects,
			wasteTransferPacket
		},
		
		(* Lookup our cache and simulation *)
		cache = Lookup[ToList[myResolutionOptions], Cache, {}];
		simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

		(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
		protocolObject = If[MatchQ[myProtocolPacket, $Failed],
			SimulateCreateID[Object[Protocol,FragmentAnalysis]],
			Lookup[myProtocolPacket, Object]
		];
		
		(* Simulate the fulfillment of all resources by the procedure. *)
		(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
		(* just make a shell of a protocol object so that we can return something back. *)
		currentSimulation=If[MatchQ[myProtocolPacket, $Failed],
			SimulateResources[
				<|
					Object->protocolObject,
					Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
					ResolvedOptions->myResolvedOptions
				|>,
				Cache->cache,
				Simulation->simulation
			],
			SimulateResources[
				myProtocolPacket,
				Cache->cache,
				Simulation->simulation
			]
		];

		(*simulate the creation of new samples (simulatedSamples) corresponding to post-sample preparation of mySamples*)
		{simulatedSamples, samplePreparationSimulation} = simulateSamplesResourcePacketsNew[ExperimentFragmentAnalysis, mySamples, myResolvedOptions, Simulation -> simulation];

		(*Update currentSimulation with the state of the SamplesIn and the generated simulatedSamples*)
		currentSimulation=UpdateSimulation[currentSimulation,samplePreparationSimulation];
		
		(*Downloads*)
		{
			separationGelObject,
			dyeObject,
			conditioningSolutionObject,
			primaryCapillaryFlushSolutionObject,
			secondaryCapillaryFlushSolutionObject,
			tertiaryCapillaryFlushSolutionObject,
			preparedRunningBufferPlateObject,
			runningBufferPlateObject,
			sampleRunningBuffersObjects,
			ladderRunningBuffersObjects,
			blankRunningBuffersObjects,
			runningBufferPlateStorageCondition,
			sampleWells,
			ladderWells,
			blankWells,
			markerInjection,
			preparedMarkerPlateObject,
			markerPlateObject,
			sampleMarkersObjects,
			ladderMarkersObjects,
			blankMarkersObjects,
			markerPlateStorageCondition,
			preMarkerRinseBufferPlateObject,
			preMarkerRinseBufferObject,
			preSampleRinseBufferPlateObject,
			preSampleRinseBufferObject,
			samplesInObjects,
			ladderObjects,
			blankObjects,
			samplePlateObject,
			sampleLoadingBufferObjects,
			ladderLoadingBufferObjects,
			sampleDiluentObjects,
			gelDyeContainerObject,
			conditioningSolutionContainerObject,
			primaryCapillaryFlushSolutionContainerObject,
			secondaryCapillaryFlushSolutionContainerObject,
			tertiaryCapillaryFlushSolutionContainerObject
		}=Download[protocolObject,
			{
				SeparationGel,
				Dye,
				ConditioningSolution,
				PrimaryCapillaryFlushSolution,
				SecondaryCapillaryFlushSolution,
				TertiaryCapillaryFlushSolution,
				PreparedRunningBufferPlate,
				RunningBufferPlate,
				SampleRunningBuffers,
				LadderRunningBuffers,
				BlankRunningBuffers,
				RunningBufferPlateStorageCondition,
				SampleWells,
				LadderWells,
				BlankWells,
				MarkerInjection,
				PreparedMarkerPlate,
				MarkerPlate,
				SampleMarkers,
				LadderMarkers,
				BlankMarkers,
				MarkerPlateStorageCondition,
				PreMarkerRinseBufferPlate,
				PreMarkerRinseBuffer,
				PreSampleRinseBufferPlate,
				PreSampleRinseBuffer,
				SamplesIn,
				Ladders,
				Blanks,
				SamplePlate,
				SampleLoadingBuffers,
				LadderLoadingBuffers,
				SampleDiluents,
				SeparationGel[Container],
				ConditioningSolution[Container],
				PrimaryCapillaryFlushSolution[Container],
				SecondaryCapillaryFlushSolution[Container],
				TertiaryCapillaryFlushSolution[Container]
			},
			Simulation->currentSimulation
		];
	
		(*simulateSamplesResourcePacketsNew does not update the volume of the source for the aliqout samples so this is done here*)
		aliquotSampleQ=Lookup[myResolvedOptions,Aliquot];
		
		samplesInObjectsForAliquot=If[MatchQ[Length[samplesInObjects],Length[aliquotSampleQ]],
			PickList[samplesInObjects,aliquotSampleQ],
			{}
		];

		simulatedSamplesWithAliquot=If[MatchQ[Length[simulatedSamples],Length[aliquotSampleQ]],
			PickList[simulatedSamples,aliquotSampleQ],
			{}
		];

		aliquotSampleVolumes=Lookup[myResolvedOptions,AliquotAmount];

		sampleObjectToAliquotVolume=If[MatchQ[simulatedSamplesWithAliquot, {ObjectP[]..}],
			Download[
				simulatedSamplesWithAliquot,
				Volume,
				Simulation->currentSimulation
			],
			{}
		];

		samplesInToAliquotVolumeRules=If[MemberQ[samplesInObjectsForAliquot, ObjectP[]]&&MatchQ[Length[samplesInObjectsForAliquot],Length[sampleObjectToAliquotVolume]],
			MapThread[
				#1->#2&,
				{
					samplesInObjectsForAliquot,
					sampleObjectToAliquotVolume
				}
			],
			{}
		];

		mergedSamplesInToAliquotVolume=If[MatchQ[samplesInObjectsForAliquot,{ObjectP[]..}],
			Values[Merge[samplesInToAliquotVolumeRules,Total]],
			{}
		];

		uniqueSamplesInToAliquot=If[MatchQ[samplesInObjectsForAliquot, {ObjectP[]..}],
			Keys[Merge[samplesInToAliquotVolumeRules,Total]],
			{}
		];

		samplesInVolumes=If[MatchQ[samplesInObjectsForAliquot, {ObjectP[]..}],
			Download[
				uniqueSamplesInToAliquot,
				Volume,
				Simulation->currentSimulation
			],
			{}
		];

		samplesInNewVolumes=If[MatchQ[samplesInObjectsForAliquot, {ObjectP[]..}],
			MapThread[
				#1-#2&,
				{
					samplesInVolumes,
					mergedSamplesInToAliquotVolume
				}
			],
			{}
		];

		samplesInPostAliquotVolumePacket=If[MatchQ[samplesInObjectsForAliquot, {ObjectP[]..}],
			UploadSampleProperties[
				uniqueSamplesInToAliquot,
				Volume->samplesInNewVolumes,
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[currentSimulation,Simulation[samplesInPostAliquotVolumePacket]];
		
		(*Preparation of Gel-Dye Solution*)
		gelDyeTransferPacket=If[MatchQ[dyeObject,ObjectP[]]&&MatchQ[separationGelObject,ObjectP[]],
			UploadSampleTransfer[
				dyeObject,
				separationGelObject,
				All,
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[currentSimulation,Simulation[gelDyeTransferPacket]];

		(*Preparation of RunningBufferPlate*)
		(*If a PreparedRunningBufferPlate is used, no need to prepare a new plate*)
		prepareRunningBufferPlateQ=!MatchQ[preparedRunningBufferPlateObject,ObjectP[]]&&MatchQ[runningBufferPlateObject,ObjectP[]];
		
		runningBufferPlateDestinationSamples=If[prepareRunningBufferPlateQ&&MatchQ[runningBufferPlateObject,ObjectP[]],
			UploadSample[
				ConstantArray[{}, 96],
				Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[runningBufferPlateObject, 96]}],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False,
				SimulationMode -> True
			],
			{}
		];

		currentSimulation=UpdateSimulation[currentSimulation,Simulation[runningBufferPlateDestinationSamples]];

		runningBufferPlateDestinationSamplesObject=If[prepareRunningBufferPlateQ&&MatchQ[runningBufferPlateDestinationSamples,Except[{}]],
			Take[Lookup[runningBufferPlateDestinationSamples,Object],96],
			{}
		];

		wellToRunningBufferRules=If[prepareRunningBufferPlateQ,
			MapThread[
				#1->#2&,
				{
					Flatten[AllWells[]],
					runningBufferPlateDestinationSamplesObject
				}
			],
			{}
		];

		sampleRunningBufferDestinationObjects=If[MatchQ[wellToRunningBufferRules,{_Rule..}],
			sampleWells/.wellToRunningBufferRules,
			{}
		];
		
		sampleRunningBufferTransferPacket=If[prepareRunningBufferPlateQ&&MemberQ[sampleRunningBufferDestinationObjects,ObjectP[]],
			UploadSampleTransfer[
				sampleRunningBuffersObjects,
				sampleRunningBufferDestinationObjects,
				ConstantArray[1 Milliliter,Length[sampleRunningBuffersObjects]],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[sampleRunningBufferTransferPacket]
		];

		ladderRunningBufferDestinationObjects= If[MatchQ[wellToRunningBufferRules,{_Rule..}],
			ladderWells/.wellToRunningBufferRules,
			{}
		];
		
		ladderRunningBufferTransferPacket=If[MatchQ[ToList[ladderRunningBuffersObjects],{ObjectP[]..}]&&prepareRunningBufferPlateQ,
			UploadSampleTransfer[
				ladderRunningBuffersObjects,
				ladderRunningBufferDestinationObjects,
				ConstantArray[1 Milliliter,Length[ladderRunningBuffersObjects]],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[ladderRunningBufferTransferPacket]
		];

		blankRunningBufferDestinationObjects= If[MatchQ[wellToRunningBufferRules,{_Rule..}],
			blankWells/.wellToRunningBufferRules,
			{}
		];
		
		blankRunningBufferTransferPacket=If[MatchQ[ToList[blankRunningBuffersObjects],{ObjectP[]..}]&&prepareRunningBufferPlateQ,
			UploadSampleTransfer[
				blankRunningBuffersObjects,
				blankRunningBufferDestinationObjects,
				ConstantArray[1 Milliliter,Length[blankRunningBuffersObjects]],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[blankRunningBufferTransferPacket]
		];

		runningBufferPlateToWasteTransferPacket=If[MatchQ[runningBufferPlateStorageCondition,Disposal]&&MatchQ[runningBufferPlateObject,ObjectP[]],
			UploadLocation[
				runningBufferPlateObject,
				Waste,
				Simulation->currentSimulation,
				Upload->False,
				UpdatedBy->protocolObject
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[runningBufferPlateToWasteTransferPacket]
		];
		
		(*Preparation of MarkerPlate*)
		(*If MarkerInjection is True and a PreparedMarkerPlate is not used, prepare a new MarkerPlate*)
		prepareMarkerPlateQ=MatchQ[markerInjection,True]&&!MatchQ[preparedMarkerPlateObject,ObjectP[]]&&MatchQ[markerPlateObject,ObjectP[]];
		
		markerPlateDestinationSamples=If[prepareMarkerPlateQ,
			UploadSample[
				ConstantArray[{}, 96],
				Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[markerPlateObject, 96]}],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False,
				SimulationMode -> True
			],
			{}
		];

		currentSimulation=UpdateSimulation[currentSimulation,Simulation[markerPlateDestinationSamples]];

		markerPlateDestinationSamplesObject=If[prepareMarkerPlateQ,
			Take[Lookup[markerPlateDestinationSamples,Object],96],
			{}
		];

		wellToMarkerRules=If[MatchQ[markerPlateDestinationSamplesObject,{ObjectP[]..}]&&prepareMarkerPlateQ,
			MapThread[
				#1->#2&,
				{
					Flatten[AllWells[]],
					markerPlateDestinationSamplesObject
				}
			],
			{}
		];

		sampleMarkerDestinationObjects=If[MatchQ[sampleMarkersObjects,{ObjectP[]..}]&&prepareMarkerPlateQ,
			sampleWells/.wellToMarkerRules,
			{}
		];
	
		sampleMarkerTransferPacket=If[MatchQ[sampleMarkersObjects,{ObjectP[]..}]&&prepareMarkerPlateQ,
			UploadSampleTransfer[
				sampleMarkersObjects,
				sampleMarkerDestinationObjects,
				ConstantArray[30 Microliter,Length[sampleMarkersObjects]],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[sampleMarkerTransferPacket]
		];

		ladderMarkerDestinationObjects=If[MatchQ[ladderMarkersObjects,{ObjectP[]..}]&&prepareMarkerPlateQ,
			ladderWells/.wellToMarkerRules,
			{}
		];
		
		ladderMarkerTransferPacket=If[MatchQ[ladderMarkersObjects,{ObjectP[]..}]&&prepareMarkerPlateQ,
			UploadSampleTransfer[
				ladderMarkersObjects,
				ladderMarkerDestinationObjects,
				ConstantArray[30 Microliter,Length[ladderMarkersObjects]],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[ladderMarkerTransferPacket]
		];

		blankMarkerDestinationObjects=If[MatchQ[blankMarkersObjects,{ObjectP[]..}]&&prepareMarkerPlateQ,
			blankWells/.wellToMarkerRules,
			{}
		];
		
		blankMarkerTransferPacket=If[MatchQ[blankMarkersObjects,{ObjectP[]..}]&&prepareMarkerPlateQ,
			UploadSampleTransfer[
				blankMarkersObjects,
				blankMarkerDestinationObjects,
				ConstantArray[30 Microliter,Length[blankMarkersObjects]],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[blankMarkerTransferPacket]
		];

		markerPlateToWasteTransferPacket=If[MatchQ[markerPlateStorageCondition,Disposal]&&MatchQ[markerPlateObject,ObjectP[]],
			UploadLocation[
				markerPlateObject,
				Waste,
				Simulation->currentSimulation,
				Upload->False,
				UpdatedBy->protocolObject
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[markerPlateToWasteTransferPacket]
		];
		
		(*Preparation of PreMarkerRinseBufferPlate*)
		preMarkerRinseBufferPlateDestinationSamples=If[MatchQ[preMarkerRinseBufferPlateObject,ObjectP[]],
			UploadSample[
				ConstantArray[{}, 96],
				Transpose[{Flatten[AllWells[]], ConstantArray[preMarkerRinseBufferPlateObject, 96]}],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False,
				SimulationMode -> True
			],
			{}
		];

		currentSimulation=UpdateSimulation[currentSimulation,Simulation[preMarkerRinseBufferPlateDestinationSamples]];

		preMarkerRinseBufferPlateDestinationSamplesObject=If[MatchQ[preMarkerRinseBufferPlateObject,ObjectP[]],
			Take[Lookup[preMarkerRinseBufferPlateDestinationSamples,Object],96],
			{}
		];

		preMarkerRinseBufferTransferPacket=If[MatchQ[preMarkerRinseBufferObject,ObjectP[]]&&MatchQ[preMarkerRinseBufferPlateDestinationSamplesObject,{ObjectP[]..}],
			UploadSampleTransfer[
				ConstantArray[preMarkerRinseBufferObject,96],
				preMarkerRinseBufferPlateDestinationSamplesObject,
				ConstantArray[200 Microliter,96],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[preMarkerRinseBufferTransferPacket]
		];
		
		(*Preparation of PreSampleRinseBufferPlate*)
		preSampleRinseBufferPlateDestinationSamples=If[MatchQ[preSampleRinseBufferPlateObject,ObjectP[]],
			UploadSample[
				ConstantArray[{}, 96],
				Transpose[{Flatten[AllWells[]], ConstantArray[preSampleRinseBufferPlateObject, 96]}],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False,
				SimulationMode -> True
			],
			{}
		];

		currentSimulation=UpdateSimulation[currentSimulation,Simulation[preSampleRinseBufferPlateDestinationSamples]];

		preSampleRinseBufferPlateDestinationSamplesObject=If[MatchQ[preSampleRinseBufferPlateObject,ObjectP[]],
			Take[Lookup[preSampleRinseBufferPlateDestinationSamples,Object],96],
			{}
		];

		preSampleRinseBufferTransferPacket=If[MatchQ[preSampleRinseBufferObject,ObjectP[]]&&MatchQ[preSampleRinseBufferPlateDestinationSamplesObject,{ObjectP[]..}],
			UploadSampleTransfer[
				ConstantArray[preSampleRinseBufferObject,96],
				preSampleRinseBufferPlateDestinationSamplesObject,
				ConstantArray[200 Microliter,96],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[preSampleRinseBufferTransferPacket]
		];
	
		(*Preparation of SamplePlate*)
		(*Samples,Ladders and Blanks to SamplePlate*)
		preparedPlate=Lookup[myResolvedOptions,PreparedPlate];
		sampleVolumes=Lookup[myResolvedOptions,SampleVolume];
		ladderVolumes=Lookup[myResolvedOptions,LadderVolume];

		samplePlateDestinationSamples=If[MatchQ[preparedPlate,False]&&MatchQ[samplePlateObject,ObjectP[]],
			UploadSample[
				ConstantArray[{}, 96],
				Transpose[{Flatten[AllWells[]], ConstantArray[samplePlateObject, 96]}],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False,
				SimulationMode -> True
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[samplePlateDestinationSamples]
		];
		
		samplePlateDestinationSamplesObject=If[MatchQ[preparedPlate,False]&&MatchQ[samplePlateDestinationSamples,Except[{}]],
			Take[Lookup[samplePlateDestinationSamples,Object],96],
			{}
		];
		

		wellToSampleRules=If[MatchQ[preparedPlate,False]&&MatchQ[samplePlateDestinationSamplesObject,Except[{}]],
			MapThread[
				#1->#2&,
				{
					Flatten[AllWells[]],
					samplePlateDestinationSamplesObject
				}
			],
			{}
		];

		sampleDestinationObjects=If[MatchQ[preparedPlate,False]&&MatchQ[wellToSampleRules,{_Rule..}],
			sampleWells/.wellToSampleRules,
			{}
		];

		sampleToPlateTransferPacket=If[MatchQ[preparedPlate,False]&&MatchQ[simulatedSamples,{ObjectP[]..}]&&MatchQ[simulatedSamples,{sampleDestinationObjects[]..}]&&MatchQ[sampleVolumes,{_?QuantityQ ..}],
			UploadSampleTransfer[
				simulatedSamples,
				sampleDestinationObjects,
				sampleVolumes,
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[sampleToPlateTransferPacket]
		];
		
		ladderDestinationObjects=If[MatchQ[preparedPlate,False]&&MatchQ[ladderWells,{WellPositionP[]..}]&&MatchQ[wellToSampleRules,{_Rule..}],
			ladderWells/.wellToSampleRules,
			{}
		];

		ladderToPlateTransferPacket=If[MatchQ[preparedPlate,False]&&MatchQ[ladderObjects,{ObjectP[]..}]&&MatchQ[ladderDestinationObjects,{ObjectP[]..}],
			UploadSampleTransfer[
				ladderObjects,
				ladderDestinationObjects,
				ladderVolumes,
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[ladderToPlateTransferPacket]
		];
		
		blankDestinationObjects=If[MatchQ[preparedPlate,False]&&MatchQ[blankWells,{WellPositionP..}]&&MatchQ[wellToSampleRules,{_Rule..}],
			blankWells/.wellToSampleRules,
			{}
		];

		blankToPlateTransferPacket=If[MatchQ[preparedPlate,False]&&MatchQ[blankObjects,{ObjectP[]..}]&&MatchQ[blankDestinationObjects,{ObjectP[]..}],
			UploadSampleTransfer[
				blankObjects,
				blankDestinationObjects,
				ConstantArray[24 Microliter,Length[blankObjects]],
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[blankToPlateTransferPacket]
		];
		
		(*SampleLoadingBuffers,LadderLoadingBuffers to SamplePlate*)
		sampleLoadingBufferVolumes=If[MemberQ[sampleLoadingBufferObjects,ObjectP[]],
			PickList[Lookup[myResolvedOptions,SampleLoadingBufferVolume],sampleLoadingBufferObjects,ObjectP[]],
			{}
		];
		ladderLoadingBufferVolumes=If[MemberQ[ladderLoadingBufferObjects,ObjectP[]],
			PickList[Lookup[myResolvedOptions,LadderLoadingBufferVolume],ladderLoadingBufferObjects,ObjectP[]],
			{}
		];

		sampleLoadingBufferDestinationObjects=If[MatchQ[preparedPlate,False]&&MemberQ[sampleLoadingBufferObjects,ObjectP[]],
			PickList[sampleDestinationObjects,sampleLoadingBufferObjects,ObjectP[]],
			{}
		];

		sampleLoadingBufferToPlateTransferPacket=If[MatchQ[preparedPlate,False]&&MemberQ[sampleLoadingBufferDestinationObjects,ObjectP[]],
			UploadSampleTransfer[
				sampleLoadingBufferObjects,
				sampleLoadingBufferDestinationObjects,
				sampleLoadingBufferVolumes,
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[sampleLoadingBufferToPlateTransferPacket]
		];
		
		ladderLoadingBufferDestinationObjects=If[MatchQ[preparedPlate,False]&&MemberQ[ladderLoadingBufferObjects,ObjectP[]],
			PickList[ladderDestinationObjects,ladderLoadingBufferObjects,ObjectP[]],
			{}
		];

		ladderLoadingBufferToPlateTransferPacket=If[MatchQ[preparedPlate,False]&&MemberQ[ladderLoadingBufferObjects,ObjectP[]],
			UploadSampleTransfer[
				ladderLoadingBufferObjects,
				ladderLoadingBufferDestinationObjects,
				ladderLoadingBufferVolumes,
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[ladderLoadingBufferToPlateTransferPacket]
		];
		
		(*SampleDiluent to SamplePlate*)
		sampleDiluentVolumes=If[MatchQ[Length[Lookup[myResolvedOptions,SampleDiluentVolume]],Length[sampleDiluentObjects]],
			PickList[Lookup[myResolvedOptions,SampleDiluentVolume],sampleDiluentObjects,ObjectP[]],
			{}
		];

		sampleDiluentDestinationObjects=If[MatchQ[preparedPlate,False]&&MemberQ[sampleDiluentObjects,ObjectP[]],
			PickList[sampleDestinationObjects,sampleDiluentObjects,ObjectP[]],
			{}
		];

		sampleDiluentToPlateTransferPacket=If[MatchQ[preparedPlate,False]&&MemberQ[sampleDiluentObjects,ObjectP[]],
			UploadSampleTransfer[
				sampleDiluentObjects,
				sampleDiluentDestinationObjects,
				sampleDiluentVolumes,
				Simulation -> currentSimulation,
				UpdatedBy->protocolObject,
				Upload->False
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[sampleDiluentToPlateTransferPacket]
		];
		
		wasteObjects=DeleteCases[{gelDyeContainerObject, conditioningSolutionContainerObject, secondaryCapillaryFlushSolutionContainerObject, primaryCapillaryFlushSolutionContainerObject, tertiaryCapillaryFlushSolutionContainerObject, samplePlateObject},Except[ObjectP[]]];

		wasteTransferPacket=If[MemberQ[wasteObjects,ObjectP[]],
			UploadLocation[
				wasteObjects,
				Waste,
				Simulation->currentSimulation,
				Upload->False,
				UpdatedBy->protocolObject
			],
			{}
		];

		currentSimulation=UpdateSimulation[
			currentSimulation,Simulation[wasteTransferPacket]
		];
		
		{
			protocolObject,
			currentSimulation
		}
	];

(* ::Subsection::Closed:: *)
(*Sister Functions*)


(* ::Subsection::Closed:: *)
(*ExperimentFragmentAnalysisOptions*)

DefineOptions[ExperimentFragmentAnalysisOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions:>{ExperimentFragmentAnalysis}
];


(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer pair inputs---*)
ExperimentFragmentAnalysisOptions[
	mySamples:ListableP[ObjectP[Object[Container]]]|ListableP[(ObjectP[{Object[Sample],Model[Sample]}]|_String)],
	myOptions:OptionsPattern[ExperimentFragmentAnalysisOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentFragmentAnalysis[mySamples,preparedOptions];

	(* If options fail, return failure *)
	If[MatchQ[resolvedOptions,$Failed],
		Return[$Failed]
	];

	(*Return the option as a list or table*)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentFragmentAnalysis],
		resolvedOptions
	]
];

(* ::Subsection::Closed:: *)
(*ValidExperimentFragmentAnalysisQ*)

DefineOptions[ValidExperimentFragmentAnalysisQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{ExperimentFragmentAnalysis}
];

ValidExperimentFragmentAnalysisQ[mySamples:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentFragmentAnalysisQ]]:=Module[
	{listedOptions,preparedOptions,fragmentAnalysisTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for ExperimentFragmentAnalysis *)
	fragmentAnalysisTests=ExperimentFragmentAnalysis[mySamples,Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails).";

	(*Make a list of all of the tests, including the blanket test *)
	allTests=If[MatchQ[fragmentAnalysisTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test, which we know will pass if we got this far *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[ToList[mySamples],_String],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[mySamples],_String],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest,fragmentAnalysisTests,voqWarnings}]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentFragmentAnalysisQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentFragmentAnalysisQ"]

];

(* ::Subsection:: *)
(*ExperimentFragmentAnalysisPreview*)

DefineOptions[ExperimentFragmentAnalysisPreview,
	SharedOptions:>{ExperimentFragmentAnalysis}
];

ExperimentFragmentAnalysisPreview[mySamples:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[ExperimentFragmentAnalysisPreview]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentFragmentAnalysis[mySamples,ReplaceRule[listedOptions,Output->Preview]]
];

