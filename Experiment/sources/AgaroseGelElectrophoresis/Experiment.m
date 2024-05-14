(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentAgaroseGelElectrophoresis*)


(* ::Subsubsection::Closed:: *)
(*ExperimentAgaroseGelElectrophoresis Options and Messages*)


DefineOptions[ExperimentAgaroseGelElectrophoresis,
	Options :> {
		{
			OptionName->Scale,
			Default->Automatic,
			Description->"The method of gel electrophoresis to run to obtain the separation of samples. If set to Preparative, gel is imaged throughout the run and the target band is collected; if set to Analytical, the gel is only be imaged and no bands are collected.",
			ResolutionDescription -> "Automatically set to Analytical if Gel is set a gel of Model in AnalyticalAgaroseGelP, or Preparative if Gel is set to a gel of Model in PreparativeAgaroseGelP or is unspecified. See the ExperimentAgaroseGelElectrophoresis documentation for a full list of these gels.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Enumeration,
				Pattern:> PurificationScaleP
			]
		},
		{
			OptionName->AgarosePercentage,
			Default->Automatic,
			Description->"The percent of agarose (w/v) present in the gels used in this experiment.",
			ResolutionDescription -> "Automatically set to be the GelPercentage of the Gel if the Gel option has been specified. Otherwise, this option is set based on the average Length of the longest Model[Molecule,Oligomer] present in each of the input samples' Analytes field (or Composition field if there are no Oligomer Analytes for a given sample). The AgarosePercentage is set to be 3%, 2%, 1.5%, 1%, or 0.5% if the average oligomer length is between 1 and 199 basepairs, between 200 and 399 basepairs, between 400 and 1249 basepairs, between 1250 and 3999 basepairs, or larger than 3999 basepairs, respectively.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Enumeration,
				Pattern:> AgarosePercentageP
			]
		},
		{
			OptionName->Gel,
			Default->Automatic,
			Description->"The agarose gel(s) that the input samples are run through.",
			ResolutionDescription -> "See the ExperimentAgaroseGelElectrophoresis documentation to see what this is set to depending on the Scale and AgarosePercent options.",
			AllowNull->False,
			Category->"General",
			Widget->Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Item, Gel],Object[Item,Gel]}]
				],
				Adder[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Item, Gel]]
					]
				]
			]
		},
		{
			OptionName->Ladder,
			Default->Automatic,
			Description->"The sample or model of ladder to be used as a standard, reference ladder in the Experiment.",
			ResolutionDescription -> "Automatically set to be Null if the Scale is Preparative. If the Scale is Analytical, the option is automatically set to Model[Sample, StockSolution, Standard, \"GeneRuler dsDNA 10000-50000 bp, 8 bands, 50 ng/uL\"] if the AgarosePercentage is 0.5%, to Model[Sample, StockSolution, Standard, \"GeneRuler dsDNA 75-20000 bp, 15 bands, 50 ng/uL\"] if the AgarosePercentage is 1% or 1.5%, to Model[Sample, StockSolution, Standard, \"GeneRuler dsDNA 25-700 bp, 10 bands, 50 ng/uL\"] if the AgarosePercentage is 2%, and to Model[Sample, StockSolution, Standard, \"GeneRuler dsDNA 10-300 bp, 11 bands, 50 ng/uL\"] if the AgarosePercentage is 3%.",
			AllowNull->True,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample], Model[Sample]}]
			]
		},
		{
			OptionName->LadderFrequency,
			Default->Automatic,
			Description->"The frequency a reference ladder will be used on each agarose gel in the Experiment. When First is specified, the ladder will be loaded onto the first well of every gel; When specifying FirstAndLast, the ladder will be loaded before and after samples loaded on every gel.",
			ResolutionDescription -> "Automatically set to be Null if the Scale is Preparative. If the Scale is Analytical, the option is automatically set to FirstAndLast.",
			AllowNull->True,
			Category->"General",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>First|FirstAndLast
			]
		},
		{
		    OptionName->LadderStorageCondition,
		    Default->Null,
            Description->"The non-default conditions under which any ladder used by this experiment should be stored after the protocol is completed. If left unset, the ladder will be stored according to their Models' DefaultStorageCondition.",
            AllowNull->True,
            Category->"General",
            Widget->Widget[
                Type->Enumeration,
                Pattern:>SampleStorageTypeP|Disposal
            ]
		},
		{
			OptionName->Instrument,
			Default->Model[Instrument, Electrophoresis, "Ranger"],
			Description->"The electrophoresis instrument used for this experiment.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern :> ObjectP[{Object[Instrument, Electrophoresis], Model[Instrument, Electrophoresis]}]
			]
		},
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description->"The number of wells each input sample is loaded into. For example {input 1, input 2} with NumberOfReplicates->2 acts like {input 1, input 1, input 2, input 2}.",
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
				OptionName->SampleVolume,
				Default->Automatic,
				Description->"The amount of each input sample that is mixed with the LoadingDye before a portion of the mixture (the SampleLoadingVolume) is loaded into the gel.",
				ResolutionDescription -> "Automatically set to 52.8 uL if the Scale is Preparative, or to 10 uL if the Scale is Analytical.",
				AllowNull->False,
				Category->"Loading",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Micro Liter, 80 Micro Liter],
					Units->Micro Liter
				]
			},
			{
				OptionName-> LoadingDye,
				Default->Automatic,
				Description->"The dye(s) that are mixed with the sample and LoadingDilutionBuffer according to the SampleVolume, LoadingDilutionBufferVolume, and LoadingDyeVolume options.  The dyes contain Ficoll, SYBR Gold, and a cyanine-labeled DNA sizing reference used to mark the progress of the electrophoresis.  Note that while one or two LoadingDyes can be specified, it is recommended to use two dyes for each sample. The only accepted LoadingDye Models are members of AgaroseLoadingDyeP.",
				ResolutionDescription -> "Automatically set based on the value of the AgarosePercentage option. See the ExperimentAgaroseGelElectrophoresis documentation to see which dyes are chosen for each percentage.",
				AllowNull->False,
				Category->"Loading",
				Widget-> Adder[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
					]
				]
			},
			{
				OptionName->LoadingDyeVolume,
				Default->Automatic,
				Description->"The amount of each LoadingDye that is mixed with the sample and LoadingDilutionBuffer according to the SampleVolume, LoadingDilutionBufferVolume, and LoadingDyeVolume options.",
				ResolutionDescription -> "Automatically set to 0.072 * the MaxWellVolume of the specified Gel if the Scale is Preparative, or 0.1875 * the MaxWellVolume of the specified Gel if the Scale is Analytical.",
				AllowNull->False,
				Category->"Loading",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Micro Liter, 10 Micro Liter],
					Units->Micro Liter
				]
			},
			{
				OptionName-> LoadingDilutionBuffer,
				Default->Automatic,
				Description->"The buffer that is mixed with the sample and LoadingDye according to the SampleVolume, LoadingDilutionBufferVolume, and LoadingDyeVolume options.",
				ResolutionDescription -> "If SampleVolume + (2*LoadingDyeVolume) is less 10 uL when the Scale is Analytical, or less than 60 uL when the Scale is Preparative, automatically set to Model[Sample, StockSolution, \"1x TE Buffer\"].",
				AllowNull->True,
				Category->"Loading",
				Widget->Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
				]
			},
			{
				OptionName->LoadingDilutionBufferVolume,
				Default->Automatic,
				Description->"The amount of LoadingDilutionBuffer that is mixed with the sample and LoadingDye according to the SampleVolume, LoadingDilutionBufferVolume, and LoadingDyeVolume options.",
				ResolutionDescription -> "If SampleVolume + (2*LoadingDyeVolume) is less 10 uL when the Scale is Analytical, or less than 60 uL when the Scale is Preparative, automatically set to the difference between the two values.",
				AllowNull->False,
				Category->"Loading",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Micro Liter, 80 Micro Liter],
					Units->Micro Liter
				]
			},
			{
				OptionName->AutomaticPeakDetection,
				Default->Automatic,
				Description->"Indicates if the instrument software detects and collects the largest peak within the PeakDetectionRange when Scale is Preparative. It is recommended to set AutomaticPeakDetection to True when Scale is Preparative.",
				ResolutionDescription->"The AutomaticPeakDetection is set to Null if the Scale is Analytical. The option is set to False if either the CollectionSize or CollectionWidth options are specified as non-Null values. The option is set to be True if the PeakDetectionRange is set to a non-Null value, or if none of the PeakDetectionRange, CollectionSize, or CollectionWidth options are specified.",
				AllowNull->True,
				Category->"Collection",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				]
			},
			{
				OptionName->PeakDetectionRange,
				Default->Automatic,
				Description->"The range, in base pairs, between which the instrument software detects and collects the largest peak when Scale is Preparative and AutomaticPeakDetection is True.",
				ResolutionDescription->"The PeakDetectionRange is set to Null if the Scale is Analytical. The option is set to Null if AutomaticPeakDetection is False. If AutomaticPeakDetection is True, it is set to the range between 75% and 110% of the length of the largest Model[Molecule,Oligomer] present in the input Sample's Analytes field, or in the Composition field if there are no Oligomers in the Analytes field.",
				AllowNull->True,
				Category->"Collection",
				Widget->Span[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1*BasePair, 20000*BasePair, 1*BasePair],
						Units -> BasePair
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1*BasePair, 20000*BasePair, 1*BasePair],
						Units -> BasePair
					]
				]
			},
			{
				OptionName -> CollectionSize,
				Default-> Automatic,
				Description->"The size of the sample to collect after purification in base pairs when Scale is Preparative and AutomaticPeakDetection is False.",
				ResolutionDescription -> "The CollectionSize is set to Null if the Scale is Analytical. The option is set to Null if AutomaticPeakDetection is True. If AutomaticPeakDetection is False, it is set to the length of the largest Model[Molecule,Oligomer] present in the input Sample's Analytes field, or in the Composition field if there are no Oligomers in the Analytes field.",
				AllowNull-> True,
				Category->"Collection",
				Widget-> Widget[
					Type->Quantity,
					Pattern:> RangeP[1 BasePair, 20000 BasePair,1*BasePair],
					Units-> BasePair
				]
			},
			{
				OptionName -> CollectionRange,
				Default-> Automatic,
				Description->"The range of the collection area in base pairs when the Scale is Preparative AutomaticPeakDetection is False, and CollectionSize is Null. This instrument manufacturer recommends not specifying this option, as doing so may lead to either low sample recovery, or dilute SamplesOut. It is recommended to only specify the CollectionSize and the ExtractionVolume, if AutomaticPeakDetection is False.",
				ResolutionDescription -> "The CollectionRange is set to Null if the Scale is Analytical. The option is set to Null if AutomaticPeakDetection is True. If AutomaticPeakDetection is False, and the CollectionSize option is set to Null, the CollectionRange is set to the range between 92% and 105% of the length of the largest Model[Molecule,Oligomer] present in the input Sample's Analytes field, or in the Composition field if there are no Oligomers in the Analytes field.",
				AllowNull-> True,
				Category->"Collection",
				Widget-> Span[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1*BasePair, 20000*BasePair, 1*BasePair],
						Units -> BasePair
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[1*BasePair, 20000*BasePair, 1*BasePair],
						Units -> BasePair
					]
				]
			}
		],
		{
			OptionName->SampleLoadingVolume,
			Default->Automatic,
			Description->"The volume of the sample and loading dye buffer mixture that is loaded into each gel well.",
			ResolutionDescription -> "Automatically set to 50 Microliter if the Scale is Preparative, and 8 Microliter if the Scale is Analytical.",
			AllowNull->False,
			Category->"Loading",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[5*Microliter,50*Microliter],
				Units->Micro Liter
			]
		},
		{
			OptionName->SeparationTime,
			Default->Automatic,
			Description->"The amount of time voltage is applied across the gel (if the Scale is Analytical) or the maximum time voltage is applied in attempt to isolate the sample (if the Scale is Preparative).",
			ResolutionDescription -> "Automatically set to 5000 seconds if the Scale is Preparative, and to 2500 seconds if the Scale is Analytical",
			AllowNull->False,
			Category->"Separation",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[Minute,4*Hour],
				Units->Alternatives[Second,Minute,Hour]
			]
		},
		{
			OptionName->DutyCycle,
			Default->Automatic,
			Description->"The maximum percent of the SeparationTime that the 100 Volts is applied across the gel, with a voltage switching frequency of 8 kHz. When Scale is Analytical, the DutyCycle is always constant. When Scale is Preparative, the DutyCycle for individual lanes may be reduced below the set maximum so that bands of the desired size can be extracted from adjacent lanes simultaneously.",
			ResolutionDescription -> "Automatically set to 100% if the AgarosePercentage is 2 or 3%, to 50% if the AgarosePercentage is 1.5 or 1%, and to 35% if the AgarosePercentage is 0.5%.",
			AllowNull->False,
			Category->"Separation",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[Percent, 100*Percent],
				Units->Percent
			]
		},
		{
			OptionName->ExtractionVolume,
			Default->Automatic,
			Description->"The amount of running buffer containing nucleotides of the appropriate size designated by the PeakDetectionRange, CollectionSize, or CollectionRange that is removed from Gel during electrophoretic separation and transferred to DestinationPlate. The ExtractionVolume can affect the sample recovery percentage.",
			ResolutionDescription->"Automatically set to Null if Scale is Analytical, or to 150 uL if the Scale is Preparative.",
			AllowNull->True,
			Category->"Collection",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Microliter,450*Microliter],
				Units->Microliter
			]
		},
		FuntopiaSharedOptions,
		SubprotocolDescriptionOption,
		SamplesInStorageOption,
		SamplesOutStorageOption
	}
];

(* - Messages - *)
Error::InvalidAgaroseLoadingDye="The following supplied LoadingDyes, `1`, are either Objects with no Model, or are not one of the accepted Models in AgaroseLoadingDyeP. Please consult this pattern for the acceptable LoadingDye Models, or consider letting the LoadingDye option automatically resolve.";
Error::TooManyAgaroseInputs="The number of input samples, `1` times the NumberOfReplicates option, `2`, is too large for the Scale option, `3`. The maximum number of wells is 40 when Scale is Preparative, and 92 when Scale is Analytical. Consider choosing fewer input samples, or reducing the NumberOfReplicates.";
Error::MoreThanOneAgaroseGelModel="The Objects of the supplied Gel option, `1`, have the following Models, `2`. All Gels must be of the same Model. Please ensure that the supplied Gel Objects are of the same Model.";
Error::InvalidNumberOfAgaroseGels="The number of input samples, `1`, is not compatible with the Gel option, `2`. Given the number of Gel Objects specified, a minimum of `3` and a maximum of `4` samples can be run.";
Error::DuplicateAgaroseGelObjects="The Gel option, `1`, contains duplicate Objects. If the Gel option is specified as a list of Objects, each Object must be unique.";
Error::TooManyAgaroseLoadingDyes="The following input samples, `1`, have more than two associated LoadingDyes specified. A maximum of two LoadingDyes can be specified per input sample. Please consider reducing the number of LoadingDyes, or letting the LoadingDye option automatically resolve.";
Warning::OnlyOneAgaroseLoadingDye="The following input samples, `1`, have only one associated LoadingDye specified. Sizing is most accurate when each SampleIn has two associated LoadingDyes whose oligomer lengths flank the target strand of interest. Please consider specifying an additional LoadingDye for this input, or letting the LoadingDye option automatically resolve.";
Error::NotEnoughAgaroseSampleToLoad="The sum of the SampleVolume, LoadingDyeVolume, and LoadingDilutionBufferVolume, `1`, is smaller than the SampleLoadingVolume, `2`, for the following input samples, `3`. Please increase the LoadingDilutionBufferVolume, or consider letting these options automatically resolve.";
Error::ConflictingAgaroseCollectionSizeScaleOptions="The following input samples, `1` have CollectionSize options ,`2`, that are in conflict with the Scale option, `3`. If the Scale is Preparative, the CollectionSize must be set, if the Scale is Analytical, the CollectionSize option must be Null.";
Error::UnableToDetermineAgaroseCollectionSize="For the following input samples `1`, we are unable to determine the optimal CollectionSize. Please specify the CollectionSize option for this input.";
Error::UnableToDetermineAgarosePeakDetectionRange="For the following input samples, `1`, we are unable to determine the optimal PeakDetectionRange. Please specify the PeakDetectionRange option for this input.";
Error::UnableToDetermineAgaroseCollectionRange="For the following input samples, `1`, we are unable to determine the optimal CollectionRange. Please specify the CollectionRange option for this input.";
Error::ConflictingAgaroseAutomaticPeakDetectionScaleOptions="The following input samples, `1`, have AutomaticPeakDetection options, `2`, that are in conflict with the Scale option, `3`. If the Scale is Analytical, the AutomaticPeakDetection must be Null. If the Scale is Preparative, the AutomaticPeakDetection must be True or False.";
Error::ConflictingAgaroseAutomaticPeakDetectionRangeOptions="The following input samples, `1`, have AutomaticPeakDetection options, `2`, and PeakDetectionRange Options, `3`, that are in conflict. If AutomaticPeakDetection is True, the PeakDetectionRange cannot be Null. If AutomaticPeakDetection is False, the PeakDetectionRange must be Null.";
Error::ConflictingAgaroseAutomaticPeakDetectionCollectionRangeOptions="The following input samples, `1`, have AutomaticPeakDetection options, `2`, and CollectionRange options, `3`, that are in conflict. If AutomaticPeakDetection is True, the CollectionRange option must be Null.";
Error::ConflictingAgaroseAutomaticPeakDetectionCollectionSizeOptions="The following input samples, `1`, have AutomaticPeakDetection options, `2`, and CollectionSize options, `3`, that are in conflict. If AutomaticPeakDetection is True, the CollectionSize option must be Null.";
Error::ConflictingAgaroseCollectionSizeAndRangeOptions="The following input samples, `1`, have CollectionSize options, `2`, and CollectionRange options, `3`, that are in conflict. If the CollectionSize is specified as a non-Null value, The CollectionRange option must be Null.";
Error::ConflictingAgarosePeakDetectionRangeScaleOptions="The following input samples, `1`, have PeakDetectionRange options, `2`, that are in conflict with the Scale option, `3`. If the Scale is Analytical, the PeakDetectionRange must be Null.";
Error::ConflictingAgarosePeakDetectionRangeCollectionRangeOptions="The following input samples, `1`, have PeakDetectionRange options, `2`, and CollectionRange options, `3`, that are in conflict. If the PeakDetectionRange option is specified, the CollectionRange option must be Null.";
Error::ConflictingAgaroseCollectionRangeScaleOptions="The following input samples, `1`, have CollectionRange options, `2`, that are in conflict with the Scale option, `3`. If the Scale is Analytical, the CollectionRange option must be Null.";
Error::AgaroseCollectionSizeAndRangeBothNull="The following input samples, `1`, have AutomaticPeakDetection set to False, and both the CollectionSize and CollectionRange options set to Null. If AutomaticPeakDetection is False, either the CollectionSize or the CollectionRange must not be Null. For these inputs, please either set AutomaticPeakDetection to True, set the CollectionSize or CollectionRange to a non-Null value, or consider letting these options automatically resolve.";
Error::AgaroseSampleLoadingVolumeScaleMismatch="The Scale option, `1`, and the SampleLoadingVolume option, `2`, are in conflict. If Scale is Analytical, the SampleLoadingVolume must be no greater than 8 uL. If the Scale is Preparative, the SampleLoadingVolume must be no greater than 50 uL. Please lower the SampleLoadingVolume.";
Error::AgaroseLoadingDilutionBufferMismatch="The following input samples, `1`, have LoadingDilutionBuffer and LoadingDilutionBufferVolume options, `2`, that are in conflict. If LoadingDilutionBuffer is Null, the associated LoadingDilutionBufferVolume must be 0 uL. If LoadingDilutionBufferVolume is not 0 uL, the LoadingDilutionBuffer cannot be Null. Please consider allowing these options to automatically resolve.";
Error::AgaroseExtractionVolumeScaleMismatch="The Scale option, `1`, and the ExtractionVolume option, `2`, are in conflict. If the Scale is Analytical, the ExtractionVolume must be Null. If the Scale is Preparative, the ExtractionVolume cannot be Null. Please consider letting these otpions automatically resolve.";
Error::AgaroseGelOptionsMismatch="The Gel option, `1`, either has a GelMaterial that is not Agarose, and/or is in conflict with Scale option, `2`, or the AgarosePercentage option, `3`. The GelPercentage of the Gel must match the AgarosePercentage option, and the NumberOfLanes of the Gel must be 12 if Scale is Preparative, or 24 if Scale is Analytical. Please correct any mismatched options, or consider letting the Gel option resolve automatically.";
Error::InvalidAgaroseLadder="The Scale option, `1`, and the Ladder option, `2`, are in conflict. The Ladder must be Null if the Scale is Preparative, and must not be Null if the Scale is Analytical. Please consider letting these options automatically resolve.";
Error::InvalidAgaroseLadderFrequency="The Scale option, `1`, and the LadderFrequency option, `2`, are in conflict. The LadderFrequency must be Null if the Scale is Preparative, and must not be Null if the Scale is Analytical. Please consider letting these options automatically resolve.";
Error::InvalidAgarosePeakDetectionRange="The following input samples, `1`, have PeakDetectionRange options, `2`, that are invalid. The PeakDetectionRange cannot have the same value listed as the start and the end of the range. Please consider setting the CollectionSize option instead, or letting the PeakDetectionRange automatically resolve.";
Error::InvalidAgaroseCollectionRange="The following input samples, `1`, have CollectionRange options, `2`, that are invalid. The CollectionRange cannot have the same value listed as the start and the end of the range. Please consider setting the CollectionSize option instead, or letting the CollectionRange automatically resolve.";
Warning::AgaroseLoadingDyeRangeCollectionOptionMismatch="The following input samples, `1`, have collection-related Options, `2`, whose values, `3`, are not within the range of sizes of Oligomers in the corresponding LoadingDyes, `4`. Most accurate sizing and collection is achieved when the target of interest is between the size of the two LoadingDyes. Please consider specifying loading dyes whose sizes span the desired `2`:";
Warning::OverwriteLadderStorageCondition="A Ladder is not used in this experiment. There LadderStorageCondition is overwritten and set to Null.";

(* ::Subsubsection:: *)
(*ExperimentAgaroseGelElectrophoresis*)

(* Container and PreparatoryPrimitives overload *)
ExperimentAgaroseGelElectrophoresis[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions, outputSpecification, output, gatherTests, containerToSampleResult,containerToSampleOutput,
		containerToSampleTests, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
		samplePreparationCache, updatedCache,samples,sampleOptions,sampleCache
	},

	(* make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentAgaroseGelElectrophoresis,
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
			ExperimentAgaroseGelElectrophoresis,
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
				ExperimentAgaroseGelElectrophoresis,
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
		{samples,sampleOptions,sampleCache}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentAgaroseGelElectrophoresis[samples,ReplaceRule[sampleOptions,Cache->Flatten[updatedCache,sampleCache]]]
	]
];


