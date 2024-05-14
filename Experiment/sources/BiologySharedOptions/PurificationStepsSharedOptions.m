(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*PurificationStepsSharedOptions*)

(* ::Subsubsection::Closed:: *)
(*PurificationStepsSharedOptions*)

DefineOptions[
	PurificationStepsSharedOptions,
	Options :> {

		{
			OptionName -> Purification,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[
				"One Purification Step" -> Widget[
					Type -> Enumeration,
					Pattern :> (LiquidLiquidExtraction | Precipitation | SolidPhaseExtraction | MagneticBeadSeparation)
				],
				"Multiple Purification Steps" -> Adder[
					Widget[
						Type -> Enumeration,
						Pattern :> (LiquidLiquidExtraction | Precipitation | SolidPhaseExtraction | MagneticBeadSeparation)
					]
				],
				"No Purification Steps" -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[None]
				]
			],
			Description -> "Indicates the number of rudimentary purification steps, which techniques each step will use, and in what order the techniques will be carried out to isolate the target cell component. There are four rudimentary purification techniques: liquid-liquid extraction, precipitation, solid phase extraction (also known as using \"spin columns\"), and magnetic bead separation. Each technique can be run up to three times each and can be run in any order (as specified by the order of the list). Additional purification steps such as these or more advanced purification steps such as HPLC, FPLC, gels, etc. can be performed on the final product using scripts which call the corresponding functions (ExperimentLiquidLiquidExtraction, ExperimentPrecipitate, ExperimentSolidPhaseExtraction, ExperimentMagneticBeadSeparation, ExperimentHPLC, ExperimentFPLC, ExperimentAgaroseGelElectrophoresis, etc.).",
			ResolutionDescription -> "Automatically set to the Purification steps specified by the selected Method. If Method is set to Custom, Purification is set based on any already set options pertaining to a specific rudimentary purification type. For example, if AqueousSolvent is specified, a LiquidLiquidExtraction step is added to Purification. Purification steps added this way are only added once and they are added in the following order: LiquidLiquidExtraction, Precipitation, SolidPhaseExtraction, then MagneticBeadSeparation. Otherwise, Purification is set to a LiquidLiquidExtraction followed by a Precipitation.",
			Category -> "General"
		},

		ExtractionLiquidLiquidSharedOptions,
		ExtractionPrecipitationSharedOptions,
		(* NOTE: Temperature options hidden because SPE currently doesn't support non-ambient solution temperatures for robotic protocols. *)
		ModifyOptions[ExtractionSolidPhaseSharedOptions,
			ToExpression[Keys[
				KeyDrop[
					Options[ExtractionSolidPhaseSharedOptions],
					{Key["SolidPhaseExtractionLoadingTemperature"], Key["SolidPhaseExtractionLoadingTemperatureEquilibrationTime"], Key["SolidPhaseExtractionWashTemperature"], Key["SolidPhaseExtractionWashTemperatureEquilibrationTime"], Key["SecondarySolidPhaseExtractionWashTemperature"], Key["SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime"], Key["TertiarySolidPhaseExtractionWashTemperature"], Key["TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime"], Key["SolidPhaseExtractionElutionSolutionTemperature"], Key["SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime"]}
				]
			]]
		],
		ModifyOptions[ExtractionSolidPhaseSharedOptions,
			{
				SolidPhaseExtractionLoadingTemperature, SolidPhaseExtractionLoadingTemperatureEquilibrationTime,
				SolidPhaseExtractionWashTemperature, SolidPhaseExtractionWashTemperatureEquilibrationTime,
				SecondarySolidPhaseExtractionWashTemperature, SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,
				TertiarySolidPhaseExtractionWashTemperature, TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,
				SolidPhaseExtractionElutionSolutionTemperature, SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime
			},
			{
				Category -> "Hidden"
			}
		],
		ExtractionMagneticBeadSharedOptions

	}
];


(* ::Subsection::Closed:: *)
(* Shared Options Lists *)

$PurificationTechniqueToContainerOutOption = {
	LiquidLiquidExtraction -> {TargetContainerOutWell, TargetContainerOut},
	SolidPhaseExtraction -> {ElutingSolutionCollectionContainer, SolidPhaseExtractionLoadingFlowthroughContainerOut},
	MagneticBeadSeparation -> {MagneticBeadSeparationElutionCollectionContainer,MagneticBeadSeparationLoadingCollectionContainer},
	Precipitation -> {PrecipitatedSampleContainerOut, UnprecipitatedSampleContainerOut}
};

$PrecipitationSharedOptions = ToExpression[Keys[Options[ExtractionPrecipitationSharedOptions]]];
$MagneticBeadSeparationSharedOptions = ToExpression[Keys[Options[ExtractionMagneticBeadSharedOptions]]];
$SolidPhaseExtractionSharedOptions = ToExpression[Keys[Options[ExtractionSolidPhaseSharedOptions]]];
$LiquidLiquidExtractionSharedOptions = ToExpression[Keys[Options[ExtractionLiquidLiquidSharedOptions]]];


(* ::Subsubsection::Closed:: *)
(*resolvePurification*)

