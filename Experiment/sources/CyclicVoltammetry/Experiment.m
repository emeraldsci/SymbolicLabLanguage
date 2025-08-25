(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentCyclicVoltammetry*)


(* ::Subsubsection:: *)
(*Options*)


DefineOptions[ExperimentCyclicVoltammetry,
	Options :> {
		(* General *)
		{
			OptionName -> NumberOfReplicates,
			Default -> 1,
			Description -> "The number of times to repeat cyclic voltammetry measurement on each provided sample.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterEqualP[1, 1]
			]
		},
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, Reactor, Electrochemical, "IKA ElectraSyn 2.0"],
			Description -> "The electrochemical reactor that performs cyclic voltammetry measurements by linearly and periodically scanning the potential (within a practical range) applied to a specific inert electrode (working electrode) within the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard).",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, Reactor, Electrochemical], Object[Instrument, Reactor, Electrochemical]}]
			],
			Category->"General"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples that are being measured in ExperimentCyclicVoltammetry, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the containers of the samples that are being measured in ExperimentCyclicVoltammetry, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> PreparedSample,
				Default -> Automatic,
				Description -> "Indicates if the current input sample is a fully prepared solution ready to be measured, which includes a solvent, an electrolyte, the target analyte, and an optional internal standard. If sample State is Liquid, automatically resolves to True. Otherwise, resolves to False. If set to True, will skip the options in the Sample Preparation step.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "General"
			},
			{
				OptionName -> Analyte,
				Default -> Automatic,
				Description -> "The target chemical whose cyclic voltammogram is measured.",
				ResolutionDescription -> "If PreparedSample is True, automatically resolves to the analyte specified in the SamplesIn. If the PreparedSample is False, automatically resolves to SamplesIn.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Molecule]}]
				],
				Category->"General"
			},
			{
				OptionName -> Solvent,
				Default -> Automatic,
				Description -> "The liquid used to dilute or dissolve the target analyte. This can be the \"Milli-Q\" water or a organic solvent.",
				ResolutionDescription -> "If PreparedSample is True, automatically resolves to the solvent specified in the SamplesIn. If the PreparedSample is False and an ElectrolyteSolution is provided, automatically resolves to the solvent specified in the ElectrolyteSolution. If the PreparedSample is False and no ElectrolyteSolution is provided, automatically resolves to acetonitrile (CH3CN).",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
				],
				Category->"General"
			},
			{
				OptionName -> Electrolyte,
				Default -> Automatic,
				Description -> "Specify the electrolyte chemical added into the Solvent to prepare the ElectrolyteSolution and the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard), if the ElectrolyteSolution option is unspecified.",
				ResolutionDescription -> "If an ElectrolyteSolution is provided, automatically resolves to the electrolyte specified in the ElectrolyteSolution. If no ElectrolyteSolution is provided and PreparedSample is False, automatically resolves to KCl if Solvent is aqueous, to NBu4PF6 is Solvent is organic. If no ElectrolyteSolution is provided and PreparedSample is True, this cannot be automatically resolved.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
				],
				Category->"General"
			},
			{
				OptionName -> InternalStandard,
				Default -> None,
				Description -> "Specify the chemical used as the internal standard in the LoadingSample (including a solvent, an electrolyte, the target analyte, and the optional internal standard indicated here). Since the locations of the reduction and oxidation waves of an internal standard species are known, the use of an internal standard can define the absolute potential level of the cyclic voltammetry measurement. For a silver pseudo reference electrode, ferrocene is usually used as the InternalStandard.
				If this is set to None, no InternalStandard is included in the LoadingSample, and InternalStandard options will be skipped.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[None]
					]
				],
				Category->"General"
			}
		],
		{
			OptionName -> WorkingElectrode,
			Default -> Model[Item, Electrode, "IKA Glassy Carbon 3 mm Disc Working Electrode"],
			Description -> "The electrode whose potential is linearly and periodically scanned to trigger the local reduction and oxidation of the target analyte within the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) during the cyclic voltammetry measurement.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Electrode], Object[Item, Electrode]}]
			],
			Category->"General"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> ReferenceElectrode,
				Default -> Automatic,
				Description -> "The electrode whose potential stays constant during the cyclic voltammetry measurement, and therefore acts as a reference point for the working electrode potential. The potential difference between the working electrode and the reference electrode is plotted as the x-axis of the cyclic voltammetry output (voltammogram).",
				ResolutionDescription -> "Automatically set to \"0.1M AgNO3 Ag/Ag+ Reference Electrode\" for samples in organic solvents and resolves to \"3M KCl Ag/AgCl reference electrode\" for samples in aqueous solvent (\"Milli-Q Water\").",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]
				],
				Category->"General"
			}
		],
		{
			OptionName -> CounterElectrode,
			Default -> Model[Item, Electrode, "IKA Platinum Coated Copper Plate Electrode"],
			Description -> "The electrode that completes the electric circuit with the working electrode. The current flowing between the working electrode and the counter electrode is plotted as the y-axis of the cyclic voltammetry output (voltammogram).",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Electrode], Object[Item, Electrode]}]
			],
			Category->"General"
		},
		{
			OptionName -> ElectrodeCap,
			Default -> Model[Item, Cap, ElectrodeCap, "IKA Regular Electrode Cap"],
			Description -> "The assembly that covers and seals the reaction vessel holding the solution being measured. This assembly includes a main cap that holds the working, counter, and reference electrodes and connects them to the instrument. A smaller cap that covers the sample loading hole on the main cap is also included in this assembly. The smaller cap is equipped with a septum membrane, which can be pierced to install the gas-sparging needles.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Cap, ElectrodeCap], Object[Item, Cap, ElectrodeCap]}]
			],
			Category->"General"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> ReactionVessel,
				Default -> Model[Container, ReactionVessel, ElectrochemicalSynthesis, "Electrochemical Reaction Vessel, 5 mL"],
				Description -> "The container holds the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) being measured. This vessel is covered and sealed by the cap assembly specified by the ElectrodeCap option.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, ReactionVessel, ElectrochemicalSynthesis], Object[Container, ReactionVessel, ElectrochemicalSynthesis]}]
				],
				Category->"General"
			},

			(* Working and Counter Electrode Preparation *)
			(* Working Electrode Polishing *)
			{
				OptionName -> PolishWorkingElectrode,
				Default -> False,
				Description -> "Indicates if the working electrode is polished on a series of polishing pads with corresponding polishing solutions, before the electrode is sonicated in \"Milli-Q\" water or wash-cleaned by methanol and \"Milli-Q\" water. Note: the polishing process will consume the WorkingElectrode. If the amount of deposits on the working electrode bottom surface is small, sonication and wash-cleaning may be enough.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category->"Electrode Polishing"
			},
			{
				OptionName -> PolishingPads,
				Default -> Automatic,
				Description -> "The series of polishing pads used to polish the working electrode. Each pad will be used to polish the electrode in the order provided in the list. It is recommended that the progression of polishing is proceed from coarse to fine pads.",
				ResolutionDescription -> "Automatically resolves to {Diamond/Nylon Pad, Alumina/Texmet Pad}.",
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Item, ElectrodePolishingPad], Object[Item, ElectrodePolishingPad]}]
					]
				],
				Category->"Electrode Polishing"
			},
			{
				OptionName -> PolishingSolutions,
				Default -> Automatic,
				Description -> "The corresponding series of solutions dropped onto each polishing pad as a polishing medium between the pad and the working electrode when the working electrode is polished. The length of the PolishingSolutions list should be the same as the length of the PolishingPads list.",
				ResolutionDescription -> "Automatically resolves to the DefaultPolishingSolution in each Model[Item, PolishingPad].",
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
					]
				],
				Category->"Electrode Polishing"
			},
			{
				OptionName -> NumberOfPolishingSolutionDroplets,
				Default -> Automatic,
				Description -> "The number of droplets of the polishing solution put onto each polishing pad when the working electrode is polished. The length of the NumberOfPolishingSolutionDroplets list should be the same as the length of the PolishingPads list.",
				ResolutionDescription -> "Automatically resolves to 2 for each member of PolishingPads.",
				AllowNull -> True,
				Widget-> Adder[
					Widget[
						Type -> Number,
						Pattern :> GreaterP[0, 1]
					]
				],
				Category->"Electrode Polishing"
			},
			{
				OptionName -> NumberOfPolishings,
				Default -> Automatic,
				Description -> "The number of polishings performed for each polishing pad before moving to the next polishing pad, in the order specified by the PolishingPads option. Each polishing includes rubbing the bottom of the working electrode for 10 \"8\"-figure cycles. If there are 3 polishing pads (A, B, C) specified by the PolishingPads option, a NumberOfPolishing equals to {2, 2, 3} means the polishings will happen in the order of AA, BB, CCC. The length of the NumberOfPolishings list should be the same as the length of the PolishingPads list.",
				ResolutionDescription -> "Automatically resolves to 1 for each member of PolishingPads.",
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Number,
						Pattern :> GreaterP[0, 1]
					]
				],
				Category->"Electrode Polishing"
			},

			(* Working Electrode Polishing *)
			{
				OptionName -> WorkingElectrodeSonication,
				Default -> False,
				Description -> "Indicates if the working electrode is sonicated in \"Milli-Q\" water after the polishing (if any) and before the wash-cleaning.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category->"Electrode Cleaning"
			},
			{
				OptionName -> WorkingElectrodeSonicationTime,
				Default -> Automatic,
				Description -> "Specify the duration for which the sonication of the working electrodes last. The sonication should last no more than 1 minute to ensure the integrity of the working electrode electrical connections.",
				ResolutionDescription -> "Automatically resolves to 30 seconds if WorkingElectrodeSonication is True.",
				AllowNull -> True,
				Widget -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Second, 60 Second],
						Units -> Second
				],
				Category->"Electrode Cleaning"
			},
			{
				OptionName -> WorkingElectrodeSonicationTemperature,
				Default -> Automatic,
				Description -> "Specify the temperature at which the sonication of the working electrodes is performed.",
				ResolutionDescription -> "Automatically resolves to ambient temperature if WorkingElectrodeSonication is True.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[$AmbientTemperature, 69 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Category->"Electrode Cleaning"
			},
			(* Working and Counter Electrodes Washing *)
			{
				OptionName -> WorkingElectrodeWashing,
				Default -> True,
				Description -> "Indicates if the working electrode is washed to remove the unwanted deposits, after the optional polishing and optional sonication. This also helps to remove possible polishing deposits on the working electrode after the polishing step (if any). \"Milli-Q\" water and methanol are squirted from a wash bottle against the working electrode in sequence. A chemwipe damped with the methanol is used to carefully wipe the bottom of the working electrode, before the electrode is blow dried with nitrogen gas.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category->"Electrode Cleaning"
			},
			{
				OptionName -> CounterElectrodeWashing,
				Default -> True,
				Description -> "Indicates if the counter electrode is washed to remove the unwanted deposits, before the optional pretreatment or the CV measurement. \"Milli-Q\" water and methanol are squirted from a wash bottle against the counter electrode in sequence. The counter electrode is then blow dried with nitrogen gas.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category->"Electrode Cleaning"
			},
			{
				OptionName -> WorkingElectrodeWashingCycles,
				Default -> Automatic,
				Description -> "The number of washing cycles performed for the working electrode after the optional polishing and optional sonication.",
				ResolutionDescription -> "Automatically resolves to 1 if WorkingElectrodeWashing is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 10]
				],
				Category->"Electrode Cleaning"
			},

			(* Reference Electrode Preparation *)
			{
				OptionName -> RefreshReferenceElectrode,
				Default -> False,
				Description -> "Indicates if the ReferenceElectrode is refreshed using the ReferenceSolution defined in the ReferenceElectrode. The refresh process replaces the reference solution within the glass tube which may have decreased in concentration over time and usage. The refresh involves emptying the previous solution from the glass tube, washing the inside of reference electrode with the fresh solution, emptying the washing solution, adding in the fresh solution into the glass tube. See more details in ExperimentPrepareReferenceElectrode help file.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "Reference Electrode Preparation"
			},
			{
				OptionName -> ReferenceElectrodeSoakTime,
				Default -> 3 Minute,
				Description -> "Specify the duration the ReferenceElectrode is soaked with solutions outside its glass tube. The outside solution is the electrolyte solution if the electrode pretreatment will be performed, otherwise is the LoadingSample. This soaking step happens before the optional electrode pretreatment or before the cyclic voltammetry measurements (if no pretreatment is performed).",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				],
				Category -> "Reference Electrode Preparation"
			},

			(* Electrode Pretreatment *)
			{
				(* Master switch to control the pretreatment options *)
				OptionName -> PretreatElectrodes,
				Default -> False,
				Description -> "Indicates if the working, counter, and reference electrodes are pretreated before the cyclic voltammetry measurement of the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard), to remove any interfering deposits on the electrodes. The pretreatment performs several cyclic voltammetry cycles of the electrolyte solution until the voltammogram becomes stable, therefore prepares the working, counter, and reference electrodes for the cyclic voltammetry measurements of the LoadingSample later.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category->"Electrode Pretreatment"
			},
			{
				OptionName -> ElectrolyteSolution,
				Default -> Automatic,
				Description -> "The conductive solution used to pretreat the electrodes before the cyclic voltammetry measurement. The ElectrolyteSolution contains a aqueous or an organic solvent and an electrolyte chemical to make the solution conductive. When the PretreatElectrodes options is set to True, ElectrolyteSolution cannot be automatically resolved and must be explicitly specified.",
				ResolutionDescription -> "Automatically set to Null if PretreatElectrodes is False. ElectrolyteSolution cannot be automatically resolved if PretreatElectrodes is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
				],
				Category->"Electrode Pretreatment"
			},
			{
				OptionName -> ElectrolyteSolutionLoadingVolume,
				Default -> Automatic,
				Description -> "Volume of the electrolyte solution added into the electrode pretreatment reaction vessel (same model as specified by ReactionVessel option).",
				ResolutionDescription -> "Automatically set to Null if PretreatElectrodes is False. Automatically set to 60% of the MaxVolume of ReactionVessel if PretreatElectrodes is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Milliliter, 20 Milliliter],
					Units -> Milliliter
				],
				Category->"Electrode Pretreatment"
			},
			{
				OptionName -> PretreatmentSparging,
				Default -> Automatic,
				Description -> "Indicates if the electrolyte solution within the electrode pretreatment reaction vessel is sparged with an inert gas before the pretreatment procedure. This sparging process removes the dissolved oxygen and carbon dioxide from the electrolyte solution, allowing for better pretreatment performance. The sparging gas type is specified by the SpargingGas option, and the sparging time is specified by the SpargingTime option, which are the same sparging gas type and sparging time for the LoadingSample sparging step.",
				ResolutionDescription -> "Automatically set to False if PretreatElectrodes is False. Automatically resolves to True if PretreatElectrodes is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category->"Electrode Pretreatment"
			},
			{
				OptionName -> PretreatmentSpargingPreBubbler,
				Default -> Automatic,
				Description -> "Indicates if a prebubbler is used before the electrode pretreatment reaction vessel. A prebubbler is a container containing the same solvent used in the electrolyte solution, which is hooked in series with the reaction vessel, such that the gas is first bubbled through the prebubbler solution and then bubbled into the reaction vessel. This helps to ensure the reaction vessel doesn't excessively evaporate during the sparging, since the sparging gas is saturated by the solvent inside the prebubbler before travelling into the reaction vessel.",
				ResolutionDescription -> "Automatically set to False if PretreatmentSparging is False. Automatically resolves to True if PretreatmentSparging is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category->"Electrode Pretreatment"
			},
			{
				(* TODO: add the explanation figure in the help file *)
				OptionName -> PretreatmentInitialPotential,
				Default -> Automatic,
				Description -> "The potential applied to the working electrode when the pretreatment cyclic voltammetry cycle starts. After the PretreatmentInitialPotential is applied, the working electrode potential is then linearly scanned to the PretreatmentFirstPotential.",
				ResolutionDescription -> "Automatically resolves to 0.0 Volt if PretreatElectrodes is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-2.5 Volt, 2.5 Volt],
					Units -> {Volt, {Millivolt, Volt}}
				],
				Category->"Electrode Pretreatment"
			},
			{
				OptionName -> PretreatmentFirstPotential,
				Default -> Automatic,
				Description -> "The first target potential after the PretreatmentInitialPotential is applied. At the PretreatmentFirstPotential, the scanning direction reverses, and the working electrode potential is then linearly scanned to the PretreatmentSecondPotential.",
				ResolutionDescription -> "Automatically resolves to 1.5 Volt if PretreatElectrodes is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-2.5 Volt, 2.5 Volt],
					Units -> {Volt, {Millivolt, Volt}}
				],
				Category->"Electrode Pretreatment"
			},
			{
				OptionName -> PretreatmentSecondPotential,
				Default -> Automatic,
				Description -> "The second target potential after the PretreatmentFirstPotential is reached. At the PretreatmentSecondPotential, the scanning direction reverses again, and the working electrode potential is then linearly scanned to the PretreatmentFinalPotential.",
				ResolutionDescription -> "Automatically resolves to -2.5 Volt if PretreatElectrodes is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-2.5 Volt, 2.5 Volt],
					Units -> {Volt, {Millivolt, Volt}}
				],
				Category->"Electrode Pretreatment"
			},
			{
				OptionName -> PretreatmentFinalPotential,
				Default -> Automatic,
				Description -> "The final target potential after the PretreatmentSecondPotential is reached. Once the PretreatmentFinalPotential is reached, the current pretreatment cyclic voltammetry cycle will stop.",
				ResolutionDescription -> "Automatically resolves to 0.0 Volt if PretreatElectrodes is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-2.5 Volt, 2.5 Volt],
					Units -> {Volt, {Millivolt, Volt}}
				],
				Category->"Electrode Pretreatment"
			},
			{
				OptionName -> PretreatmentPotentialSweepRate,
				Default -> Automatic,
				Description -> "The speed (in Millivolt per Second) at which the working electrode potential is linearly scanned during the pretreatment cyclic voltammetry cycles.",
				ResolutionDescription -> "Automatically resolves to 200 Millivolt/Second if PretreatElectrodes is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 Millivolt/Second, 1000 Millivolt/Second],
					Units -> CompoundUnit[
						{1,{Volt, {Millivolt, Volt}}},
						{-1,{Second, {Second, Minute}}}
					]
				],
				Category->"Electrode Pretreatment"
			},
			{
				OptionName -> PretreatmentNumberOfCycles,
				Default -> Automatic,
				Description -> "Specify the number of pretreatment cyclic voltammetry cycles are performed. A pretreatment cyclic voltammetry cycle starts from the PretreatmentInitialPotential, then to the PretreatmentFirstPotential, then to the PretreatmentSecondPotential, and stops at the PretreatmentFinalPotential. Currently, PretreatmentNumberOfCycles cannot exceed 4.",
				ResolutionDescription -> "Automatically resolves to 3 if PretreatElectrodes is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 4]
				],
				Category->"Electrode Pretreatment"
			},

			(* Sample Preparation *)
			{
				OptionName -> SampleAmount,
				Default -> Automatic,
				Description -> "Specify the amount of target analyte (in mass) being dissolved into the solvent (electrolyte addition required after analyte addition) or into the electrolyte solution.",
				ResolutionDescription -> "If TargetConcentration is specified, automatically set to match TargetConcentration and SolventVolume. If TargetConcentration is not specified, automatically resolves to a value assuming TargetConcentration is 5.0 Millimolar.",
				AllowNull -> True,
				Widget -> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0.1 Milligram],
						Units -> {Milligram, {Microgram, Milligram, Gram}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> LoadingSampleTargetConcentration,
				Default -> Automatic,
				Description -> "Specify the concentration of the sample in the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) after the dilution or dissolving.",
				ResolutionDescription -> "If SampleAmount is specified, automatically set to match SampleAmount and SolventVolume. If SampleAmount is not specified, automatically resolves to 5.0 Millimolar.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> Alternatives[
						GreaterP[0.1 Millimolar],
						GreaterP[0.1 Milligram/Liter]
					],
					Units -> Alternatives[
						{Millimolar, {Millimolar, Molar}},
						CompoundUnit[
							{1,{Milligram,{Milligram,Gram}}},
							{-1,{Milliliter,{Milliliter,Microliter}}}
						]
					]
				],
				Category->"Sample Preparation"
			},

			{
				OptionName -> InternalStandardAdditionOrder,
				Default -> Automatic,
				Description -> "Specify if the internal standard is added to the LoadingSample (including a solvent, an electrolyte, the target analyte, and the optional internal standard indicated here) before or after the cyclic voltammetry measurement. If the InternalStandardAdditionOrder equals to After, a series of cyclic voltammetry measurements with the same parameters used before the addition is performed.",
				ResolutionDescription -> "Automatically resolves to After if InternalStandard is not None.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Before, After]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> InternalStandardAmount,
				Default -> Automatic,
				Description -> "Specify the amount (in mass) of internal standard being diluted or dissolved into the LoadingSample (including a solvent, an electrolyte, the target analyte, and the optional internal standard indicated here).",
				ResolutionDescription -> "If InternalStandardTargetConcentration is specified, automatically set to match InternalStandardTargetConcentration. If InternalStandardTargetConcentration is not specified, automatically resolves to a value assuming InternalStandardTargetConcentration is 2.0 Millimolar.",
				AllowNull -> True,
				Widget -> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0.1 Milligram],
						Units -> {Milligram, {Microgram, Milligram, Gram}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> InternalStandardTargetConcentration,
				Default -> Automatic,
				Description -> "Indicates the concentration of the internal standard in the electrolyte solution (addition order is before) or the LoadingSample (addition order is after) after the dilution or dissolving.",
				ResolutionDescription -> "If InternalStandardAmount is specified, automatically set to match InternalStandardAmount. If InternalStandardAmount is not specified, automatically resolves to 2.0 Millimolar.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> Alternatives[
						GreaterP[0.1 Millimolar],
						GreaterP[0.1 Milligram/Liter]
					],
					Units -> Alternatives[
						{Millimolar, {Millimolar, Molar}},
						CompoundUnit[
							{1, {Milligram, {Milligram, Gram}}},
							{-1, {Milliliter, {Microliter, Milliliter}}}
						]
					]
				],
				Category->"Sample Preparation"
			},

			(* Options for Sample Mixing *)
			{
				OptionName -> SolventVolume,
				Default -> Automatic,
				Description -> "Specify the solvent volume used to dilute or dissolve the target analyte, Electrolyte, and optional InternalStandard.",
				ResolutionDescription -> "Automatically set to 60% of the current reaction vessel max volume.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.5 Milliliter, 200 Milliliter],
					Units -> {Milliliter, {Milliliter, Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> LoadingSampleElectrolyteAmount,
				Default -> Automatic,
				Description -> "Specify the amount (in mass) of Electrolyte sample being diluted or dissolved within the solvent (along with the target analyte and optional internal standard) to prepare the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard).",
				ResolutionDescription -> "If ElectrolyteTargetConcentration is specified, automatically set to match ElectrolyteTargetConcentration and SolventVolume. If ElectrolyteTargetConcentration is not specified, for aqueous Solvent, automatically resolves to a value assuming ElectrolyteTargetConcentration is 3 Molar; for organic Solvent, automatically resolves to a value assuming ElectrolyteTargetConcentration is 250 Millimolar.",
				AllowNull -> True,
				Widget -> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0.1 Milligram],
						Units -> {Milligram, {Microgram, Milligram, Gram}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> ElectrolyteTargetConcentration,
				Default -> Automatic,
				Description -> "Specify the concentration of the electrolyte in the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard). The electrolyte concentration should be the same for both ElectrolyteSolution and LoadingSample.",
				ResolutionDescription -> "For aqueous Solvent, automatically resolves to 3 Molar; for organic Solvent, automatically resolves to 250 Millimolar.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> Alternatives[
						GreaterP[0.1 Millimolar],
						GreaterP[0.1 Milligram/Liter]
					],
					Units -> Alternatives[
						{Millimolar, {Millimolar, Molar}},
						CompoundUnit[
							{1,{Milligram,{Milligram,Gram}}},
							{-1,{Milliliter,{Milliliter,Microliter}}}
						]
					]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> LoadingSampleMix,
				Default -> Automatic,
				Description -> "Indicates if the solution is mixed after the addition of the analyte, the electrolyte (if added) and the optional internal standard (addition order is before) into the solvent. This mixing step generates the LoadingSample and happens before the cyclic voltammetry measurement.",
				ResolutionDescription -> "Automatically resolves to True if Prepared Sample is False.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> LoadingSampleMixType,
				Default -> Automatic,
				Description -> "Specify the mixing type of the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) mixing procedure before the cyclic voltammetry measurement.",
				ResolutionDescription -> "Automatically resolves to Invert.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Shake, Pipette, Invert]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> LoadingSampleMixTemperature,
				Default -> Automatic,
				Description -> "Specify the temperature at which the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) mixing procedure is performed.",
				ResolutionDescription -> "Automatically resolves to Ambient.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[$AmbientTemperature, 75 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> LoadingSampleMixTime,
				Default -> Automatic,
				Description -> "Specify the mixing time for the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) mixing procedure before the cyclic voltammetry measurement.",
				ResolutionDescription -> "Automatically resolves to 5 minutes.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				],
				Category->"Sample Preparation"
			},
			{
				(* Turn off if MixType is not Pipette or Invert *)
				OptionName -> LoadingSampleNumberOfMixes,
				Default -> Automatic,
				Description -> "Specify the number of mixes for the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) mixing procedure before the cyclic voltammetry measurement. Note this option only applies for mix type: Pipette or Invert.",
				ResolutionDescription -> "Automatically resolves to 10.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 50, 1]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> LoadingSampleMixVolume,
				Default -> Automatic,
				Description -> "Specify the solution volume that is pipetted up and down (if the MixType is Pipette) for the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) mixing procedure before the cyclic voltammetry measurement.",
				ResolutionDescription -> "Automatically resolves to 50% of SolventVolume.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Milliliter, 20 Milliliter],
					Units -> {Milliliter, {Microliter, Milliliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> LoadingSampleMixUntilDissolved,
				Default -> Automatic,
				Description -> "Indicates if the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) mixing procedure continues until the solid sample is dissolved, up to the LoadingSampleMaxMixTime or the LoadingSampleMaxNumberOfMixes.",
				ResolutionDescription -> "Automatically resolves to True if LoadingSampleMix is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> LoadingSampleMaxNumberOfMixes,
				Default -> Automatic,
				Description -> "Specify the maximum number of the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) mixes, in attempt to dissolve all the solids. Note this option only applies for the mix types: Pipette or Invert, and when the LoadingSampleMixUntilDissolved is True.",
				ResolutionDescription -> "Automatically set to 30.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 50, 1]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName -> LoadingSampleMaxMixTime,
				Default -> Automatic,
				Description -> "Specify the maximum time for LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) mixing procedure to run, in attempt to dissolve all the solids. Note this option only applies for the Shake mix type, and when the LoadingSampleMixUntilDissolved is True.",
				ResolutionDescription -> "Automatically set to 20 minutes.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Minute, $MaxExperimentTime],
					Units -> {Minute, {Minute, Hour}}
				],
				Category->"Sample Preparation"
			},

			(* Sparging *)
			{
				(* Master switch to control the sparging of the LoadingSample *)
				OptionName -> Sparging,
				Default -> True,
				Description -> "Indicates if the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) within the reaction vessel is sparged with an inert gas before the cyclic voltammetry measurement. This sparging step can remove the dissolved oxygen and carbon dioxide, which can introduce unwanted reduction / oxidation peaks that interfere with the analyte peaks in the cyclic voltammetry output voltammogram.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category->"Sparging"
			},
			{
				OptionName -> SpargingGas,
				Default -> Automatic,
				Description -> "Indicates the type of inert gas used for the sparging of the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) within the reaction vessel. If PretreatmentSparging is True, this type of gas is also used for the pretreatment sparging procedure.",
				ResolutionDescription -> "Automatically resolves to Nitrogen if either PretreatmentSparging or Sparging is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Nitrogen, Argon, Helium]
				],
				Category->"Sparging"
			},
			{
				OptionName -> SpargingTime,
				Default -> Automatic,
				Description -> "Indicates the duration for which the sparging of the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) last. If PretreatmentSparging is True, the same duration is also used for the pretreatment sparging procedure.",
				ResolutionDescription -> "Automatically resolves to 3 minutes if either PretreatmentSparging or Sparging is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[30 Second, $MaxExperimentTime],
					Units -> {Minute, {Minute, Second}}
				],
				Category->"Sparging"
			},
			{
				OptionName -> SpargingPreBubbler,
				Default -> Automatic,
				Description -> "Indicates if a prebubbler is used before the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) reaction vessel. A prebubbler is a container containing the same solvent used in the LoadingSample, which is hooked in series with the reaction vessel, such that the gas is first bubbled through the prebubbler solution and then bubbled into the reaction vessel. This helps to ensure the reaction vessel doesn't excessively evaporate during the sparging, since the sparging gas is saturated by the solvent inside the prebubbler before travelling into the reaction vessel.",
				ResolutionDescription -> "Automatically resolves to True if either PretreatmentSparging or Sparging is True.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category->"Sparging"
			},

			(* Voltammetry *)
			{
				OptionName -> LoadingSampleVolume,
				Default -> Automatic,
				Description -> "Volume of the fully prepared LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) added into the reaction vessel specified by the ReactionVessel option, for the cyclic voltammetry measurement.",
				ResolutionDescription -> "Automatically resolves to 60% of the MaxVolume of the ReactionVessel.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1.5 Milliliter, 20 Milliliter],
					Units -> Milliliter
				],
				Category->"Cyclic Voltammetry"
			},
			{
				OptionName -> InitialPotentials,
				Default -> Automatic,
				Description -> "The potential applied to the working electrode when the LoadingSample (including a solvent, an electrolyte, the target analyte, and an optional internal standard) cyclic voltammetry measurement starts. After the InitialPotential is applied, the working electrode potential is then linearly scanned to the FirstPotential. The length of the list given by this option is required to be either one (the same InitialPotential for each measurement cycle), or equals to the NumberOfCycles option.",
				ResolutionDescription -> "Automatically resolves to a list of 0.0 Volt with a list length of NumberOfCycles.",
				AllowNull -> False,
				Widget -> Adder[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-2.5 Volt, 2.5 Volt],
						Units -> {Volt, {Millivolt, Volt}}
					],
				Orientation -> Vertical],
				Category->"Cyclic Voltammetry"
			},
			{
				OptionName -> FirstPotentials,
				Default -> Automatic,
				Description -> "The first target potential after the InitialPotential is applied. At the FirstPotential, the scanning direction reverses, and the working electrode potential is then linearly scanned to the SecondPotential. The length of the list given by this option is required to be either one (the same FirstPotential for each measurement cycle), or equals to the NumberOfCycles option.",
				ResolutionDescription -> "Automatically resolves to a list of 2.0 Volt with a list length of NumberOfCycles.",
				AllowNull -> False,
				Widget -> Adder[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-2.5 Volt, 2.5 Volt],
						Units -> {Volt, {Millivolt, Volt}}
					],
				Orientation -> Vertical],
				Category->"Cyclic Voltammetry"
			},
			{
				OptionName -> SecondPotentials,
				Default -> Automatic,
				Description -> "The second target potential after the FirstPotential is reached. At the SecondPotential, the scanning direction reverses again, and the working electrode potential is then linearly scanned to the FinalPotential. The length of the list given by this option is required to be either one (the same SecondPotential for each measurement cycle), or equals to the NumberOfCycles option.",
				ResolutionDescription -> "Automatically resolves to a list of -2.0 Volt with a list length of NumberOfCycles.",
				AllowNull -> False,
				Widget -> Adder[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-2.5 Volt, 2.5 Volt],
						Units -> {Volt, {Millivolt, Volt}}
					],
				Orientation -> Vertical],
				Category->"Cyclic Voltammetry"
			},
			{
				OptionName -> FinalPotentials,
				Default -> Automatic,
				Description -> "The final target potential after the SecondPotential is reached. Once the FinalPotential is reached, the current cyclic voltammetry measurement will stop. The length of the list given by this option is required to be either one (the same FinalPotential for each measurement cycle), or equals to the NumberOfCycles option.",
				ResolutionDescription -> "Automatically resolves to a list of 0.0 Volt with a list length of NumberOfCycles.",
				AllowNull -> False,
				Widget -> Adder[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-2.5 Volt, 2.5 Volt],
						Units -> {Volt, {Millivolt, Volt}}
					],
				Orientation -> Vertical],
				Category->"Cyclic Voltammetry"
			},
			{
				OptionName -> PotentialSweepRates,
				Default -> Automatic,
				Description -> "The speed (in Millivolt per Second) at which the working electrode potential is linearly scanned during the cyclic voltammetry measurement. A faster sweep rate generally leads to a larger peak current for the reduction and oxidation peaks of the analyte. The length of the list given by this option is required to be either one (the same PotentialSweepRate for each measurement cycle), or equals to the NumberOfCycles option.",
				AllowNull -> False,
				Widget -> Adder[
					Widget[
						Type -> Quantity,
						(* Specified by the ElectraSyn 2.0 *)
						Pattern :> RangeP[10 Millivolt/Second, 1000 Millivolt/Second],
						Units -> CompoundUnit[
							{1, {Millivolt, {Millivolt, Volt}}},
							{-1, {Second, {Second, Minute}}}
						]
					],
					Orientation -> Vertical],
				Category->"Cyclic Voltammetry"
			},
			{
				OptionName -> NumberOfCycles,
				Default -> 3,
				Description -> "Specify the number of cyclic voltammetry measurements is performed. A cyclic voltammetry measurement starts from the InitialPotential, then to the FirstPotential, then to the SecondPotential, and stops at the FinalPotential. Currently, the NumberOfCycles cannot exceed 4, and the lengths of InitialPotential, FirstPotential, SecondPotential, and FinalPotential lists should all equal to the NumberOfCycles.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 4]
				],
				Category->"Cyclic Voltammetry"
			}
		],
		ModelInputOptions,
		NonBiologyFuntopiaSharedOptions,
		SimulationOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions
	}
];


(* ==== Error and Warning messages ==== *)

(* Precision checks *)
Warning::TargetConcentrationPrecision = "At least one member of the provided `1` has higher precision than the experiment specifications. It has been rounded from `2` to `3`.";
Warning::PotentialsPrecision = "At least one member in the provided `1` has higher precision than the instrument specifications. They have been rounded from `2` to `3`, with the supported precision of 1 Millivolt.";
Warning::PotentialSweepRatePrecision = "At least one member in the provided PotentialSweepRate has higher precision than the instrument specifications. They have been rounded from `1` to `2`, with the supported precision of 10 Millivolt/Second.";

(* Too many inputs *)
Error::TooManyInputSamples = "The number of input samples is `1`, which is greater than the supported max input sample number `2`. Please keep the number of input samples within this limit.";

(* Too Large NumberOfReplicates *)
Error::TooLargeNumberOfReplicates = "The NumberOfReplicates is `1`, which is greater than the supported max NumberOfReplicates value `2`. Please keep the NumberOfReplicates within this limit.";

(* Error::NonNullOption *)
Error::NonNullOption = "The `1` option is specified while `2` is `3` for the following input samples `4`. Please set `1` to Automatic or Null.";
Error::SpecifiedOptionPreparedSample = "The `1` option is specified for the following input prepared liquid samples `2`. Please set `1` to Automatic or Null.";
Error::ConditionalSpecifiedOptionPreparedSample = "The `1` option is specified while `2` is `3` for the following input prepared liquid samples `4`. Please set `1` to Automatic or Null.";

(* Error::MissingOption *)
Error::MissingOption = "The `1` option is set to Null while `2` is `3` for the following input samples `5`. Please set `1` to Automatic or to `4`.";
Error::MissingOptionUnpreparedSample = "The `1` option is set to Null for the following input solid samples `3`. Please set `1` to Automatic or to `2`.";

(* Error::OptionMismatchingLength *)
Error::OptionsMismatchingLength = "The `1` option and `2` option do not have the same list length for the following input samples `3`. Please make sure the lengths of `1` and `2` are the same.";

(* Error::TooSmallVolume *)
Error::TooSmallVolume = "The `1` `2` is smaller than 30% of the `3` `4` for the following input samples `6`. Please set `1` to Automatic or to `5`.";

(* Error::TooLargeVolume *)
Error::TooLargeVolume = "The `1` `2` is greater than 90% of the `3` `4` for the following input samples `6`. Please set `1` to Automatic or to `5`.";

(* Error::TooLowConcentration *)
Error::TooLowConcentration = "`1` for the following input samples `3`. Please `2`.";

(* Error::TooHighConcentration *)
Error::TooHighConcentration = "`1` for the following input samples `3`. Please `2`.";

(* Incompatible options *)
Error::IncompatibleOptions = "`1` for the following input samples `3`. Please `2`.";

(* Mismatching Molecule options *)
Error::MismatchingMolecules = "`1` for the following input samples `3`. Please `2`.";

(* Mismatching warnings *)
Warning::MismatchingOptionsWarning = "`1` for the following input samples `3`. Please `2`.";

(* ChemicalNotSolid *)
Error::ChemicalNotSolid = "The specified `1` chemical is not a solid for the following input samples `3`. Please make sure the specified `1` chemical is a solid. `2`";

(* NotLiquid *)
Error::ChemicalNotLiquid = "The specified `1` is not a liquid solution for the following input samples `2`. Please make sure the specified `1` is a liquid solution.";

(* AmbiguousComposition *)
Error::AmbiguousComposition = "`1` for the following input samples `3`. Please `2`.";

(* MissingInformation *)
Error::MissingInformation = "`1` for the following input samples `3`. Please `2`.";

(* Electrodes *)
Error::DeprecatedElectrodeModel = "The provided `1` model `2` is deprecated. Please use the default value of `1` option, set `1` to Automatic, or provide a non-deprecated `1` model.";

(* Polishing Parameters *)
Error::CoatedWorkingElectrode = "The WorkingElectrode is coated and should not be polished for the following input samples `1`. Please set PolishWorkingElectrode to False.";

Error::NonPolishingSolutions = "The following solution(s) `1` provided in the PolishingSolutions is/are not polishing solution(s) for the input sample `2`. Please set PolishingSolutions for this sample to Automatic or provide a list of  polishing solutions models or objects.";
Warning::NonDefaultPolishingSolutions = "The following solution(s) `1` provided in the PolishingSolutions does/do not match with the default polishing solution model in the corresponding polishing pads, for the input sample `2`. Please consider to set PolishingSolutions for this sample to Automatic or provide a list of default polishing solutions models in the polishing pads.";

(* WorkingElectrode Sonication Parameters *)
Error::SonicationSensitiveWorkingElectrode = "The WorkingElectrode is sensitive to sonication and should not be sonicated for the following input samples `1`. Please set WorkingElectrodeSonication to False.";

(* Loading Sample Volume Parameters *)
Error::MismatchingSampleState = "The sample state for the following input samples `1` do not match with their PreparedSample option. Please set PreparedSample to False for solid input samples and set PreparedSample to True for liquid input samples.";
Error::TooSmallSolventVolume = "The SolventVolume `1` is either smaller than 30% of the ReactionVessel MaxVolume `2` and/or smaller than the LoadingSampleVolume `3` for the following input sample `4`. Please set SolventVolume to Automatic or to a volume between 30% and 90% of the ReactionVessel MaxVolume and also no less than the LoadingSampleVolume.";
Warning::ExcessiveSolventVolume = "The SolventVolume `1` is greater than the LoadingSampleVolume `2` for the following input sample `3`. Extra LoadingSample solution will be stored under the storage condition of the Solvent option. To avoid extra solution storage, consider setting SolventVolume to Automatic or to a volume equals to the LoadingSampleVolume.";

(* Error:UnresolvableUnit *)
(* SampleAnalyteUnresolvableUnit, SampleElectrolyteMoleculeWithUnresolvableCompositionUnit, ElectrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnit *)
Error::UnresolvableUnit = "`1` for the following input samples `3`. Please `2`.";

Error::CannotResolveElectrolyte = "The electrolyte molecule cannot be automatically identified for the following input prepared liquid samples `1`. This is likely caused by a prepared liquid sample with InternalStandard molecule. Please use the Electrolyte option to specify the electrolyte chemical contained in the prepared liquid sample";

(* ReferenceElectrode, ReferenceSolution related option messages *)
(* Errors *)
(* Error:ReferenceElectrode *)
Error::ReferenceElectrode = "`1` for the following input samples `3`. Please `2`.";
Error::TooLongSoakTime = "The specified ReferenceElectrodeSoakTime is longer than 15 Minutes for the following input samples `1`. Please set ReferenceElectrodeSoakTime to a duration between 1 Minute and 15 Minutes.";

(* InternalStandard related option messages *)
Error::InternalStandard = "`1` for the following input samples `3`. Please `2`.";

(* Pretreat electrodes related option messages *)
Error::IncompatiblePotentials = "The `1` is not between `2` and `3` for the following input samples `4`. Please set `1` to be between `2` and `3`.";
Error::TooDifferentPotentials = "The voltage differentce between `1` and `2` is greater than 0.5 Volt for the following input samples `3`. Please make sure the voltage difference between `1` and `2` is less than 0.5 Volt.";


(* Sparging related option messages *)
Error::TooLongSpargingTime = "The SpargingTime is longer than 1 Hour for the following input samples `1`. Please set SpargingTime to Automatic or to a duration between 30 Second and 1 Hour when Sparging is set to True.";


(* CyclicVoltammetry measurement related option messages *)
Error::MismatchNumberOfCycles = "The length of the `1` option list does not match with NumberOfCycles for the following input samples `2`. Please make sure the length of `1` list matches with NumberOfCycles.";
Error::IncompatiblePotentialLists = "At least one entry in the `1` list is not between its corresponding entries in the `2` list and `3` list for the following input samples `1`. Please make sure each entry in the `1` list to be between its corresponding entries in the `2` list and `3` list.";

Error::PotentialsTooDifferent = "At least one entry in the InitialPotentials has a voltage difference greater than 0.5 Volt with its corresponding entry in the FinalPotentials list for the following input samples `1`. Please make sure each entry in the InitialPotentials has a voltage difference less than 0.5 Volt with its corresponding entry in the FinalPotentials list.";

(* ::Subsubsection::Closed:: *)
(*ExperimentCyclicVoltammetry: Experiment Function*)

ExperimentCyclicVoltammetry[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[ExperimentCyclicVoltammetry]]:=Module[
	{
		outputSpecification, output, gatherTests, messages,
		listedSamples, listedOptions,
		validSamplePreparationResult, mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation,
		safeOpsNamed, safeOpsTests,
		mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples,
		validLengths,validLengthTests,
		upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache,
		templatedOptions,templateTests,
		inheritedOptions,expandedSafeOps,

		(* fake object tracking *)
		optionsWithObjects, userSpecifiedObjects, simulatedSampleQ, objectsExistQs, objectsExistTests,

		(* -- variables from safeOps and download -- *)
		samplePreparationPackets, sampleModelPreparationPackets,
		allModelSamplesFromOptions, allObjectSamplesFromOptions, allInstrumentObjectsFromOptions, allObjectsFromOptions, allInstrumentModelsFromOptions,
		containerPreparationPackets, modelPreparationPackets, liquidHandlerContainers, modelContainerPacketFields, analyteFields, analytesPackets, compositionPackets, solventModelSamplePackets, solventMoleculePackets, defaultSampleModelPackets,

		(* Electrodes *)
		allElectrodeModels, allElectrodeObjects, referenceElectrodeModels, referenceElectrodeObjects, normalElectrodeModels, normalElectrodeObjects,

		referenceElectrodeModelFields, referenceElectrodeObjectFields, electrodeModelFields, electrodeObjectFields,

		(* ElectrodeCap *)
		electrodeCapModel, electrodeCapObject, electrodeCapModelFields, electrodeCapObjectFields,

		(* Potential Containers and Needles *)
		potentialContainerModels, potentialNeedleModels, needleModelFields,

		(* PolishingPad *)
		polishingPadModels, polishingPadObjects, polishingPadModelFields, polishingPadObjectFields, polishingPadPlateModelFields,

		(* ReactionVessels *)
		reactionVesselModels, reactionVesselObjects, reactionVesselModelFields, reactionVesselObjectFields,

		(* Analyte *)
		analyteMolecules, analyteMoleculeFields,

		(* Solvent, ElectrolyteSolution, ReferenceSolution, Electrolyte, InternalStandard *)
		allOptionSampleModels, allOptionSampleObjects, optionSampleModelFields, optionSampleObjectFields,

		(* Tubings *)
		allTubingModels, tubingModelFields,

		cacheBall,resolvedOptionsResult, resolvedOptions,resolvedOptionsTests, collapsedResolvedOptions,
		returnEarlyQ, performSimulationQ,
		resourcePackets,resourcePacketTests,
		simulatedProtocol, simulation,
		protocolObject
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Remove temporal links. *)
	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentCyclicVoltammetry,
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
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentCyclicVoltammetry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentCyclicVoltammetry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Sanitize Inputs *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed,Simulation->updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentCyclicVoltammetry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentCyclicVoltammetry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
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

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache} = Lookup[safeOps, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentCyclicVoltammetry,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentCyclicVoltammetry,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
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
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentCyclicVoltammetry,{mySamplesWithPreparedSamples},inheritedOptions]];


	(* ----------------------------------------------------------------------------------- *)
	(* -- DOWNLOAD THE INFORMATION FOR THE OPTION RESOLVER AND RESOURCE PACKET FUNCTION -- *)
	(* ----------------------------------------------------------------------------------- *)

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	samplePreparationPackets = Packet[SamplePreparationCacheFields[Object[Sample], Format->Sequence], Volume, IncompatibleMaterials, RequestedResources, LiquidHandlerIncompatible, Well, Composition, Tablet];
	sampleModelPreparationPackets = Packet[Model[Flatten[{Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials,RentByDefault, SamplePreparationCacheFields[Model[Sample]]}]]];
	containerPreparationPackets = Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], Model}]]];
	modelPreparationPackets = Packet[SamplePreparationCacheFields[Model[Sample], Format->Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials];
	analyteFields = {Name, Type, MolecularWeight, DefaultSampleModel};
	analytesPackets = Packet[Analytes[analyteFields]];
	compositionPackets = Packet[Field[Composition[[All, 2]]][analyteFields]];
	solventModelSamplePackets = Packet[Field[Solvent][{SamplePreparationCacheFields[Model[Sample], Format->Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials}]];
	defaultSampleModelPackets = Packet[Field[Composition[[All, 2]]][DefaultSampleModel][{SamplePreparationCacheFields[Model[Sample], Format->Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, RentByDefault, IncompatibleMaterials}]];

	(* look up the values of the options and select ones that are objects/models *)
	allObjectsFromOptions = DeleteDuplicates[Cases[Values[KeyDrop[expandedSafeOps, {Cache,Simulation}]], ObjectP[], Infinity]];

	(* break into their types *)
	allInstrumentObjectsFromOptions = Cases[allObjectsFromOptions, ObjectP[Object[Instrument,Reactor,Electrochemical]]];
	allInstrumentModelsFromOptions = Cases[allObjectsFromOptions, ObjectP[Model[Instrument,Reactor,Electrochemical]]];

	(* download the object here since there will be a packet also from simulation *)
	allObjectSamplesFromOptions = DeleteCases[Download[Cases[allObjectsFromOptions, ObjectP[Object[Sample]]], Object], Alternatives@@ToList[mySamplesWithPreparedSamples[Object]]];
	allModelSamplesFromOptions = DeleteDuplicates[
     	Join[
		DeleteCases[Download[Cases[allObjectsFromOptions, ObjectP[Model[Sample]]], Object], Alternatives@@ToList[Download[mySamplesWithPreparedSamples, Model[Object], Cache -> Lookup[updatedSimulation[[1]], Packets]]]],

			(* Default Model[Sample]s that may be used by Automatic options *)
			{
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Acetonitrile, Electronic Grade"],
				Model[Sample, "Potassium Chloride"],
				Model[Sample, "Silver nitrate"],
				Model[Sample, "Tetrabutylammonium hexafluorophosphate"],
				Model[Sample, "Ferrocene"],
				Model[Sample, "1 um diamond polish, KitComponent"],
				Model[Sample, "0.05 um Polishing alumina, KitComponent"],
				Model[Sample, StockSolution, "3M KCl Aqueous Solution, 10 mL"],
				Model[Sample, StockSolution, "0.1M [NBu4][PF6] in acetonitrile, 10 mL"],
				Model[Sample, StockSolution, "0.1M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"],
				Model[Sample, StockSolution, "0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]
			}
		]
	];

	(* get liquid handler compatible containers *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* download fields for liquid handler compatible containers *)
	modelContainerPacketFields=Packet@@Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];

	(* -- electrodes -- *)
	allElectrodeModels = Cases[allObjectsFromOptions, ObjectP[Model[Item,Electrode]]];
	allElectrodeObjects = Cases[allObjectsFromOptions, ObjectP[Object[Item,Electrode]]];

	(* Reference Electrodes *)
	referenceElectrodeModels = DeleteDuplicates[
		Join[
			Cases[allElectrodeModels, ObjectP[Model[Item,Electrode,ReferenceElectrode]]],

			(* Default Model[Item, Electrode, ReferenceElectrodes] that may be used by Automatic options *)
			{
				Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
				Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
				Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
				Model[Item, Electrode, ReferenceElectrode, "0.01M AgNO3 Ag/Ag+ Reference Electrode"]
			}
		]
	];
	referenceElectrodeObjects = Cases[allElectrodeObjects, ObjectP[Object[Item,Electrode, ReferenceElectrode]]];

	referenceElectrodeModelFields =
	{
		Packet[Object, Name, Deprecated, Coated, ReferenceElectrodeType, RecommendedSolventType, ReferenceSolution, RecommendedRefreshPeriod, Dimensions,RentByDefault],
		Packet[ReferenceSolution[{SamplePreparationCacheFields[Model[Sample], Format->Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials}]],
		Packet[ReferenceSolution[Field[Composition[[All, 2]]]][analyteFields]],
		Packet[ReferenceSolution[Field[Solvent]][analyteFields]],
		Packet[ReferenceSolution[Field[Solvent]][{SamplePreparationCacheFields[Model[Sample], Format->Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials}]]
	};

	referenceElectrodeObjectFields =
	{
		Packet[Object, Model, Name, CurrentSolutionVolume, ReferenceElectrodeModelLog, RefreshLog],
		Packet[Model[{Name, Deprecated, Coated, ReferenceElectrodeType, RecommendedSolventType, ReferenceSolution, RecommendedRefreshPeriod, Dimensions,RentByDefault}]],
		Packet[Model[ReferenceSolution][{SamplePreparationCacheFields[Model[Sample], Format->Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials}]],
		Packet[Model[ReferenceSolution][Field[Composition[[All, 2]]]][analyteFields]],
		Packet[Model[ReferenceSolution][Field[Solvent]][analyteFields]],
		Packet[Model[ReferenceSolution][Field[Solvent]][{SamplePreparationCacheFields[Model[Sample], Format->Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials}]]
	};

	(* WorkingElectrode, CounterElectrode *)
	normalElectrodeModels = DeleteCases[allElectrodeModels, ObjectP[Model[Item,Electrode,ReferenceElectrode]]];
	normalElectrodeObjects = DeleteCases[allElectrodeObjects, ObjectP[Object[Item,Electrode,ReferenceElectrode]]];

	(* normal electrode fields *)
	electrodeModelFields = Packet[Object, Name, Deprecated, Coated, MaxNumberOfPolishings, PolishingSolutions, PolishingPads, SonicationSensitive, RequestedResources,RentByDefault];
	electrodeObjectFields = Packet[Object, Model, Coated, PolishingSolutions, PolishingPads, SonicationSensitive, NumberOfPolishings, RequestedResources];

	(* -- ElectrodeCap -- *)
	electrodeCapModel = Cases[allObjectsFromOptions, ObjectP[Model[Item, Cap, ElectrodeCap]]];
	electrodeCapObject = Cases[allObjectsFromOptions, ObjectP[Object[Item, Cap, ElectrodeCap]]];

	(* ElectrodeCap Fields *)
	electrodeCapModelFields = {Packet[Object, Name, ElectrodeCapType, Dimensions, Connectors, RequestedResources,RentByDefault]};
	electrodeCapObjectFields = {
		Packet[Object, Model, ElectrodeCapType, Connectors, RequestedResources],
		Packet[Model[Dimensions]]
	};

	(* Some containers that may be used *)
	potentialContainerModels = DeleteDuplicates[Join[
		{
			(* SquirtBottles *)
			Model[Container, Vessel, "500 mL Squirt Bottle, Unlabeled"],
			Model[Container, Vessel, "500 mL Squirt Bottle, MilliQ Water"],
			Model[Container, Vessel, "500 mL Squirt Bottle, Methanol"],

			(* PreBubbler *)
			Model[Container, Vessel, GasWashingBottle, "SYNTHWARE Gas Washing Bottle, 125 mL"]
		},
		(* PreferredContainers *)
		PreferredContainer[All]
	]];

	(* Needles that may be used *)
	potentialNeedleModels = Search[Model[Item, Needle], Deprecated != True && ConnectionType == LuerLock];

	(* Needle fields *)
	needleModelFields = Packet[Object, Name, NeedleLength, RentByDefault];

	(* -- PolishingPad -- *)
	polishingPadModels = DeleteDuplicates[Join[
		Cases[allObjectsFromOptions, ObjectP[Model[Item,ElectrodePolishingPad]]],

		(* Default polishing pad models *)
		{
			Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"],
			Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"]
		}
	]];
	polishingPadObjects = Cases[allObjectsFromOptions, ObjectP[Object[Item,ElectrodePolishingPad]]];

	(* PolishingPad Fields *)
	polishingPadModelFields = Packet[Object, Name, DefaultPolishingSolution, DefaultPolishingPlate, RequestedResources,RentByDefault];
	polishingPadObjectFields = Packet[Object, Model, DefaultPolishingSolution, DefaultPolishingPlate, RequestedResources];
	polishingPadPlateModelFields = Packet[DefaultPolishingPlate[{Type, Object, Name}]];

	(* -- ReactionVessels -- *)
	reactionVesselModels = Cases[allObjectsFromOptions, ObjectP[Model[Container, ReactionVessel, ElectrochemicalSynthesis]]];
	reactionVesselObjects = Cases[allObjectsFromOptions, ObjectP[Object[Container, ReactionVessel, ElectrochemicalSynthesis]]];

	(* ReactionVessel Fields *)
	reactionVesselModelFields = Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence], Connectors];
	reactionVesselObjectFields = {
		Packet[Model, MaxVolume, Connectors, SamplePreparationCacheFields[Object[Container], Format -> Sequence]],
		Packet[Model[{SamplePreparationCacheFields[Model[Container], Format -> Sequence], Connectors, Dimensions}]]
	};

	(* -- Analyte -- *)
	analyteMolecules = Cases[allObjectsFromOptions, ObjectP[Model[Molecule]]];

	(* Molecule Fields *)
	analyteMoleculeFields = Packet[Sequence@@analyteFields];

	(* -- PolishingSolutions, Solvent, ElectrolyteSolution, ReferenceSolution, Electrolyte, InternalStandard -- *)
	allOptionSampleModels = Cases[allObjectsFromOptions, ObjectP[Model[Sample]]];
	allOptionSampleObjects = Cases[allObjectsFromOptions, ObjectP[Object[Sample]]];

	(* Option Sample Fields *)
	(* Also reach inside the Analytes field and download their MolecularWeight *)
	optionSampleModelFields = {
		Packet[Object, Name, State, Composition, Solvent, Analytes, RentByDefault],
		Packet[Analytes[{MolecularWeight, Name}]]
	};
	optionSampleObjectFields = {
		Packet[Object, Model, State, Composition, Solvent, Analytes],
		Packet[Analytes[{MolecularWeight, Name}]]
	};

	(* Tubings *)
	allTubingModels = {
		Model[Plumbing, Tubing, "Low Vac Adapter"],
		Model[Plumbing, Tubing, "Luer Lock & Quick Disconnect"]
	};

	tubingModelFields = {
		Packet[Object, Name]
	};

	(* make the big download call *)
	cacheBall = Quiet[
		FlattenCachePackets[
			{
				inheritedCache,
				Download[
					{
						ToList[mySamplesWithPreparedSamples],
						allInstrumentObjectsFromOptions,
						allInstrumentModelsFromOptions,
						allObjectSamplesFromOptions,
						allModelSamplesFromOptions,
						liquidHandlerContainers,
						referenceElectrodeModels,
						referenceElectrodeObjects,
						normalElectrodeModels,
						normalElectrodeObjects,
						electrodeCapModel,
						electrodeCapObject,
						potentialContainerModels,
						potentialNeedleModels,
						polishingPadModels,
						polishingPadObjects,
						reactionVesselModels,
						reactionVesselObjects,
						analyteMolecules,
						allTubingModels
					},
					{
						{
							samplePreparationPackets,
							sampleModelPreparationPackets,
							containerPreparationPackets,
							analytesPackets,
							compositionPackets,
							solventModelSamplePackets,
							solventMoleculePackets,
							defaultSampleModelPackets
						},
						{
							Packet[Object,Name,Status,Model,RequestedResources],
							Packet[Model[{Object,Name, WettedMaterials, RentByDefault}]]
						},
						{
							Packet[Object, Name, WettedMaterials, RentByDefault]
						},
						{
							samplePreparationPackets,
							sampleModelPreparationPackets,
							analytesPackets,
							compositionPackets,
							solventModelSamplePackets,
							solventMoleculePackets,
							defaultSampleModelPackets
						},
						{
							modelPreparationPackets,
							analytesPackets,
							compositionPackets,
							solventModelSamplePackets,
							solventMoleculePackets,
							defaultSampleModelPackets
						},
						{
							modelContainerPacketFields
						},
						referenceElectrodeModelFields,
						referenceElectrodeObjectFields,
						{
							electrodeModelFields
						},
						{
							electrodeObjectFields
						},
						electrodeCapModelFields,
						electrodeCapObjectFields,
						{
							modelContainerPacketFields
						},
						{
							needleModelFields
						},
						{
							polishingPadModelFields,
							polishingPadPlateModelFields
						},
						{
							polishingPadObjectFields,
							polishingPadPlateModelFields
						},
						{
							reactionVesselModelFields
						},
						reactionVesselObjectFields,
						{
							analyteMoleculeFields
						},
						tubingModelFields
					},
					Cache -> inheritedCache,
					Simulation -> updatedSimulation,
					Date -> Now
				]
			}
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* -------------------------- *)
	(* --- RESOLVE THE OPTIONS ---*)
	(* -------------------------- *)

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,

		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentCyclicVoltammetryOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentCyclicVoltammetryOptions[ToList[mySamples],expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];


	(* ---------------------------- *)
	(* -- PREPARE OPTIONS OUTPUT -- *)
	(* ---------------------------- *)

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentCyclicVoltammetry,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentCyclicVoltammetry,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentIncubate,collapsedResolvedOptions],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	(* ---------------------------- *)
	(* Build packets with resources *)
	(* ---------------------------- *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		cyclicVoltammetryResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
		{cyclicVoltammetryResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions, collapsedResolvedOptions, Cache->cacheBall,Simulation->updatedSimulation],{}}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentCyclicVoltammetry[resourcePackets,ToList[mySamplesWithPreparedSamples],resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],
		{Null, updatedSimulation}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentCyclicVoltammetry,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
	protocolObject=Which[

		(* If resource packets could not be generated or options could not be resolved, can't generate a protocol, return $Failed *)
		MatchQ[resourcePackets,$Failed] || MatchQ[resolvedOptionsResult,$Failed],
			$Failed,

		(* Actually upload our protocol object. *)
		True,
			UploadProtocol[
				resourcePackets,
				Upload->Lookup[safeOps,Upload],
				Confirm->Lookup[safeOps,Confirm],
				CanaryBranch->Lookup[safeOps,CanaryBranch],
				ParentProtocol->Lookup[safeOps,ParentProtocol],
				Priority->Lookup[safeOps,Priority],
				StartDate->Lookup[safeOps,StartDate],
				HoldOrder->Lookup[safeOps,HoldOrder],
				QueuePosition->Lookup[safeOps,QueuePosition],
				ConstellationMessage->Object[Protocol,CyclicVoltammetry],
				Cache -> cacheBall,
				Simulation -> simulation
			]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentCyclicVoltammetry,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation
	}
];



(* -------------------------- *)
(* --- CONTAINER OVERLOAD --- *)
(* -------------------------- *)

ExperimentCyclicVoltammetry[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{
		outputSpecification,output,gatherTests,
		listedContainers, listedOptions,
		validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation,
		containerToSampleResult,containerToSampleTests,containerToSampleOutput,
		samples,sampleOptions,
		containerToSampleSimulation
	},

	(*
	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];
	*)

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links. *)
	{listedContainers, listedOptions}={ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentCyclicVoltammetry,
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
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentCyclicVoltammetry,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentCyclicVoltammetry,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Simulation->updatedSimulation,
				EmptyContainers->MatchQ[$ECLApplication,Engine]
			],
			$Failed,
			{Error::EmptyContainer}
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
			Simulation -> Null,
			InvalidInputs -> {},
			InvalidOptions -> {}
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentCyclicVoltammetry[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];



(* ::Subsection::Closed:: *)
(* resolveExperimentCyclicVoltammetryOptions *)


(* ---------------------- *)
(* -- OPTIONS RESOLVER -- *)
(* ---------------------- *)


DefineOptions[
	resolveExperimentCyclicVoltammetryOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentCyclicVoltammetryOptions[
	mySamples:{ObjectP[Object[Sample]]...},
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentCyclicVoltammetryOptions]
]:=Module[
	{
		outputSpecification,output,gatherTests,cache,samplePrepOptions,cyclicVoltammetryOptions,simulatedSamples,resolvedSamplePrepOptions,updatedSimulation,samplePrepTests, cyclicVoltammetryOptionsAssociation,
		cyclicVoltammetryTests, invalidInputs,invalidOptions,targetContainers,resolvedAliquotOptions,aliquotTests, fullcyclicVoltammetryOptionsAssociation, resolvedOptions, mapThreadFriendlyOptions, resolvedPostProcessingOptions,
		invalidSamplesInStorageConditionOption,

		(* -- download related variables -- *)
		inheritedCache, simulation, sampleObjectPrepFields, sampleModelPrepFields, samplePackets, sampleModelPackets, newCache, allDownloadValues,
		allSampleObjectPackets, allSampleModelPackets, allSampleModelFields, allSampleObjectFields, allSampleModelOptions, allSampleObjectOptions, modelContainerPacketFields,
		liquidHandlerContainers, liquidHandlerContainerPackets,

		(* -- invalid input tests and variables -- *)
		discardedSamplePackets, discardedInvalidInputs,discardedTest, messages, validNameQ, nameInvalidOptions,
		validNameTest, modelPacketsToCheckIfDeprecated, deprecatedTest, deprecatedInvalidInputs, deprecatedModelPackets, validSamplesInStorageConditionTests,

		(* -- samples in storage condition -- *)
		samplesInStorageCondition, validSamplesInStorageBool, validSamplesInStorageConditionBools,

		(* Too many input sample *)
		maxNumberOfSamples, numberOfInputSamples, tooManyInputSamplesInvalidInputs, tooManyInputSamplesTest,

		(* Too large NumberOfReplicates *)
		numberOfReplicates, maxNumberOfReplicates, tooLargerNumberOfReplicatesInvalidOptions, tooLargeNumberOfReplicatesTests,

		compatibleMaterialsBool, compatibleMaterialsTests, compatibleMaterialsInvalidInputs,
		globalMinMass, globalMinVolume,

		(* Electrodes *)
		electrodeModelsToCheckIfDeprecated, referenceElectrodeModelsToCheckIfDeprecated, workingElectrodeModelsToCheckIfDeprecated, counterElectrodeModelsToCheckIfDeprecated,

		deprecatedWorkingElectrodeModelPackets, deprecatedWorkingElectrodeModels,deprecatedWorkingElectrodeModelInvalidOption,deprecatedWorkingElectrodeModelTest,
		deprecatedCounterElectrodeModelPackets, deprecatedCounterElectrodeModels, deprecatedCounterElectrodeModelInvalidOption,deprecatedCounterElectrodeModelTest,
		deprecatedReferenceElectrodeModelPackets, deprecatedReferenceElectrodeModels, deprecatedReferenceElectrodeModelInvalidOption, deprecatedReferenceElectrodeModelTest,

		(* ====== option rounding ====== *)
		roundedGeneralOptions, roundedOptions, generalOptionPrecisions, generalPrecisionTests,

		(* -- Concentration rounding -- *)
		concentrationOptions, concentrationMolarPrecisions, concentrationMassVolumePrecisions, roundedElectrolyteTargetConcentration, roundedElectrolyteTargetConcentrationTest, roundedLoadingSampleTargetConcentration, roundedLoadingSampleTargetConcentrationTest, roundedInternalStandardTargetConcentration, roundedInternalStandardTargetConcentrationTest,

		(* -- Potentials rounding -- *)
		potentialOptions, potentialPrecisions, roundedInitialPotentials, roundedInitialPotentialsTest, roundedFirstPotentials, roundedFirstPotentialsTest, roundedSecondPotentials, roundedSecondPotentialsTest, roundedFinalPotentials, roundedFinalPotentialsTest,

		(* -- PotentialSweepRates rounding -- *)
		potentialSweepRatesInMillivoltSecond, roundedPotentialSweepRates, roundedPotentialSweepRateTest,

		(* -- Instrument -- *)
		instrument,

		(* ====== Global variables for MapThread ====== *)
		legitPolishingSolutionModels,

		(* -- map thread output -- *)
		mapThreadResolvedOptionAssociations, mapThreadErrorTrackingAssociations, mapThreadWarningTrackingAssociations,
		resolvedOptionsAssociation, resolvedErrorCheckingAssociation, resolvedWarningCheckingAssociation,

		(* ====== Error and Warning Tracking ====== *)
		(* -- working electrode polishing options -- *)
		samplePacketsWithCoatedWorkingElectrode,
		samplePacketsWithNonNullPolishingPads,
		samplePacketsWithNonNullPolishingSolutions,
		samplePacketsWithNonNullNumberOfPolishingSolutionDroplets,
		samplePacketsWithNonNullNumberOfPolishings,
		samplePacketsWithMissingPolishingPads,
		samplePacketsWithMissingPolishingSolutions,
		samplePacketsWithMissingNumberOfPolishingSolutionDroplets,
		samplePacketsWithMissingNumberOfPolishings,
		samplePacketsWithMisMatchingPolishingSolutionsLength,
		samplePacketsWithMisMatchingNumberOfPolishingSolutionDropletsLength,
		samplePacketsWithMisMatchingNumberOfPolishingsLength,
		samplePacketsWithNonPolishingSolutions,
		samplePacketsWithNonDefaultPolishingSolutions,
		nonPolishingSolutions,
		nonDefaultPolishingSolutions,

		(* -- working electrode sonication options -- *)
		samplePacketsWithSonicationSensitiveWorkingElectrode,
		samplePacketsWithNonNullSonicationTime,
		samplePacketsWithNonNullSonicationTemperature,
		samplePacketsWithMissingSonicationTime,
		samplePacketsWithMissingSonicationTemperature,

		(* -- electrode washing options -- *)
		samplePacketsWithNonNullWorkingElectrodeWashingCycles,
		samplePacketsWithMissingWorkingElectrodeWashingCycles,

		(* -- loading sample volume options -- *)
		samplePacketsWithMismatchingSampleState,
		samplePacketsWithMismatchingReactionVesselWithElectrodeCap,
		samplePacketsWithNonNullSolventVolume,
		samplePacketsWithMissingSolventVolume,
		samplePacketsWithTooSmallSolventVolume,
		samplePacketsWithTooSmallLoadingSampleVolume,
		samplePacketsWithTooLargeLoadingSampleVolume,
		samplePacketsWithSolventVolumeLargerThanLoadingVolume,

		solventVolumes,
		loadingSampleVolumes,
		sampleAmounts,
		reactionVesselMaxVolumes,
		indicesForTooSmallSolventVolume,
		solventVolumesForTooSmallSolventVolume,
		reactionVesselMaxVolumesForTooSmallSolventVolume,
		loadingSampleVolumesForTooSmallSolventVolume,
		indicesForTooSmallLoadingSampleVolume,
		loadingSampleVolumesForTooSmallLoadingSampleVolume,
		reactionVesselMaxVolumesForTooSmallLoadingSampleVolume,
		indicesForTooLargeLoadingSampleVolume,
		loadingSampleVolumesForTooLargeLoadingSampleVolume,
		reactionVesselMaxVolumesForTooLargeLoadingSampleVolume,
		indicesForSolventVolumeLargerThanLoadingSampleVolume,
		solventVolumesForSolventVolumeLargerThanLoadingSampleVolume,
		loadingSampleVolumesForSolventVolumeLargerThanLoadingSampleVolume,

		(* -- analyte related options -- *)
		samplePacketsWithMissingComposition,
		samplePacketsWithMissingAnalyte,
		samplePacketsWithIncompleteComposition,
		samplePacketsWithAmbiguousAnalyte,
		samplePacketsWithMismatchingAnalyte,
		samplePacketsWithUnresolvableCompositionUnit,
		samplePacketsWithMissingSampleAmount,
		samplePacketsWithMissingLoadingSampleTargetConcentration,
		samplePacketsWithNonNullSampleAmount,
		samplePacketsWithNonNullTargetConcentration,
		samplePacketsWithMismatchingConcentrationParameters,
		samplePacketsWithTooLowLoadingSampleTargetConcentration,
		samplePacketsWithTooHighLoadingSampleTargetConcentration,

		(* -- solvent and electrolyte -- *)
		(* Errors *)
		samplePacketsWithPreparedSampleMissingSolvent,
		samplePacketsWithSampleSolventAmbiguousMolecule,

		samplePacketsWithElectrolyteSolutionNotLiquid,
		samplePacketsWithElectrolyteSolutionMissingSolvent,
		samplePacketsWithElectrolyteSolutionMissingAnalyte,
		samplePacketsWithElectrolyteSolutionAmbiguousAnalyte,
		samplePacketsWithElectrolyteSolutionSolventAmbiguousMolecule,

		samplePacketsWithSolventNotLiquid,
		samplePacketsWithSolventAmbiguousMolecule,

		samplePacketsWithSolventMoleculeMismatchPreparedSampleSolventMolecule,
		samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMolecule,
		samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchSolventMolecule,

		samplePacketsWithSampleElectrolyteMoleculeWithUnresolvableCompositionUnit,
		samplePacketsWithSampleElectrolyteMoleculeMissingMolecularWeight,
		samplePacketsWithSampleElectrolyteMoleculeMissingDefaultSampleModel,
		samplePacketsWithSampleElectrolyteMoleculeNotFound,
		samplePacketsWithSampleAmbiguousElectrolyteMolecule,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingDefaultSampleModel,
		samplePacketsWithElectrolyteSampleAmbiguousMolecule,
		samplePacketsWithElectrolyteSampleNotSolid,
		samplePacketsWithElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingMolecularWeight,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule,
		samplePacketsWithCannotAutomaticallyResolveElectrolyte,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeNotFound,
		samplePacketsWithElectrolyteSolutionAmbiguousElectrolyteMolecule,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnit,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMolecule,

		samplePacketsWithNonNullElectrolyteSolution,
		samplePacketsWithNonNullElectrolyteSolutionLoadingVolume,
		samplePacketsWithNonNullLoadingSampleElectrolyteAmount,

		samplePacketsWithMissingElectrolyteSolutionLoadingVolume,
		samplePacketsWithMissingElectrolyteTargetConcentration,
		samplePacketsWithMissingLoadingSampleElectrolyteAmount,
		samplePacketsWithMissingElectrolyteSolution,

		samplePacketsWithTooSmallElectrolyteSolutionLoadingVolume,
		samplePacketsWithTooLargeElectrolyteSolutionLoadingVolume,

		samplePacketsWithTooLowElectrolyteTargetConcentration,
		samplePacketsWithTooHighElectrolyteTargetConcentration,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSample,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentration,
		samplePacketsWithElectrolyteTargetConcentrationMismatchPreparedSample,

		samplePacketsWithLoadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentration,

		(* Warnings *)
		samplePacketsWithSolventMismatchPreparedSampleSolvent,
		samplePacketsWithElectrolyteSolutionSolventMismatchSolvent,

		(* -- ReferenceElectrode and ReferenceSolution options -- *)
		(* Errors *)
		samplePacketsWithReferenceElectrodeUnprepared,
		samplePacketsWithReferenceElectrodeNeedRefreshRequiresRefresh,
		samplePacketsWithElectrodeReferenceSolutionInformationError,
		samplePacketsWithTooLongReferenceElectrodeSoakTime,

		(* Warnings *)
		samplePacketsWithReferenceElectrodeRecommendedSolventTypeMismatchSolvent,
		samplePacketsWithElectrodeReferenceSolutionSolventMoleculeMismatchWarning,
		samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeMismatchWarning,
		samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatchWarning,

		(* -- InternalStandard options -- *)
		(* Errors *)
		samplePacketsWithInternalStandardNotSolid,
		samplePacketsWithPreparedSampleInvalidCompositionLengthForNoneInternalStandard,
		samplePacketsWithResolvedInternalStandardAmbiguousMolecule,
		samplePacketsWithNonNullInternalStandardAdditionOrder,
		samplePacketsWithMissingInternalStandardAdditionOrder,
		samplePacketsWithPreparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrder,
		samplePacketsWithPreparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrder,
		samplePacketsWithInternalStandardNotACompositionMemberForPreparedSample,
		samplePacketsWithInternalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrder,
		samplePacketsWithNonNullInternalStandardTargetConcentrationForNoneInternalStandard,
		samplePacketsWithNonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSample,
		samplePacketsWithMissingInternalStandardTargetConcentrationForAfterAdditionOrder,
		samplePacketsWithMissingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSample,
		samplePacketsWithTooLowInternalStandardTargetConcentration,
		samplePacketsWithTooHighInternalStandardTargetConcentration,
		samplePacketsWithNonNullInternalStandardAmountForNoneInternalStandard,
		samplePacketsWithNonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSample,
		samplePacketsWithMissingInternalStandardAmountForAfterAdditionOrder,
		samplePacketsWithMissingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSample,
		samplePacketsWithInternalStandardAmountMismatchInternalStandardTargetConcentration,

		(* -- PretreatElectrodes options -- *)
		(* Errors *)
		samplePacketsWithNonNullPretreatmentSparging,
		samplePacketsWithMissingPretreatmentSparging,
		samplePacketsWithNonNullPretreatmentSpargingPreBubbler,
		samplePacketsWithMissingPretreatmentSpargingPreBubbler,
		samplePacketsWithPretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSparging,
		samplePacketsWithNonNullPretreatmentInitialPotential,
		samplePacketsWithMissingPretreatmentInitialPotential,
		samplePacketsWithNonNullPretreatmentFirstPotential,
		samplePacketsWithMissingPretreatmentFirstPotential,
		samplePacketsWithNonNullPretreatmentSecondPotential,
		samplePacketsWithMissingPretreatmentSecondPotential,
		samplePacketsWithNonNullPretreatmentFinalPotential,
		samplePacketsWithMissingPretreatmentFinalPotential,
		samplePacketsWithPretreatmentInitialPotentialNotBetweenFirstAndSecondPotentials,
		samplePacketsWithPretreatmentFinalPotentialNotBetweenFirstAndSecondPotentials,
		samplePacketsWithPretreatmentInitialAndFinalPotentialsTooDifferent,
		samplePacketsWithNonNullPretreatmentPotentialSweepRate,
		samplePacketsWithMissingPretreatmentPotentialSweepRate,
		samplePacketsWithNonNullPretreatmentNumberOfCycles,
		samplePacketsWithMissingPretreatmentNumberOfCycles,

		(* -- Mix options -- *)
		(* Errors *)
		samplePacketsWithLoadingSampleMixFalseForUnpreparedSample,
		samplePacketsWithNonNullLoadingSampleMixType,
		samplePacketsWithMissingLoadingSampleMixType,
		samplePacketsWithNonNullLoadingSampleMixTemperature,
		samplePacketsWithMissingLoadingSampleMixTemperature,
		samplePacketsWithLoadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixType,
		samplePacketsWithNonNullLoadingSampleMixUntilDissolved,
		samplePacketsWithMissingLoadingSampleMixUntilDissolved,
		samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixing,
		samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolved,
		samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesForShakeMixType,
		samplePacketsWithMissingLoadingSampleMaxNumberOfMixes,
		samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixing,
		samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolved,
		samplePacketsWithNonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixType,
		samplePacketsWithMissingLoadingSampleMaxMixTime,
		samplePacketsWithNonNullLoadingSampleMixTimeWhenNotMixing,
		samplePacketsWithNonNullLoadingSampleMixTimeForPipetteOrInvertMixType,
		samplePacketsWithMissingLoadingSampleMixTime,
		samplePacketsWithLoadingSampleMixTimeGreaterThanMaxMixTime,
		samplePacketsWithNonNullLoadingSampleNumberOfMixesWhenNotMixing,
		samplePacketsWithNonNullLoadingSampleNumberOfMixesForShakeMixType,
		samplePacketsWithMissingLoadingSampleNumberOfMixes,
		samplePacketsWithLoadingSampleNumberOfMixesGreaterThanMaxNumberOfMixes,
		samplePacketsWithNonNullLoadingSampleMixVolumeWhenNotMixing,
		samplePacketsWithNonNullLoadingSampleMixVolumeForNonPipetteMixType,
		samplePacketsWithMissingLoadingSampleMixVolume,
		samplePacketsWithLoadingSampleMixVolumeGreaterThanSolventVolume,

		(* -- Sparging options -- *)
		(* Errors *)
		samplePacketsWithNonNullSpargingGas,
		samplePacketsWithMissingSpargingGas,
		samplePacketsWithNonNullSpargingTime,
		samplePacketsWithMissingSpargingTime,
		samplePacketsWithTooLongSpargingTime,
		samplePacketsWithNonNullSpargingPreBubbler,
		samplePacketsWithMissingSpargingPreBubbler,

		(* -- Cyclic Voltammetry measurement options -- *)
		(* Errors *)
		samplePacketsWithInitialPotentialsLengthMismatchNumberOfCycles,
		samplePacketsWithFirstPotentialsLengthMismatchNumberOfCycles,
		samplePacketsWithSecondPotentialsLengthMismatchNumberOfCycles,
		samplePacketsWithFinalPotentialsLengthMismatchNumberOfCycles,
		samplePacketsWithPotentialSweepRatesLengthMismatchNumberOfCycles,
		samplePacketsWithInitialPotentialNotBetweenFirstAndSecondPotentials,
		samplePacketsWithFinalPotentialNotBetweenFirstAndSecondPotentials,
		samplePacketsWithInitialAndFinalPotentialsTooDifferent,

		(* ====== InvalidOption and Further InvalidInputs Tracking ====== *)
		(* working electrode polishing options *)
		coatedWorkingElectrodeInvalidOptions, nonNullPolishingParametersInvalidOptions, missingPolishingParametersInvalidOptions, mismatchingLengthPolishingParametersInvalidOptions, nonPolishingSolutionsInvalidOptions,

		(* working electrode sonication options *)
		sonicationSensitiveWorkingElectrodeInvalidOptions, nonNullSonicationParametersInvalidOptions, missingSonicationParametersInvalidOptions,

		(* electrode washing options *)
		nonNullWorkingElectrodeWashingCyclesInvalidOptions, missingWorkingElectrodeWashingCyclesInvalidOptions,

		(* loading sample volume options *)
		mismatchingSampleStateInvalidOptions, mismatchingReactionVesselWithElectrodeCapInvalidOptions, solventVolumeInvalidOptions, loadingSampleVolumeInvalidOptions,

		(* analyte related options *)
		analyteInvalidOptions, sampleAmountInvalidOptions, loadingSampleTargetConcentrationInvalidOptions,

		missingCompositionInvalidInputs, missingAnalyteInvalidInputs, IncompleteCompositionInvalidInputs, ambiguousAnalyteInvalidInputs, unresolvableCompositionUnitInvalidInputs,

		(* solvent and electrolyte *)
		solventInvalidOptions, electrolyteInvalidOptions, electrolyteSolutionInvalidOptions, electrolyteSolutionLoadingVolumeInvalidOptions, loadingSampleElectrolyteAmountInvalidOptions, electrolyteTargetConcentrationInvalidOptions,

		preparedSampleMissingSolventInvalidInputs,
		preparedSampleSolventAmbiguousMoleculeInvalidInputs,
		preparedSampleElectrolyteMoleculeWithUnresolvableCompositionUnitInvalidInputs,
		preparedSampleElectrolyteMoleculeMissingMolecularWeightInvalidInputs,
		preparedSampleElectrolyteMoleculeMissingDefaultModelSampleInvalidInputs,
		preparedSampleElectrolyteMoleculeNotFoundInvalidInputs,
		preparedSampleAmbiguousElectrolyteMoleculeInvalidInputs,

		(* reference electrode and reference solution options *)
		refreshReferenceElectrodeInvalidOptions, referenceElectrodeInvalidOptions, referenceElectrodeSoakTimeInvalidOptions,

		(* internal standard options *)
		internalStandardInvalidOptions, internalStandardAdditionOrderInvalidOptions, internalStandardAmountInvalidOptions, internalStandardTargetConcentrationInvalidOptions,

		preparedSampleInvalidCompositionLengthForNoneInternalStandardInvalidInputs,
		preparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrderInvalidInputs,
		preparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrderInvalidInputs,

		(* pretreat electrode options *)
		pretreatmentSparingInvalidOptions, pretreatmentSpargingPreBubblerInvalidOptions, pretreatmentInitialPotentialInvalidOptions, pretreatmentFirstPotentialInvalidOptions, pretreatmentSecondPotentialInvalidOptions, pretreatmentFinalPotentialInvalidOptions, pretreatmentPotentialSweepRateInvalidOptions, pretreatmentNumberOfCyclesInvalidOptions,

		(* mix options *)
		loadingSampleMixInvalidOptions, loadingSampleMixTypeInvalidOptions, loadingSampleMixTemperatureInvalidOptions, loadingSampleMixTimeInvalidOptions, loadingSampleNumberOfMixesInvalidOptions, loadingSampleMixVolumeInvalidOptions, loadingSampleMixUntilDissolvedInvalidOptions, loadingSampleMaxNumberOfMixesInvalidOptions, loadingSampleMaxMixTimeInvalidOptions,

		(* sparging options *)
		spargingGasInvalidOptions, spargingTimeInvalidOptions, spargingPreBubblerInvalidOptions,

		(* cv measurement options *)
		initialPotentialsInvalidOptions, firstPotentialsInvalidOptions, secondPotentialsInvalidOptions, finalPotentialsInvalidOptions, potentialSweepRatesInvalidOptions,

		(* ====== Tests ====== *)
		(* working electrode polishing options *)
		polishingParametersGroupedErrorTests, nonDefaultPolishingSolutionsWarningTests,

		(* working electrode sonication options *)
		sonicationParametersGroupedErrorTests,

		(* electrode washing options *)
		electrodeWashingGroupedErrorTests,

		(* loading sample volume options *)
		loadingSampleVolumesGroupedErrorTests, solventVolumeLargerThanLoadingSampleVolumeTests,

		(* analyte related options *)
		analyteOptionsGroupedErrorTests,

		(* solvent and electrolyte *)
		solventAndElectrolyteTestsGroup1, solventAndElectrolyteTestsGroup2, solventAndElectrolyteTestsGroup3,
		solventAndElectrolyteOptionsGroupedErrorTests, solventAndElectrolyteOptionsGroupedWarningTests,

		(* reference electrode and reference solution options *)
		referenceElectrodeGroupedErrorTests, referenceElectrodeGroupedWarningTests,

		(* internal standard options *)
		internalStandardGroupedErrorTests,

		(* pretreat electrode options *)
		pretreatElectrodesGroupedErrorTests,

		(* loading sample mix options *)
		loadingSampleMixGroupedErrorTests,

		(* sparging options *)
		spargingGroupedErrorTests,

		(* cv measurement options *)
		cyclicVoltammetryMeasurementGroupedErrorTests,

		(* ====== aliquot resolution variables ====== *)
		requiredVolumes, hamiltonCompatibleContainers, simulatedSampleContainers, sampleContainerPackets, sampleContainerFields,
		sampleVolumes,sampleMasses,tabletBools, bestAliquotAmount, liquidHandlerContainerModels,liquidHandlerContainerMaxVolumes,
		potentialAliquotContainers, simulatedSamplesContainerModels, requiredAliquotContainers,

		resolvedSampleLabel, resolvedSampleContainerLabel
	},

	(* ---------------------------------------------- *)
	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* ---------------------------------------------- *)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = !gatherTests;

	(* Fetch our cache from the parent function. *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation];

	(* Separate out our Cyclic Voltammetry options from our Sample Prep options. *)
	{samplePrepOptions, cyclicVoltammetryOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentCyclicVoltammetry,mySamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentCyclicVoltammetry,mySamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	cyclicVoltammetryOptionsAssociation = Association[cyclicVoltammetryOptions];

	(* Extract the packets that we need from our downloaded cache. *)
	(* we don't know what solutions will be needed yet, is there any way to prevent two download calls here? *)

	(* Remember to download from simulatedSamples *)
	sampleObjectPrepFields = Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence], IncompatibleMaterials, RequestedResources, State, Volume, Tablet];
	sampleModelPrepFields = Packet[Model[Flatten[{SamplePreparationCacheFields[Object[Sample], Format -> Sequence], State,Products, IncompatibleMaterials, RequestedResources, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, Deprecated, Tablet}]]];
	sampleContainerFields = Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], Model}]]];

	(* grab all of the instances of objects in the options and make packets for them - make sure to exclude the cache and also any models/objects found in the input *)
	allSampleObjectOptions = DeleteCases[DeleteDuplicates[Download[Cases[KeyDrop[cyclicVoltammetryOptionsAssociation, {Cache, Simulation}], ObjectP[Object[Sample]], Infinity], Object]],Alternatives@@ToList[simulatedSamples]];
	allSampleModelOptions =  DeleteDuplicates[Download[Cases[KeyDrop[cyclicVoltammetryOptionsAssociation, {Cache, Simulation}], ObjectP[Model[Sample]], Infinity],Object]];

	(* gather a list of potential aliquot containers *)
	liquidHandlerContainers = hamiltonAliquotContainers["Memoization"];

	(* also grab the fields that we will need to check *)
	allSampleObjectFields = Packet[Object, Name, State, Container, Composition, IncompatibleMaterials];
	allSampleModelFields = Packet[Object, Name, State, IncompatibleMaterials];
	modelContainerPacketFields=Packet@@Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];

	{allDownloadValues, allSampleObjectPackets, allSampleModelPackets, liquidHandlerContainerPackets} = Quiet[Download[
		{
			simulatedSamples,
			allSampleObjectOptions,
			allSampleModelOptions,
			liquidHandlerContainers
		},
		{
			{
				sampleObjectPrepFields,
				sampleModelPrepFields,
				sampleContainerFields
			},
			{
				allSampleObjectFields
			},
			{
				allSampleModelFields
			},
			{
				modelContainerPacketFields
			}
		},
		Cache -> inheritedCache,
		Simulation -> updatedSimulation
	], Download::FieldDoesntExist];

	(* split out the sample and model packets *)
	samplePackets = allDownloadValues[[All, 1]];
	sampleModelPackets = allDownloadValues[[All, 2]];
	sampleContainerPackets = allDownloadValues[[All, 3]];

	(* update cache to include the downloaded sample information and the inherited stuff *)
	newCache = Cases[FlattenCachePackets[{allDownloadValues, allSampleObjectPackets, allSampleModelPackets, liquidHandlerContainerPackets,inheritedCache, Lookup[updatedSimulation[[1]], Packets]}], PacketP[]];

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(* -------------- *)
	(* -- ROUNDING -- *)
	(* -------------- *)

	(* gather options and their precisions *)
	generalOptionPrecisions={
		(* Volumes *)
		{LoadingSampleVolume,10^0 Milliliter},
		{ElectrolyteSolutionLoadingVolume,10^0 Milliliter},
		{SolventVolume,10^0 Milliliter},
		{LoadingSampleMixVolume,10^0 Milliliter},

		(* Times *)
		{WorkingElectrodeSonicationTime, 10^0 Second},
		{ReferenceElectrodeSoakTime, 10^0 Second},
		{LoadingSampleMixTime, 10^0 Second},
		{LoadingSampleMaxMixTime, 10^0 Second},
		{SpargingTime, 10^0 Second},

		(* Solid Amounts *)
		{LoadingSampleElectrolyteAmount, 10^-1 Milligram},
		{InternalStandardAmount, 10^-1 Milligram},
		{SampleAmount, 10^-1 Milligram},

		(* Temperatures *)
		{WorkingElectrodeSonicationTemperature, 10^0 Celsius},
		{LoadingSampleMixTemperature, 10^0 Celsius},

		(* PretreatmentPotentials *)
		{PretreatmentInitialPotential, 10^0 Millivolt},
		{PretreatmentFirstPotential, 10^0 Millivolt},
		{PretreatmentSecondPotential, 10^0 Millivolt},
		{PretreatmentFinalPotential, 10^0 Millivolt},

		(* PretreatmentSweepRate *)
		{PretreatmentPotentialSweepRate, 10^1 Millivolt/Second}
	};

	(* big round call on the joined lists of all roundable options *)
	{
		roundedGeneralOptions,
		generalPrecisionTests
	} = If[gatherTests,
		RoundOptionPrecision[cyclicVoltammetryOptionsAssociation, generalOptionPrecisions[[All,1]], generalOptionPrecisions[[All,2]], Output -> {Result, Tests}, Round -> Up],
		{
			RoundOptionPrecision[cyclicVoltammetryOptionsAssociation,  generalOptionPrecisions[[All,1]], generalOptionPrecisions[[All,2]], Round -> Up],
			{}
		}
	];

	(* Round other options *)
	concentrationOptions = {ElectrolyteTargetConcentration, LoadingSampleTargetConcentration, InternalStandardTargetConcentration};
	concentrationMolarPrecisions = {10^-1 Millimolar, 10^-1 Millimolar, 10^-1 Millimolar};
	concentrationMassVolumePrecisions = {10^-1 Microgram/Liter, 10^-1 Microgram/Liter, 10^-1 Microgram/Liter};

	potentialOptions = {InitialPotentials, FirstPotentials, SecondPotentials, FinalPotentials};
	potentialPrecisions = {10^0 Millivolt, 10^0 Millivolt, 10^0 Millivolt, 10^0 Millivolt};

	(* Round concentration options *)
	{
		{roundedElectrolyteTargetConcentration, roundedElectrolyteTargetConcentrationTest},
		{roundedLoadingSampleTargetConcentration, roundedLoadingSampleTargetConcentrationTest},
		{roundedInternalStandardTargetConcentration, roundedInternalStandardTargetConcentrationTest}

	} = MapThread[
		Function[{concentrationOptionName, molarPrecision, massVolumePrecision},
			Module[{concentrationIn, concentrationInPreferredUnit, roundedConcentration, roundedTest},
				concentrationIn = Lookup[cyclicVoltammetryOptions, concentrationOptionName];
				concentrationInPreferredUnit = (concentrationIn /. {x_?ConcentrationQ :> N@UnitConvert[x, 1 Millimolar]}) /. {x_?MassConcentrationQ :> N@UnitConvert[x, 1 Microgram/Liter]};
				roundedConcentration = (concentrationInPreferredUnit /. {x_?ConcentrationQ :> N@SafeRound[x, molarPrecision]}) /. {x_?MassConcentrationQ :> N@SafeRound[x, massVolumePrecision]};

				(* warn the user if the PotentialSweepRate are rounded *)
				If[messages&&Not[MatchQ[$ECLApplication, Engine]]&&!MatchQ[concentrationIn, {Automatic..}]&&!MatchQ[concentrationInPreferredUnit, roundedConcentration],
					Message[Warning::TargetConcentrationPrecision, ToString[concentrationOptionName], ObjectToString[concentrationInPreferredUnit,Cache->newCache], ObjectToString[roundedConcentration,Cache->newCache]],
					Nothing
				];

				(* Define the tests the user will see for the above message *)
				roundedTest = If[gatherTests&&MatchQ[Lookup[cyclicVoltammetryOptions, concentrationOptionName], Except[Null]],
					Module[{failingTest,passingTest},
						failingTest=If[MatchQ[concentrationInPreferredUnit, roundedConcentration],
							{},
							Warning["At least one member of " <> ToString[concentrationOptionName] <> " have been specified at a higher precision than the experiment specifications:",False,True]
						];
						passingTest=If[MatchQ[concentrationInPreferredUnit, roundedConcentration],
							Warning["All members of " <> ToString[concentrationOptionName] <> " have been specified at a precision appropriate for the experiment :",True,True],
							{}
						];
						{failingTest,passingTest}
					],
					{}
				];

				{roundedConcentration, roundedTest}
			]
		],
		{concentrationOptions, concentrationMolarPrecisions, concentrationMassVolumePrecisions}
	];

	(* Round cyclic voltammetry measurement potentials *)
	{
		{roundedInitialPotentials, roundedInitialPotentialsTest},
		{roundedFirstPotentials, roundedFirstPotentialsTest},
		{roundedSecondPotentials, roundedSecondPotentialsTest},
		{roundedFinalPotentials, roundedFinalPotentialsTest}
	} = MapThread[
		Function[{potential, precision},
			Module[{potentialInMillivolt, roundedPotential, roundedTest},
				potentialInMillivolt = Lookup[cyclicVoltammetryOptions, potential]/.{x_?QuantityQ:>UnitConvert[x, Millivolt]};
				roundedPotential = potentialInMillivolt/.{x_?QuantityQ:>N@SafeRound[x, precision]};

				(* warn the user if the PotentialSweepRate are rounded *)
				If[messages&&Not[MatchQ[$ECLApplication, Engine]]&&!MatchQ[potentialInMillivolt,roundedPotential],
					Message[Warning::PotentialsPrecision, ToString[potential], ObjectToString[potentialInMillivolt,Cache->newCache], ObjectToString[roundedPotential,Cache->newCache]],
					Nothing
				];

				(* Define the tests the user will see for the above message *)
				roundedTest = If[gatherTests&&MatchQ[Lookup[cyclicVoltammetryOptions, potential], Except[Null]],
					Module[{failingTest,passingTest},
						failingTest=If[MatchQ[potentialInMillivolt, roundedPotential],
							{},
							Warning["At least one member of " <> ToString[potential] <> " have been specified at a higher precision than can be executed by the instrument:",False,True]
						];
						passingTest=If[MatchQ[potentialInMillivolt, roundedPotential],
							Warning["All members of " <> ToString[potential] <> " have been specified at a precision appropriate for the instrument :",True,True],
							{}
						];
						{failingTest,passingTest}
					],
					{}
				];

				{roundedPotential, roundedTest}
			]
		],
		{potentialOptions, potentialPrecisions}
	];

	(* Round cyclic voltammetry measurement PotentialSweepRates *)
	potentialSweepRatesInMillivoltSecond = Lookup[cyclicVoltammetryOptions, PotentialSweepRates]/.{x_?QuantityQ:>UnitConvert[x, Millivolt/Second]};
	roundedPotentialSweepRates = potentialSweepRatesInMillivoltSecond/.{x_?QuantityQ:>SafeRound[x, 10 Millivolt/Second]};

	(* warn the user if the PotentialSweepRate are rounded *)
	If[messages&&Not[MatchQ[$ECLApplication, Engine]]&&!MatchQ[potentialSweepRatesInMillivoltSecond, roundedPotentialSweepRates],
		Message[Warning::PotentialSweepRatePrecision, ObjectToString[potentialSweepRatesInMillivoltSecond,Cache->newCache], ObjectToString[roundedPotentialSweepRates,Cache->newCache]],
		Nothing
	];

	(* Define the tests the user will see for the above message *)
	roundedPotentialSweepRateTest=If[gatherTests&&MatchQ[Lookup[cyclicVoltammetryOptions, PotentialSweepRates], Except[Null]],
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[potentialSweepRatesInMillivoltSecond, roundedPotentialSweepRates],
				Nothing,
				Warning["At least one member of PotentialSweepRate have been specified at a higher precision than can be executed by the instrument:",False,True]
			];
			passingTest=If[MatchQ[potentialSweepRatesInMillivoltSecond, roundedPotentialSweepRates],
				Warning["All members of PotentialSweepRate have been specified at a precision appropriate for the instrument :",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];


	(* replace the options with their rounded values *)

	roundedOptions = Join[KeyDrop[roundedGeneralOptions,
		{
			ElectrolyteTargetConcentration,
			LoadingSampleTargetConcentration,
			InternalStandardTargetConcentration,
			InitialPotentials,
			FirstPotentials,
			SecondPotentials,
			FinalPotentials,
			PotentialSweepRates
		}],
		<|
			ElectrolyteTargetConcentration -> roundedElectrolyteTargetConcentration,
			LoadingSampleTargetConcentration -> roundedLoadingSampleTargetConcentration,
			InternalStandardTargetConcentration -> roundedInternalStandardTargetConcentration,
			InitialPotentials -> roundedInitialPotentials,
			FirstPotentials -> roundedFirstPotentials,
			SecondPotentials -> roundedSecondPotentials,
			FinalPotentials -> roundedFinalPotentials,
			PotentialSweepRates -> roundedPotentialSweepRates
		|>
	];

	(* ------------------------------- *)
	(* -- LOOK UP THE OPTION VALUES -- *)
	(* ------------------------------- *)

	(* look up the non index matched options *)
	{
		instrument,
		samplesInStorageCondition
	} = Lookup[roundedOptions,
		{
			Instrument,
			SamplesInStorageCondition
		}
	];

	(* --------------------------- *)
	(*-- INPUT VALIDATION CHECKS --*)
	(* --------------------------- *)


	(* -- Compatible Materials Check -- *)

	(* get the boolean for any incompatible materials *)
	{compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
		CompatibleMaterialsQ[instrument, simulatedSamples, Cache -> newCache, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		{CompatibleMaterialsQ[instrument, simulatedSamples, Cache -> newCache, Simulation -> updatedSimulation, Messages -> messages], {}}
	];

	(* If the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidInputs = If[Not[compatibleMaterialsBool] && messages,
		Download[mySamples, Object],
		{}
	];

	(* -- Discarded Samples check -- *)

	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs,Cache->newCache]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[Length[discardedInvalidInputs],0],
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->newCache]<>" are not discarded:",False,True]
			];

			passingTest=If[MatchQ[Length[discardedInvalidInputs], Length[mySamples]],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Cache->newCache]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- Check if the input samples have Deprecated inputs --- *)

	(* get all the model packets together that are going to be checked for whether they are deprecated *)
	(* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
	modelPacketsToCheckIfDeprecated = Cases[sampleModelPackets, PacketP[Model[Sample]]];

	(* get the samples that are deprecated; if on the FastTrack, don't bother checking *)
	deprecatedModelPackets = Select[modelPacketsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&];

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	deprecatedInvalidInputs = If[MatchQ[deprecatedModelPackets, {PacketP[]..}] && messages,
		(
			Message[Error::DeprecatedModels, Lookup[deprecatedModelPackets, Object, {}]];
			Lookup[deprecatedModelPackets, Object, {}]
		),
		Lookup[deprecatedModelPackets, Object, {}]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["Provided samples have models " <> ObjectToString[deprecatedInvalidInputs, Cache -> newCache] <> " that are deprecated:", False, True]
			];

			passingTest = If[Length[deprecatedInvalidInputs] == Length[modelPacketsToCheckIfDeprecated],
				Nothing,
				Test["Provided samples have models " <> ObjectToString[Download[Complement[modelPacketsToCheckIfDeprecated, deprecatedInvalidInputs], Object], Cache -> newCache] <> " that are not deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* -- SAMPLES IN STORAGE CONDITION -- *)

	(* determine if incompatible storage conditions have been specified for samples in the same container *)
	(* this will throw warnings if needed *)
	{validSamplesInStorageConditionBools, validSamplesInStorageConditionTests} = Quiet[
		If[gatherTests,
			ValidContainerStorageConditionQ[simulatedSamples, samplesInStorageCondition, Output -> {Result, Tests}, Cache ->newCache],
			{ValidContainerStorageConditionQ[simulatedSamples, samplesInStorageCondition, Output -> Result, Cache ->newCache], {}}
		],
		Download::MissingCacheField
	];

	(* convert to a single boolean *)
	validSamplesInStorageBool = And@@ToList[validSamplesInStorageConditionBools];

	(* collect the bad option to add to invalid options later *)
	invalidSamplesInStorageConditionOption = If[MatchQ[validSamplesInStorageBool, False],
		{SamplesInStorageCondition},
		{}
	];

	(* -- Too many input samples check -- *)
	numberOfInputSamples = Length[simulatedSamples];
	maxNumberOfSamples = 5;

	(* tooManyInputSamplesInvalidInputs -> simulatedSamples beyond maxNumberOfSamples  *)
	tooManyInputSamplesInvalidInputs = If[numberOfInputSamples > maxNumberOfSamples,
		Take[simulatedSamples, -(numberOfInputSamples - maxNumberOfSamples)],
		{}
	];

	(* Throw the error *)
	If[Length[tooManyInputSamplesInvalidInputs] > 0 && messages,
		Message[Error::TooManyInputSamples, ToString[numberOfInputSamples], ToString[maxNumberOfSamples]]
	];

	(* Set up the test *)
	tooManyInputSamplesTest = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[tooManyInputSamplesInvalidInputs] == 0,
				Nothing,
				Test["The number of input samples is " <> ToString[numberOfInputSamples] <> ", which is greater than the supported max input sample number " <> ToString[maxNumberOfSamples] <> ".", False, True]
			];
			passingTest=If[Length[tooManyInputSamplesInvalidInputs] == 0,
				Test["The number of input samples is " <> ToString[numberOfInputSamples] <> ", which is no more than the supported max input sample number " <> ToString[maxNumberOfSamples] <> ".",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Too large NumberOfReplicates check -- *)
	numberOfReplicates = Lookup[roundedOptions, NumberOfReplicates];
	maxNumberOfReplicates = 3;

	tooLargerNumberOfReplicatesInvalidOptions = If[numberOfReplicates > maxNumberOfReplicates,
		{NumberOfReplicates},
		{}
	];

	(* Throw the error *)
	If[numberOfReplicates > maxNumberOfReplicates && messages,
		Message[Error::TooLargeNumberOfReplicates, ToString[numberOfReplicates], ToString[maxNumberOfReplicates]]
	];

	(* Set up the test *)
	tooLargeNumberOfReplicatesTests = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[GreaterQ[numberOfReplicates, maxNumberOfReplicates],
				Test["The NumberOfReplicates is " <> ToString[numberOfReplicates] <> ", which is greater than the supported max NumberOfReplicates value " <> ToString[maxNumberOfReplicates] <> ".", False, True],
				Nothing
			];
			passingTest=If[LessEqualQ[numberOfReplicates, maxNumberOfReplicates],
				Test["The NumberOfReplicates is " <> ToString[numberOfReplicates] <> ", which is no more than the supported max NumberOfReplicates value " <> ToString[maxNumberOfReplicates] <> ".",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- electrode model deprecated check -- *)
	(* If a model is given, the model is not deprecated. *)
	electrodeModelsToCheckIfDeprecated = Cases[newCache, PacketP[Model[Item, Electrode]]];
	referenceElectrodeModelsToCheckIfDeprecated = Cases[electrodeModelsToCheckIfDeprecated, PacketP[Model[Item, Electrode, ReferenceElectrode]]];

	(* get the working electrode models *)
	workingElectrodeModelsToCheckIfDeprecated = Cases[fetchPacketFromCache[#, newCache]&/@Lookup[roundedOptions, Flatten[{WorkingElectrode}]], PacketP[Model[Item, Electrode]]];

	(* get the counter electrode models *)
	counterElectrodeModelsToCheckIfDeprecated = Cases[fetchPacketFromCache[#, newCache]&/@Lookup[roundedOptions, Flatten[{CounterElectrode}]], PacketP[Model[Item, Electrode]]];

	(* Working Electrode check *)
	deprecatedWorkingElectrodeModelPackets = Select[workingElectrodeModelsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&];
	deprecatedWorkingElectrodeModels = Flatten[Lookup[deprecatedWorkingElectrodeModelPackets, Object, {}]];

	(* If the WorkingElectrode model is deprecated and we are throwing messages, throw an error message and keep track of the invalid option.*)
	deprecatedWorkingElectrodeModelInvalidOption = If[Length[deprecatedWorkingElectrodeModels] > 0 && messages,
		(
			Message[Error::DeprecatedElectrodeModel, "WorkingElectrode", ObjectToString[deprecatedWorkingElectrodeModels,Cache->newCache]];
			{WorkingElectrode}
		),
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test for the deprecated WorkingElectrode model. *)
	deprecatedWorkingElectrodeModelTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedWorkingElectrodeModels] == 0,
				Nothing,
				Test["The provided WorkingElectrode model " <> ObjectToString[deprecatedWorkingElectrodeModels,Cache->newCache] <> " is deprecated:", False, True]
			];

			passingTest = If[Length[deprecatedWorkingElectrodeModels] == 0,
				Test["The provided WorkingElectrode model " <> ObjectToString[Complement[workingElectrodeModelsToCheckIfDeprecated, deprecatedWorkingElectrodeModels],Cache->newCache] <> " is not deprecated:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* -- CounterElectrode check -- *)
	deprecatedCounterElectrodeModelPackets = Select[counterElectrodeModelsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&];
	deprecatedCounterElectrodeModels = Flatten[Lookup[deprecatedCounterElectrodeModelPackets, Object, {}]];

	(* If the CounterElectrode model is deprecated and we are throwing messages, throw an error message and keep track of the invalid option.*)
	deprecatedCounterElectrodeModelInvalidOption = If[Length[deprecatedCounterElectrodeModels] > 0 && messages,
		(
			Message[Error::DeprecatedElectrodeModel, "CounterElectrode", ObjectToString[deprecatedCounterElectrodeModels,Cache->newCache]];
			{CounterElectrode}
		),
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test for the deprecated CounterElectrode model. *)
	deprecatedCounterElectrodeModelTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedCounterElectrodeModels] == 0,
				Nothing,
				Test["The provided CounterElectrode model " <> ObjectToString[deprecatedCounterElectrodeModels,Cache->newCache] <> " is deprecated:", False, True]
			];

			passingTest = If[Length[deprecatedCounterElectrodeModels] == 0,
				Test["The provided CounterElectrode model " <> ObjectToString[Complement[counterElectrodeModelsToCheckIfDeprecated, deprecatedCounterElectrodeModels],Cache->newCache] <> " is not deprecated:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* ReferenceElectrode check *)
	deprecatedReferenceElectrodeModelPackets = Select[referenceElectrodeModelsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&];
	deprecatedReferenceElectrodeModels = Flatten[Lookup[deprecatedReferenceElectrodeModelPackets, Object, {}]];

	(* If the ReferenceElectrode model is deprecated and we are throwing messages, throw an error message and keep track of the invalid option.*)
	deprecatedReferenceElectrodeModelInvalidOption = If[Length[deprecatedReferenceElectrodeModels] > 0 && messages,
		(
			Message[Error::DeprecatedElectrodeModel, "ReferenceElectrode", ObjectToString[deprecatedReferenceElectrodeModels,Cache->newCache]];
			{ReferenceElectrode}
		),
		{}
	];

	(* If we are gathering tests, create a passing and/or failing test for the deprecated ReferenceElectrode model. *)
	deprecatedReferenceElectrodeModelTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedReferenceElectrodeModels] == 0,
				Nothing,
				Test["The provided ReferenceElectrode model(s) " <> ObjectToString[deprecatedReferenceElectrodeModels,Cache->newCache] <> " is/are deprecated:", False, True]
			];

			passingTest = If[Length[deprecatedReferenceElectrodeModels] == 0,
				Test["The provided ReferenceElectrode model(s) " <> ObjectToString[Complement[referenceElectrodeModelsToCheckIfDeprecated, deprecatedReferenceElectrodeModelPackets],Cache->newCache] <> " is/are not deprecated:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* -- Set up some global variables for the MapThread -- *)

	(* set up legit polishing solution models *)
	legitPolishingSolutionModels = {
		Model[Sample, "id:1ZA60vLZ9DNw"],
		Model[Sample, "id:Z1lqpMz1nKA9"],
		Model[Sample, "id:eGakldJGRVjG"],
		Model[Sample, "id:AEqRl9KEopkw"]
	};

	(* =============== *)
	(* == MAPTHREAD == *)
	(* =============== *)

	(*MapThreadFriendlyOptions have the Key value pairs expanded to index match, such that if you call Lookup[options, OptionName], it gives the Option value at the index we are interested in*)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentCyclicVoltammetry, roundedOptions];

	(* since this is a fairly heavy map thread, the output will be an association of the form <|OptionName -> resolvedOptionValue|> so that it is easy to look up at the end *)
	(* the error trackers will come out the same way as <|<ErrorTrackerName> -> <tracker value>|> *)
	{mapThreadResolvedOptionAssociations, mapThreadErrorTrackingAssociations, mapThreadWarningTrackingAssociations} = Transpose[
		MapThread[
			Function[{unresolvedOptions, sample},
				Module[{

					(* -- option resolution variables -- *)
					(* working and counter electrodes *)
					workingElectrode, counterElectrode,

					(* working electrode polishing *)
					polishWorkingElectrode, polishingPads, polishingSolutions, numberOfPolishingDroplets, numberOfPolishings,
					resolvedPolishingPads, defaultPolishingSolutions, resolvedPolishingSolutions, resolvedNumberOfPolishingDroplets, resolvedNumberOfPolishings,

					(* working electrode sonication *)
					workingElectrodeSonication, workingElectrodeSonicationTime, workingElectrodeSonicationTemperature, resolvedWorkingElectrodeSonicationTime, resolvedWorkingElectrodeSonicationTemperature,

					(* electrode washing *)
					workingElectrodeWashing, workingElectrodeWashingCycles, resolvedWorkingElectrodeWashingCycles, counterElectrodeWashing,

					(* loading sample solution volumes *)
					preparedSample, resolvedPreparedSample, sampleState, reactionVessel, electrodeCap, reactionVesselConnectors, electrodeCapConnectors, reactionVesselCapPort, reactionVesselCapPortOuterDiameter, capReactionVesselPort, capReactionVesselPortInnerDiameter, reactionVesselMaxVolume, loadingSampleVolume, resolvedLoadingSampleVolume, solventVolume, resolvedSolventVolume,

					(* analyte options *)
					analyte, resolvedAnalyte, sampleAmount, resolvedSampleAmount, targetConcentration, resolvedTargetConcentration, sampleComposition, sampleAnalytes, sampleAnalyteLinks, sampleCompositionMolecules,

					(* solvent, electrolyte, and electrolyte solution *)
					solvent, electrolyte, pretreatElectrodes, electrolyteSolution, electrolyteSolutionLoadingVolume, loadingSampleElectrolyteAmount, electrolyteTargetConcentration,

					resolvedSolvent, resolvedElectrolyte, electrolyteMolecule,resolvedElectrolyteMolecule, resolvedElectrolyteMoleculeMolecularWeight, resolvedElectrolyteSolution, resolvedElectrolyteSolutionLoadingVolume, resolvedLoadingSampleElectrolyteAmount, resolvedElectrolyteTargetConcentration, resolvedElectrolyteTargetConcentrationInMillimolar,

					sampleSolvent, sampleSolventModelSample, sampleSolventMolecule, electrolyteSolutionSolventLink, electrolyteSolutionSolventSampleModel, electrolyteSolutionSolventMolecule, solventMolecule, resolvedSolventMolecule,

					electrolyteSolutionState, electrolyteSolutionComposition, electrolyteSolutionAnalyteLink, electrolyteSolutionSolvent, electrolyteSolutionAnalyteList, electrolyteSolutionElectrolyteMolecule, electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar, electrolyteSolutionElectrolyteMoleculeConcentrationInMilligramPerMilliliter, electrolyteSolutionElectrolyteMoleculeModelSample, sampleElectrolyteMoleculeModelSample, sampleElectrolyteMolecule, sampleElectrolyteMoleculeConcentrationInMillimolar, sampleElectrolyteMoleculeConcentrationInMilligramPerMilliliter,

					(* reference electrode and reference solution *)
					referenceElectrode, resolvedReferenceElectrode, refreshReferenceElectrode, referenceElectrodeSoakTime,

					(* internal standard options *)
					internalStandard, resolvedInternalStandard, resolvedInternalStandardMolecule, resolvedInternalStandardMoleculeMolecularWeight, internalStandardAdditionOrder, resolvedInternalStandardAdditionOrder, internalStandardAmount, resolvedInternalStandardAmount, internalStandardTargetConcentration, resolvedInternalStandardTargetConcentration, resolvedInternalStandardTargetConcentrationInMillimolar,

					(* pretreat electrodes *)
					pretreatmentSparging, resolvedPretreatmentSparging, pretreatmentSpargingPreBubbler, resolvedPretreatmentSpargingPreBubbler, pretreatmentInitialPotential, resolvedPretreatmentInitialPotential, pretreatmentFirstPotential, resolvedPretreatmentFirstPotential, pretreatmentSecondPotential, resolvedPretreatmentSecondPotential, pretreatmentFinalPotential, resolvedPretreatmentFinalPotential, pretreatmentPotentialSweepRate, resolvedPretreatmentPotentialSweepRate, pretreatmentNumberOfCycles, resolvedPretreatmentNumberOfCycles,

					(* mix options *)
					loadingSampleMix, resolvedLoadingSampleMix, loadingSampleMixType, resolvedLoadingSampleMixType, loadingSampleMixTemperature, resolvedLoadingSampleMixTemperature, loadingSampleMixTime, resolvedLoadingSampleMixTime, loadingSampleNumberOfMixes, resolvedLoadingSampleNumberOfMixes, loadingSampleMixVolume, resolvedLoadingSampleMixVolume, loadingSampleMixUntilDissolved, resolvedLoadingSampleMixUntilDissolved, loadingSampleMaxNumberOfMixes, resolvedLoadingSampleMaxNumberOfMixes, loadingSampleMaxMixTime, resolvedLoadingSampleMaxMixTime,

					(* sparging options *)
					sparging, spargingGas, resolvedSpargingGas, spargingTime, resolvedSpargingTime, spargingPreBubbler, resolvedSpargingPreBubbler,

					(* cv measurement options *)
					initialPotentials, firstPotentials, secondPotentials, finalPotentials, potentialSweepRates, numberOfCycles, resolvedInitialPotentials, resolvedFirstPotentials, resolvedSecondPotentials, resolvedFinalPotentials, resolvedPotentialSweepRates,

					(* -- gather option associations -- *)
					polishingOptionsAssociation, sonicationOptionsAssociation, electrodeWashingOptionsAssociation, loadingSampleVolumeOptionsAssociation, analyteOptionsAssociation, solventAndElectrolyteOptionsAssociation, referenceElectrodeOptionsAssociation, internalStandardOptionsAssociation, pretreatElectrodesOptionsAssociation, mixOptionsAssociation, spargingOptionsAssociation, cyclicVoltammetryMeasurementOptionsAssociation,

					(* -- gather error tracking associations -- *)
					polishingOptionsErrorTrackingAssociation, sonicationOptionsErrorTrackingAssociation, electrodeWashingOptionsErrorTrackingAssociation, loadingSampleVolumeOptionsErrorTrackingAssociation, analyteOptionsErrorTrackingAssociation, solventAndElectrolyteOptionsErrorTrackingAssociation, referenceElectrodeOptionsErrorTrackingAssociation, internalStandardOptionsErrorTrackingAssociation, pretreatElectrodesOptionsErrorTrackingAssociation, mixOptionsErrorTrackingAssociation, spargingOptionsErrorTrackingAssociation, cyclicVoltammetryMeasurementOptionsErrorTrackingAssociation,

					(* -- gather warning tracking associations -- *)
					polishingOptionsWarningTrackingAssociation, loadingSampleVolumeWarningTrackingAssociation, solventAndElectrolyteOptionsWarningTrackingAssociation, referenceElectrodeOptionsWarningTrackingAssociation,

					(* -- map thread output -- *)
					resolvedOptionsAssociation, errorTrackingAssociation, warningTrackingAssociation
				},


					(* -- look up the map thread options --  *)
					{
						workingElectrode,
						counterElectrode
					} = Lookup[unresolvedOptions,
						{
							WorkingElectrode,
							CounterElectrode
						}
					];
					{
						polishWorkingElectrode,
						polishingPads,
						polishingSolutions,
						numberOfPolishingDroplets,
						numberOfPolishings
					} = Lookup[unresolvedOptions,
						{
							PolishWorkingElectrode,
							PolishingPads,
							PolishingSolutions,
							NumberOfPolishingSolutionDroplets,
							NumberOfPolishings
						}
					];
					{
						workingElectrodeSonication,
						workingElectrodeSonicationTime,
						workingElectrodeSonicationTemperature
					} = Lookup[unresolvedOptions,
						{
							WorkingElectrodeSonication,
							WorkingElectrodeSonicationTime,
							WorkingElectrodeSonicationTemperature
						}
					];
					{
						workingElectrodeWashing,
						workingElectrodeWashingCycles,
						counterElectrodeWashing
					} = Lookup[unresolvedOptions,
						{
							WorkingElectrodeWashing,
							WorkingElectrodeWashingCycles,
							CounterElectrodeWashing
						}
					];
					{
						preparedSample,
						reactionVessel,
						electrodeCap,
						loadingSampleVolume,
						solventVolume
					} = Lookup[unresolvedOptions,
						{
							PreparedSample,
							ReactionVessel,
							ElectrodeCap,
							LoadingSampleVolume,
							SolventVolume
						}
					];
					{
						analyte,
						sampleAmount,
						targetConcentration
					} = Lookup[unresolvedOptions,
						{
							Analyte,
							SampleAmount,
							LoadingSampleTargetConcentration
						}
					];
					{
						solvent,
						electrolyte,
						pretreatElectrodes,
						electrolyteSolution,
						electrolyteSolutionLoadingVolume,
						loadingSampleElectrolyteAmount,
						electrolyteTargetConcentration
					} = Lookup[unresolvedOptions,
						{
							Solvent,
							Electrolyte,
							PretreatElectrodes,
							ElectrolyteSolution,
							ElectrolyteSolutionLoadingVolume,
							LoadingSampleElectrolyteAmount,
							ElectrolyteTargetConcentration
						}
					];
					{
						referenceElectrode,
						refreshReferenceElectrode,
						referenceElectrodeSoakTime
					} = Lookup[unresolvedOptions,
						{
							ReferenceElectrode,
							RefreshReferenceElectrode,
							ReferenceElectrodeSoakTime
						}
					];
					{
						internalStandard,
						internalStandardAdditionOrder,
						internalStandardAmount,
						internalStandardTargetConcentration
					} = Lookup[unresolvedOptions,
						{
							InternalStandard,
							InternalStandardAdditionOrder,
							InternalStandardAmount,
							InternalStandardTargetConcentration
						}
					];
					{
						pretreatmentSparging,
						pretreatmentSpargingPreBubbler,
						pretreatmentInitialPotential,
						pretreatmentFirstPotential,
						pretreatmentSecondPotential,
						pretreatmentFinalPotential,
						pretreatmentPotentialSweepRate,
						pretreatmentNumberOfCycles
					} = Lookup[unresolvedOptions,
						{
							PretreatmentSparging,
							PretreatmentSpargingPreBubbler,
							PretreatmentInitialPotential,
							PretreatmentFirstPotential,
							PretreatmentSecondPotential,
							PretreatmentFinalPotential,
							PretreatmentPotentialSweepRate,
							PretreatmentNumberOfCycles
						}
					];
					{
						loadingSampleMix,
						loadingSampleMixType,
						loadingSampleMixTemperature,
						loadingSampleMixTime,
						loadingSampleNumberOfMixes,
						loadingSampleMixVolume,
						loadingSampleMixUntilDissolved,
						loadingSampleMaxNumberOfMixes,
						loadingSampleMaxMixTime
					} = Lookup[unresolvedOptions,
						{
							LoadingSampleMix,
							LoadingSampleMixType,
							LoadingSampleMixTemperature,
							LoadingSampleMixTime,
							LoadingSampleNumberOfMixes,
							LoadingSampleMixVolume,
							LoadingSampleMixUntilDissolved,
							LoadingSampleMaxNumberOfMixes,
							LoadingSampleMaxMixTime
						}
					];
					{
						sparging,
						spargingGas,
						spargingTime,
						spargingPreBubbler
					} = Lookup[unresolvedOptions,
						{
							Sparging,
							SpargingGas,
							SpargingTime,
							SpargingPreBubbler
						}
					];
					{
						initialPotentials,
						firstPotentials,
						secondPotentials,
						finalPotentials,
						potentialSweepRates,
						numberOfCycles
					} = Lookup[unresolvedOptions,
						{
							InitialPotentials,
							FirstPotentials,
							SecondPotentials,
							FinalPotentials,
							PotentialSweepRates,
							NumberOfCycles
						}
					];

					(* ------------------------------------ *)
					(* -- Resolve the Polishing Options --  *)
					(* ------------------------------------ *)

					{polishingOptionsAssociation, polishingOptionsErrorTrackingAssociation, polishingOptionsWarningTrackingAssociation} = Module[{
						coatedWorkingElectrodeBool,
						nonNullPolishingPadsBool,
						nonNullPolishingSolutionsBool,
						nonNullNumberOfPolishingSolutionDropletsBool,
						nonNullNumberOfPolishingsBool,
						missingPolishingPadsBool,
						missingPolishingSolutionsBool,
						missingNumberOfPolishingSolutionDropletsBool,
						missingNumberOfPolishingsBool,
						mismatchingPolishingSolutionsLengthBool,
						mismatchingNumberOfPolishingSolutionDropletsLengthBool,
						mismatchingNumberOfPolishingsLengthBool,
						polishingSolutionModelsToCheck,
						nonPolishingSolutionsBool,
						nonPolishingSolutionsBools,
						nonPolishingSolutions,
						nonDefaultPolishingSolutionBool,
						nonDefaultPolishingSolutionBools,
						nonDefaultPolishingSolutions
					},

						If[MatchQ[polishWorkingElectrode, False],
							(* If polishWorkingElectrode is False *)

							(* set variables that will not be used *)
							coatedWorkingElectrodeBool = False;
							missingPolishingPadsBool = False;
							missingPolishingSolutionsBool = False;
							missingNumberOfPolishingSolutionDropletsBool = False;
							missingNumberOfPolishingsBool = False;
							mismatchingPolishingSolutionsLengthBool = False;
							mismatchingNumberOfPolishingSolutionDropletsLengthBool = False;
							mismatchingNumberOfPolishingsLengthBool = False;
							nonPolishingSolutionsBool = False;
							nonPolishingSolutionsBools = {False};
							nonPolishingSolutions = {False};
							nonDefaultPolishingSolutionBool = False;
							nonDefaultPolishingSolutionBools = {False};
							nonDefaultPolishingSolutions = {False};

							(* resolving *)
							Module[{},
								(* If these options are Automatic, resolve to Null *)
								resolvedPolishingPads = polishingPads /. {Automatic -> Null};
								resolvedPolishingSolutions = polishingSolutions /. {Automatic -> Null};
								resolvedNumberOfPolishingDroplets = numberOfPolishingDroplets /. {Automatic -> Null};
								resolvedNumberOfPolishings = numberOfPolishings /. {Automatic -> Null};

								(* We track every polishing parameter option if they are Null *)
								nonNullPolishingPadsBool = If[!MatchQ[resolvedPolishingPads, Null],
									True,
									False
								];
								nonNullPolishingSolutionsBool = If[!MatchQ[resolvedPolishingSolutions, Null],
									True,
									False
								];
								nonNullNumberOfPolishingSolutionDropletsBool = If[!MatchQ[resolvedNumberOfPolishingDroplets, Null],
									True,
									False
								];
								nonNullNumberOfPolishingsBool = If[!MatchQ[resolvedNumberOfPolishings, Null],
									True,
									False
								];
							],
							(* If polishWorkingElectrode is True *)

							(* set variables that will not be used *)
							nonNullPolishingPadsBool = False;
							nonNullPolishingSolutionsBool = False;
							nonNullNumberOfPolishingSolutionDropletsBool = False;
							nonNullNumberOfPolishingsBool = False;

							(* resolving *)
							Module[{polishingPadLength},
								(* fetch if working electrode is coated *)
								coatedWorkingElectrodeBool = Lookup[fetchPacketFromCache[workingElectrode, newCache], Coated];

								(* If PolishingPad is Automatic, set it to the default series of polishing pads *)
								resolvedPolishingPads = (polishingPads /. {Automatic -> {Model[Item, ElectrodePolishingPad, "Diamond/Nylon Polishing Pad (Fine Polishing Grade), KitComponent"], Model[Item, ElectrodePolishingPad, "Alumina/Texmet Polishing Pad (Ultra-fine Polishing Grade), KitComponent"]}}) /.x:ObjectP[]:>Download[x, Object];

								(* Get the length of resolvedPolishingPads *)
								polishingPadLength = Length[resolvedPolishingPads];

								(* Get the default PolishingSolutions from resolvedPolishingPads *)

								defaultPolishingSolutions = Download[#, Object] & /@ (Lookup[fetchPacketFromCache[#, newCache], DefaultPolishingSolution] &/@ resolvedPolishingPads);

								(* If PolishingSolutions is Automatic, set it to defaultPolishingSolutions *)
								resolvedPolishingSolutions = polishingSolutions /. {Automatic -> defaultPolishingSolutions};

								(* If NumberOfPolishingDroplets and NumberOfPolishings are Automatic, set them according to polishingPadLength *)
								resolvedNumberOfPolishingDroplets = numberOfPolishingDroplets /. {Automatic -> ConstantArray[2, polishingPadLength]};
								resolvedNumberOfPolishings = numberOfPolishings /. {Automatic -> ConstantArray[1, polishingPadLength]};

								(* Check if PolishingPads, PolishingSolutions, NumberOfPolishingDroplets, and NumberOfPolishings are all not Null *)
								missingPolishingPadsBool = If[MatchQ[resolvedPolishingPads, Except[{ObjectP[{Model[Item,ElectrodePolishingPad], Object[Item, ElectrodePolishingPad]}]..}]],
									True,
									False
								];

								missingPolishingSolutionsBool = If[MatchQ[resolvedPolishingSolutions, Except[{ObjectP[{Model[Sample], Object[Sample]}]..}]&&MatchQ[missingPolishingPadsBool, False]],
									True,
									False
								];

								missingNumberOfPolishingSolutionDropletsBool = If[MatchQ[resolvedNumberOfPolishingDroplets, Except[{_Integer..}]]&&MatchQ[missingPolishingPadsBool, False],
									True,
									False
								];

								missingNumberOfPolishingsBool = If[MatchQ[resolvedNumberOfPolishings, Except[{_Integer..}]]&&MatchQ[missingPolishingPadsBool, False],
									True,
									False
								];

								(* Check if PolishingSolutions, NumberOfPolishingDroplets, and NumberOfPolishings all have the same length with PolishingPads *)
								mismatchingPolishingSolutionsLengthBool = If[!MatchQ[Length[resolvedPolishingSolutions], polishingPadLength]&&MatchQ[missingPolishingSolutionsBool, False],
									True,
									False
								];

								mismatchingNumberOfPolishingSolutionDropletsLengthBool = If[!MatchQ[Length[resolvedNumberOfPolishingDroplets], polishingPadLength]&&MatchQ[missingNumberOfPolishingSolutionDropletsBool, False],
									True,
									False
								];

								mismatchingNumberOfPolishingsLengthBool = If[!MatchQ[Length[resolvedNumberOfPolishings], polishingPadLength]&&MatchQ[missingNumberOfPolishingsBool, False],
									True,
									False
								];

								(* get the models for polishing solutions *)
								polishingSolutionModelsToCheck = If[MatchQ[#, ObjectP[Model[Sample]]],
									Download[#, Object],
									Download[Lookup[fetchPacketFromCache[#, newCache], Model], Object]
								]&/@ resolvedPolishingSolutions;

								(* check if the polishing solution models are legit polishing solution models *)
								nonPolishingSolutionsBools = If[MemberQ[legitPolishingSolutionModels, #],
									False,
									True
								]&/@ polishingSolutionModelsToCheck;

								(* get the polishing solutions that do not have a legit polishing solution model *)
								nonPolishingSolutions = PickList[resolvedPolishingSolutions, nonPolishingSolutionsBools, True];
								(* if any entry of the nonPolishingSolutionsBools is True, set nonPolishingSolutionsBool to True *)
								nonPolishingSolutionsBool = AnyTrue[nonPolishingSolutionsBools, TrueQ];

								(* check if the polishing solution models agree with the defaultPolishingSolutions *)
								nonDefaultPolishingSolutionBools = If[MatchQ[Length[resolvedPolishingSolutions], polishingPadLength]&&!MatchQ[resolvedPolishingSolutions, Null]&&!MatchQ[polishingSolutionModelsToCheck, Null]&&MatchQ[nonPolishingSolutionsBool, False],

									(* Only check this if all the previous errors are not encountered *)
									Not[MatchQ[First[#], Last[#]]]&/@Transpose[{defaultPolishingSolutions, polishingSolutionModelsToCheck}],
									ConstantArray[False, Length[resolvedPolishingSolutions]]
								];

								(* get the non-default polishing solutions  *)
								nonDefaultPolishingSolutions = PickList[resolvedPolishingSolutions, nonDefaultPolishingSolutionBools, True];

								(* if any entry of the nonDefaultPolishingSolutions is True, set nonDefaultPolishingSolution to True *)
								nonDefaultPolishingSolutionBool = AnyTrue[nonDefaultPolishingSolutionBools, TrueQ];
							]
						];
						{
							Association[
								PolishWorkingElectrode -> polishWorkingElectrode,
								PolishingPads -> resolvedPolishingPads,
								PolishingSolutions -> resolvedPolishingSolutions,
								NumberOfPolishingSolutionDroplets -> resolvedNumberOfPolishingDroplets,
								NumberOfPolishings -> resolvedNumberOfPolishings
							],
							Association[
								(* WorkingElectrode is Coated or not *)
								CoatedWorkingElectrode -> coatedWorkingElectrodeBool,

								(* Non-Null Polishing Parameters *)
								NonNullPolishingPads -> nonNullPolishingPadsBool,
								NonNullPolishingSolutions -> nonNullPolishingSolutionsBool,
								NonNullNumberOfPolishingSolutionDroplets -> nonNullNumberOfPolishingSolutionDropletsBool,
								NonNullNumberOfPolishings -> nonNullNumberOfPolishingsBool,

								(* Missing Polishing Parameters *)
								MissingPolishingPads -> missingPolishingPadsBool,
								MissingPolishingSolutions -> missingPolishingSolutionsBool,
								MissingNumberOfPolishingSolutionDroplets -> missingNumberOfPolishingSolutionDropletsBool,
								MissingNumberOfPolishings -> missingNumberOfPolishingsBool,

								(* Polishing Parameters Length Mismatch *)
								MisMatchingPolishingSolutionsLength -> mismatchingPolishingSolutionsLengthBool,
								MisMatchingNumberOfPolishingSolutionDropletsLength -> mismatchingNumberOfPolishingSolutionDropletsLengthBool,
								MisMatchingNumberOfPolishingsLength -> mismatchingNumberOfPolishingsLengthBool,

								(* Not Legit Polishing Solutions *)
								NonPolishingSolutionBool -> nonPolishingSolutionsBool,
								NonPolishingSolutionBools -> nonPolishingSolutionsBools,
								NonPolishingSolutions -> nonPolishingSolutions
							],
							Association[
								(* Non-Default Polishing Solutions *)
								NonDefaultPolishingSolutionBool -> nonDefaultPolishingSolutionBool,
								NonDefaultPolishingSolutionBools -> nonDefaultPolishingSolutionBools,
								NonDefaultPolishingSolutions -> nonDefaultPolishingSolutions
							]
						}
					];

					(* ----------------------------------------------------- *)
					(* -- Resolve the WorkingElectrodeSonication options --  *)
					(* ----------------------------------------------------- *)
					{sonicationOptionsAssociation, sonicationOptionsErrorTrackingAssociation} = Module[{
							sonicationSensitiveWorkingElectrodeBool,
							nonNullSonicationTimeBool,
							nonNullSonicationTemperatureBool,
							missingSonicationTimeBool,
							missingSonicationTemperatureBool
						},
						If[MatchQ[workingElectrodeSonication, False],
							(* If workingElectrodeSonication is False *)
							(* set variables that will not be used *)
							sonicationSensitiveWorkingElectrodeBool = False;
							missingSonicationTimeBool = False;
							missingSonicationTemperatureBool = False;

							(* resolving *)
							Module[{},
								resolvedWorkingElectrodeSonicationTime = workingElectrodeSonicationTime /. {Automatic -> Null};
								resolvedWorkingElectrodeSonicationTemperature = workingElectrodeSonicationTemperature /. {Automatic -> Null};
								nonNullSonicationTimeBool = If[!MatchQ[resolvedWorkingElectrodeSonicationTime, Null],
									True,
									False
								];
								nonNullSonicationTemperatureBool = If[!MatchQ[resolvedWorkingElectrodeSonicationTemperature, Null],
									True,
									False
								];
							],

							(* If workingElectrodeSonication is True *)
							(* set variables that will not be used *)
							nonNullSonicationTimeBool = False;
							nonNullSonicationTemperatureBool = False;

							(* resolving *)
							Module[{},

								sonicationSensitiveWorkingElectrodeBool = Lookup[fetchPacketFromCache[workingElectrode, newCache], SonicationSensitive];
								resolvedWorkingElectrodeSonicationTime = workingElectrodeSonicationTime /. {Automatic -> 30 Second};
								resolvedWorkingElectrodeSonicationTemperature = workingElectrodeSonicationTemperature /. {Automatic -> $AmbientTemperature};

								missingSonicationTimeBool = If[MatchQ[resolvedWorkingElectrodeSonicationTime, Null],
									True,
									False
								];
								missingSonicationTemperatureBool = If[MatchQ[resolvedWorkingElectrodeSonicationTemperature, Null],
									True,
									False
								];
							]
						];
						{
							Association[
								WorkingElectrodeSonication -> workingElectrodeSonication,
								WorkingElectrodeSonicationTime -> resolvedWorkingElectrodeSonicationTime,
								WorkingElectrodeSonicationTemperature -> resolvedWorkingElectrodeSonicationTemperature
							],
							Association[
								(* Coated WorkingElectrode Tracking *)
								SonicationSensitiveWorkingElectrode -> sonicationSensitiveWorkingElectrodeBool,

								(* Non-Null Sonication Parameters *)
								NonNullSonicationTime -> nonNullSonicationTimeBool,
								NonNullSonicationTemperature -> nonNullSonicationTemperatureBool,

								(* Missing Sonication Parameters *)
								MissingSonicationTime -> missingSonicationTimeBool,
								MissingSonicationTemperature -> missingSonicationTemperatureBool
							]
						}
					];

					(* -----------------------------------------------------------------------------  *)
					(* -- Resolve the WorkingElectrodeWashing and CounterElectrodeWashing options --  *)
					(* ------------------------------------------------------------------------------ *)
					{electrodeWashingOptionsAssociation, electrodeWashingOptionsErrorTrackingAssociation} = Module[{
							nonNullWorkingElectrodeWashingCyclesBool,
							missingWorkingElectrodeWashingCyclesBool
						},
						If[MatchQ[workingElectrodeWashing, False],
							(* -- If WorkingElectrodeWashing is False -- *)
							(* Set missingWorkingElectrodeWashingCyclesBool to False *)
							missingWorkingElectrodeWashingCyclesBool = False;

							resolvedWorkingElectrodeWashingCycles = workingElectrodeWashingCycles/.{Automatic -> Null};
							nonNullWorkingElectrodeWashingCyclesBool = If[!MatchQ[resolvedWorkingElectrodeWashingCycles, Null],
								True,
								False
							],

							(* -- If WorkingElectrodeWashing is True -- *)
							(* Set nonNullWorkingElectrodeWashingCyclesBool to False *)
							nonNullWorkingElectrodeWashingCyclesBool = False;
							resolvedWorkingElectrodeWashingCycles = workingElectrodeWashingCycles/.{Automatic -> 1};
							missingWorkingElectrodeWashingCyclesBool = If[MatchQ[resolvedWorkingElectrodeWashingCycles, Null],
								True,
								False
							]
						];
						{
							Association[
								WorkingElectrodeWashing -> workingElectrodeWashing,
								WorkingElectrodeWashingCycles -> resolvedWorkingElectrodeWashingCycles,
								CounterElectrodeWashing -> counterElectrodeWashing
							],
							Association[
								NonNullWorkingElectrodeWashingCycles -> nonNullWorkingElectrodeWashingCyclesBool,
								MissingWorkingElectrodeWashingCycles -> missingWorkingElectrodeWashingCyclesBool
							]
						}
					];

					(* ------------------------------------------------ *)
					(* -- Resolve the Loading Sample Volume Options --  *)
					(* ------------------------------------------------ *)
					{loadingSampleVolumeOptionsAssociation, loadingSampleVolumeOptionsErrorTrackingAssociation, loadingSampleVolumeWarningTrackingAssociation} = Module[{
						mismatchingSampleStateBool,
						mismatchingReactionVesselWithElectrodeCapBool,
						nonNullSolventVolumeBool,
						missingSolventVolumeBool,
						tooSmallSolventVolumeBool,
						tooSmallLoadingSampleVolumeBool,
						tooLargeLoadingSampleVolumeBool,
						solventVolumeLargerThanLoadingVolumeBool
					},

						(* First resolve PreparedSample *)
						(* get the sample state *)
						sampleState = Lookup[fetchPacketFromCache[sample, newCache], State];

						(* resolve PreparedSample *)
						resolvedPreparedSample = Which[
							MatchQ[preparedSample,Except[Automatic]],
							preparedSample,

							(* If sample is Liquid, PreparedSample is set to True*)
							MatchQ[sampleState, Liquid],
							True,

							(*In any other case, including is sample is Solid, PreparedSample is set to True*)
							True,
							False
						];

						(* If resolvedPreparedSample is True and sampleState is Solid OR If resolvedPreparedSample is False and sampleState is Liquid, set mismatchingSampleStateBool to True*)
						mismatchingSampleStateBool = If[
							(MatchQ[resolvedPreparedSample,True]&&MatchQ[sampleState, Liquid])||(MatchQ[resolvedPreparedSample,False]&&MatchQ[sampleState, Solid]),
							False,
							True
						];

						(* Need to check if the reaction vessel is compatible with the electrode cap *)
						(* Get the connectors for the reaction vessel and electrode cap *)
						reactionVesselConnectors = Lookup[fetchPacketFromCache[reactionVessel, newCache], Connectors];
						electrodeCapConnectors = Lookup[fetchPacketFromCache[electrodeCap, newCache], Connectors];

						(* Find out the reactionVessel cap port *)
						reactionVesselCapPort = First[Select[reactionVesselConnectors, StringContainsQ[First[#], "Cap Port", IgnoreCase -> True]&]];

						(* Get out the outer diameter of reactionVessel cap port *)
						reactionVesselCapPortOuterDiameter = reactionVesselCapPort[[5]];

						(* Find out the electrodeCap reaction vessel port *)
						capReactionVesselPort = First[Select[electrodeCapConnectors, StringContainsQ[First[#], "Reaction Vessel Port", IgnoreCase -> True]&]];

						(* Get out the inner diameter of electrodeCap reaction vessel port *)
						capReactionVesselPortInnerDiameter = capReactionVesselPort[[4]];

						(* Check if these two diameters agree with each other *)
						mismatchingReactionVesselWithElectrodeCapBool = If[
							And[
								DistanceQ[reactionVesselCapPortOuterDiameter],
								DistanceQ[capReactionVesselPortInnerDiameter],
								GreaterQ[Abs[reactionVesselCapPortOuterDiameter - capReactionVesselPortInnerDiameter], 1 Millimeter]
							],
							True,
							False
						];

						(* get reaction vessel max volume *)
						reactionVesselMaxVolume = Lookup[fetchPacketFromCache[reactionVessel, newCache], MaxVolume];

						(* set Automatic LoadingSampleVolume to 60% of the reactionVesselMaxVolume *)
						resolvedLoadingSampleVolume = loadingSampleVolume /. {Automatic -> 0.6 * reactionVesselMaxVolume};

						(* depending on the resolvedPreparedSample, Automatic resolvedSolventVolume is set to resolvedLoadingSampleVolume or Null *)
						resolvedSolventVolume = If[MatchQ[resolvedPreparedSample, True],
							solventVolume /. {Automatic -> Null},
							solventVolume /. {Automatic -> resolvedLoadingSampleVolume}
						];

						(* If PreparedSample is True and resolvedSolventVolume is not Null, we get a non-Null SolventVolume error *)
						nonNullSolventVolumeBool = If[MatchQ[resolvedPreparedSample, True]&&!MatchQ[resolvedSolventVolume, Null],
							True,
							False
						];

						(* If PreparedSample is False and resolvedSolventVolume is Null, we get a missing SolventVolume error *)
						missingSolventVolumeBool = If[MatchQ[resolvedPreparedSample, False]&&MatchQ[resolvedSolventVolume, Null],
							True,
							False
						];

						(* If resolvedLoadingSampleVolume is less than 50% of the reactionVesselMaxVolume, we get a tooSmallLoadingSampleVolumeError *)
						tooSmallLoadingSampleVolumeBool = If[LessQ[resolvedLoadingSampleVolume, 0.5 * reactionVesselMaxVolume],
							True,
							False
						];

						(* We only check tooSmallSolventVolumeBool if resolvedPreparedSample is False and tooSmallLoadingSampleVolumeBool is False *)
						(* If resolvedSolventVolume is less than the resolvedLoadingSampleVolume or if resolvedSolventVolume is less than 50% of the reactionVesselMaxVolume, we get a tooSmallSolventVolumeError *)
						tooSmallSolventVolumeBool = If[And[MatchQ[resolvedPreparedSample, False], MatchQ[tooSmallLoadingSampleVolumeBool, False], Or[LessQ[resolvedSolventVolume, resolvedLoadingSampleVolume], LessQ[resolvedSolventVolume, 0.5 * reactionVesselMaxVolume]]],
							True,
							False
						];

						(* If resolvedLoadingSampleVolume is greater than 90% of the reactionVesselMaxVolume, we get a tooLargeLoadingSampleVolumeError *)
						tooLargeLoadingSampleVolumeBool = If[GreaterQ[resolvedLoadingSampleVolume, 0.9 * reactionVesselMaxVolume],
							True,
							False
						];

						(* If resolvedSolventVolume is greater than resolvedLoadingSampleVolume, we get a solventVolumeGreaterThanLoadingSampleVolume warning *)
						solventVolumeLargerThanLoadingVolumeBool = If[GreaterQ[resolvedSolventVolume, resolvedLoadingSampleVolume],
							True,
							False
						];

						{
							Association[
								LoadingSampleVolume -> resolvedLoadingSampleVolume,
								SolventVolume -> resolvedSolventVolume,
								PreparedSample->resolvedPreparedSample
							],
							Association[
								MismatchingSampleStateBool -> mismatchingSampleStateBool,
								MismatchingReactionVesselWithElectrodeCapBool -> mismatchingReactionVesselWithElectrodeCapBool,
								NonNullSolventVolumeBool -> nonNullSolventVolumeBool,
								MissingSolventVolumeBool -> missingSolventVolumeBool,
								TooSmallSolventVolumeBool -> tooSmallSolventVolumeBool,
								TooSmallLoadingSampleVolumeBool -> tooSmallLoadingSampleVolumeBool,
								TooLargeLoadingSampleVolumeBool -> tooLargeLoadingSampleVolumeBool,
								ReactionVesselMaxVolume -> reactionVesselMaxVolume
							],
							Association[
								SolventVolumeLargerThanLoadingVolumeBool -> solventVolumeLargerThanLoadingVolumeBool
							]
						}
					];

					(* ------------------------------------------ *)
					(* -- Resolve the Analyte related Options --  *)
					(* ------------------------------------------ *)

					(* Get analyte and composition information from current sample *)

					sampleAnalyteLinks = Lookup[fetchPacketFromCache[sample, newCache], Analytes];
					(* Note: the 3rd element of composition entry is time, which is not relevant here. remove it. *)
					sampleComposition = Lookup[fetchPacketFromCache[sample, newCache], Composition][[All, {1, 2}]];
					sampleAnalytes = sampleAnalyteLinks/.{x:ObjectP[]:>Download[x, Object]};

					{analyteOptionsAssociation, analyteOptionsErrorTrackingAssociation} = Module[{
						(* Error tracking booleans *)
						sampleMissingCompositionBool,
						sampleMissingAnalyteBool,
						preparedSampleIncompleteCompositionBool,
						ambiguousAnalyteBool,
						mismatchingAnalyteBool,
						preparedSampleWithUnresolvableCompositionUnitBool,
						missingSampleAmountBool,
						missingLoadingSampleTargetConcentrationBool,
						nonNullSampleAmountBool,
						nonNullTargetConcentrationBool,
						mismatchingConcentrationParametersBool,
						tooLowLoadingSampleTargetConcentrationBool,
						tooHighLoadingSampleTargetConcentrationBool,

						(* Local variables *)
						analyteMolecularWeight,
						analyteCompositionEntry,
						sampleAnalyteConcentration,
						calculatedTargetConcentration,
						calculatedSampleAmount
						},

						(* If the SamplesIn does not have Composition field filled out, we have preparedSampleMissingComposition error *)
						sampleMissingCompositionBool = If[MatchQ[sampleComposition,{}],
							True,
							False
						];

						(* If the SamplesIn does not have Analytes field filled out, we have preparedSampleMissingAnalyte error *)
						sampleMissingAnalyteBool = If[MatchQ[sampleAnalytes,{}],
							True,
							False
						];

						(* If PreparedSample is True, and the SamplesIn's Composition field has less than 3 entries, we have preparedSampleIncompleteComposition error *)
						preparedSampleIncompleteCompositionBool = If[MatchQ[resolvedPreparedSample, True]&&MatchQ[sampleState,Liquid]&&LessQ[Length[sampleComposition], 3],
							True,
							False
						];

						(* If the SamplesIn's Analytes field has more than one entry, we have ambiguousAnalyte error *)
						ambiguousAnalyteBool = If[GreaterQ[Length[sampleAnalytes], 1],
							True,
							False
						];

						(* get resolvedAnalyte. If analyte is Automatic and sampleMissingAnalyteBool is False, set it to the only entry of the SamplesIn's Analytes field *)
						resolvedAnalyte = If[MatchQ[sampleMissingAnalyteBool, False],
							analyte /. {Automatic -> First[sampleAnalytes]},
							analyte /. {Automatic -> Null}
						]/.x:ObjectP[]:>Download[x, Object];

						(* If resolvedAnalyte doesn't match with the only entry of the SamplesIn's Analytes field, we have mismatchingAnalyte error. We only check this error if sampleMissingAnalyteBool is False *)
						mismatchingAnalyteBool = If[
							MatchQ[sampleMissingAnalyteBool, False]&&!MatchQ[resolvedAnalyte, First[sampleAnalytes]],
							True,
							False
						];

						(* If PreparedSample is True, and the analyte's composition unit in SamplesIn's Composition field is not Molar or Mass/Volume, we have preparedSampleCompositionUnresolvableCompositionUnit error *)
						(* First we obtain the analyte unit within the sample composition field *)
						analyteCompositionEntry = Flatten[Select[(sampleComposition /. {_, Null} -> Nothing), MatchQ[Download[#[[2]], Object], resolvedAnalyte]&]];
						sampleAnalyteConcentration = If[!MatchQ[analyteCompositionEntry, {}],
							First[analyteCompositionEntry],
							Null
						];

						(* We only check this error only if the sampleMissingAnalyteBool, ambiguousAnalyteBool, and mismatchingAnalyteBool are all False *)
						preparedSampleWithUnresolvableCompositionUnitBool = If[And[
							MatchQ[resolvedPreparedSample, True],
							MatchQ[sampleState,Liquid],
							MatchQ[sampleMissingAnalyteBool, False],
							MatchQ[ambiguousAnalyteBool, False],
							MatchQ[mismatchingAnalyteBool, False]
						],
							(* If the analyte composition unit is not molar units or mass concentration units, we throw this error *)
							If[!MatchQ[sampleAnalyteConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
								True,
								False
							],
							False
						];

						(* If PreparedSample is False, and SampleAmount is set to Null, we have missingSampleAmount error *)
						missingSampleAmountBool = If[MatchQ[resolvedPreparedSample, False]&&MatchQ[sampleAmount, Null],
							True,
							False
						];

						(* If PreparedSample is False, and LoadingSampleTargetConcentration is set to Null, we have missingLoadingSampleTargetConcentration error *)
						missingLoadingSampleTargetConcentrationBool = If[MatchQ[resolvedPreparedSample, False]&&MatchQ[targetConcentration, Null],
							True,
							False
						];

						(* If PreparedSample is True, and the SampleAmount is not Automatic or Null, we have nonNullSampleAmount error *)
						nonNullSampleAmountBool = If[MatchQ[resolvedPreparedSample, True]&&!MatchQ[sampleAmount, Alternatives[Automatic, Null]],
							True,
							False
						];

						(* If PreparedSample is True, and the LoadingSampleTargetConcentration is not Automatic or Null, we have nonNullTargetConcentration error *)
						nonNullTargetConcentrationBool = If[MatchQ[resolvedPreparedSample, True]&&!MatchQ[targetConcentration, Alternatives[Automatic, Null]],
							True,
							False
						];

						(* get resolvedAnalyte molecular weight only resolvedAnalyte is not Null *)
						analyteMolecularWeight = If[!MatchQ[resolvedAnalyte, Null],
							Lookup[fetchPacketFromCache[resolvedAnalyte, newCache], MolecularWeight],
							Null
						];

						(* Resolve targetConcentration first *)
						resolvedTargetConcentration = If[MatchQ[resolvedPreparedSample, True],
							(* If PreparedSample is True, we set Automatic targetConcentration to Null *)
							targetConcentration /. {Automatic -> Null},
							(* If PreparedSample is False: *)
							Which[
								(* If the target concentration is Null, this is set to Null *)
								MatchQ[missingLoadingSampleTargetConcentrationBool, True],
								Null,

								(* If sample amount is automatic, set automatic target concentration to 10 Millimolar *)
								MatchQ[missingLoadingSampleTargetConcentrationBool, False]&&MatchQ[sampleAmount, Automatic],
								targetConcentration /. {Automatic -> 10 Millimolar},

								(* If sample amount is specified, set automatic target concentration according to sample amount, analyte molecular weight, solvent volume, and sample analyte mass concentration *)
								And[
									MatchQ[missingLoadingSampleTargetConcentrationBool, False],
									MatchQ[missingSampleAmountBool, False],
									!MatchQ[sampleAmount, Automatic],
									MatchQ[sampleAnalyteConcentration, MassPercentP]
								],
								Module[{},
									calculatedTargetConcentration = If[And[
										!MatchQ[sampleAmount, Null],
										!MatchQ[analyteMolecularWeight, Null],
										!MatchQ[sampleAnalyteConcentration, Null],
										!MatchQ[resolvedSolventVolume, Null],
										MatchQ[sampleAnalyteConcentration, MassPercentP]
									],
										(* Using the helper function to generate the target concentration *)

										getTargetConcentration[resolvedSolventVolume, sample, sampleAmount, resolvedAnalyte, Millimolar, newCache],
										Null
									];
									targetConcentration /. {Automatic -> calculatedTargetConcentration}
								],

								(* For all other cases, keep the input option *)
								True,
								targetConcentration /. {Automatic -> Null}
							]
						];

						(* Check if we need to throw the tooLowLoadingSampleTargetConcentrationBool warning *)
						(* Note: we don't check these warnings for prepared liquid samples *)
						tooLowLoadingSampleTargetConcentrationBool = If[MatchQ[resolvedPreparedSample, False],

							(* If resolvedTargetConcentration is lower than 1 Millimolar, we set this to True *)
							If[And[
								MatchQ[resolvedTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
								MatchQ[resolvedAnalyte, ObjectP[Model[Molecule]]],
								MatchQ[analyteMolecularWeight, MolecularWeightP],
								Or[
									LessQ[resolvedTargetConcentration, 1 Millimolar],
									LessQ[resolvedTargetConcentration, UnitConvert[1 Millimolar * analyteMolecularWeight, Milligram/Milliliter]]
								]
							],
								True,
								False
							],

							(* We don't check this warning for prepared liquid samples *)
							False
						];

						(* Check if we need to throw the tooHighLoadingSampleTargetConcentrationBool warning *)
						tooHighLoadingSampleTargetConcentrationBool = If[MatchQ[resolvedPreparedSample, False],

							(* If resolvedTargetConcentration is higher than 15 Millimolar, we set this to True *)
							If[And[
								MatchQ[resolvedTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
								MatchQ[resolvedAnalyte, ObjectP[Model[Molecule]]],
								MatchQ[analyteMolecularWeight, MolecularWeightP],
								Or[
									GreaterQ[resolvedTargetConcentration, 15 Millimolar],
									GreaterQ[resolvedTargetConcentration, UnitConvert[15 Millimolar * analyteMolecularWeight, Milligram/Milliliter]]
								]
							],
								True,
								False
							],

							(* We don't check this warning for prepared liquid samples *)
							False
						];

						(* After LoadingSampleTargetConcentration, we resolve SampleAmount *)
						resolvedSampleAmount = If[MatchQ[resolvedPreparedSample, True],
							(* If PreparedSample is True, we set Automatic sample amount to Null *)
							sampleAmount /. {Automatic -> Null},
							(* If PreparedSample is False: *)
							Which[
								(* If sampleAmount is Null, this is set to Null *)
								MatchQ[missingSampleAmountBool, True],
								Null,

								(* If resolvedTargetConcentration is not Null: *)
								!MatchQ[resolvedTargetConcentration, Null],
								Module[{},
									calculatedSampleAmount = If[
										And[
											!MatchQ[resolvedTargetConcentration, Null],
											!MatchQ[analyteMolecularWeight, Null],
											!MatchQ[sampleAnalyteConcentration, Null],
											!MatchQ[resolvedSolventVolume, Null],
											MatchQ[sampleAnalyteConcentration, MassPercentP]
										],
										(* Using the helper function to generate the sample amount *)
										getSampleAmount[resolvedSolventVolume, sample, resolvedTargetConcentration, resolvedAnalyte, Milligram, newCache],

										(* If any of the required parameter is Null, we set calculatedSampleAmount to the input option *)
										Null
									];
									sampleAmount /. {Automatic -> calculatedSampleAmount}
								],

								(* For all other cases, keep the input option *)
								True,
								sampleAmount /. {Automatic -> Null}
							]
						];


						(* If PreparedSample is False, and both SampleAmount and LoadingSampleTargetConcentration are specified but they do not agree with each other given a fixed SolventVolume, we have mismatchingConcentrationParameters error *)
						mismatchingConcentrationParametersBool = If[MatchQ[resolvedPreparedSample, False],
							If[And[
								!MatchQ[analyteMolecularWeight, Null],
								!MatchQ[sampleAnalyteConcentration, Null],
								!MatchQ[resolvedSolventVolume, Null],
								!MatchQ[resolvedTargetConcentration, Null],
								!MatchQ[resolvedSampleAmount, Null],
								MatchQ[sampleAnalyteConcentration, MassPercentP],
								MatchQ[resolvedSampleAmount, MassP],
								MatchQ[resolvedTargetConcentration, Alternatives[_?ConcentrationQ, _?MassConcentrationQ]]],

								(* If all the above parameters are properly resolved, use the helper function to check if resolvedSampleAmount and resolvedTargetConcentration match *)
								Not[sampleAmountTargetConcentrationMatchQ[resolvedSolventVolume, sample, resolvedSampleAmount, resolvedTargetConcentration, resolvedAnalyte, newCache]],

								(* If any of the required parameter is Null, we can't check this error and set this to False *)
								False
							],

							(* We don't check this error for prepared liquid samples *)
							False
						];

						{
							Association[
								Analyte -> resolvedAnalyte,
								SampleAmount -> resolvedSampleAmount,
								LoadingSampleTargetConcentration -> resolvedTargetConcentration
							],
							Association[
								SampleMissingCompositionBool -> sampleMissingCompositionBool,
								SampleMissingAnalyteBool -> sampleMissingAnalyteBool,
								PreparedSampleIncompleteCompositionBool -> preparedSampleIncompleteCompositionBool,
								AmbiguousAnalyteBool -> ambiguousAnalyteBool,
								MismatchingAnalyteBool -> mismatchingAnalyteBool,
								PreparedSampleWithUnresolvableCompositionUnitBool -> preparedSampleWithUnresolvableCompositionUnitBool,
								MissingSampleAmountBool -> missingSampleAmountBool,
								MissingLoadingSampleTargetConcentrationBool -> missingLoadingSampleTargetConcentrationBool,
								NonNullSampleAmountBool -> nonNullSampleAmountBool,
								NonNullTargetConcentrationBool -> nonNullTargetConcentrationBool,
								MismatchingConcentrationParametersBool -> mismatchingConcentrationParametersBool,
								TooLowLoadingSampleTargetConcentrationBool -> tooLowLoadingSampleTargetConcentrationBool,
								TooHighLoadingSampleTargetConcentrationBool -> tooHighLoadingSampleTargetConcentrationBool
							]
						}
					];

					(* ---------------------------------------------------------------- *)
					(* -- Resolve the Solvent, Electrolyte, and ElectrolyteSolution --  *)
					(* ---------------------------------------------------------------- *)

					{solventAndElectrolyteOptionsAssociation, solventAndElectrolyteOptionsErrorTrackingAssociation, solventAndElectrolyteOptionsWarningTrackingAssociation} = Module[{
						(* -- Errors -- *)

						(* prepared liquid input sample and prepared electrolyte solution *)
						preparedSampleMissingSolventBool,
						sampleSolventAmbiguousMoleculeBool,

						electrolyteSolutionNotLiquidBool,
						electrolyteSolutionMissingSolventBool,
						electrolyteSolutionMissingAnalyteBool,
						electrolyteSolutionAmbiguousAnalyteBool,
						electrolyteSolutionSolventAmbiguousMoleculeBool,

						(* specified solvent *)
						resolvedSolventNotLiquidBool,
						solventAmbiguousMoleculeBool,

						(* Mismatches between prepared liquid input sample, electrolyte solution and specified solvent *)
						solventMoleculeMismatchPreparedSampleSolventMoleculeBool,
						electrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMoleculeBool,
						electrolyteSolutionSolventMoleculeMismatchSolventMoleculeBool,

						(* Electrolyte related *)
						sampleElectrolyteMoleculeWithUnresolvableCompositionUnitBool,
						sampleElectrolyteMoleculeMissingMolecularWeightBool,
						sampleElectrolyteMoleculeMissingDefaultSampleModelBool,
						sampleElectrolyteMoleculeNotFoundBool,
						sampleAmbiguousElectrolyteMoleculeBool,
						electrolyteSolutionElectrolyteMoleculeMissingDefaultSampleModelBool,
						electrolyteSampleAmbiguousMoleculeBool,
						resolvedElectrolyteSampleNotSolidBool,
						electrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool,
						electrolyteSolutionElectrolyteMoleculeMissingMolecularWeightBool,
						electrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool,
						cannotAutomaticallyResolveElectrolyteBool,
						electrolyteSolutionElectrolyteMoleculeNotFoundBool,
						electrolyteSolutionAmbiguousElectrolyteMoleculeBool,
						electrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnitBool,
						electrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMoleculeBool,

						(* Electrolyte solution related *)
						nonNullElectrolyteSolutionBool,
						nonNullElectrolyteSolutionLoadingVolumeBool,
						nonNullLoadingSampleElectrolyteAmountBool,

						missingElectrolyteSolutionLoadingVolumeBool,
						missingElectrolyteTargetConcentrationBool,
						missingLoadingSampleElectrolyteAmountBool,
						missingElectrolyteSolutionBool,

						tooSmallElectrolyteSolutionLoadingVolumeBool,
						tooLargeElectrolyteSolutionLoadingVolumeBool,

						tooLowElectrolyteTargetConcentrationBool,
						tooHighElectrolyteTargetConcentrationBool,
						electrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSampleBool,
						electrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentrationBool,
						electrolyteTargetConcentrationMismatchPreparedSampleBool,

						loadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentrationBool,

						(* -- Warnings -- *)
						solventMismatchPreparedSampleSolventBool,
						electrolyteSolutionSolventMismatchSolventBool,

						(* -- Variables -- *)
						resolvedElectrolyteMolecularWeight,
						calculatedElectrolyteConcentrationFromLoadingSampleElectrolyteAmount
						},

						(* Get solvent information from the current sample. This will be Null for solid input samples *)
						sampleSolvent = Download[Lookup[fetchPacketFromCache[sample, newCache], Solvent, Null], Object];

						(* -- Prepared sample initial checks -- *)
						(* If the sample is a liquid prepared sample and solvent field is Null, we throw the preparedSampleMissingSolvent error *)
						preparedSampleMissingSolventBool = If[MatchQ[resolvedPreparedSample, True]&&MatchQ[sampleState,Liquid] && MatchQ[sampleSolvent, Null],
							True,
							False
						];

						(* If preparedSampleMissingSolventBool is False, we need to check the solvent *)
						If[
							And[
								MatchQ[resolvedPreparedSample, True],
								MatchQ[preparedSampleMissingSolventBool, False]
							],
							Which[
								(* If it is Model[Sample] *)
								MatchQ[sampleSolvent, ObjectP[Model[Sample]]],
									sampleSolventModelSample = sampleSolvent;

									(* Use the helper function (at the end of this file) to generate the result *)
									{sampleSolventMolecule, sampleSolventAmbiguousMoleculeBool} = getSampleMolecule[sampleSolventModelSample, newCache],

								(* Otherwise we can't get these information *)
								True,
									sampleSolventModelSample = Null;
									sampleSolventMolecule = Null;
									sampleSolventAmbiguousMoleculeBool = False;
							],

							(* Otherwise we can't get these information *)
							sampleSolventModelSample = Null;
							sampleSolventMolecule = Null;
							sampleSolventAmbiguousMoleculeBool = False;
						];


						(* -- ElectrolyteSolution initial checks -- *)
						If[MatchQ[pretreatElectrodes, True] && !MatchQ[electrolyteSolution, Alternatives[Null, Automatic]],

							(* If pretreatElectrode is True and ElectrolyteSolution is specified *)
							Module[{},
								{
									electrolyteSolutionSolventLink,
									electrolyteSolutionState,
									electrolyteSolutionAnalyteLink,
									electrolyteSolutionComposition
								} = Lookup[fetchPacketFromCache[electrolyteSolution, newCache], {Solvent, State, Analytes, Composition}];

								electrolyteSolutionSolvent = Download[electrolyteSolutionSolventLink,Object];
								electrolyteSolutionAnalyteList = electrolyteSolutionAnalyteLink/.x:ObjectP[]:>Download[x, Object];

								(* If the electrolyteSolution is not a liquid, we throw the electrolyteSolutionNotLiquid error *)
								electrolyteSolutionNotLiquidBool = If[!MatchQ[electrolyteSolutionState, Liquid],
									True,
									False
								];

								(* If the electrolyteSolution is a liquid and its solvent field is Null, we throw the electrolyteSolutionMissingSolvent error *)
								electrolyteSolutionMissingSolventBool = If[MatchQ[electrolyteSolutionNotLiquidBool, False] && MatchQ[electrolyteSolutionSolvent, Null],
									True,
									False
								];

								(* If the electrolyteSolution is a liquid and its Analytes field is Null, we throw the electrolyteSolutionMissingAnalyte error *)
								electrolyteSolutionMissingAnalyteBool = If[MatchQ[electrolyteSolutionNotLiquidBool, False] && !MatchQ[electrolyteSolutionAnalyteList, {ObjectP[Model[Molecule]]..}],
									True,
									False
								];

								(* If the electrolyteSolution is a liquid and there are more than one entry in its Analyte field, we throw the electrolyteSolutionAmbiguousAnalyte error *)
								electrolyteSolutionAmbiguousAnalyteBool = If[MatchQ[electrolyteSolutionNotLiquidBool, False] && MatchQ[electrolyteSolutionMissingAnalyteBool, False] && GreaterQ[Length[electrolyteSolutionAnalyteList], 1],
									True,
									False
								];

								(* We can set electrolyteSolutionElectrolyteMolecule if no error is encountered *)
								electrolyteSolutionElectrolyteMolecule = If[
									And[
										MatchQ[electrolyteSolutionNotLiquidBool, False],
										MatchQ[electrolyteSolutionMissingAnalyteBool, False],
										MatchQ[electrolyteSolutionAmbiguousAnalyteBool, False]
									],
									First[electrolyteSolutionAnalyteList],
									(* Otherwise, we set electrolyteSolutionElectrolyteMolecule to Null *)
									Null
								];

								{
									electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar,
									electrolyteSolutionElectrolyteMoleculeConcentrationInMilligramPerMilliliter,
									electrolyteSolutionElectrolyteMoleculeMissingMolecularWeightBool,
									electrolyteSolutionElectrolyteMoleculeNotFoundBool,
									electrolyteSolutionAmbiguousElectrolyteMoleculeBool,
									electrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnitBool
								} = If[
									MatchQ[electrolyteSolutionElectrolyteMolecule, ObjectP[Model[Molecule]]],

									(* If electrolyteSolutionElectrolyteMolecule is not Null, we can get these information using the helper function *)
									getMoleculeCompositionInformation[electrolyteSolution, electrolyteSolutionElectrolyteMolecule, newCache],

									(* If electrolyteSolutionElectrolyteMolecule is Null, we can't get these information *)
									{Null, Null, False, False, False, False}
								];

								(* If electrolyteSolutionNotLiquidBool and electrolyteSolutionMissingSolventBool are False, we need to check the electrolyteSolution solvent *)
								If[
									And[
										MatchQ[electrolyteSolutionNotLiquidBool, False],
										MatchQ[electrolyteSolutionMissingSolventBool, False]
									],
									Which[
										(* If it is Model[Sample] *)
										MatchQ[electrolyteSolutionSolvent, ObjectP[Model[Sample]]],
											electrolyteSolutionSolventSampleModel = electrolyteSolutionSolvent;

											(* Use the helper function (at the end of this file) to generate the result *)
											{electrolyteSolutionSolventMolecule, electrolyteSolutionSolventAmbiguousMoleculeBool} = getSampleMolecule[electrolyteSolutionSolventSampleModel, newCache],

										(* Otherwise we can't get these information *)
										True,
											electrolyteSolutionSolventSampleModel = Null;
											electrolyteSolutionSolventMolecule = Null;
											electrolyteSolutionSolventAmbiguousMoleculeBool = False;
									],

									(* Otherwise we can't get these information *)
									electrolyteSolutionSolventSampleModel = Null;
									electrolyteSolutionSolventMolecule = Null;
									electrolyteSolutionSolventAmbiguousMoleculeBool = False;
								];
							],

							(* If ElectrolyteSolution is Automatic or Null we don't do these checks *)
							electrolyteSolutionSolventLink = Null;
							electrolyteSolutionState = Null;
							electrolyteSolutionAnalyteLink = Null;
							electrolyteSolutionAnalyteList = Null;
							electrolyteSolutionComposition = Null;
							electrolyteSolutionElectrolyteMolecule = Null;
							electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar = Null;
							electrolyteSolutionElectrolyteMoleculeConcentrationInMilligramPerMilliliter = Null;
							electrolyteSolutionSolventSampleModel = Null;
							electrolyteSolutionSolventMolecule = Null;

							electrolyteSolutionNotLiquidBool = False;
							electrolyteSolutionMissingSolventBool = False;
							electrolyteSolutionMissingAnalyteBool = False;
							electrolyteSolutionAmbiguousAnalyteBool = False;
							electrolyteSolutionSolventAmbiguousMoleculeBool = False;
							electrolyteSolutionElectrolyteMoleculeMissingMolecularWeightBool = False;
							electrolyteSolutionElectrolyteMoleculeNotFoundBool = False;
							electrolyteSolutionAmbiguousElectrolyteMoleculeBool = False;
							electrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnitBool = False;
						];

						(* -- Resolve Solvent -- *)
						resolvedSolvent = If[MatchQ[resolvedPreparedSample, True],
							(* If the input sample is a prepared sample, resolve automatic solvent to the only member of the prepared sample Solvent field *)
							Module[{},

								If[
									And[
										MatchQ[preparedSampleMissingSolventBool, False],
										MatchQ[sampleSolventAmbiguousMoleculeBool, False]
									],
									(* If no solvent related error is encountered, set Automatic solvent to sampleSolventModelSample *)
									solvent /. {Automatic -> sampleSolventModelSample},

									(* If any solvent related error is encountered, set Automatic solvent to Null *)
									solvent /. {Automatic -> Null}
								]
							],

							(* If the input sample is a unprepared solid sample *)
							Module[{},

								If[
									And[
										MatchQ[pretreatElectrodes, True],
										!MatchQ[electrolyteSolution, Alternatives[Null, Automatic]],
										MatchQ[electrolyteSolutionNotLiquidBool, False],
										MatchQ[electrolyteSolutionMissingSolventBool, False],
										MatchQ[electrolyteSolutionSolventAmbiguousMoleculeBool, False]
									],

									(* If pretreatElectrodes is True, ElectrolyteSolution is provided, and no related errors were encountered, resolve automatic solvent to the electrolyteSolutionSolvent *)
									solvent /. {Automatic -> electrolyteSolutionSolventSampleModel},

									(* If pretreatElectrodes is False or ElectrolyteSolution is not provided, resolve automatic solvent to acetonitrile *)
									solvent /. {Automatic -> Model[Sample, "Acetonitrile, Electronic Grade"]}
								]
							]
						]/.x:ObjectP[]:>Download[x, Object];

						(* Check if resolvedSolvent is a liquid *)
						resolvedSolventNotLiquidBool = If[MatchQ[resolvedSolvent, ObjectP[{Model[Sample], Object[Sample]}]],
							(* solvent can be successfully resolved, we look up the State of resolvedSolvent *)
							If[!MatchQ[Lookup[fetchPacketFromCache[resolvedSolvent, newCache], State], Liquid],
								True,
								False
							],

							(* If we can't resolve solvent, we don't check this error *)
							False
						];

						(* If resolvedSolvent is not Null, we can get the solventMolecule from resolvedSolvent and see if the ambiguousMoleculeError rise *)
						{solventMolecule, solventAmbiguousMoleculeBool} = If[MatchQ[resolvedSolvent, ObjectP[{Model[Sample], Object[Sample]}]]&&MatchQ[resolvedSolventNotLiquidBool, False],

							(* Use the helper function (at the end of this file) to generate the result *)
							getSampleMolecule[resolvedSolvent, newCache],

							(* Otherwise we can't get these information *)
							{Null, False}
						];

						(* If both solventMolecule and sampleSolventMolecule are not Null, we can check the solventMoleculeMismatchPreparedSampleSolventMolecule error *)
						solventMoleculeMismatchPreparedSampleSolventMoleculeBool = If[
							And[
								!MatchQ[solventMolecule, Null],
								!MatchQ[sampleSolventMolecule, Null],
								MatchQ[resolvedSolventNotLiquidBool, False]
							],
							If[!MatchQ[sampleSolventMolecule, solventMolecule],

								(* If sampleSolventMolecule and solventMolecule do not match, we set this to True *)
								True,

								(* Otherwise, we set this to False *)
								False
							],

							(* Otherwise, we set this to False *)
							False
						];

						(* If resolvedPreparedSample is True, and no sample solvent error is encountered, we can check the preparedSampleMismatchingSolvent warning *)
						solventMismatchPreparedSampleSolventBool = If[
							And[
								MatchQ[resolvedPreparedSample, True],
								MatchQ[preparedSampleMissingSolventBool, False],
								MatchQ[sampleSolventAmbiguousMoleculeBool, False],
								MatchQ[solventMoleculeMismatchPreparedSampleSolventMoleculeBool, False],
								!MatchQ[resolvedSolvent, Null],
								MatchQ[resolvedSolventNotLiquidBool, False]
							],
							If[!MatchQ[sampleSolventModelSample, resolvedSolvent],

								(* If sampleSolventList and resolvedSolvent do not match, we set this to True *)
								True,

								(* Otherwise, we set this to False *)
								False
							],

							(* Otherwise, we set this to False *)
							False
						];

						(* If both electrolyteSolutionSolventMolecule and sampleSolventMolecule are not Null, we can check the electrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMolecule error *)
						electrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMoleculeBool = If[
							And[
								!MatchQ[electrolyteSolutionSolventMolecule, Null],
								!MatchQ[sampleSolventMolecule, Null]
							],
							If[!MatchQ[sampleSolventMolecule, electrolyteSolutionSolventMolecule],

								(* If sampleSolventMolecule and solventMolecule do not match, we set this to True *)
								True,

								(* Otherwise, we set this to False *)
								False
							],

							(* Otherwise, we set this to False *)
							False
						];

						(* If both electrolyteSolutionSolventMolecule and sampleSolventMolecule are not Null, we can check the electrolyteSolutionSolventMoleculeMismatchSolventMolecule error *)
						electrolyteSolutionSolventMoleculeMismatchSolventMoleculeBool = If[
							And[
								!MatchQ[electrolyteSolutionSolventMolecule, Null],
								!MatchQ[solventMolecule, Null],
								MatchQ[resolvedSolventNotLiquidBool, False]
							],
							If[!MatchQ[solventMolecule, electrolyteSolutionSolventMolecule],

								(* If sampleSolventMolecule and solventMolecule do not match, we set this to True *)
								True,

								(* Otherwise, we set this to False *)
								False
							],

							(* Otherwise, we set this to False *)
							False
						];

						(* If resolvedSolvent is not Null, no electrolyteSolution solvent error is encountered, and electrolyteSolutionSolventList is not an empty list or Null, we can check the electrolyteSolutionSolventMismatchSolvent warning *)
						electrolyteSolutionSolventMismatchSolventBool = If[
							And[
								!MatchQ[resolvedSolvent, Null],
								MatchQ[pretreatElectrodes, True],
								MatchQ[electrolyteSolution, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[electrolyteSolutionNotLiquidBool, False],
								MatchQ[electrolyteSolutionMissingSolventBool, False],
								MatchQ[electrolyteSolutionSolventAmbiguousMoleculeBool, False],
								MatchQ[electrolyteSolutionSolventMoleculeMismatchSolventMoleculeBool, False],
								MatchQ[resolvedSolventNotLiquidBool, False]
							],
							If[!MatchQ[resolvedSolvent, electrolyteSolutionSolventSampleModel],

								(* If sampleSolventList and electrolyteSolutionSolventList do not match, we set this to True *)
								True,

								(* Otherwise, we set this to False *)
								False
							],

							(* Otherwise, we set this to False *)
							False
						];

						(* set a resolvedSolventMolecule for later use *)
						resolvedSolventMolecule = If[
							And[
								MatchQ[solventMoleculeMismatchPreparedSampleSolventMoleculeBool, False],
								MatchQ[electrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMoleculeBool, False],
								MatchQ[electrolyteSolutionSolventMoleculeMismatchSolventMoleculeBool, False]
							],

							(* If none of the above errors is encountered, we set resolvedSolventMolecule to solventMolecule *)
							solventMolecule,
							Null
						];

						(* -- Resolve electrolyte -- *)
						(* First we may be able to get the electrolyte molecule and its MassConcentration from prepared liquid sample if the sampleSolventMolecule is not Null. We will check these information again if this step is not successful (the prepared sample has a fourth internal standard composition entry) once we have a resolvedElectrolyteMolecule *)
						{
							sampleElectrolyteMolecule,
							sampleElectrolyteMoleculeConcentrationInMillimolar,
							sampleElectrolyteMoleculeConcentrationInMilligramPerMilliliter,
							sampleElectrolyteMoleculeMissingMolecularWeightBool,
							sampleElectrolyteMoleculeWithUnresolvableCompositionUnitBool
						} = If[MatchQ[resolvedPreparedSample, True]&&MatchQ[sampleSolventMolecule, ObjectP[Model[Molecule]]],
							(* If the input sample is prepared liquid sample, we can try to get the last entry of the prepared sample composition that's not resolvedAnalyte or sampleSolventMolecule: *)
							getLastMoleculeInformationFromSampleComposition[sample, {resolvedAnalyte, sampleSolventMolecule}, newCache],

							(* If the input sample is unprepared solid, we set this to Null *)
							{Null, Null, Null, False, False}
						];

						(* get the DefaultSampleModel for sampleElectrolyteMolecule *)
						sampleElectrolyteMoleculeModelSample = If[MatchQ[sampleElectrolyteMolecule, ObjectP[Model[Molecule]]],

							(* If sampleElectrolyteMolecule is not Null *)
							Download[Lookup[fetchPacketFromCache[sampleElectrolyteMolecule, newCache], DefaultSampleModel], Object],
							(* If sampleElectrolyteMolecule is Null, we set this to Null *)
							Null
						];

						(* If electrolyte is Automatic and sampleElectrolyteMolecule is not Null, but sampleElectrolyteMoleculeModelSample is Null, we have the sampleElectrolyteMoleculeMissingDefaultModelSample error *)
						sampleElectrolyteMoleculeMissingDefaultSampleModelBool = If[
							And[
								MatchQ[electrolyte, Automatic],
								MatchQ[sampleElectrolyteMolecule, ObjectP[Model[Molecule]]],
								MatchQ[sampleElectrolyteMoleculeModelSample, Null]
							],
							True,
							False
						];

						(* get the DefaultSampleModel for electrolyteSolutionElectrolyteMolecule *)
						electrolyteSolutionElectrolyteMoleculeModelSample = If[MatchQ[electrolyteSolutionElectrolyteMolecule, ObjectP[Model[Molecule]]],

							(* If sampleElectrolyteMolecule is not Null *)
							Download[Lookup[fetchPacketFromCache[electrolyteSolutionElectrolyteMolecule, newCache], DefaultSampleModel], Object],
							(* If sampleElectrolyteMolecule is Null, we set this to Null *)
							Null
						];

						(* If electrolyte is Automatic and sampleElectrolyteMolecule is not Null, but sampleElectrolyteMoleculeModelSample is Null, we have the sampleElectrolyteMoleculeMissingDefaultModelSample error *)
						electrolyteSolutionElectrolyteMoleculeMissingDefaultSampleModelBool = If[
							And[
								MatchQ[electrolyte, Automatic],
								MatchQ[electrolyteSolutionElectrolyteMolecule, ObjectP[Model[Molecule]]],
								MatchQ[electrolyteSolutionElectrolyteMoleculeModelSample, Null]
							],
							True,
							False
						];

						(* resolve electrolyte sample *)
						resolvedElectrolyte = If[MatchQ[resolvedPreparedSample, True],
							(* If the input sample is a prepared sample, resolve automatic electrolyte to the DefaultSampleModel of sampleElectrolyteMolecule if it's not Null *)
							Module[{},

								If[MatchQ[sampleElectrolyteMoleculeModelSample, ObjectP[Model[Sample]]],
									(* If sampleElectrolyteMoleculeModelSample is not Null *)
									electrolyte /. {Automatic -> sampleElectrolyteMoleculeModelSample},

									(* If sampleElectrolyteMoleculeModelSample is Null, we check if electrolyteSolutionElectrolyteMoleculeModelSample is not Null. *)
									If[
										And[
											MatchQ[pretreatElectrodes, True],
											MatchQ[electrolyteSolution, ObjectP[{Model[Sample], Object[Sample]}]],
											MatchQ[electrolyteSolutionNotLiquidBool, False],
											MatchQ[electrolyteSolutionMissingAnalyteBool, False],
											MatchQ[electrolyteSolutionAmbiguousAnalyteBool, False],
											MatchQ[electrolyteSolutionElectrolyteMoleculeModelSample, ObjectP[Model[Sample]]]
										],
										(* If electrolyteSolutionElectrolyteMoleculeModelSample is not Null *)
										electrolyte /. {Automatic -> electrolyteSolutionElectrolyteMoleculeModelSample},

										(* Otherwise, we can't resolve automatic Electrolyte *)
										electrolyte /. {Automatic -> Null}
									]
								]
							],

							(* If the input sample is a unprepared solid sample *)
							Module[{},

								If[
									And[
										MatchQ[pretreatElectrodes, True],
										MatchQ[electrolyteSolution, ObjectP[{Model[Sample], Object[Sample]}]],
										MatchQ[electrolyteSolutionNotLiquidBool, False],
										MatchQ[electrolyteSolutionMissingAnalyteBool, False],
										MatchQ[electrolyteSolutionAmbiguousAnalyteBool, False],
										MatchQ[electrolyteSolutionElectrolyteMoleculeModelSample, ObjectP[Model[Sample]]]
									],

									(* If pretreatElectrodes is True, ElectrolyteSolution is provided, and no related errors were encountered, resolve automatic electrolyte to the electrolyteSolutionSolventList *)
									electrolyte /. {Automatic -> electrolyteSolutionElectrolyteMoleculeModelSample},

									(* If pretreatElectrodes is False or ElectrolyteSolution is not provided, resolve automatic electrolyte to KCl for water solvent, or [NBu4][PF6] for organic solvent *)
									If[MatchQ[resolvedSolvent, Download[Model[Sample, "Milli-Q water"], Object]],

										(* If the solvent is "Milli-Q water", resolve Automatic electrolyte to KCl *)
										electrolyte /. {Automatic -> Model[Sample, "Potassium Chloride"]},

										(* Otherwise, for organic solvents, resolve Automatic electrolyte to [NBu4][PF6] *)
										electrolyte /. {Automatic -> Model[Sample, "Tetrabutylammonium hexafluorophosphate"]}
									]
								]
							]
						] /. x:ObjectP[]:>Download[x, Object];

						(* Check if resolvedElectrolyte is a solid *)
						resolvedElectrolyteSampleNotSolidBool = If[MatchQ[resolvedElectrolyte, ObjectP[{Model[Sample], Object[Sample]}]],
							(* electrolyte can be successfully resolved, we look up the State of resolvedElectrolyte *)
							If[!MatchQ[Lookup[fetchPacketFromCache[resolvedElectrolyte, newCache], State], Solid],
								True,
								False
							],

							(* If we can't resolve electrolyte, we don't check this error *)
							False
						];

						(* get the molecule of the resolvedElectrolyte and collect possible ambiguous molecule error *)
						{electrolyteMolecule, electrolyteSampleAmbiguousMoleculeBool} = If[MatchQ[resolvedElectrolyte, ObjectP[{Model[Sample], Object[Sample]}]]&&MatchQ[resolvedElectrolyteSampleNotSolidBool, False],

							(* If resolvedElectrolyte is not Null *)
							getSampleMolecule[resolvedElectrolyte, newCache],

							(* Other wise we set electrolyteMolecule to Null *)
							{Null, False}
						];

						(* Check if the electrolyte molecule from resolvedElectrolyte matches with the electrolyte molecule from prepared sample *)
						electrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool = If[
							And[
								MatchQ[sampleElectrolyteMolecule, ObjectP[Model[Molecule]]],
								MatchQ[electrolyteMolecule, ObjectP[Model[Molecule]]],
								!MatchQ[sampleElectrolyteMolecule, electrolyteMolecule],
								MatchQ[resolvedElectrolyteSampleNotSolidBool, False]
							],

							(* If both molecules are not Null but they do not match with each other, we set this error to True *)
							True,

							(* Otherwise to False *)
							False
						];

						(* Check if the electrolyte molecule from electrolyte solution matches with the electrolyte molecule from resolvedElectrolyte *)
						electrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMoleculeBool = If[
							And[
								MatchQ[electrolyteMolecule, ObjectP[Model[Molecule]]],
								MatchQ[electrolyteSolutionElectrolyteMolecule, ObjectP[Model[Molecule]]],
								!MatchQ[electrolyteMolecule, electrolyteSolutionElectrolyteMolecule],
								MatchQ[resolvedElectrolyteSampleNotSolidBool, False]
							],

							(* If both molecules are not Null but they do not match with each other, we set this error to True *)
							True,

							(* Otherwise to False *)
							False
						];

						(* Check if the electrolyte molecule from electrolyte solution matches with the electrolyte molecule from prepared sample *)
						electrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool = If[
							And[
								MatchQ[sampleElectrolyteMolecule, ObjectP[Model[Molecule]]],
								MatchQ[electrolyteSolutionElectrolyteMolecule, ObjectP[Model[Molecule]]],
								!MatchQ[sampleElectrolyteMolecule, electrolyteSolutionElectrolyteMolecule],
								MatchQ[resolvedElectrolyteSampleNotSolidBool, False]
							],

							(* If both molecules are not Null but they do not match with each other, we set this error to True *)
							True,

							(* Otherwise to False *)
							False
						];

						(* set the resolvedElectrolyteMolecule *)
						resolvedElectrolyteMolecule = If[
							And[
								MatchQ[electrolyteMolecule, ObjectP[Model[Molecule]]],
								MatchQ[electrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool, False],
								MatchQ[electrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMoleculeBool, False],
								MatchQ[electrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool, False]
							],

							(* If electrolyteMolecule is not Null, and the previous two errors are not encountered, we set resolvedElectrolyteMolecule to electrolyteMolecule. *)
							electrolyteMolecule,

							(* Otherwise, we set resolvedElectrolyteMolecule to Null *)
							Null
						];

						(* get the MolecularWeight of resolvedElectrolyteMolecule *)
						resolvedElectrolyteMoleculeMolecularWeight = If[
							MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]],
							Lookup[fetchPacketFromCache[resolvedElectrolyteMolecule, newCache], MolecularWeight],
							Null
						];

						(* For prepared liquid sample, if either resolvedAnalyte or resolvedElectrolyteMolecule is not properly set, we throw the CannotResolveElectrolyte error *)
						cannotAutomaticallyResolveElectrolyteBool = If[
							And[
								MatchQ[preparedSample, True],
								MatchQ[sampleState,Liquid],
								MatchQ[Lookup[analyteOptionsErrorTrackingAssociation, PreparedSampleIncompleteCompositionBool], False],
								MatchQ[preparedSampleMissingSolventBool, False],
								MatchQ[sampleSolventAmbiguousMoleculeBool, False],
								MatchQ[resolvedElectrolyteSampleNotSolidBool, False],
								MatchQ[sampleElectrolyteMoleculeMissingDefaultSampleModelBool, False],
								MatchQ[electrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool, False],
								MatchQ[electrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMoleculeBool, False],
								MatchQ[electrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool, False],
								Or[
									!MatchQ[resolvedElectrolyte, ObjectP[{Model[Sample], Object[Sample]}]],
									!MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]]
								]
							],

							True,
							False
						];

						(* If we didn't get the information of sampleElectrolyteMolecule right after " -- Resolve electrolyte -- ", we get them here using the resolvedElectrolyteMolecule *)

						If[
							And[
								MatchQ[resolvedPreparedSample, True],
								!MatchQ[sampleElectrolyteMolecule, ObjectP[Model[Molecule]]],
								MatchQ[sampleElectrolyteMoleculeMissingMolecularWeightBool, False],
								MatchQ[sampleElectrolyteMoleculeWithUnresolvableCompositionUnitBool, False],
								MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]]
							],

							(* use the helper function to identify the electrolyte molecule and its information *)
							{
								sampleElectrolyteMoleculeConcentrationInMillimolar,
								sampleElectrolyteMoleculeConcentrationInMilligramPerMilliliter,
								sampleElectrolyteMoleculeMissingMolecularWeightBool,
								sampleElectrolyteMoleculeNotFoundBool,
								sampleAmbiguousElectrolyteMoleculeBool,
								sampleElectrolyteMoleculeWithUnresolvableCompositionUnitBool
							} = getMoleculeCompositionInformation[sample, resolvedElectrolyteMolecule, newCache],

							(* Otherwise, we keep the information obtained previously and just set sampleElectrolyteMoleculeNotFoundBool and sampleAmbiguousElectrolyteMoleculeBool to False *)
							sampleElectrolyteMoleculeNotFoundBool = False;
							sampleAmbiguousElectrolyteMoleculeBool = False;
						];

						(* If we can find the electrolyte molecule in the prepared sample composition now, we set Null resolvedPreparedSample to the resolvedElectrolyteMolecule *)
						If[
							And[
								MatchQ[resolvedPreparedSample, True],
								!MatchQ[sampleElectrolyteMolecule, ObjectP[Model[Molecule]]],
								MatchQ[sampleElectrolyteMoleculeMissingMolecularWeightBool, False],
								MatchQ[sampleElectrolyteMoleculeWithUnresolvableCompositionUnitBool, False],
								MatchQ[sampleElectrolyteMoleculeNotFoundBool, False],
								MatchQ[sampleAmbiguousElectrolyteMoleculeBool, False],
								MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]]
							],

							sampleElectrolyteMolecule = resolvedElectrolyteMolecule;
						];

						(* === Electrolyte Solution related options === *)

						(* Resolve ElectrolyteSolutionLoadingVolume *)
						resolvedElectrolyteSolutionLoadingVolume = If[MatchQ[pretreatElectrodes, True],
							(* If we are pre-treating the electrodes, set automatic ElectrolyteSolutionLoadingVolume to 60% of the reactionVesselMaxVolume *)
							electrolyteSolutionLoadingVolume /. {Automatic -> 0.6 * reactionVesselMaxVolume},

							(* If we are not pre-treating the electrodes, set automatic ElectrolyteSolutionLoadingVolume to Null  *)
							electrolyteSolutionLoadingVolume /. {Automatic -> Null}
						];

						(* Non-Null ElectrolyteSolutionLoadingVolume check *)
						nonNullElectrolyteSolutionLoadingVolumeBool = If[
							And[
								MatchQ[pretreatElectrodes, False],
								!MatchQ[resolvedElectrolyteSolutionLoadingVolume, Null]
							],

							(* If pretreatElectrode is False and resolvedElectrolyteSolutionLoadingVolume is not Null, we set this error to True *)
							True,
							False
						];

						(* Missing ElectrolyteSolutionLoadingVolume check *)
						missingElectrolyteSolutionLoadingVolumeBool = If[
							And[
								MatchQ[pretreatElectrodes, True],
								MatchQ[resolvedElectrolyteSolutionLoadingVolume, Null]
							],
							(* If pretreatElectrodes is True and resolvedElectrolyteSolutionLoadingVolume is Null, we set this error to True *)
							True,
							False
						];

						(* If resolvedElectrolyteSolutionLoadingVolume is less than 50% of the reactionVesselMaxVolume, we get a tooSmallElectrolyteSolutionLoadingVolume error *)
						tooSmallElectrolyteSolutionLoadingVolumeBool = If[MatchQ[pretreatElectrodes, True] && LessQ[resolvedElectrolyteSolutionLoadingVolume, 0.5 * reactionVesselMaxVolume],
							True,
							False
						];

						(* If resolvedElectrolyteSolutionLoadingVolume is greater than 90% of the reactionVesselMaxVolume, we get a tooLargeElectrolyteSolutionLoadingVolume error *)
						tooLargeElectrolyteSolutionLoadingVolumeBool = If[MatchQ[pretreatElectrodes, True] && GreaterQ[resolvedElectrolyteSolutionLoadingVolume, 0.9 * reactionVesselMaxVolume],
							True,
							False
						];

						(* Resolve ElectrolyteTargetConcentration *)
						resolvedElectrolyteTargetConcentration = Which[
							And[
								MatchQ[resolvedPreparedSample, True],
								MatchQ[sampleElectrolyteMolecule, ObjectP[Model[Molecule]]],
								MatchQ[cannotAutomaticallyResolveElectrolyteBool, False],
								MatchQ[resolvedElectrolyte, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]]
							],
							(* If resolvedPreparedSample is True, we resolve automatic ElectrolyteTargetConcentration to sampleElectrolyteMoleculeConcentrationInMillimolar if it's not Null *)
							If[MatchQ[sampleElectrolyteMoleculeConcentrationInMillimolar, ConcentrationP],

								electrolyteTargetConcentration /. {Automatic -> sampleElectrolyteMoleculeConcentrationInMillimolar},

								(* If sampleElectrolyteMoleculeConcentrationInMillimolar is Null, we check pretreatElectrodes and electrolyteSolution *)
								(* If pretreatElectrodes is True and electrolyteSolution is specified *)
								If[
									And[
										MatchQ[pretreatElectrodes, True],
										MatchQ[electrolyteSolution, ObjectP[{Model[Sample], Object[Sample]}]]
									],

									If[MatchQ[electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar, ConcentrationP],
										(* If electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar is not Null, we set Automatic electrolyteTargetConcentration to electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar *)
										electrolyteTargetConcentration /. {Automatic -> electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar},

										(* If electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar is Null, since we are not checking loadingSampleElectrolyteAmount for prepared sample, we set Automatic electrolyteTargetConcentration to Null *)
										electrolyteTargetConcentration /. {Automatic -> Null}
									],

									(* For all the other cases, we can't automatically resolve the electrolyteTargetConcentration *)
									electrolyteTargetConcentration /. {Automatic -> Null}
								]
							],

							(* If cannotAutomaticallyResolveElectrolyteBool is True or we can't resolve electrolyte and electrolyte molecule, we set Automatic electrolyteTargetConcentration to Null *)
							And[
								MatchQ[resolvedPreparedSample, True],
								Or[
									!MatchQ[sampleElectrolyteMolecule, ObjectP[Model[Molecule]]],
									!MatchQ[cannotAutomaticallyResolveElectrolyteBool, False],
									!MatchQ[resolvedElectrolyte, ObjectP[{Model[Sample], Object[Sample]}]],
									!MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]]
								]
							],
							electrolyteTargetConcentration /. {Automatic -> Null},

							And[
								MatchQ[resolvedPreparedSample, False],
								MatchQ[resolvedElectrolyte, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]]
							],
							(* If resolvedPreparedSample is False and we can resolve electrolyte and electrolyte molecule, resolve automatic ElectrolyteTargetConcentration according to ElectrolyteSolution if it is given. If ElectrolyteSolution is not specified, and if we are not pre-treating electrodes, we check LoadingSampleElectrolyteAmount. For all other cases, we set automatic ElectrolyteTargetConcentration to 0.1 Molar for organic solvent and 3 Molar for water. *)

							If[MatchQ[pretreatElectrodes, True],

								(* If we are pre-treating electrodes. *)
								If[MatchQ[electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar, ConcentrationP],
									(* If the electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar is not Null.  *)
									electrolyteTargetConcentration /. {Automatic -> electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar},

									(* If the electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar is Null, we try LoadingSampleElectrolyteAmount  *)
									If[
										And[
											MatchQ[loadingSampleElectrolyteAmount, MassP],
											MatchQ[resolvedSolventVolume, VolumeP]
										],

										(* If LoadingSampleElectrolyteAmount is specified, we set Automatic electrolyteTargetConcentration from LoadingSampleElectrolyteAmount *)
										electrolyteTargetConcentration /. {Automatic -> getTargetConcentration[resolvedSolventVolume, resolvedElectrolyte, loadingSampleElectrolyteAmount, resolvedElectrolyteMolecule, Millimolar, newCache]},

										(* If LoadingSampleElectrolyteAmount is not specified, we set Automatic electrolyteTargetConcentration to 100 Millimolar for Organic solvent and 3 Molar for water *)
										If[MatchQ[resolvedSolvent, Download[Model[Sample, "Milli-Q water"], Object]],

											(* If resolvedSolvent is water, we set this to 3 Molar *)
											electrolyteTargetConcentration /. {Automatic -> 3 Molar},

											(* If resolvedSolvent is not water, we set this to 100 mM *)
											electrolyteTargetConcentration /. {Automatic -> 100 Millimolar}
										]
									]
								],

								(* If we are not pre-treating electrodes, we can check if LoadingSampleElectrolyteAmount is specified *)
								If[
									And[
										MatchQ[loadingSampleElectrolyteAmount, MassP],
										MatchQ[resolvedSolventVolume, VolumeP]
									],

									(* If LoadingSampleElectrolyteAmount is specified, we set Automatic electrolyteTargetConcentration from LoadingSampleElectrolyteAmount *)
									electrolyteTargetConcentration /. {Automatic -> getTargetConcentration[resolvedSolventVolume, resolvedElectrolyte, loadingSampleElectrolyteAmount, resolvedElectrolyteMolecule, Millimolar, newCache]},

									(* If LoadingSampleElectrolyteAmount is not specified, we set Automatic electrolyteTargetConcentration to 100 Millimolar for Organic solvent and 3 Molar for water *)
									If[MatchQ[resolvedSolvent, Download[Model[Sample, "Milli-Q water"], Object]],

										(* If resolvedSolvent is water, we set this to 3 Molar *)
										electrolyteTargetConcentration /. {Automatic -> 3 Molar},

										(* If resolvedSolvent is not water, we set this to 100 mM *)
										electrolyteTargetConcentration /. {Automatic -> 100 Millimolar}
									]
								]
							],

							(* For all the other cases (if we miss any), we set Automatic electrolyteTargetConcentration to 100 Millimolar for Organic solvent and 3 Molar for water  *)
							True,
							If[MatchQ[resolvedSolvent, Download[Model[Sample, "Milli-Q water"], Object]],

								(* If resolvedSolvent is water, we set this to 3 Molar *)
								electrolyteTargetConcentration /. {Automatic -> 3 Molar},

								(* If resolvedSolvent is not water, we set this to 100 mM *)
								electrolyteTargetConcentration /. {Automatic -> 100 Millimolar}
							]
						];

						(* get resolvedElectrolyteConcentration in Millimolar *)
						resolvedElectrolyteTargetConcentrationInMillimolar = If[
							And[
								MatchQ[resolvedElectrolyteTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
								MatchQ[resolvedElectrolyteMoleculeMolecularWeight, MolecularWeightP]
							],

							(* If resolvedElectrolyteConcentration is already in molar units *)
							If[MatchQ[resolvedElectrolyteTargetConcentration, ConcentrationP],
								SafeRound[UnitConvert[resolvedElectrolyteTargetConcentration, Millimolar], 10^-1 Millimolar],

								(* If resolvedElectrolyteConcentration is in mass concentration units *)
								SafeRound[UnitConvert[resolvedElectrolyteTargetConcentration / resolvedElectrolyteMoleculeMolecularWeight, Millimolar], 10^-1 Millimolar]
							],

							(* If the initial conditions are not met, we set this to Null *)
							Null
						];

						(* If resolvedPreparedSample is False and resolvedElectrolyteTargetConcentration is Null, we have the missingElectrolyteTargetConcentration error *)
						missingElectrolyteTargetConcentrationBool = If[
							And[
								MatchQ[resolvedPreparedSample, False],
								MatchQ[electrolyteTargetConcentration, Null]
							],
							(* If resolvedPreparedSample is False and resolvedElectrolyteTargetConcentration is Null, we set this error to True *)
							True,
							False
						];

						(* Check if we need to throw the tooLowElectrolyteTargetConcentrationBool error *)
						(* If the resolvedElectrolyteTargetConcentration is lower than 0.05 M for organic solvent or 0.1 M for water solvent, we throw the tooLowElectrolyteTargetConcentrationBool error *)

						tooLowElectrolyteTargetConcentrationBool = If[
							MatchQ[resolvedSolvent, Download[Model[Sample, "Milli-Q water"], Object]],

							(* If resolvedSolvent is water *)
							If[
								And[
									MatchQ[resolvedElectrolyteTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
									MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]],
									MatchQ[resolvedElectrolyteMoleculeMolecularWeight, MolecularWeightP],
									Or[
										LessQ[resolvedElectrolyteTargetConcentration, 0.1 Molar],
										LessQ[resolvedElectrolyteTargetConcentration, SafeRound[UnitConvert[0.1 Molar * resolvedElectrolyteMoleculeMolecularWeight, Milligram/Milliliter], 10^-1 Milligram/Liter]]
									]
								],
								True,
								False
							],

							(* If resolvedSolvent is organic *)
							If[
								And[
									MatchQ[resolvedElectrolyteTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
									MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]],
									MatchQ[resolvedElectrolyteMoleculeMolecularWeight, MolecularWeightP],
									Or[
										LessQ[resolvedElectrolyteTargetConcentration, 0.05 Molar],
										LessQ[resolvedElectrolyteTargetConcentration, SafeRound[UnitConvert[0.05 Molar * resolvedElectrolyteMoleculeMolecularWeight, Milligram/Milliliter], 10^-1 Milligram/Liter]]
									]
								],
								True,
								False
							]
						];

						(* Check if we need to throw the tooHighElectrolyteTargetConcentrationBool error *)
						(* If the resolvedElectrolyteTargetConcentration is lower than 0.55 M for organic solvent or 3.05 M for water solvent, we throw the tooLowElectrolyteTargetConcentrationBool error *)

						tooHighElectrolyteTargetConcentrationBool = If[
							MatchQ[resolvedSolvent, Download[Model[Sample, "Milli-Q water"], Object]],

							(* If resolvedSolvent is water *)
							If[
								And[
									MatchQ[resolvedElectrolyteTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
									MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]],
									MatchQ[resolvedElectrolyteMoleculeMolecularWeight, MolecularWeightP],
									Or[
										GreaterQ[resolvedElectrolyteTargetConcentration, 3 Molar],
										GreaterQ[resolvedElectrolyteTargetConcentration, SafeRound[UnitConvert[3 Molar * resolvedElectrolyteMoleculeMolecularWeight, Milligram/Milliliter], 10^-1 Milligram/Liter]]
									]
								],
								True,
								False
							],

							(* If resolvedSolvent is organic *)
							If[
								And[
									MatchQ[resolvedElectrolyteTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
									MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]],
									MatchQ[resolvedElectrolyteMoleculeMolecularWeight, MolecularWeightP],
									Or[
										GreaterQ[resolvedElectrolyteTargetConcentration, 0.5 Molar],
										GreaterQ[resolvedElectrolyteTargetConcentration, SafeRound[UnitConvert[0.5 Molar * resolvedElectrolyteMoleculeMolecularWeight, Milligram/Milliliter], 10^-1 Milligram/Liter]]
									]
								],
								True,
								False
							]
						];

						(* At this point, we can check if the electrolyte molecule concentration in electrolyte solution matches with the preparedSample *)
						electrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSampleBool = If[
							And[
								MatchQ[resolvedPreparedSample, True],
								MatchQ[pretreatElectrodes, True],
								MatchQ[electrolyteSolution, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[sampleElectrolyteMoleculeConcentrationInMillimolar, ConcentrationP],
								MatchQ[electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar, ConcentrationP]
							],

							(* If the above conditions are met, we can check this error *)
							If[GreaterEqualQ[Abs[sampleElectrolyteMoleculeConcentrationInMillimolar - electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar], 10^-1 Millimolar],

								(* If sampleElectrolyteMoleculeConcentrationInMillimolar and electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar are off by at least 0.1 Millimolar, we set this error to True *)
								True,
								False
							],

							(* If the above conditions are not fully met, we can't check this error and set it to False *)
							False
						];

						(* Check electrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentration error *)
						electrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentrationBool = If[
							And[
								MatchQ[pretreatElectrodes, True],
								MatchQ[electrolyteSolution, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar, ConcentrationP],
								MatchQ[missingElectrolyteTargetConcentrationBool, False],
								MatchQ[tooLowElectrolyteTargetConcentrationBool, False],
								MatchQ[tooHighElectrolyteTargetConcentrationBool, False],
								MatchQ[resolvedElectrolyteTargetConcentrationInMillimolar, ConcentrationP]
							],

							(* If the above conditions are met, we can check this error *)
							If[GreaterEqualQ[Abs[electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar - resolvedElectrolyteTargetConcentrationInMillimolar], 10^-1 Millimolar],

								(* If electrolyteSolutionElectrolyteMoleculeConcentrationInMillimolar and resolvedElectrolyteTargetConcentrationInMillimolar are off by at least 0.1 Millimolar, we set this error to True *)
								True,
								False
							],

							(* If the above conditions are not fully met, we can't check this error and set it to False *)
							False
						];

						(* Check electrolyteTargetConcentrationMismatchPreparedSample error *)
						electrolyteTargetConcentrationMismatchPreparedSampleBool = If[
							And[
								MatchQ[resolvedPreparedSample, True],
								MatchQ[sampleElectrolyteMoleculeConcentrationInMillimolar, ConcentrationP],

								MatchQ[missingElectrolyteTargetConcentrationBool, False],
								MatchQ[tooLowElectrolyteTargetConcentrationBool, False],
								MatchQ[tooHighElectrolyteTargetConcentrationBool, False],
								MatchQ[resolvedElectrolyteTargetConcentrationInMillimolar, ConcentrationP]
							],

							(* If the above conditions are met, we can check this error *)
							If[GreaterEqualQ[Abs[sampleElectrolyteMoleculeConcentrationInMillimolar - resolvedElectrolyteTargetConcentrationInMillimolar], 10^-1 Millimolar],

								(* If sampleElectrolyteMoleculeConcentrationInMillimolar and resolvedElectrolyteTargetConcentrationInMillimolar are off by at least 0.1 Millimolar, we set this error to True *)
								True,
								False
							],

							(* If the above conditions are not fully met, we can't check this error and set it to False *)
							False
						];

						(* Resolve LoadingSampleElectrolyteAmount *)
						resolvedLoadingSampleElectrolyteAmount = If[MatchQ[resolvedPreparedSample, True],

							(* If resolvedPreparedSample is True, we set Automatic LoadingSampleElectrolyteAmount to Null *)
							loadingSampleElectrolyteAmount /. {Automatic -> Null},

							(* If resolvedPreparedSample is not True, we set Automatic LoadingSampleElectrolyteAmount from ElectrolyteTargetConcentration *)
							If[
								And[
									MatchQ[resolvedSolventVolume, VolumeP],
									MatchQ[resolvedElectrolyteTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
									MatchQ[resolvedElectrolyte, ObjectP[{Model[Sample], Object[Sample]}]],
									MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]]
								],

								loadingSampleElectrolyteAmount /. {Automatic -> getSampleAmount[resolvedSolventVolume, resolvedElectrolyte, resolvedElectrolyteTargetConcentration, resolvedElectrolyteMolecule, Milligram, newCache]},

								(* Otherwise, we set this to Null *)
								loadingSampleElectrolyteAmount /. {Automatic -> Null}
							]
						];

						(* LoadingSampleElectrolyteAmount non-Null error *)
						nonNullLoadingSampleElectrolyteAmountBool = If[
							And[
								MatchQ[resolvedPreparedSample, True],
								!MatchQ[resolvedLoadingSampleElectrolyteAmount, Null]
							],

							(* If resolvedPreparedSample is True and resolvedLoadingSampleElectrolyteAmount is specified, we set this error to True *)
							True,
							False
						];

						(* LoadingSampleElectrolyteAmountBool missing error *)
						missingLoadingSampleElectrolyteAmountBool = If[
							And[
								MatchQ[resolvedPreparedSample, False],
								!MatchQ[resolvedLoadingSampleElectrolyteAmount, MassP],

								(* And some previous possible errors are not encountered *)
								MatchQ[resolvedSolventVolume, VolumeP],
								MatchQ[resolvedElectrolyteTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
								MatchQ[resolvedElectrolyte, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]]
							],
							(* If resolvedPreparedSample is False and resolvedLoadingSampleElectrolyteAmount is set Null, we set this error to True *)
							True,
							False
						];

						(* Check resolvedLoadingSampleElectrolyteAmount agree with the resolvedElectrolyteTargetConcentration *)
						(* First we get the electrolyte concentration from resolvedLoadingSampleElectrolyteAmount *)
						calculatedElectrolyteConcentrationFromLoadingSampleElectrolyteAmount = If[
							And[
								MatchQ[nonNullLoadingSampleElectrolyteAmountBool, False],
								MatchQ[missingLoadingSampleElectrolyteAmountBool, False],
								MatchQ[resolvedSolventVolume, VolumeP],
								MatchQ[resolvedElectrolyte, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedLoadingSampleElectrolyteAmount, MassP],
								MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]]
							],
							getTargetConcentration[resolvedSolventVolume, resolvedElectrolyte, resolvedLoadingSampleElectrolyteAmount, resolvedElectrolyteMolecule, Millimolar, newCache],

							(* If the initial conditions can't be met, we set this to Null *)
							Null
						];

						(* Then we can check the loadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentration error *)
						loadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentrationBool = If[
							And[
								MatchQ[resolvedPreparedSample, False],
								MatchQ[nonNullLoadingSampleElectrolyteAmountBool, False],
								MatchQ[missingLoadingSampleElectrolyteAmountBool, False],
								MatchQ[calculatedElectrolyteConcentrationFromLoadingSampleElectrolyteAmount, ConcentrationP],
								MatchQ[resolvedElectrolyteTargetConcentrationInMillimolar, ConcentrationP]
							],

							(* If the initial conditions are met, we can check this error *)
							If[GreaterEqualQ[Abs[resolvedElectrolyteTargetConcentrationInMillimolar - calculatedElectrolyteConcentrationFromLoadingSampleElectrolyteAmount], 0.3 Millimolar],

								(* If resolvedElectrolyteTargetConcentrationInMillimolar and calculatedElectrolyteConcentrationFromLoadingSampleElectrolyteAmount are off by at least 0.3 Millimolar, we set this error to True *)
								True,
								False
							],

							(* If the initial conditions are not met, we can't check this error and set it to False *)
							False
						];

						(* Finally, we can resolve electrolyte solution *)
						resolvedElectrolyteSolution = If[MatchQ[pretreatElectrodes, False],

							(* If we are not pre-treating electrodes, set Automatic electrolyteSolution to Null *)
							electrolyteSolution /. {Automatic -> Null},

							(* If we are pre-treating electrodes, set Automatic electrolyteSolution to Null as well. *)

							electrolyteSolution /. {Automatic -> Null}
						];

						(* ElectrolyteSolution non-Null error check *)
						nonNullElectrolyteSolutionBool = If[
							And[
								MatchQ[pretreatElectrodes, False],
								!MatchQ[resolvedElectrolyteSolution, Null]
							],

							(* If pretreatElectrode is False and electrolyteSolution is specified, we set this error to True *)
							True,
							False
						];

						(* ElectrolyteSolution missing error check *)
						missingElectrolyteSolutionBool = If[
							And[
								MatchQ[pretreatElectrodes, True],
								!MatchQ[resolvedElectrolyteSolution, ObjectP[{Model[Sample], Object[Sample]}]]
							],

							(* If pretreatElectrode is False and electrolyteSolution is set to Null, we set this error to True *)
							True,
							False
						];

						{
							Association[
								Solvent -> resolvedSolvent,
								Electrolyte -> resolvedElectrolyte,
								ElectrolyteSolution -> resolvedElectrolyteSolution,
								ElectrolyteSolutionLoadingVolume -> resolvedElectrolyteSolutionLoadingVolume,
								LoadingSampleElectrolyteAmount -> resolvedLoadingSampleElectrolyteAmount,
								ElectrolyteTargetConcentration -> resolvedElectrolyteTargetConcentration
							],
							Association[
								(* prepared liquid input sample and prepared electrolyte solution *)
								PreparedSampleMissingSolventBool -> preparedSampleMissingSolventBool,
								SampleSolventAmbiguousMoleculeBool -> sampleSolventAmbiguousMoleculeBool,

								ElectrolyteSolutionNotLiquidBool -> electrolyteSolutionNotLiquidBool,
								ElectrolyteSolutionMissingSolventBool -> electrolyteSolutionMissingSolventBool,
								ElectrolyteSolutionMissingAnalyteBool -> electrolyteSolutionMissingAnalyteBool,
								ElectrolyteSolutionAmbiguousAnalyteBool -> electrolyteSolutionAmbiguousAnalyteBool,
								ElectrolyteSolutionSolventAmbiguousMoleculeBool -> electrolyteSolutionSolventAmbiguousMoleculeBool,

								(* specified solvent *)
								ResolvedSolventNotLiquidBool -> resolvedSolventNotLiquidBool,
								SolventAmbiguousMoleculeBool -> solventAmbiguousMoleculeBool,

								(* Mismatches between prepared liquid input sample, electrolyte solution and specified solvent *)
								SolventMoleculeMismatchPreparedSampleSolventMoleculeBool -> solventMoleculeMismatchPreparedSampleSolventMoleculeBool,
								ElectrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMoleculeBool -> electrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMoleculeBool,
								ElectrolyteSolutionSolventMoleculeMismatchSolventMoleculeBool -> electrolyteSolutionSolventMoleculeMismatchSolventMoleculeBool,

								(* Electrolyte related *)
								SampleElectrolyteMoleculeWithUnresolvableCompositionUnitBool -> sampleElectrolyteMoleculeWithUnresolvableCompositionUnitBool,
								SampleElectrolyteMoleculeMissingMolecularWeightBool -> sampleElectrolyteMoleculeMissingMolecularWeightBool,
								SampleElectrolyteMoleculeMissingDefaultSampleModelBool -> sampleElectrolyteMoleculeMissingDefaultSampleModelBool,
								SampleElectrolyteMoleculeNotFoundBool -> sampleElectrolyteMoleculeNotFoundBool,
								SampleAmbiguousElectrolyteMoleculeBool -> sampleAmbiguousElectrolyteMoleculeBool,
								ElectrolyteSolutionElectrolyteMoleculeMissingDefaultSampleModelBool -> electrolyteSolutionElectrolyteMoleculeMissingDefaultSampleModelBool,
								ElectrolyteSampleAmbiguousMoleculeBool -> electrolyteSampleAmbiguousMoleculeBool,
								ResolvedElectrolyteSampleNotSolidBool -> resolvedElectrolyteSampleNotSolidBool,
								ElectrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool -> electrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool,
								ElectrolyteSolutionElectrolyteMoleculeMissingMolecularWeightBool -> electrolyteSolutionElectrolyteMoleculeMissingMolecularWeightBool,
								ElectrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool -> electrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool,
								CannotAutomaticallyResolveElectrolyteBool -> cannotAutomaticallyResolveElectrolyteBool,
								ElectrolyteSolutionElectrolyteMoleculeNotFoundBool -> electrolyteSolutionElectrolyteMoleculeNotFoundBool,
								ElectrolyteSolutionAmbiguousElectrolyteMoleculeBool -> electrolyteSolutionAmbiguousElectrolyteMoleculeBool,
								ElectrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnitBool -> electrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnitBool,
								ElectrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMoleculeBool -> electrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMoleculeBool,

								(* Electrolyte solution related *)
								NonNullElectrolyteSolutionBool -> nonNullElectrolyteSolutionBool,
								NonNullElectrolyteSolutionLoadingVolumeBool -> nonNullElectrolyteSolutionLoadingVolumeBool,
								NonNullLoadingSampleElectrolyteAmountBool -> nonNullLoadingSampleElectrolyteAmountBool,

								MissingElectrolyteSolutionLoadingVolumeBool -> missingElectrolyteSolutionLoadingVolumeBool,
								MissingElectrolyteTargetConcentrationBool -> missingElectrolyteTargetConcentrationBool,
								MissingLoadingSampleElectrolyteAmountBool -> missingLoadingSampleElectrolyteAmountBool,
								MissingElectrolyteSolutionBool -> missingElectrolyteSolutionBool,

								TooSmallElectrolyteSolutionLoadingVolumeBool -> tooSmallElectrolyteSolutionLoadingVolumeBool,
								TooLargeElectrolyteSolutionLoadingVolumeBool -> tooLargeElectrolyteSolutionLoadingVolumeBool,

								TooLowElectrolyteTargetConcentrationBool -> tooLowElectrolyteTargetConcentrationBool,
								TooHighElectrolyteTargetConcentrationBool -> tooHighElectrolyteTargetConcentrationBool,
								ElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSampleBool -> electrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSampleBool,
								ElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentrationBool -> electrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentrationBool,
								ElectrolyteTargetConcentrationMismatchPreparedSampleBool -> electrolyteTargetConcentrationMismatchPreparedSampleBool,

								LoadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentrationBool -> loadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentrationBool
							],
							Association[
								SolventMismatchPreparedSampleSolventBool -> solventMismatchPreparedSampleSolventBool,
								ElectrolyteSolutionSolventMismatchSolventBool -> electrolyteSolutionSolventMismatchSolventBool
							]
						}
					];

					(* ----------------------------------------------------------- *)
					(* -- Resolve the ReferenceElectrode and ReferenceSolution --  *)
					(* ----------------------------------------------------------- *)
					{referenceElectrodeOptionsAssociation, referenceElectrodeOptionsErrorTrackingAssociation, referenceElectrodeOptionsWarningTrackingAssociation} = Module[
						{
							(* === Error Tracking Booleans === *)
							(* ReferenceElectrode *)
							referenceElectrodeUnpreparedBool,

							(* RefreshReferenceElectrode related *)
							referenceElectrodeNeedRefreshRequiresRefreshBool,

							(* ReferenceSolution related *)
							electrodeReferenceSolutionInformationErrorBool,

							(* ReferenceElectrodeSoakTime related *)
							tooLongReferenceElectrodeSoakTimeBool,

							(* === Warning Tracking Booleans === *)
							(* ReferenceElectrode related *)
							referenceElectrodeRecommendedSolventTypeMismatchSolventBool,

							electrodeReferenceSolutionSolventMoleculeMismatchWarningBool,
							electrodeReferenceSolutionElectrolyteMoleculeMismatchWarningBool,
							electrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatchWarningBool,

							(* === variables === *)
							referenceElectrodeInformation,
							electrodeReferenceSolutionInformation,
							resolvedElectrodeRefreshSolution,

							(* -- Local compatibility tracking booleans -- *)

							(* ReferenceElectrode *)
							referenceElectrodeNeedRefresh,

							(* ReferenceElectrodeReferenceSolution *)
							electrodeReferenceSolutionInformationFetchErrorBool,
							electrodeReferenceSolutionSolventMoleculeMismatch,
							electrodeReferenceSolutionElectrolyteMoleculeMismatch,
							electrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatch
						},

						(* -- Resolve ReferenceElectrode -- *)
						resolvedReferenceElectrode = If[MatchQ[resolvedSolventMolecule, Download[Model[Molecule, "Water"], Object]],

							(* If resolvedSolventMolecule is water, set Automatic ReferenceElectrode to Ag/AgCl RF *)
							referenceElectrode /. {Automatic -> Download[Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"], Object]},

							(* Otherwise, set Automatic ReferenceElectrode to 0.1M AgNO3 Ag/Ag+ RF *)
							referenceElectrode /. {Automatic -> Download[Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"], Object]}
						];

						(* get all information of the resolvedReferenceElectrode using the getReferenceElectrodeInformation helper function *)
						referenceElectrodeInformation = If[
							MatchQ[resolvedReferenceElectrode, ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]],
							getReferenceElectrodeInformation[Download[resolvedReferenceElectrode, Object], newCache],
							Null
						];

						(* If the resolvedReferenceElectrode is an unprepared Bare-Ag electrode, throw an error *)
						referenceElectrodeUnpreparedBool = If[
							And[
								MatchQ[resolvedReferenceElectrode, ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]],
								MatchQ[Lookup[referenceElectrodeInformation, ReferenceElectrodeType], "Bare-Ag"]
							],
							True,
							False
						];

						(* First check if the resolvedSolvent and the resolvedReferenceElectrode's RecommendedSolventType match *)
						referenceElectrodeRecommendedSolventTypeMismatchSolventBool = If[
							And[
								MatchQ[resolvedReferenceElectrode, ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]],
								MatchQ[referenceElectrodeUnpreparedBool, False]
							],

							(* If the reference electrode is specified and the electrode is prepared, we can check this error *)
							If[
								And[
									MatchQ[Lookup[referenceElectrodeInformation, RecommendedSolventType], Alternatives[Aqueous, Organic]],
									MatchQ[resolvedSolventMolecule, ObjectP[Model[Molecule]]]
								],

								(* If the RecommendedSolventType is properly fetched and solventMolecule is properly resolved, we can check this warning *)
								Which[

									(* If resolvedSolventMolecule is water and electrode's RecommendedSolventType is Organic, we set this warning to True *)
									And[
										MatchQ[resolvedSolventMolecule, Download[Model[Molecule, "Water"], Object]],
										MatchQ[Lookup[referenceElectrodeInformation, RecommendedSolventType], Organic]
									],
									True,

									(* If resolvedSolventMolecule is not water and electrode's RecommendedSolventType is Aqueous, we set this warning to True *)
									And[
										!MatchQ[resolvedSolventMolecule, Download[Model[Molecule, "Water"], Object]],
										MatchQ[Lookup[referenceElectrodeInformation, RecommendedSolventType], Aqueous]
									],
									True,

									(* For all the other cases, the reference electrode can be used and we set this warning to False *)
									True,
									False
								],

								(* If the RecommendedSolventType is not properly fetched or solventMolecule is not properly resolved, we set this warning to False *)
								False
							],

							(* If the resolvedReferenceElectrode is not specified or the electrode is not prepared, we do not check this error *)
							False
						];

						(* get default reference solution information *)
						electrodeReferenceSolutionInformation = If[
							MatchQ[resolvedReferenceElectrode, ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]],
							Lookup[referenceElectrodeInformation, ReferenceSolutionInformation],
							Null
						];

						(* set up a electrodeReferenceSolutionInformationFetchErrorBool for later use *)
						electrodeReferenceSolutionInformationFetchErrorBool = If[
							MatchQ[electrodeReferenceSolutionInformation, _?AssociationQ],

							(* If electrodeReferenceSolutionInformation is properly fetched *)
							If[GreaterQ[Length[Lookup[electrodeReferenceSolutionInformation, FetchErrors]], 0],

								(* If FetchErrors is not an empty list, we set this to True *)
								True,

								(* If FetchErrors is an empty list, we set this to False *)
								False
							],

							(* If electrodeReferenceSolutionInformation is Null, we set this to False *)
							False
						];

						(* set up a boolean to see if the reference electrode is "Bare-Ag" type or its solution is over due for refresh. This information is gathered during the electrode information fetching process *)
						referenceElectrodeNeedRefresh = If[
							MatchQ[referenceElectrodeInformation, _?AssociationQ],

							(* If referenceElectrodeInformation is properly fetched, we continue to check the NeedFresh key *)
							Lookup[referenceElectrodeInformation, NeedRefresh],

							(* If referenceElectrodeInformation is not properly fetched, we set this to False *)
							False
						];

						referenceElectrodeNeedRefreshRequiresRefreshBool = If[
							And[
								MatchQ[referenceElectrodeUnpreparedBool, False],
								MatchQ[refreshReferenceElectrode, False],
								MatchQ[referenceElectrodeNeedRefresh, True]
							],

							(* If we are not refreshing reference electrode, but the referenceElectrodeNeedRefresh error is encountered, set this to True *)
							True,
							False
						];

						(* -- electrodeReferenceSolution checks -- *)
						(* Solvent Molecule *)
						electrodeReferenceSolutionSolventMoleculeMismatch = If[
							And[
								MatchQ[electrodeReferenceSolutionInformation, _?AssociationQ],
								MatchQ[electrodeReferenceSolutionInformationFetchErrorBool, False]
							],

							(* If electrodeReferenceSolutionInformation is properly fetched and electrodeReferenceSolutionInformationFetchErrorBool is False, we continue to check the solvent molecule *)
							If[
								And[
									MatchQ[resolvedSolventMolecule, ObjectP[Model[Molecule]]],
									!MatchQ[resolvedSolventMolecule, Lookup[electrodeReferenceSolutionInformation, SolventMolecule]]
								],

								(* If SolventMolecule in the electrodeReferenceSolutionInformation does not match with the resolvedSolventMolecule, we set this to True *)
								True,

								(* If SolventMolecule in the electrodeReferenceSolutionInformation does match with the resolvedSolventMolecule, we set this to False *)
								False
							],

							(* If electrodeReferenceSolutionInformation is not properly fetched or electrodeReferenceSolutionInformationFetchErrorBool is True, we set this to False *)
							False
						];

						(* Electrolyte Molecule *)
						electrodeReferenceSolutionElectrolyteMoleculeMismatch = If[
							And[
								MatchQ[electrodeReferenceSolutionInformation, _?AssociationQ],
								MatchQ[electrodeReferenceSolutionInformationFetchErrorBool, False],
								MatchQ[electrodeReferenceSolutionSolventMoleculeMismatch, False]
							],

							(* If electrodeReferenceSolutionInformation is properly fetched and electrodeReferenceSolutionInformationFetchErrorBool is False, we continue to check the electrolyte molecule *)
							If[
								And[
									MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]],
									!MatchQ[resolvedElectrolyteMolecule, Lookup[electrodeReferenceSolutionInformation, ElectrolyteMolecule]]
								],

								(* If the electrolyte molecule in the electrodeReferenceSolutionInformation does not match with the resolvedElectrolyteMolecule, we set this to True *)
								True,

								(* If the electrolyte molecule in the electrodeReferenceSolutionInformation does match with the resolvedElectrolyteMolecule, we set this to False *)
								False
							],

							(* If electrodeReferenceSolutionInformation is not properly fetched or electrodeReferenceSolutionInformationFetchErrorBool is True, we set this to False *)
							False
						];

						(* Electrolyte Molecule Concentration *)
						electrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatch = If[
							And[
								MatchQ[electrodeReferenceSolutionInformation, _?AssociationQ],
								MatchQ[electrodeReferenceSolutionInformationFetchErrorBool, False],
								MatchQ[electrodeReferenceSolutionSolventMoleculeMismatch, False],
								MatchQ[electrodeReferenceSolutionElectrolyteMoleculeMismatch, False]
							],

							(* If electrodeReferenceSolutionInformation is properly fetched and electrodeReferenceSolutionInformationFetchErrorBool is False, we continue to check the resolvedElectrolyteTargetConcentration *)
							If[
								And[
									MatchQ[resolvedElectrolyteMolecule, ObjectP[Model[Molecule]]],
									MatchQ[resolvedElectrolyteTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
									MatchQ[Lookup[solventAndElectrolyteOptionsErrorTrackingAssociation, TooLowElectrolyteTargetConcentrationBool], False],
									MatchQ[Lookup[solventAndElectrolyteOptionsErrorTrackingAssociation, TooHighElectrolyteTargetConcentrationBool], False],
									MatchQ[Lookup[solventAndElectrolyteOptionsErrorTrackingAssociation,ElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSampleBool], False],
									MatchQ[Lookup[solventAndElectrolyteOptionsErrorTrackingAssociation,ElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentrationBool], False],
									MatchQ[Lookup[solventAndElectrolyteOptionsErrorTrackingAssociation,ElectrolyteTargetConcentrationMismatchPreparedSampleBool], False],

									(* Check if concentrations match with each other *)
									Not[
										Module[{tmpMolecule, tmpConcentration},
											tmpMolecule = Lookup[electrodeReferenceSolutionInformation, ElectrolyteMolecule];
											tmpConcentration = Lookup[electrodeReferenceSolutionInformation, ElectrolyteMoleculeConcentration];
											concentrationMatchQ[resolvedElectrolyteTargetConcentration, tmpConcentration, tmpMolecule, newCache]
										]
									]
								],

								(* If the electrolyte molecule concentration in the electrodeReferenceSolutionInformation does not match with the resolvedElectrolyteTargetConcentration, we set this to True *)
								True,

								(* If the electrolyte molecule concentration in the electrodeReferenceSolutionInformation does match with the resolvedElectrolyteTargetConcentration, we set this to True *)
								False
							],

							(* If electrodeReferenceSolutionInformation is not properly fetched or electrodeReferenceSolutionInformationFetchErrorBool is True, we set this to False *)
							False
						];

						(* 1. Check if any error was encountered when fetching electrodeDefaultSolutionInformation *)
						electrodeReferenceSolutionInformationErrorBool = If[
							And[
								MatchQ[electrodeReferenceSolutionInformation, _?AssociationQ],
								MatchQ[electrodeReferenceSolutionInformationFetchErrorBool, True]
							],

							True,
							False
						];

						(* 2. Check if electrodeReferenceSolution is used for refreshing and the electrodeReferenceSolution matches with the resolvedSolventMolecule *)
						electrodeReferenceSolutionSolventMoleculeMismatchWarningBool = If[
							And[
								MatchQ[electrodeReferenceSolutionInformation, _?AssociationQ],
								MatchQ[electrodeReferenceSolutionInformationFetchErrorBool, False],
								MatchQ[electrodeReferenceSolutionSolventMoleculeMismatch, True]
							],

							True,
							False
						];

						(* 3. Check if electrodeReferenceSolution is used for refreshing and the electrodeReferenceSolution matches with the resolvedElectrolyteMolecule *)
						electrodeReferenceSolutionElectrolyteMoleculeMismatchWarningBool = If[
							And[
								MatchQ[electrodeReferenceSolutionInformation, _?AssociationQ],
								MatchQ[electrodeReferenceSolutionInformationFetchErrorBool, False],
								MatchQ[electrodeReferenceSolutionElectrolyteMoleculeMismatch, True]
							],

							True,
							False
						];

						(* 4. Check if electrodeReferenceSolution is used for refreshing and the electrodeReferenceSolution matches with the resolvedElectrolyteMoleculeConcentration *)
						electrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatchWarningBool = If[
							And[
								MatchQ[electrodeReferenceSolutionInformation, _?AssociationQ],
								MatchQ[electrodeReferenceSolutionInformationFetchErrorBool, False],
								MatchQ[electrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatch, True]
							],

							True,
							False
						];

						(* -- Check if ReferenceElectrodeSoakTime is longer than 15 Minute -- *)
						tooLongReferenceElectrodeSoakTimeBool = If[
							GreaterQ[referenceElectrodeSoakTime, 15 Minute],

							(* If the ReferenceElectrodeSoakTime is longer than 15 Minute, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						{
							Association[
								ReferenceElectrode -> resolvedReferenceElectrode
							],
							Association[
								ReferenceElectrodeUnpreparedBool -> referenceElectrodeUnpreparedBool,
								ReferenceElectrodeNeedRefreshRequiresRefreshBool -> referenceElectrodeNeedRefreshRequiresRefreshBool,
								ElectrodeReferenceSolutionInformationErrorBool -> electrodeReferenceSolutionInformationErrorBool,
								TooLongReferenceElectrodeSoakTimeBool -> tooLongReferenceElectrodeSoakTimeBool
							],
							Association[
								ReferenceElectrodeRecommendedSolventTypeMismatchSolventBool -> referenceElectrodeRecommendedSolventTypeMismatchSolventBool,
								ElectrodeReferenceSolutionSolventMoleculeMismatchWarningBool -> electrodeReferenceSolutionSolventMoleculeMismatchWarningBool,
								ElectrodeReferenceSolutionElectrolyteMoleculeMismatchWarningBool -> electrodeReferenceSolutionElectrolyteMoleculeMismatchWarningBool,
								ElectrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatchWarningBool -> electrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatchWarningBool
							]
						}
					];

					(* --------------------------------------- *)
					(* -- Resolve InternalStandard options --  *)
					(* --------------------------------------- *)
					{internalStandardOptionsAssociation, internalStandardOptionsErrorTrackingAssociation} = Module[
						{
							(* Error tracking booleans *)
							internalStandardNotSolidBool,
							preparedSampleInvalidCompositionLengthForNoneInternalStandardBool,
							resolvedInternalStandardAmbiguousMoleculeBool,
							nonNullInternalStandardAdditionOrderBool,
							missingInternalStandardAdditionOrderBool,
							preparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrderBool,
							preparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrderBool,
							internalStandardNotACompositionMemberForPreparedSampleBool,
							internalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrderBool,
							nonNullInternalStandardTargetConcentrationForNoneInternalStandardBool,
							nonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSampleBool,
							missingInternalStandardTargetConcentrationForAfterAdditionOrderBool,
							missingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSampleBool,
							tooLowInternalStandardTargetConcentrationBool,
							tooHighInternalStandardTargetConcentrationBool,
							nonNullInternalStandardAmountForNoneInternalStandardBool,
							nonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSampleBool,
							missingInternalStandardAmountForAfterAdditionOrderBool,
							missingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSampleBool,
							internalStandardAmountMismatchInternalStandardTargetConcentrationBool,

							(* Local variables *)
							internalStandardAdditionOrderCompatibleVolume
						},

						(* -- InternalStandard Checks -- *)
						sampleCompositionMolecules = (sampleComposition[[All, 2]] /. {Null -> Nothing}) /. x:ObjectP[] :> Download[x, Object];

						(* InternalStandard must be a solid *)
						internalStandardNotSolidBool = If[
							MatchQ[internalStandard, ObjectP[{Model[Sample], Object[Sample]}]],

							(* If InternalStandard is specified, we check if it's State is Solid *)
							If[!MatchQ[Lookup[fetchPacketFromCache[internalStandard, newCache], State], Solid],

								(* If the specified internalStandard is not a solid, we set this error to True *)
								True,

								(* Otherwise, we set this to False *)
								False
							],

							(* If InternalStandard is None, we don't check this error *)
							False
						];

						(* If resolvedPreparedSample is True, InternalStandard is None, the sample should have 3 molecules *)
						preparedSampleInvalidCompositionLengthForNoneInternalStandardBool = If[
							And[
								MatchQ[resolvedPreparedSample, True],
								MatchQ[internalStandard, None],
								MatchQ[Lookup[analyteOptionsErrorTrackingAssociation, PreparedSampleIncompleteCompositionBool], False],
								GreaterQ[Length[sampleCompositionMolecules], 3]
							],

							(* If the preparedSample has more than 3 molecules, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* get the internalStandard Object *)
						resolvedInternalStandard = If[MatchQ[internalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
							Download[internalStandard, Object],

							(* If internalStandard is set to None, we set this to None as well *)
							None
						];

						(* If none of the errors above was encountered, we can set the resolvedInternalStandardMolecule *)
						{resolvedInternalStandardMolecule, resolvedInternalStandardAmbiguousMoleculeBool} = If[
							And[
								MatchQ[resolvedInternalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[internalStandardNotSolidBool, False],
								MatchQ[preparedSampleInvalidCompositionLengthForNoneInternalStandardBool, False]
							],

							getSampleMolecule[resolvedInternalStandard, newCache],

							(* If the conditions are not met, we set resolvedInternalStandardMolecule to Null and the ambiguous molecule error to False *)
							{Null, False}
						];

						(* get the resolvedInternalStandardMoleculeMolecularWeight *)
						resolvedInternalStandardMoleculeMolecularWeight = If[
							MatchQ[resolvedInternalStandardMolecule, ObjectP[Model[Molecule]]],

							Lookup[fetchPacketFromCache[resolvedInternalStandardMolecule, newCache], MolecularWeight],

							Null
						];

						(* -- Resolve InternalStandardAdditionOrder -- *)
						(* 1. If InternalStandard is None, set Automatic InternalStandardAdditionOrder to Null *)
						(* 2. If InternalStandard is not None: *)
						(* i. If resolvedPreparedSample is True, and the sample have 3 molecules, set Automatic InternalStandardAdditionOrder to After *)
						(* ii. If resolvedPreparedSample is True, and the sample have 4 molecules, set Automatic InternalStandardAdditionOrder to Before *)
						(* iii. If resolvedPreparedSample is False, set Automatic InternalStandardAdditionOrder to After *)

						resolvedInternalStandardAdditionOrder = If[MatchQ[internalStandard, None],

							(* If internalStandard is None, set Automatic InternalStandardAdditionOrder to Null *)
							internalStandardAdditionOrder /. {Automatic -> Null},

							(* If internalStandard is not None, we continue to check resolvedPreparedSample *)
							If[MatchQ[resolvedPreparedSample, True],

								(* If the input sample is a prepared liquid, check if resolvedInternalStandardMolecule is a member of sampleCompositionMolecules. If so, we set Automatic InternalStandardAdditionOrder to Before. Otherwise, set Automatic InternalStandardAdditionOrder to After. *)

								If[
									And[
										MatchQ[resolvedInternalStandardMolecule, ObjectP[Model[Molecule]]],
										MemberQ[sampleCompositionMolecules, resolvedInternalStandardMolecule]
									],

									(* If resolvedInternalStandardMolecule is a member of sampleCompositionMolecules, we set Automatic InternalStandardAdditionOrder to Before. *)
									internalStandardAdditionOrder /. {Automatic -> Before},

									(* Otherwise, we set Automatic InternalStandardAdditionOrder to After. *)
									internalStandardAdditionOrder /. {Automatic -> After}
								],

								(* If the input sample is an unprepared solid, set Automatic InternalStandardAdditionOrder to After *)
								internalStandardAdditionOrder /. {Automatic -> After}
							]
						];

						(* Check if resolvedInternalStandardAdditionOrder is not Null when InternalStandard is None *)
						nonNullInternalStandardAdditionOrderBool = If[
							MatchQ[internalStandard, None] && !MatchQ[resolvedInternalStandardAdditionOrder, Null],

							(* If resolvedInternalStandardAdditionOrder is not Null when InternalStandard is None, we set this error to True *)
							True,

							(* Otherwise, we set this to False *)
							False
						];

						(* Check if resolvedInternalStandardAdditionOrder is Null when InternalStandard is not None *)
						missingInternalStandardAdditionOrderBool = If[
							MatchQ[internalStandard, ObjectP[{Model[Sample], Object[Sample]}]] && !MatchQ[resolvedInternalStandardAdditionOrder, Alternatives[Before, After]],

							(* If resolvedInternalStandardAdditionOrder is set to Null when InternalStandard is not None, we set this error to True *)
							True,

							(* Otherwise, we set this to False *)
							False
						];

						(* If resolvedPreparedSample is True, InternalStandard is ObjectP[{Model[Sample], Object[Sample]}], and AdditionOrder is After, the sample should have 3 molecules *)
						preparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrderBool = If[
							And[
								MatchQ[nonNullInternalStandardAdditionOrderBool, False],
								MatchQ[missingInternalStandardAdditionOrderBool, False],
								MatchQ[resolvedPreparedSample, True],
								MatchQ[Lookup[analyteOptionsErrorTrackingAssociation, PreparedSampleIncompleteCompositionBool], False],
								MatchQ[internalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedInternalStandardAdditionOrder, After],
								!MatchQ[Length[sampleCompositionMolecules], 3]
							],

							(* If resolvedPreparedSample is True, InternalStandard is ObjectP[{Model[Sample], Object[Sample]}], and AdditionOrder is After, but the input sample doesn't have 3 molecules, we set this error to True *)
							True,

							(* Otherwise we set this error to True *)
							False
						];

						(* If resolvedPreparedSample is True, InternalStandard is ObjectP[{Model[Sample], Object[Sample]}], and AdditionOrder is Before, the sample should have 4 molecules *)
						preparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrderBool = If[
							And[
								MatchQ[nonNullInternalStandardAdditionOrderBool, False],
								MatchQ[missingInternalStandardAdditionOrderBool, False],
								MatchQ[resolvedPreparedSample, True],
								MatchQ[Lookup[analyteOptionsErrorTrackingAssociation, PreparedSampleIncompleteCompositionBool], False],
								MatchQ[internalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedInternalStandardAdditionOrder, Before],
								!MatchQ[Length[sampleCompositionMolecules], 4]
							],

							(* If resolvedPreparedSample is True, InternalStandard is ObjectP[{Model[Sample], Object[Sample]}], and AdditionOrder is Before: *)
							Which[

								(* If the analyte and the internal standard is the same, set this error to True if the sample composition length is not 3 *)
								And[
									MatchQ[resolvedAnalyte, resolvedInternalStandardMolecule],
									!MatchQ[Length[sampleCompositionMolecules], 3]
								],
								True,

								(* If the analyte and the internal standard is not the same, set this error to True if the sample composition length is not 4 *)
								And[
									!MatchQ[resolvedAnalyte, resolvedInternalStandardMolecule],
									!MatchQ[Length[sampleCompositionMolecules], 4]
								],
								True,

								(* For other cases, set this error to False *)
								True,
								False
							],

							(* Otherwise we set this error to True *)
							False
						];

						(* If resolvedPreparedSample is True, InternalStandard is ObjectP[{Model[Sample], Object[Sample]}], and AdditionOrder is Before, InternalStandard must be a member of the sample molecules *)
						internalStandardNotACompositionMemberForPreparedSampleBool = If[
							And[
								MatchQ[nonNullInternalStandardAdditionOrderBool, False],
								MatchQ[missingInternalStandardAdditionOrderBool, False],
								MatchQ[preparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrderBool, False],
								MatchQ[resolvedPreparedSample, True],
								MatchQ[Lookup[analyteOptionsErrorTrackingAssociation, PreparedSampleIncompleteCompositionBool], False],
								MatchQ[internalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedInternalStandardMolecule, ObjectP[Model[Molecule]]],
								MatchQ[resolvedInternalStandardAdditionOrder, Before],
								!MemberQ[sampleCompositionMolecules, resolvedInternalStandardMolecule]
							],

							(* If resolvedPreparedSample is True, InternalStandard is ObjectP[{Model[Sample], Object[Sample]}], and AdditionOrder is Before, but internalStandard is not a member of the sample composition, we set this error to True *)
							True,

							(* Otherwise we set this error to True *)
							False
						];

						(* If resolvedPreparedSample is True, InternalStandard is ObjectP[{Model[Sample], Object[Sample]}], InternalStandard is already a member of the sample molecules, AdditionOrder must be Before *)
						internalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrderBool = If[
							And[
								MatchQ[resolvedPreparedSample, True],
								MatchQ[nonNullInternalStandardAdditionOrderBool, False],
								MatchQ[missingInternalStandardAdditionOrderBool, False],
								MatchQ[preparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrderBool, False],
								MatchQ[Lookup[analyteOptionsErrorTrackingAssociation, PreparedSampleIncompleteCompositionBool], False],
								MatchQ[internalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedInternalStandardMolecule, ObjectP[Model[Molecule]]],
								MatchQ[resolvedInternalStandardAdditionOrder, After],
								MemberQ[sampleCompositionMolecules, resolvedInternalStandardMolecule]
							],

							True,
							False
						];

						(* -- Resolve InternalStandardTargetConcentration -- *)
						resolvedInternalStandardTargetConcentration = If[
							MatchQ[resolvedInternalStandard, ObjectP[{Model[Sample], Object[Sample]}]],

							(* If internalStandard is specified, we continue to check resolvedInternalStandardAdditionOrder *)
							If[MatchQ[resolvedInternalStandardAdditionOrder, Before],

								(* If resolvedInternalStandardAdditionOrder is Before (use the solventVolume to calculate the concentration), we continue to check resolvedPreparedSample *)
								If[MatchQ[resolvedPreparedSample, True],

									(* For prepared sample with with addition order to Before, we set Automatic InternalStandardTargetConcentration to Null *)
									internalStandardTargetConcentration /. {Automatic -> Null},

									(* For unprepared sample, we continue to check internalStandardAmount *)
									If[
										And[
											MatchQ[internalStandardAmount, MassP],
											MatchQ[resolvedSolventVolume, VolumeP],
											MatchQ[resolvedInternalStandardMolecule, ObjectP[Model[Molecule]]]
										],

										(* If internalStandardAmount is specified, we set Automatic InternalStandardTargetConcentration according to internalStandardAmount *)
										internalStandardTargetConcentration /. {Automatic -> getTargetConcentration[resolvedSolventVolume, resolvedInternalStandard, internalStandardAmount, resolvedInternalStandardMolecule, Millimolar, newCache]},

										(* If internalStandardAmount is Automatic, we set Automatic InternalStandardTargetConcentration to 10 Millimolar *)
										internalStandardTargetConcentration /. {Automatic -> 10 Millimolar}
									]
								],

								(* If resolvedInternalStandardAdditionOrder is After (use the loadingSampleVolume to calculate the concentration), we continue to check internalStandardAmount *)
								If[
									And[
										MatchQ[internalStandardAmount, MassP],
										MatchQ[resolvedLoadingSampleVolume, VolumeP],
										MatchQ[resolvedInternalStandardMolecule, ObjectP[Model[Molecule]]]
									],

									(* If internalStandardAmount is specified, we set Automatic InternalStandardTargetConcentration according to internalStandardAmount *)
									internalStandardTargetConcentration /. {Automatic -> getTargetConcentration[resolvedLoadingSampleVolume, resolvedInternalStandard, internalStandardAmount, resolvedInternalStandardMolecule, Millimolar, newCache]},

									(* If internalStandardAmount is Automatic, we set Automatic InternalStandardTargetConcentration to 10 Millimolar *)
									internalStandardTargetConcentration /. {Automatic -> 10 Millimolar}
								]
							],

							(* If internalStandard is None, we set Automatic InternalStandardTargetConcentration to Null *)
							internalStandardTargetConcentration /. {Automatic -> Null}
						];

						(* get resolvedInternalStandardTargetConcentration in Millimolar *)
						resolvedInternalStandardTargetConcentrationInMillimolar = If[
							And[
								MatchQ[resolvedInternalStandardTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
								MatchQ[resolvedInternalStandardMoleculeMolecularWeight, MolecularWeightP]
							],

							(* If resolvedInternalStandardTargetConcentration is already in molar units *)
							If[MatchQ[resolvedInternalStandardTargetConcentration, ConcentrationP],
								SafeRound[UnitConvert[resolvedInternalStandardTargetConcentration, Millimolar], 10^-1 Millimolar],

								(* If resolvedInternalStandardTargetConcentration is in mass concentration units *)
								SafeRound[UnitConvert[resolvedInternalStandardTargetConcentration / resolvedInternalStandardMoleculeMolecularWeight, Millimolar], 10^-1 Millimolar]
							],

							(* If the initial conditions are not met, we set this to Null *)
							Null
						];

						(* nonNullInternalStandardTargetConcentrationForNoneInternalStandard *)
						nonNullInternalStandardTargetConcentrationForNoneInternalStandardBool = If[
							And[
								MatchQ[resolvedInternalStandard, None],
								!MatchQ[resolvedInternalStandardTargetConcentration, Null]
							],

							(* If resolvedInternalStandardTargetConcentration is not Null when resolvedInternalStandard is None, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* nonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSample *)
						nonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSampleBool = If[
							And[
								MatchQ[resolvedInternalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedPreparedSample, True],
								MatchQ[resolvedInternalStandardAdditionOrder, Before],
								!MatchQ[resolvedInternalStandardTargetConcentration, Null]
							],

							(* If resolvedInternalStandardTargetConcentration is not Null when resolvedPreparedSample is True and resolvedInternalStandardAdditionOrder is Before, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingInternalStandardTargetConcentrationForAfterAdditionOrder *)
						missingInternalStandardTargetConcentrationForAfterAdditionOrderBool = If[
							And[
								MatchQ[resolvedInternalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedInternalStandardAdditionOrder, After],
								!MatchQ[resolvedInternalStandardTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]]
							],

							(* If resolvedInternalStandardTargetConcentration is set to Null when resolvedInternalStandardAdditionOrder is After, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSample *)
						missingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSampleBool = If[
							And[
								MatchQ[resolvedInternalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedPreparedSample, False],
								MatchQ[resolvedInternalStandardAdditionOrder, Before],
								!MatchQ[resolvedInternalStandardTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]]
							],

							(* If resolvedInternalStandardTargetConcentration is set to Null when resolvedPreparedSample is False and resolvedInternalStandardAdditionOrder is Before, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* Check if we need to throw the tooLowInternalStandardTargetConcentration error *)
						(* The resolvedInternalStandardTargetConcentration should be between 1 Millimolar and 15 Millimolar *)
						tooLowInternalStandardTargetConcentrationBool = If[
							And[
								MatchQ[nonNullInternalStandardTargetConcentrationForNoneInternalStandardBool, False],
								MatchQ[nonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSampleBool, False],
								MatchQ[resolvedInternalStandardTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
								MatchQ[resolvedInternalStandardMolecule, ObjectP[Model[Molecule]]],
								MatchQ[resolvedInternalStandardMoleculeMolecularWeight, MolecularWeightP],
								Or[
									LessQ[resolvedInternalStandardTargetConcentration, 1 Millimolar],
									LessQ[resolvedInternalStandardTargetConcentration, SafeRound[UnitConvert[1 Millimolar * resolvedInternalStandardMoleculeMolecularWeight, Milligram/Milliliter], 10^-1 Milligram/Liter]]
								]
							],
							True,
							False
						];

						(* Check if we need to throw the tooHighInternalStandardTargetConcentration error *)
						(* The resolvedInternalStandardTargetConcentration should be between 1 Millimolar and 15 Millimolar *)
						tooHighInternalStandardTargetConcentrationBool = If[
							And[
								MatchQ[nonNullInternalStandardTargetConcentrationForNoneInternalStandardBool, False],
								MatchQ[nonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSampleBool, False],
								MatchQ[resolvedInternalStandardTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
								MatchQ[resolvedInternalStandardMolecule, ObjectP[Model[Molecule]]],
								MatchQ[resolvedInternalStandardMoleculeMolecularWeight, MolecularWeightP],
								Or[
									GreaterQ[resolvedInternalStandardTargetConcentration, 15 Millimolar],
									GreaterQ[resolvedInternalStandardTargetConcentration, SafeRound[UnitConvert[15 Millimolar * resolvedInternalStandardMoleculeMolecularWeight, Milligram/Milliliter], 10^-1 Milligram/Liter]]
								]
							],
							True,
							False
						];


						(* -- Resolve InternalStandardAmount -- *)
						resolvedInternalStandardAmount = If[
							MatchQ[resolvedInternalStandard, ObjectP[{Model[Sample], Object[Sample]}]],

							(* If internalStandard is specified, we continue to check resolvedInternalStandardAdditionOrder *)
							If[MatchQ[resolvedInternalStandardAdditionOrder, Before],

								(* If resolvedInternalStandardAdditionOrder is Before (use the solventVolume to calculate the amount), we continue to check resolvedPreparedSample *)
								If[MatchQ[resolvedPreparedSample, True],

									(* For prepared sample with with addition order to Before, we set Automatic InternalStandardAmount to Null *)
									internalStandardAmount /. {Automatic -> Null},

									(* For unprepared sample, we continue to check resolved *)
									If[
										And[
											MatchQ[resolvedInternalStandardTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
											MatchQ[resolvedSolventVolume, VolumeP],
											MatchQ[resolvedInternalStandardMolecule, ObjectP[Model[Molecule]]]
										],

										(* If resolvedInternalStandardTargetConcentration is specified, we set Automatic internalStandardAmount according to resolvedInternalStandardTargetConcentration *)
										internalStandardAmount /. {Automatic -> getSampleAmount[resolvedSolventVolume, resolvedInternalStandard, resolvedInternalStandardTargetConcentration, resolvedInternalStandardMolecule, Milligram, newCache]},

										(* If resolvedInternalStandardTargetConcentration is Null (which should not happen and will be caught by errors above), we set Automatic InternalStandardAmount to Null *)
										internalStandardAmount /. {Automatic -> Null}
									]
								],

								(* If resolvedInternalStandardAdditionOrder is After (use the loadingSampleVolume to calculate the amount), we continue to check internalStandardAmount *)
								If[
									And[
										MatchQ[resolvedInternalStandardTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
										MatchQ[resolvedLoadingSampleVolume, VolumeP],
										MatchQ[resolvedInternalStandardMolecule, ObjectP[Model[Molecule]]]
									],

									(* If resolvedInternalStandardTargetConcentration is specified, we set Automatic internalStandardAmount according to resolvedInternalStandardTargetConcentration *)
									internalStandardAmount /. {Automatic -> getSampleAmount[resolvedLoadingSampleVolume, resolvedInternalStandard, resolvedInternalStandardTargetConcentration, resolvedInternalStandardMolecule, Milligram, newCache]},

									(* If resolvedInternalStandardTargetConcentration is Null (which should not happen and will be caught by errors above), we set Automatic InternalStandardAmount to Null *)
									internalStandardAmount /. {Automatic -> Null}
								]
							],

							(* If internalStandard is None, we set Automatic InternalStandardAmount to Null *)
							internalStandardAmount /. {Automatic -> Null}
						];

						(* nonNullInternalStandardAmountForNoneInternalStandard *)
						nonNullInternalStandardAmountForNoneInternalStandardBool = If[
							And[
								MatchQ[resolvedInternalStandard, None],
								!MatchQ[resolvedInternalStandardAmount, Null]
							],

							(* If resolvedInternalStandardAmount is not Null when resolvedInternalStandard is None, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* nonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSample *)
						nonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSampleBool = If[
							And[
								MatchQ[resolvedInternalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedPreparedSample, True],
								MatchQ[resolvedInternalStandardAdditionOrder, Before],
								!MatchQ[resolvedInternalStandardAmount, Null]
							],

							(* If resolvedInternalStandardAmount is not Null when resolvedPreparedSample is True and resolvedInternalStandardAdditionOrder is Before, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingInternalStandardAmountForAfterAdditionOrder *)
						missingInternalStandardAmountForAfterAdditionOrderBool = If[
							And[
								MatchQ[resolvedInternalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[internalStandardNotSolidBool, False],
								MatchQ[resolvedInternalStandardAdditionOrder, After],
								MatchQ[missingInternalStandardTargetConcentrationForAfterAdditionOrderBool, False],
								!MatchQ[resolvedInternalStandardAmount, MassP]
							],

							(* If resolvedInternalStandardAmount is set to Null when resolvedInternalStandardAdditionOrder is After, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSample *)
						missingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSampleBool = If[
							And[
								MatchQ[resolvedInternalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedPreparedSample, False],
								MatchQ[resolvedInternalStandardAdditionOrder, Before],
								MatchQ[missingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSampleBool, False],
								!MatchQ[resolvedInternalStandardAmount, MassP]
							],

							(* If resolvedInternalStandardAmount is set to Null when resolvedPreparedSample is False and resolvedInternalStandardAdditionOrder is Before, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* We will further check resolvedInternalStandardAmount matches with the resolvedInternalStandardTargetConcentration *)

						(* We need to set up a variable called internalStandardAdditionOrderCompatibleVolume to use for this check, depending on the resolvedInternalStandardAdditionOrder *)
						internalStandardAdditionOrderCompatibleVolume = If[MatchQ[resolvedInternalStandardAdditionOrder, Before],

							(* If we are adding the internal standard before the experiment, internalStandardAdditionOrderCompatibleVolume is resolvedSolventVolume *)
							resolvedSolventVolume,

							(* If we are adding the internal standard after the experiment, internalStandardAdditionOrderCompatibleVolume is resolvedLoadingSampleVolume *)
							resolvedLoadingSampleVolume
						];

						internalStandardAmountMismatchInternalStandardTargetConcentrationBool = If[
							And[
								(* Error tracking boolean checks *)
								MatchQ[nonNullInternalStandardTargetConcentrationForNoneInternalStandardBool, False],
								MatchQ[nonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSampleBool, False],
								MatchQ[missingInternalStandardTargetConcentrationForAfterAdditionOrderBool, False],
								MatchQ[missingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSampleBool, False],
								MatchQ[tooLowInternalStandardTargetConcentrationBool, False],
								MatchQ[tooHighInternalStandardTargetConcentrationBool, False],
								MatchQ[nonNullInternalStandardAmountForNoneInternalStandardBool, False],
								MatchQ[nonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSampleBool, False],
								MatchQ[missingInternalStandardAmountForAfterAdditionOrderBool, False],
								MatchQ[missingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSampleBool, False],

								(* Variable checks *)
								MatchQ[resolvedInternalStandard, ObjectP[{Model[Sample], Object[Sample]}]],
								MatchQ[resolvedInternalStandardMolecule, ObjectP[Model[Molecule]]],
								MatchQ[resolvedInternalStandardMoleculeMolecularWeight, MolecularWeightP],
								MatchQ[resolvedInternalStandardTargetConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
								MatchQ[resolvedInternalStandardAmount, MassP],
								MatchQ[internalStandardAdditionOrderCompatibleVolume, VolumeP]
							],

							(* If the initial conditions are met, we can check this error using the concentrationMatchQ and getTargetConcentration helper functions *)
							If[
								Not[
									concentrationMatchQ[
										resolvedInternalStandardTargetConcentration,
										getTargetConcentration[internalStandardAdditionOrderCompatibleVolume, resolvedInternalStandard, internalStandardAmount, resolvedInternalStandardMolecule, Millimolar, newCache],
										resolvedInternalStandardMolecule,
										newCache
									]
								],

								(* If they do not match with each other, we set this error to True *)
								True,
								False
							],

							(* If the initial conditions are not met, we can't check this error and set it to False *)
							False
						];

						{
							Association[
								InternalStandard -> resolvedInternalStandard,
								InternalStandardAdditionOrder -> resolvedInternalStandardAdditionOrder,
								InternalStandardAmount -> resolvedInternalStandardAmount,
								InternalStandardTargetConcentration -> resolvedInternalStandardTargetConcentration
							],
							Association[
								InternalStandardNotSolidBool -> internalStandardNotSolidBool,
								PreparedSampleInvalidCompositionLengthForNoneInternalStandardBool -> preparedSampleInvalidCompositionLengthForNoneInternalStandardBool,
								ResolvedInternalStandardAmbiguousMoleculeBool -> resolvedInternalStandardAmbiguousMoleculeBool,
								NonNullInternalStandardAdditionOrderBool -> nonNullInternalStandardAdditionOrderBool,
								MissingInternalStandardAdditionOrderBool -> missingInternalStandardAdditionOrderBool,
								PreparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrderBool -> preparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrderBool,
								PreparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrderBool -> preparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrderBool,
								InternalStandardNotACompositionMemberForPreparedSampleBool -> internalStandardNotACompositionMemberForPreparedSampleBool,
								InternalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrderBool -> internalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrderBool,
								NonNullInternalStandardTargetConcentrationForNoneInternalStandardBool -> nonNullInternalStandardTargetConcentrationForNoneInternalStandardBool,
								NonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSampleBool -> nonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSampleBool,
								MissingInternalStandardTargetConcentrationForAfterAdditionOrderBool -> missingInternalStandardTargetConcentrationForAfterAdditionOrderBool,
								MissingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSampleBool -> missingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSampleBool,
								TooLowInternalStandardTargetConcentrationBool -> tooLowInternalStandardTargetConcentrationBool,
								TooHighInternalStandardTargetConcentrationBool -> tooHighInternalStandardTargetConcentrationBool,
								NonNullInternalStandardAmountForNoneInternalStandardBool -> nonNullInternalStandardAmountForNoneInternalStandardBool,
								NonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSampleBool -> nonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSampleBool,
								MissingInternalStandardAmountForAfterAdditionOrderBool -> missingInternalStandardAmountForAfterAdditionOrderBool,
								MissingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSampleBool -> missingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSampleBool,
								InternalStandardAmountMismatchInternalStandardTargetConcentrationBool -> internalStandardAmountMismatchInternalStandardTargetConcentrationBool
							]
						}
					];

					(* ----------------------------------------- *)
					(* -- Resolve PretreatElectrodes options --  *)
					(* ----------------------------------------- *)
					{pretreatElectrodesOptionsAssociation, pretreatElectrodesOptionsErrorTrackingAssociation} = Module[
						{
							(* Error tracking booleans *)
							nonNullPretreatmentSpargingBool,
							missingPretreatmentSpargingBool,
							nonNullPretreatmentSpargingPreBubblerBool,
							missingPretreatmentSpargingPreBubblerBool,
							pretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSpargingBool,
							nonNullPretreatmentInitialPotentialBool,
							missingPretreatmentInitialPotentialBool,
							nonNullPretreatmentFirstPotentialBool,
							missingPretreatmentFirstPotentialBool,
							nonNullPretreatmentSecondPotentialBool,
							missingPretreatmentSecondPotentialBool,
							nonNullPretreatmentFinalPotentialBool,
							missingPretreatmentFinalPotentialBool,
							pretreatmentInitialPotentialNotBetweenFirstAndSecondPotentialsBool,
							pretreatmentFinalPotentialNotBetweenFirstAndSecondPotentialsBool,
							pretreatmentInitialAndFinalPotentialsTooDifferentBool,
							nonNullPretreatmentPotentialSweepRateBool,
							missingPretreatmentPotentialSweepRateBool,
							nonNullPretreatmentNumberOfCyclesBool,
							missingPretreatmentNumberOfCyclesBool
						},

						(* -- Resolve PretreatmentSparging -- *)
						resolvedPretreatmentSparging = If[MatchQ[pretreatElectrodes, False],

							(* If we are not pre-treating electrodes, we set Automatic PretreatmentSparging to Null *)
							pretreatmentSparging /. {Automatic -> Null},

							(* If we are pre-treating electrodes, we set Automatic PretreatmentSparging to True *)
							pretreatmentSparging /. {Automatic -> True}
						];

						(* If we are not pre-treating the electrodes, but resolvedPretreatmentSparging is not Null, we have the nonNullPretreatmentSpargingBool error *)
						nonNullPretreatmentSpargingBool = If[
							MatchQ[pretreatElectrodes, False] && !MatchQ[resolvedPretreatmentSparging, Null],

							(* If we have non-Null resolvedPretreatmentSparging when pretreatElectrode is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If we are pre-treating the electrodes, but resolvedPretreatmentSparging is set to Null, we have the missingPretreatmentSpargingBool error *)
						missingPretreatmentSpargingBool = If[
							MatchQ[pretreatElectrodes, True] && !MatchQ[resolvedPretreatmentSparging, BooleanP],

							(* If we have Null resolvedPretreatmentSparging when pretreatElectrode is True, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve PretreatmentSpargingPreBubbler -- *)
						resolvedPretreatmentSpargingPreBubbler = Which[
							And[
								MatchQ[pretreatElectrodes, False],
								MatchQ[resolvedPretreatmentSparging, Null]
							],

							(* If we are not doing pretreatment sparging, we set Automatic PretreatmentSpargingPreBubbler to Null *)
							pretreatmentSpargingPreBubbler /. {Automatic -> Null},

							And[
								MatchQ[pretreatElectrodes, True],
								MatchQ[resolvedPretreatmentSparging, False]
							],
							(* If we are doing pretreatment but not pretreatmentSparging, we set Automatic PretreatmentSpargingPreBubbler to False *)
							pretreatmentSpargingPreBubbler /. {Automatic -> False},

							And[
								MatchQ[pretreatElectrodes, True],
								MatchQ[resolvedPretreatmentSparging, True]
							],
							(* If we are doing pretreatment sparging, we set Automatic PretreatmentSpargingPreBubbler to True *)
							pretreatmentSpargingPreBubbler /. {Automatic -> True}
						];

						(* If we are not pre-treating the electrodes, but resolvedPretreatmentSpargingPreBubbler is not Null, we have the nonNullPretreatmentSpargingPreBubblerBool error *)
						nonNullPretreatmentSpargingPreBubblerBool = If[
							And[
								MatchQ[pretreatElectrodes, False],
								!MatchQ[resolvedPretreatmentSpargingPreBubbler, Null],
								MatchQ[nonNullPretreatmentSpargingBool, False]
							],

							(* If we have non-Null resolvedPretreatmentSpargingPreBubbler when pretreatElectrode is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If we are pre-treating the electrodes, but resolvedPretreatmentSpargingPreBubbler is set to Null, we have the missingPretreatmentSpargingPreBubblerBool error *)
						missingPretreatmentSpargingPreBubblerBool = If[
							And[
								MatchQ[pretreatElectrodes, True],
								!MatchQ[resolvedPretreatmentSpargingPreBubbler, BooleanP],
								MatchQ[missingPretreatmentSpargingBool, False]
							],

							(* If we have Null resolvedPretreatmentSpargingPreBubbler when pretreatElectrode is True, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If resolvedPretreatmentSparging is False but resolvedPretreatmentSpargingPreBubbler is True, we have the PretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSparging error *)
						pretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSpargingBool = If[
							And[
								MatchQ[nonNullPretreatmentSpargingBool, False],
								MatchQ[nonNullPretreatmentSpargingPreBubblerBool, False],
								MatchQ[resolvedPretreatmentSparging, False],
								MatchQ[resolvedPretreatmentSpargingPreBubbler, True]
							],

							(* If we have True resolvedPretreatmentSpargingPreBubbler when resolvedPretreatmentSparging is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve PretreatmentInitialPotential -- *)
						resolvedPretreatmentInitialPotential = If[MatchQ[pretreatElectrodes, False],

							(* If we are not pre-treating electrodes, we set Automatic PretreatmentInitialPotential to Null *)
							pretreatmentInitialPotential /. {Automatic -> Null},

							(* If we are pre-treating electrodes, we set Automatic PretreatmentInitialPotential to 0.0 Volt *)
							pretreatmentInitialPotential /. {Automatic -> 0.0 Volt}
						];

						(* If we are not pre-treating the electrodes, but resolvedPretreatmentInitialPotential is not Null, we have the nonNullPretreatmentInitialPotential error *)
						nonNullPretreatmentInitialPotentialBool = If[
							MatchQ[pretreatElectrodes, False] && !MatchQ[resolvedPretreatmentInitialPotential, Null],

							(* If we have non-Null resolvedPretreatmentInitialPotential when pretreatElectrode is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If we are pre-treating the electrodes, but resolvedPretreatmentInitialPotential is set to Null, we have the missingPretreatmentInitialPotential error *)
						missingPretreatmentInitialPotentialBool = If[
							MatchQ[pretreatElectrodes, True] && !MatchQ[resolvedPretreatmentInitialPotential, VoltageP],

							(* If we have Null resolvedPretreatmentInitialPotential when pretreatElectrode is True, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve PretreatmentFirstPotential -- *)
						resolvedPretreatmentFirstPotential = If[MatchQ[pretreatElectrodes, False],

							(* If we are not pre-treating electrodes, we set Automatic PretreatmentFirstPotential to Null *)
							pretreatmentFirstPotential /. {Automatic -> Null},

							(* If we are pre-treating electrodes, we set Automatic PretreatmentFirstPotential to 1.5 Volt *)
							pretreatmentFirstPotential /. {Automatic -> 1.5 Volt}
						];

						(* If we are not pre-treating the electrodes, but resolvedPretreatmentFirstPotential is not Null, we have the nonNullPretreatmentFirstPotential error *)
						nonNullPretreatmentFirstPotentialBool = If[
							MatchQ[pretreatElectrodes, False] && !MatchQ[resolvedPretreatmentFirstPotential, Null],

							(* If we have non-Null resolvedPretreatmentFirstPotential when pretreatElectrode is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If we are pre-treating the electrodes, but resolvedPretreatmentFirstPotential is set to Null, we have the missingPretreatmentFirstPotential error *)
						missingPretreatmentFirstPotentialBool = If[
							MatchQ[pretreatElectrodes, True] && !MatchQ[resolvedPretreatmentFirstPotential, VoltageP],

							(* If we have Null resolvedPretreatmentFirstPotential when pretreatElectrode is True, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve PretreatmentSecondPotential -- *)
						resolvedPretreatmentSecondPotential = If[MatchQ[pretreatElectrodes, False],

							(* If we are not pre-treating electrodes, we set Automatic PretreatmentSecondPotential to Null *)
							pretreatmentSecondPotential /. {Automatic -> Null},

							(* If we are pre-treating electrodes, we set Automatic PretreatmentSecondPotential to -2.5 Volt *)
							pretreatmentSecondPotential /. {Automatic -> -2.5 Volt}
						];

						(* If we are not pre-treating the electrodes, but resolvedPretreatmentSecondPotential is not Null, we have the nonNullPretreatmentSecondPotential error *)
						nonNullPretreatmentSecondPotentialBool = If[
							MatchQ[pretreatElectrodes, False] && !MatchQ[resolvedPretreatmentSecondPotential, Null],

							(* If we have non-Null resolvedPretreatmentSecondPotential when pretreatElectrode is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If we are pre-treating the electrodes, but resolvedPretreatmentSecondPotential is set to Null, we have the missingPretreatmentSecondPotential error *)
						missingPretreatmentSecondPotentialBool = If[
							MatchQ[pretreatElectrodes, True] && !MatchQ[resolvedPretreatmentSecondPotential, VoltageP],

							(* If we have Null resolvedPretreatmentSecondPotential when pretreatElectrode is True, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve PretreatmentFinalPotential -- *)
						resolvedPretreatmentFinalPotential = If[MatchQ[pretreatElectrodes, False],

							(* If we are not pre-treating electrodes, we set Automatic PretreatmentFinalPotential to Null *)
							pretreatmentFinalPotential /. {Automatic -> Null},

							(* If we are pre-treating electrodes, we set Automatic PretreatmentFinalPotential to 0.0 Volt *)
							pretreatmentFinalPotential /. {Automatic -> 0.0 Volt}
						];

						(* If we are not pre-treating the electrodes, but resolvedPretreatmentFinalPotential is not Null, we have the nonNullPretreatmentFinalPotential error *)
						nonNullPretreatmentFinalPotentialBool = If[
							MatchQ[pretreatElectrodes, False] && !MatchQ[resolvedPretreatmentFinalPotential, Null],

							(* If we have non-Null resolvedPretreatmentFinalPotential when pretreatElectrode is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If we are pre-treating the electrodes, but resolvedPretreatmentFinalPotential is set to Null, we have the missingPretreatmentFinalPotential error *)
						missingPretreatmentFinalPotentialBool = If[
							MatchQ[pretreatElectrodes, True] && !MatchQ[resolvedPretreatmentFinalPotential, VoltageP],

							(* If we have Null resolvedPretreatmentFinalPotential when pretreatElectrode is True, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* Further pretreatment potential checks *)
						(* The PretreatmentInitialPotential should be between PretreatmentFirstPotential and PretreatmentSecondPotential *)
						pretreatmentInitialPotentialNotBetweenFirstAndSecondPotentialsBool = If[
							And[
								MatchQ[pretreatElectrodes, True],
								MatchQ[resolvedPretreatmentInitialPotential, VoltageP],
								MatchQ[resolvedPretreatmentFirstPotential, VoltageP],
								MatchQ[resolvedPretreatmentSecondPotential, VoltageP],
								MatchQ[nonNullPretreatmentInitialPotentialBool, False],
								MatchQ[missingPretreatmentInitialPotentialBool, False],
								MatchQ[nonNullPretreatmentFirstPotentialBool, False],
								MatchQ[missingPretreatmentFirstPotentialBool, False],
								MatchQ[nonNullPretreatmentSecondPotentialBool, False],
								MatchQ[missingPretreatmentSecondPotentialBool, False]
							],

							(* If non of the potential related errors were encountered, we can check this error *)
							If[
								Or[
									And[
										GreaterQ[resolvedPretreatmentInitialPotential, resolvedPretreatmentFirstPotential],
										GreaterQ[resolvedPretreatmentInitialPotential, resolvedPretreatmentSecondPotential]
									],
									And[
										LessQ[resolvedPretreatmentInitialPotential, resolvedPretreatmentFirstPotential],
										LessQ[resolvedPretreatmentInitialPotential, resolvedPretreatmentSecondPotential]
									]
								],

								(* If resolvedPretreatmentInitialPotential is larger or less than both resolvedPretreatmentFirstPotential and resolvedPretreatmentSecondPotential, we set this error to True *)
								True,

								(* Otherwise, we set this error to False *)
								False
							],

							(* If we encountered any potential related errors were encountered, we don't check this error *)
							False
						];

						(* The PretreatmentFinalPotential should be between PretreatmentFirstPotential and PretreatmentSecondPotential *)
						pretreatmentFinalPotentialNotBetweenFirstAndSecondPotentialsBool = If[
							And[
								MatchQ[pretreatElectrodes, True],
								MatchQ[resolvedPretreatmentFinalPotential, VoltageP],
								MatchQ[resolvedPretreatmentFirstPotential, VoltageP],
								MatchQ[resolvedPretreatmentSecondPotential, VoltageP],
								MatchQ[nonNullPretreatmentFinalPotentialBool, False],
								MatchQ[missingPretreatmentFinalPotentialBool, False],
								MatchQ[nonNullPretreatmentFirstPotentialBool, False],
								MatchQ[missingPretreatmentFirstPotentialBool, False],
								MatchQ[nonNullPretreatmentSecondPotentialBool, False],
								MatchQ[missingPretreatmentSecondPotentialBool, False]
							],

							(* If non of the potential related errors were encountered, we can check this error *)
							If[
								Or[
									And[
										GreaterQ[resolvedPretreatmentFinalPotential, resolvedPretreatmentFirstPotential],
										GreaterQ[resolvedPretreatmentFinalPotential, resolvedPretreatmentSecondPotential]
									],
									And[
										LessQ[resolvedPretreatmentFinalPotential, resolvedPretreatmentFirstPotential],
										LessQ[resolvedPretreatmentFinalPotential, resolvedPretreatmentSecondPotential]
									]
								],

								(* If resolvedPretreatmentFinalPotential is larger or less than both resolvedPretreatmentFirstPotential and resolvedPretreatmentSecondPotential, we set this error to True *)
								True,

								(* Otherwise, we set this error to False *)
								False
							],

							(* If we encountered any potential related errors were encountered, we don't check this error *)
							False
						];

						(* The PretreatmentInitialPotential and PretreatmentFinalPotential should not be differed by more than 0.5 Volt *)
						pretreatmentInitialAndFinalPotentialsTooDifferentBool = If[
							And[
								MatchQ[pretreatElectrodes, True],
								MatchQ[resolvedPretreatmentInitialPotential, VoltageP],
								MatchQ[resolvedPretreatmentFinalPotential, VoltageP],
								MatchQ[nonNullPretreatmentInitialPotentialBool, False],
								MatchQ[missingPretreatmentInitialPotentialBool, False],
								MatchQ[nonNullPretreatmentFinalPotentialBool, False],
								MatchQ[missingPretreatmentFinalPotentialBool, False]
							],

							(* If non of the potential related errors were encountered, we can check this error *)
							If[GreaterQ[Abs[resolvedPretreatmentInitialPotential - resolvedPretreatmentFinalPotential], 0.5 Volt],

								(* If resolvedPretreatmentInitialPotential and resolvedPretreatmentFinalPotential are differed by more than 0.5 Volt, we set this error to True *)
								True,

								(* Otherwise, we set this error to False *)
								False
							],

							(* If we encountered any potential related errors were encountered, we don't check this error *)
							False
						];

						(* -- Resolve PretreatmentPotentialSweepRate -- *)
						resolvedPretreatmentPotentialSweepRate = If[MatchQ[pretreatElectrodes, False],

							(* If we are not pre-treating electrodes, we set Automatic PretreatmentPotentialSweepRate to Null *)
							pretreatmentPotentialSweepRate /. {Automatic -> Null},

							(* If we are pre-treating electrodes, we set Automatic PretreatmentPotentialSweepRate to 200 Millivolt/Second *)
							pretreatmentPotentialSweepRate /. {Automatic -> 200 Millivolt/Second}
						];

						(* If we are not pre-treating the electrodes, but resolvedPretreatmentPotentialSweepRate is not Null, we have the nonNullPretreatmentPotentialSweepRate error *)
						nonNullPretreatmentPotentialSweepRateBool = If[
							MatchQ[pretreatElectrodes, False] && !MatchQ[resolvedPretreatmentPotentialSweepRate, Null],

							(* If we have non-Null resolvedPretreatmentInitialPotential when pretreatElectrode is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If we are pre-treating the electrodes, but resolvedPretreatmentPotentialSweepRate is set to Null, we have the missingPretreatmentPotentialSweepRate error *)
						missingPretreatmentPotentialSweepRateBool = If[
							MatchQ[pretreatElectrodes, True] && MatchQ[resolvedPretreatmentPotentialSweepRate, Null],

							(* If we have Null resolvedPretreatmentInitialPotential when pretreatElectrode is True, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve PretreatmentNumberOfCycles -- *)
						resolvedPretreatmentNumberOfCycles = If[MatchQ[pretreatElectrodes, False],

							(* If we are not pre-treating electrodes, we set Automatic PretreatmentNumberOfCycles to Null *)
							pretreatmentNumberOfCycles /. {Automatic -> Null},

							(* If we are pre-treating electrodes, we set Automatic PretreatmentNumberOfCycles to 3 *)
							pretreatmentNumberOfCycles /. {Automatic -> 3}
						];

						(* If we are not pre-treating the electrodes, but resolvedPretreatmentNumberOfCycles is not Null, we have the nonNullPretreatmentNumberOfCycles error *)
						nonNullPretreatmentNumberOfCyclesBool = If[
							MatchQ[pretreatElectrodes, False] && !MatchQ[resolvedPretreatmentNumberOfCycles, Null],

							(* If we have non-Null resolvedPretreatmentNumberOfCycles when pretreatElectrode is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If we are pre-treating the electrodes, but resolvedPretreatmentNumberOfCycles is set to Null, we have the missingPretreatmentNumberOfCycles error *)
						missingPretreatmentNumberOfCyclesBool = If[
							MatchQ[pretreatElectrodes, True] && !MatchQ[resolvedPretreatmentNumberOfCycles, _Integer],

							(* If we have Null resolvedPretreatmentNumberOfCycles when pretreatElectrode is True, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						{
							Association[
								PretreatmentSparging -> resolvedPretreatmentSparging,
								PretreatmentSpargingPreBubbler -> resolvedPretreatmentSpargingPreBubbler,
								PretreatmentInitialPotential -> resolvedPretreatmentInitialPotential,
								PretreatmentFirstPotential -> resolvedPretreatmentFirstPotential,
								PretreatmentSecondPotential -> resolvedPretreatmentSecondPotential,
								PretreatmentFinalPotential -> resolvedPretreatmentFinalPotential,
								PretreatmentPotentialSweepRate -> resolvedPretreatmentPotentialSweepRate,
								PretreatmentNumberOfCycles -> resolvedPretreatmentNumberOfCycles
							],
							Association[
								NonNullPretreatmentSpargingBool -> nonNullPretreatmentSpargingBool,
								MissingPretreatmentSpargingBool -> missingPretreatmentSpargingBool,
								NonNullPretreatmentSpargingPreBubblerBool -> nonNullPretreatmentSpargingPreBubblerBool,
								MissingPretreatmentSpargingPreBubblerBool -> missingPretreatmentSpargingPreBubblerBool,
								PretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSpargingBool -> pretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSpargingBool,
								NonNullPretreatmentInitialPotentialBool -> nonNullPretreatmentInitialPotentialBool,
								MissingPretreatmentInitialPotentialBool -> missingPretreatmentInitialPotentialBool,
								NonNullPretreatmentFirstPotentialBool -> nonNullPretreatmentFirstPotentialBool,
								MissingPretreatmentFirstPotentialBool -> missingPretreatmentFirstPotentialBool,
								NonNullPretreatmentSecondPotentialBool -> nonNullPretreatmentSecondPotentialBool,
								MissingPretreatmentSecondPotentialBool -> missingPretreatmentSecondPotentialBool,
								NonNullPretreatmentFinalPotentialBool -> nonNullPretreatmentFinalPotentialBool,
								MissingPretreatmentFinalPotentialBool -> missingPretreatmentFinalPotentialBool,
								PretreatmentInitialPotentialNotBetweenFirstAndSecondPotentialsBool -> pretreatmentInitialPotentialNotBetweenFirstAndSecondPotentialsBool,
								PretreatmentFinalPotentialNotBetweenFirstAndSecondPotentialsBool -> pretreatmentFinalPotentialNotBetweenFirstAndSecondPotentialsBool,
								PretreatmentInitialAndFinalPotentialsTooDifferentBool -> pretreatmentInitialAndFinalPotentialsTooDifferentBool,
								NonNullPretreatmentPotentialSweepRateBool -> nonNullPretreatmentPotentialSweepRateBool,
								MissingPretreatmentPotentialSweepRateBool -> missingPretreatmentPotentialSweepRateBool,
								NonNullPretreatmentNumberOfCyclesBool -> nonNullPretreatmentNumberOfCyclesBool,
								MissingPretreatmentNumberOfCyclesBool -> missingPretreatmentNumberOfCyclesBool
							]
						}
					];

					(* -------------------------- *)
					(* -- Resolve Mix options --  *)
					(* -------------------------- *)
					{mixOptionsAssociation, mixOptionsErrorTrackingAssociation} = Module[
						{
							(* Error tracking booleans *)
							loadingSampleMixFalseForUnpreparedSampleBool,
							nonNullLoadingSampleMixTypeBool,
							missingLoadingSampleMixTypeBool,
							nonNullLoadingSampleMixTemperatureBool,
							missingLoadingSampleMixTemperatureBool,
							loadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixTypeBool,
							nonNullLoadingSampleMixUntilDissolvedBool,
							missingLoadingSampleMixUntilDissolvedBool,
							nonNullLoadingSampleMaxNumberOfMixesWhenNotMixingBool,
							nonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolvedBool,
							nonNullLoadingSampleMaxNumberOfMixesForShakeMixTypeBool,
							missingLoadingSampleMaxNumberOfMixesBool,
							nonNullLoadingSampleMaxMixTimeWhenNotMixingBool,
							nonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolvedBool,
							nonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixTypeBool,
							missingLoadingSampleMaxMixTimeBool,
							nonNullLoadingSampleMixTimeWhenNotMixingBool,
							nonNullLoadingSampleMixTimeForPipetteOrInvertMixTypeBool,
							missingLoadingSampleMixTimeBool,
							loadingSampleMixTimeGreaterThanMaxMixTimeBool,
							nonNullLoadingSampleNumberOfMixesWhenNotMixingBool,
							nonNullLoadingSampleNumberOfMixesForShakeMixTypeBool,
							missingLoadingSampleNumberOfMixesBool,
							loadingSampleNumberOfMixesGreaterThanMaxNumberOfMixesBool,
							nonNullLoadingSampleMixVolumeWhenNotMixingBool,
							nonNullLoadingSampleMixVolumeForNonPipetteMixTypeBool,
							missingLoadingSampleMixVolumeBool,
							loadingSampleMixVolumeGreaterThanSolventVolumeBool
						},

						(* -- Resolve LoadingSampleMix -- *)
						resolvedLoadingSampleMix = If[MatchQ[resolvedPreparedSample, False],

							(* If the input sample is not prepared, set Automatic LoadingSampleMix to True *)
							loadingSampleMix /. {Automatic -> True},

							(* Otherwise, we set this to False *)
							loadingSampleMix /. {Automatic -> False}
						];

						(* Check if we are not mixing the unprepared sample *)
						loadingSampleMixFalseForUnpreparedSampleBool = If[
							MatchQ[resolvedPreparedSample, False] && MatchQ[resolvedLoadingSampleMix, False],

							(* If the input sample is not prepared and we are not mixing, set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve LoadingSampleMixType -- *)
						resolvedLoadingSampleMixType = If[
							MatchQ[resolvedLoadingSampleMix, True],

							(* If we are mixing, set Automatic LoadingSampleMixType to Invert *)
							loadingSampleMixType /. {Automatic -> Invert},

							(* If we are not mixing, set Automatic LoadingSampleMixType to Null *)
							loadingSampleMixType /. {Automatic -> Null}
						];

						(* nonNullLoadingSampleMixType check *)
						nonNullLoadingSampleMixTypeBool = If[
							And[
								MatchQ[loadingSampleMixFalseForUnpreparedSampleBool, False],
								MatchQ[resolvedLoadingSampleMix, False],
								!MatchQ[resolvedLoadingSampleMixType, Null]
							],

							(* If we are not mixing and resolvedLoadingSampleMixType is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingLoadingSampleMixType check *)
						missingLoadingSampleMixTypeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								!MatchQ[resolvedLoadingSampleMixType, Alternatives[Shake, Pipette, Invert]]
							],

							(* If we are mixing and resolvedLoadingSampleMixType is set to Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve LoadingSampleMixTemperature -- *)
						resolvedLoadingSampleMixTemperature = If[
							MatchQ[resolvedLoadingSampleMix, True],

							(* If we are mixing, set Automatic and Ambient LoadingSampleMixTemperature to 25 Celsius *)
							loadingSampleMixTemperature /. {Automatic -> $AmbientTemperature, Ambient -> $AmbientTemperature},

							(* If we are not mixing, set Automatic LoadingSampleMixType to Null *)
							loadingSampleMixTemperature /. {Automatic -> Null}
						];

						(* nonNullLoadingSampleMixTemperature check *)
						nonNullLoadingSampleMixTemperatureBool = If[
							And[
								MatchQ[loadingSampleMixFalseForUnpreparedSampleBool, False],
								MatchQ[resolvedLoadingSampleMix, False],
								!MatchQ[resolvedLoadingSampleMixTemperature, Null]
							],

							(* If we are not mixing and resolvedLoadingSampleMixTemperature is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingLoadingSampleMixTemperature check *)
						missingLoadingSampleMixTemperatureBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								!MatchQ[resolvedLoadingSampleMixTemperature, TemperatureP]
							],

							(* If we are mixing and resolvedLoadingSampleMixTemperature is set to Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* Check if resolvedLoadingSampleMixTemperature is higher than 25 Celsius when MixType is Pipette or Invert *)
						loadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixTypeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Alternatives[Pipette, Invert]],
								MatchQ[resolvedLoadingSampleMixTemperature, TemperatureP],
								GreaterQ[resolvedLoadingSampleMixTemperature, 25 Celsius]
							],

							(* If resolvedLoadingSampleMixTemperature is higher than 25 Celsius for Pipette or Invert, we set this error to True *)
							True,

							(* Otherwise, we set this error to True *)
							False
						];

						(* -- Resolve LoadingSampleMixUntilDissolved -- *)
						resolvedLoadingSampleMixUntilDissolved = If[MatchQ[resolvedLoadingSampleMix, True],

							(* If we are mixing, set Automatic LoadingSampleMixUntilDissolved to True *)
							loadingSampleMixUntilDissolved /. {Automatic -> True},

							(* If we are not mixing, set Automatic LoadingSampleMixUntilDissolved to Null *)
							loadingSampleMixUntilDissolved /. {Automatic -> Null}
						];

						(* nonNullLoadingSampleMixUntilDissolved check *)
						nonNullLoadingSampleMixUntilDissolvedBool = If[
							And[
								MatchQ[loadingSampleMixFalseForUnpreparedSampleBool, False],
								MatchQ[resolvedLoadingSampleMix, False],
								!MatchQ[resolvedLoadingSampleMixUntilDissolved, Null]
							],

							(* If we are not mixing and resolvedLoadingSampleMixUntilDissolved is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingLoadingSampleMixUntilDissolved check *)
						missingLoadingSampleMixUntilDissolvedBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								!MatchQ[resolvedLoadingSampleMixUntilDissolved, BooleanP]
							],

							(* If we are mixing and resolvedLoadingSampleMixUntilDissolved is set to Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve LoadingSampleMaxNumberOfMixes -- *)
						resolvedLoadingSampleMaxNumberOfMixes = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Alternatives[Pipette, Invert]],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								MatchQ[resolvedLoadingSampleMixUntilDissolved, True],
								MatchQ[nonNullLoadingSampleMixUntilDissolvedBool, False],
								MatchQ[missingLoadingSampleMixUntilDissolvedBool, False]
							],

							(* If we are mixing using Pipette or Invert and resolvedLoadingSampleMixUntilDissolved is True, set Automatic LoadingSampleMaxNumberOfMixes to 30 *)
							loadingSampleMaxNumberOfMixes /. {Automatic -> 30},

							(* If we are not mixing using Pipette or Invert or resolvedLoadingSampleMixUntilDissolved is False, set Automatic LoadingSampleMaxNumberOfMixes to Null *)
							loadingSampleMaxNumberOfMixes /. {Automatic -> Null}
						];

						(* nonNullLoadingSampleMaxNumberOfMixesWhenNotMixing check *)
						nonNullLoadingSampleMaxNumberOfMixesWhenNotMixingBool = If[
							And[
								MatchQ[loadingSampleMixFalseForUnpreparedSampleBool, False],
								MatchQ[resolvedLoadingSampleMix, False],
								!MatchQ[resolvedLoadingSampleMaxNumberOfMixes, Null]
							],

							(* If we are not mixing and resolvedLoadingSampleMaxNumberOfMixes is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* nonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolved check *)
						nonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolvedBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixUntilDissolved, False],
								MatchQ[nonNullLoadingSampleMixUntilDissolvedBool, False],
								MatchQ[missingLoadingSampleMixUntilDissolvedBool, False],
								!MatchQ[resolvedLoadingSampleMaxNumberOfMixes, Null]
							],

							(* If we are mixing with resolvedLoadingSampleMixUntilDissolved set to False, and resolvedLoadingSampleMaxNumberOfMixes is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* nonNullLoadingSampleMaxNumberOfMixesForShakeMixType check *)
						nonNullLoadingSampleMaxNumberOfMixesForShakeMixTypeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Shake],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								!MatchQ[resolvedLoadingSampleMaxNumberOfMixes, Null]
							],

							(* If we are mixing using Shake, and resolvedLoadingSampleMaxNumberOfMixes is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingLoadingSampleMaxNumberOfMixes check *)
						missingLoadingSampleMaxNumberOfMixesBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Alternatives[Pipette, Invert]],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								MatchQ[resolvedLoadingSampleMixUntilDissolved, True],
								MatchQ[nonNullLoadingSampleMixUntilDissolvedBool, False],
								MatchQ[missingLoadingSampleMixUntilDissolvedBool, False],
								!MatchQ[resolvedLoadingSampleMaxNumberOfMixes, _Integer]
							],

							(* If we are mixing using Pipette or Invert, resolvedLoadingSampleMixUntilDissolved is True and resolvedLoadingSampleMaxNumberOfMixes is set to Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve LoadingSampleMaxMixTime -- *)
						resolvedLoadingSampleMaxMixTime = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Shake],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								MatchQ[resolvedLoadingSampleMixUntilDissolved, True],
								MatchQ[nonNullLoadingSampleMixUntilDissolvedBool, False],
								MatchQ[missingLoadingSampleMixUntilDissolvedBool, False]
							],

							(* If we are mixing using Shake and resolvedLoadingSampleMixUntilDissolved is True, set Automatic LoadingSampleMaxMixTime to 20 Minutes *)
							loadingSampleMaxMixTime /. {Automatic -> 20 Minute},

							(* If we are not mixing using Shake or resolvedLoadingSampleMixUntilDissolved is False, set Automatic LoadingSampleMaxMixTime to Null *)
							loadingSampleMaxMixTime /. {Automatic -> Null}
						];

						(* nonNullLoadingSampleMaxMixTimeWhenNotMixing check *)
						nonNullLoadingSampleMaxMixTimeWhenNotMixingBool = If[
							And[
								MatchQ[loadingSampleMixFalseForUnpreparedSampleBool, False],
								MatchQ[resolvedLoadingSampleMix, False],
								!MatchQ[resolvedLoadingSampleMaxMixTime, Null]
							],

							(* If we are not mixing and resolvedLoadingSampleMaxMixTime is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* nonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolved check *)
						nonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolvedBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixUntilDissolved, False],
								MatchQ[nonNullLoadingSampleMixUntilDissolvedBool, False],
								MatchQ[missingLoadingSampleMixUntilDissolvedBool, False],
								!MatchQ[resolvedLoadingSampleMaxMixTime, Null]
							],

							(* If we are mixing with resolvedLoadingSampleMixUntilDissolved set to False, and resolvedLoadingSampleMaxMixTime is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* nonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixType check *)
						nonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixTypeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Alternatives[Pipette, Invert]],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								!MatchQ[resolvedLoadingSampleMaxMixTime, Null]
							],

							(* If we are mixing using Pipette or Invert, and resolvedLoadingSampleMaxMixTime is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingLoadingSampleMaxMixTime check *)
						missingLoadingSampleMaxMixTimeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Shake],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								MatchQ[resolvedLoadingSampleMixUntilDissolved, True],
								MatchQ[nonNullLoadingSampleMixUntilDissolvedBool, False],
								MatchQ[missingLoadingSampleMixUntilDissolvedBool, False],
								!MatchQ[resolvedLoadingSampleMaxMixTime, TimeP]
							],

							(* If we are mixing using Shake, resolvedLoadingSampleMixUntilDissolved is True and resolvedLoadingSampleMaxMixTime is set to Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve LoadingSampleMixTime -- *)
						resolvedLoadingSampleMixTime = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Shake],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False]
							],

							(* If we are mixing and resolvedLoadingSampleMixType is Shake, set Automatic LoadingSampleMixTime to 5 Minutes *)
							loadingSampleMixTime /. {Automatic -> 5 Minute},

							(* If we are not mixing or resolvedLoadingSampleMixType is not Shake, set Automatic LoadingSampleMixTime to Null *)
							loadingSampleMixTime /. {Automatic -> Null}
						];

						(* nonNullLoadingSampleMixTimeWhenNotMixing check *)
						nonNullLoadingSampleMixTimeWhenNotMixingBool = If[
							And[
								MatchQ[loadingSampleMixFalseForUnpreparedSampleBool, False],
								MatchQ[resolvedLoadingSampleMix, False],
								!MatchQ[resolvedLoadingSampleMixTime, Null]
							],

							(* If we are not mixing and resolvedLoadingSampleMixTime is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* nonNullLoadingSampleMixTimeForPipetteOrInversionMixType check *)
						nonNullLoadingSampleMixTimeForPipetteOrInvertMixTypeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Alternatives[Pipette, Invert]],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								!MatchQ[resolvedLoadingSampleMixTime, Null]
							],

							(* If we are mixing using Pipette or Invert, but resolvedLoadingSampleMixTime is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingLoadingSampleMixTime check *)
						missingLoadingSampleMixTimeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Shake],
								!MatchQ[resolvedLoadingSampleMaxMixTime, TimeP],
								!MatchQ[resolvedLoadingSampleMixTime, TimeP]
							],

							(* If we are mixing using Shake, resolvedLoadingSampleMaxMixTime is set to Null, and resolvedLoadingSampleMixTime is set to Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* check if resolvedLoadingSampleMixTime is greater than resolvedLoadingSampleMaxMixTime *)
						loadingSampleMixTimeGreaterThanMaxMixTimeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixUntilDissolved, True],
								MatchQ[resolvedLoadingSampleMaxMixTime, TimeP],
								MatchQ[nonNullLoadingSampleMaxMixTimeWhenNotMixingBool, False],
								MatchQ[nonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolvedBool, False],
								MatchQ[nonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixTypeBool, False],
								MatchQ[missingLoadingSampleMaxMixTimeBool, False],
								MatchQ[resolvedLoadingSampleMixTime, TimeP],
								MatchQ[nonNullLoadingSampleMixTimeWhenNotMixingBool, False],
								MatchQ[nonNullLoadingSampleMixTimeForPipetteOrInvertMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTimeBool, False],
								GreaterQ[resolvedLoadingSampleMixTime, resolvedLoadingSampleMaxMixTime]
							],

							(* If resolvedLoadingSampleMixTime is greater than resolvedLoadingSampleMaxMixTime, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve LoadingSampleNumberOfMixes -- *)
						resolvedLoadingSampleNumberOfMixes = If[
							MatchQ[resolvedLoadingSampleMix, True] && MatchQ[resolvedLoadingSampleMixType, Alternatives[Pipette, Invert]],

							(* If we are mixing and resolvedLoadingSampleMixType is Pipette or Invert, set Automatic LoadingSampleMixTime to 10 *)
							loadingSampleNumberOfMixes /. {Automatic -> 10},

							(* If we are not mixing or resolvedLoadingSampleMixType is not Pipette or Invert, set Automatic LoadingSampleMixTime to Null *)
							loadingSampleNumberOfMixes /. {Automatic -> Null}
						];

						(* nonNullLoadingSampleNumberOfMixesWhenNotMixing check *)
						nonNullLoadingSampleNumberOfMixesWhenNotMixingBool = If[
							And[
								MatchQ[loadingSampleMixFalseForUnpreparedSampleBool, False],
								MatchQ[resolvedLoadingSampleMix, False],
								!MatchQ[resolvedLoadingSampleNumberOfMixes, Null]
							],

							(* If we are not mixing and resolvedLoadingSampleNumberOfMixes is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* nonNullLoadingSampleNumberOfMixesForShakeMixType check *)
						nonNullLoadingSampleNumberOfMixesForShakeMixTypeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Shake],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								!MatchQ[resolvedLoadingSampleNumberOfMixes, Null]
							],

							(* If we are mixing using Shake, but resolvedLoadingSampleNumberOfMixes is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingLoadingSampleNumberOfMixes check *)
						missingLoadingSampleNumberOfMixesBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Alternatives[Pipette, Invert]],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								!MatchQ[resolvedLoadingSampleMaxNumberOfMixes, _Integer],
								!MatchQ[resolvedLoadingSampleNumberOfMixes, _Integer]
							],

							(* If we are mixing using Pipette or Invert, resolvedLoadingSampleMaxNumberOfMixes is set to Null, and resolvedLoadingSampleNumberOfMixes is set to Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* check if resolvedLoadingSampleNumberOfMixes is greater than resolvedLoadingSampleMaxNumberOfMixes *)
						loadingSampleNumberOfMixesGreaterThanMaxNumberOfMixesBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixUntilDissolved, True],
								MatchQ[resolvedLoadingSampleMaxNumberOfMixes, _Integer],
								MatchQ[nonNullLoadingSampleMaxNumberOfMixesWhenNotMixingBool, False],
								MatchQ[nonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolvedBool, False],
								MatchQ[nonNullLoadingSampleMaxNumberOfMixesForShakeMixTypeBool, False],
								MatchQ[missingLoadingSampleMaxNumberOfMixesBool, False],
								MatchQ[resolvedLoadingSampleNumberOfMixes, _Integer],
								MatchQ[nonNullLoadingSampleNumberOfMixesWhenNotMixingBool, False],
								MatchQ[nonNullLoadingSampleNumberOfMixesForShakeMixTypeBool, False],
								MatchQ[missingLoadingSampleNumberOfMixesBool, False],
								GreaterQ[resolvedLoadingSampleNumberOfMixes, resolvedLoadingSampleMaxNumberOfMixes]
							],

							(* If resolvedLoadingSampleNumberOfMixes is greater than resolvedLoadingSampleMaxNumberOfMixes, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];


						(* -- Resolve LoadingSampleMixVolume -- *)
						resolvedLoadingSampleMixVolume = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Pipette],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False]
							],

							(* If we are mixing and resolvedLoadingSampleMixType is Pipette, check if resolvedSolventVolume is successfully resolved *)
							If[MatchQ[resolvedSolventVolume, VolumeP],

								(* If resolvedSolventVolume is successfully resolved, set Automatic LoadingSampleMixVolume to 50% of resolvedSolventVolume *)
								loadingSampleMixVolume /. {Automatic -> 0.5 * resolvedSolventVolume},

								(* Otherwise, set Automatic LoadingSampleMixVolume to 3 mL *)
								loadingSampleMixVolume /. {Automatic -> 3 Milliliter}
							],

							(* If we are not mixing or resolvedLoadingSampleMixType is not Pipette, set Automatic LoadingSampleMixVolume to Null *)
							loadingSampleMixVolume /. {Automatic -> Null}
						];

						(* nonNullLoadingSampleMixVolumeWhenNotMixing check *)
						nonNullLoadingSampleMixVolumeWhenNotMixingBool = If[
							And[
								MatchQ[loadingSampleMixFalseForUnpreparedSampleBool, False],
								MatchQ[resolvedLoadingSampleMix, False],
								!MatchQ[resolvedLoadingSampleMixVolume, Null]
							],

							(* If we are not mixing and resolvedLoadingSampleMixVolume is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* nonNullLoadingSampleMixVolumeForNonPipetteMixType check *)
						nonNullLoadingSampleMixVolumeForNonPipetteMixTypeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								!MatchQ[resolvedLoadingSampleMixType, Pipette],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								!MatchQ[resolvedLoadingSampleMixVolume, Null]
							],

							(* If we are mixing but not using Pipette, and resolvedLoadingSampleMixVolume is not Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* missingLoadingSampleMixVolume check *)
						missingLoadingSampleMixVolumeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Pipette],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								!MatchQ[resolvedLoadingSampleMixVolume, VolumeP]
							],

							(* If we are mixing using Pipette and resolvedLoadingSampleMixVolume is set to Null, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* Check if resolvedLoadingSampleMixVolume is greater than the resolvedSolventVolume *)
						loadingSampleMixVolumeGreaterThanSolventVolumeBool = If[
							And[
								MatchQ[resolvedLoadingSampleMix, True],
								MatchQ[resolvedLoadingSampleMixType, Pipette],
								MatchQ[nonNullLoadingSampleMixTypeBool, False],
								MatchQ[missingLoadingSampleMixTypeBool, False],
								MatchQ[resolvedLoadingSampleMixVolume, VolumeP],
								MatchQ[nonNullLoadingSampleMixVolumeWhenNotMixingBool, False],
								MatchQ[nonNullLoadingSampleMixVolumeForNonPipetteMixTypeBool, False],
								MatchQ[missingLoadingSampleMixVolumeBool, False],
								MatchQ[resolvedSolventVolume, VolumeP],
								GreaterQ[resolvedLoadingSampleMixVolume, resolvedSolventVolume]
							],

							(* If resolvedLoadingSampleMixVolume is greater than resolvedSolventVolume, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						{
							Association[
								LoadingSampleMix -> resolvedLoadingSampleMix,
								LoadingSampleMixType -> resolvedLoadingSampleMixType,
								LoadingSampleMixTemperature -> resolvedLoadingSampleMixTemperature,
								LoadingSampleMixTime -> resolvedLoadingSampleMixTime,
								LoadingSampleNumberOfMixes -> resolvedLoadingSampleNumberOfMixes,
								LoadingSampleMixVolume -> resolvedLoadingSampleMixVolume,
								LoadingSampleMixUntilDissolved -> resolvedLoadingSampleMixUntilDissolved,
								LoadingSampleMaxNumberOfMixes -> resolvedLoadingSampleMaxNumberOfMixes,
								LoadingSampleMaxMixTime -> resolvedLoadingSampleMaxMixTime
							],
							Association[
								LoadingSampleMixFalseForUnpreparedSampleBool -> loadingSampleMixFalseForUnpreparedSampleBool,
								NonNullLoadingSampleMixTypeBool -> nonNullLoadingSampleMixTypeBool,
								MissingLoadingSampleMixTypeBool -> missingLoadingSampleMixTypeBool,
								NonNullLoadingSampleMixTemperatureBool -> nonNullLoadingSampleMixTemperatureBool,
								MissingLoadingSampleMixTemperatureBool -> missingLoadingSampleMixTemperatureBool,
								LoadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixTypeBool -> loadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixTypeBool,
								NonNullLoadingSampleMixUntilDissolvedBool -> nonNullLoadingSampleMixUntilDissolvedBool,
								MissingLoadingSampleMixUntilDissolvedBool -> missingLoadingSampleMixUntilDissolvedBool,
								NonNullLoadingSampleMaxNumberOfMixesWhenNotMixingBool -> nonNullLoadingSampleMaxNumberOfMixesWhenNotMixingBool,
								NonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolvedBool -> nonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolvedBool,
								NonNullLoadingSampleMaxNumberOfMixesForShakeMixTypeBool -> nonNullLoadingSampleMaxNumberOfMixesForShakeMixTypeBool,
								MissingLoadingSampleMaxNumberOfMixesBool -> missingLoadingSampleMaxNumberOfMixesBool,
								NonNullLoadingSampleMaxMixTimeWhenNotMixingBool -> nonNullLoadingSampleMaxMixTimeWhenNotMixingBool,
								NonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolvedBool -> nonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolvedBool,
								NonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixTypeBool -> nonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixTypeBool,
								MissingLoadingSampleMaxMixTimeBool -> missingLoadingSampleMaxMixTimeBool,
								NonNullLoadingSampleMixTimeWhenNotMixingBool -> nonNullLoadingSampleMixTimeWhenNotMixingBool,
								NonNullLoadingSampleMixTimeForPipetteOrInvertMixTypeBool -> nonNullLoadingSampleMixTimeForPipetteOrInvertMixTypeBool,
								MissingLoadingSampleMixTimeBool -> missingLoadingSampleMixTimeBool,
								LoadingSampleMixTimeGreaterThanMaxMixTimeBool -> loadingSampleMixTimeGreaterThanMaxMixTimeBool,
								NonNullLoadingSampleNumberOfMixesWhenNotMixingBool -> nonNullLoadingSampleNumberOfMixesWhenNotMixingBool,
								NonNullLoadingSampleNumberOfMixesForShakeMixTypeBool -> nonNullLoadingSampleNumberOfMixesForShakeMixTypeBool,
								MissingLoadingSampleNumberOfMixesBool -> missingLoadingSampleNumberOfMixesBool,
								LoadingSampleNumberOfMixesGreaterThanMaxNumberOfMixesBool -> loadingSampleNumberOfMixesGreaterThanMaxNumberOfMixesBool,
								NonNullLoadingSampleMixVolumeWhenNotMixingBool -> nonNullLoadingSampleMixVolumeWhenNotMixingBool,
								NonNullLoadingSampleMixVolumeForNonPipetteMixTypeBool -> nonNullLoadingSampleMixVolumeForNonPipetteMixTypeBool,
								MissingLoadingSampleMixVolumeBool -> missingLoadingSampleMixVolumeBool,
								LoadingSampleMixVolumeGreaterThanSolventVolumeBool -> loadingSampleMixVolumeGreaterThanSolventVolumeBool
							]
						}
					];

					(* ------------------------------- *)
					(* -- Resolve Sparging options --  *)
					(* ------------------------------- *)
					{spargingOptionsAssociation, spargingOptionsErrorTrackingAssociation} = Module[
						{
							(* Error tracking Booleans *)
							nonNullSpargingGasBool,
							missingSpargingGasBool,
							nonNullSpargingTimeBool,
							missingSpargingTimeBool,
							tooLongSpargingTimeBool,
							nonNullSpargingPreBubblerBool,
							missingSpargingPreBubblerBool
						},

						(* -- Resolve SpargingGas -- *)
						resolvedSpargingGas = If[
							MatchQ[sparging, False],

							(* If we are not sparging the loading sample, set Automatic SpargingGas to Null *)
							spargingGas /. {Automatic -> Null},

							(* If we are sparging the loading sample, set Automatic SpargingGas to Nitrogen *)
							spargingGas /. {Automatic -> Nitrogen}
						];

						(* If we are not not sparging the loading sample, but resolvedSpargingGas is not Null, we have the nonNullSpargingGasBool error *)
						nonNullSpargingGasBool = If[
							MatchQ[sparging, False] && !MatchQ[resolvedSpargingGas, Null],

							(* If we have non-Null resolvedSpargingGas when sparging is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If we are pre-treating the electrodes, but resolvedSpargingGas is set to Null, we have the missingSpargingGasBool error *)
						missingSpargingGasBool = If[
							MatchQ[sparging, True] && !MatchQ[resolvedSpargingGas, Alternatives[Nitrogen, Argon, Helium]],

							(* If we have Null resolvedSpargingGas when sparging is True, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* -- Resolve SpargingTime -- *)
						resolvedSpargingTime = If[
							MatchQ[sparging, False],

							(* If we are not sparging the loading sample, set Automatic SpargingTime to Null *)
							spargingTime /. {Automatic -> Null},

							(* If we are sparging the loading sample, set Automatic SpargingTime to Nitrogen *)
							spargingTime /. {Automatic -> 3 Minute}
						];

						(* If we are not not sparging the loading sample, but resolvedSpargingTime is not Null, we have the nonNullSpargingTimeBool error *)
						nonNullSpargingTimeBool = If[
							MatchQ[sparging, False] && !MatchQ[resolvedSpargingTime, Null],

							(* If we have non-Null resolvedSpargingTime when sparging is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If we are pre-treating the electrodes, but resolvedSpargingTime is set to Null, we have the missingSpargingTimeBool error *)
						missingSpargingTimeBool = If[
							MatchQ[sparging, True] && !MatchQ[resolvedSpargingTime, TimeP],

							(* If we have Null resolvedSpargingTime when sparging is True, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* SpargingTime should not exceed 1 hour *)
						tooLongSpargingTimeBool = If[
							And[
								MatchQ[sparging, True],
								MatchQ[resolvedSpargingTime, TimeP],
								MatchQ[nonNullSpargingTimeBool, False],
								MatchQ[missingSpargingTimeBool, False]
							],

							(* If no error was encountered previously, we can check this error *)
							If[GreaterQ[resolvedSpargingTime, 1 Hour],

								(* If the resolvedSpargingTime is greater than 1 hour, we set this error to True *)
								True,

								(* Otherwise, we set this error to False *)
								False
							],

							(* If any error was encountered, we do not check this error. *)
							False
						];

						(* -- Resolve SpargingPreBubbler -- *)
						resolvedSpargingPreBubbler = If[
							MatchQ[sparging, False],

							(* If we are not sparging the loading sample, set Automatic SpargingPreBubbler to Null *)
							spargingPreBubbler /. {Automatic -> Null},

							(* If we are sparging the loading sample, set Automatic SpargingPreBubbler to True *)
							spargingPreBubbler /. {Automatic -> True}
						];

						(* If we are not not sparging the loading sample, but resolvedSpargingPreBubbler is not Null, we have the nonNullSpargingPreBubblerBool error *)
						nonNullSpargingPreBubblerBool = If[
							MatchQ[sparging, False] && !MatchQ[resolvedSpargingPreBubbler, Null],

							(* If we have non-Null resolvedSpargingPreBubbler when sparging is False, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						(* If we are pre-treating the electrodes, but resolvedPretreatmentSpargingPreBubbler is set to Null, we have the missingSpargingPreBubblerBool error *)
						missingSpargingPreBubblerBool = If[
							MatchQ[sparging, True] && !MatchQ[resolvedSpargingPreBubbler, BooleanP],

							(* If we have Null resolvedSpargingPreBubbler when sparging is True, we set this error to True *)
							True,

							(* Otherwise, we set this error to False *)
							False
						];

						{
							Association[
								SpargingGas -> resolvedSpargingGas,
								SpargingTime -> resolvedSpargingTime,
								SpargingPreBubbler -> resolvedSpargingPreBubbler
							],
							Association[
								NonNullSpargingGasBool -> nonNullSpargingGasBool,
								MissingSpargingGasBool -> missingSpargingGasBool,
								NonNullSpargingTimeBool -> nonNullSpargingTimeBool,
								MissingSpargingTimeBool -> missingSpargingTimeBool,
								TooLongSpargingTimeBool -> tooLongSpargingTimeBool,
								NonNullSpargingPreBubblerBool -> nonNullSpargingPreBubblerBool,
								MissingSpargingPreBubblerBool -> missingSpargingPreBubblerBool
							]
						}
					];

					(* ----------------------------------------------------- *)
					(* -- Resolve Cyclic Voltammetry Measurement options --  *)
					(* ----------------------------------------------------- *)
					{cyclicVoltammetryMeasurementOptionsAssociation, cyclicVoltammetryMeasurementOptionsErrorTrackingAssociation} = Module[
						{
							(* Error tracking booleans *)
							initialPotentialsLengthMismatchNumberOfCyclesBool,
							firstPotentialsLengthMismatchNumberOfCyclesBool,
							secondPotentialsLengthMismatchNumberOfCyclesBool,
							finalPotentialsLengthMismatchNumberOfCyclesBool,
							potentialSweepRatesLengthMismatchNumberOfCyclesBool,
							initialPotentialNotBetweenFirstAndSecondPotentialsBool,
							finalPotentialNotBetweenFirstAndSecondPotentialsBool,
							initialAndFinalPotentialsTooDifferentBool
						},

						(* Resolve the InitialPotentials *)
						resolvedInitialPotentials = initialPotentials /. {Automatic -> ConstantArray[0.0 Volt, numberOfCycles]};

						(* Resolve the FinalPotentials *)
						resolvedFirstPotentials = firstPotentials /. {Automatic -> ConstantArray[2.0 Volt, numberOfCycles]};

						(* Resolve the SecondPotentials *)
						resolvedSecondPotentials = secondPotentials /. {Automatic -> ConstantArray[-2.0 Volt, numberOfCycles]};

						(* Resolve the FirstPotentials *)
						resolvedFinalPotentials = finalPotentials /. {Automatic -> ConstantArray[0.0 Volt, numberOfCycles]};

						(* Resolve the PotentialSweepRates *)
						resolvedPotentialSweepRates = potentialSweepRates /. {Automatic -> ConstantArray[200 Millivolt/Second, numberOfCycles]};

						(* -- First we check if the length of InitialPotentials, FirstPotentials, SecondPotentials, FinalPotentials, and PotentialSweepRate match with NumberOfCycles -- *)
						(* InitialPotentials *)
						initialPotentialsLengthMismatchNumberOfCyclesBool = If[
							!MatchQ[Length[resolvedInitialPotentials], numberOfCycles],

							(* If the length of InitialPotentials does not match with NumberOfCycles, we set this error to True *)
							True,
							False
						];

						(* FirstPotentials *)
						firstPotentialsLengthMismatchNumberOfCyclesBool = If[
							!MatchQ[Length[resolvedFirstPotentials], numberOfCycles],

							(* If the length of FirstPotentials does not match with NumberOfCycles, we set this error to True *)
							True,
							False
						];

						(* SecondPotentials *)
						secondPotentialsLengthMismatchNumberOfCyclesBool = If[
							!MatchQ[Length[resolvedSecondPotentials], numberOfCycles],

							(* If the length of SecondPotentials does not match with NumberOfCycles, we set this error to True *)
							True,
							False
						];

						(* FinalPotentials *)
						finalPotentialsLengthMismatchNumberOfCyclesBool = If[
							!MatchQ[Length[resolvedFinalPotentials], numberOfCycles],

							(* If the length of FinalPotentials does not match with NumberOfCycles, we set this error to True *)
							True,
							False
						];

						(* PotentialSweepRates *)
						potentialSweepRatesLengthMismatchNumberOfCyclesBool = If[
							!MatchQ[Length[resolvedPotentialSweepRates], numberOfCycles],

							(* If the length of PotentialSweepRates does not match with NumberOfCycles, we set this error to True *)
							True,
							False
						];

						(* -- If none of the potential errors was encountered, we then dig into the lists of Initial, First, Second, Final-Potentials to check -- *)
						If[
							And[
								MatchQ[initialPotentialsLengthMismatchNumberOfCyclesBool, False],
								MatchQ[firstPotentialsLengthMismatchNumberOfCyclesBool, False],
								MatchQ[secondPotentialsLengthMismatchNumberOfCyclesBool, False],
								MatchQ[finalPotentialsLengthMismatchNumberOfCyclesBool, False]
							],

							(* If no error was encountered, we continue *)
							(* First we initialize the error tracking booleans, and in the MapThread, we only set them to True if the error is encountered. *)
							{
								initialPotentialNotBetweenFirstAndSecondPotentialsBool,
								finalPotentialNotBetweenFirstAndSecondPotentialsBool,
								initialAndFinalPotentialsTooDifferentBool
							} = {False, False, False};

							(* We use a MapThread to check these three errors. *)
							MapThread[
								Function[{initialPotential, firstPotential, secondPotential, finalPotential},
									Module[{},

										(* initialPotential should be between firstPotential and secondPotential *)
										If[
											Or[
												And[
													GreaterQ[initialPotential, firstPotential],
													GreaterQ[initialPotential, secondPotential]
												],
												And[
													LessQ[initialPotential, firstPotential],
													LessQ[initialPotential, secondPotential]
												]
											],

											(* If initialPotential is larger or less than both firstPotential and secondPotential, we set this error to True *)
											initialPotentialNotBetweenFirstAndSecondPotentialsBool = True
										];

										(* finalPotential should be between firstPotential and secondPotential *)
										If[
											Or[
												And[
													GreaterQ[finalPotential, firstPotential],
													GreaterQ[finalPotential, secondPotential]
												],
												And[
													LessQ[finalPotential, firstPotential],
													LessQ[finalPotential, secondPotential]
												]
											],

											(* If finalPotential is larger or less than both firstPotential and secondPotential, we set this error to True *)
											finalPotentialNotBetweenFirstAndSecondPotentialsBool = True
										];

										(* The initialPotential and finalPotential should not be differed by more than 0.5 Volt *)
										If[GreaterQ[Abs[initialPotential - finalPotential], 0.5 Volt],

											(* If initialPotential and finalPotential are differed by more than 0.5 Volt, we set this error to True *)
											initialAndFinalPotentialsTooDifferentBool = True
										];

									]
								],
								(* MapThread input variables *)
								{resolvedInitialPotentials, resolvedFirstPotentials, resolvedSecondPotentials, resolvedFinalPotentials}
							],

							(* If any error was encountered, we don't do the check *)
							{
								initialPotentialNotBetweenFirstAndSecondPotentialsBool,
								finalPotentialNotBetweenFirstAndSecondPotentialsBool,
								initialAndFinalPotentialsTooDifferentBool
							} = {False, False, False}
						];

						{
							Association[
								InitialPotentials -> resolvedInitialPotentials,
								FirstPotentials -> resolvedFirstPotentials,
								SecondPotentials -> resolvedSecondPotentials,
								FinalPotentials -> resolvedFinalPotentials,
								PotentialSweepRates -> resolvedPotentialSweepRates
							],
							Association[
								InitialPotentialsLengthMismatchNumberOfCyclesBool -> initialPotentialsLengthMismatchNumberOfCyclesBool,
								FirstPotentialsLengthMismatchNumberOfCyclesBool -> firstPotentialsLengthMismatchNumberOfCyclesBool,
								SecondPotentialsLengthMismatchNumberOfCyclesBool -> secondPotentialsLengthMismatchNumberOfCyclesBool,
								FinalPotentialsLengthMismatchNumberOfCyclesBool -> finalPotentialsLengthMismatchNumberOfCyclesBool,
								PotentialSweepRatesLengthMismatchNumberOfCyclesBool -> potentialSweepRatesLengthMismatchNumberOfCyclesBool,
								InitialPotentialNotBetweenFirstAndSecondPotentialsBool -> initialPotentialNotBetweenFirstAndSecondPotentialsBool,
								FinalPotentialNotBetweenFirstAndSecondPotentialsBool -> finalPotentialNotBetweenFirstAndSecondPotentialsBool,
								InitialAndFinalPotentialsTooDifferentBool -> initialAndFinalPotentialsTooDifferentBool
							]
						}
					];

					(* gather the resolved Options and the error tracking booleans *)
					resolvedOptionsAssociation = Join[
						polishingOptionsAssociation,
						sonicationOptionsAssociation,
						electrodeWashingOptionsAssociation,
						loadingSampleVolumeOptionsAssociation,
						analyteOptionsAssociation,
						solventAndElectrolyteOptionsAssociation,
						referenceElectrodeOptionsAssociation,
						internalStandardOptionsAssociation,
						pretreatElectrodesOptionsAssociation,
						mixOptionsAssociation,
						spargingOptionsAssociation,
						cyclicVoltammetryMeasurementOptionsAssociation
					];

					(*gather the error tracking*)
					errorTrackingAssociation = Join[
						polishingOptionsErrorTrackingAssociation,
						sonicationOptionsErrorTrackingAssociation,
						electrodeWashingOptionsErrorTrackingAssociation,
						loadingSampleVolumeOptionsErrorTrackingAssociation,
						analyteOptionsErrorTrackingAssociation,
						solventAndElectrolyteOptionsErrorTrackingAssociation,
						referenceElectrodeOptionsErrorTrackingAssociation,
						internalStandardOptionsErrorTrackingAssociation,
						pretreatElectrodesOptionsErrorTrackingAssociation,
						mixOptionsErrorTrackingAssociation,
						spargingOptionsErrorTrackingAssociation,
						cyclicVoltammetryMeasurementOptionsErrorTrackingAssociation
					];

					(* gather the warning tracking *)
					warningTrackingAssociation = Join[
						polishingOptionsWarningTrackingAssociation,
						loadingSampleVolumeWarningTrackingAssociation,
						solventAndElectrolyteOptionsWarningTrackingAssociation,
						referenceElectrodeOptionsWarningTrackingAssociation
					];

					(* return the associations *)
					{resolvedOptionsAssociation, errorTrackingAssociation, warningTrackingAssociation}
				]
			],
			{mapThreadFriendlyOptions, simulatedSamples}
		]
	];

	(* -- MAPTHREAD CLEANUP -- *)
	resolvedOptionsAssociation = Merge[mapThreadResolvedOptionAssociations, Join];
	resolvedErrorCheckingAssociation = Merge[mapThreadErrorTrackingAssociations, Join];
	resolvedWarningCheckingAssociation = Merge[mapThreadWarningTrackingAssociations, Join];

	(* -- Extract samplePackets that had a polishing options related problem in the MapThread -- *)
	(* Errors *)
	{
		samplePacketsWithCoatedWorkingElectrode,
		samplePacketsWithNonNullPolishingPads,
		samplePacketsWithNonNullPolishingSolutions,
		samplePacketsWithNonNullNumberOfPolishingSolutionDroplets,
		samplePacketsWithNonNullNumberOfPolishings,
		samplePacketsWithMissingPolishingPads,
		samplePacketsWithMissingPolishingSolutions,
		samplePacketsWithMissingNumberOfPolishingSolutionDroplets,
		samplePacketsWithMissingNumberOfPolishings,
		samplePacketsWithMisMatchingPolishingSolutionsLength,
		samplePacketsWithMisMatchingNumberOfPolishingSolutionDropletsLength,
		samplePacketsWithMisMatchingNumberOfPolishingsLength,
		samplePacketsWithNonPolishingSolutions
	} = Map[PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				CoatedWorkingElectrode,
				NonNullPolishingPads,
				NonNullPolishingSolutions,
				NonNullNumberOfPolishingSolutionDroplets,
				NonNullNumberOfPolishings,
				MissingPolishingPads,
				MissingPolishingSolutions,
				MissingNumberOfPolishingSolutionDroplets,
				MissingNumberOfPolishings,
				MisMatchingPolishingSolutionsLength,
				MisMatchingNumberOfPolishingSolutionDropletsLength,
				MisMatchingNumberOfPolishingsLength,
				NonPolishingSolutionBool
			}
		]
	];

	(* Warnings *)
	samplePacketsWithNonDefaultPolishingSolutions = PickList[samplePackets, Lookup[resolvedWarningCheckingAssociation, NonDefaultPolishingSolutionBool]];

	(* -- Extract samplePackets that had a sonication options related problem in the MapThread -- *)
	(* Errors *)
	{
		samplePacketsWithSonicationSensitiveWorkingElectrode,
		samplePacketsWithNonNullSonicationTime,
		samplePacketsWithNonNullSonicationTemperature,
		samplePacketsWithMissingSonicationTime,
		samplePacketsWithMissingSonicationTemperature
	} = Map[PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				SonicationSensitiveWorkingElectrode,
				NonNullSonicationTime,
				NonNullSonicationTemperature,
				MissingSonicationTime,
				MissingSonicationTemperature
			}
		]
	];

	(* -- Extract samplePackets that had an electrode washing options related problem in the MapThread -- *)
	(* Errors *)
	{
		samplePacketsWithNonNullWorkingElectrodeWashingCycles,
		samplePacketsWithMissingWorkingElectrodeWashingCycles
	} = Map[PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				NonNullWorkingElectrodeWashingCycles,
				MissingWorkingElectrodeWashingCycles
			}
		]
	];

	(* -- Extract samplePackets that had a loading sample volume options related problem in the MapThread -- *)
	(* Errors *)
	{
		samplePacketsWithMismatchingSampleState,
		samplePacketsWithMismatchingReactionVesselWithElectrodeCap,
		samplePacketsWithNonNullSolventVolume,
		samplePacketsWithMissingSolventVolume,
		samplePacketsWithTooSmallSolventVolume,
		samplePacketsWithTooSmallLoadingSampleVolume,
		samplePacketsWithTooLargeLoadingSampleVolume
	} = Map[PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				MismatchingSampleStateBool,
				MismatchingReactionVesselWithElectrodeCapBool,
				NonNullSolventVolumeBool,
				MissingSolventVolumeBool,
				TooSmallSolventVolumeBool,
				TooSmallLoadingSampleVolumeBool,
				TooLargeLoadingSampleVolumeBool
			}
		]
	];


	(* -- Extract the packets that have problems related to the analyte -- *)
	{
		samplePacketsWithMissingComposition,
		samplePacketsWithMissingAnalyte,
		samplePacketsWithIncompleteComposition,
		samplePacketsWithAmbiguousAnalyte,
		samplePacketsWithMismatchingAnalyte,
		samplePacketsWithUnresolvableCompositionUnit,
		samplePacketsWithMissingSampleAmount,
		samplePacketsWithMissingLoadingSampleTargetConcentration,
		samplePacketsWithNonNullSampleAmount,
		samplePacketsWithNonNullTargetConcentration,
		samplePacketsWithMismatchingConcentrationParameters,
		samplePacketsWithTooLowLoadingSampleTargetConcentration,
		samplePacketsWithTooHighLoadingSampleTargetConcentration
	} = Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				SampleMissingCompositionBool,
				SampleMissingAnalyteBool,
				PreparedSampleIncompleteCompositionBool,
				AmbiguousAnalyteBool,
				MismatchingAnalyteBool,
				PreparedSampleWithUnresolvableCompositionUnitBool,
				MissingSampleAmountBool,
				MissingLoadingSampleTargetConcentrationBool,
				NonNullSampleAmountBool,
				NonNullTargetConcentrationBool,
				MismatchingConcentrationParametersBool,
				TooLowLoadingSampleTargetConcentrationBool,
				TooHighLoadingSampleTargetConcentrationBool
			}
		]
	];

	(* Warnings *)
	samplePacketsWithSolventVolumeLargerThanLoadingVolume = PickList[samplePackets, Lookup[resolvedWarningCheckingAssociation, SolventVolumeLargerThanLoadingVolumeBool]];

	(* -- Extract the packets that have problems related to the solvent, electrolyte, and electrolyte solution options -- *)
	{
		samplePacketsWithPreparedSampleMissingSolvent,
		samplePacketsWithSampleSolventAmbiguousMolecule,
		samplePacketsWithElectrolyteSolutionNotLiquid,
		samplePacketsWithElectrolyteSolutionMissingSolvent,
		samplePacketsWithElectrolyteSolutionMissingAnalyte,
		samplePacketsWithElectrolyteSolutionAmbiguousAnalyte,
		samplePacketsWithElectrolyteSolutionSolventAmbiguousMolecule,
		samplePacketsWithSolventNotLiquid,
		samplePacketsWithSolventAmbiguousMolecule,
		samplePacketsWithSolventMoleculeMismatchPreparedSampleSolventMolecule,
		samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMolecule,
		samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchSolventMolecule
	} =  Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				PreparedSampleMissingSolventBool,
				SampleSolventAmbiguousMoleculeBool,
				ElectrolyteSolutionNotLiquidBool,
				ElectrolyteSolutionMissingSolventBool,
				ElectrolyteSolutionMissingAnalyteBool,
				ElectrolyteSolutionAmbiguousAnalyteBool,
				ElectrolyteSolutionSolventAmbiguousMoleculeBool,
				ResolvedSolventNotLiquidBool,
				SolventAmbiguousMoleculeBool,
				SolventMoleculeMismatchPreparedSampleSolventMoleculeBool,
				ElectrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMoleculeBool,
				ElectrolyteSolutionSolventMoleculeMismatchSolventMoleculeBool
			}
		]
	];

	(* error tracker lookup is broken up for readability and maintainability *)
	{
		samplePacketsWithSampleElectrolyteMoleculeWithUnresolvableCompositionUnit,
		samplePacketsWithSampleElectrolyteMoleculeMissingMolecularWeight,
		samplePacketsWithSampleElectrolyteMoleculeMissingDefaultSampleModel,
		samplePacketsWithSampleElectrolyteMoleculeNotFound,
		samplePacketsWithSampleAmbiguousElectrolyteMolecule,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingDefaultSampleModel,
		samplePacketsWithElectrolyteSampleAmbiguousMolecule,
		samplePacketsWithElectrolyteSampleNotSolid,
		samplePacketsWithElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingMolecularWeight,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule,
		samplePacketsWithCannotAutomaticallyResolveElectrolyte,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeNotFound,
		samplePacketsWithElectrolyteSolutionAmbiguousElectrolyteMolecule,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnit,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMolecule
	} =  Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				SampleElectrolyteMoleculeWithUnresolvableCompositionUnitBool,
				SampleElectrolyteMoleculeMissingMolecularWeightBool,
				SampleElectrolyteMoleculeMissingDefaultSampleModelBool,
				SampleElectrolyteMoleculeNotFoundBool,
				SampleAmbiguousElectrolyteMoleculeBool,
				ElectrolyteSolutionElectrolyteMoleculeMissingDefaultSampleModelBool,
				ElectrolyteSampleAmbiguousMoleculeBool,
				ResolvedElectrolyteSampleNotSolidBool,
				ElectrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool,
				ElectrolyteSolutionElectrolyteMoleculeMissingMolecularWeightBool,
				ElectrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMoleculeBool,
				CannotAutomaticallyResolveElectrolyteBool,
				ElectrolyteSolutionElectrolyteMoleculeNotFoundBool,
				ElectrolyteSolutionAmbiguousElectrolyteMoleculeBool,
				ElectrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnitBool,
				ElectrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMoleculeBool
			}
		]
	];

	(* error tracker lookup is broken up for readability and maintainability *)
	{
		samplePacketsWithNonNullElectrolyteSolution,
		samplePacketsWithNonNullElectrolyteSolutionLoadingVolume,
		samplePacketsWithNonNullLoadingSampleElectrolyteAmount,
		samplePacketsWithMissingElectrolyteSolutionLoadingVolume,
		samplePacketsWithMissingElectrolyteTargetConcentration,
		samplePacketsWithMissingLoadingSampleElectrolyteAmount,
		samplePacketsWithMissingElectrolyteSolution,
		samplePacketsWithTooSmallElectrolyteSolutionLoadingVolume,
		samplePacketsWithTooLargeElectrolyteSolutionLoadingVolume,
		samplePacketsWithTooLowElectrolyteTargetConcentration,
		samplePacketsWithTooHighElectrolyteTargetConcentration,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSample,
		samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentration,
		samplePacketsWithElectrolyteTargetConcentrationMismatchPreparedSample,
		samplePacketsWithLoadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentration
	} =  Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				NonNullElectrolyteSolutionBool,
				NonNullElectrolyteSolutionLoadingVolumeBool,
				NonNullLoadingSampleElectrolyteAmountBool,
				MissingElectrolyteSolutionLoadingVolumeBool,
				MissingElectrolyteTargetConcentrationBool,
				MissingLoadingSampleElectrolyteAmountBool,
				MissingElectrolyteSolutionBool,
				TooSmallElectrolyteSolutionLoadingVolumeBool,
				TooLargeElectrolyteSolutionLoadingVolumeBool,
				TooLowElectrolyteTargetConcentrationBool,
				TooHighElectrolyteTargetConcentrationBool,
				ElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSampleBool,
				ElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentrationBool,
				ElectrolyteTargetConcentrationMismatchPreparedSampleBool,
				LoadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentrationBool
			}
		]
	];

	(* -- Extract packets that need warnings for Solvent based errors -- *)
	{
		samplePacketsWithSolventMismatchPreparedSampleSolvent,
		samplePacketsWithElectrolyteSolutionSolventMismatchSolvent
	} =  Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedWarningCheckingAssociation,
			{
				SolventMismatchPreparedSampleSolventBool,
				ElectrolyteSolutionSolventMismatchSolventBool
			}
		]
	];

	(* -- Extract the packets that have problems related to the reference electrode and reference solution options -- *)
	(* Errors *)
	{
		samplePacketsWithReferenceElectrodeUnprepared,
		samplePacketsWithReferenceElectrodeNeedRefreshRequiresRefresh,
		samplePacketsWithElectrodeReferenceSolutionInformationError,
		samplePacketsWithTooLongReferenceElectrodeSoakTime
	} =  Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				ReferenceElectrodeUnpreparedBool,
				ReferenceElectrodeNeedRefreshRequiresRefreshBool,
				ElectrodeReferenceSolutionInformationErrorBool,
				TooLongReferenceElectrodeSoakTimeBool
			}
		]
	];

	(* Warnings *)
	{
		samplePacketsWithReferenceElectrodeRecommendedSolventTypeMismatchSolvent,
		samplePacketsWithElectrodeReferenceSolutionSolventMoleculeMismatchWarning,
		samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeMismatchWarning,
		samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatchWarning
	} =  Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedWarningCheckingAssociation,
			{
				ReferenceElectrodeRecommendedSolventTypeMismatchSolventBool,
				ElectrodeReferenceSolutionSolventMoleculeMismatchWarningBool,
				ElectrodeReferenceSolutionElectrolyteMoleculeMismatchWarningBool,
				ElectrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatchWarningBool
			}
		]
	];

	(* -- Extract the packets that have problems related to the internal standard options -- *)
	{
		samplePacketsWithInternalStandardNotSolid,
		samplePacketsWithPreparedSampleInvalidCompositionLengthForNoneInternalStandard,
		samplePacketsWithResolvedInternalStandardAmbiguousMolecule,
		samplePacketsWithNonNullInternalStandardAdditionOrder,
		samplePacketsWithMissingInternalStandardAdditionOrder,
		samplePacketsWithPreparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrder,
		samplePacketsWithPreparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrder,
		samplePacketsWithInternalStandardNotACompositionMemberForPreparedSample,
		samplePacketsWithInternalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrder,
		samplePacketsWithNonNullInternalStandardTargetConcentrationForNoneInternalStandard,
		samplePacketsWithNonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSample,
		samplePacketsWithMissingInternalStandardTargetConcentrationForAfterAdditionOrder,
		samplePacketsWithMissingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSample,
		samplePacketsWithTooLowInternalStandardTargetConcentration,
		samplePacketsWithTooHighInternalStandardTargetConcentration,
		samplePacketsWithNonNullInternalStandardAmountForNoneInternalStandard,
		samplePacketsWithNonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSample,
		samplePacketsWithMissingInternalStandardAmountForAfterAdditionOrder,
		samplePacketsWithMissingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSample,
		samplePacketsWithInternalStandardAmountMismatchInternalStandardTargetConcentration
	} =  Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				InternalStandardNotSolidBool,
				PreparedSampleInvalidCompositionLengthForNoneInternalStandardBool,
				ResolvedInternalStandardAmbiguousMoleculeBool,
				NonNullInternalStandardAdditionOrderBool,
				MissingInternalStandardAdditionOrderBool,
				PreparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrderBool,
				PreparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrderBool,
				InternalStandardNotACompositionMemberForPreparedSampleBool,
				InternalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrderBool,
				NonNullInternalStandardTargetConcentrationForNoneInternalStandardBool,
				NonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSampleBool,
				MissingInternalStandardTargetConcentrationForAfterAdditionOrderBool,
				MissingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSampleBool,
				TooLowInternalStandardTargetConcentrationBool,
				TooHighInternalStandardTargetConcentrationBool,
				NonNullInternalStandardAmountForNoneInternalStandardBool,
				NonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSampleBool,
				MissingInternalStandardAmountForAfterAdditionOrderBool,
				MissingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSampleBool,
				InternalStandardAmountMismatchInternalStandardTargetConcentrationBool
			}
		]
	];

	(* -- Extract the packets that have problems related to the pretreatElectrodes options -- *)
	{
		samplePacketsWithNonNullPretreatmentSparging,
		samplePacketsWithMissingPretreatmentSparging,
		samplePacketsWithNonNullPretreatmentSpargingPreBubbler,
		samplePacketsWithMissingPretreatmentSpargingPreBubbler,
		samplePacketsWithPretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSparging,
		samplePacketsWithNonNullPretreatmentInitialPotential,
		samplePacketsWithMissingPretreatmentInitialPotential,
		samplePacketsWithNonNullPretreatmentFirstPotential,
		samplePacketsWithMissingPretreatmentFirstPotential,
		samplePacketsWithNonNullPretreatmentSecondPotential,
		samplePacketsWithMissingPretreatmentSecondPotential,
		samplePacketsWithNonNullPretreatmentFinalPotential,
		samplePacketsWithMissingPretreatmentFinalPotential,
		samplePacketsWithPretreatmentInitialPotentialNotBetweenFirstAndSecondPotentials,
		samplePacketsWithPretreatmentFinalPotentialNotBetweenFirstAndSecondPotentials,
		samplePacketsWithPretreatmentInitialAndFinalPotentialsTooDifferent,
		samplePacketsWithNonNullPretreatmentPotentialSweepRate,
		samplePacketsWithMissingPretreatmentPotentialSweepRate,
		samplePacketsWithNonNullPretreatmentNumberOfCycles,
		samplePacketsWithMissingPretreatmentNumberOfCycles
	} =  Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				NonNullPretreatmentSpargingBool,
				MissingPretreatmentSpargingBool,
				NonNullPretreatmentSpargingPreBubblerBool,
				MissingPretreatmentSpargingPreBubblerBool,
				PretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSpargingBool,
				NonNullPretreatmentInitialPotentialBool,
				MissingPretreatmentInitialPotentialBool,
				NonNullPretreatmentFirstPotentialBool,
				MissingPretreatmentFirstPotentialBool,
				NonNullPretreatmentSecondPotentialBool,
				MissingPretreatmentSecondPotentialBool,
				NonNullPretreatmentFinalPotentialBool,
				MissingPretreatmentFinalPotentialBool,
				PretreatmentInitialPotentialNotBetweenFirstAndSecondPotentialsBool,
				PretreatmentFinalPotentialNotBetweenFirstAndSecondPotentialsBool,
				PretreatmentInitialAndFinalPotentialsTooDifferentBool,
				NonNullPretreatmentPotentialSweepRateBool,
				MissingPretreatmentPotentialSweepRateBool,
				NonNullPretreatmentNumberOfCyclesBool,
				MissingPretreatmentNumberOfCyclesBool
			}
		]
	];

	(* -- Extract the packets that have problems related to the mix options -- *)
	{
		samplePacketsWithLoadingSampleMixFalseForUnpreparedSample,
		samplePacketsWithNonNullLoadingSampleMixType,
		samplePacketsWithMissingLoadingSampleMixType,
		samplePacketsWithNonNullLoadingSampleMixTemperature,
		samplePacketsWithMissingLoadingSampleMixTemperature,
		samplePacketsWithLoadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixType,
		samplePacketsWithNonNullLoadingSampleMixUntilDissolved,
		samplePacketsWithMissingLoadingSampleMixUntilDissolved,
		samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixing,
		samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolved,
		samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesForShakeMixType,
		samplePacketsWithMissingLoadingSampleMaxNumberOfMixes,
		samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixing,
		samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolved,
		samplePacketsWithNonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixType,
		samplePacketsWithMissingLoadingSampleMaxMixTime,
		samplePacketsWithNonNullLoadingSampleMixTimeWhenNotMixing,
		samplePacketsWithNonNullLoadingSampleMixTimeForPipetteOrInvertMixType,
		samplePacketsWithMissingLoadingSampleMixTime,
		samplePacketsWithLoadingSampleMixTimeGreaterThanMaxMixTime,
		samplePacketsWithNonNullLoadingSampleNumberOfMixesWhenNotMixing,
		samplePacketsWithNonNullLoadingSampleNumberOfMixesForShakeMixType,
		samplePacketsWithMissingLoadingSampleNumberOfMixes,
		samplePacketsWithLoadingSampleNumberOfMixesGreaterThanMaxNumberOfMixes,
		samplePacketsWithNonNullLoadingSampleMixVolumeWhenNotMixing,
		samplePacketsWithNonNullLoadingSampleMixVolumeForNonPipetteMixType,
		samplePacketsWithMissingLoadingSampleMixVolume,
		samplePacketsWithLoadingSampleMixVolumeGreaterThanSolventVolume
	} =  Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				LoadingSampleMixFalseForUnpreparedSampleBool,
				NonNullLoadingSampleMixTypeBool,
				MissingLoadingSampleMixTypeBool,
				NonNullLoadingSampleMixTemperatureBool,
				MissingLoadingSampleMixTemperatureBool,
				LoadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixTypeBool,
				NonNullLoadingSampleMixUntilDissolvedBool,
				MissingLoadingSampleMixUntilDissolvedBool,
				NonNullLoadingSampleMaxNumberOfMixesWhenNotMixingBool,
				NonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolvedBool,
				NonNullLoadingSampleMaxNumberOfMixesForShakeMixTypeBool,
				MissingLoadingSampleMaxNumberOfMixesBool,
				NonNullLoadingSampleMaxMixTimeWhenNotMixingBool,
				NonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolvedBool,
				NonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixTypeBool,
				MissingLoadingSampleMaxMixTimeBool,
				NonNullLoadingSampleMixTimeWhenNotMixingBool,
				NonNullLoadingSampleMixTimeForPipetteOrInvertMixTypeBool,
				MissingLoadingSampleMixTimeBool,
				LoadingSampleMixTimeGreaterThanMaxMixTimeBool,
				NonNullLoadingSampleNumberOfMixesWhenNotMixingBool,
				NonNullLoadingSampleNumberOfMixesForShakeMixTypeBool,
				MissingLoadingSampleNumberOfMixesBool,
				LoadingSampleNumberOfMixesGreaterThanMaxNumberOfMixesBool,
				NonNullLoadingSampleMixVolumeWhenNotMixingBool,
				NonNullLoadingSampleMixVolumeForNonPipetteMixTypeBool,
				MissingLoadingSampleMixVolumeBool,
				LoadingSampleMixVolumeGreaterThanSolventVolumeBool
			}
		]
	];

	(* -- Extract the packets that have problems related to the sparging options -- *)
	{
		samplePacketsWithNonNullSpargingGas,
		samplePacketsWithMissingSpargingGas,
		samplePacketsWithNonNullSpargingTime,
		samplePacketsWithMissingSpargingTime,
		samplePacketsWithTooLongSpargingTime,
		samplePacketsWithNonNullSpargingPreBubbler,
		samplePacketsWithMissingSpargingPreBubbler
	} =  Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				NonNullSpargingGasBool,
				MissingSpargingGasBool,
				NonNullSpargingTimeBool,
				MissingSpargingTimeBool,
				TooLongSpargingTimeBool,
				NonNullSpargingPreBubblerBool,
				MissingSpargingPreBubblerBool
			}
		]
	];

	(* -- Extract the packets that have problems related to the cv measurement options -- *)
	{
		samplePacketsWithInitialPotentialsLengthMismatchNumberOfCycles,
		samplePacketsWithFirstPotentialsLengthMismatchNumberOfCycles,
		samplePacketsWithSecondPotentialsLengthMismatchNumberOfCycles,
		samplePacketsWithFinalPotentialsLengthMismatchNumberOfCycles,
		samplePacketsWithPotentialSweepRatesLengthMismatchNumberOfCycles,
		samplePacketsWithInitialPotentialNotBetweenFirstAndSecondPotentials,
		samplePacketsWithFinalPotentialNotBetweenFirstAndSecondPotentials,
		samplePacketsWithInitialAndFinalPotentialsTooDifferent
	} =  Map[
		PickList[samplePackets, #]&,
		Lookup[resolvedErrorCheckingAssociation,
			{
				InitialPotentialsLengthMismatchNumberOfCyclesBool,
				FirstPotentialsLengthMismatchNumberOfCyclesBool,
				SecondPotentialsLengthMismatchNumberOfCyclesBool,
				FinalPotentialsLengthMismatchNumberOfCyclesBool,
				PotentialSweepRatesLengthMismatchNumberOfCyclesBool,
				InitialPotentialNotBetweenFirstAndSecondPotentialsBool,
				FinalPotentialNotBetweenFirstAndSecondPotentialsBool,
				InitialAndFinalPotentialsTooDifferentBool
			}
		]
	];

	(* ------------------------------ *)
	(*-- CONFLICTING OPTIONS CHECKS --*)
	(* ------------------------------ *)

	(* ==== PolishingPads, PolishingSolutions, NumberOfPolishingSolutionDroplets, NumberOfPolishings related messages, invalidOptions, and tests ==== *)

	(* -- samplePacketsWithCoatedWorkingElectrode: Message -- *)
	If[!MatchQ[samplePacketsWithCoatedWorkingElectrode,{}]&&!gatherTests,
		Message[Error::CoatedWorkingElectrode, ObjectToString[samplePacketsWithCoatedWorkingElectrode,Cache->newCache]]
	];

	(* -- samplePacketsWithMissingPolishingPads: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullPolishingPads,{}]&&!gatherTests,
		Message[Error::NonNullOption, "PolishingPads", "PolishWorkingElectrode", "False", ObjectToString[samplePacketsWithNonNullPolishingPads,Cache->newCache]]
	];

	(* -- samplePacketsWithNonNullPolishingSolutions: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullPolishingSolutions,{}]&&!gatherTests,
		Message[Error::NonNullOption, "PolishingSolutions", "PolishWorkingElectrode", "False", ObjectToString[samplePacketsWithNonNullPolishingSolutions,Cache->newCache]]
	];

	(* -- samplePacketsWithNonNullNumberOfPolishingSolutionDroplets: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullNumberOfPolishingSolutionDroplets,{}]&&!gatherTests,
		Message[Error::NonNullOption, "NumberOfPolishingSolutionDroplets", "PolishWorkingElectrode", "False", ObjectToString[samplePacketsWithNonNullNumberOfPolishingSolutionDroplets,Cache->newCache]]
	];

	(* -- samplePacketsWithNonNullNumberOfPolishings: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullNumberOfPolishings,{}]&&!gatherTests,
		Message[Error::NonNullOption, "NumberOfPolishings", "PolishWorkingElectrode", "False", ObjectToString[samplePacketsWithNonNullNumberOfPolishings,Cache->newCache]]
	];

	(* -- samplePacketsWithMissingPolishingPads: Message -- *)
	If[!MatchQ[samplePacketsWithMissingPolishingPads,{}]&&!gatherTests,
		Message[Error::MissingOption, "PolishingPads", "PolishWorkingElectrode", "True", "a list of polishing pads", ObjectToString[samplePacketsWithMissingPolishingPads,Cache->newCache]]
	];

	(* -- samplePacketsWithMissingPolishingSolutions: Message -- *)
	If[!MatchQ[samplePacketsWithMissingPolishingSolutions,{}]&&!gatherTests,
		Message[Error::MissingOption, "PolishingSolutions", "PolishWorkingElectrode", "True", "a list of polishing solutions", ObjectToString[samplePacketsWithMissingPolishingSolutions,Cache->newCache]]
	];

	(* -- samplePacketsWithMissingNumberOfPolishingSolutionDroplets: Message -- *)
	If[!MatchQ[samplePacketsWithMissingNumberOfPolishingSolutionDroplets,{}]&&!gatherTests,
		Message[Error::MissingOption, "NumberOfPolishingSolutionDroplets", "PolishWorkingElectrode", "True", "a list of integers", ObjectToString[samplePacketsWithMissingNumberOfPolishingSolutionDroplets,Cache->newCache]]
	];

	(* -- samplePacketsWithMissingNumberOfPolishings: Message -- *)
	If[!MatchQ[samplePacketsWithMissingNumberOfPolishings,{}]&&!gatherTests,
		Message[Error::MissingOption, "NumberOfPolishings", "PolishWorkingElectrode", "True", "a list of integers", ObjectToString[samplePacketsWithMissingNumberOfPolishings,Cache->newCache]]
	];

	(* -- samplePacketsWithMisMatchingPolishingSolutionsLength: Message -- *)
	If[!MatchQ[samplePacketsWithMisMatchingPolishingSolutionsLength,{}]&&!gatherTests,
		Message[Error::OptionsMismatchingLength, "PolishingSolutions", "PolishingPads", ObjectToString[samplePacketsWithMisMatchingPolishingSolutionsLength,Cache->newCache]]
	];

	(* -- samplePacketsWithMisMatchingNumberOfPolishingSolutionDropletsLength: Message -- *)
	If[!MatchQ[samplePacketsWithMisMatchingNumberOfPolishingSolutionDropletsLength,{}]&&!gatherTests,
		Message[Error::OptionsMismatchingLength, "NumberOfPolishingSolutionDroplets", "PolishingPads", ObjectToString[samplePacketsWithMisMatchingNumberOfPolishingSolutionDropletsLength,Cache->newCache]]
	];

	(* -- samplePacketsWithMisMatchingNumberOfPolishingsLength: Message -- *)
	If[!MatchQ[samplePacketsWithMisMatchingNumberOfPolishingsLength,{}]&&!gatherTests,
		Message[Error::OptionsMismatchingLength, "NumberOfPolishings", "PolishingPads", ObjectToString[samplePacketsWithMisMatchingNumberOfPolishingsLength,Cache->newCache]]
	];

	(* -- samplePacketsWithNonPolishingSolutions: Message -- *)
	(* fetch the list of solutions in PolishingSolutions that are not actual polishing solutions for each sample packet. We need to remove {False..} entries since they can be introduced in the resolver *)
	nonPolishingSolutions = Lookup[resolvedErrorCheckingAssociation, NonPolishingSolutions]/.{{False...} -> Nothing};
	If[!MatchQ[samplePacketsWithNonPolishingSolutions,{}]&&!gatherTests,
		(* throw the message for each sample, with the illegal solutions *)
		(* Important to keep the use of Off and On locally to prevent accidental Mathematica kernel crashing *)
		Off[General::stop];
		MapThread[
			Message[Error::NonPolishingSolutions, ObjectToString[#1, Cache->newCache], ObjectToString[#2, Cache->newCache]]&,
			{nonPolishingSolutions, samplePacketsWithNonPolishingSolutions}
		];
		On[General::stop];
	];


	(* -- Collect polishing parameters invalid options -- *)
	(* collect PolishWorkingElectrode if it is true and the WorkingElectrode is SonicationSensitive *)
	coatedWorkingElectrodeInvalidOptions = If[MatchQ[samplePacketsWithCoatedWorkingElectrode, Except[{}]],
		{PolishWorkingElectrode},
		{}
	];

	(* collect the non-Null polishing parameters invalid option names *)
	nonNullPolishingParametersInvalidOptions = PickList[{
		PolishingPads,
		PolishingSolutions,
		NumberOfPolishingSolutionDroplets,
		NumberOfPolishings},
		{
			MatchQ[samplePacketsWithNonNullPolishingPads, Except[{}]],
			MatchQ[samplePacketsWithNonNullPolishingSolutions, Except[{}]],
			MatchQ[samplePacketsWithNonNullNumberOfPolishingSolutionDroplets, Except[{}]],
			MatchQ[samplePacketsWithNonNullNumberOfPolishings, Except[{}]]
		},
		True
	];

	(* collect the missing polishing parameters invalid option names *)
	missingPolishingParametersInvalidOptions = PickList[{
		PolishingPads,
		PolishingSolutions,
		NumberOfPolishingSolutionDroplets,
		NumberOfPolishings},
		{
			MatchQ[samplePacketsWithMissingPolishingPads, Except[{}]],
			MatchQ[samplePacketsWithMissingPolishingSolutions, Except[{}]],
			MatchQ[samplePacketsWithMissingNumberOfPolishingSolutionDroplets, Except[{}]],
			MatchQ[samplePacketsWithMissingNumberOfPolishings, Except[{}]]
		},
		True
	];

	(* collect the mismatching length polishing parameters invalid option names *)
	mismatchingLengthPolishingParametersInvalidOptions = PickList[{
		PolishingSolutions,
		NumberOfPolishingSolutionDroplets,
		NumberOfPolishings},
		{
			MatchQ[samplePacketsWithMisMatchingPolishingSolutionsLength, Except[{}]],
			MatchQ[samplePacketsWithMisMatchingNumberOfPolishingSolutionDropletsLength, Except[{}]],
			MatchQ[samplePacketsWithMisMatchingNumberOfPolishingsLength, Except[{}]]
		},
		True
	];

	(* collect the non polishing solutions invalid option name *)
	nonPolishingSolutionsInvalidOptions = If[MatchQ[samplePacketsWithNonPolishingSolutions, Except[{}]],
		{PolishingSolutions},
		{}
	];

	(* -- Make tests for the polishing parameters -- *)
	polishingParametersGroupedErrorTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithNonNullPolishingPads,
				samplePacketsWithNonNullPolishingSolutions,
				samplePacketsWithNonNullNumberOfPolishingSolutionDroplets,
				samplePacketsWithNonNullNumberOfPolishings,
				samplePacketsWithMissingPolishingPads,
				samplePacketsWithMissingPolishingSolutions,
				samplePacketsWithMissingNumberOfPolishingSolutionDroplets,
				samplePacketsWithMissingNumberOfPolishings,
				samplePacketsWithMisMatchingPolishingSolutionsLength,
				samplePacketsWithMisMatchingNumberOfPolishingSolutionDropletsLength,
				samplePacketsWithMisMatchingNumberOfPolishingsLength,
				samplePacketsWithNonPolishingSolutions
			},
			{
				"When PolishWorkingElectrode is False, PolishingPads is set to Automatic or Null for `1`:",
				"When PolishWorkingElectrode is False, PolishingSolutions is set to Automatic or Null for `1`:",
				"When PolishWorkingElectrode is False, NumberOfPolishingSolutionDroplets is set to Automatic or Null for `1`:",
				"When PolishWorkingElectrode is False, NumberOfPolishings is set to Automatic or Null for `1`:",
				"When PolishWorkingElectrode is True, PolishingPads is set to Automatic or a provided list for `1`:",
				"When PolishWorkingElectrode is True, PolishingSolutions is set to Automatic or a provided list for `1`:",
				"When PolishWorkingElectrode is True, NumberOfPolishingSolutionDroplets is set to Automatic or a provided list for `1`:",
				"When PolishWorkingElectrode is True, NumberOfPolishings is set to Automatic or a provided list for `1`:",
				"When PolishWorkingElectrode is True, the length of the PolishingSolutions list is the same as the length of the PolishingPads list for `1`:",
				"When PolishWorkingElectrode is True, the length of the NumberOfPolishingSolutionDroplets list is the same as the length of the PolishingPads list for `1`:",
				"When PolishWorkingElectrode is True, the length of the NumberOfPolishings list is the same as the length of the PolishingPads list for `1`:",
				"When PolishWorkingElectrode is True, the entries in the PolishingSolutions are all actual polishing solution models or objects for `1`:"
			}
		}
	];

	(* -- samplePacketsWithNonDefaultPolishingSolutions: Message and Test -- *)
	(* fetch the list of solutions in PolishingSolutions that are not default polishing solutions for each sample packet. We need to remove {False..} entries since they can be introduced in the resolver *)
	nonDefaultPolishingSolutions = Lookup[resolvedWarningCheckingAssociation, NonDefaultPolishingSolutions]/.{{False...} -> Nothing};
	If[!MatchQ[samplePacketsWithNonDefaultPolishingSolutions,{}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
		(* throw the warning message for each sample, with the non default reference solutions *)
		Off[General::stop];
		MapThread[
			Message[Warning::NonDefaultPolishingSolutions, ObjectToString[#1, Cache->newCache], ObjectToString[#2, Cache->newCache]]&,
			{nonDefaultPolishingSolutions, samplePacketsWithNonDefaultPolishingSolutions}
		];
		On[General::stop];
	];

	(* make the test *)
	nonDefaultPolishingSolutionsWarningTests = cyclicVoltammetrySampleTests[gatherTests,
		Warning,
		samplePackets,
		samplePacketsWithNonDefaultPolishingSolutions,
		"The solutions specified in PolishingSolutions match the DefaultPolishingSolution in their corresponding PolishingPad for `1`:",
		newCache
	];

	(* ==== WorkingElectrodeSonicationTime, WorkingElectrodeSonicationTemperature related messages, invalidOptions, and tests ==== *)

	(* -- samplePacketsWithSonicationSensitiveWorkingElectrode: Message -- *)
	If[!MatchQ[samplePacketsWithSonicationSensitiveWorkingElectrode,{}]&&!gatherTests,
		Message[Error::SonicationSensitiveWorkingElectrode, ObjectToString[samplePacketsWithSonicationSensitiveWorkingElectrode,Cache->newCache]]
	];

	(* -- samplePacketsWithMissingPolishingPads: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullSonicationTime,{}]&&!gatherTests,
		Message[Error::NonNullOption, "WorkingElectrodeSonicationTime", "WorkingElectrodeSonication", "False", ObjectToString[samplePacketsWithNonNullSonicationTime,Cache->newCache]]
	];

	(* -- samplePacketsWithNonNullSonicationTemperature: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullSonicationTemperature,{}]&&!gatherTests,
		Message[Error::NonNullOption, "WorkingElectrodeSonicationTemperature", "WorkingElectrodeSonication", "False", ObjectToString[samplePacketsWithNonNullSonicationTemperature,Cache->newCache]]
	];

	(* -- samplePacketsWithMissingSonicationTime: Message -- *)
	If[!MatchQ[samplePacketsWithMissingSonicationTime,{}]&&!gatherTests,
		Message[Error::MissingOption, "WorkingElectrodeSonicationTime", "WorkingElectrodeSonication", "True", "a duration between 0 and 60 seconds", ObjectToString[samplePacketsWithMissingSonicationTime,Cache->newCache]]
	];

	(* -- samplePacketsWithMissingSonicationTemperature: Message -- *)
	If[!MatchQ[samplePacketsWithMissingSonicationTemperature,{}]&&!gatherTests,
		Message[Error::MissingOption, "WorkingElectrodeSonicationTemperature", "WorkingElectrodeSonication", "True", "a temperature between 25 and 69 degree Celsius", ObjectToString[samplePacketsWithMissingSonicationTemperature,Cache->newCache]]
	];

	(* -- Collect sonication parameters invalid options -- *)
	(* collect WorkingElectrodeSonication if it is true and the WorkingElectrode is SonicationSensitive *)
	sonicationSensitiveWorkingElectrodeInvalidOptions = If[MatchQ[samplePacketsWithSonicationSensitiveWorkingElectrode, Except[{}]],
		{WorkingElectrodeSonication},
		{}
	];

	(* collect the non-Null sonication parameters invalid option names *)
	nonNullSonicationParametersInvalidOptions = PickList[{
		WorkingElectrodeSonicationTime,
		WorkingElectrodeSonicationTemperature
		},
		{
			MatchQ[samplePacketsWithNonNullSonicationTime, Except[{}]],
			MatchQ[samplePacketsWithNonNullSonicationTemperature, Except[{}]]
		},
		True
	];

	(* collect the missing sonication parameters invalid option names *)
	missingSonicationParametersInvalidOptions = PickList[{
		WorkingElectrodeSonicationTime,
		WorkingElectrodeSonicationTemperature
	},
		{
			MatchQ[samplePacketsWithMissingSonicationTime, Except[{}]],
			MatchQ[samplePacketsWithMissingSonicationTemperature, Except[{}]]
		},
		True
	];

	(* -- Make tests for the sonication parameters -- *)
	sonicationParametersGroupedErrorTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithSonicationSensitiveWorkingElectrode,
				samplePacketsWithNonNullSonicationTime,
				samplePacketsWithNonNullSonicationTemperature,
				samplePacketsWithMissingSonicationTime,
				samplePacketsWithMissingSonicationTemperature
			},
			{
				"When WorkingElectrode's SonicationSensitive field is True, WorkingElectrodeSonication is set to False for `1`:",
				"When WorkingElectrodeSonication is False, WorkingElectrodeSonicationTime is set to Automatic or Null for `1`:",
				"When WorkingElectrodeSonication is False, WorkingElectrodeSonicationTemperature is set to Automatic or Null for `1`:",
				"When WorkingElectrodeSonication is True, WorkingElectrodeSonicationTime is set to Automatic or a provided list for `1`:",
				"When WorkingElectrodeSonication is True, WorkingElectrodeSonicationTemperature is set to Automatic or a provided list for `1`:"
			}
		}
	];

	(* ==== WorkingElectrodeWashing, CounterElectrodeWashing, WorkingElectrodeWashingCycles related messages, invalidOptions, and tests ==== *)

	(* -- samplePacketsWithNonNullWorkingElectrodeWashingCycles: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullWorkingElectrodeWashingCycles,{}]&&!gatherTests,
		Message[Error::NonNullOption, "WorkingElectrodeWashingCycles", "WorkingElectrodeWashing", "False", ObjectToString[samplePacketsWithNonNullWorkingElectrodeWashingCycles,Cache->newCache]]
	];

	(* -- samplePacketsWithMissingWorkingElectrodeWashingCycles: Message -- *)
	If[!MatchQ[samplePacketsWithMissingWorkingElectrodeWashingCycles,{}]&&!gatherTests,
		Message[Error::MissingOption, "WorkingElectrodeWashingCycles", "WorkingElectrodeWashing", "True", "an integer", ObjectToString[samplePacketsWithMissingWorkingElectrodeWashingCycles,Cache->newCache]]
	];

	(* -- Collect electrode washing parameters invalid options -- *)
	(* collect the non-Null WorkingElectrodeWashingCycles invalid option *)
	nonNullWorkingElectrodeWashingCyclesInvalidOptions = If[MatchQ[samplePacketsWithNonNullWorkingElectrodeWashingCycles, Except[{}]],
		{WorkingElectrodeWashingCycles},
		{}
	];

	(* collect the missing WorkingElectrodeWashingCycles invalid option *)
	missingWorkingElectrodeWashingCyclesInvalidOptions = If[MatchQ[samplePacketsWithMissingWorkingElectrodeWashingCycles, Except[{}]],
		{WorkingElectrodeWashingCycles},
		{}
	];

	(* -- Make tests for the WorkingElectrodeWashingCycles option -- *)
	electrodeWashingGroupedErrorTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithNonNullWorkingElectrodeWashingCycles,
				samplePacketsWithMissingWorkingElectrodeWashingCycles
			},
			{
				"When WorkingElectrodeWashing is set to False, WorkingElectrodeSonication is set to Automatic or Null for `1`:",
				"When WorkingElectrodeWashing is set to True, WorkingElectrodeSonication is set to Automatic or an integer for `1`:"
			}
		}
	];

	(* ==== PreparedSample, LoadingSampleVolume, SolventVolume related messages, invalidOptions, and tests ==== *)

	(* -- samplePacketsWithMismatchingSampleState: Message -- *)
	If[!MatchQ[samplePacketsWithMismatchingSampleState,{}]&&!gatherTests,
		Message[Error::MismatchingSampleState, ObjectToString[samplePacketsWithMismatchingSampleState,Cache->newCache]]
	];

	(* -- samplePacketsWithMismatchingReactionVesselWithElectrodeCap: Message -- *)
	If[!MatchQ[samplePacketsWithMismatchingReactionVesselWithElectrodeCap,{}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The specified reaction vessel and the electrode cap are incompatible", "make sure the outer diameter of the specified reaction vessel's \"Electrode Cap Port\" is identical with the inner diameter of the electrode cap's \"Reaction Vessel Port\"", ObjectToString[samplePacketsWithMismatchingReactionVesselWithElectrodeCap,Cache->newCache]]
	];

	(* -- samplePacketsWithNonNullSolventVolume: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullSolventVolume,{}]&&!gatherTests,
		Message[Error::NonNullOption, "SolventVolume", "PreparedSample", "True", ObjectToString[samplePacketsWithNonNullSolventVolume,Cache->newCache]]
	];

	(* -- samplePacketsWithMissingSolventVolume: Message -- *)
	If[!MatchQ[samplePacketsWithMissingSolventVolume,{}]&&!gatherTests,
		Message[Error::MissingOption, "SolventVolume", "PreparedSample", "False", "a volume between 30% and 90% of the ReactionVessel MaxVolume and also no less than the LoadingSampleVolume", ObjectToString[samplePacketsWithMissingSolventVolume,Cache->newCache]]
	];

	(* -- get the lists of loading sample volumes, solvent volumes and reaction vessel max volumes for the following messages -- *)
	solventVolumes = Lookup[resolvedOptionsAssociation, SolventVolume];
	loadingSampleVolumes = Lookup[resolvedOptionsAssociation, LoadingSampleVolume];
	reactionVesselMaxVolumes = Lookup[resolvedErrorCheckingAssociation, ReactionVesselMaxVolume];

	(* -- samplePacketsWithTooSmallSolventVolume: Message -- *)
	(* fetch the lists of loading sample volumes, solvent volumes and reaction vessel max volumes for each sample packet with too small solvent volume. *)
	indicesForTooSmallSolventVolume = Lookup[resolvedErrorCheckingAssociation, TooSmallSolventVolumeBool];
	solventVolumesForTooSmallSolventVolume = PickList[solventVolumes, indicesForTooSmallSolventVolume];
	reactionVesselMaxVolumesForTooSmallSolventVolume = PickList[reactionVesselMaxVolumes, indicesForTooSmallSolventVolume];
	loadingSampleVolumesForTooSmallSolventVolume = PickList[loadingSampleVolumes, indicesForTooSmallSolventVolume];

	If[!MatchQ[samplePacketsWithTooSmallSolventVolume,{}]&&!gatherTests,
		(* throw the message for each sample, with the solvent volumes, reaction vessel max volumes, and loading sample volumes *)
		Off[General::stop];
		MapThread[
			Message[Error::TooSmallSolventVolume, ObjectToString[#1, Cache->newCache], ObjectToString[#2, Cache->newCache], ObjectToString[#3, Cache->newCache], ObjectToString[#4, Cache->newCache]]&,
			{solventVolumesForTooSmallSolventVolume, reactionVesselMaxVolumesForTooSmallSolventVolume, loadingSampleVolumesForTooSmallSolventVolume, samplePacketsWithTooSmallSolventVolume}
		];
		On[General::stop];
	];

	(* -- samplePacketsWithTooSmallLoadingSampleVolume: Message -- *)
	(* fetch the lists of loading sample volumes and reaction vessel max volumes for each sample packet with too small loading sample volume. *)
	indicesForTooSmallLoadingSampleVolume = Lookup[resolvedErrorCheckingAssociation, TooSmallLoadingSampleVolumeBool];
	loadingSampleVolumesForTooSmallLoadingSampleVolume = PickList[loadingSampleVolumes, indicesForTooSmallLoadingSampleVolume];
	reactionVesselMaxVolumesForTooSmallLoadingSampleVolume = PickList[reactionVesselMaxVolumes, indicesForTooSmallLoadingSampleVolume];

	If[!MatchQ[samplePacketsWithTooSmallLoadingSampleVolume,{}]&&!gatherTests,
		(* throw the message for each sample, with the loading sample volumes and reaction vessel max volumes *)
		Off[General::stop];
		MapThread[
			Message[Error::TooSmallVolume, "LoadingSampleVolume", ObjectToString[#1, Cache->newCache], "ReactionVessel MaxVolume", ObjectToString[#2, Cache->newCache], "a volume between 30% and 90% of the ReactionVessel MaxVolume", ObjectToString[#3, Cache->newCache]]&,
			{loadingSampleVolumesForTooSmallLoadingSampleVolume, reactionVesselMaxVolumesForTooSmallLoadingSampleVolume, samplePacketsWithTooSmallLoadingSampleVolume}
		];
		On[General::stop];
	];

	(* -- samplePacketsWithTooLargeLoadingSampleVolume: Message -- *)
	(* fetch the lists of loading sample volumes and reaction vessel max volumes for each sample packet with too large loading sample volume. *)
	indicesForTooLargeLoadingSampleVolume = Lookup[resolvedErrorCheckingAssociation, TooLargeLoadingSampleVolumeBool];
	loadingSampleVolumesForTooLargeLoadingSampleVolume = PickList[loadingSampleVolumes, indicesForTooLargeLoadingSampleVolume];
	reactionVesselMaxVolumesForTooLargeLoadingSampleVolume = PickList[reactionVesselMaxVolumes, indicesForTooLargeLoadingSampleVolume];

	If[!MatchQ[samplePacketsWithTooLargeLoadingSampleVolume,{}]&&!gatherTests,
		(* throw the message for each sample, with the loading sample volumes and reaction vessel max volumes *)
		Off[General::stop];
		MapThread[
			Message[Error::TooLargeVolume, "LoadingSampleVolume", ObjectToString[#1, Cache->newCache], "ReactionVessel MaxVolume", ObjectToString[#2, Cache->newCache], "a volume between 30% and 90% of the ReactionVessel MaxVolume", ObjectToString[#3, Cache->newCache]]&,
			{loadingSampleVolumesForTooLargeLoadingSampleVolume, reactionVesselMaxVolumesForTooLargeLoadingSampleVolume, samplePacketsWithTooLargeLoadingSampleVolume}
		];
		On[General::stop];
	];

	(* -- Collect loading sample volume parameters invalid options -- *)
	(* collect the conflicting PreparedSample invalid option *)
	mismatchingSampleStateInvalidOptions = If[MatchQ[samplePacketsWithMismatchingSampleState, Except[{}]],
		{PreparedSample},
		{}
	];

	(* collect the mismatching reaction vessel and electrode cap invalid option *)
	mismatchingReactionVesselWithElectrodeCapInvalidOptions = If[MatchQ[samplePacketsWithMismatchingReactionVesselWithElectrodeCap, Except[{}]],
		{ReactionVessel, ElectrodeCap},
		{}
	];

	(* collect the NonNull and TooSmall SolventVolume invalid option *)
	solventVolumeInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullSolventVolume, Except[{}]],
			MatchQ[samplePacketsWithTooSmallSolventVolume, Except[{}]],
			MatchQ[samplePacketsWithMissingSolventVolume, Except[{}]]
		],
		{SolventVolume},
		{}
	];

	(* collect the TooSmall and TooLarge LoadingSampleVolume invalid option *)
	loadingSampleVolumeInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithTooSmallLoadingSampleVolume, Except[{}]],
			MatchQ[samplePacketsWithTooLargeLoadingSampleVolume, Except[{}]]
		],
		{LoadingSampleVolume},
		{}
	];

	(* -- Make error tests for the loading sample volumes option -- *)
	loadingSampleVolumesGroupedErrorTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithMismatchingSampleState,
				samplePacketsWithMismatchingReactionVesselWithElectrodeCap,
				samplePacketsWithNonNullSolventVolume,
				samplePacketsWithTooSmallSolventVolume,
				samplePacketsWithTooSmallLoadingSampleVolume,
				samplePacketsWithTooLargeLoadingSampleVolume
			},
			{
				"PreparedSample is False for solid input samples and PreparedSample is True for liquid input samples for `1`:",
				"The specified reaction vessel and the electrode cap are compatible for `1`:",
				"When PreparedSample is set to True, SolventVolume is set to Automatic or to Null for `1`:",
				"When PreparedSample is set to False, SolventVolume is greater than 30% of the ReactionVessel MaxVolume and no less than the LoadingSampleVolume for `1`:",
				"When PreparedSample is set to False, LoadingSampleVolume is greater than 30% of the ReactionVessel MaxVolume and no less than the LoadingSampleVolume for `1`:",
				"When PreparedSample is set to False, LoadingSampleVolume is less than 90% of the ReactionVessel MaxVolume and no less than the LoadingSampleVolume for `1`:"
			}
		}
	];

	(* -- samplePacketsWithSolventVolumeLargerThanLoadingVolume: Message and Test -- *)
	(* fetch the lists of loading sample volumes, solvent volumes and reaction vessel max volumes for each sample packet with too small solvent volume. *)
	indicesForSolventVolumeLargerThanLoadingSampleVolume = Lookup[resolvedWarningCheckingAssociation, SolventVolumeLargerThanLoadingVolumeBool];
	solventVolumesForSolventVolumeLargerThanLoadingSampleVolume = PickList[solventVolumes, indicesForSolventVolumeLargerThanLoadingSampleVolume];
	loadingSampleVolumesForSolventVolumeLargerThanLoadingSampleVolume = PickList[loadingSampleVolumes, indicesForSolventVolumeLargerThanLoadingSampleVolume];

	If[!MatchQ[samplePacketsWithSolventVolumeLargerThanLoadingVolume,{}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
		(* throw the warning message for each sample, with the solvent volumes, reaction vessel max volumes, and loading sample volumes *)
		Off[General::stop];
		MapThread[
			Message[Warning::ExcessiveSolventVolume, ObjectToString[#1, Cache->newCache], ObjectToString[#2, Cache->newCache], ObjectToString[#3, Cache->newCache]]&,
			{solventVolumesForSolventVolumeLargerThanLoadingSampleVolume, loadingSampleVolumesForSolventVolumeLargerThanLoadingSampleVolume, samplePacketsWithSolventVolumeLargerThanLoadingVolume}
		];
		On[General::stop];
	];

	(* make the test *)
	solventVolumeLargerThanLoadingSampleVolumeTests = cyclicVoltammetrySampleTests[gatherTests,
		Warning,
		samplePackets,
		samplePacketsWithSolventVolumeLargerThanLoadingVolume,
		"The SolventVolume is no greater than the LoadingSampleVolume for `1`:",
		newCache
	];


	(* ==== Analyte related related messages, invalidOptions, and tests ==== *)

	(* -- Error Messages for Analyte/Composition issues -- *)

	(* -- error for missing composition -- *)
	If[!MatchQ[samplePacketsWithMissingComposition,{}]&&!gatherTests,
		Message[Error::MissingInformation, "The Composition field is not populated", "fill out the Composition field for these input samples", ObjectToString[samplePacketsWithMissingComposition,Cache->newCache]]
	];

	(* -- error for incomplete sample composition -- *)
	If[!MatchQ[samplePacketsWithIncompleteComposition,{}]&&!gatherTests,
		Message[Error::MissingInformation, "The Composition field has less than 3 entries", "make sure the Composition field has at least 3 entries, which corresponds to the target analyte, a solvent and an electrolyte, for these prepared liquid samples. All liquid samples resolve to PreparedSample True and require the Composition field of the sample to have at least 3 entries.", ObjectToString[samplePacketsWithIncompleteComposition,Cache->newCache]]
	];

	(* -- error for missing analyte -- *)
	If[!MatchQ[samplePacketsWithMissingAnalyte,{}]&&!gatherTests,
		Message[Error::MissingInformation, "The Analytes field is not populated", "fill out the Analytes field for these input samples. This experiment is highly dependent on the Analytes indicative of the relevant species that is redox-active within the potential window being scanned. ", ObjectToString[samplePacketsWithMissingAnalyte,Cache->newCache]]
	];

	(* -- error for ambiguous analyte -- *)
	If[!MatchQ[samplePacketsWithAmbiguousAnalyte,{}]&&!gatherTests,
		Message[Error::AmbiguousComposition, "The target analyte has a composition unit that is not in Molar units or MassConcentration units (Milligram/Liter, Milligram/Milliliter, etc.) in the Analytes field", "change the target analyte's composition unit to Molar units or MassConcentration units", ObjectToString[samplePacketsWithAmbiguousAnalyte,Cache->newCache]]
	];

	(* -- error for mismatching analyte -- *)
	If[!MatchQ[samplePacketsWithMismatchingAnalyte,{}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The chemical specified in the Analyte option does not match with the only entry of the Analytes field", "make sure the Analyte option is set to Automatic or is pointed to the target analyte (which is contained the input samples' Analytes field) for these input samples", ObjectToString[samplePacketsWithMismatchingAnalyte,Cache->newCache]]
	];

	(* -- error for sample analyte unresolvable unit -- *)
	If[!MatchQ[samplePacketsWithUnresolvableCompositionUnit,{}]&&!gatherTests,
		Message[Error::UnresolvableUnit, "The target analyte has a composition unit that is not in Molar units or MassConcentration units (Milligram/Liter, Milligram/Milliliter, etc.) in the Analytes field", "change the target analyte's composition unit to Molar units or MassConcentration units", ObjectToString[samplePacketsWithUnresolvableCompositionUnit,Cache->newCache]]
	];

	(* -- Error for missing sample amount -- *)
	If[!MatchQ[samplePacketsWithMissingSampleAmount,{}]&&!gatherTests,
		Message[Error::MissingOptionUnpreparedSample, "SampleAmount", "a mass quantity", ObjectToString[samplePacketsWithMissingSampleAmount,Cache->newCache]]
	];

	(* -- Error for missing loading sample target concentration -- *)
	If[!MatchQ[samplePacketsWithMissingLoadingSampleTargetConcentration,{}]&&!gatherTests,
		Message[Error::MissingOptionUnpreparedSample, "LoadingSampleTargetConcentration", "a concentration quantity", ObjectToString[samplePacketsWithMissingLoadingSampleTargetConcentration,Cache->newCache]]
	];

	(* -- Error for not null sample amount -- *)
	If[!MatchQ[samplePacketsWithNonNullSampleAmount,{}]&&!gatherTests,
		Message[Error::SpecifiedOptionPreparedSample, "SampleAmount", ObjectToString[samplePacketsWithNonNullSampleAmount,Cache->newCache]]
	];

	(* -- Error for non null loading concentration -- *)
	If[!MatchQ[samplePacketsWithNonNullTargetConcentration,{}]&&!gatherTests,
		Message[Error::SpecifiedOptionPreparedSample, "LoadingSampleTargetConcentration", ObjectToString[samplePacketsWithNonNullTargetConcentration,Cache->newCache]]
	];

	(* -- Error for mismatched concentration parameters -- *)
	If[!MatchQ[samplePacketsWithMismatchingConcentrationParameters,{}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The specified SampleAmount and LoadingSampleTargetConcentration do not match given the SolventVolume", "set one of them to Automatic or specify matching quantities for these two options", ObjectToString[samplePacketsWithMismatchingConcentrationParameters,Cache->newCache]]
	];

	(* -- Error for too low concentration -- *)
	If[!MatchQ[samplePacketsWithTooLowLoadingSampleTargetConcentration,{}]&&!gatherTests,
		Message[Error::TooLowConcentration, "The specified SampleAmount or LoadingSampleTargetConcentration leads to an analyte concentration lower than 1 Millimolar (or equivalent mass concentration)", "increase the specified SampleAmount or LoadingSampleTargetConcentration and make sure the analyte concentration is between 1 Millimolar and 15 Millimolar", ObjectToString[samplePacketsWithTooLowLoadingSampleTargetConcentration,Cache->newCache]]
	];

	(* -- Error for too high concentration -- *)
	If[!MatchQ[samplePacketsWithTooHighLoadingSampleTargetConcentration,{}]&&!gatherTests,
		Message[Error::TooHighConcentration, "The specified SampleAmount or LoadingSampleTargetConcentration leads to an analyte concentration higher than 15 Millimolar (or equivalent mass concentration)", "decrease the specified SampleAmount or LoadingSampleTargetConcentration and make sure the analyte concentration is between 1 Millimolar and 15 Millimolar", ObjectToString[samplePacketsWithTooHighLoadingSampleTargetConcentration,Cache->newCache]]
	];

	(* -- collect invalid inputs related to Analyte/Composition errors -- *)
	missingCompositionInvalidInputs = If[MatchQ[samplePacketsWithMissingComposition, {}],
		{},
		Lookup[samplePacketsWithMissingComposition, Object]
	];

	missingAnalyteInvalidInputs = If[MatchQ[samplePacketsWithMissingAnalyte, {}],
		{},
		Lookup[samplePacketsWithMissingAnalyte, Object]
	];

	IncompleteCompositionInvalidInputs = If[MatchQ[samplePacketsWithIncompleteComposition, {}],
		{},
		Lookup[samplePacketsWithIncompleteComposition, Object]
	];

	ambiguousAnalyteInvalidInputs = If[MatchQ[samplePacketsWithAmbiguousAnalyte, {}],
		{},
		Lookup[samplePacketsWithAmbiguousAnalyte, Object]
	];

	unresolvableCompositionUnitInvalidInputs = If[MatchQ[samplePacketsWithUnresolvableCompositionUnit, {}],
		{},
		Lookup[samplePacketsWithUnresolvableCompositionUnit, Object]
	];

	(* -- collect invalid options related to Analyte/Composition errors -- *)
	(* determine if the Analyte option has an invalid value or could not be resolved because of missing or malformed fields *)
	analyteInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithMismatchingAnalyte, Except[{}]]
		],
		{Analyte},
		{}
	];

	(* determine if the SampleAmount option has an invalid value or could not be resolved *)
	sampleAmountInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithMissingSampleAmount, Except[{}]],
			MatchQ[samplePacketsWithNonNullSampleAmount, Except[{}]],
			MatchQ[samplePacketsWithMismatchingConcentrationParameters, Except[{}]]
		],
		{SampleAmount},
		{}
	];

	(* determine if the SampleAmount option has an invalid value or could not be resolved *)
	loadingSampleTargetConcentrationInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithMissingLoadingSampleTargetConcentration, Except[{}]],
			MatchQ[samplePacketsWithNonNullTargetConcentration, Except[{}]],
			MatchQ[samplePacketsWithTooLowLoadingSampleTargetConcentration, Except[{}]],
			MatchQ[samplePacketsWithTooHighLoadingSampleTargetConcentration, Except[{}]],
			MatchQ[samplePacketsWithMismatchingConcentrationParameters, Except[{}]]
		],
		{TargetConcentration},
		{}
	];

	(* -- Make tests for the analyte options -- *)

	analyteOptionsGroupedErrorTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithMissingComposition,
				samplePacketsWithMissingAnalyte,
				samplePacketsWithIncompleteComposition,
				samplePacketsWithAmbiguousAnalyte,
				samplePacketsWithMismatchingAnalyte,
				samplePacketsWithUnresolvableCompositionUnit,
				samplePacketsWithMissingSampleAmount,
				samplePacketsWithMissingLoadingSampleTargetConcentration,
				samplePacketsWithNonNullSampleAmount,
				samplePacketsWithNonNullTargetConcentration,
				samplePacketsWithMismatchingConcentrationParameters,
				samplePacketsWithTooLowLoadingSampleTargetConcentration,
				samplePacketsWithTooHighLoadingSampleTargetConcentration
			},
			{
				"The Composition field is informed for `1`:",
				"Prepared liquid input samples have at least 3 entries in their Composition field for `1`:",
				"The Analytes field is informed for `1`:",
				"The Analytes field has only one entry for `1`:",
				"The chemical specified in the Analyte options match with the only entry in the sample's Analytes field for `1`:",
				"The only entry in the sample's Analytes field has a molar concentration unit or a mass concentration unit for `1`:",
				"The SampleAmount option is not resolved to Null for unprepared solid input sample for `1`:",
				"The LoadingSampleTargetConcentration option is not resolved to Null for unprepared solid input sample for `1`:",
				"The SampleAmount option is resolved to Null for prepared liquid input sample for `1`:",
				"The LoadingSampleTargetConcentration option is resolved to Null for prepared liquid input sample for `1`:",
				"The SampleAmount and LoadingSampleTargetConcentration agree for `1`:",
				"The LoadingSampleTargetConcentration is greater than or equal to 1 Millimolar for `1`:",
				"The LoadingSampleTargetConcentration is less than or equal to 15 Millimolar for `1`:"
			}
		}
	];


	(* ==== Solvent, Electrolyte, and ElectrolyteSolution related related messages, invalidOptions, and tests ==== *)

	(* INVALID INPUTS *)
	preparedSampleMissingSolventInvalidInputs = If[MatchQ[samplePacketsWithPreparedSampleMissingSolvent, {}],
		{},
		Lookup[samplePacketsWithPreparedSampleMissingSolvent, Object]
	];

	preparedSampleSolventAmbiguousMoleculeInvalidInputs = If[MatchQ[samplePacketsWithSampleSolventAmbiguousMolecule, {}],
		{},
		Lookup[samplePacketsWithSampleSolventAmbiguousMolecule, Object]
	];

	preparedSampleElectrolyteMoleculeWithUnresolvableCompositionUnitInvalidInputs = If[MatchQ[samplePacketsWithSampleElectrolyteMoleculeWithUnresolvableCompositionUnit, {}],
		{},
		Lookup[samplePacketsWithSampleElectrolyteMoleculeWithUnresolvableCompositionUnit, Object]
	];

	preparedSampleElectrolyteMoleculeMissingMolecularWeightInvalidInputs = If[MatchQ[samplePacketsWithSampleElectrolyteMoleculeMissingMolecularWeight, {}],
		{},
		Lookup[samplePacketsWithSampleElectrolyteMoleculeMissingMolecularWeight, Object]
	];

	preparedSampleElectrolyteMoleculeMissingDefaultModelSampleInvalidInputs = If[MatchQ[samplePacketsWithSampleElectrolyteMoleculeMissingDefaultSampleModel, {}],
		{},
		Lookup[samplePacketsWithSampleElectrolyteMoleculeMissingDefaultSampleModel, Object]
	];

	preparedSampleElectrolyteMoleculeNotFoundInvalidInputs = If[MatchQ[samplePacketsWithSampleElectrolyteMoleculeNotFound, {}],
		{},
		Lookup[samplePacketsWithSampleElectrolyteMoleculeNotFound, Object]
	];

	preparedSampleAmbiguousElectrolyteMoleculeInvalidInputs = If[MatchQ[samplePacketsWithSampleAmbiguousElectrolyteMolecule, {}],
		{},
		Lookup[samplePacketsWithSampleAmbiguousElectrolyteMolecule, Object]
	];


	(* INVALID OPTIONS *)
	(* determine if the Solvent option has an invalid value or could not be resolved *)
	solventInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithSolventNotLiquid, Except[{}]],
			MatchQ[samplePacketsWithSolventAmbiguousMolecule, Except[{}]],
			MatchQ[samplePacketsWithSolventMoleculeMismatchPreparedSampleSolventMolecule, Except[{}]]
		],
		{Solvent},
		{}
	];

	(* determine if the Electrolyte option has an invalid value or could not be resolved *)
	electrolyteInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithElectrolyteSampleNotSolid, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSampleAmbiguousMolecule, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule, Except[{}]],
			MatchQ[samplePacketsWithCannotAutomaticallyResolveElectrolyte, Except[{}]]
		],
		{Electrolyte},
		{}
	];

	(* determine if the ElectrolyteSolution option has an invalid value or could not be resolved *)
	electrolyteSolutionInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithElectrolyteSolutionNotLiquid, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionMissingSolvent, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionMissingAnalyte, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionAmbiguousAnalyte, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionSolventAmbiguousMolecule, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMolecule, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchSolventMolecule, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingDefaultSampleModel, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingMolecularWeight, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeNotFound, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionAmbiguousElectrolyteMolecule, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnit, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMolecule, Except[{}]],
			MatchQ[samplePacketsWithNonNullElectrolyteSolution, Except[{}]],
			MatchQ[samplePacketsWithMissingElectrolyteSolution, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSample, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentration, Except[{}]]
		],
		{ElectrolyteSolution},
		{}
	];

	(* determine if the ElectrolyteSolutionLoadingVolume option has an invalid value or could not be resolved *)
	electrolyteSolutionLoadingVolumeInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullElectrolyteSolutionLoadingVolume, Except[{}]],
			MatchQ[samplePacketsWithMissingElectrolyteSolutionLoadingVolume, Except[{}]],
			MatchQ[samplePacketsWithTooSmallElectrolyteSolutionLoadingVolume, Except[{}]],
			MatchQ[samplePacketsWithTooLargeElectrolyteSolutionLoadingVolume, Except[{}]]
		],
		{ElectrolyteSolutionLoadingVolume},
		{}
	];

	(* determine if the LoadingSampleElectrolyteAmount option has an invalid value or could not be resolved *)
	loadingSampleElectrolyteAmountInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullLoadingSampleElectrolyteAmount, Except[{}]],
			MatchQ[samplePacketsWithMissingLoadingSampleElectrolyteAmount, Except[{}]],
			MatchQ[samplePacketsWithLoadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentration, Except[{}]]
		],
		{LoadingSampleElectrolyteAmount},
		{}
	];

	(* determine if the ElectrolyteTargetConcentration option has an invalid value or could not be resolved *)
	electrolyteTargetConcentrationInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithMissingElectrolyteTargetConcentration, Except[{}]],
			MatchQ[samplePacketsWithTooLowElectrolyteTargetConcentration, Except[{}]],
			MatchQ[samplePacketsWithTooHighElectrolyteTargetConcentration, Except[{}]],
			MatchQ[samplePacketsWithElectrolyteTargetConcentrationMismatchPreparedSample, Except[{}]],
			MatchQ[samplePacketsWithLoadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentration, Except[{}]]
		],
		{ElectrolyteTargetConcentration},
		{}
	];

	(* -- TESTS -- *)
	(* -- Make tests for warnings related to the electrolyte solution and solvent -- *)
	solventAndElectrolyteOptionsGroupedWarningTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Warning,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithSolventMismatchPreparedSampleSolvent,
				samplePacketsWithElectrolyteSolutionSolventMismatchSolvent
			},
			{
				"The Solvent chemical is the same with the solvent chemical used to prepared the liquid input sample for `1`:",
				"The solvent chemical used to prepare the ElectrolyteSolution is the same with the Solvent chemical for `1`:"
			}
		}
	];

	(* -- Generate tests for solvent/electrolyte/prepared sample errors -- *)
	(* the test generation is batched for readability and easy of use, this is the first batch *)
	solventAndElectrolyteTestsGroup1 = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithPreparedSampleMissingSolvent,
				samplePacketsWithSampleSolventAmbiguousMolecule,
				samplePacketsWithElectrolyteSolutionNotLiquid,
				samplePacketsWithElectrolyteSolutionMissingSolvent,
				samplePacketsWithElectrolyteSolutionMissingAnalyte,
				samplePacketsWithElectrolyteSolutionAmbiguousAnalyte,
				samplePacketsWithElectrolyteSolutionSolventAmbiguousMolecule,
				samplePacketsWithSolventNotLiquid,
				samplePacketsWithSolventAmbiguousMolecule,
				samplePacketsWithSolventMoleculeMismatchPreparedSampleSolventMolecule,
				samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMolecule,
				samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchSolventMolecule
			},
			{
				"The Solvent field of the prepared liquid input sample is informed for `1`:",
				"The solvent chemical used to prepare the liquid input sample has only one non-Null entry in its Composition field for `1`:",
				"The ElectrolyteSolution is a liquid for `1`:",
				"The Solvent field of the ElectrolyteSolution is informed for `1`:",
				"The Analytes field of the ElectrolyteSolution is informed for `1`:",
				"The Analytes field of the ElectrolyteSolution has only one entry for `1`:",
				"The solvent chemical used to prepare the ElectrolyteSolution has only one non-Null entry in its Composition field for `1`:",
				"The Solvent is a liquid for `1`:",
				"The Solvent has only one non-Null entry in its Composition field for `1`:",
				"The solvent molecule specified by Solvent option matches with the solvent molecule specified by the prepared liquid input sample for `1`:",
				"The solvent molecule specified by ElectrolyteSolution option matches with the solvent molecule specified by the prepared liquid input sample for `1`:",
				"The solvent molecule specified by ElectrolyteSolution option matches with the solvent molecule specified by the Solvent option for `1`:"
			}
		}
	];

	(* more tests related to solvents, electrolytes, and prepared samples *)
	(* test generation is grouped for readability and maintainability *)
	solventAndElectrolyteTestsGroup2 = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithSampleElectrolyteMoleculeWithUnresolvableCompositionUnit,
				samplePacketsWithSampleElectrolyteMoleculeMissingMolecularWeight,
				samplePacketsWithSampleElectrolyteMoleculeMissingDefaultSampleModel,
				samplePacketsWithSampleElectrolyteMoleculeNotFound,
				samplePacketsWithSampleAmbiguousElectrolyteMolecule,
				samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingDefaultSampleModel,
				samplePacketsWithElectrolyteSampleAmbiguousMolecule,
				samplePacketsWithElectrolyteSampleNotSolid,
				samplePacketsWithElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule,
				samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingMolecularWeight,
				samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule,
				samplePacketsWithCannotAutomaticallyResolveElectrolyte,
				samplePacketsWithElectrolyteSolutionElectrolyteMoleculeNotFound,
				samplePacketsWithElectrolyteSolutionAmbiguousElectrolyteMolecule,
				samplePacketsWithElectrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnit,
				samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMolecule
			},
			{
				"The electrolyte molecule entry in the Composition field of the prepared liquid input sample has a composition unit of molar units or mass concentration units for `1`:",
				"The electrolyte molecule specified by the prepared liquid input sample has its MolecularWeight defined for `1`:",
				"The electrolyte molecule specified by the prepared liquid input sample has its DefaultSampleModel defined for `1`:",
				"The electrolyte molecule specified by the Electrolyte option or ElectrolyteSolution option can be found in the prepared liquid input sample for `1`:",
				"The electrolyte molecule specified by the Electrolyte option or ElectrolyteSolution option has only one entry in the Composition field of the prepared liquid input sample for `1`:",
				"The electrolyte molecule specified by the ElectrolyteSolution has its DefaultSampleModel defined for `1`:",
				"The Electrolyte chemical has only one non-Null entry in its Composition field for `1`:",
				"The Electrolyte chemical is a solid for `1`:",
				"The electrolyte molecule specified by Electrolyte option matches with the electrolyte molecule specified by the prepared liquid input sample for `1`:",
				"The electrolyte molecule specified by the ElectrolyteSolution has its MolecularWeight defined for `1`:",
				"The electrolyte molecule specified by ElectrolyteSolution option matches with the electrolyte molecule specified by the prepared liquid input sample for `1`:",
				"The electrolyte molecule can be automatically resolved for `1`:",
				"The electrolyte molecule specified by the Electrolyte chemical or the liquid prepared input sample can be found in ElectrolyteSolution for `1`:",
				"The electrolyte molecule specified by the Electrolyte chemical or the liquid prepared input sample has only one entry in the Composition field of the ElectrolyteSolution for `1`:",
				"The electrolyte molecule has a concentration unit that is of Molar units or Mass/Volume units in the Composition field of the ElectrolyteSolution for `1`:",
				"The electrolyte molecule specified by the ElectrolyteSolution is the same with the electrolyte molecule specified by the Electrolyte chemical for `1`:"
			}
		}
	];

	(* more tests related to solvents, electrolytes, and prepared samples *)
	(* test generation is grouped for readability and maintainability *)
	solventAndElectrolyteTestsGroup3 = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithNonNullElectrolyteSolution,
				samplePacketsWithNonNullElectrolyteSolutionLoadingVolume,
				samplePacketsWithNonNullLoadingSampleElectrolyteAmount,
				samplePacketsWithMissingElectrolyteSolutionLoadingVolume,
				samplePacketsWithMissingElectrolyteTargetConcentration,
				samplePacketsWithMissingLoadingSampleElectrolyteAmount,
				samplePacketsWithMissingElectrolyteSolution,
				samplePacketsWithTooSmallElectrolyteSolutionLoadingVolume,
				samplePacketsWithTooLargeElectrolyteSolutionLoadingVolume,
				samplePacketsWithTooLowElectrolyteTargetConcentration,
				samplePacketsWithTooHighElectrolyteTargetConcentration,
				samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSample,
				samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentration,
				samplePacketsWithElectrolyteTargetConcentrationMismatchPreparedSample,
				samplePacketsWithLoadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentration
			},
			{
				"The ElectrolyteSolution option is resolved to Null when PretreatElectrodes is False for `1`:",
				"The ElectrolyteSolutionLoadingVolume option is resolved to Null when PretreatElectrodes is False for `1`:",
				"The LoadingSampleElectrolyteAmount option is resolved to Null for liquid prepared input sample for `1`:",
				"The ElectrolyteSolutionLoadingVolume option is not resolved to Null when PretreatElectrodes is True for `1`:",
				"The ElectrolyteTargetConcentration option is not resolved to Null for unprepared input sample for `1`:",
				"The LoadingSampleElectrolyteAmount option is not resolved to Null for unprepared input sample for `1`:",
				"The ElectrolyteSolution option is not resolved to Null when PretreatElectrodes is True for `1`:",
				"The ElectrolyteSolutionLoadingVolume is not less than 30% of the ReactionVessel's MaxVolume for `1`:",
				"The ElectrolyteSolutionLoadingVolume is not greater than 90% of the ReactionVessel's MaxVolume for `1`:",
				"The specified ElectrolyteTargetConcentration (or the concentration determined by the LoadingSampleElectrolyteAmount and SolventVolume) leads to an electrolyte concentration no lower than 0.05 Molar (for organic solvent) or 0.1 Molar (for aqueous solvent) for `1`:",
				"The specified ElectrolyteTargetConcentration (or the concentration determined by the LoadingSampleElectrolyteAmount and SolventVolume) leads to an electrolyte concentration no higher than 0.5 Molar (for organic solvent) or 3 Molar (for aqueous solvent) for `1`:",
				"The ElectrolyteSolution's electrolyte concentration matches with the input sample's electrolyte concentration for `1`:",
				"The ElectrolyteSolution's electrolyte concentration matches with the concentration specified by the ElectrolyteTargetConcentration option for `1`:",
				"The electrolyte concentration specified by the ElectrolyteTargetConcentration option matches with the liquid prepared input sample's electrolyte concentration for `1`:",
				"The electrolyte concentration specified by LoadingSampleElectrolyteAmount option matches with the concentration specified by the ElectrolyteTargetConcentration option for `1`:"
			}
		}
	];

	(* collect all the tests for the electrolyte/solution etc errors *)
	solventAndElectrolyteOptionsGroupedErrorTests = Flatten[
		{
			solventAndElectrolyteTestsGroup1,
			solventAndElectrolyteTestsGroup2,
			solventAndElectrolyteTestsGroup3
		}
	];


	(* -- ERRORS --*)

	(* --  Electrolytes and Solutions -- *)

	(* error for missing solvent in a prepared sample *)
	If[!MatchQ[samplePacketsWithPreparedSampleMissingSolvent, {}]&&!gatherTests,
		Message[Error::MissingInformation, "The Solvent field is not populated", "populate the Solvent field to reflect the solvent chemical or solvent molecule species used to prepare these liquid samples. All liquid samples resolve to PreparedSample True and require Solvent field to be populated.", ObjectToString[samplePacketsWithPreparedSampleMissingSolvent, Cache -> newCache]]];

	(* error for ambiguous analyte in the sample packets*)
	If[!MatchQ[samplePacketsWithSampleSolventAmbiguousMolecule, {}]&&!gatherTests,
		Message[Error::AmbiguousComposition, "The solvent chemical used to prepare the liquid input sample has more than one non-Null entry in its Composition field", "check the Composition field is properly populated (only has one solvent molecule) for the corresponding solvent chemical(s)", ObjectToString[samplePacketsWithSampleSolventAmbiguousMolecule, Cache -> newCache]]];

	(* -- ElectrolyteSolution Error messages -- *)

	(* error for a non-liquid electrolyte solution *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionNotLiquid, {}]&&!gatherTests,
		Message[Error::ChemicalNotLiquid, "ElectrolyteSolution", ObjectToString[samplePacketsWithElectrolyteSolutionNotLiquid, Cache -> newCache]]];

	(* error for an electrolyte solution missing solvent information *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionMissingSolvent, {}]&&!gatherTests,
		Message[Error::MissingInformation, "The ElectrolyteSolution's Solvent field is not populated", "populate the Solvent field to reflect the solvent chemical or solvent molecule species used to prepare the corresponding ElectrolyteSolution(s)", ObjectToString[samplePacketsWithElectrolyteSolutionMissingSolvent, Cache -> newCache]]];

	(* error for electrolyte solution that are missing analyte *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionMissingAnalyte, {}]&&!gatherTests,
		Message[Error::MissingInformation, "The ElectrolyteSolution's Analytes field is not populated", "populate the Analytes field to reflect the electrolyte (which is the analyte in the case of electrolyte solution) molecule species used to prepare the corresponding ElectrolyteSolution(s)", ObjectToString[samplePacketsWithElectrolyteSolutionMissingAnalyte, Cache -> newCache]]];

	(* error for electrolyte solutions with an ambiguous analyte *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionAmbiguousAnalyte, {}]&&!gatherTests,
		Message[Error::AmbiguousComposition, "The ElectrolyteSolution's Analytes field has more than one entry", "populate the Analytes field to reflect the electrolyte (which is the analyte in the case of electrolyte solution) molecule species used to prepare the corresponding ElectrolyteSolution(s)", ObjectToString[samplePacketsWithElectrolyteSolutionAmbiguousAnalyte, Cache -> newCache]]];

	(* error message for electrolyte solutions with ambiguous composition molecules *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionSolventAmbiguousMolecule, {}]&&!gatherTests,
		Message[Error::AmbiguousComposition, "The ElectrolyteSolution's solvent chemical has more than one non-Null entry in its Composition field", "check the Composition field is properly populated (only has one solvent molecule) for the solvent chemical of the corresponding ElectrolyteSolution(s)", ObjectToString[samplePacketsWithElectrolyteSolutionSolventAmbiguousMolecule, Cache -> newCache]]];

	(* -- Solvent errors -- *)

	(* error message for samples with non liquid solvents *)
	If[!MatchQ[samplePacketsWithSolventNotLiquid, {}]&&!gatherTests,
		Message[Error::ChemicalNotLiquid, "Solvent", ObjectToString[samplePacketsWithSolventNotLiquid, Cache -> newCache]]];

	(* error messages for solvent ambiguous composition molecules *)
	If[!MatchQ[samplePacketsWithSolventAmbiguousMolecule, {}]&&!gatherTests,
		Message[Error::AmbiguousComposition, "The specified Solvent has more than one non-Null entry in its Composition field", "check the Composition field is properly populated (only has one solvent molecule) for the corresponding Solvent(s)", ObjectToString[samplePacketsWithSolventAmbiguousMolecule, Cache -> newCache]]];

	(* error message for samples where the indicated solvent molecule does not match the sample information*)
	If[!MatchQ[samplePacketsWithSolventMoleculeMismatchPreparedSampleSolventMolecule, {}]&&!gatherTests,
		Message[Error::MismatchingMolecules, "The solvent molecule specified by the Solvent is not the same with the solvent molecule specified by the sample", "make sure the solvent molecule in the Solvent chemical and the input prepared liquid sample are the same", ObjectToString[samplePacketsWithSolventMoleculeMismatchPreparedSampleSolventMolecule, Cache -> newCache]]];

	(* error message for samples where the indicated solvent molecule is not consistent with the sample information *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMolecule, {}]&&!gatherTests,
		Message[Error::MismatchingMolecules, "The solvent molecule specified by the ElectrolyteSolution is not the same with the solvent molecule specified by the sample", "make sure the solvent molecule in the ElectrolyteSolution solution and the input prepared liquid sample are the same", ObjectToString[samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchPreparedSampleSolventMolecule, Cache -> newCache]]];

	(* error message for mismatch between the electrolyte and sample solvent *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchSolventMolecule, {}]&&!gatherTests,
		Message[Error::MismatchingMolecules, "The solvent molecule specified by the ElectrolyteSolution is not the same with the solvent molecule specified by the Solvent chemical", " make sure the solvent molecule in the ElectrolyteSolution solution and the Solvent chemical are the same", ObjectToString[samplePacketsWithElectrolyteSolutionSolventMoleculeMismatchSolventMolecule, Cache -> newCache]]];


	(* -- Electrolyte solid error checking -- *)

	(* error message for solid electrolytes that don't give us the expected units in the composition field *)
	If[!MatchQ[samplePacketsWithSampleElectrolyteMoleculeWithUnresolvableCompositionUnit, {}]&&!gatherTests,
		Message[Error::UnresolvableUnit, "The electrolyte molecule has a concentration unit that is not of Molar units or Mass/Volume units in the Composition field", "make sure the composition unit of the electrolyte molecule is specified in Molar units or Mass/Volume units in the Composition field for these input liquid samples", ObjectToString[samplePacketsWithSampleElectrolyteMoleculeWithUnresolvableCompositionUnit, Cache -> newCache]]];

	(* error for a missing molecular weight in the solid electrolyte *)
	If[!MatchQ[samplePacketsWithSampleElectrolyteMoleculeMissingMolecularWeight, {}]&&!gatherTests,
		Message[Error::MissingInformation, "The electrolyte molecule specified by the sample does not have the MolecularWeight field populated", "make sure the MolecularWeight field is informed for the corresponding electrolyte molecule(s)", ObjectToString[samplePacketsWithSampleElectrolyteMoleculeMissingMolecularWeight, Cache -> newCache]]];

	(* error message for solid electrolyte molecule that lacks a default model sample *)
	If[!MatchQ[samplePacketsWithSampleElectrolyteMoleculeMissingDefaultSampleModel, {}]&&!gatherTests,
		Message[Error::MissingInformation, "The electrolyte molecule specified by the sample does not have the DefaultSampleModel field populated", "make sure the DefaultSampleModel field is informed for the corresponding electrolyte molecule(s).", ObjectToString[samplePacketsWithSampleElectrolyteMoleculeMissingDefaultSampleModel, Cache -> newCache]]];

	(* error message for resolved electrolyte molecule not found in the prepared sample *)
	If[!MatchQ[samplePacketsWithSampleElectrolyteMoleculeNotFound, {}]&&!gatherTests,
		Message[Error::MissingInformation, "The electrolyte molecule specified by the Electrolyte chemical or the ElectrolyteSolution was not found in the input sample", "make sure the same electrolyte chemical/molecule is used to prepare the input liquid sample", ObjectToString[samplePacketsWithSampleElectrolyteMoleculeNotFound, Cache -> newCache]]];

	(* error message for ambiguous solid electrolyte molecule in the prepared sample *)
	If[!MatchQ[samplePacketsWithSampleAmbiguousElectrolyteMolecule, {}]&&!gatherTests,
		Message[Error::AmbiguousComposition, "The electrolyte molecule specified by the Electrolyte chemical or the ElectrolyteSolution has more than one entry in the Composition field", "make sure the electrolyte chemical/molecule used to prepare the input liquid sample is only defined once in the sample's Composition field", ObjectToString[samplePacketsWithSampleAmbiguousElectrolyteMolecule, Cache -> newCache]]];

	(* error message for electrolyte model molecules that don't have default sample models *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingDefaultSampleModel, {}]&&!gatherTests,
		Message[Error::MissingInformation, "The electrolyte molecule specified by the ElectrolyteSolution does not have the DefaultSampleModel field populated", "make sure the DefaultSampleModel field is informed for the corresponding electrolyte molecule(s)", ObjectToString[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingDefaultSampleModel, Cache -> newCache]]];

	(* error messages for solid electrolytes with ambiguous molecules *)
	If[!MatchQ[samplePacketsWithElectrolyteSampleAmbiguousMolecule, {}]&&!gatherTests,
		Message[Error::AmbiguousComposition, "The Electrolyte chemical has more than one non-Null entry in its Composition field", "check the Composition field is properly populated (only has one electrolyte molecule) for the corresponding Electrolyte chemical(s)", ObjectToString[samplePacketsWithElectrolyteSampleAmbiguousMolecule, Cache -> newCache]]];

	(* error message for non-solid electrolytes (which we are making into electrolyte solution) *)
	If[!MatchQ[samplePacketsWithElectrolyteSampleNotSolid, {}]&&!gatherTests,
		Message[Error::ChemicalNotSolid, "Electrolyte", "", ObjectToString[samplePacketsWithElectrolyteSampleNotSolid, Cache -> newCache]]];

	(* error message for solid electrolytes that don't match the specified electrolyte model molecule *)
	If[!MatchQ[samplePacketsWithElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule, {}]&&!gatherTests,
		Message[Error::MismatchingMolecules, "The electrolyte molecule specified by the Electrolyte chemical is not the same with the electrolyte molecule specified by the sample", "make sure the electrolyte molecule in the Electrolyte chemical and the input prepared liquid sample are the same", ObjectToString[samplePacketsWithElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule, Cache -> newCache]]];

	(* error message for solid electrolytes where the MW is missing *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingMolecularWeight, {}]&&!gatherTests,
		Message[Error::MissingInformation, "The electrolyte molecule specified by the ElectrolyteSolution does not have the MolecularWeight field populated", "make sure the MolecularWeight field is informed for the corresponding electrolyte molecule(s)", ObjectToString[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMissingMolecularWeight, Cache -> newCache]]];

	(* error message for solid electrolytes where the composition doesn't match the indicated electrolyte molecule *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule, {}]&&!gatherTests,
		Message[Error::MismatchingMolecules, "The electrolyte molecule specified by the ElectrolyteSolution option is not the same with the electrolyte molecule specified by the sample", "make sure the electrolyte molecule in the ElectrolyteSolution and the input prepared liquid sample are the same", ObjectToString[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchPreparedSampleElectrolyteMolecule, Cache -> newCache]]];

	(* error message for bad resolution of electrolyte  *)
	If[!MatchQ[samplePacketsWithCannotAutomaticallyResolveElectrolyte, {}]&&!gatherTests,
		Message[Error::CannotResolveElectrolyte, ObjectToString[samplePacketsWithCannotAutomaticallyResolveElectrolyte, Cache -> newCache]]];

	(* error message for electrolyte solutions with ambiguous molecules *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionAmbiguousElectrolyteMolecule, {}]&&!gatherTests,
		Message[Error::AmbiguousComposition, "The electrolyte molecule specified by the Electrolyte chemical or the input sample has more than one entry in the Composition field of the ElectrolyteSolution", "make sure the electrolyte chemical/molecule used to prepare the ElectrolyteSolution is only defined once in the ElectrolyteSolution's Composition field", ObjectToString[samplePacketsWithElectrolyteSolutionAmbiguousElectrolyteMolecule, Cache -> newCache]]];

	(* error message for electrolyte with unresolvable composition unit *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnit, {}]&&!gatherTests,
		Message[Error::UnresolvableUnit, "The electrolyte molecule has a concentration unit that is not of molar units or mass concentration units in the Composition field of the ElectrolyteSolution", "make sure the composition unit of the electrolyte molecule is specified in Molar units or Mass/Volume units in the Composition field for corresponding ElectrolyteSolution(s)", ObjectToString[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeWithUnresolvableCompositionUnit, Cache -> newCache]]];

	(* error message for electrolytes that don't match the specified molecule  *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMolecule, {}]&&!gatherTests,
		Message[Error::MismatchingMolecules, "The electrolyte molecule specified by the ElectrolyteSolution is not the same with the resolved electrolyte molecule", "make sure that all electrolyte-related error are addressed and the electrolyte molecule in the ElectrolyteSolution and the Electrolyte chemical are the same", ObjectToString[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeMismatchElectrolyteMolecule, Cache -> newCache]]];

	(* -- Electrolyte amount/volume error messages -- *)

	(* Error message for unused specified electrolyte solutions *)
	If[!MatchQ[samplePacketsWithNonNullElectrolyteSolution, {}]&&!gatherTests,
		Message[Error::NonNullOption, "ElectrolyteSolution", "PretreatElectrodes", "False", ObjectToString[samplePacketsWithNonNullElectrolyteSolution, Cache -> newCache]]];

	(* error message for unused specified electrolyte solution loading volume *)
	If[!MatchQ[samplePacketsWithNonNullElectrolyteSolutionLoadingVolume, {}]&&!gatherTests,
		Message[Error::NonNullOption, "ElectrolyteSolutionLoadingVolume", "PretreatElectrodes", "False", ObjectToString[samplePacketsWithNonNullElectrolyteSolutionLoadingVolume, Cache -> newCache]]];

	(* error message for unused loading sample electrolyte amount *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleElectrolyteAmount, {}]&&!gatherTests,
		Message[Error::SpecifiedOptionPreparedSample, "LoadingSampleElectrolyteAmount", ObjectToString[samplePacketsWithNonNullLoadingSampleElectrolyteAmount, Cache -> newCache]]];

	(* error message for missing electrolyte solution loading volume *)
	If[!MatchQ[samplePacketsWithMissingElectrolyteSolutionLoadingVolume, {}]&&!gatherTests,
		Message[Error::MissingOption, "ElectrolyteSolutionLoadingVolume", "PretreatElectrodes", "True", "a volume between 30% and 90% of the ReactionVessel's MaxVolume", ObjectToString[samplePacketsWithMissingElectrolyteSolutionLoadingVolume, Cache -> newCache]]];

	(* error message missing required electrolyte target concentration *)
	If[!MatchQ[samplePacketsWithMissingElectrolyteTargetConcentration, {}]&&!gatherTests,
		Message[Error::MissingOptionUnpreparedSample, "ElectrolyteTargetConcentration", "a concentration quantity", ObjectToString[samplePacketsWithMissingElectrolyteTargetConcentration, Cache -> newCache]]];

	(* error message for missing electrolyte amount *)
	If[!MatchQ[samplePacketsWithMissingLoadingSampleElectrolyteAmount, {}]&&!gatherTests,
		Message[Error::MissingOptionUnpreparedSample, "LoadingSampleElectrolyteAmount", "a mass quantity", ObjectToString[samplePacketsWithMissingLoadingSampleElectrolyteAmount, Cache -> newCache]]];

	(* error message for missing electrolyte solution *)
	If[!MatchQ[samplePacketsWithMissingElectrolyteSolution, {}]&&!gatherTests,
		Message[Error::MissingOption, "ElectrolyteSolution", "PretreatElectrodes", "True", "a solution", ObjectToString[samplePacketsWithMissingElectrolyteSolution, Cache -> newCache]]];

	(* error message for electrolytes with insufficient loading volume*)
	If[!MatchQ[samplePacketsWithTooSmallElectrolyteSolutionLoadingVolume, {}]&&!gatherTests,
		Message[Error::TooSmallVolume, "ElectrolyteSolutionLoadingVolume", "", "ReactionVessel's MaxVolume", "", "a volume between 30% and 90% of the ReactionVessel's MaxVolume", ObjectToString[samplePacketsWithTooSmallElectrolyteSolutionLoadingVolume, Cache -> newCache]]];

	(* error message for electrolytes with excessive loading volume*)
	If[!MatchQ[samplePacketsWithTooLargeElectrolyteSolutionLoadingVolume, {}]&&!gatherTests,
		Message[Error::TooLargeVolume, "ElectrolyteSolutionLoadingVolume", "", "ReactionVessel's MaxVolume", "", "a volume between 30% and 90% of the ReactionVessel's MaxVolume", ObjectToString[samplePacketsWithTooLargeElectrolyteSolutionLoadingVolume, Cache -> newCache]]];

	(* error message for electrolytes with insufficient target concentrations *)
	If[!MatchQ[samplePacketsWithTooLowElectrolyteTargetConcentration, {}]&&!gatherTests,
		Message[Error::TooLowConcentration, "The specified ElectrolyteTargetConcentration (or the concentration determined by the LoadingSampleElectrolyteAmount and SolventVolume) leads to an electrolyte concentration lower than 0.05 Molar (for organic solvent) or 0.1 Molar (for aqueous solvent)", "increase the specified ElectrolyteTargetConcentration (or the concentration determined by the LoadingSampleElectrolyteAmount and SolventVolume) and make sure the electrolyte concentration is between 0.05 Molar and 0.5 Molar (for organic solvent) or between 0.1 Molar and 3 Molar (for aqueous solvent)", ObjectToString[samplePacketsWithTooLowElectrolyteTargetConcentration, Cache -> newCache]]];

	(* error message for electrolytes with unobtainable target concentrations *)
	If[!MatchQ[samplePacketsWithTooHighElectrolyteTargetConcentration, {}]&&!gatherTests,
		Message[Error::TooHighConcentration, "The specified ElectrolyteTargetConcentration (or the concentration determined by the LoadingSampleElectrolyteAmount and SolventVolume) leads to an electrolyte concentration higher than 0.5 Molar (for organic solvent) or 3 Molar (for aqueous solvent)", "decrease the specified ElectrolyteTargetConcentration (or the concentration determined by the LoadingSampleElectrolyteAmount and SolventVolume) and make sure the electrolyte concentration is between 0.05 Molar and 0.5 Molar (for organic solvent) or between 0.1 Molar and 3 Molar (for aqueous solvent)", ObjectToString[samplePacketsWithTooHighElectrolyteTargetConcentration, Cache -> newCache]]];

	(* error message for electrolyte with a mismatch in concentration*)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSample, {}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The ElectrolyteSolution's electrolyte concentration does not match with the input sample's electrolyte concentration", "make sure the electrolyte concentration match between the ElectrolyteSolution and the input sample", ObjectToString[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchPreparedSample, Cache -> newCache]]];

	(* error message for electrolytes with an inconsistent target concentration *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentration, {}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The ElectrolyteSolution's electrolyte concentration does not match with the concentration specified by the ElectrolyteTargetConcentration option", "make sure the ElectrolyteSolution's electrolyte concentration matches with the ElectrolyteTargetConcentration", ObjectToString[samplePacketsWithElectrolyteSolutionElectrolyteMoleculeConcentrationMismatchElectrolyteTargetConcentration, Cache -> newCache]]];

	(* error message for electrolytes where the target concentration do not match the prepared samples information *)
	If[!MatchQ[samplePacketsWithElectrolyteTargetConcentrationMismatchPreparedSample, {}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The electrolyte concentration specified by the ElectrolyteTargetConcentration option does not match with the input sample's electrolyte concentration", "make sure the ElectrolyteTargetConcentration matches with the input prepared samples", ObjectToString[samplePacketsWithElectrolyteTargetConcentrationMismatchPreparedSample, Cache -> newCache]]];

	(* error message for electrolytes where the loading amount is inconsistent with the target concentration *)
	If[!MatchQ[samplePacketsWithLoadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentration, {}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The electrolyte concentration specified by LoadingSampleElectrolyteAmount option does not match with the concentration specified by the ElectrolyteTargetConcentration option", "make sure the LoadingSampleElectrolyteAmount option agrees with the ElectrolyteTargetConcentration", ObjectToString[samplePacketsWithLoadingSampleElectrolyteAmountMismatchElectrolyteTargetConcentration, Cache -> newCache]]];



	(* -- WARNINGS -- *)

	(* warning message for samples where the solvent does not match prepared samples solvent *)
	If[!MatchQ[samplePacketsWithSolventMismatchPreparedSampleSolvent, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MismatchingOptionsWarning, "Though the solvent molecules are the same, the specified Solvent chemical may not be the same solvent chemical used", "consider to use the same solvent chemical to prepare the input sample(s)",ObjectToString[samplePacketsWithSolventMismatchPreparedSampleSolvent, Cache -> newCache]]];

	(* warning message for samples where the electrolyte solvent does not match the solvent *)
	If[!MatchQ[samplePacketsWithElectrolyteSolutionSolventMismatchSolvent, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MismatchingOptionsWarning, "Though the solvent molecules are the same, the solvent chemical used to prepare the ElectrolyteSolution may not be the same solvent chemical specified by the Solvent option", "consider to use the same solvent chemical specified by the Solvent option to prepare the ElectrolyteSolution",ObjectToString[samplePacketsWithElectrolyteSolutionSolventMismatchSolvent, Cache -> newCache]]];


	(* ==== ReferenceElectrode, ReferenceSolution related related messages, invalidOptions, and tests ==== *)

	(* INVALID OPTIONS *)
	(* determine if the RefreshReferenceElectrode option has an invalid value or could not be resolved *)
	refreshReferenceElectrodeInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithReferenceElectrodeNeedRefreshRequiresRefresh, Except[{}]]
		],
		{RefreshReferenceElectrode},
		{}
	];

	(* determine if the ReferenceElectrode option has an invalid value or could not be resolved *)
	referenceElectrodeInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithReferenceElectrodeUnprepared, Except[{}]],
			MatchQ[samplePacketsWithElectrodeReferenceSolutionInformationError, Except[{}]]
		],
		{ReferenceElectrode},
		{}
	];

	(* determine if the ReferenceElectrodeSoakTime option has an invalid value or could not be resolved *)
	referenceElectrodeSoakTimeInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithTooLongReferenceElectrodeSoakTime, Except[{}]]
		],
		{ReferenceElectrodeSoakTime},
		{}
	];

	(* ERROR TESTS *)
	referenceElectrodeGroupedErrorTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithReferenceElectrodeUnprepared,
				samplePacketsWithReferenceElectrodeNeedRefreshRequiresRefresh,
				samplePacketsWithElectrodeReferenceSolutionInformationError,
				samplePacketsWithTooLongReferenceElectrodeSoakTime
			},
			{
				"The ReferenceElectrode is not an unprepared 'Bare' type reference electrode for `1`:",
				"The RefreshReferenceElectrode option is set to True when the ReferenceElectrode needs a reference solution refresh for `1`:",
				"No error was encountered when the information is fetched for the ReferenceSolution of the ReferenceElectrode for `1`:",
				"The specified ReferenceElectrodeSoakTime is not longer than 1 hour for `1`:"
			}
		}
	];

	(* WARNING TESTS *)
	referenceElectrodeGroupedWarningTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Warning,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithReferenceElectrodeRecommendedSolventTypeMismatchSolvent,
				samplePacketsWithElectrodeReferenceSolutionSolventMoleculeMismatchWarning,
				samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeMismatchWarning,
				samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatchWarning
			},
			{
				"The RecommendedSolventType of the ReferenceElectrode matches with the Solvent option for `1`:",
				"The solvent molecule used to prepare the ReferenceSolution in the ReferenceElectrode matches with the solvent molecule specified by the Solvent option for `1`:",
				"The electrolyte molecule used to prepare the ReferenceSolution in the ReferenceElectrode matches with the electrolyte molecule specified by the Electrolyte option for `1`:",
				"The electrolyte molecule concentration used to prepare the ReferenceSolution in the ReferenceElectrode matches with the electrolyte molecule concentration specified by the ElectrolyteTargetConcentration option for `1`:"
			}
		}
	];

	(* ERROR MESSAGES *)

	(* -- samplePacketsWithReferenceElectrodeUnprepared: Message -- *)
	If[!MatchQ[samplePacketsWithReferenceElectrodeUnprepared, {}]&&!gatherTests,
		Message[Error::ReferenceElectrode, "The ReferenceElectrode is an unprepared 'Bare' type reference electrode", "choose another reference electrode model or object that is not of 'Bare-Ag' or other unprepared types. You can use UploadReferenceElectrodeModel to create new reference electrode models", ObjectToString[samplePacketsWithReferenceElectrodeUnprepared, Cache -> newCache]]];

	(* -- samplePacketsWithReferenceElectrodeNeedRefreshRequiresRefresh: Message -- *)
	If[!MatchQ[samplePacketsWithReferenceElectrodeNeedRefreshRequiresRefresh, {}]&&!gatherTests,
		Message[Error::ReferenceElectrode, "The RefreshReferenceElectrode option is set to False when the ReferenceElectrode needs a reference solution refresh", "set RefreshReferenceElectrode to True. A reference electrode needs a refresh if its current reference solution was added before a date indicated by the electrode's RecommendedRefreshPeriod", ObjectToString[samplePacketsWithReferenceElectrodeNeedRefreshRequiresRefresh, Cache -> newCache]]];

	(* -- samplePacketsWithElectrodeReferenceSolutionInformationError: Message -- *)
	If[!MatchQ[samplePacketsWithElectrodeReferenceSolutionInformationError, {}]&&!gatherTests,
		Message[Error::ReferenceElectrode, "Errors were encountered when the information is fetched for the ReferenceSolution of the ReferenceElectrode", "double check the specified ReferenceElectrode passes ValidObjectQ", ObjectToString[samplePacketsWithElectrodeReferenceSolutionInformationError, Cache -> newCache]]];

	(* -- samplePacketsWithTooLongReferenceElectrodeSoakTime: Message -- *)
	If[!MatchQ[samplePacketsWithTooLongReferenceElectrodeSoakTime, {}]&&!gatherTests,
		Message[Error::TooLongSoakTime, ObjectToString[samplePacketsWithTooLongReferenceElectrodeSoakTime, Cache -> newCache]]];


	(* WARNING MESSAGES *)
	(* -- samplePacketsWithReferenceElectrodeRecommendedSolventTypeMismatchSolvent: Message -- *)
	If[!MatchQ[samplePacketsWithReferenceElectrodeRecommendedSolventTypeMismatchSolvent, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MismatchingOptionsWarning, "The RecommendedSolventType of the ReferenceElectrode does not match with the Solvent option", "consider using another type of reference electrode or prepare a new ReferenceElectrode",ObjectToString[samplePacketsWithReferenceElectrodeRecommendedSolventTypeMismatchSolvent, Cache -> newCache]]];

	(* -- samplePacketsWithElectrodeReferenceSolutionSolventMoleculeMismatchWarning: Message -- *)
	If[!MatchQ[samplePacketsWithElectrodeReferenceSolutionSolventMoleculeMismatchWarning, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MismatchingOptionsWarning, "The solvent molecule used to prepare the ReferenceSolution in the ReferenceElectrode does not match with the solvent molecule specified by the Solvent option", "consider using another type of reference electrode, using a reference solution (prepared using the same solvent molecule) to refresh the current ReferenceElectrode, or prepare a new ReferenceElectrode",ObjectToString[samplePacketsWithElectrodeReferenceSolutionSolventMoleculeMismatchWarning, Cache -> newCache]]];

	(* -- samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeMismatchWarning: Message -- *)
	If[!MatchQ[samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeMismatchWarning, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MismatchingOptionsWarning, "The electrolyte molecule used to prepare the ReferenceSolution in the ReferenceElectrode does not match with the electrolyte molecule specified by the Electrolyte option", "consider using another type of reference electrode, using a reference solution (prepared using the same electrolyte molecule) to refresh the current ReferenceElectrode, or prepare a new ReferenceElectrode",ObjectToString[samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeMismatchWarning, Cache -> newCache]]];

	(* -- samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatchWarning: Message -- *)
	If[!MatchQ[samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatchWarning, {}]&&!gatherTests&&Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::MismatchingOptionsWarning, "The electrolyte molecule concentration used to prepare the ReferenceSolution in the ReferenceElectrode does not match with the electrolyte molecule concentration specified by the ElectrolyteTargetConcentration option", "consider using another type of reference electrode, using a reference solution (prepared using the same electrolyte molecule concentration) to refresh the current ReferenceElectrode, or prepare a new ReferenceElectrode",ObjectToString[samplePacketsWithElectrodeReferenceSolutionElectrolyteMoleculeConcentrationMismatchWarning, Cache -> newCache]]];


	(* ==== InternalStandard related related messages, invalidOptions, and tests ==== *)

	(* INVALID INPUTS *)
	preparedSampleInvalidCompositionLengthForNoneInternalStandardInvalidInputs = If[MatchQ[samplePacketsWithPreparedSampleInvalidCompositionLengthForNoneInternalStandard, {}],
		{},
		Lookup[samplePacketsWithPreparedSampleInvalidCompositionLengthForNoneInternalStandard, Object]
	];

	preparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrderInvalidInputs = If[MatchQ[samplePacketsWithPreparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrder, {}],
		{},
		Lookup[samplePacketsWithPreparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrder, Object]
	];

	preparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrderInvalidInputs = If[MatchQ[samplePacketsWithPreparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrder, {}],
		{},
		Lookup[samplePacketsWithPreparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrder, Object]
	];

	(* INVALID OPTIONS *)
	(* determine if the InternalStandard option has an invalid value or could not be resolved *)
	internalStandardInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithInternalStandardNotSolid, Except[{}]],
			MatchQ[samplePacketsWithResolvedInternalStandardAmbiguousMolecule, Except[{}]],
			MatchQ[samplePacketsWithInternalStandardNotACompositionMemberForPreparedSample, Except[{}]]
		],
		{InternalStandard},
		{}
	];

	(* determine if the InternalStandardAdditionOrder option has an invalid value or could not be resolved *)
	internalStandardAdditionOrderInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullInternalStandardAdditionOrder, Except[{}]],
			MatchQ[samplePacketsWithMissingInternalStandardAdditionOrder, Except[{}]],
			MatchQ[samplePacketsWithInternalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrder, Except[{}]]
		],
		{InternalStandardAdditionOrder},
		{}
	];

	(* determine if the InternalStandardAmount option has an invalid value or could not be resolved *)
	internalStandardAmountInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullInternalStandardAmountForNoneInternalStandard, Except[{}]],
			MatchQ[samplePacketsWithNonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSample, Except[{}]],
			MatchQ[samplePacketsWithMissingInternalStandardAmountForAfterAdditionOrder, Except[{}]],
			MatchQ[samplePacketsWithMissingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSample, Except[{}]],
			MatchQ[samplePacketsWithInternalStandardAmountMismatchInternalStandardTargetConcentration, Except[{}]]
		],
		{InternalStandardAmount},
		{}
	];

	(* determine if the InternalStandardTargetConcentration option has an invalid value or could not be resolved *)
	internalStandardTargetConcentrationInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullInternalStandardTargetConcentrationForNoneInternalStandard, Except[{}]],
			MatchQ[samplePacketsWithNonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSample, Except[{}]],
			MatchQ[samplePacketsWithMissingInternalStandardTargetConcentrationForAfterAdditionOrder, Except[{}]],
			MatchQ[samplePacketsWithMissingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSample, Except[{}]],
			MatchQ[samplePacketsWithTooLowInternalStandardTargetConcentration, Except[{}]],
			MatchQ[samplePacketsWithTooHighInternalStandardTargetConcentration, Except[{}]],
			MatchQ[samplePacketsWithInternalStandardAmountMismatchInternalStandardTargetConcentration, Except[{}]]
		],
		{InternalStandardTargetConcentration},
		{}
	];

	(* ERROR TESTS *)
	internalStandardGroupedErrorTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithInternalStandardNotSolid,
				samplePacketsWithPreparedSampleInvalidCompositionLengthForNoneInternalStandard,
				samplePacketsWithResolvedInternalStandardAmbiguousMolecule,
				samplePacketsWithNonNullInternalStandardAdditionOrder,
				samplePacketsWithMissingInternalStandardAdditionOrder,
				samplePacketsWithPreparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrder,
				samplePacketsWithPreparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrder,
				samplePacketsWithInternalStandardNotACompositionMemberForPreparedSample,
				samplePacketsWithInternalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrder,
				samplePacketsWithNonNullInternalStandardTargetConcentrationForNoneInternalStandard,
				samplePacketsWithNonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSample,
				samplePacketsWithMissingInternalStandardTargetConcentrationForAfterAdditionOrder,
				samplePacketsWithMissingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSample,
				samplePacketsWithTooLowInternalStandardTargetConcentration,
				samplePacketsWithTooHighInternalStandardTargetConcentration,
				samplePacketsWithNonNullInternalStandardAmountForNoneInternalStandard,
				samplePacketsWithNonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSample,
				samplePacketsWithMissingInternalStandardAmountForAfterAdditionOrder,
				samplePacketsWithMissingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSample,
				samplePacketsWithInternalStandardAmountMismatchInternalStandardTargetConcentration
			},
			{
				"The provided InternalStandard is a solid for `1`:",
				"The prepared liquid input sample has 3 entries in its Composition field when the InternalStandard is set to None for `1`:",
				"The provided InternalStandard chemical has only one entry in its Analytes field for `1`:",
				"The InternalStandardAdditionOrder is resolved to Null when InternalStandard is set to None for `1`:",
				"The InternalStandardAdditionOrder is not resolved to Null when InternalStandard is provided for `1`:",
				"The prepared liquid input sample has 3 entries in its Composition field when the InternalStandardAdditionOrder is set to After for `1`:",
				"The prepared liquid input sample has 4 entries in its Composition field when the InternalStandardAdditionOrder is set to Before for `1`:",
				"The molecule of the provided InternalStandardMolecule is a member of the Composition field of the prepared liquid input sample for `1`:",
				"The InternalStandardAdditionOrder is Before if the InternalStandardMolecule is already a member of the Composition field of the prepared liquid input sample for `1`:",
				"The InternalStandardTargetConcentration is resolved to Null when InternalStandard is set to None for `1`:",
				"The InternalStandardTargetConcentration is resolved to Null when InternalStandardAdditionOrder is set to Before for prepared liquid input sample for `1`:",
				"The InternalStandardTargetConcentration is not resolved to Null when InternalStandardAdditionOrder is set to After for `1`:",
				"The InternalStandardTargetConcentration is not resolved Null when InternalStandardAdditionOrder is set to Before for unprepared solid input sample for `1`:",
				"The InternalStandardTargetConcentration is not less than 1 Millimolar for `1`:",
				"The InternalStandardTargetConcentration is not greater than 15 Millimolar for `1`:",
				"The InternalStandardAmount is resolved to Null when InternalStandard is set to None for `1`:",
				"The InternalStandardAmount is resolved to Null when InternalStandardAdditionOrder is set to Before for prepared liquid input sample for `1`:",
				"The InternalStandardAmount is not resolved to Null when InternalStandardAdditionOrder is set to After for `1`:",
				"The InternalStandardAmount is not resolved to Null when InternalStandardAdditionOrder is set to Before for  unprepared solid input sample for `1`:",
				"The provided InternalStandardTargetConcentration and InternalStandardAmount agree with each other for `1`:"
			}
		}
	];

	(* ERROR MESSAGES *)
	(* -- samplePacketsWithInternalStandardNotSolid: Message -- *)
	If[!MatchQ[samplePacketsWithInternalStandardNotSolid, {}]&&!gatherTests,
		Message[Error::ChemicalNotSolid, "InternalStandard", "Ferrocene is one of the widely used internal standard chemical.", ObjectToString[samplePacketsWithInternalStandardNotSolid, Cache -> newCache]]];

	(* -- samplePacketsWithPreparedSampleInvalidCompositionLengthForNoneInternalStandard: Message -- *)
	If[!MatchQ[samplePacketsWithPreparedSampleInvalidCompositionLengthForNoneInternalStandard, {}]&&!gatherTests,
		Message[Error::InternalStandard, "The sample does not have 3 non-Null entries in its Composition field while the InternalStandard is set to None", "make sure the prepared input sample has the solvent molecule, electrolyte molecule and the target analyte molecule populated in its Composition field if no internal standard is used", ObjectToString[samplePacketsWithPreparedSampleInvalidCompositionLengthForNoneInternalStandard, Cache -> newCache]]];

	(* -- samplePacketsWithResolvedInternalStandardAmbiguousMolecule: Message -- *)
	If[!MatchQ[samplePacketsWithResolvedInternalStandardAmbiguousMolecule, {}]&&!gatherTests,
		Message[Error::AmbiguousComposition, "The provided InternalStandard chemical has no entry or more than one entry in its Analytes field", "make sure the InternalStandard chemical has and only has one entry in its Analytes field to indicate the internal standard molecule", ObjectToString[samplePacketsWithResolvedInternalStandardAmbiguousMolecule, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullInternalStandardAdditionOrder: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullInternalStandardAdditionOrder, {}]&&!gatherTests,
		Message[Error::NonNullOption, "InternalStandardAdditionOrder", "InternalStandard", "None", ObjectToString[samplePacketsWithNonNullInternalStandardAdditionOrder, Cache -> newCache]]];

	(* -- samplePacketsWithMissingInternalStandardAdditionOrder: Message -- *)
	If[!MatchQ[samplePacketsWithMissingInternalStandardAdditionOrder, {}]&&!gatherTests,
		Message[Error::MissingOption, "InternalStandardAdditionOrder", "InternalStandard", "provided", "Before, or to After, in order to indicate when the provided internal standard chemical should be added into the LoadingSample solution", ObjectToString[samplePacketsWithMissingInternalStandardAdditionOrder, Cache -> newCache]]];

	(* -- samplePacketsWithPreparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrder: Message -- *)
	If[!MatchQ[samplePacketsWithPreparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrder, {}]&&!gatherTests,
		Message[Error::InternalStandard, "The sample does not have 3 entries in its Composition field while the InternalStandardAdditionOrder is set to After", "make sure the prepared input sample has the solvent molecule, electrolyte molecule and the target analyte molecule populated in its Composition field if the internal standard chemical is added after the cyclic voltammetry measurements", ObjectToString[samplePacketsWithPreparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrder, Cache -> newCache]]];

	(* -- samplePacketsWithPreparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrder: Message -- *)
	If[!MatchQ[samplePacketsWithPreparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrder, {}]&&!gatherTests,
		Message[Error::InternalStandard, "The sample does not have 4 entries in its Composition field while the InternalStandardAdditionOrder is set to Before", "make sure the prepared input sample has the solvent molecule, electrolyte molecule, the target analyte molecule, and the internal standard molecule populated in its Composition field if the internal standard chemical is added before the cyclic voltammetry measurements", ObjectToString[samplePacketsWithPreparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrder, Cache -> newCache]]];

	(* -- samplePacketsWithInternalStandardNotACompositionMemberForPreparedSample: Message -- *)
	If[!MatchQ[samplePacketsWithInternalStandardNotACompositionMemberForPreparedSample, {}]&&!gatherTests,
		Message[Error::InternalStandard, "The molecule of the provided InternalStandardMolecule is not a member of the Composition field", "make sure the prepared input sample has the solvent molecule, electrolyte molecule, the target analyte molecule, and the internal standard molecule populated in its Composition field if the internal standard chemical is added before the cyclic voltammetry measurements", ObjectToString[samplePacketsWithInternalStandardNotACompositionMemberForPreparedSample, Cache -> newCache]]];

	(* -- samplePacketsWithInternalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrder: Message -- *)
	If[!MatchQ[samplePacketsWithInternalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrder, {}]&&!gatherTests,
		Message[Error::InternalStandard, "The specified InternalStandardAdditionOrder is After, but the molecule of the provided InternalStandard is already a member of the Composition field", "set InternalStandardAdditionOrder to Automatic or to Before for these input liquid samples", ObjectToString[samplePacketsWithInternalStandardAlreadyACompositionMemberForAfterInternalStandardAdditionOrder, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullInternalStandardTargetConcentrationForNoneInternalStandard: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullInternalStandardTargetConcentrationForNoneInternalStandard, {}]&&!gatherTests,
		Message[Error::NonNullOption, "InternalStandardTargetConcentration", "InternalStandard", "None", ObjectToString[samplePacketsWithNonNullInternalStandardTargetConcentrationForNoneInternalStandard, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSample: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSample, {}]&&!gatherTests,
		Message[Error::ConditionalSpecifiedOptionPreparedSample, "InternalStandardTargetConcentration", "InternalStandardAdditionOrder", "Before", ObjectToString[samplePacketsWithNonNullInternalStandardTargetConcentrationForBeforeAdditionOrderAndPreparedSample, Cache -> newCache]]];

	(* -- samplePacketsWithMissingInternalStandardTargetConcentrationForAfterAdditionOrder: Message -- *)
	If[!MatchQ[samplePacketsWithMissingInternalStandardTargetConcentrationForAfterAdditionOrder, {}]&&!gatherTests,
		Message[Error::MissingOption, "InternalStandardTargetConcentration", "InternalStandardAdditionOrder", "After", "a molar concentration (or an equivalent mass concentration) between 1 Millimolar and 15 Millimolar when InternalStandardAdditionOrder is set to After", ObjectToString[samplePacketsWithMissingInternalStandardTargetConcentrationForAfterAdditionOrder, Cache -> newCache]]];

	(* -- samplePacketsWithMissingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSample: Message -- *)
	If[!MatchQ[samplePacketsWithMissingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSample, {}]&&!gatherTests,
		Message[Error::MissingOption, "InternalStandardTargetConcentration", "InternalStandardAdditionOrder", "Before", "a molar concentration (or an equivalent mass concentration) between 1 Millimolar and 15 Millimolar when InternalStandardAdditionOrder is set to Before for unprepared solid input samples", ObjectToString[samplePacketsWithMissingInternalStandardTargetConcentrationForBeforeAdditionOrderAndUnpreparedSample, Cache -> newCache]]];

	(* -- samplePacketsWithTooLowInternalStandardTargetConcentration: Message -- *)
	If[!MatchQ[samplePacketsWithTooLowInternalStandardTargetConcentration, {}]&&!gatherTests,
		Message[Error::TooLowConcentration, "The InternalStandardTargetConcentration is less than 1 Millimolar", "set InternalStandardTargetConcentration to Automatic or to a molar concentration (or an equivalent mass concentration) between 1 Millimolar and 15 Millimolar", ObjectToString[samplePacketsWithTooLowInternalStandardTargetConcentration, Cache -> newCache]]];

	(* -- samplePacketsWithTooHighInternalStandardTargetConcentration: Message -- *)
	If[!MatchQ[samplePacketsWithTooHighInternalStandardTargetConcentration, {}]&&!gatherTests,
		Message[Error::TooHighConcentration, "The InternalStandardTargetConcentration is greater than 15 Millimolar", "set InternalStandardTargetConcentration to Automatic or to a molar concentration (or an equivalent mass concentration) between 1 Millimolar and 15 Millimolar", ObjectToString[samplePacketsWithTooHighInternalStandardTargetConcentration, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullInternalStandardAmountForNoneInternalStandard: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullInternalStandardAmountForNoneInternalStandard, {}]&&!gatherTests,
		Message[Error::NonNullOption, "InternalStandardAmount", "InternalStandard", "None",ObjectToString[samplePacketsWithNonNullInternalStandardAmountForNoneInternalStandard, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSample: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSample, {}]&&!gatherTests,
		Message[Error::ConditionalSpecifiedOptionPreparedSample, "InternalStandardAmount", "InternalStandardAdditionOrder", "Before", ObjectToString[samplePacketsWithNonNullInternalStandardAmountForBeforeAdditionOrderAndPreparedSample, Cache -> newCache]]];

	(* -- samplePacketsWithMissingInternalStandardAmountForAfterAdditionOrder: Message -- *)
	If[!MatchQ[samplePacketsWithMissingInternalStandardAmountForAfterAdditionOrder, {}]&&!gatherTests,
		Message[Error::MissingOption, "InternalStandardAmount", "InternalStandardAdditionOrder", "After", "a mass amount leading to an internal standard concentration between 1 Millimolar and 15 Millimolar when InternalStandardAdditionOrder is set to After", ObjectToString[samplePacketsWithMissingInternalStandardAmountForAfterAdditionOrder, Cache -> newCache]]];

	(* -- samplePacketsWithMissingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSample: Message -- *)
	If[!MatchQ[samplePacketsWithMissingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSample, {}]&&!gatherTests,
		Message[Error::MissingOption, "InternalStandardAmount", "InternalStandardAdditionOrder", "Before", "a mass amount leading to an internal standard concentration between 1 Millimolar and 15 Millimolar when InternalStandardAdditionOrder is set to Before for unprepared solid input samples", ObjectToString[samplePacketsWithMissingInternalStandardAmountForBeforeAdditionOrderAndUnpreparedSample, Cache -> newCache]]];

	(* -- samplePacketsWithInternalStandardAmountMismatchInternalStandardTargetConcentration: Message -- *)
	If[!MatchQ[samplePacketsWithInternalStandardAmountMismatchInternalStandardTargetConcentration, {}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The provided InternalStandardTargetConcentration and InternalStandardAmount do not agree with each other", "make sure InternalStandardTargetConcentration and InternalStandardAmount with respect to the SolventVolume (when InternalStandardAdditionOrder is Before) or to the LoadingSampleVolume (when InternalStandardAdditionOrder is After)", ObjectToString[samplePacketsWithInternalStandardAmountMismatchInternalStandardTargetConcentration, Cache -> newCache]]];

	(* ==== PretreatElectrodes related related messages, invalidOptions, and tests ==== *)

	(* INVALID OPTIONS *)
	(* determine if the PretreatmentSparging option has an invalid value or could not be resolved *)
	pretreatmentSparingInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullPretreatmentSparging, Except[{}]],
			MatchQ[samplePacketsWithMissingPretreatmentSparging, Except[{}]]
		],
		{PretreatmentSparging},
		{}
	];

	(* determine if the PretreatmentSpargingPreBubbler option has an invalid value or could not be resolved *)
	pretreatmentSpargingPreBubblerInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullPretreatmentSpargingPreBubbler, Except[{}]],
			MatchQ[samplePacketsWithMissingPretreatmentSpargingPreBubbler, Except[{}]],
			MatchQ[samplePacketsWithPretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSparging, Except[{}]]
		],
		{PretreatmentSpargingPreBubbler},
		{}
	];

	(* determine if the PretreatmentInitialPotential option has an invalid value or could not be resolved *)
	pretreatmentInitialPotentialInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullPretreatmentInitialPotential, Except[{}]],
			MatchQ[samplePacketsWithMissingPretreatmentInitialPotential, Except[{}]],
			MatchQ[samplePacketsWithPretreatmentInitialPotentialNotBetweenFirstAndSecondPotentials, Except[{}]],
			MatchQ[samplePacketsWithPretreatmentInitialAndFinalPotentialsTooDifferent, Except[{}]]
		],
		{PretreatmentInitialPotential},
		{}
	];

	(* determine if the PretreatmentFirstPotential option has an invalid value or could not be resolved *)
	pretreatmentFirstPotentialInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullPretreatmentFirstPotential, Except[{}]],
			MatchQ[samplePacketsWithMissingPretreatmentFirstPotential, Except[{}]]
		],
		{PretreatmentFirstPotential},
		{}
	];

	(* determine if the PretreatmentSecondPotential option has an invalid value or could not be resolved *)
	pretreatmentSecondPotentialInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullPretreatmentSecondPotential, Except[{}]],
			MatchQ[samplePacketsWithMissingPretreatmentSecondPotential, Except[{}]]
		],
		{PretreatmentSecondPotential},
		{}
	];

	(* determine if the PretreatmentFinalPotential option has an invalid value or could not be resolved *)
	pretreatmentFinalPotentialInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullPretreatmentFinalPotential, Except[{}]],
			MatchQ[samplePacketsWithMissingPretreatmentFinalPotential, Except[{}]],
			MatchQ[samplePacketsWithPretreatmentFinalPotentialNotBetweenFirstAndSecondPotentials, Except[{}]],
			MatchQ[samplePacketsWithPretreatmentInitialAndFinalPotentialsTooDifferent, Except[{}]]
		],
		{PretreatmentFinalPotential},
		{}
	];

	(* determine if the PretreatmentPotentialSweepRate option has an invalid value or could not be resolved *)
	pretreatmentPotentialSweepRateInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullPretreatmentPotentialSweepRate, Except[{}]],
			MatchQ[samplePacketsWithMissingPretreatmentPotentialSweepRate, Except[{}]]
		],
		{PretreatmentPotentialSweepRate},
		{}
	];

	(* determine if the PretreatmentNumberOfCycles option has an invalid value or could not be resolved *)
	pretreatmentNumberOfCyclesInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullPretreatmentNumberOfCycles, Except[{}]],
			MatchQ[samplePacketsWithMissingPretreatmentNumberOfCycles, Except[{}]]
		],
		{PretreatmentNumberOfCycles},
		{}
	];

	(* ERROR TESTS *)
	pretreatElectrodesGroupedErrorTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithNonNullPretreatmentSparging,
				samplePacketsWithMissingPretreatmentSparging,
				samplePacketsWithNonNullPretreatmentSpargingPreBubbler,
				samplePacketsWithMissingPretreatmentSpargingPreBubbler,
				samplePacketsWithPretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSparging,
				samplePacketsWithNonNullPretreatmentInitialPotential,
				samplePacketsWithMissingPretreatmentInitialPotential,
				samplePacketsWithNonNullPretreatmentFirstPotential,
				samplePacketsWithMissingPretreatmentFirstPotential,
				samplePacketsWithNonNullPretreatmentSecondPotential,
				samplePacketsWithMissingPretreatmentSecondPotential,
				samplePacketsWithNonNullPretreatmentFinalPotential,
				samplePacketsWithMissingPretreatmentFinalPotential,
				samplePacketsWithPretreatmentInitialPotentialNotBetweenFirstAndSecondPotentials,
				samplePacketsWithPretreatmentFinalPotentialNotBetweenFirstAndSecondPotentials,
				samplePacketsWithPretreatmentInitialAndFinalPotentialsTooDifferent,
				samplePacketsWithNonNullPretreatmentPotentialSweepRate,
				samplePacketsWithMissingPretreatmentPotentialSweepRate,
				samplePacketsWithNonNullPretreatmentNumberOfCycles,
				samplePacketsWithMissingPretreatmentNumberOfCycles
			},
			{
				"The PretreatmentSparging is resolved to Null when PretreatElectrodes is set to False for `1`:",
				"The PretreatmentSparging is not resolved to Null when PretreatElectrodes is set to True for `1`:",
				"The PretreatmentSpargingPreBubbler is resolved to Null when PretreatElectrodes is set to False for `1`:",
				"The PretreatmentSpargingPreBubbler is not resolved to Null when PretreatElectrodes is set to True for `1`:",
				"The PretreatmentSpargingPreBubbler is not set to True when PretreatmentSparging is set to False for `1`:",
				"The PretreatmentInitialPotential is resolved to Null when PretreatElectrodes is set to False for `1`:",
				"The PretreatmentInitialPotential is not resolved to Null when PretreatElectrodes is set to True for `1`:",
				"The PretreatmentFirstPotential is resolved to Null when PretreatElectrodes is set to False for `1`:",
				"The PretreatmentFirstPotential is not resolved to Null when PretreatElectrodes is set to True for `1`:",
				"The PretreatmentSecondPotential is resolved to Null when PretreatElectrodes is set to False for `1`:",
				"The PretreatmentSecondPotential is not resolved to Null when PretreatElectrodes is set to True for `1`:",
				"The PretreatmentFinalPotential is resolved to Null when PretreatElectrodes is set to False for `1`:",
				"The PretreatmentFinalPotential is not resolved to Null when PretreatElectrodes is set to True for `1`:",
				"The PretreatmentInitialPotential is between PretreatmentFirstPotential and PretreatmentSecondPotential for `1`:",
				"The PretreatmentFinalPotential is between PretreatmentFirstPotential and PretreatmentSecondPotential for `1`:",
				"The voltage difference between PretreatmentInitialPotential and PretreatmentFinalPotential is not greater than 0.5 Volt for `1`:",
				"The PretreatmentPotentialSweepRate is resolved to Null when PretreatElectrodes is set to False for `1`:",
				"The PretreatmentPotentialSweepRate is not resolved to Null when PretreatElectrodes is set to True for `1`:",
				"The PretreatmentNumberOfCycles is resolved to Null when PretreatElectrodes is set to False for `1`:",
				"The PretreatmentNumberOfCycles is not resolved to Null when PretreatElectrodes is set to True for `1`:"
			}
		}
	];

	(* ERROR MESSAGES *)
	(* -- samplePacketsWithNonNullPretreatmentSparging: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullPretreatmentSparging, {}]&&!gatherTests,
		Message[Error::NonNullOption, "PretreatmentSparging", "PretreatElectrodes", "False", ObjectToString[samplePacketsWithNonNullPretreatmentSparging, Cache -> newCache]]];

	(* -- samplePacketsWithMissingPretreatmentSparging: Message -- *)
	If[!MatchQ[samplePacketsWithMissingPretreatmentSparging, {}]&&!gatherTests,
		Message[Error::MissingOption, "PretreatmentSparging", "PretreatElectrodes", "True", "a boolean", ObjectToString[samplePacketsWithMissingPretreatmentSparging, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullPretreatmentSpargingPreBubbler: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullPretreatmentSpargingPreBubbler, {}]&&!gatherTests,
		Message[Error::NonNullOption, "PretreatmentSpargingPreBubbler", "PretreatElectrodes", "False", ObjectToString[samplePacketsWithNonNullPretreatmentSpargingPreBubbler, Cache -> newCache]]];

	(* -- samplePacketsWithMissingPretreatmentSpargingPreBubbler: Message -- *)
	If[!MatchQ[samplePacketsWithMissingPretreatmentSpargingPreBubbler, {}]&&!gatherTests,
		Message[Error::MissingOption, "PretreatmentSpargingPreBubbler", "PretreatElectrodes", "True", "a boolean", ObjectToString[samplePacketsWithMissingPretreatmentSpargingPreBubbler, Cache -> newCache]]];

	(* -- samplePacketsWithPretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSparging: Message -- *)
	If[!MatchQ[samplePacketsWithPretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSparging, {}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The PretreatmentSpargingPreBubbler is set to True when PretreatmentSparging is set to False", "set PretreatmentSpargingPreBubbler to Automatic or to False when PretreatmentSparging is set to False", ObjectToString[samplePacketsWithPretreatmentSpargingPreBubblerTrueWhenNotPretreatmentSparging, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullPretreatmentInitialPotential: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullPretreatmentInitialPotential, {}]&&!gatherTests,
		Message[Error::NonNullOption, "PretreatmentInitialPotential", "PretreatElectrodes", "False", ObjectToString[samplePacketsWithNonNullPretreatmentInitialPotential, Cache -> newCache]]];

	(* -- samplePacketsWithMissingPretreatmentInitialPotential: Message -- *)
	If[!MatchQ[samplePacketsWithMissingPretreatmentInitialPotential, {}]&&!gatherTests,
		Message[Error::MissingOption, "PretreatmentInitialPotential", "PretreatElectrodes", "True", "a voltage", ObjectToString[samplePacketsWithMissingPretreatmentInitialPotential, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullPretreatmentFirstPotential: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullPretreatmentFirstPotential, {}]&&!gatherTests,
		Message[Error::NonNullOption, "PretreatmentFirstPotential", "PretreatElectrodes", "False", ObjectToString[samplePacketsWithNonNullPretreatmentFirstPotential, Cache -> newCache]]];

	(* -- samplePacketsWithMissingPretreatmentFirstPotential: Message -- *)
	If[!MatchQ[samplePacketsWithMissingPretreatmentFirstPotential, {}]&&!gatherTests,
		Message[Error::MissingOption, "PretreatmentFirstPotential", "PretreatElectrodes", "True", "a voltage", ObjectToString[samplePacketsWithMissingPretreatmentFirstPotential, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullPretreatmentSecondPotential: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullPretreatmentSecondPotential, {}]&&!gatherTests,
		Message[Error::NonNullOption, "PretreatmentSecondPotential", "PretreatElectrodes", "False", ObjectToString[samplePacketsWithNonNullPretreatmentSecondPotential, Cache -> newCache]]];

	(* -- samplePacketsWithMissingPretreatmentSecondPotential: Message -- *)
	If[!MatchQ[samplePacketsWithMissingPretreatmentSecondPotential, {}]&&!gatherTests,
		Message[Error::MissingOption, "PretreatmentSecondPotential", "PretreatElectrodes", "True", "a voltage", ObjectToString[samplePacketsWithMissingPretreatmentSecondPotential, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullPretreatmentFinalPotential: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullPretreatmentFinalPotential, {}]&&!gatherTests,
		Message[Error::NonNullOption, "PretreatmentFinalPotential", "PretreatElectrodes", "False", ObjectToString[samplePacketsWithNonNullPretreatmentFinalPotential, Cache -> newCache]]];

	(* -- samplePacketsWithMissingPretreatmentFinalPotential: Message -- *)
	If[!MatchQ[samplePacketsWithMissingPretreatmentFinalPotential, {}]&&!gatherTests,
		Message[Error::MissingOption, "PretreatmentFinalPotential", "PretreatElectrodes", "True", "a voltage", ObjectToString[samplePacketsWithMissingPretreatmentFinalPotential, Cache -> newCache]]];

	(* -- samplePacketsWithPretreatmentInitialPotentialNotBetweenFirstAndSecondPotentials: Message -- *)
	If[!MatchQ[samplePacketsWithPretreatmentInitialPotentialNotBetweenFirstAndSecondPotentials, {}]&&!gatherTests,
		Message[Error::IncompatiblePotentials, "PretreatmentInitialPotential", "PretreatmentFirstPotential", "PretreatmentSecondPotential", ObjectToString[samplePacketsWithPretreatmentInitialPotentialNotBetweenFirstAndSecondPotentials, Cache -> newCache]]];

	(* -- samplePacketsWithPretreatmentFinalPotentialNotBetweenFirstAndSecondPotentials: Message -- *)
	If[!MatchQ[samplePacketsWithPretreatmentFinalPotentialNotBetweenFirstAndSecondPotentials, {}]&&!gatherTests,
		Message[Error::IncompatiblePotentials, "PretreatmentFinalPotential", "PretreatmentFirstPotential", "PretreatmentSecondPotential", ObjectToString[samplePacketsWithPretreatmentFinalPotentialNotBetweenFirstAndSecondPotentials, Cache -> newCache]]];

	(* -- samplePacketsWithPretreatmentInitialAndFinalPotentialsTooDifferent: Message -- *)
	If[!MatchQ[samplePacketsWithPretreatmentInitialAndFinalPotentialsTooDifferent, {}]&&!gatherTests,
		Message[Error::TooDifferentPotentials, "PretreatmentInitialPotential", "PretreatmentFinalPotential", ObjectToString[samplePacketsWithPretreatmentInitialAndFinalPotentialsTooDifferent, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullPretreatmentPotentialSweepRate: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullPretreatmentPotentialSweepRate, {}]&&!gatherTests,
		Message[Error::NonNullOption, "PretreatmentPotentialSweepRate", "PretreatElectrodes", "False", ObjectToString[samplePacketsWithNonNullPretreatmentPotentialSweepRate, Cache -> newCache]]];

	(* -- samplePacketsWithMissingPretreatmentPotentialSweepRate: Message -- *)
	If[!MatchQ[samplePacketsWithMissingPretreatmentPotentialSweepRate, {}]&&!gatherTests,
		Message[Error::MissingOption, "PretreatmentPotentialSweepRate", "PretreatElectrodes", "True", "a voltage sweeping rate", ObjectToString[samplePacketsWithMissingPretreatmentPotentialSweepRate, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullPretreatmentNumberOfCycles: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullPretreatmentNumberOfCycles, {}]&&!gatherTests,
		Message[Error::NonNullOption, "PretreatmentNumberOfCycles", "PretreatElectrodes", "False", ObjectToString[samplePacketsWithNonNullPretreatmentNumberOfCycles, Cache -> newCache]]];

	(* -- samplePacketsWithMissingPretreatmentNumberOfCycles: Message -- *)
	If[!MatchQ[samplePacketsWithMissingPretreatmentNumberOfCycles, {}]&&!gatherTests,
		Message[Error::MissingOption, "PretreatmentNumberOfCycles", "PretreatElectrodes", "True", "an integer", ObjectToString[samplePacketsWithMissingPretreatmentNumberOfCycles, Cache -> newCache]]];

	(* ==== Mix related related messages, invalidOptions, and tests ==== *)

	(* INVALID OPTIONS *)
	(* determine if the LoadingSampleMix option has an invalid value or could not be resolved *)
	loadingSampleMixInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithLoadingSampleMixFalseForUnpreparedSample, Except[{}]]
		],
		{LoadingSampleMix},
		{}
	];

	(* determine if the LoadingSampleMixType option has an invalid value or could not be resolved *)
	loadingSampleMixTypeInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullLoadingSampleMixType, Except[{}]],
			MatchQ[samplePacketsWithMissingLoadingSampleMixType, Except[{}]]
		],
		{LoadingSampleMixType},
		{}
	];

	(* determine if the LoadingSampleMixTemperature option has an invalid value or could not be resolved *)
	loadingSampleMixTemperatureInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullLoadingSampleMixTemperature, Except[{}]],
			MatchQ[samplePacketsWithMissingLoadingSampleMixTemperature, Except[{}]],
			MatchQ[samplePacketsWithLoadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixType, Except[{}]]
		],
		{LoadingSampleMixTemperature},
		{}
	];

	(* determine if the LoadingSampleMixUntilDissolved option has an invalid value or could not be resolved *)
	loadingSampleMixUntilDissolvedInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullLoadingSampleMixUntilDissolved, Except[{}]],
			MatchQ[samplePacketsWithMissingLoadingSampleMixUntilDissolved, Except[{}]]
		],
		{LoadingSampleMixUntilDissolved},
		{}
	];

	(* determine if the LoadingSampleMaxNumberOfMixes option has an invalid value or could not be resolved *)
	loadingSampleMaxNumberOfMixesInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixing, Except[{}]],
			MatchQ[samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolved, Except[{}]],
			MatchQ[samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesForShakeMixType, Except[{}]],
			MatchQ[samplePacketsWithMissingLoadingSampleMaxNumberOfMixes, Except[{}]]
		],
		{LoadingSampleMaxNumberOfMixes},
		{}
	];

	(* determine if the LoadingSampleMaxMixTime option has an invalid value or could not be resolved *)
	loadingSampleMaxMixTimeInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixing, Except[{}]],
			MatchQ[samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolved, Except[{}]],
			MatchQ[samplePacketsWithNonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixType, Except[{}]],
			MatchQ[samplePacketsWithMissingLoadingSampleMaxMixTime, Except[{}]]
		],
		{LoadingSampleMaxMixTime},
		{}
	];

	(* determine if the LoadingSampleMixTime option has an invalid value or could not be resolved *)
	loadingSampleMixTimeInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullLoadingSampleMixTimeWhenNotMixing, Except[{}]],
			MatchQ[samplePacketsWithNonNullLoadingSampleMixTimeForPipetteOrInvertMixType, Except[{}]],
			MatchQ[samplePacketsWithMissingLoadingSampleMixTime, Except[{}]],
			MatchQ[samplePacketsWithLoadingSampleMixTimeGreaterThanMaxMixTime, Except[{}]]
		],
		{LoadingSampleMixTime},
		{}
	];

	(* determine if the LoadingSampleNumberOfMixes option has an invalid value or could not be resolved *)
	loadingSampleNumberOfMixesInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullLoadingSampleNumberOfMixesWhenNotMixing, Except[{}]],
			MatchQ[samplePacketsWithNonNullLoadingSampleNumberOfMixesForShakeMixType, Except[{}]],
			MatchQ[samplePacketsWithMissingLoadingSampleNumberOfMixes, Except[{}]],
			MatchQ[samplePacketsWithLoadingSampleNumberOfMixesGreaterThanMaxNumberOfMixes, Except[{}]]
		],
		{LoadingSampleNumberOfMixes},
		{}
	];

	(* determine if the LoadingSampleMixVolume option has an invalid value or could not be resolved *)
	loadingSampleMixVolumeInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullLoadingSampleMixVolumeWhenNotMixing, Except[{}]],
			MatchQ[samplePacketsWithNonNullLoadingSampleMixVolumeForNonPipetteMixType, Except[{}]],
			MatchQ[samplePacketsWithMissingLoadingSampleMixVolume, Except[{}]],
			MatchQ[samplePacketsWithLoadingSampleMixVolumeGreaterThanSolventVolume, Except[{}]]
		],
		{LoadingSampleMixVolume},
		{}
	];

	(* ERROR TESTS *)
	loadingSampleMixGroupedErrorTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithLoadingSampleMixFalseForUnpreparedSample,
				samplePacketsWithNonNullLoadingSampleMixType,
				samplePacketsWithMissingLoadingSampleMixType,
				samplePacketsWithNonNullLoadingSampleMixTemperature,
				samplePacketsWithMissingLoadingSampleMixTemperature,
				samplePacketsWithLoadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixType,
				samplePacketsWithNonNullLoadingSampleMixUntilDissolved,
				samplePacketsWithMissingLoadingSampleMixUntilDissolved,
				samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixing,
				samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolved,
				samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesForShakeMixType,
				samplePacketsWithMissingLoadingSampleMaxNumberOfMixes,
				samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixing,
				samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolved,
				samplePacketsWithNonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixType,
				samplePacketsWithMissingLoadingSampleMaxMixTime,
				samplePacketsWithNonNullLoadingSampleMixTimeWhenNotMixing,
				samplePacketsWithNonNullLoadingSampleMixTimeForPipetteOrInvertMixType,
				samplePacketsWithMissingLoadingSampleMixTime,
				samplePacketsWithLoadingSampleMixTimeGreaterThanMaxMixTime,
				samplePacketsWithNonNullLoadingSampleNumberOfMixesWhenNotMixing,
				samplePacketsWithNonNullLoadingSampleNumberOfMixesForShakeMixType,
				samplePacketsWithMissingLoadingSampleNumberOfMixes,
				samplePacketsWithLoadingSampleNumberOfMixesGreaterThanMaxNumberOfMixes,
				samplePacketsWithNonNullLoadingSampleMixVolumeWhenNotMixing,
				samplePacketsWithNonNullLoadingSampleMixVolumeForNonPipetteMixType,
				samplePacketsWithMissingLoadingSampleMixVolume,
				samplePacketsWithLoadingSampleMixVolumeGreaterThanSolventVolume
			},
			{
				"The LoadingSampleMix is set to True for unprepared solid input sample for `1`:",
				"The LoadingSampleMixType is resolved to Null when LoadingSampleMix is set to False for `1`:",
				"The LoadingSampleMixType is not resolved to Null when LoadingSampleMix is set to True for `1`:",
				"The LoadingSampleMixTemperature is resolved to Null when LoadingSampleMix is set to False for `1`:",
				"The LoadingSampleMixTemperature is not resolved to Null when LoadingSampleMix is set to True for `1`:",
				"The LoadingSampleMixTemperature is set to Ambient when the LoadingSampleMixType is Pipette or Invert for `1`:",
				"The LoadingSampleMixUntilDissolved is resolved to Null when LoadingSampleMix is set to False for `1`:",
				"The LoadingSampleMixUntilDissolved is not resolved to Null when LoadingSampleMix is set to True for `1`:",
				"The LoadingSampleMaxNumberOfMixes is resolved to Null when LoadingSampleMix is set to False for `1`:",
				"The LoadingSampleMaxNumberOfMixes is resolved to Null when LoadingSampleMixUntilDissolved is set to False for `1`:",
				"The LoadingSampleMaxNumberOfMixes is resolved to Null when LoadingSampleMixType is set to Shake for `1`:",
				"The LoadingSampleMaxNumberOfMixes is not resolved to Null when LoadingSampleMix is set to True, LoadingSampleMixType is set to Pipette or Invert, and LoadingSampleMixUntilDissolved is set to True for `1`:",
				"The LoadingSampleMaxMixTime is resolved to Null when LoadingSampleMix is set to False for `1`:",
				"The LoadingSampleMaxMixTime is resolved to Null when LoadingSampleMixUntilDissolved is set to False for `1`:",
				"The LoadingSampleMaxMixTime is resolved to Null when LoadingSampleMixType is set to Pipette or Invert for `1`:",
				"The LoadingSampleMaxMixTime is not resolved to Null when LoadingSampleMix is set to True, LoadingSampleMixType is set to Shake, and LoadingSampleMixUntilDissolved is set to True for `1`:",
				"The LoadingSampleMixTime is resolved to Null when LoadingSampleMix is set to False for `1`:",
				"The LoadingSampleMixTime is resolved to Null when LoadingSampleMixType is set to Pipette or Invert for `1`:",
				"The LoadingSampleMixTime is not resolved to Null when LoadingSampleMix is set to True and LoadingSampleMixType is set to Shake for `1`:",
				"The LoadingSampleMixTime is not greater than the LoadingSampleMaxMixTime for `1`:",
				"The LoadingSampleNumberOfMixes is resolved to Null when LoadingSampleMix is set to False for `1`:",
				"The LoadingSampleNumberOfMixes is resolved to Null when LoadingSampleMixType is set to Shake for `1`:",
				"The LoadingSampleNumberOfMixes is not resolved to Null when LoadingSampleMix is set to True and LoadingSampleMixType is set to Pipette or Invert for `1`:",
				"The LoadingSampleNumberOfMixes is not greater than the LoadingSampleMaxNumberOfMixes for `1`:",
				"The LoadingSampleMixVolume is resolved to Null when LoadingSampleMix is set to False for `1`:",
				"The LoadingSampleMixVolume is resolved to Null when LoadingSampleMixType is not set to Pipette for `1`:",
				"The LoadingSampleMixVolume is not resolved to Null when LoadingSampleMixType is set to Pipette for `1`:",
				"The LoadingSampleMixVolume is not greater than the SolventVolume for `1`:"
			}
		}
	];

	(* ERROR MESSAGES *)
	(* -- samplePacketsWithLoadingSampleMixFalseForUnpreparedSample: Message -- *)
	If[!MatchQ[samplePacketsWithLoadingSampleMixFalseForUnpreparedSample, {}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The LoadingSampleMix is set to False", "set LoadingSampleMix to True if the input sample is unprepared", ObjectToString[samplePacketsWithLoadingSampleMixFalseForUnpreparedSample, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMixType: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMixType, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMixType", "LoadingSampleMix" , "False", ObjectToString[samplePacketsWithNonNullLoadingSampleMixType, Cache -> newCache]]];

	(* -- samplePacketsWithMissingLoadingSampleMixType: Message -- *)
	If[!MatchQ[samplePacketsWithMissingLoadingSampleMixType, {}]&&!gatherTests,
		Message[Error::MissingOption, "LoadingSampleMixType", "LoadingSampleMix", "True", "a mix type", ObjectToString[samplePacketsWithMissingLoadingSampleMixType, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMixTemperature: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMixTemperature, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMixTemperature", "LoadingSampleMix" , "False", ObjectToString[samplePacketsWithNonNullLoadingSampleMixTemperature, Cache -> newCache]]];

	(* -- samplePacketsWithMissingLoadingSampleMixTemperature: Message -- *)
	If[!MatchQ[samplePacketsWithMissingLoadingSampleMixTemperature, {}]&&!gatherTests,
		Message[Error::MissingOption, "LoadingSampleMixTemperature", "LoadingSampleMix", "True", "a temperature between 25 and 75 Celsius", ObjectToString[samplePacketsWithMissingLoadingSampleMixTemperature, Cache -> newCache]]];

	(* -- samplePacketsWithLoadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixType: Message -- *)
	If[!MatchQ[samplePacketsWithLoadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixType, {}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The LoadingSampleMixTemperature is not set to Ambient when the LoadingSampleMixType is Pipette or Invert", "set LoadingSampleMixTemperature to Automatic or to Ambient when the LoadingSampleMixType is Pipette or Invert", ObjectToString[samplePacketsWithLoadingSampleMixTemperatureNotAmbientForPipetteOrInvertMixType, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMixUntilDissolved: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMixUntilDissolved, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMixUntilDissolved", "LoadingSampleMix" , "False", ObjectToString[samplePacketsWithNonNullLoadingSampleMixUntilDissolved, Cache -> newCache]]];

	(* -- samplePacketsWithMissingLoadingSampleMixUntilDissolved: Message -- *)
	If[!MatchQ[samplePacketsWithMissingLoadingSampleMixUntilDissolved, {}]&&!gatherTests,
		Message[Error::MissingOption, "LoadingSampleMixUntilDissolved", "LoadingSampleMix", "True", "a boolean", ObjectToString[samplePacketsWithMissingLoadingSampleMixUntilDissolved, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixing: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixing, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMaxNumberOfMixes", "LoadingSampleMix" , "False", ObjectToString[samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixing, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolved: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolved, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMaxNumberOfMixes", "LoadingSampleMixUntilDissolved" , "False", ObjectToString[samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesWhenNotMixUntilDissolved, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesForShakeMixType: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesForShakeMixType, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMaxNumberOfMixes", "LoadingSampleMixType" , "Shake", ObjectToString[samplePacketsWithNonNullLoadingSampleMaxNumberOfMixesForShakeMixType, Cache -> newCache]]];

	(* -- samplePacketsWithMissingLoadingSampleMaxNumberOfMixes: Message -- *)
	If[!MatchQ[samplePacketsWithMissingLoadingSampleMaxNumberOfMixes, {}]&&!gatherTests,
		Message[Error::MissingOption, "LoadingSampleMaxNumberOfMixes", "LoadingSampleMix", "True, LoadingSampleMixType is set to Pipette or Invert, and LoadingSampleMixUntilDissolved is set to True", "an integer", ObjectToString[samplePacketsWithMissingLoadingSampleMaxNumberOfMixes, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixing: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixing, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMaxMixTime", "LoadingSampleMix" , "False", ObjectToString[samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixing, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolved: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolved, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMaxMixTime", "LoadingSampleMixUntilDissolved" , "False", ObjectToString[samplePacketsWithNonNullLoadingSampleMaxMixTimeWhenNotMixUntilDissolved, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixType: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixType, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMaxMixTime", "LoadingSampleMixType" , "Pipette or Invert", ObjectToString[samplePacketsWithNonNullLoadingSampleMaxMixTimeForPipetteOrInvertMixType, Cache -> newCache]]];

	(* -- samplePacketsWithMissingLoadingSampleMaxMixTime: Message -- *)
	If[!MatchQ[samplePacketsWithMissingLoadingSampleMaxMixTime, {}]&&!gatherTests,
		Message[Error::MissingOption, "LoadingSampleMaxMixTime", "LoadingSampleMix", "True, LoadingSampleMixType is set to Shake, and LoadingSampleMixUntilDissolved is set to True", "a duration", ObjectToString[samplePacketsWithMissingLoadingSampleMaxMixTime, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMixTimeWhenNotMixing: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMixTimeWhenNotMixing, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMixTime", "LoadingSampleMix" , "False", ObjectToString[samplePacketsWithNonNullLoadingSampleMixTimeWhenNotMixing, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMixTimeForPipetteOrInvertMixType: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMixTimeForPipetteOrInvertMixType, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMixTime", "LoadingSampleMixType" , "Pipette or Invert", ObjectToString[samplePacketsWithNonNullLoadingSampleMixTimeForPipetteOrInvertMixType, Cache -> newCache]]];

	(* -- samplePacketsWithMissingLoadingSampleMixTime: Message -- *)
	If[!MatchQ[samplePacketsWithMissingLoadingSampleMixTime, {}]&&!gatherTests,
		Message[Error::MissingOption, "LoadingSampleMixTime", "LoadingSampleMix", "True and LoadingSampleMixType is set to Shake", "a duration", ObjectToString[samplePacketsWithMissingLoadingSampleMixTime, Cache -> newCache]]];

	(* -- samplePacketsWithLoadingSampleMixTimeGreaterThanMaxMixTime: Message -- *)
	If[!MatchQ[samplePacketsWithLoadingSampleMixTimeGreaterThanMaxMixTime, {}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The LoadingSampleMixTime is greater than the LoadingSampleMaxMixTime", "make sure LoadingSampleMixTime is less than or equal to the LoadingSampleMaxMixTime", ObjectToString[samplePacketsWithLoadingSampleMixTimeGreaterThanMaxMixTime, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleNumberOfMixesWhenNotMixing: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleNumberOfMixesWhenNotMixing, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleNumberOfMixes", "LoadingSampleMix" , "False", ObjectToString[samplePacketsWithNonNullLoadingSampleNumberOfMixesWhenNotMixing, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleNumberOfMixesForShakeMixType: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleNumberOfMixesForShakeMixType, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleNumberOfMixes", "LoadingSampleMixType" , "Shake", ObjectToString[samplePacketsWithNonNullLoadingSampleNumberOfMixesForShakeMixType, Cache -> newCache]]];

	(* -- samplePacketsWithMissingLoadingSampleNumberOfMixes: Message -- *)
	If[!MatchQ[samplePacketsWithMissingLoadingSampleNumberOfMixes, {}]&&!gatherTests,
		Message[Error::MissingOption, "LoadingSampleNumberOfMixes", "LoadingSampleMix", "True and LoadingSampleMixType is set to Pipette or Invert", "an integer", ObjectToString[samplePacketsWithMissingLoadingSampleNumberOfMixes, Cache -> newCache]]];

	(* -- samplePacketsWithLoadingSampleNumberOfMixesGreaterThanMaxNumberOfMixes: Message -- *)
	If[!MatchQ[samplePacketsWithLoadingSampleNumberOfMixesGreaterThanMaxNumberOfMixes, {}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The LoadingSampleNumberOfMixes is greater than the LoadingSampleMaxNumberOfMixes", "make sure LoadingSampleNumberOfMixes is less than or equal to the LoadingSampleMaxNumberOfMixes", ObjectToString[samplePacketsWithLoadingSampleNumberOfMixesGreaterThanMaxNumberOfMixes, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMixVolumeWhenNotMixing: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMixVolumeWhenNotMixing, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMixVolume", "LoadingSampleMix" , "False", ObjectToString[samplePacketsWithNonNullLoadingSampleMixVolumeWhenNotMixing, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullLoadingSampleMixVolumeForNonPipetteMixType: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullLoadingSampleMixVolumeForNonPipetteMixType, {}]&&!gatherTests,
		Message[Error::NonNullOption, "LoadingSampleMixVolume", "LoadingSampleMixType" , "not Pipette", ObjectToString[samplePacketsWithNonNullLoadingSampleMixVolumeForNonPipetteMixType, Cache -> newCache]]];

	(* -- samplePacketsWithMissingLoadingSampleMixVolume: Message -- *)
	If[!MatchQ[samplePacketsWithMissingLoadingSampleMixVolume, {}]&&!gatherTests,
		Message[Error::MissingOption, "LoadingSampleMixVolume", "LoadingSampleMixType", "set to Pipette", "a volume", ObjectToString[samplePacketsWithMissingLoadingSampleMixVolume, Cache -> newCache]]];

	(* -- samplePacketsWithLoadingSampleMixVolumeGreaterThanSolventVolume: Message -- *)
	If[!MatchQ[samplePacketsWithLoadingSampleMixVolumeGreaterThanSolventVolume, {}]&&!gatherTests,
		Message[Error::IncompatibleOptions, "The LoadingSampleMixVolume is greater than the SolventVolume", "set LoadingSampleMixVolume to Automatic or to a volume less than the SolventVolume", ObjectToString[samplePacketsWithLoadingSampleMixVolumeGreaterThanSolventVolume, Cache -> newCache]]];

	(* ==== Sparging related related messages, invalidOptions, and tests ==== *)

	(* INVALID OPTIONS *)
	(* determine if the SpargingGas option has an invalid value or could not be resolved *)
	spargingGasInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullSpargingGas, Except[{}]],
			MatchQ[samplePacketsWithMissingSpargingGas, Except[{}]]
		],
		{SpargingGas},
		{}
	];

	(* determine if the SpargingTime option has an invalid value or could not be resolved *)
	spargingTimeInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullSpargingTime, Except[{}]],
			MatchQ[samplePacketsWithMissingSpargingTime, Except[{}]],
			MatchQ[samplePacketsWithTooLongSpargingTime, Except[{}]]
		],
		{SpargingTime},
		{}
	];

	(* determine if the SpargingPreBubbler option has an invalid value or could not be resolved *)
	spargingPreBubblerInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithNonNullSpargingPreBubbler, Except[{}]],
			MatchQ[samplePacketsWithMissingSpargingPreBubbler, Except[{}]]
		],
		{SpargingPreBubbler},
		{}
	];

	(* ERROR TESTS *)
	spargingGroupedErrorTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithNonNullSpargingGas,
				samplePacketsWithMissingSpargingGas,
				samplePacketsWithNonNullSpargingTime,
				samplePacketsWithMissingSpargingTime,
				samplePacketsWithTooLongSpargingTime,
				samplePacketsWithNonNullSpargingPreBubbler,
				samplePacketsWithMissingSpargingPreBubbler
			},
			{
				"The SpargingGas is resolved to Null when Sparging is set to False for `1`:",
				"The SpargingGas is not resolved to Null when Sparging is set to True for `1`:",
				"The SpargingTime is resolved to Null when Sparging is set to False for `1`:",
				"The SpargingTime is not resolved to Null when Sparging is set to True for `1`:",
				"The SpargingTime is not longer than 1 Hour for `1`:",
				"The SpargingPreBubbler is resolved to Null when Sparging is set to False for `1`:",
				"The SpargingPreBubbler is not resolved to Null when Sparging is set to True for `1`:"
			}
		}
	];

	(* ERROR MESSAGES *)
	(* -- samplePacketsWithNonNullSpargingGas: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullSpargingGas, {}]&&!gatherTests,
		Message[Error::NonNullOption, "SpargingGas", "Sparging", "False", ObjectToString[samplePacketsWithNonNullSpargingGas, Cache -> newCache]]];

	(* -- samplePacketsWithMissingSpargingGas: Message -- *)
	If[!MatchQ[samplePacketsWithMissingSpargingGas, {}]&&!gatherTests,
		Message[Error::MissingOption, "SpargingGas", "Sparging", "True", "the gas used for the sparging process", ObjectToString[samplePacketsWithMissingSpargingGas, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullSpargingTime: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullSpargingTime, {}]&&!gatherTests,
		Message[Error::NonNullOption, "SpargingTime", "Sparging", "False", ObjectToString[samplePacketsWithNonNullSpargingTime, Cache -> newCache]]];

	(* -- samplePacketsWithMissingSpargingTime: Message -- *)
	If[!MatchQ[samplePacketsWithMissingSpargingTime, {}]&&!gatherTests,
		Message[Error::MissingOption, "SpargingTime", "Sparging", "True", "a duration between 30 Second and 1 Hour", ObjectToString[samplePacketsWithMissingSpargingTime, Cache -> newCache]]];

	(* -- samplePacketsWithTooLongSpargingTime: Message -- *)
	If[!MatchQ[samplePacketsWithTooLongSpargingTime, {}]&&!gatherTests,
		Message[Error::TooLongSpargingTime, ObjectToString[samplePacketsWithTooLongSpargingTime, Cache -> newCache]]];

	(* -- samplePacketsWithNonNullSpargingPreBubbler: Message -- *)
	If[!MatchQ[samplePacketsWithNonNullSpargingPreBubbler, {}]&&!gatherTests,
		Message[Error::NonNullOption, "SpargingPreBubbler", "Sparging", "False", ObjectToString[samplePacketsWithNonNullSpargingPreBubbler, Cache -> newCache]]];

	(* -- samplePacketsWithMissingSpargingPreBubbler: Message -- *)
	If[!MatchQ[samplePacketsWithMissingSpargingPreBubbler, {}]&&!gatherTests,
		Message[Error::MissingOption, "SpargingPreBubbler", "Sparging", "True", "a boolean", ObjectToString[samplePacketsWithMissingSpargingPreBubbler, Cache -> newCache]]];

	(* ==== Cyclic Voltammetry Measurement related related messages, invalidOptions, and tests ==== *)

	(* INVALID OPTIONS *)
	(* determine if the InitialPotentials option has an invalid value or could not be resolved *)
	initialPotentialsInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithInitialPotentialsLengthMismatchNumberOfCycles, Except[{}]],
			MatchQ[samplePacketsWithInitialPotentialNotBetweenFirstAndSecondPotentials, Except[{}]],
			MatchQ[samplePacketsWithInitialAndFinalPotentialsTooDifferent, Except[{}]]
		],
		{InitialPotentials},
		{}
	];

	(* determine if the FirstPotentials option has an invalid value or could not be resolved *)
	firstPotentialsInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithFirstPotentialsLengthMismatchNumberOfCycles, Except[{}]]
		],
		{FirstPotentials},
		{}
	];

	(* determine if the SecondPotentials option has an invalid value or could not be resolved *)
	secondPotentialsInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithSecondPotentialsLengthMismatchNumberOfCycles, Except[{}]]
		],
		{SecondPotentials},
		{}
	];

	(* determine if the FinalPotentials option has an invalid value or could not be resolved *)
	finalPotentialsInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithFinalPotentialsLengthMismatchNumberOfCycles, Except[{}]],
			MatchQ[samplePacketsWithFinalPotentialNotBetweenFirstAndSecondPotentials, Except[{}]],
			MatchQ[samplePacketsWithInitialAndFinalPotentialsTooDifferent, Except[{}]]
		],
		{FinalPotentials},
		{}
	];

	(* determine if the PotentialSweepRates option has an invalid value or could not be resolved *)
	potentialSweepRatesInvalidOptions = If[
		Or[
			MatchQ[samplePacketsWithPotentialSweepRatesLengthMismatchNumberOfCycles, Except[{}]]
		],
		{PotentialSweepRates},
		{}
	];

	(* ERROR TESTS *)
	cyclicVoltammetryMeasurementGroupedErrorTests = MapThread[
		cyclicVoltammetrySampleTests[gatherTests,
			Test,
			samplePackets,
			#1,
			#2,
			newCache]&,
		{
			{
				samplePacketsWithInitialPotentialsLengthMismatchNumberOfCycles,
				samplePacketsWithFirstPotentialsLengthMismatchNumberOfCycles,
				samplePacketsWithSecondPotentialsLengthMismatchNumberOfCycles,
				samplePacketsWithFinalPotentialsLengthMismatchNumberOfCycles,
				samplePacketsWithPotentialSweepRatesLengthMismatchNumberOfCycles,
				samplePacketsWithInitialPotentialNotBetweenFirstAndSecondPotentials,
				samplePacketsWithFinalPotentialNotBetweenFirstAndSecondPotentials,
				samplePacketsWithInitialAndFinalPotentialsTooDifferent
			},
			{
				"The length of the InitialPotentials list matches with NumberOfCycles for `1`:",
				"The length of the FirstPotentials list matches with NumberOfCycles for `1`:",
				"The length of the SecondPotentials list matches with NumberOfCycles for `1`:",
				"The length of the FinalPotentials list matches with NumberOfCycles for `1`:",
				"The length of the PotentialSweepRates list matches with NumberOfCycles for `1`:",
				"All entries in the InitialPotentials list is between its corresponding entries in the FirstPotentials list and SecondPotentials list for `1`:",
				"All entries in the FinalPotentials list is between its corresponding entries in the FirstPotentials list and SecondPotentials list for `1`:",
				"All entries in the InitialPotentials has a voltage difference less than or equal to 0.5 Volt with its corresponding entry in the FinalPotentials list for `1`:"
			}
		}
	];

	(* ERROR MESSAGES *)
	(* -- samplePacketsWithInitialPotentialsLengthMismatchNumberOfCycles: Message -- *)
	If[!MatchQ[samplePacketsWithInitialPotentialsLengthMismatchNumberOfCycles, {}]&&!gatherTests,
		Message[Error::MismatchNumberOfCycles, "InitialPotentials", ObjectToString[samplePacketsWithInitialPotentialsLengthMismatchNumberOfCycles, Cache -> newCache]]];

	(* -- samplePacketsWithFirstPotentialsLengthMismatchNumberOfCycles: Message -- *)
	If[!MatchQ[samplePacketsWithFirstPotentialsLengthMismatchNumberOfCycles, {}]&&!gatherTests,
		Message[Error::MismatchNumberOfCycles, "FirstPotentials", ObjectToString[samplePacketsWithFirstPotentialsLengthMismatchNumberOfCycles, Cache -> newCache]]];

	(* -- samplePacketsWithSecondPotentialsLengthMismatchNumberOfCycles: Message -- *)
	If[!MatchQ[samplePacketsWithSecondPotentialsLengthMismatchNumberOfCycles, {}]&&!gatherTests,
		Message[Error::MismatchNumberOfCycles, "SecondPotentials", ObjectToString[samplePacketsWithSecondPotentialsLengthMismatchNumberOfCycles, Cache -> newCache]]];

	(* -- samplePacketsWithFinalPotentialsLengthMismatchNumberOfCycles: Message -- *)
	If[!MatchQ[samplePacketsWithFinalPotentialsLengthMismatchNumberOfCycles, {}]&&!gatherTests,
		Message[Error::MismatchNumberOfCycles, "FinalPotentials", ObjectToString[samplePacketsWithFinalPotentialsLengthMismatchNumberOfCycles, Cache -> newCache]]];

	(* -- samplePacketsWithPotentialSweepRatesLengthMismatchNumberOfCycles: Message -- *)
	If[!MatchQ[samplePacketsWithPotentialSweepRatesLengthMismatchNumberOfCycles, {}]&&!gatherTests,
		Message[Error::MismatchNumberOfCycles, "PotentialSweepRates", ObjectToString[samplePacketsWithPotentialSweepRatesLengthMismatchNumberOfCycles, Cache -> newCache]]];

	(* -- samplePacketsWithInitialPotentialNotBetweenFirstAndSecondPotentials: Message -- *)
	If[!MatchQ[samplePacketsWithInitialPotentialNotBetweenFirstAndSecondPotentials, {}]&&!gatherTests,
		Message[Error::IncompatiblePotentialLists, "InitialPotentials", "FirstPotentials", "SecondPotentials", ObjectToString[samplePacketsWithInitialPotentialNotBetweenFirstAndSecondPotentials, Cache -> newCache]]];

	(* -- samplePacketsWithFinalPotentialNotBetweenFirstAndSecondPotentials: Message -- *)
	If[!MatchQ[samplePacketsWithFinalPotentialNotBetweenFirstAndSecondPotentials, {}]&&!gatherTests,
		Message[Error::IncompatiblePotentialLists, "FinalPotentials", "FirstPotentials", "SecondPotentials", ObjectToString[samplePacketsWithFinalPotentialNotBetweenFirstAndSecondPotentials, Cache -> newCache]]];

	(* -- samplePacketsWithInitialAndFinalPotentialsTooDifferent: Message -- *)
	If[!MatchQ[samplePacketsWithInitialAndFinalPotentialsTooDifferent, {}]&&!gatherTests,
		Message[Error::PotentialsTooDifferent, ObjectToString[samplePacketsWithInitialAndFinalPotentialsTooDifferent, Cache -> newCache]]];

	(* ------------------------ *)
	(* -- ALIQUOT RESOLUTION -- *)
	(* ------------------------ *)

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	(*targetContainers=targetAliquotContainerList;*)
	(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
	(* When you do not want an aliquot to happen for the corresponding simulated sample, make the corresponding index of targetContainers Null. *)
	(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)

	(*figure out the required aliquot amounts*)

	(* determine the sample volumes and masses for each member of SamplesIn *)
	(* loadingSampleVolumes is gathered above *)
	sampleAmounts = Lookup[resolvedOptionsAssociation, SampleAmount];

	(*first get the volume and mass of our original samples (not simulated)*)
	{sampleVolumes,sampleMasses}=Transpose[Lookup[fetchPacketFromCache[#,inheritedCache],{Volume,Mass}]&/@mySamples];

	(*get the best aliquot amount based on the available amount*)
	bestAliquotAmount=MapThread[
		Function[
			{sampleVol, sampleMass, neededVol, neededMass},
			Which[
				(* TODO: check the volume roundings here and all the places above!!! *)
				MatchQ[sampleVol,GreaterP[0*Liter]] && !MatchQ[sampleMass, MassP], neededVol,
				MatchQ[sampleMass,GreaterP[0*Gram]] && MatchQ[neededMass, MassP], neededMass
			]
		],
		{sampleVolumes, sampleMasses, loadingSampleVolumes, sampleAmounts}
	];

	(* ------------------------------------ *)


	(* - Make a list of the smallest liquid handler compatible container that can potentially hold the needed volume for each sample - *)
	(* First, find the Models and the MaxVolumes of the liquid handler compatible containers *)
	{liquidHandlerContainerModels,liquidHandlerContainerMaxVolumes}=Transpose[Lookup[
		Flatten[liquidHandlerContainerPackets,1],
		{Object,MaxVolume}
	]];

	(* Define the container we would transfer into for each sample, if Aliquotting needed to happen *)
	potentialAliquotContainers=
			If[VolumeQ[#],
				First[
					PickList[
						liquidHandlerContainerModels,
						liquidHandlerContainerMaxVolumes,
						GreaterEqualP[#]
					]
				],
				Null
			]&/@bestAliquotAmount;

	(* Find the ContainerModel for each input sample *)
	simulatedSamplesContainerModels=Lookup[sampleContainerPackets,Model,{}][Object];

	(*add state to the mapthread, treat Nulls as Solids*)
	(* Define the RequiredAliquotContainers - we have to aliquot if the samples are not in a liquid handler compatible container *)
	requiredAliquotContainers=MapThread[
		If[(MatchQ[#1, Alternatives@@liquidHandlerContainerModels]||MatchQ[#2, Null]),
			Automatic,
			#2
		]&,
		{simulatedSamplesContainerModels,potentialAliquotContainers}
	];

	(* ------------------------------------ *)

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentCyclicVoltammetry,
			mySamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolvedSamplePrepOptions],
			Cache -> newCache,
			Simulation -> simulation,
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->bestAliquotAmount,
			AliquotWarningMessage->Null,
			AllowSolids -> True,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentCyclicVoltammetry,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions,resolvedSamplePrepOptions],
				Cache -> newCache,
				Simulation -> simulation,
				RequiredAliquotContainers->requiredAliquotContainers,
				RequiredAliquotAmounts->bestAliquotAmount,
				AliquotWarningMessage->Null,
				AllowSolids -> True,
				Output->Result
			],
			{}
		}
	];

	(* --- Resolve Label Options *)
	resolvedSampleLabel=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		suppliedSampleObjects = Download[simulatedSamples, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["cyclic voltammetry sample"], Length[uniqueSamples]];
		preResolvedSampleLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueSamples, preResolvedSampleLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
					LookupObjectLabel[updatedSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedSampleLabelRules, Download[object, Object]]
				]
			],
			{suppliedSampleObjects, Lookup[roundedOptions, SampleLabel]}
		]
	];

	resolvedSampleContainerLabel=Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["cyclic voltammetry sample container"], Length[uniqueContainers]];
		preResolvedContainerLabelRules = MapThread[
			(#1 -> #2)&,
			{uniqueContainers, preresolvedSampleContainerLabels}
		];

		MapThread[
			Function[{object, label},
				Which[
					MatchQ[label, Except[Automatic]],
					label,
					MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
					LookupObjectLabel[updatedSimulation, Download[object, Object]],
					True,
					Lookup[preResolvedContainerLabelRules, Download[object, Object]]
				]
			],
			{suppliedContainerObjects, Lookup[roundedOptions, SampleContainerLabel]}
		]
	];


	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	(* gather the invalid inputs *)
	invalidInputs=DeleteDuplicates[Flatten[{
		compatibleMaterialsInvalidInputs,
		deprecatedInvalidInputs,
		discardedInvalidInputs,
		tooManyInputSamplesInvalidInputs,

		(* Found in MapThread *)
		missingCompositionInvalidInputs,
		missingAnalyteInvalidInputs,
		IncompleteCompositionInvalidInputs,
		ambiguousAnalyteInvalidInputs,
		unresolvableCompositionUnitInvalidInputs,

		preparedSampleMissingSolventInvalidInputs,
		preparedSampleSolventAmbiguousMoleculeInvalidInputs,
		preparedSampleElectrolyteMoleculeWithUnresolvableCompositionUnitInvalidInputs,
		preparedSampleElectrolyteMoleculeMissingMolecularWeightInvalidInputs,
		preparedSampleElectrolyteMoleculeMissingDefaultModelSampleInvalidInputs,
		preparedSampleElectrolyteMoleculeNotFoundInvalidInputs,
		preparedSampleAmbiguousElectrolyteMoleculeInvalidInputs,

		preparedSampleInvalidCompositionLengthForNoneInternalStandardInvalidInputs,
		preparedSampleInvalidCompositionLengthForAfterInternalStandardAdditionOrderInvalidInputs,
		preparedSampleInvalidCompositionLengthForBeforeInternalStandardAdditionOrderInvalidInputs
	}]];


	(*add the invalid options here*)
	(* gather the invalid options *)
	invalidOptions=DeleteCases[
		DeleteDuplicates[
			Flatten[
				{
					(* Too large NumberOfReplicates *)
					tooLargerNumberOfReplicatesInvalidOptions,

					(* Deprecated Electrode models *)
					deprecatedWorkingElectrodeModelInvalidOption,
					deprecatedCounterElectrodeModelInvalidOption,
					deprecatedReferenceElectrodeModelInvalidOption,

					(* Polishing-related invalid options *)
					coatedWorkingElectrodeInvalidOptions,
					nonNullPolishingParametersInvalidOptions,
					missingPolishingParametersInvalidOptions,
					mismatchingLengthPolishingParametersInvalidOptions,
					nonPolishingSolutionsInvalidOptions,

					(* Sonication-related invalid options *)
					sonicationSensitiveWorkingElectrodeInvalidOptions,
					nonNullSonicationParametersInvalidOptions,
					missingSonicationParametersInvalidOptions,

					(* Electrode washing related invalid options *)
					nonNullWorkingElectrodeWashingCyclesInvalidOptions,
					missingWorkingElectrodeWashingCyclesInvalidOptions,

					(* LoadingSample volumes related invalid options *)
					mismatchingSampleStateInvalidOptions,
					mismatchingReactionVesselWithElectrodeCapInvalidOptions,
					solventVolumeInvalidOptions,
					loadingSampleVolumeInvalidOptions,

					(*analyte related options*)
					analyteInvalidOptions,
					sampleAmountInvalidOptions,
					loadingSampleTargetConcentrationInvalidOptions,

					(* solvent and electrolyte *)
					solventInvalidOptions, electrolyteInvalidOptions, electrolyteSolutionInvalidOptions, electrolyteSolutionLoadingVolumeInvalidOptions, loadingSampleElectrolyteAmountInvalidOptions, electrolyteTargetConcentrationInvalidOptions,

					(* reference electrode and reference solution options *)
					refreshReferenceElectrodeInvalidOptions, referenceElectrodeInvalidOptions, referenceElectrodeSoakTimeInvalidOptions,

					(* internal standard options *)
					internalStandardInvalidOptions, internalStandardAdditionOrderInvalidOptions, internalStandardAmountInvalidOptions, internalStandardTargetConcentrationInvalidOptions,

					(* pretreat electrode options *)
					pretreatmentSparingInvalidOptions, pretreatmentSpargingPreBubblerInvalidOptions, pretreatmentInitialPotentialInvalidOptions, pretreatmentFirstPotentialInvalidOptions, pretreatmentSecondPotentialInvalidOptions, pretreatmentFinalPotentialInvalidOptions, pretreatmentPotentialSweepRateInvalidOptions, pretreatmentNumberOfCyclesInvalidOptions,

					(* mix options *)
					loadingSampleMixInvalidOptions, loadingSampleMixTypeInvalidOptions, loadingSampleMixTemperatureInvalidOptions, loadingSampleMixTimeInvalidOptions, loadingSampleNumberOfMixesInvalidOptions, loadingSampleMixVolumeInvalidOptions, loadingSampleMixUntilDissolvedInvalidOptions, loadingSampleMaxNumberOfMixesInvalidOptions, loadingSampleMaxMixTimeInvalidOptions,

					(* sparging options *)
					spargingGasInvalidOptions, spargingTimeInvalidOptions, spargingPreBubblerInvalidOptions,

					(* cv measurement options *)
					initialPotentialsInvalidOptions, firstPotentialsInvalidOptions, secondPotentialsInvalidOptions, finalPotentialsInvalidOptions, potentialSweepRatesInvalidOptions
				}
			]
		],
		Null
	];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->newCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	cyclicVoltammetryTests = Cases[Flatten[
		{

			deprecatedTest,
			discardedTest,
			compatibleMaterialsTests,
			tooManyInputSamplesTest,
			tooLargeNumberOfReplicatesTests,
			deprecatedWorkingElectrodeModelTest,
			deprecatedCounterElectrodeModelTest,
			deprecatedReferenceElectrodeModelTest,

			(*storage condition tests*)
			validSamplesInStorageConditionTests,

			(* polishing parameter tests *)
			polishingParametersGroupedErrorTests,

			(* sonication parameter tests *)
			sonicationParametersGroupedErrorTests,

			(* electrode washing tests *)
			electrodeWashingGroupedErrorTests,

			(*analyte related tests*)
			analyteOptionsGroupedErrorTests,

			(* solvent/electrolyte related tests *)
			solventAndElectrolyteOptionsGroupedErrorTests,

			(* solvent/electrolyte warning tests*)
			solventAndElectrolyteOptionsGroupedWarningTests,

			(* loading sample volumes tests and warnings *)
			loadingSampleVolumesGroupedErrorTests,
			solventVolumeLargerThanLoadingSampleVolumeTests,

			(* analyte related options *)
			analyteOptionsGroupedErrorTests,

			(* solvent and electrolyte *)
			solventAndElectrolyteOptionsGroupedErrorTests, solventAndElectrolyteOptionsGroupedWarningTests,

			(* reference electrode and reference solution options *)
			referenceElectrodeGroupedErrorTests, referenceElectrodeGroupedWarningTests,

			(* internal standard options *)
			internalStandardGroupedErrorTests,

			(* pretreat electrode options *)
			pretreatElectrodesGroupedErrorTests,

			(* loading sample mix options *)
			loadingSampleMixGroupedErrorTests,

			(* sparging options *)
			spargingGroupedErrorTests,

			(* cv measurement options *)
			cyclicVoltammetryMeasurementGroupedErrorTests
		}
	], _EmeraldTest];

	(* ------------------------ *)
	(* --- RESOLVED OPTIONS --- *)
	(* ------------------------ *)


	resolvedOptions = ReplaceRule[Normal[roundedOptions],
		Flatten[
			{
				(* -- map thread resolved options -- *)
				Normal[resolvedOptionsAssociation],

				(* --- pass through and other resolved options --- *)
				{
					SampleLabel->resolvedSampleLabel,
					SampleContainerLabel->resolvedSampleContainerLabel
				},
				resolvedSamplePrepOptions,
				resolvedAliquotOptions,
				resolvedPostProcessingOptions
			}
		]
	]/.x:ObjectP[]:>Download[x,Object];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> cyclicVoltammetryTests
	}
];

(* cyclicVoltammetryResourcePackets *)



(* ====================== *)
(* == RESOURCE PACKETS == *)
(* ====================== *)

DefineOptions[cyclicVoltammetryResourcePackets,
	Options:>{
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];

cyclicVoltammetryResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},myCollapsedResolvedOptions:{___Rule},myOptions:OptionsPattern[]]:=Module[
	{
		(* general variables *)
		expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output,
		gatherTests, messages, cache, simulation, simulatedSamples, updatedSimulation,

		(* resolved option values *)
		instrument,
		workingElectrode, counterElectrode, electrodeCap,
		polishWorkingElectrodes, polishingPads, polishingSolutions, numberOfPolishingDroplets, numberOfPolishings,
		workingElectrodeSonications, workingElectrodeSonicationTimes, workingElectrodeSonicationTemperatures,
		workingElectrodeWashings, workingElectrodeWashingCycles, counterElectrodeWashings,
		preparedSamples, reactionVessels, loadingSampleVolumes, solventVolumes, analytes, sampleAmounts, targetConcentrations,
		solvents, electrolytes, pretreatElectrodes, electrolyteSolutions, electrolyteSolutionLoadingVolumes, loadingSampleElectrolyteAmounts, electrolyteTargetConcentrations,
		referenceElectrodes, refreshReferenceElectrodes, referenceElectrodeSoakTimes,
		internalStandards, internalStandardAdditionOrders, internalStandardAmounts, internalStandardTargetConcentrations,
		pretreatmentSpargings, pretreatmentSpargingPreBubblers, pretreatmentInitialPotentials, pretreatmentFirstPotentials, pretreatmentSecondPotentials, pretreatmentFinalPotentials, pretreatmentPotentialSweepRates, pretreatmentNumberOfCycles,
		loadingSampleMixes, loadingSampleMixTypes, loadingSampleMixTemperatures, loadingSampleMixTimes, loadingSampleNumberOfMixes, loadingSampleMixVolumes, loadingSampleMixUntilDissolveds, loadingSampleMaxNumberOfMixes, loadingSampleMaxMixTimes,
		spargings, spargingGases, spargingTimes, spargingPreBubblers,
		initialPotentials, firstPotentials, secondPotentials, finalPotentials, potentialSweepRates, numberOfCycles,
		samplesInStorageConditions, samplesOutStorageConditions,

		(*download*)
		objectSamplePacketFields, listedSamplePackets,liquidHandlerContainerDownload, samplePackets,
		sampleCompositionPackets, listedSampleContainers, sampleContainersIn, liquidHandlerContainerMaxVolumes,
		liquidHandlerContainers,

		(* default variables *)
		numberOfSamples, defaultSpargingPressure, defaultWaterSquirtBottles, defaultWaterSquirtBottleMaxVolumes, defaultMethanolSquirtBottles, defaultMethanolSquirtBottleMaxVolumes, defaultSpargingPreBubblers, defaultSpargingPreBubblerMaxVolumes, preferredContainers, preferredContainerMaxVolumes, preferredContainerHeights, singlePolishingSolutionDropletVolume, resourceExpansionFactor,

		(* samples in resources *)
		expandedAliquotAmount, safeSampleAmounts, pairedSamplesInAndAmounts,
		sampleAmountRules, sampleResourceReplaceRules, samplesInResources,

		(* -- Electrodes -- *)
		workingElectrodeResource, counterElectrodeResource, uniqueReferenceElectrodes, referenceElectrodeReplaceRules, referenceElectrodeLengths, sortedPreferredContainersByHeight, sortedPreferredContainerHeights, selectedReferenceElectrodeContainerModels, referenceElectrodesField,

		(* other resources *)
		instrumentResource, reactionVesselHolderModel, reactionVesselHolderResource, fumeHoodModel, fumeHoodResource,
		schlenkLineModel, schlenkLineResources, postMeasurementStandardAdditionSchlenkLineResources,
		reactionVesselModels, reactionVesselResources, electrodeCapResource, tweezerResource,
		electrodeImagingRackModel, electrodeImagingRackResource, referenceElectrodeRackModel, referenceElectrodeRackResource,

		(* WorkingElectrode Polishing *)
		numberOfElectrodePolishings, polishingWaterVolume, polishingMethanolVolume,

		uniquePolishingPads, polishingPadsReplaceRules, uniquePolishingPadsField,
		defaultPolishingPlates, polishingPadToPlateResourceReplaceRules, polishingPlates, uniquePolishingPlatesField,
		uniquePolishingSolutions, polishingSolutionTotalDropletsCounts, polishingSolutionWithDroplets, uniquePolishingSolutionsWithDropletCounts, polishingSolutionsReplaceRules, uniquePolishingSolutionsField, uniquePolishingSolutionVolumes,
		safePrimaryPolishings, safeSecondaryPolishings, safeTertiaryPolishings,

		(* WorkingElectrode Sonication *)
		safeWorkingElectrodeSonicationTimes, safeWorkingElectrodeSonicationTemperatures, workingElectrodeSonicationContainerModel, workingElectrodeSonicationContainerModelMaxVolume, workingElectrodeSonicationContainerResource, safeWorkingElectrodeSonicationSolventVolume, workingElectrodeSonicationSolventResource,

		(* Electrode Washing *)
		numberOfWorkingElectrodeWashings, numberOfCounterElectrodeWashings, numberOfElectrodeWashings,
		washingWaterVolume, washingMethanolVolume,
		totalSquirtWaterVolume, totalSquirtMethanolVolume,
		washingWaterModel, washingMethanolModel,
		uniqueElectrodeWashingSolutionField, uniqueElectrodeWashingSolutionVolumes,
		safeWorkingElectrodePolishWashingSolutions, safeWorkingElectrodeWashingSolutions, safeCounterElectrodeWashingSolutions, safeWorkingElectrodeWashingCycles,
		waterCollectionContainerModel, methanolCollectionContainerModel, washingSolutionCollectionContainerResources, dryWorkingElectrodeField, dryCounterElectrodeField, washingWaterCollectionContainerField, washingMethanolCollectionContainerField,

		(* Electrodes pretreatment *)
		requiredElectrolyteSolutionVolumes, safeElectrodeSolutionLoadingVolumes, pairedElectrolyteSolutionAndLoadingVolumes, electrolyteSolutionLoadingVolumesRules, electrolyteSolutionResourceReplaceRules, electrolyteSolutionResources,

		pretreatmentReactionVesselResources, safePretreatmentSpargingGases, safePretreatmentSpargingTimes, safePretreatmentSpargingPressures, safePretreatmentPotentials, safePretreatmentPrimaryPotentials, safePretreatmentSecondaryPotentials, safePretreatmentTertiaryPotentials, safePretreatmentQuaternaryPotentials,

		(* LoadingSample preparation *)
		safeSampleDilutions, safeSolidSampleAmounts, safeTargetConcentrations, safeSolventVolumes,

		requiredLoadingSampleElectrolyteAmounts, pairedLoadingSampleElectrolyteAndAmounts, loadingSampleElectrolyteAmountRules, loadingSampleElectrolyteResourceReplaceRules, loadingSampleElectrolyteResources, electrolytesField, safeLoadingSampleElectrolyteAmounts, safeElectrolyteTargetConcentrations,

		(* InternalStandard *)
		requiredInternalStandardAmounts, pairedInternalStandardAndAmounts, internalStandardAmountRules, internalStandardResourceReplaceRules, internalStandardResources, internalStandardsField, safeInternalStandardAmounts, safeInternalStandardTargetConcentrations, safeInternalStandardAdditionOrders, postMeasurementStandardAdditionContainerResources,

		(* LoadingSampleMix Fields *)
		loadingSamplePreparationContainerResources, safeLoadingSampleMixes, safeLoadingSampleMixTypes, safeLoadingSampleMixTemperatures, safeLoadingSampleMixTimes, safeLoadingSampleNumberOfMixes, safeLoadingSampleMixVolumes, safeLoadingSampleMixUntilDissolveds, safeLoadingSampleMaxNumberOfMixes, safeLoadingSampleMaxMixTimes,

		(* Sparging *)
		safeSpargingPressures, safeSpargingGases, safeSpargingTimes,

		(* Helper Fields *)
		requireSchlenkLinesField,

		potentialNeedleModelPackets, sortedNeedleModelPackets, needleModels, needleLengths, ventingNeedleModel, reactionVesselVentingNeedleResource, reactionVesselDimensions, reactionVesselsMaxHeight, electrodeCapHeight, inletNeedleRequiredLength, inletNeedleModel, pretreatmentSpargingWithoutReplicates, spargingWithoutReplicates, inletNeedleResourceReplaceRules, reactionVesselInletNeedlesField,

		(* PreBubblers *)
		preBubblerRequired, preBubblerModel, preBubblerMaxVolume, preBubblerSolventVolume, pretreatmentSolventVolumes, spargingSolventVolumes, preBubblerSolventVolumes, uniqueSolvents, uniqueSolventsForPreBubblers, uniquePreBubblerResources, uniqueSolventToUniquePrebubblerAssociation, uniquePreBubblerSolventLoadingVolumesField, uniqueSolventsForPreBubblerVolumes, pretreatmentSpargingPreBubblersField, spargingPreBubblersField,

		solventReferences, solventReferenceSplitsForUninstall, uninstallPreBubblersField, helperList, helperSubList, uninstallSplits, splitLengths, pretreatmentPreBubblersSplits, spargingPreBubblersSplits, installPretreatmentSpargingPreBubblersField, installSparingPreBubblersField,

		(* Tubings *)
		preBubblerOutletTubingModel,
		reactionVesselInletTubingModel, preBubblerInletTubingModel, requireReactionVesselInletTubingChecks, requirePreBubblerTubingChecks, requireReactionVesselInletTubing, requirePreBubblerTubing, reactionVesselInletTubingResource, preBubblerInletTubingResource, preBubblerOutletTubingResource,

		(* Solvents *)
		loadingSampleSolventVolumes, pairedLoadingSampleSolventsAndVolumes, solventVolumeRules, solventResourceReplaceRules, solventResources, solventsField,
		uniquePreBubblerSolventsField, pretreatmentSpargingPreBubblerSolventsField, spargingPreBubblerSolventsField,

		(* cyclic voltammetry measurements *)
		safePrimaryCyclicVoltammetryPotentials, safeSecondaryCyclicVoltammetryPotentials, safeTertiaryCyclicVoltammetryPotentials, safeQuaternaryCyclicVoltammetryPotentials,

		(* time estimates *)
		samplePrepTime, gatherResourcesTime, experimentPreparationTime, experimentTime,

		samplesWithoutLinks,numberOfReplicates,samplesWithReplicates,optionsWithReplicates,
		protocolPacket,allResourceBlobs,fulfillable,frqTests,resultRule,testsRule
	},

	(* ----------------------------- *)
	(* -- SETUP OPTIONS AND CACHE -- *)
	(* ----------------------------- *)


	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentCyclicVoltammetry, {mySamples}, myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentCyclicVoltammetry,
		RemoveHiddenOptions[ExperimentCyclicVoltammetry,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Fetch our cache and simulation from the parent function. *)
	cache=Lookup[ToList[myOptions],Cache, {}];
	simulation=Lookup[ToList[myOptions],Simulation, Null];

	(* Get rid of the links in mySamples. *)
	samplesWithoutLinks=mySamples/.x:ObjectP[]:>Download[x, Object];

	(* Get our simulated samples (we have to figure out sample groupings here). *)
	{simulatedSamples,updatedSimulation}=simulateSamplesResourcePacketsNew[ExperimentCyclicVoltammetry,samplesWithoutLinks,myResolvedOptions,Cache->cache,Simulation->simulation];

	(* Get our number of replicates. *)
	numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates]/.{Null->1};

	(*Get our instrument*)
	instrument=Lookup[myResolvedOptions,Instrument];

	(* Expand our samples and options according to NumberOfReplicates. *)
	{samplesWithReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentCyclicVoltammetry,samplesWithoutLinks,expandedResolvedOptions];

	(* get the number of samples, with replicates counted as individual samples *)
	numberOfSamples = Length[samplesWithReplicates];

	(* ------------------- *)
	(* -- OPTION LOOKUP -- *)
	(* ------------------- *)

	(* split the lookup by category for readability *)

	(* general options *)
	{
		workingElectrode,
		counterElectrode,
		electrodeCap
	} = Lookup[optionsWithReplicates,
		{
			WorkingElectrode,
			CounterElectrode,
			ElectrodeCap
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* working electrode polishing options *)
	{
		polishWorkingElectrodes,
		polishingPads,
		polishingSolutions,
		numberOfPolishingDroplets,
		numberOfPolishings
	} = Lookup[optionsWithReplicates,
		{
			PolishWorkingElectrode,
			PolishingPads,
			PolishingSolutions,
			NumberOfPolishingSolutionDroplets,
			NumberOfPolishings
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* working electrode sonication options *)
	{
		workingElectrodeSonications,
		workingElectrodeSonicationTimes,
		workingElectrodeSonicationTemperatures
	} = Lookup[optionsWithReplicates,
		{
			WorkingElectrodeSonication,
			WorkingElectrodeSonicationTime,
			WorkingElectrodeSonicationTemperature
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* electrode washing options *)
	{
		workingElectrodeWashings,
		workingElectrodeWashingCycles,
		counterElectrodeWashings
	} = Lookup[optionsWithReplicates,
		{
			WorkingElectrodeWashing,
			WorkingElectrodeWashingCycles,
			CounterElectrodeWashing
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* loading sample options *)
	{
		preparedSamples,
		reactionVessels,
		loadingSampleVolumes,
		solventVolumes,
		analytes,
		sampleAmounts,
		targetConcentrations
	} = Lookup[optionsWithReplicates,
		{
			PreparedSample,
			ReactionVessel,
			LoadingSampleVolume,
			SolventVolume,
			Analyte,
			SampleAmount,
			LoadingSampleTargetConcentration
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* electrolyte solution options *)
	{
		solvents,
		electrolytes,
		pretreatElectrodes,
		electrolyteSolutions,
		electrolyteSolutionLoadingVolumes,
		loadingSampleElectrolyteAmounts,
		electrolyteTargetConcentrations
	} = Lookup[optionsWithReplicates,
		{
			Solvent,
			Electrolyte,
			PretreatElectrodes,
			ElectrolyteSolution,
			ElectrolyteSolutionLoadingVolume,
			LoadingSampleElectrolyteAmount,
			ElectrolyteTargetConcentration
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* reference solution options *)
	{
		referenceElectrodes,
		refreshReferenceElectrodes,
		referenceElectrodeSoakTimes
	} = Lookup[optionsWithReplicates,
		{
			ReferenceElectrode,
			RefreshReferenceElectrode,
			ReferenceElectrodeSoakTime
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* Internal Standard options *)
	{
		internalStandards,
		internalStandardAdditionOrders,
		internalStandardAmounts,
		internalStandardTargetConcentrations
	} = Lookup[optionsWithReplicates,
		{
			InternalStandard,
			InternalStandardAdditionOrder,
			InternalStandardAmount,
			InternalStandardTargetConcentration
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* Pretreat electrodes options *)
	{
		pretreatmentSpargings,
		pretreatmentSpargingPreBubblers,
		pretreatmentInitialPotentials,
		pretreatmentFirstPotentials,
		pretreatmentSecondPotentials,
		pretreatmentFinalPotentials,
		pretreatmentPotentialSweepRates,
		pretreatmentNumberOfCycles
	} = Lookup[optionsWithReplicates,
		{
			PretreatmentSparging,
			PretreatmentSpargingPreBubbler,
			PretreatmentInitialPotential,
			PretreatmentFirstPotential,
			PretreatmentSecondPotential,
			PretreatmentFinalPotential,
			PretreatmentPotentialSweepRate,
			PretreatmentNumberOfCycles
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* Loading sample mix options *)
	{
		loadingSampleMixes,
		loadingSampleMixTypes,
		loadingSampleMixTemperatures,
		loadingSampleMixTimes,
		loadingSampleNumberOfMixes,
		loadingSampleMixVolumes,
		loadingSampleMixUntilDissolveds,
		loadingSampleMaxNumberOfMixes,
		loadingSampleMaxMixTimes
	} = Lookup[optionsWithReplicates,
		{
			LoadingSampleMix,
			LoadingSampleMixType,
			LoadingSampleMixTemperature,
			LoadingSampleMixTime,
			LoadingSampleNumberOfMixes,
			LoadingSampleMixVolume,
			LoadingSampleMixUntilDissolved,
			LoadingSampleMaxNumberOfMixes,
			LoadingSampleMaxMixTime
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* sparing options *)
	{
		spargings,
		spargingGases,
		spargingTimes,
		spargingPreBubblers
	} = Lookup[optionsWithReplicates,
		{
			Sparging,
			SpargingGas,
			SpargingTime,
			SpargingPreBubbler
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* cyclic voltammetry measurement options *)
	{
		initialPotentials,
		firstPotentials,
		secondPotentials,
		finalPotentials,
		potentialSweepRates,
		numberOfCycles
	} = Lookup[optionsWithReplicates,
		{
			InitialPotentials,
			FirstPotentials,
			SecondPotentials,
			FinalPotentials,
			PotentialSweepRates,
			NumberOfCycles
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* storage conditions *)
	{
		samplesInStorageConditions,
		samplesOutStorageConditions
	} = Lookup[optionsWithReplicates,
		{
			SamplesInStorageCondition,
			SamplesOutStorageCondition
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* -------------- *)
	(* -- DOWNLOAD -- *)
	(* -------------- *)

	(* Get all containers which can fit on the liquid handler - many of our resources are in one of these containers *)
	(* In case we need to prepare the resource add 0.5mL tube in 2 mL skirt to the beginning of the list (Engine uses the first requested container if it has to transfer or make a stock solution) *)

	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* download sample prep fields from for samples *)
	objectSamplePacketFields=Packet@@Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}];

	(* Download sample and liquid handler compatible container information *)
	{listedSamplePackets,liquidHandlerContainerDownload}=Quiet[
		Download[
			{
				mySamples,
				liquidHandlerContainers
			},
			{
				{
					objectSamplePacketFields
				},
				{MaxVolume}
			},
			Cache->cache,
			Simulation -> simulation,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* Make a list of all the maximum volumes *)
	liquidHandlerContainerMaxVolumes=Flatten[liquidHandlerContainerDownload,1];

	(* ------------------------------- *)
	(* -- GENERAL DEFAULT VARIABLES -- *)
	(* ------------------------------- *)

	(* set up the default sparging pressure *)
	defaultSpargingPressure = 1.0 PSI;

	(* set up potential water squirt bottles *)
	defaultWaterSquirtBottles = {
		Model[Container, Vessel, "500 mL Squirt Bottle, MilliQ Water"],
		Model[Container, Vessel, "500 mL Squirt Bottle, Unlabeled"]
	};
	defaultWaterSquirtBottleMaxVolumes = Lookup[fetchPacketFromCache[Download[#, Object], cache], MaxVolume]&/@ defaultWaterSquirtBottles;

	(* set up potential methanol squirt bottles *)
	defaultMethanolSquirtBottles = {
		Model[Container, Vessel, "500 mL Squirt Bottle, Methanol"],
		Model[Container, Vessel, "500 mL Squirt Bottle, Unlabeled"]
	};
	defaultMethanolSquirtBottleMaxVolumes = Lookup[fetchPacketFromCache[Download[#, Object], cache], MaxVolume]&/@ defaultMethanolSquirtBottles;

	(* set up potential gas washing bottles *)
	defaultSpargingPreBubblers = {
		Model[Container, Vessel, GasWashingBottle, "SYNTHWARE Gas Washing Bottle, 125 mL"]
	};
	defaultSpargingPreBubblerMaxVolumes = Lookup[fetchPacketFromCache[Download[#, Object], cache], MaxVolume]&/@ defaultSpargingPreBubblers;

	(* set up preferred containers *)
	preferredContainers = PreferredContainer[All];
	preferredContainerMaxVolumes = Lookup[fetchPacketFromCache[Download[#, Object], cache], MaxVolume]&/@ preferredContainers;
	preferredContainerHeights = (Lookup[fetchPacketFromCache[Download[#, Object], cache], Dimensions][[3]])&/@ preferredContainers;

	(* set up an estimation of a single polishing solution droplet volume *)
	singlePolishingSolutionDropletVolume = 10 Microliter;

	(* set up a expansion factor for the resource picking *)
	resourceExpansionFactor = 1;

	(* -------------------------- *)
	(* -- SAMPLES IN RESOURCES -- *)
	(* -------------------------- *)

	(* -- Generate resources for the SamplesIn -- *)
	(* pull out the AliquotAmount option *)
	expandedAliquotAmount = Lookup[optionsWithReplicates, AliquotAmount];

	(* Get the sample amount; if we're aliquoting, use that expandedAliquotAmount; otherwise use the sampleAmounts and loadingSampleVolumes *)

	(* check what type of sample we are dealing with in order to grab the correct resource *)
	safeSampleAmounts = MapThread[Function[{aliquotAmount, solidMass, liquidVolume, prepared},
		Which[
			MatchQ[prepared, True],
			If[VolumeQ[aliquotAmount],
				aliquotAmount,
				SafeRound[liquidVolume * resourceExpansionFactor, 10^0 Milliliter, RoundAmbiguous -> Up]
			],

			MatchQ[prepared, False],
			If[MassQ[aliquotAmount],
				aliquotAmount,
				SafeRound[solidMass * resourceExpansionFactor, 10^-1 Milligram, RoundAmbiguous -> Up]
			]
		]],
		{expandedAliquotAmount, sampleAmounts, loadingSampleVolumes, preparedSamples}
	];

	(* Pair the SamplesIn and their Amounts *)
	pairedSamplesInAndAmounts = MapThread[
		(#1 -> #2)&,
		{samplesWithReplicates, safeSampleAmounts}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleAmountRules = Merge[pairedSamplesInAndAmounts, Total];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, amount},
			If[VolumeQ[amount],
				(sample -> Resource[Sample -> Download[sample, Object], Name -> CreateUUID[], Amount -> amount]),
				(sample -> Resource[Sample -> Download[sample, Object], Name -> CreateUUID[], Amount -> amount])
			]
		],
		sampleAmountRules
	];

	(* Use the replace rules to get the sample resources *)
	samplesInResources = Replace[samplesWithReplicates, sampleResourceReplaceRules, {1}];

	(* ------------------------------- *)
	(* -- WorkingElectrode RESOURCE -- *)
	(* ------------------------------- *)
	workingElectrodeResource = Resource[Sample -> workingElectrode];

	(* ------------------------------- *)
	(* -- CounterElectrode RESOURCE -- *)
	(* ------------------------------- *)
	counterElectrodeResource = Resource[Sample -> counterElectrode];

	(* ------------------------------------------- *)
	(* -- ReferenceElectrode RESOURCES & Fields -- *)
	(* ------------------------------------------- *)
	(* -- Get unique reference Electrodes -- *)
	uniqueReferenceElectrodes = DeleteDuplicates[referenceElectrodes];

	(* -- We need to find out the container models to store the reference electrode, this must be the same logic with the one in ExperimentPrepareReferenceElectrode, otherwise when we prepare the reference electrode as a resource, it will bug out!!! -- *)
	(* Find out the length of the reference electrodes *)
	referenceElectrodeLengths = Map[
		Function[{referenceElectrode},
			If[MatchQ[referenceElectrode, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
				(* If the current reference electrode is a Model, take the Dimensions directly *)
				Lookup[fetchPacketFromCache[referenceElectrode, cache], Dimensions][[3]],

				(* If the current reference electrode is an Object, take the Dimensions from its Model *)
				Lookup[fetchPacketFromCache[
					Download[Lookup[fetchPacketFromCache[referenceElectrode, cache], Model], Object],
					cache], Dimensions][[3]]
			]
		],
		uniqueReferenceElectrodes
	];

	(* Sort the preferred Containers by their heights *)
	{sortedPreferredContainersByHeight, sortedPreferredContainerHeights} = Transpose[Sort[Transpose[{preferredContainers, preferredContainerHeights}], Last[#1] < Last[#2]&]];

	(* Select the right storage container model *)
	selectedReferenceElectrodeContainerModels = MapThread[
		Function[{referenceElectrode, electrodeHeight},
			referenceElectrode -> First[
				PickList[
					sortedPreferredContainersByHeight,
					sortedPreferredContainerHeights,
					RangeP[electrodeHeight * 1.3, electrodeHeight * 2]
				]
			]
		],
		{uniqueReferenceElectrodes, referenceElectrodeLengths}
	];

	(* Create the reference electrode replace rules *)
	referenceElectrodeReplaceRules = Map[
		# -> Link[Resource[
			Sample -> #,
			Name -> CreateUUID[]
		]]&,
		uniqueReferenceElectrodes
	];

	(* Create the field to populate ReferenceElectrodes field *)
	referenceElectrodesField = Replace[referenceElectrodes, referenceElectrodeReplaceRules, {1}];

	(* -- Directly populate RefreshReferenceElectrodes and ReferenceElectrodeSoakTimes from the optionsWithReplicates, so we do not have to do anything here -- *)

	(* ------------------------------------------- *)
	(* -- ReactionVessel/ElectrodeCap RESOURCES -- *)
	(* ------------------------------------------- *)
	(* Get the reaction vessel models *)
	reactionVesselModels = Map[
		If[MatchQ[#, ObjectP[Object[Container, ReactionVessel, ElectrochemicalSynthesis]]],

			(* If the current reaction vessel is an Object, get its Model *)
			Download[Lookup[fetchPacketFromCache[#, cache], Model], Object],

			(* If the current reaction vessel is a Model, return itself *)
			#
		]&,
		reactionVessels
	];

	(* -- ReactionVessels -- *)
	reactionVesselResources = Map[
		Link[Resource[
			Sample -> #,
			Name -> CreateUUID[]
		]]&,
		reactionVessels
	];

	(* -- ElectrodeCap -- *)
	electrodeCapResource = Resource[Sample -> electrodeCap, Name -> CreateUUID[]];

	(* -- Tweezers -- *)
	(* Resource pick the tweezers *)
	tweezerResource = Resource[Sample -> Model[Item, Tweezer, "Straight flat tip tweezer"], Name -> CreateUUID[], Rent -> True];

	(* ----------------------------------------------------- *)
	(* -- WorkingElectrode Polishing FIELDS AND RESOURCES -- *)
	(* ----------------------------------------------------- *)

	(* -- Gather water and methanol to use in between polishings -- *)
	numberOfElectrodePolishings = Total[Flatten[numberOfPolishings]/.{Null -> Nothing}];

	polishingWaterVolume = numberOfElectrodePolishings * 4 * Milliliter;

	(* -- Gather methanol -- *)
	polishingMethanolVolume = numberOfElectrodePolishings * 2 * Milliliter;

	(* -- PolishingPads resources -- *)
	(* Get unique polishing pad models and objects *)
	uniquePolishingPads = DeleteDuplicates[Flatten[polishingPads /. {Null -> Nothing}]];

	(* Set up the replacing rules *)
	polishingPadsReplaceRules = Map[
		# -> If[MatchQ[#, ObjectP[{Model[Item, ElectrodePolishingPad], Object[Item, ElectrodePolishingPad]}]],
			Link[Resource[
				Sample -> #,
				Name -> CreateUUID[]
			]],
			Null
		]&,
		uniquePolishingPads
	];

	(* Create the value for the UniquePolishingPads field *)
	uniquePolishingPadsField = uniquePolishingPads /. polishingPadsReplaceRules;

	(* -- PolishingPlates resources -- *)
	defaultPolishingPlates = Map[
		If[MatchQ[#, ObjectP[{Model[Item, ElectrodePolishingPad], Object[Item, ElectrodePolishingPad]}]],
			Lookup[fetchPacketFromCache[#, cache], DefaultPolishingPlate],
			Null
		]&,
		uniquePolishingPads
	] /. x:ObjectP[]:> Download[x, Object];

	(* get the polishing plate resources *)
	polishingPadToPlateResourceReplaceRules = MapThread[
		#1 -> If[
			MatchQ[#1, ObjectP[{Model[Item, ElectrodePolishingPad], Object[Item, ElectrodePolishingPad]}]] && MatchQ[#2, ObjectP[{Model[Item, ElectrodePolishingPlate]}]],
			Link[Resource[
				Sample -> #2,
				Name -> CreateUUID[]
			]],
			Null
		]&,
		{uniquePolishingPads, defaultPolishingPlates}
	];

	(* We can use polishingPadToPlateMap to generate the polishingPlates *)
	polishingPlates = polishingPads /. polishingPadToPlateResourceReplaceRules;

	(* Create the value for the UniquePolishingPlates field *)
	uniquePolishingPlatesField = uniquePolishingPads /. polishingPadToPlateResourceReplaceRules;

	(* -- PolishingSolutions resources -- *)
	(* Get unique polishing solution models and objects *)
	uniquePolishingSolutions = DeleteDuplicates[Flatten[polishingSolutions]]/.{Null -> Nothing};

	(* get the count of every polishing solution *)
	polishingSolutionTotalDropletsCounts = MapThread[
		Function[{droplets, number},
			If[MatchQ[droplets,_Integer] && MatchQ[number,_Integer],
				droplets * number,
				Null
			]
		],
		{Flatten[numberOfPolishingDroplets], Flatten[numberOfPolishings]}
	];

	(* make a matrix with polishing solution and its corresponding total droplet count *)
	polishingSolutionWithDroplets = Replace[Transpose[{Flatten[polishingSolutions], polishingSolutionTotalDropletsCounts}], {{x_, y_} -> (x -> y)}, {1}];

	(* sum the number of droplets for each unique polishing solution *)
	uniquePolishingSolutionsWithDropletCounts = KeyDrop[Merge[polishingSolutionWithDroplets, Total], {Null}];

	(* Get the required volume for each unique polishing solution *)
	uniquePolishingSolutionVolumes = Map[
		(Lookup[uniquePolishingSolutionsWithDropletCounts, #] * singlePolishingSolutionDropletVolume)&,
		uniquePolishingSolutions
	];

	(* Set up the replacing rules *)
	polishingSolutionsReplaceRules = MapThread[
		#1 -> Link[Resource[
			Sample -> #1,
			Amount -> #2,
			Name -> CreateUUID[]
		]]&,
		{uniquePolishingSolutions, uniquePolishingSolutionVolumes}
	];

	(* Create the value for the UniquePolishingSolutions field *)
	uniquePolishingSolutionsField = uniquePolishingSolutions /. polishingSolutionsReplaceRules;

	(* -- PrimaryPolishings, SecondaryPolishings, TertiaryPolishings fields -- *)
	{safePrimaryPolishings, safeSecondaryPolishings, safeTertiaryPolishings} = Transpose[MapThread[
		Function[{polish, padSeries, solutionSeries, plateSeries, dropletSeries, numberOfPolishingsSeries},
			Module[
				{seriesLength, primaryPolish, secondaryPolish, tertiaryPolish, nullEntry},

				(* Set up the nullEntry *)
				nullEntry = Association[
					PolishingPad -> Null,
					PolishingSolution -> Null,
					PolishingPlate -> Null,
					NumberOfDroplets -> Null,
					NumberOfPolishings -> Null
				];

				If[MatchQ[polish, False],

					(* If we are not polishing, return {nullEntry, nullEntry, nullEntry} *)
					{nullEntry, nullEntry, nullEntry},

					(* Otherwise, continue *)
					seriesLength = Length[padSeries];

					(* we always have the primaryPolish if PolishWorkingElectrode is True *)
					primaryPolish = Association[
						PolishingPad -> Link[padSeries[[1]]],
						PolishingSolution -> Link[solutionSeries[[1]]],
						PolishingPlate -> Link[plateSeries[[1]]],
						NumberOfDroplets -> dropletSeries[[1]],
						NumberOfPolishings -> numberOfPolishingsSeries[[1]]
					];

					(* If there are at least 2 polishing pads, we can set up the secondaryPolish *)
					secondaryPolish = If[GreaterEqualQ[seriesLength, 2],
						Association[
							PolishingPad -> Link[padSeries[[2]]],
							PolishingSolution -> Link[solutionSeries[[2]]],
							PolishingPlate -> Link[plateSeries[[2]]],
							NumberOfDroplets -> dropletSeries[[2]],
							NumberOfPolishings -> numberOfPolishingsSeries[[2]]
						],
						nullEntry
					];

					(* If there are at least 3 polishing pads, we can set up the tertiaryPolish *)
					tertiaryPolish = If[GreaterEqualQ[seriesLength, 3],
						Association[
							PolishingPad -> Link[padSeries[[3]]],
							PolishingSolution -> Link[solutionSeries[[3]]],
							PolishingPlate -> Link[plateSeries[[3]]],
							NumberOfDroplets -> dropletSeries[[3]],
							NumberOfPolishings -> numberOfPolishingsSeries[[3]]
						],
						nullEntry
					];

					{primaryPolish, secondaryPolish, tertiaryPolish}
				]
			]
		],
		{
			polishWorkingElectrodes,
			polishingPads /. polishingPadsReplaceRules,
			polishingSolutions /. polishingSolutionsReplaceRules,
			polishingPlates,
			numberOfPolishingDroplets,
			numberOfPolishings
		}]
	];

	(* ------------------------------------------------------ *)
	(* -- WorkingElectrode Sonication FIELDS AND RESOURCES -- *)
	(* ------------------------------------------------------ *)
	safeWorkingElectrodeSonicationTimes = workingElectrodeSonicationTimes;
	safeWorkingElectrodeSonicationTemperatures = workingElectrodeSonicationTemperatures;

	(* gather a container to hold the workingElectrode for sonication, we assume a 30 Milliliter container is large enough to hold the working electrode *)
	workingElectrodeSonicationContainerModel = First[PickList[preferredContainers, preferredContainerMaxVolumes, GreaterP[30 Milliliter]]];
	workingElectrodeSonicationContainerModelMaxVolume = Lookup[fetchPacketFromCache[workingElectrodeSonicationContainerModel, cache], MaxVolume];

	(* If the working electrode needs to be sonicated for any sample, we pick the workingElectrodeSonicationContainerResource *)
	workingElectrodeSonicationContainerResource = If[MemberQ[workingElectrodeSonications, True],
		Link[Resource[Sample -> workingElectrodeSonicationContainerModel]],
		Null
	];

	(* gather the water to be put into the working electrode sonication container *)
	(* Find the water volume *)
	safeWorkingElectrodeSonicationSolventVolume = If[MemberQ[workingElectrodeSonications, True],
		SafeRound[0.7 * workingElectrodeSonicationContainerModelMaxVolume, 1 Milliliter, Round -> Up],
		Null
	];

	(* gather the resource *)
	workingElectrodeSonicationSolventResource = If[MemberQ[workingElectrodeSonications, True],
		Link[
			Resource[
				Sample -> Model[Sample, "Milli-Q water"],
				Amount -> safeWorkingElectrodeSonicationSolventVolume,
				Container -> First[PickList[liquidHandlerContainers, liquidHandlerContainerMaxVolumes, GreaterP[safeWorkingElectrodeSonicationSolventVolume]]]
			]
		],
		Null
	];

	(* -------------------------------------------- *)
	(* -- Electrode Washing FIELDS AND RESOURCES -- *)
	(* -------------------------------------------- *)

	(* Gather water and methanol to use in between polishings *)
	numberOfWorkingElectrodeWashings = Total[workingElectrodeWashingCycles /. {Null -> Nothing}];
	numberOfCounterElectrodeWashings = Length[counterElectrodeWashings /. {False -> Nothing}];
	numberOfElectrodeWashings = numberOfWorkingElectrodeWashings + numberOfCounterElectrodeWashings;

	(* We add 1 for the last working electrode washing, 1 for last counter electrode washing, 1 for each reference electrode washing *)
	washingWaterVolume = (numberOfElectrodeWashings + 2 + Length[referenceElectrodes]) * 5 * Milliliter;

	(* Gather methanol, add 1 for the last working electrode washing, 1 for last counter electrode washing *)
	washingMethanolVolume = (numberOfElectrodeWashings + 2) * 5 * Milliliter;

	(* Total Water volume and Methanol volume *)
	totalSquirtWaterVolume = If[MatchQ[polishingWaterVolume + washingWaterVolume, GreaterP[0 Milliliter]],
		polishingWaterVolume + washingWaterVolume + 20 Milliliter,
		0 Milliliter
	];
	totalSquirtMethanolVolume = If[MatchQ[polishingMethanolVolume + washingMethanolVolume, GreaterP[0 Milliliter]],
		polishingMethanolVolume + washingMethanolVolume + 20 Milliliter,
		0 Milliliter
	];

	(* get the water and methanol Models *)
	washingWaterModel = If[MatchQ[totalSquirtWaterVolume, GreaterP[0 Milliliter]],
		Link[Model[Sample, "Milli-Q water"]],
		Null
	];

	washingMethanolModel = If[MatchQ[totalSquirtMethanolVolume, GreaterP[0 Milliliter]],
		Link[Model[Sample, "Methanol"]],
		Null
	];

	(* Prepare the UniqueElectrodeWashingSolutions field *)
	uniqueElectrodeWashingSolutionField = {washingWaterModel, washingMethanolModel} /. {Null -> Nothing};

	(* Prepare the UniqueElectrodeWashingSolutionVolumes field *)
	uniqueElectrodeWashingSolutionVolumes = {
		(* Water volume *)
		If[!MatchQ[washingWaterModel, Null],
			polishingWaterVolume + washingWaterVolume,
			Null
		],

		(* Methanol volume *)
		If[!MatchQ[washingMethanolModel, Null],
			polishingMethanolVolume + washingMethanolVolume,
			Null
		]
	} /. {Null -> Nothing};

	(* Prepare the WorkingElectrodePolishWashingSolutions, WorkingElectrodeWashingSolutions and CounterElectrodeWashingSolutions fields *)
	safeWorkingElectrodePolishWashingSolutions = (polishWorkingElectrodes /. {True -> <|Primary -> washingWaterModel, Secondary -> washingMethanolModel|>, False -> <|Primary -> Null, Secondary -> Null|>});

	safeWorkingElectrodeWashingSolutions = (workingElectrodeWashings /. {True -> <|Primary -> washingWaterModel, Secondary -> washingMethanolModel|>, False -> <|Primary -> Null, Secondary -> Null|>});

	safeCounterElectrodeWashingSolutions = (counterElectrodeWashings /. {True -> <|Primary -> washingWaterModel, Secondary -> washingMethanolModel|>, False -> <|Primary -> Null, Secondary -> Null|>});

	(* safeWorkingElectrodeWashingCycles *)
	safeWorkingElectrodeWashingCycles = workingElectrodeWashingCycles /. {Null -> 0};

	(* -- Prepare the values for DryWorkingElectrode and DryCounterElectrode fields -- *)
	(* Working electrode *)
	dryWorkingElectrodeField = MapThread[
		If[MemberQ[Join[#1, #2], True],
			True,
			False
		]&,
		{polishWorkingElectrodes, workingElectrodeWashings}
	];

	(* Counter electrode *)
	dryCounterElectrodeField = counterElectrodeWashings /. {Null -> False};

	(* -- Water and Methanol collection containers -- *)
	(* get the container model for water collection *)
	waterCollectionContainerModel = First[
		PickList[
			preferredContainers,
			preferredContainerMaxVolumes,
			GreaterP[totalSquirtWaterVolume]
		]
	];

	(* get the container model for methanol collection *)
	methanolCollectionContainerModel = First[
		PickList[
			preferredContainers,
			preferredContainerMaxVolumes,
			GreaterP[totalSquirtMethanolVolume]
		]
	];

	(* get the collection container resources *)
	washingSolutionCollectionContainerResources = {
		If[MatchQ[totalSquirtWaterVolume, GreaterP[0 Milliliter]],
			Link[Resource[Sample -> waterCollectionContainerModel, Name -> CreateUUID[], Rent -> True]],
			Null
		],
		If[MatchQ[totalSquirtMethanolVolume, GreaterP[0 Milliliter]],
			Link[Resource[Sample -> methanolCollectionContainerModel, Name -> CreateUUID[], Rent -> True]],
			Null
		]
	};

	(* set the WashingWaterCollectionContainer and WashingMethanolCollectionContainer fields *)
	washingWaterCollectionContainerField = First[washingSolutionCollectionContainerResources];
	washingMethanolCollectionContainerField = Last[washingSolutionCollectionContainerResources];

	(* ----------------------------------- *)
	(* -- ElectrolyteSolution RESOURCES -- *)
	(* ----------------------------------- *)

	(* check the electrolyteSolutionLoadingVolumes *)
	requiredElectrolyteSolutionVolumes = MapThread[Function[{solutionVolume, pretreat},
		Which[
			MatchQ[pretreat, True],
			solutionVolume * resourceExpansionFactor,

			MatchQ[pretreat, False],
			Null
		]],
		{electrolyteSolutionLoadingVolumes, pretreatElectrodes}
	];

	(* Create a safeElectrodeSolutionLoadingVolumes *)
	safeElectrodeSolutionLoadingVolumes = electrolyteSolutionLoadingVolumes;

	(* Pair the ElectrolyteSolutions and their Volumes *)
	pairedElectrolyteSolutionAndLoadingVolumes = MapThread[
		(#1 -> #2)&,
		{electrolyteSolutions, requiredElectrolyteSolutionVolumes}
	];

	(* Merge the ElectrolyteSolution volumes together to get the total volume of each ElectrolyteSolution *)
	electrolyteSolutionLoadingVolumesRules = KeyDrop[Merge[pairedElectrolyteSolutionAndLoadingVolumes, Total], Null];

	(* Make replace rules for the ElectrolyteSolution and its resources; doing it this way because we only want to make one resource per ElectrolyteSolution including in replicates *)
	electrolyteSolutionResourceReplaceRules = KeyValueMap[
		Function[{electrolyteSolution, volume},
			If[VolumeQ[volume],
				(electrolyteSolution -> Link[Resource[
					Sample -> Download[electrolyteSolution, Object],
					Amount -> volume,
					Name -> CreateUUID[]
				]])
			]
		],
		electrolyteSolutionLoadingVolumesRules
	];

	(* Use the replace rules to get the electrolyte solution resources *)
	electrolyteSolutionResources = Replace[electrolyteSolutions, electrolyteSolutionResourceReplaceRules, {1}];

	(* --------------------------------------------- *)
	(* -- PretreatElectrodes FIELDS AND RESOURCES -- *)
	(* --------------------------------------------- *)

	(* -- Resource pick the reaction vessels for pretreatment -- *)
	pretreatmentReactionVesselResources = If[MemberQ[pretreatElectrodes, True],
		MapThread[
			If[MatchQ[#1, True],

				(* If we are pre-treating the current electrodes, pick the resource *)
				Link[Resource[
					Sample -> #2,
					Name -> CreateUUID[]
				]],

				(* If we are not pre-treating the current electrodes, return Null *)
				Null
			]&,
			{pretreatElectrodes, reactionVesselModels}
		],
		(* If we are not pretreat the electrodes, do not bother to collect the pretreatmentReactionVesselResources *)
		ConstantArray[Null, Length[samplesWithReplicates]]
	];

	(* PretreatmentSpargingGases: If the corresponding SpargingGas is specified, set PretreatmentSpargingGas to SpargingGas. If the corresponding SpargingGas is Null, set PretreatmentSpargingGas to Nitrogen. *)

	safePretreatmentSpargingGases = MapThread[
		Function[{pretreatmentSparging, spargingGas},
			If[MatchQ[pretreatmentSparging, Alternatives[False, Null]],
				(* If we are not pretreatment sparging *)
				Null,

				(* If we are pretreatment sparging *)
				If[MatchQ[spargingGas, Alternatives[Nitrogen, Argon, Helium]],
					spargingGas,
					Nitrogen
				]
			]
		],
		{pretreatmentSpargings, spargingGases}
	];

	(* PretreatmentSpargingTimes: If the corresponding SpargingTime is specified, set PretreatmentSpargingTime to SpargingTime. If the corresponding SpargingTime is Null, set PretreatmentSpargingTime to 3 Minute. *)

	safePretreatmentSpargingTimes = MapThread[
		Function[{pretreatmentSparging, spargingTime},
			If[MatchQ[pretreatmentSparging, Alternatives[False, Null]],
				(* If we are not pretreatment sparging *)
				Null,

				(* If we are pretreatment sparging *)
				If[MatchQ[spargingTime, TimeP],
					spargingTime,
					3 Minute
				]
			]
		],
		{pretreatmentSpargings, spargingTimes}
	];

	safePretreatmentSpargingPressures = (pretreatmentSpargings /. {True -> defaultSpargingPressure, False -> Null});

	(* PretreatmentPotentials *)
	safePretreatmentPotentials = MapThread[Function[{initial, first, second, final, sweepRate},
		Association[
			InitialPotential -> initial,
			FirstPotential -> first,
			SecondPotential -> second,
			FinalPotential -> final,
			SweepRate -> sweepRate
		]
	],
		{
			pretreatmentInitialPotentials,
			pretreatmentFirstPotentials,
			pretreatmentSecondPotentials,
			pretreatmentFinalPotentials,
			pretreatmentPotentialSweepRates
		}
	];

	(* Depending on the pretreatmentNumberOfCycles, we prepare the PretreatmentPrimaryPotentials, PretreatmentSecondaryPotentials, PretreatmentTertiaryPotentials, PretreatmentQuaternaryPotentials values *)
	{
		safePretreatmentPrimaryPotentials,
		safePretreatmentSecondaryPotentials,
		safePretreatmentTertiaryPotentials,
		safePretreatmentQuaternaryPotentials
	} = Transpose[MapThread[
		Function[{potentials, currentPretreatmentNOC},
			Module[{result, nullValue},
				nullValue = <|
					InitialPotential -> Null,
					FirstPotential -> Null,
					SecondPotential -> Null,
					FinalPotential -> Null,
					SweepRate -> Null
				|>;
				Which[

					(* If current pretreatment number of cycles is Null, return {nullValue, nullValue, nullValue, nullValue} *)
					MatchQ[currentPretreatmentNOC, Null],
					{nullValue, nullValue, nullValue, nullValue},

					(* If current pretreatment number of cycles is an integer, return number of cycles of potentials with nullValue on the right *)
					IntegerQ[currentPretreatmentNOC],
					PadRight[ConstantArray[potentials, currentPretreatmentNOC], 4, nullValue]
				]
			]
		],
		{safePretreatmentPotentials, pretreatmentNumberOfCycles}
	]];

	(* ---------------------------------------- *)
	(* -- LoadingSample FIELDS AMD RESOURCES -- *)
	(* ---------------------------------------- *)
	(* -- SampleDilutions -- *)
	safeSampleDilutions = Not[#]&/@preparedSamples;

	(* -- SolidSampleAmounts -- *)
	safeSolidSampleAmounts = sampleAmounts /. {{Null..} -> {}};

	(* -- TargetConcentrations -- *)
	safeTargetConcentrations = targetConcentrations /. {{Null..} -> {}};

	(* -- SolventVolumes -- *)
	safeSolventVolumes = solventVolumes /. {{Null..} -> {}};

	(* -- Electrolytes & LoadingSampleElectrolyteAmounts -- *)
	(* NOTE: as long as loadingSampleElectrolyteAmount is not Null, we need to resource pick Electrolyte *)

	(* check the loadingSampleElectrolyteAmounts *)
	requiredLoadingSampleElectrolyteAmounts = If[
		MatchQ[#, MassP],
		SafeRound[resourceExpansionFactor * #, 10^-1 Milligram, RoundAmbiguous -> Up],
		Null
	]&/@ loadingSampleElectrolyteAmounts;

	(* Pair the electrolyte and their amounts *)
	pairedLoadingSampleElectrolyteAndAmounts = MapThread[
		(#1 -> #2)&,
		{electrolytes, requiredLoadingSampleElectrolyteAmounts}
	]/.{(_ -> Null) -> Nothing};

	(* Merge the electrolyte amounts together to get the total amount of each InternalStandard *)
	loadingSampleElectrolyteAmountRules = Merge[pairedLoadingSampleElectrolyteAndAmounts, Total];

	(* Make replace rules for the loadingSampleElectrolyte and its resources; doing it this way because we only want to make one resource per loadingSampleElectrolyte including in replicates *)
	loadingSampleElectrolyteResourceReplaceRules = KeyValueMap[
		Function[{electrolyte, amount},
			electrolyte -> Link[Resource[Sample -> Download[electrolyte, Object], Amount -> amount, Name -> CreateUUID[]]]
		],
		loadingSampleElectrolyteAmountRules
	];

	(* Get the electrolyteResources *)
	loadingSampleElectrolyteResources = Values[loadingSampleElectrolyteResourceReplaceRules];

	(* Use MapThread and the replace rules to get the loadingSampleElectrolyte resources *)
	electrolytesField = MapThread[
		Function[{electrolyte, amount},
			If[MassQ[amount],
				Replace[electrolyte, loadingSampleElectrolyteResourceReplaceRules],
				Link[electrolyte]
			]
		],
		{electrolytes, loadingSampleElectrolyteAmounts}
	];

	(* -- LoadingSampleElectrolyteAmounts & ElectrolyteTargetConcentrations Fields -- *)
	safeLoadingSampleElectrolyteAmounts = loadingSampleElectrolyteAmounts /. {{Null..} -> {}};
	safeElectrolyteTargetConcentrations = MapThread[
		If[MatchQ[#1, False],
			#2,
			Null
		]&,
		{preparedSamples, electrolyteTargetConcentrations}
	] /. {{Null..} -> {}};

	(* ----------------------------------------- *)
	(* -- InternalStandard FIELDS & RESOURCES -- *)
	(* ----------------------------------------- *)

	(* NOTE: as long as InternalStandardAmount is not Null, we need to resource pick InternalStandard *)
	(* This includes InternalStandardAdditionOrder to After and to Before when the input sample is not prepared *)

	(* check the internalStandardAmounts *)
	requiredInternalStandardAmounts = If[
		MatchQ[#, MassP],
		SafeRound[resourceExpansionFactor * #, 10^-1 Milligram, RoundAmbiguous -> Up],
		Null
	]&/@ internalStandardAmounts;

	(* Pair the internalStandard and their amounts *)
	pairedInternalStandardAndAmounts = MapThread[
		(#1 -> #2)&,
		{internalStandards, requiredInternalStandardAmounts}
	]/.{(_ -> Null) -> Nothing};

	(* Merge the InternalStandard amounts together to get the total amount of each InternalStandard *)
	internalStandardAmountRules = Merge[pairedInternalStandardAndAmounts, Total];

	(* Make replace rules for the InternalStandard and its resources; doing it this way because we only want to make one resource per InternalStandard including in replicates *)
	internalStandardResourceReplaceRules = KeyValueMap[
		Function[{internalStandard, amount},
			internalStandard -> Link[Resource[Sample -> Download[internalStandard, Object], Amount -> amount, Name -> CreateUUID[]]]
		],
		internalStandardAmountRules
	];

	(* Get the resources *)
	internalStandardResources = Values[internalStandardResourceReplaceRules];

	(* Use MapThread and the replace rules to get the internalStandard resources *)
	internalStandardsField = MapThread[
		Function[{internalStandard, amount},
			If[MassQ[amount],
				Replace[internalStandard, internalStandardResourceReplaceRules],
				Link[internalStandard] /. {None -> Null}
			]
		],
		{internalStandards, internalStandardAmounts}
	];

	(* get safe fields *)
	safeInternalStandardAmounts = internalStandardAmounts;
	safeInternalStandardTargetConcentrations = internalStandardTargetConcentrations;
	safeInternalStandardAdditionOrders = internalStandardAdditionOrders;

	(* Prepare the resource for the PostMeasurementStandardAdditionContainers *)
	postMeasurementStandardAdditionContainerResources = MapThread[
		If[MatchQ[#1, After],

			(* If we need to do the post measurement internal standard addition, we collect the resource *)
			Link[Resource[
				Sample -> First[PickList[preferredContainers, preferredContainerMaxVolumes, GreaterP[1.5 * #2]]],
				Name -> CreateUUID[]
			]],

			(* Otherwise, return Null *)
			Null
		]&,
		{safeInternalStandardAdditionOrders, loadingSampleVolumes}
	];

	(* ------------------------------ *)
	(* -- LoadingSample Mix Fields -- *)
	(* ------------------------------ *)
	(* Gather the containers from preferredContainers for the solid sample -> LoadingSample preparation *)

	loadingSamplePreparationContainerResources = If[!MatchQ[safeSolventVolumes, {}],

		(* If we have solvent volumes, which means we have solid samples to prepare *)
		Map[
			If[VolumeQ[#],
				(* If the current entry is a volume, gather the resource *)
				Link[Resource[
					Sample -> First[PickList[preferredContainers, preferredContainerMaxVolumes, GreaterP[1.5 * #]]],
					Name -> CreateUUID[]
				]],

				(* If the current entry is not a volume, return Null *)
				Null
			]&,
			safeSolventVolumes
		],

		(* If we do not have solvent volumes, return an empty list *)
		{}
	];

	(* Get safe fields for each LoadingSampleMix option *)
	{
		safeLoadingSampleMixes,
		safeLoadingSampleMixTypes,
		safeLoadingSampleMixTemperatures,
		safeLoadingSampleMixTimes,
		safeLoadingSampleNumberOfMixes,
		safeLoadingSampleMixVolumes,
		safeLoadingSampleMixUntilDissolveds,
		safeLoadingSampleMaxNumberOfMixes,
		safeLoadingSampleMaxMixTimes
	} = (# /. {{Null..} -> {}}) & /@{
		loadingSampleMixes,
		loadingSampleMixTypes,
		loadingSampleMixTemperatures,
		loadingSampleMixTimes,
		loadingSampleNumberOfMixes,
		loadingSampleMixVolumes,
		loadingSampleMixUntilDissolveds,
		loadingSampleMaxNumberOfMixes,
		loadingSampleMaxMixTimes
	};

	(* ----------------------------------- *)
	(* -- Sparging FIELDS AND RESOURCES -- *)
	(* ----------------------------------- *)
	safeSpargingPressures = spargings /. {True -> defaultSpargingPressure, False -> Null};

	(* Safe fields *)
	safeSpargingGases = spargingGases;
	safeSpargingTimes = spargingTimes;

	(* -------------------------------------------------------------- *)
	(* -- Helper Fields for Pretreatment Sparging and Main Sparing -- *)
	(* -------------------------------------------------------------- *)
	(* If we are doing any sparging in the pretreatment process or the main sparging process, the SchlenkLine is required *)
	requireSchlenkLinesField = MapThread[
		If[
			Or[MatchQ[#1, True], MatchQ[#2, True]],
			True,
			False
		]&,
		{pretreatmentSpargings, spargings}
	];

	(* -- In order to prepare the reaction vessel venting and inlet needles resource picking, we need to first find out the needle packets from cache -- *)
	potentialNeedleModelPackets = Cases[cache, PacketP[Model[Item, Needle]]];

	(* Sort the packets by the NeedleLength *)
	sortedNeedleModelPackets = SortBy[potentialNeedleModelPackets, Lookup[#, NeedleLength]&];

	(* Get the information out *)
	needleModels = Lookup[sortedNeedleModelPackets, Object];
	needleLengths = Lookup[sortedNeedleModelPackets, NeedleLength];

	(* -- Reaction vessel venting needle resource picking -- *)
	(* Find the right needle model: for the venting needle, we can just pick the shortest needle that is longer than 2 Centimeters *)
	ventingNeedleModel = First[PickList[needleModels, needleLengths, GreaterP[2 Centimeter]]];

	(* If requireSchlenkLinesField is True, we resource pick this needle *)
	reactionVesselVentingNeedleResource = If[MemberQ[requireSchlenkLinesField, True],
		Link[Resource[Sample -> ventingNeedleModel, Name -> CreateUUID[], Rent -> True]],
		Null
	];

	(* -- ReactionVesselInletNeedles resource picking -- *)
	(* NOTE: Each different sample gets a different inlet needle *)
	(* Find the reaction vessel heights from the models *)
	reactionVesselDimensions = Lookup[fetchPacketFromCache[#, cache], Dimensions]& /@ reactionVesselModels;

	(* Find the reaction vessel max height *)
	reactionVesselsMaxHeight = Max[reactionVesselDimensions[[All, 3]]];

	(* Find the electrode cap height *)
	electrodeCapHeight = If[MatchQ[electrodeCap, ObjectP[Model[Item, Cap, ElectrodeCap]]],

		(* If the electrode cap is a Model, lookup its height directly *)
		Lookup[fetchPacketFromCache[electrodeCap, cache], Dimensions][[3]],

		(* If the electrode cap is a Object, lookup its height through the Model *)
		Module[{electrodeCapModel},
			electrodeCapModel = Download[Lookup[fetchPacketFromCache[electrodeCap, cache], Model], Object];
			Lookup[fetchPacketFromCache[electrodeCapModel, cache], Dimensions][[3]]
		]
	];

	(* Find out the max value of (reaction vessel height + electrode cap height + 1 Centimeter), which will be the minimum length of the needle *)
	inletNeedleRequiredLength = reactionVesselsMaxHeight + electrodeCapHeight + 1 Centimeter;

	(* Find the right needle model *)
	inletNeedleModel = First[PickList[needleModels, needleLengths, GreaterEqualP[inletNeedleRequiredLength]]];

	(* For each samplesWithoutLinks, pick an inlet needle resource if the current pretreatmentSparging or sparging is True *)
	pretreatmentSpargingWithoutReplicates = Lookup[myResolvedOptions, PretreatmentSparging];
	spargingWithoutReplicates = Lookup[myResolvedOptions, Sparging];

	inletNeedleResourceReplaceRules = MapThread[
		Function[{sample, pretreatmentSparging, sparging},
			Module[{},
				sample -> If[Or[MatchQ[pretreatmentSparging, True], MatchQ[sparging, True]],

					(* If the current pretreatmentSparging or sparging is True, collect a resource *)
					Link[Resource[
						Sample -> inletNeedleModel,
						Name -> CreateUUID[],
						Rent -> True
					]],

					(* Otherwise, return Null *)
					Null
				]
			]
		],
		{samplesWithoutLinks, pretreatmentSpargingWithoutReplicates, spargingWithoutReplicates}
	];

	(* Prepare the reactionVesselInletNeedlesField *)
	reactionVesselInletNeedlesField = Replace[samplesWithReplicates, inletNeedleResourceReplaceRules, {1}];

	(* -------------------------- *)
	(* -- PreBubbler RESOURCES -- *)
	(* -------------------------- *)

	(* NOTE: when requesting the solvent resource for the pre-bubblers and loadingSampleSolvents, we request through the solvent itself, which means if the solvent is a Object, request the resource through the Object, not through its Model *)

	(* Create a variable to see if a prebubbler is needed for each samplesWithReplicates *)
	preBubblerRequired = MapThread[

		(* If pretreatment sparging or sparging is requesting a prebubbler, set this to True *)
		If[
			Or[MatchQ[#1, True], MatchQ[#2, True]],
			True,
			False
		]&,
		{pretreatmentSpargingPreBubblers, spargingPreBubblers}
	];

	(* First we get a PreBubbler Model that can be used *)
	preBubblerModel =  Download[First[PickList[defaultSpargingPreBubblers, defaultSpargingPreBubblerMaxVolumes - 2 * Max[loadingSampleVolumes], PositiveQuantityP]], Object];

	(* Get the volume information from the prebubbler *)
	preBubblerMaxVolume = Lookup[fetchPacketFromCache[Download[preBubblerModel, Object], cache], MaxVolume];
	preBubblerSolventVolume = SafeRound[preBubblerMaxVolume * 0.5, 1 Milliliter, RoundAmbiguous -> Up];

	(* PretreatmentSpargingPreBubbler solvent volumes *)
	pretreatmentSolventVolumes = pretreatmentSpargingPreBubblers /. {True -> preBubblerSolventVolume, False -> Null};

	(* SparingPreBubbler solvent volumes *)
	spargingSolventVolumes = spargingPreBubblers /. {True -> preBubblerSolventVolume, False -> Null};

	(* PreBubbler solvent volumes *)
	preBubblerSolventVolumes = preBubblerRequired /. {True -> preBubblerSolventVolume, False -> Null};

	(* Get unique solvents *)
	uniqueSolvents = DeleteDuplicates[solvents];

	(* Get unique solvents needed to fill preBubblers *)
	uniqueSolventsForPreBubblers = DeleteDuplicates[PickList[solvents, preBubblerRequired]];

	(* Get the unique prebubbler resource *)
	uniquePreBubblerResources = Map[
		(* For each unique SolventsForPreBubblers, we get a different prebubbler *)
		Link[Resource[
			Sample -> preBubblerModel,
			Name -> CreateUUID[],
			Rent -> True
		]]&,
		uniqueSolventsForPreBubblers
	];

	(* Prepare a helper association variable to link the unique solvent to its corresponding prebubbler resource *)
	uniqueSolventToUniquePrebubblerAssociation = Association[MapThread[
		(#1 -> #2)&,
		{uniqueSolventsForPreBubblers, uniquePreBubblerResources}
	]];

	(* Prepare the UniquePreBubblerSolventLoadingVolumes field *)
	uniquePreBubblerSolventLoadingVolumesField = If[Length[uniquePreBubblerResources] > 0,

		(* If the uniquePreBubblerResources is not an empty list, we create an array of preBubblerSolventVolume with the same list length *)
		ConstantArray[preBubblerSolventVolume, Length[uniquePreBubblerResources]],
		(* Otherwise, return an empty list as well *)
		{}
	];

	(* Create a helper variable to determine the solvent volume required for each uniqueSolventsForPreBubblers *)
	uniqueSolventsForPreBubblerVolumes = Map[
		(# -> preBubblerSolventVolume)&,
		uniqueSolventsForPreBubblers
	];

	(* Prepare the value for pretreatmentSpargingPreBubblersField and spargingPreBubblersField *)
	{pretreatmentSpargingPreBubblersField, spargingPreBubblersField} = Transpose[MapThread[
		Function[{solvent, pretreatmentRequiresPreBubbler, spargingRequiresPreBubbler},
			Module[{pretreatmentPreBubbler, spargingPreBubbler},
				pretreatmentPreBubbler = If[MatchQ[pretreatmentRequiresPreBubbler, True],
					(* If the current sample requires the pretreatment preBubbler, lookup the preBubbler from uniqueSolventToUniquePrebubblerAssociation *)
					Lookup[uniqueSolventToUniquePrebubblerAssociation, solvent],

					(* Otherwise, return Null *)
					Null
				];
				spargingPreBubbler = If[MatchQ[spargingRequiresPreBubbler, True],
					(* If the current sample requires the sparging preBubbler, lookup the preBubbler from uniqueSolventToUniquePrebubblerAssociation *)
					Lookup[uniqueSolventToUniquePrebubblerAssociation, solvent],

					(* Otherwise, return Null *)
					Null
				];
				{pretreatmentPreBubbler, spargingPreBubbler}
			]
		],
		{solvents, pretreatmentSpargingPreBubblers, spargingPreBubblers}
	]];

	(* Here, we need to prepare the installPretreatmentSpargingPreBubblersField, installSparingPreBubblersField, uninstallPreBubblersField *)
	(* Rules:
		1. The first sample with pretreatmentSparingPreBubbler or spargingPreBubbler set to True, the corresponding install is True
		2. The last sample's uninstallPreBubblersField is True
		3. For a sample, if the solvent is different from the next solvent, the uninstallPreBubblersField is True
	*)

	(* -- Get the value for the uninstallPreBubblersField -- *)
	(* Set up a helper variable from solvents: if the current preBubblerRequired is False, replace the current solvent to Null *)
	solventReferences = MapThread[
		If[MatchQ[#2, True],
			#1,
			Null
		]&,
		{solvents, preBubblerRequired}
	];

	(* Split the solventReferences into a list of {first part of the list, second part of the list} in the following way: The first part starts with one entry and ends with all the entries *)
	solventReferenceSplitsForUninstall = Map[
		{Take[solventReferences, #], Take[solventReferences, -(Length[solventReferences] - #)]}&,
		Range[Length[solventReferences]]
	];

	(* -- Get the value for the uninstallPreBubblersField -- *)
	uninstallPreBubblersField = Map[
		Function[{currentSplit},
			Module[{firstPart, safeFirstPart, secondPart, safeSecondPart, currentSolvent, currentEntry, nextSolvent, nextEntry},

				(* Get the first and second part of the currentSplit *)
				{firstPart, secondPart} = currentSplit;

				(* Get the cleaned version of the firstPart and secondPart: with Null replaced to Nothing *)
				{safeFirstPart, safeSecondPart} = {firstPart /. {Null -> Nothing}, secondPart /. {Null -> Nothing}};

				(* Get the last entry of the safeFirstPart as the currentSolvent. If safeFirstPart is {}, set currentSolvent to Null *)
				currentSolvent = If[!MatchQ[safeFirstPart, {}],
					Last[safeFirstPart],
					Null
				];

				(* Get the last entry of the firstPart (firstPart always has at least one entry) *)
				currentEntry = Last[firstPart];

				(* Get the first non-Null entry of the secondPart as the nextSolvent. If secondPart is {}, set nextSolvent to Null *)
				nextSolvent = If[!MatchQ[safeSecondPart, {}],
					First[safeSecondPart],
					Null
				];

				(* Get the first entry of the secondPart as the nextEntry. If secondPart is {}, set nextEntry to Null *)
				nextEntry = If[!MatchQ[secondPart, {}],
					First[secondPart],
					Null
				];

				(* The logics to check if the solvent changes *)
				Which[
					(* If both the currentSolvent and nextSolvent are Samples and they are different, return True *)
					And[
						MatchQ[currentSolvent, ObjectP[{Model[Sample], Object[Sample]}]],
						MatchQ[nextSolvent, ObjectP[{Model[Sample], Object[Sample]}]],
						!MatchQ[currentSolvent, nextSolvent]
					],
					True,

					(* If both the currentSolvent and nextSolvent are Samples and they are the same, return False *)
					And[
						MatchQ[currentSolvent, ObjectP[{Model[Sample], Object[Sample]}]],
						MatchQ[nextSolvent, ObjectP[{Model[Sample], Object[Sample]}]],
						MatchQ[currentSolvent, nextSolvent]
					],
					False,

					(* If the currentSolvent is Null, this means we haven't encountered any pre-bubblers yet, return False *)
					MatchQ[currentSolvent, Null],
					False,

					(* If the currentSolvent is a Sample and nextSolvent is Null, this means we have already installed a pre-bubbler and there is no further pre-bubbler manipulations, we need to check if the currentEntry is Null to prevent redundant uninstalls *)
					MatchQ[currentSolvent, ObjectP[{Model[Sample], Object[Sample]}]],
					If[MatchQ[currentEntry, ObjectP[{Model[Sample], Object[Sample]}]],
						(* If currentEntry is a sample, we return True *)
						True,
						(* If currentEntry is Null, we return False *)
						False
					]
				]
			]
		],
		solventReferenceSplitsForUninstall
	];

	(* -- installPretreatmentSpargingPreBubblersField and installSparingPreBubblersField -- *)
	(* Split the uninstallPreBubblersField by True's, along with pretreatmentSparingPreBubblers and spargingPreBubblers, then the first entry of each segment where either pretreatmentSparingPreBubblers or spargingPreBubblers is True, we set the corresponding install variable to True *)

	(* NOTE: Using Do is probably not ideal, but for now we use this method for no obvious better choice *)
	(* Two helper lists *)
	helperList = {};
	helperSubList = {};

	(* Split the uninstallPreBubblersField by True's, with True considered as the end of a segment *)
	uninstallSplits = Do[
		Module[{current},
			current = uninstallPreBubblersField[[i]];
			AppendTo[helperSubList, current];
			If[MatchQ[current, True],
				AppendTo[helperList, helperSubList];
				helperSubList = {};
			];

			(* Add in the last segment if we do not encounter a True *)
			If[i == Length[uninstallPreBubblersField] && !MatchQ[helperSubList, {}],
				AppendTo[helperList, helperSubList]
			]
		],
		{i, Length[uninstallPreBubblersField]}
	];

	(* Split the pretreatmentSparingPreBubblers and spargingPreBubblers according to uninstallSplits *)
	splitLengths = Length[#]& /@ helperList;

	pretreatmentPreBubblersSplits = TakeList[pretreatmentSpargingPreBubblers, splitLengths];
	spargingPreBubblersSplits = TakeList[spargingPreBubblers, splitLengths];

	(* we can finally determine installPretreatmentSpargingPreBubblersField and installSparingPreBubblersField *)
	{installPretreatmentSpargingPreBubblersField, installSparingPreBubblersField} = Transpose[MapThread[
		Function[{uninstallSegment, pretreatPreBubblerSegment, spargingPreBubblerSegment},
			Module[{pretreatmentInstall, spargingInstall},
				(* Check if the current uninstallSegment has the last entry as True *)
				If[MatchQ[Last[uninstallSegment], True],

					(* If the current uninstallSegment has the last entry as True, we find the first entry where either pretreatmentPreBubbler or the spargingPreBubbler is True *)
					Module[{helperPretreatmentInstall, helperSpargingInstall, listLength},
						helperPretreatmentInstall = {};
						helperSpargingInstall = {};
						listLength = Length[uninstallSegment];

						(* Find the first sample we need to install the prebubbler *)
						Do[
							Which[
								(* If the pretreatment prebubbler is True, add True to helperPretreatmentInstall and False to helperSpargingInstall, and Break *)
								MatchQ[pretreatPreBubblerSegment[[i]], True],
								AppendTo[helperPretreatmentInstall, True];
								AppendTo[helperSpargingInstall, False];
								Break[],

								(* If the sparging prebubbler install is True, add False to helperPretreatmentInstall and True to helperSpargingInstall, and Break *)
								MatchQ[spargingPreBubblerSegment[[i]], True],
								AppendTo[helperPretreatmentInstall, False];
								AppendTo[helperSpargingInstall, True];
								Break[],

								(* Otherwise, add False to both *)
								True,
								AppendTo[helperPretreatmentInstall, False];
								AppendTo[helperSpargingInstall, False];
							],
							{i, listLength}
						];

						pretreatmentInstall = PadRight[helperPretreatmentInstall, listLength, False];
						spargingInstall = PadRight[helperSpargingInstall, listLength, False];
					],

					(* If the current uninstallSegment does not have True, return a list of False's *)
					pretreatmentInstall = ConstantArray[False, Length[uninstallSegment]];
					spargingInstall = ConstantArray[False, Length[uninstallSegment]];
				];

				(* Return the results *)
				{pretreatmentInstall, spargingInstall}
			]
		],
		{helperList, pretreatmentPreBubblersSplits, spargingPreBubblersSplits}
	]];

	(* Flatten the fields *)
	installPretreatmentSpargingPreBubblersField = Flatten[installPretreatmentSpargingPreBubblersField];
	installSparingPreBubblersField = Flatten[installSparingPreBubblersField];


	(* -- ReactionVesselInletTubing, PreBubblerInletTubing, and PreBubblerOutletTubing resource picking -- *)
	(* Find the right inlet tubing models *)
	reactionVesselInletTubingModel = Download[Model[Plumbing, Tubing, "Luer Lock & Quick Disconnect"], Object];

	(* Find the right preBubbler inlet tubing model *)
	preBubblerInletTubingModel = Download[Model[Plumbing, Tubing, "Low Vac Adapter"], Object];

	(* Find the right preBubbler outlet tubing model *)
	preBubblerOutletTubingModel = Download[Model[Plumbing, Tubing, "Luer Lock & Quick Disconnect"], Object];

	(* Determine if we need the reactionVesselInletTubing and/or the preBubblerInletTubing *)
	{requireReactionVesselInletTubingChecks, requirePreBubblerTubingChecks} = Transpose[MapThread[
		Function[{pretreatSparging, pretreatPreBubbler, sparging, spargingPreBubbler},
			Module[{needSparging},

				(* Find out if we need sparging at all *)
				needSparging = Or[MatchQ[pretreatSparging, True], MatchQ[sparging, True]];

				If[MatchQ[needSparging, True],
					Module[{needReactionVesselTubing, needPreBubblerTubing},
						(* If the preBubbler is False for pretreatment or main sparing, we need the reaction vessel inlet tubing *)
						needReactionVesselTubing = Or[
							And[MatchQ[pretreatSparging, True], MatchQ[pretreatPreBubbler, False]],
							And[MatchQ[sparging, True], MatchQ[spargingPreBubbler, False]]
						];

						(* If the preBubbler is True for pretreatment or main sparing, we need the pre-bubbler inlet tubing *)
						needPreBubblerTubing = Or[
							And[MatchQ[pretreatSparging, True], MatchQ[pretreatPreBubbler, True]],
							And[MatchQ[sparging, True], MatchQ[spargingPreBubbler, True]]
						];

						{needReactionVesselTubing, needPreBubblerTubing}
					],

					(* If we do not need sparging at all, return False *)
					{False, False}
				]
			]
		],
		{pretreatmentSpargings, pretreatmentSpargingPreBubblers, spargings, spargingPreBubblers}
	]];

	requireReactionVesselInletTubing = MemberQ[requireReactionVesselInletTubingChecks, True];
	requirePreBubblerTubing = MemberQ[requirePreBubblerTubingChecks, True];

	(* Pick the reaction vessel inlet tubing resource *)
	reactionVesselInletTubingResource = If[MatchQ[requireReactionVesselInletTubing, True],
		Link[Resource[
			Sample -> reactionVesselInletTubingModel,
			Name -> CreateUUID[],
			Rent -> True
		]],
		(* If we do not need this resource, return Null *)
		Null
	];

	(* Pick the preBubbler inlet tubing resource *)
	preBubblerInletTubingResource = If[MatchQ[requirePreBubblerTubing, True],
		Link[Resource[
			Sample -> preBubblerInletTubingModel,
			Name -> CreateUUID[],
			Rent -> True
		]],
		(* If we do not need this resource, return Null *)
		Null
	];

	(* Pick the preBubbler outlet tubing resource *)
	preBubblerOutletTubingResource = If[MatchQ[requirePreBubblerTubing, True],
		Link[Resource[
			Sample -> preBubblerOutletTubingModel,
			Name -> CreateUUID[],
			Rent -> True
		]],
		(* If we do not need this resource, return Null *)
		Null
	];

	(* ----------------------- *)
	(* -- Solvent RESOURCES -- *)
	(* ----------------------- *)

	(* LoadingSample solvent volumes *)
	loadingSampleSolventVolumes = SafeRound[solventVolumes /. {x:VolumeP :> x * resourceExpansionFactor}, 1 Milliliter, RoundAmbiguous -> Up];

	(* Pair the solvents and their volumes *)
	pairedLoadingSampleSolventsAndVolumes = MapThread[
		(#1 -> #2)&,
		{solvents, loadingSampleSolventVolumes}
	] /. {(_ -> Null) -> Nothing};

	(* Merge the Solvent volumes together to get the total volumes of each Solvent *)
	solventVolumeRules = Merge[Join[pairedLoadingSampleSolventsAndVolumes, uniqueSolventsForPreBubblerVolumes], Total];

	(* Make replace rules for the Solvent and its resources; doing it this way because we only want to make one resource per Solvent including in replicates *)
	solventResourceReplaceRules = KeyValueMap[
		Function[{solvent, volume},
			solvent -> Link[Resource[
				Sample -> Download[solvent, Object],
				Amount -> volume,
				Name -> CreateUUID[],
				(* Find out the right container model from preferred containers *)
				Container -> First[PickList[preferredContainers, preferredContainerMaxVolumes, GreaterP[volume]]]
			]]
		],
		solventVolumeRules
	];

	(* Prepare the Solvent resources and fields *)
	solventResources = Values[solventResourceReplaceRules];

	(* NOTE: we are not changing the Solvents field to a resource for a prepared sample, just put the solvent model in the field *)
	solventsField = MapThread[
		Function[{solvent, volume},
			If[VolumeQ[volume],
				Replace[solvent, solventResourceReplaceRules],
				Link[solvent]
			]
		],
		{solvents, loadingSampleSolventVolumes}
	];

	(* Prepare the uniquePreBubblerSolventsField *)
	uniquePreBubblerSolventsField = Map[
		Lookup[solventResourceReplaceRules, #]&,
		uniqueSolventsForPreBubblers
	];

	(* Prepare the pretreatmentSpargingPreBubblerSolventsField and spargingPreBubblerSolventsField *)
	{pretreatmentSpargingPreBubblerSolventsField, spargingPreBubblerSolventsField} = Transpose[MapThread[
		Function[{currentSolvent, pretreatmentRequiresPreBubbler, spargingRequiresPreBubbler},
			Module[{pretreatmentSolvent, spargingSolvent},
				pretreatmentSolvent = If[MatchQ[pretreatmentRequiresPreBubbler, True],
					(* If the pretreatmentRequiresPreBubbler is True, find the solvent resource *)
					Lookup[solventResourceReplaceRules, currentSolvent],

					(* Otherwise, return Null *)
					Null
				];
				spargingSolvent = If[MatchQ[spargingRequiresPreBubbler, True],
					(* If the spargingRequiresPreBubbler is True, find the solvent resource *)
					Lookup[solventResourceReplaceRules, currentSolvent],

					(* Otherwise, return Null *)
					Null
				];
				{pretreatmentSolvent, spargingSolvent}
			]
		],
		{solvents, pretreatmentSpargingPreBubblers, spargingPreBubblers}
	]];

	(* ------------------------------------------ *)
	(* -- CyclicVoltammetry Measurement FIELDS -- *)
	(* ------------------------------------------ *)
	{
		safePrimaryCyclicVoltammetryPotentials,
		safeSecondaryCyclicVoltammetryPotentials,
		safeTertiaryCyclicVoltammetryPotentials,
		safeQuaternaryCyclicVoltammetryPotentials
	} = Transpose[MapThread[
		Function[{myInitialPotentials, myFirstPotentials,
			mySecondPotentials, myFinalPotentials, myPotentialSweepRates,
			myNumberOfCycles},
			Module[
				{
					primaryPotentials,
					secondaryPotentials,
					tertiaryPotentials,
					quaternaryPotentials
				},

				(* We always have primaryPotentials *)
				primaryPotentials = Association[
					InitialPotential -> myInitialPotentials[[1]],
					FirstPotential -> myFirstPotentials[[1]],
					SecondPotential -> mySecondPotentials[[1]],
					FinalPotential -> myFinalPotentials[[1]],
					SweepRate -> myPotentialSweepRates[[1]]
				];

				(* If NumberOfCycles is at least 2, we have secondaryPotentials *)
				secondaryPotentials = If[GreaterEqualQ[myNumberOfCycles, 2],
					Association[
						InitialPotential -> myInitialPotentials[[2]],
						FirstPotential -> myFirstPotentials[[2]],
						SecondPotential -> mySecondPotentials[[2]],
						FinalPotential -> myFinalPotentials[[2]],
						SweepRate -> myPotentialSweepRates[[2]]
					],
					Association[
						InitialPotential -> Null,
						FirstPotential -> Null,
						SecondPotential -> Null,
						FinalPotential -> Null,
						SweepRate -> Null
					]
				];

				(* If NumberOfCycles is at least 3, we have tertiaryPotentials *)
				tertiaryPotentials = If[GreaterEqualQ[myNumberOfCycles, 3],
					Association[
						InitialPotential -> myInitialPotentials[[3]],
						FirstPotential -> myFirstPotentials[[3]],
						SecondPotential -> mySecondPotentials[[3]],
						FinalPotential -> myFinalPotentials[[3]],
						SweepRate -> myPotentialSweepRates[[3]]
					],
					Association[
						InitialPotential -> Null,
						FirstPotential -> Null,
						SecondPotential -> Null,
						FinalPotential -> Null,
						SweepRate -> Null
					]
				];

				(* If NumberOfCycles is at least 4, we have quaternaryPotentials *)
				quaternaryPotentials = If[GreaterEqualQ[myNumberOfCycles, 4],
					Association[
						InitialPotential -> myInitialPotentials[[4]],
						FirstPotential -> myFirstPotentials[[4]],
						SecondPotential -> mySecondPotentials[[4]],
						FinalPotential -> myFinalPotentials[[4]],
						SweepRate -> myPotentialSweepRates[[4]]
					],
					Association[
						InitialPotential -> Null,
						FirstPotential -> Null,
						SecondPotential -> Null,
						FinalPotential -> Null,
						SweepRate -> Null
					]
				];

				{primaryPotentials, secondaryPotentials, tertiaryPotentials, quaternaryPotentials}
			]
		],
		{
			initialPotentials,
			firstPotentials,
			secondPotentials,
			finalPotentials,
			potentialSweepRates,
			numberOfCycles
		}]];

	(* -- Electrode racks -- *)
	(* ImagingRack *)
	electrodeImagingRackModel = Model[Container, Rack, "Electrode Imaging Holder for IKA Electrodes"];
	electrodeImagingRackResource = Resource[Sample -> electrodeImagingRackModel, Name -> CreateUUID[], Rent -> True];

	(* Reference electrode rack *)
	referenceElectrodeRackModel = Model[Container, Rack, "Electrode Holder for IKA Reference Electrodes"];
	referenceElectrodeRackResource = Resource[Sample -> referenceElectrodeRackModel, Name -> CreateUUID[], Rent -> True];

	(* -------------------- *)
	(* -- TIME ESTIMATES -- *)
	(* -------------------- *)

	(* -- sample prep time estimate -- *)
	(* For now, assume 10 minute per sample for the preparation *)
	samplePrepTime = (10 Minute) * Length[samplesWithReplicates] + (30 Minute);

	(* -- resource picking time estimate -- *)
	(* roughly calculate the time required to gather resources: 15 min per sample for resource picking *)
	gatherResourcesTime = (15 Minute) * Length[samplesWithReplicates] + (30 Minute);

	(* Assume 1 hour for each sample *)
	experimentPreparationTime = (1 Hour) * Length[samplesWithReplicates];

	(* -- Note: We just roughly estimate each sample takes about two hours to finish all the electrode polishing/sonication/washing/pretreatment/measurement/InternalStandard addition.-- *)
	experimentTime = (3 Hour) * Length[samplesWithReplicates];

	(* -------------------------- *)
	(* -- INSTRUMENT RESOURCES -- *)
	(* -------------------------- *)

	(* -- Electrochemical reactor -- *)
	(* get the instrument resources. we will assume 2 hours per sample for the instrument *)
	instrumentResource = Resource[Instrument -> instrument, Time -> experimentTime];

	(* get the reaction vessel holder *)
	reactionVesselHolderModel = Model[Container, Rack, "IKA Single Reaction Vessel Holder"];
	reactionVesselHolderResource = Resource[Sample -> reactionVesselHolderModel, Name -> CreateUUID[], Rent -> True];

	(* -- FumeHood -- *)
	fumeHoodModel = Model[Instrument, FumeHood, "Labconco Premier 6 Foot"];
	fumeHoodResource = Resource[Instrument -> fumeHoodModel, Time -> experimentTime];

	(* -- SchlenkLine -- *)
	schlenkLineModel = Model[Instrument, SchlenkLine, "High Tech Schlenk Line"];

	(* SchlenkLines for pretreatment sparging and main sparging *)
	schlenkLineResources = MapThread[
		Function[{pretreatmentSparging, pretreatmentSpargingTime, sparging, spargingTime, required},
			If[MatchQ[required, True],
				(* If we need to do pretreatment sparging and/or main sparging, we create the resource *)
				Link[Resource[
					Instrument -> schlenkLineModel,
					Name -> CreateUUID[],
					Time -> (pretreatmentSpargingTime /. {Null -> 0 Minute}) + (spargingTime /. {Null -> 0 Minute}) + (30 Minute)
				]],
				(* Otherwise, return Null *)
				Null
			]
		],
		{pretreatmentSpargings, safePretreatmentSpargingTimes, spargings, safeSpargingTimes, requireSchlenkLinesField}
	];

	(* SchlenkLines for post measurement standard addition sample sparging *)
	postMeasurementStandardAdditionSchlenkLineResources = MapThread[
		Function[{sparging, spargingTime},
			If[MatchQ[sparging, True],
				(* If we need to do post measurement sparging, we create the resource *)
				Link[Resource[
					Instrument -> schlenkLineModel,
					Name -> CreateUUID[],
					Time -> spargingTime + (30 Minute)
				]],
				(* Otherwise, return Null *)
				Null
			]
		],
		{spargings, safeSpargingTimes}
	];

	(* --------------------- *)
	(* -- PROTOCOL PACKET -- *)
	(* --------------------- *)

	(* Create our protocol packet. *)
	protocolPacket = Join[<|
		Type->Object[Protocol,CyclicVoltammetry],
		Object->CreateID[Object[Protocol,CyclicVoltammetry]],
		Replace[SamplesIn]->samplesInResources,
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@DeleteDuplicates[Lookup[fetchPacketFromCache[#,cache],Container]&/@samplesWithReplicates],

		(* -- Instrument -- *)
		Instrument -> Link[instrumentResource],
		ReactionVesselHolder -> Link[reactionVesselHolderResource],
		FumeHood -> Link[fumeHoodResource],

		(* -- General options -- *)
		Replace[Analytes] -> (Link[#]&)/@analytes,
		WorkingElectrode -> Link[workingElectrodeResource],
		CounterElectrode -> Link[counterElectrodeResource],
		Replace[ReferenceElectrodes] -> referenceElectrodesField,
		ElectrodeCap -> Link[electrodeCapResource],
		Replace[ReactionVessels] -> reactionVesselResources,

		(* Working electrode polishing *)
		Replace[PrimaryPolishings] -> safePrimaryPolishings,
		Replace[SecondaryPolishings] -> safeSecondaryPolishings,
		Replace[TertiaryPolishings] -> safeTertiaryPolishings,
		Replace[WorkingElectrodePolishWashingSolutions] -> safeWorkingElectrodePolishWashingSolutions,
		Replace[UniquePolishingSolutions] -> uniquePolishingSolutionsField,
		Replace[UniquePolishingSolutionVolumes] -> uniquePolishingSolutionVolumes,
		Replace[UniquePolishingPads] -> uniquePolishingPadsField,
		Replace[UniquePolishingPlates] -> uniquePolishingPlatesField,

		(* Working electrode sonication *)
		Replace[WorkingElectrodeSonicationTimes] -> safeWorkingElectrodeSonicationTimes,
		Replace[WorkingElectrodeSonicationTemperatures] -> safeWorkingElectrodeSonicationTemperatures,
		WorkingElectrodeSonicationContainer -> workingElectrodeSonicationContainerResource,
		WorkingElectrodeSonicationSolvent -> workingElectrodeSonicationSolventResource,
		WorkingElectrodeSonicationSolventVolume -> safeWorkingElectrodeSonicationSolventVolume,

		(* electrode washing *)
		Replace[WorkingElectrodeWashingSolutions] -> safeWorkingElectrodeWashingSolutions,
		Replace[CounterElectrodeWashingSolutions] -> safeCounterElectrodeWashingSolutions,
		Replace[WorkingElectrodeWashingCycles] -> safeWorkingElectrodeWashingCycles,
		Replace[UniqueElectrodeWashingSolutions] -> uniqueElectrodeWashingSolutionField,
		Replace[UniqueElectrodeWashingSolutionVolumes] -> uniqueElectrodeWashingSolutionVolumes,
		Replace[WashingSolutionsCollectionContainers] -> washingSolutionCollectionContainerResources,
		WashingWaterCollectionContainer -> washingWaterCollectionContainerField,
		WashingMethanolCollectionContainer -> washingMethanolCollectionContainerField,
		Tweezers -> tweezerResource,
		ElectrodeImagingRack -> Link[electrodeImagingRackResource],
		ReferenceElectrodeRack -> Link[referenceElectrodeRackResource],
		Replace[DryWorkingElectrode] -> dryWorkingElectrodeField,
		Replace[DryCounterElectrode] -> dryCounterElectrodeField,

		(* reference electrode and reference solution related *)
		Replace[RefreshReferenceElectrodes] -> refreshReferenceElectrodes,
		Replace[ReferenceElectrodeSoakTimes] -> referenceElectrodeSoakTimes,

		(* Pretreatment-related *)
		Replace[ElectrolyteSolutions] -> electrolyteSolutionResources,
		Replace[ElectrolyteSolutionLoadingVolumes] -> safeElectrodeSolutionLoadingVolumes,

		Replace[PretreatmentReactionVessels] -> pretreatmentReactionVesselResources,
		Replace[PretreatmentSpargingGases] -> safePretreatmentSpargingGases,
		Replace[PretreatmentSpargingTimes] -> safePretreatmentSpargingTimes,
		Replace[PretreatmentSpargingPressures] -> safePretreatmentSpargingPressures,
		Replace[PretreatmentSpargingPreBubblers] -> pretreatmentSpargingPreBubblersField,
		Replace[PretreatmentSpargingPreBubblerSolvents] -> pretreatmentSpargingPreBubblerSolventsField,
		Replace[PretreatmentSpargingPreBubblerSolventVolumes] -> pretreatmentSolventVolumes,
		Replace[PretreatmentPrimaryPotentials] -> safePretreatmentPrimaryPotentials,
		Replace[PretreatmentSecondaryPotentials] -> safePretreatmentSecondaryPotentials,
		Replace[PretreatmentTertiaryPotentials] -> safePretreatmentTertiaryPotentials,
		Replace[PretreatmentQuaternaryPotentials] -> safePretreatmentQuaternaryPotentials,
		Replace[PretreatmentNumberOfCycles] -> pretreatmentNumberOfCycles /. {Null -> 0},
		Replace[InstallPretreatmentSpargingPreBubblers] -> installPretreatmentSpargingPreBubblersField,

		(* LoadingSample preparation *)
		Replace[SampleDilutions] -> safeSampleDilutions,
		Replace[SolidSampleAmounts] -> safeSolidSampleAmounts,
		Replace[LoadingSampleTargetConcentrations] -> safeTargetConcentrations,
		Replace[Solvents] -> solventsField,
		Replace[RequestedSolvents] -> solventResources,
		Replace[SolventVolumes] -> safeSolventVolumes,
		Replace[Electrolytes] -> electrolytesField,
		Replace[RequestedElectrolytes] -> loadingSampleElectrolyteResources,
		Replace[LoadingSampleElectrolyteAmounts] -> safeLoadingSampleElectrolyteAmounts,
		Replace[ElectrolyteTargetConcentrations] -> safeElectrolyteTargetConcentrations,

		(* internal standard related *)
		Replace[InternalStandards] -> internalStandardsField,
		Replace[RequestedInternalStandards] -> internalStandardResources,
		Replace[InternalStandardAdditionOrders] -> safeInternalStandardAdditionOrders,
		Replace[InternalStandardAmounts] -> safeInternalStandardAmounts,
		Replace[InternalStandardTargetConcentrations] -> safeInternalStandardTargetConcentrations,

		(* loading sample mix related *)
		Replace[LoadingSamplePreparationContainers] -> loadingSamplePreparationContainerResources,
		Replace[LoadingSampleMixes] -> safeLoadingSampleMixes,
		Replace[LoadingSampleMixTypes] -> safeLoadingSampleMixTypes,
		Replace[LoadingSampleMixTemperatures] -> safeLoadingSampleMixTemperatures,
		Replace[LoadingSampleMixTimes] -> safeLoadingSampleMixTimes,
		Replace[LoadingSampleNumberOfMixes] -> safeLoadingSampleNumberOfMixes,
		Replace[LoadingSampleMixVolumes] -> safeLoadingSampleMixVolumes,
		Replace[LoadingSampleMixUntilDissolveds] -> safeLoadingSampleMixUntilDissolveds,
		Replace[LoadingSampleMaxNumberOfMixes] -> safeLoadingSampleMaxNumberOfMixes,
		Replace[LoadingSampleMaxMixTimes] -> safeLoadingSampleMaxMixTimes,

		(* sparging related *)
		Replace[SpargingGases] -> safeSpargingGases,
		Replace[SpargingTimes] -> safeSpargingTimes,
		Replace[SpargingPressures] -> safeSpargingPressures,
		Replace[SpargingPreBubblers] -> spargingPreBubblersField,
		Replace[SpargingPreBubblerSolvents] -> spargingPreBubblerSolventsField,
		Replace[SpargingPreBubblerSolventVolumes] -> spargingSolventVolumes,

		(* -- Sparing helper fields -- *)
		(* ReactionVessels *)
		Replace[RequireSchlenkLines] -> requireSchlenkLinesField,
		Replace[SchlenkLines] -> schlenkLineResources,
		Replace[PostMeasurementStandardAdditionSchlenkLines] -> postMeasurementStandardAdditionSchlenkLineResources,
		ReactionVesselVentingNeedle -> reactionVesselVentingNeedleResource,
		ReactionVesselInletTubing -> reactionVesselInletTubingResource,
		Replace[ReactionVesselInletNeedles] -> reactionVesselInletNeedlesField,

		(* PreBubblers *)
		PreBubblerInletTubing -> preBubblerInletTubingResource,
		PreBubblerOutletTubing -> preBubblerOutletTubingResource,
		Replace[UniquePreBubblers] -> uniquePreBubblerResources,
		Replace[UniquePreBubblerSolvents] -> uniquePreBubblerSolventsField,
		Replace[UniquePreBubblerSolventLoadingVolumes] -> uniquePreBubblerSolventLoadingVolumesField,
		Replace[InstallSpargingPreBubblers] -> installSparingPreBubblersField,
		Replace[UninstallPreBubblers] -> uninstallPreBubblersField,

		(* cyclic voltammetry measurements *)
		Replace[LoadingSampleVolumes] -> loadingSampleVolumes,
		Replace[PrimaryCyclicVoltammetryPotentials] -> safePrimaryCyclicVoltammetryPotentials,
		Replace[SecondaryCyclicVoltammetryPotentials] -> safeSecondaryCyclicVoltammetryPotentials,
		Replace[TertiaryCyclicVoltammetryPotentials] -> safeTertiaryCyclicVoltammetryPotentials,
		Replace[QuaternaryCyclicVoltammetryPotentials] -> safeQuaternaryCyclicVoltammetryPotentials,
		Replace[NumberOfCycles] -> numberOfCycles,

		(* Post CV Internal Standard Addition *)
		Replace[PostMeasurementStandardAdditionContainers] -> postMeasurementStandardAdditionContainerResources,
		(* We need to populate the PostMeasurementStandardAdditionSamples here for the looping procedure *)
		Replace[PostMeasurementStandardAdditionSamples] -> ConstantArray[Null, numberOfSamples],

		(* checkpoints *)
		Replace[Checkpoints]->{
			{
				"Preparing Samples",
				5 Minute,
				"Preprocessing, such as incubation/mixing, and aliquotting, is performed.",
				Resource[Operator->$BaselineOperator,Time->5 Minute]
			},
			{
				"Picking Resources",
				gatherResourcesTime,
				"Samples and items required to execute this protocol are gathered from storage.",
				Resource[Operator->$BaselineOperator,Time->gatherResourcesTime]
			},
			{
				"Experiment Preparation",
				gatherResourcesTime,
				"Solid samples are dissolved in the solvents. Loading samples are transferred into the reaction vessels. Electrolyte solutions (if any) are transferred into pretreatment reaction vessels.",
				Resource[Operator->$BaselineOperator,Time->experimentPreparationTime]
			},
			{
				"Experiment Execution",
				experimentTime,
				"Execute the electrode preparations and cyclic voltammetry measurements.",
				Resource[Operator->$BaselineOperator,Time->experimentTime]
			},
			{
				"Sample Postprocessing",
				0 Minute,
				"The samples are imaged and volumes are measured.",
				Resource[Operator->$BaselineOperator,Time->0 Minute]
			}
		},
		ResolvedOptions->myCollapsedResolvedOptions,
		UnresolvedOptions->myUnresolvedOptions,
		Replace[SamplesInStorage]->samplesInStorageConditions,
		Replace[SamplesOutStorage]->samplesOutStorageConditions
	|>,
		populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cache,Simulation->updatedSimulation]
	];

	(* ---------------------- *)
	(* -- CLEAN UP AND FRQ -- *)
	(* ---------------------- *)

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],
		{True,{}},
		gatherTests,
		Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache,Simulation->updatedSimulation],
		True,
		{Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->Not[gatherTests],Cache->cache,Simulation->updatedSimulation],Null}
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		protocolPacket,
		$Failed
	];

	(* Return our result. *)
	outputSpecification/.{resultRule,testsRule}
];


(* ::Subsubsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentCyclicVoltammetry,
	Options:>{CacheOption,SimulationOption}
];

simulateExperimentCyclicVoltammetry[
	myResourcePacket:(PacketP[Object[Protocol, CyclicVoltammetry], {Object, ResolvedOptions}]|$Failed),
	mySamples:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentCyclicVoltammetry]
]:=Module[
	{
		cache, simulation, samplePackets, protocolObject, fulfillmentSimulation, updatedSimulation,

		(* Download *)
		protocolDownloadFieldNames, allDownloadFields, protPacket, samplesInCompositionPackets, workingSamplesCompositionPackets, electrolytePackets, internalStandardPackets, solventPackets, electrolyteSolutionPackets, sonicationSolventPacket, preBubblerSolventPackets, polishingSolutionPackets,

		(* Information lookup *)
		samplesIn, workingSamples, sampleDilutions, solidSampleAmounts, electrolytes, electrolyteAmounts, internalStandards, internalStandardAdditionOrders, internalStandardAmounts, solvents, solventVolumes, loadingSampleVolumes, loadingSamplePreparationContainers, reactionVessels,
		electrolyteSolutions, electrolyteSolutionLoadingVolumes, pretreatmentReactionVessels,
		sonicationContainer, sonicationSolvent, sonicationSolventVolume,
		uniquePreBubblers, uniquePreBubblerSolvents, uniquePreBubblerSolventLoadingVolumes,
		uniquePolishingSolutions, uniquePolishingSolutionVolumes, uniqueElectrodeWashingSolutions, uniqueElectrodeWashingSolutionVolumes, washingSolutionsCollectionContainers,

		(* LoadingSample preparation *)
		expandedWorkingSamples, loadingSamplePreparationPackets,

		(* electrolyte solution, sonication solvent, prebubbler solvent *)
		electrolyteSolutionTransferPackets, sonicationSolventTransferPackets, preBubblerSolventTransferPackets,

		(* washing and polishing solutions *)
		washingSolutionModels, numberOfUniqueWashingSolutionModels, washingSolutionUploadSamplePackets, polishingSolutionModels, numberOfUniquePolishingSolutionModels, polishingSolutionUploadSamplePackets, polishingSolutionPacketsForUploadSampleTransfer, polishingSolutionUploadSampleTransferPackets,

		simulationWithLabels
	},

	(* Lookup our cache and simulation. *)
	cache=Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* Download containers from our sample packets. *)
	samplePackets=Download[
		mySamples,
		Packet[Container],
		Cache->Lookup[ToList[myResolutionOptions], Cache, {}],
		Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
	];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=If[MatchQ[myResourcePacket, $Failed],
		SimulateCreateID[Object[Protocol,CyclicVoltammetry]],
		Lookup[myResourcePacket, Object]
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	fulfillmentSimulation=If[MatchQ[myResourcePacket, $Failed],
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
			myResourcePacket,
			Cache->cache,
			Simulation->simulation
		]
	];

	(* Update simulation with fulfillment simulation *)
	updatedSimulation = UpdateSimulation[simulation, fulfillmentSimulation];

	(* ================== *)
	(* ==== Download ==== *)
	(* ================== *)

	(* protocol download fields *)
	protocolDownloadFieldNames = Packet[
		SamplesIn,
		WorkingSamples,
		WorkingContainers,
		SampleDilutions,
		SolidSampleAmounts,
		Electrolytes,
		LoadingSampleElectrolyteAmounts,
		InternalStandards,
		InternalStandardAdditionOrders,
		InternalStandardAmounts,
		Solvents,
		SolventVolumes,
		LoadingSampleVolumes,
		ReactionVessels,

		(* LoadingSampleMix options *)
		LoadingSamplePreparationContainers,
		LoadingSampleMixes,
		LoadingSampleMixTypes,
		LoadingSampleMixTemperatures,
		LoadingSampleMixTimes,
		LoadingSampleNumberOfMixes,
		LoadingSampleMixVolumes,
		LoadingSampleMixUntilDissolveds,
		LoadingSampleMaxNumberOfMixes,
		LoadingSampleMaxMixTimes,

		(* Electrode Pretreatment *)
		ElectrolyteSolutions,
		ElectrolyteSolutionLoadingVolumes,
		PretreatmentReactionVessels,

		(* WiringConnections needed *)
		WorkingElectrode,
		CounterElectrode,
		ReferenceElectrodes,
		ElectrodeCap,
		Instrument,

		(* Working Electrode Sonication *)
		WorkingElectrodeSonicationContainer,
		WorkingElectrodeSonicationSolvent,
		WorkingElectrodeSonicationSolventVolume,

		(* PreBubblers related *)
		UniquePreBubblers,
		UniquePreBubblerSolvents,
		UniquePreBubblerSolventLoadingVolumes,

		(* Connections needed *)
		ReactionVesselInletTubing,
		PreBubblerInletTubing,
		PreBubblerOutletTubing,

		PretreatmentSpargingPreBubblers,
		SpargingPreBubblers,
		InstallPretreatmentSpargingPreBubblers,
		InstallSpargingPreBubblers,
		UninstallPreBubblers,

		(* Polish and washing solutions *)
		UniquePolishingSolutions,
		UniquePolishingSolutionVolumes,
		UniqueElectrodeWashingSolutions,
		UniqueElectrodeWashingSolutionVolumes,
		WashingSolutionsCollectionContainers
	];

	allDownloadFields = {
		protocolDownloadFieldNames,
		Packet[SamplesIn[{Composition}]],
		Packet[WorkingSamples[{Composition}]],
		Packet[Electrolytes[{Model}]],
		Packet[InternalStandards[{Model}]],
		Packet[Solvents[{Model}]],
		Packet[ElectrolyteSolutions[{Model}]],
		Packet[WorkingElectrodeSonicationSolvent[{Model}]],
		Packet[UniquePreBubblerSolvents[{Model}]],
		Packet[UniquePolishingSolutions[{Model}]]
	};

	{
		{
			protPacket,
			samplesInCompositionPackets,
			workingSamplesCompositionPackets,
			electrolytePackets,
			internalStandardPackets,
			solventPackets,
			electrolyteSolutionPackets,
			sonicationSolventPacket,
			preBubblerSolventPackets,
			polishingSolutionPackets
		}
	} = Quiet[Download[protocolObject,
		{
			allDownloadFields
		},
		Cache -> cache,
		Simulation -> updatedSimulation,
		Date -> Now
	], Download::FieldDoesntExist];

	(* ==================== *)
	(* ==== Simulation ==== *)
	(* ==================== *)
	(* NOTE: any data related information is not simulated, since we can't predict the data at this point *)

	(* === Compiler Corresponding Changes === *)
	(* -- Lookup -- *)
	(* -- Lookup the sample related information -- *)
	{
		samplesIn,
		workingSamples,
		sampleDilutions,
		solidSampleAmounts,
		electrolytes,
		electrolyteAmounts,
		internalStandards,
		internalStandardAdditionOrders,
		internalStandardAmounts,
		solvents,
		solventVolumes,
		loadingSampleVolumes,
		loadingSamplePreparationContainers,
		reactionVessels
	} = Lookup[protPacket, {
		SamplesIn,
		WorkingSamples,
		SampleDilutions,
		SolidSampleAmounts,
		Electrolytes,
		LoadingSampleElectrolyteAmounts,
		InternalStandards,
		InternalStandardAdditionOrders,
		InternalStandardAmounts,
		Solvents,
		SolventVolumes,
		LoadingSampleVolumes,
		LoadingSamplePreparationContainers,
		ReactionVessels
	}] /. {x:ObjectP[] -> Download[x, Object]};

	(* -- Lookup pretreatment related information -- *)
	{
		electrolyteSolutions,
		electrolyteSolutionLoadingVolumes,
		pretreatmentReactionVessels
	} = Lookup[protPacket, {
		ElectrolyteSolutions,
		ElectrolyteSolutionLoadingVolumes,
		PretreatmentReactionVessels
	}] /. {x:ObjectP[] -> Download[x, Object]};

	(* -- Lookup working electrode sonication related information -- *)
	{
		sonicationContainer,
		sonicationSolvent,
		sonicationSolventVolume
	} = Lookup[protPacket, {
		WorkingElectrodeSonicationContainer,
		WorkingElectrodeSonicationSolvent,
		WorkingElectrodeSonicationSolventVolume
	}] /. {x:ObjectP[] -> Download[x, Object]};

	(* -- Lookup prebubbler related information -- *)
	{
		uniquePreBubblers,
		uniquePreBubblerSolvents,
		uniquePreBubblerSolventLoadingVolumes
	} = Lookup[protPacket, {
		UniquePreBubblers,
		UniquePreBubblerSolvents,
		UniquePreBubblerSolventLoadingVolumes
	}] /. {x:ObjectP[] -> Download[x, Object]};

	(* -- Lookup Polishing/Washing fields -- *)
	{
		uniquePolishingSolutions,
		uniquePolishingSolutionVolumes,

		uniqueElectrodeWashingSolutions,
		uniqueElectrodeWashingSolutionVolumes,
		washingSolutionsCollectionContainers
	} = Lookup[protPacket,
		{
			(* Polishing Information *)
			UniquePolishingSolutions,
			UniquePolishingSolutionVolumes,

			(* Washing Information *)
			UniqueElectrodeWashingSolutions,
			UniqueElectrodeWashingSolutionVolumes,
			WashingSolutionsCollectionContainers
		}
	] /. {x:ObjectP[] :> Download[x, Object]};

	(* If WorkingSamples is an empty list, we expand it with Null's *)
	expandedWorkingSamples = If[MatchQ[workingSamples, Null|{}],
		ConstantArray[Null, Length[samplesIn]],
		workingSamples
	];

	(* -- LoadingSample preparation -- *)
	(* generate the loadingSample Transfers *)
	loadingSamplePreparationPackets = Flatten[MapThread[
		Function[{sampleDilution, reactionVessel, preparationContainer, currentSampleIn, currentWorkingSample, sampleAmount, electrolyte, electrolyteAmount, internalStandard, internalStandardAdditionOrder, internalStandardAmount, solvent, solventVolume, loadingSampleVolume},
			Module[{currentSample, currentSampleComposition},

				(* check if workingSamples is populated, if not, we use SamplesIn directly *)
				currentSample = If[MatchQ[currentWorkingSample,Null],
					currentSampleIn,
					currentWorkingSample
				];

				(* Get the current sample composition *)
				currentSampleComposition = Lookup[fetchPacketFromCache[
					currentSample,
					If[MatchQ[currentWorkingSample,Null],
						samplesInCompositionPackets,
						workingSamplesCompositionPackets
					]
				], Composition];

				If[MatchQ[sampleDilution, True],

					(* If the current sample needs preparation, we need to consider the sample, electrolyte, internal standard and the solvent *)
					Module[{
						sampleUploadToPrepContainerPackets,
						sampleTransferToPrepContainerPackets,
						electrolyteUploadToPrepContainerPackets,
						electrolyteTransferToPrepContainerPackets,
						solventUploadToPrepContainerPackets,
						solventTransferToPrepContainerPackets,

						sampleUploadToReactionVesselPackets,
						sampleTransferToReactionVesselPackets,
						electrolyteUploadToReactionVesselPackets,
						electrolyteTransferToReactionVesselPackets,
						standardUploadToReactionVesselPackets,
						standardTransferToReactionVesselPackets,
						solventUploadToReactionVesselPackets,
						solventTransferToReactionVesselPackets
					},

						(* -- To Preparation Container -- *)

						(* sample UploadSample *)
						sampleUploadToPrepContainerPackets = UploadSample[
							currentSampleComposition[[All, {1, 2}]],
							{"A1", preparationContainer},
							Simulation -> updatedSimulation,
							Upload -> False,
							SimulationMode -> True
						];

						(* sample UploadTransfer *)
						sampleTransferToPrepContainerPackets = UploadSampleTransfer[
							currentSample,
							First[sampleUploadToPrepContainerPackets],
							sampleAmount,
							Simulation -> updatedSimulation,
							Upload -> False
						];

						(* electrolyte UploadSample and UploadSampleTransfer *)
						{electrolyteUploadToPrepContainerPackets, electrolyteTransferToPrepContainerPackets} = If[
							MatchQ[electrolyte, ObjectP[Object[Sample]]],

							(* If electrolyte is a sample object, we continue *)
							Module[{electrolyteModel, uploadPackets, transferPackets},

								(* Get the internal Standard model *)
								electrolyteModel = Lookup[fetchPacketFromCache[electrolyte, electrolytePackets], Model] /. {x:ObjectP[]:>Download[x, Object]};

								(* Call UploadSample *)
								uploadPackets = UploadSample[
									electrolyteModel,
									{"A1", preparationContainer},
									Simulation -> updatedSimulation,
									Upload -> False,
									SimulationMode -> True
								];

								(* Call UploadSampleTransfer *)
								transferPackets = UploadSampleTransfer[
									electrolyte,
									First[uploadPackets],
									electrolyteAmount,
									Simulation -> updatedSimulation,
									Upload -> False
								];

								(* Return the packets *)
								{uploadPackets, transferPackets}
							],

							(* If internal standard is not a sample object or addition order is not after, return Nothing *)
							{Hold[Nothing], Hold[Nothing]}
						];

						(* solvent UploadSample and UploadSampleTransfer *)
						{solventUploadToPrepContainerPackets, solventTransferToPrepContainerPackets} = If[
							MatchQ[solvent, ObjectP[Object[Sample]]],

							(* If solvent is a sample object, we continue *)
							Module[{solventModel, uploadPackets, transferPackets},

								(* Get the internal Standard model *)
								solventModel = Lookup[fetchPacketFromCache[solvent, solventPackets], Model] /. {x:ObjectP[]:>Download[x, Object]};

								(* Call UploadSample *)
								uploadPackets = UploadSample[
									solventModel,
									{"A1", preparationContainer},
									Simulation -> updatedSimulation,
									Upload -> False,
									SimulationMode -> True
								];

								(* Call UploadSampleTransfer *)
								transferPackets = UploadSampleTransfer[
									solvent,
									First[uploadPackets],
									solventVolume,
									Simulation -> updatedSimulation,
									Upload -> False
								];

								(* Return the packets *)
								{uploadPackets, transferPackets}
							],

							(* If internal standard is not a sample object or addition order is not after, return Nothing *)
							{Hold[Nothing], Hold[Nothing]}
						];

						(* NOTE: At this stage, we don't have internalStandard UploadSample and UploadSampleTransfer packets, since if addition order is before, the internal standard is already in the prepared sample and if the addition order is after, we add it directly to the reaction vessel *)

						(* -- To ReactionVessel -- *)

						(* sample UploadSample *)
						sampleUploadToReactionVesselPackets = UploadSample[
							currentSampleComposition[[All, {1, 2}]],
							{"A1", reactionVessel},
							Simulation -> updatedSimulation,
							Upload -> False,
							SimulationMode -> True
						];

						(* sample UploadTransfer *)
						sampleTransferToReactionVesselPackets = UploadSampleTransfer[
							First[sampleUploadToPrepContainerPackets],
							First[sampleUploadToReactionVesselPackets],
							SafeRound[sampleAmount * (loadingSampleVolume / solventVolume), 10^-1 Milligram],
							Simulation -> updatedSimulation,
							Upload -> False
						];

						(* electrolyte UploadSample and UploadSampleTransfer *)
						{electrolyteUploadToReactionVesselPackets, electrolyteTransferToReactionVesselPackets} = If[
							MatchQ[electrolyte, ObjectP[Object[Sample]]],

							(* If electrolyte is a sample object, we continue *)
							Module[{electrolyteModel, uploadPackets, transferPackets},

								(* Get the internal Standard model *)
								electrolyteModel = Lookup[fetchPacketFromCache[electrolyte, electrolytePackets], Model] /. {x:ObjectP[]:>Download[x, Object]};

								(* Call UploadSample *)
								uploadPackets = UploadSample[
									electrolyteModel,
									{"A1", reactionVessel},
									Simulation -> updatedSimulation,
									Upload -> False,
									SimulationMode -> True
								];

								(* Call UploadSampleTransfer *)
								transferPackets = UploadSampleTransfer[
									First[electrolyteUploadToPrepContainerPackets],
									First[uploadPackets],
									SafeRound[electrolyteAmount * (loadingSampleVolume / solventVolume), 10^-1 Milligram],
									Simulation -> updatedSimulation,
									Upload -> False
								];

								(* Return the packets *)
								{uploadPackets, transferPackets}
							],

							(* If internal standard is not a sample object or addition order is not after, return Nothing *)
							{Hold[Nothing], Hold[Nothing]}
						];

						(* internalStandard UploadSample and UploadSampleTransfer *)
						{standardUploadToReactionVesselPackets, standardTransferToReactionVesselPackets} = If[
							MatchQ[internalStandard, ObjectP[Object[Sample]]] && MatchQ[internalStandardAdditionOrder, After],

							(* If internal standard is a sample object and addition order is after, we continue *)
							Module[{standardModel, uploadPackets, transferPackets},

								(* Get the internal Standard model *)
								standardModel = Lookup[fetchPacketFromCache[internalStandard, internalStandardPackets], Model] /. {x:ObjectP[]:>Download[x, Object]};

								(* Call UploadSample *)
								uploadPackets = UploadSample[
									standardModel,
									{"A1", reactionVessel},
									Simulation -> updatedSimulation,
									Upload -> False,
									SimulationMode -> True
								];

								(* Call UploadSampleTransfer *)
								transferPackets = UploadSampleTransfer[
									internalStandard,
									First[uploadPackets],
									internalStandardAmount,
									Simulation -> updatedSimulation,
									Upload -> False
								];

								(* Return the packets *)
								{uploadPackets, transferPackets}
							],

							(* If internal standard is not a sample object or addition order is not after, return Nothing *)
							{Hold[Nothing], Hold[Nothing]}
						];

						(* solvent UploadSample and UploadSampleTransfer *)
						{solventUploadToReactionVesselPackets, solventTransferToReactionVesselPackets} = If[
							MatchQ[solvent, ObjectP[Object[Sample]]],

							(* If solvent is a sample object, we continue *)
							Module[{solventModel, uploadPackets, transferPackets},

								(* Get the internal Standard model *)
								solventModel = Lookup[fetchPacketFromCache[solvent, solventPackets], Model] /. {x:ObjectP[]:>Download[x, Object]};

								(* Call UploadSample *)
								uploadPackets = UploadSample[
									solventModel,
									{"A1", reactionVessel},
									Simulation -> updatedSimulation,
									Upload -> False,
									SimulationMode -> True
								];

								(* Call UploadSampleTransfer *)
								transferPackets = UploadSampleTransfer[
									First[solventUploadToPrepContainerPackets],
									First[uploadPackets],
									loadingSampleVolume,
									Simulation -> updatedSimulation,
									Upload -> False
								];

								(* Return the packets *)
								{uploadPackets, transferPackets}
							],

							(* If internal standard is not a sample object or addition order is not after, return Nothing *)
							{Hold[Nothing], Hold[Nothing]}
						];

						(* return all the packets *)
						ReleaseHold[{
							sampleUploadToPrepContainerPackets,
							sampleTransferToPrepContainerPackets,
							electrolyteUploadToPrepContainerPackets,
							electrolyteTransferToPrepContainerPackets,
							solventUploadToPrepContainerPackets,
							solventTransferToPrepContainerPackets,

							sampleUploadToReactionVesselPackets,
							sampleTransferToReactionVesselPackets,
							electrolyteUploadToReactionVesselPackets,
							electrolyteTransferToReactionVesselPackets,
							standardUploadToReactionVesselPackets,
							standardTransferToReactionVesselPackets,
							solventUploadToReactionVesselPackets,
							solventTransferToReactionVesselPackets
						}]
					],

					(* If the current sample does need preparation, we only need to consider the sample into the reaction vessel *)
					Module[{
						sampleUploadToReactionVesselPackets,
						sampleTransferToReactionVesselPackets,
						standardUploadToReactionVesselPackets,
						standardTransferToReactionVesselPackets
					},

						(* sample UploadSample *)
						sampleUploadToReactionVesselPackets = UploadSample[
							currentSampleComposition[[All, {1, 2}]],
							{"A1", reactionVessel},
							Simulation -> updatedSimulation,
							Upload -> False,
							SimulationMode -> True
						];

						(* sample UploadTransfer *)
						sampleTransferToReactionVesselPackets = UploadSampleTransfer[
							currentSample,
							First[sampleUploadToReactionVesselPackets],
							loadingSampleVolume,
							Simulation -> updatedSimulation,
							Upload -> False
						];

						(* internalStandard UploadSample and UploadSampleTransfer *)
						{standardUploadToReactionVesselPackets, standardTransferToReactionVesselPackets} = If[
							MatchQ[internalStandard, ObjectP[Object[Sample]]] && MatchQ[internalStandardAdditionOrder, After],

							(* If internal standard is a sample object and addition order is after, we continue *)
							Module[{standardModel, uploadPackets, transferPackets},

								(* Get the internal Standard model *)
								standardModel = Lookup[fetchPacketFromCache[internalStandard, internalStandardPackets], Model] /. {x:ObjectP[]:>Download[x, Object]};

								(* Call UploadSample *)
								uploadPackets = UploadSample[
									standardModel,
									{"A1", reactionVessel},
									Simulation -> updatedSimulation,
									Upload -> False,
									SimulationMode -> True
								];

								(* Call UploadSampleTransfer *)
								transferPackets = UploadSampleTransfer[
									internalStandard,
									First[uploadPackets],
									internalStandardAmount,
									Simulation -> updatedSimulation,
									Upload -> False
								];

								(* Return the packets *)
								{uploadPackets, transferPackets}
							],

							(* If internal standard is not a sample object or addition order is not after, return Nothing *)
							{Hold[Nothing], Hold[Nothing]}
						];

						(* return all the packets *)
						ReleaseHold[{
							sampleUploadToReactionVesselPackets,
							sampleTransferToReactionVesselPackets,
							standardUploadToReactionVesselPackets,
							standardTransferToReactionVesselPackets
						}]
					]
				]
			]
		],
		{sampleDilutions, reactionVessels, loadingSamplePreparationContainers, samplesIn, expandedWorkingSamples, solidSampleAmounts, electrolytes, electrolyteAmounts, internalStandards, internalStandardAdditionOrders, internalStandardAmounts, solvents, solventVolumes, loadingSampleVolumes}
	]];

	(* Update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[loadingSamplePreparationPackets]];

	(* -- ElectrolyteSolution Transfer into Pretreatment ReactionVessels -- *)
	electrolyteSolutionTransferPackets = If[!MatchQ[electrolyteSolutions, (Null | {} | {Null..})],
		(* If we have any electrolyteSolutions, continue *)
		Flatten[MapThread[
			Function[{electrolyteSolution, electrolyteSolutionVolume, pretreatmentReactionVessel},
				If[MatchQ[electrolyteSolution, ObjectP[Object[Sample]]],
					Module[{electrolyteSolutionModel, uploadPackets, transferPackets},

						(* Find out the electrolyte solution model *)
						electrolyteSolutionModel = (Lookup[fetchPacketFromCache[electrolyteSolution, electrolyteSolutionPackets], Model]) /. {x:ObjectP[]:>Download[x, Object]};

						(* electrolyteSolutions UploadSample *)
						uploadPackets = UploadSample[
							electrolyteSolutionModel,
							{"A1", pretreatmentReactionVessel},
							Simulation -> updatedSimulation,
							Upload -> False,
							SimulationMode -> True
						];

						(* electrolyteSolutions UploadSampleTransfer *)
						transferPackets = UploadSampleTransfer[
							electrolyteSolution,
							First[uploadPackets],
							electrolyteSolutionVolume,
							Simulation -> updatedSimulation,
							Upload -> False
						];

						(* Return the results *)
						{uploadPackets, transferPackets}
					],

					(* If we do not have an electrolyte solution, return Nothing *)
					Nothing
				]
			],
			{electrolyteSolutions, electrolyteSolutionLoadingVolumes, pretreatmentReactionVessels}
		]],

		(* If we are not transferring the electrolyteSolutions into the reactionVessels, return {} *)
		{}
	];

	(* Update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[electrolyteSolutionTransferPackets]];

	(* -- WorkingElectrodeSonicationSolvent Transfer into WorkingElectrodeSonicationContainer -- *)
	sonicationSolventTransferPackets = If[MatchQ[sonicationContainer, ObjectP[Object[Container]]],

		(* If we are doing the working electrode sonication, continue *)
		Module[{sonicationSolventModel, uploadPackets, transferPackets},
			(* Find out the sonication solvent model *)
			sonicationSolventModel = (Lookup[fetchPacketFromCache[sonicationSolvent, ToList[sonicationSolventPacket]], Model]) /. {x:ObjectP[]:>Download[x, Object]};

			(* electrolyteSolutions UploadSample *)
			uploadPackets = UploadSample[
				sonicationSolventModel,
				{"A1", sonicationContainer},
				Simulation -> updatedSimulation,
				Upload -> False,
				SimulationMode -> True
			];

			(* electrolyteSolutions UploadSampleTransfer *)
			transferPackets = UploadSampleTransfer[
				sonicationSolvent,
				First[uploadPackets],
				sonicationSolventVolume,
				Simulation -> updatedSimulation,
				Upload -> False
			];

			(* Return the results *)
			Flatten[{uploadPackets, transferPackets}]
		],

		(* If we are not doing the working electrode sonication, return {} *)
		{}
	];

	(* Update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[sonicationSolventTransferPackets]];

	(* -- Solvents Transfer into PreBubblers -- *)
	preBubblerSolventTransferPackets = If[
		MatchQ[uniquePreBubblers, {ObjectP[Object[Container, Vessel, GasWashingBottle]]..}],

		(* If we have unique pre-bubblers, we are using prebubbler for at least one sample, we continue *)
		Flatten[MapThread[
			Function[{preBubbler, preBubblerSolvent, preBubblerSolventVolume},
				If[MatchQ[preBubblerSolvent, ObjectP[Object[Sample]]],
					Module[{preBubblerSolventModel, uploadPackets, transferPackets},

						(* Find out the preBubblerSolvent model *)
						preBubblerSolventModel = (Lookup[fetchPacketFromCache[preBubblerSolvent, preBubblerSolventPackets], Model]) /. {x:ObjectP[]:>Download[x, Object]};

						(* electrolyteSolutions UploadSample *)
						uploadPackets = UploadSample[
							preBubblerSolventModel,
							{"A1", preBubbler},
							Simulation -> updatedSimulation,
							Upload -> False,
							SimulationMode -> True
						];

						(* electrolyteSolutions UploadSampleTransfer *)
						transferPackets = UploadSampleTransfer[
							preBubblerSolvent,
							First[uploadPackets],
							preBubblerSolventVolume,
							Simulation -> updatedSimulation,
							Upload -> False
						];

						(* Return the results *)
						{uploadPackets, transferPackets}
					],

					(* If we do not have an electrolyte solution, return Nothing *)
					Nothing
				]
			],
			{uniquePreBubblers, uniquePreBubblerSolvents, uniquePreBubblerSolventLoadingVolumes}
		]],

		(* If we do not have any unique pre-bubblers, return {} *)
		{}
	];

	(* Update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[preBubblerSolventTransferPackets]];

	(* === Parser Corresponding Changes (except data collection) === *)

	(* -- WashingSolutions -> WashingSolutionsCollectionContainers -- *)
	(* Lookup washing solution models from washingSolutionPackets *)
	washingSolutionModels = uniqueElectrodeWashingSolutions;

	(* Get how many unique washing solutions we are dealing with *)
	numberOfUniqueWashingSolutionModels = Length[washingSolutionModels];

	(* Gather UploadSample packets *)
	washingSolutionUploadSamplePackets = If[MatchQ[washingSolutionModels, {ObjectP[Model[Sample]]..}],
		(* If we have any washing solutions, we gather the UploadSample packets *)
		UploadSample[
			washingSolutionModels,
			Transpose[{ConstantArray["A1", numberOfUniqueWashingSolutionModels], washingSolutionsCollectionContainers}],
			InitialAmount -> uniqueElectrodeWashingSolutionVolumes,
			Simulation -> updatedSimulation,
			Upload -> False,
			SimulationMode -> True
		],

		(* Otherwise, we return an empty list *)
		{}
	];

	(* Update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[washingSolutionUploadSamplePackets]];

	(* -- PolishingSolutions -> WashingSolutionsCollectionContainers -- *)
	(* Lookup polishing solution models from polishingSolutionPackets *)
	polishingSolutionModels = (Lookup[fetchPacketFromCache[#, polishingSolutionPackets], Model]&/@uniquePolishingSolutions) /. {x:ObjectP[]:>Download[x, Object]};

	(* Get how many unique polishing solutions we are dealing with *)
	numberOfUniquePolishingSolutionModels = Length[polishingSolutionModels];

	(* Gather UploadSample packets *)
	polishingSolutionUploadSamplePackets = If[MatchQ[polishingSolutionModels, {ObjectP[Model[Sample]]..}],
		(* If we have any polishing solutions, we gather the UploadSample packets *)
		UploadSample[
			polishingSolutionModels,

			(* Here, we transfer all the polishing solutions into the washing water collection container *)
			ConstantArray[{"A1", First[washingSolutionsCollectionContainers]}, numberOfUniquePolishingSolutionModels],
			Simulation -> updatedSimulation,
			Upload -> False,
			SimulationMode -> True
		],

		(* Otherwise, we return Null *)
		Null
	];

	(* Update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[polishingSolutionUploadSamplePackets]];

	(* We need to get out the first numberOfUniqueWashingSolutionModels packets of the washingSolutionUploadSamplePackets for the later UploadSampleTransfer Call *)
	polishingSolutionPacketsForUploadSampleTransfer = If[MatchQ[polishingSolutionUploadSamplePackets, {PacketP[]..}],

		(* The first numberOfUniqueWashingSolutions packets are for UploadSampleTransfer *)
		Take[polishingSolutionUploadSamplePackets, numberOfUniquePolishingSolutionModels],
		{}
	];

	(* Get UploadSampleTransfer packets *)
	polishingSolutionUploadSampleTransferPackets = If[MatchQ[polishingSolutionPacketsForUploadSampleTransfer, {PacketP[]..}],
		UploadSampleTransfer[
			uniquePolishingSolutions,
			polishingSolutionPacketsForUploadSampleTransfer,
			uniquePolishingSolutionVolumes,
			Upload -> False,
			Simulation -> updatedSimulation,
			UpdatedBy -> protocolObject
		],
		{}
	];

	(* Update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[polishingSolutionUploadSampleTransferPackets]];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the SamplesIn field *)
	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], mySamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], Lookup[samplePackets, Container]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields->Join[
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			]
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[updatedSimulation, simulationWithLabels]
	}
];

(* ====================== *)
(* == Sister Functions == *)
(* ====================== *)
(* ::Subsubsection::Closed:: *)
(*ExperimentCyclicVoltammetryOptions*)

DefineOptions[ExperimentCyclicVoltammetryOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
			Description->"Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentCyclicVoltammetry}
];

ExperimentCyclicVoltammetryOptions[
	myInput:ListableP[ObjectP[{Object[Sample],Object[Container], Model[Sample]}]|_String],
	myOptions:OptionsPattern[ExperimentCyclicVoltammetryOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	listedOptions=ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentCyclicVoltammetry[myInput,preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentCyclicVoltammetry],
		resolvedOptions
	]
];

(* ::Subsubsection::Closed:: *)
(*ExperimentCyclicVoltammetryPreview*)

DefineOptions[ExperimentCyclicVoltammetryPreview,
	SharedOptions :> {ExperimentCyclicVoltammetry}
];

ExperimentCyclicVoltammetryPreview[
	myInput:ListableP[ObjectP[{Object[Sample],Object[Container], Model[Sample]}]|_String],
	myOptions:OptionsPattern[ExperimentCyclicVoltammetryPreview]
]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentCyclicVoltammetry[myInput,ReplaceRule[listedOptions,Output->Preview]]
];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentCyclicVoltammetryQ*)

DefineOptions[ValidExperimentCyclicVoltammetryQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentCyclicVoltammetry}
];

ValidExperimentCyclicVoltammetryQ[
	myInput:ListableP[ObjectP[{Object[Sample],Object[Container], Model[Sample]}]|_String],
	myOptions:OptionsPattern[ValidExperimentCyclicVoltammetryQ]
]:=Module[
	{listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

	listedInput=ToList[myInput];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ExperimentCyclicVoltammetry[myInput,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[listedInput,_String],OutputFormat->Boolean];
			voqWarnings=MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{DeleteCases[listedInput,_String],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[{initialTest},functionTests,voqWarnings]
		]
	];

	(* Lookup test running options *)
	safeOps=SafeOptions[ValidExperimentCyclicVoltammetryQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentCyclicVoltammetry"->allTests|>,
			Verbose->verbose,
			OutputFormat->outputFormat
		],
		"ExperimentCyclicVoltammetry"
	]
];


(* ========================================= *)
(* == cyclicVoltammetrySampleTests HELPER == *)
(* ========================================= *)

(* Conditionally returns appropriate tests based on the number of failing samples and the gather tests boolean
	Inputs:
		testFlag - Indicates if we should actually make tests
		allSamples - The input samples
		badSamples - Samples which are invalid in some way
		testDescription - A description of the sample invalidity check
			- must be formatted as a template with an `1` which can be replaced by a list of samples or "all input samples"
	Outputs:
		out: {(_Test|_Warning)...} - Tests for the good and bad samples - if all samples fall in one category, only one test is returned *)

cyclicVoltammetrySampleTests[testFlag:False,testHead:(Test|Warning),allSamples_,badSamples_,testDescription_,cache_]:={};

cyclicVoltammetrySampleTests[testFlag:True,testHead:(Test|Warning),allSamples:{PacketP[]..},badSamples:{PacketP[]...},testDescription_String,cache_]:=Module[{
	numberOfSamples,numberOfBadSamples,allSampleObjects,badObjects,goodObjects},

	(* Convert packets to objects *)
	allSampleObjects=Lookup[allSamples,Object];
	badObjects=Lookup[badSamples,Object,{}];

	(* Determine how many of each sample we have - delete duplicates in case one of sample sets was sent to us with duplicates removed *)
	numberOfSamples=Length[DeleteDuplicates[allSampleObjects]];
	numberOfBadSamples=Length[DeleteDuplicates[badObjects]];

	(* Get a list of objects which are okay *)
	goodObjects=Complement[allSampleObjects,badObjects];

	Which[
		(* All samples are okay *)
		MatchQ[numberOfBadSamples,0],{testHead[StringTemplate[testDescription]["all input samples"],True,True]},

		(* All samples are bad *)
		MatchQ[numberOfBadSamples,numberOfSamples],{testHead[StringTemplate[testDescription]["all input samples"],False,True]},

		(* Mixed samples *)
		True,
		{
			(* Passing Test *)
			testHead[StringTemplate[testDescription][ObjectToString[goodObjects,Cache->cache]],True,True],
			(* Failing Test *)
			testHead[StringTemplate[testDescription][ObjectToString[badObjects,Cache->cache]],False,True]
		}
	]
];

(* ============================ *)
(* == getSampleAmount HELPER == *)
(* ============================ *)

(* Using input of solvent volume, target concentration, analyte molecular weight, and sample analyte MassPercent to generate the matching sample amount *)

getSampleAmount[mySolventVolume:VolumeP, mySample:ObjectP[{Model[Sample], Object[Sample]}], myTargetConcentration:Alternatives[ConcentrationP, MassConcentrationP], myMolecule:ObjectP[Model[Molecule]],myAmountUnit:_?MassQ, myCache:{PacketP[]..}]:=Module[
	{
		molecularWeight,
		sampleComposition,
		moleculeCompositionEntry,
		massPercent,
		numericalMassPercent,
		targetConcentrationInMassConcentration,
		analyteAmount,
		sampleAmount
	},

	molecularWeight = Lookup[fetchPacketFromCache[myMolecule, myCache], MolecularWeight];

	sampleComposition = Lookup[fetchPacketFromCache[mySample, myCache], Composition];

	moleculeCompositionEntry = Select[sampleComposition, MatchQ[Download[#[[2]], Object, Cache -> myCache], myMolecule]&];

	massPercent = First[Flatten[moleculeCompositionEntry]];

	(* strip the unit of mySampleAnalyteMassPercent and change the number into the range of [0, 1] *)
	numericalMassPercent = QuantityMagnitude[massPercent]/100;

	(* Convert the input target concentration into Milligram/Milliliter *)
	targetConcentrationInMassConcentration = If[MatchQ[myTargetConcentration, ConcentrationP],
		(* If target concentration is in Molar, we transform it into MassConcentration with molecular weight *)
		UnitConvert[myTargetConcentration * molecularWeight, Milligram/Milliliter],

		(* Otherwise we output the target concentration with the right unit directly *)
		UnitConvert[myTargetConcentration, Milligram/Milliliter]
	];

	(* Get the analyte amount *)
	analyteAmount = targetConcentrationInMassConcentration * UnitConvert[mySolventVolume, Milliliter];

	(* Get the sample amount *)
	sampleAmount = SafeRound[UnitConvert[analyteAmount / numericalMassPercent, myAmountUnit], 10^-1 Milligram]
];

(* A function reload to prevent accidental massive output of the cache *)
getSampleAmount[mySolventVolume_, mySample_, myTargetConcentration_, myMolecule_, myAmountUnit_, myCache_]:= Null;

(* =================================== *)
(* == getTargetConcentration HELPER == *)
(* =================================== *)

(* Using input of solvent volume, sample amount, analyte molecular weight, and sample analyte MassPercent to generate the matching sample target concentration *)

getTargetConcentration[mySolventVolume:VolumeP, mySample:ObjectP[{Model[Sample], Object[Sample]}], mySampleAmount:MassP, myMolecule:ObjectP[Model[Molecule]], myConcentrationUnit:Alternatives[_?ConcentrationQ, _?MassConcentrationQ], myCache:{PacketP[]..}]:=Module[
	{
		molecularWeight,
		sampleComposition,
		moleculeCompositionEntry,
		massPercent,
		numericalMassPercent,
		sampleAmountInMilligram,
		analyteAmount,
		moleAmount,
		targetConcentration
	},

	molecularWeight = Lookup[fetchPacketFromCache[myMolecule, myCache], MolecularWeight];

	sampleComposition = Lookup[fetchPacketFromCache[mySample, myCache], Composition];

	moleculeCompositionEntry = Select[sampleComposition, MatchQ[Download[#[[2]], Object, Cache -> myCache], myMolecule]&];

	massPercent = First[Flatten[moleculeCompositionEntry]];

	(* strip the unit of mySampleAnalyteMassPercent and change the number into the range of[0,1] *)
	numericalMassPercent = QuantityMagnitude[massPercent]/100;

	(* Convert the input sample amount into Milligram unit *)
	sampleAmountInMilligram = UnitConvert[mySampleAmount, Milligram];

	(* Get the corresponding analyte amount *)
	analyteAmount = sampleAmountInMilligram * numericalMassPercent;

	(* Get the target concentration *)
	targetConcentration = If[MatchQ[myConcentrationUnit, _?MassConcentrationQ],
		(* If the requested targetConcentration is in MassConcentration units, we can directly get the target concentration *)
		SafeRound[UnitConvert[analyteAmount / mySolventVolume, myConcentrationUnit], 10^-1 Milligram/Liter],

		(* If the requested targetConcentration is in Molar units, we use the MolecularWeight to transform it *)
		moleAmount = analyteAmount / molecularWeight;
		SafeRound[UnitConvert[moleAmount / mySolventVolume, myConcentrationUnit], 10^-1 Millimolar]
	]
];

(* A function reload to prevent accidental massive output of the cache *)
getTargetConcentration[mySolventVolume_, mySample_, mySampleAmount_, myMolecule_, myConcentrationUnit_, myCache_]:= Null;

(* ================================================== *)
(* == sampleAmountTargetConcentrationMatchQ HELPER == *)
(* ================================================== *)

(* Using input of solvent volume, sample amount, target concentration, analyte molecular weight, and sample analyte MassPercent to check if sample amount and target concentration agree with each other *)

sampleAmountTargetConcentrationMatchQ[mySolventVolume:VolumeP, mySample:ObjectP[{Model[Sample], Object[Sample]}], mySampleAmount:MassP, myTargetConcentration:Alternatives[ConcentrationP,MassConcentrationP], myMolecule:ObjectP[Model[Molecule]], myCache:{PacketP[]..}]:=Module[
	{
		molecularWeight,
		sampleComposition,
		moleculeCompositionEntry,
		massPercent,
		numericalMassPercent,
		sampleAmountInMilligram,
		analyteAmount,
		analyteAmountFromConcentration,
		targetConcentrationInMassConcentration
	},

	molecularWeight = Lookup[fetchPacketFromCache[myMolecule, myCache], MolecularWeight];

	sampleComposition = Lookup[fetchPacketFromCache[mySample, myCache], Composition];

	moleculeCompositionEntry = Select[sampleComposition, MatchQ[Download[#[[2]], Object, Cache -> myCache], myMolecule]&];

	massPercent = First[Flatten[moleculeCompositionEntry]];

	(* strip the unit of mySampleAnalyteMassPercent and change the number into the range of[0,1] *)
	numericalMassPercent = QuantityMagnitude[massPercent]/100;

	(* Convert the input sample amount into Milligram unit *)
	sampleAmountInMilligram = UnitConvert[mySampleAmount, Milligram];

	(* Get the corresponding analyte amount *)
	analyteAmount = sampleAmountInMilligram * numericalMassPercent;

	(* Get corresponding analyte amount from target concentration *)
	analyteAmountFromConcentration = If[MatchQ[myTargetConcentration, MassConcentrationP],
		(* If the target concentration is in mass concentration units, we can directly get the corresponding analyte amount *)
		UnitConvert[myTargetConcentration * mySolventVolume, Milligram],

		(* If the target concentration is in molar concentration units, we need to transform it into MassConcentration first *)
		targetConcentrationInMassConcentration = myTargetConcentration * molecularWeight;
		UnitConvert[targetConcentrationInMassConcentration * mySolventVolume, Milligram]
	];

	LessQ[Abs[analyteAmount - analyteAmountFromConcentration], 10^-1 Milligram]
];

(* A function reload to prevent accidental massive output of the cache *)
sampleAmountTargetConcentrationMatchQ[mySolventVolume_, mySample_, mySampleAmount_, myTargetConcentration_, myMolecule_, myCache_]:= Null;

(* ============================== *)
(* == getSampleMolecule HELPER == *)
(* ============================== *)

(* Get the molecule of interest from a sample Model or Object. If there are more than one non-Null molecule in the sample composition, return the molecule as Null and an ambiguousMolecule error *)

getSampleMolecule[mySample:ObjectP[{Model[Sample], Object[Sample]}], myCache:{PacketP[]..}]:=Module[
	{
		composition,
		candidateMolecules,
		molecule,
		ambiguousMoleculeBool
	},

	(* get the composition field of mySample *)
	composition = Lookup[fetchPacketFromCache[mySample, myCache], Composition];

	(* Get all the non-Null molecules *)
	candidateMolecules = Select[composition[[All, 2]], !MatchQ[#, Null]&];

	(* If there is only one non-Null molecule, that is the molecule of interest *)
	{molecule, ambiguousMoleculeBool} = If[MatchQ[Length[candidateMolecules], 1],
		{Download[First[candidateMolecules], Object, Cache -> myCache], False},

		(* Otherwise we can't obtain the molecule *)
		{Null, True}
	];

	{
		molecule,
		ambiguousMoleculeBool
	}
];

(* A function reload to prevent accidental massive output of the cache *)
getSampleMolecule[mySample_, myCache_] := Null;

(* ============================================== *)
(* == getMoleculeCompositionInformation HELPER == *)
(* ============================================== *)

(* Get composition information of the molecule of interest from a sample Model or Object. If the target molecule is not the sample's composition field, an error will be returned. *)

getMoleculeCompositionInformation[mySample:ObjectP[{Model[Sample], Object[Sample]}], myMolecule:ObjectP[Model[Molecule]], myCache:{PacketP[]..}]:=Module[
	{
		moleculeMolecularWeight,
		composition,
		moleculeCompositionEntry,
		moleculeConcentration,
		moleculeConcentrationInMillimolar,
		moleculeConcentrationInMilligramPerMilliliter,
		moleculeMissingMolecularWeightBool,
		moleculeNotFoundBool,
		ambiguousMoleculeBool,
		moleculeWithUnresolvableCompositionUnitBool
	},

	(* get the molecularWeight *)
	moleculeMolecularWeight = Lookup[fetchPacketFromCache[myMolecule, myCache], MolecularWeight];

	(* If moleculeMolecularWeight is Null, we set moleculeMissingMolecularWeightBool to True *)
	moleculeMissingMolecularWeightBool = If[!MatchQ[moleculeMolecularWeight, MolecularWeightP],
		True,
		False
	];

	(* get the composition field of mySample *)
	(* Note: the 3rd element of composition is time, it is not relevant here. *)
	composition = Lookup[fetchPacketFromCache[mySample, myCache], Composition][[All, {1, 2}]];

	(* Get all the entries non-Null molecules *)
	moleculeCompositionEntry = Select[composition, MatchQ[Download[Last[#], Object, Cache -> myCache], myMolecule]&];

	(* If moleculeCompositionEntry has a length of 0, we set moleculeNotFoundBool to True *)
	moleculeNotFoundBool = If[MatchQ[Length[moleculeCompositionEntry], 0],
		True,
		False
	];

	(* If moleculeCompositionEntry has a length greater than 1, we set ambiguousMoleculeBool to True *)
	ambiguousMoleculeBool = If[GreaterQ[Length[moleculeCompositionEntry], 1],
		True,
		False
	];

	(* fetch the concentration of the molecule from the composition field if the previous two errors are not encountered. *)
	moleculeConcentration = If[MatchQ[moleculeNotFoundBool, False] && MatchQ[ambiguousMoleculeBool, False],
		First[Flatten[moleculeCompositionEntry]],

		(* Otherwise we set this to Null *)
		Null
	];

	(* If moleculeConcentration is not in molar units or mass concentration units, we set moleculeWithUnresolvableCompositionUnitBool to True *)
	moleculeWithUnresolvableCompositionUnitBool = If[
		And[
			MatchQ[moleculeNotFoundBool, False],
			MatchQ[ambiguousMoleculeBool, False],
			!MatchQ[moleculeConcentration, Alternatives[ConcentrationP, MassConcentrationP]]
		],
		True,
		False
	];
	(* If moleculeConcentration is MassConcentration or molar Concentration, we can calculate the moleculeConcentrationInMillimolar and moleculeConcentrationInMilligramPerMilliliter *)
	{moleculeConcentrationInMillimolar, moleculeConcentrationInMilligramPerMilliliter} = Which[
		MatchQ[moleculeConcentration, ConcentrationP],
		(* If moleculeConcentration is in molar units *)
		(* Check to make sure MolecularWeightExists. If not, return Null where the MW is needed. *)
		If[moleculeMissingMolecularWeightBool,
			{UnitConvert[moleculeConcentration, Millimolar], Null},
			{UnitConvert[moleculeConcentration, Millimolar], UnitConvert[moleculeConcentration * moleculeMolecularWeight, Milligram/Milliliter]}
		],
		MatchQ[moleculeConcentration, MassConcentrationP],
		(* If moleculeConcentration is in mass concentration units *)
		(* Check to make sure MolecularWeightExists. If not, return Null where the MW is needed. *)
		If[moleculeMissingMolecularWeightBool,
			{Null, UnitConvert[moleculeConcentration, Milligram/Milliliter]},
			{UnitConvert[moleculeConcentration / moleculeMolecularWeight, Millimolar], UnitConvert[moleculeConcentration, Milligram/Milliliter]}
		],
		True,
		(* Otherwise, we set both of them to Null *)
		{Null, Null}
	];

	{
		SafeRound[moleculeConcentrationInMillimolar, 10^-1 Millimolar],
		SafeRound[moleculeConcentrationInMilligramPerMilliliter, 10^-1 Milligram / Liter],
		moleculeMissingMolecularWeightBool,
		moleculeNotFoundBool,
		ambiguousMoleculeBool,
		moleculeWithUnresolvableCompositionUnitBool
	}
];

(* A function reload to prevent accidental massive output of the cache *)
getMoleculeCompositionInformation[mySample_, myMolecule_, myCache_] := Null;

(* ============================================================ *)
(* == getLastMoleculeInformationFromSampleComposition HELPER == *)
(* ============================================================ *)

(* Get composition information of the last un-identified entry of a sample Model or Object. If the last molecule has a composition unit that is not in molar units or mass concentration units, a moleculeWithUnresolvableCompositionUnit error will be returned. If the last molecule does not have a MolecularWeight, a moleculeMissingMolecularWeight error will be returned*)

getLastMoleculeInformationFromSampleComposition[mySample:ObjectP[{Model[Sample], Object[Sample]}], myKnownMolecules:{ObjectP[Model[Molecule]]..}, myCache:{PacketP[]..}]:=Module[
	{
		composition,
		moleculeCompositionEntry,
		lastMolecule,
		moleculeMolecularWeight,
		moleculeConcentration,
		moleculeConcentrationInMillimolar,
		moleculeConcentrationInMilligramPerMilliliter,
		moleculeMissingMolecularWeightBool,
		moleculeWithUnresolvableCompositionUnitBool
	},

	(* get the composition field of mySample *)
	(* Note: the 3rd element of composition is time, it is not relevant here. *)
	composition = Lookup[fetchPacketFromCache[mySample, myCache], Composition][[All, {1, 2}]];

	(* Get all the entries non-Null molecules *)
	moleculeCompositionEntry = Select[composition, !MatchQ[Download[Last[#], Object, Cache -> myCache], Alternatives[Sequence@@myKnownMolecules, Null]]&];

	(* get the last molecule *)
	lastMolecule = If[MatchQ[Length[moleculeCompositionEntry], 1],

		(* If there is only one entry last, that is the molecule entry we want *)
		Download[Last[Flatten[moleculeCompositionEntry]], Object, Cache -> myCache],

		(* Otherwise we can't get the last molecule *)
		Null
	];

	(* get the molecularWeight *)
	moleculeMolecularWeight = If[MatchQ[lastMolecule, ObjectP[Model[Molecule]]],

		(* If we can get the last molecule, we try to get its MolecularWeight *)
		Lookup[fetchPacketFromCache[lastMolecule, myCache], MolecularWeight],

		(* Otherwise we set this to Null *)
		Null
	];

	(* If lastMolecule is not Null and moleculeMolecularWeight is Null, we set moleculeMissingMolecularWeightBool to True *)
	moleculeMissingMolecularWeightBool = If[MatchQ[lastMolecule, ObjectP[Model[Molecule]]] && !MatchQ[moleculeMolecularWeight, MolecularWeightP],
		True,
		False
	];

	(* If lastMolecule is not Null, we get its concentration. *)
	moleculeConcentration = If[MatchQ[lastMolecule, ObjectP[Model[Molecule]]],
		First[Flatten[moleculeCompositionEntry]],

		(* Otherwise we set this to Null *)
		Null
	];

	(* If moleculeConcentration is not in molar units or mass concentration units, we set moleculeWithUnresolvableCompositionUnitBool to True *)
	moleculeWithUnresolvableCompositionUnitBool = If[MatchQ[lastMolecule, ObjectP[Model[Molecule]]] && !MatchQ[moleculeConcentration, Alternatives[ConcentrationP, MassConcentrationP]],
		True,
		False
	];

	(* If moleculeConcentration is MassConcentration or molar Concentration, we can calculate the moleculeConcentrationInMillimolar and moleculeConcentrationInMilligramPerMilliliter *)
	{moleculeConcentrationInMillimolar, moleculeConcentrationInMilligramPerMilliliter} = Which[
		MatchQ[moleculeConcentration, ConcentrationP],
		(* If moleculeConcentration is in molar units *)
		(* Check to make sure MolecularWeightExists. If not, return Null where the MW is needed. *)
		If[moleculeMissingMolecularWeightBool,
			{UnitConvert[moleculeConcentration, Millimolar], Null},
			{UnitConvert[moleculeConcentration, Millimolar], UnitConvert[moleculeConcentration * moleculeMolecularWeight, Milligram/Milliliter]}
		],
		MatchQ[moleculeConcentration, MassConcentrationP],
		(* If moleculeConcentration is in mass concentration units *)
		(* Check to make sure MolecularWeightExists. If not, return Null where the MW is needed. *)
		If[moleculeMissingMolecularWeightBool,
			{Null, UnitConvert[moleculeConcentration, Milligram/Milliliter]},
			{UnitConvert[moleculeConcentration / moleculeMolecularWeight, Millimolar], UnitConvert[moleculeConcentration, Milligram/Milliliter]}
		],
		True,
		(* Otherwise, we set both of them to Null *)
		{Null, Null}
	];

	{
		lastMolecule,
		SafeRound[moleculeConcentrationInMillimolar, 10^-1 Millimolar],
		SafeRound[moleculeConcentrationInMilligramPerMilliliter, 10^-1 Milligram / Liter],
		moleculeMissingMolecularWeightBool,
		moleculeWithUnresolvableCompositionUnitBool
	}
];

(* A function reload to prevent accidental massive output of the cache *)
getLastMoleculeInformationFromSampleComposition[mySample_, myKnownMolecules_, myCache_]:=Null;

(* =================================== *)
(* == getSolutionInformation HELPER == *)
(* =================================== *)

(* Get solvent, analyte, and possible electrolyte information from an input solution sample. Several error tracking booleans will also be returned. *)

getSolutionInformation[mySolution:ObjectP[{Model[Sample], Object[Sample]}], myCache:{PacketP[]..}] := Module[
	{
		compositionField,
		compositionMoleculeList,
		solventField,
		solvent,
		solventMolecule,
		analyteField,
		analyteList,
		analyteMolecule,
		analyteMoleculeConcentration,
		thirdMolecule,
		thirdMoleculeConcentration,
		electrolyteMolecule,
		electrolyteMoleculeConcentration,

		(* Error booleans *)
		solutionMissingSolventBool,
		solutionMissingAnalyteBool,
		solutionAmbiguousAnalyteBool,
		solventMoleculeMissingDefaultSampleModelBool,
		solventSampleAmbiguousMoleculeBool,
		solutionDoesNotHaveThirdMoleculeBool,
		cannotDetermineThirdMoleculeBool,
		fetchErrors
	},

	(* -- Get basic information -- *)

	(* Get the solution composition field *)
	(* Note: if either Model[Sample] or Object[Sample] has an entry of composition without identity model, remove that entry *)
	compositionField = Lookup[fetchPacketFromCache[mySolution, myCache], Composition] /. {{_, Null, _} -> Nothing, {_, Null} -> Nothing};

	(* Get the composition molecules *)
	compositionMoleculeList = Download[compositionField[[All, 2]], Object, Cache -> myCache];

	(* Get the solvent field *)
	solventField = Lookup[fetchPacketFromCache[mySolution, myCache], Solvent] /. {{_, Null} -> Nothing};

	(* Get the solvent *)
	solvent = Download[solventField, Object, Cache -> myCache];

	(* Get the analyte field *)
	analyteField = Lookup[fetchPacketFromCache[mySolution, myCache], Analytes] /. {Null -> Nothing};

	(* Get the analyteList *)
	analyteList = Download[analyteField, Object, Cache -> myCache];

	(* -- Solvent information -- *)
	(* If solventList is an empty list, set solutionMissingSolventBool to True *)
	solutionMissingSolventBool = If[NullQ[solvent],
		True,
		False
	];

	(* We try to get solventSample and solventMolecule from solventField *)
	If[MatchQ[solutionMissingSolventBool, False],

		(* If no errors are encountered, we check the first entry of solvent *)
		Module[{},
			solventMoleculeMissingDefaultSampleModelBool = False;
			{solventMolecule, solventSampleAmbiguousMoleculeBool} = getSampleMolecule[solvent, myCache];
		],

		(* If the previous error is encountered, we set solvent molecule to Null *)
		solventMolecule = Null;
		solventMoleculeMissingDefaultSampleModelBool = False;
		solventSampleAmbiguousMoleculeBool = False;
	];

	(* -- Analyte information -- *)
	(* If analyteList is an empty list, set solutionMissingAnalyteBool to True *)
	solutionMissingAnalyteBool = If[MatchQ[Length[analyteList], 0],
		True,
		False
	];

	(* If analyteList has more than one non-Null entries, set solutionAmbiguousAnalyteBool to True *)
	solutionAmbiguousAnalyteBool = If[GreaterQ[Length[analyteList], 1],
		True,
		False
	];

	(* Get analyteMolecule from analyteList *)
	analyteMolecule = If[MatchQ[solutionMissingAnalyteBool, False] && MatchQ[solutionAmbiguousAnalyteBool, False],

		First[analyteList],

		(* If any of the two previous errors are encountered, we set analyteMolecule to Null *)
		Null
	];

	(* get analyteMoleculeConcentration *)
	analyteMoleculeConcentration = If[MatchQ[analyteMolecule, ObjectP[Model[Molecule]]],

		First[Flatten[Select[compositionField, MatchQ[Download[#[[2]], Object, Cache -> myCache], analyteMolecule]&]]],

		Null
	];

	(* -- We try to get the third molecule info -- *)
	solutionDoesNotHaveThirdMoleculeBool = If[LessQ[Length[compositionMoleculeList], 3],
		True,
		False
	];

	cannotDetermineThirdMoleculeBool = If[
		Or[
			!MatchQ[solventMolecule, ObjectP[Model[Molecule]]],
			!MatchQ[analyteMolecule, ObjectP[Model[Molecule]]],
			GreaterQ[Length[compositionMoleculeList], 3]
		],
		True,
		False
	];

	(* We can get the third molecule if cannotDetermineThirdMoleculeBool is False *)
	thirdMolecule = If[MatchQ[solutionDoesNotHaveThirdMoleculeBool, False] && MatchQ[cannotDetermineThirdMoleculeBool, False],
		First[Select[compositionMoleculeList, !MatchQ[#, Alternatives[solventMolecule, analyteMolecule]]&]],

		Null
	];

	(* We can also get the third molecule concentration if cannotDetermineThirdMoleculeBool is False *)
	thirdMoleculeConcentration = If[MatchQ[solutionDoesNotHaveThirdMoleculeBool, False] && MatchQ[cannotDetermineThirdMoleculeBool, False],
		First[Flatten[Select[compositionField, MatchQ[Download[#[[2]], Object, Cache -> myCache], thirdMolecule]&]]],

		Null
	];

	(* If solutionDoesNotHaveThirdMoleculeBool is True, set electrolyteMolecule to analyteMolecule. Otherwise set to thirdMolecule *)
	{electrolyteMolecule, electrolyteMoleculeConcentration} = If[MatchQ[solutionDoesNotHaveThirdMoleculeBool, True],

		{analyteMolecule, analyteMoleculeConcentration},

		{thirdMolecule, thirdMoleculeConcentration}
	];

	fetchErrors = PickList[{
		SolutionMissingSolventBool,
		SolutionMissingAnalyteBool,
		SolutionAmbiguousAnalyteBool,
		SolventMoleculeMissingDefaultSampleModelBool,
		SolventSampleAmbiguousMoleculeBool,
		CannotDetermineThirdMoleculeBool
	}, {
		solutionMissingSolventBool,
		solutionMissingAnalyteBool,
		solutionAmbiguousAnalyteBool,
		solventMoleculeMissingDefaultSampleModelBool,
		solventSampleAmbiguousMoleculeBool,
		cannotDetermineThirdMoleculeBool
	}, True];

	Association[
		Composition -> compositionField,
		CompositionMoleculeList -> compositionMoleculeList,
		SolventSample -> solvent,
		SolventMolecule -> solventMolecule,
		AnalyteMolecule -> analyteMolecule,
		AnalyteMoleculeConcentration -> analyteMoleculeConcentration,
		ElectrolyteMolecule -> electrolyteMolecule,
		ElectrolyteMoleculeConcentration -> electrolyteMoleculeConcentration,
		SolutionMissingSolventBool -> solutionMissingSolventBool,
		SolutionMissingAnalyteBool -> solutionMissingAnalyteBool,
		SolutionAmbiguousAnalyteBool -> solutionAmbiguousAnalyteBool,
		SolventMoleculeMissingDefaultSampleModelBool -> solventMoleculeMissingDefaultSampleModelBool,
		SolventSampleAmbiguousMoleculeBool -> solventSampleAmbiguousMoleculeBool,
		SolutionDoesNotHaveThirdMoleculeBool -> solutionDoesNotHaveThirdMoleculeBool,
		CannotDetermineThirdMoleculeBool -> cannotDetermineThirdMoleculeBool,
		FetchErrors -> fetchErrors
	]
];

(* A function reload to prevent accidental massive output of the cache *)
getSolutionInformation[mySolution_, myCache_] := Null;

(* ============================================= *)
(* == getReferenceElectrodeInformation HELPER == *)
(* ============================================= *)

(* Get electrode and solution information from an input reference electrode Model or Object. *)

getReferenceElectrodeInformation[myReferenceElectrode:ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}], myCache:{PacketP[]..}] := Module[
	{
		electrodeModel,
		electrodeType,
		recommendedSolventType,
		recommendedRefreshPeriod,
		referenceSolution,
		referenceSolutionInformation,
		refreshLog,
		lastRefreshedDate,
		needRefresh
	},

	(* First we need to find out the electrode model *)
	electrodeModel = If[MatchQ[myReferenceElectrode, ObjectP[Object[Item, Electrode, ReferenceElectrode]]],
		Lookup[fetchPacketFromCache[myReferenceElectrode, myCache], Model] /. {x:ObjectP[]:>Download[x, Object]},
		myReferenceElectrode
	];

	(* get basic information *)
	{
		electrodeType,
		recommendedSolventType,
		recommendedRefreshPeriod
	} = Lookup[fetchPacketFromCache[electrodeModel, myCache],
		{
			ReferenceElectrodeType,
			RecommendedSolventType,
			RecommendedRefreshPeriod
		}]
	;

	(* fetch solutions in electrode model *)
	referenceSolution = Download[
		Lookup[fetchPacketFromCache[electrodeModel, myCache], ReferenceSolution],
		Object, Cache -> myCache];

	(* get information for the referenceSolution *)
	referenceSolutionInformation = getSolutionInformation[referenceSolution, myCache];

	(* Get the solutionLog of the Object electrode information *)
	refreshLog = If[MatchQ[myReferenceElectrode, ObjectP[Object[Item, Electrode, ReferenceElectrode]]],
		Lookup[fetchPacketFromCache[myReferenceElectrode, myCache], RefreshLog],
		Null
	];

	(* get the time the reference electrode is last refreshed *)
	lastRefreshedDate = If[!MatchQ[refreshLog, (Null|{}|{Null..})],
		Max[refreshLog[[All, 1]]],
		Null
	];

	(* If lastRefreshDate is not Null and past due, we set needRefresh to True *)
	needRefresh = If[
		And[
			MatchQ[lastRefreshedDate, _?DateObjectQ],
			!MatchQ[recommendedRefreshPeriod, Null],
			!MatchQ[electrodeType, "Bare-Ag"]
		],

		Module[{timePassed},
			(* get the time between lastRefreshDate and now *)
			timePassed = Now - lastRefreshedDate;
			If[GreaterQ[timePassed, recommendedRefreshPeriod],

				(* If timePassed is larger than the inverse of recommendRefreshFrequency, set needRefresh to True *)
				True,
				False
			]
		],

		(* If the electrodeType is "Bare-Ag", we need to refresh the reference electrode anyway *)
		If[
			MatchQ[electrodeType, "Bare-Ag"],
			True,

			(* Otherwise we set this to False *)
			False
		]
	];

	Association[
		ReferenceElectrodeType -> electrodeType,
		RecommendedSolventType -> recommendedSolventType,
		RecommendedRefreshPeriod -> recommendedRefreshPeriod,
		ReferenceSolution -> referenceSolution,
		ReferenceSolutionInformation -> referenceSolutionInformation,
		RefreshLog -> refreshLog,
		LastRefreshedDate -> lastRefreshedDate,
		NeedRefresh -> needRefresh
	]
];

(* A function reload to prevent accidental massive output of the cache *)
getReferenceElectrodeInformation[myReferenceElectrode_, myCache_]:=Null;

(* ================================ *)
(* == concentrationMatchQ HELPER == *)
(* ================================ *)

(* Check if two input concentrations match with each other for a given molecule *)

concentrationMatchQ[myFirstConcentration:Alternatives[ConcentrationP, MassConcentrationP], mySecondConcentration:Alternatives[ConcentrationP, MassConcentrationP], myMolecule:ObjectP[Model[Molecule]], myCache:{PacketP[]..}] := Module[
	{
		molecularWeight,
		firstConcentrationInMillimolar,
		secondConcentrationInMillimolar
	},

	(* fetch the molecular weight of the molecule *)
	molecularWeight = Lookup[fetchPacketFromCache[myMolecule, myCache], MolecularWeight];

	(* If molecularWeight is not properly fetched, we return False directly *)
	If[!MatchQ[molecularWeight, MolecularWeightP],
		Return[False];
	];

	(* Otherwise we can continue *)

	(* First we get the firstConcentrationInMillimolar *)
	firstConcentrationInMillimolar = If[MatchQ[myFirstConcentration, ConcentrationP],
		UnitConvert[myFirstConcentration, Millimolar],

		(* Otherwise we use the molecular weight to convert it *)
		UnitConvert[myFirstConcentration / molecularWeight, Millimolar]
	];

	(* Then we get the secondConcentrationInMillimolar *)
	secondConcentrationInMillimolar = If[MatchQ[mySecondConcentration, ConcentrationP],
		UnitConvert[mySecondConcentration, Millimolar],

		(* Otherwise we use the molecular weight to convert it *)
		UnitConvert[mySecondConcentration / molecularWeight, Millimolar]
	];

	(* Return the result *)
	LessQ[Abs[firstConcentrationInMillimolar - secondConcentrationInMillimolar], 10^-1 Millimolar]
];

(* A function reload to prevent accidental massive output of the cache *)
concentrationMatchQ[myFirstConcentration_, mySecondConcentration_, myMolecule_, myCache_] := Null;