(* Main sample overload *)
ExperimentAgaroseGelElectrophoresis[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions, listedSamples, outputSpecification, output, gatherTests, messages, safeOptions, safeOptionTests,validLengths, validLengthTests,templatedOptions,templateTests, inheritedOptions,
		expandedSafeOps,agaroseOptionsAssociation,suppliedInstrument,suppliedGel,suppliedLoadingDye,
		instrumentDownloadOption,instrumentDownloadFields,gelDownloadOption,gelDownloadFields,loadingDyesNoAutomatic,uniqueObjectLoadingDyes,uniqueModelLoadingDyes,objectSamplePacketFields,
		modelSamplePacketFields,objectContainerFields,modelContainerFields,modelContainerPacketFields,
		optionsWithObjects,userSpecifiedObjects,simulatedSampleQ,objectsExistQs,objectsExistTests,liquidHandlerContainers,
		listedSampleContainerPackets,instrumentPacket,gelPacket,inputsInOrder,listedLoadingDyeObjectPackets,listedLoadingDyeModelPackets,
		liquidHandlerContainerPackets,cacheBall,inputObjects,
		resolvedOptions,
		resolvedOptionsTests,resolvedOptionsResult,collapsedResolvedOptions,resourcePackets,resourcePacketTests,protocolObject,
		validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationCache,
		mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed, samplePreparationCacheNamed
	},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationCacheNamed} = simulateSamplePreparationPackets[
			ExperimentAgaroseGelElectrophoresis,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentAgaroseGelElectrophoresis, myOptionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentAgaroseGelElectrophoresis, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, {safeOptions, myOptionsWithPreparedSamples, samplePreparationCache}} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, {safeOptionsNamed, myOptionsWithPreparedSamplesNamed, samplePreparationCacheNamed}];

	(* If the specified options don't match their patterns or if the option lengths are invalid, return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* call ValidInputLengthsQ to make sure all the options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentAgaroseGelElectrophoresis, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentAgaroseGelElectrophoresis, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[Not[validLengths],
		Return[outputSpecification /.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests,validLengthTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentAgaroseGelElectrophoresis,{ToList[mySamplesWithPreparedSamples]},ToList[myOptionsWithPreparedSamples],Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentAgaroseGelElectrophoresis,{ToList[mySamplesWithPreparedSamples]},ToList[myOptionsWithPreparedSamples]],Null}
	];

	(* If couldn't apply the template, return $Failed (or the tests up to this point) *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests,validLengthTests, applyTemplateOptionTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOptions,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentAgaroseGelElectrophoresis,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Turn the expanded safe ops into an association so we can lookup information from it*)
	agaroseOptionsAssociation=Association[expandedSafeOps];

	(* Pull the info out of the options that we need to download from *)
	{
		suppliedInstrument,suppliedGel,suppliedLoadingDye
	}=Lookup[agaroseOptionsAssociation,
		{
			Instrument,Gel,LoadingDye
		}
	];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
	(* - Instrument - *)
	instrumentDownloadOption=If[
		(* Only downloading from the instrument option if it is not Automatic *)
		MatchQ[suppliedInstrument,Automatic],
		Nothing,
		suppliedInstrument
	];

	instrumentDownloadFields=Which[
		(* If instrument left as automatic, don't download anything *)
		MatchQ[suppliedInstrument,Automatic],
		Nothing,

		(* If instrument is an object, download fields from the Model *)
		MatchQ[suppliedInstrument,ObjectP[Object[Instrument]]],
		Packet[Model[{Object,WettedMaterials}]],

		(* If instrument is a Model, download fields*)
		MatchQ[suppliedInstrument,ObjectP[Model[Instrument]]],
		Packet[Object,WettedMaterials],

		True,
		Nothing
	];

	(* - Gel - *)
	gelDownloadOption=If[
		(* Only downloading from the gel option if it is not Automatic *)
		MatchQ[suppliedGel,Automatic],
		{Nothing},
		ToList[suppliedGel]
	];

	gelDownloadFields=Which[
		(* If instrument left as automatic, don't download anything *)
		MatchQ[suppliedGel,Automatic],
			Nothing,

		(* If Gel is an object, download fields from the Model *)
		MatchQ[suppliedGel,ObjectP[Object[Item,Gel]]],
			Packet[Model[{Object,GelPercentage,MaxWellVolume,NumberOfLanes,GelMaterial}]],

		(* If Gel is a Model, download fields*)
		MatchQ[suppliedGel,ObjectP[Model[Item,Gel]]],
			Packet[Object,GelPercentage,MaxWellVolume,NumberOfLanes,GelMaterial],

		(* If Gel is a list of objects, download fields from the Model *)
		MatchQ[suppliedGel,{ObjectP[Object[Item,Gel]]..}],
			Packet[Model[{Object,GelPercentage,MaxWellVolume,NumberOfLanes,GelMaterial}]],

		True,
			Nothing
	];

	(* - From the LoadingDye option, we need to download the Model (to check in the resolver if it is one of the acceptable Models - no other Models will work with the Instrument - *)
	(* First, Flatten the list of LoadingDye, and get rid of any Automatics *)
	loadingDyesNoAutomatic=Flatten[
		ToList[suppliedLoadingDye/.{Automatic->Nothing}]
	];

	(* We will download different fields from the Object and Model inputs, so find the unique Object and Model LoadingDyes *)
	uniqueObjectLoadingDyes=DeleteDuplicates[Cases[loadingDyesNoAutomatic,ObjectP[Object]]];
	uniqueModelLoadingDyes=DeleteDuplicates[Cases[loadingDyesNoAutomatic,ObjectP[Model]]];

	(* - Determine which fields we need to download from the input Objects - *)
	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,MolecularWeight,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerFields=SamplePreparationCacheFields[Object[Container]];
	modelContainerFields=SamplePreparationCacheFields[Model[Container]];
	modelContainerPacketFields=Packet@@Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];

	(* - Throw an error and return failed if any of the specified Objects are not members of the database - *)
	(* Any options whose values _could_ be an object *)
	optionsWithObjects = {
		Instrument,
		Ladder,
		Gel,
		LoadingDye,
		LoadingDilutionBuffer
	};

	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten@Join[ToList[mySamples],Lookup[ToList[myOptions],optionsWithObjects,Null]],
		ObjectP[]
	];

	(* Check that the specified objects exist or are visible to the current user *)
	 (*Quiet: throws extra errors when sample does not exist, which we will scream about later*)
	simulatedSampleQ = Lookup[Quiet[fetchPacketFromCache[#,samplePreparationCache]],Simulated,False]&/@userSpecifiedObjects;
	objectsExistQs = DatabaseMemberQ[PickList[userSpecifiedObjects,simulatedSampleQ,False]];

	(* Build tests for object existence *)
	objectsExistTests = If[gatherTests,
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
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests,templateTests,objectsExistTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* - All liquid handler compatible containers (for resources and Aliquot) - *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* - Big Download to make cacheBall and get the inputs in order by ID - *)
	{
		listedSampleContainerPackets,instrumentPacket,gelPacket,inputsInOrder,listedLoadingDyeObjectPackets,listedLoadingDyeModelPackets,
		liquidHandlerContainerPackets
	}=Quiet[
		Download[
			{
				(*Inputs*)
				ToList[mySamplesWithPreparedSamples],
				{instrumentDownloadOption},
				gelDownloadOption,
				ToList[mySamplesWithPreparedSamples],
				uniqueObjectLoadingDyes,
				uniqueModelLoadingDyes,
				liquidHandlerContainers
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Container[objectContainerFields]],
					Packet[Container[Model][modelContainerFields]],
					Packet[Composition[[All, 2]][{Object,Molecule,MolecularWeight}]],
					Packet[Analytes[{Object,Molecule,MolecularWeight}]]
				},
				{instrumentDownloadFields},
				{gelDownloadFields},
				{Packet[Object]},
				(* LoadingDye fields *)
				{Packet[Model[{Name}]]},
				{Packet[]},
				{modelContainerPacketFields}
			},
			Cache->Flatten[{Lookup[expandedSafeOps,Cache,{}],samplePreparationCache}],
			Date->Now
		],
		{Download::FieldDoesntExist}
	];


	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall=FlattenCachePackets[
		{
			samplePreparationCache,listedSampleContainerPackets,instrumentPacket,gelPacket,listedLoadingDyeObjectPackets,
			listedLoadingDyeModelPackets,liquidHandlerContainerPackets
		}
	];


	(* Get a list of the inputs by ID *)
	inputObjects=Lookup[Flatten[inputsInOrder],Object];

	(* --- Resolve the options! --- *)
	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveAgaroseGelElectrophoresisOptions[inputObjects,expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveAgaroseGelElectrophoresisOptions[inputObjects,expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentAgaroseGelElectrophoresis,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentAgaroseGelElectrophoresis,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		agaroseGelElectrophoresisResourcePackets[inputObjects,templatedOptions,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{agaroseGelElectrophoresisResourcePackets[inputObjects,templatedOptions,resolvedOptions,Cache->cacheBall],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentAgaroseGelElectrophoresis,collapsedResolvedOptions],
			Preview -> Null
		}]
	];


    (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
    protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
      UploadProtocol[
        resourcePackets,
        Upload->Lookup[safeOptions,Upload],
        Confirm->Lookup[safeOptions,Confirm],
        ParentProtocol->Lookup[safeOptions,ParentProtocol],
				Priority->Lookup[safeOptions,Priority],
				StartDate->Lookup[safeOptions,StartDate],
				HoldOrder->Lookup[safeOptions,HoldOrder],
				QueuePosition->Lookup[safeOptions,QueuePosition],
        ConstellationMessage->Object[Protocol,AgaroseGelElectrophoresis],
        Cache->samplePreparationCache
      ],
      $Failed
    ];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentAgaroseGelElectrophoresis,collapsedResolvedOptions],
		Preview -> Null
	}
];


(* ::Subsection::Closed:: *)
(* resolveAgaroseGelElectrophoresisOptions *)


DefineOptions[resolveAgaroseGelElectrophoresisOptions,
	Options :> {HelperOutputOption, CacheOption}
];

