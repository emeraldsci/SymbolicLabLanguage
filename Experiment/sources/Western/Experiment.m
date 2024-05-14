(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(* ExperimentWestern Options *)


DefineOptions[ExperimentWestern,
	Options:>{
		WesSharedLoadingOptions,
		(* Blocking *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->BlockingBuffer,
				Default->Automatic,
				Description->"The buffer that is incubated with the capillary after the MatrixRemovalTime. Incubation in this buffer reduces non-specific antibody binding to residual matrix present in the capillary. For more information about assay development and troubleshooting unexpected results, please refer to Object[Report, Literature, \"Simple Western Size Assay Development Guide\"].",
				ResolutionDescription->"The BlockingBuffer is automatically set to Model[Sample,\"Simple Western Milk-Free Antibody Diluent\"] if the Organism of the PrimaryAntibody is Goat, and to Model[Sample,\"Simple Western Antibody Diluent 2\"] otherwise.",
				AllowNull->False,
				Category->"Blocking",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			}
		],
		{
			OptionName->BlockingBufferVolume,
			Default->10*Microliter,
			Description->"The amount of BlockingBuffer that is aliquotted into the appropriate wells of the western assay plate (the specialized plate that is inserted into the western instrument).",
			AllowNull->False,
			Category->"Blocking",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[5*Microliter,20*Microliter],
				Units:>Microliter
			]
		},
		{
			OptionName->LadderBlockingBuffer,
			Default->Model[Sample,"Simple Western Antibody Diluent 2"],
			Description->"The buffer that is incubated with the capillary containing the Ladder during both the BlockingTime and the PrimaryIncubationTime.",
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
			Description->"The amount of LadderBlockingBuffer that is aliquotted into each of the two appropriate wells of the western assay plate (the specialized plate that is inserted into the western instrument).",
			AllowNull->False,
			Category->"Blocking",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[5*Microliter,20*Microliter],
				Units:>Microliter
			]
		},
		{
			OptionName->BlockingTime,
			Default->300*Second,
			Description->"The duration of the BlockingBuffer incubation after the MatrixRemovalTime.",
			AllowNull->False,
			Category->"Blocking",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,7200*Second],
				Units:>Second
			]
		},
		(* Antibody Labeling *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->PrimaryAntibodyVolume,
				Default->Automatic,
				Description->"The amount of the concentrated stock solution of input PrimaryAntibody that is mixed with the PrimaryAntibodyDiluent and StandardPrimaryAntibody before a portion of the mixture, the PrimaryAntibodyLoadingVolume, is loaded into the western assay plate (the specialized plate that is inserted into the western instrument). After the analyte binding, which occurs during the PrimaryIncubationTime, the presence of the PrimaryAntibody is detected by the SecondaryAntibody.",
				ResolutionDescription->"The PrimaryAntibodyVolume is automatically set to 36 uL if the PrimaryAntibodyDiluent is Null. Otherwise, The option is calculated from the equation PrimaryAntibodyDilutionFactor = (PrimaryAntibodyVolume/(PrimaryAntibodyVolume + PrimaryAntibodyDiluentVolume + StandardPrimaryAntibodyVolume)) with the assumptions that The StandardPrimaryAntibodyVolume will be 10% of the total volume when SystemStandard is True, and that the total volume will be 100 uL whenever possible. ",
				AllowNull->False,
				Category->"Antibody Labeling",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1*Microliter,200*Microliter],
					Units:>Microliter
				]
			},
			{
				OptionName->PrimaryAntibodyStorageCondition,
				Default->Null,
				Description->"The non-default storage condition under which the PrimaryAntibody of this experiment should be stored after the protocol is completed. If left unset, the PrimaryAntibody will be stored according to its current StorageCondition.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Antibody Labeling"
			},
			{
				OptionName->PrimaryAntibodyDiluent,
				Default->Automatic,
				Description->"The buffer which is mixed with the PrimaryAntibody to reduce the concentration of the antibody solution that will be loaded into the western assay plate (the specialized plate that is inserted into the western instrument). For more information about assay development and troubleshooting unexpected results, please refer to Object[Report, Literature, \"Simple Western Size Assay Development Guide\"].",
				ResolutionDescription->"The PrimaryAntibodyDiluent is automatically set to Null if the PrimaryAntibodyDilutionFactor is 1, or if the PrimaryAntibodyDiluentVolume is 0 uL or Null.",
				AllowNull->True,
				Category->"Antibody Labeling",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->PrimaryAntibodyDilutionFactor,
				Default->Automatic,
				Description->"A measure of the ratio of PrimaryAntibodyVolume to the diluted PrimaryAntibody (PrimaryAntibody plus PrimaryAntibodyDiluent plus StandardPrimaryAntibody). A PrimaryAntibodyDilutionFactor of 0.02 indicates that the diluted PrimaryAntibody solution will be comprised of 1 part concentrated PrimaryAntibody and 49 parts of either PrimaryAntibodyDiluent or a mixture of PrimaryAntibodyDiluent and StandardPrimaryAntibody. For more information about suggested primary antibody dilutions, please refer to https://www.proteinsimple.com/antibody/antibodies.html. If traditional Western Blot primary antibody dilution conditions are known, it is recommended to start with 100, 20, and 4 times the recommended traditional primary antibody dilutions for initial antibody screening. For example, if the recommended traditional Western dilution is 1:1000 (a PrimaryAntibodyDilutionFactor of 0.001), the recommended starting PrimaryAntibodyDilutionFactors would be 0.1, 0.02, and 0.004. For a new assay where Western blot parameters are not known, it is recommended to use PrimaryAntibodyDilutionFactors of 0.1, 0.02, and 0.004 for initial antibody screening. For more information about assay development and troubleshooting unexpected results, please refer to Object[Report, Literature, \"Simple Western Size Assay Development Guide\"].",
				ResolutionDescription->"The PrimaryAntibodyDilutionFactor is automatically set to 1 if the PrimaryAntibodyDiluent is Null. If any of the PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, or StandardPrimaryAntibodyVolume are set, the PrimaryAntibodyDilutionFactor is calculated from the equation PrimaryAntibodyDilutionFactor = (PrimaryAntibodyVolume/(PrimaryAntibodyVolume + PrimaryAntibodyDiluentVolume + StandardPrimaryAntibodyVolume)), with the assumptions that The StandardPrimaryAntibodyVolume will be 10% of the total volume when SystemStandard is True, and that the total volume will be 100 uL whenever possible. If none of the previously mentioned options are specified, the PrimaryAntibodyDilutionFactor is automatically set to the RecommendedDilution of the PrimaryAntibody.",
				AllowNull->False,
				Category->"Antibody Labeling",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0.005,1]
				]
			},
			{
				OptionName->PrimaryAntibodyDiluentVolume,
				Default->Automatic,
				Description->"The amount of the PrimaryAntibodyDiluent that is mixed with the PrimaryAntibody and the StandardPrimaryAntibody before a portion of the mixture, the PrimaryAntibodyLoadingVolume, is loaded into the western assay plate (the specialized plate that is inserted into the western instrument).",
				ResolutionDescription->"The PrimaryAntibodyDiluentVolume is automatically set to Null when the PrimaryAntibodyDiluent is Null. Otherwise, The option is calculated from the equation PrimaryAntibodyDilutionFactor = (PrimaryAntibodyVolume/(PrimaryAntibodyVolume + PrimaryAntibodyDiluentVolume + StandardPrimaryAntibodyVolume)) with the assumptions that The StandardPrimaryAntibodyVolume will be 10% of the total volume when SystemStandard is True, and that the total volume will be 100 uL whenever possible.",
				AllowNull->True,
				Category->"Antibody Labeling",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Microliter,200*Microliter],
					Units:>Microliter
				]
			},
			{
				OptionName->SystemStandard,
				Default->False,
				Description->"Indicates if a StandardPrimaryAntibody and secondary antibody-HRP conjugate is used to detect a standard protein present in the ConcentratedLoadingBuffer. This option is typically set to True when trying to troubleshoot anomalous results.",
				AllowNull->False,
				Category->"Antibody Labeling",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				]
			},
			{
				OptionName->StandardPrimaryAntibody,
				Default->Automatic,
				Description->"The solution containing a control antibody which detects the system control protein in the LoadingBuffer, provided by the instrument supplier, that is mixed with the PrimaryAntibody and the PrimaryAntibodyDiluent.",
				ResolutionDescription->"The StandardPrimaryAntibody is automatically set to Null if SystemStandard is False. If SystemStandard is True, the option resolves to Model[Sample,\"Simple Western 10X System Control Primary Antibody-Mouse\"] if the Organism of the PrimaryAntibody is Mouse, and to Model[Sample,\"Simple Western 10X System Control Primary Antibody-Rabbit\"] otherwise.",
				AllowNull->True,
				Category->"Antibody Labeling",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->StandardPrimaryAntibodyStorageCondition,
				Default->Null,
				Description->"The non-default storage condition under which the StandardPrimaryAntibody of this experiment should be stored after the protocol is completed. If left unset, the StandardPrimaryAntibody will be stored according to its current StorageCondition.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Antibody Labeling"
			},
			{
				OptionName->StandardPrimaryAntibodyVolume,
				Default->Automatic,
				Description->"The amount of the StandardPrimaryAntibody that is mixed with the PrimaryAntibody and the PrimaryAntibodyDiluent before a portion of the mixture, the PrimaryAntibodyLoadingVolume, is loaded into the western assay plate (the specialized plate that is inserted into the western instrument).",
				ResolutionDescription->"The StandardPrimaryAntibodyVolume is automatically set to Null if the SystemStandard is False. If the SystemStandard is True and the PrimaryAntibodyDilutionFactor is 1, the StandardPrimaryAntibodyVolume ia automatically set to be 10% of the PrimaryAntibodyVolume. Otherwise, the option is calculated from the equation PrimaryAntibodyDilutionFactor = (PrimaryAntibodyVolume/(PrimaryAntibodyVolume + PrimaryAntibodyDiluentVolume + StandardPrimaryAntibodyVolume)).",
				AllowNull->True,
				Category->"Antibody Labeling",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Microliter,30*Microliter],
					Units:>Microliter
				]
			}
		],
		{
			OptionName->PrimaryAntibodyLoadingVolume,
			Default->Automatic,
			Description->"The amount of each mixture of PrimaryAntibody, PrimaryAntibodyDiluent, and StandardPrimaryAntibody that is loaded into the appropriate wells of the western assay plate (the specialized plate that is inserted into the western instrument).",
			ResolutionDescription->"The PrimaryAntibodyLoadingVolume is automatically set to 10 uL, unless any input sample's total of PrimaryAntibodyVolume, PrimaryAntibodyDiluentVolume, and StandardPrimaryAntibodyVolume is less than 10 uL, in which case the option is set to the lowest such volume.",
			AllowNull->False,
			Category->"Antibody Labeling",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[5*Microliter,20*Microliter],
				Units:>Microliter
			]
		},
		{
			OptionName->PrimaryIncubationTime,
			Default->1800*Second,
			Description->"The duration for which the capillary is incubated with the PrimaryAntibody.",
			AllowNull->False,
			Category->"Antibody Labeling",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,7200*Second],
				Units:>Second
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SecondaryAntibody,
				Default->Automatic,
				Description->"The antibody-HRP conjugate solution that is used to detect the PrimaryAntibody. Corresponding SecondaryAntibodies will be automatically set for any PrimaryAntibodies that are derived from Mouse, Rabbit, Human, or Goat. For PrimaryAntibodies derived from other species, the user should provide a corresponding SecondaryAntibody. For more information about assay development and troubleshooting unexpected results, please refer to Object[Report, Literature, \"Simple Western Size Assay Development Guide\"].",
				ResolutionDescription->"The SecondaryAntibody is automatically set to Model[Sample,\"Simple Western Goat-AntiRabbit-HRP\"] if the Organism of the PrimaryAntibody is Rabbit, to Model[Sample,\"Simple Western Goat-AntiMouse-HRP\"] if Mouse, to Model[Sample,\"Simple Western Goat-AntiHuman-IgG-HRP\"] if Human, to Model[Sample,\"Simple Western Donkey-AntiGoat-HRP\"] if Goat, and to Model[Sample,\"Simple Western Antibody Diluent 2\"] otherwise.",
				AllowNull->False,
				Category->"Antibody Labeling",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->SecondaryAntibodyStorageCondition,
				Default->Null,
				Description->"The non-default storage condition under which the SecondaryAntibody of this experiment should be stored after the protocol is completed. If left unset, the SecondaryAntibody will be stored according to its current StorageCondition.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Antibody Labeling"
			},
			{
				OptionName->SecondaryAntibodyVolume,
				Default->Automatic,
				Description->"The amount of SecondaryAntibody solution that is aliquotted into the appropriate wells of the western assay plate (the specialized plate that is inserted into the western instrument).",
				ResolutionDescription->"The SecondaryAntibodyVolume is automatically set to 10 uL if the StandardSecondaryAntibody is Null, to 9.5 uL if the StandardSecondaryAntibody is not Null but the StandardSecondaryAntibodyVolume is left as Automatic, and to 19 times the StandardSecondaryAntibodyVolume otherwise.",
				AllowNull->False,
				Category->"Antibody Labeling",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[5*Microliter,19*Microliter],
					Units:>Microliter
				]
			},
			{
				OptionName->StandardSecondaryAntibody,
				Default->Automatic,
				Description->"The concentrated solution containing a control antibody-HRP conjugate which detects the StandardPrimaryAntibody. The StandardSecondaryAntibody is mixed with the SecondaryAntibody in cases where the PrimaryAntibody and StandardPrimaryAntibody are not derived from the same mammal - when the PrimaryAntibody is human or goat-derived.",
				ResolutionDescription->"The StandardSecondaryAntibody is automatically set to Null if the StandardPrimaryAntibody is Null. If the StandardPrimaryAntibody is Model[Sample,\"Simple Western 10X System Control Primary Antibody-Mouse\"] and the Organism of the PrimaryAntibody is Mouse, or the StandardPrimaryAntibody is Model[Sample,\"Simple Western 10X System Control Primary Antibody-Rabbit\"] and the Organism of the PrimaryAntibody is Rabbit, the StandardSecondaryAntibody resolves to Null. Otherwise, the option resolves to Model[Sample, \"Simple Western 20X Goat-AntiRabbit-HRP\"].",
				AllowNull->True,
				Category->"Antibody Labeling",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->StandardSecondaryAntibodyStorageCondition,
				Default->Null,
				Description->"The non-default storage condition under which the StandardSecondaryAntibody of this experiment should be stored after the protocol is completed. If left unset, the StandardSecondaryAntibody will be stored according to its current StorageCondition.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Antibody Labeling"
			},
			{
				OptionName->StandardSecondaryAntibodyVolume,
				Default->Automatic,
				Description->"The amount of the concentrated solution of the StandardSecondaryAntibody that is mixed with the SecondaryAntibody in cases where the PrimaryAntibody and StandardPrimaryAntibody are not derived from the same mammal - when the PrimaryAntibody is human or goat-derived.",
				ResolutionDescription->"The StandardSecondaryAntibodyVolume is automatically set to Null if the StandardSecondaryAntibody is Null, and to the SecondaryAntibodyVolume divided by 19 otherwise.",
				AllowNull->True,
				Category->"Antibody Labeling",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0*Microliter,1*Microliter],
					Units:>Microliter
				]
			}
		],
		{
			OptionName->SecondaryIncubationTime,
			Default->1800*Second,
			Description->"The duration for which the capillary is incubated with the SecondaryAntibody or the LadderPeroxidaseReagent (for the capillary containing the Ladder).",
			AllowNull->False,
			Category->"Antibody Labeling",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Second,7200*Second],
				Units:>Second
			]
		},
		{
			OptionName->LadderPeroxidaseReagent,
			Default->Model[Sample,"Simple Western Streptavidin-HRP"],
			Description->"The sample or model of streptavidin-HRP solution which binds to the biotinylated ladder provided by the instrument supplier.",
			AllowNull->False,
			Category->"Antibody Labeling",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},
		{
			OptionName->LadderPeroxidaseReagentStorageCondition,
			Default->Null,
			Description->"The non-default storage condition under which the LadderPeroxidaseReagent of this experiment should be stored after the protocol is completed. If left unset, the LadderPeroxidaseReagent will be stored according to its current StorageCondition.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
			],
			Category->"Antibody Labeling"
		},
		{
			OptionName->LadderPeroxidaseReagentVolume,
			Default->10*Microliter,
			Description->"The amount of streptavidin-HRP conjugate solution that is added to the appropriate well of the western assay plate (the specialized plate that is inserted into the western instrument).",
			AllowNull->False,
			Category->"Antibody Labeling",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[5*Microliter,20*Microliter],
				Units:>Microliter
			]
		},
		WesSharedImagingOptions,
		FuntopiaSharedOptions,
		SamplesInStorageOptions,
		SubprotocolDescriptionOption
}];