resolvePurification[myMapThreadFriendlyOptions:{__Association}, myMethods:{(ObjectP[Object[Method]]|Custom)..}]:=MapThread[
	Function[{options, method},
		(* Is the purification options already specified by the user? *)
		Which[
			(* Is the purification options already specified by the user? *)
			MatchQ[Lookup[options, Purification], Except[Automatic]],
				Lookup[options, Purification],
			(* Is purification specified by the method? *)
			MatchQ[method, ObjectP[Object[Method]]] && MatchQ[Download[method, Purification], Except[Null]],
				Download[method, Purification],
			(* Are any LLE, Precipitation, SPE, or MBS options set? If not, then defaults to LLE followed by Precipitation. *)
			MatchQ[
				Map[
					MemberQ[ToList[Lookup[options,#,Null]],Except[Automatic|Null|{Automatic,Automatic}]]&,
					Keys[Join[$LLEPurificationOptionMap, $PrecipitationSharedOptionMap, $SPEPurificationOptionMap, $MBSPurificationOptionMap]]
				],
				{False...}
			],
				{LiquidLiquidExtraction, Precipitation},
			(* Otherwise, adds techniques based on any purification technique options already set. *)
			True,
			{
				(* Are any of the LLE options set? *)
				Module[{lleSpecifiedQ},
					lleSpecifiedQ=Or@@Map[
						MemberQ[ToList[Lookup[options,#,Null]],Except[Automatic|Null|{Automatic,Automatic}]]&,
						Keys[$LLEPurificationOptionMap]
					];
					If[lleSpecifiedQ,
						LiquidLiquidExtraction,
						Nothing
					]
				],
				(* Are any of the Precipitation options set? *)
				Module[{precipitationSpecifiedQ},
					precipitationSpecifiedQ=Or@@Map[
						MemberQ[ToList[Lookup[options,#,Null]],Except[Automatic|Null|{Automatic,Automatic}]]&,
						Keys[$PrecipitationSharedOptionMap]
					];

					If[precipitationSpecifiedQ,
						Precipitation,
						Nothing
					]
				],
				(* Are any of the SPE options set? *)
				Module[{speSpecifiedQ},
					speSpecifiedQ=Or@@Map[
						MemberQ[ToList[Lookup[options,#,Null]],Except[Automatic|Null|{Automatic,Automatic}]]&,
						Keys[$SPEPurificationOptionMap]
					];
					If[speSpecifiedQ,
						SolidPhaseExtraction,
						Nothing
					]
				],
				(* Are any of the MBS options set? *)
				Module[{mbsSpecifiedQ},
					mbsSpecifiedQ=Or@@Map[
						MemberQ[ToList[Lookup[options,#,Null]],Except[Automatic|Null|{Automatic,Automatic}]]&,
						Keys[$MBSPurificationOptionMap]
					];

					If[mbsSpecifiedQ,
						MagneticBeadSeparation,
						Nothing
					]
				]
			}
		]
	],
	{myMapThreadFriendlyOptions, myMethods}
];

(* ::Subsubsection::Closed:: *)
(*preResolvePurificationSharedOptions*)

DefineOptions[
	preResolvePurificationSharedOptions,
	Options:>{
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName->TargetCellularComponent,
				Default->Unspecified,
				AllowNull->False,
				Widget->Alternatives[
					"Unspecified" -> Widget[Type->Enumeration, Pattern:>Alternatives[Unspecified]],
					"Cellular Component(s)" -> Widget[Type->Enumeration, Pattern:>Alternatives[CellularComponentP]],
					"RNA" -> Widget[Type->Enumeration, Pattern:>CellularRNAP],
					"Molecule" -> Widget[Type->Object, Pattern:>ObjectP[Model[Molecule]]]
				],
				Description->"The desired cellular component to be isolated by the purification steps.",
				Category -> "General"
			}
		],
		HelperOutputOption,
		CacheOption,
		SimulationOption,
		DebugOption
	}
];


preResolvePurificationSharedOptions[mySamples:{ObjectP[Object[Sample]]...}, myOptions_List, myMapThreadOptions:{_Association..}, myResolutionOptions:OptionsPattern[preResolvePurificationSharedOptions]] := Module[{safeOps, cache, simulation, methods, purification, preResolvedLLEOptions, preResolvedPrecipitateOptions, preResolvedSPEOptions, preResolvedMBSOptions},

	(*Pull out the safe options.*)
	safeOps = SafeOptions[preResolvePurificationSharedOptions, ToList[myResolutionOptions]];

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[safeOps], Cache, {}];
	simulation = Lookup[ToList[safeOps], Simulation, Null];

	(* Pull out methods and purification option value to use for resolving. *)
	methods = Lookup[myOptions, Method];
	purification = Lookup[myOptions, Purification];

	preResolvedLLEOptions = If[MemberQ[Flatten[purification], LiquidLiquidExtraction] || MatchQ[purification, LiquidLiquidExtraction],
		preResolveLiquidLiquidExtractionSharedOptions[
			mySamples,
			methods,
			$LLEPurificationOptionMap,
			myOptions,
			myMapThreadOptions,
			Cache -> cache,
			Simulation -> simulation
		],
		{}
	];

	preResolvedPrecipitateOptions = If[MemberQ[Flatten[purification], Precipitation] || MatchQ[purification, Precipitation],
     preResolvePrecipitationSharedOptions[
			mySamples,
			methods,
			$PrecipitationSharedOptionMap,
			myOptions,
			myMapThreadOptions,
			Cache -> cache,
			Simulation -> simulation
		],
		{}
	];

	preResolvedSPEOptions = If[MemberQ[Flatten[purification], SolidPhaseExtraction] || MatchQ[purification, SolidPhaseExtraction],
     preResolveExtractionSolidPhaseSharedOptions[
			mySamples,
			methods,
			$SPEPurificationOptionMap,
			myOptions,
			myMapThreadOptions,
			Cache -> cache,
			Simulation -> simulation,
	        TargetCellularComponent -> Lookup[safeOps, TargetCellularComponent]
        ],
		{}
	];

	preResolvedMBSOptions = If[MemberQ[Flatten[purification], MagneticBeadSeparation] || MatchQ[purification, MagneticBeadSeparation],
		preResolveMagneticBeadSeparationSharedOptions[
			mySamples,
			methods,
			$MBSPurificationOptionMap,
			myOptions,
			myMapThreadOptions,
			Cache -> cache,
			Simulation -> simulation,
			TargetCellularComponent -> Lookup[safeOps, TargetCellularComponent]
		],
		{}
	];

	Flatten[
		{
			preResolvedLLEOptions,
			preResolvedPrecipitateOptions,
			preResolvedSPEOptions,
			preResolvedMBSOptions
		}
	]

];


(* ::Subsubsection::Closed:: *)
(*buildPurificationUnitOperations*)

DefineOptions[
	buildPurificationUnitOperations,
	Options:>{
		CacheOption,
		SimulationOption
	}
];

buildPurificationUnitOperations[
	mySamples_List,
	myResolvedOptions_List,
	myMapThreadFriendlyOptions_List,
	myContainerOutLabelOptionName_Symbol,
	mySampleOutLabelOptionName_Symbol,
	myResolutionOptions:OptionsPattern[buildPurificationUnitOperations]
] := Module[
	{
		safeOptions, cache, currentSimulation,
		workingSamples, transposedResolvedPurifications, orderOfResolvers, purificationUnitOperations
	},

	(* Get our safe options. *)
	safeOptions = SafeOptions[buildPurificationUnitOperations, ToList[myResolutionOptions]];

	(* Lookup cache and simulation *)
	cache = Lookup[safeOptions, Cache];
	currentSimulation = Lookup[safeOptions, Simulation];

	(* set up working samples that can be updated in each round of purification *)
	workingSamples = mySamples;

	(* Transpose our purification master switch option. *)
	(* NOTE: We have to PadRight here since our purification rounds may not be of the same length. *)
	transposedResolvedPurifications = Transpose@PadRight[ToList/@Lookup[myResolvedOptions, Purification], Automatic, Null];

	orderOfResolvers = {LiquidLiquidExtraction, Precipitation, SolidPhaseExtraction, MagneticBeadSeparation};

	(* Output of this should be a list of lists of the purification unit operations for each round of purification *)
	purificationUnitOperations = MapThread[
		Function[{purificationTechniquesForRound, purificationRoundIndex},
			Map[
				Function[{purificationTechnique},
					(* Output of this Module should be a list of the purification unit operations for this round of purification *)
					Module[{purificationSamples, purificationSampleIndices},

						(* Get the samples that are going to be purified by the current technique *)
						(* Also get the sample indices which will be used to determine whether we are on the final round for that sample *)
						purificationSamples = PickList[workingSamples, purificationTechniquesForRound, purificationTechnique];
						purificationSampleIndices = PickList[Range[Length[workingSamples]], purificationTechniquesForRound, purificationTechnique];

						If[Length[purificationSamples] > 0,
							Module[
								{
									purificationMapThreadFriendlyOptions,
									primitiveFunction, optionMap, containerOutOption, containerOutLabelOption, sampleOutLabelOption,
									newSampleOutLabels, containerOutRules, containerOutLabelsWithFinalRoundContainerLabels,
									purificationRoundPrimitives, samplesOutStorageConditionOption, samplesOutStorageConditionValues,
									preFilteredPurificationOptions, purificationOptions
								},

								(* Get the map thread friendly options that correspond *)
								(* to the samples that we'll be operating on during this extraction round *)
								purificationMapThreadFriendlyOptions = If[MatchQ[purificationTechnique, MagneticBeadSeparation],
									(*If the technique for this round is MBS, it requires manual expansion of mapthread options for container and container label options*)
									(*MBS container and container label options only need to be manually expanded if they are resolved prior to calling buildPurificationUnitOperations*)
									(*If these options are left as Automatic, no need to expand*)
									Module[{mbsMapThreadOptions,singletonP},
										singletonP = Alternatives[
											Except[_List],
											{_Integer, ObjectP[]},
											{_String,ObjectP[]},
											{_String,{_Integer,ObjectP[]}}
										];
										mbsMapThreadOptions=PickList[myMapThreadFriendlyOptions, purificationTechniquesForRound, purificationTechnique];
										MapThread[
											Function[{options, index},
												Merge[
													{
														options,
														Association@Map[
															If[!MatchQ[Lookup[options, #], singletonP],
																# -> Lookup[options, #][[index]],
																# -> Lookup[options, #]
															]&,
															{MagneticBeadSeparationPreWashCollectionContainerLabel, MagneticBeadSeparationEquilibrationCollectionContainerLabel, MagneticBeadSeparationLoadingCollectionContainerLabel, MagneticBeadSeparationWashCollectionContainerLabel, MagneticBeadSeparationSecondaryWashCollectionContainerLabel, MagneticBeadSeparationTertiaryWashCollectionContainerLabel, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel, MagneticBeadSeparationQuinaryWashCollectionContainerLabel, MagneticBeadSeparationSenaryWashCollectionContainerLabel, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel, MagneticBeadSeparationElutionCollectionContainerLabel,
																MagneticBeadSeparationPreWashCollectionContainer, MagneticBeadSeparationEquilibrationCollectionContainer, MagneticBeadSeparationLoadingCollectionContainer, MagneticBeadSeparationWashCollectionContainer, MagneticBeadSeparationSecondaryWashCollectionContainer, MagneticBeadSeparationTertiaryWashCollectionContainer, MagneticBeadSeparationQuaternaryWashCollectionContainer, MagneticBeadSeparationQuinaryWashCollectionContainer, MagneticBeadSeparationSenaryWashCollectionContainer, MagneticBeadSeparationSeptenaryWashCollectionContainer,MagneticBeadSeparationElutionCollectionContainer
															}
														]
													},
													Last
												]
											],
											{mbsMapThreadOptions, Range[Length[mbsMapThreadOptions]]}
										]
									],
									(*If the technique is not MBS, just pick the relevant options*)
									PickList[myMapThreadFriendlyOptions, purificationTechniquesForRound, purificationTechnique]
								];

								(* Determine which primitive we are calling, *)
								(* which option map we are using (option maps in the format {SharedOption -> OriginalOption ..}),*)
								(* and what the output options are for ContainerOut, ContainerOutLabel, and SampleOutLabel. *)
								{
									primitiveFunction,
									optionMap,
									containerOutOption,
									containerOutLabelOption,
									samplesOutStorageConditionOption,
									sampleOutLabelOption
								} = Switch[purificationTechnique,
									LiquidLiquidExtraction,
										{
											LiquidLiquidExtraction,
											$LLEPurificationOptionMap,
											{TargetContainerOutWell, TargetContainerOut},
											TargetContainerLabel,
											TargetStorageCondition,
											TargetLabel
										},
									Precipitation,
										{
											Precipitate,
											$PrecipitationSharedOptionMap,
											If[MatchQ[Lookup[purificationMapThreadFriendlyOptions, PrecipitationTargetPhase], ListableP[Solid|Automatic]],
												Sequence@@{
													PrecipitatedSampleContainerOut,
													PrecipitatedSampleContainerLabel,
													PrecipitatedSampleStorageCondition,
													PrecipitatedSampleLabel
												},
												Sequence@@{
													UnprecipitatedSampleContainerOut,
													UnprecipitatedSampleContainerLabel,
													UnprecipitatedSampleStorageCondition,
													UnprecipitatedSampleLabel
												}
											]
										},
									SolidPhaseExtraction,
										{
											SolidPhaseExtraction,
											$SPEPurificationOptionMap,
											ElutingSolutionCollectionContainer,
											ElutingCollectionContainerOutLabel,
											SamplesOutStorageCondition,
											ElutingSampleOutLabel
										},
									_,
										{
											MagneticBeadSeparation,
											$MBSPurificationOptionMap,
											If[MatchQ[Lookup[purificationMapThreadFriendlyOptions, MagneticBeadSeparationSelectionStrategy], ListableP[Positive|Automatic]],
												Sequence@@{
													ElutionCollectionContainer,
													ElutionCollectionContainerLabel,
													ElutionCollectionStorageCondition
												},
												Sequence@@{
													LoadingCollectionContainer,
													LoadingCollectionContainerLabel,
													LoadingCollectionStorageCondition
												}
											],
											SampleOutLabel
										}
								];

								(* make a list of new sample labels the length of the purification samples *)
								(* the workingSamples will be updated with the new sample labels in order to feed in to the next round of purification *)
								newSampleOutLabels = Map[
									Function[{purificationSample},
										CreateUniqueLabel[StringJoin[ToString[purificationTechnique], " purification during round ",ToString[purificationRoundIndex]," sample out label"]]
									],
									purificationSamples
								];

								(* Replace the intermediate container labels with the user-set ExtractedBLAHContainerLabel options if they're *)
								(* specified by the user for this sample and we're on the last purification round and technique for this sample. *)
								containerOutLabelsWithFinalRoundContainerLabels = Map[
									Function[{options},
										If[purificationRoundIndex == Length[Lookup[options, Purification]],
											Lookup[options, myContainerOutLabelOptionName],
											Automatic
										]
									],
									purificationMapThreadFriendlyOptions
								];

								(* Replace the storage condition option with our SamplesOutStorageCondition (if we are on the last purification round) *)
								samplesOutStorageConditionValues = Map[
									Function[{options},
										If[purificationRoundIndex == Length[Lookup[options, Purification]],
											(* If final step is Precipitation, Null for SamplesOutStorageCondition is Automatic for Precipitated/UnprecipitatedSampleStorageCondition. *)
											(* NOTE: Null likely should be fine as a storage condition in ExperimentPrecipitate. Added defensive manouver here and checking with Tim now. *)
											If[
												MatchQ[purificationTechnique, (Precipitation | MagneticBeadSeparation)] && MatchQ[Lookup[options, SamplesOutStorageCondition], Null],
												Automatic,
												Lookup[options, SamplesOutStorageCondition]
											],
											Automatic
										]
									],
									purificationMapThreadFriendlyOptions
								];

								(* If we're on the last purification round, replace the purification technique ContainerOut option *)
								(* with the ContainerOut option of the main experiment. *)
								containerOutRules = Module[{containerOutValues},

									(* Get the modified ContainerOut values that are formatted to be input into the unit operations. *)
									containerOutValues = MapThread[
										Function[{sample, options, sampleIndex},
											(* Are we on the last purification round? *)
											If[purificationRoundIndex == Length[Lookup[options, Purification]],
												(* Based on the technique of the last round, prep ContainerOut value to go into the unit operation. *)
												Switch[purificationTechnique,
													SolidPhaseExtraction,
													(* For SPE, container needs to be removed from wells and index in ContainerOut to be fed into *)
													(* unit operation if selection strategy is Positive (via ElutingSolutionCollectionContainer). *)
													(* NOTE: Currently can't feed in the well assignment into SPE for ContainerOut. Can technically input the *)
													(* index by labeling a container first and then adding as labeled option as well, but simplifying for now. *)
														Module[{extractionStrategy, containerOut, containerOutWells, containerOutWithoutWellsOrIndex},

															(* Lookup the relevant options. *)
															{extractionStrategy, containerOut} = ToList[Lookup[options, {SolidPhaseExtractionStrategy, ContainerOut}]];

															(* Get containers without wells or indexes to feed into SPE. *)
															containerOutWithoutWellsOrIndex = Which[
																(* If the user specified ContainerOut using the "Container with Well" widget format, remove the well. *)
																MatchQ[containerOut, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container],Model[Container]}]}],
																	Last[containerOut],
																(* If the user specified ContainerOut using the "Container with Index" widget format, remove the index. *)
																MatchQ[containerOut, {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}],
																	Last[containerOut],
																(* If the user specified ContainerOut using the "Container with Well and Index" widget format, remove the well and Index. *)
																MatchQ[containerOut, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}}],
																	Last[Last[containerOut]],
																(* If the user specified ContainerOut any other way, we don't have to mess with it here. *)
																True,
																	Sequence@@ToList[containerOut]
															];

															(* If extraction strategy is Positive, then return the ElutingSolutionCollectionContainer value. *)
															If[
																MatchQ[extractionStrategy, Positive],
																containerOutWithoutWellsOrIndex,
																Automatic
															]

														],
													LiquidLiquidExtraction, (* not sure about MBS or even Precipitate here? *)
														(* For LLE, ContainerOut needs to be split into well and container to go into unit operation *)
														(* via TargetContainerOutWell and TargetContainerOut (not in shared options). *)
														Module[{containerOut, containerOutWells, containerOutWithoutWells},

															(* Lookup the ContainerOut. *)
															containerOut = Lookup[options, ContainerOut];

															(* Get any wells from user-specified container out inputs according to their widget patterns. *)
															containerOutWells = Which[
																(* If ContainerOut specified using the "Container with Well" widget format, extract the well. *)
																MatchQ[containerOut, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container],Model[Container]}]}],
																	First[containerOut],
																(* If ContainerOut specified using the "Container with Well and Index" widget format, extract the well. *)
																MatchQ[containerOut, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}}],
																	First[containerOut],
																(* Otherwise, there isn't a well specified and we set this to automatic. *)
																True,
																	Automatic
															];

															(* Get containers without wells to feed into LLE. *)
															containerOutWithoutWells = Which[
																(* If the user specified ContainerOut using the "Container with Well" widget format, remove the well. *)
																MatchQ[containerOut, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container],Model[Container]}]}],
																	Last[containerOut],
																(* If the user specified ContainerOut using the "Container with Well and Index" widget format, remove the well. *)
																MatchQ[containerOut, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}}],
																	Last[containerOut],
																(* If the user specified ContainerOut any other way, we don't have to mess with it here. *)
																True,
																	containerOut
															];

															{containerOutWells, containerOutWithoutWells}

														],
													Precipitation,
														(* For Precipitation, the container out options are already in the mapthread, so we don't *)
														(* need to feed them in separately. *)
														Module[{containerOut, containerOutWithoutWellsOrIndex},

															(* Lookup the ContainerOut. *)
															containerOut = ToList[Lookup[options, ContainerOut]];

															(* Get containers without wells or indexes to feed into Precipitation or MBS. *)
															containerOutWithoutWellsOrIndex = Which[
																(* If the user specified ContainerOut using the "Container with Well" widget format, remove the well. *)
																MatchQ[containerOut, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Object[Container],Model[Container]}]}],
																	Last[containerOut],
																(* If the user specified ContainerOut using the "Container with Index" widget format, remove the index. *)
																MatchQ[containerOut, {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}],
																	Last[containerOut],
																(* If the user specified ContainerOut using the "Container with Well and Index" widget format, remove the well and Index. *)
																MatchQ[containerOut, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Object[Container],Model[Container]}]}}],
																	Last[Last[containerOut]],
																(* If the user specified ContainerOut any other way, we don't have to mess with it here. *)
																True,
																	Sequence@@ToList[containerOut]
															];

															containerOutWithoutWellsOrIndex

														],

													MagneticBeadSeparation,
														(* For MBS, the container out options need a different level of nestiness. *)
														Module[{containerOut},

															(* Lookup the ContainerOut. *)
															containerOut = Which[
																MatchQ[ToList[Lookup[options, ContainerOut]], ListableP[Automatic]] && MatchQ[Lookup[options, MagneticBeadSeparationSelectionStrategy], Positive],
																	Lookup[myResolvedOptions,MagneticBeadSeparationElutionCollectionContainer][[sampleIndex]],
																MatchQ[ToList[Lookup[options, ContainerOut]], ListableP[Automatic]] && MatchQ[Lookup[options, MagneticBeadSeparationSelectionStrategy], Negative],
																	Lookup[myResolvedOptions,MagneticBeadSeparationLoadingCollectionContainer][[sampleIndex]],
																_,
																	Lookup[options, ContainerOut]
															]
														]
												],
												Automatic
											]
										],
										{purificationSamples, purificationMapThreadFriendlyOptions,Range[Length[purificationSamples]]}
									];

									(* Build a list of rules to be added to the unit operation to make sure the last container that the *)
									(* sample is in matches the ContainerOut. *)
									Switch[purificationTechnique,
										(* For SPE, ElutingSolutionCollectionContainer -> newvalue since it is not in shared options. *)
										SolidPhaseExtraction|Precipitation|MagneticBeadSeparation,
											{containerOutOption -> containerOutValues},
										(* For LLE, TargetContainerOut -> <new container value> & TargetContainerOutWell -> <new well value> *)
										(* since they are not in shared options. *)
										LiquidLiquidExtraction,
											Module[{transposableContainerOutValues, transposedContainerOutValues},

												(* Make containerOUtValues "transpose-able" with Automatics. *)
												transposableContainerOutValues = Map[
													If[MatchQ[#, Automatic],
														{Automatic, Automatic},
														#
													]&,
													containerOutValues
												];

												(* {{well, container}..} -> {{wells},{containers}} *)
												transposedContainerOutValues = Transpose[transposableContainerOutValues];

												(* TargetContainerOutWell -> {wells}, TargetContainerOUt -> {containers} *)
												MapThread[
													#1 -> #2&,
													{containerOutOption, transposedContainerOutValues}
												]

											]
									]

								];

								(* Call the purification primitive: *)
								(* input the sample (or list of samples) and the resolved shared options for that experiment function *)
								(* use the optionMap to convert the shared option names to the child function option names *)
								(* output a single primitive containing listed samples and option values *)
								(* note that first we need to remove any Automatics that shouldn't be here at this stage just in case *)
								preFilteredPurificationOptions = {
									(*sample or list of samples that get the current purification technique during the current round *)
									Sample -> purificationSamples,
									(*from the map thread options for these samples, take out the options that are in the shared option set, and replace the shared option names with the child function option names *)
									Sequence@@ReplaceRule[
										Map[
											Function[{optionRule},
												optionRule[[2]] -> Lookup[purificationMapThreadFriendlyOptions, optionRule[[1]]]
											],
											optionMap
										],
										{
											containerOutLabelOption -> containerOutLabelsWithFinalRoundContainerLabels,
											sampleOutLabelOption -> newSampleOutLabels,
											samplesOutStorageConditionOption -> samplesOutStorageConditionValues,
											Sequence@@containerOutRules,
											Switch[purificationTechnique,
												Precipitation,
												Sequence@@{
													RoboticInstrument -> Lookup[myResolvedOptions, RoboticInstrument]
												},
												MagneticBeadSeparation,
												Sequence@@{
													SeparationMode -> Lookup[myResolvedOptions, MagneticBeadSeparationMode],
													SelectionStrategy -> Lookup[myResolvedOptions, MagneticBeadSeparationSelectionStrategy]
												},
												SolidPhaseExtraction,
												Sequence@@{
													PreFlushing -> False,
													Conditioning -> False,
													(*Translate our masterswitches to SPE masterswitches, otherwise the SPE might still resolves to masterswitch->True but will crash with the buffer set to Null*)
													Washing -> translateSharedSPEMasterswitch[myResolvedOptions,Wash],
													SecondaryWashing -> translateSharedSPEMasterswitch[myResolvedOptions,SecondaryWash],
													TertiaryWashing -> translateSharedSPEMasterswitch[myResolvedOptions,TertiaryWash],
													Eluting -> translateSharedSPEMasterswitch[myResolvedOptions,Elution]
												},
												_,
												Sequence@@{
													TargetAnalyte -> Null,
													(* NOTE: If LLE Extraction Container is Null, then no alliquotting needed and can remain Null. *)
													SampleVolume -> (Lookup[myResolvedOptions,LiquidLiquidExtractionContainer] /. (Except[Null] -> All))
												}
											],
											Sequence@@{
												WorkCell -> Lookup[myResolvedOptions, WorkCell],
												Preparation -> Robotic
											}
										}
									]
								};

								purificationOptions = removeConflictingNonAutomaticOptions[primitiveFunction, preFilteredPurificationOptions];

								purificationRoundPrimitives = primitiveFunction[purificationOptions];

								(* update the workingSamples with the new label *)
								workingSamples = ReplaceAll[
									workingSamples,
									MapThread[
										Function[
											{prePurificationSample, postPurificationSample},
											prePurificationSample -> postPurificationSample
										],
										{purificationSamples, newSampleOutLabels}
									]
								];
								purificationRoundPrimitives
							],
							Nothing
						]
					]
				],
				orderOfResolvers
			]
		],
		{transposedResolvedPurifications, Range[Length[transposedResolvedPurifications]]}
	];

	{workingSamples, Flatten[purificationUnitOperations]}

];


(* ::Subsection::Closed:: *)
(* purificationSharedOptionsTests *)

Error::LiquidLiquidExtractionStepCountLimitExceeded = "The sample(s), `1`, at indices, `3`, have too many liquid-liquid extraction purification steps specified in the Purification option: `2`. The maximum number of purification steps of one type per extraction is 3. Please remove liquid-liquid extractions from the purification list until there are 3 or fewer and call another extraction or ExperimentLiquidLiquidExtraction if more liquid-liquid extractions are required.";
Error::PrecipitationStepCountLimitExceeded = "The sample(s), `1`, at indices, `3`, have too many precipitation purification steps specified in the Purification option: `2`. The maximum number of purification steps of one type per extraction is 3. Please remove precipitations from the purification list until there are 3 or fewer and call another extraction or ExperimentPrecipitate if more precipitations are required.";
Error::SolidPhaseExtractionStepCountLimitExceeded = "The sample(s), `1`, at indices, `3`, have too many solid phase extraction purification steps specified in the Purification option: `2`. The maximum number of purification steps of one type per extraction is 3. Please remove solid phase extractions from the purification list until there are 3 or fewer and call another extraction or ExperimentSolidPhaseExtraction if more solid phase extractions are required.";
Error::MagneticBeadSeparationStepCountLimitExceeded = "The sample(s), `1`, at indices, `3`, have too many magnetic bead separation purification steps specified in the Purification option: `2`. The maximum number of purification steps of one type per extraction is 3. Please remove magnetic bead separations from the purification list until there are 3 or fewer and call another extraction or ExperimentMagneticBeadSeparation if more magnetic bead separations are required.";


DefineOptions[
	purificationSharedOptionsTests,
	Options:>{CacheOption}
];

purificationSharedOptionsTests[
	mySamples:{ObjectP[Object[Sample]]...},
	mySamplePackets:{PacketP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	gatherTestsQ:BooleanP,
	myResolutionOptions:OptionsPattern[purificationSharedOptionsTests]
] := Module[
	{safeOps, cache, messages, liquidLiquidExtractionStepCountOption, precipitationStepCountOption, solidPhaseExtractionStepCountOption, magneticBeadSeparationStepCountOption, liquidLiquidExtractionStepCountTest, precipitationStepCountTest, solidPhaseExtractionStepCountTest, magneticBeadSeparationStepCountTest, purificationInvalidOptions},

	(*Pull out the safe options.*)
	safeOps = SafeOptions[purificationSharedOptionsTests, ToList[myResolutionOptions]];

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[safeOps], Cache, {}];

	(* Determine if we should keep a running list of tests (Output contains Test). *)
	messages = !gatherTestsQ;

	(* --- Purification Conflicting Options --- *)

	(* ---- liquidLiquidExtractionStepCountTest --- *)

	(*Checks if there are more than three liquid-liquid extraction steps.*)
	liquidLiquidExtractionStepCountOption = MapThread[
		Function[{sample, purification, index},
			If[
				Count[purification, LiquidLiquidExtraction]>3,
				{
					sample,
					purification,
					index
				},
				Nothing
			]
		],
		{mySamples, Lookup[myResolvedOptions, Purification], Range[Length[mySamples]]}
	];

	If[Length[liquidLiquidExtractionStepCountOption]>0 && messages,
		Message[
			Error::LiquidLiquidExtractionStepCountLimitExceeded,
			ObjectToString[liquidLiquidExtractionStepCountOption[[All,1]], Cache -> cache],
			liquidLiquidExtractionStepCountOption[[All,2]],
			liquidLiquidExtractionStepCountOption[[All,3]]
		];
	];

	liquidLiquidExtractionStepCountTest=If[gatherTestsQ,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = liquidLiquidExtractionStepCountOption[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have 3 or fewer liquid-liquid extraction steps for purification:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have 3 or fewer liquid-liquid extraction steps for purification:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*Checks if there are more than three precipitation steps.*)
	precipitationStepCountOption = MapThread[
		Function[{sample, purification, index},
			If[
				Count[purification, Precipitation]>3,
				{
					sample,
					purification,
					index
				},
				Nothing
			]
		],
		{mySamples, Lookup[myResolvedOptions, Purification], Range[Length[mySamples]]}
	];

	If[Length[precipitationStepCountOption]>0 && messages,
		Message[
			Error::PrecipitationStepCountLimitExceeded,
			ObjectToString[precipitationStepCountOption[[All,1]], Cache -> cache],
			precipitationStepCountOption[[All,2]],
			precipitationStepCountOption[[All,3]]
		];
	];

	precipitationStepCountTest=If[gatherTestsQ,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = precipitationStepCountOption[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have 3 or fewer precipitation steps for purification:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have 3 or fewer precipitation steps for purification:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* ---- solidPhaseExtractionStepCountTest --- *)

	(*Checks if there are more than three solid phase extraction steps.*)
	solidPhaseExtractionStepCountOption = MapThread[
		Function[{sample, purification, index},
			If[
				Count[purification, SolidPhaseExtraction]>3,
				{
					sample,
					purification,
					index
				},
				Nothing
			]
		],
		{mySamples, Lookup[myResolvedOptions, Purification], Range[Length[mySamples]]}
	];

	If[Length[solidPhaseExtractionStepCountOption]>0 && messages,
		Message[
			Error::SolidPhaseExtractionStepCountLimitExceeded,
			ObjectToString[solidPhaseExtractionStepCountOption[[All,1]], Cache -> cache],
			solidPhaseExtractionStepCountOption[[All,2]],
			solidPhaseExtractionStepCountOption[[All,3]]
		];
	];

	solidPhaseExtractionStepCountTest=If[gatherTestsQ,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = solidPhaseExtractionStepCountOption[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have 3 or fewer solid phase extraction steps for purification:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have 3 or fewer solid phase extraction steps for purification:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* ---- magneticBeadSeparationStepCountTest --- *)

	(*Checks if there are more than three magnetic bead separation steps.*)
	magneticBeadSeparationStepCountOption = MapThread[
		Function[{sample, purification, index},
			If[
				Count[purification, MagneticBeadSeparation]>3,
				{
					sample,
					purification,
					index
				},
				Nothing
			]
		],
		{mySamples, Lookup[myResolvedOptions, Purification], Range[Length[mySamples]]}
	];

	If[Length[magneticBeadSeparationStepCountOption]>0 && messages,
		Message[
			Error::MagneticBeadSeparationStepCountLimitExceeded,
			ObjectToString[magneticBeadSeparationStepCountOption[[All,1]], Cache -> cache],
			magneticBeadSeparationStepCountOption[[All,2]],
			magneticBeadSeparationStepCountOption[[All,3]]
		];
	];

	magneticBeadSeparationStepCountTest=If[gatherTestsQ,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = magneticBeadSeparationStepCountOption[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have 3 or fewer magnetic bead separation steps for purification:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have 3 or fewer magnetic bead separation steps for purification:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	purificationInvalidOptions = {
		If[Length[liquidLiquidExtractionStepCountOption]>0,
			{Purification},
			{}
		],
		If[Length[precipitationStepCountOption]>0,
			{Purification},
			{}
		],
		If[Length[solidPhaseExtractionStepCountOption]>0,
			{Purification},
			{}
		],
		If[Length[magneticBeadSeparationStepCountOption]>0,
			{Purification},
			{}
		]
	};

	{
		{
			liquidLiquidExtractionStepCountTest,
			precipitationStepCountTest,
			solidPhaseExtractionStepCountTest,
			magneticBeadSeparationStepCountTest
		},
		DeleteDuplicates[Flatten[purificationInvalidOptions]]
	}

];


(* ::Subsection::Closed:: *)
(*purificationSharedOptionsUnitTests*)


purificationSharedOptionsUnitTests[myFunction_Symbol, mySample: ObjectP[Object[Sample]]] :=
		{

			(* - Purification Option - *)

			Example[{Options,Purification, "If any liquid-liquid extraction options are set, then a liquid-liquid extraction will be added to the list of purification steps:"},
				myFunction[
					mySample,
					LiquidLiquidExtractionTechnique -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						Purification -> {LiquidLiquidExtraction}
					}
				],
				TimeConstraint -> 1200
			],
			Example[{Options,Purification, "If any precipitation options are set, then precipitation will be added to the list of purification steps:"},
				myFunction[
					mySample,
					PrecipitationSeparationTechnique -> Filter,
					Output->Options
				],
				KeyValuePattern[
					{
						Purification -> {Precipitation}
					}
				],
				TimeConstraint -> 1200
			],
			Example[{Options,Purification, "If any solid phase extraction options are set, then a solid phase extraction will be added to the list of purification steps:"},
				myFunction[
					mySample,
					SolidPhaseExtractionTechnique -> Pressure,
					Output->Options
				],
				KeyValuePattern[
					{
						Purification -> {SolidPhaseExtraction}
					}
				],
				TimeConstraint -> 1200
			],
			Example[{Options,Purification, "If any magnetic bead separation options are set, then a magnetic bead separation will be added to the list of purification steps:"},
				myFunction[
					mySample,
					MagneticBeadSeparationElutionMixTime -> 5*Minute,
					Output->Options
				],
				KeyValuePattern[
					{
						Purification -> {MagneticBeadSeparation}
					}
				],
				TimeConstraint -> 1200
			],
			Example[{Options,Purification, "If options from multiple purification steps are specified, then they will be added to the purification step list in the order liquid-liquid extraction, precipitation, solid phase extraction, then magnetic bead separation:"},
				myFunction[
					mySample,
					MagneticBeadSeparationElutionMixTime -> 5*Minute,
					SolidPhaseExtractionTechnique -> Pressure,
					PrecipitationSeparationTechnique -> Filter,
					LiquidLiquidExtractionTechnique -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						Purification -> {LiquidLiquidExtraction, Precipitation, SolidPhaseExtraction, MagneticBeadSeparation}
					}
				],
				TimeConstraint -> 1200
			],
			Example[{Options,Purification, "If no options relating to purification steps are specified, then a liquid-liquid extraction followed by a precipitation will be used by default:"},
				myFunction[
					mySample,
					Output->Options
				],
				KeyValuePattern[
					{
						Purification -> {LiquidLiquidExtraction, Precipitation}
					}
				],
				TimeConstraint -> 1200
			],
			
			(* - Purification Errors - *)
			
			Example[{Messages, "LiquidLiquidExtractionStepCountLimitExceeded", "An error is returned if there are more than 3 liquid-liquid extractions called for in the purification step list:"},
        myFunction[
          mySample,
          Purification -> {LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction, LiquidLiquidExtraction},
          Output->Result
        ],
        $Failed,
        Messages:>{
          Error::LiquidLiquidExtractionStepCountLimitExceeded,
          Error::InvalidOption
        },
        TimeConstraint -> 1200
      ],
			Example[{Messages, "PurificationStepCountLimitExceeded", "An error is returned if there are more than 3 precipitations called for in the purification step list:"},
				myFunction[
					mySample,
					Purification -> {Precipitation, Precipitation, Precipitation, Precipitation},
					Output->Result
				],
				$Failed,
				Messages:>{
					Error::PrecipitationStepCountLimitExceeded,
					Error::InvalidOption
				},
				TimeConstraint -> 1200
			],
			Example[{Messages, "SolidPhaseExtractionStepCountLimitExceeded", "An error is returned if there are more than 3 solid phase extractions called for in the purification step list:"},
				myFunction[
					mySample,
					Purification -> {SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction, SolidPhaseExtraction},
					Output->Result
				],
				$Failed,
				Messages:>{
					Error::SolidPhaseExtractionStepCountLimitExceeded,
					Error::InvalidOption
				},
				TimeConstraint -> 1200
			],
			Example[{Messages, "MagneticBeadSeparationStepCountLimitExceeded", "An error is returned if there are more than 3 magnetic bead separations called for in the purification step list:"},
				myFunction[
					mySample,
					Purification -> {MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation, MagneticBeadSeparation},
					Output->Result
				],
				$Failed,
				Messages:>{
					Error::MagneticBeadSeparationStepCountLimitExceeded,
					Error::InvalidOption
				},
				TimeConstraint -> 1200
			]

		};


(* ::Subsection::Closed:: *)
(*checkPurificationConflictingOptions*)

DefineOptions[
	checkPurificationConflictingOptions,
	Options:>{CacheOption}
];

checkPurificationConflictingOptions[
	mySamples:{ObjectP[Object[Sample]]..},
	myMapThreadFriendlyOptions:{_Association..},
	messagesQ:BooleanP,
	myOptions:OptionsPattern[checkPurificationConflictingOptions]
]:=Module[{safeOptions, cache,
	(* Precipitation *)
	precipitationConflictingOptionsResult, precipitationAffectedSamples, precipitationAffectedOptions,  precipitationAffectedIndices, precipitationConflictingOptionsTest,
	(* Magnetic Bead Separation *)
	MBSConflictingOptionsResult, MBSAffectedSamples, MBSAffectedOptions, MBSAffectedIndices, MBSConflictingOptionsTest, editedMBSSharedOptions,
	(* Solid Phase Extraction *)
	SPEConflictingOptionsResult, SPEAffectedSamples, SPEAffectedOptions,  SPEAffectedIndices, SPEConflictingOptionsTest,
	(* Liquid-Liquid Extraction *)
	LLEConflictingOptionsResult, LLEAffectedSamples, LLEAffectedOptions,  LLEAffectedIndices, LLEConflictingOptionsTest,
	(* Result *)
	combinedTests, combinedTestResult},

	(* get the safe options of the Cache option *)
	safeOptions = SafeOptions[checkLysisConflictingOptions,ToList[myOptions]];
	cache = Lookup[safeOptions,Cache];

	(* MBS shared options contains one option that is AllowNull->False, so we have to remove that *)
	editedMBSSharedOptions = Cases[$MagneticBeadSeparationSharedOptions, Except[TargetCellularComponent]];

	(* Check Precipitation options to see if any are set when Purification doesn't contain Precipitation *)
	precipitationConflictingOptionsResult = MapThread[
		Function[{sample, options, index},
			If[
				!MemberQ[ToList[Lookup[options,Purification]], Precipitation]
						&& MemberQ[Lookup[options,$PrecipitationSharedOptions],Except[Null|Automatic]],
				{
					sample,
					index,
					PickList[$PrecipitationSharedOptions,Lookup[options,$PrecipitationSharedOptions],Except[Null|Automatic]]
				},
				Nothing
			]
		],
		{mySamples, myMapThreadFriendlyOptions, Range[Length[mySamples]]}
	];
	precipitationAffectedSamples=precipitationConflictingOptionsResult[[All,1]];
	precipitationAffectedIndices=precipitationConflictingOptionsResult[[All,2]];
	precipitationAffectedOptions=precipitationConflictingOptionsResult[[All,3]];



	(* Check MBS options to see if any are set when Purification doesn't contain MBS *)
	MBSConflictingOptionsResult = MapThread[
		Function[{sample, options, index},
			If[
				!MemberQ[ToList[Lookup[options,Purification]], MagneticBeadSeparation]
						&& MemberQ[Lookup[options,editedMBSSharedOptions],Except[Null|{Null..}|Automatic]],
				{
					sample,
					index,
					PickList[editedMBSSharedOptions,Lookup[options,editedMBSSharedOptions],Except[Null|{Null..}|Automatic]]
				},
				Nothing
			]
		],
		{mySamples, myMapThreadFriendlyOptions, Range[Length[mySamples]]}
	];
	MBSAffectedSamples=MBSConflictingOptionsResult[[All,1]];
	MBSAffectedIndices=MBSConflictingOptionsResult[[All,2]];
	MBSAffectedOptions=MBSConflictingOptionsResult[[All,3]];

	(* Check SPE options to see if any are set when Purification doesn't contain SPE *)
	SPEConflictingOptionsResult = MapThread[
		Function[{sample, options, index},
			If[
				!MemberQ[ToList[Lookup[options,Purification]], SolidPhaseExtraction]
						&& MemberQ[Lookup[options,$SolidPhaseExtractionSharedOptions],Except[Null|Automatic]],
				{
					sample,
					index,
					PickList[$SolidPhaseExtractionSharedOptions,Lookup[options,$SolidPhaseExtractionSharedOptions],Except[Null|Automatic]]
				},
				Nothing
			]
		],
		{mySamples, myMapThreadFriendlyOptions, Range[Length[mySamples]]}
	];
	SPEAffectedSamples=SPEConflictingOptionsResult[[All,1]];
	SPEAffectedIndices=SPEConflictingOptionsResult[[All,2]];
	SPEAffectedOptions=SPEConflictingOptionsResult[[All,3]];

	(* Check LLE options to see if any are set when Purification doesn't contain LLE *)
	LLEConflictingOptionsResult = MapThread[
		Function[{sample, options, index},
			If[
				!MemberQ[ToList[Lookup[options,Purification]], LiquidLiquidExtraction]
						&& MemberQ[Lookup[options,$LiquidLiquidExtractionSharedOptions],Except[Null|Automatic]],
				{
					sample,
					index,
					PickList[$LiquidLiquidExtractionSharedOptions,Lookup[options,$LiquidLiquidExtractionSharedOptions],Except[Null|Automatic]]
				},
				Nothing
			]
		],
		{mySamples, myMapThreadFriendlyOptions, Range[Length[mySamples]]}
	];
	LLEAffectedSamples=LLEConflictingOptionsResult[[All,1]];
	LLEAffectedIndices=LLEConflictingOptionsResult[[All,2]];
	LLEAffectedOptions=LLEConflictingOptionsResult[[All,3]];

	(* If there are samples with conflicting precipitation options and we are throwing messages, throw an error message *)
	If[Length[precipitationAffectedSamples] > 0 && messagesQ,
		Message[Error::PrecipitationConflictingOptions,
			ObjectToString[precipitationAffectedSamples, Cache -> cache],
			ToString[precipitationAffectedIndices],
			ToString[precipitationAffectedOptions]
		]
	];

	(* If there are samples with conflicting MBS options and we are throwing messages, throw an error message *)
	If[Length[MBSAffectedSamples] > 0 && messagesQ,
		Message[Error::MagneticBeadSeparationConflictingOptions,
			ObjectToString[MBSAffectedSamples, Cache -> cache],
			ToString[MBSAffectedIndices],
			ToString[MBSAffectedOptions]
		]
	];

	(* If there are samples with conflicting SPE options and we are throwing messages, throw an error message *)
	If[Length[SPEAffectedSamples] > 0 && messagesQ,
		Message[Error::SolidPhaseExtractionConflictingOptions,
			ObjectToString[SPEAffectedSamples, Cache -> cache],
			ToString[SPEAffectedIndices],
			ToString[SPEAffectedOptions]
		]
	];

	(* If there are samples with conflicting MBS options and we are throwing messages, throw an error message *)
	If[Length[LLEAffectedSamples] > 0 && messagesQ,
		Message[Error::LiquidLiquidExtractionConflictingOptions,
			ObjectToString[LLEAffectedSamples, Cache -> cache],
			ToString[LLEAffectedIndices],
			ToString[LLEAffectedOptions]
		]
	];

	(* If we are returning tests, compile the tests *)
	precipitationConflictingOptionsTest = If[!messagesQ,
		Module[{failingTest, passingTest},
			failingTest = If[Length[precipitationAffectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[precipitationAffectedSamples, Cache -> cache] <> " have all precipitation options set to Null if Purification does not contain Precipitation:", True, False]
			];
			passingTest = If[Length[precipitationAffectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, precipitationAffectedSamples], Cache -> cache] <> " have all precipitation options set to Null if Purification does not contain Precipitation:", True, True]
			];
			{failingTest, passingTest}
		],
		Null
	];

	MBSConflictingOptionsTest = If[!messagesQ,
		Module[{failingTest, passingTest},
			failingTest = If[Length[MBSAffectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[MBSAffectedSamples, Cache -> cache] <> " have all magnetic bead separation options set to Null if Purification does not contain MagneticBeadSeparation:", True, False]
			];
			passingTest = If[Length[MBSAffectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, MBSAffectedSamples], Cache -> cache] <> " have all magnetic bead separation options set to Null if Purification does not contain MagneticBeadSeparation:", True, True]
			];
			{failingTest, passingTest}
		],
		Null
	];

	SPEConflictingOptionsTest = If[!messagesQ,
		Module[{failingTest, passingTest},
			failingTest = If[Length[SPEAffectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[SPEAffectedSamples, Cache -> cache] <> " have all solid phase extraction options set to Null if Purification does not contain SolidPhaseExtraction:", True, False]
			];
			passingTest = If[Length[SPEAffectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, SPEAffectedSamples], Cache -> cache] <> " have all solid phase extraction options set to Null if Purification does not contain SolidPhaseExtraction:", True, True]
			];
			{failingTest, passingTest}
		],
		Null
	];

	LLEConflictingOptionsTest = If[!messagesQ,
		Module[{failingTest, passingTest},
			failingTest = If[Length[LLEAffectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[LLEAffectedSamples, Cache -> cache] <> " have all liquid-liquid extraction options set to Null if Purification does not contain LiquidLiquidExtraction:", True, False]
			];
			passingTest = If[Length[LLEAffectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, LLEAffectedSamples], Cache -> cache] <> " have all liquid-liquid extraction options set to Null if Purification does not contain LiquidLiquidExtraction:", True, True]
			];
			{failingTest, passingTest}
		],
		Null
	];

	(* Combine all tests into a single list, or a single Null *)
	combinedTests = Flatten[{precipitationConflictingOptionsTest,MBSConflictingOptionsTest,SPEConflictingOptionsTest,LLEConflictingOptionsTest}];
	(* If there's any tests in the list, *)
	combinedTestResult = If[MemberQ[combinedTests, TestP],
		(* Pull out the tests, leaving any Nulls behind *)
		Cases[combinedTests,TestP],
		(* Otherwise, the result is a single Null *)
		Null
	];

	(* Return flattened lists of the affected options and tests *)
	{Flatten[DeleteDuplicates[{precipitationAffectedOptions,MBSAffectedOptions,SPEAffectedOptions,LLEAffectedOptions}]], combinedTestResult}
];


(* ::Subsection::Closed:: *)
(*optionsFromUnitOperation*)

(* NOTE: This is a first pass and is not fully tested yet. Please feel free to update/streamline/etc. *)
optionsFromUnitOperation[
	unitOperationPackets: {_Association..},
	unitOperationTypes: {TypeP[]..},
	mySamples: {ObjectP[]..},
	samplesUsedList: {{ObjectP[]...}..},
	preResolvedOptions: {_Rule..},
	mapThreadFriendlyPreResolvedOptions: {_Association..},
	optionMaps: {{_Rule..}..},
	stepsUsedQ: {BooleanP..}
] := MapThread[
	Function[{unitOperationType, samplesUsed, optionMap, stepUsedQ},
		If[MatchQ[stepUsedQ, True],
			Module[{allUnitOperations, samplesUsedPositions, unitOperationPosition, unitOperationOptions, resolvedOptions},

				(* Pull out unit operation types. *)
				allUnitOperations = Lookup[#, Type] & /@ unitOperationPackets;

				(* Determine the position of samples that are used in this unit operation step in all samples. *)
				samplesUsedPositions = Flatten[Position[mySamples, #]& /@ samplesUsed];

				(* Find the position of the UO of interest. *)
				unitOperationPosition = {First[Flatten[Position[allUnitOperations, unitOperationType]]]};

				(* Find the resolved options of the UO. *)
				unitOperationOptions = Lookup[Extract[unitOperationPackets, unitOperationPosition], ResolvedUnitOperationOptions];

				(* Pull out the options that we want and change their names to the shared names. *)
				(* Not using ReplaceAll to avoid replacing e.g. Model[Instrument,Centrifuge,id] with Model[Instrument,LiquidLiquidExtractionCentrifuge,id]*)
				resolvedOptions = Replace[
					Map[
						If[
							MemberQ[Values[optionMap], Keys[#]],
							#,
							Nothing
						]&,
						unitOperationOptions
					],
					Reverse /@ optionMap,
					2
				];

				(* For each shared option, replace Automatics with resolved options (if used) or Null (if not used). *)
				Map[
					Function[{optionName},
						Module[{indexMatchingQ, optionValue},

							(* Check if the option is index-matched. *)
							(* NOTE: May need to have new input to check OptionDefinition in the future to determine this. *)
							indexMatchingQ = And[
								MatchQ[Lookup[resolvedOptions, optionName],_List],
								SameQ[Length[Lookup[resolvedOptions, optionName]], Length[samplesUsed]]
							];

							(* Build the fully resolved value for this shared option name. *)
							optionValue = If[indexMatchingQ,
								MapThread[
									Function[{sampleIndex, sample, options},
										If[
											MemberQ[samplesUsedPositions, sampleIndex],
											(* If sample is used, then use resolved option. *)
											Module[{resolvedOptionValue,roundedResolvedOptionValue},

												(* Index-matching options are in list the length of the samples used. The position of the *)
												(* sample in the 'samples used' list pulls out the option value for that sample *)
												(* non-index matching options will not be in a list form. The single value applies to all samples *)
												resolvedOptionValue = Extract[
													Lookup[resolvedOptions, optionName],
													Position[samplesUsed, sample]
												][[1]];

												(* Re-round options that do not round correctly. *)
												roundedResolvedOptionValue = Which[
													MatchQ[optionName,TargetCellCount],
														SafeRound[resolvedOptionValue,1 EmeraldCell],
													MatchQ[optionName,TargetCellConcentration],
														SafeRound[resolvedOptionValue,10^-1 EmeraldCell / Milliliter],
													MatchQ[optionName, LysisAliquotAmount],
														SafeRound[resolvedOptionValue,10^-1 Microliter],
													True,
														resolvedOptionValue
												];

												(* Replace Automatic with the new option value. *)
												Lookup[options,optionName] /. (Automatic -> roundedResolvedOptionValue)

											],
											(* If sample is not used, set Automatic to Null. *)
											Lookup[options,optionName] /. (Automatic -> Null)
										]
									],
									{Range[Length[mySamples]], mySamples, mapThreadFriendlyPreResolvedOptions}
								],
								(* If not index-matching, then just look up the option. *)
								Lookup[resolvedOptions, optionName]
							];

							(* Build the final option.*)
							optionName -> optionValue

						]
					],
					Keys[optionMap]
				]

			],
			(* If no samples used by this unit operation, then replace all shared options with Null. *)
			Map[
				# -> Lookup[preResolvedOptions, #] /. (Automatic -> Null)&,
				Keys[optionMap]
			]
		]
	],
	{unitOperationTypes, samplesUsedList, optionMaps, stepsUsedQ}
];


(* ::Subsection::Closed:: *)
(*unNestResolvedPurificationContainer*)

unNestResolvedPurificationContainer[
	myResolvedOption:ListableP[Alternatives[Null, ObjectP[], {_Integer, ObjectP[]}, {_String, ObjectP[]}, {_String ,{_Integer, ObjectP[]}}], 4]
]:=	Switch[ToList[myResolvedOption],
	(*If it is a listable objects, just flatten it*)
	ListableP[ObjectP[Object[Container]] | ObjectP[Model[Container]], 3],
		Flatten[ToList[myResolvedOption]],
	(*If it is a listable indices and containers, flatten to singletons*)
	ListableP[{GreaterEqualP[1, 1], ObjectP[Model[Container]]}, 3],
		Cases[ToList[myResolvedOption], {GreaterEqualP[1, 1], ObjectP[Model[Container]]}, 3],
	(*If it is a listable wells and containers, flatten to singletons*)
	ListableP[{_String, ObjectP[Model[Container]]}, 4],
		Cases[ToList[myResolvedOption], {_String, ObjectP[Model[Container]]}, 4],
	(*If it is a listable wells indices and containers, flatten to singletons *)
	ListableP[{_String, {GreaterEqualP[1, 1], ObjectP[Model[Container]]}}, 3],
		Cases[ToList[myResolvedOption],{_String, {GreaterEqualP[1, 1], ObjectP[Model[Container]]}}, 3],
	(*If it is a listable Null, just flatten it*)
	_,
		Flatten[ToList[myResolvedOption]]
];

(* ::Subsection::Closed:: *)
(*unNestResolvedPurificationOptions*)

unNestResolvedPurificationOptions[myResolvedOptions:{_Rule..}] := Map[
	Which[
		(*ContainerOut options: un-nest containers*)
		MatchQ[#, Alternatives[
			MagneticBeadSeparationPreWashCollectionContainer, MagneticBeadSeparationEquilibrationCollectionContainer, MagneticBeadSeparationLoadingCollectionContainer, MagneticBeadSeparationWashCollectionContainer, MagneticBeadSeparationSecondaryWashCollectionContainer, MagneticBeadSeparationTertiaryWashCollectionContainer, MagneticBeadSeparationQuaternaryWashCollectionContainer, MagneticBeadSeparationQuinaryWashCollectionContainer, MagneticBeadSeparationSenaryWashCollectionContainer, MagneticBeadSeparationSeptenaryWashCollectionContainer, MagneticBeadSeparationElutionCollectionContainer,
			PrecipitatedSampleContainerOut, UnprecipitatedSampleContainerOut
		]],
			# -> unNestResolvedPurificationContainer[Lookup[myResolvedOptions, #]],

		(*ContainerLabel options: transpose and flatten*)
		MatchQ[#, Alternatives[
			MagneticBeadSeparationPreWashCollectionContainerLabel, MagneticBeadSeparationEquilibrationCollectionContainerLabel, MagneticBeadSeparationLoadingCollectionContainerLabel, MagneticBeadSeparationWashCollectionContainerLabel, MagneticBeadSeparationSecondaryWashCollectionContainerLabel, MagneticBeadSeparationTertiaryWashCollectionContainerLabel, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel, MagneticBeadSeparationQuinaryWashCollectionContainerLabel, MagneticBeadSeparationSenaryWashCollectionContainerLabel, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel, MagneticBeadSeparationElutionCollectionContainerLabel, SampleOutLabel
		]],
			# -> Flatten[Lookup[myResolvedOptions, #]],

		(*Options that should not be flattened*)
		MatchQ[#, Alternatives[
			MagneticBeadSeparationSelectionStrategy, MagneticBeadSeparationMode, WorkCell, LiquidLiquidExtractionTargetLayer, DemulsifierAdditions, LiquidLiquidExtractionSolventAdditions
		]],
			# -> Lookup[myResolvedOptions, #],

		(*Otherwise just lookup and flatten the option value*)
		True,
			# -> Flatten[Lookup[myResolvedOptions, #]]
	]&,
	Keys[myResolvedOptions]
];


(* ::Subsection::Closed:: *)
(* expandPurificationOption *)

(* Correct expansion of Purification option. *)
expandPurificationOption[nonExpandedOptions:{_Rule..}, expandedOptions:{_Rule..}, mySamples:{ObjectP[Object[Sample]]..}] := Module[{purificationOption, expandedPurificationOption},

	(* Pull out the original purification option value. *)
	purificationOption = Lookup[nonExpandedOptions,Purification];

	(* Expand the purification option. *)
	expandedPurificationOption = Which[
		(* If the option is None, then expand it to be None for each sample. *)
		MatchQ[purificationOption, None],
			ConstantArray[purificationOption, Length[mySamples]],
		(* If the option is Automatic, then expand it to be Automatic for each sample. *)
		MatchQ[purificationOption, Automatic],
			ConstantArray[purificationOption, Length[mySamples]],
		(* If the option is a list of Automatics the length of the number of samples, then keep it as is. *)
		MatchQ[purificationOption, {Automatic..}] && Length[purificationOption] == Length[mySamples],
			purificationOption,
		(* If the option is one purification step, then just have that happen once for each sample, and put the purification technique symbol in a list. *)
		!MatchQ[purificationOption, _List],
			ConstantArray[{purificationOption}, Length[mySamples]],
		(* If the purification option is a list the length of the number of samples, its already indexed-matched to samples, but need to make *)
		(* single symbols into {_Symbol} *)
		Length[purificationOption] == Length[mySamples],
			ToList[#]& /@ purificationOption,
		(* Otherwise, the option is specifying the steps to be used for each sample and is made index-matching. *)
		True,
			ConstantArray[purificationOption, Length[mySamples]]
	];

	(* Add fixed Purification option to the rest of the expanded options. *)
	ReplaceRule[
		expandedOptions,
		{
			Purification -> expandedPurificationOption
		}
	]

];

(* ::Subsection::Closed:: *)
(* makePurificationMapThreadFriendly *)

makePurificationMapThreadFriendly[mySamples:{ObjectP[Object[Sample]]..}, myOptions: _Association, preCorrectionMapThreadFriendlyOptions:{_Association..}] := MapThread[
	Function[{options, index},
		Merge[
			{
				options,
				<|
					Purification -> Lookup[myOptions, Purification][[index]]
				|>
			},
			Last
		]
	],
	{preCorrectionMapThreadFriendlyOptions, Range[Length[mySamples]]}
];

(* ::Subsection::Closed:: *)
(* translateSharedSPEMasterswitch *)
translateSharedSPEMasterswitch[myOptions: {_Rule..}, mySPEStage:Alternatives[Wash,SecondaryWash,TertiaryWash,Elution]] := Module[{sharedSPEStageMasterSwitch},
	(*Our master switch aka the buffer*)
	sharedSPEStageMasterSwitch = Switch[mySPEStage,
		Wash, SolidPhaseExtractionWashSolution,
		SecondaryWash, SecondarySolidPhaseExtractionWashSolution,
		TertiaryWash, TertiarySolidPhaseExtractionWashSolution,
		Elution, SolidPhaseExtractionElutionSolution,
		(*Should never be here but jic*)
		_,Null
	];
	(*Washing&Eluting resolves similarly, the other two resolves similarly*)
	If[MatchQ[mySPEStage,Wash|Elution],
		(*the stage switch resolution also considers extraction strategy*)
		MapThread[
			Function[{buffer,strategy},
				If[Or[MatchQ[buffer,Null],
						MatchQ[{buffer,strategy},{Automatic,Negative}]],(*mimicking SPE resolver*)
					False,
					True]
			],
			{Lookup[myOptions,sharedSPEStageMasterSwitch],Lookup[myOptions,SolidPhaseExtractionStrategy]}
		],
		(*Otherwise the stage is secondary or tertiary wash, it does not consider strategy*)
		Map[
			Function[buffer,
				If[MatchQ[buffer,Automatic|Null],
					False,
					True]
			],
			Lookup[myOptions,sharedSPEStageMasterSwitch]
		]
	]
];