resolveAgaroseGelElectrophoresisOptions[mySamples:{ObjectP[Object[Sample]]..}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveAgaroseGelElectrophoresisOptions]]:=Module[
	{
		outputSpecification, output, gatherTests, messages, notInEngine, cache,samplePrepOptions,experimentOptions,simulatedSamples,resolvedSamplePrepOptions,simulatedCache,experimentOptionsAssociation,
		instrument,suppliedScale,suppliedAgarosePercentage,suppliedGel,suppliedLadder,suppliedLadderFrequency,numberOfReplicates,suppliedLoadingDye,suppliedLoadingDilutionBuffer,suppliedName,suppliedAutomaticPeakDetection,suppliedPeakDetectionRange,
		instrumentDownloadOption,instrumentDownloadFields,gelDownloadOption,gelDownloadFields,loadingDyesNoAutomatic,uniqueObjectLoadingDyes,uniqueModelLoadingDyes,listedSampleContainerPackets,instrumentPacket,gelPacket,
		listedLoadingDyeObjectPackets,listedLoadingDyeModelPackets,liquidHandlerContainerPackets,
		samplePackets,sampleContainerPackets,sampleCompositionPackets,sampleAnalytesPackets,gelOptionModel,suppliedGelPercentage,
		discardedSamplePackets,discardedInvalidInputs,discardedTests,
		optionPrecisions,roundedExperimentOptions,optionPrecisionTests,suppliedSampleVolume,suppliedLoadingDyeVolume,suppliedLoadingDilutionBufferVolume,
		suppliedCollectionSize,suppliedCollectionRange,suppliedSampleLoadingVolume,suppliedSeparationTime,suppliedDutyCycle,suppliedExtractionVolume,roundedExperimentOptionsList,
		allOptionsRounded,validNameQ,nameInvalidOption,validNameTest,allUniqueLoadingDyes,allUniqueLoadingDyeDownloads,modellessLoadingDyes,loadingDyesWithModels,
		allUniqueLoadingDyePackets,validModelLoadingDyes,invalidModelLoadingDyes,invalidLoadingDyes,invalidLoadingDyeModelOptions,invalidLoadingDyeTests,
		longestAnalyteOligomerLengths,sampleCompositionPacketsNoNull,compositionIDModels,compositionIDMolecules,sampleOligomerIDModels,sampleOligomerMolecules,
		sampleStructureOrStrandOligomerMolecules,sampleStrandLengths,longestCompositionAnalyteLengths,targetStrandLengths,averageTargetStrandLength,resolvedAgarosePercentage,
    resolvedScale,resolvedGel,resolvedLadder,resolvedLadderFrequency,objectSamplePacketFields,modelSamplePacketFields,modelContainerPacketFields,liquidHandlerContainers,
		resolvedDutyCycle,resolvedSeparationTime,resolvedExtractionVolume,resolvedSampleLoadingVolume,mapThreadFriendlyOptions,resolvedSampleVolume,resolvedLoadingDyeVolume,resolvedLoadingDye,
		resolvedLoadingDilutionBuffer,resolvedLoadingDilutionBufferVolume,resolvedAutomaticPeakDetection,resolvedCollectionSize,resolvedPeakDetectionRange,resolvedCollectionRange,onlyOneLoadingDyeWarnings,
		moreThanTwoLoadingDyesErrors,sampleLoadingVolumeTooLargeErrors,automaticPeakDetectionScaleMismatchErrors,automaticPeakDetectionRangeMismatchErrors,automaticPeakDetectionCollectionRangeMismatchErrors,
		automaticPeakDetectionCollectionSizeMismatchErrors,collectionScaleMismatchErrors,
		unableToDetermineCollectionSizeErrors,peakDetectionRangeScaleMismatchErrors,peakDetectionRangeCollectionRangeMismatchErrors,unableToDeterminePeakDetectionRangeErrors,
		unableToDetermineCollectionRangeErrors,collectionSizeAndRangeBothNullErrors,
		collectionRangeScaleMismatchErrors,collectionSizeCollectionRangeMismatchErrors,compatibleMaterialsBool,compatibleMaterialsTests,
		intNumberOfReplicates,numberOfSamples,totalNumberOfSamples,tooManyInvalidInputs,tooManyInputsTests,
		gelOptionModels,gelListQ,uniqueGelOptionModels,invalidMultipleGelObjectModelOptions,multipleGelObjectModelTests,
		invalidDuplicateGelOptions,duplicateGelObjectsTests,
		objectGelQ,numberOfGelObjects,numberOfSampleLanes,minimumSampleLanes,maximumSampleLanes,invalidNumberOfGelsOptions,invalidNumberOfGelsTests,
		moreThanTwoLoadingDyesErrorQ,failingMoreThanTwoLoadingDyesErrorSamples, passingMoreThanTwoLoadingDyesErrorSamples,invalidTooManyLoadingDyesOptions,
		moreThanTwoLoadingDyesTests,onlyOneLoadingDyeWarningQ,failingOnlyOneLoadingDyeWarningSamples,passingOnlyOneLoadingDyeWarningSamples,onlyOneLoadingDyeTests,
		totalSampleVolumes,sampleLoadingVolumeTooLargeErrorQ,failingSampleLoadingVolumeTooLargeSamples,
		passingSampleLoadingVolumeTooLargeSamples,failingSampleLoadingVolumeTooLargeVolumes,invalidSampleLoadingOptions,sampleLoadingVolumeTooLargeTests,collectionScaleMismatchErrorQ,
		failingCollectionScaleMismatchSamples,passingCollectionScaleMismatchSamples,failingCollectionSizes,invalidCollectionScaleMismatchOptions,
		collectionScaleMismatchTests,unableToDetermineCollectionSizeErrorQ,failingUnableToDetermineCollectionSizeSamples,passingUnableToDetermineCollectionSizeSamples,
		invalidUnableToDetermineCollectionOptions,unableToDetermineCollectionSizeTests,automaticPeakDetectionScaleMismatchErrorQ,failingAutomaticPeakDetectionScaleSamples,
		passingAutomaticPeakDetectionScaleSamples,failingScaleMismatchAutomaticPeakDetections,invalidAPDScaleMismatchOptions,automaticPeakDetectionScaleMismatchTests,automaticPeakDetectionRangeMismatchErrorQ,
		failingAutomaticPeakDetectionRangeSamples,passingAutomaticPeakDetectionRangeSamples,failingPeakDetectionRangeMismatchAutomaticPeakDetections,failingAutomaticPeakDetectionMismatchDetectionWidths,
		invalidAPDPeakDetectionRangeMismatchOptions,automaticPeakDetectionRangeMismatchTests,automaticPeakDetectionCollectionRangeMismatchErrorQ,failingAutomaticPeakDetectionCollectionSamples,
		passingAutomaticPeakDetectionCollectionSamples,failingCollectionRangeMismatchAutomaticPeakDetections,failingAutomaticPeakDetectionMismatchCollectionRanges,invalidAPDCollectionRangeMismatchOptions,
		automaticPeakDetectionCollectionRangeMismatchTests,automaticPeakDetectionCollectionSizeMismatchErrorQ,failingAutomaticPeakDetectionCollectionSizeSamples,passingAutomaticPeakDetectionCollectionSizeSamples,
		failingCollectionSizeMismatchAutomaticPeakDetections,failingAutomaticPeakDetectionMismatchCollectionSizes,invalidAPDCollectionSizeMismatchOptions,automaticPeakDetectionCollectionSizeMismatchTests,
		collectionSizeCollectionRangeMismatchErrorQ,failingCollectionSizeCollectionRangeSamples,passingCollectionSizeCollectionRangeSamples,failingCollectionRangeMisMatchCollectionSizes,
		failingCollectionSizeMismatchCollectionRanges,invalidCollectionSizeRangeMismatchOptions,collectionSizeCollectionRangeMismatchTests,
		unableToDeterminePeakDetectionRangeErrorQ,failingUnableToDeterminePeakDetectionRangeSamples,passingUnableToDeterminePeakDetectionRangeSamples,invalidUnableToDeterminePeakDetectionRangeOptions,
		unableToDeterminePeakDetectionRangeTests,peakDetectionRangeScaleMismatchErrorQ,failingPeakDetectionRangeScaleSamples,passingPeakDetectionRangeScaleSamples,failingScaleMismatchPeakDetectionRanges,
		invalidPDWScaleMismatchOptions,peakDetectionRangeScaleMismatchTests,peakDetectionRangeCollectionRangeMismatchErrorQ,failingPeakDetectionRangeCollectionRangeSamples,
		passingPeakDetectionRangeCollectionRangeSamples,failingCollectionRangeMismatchPeakDetectionRanges,failingPeakDetectionRangeMismatchCollectionRanges,invalidPeakDetectionRangeCollectionMismatchOptions,
		peakDetectionRangeCollectionRangeMismatchTests,collectionRangeScaleMismatchErrorQ,failingCollectionRangeScaleMismatchSamples,passingCollectionRangeScaleMismatchSamples,failingScaleMismatchCollectionRanges,
		invalidCollectionRangeScaleMismatchOptions,collectionRangeScaleMismatchTests,unableToDetermineCollectionRangeErrorQ,failingUnableToDetermineCollectionRangeSamples,
		passingUnableToDetermineCollectionRangeSamples,invalidUnableToDetermineCollectionRangeOptions,unableToDetermineCollectionRangeTests,collectionSizeAndRangeBothNullErrorQ,
		failingCollectionSizeAndRangeBothNullSamples,passingCollectionSizeAndRangeBothNullSamples,invalidCollectionSizeAndRangeBothNullOptions,collectionSizeAndRangeBothNullTests,
		loadingVolumeScaleMismatchOptions,loadingVolumeScaleMismatchTests,loadingDilutionBufferOptionTuples,
		failingLoadingDilutionBufferOptionTuples,failingLoadingDilutionBufferOptionSamples,passingLoadingDilutionBufferOptionSamples,invalidLoadingDilutionBufferOptions,
		loadingDilutionBufferMismatchTests,invalidExtractionScaleMismatchOptions,extractionScaleMismatchTests,specifiedGelPercentage,specifiedGelMaterial,specifiedGelNumberOfLanes,
		invalidGelOptionMismatchOptions,gelOptionMismatchTests,invalidLadderOptions,ladderScaleMismatchTests,invalidLadderFrequencyOptions,
		ladderFrequencyScaleMismatchTests,nonNullResolvedPeakDetectionRanges,nonNullResolvedPeakDetectionRangeSamples,
		failingPatternPeakDetectionRanges,failingPatternPeakDetectionRangeSamples,passingPatternPeakDetectionRanges,passingPatternPeakDetectionRangeSamples,
		loadingDyeModelReplaceRules,loadingDyeLengthReplaceRules,loadingDyesByModelIDs,loadingDyesByLengths,twoLoadingDyeLengths,twoLoadingDyeOptions,twoLoadingDyeSamples,collectionOptions,
		collectionOptionValues,collectionOptionListedValues,twoLoadingDyeCollectionOptions,twoLoadingDyeCollectionOptionValues,twoLoadingDyeCollectionOptionListedValues,twoLoadingDyeRanges,listOfLoadingDyeCollectionOptionMismatchBools,
		failingLoadingDyeCollectionMismatchSamples,passingLoadingDyeCollectionMismatchSamples,failingLoadingDyeCollectionMismatchOptionNames,passingLoadingDyeCollectionMismatchOptionNames,
		failingLoadingDyeCollectionMismatchOptionValues,passingLoadingDyeCollectionMismatchOptionValues,failingLoadingDyeCollectionMismatchLoadingDyes,passingLoadingDyeCollectionMismatchLoadingDyes,
		loadingDyeCollectionMisMatchTests,invalidPDRPatternOptions,peakDetectionRangePatternTests,nonNullResolvedCollectionRanges,nonNullResolvedCollectionRangeSamples,failingPatternCollectionRanges,
		failingPatternCollectionRangeSamples,passingPatternCollectionRanges,passingPatternCollectionRangeSamples,invalidCollectionRangePatternOptions,collectionRangeRangePatternTests,
		loadingDyeObjectModels,unnecessaryLadderStorageConditionQ,ladderStorageConditionTest,specifiedSampleStorageCondition,validSampleStorageConditionQ,invalidStorageConditionOptions,invalidStorageConditionTest,
		invalidInputs,invalidOptions,requiredAliquotAmounts,liquidHandlerContainerModels,liquidHandlerContainerMaxVolumes,
		potentialAliquotContainers,simulatedSamplesContainerModels,requiredAliquotContainers,resolvedAliquotOptions,aliquotTests,
		resolvedPostProcessingOptions,email,resolvedOptions
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
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
	{simulatedSamples,resolvedSamplePrepOptions,simulatedCache}=resolveSamplePrepOptions[ExperimentAgaroseGelElectrophoresis,mySamples,samplePrepOptions,Cache->cache];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	experimentOptionsAssociation = Association[experimentOptions];

	(* --- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --- *)
	(* Pull out information from the non-quantity or number options that we might need - later, after rounding, we will Lookup the rounded options *)
	{
		instrument,suppliedScale,suppliedAgarosePercentage,suppliedGel,suppliedLadder,suppliedLadderFrequency, numberOfReplicates,suppliedLoadingDye,suppliedLoadingDilutionBuffer,suppliedName,suppliedAutomaticPeakDetection
	}=
     Lookup[experimentOptionsAssociation,
			 {
				 Instrument,Scale,AgarosePercentage,Gel,Ladder,LadderFrequency,NumberOfReplicates,LoadingDye,LoadingDilutionBuffer,Name,AutomaticPeakDetection
			 },
			 Null
	 ];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
	(* - Instrument - *)
	instrumentDownloadOption=If[
		(* Only downloading from the instrument option if it is not Automatic *)
		MatchQ[instrument,Automatic],
		Nothing,
		instrument
	];

	instrumentDownloadFields=Which[
		(* If instrument left as automatic, don't download anything *)
		MatchQ[instrument,Automatic],
		Nothing,

		(* If instrument is an object, download fields from the Model *)
		MatchQ[instrument,ObjectP[Object[Instrument]]],
		Packet[Model[{Object,WettedMaterials}]],

		(* If instrument is a Model, download fields*)
		MatchQ[instrument,ObjectP[Model[Instrument]]],
		Packet[Object,WettedMaterials],

		True,
		Nothing
	];

	(* - Gel - *)
	gelDownloadOption=If[
		(* Only downloading from the gel option if it is not Automatic *)
		MatchQ[suppliedGel,Automatic],
		{Nothing},
		ToList[suppliedGel]
	];

	gelDownloadFields=Which[
		(* If instrument left as automatic, don't download anything *)
		MatchQ[suppliedGel,Automatic],
			Nothing,

		(* If Gel is an object, download fields from the Model *)
		MatchQ[suppliedGel,ObjectP[Object[Item,Gel]]],
			Packet[Model[{Object,GelPercentage,MaxWellVolume,NumberOfLanes,GelMaterial}]],

		(* If Gel is a Model, download fields*)
		MatchQ[suppliedGel,ObjectP[Model[Item,Gel]]],
			Packet[Object,GelPercentage,MaxWellVolume,NumberOfLanes,GelMaterial],

		(* If Gel is a list of objects, download fields from the Model *)
		MatchQ[suppliedGel,{ObjectP[Object[Item,Gel]]..}],
			Packet[Model[{Object,GelPercentage,MaxWellVolume,NumberOfLanes,GelMaterial}]],

		True,
			Nothing
	];

	(* - From the LoadingDye option, we need to download the Model (to check in the resolver if it is one of the acceptable Models - no other Models will work with the Instrument - *)
	(* First, Flatten the list of LoadingDye, and get rid of any Automatics *)
	loadingDyesNoAutomatic=Flatten[
		ToList[suppliedLoadingDye/.{Automatic->Nothing}]
	];

	(* We will download different fields from the Object and Model inputs, so find the unique Object and Model LoadingDyes *)
	uniqueObjectLoadingDyes=DeleteDuplicates[Cases[loadingDyesNoAutomatic,ObjectP[Object]]];
	uniqueModelLoadingDyes=DeleteDuplicates[Cases[loadingDyesNoAutomatic,ObjectP[Model]]];

	(* - Determine which fields we need to download from the input Objects - *)
	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
	modelContainerPacketFields=Packet@@Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];

	(* - All liquid handler compatible containers (for resources and Aliquot) - *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];


	(* --- Assemble Download --- *)
	{
		listedSampleContainerPackets,instrumentPacket,gelPacket,listedLoadingDyeObjectPackets,listedLoadingDyeModelPackets,
		liquidHandlerContainerPackets
	}=Quiet[
		Download[
			{
				(*Inputs*)
				simulatedSamples,
				{instrumentDownloadOption},
				gelDownloadOption,
				uniqueObjectLoadingDyes,
				uniqueModelLoadingDyes,
				liquidHandlerContainers
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Container[{Model, Contents, Name, Status, Sterile, TareWeight,StorageCondition, RequestedResources}]],
					Packet[Composition[[All, 2]][{Object,Molecule,MolecularWeight}]],
					Packet[Analytes[{Object,Molecule,MolecularWeight}]]
				},
				{instrumentDownloadFields},
				{gelDownloadFields},
				(* LoadingDye fields *)
				{Packet[Model[{Name}]]},
				{Packet[]},
				{modelContainerPacketFields}

			},
			Cache->simulatedCache,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* --- Extract out the packets from the download --- *)
	(* -- Sample Packets -- *)
	samplePackets=listedSampleContainerPackets[[All,1]];
	sampleContainerPackets=listedSampleContainerPackets[[All,3]];
	sampleCompositionPackets=listedSampleContainerPackets[[All,4]];
	sampleAnalytesPackets=listedSampleContainerPackets[[All,5]];

  (* - Gel Packets - *)
	(* Get the Model of the supplied Gel *)
  gelOptionModel=If[MatchQ[gelPacket,{}],
    Automatic,
    First[Lookup[First[gelPacket],Object]]
  ];

	(* Get the GelPercentage of the supplied Gel *)
	suppliedGelPercentage=If[MatchQ[gelPacket,{}],
		Automatic,
		First[Lookup[First[gelPacket],GelPercentage]]
	];

	(* --- INPUT VALIDATION CHECKS --- *)
	(* Get the samples from simulatedSamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs= If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
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

	(* -- OPTION PRECISION CHECKS -- *)
	(* First, define the option precisions that need to be checked for AgaroseGelElectrophoresis *)
	optionPrecisions={
		{SampleVolume,10^-1*Microliter},
		{LoadingDyeVolume,10^-1*Microliter},
		{LoadingDilutionBufferVolume,10^-1*Microliter},
		{SampleLoadingVolume,10^-1*Microliter},
		{SeparationTime,10^0*Second},
		{DutyCycle,10^0*Percent},
		{ExtractionVolume,10^0*Microliter}
	};

	(* Verify that the experiment options are not overly precise *)
	{roundedExperimentOptions,optionPrecisionTests}=If[gatherTests,

		(*If we are gathering tests *)
		RoundOptionPrecision[experimentOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],

		(* Otherwise *)
		{RoundOptionPrecision[experimentOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
	];

	(* For option resolution below, Lookup the options that can be quantities or numbers from roundedExperimentOptions *)
	{
		suppliedSampleVolume,suppliedLoadingDyeVolume,suppliedLoadingDilutionBufferVolume,suppliedCollectionSize,suppliedCollectionRange,suppliedSampleLoadingVolume,suppliedSeparationTime,
		suppliedDutyCycle,suppliedExtractionVolume,suppliedPeakDetectionRange
	}=
 		Lookup[
			roundedExperimentOptions,
			{
				SampleVolume,LoadingDyeVolume,LoadingDilutionBufferVolume,CollectionSize,CollectionRange,SampleLoadingVolume,SeparationTime,DutyCycle,ExtractionVolume,PeakDetectionRange
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

	(*-- CONFLICTING OPTIONS CHECKS --*)
	(* - Check that the protocol name is unique - *)
	validNameQ=If[MatchQ[suppliedName,_String],

		(* If the name was specified, make sure its not a duplicate name *)
		Not[DatabaseMemberQ[Object[Protocol,AgaroseGelElectrophoresis,suppliedName]]],

		(* Otherwise, its all good *)
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOption=If[!validNameQ&&messages,
		(
			Message[Error::DuplicateName,"AgaroseGelElectrophoresis protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[suppliedName,_String],
		Test["If specified, Name is not already an AgaroseGelElectrophoresis protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* -- Check to make sure that any of the supplied LoadingDyes are of acceptable Models -- *)
	(* Make a list of all of the LoadingDyes we downloaded information about above, and an index-matched list of the packets (or Null for Model-less Objects) that we downloaded *)
	allUniqueLoadingDyes=Flatten[Join[uniqueObjectLoadingDyes,uniqueModelLoadingDyes]];
	allUniqueLoadingDyeDownloads=Flatten[Join[listedLoadingDyeObjectPackets,listedLoadingDyeModelPackets]];

	(* Define a list of the LoadingDye Objects without Models (these will be invalid) *)
	modellessLoadingDyes=PickList[allUniqueLoadingDyes,allUniqueLoadingDyeDownloads,Null];

	(* Make a list of the unique LoadingDyes that are either Models or Objects with Models *)
	loadingDyesWithModels=PickList[allUniqueLoadingDyes,allUniqueLoadingDyeDownloads,Except[Null]];

	(* Create a list of the loadign dye download packets index matched to loadingDyesWithModels *)
	allUniqueLoadingDyePackets=Cases[allUniqueLoadingDyeDownloads,Except[Null]];

	(* From the list of loadingDyesWithModels, the valid ones are those whose corresponding Packet has an Object that is one of the acceptable loading dye models *)
	validModelLoadingDyes=PickList[loadingDyesWithModels,Lookup[allUniqueLoadingDyePackets,Object,{}],AgaroseLoadingDyeP];

	(* The not-valid loading dyes with Models are those whose Packet Object is not one of the acceptable loading dye models *)
	invalidModelLoadingDyes=Cases[loadingDyesWithModels,Except[Alternatives@@validModelLoadingDyes]];

	(* Make a list of all the invalid LoadingDyes - those Objects without Models, and those whose Model is not one of the accepted Models *)
	invalidLoadingDyes=Join[modellessLoadingDyes,invalidModelLoadingDyes];

	(* If there are any invalidLoadingDyes, set an invalidOption variable *)
	invalidLoadingDyeModelOptions=If[Length[invalidLoadingDyes]>0,
		{LoadingDye},
		{}
	];

	(* If there are any invalidLoadingDyes and we are throwing Messages, throw an Error *)
	If[Length[invalidLoadingDyeModelOptions]>0&&messages,
		Message[Error::InvalidAgaroseLoadingDye, ObjectToString[invalidLoadingDyes,Cache->simulatedCache]]
	];

	(* Define the tests the user will see for the above message *)
	invalidLoadingDyeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidLoadingDyes]==0,
				Nothing,
				Test["The following user-specified LoadingDyes, "<>ObjectToString[invalidLoadingDyes,Cache->simulatedCache]<>", are either Objects with no Model, or are not of an acceptable LoadingDye Model for ExperimentAgaroseGelElectrophoresis. Please consult the documentation for a list of acceptable LoadingDye Models, or consider letting the LoadingDye option resolve automatically:",True,False]
			];
			passingTest=If[Length[validModelLoadingDyes]==0,
				Nothing,
				Test["The following user-specified LoadingDyes, "<>ObjectToString[validModelLoadingDyes,Cache->simulatedCache]<>", are of an acceptable Model for ExperiemntAgaroseGelElectrophoresis:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

  (* ---- RESOLVE AUTOMATIC OPTIONS ---- *)
	(* -- Resolve non-index matched options -- *)
  (* - MASTER SWITCH - Resolve Scale - *)
  resolvedScale=Switch[{suppliedScale,gelOptionModel,suppliedLadder},

    (* If the user has set the Scale option, we accept it *)
    {Except[Automatic],_,_},
      suppliedScale,

    (* If the Scale option has been left as automatic, it resolves based on if the Gel option is an analytical or preparative gel *)
    {Automatic,AnalyticalAgaroseGelP,_}|{Automatic,_,Except[Automatic|Null]},
      Analytical,

    {Automatic,_,_},
      Preparative
  ];

  (* --- To resolve the AgarosePercentage, and the Preparative PeakDetection/Collection-related options in the MapThread, we need to get information about the Length of the Oligomers in the Analytes field and Composition fields of the SimulatedSamples --- *)
  (* Ideally we would just do this in the MapThread, but we need this information now to resolve the AgarosePercentage and thus Gel - will pass the result of all of this information and the info about Lengths of Oligos in the SimulatedSamples Composition field to the MapThread later on  *)
  (* -- Find the Length of the largest Oligomer present in the Analytes field of each input -- *)
  longestAnalyteOligomerLengths=Map[
    If[
      (* IF the Analytes field contains nothing for the sample *)
      MatchQ[#,{}],

      (* THEN set the length to Null for this sample *)
      Null,

      (* ELSE we need to figure out which the longest oligomer  *)
      Module[
        {
          analyteIDModels,analyteIDModelMolecules,analyteOligomerIDModels,analytesOligomerMolecules,structureOrStrandOligomerMolecules,analyteStrandLengths,longestAnalyteOligomerLength
        },

        (* Get the Objects of the ID Models *)
        analyteIDModels=Lookup[#,Object];

        (* Get the Molecules of the ID Models *)
        analyteIDModelMolecules=Lookup[#,Molecule];

        (* Make a list of the analyteIDModelObjects that are of Type Model[Molecule,Oligomer] *)
        analyteOligomerIDModels=Cases[analyteIDModels,ObjectP[Model[Molecule,Oligomer]]];

        (* Get a list of the Molecules that correspond to the Model[Molecule,Oligomer]s present in the Analytes field for this sample *)
        analytesOligomerMolecules=PickList[analyteIDModelMolecules,analyteIDModels,ObjectP[analyteOligomerIDModels]];

        (* Of these Oligomer Molecules, only keep the ones that are Strands or Structures *)
        structureOrStrandOligomerMolecules=Cases[analytesOligomerMolecules,Alternatives[_Structure,_Strand]];

        (* Calculate the Length of the Strands for each of the structureOrStrandOligomerMolecules (in the case of Structures with more than one Strand, we take the Mean) *)
        analyteStrandLengths=Flatten[
          Map[
            Function[{molecule},
              (Mean[ToList[StrandLength[molecule]]])
            ],
            ToStrand[structureOrStrandOligomerMolecules]
          ]
        ];

        (* Take the Largest of these analyteStrandLengths, or return Null if the List is empty *)
        longestAnalyteOligomerLength=If[MatchQ[analyteStrandLengths,{}],
          Null,
          Last[Sort[analyteStrandLengths]]
        ];

        (* Return the Length of the longest Oligomer present in the Analytes field of the Sample *)
        longestAnalyteOligomerLength
      ]
    ]&,
    sampleAnalytesPackets
  ];

  (* -- Find the Length of the largest Oligomer present in the Composition field of each input -- *)
	(* Very similar logic used in parseAgaroseGelElectrophoresis *)
	(* - First, get rid of any Nulls present in the sampleCompositionPackets - *)
	sampleCompositionPacketsNoNull=Cases[#,PacketP[]]&/@sampleCompositionPackets;

	(* - From this list of list of Packets, Lookup the Object and the Molecule of each Packet - *)
	compositionIDModels=Lookup[#,Object]&/@sampleCompositionPacketsNoNull;
	compositionIDMolecules=Lookup[#,Molecule]&/@sampleCompositionPacketsNoNull;

	(* Get a list of all of the ID Models that are Oligomers for the input samples *)
	sampleOligomerIDModels=Cases[#,ObjectP[Model[Molecule,Oligomer]]]&/@compositionIDModels;

	(* Get the corresponding Molecules of the sampleOligomerIDModels *)
	sampleOligomerMolecules=MapThread[
		PickList[#1,#2,ObjectP[#3]]&,
		{compositionIDMolecules,compositionIDModels,sampleOligomerIDModels}
	];

	(* Of all of these Oligomer Molecules, keep the ones that are Strands or Structures *)
	sampleStructureOrStrandOligomerMolecules=Map[
		Cases[#,Alternatives[_Structure,_Strand]]&,
		sampleOligomerMolecules
	];

	(* Calculate the Length of the Strands for each of the sampleStructureOrStrandOligomerMolecules *)
	sampleStrandLengths=Map[
		Function[{molecules},
			Flatten[
				Map[
					(Mean[ToList[StrandLength[#]]])&,
					ToStrand[molecules]
				]
			]
		],
		sampleStructureOrStrandOligomerMolecules
	];

	(* - Make a list of the Length of each sample's longest Oligomer ID Model (or Null if there are no Oligomer ID Models with Strand or Structure Molecules - *)
	longestCompositionAnalyteLengths=Map[
		If[MatchQ[#,{}],
			Null,
			Last[Sort[#]]
		]&,
		sampleStrandLengths
	];

	(* -- Make a list of the Lengths of the target strands, from the Analyte if it exists, or from the Composition of SamplesIn if not - will pass this to MapThread later -- *)
	targetStrandLengths=MapThread[
		If[MatchQ[#1,Null],
			#2,
			#1
		]&,
		{longestAnalyteOligomerLengths,longestCompositionAnalyteLengths}
	];

	(* - Take the average of the non-Null values in targetStrandLengths.  If the list only contains Null set the average to 0 - *)
	averageTargetStrandLength=If[
		MatchQ[targetStrandLengths,{Null..}],
		0,
		SafeRound[Mean[Cases[targetStrandLengths,Except[Null]]],10^0]
	];

	(* --- Back to Resolving non-index matched options ---*)
	(* - Resolve the AgarosePercentage - *)
	resolvedAgarosePercentage=Switch[{suppliedAgarosePercentage,suppliedGelPercentage,averageTargetStrandLength},

		(* If the user has supplied the AgarosePercentage, we accept it *)
		{Except[Automatic],_,_},
			suppliedAgarosePercentage,

		(* - Cases where the AgarosePercentage is Automatic - *)
		(* If the user has not supplied the AgarosePercentage, but has supplied the Gel option, resolve the AgarosePercentage based on the GelPercentage of the Gel *)
		(* Cases where the GelPercentage is one of the accepted AgarosePercentages *)
		{Automatic,0.5*Percent,_},
			0.5*Percent,
		{Automatic,1.*Percent,_},
			1*Percent,
		{Automatic,1.5*Percent,_},
			1.5*Percent,
		{Automatic,2.*Percent,_},
			2*Percent,
		{Automatic,3.*Percent,_},
			3*Percent,

		(* Case where the GelPercentage is not one of the accepted AgarosePercentages - resolve to 1*Percent, we will be throwing an error later anyways *)
		{Automatic,Except[Automatic],_},
			1*Percent,

		(* - Cases where both the AgarosePercentage and the Gel are Automatic - Resolve based on the averageTargetStrandLength - *)
		(* Generally we want to resolve to the lower-percentage gel when possible ranges are overalpping, because we want the target band to run closer to the smaller marker than the larger (to make the run not excessively long) - *)
		{Automatic,Automatic,RangeP[1,199]},
			3*Percent,
		{Automatic,Automatic,RangeP[200,399]},
			2*Percent,
		{Automatic,Automatic,RangeP[400,1249]},
			1.5*Percent,
		{Automatic,Automatic,RangeP[1250,3999]},
			1*Percent,
		{Automatic,Automatic,GreaterP[3999]},
			0.5*Percent,

		(* Case where there are no Oligomer IDMolecules in the Composition field of any of the input Samples, and any other case *)
		{_,_,_},
			1*Percent
	];

  (* - Resolve Gel - *)
  resolvedGel=Switch[{suppliedGel,resolvedScale,resolvedAgarosePercentage},

    (* If the user has supplied the Gel option, we accept it *)
    {Except[Automatic],_,_},
      suppliedGel,

    (* Otherwise, resolves based on the Scale and Agarose percentage as seen in the documentation *)
    {Automatic,Analytical,0.5*Percent},
      Model[Item, Gel, "Analytical 0.5% agarose cassette, 24 channel"],
    {Automatic,Analytical,1*Percent},
      Model[Item, Gel, "Analytical 1.0% agarose cassette, 24 channel"],
    {Automatic,Analytical,1.5*Percent},
      Model[Item, Gel, "Analytical 1.5% agarose cassette, 24 channel"],
    {Automatic,Analytical,2*Percent},
      Model[Item, Gel, "Analytical 2.0% agarose cassette, 24 channel"],
    {Automatic,Analytical,3*Percent},
      Model[Item, Gel, "Analytical 3.0% agarose cassette, 24 channel"],
    {Automatic,Preparative,0.5*Percent},
      Model[Item, Gel, "Size Selection 0.5% agarose cassette, 12 channel"],
    {Automatic,Preparative,1*Percent},
      Model[Item, Gel, "Size Selection 1.0% agarose cassette, 12 channel"],
    {Automatic,Preparative,1.5*Percent},
      Model[Item, Gel, "Size Selection 1.5% agarose cassette, 12 channel"],
    {Automatic,Preparative,2*Percent},
      Model[Item, Gel, "Size Selection 2.0% agarose cassette, 12 channel"],
    {Automatic,Preparative,3*Percent},
      Model[Item, Gel, "Size Selection 3.0% agarose cassette, 12 channel"],

    (* If for some crazy reason the above combinations are not all of the combinations (they for sure are / should be), resolve to the appropriate 1% agarose gel based on the scale *)
    {_,Analytical,_},
      Model[Item, Gel, "Analytical 1.0% agarose cassette, 24 channel"],
    {_,Preparative,_},
      Model[Item, Gel, "Size Selection 1.0% agarose cassette, 12 channel"]
  ];

  (* - Resolve Ladder - *)
  resolvedLadder=Switch[{suppliedLadder,resolvedAgarosePercentage,resolvedScale},

    (* If the user has supplied the Ladder option, we accept it *)
    {Except[Automatic],_,_},
      suppliedLadder,

		(* If the Scale is Preparative, we set the Ladder option to Null *)
		{Automatic,_,Preparative},
			Null,

    (* Otherwise, we resolve the Ladder based on the AgarosePercentage option *)
    {Automatic,0.5*Percent,_},
      Model[Sample, StockSolution, Standard, "GeneRuler dsDNA 10000-50000 bp, 8 bands, 50 ng/uL"],
    {Automatic,Alternatives[1*Percent,1.5*Percent],_},
      Model[Sample, StockSolution, Standard, "GeneRuler dsDNA 75-20000 bp, 15 bands, 50 ng/uL"],
    {Automatic,2*Percent,_},
      Model[Sample, StockSolution, Standard, "GeneRuler dsDNA 25-700 bp, 10 bands, 50 ng/uL"],
    {Automatic,3*Percent,_},
      Model[Sample, StockSolution, Standard, "GeneRuler dsDNA 10-300 bp, 11 bands, 50 ng/uL"]
  ];

	(* Error checking: LadderStorageCondition should not be specified if Ladder resolves to Null *)
	unnecessaryLadderStorageConditionQ=If[MatchQ[resolvedLadder,{}|Null|{Null}],
		If[MatchQ[Lookup[roundedExperimentOptions,LadderStorageCondition],Except[{}|Null|{Null}]],
			True,
			False
		],
		False
	];

	(* Throw warning messages based on the value of unnecessaryLadderStorageConditionQ *)
	If[unnecessaryLadderStorageConditionQ&&messages,
		Message[Warning::OverwriteLadderStorageCondition],
		Nothing
	];

	ladderStorageConditionTest=If[gatherTests,
		Warning["If Ladder is not used in a particular run, LadderStorageCondition is not set to anything other than Null:",!unnecessaryLadderStorageConditionQ,True],
		Nothing
	];

	(* - Resolve Ladder Frequency- *)
	resolvedLadderFrequency=Switch[{suppliedLadderFrequency,resolvedScale},

		(* If the user has supplied the LadderFrequency option, we accept it *)
		{Except[Automatic],_},
		suppliedLadderFrequency,

		(* If the Scale is Preparative, we set the LadderFrequency option to Null *)
		{Automatic,Preparative},
		Null,

		(* Otherwise, we resolve the LadderFrequency to First and Last *)
		{Automatic,_},
		FirstAndLast
	];

  (* - Resolve DutyCycle - *)
  resolvedDutyCycle=Switch[{suppliedDutyCycle,resolvedAgarosePercentage},

    (* If the user has supplied the DutyCycle option, we accept it *)
    {Except[Automatic],_},
      suppliedDutyCycle,

    (* Otherwise, we resolve the option based on the AgarosePercentage *)
    {Automatic,0.5*Percent},
      35*Percent,
    {Automatic,Alternatives[1*Percent,1.5*Percent]},
      50*Percent,
    {Automatic,Alternatives[2*Percent,3*Percent]},
      100*Percent
  ];

  (* - Resolve SeparationTime - *)
	resolvedSeparationTime=Switch[{suppliedSeparationTime,resolvedScale},

		(* If the user has supplied the SeparationTime option, we accept it *)
		{Except[Automatic],_},
			suppliedSeparationTime,

		(* Otherwise, we resolve based on the Scale *)
		{Automatic,Preparative},
			5000*Second,
		{Automatic,Analytical},
			2500*Second
	];

	(* - Resolve ExtractionVolume - *)
	resolvedExtractionVolume=Switch[{suppliedExtractionVolume,resolvedScale},

		(* If the user has supplied the ExtractionVolume option, we accept it *)
		{Except[Automatic],_},
			suppliedExtractionVolume,

		(* Otherwise, resolve the option based on the Scale and AgarosePercentage options  *)
		(* If Scale is Analytical, ExtractionVolume must be Null *)
		{Automatic,Analytical},
			Null,

		(* If Scale is Preparative, the ExtractionVolume depends on the AgarosePercentage *)
		{Automatic,Preparative},
			150*Microliter
	];

	(* - Resolve SampleLoadingVolume - *)
	resolvedSampleLoadingVolume=Switch[{suppliedSampleLoadingVolume,resolvedScale},

		(* If the user has supplied the SampleLoadingVolume option, we accept it *)
		{Except[Automatic],_},
		suppliedSampleLoadingVolume,

		(* Otherwise, the SampleLoadingVolume is determined by the Scale option *)
		{Automatic,Analytical},
			8*Microliter,
		{Automatic,Preparative},
			50*Microliter
	];

	(* -- Resolve index-matched options -- *)
	(* Convert our options into a MapThread friendly version. so we can do our big MapThread *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentAgaroseGelElectrophoresis,roundedExperimentOptions];

	(* Big MapThread *)
	{
		resolvedSampleVolume,resolvedLoadingDyeVolume,resolvedLoadingDye,resolvedLoadingDilutionBuffer,resolvedLoadingDilutionBufferVolume,resolvedAutomaticPeakDetection,resolvedCollectionSize,
		resolvedPeakDetectionRange,resolvedCollectionRange,onlyOneLoadingDyeWarnings,moreThanTwoLoadingDyesErrors,sampleLoadingVolumeTooLargeErrors,automaticPeakDetectionScaleMismatchErrors,automaticPeakDetectionRangeMismatchErrors,
		automaticPeakDetectionCollectionRangeMismatchErrors,automaticPeakDetectionCollectionSizeMismatchErrors,collectionScaleMismatchErrors,unableToDetermineCollectionSizeErrors,peakDetectionRangeScaleMismatchErrors,
		peakDetectionRangeCollectionRangeMismatchErrors,unableToDeterminePeakDetectionRangeErrors,collectionRangeScaleMismatchErrors,collectionSizeCollectionRangeMismatchErrors,
		unableToDetermineCollectionRangeErrors,collectionSizeAndRangeBothNullErrors
	}=Transpose[MapThread[
		Function[{options,targetStrandLength},
			Module[
				{
					sampleVolume,loadingDyeVolume,loadingDye,loadingDilutionBuffer,loadingDilutionBufferVolume,automaticPeakDetection,collectionSize,peakDetectionRange,collectionRange,onlyOneLoadingDyeWarning,
					moreThanTwoLoadingDyesError,sampleLoadingVolumeTooLargeError,automaticPeakDetectionScaleMismatchError,automaticPeakDetectionRangeMismatchError,automaticPeakDetectionCollectionRangeMismatchError,
					automaticPeakDetectionCollectionSizeMismatchError,collectionScaleMismatchError,unableToDetermineCollectionSizeError,peakDetectionRangeScaleMismatchError,
					peakDetectionRangeCollectionRangeMismatchError,unableToDeterminePeakDetectionRangeError,collectionRangeScaleMismatchError,collectionSizeCollectionRangeMismatchError,
					unableToDetermineCollectionRangeError,collectionSizeAndRangeBothNullError,initialSampleVolume,initialLoadingDyeVolume,initialLoadingDye,
					initialLoadingDilutionBuffer,initialLoadingDilutionBufferVolume,initialAutomaticPeakDetection,initialCollectionSize,initialPeakDetectionRange,initialCollectionRange,preLoadingDilutionBufferVolume,
					minTargetVolume,loadingDyeLength
				},

				(* Set up error tracking variables *)
				{
					onlyOneLoadingDyeWarning,moreThanTwoLoadingDyesError,sampleLoadingVolumeTooLargeError,automaticPeakDetectionScaleMismatchError,automaticPeakDetectionRangeMismatchError,automaticPeakDetectionCollectionRangeMismatchError,
					automaticPeakDetectionCollectionSizeMismatchError,collectionScaleMismatchError,unableToDetermineCollectionSizeError,peakDetectionRangeScaleMismatchError,peakDetectionRangeCollectionRangeMismatchError,
					unableToDeterminePeakDetectionRangeError,collectionRangeScaleMismatchError,collectionSizeCollectionRangeMismatchError,unableToDetermineCollectionRangeError,collectionSizeAndRangeBothNullError
				}=ConstantArray[False,16];

				(* Lookup the initial values of the options *)
				{
					initialSampleVolume,initialLoadingDyeVolume,initialLoadingDye,initialLoadingDilutionBuffer,initialLoadingDilutionBufferVolume,initialAutomaticPeakDetection,initialCollectionSize,initialPeakDetectionRange,
					initialCollectionRange
				}=
        	Lookup[options,
						{
							SampleVolume,LoadingDyeVolume,LoadingDye,LoadingDilutionBuffer,LoadingDilutionBufferVolume,AutomaticPeakDetection,CollectionSize,PeakDetectionRange,CollectionRange
						}
				];

				(* - Resolve the SampleVolume - *)
				sampleVolume=Switch[{initialSampleVolume,resolvedScale},

					(* If the user has specified the SampleVolume option, we accept it *)
					{Except[Automatic],_},
						initialSampleVolume,

					(* Otherwise, we resolve the option based on the Scale option *)
					{Automatic,Preparative},
						45*Microliter,
					{Automatic,Analytical},
						10*Microliter
				];

				(* - Resolve the LoadingDyeVolume - *)
				loadingDyeVolume=Switch[{initialLoadingDyeVolume,resolvedScale},

					(* If the user has specified the LoadingDyeVolume option, we accept it *)
					{Except[Automatic],_},
						initialLoadingDyeVolume,

					(* Otherwise, we resolve the option based on the Scale option *)
					{Automatic,Preparative},
						5*Microliter,
					{Automatic,Analytical},
						1.3*Microliter
				];

				(* Define the Length of the loading dye option  *)
				loadingDyeLength=If[

					(* IF the LoadingDye option has been left as Automatic *)
					MatchQ[initialLoadingDye,Automatic],

					(* THEN we will resolve it to 2 loading dyes *)
					2,

					(* ELSE check the Length of the LoadingDye *)
					Length[initialLoadingDye]
				];

				(* - Resolve LoadingDye - maybe in future will need to change the warnings based on Scale - *)
				{loadingDye,moreThanTwoLoadingDyesError,onlyOneLoadingDyeWarning}=Switch[{initialLoadingDye,resolvedAgarosePercentage,loadingDyeLength},

					(* - If the user has specified the LoadingDye option, we accept it, but may need to throw an error message if there are more than 2 LoadingDyes specified- *)
					(* Throw an Error if there are more than two LoadingDyes  *)
					{Except[Automatic],_,GreaterP[2]},
						{initialLoadingDye,True,False},
					{Except[Automatic],_,1},
						{initialLoadingDye,False,True},
					{Except[Automatic],_,_},
						{initialLoadingDye,False,False},

					(* Otherwise, we resolve the LoadingDye option based on the AgarosePercentage, and no messages will need to be thrown - the table explaining the resolution is in the documentation *)
					{Automatic,3*Percent,_},
						{{Model[Sample, "100 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "500 bp dyed loading buffer for agarose gel electrophoresis"]},False,False},
					{Automatic,2*Percent,_},
						{{Model[Sample, "200 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "2000 bp dyed loading buffer for agarose gel electrophoresis"]},False,False},
					{Automatic,1.5*Percent,_},
						{{Model[Sample, "300 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "3000 bp dyed loading buffer for agarose gel electrophoresis"]},False,False},
					{Automatic,1*Percent,_},
						{{Model[Sample, "1000 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "10000 bp dyed loading buffer for agarose gel electrophoresis"]},False,False},
					{Automatic,0.5*Percent,_},
						{{Model[Sample, "3000 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "10000 bp dyed loading buffer for agarose gel electrophoresis"]},False,False}
				];


				(* - Resolve LoadingDilutionBuffer - *)
				(* Define a variable that is the sum of the SampleVolume and the LoadingDyeVolume *)
				preLoadingDilutionBufferVolume=(sampleVolume+(loadingDyeVolume*2));

				(* Set a variable that is the target minimum total volume of sample and loading dyes for each scale (determines if we need LoadingdilutionBuffer or not) *)
				minTargetVolume=If[
					MatchQ[resolvedScale,Analytical],
					10*Microliter,
					55*Microliter
				];

				(* Resolve the option *)
				loadingDilutionBuffer=Which[

					(* If the user has specified the LoadingDilutionBuffer option, we accept it *)
					MatchQ[initialLoadingDilutionBuffer,Except[Automatic]],
						initialLoadingDilutionBuffer,

					(* If the user has set the LoadingDilutionBufferVolume to a non-zero volume, we set the LoadingDilutionBuffer to the default TE Buffer *)
					MatchQ[initialLoadingDilutionBufferVolume,Except[Alternatives[Automatic,0*Microliter]]],
						Model[Sample, StockSolution, "1x TE Buffer"],

					(* If the sum of the sampleVolume and the loadingDyeVolume times two is equal to or larger than the 10uL when Scale is Analytical or 60 uL when Scale is Preparative, we set the loadingDilutionBuffer to Null *)
					MatchQ[preLoadingDilutionBufferVolume,GreaterEqualP[minTargetVolume]],
						Null,

					(* Otherwise, we need some more volume, so we have to set the LoadingDilutionBuffer *)
					True,
						Model[Sample, StockSolution, "1x TE Buffer"]
				];

				(* - Resolve the LoadingDilutionBufferVolume - *)
				loadingDilutionBufferVolume=Which[

					(* If the user has specified the LoadingDilutionBufferVolume option, we accept it *)
					MatchQ[initialLoadingDilutionBufferVolume,Except[Automatic]],
						initialLoadingDilutionBufferVolume,

					(* If the LoadingDilutionBuffer was set to or has resolved to Null, we set the LoadingDilutionBufferVolume to 0*Microliter *)
					MatchQ[loadingDilutionBuffer,Null],
						0*Microliter,

					(* If the sum of the sampleVolume and the loadingDyeVolume times number of LoadingDyes is equal to or larger than the resolvedSampleLoadingVolume, we set the loadingDilutionBufferVolume to 0*Microliter *)
					MatchQ[preLoadingDilutionBufferVolume,GreaterEqualP[minTargetVolume]],
						0*Microliter,

					(* Otherwise, we calculated the required remaining volume based on the preLoadingDilutionBufferVolume and the resolvedSampleLoadingVolume *)
					True,
						Max[RoundOptionPrecision[(minTargetVolume-preLoadingDilutionBufferVolume),10^-1*Microliter,AvoidZero->True],1*Microliter]
				];

				(* - Set the sampleLoadingVolumeTooLargeError - *)
				sampleLoadingVolumeTooLargeError=If[(sampleVolume+loadingDilutionBufferVolume+(loadingDyeVolume*2))<resolvedSampleLoadingVolume,
					True,
					False
				];

				(* - Resolve the AutomaticPeakDetection and related error - *)
				{automaticPeakDetection,automaticPeakDetectionScaleMismatchError,automaticPeakDetectionRangeMismatchError,automaticPeakDetectionCollectionRangeMismatchError,automaticPeakDetectionCollectionSizeMismatchError}=Switch[
					{resolvedScale,initialAutomaticPeakDetection,initialPeakDetectionRange,initialCollectionRange,initialCollectionSize},

					(* - Cases when Scale is Analytical - *)
					(* If Scale is Analytical and User has not specified the AutomaticPeakDetection, we resolve to Null (or leave it as Null) *)
					{Analytical,Automatic|Null,_,_,_},
						{Null,False,False,False,False},

					(* If the Scale is Analytical, and the User has specified the AutomaticPeakDetection as anything except Null, we accept it but will need to throw an Error *)
					{Analytical,Except[Null|Automatic],_,_,_},
						{initialAutomaticPeakDetection,True,False,False,False},

					(* -- Cases when Scale is Preparative -- = *)
					(* - Cases when Scale is Preparative and the initialAutomaticPeakDetection is left as Automatic - *)
					(*  If the user has set the PeakDetectionRange to anything other than Null or Automatic, we resolve AutomaticPeakDetection to True *)
					{Preparative,Automatic,Except[Automatic|Null],_,_},
						{True,False,False,False,False},

					(* If the user has set the CollectionSize, we resolve AutomaticPeakDetection to False *)
					{Preparative,Automatic,_,_,Except[Automatic|Null]},
						{False,False,False,False,False},

					(* If the user has set the CollectionRange, we resolve AutomaticPeakDetection to False *)
					{Preparative,Automatic,_,Except[Automatic|Null],_},
						{False,False,False,False,False},

					(* If the user has set the PeakDetectionRange to Null, we resolve AutomaticPeakDetection to False *)
					{Preparative,Automatic,Null,_,_},
						{False,False,False,False,False},

					(* If the user has set the CollectionSize to Null, we resolve AutomaticPeakDetection to True *)
					{Preparative,Automatic,_,_,Null},
						{True,False,False,False,False},

					(* In any other case where the initialAutomaticPeakDetection is Automatic and Scale is Preparative, we resolve to True *)
					{Preparative,Automatic,_,_,_},
						{True,False,False,False,False},

					(* - Cases when Scale is Preparative and the AutomaticPeakDetection has been set by the user. In all cases we accept their value, but might need to throw Errors - *)
					(* If the user has set the AutomaticPeakDetection to Null, we throw an Error (must be True or False) *)
					{Preparative,Null,_,_,_},
						{initialAutomaticPeakDetection,True,False,False,False},

					(* If the user has set the AutomaticPeakDetection to True, the PeakDetectionRange option cannot be Null *)
					{Preparative,True,Null,_,_},
						{initialAutomaticPeakDetection,False,True,False,False},

					(* If the user has set the AutomaticPeakDetection to True, the CollectionSize option cannot be anything except Automatic or Null *)
					{Preparative,True,_,_,Except[Null|Automatic]},
					{initialAutomaticPeakDetection,False,False,False,True},

					(* If the user has set the AutomaticPeakDetection to True, the CollectionRange option cannot be anything except Automatic or Null *)
					{Preparative,True,_,Except[Null|Automatic],_},
						{initialAutomaticPeakDetection,False,False,True,False},

					(* If the user has set the AutomaticPeakDetection to False, the PeakDetectionRange must be Null or Automatic *)
					{Preparative,False,Except[Null|Automatic],_,_},
						{initialAutomaticPeakDetection,False,True,False,False},

					(* In all other cases, we accept the user's option and no errors are thrown (CollectionRange can be Null even if AutomaticPeakDetection is False) *)
					{_,_,_,_,_},
						{initialAutomaticPeakDetection,False,False,False,False}
				];

				(* - Resolve the CollectionSize and related errors - *)
				{collectionSize,collectionScaleMismatchError,unableToDetermineCollectionSizeError,collectionSizeCollectionRangeMismatchError}=Switch[
					{resolvedScale,initialCollectionSize,targetStrandLength,automaticPeakDetection,initialCollectionRange},

					(* - Cases when Scale is Analytical - *)
					(* This is the expected case, we set collectionSize to Null when Analytical *)
					{Analytical,Alternatives[Null,Automatic],_,_,_},
						{Null,False,False,False},

					(* If user has specified a collectionSize and Scale is Analytical, we will need to throw an error *)
					{Analytical,Except[Alternatives[Null,Automatic]],_,_,_},
						{initialCollectionSize,True,False,False},

					(* - Cases when the Scale is Preparative - *)
					(* In the case the CollectionSize is specified, we accept it, but need to throw an Error if the CollectionRange has been specified *)
					{Preparative,Except[Null|Automatic],_,_,Except[Null|Automatic]},
						{initialCollectionSize,False,False,True},

					{Preparative,Except[Automatic],_,_,_},
						{initialCollectionSize,False,False,False},

					(* - Cases where the CollectionSize is Automatic - *)
					(* We resolve it to Null if AutomaticPeakDetection is True *)
					{Preparative,Automatic,_,True,_},
						{Null,False,False,False},

					(* Cases where the CollectionSize is Automatic and AutomaticPeakDetection is False *)
					(* If the CollectionRange has been specified, we default CollectionSize to Null *)
					{Preparative,Automatic,_,_,Except[Null|Automatic]},
						{Null,False,False,False},
					(* In the cases where AutomaticPeakDetection is False and the CollectionRange has not been specified, we resolve the option to the targetStrandLength, or to Null if the targetStrandLength is Null *)
					{Preparative,Automatic,Null,_,_},
						{Null,False,True,False},
					{Preparative,Automatic,_,_,_},
						{(targetStrandLength*BasePair),False,False,False}
				];

				(* - Resolve the PeakDetectionRange - *)
				{peakDetectionRange,peakDetectionRangeScaleMismatchError,peakDetectionRangeCollectionRangeMismatchError,unableToDeterminePeakDetectionRangeError}=Switch[
					{resolvedScale,initialPeakDetectionRange,automaticPeakDetection,initialCollectionRange,targetStrandLength},

					(* - Cases when Scale is Analytical - *)
					(* If PeakDetectionRange left as Null or Automatic, we set option to Null and no Error thrown *)
					{Analytical,Automatic|Null,_,_,_},
						{Null,False,False,False},

					(* If PeakDetectionRange has been set other than Null or Automatic, we accept the user's option but need to throw an Error *)
					{Analytical,Except[Null|Automatic],_,_,_},
						{initialPeakDetectionRange,True,False,False},

					(* -- Cases when Scale is Preparative -- *)
					(* - Cases when Scale is Preparative and the user has not specified the PeakDetectionRange - *)
					(* If AutomaticPeakDetection is False, we resolve to Null *)
					{Preparative,Automatic,False,_,_},
						{Null,False,False,False},

					(* If AutomaticPeakDetection is True, we resolve Span[0.75*largest strand length, 1.1*largest strand length] *)
					{Preparative,Automatic,True,_,Except[Null]},
						{Span[Min[RoundOptionPrecision[(targetStrandLength*0.75)*BasePair,10^0*BasePair,AvoidZero->True],20000*BasePair],Min[RoundOptionPrecision[(targetStrandLength*1.1)*BasePair,10^0*BasePair,AvoidZero->True],20000*BasePair]],False,False,False},

					(* If the targetStrandLength is Null, we resolve the option to Null but need to throw an error *)
					{Preparative,Automatic,True,_,Null},
						{Null,False,False,True},

					(* - Cases when Scale is Preparative and the user has specified the PeakDetectionRange - *)
					(* PeakDetectionRange set to be anything except Null or Automatic, and the CollectionRange has been set to be anything except Null or Automatic - Error, can't have both *)
					{Preparative,Except[Null|Automatic],_,Except[Null|Automatic],_},
						{initialPeakDetectionRange,False,True,False},

					(* In all other cases, we just accept the user-given option *)
					{_,_,_,_,_},
						{initialPeakDetectionRange,False,False,False}
				];

				(* - Resolve the CollectionRange - *)
				{collectionRange,collectionRangeScaleMismatchError,unableToDetermineCollectionRangeError,collectionSizeAndRangeBothNullError}=Switch[
					{resolvedScale,initialCollectionRange,automaticPeakDetection,collectionSize,targetStrandLength},

					(* - Cases when Scale is Analytical - *)
					(* If PeakDetectionRange left as Null or Automatic, we set option to Null and no Error thrown *)
					{Analytical,Null|Automatic,_,_,_},
						{Null,False,False,False},

					(* If PeakDetectionRange has been set other than Null or Automatic, we accept the user's option but need to throw an Error *)
					{Analytical,Except[Null|Automatic],_,_,_},
						{initialCollectionRange,True,False,False},

					(* -- Cases when Scale is Preparative -- *)
					(* - Cases where the user has left the option as Automatic - *)
					(* When AutomaticPeakDetection is True, CollectionRange is resolved to Null *)
					{Preparative,Automatic,True,_,_},
						{Null,False,False,False},

					(* When AutomaticPeakDetection is False and CollectionSize is not Null, the CollectionRange is resolved to Null *)
					{Preparative,Automatic,False,Except[Null],_},
						{Null,False,False,False},

					(* When AutomaticPeakDetection is False and CollectionSize is Null, the CollectionRange is resolved to Null if the targetStrandLength is Null (an error will be thrown) *)
					{Preparative,Automatic,False,Null,Null},
						{Null,False,True,False},

					(* When AutomaticPeakDetection is False and CollectionSize is Null, the CollectionRange is resolved to the range between 92 and 105% of the targetSize *)
					{Preparative,Automatic,False,Null,_},
						{Span[Min[RoundOptionPrecision[(targetStrandLength*0.92)*BasePair,10^0*BasePair,AvoidZero->True],20000*BasePair],Min[RoundOptionPrecision[(targetStrandLength*1.05)*BasePair,10^0*BasePair,AvoidZero->True],20000*BasePair]],False,False,False},

					(* - Cases where the user has specified the CollectionRange option - *)
					(* When AutomaticPeakDetection is False and CollectionSize is Null, the CollectionRange cannot be specified as Null (will throw error) *)
					{Preparative,Null,False,Null,_},
						{initialCollectionRange,False,False,True},

					(* In all other cases, we accept the specified CollectionRange *)
					{Preparative,_,_,_,_},
						{initialCollectionRange,False,False,False}
				];

				(* -- Return the MapThread variables in order -- *)
				{
					sampleVolume,loadingDyeVolume,loadingDye,loadingDilutionBuffer,loadingDilutionBufferVolume,automaticPeakDetection,collectionSize,peakDetectionRange,collectionRange,onlyOneLoadingDyeWarning,
					moreThanTwoLoadingDyesError,sampleLoadingVolumeTooLargeError,automaticPeakDetectionScaleMismatchError,automaticPeakDetectionRangeMismatchError,automaticPeakDetectionCollectionRangeMismatchError,
					automaticPeakDetectionCollectionSizeMismatchError,collectionScaleMismatchError,unableToDetermineCollectionSizeError,peakDetectionRangeScaleMismatchError,peakDetectionRangeCollectionRangeMismatchError,
					unableToDeterminePeakDetectionRangeError,collectionRangeScaleMismatchError,collectionSizeCollectionRangeMismatchError,
					unableToDetermineCollectionRangeError,collectionSizeAndRangeBothNullError
				}
			]
		],
		{mapThreadFriendlyOptions,targetStrandLengths}
	]];

	(* --- UNRESOLVABLE OPTION CHECKS ---*)
	(* -- Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument -- *)
	{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[instrument,simulatedSamples,Cache->simulatedCache,Output->{Result,Tests}],
		{CompatibleMaterialsQ[instrument,simulatedSamples,Cache->simulatedCache,Messages->messages],{}}
	];

	(* - Check to ensure that we do not have too many input samples for the Scale and NumberOfReplicates - *)
	(* Convert numberOfReplicates where Null->1 *)
	intNumberOfReplicates=numberOfReplicates/.{Null->1};

	(* Calculate the number of wells we will need for the run *)
	numberOfSamples=Length[simulatedSamples];
	totalNumberOfSamples=(Length[simulatedSamples]*intNumberOfReplicates);

	(* Define a variable that is all of the input samples if there are too many for the Scale and NumberOfReplicates *)
	tooManyInvalidInputs=Switch[{resolvedScale,totalNumberOfSamples},

		(* If the Scale is Preparative, we can run at most 48 samples - 12 lanes per gel with no ladders *)
		{Preparative,GreaterP[48]},
			simulatedSamples,

		(* If the Scale is Analytical, we can run at most 92 samples 24 lanes per gel with 1 ladder lane per gel*)
		{Analytical,GreaterP[92]},
			simulatedSamples,

		(* Otherwise, its all good *)
		{_,_},
			{}
	];

	(* If number of replicates is too high, and we are throwing messages, throw an error *)
	If[Length[tooManyInvalidInputs]>0&&messages,
		Message[Error::TooManyAgaroseInputs,numberOfSamples,intNumberOfReplicates,resolvedScale]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyInputsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[tooManyInvalidInputs]==0,
				Nothing,
				Test["The product of the number of input samples and the NumberOfReplicates option is not greater than 48 if the Scale is Preparative or 92 if the Scale is Analytical:",True,False]
			];
			passingTest=If[Length[tooManyInvalidInputs]!=0,
				Nothing,
				Test["The product of the number of input samples and the NumberOfReplicates option is not greater than 48 if the Scale is Preparative or 92 if the Scale is Analytical:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- Error checks to make sure the Gel option is okay when input as a list of Objects --- *)
	(* -- Make sure that all of the Gel Objects are of the same Model -- *)
	(* First, get a list of all of the Models of the Gel Objects *)
	gelOptionModels=Lookup[Flatten[gelPacket],Object,{}];

	(* Next, delete duplicates on this list *)
	uniqueGelOptionModels=DeleteDuplicates[gelOptionModels];

	(* Next, check to see if the input gel is list of Objects *)
	gelListQ=If[
		MatchQ[resolvedGel,{ObjectP[Object[Item,Gel]]..}],
		True,
		False
	];

	(* - If the user gave a list of gel Objects as inputs, we need to make sure they are all of the same Model - *)
	invalidMultipleGelObjectModelOptions=Which[

		(* If the user didn't give a list of Gel Objects, then we're fine *)
		!gelListQ,
			{},

		(* Otherwise, we need to make sure that all of the Gel Objects are the same Model *)
		Length[uniqueGelOptionModels]>1,
			{Gel},

		True,
			{}
	];

	(* If the Gel option was given as a list of Objects, and they are not all the same Model, throw an error *)
	If[gelListQ&&Length[invalidMultipleGelObjectModelOptions]>0&&messages,
		Message[Error::MoreThanOneAgaroseGelModel,ObjectToString[resolvedGel,Cache->simulatedCache],ObjectToString[gelOptionModels,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	multipleGelObjectModelTests=If[gatherTests&&gelListQ,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidMultipleGelObjectModelOptions]==0,
				Nothing,
				Test["The Gel option Objects are of more than one Model. All Gels must be of the same Model:",True,False]
			];
			passingTest=If[Length[invalidMultipleGelObjectModelOptions]!=0,
				Nothing,
				Test["The Gel option Objects are all of the same Model:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Check to make sure there are no duplicate Objects in the Gel Option -- *)
	invalidDuplicateGelOptions=Which[

		(* Case where the Gel option is not a list of Objects *)
		!gelListQ,
			{},

		(* Case where the number Of Gel Objects is the same as the number of Objects with Duplicates Deleted *)
		Length[resolvedGel]==Length[DeleteDuplicates[resolvedGel]],
			{},

		(* Otherwise, there is a duplicate Gel *)
		True,
			{Gel}
	];

	(* If the Gel option was given as a list of Objects, and there are any duplicates, throw an error *)
	If[gelListQ&&Length[invalidDuplicateGelOptions]>0&&messages,
		Message[Error::DuplicateAgaroseGelObjects,ObjectToString[resolvedGel,Cache->simulatedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	duplicateGelObjectsTests=If[gatherTests&&gelListQ,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidDuplicateGelOptions]==0,
				Nothing,
				Test["The Gel option contains no duplicate entries:",True,False]
			];
			passingTest=If[Length[invalidDuplicateGelOptions]!=0,
				Nothing,
				Test["The Gel option contains duplicate entries:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Check that we have an appropriate number of samples for the gel(s) -- *)
	(* - Check to make sure that, if the resolvedGel is an Object and not a Model, that there are not too many samples to fit on the gel - *)
	(* First, check to see if the resolved Gel is an Object or list of Objects *)
	objectGelQ=If[
		MatchQ[resolvedGel,Alternatives[ObjectP[Object[Item,Gel]],{ObjectP[Object[Item,Gel]]..}]],
		True,
		False
	];

	(* Set the number of Gel Objects present in option *)
	numberOfGelObjects=If[objectGelQ,
		Length[ToList[resolvedGel]],
		Null
	];

	(* Set the number of potential sample lanes per gel (1 for ladders in analytical gels)*)
	numberOfSampleLanes=If[

		(* IF the Scale is Analytical *)
		MatchQ[resolvedScale,Analytical],

		(* THEN the numberOfSampleLanes per gel is 23 *)
		23,

		(* ELSE, the numberOfSampleLanes per gel is 12 *)
		12
	];

	(* Set the minimum and maximum number of samples that can be run on the Gel Objects given in the option *)
	{minimumSampleLanes,maximumSampleLanes}=If[

		(* IF the Gel option is a Model *)
		!objectGelQ,

		(* THEN set both to Null *)
		{Null,Null},

		(* ELSE, calculate the minimum and maximum number of acceptable lanes *)
		{
			((numberOfSampleLanes*(numberOfGelObjects-1))+1),
			(numberOfSampleLanes*numberOfGelObjects)
		}
	];

	(* Set an invalid option variable if the number of samples isn't copacetic with the Gel option *)
	invalidNumberOfGelsOptions=Which[

		(* Case where the Gel is Model, no need to check *)
		!objectGelQ,
			{},

		(* Case where the number of sample lanes required is within the min/max available lanes, that's cool *)
		MatchQ[totalNumberOfSamples,RangeP[minimumSampleLanes,maximumSampleLanes]],
			{},

		(* Otherwise, the Gel option is invalid *)
		True,
			{Gel}
	];

	(* If the Gel option was given as an Object or list of Objects, and there aren't the right number of Samples throw an error *)
	If[objectGelQ&&Length[invalidNumberOfGelsOptions]>0&&messages,
		Message[Error::InvalidNumberOfAgaroseGels,totalNumberOfSamples,ObjectToString[resolvedGel,Cache->simulatedCache],minimumSampleLanes,maximumSampleLanes]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidNumberOfGelsTests=If[gatherTests&&objectGelQ,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidNumberOfGelsOptions]==0,
				Nothing,
				Test["The supplied Gel option is not acceptable for the number of input samples:",True,False]
			];
			passingTest=If[Length[invalidNumberOfGelsOptions]!=0,
				Nothing,
				Test["The supplied Gel option is acceptable for the number of input samples:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(* - Throw Error for moreThanTwoLoadingDyesErrors - *)
	(* First, determine if we need to throw this warning *)
	moreThanTwoLoadingDyesErrorQ=MemberQ[moreThanTwoLoadingDyesErrors,True];

	(* Create lists of the input samples that have the moreThanTwoLoadingDyesError set to True and to False *)
	failingMoreThanTwoLoadingDyesErrorSamples=PickList[simulatedSamples,moreThanTwoLoadingDyesErrors,True];
	passingMoreThanTwoLoadingDyesErrorSamples=PickList[simulatedSamples,moreThanTwoLoadingDyesErrors,False];

	(* Define the invalid option variable related to the Error below *)
	invalidTooManyLoadingDyesOptions=If[moreThanTwoLoadingDyesErrorQ,
		{LoadingDye},
		{}
	];

	(* Throw an error message if we are throwing messages, and there are some input samples that caused moreThanTwoLoadingDyesErrors to be set to True *)
	If[moreThanTwoLoadingDyesErrorQ&&messages,
		Message[Error::TooManyAgaroseLoadingDyes,ObjectToString[failingMoreThanTwoLoadingDyesErrorSamples,Cache->simulatedCache]]
	];

	(* Define the tests the user will see for the above message *)
	moreThanTwoLoadingDyesTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[moreThanTwoLoadingDyesErrorQ,
				Test["There are more than two associated LoadingDyes specified for the following samples, "<>ObjectToString[failingMoreThanTwoLoadingDyesErrorSamples,Cache->simulatedCache]<>":",True,False],
				Nothing
			];
			passingTest=If[Length[passingMoreThanTwoLoadingDyesErrorSamples]>0,
				Test["There at most two associated LoadingDyes specified for the following samples, "<>ObjectToString[passingMoreThanTwoLoadingDyesErrorSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Warning for moreThanTwoLoadingDyesErrors - *)
	(* First, determine if we need to throw this warning *)
	onlyOneLoadingDyeWarningQ=MemberQ[onlyOneLoadingDyeWarnings,True];

	(* Create lists of the input samples that have the moreThanTwoLoadingDyesWarning set to True and to False *)
	failingOnlyOneLoadingDyeWarningSamples=PickList[simulatedSamples,onlyOneLoadingDyeWarnings,True];
	passingOnlyOneLoadingDyeWarningSamples=PickList[simulatedSamples,onlyOneLoadingDyeWarnings,False];

	(* Throw a warning message if we are throwing messages, and there are some input samples that caused moreThanTwoLoadingDyesWarnings to be set to True *)
	If[onlyOneLoadingDyeWarningQ&&messages&&notInEngine,
		Message[Warning::OnlyOneAgaroseLoadingDye,ObjectToString[failingOnlyOneLoadingDyeWarningSamples,Cache->simulatedCache]]
	];

	(* Define the tests the user will see for the above message *)
	onlyOneLoadingDyeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[onlyOneLoadingDyeWarningQ,
				Warning["There is only one LoadingDye specified for the following samples, "<>ObjectToString[failingOnlyOneLoadingDyeWarningSamples,Cache->simulatedCache]<>". Sizing is most accurate when each SampleIn has two associated LoadingDyes whose oligomer lengths flank the target strand of interest:",True,False],
				Nothing
			];
			passingTest=If[Length[passingOnlyOneLoadingDyeWarningSamples]>0,
				Warning["There are more than one LoadingDyes specified for the following samples, "<>ObjectToString[passingOnlyOneLoadingDyeWarningSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for sampleLoadingVolumeTooLargeErrors - *)
	(* First, calculate the total sample volume for all of the input samples *)
	totalSampleVolumes=(resolvedSampleVolume+resolvedLoadingDyeVolume+resolvedLoadingDilutionBufferVolume);

	(* Determine if we need to throw this Error *)
	sampleLoadingVolumeTooLargeErrorQ=MemberQ[sampleLoadingVolumeTooLargeErrors,True];

	(* Create lists of the input samples that have the sampleLoadingVolumeTooLargeError set to True and to False *)
	failingSampleLoadingVolumeTooLargeSamples=PickList[simulatedSamples,sampleLoadingVolumeTooLargeErrors,True];
	passingSampleLoadingVolumeTooLargeSamples=PickList[simulatedSamples,sampleLoadingVolumeTooLargeErrors,False];

	(* Create a list of the totalSampleVolumes for the samples which sampleLoadingVolumeTooLargeError is True (for the Tests and Error) *)
	failingSampleLoadingVolumeTooLargeVolumes=PickList[totalSampleVolumes,sampleLoadingVolumeTooLargeErrors,True];

	(* Define the invalid options if we need to throw this Error *)
	invalidSampleLoadingOptions=If[sampleLoadingVolumeTooLargeErrorQ,
		{SampleVolume,LoadingDyeVolume,LoadingDilutionBufferVolume,SampleLoadingVolume},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused sampleLoadingVolumeTooLargeErrors to be set to True *)
	If[sampleLoadingVolumeTooLargeErrorQ&&messages,
		Message[Error::NotEnoughAgaroseSampleToLoad,failingSampleLoadingVolumeTooLargeVolumes,resolvedSampleLoadingVolume,ObjectToString[failingSampleLoadingVolumeTooLargeSamples,Cache->simulatedCache]]
	];

	(* Define the tests the user will see for the above message *)
	sampleLoadingVolumeTooLargeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[sampleLoadingVolumeTooLargeErrorQ,
				Test["For the following input samples, "<>ObjectToString[failingSampleLoadingVolumeTooLargeSamples,Cache->simulatedCache]<>", the sum of the SampleVolume, LoadingDyeVolume, and LoadingDilutionBufferVolume, "<>ToString[failingSampleLoadingVolumeTooLargeVolumes]<>", is smaller than the SampleLoadingVolume, "<>ToString[resolvedSampleLoadingVolume]<>":",True,False],
				Nothing
			];
			passingTest=If[Length[passingSampleLoadingVolumeTooLargeSamples]>0,
				Test["The sum of the SampleVolume, LoadingDyeVolume, and LoadingDilutionBufferVolume is larger than the SampleLoadingVolume for the following input samples, "<>ObjectToString[passingSampleLoadingVolumeTooLargeSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for collectionScaleMismatchErrors - *)
	(* First, determine if we need to throw this Error *)
	collectionScaleMismatchErrorQ=MemberQ[collectionScaleMismatchErrors,True];

	(* Create lists of the input samples that have the collectionScaleMismatchError set to True and to False *)
	failingCollectionScaleMismatchSamples=PickList[simulatedSamples,collectionScaleMismatchErrors,True];
	passingCollectionScaleMismatchSamples=PickList[simulatedSamples,collectionScaleMismatchErrors,False];

	(* Create a list of the resolvedCollectionSizes for the samples which collectionScaleMismatchErrors is True (for the Tests and Error) *)
	failingCollectionSizes=PickList[resolvedCollectionSize,collectionScaleMismatchErrors,True];

	(* Define the invalid options if we need to throw this Error *)
	invalidCollectionScaleMismatchOptions=If[collectionScaleMismatchErrorQ,
		{CollectionSize,Scale},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused collectionScaleMismatchErrors to be set to True *)
	If[collectionScaleMismatchErrorQ&&messages,
		Message[Error::ConflictingAgaroseCollectionSizeScaleOptions,ObjectToString[failingCollectionScaleMismatchSamples,Cache->simulatedCache],failingCollectionSizes,resolvedScale]
	];

	(* Define the tests the user will see for the above message *)
	collectionScaleMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[collectionScaleMismatchErrorQ,
				Test["The following samples, "<>ObjectToString[failingCollectionScaleMismatchSamples,Cache->simulatedCache]<>", have CollectionSize options, "<>ToString[failingCollectionSizes]<>", which are in conflict with the Scale option, "<>ToString[resolvedScale]<>". If the Scale is Preparative, the CollectionSize must be set, if the Scale is Analytical, these options must be Null:",True,False],
				Nothing
			];
			passingTest=If[Length[passingCollectionScaleMismatchSamples]>0,
				Test["The following samples have CollectionSize options which are not in conflict with the Scale option, "<>ObjectToString[passingCollectionScaleMismatchSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for unableToDetermineCollectionSizeErrors - *)
	(* First, determine if we need to throw this Error *)
	unableToDetermineCollectionSizeErrorQ=MemberQ[unableToDetermineCollectionSizeErrors,True];

	(* Create lists of the input samples that have the unableToDetermineCollectionScaleError set to True and to False *)
	failingUnableToDetermineCollectionSizeSamples=PickList[simulatedSamples,unableToDetermineCollectionSizeErrors,True];
	passingUnableToDetermineCollectionSizeSamples=PickList[simulatedSamples,unableToDetermineCollectionSizeErrors,False];

	(* Define the invalid options if we need to throw this Error *)
	invalidUnableToDetermineCollectionOptions=If[unableToDetermineCollectionSizeErrorQ,
		{CollectionSize},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused unableToDetermineCollectionSizeErrors to be set to True *)
	If[unableToDetermineCollectionSizeErrorQ&&messages,
		Message[Error::UnableToDetermineAgaroseCollectionSize,ObjectToString[failingUnableToDetermineCollectionSizeSamples,Cache->simulatedCache]]
	];

	(* Define the tests the user will see for the above message *)
	unableToDetermineCollectionSizeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[unableToDetermineCollectionSizeErrorQ,
				Test["The CollectionSize cannot be determined for the following input samples, "<>ObjectToString[failingUnableToDetermineCollectionSizeSamples,Cache->simulatedCache]<>":",True,False],
				Nothing
			];
			passingTest=If[Length[passingUnableToDetermineCollectionSizeSamples]>0,
				Test["The CollectionSize can be determined for the following input samples, "<>ObjectToString[passingUnableToDetermineCollectionSizeSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for unableToDeterminePeakDetectionRangeErrors - *)
	(* First, determine if we need to throw this Error *)
	unableToDeterminePeakDetectionRangeErrorQ=MemberQ[unableToDeterminePeakDetectionRangeErrors,True];

	(* Create lists of the input samples that have the unableToDeterminePeakDetectionRangeError set to True and to False *)
	failingUnableToDeterminePeakDetectionRangeSamples=PickList[simulatedSamples,unableToDeterminePeakDetectionRangeErrors,True];
	passingUnableToDeterminePeakDetectionRangeSamples=PickList[simulatedSamples,unableToDeterminePeakDetectionRangeErrors,False];

	(* Define the invalid options if we need to throw this Error *)
	invalidUnableToDeterminePeakDetectionRangeOptions=If[unableToDeterminePeakDetectionRangeErrorQ,
		{PeakDetectionRange},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused unableToDeterminePeakDetectionRangeErrors to be set to True *)
	If[unableToDeterminePeakDetectionRangeErrorQ&&messages,
		Message[Error::UnableToDetermineAgarosePeakDetectionRange,ObjectToString[failingUnableToDeterminePeakDetectionRangeSamples,Cache->simulatedCache]]
	];

	(* Define the tests the user will see for the above message *)
	unableToDeterminePeakDetectionRangeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[unableToDeterminePeakDetectionRangeErrorQ,
				Test["The PeakDetectionRange cannot be determined for the following input samples, "<>ObjectToString[failingUnableToDeterminePeakDetectionRangeSamples,Cache->simulatedCache]<>":",True,False],
				Nothing
			];
			passingTest=If[Length[passingUnableToDeterminePeakDetectionRangeSamples]>0,
				Test["The PeakDetectionRange can be determined for the following input samples, "<>ObjectToString[passingUnableToDeterminePeakDetectionRangeSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for unableToDetermineCollectionRangeErrors - *)
	(* First, determine if we need to throw this Error *)
	unableToDetermineCollectionRangeErrorQ=MemberQ[unableToDetermineCollectionRangeErrors,True];

	(* Create lists of the input samples that have the unableToDetermineCollectionRangeError set to True and to False *)
	failingUnableToDetermineCollectionRangeSamples=PickList[simulatedSamples,unableToDetermineCollectionRangeErrors,True];
	passingUnableToDetermineCollectionRangeSamples=PickList[simulatedSamples,unableToDetermineCollectionRangeErrors,False];

	(* Define the invalid options if we need to throw this Error *)
	invalidUnableToDetermineCollectionRangeOptions=If[unableToDetermineCollectionRangeErrorQ,
		{CollectionRange},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused unableToDeterminePeakDetectionRangeErrors to be set to True *)
	If[unableToDetermineCollectionRangeErrorQ&&messages,
		Message[Error::UnableToDetermineAgaroseCollectionRange,ObjectToString[failingUnableToDetermineCollectionRangeSamples,Cache->simulatedCache]]
	];

	(* Define the tests the user will see for the above message *)
	unableToDetermineCollectionRangeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[unableToDetermineCollectionRangeErrorQ,
				Test["The CollectionRange cannot be determined for the following input samples, "<>ObjectToString[failingUnableToDetermineCollectionRangeSamples,Cache->simulatedCache]<>":",True,False],
				Nothing
			];
			passingTest=If[Length[passingUnableToDeterminePeakDetectionRangeSamples]>0,
				Test["The CollectionRange can be determined for the following input samples, "<>ObjectToString[passingUnableToDetermineCollectionRangeSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for automaticPeakDetectionScaleMismatchErrors - *)
	(* First, determine if we need to throw this Error *)
	automaticPeakDetectionScaleMismatchErrorQ=MemberQ[automaticPeakDetectionScaleMismatchErrors,True];

	(* Create lists of the input samples that have the automaticPeakDetectionScaleMismatchError set to True and to False *)
	failingAutomaticPeakDetectionScaleSamples=PickList[simulatedSamples,automaticPeakDetectionScaleMismatchErrors,True];
	passingAutomaticPeakDetectionScaleSamples=PickList[simulatedSamples,automaticPeakDetectionScaleMismatchErrors,False];

	(* Create a list of the AutomaticPeakDetections that are failing (for Error message and Tests *)
	failingScaleMismatchAutomaticPeakDetections=PickList[resolvedAutomaticPeakDetection,automaticPeakDetectionScaleMismatchErrors,True];

	(* Define the invalid options if we need to throw this Error *)
	invalidAPDScaleMismatchOptions=If[automaticPeakDetectionScaleMismatchErrorQ,
		{AutomaticPeakDetection,Scale},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused automaticPeakDetectionScaleMismatchErrors to be set to True *)
	If[automaticPeakDetectionScaleMismatchErrorQ&&messages,
		Message[Error::ConflictingAgaroseAutomaticPeakDetectionScaleOptions,ObjectToString[failingAutomaticPeakDetectionScaleSamples,Cache->simulatedCache],failingScaleMismatchAutomaticPeakDetections,resolvedScale]
	];

	(* Define the tests the user will see for the above message *)
	automaticPeakDetectionScaleMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[automaticPeakDetectionScaleMismatchErrorQ,
				Test["The following samples, "<>ObjectToString[failingAutomaticPeakDetectionScaleSamples,Cache->simulatedCache]<>", have AutomaticPeakDetection options, "<>ToString[failingScaleMismatchAutomaticPeakDetections]<>", which are in conflict with the Scale option, "<>ToString[resolvedScale]<>". If the Scale is Analytical, the AutomaticPeakDetection must be Null. If the Scale is Preparative, the AutomaticPeakDetection must be True or False:",True,False],
				Nothing
			];
			passingTest=If[Length[passingAutomaticPeakDetectionScaleSamples]>0,
				Test["The following samples have AutomaticPeakDetection options which are not in conflict with the Scale option, "<>ObjectToString[passingAutomaticPeakDetectionScaleSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for automaticPeakDetectionScaleMismatchErrors - *)
	(* First, determine if we need to throw this Error *)
	automaticPeakDetectionRangeMismatchErrorQ=MemberQ[automaticPeakDetectionRangeMismatchErrors,True];

	(* Create lists of the input samples that have the automaticPeakDetectionRangeMismatchError set to True and to False *)
	failingAutomaticPeakDetectionRangeSamples=PickList[simulatedSamples,automaticPeakDetectionRangeMismatchErrors,True];
	passingAutomaticPeakDetectionRangeSamples=PickList[simulatedSamples,automaticPeakDetectionRangeMismatchErrors,False];

	(* Create lists of the AutomaticPeakDetections and PeakDetectionRanges that are failing (for Error message and Tests) *)
	failingPeakDetectionRangeMismatchAutomaticPeakDetections=PickList[resolvedAutomaticPeakDetection,automaticPeakDetectionRangeMismatchErrors,True];
	failingAutomaticPeakDetectionMismatchDetectionWidths=PickList[resolvedPeakDetectionRange,automaticPeakDetectionRangeMismatchErrors,True];

	(* Define the invalid options if we need to throw this Error *)
	invalidAPDPeakDetectionRangeMismatchOptions=If[automaticPeakDetectionRangeMismatchErrorQ,
		{AutomaticPeakDetection,PeakDetectionRange},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused automaticPeakDetectionScaleMismatchErrors to be set to True *)
	If[automaticPeakDetectionRangeMismatchErrorQ&&messages,
		Message[Error::ConflictingAgaroseAutomaticPeakDetectionRangeOptions,ObjectToString[failingAutomaticPeakDetectionRangeSamples,Cache->simulatedCache],failingPeakDetectionRangeMismatchAutomaticPeakDetections,failingAutomaticPeakDetectionMismatchDetectionWidths]
	];

	(* Define the tests the user will see for the above message *)
	automaticPeakDetectionRangeMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[automaticPeakDetectionRangeMismatchErrorQ,
				Test["The following samples, "<>ObjectToString[failingAutomaticPeakDetectionRangeSamples,Cache->simulatedCache]<>", have AutomaticPeakDetection options, "<>ToString[failingPeakDetectionRangeMismatchAutomaticPeakDetections]<>", which are in conflict with their PeakDetectionRange options, "<>ToString[failingAutomaticPeakDetectionMismatchDetectionWidths]<>". If AutomaticPeakDetection is True, the PeakDetectionRange cannot be Null. If AutomaticPeakDetection is False, the PeakDetectionRange must be Null:",True,False],
				Nothing
			];
			passingTest=If[Length[passingAutomaticPeakDetectionRangeSamples]>0,
				Test["The following samples have AutomaticPeakDetection options which are not in conflict with the PeakDetectionRange option, "<>ObjectToString[passingAutomaticPeakDetectionRangeSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for automaticPeakDetectionCollectionRangeMismatchErrors - *)
	(* First, determine if we need to throw this Error *)
	automaticPeakDetectionCollectionRangeMismatchErrorQ=MemberQ[automaticPeakDetectionCollectionRangeMismatchErrors,True];

	(* Create lists of the input samples that have the automaticPeakDetectionCollectionRangeMismatchError set to True and to False *)
	failingAutomaticPeakDetectionCollectionSamples=PickList[simulatedSamples,automaticPeakDetectionCollectionRangeMismatchErrors,True];
	passingAutomaticPeakDetectionCollectionSamples=PickList[simulatedSamples,automaticPeakDetectionCollectionRangeMismatchErrors,False];

	(* Create lists of the AutomaticPeakDetections and CollectionRanges that are failing (for Error message and Tests) *)
	failingCollectionRangeMismatchAutomaticPeakDetections=PickList[resolvedAutomaticPeakDetection,automaticPeakDetectionCollectionRangeMismatchErrors,True];
	failingAutomaticPeakDetectionMismatchCollectionRanges=PickList[resolvedCollectionRange,automaticPeakDetectionCollectionRangeMismatchErrors,True];

	(* Define the invalid options if we need to throw this Error *)
	invalidAPDCollectionRangeMismatchOptions=If[automaticPeakDetectionCollectionRangeMismatchErrorQ,
		{AutomaticPeakDetection,CollectionRange},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused automaticPeakDetectionCollectionRangeMismatchErrors to be set to True *)
	If[automaticPeakDetectionCollectionRangeMismatchErrorQ&&messages,
		Message[Error::ConflictingAgaroseAutomaticPeakDetectionCollectionRangeOptions,ObjectToString[failingAutomaticPeakDetectionCollectionSamples,Cache->simulatedCache],failingCollectionRangeMismatchAutomaticPeakDetections,failingAutomaticPeakDetectionMismatchCollectionRanges]
	];

	(* Define the tests the user will see for the above message *)
	automaticPeakDetectionCollectionRangeMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[automaticPeakDetectionCollectionRangeMismatchErrorQ,
				Test["The following samples, "<>ObjectToString[failingAutomaticPeakDetectionCollectionSamples,Cache->simulatedCache]<>", have AutomaticPeakDetection options, "<>ToString[failingCollectionRangeMismatchAutomaticPeakDetections]<>", which are in conflict with their CollectionRange options, "<>ToString[failingAutomaticPeakDetectionMismatchCollectionRanges]<>". If AutomaticPeakDetection is True, the CollectionRange must be Null:",True,False],
				Nothing
			];
			passingTest=If[Length[passingAutomaticPeakDetectionCollectionSamples]>0,
				Test["The following samples have AutomaticPeakDetection options which are not in conflict with the CollectionRange option, "<>ObjectToString[passingAutomaticPeakDetectionCollectionSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for automaticPeakDetectionCollectionSizeMismatchErrors - *)
	(* First, determine if we need to throw this Error *)
	automaticPeakDetectionCollectionSizeMismatchErrorQ=MemberQ[automaticPeakDetectionCollectionSizeMismatchErrors,True];

	(* Create lists of the input samples that have the automaticPeakDetectionCollectionSizeMismatchError set to True and to False *)
	failingAutomaticPeakDetectionCollectionSizeSamples=PickList[simulatedSamples,automaticPeakDetectionCollectionSizeMismatchErrors,True];
	passingAutomaticPeakDetectionCollectionSizeSamples=PickList[simulatedSamples,automaticPeakDetectionCollectionSizeMismatchErrors,False];

	(* Create lists of the AutomaticPeakDetections and CollectionSizes that are failing (for Error message and Tests) *)
	failingCollectionSizeMismatchAutomaticPeakDetections=PickList[resolvedAutomaticPeakDetection,automaticPeakDetectionCollectionSizeMismatchErrors,True];
	failingAutomaticPeakDetectionMismatchCollectionSizes=PickList[resolvedCollectionSize,automaticPeakDetectionCollectionSizeMismatchErrors,True];

	(* Define the invalid options if we need to throw this Error *)
	invalidAPDCollectionSizeMismatchOptions=If[automaticPeakDetectionCollectionSizeMismatchErrorQ,
		{AutomaticPeakDetection,CollectionSize},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused automaticPeakDetectionCollectionSizeMismatchErrors to be set to True *)
	If[automaticPeakDetectionCollectionSizeMismatchErrorQ&&messages,
		Message[Error::ConflictingAgaroseAutomaticPeakDetectionCollectionSizeOptions,ObjectToString[failingAutomaticPeakDetectionCollectionSizeSamples,Cache->simulatedCache],failingCollectionSizeMismatchAutomaticPeakDetections,failingAutomaticPeakDetectionMismatchCollectionSizes]
	];

	(* Define the tests the user will see for the above message *)
	automaticPeakDetectionCollectionSizeMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[automaticPeakDetectionCollectionSizeMismatchErrorQ,
				Test["The following samples, "<>ObjectToString[failingAutomaticPeakDetectionCollectionSizeSamples,Cache->simulatedCache]<>", have AutomaticPeakDetection options, "<>ToString[failingCollectionSizeMismatchAutomaticPeakDetections]<>", which are in conflict with their CollectionSize options, "<>ToString[failingAutomaticPeakDetectionMismatchCollectionSizes]<>". If AutomaticPeakDetection is True, the CollectionSize must be Null:",True,False],
				Nothing
			];
			passingTest=If[Length[passingAutomaticPeakDetectionCollectionSizeSamples]>0,
				Test["The following samples have AutomaticPeakDetection options which are not in conflict with the CollectionSize option, "<>ObjectToString[passingAutomaticPeakDetectionCollectionSizeSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for collectionSizeCollectionRangeMismatchErrors - *)
	(* First, determine if we need to throw this Error *)

	collectionSizeCollectionRangeMismatchErrorQ=MemberQ[collectionSizeCollectionRangeMismatchErrors,True];

	(* Create lists of the input samples that have the collectionSizeCollectionRangeMismatchError set to True and to False *)
	failingCollectionSizeCollectionRangeSamples=PickList[simulatedSamples,collectionSizeCollectionRangeMismatchErrors,True];
	passingCollectionSizeCollectionRangeSamples=PickList[simulatedSamples,collectionSizeCollectionRangeMismatchErrors,False];

	(* Create lists of the CollectionRanges and CollectionSizes that are failing (for Error message and Tests) *)
	failingCollectionRangeMisMatchCollectionSizes=PickList[resolvedCollectionSize,collectionSizeCollectionRangeMismatchErrors,True];
	failingCollectionSizeMismatchCollectionRanges=PickList[resolvedCollectionRange,collectionSizeCollectionRangeMismatchErrors,True];

	(* Define the invalid options if we need to throw this Error *)
	invalidCollectionSizeRangeMismatchOptions=If[collectionSizeCollectionRangeMismatchErrorQ,
		{CollectionSize,CollectionRange},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused automaticPeakDetectionCollectionSizeMismatchErrors to be set to True *)
	If[collectionSizeCollectionRangeMismatchErrorQ&&messages,
		Message[Error::ConflictingAgaroseCollectionSizeAndRangeOptions,ObjectToString[failingCollectionSizeCollectionRangeSamples,Cache->simulatedCache],failingCollectionRangeMisMatchCollectionSizes,failingCollectionSizeMismatchCollectionRanges]
	];

	(* Define the tests the user will see for the above message *)
	collectionSizeCollectionRangeMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[collectionSizeCollectionRangeMismatchErrorQ,
				Test["The following samples, "<>ObjectToString[failingCollectionSizeCollectionRangeSamples,Cache->simulatedCache]<>", have CollectionSize options, "<>ToString[failingCollectionRangeMisMatchCollectionSizes]<>", which are in conflict with their CollectionRange options, "<>ToString[failingCollectionSizeMismatchCollectionRanges]<>". If the CollectionSize is specified as a non-Null value, The CollectionRange option must be Null:",True,False],
				Nothing
			];
			passingTest=If[Length[passingCollectionSizeCollectionRangeSamples]>0,
				Test["The following samples have CollectionSize options which are not in conflict with the CollectionRange option, "<>ObjectToString[passingCollectionSizeCollectionRangeSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* - Throw Error for peakDetectionRangeScaleMismatchErrors - *)
	(* First, determine if we need to throw this Error *)
	peakDetectionRangeScaleMismatchErrorQ=MemberQ[peakDetectionRangeScaleMismatchErrors,True];

	(* Create lists of the input samples that have the automaticPeakDetectionCollectionRangeMismatchError set to True and to False *)
	failingPeakDetectionRangeScaleSamples=PickList[simulatedSamples,peakDetectionRangeScaleMismatchErrors,True];
	passingPeakDetectionRangeScaleSamples=PickList[simulatedSamples,peakDetectionRangeScaleMismatchErrors,False];

	(* Create lists of the PeakDetectionRanges that are failing (for Error message and Tests) *)
	failingScaleMismatchPeakDetectionRanges=PickList[resolvedPeakDetectionRange,peakDetectionRangeScaleMismatchErrors,True];

	(* Define the invalid options if we need to throw this Error *)
	invalidPDWScaleMismatchOptions=If[peakDetectionRangeScaleMismatchErrorQ,
		{PeakDetectionRange,Scale},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused automaticPeakDetectionCollectionRangeMismatchErrors to be set to True *)
	If[peakDetectionRangeScaleMismatchErrorQ&&messages,
		Message[Error::ConflictingAgarosePeakDetectionRangeScaleOptions,ObjectToString[failingPeakDetectionRangeScaleSamples,Cache->simulatedCache],failingScaleMismatchPeakDetectionRanges,resolvedScale]
	];

	(* Define the tests the user will see for the above message *)
	peakDetectionRangeScaleMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[peakDetectionRangeScaleMismatchErrorQ,
				Test["The following samples, "<>ObjectToString[failingPeakDetectionRangeScaleSamples,Cache->simulatedCache]<>", have PeakDetectionRange options, "<>ToString[failingScaleMismatchPeakDetectionRanges]<>", which are in conflict with the Scale Option, "<>ToString[resolvedScale]<>". If Scale is Analytical, the PeakDetectionRange must be Null:",True,False],
				Nothing
			];
			passingTest=If[Length[passingPeakDetectionRangeScaleSamples]>0,
				Test["The following samples have PeakDetectionRange options which are not in conflict with the Scale option, "<>ObjectToString[passingPeakDetectionRangeScaleSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for peakDetectionRangeCollectionRangeMismatchErrors - *)
	(* First, determine if we need to throw this Error *)
	peakDetectionRangeCollectionRangeMismatchErrorQ=MemberQ[peakDetectionRangeCollectionRangeMismatchErrors,True];

	(* Create lists of the input samples that have the automaticPeakDetectionCollectionRangeMismatchError set to True and to False *)
	failingPeakDetectionRangeCollectionRangeSamples=PickList[simulatedSamples,peakDetectionRangeCollectionRangeMismatchErrors,True];
	passingPeakDetectionRangeCollectionRangeSamples=PickList[simulatedSamples,peakDetectionRangeCollectionRangeMismatchErrors,False];

	(* Create lists of the PeakDetectionRanges and CollectionRanges that are failing (for Error message and Tests) *)
	failingCollectionRangeMismatchPeakDetectionRanges=PickList[resolvedPeakDetectionRange,peakDetectionRangeCollectionRangeMismatchErrors,True];
	failingPeakDetectionRangeMismatchCollectionRanges=PickList[resolvedCollectionRange,peakDetectionRangeCollectionRangeMismatchErrors,True];

	(* Define the invalid options if we need to throw this Error *)
	invalidPeakDetectionRangeCollectionMismatchOptions=If[peakDetectionRangeCollectionRangeMismatchErrorQ,
		{PeakDetectionRange,CollectionRange},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused peakDetectionRangeCollectionRangeMismatchErrors to be set to True *)
	If[peakDetectionRangeCollectionRangeMismatchErrorQ&&messages,
		Message[Error::ConflictingAgarosePeakDetectionRangeCollectionRangeOptions,ObjectToString[failingPeakDetectionRangeCollectionRangeSamples,Cache->simulatedCache],failingCollectionRangeMismatchPeakDetectionRanges,failingPeakDetectionRangeMismatchCollectionRanges]
	];

	(* Define the tests the user will see for the above message *)
	peakDetectionRangeCollectionRangeMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[peakDetectionRangeCollectionRangeMismatchErrorQ,
				Test["The following samples, "<>ObjectToString[failingPeakDetectionRangeCollectionRangeSamples,Cache->simulatedCache]<>", have PeakDetectionRange options, "<>ToString[failingCollectionRangeMismatchPeakDetectionRanges]<>", which are in conflict with their CollectionRange options, "<>ToString[failingPeakDetectionRangeMismatchCollectionRanges]<>". If the PeakDetectionRange is specified, the CollectionRange must be Null:",True,False],
				Nothing
			];
			passingTest=If[Length[passingPeakDetectionRangeCollectionRangeSamples]>0,
				Test["The following samples have PeakDetectionRange options which are not in conflict with the CollectionRange option, "<>ObjectToString[passingPeakDetectionRangeCollectionRangeSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for collectionRangeScaleMismatchErrors - *)
	(* First, determine if we need to throw this Error *)
	collectionRangeScaleMismatchErrorQ=MemberQ[collectionRangeScaleMismatchErrors,True];

	(* Create lists of the input samples that have the collectionRangeScaleMismatchError set to True and to False *)
	failingCollectionRangeScaleMismatchSamples=PickList[simulatedSamples,collectionRangeScaleMismatchErrors,True];
	passingCollectionRangeScaleMismatchSamples=PickList[simulatedSamples,collectionRangeScaleMismatchErrors,False];

	(* Create list of the CollectionRanges that are failing (for Error message and Tests) *)
	failingScaleMismatchCollectionRanges=PickList[resolvedCollectionRange,collectionRangeScaleMismatchErrors,True];

	(* Define the invalid options if we need to throw this Error *)
	invalidCollectionRangeScaleMismatchOptions=If[collectionRangeScaleMismatchErrorQ,
		{CollectionRange,Scale},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused collectionRangeScaleMismatchErrors to be set to True *)
	If[collectionRangeScaleMismatchErrorQ&&messages,
		Message[Error::ConflictingAgaroseCollectionRangeScaleOptions,ObjectToString[failingCollectionRangeScaleMismatchSamples,Cache->simulatedCache],failingScaleMismatchCollectionRanges,resolvedScale]
	];

	(* Define the tests the user will see for the above message *)
	collectionRangeScaleMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[collectionRangeScaleMismatchErrorQ,
				Test["The following samples, "<>ObjectToString[failingCollectionRangeScaleMismatchSamples,Cache->simulatedCache]<>", have CollectionRange options, "<>ToString[failingScaleMismatchCollectionRanges]<>", which are in conflict with the Scale Option, "<>ToString[resolvedScale]<>". If Scale is Analytical, the CollectionRange must be Null:",True,False],
				Nothing
			];
			passingTest=If[Length[passingCollectionRangeScaleMismatchSamples]>0,
				Test["The following samples have CollectionRange options which are not in conflict with the Scale option, "<>ObjectToString[passingCollectionRangeScaleMismatchSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error for collectionSizeAndRangeBothNullErrors - *)
	(* First, determine if we need to throw this Error *)
	collectionSizeAndRangeBothNullErrorQ=MemberQ[collectionSizeAndRangeBothNullErrors,True];

	(* Create lists of the input samples that have the collectionSizeAndRangeBothNullError set to True and to False *)
	failingCollectionSizeAndRangeBothNullSamples=PickList[simulatedSamples,collectionSizeAndRangeBothNullErrors,True];
	passingCollectionSizeAndRangeBothNullSamples=PickList[simulatedSamples,collectionSizeAndRangeBothNullErrors,False];

	(* Define the invalid options if we need to throw this Error *)
	invalidCollectionSizeAndRangeBothNullOptions=If[collectionSizeAndRangeBothNullErrorQ,
		{AutomaticPeakDetection,CollectionSize,CollectionRange},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused collectionSizeAndRangeBothNullError to be set to True *)
	If[collectionSizeAndRangeBothNullErrorQ&&messages,
		Message[Error::AgaroseCollectionSizeAndRangeBothNull,ObjectToString[failingCollectionSizeAndRangeBothNullSamples,Cache->simulatedCache]]
	];

	(* Define the tests the user will see for the above message *)
	collectionSizeAndRangeBothNullTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[collectionSizeAndRangeBothNullErrorQ,
				Test["The following samples, "<>ObjectToString[failingCollectionSizeAndRangeBothNullSamples,Cache->simulatedCache]<>", have AutomaticPeakDetection option set to False, and both the CollectionSize and CollectionRange options set to Null. If AutomaticPeakDetection is False, either the CollectionSize or the CollectionRange must not be Null:",True,False],
				Nothing
			];
			passingTest=If[Length[passingCollectionSizeAndRangeBothNullSamples]>0,
				Test["The following samples have AutomaticPeakDetection, CollectionSize, and CollectionRange options which are not in conflict due to CollectionSize and CollectionRange both being set to Null when AutomaticPeakDetection is False "<>ObjectToString[passingAutomaticPeakDetectionScaleSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to make sure that the SampleLoadingVolume is not larger than allowed for the Scale (8 uL for Analytical and 50 uL for Preparative) - *)
	loadingVolumeScaleMismatchOptions=Switch[{resolvedScale,resolvedSampleLoadingVolume},

		(* If the Scale is Analytical, the SampleLoadingVolume must be equal to or less than 8 uL *)
		{Analytical,GreaterP[8*Microliter]},
			{Scale,SampleLoadingVolume},

		(* If the Scale is Preparative, the SampleLoadingVolume must be equal to or less than 50 uL *)
		{Preparative,GreaterP[50*Microliter]},
			{Scale,SampleLoadingVolume},

		(* Otherwise, there is no Mismatch *)
		{_,_},
			{}
	];

	(* Throw an Error if we are throwing messages, and there are any loadingVolumeScaleMismatchOptions *)
	If[Length[loadingVolumeScaleMismatchOptions]>0&&messages,
		Message[Error::AgaroseSampleLoadingVolumeScaleMismatch,resolvedScale,resolvedSampleLoadingVolume]
	];

	(* Define the tests the user will see for the above message *)
	loadingVolumeScaleMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[loadingVolumeScaleMismatchOptions]==0,
				Nothing,
				Test["The Scale option, "<>ToString[resolvedScale]<>", and the SampleLoadingVolume option, "<>ToString[resolvedSampleLoadingVolume]<>", are in conflict. If Scale is Analytical, the SampleLoadingVolume must be no greater than 8 uL. If the Scale is Preparative, the SampleLoadingVolume must be no greater than 50 uL:",True,False]
			];
			passingTest=If[Length[loadingVolumeScaleMismatchOptions]!=0,
				Nothing,
				Test["The Scale option and the SampleLoadingVolume option are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to make sure the LoadingDilutionBuffer and LoadingDilutionBufferVolume options are copacetic (not set with Volume of 0 uL) - *)
	(* Make a list of option tuples index matched to the SamplesIn *)
	loadingDilutionBufferOptionTuples=MapThread[
		{#1,#2}&,
		{resolvedLoadingDilutionBuffer,resolvedLoadingDilutionBufferVolume}
	];

	(* Define the tuples which are invalid *)
	failingLoadingDilutionBufferOptionTuples=Cases[loadingDilutionBufferOptionTuples,Alternatives[{Except[Null],0*Microliter},{Null,Except[0*Microliter]}]];

	(* Set a variable with the invalid options if there are any failingLoadingDilutionBufferOptionTuples *)
	invalidLoadingDilutionBufferOptions=If[Length[failingLoadingDilutionBufferOptionTuples]>0,
		{LoadingDilutionBuffer,LoadingDilutionBufferVolume},
		{}
	];

	(* Define lists of the input samples whose LoadingDilutionBuffer and LoadingDilutionBufferVolume options are in conflict *)
	failingLoadingDilutionBufferOptionSamples=PickList[simulatedSamples,loadingDilutionBufferOptionTuples,Alternatives[{Except[Null],0*Microliter},{Null,Except[0*Microliter]}]];
	passingLoadingDilutionBufferOptionSamples=PickList[simulatedSamples,loadingDilutionBufferOptionTuples,Except[Alternatives[{Except[Null],0*Microliter},{Null,Except[0*Microliter]}]]];

	(* Throw an Error if we are throwing messages, and there are any invalidLoadingDilutionBufferOptions *)
	If[Length[invalidLoadingDilutionBufferOptions]>0&&messages,
		Message[Error::AgaroseLoadingDilutionBufferMismatch,ObjectToString[failingLoadingDilutionBufferOptionSamples,Cache->simulatedCache],failingLoadingDilutionBufferOptionTuples]
	];

	(* Define the tests the user will see for the above message *)
	loadingDilutionBufferMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidLoadingDilutionBufferOptions]==0,
				Nothing,
				Test["For the following input samples, "<>ObjectToString[failingLoadingDilutionBufferOptionSamples,Cache->simulatedCache]<>", the LoadingDilutionBuffer and LoadingDilutionBufferVolume options, "<>ToString[failingLoadingDilutionBufferOptionTuples]<>", are in conflict. If LoadingDilutionBuffer is Null, the associated LoadingDilutionBufferVolume must be 0 uL. If LoadingDilutionBufferVolume is not 0 uL, the LoadingDilutionBuffer cannot be Null:",True,False]
			];
			passingTest=If[Length[passingLoadingDilutionBufferOptionSamples]==0,
				Nothing,
				Test["For the following input samples, "<>ObjectToString[passingLoadingDilutionBufferOptionSamples,Cache->simulatedCache]<>", the LoadingDilutionBuffer and LoadingDilutionBufferVolume options are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to make sure the ExtractionVolume and Scale options are copacetic - *)
	invalidExtractionScaleMismatchOptions=Switch[{resolvedScale,resolvedExtractionVolume},

		(* Case when Scale is Preparative and ExtractionVolume is Null *)
		{Preparative,Null},
			{Scale,ExtractionVolume},

		(* Case when Scale is Analytical and ExtractionVolume is not Null *)
		{Analytical,Except[Null]},
			{Scale,ExtractionVolume},

		(* All other cases are gravy *)
		{_,_},
			{}
	];

	(* Throw an Error if we are throwing messages, and there are any loadingVolumeScaleMismatchOptions *)
	If[Length[invalidExtractionScaleMismatchOptions]>0&&messages,
		Message[Error::AgaroseExtractionVolumeScaleMismatch,resolvedScale,resolvedExtractionVolume]
	];

	(* Define the tests the user will see for the above message *)
	extractionScaleMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidExtractionScaleMismatchOptions]==0,
				Nothing,
				Test["The Scale option, "<>ToString[resolvedScale]<>", and the ExtractionVolume option, "<>ToString[resolvedExtractionVolume]<>", are in conflict. If the Scale is Analytical, the ExtractionVolume must be Null. If the Scale is Preparative, the ExtractionVolume cannot be Null:",True,False]
			];
			passingTest=If[Length[invalidExtractionScaleMismatchOptions]!=0,
				Nothing,
				Test["The Scale option and the ExtractionVolume option are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to make sure that, if the Gel option has been specified, the specified gel matches the various resolved options - *)
	(* First, lookup the relevant fields from the gelPacket if necessary  *)
	{specifiedGelPercentage,specifiedGelMaterial,specifiedGelNumberOfLanes}=If[

		(* IF the Gel option was left as Automatic *)
		MatchQ[gelPacket,{}],

		(* THEN we set all of these variables to Automatic *)
		{Automatic,Automatic,Automatic},

		(* ELSE we look them up from the gelPacket *)
		{Lookup[First[Flatten[gelPacket]],GelPercentage,Null],Lookup[First[Flatten[gelPacket]],GelMaterial,Null],Lookup[First[Flatten[gelPacket]],NumberOfLanes,Null]}
	];

	(* Then, define the invalid options if necessary *)
	invalidGelOptionMismatchOptions=Which[

		(* The case where the Gel was left as Automatic, don't need to do these checks *)
		MatchQ[gelPacket,{}],
			{},

		(* In other cases, we need to do checks *)
		(* In the case where the specified Gel's Material is Agarose *)
		MatchQ[specifiedGelMaterial,Agarose]&&

		(* AND The specified Gel's Percentage is the same as the AgarosePercentage Option *)
		EqualQ[specifiedGelPercentage,resolvedAgarosePercentage]&&

		(* AND the specifiedGelNumberOfLanes is cool with the resolvedScale *)
		If[
			(* IF the Scale is Preparative *)
			MatchQ[resolvedScale,Preparative],
			(* THEN we need to check to make sure the Gel's NumberOfLanes is 12 *)
			MatchQ[specifiedGelNumberOfLanes,12],
			(* ELSE, we need to check to make sure that the Gel's NumberOfLanes is 24 *)
			MatchQ[specifiedGelNumberOfLanes,24]
		],
			(* If all the above conditions are true, then the options are cool *)
			{},

		(* Otherwise, the options are in conflict *)
		True,
			{Gel,Scale,AgarosePercentage}
	];

	(* Throw an Error if we are throwing messages, and there are any loadingVolumeScaleMismatchOptions *)
	If[Length[invalidGelOptionMismatchOptions]>0&&messages,
		Message[Error::AgaroseGelOptionsMismatch,resolvedGel,resolvedScale,resolvedAgarosePercentage]
	];

	(* Define the tests the user will see for the above message *)
	gelOptionMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidGelOptionMismatchOptions]==0,
				Nothing,
				Test["The Gel option, "<>ObjectToString[resolvedGel,Cache->simulatedCache]<>", either has a GelMaterial that is not Agarose, and/or is in conflict with the Scale option, "<>ToString[resolvedScale]<>", or the AgarosePercentage option, "<>ToString[resolvedAgarosePercentage]<>". The GelPercentage of the Gel must match the AgarosePercentage option, and the NumberOfLanes of the Gel must be 12 if Scale is Preparative, or 24 if Scale is Analytical:",True,False]
			];
			passingTest=If[Length[invalidGelOptionMismatchOptions]!=0,
				Nothing,
				Test["The Gel option is not in conflict with either the Scale or the AgarosePercentage options:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to make sure that the resolvedLadder is Null if Scale is Preparative, and is set otherwise - *)
	invalidLadderOptions=Switch[{resolvedScale,resolvedLadder},

		(* Invalid - case where the Scale is Preparative and the resolvedLadder is specified *)
		{Preparative,Except[Null]},
			{Scale,Ladder},

		(* Invalid - case where the Scale is Analytical and the resolvedLadder is Null *)
		{Analytical,Null},
			{Scale,Ladder},

		(* Valid - all other cases *)
		{_,_},
			{}
	];

	(* If there are any invalidLadderOptions and we are throwing messages, throw an Error *)
	If[Length[invalidLadderOptions]>0&&messages,
		Message[Error::InvalidAgaroseLadder,resolvedScale,resolvedLadder]
	];

	(* Define the tests the user will see for the above message *)
	ladderScaleMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidLadderOptions]==0,
				Nothing,
				Test["The Scale option, "<>ToString[resolvedScale]<>", and the Ladder option, "<>ObjectToString[resolvedLadder,Cache->simulatedCache]<>", are in conflict.  The Ladder must be Null if the Scale is Preparative, and must not be Null if the Scale is Analytical. Please consider letting these options automatically resolve:",True,False]
			];
			passingTest=If[Length[invalidLadderOptions]!=0,
				Nothing,
				Test["The Scale option and the Ladder option are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to make sure that the resolvedLadderFrequency is Null if Scale is Preparative, and is set otherwise - *)
	invalidLadderFrequencyOptions=Switch[{resolvedScale,resolvedLadderFrequency},

		(* Invalid - case where the Scale is Preparative and the resolvedLadderFrequency is specified *)
		{Preparative,Except[Null]},
		{Scale,LadderFrequency},

		(* Invalid - case where the Scale is Analytical and the resolvedLadderFrequency is Null *)
		{Analytical,Null},
		{Scale,LadderFrequency},

		(* Valid - all other cases *)
		{_,_},
		{}
	];

	(* If there are any invalidLadderFrequencyOptions and we are throwing messages, throw an Error *)
	If[Length[invalidLadderFrequencyOptions]>0&&messages,
		Message[Error::InvalidAgaroseLadderFrequency,resolvedScale,resolvedLadderFrequency]
	];

	(* Define the tests the user will see for the above message *)
	ladderFrequencyScaleMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidLadderFrequencyOptions]==0,
				Nothing,
				Test["The Scale option, "<>ToString[resolvedScale]<>", and the LadderFrequency option, "<>ObjectToString[resolvedLadderFrequency,Cache->simulatedCache]<>", are in conflict.  The LadderFrequency must be Null if the Scale is Preparative, and must not be Null if the Scale is Analytical. Please consider letting these options automatically resolve:",True,False]
			];
			passingTest=If[Length[invalidLadderFrequencyOptions]!=0,
				Nothing,
				Test["The Scale option and the LadderFrequency option are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];
	(* - Throw Error here if any of the resolvedPeakDetectionRange(s) are Spans where the two ends are identical (instrument software will barf on this) - *)
	(* First, find the ResolvePeakDetectionRanges that are Spans (all the things that arent Null *)
	nonNullResolvedPeakDetectionRanges=Cases[resolvedPeakDetectionRange,_Span];

	(* Find the associated SamplesIn *)
	nonNullResolvedPeakDetectionRangeSamples=PickList[simulatedSamples,resolvedPeakDetectionRange,_Span];

	(* From the list of non-Null ResolvedPeakDetectionRanges, pick the ones that are invalid (same thing listed twice) *)
	failingPatternPeakDetectionRanges=Cases[nonNullResolvedPeakDetectionRanges,Span[x_,x_]];

	(* Make a list of the failing SamplesIn *)
	failingPatternPeakDetectionRangeSamples=PickList[nonNullResolvedPeakDetectionRangeSamples,nonNullResolvedPeakDetectionRanges,Span[x_,x_]];

	(* Make a list of the non-Null PeakDetectionRanges that are valid *)
	passingPatternPeakDetectionRanges=Cases[nonNullResolvedPeakDetectionRanges,Except[Span[x_,x_]]];

	(* Make a list of the passing SamplesIn *)
	passingPatternPeakDetectionRangeSamples=PickList[nonNullResolvedPeakDetectionRangeSamples,nonNullResolvedPeakDetectionRanges,Except[Span[x_,x_]]];

	(* Create an invalid Option variable for the following Error *)
	invalidPDRPatternOptions=If[Length[failingPatternPeakDetectionRanges]>0,
		{PeakDetectionRange},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are any invalidLoadingDilutionBufferOptions *)
	If[Length[failingPatternPeakDetectionRanges]>0&&messages,
		Message[Error::InvalidAgarosePeakDetectionRange,ObjectToString[failingPatternPeakDetectionRangeSamples,Cache->simulatedCache],failingPatternPeakDetectionRanges]
	];

	(* Define the tests the user will see for the above message *)
	peakDetectionRangePatternTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[failingPatternPeakDetectionRanges]>0,
				Test["The following samples, "<>ObjectToString[failingPatternPeakDetectionRangeSamples,Cache->simulatedCache]<>", have PeakDetectionRange options, "<>ToString[failingPatternPeakDetectionRanges]<>", which are invalid. The PeakDetectionRange cannot have the same value listed as the start and the end of the range. Please consider setting the CollectionSize option instead, or letting the PeakDetectionRange automatically resolve:",True,False],
				Nothing
			];
			passingTest=If[Length[passingPatternPeakDetectionRanges]>0,
				Test["The following samples have PeakDetectionRange options which are valid, "<>ObjectToString[passingPatternPeakDetectionRangeSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw Error here if any of the resolvedCollectionRange(s) are Spans where the two ends are identical (instrument software will barf on this) - *)
	(* First, find the ResolveCollectionRanges that are Spans (all the things that arent Null *)
	nonNullResolvedCollectionRanges=Cases[resolvedCollectionRange,_Span];

	(* Find the associated SamplesIn *)
	nonNullResolvedCollectionRangeSamples=PickList[simulatedSamples,resolvedCollectionRange,_Span];

	(* From the list of non-Null ResolvedCollectionRanges, pick the ones that are invalid (same thing listed twice) *)
	failingPatternCollectionRanges=Cases[nonNullResolvedCollectionRanges,Span[x_,x_]];

	(* Make a list of the failing SamplesIn *)
	failingPatternCollectionRangeSamples=PickList[nonNullResolvedCollectionRangeSamples,nonNullResolvedCollectionRanges,Span[x_,x_]];

	(* Make a list of the non-Null CollectionRanges that are valid *)
	passingPatternCollectionRanges=Cases[nonNullResolvedCollectionRanges,Except[Span[x_,x_]]];

	(* Make a list of the passing SamplesIn *)
	passingPatternCollectionRangeSamples=PickList[nonNullResolvedCollectionRangeSamples,nonNullResolvedCollectionRanges,Except[Span[x_,x_]]];

	(* Create an invalid Option variable for the following Error *)
	invalidCollectionRangePatternOptions=If[Length[failingPatternCollectionRanges]>0,
		{CollectionRange},
		{}
	];

	(* Throw an Error if we are throwing messages, and there are any invalidLoadingDilutionBufferOptions *)
	If[Length[failingPatternCollectionRanges]>0&&messages,
		Message[Error::InvalidAgaroseCollectionRange,ObjectToString[failingPatternCollectionRangeSamples,Cache->simulatedCache],failingPatternCollectionRanges]
	];

	(* Define the tests the user will see for the above message *)
	collectionRangeRangePatternTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[failingPatternCollectionRanges]>0,
				Test["The following samples, "<>ObjectToString[failingPatternCollectionRangeSamples,Cache->simulatedCache]<>", have CollectionRange options, "<>ToString[failingPatternCollectionRanges]<>", which are invalid. The CollectionRange cannot have the same value listed as the start and the end of the range. Please consider setting the CollectionSize option instead, or letting the CollectionRange automatically resolve:",True,False],
				Nothing
			];
			passingTest=If[Length[passingPatternCollectionRanges]>0,
				Test["The following samples have CollectionRange options which are valid, "<>ObjectToString[passingPatternCollectionRangeSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Throw Warnings if the CollectionSize, or no part of the PeakDetectionRange or CollecitonRange are within the LoadingDye size range only for Preparative -- *)
	(* We are going to create two ReplaceRule lists. one to turn all of the resolvedLoadingDyes into Models by ID, and another to the Length of those Models *)
	(* - First, we need to figure out which Model any loading dyes that were specified are - *)
	(* Find the Models of all unique Objects that have been input as LoadingDyes *)
	loadingDyeObjectModels=If[
		MatchQ[#,Null],
		Null,
		Lookup[#,Object]
	]&/@Flatten[listedLoadingDyeObjectPackets];

	(* Define the ReplaceRules for the Objects/Models with names to Model by ID, and for any Models by Name we may have resolved to *)
	loadingDyeModelReplaceRules=Join[
		If[Length[uniqueObjectLoadingDyes]>0,
			MapThread[
				If[
					MatchQ[#2,Null],
					(#1->Null),
					(#1->#2)
				]&,
				{uniqueObjectLoadingDyes,loadingDyeObjectModels}
			],
			{}
		],
		If[Length[uniqueModelLoadingDyes]>0,
			MapThread[
				(#1->#2)&,
				{uniqueModelLoadingDyes,Lookup[Flatten[listedLoadingDyeModelPackets],Object]}
			],
			{}
		],
		MapThread[
			(#1->#2)&,
			{{Model[Sample,"100 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample,"200 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample,"300 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample,"500 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample,"1000 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample,"1500 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample,"2000 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample,"3000 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample,"5000 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample,"7000 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample,"10000 bp dyed loading buffer for agarose gel electrophoresis"]},{Model[Sample,"id:o1k9jAGq4WnG"],Model[Sample,"id:zGj91a7PrxAj"],Model[Sample,"id:lYq9jRx40W8O"],Model[Sample,"id:L8kPEjnm3oAA"],Model[Sample,"id:E8zoYvN4XJV5"],Model[Sample,"id:Y0lXejM9pxOx"],Model[Sample,"id:kEJ9mqRpW5Gp"],Model[Sample,"id:P5ZnEjdmK6r0"],Model[Sample,"id:3em6ZvL1zxA8"],Model[Sample,"id:D8KAEvGp4R5m"],Model[Sample,"id:aXRlGn6kPKav"]}}
		]
	];

	(* Another hard coded replace rule list - in future with more time can get this from the download of all AgaroseLoadingDyeP - this time replacing Models with Intergers *)
	loadingDyeLengthReplaceRules=MapThread[
		(#1->#2)&,
		{{Model[Sample,"id:o1k9jAGq4WnG"],Model[Sample,"id:zGj91a7PrxAj"],Model[Sample,"id:lYq9jRx40W8O"],Model[Sample,"id:L8kPEjnm3oAA"],Model[Sample,"id:E8zoYvN4XJV5"],Model[Sample,"id:Y0lXejM9pxOx"],Model[Sample,"id:kEJ9mqRpW5Gp"],Model[Sample,"id:P5ZnEjdmK6r0"],Model[Sample,"id:3em6ZvL1zxA8"],Model[Sample,"id:D8KAEvGp4R5m"],Model[Sample,"id:aXRlGn6kPKav"]},{100,200,300,500,1000,1500,2000,3000,5000,7000,10000}(BasePair)}
	];

	(* - Use these two ReplaceRules in sequence to get the resovledLoadingDyes as lists of Lengths. (any of the wrong Model will still be objects and will be filtered out in next steps) - *)
	loadingDyesByModelIDs=resolvedLoadingDye/.loadingDyeModelReplaceRules;
	loadingDyesByLengths=loadingDyesByModelIDs/.loadingDyeLengthReplaceRules;

	(* - Get the LoadingDye Options that are comprised of two acceptable loading dyes, and the corresponding simulatedSamples, resolvedPeakDetectionRanges *)
	twoLoadingDyeLengths=If[MatchQ[resolvedScale,Preparative],
		Cases[loadingDyesByLengths,{_Quantity,_Quantity}],
		{}
	];
	twoLoadingDyeOptions=If[MatchQ[resolvedScale,Preparative],
		PickList[resolvedLoadingDye,loadingDyesByLengths,{_Quantity,_Quantity}],
		{}
	];
	twoLoadingDyeSamples=If[MatchQ[resolvedScale,Preparative],
		PickList[simulatedSamples,loadingDyesByLengths,{_Quantity,_Quantity}],
		{}
	];

	(* - When the Scale is Preparative, create a list index matched to simulatedSamples that is either the PeakDetectionRange, the CollectionSize, or the CollecitonRange symbol - *)
	collectionOptions=If[MatchQ[resolvedScale,Preparative],
		MapThread[
			Which[
				MatchQ[#1,Except[Null]],
				PeakDetectionRange,
				MatchQ[#2,Except[Null]],
				CollectionSize,
				MatchQ[#3,Except[Null]],
				CollectionRange
			]&,
			{resolvedPeakDetectionRange,resolvedCollectionSize,resolvedCollectionRange}
		],
		{}
	];

	(* - When the Scale is Preparative, create a list index matched to simulatedSamples that is either the PeakDetectionRange, the CollectionSize, or the CollecitonRange, as the resolved Option - *)
	collectionOptionValues=If[MatchQ[resolvedScale,Preparative],
		MapThread[
			Which[
				MatchQ[#1,Except[Null]],
				#1,
				MatchQ[#2,Except[Null]],
				#2,
				MatchQ[#3,Except[Null]],
				#3
			]&,
			{resolvedPeakDetectionRange,resolvedCollectionSize,resolvedCollectionRange}
		],
		{}
	];

	(* - When the Scale is Preparative, create a list index matched to simulatedSamples that is either the PeakDetectionRange, the CollectionSize, or the CollecitonRange, as a list of Quantities - *)
	collectionOptionListedValues=If[MatchQ[resolvedScale,Preparative],
		MapThread[
			Which[
				MatchQ[#1,Except[Null]],
					{First[#1],Last[#1]},
				MatchQ[#2,Except[Null]],
					{#2},
				MatchQ[#3,Except[Null]],
					{First[#3],Last[#3]}
			]&,
			{resolvedPeakDetectionRange,resolvedCollectionSize,resolvedCollectionRange}
		],
		{}
	];

	(* Get the collectionOptions for samples that have two LoadingDyes *)
	twoLoadingDyeCollectionOptions=If[MatchQ[resolvedScale,Preparative],
		PickList[collectionOptions,loadingDyesByLengths,{_Quantity,_Quantity}],
		{}
	];

	(* Get the collectionOptionValues for samples that have two LoadingDyes - will use these for warning messages / tests *)
	twoLoadingDyeCollectionOptionValues=If[MatchQ[resolvedScale,Preparative],
		PickList[collectionOptionValues,loadingDyesByLengths,{_Quantity,_Quantity}],
		{}
	];

	(* Get the collectionOptionListedValues for samples that have two LoadingDyes - will test these against the loading dye range pattern *)
	twoLoadingDyeCollectionOptionListedValues=If[MatchQ[resolvedScale,Preparative],
		PickList[collectionOptionListedValues,loadingDyesByLengths,{_Quantity,_Quantity}],
		{}
	];

	(* - When the Scale is Preparative, we want to check each of the ends of a Span, or the CollectionSize, is within the range of the LoadingDye sizes, when there are two loading dyes - *)
	(* Make a list of the Ranges of the sizes of the LoadingDyes when there are two loadingDyes *)
	twoLoadingDyeRanges=RangeP[First[Sort[#]],Last[Sort[#]]]&/@twoLoadingDyeLengths;

	(* - Here we are going to check whether each member of the list of twoLoadingDyeOptionVales falls within the corresponding twoLoadingDyeRanges - *)
	listOfLoadingDyeCollectionOptionMismatchBools=MapThread[
		Function[{innerCollectionOptionValues,rangePattern},
			Map[
				Not[MatchQ[#,rangePattern]]&,
				innerCollectionOptionValues
			]
		],
		{twoLoadingDyeCollectionOptionListedValues,twoLoadingDyeRanges}
	];

	(* - With this information, we are going to find the simulatedSamples, collection related Options, their values - *)
	(* simulatedSamples *)
	failingLoadingDyeCollectionMismatchSamples=PickList[twoLoadingDyeSamples,listOfLoadingDyeCollectionOptionMismatchBools,{True..}];
	passingLoadingDyeCollectionMismatchSamples=PickList[twoLoadingDyeSamples,listOfLoadingDyeCollectionOptionMismatchBools,Except[{True..}]];

	(* Collection-related Options *)
	failingLoadingDyeCollectionMismatchOptionNames=PickList[twoLoadingDyeCollectionOptions,listOfLoadingDyeCollectionOptionMismatchBools,{True..}];
	passingLoadingDyeCollectionMismatchOptionNames=PickList[twoLoadingDyeCollectionOptions,listOfLoadingDyeCollectionOptionMismatchBools,Except[{True..}]];

	(* Collection-related Option Values *)
	failingLoadingDyeCollectionMismatchOptionValues=PickList[twoLoadingDyeCollectionOptionValues,listOfLoadingDyeCollectionOptionMismatchBools,{True..}];
	passingLoadingDyeCollectionMismatchOptionValues=PickList[twoLoadingDyeCollectionOptionValues,listOfLoadingDyeCollectionOptionMismatchBools,Except[{True..}]];

	(* LoadingDye Options *)
	failingLoadingDyeCollectionMismatchLoadingDyes=PickList[twoLoadingDyeOptions,listOfLoadingDyeCollectionOptionMismatchBools,{True..}];
	passingLoadingDyeCollectionMismatchLoadingDyes=PickList[twoLoadingDyeOptions,listOfLoadingDyeCollectionOptionMismatchBools,Except[{True..}]];

	(* - Whew, after all of that, throw a Warning if there are any failing Samples / OptionNames / OptionValues - *)
	(* Throw a warning message if we are throwing messages, and there are some input samples that caused moreThanTwoLoadingDyesWarnings to be set to True *)
	If[Length[failingLoadingDyeCollectionMismatchSamples]>0&&messages&&notInEngine,
		Message[Warning::AgaroseLoadingDyeRangeCollectionOptionMismatch,ObjectToString[failingLoadingDyeCollectionMismatchSamples,Cache->simulatedCache],failingLoadingDyeCollectionMismatchOptionNames,failingLoadingDyeCollectionMismatchOptionValues,ObjectToString[failingLoadingDyeCollectionMismatchLoadingDyes,Cache->simulatedCache]]
	];

	(* Define the tests the user will see for the above message *)
	loadingDyeCollectionMisMatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[failingLoadingDyeCollectionMismatchSamples]>0,
				Warning["For the following input samples, "<>ObjectToString[failingLoadingDyeCollectionMismatchSamples,Cache->simulatedCache]<>", The corresponding collection-related Options, "<>ToString[failingLoadingDyeCollectionMismatchOptionNames]<>", have values, "<>ToString[failingLoadingDyeCollectionMismatchOptionValues]<>", which are outside of the range of Oligomer sizes present in the corresponding LoadingDye options, "<>ObjectToString[failingLoadingDyeCollectionMismatchLoadingDyes,Cache->simulatedCache]<>". Most accurate sizing and collection is achieved when the target of interest is between the size of the two LoadingDyes:",True,False],
				Nothing
			];
			passingTest=If[Length[passingLoadingDyeCollectionMismatchSamples]>0,
				Warning["The collection-related options are within the size range of the specified LoadingDyes for the following input samples, "<>ObjectToString[passingLoadingDyeCollectionMismatchSamples,Cache->simulatedCache]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*collect invalid storage condition option using helper function*)
	specifiedSampleStorageCondition=Lookup[allOptionsRounded,SamplesInStorageCondition];
	validSampleStorageConditionQ=If[!MatchQ[specifiedSampleStorageCondition,
		ListableP[Automatic|Null]],
		If[messages,
			ValidContainerStorageConditionQ[mySamples,specifiedSampleStorageCondition],
			Quiet[ValidContainerStorageConditionQ[mySamples,specifiedSampleStorageCondition]]],True
	];

	(*if the test above passes,there's no invalid option,otherwise,SamplesInStorageCondition will be an invalid option*)
	invalidStorageConditionOptions=If[Not[And@@validSampleStorageConditionQ],
		{SamplesInStorageCondition},{}];

	(*generate test for storage condition*)
	invalidStorageConditionTest=If[gatherTests,
		Test["The specified SamplesInStorageCondition can be filled for sample in a particular container or for samples sharing a container:",
			And@@validSampleStorageConditionQ,True],
		Nothing
	];

	(* -- Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. -- *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,tooManyInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[
		{
			invalidLoadingDyeModelOptions,invalidTooManyLoadingDyesOptions,nameInvalidOption,invalidSampleLoadingOptions,invalidCollectionScaleMismatchOptions,
			invalidUnableToDetermineCollectionOptions,loadingVolumeScaleMismatchOptions,invalidLoadingDilutionBufferOptions,invalidExtractionScaleMismatchOptions,
			invalidGelOptionMismatchOptions,invalidLadderOptions,invalidLadderFrequencyOptions,	invalidAPDScaleMismatchOptions,invalidAPDPeakDetectionRangeMismatchOptions,
			invalidAPDCollectionRangeMismatchOptions,invalidPDWScaleMismatchOptions,invalidPeakDetectionRangeCollectionMismatchOptions,	invalidCollectionRangeScaleMismatchOptions,
			invalidAPDCollectionSizeMismatchOptions,invalidUnableToDeterminePeakDetectionRangeOptions,invalidCollectionSizeRangeMismatchOptions,
			invalidUnableToDetermineCollectionRangeOptions,invalidCollectionSizeAndRangeBothNullOptions,invalidPDRPatternOptions,invalidCollectionRangePatternOptions,invalidStorageConditionOptions,
			invalidMultipleGelObjectModelOptions,invalidNumberOfGelsOptions,invalidDuplicateGelOptions
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
	requiredAliquotAmounts=(resolvedSampleVolume+10*Microliter);
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
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,

		(* Case where output includes tests *)
		resolveAliquotOptions[
			ExperimentAgaroseGelElectrophoresis,
			mySamples,
			simulatedSamples,
			ReplaceRule[allOptionsRounded,resolvedSamplePrepOptions],
			Cache->simulatedCache,
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
			Output->{Result,Tests}
		],

		(* Case where we are not gathering tests  *)
		{
			resolveAliquotOptions[
				ExperimentAgaroseGelElectrophoresis,
				mySamples,
				simulatedSamples,
				ReplaceRule[allOptionsRounded,resolvedSamplePrepOptions],
				Cache->simulatedCache,
				RequiredAliquotContainers->requiredAliquotContainers,
				RequiredAliquotAmounts->requiredAliquotAmounts,
				AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
				Output->Result
			],{}
		}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[allOptionsRounded];

	(* get the resolved Email option; for this experiment. the default is True *)
	email=If[MatchQ[Lookup[allOptionsRounded,Email],Automatic],
		True,
		Lookup[allOptionsRounded,Email]
	];

	(* - Define the resolved options that we will output - *)
	resolvedOptions=ReplaceRule[
		allOptionsRounded,
		Join[
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			{
				AgarosePercentage->resolvedAgarosePercentage,
				Scale->resolvedScale,
				Gel->resolvedGel,
				Ladder->resolvedLadder,
				LadderStorageCondition->If[unnecessaryLadderStorageConditionQ,
					Null,
					Lookup[experimentOptionsAssociation,LadderStorageCondition]
				],
				LadderFrequency->resolvedLadderFrequency,
				DutyCycle->resolvedDutyCycle,
				SeparationTime->resolvedSeparationTime,
				ExtractionVolume->resolvedExtractionVolume,
				SampleLoadingVolume->resolvedSampleLoadingVolume,
				SampleVolume->resolvedSampleVolume,
				LoadingDye->resolvedLoadingDye,
				LoadingDyeVolume->resolvedLoadingDyeVolume,
				LoadingDilutionBuffer->resolvedLoadingDilutionBuffer,
				LoadingDilutionBufferVolume->resolvedLoadingDilutionBufferVolume,
				AutomaticPeakDetection->resolvedAutomaticPeakDetection,
				CollectionSize->resolvedCollectionSize,
				PeakDetectionRange->resolvedPeakDetectionRange,
				CollectionRange->resolvedCollectionRange
			}
		],
		Append->False
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> Cases[
			Flatten[
				{
					optionPrecisionTests,discardedTests,validNameTest,invalidLoadingDyeTests,compatibleMaterialsTests,tooManyInputsTests,moreThanTwoLoadingDyesTests,onlyOneLoadingDyeTests,sampleLoadingVolumeTooLargeTests,collectionScaleMismatchTests,
					unableToDetermineCollectionSizeTests,loadingVolumeScaleMismatchTests,loadingDilutionBufferMismatchTests,extractionScaleMismatchTests,gelOptionMismatchTests,ladderScaleMismatchTests,
					ladderFrequencyScaleMismatchTests,automaticPeakDetectionScaleMismatchTests,automaticPeakDetectionRangeMismatchTests,automaticPeakDetectionCollectionRangeMismatchTests,peakDetectionRangeScaleMismatchTests,
					peakDetectionRangeCollectionRangeMismatchTests,collectionRangeScaleMismatchTests,automaticPeakDetectionCollectionSizeMismatchTests,unableToDeterminePeakDetectionRangeTests,invalidStorageConditionTest,
					collectionSizeCollectionRangeMismatchTests,unableToDetermineCollectionRangeTests,collectionSizeAndRangeBothNullTests,peakDetectionRangePatternTests,collectionRangeRangePatternTests,loadingDyeCollectionMisMatchTests,ladderStorageConditionTest,
					multipleGelObjectModelTests,invalidNumberOfGelsTests,duplicateGelObjectsTests,aliquotTests
				}
			]
			,_EmeraldTest
		]
	}
];


(* ::Subsection:: *)
(*agaroseGelElectrophoresisResourcePackets*)

DefineOptions[
	agaroseGelElectrophoresisResourcePackets,
	Options:>{HelperOutputOption,CacheOption}
];


(* create the protocol packet with resource blobs included *)
agaroseGelElectrophoresisResourcePackets[mySamples:ListableP[ObjectP[Object[Sample]]],myTemplatedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages,inheritedCache,protocolID,liquidHandlerContainers,
		numberOfReplicates,instrument,name,scale,agarosePercentage,gel,ladder,ladderFrequency,sampleVolume,loadingDye,loadingDyeVolume,loadingDilutionBuffer,loadingDilutionBufferVolume,automaticPeakDetections,peakDetectionRanges,
		collectionSizes,collectionRanges,samplesOutStorageCondition,sampleLoadingVolume,separationTime,dutyCycle,extractionVolume,parentProtocol,gelDownloadFields,
		listedSampleContainers,liquidHandlerContainerDownload,gelDownload,gelPacket,sampleContainersIn,liquidHandlerContainerMaxVolumes,samplesWithReplicates,optionsWithReplicates,
		expandedAliquotAmounts,expandedSampleVolumes,expandedLoadingDye,expandedLoadingDyeVolume,expandedLoadingDilutionBuffer,expandedLoadingDilutionBufferVolume,expandedSamplesInStorage,
		expandedSampleOrAliquotVolumes, sampleVolumeRules,uniqueSampleVolumeRules,sampleResourceReplaceRules,
		numberOfExpandedSamples,numberOfLadders,numberOfLanes,gelNumberPerSampleLane,numberOfGels,
		sampleLanesPerGel,gelResources,expandedGelResources,ladderVolumeRule,ladderVolume,loadingDilutionBufferVolumeRules,allVolumeRules,uniqueObjectsAndVolumesAssociation,uniqueResources,uniqueObjects,
		uniqueObjectResourceReplaceRules,samplesInResources,loadingDilutionBufferResources,ladderResource,
		noSingleLoadingDyes,flattenedExpandedLoadingDyeVolumes,loadingDyeVolumeRules,primaryLoadingDyes,secondaryLoadingDyes,ladderLoadingDyes,ladderLoadingDyeVolume,ladderLoadingDyeVolumeRules,
		allLoadingDyeVolumeRules,uniqueLoadingDyeObjectsAndVolumesAssociation,uniqueLoadingDyeResources,uniqueLoadingDyeObjects,uniqueLoadingDyeObjectResourceReplaceRules,ladderLoadingDyeResources,
		primaryLoadingDyeResources,secondaryLoadingDyeResources,instrumentResource,gelMaterial,gelPercentage,gelModel,destinationPlateResource,primaryPipettteTipsResource,secondaryPipetteTipsResource,
		electrophoresisTimeEstimate,minPeakDetectionSizes,maxPeakDetectionSizes,minCollectionRangeSizes,maxCollectionRangeSizes,
		protocolPacket,prepPacket,finalizedPacket,allResourceBlobs,resourcesOk,resourceTests,previewRule,optionsRule,testsRule,resultRule
	},

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentAgaroseGelElectrophoresis, {mySamples}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentAgaroseGelElectrophoresis,
		RemoveHiddenOptions[ExperimentAgaroseGelElectrophoresis, myResolvedOptions],
		Ignore -> myTemplatedOptions,
		Messages -> False
	];

	(* pull out the Output option and make it a list *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* get the inherited cache *)
	inheritedCache = Lookup[ToList[ops],Cache];

	(* Generate an ID for the new protocol *)
	protocolID=CreateID[Object[Protocol,AgaroseGelElectrophoresis]];

	(* Get all containers which can fit on the liquid handler - many of our resources are in one of these containers *)
	(* In case we need to prepare the resource add 0.5mL tube in 2 mL skirt to the beginning of the list (Engine uses the first requested container if it has to transfer or make a stock solution) *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* Pull out relevant non-index matched options from the re-expanded options *)
	{
		numberOfReplicates,instrument,name,scale,agarosePercentage,gel,ladder,ladderFrequency,sampleVolume,loadingDye,loadingDyeVolume,loadingDilutionBuffer,loadingDilutionBufferVolume,sampleLoadingVolume,separationTime,
		dutyCycle,extractionVolume,parentProtocol
	}=
     Lookup[expandedResolvedOptions,
			 {
				 NumberOfReplicates,Instrument,Name,Scale,AgarosePercentage,Gel,Ladder,LadderFrequency,SampleVolume,LoadingDye,LoadingDyeVolume,LoadingDilutionBuffer,LoadingDilutionBufferVolume,SampleLoadingVolume,
				 SeparationTime,DutyCycle,ExtractionVolume,ParentProtocol
			 },
			 Null
		 ];

	(* Define which fields we want to download from the Gel option based on if it is an Object or a Model *)
	gelDownloadFields=If[

		(* IF Gel is an object or list of Objects *)
		MatchQ[gel,Alternatives[ObjectP[Object[Item,Gel]],{ObjectP[Object[Item,Gel]]..}]],

		(* THEN download fields from the Model *)
		Packet[Model[{Object,GelPercentage,GelMaterial}]],

		(* ELSE just download fields *)
		Packet[Object,GelPercentage,GelMaterial]
	];

	(* - Make a Download call to get the containers of the input samples - *)
	{listedSampleContainers,liquidHandlerContainerDownload,gelDownload}=Quiet[
		Download[
			{
				mySamples,
				liquidHandlerContainers,
				ToList[gel]
			},
			{
				{Container[Object]},
				{MaxVolume},
				{gelDownloadFields}
			},
			Cache->inheritedCache,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* Gel Packet *)
	gelPacket=First[Flatten[gelDownload]];

	(* Find the list of input sample and antibody containers *)
	sampleContainersIn=DeleteDuplicates[Flatten[listedSampleContainers]];

	(* Find the MaxVolume of all of the liquid handler compatible containers *)
	liquidHandlerContainerMaxVolumes=Flatten[liquidHandlerContainerDownload,1];

	(* -- Expand inputs and index-matched options to take into account the NumberOfReplicates option -- *)
	(* - Expand the index-matched inputs for the NumberOfReplicates - *)
	{samplesWithReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentAgaroseGelElectrophoresis,mySamples,expandedResolvedOptions];

	{
		expandedAliquotAmounts,expandedSampleVolumes,expandedLoadingDye,expandedLoadingDyeVolume,expandedLoadingDilutionBuffer,expandedLoadingDilutionBufferVolume,expandedSamplesInStorage,automaticPeakDetections,
		peakDetectionRanges,collectionSizes,collectionRanges,samplesOutStorageCondition
	}=
			Lookup[optionsWithReplicates,
				{
					AliquotAmount,SampleVolume,LoadingDye,LoadingDyeVolume,LoadingDilutionBuffer,LoadingDilutionBufferVolume,SamplesInStorageCondition,AutomaticPeakDetection,PeakDetectionRange,CollectionSize,CollectionRange,
					SamplesOutStorageCondition
				},
				Null
			];

	(* --- To make resources, we need to find the input Objects and Models that are unique, and to request the total volume of them that is needed --- *)
	(* --  For each input or option object/volume pair, make a list of rules - ask for a bit more than requested in the cases it makes sense to, to take into account dead volumes etc -- *)
	(* - First, we need to make a list of volumes that are index matched to the expanded samples in, with the SampleVolume if no Aliquotting is occurring, or the AliquotAmount if Aliquotting is happening - *)
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

	(* - Figure out how many Gels and Ladder lanes are needed - *)
	(* The below depends on how many lanes we are using for the gel: 12 for Preparative (all samples) and 24 for Analytical (23 sample and 1 ladder) *)
	(* Get the number of ladder lanes needed *)
	(* First, figure out how many samples we have *)
	numberOfExpandedSamples=Length[samplesWithReplicates];

	(* Get the number of ladder lanes needed *)
	numberOfLadders=If[

		(* IF the Scale is Preparative *)
		MatchQ[scale,Preparative],

		(* THEN it is 0 since there are no preparative ladders*)
		0,

		(* ELSE, the number of ladder lanes is the number of expanded samples divided by 23 if LadderFrequency is First, or divided by 11 if ladderFrequency is FirstAndLast rounded up *)
		If[MatchQ[ladderFrequency, FirstAndLast],
			Ceiling[numberOfExpandedSamples/22]*2,
			Ceiling[numberOfExpandedSamples/23]
		]
	];

	(* Find the number of lanes that will be run during the experiment *)
	numberOfLanes=numberOfExpandedSamples+numberOfLadders;

	(* get the gel number for each lane that has a sample in it *)
	gelNumberPerSampleLane=If[

		(* IF the Scale is Preparative *)
		MatchQ[scale,Preparative],

		(* THEN we have 12 sample lanes per gel *)
		Ceiling[Range[numberOfExpandedSamples]/12],

		(* ELSE, we have 23 sample lanes per gel if one ladder per gel, and 22 if two ladders per gel *)
		If[MatchQ[ladderFrequency, FirstAndLast],
			Ceiling[Range[numberOfExpandedSamples]/22],
			Ceiling[Range[numberOfExpandedSamples]/23]
		]
	];

	(* Figure out how many Gels will be run *)
	numberOfGels=Max[gelNumberPerSampleLane];

	(* Get the number of samples (not including ladders) that go in each gel as a list of the same length as the number of gels *)
	sampleLanesPerGel=Tally[gelNumberPerSampleLane][[All,2]];

	(* Create resources for the necessary gels *)
	gelResources=If[MatchQ[gel,Except[_List]],
		Link[Resource[Sample->gel,Name->ToString[Unique[]]]]&/@Range[numberOfGels],
		Link[Resource[Sample->#,Name->ToString[Unique[]]]]&/@gel
	];

	(* Duplicate the gel resources for the number of samples in each of the gels, then Flatten it all together (so that the resulting list is index-matched to the examnded list of samples) *)
	expandedGelResources=Flatten[MapThread[
		ConstantArray[#1,#2]&,
		{gelResources,sampleLanesPerGel}
	]];

	(* - Determine how much Ladder we need depends on the Scale, and how many ladder lanes - *)
	ladderVolumeRule=If[

		(* IF the scale is Preparative *)
		MatchQ[scale,Preparative],

		(* THEN, we define the ladderVolumeRule with larger volume needed *)
		{ladder->0*Microliter},

		(* ELSE, we define the ladderVolumeRule with smaller volume *)
		{ladder->RoundOptionPrecision[((10*Microliter*numberOfLadders)+30*Microliter),10^-1*Microliter]}
	];

	ladderVolume=If[
		MatchQ[scale,Preparative],
		Null,
		10*Microliter
	];

	(* - Determine how much LoadingDilutionBuffer we need - *)
	loadingDilutionBufferVolumeRules=MapThread[
		If[
			(* IF the LoadingDilutionBuffer is Null *)
			MatchQ[#1,Null],
			(* THEN we set the Volume as 0 uL *)
			(#1->0*Microliter),
			(* ELSE we set the Volume to the LoadingDilutionBufferVolume plus 30 uL for dead volume *)
			(#1->(#2+30*Microliter))
		]&,
		{expandedLoadingDilutionBuffer,expandedLoadingDilutionBufferVolume}
	];

	(* --- Make the resources --- *)
	(* -- We want to make the resources for each unique  Object or Model Input, for the total volume required for the experiment for each -- *)
	(* - First, join the lists of the rules above, getting rid of any Rules with the pattern _->0*Microliter or Null->_ - *)
	allVolumeRules=Cases[
		Join[
			ladderVolumeRule,loadingDilutionBufferVolumeRules
		],
		Except[Alternatives[_->0*Microliter,Null->_]]
	];

	(* - Make an association whose keys are the unique (non LoadingDye) Object and Model Keys in the list of allVolumeRules, and whose values are the total volume of each of those unique keys - *)
	uniqueObjectsAndVolumesAssociation=Merge[allVolumeRules,Total];

	(* - Use this association to make Resources for each unique (non LoadingDye) Object or Model Key - *)
	uniqueResources=KeyValueMap[
		Module[{amount,containers},
			amount=#2;
			containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];
			Resource[Sample->#1,Amount->amount,Container->containers,Name->ToString[#1]]
		]&,
		uniqueObjectsAndVolumesAssociation
	];

	(* -- Define a list of replace rules for the unique (non LoadingDye) Model and Objects with the corresponding Resources --*)
	(* - Find a list of the unique (non LoadingDye) Object/Model Keys - *)
	uniqueObjects=Keys[uniqueObjectsAndVolumesAssociation];

	(* - Make a list of replace rules, replacing unique (non LoadingDye) objects with their respective Resources - *)
	uniqueObjectResourceReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueObjects,uniqueResources}
	];

	(* -- Use the unique (non LoadingDye) object replace rules to make lists of the resources of the inputs and the options / fields that are objects -- *)
	(* - For the inputs and options that are lists, Map over replacing the options with the replace rules at level {1} to get the corresponding list of resources - *)
	{
		loadingDilutionBufferResources
	}=Map[
		Replace[#,uniqueObjectResourceReplaceRules,{1}]&,
		{
			expandedLoadingDilutionBuffer
		}
	];

	(* - For the options that are single objects, Map over replacing the option with the replace rules to get the corresponding resources - *)
	{
		ladderResource
	}=Map[
		Replace[#,uniqueObjectResourceReplaceRules]&,
		{
			ladder
		}
	];

	(* --  We make the resources for the LoadingDyes separately, since there is such a small volume needed, we want to add the dead volume buffer amount to the total, rather than to each instance, so that we have enough if there is only one sample, but also are not wasting a ton if we have a lot of samples -- *)
	(* - Determine how much of each LoadingDye we need - *)
	(* First, expand any of the LoadingDyes that only have one dye to be a list of the same dye twice *)
	noSingleLoadingDyes=Map[
		If[Length[#]==1,
			Table[First[#],2],
			#
		]&,
		expandedLoadingDye
	];

	(* First, expand the LoadingDyeVolume to take into account the length of each member of LoadingDye *)
	flattenedExpandedLoadingDyeVolumes=Flatten[
		Map[
			ConstantArray[#1,2]&,
			expandedLoadingDyeVolume
		]
	];

	(* Next, define the volume rules for the LoadingDyes *)
	loadingDyeVolumeRules=MapThread[
		(#1->(#2+0.5*Microliter))&,
		{Flatten[noSingleLoadingDyes],flattenedExpandedLoadingDyeVolumes}
	];

	(* Define the PrimaryLoadingDyes as the first member of each sublist in loadingDyes *)
	primaryLoadingDyes=First[#]&/@noSingleLoadingDyes;

	(* Define the SecondaryLoadingDyes as either the last entry of each sublist if there are two members, or Null if there are one *)
	secondaryLoadingDyes=Last[#]&/@noSingleLoadingDyes;

	(* - Figure out what the LadderLoadingDyes and LadderLoadingDyeVolume will be, as well as the volume rules - *)
	(* We define the LadderLoadingDyes as the most used LoadingDyes for the input samples - tally the loading dyes, then sort by the number of times it shows up, reverse the list to put the most abundant list first, then take the First of the list *)
	ladderLoadingDyes=If[MatchQ[ladder,Except[Null]],
		First[Reverse[SortBy[Tally[noSingleLoadingDyes],Last]][[All,1]]],
		{}
	];

	(* LadderLoadingDyeVolume depends on the Scale *)
	ladderLoadingDyeVolume=If[
		MatchQ[scale,Preparative],
		Null,
		1.5*Microliter
	];

	(* Define the LadderLoadingDyeVolume rules *)
	ladderLoadingDyeVolumeRules=Map[
		(#->If[MatchQ[ladderFrequency, FirstAndLast],
			(ladderLoadingDyeVolume+0.5*Microliter)*2,
			(ladderLoadingDyeVolume+0.5*Microliter)])&,
		ladderLoadingDyes
	];

	(* -- We want to make the resources for each unique LoadingDye Object or Model Input, for the total volume required for the experiment for each -- *)
	(* - First, join the lists of the rules above, getting rid of any Rules with the pattern _->0*Microliter or Null->_ - *)
	allLoadingDyeVolumeRules=Cases[
		Join[
			loadingDyeVolumeRules,ladderLoadingDyeVolumeRules
		],
		Except[Alternatives[_->0*Microliter,Null->_]]
	];

	(* - Make an association whose keys are the unique (LoadingDye) Object and Model Keys in the list of allVolumeRules, and whose values are the total volume of each of those unique keys - *)
	uniqueLoadingDyeObjectsAndVolumesAssociation=Merge[allLoadingDyeVolumeRules,Total];

	(* - Use this association to make Resources for each unique (LoadingDye) Object or Model Key - *)
	uniqueLoadingDyeResources=KeyValueMap[
		Module[{amount,containers},
			amount=(#2+40*Microliter);
			containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];
			Resource[Sample->#1,Amount->amount,Container->containers,Name->ToString[Unique[]]]
		]&,
		uniqueLoadingDyeObjectsAndVolumesAssociation
	];

	(* -- Define a list of replace rules for the unique (LoadingDye) Model and Objects with the corresponding Resources --*)
	(* - Find a list of the unique (non LoadingDye) Object/Model Keys - *)
	uniqueLoadingDyeObjects=Keys[uniqueLoadingDyeObjectsAndVolumesAssociation];

	(* - Make a list of replace rules, replacing unique (LoadingDye) objects with their respective Resources - *)
	uniqueLoadingDyeObjectResourceReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueLoadingDyeObjects,uniqueLoadingDyeResources}
	];

	(* -- Use the unique (LoadingDye) object replace rules to make lists of the resources of the inputs and the options / fields that are objects -- *)
	(* - For the inputs and options that are lists, Map over replacing the options with the replace rules at level {1} to get the corresponding list of resources - *)
	{
		ladderLoadingDyeResources,primaryLoadingDyeResources,secondaryLoadingDyeResources
	}=Map[
		Replace[#,uniqueLoadingDyeObjectResourceReplaceRules,{1}]&,
		{
			ladderLoadingDyes,primaryLoadingDyes,secondaryLoadingDyes
		}
	];

	(* -- Make the resource packet for instrument --*)
	instrumentResource=Resource[
		Instrument->instrument,
		Time->separationTime+2*Hour
	];

	(* Get some information about the gel out of the gelModelPacket *)
	{gelMaterial,gelPercentage,gelModel}=Lookup[gelPacket,{GelMaterial,GelPercentage,Object},Null];

	(* - Make a resource for the DestinationPlate -*)
	destinationPlateResource=Which[
		MatchQ[scale,Analytical],
			Null,
		extractionVolume>250*Microliter,
			Resource[Sample->Model[Container, Plate, "96-well 1mL Deep Well Plate"]],
		True,
			Resource[Sample->Model[Container, Plate, "96-well Round Bottom Plate"]]
	];

	(* Make resources for the pipette tips - making two separate resources so that users don't ALWAYS buy tips for the Ranger if none are needed *)
	primaryPipettteTipsResource=Link[Resource[
		Sample -> Model[Item,Tips,"50 uL Hamilton barrier tips, sterile"],
		Amount->96
	]];
	secondaryPipetteTipsResource=Link[Resource[
		Sample -> Model[Item,Tips,"50 uL Hamilton barrier tips, sterile"],
		Amount->96
	]];

	(* Calculate the time estimate for Electrophoresis checkpoint. separationTime is the effective separation time time divided by the duty cycle  *)
	electrophoresisTimeEstimate=((separationTime/(Unitless[dutyCycle]/100))+2*Hour);

	(* - We need to turn the Spans of peakDetectionRanges into the Max/MinPeakDetectionSizes fields - *)
	(* Here we will Sort the members of peakDetectionRanges that are Spans, to guard against the user giving us something like 1200*BasePair;;1000*BasePair, which would cause an error on the Instrument *)
	{minPeakDetectionSizes,maxPeakDetectionSizes}=Module[
		{minPeakDetections,maxPeakDetections},

		(* First, define the minima *)
		minPeakDetections=Map[
			If[MatchQ[#,Null],
				Null,
				First[Sort[#]]
			]&,
			peakDetectionRanges
		];

		(* Next, define the maxima *)
		maxPeakDetections=Map[
			If[MatchQ[#,Null],
				Null,
				Last[Sort[#]]
			]&,
			peakDetectionRanges
		];

		(* Return the two lists *)
		{minPeakDetections,maxPeakDetections}

	];

	(* - We need to turn the Spans of collectionRanges into the Max/MinCollectionRangeSizes fields - *)
	(* Here we will Sort the members of collectionRanges that are Spans, to guard against the user giving us something like 1200*BasePair;;1000*BasePair, which would cause an error on the Instrument *)
	{minCollectionRangeSizes,maxCollectionRangeSizes}=Module[
		{minPeakCollections,maxPeakCollections},

		(* First, define the minima *)
		minPeakCollections=Map[
			If[MatchQ[#,Null],
				Null,
				First[Sort[#]]
			]&,
			collectionRanges
		];

		(* Next, define the maxima *)
		maxPeakCollections=Map[
			If[MatchQ[#,Null],
				Null,
				Last[Sort[#]]
			]&,
			collectionRanges
		];

		(* Return the two lists *)
		{minPeakCollections,maxPeakCollections}

	];

	(* --- Create the protocol packet --- *)
	protocolPacket=<|
		Type->Object[Protocol,AgaroseGelElectrophoresis],
		Object->protocolID,
		Author->If[MatchQ[parentProtocol,Null],
			Link[$PersonID,ProtocolsAuthored]
		],
		ParentProtocol->If[MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],
			Link[parentProtocol,Subprotocols]
		],

		Instrument->Link[instrumentResource],

		Replace[SamplesIn]->(Link[#,Protocols]&/@samplesInResources),
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@sampleContainersIn,

		UnresolvedOptions->RemoveHiddenOptions[ExperimentAgaroseGelElectrophoresis,myTemplatedOptions],
		ResolvedOptions->myResolvedOptions,

		Name->name,

		(* Agarose-specific fields *)
		Scale->scale,
		Replace[SampleVolumes]->expandedSampleVolumes,
		Replace[PrimaryLoadingDyes]->(Link[#]&/@primaryLoadingDyeResources),
		Replace[SecondaryLoadingDyes]->(Link[#]&/@secondaryLoadingDyeResources),
		Replace[LoadingDyeVolumes]->expandedLoadingDyeVolume,
		Replace[LoadingDilutionBuffers]->(Link[#]&/@loadingDilutionBufferResources),
		Replace[LoadingDilutionBufferVolumes]->expandedLoadingDilutionBufferVolume,
		SampleLoadingVolume->sampleLoadingVolume,
		PrimaryPipetteTips->primaryPipettteTipsResource,
		SecondaryPipetteTips->secondaryPipetteTipsResource,
		Ladder->Link[ladderResource],
		LadderFrequency->ladderFrequency,
		LadderVolume->ladderVolume,
		Replace[LadderLoadingDyes]->(Link[#]&/@ladderLoadingDyeResources),
		LadderLoadingDyeVolume->ladderLoadingDyeVolume,
		LoadingPlate->Link[Resource[Sample->Model[Container, Plate, "id:01G6nvkKrrYm"]]],
		LadderStorageCondition->Lookup[myResolvedOptions,LadderStorageCondition],
		DestinationPlate->Link[destinationPlateResource],
		Replace[Gels]->expandedGelResources,
		GelModel->Link[gelModel],
		GelMaterial->gelMaterial,
		GelPercentage->gelPercentage,
		NumberOfGels->numberOfGels,
		NumberOfLanes->numberOfLanes,
		SeparationTime->separationTime,
		Voltage->100*Volt,
		DutyCycle->dutyCycle,
		CycleDuration->125*Microsecond,
		Replace[AutomaticPeakDetections]->automaticPeakDetections,
		Replace[MinPeakDetectionSizes]->minPeakDetectionSizes,
		Replace[MaxPeakDetectionSizes]->maxPeakDetectionSizes,
		Replace[CollectionSizes]->collectionSizes,
		Replace[MinCollectionRangeSizes]->minCollectionRangeSizes,
		Replace[MaxCollectionRangeSizes]->maxCollectionRangeSizes,
		ExtractionVolume->extractionVolume,
		DestinationPlate->Link[destinationPlateResource],
		NumberOfReplicates->numberOfReplicates,
		Replace[ExposureTimes]->{20.0,73.0,271.0,1000.0}*Millisecond,
		Replace[ExcitationWavelengths]->{470,625}*Nanometer,
		Replace[ExcitationBandwidths]->{70,30}*Nanometer,
		Replace[EmissionWavelengths]->{540,677}*Nanometer,
		Replace[EmissionBandwidths]->{40,46}*Nanometer,
		Replace[SamplesInStorage]->expandedSamplesInStorage,
		Replace[SamplesOutStorage]->samplesOutStorageCondition,
		Replace[Checkpoints]->{
			{"Preparing Samples",15*Minute,"Preprocessing, such as incubation, centrifugation, filtration, and aliquotting, is performed.",Link[Resource[Operator->Model[User, Emerald, Operator, "Trainee"],Time->15 Minute]]},
			{"Picking Resources",45*Minute,"Samples, plates, and gels required to execute this protocol are gathered from storage.",Link[Resource[Operator->Model[User, Emerald, Operator, "Trainee"],Time->45 Minute]]},
			{"Preparing Loading Plate",30*Minute,"The LoadingPlate is loaded with the specified reagents.",Link[Resource[Operator->Model[User, Emerald, Operator, "Trainee"],Time->30 Minute]]},
			{"Preparing Instrumentation",45*Minute,"The instrument is configured for the protocol.",Link[Resource[Operator->Model[User, Emerald, Operator, "Trainee"],Time->45 Minute]]},
			{"Electrophoresis",(separationTime+2*Hour),"Samples are separated according to their electrophoretic mobility.",Link[Resource[Operator->Model[User, Emerald, Operator, "Trainee"],Time->(separationTime+2*Hour)]]},
			{"Returning Materials",30*Minute,"Samples are returned to storage.",Link[Resource[Operator->Model[User, Emerald, Operator, "Trainee"],Time->30 Minute]]}
		}
	|>;

	(* - Populate prep field - send in initial samples and options since this handles NumberOfReplicates on its own - *)
	prepPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Cache->inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[protocolPacket,prepPacket];

	(* make list of all the resources we need to check in FRQ *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		MatchQ[$ECLApplication,Engine],
			{True,{}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache],Null}
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
