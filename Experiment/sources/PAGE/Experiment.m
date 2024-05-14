(* ::Package:: *)

(* ::Subsection::Closed:: *)
(* Options *)


DefineOptions[ExperimentPAGE,
	Options:>{

		{
			OptionName->Gel,
			Default->Automatic,
			Description->"The polyacrylamide gel(s) that the input samples are run through.",
			ResolutionDescription->
       		"For oligomers, if DenaturingGel is True or Automatic: Model[Item, Gel, \"10% polyacrylamide TBE-Urea cassette, 20 channel\"], otherwise Model[Item, Gel, \"10% polyacrylamide TBE cassette, 20 channel\"].
			For proteins with molar masses of less than 200 KDa, if DenaturingGel is True or Automatic: Model[Item, Gel, \"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel\"], otherwise Model[Item, Gel, \"12% polyacrylamide Tris-Glycine cassette, 20 channel\"].
			For proteins with molar masses of equal or greater than 200 KDa, if DenaturingGel is True or Automatic: Model[Item, Gel, \"7% polyacrylamide Tris-Glycine-SDS cassette, 20 channel\"], otherwise Model[Item, Gel, \"7% polyacrylamide Tris-Glycine cassette, 20 channel\"].",
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
			OptionName->DenaturingGel,
			Default->Automatic,
			Description->"If set to True, the Gel will contain 7M Urea. If set to False, PAGE will be run under native conditions, without any denaturant in the gel.",
			ResolutionDescription->"Automatically set to the value of the Denaturing field of the input Gel option.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
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
				Pattern:>ObjectP[{Object[Instrument,Electrophoresis],Model[Instrument,Electrophoresis]}]
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
		{
			OptionName->ReservoirBuffer,
			Default->Automatic,
			Description->"The buffer that is used in the gel cassette reservoirs during electrophoresis.",
			ResolutionDescription->"Automatically set to Model[Sample, StockSolution, \"1x TBE Buffer\"] if the Gel is a TBE oligomer gel, to Model[Sample,StockSolution,\"1x Tris-Glycine Buffer\"] if the Gel is a native Tris/Glycine protein gel, and to Model[Sample,StockSolution,\"1x Tris-Glycine-SDS Buffer\"] otherwise.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
			]
		},
		{
			OptionName->GelBuffer,
			Default->Automatic,
			Description->"The buffer that is applied to the gel during electrophoresis.",
			ResolutionDescription->"Automatically set to Model[Sample, StockSolution, \"1x TBE Buffer\"] if the Gel is a native TBE oligomer gel, to Model[Sample, StockSolution, \"1X TBE buffer with 7M Urea\"] if the Gel is a denaturing TBE-Urea oligomer gel, to Model[Sample,StockSolution,\"1x Tris-Glycine Buffer\"] if the Gel is a native Tris/Glycine protein gel, and to Model[Sample,StockSolution,\"1x Tris-Glycine-SDS Buffer\"] otherwise.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleVolume,
				Default->Automatic,
				Description->"The amount of each input sample that is mixed with the LoadingBuffer before a portion of the mixture (the SampleLoadingVolume) is loaded into the gel.",
				ResolutionDescription->"Automatically set to 12 uL if the Gel is a native TBE oligomer gel, to 3 uL if the Gel is a denaturing TBE-Urea oligomer gel, and to 7.5 uL otherwise.",
				AllowNull->False,
				Category->"Loading",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Micro Liter,15 Micro Liter],
					Units->Micro Liter
				]
			},
			{
				OptionName->LoadingBufferVolume,
				Default->Automatic,
				Description->"The amount of LoadingBuffer that is mixed with each input sample before a portion of the mixture (the SampleLoadingVolume) is loaded into the gel.",
				ResolutionDescription->"Automatically set to 3 uL if the Gel is a native TBE oligomer gel, to 40 uL if the Gel is a denaturing TBE-Urea oligomer gel, and to 7.5 uL otherwise.",
				AllowNull->False,
				Category->"Loading",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Micro Liter,40 Micro Liter],
					Units->Micro Liter
				]
			}
		],
		{
			OptionName->Ladder,
			Default->Automatic,
			Description->"The sample or model of ladder used as a standard reference in the Experiment.",
			ResolutionDescription->"Automatically set to Model[Sample,StockSolution,Standard,\"GeneRuler dsDNA 10-300 bp, 11 bands, 167 ng/uL\"] if the Gel is a TBE oligomer gel, to Model[Sample,StockSolution,Standard,\"NativeMark Unstained Protein Standards, 20-1236 kDa\"] if the Gel is a native Tris/Glycine protein gel, and to Model[Sample,StockSolution,Standard,\"Precision Plus Unstained Protein Standards, 10-200 kDa\"] otherwise.",
			AllowNull->False,
			Category->"Loading",
			Widget->Widget[
				Type->Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
			]
		},
		{
			OptionName->LoadingBuffer,
			Default->Automatic,
			Description->"The buffer that is mixed with samples before they are loaded into the gel.",
			ResolutionDescription->"Automatically set to Model[Sample, \"PAGE SYBR Gold non-denaturing loading buffer, 25% Ficoll\"] if the Gel is a native TBE oligomer gel, to Model[Sample, \"PAGE denaturing loading buffer, 22% Ficoll\"] if the Gel is a denaturing TBE-Urea oligomer gel, to Model[Sample, \"Native Sample Buffer for Protein Gels\"] if the Gel is a native Tris/Glycine protein gel, and to Model[Sample, \"Sample Buffer, Laemmli 2x Concentrate\"] otherwise.",
			AllowNull->False,
			Category->"Loading",
			Widget->Widget[
				Type->Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
			]
		},
		{
			OptionName->LadderVolume,
			Default->Automatic,
			Description->"The amount of reference ladder that is loaded into each of the control ladder wells on the sides of the gel.",
			ResolutionDescription->"Automatically set to the Mean of the SampleVolumes.",
			AllowNull->False,
			Category->"Loading",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Microliter,15*Microliter],
				Units->Microliter
			]
		},
		{
			OptionName->LadderLoadingBuffer,
			Default->Automatic,
			Description->"The buffer that is mixed with the Ladder before a portion of the mixture, the SampleLoadingVolume, is loaded into each of the gel wells used as a standard reference in the experiment.",
			ResolutionDescription->"Automatically set to the LoadingBuffer, unless the LadderLoadingBufferVolume has been specified as Null, in which case the LadderLoadingBuffer is also set to Null.",
			AllowNull->True,
			Category->"Loading",
			Widget->Widget[
				Type->Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
			]
		},
		{
			OptionName->LadderLoadingBufferVolume,
			Default->Automatic,
			Description->"The amount of LadderLoadingBuffer that is that is mixed with the Ladder before a portion of the mixture, the SampleLoadingVolume, is loaded into each of the gel wells used as a standard reference in the experiment.",
			ResolutionDescription->"Automatically set to the Mean of the LoadingBufferVolume option, unless the LadderLoadingBuffer has been specified as Null, in which case the LadderLoadingBufferVolume is also set to Null",
			AllowNull->True,
			Category->"Loading",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Microliter,40*Microliter],
				Units->Microliter
			]
		},
		{
			OptionName->SampleLoadingVolume,
			Default->Automatic,
			Description->"The volume of the sample and loading buffer mixture that is loaded into each gel well.",
			ResolutionDescription->"Automatically set to 10.5 uL if the Gel has 10 lanes and to 5 uL otherwise.",
			AllowNull->False,
			Category->"Loading",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[2*Microliter,14*Microliter],
				Units->Micro Liter
			]
		},
		(* Denaturation *)
		{
			OptionName->SampleDenaturing,
			Default->Automatic,
			Description->"Indicates if the mixture of input samples and loading buffer is denatured by heating before electrophoresis. The Denaturation options control the temperature and duration of this denaturation.",
			ResolutionDescription->"Automatically set to True if the Gel is a denaturing Tris/Glycine/SDS protein gel, and to False otherwise.",
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
			Description->"The temperature which the mixtures of input samples and loading buffer are heated to before being transferred to the Gel for electrophoresis.",
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
			Description->"The duration which the mixtures of input samples and loading buffer are heated to DenaturingTemperature before being transferred to the Gel for electrophoresis.",
			ResolutionDescription->"The DenaturingTime is automatically set to 5 minutes if Denaturing is True, and to Null if Denaturing is False.",
			AllowNull->True,
			Category->"Denaturation",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Minute,120*Minute],
				Units:>Minute
			]
		},
		{
			OptionName->SeparationTime,
			Default->Automatic,
			Description->"The amount of time voltage is applied across the gel before staining and imaging.",
			ResolutionDescription->"The SeparationTime is automatically set to 2 hours if the Gel is a TBE gel and to 133 minutes otherwise.",
			AllowNull->False,
			Category->"Separation",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[Minute,4*Hour],
				Units->Alternatives[Second,Minute,Hour]
			]
		},
		{
			OptionName->Voltage,
			Default->50*Volt,
			Description->"The voltage that is applied across the gel for the duration of the SeparationTime.",
			AllowNull->False,
			Category->"Separation",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[Volt,100*Volt],
				Units->Volt
			]
		},
		{
			OptionName->DutyCycle,
			Default->100*Percent,
			Description->"The percent of the SeparationTime that the Voltage is applied across the gel.",
			AllowNull->False,
			Category->"Separation",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[Percent, 100*Percent],
				Units->Percent
			]
		},
		{
			OptionName->PostRunStaining,
			Default->Automatic,
			Description->"Indicates if the gel is incubated with the StainingSolution after electrophoresis in order to visualize the analytes.",
			ResolutionDescription->"Automatically set to True if any of the StainingSolution, RinsingSolution, or PrewashingSolution options are specified, set to False if the Gel is a native TBE oligomer gel, and to True otherwise.",
			AllowNull->False,
			Category->"Imaging",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			]
		},
		{
			OptionName->PrewashingSolution,
			Default->Null,
			Description->"The solution used to rinse the gel after electrophoresis, before staining.",
			AllowNull->True,
			Category->"Imaging",
			Widget->Widget[
				Type->Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
			]
		},
		{
			OptionName->PrewashVolume,
			Default->Automatic,
			Description->"The volume of the PrewashingSolution that is used to rinse the gel after electrophoresis, before staining.",
			ResolutionDescription->"Automatically set to 12 mL if the PrewashingSolution option is specified and to Null otherwise.",
			AllowNull->True,
			Category->"Loading",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[5*Milliliter,15*Milliliter],
				Units->Milliliter
			]
		},
		{
			OptionName->PrewashingTime,
			Default->Automatic,
			Description->"The length of time the gel is soaked in PrewashingSolution after the electrophoresis is complete and before the StainingSolution is applied.",
			ResolutionDescription->"Automatically set to 6 minutes if the PrewashingSolution option is specified and to Null otherwise.",
			AllowNull->True,
			Category->"Imaging",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[6*Minute, Hour],
				Units->Alternatives[Second,Minute,Hour]
			]
		},
		{
			OptionName->StainingSolution,
			Default-> Automatic,
			Description->"The solution applied to the gel after electrophoresis to view the analytes.",
			ResolutionDescription->"Automatically set to Null if the PostRunStaining is False, to Model[Sample, StockSolution, \"10X SYBR Gold in 1X TBE\"] if the Gel is a TBE oligomer gel, and to Model[Sample,StockSolution,\"1x SYPRO Orange Protein Gel Stain in 7.5% acetic acid\"] otherwise.",
			AllowNull->True,
			Category->"Imaging",
			Widget->Widget[
				Type->Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
			]
		},
		{
			OptionName->StainVolume,
			Default->Automatic,
			Description->"The volume of the StainingSolution that is applied to the gel after electrophoresis to view the analytes.",
			ResolutionDescription->"Automatically set to 12 mL if the StainingSolution option is specified and to Null otherwise.",
			AllowNull->True,
			Category->"Imaging",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[5*Milliliter,15*Milliliter],
				Units->Milliliter
			]
		},
		{
			OptionName->StainingTime,
			Default->Automatic,
			Description->"The length of time the gel is soaked in StainingSolution after the electrophoresis is complete.",
			ResolutionDescription->"Automatically set to Null if the StainingSolution is Null, to 36 minutes if the Gel is a TBE oligomer gel and to 1 hour otherwise.",
			AllowNull->True,
			Category->"Imaging",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[6*Minute, 2*Hour],
				Units->Alternatives[Second,Minute,Hour]
			]
		},
		{
			OptionName->RinsingSolution,
			Default->Automatic,
			Description->"The buffer used to rinse the gel after staining, before imaging.",
			ResolutionDescription->"Automatically set to Null if the PostRunStaining is False, to Model[Sample, StockSolution, \"1x TBE Buffer\"] if the Gel is a TBE oligomer gel, and to Model[Sample,StockSolution,\"7.5% acetic acid in water\"] otherwise.",
			AllowNull->True,
			Category->"Imaging",
			Widget->Widget[
				Type->Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
			]
		},
		{
			OptionName->RinseVolume,
			Default->Automatic,
			Description->"The volume of the RinsingSolution that is applied to the gel after staining to remove excess StainingSolution from the gel before imaging.",
			ResolutionDescription->"Automatically set to 12 mL if the RinsingSolution option is specified and to Null otherwise.",
			AllowNull->True,
			Category->"Imaging",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[5*Milliliter,15*Milliliter],
				Units->Milliliter
			]
		},
		{
			OptionName->RinsingTime,
			Default->Automatic,
			Description->"The length of time the gel is soaked in RinsingSolution after the staining is complete. The gel is only soaked for the RinsingTime if the NumberOfRinses is larger than 1, otherwise, the images are taken directly after the RinsingSolution is added.",
			ResolutionDescription->"Automatically set 6 minutes if the RinsingSolution is specified and to Null otherwise.",
			AllowNull->True,
			Category->"Imaging",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[6*Minute, Hour],
				Units->Alternatives[Second,Minute,Hour]
			]
		},
		{
			OptionName->NumberOfRinses,
			Default->Automatic,
			Description->"The number of times the RinsingSolution is added to the gel and incubated for the RinsingTime before imaging occurs.",
			ResolutionDescription->"Automatically set to 1 if the RinsingSolution is specified and to Null otherwise.",
			AllowNull->True,
			Category->"Imaging",
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,4,1]
			]
		},
		{
			OptionName->FilterSet,
			Default->BlueFluorescence,
			Description->"Indicates which excitation/emission filter sets are used to capture the gel images in this experiemnt. BlueFluorescence indicates that a 470/35 nm bandpass excitation filter and a 540/20 nm bandpass emission filter are used. RedFluorescence indicates that a 625/15 nm bandpass excitation filter and a 677/23 nm bandpass emission filter are used.",
			AllowNull->False,
			Category->"Imaging",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[BlueFluorescence,RedFluorescence]
			]
		},
		{
			OptionName->LadderStorageCondition,
			Default->Null,
			Description->"The non-default storage condition under which the Ladder of this experiment should be stored after the protocol is completed. If left unset, the Ladder will be stored according to its current StorageCondition.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
			],
			Category->"Sample Storage"
		},
		FuntopiaSharedOptions,
		ModifyOptions[FuntopiaSharedOptions, Template, Widget -> Alternatives[
			Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,PAGE]],ObjectTypes->{Object[Protocol,PAGE]}],
			Widget[Type -> FieldReference,Pattern :>FieldReferenceP[Types[Object[Protocol,PAGE]], {UnresolvedOptions, ResolvedOptions}]]
		]],
		SamplesInStorageOptions
	}
];

(* === Errors go here === *)
Error::TooManyPAGEInputs="The maximum number of input samples for one PAGE protocol is 32. Please enter fewer input samples, or queue an additional experiment for the excess input samples.";
Error::InvalidPAGEGelMaterial="The specified Gel does not have a GelMaterial of Polyacrylamide. Please input a Polyacrylamide Gel, or consider letting the Gel option automatically resolve.";
Error::InvalidPAGENumberOfLanes="Currently, ExperimentPAGE only supports gels with 10 or 20 lanes. Please input a Gel with a NumberOfLanes that is 10 or 20, or consider letting Gel option automatically resolve.";
Error::NotEnoughVolumeToLoadPAGE="For each of the following sample(s), `1`, the sum of the corresponding SampleVolume(s) and LoadingBufferVolume(s), `2`, is less than the SampleLoadingVolume,`3`, Please ensure that there will be enough total volume to load on the gel.";
Error::InvalidPAGEInstrument="The user-supplied Instrument Option is not compatible with ExperimentPAGE. Instrument Option must be of Model Model[Instrument,Electrophoresis,\"Ranger\"].";
Error::MoreThanOnePAGEGelModel="The Objects of the supplied Gel option, `1`, have the following Models, `2`. All Gels must be of the same Model. Please ensure that the supplied Gel Objects are of the same Model.";
Error::PAGEGelModelNotCompatible="The specified Gel is not compatible with the robotic instrumentation. Please choose a Gel whose Rig field is set to Robotic.";
Error::InvalidNumberOfPAGEGels="The number of input samples, `1`, is not compatible with the Gel option, `2`. Given the number of Gel Objects specified, a minimum of `3` and a maximum of `4` samples can be run.";
Error::DuplicatePAGEGelObjects="The Gel option, `1`, contains duplicate Objects. If the Gel option is specified as a list of Objects, each Object must be unique.";
Error::ConflictingPAGEDenaturingGelOptions="The Gel option, `1`, has a Denaturing field value of `2`, which is in conflict with the DenaturingGel option, `3`. Please ensure that the DenaturingGel and Gel options are not in conflict, or consider letting these options automatically resolve.";
Error::ConflictingPAGEPostRunStainingSolutionOptions="The PostRunStaining option, `1`, is in conflict with the StainingSolution option, `2`. If PostRunStaining is True, a StainingSolution must be specified. If PostRunStaining is False, the StainingSolution must be Null. Please consider letting these options automatically resolve";
Error::ConflictingPAGEPostRunRinsingSolutionOptions="The PostRunStaining option, `1`, is in conflict with the RinsingSolution option, `2`. If PostRunStaining is False, the RinsingSolution must not be specified. Please ensure that these options are not in conflict, or consider letting these options automatically resolve";
Error::ConflictingPAGEPostRunPrewashingSolutionOptions="The PostRunStaining option, `1`, is in conflict with the PrewashingSolution option, `2`. If PostRunStaining is False, the PrewashingSolution must not be specified. Please ensure that these options are not in conflict, or consider letting these options automatically resolve";
Error::MismatchedPAGEStainingOptions="The StainingSolution, `1`, StainVolume, `2`, and StainingTime, `3`, are in conflict. Either all three options must be Null, or all three must be specified. Please consider letting these options automatically resolve";
Error::MismatchedPAGEPrewashingOptions="The PrewashingSolution, `1`, PrewashVolume, `2`, and PrewashingTime, `3`, are in conflict. Either all three options must be Null, or all three must be specified. Please consider letting these options automatically resolve";
Error::MismatchedPAGERinsingOptions="The RinsingSolution, `1`, RinseVolume, `2`, RinsingTime, `3`, and NumberOfRinses. `4`. are in conflict. Either all four options must be Null, or all three must be specified. Please consider letting these options automatically resolve";
Error::ConflictingPAGESampleDenaturingOptions="The following SampleDenaturing-related options, `1`, with values of `2` are in conflict. If SampleDenaturing is False, the DeanturingTime and DenaturingTemperature options must be Null. If SampleDenaturing is True, the other two options must be specified. Please ensure that these options are not in conflict, or consider letting the options automatically resolve.";
Error::ConflictingPAGESampleLoadingVolumeGelOptions="The SampleLoadingVolume option, `1`, is in conflict with the Gel option, `2`, which has a MaxWellVolume of `3`. Please ensure that the SampleLoadingVolume is not larger than the MaxWellVolume of the Gel.";
Error::NotEnoughLadderVolumeToLoadPAGE="The sum of the LadderVolume, `1`, and the LadderLoadingBufferVolume, `2`, is smaller than the SampleLoadingVolume, `3`. Please ensure that there will be enough Ladder / LadderLoadingBuffer mixture to load, or consider letting these options automatically resolve.";
Error::ConflictingPAGELadderLoadingBufferOptions="The LadderLoadingBuffer, `1`, and LadderLoadingBufferVolume, `2`, are in conflict. Both must be specified, or both must be Null. Please ensure that these options are not in conflict, or consider letting them automatically resolve.";
Error::TooMuchPAGEWasteVolume="The experiment is expected to generate `1` of waste on the liquid handler, which is more than the maximum allowed 400 mL. The waste volume is calulated by adding the following values. The GelBuffer waste volume is 20 mL times number of required gels, `2`. The StainingSolution waste is the StainVolume, `3`, times the number of required gels. The PrewashingSolution waste is the PrewashVolume, `4`, times the number of required gels. The RinsingSolution waste is the RinseVolume, `5`, times the NumberOfRinses, `6`, times the number of required gels. Please reduce the number of input samples, or the NumberOfRinses, or consider letting these options automatically resolve.";
(* ::Subsection:: *)
(* ExperimentPAGE *)


