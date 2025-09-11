(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* Source Code *)


(* ::Subsection:: *)
(* ExperimentSerialDilute *)


(* ::Subsubsection:: *)
(* ExperimentSerialDilute Options*)


(* get the shared options from ExperimentDilute *)

DefineOptions[ExperimentSerialDilute,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",

			{
				OptionName -> SourceLabel,
				Default -> Automatic,
				Description -> "The label of the source sample that is used in the sequential dilution.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation -> True
			},
			{
				OptionName ->SourceContainerLabel,
				Default -> Automatic,
				Description -> "The label of the source sample's container that is used for the transfer.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation -> True
			},

			{
				OptionName->SerialDilutionFactors,
				Default->Automatic,
				Widget->
					Adder[
						Widget[
							Type-> Number,
							Pattern:>GreaterEqualP[1]
						]
					],
				Category->"General",
				Description->
					"The factors by which you wish to reduce the concentrations starting with SamplesIn, followed by each previous dilution in the series of dilutions. This or TargetConcentrations must be provided, or an error is thrown.",
				ResolutionDescription->
					"Automatically set to 10. This option can also be calculated from equations in Process Diagrams.",
				AllowNull->True
			},
			
			{
				OptionName->NumberOfSerialDilutions,
				Default->Automatic,
				Widget->
        			Widget[
						Type->Number,
						Pattern:>GreaterEqualP[1,1]
				],
				Category->"General",
				Description->
					"The number of times the sample is repeatedly diluted, starting with SamplesIn, followed by each previous dilution.",
				ResolutionDescription->"Automatically set to the number of TargetConcentrations or SerialDilutionFactors if provided, otherwise set to 1.",
				AllowNull->False
			},

			{
				OptionName->TargetConcentrations,
				Default->Automatic,
				Widget->
						Adder[
							Widget[
								Type->Quantity,
								Pattern:>GreaterP[0 Molar]|GreaterP[0 Gram/Liter],
								Units->Alternatives[{1,{Micromolar,{Nanomolar,Micromolar,Millimolar,Molar}}},
								CompoundUnit[{1,{Milligram,{Microgram,Milligram,Gram}}},
											{-1,{Liter,{Microliter,Milliliter,Liter}}}]]
								]
						],
				Category->"General",
				Description->"Desired concentrations of Analyte in the final diluted samples after serial dilutions.",
				ResolutionDescription->"Automatically set to 2Molar. In either Direct or FromConcentrate, this can be calculated from the equations in Process Diagrams.",
				AllowNull->True
			},
			
			{
				OptionName->Analyte,
				Default->Automatic,
				Widget ->
        			Widget[
						Type -> Object,
						Pattern :> ObjectP[IdentityModelTypes],
						ObjectTypes -> IdentityModelTypes
				],
				Category->"General",
				Description->
					"The components in SamplesIn's Composition whose final concentrations (TargetConcentrations) are attained through a series of repeated dilutions.",
				ResolutionDescription->"Automatically set to the first value in the Analytes field of SamplesIn, or, if not populated, to the first analyte in the Composition field of the input sample, or if none exist, the first identity model of any kind in the Composition field.",
				AllowNull->True
			},

			{
				OptionName->FinalVolume,
				Default->Automatic,
				Widget->Adder[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0Microliter,$MaxTransferVolume],
								Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
							]
				],
				Category->"General",
				Description->"The volume into which the sample is diluted for each serial dilution.",
				ResolutionDescription->"Automatically set to 100Microliter. In either Direct or FromConcentrate, can be calculated from the equations in Process Diagrams.",
				AllowNull->False	
			},
			
			{
				OptionName->BufferDilutionStrategy,
				Default->Direct,
				Widget->
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Direct,FromConcentrate]
						],
				Category->"General",
				Description->"BufferDilutionStrategy describes the manner in which to generate to buffer samples for each serial dilution. FromConcentrate provides ConcentratedBuffer to each well, which is then diluted with BufferDiluent to reach a final buffer concentraion of 1X, whereas Direct uses pre-diluted buffer which is already at 1X to perform the subsequent dilutions (see Equations chart in Process Diagrams).",
				AllowNull->False
			},

			{
				OptionName->TransferAmounts,
				Default->Automatic,
				Widget->
							Adder[
								Widget[
									Type->Quantity,
									Pattern:>RangeP[0Microliter,$MaxTransferVolume],
									Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
									]
							],
				Category->"General",
				Description->
					"The series of volume transferred starting from SamplesIn, and going into each subsequent dilution.",
				ResolutionDescription->
					"Automatically set to 10Microliter. If SerialDilutionFactors or TargetConcentrations, and FinalVolume are provided, this option can be calculated from the equations in Process Diagrams.",
				AllowNull->False
			},
			
			{ 
				OptionName->Diluent,
				Default->Automatic,
				Widget-> 
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Reagents",
								"Water"
							}
						}
					],
				Category->"General",
				Description->
					"The solution used to reduce the concentration of the SamplesIn and each subsequent dilution.",
				ResolutionDescription->
					"Automatically set to the Solvent of SamplesIn, or Model[Sample,\"milli-Q Water\"] if Solvent is not defined.",
				AllowNull->True
			},
			{
				OptionName -> DiluentLabel,
				Default -> Automatic,
				Description -> "The label of the diluent added to the diluted sample.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},

			{
				OptionName->DiluentAmount,
				Default->Automatic,
				Widget->
						Adder[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0Microliter,$MaxTransferVolume],
								Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
							]
						],
				Category->"General",
				Description->"The amount of solution used to reduce the concentration of the SamplesIn and each subsequent dilution.",
				ResolutionDescription->"Automatically set to 90Microliter. If SerialDilutionFactors or TargetConcentrations, and FinalVolume are provided, this option can be calculated from the equations in Process Diagrams.",
				AllowNull->False
			},
			
			{
				OptionName->BufferDiluent,
				Default->Null,
				Widget-> 
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Reagents",
								"Water"
							}
						}
					],
				Category->"General",
				Description->
					"The solution used to reduce the concentration of the ConcentratedBuffer in the first and each subsequent dilution.",
				ResolutionDescription->
					"If the BufferDilutionStrategy is Direct, it will be set to Null. If not, it will automatically be set to the Solvent of ConcentratedBuffer, or Model[\"milli-Q Water\"] if Solvent is not defined.",
				AllowNull->True
			},
			{
				OptionName -> BufferDiluentLabel,
				Default -> Automatic,
				Description -> "The label of the buffer used to dilute the sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			
			{
				OptionName->BufferDilutionFactor,
				Default->Automatic,
				Widget->
        			Widget[
						Type->Number,
						Pattern:>GreaterEqualP[1]
					],
				Category->"General",
				Description->
					"The factor by which to reduce the concentration of the ConcentratedBufferDilutionFactor (but not the input sample) in all of the dilutions.",
				ResolutionDescription->"Automatically set to the ConcentratedBufferDilutionFactor of ConcentratedBuffer. If ConcentratedBufferDilutionFactor is not defined, automatically set to 10 and throws a warning.",
				AllowNull->False
			},

			{
				OptionName->BufferDiluentAmount,
				Default->Automatic,
				Widget->
						Adder[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0Microliter,$MaxTransferVolume],
								Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
							]
						],
				Category->"General",
				Description->"The amount of buffer diluent to be added to reduce the concentration of ConcentratedBuffer in each dilution.",
				ResolutionDescription->"Can be calculated from the equations in Process Diagrams.",
				AllowNull->True
			},
						
			{
				OptionName->ConcentratedBuffer,
				Default->Null,
				Widget->
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Reagents",
								"Buffers"
							}
						}
					],
				Category->"General",
				Description->
					"The buffer used in the first dilution from SamplesIn. If BufferDiluentStrategy is FromConcentrate, then it will also be used in subsequent dilutions.",
				AllowNull->True
			},
			{
				OptionName -> ConcentratedBufferLabel,
				Default -> Automatic,
				Description -> "The label of the concentrated buffer that is diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent).",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},

			{
				OptionName->ConcentratedBufferAmount,
				Default->Automatic,
				Widget->
						Adder[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0Microliter,20*Liter],
								Units->{1,{Microliter,{Microliter,Milliliter,Liter}}}
							]
						],
				Category->"General",
				Description->
					"The amount of ConcentratedBuffer used in the first dilution from SamplesIn and each subsequent dilution.",
				ResolutionDescription->"Can be calculated from the equations in Additional Information.",
				AllowNull->True
			},
					
			{
				OptionName->DiscardFinalTransfer,
				Default->False,
				Widget->
        			Widget[
						Type->Enumeration,
						Pattern:>BooleanP
				],
				Category->"General",
				Description->
					"Indicates if the final wells contain the same volume as the previously diluted wells by removing TransferAmount from the final dilution.",
				AllowNull->True
			},
			
			{
				OptionName->DestinationWells,
				Default->Automatic,
				Widget->
        			Adder[
						Widget[
							Type->String,
							Pattern:>WellPositionP,
							Size->Word,
							PatternTooltip->"Enumeration must be any well from A1 to P24."
						]
					],
				Category->"General",
				Description->"The wells in which the dilutions will occur in ContainerOut if the dilutions occur in well plates.",
				ResolutionDescription->"Automatically determined based on available wells and volume of liquid.",
				AllowNull->True
			},

			{
				OptionName -> ContainerOut,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Adder[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container], Object[Container]}],
							ObjectTypes -> {Model[Container], Object[Container]},
							PreparedSample -> False,
							PreparedContainer -> True,
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Containers"
								}
							}
						]
					],
					Adder[{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								PreparedSample -> False,
								PreparedContainer -> True,
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}]
				],
				Category->"General",
				Description -> "The desired type of container that should be used to prepare and house the diluted samples, with indices indicating grouping of samples in the same plates, if desired.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the AssayVolume of the sample.  For plates, attempts to fill all wells of a single plate with the same model before diluting into the next."
			},
			{
				OptionName -> SampleOutLabel,
				Default -> Automatic,
				Description -> "The label of the sample(s) that become the SamplesOut.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Adder[Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				]],
				UnitOperation -> True
			},
			{
				OptionName -> ContainerOutLabel,
				Default -> Automatic,
				Description -> "The label of the container that holds the sample that becomes the SamplesOut.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Adder[Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				]],
				UnitOperation -> True
			},

			(*Mixing options between Transfers, copied from ExpDilute with names & descs changed*)
			{
				OptionName -> TransferMix,
				Default -> True,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if mixing of the samples is needed after each dilution in the series.",
				Category -> "Mixing"
			},

			{
				OptionName -> TransferMixType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Pipette|Swirl
				],
				Description -> "Determines which type of mixing should be performed on the diluted samples after each dispense.",
				ResolutionDescription -> "Automatically set based on the Volume option and size of the container in which the sample is prepared.",
				Category -> "Mixing"
			},

			{
				OptionName->TransferNumberOfMixes,
				Default->Automatic,
				Widget->
						Widget[
							Type->Number,
							Pattern:>GreaterEqualP[0,1]
							],
				Description->"Determines the number of times the sample is mixed for discrete mixing processes such as Pipette or Swirl.",
				AllowNull->True,
				Category->"Mixing"
			},

			(*Incubate options to be resolved by resolveSamplePrepOptions*)
			{
				OptionName->Incubate,
				Default->True,
				Widget->
					Widget[
						Type->Enumeration,
						Pattern:>BooleanP
					],
				Description->
					"Determines if incubation of the samples should occur after the dilutions.",
				AllowNull->True,
				Category->"Mixing"
			},

			(*(*modifiedMix*)
			ModifyOptions[ExperimentDilute,{OptionName->Mix,Description->"Indicates if mixing of the samples is needed after each dilution in the series."}],

			(*modifiedMixType*)
			ModifyOptions[ExperimentDilute,{OptionName->MixType,Description->"Determines which type of mixing should be performed on the diluted samples after each dispense.",Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Pipette|Swirl
			]}],*)

			(*modifiedIncubationTime*)
			ModifyOptions[ExperimentDilute,
				{OptionName->IncubationTime,Description->
					"Determines how long the incubation should occur for the sample after the dilutions."}],

			(*modifiedMaxIncubationTime*)
			ModifyOptions[ExperimentDilute,
				{OptionName->MaxIncubationTime,Description->
					"The maximum time to let the samples incubate after the dilutions."}],

			(*modifiedIncubationTemperature*)
			(*modified such that minimum temp is 0Celsius, for the heatercoolers on deck, before was 22C*)
			ModifyOptions[ExperimentDilute,
				{
					OptionName->IncubationTemperature,
					Description->
					"The temperature at which the diluted samples will incubate after the dilutions."
				}
			]
		],
		PreparationOption,
		{
			OptionName -> ResolveMethod,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "If True, this resolver is being called as part of resolveSerialDiluteMethod, and certain labels are resolved differently.",
			Category -> "Hidden"
		},
		ModelInputOptions,
		(* don't actually want this exposed to the customer, but do need it under the hood for ModelInputOptions to work *)
		ModifyOptions[
			PreparatoryUnitOperationsOption,
			Category -> "Hidden"
		]

	},
	SharedOptions:>{
		ProtocolOptions,
		WorkCellOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions,
		SimulationOption,
		NonBiologyPostProcessingOptions
	}
];

Error::noellefakeerrormessage = "This is a fake error message.";

(*singular input overload*)
ExperimentSerialDilute[mySamples:ObjectP[Object[Sample]],myOptions:OptionsPattern[]]:=ExperimentSerialDilute[{mySamples},myOptions];