(* ::Subsubsection::Closed:: *)
(* ExperimentWestern Source Code *)


(* - Container to Sample Overload - *)
ExperimentWestern[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myAntibodyContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,initialOptionsWithPreparedSamples,initialSamplePreparationCache,
		allPreparedSamples,myAntibodySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,containerToSampleResult,containerToSampleOutput,sampleCache,antibodyCache,
		antibodyContainerToSampleResult,antibodyContainerToSampleOutput,antibodyContainerToSampleTests,containerToSampleTests,joinedTests,updatedCache,samples,sampleOptions,antibodies,antibodyOptions},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation - not wrapping myAntibodies with ToList, because we want the secondary input to remain unlisted if given as a single so that it can be expanded by expandIndexMatchedInputs later. *)
		{allPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentWestern,
			Join[ToList[myContainers],ToList[myAntibodyContainers]],
			ToList[myOptions]
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	{mySamplesWithPreparedSamples, myAntibodySamplesWithPreparedSamples}=TakeDrop[allPreparedSamples, Length[ToList[myContainers]]];

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
			ExperimentWestern,
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
				ExperimentWestern,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->Result,
				Cache->samplePreparationCache
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* Convert our given antibody containers into antibodies and antibody index-matched options. *)
	antibodyContainerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{antibodyContainerToSampleOutput,antibodyContainerToSampleTests}=containerToSampleOptions[
			ExperimentWestern,
			myAntibodySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests},
			Cache->samplePreparationCache
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->antibodyContainerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			antibodyContainerToSampleOutput=containerToSampleOptions[
				ExperimentWestern,
				myAntibodySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->Result,
				Cache->samplePreparationCache
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	joinedTests=Join[containerToSampleTests,antibodyContainerToSampleTests];

	(* Update our cache with our new simulated values. *)
	updatedCache=Flatten[{
		samplePreparationCache,
		Lookup[listedOptions,Cache,{}]
	}];

	(* If we were given an empty container, return early. *)
	If[Or[MatchQ[containerToSampleResult,$Failed],MatchQ[antibodyContainerToSampleResult,$Failed]],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> joinedTests,
			Options -> $Failed,
			Preview -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions,sampleCache}=containerToSampleOutput;

		(* Split up our antibodyContainerToSample result into antibodies and antibodyOptions *)
		{antibodies,antibodyOptions,antibodyCache}=antibodyContainerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentWestern[samples,antibodies,ReplaceRule[sampleOptions,Cache->Flatten[{updatedCache, sampleCache, antibodyCache}]]]
	]
];