(* ::Subsubsection:: *)
(* ExperimentPAGE (container input)*)


ExperimentPAGE[myInputs:ListableP[ObjectP[{Object[Container,Plate],Object[Container,Vessel],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,containerToSampleResult,samples,sampleCache,
		sampleOptions,containerToSampleTests,containerToSampleOutput,listedInputs,
		validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		samplePreparationCache,updatedCache},

(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];
	listedInputs=ToList[myInputs];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
			ExperimentPAGE,
			ToList[myInputs],
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
			ExperimentPAGE,
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
				ExperimentPAGE,
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
		ExperimentPAGE[samples,ReplaceRule[sampleOptions,Cache->Flatten[{updatedCache,sampleCache}]]]
	]
];


(* ::Subsubsection:: *)
(* ExperimentPAGE (sample input)*)


ExperimentPAGE[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,listedSamples,outputSpecification,output,gatherTests,safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,expandedSafeOps,pageOptionsAssociation,
		suppliedInstrument,numberOfReplicates,name,suppliedGel,suppliedLadder,suppliedLoadingBuffer,suppliedReservoirBuffer,suppliedGelBuffer,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,
		safeOpsNamed,suppliedStainingSolution,suppliedRinsingSolution,suppliedPrewashingSolution,suppliedLadderLoadingBuffer,ladderLoadingBufferDownloadFields,samplePreparationCacheNamed,
		gelDownloadOption,ladderDownloadOption,loadingBufferDownloadOption,reservoirBufferDownloadOption,gelBufferDownloadOption,stainingSolutionDownloadOption,rinsingSolutionDownloadOption,
		gelDownloadFields,ladderDownloadFields,loadingBufferDownloadFields,reservoirBufferDownloadFields,gelBufferDownloadFields,stainingSolutionDownloadFields,rinsingSolutionDownloadFields,
		prewashingSolutionDownloadOption,prewashingSolutionDownloadFields,ladderLoadingBufferDownloadOption,
		instrumentDownloadOption,instrumentDownloadFields,allPolyacrylamideGels,
		objectSamplePacketFields,modelSamplePacketFields,objectContainerFields,modelContainerFields,
		modelContainerPacketFields,samplesContainerModelPacketFields,
		optionsWithObjects,userSpecifiedObjects,simulatedSampleQ,objectsExistQs,objectsExistTests,liquidHandlerContainers,
		listedSampleContainerPackets,listedModelInstrumentPackets,listedGelOptionPackets,listedLadderOptionPackets,
		listedLoadingBufferOptionPackets,listedReservoirBufferPackets,listedGelBufferOptionPackets,listedStainingSolutionPackets,listedRinsingSolutionPackets,
		listedPrewashingSolutionPackets,listedLadderLoadingBufferPackets,allPolyacrylamideGelPackets,
		sampleObjectsInOrder,liquidHandlerContainerPackets,cacheBall,sampleObjects,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,
		validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache
	},

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCacheNamed}=simulateSamplePreparationPackets[
			ExperimentPAGE,
			ToList[mySamples],
			ToList[listedOptions]
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
		SafeOptions[ExperimentPAGE,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentPAGE,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Sanitize the samples and options using sanitizInput funciton*)
	{mySamplesWithPreparedSamples, {safeOps, myOptionsWithPreparedSamples, samplePreparationCache}} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, {safeOpsNamed, myOptionsWithPreparedSamplesNamed, samplePreparationCacheNamed}];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentPAGE,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentPAGE,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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
		ApplyTemplateOptions[ExperimentPAGE,{ToList[mySamplesWithPreparedSamples]},ToList[myOptionsWithPreparedSamples],Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentPAGE,{ToList[mySamplesWithPreparedSamples]},ToList[myOptionsWithPreparedSamples]],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentPAGE,{mySamplesWithPreparedSamples},inheritedOptions]];

	(* --- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --- *)
	pageOptionsAssociation=Association[expandedSafeOps];


	(* Pull the info out of the options that we need *)
	(* pull out the instrument, numberOfReplicates, and name options, and other option values that can either be Models or Objects, and Denaturing *)
	{
		suppliedInstrument,numberOfReplicates,name,suppliedGel,suppliedLadder,suppliedLoadingBuffer,suppliedReservoirBuffer,
		suppliedGelBuffer,suppliedStainingSolution,suppliedRinsingSolution,suppliedPrewashingSolution,suppliedLadderLoadingBuffer
	}=Lookup[
		pageOptionsAssociation,
		{
			Instrument,NumberOfReplicates,Name,Gel,Ladder,LoadingBuffer,ReservoirBuffer,GelBuffer,StainingSolution,RinsingSolution,
			PrewashingSolution,LadderLoadingBuffer
		}
	];

	(* - Determine which fields from the various Options that can be Objects or Models or Automatic that we need to Download -- *)
	(* Gel *)
	gelDownloadOption=If[
		MatchQ[suppliedGel,Automatic],
		{Nothing},
		ToList[suppliedGel]
	];

	gelDownloadFields=Which[
		(* If the option is left as Automatic, don't download anything *)
		MatchQ[suppliedGel,Automatic],
			Nothing,

		(* If the option is an Object, download fields from the Model *)
		MatchQ[suppliedGel,ObjectP[Object[Item,Gel]]],
			Packet[Model[{Name,Denaturing,Rig,GelMaterial,GelPercentage,CrosslinkerRatio,NumberOfLanes,BufferComponents,MaxWellVolume}]],

		(* If the option is an Model, download fields *)
		MatchQ[suppliedGel,ObjectP[Model[Item,Gel]]],
			Packet[Name,Denaturing,Rig,GelMaterial,GelPercentage,CrosslinkerRatio,NumberOfLanes,BufferComponents,MaxWellVolume],

		(* If Gel is a list of objects, download fields from the Model *)
		MatchQ[suppliedGel,{ObjectP[Object[Item,Gel]]..}],
			Packet[Model[{Name,Denaturing,Rig,GelMaterial,GelPercentage,CrosslinkerRatio,NumberOfLanes,BufferComponents,MaxWellVolume}]],

		True,
			Nothing
	];

	(* - For all of the options that can be a single Object[Sample] or Model[Sample], define the Object we will be downloading from, or Nothing if Automatic - *)
	(* Ladder *)
	ladderDownloadOption=If[
		MatchQ[suppliedLadder,Automatic],
		Nothing,
		suppliedLadder
	];
	ladderDownloadFields=If[
		MatchQ[suppliedLadder,Automatic],
		Nothing,
		Packet[Composition]
	];

	(* LoadingBuffer *)
	loadingBufferDownloadOption=If[
		MatchQ[suppliedLoadingBuffer,Automatic],
		Nothing,
		suppliedLoadingBuffer
	];
	loadingBufferDownloadFields=If[
		MatchQ[suppliedLoadingBuffer,Automatic],
		Nothing,
		Packet[Composition]
	];

	(* ReservoirBuffer *)
	reservoirBufferDownloadOption=If[
		MatchQ[suppliedReservoirBuffer,Automatic],
		Nothing,
		suppliedReservoirBuffer
	];
	reservoirBufferDownloadFields=If[
		MatchQ[suppliedReservoirBuffer,Automatic],
		Nothing,
		Packet[Composition,Sterile]
	];

	(* GelBuffer *)
	gelBufferDownloadOption=If[
		MatchQ[suppliedGelBuffer,Automatic],
		Nothing,
		suppliedGelBuffer
	];
	gelBufferDownloadFields=If[
		MatchQ[suppliedGelBuffer,Automatic],
		Nothing,
		Packet[Composition,Sterile]
	];

	(* StainingSolution *)
	stainingSolutionDownloadOption=If[
		MatchQ[suppliedStainingSolution,Automatic],
		Nothing,
		suppliedStainingSolution
	];
	stainingSolutionDownloadFields=If[
		MatchQ[suppliedStainingSolution,Automatic],
		Nothing,
		Packet[Composition]
	];

	(* RinsingSolution *)
	rinsingSolutionDownloadOption=If[
		MatchQ[suppliedRinsingSolution,Automatic],
		Nothing,
		suppliedRinsingSolution
	];
	rinsingSolutionDownloadFields=If[
		MatchQ[suppliedRinsingSolution,Automatic],
		Nothing,
		Packet[Composition,Sterile]
	];

	(* Prewashing Solution *)
	prewashingSolutionDownloadOption=If[
		MatchQ[suppliedPrewashingSolution,Automatic],
		Nothing,
		suppliedPrewashingSolution
	];
	prewashingSolutionDownloadFields=If[
		MatchQ[suppliedPrewashingSolution,Automatic],
		Nothing,
		Packet[Composition,Sterile]
	];

	(* LadderLoadingBuffer Solution *)
	ladderLoadingBufferDownloadOption=If[
		MatchQ[suppliedLadderLoadingBuffer,Automatic],
		Nothing,
		suppliedLadderLoadingBuffer
	];
	ladderLoadingBufferDownloadFields=If[
		MatchQ[suppliedLadderLoadingBuffer,Automatic],
		Nothing,
		Packet[Composition]
	];

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

	(* - Get a list of all of the possible gels we may resolve to - *)
	allPolyacrylamideGels=Search[Model[Item,Gel],Rig==Robotic&&GelMaterial==Polyacrylamide];

	(* - Determine which fields we need to download from the input Objects - *)
	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerFields=SamplePreparationCacheFields[Object[Container]];
	modelContainerFields=SamplePreparationCacheFields[Model[Container]];
	modelContainerPacketFields=Packet@@Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];
	samplesContainerModelPacketFields=Packet[Container[Model[Flatten[{Object,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container]]}]]]];

	(* - Throw an error and return failed if any of the specified Objects are not members of the database - *)
	(* Any options whose values _could_ be an object *)
	optionsWithObjects = {
		Instrument,
		Ladder,
		LoadingBuffer,
		Gel,
		GelBuffer,
		ReservoirBuffer,
		StainingSolution,
		RinsingSolution,
		PrewashingSolution,
		LadderLoadingBuffer
	};

	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten@Join[ToList[mySamples],Lookup[ToList[myOptions],optionsWithObjects,Null]],
		ObjectP[]
	];

	(* Check that the specified objects exist or are visible to the current user *)
	simulatedSampleQ = Lookup[
		(*Quiet extra errors when sample does not exist, which we will scream about later*)
		Quiet[fetchPacketFromCache[#,samplePreparationCache]],
		Simulated,
		False
	]&/@userSpecifiedObjects;
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

	(* - All liquid handler compatible containers (for resources and Aliquot) - *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* Big download call, get it into the form we want afterwards *)
	{
		listedSampleContainerPackets,listedModelInstrumentPackets,listedGelOptionPackets,listedLadderOptionPackets,
		listedLoadingBufferOptionPackets,listedReservoirBufferPackets,listedGelBufferOptionPackets,listedStainingSolutionPackets,listedRinsingSolutionPackets,
		listedPrewashingSolutionPackets,listedLadderLoadingBufferPackets,allPolyacrylamideGelPackets,
		sampleObjectsInOrder,liquidHandlerContainerPackets
	}=Quiet[
		Download[
			{
				ToList[mySamplesWithPreparedSamples],
				{instrumentDownloadOption},
				gelDownloadOption,
				{ladderDownloadOption},
				{loadingBufferDownloadOption},
				{reservoirBufferDownloadOption},
				{gelBufferDownloadOption},
				{stainingSolutionDownloadOption},
				{rinsingSolutionDownloadOption},
				{prewashingSolutionDownloadOption},
				{ladderLoadingBufferDownloadOption},
				allPolyacrylamideGels,
				listedSamples,
				liquidHandlerContainers
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Container[objectContainerFields]],
					Packet[Container[Model][modelContainerFields]],
					Packet[Composition[[All, 2]][{Object,Molecule,MolecularWeight}]],
					Packet[Analytes[{Object,Molecule,MolecularWeight}]],
					Packet[Container[{Model, Contents, Name, Status, Sterile, TareWeight}]],
					samplesContainerModelPacketFields
				},
				{instrumentDownloadFields},
				{gelDownloadFields},
				{ladderDownloadFields},
				{loadingBufferDownloadFields},
				{reservoirBufferDownloadFields},
				{gelBufferDownloadFields},
				{stainingSolutionDownloadFields},
				{rinsingSolutionDownloadFields},
				{prewashingSolutionDownloadFields},
				{ladderLoadingBufferDownloadFields},
				{Packet[Name,Denaturing,Rig,GelMaterial,GelPercentage,CrosslinkerRatio,NumberOfLanes,BufferComponents,MaxWellVolume]},
				{Packet[Object]},
				{modelContainerPacketFields}
			},
			Cache->Flatten[{Lookup[expandedSafeOps,Cache,{}],samplePreparationCache}],
			Date->Now
		],
		{Download::FieldDoesntExist,Download::MissingCacheField}
	];

	(* Flatten the lists of packets *)
	cacheBall=FlattenCachePackets[
     {
			 samplePreparationCache,listedSampleContainerPackets,listedModelInstrumentPackets,listedGelOptionPackets,listedLadderOptionPackets,
			 listedLoadingBufferOptionPackets,listedReservoirBufferPackets,listedGelBufferOptionPackets,listedStainingSolutionPackets,
			 listedPrewashingSolutionPackets,listedRinsingSolutionPackets,allPolyacrylamideGelPackets,
			 listedLadderLoadingBufferPackets,liquidHandlerContainerPackets
		 }
	 ];

	(* Get a list of the input samples by ID in order to pass into the helper functions *)
	sampleObjects=Lookup[Flatten[sampleObjectsInOrder],Object];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
	(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentPAGEOptions[sampleObjects,expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

	(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentPAGEOptions[sampleObjects,expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentPAGE,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentPAGE,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		pageResourcePackets[sampleObjects,templatedOptions,resolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{pageResourcePackets[sampleObjects,templatedOptions,resolvedOptions,Cache->cacheBall,Output->Result],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentPAGE,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,PAGE],
			Cache->samplePreparationCache
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result ->protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentPAGE,collapsedResolvedOptions],
		Preview -> Null
	}
];


(* ::Subsubsection:: *)
(*resolveExperimentPAGEOptions*)


DefineOptions[
	resolveExperimentPAGEOptions,
	Options:>{HelperOutputOption,CacheOption}
];

resolveExperimentPAGEOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentPAGEOptions]]:=Module[
	{
		outputSpecification,output,gatherTests,messages,notInEngine,cache,samplePrepOptions,PAGENewOptions,simulatedSamples,
		resolvedSamplePrepOptions,simulatedCache,samplePrepTests,pageOptionsAssociation,listedModelInstrumentPackets,suppliedInstrument,
		numberOfReplicates,name,suppliedGel,suppliedDenaturingGel,suppliedLadder,suppliedLoadingBuffer,suppliedReservoirBuffer,suppliedGelBuffer,suppliedStainingSolution,suppliedRinsingSolution,
		suppliedLadderStorageCondition,suppliedSamplesInStorageCondition,suppliedPrewashingSolution,suppliedLadderLoadingBuffer,suppliedLadderVolume,
		suppliedSampleDenaturing,
		suppliedSampleLoadingVolume,suppliedPostRunStaining,suppliedStainingTime,suppliedSeparationTime,suppliedVoltage,suppliedDutyCycle,roundedExperimentOptionsList,allOptionsRounded,validInstrumentP,invalidUnsupportedInstrumentOption,validInstrumentTests,
		gelDownloadOption,gelDownloadFields,ladderDownloadOption,loadingBufferDownloadOption,reservoirBufferDownloadOption,gelBufferDownloadOption,stainingSolutionDownloadOption,rinsingSolutionDownloadOption,
		ladderDownloadFields,loadingBufferDownloadFields,reservoirBufferDownloadFields,gelBufferDownloadFields,stainingSolutionDownloadFields,rinsingSolutionDownloadFields,objectSamplePacketFields,
		prewashingSolutionDownloadOption,prewashingSolutionDownloadFields,ladderLoadingBufferDownloadOption,ladderLoadingBufferDownloadFields,
		instrumentDownloadOption,instrumentDownloadFields,modelSamplePacketFields,objectContainerFields,modelContainerPacketFields,
		samplesContainerModelPacketFields,liquidHandlerContainers,
		listedSampleContainerPackets,listedGelOptionPackets,listedLadderOptionPackets,listedLoadingBufferOptionPackets,
		listedReservoirBufferPackets,listedGelBufferOptionPackets,listedStainingSolutionPackets,listedRinsingSolutionPackets,listedLadderLoadingBufferPackets,
		listedPrewashingSolutionPackets,
		liquidHandlerContainerPackets,samplePackets,sampleModelPackets,sampleCompositionPackets,sampleAnalytesPackets,sampleContainerPackets,
		suppliedInstrumentModel,gelOptionPacket,ladderOptionPacket,loadingBufferOptionPacket,reservoirBufferOptionPacket,
		gelBufferOptionPacket,stainingSolutionOptionPacket,rinsingSolutionOptionPacket,prewashingSolutionOptionPacket,
		ladderLoadingBufferOptionPacket,simulatedSampleContainers,
		discardedSamplePackets,discardedInvalidInputs,discardedTests,validSamplesInStorageBools,samplesInStorageTests,invalidSamplesInStorageConditionOptions,
		tooManyInvalidInputs,tooManyInputsTests,
		suppliedNumberOfGelLanes,suppliedGelMaterial,maxSampleLanes,invalidGelMaterialOptions,gelMaterialTests,invalidNumberOfGelLanesOptions,numberOfLGelLanesTests,optionPrecisions,
		roundedExperimentOptions,optionPrecisionTests,suppliedGelOptionRig,suppliedGelDenaturingField,suppliedGelBufferComponents,suppliedMaxWellVolume,gelInvalidOption,gelTests,
		gelOptionModels,uniqueGelOptionModels,gelListQ,invalidMultipleGelObjectModelOptions,multipleGelObjectModelTests,invalidDuplicateGelOptions,
		duplicateGelObjectsTests,objectGelQ,
		numberOfGelObjects,numberOfSampleLanes,minimumSampleLanes,maximumSampleLanes,invalidNumberOfGelsOptions,invalidNumberOfGelsTests,
		compatibleMaterialsBool,compatibleMaterialsTests,compatibleMaterialsInvalidOption,validNameQ,nameInvalidOptions,validNameTest,
		sampleCompositionPacketsNoNull,compositionIDModels,compositionIDMolecules,compositionIDMolecularWeights,sampleOligomerIDModels,
		sampleOligomerMolecules,sampleStructureOrStrandOligomerMolecules,sampleStrandLengths,longestCompositionOligomerLengths,sampleProteinIDModels,
		sampleProteinIDMoleculeMolecularWeights,meanSampleProteinIDMoleculeMolecularWeights,preferredCompositionAnalyteType,
		longestAnalyteOligomerLengths,meanAnalyteProteinMolecularWeights,
		preferredAnalytesAnalyteType,
		targetOligomerStrandLengths,averageTargetOligomerStrandLength,proteinMeanMolecularWeights,averageProteinMolecularWeight,preferredAnalyteTypes,
		preferredAnalyteType,
		numberOfSamples,intNumberOfReplicates,
		suppliedSampleVolume,suppliedLoadingBufferVolume,suppliedStainVolume,suppliedPrewashVolume,suppliedPrewashingTime,
		suppliedRinseVolume,suppliedRinsingTime,suppliedNumberOfRinses,suppliedLadderLoadingBufferVolume,
		resolvedDenaturingGel,resolvedGel,numberOfGelLanes,gelMaterial,gelRig,gelDenaturingField,gelBufferComponents,maxWellVolume,
		gelBufferComponentsObjects,
		denaturingOligomerGelQ,nonDenaturingOligomerGelQ,denaturingTrisGlycineGelQ,nativeTrisGlycineGelQ,bisTrisGelQ,
		resolvedLadder,resolvedLoadingBuffer,resolvedLadderLoadingBuffer,
		resolvedReservoirBuffer,resolvedGelBuffer,resolvedSampleLoadingVolume,resolvedPostRunStaining,
		resolvedStainingSolution,resolvedStainVolume,resolvedRinsingSolution,
		resolvedSeparationTime,resolvedVoltage,resolvedDutyCycle,resolvedStainingTime,resolvedPrewashingSolution,resolvedPrewashVolume,resolvedPrewashingTime,
		resolvedRinseVolume,resolvedRinsingTime,resolvedNumberOfRinses,
		resolvedLadderVolume,mapThreadFriendlyOptions,resolvedSampleVolume,resolvedLoadingBufferVolume,
		notEnoughVolumeErrors,resolvedLadderLoadingBufferVolume,
		requiredAliquotAmounts,liquidHandlerContainerModels,liquidHandlerContainerMaxVolumes,potentialAliquotContainers,simulatedSamplesContainerModels,
		suppliedDenaturingTime,suppliedDenaturingTemperature,resolvedSampleDenaturing,resolvedDenaturingTime,resolvedDenaturingTemperature,
		conflictingDenaturingOptionValues,conflictingDenaturingOptionNames,conflictingSampleDenaturingTests,
		notEnoughVolumeErrorQ,failingSampleAndBufferLoadingVolumeSamples,passingSampleAndBufferLoadingVolumeSamples,failingSampleVolumes,failingLoadingBufferVolumes,
		totalFailingVolumes,invalidNotEnoughVolumeOptions,sampleLoadingBufferVolumeTests,invalidLadderLoadingBufferOptions,
		conflictingLadderLoadingBufferTests,invalidEnoughLadderOptions,
		notEnoughLadderVolumeTests,invalidMismatchedStainingOptions,invalidMismatchedStainingOptionTests,invalidMismatchedPrewashingOptions,
		invalidMismatchedPrewashingOptionTests,invalidMismatchedRinsingOptions,invalidMismatchedRinsingOptionTests,
		invalidPostStainRinsingMismatchOptions,invalidPostStainRinsingOptionsTests,invalidPostStainPrewashingMismatchOptions,
		invalidPostStainPrewashingOptionsTests,
		invalidDenaturingGelOptions,denaturingGelOptionTests,
		invalidPostStainMismatchOptions,invalidStainingOptionsTests,invalidMaxWellVolumeOptions,invalidSampleLoadingVolumeGelTests,
		numberOfGels,totalWasteVolume,invalidWasteVolumeOptions,invalidWasteVolumeTests,
		requiredAliquotContainers,
		invalidInputs,invalidOptions,resolvedOptions,resolvedAliquotOptions,aliquotTests,email,resolvedPostProcessingOptions
	},

(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];

	(* Determine if we are throwing messages or not *)
	messages=!gatherTests;

	(* Determine if we are in Engine or not, in Engine we silence warnings *)
	notInEngine=Not[MatchQ[$ECLApplication,Engine]];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions],Cache,{}];

	(* Seperate out our PAGENew options from our Sample Prep options. *)
	{samplePrepOptions,PAGENewOptions}=splitPrepOptions[myOptions];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	pageOptionsAssociation = Association[PAGENewOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,simulatedCache},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptions[ExperimentPAGE,mySamples,samplePrepOptions,Cache->cache,Output->{Result,Tests}],
		{resolveSamplePrepOptions[ExperimentPAGE,mySamples,samplePrepOptions,Cache->cache,Output->Result],{}}
	];

	(* ---Make our one big Download call --- *)
	(* Pull out the instrument, numberOfReplicates, and name options, need to Download from Instrument and suppliedGel and don't need to resolve the rest *)
	{
		suppliedInstrument,numberOfReplicates,name,suppliedGel,suppliedDenaturingGel,suppliedLadder,suppliedLoadingBuffer,suppliedReservoirBuffer,
		suppliedGelBuffer,suppliedPostRunStaining,suppliedStainingSolution,suppliedRinsingSolution,suppliedLadderStorageCondition,
		suppliedSamplesInStorageCondition,suppliedPrewashingSolution,suppliedLadderLoadingBuffer,
		suppliedSampleDenaturing
	}=Lookup[pageOptionsAssociation,
		{
			Instrument,NumberOfReplicates,Name,Gel,DenaturingGel,Ladder,LoadingBuffer,ReservoirBuffer,GelBuffer,PostRunStaining,StainingSolution,
			RinsingSolution,LadderStorageCondition,SamplesInStorageCondition,PrewashingSolution,LadderLoadingBuffer,
			SampleDenaturing
		}
	];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to Download -- *)
	(* Gel *)
	gelDownloadOption=If[
		MatchQ[suppliedGel,Automatic],
		{Nothing},
		ToList[suppliedGel]
	];

	gelDownloadFields=Which[
		(* If the option is left as Automatic, don't download anything *)
		MatchQ[suppliedGel,Automatic],
			Nothing,

		(* If the option is an Object, download fields from the Model *)
		MatchQ[suppliedGel,ObjectP[Object[Item,Gel]]],
			Packet[Model[{Name,Denaturing,Rig,GelMaterial,GelPercentage,CrosslinkerRatio,NumberOfLanes,BufferComponents,MaxWellVolume}]],

		(* If the option is an Model, download fields *)
		MatchQ[suppliedGel,ObjectP[Model[Item,Gel]]],
			Packet[Name,Denaturing,Rig,GelMaterial,GelPercentage,CrosslinkerRatio,NumberOfLanes,BufferComponents,MaxWellVolume],

		(* If Gel is a list of objects, download fields from the Model *)
		MatchQ[suppliedGel,{ObjectP[Object[Item,Gel]]..}],
			Packet[Model[{Name,Denaturing,Rig,GelMaterial,GelPercentage,CrosslinkerRatio,NumberOfLanes,BufferComponents,MaxWellVolume}]],

		True,
			Nothing
	];

	(* - For all of the options that can be a single Object[Sample] or Model[Sample], define the Object we will be downloading from, or Nothing if Automatic - *)
	(* Ladder *)
	ladderDownloadOption=If[
		MatchQ[suppliedLadder,Automatic],
		Nothing,
		suppliedLadder
	];
	ladderDownloadFields=If[
		MatchQ[suppliedLadder,Automatic],
		Nothing,
		Packet[Composition]
	];

	(* LoadingBuffer *)
	loadingBufferDownloadOption=If[
		MatchQ[suppliedLoadingBuffer,Automatic],
		Nothing,
		suppliedLoadingBuffer
	];
	loadingBufferDownloadFields=If[
		MatchQ[suppliedLoadingBuffer,Automatic],
		Nothing,
		Packet[Composition]
	];

	(* ReservoirBuffer *)
	reservoirBufferDownloadOption=If[
		MatchQ[suppliedReservoirBuffer,Automatic],
		Nothing,
		suppliedReservoirBuffer
	];
	reservoirBufferDownloadFields=If[
		MatchQ[suppliedReservoirBuffer,Automatic],
		Nothing,
		Packet[Composition]
	];

	(* GelBuffer *)
	gelBufferDownloadOption=If[
		MatchQ[suppliedGelBuffer,Automatic],
		Nothing,
		suppliedGelBuffer
	];
	gelBufferDownloadFields=If[
		MatchQ[suppliedGelBuffer,Automatic],
		Nothing,
		Packet[Composition]
	];

	(* StainingSolution *)
	stainingSolutionDownloadOption=If[
		MatchQ[suppliedStainingSolution,Automatic],
		Nothing,
		suppliedStainingSolution
	];
	stainingSolutionDownloadFields=If[
		MatchQ[suppliedStainingSolution,Automatic],
		Nothing,
		Packet[Composition]
	];

	(* RinsingSolution *)
	rinsingSolutionDownloadOption=If[
		MatchQ[suppliedRinsingSolution,Automatic],
		Nothing,
		suppliedRinsingSolution
	];
	rinsingSolutionDownloadFields=If[
		MatchQ[suppliedRinsingSolution,Automatic],
		Nothing,
		Packet[Composition]
	];

	(* Prewashing Solution *)
	prewashingSolutionDownloadOption=If[
		MatchQ[suppliedPrewashingSolution,Automatic],
		Nothing,
		suppliedPrewashingSolution
	];
	prewashingSolutionDownloadFields=If[
		MatchQ[suppliedPrewashingSolution,Automatic],
		Nothing,
		Packet[Composition]
	];

	(* LadderLoadingBuffer Solution *)
	ladderLoadingBufferDownloadOption=If[
		MatchQ[suppliedLadderLoadingBuffer,Automatic],
		Nothing,
		suppliedLadderLoadingBuffer
	];
	ladderLoadingBufferDownloadFields=If[
		MatchQ[suppliedLadderLoadingBuffer,Automatic],
		Nothing,
		Packet[Composition]
	];

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

	(* - Determine which fields we need to download from the input Objects - *)
	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerFields=SamplePreparationCacheFields[Object[Container]];
	modelContainerPacketFields=Packet@@Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];
	samplesContainerModelPacketFields=Packet[Container[Model[Flatten[{Object,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container]]}]]]];

	(* - All liquid handler compatible containers (for resources and Aliquot) - *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* Extract the packets that we need from our downloaded cache. doing oligomers and others separately due to different needed Fields *)
	{
		listedSampleContainerPackets,listedModelInstrumentPackets,listedGelOptionPackets,listedLadderOptionPackets,
		listedLoadingBufferOptionPackets,listedReservoirBufferPackets,listedGelBufferOptionPackets,listedStainingSolutionPackets,listedRinsingSolutionPackets,
		listedPrewashingSolutionPackets,listedLadderLoadingBufferPackets,liquidHandlerContainerPackets
	}=Quiet[
		Download[
			{
				simulatedSamples,
				{instrumentDownloadOption},
				gelDownloadOption,
				{ladderDownloadOption},
				{loadingBufferDownloadOption},
				{reservoirBufferDownloadOption},
				{gelBufferDownloadOption},
				{stainingSolutionDownloadOption},
				{rinsingSolutionDownloadOption},
				{prewashingSolutionDownloadOption},
				{ladderLoadingBufferDownloadOption},
				liquidHandlerContainers
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Composition[[All, 2]][{Object,Molecule,MolecularWeight}]],
					Packet[Analytes[{Object,Molecule,MolecularWeight}]],
					Packet[Container[{Model, Contents, Name, Status, Sterile, TareWeight}]],
					samplesContainerModelPacketFields
				},
				{instrumentDownloadFields},
				{gelDownloadFields},
				{ladderDownloadFields},
				{loadingBufferDownloadFields},
				{reservoirBufferDownloadFields},
				{gelBufferDownloadFields},
				{stainingSolutionDownloadFields},
				{rinsingSolutionDownloadFields},
				{prewashingSolutionDownloadFields},
				{ladderLoadingBufferDownloadFields},
				{modelContainerPacketFields}
			},
			Cache->simulatedCache,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* --- Extract out the packets from the download --- *)
	(* -- sample packets -- *)
	samplePackets=listedSampleContainerPackets[[All,1]];
	sampleModelPackets=listedSampleContainerPackets[[All,2]];
	sampleCompositionPackets=listedSampleContainerPackets[[All,3]];
	sampleAnalytesPackets=listedSampleContainerPackets[[All,4]];
	sampleContainerPackets=listedSampleContainerPackets[[All,5]];

	(* -- Instrument packet --*)
	(* - Find the Model of the instrument, if it was specified - *)
	suppliedInstrumentModel=If[
		MatchQ[listedModelInstrumentPackets,{}],
		Null,
		FirstOrDefault[Lookup[Flatten[listedModelInstrumentPackets],Object]]
	];

	(* make the gelOptionPacket an empty association if the Option is set to automatic *)
	gelOptionPacket=FirstOrDefault[FirstOrDefault[listedGelOptionPackets],<||>];

	(* make the ladderOptionPacket an empty association if the Option is set to automatic *)
	ladderOptionPacket=FirstOrDefault[FirstOrDefault[listedLadderOptionPackets],<||>];

	(* make the loadingBufferOptionPacket an empty association if the Option is set to autoamtic *)
	loadingBufferOptionPacket=FirstOrDefault[FirstOrDefault[listedLoadingBufferOptionPackets],<||>];

	(* make the reservoirBufferOptionsPacket an epty association if the Option is set to automatic *)
	reservoirBufferOptionPacket=FirstOrDefault[FirstOrDefault[listedReservoirBufferPackets],<||>];

	(* make the gelBufferOptionPacket an empty association if the Option is set to automatic*)
	gelBufferOptionPacket=FirstOrDefault[FirstOrDefault[listedGelBufferOptionPackets],<||>];

	(* make the stainingSolutionOptionPacket an empty association if the Option is set to automatic *)
	stainingSolutionOptionPacket=FirstOrDefault[FirstOrDefault[listedStainingSolutionPackets],<||>];

	(* make the rinsingSolutionOptionPacket an empty association if the Option is set to automatic *)
	rinsingSolutionOptionPacket=FirstOrDefault[FirstOrDefault[listedRinsingSolutionPackets],<||>];

	(* make the prewashingSolutionOptionPacket an empty association if the Option is set to automatic *)
	prewashingSolutionOptionPacket=FirstOrDefault[FirstOrDefault[listedPrewashingSolutionPackets],<||>];

	(* make the ladderLoadingBufferOptionPacket an empty association if the Option is set to automatic *)
	ladderLoadingBufferOptionPacket=FirstOrDefault[FirstOrDefault[listedLadderOptionPackets],<||>];

	(* Find the containers of the simulated samples *)
	simulatedSampleContainers=Lookup[sampleContainerPackets,Object];

	(*-- INPUT VALIDATION CHECKS --*)
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

	(* - Pull information from the gelOptionPacket - *)
	(* Lookup the NumberOfLanes field from the gelOptionPacket -  *)
	suppliedNumberOfGelLanes=Lookup[gelOptionPacket,NumberOfLanes];

	(* Lookup the GelMaterial field from the gelOptionPacket - set default to Polyacrylamide if the option is Automatic since we resolve to a polyacrylamide gel *)
	suppliedGelMaterial=Lookup[gelOptionPacket,GelMaterial];

	(* Lookup the Rig field from the gelOptionPacket *)
	suppliedGelOptionRig=Lookup[gelOptionPacket,Rig];

	(* Lookup the Denaturing field from the gelOptionPacket *)
	suppliedGelDenaturingField=Lookup[gelOptionPacket,Denaturing];

	(* Lookup the BufferComponents field of the gelOptionPacket *)
	suppliedGelBufferComponents=Lookup[gelOptionPacket,BufferComponents];

	(* Lookup the MaxWellVolume field from the gelOptionPacket *)
	suppliedMaxWellVolume=Lookup[gelOptionPacket,MaxWellVolume];

	(* - Throw an error if there are too many input samples - *)
	(* convert numberOfReplicates such that Null->1 *)
	intNumberOfReplicates=numberOfReplicates/.{Null->1};

	(* make a variable that is the number of input samples *)
	numberOfSamples=(Length[simulatedSamples]*intNumberOfReplicates);

	(*-- OPTION PRECISION CHECKS --*)
	(* First, define the option precisions that need to be checked for PAGE *)
	optionPrecisions={
		{SampleVolume,10^-1*Microliter},
		{LadderVolume,10^-1*Microliter},
		{LoadingBufferVolume,10^-1*Microliter},
		{SampleLoadingVolume,10^-1*Microliter},
		{SeparationTime,10^0*Second},
		{StainVolume,10^0*Milliliter},
		{StainingTime,10^0*Minute},
		{Voltage,10^0*Volt},
		{DutyCycle,10^0*Percent},
		{PrewashVolume,10^0*Milliliter},
		{PrewashingTime,10^0*Minute},
		{RinseVolume,10^0*Milliliter},
		{RinsingTime,10^0*Minute},
		{LadderLoadingBufferVolume,10^-1*Microliter},
		{DenaturingTemperature,10^-1*Celsius},
		{DenaturingTime,10^0*Minute}
	};

	(* Verify that the experiment options are not overly precise *)
	{roundedExperimentOptions,optionPrecisionTests}=If[gatherTests,

		(*If we are gathering tests *)
		RoundOptionPrecision[pageOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],

		(* Otherwise *)
		{RoundOptionPrecision[pageOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
	];

	(* --- set the option variables that will be used during option resolution that need to be rounded--- *)
	{
		suppliedSampleLoadingVolume,suppliedLadderVolume,suppliedStainingTime,suppliedSeparationTime,suppliedVoltage,
		suppliedDutyCycle,suppliedSampleVolume,suppliedLoadingBufferVolume,suppliedStainVolume,suppliedPrewashVolume,suppliedPrewashingTime,
		suppliedRinseVolume,suppliedRinsingTime,suppliedNumberOfRinses,suppliedLadderLoadingBufferVolume,suppliedDenaturingTime,
		suppliedDenaturingTemperature
	}=Lookup[roundedExperimentOptions,
		{
			SampleLoadingVolume,LadderVolume,StainingTime,SeparationTime,Voltage,DutyCycle,SampleVolume,LoadingBufferVolume,
			StainVolume,PrewashVolume,PrewashingTime,RinseVolume,RinsingTime,NumberOfRinses,LadderLoadingBufferVolume,
			DenaturingTime,DenaturingTemperature
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

	(* ---Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument --- *)
	(* call CompatibleMaterialsQ and figure out if materials are compatible *)
	{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[suppliedInstrument,simulatedSamples,Cache->simulatedCache,Output->{Result,Tests}],
		{CompatibleMaterialsQ[suppliedInstrument,simulatedSamples,Cache->simulatedCache,Messages->messages],{}}
	];

	(* If the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidOption=If[Not[compatibleMaterialsBool]&&messages,
		{Instrument},
		{}
	];

	(* --- Check to see if the Name option is properly specified --- *)
	validNameQ=If[MatchQ[name,_String],
		Not[DatabaseMemberQ[Object[Protocol,PAGE,Lookup[roundedExperimentOptions,Name]]]],
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions=If[Not[validNameQ]&&messages,
		(
			Message[Error::DuplicateName,"PAGE protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already a PAGE protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* === Get information about the Proteins and Oligomers present in the Composition and Analytes fields of the input samples === *)
	(* Want to know the longest Oligomer present in each Sample, and the average MW of proteins in each Sample *)
	(* Also want to know if there are more Oligomers or Proteins present in each sample *)
	(* == First, the Compositions == *)
	(* - First, get rid of any Nulls present in the sampleCompositionPackets - *)
	sampleCompositionPacketsNoNull=Cases[#,PacketP[]]&/@sampleCompositionPackets;

	(* - From this list of list of Packets, Lookup the Object, Molecule, and MolecularWeight of each Packet - *)
	compositionIDModels=Lookup[#,Object]&/@sampleCompositionPacketsNoNull;
	compositionIDMolecules=Lookup[#,Molecule]&/@sampleCompositionPacketsNoNull;
	compositionIDMolecularWeights=Lookup[#,MolecularWeight]&/@sampleCompositionPacketsNoNull;

	(* - Do stuff to the Oligomer ID Molecules to figure out what the longest Oligomer in the Composition field of each SampleIn is - *)
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
	longestCompositionOligomerLengths=Map[
		If[MatchQ[#,{}],
			Null,
			Last[Sort[#]]
		]&,
		sampleStrandLengths
	];

	(* - Do stuff to the Protein ID Molecules to figure out what the average MolecularWeight of each SamplesIn Protein ID Models in the Composition field - *)
	(* Get a list of all of the ID Models that are Oligomers for the input samples *)
	sampleProteinIDModels=Cases[#,ObjectP[Model[Molecule,Protein]]]&/@compositionIDModels;

	sampleProteinIDMoleculeMolecularWeights=MapThread[
		PickList[#1,#2,ObjectP[#3]]&,
		{compositionIDMolecularWeights,compositionIDModels,sampleProteinIDModels}
	];

	(* Get the average protein molecular weight for each SamplesIn Composition *)
	meanSampleProteinIDMoleculeMolecularWeights=Map[
		If[MatchQ[#,{}],
			Null,
			Mean[#]
		]&,
		sampleProteinIDMoleculeMolecularWeights
	];

	(* - Lastly, for each input sample, determine if the composition suggests that we want an Oligomer or a Protein gel - *)
	preferredCompositionAnalyteType=MapThread[

		(* For each sample in, determine if there are more Oligomers or Proteins in the Composition *)
		Which[

			(* If there are the same number of Oligomers and Proteins in the Analytes field *)
			Length[#1]==Length[#2],
				Null,

			(* If there are more Oligomers than Proteins in the Analytes field *)
			Length[#1]>Length[#2],
				Oligomer,

			(* If there are more Proteins than Oligomers in the Analytes field *)
			Length[#1]<Length[#2],
				Protein,

			(* Catch all that won't come up *)
			True,
				Null
		]&,
		{sampleOligomerIDModels,sampleProteinIDModels}
	];

	(* == Also do similar things with the Analytes field, the results from the Analytes field will trump the results from the Composition field for a
	given SampleIn == *)
	(* -- Find the Length of the largest Oligomer present in the Analytes field of each input, and the mean MW of the proteins present -- *)
	{longestAnalyteOligomerLengths,meanAnalyteProteinMolecularWeights,preferredAnalytesAnalyteType}=Transpose[
		Map[
			If[
				(* IF the Analytes field contains nothing for the sample *)
				MatchQ[#,{}],

				(* THEN set the length to Null for this sample *)
				{Null,Null,Null},

				(* ELSE we need to figure out which the longest oligomer  *)
				Module[
					{
						analyteIDModels,analyteIDModelMolecules,analyteIDModelMolecularWeights,analyteOligomerIDModels,analyteProteinIDModels,
						analytesOligomerMolecules,structureOrStrandOligomerMolecules,analyteStrandLengths,longestAnalyteOligomerLength,
						analytesProteinMolecularWeights,averageProteinMolecularWeight,preferredAnalyteGelType
					},

					(* Get the Objects of the ID Models *)
					analyteIDModels=Lookup[#,Object];

					(* Get the Molecules of the ID Models *)
					analyteIDModelMolecules=Lookup[#,Molecule];

					(* Get the MolecularWeights of the ID Models *)
					analyteIDModelMolecularWeights=Lookup[#,MolecularWeight];

					(* Make a list of the analyteIDModelObjects that are of Type Model[Molecule,Oligomer] *)
					analyteOligomerIDModels=Cases[analyteIDModels,ObjectP[Model[Molecule,Oligomer]]];

					(* Make a list of the analyteIDModelObjects that are of Type Model[Molecule,Protein] *)
					analyteProteinIDModels=Cases[analyteIDModels,ObjectP[Model[Molecule,Protein]]];

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

					(* Get a list of the Molecules that correspond to the Model[Molecule,Oligomer]s present in the Analytes field for this sample *)
					analytesProteinMolecularWeights=PickList[analyteIDModelMolecularWeights,analyteIDModels,ObjectP[analyteProteinIDModels]];

					(* Get the average MolecularWeight of the Protein ID Models *)
					averageProteinMolecularWeight=If[MatchQ[analytesProteinMolecularWeights,{}],
						Null,
						Mean[analytesProteinMolecularWeights]
					];

					(* - Lastly, figure out if there are more Oligomers or Proteins present in the Analytes field to help determine which type of gel we
					want to resolve to - *)
					preferredAnalyteGelType=Which[

						(* If there are the same number of Oligomers and Proteins in the Analytes field *)
						Length[analyteOligomerIDModels]==Length[analyteProteinIDModels],
							Null,

						(* If there are more Oligomers than Proteins in the Analytes field *)
						Length[analyteOligomerIDModels]>Length[analyteProteinIDModels],
							Oligomer,

						(* If there are more Proteins than Oligomers in the Analytes field *)
						Length[analyteOligomerIDModels]<Length[analyteProteinIDModels],
							Protein,

						(* Catch all that won't come up *)
						True,
							Null
					];

					(* Return the Length of the longest Oligomer present in the Analytes field of the Sample, and the mean of the Protein MolecularWeights *)
					{longestAnalyteOligomerLength,averageProteinMolecularWeight,preferredAnalyteGelType}
				]
			]&,
			sampleAnalytesPackets
		]
	];

	(* -- Make a list of the Lengths of the target Oligomer Strands, from the Analyte if it exists, or from the Composition of SamplesIn if not -- *)
	targetOligomerStrandLengths=MapThread[
		If[MatchQ[#1,Null],
			#2,
			#1
		]&,
		{longestAnalyteOligomerLengths,longestCompositionOligomerLengths}
	];

	(* - Take the average of the non-Null values in targetOligomerStrandLengths.  If the list only contains Null set the average to 0 - *)
	averageTargetOligomerStrandLength=If[
		MatchQ[targetOligomerStrandLengths,{Null..}],
		0,
		SafeRound[Mean[Cases[targetOligomerStrandLengths,Except[Null]]],10^0]
	];

	(* -- Make a list of the mean MolecularWeights of the Proteins, from the Analyte if it exists, or from the Composition of SamplesIn if not -- *)
	proteinMeanMolecularWeights=MapThread[
		If[MatchQ[#1,Null],
			#2,
			#1
		]&,
		{meanAnalyteProteinMolecularWeights,meanSampleProteinIDMoleculeMolecularWeights}
	];

	(* - Take the average of the non-Null values in proteinMeanMolecularWeights.  If the list only contains Null set the average to 0 g/mol  - *)
	averageProteinMolecularWeight=If[
		MatchQ[proteinMeanMolecularWeights,{Null..}],
		0*(Gram/Mole),
		SafeRound[Mean[Cases[proteinMeanMolecularWeights,Except[Null]]],10^0*(Gram/Mole)]
	];

	(* --- Determine which type of Gel we want to resolve to (Protein vs Oligomer) --- *)
	(* - Get the preferred gel analyte type for each sample in, taking info preferentially from the Analyte field - *)
	preferredAnalyteTypes=MapThread[
		If[MatchQ[#1,Null],
			#2,
			#1
		]&,
		{preferredAnalytesAnalyteType,preferredCompositionAnalyteType}
	];

	(* Based on the PreferredAnalyteTypes, figure out which member is the most prevelant - if all Null, choose Oligomer *)
	preferredAnalyteType=If[

		(* IF the list of preferredAnalyteTypes is just a bunch of Nulls *)
		MatchQ[preferredAnalyteTypes,{Null..}],

		(* THEN choose Oligomer *)
		Oligomer,

		(* ELSE, get the most frequent analyte type (Protein or Oligomer) in the list, after getting rid of Nulls
		 If Oligomer and Protein are both present in equal amounts, the code below defaults to Oligomer *)
		FirstOrDefault[
			FirstOrDefault[
				(* This SortBy returns a list in form {{Type,Integer}..}, with the first type listed being the one with the largest Integer, with Oligomer listed
				 first if the integer is the same for Oligomer and Protein *)
				SortBy[
					Tally[
						Cases[preferredAnalyteTypes,Except[Null]]
					],
					Last,
					GreaterEqual
				]
			]
		]
	];


	(* --- RESOLVE EXPERIMENT OPTION --- *)
	resolvedGel=Switch[
		{suppliedGel,preferredAnalyteType,suppliedDenaturingGel,averageTargetOligomerStrandLength,averageProteinMolecularWeight},

		(* If the user has supplied the Gel, we accept it (currently the option is not an Automatic option) *)
		{Except[Automatic],_,_,_,_},
			suppliedGel,

		(* - Otherwise, we resolve based on the preferredAnalyteType, the suppliedDenaturingGel - *)
		(* If the preferredAnalyteType is Oligomer, resolve Gel based on the suppliedDenaturingGel *)
		(* Only resolve to the Native gel if the user has supplied the DenaturingGel option as False *)
		{Automatic,Oligomer,False,_,_},
			Model[Item, Gel, "10% polyacrylamide TBE cassette, 20 channel"],
		{Automatic,Oligomer,_,_,_},
			Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],

		(* If the preferredAnalyteType is Protein, resolve the Gel based on the suppliedDenaturingGel and the averageProtienMolecularWeight *)
		(* If user has specified DenaturingGel as False, resolve to one of the Tris/Glycine gels *)
		{Automatic,Protein,False,_,LessP[200*(Kilogram/Mole)]},
			Model[Item,Gel,"12% polyacrylamide Tris-Glycine cassette, 20 channel"],
		{Automatic,Protein,False,_,_},
			Model[Item,Gel,"7% polyacrylamide Tris-Glycine cassette, 20 channel"],

		(* If user has not specified DenaturingGel as False, resolve to one of the Tris/Glycine/SDS gels *)
		{Automatic,Protein,_,_,LessP[200*(Kilogram/Mole)]},
			Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
		{Automatic,Protein,_,_,_},
			Model[Item,Gel,"7% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],

		(* Catch all which should never occur, default to denaturing TBE-Urea gel *)
		{_,_,_,_,_},
			Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"]
	];

	(* - Get information out of the resolved Gel - *)
	{
		numberOfGelLanes,
		gelMaterial,
		gelRig,
		gelDenaturingField,
		gelBufferComponents,
		maxWellVolume
	}=If[

		(* IF the gel was specified *)
		MatchQ[suppliedGel,Except[Automatic]],

		(* THEN, we set these to the values from the specified gel *)
		{
			suppliedNumberOfGelLanes,
			suppliedGelMaterial,
			suppliedGelOptionRig,
			suppliedGelDenaturingField,
			suppliedGelBufferComponents,
			suppliedMaxWellVolume
		},

		(* ELSE, get the values from the cache packet of the gel we have resolved to *)
		Lookup[
			Experiment`Private`fetchPacketFromCache[
				resolvedGel,
				simulatedCache
			],
			{
				NumberOfLanes,
				GelMaterial,
				Rig,
				Denaturing,
				BufferComponents,
				MaxWellVolume
			}
		]
	];

	(* Define the maximum number of sample lanes *)
	maxSampleLanes=((numberOfGelLanes-2)*4);

	(* Get the objects from the BufferComponents Links (used for comparison in resolution) *)
	gelBufferComponentsObjects=Download[gelBufferComponents,Object];

	(* - DenaturingGel  - *)
	resolvedDenaturingGel=Switch[suppliedDenaturingGel,

		(* If the user has supplied the DenaturingGel, we accept it (do error checking later) *)
		Except[Automatic],
			suppliedDenaturingGel,

		(* Otherwise, we resolve to the Denaturing field of the supplied gel *)
		Automatic,
			gelDenaturingField
	];

	(* -- Set a bunch of booleans which determine which type of gel we are using -- *)
	(* denaturing oligomer Gel, non-denaturing oligomer gel, TrisGlycine Gel, TrisGlycineSDS gel, Bis-Tris gel *)
	(* - Set a boolean that indicates if the resolvedGel is a TBE (oligomer) gel - *)
	denaturingOligomerGelQ=If[

		(* IF the BufferComponents field of the resolved Gel contains Tris base, EDTA, Boric Acid, and Urea  *)
		ContainsAll[gelBufferComponentsObjects,{Model[Molecule, "id:WNa4ZjKVdVOD"],Model[Molecule, "id:XnlV5jKXeXj3"],Model[Molecule, "id:vXl9j57PmPzN"],Model[Molecule, "id:Z1lqpMzR4RZ0"]}],

		(* THEN this is a denaturing gel for Oligomers *)
		True,

		(* ELSE, it is not *)
		False
	];

	(* - Set a boolean that indicates if the resolvedGel is a non-denaturing TBE (oligomer) gel - *)
	nonDenaturingOligomerGelQ=If[

		(* IF Both the BufferComponents field of the resolved gel contains Tris base, EDTA, and Boric Acid, AND we are not a denaturingOligomerGel *)
		And[
			ContainsAll[gelBufferComponentsObjects,{Model[Molecule, "id:WNa4ZjKVdVOD"],Model[Molecule, "id:XnlV5jKXeXj3"],Model[Molecule, "id:vXl9j57PmPzN"]}],
			Not[denaturingOligomerGelQ]
		],

		(* THEN this is a non-denaturing oligomer gel *)
		True,

		(* ELSE it is not *)
		False
	];

	(* - Denaturing Tris/Glycine/SDS gel - *)
	denaturingTrisGlycineGelQ=If[

		(* IF the BufferComponents field of the resolved Gel contains Tris Base, Glycine, and SDS  *)
		ContainsAll[gelBufferComponentsObjects,{Model[Molecule, "id:WNa4ZjKVdVOD"],Model[Molecule, "id:o1k9jAGP8Pem"],Model[Molecule, "id:wqW9BP7JmJe9"]}],

		(* THEN this is a Tris/Glycine/SDS gel *)
		True,

		(* ELSE, its not *)
		False
	];

	(* - Native Tris/Glycine gel - *)
	nativeTrisGlycineGelQ=If[

		(* IF the BufferComponents field of the resolved Gel contains Base and Glycine, but there is no SDS *)
		And[
			ContainsAll[gelBufferComponentsObjects,{Model[Molecule, "id:WNa4ZjKVdVOD"],Model[Molecule, "id:o1k9jAGP8Pem"]}],
			Not[denaturingTrisGlycineGelQ]
		],

		(* THEN this is a native Tris/Glycine gel *)
		True,

		(* ELSE this is not *)
		False
	];

	(* - Bis-Tris gel - *)
	bisTrisGelQ=If[

		(* IF the gel contains Bis Tris *)
		ContainsAll[gelBufferComponentsObjects,{Model[Molecule, "id:E8zoYvN6m6dN"]}],

		(* THEN it is a bis tris gel *)
		True,

		(* ELSE it is not *)
		False
	];


	(* Ladder *)
	resolvedLadder=Switch[
		{suppliedLadder,denaturingOligomerGelQ,nonDenaturingOligomerGelQ,denaturingTrisGlycineGelQ,nativeTrisGlycineGelQ,bisTrisGelQ},

		(* If the user has supplied the Ladder option, we accept it *)
		{Except[Automatic],_,_,_,_,_},
			suppliedLadder,

		(* - Other cases, where Ladder is Automatic - *)
		(* Denaturing TBE-Urea Oligomer gel *)
		{Automatic,True,_,_,_,_},
			Model[Sample,StockSolution,Standard,"GeneRuler dsDNA 10-300 bp, 11 bands, 167 ng/uL"],

		(* Native TBE Oligomer gel *)
		{Automatic,_,True,_,_,_},
			Model[Sample,StockSolution,Standard,"GeneRuler dsDNA 10-300 bp, 11 bands, 167 ng/uL"],

		(* Denaturing Tris/Glycine/SDS Protein gel *)
		{Automatic,_,_,True,_,_},
			Model[Sample,StockSolution,Standard,"Precision Plus Unstained Protein Standards, 10-200 kDa"],

		(* Native Tris/Glycine Protein Gel *)
		{Automatic,_,_,_,True,_},
			Model[Sample,StockSolution,Standard,"NativeMark Unstained Protein Standards, 20-1236 kDa"],

		(* BisTris Protein Gel *)
		{Automatic,_,_,_,_,True},
			Model[Sample,StockSolution,Standard,"Precision Plus Unstained Protein Standards, 10-200 kDa"],

		(* All other cases (should not occur) - default to Denaturing TBE-Urea ladder *)
		{_,_,_,_,_,_},
			Model[Sample,StockSolution,Standard,"GeneRuler dsDNA 10-300 bp, 11 bands, 167 ng/uL"]
	];

	(* LoadingBuffer *)
	resolvedLoadingBuffer=Switch[
		{suppliedLoadingBuffer,denaturingOligomerGelQ,nonDenaturingOligomerGelQ,denaturingTrisGlycineGelQ,nativeTrisGlycineGelQ,bisTrisGelQ},

		(* If the user has supplied the LoadingBuffer option, we accept it *)
		{Except[Automatic],_,_,_,_,_},
			suppliedLoadingBuffer,

		(* - Other cases, where LoadingBuffer is Automatic - *)
		(* Denaturing TBE-Urea Oligomer gel *)
		{Automatic,True,_,_,_,_},
			Model[Sample, "PAGE denaturing loading buffer, 22% Ficoll"],

		(* Native TBE Oligomer gel *)
		{Automatic,_,True,_,_,_},
			Model[Sample,"PAGE SYBR Gold non-denaturing loading buffer, 25% Ficoll"],

		(* Denaturing Tris/Glycine/SDS Protein gel *)
		{Automatic,_,_,True,_,_},
			Model[Sample, "Sample Buffer, Laemmli 2x Concentrate"],

		(* Native Tris/Glycine Protein Gel *)
		{Automatic,_,_,_,True,_},
			Model[Sample, "Native Sample Buffer for Protein Gels"],

		(* BisTris Protein Gel *)
		{Automatic,_,_,_,_,True},
			Model[Sample, "Sample Buffer, Laemmli 2x Concentrate"],

		(* All other cases (should not occur) - default to Denaturing TBE-Urea ladder *)
		{_,_,_,_,_,_},
			Model[Sample, "PAGE denaturing loading buffer, 22% Ficoll"]
	];

	(* LadderLoadingBuffer *)
	resolvedLadderLoadingBuffer=Switch[{suppliedLadderLoadingBuffer,suppliedLadderLoadingBufferVolume},

		(* If the user has supplied the LadderLoadingBuffer, we accept it *)
		{Except[Automatic],_},
			suppliedLadderLoadingBuffer,

		(* If the user has specified the LadderLoadingBufferVolume as Null, we resolve the volume to Null *)
		{Automatic,Null},
			Null,

		(* Otherwise, we resolve to the LoadingBuffer *)
		{Automatic,_},
			resolvedLoadingBuffer
	];

	(* ReservoirBuffer *)
	resolvedReservoirBuffer=Switch[
		{suppliedReservoirBuffer,denaturingOligomerGelQ,nonDenaturingOligomerGelQ,denaturingTrisGlycineGelQ,nativeTrisGlycineGelQ,bisTrisGelQ},

		(* If the user has supplied the ReservoirBuffer option, we accept it *)
		{Except[Automatic],_,_,_,_,_},
		suppliedReservoirBuffer,

		(* - Other cases, where ReservoirBuffer is Automatic - *)
		(* Denaturing TBE-Urea Oligomer gel *)
		{Automatic,True,_,_,_,_},
			Model[Sample, StockSolution, "1x TBE Buffer"],

		(* Native TBE Oligomer gel *)
		{Automatic,_,True,_,_,_},
			Model[Sample, StockSolution, "1x TBE Buffer"],

		(* Denaturing Tris/Glycine/SDS Protein gel *)
		{Automatic,_,_,True,_,_},
			Model[Sample,StockSolution,"1x Tris-Glycine-SDS Buffer"],

		(* Native Tris/Glycine Protein Gel *)
		{Automatic,_,_,_,True,_},
			Model[Sample,StockSolution,"1x Tris-Glycine Buffer"],

		(* BisTris Protein Gel *)
		{Automatic,_,_,_,_,True},
			Model[Sample,StockSolution,"1x Tris-Glycine-SDS Buffer"],

		(* All other cases (should not occur) - default to Denaturing TBE-Urea ladder *)
		{_,_,_,_,_,_},
			Model[Sample, StockSolution, "1x TBE Buffer"]
	];

	(* GelBuffer *)
	resolvedGelBuffer=Switch[
		{suppliedGelBuffer,denaturingOligomerGelQ,nonDenaturingOligomerGelQ,denaturingTrisGlycineGelQ,nativeTrisGlycineGelQ,bisTrisGelQ},

		(* If the user has supplied the GelBuffer option, we accept it *)
		{Except[Automatic],_,_,_,_,_},
			suppliedGelBuffer,

		(* - Other cases, where GelBuffer is Automatic - *)
		(* Denaturing TBE-Urea Oligomer gel *)
		{Automatic,True,_,_,_,_},
			Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"],

		(* Native TBE Oligomer gel *)
		{Automatic,_,True,_,_,_},
			Model[Sample, StockSolution, "1x TBE Buffer"],

		(* Denaturing Tris/Glycine/SDS Protein gel *)
		{Automatic,_,_,True,_,_},
			Model[Sample,StockSolution,"1x Tris-Glycine-SDS Buffer"],

		(* Native Tris/Glycine Protein Gel *)
		{Automatic,_,_,_,True,_},
			Model[Sample,StockSolution,"1x Tris-Glycine Buffer"],

		(* BisTris Protein Gel *)
		{Automatic,_,_,_,_,True},
			Model[Sample,StockSolution,"1x Tris-Glycine-SDS Buffer"],

		(* All other cases (should not occur) - default to Denaturing TBE-Urea ladder *)
		{_,_,_,_,_,_},
			Model[Sample, StockSolution, "1x TBE Buffer"]
	];

	(* SampleLoadingVolume *)
	resolvedSampleLoadingVolume=Switch[{suppliedSampleLoadingVolume,numberOfGelLanes},

		(* If the user has supplied the SampleLoadingVolume, we accept it *)
		{Except[Automatic],_},
			suppliedSampleLoadingVolume,

		(* Otherwise, we resolve based on the number of lanes in the gel  *)
		{Automatic,10},
			10.5*Microliter,
		{Automatic,20},
			4*Microliter,
		{Automatic,_},
			4*Microliter
	];

	(* PostRunStaining *)
	resolvedPostRunStaining=Switch[{suppliedPostRunStaining,suppliedStainingSolution,suppliedRinsingSolution,suppliedPrewashingSolution,nonDenaturingOligomerGelQ},

		(* If the user has supplied the PostRunStaining option, we accept it *)
		{Except[Automatic],_,_,_,_},
			suppliedPostRunStaining,

		(* - First, we try to resolve based on if the StainingSolution, RinsingSolution, or PrewashingSolution are specified - *)
		(* If any of them are specified, we resolve to True *)
		Alternatives[
			{Automatic,Except[Alternatives[Null,Automatic]],_,_,_},
			{Automatic,_,Except[Alternatives[Null,Automatic]],_,_},
			{Automatic,_,_,Except[Alternatives[Null,Automatic]],_}
		],
			True,

		(* - Otherwise, we resolved based on what type of Gel we are using - *)
		(* If we are using a native oligomer gel, we do not need to stain *)
		{Automatic,_,_,_,True},
			False,

		(* Otherwise, we do *)
		{Automatic,_,_,_,_},
			True
	];

	(* StainingSolution *)
	resolvedStainingSolution=Switch[
		{
			suppliedStainingSolution,resolvedPostRunStaining,denaturingOligomerGelQ,nonDenaturingOligomerGelQ,denaturingTrisGlycineGelQ,
			nativeTrisGlycineGelQ,bisTrisGelQ
		},

		(* If the user has supplied the StainingSolution, we accept it *)
		{Except[Automatic],_,_,_,_,_,_},
			suppliedStainingSolution,

		(* Otherwise, we resolve based on the resolvedPostRunStaining option and which type of gel we are using *)
		(* If we are not staining, set to Null *)
		{Automatic,False,_,_,_,_,_},
			Null,

		(* If we are staining, choose the StainingSolution based on the type of gel we are using  *)
		(* Denaturing TBE gel *)
		{Automatic,True,True,_,_,_,_},
			Model[Sample, StockSolution, "10X SYBR Gold in 1X TBE"],

		(* Native TBE gel *)
		{Automatic,True,_,True,_,_,_},
			Model[Sample, StockSolution, "10X SYBR Gold in 1X TBE"],

		(* Denaturing Tris/Glycine/SDS Protein gel *)
		{Automatic,_,_,_,True,_,_},
			Model[Sample,StockSolution,"1x SYPRO Orange Protein Gel Stain in 7.5% acetic acid"],

		(* Native Tris/Glycine Protein Gel *)
		{Automatic,_,_,_,_,True,_},
			Model[Sample,StockSolution,"1x SYPRO Orange Protein Gel Stain in 7.5% acetic acid"],

		(* BisTris Protein Gel *)
		{Automatic,_,_,_,_,_,True},
			Model[Sample,StockSolution,"1x SYPRO Orange Protein Gel Stain in 7.5% acetic acid"],

		(* All other cases (should not occur) - default to Denaturing TBE-Urea ladder *)
		{_,_,_,_,_,_,_},
			Model[Sample, StockSolution, "10X SYBR Gold in 1X TBE"]
	];

	(* StainVolume *)
	resolvedStainVolume=Switch[{suppliedStainVolume,resolvedStainingSolution},

		(* If the user has supplied the StainVolume, we accept it *)
		{Except[Automatic],_},
			suppliedStainVolume,

		(* Otherwise, we resolve based on the resolvedStainingSolution option  *)
		(* If we are staining *)
		{Automatic,Except[Null]},
			12*Milliliter,

		(* If we are not staining, set to Null *)
		{Automatic,Null},
			Null
	];

	(* StainingTime *)
	resolvedStainingTime=Switch[
		{
			suppliedStainingTime,resolvedStainingSolution,denaturingOligomerGelQ,nonDenaturingOligomerGelQ,denaturingTrisGlycineGelQ,
			nativeTrisGlycineGelQ,bisTrisGelQ
		},

		(* If the user has supplied the StainingTime, we accept it *)
		{Except[Automatic],_,_,_,_,_,_},
			suppliedStainingTime,

		(* If we are not staining, set to Null *)
		{Automatic,Null,_,_,_,_,_},
			Null,

		(* Otherwise, we resolve based on which type of gel we are using  *)
		(* If we are using a TBE gel, stain for 36 min *)
		{Automatic,_,True,_,_,_,_},
			36*Minute,
		{Automatic,_,_,True,_,_,_},
			36*Minute,

		(* If we are using a protein gel, stain for one hour *)
		{Automatic,_,_,_,True,_,_},
			1*Hour,
		{Automatic,_,_,_,_,True,_},
			1*Hour,
		{Automatic,_,_,_,_,_,True},
			1*Hour,

		(* Otherwise (shouldn't come up), set to 36 min *)
		{_,_,_,_,_,_,_},
			36*Minute
	];

	(* PrewashingSolution *)
	resolvedPrewashingSolution=suppliedPrewashingSolution;

	(* PrewashVolume *)
	resolvedPrewashVolume=Switch[{suppliedPrewashVolume,resolvedPrewashingSolution},

		(* If the user has supplied the PrewashVolume, we accept it *)
		{Except[Automatic],_},
			suppliedPrewashVolume,

		(* Otherwise, we resolve based on the resolvedPrewashingSolution *)
		(* Case where PrewashingSolution is Null *)
		{Automatic,Null},
			Null,

		(* Case where PrewashingSolution is not Null *)
		{Automatic,Except[Null]},
			12*Milliliter
	];

	(* PrewashingTime *)
	resolvedPrewashingTime=Switch[{suppliedPrewashingTime,resolvedPrewashingSolution},

		(* If the user has supplied the PrewashingTime, we accept it *)
		{Except[Automatic],_},
		suppliedPrewashingTime,

		(* Otherwise, we resolve based on the resolvedPrewashingSolution *)
		(* Case where PrewashingSolution is Null *)
		{Automatic,Null},
			Null,

		(* Case where PrewashingSolution is not Null *)
		{Automatic,Except[Null]},
			6*Minute
	];

	(* RinsingSolution *)
	resolvedRinsingSolution=Switch[
		{
			suppliedRinsingSolution,resolvedPostRunStaining,denaturingOligomerGelQ,nonDenaturingOligomerGelQ,denaturingTrisGlycineGelQ,
			nativeTrisGlycineGelQ,bisTrisGelQ
		},

		(* If the user has supplied the RinsingSolution, we accept it *)
		{Except[Automatic],_,_,_,_,_,_},
			suppliedRinsingSolution,

		(* If we are not staining, set to Null *)
		{Automatic,False,_,_,_,_,_},
			Null,

		(* Otherwise, we resolve based on the type of gel we are using  *)
		(* If we are using a TBE gel, rinse with 1x TBE Buffer *)
		{Automatic,_,True,_,_,_,_},
			Model[Sample, StockSolution, "1x TBE Buffer"],
		{Automatic,_,_,True,_,_,_},
			Model[Sample, StockSolution, "1x TBE Buffer"],

		(* If we are using a protein gel, rinse with 7.5% acetic acid in water *)
		{Automatic,_,_,_,True,_,_},
			Model[Sample,StockSolution,"7.5% acetic acid in water"],
		{Automatic,_,_,_,_,True,_},
			Model[Sample,StockSolution,"7.5% acetic acid in water"],
		{Automatic,_,_,_,_,_,True},
			Model[Sample,StockSolution,"7.5% acetic acid in water"],

		(* Otherwise (shouldn't come up), set to 1x TBE buffer *)
		{_,_,_,_,_,_,_},
			Model[Sample, StockSolution, "1x TBE Buffer"]
	];

	(* RinseVolume *)
	resolvedRinseVolume=Switch[{suppliedRinseVolume,resolvedRinsingSolution},

		(* If the user has supplied the RinseVolume, we accept it *)
		{Except[Automatic],_},
			suppliedRinseVolume,

		(* Otherwise, we resolve based on the resolvedRinsingSolution *)
		(* Case where RinsingSolution is Null *)
		{Automatic,Null},
			Null,

		(* Case where RinsingSolution is not Null *)
		{Automatic,Except[Null]},
			12*Milliliter
	];

	(* RinsingTime *)
	resolvedRinsingTime=Switch[{suppliedRinsingTime,resolvedRinsingSolution},

		(* If the user has supplied the RinsingTime, we accept it *)
		{Except[Automatic],_},
			suppliedRinsingTime,

		(* Otherwise, we resolve based on the resolvedRinsingSolution *)
		(* Case where RinsingSolution is Null *)
		{Automatic,Null},
			Null,

		(* Case where RinsingSolution is not Null *)
		{Automatic,Except[Null]},
			6*Minute
	];

	(* NumberOfRinses *)
	resolvedNumberOfRinses=Switch[{suppliedNumberOfRinses,resolvedRinsingSolution},

		(* If the user has supplied the NumberOfRinses, we accept it *)
		{Except[Automatic],_},
			suppliedNumberOfRinses,

		(* Otherwise, we resolve based on the resolvedRinsingSolution *)
		(* Case where RinsingSolution is Null *)
		{Automatic,Null},
			Null,

		(* Case where the RinsingSolution is not Null *)
		{Automatic,Except[Null]},
			1
	];

	(* SeparationTime *)
	resolvedSeparationTime=Switch[{suppliedSeparationTime,denaturingOligomerGelQ,nonDenaturingOligomerGelQ},

		(* If the user has supplied the SeparationTime, we accept it *)
		{Except[Automatic],_,_},
			suppliedSeparationTime,

		(* Otherwise, we resolve the option based on the type of Gel we are using *)
		(* If we are running an oligomer TBE gel, resolve to 2 hours *)
		{Automatic,True,_},
			2*Hour,
		{Automatic,_,True},
			2*Hour,

		(* If we are running a protein gel, resolve to 133 minutes *)
		{Automatic,_,_},
			133*Minute
	];

	(* Voltage *)
	resolvedVoltage=suppliedVoltage;

	(* DutyCycle *)
	resolvedDutyCycle=suppliedDutyCycle;

	(* SampleDenaturing *)
	resolvedSampleDenaturing=Switch[
		{
			suppliedSampleDenaturing,denaturingOligomerGelQ,nonDenaturingOligomerGelQ,denaturingTrisGlycineGelQ,resolvedDenaturingGel
		},

		(* If the user has supplied the SampleDenaturing, we accept it *)
		{Except[Automatic],_,_,_,_},
			suppliedSampleDenaturing,

		(* Otherwise, we resolve it based on the gel type, or if none of the gel types, with the DenaturingGel option (for futur bis-tris gels *)
		(* The only types of gel we will resolve this to True for are Tris/Glycine/SDS gels *)
		{Automatic,True,_,_,_},
			False,
		{Automatic,_,True,_,_},
			False,
		{Automatic,_,_,True,_},
			True,

		(* Resolve to True if the resolved DenaturingGel is true (occurs in future maybe with bis-tris gels *)
		{Automatic,_,_,_,True},
			True,

		(* Other cases (catch all), set to False *)
		{_,_,_,_,_},
			False
	];

	(* DenaturingTime *)
	resolvedDenaturingTime=Switch[{suppliedDenaturingTime,resolvedSampleDenaturing},

		(* If the user has supplied the DenaturingTime, we accept it *)
		{Except[Automatic],_},
			suppliedDenaturingTime,

		(* Otherwise, resolve based on the SampleDenaturing option *)
		(* If we are not denaturing, set to Null *)
		{Automatic,False},
			Null,

		(* If we are denaturing, set to 5 minutes *)
		{Automatic,True},
			5*Minute
	];

	(* DenaturingTemperature *)
	resolvedDenaturingTemperature=Switch[{suppliedDenaturingTemperature,resolvedSampleDenaturing},

		(* If the user has supplied the DenaturingTemperature, we accept it *)
		{Except[Automatic],_},
			suppliedDenaturingTemperature,

		(* Otherwise, resolve based on the SampleDenaturing option *)
		(* If we are not denaturing, set to Null *)
		{Automatic,False},
			Null,

		(* If we are denaturing, set to 5 minutes *)
		{Automatic,True},
			95*Celsius
	];

	(* -- Resolve index-matched options -- *)
	(* Convert our options into a MapThread friendly version. so we can do our big MapThread *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentPAGE,roundedExperimentOptions];

	{
		resolvedSampleVolume,resolvedLoadingBufferVolume,notEnoughVolumeErrors
	}=Transpose[MapThread[
		Function[{options},
			Module[
				{
					sampleVolume,loadingBufferVolume,notEnoughVolumeError,initialSampleVolume,initialLoadingBufferVolume
				},

				(* Set up error tracking variables *)
				{
					notEnoughVolumeError
				}=ConstantArray[False,1];

				(* Lookup the initial values of the options *)
				{
					initialSampleVolume,initialLoadingBufferVolume
				}=
						Lookup[options,
							{
								SampleVolume,LoadingBufferVolume
							}
						];

				(* - Resolve the SampleVolume - *)
				sampleVolume=Switch[
					{
						initialSampleVolume,denaturingOligomerGelQ,nonDenaturingOligomerGelQ,denaturingTrisGlycineGelQ,
						nativeTrisGlycineGelQ,bisTrisGelQ
					},

					(* If the user has specified the SampleVolume option, we accept it *)
					{Except[Automatic],_,_,_,_,_},
						initialSampleVolume,

					(* Otherwise, we resolve the option based on the type of gel we are running (if user has picked a non-default loading buffer,
					 they will also have to change the sample volume and loading buffer volumes *)
					(* Denaturing TBE-Urea gel (with Ficoll loading buffer) *)
					{Automatic,True,_,_,_,_},
						3*Microliter,

					(* Native TBE gel (with non-denaturing SYBR gold/Ficoll loading buffer) *)
					{Automatic,_,True,_,_,_},
						12*Microliter,

					(* Denaturing Tris/Glycine/SDS gel (with 2x Laemmli loading buffer) *)
					{Automatic,_,_,True,_,_},
						7.5*Microliter,

					(* Native Tris/Glycine gel (with native loading buffer) *)
					{Automatic,_,_,_,True,_},
						7.5*Microliter,

					(* Bis-Tris gel (with 2x Laemmli loading buffer) *)
					{Automatic,_,_,_,_,True},
						7.5*Microliter,

					(* Catch all - resolve to denaturing TBE stuff *)
					{_,_,_,_,_,_},
						3*Microliter
				];

				(* - Resolve the LoadingBufferVolume - *)
				loadingBufferVolume=Switch[
					{
						initialLoadingBufferVolume,denaturingOligomerGelQ,nonDenaturingOligomerGelQ,denaturingTrisGlycineGelQ,
						nativeTrisGlycineGelQ,bisTrisGelQ
					},

					(* If the user has specified the SampleVolume option, we accept it *)
					{Except[Automatic],_,_,_,_,_},
						initialLoadingBufferVolume,


					(* Otherwise, we resolve the option based on the type of gel we are running (if user has picked a non-default loading buffer,
					 they will also have to change the sample volume and loading buffer volumes *)
					(* Denaturing TBE-Urea gel (with Ficoll loading buffer) *)
					{Automatic,True,_,_,_,_},
						40*Microliter,

					(* Native TBE gel (with non-denaturing SYBR gold/Ficoll loading buffer) *)
					{Automatic,_,True,_,_,_},
						3*Microliter,

					(* Denaturing Tris/Glycine/SDS gel (with 2x Laemmli loading buffer) *)
					{Automatic,_,_,True,_,_},
						7.5*Microliter,

					(* Native Tris/Glycine gel (with native loading buffer) *)
					{Automatic,_,_,_,True,_},
						7.5*Microliter,

					(* Bis-Tris gel (with 2x Laemmli loading buffer) *)
					{Automatic,_,_,_,_,True},
						7.5*Microliter,

					(* Catch all - resolve to denaturing TBE stuff *)
					{_,_,_,_,_,_},
						40*Microliter
				];

				(* - Set the notEnoughVolumeError bool - *)
				notEnoughVolumeError=If[

					(* IF the sum of the SampleVolume and the LoadingBufferVolume is less than the SampleLoadingVolume *)
					(sampleVolume+loadingBufferVolume)<resolvedSampleLoadingVolume,

					(* THEN we set the error boolean to True *)
					True,

					(* ELSE we set it to false, we have enough volume *)
					False
				];

				(* -- Return the MapThread variables in order -- *)
				{
					sampleVolume,loadingBufferVolume,notEnoughVolumeError
				}
			]
		],
		{mapThreadFriendlyOptions}
	]];

	(* LadderVolume *)
	resolvedLadderVolume=Switch[suppliedLadderVolume,

		(* If the user has supplied the LadderVolume, we accept it *)
		Except[Automatic],
			suppliedLadderVolume,

		(* Otherwise, we set it as the Mean of the resolvedLoadingBufferVolume *)
		Automatic,
			RoundOptionPrecision[Mean[ToList[resolvedSampleVolume]],10^-1*Microliter]
	];

	(* Resolve the LadderLoadingBufferVolume *)
	resolvedLadderLoadingBufferVolume=Switch[{suppliedLadderLoadingBufferVolume,resolvedLadderLoadingBuffer},

		(* In the case where the user has specified the LadderLoadingBufferVolume, we accept it *)
		{Except[Automatic],_},
			suppliedLadderLoadingBufferVolume,

		(* Otherwise, we set it as the Mean of the resolvedLoadingBufferVolume *)
		{Automatic,Except[Null]},
			RoundOptionPrecision[Mean[ToList[resolvedLoadingBufferVolume]],10^-1*Microliter],

		(* If the LadderLoadingBuffer is Null, resolve the Volume to Null *)
		{Automatic,Null},
			Null
	];

	(* ---  Post resolution error checking --- *)
	(* If there are more than 32 input samples, set all of the samples to tooManyInvalidInputs *)
	tooManyInvalidInputs=If[numberOfSamples>maxSampleLanes,
		Lookup[Flatten[samplePackets],Object],
		{}
	];

	(* If there are too many input samples and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	If[Length[tooManyInvalidInputs]>0&&messages,
		Message[Error::TooManyPAGEInputs]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyInputsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[tooManyInvalidInputs]==0,
				Nothing,
				Test["There are "<>ToString[maxSampleLanes]<>" or fewer input samples times the NumberOfReplicates:",True,False]
			];

			passingTest=If[Length[tooManyInvalidInputs]>0,
				Nothing,
				Test["There are "<>ToString[maxSampleLanes]<>" or fewer input samples times the NumberOfReplicates.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw an Error if the specified Gel is not a Polyacrylamide Gel - *)
	invalidGelMaterialOptions=If[!MatchQ[gelMaterial,Polyacrylamide],
		{Gel},
		{}
	];

	(* If the Gel is not a Polyacrylamide Gel, throw an error message and keep track of the invalid options *)
	If[Length[invalidGelMaterialOptions]>0&&messages,
		Message[Error::InvalidPAGEGelMaterial]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result *)
	gelMaterialTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidGelMaterialOptions]==0,
				Nothing,
				Test["The supplied Gel, "<>ObjectToString[suppliedGel]<>", is not a Polyacrylamide Gel:",True,False]
			];

			passingTest=If[Length[invalidGelMaterialOptions]>0,
				Nothing,
				Test["The Gel is either not specified, or is a Polyacrylamide Gel.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw an Error if the number of gel lanes is not 10 or 20 (the only supported versions) - *)
	(* Set the invalid option variable if there arent 10 or 20 useable lanes per  *)
	invalidNumberOfGelLanesOptions=If[MatchQ[numberOfGelLanes,Except[Alternatives[10,20]]],
		{Gel},
		{}
	];

	(* If invalidNumberOfGelLanesOptions is not an empty list, throw an error message *)
	If[Length[invalidNumberOfGelLanesOptions]>0&&messages,
		Message[Error::InvalidPAGENumberOfLanes]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result *)
	numberOfLGelLanesTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidNumberOfGelLanesOptions]==0,
				Nothing,
				Test["The supplied Gel, "<>ObjectToString[suppliedGel]<>", does not have a NumberOfLanes of 10 or 20:",True,False]
			];

			passingTest=If[Length[invalidNumberOfGelLanesOptions]>0,
				Nothing,
				Test["The Gel is either not specified, or has 10 or 20 lanes.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Ensure that the supplied Instrument option is of a Model that is currently supported in PAGE - *)
	(* Pattern containing the instruments that are currently supported in PAGE *)
	validInstrumentP=Alternatives[
		Model[Instrument, Electrophoresis, "id:J8AY5jwzPPE7"]
	];

	(* Check to see if the instrument option is set and valid *)
	invalidUnsupportedInstrumentOption=Which[

		(* IF the instrument is not specified, the option is fine *)
		MatchQ[suppliedInstrumentModel,Null],
		{},

		(* IF the instrument model matches validInstrumentP, then the option is valid *)
		MatchQ[suppliedInstrumentModel,validInstrumentP],
		{},

		(* OTHERWISE, the Instrument option is invalid *)
		True,
		{Instrument}
	];

	(* If the instrument option is invalid, and we are throwing messages, throw an Error message *)
	If[Length[invalidUnsupportedInstrumentOption]>0&&messages,
		Message[Error::InvalidPAGEInstrument]
	];

	validInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidUnsupportedInstrumentOption]==0,
				Nothing,
				Test["The Instrument option "<>ObjectToString[suppliedInstrument,Cache->simulatedCache]<>" is of the Model Model[Instrument,Electrophoresis,\"Ranger\"]",True,False]
			];
			passingTest=If[Length[invalidUnsupportedInstrumentOption]>0&&MatchQ[suppliedInstrument,Except[Automatic]],
				Nothing,
				Test["The Instrument option "<>ObjectToString[suppliedInstrument,Cache->simulatedCache]<>" is of the Model Model[Instrument,Electrophoresis,\"Ranger\"]",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- Check to see that if the Gel was specified, it can be used with the Ranger instrument *)
	(*set gelInvalidOption if gelRig is anything other than Robotic *)
	gelInvalidOption=If[MatchQ[gelRig,Robotic],
		{},
		{Gel}
	];

	(* If the Gel option is not valid, and we are throwing messages, throw an error message *)
	If[Length[gelInvalidOption]>0&&messages,
		Message[Error::PAGEGelModelNotCompatible]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result *)
	gelTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[gelInvalidOption]==0,
				Nothing,
				Test["The Gel option is compatible with the instrument.",True,False]
			];
			passingTest=If[Length[gelInvalidOption]!=0,
				Nothing,
				Test["The Gel option is compatible with the instrument.",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- Error checks to make sure the Gel option is okay when input as a list of Objects --- *)
	(* -- Make sure that all of the Gel Objects are of the same Model -- *)
	(* First, get a list of all of the Models of the Gel Objects *)
	gelOptionModels=Lookup[Flatten[listedGelOptionPackets],Object,{}];

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
		Message[Error::MoreThanOnePAGEGelModel,ObjectToString[resolvedGel,Cache->simulatedCache],ObjectToString[gelOptionModels,Cache->simulatedCache]]
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
		Message[Error::DuplicatePAGEGelObjects,ObjectToString[resolvedGel,Cache->simulatedCache]]
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

	(* Set the number of potential sample lanes per gel (2 for ladders)*)
	numberOfSampleLanes=(numberOfGelLanes-2);

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
		MatchQ[numberOfSamples,RangeP[minimumSampleLanes,maximumSampleLanes]],
			{},

		(* Otherwise, the Gel option is invalid *)
		True,
			{Gel}
	];


	(* If the Gel option was given as an Object or list of Objects, and there aren't the right number of Samples throw an error *)
	If[objectGelQ&&Length[invalidNumberOfGelsOptions]>0&&messages,
		Message[Error::InvalidNumberOfPAGEGels,numberOfSamples,ObjectToString[resolvedGel,Cache->simulatedCache],minimumSampleLanes,maximumSampleLanes]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidNumberOfGelsTests=If[gatherTests&&objectGelQ,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidNumberOfGelsOptions]==0,
				Nothing,
				Test["The supplied Gel option is acceptable for the number of input samples:",True,False]
			];
			passingTest=If[Length[invalidNumberOfGelsOptions]!=0,
				Nothing,
				Test["The supplied Gel option is not acceptable for the number of input samples:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Throw an error if the SampleDenaturing is in conflict with the DenaturingTime or DenaturingTemperature options -- *)
	{conflictingDenaturingOptionValues,conflictingDenaturingOptionNames}=Switch[
		{resolvedSampleDenaturing,resolvedDenaturingTime,resolvedDenaturingTemperature},

		(* - First, cases where the options are totally fine and not in conflict - *)
		(* If we are not doing sample denaturing, then the related options must be Null *)
		{False,Null,Null},
			{{},{}},

		(* If we are doing sample denaturing, then the options cannot be Null *)
		{True,Except[Null],Except[Null]},
			{{},{}},

		(* - Cases where the options are in conflict - *)
		(* If we are not doing sample denaturing, then the related options must be Null *)
		{False,_,_},
			{
				(* Figure out which options are in conflict *)
				Join[
					{resolvedSampleDenaturing},
					Cases[{resolvedDenaturingTime,resolvedDenaturingTemperature},Except[Null]]
				],
				Join[
					{SampleDenaturing},
					PickList[{DenaturingTime,DenaturingTemperature},{resolvedDenaturingTime,resolvedDenaturingTemperature},Except[Null]]
				]
			},

		(* If we are doing sample denaturing, then the realted option cannot be Null *)
		{True,_,_},
			{
				(* Figure out which options are in conflict *)
				Join[
					{resolvedSampleDenaturing},
					Cases[{resolvedDenaturingTime,resolvedDenaturingTemperature},Null]
				],
				Join[
					{SampleDenaturing},
					PickList[{DenaturingTime,DenaturingTemperature},{resolvedDenaturingTime,resolvedDenaturingTemperature},Null]
				]
			}
	];

	(* Throw an error if there are any invalidDenaturingGelOptions and we are throwing messages  *)
	If[Length[conflictingDenaturingOptionNames]>0&&messages,
		Message[Error::ConflictingPAGESampleDenaturingOptions,conflictingDenaturingOptionNames,conflictingDenaturingOptionValues]
	];

	(* Define the variable for the tests that we will return *)
	conflictingSampleDenaturingTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[conflictingDenaturingOptionNames]>0,
				Test["The following options, "<>ToString[conflictingDenaturingOptionNames]<>", with values of "<>ToString[conflictingDenaturingOptionValues]<>", are in conflict. If SampleDenaturing is False, the DeanturingTime and DenaturingTemperature options must be Null. If SampleDenaturing is True, the other two options must be specified:",True,False],
				Nothing
			];

			passingTest=If[Length[conflictingDenaturingOptionNames]==0,
				Test["The SampleDenaturing option is not in conflict with the DenaturingTime or DenaturingTemperature options:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* -- Throw an error for notEnoughVolumeErrors, if the sum of the SampleVolume and LoadingBuffer Volume is less than the SampleLoadingVolume -- *)
	(* First, determine if we need to throw this Error *)
	notEnoughVolumeErrorQ=MemberQ[notEnoughVolumeErrors,True];

	(* Find the samples for which the SampleVolume plus the LoadingBufferVolume is less than the SampleLoadingVolume. These are the samples with invalid options *)
	failingSampleAndBufferLoadingVolumeSamples=PickList[simulatedSamples,notEnoughVolumeErrors,True];
	passingSampleAndBufferLoadingVolumeSamples=PickList[simulatedSamples,notEnoughVolumeErrors,False];

	(* For each failingSampleAndBufferLoadingVolumeSample, we want to be able to display the sum of the SampleVolume and LoadingBufferVolume to compare it to the SampleLoadingVolume *)
	failingSampleVolumes=PickList[resolvedSampleVolume,notEnoughVolumeErrors,True];
	failingLoadingBufferVolumes=PickList[resolvedLoadingBufferVolume,notEnoughVolumeErrors,True];
	totalFailingVolumes=(failingSampleVolumes+failingLoadingBufferVolumes);

	(* Set the invalid options variable *)
	invalidNotEnoughVolumeOptions=If[notEnoughVolumeErrorQ,
		{SampleVolume,LoadingBufferVolume,SampleLoadingVolume},
		{}
	];

	(* Throw an error if there are any invalidNotEnoughVolumeOptions and we are throwing messages  *)
	If[notEnoughVolumeErrorQ&&messages,
		Message[Error::NotEnoughVolumeToLoadPAGE,ObjectToString[failingSampleAndBufferLoadingVolumeSamples,Cache->simulatedCache],totalFailingVolumes,resolvedSampleLoadingVolume]
	];

	(* Define the variable for the tests that we will return *)
	sampleLoadingBufferVolumeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[notEnoughVolumeErrorQ,
				Test["The sum of the SampleVolume and LoadingBufferVolume, "<>ToString[totalFailingVolumes]<>", is less than the SampleLoadingVolume, "<>ToString[resolvedSampleLoadingVolume]<>", for the following samples, "<>ObjectToString[failingSampleAndBufferLoadingVolumeSamples,Cache->simulatedCache]<>":",True,False],
				Nothing
			];

			passingTest=If[Length[passingSampleAndBufferLoadingVolumeSamples]==0,
				Nothing,
				Test["The sum of the SampleVolume and LoadingBufferVolume is greater than the SampleLoadingVolume for the following samples "<>ObjectToString[passingSampleAndBufferLoadingVolumeSamples,Cache->simulatedCache]<>":",True,True]
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* -- Throw an error if the LadderLoadingBuffer and LadderLoadingBufferVolume options are in conflict -- *)
	invalidLadderLoadingBufferOptions=Switch[{resolvedLadderLoadingBuffer,resolvedLadderLoadingBufferVolume},

		(* If both options are Null or both are not Null, the options are not in conflict *)
		{Except[Null],Except[Null]},
			{},
		{Null,Null},
			{},

		(* Otherwise, the options are in conflict *)
		{_,_},
			{LadderLoadingBuffer,LadderLoadingBufferVolume}
	];

	(* Throw an error if there are any invalidLadderLoadingBufferOptions and we are throwing messages  *)
	If[Length[invalidLadderLoadingBufferOptions]>0&&messages,
		Message[Error::ConflictingPAGELadderLoadingBufferOptions,ObjectToString[resolvedLadderLoadingBuffer,Cache->simulatedCache],resolvedLadderLoadingBufferVolume]
	];

	(* Define the variable for the tests that we will return *)
	conflictingLadderLoadingBufferTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidLadderLoadingBufferOptions]>0,
				Test["The LadderLoadingBuffer, "<>ObjectToString[resolvedLadderLoadingBuffer,Cache->simulatedCache]<>", and the LadderLoadingBufferVolume, "<>ToString[resolvedLadderLoadingBufferVolume]<>", are in conflict. Either both options must be specified, or both options must be Null:",True,False],
				Nothing
			];

			passingTest=If[Length[invalidLadderLoadingBufferOptions]==0,
				Test["The LadderLoadingBuffer and LadderLoadingBufferVolume options are not in conflict:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* -- Throw an error if there isn't enough Ladder to load -- *)
	(* Determine if we are throwing this error, assign the invalid option variable *)
	invalidEnoughLadderOptions=If[

		(* IF the sum of the LadderVolume and the LadderLoadingBufferVolume is smaller than the SampleLoadingVolume *)
		(resolvedLadderVolume+(resolvedLadderLoadingBufferVolume/.{Null->0*Microliter}))<resolvedSampleLoadingVolume,

		(* THEN the three options are invalid *)
		{LadderVolume,LadderLoadingBufferVolume,SampleLoadingVolume},

		(* ELSE the options are fine *)
		{}
	];

	(* Throw an error if there are any invalidEnoughLadderOptions and we are throwing messages  *)
	If[Length[invalidEnoughLadderOptions]>0&&messages,
		Message[Error::NotEnoughLadderVolumeToLoadPAGE,resolvedLadderVolume,resolvedLadderLoadingBufferVolume,resolvedSampleLoadingVolume]
	];

	(* Define the variable for the tests that we will return *)
	notEnoughLadderVolumeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidEnoughLadderOptions]==0,
				Nothing,
				Test["The sum of the LadderVolume, "<>ToString[resolvedLadderVolume]<>", and the LadderLoadingBufferVolume, "<>ToString[resolvedLadderLoadingBufferVolume]<>", is smaller than the SampleLoadingVolume, "<>ToString[resolvedSampleLoadingVolume]<>":",True,False]
			];

			passingTest=If[Length[invalidEnoughLadderOptions]==0,
				Test["The LadderVolume, LadderLoadingBufferVolume, and SampleLoadingVolume options are not in conflict:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		{}
	];


	(* -- Throw an Error if the DenaturingGel option and the Denaturing field of the Gel option are in conflict -- *)
	(* Check if the DenaturingGel option is the same as the Denaturing field of the input Gel *)
	invalidDenaturingGelOptions=If[

		(* IF the resolvedDenaturingGel and the Denaturing field of the Gel option are the same *)
		MatchQ[gelDenaturingField,resolvedDenaturingGel],

		(* THEN the options are fine *)
		{},

		(* ELSE, they are in conflict *)
		{Gel,DenaturingGel}
	];

	(* Throw an error if there are any invalidDenaturingGelOptions and we are throwing messages  *)
	If[Length[invalidDenaturingGelOptions]>0&&messages,
		Message[Error::ConflictingPAGEDenaturingGelOptions,ObjectToString[resolvedGel,Cache->simulatedCache],gelDenaturingField,resolvedDenaturingGel]
	];

	(* Define the variable for the tests that we will return *)
	denaturingGelOptionTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidDenaturingGelOptions]==0,
				Nothing,
				Test["The Denaturing field of the Gel option, "<>ToString[gelDenaturingField]<>", is in conflict with the DenaturingGel option, "<>ToString[resolvedDenaturingGel]<>":",True,False]
			];

			passingTest=If[Length[passingSampleAndBufferLoadingVolumeSamples]==0,
				Nothing,
				Test["The Denaturing field of the Gel option is the same as the DenaturingGel option:",True,True]
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* -- Throw an Error if PostRunStaining and the StainingSolution options are in conflict -- *)
	(* Determine if the two main master switch options are in conflict *)
	invalidPostStainMismatchOptions=Switch[{resolvedPostRunStaining,resolvedStainingSolution},

		(* If the options are True/Except[Null] or False/Null, the options are invalid *)
		{True,Except[Null]},
			{},
		{False,Null},
			{},

		(* Otherwise, the options are in conflict *)
		{_,_},
			{PostRunStaining,StainingSolution}
	];

	(* Throw an error if there are any invalidPostStainMismatchOptions and we are throwing messages  *)
	If[Length[invalidPostStainMismatchOptions]>0&&messages,
		Message[Error::ConflictingPAGEPostRunStainingSolutionOptions,resolvedPostRunStaining,resolvedStainingSolution]
	];

	(* Define the variable for the tests that we will return *)
	invalidStainingOptionsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidPostStainMismatchOptions]==0,
				Nothing,
				Test["The PostRunStaining option, "<>ToString[resolvedPostRunStaining]<>", is in conflict with the StainingSolution option, "<>ToString[resolvedStainingSolution]<>". If PostRunStaining is True, a StainingSolution must be specified. If PostRunStaining is False, the StainingSolution must be Null:",True,False]
			];

			passingTest=If[Length[invalidPostStainMismatchOptions]!=0,
				Nothing,
				Test["The PostRunStaining option is not in conflict with the StainingSolution option:",True,True]
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* -- Throw an Error if PostRunStaining and the RinsingSolution options are in conflict -- *)
	(* Determine if the two options are in conflict *)
	invalidPostStainRinsingMismatchOptions=Switch[{resolvedPostRunStaining,resolvedRinsingSolution},

		(* If PostRunStaining is False and the RinsingSolution is specified, the options are in conflict *)
		{False,Except[Null]},
			{PostRunStaining,RinsingSolution},

		(* Otherwise, the options are fine *)
		{_,_},
			{}
	];

	(* Throw an error if there are any invalidPostStainRinsingMismatchOptions and we are throwing messages  *)
	If[Length[invalidPostStainRinsingMismatchOptions]>0&&messages,
		Message[Error::ConflictingPAGEPostRunRinsingSolutionOptions,resolvedPostRunStaining,resolvedRinsingSolution]
	];

	(* Define the variable for the tests that we will return *)
	invalidPostStainRinsingOptionsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidPostStainRinsingMismatchOptions]==0,
				Nothing,
				Test["The PostRunStaining option, "<>ToString[resolvedPostRunStaining]<>", is in conflict with the RinsingSolution option, "<>ToString[resolvedRinsingSolution]<>". If PostRunStaining is False, a RinsingSolution cannot be specified:",True,False]
			];

			passingTest=If[Length[invalidPostStainRinsingMismatchOptions]!=0,
				Nothing,
				Test["The PostRunStaining option is not in conflict with the RinsingSolution option:",True,True]
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* -- Throw an Error if PostRunStaining and the PrewashingSolution options are in conflict -- *)
	(* Determine if the two options are in conflict *)
	invalidPostStainPrewashingMismatchOptions=Switch[{resolvedPostRunStaining,resolvedPrewashingSolution},

		(* If PostRunStaining is False and the PrewashingSolution is specified, the options are in conflict *)
		{False,Except[Null]},
			{PostRunStaining,PrewashingSolution},

		(* Otherwise, the options are fine *)
		{_,_},
			{}
	];

	(* Throw an error if there are any invalidPostStainPrewashingMismatchOptions and we are throwing messages  *)
	If[Length[invalidPostStainPrewashingMismatchOptions]>0&&messages,
		Message[Error::ConflictingPAGEPostRunPrewashingSolutionOptions,resolvedPostRunStaining,resolvedPrewashingSolution]
	];

	(* Define the variable for the tests that we will return *)
	invalidPostStainPrewashingOptionsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidPostStainPrewashingMismatchOptions]==0,
				Nothing,
				Test["The PostRunStaining option, "<>ToString[resolvedPostRunStaining]<>", is in conflict with the PrewashingSolution option, "<>ToString[resolvedPrewashingSolution]<>". If PostRunStaining is False, a PrewashingSolution cannot be specified:",True,False]
			];

			passingTest=If[Length[invalidPostStainPrewashingMismatchOptions]!=0,
				Nothing,
				Test["The PostRunStaining option is not in conflict with the PrewashingSolution option:",True,True]
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* -- Throw an error if the StainingSolution-related options are in conflict -- *)
	invalidMismatchedStainingOptions=Switch[{resolvedStainingSolution,resolvedStainVolume,resolvedStainingTime},

		(* If all of the options are Null, or all of the options are specified, the options are not in conflict *)
		{Null,Null,Null},
			{},
		{Except[Null],Except[Null],Except[Null]},
			{},

		(* Otherwise, the options are in conflict *)
		{_,_,_},
			{StainingSolution,StainingTime,StainVolume}
	];

	(* Throw an error if there are any invalidPostStainMismatchOptions and we are throwing messages  *)
	If[Length[invalidMismatchedStainingOptions]>0&&messages,
		Message[Error::MismatchedPAGEStainingOptions,resolvedStainingSolution,resolvedStainVolume,resolvedStainingTime]
	];

	(* Define the variable for the tests that we will return *)
	invalidMismatchedStainingOptionTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidMismatchedStainingOptions]==0,
				Nothing,
				Test["The StainingSolution option, "<>ToString[resolvedStainingSolution]<>", StainVolume option, "<>ToString[resolvedStainVolume]<>", and StainingTime option, "<>ToString[resolvedStainingTime]<>", are in conflict:",True,False]
			];

			passingTest=If[Length[invalidMismatchedStainingOptions]!=0,
				Nothing,
				Test["The StainingSolution, StainVolume, and StainingTime options are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* -- Throw an error if the PrewashingSolution-related options are in conflict -- *)
	invalidMismatchedPrewashingOptions=Switch[{resolvedPrewashingSolution,resolvedPrewashVolume,resolvedPrewashingTime},

		(* If all of the options are Null, or all of the options are specified, the options are not in conflict *)
		{Null,Null,Null},
			{},
		{Except[Null],Except[Null],Except[Null]},
			{},

		(* Otherwise, the options are in conflict *)
		{_,_,_},
			{PrewashingSolution,PrewashingTime,PrewashVolume}
	];

	(* Throw an error if there are any invalidMismatchedPrewashingOptions and we are throwing messages  *)
	If[Length[invalidMismatchedPrewashingOptions]>0&&messages,
		Message[Error::MismatchedPAGEPrewashingOptions,resolvedPrewashingSolution,resolvedPrewashVolume,resolvedPrewashingTime]
	];

	(* Define the variable for the tests that we will return *)
	invalidMismatchedPrewashingOptionTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidMismatchedPrewashingOptions]==0,
				Nothing,
				Test["The PrewashingSolution option, "<>ToString[resolvedPrewashingSolution]<>", PrewashVolume option, "<>ToString[resolvedPrewashVolume]<>", and PrewashingTime option, "<>ToString[resolvedPrewashingTime]<>", are in conflict:",True,False]
			];

			passingTest=If[Length[invalidMismatchedPrewashingOptions]!=0,
				Nothing,
				Test["The PrewashingSolution, PrewashVolume, and PrewashingTime options are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* -- Throw an error if the RinsingSolution-related options are in conflict -- *)
	invalidMismatchedRinsingOptions=Switch[{resolvedRinsingSolution,resolvedRinseVolume,resolvedRinsingTime,resolvedNumberOfRinses},

		(* If all of the options are Null, or all of the options are specified, the options are not in conflict *)
		{Null,Null,Null,Null},
			{},
		{Except[Null],Except[Null],Except[Null],Except[Null]},
			{},

		(* Otherwise, the options are in conflict *)
		{_,_,_,_},
			{RinsingSolution,RinsingTime,RinseVolume,NumberOfRinses}
	];

	(* Throw an error if there are any invalidMismatchedRinsingOptions and we are throwing messages  *)
	If[Length[invalidMismatchedRinsingOptions]>0&&messages,
		Message[Error::MismatchedPAGERinsingOptions,resolvedRinsingSolution,resolvedRinseVolume,resolvedRinsingTime,resolvedNumberOfRinses]
	];

	(* Define the variable for the tests that we will return *)
	invalidMismatchedRinsingOptionTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidMismatchedRinsingOptions]==0,
				Nothing,
				Test["The RinsingSolution option, "<>ToString[resolvedRinsingSolution]<>", RinseVolume option, "<>ToString[resolvedRinseVolume]<>", RinsingTime option, "<>ToString[resolvedRinsingTime]<>", and NumberOfRinses option, "<>ToString[resolvedNumberOfRinses]<>", are in conflict:",True,False]
			];

			passingTest=If[Length[invalidMismatchedRinsingOptions]!=0,
				Nothing,
				Test["The RinsingSolution, RinseVolume, RinsingTime, and NumberOfRinses options are not in conflict:",True,True]
			];

			{failingTest,passingTest}
		],
		{}
	];


	(* -- Throw an Error if the SampleLoadingVolume is larger than the MaxWellVolume of the Gel -- *)
	(* Determine if the SampleLoadingVolume and Gel options are in conflict *)
	invalidMaxWellVolumeOptions=If[

		(* IF the SampleLoadingVolume is larger than the MaxWellVolume of the Gel *)
		resolvedSampleLoadingVolume>maxWellVolume,

		(* THEN the options are invalid *)
		{SampleLoadingVolume,Gel},

		(* ELSE we're all good *)
		{}
	];

	(* Throw an error if there are any invalidMaxWellVolumeOptions and we are throwing messages  *)
	If[Length[invalidMaxWellVolumeOptions]>0&&messages,
		Message[Error::ConflictingPAGESampleLoadingVolumeGelOptions,resolvedSampleLoadingVolume,ObjectToString[resolvedGel,Cache->simulatedCache],maxWellVolume]
	];

	(* Define the variable for the tests that we will return *)
	invalidSampleLoadingVolumeGelTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidMaxWellVolumeOptions]==0,
				Nothing,
				Test["The SampleLoadingVolume option, "<>ToString[resolvedSampleLoadingVolume]<>", is in conflict with the Gel option "<>ObjectToString[resolvedGel,Cache->simulatedCache]<>", which has a MaxWellVolume of "<>ToString[maxWellVolume]<>". The SampleLoadingVolume cannot be larger than the MaxWellVolume of the Gel option:",True,False]
			];

			passingTest=If[Length[invalidMaxWellVolumeOptions]!=0,
				Nothing,
				Test["The SampleLoadingVolume option is not in conflict with the MaxWellVolume of the Gel option:",True,True]
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* -- Throw an Error if there is too much overall waste volume (max 400 mL) -- *)
	(* Figure out how many Gels will be run *)
	numberOfGels=Max[Ceiling[Range[numberOfSamples]/(numberOfGelLanes-2)]];

	(* Determine the total waste volume that will be generated by the experiment on deck *)
	totalWasteVolume=Plus[

		(* GelBuffer waste *)
		(20*Milliliter*numberOfGels),

		(* StainingSolution waste *)
		((resolvedStainVolume/.{Null->0*Milliliter})*numberOfGels),

		(* RinsingSolution waste *)
		((resolvedRinseVolume/.{Null->0*Milliliter})*numberOfGels*(resolvedNumberOfRinses/.{Null->0})),

		(* PrewashingSolution waste *)
		((resolvedPrewashVolume/.{Null->0*Milliliter})*numberOfGels)
	];

	(* Define the invalid options *)
	invalidWasteVolumeOptions=If[

		(* IF we are generating more than 400 mL of waste *)
		totalWasteVolume>400*Milliliter,

		(* THEN the options are invalid *)
		{StainVolume,RinseVolume,NumberOfRinses,PrewashVolume},

		(* ELSE they're fine *)
		{}
	];

	(* Throw an error if there are any invalidMaxWellVolumeOptions and we are throwing messages  *)
	If[Length[invalidWasteVolumeOptions]>0&&messages,
		Message[Error::TooMuchPAGEWasteVolume,totalWasteVolume,numberOfGels,resolvedStainVolume,resolvedPrewashVolume,resolvedRinseVolume,resolvedNumberOfRinses]
	];

	(* Define the variable for the tests that we will return *)
	invalidWasteVolumeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidWasteVolumeOptions]==0,
				Nothing,
				Test["The experiment is expected to generate "<>ToString[totalWasteVolume]<>" of waste volume on the liquid handler deck, which is more than the maximum allowed volume of 400 mL:",True,False]
			];

			passingTest=If[Length[invalidWasteVolumeOptions]!=0,
				Nothing,
				Test["The experiment is not expected to generate too much waste volume",True,True]
			];

			{failingTest,passingTest}
		],
		{}
	];

	(* -- CONTAINER GROUPING RESOLUTION --*)
	(* - Resolve Aliquot Options - *)
	(* Calculate the Required AssayVolume of the inputs the sampleVolume plus 7*Microliters *)
	requiredAliquotAmounts=(resolvedSampleVolume+17*Microliter);

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

	(* -- Call resolveAliquotOptions -- *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentPAGE,
			mySamples,
			simulatedSamples,
			ReplaceRule[allOptionsRounded, resolvedSamplePrepOptions],
			Cache->simulatedCache,
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentPAGE,
				mySamples,
				simulatedSamples,
				ReplaceRule[allOptionsRounded, resolvedSamplePrepOptions],
				Cache->simulatedCache,
				RequiredAliquotContainers->requiredAliquotContainers,
				RequiredAliquotAmounts->requiredAliquotAmounts,
				AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
				Output->Result
			],
			{}
		}
	];

	(* get the resolved Email option; for this experiment. the default is True *)
	email=If[MatchQ[Lookup[myOptions,Email],Automatic],
		True,
		Lookup[myOptions,Email]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* --- Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary --- *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,tooManyInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[
		{
			compatibleMaterialsInvalidOption,invalidSamplesInStorageConditionOptions,invalidGelMaterialOptions,invalidNumberOfGelLanesOptions,
			nameInvalidOptions,invalidNotEnoughVolumeOptions,invalidUnsupportedInstrumentOption,gelInvalidOption,
			invalidDenaturingGelOptions,invalidPostStainMismatchOptions,invalidMaxWellVolumeOptions,invalidEnoughLadderOptions,
			invalidMismatchedStainingOptions,invalidMismatchedPrewashingOptions,invalidMismatchedRinsingOptions,
			invalidPostStainRinsingMismatchOptions,invalidPostStainPrewashingMismatchOptions,invalidWasteVolumeOptions,
			conflictingDenaturingOptionNames,invalidLadderLoadingBufferOptions,invalidMultipleGelObjectModelOptions,
			invalidNumberOfGelsOptions,invalidDuplicateGelOptions
		}
	]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&messages,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* - Define the resolved options that we will output - *)
	resolvedOptions=ReplaceRule[
		allOptionsRounded,
		Join[
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			{
				Gel->resolvedGel,
				Ladder->resolvedLadder,
				LoadingBuffer->resolvedLoadingBuffer,
				ReservoirBuffer->resolvedReservoirBuffer,
				GelBuffer->resolvedGelBuffer,
				SampleLoadingVolume->resolvedSampleLoadingVolume,
				PrewashingSolution->resolvedPrewashingSolution,
				PrewashingTime->resolvedPrewashingTime,
				PrewashVolume->resolvedPrewashVolume,
				StainingSolution->resolvedStainingSolution,
				StainingTime->resolvedStainingTime,
				StainVolume->resolvedStainVolume,
				RinsingSolution->resolvedRinsingSolution,
				RinseVolume->resolvedRinseVolume,
				RinsingTime->resolvedRinsingTime,
				NumberOfRinses->resolvedNumberOfRinses,
				SeparationTime->resolvedSeparationTime,
				Voltage->resolvedVoltage,
				DutyCycle->resolvedDutyCycle,
				LadderVolume->resolvedLadderVolume,
				SampleVolume->resolvedSampleVolume,
				LoadingBufferVolume->resolvedLoadingBufferVolume,
				Instrument->suppliedInstrument,
				PostRunStaining->resolvedPostRunStaining,
				DenaturingGel->resolvedDenaturingGel,
				LadderLoadingBuffer->resolvedLadderLoadingBuffer,
				LadderLoadingBufferVolume->resolvedLadderLoadingBufferVolume,
				SampleDenaturing->resolvedSampleDenaturing,
				DenaturingTime->resolvedDenaturingTime,
				DenaturingTemperature->resolvedDenaturingTemperature
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
					samplePrepTests,discardedTests,tooManyInputsTests,gelMaterialTests,numberOfLGelLanesTests,validInstrumentTests,optionPrecisionTests,
					samplesInStorageTests,compatibleMaterialsTests,validNameTest,sampleLoadingBufferVolumeTests,denaturingGelOptionTests,
					gelTests,invalidStainingOptionsTests,invalidSampleLoadingVolumeGelTests,notEnoughLadderVolumeTests,
					invalidMismatchedStainingOptionTests,invalidMismatchedPrewashingOptionTests,invalidMismatchedRinsingOptionTests,
					invalidPostStainRinsingOptionsTests,invalidPostStainPrewashingOptionsTests,invalidWasteVolumeTests,conflictingSampleDenaturingTests,
					conflictingLadderLoadingBufferTests,multipleGelObjectModelTests,invalidNumberOfGelsTests,duplicateGelObjectsTests,aliquotTests
				}
			],
			_EmeraldTest
		]
	}
];


(* ::Subsubsection:: *)
(*pageResourcePackets (private helper)*)


(* --- pageResourcePackets --- *)

DefineOptions[
	pageResourcePackets,
	Options:>{HelperOutputOption,CacheOption}
];

(* Private function to generate the list of protocol packets containing resource blobs *)
pageResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},myResourceOptions:OptionsPattern[pageResourcePackets]]:=Module[
	{
		expandedInputs,expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,
		inheritedCache,gel,ladder,loadingBuffer,reservoirBuffer,gelBuffer,stainingSolution,rinsingSolution,ladderVolume,
		instrument,numberOfReplicates,separationTime,sampleLoadingVolume,voltage,dutyCycle,stainingTime,postRunStaining,ladderStorageCondition,
		prewashingSolution,prewashVolume,prewashingTime,stainVolume,rinseVolume,rinsingTime,numberOfRinses,ladderLoadingBuffer,
		ladderLoadingBufferVolume,
		gelDownloadFields,listedSampleContainers,liquidHandlerContainerDownload,gelDownloads,bufferSterileDownloads,samplePackets,modelContainerPackets,gelPacket,
		sampleContainersIn,
		liquidHandlerContainerMaxVolumes,preferredContainerMaxVolumes,preferredSterileContainerMaxVolumes,numberOfGelLanes,
		sampleDenaturing,denaturingTime,denaturingTemperature,filterSet,

		samplesWithReplicates,optionsWithReplicates,expandedAliquotAmounts,expandedSampleVolumes,expandedSamplesInStorage,expandedLoadingBufferVolumes,
		expandedSampleOrAliquotVolumes,sampleVolumeRules,uniqueSampleVolumeRules,
		numberOfSamples,
		numberOfLadders,numberOfLanes,gelNumberPerSampleLane,sampleResourceReplaceRules,samplesInResources,
		numberOfGels,sampleLanesPerGel,gelResources,gelResourcesExpanded,
		stainNeeded,stainingSolutionResource,ladderVolumeRule,loadingBufferVolumeRule,ladderLoadingBufferVolumeRule,
		gelBufferVolumeRule,reservoirBufferVolumeRule,prewashingSolutionVolumeRule,rinsingSolutionVolumeRule,
		allLiquidHandlerCompatibleVolumeRules,allPreferredContainerVolumeRules,uniqueLiquidHandlerObjectsAndVolumesAssociation,
		uniquePreferredContainerObjectsAndVolumesAssociation,bufferSterileRule,uniqueLiquidHandlerResources,uniquePreferredContainerResources,
		uniqueLiquidHandlerObjects,uniquePreferredContainerObjects,uniqueLiquidHandlerObjectResourceReplaceRules,
		uniquePreferredContainerObjectResourceReplaceRules,ladderLoadingBufferResource,prewashingSolutionResource,
		rinsingSolutionResource,
		gelBufferPerGel,gelBufferResource,reservoirBufferResource,instrumentResource,
		primaryPipettteTipsResource,secondaryPipetteTipsResource,
		gelBufferTransferVesselResource,reservoirBufferTransferVesselResource,wasteReservoirResource,secondaryWasteReservoirResource,
		stainReservoirResource,rinseReservoirResource,secondaryRinseReservoirResource,
		ladderResource,liquidHandlerContainers,
		preferredContainers,preferredSterileContainers,preferredContainerDownload,preferredSterileContainerDownload,loadingBufferResource,pageID,author,gelMaterial,gelPercentage,crosslinkerRatio,gelModel,
		protocolPacket,sharedFieldPacket,finalizedPacket,allResourceBlobs,fulfillable,frqTests,
		excitationWavelength,excitationBandwidth,emissionWavelength,emissionBandwidth,
		previewRule,optionsRule,testsRule,resultRule
	},

	(* Expand the resolved options *)
	{expandedInputs,expandedResolvedOptions}=ExpandIndexMatchedInputs[ExperimentPAGE,{mySamples},myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentPAGE,
		RemoveHiddenOptions[ExperimentPAGE,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* pull out the Output option and make it a list *)
	outputSpecification=Lookup[ToList[myResourceOptions],Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; If True, then silence the messages *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Get the cache *)
	inheritedCache=Lookup[ToList[myResourceOptions],Cache];

	(* Pull out relevant info from the resolved options *)
	{
		gel,ladder,loadingBuffer,reservoirBuffer,gelBuffer,stainingSolution,rinsingSolution,ladderVolume,instrument,numberOfReplicates,separationTime,
		sampleLoadingVolume,voltage,dutyCycle,stainingTime,postRunStaining,ladderStorageCondition,prewashingSolution,prewashVolume,prewashingTime,
		stainVolume,rinseVolume,rinsingTime,numberOfRinses,ladderLoadingBuffer,ladderLoadingBufferVolume,sampleDenaturing,denaturingTime,
		denaturingTemperature,filterSet
	}=Lookup[myResolvedOptions,
		{
			Gel,Ladder,LoadingBuffer,ReservoirBuffer,GelBuffer,StainingSolution,RinsingSolution,LadderVolume,Instrument,NumberOfReplicates,
			SeparationTime,SampleLoadingVolume,Voltage,DutyCycle,StainingTime,PostRunStaining,LadderStorageCondition,PrewashingSolution,
			PrewashVolume,PrewashingTime,StainVolume,RinseVolume,RinsingTime,NumberOfRinses,LadderLoadingBuffer,LadderLoadingBufferVolume,
			SampleDenaturing,DenaturingTime,DenaturingTemperature,FilterSet
		}
	];

	(* Determine which fields we want to download from the Gel option based on if it is an object or a Model *)
	gelDownloadFields=If[

		(* IF Gel is an object *)
		MatchQ[gel,Alternatives[ObjectP[Object[Item,Gel]],{ObjectP[Object[Item,Gel]]..}]],

		(* THEN download fields from the Model *)
		Packet[Model[{Object,GelPercentage,GelMaterial,CrosslinkerRatio,NumberOfLanes}]],

		(* ELSE just download fields *)
		Packet[Object,GelPercentage,GelMaterial,CrosslinkerRatio,NumberOfLanes]
	];

	(* Make a list of the containers that are liquid handler compatible, for use with the loading buffer*)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* Make a list of preferred containers *)
	preferredContainers=PreferredContainer[All];
	preferredSterileContainers=PreferredContainer[All,Sterile -> True];

	(* Download the relevant info *)
	{listedSampleContainers,liquidHandlerContainerDownload,preferredContainerDownload,preferredSterileContainerDownload,gelDownloads,bufferSterileDownloads}=Quiet[Download[
		{
			mySamples,
			liquidHandlerContainers,
			preferredContainers,
			preferredSterileContainers,
			ToList[gel],
			Flatten[{reservoirBuffer,gelBuffer,prewashingSolution,rinsingSolution}]
		},
		{
			{Container[Object]},
			{MaxVolume},
			{MaxVolume},
			{MaxVolume},
			{gelDownloadFields},
			{Sterile}
		},

		Cache->inheritedCache,
		Date->Now
	],Download::FieldDoesntExist];

	samplePackets=listedSampleContainers[[All,1]];
	modelContainerPackets=liquidHandlerContainerDownload[[All,1]];
	gelPacket=First[Flatten[gelDownloads]];

	(* Find the list of input sample and antibody containers *)
	sampleContainersIn=DeleteDuplicates[Flatten[listedSampleContainers]];

	(* Find the MaxVolume of all of the liquid handler compatible containers *)
	liquidHandlerContainerMaxVolumes=Flatten[liquidHandlerContainerDownload,1];

	(* Find the MaxVolume of all of the preferred containers *)
	preferredContainerMaxVolumes=Flatten[preferredContainerDownload,1];
	preferredSterileContainerMaxVolumes=Flatten[preferredSterileContainerDownload,1];

	(* Get some information about the gel out of the gelPacket *)
	{gelMaterial,gelPercentage,crosslinkerRatio,numberOfGelLanes,gelModel}=
     Lookup[
			 gelPacket,
			 {GelMaterial,GelPercentage,CrosslinkerRatio,NumberOfLanes,Object},
			 Null
		 ];

	(* -- Expand inputs and index-matched options to take into account the NumberOfReplicates option -- *)
	(* - Expand the index-matched inputs for the NumberOfReplicates - *)
	{samplesWithReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentPAGE,mySamples,expandedResolvedOptions];

	{
		expandedAliquotAmounts,expandedSampleVolumes,expandedSamplesInStorage,expandedLoadingBufferVolumes
	}=
			Lookup[optionsWithReplicates,
				{
					AliquotAmount,SampleVolume,SamplesInStorageCondition,LoadingBufferVolume
				},
				Null
			];

	(* -- First, figure out how many ladders / gels we need -- *)
	(* Make a variable for number of input samples *)
	numberOfSamples=Length[samplesWithReplicates];

	(* - Logic below based on number of lanes in the gel - *)
	(* get the number of ladder lanes needed *)
	numberOfLadders=Ceiling[numberOfSamples/((numberOfGelLanes-2)/2)];

	(* Find the number of lanes that will be run during the experiment *)
	numberOfLanes=numberOfSamples+numberOfLadders;

	(* get the gel number for each lane that has a sample in it *)
	gelNumberPerSampleLane=Ceiling[Range[numberOfSamples]/(numberOfGelLanes-2)];

	(* Figure out how many Gels will be run *)
	numberOfGels=Max[gelNumberPerSampleLane];

	(* Get the number of samples (not including ladders) that go in each gel as a list of the same length as the number of gels *)
	sampleLanesPerGel=Tally[gelNumberPerSampleLane][[All,2]];

	(* Generate resource blobs for all number of cassettes that are necessary *)
	gelResources=If[MatchQ[gel,Except[_List]],
		Link[Resource[Sample->gel,Name->ToString[Unique[]]]]&/@Range[numberOfGels],
		Link[Resource[Sample->#,Name->ToString[Unique[]]]]&/@gel
	];

	(* Duplicate the gel resource blobs for the number of samples in each of the gels, then Flatten it all together *)
	(* for example, if we have {8,8,8,2} lanes for the 4 gels, respectively, I will duplicate the first, second, and third resource blobs x8, and the fourth one x2 *)
	gelResourcesExpanded=Flatten[MapThread[
		ConstantArray[#1,#2]&,
		{gelResources,sampleLanesPerGel}
	]];

	(* ---- To make resources, we need to find the input Objects and Models that are unique, and to request the total volume of them that is needed ---- *)
	(* --  For each input or option object/volume pair, make a list of rules - ask for a bit more than requested in the cases it makes sense to, to take into account dead volumes etc -- *)
	(* - First, we need to make a list of volumes that are index matched to the expanded samples in, with the SampleVolume if no Aliquotting is occurring, or the AliquotAmount if Aliquotting is happening - *)
	expandedSampleOrAliquotVolumes=MapThread[
		If[MatchQ[#2,Null],
			(#1+7*Microliter),
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

	(* --- Generate resources for the various buffers used --- *)
	(* For the StainingSolution, make the Resource separately because it is a special snowflake that is potentially light sensitive *)
	stainNeeded=If[

		(* If we are doing a post run stain *)
		MatchQ[stainVolume,Except[Null]],

		(* THEN the amount of staining solution we need is the StainVolume times the number of Gels times 1.25 for some extra *)
		numberOfGels*(stainVolume+10*Milliliter),

		(* ELSE we dont need any *)
		Null
	];

	(* Make the staining solution in a plastic, fully opaque bottle to prevent stain from adhering to sides and getting bleached *)
	stainingSolutionResource=If[

		(* IF we are doing a post run stain *)
		MatchQ[stainingSolution,Except[Null]],

		(* THEN we make a Resource for it *)
		Link[Resource[Sample->stainingSolution,Container->Model[Container, Vessel, "250mL Amber Polyproylene Bottle"],Amount->stainNeeded,RentContainer->True]],

		(* ELSE, we don't *)
		Null
	];

	(* -- Define the Volume rules for all of the buffers and Ladder used in the experiment -- *)
	(* - Things we will need in liquid handler compatible containers - *)
	(* - Ladder - *)
	ladderVolumeRule={ladder->RoundOptionPrecision[((ladderVolume*numberOfLadders)+30*Microliter),10^-1*Microliter]};

	(* - LoadingBuffer - *)
	loadingBufferVolumeRule={loadingBuffer->RoundOptionPrecision[((Total[expandedLoadingBufferVolumes]*1.2)+20*Microliter),10^0*Microliter]};

	(* - LadderLoadingBuffer -*)
	ladderLoadingBufferVolumeRule={ladderLoadingBuffer->((numberOfLadders*ladderLoadingBufferVolume)+20*Microliter)};

	(* Things we want in PreferredContainers *)
	(* - GelBuffer - *)
	gelBufferPerGel=20*Milliliter;
	gelBufferVolumeRule={gelBuffer->(numberOfGels*20*Milliliter*1.25)};

	(* - ReservoirBuffer - *)
	reservoirBufferVolumeRule={reservoirBuffer->(numberOfGels*70*Milliliter)};

	(* - PrewashingSolution - *)
	prewashingSolutionVolumeRule=If[

		(* IF prewashing is happening *)
		MatchQ[prewashingSolution,Except[Null]],

		(* THEN we define the volume rule *)
		{prewashingSolution->(((prewashVolume+7*Milliliter)*numberOfGels)+35*Milliliter)},

		(* ELSE, just set a dummy rule *)
		{Null->0*Milliliter}
	];

	(* - RinsingSolution - *)
	rinsingSolutionVolumeRule=If[

		(* IF rinsing is happening *)
		MatchQ[rinsingSolution,Except[Null]],

		(* Then we define the volume rule *)
		{rinsingSolution->Min[(((rinseVolume+7*Milliliter)*numberOfGels*numberOfRinses)+35*Milliliter),200*Milliliter]},

		(* ELSE, just set a dummy rule *)
		{Null->0*Milliliter}
	];

	(* --- Make the resources --- *)
	(* -- We want to make the resources for each unique  Object or Model Input, for the total volume required for the experiment for each -- *)
	(* - First, join the lists of the rules above for the things we want in liquid handler compatible containers,
	 getting rid of any Rules with the pattern _->0*Microliter or Null->_ - *)
	allLiquidHandlerCompatibleVolumeRules=Cases[
		Join[
			ladderVolumeRule,loadingBufferVolumeRule,ladderLoadingBufferVolumeRule
		],
		Except[Alternatives[_->0*Microliter,Null->_]]
	];

	(* - Also do this for the Buffers we will use Macro and want in PreferredContainers - *)
	allPreferredContainerVolumeRules=Cases[
		Join[
			gelBufferVolumeRule,reservoirBufferVolumeRule,prewashingSolutionVolumeRule,rinsingSolutionVolumeRule
		],
		Except[Alternatives[_->0*Microliter,Null->_]]
	];

	(* - Make associations whose keys are the unique Object and Model Keys in the list of allLiquidHandlerCompatibleVolumeRules or
	allPreferredContainerVolumeRules, and whose values are the total volume of each of those unique keys - *)
	uniqueLiquidHandlerObjectsAndVolumesAssociation=Merge[allLiquidHandlerCompatibleVolumeRules,Total];
	uniquePreferredContainerObjectsAndVolumesAssociation=Merge[allPreferredContainerVolumeRules,Total];

	(* Check Sterile status of the buffers so we can make sure we get a correct container *)
	bufferSterileRule=DeleteCases[DeleteDuplicates[MapThread[(Download[#1,Object]->#2)&,{Flatten[{reservoirBuffer,gelBuffer,prewashingSolution,rinsingSolution}],Flatten[bufferSterileDownloads]}]],(Null->_)];

	(* - Use these associations to make Resources for each unique Object or Model Key, either in liquid handler compatible containers or
	 preferred containers- *)
	uniqueLiquidHandlerResources=KeyValueMap[
		Module[{amount,containers},
			amount=#2;
			containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];
			Resource[Sample->#1,Amount->amount,Container->containers,Name->ToString[#1]]
		]&,
		uniqueLiquidHandlerObjectsAndVolumesAssociation
	];
	uniquePreferredContainerResources=KeyValueMap[
		Module[{amount,containers,sterileQ},
			amount=#2;
			sterileQ=TrueQ[Lookup[bufferSterileRule,Download[#1,Object],Null]];
			containers=If[sterileQ,
				PickList[preferredSterileContainers,preferredSterileContainerMaxVolumes,GreaterEqualP[amount]],
				PickList[preferredContainers,preferredContainerMaxVolumes,GreaterEqualP[amount]]
			];
			Resource[Sample->#1,Amount->amount,Container->containers,Name->ToString[#1]]
		]&,
		uniquePreferredContainerObjectsAndVolumesAssociation
	];

	(* -- Define a list of replace rules for the unique Models and Objects with the corresponding Resources --*)
	(* - Find a list of the unique liquid handler Object/Model Keys - *)
	uniqueLiquidHandlerObjects=Keys[uniqueLiquidHandlerObjectsAndVolumesAssociation];

	(* - Do the same with the preferredContainer resources- *)
	uniquePreferredContainerObjects=Keys[uniquePreferredContainerObjectsAndVolumesAssociation];

	(* - Make two lists of replace rules, replacing unique objects with their respective Resources - *)
	uniqueLiquidHandlerObjectResourceReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueLiquidHandlerObjects,uniqueLiquidHandlerResources}
	];
	uniquePreferredContainerObjectResourceReplaceRules=MapThread[
		(#1->#2)&,
		{uniquePreferredContainerObjects,uniquePreferredContainerResources}
	];

	(* - For the options that are single objects needed in liquid handler compatible containers,
	Map over replacing the option with the replace rules to get the corresponding resources - *)
	{
		ladderResource,loadingBufferResource,ladderLoadingBufferResource
	}=Map[
		Replace[#,uniqueLiquidHandlerObjectResourceReplaceRules]&,
		{
			ladder,loadingBuffer,ladderLoadingBuffer
		}
	];

	(* - For the options that are single objects needed in preferred containers,
	Map over replacing the option with the replace rules to get the corresponding resources - *)
	{
		gelBufferResource,reservoirBufferResource,prewashingSolutionResource,rinsingSolutionResource
	}=Map[
		Replace[#,uniquePreferredContainerObjectResourceReplaceRules]&,
		{
			gelBuffer,reservoirBuffer,prewashingSolution,rinsingSolution
		}
	];

	(* --- make the resource packet for instrument ---*)
	instrumentResource=Resource[
		Instrument->instrument,
		Time->separationTime+2*Hour
	];

	(* --- Make resources for all the other fields in question ---*)
	(* Make resources for the pipette tips, this is a list for reasons I don't understand yet but hopefully will by the time anyone reads this *)
	(* Make resources for the pipette tips - making two separate resources so that users don't ALWAYS buy tips for the Ranger if none are needed *)
	primaryPipettteTipsResource=Link[Resource[
		Sample -> Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"],
		Amount->96
	]];
	secondaryPipetteTipsResource=Link[Resource[
		Sample -> Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"],
		Amount->96
	]];

	(* Make a resource for the GelBufferTransferVessel *)
	gelBufferTransferVesselResource = Link[Resource[Sample -> Model[Container, Vessel, "50mL Tube"]]];

	(* make a resource for the ReservoirBufferTransferVessel *)
	reservoirBufferTransferVesselResource = Link[Resource[Sample -> Model[Container, Vessel, "50mL Tube"]]];

	(* Experiment parameters are calculated to work with the model containers specified below for the WasteReservoir and StainReservoir *)
	(* make a resource for the WasteReservoir *)
	wasteReservoirResource = If[postRunStaining,
		Link[Resource[Sample -> Model[Container,Plate,"200mL Polypropylene Robotic Reservoir, non-sterile"]]],
		Null
	];

	(* Make a resource for the SecondaryWasgeReservoir *)
	secondaryWasteReservoirResource=If[

		(* IF we are doing post run staining *)
		And[
			postRunStaining,
			(* AND EITHER we are doing more than one rinse, or we are doing prewashing *)
			Or[
				MatchQ[numberOfRinses,GreaterP[1]],
				MatchQ[prewashingSolution,Except[Null]]
			]
		],

		(* THEN we make the resource *)
		Link[Resource[Sample -> Model[Container,Plate,"200mL Polypropylene Robotic Reservoir, non-sterile"]]],

		(* ELSE, we don't *)
		Null
	];

	(* make a resource for the StainReservoir *)
	stainReservoirResource = If[postRunStaining,
		Link[Resource[Sample -> Model[Container, Plate, "8-row Polypropylene Reservoir"]]],
		Null
	];

	(* Make resources for the RinseReservoir and SecondaryRinseReservoir *)
	rinseReservoirResource=If[

		(* IF we are doing post run staining AND the NumberOfRinses is more than 1 *)
		And[
			postRunStaining,
			MatchQ[rinsingSolution,Except[Null]],
			MatchQ[numberOfRinses,GreaterP[1]]
		],

		(* THEN we make the resource *)
		Link[Resource[Sample -> Model[Container,Plate,"200mL Polypropylene Robotic Reservoir, non-sterile"]]],

		(* ELSE we don't *)
		Null
	];

	secondaryRinseReservoirResource=If[

		(* IF we are doing post run staining *)
		And[
			postRunStaining,
			(* AND  we are doing Prewashing *)
			MatchQ[prewashingSolution,Except[Null]]
		],

		(* THEN we make the resource *)
		Link[Resource[Sample -> Model[Container,Plate,"200mL Polypropylene Robotic Reservoir, non-sterile"]]],

		(* ELSE we don't *)
		Null
	];

	(* create the PAGE ID *)
	pageID=CreateID[Object[Protocol,PAGE]];

	(* get the author *)
	author=$PersonID;

	(* Define the excitation and emission wavelength fields based on the filter set *)
	{excitationWavelength,excitationBandwidth,emissionWavelength,emissionBandwidth}=Switch[filterSet,

		(* Case where we are using the Blue Filter Set *)
		BlueFluorescence,
			{470*Nanometer,70*Nanometer,540*Nanometer,40*Nanometer},

		(* Case where we are using the Red Filter Set *)
		RedFluorescence,
			{625*Nanometer,30*Nanometer,677*Nanometer,46*Nanometer},

		(* Catch all that we should never hit until we bring online manual gels *)
		_,
			{470*Nanometer,70*Nanometer,540*Nanometer,40*Nanometer}
	];

	(* generate a PAGE packet with the gel buffer names *)
	protocolPacket=
			<|
				Object->pageID,
				Type->Object[Protocol,PAGE],
				Template -> Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated],
				(* General *)
				Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@sampleContainersIn,
				ResolvedOptions->myResolvedOptions,
				UnresolvedOptions->myUnresolvedOptions,

				Replace[SamplesIn]->(Link[#,Protocols]&/@samplesInResources),
				Replace[SampleVolumes]->expandedSampleVolumes,
				Replace[Gels]->gelResourcesExpanded,
				Instrument->instrumentResource,
				LoadingBuffer->loadingBufferResource,
				Replace[LoadingBufferVolumes]->expandedLoadingBufferVolumes,
				PrewashingSolution->prewashingSolutionResource,
				PrewashVolume->prewashVolume,
				PrewashingTime->prewashingTime,
				RinsingSolution->rinsingSolutionResource,
				RinseVolume->rinseVolume,
				RinsingTime->rinsingTime,
				NumberOfRinses->numberOfRinses,
				ReservoirBuffer->reservoirBufferResource,
				GelBuffer->gelBufferResource,
				PostRunStaining->postRunStaining,
				StainingSolution->stainingSolutionResource,
				StainingTime->stainingTime,
				StainVolume->stainVolume,
				Ladder->ladderResource,
				LadderVolume->ladderVolume,
				LadderLoadingBuffer->ladderLoadingBufferResource,
				LadderLoadingBufferVolume->ladderLoadingBufferVolume,
				NumberOfLanes->numberOfLanes,
				NumberOfGels->numberOfGels,
				PrimaryPipetteTips->primaryPipettteTipsResource,
				SecondaryPipetteTips->secondaryPipetteTipsResource,
				GelBufferTransferVessel->gelBufferTransferVesselResource,
				ReservoirBufferTransferVessel->reservoirBufferTransferVesselResource,
				WasteReservoir->wasteReservoirResource,
				SecondaryWasteReservoir->secondaryWasteReservoirResource,
				StainReservoir->stainReservoirResource,
				RinseReservoir->rinseReservoirResource,
				SecondaryRinseReservoir->secondaryRinseReservoirResource,
				LadderStorageCondition->ladderStorageCondition,

				LoadingPlate->Resource[Sample->Model[Container, Plate, "id:01G6nvkKrrYm"]],
				GelModel->Link[gelModel],
				GelMaterial->gelMaterial,
				GelPercentage->gelPercentage,
				CrosslinkerRatio->crosslinkerRatio,
				DenaturingGel->True,
				SampleLoadingVolume->sampleLoadingVolume,
				SeparationTime->separationTime,
				Voltage->voltage,
				DutyCycle->dutyCycle,
				Replace[SamplesInStorage]->expandedSamplesInStorage,
				SampleDenaturing->sampleDenaturing,
				DenaturingTime->denaturingTime,
				DenaturingTemperature->denaturingTemperature,

				(* Experiment parameter defaults *)
				(* these changed a little bit with ranger software version 1.5.0.17 *)
				ExposureTime -> 271.0*Millisecond,
				LowExposureTime->20.0*Millisecond,
				MediumLowExposureTime->73.0*Millisecond,
				MediumHighExposureTime->271.0*Millisecond,
				HighExposureTime->1000.0*Millisecond,
				ExcitationWavelength -> excitationWavelength,
				ExcitationBandwidth -> excitationBandwidth,
				EmissionWavelength -> emissionWavelength,
				EmissionBandwidth -> emissionBandwidth,
				CycleDuration -> 125*Microsecond,
				GelBufferVolume -> 20*Milliliter,
				ReservoirBufferVolume -> 35*Milliliter,

				(* check points, no checkpoint estimates *)
				Replace[Checkpoints] -> {
					{"Preparing Samples", 2 Hour, "Preprocessing, such as mixing, centrifuging, thermal incubation, filtration, and aliquoting, is performed. Samples and ladders are prepared for loading into the gel.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 2Hour]]},
					{"Running the Gel", (separationTime+2*Hour), "Samples are separated according to their electrophoretic mobility.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> (separationTime+2*Hour)]]},
					{"Returning Materials", 30 Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 30 Minute]]}
				}
			|>;


	(* Generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Cache->inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* --- fulfillableResourceQ --- *)

	(* Get all the resource blobs *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache],Null}
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
		frqTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}

];