ExperimentSerialDilute[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,
		safeOpsNamed,safeOpsTests,mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples,
		validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cache,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,resourcePackets,runTime,resourcePacketTests,listedSamples, listedOptions,

		(* download variables *)
		concentratedBuffer, bufferDiluent, specifiedContainerOut,
		containerOutModels,containerOutObjs,preferredContainerModels,sampleFields,modelFields,
		containerFields,containerModelFields,allDownloadValues,inheritedCache, simulation, updatedSimulation,
		simulatedProtocol, newSimulation, performSimulationQ, allTests, upload, parentProt, previewRule,
		testsRule,simulationRule,runTimeRule,resultRule,confirm,canaryBranch, fastTrack, optionsRule, constellationMessageRule,

		allDiluentModels,
		allDiluentObjs,
		allBufferDiluentModels,
		allBufferDiluentObjs,
		allConcentratedBufferModels,
		allConcentratedBufferObjs,analyte,diluent,allAnalyteModels,allAnalyteObjs, preparation, workCell, samplePrepModelSampleField,
		samplePrepModelContainerField,

		resourcePacketsResult, simulationResult, validQ,newCache, samplePreparationSimulation

	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];

	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links. *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentSerialDilute,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];


	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentSerialDilute,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentSerialDilute,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* replace all objects referenced by Name to ID *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> samplePreparationSimulation
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentSerialDilute,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentSerialDilute,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> samplePreparationSimulation
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentSerialDilute,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentSerialDilute,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> samplePreparationSimulation
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentSerialDilute,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* TODO: FILL THIS IN ONCE THE RESOLVE<TYPE>OPTIONS AND <TYPE>RESOURCE PACKETS ARE FINISHED *)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

	(* -------------- *)
	(* ---DOWNLOAD--- *)
	(* -------------- *)
	(* FIXME: this is an example taken from ExperimentDilute and needs to be updated *)

	(* pull out the Analyte, Diluent, ConcentratedBuffer, BufferDiluent, and ContainerOut options *)
	{analyte,diluent,bufferDiluent,concentratedBuffer,specifiedContainerOut}=Lookup[expandedSafeOps,{Analyte,Diluent,BufferDiluent,ConcentratedBuffer,ContainerOut}];

	(* get all the diluent, bufferdiluent and concentratedbuffers that were specified as models and objects *)
	allDiluentModels=Cases[Flatten[{diluent}],ObjectP[Model[Sample]]];
	allBufferDiluentModels=Cases[Flatten[{bufferDiluent}],ObjectP[Model[Sample]]];
	allConcentratedBufferModels=Cases[Flatten[{concentratedBuffer}],ObjectP[Model[Sample]]];

	allDiluentObjs=Cases[Flatten[{diluent}],ObjectP[Object[Sample]]];
	allBufferDiluentObjs=Cases[Flatten[{bufferDiluent}],ObjectP[Object[Sample]]];
	allConcentratedBufferObjs=Cases[Flatten[{concentratedBuffer}],ObjectP[Object[Sample]]];

	(*get all the analytes that were specified as models and object *)
	allAnalyteModels=Cases[Flatten[{analyte}],ObjectP[Model[Sample]]];
	allAnalyteObjs=Cases[Flatten[{analyte}],ObjectP[Object[Sample]]];

	(* get all the ContainerOut models and objects *)
	containerOutModels=Cases[Flatten[ToList[specifiedContainerOut]],ObjectP[Model[Container]]];
	containerOutObjs=Cases[Flatten[ToList[specifiedContainerOut]],ObjectP[Object[Container]]];

	(* if the Container option is Automatic, we might end up calling PreferredContainer; so we've gotta make sure we download info from all the objects it might spit out *)
	(* need this because we need to lookup wells *)
	preferredContainerModels=If[MatchQ[specifiedContainerOut,Automatic]||MemberQ[Flatten[ToList[specifiedContainerOut]],Automatic],
		DeleteDuplicates[
			Flatten[{
				PreferredContainer[All, Type -> All],
				PreferredContainer[All, Sterile -> True, Type -> All],
				PreferredContainer[All, Sterile -> True, LiquidHandlerCompatible -> True, Type -> All]
			}]
		],
		{}
	];

	(* get the Object[Sample], Model[Sample], Object[Container], and Model[Container] fields I need *)
	sampleFields = Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence], MassConcentration, Concentration, StorageCondition,
		ThawTime, ThawTemperature,TransportTemperature, LightSensitive];

	modelFields = Packet[Model[{SamplePreparationCacheFields[Model[Sample], Format -> Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock}]];

	containerFields = Packet[Container[{SamplePreparationCacheFields[Object[Container], Format -> Sequence]}]];

	containerModelFields = Packet[Container[Model][{SamplePreparationCacheFields[Model[Container], Format -> Sequence]}]];

	inheritedCache=Lookup[safeOps,Cache];

	samplePrepModelSampleField = Packet[SamplePreparationCacheFields[Model[Sample], Format -> Sequence]];
	samplePrepModelContainerField = Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence]];

	(* make the Download call on all the samples, containers, and buffers *)
	allDownloadValues=Check[
		Quiet[
			Download[
				{
					Flatten[mySamplesWithPreparedSamples],
					allDiluentModels,
					allDiluentObjs,
					allBufferDiluentModels,
					allBufferDiluentObjs,
					allConcentratedBufferModels,
					allConcentratedBufferObjs,
					containerOutModels,
					containerOutObjs,
					preferredContainerModels
				},
				Evaluate[{
					{ 	(*for Flatten[mySamplesWithPreparedSamples]*)
						sampleFields,
						modelFields,
						containerFields,
						containerModelFields,
						Packet[Field[Composition[[All, 2]][MolecularWeight]]],
						Packet[Field[Composition[[All, 2]][Density]]]
					},
					{
						(*for allDiluentModels*)
						samplePrepModelSampleField
					},
					{
						(*for allDiluentObjs*)
						sampleFields,
						modelFields,
						containerFields,
						containerModelFields
					},

					{
						(*for allBufferDiluentModels*)
						Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence]]
					},
					{
						(*for allBufferDiluentObjs*)
						sampleFields,
						modelFields,
						containerFields,
						containerModelFields
					},
					{
						(*for allConcentratedBufferModels*)
						Packet[SamplePreparationCacheFields[Model[Sample],Format->Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock]
					},
					{
						(*for allConcentratedBufferObjs *)
						sampleFields,
						modelFields,
						containerFields,
						containerModelFields
					},
					{
						(*for containerOutModels*)
						samplePrepModelContainerField
					},
					{
						(*for containerOutObjs*)
						Packet[SamplePreparationCacheFields[Object[Container], Format -> Sequence]],
						Packet[Model[{SamplePreparationCacheFields[Model[Container], Format -> Sequence]}]]
					},
					{
						samplePrepModelContainerField
					}
				}],
				Cache->inheritedCache,
				Date->Now,
				Simulation->samplePreparationSimulation
			],
			{Download::FieldDoesntExist}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];



	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	(* make the new cache, removing any nulls or $Faileds *)
	newCache = Cases[FlattenCachePackets[{inheritedCache, allDownloadValues}], PacketP[]];


	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)

		{resolvedOptions,resolvedOptionsTests}=resolveExperimentSerialDiluteOptions[
			ToList[mySamples],
			expandedSafeOps,
			Cache->newCache,
			Simulation->samplePreparationSimulation,
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
				resolveExperimentSerialDiluteOptions[ToList[mySamples],expandedSafeOps,Cache->newCache, Simulation->samplePreparationSimulation],
				{}
			},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentSerialDilute,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentSerialDilute,collapsedResolvedOptions],
			Preview->Null
		}]
	];


	{preparation, workCell} = Lookup[resolvedOptions, {Preparation, WorkCell}];

	(* Build packets with resources *)

	resourcePacketsResult = Check[
		{{resourcePackets,runTime},updatedSimulation,resourcePacketTests} =
			Which[
				gatherTests,serialDiluteResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps, ReplaceRule[resolvedOptions, Output -> {Result, Simulation, Tests}],Cache->newCache,Simulation->samplePreparationSimulation],
				True,{Sequence@@serialDiluteResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps, ReplaceRule[resolvedOptions, Output -> {Result, Simulation}],Cache->newCache,Simulation->samplePreparationSimulation],Null}
			],
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
	];

	simulationResult = Check[

		{simulatedProtocol, newSimulation} =
			simulateExperimentSerialDilute[
				If[MatchQ[resourcePackets, $Failed] || MemberQ[Flatten[resourcePackets], $Failed|Null],
					$Failed,
					resourcePackets[[1]](* protocol packet*)
				],
				If[MatchQ[resourcePackets, $Failed] || MemberQ[Flatten[resourcePackets], $Failed],
					$Failed,
					Rest[resourcePackets]
				],
				mySamples,
				resolvedOptions,
				Cache -> newCache,
				Simulation -> updatedSimulation
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];


	validQ = Which[
		(* needs to be MemberQ because could possibly generate multiple protocols *)
		MatchQ[resourcePackets, $Failed] || MemberQ[Flatten[resourcePackets], $Failed], False,
		gatherTests && MemberQ[output, Result], RunUnitTest[<|"ExperimentSerialDilute tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	resolvedOptions = Normal[resolvedOptions];

	{upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache, simulation} = Lookup[safeOps, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache, Simulation}];

	performSimulationQ = MemberQ[output, Result|Simulation];

	allTests = Join[safeOpsTests,validLengthTests,resourcePacketTests];
	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the simulation rule*)
	simulationRule = Simulation -> If[performSimulationQ,
		newSimulation,
		Null
	];

	(* generate the RUnTime rule *)
	runTimeRule = RunTime -> runTime;

	optionsRule = Options -> resolvedOptions;

	(* Set a rule for the ConstellationMessage since we can generate different protocol types. *)
	constellationMessageRule = ConstellationMessage -> {
		Object[Protocol, RoboticSamplePreparation], Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]
	};

	(* generate the Result output rule, but only if we've got a Valid experiment call (determined above) *)
	(* note that we are NOT calling UploadProtocol here because the ExperimentSamplePreparation call already did that so no need to do it again *)
	resultRule = Result -> Which[
		Not[validQ], $Failed,
		Not[MemberQ[output, Result]], $Failed,
		(* if we're doing Preparation -> Robotic, return all our unit operation packets without RequireResources called if Upload -> False *)
		MatchQ[preparation, Robotic] && MatchQ[upload, False],
			Rest[resourcePackets],
		(* if we are doing Preparation -> Robotic and Upload -> True, then call ExperimentRoboticSamplePreparation on the serial dilute unit operations *)
		MatchQ[preparation, Robotic],
			Module[{unitOperation, nonHiddenOptions, samplesMaybeWithModels, experimentFunction},

				(* convert the samples to models if we had model inputs originally *)
				(* if we don't have a simulation or a single prep unit op, then we know we didn't have a model input *)
				(* NOTE: this is important: need to use the samplePreparationSimulation from before the resource packets function to do this sample -> model conversion, because we had to do some label shenanigans in the resource packets function that made the label-deconvolution here _not_ work *)
				(* otherwise, the same label will point at two different IDs, and that's going to cause problems *)
				samplesMaybeWithModels = If[NullQ[samplePreparationSimulation] || Not[MatchQ[Lookup[resolvedOptions, PreparatoryUnitOperations], {_[_LabelSample]}]],
					listedSamples,
					simulatedSamplesToModels[
						Lookup[resolvedOptions, PreparatoryUnitOperations][[1, 1]],
						samplePreparationSimulation,
						listedSamples
					]
				];

				unitOperation = SerialDilute @@ Join[
					{
						Source -> samplesMaybeWithModels
					},
					RemoveHiddenPrimitiveOptions[SerialDilute, ToList[resolvedOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentSerialDilute, resolvedOptions];

				(* pick the corresponding function from the association above *)
				experimentFunction = Lookup[$WorkCellToExperimentFunction, workCell];

				(* Memoize the value of ExperimentSerialDilute so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentSerialDilute, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentSerialDilute]={};

					ExperimentSerialDilute[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification = Lookup[ToList[options], Output];

						frameworkOutputSpecification /. {
							Result -> Rest[resourcePackets],
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> newSimulation,
							RunTime -> runTime
						}
					];

					experimentFunction[
						unitOperation,
						Name -> Lookup[safeOps, Name],
						Upload -> Lookup[safeOps, Upload],
						Confirm -> Lookup[safeOps, Confirm],
						CanaryBranch -> Lookup[safeOps, CanaryBranch],
						ParentProtocol -> Lookup[safeOps, ParentProtocol],
						Priority -> Lookup[safeOps, Priority],
						StartDate -> Lookup[safeOps, StartDate],
						HoldOrder -> Lookup[safeOps, HoldOrder],
						QueuePosition -> Lookup[safeOps, QueuePosition],
						ImageSample -> Lookup[resolvedOptions, ImageSample],
						MeasureVolume -> Lookup[resolvedOptions, MeasureVolume],
						MeasureWeight -> Lookup[resolvedOptions, MeasureWeight],
						Cache -> newCache
					]
				]
			],
		(* don't need to call ExperimentManualSamplePreparation here because we already called it in the resource packet sfunction*)
		MatchQ[preparation, Manual] && MemberQ[output, Result] && upload && StringQ[Lookup[resolvedOptions, Name]],
			(
				Upload[resourcePackets, constellationMessageRule];
				If[confirm, UploadProtocolStatus[Lookup[First[resourcePackets], Object], OperatorStart, Upload -> True, FastTrack -> True, UpdatedBy -> If[NullQ[parentProt], $PersonID, parentProt]]];
				Append[Lookup[First[resourcePackets], Type], Lookup[resolvedOptions, Name]]
			),
		MatchQ[preparation, Manual] && MemberQ[output, Result] && upload,
			(
				Upload[resourcePackets, constellationMessageRule];
				If[confirm, UploadProtocolStatus[Lookup[First[resourcePackets], Object], OperatorStart, Upload -> True, FastTrack -> True, UpdatedBy -> If[NullQ[parentProt], $PersonID, parentProt]]];
				Lookup[First[resourcePackets], Object]
			),
		MatchQ[preparation, Manual] && MemberQ[output, Result] && Not[upload],
			resourcePackets,
		True,
			$Failed
	];

	(* return the output as we desire it *)

	outputSpecification /. {previewRule, resultRule, simulationRule, runTimeRule, testsRule, optionsRule}

];



(* Note: The container overload should come after the sample overload. *)
ExperimentSerialDilute[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedContainers,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
	containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests,samplePreparationSimulation,containerToSampleSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links. *)
	{listedContainers, listedOptions}= {ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentSerialDilute,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentSerialDilute,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->samplePreparationSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentSerialDilute,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->{Result,Simulation},
				Simulation->samplePreparationSimulation
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MemberQ[ToList[containerToSampleResult],$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentSerialDilute[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]

];


DefineOptions[
	resolveExperimentSerialDiluteOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

canCalculateDirect[myOptions : _?AssociationQ] :=
	Module[{serialDilutionFactors,finalVolume,targetConcentrations,returnBool},
		{serialDilutionFactors,finalVolume,targetConcentrations} = Lookup[myOptions,{SerialDilutionFactors, FinalVolume, TargetConcentrations}];

		returnBool = If[(MatchQ[serialDilutionFactors,Except[Automatic]]&&MatchQ[finalVolume,Except[Automatic]]) ||
				(MatchQ[targetConcentrations,Except[Automatic]]&&MatchQ[finalVolume,Except[Automatic]]),
			True,
      False
			];
		returnBool
	];

calculateDirect[varName_Symbol, ConcentrationFactor_Integer,
	myOptions : _?AssociationQ,serialDilutionFactors_,finalVolume_] :=
	Module[{transferAmount, concentratedBufferAmount,
		concentratedBuffer, firstDA, restDAs},
		(*{finalVolume} = Lookup[myOptions, {FinalVolume}];*)
		concentratedBuffer = Lookup[myOptions, ConcentratedBuffer];
		transferAmount = UnitConvert[finalVolume/serialDilutionFactors, Microliter];

		concentratedBufferAmount = If[! NullQ[concentratedBuffer], transferAmount[[1]]/ConcentrationFactor,
			0 Milliliter];

		(*Solve for DiluentAmounts first transfer is cb is not Null,
		if it is,just subtract without cb*)

		firstDA =
			If[! NullQ[concentratedBuffer], finalVolume[[1]] - transferAmount[[1]] - concentratedBufferAmount,
				finalVolume[[1]] - transferAmount[[1]]];

		restDAs = Rest[finalVolume] - Rest[transferAmount];

		Which[MatchQ[varName, TransferAmounts], transferAmount,
			MatchQ[varName, DiluentAmount], Join[{firstDA},restDAs],
			MatchQ[varName, ConcentratedBufferAmount], {concentratedBufferAmount}]
	];

canCalculateFromConcentrate[myOptions : _?AssociationQ] :=
		Module[{serialDilutionFactors,finalVolume,targetConcentrations,returnBool},
			{serialDilutionFactors,finalVolume,targetConcentrations} = Lookup[myOptions,{SerialDilutionFactors, FinalVolume, TargetConcentrations}];

			returnBool = If[(MatchQ[serialDilutionFactors,Except[Automatic]]&&MatchQ[finalVolume,Except[Automatic]]) ||
					(MatchQ[targetConcentrations,Except[Automatic]]&&MatchQ[finalVolume,Except[Automatic]]),
				True,
				False
			];
			returnBool
	];

calculateFromConcentrate[varName_Symbol, ConcentrationFactor_Integer,
	myOptions : _?AssociationQ,serialDilutionFactors_,finalVolume_] :=
	Module[{transferAmount, firstConcentratedBufferAmount, restConcentratedBufferAmounts,
		concentratedBuffer,bufferDiluentAmount, concentratedBufferAmounts},

		concentratedBuffer = Lookup[myOptions, ConcentratedBuffer];

		transferAmount = UnitConvert[finalVolume/serialDilutionFactors, Microliter];

		firstConcentratedBufferAmount = If[! NullQ[concentratedBuffer], finalVolume[[1]]/ConcentrationFactor,
			0Milliliter];


		restConcentratedBufferAmounts =
			If[! NullQ[concentratedBuffer], (Rest[finalVolume]-Rest[transferAmount])/ConcentrationFactor,
				{0Milliliter}];

		concentratedBufferAmounts = UnitConvert[Join[{firstConcentratedBufferAmount},restConcentratedBufferAmounts],Microliter];

		bufferDiluentAmount = If[!NullQ[concentratedBuffer],finalVolume-transferAmount-concentratedBufferAmounts,finalVolume-transferAmount];

		Which[MatchQ[varName, TransferAmounts], transferAmount,
			MatchQ[varName, BufferDiluentAmount], bufferDiluentAmount,
			MatchQ[varName, ConcentratedBufferAmount], concentratedBufferAmounts]
	];

(*Function that multiplies each successive element of a given list*)
accMultFunction[numberList_] := Module[{intermediateList,numbersToMultiplyBy},
	numbersToMultiplyBy = Map[
		(* for every instance, take the product of all the entries of numberList up to this point *)
		Times @@ numberList[[;; (# - 1)]]&,
		(* this gives me  a list starting at 1 of whatever length we need *)
		Range[Length[numberList]]
	];
	intermediateList = numbersToMultiplyBy * numberList
];

(*helper function that takes in a list of volumes, a running total, a maximum volume,
and a running list of lists of groupings of volumes where the volumes are grouped together
if they can add up to the max but not over*)
(*function preserves order of volumes in listNums*)
(*Used to sort volumes when determining how many 200mL waste containers we need*)
(*similar to GroupByTotal in Core.m*)
groupByEdited[listNums : {VolumeP ...}, total_, max_, groupings_] :=
	Which[
		(*Base case*)
		Length[listNums] == 0, groupings,

		(*If the next volume will make you go over the max*)
		listNums[[1]] + total >= max,
		Module[{firstElem,
			nextGroupings},
			firstElem = listNums[[1]];
			nextGroupings = Append[groupings, {firstElem}];
			groupByEdited[Rest[listNums], firstElem, max, nextGroupings]
		],

		(*If the next volume will not make you go over the max*)
		listNums[[1]] + total < max,
		Module[{firstElem, updatedLastListInGroupings, droppedGroupings,
			nextGroupings},
			firstElem = listNums[[1]];
			updatedLastListInGroupings = Join[groupings[[-1]], {firstElem}];
			droppedGroupings = Drop[groupings, -1];
			nextGroupings =
				Append[droppedGroupings, updatedLastListInGroupings];
			groupByEdited[Rest[listNums], firstElem + total, max, nextGroupings]
		]
	];

Error::NoSerialDiluteFactors = "No SerialDilutionFactors or TargetConcentrations have been given, or they cannot be calculated with the given information for samples `1`.";
Error::SerialDiluteNumberErr = "These samples have a NumberOfSerialDilutions that does not correspond with SerialDilutionFactors or TargetConcentrations, `1`.";
Error::FinalVolumeErr="No FinalVolume is specified for samples `1`, please specify a FinalVolume.";
Error::TransferAmountsErr="The TransferAmounts option cannot be calculated for samples `1`. More information about SerialDilutionFactors, TargetConcentrations, and/or FinalVolume must be given.";
Error::BufferDilutionStrategyErr="The BufferDilutionStrategy is incorrect for samples `1`.";
Error::BufferDiluentAmountErr="The BufferDiluentAmount option cannot be calculated for samples `1`. More information about SerialDilutionFactors, TargetConcentrations, and/or FinalVolume must be given.";
Error::DiluentAmountErr="The DiluentAmount option cannot be calculated for samples `1`. More information about SerialDilutionFactors, TargetConcentrations, and/or FinalVolume must be given.";
Error::ConcentratedBufferAmountErr="The ConcentratedBufferAmount option cannot be calculated for samples `1`. More information about SerialDilutionFactors or TargetConcentrations, and/or FinalVolume must be given.";

Error::UnevenNumberFinalVolumeAmount="The number of given FinalVolumes does not match NumberOfSerialDilutions for samples `1`.";
Error::UnevenNumberTransferAmount="The number of given TransferAmounts does not match NumberOfSerialDilutions for samples `1`.";
Error::UnevenNumberDiluentAmount="The number of given DiluentAmount does not match NumberOfSerialDilutions for samples `1`.";
Error::UnevenNumberBufferDiluentAmount ="The number of given BufferDiluentAmount does not match NumberOfSerialDilutions for samples `1`.";
Error::UnevenNumberConcentratedBufferAmount ="The number of given ConcentratedBufferAmount does not match NumberOfSerialDilutions for samples `1`.";

Error::IncompatibleIncubateDevice = "The given Incubate device is not compatible with the following samples, `1`, and corresponding containers, `2`. Please make sure the Preparation option is correct for the given FinalVolume and/or ContainerOut.";

Error::ConflictingIncubate = "The Incubate option does not correspond to the container for the dilutions, `1`. Please re-specify the ContainerOut or Incubate options.";
Error::ConflictingIncubateTime = "The Incubation time does not correspond to the container for the dilutions `1`. Please re-specify the ContainerOut or Incubate options.";
Error::ConflictingMaxIncubateTime = "The max Incubation time does not correspond to the container for the dilutions `1`. Please re-specify the ContainerOut or Incubate options.";
Error::ConflictingIncubateTemp = "The Incubation temperature does not correspond to the container for the dilutions `1`. Please re-specify the ContainerOut or Incubate options.";


resolveExperimentSerialDiluteOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentSerialDiluteOptions]]:=Module[
	{
		outputSpecification,output,gatherTests,cache,samplePrepOptions,serialDiluteOptions,simulatedSamples,resolvedSamplePrepOptions,updatedSimulation,samplePrepTests,
		serialDiluteOptionsAssociation,invalidInputs,invalidOptions,targetContainers,
		discardedSamplePackets,discardedInvalidInputs,discardedTest,roundedSerialDiluteOptions,precisionTests,
		samplePackets,mapThreadFriendlyOptions,mwPackets,resolvedPostProcessingOptions,resolvedOptions,allTests,
		samplePrepOptionsWithMasterSwitches,samplePrepOptionsAssociation,concentratedBufferPacket,

		(*MapThread Options*)
		containerOut,destinationWells,
		resolvedContainerOutPre,

		noSerialDiluteFactorsErr,serialDiluteNumberErr,transferAmountsError,bufferDilutionStrategyError,
		bufferDiluentAmountError,concentratedBufferAmountError,diluentAmountError,

		transferNumberOfMixes, transferMixType,transferMix,

		(*Resolved Options*)
		resolvedAnalyte,resolvedSerialDilutionFactors,resolvedTargetConcentrations,resolvedNumberOfSerialDilutions,
		resolvedFinalVolume,resolvedTransferAmounts,resolvedDiluent,resolvedDiluentAmount,resolvedBufferDiluent,
		resolvedConcentratedBuffer,resolvedBufferDilutionFactor,resolvedBufferDiluentAmount,resolvedConcentratedBufferAmount,
		resolvedContainerOut,resolvedDestinationWells,

		resolvedSampleLabel,resolvedSampleContainerLabel,resolvedSampleOutLabel,transferTuples,
		resolvedContainerOutLabel,resolvedDiluentLabel,resolvedConcentratedBufferLabel,
		resolvedBufferDiluentLabel, resolvedPreparation, allowedWorkCells, resolvedWorkCell, resolvedNumberOfMixes, resolvedMixType,

		autoDestWells, flattenedPreResolvedContainersOut, flattenedPreResolvedDestinationWells, resolvedContainerOutAndWells,
		resolvedContainerOutNotGrouped, resolvedDestinationWellsNotGrouped,

		serialDiluteNumberTest,
		bufferDilutionStrategyTest,
		concentratedBufferAmountTest,

		simulation,
		concentratedBufferAmountInvalidOptions,
		bufferDilutionStrategyInvalidOptions,
		serialDiluteNumberInvalidOptions,
		couldBeMicroQ,
		methods,
		incubationTime,
		maxIncubationTime,
		incubationTemperature,

		incubateOption,incompatibleIncubateOptionErrPre,

		expandedIncubate,expandedIncubateTime,expandedMaxIncubateTime,expandedIncubateTemperature,
		incompatibleIncubateOptionErr,incompatibleIncubateInvalidOptions,
		incompatibleIncubateTest,expandedIncubateInformation,


		conflictingIncubateErr, conflictingIncubateTimeErr, conflictingIncubateMaxTimeErr,
		incubTimeRules, incubMaxTimeRules, incubTempRules,
		conflictingIncubateTimeContainers,conflictingIncubateMaxTimeContainers,

		bufferDiluentOption, concentratedBufferOption, bufferDilutionFactorOption, incubateTemperatureOption,
		incubateTimeOption,incubateMaxTimeOption,conflictingIncubateTimeInvalidOptions,
		conflictingIncubateTimeTest,conflictingMaxIncubateTimeInvalidOptions,conflictingMaxIncubateTimeTest,
		conflictingIncubateTempContainers,conflictingIncubateTempErr,conflictingIncubateTempTest,
		conflictingIncubateTempInvalidOptions,

		conflictingIncubateContainers,incubRules,conflictingIncubateInvalidOptions,conflictingIncubateTest,

		unevenNumberTransferAmountErr, unevenNumberDiluentAmountErr, unevenNumberBufferDiluentAmountErr,
		unevenNumberConcentratedBufferAmountErr, unevenNumberFinalVolumeErr,

		unevenNumberTransferAmountError, unevenNumberDiluentAmountError, unevenNumberBufferDiluentAmountError,
		unevenNumberConcentratedBufferAmountError, unevenNumberFinalVolumeError,

		unevenNumberFinalVolumeInvalidOptions,unevenNumberTransferAmountTest,
		resolvedMix, unevenNumberFinalVolumeTest,unevenNumberTransferAmountsInvalidOptions,
		unevenNumberDiluentAmountInvalidOptions,unevenNumberDiluentAmountTest,
		unevenNumberBufferDiluentAmountInvalidOptions,unevenNumberBufferDiluentAmountTest,
		unevenNumberConcentratedBufferAmountInvalidOptions,unevenNumberConcentratedBufferAmountTest,
		resolvedIncubate,sterileQ,

		listOfJustContainers, objectToNewResolvedLabelLookup, containerOutLabelReplaceRules,
		uniqueContainersOut, uniqueUserLabels, labelPrefix, sampleOutLabelReplaceRules

	},
	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)

	outputSpecification=OptionValue[Output];

	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Separate out our <Type> options from our Sample Prep options. *)
	{samplePrepOptions,serialDiluteOptions}=splitPrepOptions[myOptions];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	serialDiluteOptionsAssociation=Association[serialDiluteOptions];


	(*get BufferDiluent, ConcentratedBuffer and BufferDilutionFactor from samplePrepOptions*)
	samplePrepOptionsAssociation=Association[samplePrepOptions];

	bufferDiluentOption = samplePrepOptionsAssociation[BufferDiluent];

	concentratedBufferOption = samplePrepOptionsAssociation[ConcentratedBuffer];

	bufferDilutionFactorOption = samplePrepOptionsAssociation[BufferDilutionFactor];

	(*mixOption = samplePrepOptionsAssociation[Mix];

	mixTypeOption = samplePrepOptionsAssociation[MixType];

	numberOfMixesOption = samplePrepOptionsAssociation[NumberOfMixes];*)

	incubateOption = samplePrepOptionsAssociation[Incubate];

	incubateTemperatureOption = samplePrepOptionsAssociation[IncubationTemperature];

	incubateTimeOption = samplePrepOptionsAssociation[IncubationTime];

	incubateMaxTimeOption = samplePrepOptionsAssociation[MaxIncubationTime];

	(*set Mix->incubateOptions here in case resolveSamplePrepOptions gives us issues with Incubate & Mix being different*)
	serialDiluteOptionsAssociation=Append[serialDiluteOptionsAssociation,{BufferDiluent->bufferDiluentOption,
		ConcentratedBuffer->concentratedBufferOption,BufferDilutionFactor->bufferDilutionFactorOption,Mix->incubateOption,
	Incubate->incubateOption,IncubationTime->incubateTimeOption,
	IncubationTemperature->incubateTemperatureOption,MaxIncubationTime->incubateMaxTimeOption}];


	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamples, using our simulatedCache *)
	(* Quiet[Download[...],Download::FieldDoesntExist] *)

	samplePackets=fetchPacketFromCache[#,cache]&/@mySamples;
	mwPackets = Select[cache,KeyExistsQ[#,MolecularWeight]&];

	concentratedBufferPacket = fetchPacketFromCache[#,cache]&/@concentratedBufferOption;
	(*temporary fix for null concentratedBufferPacket, this wasn't an issue before though?*)
	(*concentratedBufferPacket = If[NullQ[concentratedBufferPacket],Table[{},Length[mySamples]]];*)


	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)
	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Select[Flatten[samplePackets], MatchQ[Lookup[#, Status], Discarded]&];

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

			passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Cache->cache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	{roundedSerialDiluteOptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[serialDiluteOptionsAssociation,{FinalVolume,TransferAmounts,DiluentAmount,BufferDiluentAmount,ConcentratedBufferAmount},{10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter},Output->{Result,Tests}],
		{RoundOptionPrecision[serialDiluteOptionsAssociation,{FinalVolume,TransferAmounts,DiluentAmount,BufferDiluentAmount,ConcentratedBufferAmount},{10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter}],Null}
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentSerialDilute,roundedSerialDiluteOptions];
	objectToNewResolvedLabelLookup = {};

	(* Check if sample is Sterile, contains cells, or require AsepticHandling *)
	(* Note:ExperimentSerialDilute does not have SterileTechnique or Sterile option yet, so we do not need to check *)
	sterileQ = Or[
		MemberQ[Lookup[samplePackets, Sterile], True],
		MemberQ[Lookup[samplePackets, Living], True],
		MemberQ[Lookup[samplePackets, CellType], CellTypeP],
		MemberQ[Lookup[samplePackets, AsepticHandling], True]
	];

	(* MapThread over each of our samples. *)
	{
		resolvedAnalyte,resolvedSerialDilutionFactors,resolvedTargetConcentrations,resolvedNumberOfSerialDilutions,
		resolvedFinalVolume,resolvedTransferAmounts,resolvedDiluent,resolvedDiluentAmount,resolvedBufferDiluent,
		resolvedConcentratedBuffer,resolvedBufferDilutionFactor,resolvedBufferDiluentAmount,resolvedConcentratedBufferAmount,
		resolvedContainerOutPre,

		resolvedSampleLabel,resolvedSampleContainerLabel, resolvedDiluentLabel,resolvedConcentratedBufferLabel,
		resolvedBufferDiluentLabel, resolvedNumberOfMixes, resolvedMixType,

		noSerialDiluteFactorsErr,serialDiluteNumberErr,transferAmountsError,bufferDilutionStrategyError,
		bufferDiluentAmountError,concentratedBufferAmountError,diluentAmountError,

		unevenNumberTransferAmountError, unevenNumberDiluentAmountError, unevenNumberBufferDiluentAmountError,
		unevenNumberConcentratedBufferAmountError, unevenNumberFinalVolumeError,

		resolvedMix

	}=Transpose@MapThread[
		Function[{mySample,mySamplePacket,myConcentratedBufferPacket,myMapThreadOptions},
			Module[

				{
					analyte,serialDilutionFactors,targetConcentrations,numberOfSerialDilutions,
					finalVolume,transferAmounts,diluent,diluentAmount,bufferDiluent,
					concentratedBuffer,bufferDilutionFactor,bufferDiluentAmount,concentratedBufferAmount,

					sampleLabel,sampleContainerLabel,diluentLabel,concentratedBufferLabel,
					bufferDiluentLabel,

					noSerialDiluteFactorsErr,serialDiluteNumberErr,transferAmountsError,bufferDilutionStrategyError,
					bufferDiluentAmountError,concentratedBufferAmountError,diluentAmountError,tooMuchVolumeError,addedVolumes,

					specifiedAnalyte,specifiedDilutionFactors,specifiedTargetConcentrations,
					specifiedNumberOfSerialDilutions,specifiedFinalVolume,
					specifiedTransferAmounts,specifiedDiluent,specifiedDiluentAmount,
					specifiedBufferDiluentAmount,specifiedConcentratedBufferAmount,
					specifiedSampleLabel,specifiedSampleContainerLabel,specifiedDiluentLabel,
					specifiedConcentratedBufferLabel,specifiedSerialDilutionFactors,specifiedBufferDilutionStrategy,
					specifiedConcentratedBuffer,specifiedBufferDiluent,

					sampleContainer, diluentObj, concetratedBufferObj, bufferDiluentObj
				},


				(* Setup our error tracking variables *)
				{
					noSerialDiluteFactorsErr,serialDiluteNumberErr,transferAmountsError,bufferDilutionStrategyError,
					bufferDiluentAmountError,concentratedBufferAmountError,diluentAmountError,tooMuchVolumeError,
					unevenNumberTransferAmountErr, unevenNumberDiluentAmountErr, unevenNumberBufferDiluentAmountErr,
					unevenNumberConcentratedBufferAmountErr, unevenNumberFinalVolumeErr
				}=ConstantArray[False,13];


				(* TODO: lookup all specified options *)
				{specifiedAnalyte,specifiedDilutionFactors,specifiedTargetConcentrations,
					specifiedNumberOfSerialDilutions,specifiedFinalVolume,
					specifiedTransferAmounts,specifiedDiluent,specifiedDiluentAmount,
				specifiedBufferDiluentAmount,specifiedConcentratedBufferAmount,
				specifiedSampleLabel,specifiedSampleContainerLabel,specifiedDiluentLabel,
				specifiedConcentratedBufferLabel,specifiedSerialDilutionFactors,specifiedBufferDilutionStrategy,
					specifiedConcentratedBuffer,specifiedBufferDiluent}= Lookup[myMapThreadOptions,
					{Analyte,BufferDilutionFactor,TargetConcentrations,NumberOfSerialDilutions,FinalVolume,
						TransferAmounts,Diluent,DiluentAmount,BufferDiluentAmount,ConcentratedBufferAmount,
					SampleLabel,SampleContainerLabel,DiluentLabel,ConcentratedBufferLabel,SerialDilutionFactors,
						BufferDilutionStrategy,ConcentratedBuffer,BufferDiluent}];


				(* Resolving Analyte option *)
				analyte=If[MatchQ[specifiedAnalyte, ObjectP[IdentityModelTypes]],
					specifiedAnalyte,
					(*Analyte is not set by the user*)

					Quiet[selectAnalyteFromSample[mySamplePacket]][[1]]
				];

				(*Resolving serialDilutionFactors and targetConcentrations*)
				serialDilutionFactors=If[MatchQ[specifiedSerialDilutionFactors,Except[Automatic]],

					(*If serialDilutionFactors is defined, return what the user defined, with possible expansion to the length at NumberOfSerialDilution if that is specified*)
					If[And[
						NumberQ[specifiedNumberOfSerialDilutions],
						!MatchQ[Length[ToList@specifiedSerialDilutionFactors],specifiedNumberOfSerialDilutions]
					],
						Flatten[ConstantArray[specifiedSerialDilutionFactors,specifiedNumberOfSerialDilutions]],
						specifiedSerialDilutionFactors
					],

					(*serialDilutionFactors is not set by the user*)
					Module[{sDF},

						(* Here, is specifiedTargetConcentrations specified by user? *)
						sDF=If[MatchQ[specifiedTargetConcentrations,Automatic] && MatchQ[specifiedNumberOfSerialDilutions,Automatic],
							Module[{},
								noSerialDiluteFactorsErr=True;
								{10}
							],

							(* If yes, then calculate serialDilutionFactors based on specifiedTargetConcentrations *)
							Module[{molecularWeightPacket,mw,density, totalVolume, composition,
								percentOrConcentration,volumePercent,massPercent,concentration, finalConcentration,
								restSerialDilutionFactors,compositionPre},
								molecularWeightPacket = First[Select[mwPackets,Lookup[#,Object]==analyte&]];
								mw = molecularWeightPacket[MolecularWeight];

								density = molecularWeightPacket[Density];

								totalVolume = mySamplePacket[Volume];

								compositionPre = mySamplePacket[Composition];
								(*get rid of any Null identity model entries in the composition*)
								composition = DeleteCases[compositionPre,{_,Null,_}];

								(*Determine if analyte already has a concentration or need to calculate from a liquid*)
								percentOrConcentration = Select[composition, #[[2]][[1]] == analyte &][[1]][[1]];

								{volumePercent,massPercent,concentration} = Which[
									(* Volume Percent *)
									MatchQ[percentOrConcentration,VolumePercentP],{Unitless[percentOrConcentration/100],Null,Null},
									(* Mass Percent *)
									MatchQ[percentOrConcentration,MassPercentP],{Null,Unitless[percentOrConcentration/100],Null},
									(* Molarity or Null *)
									True, {Null,Null,percentOrConcentration}
								];

								finalConcentration = Which[
									(*If already have the concentration, return it*)
									ConcentrationQ[concentration], UnitConvert[concentration,Molar],

									(*If we have VolumePercent, calculate the concentration and return it *)
									!NullQ[volumePercent],
									(*If not, calculate it and return the calculated*)
									Module[{analyteVolume,density,mass,preFinalConcentration},
										density = analyte[Density];
										analyteVolume = volumePercent * totalVolume;
										mass=If[
											NullQ[density],
											997 Gram/Liter*analyteVolume,
											density*analyteVolume
										];
										preFinalConcentration = mass/totalVolume;
										preFinalConcentration/mw
									],

									(*If we have MassPercent, calculate the concentration and return it *)
									!NullQ[massPercent],
									Module[{totalMass,density,analyteMass,preFinalConcentration},
										(* Assume water density for the solution *)
										density = 997 Gram/Liter;
										totalMass = totalVolume * density;
										analyteMass = massPercent * totalMass;
										preFinalConcentration = analyteMass/totalVolume;
										preFinalConcentration/mw
									],

									True, concentration
								];
								restSerialDilutionFactors = Map[Divide[specifiedTargetConcentrations[[# - 1]], specifiedTargetConcentrations[[#]]] &,
									Range[2, Length[specifiedTargetConcentrations]]];
								Join[{finalConcentration/specifiedTargetConcentrations[[1]]},restSerialDilutionFactors]
							]
							(*define serialDiluteFactors based on targetConcentrations*)
							(*getAnalyteConcentration[analyte,mySamplePacket,molecularWeightPacket]/targetConcentrations*)
						];
						sDF
					]
				];

				(*Lookup targetConcentrations*)
				targetConcentrations=If[MatchQ[specifiedTargetConcentrations,Except[Automatic]],
					(*If it is defied by the user, return it*)
					specifiedTargetConcentrations,
					(*If it is not defined by the user, get the Analyte concentration and divide it by serialDilutionFactors*)

					Module[{molecularWeightPacket,mw, density, totalVolume, composition,
						percentOrConcentration,volumePercent,massPercent,concentration, finalConcentration,dividers,compositionPre},

						(* If analyte == Null then we just want to return Null for Error catching *)
						molecularWeightPacket = If[MatchQ[analyte, Null],
							Null,
							First[Select[mwPackets,Lookup[#,Object]==analyte&]]
						];
						dividers = accMultFunction[serialDilutionFactors];

						mw = molecularWeightPacket[MolecularWeight];
						density = molecularWeightPacket[Density];
						totalVolume = mySamplePacket[Volume];
						compositionPre = mySamplePacket[Composition];
						(*get rid of any Null identity model entries in the composition*)
						composition = DeleteCases[compositionPre,{_,Null,_}];

						(*Determine if analyte already has a concentration or need to calculate from a liquid*)
						(* If analyte == Null then we just want to return Null for Error catching *)
						percentOrConcentration = If[MatchQ[analyte, Null],
							Null,
							Select[composition, #[[2]][[1]] == analyte &][[1]][[1]]
						];

						{volumePercent,massPercent,concentration} = Which[
							(* Volume Percent *)
							MatchQ[percentOrConcentration,VolumePercentP],{Unitless[percentOrConcentration/100],Null,Null},
							(* Mass Percent *)
							MatchQ[percentOrConcentration,MassPercentP],{Null,Unitless[percentOrConcentration/100],Null},
							(* Molarity or Null *)
							True, {Null,Null,percentOrConcentration}
						];

						(*Get final concentration*)
						finalConcentration = Which[
							(*If already have the concentration, return it*)
							ConcentrationQ[concentration], UnitConvert[concentration,Molar],

							(*If we have VolumePercent, calculate the concentration and return it *)
							!NullQ[volumePercent],
							Module[{analyteVolume,density,mass,preFinalConcentration},
								density = analyte[Density];
								analyteVolume = volumePercent * totalVolume;
								mass = If[
									NullQ[density],
									997 Gram/Liter*analyteVolume,
									density*analyteVolume
								];
								preFinalConcentration = mass/totalVolume;
								If[MolecularWeightQ[mw],
									(preFinalConcentration/mw),
									preFinalConcentration
								]
							],

							(*If we have MassPercent, calculate the concentration and return it *)
							!NullQ[massPercent],
							Module[{totalMass,density,analyteMass,preFinalConcentration},
								(* Assume water density for the solution *)
								density = 997 Gram/Liter;
								totalMass = totalVolume * density;
								analyteMass = massPercent * totalMass;
								preFinalConcentration = analyteMass/totalVolume;
								If[MolecularWeightQ[mw],
									(preFinalConcentration/mw),
									preFinalConcentration
								]
							],

							True, concentration
						];

						If[NullQ[finalConcentration],
							finalConcentration,
							finalConcentration/dividers
						]

					]

				];

				(*Resolving the numberOfSerialDilutions option*)
				numberOfSerialDilutions=If[MatchQ[specifiedNumberOfSerialDilutions,Except[Automatic]],
					(*If numberOfSerialDilutions is defined*)
					If[(specifiedNumberOfSerialDilutions==Length[serialDilutionFactors]
						||specifiedNumberOfSerialDilutions==Length[targetConcentrations]),
						specifiedNumberOfSerialDilutions,

						(
							If[Length[serialDilutionFactors]>1&&Length[serialDilutionFactors]!=specifiedNumberOfSerialDilutions,
								(*in this case, theres more than one serialDilutionFactor and it mismatches the number of serial dilutions, throw an error*)
								(*need the specified serialDilutionFactors to be length of 1 to expand it properly (i.e. what does it mean to expand {10,11} to be length of 4 if numberOfSerialDilutions=4?)*)
								serialDiluteNumberErr=True;
								Length[serialDilutionFactors],

								(*if it passes all of these, i.e. lengths of both are 1 and they both don't match, expand both*)
								Module[{serialDilutionFactor,targetConcentration,serialDilutionFactorsMultiplied},

									serialDilutionFactor=serialDilutionFactors[[1]];
									targetConcentration=targetConcentrations[[1]];
									serialDilutionFactors=Table[serialDilutionFactor,specifiedNumberOfSerialDilutions];

									serialDilutionFactorsMultiplied=accMultFunction[Rest[serialDilutionFactors]];

									targetConcentrations=Join[{targetConcentration},targetConcentration/serialDilutionFactorsMultiplied];
									specifiedNumberOfSerialDilutions
								]

							]
						)
					],
					(*If numberOfSerialDilutions is not defined*)
					Length[serialDilutionFactors]
				];


				(*resolving bufferDilutionFactor*)
				bufferDilutionFactor = If[MatchQ[specifiedDilutionFactors,Except[Automatic]],
					(*if yes, set to user specified*)
					specifiedDilutionFactors,
					10
				];


				(*Resolving the FinalVolume option*)
				finalVolume=If[MatchQ[specifiedFinalVolume,Except[Automatic]],
					(*if it is set by the user, check if it is matching the number of serial dilutions*)
					If[Length[specifiedFinalVolume]!=numberOfSerialDilutions,
						Which[MatchQ[Length[specifiedFinalVolume],1],
							Module[{finalVolumeSingle},
								finalVolumeSingle = specifiedFinalVolume[[1]];
								Table[finalVolumeSingle,numberOfSerialDilutions]
							],
							Length[specifiedFinalVolume]>1&&DuplicateFreeQ[specifiedFinalVolume],
							Module[{finalVolumeSingle},
								finalVolumeSingle = specifiedFinalVolume[[1]];
								Table[finalVolumeSingle,numberOfSerialDilutions]
							],
							True,
							Module[{},
								unevenNumberFinalVolumeErr=True;
								Table[100Microliter,numberOfSerialDilutions]
							]
						],
						specifiedFinalVolume
					],
					(*if not, throw an error - it is required*)
					Module[{},
						Table[100Microliter,numberOfSerialDilutions]
					]
				];


				(*Resolving the transferAmounts option, similar to above*)
				transferAmounts=If[MatchQ[specifiedTransferAmounts,Except[Automatic]],
					(*if it is set by the user, check if it is matching the number of serial dilutions*)
					If[Length[specifiedTransferAmounts]!=numberOfSerialDilutions,
						Module[{},
							unevenNumberTransferAmountErr=True;
							{10Microliter}
						],
						specifiedTransferAmounts
					],

					(*if it is not set by the user*)
					If[MatchQ[specifiedBufferDilutionStrategy,Direct],
						calculateDirect[TransferAmounts,bufferDilutionFactor,Association[ReplaceRule[Normal[myMapThreadOptions],FinalVolume->finalVolume]],serialDilutionFactors,finalVolume],
						calculateFromConcentrate[TransferAmounts,bufferDilutionFactor,Association[ReplaceRule[Normal[myMapThreadOptions],FinalVolume->finalVolume]],serialDilutionFactors,finalVolume]
					]
				];

				(*Going into whether BDS is Direct or not*)
				If[MatchQ[specifiedBufferDilutionStrategy,Direct],

					(*bufferDilutionStrategy is Direct*)
					Module[{},


						(*resolving Diluent*)
						diluent=If[MatchQ[specifiedDiluent,Except[Automatic]],
							(*if Diluent is defined, return it*)
							specifiedDiluent,
							(*if not, see whether SamplesIn[Solvent] is populated*)
							(*this is downloading,mySamplePacket come back and just get from mySample packet*)
							If[!NullQ[Lookup[mySamplePacket,Solvent]],
								Download[Lookup[mySamplePacket,Solvent], Object],
								Model[Sample,"Milli-Q water"]
							]
						];

						(*Resolving DiluentAmount*)
						diluentAmount=If[MatchQ[specifiedDiluentAmount,Except[Automatic]],
							(*if DiluentAmount is defined, return it*)
							If[Length[specifiedDiluentAmount]!=numberOfSerialDilutions,
								Module[{},
									unevenNumberDiluentAmountErr=True;
									Table[90Microliter,numberOfSerialDilutions]
								],
								specifiedDiluentAmount
							],

							(*if not, calculated with BDS=Dilute*)
							calculateDirect[DiluentAmount,bufferDilutionFactor,Association[ReplaceRule[Normal[myMapThreadOptions],FinalVolume->finalVolume]],serialDilutionFactors,finalVolume]
						];

						(*Resolving bufferDiluent*)
						bufferDiluent=If[MatchQ[specifiedBufferDiluent,Except[Null]],
							(*if bufferDiluent is defined, make error=true*)
							Module[{},
								bufferDilutionStrategyError=True;
								Null
							],
							(*if not, set to Null anyway*)
							Null
						];

						(*Resolving ConcentratedBuffer*)
						concentratedBuffer=If[MatchQ[specifiedConcentratedBuffer,Except[Null]],
							(*if concentratedBuffer is defined, return what is user defined*)
							specifiedConcentratedBuffer,
							(*if not, set to Null*)
							Null
						];
						(* We allow Automatic or 0 uL here because we may in a subprotocol of MSP and resolved to Table[0Microliter,xxx] earlier. We should not try to error out on something we resolved to. Other than that, we throw hard error *)
						bufferDiluentAmount = If[MatchQ[specifiedBufferDiluentAmount,Except[(Automatic|Table[0Microliter,numberOfSerialDilutions])]],
							Module[{},
								bufferDilutionStrategyError=True;
								Table[0Microliter,numberOfSerialDilutions]
							],
							Table[0Microliter,numberOfSerialDilutions]
						];

						(*resolving ConcentratedBufferAmount*)
						concentratedBufferAmount = If[MatchQ[specifiedConcentratedBufferAmount,Except[Automatic]],
							specifiedConcentratedBufferAmount,
							If[NullQ[concentratedBuffer],
								Table[0Microliter,numberOfSerialDilutions],
								calculateDirect[ConcentratedBufferAmount,bufferDilutionFactor,Association[ReplaceRule[Normal[myMapThreadOptions],FinalVolume->finalVolume]],serialDilutionFactors,finalVolume]
							]
						];

					],


					(*going into the FromConcentrate branch*)
					Module[{},

						(*Resolving diluent*)
						(* We allow Automatic or Null here because we may in a subprotocol of MSP and resolved to Null earlier. We should not try to error out on something we resolved to. Other than that, we throw hard error *)
						diluent = If[MatchQ[specifiedDiluent,Except[(Automatic|Null)]],
							Module[{},
								bufferDilutionStrategyError=True;
								Null
							],
							Null
						];

						(*Resolving DiluentAmount*)
						(* We allow Automatic or 0 uL here because we may in a subprotocol of MSP and resolved to Table[0Microliter,xxx] earlier. We should not try to error out on something we resolved to. Other than that, we throw hard error *)
						diluentAmount=If[MatchQ[specifiedDiluentAmount,Except[(Automatic|Table[0Microliter,numberOfSerialDilutions])]],
							Module[{},
								bufferDilutionStrategyError=True;
								Table[0Microliter,numberOfSerialDilutions]
							],
							Table[0Microliter,numberOfSerialDilutions]
						];

						(*Resolving ConcentratedBuffer*)
						concentratedBuffer = If[MatchQ[specifiedConcentratedBuffer,Except[Null]],
							specifiedConcentratedBuffer,
							Null
						];

						(*Resolving BufferDiluent*)
						bufferDiluent = If[MatchQ[specifiedBufferDiluent,Except[Null]],
							specifiedBufferDiluent,
							If[NullQ[concentratedBuffer],
								Model[Sample,"Milli-Q water"],
								If[!NullQ[Lookup[myConcentratedBufferPacket,Solvent]],
									Lookup[myConcentratedBufferPacket,Solvent],
									Model[Sample,"Milli-Q water"]
								]
							]
						];


						(*resolving BufferDiluentAmount*)
						bufferDiluentAmount = If[MatchQ[specifiedBufferDiluentAmount,Except[Automatic]],

							If[Length[specifiedBufferDiluentAmount]!=numberOfSerialDilutions,
								Module[{},
									unevenNumberBufferDiluentAmountErr=True;
									Table[0.1Milliliter,numberOfSerialDilutions]
								],
								specifiedBufferDiluentAmount
							],

							calculateFromConcentrate[BufferDiluentAmount,bufferDilutionFactor,Association[ReplaceRule[Normal[myMapThreadOptions],FinalVolume->finalVolume]],serialDilutionFactors,finalVolume]

						];

						(*resolving ConcentratedBufferAmount*)
						concentratedBufferAmount = If[MatchQ[specifiedConcentratedBufferAmount,Except[Automatic]],

							If[Length[specifiedConcentratedBufferAmount]!=numberOfSerialDilutions,
								Module[{},
									unevenNumberConcentratedBufferAmountErr=True;
									{0.1Milliliter}
								],
								specifiedConcentratedBufferAmount
							],

							If[NullQ[concentratedBuffer],
								{0Milliliter},
								calculateFromConcentrate[ConcentratedBufferAmount,bufferDilutionFactor,Association[ReplaceRule[Normal[myMapThreadOptions],FinalVolume->finalVolume]],serialDilutionFactors,finalVolume]
							]
						];
					]
				];

				(* lookup DestinationWells option *)
				destinationWells = Lookup[myMapThreadOptions,DestinationWells];

				(*resolving containerOut*)
				(*want to do this for every finalVolume + transferAmounts*)
				addedVolumes = finalVolume;

				containerOut = If[MatchQ[Lookup[myMapThreadOptions,ContainerOut],Except[Automatic]],
					(*If containerOut is defined, return what the user defined*)
					Module[{specifiedContainerOut},
						specifiedContainerOut = Lookup[myMapThreadOptions,ContainerOut];
						(* If what the user specified matches the required length of NumberOfSerialDilutions, use it, otherwise constant array it. If it's not a singleton for constant arraying, we would have mismatched length error thrown already *)
						If[MatchQ[Length[ToList@specifiedContainerOut],numberOfSerialDilutions],
							specifiedContainerOut,
							Flatten[ConstantArray[specifiedContainerOut,numberOfSerialDilutions],1]
						]
					],
					(*If not, map over each addedVolume to get a containerOut for each sampleout*)

					(*containerOut is not user defined*)
					If[MatchQ[Lookup[myMapThreadOptions,DestinationWells],Except[Automatic]],
						(*go through each destinationWell since it is user defined*)
						MapThread[
							Function[{destWell,addedVolume},
								(*If it is, is it A1?*)
								If[destWell=="A1",
									(*If it is, is finalVolume+transferAmounts>1.9mL?*)
									If[addedVolume>1.9Milliliter,
										PreferredContainer[addedVolume, Sterile -> sterileQ],
										PreferredContainer[addedVolume, Sterile -> sterileQ, Type->Plate]
									],
									(*If it's not, use PreferredContainer, Type->Plate*)
									PreferredContainer[addedVolume,Sterile -> sterileQ, Type->Plate]
								]
							],
							{destinationWells,addedVolumes}
						],

						(*if destinationWells is not user defined*)
						MapThread[
							Function[{addedVolume},
								If[addedVolume>1.9Milliliter,
									PreferredContainer[addedVolume, Sterile -> sterileQ],
									PreferredContainer[addedVolume, Sterile -> sterileQ, Type -> Plate]
								]
							],
							{addedVolumes}
						]
					]
				];


				sampleLabel = Which[
					MatchQ[Lookup[myMapThreadOptions, SourceLabel], Except[Automatic]],
					Lookup[myMapThreadOptions, SourceLabel],

					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[mySample, Object]], _String],
					LookupObjectLabel[simulation, Download[mySample, Object]],

					KeyExistsQ[objectToNewResolvedLabelLookup, mySample],
					Lookup[objectToNewResolvedLabelLookup, mySample],

					True,
					Module[{newLabel},
						newLabel=CreateUniqueLabel["serial dilute source sample"];

						AppendTo[objectToNewResolvedLabelLookup, mySample->newLabel];

						newLabel
					]
				];

				sampleContainer = Download[Lookup[mySamplePacket,Container],Object];
				sampleContainerLabel = Which[
					MatchQ[Lookup[myMapThreadOptions, SourceContainerLabel], Except[Automatic]],
					Lookup[myMapThreadOptions, SourceContainerLabel],

					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[sampleContainer, Object]], _String],
					LookupObjectLabel[simulation, Download[sampleContainer, Object]],

					KeyExistsQ[objectToNewResolvedLabelLookup, sampleContainer],
					Lookup[objectToNewResolvedLabelLookup, sampleContainer],

					True,
					Module[{newLabel},
						newLabel=CreateUniqueLabel["serial dilute source sample container"];

						AppendTo[objectToNewResolvedLabelLookup, sampleContainer->newLabel];

						newLabel
					]
				];

				diluentObj = Download[diluent,Object];
				diluentLabel = Which[
					NullQ[diluentObj],Null,

					MatchQ[Lookup[myMapThreadOptions, DiluentLabel], Except[Automatic]],
					Lookup[myMapThreadOptions, DiluentLabel],

					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[diluentObj, Object]], _String],
					LookupObjectLabel[simulation, Download[diluentObj, Object]],

					KeyExistsQ[objectToNewResolvedLabelLookup, diluentObj],
					Lookup[objectToNewResolvedLabelLookup, diluentObj],

					True,
					Module[{newLabel},
						newLabel=CreateUniqueLabel["serial dilute diluent"];

						AppendTo[objectToNewResolvedLabelLookup, diluentObj->newLabel];

						newLabel
					]
				];

				concetratedBufferObj = Download[concentratedBuffer,Object];
				concentratedBufferLabel = Which[
					NullQ[concetratedBufferObj],Null,

					MatchQ[Lookup[myMapThreadOptions, ConcentratedBufferLabel], Except[Automatic]],
					Lookup[myMapThreadOptions, ConcentratedBufferLabel],

					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[concetratedBufferObj, Object]], _String],
					LookupObjectLabel[simulation, Download[concetratedBufferObj, Object]],

					KeyExistsQ[objectToNewResolvedLabelLookup, concetratedBufferObj],
					Lookup[objectToNewResolvedLabelLookup, concetratedBufferObj],

					True,
					Module[{newLabel},
						newLabel=CreateUniqueLabel["serial dilute concentrated buffer"];

						AppendTo[objectToNewResolvedLabelLookup, concetratedBufferObj->newLabel];

						newLabel
					]
				];

				bufferDiluentObj = Download[bufferDiluent,Object];
				bufferDiluentLabel = Which[
					NullQ[bufferDiluentObj],Null,

					MatchQ[Lookup[myMapThreadOptions, BufferDiluentLabel], Except[Automatic]],
					Lookup[myMapThreadOptions, BufferDiluentLabel],

					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[bufferDiluentObj, Object]], _String],
					LookupObjectLabel[simulation, Download[bufferDiluentObj, Object]],

					KeyExistsQ[objectToNewResolvedLabelLookup, bufferDiluentObj],
					Lookup[objectToNewResolvedLabelLookup, bufferDiluentObj],

					True,
					Module[{newLabel},
						newLabel=CreateUniqueLabel["serial dilute buffer diluent"];

						AppendTo[objectToNewResolvedLabelLookup, bufferDiluentObj->newLabel];

						newLabel
					]
				];


				(*Resolve transferMix*)
				transferMix= If[MatchQ[Lookup[myMapThreadOptions,TransferMix],Except[Automatic]],
					(*if it's set by the user*)
					Lookup[myMapThreadOptions,TransferMix],
					(*if not, automatically set it to True*)
					True
				];

				(*Resolve numberOfMixes*)
				transferNumberOfMixes= If[MatchQ[Lookup[myMapThreadOptions,TransferNumberOfMixes],Except[Automatic]],
					(*if it's set by the user*)
					If[MatchQ[Lookup[myMapThreadOptions,TransferMix],True],
						(*if we even want Mixing on*)
						Lookup[myMapThreadOptions,TransferNumberOfMixes],
						(*If we don't want mixing, set it to Null*)
						Null
					],
					(*if it's not set by the user*)
					If[MatchQ[Lookup[myMapThreadOptions,TransferMix],True],
						(*if we want mixing, resolve it by volume*)
						20,
						(*don't want mixing, set to Null*)
						Null
					]
				];

				(*Resolve mixType*)
				transferMixType= If[MatchQ[Lookup[myMapThreadOptions,TransferMixType],Except[Automatic]],
					(*if it's set by the user*)
					If[MatchQ[Lookup[myMapThreadOptions,TransferMix],True],
						(*if we even want Mixing on*)
						Lookup[myMapThreadOptions,TransferMixType],
						(*If we don't want mixing, set it to Null*)
						Null
					],
					(*if it's not set by the user*)
					If[MatchQ[Lookup[myMapThreadOptions,TransferMix],True],
						(*if we want mixing, resolve it by volume*)
						Module[{largestVol},
							largestVol = Max[finalVolume];
							If[largestVol>1.9Milliliter,
								Swirl,
								Pipette
							]
						],
						(*don't want mixing, set to Null*)
						Null
					]
				];

				(* Gather MapThread results *)
				{
					analyte,serialDilutionFactors,targetConcentrations,numberOfSerialDilutions,
					finalVolume,transferAmounts,diluent,diluentAmount,bufferDiluent,
					concentratedBuffer,bufferDilutionFactor,bufferDiluentAmount,concentratedBufferAmount,
					containerOut,

					sampleLabel,sampleContainerLabel,diluentLabel,concentratedBufferLabel,
					bufferDiluentLabel,transferNumberOfMixes,transferMixType,

					noSerialDiluteFactorsErr,serialDiluteNumberErr,transferAmountsError,bufferDilutionStrategyError,
					bufferDiluentAmountError,concentratedBufferAmountError,diluentAmountError,

					unevenNumberTransferAmountErr, unevenNumberDiluentAmountErr, unevenNumberBufferDiluentAmountErr,
					unevenNumberConcentratedBufferAmountErr, unevenNumberFinalVolumeErr,

					transferMix

				}

			]
		],
		{mySamples,samplePackets,concentratedBufferPacket,mapThreadFriendlyOptions}
	];


	destinationWells = Lookup[serialDiluteOptionsAssociation,DestinationWells];

	resolvedContainerOutPre =Map[
		Function[{listOfModels},
			(* If we already have index, do not try to add another index. Keep the existing index *)
			If[MatchQ[#,{_Integer|Automatic,ObjectP[Model[Container]]}],
				#,
				{Automatic, #}
			]& /@ listOfModels
		],
		resolvedContainerOutPre
	];

	(*temporary fix if destWells is just Automatic, but this was working fine before too?*)
	(*destinationWells = If[MatchQ[destinationWells,Automatic],{Automatic}];*)

	(*expand destWells such that each sampleIn has the same number of destWells as resolvedContainerOut for that sample*)
	autoDestWells = MapThread[
		Function[{destWell, resCP},
			If[MatchQ[destWell, Automatic],
				Table[Automatic, Length[resCP]],
				destWell
			]
		],
		{destinationWells, resolvedContainerOutPre}
	];

	(*Do what Steven showed for groupContainersOut*)
	(*1. Flatten the resolvedContainerOutPre inner list*)
	flattenedPreResolvedContainersOut = Join @@ resolvedContainerOutPre;

	(*2. Completely flatten autoDestWells*)
	flattenedPreResolvedDestinationWells = Join @@ autoDestWells;

	(*3. Call groupContainersOut on the two flattened lists*)
	resolvedContainerOutAndWells = groupContainersOut[cache,
		flattenedPreResolvedContainersOut,
		DestinationWell->flattenedPreResolvedDestinationWells];


	(*4. Group the resolvedContainerOut and resolvedDestinationWells by lengths of resolvedContainerOutPre*)
	resolvedContainerOutNotGrouped = resolvedContainerOutAndWells[[1]];
	resolvedDestinationWellsNotGrouped = resolvedContainerOutAndWells[[2]];

	resolvedContainerOut = TakeList[resolvedContainerOutNotGrouped, Length /@ resolvedContainerOutPre];
	resolvedDestinationWells =
     If[MatchQ[destinationWells,Table[Automatic,Length[mySamples]]],
		 (*if destinationWells is not user defined, take the resolved wells from groupContainersOut*)
		 TakeList[resolvedDestinationWellsNotGrouped, Length /@ autoDestWells],
		 (*if it was user defined, take autoDestWells, should be the same*)
		 autoDestWells
	 ];
	(* get the unique containers*)
	uniqueContainersOut = DeleteDuplicates[Flatten[resolvedContainerOut, 1]] /. obj : ObjectReferenceP[] :> Download[obj, Object];
	(* get the unique strings in user input*)
	uniqueUserLabels = DeleteDuplicates[DeleteCases[Flatten@Lookup[myOptions, ContainerOutLabel], Automatic | Null]];
	(*If the specified sample container labels is one string, use it as a label prefix, otherwise use "serial dilute container out" as prefix*)
	labelPrefix = If[MatchQ[Length@uniqueUserLabels, 1],
		FirstCase[uniqueUserLabels, _String, "serial dilute container out"],
		"serial dilute container out"];

	(* make labels for the resolved containers out*)
	containerOutLabelReplaceRules = If[MatchQ[Length[uniqueContainersOut], Length[uniqueUserLabels]],
		(* If we were given matching length of containers to labels, mapthread it *)
		MapThread[
			Function[{container,label},
				container -> label
			],
			{uniqueContainersOut, uniqueUserLabels}
		],
		(* Otherwise map through unique containers out *)
		Map[
			Function[uniqueContainer,
				Which[
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Last[uniqueContainer]], _String],
					(uniqueContainer -> LookupObjectLabel[simulation, Last[uniqueContainer]]),
					(* If we are only called by resolveSerialDiluteMethod, we don't care about this label here. We should make sure we don't use CreateUniqueLabel and increase the counter *)
					MatchQ[Lookup[serialDiluteOptionsAssociation, ResolveMethod, False], True],
					(uniqueContainer -> CreateUUID[]),
					True,
					(uniqueContainer -> CreateUniqueLabel[labelPrefix])
				]
			],
			uniqueContainersOut
		]
	];

	resolvedContainerOutLabel = MapThread[
		Function[{containerOut, containerOutLabel},

			If[And[
					Not[MatchQ[containerOutLabel, Automatic]],
					MatchQ[Length[ToList@containerOutLabel],Length[ToList@containerOut]]
				],
				(*If the label is given and it matches the container out length, use directly*)
				containerOutLabel,
				(* Otherwise use the lookup *)
				containerOut /. containerOutLabelReplaceRules
			]
		],
		{resolvedContainerOut, Lookup[myOptions, ContainerOutLabel]}
	];


	(* make labels for the things that will become the SamplesOut *)
	sampleOutLabelReplaceRules = Map[
		# -> CreateUniqueLabel["serial dilute sample out"]&,
		DeleteDuplicates[Transpose[{Flatten@resolvedContainerOutLabel, Flatten@resolvedDestinationWells}]]
	];
	resolvedSampleOutLabel = MapThread[
		If[Not[MatchQ[#1, Automatic]],
			#1,
			Transpose[{#2, #3}] /. sampleOutLabelReplaceRules
		]&,
		{Lookup[myOptions, SampleOutLabel], resolvedContainerOutLabel, resolvedDestinationWells}
	];

	(*resolving independent options*)
	(*resolving prep option*)
	(*make sure we consider both mySamples and diluent if needed*)
	transferTuples=Transpose[
		MapThread[
			If[MatchQ[#2,ObjectP[{Object[Container],Object[Sample]}]],
				{
					Join[ConstantArray[#1,Length[#3]],ConstantArray[#2,Length[#3]]],
					Flatten[ConstantArray[DeleteCases[Flatten[#3],_Integer],2]],
					Join[ConstantArray[#4,Length[#3]],ConstantArray[#5,Length[#3]]],
					Flatten[ConstantArray[#6,2]]
				},
				{
					ConstantArray[#1,Length[#3]],
					DeleteCases[Flatten[#3],_Integer],
					ConstantArray[#4,Length[#3]],
					Flatten[#6]
				}
			]&,
			{mySamples,resolvedDiluent,resolvedContainerOut,resolvedFinalVolume,resolvedDiluentAmount,resolvedDestinationWells}
		]
	];

	methods = resolveTransferMethod[Flatten[transferTuples[[1]]], Flatten[transferTuples[[2]]], Flatten[transferTuples[[3]]],
		DestinationWell -> Flatten[transferTuples[[4]]],Simulation->simulation,Cache->cache];

	couldBeMicroQ = MemberQ[methods, Robotic];

	(* resolve the Preparation option *)
	resolvedPreparation = Which[
		Not[MatchQ[Lookup[serialDiluteOptionsAssociation, Preparation], Automatic]], Lookup[serialDiluteOptionsAssociation, Preparation],
		couldBeMicroQ, Robotic,
		True, Manual
	];

	(* Resolve the work cell that we're going to operator on. *)
	allowedWorkCells = resolveSerialDiluteWorkCell[Flatten[mySamples], {Preparation -> resolvedPreparation, Simulation -> simulation, Cache -> cache, Output -> Result}];

	resolvedWorkCell = FirstOrDefault[allowedWorkCells];

	(*Resolve doing right preparation on resolved containers*)
	resolvedIncubate = Lookup[serialDiluteOptionsAssociation,Incubate];

	(*Determine if any of the resolvedContainerOut are plates, if so, then put True, if not, then False*)
	listOfJustContainers = Map[Function[{subList}, Map[#[[2]] &, subList]], resolvedContainerOut];

	(*Reduce is such that it's an And for each sublist, i.e. {True,False,True}->{False}*)
	(*If there is a False, then that means at least one resolvedContainerOut in that serial dilution of that samples
	must be a non-plate*)
	incompatibleIncubateOptionErrPre =Map[
		Function[containerSubList,
			Not[MemberQ[containerSubList,Except[ObjectP[{Object[Container,Plate],Model[Container,Plate]}]]]]
		],
		listOfJustContainers
	];

	(*Double check with Incubate and resolvedPrep*)
	(*If resolvedPrep=Robotic and resolvedIncubate=True and incompatibleIncubateOptionErrPre = False,
	make the error true*)
	incompatibleIncubateOptionErr = MapThread[
		Function[{incubateBool,incompatibleIncubatePre},
			If[MatchQ[resolvedPreparation,Robotic],

				Which[
					(*if not incubating and only have plates, it's okay, no error raised*)
					MatchQ[incubateBool,False]&&MatchQ[incompatibleIncubatePre,True],
					False,

					(*if incubating but only have plates, it's okay, no error raised*)
					MatchQ[incubateBool,True]&&MatchQ[incompatibleIncubatePre,True],
					False,

					(*if incubating and have non-plates, not okay, raise error*)
					MatchQ[incubateBool,True]&&MatchQ[incompatibleIncubatePre,False],
					True,

					(*both are False, it's okay*)
					True,
					False
				],
				(*If get to here, prep is Manual so it's all fine*)
				False
			]
		],
		{resolvedIncubate,incompatibleIncubateOptionErrPre}
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(*----- START HERE -----*)
	(*check for any samples that haven't been given serialDilutionFactors or TargetConcentrations - NoSerialDiluteFactorsErr*)
	incompatibleIncubateInvalidOptions=If[Or@@incompatibleIncubateOptionErr&&!gatherTests,
		Module[{incompatibleIncubateInvalidSamples,incompatibleIncubateInvalidContainersOut},
			(* Get the samples that correspond to this error. *)
			incompatibleIncubateInvalidSamples=PickList[mySamples,incompatibleIncubateOptionErr];
			incompatibleIncubateInvalidContainersOut=PickList[resolvedContainerOut,incompatibleIncubateOptionErr];
			(* Throw the corresopnding error. *)
			Message[Error::IncompatibleIncubateDevice,
				ObjectToString[incompatibleIncubateInvalidSamples, Cache -> cache],
					ObjectToString[incompatibleIncubateInvalidContainersOut, Cache -> cache]
			];

			(* Return our invalid options. *)
			{Incubate,ContainerOut}
		],
		{}
	];

	(* Create the corresponding test for the noSerialDilutionFactors error. *)
	incompatibleIncubateTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingIncubateInputs,passingIncubateInputs,passingIncubateContainersOut,failingIncubateContainersOut,
			failingInputTest,passingInputsTest},
			(* Get the inputs that fail this test. *)
			failingIncubateInputs=PickList[mySamples,incompatibleIncubateOptionErr];
			failingIncubateContainersOut = PickList[resolvedContainerOut,incompatibleIncubateOptionErr];

			(* Get the inputs that pass this test. *)
			passingIncubateInputs=PickList[mySamples,incompatibleIncubateOptionErr,False];
			passingIncubateContainersOut = PickList[resolvedContainerOut,incompatibleIncubateOptionErr,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingIncubateInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingIncubateInputs,Cache->cache]<>" and their
				corresponding ContainerOut, "<>ObjectToString[failingIncubateContainersOut,Cache->cache]<>" have
				compatible Incubate options set.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingIncubateInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingIncubateInputs,Cache->cache]<>" and their
				corresponding ContainerOut, "<>ObjectToString[passingIncubateContainersOut,Cache->cache]<>" have
				compatible Incubate options set.",True,True],
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

	(*check for any samples whose FinalVolumes are not index-matched properly to inner lists*)
	unevenNumberFinalVolumeInvalidOptions=If[Or@@unevenNumberFinalVolumeError&&!gatherTests,
		Module[{unevenNumberFinalVolumeInvalidSamples},
			(* Get the samples that correspond to this error. *)
			unevenNumberFinalVolumeInvalidSamples=PickList[mySamples,unevenNumberFinalVolumeError];

			(* Throw the corresopnding error. *)
			Message[Error::UnevenNumberFinalVolumeAmount,ObjectToString[unevenNumberFinalVolumeInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{FinalVolume}
		],
		{}
	];


	(* Create the corresponding test for the noSerialDilutionFactors error. *)
	unevenNumberFinalVolumeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,unevenNumberFinalVolumeError];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,unevenNumberFinalVolumeError,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have the correct number of FinalVolumes specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have the correct number of FinalVolumes specified.",True,True],
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

	(*check for any samples whose TransferAmounts are not index-matched properly to inner lists*)
	unevenNumberTransferAmountsInvalidOptions=If[Or@@unevenNumberTransferAmountError&&!gatherTests,
		Module[{unevenNumberTransferAmountInvalidSamples},
			(* Get the samples that correspond to this error. *)
			unevenNumberTransferAmountInvalidSamples=PickList[mySamples,unevenNumberTransferAmountError];

			(* Throw the corresopnding error. *)
			Message[Error::UnevenNumberTransferAmount,ObjectToString[unevenNumberTransferAmountInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{TransferAmounts}
		],
		{}
	];


	(* Create the corresponding test for the noSerialDilutionFactors error. *)
	unevenNumberTransferAmountTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,unevenNumberTransferAmountError];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,unevenNumberTransferAmountError,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have the correct number of TransferAmounts specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have the correct number of TransferAmounts specified.",True,True],
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

	(*check for any samples whose DiluentAmount are not index-matched properly to inner lists*)
	unevenNumberDiluentAmountInvalidOptions=If[Or@@unevenNumberDiluentAmountError&&!gatherTests,
		Module[{unevenNumberDiluentAmountInvalidSamples},
			(* Get the samples that correspond to this error. *)
			unevenNumberDiluentAmountInvalidSamples=PickList[mySamples,unevenNumberDiluentAmountError];

			(* Throw the corresopnding error. *)
			Message[Error::UnevenNumberDiluentAmount,ObjectToString[unevenNumberDiluentAmountInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{DiluentAmount}
		],
		{}
	];


	(* Create the corresponding test for the noSerialDilutionFactors error. *)
	unevenNumberDiluentAmountTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,unevenNumberDiluentAmountError];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,unevenNumberDiluentAmountError,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have the correct number of DiluentAmounts specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have the correct number of DiluentAmounts specified.",True,True],
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

	(*check for any samples whose BufferDiluentAmount are not index-matched properly to inner lists*)
	unevenNumberBufferDiluentAmountInvalidOptions=If[Or@@unevenNumberBufferDiluentAmountError&&!gatherTests,
		Module[{unevenNumberBufferDiluentAmountInvalidSamples},
			(* Get the samples that correspond to this error. *)
			unevenNumberBufferDiluentAmountInvalidSamples=PickList[mySamples,unevenNumberBufferDiluentAmountError];

			(* Throw the corresopnding error. *)
			Message[Error::UnevenNumberBufferDiluentAmount,ObjectToString[unevenNumberBufferDiluentAmountInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{BufferDiluentAmount}
		],
		{}
	];


	(* Create the corresponding test for the noSerialDilutionFactors error. *)
	unevenNumberBufferDiluentAmountTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,unevenNumberBufferDiluentAmountError];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,unevenNumberBufferDiluentAmountError,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have the correct number of BufferDiluentAmounts specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have the correct number of BufferDiluentAmounts specified.",True,True],
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

	(*check for any samples whose ConcentratedBufferAmount are not index-matched properly to inner lists*)
	unevenNumberConcentratedBufferAmountInvalidOptions=If[Or@@unevenNumberConcentratedBufferAmountError&&!gatherTests,
		Module[{unevenNumberConcentratedBufferAmountInvalidSamples},
			(* Get the samples that correspond to this error. *)
			unevenNumberConcentratedBufferAmountInvalidSamples=PickList[mySamples,unevenNumberConcentratedBufferAmountError];

			(* Throw the corresopnding error. *)
			Message[Error::UnevenNumberConcentratedBufferAmount,ObjectToString[unevenNumberConcentratedBufferAmountInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{ConcentratedBufferAmount}
		],
		{}
	];


	(* Create the corresponding test for the noSerialDilutionFactors error. *)
	unevenNumberConcentratedBufferAmountTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,unevenNumberConcentratedBufferAmountError];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,unevenNumberConcentratedBufferAmountError,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have the correct number of ConcentratedBufferAmounts specified.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have the correct number of ConcentratedBufferAmounts specified.",True,True],
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

	(*----- serialDiluteNumberErr -----*)
	serialDiluteNumberInvalidOptions=If[Or@@serialDiluteNumberErr&&!gatherTests,
		Module[{serialDiluteNumberInvalidSamples},
			(* Get the samples that correspond to this error. *)
			serialDiluteNumberInvalidSamples=PickList[mySamples,serialDiluteNumberErr];

			(* Throw the corresopnding error. *)
			Message[Error::SerialDiluteNumberErr,ObjectToString[serialDiluteNumberInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{NumberOfSerialDilutions}
		],
		{}
	];


	(* Create the corresponding test for the invalid thaw instrument error. *)
	serialDiluteNumberTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,serialDiluteNumberErr];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,serialDiluteNumberErr,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have a matching number of serial dilutions.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have a matching number of serial dilutions.",True,True],
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

	(*------ bufferDilutionStrategyError ------*)
	bufferDilutionStrategyInvalidOptions=If[Or@@bufferDilutionStrategyError&&!gatherTests,
		Module[{bufferDilutionStrategyInvalidSamples},
			(* Get the samples that correspond to this error. *)
			bufferDilutionStrategyInvalidSamples=PickList[mySamples,bufferDilutionStrategyError];

			(* Throw the corresopnding error. *)
			Message[Error::BufferDilutionStrategyErr,ObjectToString[bufferDilutionStrategyInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{BufferDilutionStrategy}
		],
		{}
	];


	(* Create the corresponding test for the bufferDilutionStrategyErr. *)
	bufferDilutionStrategyTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,bufferDilutionStrategyError];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,bufferDilutionStrategyError,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have BufferDilutionStrategies that are compatible with the given options.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have BufferDilutionStrategies that are compatible with the given options.",True,True],
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




	(*------ concentratedBufferAmount ------*)
	concentratedBufferAmountInvalidOptions = If[Or@@concentratedBufferAmountError&&!gatherTests,
		Module[{concentratedBufferAmountInvalidSamples},
			(* Get the samples that correspond to this error. *)
			concentratedBufferAmountInvalidSamples=PickList[mySamples,concentratedBufferAmountError];

			(* Throw the corresopnding error. *)
			Message[Error::ConcentratedBufferAmountErr,ObjectToString[concentratedBufferAmountInvalidSamples,Cache->cache]];

			(* Return our invalid options. *)
			{ConcentratedBufferAmount}
		],
		{}
	];


	(* Create the corresponding test for the bufferDilutionStrategyErr. *)
	concentratedBufferAmountTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,concentratedBufferAmountError];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,concentratedBufferAmountError,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have ConcentratedBufferAmounts that are given by the user or can be calculated.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have ConcentratedBufferAmounts that are given by the user or can be calculated.",True,True],
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
	(*Message[Error::noellefakeerrormessage];*)

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
	(* When you do not want an aliquot to happen for the corresopnding simulated sample, make the corresponding index of targetContainers Null. *)
	(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)
	targetContainers=Null;

	(* rename rules for converting the options we have here with the names that *)
	(*add Mix option to samplePrepOptions in case resolveSamplePrepOptions gives us problems*)
	samplePrepOptions = Join[samplePrepOptions,{Mix->incubateOption}];

	(* turn the non-incubate sample prep options off *)
	(* Need to KeyDrop the options that are resuspend options but share names with sample prep options (TargetConcentration and DestinationWell, currently) *)
	samplePrepOptionsWithMasterSwitches=Normal[KeyDrop[
		Flatten[{samplePrepOptions,{
			Centrifuge->ConstantArray[False,Length[mySamples]],
			Aliquot->ConstantArray[False,Length[mySamples]],
			Filter->ConstantArray[False,Length[mySamples]],
			IncubateAliquot->ConstantArray[Null,Length[mySamples]]}
		}],
		{TargetConcentration,DestinationWell}
	]];


	(*temp testing*)

	(* resolve the sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentSerialDilute,Lookup[samplePackets,Object],samplePrepOptionsWithMasterSwitches,Cache->cache,Simulation -> simulation, Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentSerialDilute,Lookup[samplePackets,Object],samplePrepOptionsWithMasterSwitches,Cache->cache,Simulation -> simulation, Output->Result],{}}
	];


	(*Resolve all the incubate options*)
	resolvedIncubate = Lookup[resolvedSamplePrepOptions,Incubate];
	incubationTime = Lookup[resolvedSamplePrepOptions,IncubationTime];
	maxIncubationTime = Lookup[resolvedSamplePrepOptions,MaxIncubationTime];
	incubationTemperature = Lookup[resolvedSamplePrepOptions,IncubationTemperature];

	(*Expand all the options based on resolvedIncubate and the number of resolvedCOs for each sample*)
	expandedIncubateInformation =
		MapThread[
			Function[{incubateBool,incubTime,maxIncubTime,incubTemp,containersOut},
				{Table[incubateBool,Length[containersOut]],Table[incubTime,Length[containersOut]],Table[maxIncubTime,Length[containersOut]],Table[incubTemp,Length[containersOut]]}
			],
			{resolvedIncubate,incubationTime,maxIncubationTime,incubationTemperature,resolvedContainerOut}
		];

	expandedIncubate = expandedIncubateInformation[[All,1]];
	expandedIncubateTime = expandedIncubateInformation[[All,2]];
	expandedMaxIncubateTime = expandedIncubateInformation[[All,3]];
	expandedIncubateTemperature = expandedIncubateInformation[[All,4]];

	(*Create dictionaries to see whether there are conflicting options with overlapping resolved containers*)
	(*After each dict is formed, check to see if any values have length > 1 - if so, throw error*)
	incubRules =
     Merge[
		 MapThread[
			 Function[{containersOut,incubateBools},
				 AssociationThread[containersOut->incubateBools]
			 ],
			 {resolvedContainerOut,expandedIncubate}
		 ], Identity
	];

	(*go through and delete duplicates in each value*)
	incubRules = Normal[Map[DeleteDuplicates,incubRules]];

	(*want to return the samples that have the conflicting incubate options/containerout options*)
	conflictingIncubateContainers = Select[incubRules, Length[#[[2]]] > 1 &][[All, 1]];
	conflictingIncubateErr = If[Length[conflictingIncubateContainers]>0,True,False];

	(*------ conflictingIncubateErr ------*)
	conflictingIncubateInvalidOptions = If[Or@@conflictingIncubateErr&&!gatherTests,
		Module[{},
			(* Throw the corresopnding error. *)
			Message[Error::ConflictingIncubate,ObjectToString[conflictingIncubateContainers,Cache->cache]];

			(* Return our invalid options. *)
			{ContainerOut,Incubate}
		],
		{}
	];
	(* Create the corresponding test for the bufferDilutionStrategyErr. *)
	conflictingIncubateTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,concentratedBufferAmountError];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,concentratedBufferAmountError,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have ConcentratedBufferAmounts that are given by the user or can be calculated.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have ConcentratedBufferAmounts that are given by the user or can be calculated.",True,True],
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

	(*Repeat above for incubate time*)
	incubTimeRules =
		Merge[
			MapThread[
				Function[{containersOut,incubateTimes},
					AssociationThread[containersOut->incubateTimes]
				],
				{resolvedContainerOut,expandedIncubateTime}
			], Identity
		];
	incubTimeRules = Normal[Map[DeleteDuplicates,incubTimeRules]];
	conflictingIncubateTimeContainers = Select[incubTimeRules, Length[#[[2]]] > 1 &][[All, 1]];
	conflictingIncubateTimeErr = If[Length[conflictingIncubateTimeContainers]>0,True,False];

	(*------ conflictingIncubateTimeErr ------*)
	conflictingIncubateTimeInvalidOptions = If[Or@@conflictingIncubateTimeErr&&!gatherTests,
		Module[{},
			(* Throw the corresopnding error. *)
			Message[Error::ConflictingIncubateTime,ObjectToString[conflictingIncubateTimeContainers,Cache->cache]];

			(* Return our invalid options. *)
			{ContainerOut,Incubate}
		],
		{}
	];
	(* Create the corresponding test for the bufferDilutionStrategyErr. *)
	conflictingIncubateTimeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,concentratedBufferAmountError];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,concentratedBufferAmountError,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have ConcentratedBufferAmounts that are given by the user or can be calculated.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have ConcentratedBufferAmounts that are given by the user or can be calculated.",True,True],
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

	(*Repeat for max time rules*)
	incubMaxTimeRules =
		Merge[
			MapThread[
				Function[{containersOut,incubateMaxTimes},
					AssociationThread[containersOut->incubateMaxTimes]
				],
				{resolvedContainerOut,expandedMaxIncubateTime}
			], Identity
		];
	incubMaxTimeRules = Normal[Map[DeleteDuplicates,incubMaxTimeRules]];
	conflictingIncubateMaxTimeContainers = Select[incubMaxTimeRules,Length[#[[2]]] > 1 &][[All, 1]];
	conflictingIncubateMaxTimeErr = If[Length[conflictingIncubateMaxTimeContainers]>0,True,False];

	(*------ conflictingMaxIncubateTimeErr ------*)
	conflictingMaxIncubateTimeInvalidOptions = If[Or@@conflictingIncubateMaxTimeErr&&!gatherTests,
		Module[{},
			(* Throw the corresopnding error. *)
			Message[Error::ConflictingMaxIncubateTime,ObjectToString[conflictingIncubateMaxTimeContainers,Cache->cache]];

			(* Return our invalid options. *)
			{ContainerOut,Incubate}
		],
		{}
	];
	(* Create the corresponding test for the bufferDilutionStrategyErr. *)
	conflictingMaxIncubateTimeTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,concentratedBufferAmountError];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,concentratedBufferAmountError,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have ConcentratedBufferAmounts that are given by the user or can be calculated.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have ConcentratedBufferAmounts that are given by the user or can be calculated.",True,True],
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

	incubTempRules =
		Merge[
			MapThread[
				Function[{containersOut,incubateTemp},
					AssociationThread[containersOut->incubateTemp]
				],
				{resolvedContainerOut,expandedIncubateTemperature}
			], Identity
		];
	incubTempRules = Normal[Map[DeleteDuplicates,incubTempRules]];
	conflictingIncubateTempContainers = Select[incubTempRules, Length[#[[2]]] > 1 &][[All, 1]];
	conflictingIncubateTempErr = If[Length[conflictingIncubateTempContainers]>0,True,False];

	(*------ conflictingMaxIncubateTimeErr ------*)
	conflictingIncubateTempInvalidOptions = If[Or@@conflictingIncubateTempErr&&!gatherTests,
		Module[{},
			(* Throw the corresopnding error. *)
			Message[Error::ConflictingIncubateTemp,ObjectToString[conflictingIncubateTempContainers,Cache->cache]];

			(* Return our invalid options. *)
			{ContainerOut,Incubate}
		],
		{}
	];
	(* Create the corresponding test for the bufferDilutionStrategyErr. *)
	conflictingIncubateTempTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[mySamples,concentratedBufferAmountError];

			(* Get the inputs that pass this test. *)
			passingInputs=PickList[mySamples,concentratedBufferAmountError,False];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[failingInputs,Cache->cache]<>" have ConcentratedBufferAmounts that are given by the user or can be calculated.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following sample(s), "<>ObjectToString[passingInputs,Cache->cache]<>" have ConcentratedBufferAmounts that are given by the user or can be calculated.",True,True],
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


	(* Check ou  r invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs}]]; (*invalid objects*)
	invalidOptions=DeleteDuplicates[Flatten[{serialDiluteNumberInvalidOptions,
		bufferDilutionStrategyInvalidOptions,concentratedBufferAmountInvalidOptions,
		incompatibleIncubateInvalidOptions,conflictingIncubateInvalidOptions,
		unevenNumberFinalVolumeInvalidOptions,unevenNumberTransferAmountsInvalidOptions,
		unevenNumberDiluentAmountInvalidOptions,unevenNumberBufferDiluentAmountInvalidOptions,
		unevenNumberConcentratedBufferAmountInvalidOptions}]];
	(* Throw Error::InvalidInput if there are invalid inputs. *)


	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];
	(* TODO: Gather the resolved options (pre-collapsed; that is happening outside the function)*)
	resolvedOptions=
     ReplaceRule[
	 	myOptions,
		 Flatten[{
			 (* add your resolved options here *)
			 Analyte -> resolvedAnalyte,
			 SerialDilutionFactors->resolvedSerialDilutionFactors,
			 NumberOfSerialDilutions->resolvedNumberOfSerialDilutions,
			 TargetConcentrations->resolvedTargetConcentrations,
			 FinalVolume->resolvedFinalVolume,
			 TransferAmounts->resolvedTransferAmounts,
			 Diluent->resolvedDiluent,
			 DiluentAmount->resolvedDiluentAmount,
			 BufferDiluent->resolvedBufferDiluent,
			 BufferDilutionFactor->resolvedBufferDilutionFactor,
			 BufferDiluentAmount->resolvedBufferDiluentAmount,
			 ConcentratedBuffer->resolvedConcentratedBuffer,
			 ConcentratedBufferAmount->resolvedConcentratedBufferAmount,
			 DestinationWells->resolvedDestinationWells,
			 ContainerOut->resolvedContainerOut,
			 SourceLabel->resolvedSampleLabel,
			 SourceContainerLabel->resolvedSampleContainerLabel,
			 SampleOutLabel->resolvedSampleOutLabel,
			 ContainerOutLabel->resolvedContainerOutLabel,
			 DiluentLabel->resolvedDiluentLabel,
			 ConcentratedBufferLabel->resolvedConcentratedBufferLabel,
			 BufferDiluentLabel->resolvedBufferDiluentLabel,
			 Preparation->resolvedPreparation,
			 WorkCell->resolvedWorkCell,
			 BufferDilutionStrategy->Lookup[roundedSerialDiluteOptions,BufferDilutionStrategy],
			 TransferNumberOfMixes->resolvedNumberOfMixes,
			 TransferMixType->resolvedMixType,
			 TransferMix->resolvedMix,
			 (*Incubate->Values[incubRules],
			 IncubationTime->Values[incubTimeRules],
			 MaxIncubationTime->Values[incubMaxTimeRules],
			 IncubationTemperature->Values[incubTempRules],*)
			 Output->output,
			 (* also your reoslved Shared options*)
			 resolvedSamplePrepOptions,
			 resolvedPostProcessingOptions
		 }
		 ]
	 ];


	(* gather all the tests together *)
	allTests=Cases[Flatten[{
		(* put all your test variables here *)
		discardedTest,
		serialDiluteNumberTest,
		bufferDilutionStrategyTest,
		concentratedBufferAmountTest,
		incompatibleIncubateTest,
		conflictingIncubateTest,
		conflictingIncubateTimeTest,
		conflictingMaxIncubateTimeTest,
		conflictingIncubateTempTest,
		unevenNumberFinalVolumeTest,
		unevenNumberTransferAmountTest,
		unevenNumberDiluentAmountTest,
		unevenNumberBufferDiluentAmountTest,
		unevenNumberConcentratedBufferAmountTest
	}],_EmeraldTest];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> allTests
	}
];

DefineOptions[convertTransferStepsToPrimitivesSerialDilute,
	Options :> {
		CacheOption,
		SimulationOption
	}
];

(* helper function that takes the transfers we want to do + the resolved options, and makes them into actual transfer primitives.  This called in the resource packets function and the simulation function *)
convertTransferStepsToPrimitivesSerialDilute[
	mySamplePackets:{PacketP[Object[Sample]]..},
	myResolvedOptions:{___Rule},
	ops:OptionsPattern[convertTransferStepsToPrimitivesSerialDilute]
]:=Module[
	{resolvedBufferDiluent, resolvedConcentratedBuffer,
		sampleOutLabelReplaceRules, sampleOutLabelsForTransfer,
		safeOps, cache, resolvedContainerOut, containerOutModels, containerOutObjs,
		containerOutPackets, containerOutModelPackets, resolvedContainerOutWithPacket,transferPrimitives,
		allPrimitives, poolingShapes, sampleContainerPackets, labelSamplePrimitives,
		totalDiluentAmounts, totalConcentratedBufferAmounts, totalBufferDiluentAmounts,

		resolvedSerialDilutionFactors,
		resolvedNumberOfSerialDilutions,
		resolvedFinalVolume,
		resolvedTransferAmounts,
		resolvedDiluent,
		resolvedDiluentAmount,
		resolvedBufferDiluentAmount,
		resolvedConcentratedBufferAmount,
		resolvedDestinationWells,
		resolvedMix,
		resolvedMixType,
		resolvedNumberOfMixes,
		resolvedIncubationTime,
		resolvedMaxIncubationTime,
		resolvedIncubationTemperature,
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedSampleOutLabel,
		resolvedContainerOutLabel,
		resolvedDiluentLabel,
		resolvedConcentratedBufferLabel,
		resolvedBufferDiluentLabel,
		preResolvedContainerOut,
		resolvedBufferDilutionStrategy,
		resolvedPreparation,

		diluentLabelSamplePrimitives,
		bufferDiluentLabelSamplePrimitives,
		concentratedBufferLabelSamplePrimitives,
		containerOutFlattened, containerOutFlattenedNoInts, containerOutLabelsFlattened,
		containerOutWithLabelPaired, labelContainersPrimitive,incubatePrimitive,

		preDiluentThings,diluentThings,diluentSourceLabels,diluentDestinationContainerLabels,diluentTransferAmounts,diluentDestinationWells,
		preBufferDiluentThings,bufferDiluentThings,bufferDiluentSourceLabels,bufferDiluentDestinationContainerLabels,
		bufferDiluentTransferAmounts,bufferDiluentDestinationWells,concentratedBufferThings,preConcentratedBufferThings,
		concentratedBufferSourceLabels,concentratedBufferDestinationContainerLabels,concentratedBufferTransferAmounts,
		concentratedBufferDestinationWells,transferSamplesSourceLabels,transferSamplesDestinationContainerLabels,transferSamplesTransferAmounts,
		transferSamplesDestinationWells,diluentSourceWells,bufferDiluentSourceWells,concentratedBufferSourceWells,
		transferSamplesThingsFirst,transferSamplesSourceLabelsFirst,transferSamplesDestinationContainerLabelsFirst,transferSamplesTransferAmountsFirst,
		transferSamplesDestinationWellsFirst,transferSamplesThingsSubsequent,transferSamplesSourceLabelsSubs,transferSamplesDestinationContainerLabelsSubs,transferSamplesTransferAmountsSubs,
		transferSamplesDestinationWellsSubs,transferSamplesSourceWellsFirst,transferSamplesSourceWellsSubs,transferSamplesSourceWells,
		allSources,allSourceWells,allDestinationWells,allDestinationContainerLabels,allAmounts,
		allPrimitivesWithoutIncubateAndTransfer,nonSampleRelated,

		mixListFirst,mixListLast,mixList,mixTypeListFirst,mixTypeListLast,
		mixTypeList,mixNumList,

		resolvedDestWellsBySample,mixNumberFirst,mixNumLast,
		diluentAmountAssoc,bufferDiluentAmountAssoc,concentratedBufferAmountAssoc,

		diluentLabelRules,bufferDiluentLabelLabelRules,concentratedBufferLabelRules, resolvedIncubate,

		expandedIncubateInformation, expandedIncubate,expandedIncubateTime,expandedMaxIncubateTime,expandedIncubateTemperature,
		incubRules,incubTimeRules,incubMaxTimeRules,incubTempRules,

		containerOutLabelsIncubate,containerOutIncubateTemps,containerOutIncubateTimes,containerOutIncubateMaxTimes,
		resolvedDiscardFinalTransfer,wasteContainerVolumes,numWasteContainers,groupedFinalTransferVolumes,
		labelWasteContainersPrimitive,

		total,maxVolume,groupings,labelWasteContainers,discardFinalTransferSourceLabels,discardFinalTransferSourceWells,
		discardFinalTransferDestinationLabels,discardFinalTransferDestinationWells, discardFinalTransferMix,discardFinalTransferMixType,
		discardFinalTransferMixNumber,allPrimitivesWithoutIncubateAndTransferAndWaste,discardFinalTransferAmounts,
		multiChannelTransferBools,storageConditions, containerOutLabelToContainerOutRules, diluentDestinations,
		simulation, resolvedPreparatoryUnitOperations, labelSampleUOToPrepend, sampleToLabelRules, updatedSimulation,
		expandedDiluentTransferAmounts,expandedTransferSamplesTransferAmountsSubs

	},
	(* get the cache to grab the packets *)
	safeOps = SafeOptions[convertTransferStepsToPrimitivesSerialDilute, ToList[ops]];
	{cache,simulation} = Lookup[safeOps, {Cache,Simulation}];

	{
		resolvedSerialDilutionFactors,
		resolvedNumberOfSerialDilutions,
		resolvedFinalVolume,
		resolvedTransferAmounts,
		resolvedDiluent,
		resolvedDiluentAmount,
		resolvedBufferDiluent,
		resolvedBufferDiluentAmount,
		resolvedConcentratedBuffer,
		resolvedConcentratedBufferAmount,
		resolvedDestinationWells,
		resolvedContainerOut,
		resolvedMix,
		resolvedMixType,
		resolvedNumberOfMixes,
		resolvedIncubationTime,
		resolvedMaxIncubationTime,
		resolvedIncubationTemperature,
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedSampleOutLabel,
		resolvedContainerOutLabel,
		resolvedDiluentLabel,
		resolvedConcentratedBufferLabel,
		resolvedBufferDiluentLabel,
		resolvedBufferDilutionStrategy,
		resolvedPreparation,
		resolvedIncubate,
		resolvedDiscardFinalTransfer,
		resolvedPreparatoryUnitOperations
	} = Lookup[
		myResolvedOptions,
		{
			SerialDilutionFactors,
			NumberOfSerialDilutions,
			FinalVolume,
			TransferAmounts,
			Diluent,
			DiluentAmount,
			BufferDiluent,
			BufferDiluentAmount,
			ConcentratedBuffer,
			ConcentratedBufferAmount,
			DestinationWells,
			ContainerOut,
			TransferMix,
			TransferMixType,
			TransferNumberOfMixes,
			IncubationTime,
			MaxIncubationTime,
			IncubationTemperature,
			SourceLabel,
			SourceContainerLabel,
			SampleOutLabel,
			ContainerOutLabel,
			DiluentLabel,
			ConcentratedBufferLabel,
			BufferDiluentLabel,
			BufferDilutionStrategy,
			Preparation,
			Incubate,
			DiscardFinalTransfer,
			PreparatoryUnitOperations
		}
	];

	(* get the LabelSample unit operation we're going to be using here *)
	labelSampleUOToPrepend = If[MatchQ[resolvedPreparatoryUnitOperations, {_[_LabelSample]}],
		resolvedPreparatoryUnitOperations[[1, 1]],
		Null
	];

	(* get the samples from labels from the LabelSample we're prepending *)
	sampleToLabelRules = If[NullQ[labelSampleUOToPrepend] || Not[MatchQ[simulation, _Simulation]],
		{},
		With[
			{
				labelRules = Lookup[simulation[[1]], Labels],
				prepUOLabels = Flatten[{labelSampleUOToPrepend[Label], labelSampleUOToPrepend[ContainerLabel]}]
			},
			Reverse /@ Select[labelRules, MemberQ[prepUOLabels, #[[1]]]&]
		]
	];

	(* update the simulation to _not_ have the labels that we are adding above *)
	updatedSimulation = If[NullQ[simulation],
		Null,
		With[{oldLabelRules = Lookup[First[simulation], Labels], labelsToRemove = Values[sampleToLabelRules]},
			Simulation[
				Append[
					First[simulation],
					Labels -> Select[oldLabelRules, Not[MemberQ[labelsToRemove, #[[1]]]]&]
				]
			]
		]
	];

	(* get the shape of the sample inputs *)
	poolingShapes = Length[#]& /@ mySamplePackets;
	sampleContainerPackets = fetchPacketFromCache[#, cache]& /@ Lookup[Flatten[mySamplePackets], Container, {}];

	(* get all the ContainerOut models and objects *)
	containerOutModels = Cases[Flatten[ToList[resolvedContainerOut]], ObjectP[Model[Container]]];
	containerOutObjs = Cases[Flatten[ToList[resolvedContainerOut]], ObjectP[Object[Container]]];

	(* get the ContainerOut object and model packets (these two don't have to be the same length) *)
	containerOutPackets = fetchPacketFromCache[#, cache]& /@ containerOutObjs;
	(*containerOutModelPackets = Flatten[Download[containerOutModels]];*)
	containerOutModelPackets = Flatten[{
		fetchPacketFromCache[#, cache]& /@ containerOutModels,
		fetchPacketFromCache[#, cache]& /@ Lookup[containerOutPackets, Model, {}]
	}];

	(* get the resolved container out with packets instead of objects *)
	resolvedContainerOutWithPacket = Map[
		Function[{indexAndContainer},
			{indexAndContainer[[1]], SelectFirst[Flatten[{containerOutPackets, containerOutModelPackets}], MatchQ[#, ObjectP[indexAndContainer[[2]]]]&]}
		],
		preResolvedContainerOut
	];

	totalConcentratedBufferAmounts = Total/@resolvedConcentratedBufferAmount;(*If[Length[#]>1,Total[#],#]&/@resolvedConcentratedBufferAmount;*)

	totalBufferDiluentAmounts = Total/@resolvedBufferDiluentAmount;

	(*--- MAKE LABELSAMPLEPRIMITIVES FOR SAMPLES AND BUFFERS ---*)

	labelSamplePrimitives = DeleteDuplicates[
		Flatten[
			MapThread[
				Function[{samplePacketsInPool, sampleContainerPacketsInPool, sampleLabelsInPool, sampleContainerLabelsInPool,resolvedTransferAmount},
					MapThread[
						If[StringQ[#3] && StringQ[#4] && Not[MemberQ[Values[sampleToLabelRules], #3|#4]],
							Module[{},
								LabelSample[
									Sample -> Lookup[#1, Object],
									Container -> Lookup[#2, Object],
									Label -> #3,
									(* only models get amounts in LabelSample now *)
									Amount -> If[MatchQ[#1, ObjectP[Model]], resolvedTransferAmount[[1]][[1]], Automatic],
									ContainerLabel -> #4]
							],
							Nothing
						]&,
						{samplePacketsInPool, sampleContainerPacketsInPool, sampleLabelsInPool, sampleContainerLabelsInPool,resolvedTransferAmount}
					]
				],
				{List/@mySamplePackets, List/@sampleContainerPackets, List/@resolvedSampleLabel, List/@resolvedSampleContainerLabel, List/@resolvedTransferAmounts}
			]
		]
	];

	bufferDiluentLabelLabelRules = MapThread[
		If[VolumeQ[#2],
			#1 -> #2,
			Nothing
		]&,
		{resolvedBufferDiluentLabel, totalBufferDiluentAmounts}
	];
	bufferDiluentAmountAssoc = Merge[bufferDiluentLabelLabelRules, Total];


	bufferDiluentLabelSamplePrimitives = DeleteDuplicates[
		MapThread[
			LabelSample[
				Sample -> #1,
				Label -> #2,
				Amount -> If[MatchQ[#1, ObjectP[Model]], bufferDiluentAmountAssoc[#2], Automatic],
				Container -> If[MatchQ[#1, ObjectP[Model]], PreferredContainer[bufferDiluentAmountAssoc[#2]], Automatic]
			]&,
			{
				resolvedBufferDiluent, resolvedBufferDiluentLabel
			}
		]
	];

	concentratedBufferLabelRules= MapThread[
		If[VolumeQ[#2],
			#1 -> #2,
			Nothing
		]&,
		{resolvedConcentratedBufferLabel, totalConcentratedBufferAmounts}
	];
	concentratedBufferAmountAssoc = Merge[concentratedBufferLabelRules, Total];

	concentratedBufferLabelSamplePrimitives = DeleteDuplicates[
		MapThread[
			LabelSample[
				Sample -> #1,
				Label -> #2,
				Amount -> If[MatchQ[#1, ObjectP[Model]], concentratedBufferAmountAssoc[#2], Automatic],
				Container -> If[MatchQ[#1, ObjectP[Model]], PreferredContainer[concentratedBufferAmountAssoc[#2]], Automatic]
			]&,
			{
				resolvedConcentratedBuffer, resolvedConcentratedBufferLabel
			}
		]
	];

	(*--- ADD LABELS FOR ALL POSSIBLE CONTAINEROUTS ---*)
	(*get all unique containers in ContainerOut*)
	containerOutFlattened = Flatten[resolvedContainerOut];
	(*remove the integers from containerOutFlattened*)
	containerOutFlattenedNoInts = Cases[containerOutFlattened,ObjectP[]];

	(*flatten all the labels*)
	containerOutLabelsFlattened = Flatten[resolvedContainerOutLabel];

	(*get all unique labels in ContainerOutLabel, along with corresponding ContainerOut in containerOutFlattenedNoInts*)
	containerOutWithLabelPaired = DeleteDuplicates[MapThread[{#1,#2}&,{containerOutFlattenedNoInts,containerOutLabelsFlattened}]];


	(*assign labels to containerOut from columns of containerOutWithLabelPaired*)
	labelContainersPrimitive=LabelContainer[Container->containerOutWithLabelPaired[[All,1]],Label->containerOutWithLabelPaired[[All,2]]];

	(*Create ContainerLabel for Waste container when DiscardFinalTransfer->True*)
	wasteContainerVolumes = MapThread[
		Function[{discardFinalTransfer,transferAmounts},
			If[discardFinalTransfer,
				transferAmounts[[-1]],
				0Microliter
			]
		],
		{resolvedDiscardFinalTransfer,resolvedTransferAmounts}
	];
	(*get number of waste containers needed if prep->robotic, if prep->manual just do preferredcontainer*)
	total = 0Microliter;
	maxVolume = 195Milliliter;
	groupings = {{}};
	groupedFinalTransferVolumes = groupByEdited[wasteContainerVolumes,total,maxVolume,groupings];
	numWasteContainers =
     If[
		MatchQ[resolvedPreparation,Robotic],
		 Length[groupedFinalTransferVolumes],
		 1
	 ];

	(*generate the labels for the waste container primitive*)
	labelWasteContainers = If[MatchQ[resolvedPreparation,Robotic],
		Map[StringJoin["Waste container ", ToString[#]] &, Table[i,{i,numWasteContainers}]],
		"Waste container"
	];

	labelWasteContainersPrimitive = If[MatchQ[resolvedPreparation,Robotic],
		(*if prep->robotic, make numWasteContainers waste container labelcontainer primitives*)
		Module[{wasteContainerModels},
			(*create labels*)
			wasteContainerModels = Table[Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"],numWasteContainers];
			LabelContainer[Container->wasteContainerModels,Label->labelWasteContainers]
		],
		(*if prep->manual, make one waste container labelcontainer primitive*)
		Module[{totalVol,preferredContainer},
			totalVol = Total[wasteContainerVolumes];
			preferredContainer = PreferredContainer[totalVol];
			LabelContainer[Container->preferredContainer,Label->labelWasteContainers]
		]
	];


	(*--- GENERATE LISTS FOR BIG TRANSFER PRIMITIVE(S) ---*)

	(*Create dictionary of containeroutlabel->containerout*)
	containerOutLabelToContainerOutRules = Normal[
		Association[
			Normal/@(
				MapThread[
					Function[
						{labelsForOneSample, containersForOneSample},
						AssociationThread[labelsForOneSample -> containersForOneSample]
					],
					{resolvedContainerOutLabel, resolvedContainerOut}
				]
			)
		]
	];

	(*----- Create source list for samples in plates or vessels -----*)

	(*First get diluentThings, MapThread over bufferDilutionStrategy*)
	(*structure of diluentThings is {{diluentLabels},{diluent destiations},{diluentAmounts},{diluentDestinationWells and Preparation}}*)
	preDiluentThings = MapThread[
		Function[{bufferDilutionStrategy,dilLabel,dilAmounts,containerOutLabels,destWells},
			If[MatchQ[bufferDilutionStrategy,Direct],
				Module[{},
					splitTransfersBy970[Table[dilLabel, Length[containerOutLabels]], containerOutLabels,
						dilAmounts, DestinationWell -> destWells,Preparation->resolvedPreparation]
				],
				Null
			]
		],
		{resolvedBufferDilutionStrategy,resolvedDiluentLabel,resolvedDiluentAmount,resolvedContainerOutLabel,
			resolvedDestinationWells}
	];

	(*If bufferDilutionStrategy is never Direct, check that now*)
	diluentThings = If[!MemberQ[resolvedBufferDilutionStrategy,Direct],
		{},
		DeleteCases[preDiluentThings,Null]
	];


	If[Length[diluentThings]>0,
		Module[{},
			{diluentSourceLabels,diluentDestinationContainerLabels,diluentTransferAmounts,diluentDestinationWells} =
				{diluentThings[[All,1]],diluentThings[[All,2]],diluentThings[[All,3]],Lookup[#,DestinationWell]&/@diluentThings[[All,4]]};
			diluentSourceWells = Table[Automatic,Length[#]]&/@diluentSourceLabels;
			(*Echo[diluentDestinationContainerLabels,"diluentDestinationContainerLabels"];*)
			diluentDestinations = Map[#/.containerOutLabelToContainerOutRules&,diluentDestinationContainerLabels];
		],
		Module[{},
			{diluentSourceLabels,diluentDestinationContainerLabels,diluentTransferAmounts,diluentDestinationWells} =
				{{},{},{},{}};
			diluentSourceWells = {};
			(*diluentDestinations = {};*)
		]
	];

	(*MapThreading over diluentTransferAmounts and diluentDestinationContainerLabels,
	if Length[diluentTransferAmounts]!=Length[diluentDestinationContainerLabels] and is length of 1, expand it*)
	expandedDiluentTransferAmounts=
     MapThread[
		 Function[{diluentTransferAmount,diluentDestinationContainerLabel},
		 	If[Length[diluentTransferAmount]==1 && Length[diluentTransferAmount]!=Length[diluentDestinationContainerLabel],
				ConstantArray[diluentTransferAmount[[1]],Length[diluentDestinationContainerLabel]],
				diluentTransferAmount
			]
		 ],
		 {diluentTransferAmounts,diluentDestinationContainerLabels}
	];

	(*make Diluent labelsample primitive based on expandedDiluentTransferAmounts*)
	totalDiluentAmounts = Flatten[Total/@expandedDiluentTransferAmounts];

	diluentLabelRules = If[Length[totalDiluentAmounts]>0,
		MapThread[
			If[VolumeQ[#2],
				#1 -> #2,
				Nothing
			]&,
			{resolvedDiluentLabel, totalDiluentAmounts}
		],
		{}
	];
	diluentAmountAssoc = If[Length[totalDiluentAmounts]>0,Merge[diluentLabelRules, Total],{}];

	(* make the LabelSample primitives for all AssayBuffers, BufferDiluents, and ConcentratedBuffers *)
	diluentLabelSamplePrimitives =
     If[Length[totalDiluentAmounts]>0,
		DeleteDuplicates[
			MapThread[
				LabelSample[
					Sample -> #1,
					Label -> #2,
					Amount -> If[MatchQ[#1, ObjectP[Model]], diluentAmountAssoc[#2], Automatic],
					Container -> If[MatchQ[#1, ObjectP[Model]], PreferredContainer[diluentAmountAssoc[#2]], Automatic],
					ContainerLabel -> If[MatchQ[#2,_String],StringJoin["Container of ",#2],Automatic]
				]&,
				{
					resolvedDiluent, resolvedDiluentLabel
				}
			]
		],
		 {}
	 ];

	(*Echo[diluentDestinations,"diluentDestinations"];*)
	(*Do the same thing for bufferDiluentThings, MapThread over bufferDilutionStrategy*)

	preBufferDiluentThings = MapThread[
		Function[{bufferDilutionStrategy,dilLabel,dilAmounts,containerOutLabels,destWells},
			If[MatchQ[bufferDilutionStrategy,FromConcentrate],
				Module[{},
					splitTransfersBy970[Table[dilLabel, Length[containerOutLabels]], containerOutLabels,
						dilAmounts, DestinationWell -> destWells,Preparation->resolvedPreparation]
				],
				Null
			]
		],
		{resolvedBufferDilutionStrategy,resolvedBufferDiluentLabel,resolvedBufferDiluentAmount,resolvedContainerOutLabel,
			resolvedDestinationWells}
	];


	(*If bufferDilutionStrategy is never Direct, check that now*)
	bufferDiluentThings = If[!MemberQ[resolvedBufferDilutionStrategy,FromConcentrate],
		{},
		DeleteCases[preBufferDiluentThings,Null]
	];

	If[Length[bufferDiluentThings]>0,
		Module[{},
			{bufferDiluentSourceLabels,bufferDiluentDestinationContainerLabels,bufferDiluentTransferAmounts,bufferDiluentDestinationWells} =
				{bufferDiluentThings[[All,1]],bufferDiluentThings[[All,2]],bufferDiluentThings[[All,3]],Lookup[#,DestinationWell]&/@bufferDiluentThings[[All,4]]};
			bufferDiluentSourceWells = Table[Automatic,Length[#]]&/@bufferDiluentSourceLabels;
			(*bufferDiluentDestinations = Map[#/.containerOutLabelToContainerOutRules&,bufferDiluentDestinationContainerLabels];*)
		],
		Module[{},
			{bufferDiluentSourceLabels,bufferDiluentDestinationContainerLabels,bufferDiluentTransferAmounts,bufferDiluentDestinationWells} =
				{{},{},{},{}};
			bufferDiluentSourceWells = {};
			(*bufferDiluentDestinations = {};*)
		]
	];

	(*Do the same thing for concentratedBufferThings, check if concentratedBuffer is not Null and check for strategy*)
	preConcentratedBufferThings = MapThread[
		Function[{concentratedBuffer,bufferDilutionStrategy,concentratedBufferLabel,concentratedBufferAmounts,
			destWells,containerOutLabels},
			Which[!NullQ[concentratedBuffer]&&MatchQ[bufferDilutionStrategy,Direct],
				Module[{},
					splitTransfersBy970[{concentratedBufferLabel}, {containerOutLabels[[1]]},
						concentratedBufferAmounts, DestinationWell -> destWells[[1]],Preparation->resolvedPreparation]
				],


				!NullQ[concentratedBuffer]&&MatchQ[bufferDilutionStrategy,FromConcentrate],
				splitTransfersBy970[Table[concentratedBufferLabel,Length[containerOutLabels]], containerOutLabels,
					concentratedBufferAmounts, DestinationWell -> destWells,Preparation->resolvedPreparation],

				True,
				Null
			]
		],
		{resolvedConcentratedBuffer,resolvedBufferDilutionStrategy,resolvedConcentratedBufferLabel,
		resolvedConcentratedBufferAmount,resolvedDestinationWells,resolvedContainerOutLabel}
	];

	concentratedBufferThings = If[MatchQ[DeleteDuplicates[resolvedConcentratedBuffer],{Null}],
		{},
		DeleteCases[preConcentratedBufferThings,Null]
	];

	If[Length[concentratedBufferThings]>0,
		Module[{},
			{concentratedBufferSourceLabels,concentratedBufferDestinationContainerLabels,concentratedBufferTransferAmounts,
				concentratedBufferDestinationWells} =
				{concentratedBufferThings[[All,1]],concentratedBufferThings[[All,2]],concentratedBufferThings[[All,3]],Lookup[#,DestinationWell]&/@concentratedBufferThings[[All,4]]};
			concentratedBufferSourceWells = Table[Automatic,Length[#]]&/@concentratedBufferSourceLabels;
			(*concentratedBufferDestinations = Map[#/.containerOutLabelToContainerOutRules&,concentratedBufferDestinationContainerLabels];*)
		],
		Module[{},
			{concentratedBufferSourceLabels,concentratedBufferDestinationContainerLabels,concentratedBufferTransferAmounts,
				concentratedBufferDestinationWells} =
				{{},{},{},{}};
			concentratedBufferSourceWells = {};
			(*concentratedBufferDestinations = {};*)
		]
	];


	(*do the same for transferring the actual samples to their destinations*)

	(*resolve first transfer, from sample to first container vessel/well*)
	(*transferSamplesThingsFirst contains information about the first transfer, the sampleLabel, the containerOutLabel,
	the transferAmount, the destinationWell, and the preparation*)

	transferSamplesThingsFirst = MapThread[
		Function[{sampleLabel,transferAmounts,containerOutLabels,destWells},
			splitTransfersBy970[{sampleLabel}, {containerOutLabels[[1]]},
				{transferAmounts[[1]]}, DestinationWell -> destWells[[1]],Preparation->resolvedPreparation]
		],
		{resolvedSampleLabel,resolvedTransferAmounts,resolvedContainerOutLabel,resolvedDestinationWells}
	];

	{transferSamplesSourceLabelsFirst,transferSamplesDestinationContainerLabelsFirst,transferSamplesTransferAmountsFirst,
		transferSamplesDestinationWellsFirst} =
		{transferSamplesThingsFirst[[All,1]],transferSamplesThingsFirst[[All,2]],transferSamplesThingsFirst[[All,3]],
			Lookup[#,DestinationWell]&/@transferSamplesThingsFirst[[All,4]]};

	(*transferSamplesFirstDestination = Map[# /. containerOutLabelToContainerOutRules &, transferSamplesDestinationContainerLabelsFirst];
	Echo[transferSamplesFirstDestination,"transferSamplesFirstDestination"];*)
	(*resolve the subsequent transfers*)
	(*transferSamplesThingsSubsequent has information about the subsequent transfers*)
	transferSamplesThingsSubsequent = MapThread[
		Function[{sampleLabel,transferAmounts,containerOutLabels,destWells},
			splitTransfersBy970[Most[containerOutLabels], Rest[containerOutLabels],
				Rest[transferAmounts], DestinationWell -> Rest[destWells],Preparation->resolvedPreparation]
		],
		{resolvedSampleLabel,resolvedTransferAmounts,resolvedContainerOutLabel,resolvedDestinationWells}
	];

	(*Get information about the sourcelabel, destination container label, sample transfer amounts, and destinationwells for
	the subsequent transfers, based on transferSamplesThingsSubsequent*)
	{transferSamplesSourceLabelsSubs,transferSamplesDestinationContainerLabelsSubs,transferSamplesTransferAmountsSubs,
		transferSamplesDestinationWellsSubs} =
		{transferSamplesThingsSubsequent[[All,1]],transferSamplesThingsSubsequent[[All,2]],transferSamplesThingsSubsequent[[All,3]],
			Lookup[#,DestinationWell]&/@transferSamplesThingsSubsequent[[All,4]]};
	(*transferSamplesSubsDestination = Map[# /. containerOutLabelToContainerOutRules &, transferSamplesDestinationContainerLabelsSubs];
	Echo[transferSamplesSubsDestination,"transferSamplesSubsDestination"];*)

	transferSamplesSourceWellsFirst = Table[Automatic,Length[transferSamplesDestinationWellsFirst]];
	transferSamplesSourceWellsSubs =
     MapThread[
		Function[{destWellFirst,destWellsSubs},
			If[Length[destWellsSubs]==0,
				{},
				Join[ToList[destWellFirst],Most[destWellsSubs]]
			]
		],
		{transferSamplesDestinationWellsFirst,transferSamplesDestinationWellsSubs}
	];

	(*MapThreading over diluentTransferAmounts and diluentDestinationContainerLabels,
	if Length[diluentTransferAmounts]!=Length[diluentDestinationContainerLabels] and is length of 1, expand it*)
	expandedTransferSamplesTransferAmountsSubs=
		MapThread[
			Function[{transferSamplesTransferAmountsSub,transferSamplesDestinationContainerLabelsSub},
				If[Length[transferSamplesTransferAmountsSub]==0 && Length[transferSamplesTransferAmountsSub]!=Length[transferSamplesDestinationContainerLabelsSub],
					ConstantArray[transferSamplesTransferAmountsFirst[[1]],Length[transferSamplesDestinationContainerLabelsSub]],
					transferSamplesTransferAmountsSub
				]
			],
			{transferSamplesTransferAmountsSubs,transferSamplesDestinationContainerLabelsSubs}
		];

	transferSamplesSourceLabels = Join[transferSamplesSourceLabelsFirst,transferSamplesSourceLabelsSubs];
	transferSamplesDestinationContainerLabels = Join[transferSamplesDestinationContainerLabelsFirst,transferSamplesDestinationContainerLabelsSubs];
	transferSamplesTransferAmounts = Join[transferSamplesTransferAmountsFirst,expandedTransferSamplesTransferAmountsSubs];
	transferSamplesDestinationWells = Join[transferSamplesDestinationWellsFirst,transferSamplesDestinationWellsSubs];
	transferSamplesSourceWells = Join[transferSamplesSourceWellsFirst,transferSamplesSourceWellsSubs];



	(*transferDestinations = Join[transferSamplesFirstDestination,transferSamplesSubsDestination];
	Echo[transferDestinations,"transferDestinations"];*)
	(*If MemberQ[DeleteDuplicates[resolvedDiscardFinalTransfer],True], then we should add DiscardFinalTransfer things to ends of lists*)
	{
		discardFinalTransferSourceLabels,
		discardFinalTransferSourceWells,
		discardFinalTransferDestinationLabels,
		discardFinalTransferDestinationWells,
		discardFinalTransferMix,
		discardFinalTransferMixType,
		discardFinalTransferMixNumber,
		discardFinalTransferAmounts
	} = If[MemberQ[DeleteDuplicates[resolvedDiscardFinalTransfer],True],
		Module[{wasteLabelsToTransferAmounts,discardOrNot,discardSourceLabels,discardSourceWells,newWasteLabelsToTransferAmounts,
			discardDestinationLabels,discardDestinationWells,discardDispenseMix,discardDispenseMixType,discardDispenseMixNumber,
			discardTransferAmounts},

			(*create association with waste container labels to last transfer amounts*)
			wasteLabelsToTransferAmounts = AssociationThread[labelWasteContainers,groupedFinalTransferVolumes];

			(*select from last of the DestinationLabels and DestinationWells the ones where DiscardFinalTransfer isn't false, aka 0uL amount*)
			discardOrNot = Unitless[Flatten[groupedFinalTransferVolumes]]/.{0->False,NumericP->True};
			discardSourceLabels = PickList[transferSamplesDestinationContainerLabelsSubs[[All, -1]], discardOrNot, True];
			discardSourceWells = PickList[transferSamplesDestinationWellsSubs[[All, -1]], discardOrNot, True];

			(*Remove all 0uLs from wasteLabelsToTransferAmounts*)
			newWasteLabelsToTransferAmounts = Map[DeleteCases[#,0Microliter]&,wasteLabelsToTransferAmounts];

			(*get discardFinalTransferAmounts*)
			discardTransferAmounts = Flatten[Values[newWasteLabelsToTransferAmounts]];

			(*Expand each key to the length of its values, and concatenate them all in a list*)
			discardDestinationLabels = Flatten[KeyValueMap[Table[#1,Length[#2]]&,newWasteLabelsToTransferAmounts]];

			(*Create list of A1s length of discardDestinationLabels*)
			discardDestinationWells = Table["A1",Length[discardDestinationLabels]];

			(*for DispenseMix,DispenseMixType and mixNumList, just do False and Nulls*)
			discardDispenseMix = Table[False,Length[discardDestinationLabels]];
			discardDispenseMixType = Table[Null,Length[discardDestinationLabels]];
			discardDispenseMixNumber = Table[Null,Length[discardDestinationLabels]];

			(* return results *)
			{
				discardSourceLabels,
				discardSourceWells,
				discardDestinationLabels,
				discardDestinationWells,
				discardDispenseMix,
				discardDispenseMixType,
				discardDispenseMixNumber,
				discardTransferAmounts
			}
		],
		(*if not, return Nulls*)
		{{},{},{},{},{},{},{},{}}
	];


	(*--- build the Transfer primitive ---*)

	allSources = Flatten[Join[
		diluentSourceLabels,bufferDiluentSourceLabels,concentratedBufferSourceLabels,transferSamplesSourceLabels,discardFinalTransferSourceLabels
	]];

	allSourceWells = Flatten[Join[
		diluentSourceWells, bufferDiluentSourceWells,concentratedBufferSourceWells,transferSamplesSourceWells,discardFinalTransferSourceWells]
	];

	multiChannelTransferBools = Flatten[Join[
		ConstantArray[True,Length[Flatten[diluentSourceWells]]],ConstantArray[True,Length[Flatten[bufferDiluentSourceWells]]],ConstantArray[True,Length[Flatten[concentratedBufferSourceWells]]],
		ConstantArray[False,Length[Flatten[transferSamplesSourceWells]]],ConstantArray[False,Length[Flatten[discardFinalTransferSourceWells]]]
	]];

	(*SamplesOutStorageCondition*)
	storageConditions = Flatten[Join[
		ConstantArray[Null,Length[Flatten[diluentSourceWells]]],ConstantArray[Null,Length[Flatten[bufferDiluentSourceWells]]],ConstantArray[Null,Length[Flatten[concentratedBufferSourceWells]]],
		ConstantArray[Null,Length[Flatten[transferSamplesSourceWells]]],ConstantArray[Disposal,Length[Flatten[discardFinalTransferSourceWells]]]
	]];

	allDestinationWells = Flatten[Join[
		diluentDestinationWells,bufferDiluentDestinationWells,concentratedBufferDestinationWells,transferSamplesDestinationWells,discardFinalTransferDestinationWells
		]
	];


	allDestinationContainerLabels = Flatten[Join[
		diluentDestinationContainerLabels,bufferDiluentDestinationContainerLabels,concentratedBufferDestinationContainerLabels,
		transferSamplesDestinationContainerLabels,discardFinalTransferDestinationLabels
	]];


	allAmounts = Flatten[Join[
		expandedDiluentTransferAmounts,bufferDiluentTransferAmounts,concentratedBufferTransferAmounts,transferSamplesTransferAmounts,discardFinalTransferAmounts
	]];

	(*resolving mix lists*)
	resolvedDestWellsBySample = MapThread[
		Function[{firstDestWell,secondDestWells},
			Flatten[Join[ToList[firstDestWell],secondDestWells]]
		],
		{transferSamplesDestinationWellsFirst,transferSamplesDestinationWellsSubs}
	];

	nonSampleRelated = Length[Flatten[Join[expandedDiluentTransferAmounts,bufferDiluentTransferAmounts,concentratedBufferTransferAmounts]]];
	mixListFirst = Table[False,nonSampleRelated];
	mixListLast = MapThread[
		Function[{mix,destWellsBySample},
			Table[mix,Length[destWellsBySample]]
		],
		{resolvedMix,resolvedDestWellsBySample}
	];
	mixList = Flatten[Join[mixListFirst,mixListLast,discardFinalTransferMix]];

	mixTypeListFirst = Table[Null,nonSampleRelated];
	mixTypeListLast =  MapThread[
		Function[{mix,mixType,destWellsBySample},
			If[mix,
				Table[mixType,Length[destWellsBySample]],
				Table[Null,Length[destWellsBySample]]
			]
		],
		{resolvedMix,resolvedMixType,resolvedDestWellsBySample}
	];
	mixTypeList = Flatten[Join[mixTypeListFirst,mixTypeListLast,discardFinalTransferMixType]];


	mixNumberFirst = Table[Null,nonSampleRelated];
	mixNumLast =  MapThread[
		Function[{mix,destWellsBySample},
			If[mix,
				Table[20,Length[destWellsBySample]],
				Table[Null,Length[destWellsBySample]]
			]
		],
		{resolvedMix,resolvedDestWellsBySample}
	];

	mixNumList = Flatten[Join[mixNumberFirst,mixNumLast,discardFinalTransferMixNumber]];

	(* make replace rules converting ContainerOutLabel + DestinationWell pairs into the SampleOutLabel *)
	sampleOutLabelReplaceRules=DeleteDuplicates@MapThread[
		{#1,#2}->#3&,
		{Flatten@resolvedContainerOutLabel,Flatten@resolvedDestinationWells,Flatten@resolvedSampleOutLabel}
	];
	sampleOutLabelsForTransfer=Transpose[{allDestinationContainerLabels,allDestinationWells}]/.sampleOutLabelReplaceRules;

	transferPrimitives = Transfer[
		Source->allSources,
		SourceLabel->allSources,
		SourceWell->allSourceWells,
		DestinationWell->allDestinationWells,
		Destination->allDestinationContainerLabels,
		DestinationLabel->sampleOutLabelsForTransfer,
		DestinationContainerLabel -> allDestinationContainerLabels,
		Amount->allAmounts,
		DispenseMix->mixList,
		DispenseMixType->mixTypeList,
		NumberOfDispenseMixes->mixNumList,
		MultichannelTransfer->multiChannelTransferBools,
		SamplesOutStorageCondition->storageConditions
	];

	allPrimitivesWithoutIncubateAndTransferAndWaste =
		Flatten[
			MapThread[
				Function[{bufferDilutionStrategy,concentratedBuffer,bufferDiluent,diluent},
					(*are we in bDS=Direct?*)
					If[MatchQ[bufferDilutionStrategy,Direct],
						(*is ConcentratedBuffer defined?*)
						If[NullQ[concentratedBuffer],
							(*if yes, return labelSamplePrimitives,labelContainersPrimitives,diluentLabelSamplePrimitives, and transferPrimitives*)
							{labelSamplePrimitives,labelContainersPrimitive,diluentLabelSamplePrimitives},
							(*if no, reutrn the above plus concentratedBufferLabelSamplePrimitives*)
							{labelSamplePrimitives,labelContainersPrimitive,diluentLabelSamplePrimitives,concentratedBufferLabelSamplePrimitives}
						],
						(*we are in bDS=FromConcentrate*)
						(*is ConcentratedBuffer defined?*)
						If[NullQ[concentratedBuffer],
							(*if yes, return labelSamplePrimitives,labelContainersPrimitive,bufferDiluentLabelSamplePrimitives,transferPrimitives*)
							{labelSamplePrimitives,labelContainersPrimitive,bufferDiluentLabelSamplePrimitives},
							(*if not, return the above with concentratedBufferLabelSamplePrimitives*)
							{labelSamplePrimitives,labelContainersPrimitive,bufferDiluentLabelSamplePrimitives,concentratedBufferLabelSamplePrimitives}
						]
					]
				],
				{resolvedBufferDilutionStrategy,resolvedConcentratedBuffer,resolvedBufferDiluent,resolvedDiluent}
			]
		];

	(*Check if we are not discarding final transfer for any sample at all - if we are, include the LabelContainer waste primtive*)
	allPrimitivesWithoutIncubateAndTransfer = If[MemberQ[DeleteDuplicates[resolvedDiscardFinalTransfer],True],
		Join[allPrimitivesWithoutIncubateAndTransferAndWaste,{labelWasteContainersPrimitive}],
		allPrimitivesWithoutIncubateAndTransferAndWaste
	];

	(*-------- INCUBATE PRIMITIVE --------*)

	(*re-create containerOut->incubateOption dictionaries like in resolvedOptions*)
	(*in order to also filter out False incubations as well as resolve same plate incubations*)

	(*Expand all the options based on resolvedIncubate and the number of resolvedCOs for each sample*)
	expandedIncubateInformation =
		MapThread[
			Function[{incubateBool,incubTime,maxIncubTime,incubTemp,containersOut},
				{Table[incubateBool,Length[containersOut]],Table[incubTime,Length[containersOut]],Table[maxIncubTime,Length[containersOut]],Table[incubTemp,Length[containersOut]]}
			],
			{resolvedIncubate,resolvedIncubationTime,resolvedMaxIncubationTime,
				resolvedIncubationTemperature,resolvedContainerOut}
		];

	expandedIncubate = expandedIncubateInformation[[All,1]];
	expandedIncubateTime = expandedIncubateInformation[[All,2]];
	expandedMaxIncubateTime = expandedIncubateInformation[[All,3]];
	expandedIncubateTemperature = expandedIncubateInformation[[All,4]];

	(*create each dictionary for each incubate rule, use these to create the incubate primitive*)
	incubRules =
		Merge[
			MapThread[
				Function[{containersOut,incubateBools},
					AssociationThread[containersOut->incubateBools]
				],
				{resolvedContainerOut,expandedIncubate}
			], Identity
		];

	(*go through and delete duplicates in each value*)
	incubRules = Normal[Map[DeleteDuplicates,incubRules]];


	(*Repeat above for incubate time*)
	incubTimeRules =
		Merge[
			MapThread[
				Function[{containersOut,incubateTimes},
					AssociationThread[containersOut->incubateTimes]
				],
				{resolvedContainerOut,expandedIncubateTime}
			], Identity
		];
	incubTimeRules = Normal[Map[DeleteDuplicates,incubTimeRules]];


	(*Repeat for max time rules*)
	incubMaxTimeRules =
		Merge[
			MapThread[
				Function[{containersOut,incubateMaxTimes},
					AssociationThread[containersOut->incubateMaxTimes]
				],
				{resolvedContainerOut,expandedMaxIncubateTime}
			], Identity
		];
	incubMaxTimeRules = Normal[Map[DeleteDuplicates,incubMaxTimeRules]];


	incubTempRules =
		Merge[
			MapThread[
				Function[{containersOut,incubateTemp},
					AssociationThread[containersOut->incubateTemp]
				],
				{resolvedContainerOut,expandedIncubateTemperature}
			], Identity
		];
	incubTempRules = Normal[Map[DeleteDuplicates,incubTempRules]];
	incubTempRules = incubTempRules/.{Ambient->25Celsius};

	(*get resolvedConntaienrOutLabels that have Incubate->True*)
	containerOutLabelsIncubate = PickList[containerOutWithLabelPaired[[All,2]],Flatten[Values[incubRules]]];
	containerOutIncubateTemps = PickList[Values[incubTempRules],Flatten[Values[incubRules]]];
	containerOutIncubateTimes = PickList[Values[incubTimeRules],Flatten[Values[incubRules]]];
	containerOutIncubateMaxTimes = PickList[Values[incubMaxTimeRules],Flatten[Values[incubRules]]];


	incubatePrimitive =
		Incubate[
			Sample->Flatten[containerOutLabelsIncubate],
			Temperature->Flatten[containerOutIncubateTemps],
			Time->Flatten[containerOutIncubateTimes],
			MaxTime->Flatten[containerOutIncubateMaxTimes]
		];

	(*if no incubation happening at all, don't include it*)
	(* if we're doing a preparatory unit operation model input, we need to remove the simulated IDs here and replace them with the labels in question *)
	allPrimitives = ReplaceAll[
		DeleteDuplicates[Flatten[{
			If[NullQ[labelSampleUOToPrepend], Nothing, labelSampleUOToPrepend],
			allPrimitivesWithoutIncubateAndTransfer,
			transferPrimitives,
			If[MatchQ[DeleteDuplicates[Flatten[Values[incubRules]]], {False}],
				Nothing,
				incubatePrimitive
			]
		}]],
		sampleToLabelRules
	];

	{allPrimitives, updatedSimulation}

];

DefineOptions[
	serialDiluteResourcePackets,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

serialDiluteResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages,
		inheritedCache, testsRule, resultRule, resolvedDiluent, resolvedConcentratedBuffer, resolvedBufferDiluent,
		resolvedBufferDilutionFactor, specifiedContainerOut, allBufferModels, allBufferObjs, containerOutModels,
		containerOutObjs, resolvedPrepUOs, samplePackets, sampleContainerPackets, sampleContainerModelPackets, containerOutPackets,
		containerOutModelPackets, bufferObjectPackets, bufferModelPackets, bufferContainerPackets, bufferContainerModelPackets,
		mapThreadFriendlyOptions, resolvedTargetConcentration, resolvedContainerOut, resolvedDestWell, currentAmounts,
		containerOutIndices, containerOutIndexReplaceRules, resolvedPreparation, resolvedWorkCell, modelExchangedInputs,
		protocolPackets, protocolTests, runTime, allUnitOperationPackets, updatedSimulation, allPrimitives, experimentFunction,
		simulatedObjectsToLabel, expandedResolvedOptionsWithLabels, serialDiluteUnitOperationBlobs, serialDiluteUnitOperationPacketsNotLinked,
		serialDiluteUnitOperationPackets, protPacket, accessoryProtPackets, protPacketFinal, previewRule, optionsRule,
		simulationRule, simulation, wasteContainersLabels, allLabelContainers, wasteContainers, finalSimulation
	},

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentSerialDilute, {mySamples}, myResolvedOptions];


	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentSerialDilute,
		RemoveHiddenOptions[ExperimentSerialDilute,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	(*outputSpecification=OptionDefault[OptionValue[Output]];*)

	outputSpecification = Lookup[myResolvedOptions,Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];


	(* Get the inherited cache *)
	{inheritedCache, simulation} = Lookup[SafeOptions[serialDiluteResourcePackets, ToList[ops]], {Cache, Simulation}];

	(* pull out the ConcentratedBuffer, AssayBuffer, BufferDiluent, and ContainerOut options *)
	{
		resolvedDiluent,
		resolvedConcentratedBuffer,
		resolvedBufferDiluent,
		resolvedBufferDilutionFactor,
		resolvedPrepUOs
	} = Lookup[
		expandedResolvedOptions,
		{
			Diluent,
			ConcentratedBuffer,
			BufferDiluent,
			BufferDilutionFactor,
			PreparatoryUnitOperations
		}
	];

	specifiedContainerOut = Lookup[expandedResolvedOptions,ContainerOut]; (*/. _Integer->Container;*)

	(* get all the buffers that were specified as models and objects *)
	allBufferModels = Cases[Flatten[{resolvedConcentratedBuffer, resolvedDiluent, resolvedBufferDiluent}], ObjectP[Model[Sample]]];
	allBufferObjs = Cases[Flatten[{resolvedConcentratedBuffer, resolvedDiluent, resolvedBufferDiluent}], ObjectP[Object[Sample]]];

	(* get all the ContainerOut models and objects *)
	containerOutModels = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Model[Container]]];
	containerOutObjs = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Object[Container]]];

	(* pull out all the sample/sample model/container/container model packets; also get these in the proper shape that the samples are in *)
	samplePackets = fetchPacketFromCache[#, inheritedCache]& /@ mySamples;
	sampleContainerPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[samplePackets, Container, {}], Object];
	sampleContainerModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[sampleContainerPackets, Model, {}], Object];


	(* get the ContainerOut object and model packets (again like with the buffers, these two don't have to be the same length) *)
	containerOutPackets = fetchPacketFromCache[#, inheritedCache]& /@ containerOutObjs;
	containerOutModelPackets = DeleteDuplicates[fetchPacketFromCache[#, inheritedCache]& /@ Flatten[{Download[Lookup[containerOutPackets, Model, {}], Object], containerOutModels}]];

	(* get the packets for the buffer objects*)
	bufferObjectPackets = fetchPacketFromCache[#, inheritedCache]& /@ allBufferObjs;
	bufferModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Flatten[{Download[Lookup[bufferObjectPackets, Model, {}], Object], allBufferModels}];
	bufferContainerPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[bufferObjectPackets, Container, {}], Object];
	bufferContainerModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[bufferContainerPackets, Model, {}], Object];

	(* split the resolved options into MapThread friendly options *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentSerialDilute, expandedResolvedOptions];

	(* pull out the Volume, Mass, Volume, TargetConcentration, TargetConcentrationAnalyte, ContainerOut, and DestinationWell (and BufferDilutionFactor) options *)
	{resolvedTargetConcentration, resolvedContainerOut, resolvedDestWell} = Lookup[expandedResolvedOptions, {TargetConcentration, ContainerOut, DestinationWells}];

	(* get the current amount of the given sample we have *)
	currentAmounts = Map[Lookup[#, Volume]&, samplePackets];


	(* get all the integers we care about in the resolved ContainerOut, and turn those into replace rules to turn them into Unique[]s for the transfers below *)
	containerOutIndices = DeleteDuplicates[resolvedContainerOut[[All, 1]]];
	containerOutIndexReplaceRules = Map[
		# -> Unique[]&,
		containerOutIndices
	];

	(* make the actual primitives we're going to be using *)
	(*expandedResolvedOptions -> myResolvedOptions for now*)
	{allPrimitives, updatedSimulation} = convertTransferStepsToPrimitivesSerialDilute[
		samplePackets,
		expandedResolvedOptions,
		Cache -> inheritedCache,
		Simulation->simulation
	];

	(* get the expanded inputs converted to models *)
	(* it is important to use simulation here and not updatedSimulation because we did shenanigans to mess with the Labels above when we made updatedSimulation, *)
	(* and while that's important for below, this step needs the pre-shenanigans simulation *)
	(* note that we do NOT need to use resources here like we do in Dilute/Resuspend/Aliquot because Source can't take resources here *)
	modelExchangedInputs = If[MatchQ[resolvedPrepUOs, {_[_LabelSample]}],
		simulatedSamplesToModels[
			First[allPrimitives],
			simulation,
			expandedInputs
		],
		expandedInputs
	];


	(*If we are discarding final transfers, get waste container information out of primitives*)
	(*Normally just have one labelcontainer primitive if not discarding, use that as conditional*)
	allLabelContainers = Select[allPrimitives,MatchQ[Head[#],LabelContainer]&];
	{wasteContainers,wasteContainersLabels} = If[Length[allLabelContainers]>1,
		Module[{wasteLabelPrim},
			wasteLabelPrim = allLabelContainers[[2]]; (*labelContainerOut prim comes first usually*)
			{wasteLabelPrim[Container],wasteLabelPrim[Label]}
		],
		{Null,Null}
	];

	{resolvedPreparation, resolvedWorkCell} = Lookup[myResolvedOptions, {Preparation, WorkCell}];

	(* Resolve the experiment function (MSP/RSP/MCP/RCP) to call using the shared helper function *)
	experimentFunction = If[MatchQ[resolvedPreparation, Manual],
		resolveManualFrameworkFunction[mySamples, myResolvedOptions, Cache -> inheritedCache, Simulation -> simulation, Output -> Function],
		Lookup[$WorkCellToExperimentFunction, resolvedWorkCell]
	];

	(* make unit operation packets for the UOs we just made here *)
	{{allUnitOperationPackets, runTime}, updatedSimulation} = If[MatchQ[resolvedPreparation, Manual],
		Module[{},
			{{{}, (Length[Flatten[mySamples]] * 20 Second)}, updatedSimulation}],
		Module[{},
			experimentFunction[
				allPrimitives,
				UnitOperationPackets -> True,
				Output->{Result, Simulation},
				FastTrack -> Lookup[expandedResolvedOptions, FastTrack],
				ParentProtocol -> Lookup[expandedResolvedOptions, ParentProtocol],
				Name -> Lookup[expandedResolvedOptions, Name],
				Simulation -> updatedSimulation,
				Upload -> False,
				ImageSample -> Lookup[expandedResolvedOptions, ImageSample],
				MeasureVolume -> Lookup[expandedResolvedOptions, MeasureVolume],
				MeasureWeight -> Lookup[expandedResolvedOptions, MeasureWeight],
				Priority -> Lookup[expandedResolvedOptions, Priority],
				StartDate -> Lookup[expandedResolvedOptions, StartDate],
				HoldOrder -> Lookup[expandedResolvedOptions, HoldOrder],
				QueuePosition -> Lookup[expandedResolvedOptions, QueuePosition],
				(* We should not cover at the end of SerialDilute, instead, we should cover at the end of the RSP/RCP group. If we have more UOs to run after SerialDilute, the plate should be left uncovered. *)
				(* This option does not affect the automatic Cover added at the end of the RSP/RCP group handled in the primitive framework. *)
				CoverAtEnd -> False
			]
		]
	];

	(* determine which objects in the simulation are simulated and make replace rules for those *)
	simulatedObjectsToLabel = If[NullQ[updatedSimulation],
		{},
		Module[{allObjectsInSimulation, simulatedQ},
			(* Get all objects out of our simulation. *)
			allObjectsInSimulation = Download[Lookup[updatedSimulation[[1]], Labels][[All, 2]], Object];

			(* Figure out which objects are simulated. *)
			simulatedQ = Experiment`Private`simulatedObjectQs[allObjectsInSimulation, updatedSimulation];

			(Reverse /@ PickList[Lookup[updatedSimulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
		]
	];

	(* get the resolved options with simulated objects replaced with labels *)
	expandedResolvedOptionsWithLabels = expandedResolvedOptions /. simulatedObjectsToLabel;

	(* make the serialdilute unit operation blob *)
	serialDiluteUnitOperationBlobs = If[MatchQ[resolvedPreparation, Robotic],
		SerialDilute[
			(* this is specifically for simulated Object[Sample]s (from a series of UOs) to get converted to their label *)
			Source->modelExchangedInputs /. simulatedObjectsToLabel,
			SourceLabel->Lookup[expandedResolvedOptionsWithLabels, SourceLabel],
			SourceContainerLabel->Lookup[expandedResolvedOptionsWithLabels, SourceContainerLabel],
			SampleOutLabel->Lookup[expandedResolvedOptionsWithLabels, SampleOutLabel],
			ContainerOutLabel->Lookup[expandedResolvedOptionsWithLabels, ContainerOutLabel],
			DiluentLabel->Lookup[expandedResolvedOptionsWithLabels, DiluentLabel],
			ConcentratedBufferLabel->Lookup[expandedResolvedOptionsWithLabels, ConcentratedBufferLabel],
			BufferDiluentLabel->Lookup[expandedResolvedOptionsWithLabels, BufferDiluentLabel],
			SerialDilutionFactors->Lookup[expandedResolvedOptionsWithLabels, SerialDilutionFactors],
			NumberOfSerialDilutions->Lookup[expandedResolvedOptionsWithLabels, NumberOfSerialDilutions],
			TargetConcentrations->Lookup[expandedResolvedOptionsWithLabels, TargetConcentrations],
			Analyte->Lookup[expandedResolvedOptionsWithLabels, Analyte],
			FinalVolume->Lookup[expandedResolvedOptionsWithLabels, FinalVolume],
			BufferDilutionStrategy->Lookup[expandedResolvedOptionsWithLabels, BufferDilutionStrategy],
			TransferAmounts->Lookup[expandedResolvedOptionsWithLabels, TransferAmounts],
			Diluent->Lookup[expandedResolvedOptionsWithLabels, Diluent],
			DiluentAmount->Lookup[expandedResolvedOptionsWithLabels, DiluentAmount],
			BufferDiluent->Lookup[expandedResolvedOptionsWithLabels, BufferDiluent],
			BufferDilutionFactor->Lookup[expandedResolvedOptionsWithLabels, BufferDilutionFactor],
			BufferDiluentAmount->Lookup[expandedResolvedOptionsWithLabels, BufferDiluentAmount],
			ConcentratedBuffer->Lookup[expandedResolvedOptionsWithLabels, ConcentratedBuffer],
			ConcentratedBufferAmount->Lookup[expandedResolvedOptionsWithLabels, ConcentratedBufferAmount],
			DiscardFinalTransfer->Lookup[expandedResolvedOptionsWithLabels, DiscardFinalTransfer],
			DestinationWells->Lookup[expandedResolvedOptionsWithLabels, DestinationWells],
			ContainerOut->Lookup[expandedResolvedOptionsWithLabels, ContainerOut],
			TransferNumberOfMixes->Lookup[expandedResolvedOptionsWithLabels, TransferNumberOfMixes],
			TransferMix->Lookup[expandedResolvedOptionsWithLabels,TransferMix],
			TransferMixType->Lookup[expandedResolvedOptionsWithLabels, TransferMixType],
			(*MixUntilDissolved->Lookup[expandedResolvedOptionsWithLabels,MixUntilDissolved],*)
			IncubationTime->Lookup[expandedResolvedOptionsWithLabels,IncubationTime],
			MaxIncubationTime->Lookup[expandedResolvedOptionsWithLabels,MaxIncubationTime],
			IncubationTemperature->Lookup[expandedResolvedOptionsWithLabels,IncubationTemperature],
			Preparation->resolvedPreparation,
			WorkCell->resolvedWorkCell,
			WasteContainers->wasteContainers,
			WasteContainerLabels->wasteContainersLabels
			(*DilutionSeriesDirection->Lookup[expandedResolvedOptionsWithLabels,DilutionSeriesDirection]*)

		]
	];

	(* if we're doing robotic sample preparation, then make unit operation packets for the aliquot blob *)
	serialDiluteUnitOperationPacketsNotLinked = If[MatchQ[resolvedPreparation, Robotic],
		UploadUnitOperation[
			serialDiluteUnitOperationBlobs,
			UnitOperationType -> Input,
			FastTrack -> True,
			Upload -> False
		],
		Null
	];


	(* link the transfer unit operations to the serial dilute one *)
	serialDiluteUnitOperationPackets = If[NullQ[serialDiluteUnitOperationPacketsNotLinked],
		Null,
		Join[
			serialDiluteUnitOperationPacketsNotLinked,
			<|
				Replace[RoboticUnitOperations] -> Link[Lookup[allUnitOperationPackets, Object]]
			|>
		]
	];

	(* since we are putting this UO inside RSP, we should re-do the LabelFields so they link via RoboticUnitOperations *)
	updatedSimulation = updateLabelFieldReferences[updatedSimulation, RoboticUnitOperations];

	{protocolPackets, finalSimulation, protocolTests} = Which[
		MatchQ[resolvedPreparation, Robotic],
			{Flatten[{Null, serialDiluteUnitOperationPackets, allUnitOperationPackets}], updatedSimulation, {}},
		gatherTests,
			experimentFunction[
				allPrimitives,
				FastTrack -> Lookup[expandedResolvedOptionsWithLabels, FastTrack],
				ParentProtocol -> Lookup[expandedResolvedOptionsWithLabels, ParentProtocol],
				Name -> Lookup[expandedResolvedOptionsWithLabels, Name],
				Simulation -> updatedSimulation,
				Output -> {Result, Simulation, Tests},
				Upload -> False,
				ImageSample -> Lookup[expandedResolvedOptionsWithLabels, ImageSample],
				MeasureVolume -> Lookup[expandedResolvedOptionsWithLabels, MeasureVolume],
				MeasureWeight -> Lookup[expandedResolvedOptionsWithLabels, MeasureWeight],
				Priority -> Lookup[expandedResolvedOptionsWithLabels, Priority],
				StartDate -> Lookup[expandedResolvedOptionsWithLabels, StartDate],
				HoldOrder -> Lookup[expandedResolvedOptionsWithLabels, HoldOrder],
				QueuePosition -> Lookup[expandedResolvedOptionsWithLabels, QueuePosition]
			],
		True,
			{
				Sequence@@experimentFunction[
					allPrimitives,
					FastTrack -> Lookup[expandedResolvedOptionsWithLabels, FastTrack],
					ParentProtocol -> Lookup[expandedResolvedOptionsWithLabels, ParentProtocol],
					Name -> Lookup[expandedResolvedOptionsWithLabels, Name],
					Simulation -> updatedSimulation,
					Output -> {Result,Simulation},
					Upload -> False,
					ImageSample -> Lookup[expandedResolvedOptionsWithLabels, ImageSample],
					MeasureVolume -> Lookup[expandedResolvedOptionsWithLabels, MeasureVolume],
					MeasureWeight -> Lookup[expandedResolvedOptionsWithLabels, MeasureWeight],
					Priority -> Lookup[expandedResolvedOptionsWithLabels, Priority],
					StartDate -> Lookup[expandedResolvedOptionsWithLabels, StartDate],
					HoldOrder -> Lookup[expandedResolvedOptionsWithLabels, HoldOrder],
					QueuePosition -> Lookup[expandedResolvedOptionsWithLabels, QueuePosition]
				],
				{}
			}
	];

	(* if the protocol packet generation failed, need to return early here (with the tests, of course) *)
	(* note that we do NOT need to call fulfillableResourceQ here because ExperimentManualSamplePreparation will call it for us, and ExperimentRoboticSamplePreparation means it will get called for us later *)
	If[MemberQ[protocolPackets, $Failed] || MatchQ[protocolPackets, $Failed],
		Return[outputSpecification /. {Result -> $Failed, Tests -> protocolTests}]
	];

	(* get the protocol packet specifically and the accessory packets *)
	{protPacket, accessoryProtPackets} = {First[protocolPackets], Rest[protocolPackets]};

	(* add the ResolvedOptions/UnresolvedOptions in *)
	protPacketFinal = If[NullQ[protPacket],
		Null,
		Append[
			protPacket,
			{
				UnresolvedOptions -> DeleteCases[myUnresolvedOptions, (Verbatim[Cache] -> _) | (Verbatim[Simulation] -> _)],
				ResolvedOptions -> DeleteCases[expandedResolvedOptions, (Verbatim[Cache] -> _) | (Verbatim[Simulation] -> _)]
			}
		]
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
		Cases[Flatten[{protocolTests}], _EmeraldTest],
		Null
	];

	(* note that I am not calling fulfillableResourceQ here because ExperimentSamplePreparation will have already called it*)
	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result],
		{Flatten[{protPacketFinal, accessoryProtPackets}],(runTime+10Minute)},
		$Failed
	];

	(* generate the simulation rule *)
	simulationRule = Simulation -> finalSimulation;


	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule, simulationRule}

];

(* :: Subsubsection::Closed:: *)
(*simulateExperimentSerialDilute*)

DefineOptions[simulateExperimentSerialDilute,
	Options :> {
		CacheOption,
		SimulationOption
	}
];

(* very simple simulation function because it is entirely relying on ExperimentRobotic/ManualSamplePreparation to do the heavy lifting *)
simulateExperimentSerialDilute[
	myProtocolPacket:PacketP[{Object[Protocol, RoboticSamplePreparation], Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]}]|$Failed,
	myAccessoryPackets:{PacketP[]...}|$Failed,
	mySamples:{ObjectP[Object[Sample]]..},
	myResolvedOptions:{___Rule},
	ops:OptionsPattern[simulateExperimentSerialDilute]
]:=Module[
	{
		safeResolutionOps, cache, simulation, preparation, workCell, protocolType, protocolObject, samplePackets,
		accessoryPacketSimulation, expandedResolvedOptions, expandedInputs, sampleOutLabels, containerOutLabels,
		diluentLabels, concentratedBufferLabels, bufferDiluentLabels, sampleOutLabelFields, containerOutLabelFields,
		diluentLabelFields, concentratedBufferLabelFields, bufferDiluentLabelFields, updatedSimulation
	},

	(* pull out the cache and simulation blob now *)
	safeResolutionOps = SafeOptions[simulateExperimentSerialDilute, ToList[ops]];

	cache = Lookup[safeResolutionOps, Cache];
	simulation = If[NullQ[Lookup[safeResolutionOps, Simulation]],
		Simulation[],
		Lookup[safeResolutionOps, Simulation]
	];

	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentSerialDilute, {mySamples}, myResolvedOptions];

	(* Get the resolved preparation and resolve the protocol type. *)
	{preparation, workCell} = Lookup[myResolvedOptions, {Preparation, WorkCell}];

	(* If preparation is Robotic, determine the protocol type (RCP vs. RSP) that we want to create an ID for. *)
	protocolType = If[MatchQ[preparation, Manual],
		resolveManualFrameworkFunction[mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation, Output -> Type],
		Module[{experimentFunction},
			experimentFunction = Lookup[$WorkCellToExperimentFunction, workCell];
			Object[Protocol, ToExpression@StringDelete[ToString[experimentFunction], "Experiment"]]
		]
	];

	(* get the protocol object ID *)
	protocolObject = If[MatchQ[myProtocolPacket, $Failed],
		SimulateCreateID[protocolType],
		Lookup[myProtocolPacket, Object]
	];

	(* get the sample packets from the input samples *)
	samplePackets = Map[
		fetchPacketFromCache[#, cache]&,
		mySamples
	];

	(* pull out label field options *)
	{
		sampleOutLabels,
		containerOutLabels,
		diluentLabels,
		concentratedBufferLabels,
		bufferDiluentLabels
	} = Lookup[
		myResolvedOptions,
		{
			SampleOutLabel,
			ContainerOutLabel,
			DiluentLabel,
			ConcentratedBufferLabel,
			BufferDiluentLabel
		}
	];

	sampleOutLabelFields = MapIndexed[
		With[{index = First[#2]},
			#1 -> Field[DestinationSample[[index]]]
		]&,
		Flatten[sampleOutLabels]
	];

	containerOutLabelFields = MapIndexed[
		With[{index = First[#2]},
			#1 -> Field[ContainerOutLink[[index]]]
		]&,
		Flatten[containerOutLabels]
	];

	(* generate the extra LabelFields that we want with the AssayBufferLabel/BufferDiluentLabel/ConcentratedBufferLabel *)
	diluentLabelFields = MapIndexed[
		With[{index = First[#2]},
			If[StringQ[#1],
				#1 -> Field[DiluentLink[[index]]],
				Nothing
			]
		]&,
		Flatten[diluentLabels]
	];
	concentratedBufferLabelFields = MapIndexed[
		With[{index = First[#2]},
			If[StringQ[#1],
				#1 -> Field[ConcentratedBufferLink[[index]]],
				Nothing
			]
		]&,
		Flatten[concentratedBufferLabels]
	];

	bufferDiluentLabelFields = MapIndexed[
		With[{index = First[#2]},
			If[StringQ[#1],
				#1 -> Field[BufferDiluentLink[[index]]],
				Nothing
			]
		]&,
		Flatten[bufferDiluentLabels]
	];

	(* replace the LabelFields key in the old simulation blob to make a new one *)
	(* only do this for manual; for robotic, we don't change anything here because it is magic and handles itself properly *)
	updatedSimulation = If[MatchQ[preparation, Manual],
		UpdateSimulation[
			simulation,
			Simulation[LabelFields -> Flatten[{sampleOutLabelFields, containerOutLabelFields, concentratedBufferLabelFields, bufferDiluentLabelFields, diluentLabelFields}]]
		],
		simulation
	];

	(* NOTE: SimulateResources requires you to have a protocol object, so just make a fake one to simulate our unit operation. *)
	accessoryPacketSimulation = Module[{protocolPacket},
		protocolPacket = <|
			Object -> SimulateCreateID[protocolType],
			Replace[OutputUnitOperations] -> Link[
				Lookup[
					Cases[
						myAccessoryPackets,
						Except[PacketP[Object[UnitOperation, SerialDilute]],
							PacketP[Object[UnitOperation]]]], Object, {}],
					Protocol],
			(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
			(* simulate resources will NOT simulate them for you. *)
			(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
			Replace[RequiredObjects] -> DeleteDuplicates[
				Cases[Lookup[Cases[myAccessoryPackets, PacketP[]], Object, {}], Resource[KeyValuePattern[Type -> Except[Object[Resource, Instrument]]]], Infinity]
			],
			Replace[RequiredInstruments] -> DeleteDuplicates[
				Cases[Lookup[Cases[myAccessoryPackets, PacketP[]], Object, {}], Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]], Infinity]
			],
			ResolvedOptions -> {}
		|>;
		If[MatchQ[Cases[myAccessoryPackets, PacketP[]], {}],
			updatedSimulation,
			SimulateResources[
				protocolPacket,
				(* want to exclude accessory packets that don't have the Object key because seemingly SimulateResources freaks out at that (like notifications and procedure events) *)
				Cases[myAccessoryPackets, KeyValuePattern[{Object -> _}]],
				ParentProtocol -> Lookup[ToList[myResolvedOptions], ParentProtocol, Null],
				Simulation -> simulation
			]
		]
	];

	(* merge the simulation we started with with what we have now *)
	{
		protocolObject,
		UpdateSimulation[updatedSimulation, accessoryPacketSimulation]
	}

];

(* ::Subsubsection::Closed:: *)
(* resolveSerialDiluteMethod *)

DefineOptions[resolveSerialDiluteMethod,
	SharedOptions:>{
		ExperimentSerialDilute,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveSerialDiluteMethod[mySamples:ObjectP[{Object[Sample], Object[Container]}] | {ListableP[ObjectP[{Object[Sample], Object[Container]}]]..}, myOptions:OptionsPattern[]]:=Module[
	{specifiedOptions, resolvedOptions, outputSpecification, methodResolutionOptions, method},

	(* get the output specification *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];

	(* get the options that were provided *)
	specifiedOptions = ToList[myOptions];

	(* replace the options with Output -> Options and ResolveMethod -> True *)
	methodResolutionOptions = ReplaceRule[specifiedOptions, {Output -> Options, ResolveMethod -> True}];

	(* get the resolved options, and whether we're Robotic or Manual *)
	resolvedOptions = ExperimentSerialDilute[mySamples, methodResolutionOptions];
	method = Lookup[resolvedOptions, Preparation];

	outputSpecification /. {Result -> method, Tests -> {}, Preview -> Null, Options -> methodResolutionOptions}

];


(* ::Subsection:: *)
(*resolveSerialDiluteWorkCell*)

DefineOptions[resolveSerialDiluteWorkCell,
	SharedOptions :> {
		ExperimentSerialDilute,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveSerialDiluteWorkCell[
	mySamples: ObjectP[{Object[Sample], Object[Container], Model[Sample]}] | {ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]]..},
	myOptions: OptionsPattern[]
] := Module[{safeOptions, cache, simulation, workCell, preparation},

	(* Get our safe options. *)
	safeOptions = SafeOptions[resolveSerialDiluteWorkCell, ToList[myOptions]];
	{cache, simulation, workCell, preparation} = Lookup[safeOptions, {Cache, Simulation, WorkCell, Preparation}];

	(* Determine the WorkCell that can be used *)
	If[MatchQ[workCell, WorkCellP|Null],
		(* If WorkCell is specified, use that *)
		{workCell}/.{Null} -> {},
		(* Otherwise, use helper function to resolve potential work cells based on experiment options and sample properties *)
		(* Note: there is no Sterile or SterileTechnique for ExperimentSerialDilute *)
		resolvePotentialWorkCells[Flatten[{mySamples}], {Preparation -> preparation}, Cache -> cache, Simulation -> simulation]
	]
];