(* - Main Sample Overload - *)

ExperimentWestern[mySamples:ListableP[ObjectP[Object[Sample]]],myAntibodies:ListableP[ObjectP[{Object[Sample],Model[Sample]}]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,listedSamples,outputSpecification,output,gatherTests,messages,validSamplePreparationResult,mySamplesWithPreparedSamples,initialOptionsWithPreparedSamples,initialSamplePreparationCache,
		allPreparedSamples,myAntibodySamplesWithPreparedSamplesList,myAntibodySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,mySamplesWithPreparedSamplesNamed,	myAntibodySamplesWithPreparedSamplesNamed,samplePreparationCacheNamed,
		myOptionsWithPreparedSamplesNamed, safeOpsNamed, combinedNamedSamples,combinedSamples,safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedLysates,expandedPrimaryAntibodies,expandedSafeOps,westernOptionsAssociation,suppliedLadder,suppliedWashBuffer,suppliedConcentratedLoadingBuffer,suppliedInstrument,suppliedBlockingBuffer,
		suppliedSecondaryAntibody,suppliedStandardPrimaryAntibody,suppliedStandardSecondaryAntibody,suppliedPrimaryAntibodyDiluent,ladderDownloadFields,washBufferDownloadFields,concentratedLoadingBufferDownloadFields,
		uniqueSecondaryAntibodyObjects,uniqueSecondaryAntibodyModels,uniqueStandardPrimaryAbObjects,uniqueStandardPrimaryAbModels,uniqueStandardSecondaryAbObjects,uniqueStandardSecondaryAbModels,
		listedBlockingBuffer,uniqueBlockingBufferObjects,uniqueBlockingBufferModels,uniquePrimaryAntibodyDiluentObjects,uniquePrimaryAntibodyDiluentModels,
		primaryAntibodyObjectInputs,primaryAntibodyModelInputs,objectSamplePacketFields,modelSamplePacketFields,objectContainerFields,modelContainerFields,
		optionsWithObjects,userSpecifiedObjects,simulatedSampleQ,objectsExistQs,objectsExistTests,
		modelContainerPacketFields,samplesContainerModelPacketFields,
		liquidHandlerContainers,listedSampleContainerPackets,listedAntibodyObjectInputPackets,listedModelInstrumentPackets,listedLadderOptionPackets,listedWashBufferOptionPackets,listedConcentratedLoadingBufferOptionPackets,
		listedSecondaryAbObjectPackets,listedSecondaryAbModelPackets,listedStandardPrimaryAbObjectPackets,listedStandardPrimaryAbModelPackets,listedStandardSecondaryAbObjectPackets,
		listedStandardSecondaryAbModelPackets,listedBlockingBufferObjectPackets,listedBlockingBufferModelPackets,listedPrimaryAntibodyDiluentObjectPackets,
		listedPrimaryAntibodyDiluentModelPackets,inputsInOrder,antibodiesInOrder,listedPrimaryAntibodyCompositionPackets,liquidHandlerContainerPackets,
		cacheBall,inputObjects,antibodyObjects,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests},

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
		(* Simulate sample preparation - not wrapping myAntibodies with ToList, because we want the secondary input to remain unlisted if given as a single so that it can be expanded by expandIndexMatchedInputs later. *)
		{allPreparedSamples,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed}=simulateSamplePreparationPackets[
			ExperimentWestern,
			Join[listedSamples,ToList[myAntibodies]],
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	{mySamplesWithPreparedSamplesNamed, myAntibodySamplesWithPreparedSamplesNamed}=TakeDrop[allPreparedSamples, Length[listedSamples]];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
	(* Return early. *)
	(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentWestern,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentWestern,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Combined the samples to be sent to the sanitizeInput function*)
	combinedNamedSamples=Join[mySamplesWithPreparedSamplesNamed,myAntibodySamplesWithPreparedSamplesNamed];

	(* Sanitize the samples and antibodies and options using sanitizInput funciton*)
	{combinedSamples, {safeOps, myOptionsWithPreparedSamples, samplePreparationCache}} = sanitizeInputs[combinedNamedSamples, {safeOpsNamed, myOptionsWithPreparedSamplesNamed, samplePreparationCacheNamed}];

	(* Separate them into samples and antibody samples*)
	{mySamplesWithPreparedSamples, myAntibodySamplesWithPreparedSamplesList}=TakeList[combinedSamples,{Length[mySamplesWithPreparedSamplesNamed],Length[myAntibodySamplesWithPreparedSamplesNamed]}];

	(* After TakeList the myAntibodySamplesWithPreparedSamplesList may be added with a List head, which can be bad for input length check and ExpandIndexMatchedInputs call later, take out the List head if we were given a single value *)
	myAntibodySamplesWithPreparedSamples = If[MatchQ[myAntibodies, _List],
		myAntibodySamplesWithPreparedSamplesList,
		First[myAntibodySamplesWithPreparedSamplesList]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentWestern,{mySamplesWithPreparedSamples,myAntibodySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentWestern,{mySamplesWithPreparedSamples,myAntibodySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
		ApplyTemplateOptions[ExperimentWestern,{mySamplesWithPreparedSamples,myAntibodySamplesWithPreparedSamples},ToList[myOptionsWithPreparedSamples],Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentWestern,{mySamplesWithPreparedSamples,myAntibodySamplesWithPreparedSamples},ToList[myOptionsWithPreparedSamples]],Null}
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

	(* Expand index-matching options and secondary input (the primary antibodies) *)
	{{expandedLysates,expandedPrimaryAntibodies},expandedSafeOps}=ExpandIndexMatchedInputs[ExperimentWestern,{mySamplesWithPreparedSamples,myAntibodySamplesWithPreparedSamples},inheritedOptions];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Turn the expanded safe ops into an association so we can lookup information from it*)
	westernOptionsAssociation=Association[expandedSafeOps];

	(* Pull the info out of the options that we need to download from *)
	{
		suppliedLadder,suppliedWashBuffer,suppliedConcentratedLoadingBuffer,suppliedInstrument,suppliedBlockingBuffer,suppliedSecondaryAntibody,suppliedStandardPrimaryAntibody,suppliedStandardSecondaryAntibody,
		suppliedPrimaryAntibodyDiluent
	}=Lookup[westernOptionsAssociation,
		{
			Ladder,WashBuffer,ConcentratedLoadingBuffer,Instrument,BlockingBuffer,SecondaryAntibody,StandardPrimaryAntibody,StandardSecondaryAntibody,PrimaryAntibodyDiluent
		}
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
	(* Since SecondaryAntibody is index matched, we will need to download packets from Object and Model inputs separately, then reconstruct a list of the SecondaryAntibody Models by ID after *)
	(* Create lists of the SecondaryAntibodies that are unique Objects and Models*)
	uniqueSecondaryAntibodyObjects=DeleteDuplicates[Cases[ToList[suppliedSecondaryAntibody],ObjectP[Object]]];
	uniqueSecondaryAntibodyModels=DeleteDuplicates[Cases[ToList[suppliedSecondaryAntibody],ObjectP[Model]]];

	(* - StandardPrimaryAntibody Option - *)
	(* Since StandardPrimaryAntibody is index matched, we will need to download packets from Object and Model inputs separately, then reconstruct a list of the StandardPrimaryAntibody Models by ID after *)
	uniqueStandardPrimaryAbObjects=DeleteDuplicates[Cases[ToList[suppliedStandardPrimaryAntibody],ObjectP[Object]]];
	uniqueStandardPrimaryAbModels=DeleteDuplicates[Cases[ToList[suppliedStandardPrimaryAntibody],ObjectP[Model]]];

	(* - StandardSecondaryAntibody Option - *)
	(* Since StandardSecondaryAntibody is index matched, we will need to download packets from Object and Model inputs separately, then reconstruct a list of the StandardSecondaryAntibody Models by ID after *)
	uniqueStandardSecondaryAbObjects=DeleteDuplicates[Cases[ToList[suppliedStandardSecondaryAntibody],ObjectP[Object]]];
	uniqueStandardSecondaryAbModels=DeleteDuplicates[Cases[ToList[suppliedStandardSecondaryAntibody],ObjectP[Model]]];

	(* - BlockingBuffer Option - *)
	(* Since StandardSecondaryAntibody is index matched in Western and single in TotalProteinLabeling , we will need to download packets from Object and Model inputs separately, then reconstruct a list of the StandardSecondaryAntibody Models by ID after *)
	listedBlockingBuffer=ToList[suppliedBlockingBuffer];
	uniqueBlockingBufferObjects=DeleteDuplicates[Cases[ToList[listedBlockingBuffer],ObjectP[Object]]];
	uniqueBlockingBufferModels=DeleteDuplicates[Cases[ToList[listedBlockingBuffer],ObjectP[Model]]];

	(* - PrimaryAntibodyDiluent Option - *)
	(* Since PrimaryAntibodyDiluent is index matched, we will need to download packets from Object and Model inputs separately, then reconstruct a list of the PrimaryAntibodyDiluent Models by ID after *)
	uniquePrimaryAntibodyDiluentObjects=DeleteDuplicates[Cases[ToList[suppliedPrimaryAntibodyDiluent],ObjectP[Object]]];
	uniquePrimaryAntibodyDiluentModels=DeleteDuplicates[Cases[ToList[suppliedPrimaryAntibodyDiluent],ObjectP[Model]]];

	(* -- PrimaryAntibody input -- *)
	(* - Depending on if the secondary input is an object, we need to download different fields - *)
	primaryAntibodyObjectInputs=Cases[ToList[myAntibodySamplesWithPreparedSamples],ObjectP[Object[Sample]]];
	primaryAntibodyModelInputs=Cases[ToList[myAntibodySamplesWithPreparedSamples],ObjectP[Model[Sample]]];

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

	(* - Throw an error and return failed if any of the specified Objects are not members of the database - *)
	(* Any options whose values _could_ be an object *)
	optionsWithObjects = {
		SecondaryAntibody,
		StandardPrimaryAntibody,
		StandardSecondaryAntibody,
		BlockingBuffer,
		PrimaryAntibodyDiluent,
		Ladder,
		WashBuffer,
		ConcentratedLoadingBuffer,
		Denaturant,
		LadderPeroxidaseReagent
	};

	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten@Join[listedSamples,ToList[myAntibodies],Lookup[listedOptions,optionsWithObjects,Null]],
		ObjectP[]
	];

	(* Check that the specified objects exist or are visible to the current user *)
	simulatedSampleQ = Map[
		If[MatchQ[#,ObjectP[Lookup[samplePreparationCache,Object,{}]]],
			Lookup[fetchPacketFromCache[#,samplePreparationCache],Simulated,False],
			False
		]&,
		userSpecifiedObjects
	];
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
			Tests -> Join[safeOpsTests,validLengthTests,templateTests,objectsExistTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* - Big Download to make cacheBall and get the inputs in order by ID - *)
	{
		listedSampleContainerPackets,listedAntibodyObjectInputPackets,listedModelInstrumentPackets,listedLadderOptionPackets,listedWashBufferOptionPackets,listedConcentratedLoadingBufferOptionPackets,
		listedSecondaryAbObjectPackets,listedSecondaryAbModelPackets,listedStandardPrimaryAbObjectPackets,listedStandardPrimaryAbModelPackets,listedStandardSecondaryAbObjectPackets,
		listedStandardSecondaryAbModelPackets,listedBlockingBufferObjectPackets,listedBlockingBufferModelPackets,listedPrimaryAntibodyDiluentObjectPackets,
		listedPrimaryAntibodyDiluentModelPackets,inputsInOrder,antibodiesInOrder,listedPrimaryAntibodyCompositionPackets,liquidHandlerContainerPackets
	}=Quiet[
		Download[
			{
				(* Inputs *)
				ToList[mySamplesWithPreparedSamples],

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
				ToList[mySamplesWithPreparedSamples],
				expandedPrimaryAntibodies,
				expandedPrimaryAntibodies,
				liquidHandlerContainers
			},
			{
				(* Primary inputs *)
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Container[objectContainerFields]],
					Packet[Container[Model][modelContainerFields]],
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
				(* Get input and antibody objects *)
				{Packet[Object]},
				{Packet[Object]},

				(* PrimaryAntibodies Composition *)
				{
					Packet[Composition[[All,2]][{RecommendedDilution,Organism,Targets}]],
					Packet[Composition[[All,2]][Targets][MolecularWeight]]
				},
				{modelContainerPacketFields}
			},
			Cache->Flatten[{Lookup[expandedSafeOps,Cache,{}],samplePreparationCache}],
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	cacheBall=FlattenCachePackets[
		{
			samplePreparationCache,listedSampleContainerPackets,listedAntibodyObjectInputPackets,listedModelInstrumentPackets,listedLadderOptionPackets,listedWashBufferOptionPackets,
			listedConcentratedLoadingBufferOptionPackets,listedSecondaryAbObjectPackets,listedSecondaryAbModelPackets,listedStandardPrimaryAbObjectPackets,listedStandardPrimaryAbModelPackets,
			listedStandardSecondaryAbObjectPackets,listedStandardSecondaryAbModelPackets,listedBlockingBufferObjectPackets,listedBlockingBufferModelPackets,listedPrimaryAntibodyDiluentObjectPackets,
			listedPrimaryAntibodyDiluentModelPackets,listedPrimaryAntibodyCompositionPackets,liquidHandlerContainerPackets
		}
	];

	(* Make lists of the inputs and antibodies by Object ID to pass to the helper functions *)
	inputObjects=Lookup[Flatten[inputsInOrder],Object];
	antibodyObjects=Lookup[Flatten[antibodiesInOrder],Object];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveWesExperimentOptions[inputObjects,antibodyObjects,expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveWesExperimentOptions[inputObjects,antibodyObjects,expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentWestern,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentWestern,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		wesResourcePackets[inputObjects,antibodyObjects,templatedOptions,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{wesResourcePackets[inputObjects,antibodyObjects,templatedOptions,resolvedOptions,Cache->cacheBall],{}}
	];


(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
If[!MemberQ[output,Result],
	Return[outputSpecification/.{
		Result -> Null,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentWestern,collapsedResolvedOptions],
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
		Priority->Lookup[safeOps,Priority],
		StartDate->Lookup[safeOps,StartDate],
		HoldOrder->Lookup[safeOps,HoldOrder],
		QueuePosition->Lookup[safeOps,QueuePosition],
		ConstellationMessage->Object[Protocol,Western],
		Cache->cacheBall
	],
	$Failed
];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentWestern,collapsedResolvedOptions],
		Preview -> Null
	}
];
