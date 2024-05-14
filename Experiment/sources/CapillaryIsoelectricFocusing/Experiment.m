(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ExperimentCapillaryIsoelectricFocusing Options *)

DefineOptions[ExperimentCapillaryIsoelectricFocusing,
	Options:>{
		(* General Options *)
		{
			OptionName->Instrument,
			Default->Model[Instrument,ProteinCapillaryElectrophoresis,"Maurice"],
			Description->"The capillary electrophoresis instrument that will be used by the protocol. The instrument accepts a capillary cartridge loaded with electrolytes and sequentially analyzes samples by separating proteins according to their isoelectric point in a pH gradient.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,ProteinCapillaryElectrophoresis],Object[Instrument,ProteinCapillaryElectrophoresis]}]
			],
			Category->"General"
		},
		{
			OptionName->Cartridge,
			Default->Model[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF"],
			Description->"The capillary electrophoresis cartridge loaded on the instrument for Capillary IsoElectric Focusing (cIEF) experiments. The cartridge holds a single capillary and electrolyte buffers (sources of hydronium and hydroxyl ions). The cIEF cartridge can run 100 injections in up to 20 batches under optimal conditions, and up to 200 injections in total.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Container,ProteinCapillaryElectrophoresisCartridge],Object[Container,ProteinCapillaryElectrophoresisCartridge]}]
			],
			Category->"General"
		},
		{
			OptionName->SampleTemperature,
			Default->10Celsius,
			Description->"The sample tray temperature at which samples are maintained while awaiting injection.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[Ambient,4*Celsius,10*Celsius,15*Celsius]
			],
			Category->"General"
		},
		{
			OptionName->InjectionTable,
			Default->Automatic,
			Description->"The order of sample, Standard, and Blank sample loading into the Instrument during measurement.",
			ResolutionDescription->"Determined to the order of input samples articulated. Standard and Blank samples are inserted based on the determination of StandardFrequency and BlankFrequency. For example, StandardFrequency -> FirstAndLast and BlankFrequency -> Null result in Standard samples injected first, then samples, and then the Standard sample set again at the end.",
			AllowNull->False,
			Widget->Adder[{
				"Type"->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Sample,Standard,Blank]],
				"Sample"->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
				"Volume"->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Microliter,200*Microliter],
						Units:>Microliter
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Automatic]
					]
				]
			},
				Orientation->Vertical
			],
			Category->"General"
		},
		{
			OptionName->MatchedInjectionTable,
			Default->Automatic,
			Description->"The order of sample, Standard, and Blank sample loading into the Instrument during measurement withthe index of the respective sample.",
			ResolutionDescription->"Determined to the order of input samples articulated. Standard and Blank samples are inserted based on the determination of StandardFrequency and BlankFrequency. For example, StandardFrequency -> FirstAndLast and BlankFrequency -> Null result in Standard samples injected first, then samples, and then the Standard sample set again at the end.",
			AllowNull->False,
			Widget->Adder[{
				"Type"->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Sample,Standard,Blank]],
				"Sample"->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
				"Volume"->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Microliter,200*Microliter],
						Units:>Microliter
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Automatic]
					]
				],
				"SampleIndex"->Widget[
					Type->Number,
					Pattern:>GreaterEqualP[1,1]
				]
			},
				Orientation->Vertical
			],
			Category->"Hidden"
		},
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description->"The number of times each sample will be injected. For example, when NumberOfReplicates is set to 2, each sample will be run twice consecutively. By default, this option means technical replicates that are injected from the same position on the assay plate. Unless different aliquot containers are used for the replicates with ConsolidateAliquots->False, the replicates will be injected from different aliquots of the sample.",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterEqualP[2,1]
			],
			Category->"General"
		},
		(* Instrument Preparation Options *)
		{
			OptionName->Anolyte,
			Default->Model[Sample,"0.08M Phosphoric Acid in 0.1% Methyl Cellulose"],
			Description->"The anode electrolyte solution loaded on the cartridge that is the source of hydronium ion for the capillary in cIEF experiments. Two milliliters of anolyte solution will be loaded onto the cartridge for every batch of up to 100 injections.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->Catholyte,
			Default->Model[Sample,"0.1M Sodium Hydroxide in 0.1% Methyl Cellulose"],
			Description->"The electrolyte solution loaded on the cartridge that is the source of hydroxyl ions for the capillary in cIEF experiments. Two milliliters of catholyte solution will be loaded onto the cartridge for every batch of up to 100 injections.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->ElectroosmoticConditioningBuffer,
			Default->Model[Sample,"0.5% Methyl Cellulose"],
			Description->"The ElectroosmoticConditioningBuffer solution is used to wash the capillary between injections to decrease electroosmotic flow. Two milliliters of 0.5% Methyl Cellulose solution will be loaded on the instrument for every batch of up to 100 injections.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->FluorescenceCalibrationStandard,
			Default->Model[Sample,"cIEF Fluorescence Calibration Standard"],
			Description->"The FluorescenceCalibrationStandard solution is used to set the baseline for NativeFluorescence detection. Five hundred microliters of a commercial standard are loaded on the instrument for every batch of up to 100 injections.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->WashSolution,
			Default-> Model[Sample, "LCMS Grade Water"],
			Description->"The WashSolution is used to rinse the capillary after use. WashSolution is loaded on the instrument in two separate with 2 mL each. One vial is used to wash the capillary and the other to wash the capillary tip.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->PlaceholderContainer,
			Default->Model[Container, Vessel, "Maurice Reagent Glass Vials, 2mL"],
			Description->"The PlaceholderContainer is an empty vial used to dry the capillary after wash.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Container,Vessel],Object[Container,Vessel]}]
			],
			Category->"Hidden"
		},
		{
			OptionName->OnBoardMixing,
			Default->False,
			Description->"Indicates whether samples should be mixed with the master mix right before they are loaded to the capillary or during sample preparation before the assay plate is loaded to the instrument. OnBoardMixing should be used for sensitive samples. Only a single master mix composition is allowed when using OnBoardMixing. When using OnBoardMixing, Sample tubes should contain samples in 25 microliters. Before injecting each sample, the instrument will add 100 microliters of the master mix and mix.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"Instrument Preparation"
		},
		(* Storage conditions for Instrument Preparation *)
		{
			OptionName->CartridgeStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for the Cartridge after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Post Experiment"
		},
		{
			OptionName->AnolyteStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for the Anolyte solution after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Post Experiment"
		},
		{
			OptionName->CatholyteStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for the Catholyte solution after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Post Experiment"
		},
		{
			OptionName->ElectroosmoticConditioningBufferStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for the ElectroosmoticConditioningBuffer after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Post Experiment"
		},
		{
			OptionName->FluorescenceCalibrationStandardStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for the FluorescenceCalibrationStandard after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Post Experiment"
		},
		{
			OptionName->WashSolutionStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for the WashSolution after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Post Experiment"
		},
		(* master mix Preparation Options - Index-Matched to SamplesIn*)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			(* Label options for manual primitives *)
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples that are being analyzed by capillary isoelectric focusing, for use in downstream unit operations.",
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
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the containers of the samples that are being analyzed by capillary isoelectric focusing, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation -> True
			},
			(* Sample Options *)
			{
				OptionName->SampleVolume,
				Default->Automatic,
				Description->"Indicates the volume drawn from the sample to the assay tube. Each tube contains a Sample, DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				ResolutionDescription->"When SampleVolume is set to Automatic and OnBoardMixing is False, the volume is calculated based off of the composition of the sample to reach 0.2 mg / ml protein in the sample. If composition is not available, volume will be set to 10% of the TotalVolume. When SampleVolume is set to Automatic and OnBoardMixing is True, SampleVolume is resolves to 25 microliters.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->TotalVolume,
				Default->Automatic,
				Description->"Indicates the final volume in the assay tube prior to loading onto the capillary. Each tube contains a Sample, DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				ResolutionDescription->"When TotalVolume is set to Automatic and OnBoardMixing is True, Total Volume is resolved to 125 microliters. OnBoardMixing is False, Total volume is defaulted to 100 microliters.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[50*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->PremadeMasterMix,
				Default->Automatic,
				Description->"Indicates if a premade master mix should be used or, alternatively, the master mix should be made as part of this protocol. The master mix contains the reagents required for cIEF experiments, i.e., DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				ResolutionDescription->"When PremadeMasterMix is set to Automatic, it will resolve to True if any of its downstream options is specified.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->PremadeMasterMixReagent,
				Default->Automatic,
				Description->"The premade master mix used for cIEF experiment, containing DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				ResolutionDescription->"When PremadeMasterMix is True and PremadeMasterMixReagent is set to Automatic, it will resolve to Model[Sample, StockSolution, \"2X Wide-Range cIEF Premade Master Mix\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->PremadeMasterMixDiluent,
				Default->Automatic,
				Description->"The solution used to dilute the premade master mix used to its working concentration.",
				ResolutionDescription->"When PremadeMasterMix is set to True and PremadeMasterMixDiluent is set to Automatic, Model[Sample,\"LCMS Grade Water\"] will be set as diluent.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->PremadeMasterMixReagentDilutionFactor,
				Default->Automatic,
				Description->"The factor by which the premade master mix should be diluted by in the final assay tube.",
				ResolutionDescription->"When PremadeMasterMix is set to True and PremadeMasterMixReagentDilutionFactor is set to Automatic, it will be set as the ratio of the total volume to premade master mix volume.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterEqualP[1]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->PremadeMasterMixVolume,
				Default->Automatic,
				Description->"The volume of the premade master mix required to reach its final concentration.",
				ResolutionDescription->"When PremadeMasterMix is set to True and PremadeMasterMixVolume is set to Automatic, the volume is calculated by the division of TotalVolume by PremadeMasterMixReagentDilutionFactor. If PremadeMasterMix is set to False, PremadeMasterMixVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->Diluent,
				Default->Automatic,
				Description->"The solution used to top volume in assay tube to total volume and dilute components to working concentration.",
				ResolutionDescription->"When PremadeMasterMix is set to False and Diluent is set to Automatic, Model[Sample,\"LCMS Grade Water\"] will be set as diluent.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->Ampholytes,
				Default->Automatic,
				Description->"A solution composed of a mixture of amphoteric molecules, that case act both as an acid and a base, in the master mix that form the pH gradient. In the presence of an anolyte and a catholyte, and once a voltage is applied across the capillary, ampholytes for a pH gradient at a range that depend on the amopholyte composition. Proteins then resolve according to their isoelectric point within this gradient. When specifying values for each of SamplesIn, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When Ampholytes is set to Automatic and PremadeMasterMix is False, Model[Sample,\"Pharmalyte pH 3-10\"] will be set as the ampholyte in this sample.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
					Adder[Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample],Object[Sample]}]]
					]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->AmpholyteTargetConcentrations,
				Default->Automatic,
				Description->"The concentration (Vol/Vol) of amphoteric molecules in the master mix. When specifying values for each of SamplesIn, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When PremadeMasterMix is set to False and AmpholyteTargetConcentrations is set to Automatic, AmpholyteTargetConcentrations will be set to 4% if one ampholyte is given, and 2% each, if more than one ampholyte is set and no AmpholyteVolume values are given. If volume is given concentration will be calculated considering Ampholyte concentrations as 100%.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
						Units->VolumePercent],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
								Units->VolumePercent],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
							]
					]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->AmpholyteVolume,
				Default->Automatic,
				Description->"The volume of amphoteric molecule stocks to add to the master mix. When specifying values for each of SamplesIn, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When PremadeMasterMix is set to False and AmpholyteVolume is set to Automatic, AmpholyteVolume is set to the volume needed to reach the given AmpholyteTargetConcentrations based in the TotalVolume.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.1*Microliter,200*Microliter],
						Units->{Microliter,{Milliliter,Microliter}}],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.1*Microliter,200*Microliter],
								Units->{Microliter,{Milliliter,Microliter}}],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
						]
					]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->IsoelectricPointMarkers,
				Default->Automatic,
				Description->"Reference analytes, usually peptides with known isoelectric points, that are included in the master mix and are used to convert position in the capillary to the pI it represents. The mastermix for each sample should have two isoelectric point markers. A linear fit is then used to directly interpret the pI for each position between the two markers. When specifying values for each of SamplesIn, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When IsoelectricPointMarkers is set to Automatic and PremadeMasterMix is False, {Model[Sample,StockSolution, \"Resuspended cIEF pI Marker - 4.05\"], Model[Sample,StockSolution, \"Resuspended cIEF pI Marker - 9.99\"]} will be set as the IsoelectricPointMarkers in this sample.",
				AllowNull->True,
				Widget->Alternatives[
					Adder[
						Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample],Object[Sample]}]]
					],
					Widget[
						Type-> Enumeration,
						Pattern:>Alternatives[Automatic|Null]]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->IsoelectricPointMarkersTargetConcentrations,
				Default->Automatic,
				Description->"The final concentration (Vol/Vol) of pI markers in the assay tube. When specifying values for each of SamplesIn, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When IsoelectricPointMarkers is set to Automatic and PremadeMasterMix is False, pI markers target concentration will be set to 1%.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
						Units->VolumePercent],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
								Units->VolumePercent],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
						]
					]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->IsoelectricPointMarkersVolume,
				Default->Automatic,
				Description->"The volume of pI marker stocks to add to the master mix. When specifying values for each of SamplesIn, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When IsoelectricPointMarkersVolume is set to Automatic and PremadeMasterMix is False, it is set to the volume required to reach IsoelectricPointMarkersTargetConcentrations in TotalVolume.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.1*Microliter,200*Microliter],
						Units->{Microliter,{Milliliter,Microliter}}],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.1*Microliter,200*Microliter],
								Units->{Microliter,{Milliliter,Microliter}}],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
						]
					]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ElectroosmoticFlowBlocker,
				Default->Automatic,
				Description->"Electroosmotic flow blocker solution, usually methyl cellulose, to include in the master mix. Electroosmotic flow referes to the motion of liquids in a capillary as a result of applied voltage across it. Electroosmotic flow is most significant when channel diameters are very small. In capillary isoelectric focusing, the charge of the capillary wall should be masked to minimize the electroosmotic flow.",
				ResolutionDescription->"When ElectroosmoticFlowBlocker is set to Automatic and PremadeMasterMix is False, ElectroosmoticFlowBlocker will be set to Model[Sample,\"1% Methyl Cellulose\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ElectroosmoticFlowBlockerTargetConcentrations,
				Default->Automatic,
				Description->"The concentration of ElectroosmoticFlowBlocker in the master mix.",
				ResolutionDescription->"When ElectroosmoticFlowBlockerTargetConcentrations is set to Automatic and PremadeMasterMix is False, it is set to 0.35% if no ElectroosmoticFlowBlockerVolume is set.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.001*MassPercent,100*MassPercent],
					Units->MassPercent
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ElectroosmoticFlowBlockerVolume,
				Default->Automatic,
				Description->"The volume of ElectroosmoticBlocker stock to add to the master mix.",
				ResolutionDescription->"When ElectroosmoticFlowBlockerVolume is set to Automatic and PremadeMasterMix is False, it is calculated based on TotalVolume to reach the ElectroosmoticBlockerTargetConcentrations.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->Denature,
				Default->Automatic,
				Description->"Indicates if a DenaturationReagent should be added to the master mix.",
				ResolutionDescription->"When Denature is set to Automatic and PremadeMasterMix is False, Denature will be set to False.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->DenaturationReagent,
				Default->Automatic,
				Description->"The denaturing agent, e.g., Urea or SimpleSol, to be added to the master mix to prevent protein precipitation.",
				ResolutionDescription->"When DenaturationReagent is set to Automatic, PremadeMasterMix is False, and Denature is True, DenaturationReagent will be set to Model[Sample,StockSolution,\"8M Urea\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->DenaturationReagentTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of the denaturing agent in the master mix.",
				ResolutionDescription->"When DenaturationReagentTargetConcentration is set to Automatic, PremadeMasterMix is False, and Denature is True, it is set to 4M if no DenaturationReagentVolume value is given. If DenaturationReagentVolume is set and the concentration of DenaturationReagent is known, DenaturationReagentTargetConcentration is calculated.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0*Molar],
						Units->{1,{Molar,{Millimolar,Molar}}}
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
						Units->VolumePercent]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->DenaturationReagentVolume,
				Default->Automatic,
				Description->"The volume of the denaturing agent required to reach its final concentration in the master mix.",
				ResolutionDescription->"When DenaturationReagentVolume is set to Automatic, PremadeMasterMix is False, and Denature is True, it is set to the volume required to reach DenaturationReagentTargetConcentration.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->IncludeAnodicSpacer,
				Default->Automatic,
				Description->"Indicates if an anodic spacer should be added to the master mix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) and Arginine (pI 10.7) are added as Spacers.",
				ResolutionDescription->"When AnodicSpacer is set to Automatic and PremadeMasterMix is False, Spacers will be set to False.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->AnodicSpacer,
				Default->Automatic,
				Description->"Acidic ampholyte to include in the master mix.  When analyzing a protein with very acidic pI (e.g. Pepsin), one might choose to add an AnodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the anolyte reservoir.",
				ResolutionDescription->"When AnodicSpacer is set to Automatic, PremadeMasterMix is False and IncludeAnodicSpacer is set to True, AnodicSpacer will be set to Model[Sample,StockSolution, \"200mM Iminodiacetic acid\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->AnodicSpacerTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of AnodicSpacer in the master mix.",
				ResolutionDescription->"When AnodicSpacerTargetConcentration is set to Automatic, PremadeMasterMix is False and IncludeAnodicSpacer is set to True, it is set to 1 mM when no AnodicSpacerMarkersVolume is set. When AnodicSpacer concentration is known and AnodicSpacerMarkersVolume is set, Automatic calculates the final concentration based on AnodicSpacerTargetConcentrations and TotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Millimolar],
					Units->Alternatives[
						{1,{Millimolar,{Micromolar,Millimolar,Molar}}}
					]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->AnodicSpacerVolume,
				Default->Automatic,
				Description->"The volume of AnodicSpacer stock to add to the master mix.",
				ResolutionDescription->"When AnodicSpacerVolume is set to Automatic, PremadeMasterMix is False and IncludeAnodicSpacer is set to True, it is set to the volume required to reach AnodicSpacerTargetConcentrations in TotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->IncludeCathodicSpacer,
				Default->Automatic,
				Description->"Indicates if a cathodic spacer should be added to the master mix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) and Arginine (pI 10.7) are added as Spacers.",
				ResolutionDescription->"When AnodicSpacer is set to Automatic and PremadeMasterMix is False, Spacers will be set to False.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->CathodicSpacer,
				Default->Automatic,
				Description->"Basic ampholyte spacer to include in the master mix. When analyzing a protein with very basic pI (e.g. Cytochrome C), one might choose to add a CathodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the catholyte reservoir.",
				ResolutionDescription->"When CathodicSpacer is set to Automatic, PremadeMasterMix is False and IncludeCathodicSpacer is set to True, CathodicSpacer will be set to Model[Sample,StockSolution, \"500mM Arginine\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->CathodicSpacerTargetConcentration,
				Default->Automatic,
				Description->"The concentration of Cathodic spacer in the master mix.",
				ResolutionDescription->"When CathodicSpacerTargetConcentration is set to Automatic, PremadeMasterMix is False and IncludeCathodicSpacer is set to True, it is set to 10 mM when no CathodicSpacerMarkersVolume is set. When CathodicSpacer concentration is known and CathodicSpacerMarkersVolume is set, Automatic calculates the final concentration based on CathodicSpacerTargetConcentrations and TotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Millimolar],
					Units->Alternatives[
						{1,{Millimolar,{Micromolar,Millimolar,Molar}}}
					]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->CathodicSpacerVolume,
				Default->Automatic,
				Description->"The volume of Cathodic spacer stocks to add to the master mix.",
				ResolutionDescription->"When CathodicSpacerVolume is set to Automatic, PremadeMasterMix is False and IncludeCathodicSpacer is set to True, it is set to the volume required to reach AnodicSpacerTargetConcentrations in TotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Sample Preparation"
			},
			(* MasterMix Storage Conditions *)
			{
				OptionName->AmpholytesStorageCondition,
				Default->Automatic,
				Description->"The non-default storage condition for ampholyte stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				ResolutionDescription->"When Automatic, resolve according to the resolved ampholytes.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal|Null],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal|Null]]
				],
				Category->"Post Experiment"
			},
			{
				OptionName->IsoelectricPointMarkersStorageCondition,
				Default->Automatic,
				Description->"The non-default storage condition for IsoelectricPointMarker stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				ResolutionDescription->"When Automatic, resolve according to the resolved isoelectricPointMarkers.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal|Null],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal|Null]]
				],
				Category->"Post Experiment"
			},
			{
				OptionName->DenaturationReagentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for DenaturationReagent stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->AnodicSpacerStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for AnodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->CathodicSpacerStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->ElectroosmoticFlowBlockerStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->DiluentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for Diluent of this experiment after the protocol is completed. If left unset, Diluent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			(* Separation conditions - Index-matched to SamplesIn*)
			{
				OptionName->LoadTime,
				Default->55*Second,
				Description->"Time to load samples into the capillary by vacuum. The default 55 Second time is enough to load approximately 8 \[Micro]l. This value should be increased only if very viscous samples are used.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1*Second,300*Second],
					Units->{Second,{Second,Minute}}
				],
				Category->"Sample Separation"
			},
			{
				OptionName->VoltageDurationProfile,
				Default->{{1500*Volt,1*Minute},{3000*Volt,10*Minute}},
				Description->"Series of voltages and durations to apply onto the capillary for separation. Supports up to 20 steps where each step is 0-600 minutes, and 0-5000 volts.",
				AllowNull->False,
				Widget->Adder[{
					"Voltage"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0.1*Volt,5000*Volt],
						Units->Volt
					],
					"Time"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0.01*Minute,600*Minute],
						Units->{Minute,{Second,Minute,Hour}}
					]
				},
					Orientation->Vertical
				],
				Category->"Sample Separation"
			},
			(* Imaging settings *)
			{
				OptionName->ImagingMethods,
				Default->Automatic,
				Description->"Whole capillary imaging by Either UVAbsorbance (280 nm) alone or both UVAbsorbance and Native Fluorescence (Ex 280 nm, Em 320-450nm).",
				ResolutionDescription->"When Automatic, AbsorbanceAndFluorescnece will be set.",
				AllowNull->False,
				Widget->Widget[
						Type->Enumeration,
						Pattern:>Absorbance|AbsorbanceAndFluorescence
				],
				Category->"Sample Detection"
			},
			{
				OptionName->NativeFluorescenceExposureTime,
				Default->Automatic,
				Description->"Exposure duration for NativeFluorescence detection.",
				ResolutionDescription->"When Automatic, resolves according to ImagingMethods. when ImagingMethods is set to AbsorbanceAndFluorescence, NativeFluorescenceExposureTime will be set to {3*Second,5*Second,10*Second,20*Second}.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[1*Second,200*Second],
						Units->{Second,{Minute,Second,Millisecond}}],
					Adder[Widget[
						Type->Quantity,
						Pattern:>RangeP[1*Second,200*Second],
						Units->{Second,{Minute,Second,Millisecond}}]
					]
				],
				Category->"Sample Detection"
			}
		],
		{
			OptionName->UVDetectionWavelength,
			Default->280*Nanometer,
			Description->"The wavelength used for signal detection by Absorbance.",
			AllowNull->False,
			Widget->Widget[
				Type->Expression,
				Pattern:>280*Nanometer,
				Size->Line
			],
			Category->"Sample Detection"
		},
		{
			OptionName->NativeFluorescenceDetectionExcitationWavelengths,
			Default->280*Nanometer,
			Description->"The excitation wavelength used for Fluorescence detection.",
			AllowNull->False,
			Widget->Widget[
				Type->Expression,
				Pattern:>280*Nanometer,
				Size->Line
			],
			Category->"Sample Detection"
		},
		{
			OptionName->NativeFluorescenceDetectionEmissionWavelengths,
			Default->{320*Nanometer,405*Nanometer},
			Description->"The emission wavelength range used for Fluorescence detection.",
			AllowNull->False,
			Widget->Widget[
				Type->Expression,
				Pattern:>{320*Nanometer,405*Nanometer},
				Size->Line
			],
			Category->"Sample Detection"
		},
				(* Standards and Blanks*)
		{
			OptionName->IncludeStandards,
			Default->Automatic,
			Description->"Indicates if standards should be included in this experiment. Standards are used to both ensure reproducibility within and between Experiments and as a reference to interpolate the isoelectric point of unknown analytes in samples.",
			ResolutionDescription->"When IncludeBlanks is set to Automatic and any of its related options is specified, it is set to True. Otherwise, it is set to False.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"Standards"
		},
		IndexMatching[
			IndexMatchingParent->Standards,
			{
				OptionName->Standards,
				Default->Automatic,
				Description->"Indicates what analyte(s) of known isoelectric points to include as part of this experiments. Standards are treated as independent samples and serve as positive controls or references for unknown samples.",
				ResolutionDescription->"When Standards is set to Automatic and IncludeStandards is True, it is set to Maurice cIEF System Suitability Peptide Panel.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standards"
			},
			{
				OptionName->StandardStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for Standards of this experiment after the protocol is completed. If left unset, StandardStorageCondition will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->StandardVolume,
				Default->Automatic,
				Description->"Indicates the volume drawn from the standard to the assay tube. Each tube contains a Sample, DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				ResolutionDescription->"When StandardVolume is set to Automatic and OnBoardMixing is False, the volume is calculated based off of the composition of the sample to reach 0.2 mg / ml protein in the sample. If composition is not available, volume will be set to 10% of the TotalVolume. When StandardVolume is set to Automatic and OnBoardMixing is True, StandardVolume is resolves to 25 microliters.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardFrequency,
				Default->Automatic,
				Description->"Indicates how many injections per standard should be included in this experiment. Sample, Standard, and Blank injection order are resolved according to InjectoinTable.",
				ResolutionDescription->"When StandardFrequency is set to Automatic and IncludeStandards is True, it will default to FirstAndLast.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>GreaterP[0,1]|FirstAndLast|First|Last
				],
				Category->"Standards"
			},
			{
				OptionName->StandardTotalVolume,
				Default->Automatic,
				Description->"Indicates the final volume in the assay tube, including standard and master mix.",
				ResolutionDescription->"When StandardTotalVolume is set to Automatic and IncludeStandards is True, it will resolve to the most common total volume in SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[50*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardPremadeMasterMix,
				Default->Automatic,
				Description->"Indicates if a premade  should be used or, alternatively, the master should be made as part of this protocol. The  contains the reagents required for cIEF experiments, i.e., DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				ResolutionDescription->"When StandardPremadeMasterMix is set to Automatic and IncludeStandards is True, it will resolve to True if any of its downstream options is specified.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardPremadeMasterMixReagent,
				Default->Automatic,
				Description->"The premade master mix used for cIEF experiment, containing DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				ResolutionDescription->"When StandardPremadeMasterMix is True and StandardPremadeMasterMixReagent is set to Automatic, it will resolve to Model[Sample, StockSolution, \"2X Wide-Range cIEF Premade Master Mix\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardPremadeMasterMixDiluent,
				Default->Automatic,
				Description->"The solution used to dilute the premade master mix used to its working concentration.",
				ResolutionDescription->"When StandardPremadeMasterMixDiluent is set to Automatic, StandardPremadeMasterMix is set to True, and IncludeStandards is True, Model[Sample,\"LCMS Grade Water\"] will be set as diluent.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardPremadeMasterMixReagentDilutionFactor,
				Default->Automatic,
				Description->"The factor by which the premade master mix should be diluted by in the final assay tube.",
				ResolutionDescription->"When StandardPremadeMasterMixReagentDilutionFactor is set to Automatic, StandardPremadeMasterMix is set to True, and IncludeStandards is True, it will be set as the ratio of the total volume to premade master mix volume.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterEqualP[1]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardPremadeMasterMixVolume,
				Default->Automatic,
				Description->"The volume of the premade master mix required to reach its final concentration.",
				ResolutionDescription->"When StandardPremadeMasterMixVolume is set to Automatic, StandardPremadeMasterMix is set to True, and IncludeStandards is True, the volume is calculated by the division of TotalVolume by StandardPremadeMasterMixReagentDilutionFactor. If StandardPremadeMasterMix is set to False, StandardPremadeMasterMixVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardDiluent,
				Default->Automatic,
				Description->"The solution used to top volume in assay tube to total volume and dilute components to working concentration.",
				ResolutionDescription->"When StandardPremadeMasterMix is set to False, StandardDiluent is set to Automatic, and IncludeStandards is True, Model[Sample,\"LCMS Grade Water\"] will be set as diluent.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardAmpholytes,
				Default->Automatic,
				Description->"A solution composed of a mixture of amphoteric molecules, that case act both as an acid and a base, in the master mix that form the pH gradient. In the presence of an anolyte and a catholyte, and once a voltage is applied across the capillary, ampholytes for a pH gradient at a range that depend on the amopholyte composition. Proteins then resolve according to their isoelectric point within this gradient. When specifying values for each of Standards, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When StandardAmpholytes is set to Automatic, StandardPremadeMasterMix is False, and IncludeStandards is True, Model[Sample,\"Pharmalyte pH 3-10\"] will be set as the ampholyte in this standard.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
					Adder[Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample],Object[Sample]}]]
					]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardAmpholyteTargetConcentrations,
				Default->Automatic,
				Description->"The concentration (Vol/Vol) of amphoteric molecules in the master mix. When specifying values for each of Standards, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When StandardPremadeMasterMix is set to False, StandardAmpholyteTargetConcentrations is set to Automatic, and IncludeStandards is True, StandardAmpholyteTargetConcentrations will be set to 4% if one ampholyte is given, and 2% each, if more than one ampholyte is set and no StandardAmpholyteVolume values are given. If volume is given concentration will be calculated considering Ampholyte concentrations as 100%.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
						Units->VolumePercent],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
								Units->VolumePercent],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
						]
					]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardAmpholyteVolume,
				Default->Automatic,
				Description->"The volume of amphoteric molecule stocks to add to the master mix. When specifying values for each of Standards, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When StandardAmpholyteVolume is set to Automatic, StandardPremadeMasterMix is set to False, and IncludeStandards is True, StandardAmpholyteVolume is set to the volume needed to reach the given AmpholyteTargetConcentrations based in the TotalVolume.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.1*Microliter,200*Microliter],
						Units->{Microliter,{Milliliter,Microliter}}],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.1*Microliter,200*Microliter],
								Units->{Microliter,{Milliliter,Microliter}}],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
						]
					]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardIsoelectricPointMarkers,
				Default->Automatic,
				Description->"Reference analytes, usually peptides with known isoelectric points, that are included in the master mix and are used to convert position in the capillary to the pI it represents. The mastermix for each sample should have two isoelectric point markers. A linear fit is then used to directly interpret the pI for each position between the two markers. When specifying values for each of Standards, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When StandardIsoelectricPointMarkers is set to Automatic, StandardPremadeMasterMix is False, and IncludeStandards is True, {Model[Sample,StockSolution, \"Resuspended cIEF pI Marker - 4.05\"], Model[Sample,StockSolution, \"Resuspended cIEF pI Marker - 9.99\"]} will be set as the StandardIsoelectricPointMarkers in this standard.",
				AllowNull->True,
				Widget->Alternatives[
					Adder[
						Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample],Object[Sample]}]]
					],
					Widget[
						Type-> Enumeration,
						Pattern:>Alternatives[Automatic|Null]]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardIsoelectricPointMarkersTargetConcentrations,
				Default->Automatic,
				Description->"The final concentration (Vol/Vol) of pI markers in the assay tube. When specifying values for each of Standards, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When StandardIsoelectricPointMarkersTargetConcentrations is set to Automatic, StandardPremadeMasterMix is False, and IncludeStandards is True, pI markers target concentration will be set to 1%.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
						Units->VolumePercent],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
								Units->VolumePercent],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
						]
					]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardIsoelectricPointMarkersVolume,
				Default->Automatic,
				Description->"The volume of pI marker stocks to add to the master mix. When specifying values for each of Standards, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When StandardIsoelectricPointMarkersVolume is set to Automatic, StandardPremadeMasterMix is False, and IncludeStandards is True, it is set to the volume required to reach StandardIsoelectricPointMarkersTargetConcentrations in StandardTotalVolume.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.1*Microliter,200*Microliter],
						Units->{Microliter,{Milliliter,Microliter}}],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.1*Microliter,200*Microliter],
								Units->{Microliter,{Milliliter,Microliter}}],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
						]
					]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardElectroosmoticFlowBlocker,
				Default->Automatic,
				Description->"Electroosmotic flow blocker solution, usually methyl cellulose, to include in the master mix. Electroosmotic flow referes to the motion of liquids in a capillary as a result of applied voltage across it. Electroosmotic flow is most significant when channel diameters are very small. In capillary isoelectric focusing, the charge of the capillary wall should be masked to minimize the electroosmotic flow.",
				ResolutionDescription->"When StandardElectroosmoticFlowBlocker is set to Automatic, StandardPremadeMasterMix is False, and IncludeStandards is True, StandardElectroosmoticFlowBlocker will be set to Model[Sample,\"1% Methyl Cellulose\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardElectroosmoticFlowBlockerTargetConcentrations,
				Default->Automatic,
				Description->"The concentration of ElectroosmoticFlowBlocker in the master mix.",
				ResolutionDescription->"When StandardElectroosmoticFlowBlockerTargetConcentrations is set to Automatic, StandardPremadeMasterMix is False, and IncludeStandards is True, it is set to 0.35% if no StandardElectroosmoticFlowBlockerVolume is set.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.001*MassPercent,100*MassPercent],
					Units->MassPercent
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardElectroosmoticFlowBlockerVolume,
				Default->Automatic,
				Description->"The volume of ElectroosmoticBlocker stock to add to the master mix.",
				ResolutionDescription->"When StandardElectroosmoticFlowBlockerVolume is set to Automatic, StandardPremadeMasterMix is False, and IncludeStandards is True, it is calculated based on StandardTotalVolume and the given StandardElectroosmoticFlowBlockerTargetConcentrations.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardDenature,
				Default->Automatic,
				Description->"Indicates if a DenaturationReagent should be added to the master mix.",
				ResolutionDescription->"When StandardDenature is set to Automatic, StandardPremadeMasterMix is False, and IncludeStandards is True, StandardDenature will be set to False.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardDenaturationReagent,
				Default->Automatic,
				Description->"The denaturing agent, e.g., Urea or SimpleSol, to be added to the master mix to prevent protein precipitation.",
				ResolutionDescription->"When StandardDenaturationReagent is set to Automatic, StandardPremadeMasterMix is False, StandardDenature is True, and IncludeStandards is True, StandardDenaturationReagent will be set to Model[Sample,StockSolution,\"8M Urea\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardDenaturationReagentTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of the denaturing agent in the master mix.",
				ResolutionDescription->"When StandardDenaturationReagentTargetConcentration is set to Automatic, StandardPremadeMasterMix is False, StandardDenature is True, and IncludeStandards is True, it is set to 4M if no StandardDenaturationReagentVolume value is given. If StandardDenaturationReagentVolume is set and the concentration of StandardDenaturationReagent is known, StandardDenaturationReagentTargetConcentration is calculated.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0*Molar],
						Units->{1,{Molar,{Millimolar,Molar}}}
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
						Units->VolumePercent]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardDenaturationReagentVolume,
				Default->Automatic,
				Description->"The volume of the denaturing agent required to reach its final concentration in the master mix.",
				ResolutionDescription->"When StandardDenaturationReagentVolume is set to Automatic, StandardPremadeMasterMix is False, StandardDenature is True, and IncludeStandards is True, it is set to the volume required to reach StandardDenaturationReagentTargetConcentration.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardIncludeAnodicSpacer,
				Default->Automatic,
				Description->"Indicates if an anodic spacer should be added to the master mix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) is added as an AnodicSpacer.",
				ResolutionDescription->"When StandardIncludeAnodicSpacer is set to Automatic, StandardPremadeMasterMix is False, and IncludeStandards is True, StandardIncludeAnodicSpacer will be set to False.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardAnodicSpacer,
				Default->Automatic,
				Description->"Acidic ampholyte to include in the master mix.  When analyzing a protein with very acidic pI (e.g. Pepsin), one might choose to add an AnodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the anolyte reservoir.",
				ResolutionDescription->"When StandardAnodicSpacer is set to Automatic, StandardPremadeMasterMix is False, StandardIncludeAnodicSpacer is set to True, and IncludeStandards is True, StandardAnodicSpacer will be set to Model[Sample,StockSolution, \"200mM Iminodiacetic acid\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardAnodicSpacerTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of AnodicSpacer in the master mix.",
				ResolutionDescription->"When StandardAnodicSpacerTargetConcentration is set to Automatic, StandardPremadeMasterMix is False, StandardIncludeAnodicSpacer is set to True, and IncludeStandards is True, it is set to 1mM when no StandardAnodicSpacerMarkersVolume is set. When StandardAnodicSpacer concentration is known and AnodicSpacerMarkersVolume is set, Automatic calculates the final concentration based on StandardAnodicSpacerTargetConcentrations and StandardTotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Millimolar],
					Units->Alternatives[
						{1,{Millimolar,{Micromolar,Millimolar,Molar}}}
					]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardAnodicSpacerVolume,
				Default->Automatic,
				Description->"The volume of AnodicSpacer stock to add to the master mix.",
				ResolutionDescription->"When StandardAnodicSpacerVolume is set to Automatic, StandardPremadeMasterMix is False, StandardIncludeAnodicSpacer is set to True, and IncludeStandards is True, it is set to the volume required to reach StandardAnodicSpacerTargetConcentrations in StandardTotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardIncludeCathodicSpacer,
				Default->Automatic,
				Description->"Indicates if a cathodic spacer should be added to the master mix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) and Arginine (pI 10.7) are added as Spacers.",
				ResolutionDescription->"When StandardIncludeCathodicSpacer is set to Automatic, StandardPremadeMasterMix is False, and IncludeStandards is True, StandardIncludeCathodicSpacer will be set to True.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardCathodicSpacer,
				Default->Automatic,
				Description->"Basic ampholyte spacer to include in the master mix. When analyzing a protein with very basic pI (e.g. Cytochrome C), one might choose to add a CathodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the catholyte reservoir.",
				ResolutionDescription->"When StandardCathodicSpacer is set to Automatic, StandardPremadeMasterMix is False, StandardIncludeCathodicSpacer is set to True, and IncludeStandards is True, StandardCathodicSpacer will be set to Model[Sample,StockSolution, \"500mM Arginine\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardCathodicSpacerTargetConcentration,
				Default->Automatic,
				Description->"The concentration of Cathodic spacer in the master mix.",
				ResolutionDescription->"When StandardCathodicSpacerTargetConcentration is set to Automatic, StandardPremadeMasterMix is False, StandardIncludeCathodicSpacer is set to True, and IncludeStandards is True, it is set to 10 mM when no StandardCathodicSpacerMarkersVolume is set. When StandardCathodicSpacer concentration is known and StandardCathodicSpacerMarkersVolume is set, Automatic calculates the final concentration based on StandardCathodicSpacerTargetConcentrations and StandardTotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Millimolar],
					Units->Alternatives[
						{1,{Millimolar,{Micromolar,Millimolar,Molar}}}
					]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardCathodicSpacerVolume,
				Default->Automatic,
				Description->"The volume of Cathodic spacer stocks to add to the master mix.",
				ResolutionDescription->"When StandardCathodicSpacerVolume is set to Automatic, StandardPremadeMasterMix is False, StandardIncludeCathodicSpacer is set to True, and IncludeStandards is True, it is set to the volume required to reach StandardAnodicSpacerTargetConcentrations in StandardTotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Standard Preparation"
			},
			(* MasterMix Storage Conditions *)
			{
				OptionName->StandardAmpholytesStorageCondition,
				Default->Automatic,
				Description->"The non-default storage condition for ampholyte stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				ResolutionDescription->"When Automatic and IncludeStandards is True, resolves to Null according to the resolved ampholytes.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Post Experiment"
			},
			{
				OptionName->StandardIsoelectricPointMarkersStorageCondition,
				Default->Automatic,
				Description->"The non-default storage condition for IsoelectricPointMarker stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				ResolutionDescription->"When Automatic and IncludeStandards is True, resolves to Null according to the resolved isoelectricPointMarkers.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Post Experiment"
			},
			{
				OptionName->StandardDenaturationReagentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for DenaturationReagent stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->StandardAnodicSpacerStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for AnodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->StandardCathodicSpacerStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->StandardElectroosmoticFlowBlockerStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->StandardDiluentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for Diluent of this experiment after the protocol is completed. If left unset, Diluent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			(* Separation conditions - Index-matched to Standards*)
			{
				OptionName->StandardLoadTime,
				Default->Automatic,
				Description->"Time to load standards in master mix into the capillary by vacuum.",
				ResolutionDescription->"When StandardLoadTime is set to Automatic and IncludeStandards is True, StandardLoadTime is set to 55 seconds.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1*Second,300*Second],
					Units->{Second,{Second,Minute}}
				],
				Category->"Standard Separation"
			},
			{
				OptionName->StandardVoltageDurationProfile,
				Default->Automatic,
				Description->"Series of voltages and durations to apply onto the capillary for separation. Supports up to 20 steps where each step is 0-600 minutes, and 0-5000 volts.",
				ResolutionDescription->"When StandardVoltageDurationProfile is set to Automatic and IncludeStandards is True, StandardVoltageDurationProfile is set to a two-step focusing: 1500 Volts for 1 Minute, followed by 3000 Volts for 10 minutes.",
				AllowNull->True,
				Widget->Adder[{
					"Voltage"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0.1*Volt,5000*Volt],
						Units->Volt
					],
					"Time"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0.01*Minute,600*Minute],
						Units->{Minute,{Second,Minute,Hour}}
					]
				},
					Orientation->Vertical
				],
				Category->"Standard Separation"
			},
			(* Imaging settings *)
			{
				OptionName->StandardImagingMethods,
				Default->Automatic,
				Description->"Whole capillary imaging by Either UVAbsorbance (280 nm) alone or both UVAbsorbance and Native Fluorescence (Ex 280 nm, Em 320-450nm).",
				ResolutionDescription->"When StandardImagingMethods is set to Automatic and IncludeStandards is True, StandardImagingMethods is set to imaging by both UVAbsorbance and NativeFluorescence.",
				AllowNull->True,
				Widget->Widget[
						Type->Enumeration,
						Pattern:>Absorbance|AbsorbanceAndFluorescence
				],
				Category->"Standard Detection"
			},
			{
				OptionName->StandardNativeFluorescenceExposureTime,
				Default->Automatic,
				Description->"Exposure duration for NativeFluorescence detection.",
				ResolutionDescription->"When StandardNativeFluorescenceExposureTime is set to Automatic and IncludeStandards is True, StandardNativeFluorescenceExposureTime is set to imaging for 3, 5, 10, and 20 seconds.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[1*Second,200*Second],
						Units->{Second,{Minute,Second,Millisecond}}],
					Adder[Widget[
						Type->Quantity,
						Pattern:>RangeP[1*Second,200*Second],
						Units->{Second,{Minute,Second,Millisecond}}]
					]
				],
				Category->"Standard Detection"
			}
		],
		(* Blanks *)
		{
			OptionName->IncludeBlanks,
			Default->Automatic,
			Description->"Indicates if blanks should be included in this experiment. Blanks serve to identify any artifacts of sample prep that may affect the results of this experiment.",
			ResolutionDescription->"When IncludeBlanks is set to Automatic and any of its related options is specified, it is set to True. Otherwise, it is set to False.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"Blanks"
		},
		IndexMatching[
			IndexMatchingParent->Blanks,
			{
				OptionName->Blanks,
				Default->Automatic,
				Description->"Indicates what blanks to include.",
				ResolutionDescription->"When Blanks is set to Automatic and IncludeBlanks is True, it is set to Milli-Q water.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blanks"
			},
			{
				OptionName->BlankStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for Blanks of this experiment after the protocol is completed. If left unset, BlanksStorageCondition will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->BlankVolume,
				Default->Automatic,
				Description->"Indicates the volume drawn from the blank to the assay tube. Each tube contains a Blank, ampholytes, pI markers, a reducing Agent, an electroosmotic flow blocker, and an anodic and/or cathodic spacers.",
				ResolutionDescription->"When BlankVolume is set to Automatic and IncludeBlanks is True, the volume is calculated to be 10% of the BlankTotalVolume. When IncludeBlanks is False, BlankVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blanks and Blanks"
			},
			{
				OptionName->BlankFrequency,
				Default->Automatic,
				Description->"Indicates how many injections per Blank should be included in this experiment. Sample, Standard, and Blank injection order are resolved according to InjectoinTable.",
				ResolutionDescription->"When BlankFrequency is set to Automatic and IncludeBlanks is True, it will default to FirstAndLast.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>GreaterP[0,1]|FirstAndLast|First|Last
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankTotalVolume,
				Default->Automatic,
				Description->"Indicates the final volume in the assay tube, including blank and master mix.",
				ResolutionDescription->"When BlankTotalVolume is set to Automatic and IncludeBlanks is True, it will resolve to the most common total volume in SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[50*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankPremadeMasterMix,
				Default->Automatic,
				Description->"Indicates if a premade  should be used or, alternatively, the master should be made as part of this protocol. The  contains the reagents required for cIEF experiments, i.e., DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				ResolutionDescription->"When BlankPremadeMasterMix is set to Automatic and IncludeBlanks is True, it will resolve to True if any of its downstream options is specified.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankPremadeMasterMixReagent,
				Default->Automatic,
				Description->"The premade master mix used for cIEF experiment, containing DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker.",
				ResolutionDescription->"When BlankPremadeMasterMix is True and BlankPremadeMasterMixReagent is set to Automatic, it will resolve to Model[Sample, StockSolution, \"2X Wide-Range cIEF Premade Master Mix\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankPremadeMasterMixDiluent,
				Default->Automatic,
				Description->"The solution used to dilute the premade master mix used to its working concentration.",
				ResolutionDescription->"When BlankPremadeMasterMixDiluent is set to Automatic and BlankPremadeMasterMix is set to True, Model[Sample,\"LCMS Grade Water\"] will be set as diluent.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankPremadeMasterMixReagentDilutionFactor,
				Default->Automatic,
				Description->"The factor by which the premade master mix should be diluted by in the final assay tube.",
				ResolutionDescription->"When BlankPremadeMasterMixReagentDilutionFactor is set to Automatic and BlankPremadeMasterMix is set to True, it will be set as the ratio of the total volume to premade master mix volume.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterEqualP[1]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankPremadeMasterMixVolume,
				Default->Automatic,
				Description->"The volume of the premade master mix required to reach its final concentration.",
				ResolutionDescription->"When BlankPremadeMasterMixVolume is set to Automatic and BlankPremadeMasterMix is set to True, the volume is calculated by the division of TotalVolume by PremadeMasterMixReagentDilutionFactor. If PremadeMasterMix is set to False, PremadeMasterMixVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankDiluent,
				Default->Automatic,
				Description->"The solution used to top volume in assay tube to total volume and dilute components to working concentration.",
				ResolutionDescription->"When BlankPremadeMasterMix is set to False and BlankDiluent is set to Automatic, Model[Sample,\"LCMS Grade Water\"] will be set as diluent.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankAmpholytes,
				Default->Automatic,
				Description->"A solution composed of a mixture of amphoteric molecules, that case act both as an acid and a base, in the master mix that form the pH gradient. In the presence of an anolyte and a catholyte, and once a voltage is applied across the capillary, ampholytes for a pH gradient at a range that depend on the amopholyte composition. Proteins then resolve according to their isoelectric point within this gradient. When specifying values for each of Blanks, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When BlankAmpholytes is set to Automatic and BlankPremadeMasterMix is False, Model[Sample,\"Pharmalyte pH 3-10\"] will be set as the ampholyte in this standard.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
					Adder[Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample],Object[Sample]}]]
					]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankAmpholyteTargetConcentrations,
				Default->Automatic,
				Description->"The concentration (Vol/Vol) of amphoteric molecules in the master mix. When specifying values for each of Blanks, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When BlankPremadeMasterMix is set to False and BlankAmpholyteTargetConcentrations is set to Automatic, AmpholyteTargetConcentrations will be set to 4% if one ampholyte is given, and 2% each, if more than one ampholyte is set and no AmpholyteVolume values are given. If volume is given concentration will be calculated considering Ampholyte concentrations as 100%.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
						Units->VolumePercent],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
								Units->VolumePercent],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
						]
					]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankAmpholyteVolume,
				Default->Automatic,
				Description->"The volume of amphoteric molecule stocks to add to the master mix. When specifying values for each of Blanks, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When BlankAmpholyteVolume is set to Automatic and BlankPremadeMasterMix is set to False, BlankAmpholyteVolume is set to the volume needed to reach the given AmpholyteTargetConcentrations based in the TotalVolume.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.1*Microliter,200*Microliter],
						Units->{Microliter,{Milliliter,Microliter}}],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.1*Microliter,200*Microliter],
								Units->{Microliter,{Milliliter,Microliter}}],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
						]
					]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankIsoelectricPointMarkers,
				Default->Automatic,
				Description->"Reference analytes, usually peptides with known isoelectric points, that are included in the master mix and are used to convert position in the capillary to the pI it represents. The mastermix for each sample should have two isoelectric point markers. A linear fit is then used to directly interpret the pI for each position between the two markers. When specifying values for each of Blanks, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When BlankIsoelectricPointMarkers is set to Automatic and BlankPremadeMasterMix is False, {Model[Sample,StockSolution, \"Resuspended cIEF pI Marker - 4.05\"], Model[Sample,StockSolution, \"Resuspended cIEF pI Marker - 9.99\"]} will be set as the BlankIsoelectricPointMarkers in this standard.",
				AllowNull->True,
				Widget->Alternatives[
					Adder[
						Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample],Object[Sample]}]]
					],
					Widget[
						Type-> Enumeration,
						Pattern:>Alternatives[Automatic|Null]]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankIsoelectricPointMarkersTargetConcentrations,
				Default->Automatic,
				Description->"The final concentration (Vol/Vol) of pI markers in the assay tube. When specifying values for each of Blanks, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When BlankIsoelectricPointMarkersTargetConcentrations is set to Automatic and BlankPremadeMasterMix is False, pI markers target concentration will be set to 1%.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
						Units->VolumePercent],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
								Units->VolumePercent],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
						]
					]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankIsoelectricPointMarkersVolume,
				Default->Automatic,
				Description->"The volume of pI marker stocks to add to the master mix. When specifying values for each of Blanks, please specify this option as a list of lists to avoid ambiguity.",
				ResolutionDescription->"When BlankIsoelectricPointMarkersVolume is set to Automatic and BlankPremadeMasterMix is False, it is set to the volume required to reach BlankIsoelectricPointMarkersTargetConcentrations in BlankTotalVolume.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.1*Microliter,200*Microliter],
						Units->{Microliter,{Milliliter,Microliter}}],
					Adder[
						Alternatives[
							Widget[
								Type->Quantity,
								Pattern:>RangeP[0.1*Microliter,200*Microliter],
								Units->{Microliter,{Milliliter,Microliter}}],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]]
						]
					]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankElectroosmoticFlowBlocker,
				Default->Automatic,
				Description->"Electroosmotic flow blocker solution, usually methyl cellulose, to include in the master mix. Electroosmotic flow referes to the motion of liquids in a capillary as a result of applied voltage across it. Electroosmotic flow is most significant when channel diameters are very small. In capillary isoelectric focusing, the charge of the capillary wall should be masked to minimize the electroosmotic flow.",
				ResolutionDescription->"When BlankElectroosmoticFlowBlocker is set to Automatic and BlankPremadeMasterMix is False, BlankElectroosmoticFlowBlocker will be set to Model[Sample,\"1% Methyl Cellulose\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankElectroosmoticFlowBlockerTargetConcentrations,
				Default->Automatic,
				Description->"The concentration of ElectroosmoticFlowBlocker in the master mix.",
				ResolutionDescription->"When BlankElectroosmoticFlowBlockerTargetConcentrations is set to Automatic and BlankPremadeMasterMix is False, it is set to 0.35% if no BlankElectroosmoticFlowBlockerVolume is set.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.001*MassPercent,100*MassPercent],
					Units->MassPercent
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankElectroosmoticFlowBlockerVolume,
				Default->Automatic,
				Description->"The volume of ElectroosmoticBlocker stock to add to the master mix.",
				ResolutionDescription->"When BlankElectroosmoticFlowBlockerVolume is set to Automatic and BlankPremadeMasterMix is False, it is calculated based on BlankTotalVolume and the given BlankElectroosmoticFlowBlockerTargetConcentrations.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankDenature,
				Default->Automatic,
				Description->"Indicates if a DenaturationReagent should be added to the master mix.",
				ResolutionDescription->"When BlankDenature is set to Automatic and BlankPremadeMasterMix is False, BlankDenature will be set to False.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankDenaturationReagent,
				Default->Automatic,
				Description->"The denaturing agent, e.g., Urea or SimpleSol, to be added to the master mix to prevent protein precipitation.",
				ResolutionDescription->"When BlankDenaturationReagent is set to Automatic, BlankPremadeMasterMix is False, and BlankDenature is True, BlankDenaturationReagent will be set to Model[Sample,StockSolution,\"8M Urea\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankDenaturationReagentTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of the denaturing agent in the master mix.",
				ResolutionDescription->"When BlankDenaturationReagentTargetConcentration is set to Automatic, BlankPremadeMasterMix is False, and BlankDenature is True, it is set to 4M if no BlankDenaturationReagentVolume value is given. If BlankDenaturationReagentVolume is set and the concentration of BlankDenaturationReagent is known, BlankDenaturationReagentTargetConcentration is calculated.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0*Molar],
						Units->{1,{Molar,{Millimolar,Molar}}}
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0.001*VolumePercent,100*VolumePercent],
						Units->VolumePercent]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankDenaturationReagentVolume,
				Default->Automatic,
				Description->"The volume of the denaturing agent required to reach its final concentration in the master mix.",
				ResolutionDescription->"When BlankDenaturationReagentVolume is set to Automatic, BlankPremadeMasterMix is False, and BlankDenature is True, it is set to the volume required to reach BlankDenaturationReagentTargetConcentration.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankIncludeAnodicSpacer,
				Default->Automatic,
				Description->"Indicates if an anodic spacer should be added to the master mix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) is added as an AnodicSpacer.",
				ResolutionDescription->"When BlankIncludeAnodicSpacer is set to Automatic and BlankPremadeMasterMix is False, BlankIncludeAnodicSpacer will be set to False.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankAnodicSpacer,
				Default->Automatic,
				Description->"Acidic ampholyte to include in the master mix.  When analyzing a protein with very acidic pI (e.g. Pepsin), one might choose to add an AnodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the anolyte reservoir.",
				ResolutionDescription->"When BlankAnodicSpacer is set to Automatic, BlankPremadeMasterMix is False and BlankIncludeAnodicSpacer is set to True, BlankAnodicSpacer will be set to Model[Sample,StockSolution, \"200mM Iminodiacetic acid\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankAnodicSpacerTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of AnodicSpacer in the master mix.",
				ResolutionDescription->"When BlankAnodicSpacerTargetConcentration is set to Automatic, BlankPremadeMasterMix is False and BlankIncludeAnodicSpacer is set to True, it is set to 1mM when no BlankAnodicSpacerMarkersVolume is set. When BlankAnodicSpacer concentration is known and AnodicSpacerMarkersVolume is set, Automatic calculates the final concentration based on BlankAnodicSpacerTargetConcentrations and BlankTotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Millimolar],
					Units->Alternatives[
						{1,{Millimolar,{Micromolar,Millimolar,Molar}}}
					]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankAnodicSpacerVolume,
				Default->Automatic,
				Description->"The volume of AnodicSpacer stock to add to the master mix.",
				ResolutionDescription->"When BlankAnodicSpacerVolume is set to Automatic, BlankPremadeMasterMix is False and BlankIncludeAnodicSpacer is set to True, it is set to the volume required to reach BlankAnodicSpacerTargetConcentrations in BlankTotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankIncludeCathodicSpacer,
				Default->Automatic,
				Description->"Indicates if a cathodic spacer should be added to the master mix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of ampholytes, Spacers (ampholytes with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) and Arginine (pI 10.7) are added as Spacers.",
				ResolutionDescription->"When BlankIncludeCathodicSpacer is set to Automatic and BlankPremadeMasterMix is False, BlankIncludeCathodicSpacer will be set to True.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankCathodicSpacer,
				Default->Automatic,
				Description->"Basic ampholyte spacer to include in the master mix. When analyzing a protein with very basic pI (e.g. Cytochrome C), one might choose to add a CathodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the catholyte reservoir.",
				ResolutionDescription->"When BlankCathodicSpacer is set to Automatic, BlankPremadeMasterMix is False and BlankIncludeCathodicSpacer is set to True, BlankCathodicSpacer will be set to Model[Sample,StockSolution, \"500mM Arginine\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankCathodicSpacerTargetConcentration,
				Default->Automatic,
				Description->"The concentration of Cathodic spacer in the master mix.",
				ResolutionDescription->"When BlankCathodicSpacerTargetConcentration is set to Automatic, BlankPremadeMasterMix is False and BlankIncludeCathodicSpacer is set to True, it is set to 10 mM when no BlankCathodicSpacerMarkersVolume is set. When BlankCathodicSpacer concentration is known and BlankCathodicSpacerMarkersVolume is set, Automatic calculates the final concentration based on BlankCathodicSpacerTargetConcentrations and BlankTotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Millimolar],
					Units->Alternatives[
						{1,{Millimolar,{Micromolar,Millimolar,Molar}}}
					]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankCathodicSpacerVolume,
				Default->Automatic,
				Description->"The volume of Cathodic spacer stocks to add to the master mix.",
				ResolutionDescription->"When BlankCathodicSpacerVolume is set to Automatic, BlankPremadeMasterMix is False and BlankIncludeCathodicSpacer is set to True, it is set to the volume required to reach BlankAnodicSpacerTargetConcentrations in BlankTotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0.1*Microliter,200*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blank Preparation"
			},
			(* MasterMix Storage Conditions *)
			{
				OptionName->BlankAmpholytesStorageCondition,
				Default->Automatic,
				Description->"The non-default storage condition for ampholyte stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				ResolutionDescription->"When Automatic, resolve according to the resolved ampholytes.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Post Experiment"
			},
			{
				OptionName->BlankIsoelectricPointMarkersStorageCondition,
				Default->Automatic,
				Description->"The non-default storage condition for IsoelectricPointMarker stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				ResolutionDescription->"When Automatic, resolve according to the resolved isoelectricPointMarkers.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
					Adder[Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]]
				],
				Category->"Post Experiment"
			},
			{
				OptionName->BlankDenaturationReagentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for DenaturationReagent stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->BlankAnodicSpacerStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for AnodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->BlankCathodicSpacerStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->BlankElectroosmoticFlowBlockerStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			{
				OptionName->BlankDiluentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for Diluent of this experiment after the protocol is completed. If left unset, Diluent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Post Experiment"
			},
			(* Separation conditions - Index-matched to Blanks*)
			{
				OptionName->BlankLoadTime,
				Default->Automatic,
				Description->"Time to load standards in master mix into the capillary by vacuum.",
				ResolutionDescription->"When BlankLoadTime is set to Automatic and IncludeBlanks is True, BlankLoadTime is set to 55 seconds.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1*Second,300*Second],
					Units->{Second,{Second,Minute}}
				],
				Category->"Blank Separation"
			},
			{
				OptionName->BlankVoltageDurationProfile,
				Default->Automatic,
				Description->"Series of voltages and durations to apply onto the capillary for separation. Supports up to 20 steps where each step is 0-600 minutes, and 0-5000 volts.",
				ResolutionDescription->"When BlankVoltageDurationProfile is set to Automatic and IncludeBlanks is True, BlankVoltageDurationProfile is set to a two-step focusing: 1500 Volts for 1 Minute, followed by 3000 Volts for 10 minutes.",
				AllowNull->True,
				Widget->Adder[{
					"Voltage"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0.001*Volt,5000*Volt],
						Units->Volt
					],
					"Time"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0.01*Minute,600*Minute],
						Units->{Minute,{Second,Minute,Hour}}
					]
				},
					Orientation->Vertical
				],
				Category->"Blank Separation"
			},
			(* Imaging settings *)
			{
				OptionName->BlankImagingMethods,
				Default->Automatic,
				Description->"Whole capillary imaging by Either UVAbsorbance (280 nm) alone or both UVAbsorbance and Native Fluorescence (Ex 280 nm, Em 320-450nm).",
				ResolutionDescription->"When BlankImagingMethods is set to Automatic and IncludeBlanks is True, BlankImagingMethods is set to imaging by both UVAbsorbance and NativeFluorescence.",
				AllowNull->True,
				Widget->Widget[
						Type->Enumeration,
						Pattern:>Absorbance|AbsorbanceAndFluorescence
				],
				Category->"Blank Separation"
			},
			{
				OptionName->BlankNativeFluorescenceExposureTime,
				Default->Automatic,
				Description->"Exposure duration for NativeFluorescence detection.",
				ResolutionDescription->"When BlankNativeFluorescenceExposureTime is set to Automatic and IncludeBlanks is True, BlankNativeFluorescenceExposureTime is set to imaging for 3, 5, 10, and 20 seconds.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[1*Second,200*Second],
						Units->{Second,{Minute,Second,Millisecond}}],
					Adder[Widget[
						Type->Quantity,
						Pattern:>RangeP[1*Second,200*Second],
						Units->{Second,{Minute,Second,Millisecond}}]
					]
				],
				Category->"Blank Separation"
			}
		],
		(* Shared Options *)
		AliquotOptions,
		FuntopiaSharedOptions,
		SamplesInStorageOptions,
		SimulationOption
	}
];

(* ::Subsubsection::Closed:: *)
(* Errors and Messages *)
Error::CIEFBlanksFalseOptionsSpecifiedError="IncludeBlanks was set to False while other related options have been specified for Blanks. Please set IncludeBlanks to True or change the related options to Null or Automatic.";
Error::CIEFStandardsFalseOptionsSpecifiedError="IncludeStandards was set to False while other related options have been specified for Standards. Please set IncludeStandards to True or change the related options to Null or Automatic.";
Error::CIEFIncompatibleCartridge="The specified experiment cartridge `1` is not compatible with capillary Isoelectric Focusing. Set Cartridge to an Object or Model that is compatible with ExperimentType cIEF.";
Error::CIEFDiscardedCartridge="The specified cartridge `1` for capillary Isoelectric Focusing experiment has been discarded. Please choose another Cartridge object or model.";
Error::InjectionTableReplicatesSpecified="Both an injection table and number of replicates were specified. Please specify either InjectionTable or NumberOfReplicates, but not both.";
Error::InjectionTableVolumeZero="An entry in the injection table `1` has been specified with a 0 Microliter volume. Please use the NumberOfReplicates option to set repeated injections.";
Error::TooManyInjectionsCapillaryIsoelectricFocusing="The number of injections specified for samples, standards, and blanks (`1`) exceeds the number of injections possible for each batch (100, or 96 if OnBoardMixing is used). Please consider splitting this protocol to multiple protocols.";
Error::NotEnoughUsesLeftOnCIEFCartridge="This protocol requires more injections than the capillary Isoelectric Focusing cartridge `1` has left (`2` injections). Please consider splitting this protocol or using another cartridge.";
Warning::NotEnoughOptimalUsesLeftOnCIEFCartridge="This protocol requires more injections than the capillary Isoelectric Focusing cartridge `1` has left for optimal conditions (`2` injections). Please consider splitting this protocol or using another cartridge.";
Error::CIEFInjectionTableMismatch="The specified injection table is different from the specified SamplesIn, Standards, and/or Blanks. The following objects differ (present in either the InjectionTable or inputs, but not both): `1`. Please make sure that all sample, standard, and blank objects in the injection table are also specified in SamplesIn, Standards, and Blanks, or set to Automatic for the InjectionTable to be resolved based of the inputs.";
Error::CIEFTotalVolumeNull="The specified TotalVolume for `1` cannot be set to Null. Please make sure to set a valid value or set to Automatic.";
Error::CIEFIncludeTrueFrequencyNullError="`1` was set to True and `2` was set to Null for `3`. Please make sure `2` is set to a valid value or to Automatic.";
Error::CIEFLoadTimeNullError="The specified LoadTime for `1` cannot be set to Null. Please make sure to set a valid value or set to Automatic.";
Warning::CIEFPreMadeMasterMixWithMakeOwnOptions="Options for both premade master mix and modular master mix are specified for `1`. These options are exclusive to each other and only premade master mix options will take effect. If you don't wish to use a PremadeMasterMix, make sure to set this option to False.";
Warning::CIEFMissingSampleComposition="Sample composition is missing for `1`. As a result, sample Volume can't be accurately calculated to reach 0.2 mg/mL protein and defaulted to 10% of the TotalVolume, or to 25 microliters if OnBoardMixing is True. Please specify the volume if desired.";
Error::CIEFOnBoardMixingIncompatibleVolumes="Total and sample volumes specified for `1` are incompatible with OnBoardMixing. The total volume must be 125 microliters and the sample volume must be 25 microliters for OnBoardMixing. Please change the total volume and/or sample volume, set them to Automatic, or consider switching OnBoardMixing to False.";
Error::CIEFMoreThanOneMasterMixWithOnBoardMixing="More than one master mix composition has been specified while OnBoardMixing is set to True (for the following options:`1`). OnboardMixing can only be used with a single master mix composition. Please make sure that reagents, concentrations and volume are the same for all sample or consider setting OnBoardMixing to False.";
Warning::OnBoardMixingVolume="Onboard mixing requires a minimum volume in each vial in order to run reliably. As a result, an extra `1` of the prepared sample mix will be required.";
Error::CIEFimagingMethodMismatch="The imaging methods set for `1` are not copacetic with the specified fluorescence imaging times. Please make sure the two options are in agreement, or set one or both to Automatic.";
Error::CIEFInvalidVoltageDurationProfile="The number of VoltageDurationProfile Steps for `1` is not within the accepted range (1-20 steps). Please make sure VoltageDuration profiles have 1-20 steps.";
(* premade mastermix branch (same as in experimentCapillaryGelElectrophoresis) *)
Error::CIEFPremadeMastermixFalseOptionsSpecifiedError="PremadeMasterMix was set to False while other related options have been specified for `1`. Please set PremadeMasterMix to True or change the related options to Null or Automatic.";
Error::CIEFPremadeMasterMixReagentNull="PremadeMasterMixReagent is set to Null while premade master mix is True for `1`. Please make sure the premade master mix reagent object is specified or set premade master mix to False.";
Error::CIEFPremadeMasterMixDilutionFactorNull="PremadeMasterMixReagent's dilution factor is set to Null while premade master mix is True for `1`. Please make sure to specify either the dilution factor or the volume. Alternatively, Set premade master mix to False.";
Error::CIEFPremadeMasterMixVolumeNull="PremadeMasterMixVolume cannot be set to Null while premade master mix is set to True for `1`. Please set a valid volume or Automatic to use premade master mix reagent. Alternatively, Set premade master mix to False.";
Error::CIEFPremadeMasterMixVolumeDilutionFactorMismatch="Specified premade master mix volume and dilution factor are not copacetic. Please make sure that their values are in agreement, or set one to Automatic.";
Error::CIEFPremadeMasterMixInvalidTotalVolume="Sample Volume and premade master mix volume sum up to more than the total Volume in `1`. Please make sure volumes do not exceed the total volume in the tube.";
Error::CIEFPremadeMasterMixDiluentNull="While premade master mix is True, a Diluent is missing for `1`. Please specify the desired diluent or set to Automatic.";
(* premade mastermix branch *)
Error::CIEFMakeMasterMixDiluentNull="A Diluent is missing for `1` while other master mix components do not sum up to the total volume. Please specify the desired diluent or set to Automatic.";
Error::CIEFMakeMasterMixAmpholytesNull="Ampholytes are not specified for `1` while a premade master mix is set to False. Ampholytes are crucial for capillary isoelectric focusing. Please specify the desired ampholytes or set to Automatic.";
Error::CIEFMakeMasterMixAmpholyteOptionLengthsNotCopacetic="The number of items specified for Ampholyte objects, target concentrations, and/or volumes for `1` does not match. Please make sure target concentrations and volumes are specified only for the chosen ampholyte objects or set to Automatic.";
Error::CIEFMakeMasterMixAmpholytesVolumesNull="Ampholyte volumes are not specified for `1` while a premade master mix is set to False. Ampholytes are crucial for capillary isoelectric focusing. Please specify the desired volumes or set to Automatic.";
Error::CIEFMakeMasterMixAmpholytesConcentrationNull="Ampholyte target concentrations are not specified for `1` while a premade master mix is set to False. Ampholytes are crucial for capillary isoelectric focusing. Please specify the desired target concentrations or set to Automatic.";
Error::CIEFMakeMasterMixAmpholytesVolumeConcentrationMismatch="Ampholyte target concentrations and volumes are not in agreement for `1`. Please make sure volumes and concentrations are in agreemment or set one of these options to Automatic.";
Error::CIEFMakeMasterMixIsoelectricPointMarkersNull="IsoelectricPointMarkers are not specified for `1` while a premade master mix is set to False. IsoelectricPointMarkers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired ampholytes or set to Automatic.";
Error::CIEFMakeMasterMixIsoelectricPointMarkerOptionLengthsNotCopacetic="The number of items specified for IsoelectricPointMarker objects, target concentrations, and/or volumes for `1` does not match. Please make sure target concentrations and volumes are specified only for the chosen ampholyte objects or set to Automatic.";
Error::CIEFMakeMasterMixIsoelectricPointMarkersVolumesNull="IsoelectricPointMarker volumes are not specified for `1` while a premade master mix is set to False. IsoelectricPointMarkers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired volumes or set to Automatic.";
Error::CIEFMakeMasterMixIsoelectricPointMarkersConcentrationNull="IsoelectricPointMarker target concentrations are not specified for `1` while a premade master mix is set to False. IsoelectricPointMarkers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired target concentrations or set to Automatic.";
Error::CIEFMakeMasterMixIsoelectricPointMarkersVolumeConcentrationMismatch="IsoelectricPointMarker target concentrations and volumes are not in agreement for `1`. Please make sure volumes and concentrations are in agreement or set one of these options to Automatic.";
Error::CIEFMakeMasterMixElectroosmoticFlowBlockersNull="An ElectroosmoticFlowBlocker was not specified for `1` while a premade master mix is set to False. ElectroosmoticFlowBlockers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired ampholytes or set to Automatic.";
Warning::CIEFMakeMasterMixElectroosmoticFlowBlockerComposition="The composition of the ElectroosmoticFlowBlocker object/model does not have a known elerctroosmotic flow blocking agent (e.g., methyl cellulose) for `1`. Volumes were calculated assuming a 1% concentration.";
Error::CIEFMakeMasterMixElectroosmoticFlowBlockersVolumesNull="ElectroosmoticFlowBlocker volumes are not specified for `1` while a premade master mix is set to False. ElectroosmoticFlowBlockers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired volumes or set to Automatic.";
Error::CIEFMakeMasterMixElectroosmoticFlowBlockersConcentrationNull="ElectroosmoticFlowBlocker target concentrations are not specified for `1` while a premade master mix is set to False. ElectroosmoticFlowBlockers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired target concentrations or set to Automatic.";
Error::CIEFMakeMasterMixElectroosmoticFlowBlockersVolumeConcentrationMismatch="ElectroosmoticFlowBlocker target concentrations and volumes are not in agreement for `1`. Please make sure volumes and concentrations are in agreement or set one of these options to Automatic.";
Error::CIEFMakeMasterMixDenatureFalseOptionsSpecifiedErrors="Denature was set to False while other related options have been specified for `1`. Please set Denature to True or change the related options to Null or automatic.";
Error::CIEFMakeMasterMixDenaturationReagentsNull="A DenaturationReagent was not specified for `1` while Denature is set to True. DenaturationReagents are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired ampholytes or set to Automatic.";
Warning::CIEFMakeMasterMixDenaturationReagentComposition="The composition of the DenaturationReagent object/model does not have a known denaturation agent (e.g., SimpleSol and Urea) for `1`.Volumes will be calculated assuming the stock solution concentration is 10 M. Consider specifying a different object/model or specify the volume to be added to the master mix.";
Error::CIEFMakeMasterMixDenaturationReagentsVolumesNull="DenaturationReagent volumes are not specified for `1` while Denature is set to True. DenaturationReagents are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired volumes or set to Automatic.";
Error::CIEFMakeMasterMixDenaturationReagentsConcentrationNull="DenaturationReagent target concentrations are not specified for `1` while Denature is set to True. DenaturationReagents are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired target concentrations or set to Automatic.";
Error::CIEFMakeMasterMixDenaturationReagentsVolumeConcentrationMismatch="The DenaturationReagent target concentrations and volumes are not in agreement for `1`. Please make sure volumes and concentrations are in agreement or set one of these options to Automatic.";
Warning::CIEFresolveableDenatureReagentConcentrationUnitMismatch="The DenaturationReagent target concentration unit (VolumePercent) does not match that of the DenaturationReagent object/model for `1`. The volume has been calculated considering the reagent's concentration as 100%. Please consider specifying the target concentration in Molar concentration.";
Error::CIEFunresolveableDenatureReagentConcentrationUnitMismatch="The DenaturationReagent target concentration unit (Molar) does not match that of the DenaturationReagent object/model for `1`. The volume cannot be calculated. Please specify the target concentration in Molar concentration or set to automatic.";
Error::CIEFMakeMasterMixAnodicSpacerFalseOptionsSpecifiedErrors="IncludeAnodicSpacer was set to False while other related options have been specified for `1`. Please set IncludeAnodicSpacer to True or change the related options to Null or automatic.";
Error::CIEFMakeMasterMixAnodicSpacersNull="An AnodicSpacer was not specified for `1` while IncludeAnodicSpaces is set to True. AnodicSpacers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired ampholytes or set to Automatic.";
Warning::CIEFMakeMasterMixAnodicSpacerComposition="The composition of the AnodicSpacer object/model does not have a known anodic spacer (e.g., Iminodiacetic acid) for `1`. Volumes will be calculated assuming the anodic spacer's stock solution concentration is 200 mM. Consider specifying a different object/model or specify the volume to be added to the master mix.";
Error::CIEFMakeMasterMixAnodicSpacersVolumesNull="AnodicSpacer volumes are not specified for `1` while IncludeAnodicSpaces is set to True. AnodicSpacers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired volumes or set to Automatic.";
Error::CIEFMakeMasterMixAnodicSpacersConcentrationNull="AnodicSpacer target concentrations are not specified for `1` while IncludeAnodicSpaces is set to True. AnodicSpacers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired target concentrations or set to Automatic.";
Error::CIEFMakeMasterMixAnodicSpacersVolumeConcentrationMismatch="AnodicSpacer target concentrations and volumes are not in agreement for `1`. Please make sure volumes and concentrations are in agreement or set one of these options to Automatic.";
Error::CIEFMakeMasterMixCathodicSpacerFalseOptionsSpecifiedErrors="IncludeCathodicSpacer was set to False while other related options have been specified for `1`. Please set IncludeCathodicSpacer to True or change the related options to Null or automatic.";
Error::CIEFMakeMasterMixCathodicSpacersNull="An CathodicSpacers was not specified for `1` while IncludeCathodicSpaces is set to True. CathodicSpacers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired ampholytes or set to Automatic.";
Warning::CIEFMakeMasterMixCathodicSpacerComposition="The composition of the CathodicSpacer object/model does not have a known cathodic spacer (e.g., arginine) for `1`. Volumes will be calculated assuming the cathodic spacer's stock solution concentration is 500 mM. Consider specifying a different object/model or specify the volume to be added to the master mix.";
Error::CIEFMakeMasterMixCathodicSpacersVolumesNull="CathodicSpacer volumes are not specified for `1` while IncludeCathodicSpaces is set to True. CathodicSpacers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired volumes or set to Automatic.";
Error::CIEFMakeMasterMixCathodicSpacersConcentrationNull="CathodicSpacer target concentrations are not specified for `1` while IncludeCathodicSpaces is set to True. CathodicSpacers are crucial for the analysis of capillary isoelectric focusing data. Please specify the desired target concentrations or set to Automatic.";
Error::CIEFMakeMasterMixCathodicSpacersVolumeConcentrationMismatch="CathodicSpacer target concentrations and volumes are not in agreement for `1`. Please make sure volumes and concentrations are in agreement or set one of these options to Automatic.";
Error::CIEFSumOfVolumesOverTotalVolume="The sum total of reagent volumes specified exceeds the TotalVolume for `1`. Please make sure that the sum of ampholytes, isoelectric point markers, denaturation reagent, and spacer volumes does not exceed the TotalVolume.";

(* ::Subsubsection::Closed:: *)
(* singleton sample overload *)
ExperimentCapillaryIsoelectricFocusing[mySample:ObjectP[Object[Sample]],myOptions:OptionsPattern[ExperimentCapillaryIsoelectricFocusing]]:=ExperimentCapillaryIsoelectricFocusing[{mySample},myOptions];

(* ExperimentCapillaryIsoelectricFocusing Main Function (Sample overload) *)
ExperimentCapillaryIsoelectricFocusing[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedSamples,listedOptions,outputSpecification,output,gatherTests,messages,safeOptions,
		safeOptionTests,mySamplesWithPreparedSamplesNamed,safeOptionsNamed, myOptionsWithPreparedSamplesNamed,
		validLengths,validLengthTests,upload,confirm,fastTrack,parentProt,inheritedCache,nestedMultipleOptions,
		unresolveOptionsListedMultiples,unresolvedOptions,specifiedInjectionTable,applyTemplateOptionTests,combinedOptions,expandedCombinedOptions,
		sampleModelPreparationPacket,samplePreparationPacket,resolveOptionsResult,resolvedOptions,resolutionTests,
		resolvedOptionsNoHidden,returnEarlyQ,cacheBall,finalizedPacket,resourcePacketTests,validSamplePreparationResult,
		mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,allTests,protocolObject,testsRule,optionsRule,validQ,
		specifiedInstrument,specifiedCartridge,allContainerModels,allContainerObjects,allInstrumentObjects,containerFields,
		containerModelFieldsThroughLinks,containerModelFields,allSampleObjects,sampleContainerFields,sampleContainerModelFields,
		allReagentsModels,reagentFields,optionsWithObjects,userSpecifiedObjects,simulatedSampleQ,
		objectsExistQs,objectsExistTests,updatedSimulation,performSimulationQ,simulatedProtocol,simulation
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Remove temporal links. *)
	{listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentCapillaryIsoelectricFocusing,
			listedSamples,
			listedOptions
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

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed,safeOptionTests}=If[gatherTests,
		SafeOptions[ExperimentCapillaryIsoelectricFocusing,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentCapillaryIsoelectricFocusing,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitizeInputs to replace named samples with ids *)
	{mySamplesWithPreparedSamples,safeOptions,myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed, myOptionsWithPreparedSamplesNamed];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOptionTests,
			Options->$Failed,
			Preview->Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length - Does not check nested  *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentCapillaryIsoelectricFocusing,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentCapillaryIsoelectricFocusing,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1],Null}
	];


	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOptionTests,validLengthTests],
			Options->$Failed,
			Preview->Null,
			Simulation -> Null
		}]
	];

	(* get assorted hidden options *)
	{upload,confirm,fastTrack,parentProt,inheritedCache}=Lookup[safeOptions,{Upload,Confirm,FastTrack,ParentProtocol,Cache}];

	(* Use any template options to get values for options not specified in myOptions *)
	{unresolvedOptions,applyTemplateOptionTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentCapillaryIsoelectricFocusing,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentCapillaryIsoelectricFocusing,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1,Output->Result],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[unresolvedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOptionTests,validLengthTests,applyTemplateOptionTests],
			Options->$Failed,
			Preview->Null,
			Simulation -> Null
		}]
	];

	(* before expanding options, we need to make sure all specified nested-multiple options are in lists before expanding,
	otherwise it might mess things up. *)

	(* First, make a list of options to look out for as nested multiples *)
	nestedMultipleOptions =
		{
			Ampholytes,AmpholyteTargetConcentrations,AmpholyteVolume,AmpholytesStorageCondition,
			IsoelectricPointMarkers,IsoelectricPointMarkersTargetConcentrations,IsoelectricPointMarkersVolume,IsoelectricPointMarkersStorageCondition,
			StandardAmpholytes,StandardAmpholyteTargetConcentrations,StandardAmpholyteVolume,StandardAmpholytesStorageCondition,
			StandardIsoelectricPointMarkers,StandardIsoelectricPointMarkersTargetConcentrations,StandardIsoelectricPointMarkersVolume,StandardIsoelectricPointMarkersStorageCondition,
			BlankAmpholytes,BlankAmpholyteTargetConcentrations,BlankAmpholyteVolume,BlankAmpholytesStorageCondition,
			BlankIsoelectricPointMarkers,BlankIsoelectricPointMarkersTargetConcentrations,BlankIsoelectricPointMarkersVolume,BlankIsoelectricPointMarkersStorageCondition
		};

	(* now, map over all specified options and make sure the ones that are have elements listed *)
	unresolveOptionsListedMultiples = KeyValueMap[
		Function[{key, value},
			(* If this option is a nested multiple, make sure each element is listed *)
			If[MemberQ[nestedMultipleOptions, key],
				If[MatchQ[value, _List],
					(* If the length of the list is equal to the length of Samples In or the number of unique values is smaller than the number of values (hence assuming a user would not repeat the same reagent twice), assume each value is match to a sample and listify it if it isnt already. This is not perfect, but the best I can do at the moment..  *)
					If[Length[value] == Length[mySamplesWithPreparedSamples]||Length[DeleteDuplicates[value]]<Length[value],
						Rule[
							key,
							Map[Function[valueElement, ToList[valueElement]], value]
						],
						(* Otherwise, we can assume the list of elements relates to each sample *)
						Rule[
							key,
							value
						]
					],
					(* If not a list, make is a list *)
					Rule[
						key,
						ToList[value]
					]
				],
			(* if its not a nested multiple, just keep as is *)
				Rule[
					key,
					value
				]
			]
		],
		Association[unresolvedOptions]
	];

	(* if a template was applied, we need to make sure not to take its injection table (because it will not apply, by definition) but also need to make sure we dont omit a specified injection table *)
	specifiedInjectionTable = {InjectionTable->Lookup[safeOptions, InjectionTable]};

	(* Replace our safe options with our inherited options from our template. *)
	combinedOptions=ReplaceRule[safeOptions,ReplaceRule[unresolveOptionsListedMultiples, specifiedInjectionTable]];

	(* Expand index-matching options *)
	expandedCombinedOptions=Last[ExpandIndexMatchedInputs[ExperimentCapillaryIsoelectricFocusing,{mySamplesWithPreparedSamples},combinedOptions,1]];

	(* get all of the sample objects*)
	(*don't include cache because that's a bad time when simulating with Prep Primitves*)
	allSampleObjects=DeleteDuplicates[Cases[KeyDrop[combinedOptions,{Simulation, Cache}],ObjectReferenceP[Object[Sample]],Infinity]];

	(* mostly for reagents, grab them off of options so we can download *)
	reagentFields={Anolyte,Catholyte,ElectroosmoticConditioningBuffer,
		FluorescenceCalibrationStandard,WashSolution,PremadeMasterMixReagent,PremadeMasterMixDiluent,Diluent,Ampholytes,
		IsoelectricPointMarkers,ElectroosmoticFlowBlocker,AnodicSpacer,CathodicSpacer,DenaturationReagent,Standards,Blanks,
		StandardPremadeMasterMixReagent,StandardPremadeMasterMixDiluent,StandardDiluent,StandardAmpholytes,
		StandardIsoelectricPointMarkers,StandardElectroosmoticFlowBlocker,StandardAnodicSpacer,StandardCathodicSpacer,
		StandardDenaturationReagent, BlankPremadeMasterMixReagent,BlankPremadeMasterMixDiluent,BlankDiluent,BlankAmpholytes,
		BlankIsoelectricPointMarkers,BlankElectroosmoticFlowBlocker,BlankAnodicSpacer,BlankCathodicSpacer, BlankDenaturationReagent};

	allReagentsModels=DeleteDuplicates[
		Join[(* add models to download by default, get their Object ID *)
			Download[{
				Model[Sample,StockSolution,"8M Urea"],
				Model[Sample,StockSolution,"10M Urea"],
				Model[Sample, "SimpleSol"],
				Model[Sample,StockSolution, "200mM Iminodiacetic acid"],
				Model[Sample,StockSolution, "500mM Arginine"],
				Model[Sample,"Pharmalyte pH 3-10"],
				Model[Sample,"Pharmalyte pH 2.5-5"],
				Model[Sample,"Pharmalyte pH 5-8"],
				Model[Sample,"Pharmalyte pH 8-10.5"],
				Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 10.17" ],
				Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 9.99" ],
				Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 9.50" ],
				Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 8.40" ],
				Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 7.05" ],
				Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 6.14" ],
				Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 5.85" ],
				Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 4.05"],
				Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 3.38" ],
				Model[Sample,"0.5% Methyl Cellulose"],
				Model[Sample,"1% Methyl Cellulose"],
				Model[Sample,"0.08M Phosphoric Acid in 0.1% Methyl Cellulose"],
				Model[Sample,"0.1M Sodium Hydroxide in 0.1% Methyl Cellulose"],
				Model[Sample,"cIEF Fluorescence Calibration Standard"],
				Model[Sample,StockSolution,"Resuspended cIEF System Suitability Peptide Panel"],
				Model[Sample,"cIEF System Suitability Test Mix"]
			},Object],
			Cases[Lookup[combinedOptions,reagentFields],ObjectReferenceP[Model[Sample]],Infinity]]];

	(* download container models *)
	allContainerModels=DeleteDuplicates[Flatten[{
		Model[Container, Plate, "96-Well Full-Skirted PCR Plate"],
		Model[Container, Vessel, "Maurice Reagent Glass Vials, 2mL"],
		Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling, ContainerType->Model[Container,Vessel]],
		Cases[combinedOptions, ObjectReferenceP[{Model[Container]}], Infinity]
	}]];

	allContainerObjects=Cases[combinedOptions,ObjectReferenceP[{Object[Container]}],Infinity];

	(* get instrument and Cartridge packets *)
	allInstrumentObjects=DeleteDuplicates[Flatten[{
		Cases[combinedOptions,ObjectReferenceP[{Object[Instrument,ProteinCapillaryElectrophoresis],Model[Instrument,ProteinCapillaryElectrophoresis]}],Infinity],
		Search[Model[Instrument,ProteinCapillaryElectrophoresis],Deprecated!=True]
	}]];

	{specifiedInstrument,specifiedCartridge}=Lookup[expandedCombinedOptions,{Instrument,Cartridge}];

	(*fields not in the object: DefaultThawTime, DefaultThawTemperature,MolecularWeight*)
	(* Set up the samplePreparationPacket using SamplePreparationCacheFields*)
	samplePreparationPacket=Packet[SamplePreparationCacheFields[Object[Sample],Format->Sequence],Deprecated,UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials,LiquidHandlerIncompatible,Tablet,TabletWeight,TransportWarmed,TransportChilled];
	sampleModelPreparationPacket=Packet[Model[Flatten[{Products,Deprecated,UsedAsSolvent,ConcentratedBufferDiluent,ConcentratedBufferDilutionFactor,BaselineStock,IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
	sampleContainerFields=Packet[Container[{Model,SamplePreparationCacheFields[Object[Container],Format->Sequence]}]];
	sampleContainerModelFields=Packet[Container[Model][{MaxVolume,Name,Dimensions,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container],Format->Sequence]}]];
	containerFields=Packet[Model,SamplePreparationCacheFields[Object[Container],Format->Sequence]];
	containerModelFieldsThroughLinks=Packet[Model[{Name,MaxVolume,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container],Format->Sequence]}]];
	containerModelFields=Packet[Name,MaxVolume,DefaultStorageCondition,ConnectionType,SamplePreparationCacheFields[Model[Container],Format->Sequence]];

	(* - Throw an error and return failed if any of the specified Objects are not members of the database - *)
	(* Any options whose values _could_ be an object *)
	optionsWithObjects={
		Instrument,
		Cartridge,
		InjectionTable,
		Standards,
		Blanks,
		Anolyte,
		Catholyte,
		ElectroosmoticConditioningBuffer,
		FluorescenceCalibrationStandard,
		WashSolution,
		PremadeMasterMixReagent,
		Ampholytes,
		IsoelectricPointMarkers,
		ElectroosmoticFlowBlocker,
		DenaturationReagent,
		AnodicSpacer,
		CathodicSpacer,
		StandardPremadeMasterMixReagent,
		StandardAmpholytes,
		StandardIsoelectricPointMarkers,
		StandardElectroosmoticFlowBlocker,
		StandardDenaturationReagent,
		StandardAnodicSpacer,
		StandardCathodicSpacer,
		BlankPremadeMasterMixReagent,
		BlankAmpholytes,
		BlankIsoelectricPointMarkers,
		BlankElectroosmoticFlowBlocker,
		BlankDenaturationReagent,
		BlankAnodicSpacer,
		BlankCathodicSpacer
	};

	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects=DeleteDuplicates@Cases[
		Flatten@Join[ToList[mySamples],Lookup[ToList[myOptions],optionsWithObjects,Null]],
		ObjectP[]
	];

	(* Check that the specified objects exist or are visible to the current user *)
	simulatedSampleQ=MemberQ[Download[Lookup[updatedSimulation[[1]], Packets],Object], #] &/@userSpecifiedObjects;

	objectsExistQs=DatabaseMemberQ[PickList[userSpecifiedObjects,simulatedSampleQ,False]];

	(* Build tests for object existence *)
	objectsExistTests=If[gatherTests,
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
			Result->$Failed,
			Tests->Join[safeOptionTests,validLengthTests,applyTemplateOptionTests,objectsExistTests],
			Options->$Failed,
			Preview->Null,
			Simulation -> Null
		}]
	];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall=Quiet[
		Cases[Flatten[{Download[
			{
				ToList[mySamplesWithPreparedSamples],
				allSampleObjects,
				{specifiedCartridge},
				allReagentsModels,
				allInstrumentObjects,
				allContainerModels
			},
			{
				{
					samplePreparationPacket,
					sampleModelPreparationPacket,
					Packet[Composition],
					Packet[Composition[[All,2]][MolecularWeight]],
					sampleContainerFields,
					sampleContainerModelFields
				},
				{
					samplePreparationPacket,
					sampleModelPreparationPacket,
					Packet[Composition],
					Packet[Composition[[All,2]][MolecularWeight]],
					sampleContainerFields,
					sampleContainerModelFields
				},
				{
					Packet[Name,Model,ExperimentType,Status,NumberOfUses,MaxInjections,MaxNumberOfUses,OptimalMaxInjections,
						MaxInjectionsPerBatch],
					Packet[Model[{Name,ExperimentType,MaxInjections,MaxNumberOfUses,OptimalMaxInjections,
						MaxInjectionsPerBatch}]]
				},
				{
					Evaluate[Packet[Deprecated,Products,UsedAsSolvent,ConcentratedBufferDiluent,ConcentratedBufferDilutionFactor,BaselineStock,IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample],Format->Sequence]]],
					Packet[Analytes],
					Packet[Composition],
					Packet[Composition[[All,2]][{CAS,InChI,InChIKey,Synonyms,Name,MolecularWeight}]]
				},
				{
					Packet[Model,Name,WettedMaterials,OnBoardMixing],
					Packet[Model[{Name,WettedMaterials,OnBoardMixing}]]
				},
				{
					containerModelFields
				}
			},
			Cache->inheritedCache,
			Simulation->updatedSimulation,
			Date->Now
		]}],
		PacketP[]
	],
	{Download::NotLinkField,Download::FieldDoesntExist}];

	(* Build the resolved options *)

	(* when calling the resolver, we will add another field in our options to also pass a list of unresolved options,
	 so we can display relevant options in errors *)

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolutionTests}=resolveCapillaryIsoelectricFocusingOptions[mySamplesWithPreparedSamples,Append[expandedCombinedOptions, Rule[UnresolvedOptions, Keys[unresolvedOptions]]],Output->{Result,Tests},Cache->cacheBall,Simulation->updatedSimulation];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolutionTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolutionTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolutionTests}={resolveCapillaryIsoelectricFocusingOptions[mySamplesWithPreparedSamples,Append[expandedCombinedOptions, Rule[UnresolvedOptions, Keys[unresolvedOptions]]],Output->Result,Cache->cacheBall,Simulation->updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* remove the hidden options and collapse the expanded options if necessary *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentCapillaryIsoelectricFocusing,
		RemoveHiddenOptions[ExperimentCapillaryIsoelectricFocusing,resolvedOptions],
		Messages->False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ=Which[
		MatchQ[resolveOptionsResult,$Failed],
			True,
		gatherTests,
			Not[RunUnitTest[<|"Tests"->resolutionTests|>,
				Verbose->False,
				OutputFormat->SingleBoolean]],
		True,
			False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];

	(* if resolveOptionsResult is $Failed and we're not in simulation, return early; messages would have been thrown already *)
	If[returnEarlyQ && !performSimulationQ,
		Return[outputSpecification/.{
			Result->$Failed,
			Options->resolvedOptionsNoHidden,
			Tests->Flatten[{safeOptionTests,applyTemplateOptionTests,validLengthTests,resolutionTests}],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	(* Build packets with resources *)
	{finalizedPacket,resourcePacketTests}=If[gatherTests,
		capillaryIsoelectricFocusingResourcePackets[ToList[mySamplesWithPreparedSamples],unresolvedOptions,
			resolvedOptions,Output->{Result,Tests},Cache->cacheBall,Simulation->updatedSimulation],
		{capillaryIsoelectricFocusingResourcePackets[ToList[mySamplesWithPreparedSamples],unresolvedOptions,
			resolvedOptions,Output->Result,Cache->cacheBall,Simulation->updatedSimulation],Null}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentCapillaryIsoelectricFocusing[finalizedPacket,ToList[mySamplesWithPreparedSamples],expandedCombinedOptions,Cache->cacheBall,Simulation->updatedSimulation],
		{Null, Null}
	];

	(* get all the tests together *)
	allTests=Cases[Flatten[{
		safeOptionTests,
		applyTemplateOptionTests,
		validLengthTests,
		resolutionTests,
		resourcePacketTests}],_EmeraldTest];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests ->allTests,
			Options -> resolvedOptionsNoHidden,
			Preview -> Null,
			Simulation->simulation
		}]
	];

	(* the tricky part is that if the Output option includes Tests _and_ Result, messages will be suppressed.
		Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed
		Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ=Which[
		(* needs to be MemberQ because could possibly generate multiple protocols *)
		MatchQ[finalizedPacket,$Failed],
			False,
		gatherTests&&MemberQ[output,Result],
			RunUnitTest[<|"Tests"->allTests|>,OutputFormat->SingleBoolean,Verbose->False],
		True,
			True
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject=Which[
		(* If resource packets could not be generated or options could not be resolved, can't generate a protocol, retun $Failed *)
		MatchQ[finalizedPacket,$Failed]||MatchQ[resolveOptionsResult,$Failed]||!validQ,
			$Failed,

		(* If we want to upload an actual protocol object. *)
		True,
			UploadProtocol[
				finalizedPacket,
				Confirm->confirm,
				Upload->upload,
				FastTrack->fastTrack,
				ParentProtocol->parentProt,
				ConstellationMessage->Object[Protocol,CapillaryIsoelectricFocusing],
				Simulation->updatedSimulation
			]
	];

	(* Return requested output *)
	(* get all options *)
	optionsRule=If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* generate the tests rule *)
	testsRule=If[gatherTests,
		allTests,
		Null
	];

	(* Return output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->testsRule,
		Options->optionsRule,
		Preview->Null,
		Simulation -> simulation
	}
];

(* ::Subsubsection::Closed:: *)
(* singleton container input *)
ExperimentCapillaryIsoelectricFocusing[myContainer:(ObjectP[{Object[Container],Object[Sample]}]|_String),myOptions:OptionsPattern[ExperimentCapillaryIsoelectricFocusing]]:=ExperimentCapillaryIsoelectricFocusing[{myContainer},myOptions];

(* ExperimentCapillaryIsoelectricFocusing Main function (container overload). *)
ExperimentCapillaryIsoelectricFocusing[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedContainers,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedSimulation,containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests,containerToSampleSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* get containers and options to lists *)
	{listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentCapillaryIsoelectricFocusing,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentCapillaryIsoelectricFocusing,
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
				ExperimentCapillaryIsoelectricFocusing,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Simulation->updatedSimulation
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[ToList[containerToSampleResult],{$Failed..}],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentCapillaryIsoelectricFocusing[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];

(* ::Subsection:: *)
(* CapillaryIsoelectricFocusingOptions Resolver *)

DefineOptions[
	resolveCapillaryIsoelectricFocusingOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveCapillaryIsoelectricFocusingOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveCapillaryIsoelectricFocusingOptions]]:=
	Module[
		{
			aliquotBools,aliquotTests,allPrecisionTests,ampolyteOptions,ampolyteOptionsPrecisionTests,ampolyteOptionsTests,blankAmpolyteOptions,
			blankAmpolyteOptionsPrecisionTests,blankAmpolyteOptionsTests,blankOptionList,blankOptions,blankPIMarkerOptions,
			blankPIMarkerOptionsPrecisionTests,blankPIMarkerOptionsTests,blanksInInjectionTableBool,capillaryIsoelectricFocusingOptions,
			capillaryIsoelectricFocusingOptionsAssociation,cartridgeCompatibleQ,cartridgeObject,cartridgePacket,compatibleMaterialsBool,
			compatibleMaterialsInvalidInputs,compatibleMaterialsTests,compositionModels,deprecatedInvalidInputs,deprecatedModelPackets,
			deprecatedTest,discardedInvalidInputs,discardedSamplePackets,discardedTest,email,engineQ,expandedBlanksOptions,expandedOptions,
			expandedStandardsOptions,expandNestedIndexMatchedTests,expandThis,fastTrack,focusingPrecisionOptions,gatherTests,
			includeBlankOptionBool,includeStandardOptionBool,includeBlanksFalseOptionsSpecifiedError,
			includeStandardsFalseOptionsSpecifiedError,incompatibleCartridgeInvalidOption,incompatibleCartridgeTest,inheritedCache,
			injectionTableBlankNotCopaceticQ,injectionTableBlankVolumes,injectionTableSamplesNotCopaceticQ,injectionTableSampleVolumes,
			injectionTableStandardNotCopaceticQ,injectionTableStandardVolumes,injectionTableValidQ,instrumentModelPacket,
			invalidInputs,invalidOptions,imagingMethodMismatchErrors,joinedExpandedOptions,keyBlankNames,
			keyBlankNamesPrependRemoved,keyStandardNames,keyStandardNamesPrependRemoved,lengthCorrectedInjectionTableBlankVolumes,
			lengthCorrectedInjectionTableStandardVolumes,mapThreadFriendlyBlankOptions,mapThreadFriendlyOptions,
			mapThreadFriendlyStandardOptions,messages,modelPacketsToCheckIfdeprecaded,nestedMatchedOptions,nestedMatchSafePreexpandedBlanksOptions,
			nestedMatchSafePreexpandedStandardsOptions,objectsByGroup,opsDef,optionObjectModelComposition,
			optionObjectModelCompositionPackets,optionObjectModelPackets,optionObjectsModels,output,outputSpecification,parentOptions,
			pIMarkerOptions,pIMarkerOptionsPrecisionTests,pIMarkerOptionsTests,precisionTests,preexpandedBlanksOptions,
			preexpandedStandardsOptions,renamedBlankOptionSet,renamedStandardOptionSet,requiredAliquotAmounts,resolvedAliquotOptions,
			requiredBlanks,resolvedBlanks,resolvedBlanksPackets,resolvedEmail,resolvedExperimentOptions,resolvedInjectionTable,resolvedOptions,
			resolvedPostProcessingOptions,resolvedSamplePrepOptions,resolvedStandards,requiredStandards,resolvedStandardsPackets,resolveIncludeBlanks,
			resolveIncludeStandards,roundedCapillaryIsoelectricFocusingOptions,roundedCIEFOptions,roundedFocusingOptions,
			roundedInjectionTableBlankVolumes,roundedInjectionTableSampleVolumes,roundedInjectionTableStandardVolumes,roundedSingletonOptions,
			sampleCompositionModelPackets,sampleModelPackets,samplePackets,samplePacketsToCheckIfDiscarded,
			samplePrepContainers,samplePrepModelSamples,samplePrepOptions,samplePrepTests,updatedSimulation,simulation,
			smallCacheBall,simulatedSamplePackets,simulatedSampleContainerPackets,simulatedSamples,singletonTests,
			specifiedInjectionTable,standardAmpolyteOptions,standardAmpolyteOptionsPrecisionTests,
			standardAmpolyteOptionsTests,standardInInjectionTableBool,standardOptionList,standardOptions,standardPIMarkerOptions,
			standardPIMarkerOptionsPrecisionTests,standardPIMarkerOptionsTests,hamiltonCompatibleContainers,targetContainers,suppliedConsolidation,resolvedConsolidation,aliquotOptions,
			unresolvedOptionsKeys,upload,

			(* SampleIn MapThread *)
			ampholyteConcentrationNullErrors,ampholyteMatchedlengthsNotCopaceticErrors,ampholyteVolumeConcentrationMismatchErrors,
			ampholyteVolumeNullErrors,anodicSpacerConcentrationNullErrors,anodicSpacerConcentrationVolumeMismatchErrors,
			anodicSpacerFalseOptionsSpecifiedErrors,anodicSpacerNullErrors,anodicSpacerVolumeNullErrors,
			cathodicSpacerConcentrationNullErrors,cathodicSpacerConcentrationVolumeMismatchErrors,cathodicSpacerFalseOptionsSpecifiedErrors,
			cathodicSpacerNullErrors,cathodicSpacerVolumeNullErrors,denaturationReagentConcentrationNullErrors,
			denaturationReagentConcentrationVolumeMismatchErrors,denaturationReagentNullErrors,denaturationReagentVolumeNullErrors,
			denatureFalseOptionsSpecifiedErrors,electroosmoticFlowBlockerConcentrationNullErrors,electroosmoticFlowBlockerNullErrors,
			electroosmoticFlowBlockerVolumeNullErrors,eofBlockerVolumeConcentrationMismatchErrors,isoelectricPointMarkersConcentrationNullErrors,
			isoelectricPointMarkersVolumeConcentrationMismatchErrors,isoelectricPointMarkersVolumeNullErrors,missingSampleCompositionWarnings,
			noAnodicSpacerIdentifiedErrors,noCathodicSpacerIdentifiedErrors,noDenaturationReagentIdentifiedErrors,
			noElectroosmoticFlowBlockerAgentIdentifiedWarnings,noSpecifiedAmpholytesErrors,noSpecifiedIsoelectricPointMarkersErrors,
			nullDiluentErrors,OnBoardMixingIncompatibleVolumesErrors,premadeMasterMixDiluentNullErrors,
			premadeMastermixFalseOptionsSpecifiedErrors,premadeMasterMixDilutionFactorNullErrors,premadeMasterMixNullErrors,
			premadeMasterMixTotalVolumeErrors,premadeMasterMixVolumeDilutionFactorMismatchWarnings,
			premadeMasterMixVolumeNullErrors,resolveableDenatureReagentConcentrationUnitMismatchErrors,resolvedAmpholytes,
			resolvedAmpholytesStorageConditions,resolvedAmpholyteTargetConcentrations,resolvedAmpholyteVolume,resolvedAnodicSpacer,
			resolvedAnodicSpacerTargetConcentration,resolvedAnodicSpacerVolume,resolvedCathodicSpacer,resolvedCathodicSpacerTargetConcentration,
			resolvedCathodicSpacerVolume,resolvedDenaturationReagent,resolvedDenaturationReagentTargetConcentration,
			resolvedDenaturationReagentVolume,resolvedDenature,resolvedDiluent,resolvedElectroosmoticFlowBlocker,
			resolvedElectroosmoticFlowBlockerTargetConcentrations,resolvedElectroosmoticFlowBlockerVolume,resolvedIncludeAnodicSpacer,
			resolvedIncludeCathodicSpacer,resolvedImagingMethods,resolvedNativeFluorescenceExposureTimes,
			resolvedIsoelectricPointMarkers,resolvedIsoelectricPointMarkersStorageConditions,
			resolvedIsoelectricPointMarkersTargetConcentrations,resolvedIsoelectricPointMarkersVolume,resolvedPremadeMasterMix,
			resolvedPremadeMasterMixDiluent,resolvedPremadeMasterMixDilutionFactor,resolvedPremadeMasterMixReagent,
			resolvedPremadeMasterMixVolume,resolvedSampleVolume,resolvedTotalVolume,resolverCantFixIsoelectricPointMarkersMismatchErrors,
			sumOfVolumesOverTotalvolumeErrors,unresolveableDenatureReagentConcentrationUnitMismatchErrors,voltageDurationStepErrors,

			(* standards/blanks mapThread *)
			blankAmpholyteConcentrationNullErrors,blankAmpholyteMatchedlengthsNotCopaceticErrors,blankAmpholyteVolumeConcentrationMismatchErrors,
			blankAmpholyteVolumeNullErrors,blankAnodicSpacerConcentrationNullErrors,blankAnodicSpacerConcentrationVolumeMismatchErrors,
			blankAnodicSpacerFalseOptionsSpecifiedErrors,blankAnodicSpacerNullErrors,blankAnodicSpacerVolumeNullErrors,blankCathodicSpacerConcentrationNullErrors,
			blankCathodicSpacerConcentrationVolumeMismatchErrors,blankCathodicSpacerFalseOptionsSpecifiedErrors,blankCathodicSpacerNullErrors,blankCathodicSpacerVolumeNullErrors,
			blankDenaturationReagentConcentrationNullErrors,blankDenaturationReagentConcentrationVolumeMismatchErrors,
			blankDenaturationReagentNullErrors,blankDenaturationReagentVolumeNullErrors,blankDenatureFalseOptionsSpecifiedErrors,
			blankElectroosmoticFlowBlockerConcentrationNullErrors,blankElectroosmoticFlowBlockerNullErrors,
			blankElectroosmoticFlowBlockerVolumeNullErrors,blankEofBlockerVolumeConcentrationMismatchErrors,blankImagingMethodMismatchErrors,
			blankIsoelectricPointMarkersConcentrationNullErrors,blankIsoelectricPointMarkersVolumeConcentrationMismatchErrors,
			blankIsoelectricPointMarkersVolumeNullErrors,blankLoadTimeNullErrors,blankMissingSampleCompositionWarnings,blankNoAnodicSpacerIdentifiedErrors,
			blankNoCathodicSpacerIdentifiedErrors,blankNoDenaturationReagentIdentifiedErrors,blankNoElectroosmoticFlowBlockerAgentIdentifiedWarnings,
			blankNoSpecifiedAmpholytesErrors,blankNoSpecifiedIsoelectricPointMarkersErrors,blankNullDiluentErrors,blankNullTotalVolumeErrors,
			blankOnBoardMixingIncompatibleVolumesErrors,blankPremadeMasterMixDiluentNullErrors,blankPremadeMasterMixDilutionFactorNullErrors,
			blankPremadeMastermixFalseOptionsSpecifiedErrors,blankPremadeMasterMixNullErrors,blankPremadeMasterMixTotalVolumeErrors,
			blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings,blankPremadeMasterMixVolumeNullErrors,
			blankResolveableDenatureReagentConcentrationUnitMismatchErrors,blankResolverCantFixIsoelectricPointMarkersMismatchErrors,
			blankSumOfVolumesOverTotalvolumeErrors,blankTrueFrequencyNullErrors,blankUnresolveableDenatureReagentConcentrationUnitMismatchErrors,
			blankVoltageDurationStepErrors,resolvedBlankAmpholytes,resolvedBlankAmpholytesStorageConditions,resolvedBlankAmpholyteTargetConcentrations,
			resolvedBlankAmpholyteVolume,resolvedBlankAnodicSpacer,resolvedBlankAnodicSpacerTargetConcentration,
			resolvedBlankAnodicSpacerVolume,resolvedBlankCathodicSpacer,resolvedBlankCathodicSpacerTargetConcentration,
			resolvedBlankCathodicSpacerVolume,resolvedBlankDenaturationReagent,resolvedBlankDenaturationReagentTargetConcentration,
			resolvedBlankDenaturationReagentVolume,resolvedBlankDenature,resolvedBlankDiluent,resolvedBlankElectroosmoticFlowBlocker,
			resolvedBlankElectroosmoticFlowBlockerTargetConcentrations,	resolvedBlankElectroosmoticFlowBlockerVolume,
			resolvedBlankFrequency,resolvedBlankImagingMethods,resolvedBlankIncludeAnodicSpacer,resolvedBlankIncludeCathodicSpacer,
			resolvedBlankIsoelectricPointMarkers,resolvedBlankIsoelectricPointMarkersStorageConditions,
			resolvedBlankIsoelectricPointMarkersTargetConcentrations,resolvedBlankIsoelectricPointMarkersVolume,resolvedBlankLoadTime,
			resolvedBlankNativeFluorescenceExposureTime,resolvedBlankPremadeMasterMix,resolvedBlankPremadeMasterMixDiluent,
			resolvedBlankPremadeMasterMixDilutionFactor,resolvedBlankPremadeMasterMixReagent,resolvedBlankPremadeMasterMixVolume,
			resolvedBlankTotalVolume,resolvedBlankVoltageDurationProfile,resolvedBlankVolume,resolvedStandardAmpholytes,
			resolvedStandardAmpholytesStorageConditions,resolvedStandardAmpholyteTargetConcentrations,resolvedStandardAmpholyteVolume,
			resolvedStandardAnodicSpacer,resolvedStandardAnodicSpacerTargetConcentration,resolvedStandardAnodicSpacerVolume,
			resolvedStandardCathodicSpacer,resolvedStandardCathodicSpacerTargetConcentration,resolvedStandardCathodicSpacerVolume,
			resolvedStandardDenaturationReagent,resolvedStandardDenaturationReagentTargetConcentration,resolvedStandardDenaturationReagentVolume,
			resolvedStandardDenature,resolvedStandardDiluent,resolvedStandardElectroosmoticFlowBlocker,
			resolvedStandardElectroosmoticFlowBlockerTargetConcentrations,resolvedStandardElectroosmoticFlowBlockerVolume,resolvedStandardFrequency,
			resolvedStandardImagingMethods,resolvedStandardIncludeAnodicSpacer,resolvedStandardIncludeCathodicSpacer,
			resolvedStandardIsoelectricPointMarkers,resolvedStandardIsoelectricPointMarkersStorageConditions,
			resolvedStandardIsoelectricPointMarkersTargetConcentrations,resolvedStandardIsoelectricPointMarkersVolume,resolvedStandardLoadTime,
			resolvedStandardNativeFluorescenceExposureTime,resolvedStandardPremadeMasterMix,resolvedStandardPremadeMasterMixDiluent,
			resolvedStandardPremadeMasterMixDilutionFactor,resolvedStandardPremadeMasterMixReagent,resolvedStandardPremadeMasterMixVolume,
			resolvedStandardTotalVolume,resolvedStandardVoltageDurationProfile,resolvedStandardVolume,standardAmpholyteConcentrationNullErrors,
			standardAmpholyteMatchedlengthsNotCopaceticErrors,standardAmpholyteVolumeConcentrationMismatchErrors,standardAmpholyteVolumeNullErrors,
			standardAnodicSpacerConcentrationNullErrors,standardAnodicSpacerConcentrationVolumeMismatchErrors,
			standardAnodicSpacerFalseOptionsSpecifiedErrors,standardAnodicSpacerNullErrors,standardAnodicSpacerVolumeNullErrors,
			standardCathodicSpacerConcentrationNullErrors,standardCathodicSpacerConcentrationVolumeMismatchErrors,
			standardCathodicSpacerFalseOptionsSpecifiedErrors,standardCathodicSpacerNullErrors,standardCathodicSpacerVolumeNullErrors,
			standardDenaturationReagentConcentrationNullErrors,standardDenaturationReagentConcentrationVolumeMismatchErrors,
			standardDenaturationReagentNullErrors,standardDenaturationReagentVolumeNullErrors,standardDenatureFalseOptionsSpecifiedErrors,
			standardElectroosmoticFlowBlockerConcentrationNullErrors,standardElectroosmoticFlowBlockerNullErrors,
			standardElectroosmoticFlowBlockerVolumeNullErrors,standardEofBlockerVolumeConcentrationMismatchErrors,standardImagingMethodMismatchErrors,
			standardIsoelectricPointMarkersConcentrationNullErrors,standardIsoelectricPointMarkersVolumeConcentrationMismatchErrors,
			standardIsoelectricPointMarkersVolumeNullErrors,standardLoadTimeNullErrors,standardMissingSampleCompositionWarnings,
			standardNoAnodicSpacerIdentifiedErrors,standardNoCathodicSpacerIdentifiedErrors,standardNoDenaturationReagentIdentifiedErrors,
			standardNoElectroosmoticFlowBlockerAgentIdentifiedWarnings,standardNoSpecifiedAmpholytesErrors,
			standardNoSpecifiedIsoelectricPointMarkersErrors,standardNullDiluentErrors,standardNullTotalVolumeErrors,
			standardOnBoardMixingIncompatibleVolumesErrors,standardPremadeMasterMixDiluentNullErrors,
			standardPremadeMastermixFalseOptionsSpecifiedErrors,standardPremadeMasterMixDilutionFactorNullErrors,
			standardPremadeMasterMixNullErrors,standardPremadeMasterMixTotalVolumeErrors,standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings,
			standardPremadeMasterMixVolumeNullErrors,standardResolveableDenatureReagentConcentrationUnitMismatchErrors,
			standardResolverCantFixIsoelectricPointMarkersMismatchErrors,standardSumOfVolumesOverTotalvolumeErrors,
			standardTrueFrequencyNullErrors,standardUnresolveableDenatureReagentConcentrationUnitMismatchErrors,
			standardVoltageDurationStepErrors,resolvedSampleLabel,resolvedSampleContainerLabel,

			(* conflicting options *)
			blankMakeMasterMixOptionsSetBool,blankPremadeMasterMixWithmakeMasterMixOptionsSetQ,blanksFalseOptionsSpecifiedInvalidOption,
			blanksFalseOptionsSpecifiedTest,cartridgeModelPacket,discardedCartridgeInvalidOption,discardedCartridgeInvalidTest,
			injectionTableContainsAllQ,invalidInjectionTableOption,invalidInjectionTableTest,makeOnesOwnMasterMixOptions,
			nameInvalidOptions,notEnoughOptimalUsesLeftOption,notEnoughOptimalUsesLeftOptionTest,notEnoughUsesLeftOption,
			notEnoughUsesLeftOptionTest,notEnoughUsesLeftQ,	optimalUsesLeftOnCartridge,injectionTableVolumeZeroInvalidOption,
			injectionTableVolumeZeroInvalidTest,injectionTableWithReplicatesInvalidOption,injectionTableWithReplicatesInvalidTest,
			specifiedNumberOfReplicates,volumeZeroInjectionTableBool,premadeMasterMixOptions,premadeMasterMixWithmakeMasterMixOptionsSetInvalidOption,
			premadeMasterMixWithmakeMasterMixOptionsSetInvalidOptionTest,premadeMasterMixWithmakeMasterMixOptionsSetQ,
			preMadeMasterMixWithMakeOwnInvalidOptions,preMadeMasterMixWithMakeOwnInvalidSamples,sampleCountInvalidOption,
			sampleCountQ,sampleCountTest,samplesMakeMasterMixOptionsSetBool,samplesMissingFromInjectionTables,
			standardsFalseOptionsSpecifiedInvalidOption,standardsFalseOptionsSpecifiedTest,standardMakeMasterMixOptionsSetBool,
			standardPremadeMasterMixWithmakeMasterMixOptionsSetQ,usesLeftOnCartridge,validNameQ,validNameTest,

			(* Unresolved options tests*)
			ampholyteConcentrationNullErrorsInvalidOptions,ampholyteConcentrationNullErrorsTests,
			ampholyteConcentrationNullInvalidSamples,ampholyteConcentrationNullOptions,
			ampholyteMatchedlengthsNotCopaceticInvalidOptions,ampholyteMatchedlengthsNotCopaceticInvalidSamples,
			ampholyteMatchedlengthsNotCopaceticOptions,ampholyteMatchedlengthsNotCopaceticTests,
			ampholyteVolumeConcentrationMismatchInvalidOptions,ampholyteVolumeConcentrationMismatchInvalidSamples,
			ampholyteVolumeConcentrationMismatchOptions,ampholyteVolumeConcentrationMismatchTests,ampholyteVolumeNullInvalidOptions,
			ampholyteVolumeNullInvalidSamples,ampholyteVolumeNullOptions,ampholyteVolumeNullTests,
			anodicSpacerConcentrationNullInvalidOptions,anodicSpacerConcentrationNullTests,
			anodicSpacerConcentrationVolumeMismatchInvalidOptions,anodicSpacerConcentrationVolumeMismatchInvalidSamples,
			anodicSpacerConcentrationVolumeMismatchOptions,anodicSpacerConcentrationVolumeMismatchTests,
			anodicSpacerFalseOptionsSpecifiedOptions, anodicSpacerFalseOptionsSpecifiedInvalidSamples,
			anodicSpacerFalseOptionsSpecifiedInvalidOptions,anodicSpacerFalseOptionsSpecifiedTests,
			anodicSpacerNullInvalidOptions,anodicSpacerNullInvalidSamples,anodicSpacerNullOptions,anodicSpacerNullTests,
			anodicSpacerVolumeNullInvalidOptions,anodicSpacerVolumeNullInvalidSamples,anodicSpacerVolumeNullOptions,
			anodicSpacerVolumeNullTests,cathodicSpacerConcentrationNullInvalidOptions,cathodicSpacerConcentrationNullOptions,
			cathodicSpacerConcentrationNullSamples,cathodicSpacerConcentrationNullTests,
			cathodicSpacerConcentrationVolumeMismatchInvalidOptions,cathodicSpacerConcentrationVolumeMismatchInvalidSamples,
			cathodicSpacerConcentrationVolumeMismatchOptions,cathodicSpacerConcentrationVolumeMismatchTests,
			cathodicSpacerFalseOptionsSpecifiedOptions, cathodicSpacerFalseOptionsSpecifiedInvalidSamples,
			cathodicSpacerFalseOptionsSpecifiedInvalidOptions,cathodicSpacerFalseOptionsSpecifiedTests,
			cathodicSpacerNullInvalidOptions,cathodicSpacerNullInvalidSamples,cathodicSpacerNullOptions,cathodicSpacerNullTests,
			cathodicSpacerVolumeNullInvalidOptions,cathodicSpacerVolumeNullInvalidSamples,cathodicSpacerVolumeNullOptions,
			cathodicSpacerVolumeNullTests,denaturationReagentConcentrationNullInvalidOptions,
			denatureFalseOptionsSpecifiedOptions, denatureFalseOptionsSpecifiedInvalidSamples, denatureFalseOptionsSpecifiedInvalidOptions,
			denatureFalseOptionsSpecifiedTests,denaturationReagentConcentrationNullInvalidSamples,denaturationReagentConcentrationNullOptions,
			denaturationReagentConcentrationNullTests,denaturationReagentConcentrationVolumeMismatchInvalidOptions,
			denaturationReagentConcentrationVolumeMismatchInvalidSamples,denaturationReagentConcentrationVolumeMismatchOptions,
			denaturationReagentConcentrationVolumeMismatchTests,denaturationReagentNullInvalidOptions,
			denaturationReagentNullInvalidSamples,denaturationReagentNullOptions,denaturationReagentNullTests,
			denaturationReagentVolumeNullInvalidOptions,denaturationReagentVolumeNullInvalidSamples,
			denaturationReagentVolumeNullOptions,denaturationReagentVolumeNullTests,
			electroosmoticFlowBlockerConcentrationNullInvalidOptions,electroosmoticFlowBlockerConcentrationNullInvalidSamples,
			electroosmoticFlowBlockerConcentrationNullOptions,electroosmoticFlowBlockerConcentrationNullTests,
			electroosmoticFlowBlockerNullInvalidOptions,electroosmoticFlowBlockerNullInvalidSamples,
			electroosmoticFlowBlockerNullOptions,electroosmoticFlowBlockerNullTests,
			electroosmoticFlowBlockerVolumeNullInvalidOptions,electroosmoticFlowBlockerVolumeNullInvalidSamples,
			electroosmoticFlowBlockerVolumeNullOptions,electroosmoticFlowBlockerVolumeNullTests,
			eofBlockerVolumeConcentrationMismatchInvalidOptions,eofBlockerVolumeConcentrationMismatchInvalidSamples,
			eofBlockerVolumeConcentrationMismatchOptions,eofBlockerVolumeConcentrationMismatchTests,
			includeTrueFrequencyNullOptions, includeTrueFrequencyNullErrorsSamples, includeTrueFrequencyNullErrorsTests,
			isoelectricPointMarkersConcentrationNullErrorsInvalidOptions,
			isoelectricPointMarkersConcentrationNullErrorsInvalidSamples,isoelectricPointMarkersConcentrationNullErrorsOptions,
			isoelectricPointMarkersConcentrationNullErrorsTests,isoelectricPointMarkersVolumeConcentrationMismatchInvalidOptions,
			isoelectricPointMarkersVolumeConcentrationMismatchInvalidSamples,
			isoelectricPointMarkersVolumeConcentrationMismatchOptions,isoelectricPointMarkersVolumeConcentrationMismatchTests,
			isoelectricPointMarkersVolumeNullInvalidOptions,isoelectricPointMarkersVolumeNullInvalidSamples,
			isoelectricPointMarkersVolumeNullOptions,isoelectricPointMarkersVolumeNullTests,loadTimeNullOptions,
			loadTimeNullErrorsSamples, loadTimeNullErrorsTests,missingSampleCompositionWarningsOptions,
			missingSampleCompositionWarningsSamples,missingSampleCompositionWarningTests,noAnodicSpacerIdentifiedInvalidSamples,
			noAnodicSpacerIdentifiedOptions,noAnodicSpacerIdentifiedTest,noCathodicSpacerIdentifiedInvalidSamples,
			noCathodicSpacerIdentifiedOptions,noCathodicSpacerIdentifiedTest,noDenaturationReagentIdentifiedInvalidSamples,
			noDenaturationReagentIdentifiedOptions,noDenaturationReagentIdentifiedTest,
			noElectroosmoticFlowBlockerAgentIdentifiedInvalidSamples,noElectroosmoticFlowBlockerAgentIdentifiedOptions,
			noElectroosmoticFlowBlockerAgentIdentifiedTest,noSpecifiedAmpholytesInvalidOptions,noSpecifiedAmpholytesInvalidSamples,
			noSpecifiedAmpholytesOptions,noSpecifiedAmpholytesTests,noSpecifiedIsoelectricPointMarkersInvalidOptions,
			noSpecifiedIsoelectricPointMarkersInvalidSamples,noSpecifiedIsoelectricPointMarkersOptions,
			noSpecifiedIsoelectricPointMarkersTests,nullDiluentInvalidOptions,nullDiluentInvalidSamples,nullDiluentOptions,
			nullDiluentTests,nullTotalVolumeErrorsOptions,nullTotalVolumeErrorsSamples,nullTotalVolumeErrorsTests,
			obmSampleNumberTopoff,onBoardMixingIncompatibleVolumesInvalidOptions,onBoardMixingIncompatibleVolumesInvalidSamples,
			onBoardMixingIncompatibleVolumesOptions,onBoardMixingIncompatibleVolumesTests,onBoardMixingInvalidOptions,
			onBoardMixingInvalidTests,OnBoardMixingVolumeTest,onBoardMixingNullOptions,onBoardMixingPassingOptions,onBoardMixingResolvedOptions,
			onBoardMixingResolvedOptionsLengthBool,imagingMethodMismatchOptions,imagingMethodMismatchInvalidSamples,
			imagingMethodMismatchInvalidOptions,imagingMethodMismatchTests,premadeMasterMixDiluentNullInvalidOptions,
			premadeMasterMixDiluentNullInvalidSamples,premadeMasterMixDiluentNullOptions,premadeMasterMixDiluentNullTests,
			premadeMasterMixDilutionFactorNullInvalidOptions,premadeMasterMixDilutionFactorNullInvalidSamples,
			premadeMasterMixDilutionFactorNullOptions,premadeMasterMixDilutionFactorNullTests,
			premadeMastermixFalseOptionsSpecifiedInvalidOptions,premadeMastermixFalseOptionsSpecifiedInvalidSamples,
			premadeMastermixFalseOptionsSpecifiedOptions,premadeMastermixFalseOptionsSpecifiedTests,premadeMasterMixNullInvalidOptions,
			premadeMasterMixNullInvalidSamples,premadeMasterMixNullOptions,premadeMasterMixNullTests,
			premadeMasterMixTotalVolumeInvalidOptions,premadeMasterMixTotalVolumeInvalidSamples,premadeMasterMixTotalVolumeOptions,
			premadeMasterMixTotalVolumeTests,premadeMasterMixVolumeDilutionFactorMismatchInvalidOptions,
			premadeMasterMixVolumeDilutionFactorMismatchInvalidSamples,premadeMasterMixVolumeDilutionFactorMismatchOptions,
			premadeMasterMixVolumeDilutionFactorMismatchTests,premadeMasterMixVolumeNullInvalidOptions,
			premadeMasterMixVolumeNullInvalidSamples,premadeMasterMixVolumeNullOptions,premadeMasterMixVolumeNullTests,
			resolveableDenatureReagentConcentrationUnitMismatchInvalidSamples,
			resolveableDenatureReagentConcentrationUnitMismatchOptions,resolveableDenatureReagentConcentrationUnitMismatchTest,
			resolverCantFixIsoelectricPointMarkersMismatchInvalidOptions,resolverCantFixIsoelectricPointMarkersMismatchInvalidSamples,
			resolverCantFixIsoelectricPointMarkersMismatchOptions,resolverCantFixIsoelectricPointMarkersMismatchTests,
			sumOfVolumesOverTotalvolumeInvalidOptions,sumOfVolumesOverTotalvolumeInvalidSamples,sumOfVolumesOverTotalvolumeOptions,
			sumOfVolumesOverTotalvolumeTests,unresolveableDenatureReagentConcentrationUnitMismatchInvalidOptions,
			unresolveableDenatureReagentConcentrationUnitMismatchInvalidSamples,unresolveableDenatureReagentConcentrationUnitMismatchOptions,
			unresolveableDenatureReagentConcentrationUnitMismatchTests,voltageDurationStepOptions,
			voltageDurationStepInvalidSamples,voltageDurationStepInvalidOptions,voltageDurationStepTests
		},

		(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

		(* Determine the requested output format of this function. *)
		outputSpecification=OptionValue[Output];
		output=ToList[outputSpecification];

		(* Determine if we should keep a running list of tests to return to the user. *)
		gatherTests=MemberQ[output,Tests];
		messages=Not[gatherTests];

		(* pull out the Cache option *)
		inheritedCache=Lookup[ToList[myResolutionOptions],Cache,{}];
		simulation=Lookup[ToList[myResolutionOptions],Simulation,Null];

		fastTrack=Lookup[ToList[myResolutionOptions],FastTrack,False];

		(* --- split out and resolve the sample prep options --- *)
		(* Separate out our CapillaryIsoelectricFocusing options from our Sample Prep options. *)
		{samplePrepOptions,capillaryIsoelectricFocusingOptions}=splitPrepOptions[myOptions];

		(* Resolve sample prep options *)
		{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
			resolveSamplePrepOptionsNew[ExperimentCapillaryIsoelectricFocusing,mySamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->{Result,Tests}],
			{resolveSamplePrepOptionsNew[ExperimentCapillaryIsoelectricFocusing,mySamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->Result],{}}
		];

		(* grab any container models in sample prep options *)
		samplePrepContainers = DeleteDuplicates[Cases[Values[resolvedSamplePrepOptions],ObjectP[{Model[Container]}], Infinity]];

		(* grab any container models in sample prep options *)
		samplePrepModelSamples = DeleteDuplicates[Cases[Values[resolvedSamplePrepOptions],ObjectP[{Model[Sample]}], Infinity]];

		(* Download the current container model of the simulated samples and any additional containers in samplePrep*)
		smallCacheBall=Quiet[
			Cases[Flatten[{Download[
				{
					simulatedSamples,
					samplePrepContainers,
					samplePrepModelSamples
				},
				{
					{Packet[Composition]},
					{Evaluate[Packet[Name, MaxVolume, DefaultStorageCondition, SamplePreparationCacheFields[Model[Container], Format -> Sequence]]]},
					{Evaluate[Packet[Deprecated, Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, Products, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample], Format -> Sequence]]]}
				},
				Cache->inheritedCache,
				Simulation->updatedSimulation,
				Date->Now
			]}],
				PacketP[]
			],
			{Download::NotLinkField,Download::FieldDoesntExist}];

		(* add downloaded packets to cache *)
		inheritedCache=FlattenCachePackets[{inheritedCache,Flatten[smallCacheBall]}];

		(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
		capillaryIsoelectricFocusingOptionsAssociation=Association[capillaryIsoelectricFocusingOptions];

		(* get a list of options specified by the user *)
		unresolvedOptionsKeys = Lookup[capillaryIsoelectricFocusingOptionsAssociation, UnresolvedOptions];

		(* Extract the packets that we need from our downloaded cache. *)
		(* Remember to download from simulatedSamples, using our inheritedCache *)
		(* Quiet[Download[...],Download::FieldDoesntExist] *)

		(* Fetch simulated samples' cached packets *)
		simulatedSamplePackets=fetchPacketFromCache[#,inheritedCache]&/@simulatedSamples;

		(* Fetch simulated sample containers' cached packets *)
		simulatedSampleContainerPackets=fetchPacketFromCache[Download[#, Object],inheritedCache]&/@Lookup[simulatedSamplePackets,Container];

		(* currently the instrument model is always this; in the future this might be a viable option *)
		instrumentModelPacket=FirstCase[inheritedCache,ObjectP[Model[Instrument,ProteinCapillaryElectrophoresis]]];

		(* split out the sample and model packets *)
		samplePackets=fetchPacketFromCache[#,inheritedCache]&/@mySamples;
		sampleModelPackets=fetchPacketFromCache[#,inheritedCache]&/@Lookup[samplePackets,Model,{}];

		(* Get composition models for all samples *)
		compositionModels=DeleteDuplicates[Flatten[{#[Composition][[All,2]],#[Analytes]}&/@Join[samplePackets]]];
		sampleCompositionModelPackets=fetchPacketFromCache[#,inheritedCache]&/@compositionModels;

		(* get objects and models for reagents, standards, blanks, *)
		optionObjectsModels=Join[
			DeleteDuplicates[Cases[KeyDrop[capillaryIsoelectricFocusingOptionsAssociation],ObjectReferenceP[{Object[Sample],Model[Sample]}],Infinity]],
			{
				Model[Sample,StockSolution,"8M Urea"],
				Model[Sample,StockSolution,"10M Urea"],
				Model[Sample, "SimpleSol"],
				Model[Sample,StockSolution, "200mM Iminodiacetic acid"],
				Model[Sample,StockSolution, "500mM Arginine"],
				Model[Sample,"Pharmalyte pH 3-10"],
				Model[Sample,"Pharmalyte pH 2.5-5"],
				Model[Sample,"Pharmalyte pH 5-8"],
				Model[Sample,"Pharmalyte pH 8-10.5"],
				Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 10.17" ],
				Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 9.99" ],
				Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 9.50" ],
				Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 8.40" ],
				Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 7.05" ],
				Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 6.14" ],
				Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 5.85" ],
				Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 4.05" ],
				Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 3.38" ],
				Model[Sample,"0.5% Methyl Cellulose"],
				Model[Sample,"1% Methyl Cellulose"],
				Model[Sample,"0.08M Phosphoric Acid in 0.1% Methyl Cellulose"],
				Model[Sample,"0.1M Sodium Hydroxide in 0.1% Methyl Cellulose"],
				Model[Sample,"cIEF Fluorescence Calibration Standard"],
				Model[Sample,StockSolution,"Resuspended cIEF System Suitability Peptide Panel"],
				Model[Sample,"cIEF System Suitability Test Mix"]
			}
		];
		optionObjectModelPackets=fetchPacketFromCache[Download[#,Object],inheritedCache]&/@optionObjectsModels;

		(* get composition for option objects and models *)
		optionObjectModelComposition=DeleteDuplicates[Flatten[
			Download[#[[All,2]],Object] &/@(Composition/.Cases[optionObjectModelPackets,PacketP[]])
		]];
		optionObjectModelCompositionPackets=fetchPacketFromCache[Download[#,Object],inheritedCache]&/@Cases[optionObjectModelComposition,ObjectP[]];

		(* If you have Warning:: messages, do NOT throw them when engineQ == True. Warnings should NOT be surfaced in engine. *)
		engineQ=MatchQ[$ECLApplication,Engine];

		(* grab option definitions for the experiment function, to look for defaults *)
		opsDef=OptionDefinition[ExperimentCapillaryIsoelectricFocusing];

		(*-- INPUT VALIDATION CHECKS --*)

		(** Discarded Sample **)
		(* get sample packets that are not null *)
		samplePacketsToCheckIfDiscarded=Cases[samplePackets,PacketP[Object[Sample]]];

		(* Get the samples from mySamples that are discarded. *)
		discardedSamplePackets=Cases[Flatten[samplePacketsToCheckIfDiscarded],KeyValuePattern[Status->Discarded]];

		(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
		discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
			{},
			Lookup[discardedSamplePackets,Object]
		];

		(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
		If[Length[discardedInvalidInputs]>0&&messages,
			Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->inheritedCache]];
		];

		(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
		discardedTest=If[gatherTests,
			Module[{failingTest,passingTest},
				failingTest=If[Length[discardedInvalidInputs]==0,
					Nothing,
					Test["Provided input samples "<>ObjectToString[discardedInvalidInputs,Cache->inheritedCache]<>" are not discarded:",True,False]
				];

				passingTest=If[Length[discardedInvalidInputs]==Length[samplePacketsToCheckIfDiscarded],
					Nothing,
					Test["Provided input samples "<>ObjectToString[Complement[samplePacketsToCheckIfDiscarded,discardedInvalidInputs],Cache->inheritedCache]<>" are not discarded:",True,True]
				];
				{failingTest,passingTest}
			],
			Nothing
		];

		(** Deprecated models  **)
		(* get models that are not null from packets*)
		modelPacketsToCheckIfdeprecaded=Cases[sampleModelPackets,PacketP[Model[Sample]]];

		(* Get the samples from mySamples that are Deprecated. *)
		deprecatedModelPackets=Cases[Flatten[modelPacketsToCheckIfdeprecaded],KeyValuePattern[Deprecated->True]];

		(* Set deprecatedInvalidInputs to the input objects whose statuses are Deprecated *)
		deprecatedInvalidInputs=If[MatchQ[deprecatedModelPackets,{}],
			{},
			Lookup[deprecatedModelPackets,Object]
		];

		(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
		If[Length[deprecatedModelPackets]>0&&messages,
			Message[Error::DeprecatedModels,ObjectToString[deprecatedInvalidInputs,Cache->inheritedCache]];
		];

		(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
		deprecatedTest=If[gatherTests,
			Module[{failingTest,passingTest},
				failingTest=If[Length[deprecatedInvalidInputs]==0,
					Nothing,
					Test["The models for provided input samples "<>ObjectToString[deprecatedInvalidInputs,Cache->inheritedCache]<>" are not deprecated:",True,False]
				];

				passingTest=If[Length[deprecatedInvalidInputs]==Length[modelPacketsToCheckIfdeprecaded],
					Nothing,
					Test["The models for provided input samples "<>ObjectToString[Complement[modelPacketsToCheckIfdeprecaded,deprecatedInvalidInputs],Cache->inheritedCache]<>" are not deprecated:",True,True]
				];
				{failingTest,passingTest}
			],
			Nothing
		];

		(** Incompatible Cartridge **)
		(* get cartridge packet *)
		cartridgeObject=Download[Lookup[capillaryIsoelectricFocusingOptions,Cartridge],Object];
		cartridgePacket=fetchPacketFromCache[cartridgeObject,inheritedCache];
		(* grab the model, in case we got an object *)
		cartridgeModelPacket=If[MatchQ[cartridgePacket[Object],ObjectP[Object[Container,ProteinCapillaryElectrophoresisCartridge]]],
			fetchPacketFromCache[Lookup[cartridgePacket,Model],inheritedCache],
			cartridgePacket];

		(* check if ExperimentType is compatible with experiment*)
		cartridgeCompatibleQ=MatchQ[Lookup[cartridgePacket,ExperimentType],cIEF];

		(* if cartridge is incompatible, throw an error *)
		incompatibleCartridgeInvalidOption=If[MatchQ[cartridgeCompatibleQ,False]&&messages,
			(
				Message[Error::CIEFIncompatibleCartridge,ObjectToString[Lookup[capillaryIsoelectricFocusingOptions,Cartridge]]];
				{Cartridge}
			),
			{}
		];

		incompatibleCartridgeTest=If[gatherTests,
			Test["Experiment Cartridge is compatible with CapillaryIsoelectricFocusing:",
				cartridgeCompatibleQ,
				True
			],
			Nothing
		];


		(** discardedCartridge **)
		discardedCartridgeInvalidOption=If[MatchQ[Lookup[cartridgePacket,Status,Null],Discarded]&&messages,
			(
				Message[Error::CIEFDiscardedCartridge,ObjectToString[Lookup[cartridgePacket,Object],Cache->inheritedCache]];
				{Cartridge}
			),
			{}
		];

		(* If we need to gather tests, generate the tests for cartridge check *)
		discardedCartridgeInvalidTest=If[gatherTests,
			Test["Cartridge chosen for CapillaryIsoelectricFocusing experiment is not discarded:",
				MatchQ[Lookup[cartridgePacket,Status,Null],Discarded],
				False
			],
			Nothing
		];


		(*-- OPTION PRECISION CHECKS --*)
		(* Since VoltageProfiles are in a touple, the will have to be split for precision checks and transpose after. The following function does that.*)
		precisionForListedOptions[association_Association,precisions_List]:=Module[
			{
				collatedRoundedOptions,collatedPrecisionTests
			},

			collatedRoundedOptions=<||>;
			collatedPrecisionTests={};

			(* if option has values that are lists of lists *) (* Module + Map []*)
			Map[If[MatchQ[association[#],{{_List..} ..}],
				Module[
					{
						tempAssociation,transposedOptionValue,roundedOptions,roundedOptionsPrecisionTests,
						TransposedRoundedOptions,transposedFlattenedRoundedOptions
					},
					(* transpose values for each sample *)
					transposedOptionValue=Function[perSample,Transpose[perSample]]/@association[#];
					(* make temporary associations with unique names based of index in the list (1 should be voltage, 2 should be time) *)
					tempAssociation=Association[Table[ToExpression[ToString[#]<>ToString[count]]->
						Flatten[transposedOptionValue[[All,count]]],{count,Length[transposedOptionValue[[1]]]}]];
					(* round options *)
					{roundedOptions,roundedOptionsPrecisionTests}=If[gatherTests,
						RoundOptionPrecision[tempAssociation,Keys[tempAssociation],precisions,Output->{Result,Tests}],
						{RoundOptionPrecision[tempAssociation,Keys[tempAssociation],precisions],{}}];
					(* to return to correct format {{{Volt, Time}..}..} Unflattening then Transposing. When unflattening, keep the correct cell as reference (based on the number at the end of the Key name *)
					transposedFlattenedRoundedOptions=Transpose[Values[roundedOptions]];
					TransposedRoundedOptions=Association[#->TakeList[transposedFlattenedRoundedOptions,Length/@association[#]]];
					(* Collate all results into one association to return *)
					collatedRoundedOptions=Join[collatedRoundedOptions,TransposedRoundedOptions ];
					collatedPrecisionTests=Join[collatedPrecisionTests,roundedOptionsPrecisionTests];
				]] &,Keys[association]];
			Return[{collatedRoundedOptions,collatedPrecisionTests}]
		];

		(* check precision for VoltegeDurationProfiles *)
		{roundedFocusingOptions,focusingPrecisionOptions}=precisionForListedOptions[
			KeyTake[capillaryIsoelectricFocusingOptionsAssociation,
				{VoltageDurationProfile,StandardVoltageDurationProfile,BlankVoltageDurationProfile}],
			{1 Volt,10^-4 Second}];

		(* run RoundOptionPrecision on all other relevant options, except VoltageDurationProfile options *)
		{roundedSingletonOptions,singletonTests}=If[gatherTests,
			RoundOptionPrecision[capillaryIsoelectricFocusingOptionsAssociation,
				{SampleVolume,TotalVolume,PremadeMasterMixVolume,AmpholyteVolume,IsoelectricPointMarkersVolume,ElectroosmoticFlowBlockerVolume,DenaturationReagentVolume,AnodicSpacerVolume,CathodicSpacerVolume,StandardVolume,StandardTotalVolume,StandardPremadeMasterMixVolume,StandardAmpholyteVolume,StandardIsoelectricPointMarkersVolume,StandardElectroosmoticFlowBlockerVolume,StandardDenaturationReagentVolume,StandardAnodicSpacerVolume,StandardCathodicSpacerVolume,BlankVolume,BlankTotalVolume,BlankPremadeMasterMixVolume,BlankAmpholyteVolume,BlankIsoelectricPointMarkersVolume,BlankElectroosmoticFlowBlockerVolume,BlankDenaturationReagentVolume,BlankAnodicSpacerVolume,BlankCathodicSpacerVolume,LoadTime,NativeFluorescenceExposureTime,StandardLoadTime,StandardNativeFluorescenceExposureTime,BlankLoadTime,BlankNativeFluorescenceExposureTime},
				{10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^0 Second,10^-4 Second,10^0 Second,10^-4 Second,10^0 Second,
					10^-4 Second },
				Output->{Result,Tests}],
			{RoundOptionPrecision[capillaryIsoelectricFocusingOptionsAssociation,
				{SampleVolume,TotalVolume,PremadeMasterMixVolume,AmpholyteVolume,IsoelectricPointMarkersVolume,ElectroosmoticFlowBlockerVolume,DenaturationReagentVolume,AnodicSpacerVolume,CathodicSpacerVolume,StandardVolume,StandardTotalVolume,StandardPremadeMasterMixVolume,StandardAmpholyteVolume,StandardIsoelectricPointMarkersVolume,StandardElectroosmoticFlowBlockerVolume,StandardDenaturationReagentVolume,StandardAnodicSpacerVolume,StandardCathodicSpacerVolume,BlankVolume,BlankTotalVolume,BlankPremadeMasterMixVolume,BlankAmpholyteVolume,BlankIsoelectricPointMarkersVolume,BlankElectroosmoticFlowBlockerVolume,BlankDenaturationReagentVolume,BlankAnodicSpacerVolume,BlankCathodicSpacerVolume,LoadTime,NativeFluorescenceExposureTime,StandardLoadTime,StandardNativeFluorescenceExposureTime,BlankLoadTime,BlankNativeFluorescenceExposureTime},
				{10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^0 Second,10^-4 Second,10^0 Second,10^-4 Second,10^0 Second,
					10^-4 Second }],
				{}}
		];

		(* gather all rounded options and tests *)
		roundedCIEFOptions=Join[roundedSingletonOptions,roundedFocusingOptions];
		precisionTests=Join[focusingPrecisionOptions,singletonTests];

		(*-- CompatibleMaterialsQ --*)
		{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
			CompatibleMaterialsQ[Lookup[roundedCIEFOptions,Instrument],simulatedSamples,Cache->inheritedCache,Simulation->updatedSimulation,Output->{Result,Tests}],
			{CompatibleMaterialsQ[Lookup[roundedCIEFOptions,Instrument],simulatedSamples,Cache->inheritedCache,Simulation->updatedSimulation,Messages->messages],{}}
		];

		(* If the materials are incompatible, then the Instrument is invalid *)
		compatibleMaterialsInvalidInputs=If[Not[compatibleMaterialsBool]&&messages,
			Download[mySamples,Object],
			{}
		];

		(*-- RESOLVE EXPERIMENT OPTIONS --*)

		(* resolve standards and expand standard options *)
		(*retrieve all of the options that index match to Standards*)
		standardOptionList="OptionName"/.
			Cases[OptionDefinition[ExperimentCapillaryIsoelectricFocusing],
				KeyValuePattern["IndexMatchingParent"->"Standards"]];

		standardOptionList=ToExpression[#]&/@standardOptionList;

		(* any changes in default setting trigger Include *)
		includeStandardOptionBool=Map[
			MatchQ[Lookup[roundedCIEFOptions,#],Except[getDefault[#,opsDef]|Automatic|Null|False]]&,
			standardOptionList
		];

		standardInInjectionTableBool=If[
			MatchQ[Lookup[roundedCIEFOptions,InjectionTable],Except[Automatic|Null]],
			MemberQ[Lookup[roundedCIEFOptions,InjectionTable][[All,1]],Standard],
			False];

		(*resolve the IncludeStandard option based on the setting of the others*)
		resolveIncludeStandards=Which[
			MatchQ[Lookup[roundedCIEFOptions,IncludeStandards],Except[Automatic]],
			Lookup[roundedCIEFOptions,IncludeStandards],
			(* if a standard is specified in the injection table *)
			standardInInjectionTableBool,True,
			Or@@includeStandardOptionBool,True,
			True,False
		];

		(* To figure out how many standards we need to have, grab the length of any specified option and use the longest to resolve the number of standards *)
		requiredStandards = If[resolveIncludeStandards,
			(* if we have any relevant options specified, get their length and return the longest or just 1 *)
			Max[
				Flatten[{
					1,
					Map[
						Function[option, Length[ToList[option]]],
						Map[Lookup[roundedCIEFOptions,#]&,standardOptionList]
					]
				}]
			],
			(* not doing standards, dont worry about it *)
			0
		];

		(* if standards are set, grab them, if not, but resolveIncludestandards = True, grab from injectionTable, if no injection table, grab default standard *)
		resolvedStandards=Which[
			MatchQ[Lookup[roundedCIEFOptions,Standards],Except[Automatic|{Automatic..}]],
			(* if only one was specified but we actually need more, give them what they want.. *)
				If[MatchQ[Lookup[roundedCIEFOptions,Standards], ObjectP[]],
					ConstantArray[Lookup[roundedCIEFOptions,Standards],requiredStandards],
					(* still replacing automatics in case theres a mix of objects and automatics *)
					Lookup[roundedCIEFOptions,Standards]/.Automatic:>Model[Sample,StockSolution,"Resuspended cIEF System Suitability Peptide Panel"]
				],
			resolveIncludeStandards,
			(* if none were specified, check the injection table, if no injection table was specified, just give the default, but at the right amount. *)
			If[MatchQ[Lookup[roundedCIEFOptions,InjectionTable],Except[Automatic]],
				Select[Lookup[roundedCIEFOptions,InjectionTable],MatchQ[First[#],Standard]&][[All,2]],
				ConstantArray[Model[Sample,StockSolution,"Resuspended cIEF System Suitability Peptide Panel"],requiredStandards]
			],
			True,Null
		];

		(* to make sure we expend all relevant options in a flexible way, preexpend and then listify accordingly *)
		preexpandedStandardsOptions=If[!resolveIncludeStandards,
			Association[#->Null&/@standardOptionList],
			Last[ExpandIndexMatchedInputs[
				ExperimentCapillaryIsoelectricFocusing,
				{mySamples},
				Normal[Append[
					KeyTake[capillaryIsoelectricFocusingOptionsAssociation,standardOptionList],
					Standards->resolvedStandards
				]],
				Messages->False
			]]
		];

		(* because of the widgets allowing automatics witnin the options, ExpandIndexMatched is messing up the nestedIndexMatched
		 causing {Automatic, Automatic}, to become {{Automatic,Automatic},{Automatic,Automatic}} instead of {{Automatic},{Automatic}} *)

		nestedMatchSafePreexpandedStandardsOptions = Map[
			Function[{preexpandedOption},
				(* replace any nested list with only automatics by a list with a single automatic if it is a nested list*)
				If[Depth[preexpandedOption]>=3,
					preexpandedOption /. {Automatic..}:>{Automatic},
					preexpandedOption
				]
			],
			Association[preexpandedStandardsOptions]
		];

		{resolvedStandards,expandedStandardsOptions}=If[And[
			Depth[Lookup[nestedMatchSafePreexpandedStandardsOptions,Standards]]<=2,
			MatchQ[Lookup[nestedMatchSafePreexpandedStandardsOptions,Standards],Except[{}|Null]]
		],
			{
				ToList[Lookup[nestedMatchSafePreexpandedStandardsOptions,Standards]],
				Map[List[#] &,nestedMatchSafePreexpandedStandardsOptions]
			},
			(*if not the singleton case, then nothing to change*)
			{
				Lookup[nestedMatchSafePreexpandedStandardsOptions,Standards],
				nestedMatchSafePreexpandedStandardsOptions
			}
		];

		(* same for blanks *)
		blankOptionList="OptionName"/.
			Cases[OptionDefinition[ExperimentCapillaryIsoelectricFocusing],
				KeyValuePattern["IndexMatchingParent"->"Blanks"]
			];

		blankOptionList=ToExpression[#]&/@blankOptionList;

		(*check if any of the Blank options are set*)
		includeBlankOptionBool=Map[
			MatchQ[Lookup[roundedCIEFOptions,#],Except[getDefault[#,opsDef]|Automatic|Null|False]]&,
			blankOptionList
		];

		blanksInInjectionTableBool=If[
			MatchQ[Lookup[roundedCIEFOptions,InjectionTable],Except[Automatic|Null]],
			MemberQ[Lookup[roundedCIEFOptions,InjectionTable][[All,1]],Blank],
			False];

		(*resolve the IncludeBlank option based on the setting of the others*)
		resolveIncludeBlanks=Which[
			MatchQ[Lookup[roundedCIEFOptions,IncludeBlanks],Except[Automatic]],
			Lookup[roundedCIEFOptions,IncludeBlanks],
			(* if a standard is specified in the injection table *)
			blanksInInjectionTableBool,True,
			Or@@includeBlankOptionBool,True,
			True,False
		];

		(* To figure out how many blanks we need to have, grab the length of any specified option and use the longest to resolve the number of blanks *)
		requiredBlanks = If[resolveIncludeBlanks,
			(* if we have any relevant options specified, get their length and return the longest or just 1 *)
			Max[
				Flatten[{
					1,
					Map[
						Function[option, Length[ToList[option]]],
						Map[Lookup[roundedCIEFOptions,#]&,blankOptionList]
					]
				}]
			],
			(* not doing blanks, dont worry about it *)
			0
		];

		(* if blanks are set, grab them, if not, but resolveIncludeBlanks = True, grab from injectionTable, if no injection table, grab default blank *)
		resolvedBlanks=Which[
			MatchQ[Lookup[roundedCIEFOptions,Blanks],Except[Automatic|{Automatic..}]],
			(* if only one was specified but we actually need more, give them what they want.. *)
			If[MatchQ[Lookup[roundedCIEFOptions,Blanks], ObjectP[]],
				ConstantArray[Lookup[roundedCIEFOptions,Blanks],requiredBlanks],
				(* still replacing automatics in case theres a mix of objects and automatics *)
				Lookup[roundedCIEFOptions,Blanks]/.Automatic:>Model[Sample,"Milli-Q water"]
			],
			resolveIncludeBlanks,
			If[MatchQ[Lookup[roundedCIEFOptions,InjectionTable],Except[Automatic|Null]],
				Select[Lookup[roundedCIEFOptions,InjectionTable],MatchQ[First[#],Blank]&][[All,2]],
				ConstantArray[Model[Sample,"Milli-Q water"],requiredBlanks]
			],
			True,Null
		];

		(* to make sure we expend all relevant options in a flexible way, preexpend and then listify accordingly *)
		preexpandedBlanksOptions=If[!resolveIncludeBlanks,
			Association[#->Null&/@blankOptionList],
			Last[ExpandIndexMatchedInputs[
				ExperimentCapillaryIsoelectricFocusing,
				{mySamples},
				Normal[Append[
					KeyTake[capillaryIsoelectricFocusingOptionsAssociation,blankOptionList],
					Blanks->resolvedBlanks
				]],
				Messages->False
			]]
		];

		(* Check if IncludeStandard/IncludeBlanks are false but any related options have been set *)
		includeBlanksFalseOptionsSpecifiedError = Not[resolveIncludeBlanks]&&Or@@includeBlankOptionBool;
		includeStandardsFalseOptionsSpecifiedError = Not[resolveIncludeStandards]&&Or@@includeStandardOptionBool;

		(* This might be out of place, but we need to raise an error somewhere, so here is probably as good a place as any *)
		(*CIEFBlanksFalseOptionsSpecifiedError*)
		blanksFalseOptionsSpecifiedInvalidOption=If[includeBlanksFalseOptionsSpecifiedError&&messages,
			(
				Message[Error::CIEFBlanksFalseOptionsSpecifiedError];
				{IncludeBlanks}
			),
			{}
		];

		blanksFalseOptionsSpecifiedTest=If[gatherTests,
			Test["When IncludeBlanks is set to False no Blank-related options are specified:",
				Not[includeBlanksFalseOptionsSpecifiedError],
				True
			],
			Nothing
		];

		(*CIEFStandardsFalseOptionsSpecifiedError*)
		standardsFalseOptionsSpecifiedInvalidOption=If[includeStandardsFalseOptionsSpecifiedError&&messages,
			(
				Message[Error::CIEFStandardsFalseOptionsSpecifiedError];
				{IncludeStandards}
			),
			{}
		];

		standardsFalseOptionsSpecifiedTest=If[gatherTests,
			Test["When IncludeStandards is set to False no Standard-related options are specified:",
				Not[includeStandardsFalseOptionsSpecifiedError],
				True
			],
			Nothing
		];

		(* because of the widgets allowing automatics witnin the options, ExpandIndexMatched is messing up the nestedIndexMatched
 causing {Automatic, Automatic}, to become {{Automatic,Automatic},{Automatic,Automatic}} instead of {{Automatic},{Automatic}} *)

		nestedMatchSafePreexpandedBlanksOptions = Map[
			Function[{preexpandedOption},
				(* replace any nested list with only automatics by a list with a single automatic if it is a nested list*)
				If[Depth[preexpandedOption]>=3,
					preexpandedOption /. {Automatic..}:>{Automatic},
					preexpandedOption
				]
			],
			Association[preexpandedBlanksOptions]
		];

		{resolvedBlanks,expandedBlanksOptions}=If[And[
			Depth[Lookup[nestedMatchSafePreexpandedBlanksOptions,Blanks]]<=2,
			MatchQ[Lookup[nestedMatchSafePreexpandedBlanksOptions,Blanks],Except[{}|Null]]
		],
			{
				ToList[Lookup[nestedMatchSafePreexpandedBlanksOptions,Blanks]],
				Map[List[#] &,nestedMatchSafePreexpandedBlanksOptions]
			},
			(*if not the singleton case, then nothing to change*)
			{
				Lookup[nestedMatchSafePreexpandedBlanksOptions,Blanks],
				nestedMatchSafePreexpandedBlanksOptions
			}
		];

		(* split and Expand nested indexMatched options and round*)
		(* prepare lists of options for a MapThread. Make sure the Volume is third in nestedIndexMatchedOptions so we can pull it out to round below *)
		(* I do realize I couldve mapped over the mapthread, but its a bit too late for that now *)
		(* the options to use for expansion *)
		expandedOptions={roundedCIEFOptions,roundedCIEFOptions,
			Association[expandedStandardsOptions],Association[expandedStandardsOptions],
			Association[expandedBlanksOptions],Association[expandedBlanksOptions]
		};

		(* the parent option all nestedIndexMatched options need to align according to *)
		parentOptions={
			Ampholytes,IsoelectricPointMarkers,
			StandardAmpholytes,StandardIsoelectricPointMarkers,
			BlankAmpholytes,BlankIsoelectricPointMarkers
		};

		(* the relevant options to expland *)
		nestedMatchedOptions=
			{
				{Ampholytes,AmpholyteTargetConcentrations,AmpholyteVolume,AmpholytesStorageCondition},
				{IsoelectricPointMarkers,IsoelectricPointMarkersTargetConcentrations,IsoelectricPointMarkersVolume,IsoelectricPointMarkersStorageCondition},
				{StandardAmpholytes,StandardAmpholyteTargetConcentrations,StandardAmpholyteVolume,StandardAmpholytesStorageCondition},
				{StandardIsoelectricPointMarkers,StandardIsoelectricPointMarkersTargetConcentrations,StandardIsoelectricPointMarkersVolume,StandardIsoelectricPointMarkersStorageCondition},
				{BlankAmpholytes,BlankAmpholyteTargetConcentrations,BlankAmpholyteVolume,BlankAmpholytesStorageCondition},
				{BlankIsoelectricPointMarkers,BlankIsoelectricPointMarkersTargetConcentrations,BlankIsoelectricPointMarkersVolume,BlankIsoelectricPointMarkersStorageCondition}
			};

		(* the list of objects passed for samples, blanks or standards *)
		objectsByGroup ={
			mySamples, mySamples,
			resolvedStandards, resolvedStandards,
			resolvedBlanks ,resolvedBlanks
		};

		(* a list of booleans, so we dont try to expand when no standards or blanks are passed. *)
		expandThis ={
			True, True,
			resolveIncludeStandards,resolveIncludeStandards,
			resolveIncludeBlanks,resolveIncludeBlanks
		};

		(* Split and round *)
		(* quick note - using ExpandByLongest-> True is much easier to control, and we have safeguards later to should help avoid weird situations.. *)
		{
			{ampolyteOptions,ampolyteOptionsTests,ampolyteOptionsPrecisionTests},
			{pIMarkerOptions,pIMarkerOptionsTests,pIMarkerOptionsPrecisionTests},
			{standardAmpolyteOptions,standardAmpolyteOptionsTests,standardAmpolyteOptionsPrecisionTests},
			{standardPIMarkerOptions,standardPIMarkerOptionsTests,standardPIMarkerOptionsPrecisionTests},
			{blankAmpolyteOptions,blankAmpolyteOptionsTests,blankAmpolyteOptionsPrecisionTests},
			{blankPIMarkerOptions,blankPIMarkerOptionsTests,blankPIMarkerOptionsPrecisionTests}
		}=MapThread[
			Function[{sampleTypeExpandedOptions,parentOption,nestedIndexMatchedOptions, specifiedObjects, includeObjects},
				(* if we dont have standards and or blanks, just return the options as is and tests should be empty *)
				If[!includeObjects,
					{Lookup[sampleTypeExpandedOptions,nestedIndexMatchedOptions], {}, {}},
					(* otherwise, go ahead and expand if needed *)
					Module[{expandByLongest, messagesToQuiet,expandedNestedOptions,expandedNestedTests,roundedVolume,roundedExpandedNestedTests,roundedExpandedNestedOptions},

						(* we decide what to expand by, parent or longest, based on what the user specified. If the parent option is specified by the user,
						 ExpendByLongest is false, otherwise it is True (to allow expanding the parent option based on other options. *)
						expandByLongest = Not[MemberQ[unresolvedOptionsKeys,parentOption]];

						(* if we expend by anything but the parent option, we will get a warning that's not really useful for the user so be selective about what we quiet too; currently quieting all messages because teh ::Engilsh workaround does not work.. *)
						messagesToQuiet = If[expandByLongest,
							{Error::ExpandedNestedIndexLengthMismatch::English,Warning::NestedIndexLengthMismatch::English},
							{Error::ExpandedNestedIndexLengthMismatch::English}
						];

						(* expand options - Quieting Error::ExpandedNestedIndexLengthMismatch because we check again later on in the resolver so no need to raise the same error twice *)
						{expandedNestedOptions,expandedNestedTests}=If[gatherTests,
							Quiet[expandNestedIndexMatch[
								ExperimentCapillaryIsoelectricFocusing,
								sampleTypeExpandedOptions,
								specifiedObjects,
								parentOption,
								nestedIndexMatchedOptions,
								ExpandByLongest->expandByLongest,
								Output->{Result,Tests}
							]],
							{Quiet[expandNestedIndexMatch[
								ExperimentCapillaryIsoelectricFocusing,
								sampleTypeExpandedOptions,
								specifiedObjects,
								parentOption,
								nestedIndexMatchedOptions,
								ExpandByLongest->expandByLongest
							]],{}}];

						(* round volume. make sure the volume is the third option in nestedIndexMatchedOptions, otherwise this would do nothing. *)
						(* Flatten volumes then reconstruct with old structure *)

						{roundedVolume,roundedExpandedNestedTests}=If[gatherTests,
							(* We still want to keep the association structure to get meaningful tests, so we flatten values *)
							RoundOptionPrecision[
								Association@@Thread[Keys[expandedNestedOptions] -> Flatten/@Values[expandedNestedOptions]],
								nestedIndexMatchedOptions[[3]],
								10^-1Microliter,
								Output->{Result,Tests}],
							{RoundOptionPrecision[
								Association@@Thread[Keys[expandedNestedOptions] -> Flatten/@Values[expandedNestedOptions]],
								nestedIndexMatchedOptions[[3]],
								10^-1Microliter],
								{}}
						];

						(* rebuild the association with rounded volumes and restructure for rounded volume since we flattened *)
						roundedExpandedNestedOptions =List@@KeyValueMap[
							Function[{key,flattenedValue},
								key -> TakeList[flattenedValue,Length/@(key/.(expandedNestedOptions))]
							],
							roundedVolume
						];

						(* return the rounded options and joined tests *)
						{roundedExpandedNestedOptions,expandedNestedTests,ToList[roundedExpandedNestedTests]}
					]
				]
			],
			{expandedOptions,parentOptions,nestedMatchedOptions, objectsByGroup, expandThis}
		];


		(* Join options and tests *)
		(* join all results to a list, clear Nulls and make it to an association, then join with old association to replace values *)
		joinedExpandedOptions = Cases[Join[ampolyteOptions,standardAmpolyteOptions,blankAmpolyteOptions,
			pIMarkerOptions,standardPIMarkerOptions,blankPIMarkerOptions],Except[Null]];


		(* replace the expanded nested multiples to the previously expanded options. When no blanks or standards are specified, we will get a list of nulls. just avoid that by making them an empty list*)
		expandedStandardsOptions = Join[expandedStandardsOptions,Association[standardAmpolyteOptions/.{Null..}:>{}], Association[standardPIMarkerOptions/.{Null..}:>{}]];
		expandedBlanksOptions = Join[expandedBlanksOptions,Association[blankAmpolyteOptions/.{Null..}:>{}], Association[blankPIMarkerOptions/.{Null..}:>{}]];

		(* while duplicating the parent option is something we deal with later for standards and blanks, these options for sampleIs allow duplicating the parent nested index matched options
   like ampholytes and isoelectric point markers (e.g., pass ampholyte X with volumes {1ul, 2ul{ will result in ampholytes {x,x} volume {1ul, 2ul} instead of raising an error later.
   we correct this here *)
		roundedCapillaryIsoelectricFocusingOptions = Module[
			{
				allOptions,ampholyteOptionsParentMatched,pIMarkersOptionsParentMatched
			},
			allOptions = Join[roundedCIEFOptions, Association[joinedExpandedOptions]];

			ampholyteOptionsParentMatched = If[Length[Flatten[Ampholytes /. allOptions]] == Length[Flatten[Lookup[roundedCIEFOptions,Ampholytes]]],
				(* if the length of the parent option is the same as it was before expansion, we're good and can use the same values *)
				<|Ampholytes -> Ampholytes /. allOptions|>,
				(* if it does not match, we revert its value to the original and turn it back to a list *)
				<|Ampholytes -> Lookup[roundedCIEFOptions,Ampholytes]|>
			];

			pIMarkersOptionsParentMatched =  If[Length[Flatten[IsoelectricPointMarkers /. allOptions]] == Length[Flatten[Lookup[roundedCIEFOptions,IsoelectricPointMarkers]]],
				(* if the length of the parent option is the same as it was before expansion, we're good and can use the same values *)
				<|IsoelectricPointMarkers -> IsoelectricPointMarkers /. allOptions|>,
				(* if it does not match, we revert its value to the original and turn it back to a list *)
				<|IsoelectricPointMarkers -> Lookup[roundedCIEFOptions,IsoelectricPointMarkers]|>
			];
			Join[allOptions, ampholyteOptionsParentMatched, pIMarkersOptionsParentMatched]
		];

		expandNestedIndexMatchedTests=Join[ampolyteOptionsTests,standardAmpolyteOptionsTests,blankAmpolyteOptionsTests,
			pIMarkerOptionsTests,standardPIMarkerOptionsTests,blankPIMarkerOptionsTests];

		allPrecisionTests=Join[precisionTests,ampolyteOptionsPrecisionTests,standardAmpolyteOptionsPrecisionTests,blankAmpolyteOptionsPrecisionTests,
			pIMarkerOptionsPrecisionTests,standardPIMarkerOptionsPrecisionTests,blankPIMarkerOptionsPrecisionTests];


		(* before going into the mapThread, we need to see if the user specified an injection table, and if they did,
		grab volumes to pass to the mapthread *)
		specifiedInjectionTable = Lookup[roundedCapillaryIsoelectricFocusingOptions, InjectionTable];

		(* check if both Injection table AND NumberOfReplicates were specified. if they were, error out *)
		(* grab number of replicates *)
		specifiedNumberOfReplicates=Lookup[roundedCapillaryIsoelectricFocusingOptions,NumberOfReplicates];

		(* raise error if both an injection table and NumberOfReplicates were specified *)
		injectionTableWithReplicatesInvalidOption=If[MatchQ[specifiedInjectionTable,Except[Automatic]]&&MatchQ[specifiedNumberOfReplicates,Except[Null]]&&messages,
			(
				Message[Error::InjectionTableReplicatesSpecified];
				{InjectionTable, NumberOfReplicates}
			),
			{}
		];

		(* If we need to gather tests, generate the tests for injection table and replicates check *)
		injectionTableWithReplicatesInvalidTest=If[gatherTests,
			Test["Only one of the InjectionTable and NumberOfReplicates options is specified:",
				MatchQ[specifiedInjectionTable,Except[Automatic]]&&MatchQ[specifiedNumberOfReplicates,Except[Null]],
				False
			],
			Nothing
		];

		(* see if any of the specified volumes is zero *)
		volumeZeroInjectionTableBool = If[MatchQ[specifiedInjectionTable,Except[Automatic]],
			#==0Microliter& /@ specifiedInjectionTable[[All,3]],
			{False}
		];

		(* Injection table with volume zero *)
		injectionTableVolumeZeroInvalidOption=If[Or@@volumeZeroInjectionTableBool&&messages,
			(
				Message[Error::InjectionTableVolumeZero, specifiedInjectionTable[[Flatten[Position[volumeZeroInjectionTableBool, True]]]]];
				{InjectionTable}
			),
			{}
		];

		(* If we need to gather tests, generate the tests for injection table and replicates check *)
		injectionTableVolumeZeroInvalidTest=If[gatherTests,
			Test["None of the volumes specified in InjectionTable is 0 Microliter:",
				Or@@volumeZeroInjectionTableBool,
				False
			],
			Nothing
		];

		(* to make sure we dont use an invalid injection table later, keep this boolean *)
		injectionTableValidQ = !(MatchQ[specifiedInjectionTable,Except[Automatic]]&&MatchQ[specifiedNumberOfReplicates,Except[Null]])&&!Or@@volumeZeroInjectionTableBool;

		(* Informing volumes from the injection table runs the risk of it not being copacetic with specified samples/standards/blanks *)
		injectionTableSamplesNotCopaceticQ = If[MatchQ[specifiedInjectionTable,Except[Automatic]],
			Not[And[
				ContainsAll[
					Cases[specifiedInjectionTable, {Sample,ObjectP[],VolumeP|Automatic}][[All,2]],
					Cases[mySamples,ObjectP[]]
				],
				ContainsAll[
					Cases[mySamples,ObjectP[]],
					Cases[specifiedInjectionTable, {Sample,ObjectP[],VolumeP|Automatic}][[All,2]]
				]
			]],
			False
		];

		injectionTableSampleVolumes = If[Not[injectionTableSamplesNotCopaceticQ]&&injectionTableValidQ,
			Switch[specifiedInjectionTable,
				{{_,ObjectP[],VolumeP|Automatic}..}, Cases[specifiedInjectionTable, {Sample,ObjectP[],VolumeP|Automatic}][[All,3]],
				Automatic, ConstantArray[Automatic, Length[mySamples]]
			],
			(* If samples in injection tables dont match samplesIn, dont inform volume, we'll raise an error a bit later *)
			ToList[Lookup[roundedCapillaryIsoelectricFocusingOptions, SampleVolume]]
		];

		(* we need to account for a situation where the injection table is not in agreement with samplesIn and options.
		there is an error check later, but we want to make sure we dont break the MapThread *)
		injectionTableSampleVolumes = If[Length[injectionTableSampleVolumes]!=Length[mySamples],
			ConstantArray[Automatic, Length[mySamples]],
			injectionTableSampleVolumes
		];

		(* round volumes *)
		roundedInjectionTableSampleVolumes = RoundOptionPrecision[injectionTableSampleVolumes, 10^-1Microliter];


		(* Convert our options into a MapThread friendly version. *)
		mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentCapillaryIsoelectricFocusing,roundedCapillaryIsoelectricFocusingOptions];

		(* MapThread over each of our samples. *)
		{
			(* general option variables *)
			resolvedTotalVolume,
			resolvedSampleVolume,
			resolvedImagingMethods,
			resolvedNativeFluorescenceExposureTimes,
			(* general option errors *)
			missingSampleCompositionWarnings,
			OnBoardMixingIncompatibleVolumesErrors,
			imagingMethodMismatchErrors,
			voltageDurationStepErrors,
			(* premade mastermix branch variables *)
			resolvedPremadeMasterMix,
			resolvedPremadeMasterMixReagent,
			resolvedPremadeMasterMixVolume,
			resolvedPremadeMasterMixDilutionFactor,
			resolvedPremadeMasterMixDiluent,
			(* premade mastermix branch errors *)
			premadeMastermixFalseOptionsSpecifiedErrors,
			premadeMasterMixNullErrors,
			premadeMasterMixDilutionFactorNullErrors,
			premadeMasterMixVolumeNullErrors,
			premadeMasterMixVolumeDilutionFactorMismatchWarnings,
			premadeMasterMixTotalVolumeErrors,
			premadeMasterMixDiluentNullErrors,
			(* make-ones-own mastermix branch variables *)
			resolvedDiluent,
			resolvedAmpholytes,
			resolvedAmpholyteTargetConcentrations,
			resolvedAmpholyteVolume,
			resolvedIsoelectricPointMarkers,
			resolvedIsoelectricPointMarkersTargetConcentrations,
			resolvedIsoelectricPointMarkersVolume,
			resolvedAmpholytesStorageConditions,
			resolvedIsoelectricPointMarkersStorageConditions,
			resolvedElectroosmoticFlowBlocker,
			resolvedElectroosmoticFlowBlockerTargetConcentrations,
			resolvedElectroosmoticFlowBlockerVolume,
			resolvedDenature,
			resolvedDenaturationReagent,
			resolvedDenaturationReagentTargetConcentration,
			resolvedDenaturationReagentVolume,
			resolvedIncludeAnodicSpacer,
			resolvedAnodicSpacer,
			resolvedAnodicSpacerTargetConcentration,
			resolvedAnodicSpacerVolume,
			resolvedIncludeCathodicSpacer,
			resolvedCathodicSpacer,
			resolvedCathodicSpacerTargetConcentration,
			resolvedCathodicSpacerVolume,
			(* make-ones-own mastermix branch errors *)
			nullDiluentErrors,
			noSpecifiedAmpholytesErrors,
			ampholyteMatchedlengthsNotCopaceticErrors,
			ampholyteVolumeNullErrors,
			ampholyteConcentrationNullErrors,
			ampholyteVolumeConcentrationMismatchErrors,
			noSpecifiedIsoelectricPointMarkersErrors,
			resolverCantFixIsoelectricPointMarkersMismatchErrors,
			isoelectricPointMarkersVolumeNullErrors,
			isoelectricPointMarkersConcentrationNullErrors,
			isoelectricPointMarkersVolumeConcentrationMismatchErrors,
			electroosmoticFlowBlockerNullErrors,
			noElectroosmoticFlowBlockerAgentIdentifiedWarnings,
			electroosmoticFlowBlockerVolumeNullErrors,
			electroosmoticFlowBlockerConcentrationNullErrors,
			eofBlockerVolumeConcentrationMismatchErrors,
			denatureFalseOptionsSpecifiedErrors,
			denaturationReagentNullErrors,
			noDenaturationReagentIdentifiedErrors,
			resolveableDenatureReagentConcentrationUnitMismatchErrors,
			unresolveableDenatureReagentConcentrationUnitMismatchErrors,
			denaturationReagentVolumeNullErrors,
			denaturationReagentConcentrationNullErrors,
			denaturationReagentConcentrationVolumeMismatchErrors,
			anodicSpacerFalseOptionsSpecifiedErrors,
			anodicSpacerNullErrors,
			noAnodicSpacerIdentifiedErrors,
			anodicSpacerVolumeNullErrors,
			anodicSpacerConcentrationNullErrors,
			anodicSpacerConcentrationVolumeMismatchErrors,
			cathodicSpacerFalseOptionsSpecifiedErrors,
			cathodicSpacerNullErrors,
			noCathodicSpacerIdentifiedErrors,
			cathodicSpacerVolumeNullErrors,
			cathodicSpacerConcentrationNullErrors,
			cathodicSpacerConcentrationVolumeMismatchErrors,
			sumOfVolumesOverTotalvolumeErrors
		}=Transpose[MapThread[
			Function[{mySample,myMapThreadOptions, injectionTableSampleVolume},
				Module[
					{
						totalVolume,sampleVolume,missingSampleCompositionWarning,OnBoardMixingIncompatibleVolumesError,
						preMadeMasterMixOptions,includePremadeMasterMixBool,resolvePremadeMasterMix,premadeMasterMixReagent,
						premadeMastermixFalseOptionsSpecifiedError,	premadeMasterMixVolume,premadeMasterMixDilutionFactor,
						premadeMasterMixDiluent,premadeMasterMixNullError,	premadeMasterMixDilutionFactorNullError,
						premadeMasterMixVolumeNullError,premadeMasterMixVolumeDilutionFactorMismatchWarning,premadeMasterMixTotalVolumeError,
						premadeMasterMixDiluentNullError,diluent,ampholytes,ampholyteTargetConcentrations,
						ampholyteVolume,isoelectricPointMarkers,isoelectricPointMarkersTargetConcentrations,isoelectricPointMarkersVolume,
						electroosmoticFlowBlocker,electroosmoticFlowBlockerTargetConcentrations,electroosmoticFlowBlockerVolume,
						denature,denaturationReagent,denaturationReagentTargetConcentration,denaturationReagentVolume,includeAnodicSpacer,
						anodicSpacer,anodicSpacerTargetConcentration,anodicSpacerVolume,includeCathodicSpacer,cathodicSpacer,
						cathodicSpacerTargetConcentration,cathodicSpacerVolume,ampholyteStorageCondition,
						isoelectricPointMarkerStorageCondition,noSpecifiedAmpholytesError,nullDiluentError,
						ampholyteVolumeNullError,ampholyteConcentrationNullError,ampholyteVolumeConcentrationMismatchError,
						NoSpecifiedIsoelectricPointMarkersError,resolverCantFixIsoelectricPointMarkersMismatchError,
						isoelectricPointMarkersVolumeNullError,isoelectricPointMarkersConcentrationNullError,
						isoelectricPointMarkersVolumeConcentrationMismatchError,electroosmoticFlowBlockerNullError,
						noElectroosmoticFlowBlockerAgentIdentifiedWarning,electroosmoticFlowBlockerVolumeNullError,
						electroosmoticFlowBlockerConcentrationNullError,eofBlockerVolumeConcentrationMismatchError,
						denatureFalseOptionsSpecifiedError,	denaturationReagentNullError,noDenaturationReagentIdentifiedError,
						resolveableDenatureReagentConcentrationUnitMismatchError,unresolveableDenatureReagentConcentrationUnitMismatchError,
						denaturationReagentVolumeNullError,denaturationReagentConcentrationNullError,
						denaturationReagentConcentrationVolumeMismatchError,anodicSpacerFalseOptionsSpecifiedError,
						anodicSpacerNullError,noAnodicSpacerIdentifiedError,anodicSpacerVolumeNullError,
						anodicSpacerConcentrationNullError,anodicSpacerConcentrationVolumeMismatchError,
						cathodicSpacerFalseOptionsSpecifiedError,cathodicSpacerNullError,noCathodicSpacerIdentifiedError,
						cathodicSpacerVolumeNullError,cathodicSpacerConcentrationNullError,cathodicSpacerConcentrationVolumeMismatchError,
						sumOfVolumesOverTotalvolumeError,ampholyteMatchedlengthsNotCopaceticError,imagingMethods,
						nativeFLExposureTime,imagingMismatchError,voltageDurationStepError
					},
					(* Setup error tracking variables *)
					{
						missingSampleCompositionWarning,
						OnBoardMixingIncompatibleVolumesError,
						imagingMismatchError,
						voltageDurationStepError,
						premadeMastermixFalseOptionsSpecifiedError,
						premadeMasterMixNullError,
						premadeMasterMixDilutionFactorNullError,
						premadeMasterMixVolumeNullError,
						premadeMasterMixVolumeDilutionFactorMismatchWarning,
						premadeMasterMixTotalVolumeError,
						premadeMasterMixDiluentNullError,
						nullDiluentError,
						noSpecifiedAmpholytesError,
						ampholyteMatchedlengthsNotCopaceticError,
						ampholyteVolumeNullError,
						ampholyteConcentrationNullError,
						ampholyteVolumeConcentrationMismatchError,
						NoSpecifiedIsoelectricPointMarkersError,
						resolverCantFixIsoelectricPointMarkersMismatchError,
						isoelectricPointMarkersVolumeNullError,
						isoelectricPointMarkersConcentrationNullError,
						isoelectricPointMarkersVolumeConcentrationMismatchError,
						electroosmoticFlowBlockerNullError,
						noElectroosmoticFlowBlockerAgentIdentifiedWarning,
						electroosmoticFlowBlockerVolumeNullError,
						electroosmoticFlowBlockerConcentrationNullError,
						eofBlockerVolumeConcentrationMismatchError,
						denatureFalseOptionsSpecifiedError,
						denaturationReagentNullError,
						noDenaturationReagentIdentifiedError,
						resolveableDenatureReagentConcentrationUnitMismatchError,
						unresolveableDenatureReagentConcentrationUnitMismatchError,
						denaturationReagentVolumeNullError,
						denaturationReagentConcentrationNullError,
						denaturationReagentConcentrationVolumeMismatchError,
						anodicSpacerFalseOptionsSpecifiedError,
						anodicSpacerNullError,
						noAnodicSpacerIdentifiedError,
						anodicSpacerVolumeNullError,
						anodicSpacerConcentrationNullError,
						anodicSpacerConcentrationVolumeMismatchError,
						cathodicSpacerFalseOptionsSpecifiedError,
						cathodicSpacerNullError,
						noCathodicSpacerIdentifiedError,
						cathodicSpacerVolumeNullError,
						cathodicSpacerConcentrationNullError,
						cathodicSpacerConcentrationVolumeMismatchError,
						sumOfVolumesOverTotalvolumeError
					}=ConstantArray[False,48];

					(* resolve totalVolume *)
					totalVolume=If[Lookup[myMapThreadOptions,OnBoardMixing],
						(* when using obboardmixing, volumes are predetermined *)
						(* This should be 125 microliters, but this causes errors due to precision rounding for other reagents, so set to 125 *)
						Lookup[myMapThreadOptions,TotalVolume]/.Automatic:>125 Microliter,
						(* if not using OnBoardMixing, default to 100 microliters. *)
						Lookup[myMapThreadOptions,TotalVolume]/.Automatic:>100 Microliter
					];

					(* Resolve SampleVolume *)
					sampleVolume=Which[
						(* if informed, use it *)
						MatchQ[Lookup[myMapThreadOptions,SampleVolume],Except[Automatic]],
							Lookup[myMapThreadOptions,SampleVolume],
						(* if automatic, check if informed in the injection table *)
						MatchQ[injectionTableSampleVolume, VolumeP],
							injectionTableSampleVolume,
						(* If automatic and OnBoardMixing, set to 25 microliters *)
						Lookup[myMapThreadOptions,OnBoardMixing],
							25Microliter,
						(* if automatic, resolve it *)
						MatchQ[Lookup[myMapThreadOptions,SampleVolume],Automatic],
						(* if not informed, pull out composition and resolve volume to reach 0.2 mg/ml in total volume*)
							Module[{compositionProteins,proteinConcentration,calculatedVolume},
								(* get only proteins in the composition *)
								compositionProteins=Cases[Lookup[mySample,Composition],{_,ObjectP[Model[Molecule,Protein]]}];
								(* get concentrations and add all proteins in sample. If possible convert to mg/ml based on its unit *)
								proteinConcentration=If[Length[compositionProteins]==0,
									(* if no proteins in composition, return Null *)
									Null,
									(* if there are proteins in composition get their concentration in mg/ml *)
									Map[
										Function[molecule,Module[{moleculeMW},
											(* grab the Molecule,Protein Model, so you can grab the MW off of it *)
											moleculeMW=Flatten[Select[Lookup[DeleteCases[sampleCompositionModelPackets,Null],
												{Object,MolecularWeight}],MatchQ[#[[1]],Download[molecule[[2]],Object]]&]][[2]];
											(* Try to convert units to Milligram/Milliliter *)
											Switch[Quiet[Convert[molecule[[1]],Milligram/Milliliter]],
												Except[Alternatives[$Failed,Null]],Quiet[Convert[molecule[[1]],Milligram/Milliliter]],(* if it works, return this *)
												Null,Null,(* if returns null, there is no value for concentration *)
												$Failed,If[
												(*if returns $Failed,the unit cant be readily converted,so will further investigate if its MassPercent or Molarity]*)
												MatchQ[QuantityUnit[molecule[[1]]],IndependentUnit["MassPercent"]],
												QuantityMagnitude[molecule[[1]]]*(1000 Milligram)/(100 Milliliter),
												If[
													MatchQ[
														Quiet[Convert[molecule[[1]],Molar]],Except[$Failed|Null]
													]&&!NullQ[moleculeMW],
													Convert[molecule[[1]]*moleculeMW,Milligram/Milliliter]],
												Null]
											]]],
										compositionProteins
								]];
							(* If concentration in mg/ml could be calculated, return the volume to reach 1 mg / ml in totalVolume *)
							calculatedVolume=If[And@@Map[!NullQ[#]& ,ToList[proteinConcentration]],
								((0.2 Milligram/Milliliter)*totalVolume)/Total[proteinConcentration],
								(*otherwise, return volume that is 10% of the TotalVolume and raise warning *)
								missingSampleCompositionWarning=True;
								totalVolume*0.1];
							RoundOptionPrecision[Convert[calculatedVolume,Microliter],10^-1 Microliter,AvoidZero->True]
						]
					];

					(* if using OnBoardMixing, the volume added to sample must be over 100 ul (sample should be 25). will check the difference between total volume and sample volume - if less than 100, raise error *)
					OnBoardMixingIncompatibleVolumesError=If[Lookup[roundedCIEFOptions,OnBoardMixing],
						(totalVolume!=125 Microliter || sampleVolume!=25Microliter),
						False
					];

					(* resolve imaging methods *)
					imagingMethods = If[MatchQ[Lookup[myMapThreadOptions,ImagingMethods],Automatic],
						If[NullQ[Lookup[myMapThreadOptions,NativeFluorescenceExposureTime]],
							Absorbance,
							AbsorbanceAndFluorescence
						],
						Lookup[myMapThreadOptions,ImagingMethods]
					];

					nativeFLExposureTime = If[MatchQ[Lookup[myMapThreadOptions,NativeFluorescenceExposureTime],Automatic],
						Switch[imagingMethods,
							Absorbance, Null,
							AbsorbanceAndFluorescence, {3*Second,5*Second,10*Second,20*Second}
						],
						Lookup[myMapThreadOptions,NativeFluorescenceExposureTime]
					];

					(* if imaging methods is AbsorbanceAndFluorescence but exposure times are null, raise an error. same if its Absorbance but times are specified *)
					imagingMismatchError = MatchQ[imagingMethods, AbsorbanceAndFluorescence]&&NullQ[nativeFLExposureTime] ||
         				MatchQ[imagingMethods, Absorbance]&&!NullQ[nativeFLExposureTime];

					(* Check if voltage duration profiles have more than the allowed 20 steps. *)
					voltageDurationStepError = Length[Lookup[myMapThreadOptions,VoltageDurationProfile]]>20||Length[Lookup[myMapThreadOptions,VoltageDurationProfile]]==0;

					(* check if PremadeMasterMix should be True *)
					preMadeMasterMixOptions=
						{
							PremadeMasterMixReagent,PremadeMasterMixDiluent,PremadeMasterMixReagentDilutionFactor,PremadeMasterMixVolume
						};

					(* Should a premade mastermix be included *)
					includePremadeMasterMixBool=Map[
						MatchQ[#,Except[Automatic|Null|False]]&,
						Lookup[myMapThreadOptions,preMadeMasterMixOptions]
					];

					(* ResolvePremadeMastermix accordingly *)
					resolvePremadeMasterMix=Which[
						MatchQ[Lookup[myMapThreadOptions,PremadeMasterMix],Except[Automatic]],
						Lookup[myMapThreadOptions,PremadeMasterMix],
						Or@@includePremadeMasterMixBool,True,
						True,False
					];

					(* Did we specify any relevant options but set PremadeMasterMix to False? *)
					premadeMastermixFalseOptionsSpecifiedError = Not[resolvePremadeMasterMix]&&Or@@includePremadeMasterMixBool;

					(* resolve premadeMasterMixReagent *)
					premadeMasterMixReagent = If[resolvePremadeMasterMix,
						If[MatchQ[Lookup[myMapThreadOptions,PremadeMasterMixReagent],Except[Automatic]],
							Lookup[myMapThreadOptions,PremadeMasterMixReagent],
							Model[Sample, StockSolution, "2X Wide-Range cIEF Premade Master Mix"]
						],
						Lookup[myMapThreadOptions,PremadeMasterMixReagent] /. Automatic :> Null
					];

					(* PremadeMasterMix split to two branches *)
					{
						(* premade mastermix branch variables *)
						premadeMasterMixVolume,
						premadeMasterMixDilutionFactor,
						premadeMasterMixDiluent,
						(* premade mastermix branch errors *)
						premadeMasterMixNullError,
						premadeMasterMixDilutionFactorNullError,
						premadeMasterMixVolumeNullError,
						premadeMasterMixVolumeDilutionFactorMismatchWarning,
						premadeMasterMixTotalVolumeError,
						premadeMasterMixDiluentNullError,
						(* make-ones-own mastermix branch variables *)
						diluent,
						ampholytes,
						ampholyteTargetConcentrations,
						ampholyteVolume,
						isoelectricPointMarkers,
						isoelectricPointMarkersTargetConcentrations,
						isoelectricPointMarkersVolume,
						ampholyteStorageCondition,
						isoelectricPointMarkerStorageCondition,
						electroosmoticFlowBlocker,
						electroosmoticFlowBlockerTargetConcentrations,
						electroosmoticFlowBlockerVolume,
						denature,
						denaturationReagent,
						denaturationReagentTargetConcentration,
						denaturationReagentVolume,
						includeAnodicSpacer,
						anodicSpacer,
						anodicSpacerTargetConcentration,
						anodicSpacerVolume,
						includeCathodicSpacer,
						cathodicSpacer,
						cathodicSpacerTargetConcentration,
						cathodicSpacerVolume,
						(* make-ones-own mastermix branch errors *)
						nullDiluentError,
						noSpecifiedAmpholytesError,
						ampholyteMatchedlengthsNotCopaceticError,
						ampholyteVolumeNullError,
						ampholyteConcentrationNullError,
						ampholyteVolumeConcentrationMismatchError,
						NoSpecifiedIsoelectricPointMarkersError,
						resolverCantFixIsoelectricPointMarkersMismatchError,
						isoelectricPointMarkersVolumeNullError,
						isoelectricPointMarkersConcentrationNullError,
						isoelectricPointMarkersVolumeConcentrationMismatchError,
						electroosmoticFlowBlockerNullError,
						noElectroosmoticFlowBlockerAgentIdentifiedWarning,
						electroosmoticFlowBlockerVolumeNullError,
						electroosmoticFlowBlockerConcentrationNullError,
						eofBlockerVolumeConcentrationMismatchError,
						denatureFalseOptionsSpecifiedError,
						denaturationReagentNullError,
						noDenaturationReagentIdentifiedError,
						resolveableDenatureReagentConcentrationUnitMismatchError,
						unresolveableDenatureReagentConcentrationUnitMismatchError,
						denaturationReagentVolumeNullError,
						denaturationReagentConcentrationNullError,
						denaturationReagentConcentrationVolumeMismatchError,
						anodicSpacerFalseOptionsSpecifiedError,
						anodicSpacerNullError,
						noAnodicSpacerIdentifiedError,
						anodicSpacerVolumeNullError,
						anodicSpacerConcentrationNullError,
						anodicSpacerConcentrationVolumeMismatchError,
						cathodicSpacerFalseOptionsSpecifiedError,
						cathodicSpacerNullError,
						noCathodicSpacerIdentifiedError,
						cathodicSpacerVolumeNullError,
						cathodicSpacerConcentrationNullError,
						cathodicSpacerConcentrationVolumeMismatchError,
						sumOfVolumesOverTotalvolumeError
					}=If[MatchQ[resolvePremadeMasterMix,True],
						(* PremadeMasterMix, no need to get specific reagents *)
						Module[
							{
								masterMixNullError,masterMixDilutionFactorNullError,masterMixVolume,masterMixVolumeNullError,
								masterMixVolumeDilutionFactorMismatchWarning,masterMixTotalVolumeError,mixReagent,mixVolume,
								mixDilutionFactor,masterMixDilutionFactor,masterMixDiluent,masterMixDiluentNullError
							},
							(* gather options *)

							mixReagent=premadeMasterMixReagent;
							mixVolume=Lookup[myMapThreadOptions,PremadeMasterMixVolume];
							mixDilutionFactor=Lookup[myMapThreadOptions,PremadeMasterMixReagentDilutionFactor];

							(* check if PremadeMasterMixReagent is informed *)
							masterMixNullError=NullQ[mixReagent];

							(* Resolve PremadeMasterMixVolume *)
							{
								masterMixVolume,
								masterMixDilutionFactor,
								masterMixVolumeNullError,
								masterMixDilutionFactorNullError,
								masterMixVolumeDilutionFactorMismatchWarning
							}=Switch[mixVolume,
								(* If volume is Null, check if Dilution factor is null too, In which case return null and raise errors,*)
								(* If DilutionFactor isnt Null, Raise errors, but return Volume as Automatic would *)
								Null,If[
									NullQ[mixDilutionFactor],
									{Null,Null,
										True,True,False},
									{Null,mixDilutionFactor/.Automatic:>2,
										True,False,False}],
								(* If Volume is passed, all good, if dilution factor is also informed, check that they concur if not, raise warning *)
								VolumeP,If[
									NullQ[mixDilutionFactor],
									{mixVolume,mixDilutionFactor,
										False,True,False},
									{mixVolume,mixDilutionFactor/.Automatic:>N[totalVolume/mixVolume],
										False,False,mixVolume=!=(totalVolume/mixDilutionFactor/.Automatic:>(totalVolume/mixVolume))}],
								(* if automatic, make sure DilutionFactor is informed and calculate volume*)
								Automatic,If[
									NullQ[mixDilutionFactor],
									{Null,Null,
										False,True,False},
									{(totalVolume/mixDilutionFactor/.Automatic:>2),mixDilutionFactor/.Automatic:>2,
										False,False,False}]
							];

							masterMixTotalVolumeError=If[Not[And[masterMixDilutionFactorNullError,masterMixVolumeNullError]],
								(sampleVolume+masterMixVolume)>totalVolume,
								False];

							(* resolve diluent *)
							masterMixDiluent=Lookup[myMapThreadOptions,PremadeMasterMixDiluent]/.Automatic:>Model[Sample,"LCMS Grade Water"];
							(* if masterMix Diluent is Null but no need to top off to total volume, dont raise an error, otherwise raise an error *)
							masterMixDiluentNullError=(totalVolume-sampleVolume-masterMixVolume)>0Microliter&&MatchQ[masterMixDiluent,Null];

							(* Gather all resolved options and errors to return *)
							{
								masterMixVolume,
								masterMixDilutionFactor,
								masterMixDiluent,
								masterMixNullError,
								masterMixDilutionFactorNullError,
								masterMixVolumeNullError,
								masterMixVolumeDilutionFactorMismatchWarning,
								masterMixTotalVolumeError,
								masterMixDiluentNullError,
								(* other branch's options as Null *)
								Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null,
								Lookup[myMapThreadOptions,Ampholytes]/.Automatic:>Null,
								Lookup[myMapThreadOptions,AmpholyteTargetConcentrations]/.Automatic:>Null,
								Lookup[myMapThreadOptions,AmpholyteVolume]/.Automatic:>Null,
								Lookup[myMapThreadOptions,IsoelectricPointMarkers]/.Automatic:>Null,
								Lookup[myMapThreadOptions,IsoelectricPointMarkersTargetConcentrations]/.Automatic:>Null,
								Lookup[myMapThreadOptions,IsoelectricPointMarkersVolume]/.Automatic:>Null,
								Lookup[myMapThreadOptions,AmpholytesStorageCondition]/.Automatic:>Null,
								Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]/.Automatic:>Null,
								Lookup[myMapThreadOptions,ElectroosmoticFlowBlocker]/.Automatic:>Null,
								Lookup[myMapThreadOptions,ElectroosmoticFlowBlockerTargetConcentrations]/.Automatic:>Null,
								Lookup[myMapThreadOptions,ElectroosmoticFlowBlockerVolume]/.Automatic:>Null,
								Lookup[myMapThreadOptions,Denature]/.Automatic:>Null,
								Lookup[myMapThreadOptions,DenaturationReagent]/.Automatic:>Null,
								Lookup[myMapThreadOptions,DenaturationReagentTargetConcentration]/.Automatic:>Null,
								Lookup[myMapThreadOptions,DenaturationReagentVolume]/.Automatic:>Null,
								Lookup[myMapThreadOptions,IncludeAnodicSpacer]/.Automatic:>Null,
								Lookup[myMapThreadOptions,AnodicSpacer]/.Automatic:>Null,
								Lookup[myMapThreadOptions,AnodicSpacerTargetConcentration]/.Automatic:>Null,
								Lookup[myMapThreadOptions,AnodicSpacerVolume]/.Automatic:>Null,
								Lookup[myMapThreadOptions,IncludeCathodicSpacer]/.Automatic:>Null,
								Lookup[myMapThreadOptions,CathodicSpacer]/.Automatic:>Null,
								Lookup[myMapThreadOptions,CathodicSpacerTargetConcentration]/.Automatic:>Null,
								Lookup[myMapThreadOptions,CathodicSpacerVolume]/.Automatic:>Null,
								(* Other branch's errors as False *)
								False,(* nullDiluentQ *)
								False, (* NoSpecifiedAmpholytesQ *)
								False, (* ampholyteMatchedlengthsNotCopaceticQ *)
								False, (* ampholyteVolumeNullQ *)
								False, (* ampholyteConcentrationNullQ *)
								False, (* ampholyteVolumeConcentrationMismatchQ *)
								False, (* NoSpecifiedIsoelectricPointMarkersQ *)
								False, (* resolverCantFixIsoelectricPointMarkersMismatchQ *)
								False, (* isoelectricPointMarkersVolumeNullQ *)
								False, (* isoelectricPointMarkersConcentrationNullQ *)
								False, (* isoelectricPointMarkersVolumeConcentrationMismatchQ *)
								False, (* electroosmoticFlowBlockerNullQ *)
								False, (* noElectroosmoticFlowBlockerAgentIdentifiedQ *)
								False, (* electroosmoticFlowBlockerVolumeNullQ *)
								False, (* electroosmoticFlowBlockerConcentrationNullQ *)
								False, (* eofBlockerVolumeConcentrationMismatchQ *)
								False, (* denatureFalseOptionsSpecifiedQ *)
								False, (* denaturationReagentNullQ *)
								False, (* noDenaturationReagentIdentifiedQ *)
								False, (* resolveableDenatureReagentConcentrationUnitMismatchQ *)
								False, (* unresolveableDenatureReagentConcentrationUnitMismatchQ *)
								False, (* denaturationReagentVolumeNullQ *)
								False, (* denaturationReagentConcentrationNullQ *)
								False, (* denaturationReagentConcentrationVolumeMismatch *)
								False, (* anodicSpacerFalseOptionsSpecifiedQ *)
								False, (* anodicSpacerNullQ *)
								False, (* noAnodicSpacerIdentifiedQ *)
								False, (* anodicSpacerVolumeNullQ *)
								False, (* anodicSpacerConcentrationNullQ *)
								False, (* anodicSpacerConcentrationVolumeMismatch *)
								False, (* cathodicSpacerFalseOptionsSpecifiedQ *)
								False, (* cathodicSpacerNullQ *)
								False, (* noCathodicSpacerIdentifiedQ *)
								False, (* cathodicSpacerVolumeNullQ *)
								False, (* cathodicSpacerConcentrationNullQ *)
								False, (* cathodicSpacerConcentrationVolumeMismatch *)
								False (* sumOfVolumesOverTotalvolumeQ *)
							}
						],
						(* no PremadeMasterMix, make your own mastermix *)
						Module[
							{
								resolveDiluent,resolveAmpholytes,resolveAmpholyteTargetConcentrations,resolveAmpholyteVolume,resolveIsoelectricPointMarkers,
								resolveIsoelectricPointMarkersTargetConcentrations,resolveIsoelectricPointMarkersVolume,resolveElectroosmoticFlowBlocker,
								resolveElectroosmoticFlowBlockerTargetConcentration,resolveElectroosmoticFlowBlockerVolume,resolveDenature,
								resolveDenaturationReagent,resolveDenaturationReagentTargetConcentration,resolveDenaturationReagentVolume,
								resolveIncludeAnodicSpacer,resolveAnodicSpacer,resolveAnodicSpacerTargetConcentration,resolveAnodicSpacerVolume,
								resolveIncludeCathodicSpacer,resolveCathodicSpacer,resolveCathodicSpacerTargetConcentration,resolveCathodicSpacerVolume,
								NoSpecifiedAmpholytesQ, volumeLeft, nullDiluentQ,sumOfVolumesOverTotalvolumeQ,ampholyteVolumeNullQ,ampholyteConcentrationNullQ,
								ampholyteMatchedlengthsNotCopaceticQ,ampholyteVolumeConcentrationMismatchQ,NoSpecifiedIsoelectricPointMarkersQ,
								resolverCantFixIsoelectricPointMarkersMismatchQ,isoelectricPointMarkersVolumeNullQ,isoelectricPointMarkersConcentrationNullQ,
								isoelectricPointMarkersVolumeConcentrationMismatchQ,pIMarkerVolume,pIMarkerConcentration,
								electroosmoticFlowBlockerNullQ,electroosmoticFlowBlockerAgentIdentity,noElectroosmoticFlowBlockerAgentIdentifiedQ,
								electroosmoticFlowBlockerReagentConcentration,eofBlockerVolume,eofBlockerConcentration,
								eofBlockerVolumeConcentrationMismatchQ,electroosmoticFlowBlockerVolumeNullQ,
								electroosmoticFlowBlockerConcentrationNullQ,denatureOptions,includeDenatureBool,denatureFalseOptionsSpecifiedQ,
								denaturationReagentNullQ,denaturationReagentAgentIdentity,noDenaturationReagentIdentifiedQ,
								denaturationReagentConcentration,targetConcentrationByDenaturationReagent,
								denatureVolume,denatureConcentration,denaturationReagentVolumeNullQ,
								denaturationReagentConcentrationNullQ,denatureReagentConcentrationUnitMismatch,
								resolveableDenatureReagentConcentrationUnitMismatchQ,unresolveableDenatureReagentConcentrationUnitMismatchQ,
								denaturationReagentConcentrationVolumeMismatch,anodicSpacerOptions,includeAnodicSpacerBool,
								anodicSpacerNullQ,anodicSpacerFalseOptionsSpecifiedQ,anodicSpacerIdentity,noAnodicSpacerIdentifiedQ,
								anodicSpacerConcentration,targetConcentrationByAnodicSpacer,anodicVolume,anodicConcentration,
								anodicSpacerVolumeNullQ,anodicSpacerConcentrationNullQ,anodicSpacerConcentrationVolumeMismatch,
								cathodicSpacerOptions,includeCathodicSpacerBool,cathodicSpacerFalseOptionsSpecifiedQ,cathodicSpacerNullQ,
								cathodicSpacerIdentity,noCathodicSpacerIdentifiedQ,cathodicSpacerConcentration,
								targetConcentrationByCathodicSpacer,cathodicVolume,cathodicConcentration,cathodicSpacerVolumeNullQ,
								cathodicSpacerConcentrationNullQ,cathodicSpacerConcentrationVolumeMismatch,lengthToMatch,
								pIMarkersLengthToMatch,resolveAmpholyteStorageCondition, resolveIsoelectricPointMarkersStorageCondition,
								pIMarkerIdentity,nopIMarkerIdentifiedQ,pIMarkerReagentConcentration,pIMarkerCompatibleUnit
							},

							(* resolve ampholytes *)
							resolveAmpholytes=If[
								MatchQ[ToList[Lookup[myMapThreadOptions,Ampholytes]],Except[{Automatic..}]],
								ToList[Lookup[myMapThreadOptions,Ampholytes]],
								{Model[Sample,"Pharmalyte pH 3-10"]}
							];

							NoSpecifiedAmpholytesQ =Or@@(NullQ[#]& /@ resolveAmpholytes);

							(* resolve ampholyte volume and concentration *)
							(* to make sure teh length of items is the same, given a situation where volume or concentration, or both are Automatic and ampholytes or any other is not *)
							lengthToMatch = Length[resolveAmpholytes];

							(* check that lengths are copacetic *)
							ampholyteMatchedlengthsNotCopaceticQ =
								Or@@((Length[#] != lengthToMatch)& /@ {Lookup[myMapThreadOptions,AmpholyteVolume]/. {{Automatic} :> ConstantArray[Automatic, lengthToMatch]},
									Lookup[myMapThreadOptions,AmpholyteTargetConcentrations]/. {{Automatic} :> ConstantArray[Automatic, lengthToMatch]}});

							{
								resolveAmpholyteVolume,
								resolveAmpholyteTargetConcentrations,
								ampholyteVolumeNullQ,
								ampholyteConcentrationNullQ
							} = If[Not[ampholyteMatchedlengthsNotCopaceticQ],
								Transpose@MapThread[
								Function[{volume, concentration},
									Switch[volume,
										(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
										Null,
										{Null, concentration /. Automatic :>(4VolumePercent/lengthToMatch), True, False},
										VolumeP,
										{volume, concentration /. Automatic :> 100VolumePercent*volume/totalVolume, False, False},
										(* if volume is automatic, check the target concentration and calculate *)
										Automatic,
										Switch[concentration,
											(* if concentration is null, volume is also null *)
											Null,
											{Null, Null, False, True},
											VolumePercentP,
											(* if concentration is specified, calculate the volume we need for this Ampholyte and round it *)
											{RoundOptionPrecision[totalVolume*concentration/(100VolumePercent), 10^-1 Microliter], concentration, False, False},
											Automatic,
											(* if both the concentration and the volume are Automatic, default concentration to 4 VolumePercent and calculate accordingly *)
											{RoundOptionPrecision[totalVolume*(concentration/. Automatic :> (4VolumePercent/lengthToMatch))/(100VolumePercent), 10^-1 Microliter], concentration/. Automatic :> (4VolumePercent/lengthToMatch), False, False}
										]
									]
								],
								(* in a case where multiple automatics were specified for ALL of ampholytes, volumes, and concentrations,make sure they match in length to that of resolvedAmpholytes  *)
								{Lookup[myMapThreadOptions,AmpholyteVolume]/. {{Automatic..} :> ConstantArray[Automatic, lengthToMatch]},
									Lookup[myMapThreadOptions,AmpholyteTargetConcentrations]/. {{Automatic..} :> ConstantArray[Automatic, lengthToMatch]}}
								],
								{
									Lookup[myMapThreadOptions,AmpholyteVolume]/. Automatic|{Automatic..}:>Null,
									Lookup[myMapThreadOptions,AmpholyteTargetConcentrations]/. Automatic|{Automatic..} :> Null,
									NullQ[Lookup[myMapThreadOptions,AmpholyteVolume]],
									NullQ[Lookup[myMapThreadOptions,AmpholyteTargetConcentrations]]
								}
							];

							(* If volume and concentration are not in agreement, raise an error*)
							ampholyteVolumeConcentrationMismatchQ=If[Not[ampholyteMatchedlengthsNotCopaceticQ],
								MapThread[
									Function[{volume, concentration},
										If[!NullQ[volume]&& !NullQ[concentration],
											Abs[volume - N[concentration*totalVolume/(100VolumePercent)]]>0.1Microliter,
											False
										]],
									{resolveAmpholyteVolume,resolveAmpholyteTargetConcentrations}
								],
								False
							];

							resolveAmpholyteStorageCondition = Which[
								Length[ToList[Lookup[myMapThreadOptions,AmpholytesStorageCondition]]]>lengthToMatch,
								(* in the rare case where more conditions are given than storage conditions, might be the result of expansion, so grab the first and populate for all - its a crappy solution, but works *)
								Lookup[myMapThreadOptions,AmpholytesStorageCondition]/.{Automatic|{Automatic..} :> ConstantArray[Null, lengthToMatch],storage:SampleStorageTypeP|{SampleStorageTypeP..}:>  ConstantArray[First[storage], lengthToMatch]},
								Length[ToList[Lookup[myMapThreadOptions,AmpholytesStorageCondition]]]==1,
								Lookup[myMapThreadOptions,AmpholytesStorageCondition]/.{Automatic|{Automatic..} :> ConstantArray[Null, lengthToMatch],storage:SampleStorageTypeP|{SampleStorageTypeP}:>  ConstantArray[First[ToList[storage]], lengthToMatch]},
								Length[ToList[Lookup[myMapThreadOptions,AmpholytesStorageCondition]]]>1,
								Lookup[myMapThreadOptions,AmpholytesStorageCondition]/.{Automatic|{Automatic..} :> ConstantArray[Null, lengthToMatch]}
							];

							(* resolve isoelectricPointMarkers *)
							resolveIsoelectricPointMarkers=If[
								(MatchQ[ToList[Lookup[myMapThreadOptions,IsoelectricPointMarkers]],Except[{Automatic..}]]),
								ToList[Lookup[myMapThreadOptions,IsoelectricPointMarkers]],
								{Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 4.05" ], Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 9.99" ]}
							];

							NoSpecifiedIsoelectricPointMarkersQ =Or@@(NullQ[#]& /@ resolveIsoelectricPointMarkers);

							(* for brevity, get these into a variable of their own *)
							{pIMarkerVolume,pIMarkerConcentration} = Lookup[myMapThreadOptions,{IsoelectricPointMarkersVolume,IsoelectricPointMarkersTargetConcentrations}];

							(* check lengths of matched options *)
							pIMarkersLengthToMatch = Length[resolveIsoelectricPointMarkers];

							resolverCantFixIsoelectricPointMarkersMismatchQ =
								Or@@((Length[#] != pIMarkersLengthToMatch)& /@ {pIMarkerVolume/. {{Automatic} :> ConstantArray[Automatic, pIMarkersLengthToMatch]},
									pIMarkerConcentration/. {{Automatic} :> ConstantArray[Automatic, pIMarkersLengthToMatch]}});

							(* get the concentration of the reagent, has to be a volume percent *)
							(* to resolve resolveIsoelectricPointMarkersVolume below, need to know which agent is used *)
							pIMarkerIdentity=If[!NoSpecifiedIsoelectricPointMarkersQ,
								Flatten[Map[Function[piMarker,
									Module[
										{pIMarkerPacket,pIMarkerComposition,pIMarkerCompositionIDs,
											pIMarkerCompositionPackets,identifypIMarker,markerPeptide},
										pIMarkerPacket=fetchPacketFromCache[Download[piMarker,Object],optionObjectModelPackets];
										pIMarkerComposition=Lookup[pIMarkerPacket,Composition];
										(* construct list with concentration and molecule composition *)
										pIMarkerCompositionPackets=Map[
											Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
											pIMarkerComposition];
										(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
										pIMarkerCompositionIDs=If[!MatchQ[#, {NullP..}],{Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]}, {Null, Null, Null}] &/@pIMarkerCompositionPackets;

										(* Identifiers for pI Markers (from proteinSimple) based on synonyms *)
										{
											markerPeptide
										}={
											{
												"ProteinSimple Maurice cIEF pI Marker - 10.17",
												"ProteinSimple Maurice cIEF pI Marker - 9.99",
												"ProteinSimple Maurice cIEF pI Marker - 9.50",
												"ProteinSimple Maurice cIEF pI Marker - 8.40",
												"ProteinSimple Maurice cIEF pI Marker - 7.05",
												"ProteinSimple Maurice cIEF pI Marker - 6.14",
												"ProteinSimple Maurice cIEF pI Marker - 5.85",
												"ProteinSimple Maurice cIEF pI Marker - 4.05",
												"ProteinSimple Maurice cIEF pI Marker - 3.38"
											}
										};
										(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
										(* Note - this assumes a single pIMarker agent in the sample; if more, user will need to specify volume *)

										identifypIMarker=Map[
											Function[compositionMolecule,
												{
													compositionMolecule[[1]] (* ObjectID *),
													compositionMolecule[[2]] (* Concentration *),
													Which[
														ContainsAny[compositionMolecule[[3]],markerPeptide],"pIMarker"
													]
												}
											],
											pIMarkerCompositionIDs];

										(* pick out cases where the second index in teh list is not null *)
										Cases[identifypIMarker,{ObjectP[],_,Except[NullP]}]
									]],
									resolveIsoelectricPointMarkers
								],1],
								{}];

							(* check that we know what the reagent is and what its concentration in the reagent *)
							nopIMarkerIdentifiedQ = If[!NoSpecifiedIsoelectricPointMarkersQ,
								Length[pIMarkerIdentity]=!=Length[resolveIsoelectricPointMarkers],
								False];

							(* are we dealing with volume percent? *)
							pIMarkerCompatibleUnit = Map[MatchQ[QuantityUnit[#],IndependentUnit["VolumePercent"]]&,pIMarkerIdentity[[All,2]]];

							(* if the concentraiton is anything but volume percent, assume it is 100VolumePercent *)
							pIMarkerReagentConcentration = If[!nopIMarkerIdentifiedQ&&!NoSpecifiedIsoelectricPointMarkersQ,
								If[And@@pIMarkerCompatibleUnit,
									pIMarkerIdentity[[All,2]],
									MapThread[If[#1, #2, 100VolumePercent]&, {pIMarkerCompatibleUnit, pIMarkerIdentity[[All,2]]}]
								],
								ConstantArray[100VolumePercent,Length[resolveIsoelectricPointMarkers]]
							];

								(* resolve isoelectricPointMarkers volume and concentration *)
							(* at this point, we know that the lengths are all the same (we expanded them based on that notion, so we can mapthread to resolve each one seperately *)
							{
								resolveIsoelectricPointMarkersVolume,
								resolveIsoelectricPointMarkersTargetConcentrations,
								isoelectricPointMarkersVolumeNullQ,
								isoelectricPointMarkersConcentrationNullQ
							} = If[
								!resolverCantFixIsoelectricPointMarkersMismatchQ,
								(* no problems moving forward, might need to account for differences in length *)
									Transpose@MapThread[
										Function[{volume, concentration, reagentConcentration},
											Switch[volume,
												(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
												Null,
												{Null, concentration /. Automatic :>1VolumePercent, True, False},
												VolumeP,
												{volume, concentration /. Automatic :> reagentConcentration*volume/totalVolume, False, False},
												(* if volume is automatic, check the target concentration and calculate *)
												Automatic,
												Switch[concentration,
													(* if concentration is null, volume is also null *)
													Null,
													{Null, Null, False, True},
													VolumePercentP,
													(* if concentration is specified, calculate the volume we need for this IsoelectricPointMarkers and round it *)
													{RoundOptionPrecision[totalVolume*concentration/reagentConcentration, 10^-1 Microliter], concentration, False, False},
													Automatic,
													(* if both the concentration and the volume are Automatic, default concentration to 1 VolumePercent and calculate accordingly *)
													{RoundOptionPrecision[totalVolume*(concentration/. Automatic :> 1VolumePercent)/reagentConcentration, 10^-1 Microliter], concentration/. Automatic :> 1VolumePercent, False, False}
												]
											]
										],
										(* This has to match the length of resolved but we know its resolveable so, consider several cases to MapThread on*)
										{
											ToList[pIMarkerVolume]/. {{Automatic} :> ConstantArray[Automatic, pIMarkersLengthToMatch]},
											ToList[pIMarkerConcentration]/. {{Automatic} :> ConstantArray[Automatic, pIMarkersLengthToMatch]},
											ToList[pIMarkerReagentConcentration]
										}
									],
								{
									pIMarkerVolume/. Automatic|{Automatic..}:>Null,
									pIMarkerConcentration/. Automatic|{Automatic..} :> Null,
									NullQ[pIMarkerVolume],
									NullQ[pIMarkerConcentration]
								}
							];

							(* If volume and concentration are not in agreement, raise an error*)
							isoelectricPointMarkersVolumeConcentrationMismatchQ=If[!resolverCantFixIsoelectricPointMarkersMismatchQ,
								MapThread[Function[{volume, concentration, reagentConcentation},
									If[!NullQ[volume]&& !NullQ[concentration],
										Abs[volume - N[concentration*totalVolume/reagentConcentation]]>0.1Microliter,
										False
									]],
									{resolveIsoelectricPointMarkersVolume,resolveIsoelectricPointMarkersTargetConcentrations,pIMarkerReagentConcentration}
								],
								False
							];

							resolveIsoelectricPointMarkersStorageCondition = Which[
								Length[ToList[Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]]]>pIMarkersLengthToMatch,
								(* in the rare case where more conditions are given than storage conditions, might be the result of expansion, so grab the first and populate for all - its a crappy solution, but works *)
								Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]/.{Automatic|{Automatic..} :> ConstantArray[Null, pIMarkersLengthToMatch],storage:SampleStorageTypeP|{SampleStorageTypeP..}:> Sequence@@ConstantArray[First[storage], pIMarkersLengthToMatch]},
								Length[ToList[Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]]]==1,
								Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]/.{Automatic|{Automatic..} :> ConstantArray[Null, pIMarkersLengthToMatch],storage:SampleStorageTypeP|{SampleStorageTypeP}:> ConstantArray[First[ToList[storage]], pIMarkersLengthToMatch]},
								Length[ToList[Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]]]>1,
								Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]/.{Automatic|{Automatic..} :> ConstantArray[Null, pIMarkersLengthToMatch]}
							];


							(* resolve electroosmoticFlowBlocker *)
							resolveElectroosmoticFlowBlocker=If[
								MatchQ[Lookup[myMapThreadOptions,ElectroosmoticFlowBlocker],Except[Automatic]],
								Lookup[myMapThreadOptions,ElectroosmoticFlowBlocker],
								Model[Sample,"1% Methyl Cellulose"]
							];

							electroosmoticFlowBlockerNullQ = NullQ[resolveElectroosmoticFlowBlocker];

							(* get the concentration of the reagent, has to be a mass volume precentage or gram/liter. Methyl Cellulose is too variable for mw *)
							(* to resolve mixElectroosmoticFlowBlockerAgentTargetConcentration below, need to know which agent is used *)
							electroosmoticFlowBlockerAgentIdentity=If[!electroosmoticFlowBlockerNullQ,
								Module[
									{electroosmoticFlowBlockerAgentPacket,electroosmoticFlowBlockerAgentComposition,electroosmoticFlowBlockerAgentCompositionIDs,
										electroosmoticFlowBlockerAgentCompositionPackets,identifyElectroosmoticFlowBlockerAgent,methylCellulose},
									electroosmoticFlowBlockerAgentPacket=fetchPacketFromCache[Download[resolveElectroosmoticFlowBlocker,Object],optionObjectModelPackets];
									electroosmoticFlowBlockerAgentComposition=Lookup[electroosmoticFlowBlockerAgentPacket,Composition];
									(* construct list with concentration and molecule composition *)
									electroosmoticFlowBlockerAgentCompositionPackets=Map[
										Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
										electroosmoticFlowBlockerAgentComposition];
									(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
									electroosmoticFlowBlockerAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@electroosmoticFlowBlockerAgentCompositionPackets;

									(* Identifiers for methyl cellulose based on CAS, synonyms, and InChI *)
									{
										methylCellulose
									}={
										{"9004-67-5","MC","Methyl Cellulose", "MethylCellulose","Methylcellulose","methylcellulose","Methyl cellulose","methyl cellulose" }
									};
									(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
									(* Note - this assumes a single electroosmoticFlowBlocker agent in the sample; if more, user will need to specify volume *)

									identifyElectroosmoticFlowBlockerAgent=Map[
										Function[compositionMolecule,
											{
												compositionMolecule[[1]] (* ObjectID *),
												compositionMolecule[[2]] (* Concentration *),
												Which[
													ContainsAny[compositionMolecule[[3]],methylCellulose],"MC"
												]
											}
										],
										electroosmoticFlowBlockerAgentCompositionIDs];

									(* pick out cases where the second index in teh list is not null *)
									Cases[identifyElectroosmoticFlowBlockerAgent,{ObjectP[],_,Except[NullP]}]
								],
								{}];

							(* check that we know what the reagent is and what its concentration in the stock solution is *)
							noElectroosmoticFlowBlockerAgentIdentifiedQ = If[!electroosmoticFlowBlockerNullQ,
								Length[electroosmoticFlowBlockerAgentIdentity]=!=1,
								False];

							electroosmoticFlowBlockerReagentConcentration = If[!noElectroosmoticFlowBlockerAgentIdentifiedQ&&!electroosmoticFlowBlockerNullQ,
								electroosmoticFlowBlockerAgentIdentity[[1]][[2]],
								1MassPercent];

							(* )fetch volume and concentration to make it easier below *)
							{eofBlockerVolume,eofBlockerConcentration} = Lookup[myMapThreadOptions,{ElectroosmoticFlowBlockerVolume,ElectroosmoticFlowBlockerTargetConcentrations}];

							(* resolve EOFBlocker volume and concentration *)
							{
								resolveElectroosmoticFlowBlockerVolume,
								resolveElectroosmoticFlowBlockerTargetConcentration,
								electroosmoticFlowBlockerVolumeNullQ,
								electroosmoticFlowBlockerConcentrationNullQ
							}=If[!electroosmoticFlowBlockerNullQ,
									Switch[eofBlockerVolume,
										(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
										Null,
										{Null, eofBlockerConcentration /. Automatic :>0.35MassPercent, True, False},
										VolumeP,
										{eofBlockerVolume, eofBlockerConcentration /. Automatic :> N[(eofBlockerVolume*electroosmoticFlowBlockerReagentConcentration)/totalVolume], False, False},
										(* if volume is automatic, check the target concentration and calculate *)
										Automatic,
										Switch[eofBlockerConcentration,
											(* if concentration is null, volume is also null *)
											Null,
											{Null, Null, False, True},
											MassPercentP,
											(* if concentration is specified, calculate the volume we need for this Ampholyte and round it *)
											{RoundOptionPrecision[totalVolume*eofBlockerConcentration/electroosmoticFlowBlockerReagentConcentration, 10^-1 Microliter], eofBlockerConcentration, False, False},
											Automatic,
											(* if both the concentration and the volume are Automatic, default concentration to 0.35 MassPercent and calculate accordingly *)
											{RoundOptionPrecision[totalVolume*(eofBlockerConcentration/. Automatic :> 0.35MassPercent)/electroosmoticFlowBlockerReagentConcentration, 10^-1 Microliter], eofBlockerConcentration/. Automatic :> 0.35MassPercent, False, False}
										]
									],
									{
										eofBlockerVolume/.Automatic:>Null,
										eofBlockerConcentration/.Automatic:>Null,
										NullQ[eofBlockerVolume],
										NullQ[eofBlockerConcentration]
									}
								];

							(* check if there's a mismatch between the volume and concenration, if there is, raise an error *)
							eofBlockerVolumeConcentrationMismatchQ=	If[!NullQ[resolveElectroosmoticFlowBlockerVolume]&& !NullQ[resolveElectroosmoticFlowBlockerTargetConcentration] &&!electroosmoticFlowBlockerNullQ,
								Abs[resolveElectroosmoticFlowBlockerVolume - resolveElectroosmoticFlowBlockerTargetConcentration*totalVolume / electroosmoticFlowBlockerReagentConcentration]>0.1Microliter,
								False
							];

							(* resolve denaturation *)
							(* list options to check if they're specified to trigger the Denature boolean to set as True *)
							denatureOptions=
								{
									Denature,DenaturationReagent,DenaturationReagentTargetConcentration,DenaturationReagentVolume
								};

							includeDenatureBool=Map[
								MatchQ[#,Except[Automatic|Null|False]]&,
								Lookup[myMapThreadOptions,denatureOptions]
							];

							(* if the boolean is True, set Denature as true *)
							resolveDenature = Which[
								MatchQ[Lookup[myMapThreadOptions,Denature],BooleanP],Lookup[myMapThreadOptions,Denature],
								NullQ[Lookup[myMapThreadOptions,Denature]], False,
								Or@@includeDenatureBool,True,
								True,False
							];

							(* check if denature resolves to True, but relevant options have been specified *)
							denatureFalseOptionsSpecifiedQ = Not[resolveDenature]&&Or@@includeDenatureBool;

							resolveDenaturationReagent =
           						If[resolveDenature,
									If[MatchQ[Lookup[myMapThreadOptions,DenaturationReagent],Except[Automatic]],
										Lookup[myMapThreadOptions,DenaturationReagent],
										Model[Sample,StockSolution,"10M Urea"]
									],
									Lookup[myMapThreadOptions,DenaturationReagent] /. Automatic :> Null
							];

							denaturationReagentNullQ = If[resolveDenature,
								NullQ[resolveDenaturationReagent],
								False
							];

							(* identify denaturation agent in the specified object *)
							denaturationReagentAgentIdentity=If[resolveDenature&&!denaturationReagentNullQ,
								Module[
									{denaturationReagentAgentPacket,denaturationReagentAgentComposition,denaturationReagentAgentCompositionIDs,
										denaturationReagentAgentCompositionPackets,identifyDenaturationAgent,simpleSol,urea},
									denaturationReagentAgentPacket=fetchPacketFromCache[Download[resolveDenaturationReagent,Object],optionObjectModelPackets];
									denaturationReagentAgentComposition=Lookup[denaturationReagentAgentPacket,Composition];
									(* construct list with concentration and molecule composition *)
									denaturationReagentAgentCompositionPackets=Map[
										Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
										denaturationReagentAgentComposition];
									(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
									denaturationReagentAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@denaturationReagentAgentCompositionPackets;

									(* Identifiers for simpleSol and Urea based on CAS, synonyms, and InChI *)
									{
										simpleSol,
										urea
									}={
										{"SimpleSol Protein Solubilizer", "SimpleSol", "Simple Sol", "simplesol", "ProteinSimple SimpleSol Protein Solubilizer"},
										{"57-13-6", "Urea", "urea", "Carbamide", "Carbonyldiamide", "InChI=1S/CH4N2O/c2-1(3)4/h(H4,2,3,4)", " XSQUKJJJFZCRTK-UHFFFAOYSA-N"}
									};
									(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
									(* Note - this assumes a single denaturationReagent agent in the sample; if more, user will need to specify volume *)

									identifyDenaturationAgent=Map[
										Function[compositionMolecule,
											{
												compositionMolecule[[1]] (* ObjectID *),
												compositionMolecule[[2]] (* Concentration *),
												Which[
													ContainsAny[compositionMolecule[[3]],simpleSol],"SimpleSol",
													ContainsAny[compositionMolecule[[3]],urea],"Urea"
												]
											}
										],
										denaturationReagentAgentCompositionIDs];

									(* pick out cases where the second index in teh list is not null *)
									Cases[identifyDenaturationAgent,{ObjectP[],_,Except[NullP]}]
								],
								{}
							];

							(* check that we      know what the reagent is and what its concentration in the stock solution is *)
							noDenaturationReagentIdentifiedQ = If[resolveDenature&&!denaturationReagentNullQ,
								Length[denaturationReagentAgentIdentity]=!=1,
								False
							];

							(* grab the concentration of the identified denaturation reagent *)
							denaturationReagentConcentration = If[resolveDenature&&!denaturationReagentNullQ&&!noDenaturationReagentIdentifiedQ,
								denaturationReagentAgentIdentity[[1]][[2]],
								10Molar
							];

							(* grab suggested concentration by denaturation reagent *)
							targetConcentrationByDenaturationReagent =If[resolveDenature&&!denaturationReagentNullQ&&!noDenaturationReagentIdentifiedQ,
								Switch[denaturationReagentAgentIdentity[[1]][[3]],
									"SimpleSol", 20VolumePercent,
									"Urea", 4Molar
								],
								4Molar
							];

							(* Grab denaturationReagent volume and concentration from options for brevity below *)
							{denatureVolume,denatureConcentration} = Lookup[myMapThreadOptions,{DenaturationReagentVolume,DenaturationReagentTargetConcentration}];

							(* check that the unit specified for DenaturationReagentTargetConcentration is appropriate for the reagent (can't do molar for simpleSol, but can do volume percent for urea, assuming the stock is 100% *)
							(* if cant convert between the units, we raise an error *)
							(* Null is replaced with targetConcentrationByDenaturationReagent just to make sure it does not fail here*)
							denatureReagentConcentrationUnitMismatch = MatchQ[Quiet[UnitConvert[QuantityUnit[denatureConcentration/. {Null:> targetConcentrationByDenaturationReagent , Automatic:> targetConcentrationByDenaturationReagent}],QuantityUnit[targetConcentrationByDenaturationReagent]]],$Failed];

							(* now figure out if we can go on despite mismatch *)
							{
								resolveableDenatureReagentConcentrationUnitMismatchQ,
								unresolveableDenatureReagentConcentrationUnitMismatchQ
							} = Which[
								(* VolumePercent is specified but reagent is Urea, can still continue, just raise warning *)
								denatureReagentConcentrationUnitMismatch && MatchQ[targetConcentrationByDenaturationReagent, ConcentrationP],
									{True, False},
								(* Molar is specified but reagent is SimpleSol (no Molar Concentration), cant continue, raise error *)
								denatureReagentConcentrationUnitMismatch && MatchQ[targetConcentrationByDenaturationReagent, VolumePercentP],
									{False, True},
								(* otherwise we're happy and can continue *)
								!denatureReagentConcentrationUnitMismatch,
									{False, False},
								True,
									{False, False}
								];

								(* now we can resolve volume and concentration according to the reagent we're using *)
							{
								resolveDenaturationReagentVolume,
								resolveDenaturationReagentTargetConcentration,
								denaturationReagentVolumeNullQ,
								denaturationReagentConcentrationNullQ
							}=If[resolveDenature&&!denaturationReagentNullQ,
           						Switch[denatureVolume,
									(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
									Null,
									{Null, denatureConcentration /. Automatic :>targetConcentrationByDenaturationReagent, True, False},
									VolumeP,
									{denatureVolume, denatureConcentration /. Automatic :> (denatureVolume*denaturationReagentConcentration)/totalVolume, False, False},
									(* if volume is automatic, check the target concentration and calculate *)
									Automatic,
									Switch[denatureConcentration,
										(* if concentration is null, volume is also null *)
										Null,
											{Null, Null, False, True},
										(* volume percent input - assuming the reagent is SimpleSol and 100% *)
										VolumePercentP,
										(* if concentration is specified, calculate the volume we need for this reagent and round it *)
											If[resolveableDenatureReagentConcentrationUnitMismatchQ,
												(* if theres a mismatch in units, assume the reagent concentration is 100% *)
												{RoundOptionPrecision[totalVolume*denatureConcentration/(100VolumePercent), 10^-1 Microliter], denatureConcentration, False, False},
												(* otherwise, continue as you would *)
												{RoundOptionPrecision[totalVolume*denatureConcentration/denaturationReagentConcentration, 10^-1 Microliter], denatureConcentration, False, False}
											],
										(* concentration input by molar concentration of input, will need to check if it's  *)
										ConcentrationP,
										(* if concentration is specified, calculate the volume we need for this reagent and round it *)
											If[Not[unresolveableDenatureReagentConcentrationUnitMismatchQ],
												(* if units match, go on..  *)
												{RoundOptionPrecision[totalVolume*denatureConcentration/denaturationReagentConcentration, 10^-1 Microliter], denatureConcentration, False, False},
												(* if an unresolveable mismatch was found, return null for volume but no errors *)
												{Null, denatureConcentration, False, False }
											],
										Automatic,
										(* if both the concentration and the volume are Automatic, default concentration to targetConcentrationByDenaturationReagent and calculate accordingly *)
											{RoundOptionPrecision[totalVolume*(denatureConcentration/. Automatic :> targetConcentrationByDenaturationReagent)/denaturationReagentConcentration, 10^-1 Microliter], denatureConcentration/. Automatic :> targetConcentrationByDenaturationReagent, False, False}
									]
								],
								{denatureVolume/. Automatic:> Null, denatureConcentration/. Automatic:> Null, False, False}
							];

							(* check that the volume and concentration are in agreement*)
							denaturationReagentConcentrationVolumeMismatch = If[resolveDenature&&!NullQ[resolveDenaturationReagentVolume]&& !NullQ[resolveDenaturationReagentTargetConcentration]&&!denaturationReagentNullQ,
								Which[
									(* units are in agreement - just check that volume and concentration match *)
									!unresolveableDenatureReagentConcentrationUnitMismatchQ && !resolveableDenatureReagentConcentrationUnitMismatchQ,
									Abs[resolveDenaturationReagentVolume - (resolveDenaturationReagentTargetConcentration*totalVolume / denaturationReagentConcentration)]>1Microliter,
									(* if specified VolumePercent for reagent with molar concentration units *)
									resolveableDenatureReagentConcentrationUnitMismatchQ,
									Abs[resolveDenaturationReagentVolume - (resolveDenaturationReagentTargetConcentration*totalVolume / (100VolumePercent))]>1Microliter,
									(* if specified molar units for reagent with volumepercent units, an earlier error is thrown, don't seath it *)
									unresolveableDenatureReagentConcentrationUnitMismatchQ,
									False
								],
								False
							];

							(* Resolve AnodicSpacer *)
							anodicSpacerOptions=
								{
									IncludeAnodicSpacer,AnodicSpacer,AnodicSpacerTargetConcentration,AnodicSpacerVolume
								};

							includeAnodicSpacerBool=Map[
								MatchQ[#,Except[Automatic|Null|False]]&,
								Lookup[myMapThreadOptions,anodicSpacerOptions]
							];

							(* if the boolean is True, set IncludeAnodicSpacer as true *)
							resolveIncludeAnodicSpacer = Which[
								MatchQ[Lookup[myMapThreadOptions,IncludeAnodicSpacer],BooleanP],Lookup[myMapThreadOptions,IncludeAnodicSpacer],
								NullQ[Lookup[myMapThreadOptions,IncludeAnodicSpacer]], False,
								Or@@includeAnodicSpacerBool,True,
								True,False
							];

							(* check if IncludeAnodicSpacer is False, but relevant options have been specified *)
							anodicSpacerFalseOptionsSpecifiedQ = Not[resolveIncludeAnodicSpacer]&&Or@@includeAnodicSpacerBool;

							(* Resolve spacer *)
							resolveAnodicSpacer = If[resolveIncludeAnodicSpacer,
								If[MatchQ[Lookup[myMapThreadOptions,AnodicSpacer],Except[Automatic]],
									Lookup[myMapThreadOptions,AnodicSpacer],
									Model[Sample,StockSolution, "200mM Iminodiacetic acid"]
								],
								Lookup[myMapThreadOptions,AnodicSpacer] /. Automatic :> Null
							];

							anodicSpacerNullQ = If[resolveIncludeAnodicSpacer,
								NullQ[resolveAnodicSpacer],
								False
							];

							(* identify denaturation agent in the specified object *)
							anodicSpacerIdentity=If[resolveIncludeAnodicSpacer&&!anodicSpacerNullQ,
								Module[
									{anodicSpacerAgentPacket,anodicSpacerAgentComposition,anodicSpacerAgentCompositionIDs,
										anodicSpacerAgentCompositionPackets,identifyAnodicSpacer,ida},
									anodicSpacerAgentPacket=fetchPacketFromCache[Download[resolveAnodicSpacer,Object],optionObjectModelPackets];
									anodicSpacerAgentComposition=Lookup[anodicSpacerAgentPacket,Composition];
									(* construct list with concentration and molecule composition *)
									anodicSpacerAgentCompositionPackets=Map[
										Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
										anodicSpacerAgentComposition];
									(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
									anodicSpacerAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@anodicSpacerAgentCompositionPackets;

									(* Identifiers for simpleSol and Urea based on CAS, synonyms, and InChI *)
									{
										ida
									}={
										{"142-73-4", "Iminodiacetic acid", "Iminodiacetic Acid", "iminodiacetic acid","2,2'-azanediyldiacetic acid", "2,2'-Iminodiacetic acid", "InChI=1S/C4H7NO4/c6-3(7)1-5-2-4(8)9/h5H,1-2H2,(H,6,7)(H,8,9)", "NBZBKCUXIYYUSX-UHFFFAOYSA-N"}
									};
									(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
									(* Note - this assumes a single anodicSpacer agent in the sample; if more, user will need to specify volume *)

									identifyAnodicSpacer=Map[
										Function[compositionMolecule,
											{
												compositionMolecule[[1]] (* ObjectID *),
												compositionMolecule[[2]] (* Concentration *),
												Which[
													ContainsAny[compositionMolecule[[3]],ida],"IDA"
												]
											}
										],
										anodicSpacerAgentCompositionIDs];

									(* pick out cases where the second index in teh list is not null *)
									Cases[identifyAnodicSpacer,{ObjectP[],_,Except[NullP]}]
								],
								{}
							];

							(* check that we      know what the reagent is and what its concentration in the stock solution is *)
							noAnodicSpacerIdentifiedQ = If[resolveIncludeAnodicSpacer&&!anodicSpacerNullQ,
								Length[anodicSpacerIdentity]=!=1,
								False];

							(* grab the concentration of the identified denaturation reagent *)
							anodicSpacerConcentration =  If[resolveIncludeAnodicSpacer&&!noAnodicSpacerIdentifiedQ&&!anodicSpacerNullQ,
								anodicSpacerIdentity[[1]][[2]],
							200 Millimolar
							];

							(* grab suggested concentration by denaturation reagent *)
							targetConcentrationByAnodicSpacer =
           						If[resolveIncludeAnodicSpacer&&!anodicSpacerNullQ&&!noAnodicSpacerIdentifiedQ,
									Switch[anodicSpacerIdentity[[1]][[3]],
									"IDA", 10Millimolar
								],
								10Millimolar
							];

							(* Grab anodicSpacer volume and concentration from options for brevity below *)
							{anodicVolume,anodicConcentration} = Lookup[myMapThreadOptions,{AnodicSpacerVolume,AnodicSpacerTargetConcentration}];

							(* now we can resolve volume and concentration according to the reagent we're using *)
							{
								resolveAnodicSpacerVolume,
								resolveAnodicSpacerTargetConcentration,
								anodicSpacerVolumeNullQ,
								anodicSpacerConcentrationNullQ
							}=If[resolveIncludeAnodicSpacer,
           						Switch[anodicVolume,
									(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
									Null,
									{Null, anodicConcentration /. Automatic :>targetConcentrationByAnodicSpacer, True, False},
									VolumeP,
									{anodicVolume, anodicConcentration /. Automatic :> (anodicVolume*anodicSpacerConcentration)/totalVolume, False, False},
									(* if volume is automatic, check the target concentration and calculate *)
									Automatic,
									Switch[anodicConcentration,
										(* if concentration is null, volume is also null *)
										Null,
										{Null, Null, False, True},
										(* concentration input by molar concentration *)
										ConcentrationP,
										(* if concentration is specified, calculate the volume we need for this reagent and round it *)
										{RoundOptionPrecision[totalVolume*anodicConcentration/anodicSpacerConcentration, 10^-1 Microliter], anodicConcentration, False, False},
										Automatic,
										(* if both the concentration and the volume are Automatic, default concentration to targetConcentrationByAnodicSpacer and calculate accordingly *)
										{RoundOptionPrecision[totalVolume*(anodicConcentration/. Automatic :> targetConcentrationByAnodicSpacer)/anodicSpacerConcentration, 10^-1 Microliter], anodicConcentration/. Automatic :> targetConcentrationByAnodicSpacer, False, False}
									]
								],
								{anodicVolume/. Automatic:>Null, anodicConcentration /. Automatic :>Null, False, False}
							];

							(* check that the volume and concentration are in agreement*)
							anodicSpacerConcentrationVolumeMismatch = If[resolveIncludeAnodicSpacer&&!NullQ[resolveAnodicSpacerVolume]&& !NullQ[resolveAnodicSpacerTargetConcentration],
								resolveAnodicSpacerVolume != resolveAnodicSpacerTargetConcentration*totalVolume / anodicSpacerConcentration,
								False
							];

							(* Resolve CathodicSpacer *)
							cathodicSpacerOptions=
								{
									IncludeCathodicSpacer,CathodicSpacer,CathodicSpacerTargetConcentration,CathodicSpacerVolume
								};

							includeCathodicSpacerBool=Map[
								MatchQ[#,Except[Automatic|Null|False]]&,
								Lookup[myMapThreadOptions,cathodicSpacerOptions]
							];

							(* if the boolean is True, set IncludeCathodicSpacer as true *)
							resolveIncludeCathodicSpacer = Which[
								MatchQ[Lookup[myMapThreadOptions,IncludeCathodicSpacer],BooleanP],Lookup[myMapThreadOptions,IncludeCathodicSpacer],
								NullQ[Lookup[myMapThreadOptions,IncludeCathodicSpacer]], False,
								Or@@includeCathodicSpacerBool,True,
								True,False
							];

							(* check if IncludeAnodicSpacer is False, but relevant options have been specified *)
							cathodicSpacerFalseOptionsSpecifiedQ = Not[resolveIncludeCathodicSpacer]&&Or@@includeCathodicSpacerBool;

							(* Resolve spacer *)
							resolveCathodicSpacer = If[resolveIncludeCathodicSpacer,
								If[MatchQ[Lookup[myMapThreadOptions,CathodicSpacer],Except[Automatic]],
									Lookup[myMapThreadOptions,CathodicSpacer],
									Model[Sample,StockSolution, "500mM Arginine"]
								],
								Lookup[myMapThreadOptions,CathodicSpacer] /. Automatic :> Null
							];

							cathodicSpacerNullQ = If[resolveIncludeCathodicSpacer,
								NullQ[resolveCathodicSpacer],
								False
							];

							(* identify denaturation agent in the specified object *)
							cathodicSpacerIdentity=If[resolveIncludeCathodicSpacer&&!cathodicSpacerNullQ,
								Module[
									{cathodicSpacerAgentPacket,cathodicSpacerAgentComposition,cathodicSpacerAgentCompositionIDs,
										cathodicSpacerAgentCompositionPackets,identifyCathodicSpacer,arg},
									cathodicSpacerAgentPacket=fetchPacketFromCache[Download[resolveCathodicSpacer,Object],optionObjectModelPackets];
									cathodicSpacerAgentComposition=Lookup[cathodicSpacerAgentPacket,Composition];
									(* construct list with concentration and molecule composition *)
									cathodicSpacerAgentCompositionPackets=Map[
										Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
										cathodicSpacerAgentComposition];
									(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
									cathodicSpacerAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@cathodicSpacerAgentCompositionPackets;

									(* Identifiers for simpleSol and Urea based on CAS, synonyms, and InChI *)
									{
										arg
									}={
										{"74-79-3", "L-Arginine", "Arginine", "L-arginine", "arginine", "InChI=1S/C6H14N4O2/c7-4(5(11)12)2-1-3-10-6(8)9/h4H,1-3,7H2,(H,11,12)(H4,8,9,10)/t4-/m0/s1", "ODKSFYDXXFIFQN-BYPYZUCNSA-N"}
									};
									(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
									(* Note - this assumes a single cathodicSpacer agent in the sample; if more, user will need to specify volume *)

									identifyCathodicSpacer=Map[
										Function[compositionMolecule,
											{
												compositionMolecule[[1]] (* ObjectID *),
												compositionMolecule[[2]] (* Concentration *),
												Which[
													ContainsAny[compositionMolecule[[3]],arg],"Arg"
												]
											}
										],
										cathodicSpacerAgentCompositionIDs];

									(* pick out cases where the second index in teh list is not null *)
									Cases[identifyCathodicSpacer,{ObjectP[],_,Except[NullP]}]
								],
								{}
							];

							(* check that we      know what the reagent is and what its concentration in the stock solution is *)
							noCathodicSpacerIdentifiedQ = If[resolveIncludeCathodicSpacer&&!cathodicSpacerNullQ,
								Length[cathodicSpacerIdentity]=!=1,
								False];

							(* grab the concentration of the identified denaturation reagent *)
							cathodicSpacerConcentration =  If[resolveIncludeCathodicSpacer&&!noCathodicSpacerIdentifiedQ&&!cathodicSpacerNullQ,
								cathodicSpacerIdentity[[1]][[2]],
								500Millimolar
							];

							(* grab suggested concentration by denaturation reagent *)
							targetConcentrationByCathodicSpacer =
								If[resolveIncludeCathodicSpacer&&!cathodicSpacerNullQ&&!noCathodicSpacerIdentifiedQ,
									Switch[cathodicSpacerIdentity[[1]][[3]],
										"Arg", 10Millimolar
									],
									10Millimolar
								];

							(* Grab cathodicSpacer volume and concentration from options for brevity below *)
							{cathodicVolume,cathodicConcentration} = Lookup[myMapThreadOptions,{CathodicSpacerVolume,CathodicSpacerTargetConcentration}];

							(* now we can resolve volume and concentration according to the reagent we're using *)
							{
								resolveCathodicSpacerVolume,
								resolveCathodicSpacerTargetConcentration,
								cathodicSpacerVolumeNullQ,
								cathodicSpacerConcentrationNullQ
							}=If[resolveIncludeCathodicSpacer,
								Switch[cathodicVolume,
									(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
									Null,
									{Null, cathodicConcentration /. Automatic :>targetConcentrationByCathodicSpacer, True, False},
									VolumeP,
									{cathodicVolume, cathodicConcentration /. Automatic :> (cathodicVolume*cathodicSpacerConcentration)/totalVolume, False, False},
									(* if volume is automatic, check the target concentration and calculate *)
									Automatic,
									Switch[cathodicConcentration,
										(* if concentration is null, volume is also null *)
										Null,
										{Null, Null, False, True},
										(* concentration input by molar concentration *)
										ConcentrationP,
										(* if concentration is specified, calculate the volume we need for this reagent and round it *)
										{RoundOptionPrecision[totalVolume*cathodicConcentration/cathodicSpacerConcentration, 10^-1 Microliter], cathodicConcentration, False, False},
										Automatic,
										(* if both the concentration and the volume are Automatic, default concentration to targetConcentrationByCathodicSpacer and calculate accordingly *)
										{RoundOptionPrecision[totalVolume*(cathodicConcentration/. Automatic :> targetConcentrationByCathodicSpacer)/cathodicSpacerConcentration, 10^-1 Microliter], cathodicConcentration/. Automatic :> targetConcentrationByCathodicSpacer, False, False}
									]
								],
								{cathodicVolume/. Automatic:>Null, cathodicConcentration /. Automatic :>Null, False, False}
							];

							(* check that the volume and concentration are in agreement*)
							cathodicSpacerConcentrationVolumeMismatch = If[resolveIncludeCathodicSpacer&&!NullQ[resolveCathodicSpacerVolume]&& !NullQ[resolveCathodicSpacerTargetConcentration],
								resolveCathodicSpacerVolume != resolveCathodicSpacerTargetConcentration*totalVolume / cathodicSpacerConcentration,
								False
							];


							(* resolve diluent *)
							(* check volumes to make sure everything fits in the assay tube *)
							volumeLeft=RoundOptionPrecision[totalVolume-Total[Flatten[
								ReplaceAll[{sampleVolume,resolveAmpholyteVolume,resolveIsoelectricPointMarkersVolume,
									resolveElectroosmoticFlowBlockerVolume,resolveDenaturationReagentVolume,
									resolveAnodicSpacerVolume,resolveCathodicSpacerVolume},Null->0Microliter]
							]],
								10^-1 Microliter];

							(* diluent is required only if we there's volume we need to top off to get to totalVolume *)
							{
								resolveDiluent,
								nullDiluentQ,
								sumOfVolumesOverTotalvolumeQ
							}=Which[
								(* sum of volumes is exactly the total volume, no need for a dilutent  *)
								volumeLeft == 0Microliter,
								{
									Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null,
									False,
									False
								},
								(* sum of volumes is less than totalVolume, check if there's a diluent defines, if not raise error *)
								volumeLeft > 0Microliter,
								{
									Lookup[myMapThreadOptions,Diluent]/.Automatic:>Model[Sample, "LCMS Grade Water"],
									NullQ[Lookup[myMapThreadOptions,Diluent]/.Automatic:>Model[Sample, "LCMS Grade Water"]],
									False
								},
								volumeLeft < 0Microliter,
								{
									Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null,
									False,
									True
								}
							];

							(* gather resolved options and errors to return *)
							{
								(* PremadeMasterMix branch's options as Null *)
								Lookup[myMapThreadOptions,PremadeMasterMixVolume]/.Automatic:>Null,
								Lookup[myMapThreadOptions,PremadeMasterMixReagentDilutionFactor]/.Automatic:>Null,
								Lookup[myMapThreadOptions,PremadeMasterMixDiluent]/.Automatic:>Null,
								(* PremadeMasterMix branch's errors as False *)
								False,(* masterMixNullError *)
								False,(* masterMixDilutionFactorNullError *)
								False,(* masterMixVolumeNullError *)
								False,(* masterMixVolumeDilutionFactorMismatchWarning *)
								False,(* masterMixTotalVolumeError *)
								False,(* masterMixDiluentNullError *)
								(* make-your-own mix branch's options *)
								resolveDiluent,
								resolveAmpholytes,
								resolveAmpholyteTargetConcentrations,
								resolveAmpholyteVolume,
								resolveIsoelectricPointMarkers,
								resolveIsoelectricPointMarkersTargetConcentrations,
								resolveIsoelectricPointMarkersVolume,
								resolveAmpholyteStorageCondition,
								resolveIsoelectricPointMarkersStorageCondition,
								resolveElectroosmoticFlowBlocker,
								resolveElectroosmoticFlowBlockerTargetConcentration,
								resolveElectroosmoticFlowBlockerVolume,
								resolveDenature,
								resolveDenaturationReagent,
								resolveDenaturationReagentTargetConcentration,
								resolveDenaturationReagentVolume,
								resolveIncludeAnodicSpacer,
								resolveAnodicSpacer,
								resolveAnodicSpacerTargetConcentration,
								resolveAnodicSpacerVolume,
								resolveIncludeCathodicSpacer,
								resolveCathodicSpacer,
								resolveCathodicSpacerTargetConcentration,
								resolveCathodicSpacerVolume,
								(* make-your-own mix branch's errors - remember to add Or@@ on error checking from nested indexMatched options *)
								nullDiluentQ,
								NoSpecifiedAmpholytesQ,
								Or@@ampholyteMatchedlengthsNotCopaceticQ,
								Or@@ampholyteVolumeNullQ,
								Or@@ampholyteConcentrationNullQ,
								Or@@ampholyteVolumeConcentrationMismatchQ,
								NoSpecifiedIsoelectricPointMarkersQ,
								resolverCantFixIsoelectricPointMarkersMismatchQ,
								Or@@isoelectricPointMarkersVolumeNullQ,
								Or@@isoelectricPointMarkersConcentrationNullQ,
								Or@@isoelectricPointMarkersVolumeConcentrationMismatchQ,
								electroosmoticFlowBlockerNullQ,
								noElectroosmoticFlowBlockerAgentIdentifiedQ,
								electroosmoticFlowBlockerVolumeNullQ,
								electroosmoticFlowBlockerConcentrationNullQ,
								eofBlockerVolumeConcentrationMismatchQ,
								denatureFalseOptionsSpecifiedQ,
								denaturationReagentNullQ,
								noDenaturationReagentIdentifiedQ,
								resolveableDenatureReagentConcentrationUnitMismatchQ,
								unresolveableDenatureReagentConcentrationUnitMismatchQ,
								denaturationReagentVolumeNullQ,
								denaturationReagentConcentrationNullQ,
								denaturationReagentConcentrationVolumeMismatch,
								anodicSpacerFalseOptionsSpecifiedQ,
								anodicSpacerNullQ,
								noAnodicSpacerIdentifiedQ,
								anodicSpacerVolumeNullQ,
								anodicSpacerConcentrationNullQ,
								anodicSpacerConcentrationVolumeMismatch,
								cathodicSpacerFalseOptionsSpecifiedQ,
								cathodicSpacerNullQ,
								noCathodicSpacerIdentifiedQ,
								cathodicSpacerVolumeNullQ,
								cathodicSpacerConcentrationNullQ,
								cathodicSpacerConcentrationVolumeMismatch,
								sumOfVolumesOverTotalvolumeQ
							}
						]
					];

					(* Gather MapThread results *)
					{
						(* General options variables *)
						totalVolume,
						sampleVolume,
						imagingMethods,
						nativeFLExposureTime,
						(* General options errors *)
						missingSampleCompositionWarning,
						OnBoardMixingIncompatibleVolumesError,
						imagingMismatchError,
						voltageDurationStepError,
						(* premade mastermix branch variables *)
						resolvePremadeMasterMix,
						premadeMasterMixReagent,
						premadeMasterMixVolume,
						premadeMasterMixDilutionFactor,
						premadeMasterMixDiluent,
						(* premade mastermix branch errors *)
						premadeMastermixFalseOptionsSpecifiedError,
						premadeMasterMixNullError,
						premadeMasterMixDilutionFactorNullError,
						premadeMasterMixVolumeNullError,
						premadeMasterMixVolumeDilutionFactorMismatchWarning,
						premadeMasterMixTotalVolumeError,
						premadeMasterMixDiluentNullError,
						(* make-ones-own mastermix branch variables *)
						diluent,
						ampholytes,
						ampholyteTargetConcentrations,
						ampholyteVolume,
						isoelectricPointMarkers,
						isoelectricPointMarkersTargetConcentrations,
						isoelectricPointMarkersVolume,
						ampholyteStorageCondition,
						isoelectricPointMarkerStorageCondition,
						electroosmoticFlowBlocker,
						electroosmoticFlowBlockerTargetConcentrations,
						electroosmoticFlowBlockerVolume,
						denature,
						denaturationReagent,
						denaturationReagentTargetConcentration,
						denaturationReagentVolume,
						includeAnodicSpacer,
						anodicSpacer,
						anodicSpacerTargetConcentration,
						anodicSpacerVolume,
						includeCathodicSpacer,
						cathodicSpacer,
						cathodicSpacerTargetConcentration,
						cathodicSpacerVolume,
						(* make-ones-own mastermix branch errors *)
						nullDiluentError,
						noSpecifiedAmpholytesError,
						ampholyteMatchedlengthsNotCopaceticError,
						ampholyteVolumeNullError,
						ampholyteConcentrationNullError,
						ampholyteVolumeConcentrationMismatchError,
						NoSpecifiedIsoelectricPointMarkersError,
						resolverCantFixIsoelectricPointMarkersMismatchError,
						isoelectricPointMarkersVolumeNullError,
						isoelectricPointMarkersConcentrationNullError,
						isoelectricPointMarkersVolumeConcentrationMismatchError,
						electroosmoticFlowBlockerNullError,
						noElectroosmoticFlowBlockerAgentIdentifiedWarning,
						electroosmoticFlowBlockerVolumeNullError,
						electroosmoticFlowBlockerConcentrationNullError,
						eofBlockerVolumeConcentrationMismatchError,
						denatureFalseOptionsSpecifiedError,
						denaturationReagentNullError,
						noDenaturationReagentIdentifiedError,
						resolveableDenatureReagentConcentrationUnitMismatchError,
						unresolveableDenatureReagentConcentrationUnitMismatchError,
						denaturationReagentVolumeNullError,
						denaturationReagentConcentrationNullError,
						denaturationReagentConcentrationVolumeMismatchError,
						anodicSpacerFalseOptionsSpecifiedError,
						anodicSpacerNullError,
						noAnodicSpacerIdentifiedError,
						anodicSpacerVolumeNullError,
						anodicSpacerConcentrationNullError,
						anodicSpacerConcentrationVolumeMismatchError,
						cathodicSpacerFalseOptionsSpecifiedError,
						cathodicSpacerNullError,
						noCathodicSpacerIdentifiedError,
						cathodicSpacerVolumeNullError,
						cathodicSpacerConcentrationNullError,
						cathodicSpacerConcentrationVolumeMismatchError,
						sumOfVolumesOverTotalvolumeError
					}
				]
			],
			(* we are passing teh sample packets and options, as well as the injection table volumes directly to the mapthread to handle sampleVolume resolution in the right sample order *)
			{samplePackets,mapThreadFriendlyOptions, roundedInjectionTableSampleVolumes}
		]];

		(* We've already resolved standards and blanks for the most part, but need to prepare them for their own mapThread *)
		(* Informing volumes from the injection table runs the risk of it not being copacetic with specified samples/standards/blanks *)
		injectionTableStandardNotCopaceticQ = If[MatchQ[specifiedInjectionTable,Except[Automatic]],
			Not[Or[
				MatchQ[resolvedStandards,Null|Automatic|{Automatic..}],
				And[
					ContainsAll[
						Cases[specifiedInjectionTable, {Standard,ObjectP[],VolumeP|Automatic}][[All,2]],
						Cases[resolvedStandards,ObjectP[]]
					],
					ContainsAll[
						Cases[resolvedStandards,ObjectP[]],
						Cases[specifiedInjectionTable, {Standard,ObjectP[],VolumeP|Automatic}][[All,2]]
					]
				]]],
			False
		];

		(* if there is a user specified an injection table, and if they did, grab volumes to pass to the mapthread  *)
		injectionTableStandardVolumes =If[Not[injectionTableStandardNotCopaceticQ],
			Switch[specifiedInjectionTable,
				{{_,ObjectP[],VolumeP|Automatic}..}, Cases[specifiedInjectionTable, {Standard,ObjectP[],VolumeP|Automatic}][[All,3]],
				Automatic, ConstantArray[Automatic, Length[resolvedStandards]]
			],
			(* If samples in injection tables dont match Standard, dont inform volume, we'll raise an error a bit later *)
			ToList[Lookup[roundedCapillaryIsoelectricFocusingOptions, StandardVolume]]
		];

		(* we need to account for a situation where the injection table is not in agreement with samplesIn and options.
	there is an error check later, but we want to make sure we dont break the MapThread *)
		lengthCorrectedInjectionTableStandardVolumes = If[Length[injectionTableStandardVolumes]!=Length[resolvedStandards],
			ConstantArray[Automatic, Length[resolvedStandards]],
			injectionTableStandardVolumes
		];

		(* round volumes *)
		roundedInjectionTableStandardVolumes = RoundOptionPrecision[lengthCorrectedInjectionTableStandardVolumes, 10^-1Microliter];

		resolvedStandardsPackets=fetchPacketFromCache[#,optionObjectModelPackets]&/@resolvedStandards;

		(*rename the keys in the option set*)
		keyStandardNames=Keys[expandedStandardsOptions];

		(*remove the Standard prepend for the for the key*)
		keyStandardNamesPrependRemoved=ToExpression/@StringReplace[ToString/@keyStandardNames,{"Standard"->""}];

		renamedStandardOptionSet=Association[MapThread[Rule,{keyStandardNamesPrependRemoved,Values@expandedStandardsOptions}]];

		(* prep options for mapThread *)
		mapThreadFriendlyStandardOptions=If[resolveIncludeStandards,
			Transpose[Association[renamedStandardOptionSet],AllowedHeads->{Association,List}],
			renamedStandardOptionSet
		];

		(* Informing volumes from the injection table runs the risk of it not being copacetic with specified samples/standards/blanks *)
		(* to avoid this breaking the mapthread, make sure blanks are copacetic, and if not, inform volume from sampleVolume *)
		injectionTableBlankNotCopaceticQ = If[MatchQ[specifiedInjectionTable,Except[Automatic]],
			Not[Or[
				MatchQ[resolvedBlanks,Null|Automatic|{Automatic..}],
				And[
					ContainsAll[
						Cases[specifiedInjectionTable, {Blank,ObjectP[],VolumeP|Automatic}][[All,2]],
						Cases[resolvedBlanks,ObjectP[]]
					],
					ContainsAll[
						Cases[resolvedBlanks,ObjectP[]],
						Cases[specifiedInjectionTable, {Blank,ObjectP[],VolumeP|Automatic}][[All,2]]
					]
				]]],
			False
		];

		(* if there is a user specified an injection table, and if they did, grab volumes to pass to the mapthread  *)
		injectionTableBlankVolumes =If[Not[injectionTableBlankNotCopaceticQ],
			Switch[specifiedInjectionTable,
				{{_,ObjectP[],VolumeP|Automatic}..}, Cases[specifiedInjectionTable, {Blank,ObjectP[],VolumeP|Automatic}][[All,3]],
				Automatic, ConstantArray[Automatic, Length[resolvedBlanks]]
			],
			(* If samples in injection tables dont match Standard, dont inform volume, we'll raise an error a bit later *)
			ToList[Lookup[roundedCapillaryIsoelectricFocusingOptions, BlankVolume]]
		];

		(* we need to account for a situation where the injection table is not in agreement with samplesIn and options.
		there is an error check later, but we want to make sure we dont break the MapThread *)
		lengthCorrectedInjectionTableBlankVolumes = If[Length[injectionTableBlankVolumes]!=Length[resolvedBlanks],
			ConstantArray[Automatic, Length[resolvedBlanks]],
			injectionTableBlankVolumes
		];

		(* round volumes *)
		roundedInjectionTableBlankVolumes = RoundOptionPrecision[lengthCorrectedInjectionTableBlankVolumes, 10^-1Microliter];

		(* prep blank options for mapthread *)
		resolvedBlanksPackets=fetchPacketFromCache[#,optionObjectModelPackets]&/@resolvedBlanks;

		(*rename the keys in the option set*)
		keyBlankNames=Keys[expandedBlanksOptions];

		(*remove the Blank prepend for the for the key*)
		keyBlankNamesPrependRemoved=ToExpression/@StringReplace[ToString/@keyBlankNames,{"Blank"->""}];

		renamedBlankOptionSet=Association[MapThread[Rule,{keyBlankNamesPrependRemoved,Values@expandedBlanksOptions}]];

		(* prep options for mapThread *)
		mapThreadFriendlyBlankOptions=If[resolveIncludeBlanks,
			Transpose[Association[renamedBlankOptionSet],AllowedHeads->{Association,List}],
			renamedBlankOptionSet
		];

		(* mapthread for blanks and standards *)
		{
			{
				(* general option variables *)
				resolvedStandardTotalVolume,
				resolvedStandardVolume,
				resolvedStandardFrequency,
				resolvedStandardLoadTime,
				resolvedStandardVoltageDurationProfile,
				resolvedStandardImagingMethods,
				resolvedStandardNativeFluorescenceExposureTime,
				(* general option errors *)
				standardNullTotalVolumeErrors,
				standardTrueFrequencyNullErrors,
				standardMissingSampleCompositionWarnings,
				standardOnBoardMixingIncompatibleVolumesErrors,
				standardImagingMethodMismatchErrors,
				standardVoltageDurationStepErrors,
				standardLoadTimeNullErrors,
				(* premade mastermix branch variables *)
				resolvedStandardPremadeMasterMix,
				resolvedStandardPremadeMasterMixReagent,
				resolvedStandardPremadeMasterMixVolume,
				resolvedStandardPremadeMasterMixDilutionFactor,
				resolvedStandardPremadeMasterMixDiluent,
				(* premade mastermix branch errors *)
				standardPremadeMastermixFalseOptionsSpecifiedErrors,
				standardPremadeMasterMixNullErrors,
				standardPremadeMasterMixDilutionFactorNullErrors,
				standardPremadeMasterMixVolumeNullErrors,
				standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings,
				standardPremadeMasterMixTotalVolumeErrors,
				standardPremadeMasterMixDiluentNullErrors,
				(* make-ones-own mastermix branch variables *)
				resolvedStandardDiluent,
				resolvedStandardAmpholytes,
				resolvedStandardAmpholyteTargetConcentrations,
				resolvedStandardAmpholyteVolume,
				resolvedStandardIsoelectricPointMarkers,
				resolvedStandardIsoelectricPointMarkersTargetConcentrations,
				resolvedStandardIsoelectricPointMarkersVolume,
				resolvedStandardAmpholytesStorageConditions,
				resolvedStandardIsoelectricPointMarkersStorageConditions,
				resolvedStandardElectroosmoticFlowBlocker,
				resolvedStandardElectroosmoticFlowBlockerTargetConcentrations,
				resolvedStandardElectroosmoticFlowBlockerVolume,
				resolvedStandardDenature,
				resolvedStandardDenaturationReagent,
				resolvedStandardDenaturationReagentTargetConcentration,
				resolvedStandardDenaturationReagentVolume,
				resolvedStandardIncludeAnodicSpacer,
				resolvedStandardAnodicSpacer,
				resolvedStandardAnodicSpacerTargetConcentration,
				resolvedStandardAnodicSpacerVolume,
				resolvedStandardIncludeCathodicSpacer,
				resolvedStandardCathodicSpacer,
				resolvedStandardCathodicSpacerTargetConcentration,
				resolvedStandardCathodicSpacerVolume,
				(* make-ones-own mastermix branch errors *)
				standardNullDiluentErrors,
				standardNoSpecifiedAmpholytesErrors,
				standardAmpholyteMatchedlengthsNotCopaceticErrors,
				standardAmpholyteVolumeNullErrors,
				standardAmpholyteConcentrationNullErrors,
				standardAmpholyteVolumeConcentrationMismatchErrors,
				standardNoSpecifiedIsoelectricPointMarkersErrors,
				standardResolverCantFixIsoelectricPointMarkersMismatchErrors,
				standardIsoelectricPointMarkersVolumeNullErrors,
				standardIsoelectricPointMarkersConcentrationNullErrors,
				standardIsoelectricPointMarkersVolumeConcentrationMismatchErrors,
				standardElectroosmoticFlowBlockerNullErrors,
				standardNoElectroosmoticFlowBlockerAgentIdentifiedWarnings,
				standardElectroosmoticFlowBlockerVolumeNullErrors,
				standardElectroosmoticFlowBlockerConcentrationNullErrors,
				standardEofBlockerVolumeConcentrationMismatchErrors,
				standardDenatureFalseOptionsSpecifiedErrors,
				standardDenaturationReagentNullErrors,
				standardNoDenaturationReagentIdentifiedErrors,
				standardResolveableDenatureReagentConcentrationUnitMismatchErrors,
				standardUnresolveableDenatureReagentConcentrationUnitMismatchErrors,
				standardDenaturationReagentVolumeNullErrors,
				standardDenaturationReagentConcentrationNullErrors,
				standardDenaturationReagentConcentrationVolumeMismatchErrors,
				standardAnodicSpacerFalseOptionsSpecifiedErrors,
				standardAnodicSpacerNullErrors,
				standardNoAnodicSpacerIdentifiedErrors,
				standardAnodicSpacerVolumeNullErrors,
				standardAnodicSpacerConcentrationNullErrors,
				standardAnodicSpacerConcentrationVolumeMismatchErrors,
				standardCathodicSpacerFalseOptionsSpecifiedErrors,
				standardCathodicSpacerNullErrors,
				standardNoCathodicSpacerIdentifiedErrors,
				standardCathodicSpacerVolumeNullErrors,
				standardCathodicSpacerConcentrationNullErrors,
				standardCathodicSpacerConcentrationVolumeMismatchErrors,
				standardSumOfVolumesOverTotalvolumeErrors
			},
			{
				(* general option variables *)
				resolvedBlankTotalVolume,
				resolvedBlankVolume,
				resolvedBlankFrequency,
				resolvedBlankLoadTime,
				resolvedBlankVoltageDurationProfile,
				resolvedBlankImagingMethods,
				resolvedBlankNativeFluorescenceExposureTime,
				(* general option errors *)
				blankNullTotalVolumeErrors,
				blankTrueFrequencyNullErrors,
				blankMissingSampleCompositionWarnings,
				blankOnBoardMixingIncompatibleVolumesErrors,
				blankImagingMethodMismatchErrors,
				blankVoltageDurationStepErrors,
				blankLoadTimeNullErrors,
				(* premade mastermix branch variables *)
				resolvedBlankPremadeMasterMix,
				resolvedBlankPremadeMasterMixReagent,
				resolvedBlankPremadeMasterMixVolume,
				resolvedBlankPremadeMasterMixDilutionFactor,
				resolvedBlankPremadeMasterMixDiluent,
				(* premade mastermix branch errors *)
				blankPremadeMastermixFalseOptionsSpecifiedErrors,
				blankPremadeMasterMixNullErrors,
				blankPremadeMasterMixDilutionFactorNullErrors,
				blankPremadeMasterMixVolumeNullErrors,
				blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings,
				blankPremadeMasterMixTotalVolumeErrors,
				blankPremadeMasterMixDiluentNullErrors,
				(* make-ones-own mastermix branch variables *)
				resolvedBlankDiluent,
				resolvedBlankAmpholytes,
				resolvedBlankAmpholyteTargetConcentrations,
				resolvedBlankAmpholyteVolume,
				resolvedBlankIsoelectricPointMarkers,
				resolvedBlankIsoelectricPointMarkersTargetConcentrations,
				resolvedBlankIsoelectricPointMarkersVolume,
				resolvedBlankAmpholytesStorageConditions,
				resolvedBlankIsoelectricPointMarkersStorageConditions,
				resolvedBlankElectroosmoticFlowBlocker,
				resolvedBlankElectroosmoticFlowBlockerTargetConcentrations,
				resolvedBlankElectroosmoticFlowBlockerVolume,
				resolvedBlankDenature,
				resolvedBlankDenaturationReagent,
				resolvedBlankDenaturationReagentTargetConcentration,
				resolvedBlankDenaturationReagentVolume,
				resolvedBlankIncludeAnodicSpacer,
				resolvedBlankAnodicSpacer,
				resolvedBlankAnodicSpacerTargetConcentration,
				resolvedBlankAnodicSpacerVolume,
				resolvedBlankIncludeCathodicSpacer,
				resolvedBlankCathodicSpacer,
				resolvedBlankCathodicSpacerTargetConcentration,
				resolvedBlankCathodicSpacerVolume,
				(* make-ones-own mastermix branch errors *)
				blankNullDiluentErrors,
				blankNoSpecifiedAmpholytesErrors,
				blankAmpholyteMatchedlengthsNotCopaceticErrors,
				blankAmpholyteVolumeNullErrors,
				blankAmpholyteConcentrationNullErrors,
				blankAmpholyteVolumeConcentrationMismatchErrors,
				blankNoSpecifiedIsoelectricPointMarkersErrors,
				blankResolverCantFixIsoelectricPointMarkersMismatchErrors,
				blankIsoelectricPointMarkersVolumeNullErrors,
				blankIsoelectricPointMarkersConcentrationNullErrors,
				blankIsoelectricPointMarkersVolumeConcentrationMismatchErrors,
				blankElectroosmoticFlowBlockerNullErrors,
				blankNoElectroosmoticFlowBlockerAgentIdentifiedWarnings,
				blankElectroosmoticFlowBlockerVolumeNullErrors,
				blankElectroosmoticFlowBlockerConcentrationNullErrors,
				blankEofBlockerVolumeConcentrationMismatchErrors,
				blankDenatureFalseOptionsSpecifiedErrors,
				blankDenaturationReagentNullErrors,
				blankNoDenaturationReagentIdentifiedErrors,
				blankResolveableDenatureReagentConcentrationUnitMismatchErrors,
				blankUnresolveableDenatureReagentConcentrationUnitMismatchErrors,
				blankDenaturationReagentVolumeNullErrors,
				blankDenaturationReagentConcentrationNullErrors,
				blankDenaturationReagentConcentrationVolumeMismatchErrors,
				blankAnodicSpacerFalseOptionsSpecifiedErrors,
				blankAnodicSpacerNullErrors,
				blankNoAnodicSpacerIdentifiedErrors,
				blankAnodicSpacerVolumeNullErrors,
				blankAnodicSpacerConcentrationNullErrors,
				blankAnodicSpacerConcentrationVolumeMismatchErrors,
				blankCathodicSpacerFalseOptionsSpecifiedErrors,
				blankCathodicSpacerNullErrors,
				blankNoCathodicSpacerIdentifiedErrors,
				blankCathodicSpacerVolumeNullErrors,
				blankCathodicSpacerConcentrationNullErrors,
				blankCathodicSpacerConcentrationVolumeMismatchErrors,
				blankSumOfVolumesOverTotalvolumeErrors
			}
		}=Map[Function[{entry},Module[{existsQ,mapThreadFriendlyOptionsLocal,currentSamples,injectionTableVolumes},
			{existsQ,currentSamples,mapThreadFriendlyOptionsLocal,injectionTableVolumes}=entry;
			If[!existsQ,
				Flatten[Join[
					{
						(* general option variables *)
						{
							Lookup[mapThreadFriendlyOptionsLocal,TotalVolume]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,Volume]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,Frequency]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,LoadTime]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,VoltageDurationProfile]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,ImagingMethods]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,NativeFluorescenceExposureTime]/.Automatic:>Null
						},
						(* general option errors *)
						ConstantArray[False,7],
						(* premade mastermix branch variables *)
						{	Lookup[mapThreadFriendlyOptionsLocal,PremadeMasterMix]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,PremadeMasterMixReagent]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,PremadeMasterMixVolume]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,PremadeMasterMixReagentDilutionFactor]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,PremadeMasterMixDiluent]/.Automatic:>Null
						},
						(* premade mastermix branch errors *)
						ConstantArray[False,7],
						(* make-ones-own mastermix branch variables *)
						{
							Lookup[mapThreadFriendlyOptionsLocal,Diluent]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,Ampholytes]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,AmpholyteTargetConcentrations]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,AmpholyteVolume]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,IsoelectricPointMarkers]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,IsoelectricPointMarkersTargetConcentrations]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,IsoelectricPointMarkersVolume]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,ElectroosmoticFlowBlocker]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,ElectroosmoticFlowBlockerTargetConcentrations]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,ElectroosmoticFlowBlockerVolume]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,AmpholytesStorageCondition]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,IsoelectricPointMarkersStorageCondition]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,Denature]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,DenaturationReagent]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,DenaturationReagentTargetConcentration]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,DenaturationReagentVolume]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,IncludeAnodicSpacer]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,AnodicSpacer]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,AnodicSpacerTargetConcentration]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,AnodicSpacerVolume]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,IncludeCathodicSpacer]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,CathodicSpacer]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,CathodicSpacerTargetConcentration]/.Automatic:>Null,
							Lookup[mapThreadFriendlyOptionsLocal,CathodicSpacerVolume]/.Automatic:>Null
						},
						(* make-ones-own mastermix branch errors *)
						ConstantArray[False,37]
					}]],
				Transpose@MapThread[
					Function[{mySample,myMapThreadOptions,injectionTableVolume},
						Module[
							{
								totalVolume,sampleVolume,sampleFrequency,nullTotalVolumeError,nullFrequencyError,
								missingSampleCompositionWarning,OnBoardMixingIncompatibleVolumesError,
								preMadeMasterMixOptions,includePremadeMasterMixBool,resolvePremadeMasterMix,premadeMasterMixVolume,
								premadeMasterMixDilutionFactor,premadeMasterMixDiluent,premadeMasterMixNullError,
								premadeMastermixFalseOptionsSpecifiedError,premadeMasterMixDilutionFactorNullError,
								premadeMasterMixVolumeNullError,premadeMasterMixVolumeDilutionFactorMismatchWarning,
								premadeMasterMixTotalVolumeError,premadeMasterMixDiluentNullError,diluent,ampholytes,
								ampholyteTargetConcentrations,ampholyteVolume,isoelectricPointMarkers,isoelectricPointMarkersTargetConcentrations,
								isoelectricPointMarkersVolume,electroosmoticFlowBlocker,electroosmoticFlowBlockerTargetConcentrations,
								electroosmoticFlowBlockerVolume,denature,denaturationReagent,denaturationReagentTargetConcentration,denaturationReagentVolume,includeAnodicSpacer,
								anodicSpacer,anodicSpacerTargetConcentration,anodicSpacerVolume,includeCathodicSpacer,cathodicSpacer,
								cathodicSpacerTargetConcentration,cathodicSpacerVolume,noSpecifiedAmpholytesError,nullDiluentError,
								ampholyteVolumeNullError,ampholyteConcentrationNullError,ampholyteVolumeConcentrationMismatchError,
								NoSpecifiedIsoelectricPointMarkersError,resolverCantFixIsoelectricPointMarkersMismatchError,
								isoelectricPointMarkersVolumeNullError,isoelectricPointMarkersConcentrationNullError,
								isoelectricPointMarkersVolumeConcentrationMismatchError,electroosmoticFlowBlockerNullError,
								noElectroosmoticFlowBlockerAgentIdentifiedWarning,electroosmoticFlowBlockerVolumeNullError,
								electroosmoticFlowBlockerConcentrationNullError,eofBlockerVolumeConcentrationMismatchError,denatureFalseOptionsSpecifiedError,
								denaturationReagentNullError,noDenaturationReagentIdentifiedError,resolveableDenatureReagentConcentrationUnitMismatchError,
								unresolveableDenatureReagentConcentrationUnitMismatchError,denaturationReagentVolumeNullError,denaturationReagentConcentrationNullError,
								denaturationReagentConcentrationVolumeMismatchError,anodicSpacerFalseOptionsSpecifiedError,
								anodicSpacerNullError,noAnodicSpacerIdentifiedError,anodicSpacerVolumeNullError,
								anodicSpacerConcentrationNullError,anodicSpacerConcentrationVolumeMismatchError,cathodicSpacerFalseOptionsSpecifiedError,
								cathodicSpacerNullError,noCathodicSpacerIdentifiedError,cathodicSpacerVolumeNullError,cathodicSpacerConcentrationNullError,
								cathodicSpacerConcentrationVolumeMismatchError,sumOfVolumesOverTotalvolumeError,loadTime,loadTimeNullError,
								voltageDurationProfile,imagingMethods,nativeFluorescenceExposureTime,ampholyteMatchedlengthsNotCopaceticError,
								premadeMasterMixReagent,ampholyteStorageCondition,isoelectricPointMarkerStorageCondition,imagingMismatchError,voltageDurationStepError
							},
							(* Setup error tracking variables *)
							{
								nullTotalVolumeError,
								nullFrequencyError,
								missingSampleCompositionWarning,
								OnBoardMixingIncompatibleVolumesError,
								imagingMismatchError,
								voltageDurationStepError,
								premadeMastermixFalseOptionsSpecifiedError,
								loadTimeNullError,
								premadeMasterMixNullError,
								premadeMasterMixDilutionFactorNullError,
								premadeMasterMixVolumeNullError,
								premadeMasterMixVolumeDilutionFactorMismatchWarning,
								premadeMasterMixTotalVolumeError,
								premadeMasterMixDiluentNullError,
								nullDiluentError,
								noSpecifiedAmpholytesError,
								ampholyteMatchedlengthsNotCopaceticError,
								ampholyteVolumeNullError,
								ampholyteConcentrationNullError,
								ampholyteVolumeConcentrationMismatchError,
								NoSpecifiedIsoelectricPointMarkersError,
								resolverCantFixIsoelectricPointMarkersMismatchError,
								isoelectricPointMarkersVolumeNullError,
								isoelectricPointMarkersConcentrationNullError,
								isoelectricPointMarkersVolumeConcentrationMismatchError,
								electroosmoticFlowBlockerNullError,
								noElectroosmoticFlowBlockerAgentIdentifiedWarning,
								electroosmoticFlowBlockerVolumeNullError,
								electroosmoticFlowBlockerConcentrationNullError,
								eofBlockerVolumeConcentrationMismatchError,
								denatureFalseOptionsSpecifiedError,
								denaturationReagentNullError,
								noDenaturationReagentIdentifiedError,
								resolveableDenatureReagentConcentrationUnitMismatchError,
								unresolveableDenatureReagentConcentrationUnitMismatchError,
								denaturationReagentVolumeNullError,
								denaturationReagentConcentrationNullError,
								denaturationReagentConcentrationVolumeMismatchError,
								anodicSpacerFalseOptionsSpecifiedError,
								anodicSpacerNullError,
								noAnodicSpacerIdentifiedError,
								anodicSpacerVolumeNullError,
								anodicSpacerConcentrationNullError,
								anodicSpacerConcentrationVolumeMismatchError,
								cathodicSpacerFalseOptionsSpecifiedError,
								cathodicSpacerNullError,
								noCathodicSpacerIdentifiedError,
								cathodicSpacerVolumeNullError,
								cathodicSpacerConcentrationNullError,
								cathodicSpacerConcentrationVolumeMismatchError,
								sumOfVolumesOverTotalvolumeError
							}=ConstantArray[False,51];

							(* resolve totalVolume *)
							totalVolume=Switch[Lookup[myMapThreadOptions,TotalVolume],
								(* if automatic, set to most common value in sample total Value *)
								Automatic,
								First[Commonest[ToList[resolvedTotalVolume],1]],
								VolumeP,
								Lookup[myMapThreadOptions,TotalVolume],
								(* if its null, we want to avoid other errors, so assume 200 Microliter for here *)
								Null,200Microliter
							];

							(* check if total volume is set to Null *)
							nullTotalVolumeError = NullQ[Lookup[myMapThreadOptions,TotalVolume]];

							(* Resolve SampleVolume *)
							sampleVolume=Which[
								(* if informed, use it *)
								MatchQ[Lookup[myMapThreadOptions,Volume],Except[Automatic]],
									Lookup[myMapThreadOptions,Volume],
								(* if not informed,check if it was informed in the injection Table*)
								MatchQ[injectionTableVolume, VolumeP],
									injectionTableVolume,
								(* If automatic and OnBoardMixing, the difference of totalVolume and 100microliters (which is the volume onBoardMixing dispenses *)
								Lookup[roundedCapillaryIsoelectricFocusingOptions,OnBoardMixing],
									25Microliter,
								(* if automatic, resolve it *)
								MatchQ[Lookup[myMapThreadOptions,Volume],Automatic],
								(* if not informed, pull out composition and resolve volume to reach 0.2 mg/ml in total volume*)
									Module[{compositionProteins,proteinConcentration,calculatedVolume},
										(* get only proteins in the composition *)
										compositionProteins=Cases[Lookup[mySample,Composition],{_,ObjectP[Model[Molecule,Protein]]}];
										(* get concentrations and add all proteins in sample. If possible convert to mg/ml based on its unit *)
										proteinConcentration=If[Length[compositionProteins]==0,
											(* if no proteins in composition, return Null *)
											Null,
											(* if there are proteins in composition get their concentration in mg/ml *)
											Map[
												Function[molecule,Module[{moleculeMW},
													(* grab the Molecule,Protein Model, so you can grab the MW off of it this
													time from the options composition packets (as opposed to the samplesIn composition used for the SamplesIn MapThread *)

													moleculeMW=Flatten[Select[Lookup[optionObjectModelCompositionPackets,
														{Object,MolecularWeight}],MatchQ[#[[1]],Download[molecule[[2]],Object]]&]][[2]];
													(* Try to convert units to Milligram/Milliliter *)
													Switch[Quiet[Convert[molecule[[1]],Milligram/Milliliter]],
														Except[Alternatives[$Failed,Null]],Quiet[Convert[molecule[[1]],Milligram/Milliliter]],(* if it works, return this *)
														Null,Null,(* if returns null, there is no value for concentration *)
														$Failed,If[
														(*if returns $Failed,the unit cant be readily converted,so will further investigate if its MassPercent or Molarity]*)
														MatchQ[QuantityUnit[molecule[[1]]],IndependentUnit["MassPercent"]],
														QuantityMagnitude[molecule[[1]]]*(1000 Milligram)/(100 Milliliter),
														If[
															MatchQ[
																Quiet[Convert[molecule[[1]],Molar]],Except[$Failed|Null]
															]&&!NullQ[moleculeMW],
															Convert[molecule[[1]]*moleculeMW,Milligram/Milliliter]],
														Null]
													]]],
												compositionProteins
											]];
										(* If concentration in mg/ml could be calculated, return the volume to reach 1 mg / ml in totalVolume *)
										calculatedVolume=If[And@@Map[!NullQ[#]& ,ToList[proteinConcentration]],
											((0.2 Milligram/Milliliter)*totalVolume)/Total[proteinConcentration],
											(*otherwise, return volume that is 10% of the TotalVolume and raise warning *)
											missingSampleCompositionWarning=True;
											totalVolume*0.1];
										RoundOptionPrecision[Convert[calculatedVolume,Microliter],10^-1 Microliter,AvoidZero->True]
									]
							];

							(* if using OnBoardMixing, the volume added to sample must be over 100 ul (sample should be 25). will check the difference between total volume and sample volume - if less than 100, raise error *)
							OnBoardMixingIncompatibleVolumesError=If[Lookup[roundedCIEFOptions,OnBoardMixing],
								(totalVolume!=125 Microliter || sampleVolume!=25Microliter),
								False
							];

							(* resolve sampleFrequency *)
							(* if injectionTable is informed, set as null (unless you really want to figure one the frequency, but that's a bit much *)
							sampleFrequency=Switch[Lookup[roundedCIEFOptions, InjectionTable],
								Automatic,
								Lookup[myMapThreadOptions,Frequency]/.Automatic:>First,
								_,
								Lookup[myMapThreadOptions,Frequency]/.Automatic:>Null
							];

							(* Check if frequency was set to Null - but only care if injection table has NOT been specified *)
							nullFrequencyError = If[MatchQ[specifiedInjectionTable,Automatic],
								NullQ[sampleFrequency],
								False
							];

							(* resolve loadTime*)
							loadTime=Switch[Lookup[myMapThreadOptions,LoadTime],
								(* if automatic, set to most common value in sample total Value *)
								Automatic,
								First[Commonest[ToList[Lookup[roundedCapillaryIsoelectricFocusingOptions,LoadTime]],1]],
								TimeP,
								Lookup[myMapThreadOptions,LoadTime],
								Null,Null
							];

							(* resolve voltageDurationProfile*)
							voltageDurationProfile=Switch[Lookup[myMapThreadOptions,VoltageDurationProfile],
								(* if automatic, set to most common value in sample total Value *)
								Automatic,
								First[Commonest[ToList[Lookup[roundedCapillaryIsoelectricFocusingOptions,VoltageDurationProfile]],1]],
								{{VoltageP,TimeP}..},
								Lookup[myMapThreadOptions,VoltageDurationProfile],
								Null,Null
							];

							(* Check if voltage duration profiles have more than the allowed 20 steps. *)
							voltageDurationStepError = Length[Select[ToList[voltageDurationProfile], Not[NullQ[#]]&]]>20||Length[Select[ToList[voltageDurationProfile], Not[NullQ[#]]&]]==0;

							(* Check if LoadTime is set to Null *)
							loadTimeNullError = NullQ[loadTime];

							(* resolve imagingMethods*)
							imagingMethods=Switch[Lookup[myMapThreadOptions,ImagingMethods],
								(* if automatic, set to most common value in sample total Value *)
								Automatic,
								First[Commonest[ToList[resolvedImagingMethods],1]],
								Except[Automatic],
								Lookup[myMapThreadOptions,ImagingMethods],
								True,AbsorbanceAndFluorescence
							];

							(* resolve nativeFluorescenceExposureTime*)
							nativeFluorescenceExposureTime=Switch[Lookup[myMapThreadOptions,NativeFluorescenceExposureTime],
								(* if automatic, set to most common value in sample total Value *)
								Automatic,
								First[Commonest[ToList[resolvedNativeFluorescenceExposureTimes],1]],
								{TimeP..},
								Lookup[myMapThreadOptions,NativeFluorescenceExposureTime],
								Null,Null
							];

							(* if imaging methods is AbsorbanceAndFluorescence but exposure times are null, raise an error. same if its Absorbance but times are specified *)
							imagingMismatchError = MatchQ[imagingMethods, AbsorbanceAndFluorescence]&&NullQ[nativeFLExposureTime] ||
								MatchQ[imagingMethods, Absorbance]&&!NullQ[nativeFLExposureTime];

							(* check if PremadeMasterMix should be True *)
							preMadeMasterMixOptions=
								{
									PremadeMasterMixReagent,PremadeMasterMixDiluent,PremadeMasterMixReagentDilutionFactor,PremadeMasterMixVolume
								};

							(* Should a premade mastermix be included *)
							includePremadeMasterMixBool=Map[
								MatchQ[#,Except[Automatic|Null|False]]&,
								Lookup[myMapThreadOptions,preMadeMasterMixOptions]
							];

							(* ResolvePremadeMastermix accordingly *)
							resolvePremadeMasterMix=Which[
								MatchQ[Lookup[myMapThreadOptions,PremadeMasterMix],Except[Automatic]],
								Lookup[myMapThreadOptions,PremadeMasterMix],
								Or@@includePremadeMasterMixBool,True,
								True,False
							];

							(* Did we specify any relevant options but set PremadeMasterMix to False? *)
							premadeMastermixFalseOptionsSpecifiedError = Not[resolvePremadeMasterMix]&&Or@@includePremadeMasterMixBool;

							(* PremadeMasterMix split to two branches *)
							{
								(*1*)(* premade mastermix branch variables *)
								(*2*)premadeMasterMixReagent,
								(*3*)premadeMasterMixVolume,
								(*4*)premadeMasterMixDilutionFactor,
								(*5*)premadeMasterMixDiluent,
								(*6*)(* premade mastermix branch errors *)
								(*7*)premadeMasterMixNullError,
								(*8*)premadeMasterMixDilutionFactorNullError,
								(*9*)premadeMasterMixVolumeNullError,
								(*10*)premadeMasterMixVolumeDilutionFactorMismatchWarning,
								(*11*)premadeMasterMixTotalVolumeError,
								(*12*)premadeMasterMixDiluentNullError,
								(*13*)(* make-ones-own mastermix branch variables *)
								(*14*)diluent,
								(*15*)ampholytes,
								(*16*)ampholyteTargetConcentrations,
								(*17*)ampholyteVolume,
								(*18*)isoelectricPointMarkers,
								(*19*)isoelectricPointMarkersTargetConcentrations,
								(*20*)isoelectricPointMarkersVolume,
								ampholyteStorageCondition,
								isoelectricPointMarkerStorageCondition,
								(*21*)electroosmoticFlowBlocker,
								(*22*)electroosmoticFlowBlockerTargetConcentrations,
								(*23*)electroosmoticFlowBlockerVolume,
								(*24*)denature,
								(*25*)denaturationReagent,
								(*26*)denaturationReagentTargetConcentration,
								(*27*)denaturationReagentVolume,
								(*28*)includeAnodicSpacer,
								(*29*)anodicSpacer,
								(*30*)anodicSpacerTargetConcentration,
								(*31*)anodicSpacerVolume,
								(*32*)includeCathodicSpacer,
								(*33*)cathodicSpacer,
								(*34*)cathodicSpacerTargetConcentration,
								(*35*)cathodicSpacerVolume,
								(*36*)(* make-ones-own mastermix branch errors *)
								(*37*)nullDiluentError,
								(*38*)noSpecifiedAmpholytesError,
								(*39*)ampholyteMatchedlengthsNotCopaceticError,
								(*40*)ampholyteVolumeNullError,
								(*41*)ampholyteConcentrationNullError,
								(*42*)ampholyteVolumeConcentrationMismatchError,
								(*43*)NoSpecifiedIsoelectricPointMarkersError,
								(*44*)resolverCantFixIsoelectricPointMarkersMismatchError,
								(*45*)isoelectricPointMarkersVolumeNullError,
								(*46*)isoelectricPointMarkersConcentrationNullError,
								(*47*)isoelectricPointMarkersVolumeConcentrationMismatchError,
								(*48*)electroosmoticFlowBlockerNullError,
								(*49*)noElectroosmoticFlowBlockerAgentIdentifiedWarning,
								(*50*)electroosmoticFlowBlockerVolumeNullError,
								(*51*)electroosmoticFlowBlockerConcentrationNullError,
								(*52*)eofBlockerVolumeConcentrationMismatchError,
								denatureFalseOptionsSpecifiedError,
								(*53*)denaturationReagentNullError,
								(*54*)noDenaturationReagentIdentifiedError,
								(*55*)resolveableDenatureReagentConcentrationUnitMismatchError,
								(*56*)unresolveableDenatureReagentConcentrationUnitMismatchError,
								(*57*)denaturationReagentVolumeNullError,
								(*58*)denaturationReagentConcentrationNullError,
								(*59*)denaturationReagentConcentrationVolumeMismatchError,
								anodicSpacerFalseOptionsSpecifiedError,
								(*60*)anodicSpacerNullError,
								(*61*)noAnodicSpacerIdentifiedError,
								(*62*)anodicSpacerVolumeNullError,
								(*63*)anodicSpacerConcentrationNullError,
								(*64*)anodicSpacerConcentrationVolumeMismatchError,
								cathodicSpacerFalseOptionsSpecifiedError,
								(*65*)cathodicSpacerNullError,
								(*66*)noCathodicSpacerIdentifiedError,
								(*67*)cathodicSpacerVolumeNullError,
								(*68*)cathodicSpacerConcentrationNullError,
								(*69*)cathodicSpacerConcentrationVolumeMismatchError,
								(*70*)sumOfVolumesOverTotalvolumeError
							}=If[MatchQ[resolvePremadeMasterMix,True],
								(* PremadeMasterMix, no need to get specific reagents *)
								Module[
									{
										masterMixNullError,masterMixDilutionFactorNullError,masterMixVolume,masterMixVolumeNullError,
										masterMixVolumeDilutionFactorMismatchWarning,masterMixTotalVolumeError,mixReagent,mixVolume,
										mixDilutionFactor,masterMixDilutionFactor,masterMixDiluent,masterMixDiluentNullError
									},

									mixReagent=	If[MatchQ[Lookup[myMapThreadOptions,PremadeMasterMixReagent],Except[Automatic]],
										Lookup[myMapThreadOptions,PremadeMasterMixReagent],
										Model[Sample, StockSolution, "2X Wide-Range cIEF Premade Master Mix"]
									];

									mixVolume=Lookup[myMapThreadOptions,PremadeMasterMixVolume];
									mixDilutionFactor=Lookup[myMapThreadOptions,PremadeMasterMixReagentDilutionFactor];

									(* check if PremadeMasterMixReagent is informed *)
									masterMixNullError=NullQ[mixReagent];

									(* Resolve PremadeMasterMixVolume *)
									{
										masterMixVolume,
										masterMixDilutionFactor,
										masterMixVolumeNullError,
										masterMixDilutionFactorNullError,
										masterMixVolumeDilutionFactorMismatchWarning
									}=Switch[mixVolume,
										(* If volume is Null, check if Dilution factor is null too, In which case return null and raise errors,*)
										(* If DilutionFactor isnt Null, Raise errors, but return Volume as Automatic would *)
										Null,If[
											NullQ[mixDilutionFactor],
											{Null,Null,
												True,True,False},
											{Null,mixDilutionFactor/.Automatic:>2,
												True,False,False}],
										(* If Volume is passed, all good, if dilution factor is also informed, check that they concur if not, raise warning *)
										VolumeP,If[
											NullQ[mixDilutionFactor],
											{mixVolume,mixDilutionFactor,
												False,True,False},
											{mixVolume,mixDilutionFactor/.Automatic:>N[(totalVolume/mixVolume)],
												False,False,mixVolume=!=(totalVolume/mixDilutionFactor/.Automatic:>(totalVolume/mixVolume))}],
										(* if automatic, make sure DilutionFactor is informed and calculate volume*)
										Automatic,If[
											NullQ[mixDilutionFactor],
											{Null,Null,
												False,True,False},
											{(totalVolume/mixDilutionFactor/.Automatic:>2),mixDilutionFactor/.Automatic:>2,
												False,False,False}]
									];

									masterMixTotalVolumeError=If[Not[And[masterMixDilutionFactorNullError,masterMixVolumeNullError]],
										(sampleVolume+masterMixVolume)>totalVolume,
										False];

									(* resolve diluent *)
									masterMixDiluent=Lookup[myMapThreadOptions,PremadeMasterMixDiluent]/.Automatic:>Model[Sample,"LCMS Grade Water"];
									(* if masterMix Diluent is Null but no need to top off to total volume, dont raise an error, otherwise raise an error *)
									masterMixDiluentNullError=(totalVolume-sampleVolume-masterMixVolume)>0Microliter&&MatchQ[masterMixDiluent,Null];

									(* Gather all resolved options and errors to return *)
									{
										(*1*)mixReagent,
										(*2*)masterMixVolume,
										(*3*)masterMixDilutionFactor,
										(*4*)masterMixDiluent,
										(*5*)masterMixNullError,
										(*6*)masterMixDilutionFactorNullError,
										(*7*)masterMixVolumeNullError,
										(*8*)masterMixVolumeDilutionFactorMismatchWarning,
										(*9*)masterMixTotalVolumeError,
										(*10*)masterMixDiluentNullError,
										(*11*)(* other branch's options as Null *)
										(*12*)Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null,
										(*13*)Lookup[myMapThreadOptions,Ampholytes]/.Automatic:>Null,
										(*14*)Lookup[myMapThreadOptions,AmpholyteTargetConcentrations]/.Automatic:>Null,
										(*15*)Lookup[myMapThreadOptions,AmpholyteVolume]/.Automatic:>Null,
										(*16*)Lookup[myMapThreadOptions,IsoelectricPointMarkers]/.Automatic:>Null,
										(*17*)Lookup[myMapThreadOptions,IsoelectricPointMarkersTargetConcentrations]/.Automatic:>Null,
										(*18*)Lookup[myMapThreadOptions,IsoelectricPointMarkersVolume]/.Automatic:>Null,
										Lookup[myMapThreadOptions,AmpholytesStorageCondition]/.Automatic:>Null,
										Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]/.Automatic:>Null,
										(*19*)Lookup[myMapThreadOptions,ElectroosmoticFlowBlocker]/.Automatic:>Null,
										(*20*)Lookup[myMapThreadOptions,ElectroosmoticFlowBlockerTargetConcentrations]/.Automatic:>Null,
										(*21*)Lookup[myMapThreadOptions,ElectroosmoticFlowBlockerVolume]/.Automatic:>Null,
										(*22*)Lookup[myMapThreadOptions,Denature]/.Automatic:>Null,
										(*23*)Lookup[myMapThreadOptions,DenaturationReagent]/.Automatic:>Null,
										(*24*)Lookup[myMapThreadOptions,DenaturationReagentTargetConcentration]/.Automatic:>Null,
										(*25*)Lookup[myMapThreadOptions,DenaturationReagentVolume]/.Automatic:>Null,
										(*26*)Lookup[myMapThreadOptions,IncludeAnodicSpacer]/.Automatic:>Null,
										(*27*)Lookup[myMapThreadOptions,AnodicSpacer]/.Automatic:>Null,
										(*28*)Lookup[myMapThreadOptions,AnodicSpacerTargetConcentration]/.Automatic:>Null,
										(*29*)Lookup[myMapThreadOptions,AnodicSpacerVolume]/.Automatic:>Null,
										(*30*)Lookup[myMapThreadOptions,IncludeCathodicSpacer]/.Automatic:>Null,
										(*31*)Lookup[myMapThreadOptions,CathodicSpacer]/.Automatic:>Null,
										(*32*)Lookup[myMapThreadOptions,CathodicSpacerTargetConcentration]/.Automatic:>Null,
										(*33*)Lookup[myMapThreadOptions,CathodicSpacerVolume]/.Automatic:>Null,
										(*34*)(* Other branch's errors as False *)
										(*35*)False,(* nullDiluentQ *)
										(*36*)False, (* NoSpecifiedAmpholytesQ *)
										(*37*)False, (* ampholyteMatchedlengthsNotCopaceticQ *)
										(*38*)False, (* ampholyteVolumeNullQ *)
										(*39*)False, (* ampholyteConcentrationNullQ *)
										(*40*)False, (* ampholyteVolumeConcentrationMismatchQ *)
										(*41*)False, (* NoSpecifiedIsoelectricPointMarkersQ *)
										(*42*)False, (* resolverCantFixIsoelectricPointMarkersMismatchQ *)
										(*43*)False, (* isoelectricPointMarkersVolumeNullQ *)
										(*44*)False, (* isoelectricPointMarkersConcentrationNullQ *)
										(*45*)False, (* isoelectricPointMarkersVolumeConcentrationMismatchQ *)
										(*46*)False, (* electroosmoticFlowBlockerNullQ *)
										(*47*)False, (* noElectroosmoticFlowBlockerAgentIdentifiedQ *)
										(*48*)False, (* electroosmoticFlowBlockerVolumeNullQ *)
										(*49*)False, (* electroosmoticFlowBlockerConcentrationNullQ *)
										(*50*)False, (* eofBlockerVolumeConcentrationMismatchQ *)
										False, (* denatureFalseOptionsSpecifiedQ *)
										(*51*)False, (* denaturationReagentNullQ *)
										(*52*)False, (* noDenaturationReagentIdentifiedQ *)
										(*53*)False, (* resolveableDenatureReagentConcentrationUnitMismatchQ *)
										(*54*)False, (* unresolveableDenatureReagentConcentrationUnitMismatchQ *)
										(*55*)False, (* denaturationReagentVolumeNullQ *)
										(*56*)False, (* denaturationReagentConcentrationNullQ *)
										(*57*)False, (* denaturationReagentConcentrationVolumeMismatch *)
										False, (* anodicSpacerFalseOptionsSpecifiedQ *)
										(*58*)False, (* anodicSpacerNullQ *)
										(*59*)False, (* noAnodicSpacerIdentifiedQ *)
										(*60*)False, (* anodicSpacerVolumeNullQ *)
										(*61*)False, (* anodicSpacerConcentrationNullQ *)
										(*62*)False, (* anodicSpacerConcentrationVolumeMismatch *)
										False, (* cathodicSpacerFalseOptionsSpecifiedQ *)
										(*63*)False, (* cathodicSpacerNullQ *)
										(*64*)False, (* noCathodicSpacerIdentifiedQ *)
										(*65*)False, (* cathodicSpacerVolumeNullQ *)
										(*66*)False, (* cathodicSpacerConcentrationNullQ *)
										(*67*)False, (* cathodicSpacerConcentrationVolumeMismatch *)
										(*68*)False (* sumOfVolumesOverTotalvolumeQ *)
									}
								],
								(* no PremadeMasterMix, make your own mastermix *)
								Module[
									{
										resolveDiluent,resolveAmpholytes,resolveAmpholyteTargetConcentration,resolveAmpholyteVolume,resolveIsoelectricPointMarkers,
										resolveIsoelectricPointMarkersTargetConcentrations,resolveIsoelectricPointMarkersVolume,resolveElectroosmoticFlowBlocker,
										resolveElectroosmoticFlowBlockerTargetConcentration,resolveElectroosmoticFlowBlockerVolume,resolveDenature,
										resolveDenaturationReagent,resolveDenaturationReagentTargetConcentration,resolveDenaturationReagentVolume,
										resolveIncludeAnodicSpacer,resolveAnodicSpacer,resolveAnodicSpacerTargetConcentration,resolveAnodicSpacerVolume,
										resolveIncludeCathodicSpacer,resolveCathodicSpacer,resolveCathodicSpacerTargetConcentration,resolveCathodicSpacerVolume,
										NoSpecifiedAmpholytesQ, volumeLeft, nullDiluentQ,sumOfVolumesOverTotalvolumeQ,ampholyteVolumeNullQ,ampholyteConcentrationNullQ,
										ampholyteMatchedlengthsNotCopaceticQ,ampholyteVolumeConcentrationMismatchQ,NoSpecifiedIsoelectricPointMarkersQ,
										resolverCantFixIsoelectricPointMarkersMismatchQ,isoelectricPointMarkersVolumeNullQ,
										isoelectricPointMarkersConcentrationNullQ,isoelectricPointMarkersVolumeConcentrationMismatchQ,
										pIMarkerVolume,pIMarkerConcentration,electroosmoticFlowBlockerNullQ,
										electroosmoticFlowBlockerAgentIdentity,noElectroosmoticFlowBlockerAgentIdentifiedQ,
										electroosmoticFlowBlockerReagentConcentration,eofBlockerVolume,eofBlockerConcentration,
										eofBlockerVolumeConcentrationMismatchQ,electroosmoticFlowBlockerVolumeNullQ,
										electroosmoticFlowBlockerConcentrationNullQ,denatureOptions,includeDenatureBool,denatureFalseOptionsSpecifiedQ,
										denaturationReagentNullQ,denaturationReagentAgentIdentity,noDenaturationReagentIdentifiedQ,
										denaturationReagentConcentration,targetConcentrationByDenaturationReagent,
										denatureVolume,denatureConcentration,denaturationReagentVolumeNullQ,
										denaturationReagentConcentrationNullQ,denatureReagentConcentrationUnitMismatch,
										resolveableDenatureReagentConcentrationUnitMismatchQ,unresolveableDenatureReagentConcentrationUnitMismatchQ,
										denaturationReagentConcentrationVolumeMismatch,anodicSpacerOptions,includeAnodicSpacerBool,
										anodicSpacerNullQ,anodicSpacerFalseOptionsSpecifiedQ,anodicSpacerIdentity,noAnodicSpacerIdentifiedQ,anodicSpacerConcentration,
										targetConcentrationByAnodicSpacer,anodicVolume,anodicConcentration,anodicSpacerVolumeNullQ,
										anodicSpacerConcentrationNullQ,anodicSpacerConcentrationVolumeMismatch,cathodicSpacerOptions,
										includeCathodicSpacerBool,cathodicSpacerFalseOptionsSpecifiedQ,cathodicSpacerNullQ,cathodicSpacerIdentity,
										noCathodicSpacerIdentifiedQ,cathodicSpacerConcentration,targetConcentrationByCathodicSpacer,cathodicVolume,
										cathodicConcentration,cathodicSpacerVolumeNullQ,cathodicSpacerConcentrationNullQ,
										cathodicSpacerConcentrationVolumeMismatch,lengthToMatch,pIMarkersLengthToMatch,
										resolveAmpholyteStorageCondition, resolveIsoelectricPointMarkersStorageCondition,
										nopIMarkerIdentifiedQ,pIMarkerIdentity,pIMarkerReagentConcentration,pIMarkerCompatibleUnit
									},

									(* resolve ampholytes *)
									resolveAmpholytes=If[
										MatchQ[ToList[Lookup[myMapThreadOptions,Ampholytes]],Except[{Automatic}]],
										ToList[Lookup[myMapThreadOptions,Ampholytes]],
										{Model[Sample,"Pharmalyte pH 3-10"]}
									];

									NoSpecifiedAmpholytesQ =Or@@(NullQ[#]& /@ resolveAmpholytes);

									(* resolve ampholyte volume and concentration *)
									(* to make sure teh length of items is the same, given a situation where volume or concentration, or both are Automatic and ampholytes or any other is not *)
									lengthToMatch = Length[resolveAmpholytes];

									(* check that lengths are copacetic *)
									ampholyteMatchedlengthsNotCopaceticQ =
										Or@@((Length[ToList[#]] != lengthToMatch)& /@ {Lookup[myMapThreadOptions,AmpholyteVolume]/. {{Automatic}:> ConstantArray[Automatic, lengthToMatch]},
											Lookup[myMapThreadOptions,AmpholyteTargetConcentrations]/. {{Automatic} :> ConstantArray[Automatic, lengthToMatch]}});

									{
										resolveAmpholyteVolume,
										resolveAmpholyteTargetConcentration,
										ampholyteVolumeNullQ,
										ampholyteConcentrationNullQ
									} = If[Not[ampholyteMatchedlengthsNotCopaceticQ],
										Transpose@MapThread[
											Function[{volume, concentration},
												Switch[volume,
													(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
													Null,
													{Null, concentration /. Automatic :>(4VolumePercent/lengthToMatch), True, False},
													VolumeP,
													{volume, concentration /. Automatic :> 100VolumePercent*volume/totalVolume, False, False},
													(* if volume is automatic, check the target concentration and calculate *)
													Automatic,
													Switch[concentration,
														(* if concentration is null, volume is also null *)
														Null,
														{Null, Null, False, True},
														VolumePercentP,
														(* if concentration is specified, calculate the volume we need for this Ampholyte and round it *)
														{RoundOptionPrecision[totalVolume*concentration/(100VolumePercent), 10^-1 Microliter], concentration, False, False},
														Automatic,
														(* if both the concentration and the volume are Automatic, default concentration to 4 VolumePercent and calculate accordingly *)
														{RoundOptionPrecision[totalVolume*(concentration/. Automatic :> (4VolumePercent/lengthToMatch))/(100VolumePercent), 10^-1 Microliter], concentration/. Automatic :> (4VolumePercent/lengthToMatch), False, False}
													]
												]
											],
											(* in a case where multiple automatics were specified for ALL of ampholytes, volumes, and concentrations,make sure they match in length to that of resolvedAmpholytes  *)
											{ToList[Lookup[myMapThreadOptions,AmpholyteVolume]]/. {{Automatic} :> ConstantArray[Automatic, lengthToMatch]},
												ToList[Lookup[myMapThreadOptions,AmpholyteTargetConcentrations]]/. {{Automatic} :> ConstantArray[Automatic, lengthToMatch]}}
										],
										{
											Lookup[myMapThreadOptions,AmpholyteVolume]/. Automatic|{Automatic..}:>Null,
											Lookup[myMapThreadOptions,AmpholyteTargetConcentrations]/. Automatic|{Automatic..} :> Null,
											NullQ[Lookup[myMapThreadOptions,AmpholyteVolume]],
											NullQ[Lookup[myMapThreadOptions,AmpholyteTargetConcentrations]]
										}
									];

									(* If volume and concentration are not in agreement, raise an error*)
									ampholyteVolumeConcentrationMismatchQ=If[Not[ampholyteMatchedlengthsNotCopaceticQ],
             							MapThread[
											Function[{volume, concentration},
												If[!NullQ[volume]&& !NullQ[concentration],
													Abs[volume - N[concentration*totalVolume/(100VolumePercent)]]>0.1Microliter,
													False
												]],
											{resolveAmpholyteVolume,resolveAmpholyteTargetConcentration}
										],
										False
									];

									resolveAmpholyteStorageCondition = Which[
										Length[ToList[Lookup[myMapThreadOptions,AmpholytesStorageCondition]]]>lengthToMatch,
										(* in the rare case where more conditions are given than storage conditions, might be the result of expansion, so grab the first and populate for all - its a crappy solution, but works *)
										Lookup[myMapThreadOptions,AmpholytesStorageCondition]/.{{Automatic..} :> ConstantArray[Null, lengthToMatch],storage:{SampleStorageTypeP..}:>  ConstantArray[First[storage], lengthToMatch]},
										Length[ToList[Lookup[myMapThreadOptions,AmpholytesStorageCondition]]]==1,
										Lookup[myMapThreadOptions,AmpholytesStorageCondition]/.{Automatic|{Automatic..} :> ConstantArray[Null, lengthToMatch],storage:SampleStorageTypeP|{SampleStorageTypeP}:>  ConstantArray[First[ToList[storage]], lengthToMatch]},
										Length[ToList[Lookup[myMapThreadOptions,AmpholytesStorageCondition]]]>1,
										Lookup[myMapThreadOptions,AmpholytesStorageCondition]/.{{Automatic..} :> ConstantArray[Null, lengthToMatch]}
									];

									(* resolve isoelectricPointMarkers *)
									resolveIsoelectricPointMarkers=If[
										(MatchQ[ToList[Lookup[myMapThreadOptions,IsoelectricPointMarkers]],Except[{Automatic..}]]),
										ToList[Lookup[myMapThreadOptions,IsoelectricPointMarkers]],
										{Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 4.05" ], Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 9.99" ]}
									];

									NoSpecifiedIsoelectricPointMarkersQ =Or@@(NullQ[#]& /@ resolveIsoelectricPointMarkers);

									(* for brevity, get these into a variable of their own *)
									{pIMarkerVolume,pIMarkerConcentration} = Lookup[myMapThreadOptions,{IsoelectricPointMarkersVolume,IsoelectricPointMarkersTargetConcentrations}];

									(* check lengths of matched options *)
									pIMarkersLengthToMatch = Length[resolveIsoelectricPointMarkers];

									resolverCantFixIsoelectricPointMarkersMismatchQ =
										Or@@((Length[ToList[#]] != pIMarkersLengthToMatch)& /@ {pIMarkerVolume/. {{Automatic}:> ConstantArray[Automatic, pIMarkersLengthToMatch]},
											pIMarkerConcentration/. {{Automatic}:> ConstantArray[Automatic, pIMarkersLengthToMatch]}});

									(* get the concentration of the reagent, has to be a volume percent *)
									(* to resolve resolveIsoelectricPointMarkersVolume below, need to know which agent is used *)
									pIMarkerIdentity=If[!NoSpecifiedIsoelectricPointMarkersQ,
										Flatten[Map[Function[piMarker,
											Module[
												{pIMarkerPacket,pIMarkerComposition,pIMarkerCompositionIDs,
													pIMarkerCompositionPackets,identifypIMarker,markerPeptide},
												pIMarkerPacket=fetchPacketFromCache[Download[piMarker,Object],optionObjectModelPackets];
												pIMarkerComposition=Lookup[pIMarkerPacket,Composition];
												(* construct list with concentration and molecule composition *)
												pIMarkerCompositionPackets=Map[
													Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
													pIMarkerComposition];
												(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
												pIMarkerCompositionIDs=If[!MatchQ[#, {NullP..}],{Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]}, {Null, Null, Null}] &/@pIMarkerCompositionPackets;

												(* Identifiers for pI Markers (from proteinSimple) based on synonyms *)
												{
													markerPeptide
												}={
													{
														"ProteinSimple Maurice cIEF pI Marker - 10.17",
														"ProteinSimple Maurice cIEF pI Marker - 9.99",
														"ProteinSimple Maurice cIEF pI Marker - 9.50",
														"ProteinSimple Maurice cIEF pI Marker - 8.40",
														"ProteinSimple Maurice cIEF pI Marker - 7.05",
														"ProteinSimple Maurice cIEF pI Marker - 6.14",
														"ProteinSimple Maurice cIEF pI Marker - 5.85",
														"ProteinSimple Maurice cIEF pI Marker - 4.05",
														"ProteinSimple Maurice cIEF pI Marker - 3.38"
													}
												};
												(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
												(* Note - this assumes a single pIMarker agent in the sample; if more, user will need to specify volume *)

												identifypIMarker=Map[
													Function[compositionMolecule,
														{
															compositionMolecule[[1]] (* ObjectID *),
															compositionMolecule[[2]] (* Concentration *),
															Which[
																ContainsAny[compositionMolecule[[3]],markerPeptide],"pIMarker"
															]
														}
													],
													pIMarkerCompositionIDs];

												(* pick out cases where the second index in teh list is not null *)
												Cases[identifypIMarker,{ObjectP[],_,Except[NullP]}]
											]],
											resolveIsoelectricPointMarkers
										],1],
										{}];

									(* check that we know what the reagent is and what its concentration in the reagent *)
									nopIMarkerIdentifiedQ = If[!NoSpecifiedIsoelectricPointMarkersQ,
										Length[pIMarkerIdentity]=!=Length[resolveIsoelectricPointMarkers],
										False];

									(* are we dealing with volume percent? *)
									pIMarkerCompatibleUnit = Map[MatchQ[QuantityUnit[#],IndependentUnit["VolumePercent"]]&,pIMarkerIdentity[[All,2]]];

									(* if the concentraiton is anything but volume percent, assume it is 100VolumePercent *)
									pIMarkerReagentConcentration = If[!nopIMarkerIdentifiedQ&&!NoSpecifiedIsoelectricPointMarkersQ,
										If[And@@pIMarkerCompatibleUnit,
											pIMarkerIdentity[[All,2]],
											MapThread[If[#1, #2, 100VolumePercent]&, {pIMarkerCompatibleUnit, pIMarkerIdentity[[All,2]]}]
										],
										ConstantArray[100VolumePercent,Length[resolveIsoelectricPointMarkers]]
									];

									(* resolve isoelectricPointMarkers volume and concentration *)
									(* at this point, we know that the lengths are all the same (we expanded them based on that notion, so we can mapthread to resolve each one seperately *)
									{
										resolveIsoelectricPointMarkersVolume,
										resolveIsoelectricPointMarkersTargetConcentrations,
										isoelectricPointMarkersVolumeNullQ,
										isoelectricPointMarkersConcentrationNullQ
									} = If[
										!resolverCantFixIsoelectricPointMarkersMismatchQ,
										(* no problems moving forward, might need to account for differences in length *)
										Transpose@MapThread[
											Function[{volume, concentration, reagentConcentration},
												Switch[volume,
													(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
													Null,
													{Null, concentration /. Automatic :>1VolumePercent, True, False},
													VolumeP,
													{volume, concentration /. Automatic :> reagentConcentration*volume/totalVolume, False, False},
													(* if volume is automatic, check the target concentration and calculate *)
													Automatic,
													Switch[concentration,
														(* if concentration is null, volume is also null *)
														Null,
														{Null, Null, False, True},
														VolumePercentP,
														(* if concentration is specified, calculate the volume we need for this IsoelectricPointMarkers and round it *)
														{RoundOptionPrecision[totalVolume*concentration/reagentConcentration, 10^-1 Microliter], concentration, False, False},
														Automatic,
														(* if both the concentration and the volume are Automatic, default concentration to 1 VolumePercent and calculate accordingly *)
														{RoundOptionPrecision[totalVolume*(concentration/. Automatic :> 1VolumePercent)/reagentConcentration, 10^-1 Microliter], concentration/. Automatic :> 1VolumePercent, False, False}
													]
												]
											],
											(* This has to match the length of resolved but we know its resolveable so, consider several cases to MapThread on*)
											{
												ToList[pIMarkerVolume]/. {{Automatic} :> ConstantArray[Automatic, pIMarkersLengthToMatch]},
												ToList[pIMarkerConcentration]/. {{Automatic} :> ConstantArray[Automatic, pIMarkersLengthToMatch]},
												ToList[pIMarkerReagentConcentration]
											}
										],
										{
											pIMarkerVolume/. Automatic|{Automatic..}:>Null,
											pIMarkerConcentration/. Automatic|{Automatic..} :> Null,
											NullQ[pIMarkerVolume],
											NullQ[pIMarkerConcentration]
										}
									];

									(* If volume and concentration are not in agreement, raise an error*)
									isoelectricPointMarkersVolumeConcentrationMismatchQ=If[!resolverCantFixIsoelectricPointMarkersMismatchQ,
										MapThread[Function[{volume, concentration, reagentConcentation},
											If[!NullQ[volume]&& !NullQ[concentration],
												Abs[volume - N[concentration*totalVolume/reagentConcentation]]>0.1Microliter,
												False
											]],
											{resolveIsoelectricPointMarkersVolume,resolveIsoelectricPointMarkersTargetConcentrations,pIMarkerReagentConcentration}
										],
										False
									];

									resolveIsoelectricPointMarkersStorageCondition = Which[
										Length[ToList[Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]]]>pIMarkersLengthToMatch,
										(* in the rare case where more conditions are given than storage conditions, might be the result of expansion, so grab the first and populate for all - its a crappy solution, but works *)
										Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]/.{Automatic|{Automatic..} :> ConstantArray[Null, pIMarkersLengthToMatch],storage:SampleStorageTypeP|{SampleStorageTypeP..}:> Sequence@@ConstantArray[First[storage], pIMarkersLengthToMatch]},
										Length[ToList[Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]]]==1,
										Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]/.{Automatic|{Automatic..} :> ConstantArray[Null, pIMarkersLengthToMatch],storage:SampleStorageTypeP|{SampleStorageTypeP}:> ConstantArray[First[ToList[storage]], pIMarkersLengthToMatch]},
										Length[ToList[Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]]]>1,
										Lookup[myMapThreadOptions,IsoelectricPointMarkersStorageCondition]/.{Automatic|{Automatic..} :> ConstantArray[Null, pIMarkersLengthToMatch]}
									];

									(* resolve electroosmoticFlowBlocker *)
									resolveElectroosmoticFlowBlocker=If[
										MatchQ[Lookup[myMapThreadOptions,ElectroosmoticFlowBlocker],Except[Automatic]],
										Lookup[myMapThreadOptions,ElectroosmoticFlowBlocker],
										Model[Sample,"1% Methyl Cellulose"]
									];

									electroosmoticFlowBlockerNullQ = NullQ[resolveElectroosmoticFlowBlocker];

									(* get the concentration of the reagent, has to be a mass volume precentage or gram/liter. Methyl Cellulose is too variable for mw *)
									(* to resolve mixElectroosmoticFlowBlockerAgentTargetConcentration below, need to know which agent is used *)
									electroosmoticFlowBlockerAgentIdentity=If[!electroosmoticFlowBlockerNullQ,
										Module[
											{electroosmoticFlowBlockerAgentPacket,electroosmoticFlowBlockerAgentComposition,electroosmoticFlowBlockerAgentCompositionIDs,
												electroosmoticFlowBlockerAgentCompositionPackets,identifyElectroosmoticFlowBlockerAgent,methylCellulose},
											electroosmoticFlowBlockerAgentPacket=fetchPacketFromCache[Download[resolveElectroosmoticFlowBlocker,Object],optionObjectModelPackets];
											electroosmoticFlowBlockerAgentComposition=Lookup[electroosmoticFlowBlockerAgentPacket,Composition];
											(* construct list with concentration and molecule composition *)
											electroosmoticFlowBlockerAgentCompositionPackets=Map[
												Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
												electroosmoticFlowBlockerAgentComposition];
											(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
											electroosmoticFlowBlockerAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@electroosmoticFlowBlockerAgentCompositionPackets;

											(* Identifiers for methyl cellulose based on CAS, synonyms, and InChI *)
											{
												methylCellulose
											}={
												{"9004-67-5","MC","Methyl Cellulose", "MethylCellulose","Methylcellulose","methylcellulose","Methyl cellulose","methyl cellulose" }
											};
											(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
											(* Note - this assumes a single electroosmoticFlowBlocker agent in the sample; if more, user will need to specify volume *)

											identifyElectroosmoticFlowBlockerAgent=Map[
												Function[compositionMolecule,
													{
														compositionMolecule[[1]] (* ObjectID *),
														compositionMolecule[[2]] (* Concentration *),
														Which[
															ContainsAny[compositionMolecule[[3]],methylCellulose],"MC"
														]
													}
												],
												electroosmoticFlowBlockerAgentCompositionIDs];

											(* pick out cases where the second index in teh list is not null *)
											Cases[identifyElectroosmoticFlowBlockerAgent,{ObjectP[],_,Except[NullP]}]
										],
										{}];

									(* check that we know what the reagent is and what its concentration in the stock solution is *)
									noElectroosmoticFlowBlockerAgentIdentifiedQ = If[!electroosmoticFlowBlockerNullQ,
										Length[electroosmoticFlowBlockerAgentIdentity]=!=1,
										False];

									electroosmoticFlowBlockerReagentConcentration = If[!noElectroosmoticFlowBlockerAgentIdentifiedQ&&!electroosmoticFlowBlockerNullQ,
										electroosmoticFlowBlockerAgentIdentity[[1]][[2]],
										1MassPercent];

									(* fetch volume and concentration to make it easier below *)
									{eofBlockerVolume,eofBlockerConcentration} = Lookup[myMapThreadOptions,{ElectroosmoticFlowBlockerVolume,ElectroosmoticFlowBlockerTargetConcentrations}];

									(* resolve EOFBlocker volume and concentration *)
									{
										resolveElectroosmoticFlowBlockerVolume,
										resolveElectroosmoticFlowBlockerTargetConcentration,
										electroosmoticFlowBlockerVolumeNullQ,
										electroosmoticFlowBlockerConcentrationNullQ
									}=If[!electroosmoticFlowBlockerNullQ,
										Switch[eofBlockerVolume,
											(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
											Null,
											{Null, eofBlockerConcentration /. Automatic :>0.35MassPercent, True, False},
											VolumeP,
											{eofBlockerVolume, eofBlockerConcentration /. Automatic :> N[(eofBlockerVolume*electroosmoticFlowBlockerReagentConcentration)/totalVolume], False, False},
											(* if volume is automatic, check the target concentration and calculate *)
											Automatic,
											Switch[eofBlockerConcentration,
												(* if concentration is null, volume is also null *)
												Null,
												{Null, Null, False, True},
												MassPercentP,
												(* if concentration is specified, calculate the volume we need for this Ampholyte and round it *)
												{RoundOptionPrecision[totalVolume*eofBlockerConcentration/electroosmoticFlowBlockerReagentConcentration, 10^-1 Microliter], eofBlockerConcentration, False, False},
												Automatic,
												(* if both the concentration and the volume are Automatic, default concentration to 0.35 MassPercent and calculate accordingly *)
												{RoundOptionPrecision[totalVolume*(eofBlockerConcentration/. Automatic :> 0.35MassPercent)/electroosmoticFlowBlockerReagentConcentration, 10^-1 Microliter], eofBlockerConcentration/. Automatic :> 0.35MassPercent, False, False}
											]
										],
										{
											eofBlockerVolume/.Automatic:>Null,
											eofBlockerConcentration/.Automatic:>Null,
											NullQ[eofBlockerVolume],
											NullQ[eofBlockerConcentration]
										}
									];

									(* check if there's a mismatch between the volume and concenration, if there is, raise an error *)
									eofBlockerVolumeConcentrationMismatchQ=	If[!NullQ[resolveElectroosmoticFlowBlockerVolume]&& !NullQ[resolveElectroosmoticFlowBlockerTargetConcentration] &&!electroosmoticFlowBlockerNullQ,
										Abs[resolveElectroosmoticFlowBlockerVolume - resolveElectroosmoticFlowBlockerTargetConcentration*totalVolume / electroosmoticFlowBlockerReagentConcentration]>0.1Microliter,
										False
									];

									(* resolve denaturation *)
									(* list options to check if they're specified to trigger the Denature boolean to set as True *)
									denatureOptions=
										{
											Denature,DenaturationReagent,DenaturationReagentTargetConcentration,DenaturationReagentVolume
										};

									includeDenatureBool=Map[
										MatchQ[#,Except[Automatic|Null|False]]&,
										Lookup[myMapThreadOptions,denatureOptions]
									];

									(* if the boolean is True, set Denature as true *)
									resolveDenature = Which[
										MatchQ[Lookup[myMapThreadOptions,Denature],BooleanP],Lookup[myMapThreadOptions,Denature],
										NullQ[Lookup[myMapThreadOptions,Denature]], False,
										Or@@includeDenatureBool,True,
										True,False
									];

									(* check if denature resolves to True, but relevant options have been specified *)
									denatureFalseOptionsSpecifiedQ = Not[resolveDenature]&&Or@@includeDenatureBool;

									resolveDenaturationReagent = If[resolveDenature,
										Switch[Lookup[myMapThreadOptions,DenaturationReagent],
											Automatic,
											Model[Sample,StockSolution,"10M Urea"],
											Null,
											Null,
											ObjectP[],
											Lookup[myMapThreadOptions,DenaturationReagent]
										],
										Lookup[myMapThreadOptions,DenaturationReagent] /. Automatic :> Null
									];

									denaturationReagentNullQ = If[resolveDenature,
										NullQ[resolveDenaturationReagent],
										False
									];


									(* identify denaturation agent in the specified object *)
									denaturationReagentAgentIdentity=If[resolveDenature&&!denaturationReagentNullQ,
										Module[
											{denaturationReagentAgentPacket,denaturationReagentAgentComposition,denaturationReagentAgentCompositionIDs,
												denaturationReagentAgentCompositionPackets,identifyDenaturationAgent,simpleSol,urea},
											denaturationReagentAgentPacket=fetchPacketFromCache[Download[resolveDenaturationReagent,Object],optionObjectModelPackets];
											denaturationReagentAgentComposition=Lookup[denaturationReagentAgentPacket,Composition];
											(* construct list with concentration and molecule composition *)
											denaturationReagentAgentCompositionPackets=Map[
												Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
												denaturationReagentAgentComposition];
											(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
											denaturationReagentAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@denaturationReagentAgentCompositionPackets;

											(* Identifiers for simpleSol and Urea based on CAS, synonyms, and InChI *)
											{
												simpleSol,
												urea
											}={
												{"SimpleSol Protein Solubilizer", "SimpleSol", "Simple Sol", "simplesol", "ProteinSimple SimpleSol Protein Solubilizer"},
												{"57-13-6", "Urea", "urea", "Carbamide", "Carbonyldiamide", "InChI=1S/CH4N2O/c2-1(3)4/h(H4,2,3,4)", " XSQUKJJJFZCRTK-UHFFFAOYSA-N"}
											};
											(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
											(* Note - this assumes a single denaturationReagent agent in the sample; if more, user will need to specify volume *)

											identifyDenaturationAgent=Map[
												Function[compositionMolecule,
													{
														compositionMolecule[[1]] (* ObjectID *),
														compositionMolecule[[2]] (* Concentration *),
														Which[
															ContainsAny[compositionMolecule[[3]],simpleSol],"SimpleSol",
															ContainsAny[compositionMolecule[[3]],urea],"Urea"
														]
													}
												],
												denaturationReagentAgentCompositionIDs];

											(* pick out cases where the second index in teh list is not null *)
											Cases[identifyDenaturationAgent,{ObjectP[],_,Except[NullP]}]
										],
										{}
									];

									(* check that we      know what the reagent is and what its concentration in the stock solution is *)
									noDenaturationReagentIdentifiedQ = If[resolveDenature&&!denaturationReagentNullQ,
										Length[denaturationReagentAgentIdentity]=!=1,
										False
									];

									(* grab the concentration of the identified denaturation reagent *)
									denaturationReagentConcentration = If[resolveDenature&&!denaturationReagentNullQ&&!noDenaturationReagentIdentifiedQ,
										denaturationReagentAgentIdentity[[1]][[2]],
										10Molar
									];

									(* grab suggested concentration by denaturation reagent *)
									targetConcentrationByDenaturationReagent =If[resolveDenature&&!denaturationReagentNullQ&&!noDenaturationReagentIdentifiedQ,
										Switch[denaturationReagentAgentIdentity[[1]][[3]],
											"SimpleSol", 20VolumePercent,
											"Urea", 4Molar
										],
										4Molar
									];

									(* Grab denaturationReagent volume and concentration from options for brevity below *)
									{denatureVolume,denatureConcentration} = Lookup[myMapThreadOptions,{DenaturationReagentVolume,DenaturationReagentTargetConcentration}];

									(* check that the unit specified for DenaturationReagentTargetConcentration is appropriate for the reagent (can't do molar for simpleSol, but can do volume percent for urea, assuming the stock is 100% *)
									(* if cant convert between the units, we raise an error *)
									(* Null is replaced with targetConcentrationByDenaturationReagent just to make sure it does not fail here*)
									denatureReagentConcentrationUnitMismatch = MatchQ[Quiet[UnitConvert[QuantityUnit[denatureConcentration/. {Null:> targetConcentrationByDenaturationReagent , Automatic:> targetConcentrationByDenaturationReagent}],QuantityUnit[targetConcentrationByDenaturationReagent]]],$Failed];

									(* now figure out if we can go on despite mismatch *)
									{
										resolveableDenatureReagentConcentrationUnitMismatchQ,
										unresolveableDenatureReagentConcentrationUnitMismatchQ
									} = Which[
										(* VolumePercent is specified but reagent is Urea, can still continue, just raise warning *)
										denatureReagentConcentrationUnitMismatch && MatchQ[targetConcentrationByDenaturationReagent, ConcentrationP],
										{True, False},
										(* Molar is specified but reagent is SimpleSol (no Molar Concentration), cant continue, raise error *)
										denatureReagentConcentrationUnitMismatch && MatchQ[targetConcentrationByDenaturationReagent, VolumePercentP],
										{False, True},
										(* otherwise we're happy and can continue *)
										!denatureReagentConcentrationUnitMismatch,
										{False, False},
										True,
										{False, False}
									];

									(* now we can resolve volume and concentration according to the reagent we're using *)
									{
										resolveDenaturationReagentVolume,
										resolveDenaturationReagentTargetConcentration,
										denaturationReagentVolumeNullQ,
										denaturationReagentConcentrationNullQ
									}=If[resolveDenature&&!denaturationReagentNullQ,
										Switch[denatureVolume,
											(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
											Null,
											{Null, denatureConcentration /. Automatic :>targetConcentrationByDenaturationReagent, True, False},
											VolumeP,
											{denatureVolume, denatureConcentration /. Automatic :> (denatureVolume*denaturationReagentConcentration)/totalVolume, False, False},
											(* if volume is automatic, check the target concentration and calculate *)
											Automatic,
											Switch[denatureConcentration,
												(* if concentration is null, volume is also null *)
												Null,
												{Null, Null, False, True},
												(* volume percent input - assuming the reagent is SimpleSol and 100% *)
												VolumePercentP,
												(* if concentration is specified, calculate the volume we need for this reagent and round it *)
												If[resolveableDenatureReagentConcentrationUnitMismatchQ,
													(* if theres a mismatch in units, assume the reagent concentration is 100% *)
													{RoundOptionPrecision[totalVolume*denatureConcentration/(100VolumePercent), 10^-1 Microliter], denatureConcentration, False, False},
													(* otherwise, continue as you would *)
													{RoundOptionPrecision[totalVolume*denatureConcentration/denaturationReagentConcentration, 10^-1 Microliter], denatureConcentration, False, False}
												],
												(* concentration input by molar concentration of input, will need to check if it's  *)
												ConcentrationP,
												(* if concentration is specified, calculate the volume we need for this reagent and round it *)
												If[Not[unresolveableDenatureReagentConcentrationUnitMismatchQ],
													(* if units match, go on..  *)
													{RoundOptionPrecision[totalVolume*denatureConcentration/denaturationReagentConcentration, 10^-1 Microliter], denatureConcentration, False, False},
													(* if an unresolveable mismatch was found, return null for volume but no errors *)
													{Null, denatureConcentration, False, False }
												],
												Automatic,
												(* if both the concentration and the volume are Automatic, default concentration to targetConcentrationByDenaturationReagent and calculate accordingly *)
												{RoundOptionPrecision[totalVolume*(denatureConcentration/. Automatic :> targetConcentrationByDenaturationReagent)/denaturationReagentConcentration, 10^-1 Microliter], denatureConcentration/. Automatic :> targetConcentrationByDenaturationReagent, False, False}
											]
										],
										{denatureVolume/. Automatic:> Null, denatureConcentration/. Automatic:> Null, False, False}
									];

									(* check that the volume and concentration are in agreement*)
									denaturationReagentConcentrationVolumeMismatch = If[resolveDenature&&!NullQ[resolveDenaturationReagentVolume]&& !NullQ[resolveDenaturationReagentTargetConcentration]&&!denaturationReagentNullQ,
										Which[
											(* units are in agreement - just check that volume and concentration match *)
											!unresolveableDenatureReagentConcentrationUnitMismatchQ && !resolveableDenatureReagentConcentrationUnitMismatchQ,
											Abs[resolveDenaturationReagentVolume - (resolveDenaturationReagentTargetConcentration*totalVolume / denaturationReagentConcentration)]>1Microliter,
											(* if specified VolumePercent for reagent with molar concentration units *)
											resolveableDenatureReagentConcentrationUnitMismatchQ,
											Abs[resolveDenaturationReagentVolume - (resolveDenaturationReagentTargetConcentration*totalVolume / (100VolumePercent))]>1Microliter,
											(* if specified molar units for reagent with volumepercent units, an earlier error is thrown, don't seath it *)
											unresolveableDenatureReagentConcentrationUnitMismatchQ,
											False
										],
										False
									];

									(* Resolve AnodicSpacer *)
									anodicSpacerOptions=
										{
											IncludeAnodicSpacer,AnodicSpacer,AnodicSpacerTargetConcentration,AnodicSpacerVolume
										};

									includeAnodicSpacerBool=Map[
										MatchQ[#,Except[Automatic|Null|False]]&,
										Lookup[myMapThreadOptions,anodicSpacerOptions]
									];

									(* if the boolean is True, set IncludeAnodicSpacer as true *)
									resolveIncludeAnodicSpacer = Which[
										MatchQ[Lookup[myMapThreadOptions,IncludeAnodicSpacer],BooleanP],Lookup[myMapThreadOptions,IncludeAnodicSpacer],
										NullQ[Lookup[myMapThreadOptions,IncludeAnodicSpacer]], False,
										Or@@includeAnodicSpacerBool,True,
										True,False
									];

									(* check if IncludeAnodicSpacer is False, but relevant options have been specified *)
									anodicSpacerFalseOptionsSpecifiedQ = Not[resolveIncludeAnodicSpacer]&&Or@@includeAnodicSpacerBool;

									(* Resolve spacer *)
									resolveAnodicSpacer = If[resolveIncludeAnodicSpacer,
										If[MatchQ[Lookup[myMapThreadOptions,AnodicSpacer],Except[Automatic]],
											Lookup[myMapThreadOptions,AnodicSpacer],
											Model[Sample,StockSolution, "200mM Iminodiacetic acid"]
										],
										Lookup[myMapThreadOptions,AnodicSpacer] /. Automatic :> Null
									];

									anodicSpacerNullQ = If[resolveIncludeAnodicSpacer,
										NullQ[resolveAnodicSpacer],
										False
									];

									(* identify denaturation agent in the specified object *)
									anodicSpacerIdentity=If[resolveIncludeAnodicSpacer&&!anodicSpacerNullQ,
										Module[
											{anodicSpacerAgentPacket,anodicSpacerAgentComposition,anodicSpacerAgentCompositionIDs,
												anodicSpacerAgentCompositionPackets,identifyAnodicSpacer,ida},
											anodicSpacerAgentPacket=fetchPacketFromCache[Download[resolveAnodicSpacer,Object],optionObjectModelPackets];
											anodicSpacerAgentComposition=Lookup[anodicSpacerAgentPacket,Composition];
											(* construct list with concentration and molecule composition *)
											anodicSpacerAgentCompositionPackets=Map[
												Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
												anodicSpacerAgentComposition];
											(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
											anodicSpacerAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@anodicSpacerAgentCompositionPackets;

											(* Identifiers for simpleSol and Urea based on CAS, synonyms, and InChI *)
											{
												ida
											}={
												{"142-73-4", "Iminodiacetic acid", "Iminodiacetic Acid", "iminodiacetic acid","2,2'-azanediyldiacetic acid", "2,2'-Iminodiacetic acid", "InChI=1S/C4H7NO4/c6-3(7)1-5-2-4(8)9/h5H,1-2H2,(H,6,7)(H,8,9)", "NBZBKCUXIYYUSX-UHFFFAOYSA-N"}
											};
											(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
											(* Note - this assumes a single anodicSpacer agent in the sample; if more, user will need to specify volume *)

											identifyAnodicSpacer=Map[
												Function[compositionMolecule,
													{
														compositionMolecule[[1]] (* ObjectID *),
														compositionMolecule[[2]] (* Concentration *),
														Which[
															ContainsAny[compositionMolecule[[3]],ida],"IDA"
														]
													}
												],
												anodicSpacerAgentCompositionIDs];

											(* pick out cases where the second index in teh list is not null *)
											Cases[identifyAnodicSpacer,{ObjectP[],_,Except[NullP]}]
										],
										{}
									];

									(* check that we      know what the reagent is and what its concentration in the stock solution is *)
									noAnodicSpacerIdentifiedQ = If[resolveIncludeAnodicSpacer&&!anodicSpacerNullQ,
										Length[anodicSpacerIdentity]=!=1,
										False];

									(* grab the concentration of the identified reagent *)
									anodicSpacerConcentration =  If[resolveIncludeAnodicSpacer&&!noAnodicSpacerIdentifiedQ&&!anodicSpacerNullQ,
										anodicSpacerIdentity[[1]][[2]],
										200Millimolar
									];

									(* grab suggested concentration by anodicSpacer reagent *)
									targetConcentrationByAnodicSpacer =
										If[resolveIncludeAnodicSpacer&&!anodicSpacerNullQ&&!noAnodicSpacerIdentifiedQ,
											Switch[anodicSpacerIdentity[[1]][[3]],
												"IDA", 10Millimolar
											],
											10Millimolar
										];

									(* Grab anodicSpacer volume and concentration from options for brevity below *)
									{anodicVolume,anodicConcentration} = Lookup[myMapThreadOptions,{AnodicSpacerVolume,AnodicSpacerTargetConcentration}];

									(* now we can resolve volume and concentration according to the reagent we're using *)
									{
										resolveAnodicSpacerVolume,
										resolveAnodicSpacerTargetConcentration,
										anodicSpacerVolumeNullQ,
										anodicSpacerConcentrationNullQ
									}=If[resolveIncludeAnodicSpacer,
										Switch[anodicVolume,
											(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
											Null,
											{Null, anodicConcentration /. Automatic :>targetConcentrationByAnodicSpacer, True, False},
											VolumeP,
											{anodicVolume, anodicConcentration /. Automatic :> (anodicVolume*anodicSpacerConcentration)/totalVolume, False, False},
											(* if volume is automatic, check the target concentration and calculate *)
											Automatic,
											Switch[anodicConcentration,
												(* if concentration is null, volume is also null *)
												Null,
												{Null, Null, False, True},
												(* concentration input by molar concentration *)
												ConcentrationP,
												(* if concentration is specified, calculate the volume we need for this reagent and round it *)
												{RoundOptionPrecision[totalVolume*anodicConcentration/anodicSpacerConcentration, 10^-1 Microliter], anodicConcentration, False, False},
												Automatic,
												(* if both the concentration and the volume are Automatic, default concentration to targetConcentrationByAnodicSpacer and calculate accordingly *)
												{RoundOptionPrecision[totalVolume*(anodicConcentration/. Automatic :> targetConcentrationByAnodicSpacer)/anodicSpacerConcentration, 10^-1 Microliter], anodicConcentration/. Automatic :> targetConcentrationByAnodicSpacer, False, False}
											]
										],
										{anodicVolume/. Automatic:>Null, anodicConcentration /. Automatic :>Null, False, False}
									];

									(* check that the volume and concentration are in agreement*)
									anodicSpacerConcentrationVolumeMismatch = If[resolveIncludeAnodicSpacer&&!NullQ[resolveAnodicSpacerVolume]&& !NullQ[resolveAnodicSpacerTargetConcentration],
										resolveAnodicSpacerVolume != resolveAnodicSpacerTargetConcentration*totalVolume / anodicSpacerConcentration,
										False
									];

									(* Resolve CathodicSpacer *)
									cathodicSpacerOptions=
										{
											IncludeCathodicSpacer,CathodicSpacer,CathodicSpacerTargetConcentration,CathodicSpacerVolume
										};

									includeCathodicSpacerBool=Map[
										MatchQ[#,Except[Automatic|Null|False]]&,
										Lookup[myMapThreadOptions,cathodicSpacerOptions]
									];

									(* if the boolean is True, set IncludeCathodicSpacer as true *)
									resolveIncludeCathodicSpacer = Which[
										MatchQ[Lookup[myMapThreadOptions,IncludeCathodicSpacer],BooleanP],Lookup[myMapThreadOptions,IncludeCathodicSpacer],
										NullQ[Lookup[myMapThreadOptions,IncludeCathodicSpacer]], False,
										Or@@includeCathodicSpacerBool,True,
										True,False
									];

									(* check if IncludeAnodicSpacer is False, but relevant options have been specified *)
									cathodicSpacerFalseOptionsSpecifiedQ = Not[resolveIncludeCathodicSpacer]&&Or@@includeCathodicSpacerBool;

									(* Resolve spacer *)
									resolveCathodicSpacer = If[resolveIncludeCathodicSpacer,
										If[MatchQ[Lookup[myMapThreadOptions,CathodicSpacer],Except[Automatic]],
											Lookup[myMapThreadOptions,CathodicSpacer],
											Model[Sample,StockSolution, "500mM Arginine"]
										],
										Lookup[myMapThreadOptions,CathodicSpacer] /. Automatic :> Null
									];

									cathodicSpacerNullQ = If[resolveIncludeCathodicSpacer,
										NullQ[resolveCathodicSpacer],
										False
									];

									(* identify denaturation agent in the specified object *)
									cathodicSpacerIdentity=If[resolveIncludeCathodicSpacer&&!cathodicSpacerNullQ,
										Module[
											{cathodicSpacerAgentPacket,cathodicSpacerAgentComposition,cathodicSpacerAgentCompositionIDs,
												cathodicSpacerAgentCompositionPackets,identifyCathodicSpacer,arg},
											cathodicSpacerAgentPacket=fetchPacketFromCache[Download[resolveCathodicSpacer,Object],optionObjectModelPackets];
											cathodicSpacerAgentComposition=Lookup[cathodicSpacerAgentPacket,Composition];
											(* construct list with concentration and molecule composition *)
											cathodicSpacerAgentCompositionPackets=Map[
												Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
												cathodicSpacerAgentComposition];
											(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
											cathodicSpacerAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@cathodicSpacerAgentCompositionPackets;

											(* Identifiers for simpleSol and Urea based on CAS, synonyms, and InChI *)
											{
												arg
											}={
												{"74-79-3", "L-Arginine", "Arginine", "L-arginine", "arginine", "InChI=1S/C6H14N4O2/c7-4(5(11)12)2-1-3-10-6(8)9/h4H,1-3,7H2,(H,11,12)(H4,8,9,10)/t4-/m0/s1", "ODKSFYDXXFIFQN-BYPYZUCNSA-N"}
											};
											(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
											(* Note - this assumes a single cathodicSpacer agent in the sample; if more, user will need to specify volume *)

											identifyCathodicSpacer=Map[
												Function[compositionMolecule,
													{
														compositionMolecule[[1]] (* ObjectID *),
														compositionMolecule[[2]] (* Concentration *),
														Which[
															ContainsAny[compositionMolecule[[3]],arg],"Arg"
														]
													}
												],
												cathodicSpacerAgentCompositionIDs];

											(* pick out cases where the second index in teh list is not null *)
											Cases[identifyCathodicSpacer,{ObjectP[],_,Except[NullP]}]
										],
										{}
									];

									(* check that we      know what the reagent is and what its concentration in the stock solution is *)
									noCathodicSpacerIdentifiedQ = If[resolveIncludeCathodicSpacer&&!cathodicSpacerNullQ,
										Length[cathodicSpacerIdentity]=!=1,
										False];

									(* grab the concentration of the identified denaturation reagent *)
									cathodicSpacerConcentration =  If[resolveIncludeCathodicSpacer&&!cathodicSpacerNullQ&&!noCathodicSpacerIdentifiedQ,
										cathodicSpacerIdentity[[1]][[2]],
										500Millimolar
									];

									(* grab suggested concentration by denaturation reagent *)
									targetConcentrationByCathodicSpacer =
										If[resolveIncludeCathodicSpacer&&!cathodicSpacerNullQ&&!noCathodicSpacerIdentifiedQ,
											Switch[cathodicSpacerIdentity[[1]][[3]],
												"Arg", 10Millimolar
											],
											10Millimolar
										];

									(* Grab cathodicSpacer volume and concentration from options for brevity below *)
									{cathodicVolume,cathodicConcentration} = Lookup[myMapThreadOptions,{CathodicSpacerVolume,CathodicSpacerTargetConcentration}];

									(* now we can resolve volume and concentration according to the reagent we're using *)
									{
										resolveCathodicSpacerVolume,
										resolveCathodicSpacerTargetConcentration,
										cathodicSpacerVolumeNullQ,
										cathodicSpacerConcentrationNullQ
									}=If[resolveIncludeCathodicSpacer,
										Switch[cathodicVolume,
											(* if volume is defined, return it and whatever the concentration is (we'll check that they are copacetic in a bit *)
											Null,
											{Null, cathodicConcentration /. Automatic :>targetConcentrationByCathodicSpacer, True, False},
											VolumeP,
											{cathodicVolume, cathodicConcentration /. Automatic :> (cathodicVolume*cathodicSpacerConcentration)/totalVolume, False, False},
											(* if volume is automatic, check the target concentration and calculate *)
											Automatic,
											Switch[cathodicConcentration,
												(* if concentration is null, volume is also null *)
												Null,
												{Null, Null, False, True},
												(* concentration input by molar concentration *)
												ConcentrationP,
												(* if concentration is specified, calculate the volume we need for this reagent and round it *)
												{RoundOptionPrecision[totalVolume*cathodicConcentration/cathodicSpacerConcentration, 10^-1 Microliter], cathodicConcentration, False, False},
												Automatic,
												(* if both the concentration and the volume are Automatic, default concentration to targetConcentrationByCathodicSpacer and calculate accordingly *)
												{RoundOptionPrecision[totalVolume*(cathodicConcentration/. Automatic :> targetConcentrationByCathodicSpacer)/cathodicSpacerConcentration, 10^-1 Microliter], cathodicConcentration/. Automatic :> targetConcentrationByCathodicSpacer, False, False}
											]
										],
										{cathodicVolume/. Automatic:>Null, cathodicConcentration /. Automatic :>Null, False, False}
									];

									(* check that the volume and concentration are in agreement*)
									cathodicSpacerConcentrationVolumeMismatch = If[resolveIncludeCathodicSpacer&&!NullQ[resolveCathodicSpacerVolume]&& !NullQ[resolveCathodicSpacerTargetConcentration],
										resolveCathodicSpacerVolume != resolveCathodicSpacerTargetConcentration*totalVolume / cathodicSpacerConcentration,
										False
									];


									(* resolve diluent *)
									(* check volumes to make sure everything fits in the assay tube *)
									volumeLeft=RoundOptionPrecision[totalVolume-Total[Flatten[
										ReplaceAll[{sampleVolume,resolveAmpholyteVolume,resolveIsoelectricPointMarkersVolume,
											resolveElectroosmoticFlowBlockerVolume,resolveDenaturationReagentVolume,
											resolveAnodicSpacerVolume,resolveCathodicSpacerVolume},Null->0Microliter]
									]],
										10^-1 Microliter];

									(* diluent is required only if we there's volume we need to top off to get to totalVolume *)
									{
										resolveDiluent,
										nullDiluentQ,
										sumOfVolumesOverTotalvolumeQ
									}=Which[
										(* sum of volumes is exactly the total volume, no need for a dilutent  *)
										volumeLeft == 0Microliter,
										{
											Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null,
											False,
											False
										},
										(* sum of volumes is less than totalVolume, check if there's a diluent defines, if not raise error *)
										volumeLeft > 0Microliter,
										{
											Lookup[myMapThreadOptions,Diluent]/.Automatic:>Model[Sample, "LCMS Grade Water"],
											NullQ[Lookup[myMapThreadOptions,Diluent]/.Automatic:>Model[Sample, "LCMS Grade Water"]],
											False
										},
										volumeLeft < 0Microliter,
										{
											Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null,
											False,
											True
										}
									];

									(* gather resolved options and errors to return *)
									{
										(* PremadeMasterMix branch's options as Null *)
										Lookup[myMapThreadOptions,PremadeMasterMixReagent]/.Automatic:>Null,
										Lookup[myMapThreadOptions,PremadeMasterMixVolume]/.Automatic:>Null,
										Lookup[myMapThreadOptions,PremadeMasterMixReagentDilutionFactor]/.Automatic:>Null,
										Lookup[myMapThreadOptions,PremadeMasterMixDiluent]/.Automatic:>Null,
										(* PremadeMasterMix branch's errors as False *)
										False,(* masterMixNullError *)
										False,(* masterMixDilutionFactorNullError *)
										False,(* masterMixVolumeNullError *)
										False,(* masterMixVolumeDilutionFactorMismatchWarning *)
										False,(* masterMixTotalVolumeError *)
										False,(* masterMixDiluentNullError *)
										(* make-your-own mix branch's options *)
										resolveDiluent,
										resolveAmpholytes,
										resolveAmpholyteTargetConcentration,
										resolveAmpholyteVolume,
										resolveIsoelectricPointMarkers,
										resolveIsoelectricPointMarkersTargetConcentrations,
										resolveIsoelectricPointMarkersVolume,
										resolveAmpholyteStorageCondition,
										resolveIsoelectricPointMarkersStorageCondition,
										resolveElectroosmoticFlowBlocker,
										resolveElectroosmoticFlowBlockerTargetConcentration,
										resolveElectroosmoticFlowBlockerVolume,
										resolveDenature,
										resolveDenaturationReagent,
										resolveDenaturationReagentTargetConcentration,
										resolveDenaturationReagentVolume,
										resolveIncludeAnodicSpacer,
										resolveAnodicSpacer,
										resolveAnodicSpacerTargetConcentration,
										resolveAnodicSpacerVolume,
										resolveIncludeCathodicSpacer,
										resolveCathodicSpacer,
										resolveCathodicSpacerTargetConcentration,
										resolveCathodicSpacerVolume,
										(* make-your-own mix branch's errors - remember to add Or@@ on error checking from nested indexMatched options *)
										nullDiluentQ,
										NoSpecifiedAmpholytesQ,
										Or@@ampholyteMatchedlengthsNotCopaceticQ,
										Or@@ampholyteVolumeNullQ,
										Or@@ampholyteConcentrationNullQ,
										Or@@ampholyteVolumeConcentrationMismatchQ,
										NoSpecifiedIsoelectricPointMarkersQ,
										resolverCantFixIsoelectricPointMarkersMismatchQ,
										Or@@isoelectricPointMarkersVolumeNullQ,
										Or@@isoelectricPointMarkersConcentrationNullQ,
										Or@@isoelectricPointMarkersVolumeConcentrationMismatchQ,
										electroosmoticFlowBlockerNullQ,
										noElectroosmoticFlowBlockerAgentIdentifiedQ,
										electroosmoticFlowBlockerVolumeNullQ,
										electroosmoticFlowBlockerConcentrationNullQ,
										eofBlockerVolumeConcentrationMismatchQ,
										denatureFalseOptionsSpecifiedQ,
										denaturationReagentNullQ,
										noDenaturationReagentIdentifiedQ,
										resolveableDenatureReagentConcentrationUnitMismatchQ,
										unresolveableDenatureReagentConcentrationUnitMismatchQ,
										denaturationReagentVolumeNullQ,
										denaturationReagentConcentrationNullQ,
										denaturationReagentConcentrationVolumeMismatch,
										anodicSpacerFalseOptionsSpecifiedQ,
										anodicSpacerNullQ,
										noAnodicSpacerIdentifiedQ,
										anodicSpacerVolumeNullQ,
										anodicSpacerConcentrationNullQ,
										anodicSpacerConcentrationVolumeMismatch,
										cathodicSpacerFalseOptionsSpecifiedQ,
										cathodicSpacerNullQ,
										noCathodicSpacerIdentifiedQ,
										cathodicSpacerVolumeNullQ,
										cathodicSpacerConcentrationNullQ,
										cathodicSpacerConcentrationVolumeMismatch,
										sumOfVolumesOverTotalvolumeQ
									}
								]
							];

							(* Gather MapThread results *)
							{
								(* General options variables *)
								totalVolume,
								sampleVolume,
								sampleFrequency,
								loadTime,
								voltageDurationProfile,
								imagingMethods,
								nativeFluorescenceExposureTime,
								(* General options errors *)
								nullTotalVolumeError,
								nullFrequencyError,
								missingSampleCompositionWarning,
								OnBoardMixingIncompatibleVolumesError,
								imagingMismatchError,
								voltageDurationStepError,
								loadTimeNullError,
								(* premade mastermix branch variables *)
								resolvePremadeMasterMix,
								premadeMasterMixReagent,
								premadeMasterMixVolume,
								premadeMasterMixDilutionFactor,
								premadeMasterMixDiluent,
								(* premade mastermix branch errors *)
								premadeMastermixFalseOptionsSpecifiedError,
								premadeMasterMixNullError,
								premadeMasterMixDilutionFactorNullError,
								premadeMasterMixVolumeNullError,
								premadeMasterMixVolumeDilutionFactorMismatchWarning,
								premadeMasterMixTotalVolumeError,
								premadeMasterMixDiluentNullError,
								(* make-ones-own mastermix branch variables *)
								diluent,
								ampholytes,
								ampholyteTargetConcentrations,
								ampholyteVolume,
								isoelectricPointMarkers,
								isoelectricPointMarkersTargetConcentrations,
								isoelectricPointMarkersVolume,
								ampholyteStorageCondition,
								isoelectricPointMarkerStorageCondition,
								electroosmoticFlowBlocker,
								electroosmoticFlowBlockerTargetConcentrations,
								electroosmoticFlowBlockerVolume,
								denature,
								denaturationReagent,
								denaturationReagentTargetConcentration,
								denaturationReagentVolume,
								includeAnodicSpacer,
								anodicSpacer,
								anodicSpacerTargetConcentration,
								anodicSpacerVolume,
								includeCathodicSpacer,
								cathodicSpacer,
								cathodicSpacerTargetConcentration,
								cathodicSpacerVolume,
								(* make-ones-own mastermix branch errors *)
								nullDiluentError,
								noSpecifiedAmpholytesError,
								ampholyteMatchedlengthsNotCopaceticError,
								ampholyteVolumeNullError,
								ampholyteConcentrationNullError,
								ampholyteVolumeConcentrationMismatchError,
								NoSpecifiedIsoelectricPointMarkersError,
								resolverCantFixIsoelectricPointMarkersMismatchError,
								isoelectricPointMarkersVolumeNullError,
								isoelectricPointMarkersConcentrationNullError,
								isoelectricPointMarkersVolumeConcentrationMismatchError,
								electroosmoticFlowBlockerNullError,
								noElectroosmoticFlowBlockerAgentIdentifiedWarning,
								electroosmoticFlowBlockerVolumeNullError,
								electroosmoticFlowBlockerConcentrationNullError,
								eofBlockerVolumeConcentrationMismatchError,
								denatureFalseOptionsSpecifiedError,
								denaturationReagentNullError,
								noDenaturationReagentIdentifiedError,
								resolveableDenatureReagentConcentrationUnitMismatchError,
								unresolveableDenatureReagentConcentrationUnitMismatchError,
								denaturationReagentVolumeNullError,
								denaturationReagentConcentrationNullError,
								denaturationReagentConcentrationVolumeMismatchError,
								anodicSpacerFalseOptionsSpecifiedError,
								anodicSpacerNullError,
								noAnodicSpacerIdentifiedError,
								anodicSpacerVolumeNullError,
								anodicSpacerConcentrationNullError,
								anodicSpacerConcentrationVolumeMismatchError,
								cathodicSpacerFalseOptionsSpecifiedError,
								cathodicSpacerNullError,
								noCathodicSpacerIdentifiedError,
								cathodicSpacerVolumeNullError,
								cathodicSpacerConcentrationNullError,
								cathodicSpacerConcentrationVolumeMismatchError,
								sumOfVolumesOverTotalvolumeError
							}
						]
					],
					{
						currentSamples,
						mapThreadFriendlyOptionsLocal,
						injectionTableVolumes
					}
				]
			]
		]],
			{
				{resolveIncludeStandards,resolvedStandardsPackets,mapThreadFriendlyStandardOptions,roundedInjectionTableStandardVolumes},
				{resolveIncludeBlanks,resolvedBlanksPackets,mapThreadFriendlyBlankOptions,roundedInjectionTableBlankVolumes}
			}
		];

		(* resolve InjectionTable *)
		(* If there is a user specified injection table, check if there is agreement between samples on the injection list and in options,
		if not, dont bother trying to populate volumes, we're raising an error a bit later *)

		injectionTableContainsAllQ=If[MatchQ[specifiedInjectionTable,Except[Automatic]],
			Not[Or@@{
				injectionTableSamplesNotCopaceticQ,
				injectionTableStandardNotCopaceticQ,
				injectionTableBlankNotCopaceticQ
			}],
			True
		];

		(* generate an injection Table based on samples, blanks, and standards *)
		(* The injection table is a little tricky since we need to figure out if we need to aliquot and consolidate aliquots *)
		(* Resolve RequiredAliquotContainers *)
		(* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
		(* samples will be transferred to a 96 well plate anyways, so we dont need to worry about it here too much, unless they are in a container that's not liquid handler compatible *)
		hamiltonCompatibleContainers=Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling];

		(* When you do not want an aliquot to happen for the corresponding simulated sample, make the corresponding index of targetContainers Null. *)
		(* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)
		targetContainers=MapThread[Function[{container,volume},
			If[
				MatchQ[Download[container,Object], ObjectP[hamiltonCompatibleContainers]],
				Null,
				PreferredContainer[volume, LiquidHandlerCompatible -> True]
			]
		],
			{Lookup[simulatedSampleContainerPackets, Model],SafeRound[resolvedSampleVolume*1.1,10^-1 Microliter]}
		];

		(* If we have a target container, we are aliquoting, if not, we are not *)
		aliquotBools=!NullQ[#]&/@targetContainers;

		(* Since we're going to take a small sample from the aliquots to spot onto the plate, no need for them to be in separate containers *)
		suppliedConsolidation=Lookup[myOptions,ConsolidateAliquots,Null];
		resolvedConsolidation=If[MatchQ[suppliedConsolidation,Automatic]&&MemberQ[targetContainers,Except[Null]],
			True,
			suppliedConsolidation
		];
		resolvedInjectionTable=If[MatchQ[Lookup[roundedCapillaryIsoelectricFocusingOptions,InjectionTable],Automatic],
			Module[{samplesInjectionTable,blanksInjectionTable,replicates,restructuredSamplesList},
				(* add Sample type and repeat as NumberOfReplicates *)
				replicates = Lookup[roundedCapillaryIsoelectricFocusingOptions,NumberOfReplicates]/.Null:>1;
				(* Replicates are repeated injections from the same vial, and thus, do Not require any sample and volume should be 0 Microliter *)
				samplesInjectionTable=MapThread[
					Function[{object,volume,aliquotBool,index},
						Which[
							(* Case 1 - No Aliquoting required *)
							!aliquotBool,
							(* all follow-up replicates are 0 uL *)
							Flatten[{{Sample,object,volume,index},ConstantArray[{Sample,object,0Microliter,index},replicates-1]}],
							(* Case 2 - Aliquoting into consolidated container. Basically similar to no aliquoting case for replicates *)
							aliquotBool&&resolvedConsolidation,
							Flatten[{{Sample,object,volume,index},ConstantArray[{Sample,object,0Microliter,index},replicates-1]}],
							(* Case 3 - Aliquoting into different containers, we must do amount for each sample *)
							True,
							Flatten[ConstantArray[{Sample,object,volume,index},replicates]]

						]],
					{mySamples,resolvedSampleVolume,aliquotBools, Range[Length[mySamples]]}];
				restructuredSamplesList=TakeList[Flatten[samplesInjectionTable],
					ConstantArray[4,Length[Flatten[samplesInjectionTable]]/4]];
				(* resolve blanks and standards, in this order. *)
				blanksInjectionTable=Experiment`Private`populateInjectionTable[
					Blank,
					resolvedBlanks/.Null:>{},
					resolvedBlankVolume/.Null:>{},
					restructuredSamplesList,
					resolveIncludeBlanks,
					(* to avoid errors later on, if blank frequency is Null, replace with 1, an error will come up later *)
					ToList[resolvedBlankFrequency/.Null:>1],1];
				Experiment`Private`populateInjectionTable[
					Standard,
					resolvedStandards/.Null:>{},
					resolvedStandardVolume/.Null:>{},
					blanksInjectionTable,
					resolveIncludeStandards,
					(* to avoid errors later on, if standard frequency is Null, replace with 1, an error will come up later *)
					ToList[resolvedStandardFrequency/.Null:>1],1]
				],
			(* If there is a user specified injection table, check if there is agreement between samples on the injection
			list and in options, if not, dont bother trying to populate volumes *)
			(* if an injection table has been specified, we still need to make sure it has all the right volumes. *)
			(* But first we need to populate the sampleIndex, we can do this by their order *)
			Module[{indexedInjectionTable,sampleInjectionPositions,updatedSampleTuples,
				standardInjectionPositions,updatedStandardTuples,blankInjectionPositions,updatedBlankTuples},

				indexedInjectionTable = Lookup[roundedCapillaryIsoelectricFocusingOptions,InjectionTable];

				(*for all the sample positions. should be directly index matched to the input samples*)
				sampleInjectionPositions=Flatten@Position[indexedInjectionTable[[All,1]],Sample];

				(*update the tuples with the index information*)
				updatedSampleTuples =MapThread[Append[#1,#2]&,{indexedInjectionTable[[sampleInjectionPositions]],Range[Length[sampleInjectionPositions]]}];
				indexedInjectionTable[[sampleInjectionPositions]]=updatedSampleTuples;

				(*for all the standard positions. should be directly index matched to the input samples*)
				standardInjectionPositions=Flatten@Position[indexedInjectionTable[[All,1]],Standard];

				(*update the tuples with the index information*)
				updatedStandardTuples =	MapThread[Append[#1,#2]&,{indexedInjectionTable[[standardInjectionPositions]],Range[Length[standardInjectionPositions]]}];
				indexedInjectionTable[[standardInjectionPositions]]=updatedStandardTuples;

				(*for all the standard positions. should be directly index matched to the input samples*)
				blankInjectionPositions= Flatten@Position[indexedInjectionTable[[All,1]],Blank];

				(*update the tuples with the index information*)
				updatedBlankTuples = MapThread[Append[#1,#2]&,{indexedInjectionTable[[blankInjectionPositions]],Range[Length[blankInjectionPositions]]}];
				indexedInjectionTable[[blankInjectionPositions]]=updatedBlankTuples;

				If[injectionTableContainsAllQ&&injectionTableValidQ,
					replaceAutomaticVolumes[
						indexedInjectionTable,
						{},
						resolvedSampleVolume,
						resolvedStandardVolume/.Null:>{},
						resolvedBlankVolume/.Null:>{},
						{}
					],
					indexedInjectionTable
				]
			]
		];

		(*-- CONFLICTING OPTIONS CHECKS --*)

		(* Invalid Name *)
		(* If the Name is not in the database, it is valid *)
		validNameQ=If[MatchQ[Lookup[roundedCapillaryIsoelectricFocusingOptions,Name],_String],
			Not[DatabaseMemberQ[Object[Protocol,CapillaryIsoelectricFocusing,Lookup[roundedCapillaryIsoelectricFocusingOptions,Name]]]],
			True
		];

		(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
		nameInvalidOptions=If[Not[validNameQ]&&messages,
			(
				Message[Error::DuplicateName,"CapillaryIsoelectricFocusing protocol"];
				{Name}
			),
			{}
		];

		(* Generate Test for Name check *)
		validNameTest=If[gatherTests&&MatchQ[Lookup[roundedCapillaryIsoelectricFocusingOptions,Name],_String],
			Test["If specified, Name is not already a CapillaryIsoelectricFocusing object name:",
				validNameQ,
				True
			],
			Null
		];

		(* TooManySamples *)
		(* Count the number of sample * NumberOfReplicates + number of Standards*Frequency + number of Blanks*Frequency *)

		(* calculate the total number of injections for standards, based on Frequency, raise an error if number is over
		100, or 96 if OnBoardMixing is used. *)

		sampleCountQ=If[Lookup[roundedCapillaryIsoelectricFocusingOptions,OnBoardMixing],
			Length[resolvedInjectionTable]>96,
			Length[resolvedInjectionTable]>100
		];

		(* if sampleCountQ is True AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {injectionCount}; otherwise, {} is fine *)
		sampleCountInvalidOption=If[sampleCountQ&&messages,
			(
				Message[Error::TooManyInjectionsCapillaryIsoelectricFocusing,Length[resolvedInjectionTable]];
				{Blanks, Standards, NumberOfReplicates,BlankFrequency,StandardFrequency}
			),
			{}
		];

		(* Generate Test for sampleCount check *)
		sampleCountTest=If[gatherTests,
			Test["The total number of injections specified for samples, blanks, and standards can be run in a single batch:",
				sampleCountQ,
				False
			],
			Null
		];

		(** number of uses check **)
		(* If Object is set, get NumberOfUses and calculate uses left, if Model, return MaxNumberOfUses *)
		usesLeftOnCartridge=Switch[Lookup[cartridgePacket,Object],
			(* if object, grab numberOfUses *)
			ObjectP[Object[Container,ProteinCapillaryElectrophoresisCartridge]],
			(Lookup[cartridgeModelPacket,MaxNumberOfUses,200])-(Lookup[cartridgePacket,NumberOfUses,0]),
			(* if Model, grab MaxNumberOfUses *)
			ObjectP[Model[Container,ProteinCapillaryElectrophoresisCartridge]],
			Lookup[cartridgeModelPacket,MaxNumberOfUses,200]
		];

		notEnoughUsesLeftQ = usesLeftOnCartridge<Length[resolvedInjectionTable];

		notEnoughUsesLeftOption=If[notEnoughUsesLeftQ&&!sampleCountQ&&!engineQ,
			(
				Message[Error::NotEnoughUsesLeftOnCIEFCartridge,ObjectToString[Lookup[cartridgePacket,Object],Cache->inheritedCache],usesLeftOnCartridge];
				{Cartridge}
			),
			{}
		];

		(* If we need to gather tests, generate the tests for cartridge check *)
		notEnoughUsesLeftOptionTest=If[gatherTests,
			Test["The number of injections in this protocol does not exceed the total number of uses left on the chosen cartridge:",
				notEnoughUsesLeftQ&&!sampleCountQ,
				False
			],
			Nothing
		];

		(* beyond optimal number of uses - MaxInjections is the maximum number of injections under optimal conditoins *)
		optimalUsesLeftOnCartridge=Switch[Lookup[cartridgePacket,Object],
			(* if object, grab numberOfUses *)
			ObjectP[Object[Container,ProteinCapillaryElectrophoresisCartridge]],
			Lookup[cartridgeModelPacket,OptimalMaxInjections,100]-Lookup[cartridgePacket,NumberOfUses,0],
			(* if Model, grab MaxNumberOfUses *)
			ObjectP[Model[Container,ProteinCapillaryElectrophoresisCartridge]],
			Lookup[cartridgeModelPacket,OptimalMaxInjections,100]
		];

		(* make sure not to raise both this warning and the previous error *)
		notEnoughOptimalUsesLeftOption=If[optimalUsesLeftOnCartridge<Length[resolvedInjectionTable]&&!engineQ&&!notEnoughUsesLeftQ&&!sampleCountQ,
			(
				Message[Warning::NotEnoughOptimalUsesLeftOnCIEFCartridge,ObjectToString[Lookup[cartridgePacket,Object],Cache->inheritedCache],optimalUsesLeftOnCartridge];
				{Cartridge}
			),
			{}
		];

		(* If we need to gather tests, generate the tests for cartridge check *)
		notEnoughOptimalUsesLeftOptionTest=If[gatherTests,
			Warning["The number of injections in this protocol does not exceed the number of optimal uses left on the chosen cartridge:",
				optimalUsesLeftOnCartridge>Length[resolvedInjectionTable]&&!notEnoughUsesLeftQ&&!sampleCountQ,
				True
			],
			Nothing
		];

		(* InjectionTable Missing Samples *)
		(* check that the injection table contains all samples, blanks, and standards *)
		samplesMissingFromInjectionTables=If[injectionTableContainsAllQ,
			{},
			Join[
				Complement[resolvedInjectionTable[[All,2]],Cases[Flatten[Join[simulatedSamples,{resolvedStandards},{resolvedBlanks}]],ObjectP[]]],
				Complement[Cases[Flatten[Join[simulatedSamples,{resolvedStandards},{resolvedBlanks}]],ObjectP[]],resolvedInjectionTable[[All,2]]]
			]
		];

		(* if injectionTableContainsAllQ is True AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Length[resolvedInjectionTable]}; otherwise, {} is fine *)
		invalidInjectionTableOption=If[!injectionTableContainsAllQ&&messages,
			(
				Message[Error::CIEFInjectionTableMismatch,samplesMissingFromInjectionTables];
				{InjectionTable}
			),
			{}
		];

		invalidInjectionTableTest=If[gatherTests,
			(* We're gathering tests. Create the appropriate tests. *)
			Module[{passingInputs,passingInputsTest,failingInputsTest},
				(* Get the inputs that pass this test. *)
				passingInputs=DeleteDuplicates[resolvedInjectionTable];

				(* Create a test for the passing inputs. *)
				passingInputsTest=If[injectionTableContainsAllQ,
					Test["The injection table contains all samples specified in inputs and options ("<>ObjectToString[passingInputs,Cache->inheritedCache]<>"):",True,True],
					Nothing
				];

				(* Create a test for the non-passing inputs. *)
				failingInputsTest=If[!injectionTableContainsAllQ,
					Test["The injection table contains all samples specified in inputs and options ("<>ObjectToString[samplesMissingFromInjectionTables,Cache->inheritedCache]<>"):",True,Fa;se],
					Nothing
				];

				(* Return our created tests. *)
				{
					passingInputsTest,
					failingInputsTest
				}
			],
			(* We aren't gathering tests. No tests to create. *)
			{}
		];

		premadeMasterMixOptions={
			PremadeMasterMix,PremadeMasterMixReagent,PremadeMasterMixDiluent,PremadeMasterMixReagentDilutionFactor,
			PremadeMasterMixVolume
		};
		makeOnesOwnMasterMixOptions={
			Diluent,Ampholytes,AmpholyteTargetConcentrations,AmpholyteVolume,IsoelectricPointMarkers,IsoelectricPointMarkersTargetConcentrations,
			IsoelectricPointMarkersVolume,ElectroosmoticFlowBlocker,ElectroosmoticFlowBlockerTargetConcentrations,ElectroosmoticFlowBlockerVolume,
			Denature,DenaturationReagent,DenaturationReagentTargetConcentration,DenaturationReagentVolume,IncludeAnodicSpacer,
			AnodicSpacer,AnodicSpacerTargetConcentration,AnodicSpacerVolume,IncludeCathodicSpacer,CathodicSpacer,
			CathodicSpacerTargetConcentration,CathodicSpacerVolume
		};

		(* PremadeMasterMix True but other branch's options are specified *)
		(* For each sample, check if options are different from default or null *);
		samplesMakeMasterMixOptionsSetBool=
			Map[Function[{preSampleOptions},
				Map[MatchQ[Lookup[preSampleOptions,#],Except[getDefault[#,opsDef]|Automatic|Null|False|{Automatic..}|{Null..}]]&,
					makeOnesOwnMasterMixOptions]],
				mapThreadFriendlyOptions];

		(* Check which samples are true for both *)
		premadeMasterMixWithmakeMasterMixOptionsSetQ=MapThread[
			And[MatchQ[#1,True],Or@@#2]&,
			{resolvedPremadeMasterMix, samplesMakeMasterMixOptionsSetBool}];


		standardMakeMasterMixOptionsSetBool=If[resolveIncludeStandards,
			Map[Function[{perStandardOptions},
				Map[MatchQ[Lookup[perStandardOptions,#],Except[getDefault[#,opsDef]|Automatic|Null|False|{Automatic..}|{Null..}]]&,
					makeOnesOwnMasterMixOptions]],
				mapThreadFriendlyStandardOptions],
			False];

		(* Check which standards are true for both *)
		standardPremadeMasterMixWithmakeMasterMixOptionsSetQ=If[resolveIncludeStandards,
			MapThread[
				And[MatchQ[#1,True],Or@@#2]&,
				{resolvedStandardPremadeMasterMix, standardMakeMasterMixOptionsSetBool}],
			False];

		blankMakeMasterMixOptionsSetBool=If[resolveIncludeBlanks,
			Map[Function[{perBlankOptions},
				Map[MatchQ[Lookup[perBlankOptions,#],Except[getDefault[#,opsDef]|Automatic|Null|False|{Automatic..}|{Null..}]]&,
					makeOnesOwnMasterMixOptions]],
				mapThreadFriendlyBlankOptions],
			False];

		(* Check which samples are true for both *)
		blankPremadeMasterMixWithmakeMasterMixOptionsSetQ=If[resolveIncludeBlanks,
			MapThread[
				And[MatchQ[#1,True],Or@@#2]&,
				{resolvedBlankPremadeMasterMix, blankMakeMasterMixOptionsSetBool}],
			False];

		(* Grab the options that are indeed invalid between the different samples groups *)
		preMadeMasterMixWithMakeOwnInvalidOptions = PickList[
			{PremadeMasterMix,StandardPremadeMasterMix,BlankPremadeMasterMix},
			{
				Or@@premadeMasterMixWithmakeMasterMixOptionsSetQ,
				Or@@standardPremadeMasterMixWithmakeMasterMixOptionsSetQ,
				Or@@blankPremadeMasterMixWithmakeMasterMixOptionsSetQ
			}
		];

		preMadeMasterMixWithMakeOwnInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixWithmakeMasterMixOptionsSetQ]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixWithmakeMasterMixOptionsSetQ]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixWithmakeMasterMixOptionsSetQ]],Cache->inheritedCache]
		}];

		(* if indeed PremadeMasterMix is true and other options are set, raise warning.*)
		premadeMasterMixWithmakeMasterMixOptionsSetInvalidOption=If[Length[preMadeMasterMixWithMakeOwnInvalidOptions]>0&&!engineQ,
			(
				Message[Warning::CIEFPreMadeMasterMixWithMakeOwnOptions,preMadeMasterMixWithMakeOwnInvalidSamples];
				preMadeMasterMixWithMakeOwnInvalidOptions
			),
			{}
		];

		premadeMasterMixWithmakeMasterMixOptionsSetInvalidOptionTest=If[gatherTests,
			Warning["If Options for PremadeMasterMix are specified, no options are set for making master mix:",
				Length[preMadeMasterMixWithMakeOwnInvalidOptions]>0,
				False
			],
			Nothing
		];


		(*-- UNRESOLVABLE OPTION CHECKS --*)

		(* nullTotalVolumeErrors - raise warning if no composition is found and SampleVolume is automatic  *)
		(* Grab the options that are indeed invalid between the different samples groups *)
		nullTotalVolumeErrorsOptions = PickList[
			{StandardTotalVolume, BlankTotalVolume},
			{
				Or@@standardNullTotalVolumeErrors,
				Or@@blankNullTotalVolumeErrors
			}
		];

		nullTotalVolumeErrorsSamples =combineObjectStrings[{
			ObjectToString[{}],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNullTotalVolumeErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNullTotalVolumeErrors]],Cache->inheritedCache]
		}];

		If[Length[nullTotalVolumeErrorsOptions]>0&&messages&&Not[engineQ],
			(
				Message[Error::CIEFTotalVolumeNull,nullTotalVolumeErrorsSamples];
				{nullTotalVolumeErrorsOptions}
			),
			{}
		];

		nullTotalVolumeErrorsTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[resolvedStandards],ToList[standardNullTotalVolumeErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankNullTotalVolumeErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[{}],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNullTotalVolumeErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNullTotalVolumeErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[resolvedStandards],ToList[standardNullTotalVolumeErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankNullTotalVolumeErrors],False]
				];

				passingString =combineObjectStrings[{
					ObjectToString[{}],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNullTotalVolumeErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNullTotalVolumeErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the specified TotalVolume is valid:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the specified TotalVolume is valid:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];
		(* not raising MissingSampleCompositionWarnings for samples, since by they cant have a Null *)

		(* nullTotalVolumeErrors - raise warning if no composition is found and SampleVolume is automatic  *)
		(* Grab the options that are indeed invalid between the different samples groups *)
		includeTrueFrequencyNullOptions = PickList[
			{
				{IncludeStandards,StandardFrequency},
				{IncludeBlanks,BlankFrequency}
			},
			{
				Or@@standardTrueFrequencyNullErrors,
				Or@@blankTrueFrequencyNullErrors
			}
		];

		includeTrueFrequencyNullErrorsSamples =combineObjectStrings[{
			ObjectToString[{}],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardTrueFrequencyNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankTrueFrequencyNullErrors]],Cache->inheritedCache]
		}];

		If[Length[includeTrueFrequencyNullOptions]>0&&messages&&Not[engineQ],
			(
				Message[Error::CIEFIncludeTrueFrequencyNullError,ToString@includeTrueFrequencyNullOptions[[All,1]], ToString@includeTrueFrequencyNullOptions[[All,2]],includeTrueFrequencyNullErrorsSamples];
				{includeTrueFrequencyNullOptions}
			),
			{}
		];

		includeTrueFrequencyNullErrorsTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[resolvedStandards],ToList[standardTrueFrequencyNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankTrueFrequencyNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[{}],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardTrueFrequencyNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankTrueFrequencyNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[resolvedStandards],ToList[standardTrueFrequencyNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankTrueFrequencyNullErrors],False]
				];

				passingString =combineObjectStrings[{
					ObjectToString[{}],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardTrueFrequencyNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankTrueFrequencyNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>", Frequency has a valid value if Include is True:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>", Frequency has a valid value if Include is True:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* nullTotalVolumeErrors - raise warning if no composition is found and SampleVolume is automatic  *)
		(* Grab the options that are indeed invalid between the different samples groups *)
		loadTimeNullOptions = PickList[
			{
				StandardLoadTime,
				BlankLoadTime
			},
			{
				Or@@standardLoadTimeNullErrors,
				Or@@blankLoadTimeNullErrors
			}
		];

		loadTimeNullErrorsSamples =combineObjectStrings[{
			ObjectToString[{}],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardLoadTimeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankLoadTimeNullErrors]],Cache->inheritedCache]
		}];

		If[Length[loadTimeNullOptions]>0&&messages&&Not[engineQ],
			(
				Message[Error::CIEFLoadTimeNullError,loadTimeNullErrorsSamples];
				{loadTimeNullOptions}
			),
			{}
		];

		loadTimeNullErrorsTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[resolvedStandards],ToList[standardLoadTimeNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankLoadTimeNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[{}],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardLoadTimeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankLoadTimeNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[resolvedStandards],ToList[standardLoadTimeNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankLoadTimeNullErrors],False]
				];

				passingString =combineObjectStrings[{
					ObjectToString[{}],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardLoadTimeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankLoadTimeNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>", LoadTime has a valid value if related samples have been specified:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>", LoadTime has a valid value if related samples have been specified:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];


		(* not raising MissingSampleCompositionWarnings for samples, since by they cant have a Null *)

		(* missingSampleCompositionWarnings - raise warning if no composition is found and SampleVolume is automatic  *)
		(* Grab the options that are indeed invalid between the different samples groups *)
		missingSampleCompositionWarningsOptions = PickList[
			{SampleVolume, StandardVolume},
			{
				Or@@missingSampleCompositionWarnings,
				Or@@standardMissingSampleCompositionWarnings
			}
		];

		missingSampleCompositionWarningsSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[missingSampleCompositionWarnings]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardMissingSampleCompositionWarnings]],Cache->inheritedCache]
		}];

		If[Length[missingSampleCompositionWarningsOptions]>0&&messages&&Not[engineQ],
			(
				Message[Warning::CIEFMissingSampleComposition,missingSampleCompositionWarningsSamples];
				{missingSampleCompositionWarningsOptions}
			),
			{}
		];

		missingSampleCompositionWarningTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[simulatedSamples,missingSampleCompositionWarnings],
					PickList[ToList[resolvedStandards],ToList[standardMissingSampleCompositionWarnings]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[missingSampleCompositionWarnings]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardMissingSampleCompositionWarnings]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[simulatedSamples,missingSampleCompositionWarnings,False],
					PickList[ToList[resolvedStandards],ToList[standardMissingSampleCompositionWarnings],False]
				];

				passingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[missingSampleCompositionWarnings],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardMissingSampleCompositionWarnings],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Warning["For the provided samples "<>failingString<>", protein concentration is specified in Composition, allowing to calculate SampleVolume:",
						False,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];
		(* not raising MissingSampleCompositionWarnings for blanks, since by definition the should not have protein in them *)

		(* OnBoardMixingIncompatibleVolumesErrors *)
		(* Grab the options that are indeed invalid between the different samples groups *)
		onBoardMixingIncompatibleVolumesOptions = PickList[
			{
				{OnBoardMixing,TotalVolume,SampleVolume},
				{OnBoardMixing,StandardTotalVolume,StandardVolume},
				{OnBoardMixing,BlankTotalVolume,BlankVolume}
			},
			{
				Or@@OnBoardMixingIncompatibleVolumesErrors,
				Or@@standardOnBoardMixingIncompatibleVolumesErrors,
				Or@@blankOnBoardMixingIncompatibleVolumesErrors
			}
		];

		onBoardMixingIncompatibleVolumesInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[OnBoardMixingIncompatibleVolumesErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardOnBoardMixingIncompatibleVolumesErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankOnBoardMixingIncompatibleVolumesErrors]],Cache->inheritedCache]
		}];

		onBoardMixingIncompatibleVolumesInvalidOptions=If[Length[onBoardMixingIncompatibleVolumesOptions]>0&&messages,
			(
				Message[Error::CIEFOnBoardMixingIncompatibleVolumes,onBoardMixingIncompatibleVolumesInvalidSamples];
				onBoardMixingIncompatibleVolumesOptions
			),
			{}
		];

		onBoardMixingIncompatibleVolumesTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[OnBoardMixingIncompatibleVolumesErrors]],
					PickList[ToList[resolvedStandards],ToList[standardOnBoardMixingIncompatibleVolumesErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankOnBoardMixingIncompatibleVolumesErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[OnBoardMixingIncompatibleVolumesErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardOnBoardMixingIncompatibleVolumesErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankOnBoardMixingIncompatibleVolumesErrors]],Cache->inheritedCache]
				}];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[OnBoardMixingIncompatibleVolumesErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardOnBoardMixingIncompatibleVolumesErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankOnBoardMixingIncompatibleVolumesErrors],False],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[OnBoardMixingIncompatibleVolumesErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardOnBoardMixingIncompatibleVolumesErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankOnBoardMixingIncompatibleVolumesErrors],False]
				];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the set volume is compatible with OnBoardMixing, when it is set to True:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the set volume is compatible with OnBoardMixing, when it is set to True:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];


		(* moreThanOneMasterMixWithOnBoardMixing *)

		(* to make sure there is only a single makeup, we will check ALL resolved master mix related options and make sure they have a single value (or 0 if not used), if more, raise error *)
		(* This makes a pretty ugly, monstrous list.. but what can you do (let me know if you have a better idea!). *)
		onBoardMixingResolvedOptions =
			(* Flattening one by one all of the following *)
			Flatten[#,1]& /@ Transpose[
				Select[
					{
						{
							resolvedPremadeMasterMix,Lookup[roundedCapillaryIsoelectricFocusingOptions,PremadeMasterMixReagent],
							resolvedPremadeMasterMixDiluent,resolvedPremadeMasterMixDilutionFactor,resolvedPremadeMasterMixVolume,
							resolvedDiluent,resolvedAmpholytes,resolvedAmpholyteVolume,resolvedIsoelectricPointMarkers,
							resolvedIsoelectricPointMarkersVolume,resolvedElectroosmoticFlowBlocker,resolvedElectroosmoticFlowBlockerVolume,
							resolvedDenature, resolvedDenaturationReagent,resolvedDenaturationReagentVolume,resolvedAnodicSpacer,resolvedAnodicSpacerVolume,
							resolvedCathodicSpacer,resolvedCathodicSpacerVolume
						},
						(* if standards are included *)
						If[resolveIncludeStandards,
							{
								resolvedStandardPremadeMasterMix,resolvedStandardPremadeMasterMixReagent,resolvedStandardPremadeMasterMixDiluent,
								resolvedStandardPremadeMasterMixDilutionFactor,resolvedStandardPremadeMasterMixVolume,resolvedStandardDiluent,
								resolvedStandardAmpholytes,resolvedStandardAmpholyteVolume,resolvedStandardIsoelectricPointMarkers,
								resolvedStandardIsoelectricPointMarkersVolume,resolvedStandardElectroosmoticFlowBlocker,
								resolvedStandardElectroosmoticFlowBlockerVolume,resolvedStandardDenature,resolvedStandardDenaturationReagent,
								resolvedStandardDenaturationReagentVolume,resolvedStandardAnodicSpacer,resolvedStandardAnodicSpacerVolume,
								resolvedStandardCathodicSpacer,resolvedStandardCathodicSpacerVolume
							},
							ConstantArray[{},18]
						],
						(* if blanks are included *)
						If[resolveIncludeBlanks,
							{
								resolvedBlankPremadeMasterMix,resolvedBlankPremadeMasterMixReagent,resolvedBlankPremadeMasterMixDiluent,
								resolvedBlankPremadeMasterMixDilutionFactor,resolvedBlankPremadeMasterMixVolume,resolvedBlankDiluent,
								resolvedBlankAmpholytes,resolvedBlankAmpholyteVolume,resolvedBlankIsoelectricPointMarkers,
								resolvedBlankIsoelectricPointMarkersVolume,resolvedBlankElectroosmoticFlowBlocker,
								resolvedBlankElectroosmoticFlowBlockerVolume,resolvedBlankDenature,resolvedBlankDenaturationReagent,resolvedBlankDenaturationReagentVolume,
								resolvedBlankAnodicSpacer,resolvedBlankAnodicSpacerVolume,resolvedBlankCathodicSpacer,resolvedBlankCathodicSpacerVolume
							},
							ConstantArray[{},18]
						]
					},
					(* get rid of empty lists where these options where not included *)
					!MatchQ[#, {{}..}]&
				]
		];

		(* check if the length of unique options is larger than 1. if it is, we can't do OBM *)
		onBoardMixingResolvedOptionsLengthBool = If[Lookup[myOptions,OnBoardMixing],
			Map[
				Function[option,
				Length[DeleteDuplicates[option]]>1
				],
				onBoardMixingResolvedOptions
			],
			(* if not using OnBoardMixing, nothing to test here *)
			ConstantArray[False,Length[onBoardMixingResolvedOptions]]
		];

		(* make list of the rogue options violating the one mastermix makeup (once again, an ugly monstrous list *)
		onBoardMixingNullOptions =
			PickList[
				Flatten[#,1]& /@ Transpose[
					Select[
						{
							{
								PremadeMasterMix,PremadeMasterMixReagent,PremadeMasterMixDiluent,PremadeMasterMixReagentDilutionFactor,
								PremadeMasterMixVolume,Diluent,Ampholytes,AmpholyteVolume,IsoelectricPointMarkers,IsoelectricPointMarkersVolume,
								ElectroosmoticFlowBlocker,ElectroosmoticFlowBlockerVolume,Denature,DenaturationReagent,DenaturationReagentVolume,
								AnodicSpacer,AnodicSpacerVolume,CathodicSpacer,CathodicSpacerVolume
							},
							(* if standards are included *)
							If[resolveIncludeStandards,
								{
									StandardPremadeMasterMix,StandardPremadeMasterMixReagent,StandardPremadeMasterMixDiluent,
									StandardPremadeMasterMixReagentDilutionFactor,StandardPremadeMasterMixVolume,StandardDiluent,
									StandardAmpholytes,StandardAmpholyteVolume,StandardIsoelectricPointMarkers,
									StandardIsoelectricPointMarkersVolume,StandardElectroosmoticFlowBlocker,StandardElectroosmoticFlowBlockerVolume,
									StandardDenature,StandardDenaturationReagent,StandardDenaturationReagentVolume,StandardAnodicSpacer,
									StandardAnodicSpacerVolume,StandardCathodicSpacer,StandardCathodicSpacerVolume
								},
								ConstantArray[{},18]
							],
							(* if blanks are included *)
							If[resolveIncludeBlanks,
								{
									BlankPremadeMasterMix,BlankPremadeMasterMixReagent,BlankPremadeMasterMixDiluent,BlankPremadeMasterMixReagentDilutionFactor,
									BlankPremadeMasterMixVolume,BlankDiluent,BlankAmpholytes,BlankAmpholyteVolume,BlankIsoelectricPointMarkers,
									BlankIsoelectricPointMarkersVolume,BlankElectroosmoticFlowBlocker,BlankElectroosmoticFlowBlockerVolume,
									BlankDenature,BlankDenaturationReagent,BlankDenaturationReagentVolume,BlankAnodicSpacer,BlankAnodicSpacerVolume,
									BlankCathodicSpacer,BlankCathodicSpacerVolume
								},
								ConstantArray[{},18]
							]
						},
						(* get rid of empty lists where these options where not included *)
						!MatchQ[#, {{}..}]&
					]
				],
				onBoardMixingResolvedOptionsLengthBool
		];

		(* make list of the rogue options (once again, an ugly monstrous list *)
		onBoardMixingPassingOptions =
			PickList[
				Flatten[#,1]& /@ Transpose[
					Select[
						{
							{
								PremadeMasterMix,PremadeMasterMixReagent,PremadeMasterMixDiluent,PremadeMasterMixReagentDilutionFactor,
								PremadeMasterMixVolume,Diluent,Ampholytes,AmpholyteVolume,IsoelectricPointMarkers,IsoelectricPointMarkersVolume,
								ElectroosmoticFlowBlocker,ElectroosmoticFlowBlockerVolume,Denature,DenaturationReagent,DenaturationReagentVolume,
								AnodicSpacer,AnodicSpacerVolume,CathodicSpacer,CathodicSpacerVolume
							},
							(* if standards are included *)
							If[resolveIncludeStandards,
								{
									StandardPremadeMasterMix,StandardPremadeMasterMixReagent,StandardPremadeMasterMixDiluent,
									StandardPremadeMasterMixReagentDilutionFactor,StandardPremadeMasterMixVolume,StandardDiluent,
									StandardAmpholytes,StandardAmpholyteVolume,StandardIsoelectricPointMarkers,
									StandardIsoelectricPointMarkersVolume,StandardElectroosmoticFlowBlocker,StandardElectroosmoticFlowBlockerVolume,
									StandardDenature,StandardDenaturationReagent,StandardDenaturationReagentVolume,StandardAnodicSpacer,
									StandardAnodicSpacerVolume,StandardCathodicSpacer,StandardCathodicSpacerVolume
								},
								ConstantArray[{},18]
							],
							(* if blanks are included *)
							If[resolveIncludeBlanks,
								{
									BlankPremadeMasterMix,BlankPremadeMasterMixReagent,BlankPremadeMasterMixDiluent,BlankPremadeMasterMixReagentDilutionFactor,
									BlankPremadeMasterMixVolume,BlankDiluent,BlankAmpholytes,BlankAmpholyteVolume,BlankIsoelectricPointMarkers,
									BlankIsoelectricPointMarkersVolume,BlankElectroosmoticFlowBlocker,BlankElectroosmoticFlowBlockerVolume,
									BlankDenature,BlankDenaturationReagent,BlankDenaturationReagentVolume,BlankAnodicSpacer,BlankAnodicSpacerVolume,
									BlankCathodicSpacer,BlankCathodicSpacerVolume
								},
								ConstantArray[{},18]
							]
						},
						(* get rid of empty lists where these options where not included *)
						!MatchQ[#, {{}..}]&
					]
				],
				onBoardMixingResolvedOptionsLengthBool,
				False
		];

		(* if any option has more than one unique value, raise error *)
		onBoardMixingInvalidOptions=If[Length[onBoardMixingNullOptions]>0&&messages,
			(
				Message[Error::CIEFMoreThanOneMasterMixWithOnBoardMixing,TextString[Flatten@onBoardMixingNullOptions]];
				Flatten@onBoardMixingNullOptions
			),
			{}
		];

		onBoardMixingInvalidTests=If[gatherTests,
			Module[{failingOptionsTests,passingOptionsTests},

				(* create a test for the non-passing inputs *)
				failingOptionsTests=If[Length[onBoardMixingNullOptions]>0,
					Test["For the provided options "<>TextString[Flatten@onBoardMixingNullOptions]<>",All mastermix-related options have a single unique value if using onboard mixing:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingOptionsTests=If[Length[onBoardMixingPassingOptions]>0,
					Test["For the provided options "<>TextString[Flatten@onBoardMixingPassingOptions]<>",All mastermix-related options have a single unique value if using onboard mixing:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{failingOptionsTests,passingOptionsTests}
			]
		];

		(*OnBoardMixingVolume*)
		obmSampleNumberTopoff=If[Lookup[myOptions,OnBoardMixing],
			(* add 15 samples or the difference to 48 to the first or the second vial if theres too little volume to
			handle OBM. According to the engineer, there's a 1.5ml dead volume*)
			Module[{numberOfInjections},
				numberOfInjections = Length[resolvedInjectionTable];
				(* figure out how many samples we want to top off, either add 1.5 ml or whatever the differece is to 48 samples to the last vial (we have two) *)
				Which[
					numberOfInjections<48, Min[15, 48-numberOfInjections],
					numberOfInjections>48&&numberOfInjections>96, Min[15, 96-numberOfInjections],
					True, 0
				]
			],
			0
		];

		If[obmSampleNumberTopoff>0&&messages&&!engineQ,
			Message[Warning::OnBoardMixingVolume,ToString[obmSampleNumberTopoff*100Microliter]];
		];

		OnBoardMixingVolumeTest=If[gatherTests,
			Module[{failingSampleTests,passingSampleTests},
				(* create warning for failing samples *)
				failingSampleTests=If[obmSampleNumberTopoff>0,
					Warning["For the provided samples, additional volume will be added to the onboard mixing reagent vials to make sure it operates reliably:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[obmSampleNumberTopoff==0,
					Warning["For the provided samples, additional volume will be added to the onboard mixing reagent vials to make sure it operates reliably:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			],
			Nothing
		];

		(* imagingMethodMismatchErrors *)
		(* Grab the options that are indeed invalid between the different samples groups *)
		imagingMethodMismatchOptions = PickList[
			{
				{ImagingMethods, NativeFluorescneceImagingTimes},
				{StandardImagingMethods, StandardNativeFluorescneceImagingTimes},
				{BlankImagingMethods, BlankNativeFluorescneceImagingTimes}
			},
			{
				Or@@imagingMethodMismatchErrors,
				Or@@blankImagingMethodMismatchErrors,
				Or@@blankImagingMethodMismatchErrors
			}
		];

		imagingMethodMismatchInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[imagingMethodMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardImagingMethodMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankImagingMethodMismatchErrors]],Cache->inheritedCache]
		}];

		imagingMethodMismatchInvalidOptions=If[Length[imagingMethodMismatchOptions]>0&&messages,
			(
				Message[Error::CIEFimagingMethodMismatch,imagingMethodMismatchInvalidSamples];
				imagingMethodMismatchOptions
			),
			{}
		];

		imagingMethodMismatchTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[imagingMethodMismatchErrors]],
					PickList[ToList[resolvedStandards],ToList[standardImagingMethodMismatchErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankImagingMethodMismatchErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[imagingMethodMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardImagingMethodMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankImagingMethodMismatchErrors]],Cache->inheritedCache]
				}];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[imagingMethodMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardImagingMethodMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankImagingMethodMismatchErrors],False],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[imagingMethodMismatchErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardImagingMethodMismatchErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankImagingMethodMismatchErrors],False]
				];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the set imaging methods are copacetic with the native fluorescence imaging times:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the set imaging methods are copacetic with the native fluorescence imaging times:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* voltageDurationStepErrors *)
		(* Grab the options that are indeed invalid between the different samples groups *)
		voltageDurationStepOptions = PickList[
			{
				VoltageDurationProfile,
				StandardVoltageDurationProfile,
				BlankVoltageDurationProfile
			},
			{
				Or@@voltageDurationStepErrors,
				Or@@standardVoltageDurationStepErrors,
				Or@@blankVoltageDurationStepErrors
			}
		];

		voltageDurationStepInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[voltageDurationStepErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardVoltageDurationStepErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankVoltageDurationStepErrors]],Cache->inheritedCache]
		}];

		voltageDurationStepInvalidOptions=If[Length[voltageDurationStepOptions]>0&&messages,
			(
				Message[Error::CIEFInvalidVoltageDurationProfile,voltageDurationStepInvalidSamples];
				voltageDurationStepOptions
			),
			{}
		];

		voltageDurationStepTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[voltageDurationStepErrors]],
					PickList[ToList[resolvedStandards],ToList[standardVoltageDurationStepErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankVoltageDurationStepErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[voltageDurationStepErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardVoltageDurationStepErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankVoltageDurationStepErrors]],Cache->inheritedCache]
				}];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[voltageDurationStepErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardVoltageDurationStepErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankVoltageDurationStepErrors],False],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[voltageDurationStepErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardVoltageDurationStepErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankVoltageDurationStepErrors],False]
				];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the VoltageDurationProfile has more than between 1 and 20 steps:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the VoltageDurationProfile has more than between 1 and 20 steps:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* premadeMastermixFalseOptionsSpecifiedErrors *)
		premadeMastermixFalseOptionsSpecifiedOptions = PickList[
			{
				PremadeMasterMix,
				StandardPremadeMasterMix,
				BlankPremadeMasterMix
			},
			{
				Or@@premadeMastermixFalseOptionsSpecifiedErrors,
				Or@@standardPremadeMastermixFalseOptionsSpecifiedErrors,
				Or@@blankPremadeMastermixFalseOptionsSpecifiedErrors
			}
		];

		premadeMastermixFalseOptionsSpecifiedInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMastermixFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMastermixFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMastermixFalseOptionsSpecifiedErrors]],Cache->inheritedCache]
		}];

		premadeMastermixFalseOptionsSpecifiedInvalidOptions=If[Length[premadeMastermixFalseOptionsSpecifiedOptions]>0&&messages,
			(
				Message[Error::CIEFPremadeMastermixFalseOptionsSpecifiedError,premadeMastermixFalseOptionsSpecifiedInvalidSamples];
				premadeMastermixFalseOptionsSpecifiedOptions
			),
			{}
		];

		premadeMastermixFalseOptionsSpecifiedTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMastermixFalseOptionsSpecifiedErrors]],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMastermixFalseOptionsSpecifiedErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMastermixFalseOptionsSpecifiedErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMastermixFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMastermixFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMastermixFalseOptionsSpecifiedErrors]],Cache->inheritedCache]
				}];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMastermixFalseOptionsSpecifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMastermixFalseOptionsSpecifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMastermixFalseOptionsSpecifiedErrors],False],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMastermixFalseOptionsSpecifiedErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMastermixFalseOptionsSpecifiedErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMastermixFalseOptionsSpecifiedErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMastermixFalseOptionsSpecifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMastermixFalseOptionsSpecifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMastermixFalseOptionsSpecifiedErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",PremadeMasterMix is copacetic with its options: ",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",PremadeMasterMix is copacetic with its options: ",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* premadeMasterMixNullErrors *)
		premadeMasterMixNullOptions = PickList[
			{
				PremadeMasterMixReagent,
				StandardPremadeMasterMixReagent,
				BlankPremadeMasterMixReagent
			},
			{
				Or@@premadeMasterMixNullErrors,
				Or@@standardPremadeMasterMixNullErrors,
				Or@@blankPremadeMasterMixNullErrors
			}
		];

		premadeMasterMixNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixNullErrors]],Cache->inheritedCache]
		}];

		premadeMasterMixNullInvalidOptions=If[Length[premadeMasterMixNullOptions]>0&&messages,
			(
				Message[Error::CIEFPremadeMasterMixReagentNull,premadeMasterMixNullInvalidSamples];
				premadeMasterMixNullOptions
			),
			{}
		];

		premadeMasterMixNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixNullErrors]],Cache->inheritedCache]
				}];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixNullErrors],False],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",PremadeMasterMixReagent is defined when PremadeMasterMix is True :",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",PremadeMasterMixReagent is defined when PremadeMasterMix is True :",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* premadeMasterMixDilutionFactorNullErrors *)
		premadeMasterMixDilutionFactorNullOptions = PickList[
			{
				PremadeMasterMixReagentDilutionFactor,
				StandardPremadeMasterMixReagentDilutionFactor,
				BlankPremadeMasterMixReagentDilutionFactor
			},
			{
				Or@@premadeMasterMixDilutionFactorNullErrors,
				Or@@standardPremadeMasterMixDilutionFactorNullErrors,
				Or@@blankPremadeMasterMixDilutionFactorNullErrors
			}
		];

		premadeMasterMixDilutionFactorNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache]
		}];

		premadeMasterMixDilutionFactorNullInvalidOptions=If[Length[premadeMasterMixDilutionFactorNullOptions]>0&&messages,
			(
				Message[Error::CIEFPremadeMasterMixDilutionFactorNull,premadeMasterMixDilutionFactorNullInvalidSamples];
				premadeMasterMixDilutionFactorNullOptions
			),
			{}
		];

		premadeMasterMixDilutionFactorNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixDilutionFactorNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDilutionFactorNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDilutionFactorNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache]
				}];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDilutionFactorNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDilutionFactorNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDilutionFactorNullErrors],False],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixDilutionFactorNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDilutionFactorNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDilutionFactorNullErrors],False]
				];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the dilution factor of the premade master mix is specified:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the dilution factor of the premade master mix is specified:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* premadeMasterMixVolumeNullErrors *)
		premadeMasterMixVolumeNullOptions = PickList[
			{
				PremadeMasterMixReagentVolume,
				StandardPremadeMasterMixReagentVolume,
				BlankPremadeMasterMixReagentVolume
			},
			{
				Or@@premadeMasterMixVolumeNullErrors,
				Or@@standardPremadeMasterMixVolumeNullErrors,
				Or@@blankPremadeMasterMixVolumeNullErrors
			}
		];

		premadeMasterMixVolumeNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeNullErrors]],Cache->inheritedCache]
		}];

		premadeMasterMixVolumeNullInvalidOptions=If[Length[premadeMasterMixVolumeNullOptions]>0&&messages,
			(
				Message[Error::CIEFPremadeMasterMixVolumeNull,premadeMasterMixVolumeNullInvalidSamples];
				premadeMasterMixVolumeNullOptions
			),
			{}
		];

		premadeMasterMixVolumeNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeNullErrors]],Cache->inheritedCache]
				}];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeNullErrors],False],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeNullErrors],False]
				];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",PremadeMasterMix Volume is informed or Automatic if PremadeMasterMix is True:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",PremadeMasterMix Volume is informed or Automatic if PremadeMasterMix is True:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* premadeMasterMixVolumeDilutionFactorMismatchWarnings *)
		premadeMasterMixVolumeDilutionFactorMismatchOptions = PickList[
			{
				{PremadeMasterMixVolume,PremadeMasterMixReagentDilutionFactor},
				{StandardPremadeMasterMixVolume,StandardPremadeMasterMixReagentDilutionFactor},
				{BlankPremadeMasterMixVolume,BlankPremadeMasterMixReagentDilutionFactor}
			},
			{
				Or@@premadeMasterMixVolumeDilutionFactorMismatchWarnings,
				Or@@standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings,
				Or@@blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings
			}
		];

		premadeMasterMixVolumeDilutionFactorMismatchInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache]
		}];

		premadeMasterMixVolumeDilutionFactorMismatchInvalidOptions=If[Length[premadeMasterMixVolumeDilutionFactorMismatchOptions]>0&&messages,
			(
				Message[Error::CIEFPremadeMasterMixVolumeDilutionFactorMismatch,premadeMasterMixVolumeDilutionFactorMismatchInvalidSamples];
				premadeMasterMixVolumeDilutionFactorMismatchOptions
			),
			{}
		];

		premadeMasterMixVolumeDilutionFactorMismatchTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeDilutionFactorMismatchWarnings]],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache]
				}];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeDilutionFactorMismatchWarnings],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings],False],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeDilutionFactorMismatchWarnings],False],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings],False],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings],False]
				];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",MasterMix Volume and Dilution Factor are copacetic:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",MasterMix Volume and Dilution Factor are copacetic:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* premadeMasterMixTotalVolumeErrors *)
		premadeMasterMixTotalVolumeOptions = PickList[
			{
				{TotalVolume,SampleVolume,PremadeMasterMixVolume},
				{StandardTotalVolume,StandardSampleVolume,StandardPremadeMasterMixVolume},
				{BlankTotalVolume,BlankSampleVolume,BlankPremadeMasterMixVolume}
			},
			{
				Or@@premadeMasterMixTotalVolumeErrors,
				Or@@standardPremadeMasterMixTotalVolumeErrors,
				Or@@blankPremadeMasterMixTotalVolumeErrors
			}
		];

		premadeMasterMixTotalVolumeInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixTotalVolumeErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixTotalVolumeErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixTotalVolumeErrors]],Cache->inheritedCache]
		}];

		premadeMasterMixTotalVolumeInvalidOptions=If[Length[premadeMasterMixTotalVolumeOptions]>0&&messages,
			(
				Message[Error::CIEFPremadeMasterMixInvalidTotalVolume,premadeMasterMixTotalVolumeInvalidSamples];
				premadeMasterMixTotalVolumeOptions
			),
			{}
		];

		premadeMasterMixTotalVolumeTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixTotalVolumeErrors]],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixTotalVolumeErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixTotalVolumeErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixTotalVolumeErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixTotalVolumeErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixTotalVolumeErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixTotalVolumeErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixTotalVolumeErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixTotalVolumeErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixTotalVolumeErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixTotalVolumeErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixTotalVolumeErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the sum of SampleVolume and MasterMix Volume does not exceed the TotalVolume:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the sum of SampleVolume and MasterMix Volume does not exceed the TotalVolume:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* premadeMasterMixDiluentNullErrors *)
		premadeMasterMixDiluentNullOptions = PickList[
			{
				PremadeMasterMixDiluent,
				StandardPremadeMasterMixDiluent,
				BlankPremadeMasterMixDiluent
			},
			{
				Or@@premadeMasterMixDiluentNullErrors,
				Or@@standardPremadeMasterMixDiluentNullErrors,
				Or@@blankPremadeMasterMixDiluentNullErrors
			}
		];

		premadeMasterMixDiluentNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDiluentNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDiluentNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDiluentNullErrors]],Cache->inheritedCache]
		}];

		premadeMasterMixDiluentNullInvalidOptions=If[Length[premadeMasterMixDiluentNullOptions]>0&&messages,
			(
				Message[Error::CIEFPremadeMasterMixDiluentNull,premadeMasterMixDiluentNullInvalidSamples];
				premadeMasterMixDiluentNullOptions
			),
			{}
		];

		premadeMasterMixDiluentNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixDiluentNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDiluentNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDiluentNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDiluentNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDiluentNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDiluentNullErrors]],Cache->inheritedCache]
				}];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDiluentNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDiluentNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDiluentNullErrors],False],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[premadeMasterMixDiluentNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDiluentNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDiluentNullErrors],False]
				];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",a Diluent for premadeMasterMix is not Null:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",a Diluent for premadeMasterMix is not Null:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* nullDiluentErrors *)
		nullDiluentOptions = PickList[
			{
				Diluent,
				StandardDiluent,
				BlankDiluent
			},
			{
				Or@@nullDiluentErrors,
				Or@@standardNullDiluentErrors,
				Or@@blankNullDiluentErrors
			}
		];

		nullDiluentInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[nullDiluentErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNullDiluentErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNullDiluentErrors]],Cache->inheritedCache]
		}];

		nullDiluentInvalidOptions=If[Length[nullDiluentOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixDiluentNull,nullDiluentInvalidSamples];
				nullDiluentOptions
			),
			{}
		];

		nullDiluentTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[nullDiluentErrors]],
					PickList[ToList[resolvedStandards],ToList[standardNullDiluentErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankNullDiluentErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[nullDiluentErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNullDiluentErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNullDiluentErrors]],Cache->inheritedCache]
				}];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[nullDiluentErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNullDiluentErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNullDiluentErrors],False],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[nullDiluentErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardNullDiluentErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankNullDiluentErrors],False]
				];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",Diluent is specified if the volume of sample and mastermix don't sum to Total volume:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",Diluent is specified if the volume of sample and mastermix don't sum to Total volume:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* noSpecifiedAmpholytesErrors *)
		noSpecifiedAmpholytesOptions = PickList[
			{
				Ampholytes,
				StandardAmpholytes,
				BlankAmpholytes
			},
			{
				Or@@noSpecifiedAmpholytesErrors,
				Or@@standardNoSpecifiedAmpholytesErrors,
				Or@@blankNoSpecifiedAmpholytesErrors
			}
		];

		noSpecifiedAmpholytesInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[noSpecifiedAmpholytesErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoSpecifiedAmpholytesErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoSpecifiedAmpholytesErrors]],Cache->inheritedCache]
		}];

		noSpecifiedAmpholytesInvalidOptions=If[Length[noSpecifiedAmpholytesOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixAmpholytesNull,noSpecifiedAmpholytesInvalidSamples];
				noSpecifiedAmpholytesOptions
			),
			{}
		];

		noSpecifiedAmpholytesTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noSpecifiedAmpholytesErrors]],
					PickList[ToList[resolvedStandards],ToList[standardNoSpecifiedAmpholytesErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankNoSpecifiedAmpholytesErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noSpecifiedAmpholytesErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoSpecifiedAmpholytesErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoSpecifiedAmpholytesErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noSpecifiedAmpholytesErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardNoSpecifiedAmpholytesErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankNoSpecifiedAmpholytesErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noSpecifiedAmpholytesErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoSpecifiedAmpholytesErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoSpecifiedAmpholytesErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",when PremadeMasterMix is False, Ampholytes are specified:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",when PremadeMasterMix is False, Ampholytes are specified:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* ampholyteMatchedlengthsNotCopaceticErrors *)
		ampholyteMatchedlengthsNotCopaceticOptions = PickList[
			{
				{Ampholytes,AmpholyteTargetConcentrations,AmpholyteVolume},
				{StandardAmpholytes,StandardAmpholyteTargetConcentrations,StandardAmpholyteVolume},
				{BlankAmpholytes,BlankAmpholyteTargetConcentrations,BlankAmpholyteVolume}
			},
			{
				Or@@ampholyteMatchedlengthsNotCopaceticErrors,
				Or@@standardAmpholyteMatchedlengthsNotCopaceticErrors,
				Or@@blankAmpholyteMatchedlengthsNotCopaceticErrors
			}
		];

		ampholyteMatchedlengthsNotCopaceticInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteMatchedlengthsNotCopaceticErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteMatchedlengthsNotCopaceticErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteMatchedlengthsNotCopaceticErrors]],Cache->inheritedCache]
		}];

		ampholyteMatchedlengthsNotCopaceticInvalidOptions=If[Length[ampholyteMatchedlengthsNotCopaceticOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixAmpholyteOptionLengthsNotCopacetic,ampholyteMatchedlengthsNotCopaceticInvalidSamples];
				ampholyteMatchedlengthsNotCopaceticOptions
			),
			{}
		];

		ampholyteMatchedlengthsNotCopaceticTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[ampholyteMatchedlengthsNotCopaceticErrors]],
					PickList[ToList[resolvedStandards],ToList[standardAmpholyteMatchedlengthsNotCopaceticErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankAmpholyteMatchedlengthsNotCopaceticErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteMatchedlengthsNotCopaceticErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteMatchedlengthsNotCopaceticErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteMatchedlengthsNotCopaceticErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[ampholyteMatchedlengthsNotCopaceticErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardAmpholyteMatchedlengthsNotCopaceticErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankAmpholyteMatchedlengthsNotCopaceticErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteMatchedlengthsNotCopaceticErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteMatchedlengthsNotCopaceticErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteMatchedlengthsNotCopaceticErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the length of Ampholytes NestedIndexMatched options is the same or 1:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the length of Ampholytes NestedIndexMatched options is the same or 1:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* ampholyteVolumeNullErrors *)
		ampholyteVolumeNullOptions = PickList[
			{
				AmpholyteVolume,
				StandardAmpholyteVolume,
				BlankAmpholyteVolume
			},
			{
				Or@@ampholyteVolumeNullErrors,
				Or@@standardAmpholyteVolumeNullErrors,
				Or@@blankAmpholyteVolumeNullErrors
			}
		];

		ampholyteVolumeNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteVolumeNullErrors]],Cache->inheritedCache]
		}];
		ampholyteVolumeNullInvalidOptions=If[Length[ampholyteVolumeNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixAmpholytesVolumesNull,ampholyteVolumeNullInvalidSamples];
				ampholyteVolumeNullOptions
			),
			{}
		];

		ampholyteVolumeNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[ampholyteVolumeNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardAmpholyteVolumeNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankAmpholyteVolumeNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteVolumeNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[ampholyteVolumeNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardAmpholyteVolumeNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankAmpholyteVolumeNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteVolumeNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",a volume is specified for all ampholytes:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",a volume is specified for all ampholytes:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* ampholyteConcentrationNullErrors *)
		ampholyteConcentrationNullOptions = PickList[
			{
				AmpholyteTargetConcentrations,
				StandardAmpholyteTargetConcentrations,
				BlankAmpholyteTargetConcentrations
			},
			{
				Or@@ampholyteConcentrationNullErrors,
				Or@@standardAmpholyteConcentrationNullErrors,
				Or@@blankAmpholyteConcentrationNullErrors
			}
		];

		ampholyteConcentrationNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteConcentrationNullErrors]],Cache->inheritedCache]
		}];

		ampholyteConcentrationNullErrorsInvalidOptions=If[Length[ampholyteConcentrationNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixAmpholytesConcentrationNull,ampholyteConcentrationNullInvalidSamples];
				ampholyteConcentrationNullOptions
			),
			{}
		];

		ampholyteConcentrationNullErrorsTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[ampholyteConcentrationNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardAmpholyteConcentrationNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankAmpholyteConcentrationNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteConcentrationNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[ampholyteConcentrationNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardAmpholyteConcentrationNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankAmpholyteConcentrationNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteConcentrationNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the ampholyte target concentration is specified:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the ampholyte target concentration is specified:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* ampholyteVolumeConcentrationMismatchErrors *)
		ampholyteVolumeConcentrationMismatchOptions = PickList[
			{
				{AmpholyteTargetConcentrations,AmpholyteVolume},
				{StandardAmpholyteTargetConcentrations,StandardAmpholyteVolume},
				{BlankAmpholyteTargetConcentrations,BlankAmpholyteVolume}
			},
			{
				Or@@ampholyteVolumeConcentrationMismatchErrors,
				Or@@standardAmpholyteVolumeConcentrationMismatchErrors,
				Or@@blankAmpholyteVolumeConcentrationMismatchErrors
			}
		];

		ampholyteVolumeConcentrationMismatchInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteVolumeConcentrationMismatchErrors]],Cache->inheritedCache]
		}];

		ampholyteVolumeConcentrationMismatchInvalidOptions=If[Length[ampholyteVolumeConcentrationMismatchOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixAmpholytesVolumeConcentrationMismatch,ampholyteVolumeConcentrationMismatchInvalidSamples];
				ampholyteVolumeConcentrationMismatchOptions
			),
			{}
		];

		ampholyteVolumeConcentrationMismatchTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[ampholyteVolumeConcentrationMismatchErrors]],
					PickList[ToList[resolvedStandards],ToList[standardAmpholyteVolumeConcentrationMismatchErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankAmpholyteVolumeConcentrationMismatchErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteVolumeConcentrationMismatchErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[ampholyteVolumeConcentrationMismatchErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardAmpholyteVolumeConcentrationMismatchErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankAmpholyteVolumeConcentrationMismatchErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[ampholyteVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAmpholyteVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAmpholyteVolumeConcentrationMismatchErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the specified ampholyte volume and concentration are copacetic:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the specified ampholyte volume and concentration are copacetic:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* noSpecifiedIsoelectricPointMarkersErrors *)
		noSpecifiedIsoelectricPointMarkersOptions = PickList[
			{
				IsoelectricPointMarkers,
				StandardIsoelectricPointMarkers,
				BlankIsoelectricPointMarkers
			},
			{
				Or@@noSpecifiedIsoelectricPointMarkersErrors,
				Or@@standardNoSpecifiedIsoelectricPointMarkersErrors,
				Or@@blankNoSpecifiedIsoelectricPointMarkersErrors
			}
		];

		noSpecifiedIsoelectricPointMarkersInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[noSpecifiedIsoelectricPointMarkersErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoSpecifiedIsoelectricPointMarkersErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoSpecifiedIsoelectricPointMarkersErrors]],Cache->inheritedCache]
		}];

		noSpecifiedIsoelectricPointMarkersInvalidOptions=If[Length[noSpecifiedIsoelectricPointMarkersOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixIsoelectricPointMarkersNull,noSpecifiedIsoelectricPointMarkersInvalidSamples];
				noSpecifiedIsoelectricPointMarkersOptions
			),
			{}
		];

		noSpecifiedIsoelectricPointMarkersTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noSpecifiedIsoelectricPointMarkersErrors]],
					PickList[ToList[resolvedStandards],ToList[standardNoSpecifiedIsoelectricPointMarkersErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankNoSpecifiedIsoelectricPointMarkersErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noSpecifiedIsoelectricPointMarkersErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoSpecifiedIsoelectricPointMarkersErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoSpecifiedIsoelectricPointMarkersErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noSpecifiedIsoelectricPointMarkersErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardNoSpecifiedIsoelectricPointMarkersErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankNoSpecifiedIsoelectricPointMarkersErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noSpecifiedIsoelectricPointMarkersErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoSpecifiedIsoelectricPointMarkersErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoSpecifiedIsoelectricPointMarkersErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",when PremadeMasterMix is False, IsoelectricPointMarkers are specified:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",when PremadeMasterMix is False, IsoelectricPointMarkers are specified:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* resolverCantFixIsoelectricPointMarkersMismatchErrors *)
		resolverCantFixIsoelectricPointMarkersMismatchOptions = PickList[
			{
				{IsoelectricPointMarkers, IsoelectricPointMarkersTargetConcentrations, IsoelectricPointMarkersVolume},
				{StandardIsoelectricPointMarkers, StandardIsoelectricPointMarkersTargetConcentrations, StandardIsoelectricPointMarkersVolume},
				{BlankIsoelectricPointMarkers, BlankIsoelectricPointMarkersTargetConcentrations, BlankIsoelectricPointMarkersVolume}
			},
			{
				Or@@resolverCantFixIsoelectricPointMarkersMismatchErrors,
				Or@@standardResolverCantFixIsoelectricPointMarkersMismatchErrors,
				Or@@blankResolverCantFixIsoelectricPointMarkersMismatchErrors
			}
		];

		resolverCantFixIsoelectricPointMarkersMismatchInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[resolverCantFixIsoelectricPointMarkersMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardResolverCantFixIsoelectricPointMarkersMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankResolverCantFixIsoelectricPointMarkersMismatchErrors]],Cache->inheritedCache]
		}];

		resolverCantFixIsoelectricPointMarkersMismatchInvalidOptions=If[Length[resolverCantFixIsoelectricPointMarkersMismatchOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixIsoelectricPointMarkerOptionLengthsNotCopacetic,resolverCantFixIsoelectricPointMarkersMismatchInvalidSamples];
				resolverCantFixIsoelectricPointMarkersMismatchOptions
			),
			{}
		];

		resolverCantFixIsoelectricPointMarkersMismatchTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[resolverCantFixIsoelectricPointMarkersMismatchErrors]],
					PickList[ToList[resolvedStandards],ToList[standardResolverCantFixIsoelectricPointMarkersMismatchErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankResolverCantFixIsoelectricPointMarkersMismatchErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[resolverCantFixIsoelectricPointMarkersMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardResolverCantFixIsoelectricPointMarkersMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankResolverCantFixIsoelectricPointMarkersMismatchErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[resolverCantFixIsoelectricPointMarkersMismatchErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardResolverCantFixIsoelectricPointMarkersMismatchErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankResolverCantFixIsoelectricPointMarkersMismatchErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[resolverCantFixIsoelectricPointMarkersMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardResolverCantFixIsoelectricPointMarkersMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankResolverCantFixIsoelectricPointMarkersMismatchErrors],False],Cache->inheritedCache]
				}];


				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the length of IsoelectricPointMarkers NestedIndexMatched options is the same or 1:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the length of IsoelectricPointMarkers NestedIndexMatched options is the same or 1:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* isoelectricPointMarkersVolumeNullErrors *)
		isoelectricPointMarkersVolumeNullOptions = PickList[
			{
				IsoelectricPointMarkersVolume,
				StandardIsoelectricPointMarkersVolume,
				BlankIsoelectricPointMarkersVolume
			},
			{
				Or@@isoelectricPointMarkersVolumeNullErrors,
				Or@@standardIsoelectricPointMarkersVolumeNullErrors,
				Or@@blankIsoelectricPointMarkersVolumeNullErrors
			}
		];

		isoelectricPointMarkersVolumeNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersVolumeNullErrors]],Cache->inheritedCache]
		}];

		isoelectricPointMarkersVolumeNullInvalidOptions=If[Length[isoelectricPointMarkersVolumeNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixIsoelectricPointMarkersVolumesNull,isoelectricPointMarkersVolumeNullInvalidSamples];
				isoelectricPointMarkersVolumeNullOptions
			),
			{}
		];

		isoelectricPointMarkersVolumeNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersVolumeNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersVolumeNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersVolumeNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersVolumeNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersVolumeNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersVolumeNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersVolumeNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersVolumeNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",a volume is specified for all isoelectricPointMarkers:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",a volume is specified for all isoelectricPointMarkers:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* isoelectricPointMarkersConcentrationNullErrors *)
		isoelectricPointMarkersConcentrationNullErrorsOptions = PickList[
			{
				IsoelectricPointMarkersTargetConcentrations,
				StandardIsoelectricPointMarkersTargetConcentrations,
				BlankIsoelectricPointMarkersTargetConcentrations
			},
			{
				Or@@isoelectricPointMarkersConcentrationNullErrors,
				Or@@standardIsoelectricPointMarkersConcentrationNullErrors,
				Or@@blankIsoelectricPointMarkersConcentrationNullErrors
			}
		];

		isoelectricPointMarkersConcentrationNullErrorsInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersConcentrationNullErrors]],Cache->inheritedCache]
		}];
		isoelectricPointMarkersConcentrationNullErrorsInvalidOptions=If[Length[isoelectricPointMarkersConcentrationNullErrorsOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixIsoelectricPointMarkersConcentrationNull,isoelectricPointMarkersConcentrationNullErrorsInvalidSamples];
				isoelectricPointMarkersConcentrationNullErrorsOptions
			),
			{}
		];

		isoelectricPointMarkersConcentrationNullErrorsTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersConcentrationNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersConcentrationNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersConcentrationNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersConcentrationNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersConcentrationNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersConcentrationNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersConcentrationNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersConcentrationNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the isoelectricPointMarkers target concentration is specified:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the isoelectricPointMarkers target concentration is specified:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* isoelectricPointMarkersVolumeConcentrationMismatchErrors *)
		isoelectricPointMarkersVolumeConcentrationMismatchOptions = PickList[
			{
				{IsoelectricPointMarkersVolume,IsoelectricPointMarkersTargetConcentrations},
				{StandardIsoelectricPointMarkersVolume,StandardIsoelectricPointMarkersTargetConcentrations},
				{BlankIsoelectricPointMarkersVolume,BlankIsoelectricPointMarkersTargetConcentrations}
			},
			{
				Or@@isoelectricPointMarkersVolumeConcentrationMismatchErrors,
				Or@@standardIsoelectricPointMarkersVolumeConcentrationMismatchErrors,
				Or@@blankIsoelectricPointMarkersVolumeConcentrationMismatchErrors
			}
		];

		isoelectricPointMarkersVolumeConcentrationMismatchInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersVolumeConcentrationMismatchErrors]],Cache->inheritedCache]
		}];

		isoelectricPointMarkersVolumeConcentrationMismatchInvalidOptions=If[Length[isoelectricPointMarkersVolumeConcentrationMismatchOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixIsoelectricPointMarkersVolumeConcentrationMismatch,isoelectricPointMarkersVolumeConcentrationMismatchInvalidSamples];
				isoelectricPointMarkersVolumeConcentrationMismatchOptions
			),
			{}
		];

		isoelectricPointMarkersVolumeConcentrationMismatchTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersVolumeConcentrationMismatchErrors]],
					PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersVolumeConcentrationMismatchErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersVolumeConcentrationMismatchErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersVolumeConcentrationMismatchErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersVolumeConcentrationMismatchErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersVolumeConcentrationMismatchErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersVolumeConcentrationMismatchErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[isoelectricPointMarkersVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardIsoelectricPointMarkersVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankIsoelectricPointMarkersVolumeConcentrationMismatchErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the specified isoelectricPointMarkers volume and concentration are copacetic:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the specified isoelectricPointMarkers volume and concentration are copacetic:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* electroosmoticFlowBlockerNullErrors *)
		electroosmoticFlowBlockerNullOptions = PickList[
			{
				ElectroosmoticFlowBlocker,
				StandardElectroosmoticFlowBlocker,
				BlankElectroosmoticFlowBlocker
			},
			{
				Or@@electroosmoticFlowBlockerNullErrors,
				Or@@standardElectroosmoticFlowBlockerNullErrors,
				Or@@blankElectroosmoticFlowBlockerNullErrors
			}
		];

		electroosmoticFlowBlockerNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerNullErrors]],Cache->inheritedCache]
		}];

		electroosmoticFlowBlockerNullInvalidOptions=If[Length[electroosmoticFlowBlockerNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixElectroosmoticFlowBlockersNull,electroosmoticFlowBlockerNullInvalidSamples];
				electroosmoticFlowBlockerNullOptions
			),
			{}
		];

		electroosmoticFlowBlockerNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",an ElectroosmoticFlowBlocker has been specified:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",an ElectroosmoticFlowBlocker has been specified:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* noElectroosmoticFlowBlockerAgentIdentifiedWarnings *)
		noElectroosmoticFlowBlockerAgentIdentifiedOptions = PickList[
			{
				ElectroosmoticFlowBlocker,
				StandardElectroosmoticFlowBlocker,
				BlankElectroosmoticFlowBlocker
			},
			{
				Or@@noElectroosmoticFlowBlockerAgentIdentifiedWarnings,
				Or@@standardNoElectroosmoticFlowBlockerAgentIdentifiedWarnings,
				Or@@blankNoElectroosmoticFlowBlockerAgentIdentifiedWarnings
			}
		];

		noElectroosmoticFlowBlockerAgentIdentifiedInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[noElectroosmoticFlowBlockerAgentIdentifiedWarnings]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoElectroosmoticFlowBlockerAgentIdentifiedWarnings]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoElectroosmoticFlowBlockerAgentIdentifiedWarnings]],Cache->inheritedCache]
		}];

		If[MemberQ[noElectroosmoticFlowBlockerAgentIdentifiedWarnings,True]&&messages&&!engineQ,
			Message[Warning::CIEFMakeMasterMixElectroosmoticFlowBlockerComposition,ObjectToString[PickList[simulatedSamples,noElectroosmoticFlowBlockerAgentIdentifiedWarnings],Cache->inheritedCache]];
		];

		noElectroosmoticFlowBlockerAgentIdentifiedTest=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noElectroosmoticFlowBlockerAgentIdentifiedWarnings]],
					PickList[ToList[resolvedStandards],ToList[standardNoElectroosmoticFlowBlockerAgentIdentifiedWarnings]],
					PickList[ToList[resolvedBlanks],ToList[blankNoElectroosmoticFlowBlockerAgentIdentifiedWarnings]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noElectroosmoticFlowBlockerAgentIdentifiedWarnings]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoElectroosmoticFlowBlockerAgentIdentifiedWarnings]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoElectroosmoticFlowBlockerAgentIdentifiedWarnings]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noElectroosmoticFlowBlockerAgentIdentifiedWarnings],False],
					PickList[ToList[resolvedStandards],ToList[standardNoElectroosmoticFlowBlockerAgentIdentifiedWarnings],False],
					PickList[ToList[resolvedBlanks],ToList[blankNoElectroosmoticFlowBlockerAgentIdentifiedWarnings],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noElectroosmoticFlowBlockerAgentIdentifiedWarnings],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoElectroosmoticFlowBlockerAgentIdentifiedWarnings],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoElectroosmoticFlowBlockerAgentIdentifiedWarnings],False],Cache->inheritedCache]
				}];

				(* create warning for failing samples *)
				failingSampleTests=If[Length[failingSamples]>0,
					Warning["For the provided samples"<>failingString<>",the composition of the specified electroosmotic blocker object contains methyl cellulose:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Warning["For the provided samples"<>passingString<>",the composition of the specified electroosmotic blocker object contains methyl cellulose:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* electroosmoticFlowBlockerVolumeNullErrors *)
		electroosmoticFlowBlockerVolumeNullOptions = PickList[
			{
				ElectroosmoticFlowBlockerVolume,
				StandardElectroosmoticFlowBlockerVolume,
				BlankElectroosmoticFlowBlockerVolume
			},
			{
				Or@@electroosmoticFlowBlockerVolumeNullErrors,
				Or@@standardElectroosmoticFlowBlockerVolumeNullErrors,
				Or@@blankElectroosmoticFlowBlockerVolumeNullErrors
			}
		];

		electroosmoticFlowBlockerVolumeNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerVolumeNullErrors]],Cache->inheritedCache]
		}];

		electroosmoticFlowBlockerVolumeNullInvalidOptions=If[Length[electroosmoticFlowBlockerVolumeNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixElectroosmoticFlowBlockersVolumesNull,electroosmoticFlowBlockerVolumeNullInvalidSamples];
				electroosmoticFlowBlockerVolumeNullOptions
			),
			{}
		];

		electroosmoticFlowBlockerVolumeNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerVolumeNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerVolumeNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerVolumeNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerVolumeNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerVolumeNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerVolumeNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerVolumeNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerVolumeNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",a volume is specified for the electroosmotic flow blocker:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",a volume is specified for the electroosmotic flow blocker:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* electroosmoticFlowBlockerConcentrationNullErrors *)
		electroosmoticFlowBlockerConcentrationNullOptions = PickList[
			{
				ElectroosmoticFlowBlockerTargetConcentration,
				StandardElectroosmoticFlowBlockerTargetConcentration,
				BlankElectroosmoticFlowBlockerTargetConcentration
			},
			{
				Or@@electroosmoticFlowBlockerConcentrationNullErrors,
				Or@@standardElectroosmoticFlowBlockerConcentrationNullErrors,
				Or@@blankElectroosmoticFlowBlockerConcentrationNullErrors
			}
		];

		electroosmoticFlowBlockerConcentrationNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerConcentrationNullErrors]],Cache->inheritedCache]
		}];

		electroosmoticFlowBlockerConcentrationNullInvalidOptions=If[Length[electroosmoticFlowBlockerConcentrationNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixElectroosmoticFlowBlockersConcentrationNull,electroosmoticFlowBlockerConcentrationNullInvalidSamples];
				electroosmoticFlowBlockerConcentrationNullOptions
			),
			{}
		];

		electroosmoticFlowBlockerConcentrationNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerConcentrationNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerConcentrationNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerConcentrationNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerConcentrationNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerConcentrationNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerConcentrationNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerConcentrationNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[electroosmoticFlowBlockerConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardElectroosmoticFlowBlockerConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankElectroosmoticFlowBlockerConcentrationNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",a concentration has been specified for the electroosmotic flow blocker:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",a concentration has been specified for the electroosmotic flow blocker:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* eofBlockerVolumeConcentrationMismatchErrors *)
		eofBlockerVolumeConcentrationMismatchOptions = PickList[
			{
				{ElectroosmoticFlowBlockerVolume, ElectroosmoticFlowBlockerTargetConcentration},
				{StandardElectroosmoticFlowBlockerVolume, StandardElectroosmoticFlowBlockerTargetConcentration},
				{BlankElectroosmoticFlowBlockerVolume, BlankElectroosmoticFlowBlockerTargetConcentration}
			},
			{
				Or@@eofBlockerVolumeConcentrationMismatchErrors,
				Or@@standardEofBlockerVolumeConcentrationMismatchErrors,
				Or@@blankEofBlockerVolumeConcentrationMismatchErrors
			}
		];

		eofBlockerVolumeConcentrationMismatchInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[eofBlockerVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardEofBlockerVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankEofBlockerVolumeConcentrationMismatchErrors]],Cache->inheritedCache]
		}];

		eofBlockerVolumeConcentrationMismatchInvalidOptions=If[Length[eofBlockerVolumeConcentrationMismatchOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixElectroosmoticFlowBlockersVolumeConcentrationMismatch,eofBlockerVolumeConcentrationMismatchInvalidSamples];
				eofBlockerVolumeConcentrationMismatchOptions
			),
			{}
		];

		eofBlockerVolumeConcentrationMismatchTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[eofBlockerVolumeConcentrationMismatchErrors]],
					PickList[ToList[resolvedStandards],ToList[standardEofBlockerVolumeConcentrationMismatchErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankEofBlockerVolumeConcentrationMismatchErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[eofBlockerVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardEofBlockerVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankEofBlockerVolumeConcentrationMismatchErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[eofBlockerVolumeConcentrationMismatchErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardEofBlockerVolumeConcentrationMismatchErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankEofBlockerVolumeConcentrationMismatchErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[eofBlockerVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardEofBlockerVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankEofBlockerVolumeConcentrationMismatchErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the specified volume and concentration for the electroosmotic flow blocker are in agreement:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the specified volume and concentration for the electroosmotic flow blocker are in agreement:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* denatureFalseOptionsSpecifiedErrors *)
		denatureFalseOptionsSpecifiedOptions = PickList[
			{
				Denature,
				StandardDenature,
				BlankDenature
			},
			{
				Or@@denatureFalseOptionsSpecifiedErrors,
				Or@@standardDenatureFalseOptionsSpecifiedErrors,
				Or@@blankDenatureFalseOptionsSpecifiedErrors
			}
		];

		denatureFalseOptionsSpecifiedInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[denatureFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenatureFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenatureFalseOptionsSpecifiedErrors]],Cache->inheritedCache]
		}];

		denatureFalseOptionsSpecifiedInvalidOptions=If[Length[denatureFalseOptionsSpecifiedOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixDenatureFalseOptionsSpecifiedErrors,denatureFalseOptionsSpecifiedInvalidSamples];
				denatureFalseOptionsSpecifiedOptions
			),
			{}
		];

		denatureFalseOptionsSpecifiedTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[denatureFalseOptionsSpecifiedErrors]],
					PickList[ToList[resolvedStandards],ToList[standardDenatureFalseOptionsSpecifiedErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankDenatureFalseOptionsSpecifiedErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[denatureFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenatureFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenatureFalseOptionsSpecifiedErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[denatureFalseOptionsSpecifiedErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardDenatureFalseOptionsSpecifiedErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankDenatureFalseOptionsSpecifiedErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[denatureFalseOptionsSpecifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenatureFalseOptionsSpecifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenatureFalseOptionsSpecifiedErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>", denaturation options have not been specified if Denature->False:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>", denaturation options have not been specified if Denature->False:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* denaturationReagentNullErrors *)
		denaturationReagentNullOptions = PickList[
			{
				DenaturationReagent,
				StandardDenaturationReagent,
				BlankDenaturationReagent
			},
			{
				Or@@denaturationReagentNullErrors,
				Or@@standardDenaturationReagentNullErrors,
				Or@@blankDenaturationReagentNullErrors
			}
		];

		denaturationReagentNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentNullErrors]],Cache->inheritedCache]
		}];

		denaturationReagentNullInvalidOptions=If[Length[denaturationReagentNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixDenaturationReagentsNull,denaturationReagentNullInvalidSamples];
				denaturationReagentNullOptions
			),
			{}
		];

		denaturationReagentNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[denaturationReagentNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[denaturationReagentNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",an DenaturationReagent has been specified:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",an DenaturationReagent has been specified:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* noDenaturationReagentIdentifiedWarnings *)
		noDenaturationReagentIdentifiedOptions = PickList[
			{
				DenaturationReagent,
				StandardDenaturationReagent,
				BlankDenaturationReagent
			},
			{
				Or@@noDenaturationReagentIdentifiedErrors,
				Or@@standardNoDenaturationReagentIdentifiedErrors,
				Or@@blankNoDenaturationReagentIdentifiedErrors
			}
		];

		noDenaturationReagentIdentifiedInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[noDenaturationReagentIdentifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoDenaturationReagentIdentifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoDenaturationReagentIdentifiedErrors]],Cache->inheritedCache]
		}];

		If[MemberQ[noDenaturationReagentIdentifiedErrors,True]&&messages&&!engineQ,
			Message[Warning::CIEFMakeMasterMixDenaturationReagentComposition,noDenaturationReagentIdentifiedInvalidSamples];
		];

		noDenaturationReagentIdentifiedTest=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noDenaturationReagentIdentifiedErrors]],
					PickList[ToList[resolvedStandards],ToList[standardNoDenaturationReagentIdentifiedErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankNoDenaturationReagentIdentifiedErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noDenaturationReagentIdentifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoDenaturationReagentIdentifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoDenaturationReagentIdentifiedErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noDenaturationReagentIdentifiedErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardNoDenaturationReagentIdentifiedErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankNoDenaturationReagentIdentifiedErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noDenaturationReagentIdentifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoDenaturationReagentIdentifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoDenaturationReagentIdentifiedErrors],False],Cache->inheritedCache]
				}];

				(* create warning for failing samples *)
				failingSampleTests=If[Length[failingSamples]>0,
					Warning["For the provided samples"<>failingString<>",the composition of the specified electroosmotic blocker object contains methyl cellulose:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Warning["For the provided samples"<>passingString<>",the composition of the specified electroosmotic blocker object contains methyl cellulose:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* denaturationReagentVolumeNullErrors *)
		denaturationReagentVolumeNullOptions = PickList[
			{
				DenaturationReagentVolume,
				StandardDenaturationReagentVolume,
				BlankDenaturationReagentVolume
			},
			{
				Or@@denaturationReagentVolumeNullErrors,
				Or@@standardDenaturationReagentVolumeNullErrors,
				Or@@blankDenaturationReagentVolumeNullErrors
			}
		];

		denaturationReagentVolumeNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentVolumeNullErrors]],Cache->inheritedCache]
		}];
		denaturationReagentVolumeNullInvalidOptions=If[Length[denaturationReagentVolumeNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixDenaturationReagentsVolumesNull,denaturationReagentVolumeNullInvalidSamples];
				denaturationReagentVolumeNullOptions
			),
			{}
		];

		denaturationReagentVolumeNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[denaturationReagentVolumeNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentVolumeNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentVolumeNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentVolumeNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[denaturationReagentVolumeNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentVolumeNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentVolumeNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentVolumeNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",a volume is specified for the electroosmotic flow blocker:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",a volume is specified for the electroosmotic flow blocker:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* denaturationReagentConcentrationNullErrors *)
		denaturationReagentConcentrationNullOptions = PickList[
			{
				DenaturationReagentTargetConcentrations,
				StandardDenaturationReagentTargetConcentrations,
				BlankDenaturationReagentTargetConcentrations
			},
			{
				Or@@denaturationReagentConcentrationNullErrors,
				Or@@standardDenaturationReagentConcentrationNullErrors,
				Or@@blankDenaturationReagentConcentrationNullErrors
			}
		];

		denaturationReagentConcentrationNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentConcentrationNullErrors]],Cache->inheritedCache]
		}];

		denaturationReagentConcentrationNullInvalidOptions=If[Length[denaturationReagentConcentrationNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixDenaturationReagentsConcentrationNull,denaturationReagentConcentrationNullInvalidSamples];
				denaturationReagentConcentrationNullOptions
			),
			{}
		];

		denaturationReagentConcentrationNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[denaturationReagentConcentrationNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentConcentrationNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentConcentrationNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentConcentrationNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[denaturationReagentConcentrationNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentConcentrationNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentConcentrationNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentConcentrationNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",a concentration has been specified for the electroosmotic flow blocker:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",a concentration has been specified for the electroosmotic flow blocker:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* denaturationReagentConcentrationVolumeMismatchErrors *)
		denaturationReagentConcentrationVolumeMismatchOptions = PickList[
			{
				{DenaturationReagentVolume, DenaturationReagentTargetConcentrations},
				{StandardDenaturationReagentVolume, StandardDenaturationReagentTargetConcentrations},
				{BlankDenaturationReagentVolume, BlankDenaturationReagentTargetConcentrations}
			},
			{
				Or@@denaturationReagentConcentrationVolumeMismatchErrors,
				Or@@standardDenaturationReagentConcentrationVolumeMismatchErrors,
				Or@@blankDenaturationReagentConcentrationVolumeMismatchErrors
			}
		];

		denaturationReagentConcentrationVolumeMismatchInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentConcentrationVolumeMismatchErrors]],Cache->inheritedCache]
		}];

		denaturationReagentConcentrationVolumeMismatchInvalidOptions=If[Length[denaturationReagentConcentrationVolumeMismatchOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixDenaturationReagentsVolumeConcentrationMismatch,denaturationReagentConcentrationVolumeMismatchInvalidSamples];
				denaturationReagentConcentrationVolumeMismatchOptions
			),
			{}
		];

		denaturationReagentConcentrationVolumeMismatchTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[denaturationReagentConcentrationVolumeMismatchErrors]],
					PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentConcentrationVolumeMismatchErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentConcentrationVolumeMismatchErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentConcentrationVolumeMismatchErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[denaturationReagentConcentrationVolumeMismatchErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentConcentrationVolumeMismatchErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentConcentrationVolumeMismatchErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentConcentrationVolumeMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentConcentrationVolumeMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentConcentrationVolumeMismatchErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",when Denature is True, denaturation volume and target concentration are in agreement:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",when Denature is True, denaturation volume and target concentration are in agreement:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* resolveableDenatureReagentConcentrationUnitMismatchErrors *)
		resolveableDenatureReagentConcentrationUnitMismatchOptions = PickList[
			{
				DenaturationReagentTargetConcentrations,
				StandardDenaturationReagentTargetConcentrations,
				BlankDenaturationReagentTargetConcentrations
			},
			{
				Or@@resolveableDenatureReagentConcentrationUnitMismatchErrors,
				Or@@standardResolveableDenatureReagentConcentrationUnitMismatchErrors,
				Or@@blankResolveableDenatureReagentConcentrationUnitMismatchErrors
			}
		];

		resolveableDenatureReagentConcentrationUnitMismatchInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[resolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardResolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankResolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache]
		}];

		If[Length[resolveableDenatureReagentConcentrationUnitMismatchOptions]>0&&messages&&!engineQ,
			Message[Warning::CIEFresolveableDenatureReagentConcentrationUnitMismatch,resolveableDenatureReagentConcentrationUnitMismatchInvalidSamples];
		];

		resolveableDenatureReagentConcentrationUnitMismatchTest=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[resolveableDenatureReagentConcentrationUnitMismatchErrors]],
					PickList[ToList[resolvedStandards],ToList[standardResolveableDenatureReagentConcentrationUnitMismatchErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankResolveableDenatureReagentConcentrationUnitMismatchErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[resolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardResolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankResolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[resolveableDenatureReagentConcentrationUnitMismatchErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardResolveableDenatureReagentConcentrationUnitMismatchErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankResolveableDenatureReagentConcentrationUnitMismatchErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[resolveableDenatureReagentConcentrationUnitMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardResolveableDenatureReagentConcentrationUnitMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankResolveableDenatureReagentConcentrationUnitMismatchErrors],False],Cache->inheritedCache]
				}];


				(* create warning for failing samples *)
				failingSampleTests=If[Length[failingSamples]>0,
					Warning["For the provided samples"<>failingString<>",denaturation agent volume can still be resolved when target concentration is in volume percent and the reagent in molar concentration:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Warning["For the provided samples"<>passingString<>",denaturation agent volume can still be resolved when target concentration is in volume percent and the reagent in molar concentration:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* unresolveableDenatureReagentConcentrationUnitMismatchErrors *)
		unresolveableDenatureReagentConcentrationUnitMismatchOptions = PickList[
			{
				{DenaturationReagent, DenaturationReagentTargetConcentrations},
				{StandardDenaturationReagent, StandardDenaturationReagentTargetConcentrations},
				{BlankDenaturationReagent, BlankDenaturationReagentTargetConcentrations}
			},
			{
				Or@@unresolveableDenatureReagentConcentrationUnitMismatchErrors,
				Or@@standardUnresolveableDenatureReagentConcentrationUnitMismatchErrors,
				Or@@blankUnresolveableDenatureReagentConcentrationUnitMismatchErrors
			}
		];

		unresolveableDenatureReagentConcentrationUnitMismatchInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[unresolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardUnresolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankUnresolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache]
		}];

		unresolveableDenatureReagentConcentrationUnitMismatchInvalidOptions=If[Length[unresolveableDenatureReagentConcentrationUnitMismatchOptions]>0&&messages,
			(
				Message[Error::CIEFunresolveableDenatureReagentConcentrationUnitMismatch,unresolveableDenatureReagentConcentrationUnitMismatchInvalidSamples];
				unresolveableDenatureReagentConcentrationUnitMismatchOptions
			),
			{}
		];

		unresolveableDenatureReagentConcentrationUnitMismatchTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[unresolveableDenatureReagentConcentrationUnitMismatchErrors]],
					PickList[ToList[resolvedStandards],ToList[standardUnresolveableDenatureReagentConcentrationUnitMismatchErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankUnresolveableDenatureReagentConcentrationUnitMismatchErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[unresolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardUnresolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankUnresolveableDenatureReagentConcentrationUnitMismatchErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[unresolveableDenatureReagentConcentrationUnitMismatchErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardUnresolveableDenatureReagentConcentrationUnitMismatchErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankUnresolveableDenatureReagentConcentrationUnitMismatchErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[denaturationReagentConcentrationVolumeMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDenaturationReagentConcentrationVolumeMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDenaturationReagentConcentrationVolumeMismatchErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the denaturation reagent and target concentration can be used to resolve the volume:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the denaturation reagent and target concentration can be used to resolve the volume:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* anodicSpacerFalseOptionsSpecifiedErrors *)
		anodicSpacerFalseOptionsSpecifiedOptions = PickList[
			{
				AnodicSpacer,
				StandardAnodicSpacer,
				BlankAnodicSpacer
			},
			{
				Or@@anodicSpacerFalseOptionsSpecifiedErrors,
				Or@@standardAnodicSpacerFalseOptionsSpecifiedErrors,
				Or@@blankAnodicSpacerFalseOptionsSpecifiedErrors
			}
		];

		anodicSpacerFalseOptionsSpecifiedInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache]
		}];

		anodicSpacerFalseOptionsSpecifiedInvalidOptions=If[Length[anodicSpacerFalseOptionsSpecifiedOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixAnodicSpacerFalseOptionsSpecifiedErrors,anodicSpacerFalseOptionsSpecifiedInvalidSamples];
				anodicSpacerFalseOptionsSpecifiedOptions
			),
			{}
		];

		anodicSpacerFalseOptionsSpecifiedTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[anodicSpacerFalseOptionsSpecifiedErrors]],
					PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerFalseOptionsSpecifiedErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerFalseOptionsSpecifiedErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[anodicSpacerFalseOptionsSpecifiedErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerFalseOptionsSpecifiedErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerFalseOptionsSpecifiedErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerFalseOptionsSpecifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerFalseOptionsSpecifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerFalseOptionsSpecifiedErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>", anodic spacer options have not been specified if AnodicSpacer->False:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>", anodic spacer options have not been specified if AnodicSpacer->False:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* anodicSpacerNullErrors *)
		anodicSpacerNullOptions = PickList[
			{
				AnodicSpacer,
				StandardAnodicSpacer,
				BlankAnodicSpacer
			},
			{
				Or@@anodicSpacerNullErrors,
				Or@@standardAnodicSpacerNullErrors,
				Or@@blankAnodicSpacerNullErrors
			}
		];

		anodicSpacerNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerNullErrors]],Cache->inheritedCache]
		}];

		anodicSpacerNullInvalidOptions=If[Length[anodicSpacerNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixAnodicSpacersNull,anodicSpacerNullInvalidSamples];
				anodicSpacerNullOptions
			),
			{}
		];

		anodicSpacerNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[anodicSpacerNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[anodicSpacerNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",an AnodicSpacer has been specified:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",an AnodicSpacer has been specified:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* noAnodicSpacerIdentifiedWarnings *)
		noAnodicSpacerIdentifiedOptions = PickList[
			{
				AnodicSpacer,
				StandardAnodicSpacer,
				BlankAnodicSpacer
			},
			{
				Or@@noAnodicSpacerIdentifiedErrors,
				Or@@standardNoAnodicSpacerIdentifiedErrors,
				Or@@blankNoAnodicSpacerIdentifiedErrors
			}
		];

		noAnodicSpacerIdentifiedInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[noAnodicSpacerIdentifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoAnodicSpacerIdentifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoAnodicSpacerIdentifiedErrors]],Cache->inheritedCache]
		}];

		If[Length[noAnodicSpacerIdentifiedOptions]>0&&messages&&!engineQ,
			Message[Warning::CIEFMakeMasterMixAnodicSpacerComposition,noAnodicSpacerIdentifiedInvalidSamples];
		];

		noAnodicSpacerIdentifiedTest=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noAnodicSpacerIdentifiedErrors]],
					PickList[ToList[resolvedStandards],ToList[standardNoAnodicSpacerIdentifiedErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankNoAnodicSpacerIdentifiedErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noAnodicSpacerIdentifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoAnodicSpacerIdentifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoAnodicSpacerIdentifiedErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noAnodicSpacerIdentifiedErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardNoAnodicSpacerIdentifiedErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankNoAnodicSpacerIdentifiedErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noAnodicSpacerIdentifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoAnodicSpacerIdentifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoAnodicSpacerIdentifiedErrors],False],Cache->inheritedCache]
				}];

				(* create warning for failing samples *)
				failingSampleTests=If[Length[failingSamples]>0,
					Warning["For the provided samples"<>failingString<>",the composition of the specified electroosmotic blocker object contains methyl cellulose:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Warning["For the provided samples"<>passingString<>",the composition of the specified electroosmotic blocker object contains methyl cellulose:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* anodicSpacerVolumeNullErrors *)
		anodicSpacerVolumeNullOptions = PickList[
			{
				AnodicSpacerVolume,
				StandardAnodicSpacerVolume,
				BlankAnodicSpacerVolume
			},
			{
				Or@@anodicSpacerVolumeNullErrors,
				Or@@standardAnodicSpacerVolumeNullErrors,
				Or@@blankAnodicSpacerVolumeNullErrors
			}
		];

		anodicSpacerVolumeNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerVolumeNullErrors]],Cache->inheritedCache]
		}];

		anodicSpacerVolumeNullInvalidOptions=If[Length[anodicSpacerVolumeNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixAnodicSpacersVolumesNull,anodicSpacerVolumeNullInvalidSamples];
				anodicSpacerVolumeNullOptions
			),
			{}
		];

		anodicSpacerVolumeNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[anodicSpacerVolumeNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerVolumeNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerVolumeNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerVolumeNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[anodicSpacerVolumeNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerVolumeNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerVolumeNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerVolumeNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",a volume is specified for the electroosmotic flow blocker:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",a volume is specified for the electroosmotic flow blocker:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* anodicSpacerConcentrationNullErrors *)
		anodicSpacerConcentrationNullOptions = PickList[
			{
				AnodicSpacerTargetConcentrations,
				StandardAnodicSpacerTargetConcentrations,
				BlankAnodicSpacerTargetConcentrations
			},
			{
				Or@@anodicSpacerConcentrationNullErrors,
				Or@@standardAnodicSpacerConcentrationNullErrors,
				Or@@blankAnodicSpacerConcentrationNullErrors
			}
		];

		anodicSpacerConcentrationNullSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerConcentrationNullErrors]],Cache->inheritedCache]
		}];

		anodicSpacerConcentrationNullInvalidOptions=If[Length[anodicSpacerConcentrationNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixAnodicSpacersConcentrationNull,anodicSpacerConcentrationNullSamples];
				anodicSpacerConcentrationNullOptions
			),
			{}
		];

		anodicSpacerConcentrationNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[anodicSpacerConcentrationNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerConcentrationNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerConcentrationNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerConcentrationNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[anodicSpacerConcentrationNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerConcentrationNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerConcentrationNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerConcentrationNullErrors],False],Cache->inheritedCache]
				}];


				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",a concentration has been specified for the electroosmotic flow blocker:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",a concentration has been specified for the electroosmotic flow blocker:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* anodicSpacerConcentrationVolumeMismatchErrors *)
		anodicSpacerConcentrationVolumeMismatchOptions = PickList[
			{
				{AnodicSpacerVolume,AnodicSpacerTargetConcentration},
				{StandardAnodicSpacerVolume,StandardAnodicSpacerTargetConcentration},
				{BlankAnodicSpacerVolume,BlankAnodicSpacerTargetConcentration}
			},
			{
				Or@@anodicSpacerConcentrationVolumeMismatchErrors,
				Or@@standardAnodicSpacerConcentrationVolumeMismatchErrors,
				Or@@blankAnodicSpacerConcentrationVolumeMismatchErrors
			}
		];

		anodicSpacerConcentrationVolumeMismatchInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache]
		}];

		anodicSpacerConcentrationVolumeMismatchInvalidOptions=If[Length[anodicSpacerConcentrationVolumeMismatchOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixAnodicSpacersVolumeConcentrationMismatch,anodicSpacerConcentrationVolumeMismatchInvalidSamples];
				anodicSpacerConcentrationVolumeMismatchOptions
			),
			{}
		];

		anodicSpacerConcentrationVolumeMismatchTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[anodicSpacerConcentrationVolumeMismatchErrors]],
					PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerConcentrationVolumeMismatchErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerConcentrationVolumeMismatchErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[anodicSpacerConcentrationVolumeMismatchErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerConcentrationVolumeMismatchErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerConcentrationVolumeMismatchErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[anodicSpacerConcentrationVolumeMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAnodicSpacerConcentrationVolumeMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAnodicSpacerConcentrationVolumeMismatchErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",when Denature is True, denaturation volume and target concentration are in agreement:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",when Denature is True, denaturation volume and target concentration are in agreement:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* cathodicSpacerFalseOptionsSpecifiedErrors *)
		cathodicSpacerFalseOptionsSpecifiedOptions = PickList[
			{
				CathodicSpacer,
				StandardCathodicSpacer,
				BlankCathodicSpacer
			},
			{
				Or@@cathodicSpacerFalseOptionsSpecifiedErrors,
				Or@@standardCathodicSpacerFalseOptionsSpecifiedErrors,
				Or@@blankCathodicSpacerFalseOptionsSpecifiedErrors
			}
		];

		cathodicSpacerFalseOptionsSpecifiedInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache]
		}];

		cathodicSpacerFalseOptionsSpecifiedInvalidOptions=If[Length[cathodicSpacerFalseOptionsSpecifiedOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixCathodicSpacerFalseOptionsSpecifiedErrors,cathodicSpacerFalseOptionsSpecifiedInvalidSamples];
				cathodicSpacerFalseOptionsSpecifiedOptions
			),
			{}
		];

		cathodicSpacerFalseOptionsSpecifiedTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[cathodicSpacerFalseOptionsSpecifiedErrors]],
					PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerFalseOptionsSpecifiedErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerFalseOptionsSpecifiedErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerFalseOptionsSpecifiedErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[cathodicSpacerFalseOptionsSpecifiedErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerFalseOptionsSpecifiedErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerFalseOptionsSpecifiedErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerFalseOptionsSpecifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerFalseOptionsSpecifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerFalseOptionsSpecifiedErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>", cathodic spacer options have not been specified if CathodicSpacer->False:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>", cathodic spacer options have not been specified if CathodicSpacer->False:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* cathodicSpacerNullErrors *)
		cathodicSpacerNullOptions = PickList[
			{
				CathodicSpacer,
				StandardCathodicSpacer,
				BlankCathodicSpacer
			},
			{
				Or@@cathodicSpacerNullErrors,
				Or@@standardCathodicSpacerNullErrors,
				Or@@blankCathodicSpacerNullErrors
			}
		];

		cathodicSpacerNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerNullErrors]],Cache->inheritedCache]
		}];

		cathodicSpacerNullInvalidOptions=If[Length[cathodicSpacerNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixCathodicSpacersNull,cathodicSpacerNullInvalidSamples];
				cathodicSpacerNullOptions
			),
			{}
		];

		cathodicSpacerNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[cathodicSpacerNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[cathodicSpacerNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",an CathodicSpacer has been specified:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",an CathodicSpacer has been specified:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* noCathodicSpacerIdentifiedWarnings *)
		noCathodicSpacerIdentifiedOptions = PickList[
			{
				CathodicSpacer,
				StandardCathodicSpacer,
				BlankCathodicSpacer
			},
			{
				Or@@noCathodicSpacerIdentifiedErrors,
				Or@@standardNoCathodicSpacerIdentifiedErrors,
				Or@@blankNoCathodicSpacerIdentifiedErrors
			}
		];

		noCathodicSpacerIdentifiedInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[noCathodicSpacerIdentifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoCathodicSpacerIdentifiedErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoCathodicSpacerIdentifiedErrors]],Cache->inheritedCache]
		}];

		If[Length[noCathodicSpacerIdentifiedOptions]>0&&messages&&!engineQ,
			Message[Warning::CIEFMakeMasterMixCathodicSpacerComposition,noCathodicSpacerIdentifiedInvalidSamples];
		];

		noCathodicSpacerIdentifiedTest=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noCathodicSpacerIdentifiedErrors]],
					PickList[ToList[resolvedStandards],ToList[standardNoCathodicSpacerIdentifiedErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankNoCathodicSpacerIdentifiedErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noCathodicSpacerIdentifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoCathodicSpacerIdentifiedErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoCathodicSpacerIdentifiedErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[noCathodicSpacerIdentifiedErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardNoCathodicSpacerIdentifiedErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankNoCathodicSpacerIdentifiedErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[noCathodicSpacerIdentifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoCathodicSpacerIdentifiedErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoCathodicSpacerIdentifiedErrors],False],Cache->inheritedCache]
				}];

				(* create warning for failing samples *)
				failingSampleTests=If[Length[failingSamples]>0,
					Warning["For the provided samples"<>failingString<>",the composition of the specified electroosmotic blocker object contains methyl cellulose:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Warning["For the provided samples"<>passingString<>",the composition of the specified electroosmotic blocker object contains methyl cellulose:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* cathodicSpacerVolumeNullErrors *)
		cathodicSpacerVolumeNullOptions = PickList[
			{
				CathodicSpacerVolume,
				StandardCathodicSpacerVolume,
				BlankCathodicSpacerVolume
			},
			{
				Or@@cathodicSpacerVolumeNullErrors,
				Or@@standardCathodicSpacerVolumeNullErrors,
				Or@@blankCathodicSpacerVolumeNullErrors
			}
		];

		cathodicSpacerVolumeNullInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerVolumeNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerVolumeNullErrors]],Cache->inheritedCache]
		}];

		cathodicSpacerVolumeNullInvalidOptions=If[Length[cathodicSpacerVolumeNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixCathodicSpacersVolumesNull,cathodicSpacerVolumeNullInvalidSamples];
				cathodicSpacerVolumeNullOptions
			),
			{}
		];

		cathodicSpacerVolumeNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[cathodicSpacerVolumeNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerVolumeNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerVolumeNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerVolumeNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerVolumeNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[cathodicSpacerVolumeNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerVolumeNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerVolumeNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerVolumeNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerVolumeNullErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",a volume is specified for the electroosmotic flow blocker:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",a volume is specified for the electroosmotic flow blocker:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* cathodicSpacerConcentrationNullErrors *)
		cathodicSpacerConcentrationNullOptions = PickList[
			{
				CathodicSpacerTargetConcentrations,
				StandardCathodicSpacerTargetConcentrations,
				BlankCathodicSpacerTargetConcentrations
			},
			{
				Or@@cathodicSpacerConcentrationNullErrors,
				Or@@standardCathodicSpacerConcentrationNullErrors,
				Or@@blankCathodicSpacerConcentrationNullErrors
			}
		];

		cathodicSpacerConcentrationNullSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerConcentrationNullErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerConcentrationNullErrors]],Cache->inheritedCache]
		}];

		cathodicSpacerConcentrationNullInvalidOptions=If[Length[cathodicSpacerConcentrationNullOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixCathodicSpacersConcentrationNull,cathodicSpacerConcentrationNullSamples];
				cathodicSpacerConcentrationNullOptions
			),
			{}
		];

		cathodicSpacerConcentrationNullTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[cathodicSpacerConcentrationNullErrors]],
					PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerConcentrationNullErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerConcentrationNullErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerConcentrationNullErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerConcentrationNullErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[cathodicSpacerConcentrationNullErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerConcentrationNullErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerConcentrationNullErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerConcentrationNullErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerConcentrationNullErrors],False],Cache->inheritedCache]
				}];


				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",a concentration has been specified for the electroosmotic flow blocker:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",a concentration has been specified for the electroosmotic flow blocker:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* cathodicSpacerConcentrationVolumeMismatchErrors *)
		cathodicSpacerConcentrationVolumeMismatchOptions = PickList[
			{
				{CathodicSpacerVolume,CathodicSpacerTargetConcentration},
				{StandardCathodicSpacerVolume,StandardCathodicSpacerTargetConcentration},
				{BlankCathodicSpacerVolume,BlankCathodicSpacerTargetConcentration}
			},
			{
				Or@@cathodicSpacerConcentrationVolumeMismatchErrors,
				Or@@standardCathodicSpacerConcentrationVolumeMismatchErrors,
				Or@@blankCathodicSpacerConcentrationVolumeMismatchErrors
			}
		];

		cathodicSpacerConcentrationVolumeMismatchInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache]
		}];

		cathodicSpacerConcentrationVolumeMismatchInvalidOptions=If[Length[cathodicSpacerConcentrationVolumeMismatchOptions]>0&&messages,
			(
				Message[Error::CIEFMakeMasterMixCathodicSpacersVolumeConcentrationMismatch,cathodicSpacerConcentrationVolumeMismatchInvalidSamples];
				cathodicSpacerConcentrationVolumeMismatchOptions
			),
			{}
		];

		cathodicSpacerConcentrationVolumeMismatchTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[cathodicSpacerConcentrationVolumeMismatchErrors]],
					PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerConcentrationVolumeMismatchErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerConcentrationVolumeMismatchErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerConcentrationVolumeMismatchErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[cathodicSpacerConcentrationVolumeMismatchErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerConcentrationVolumeMismatchErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerConcentrationVolumeMismatchErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[cathodicSpacerConcentrationVolumeMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardCathodicSpacerConcentrationVolumeMismatchErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankCathodicSpacerConcentrationVolumeMismatchErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",when Denature is True, denaturation volume and target concentration are in agreement:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",when Denature is True, denaturation volume and target concentration are in agreement:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];

		(* sumOfVolumesOverTotalvolumeErrors *)
		(* Pick only options that were specified by the user, to avoid displaying a ton of different options that may be irrelevant *)
		sumOfVolumesOverTotalvolumeOptions = PickList[
			{
				Intersection[{TotalVolume, SampleVolume, AmpholyteVolume,IsoelectricPointMarkersVolume,DenaturationReagentVolume,AnodicSpacerVolume,CathodicSpacerVolume},unresolvedOptionsKeys],
				Intersection[{StandardTotalVolume, StandardVolume, StandardAmpholyteVolume,StandardIsoelectricPointMarkersVolume,StandardDenaturationReagentVolume,StandardAnodicSpacerVolume,StandardCathodicSpacerVolume},unresolvedOptionsKeys],
				Intersection[{BlankTotalVolume, BlankVolume, BlankAmpholyteVolume,BlankIsoelectricPointMarkersVolume,BlankDenaturationReagentVolume,BlankAnodicSpacerVolume,BlankCathodicSpacerVolume},unresolvedOptionsKeys]
			},
			{
				Or@@sumOfVolumesOverTotalvolumeErrors,
				Or@@standardSumOfVolumesOverTotalvolumeErrors,
				Or@@blankSumOfVolumesOverTotalvolumeErrors
			}
		];

		sumOfVolumesOverTotalvolumeInvalidSamples =combineObjectStrings[{
			ObjectToString[PickList[ToList[simulatedSamples],ToList[sumOfVolumesOverTotalvolumeErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedStandards],ToList[standardSumOfVolumesOverTotalvolumeErrors]],Cache->inheritedCache],
			ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankSumOfVolumesOverTotalvolumeErrors]],Cache->inheritedCache]
		}];

		sumOfVolumesOverTotalvolumeInvalidOptions=If[Length[sumOfVolumesOverTotalvolumeOptions]>0&&messages,
			(
				Message[Error::CIEFSumOfVolumesOverTotalVolume,sumOfVolumesOverTotalvolumeInvalidSamples];
				sumOfVolumesOverTotalvolumeOptions
			),
			{}
		];

		sumOfVolumesOverTotalvolumeTests=If[gatherTests,
			Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
				passingString},

				(* get the inputs that fail this test *)
				failingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[sumOfVolumesOverTotalvolumeErrors]],
					PickList[ToList[resolvedStandards],ToList[standardSumOfVolumesOverTotalvolumeErrors]],
					PickList[ToList[resolvedBlanks],ToList[blankSumOfVolumesOverTotalvolumeErrors]]
				];

				failingString =combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[sumOfVolumesOverTotalvolumeErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardSumOfVolumesOverTotalvolumeErrors]],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankSumOfVolumesOverTotalvolumeErrors]],Cache->inheritedCache]
				}];

				(* get the inputs that pass this test *)
				passingSamples=Join[
					PickList[ToList[simulatedSamples],ToList[sumOfVolumesOverTotalvolumeErrors],False],
					PickList[ToList[resolvedStandards],ToList[standardSumOfVolumesOverTotalvolumeErrors],False],
					PickList[ToList[resolvedBlanks],ToList[blankSumOfVolumesOverTotalvolumeErrors],False]
				];

				passingString=combineObjectStrings[{
					ObjectToString[PickList[ToList[simulatedSamples],ToList[sumOfVolumesOverTotalvolumeErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedStandards],ToList[standardSumOfVolumesOverTotalvolumeErrors],False],Cache->inheritedCache],
					ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankSumOfVolumesOverTotalvolumeErrors],False],Cache->inheritedCache]
				}];

				(* create a test for the non-passing inputs *)
				failingSampleTests=If[Length[failingSamples]>0,
					Test["For the provided samples "<>failingString<>",the sum total of all reagents in the assay tube does not exceed the TotalVolume:",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSampleTests=If[Length[passingSamples]>0,
					Test["For the provided samples "<>passingString<>",the sum total of all reagents in the assay tube does not exceed the TotalVolume:",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{passingSampleTests,failingSampleTests}
			]
		];


		(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub or Upload -> False *)
		resolvedEmail=Which[
			MatchQ[email,Except[Automatic]],email,
			MatchQ[email,Automatic]&&NullQ[Lookup[roundedCapillaryIsoelectricFocusingOptions,ParentProtocol]]&&TrueQ[upload]&&MemberQ[output,Result],True,
			True,False
		];


		(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
		invalidInputs=DeleteDuplicates[Flatten[{
			deprecatedInvalidInputs,
			discardedInvalidInputs,
			compatibleMaterialsInvalidInputs,
			nameInvalidOptions

		}]];

		invalidOptions=DeleteDuplicates[Flatten[{
			incompatibleCartridgeInvalidOption,
			discardedCartridgeInvalidOption,
			blanksFalseOptionsSpecifiedInvalidOption,
			standardsFalseOptionsSpecifiedInvalidOption,
			sampleCountInvalidOption,
			notEnoughUsesLeftOption,
			injectionTableWithReplicatesInvalidOption,
			injectionTableVolumeZeroInvalidOption,
			invalidInjectionTableOption,
			nullTotalVolumeErrorsOptions,
			includeTrueFrequencyNullOptions,
			loadTimeNullOptions,
			onBoardMixingIncompatibleVolumesInvalidOptions,
			onBoardMixingInvalidOptions,
			imagingMethodMismatchInvalidOptions,
			voltageDurationStepInvalidOptions,
			premadeMastermixFalseOptionsSpecifiedInvalidSamples,
			premadeMasterMixDilutionFactorNullInvalidOptions,
			premadeMasterMixVolumeNullInvalidOptions,
			premadeMasterMixVolumeDilutionFactorMismatchInvalidOptions,
			premadeMasterMixTotalVolumeInvalidOptions,
			premadeMasterMixDiluentNullInvalidOptions,
			premadeMasterMixNullInvalidOptions,
			nullDiluentInvalidOptions,
			noSpecifiedAmpholytesInvalidOptions,
			ampholyteMatchedlengthsNotCopaceticInvalidOptions,
			ampholyteVolumeNullInvalidOptions,
			ampholyteConcentrationNullErrorsInvalidOptions,
			ampholyteVolumeConcentrationMismatchInvalidOptions,
			noSpecifiedIsoelectricPointMarkersInvalidOptions,
			resolverCantFixIsoelectricPointMarkersMismatchInvalidOptions,
			isoelectricPointMarkersVolumeNullInvalidOptions,
			isoelectricPointMarkersConcentrationNullErrorsInvalidOptions,
			isoelectricPointMarkersVolumeConcentrationMismatchInvalidOptions,
			electroosmoticFlowBlockerNullInvalidOptions,
			electroosmoticFlowBlockerVolumeNullInvalidOptions,
			electroosmoticFlowBlockerConcentrationNullInvalidOptions,
			eofBlockerVolumeConcentrationMismatchInvalidOptions,
			denatureFalseOptionsSpecifiedInvalidOptions,
			denaturationReagentNullInvalidOptions,
			denaturationReagentVolumeNullInvalidOptions,
			denaturationReagentConcentrationNullInvalidOptions,
			denaturationReagentConcentrationVolumeMismatchInvalidOptions,
			unresolveableDenatureReagentConcentrationUnitMismatchInvalidOptions,
			anodicSpacerFalseOptionsSpecifiedInvalidOptions,
			anodicSpacerNullInvalidOptions,
			anodicSpacerVolumeNullInvalidOptions,
			anodicSpacerConcentrationNullInvalidOptions,
			anodicSpacerConcentrationVolumeMismatchInvalidOptions,
			cathodicSpacerFalseOptionsSpecifiedInvalidOptions,
			cathodicSpacerNullInvalidOptions,
			cathodicSpacerVolumeNullInvalidOptions,
			cathodicSpacerConcentrationNullInvalidOptions,
			cathodicSpacerConcentrationVolumeMismatchInvalidOptions,
			sumOfVolumesOverTotalvolumeInvalidOptions
		}]];

		(* Throw Error::InvalidInput if there are invalid inputs. *)
		If[Length[invalidInputs]>0&&!gatherTests,
			Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->inheritedCache]]
		];

		(* Throw Error::InvalidOption if there are invalid options. *)
		If[Length[invalidOptions]>0&&!gatherTests,
			Message[Error::InvalidOption,invalidOptions]
		];


		(*-- CONTAINER GROUPING RESOLUTION --*)
		(* Resolve RequiredAliquotContainers *)
		(* We have resolved all Aliquot related things above *)

		(* Prepare options to send to resolveAliquotOptions *)
		aliquotOptions=ReplaceRule[
			myOptions,
			Join[{ConsolidateAliquots->resolvedConsolidation},resolvedSamplePrepOptions]
		];

		(* Resolve Aliquot Options *)
		(* get the RequiredAliquotAmount. Note that this must always be greater than the specified SampleAmount *)
		(* If we are consolidating aliquots for our replicates, we will only do injection from one sample volume *)
	requiredAliquotAmounts=If[TrueQ[resolvedConsolidation],
		Map[Function[volume,volume*1.05/(specifiedNumberOfReplicates/.(Null:>1))],resolvedSampleVolume],
		Map[Function[volume,volume*1.05],resolvedSampleVolume]
	];

	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		(* Note: Also include AllowSolids->True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		resolveAliquotOptions[ExperimentCapillaryIsoelectricFocusing,Download[mySamples,Object],simulatedSamples,aliquotOptions,Cache->inheritedCache,Simulation->updatedSimulation,RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->requiredAliquotAmounts,Output->{Result,Tests}],
		{resolveAliquotOptions[ExperimentCapillaryIsoelectricFocusing,Download[mySamples,Object],simulatedSamples,aliquotOptions,Cache->inheritedCache,Simulation->updatedSimulation,RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->requiredAliquotAmounts,Output->Result],{}}
	];

		(* --- Resolve Label Options *)
		resolvedSampleLabel=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
			suppliedSampleObjects = Download[simulatedSamples, Object];
			uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
			preResolvedSampleLabels = Table[CreateUniqueLabel["capillary isoelectric focusing sample"], Length[uniqueSamples]];
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
				{suppliedSampleObjects, Lookup[roundedCapillaryIsoelectricFocusingOptions, SampleLabel]}
			]
		];

		resolvedSampleContainerLabel=Module[
			{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
			suppliedContainerObjects = Download[Lookup[simulatedSamplePackets, Container, {}], Object];
			uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
			preresolvedSampleContainerLabels = Table[CreateUniqueLabel["capillary isoelectric focusing sample container"], Length[uniqueContainers]];
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
				{suppliedContainerObjects, Lookup[roundedCapillaryIsoelectricFocusingOptions, SampleContainerLabel]}
			]
		];

		(* Resolve Post Processing Options *)
		resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

		resolvedExperimentOptions={
			Instrument->Lookup[roundedCapillaryIsoelectricFocusingOptions,Instrument],
			Cartridge->Lookup[roundedCapillaryIsoelectricFocusingOptions,Cartridge],
			SampleTemperature->Lookup[roundedCapillaryIsoelectricFocusingOptions,SampleTemperature] /. Ambient:> $AmbientTemperature,
			InjectionTable->resolvedInjectionTable[[All, ;; -2]],
			MatchedInjectionTable->resolvedInjectionTable,
			NumberOfReplicates->Lookup[roundedCapillaryIsoelectricFocusingOptions,NumberOfReplicates],
			Anolyte->Lookup[roundedCapillaryIsoelectricFocusingOptions,Anolyte],
			Catholyte->Lookup[roundedCapillaryIsoelectricFocusingOptions,Catholyte],
			ElectroosmoticConditioningBuffer->Lookup[roundedCapillaryIsoelectricFocusingOptions,ElectroosmoticConditioningBuffer],
			FluorescenceCalibrationStandard->Lookup[roundedCapillaryIsoelectricFocusingOptions,FluorescenceCalibrationStandard],
			WashSolution->Lookup[roundedCapillaryIsoelectricFocusingOptions,WashSolution],
			PlaceholderContainer->Lookup[roundedCapillaryIsoelectricFocusingOptions,PlaceholderContainer],
			OnBoardMixing->Lookup[roundedCapillaryIsoelectricFocusingOptions,OnBoardMixing],
			AnolyteStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,AnolyteStorageCondition],
			CatholyteStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,CatholyteStorageCondition],
			ElectroosmoticConditioningBufferStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,ElectroosmoticConditioningBufferStorageCondition],
			FluorescenceCalibrationStandardStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,FluorescenceCalibrationStandardStorageCondition],
			WashSolutionStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,WashSolutionStorageCondition],
			SampleVolume->resolvedSampleVolume,
			TotalVolume->resolvedTotalVolume,
			PremadeMasterMix->resolvedPremadeMasterMix,
			PremadeMasterMixReagent->resolvedPremadeMasterMixReagent,
			PremadeMasterMixDiluent->resolvedPremadeMasterMixDiluent,
			PremadeMasterMixReagentDilutionFactor->resolvedPremadeMasterMixDilutionFactor,
			PremadeMasterMixVolume->resolvedPremadeMasterMixVolume,
			Diluent->resolvedDiluent,
			Ampholytes->resolvedAmpholytes,
			AmpholyteTargetConcentrations->resolvedAmpholyteTargetConcentrations,
			AmpholyteVolume->resolvedAmpholyteVolume,
			IsoelectricPointMarkers->resolvedIsoelectricPointMarkers,
			IsoelectricPointMarkersTargetConcentrations->resolvedIsoelectricPointMarkersTargetConcentrations,
			IsoelectricPointMarkersVolume->resolvedIsoelectricPointMarkersVolume,
			ElectroosmoticFlowBlocker->resolvedElectroosmoticFlowBlocker,
			ElectroosmoticFlowBlockerTargetConcentrations->resolvedElectroosmoticFlowBlockerTargetConcentrations,
			ElectroosmoticFlowBlockerVolume->resolvedElectroosmoticFlowBlockerVolume,
			Denature->resolvedDenature,
			DenaturationReagent->resolvedDenaturationReagent,
			DenaturationReagentTargetConcentration->resolvedDenaturationReagentTargetConcentration,
			DenaturationReagentVolume->resolvedDenaturationReagentVolume,
			IncludeAnodicSpacer->resolvedIncludeAnodicSpacer,
			AnodicSpacer->resolvedAnodicSpacer,
			AnodicSpacerTargetConcentration->resolvedAnodicSpacerTargetConcentration,
			AnodicSpacerVolume->resolvedAnodicSpacerVolume,
			IncludeCathodicSpacer->resolvedIncludeCathodicSpacer,
			CathodicSpacer->resolvedCathodicSpacer,
			CathodicSpacerTargetConcentration->resolvedCathodicSpacerTargetConcentration,
			CathodicSpacerVolume->resolvedCathodicSpacerVolume,
			AmpholytesStorageCondition->resolvedAmpholytesStorageConditions,
			IsoelectricPointMarkersStorageCondition->resolvedIsoelectricPointMarkersStorageConditions,
			DenaturationReagentStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,DenaturationReagentStorageCondition],
			AnodicSpacerStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,AnodicSpacerStorageCondition],
			CathodicSpacerStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,CathodicSpacerStorageCondition],
			ElectroosmoticFlowBlockerStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,ElectroosmoticFlowBlockerStorageCondition],
			DiluentStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,DiluentStorageCondition],
			LoadTime->Lookup[roundedCapillaryIsoelectricFocusingOptions,LoadTime],
			VoltageDurationProfile->Lookup[roundedCapillaryIsoelectricFocusingOptions,VoltageDurationProfile],
			ImagingMethods->resolvedImagingMethods,
			NativeFluorescenceExposureTime->resolvedNativeFluorescenceExposureTimes,
			UVDetectionWavelength->Lookup[roundedCapillaryIsoelectricFocusingOptions,UVDetectionWavelength],
			NativeFluorescenceDetectionExcitationWavelengths->Lookup[roundedCapillaryIsoelectricFocusingOptions,NativeFluorescenceDetectionExcitationWavelengths],
			NativeFluorescenceDetectionEmissionWavelengths->Lookup[roundedCapillaryIsoelectricFocusingOptions,NativeFluorescenceDetectionEmissionWavelengths],
			IncludeStandards->resolveIncludeStandards,
			Standards->resolvedStandards,
			StandardStorageCondition->Lookup[expandedStandardsOptions,StandardStorageCondition],
			StandardVolume->resolvedStandardVolume,
			StandardFrequency->resolvedStandardFrequency,
			StandardTotalVolume->resolvedStandardTotalVolume,
			StandardPremadeMasterMix->resolvedStandardPremadeMasterMix,
			StandardPremadeMasterMixReagent->resolvedStandardPremadeMasterMixReagent,
			StandardPremadeMasterMixDiluent->resolvedStandardPremadeMasterMixDiluent,
			StandardPremadeMasterMixReagentDilutionFactor->resolvedStandardPremadeMasterMixDilutionFactor,
			StandardPremadeMasterMixVolume->resolvedStandardPremadeMasterMixVolume,
			StandardDiluent->resolvedStandardDiluent,
			StandardAmpholytes->resolvedStandardAmpholytes,
			StandardAmpholyteTargetConcentrations->resolvedStandardAmpholyteTargetConcentrations,
			StandardAmpholyteVolume->resolvedStandardAmpholyteVolume,
			StandardIsoelectricPointMarkers->resolvedStandardIsoelectricPointMarkers,
			StandardIsoelectricPointMarkersTargetConcentrations->resolvedStandardIsoelectricPointMarkersTargetConcentrations,
			StandardIsoelectricPointMarkersVolume->resolvedStandardIsoelectricPointMarkersVolume,
			StandardElectroosmoticFlowBlocker->resolvedStandardElectroosmoticFlowBlocker,
			StandardElectroosmoticFlowBlockerTargetConcentrations->resolvedStandardElectroosmoticFlowBlockerTargetConcentrations,
			StandardElectroosmoticFlowBlockerVolume->resolvedStandardElectroosmoticFlowBlockerVolume,
			StandardDenature->resolvedStandardDenature,
			StandardDenaturationReagent->resolvedStandardDenaturationReagent,
			StandardDenaturationReagentTargetConcentration->resolvedStandardDenaturationReagentTargetConcentration,
			StandardDenaturationReagentVolume->resolvedStandardDenaturationReagentVolume,
			StandardIncludeAnodicSpacer->resolvedStandardIncludeAnodicSpacer,
			StandardAnodicSpacer->resolvedStandardAnodicSpacer,
			StandardAnodicSpacerTargetConcentration->resolvedStandardAnodicSpacerTargetConcentration,
			StandardAnodicSpacerVolume->resolvedStandardAnodicSpacerVolume,
			StandardIncludeCathodicSpacer->resolvedStandardIncludeCathodicSpacer,
			StandardCathodicSpacer->resolvedStandardCathodicSpacer,
			StandardCathodicSpacerTargetConcentration->resolvedStandardCathodicSpacerTargetConcentration,
			StandardCathodicSpacerVolume->resolvedStandardCathodicSpacerVolume,
			StandardAmpholytesStorageCondition->resolvedStandardAmpholytesStorageConditions,
			StandardIsoelectricPointMarkersStorageCondition->resolvedStandardIsoelectricPointMarkersStorageConditions,
			StandardDenaturationReagentStorageCondition->Lookup[expandedStandardsOptions,StandardDenaturationReagentStorageCondition],
			StandardAnodicSpacerStorageCondition->Lookup[expandedStandardsOptions,StandardAnodicSpacerStorageCondition],
			StandardCathodicSpacerStorageCondition->Lookup[expandedStandardsOptions,StandardCathodicSpacerStorageCondition],
			StandardElectroosmoticFlowBlockerStorageCondition->Lookup[expandedStandardsOptions,StandardElectroosmoticFlowBlockerStorageCondition],
			StandardDiluentStorageCondition->Lookup[expandedStandardsOptions,StandardDiluentStorageCondition],
			StandardLoadTime->resolvedStandardLoadTime,
			StandardVoltageDurationProfile->resolvedStandardVoltageDurationProfile,
			StandardImagingMethods->resolvedStandardImagingMethods,
			StandardNativeFluorescenceExposureTime->resolvedStandardNativeFluorescenceExposureTime,
			IncludeBlanks->resolveIncludeBlanks,
			Blanks->resolvedBlanks,
			BlankStorageCondition->Lookup[expandedBlanksOptions,BlankStorageCondition],
			BlankVolume->resolvedBlankVolume,
			BlankFrequency->resolvedBlankFrequency,
			BlankTotalVolume->resolvedBlankTotalVolume,
			BlankPremadeMasterMix->resolvedBlankPremadeMasterMix,
			BlankPremadeMasterMixReagent->resolvedBlankPremadeMasterMixReagent,
			BlankPremadeMasterMixDiluent->resolvedBlankPremadeMasterMixDiluent,
			BlankPremadeMasterMixReagentDilutionFactor->resolvedBlankPremadeMasterMixDilutionFactor,
			BlankPremadeMasterMixVolume->resolvedBlankPremadeMasterMixVolume,
			BlankDiluent->resolvedBlankDiluent,
			BlankAmpholytes->resolvedBlankAmpholytes,
			BlankAmpholyteTargetConcentrations->resolvedBlankAmpholyteTargetConcentrations,
			BlankAmpholyteVolume->resolvedBlankAmpholyteVolume,
			BlankIsoelectricPointMarkers->resolvedBlankIsoelectricPointMarkers,
			BlankIsoelectricPointMarkersTargetConcentrations->resolvedBlankIsoelectricPointMarkersTargetConcentrations,
			BlankIsoelectricPointMarkersVolume->resolvedBlankIsoelectricPointMarkersVolume,
			BlankElectroosmoticFlowBlocker->resolvedBlankElectroosmoticFlowBlocker,
			BlankElectroosmoticFlowBlockerTargetConcentrations->resolvedBlankElectroosmoticFlowBlockerTargetConcentrations,
			BlankElectroosmoticFlowBlockerVolume->resolvedBlankElectroosmoticFlowBlockerVolume,
			BlankDenature->resolvedBlankDenature,
			BlankDenaturationReagent->resolvedBlankDenaturationReagent,
			BlankDenaturationReagentTargetConcentration->resolvedBlankDenaturationReagentTargetConcentration,
			BlankDenaturationReagentVolume->resolvedBlankDenaturationReagentVolume,
			BlankIncludeAnodicSpacer->resolvedBlankIncludeAnodicSpacer,
			BlankAnodicSpacer->resolvedBlankAnodicSpacer,
			BlankAnodicSpacerTargetConcentration->resolvedBlankAnodicSpacerTargetConcentration,
			BlankAnodicSpacerVolume->resolvedBlankAnodicSpacerVolume,
			BlankIncludeCathodicSpacer->resolvedBlankIncludeCathodicSpacer,
			BlankCathodicSpacer->resolvedBlankCathodicSpacer,
			BlankCathodicSpacerTargetConcentration->resolvedBlankCathodicSpacerTargetConcentration,
			BlankCathodicSpacerVolume->resolvedBlankCathodicSpacerVolume,
			BlankAmpholytesStorageCondition->resolvedBlankAmpholytesStorageConditions,
			BlankIsoelectricPointMarkersStorageCondition->resolvedBlankIsoelectricPointMarkersStorageConditions,
			BlankDenaturationReagentStorageCondition->Lookup[expandedBlanksOptions,BlankDenaturationReagentStorageCondition],
			BlankAnodicSpacerStorageCondition->Lookup[expandedBlanksOptions,BlankAnodicSpacerStorageCondition],
			BlankCathodicSpacerStorageCondition->Lookup[expandedBlanksOptions,BlankCathodicSpacerStorageCondition],
			BlankElectroosmoticFlowBlockerStorageCondition->Lookup[expandedBlanksOptions,BlankElectroosmoticFlowBlockerStorageCondition],
			BlankDiluentStorageCondition->Lookup[expandedBlanksOptions,BlankDiluentStorageCondition],
			BlankLoadTime->resolvedBlankLoadTime,
			BlankVoltageDurationProfile->resolvedBlankVoltageDurationProfile,
			BlankImagingMethods->resolvedBlankImagingMethods,
			BlankNativeFluorescenceExposureTime->resolvedBlankNativeFluorescenceExposureTime,
			CartridgeStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,CartridgeStorageCondition],
			SamplesInStorageCondition->Lookup[roundedCapillaryIsoelectricFocusingOptions,SamplesInStorageCondition],
			PreparatoryUnitOperations->Lookup[roundedCapillaryIsoelectricFocusingOptions,PreparatoryUnitOperations],
			PreparatoryPrimitives->Lookup[roundedCapillaryIsoelectricFocusingOptions, PreparatoryPrimitives],
			Cache->Lookup[roundedCapillaryIsoelectricFocusingOptions,Cache],
			FastTrack->Lookup[roundedCapillaryIsoelectricFocusingOptions,FastTrack],
			Template->Lookup[roundedCapillaryIsoelectricFocusingOptions,Template],
			ParentProtocol->Lookup[roundedCapillaryIsoelectricFocusingOptions,ParentProtocol],
			Operator->Lookup[roundedCapillaryIsoelectricFocusingOptions,Operator],
			Confirm->Lookup[roundedCapillaryIsoelectricFocusingOptions,Confirm],
			Name->Lookup[roundedCapillaryIsoelectricFocusingOptions,Name],
			Upload->Lookup[roundedCapillaryIsoelectricFocusingOptions,Upload],
			Output->Lookup[roundedCapillaryIsoelectricFocusingOptions,Output],
			Email->resolvedEmail,
			SampleLabel->resolvedSampleLabel,
			SampleContainerLabel->resolvedSampleContainerLabel
		};

		(* Join all resolved options *)
		resolvedOptions=Flatten[{
			resolvedExperimentOptions,
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		}];

		(* Return our resolved options and/or tests. *)
		outputSpecification/.{
			Result->resolvedOptions,(* add resolved options as they are written, so you can test *)
			Tests->Flatten[{
				discardedTest,
				deprecatedTest,
				discardedCartridgeInvalidTest,
				incompatibleCartridgeTest,
				blanksFalseOptionsSpecifiedTest,
				standardsFalseOptionsSpecifiedTest,
				allPrecisionTests,
				compatibleMaterialsTests,
				expandNestedIndexMatchedTests,
				validNameTest,
				sampleCountTest,
				injectionTableWithReplicatesInvalidTest,
				injectionTableVolumeZeroInvalidTest,
				notEnoughUsesLeftOptionTest,
				notEnoughOptimalUsesLeftOptionTest,
				invalidInjectionTableTest,
				premadeMasterMixWithmakeMasterMixOptionsSetInvalidOptionTest,
				nullTotalVolumeErrorsTests,
				includeTrueFrequencyNullErrorsTests,
				loadTimeNullErrorsTests,
				missingSampleCompositionWarningTests,
				onBoardMixingIncompatibleVolumesTests,
				onBoardMixingInvalidTests,
				OnBoardMixingVolumeTest,
				imagingMethodMismatchTests,
				voltageDurationStepTests,
				premadeMastermixFalseOptionsSpecifiedTests,
				premadeMasterMixDilutionFactorNullTests,
				premadeMasterMixVolumeNullTests,
				premadeMasterMixVolumeDilutionFactorMismatchTests,
				premadeMasterMixTotalVolumeTests,
				premadeMasterMixDiluentNullTests,
				premadeMasterMixNullTests,
				nullDiluentTests,
				noSpecifiedAmpholytesTests,
				ampholyteMatchedlengthsNotCopaceticTests,
				ampholyteVolumeNullTests,
				ampholyteConcentrationNullErrorsTests,
				ampholyteVolumeConcentrationMismatchTests,
				noSpecifiedIsoelectricPointMarkersTests,
				resolverCantFixIsoelectricPointMarkersMismatchTests,
				isoelectricPointMarkersVolumeNullTests,
				isoelectricPointMarkersConcentrationNullErrorsTests,
				isoelectricPointMarkersVolumeConcentrationMismatchTests,
				electroosmoticFlowBlockerNullTests,
				noElectroosmoticFlowBlockerAgentIdentifiedTest,
				electroosmoticFlowBlockerVolumeNullTests,
				electroosmoticFlowBlockerConcentrationNullTests,
				eofBlockerVolumeConcentrationMismatchTests,
				denatureFalseOptionsSpecifiedTests,
				denaturationReagentNullTests,
				noDenaturationReagentIdentifiedTest,
				denaturationReagentVolumeNullTests,
				denaturationReagentConcentrationNullTests,
				denaturationReagentConcentrationVolumeMismatchTests,
				resolveableDenatureReagentConcentrationUnitMismatchTest,
				unresolveableDenatureReagentConcentrationUnitMismatchTests,
				anodicSpacerFalseOptionsSpecifiedTests,
				anodicSpacerNullTests,
				noAnodicSpacerIdentifiedTest,
				anodicSpacerVolumeNullTests,
				anodicSpacerConcentrationNullTests,
				anodicSpacerConcentrationVolumeMismatchTests,
				cathodicSpacerFalseOptionsSpecifiedTests,
				cathodicSpacerNullTests,
				noCathodicSpacerIdentifiedTest,
				cathodicSpacerVolumeNullTests,
				cathodicSpacerConcentrationNullTests,
				cathodicSpacerConcentrationVolumeMismatchTests,
				sumOfVolumesOverTotalvolumeTests
			}]
		}
	];


(* ::Subsection:: *)
(* CapillaryIsoelectricFocusing Helper Functions *)

(* To check whether options are different from default in the option resolver. *)
(* Inputs -
	option - Option symbol as used in DefineOptions.
	optiondefinitions - the full output from OptionDefinitions[<Experiment>]

	Output - the option's setting by default

	*)

getDefault[option_Symbol,optiondefinitions_List]:=Module[{default},
	default=
		"Default"/.
			Cases[optiondefinitions,
				KeyValuePattern["OptionName"->ToString[option]]];
	First[ReleaseHold[default]]
];


(* function to expand nested index matched options *)
(**
Based heavily on ExperimentLCMS
Expand options that are indexMatched to eachother, while also having an IndexMatchParent or IndexMatchInput
	Input -
		experimentFunction - Experiment Function,
		expandedExperimentOptions - expanded input options as Association,
		mySamples - samples in Experiment (just grabbing the length for now),
		nestedMatchParent - the option we match to in the nested group (at the moment, not used),
		nestedOptions - the options we wish to expand, including the nestedMatchParent

	Options -
		ExpandByLongest - a boolean to determine if should throw an error when length of any nestedOptions is larger than the length of nestedMatchParent(at the moment, not used)
		Output - whether we include results, tests, or both in the output.

	Output -
		Result - nestedOptions in expanded format
		Tests - testing if lengths equal NestedMatch Parent


**)

DefineOptions[expandNestedIndexMatch,
	Options:>{
		{
			OptionName->Output,
			Default->Result,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>(Result|Tests|{Result,Tests})],
			Description->"Determines whether the function returns a the result, tests, or both.",
			Category->"General"
		},
		{
			OptionName->ExpandByLongest,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Determines whether the function expands to the maximum length or matches to the parent's length.",
			Category->"General"
		},
		{
			OptionName->Quiet,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			(* ExperimentCapillaryIsoelectricFocusing and ExperimentCapillaryGelElectrophoresisSDS always call this function with Quiet anyway *)
			Description->"Indicates if we should quiet the messages and tests generated from this function.",
			Category->"Hidden"
		}
	}
];

Warning::NestedIndexLengthMismatch="Nested index-matched option/s `1` are not matching in length for samples `2`. Defaulting to expand with Automatics or trim trailing values based on the `3`. Please make sure input lengths match in order to avoid unintended modifications to your method.";
Error::ExpandedNestedIndexLengthMismatch="Nested index-matched option/s `1` are not matching in length for samples `2`. Please make sure no option in `1` is longer than the parent option `3` and that all values match the required patterns.";
expandNestedIndexMatch[experimentFunction_,expandedExperimentOptions_Association,mySamples:{ObjectP[]..},
	nestedMatchParent_,nestedOptions_List,myOptions:OptionsPattern[expandNestedIndexMatch]]:=
	Module[
		{noNullExtractorDepth3,withNullExtractorDepth3,unitPatternDepth3Extractor,findDepth3Positions,getExpandedDimensionsDepth3,
			performDepth3Expansion,	expandedNestedOptions,relevantOptions,positioning,automatics,copaceticLengthWarningQ,
			copaceticLengthErrorQ,lengthMatchInvalidOptions,lengthMatchErrorTests,lengthMatchWarningTests,
			parentPositioning,parentAutomatics,outputAssociation,expandByLongest,quiet},

		expandByLongest = Lookup[ToList[myOptions],ExpandByLongest];
		quiet = TrueQ[Lookup[ToList[myOptions],Quiet,True]];

		(** helper functions **)
		(*account for patterns with and without Nulls to extract singleton patterns *)
		noNullExtractorDepth3[Verbatim[Hold][Verbatim[Alternatives][Verbatim[Alternatives][x_,___],Automatic]]]:=Hold[x];
		withNullExtractorDepth3[Verbatim[Hold][Verbatim[Alternatives][Verbatim[Alternatives][Verbatim[Alternatives][x_,___],Automatic],Null]]]:=Hold[x];

		(*define a unit pattern extractor for depth 3*)
		unitPatternDepth3Extractor:=Function[{optionName},Module[{optionDefinition,allowNullQ},
			(*first we grab the option definition pattern for this*)optionDefinition=FirstCase[OptionDefinition[experimentFunction],KeyValuePattern["OptionName"->ToString[optionName]]];
			(*check whether it's allow null true or not and that dictates the pattern extractor used*)
			allowNullQ="AllowNull"/.optionDefinition;
			(*get the unit pattern*)
			If[allowNullQ,
				withNullExtractorDepth3["SingletonPattern"/.optionDefinition],
				noNullExtractorDepth3["SingletonPattern"/.optionDefinition]]
		]];

		findDepth3Positions:=Function[{optionValue,currentUnitPattern},
			Module[{alternativesQ,listedPattern,spanInsideQ,spanPatternCases,replacedSpans,spanPositions,remainingPositions,remainingCases},
				(*if there are multiple entities in the unit pattern,we first split into individual holds*)(*e.g.Hold[Alternatives[pattern1,pattern2]] becomes List[Hold[pattern1],Hold[pattern2]]*)(*all of the logic is only necessary if we have a list of alternatives,so we check that first*)alternativesQ=MatchQ[currentUnitPattern,Verbatim[Hold][Alternatives[_]]];
			(*convert the alternatives to a list if it's an alternative of stuff*)
			listedPattern=If[
				alternativesQ,ToList@Thread[List@@@currentUnitPattern],currentUnitPattern];
			(*check if we have span inside,in which case,we continue on*)
			spanInsideQ=If[alternativesQ,MemberQ[listedPattern,Verbatim[Hold][Span[_,_]]],False];

			(*if we don't have any spans then we return all the positions*)
			If[!spanInsideQ,
				Position[optionValue,ReleaseHold@currentUnitPattern],(
				(*otherwise more logic*)
				(*we then see if we have a span inside.those are the top ranking patterns,and we want to consider them before any singletons*)
				spanPatternCases=Cases[listedPattern,Verbatim[Hold][Span[_,_]]];
				(*first get the span positions*)
				spanPositions=Position[optionValue,Alternatives@@ReleaseHold[spanPatternCases]];
				(*replace out anything found with an Automatic (really it's just a placeholder)*)
				replacedSpans=ReplacePart[optionValue,Map[Rule[#,Automatic]&,spanPositions]];
				(*get the positions of anything else remaining*)
				remainingCases=Complement[listedPattern,spanPatternCases];
				remainingPositions=Position[replacedSpans,Alternatives@@ReleaseHold[remainingCases]];
				(*return all of the positions*)
				Join[spanPositions,remainingPositions])]
			]];

		(* Prep for expansion by getting a certain Index's dimension *)
		getExpandedDimensionsDepth3:=Function[{basePatternPositions,automaticsPositions,currentIndex},
			Module[
				{relevantCases},
				(*just join everything and figure out everything relevant for the current index*)
				relevantCases=Cases[Join[basePatternPositions,automaticsPositions],{currentIndex,_,___}];
				(*check whether we have expansion in the relevant cases*)
				If[Length[relevantCases]>0,Max[#[[2]]&/@relevantCases],1]
			]];

		(* Set up expasion logic *)
		performDepth3Expansion:=Function[{currentDimension,currentOption,optionName,maxDimensionHere},
			Module[{},
				Which[
					MatchQ[currentOption,List@List[ReleaseHold@unitPatternDepth3Extractor[optionName]]],ConstantArray[First@currentOption,maxDimensionHere],
					(*if the current is 1,then we expand to the MAXXX*)
					currentDimension==1,Flatten[ConstantArray[currentOption,maxDimensionHere]],
					(*otherwise,if its the same,do nothing*)
					currentDimension==maxDimensionHere,currentOption,
					(*otherwise,we have a kerfuffle and just pad out with Automatics and note a conflict*)
					True,PadRight[ToList@currentOption,maxDimensionHere,Automatic]
				]
			]];

		(* Extract relevant options from expanded options *)
		relevantOptions=Lookup[expandedExperimentOptions,nestedOptions];

		(* Map over options and get positions and automatics *)
		{positioning,automatics}=Transpose@Map[
			Function[{optionName},
				Module[{unitPattern},
					(*get the unit pattern for this option*)
					unitPattern=unitPatternDepth3Extractor[optionName];
					(*get all of the positions within the passed options as well as the automatics*)
					{findDepth3Positions[Lookup[expandedExperimentOptions,optionName],unitPattern],
						Position[Lookup[expandedExperimentOptions,optionName],Automatic|Null]}
				]],
			nestedOptions
		];

		(*now expand all the depth=3*)
		{parentPositioning,parentAutomatics}=
			Module[{unitPattern},
				(*get the unit pattern for this option*)
				unitPattern=unitPatternDepth3Extractor[nestedMatchParent];
				(*get all of the positions within the passed options as well as the automatics*)
				{findDepth3Positions[Lookup[expandedExperimentOptions,nestedMatchParent],unitPattern],
					Position[Lookup[expandedExperimentOptions,nestedMatchParent],Automatic|Null]}
			];

		expandedNestedOptions=Transpose@Map[
			Function[{index},
				Module[{expandedDimensions,parentDimensions,maxDimension},
					(*here we just care about the total length for a given option*)
					expandedDimensions=MapThread[
						getExpandedDimensionsDepth3,
						{positioning,automatics,ConstantArray[index,Length@automatics]}
					];

					parentDimensions=MapThread[
						getExpandedDimensionsDepth3,
						{{parentPositioning},{parentAutomatics},{index}}
					];

					(*find the max length*)
					maxDimension=If[OptionValue[ExpandByLongest],
						Max[expandedDimensions],
						(* if epand by parent *)
						Max[parentDimensions]];
					(*now we do our checking and expansion.*)
					If[MatchQ[maxDimension,1],
						(*we don't have to do anything other than inner expansion-- if we're depth four then*)
						MapThread[
							Function[{currentOption,optionName},
								Switch[currentOption,
									Automatic|Null,{currentOption},
									{Automatic}|{Null},currentOption,
									(*we check if the's the base pattern,if so wrap with a list*)
									ReleaseHold@unitPatternDepth3Extractor[optionName],ToList[currentOption],
									_,currentOption
								]
							],
							{relevantOptions[[All,index]],
								nestedOptions}
						],
						(*otherwise,we have to do stuff and expand to the max length or to the max length of the parent*)
						MapThread[
							performDepth3Expansion,
							{expandedDimensions,relevantOptions[[All,index]],
								nestedOptions,
								ConstantArray[maxDimension,
									Length[expandedDimensions]]}
						]
					]
				]],
			Range[Length@ToList[mySamples]]
		];

		outputAssociation=MapThread[
			Function[{key,value},
				key->value
			],
			{nestedOptions,expandedNestedOptions}
		];

		(* Raise error if there is any type of mismatch that we cant expant (not automatics)*)
		(*Make sure that all values are of the same length *)
		copaceticLengthErrorQ=MapThread[Function[{key,values},
			(* Get the length of each option value and see if there are more than one, meaning something has a different length - if there is, return True *)
			Module[{lengths},
				lengths = Map[Length[ToList[#]]&, values];
				If[Length[DeleteDuplicates[lengths]] > 1,
					Rule[key,True],
					Rule[key,False]]
			]],
			(* map over all values as matched to samples *)
			{mySamples,Transpose[Values[Association[outputAssociation]]]}
		];

		(* set up tests *)
		lengthMatchInvalidOptions=If[Or@@Values[copaceticLengthErrorQ]&&!MatchQ[$ECLApplication,Engine]&&!quiet,
			(
				Message[Error::ExpandedNestedIndexLengthMismatch,nestedOptions,PickList[mySamples,Values[copaceticLengthErrorQ]],nestedMatchParent];
				nestedOptions
			),
			{}
		];

		lengthMatchErrorTests=If[!quiet,
			Module[{failingSamples,passingSamples,failingSamplesTests,passingSamplesTests},

				(* get the inputs that fail this test *)
				failingSamples=PickList[mySamples,Values[copaceticLengthErrorQ]];

				(* get the inputs that pass this test *)
				passingSamples=PickList[mySamples,Values[copaceticLengthErrorQ],False];

				(* create a test for the non-passing inputs *)
				failingSamplesTests=If[Length[failingSamples]>0,
					Test["The following expanded options "<>ToString[nestedOptions]<>", are in agreement with their parent nested index-matched option's length for the following samples "<>ObjectToString[failingSamples]<>":",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSamplesTests=If[Length[passingSamples]>0,
					Test["The following expanded options" <>ToString[nestedOptions]<>", are in agreement with their parent nested index-matched option's length for the following samples "<>ObjectToString[passingSamples]<>":",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{failingSamplesTests,passingSamplesTests}
			],
			{}
		];

		(* warn if there is any type of mismatch to let the user know you are going to expand *)
		(*Make sure that all values are of the same length *)
		copaceticLengthWarningQ=If[!Or@@Values[copaceticLengthErrorQ],
			MapThread[Function[{key,values},
				(* Get the length of each option value and see if there are more than one, meaning something has a different length - if there is, return True *)
				Module[{lengths},
					lengths = Map[Length[ToList[#]]&, values];
					If[Length[DeleteDuplicates[lengths]] > 1,
						Rule[key,True],
						Rule[key,False]]
				]],
				(* map over all values as matched to samples *)
				{mySamples,Transpose[relevantOptions]}
			],
			{False}
		];

		(* set up tests only if no error was raised before *)
		lengthMatchInvalidOptions=If[!Or@@Values[copaceticLengthErrorQ]&&Or@@Values[copaceticLengthWarningQ]&&!MatchQ[$ECLApplication,Engine]&&!quiet,
			(
				Message[Warning::NestedIndexLengthMismatch,nestedOptions,PickList[mySamples,Values[copaceticLengthWarningQ]],If[expandByLongest,"longest input", "parent option "<>ToString[nestedMatchParent]]];
				nestedOptions
			),
			{}
		];

		lengthMatchWarningTests=If[(!Or@@Values[copaceticLengthErrorQ])&&(!quiet),
			Module[{failingSamples,passingSamples,failingSamplesTests,passingSamplesTests},

				(* get the inputs that fail this test *)
				failingSamples=PickList[mySamples,Values[copaceticLengthWarningQ]];

				(* get the inputs that pass this test *)
				passingSamples=PickList[mySamples,Values[copaceticLengthWarningQ],False];

				(* create a test for the non-passing inputs *)
				failingSamplesTests=If[Length[failingSamples]>0,
					Warning["The following options "<>ToString[nestedOptions]<>", are in agreement with their parent nested index-matched option's length for the following samples "<>ObjectToString[failingSamples]<>":",
						False,
						True
					],
					Nothing
				];

				(* create a test for the passing inputs *)
				passingSamplesTests=If[Length[passingSamples]>0,
					Warning["The following options" <>ToString[nestedOptions]<>", are in agreement with their parent nested index-matched option's length for the following samples "<>ObjectToString[passingSamples]<>":",
						True,
						True
					],
					Nothing
				];
				(* return the created tests *)
				{failingSamplesTests,passingSamplesTests}
			],
			{}
		];

		OptionValue[Output]/.{Result->outputAssociation,Tests->{lengthMatchWarningTests,lengthMatchErrorTests}}
	];

(* ::Subsection:: *)
(* capillaryIsoelectricFocusingResourcePackets*)

DefineOptions[
	capillaryIsoelectricFocusingResourcePackets,
	Options :> {HelperOutputOption, CacheOption,SimulationOption}
];

capillaryIsoelectricFocusingResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs, expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,
		samplePackets,expandedAliquotVolume,sampleVolumes,pairedSamplesInAndVolumes,sampleVolumeRules,optionsWithVolume,
		sampleResourceReplaceRules,instrumentTime,instrumentResource,protocolPacket,sharedFieldPacket,finalizedPacket,
		allResourceBlobs,fulfillable, frqTests,testsRule,resultRule,allDownloadValues,cache,sampleReplicates,samplesWithReplicates,replaceVolumesForReplicates,
		expandedOptionsWithReplicates, optionsWithReplicates,uniqueSamples,uniqueSamplePackets,sampleContainers,uniqueContainers,uniquePlateContainers,
		standardOptionList,blankOptionList,standardOptions,blankOptions,standards,includeStandards,blanks,includeBlanks,
		numberOfReplicatesRules,standardsReplicates,blanksReplicates,standardsWithReplicates,standardOptionsWithReplicates,
		blanksWithReplicates,blankOptionsWithReplicates,standardResourceRules,blankResourceRules,resolvedSampleVolume,
		injectionTableToUpload,totalInjections,optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,
		blankOptionsWithReplicatesAssociation,injectionOverheadTime,sampleTimes,standardTimes,blankTimes,premadeMasterMixObjects,
		premadeMasterMixVolumes,premadeMasterMixResourceRules,premadeMasterMixDiluentResourceRules,premadeMastermixDiluentTuples,
		premadeMasterMixDiluentObjects,premadeMasterMixDiluentVolumes,ampholyteObjects,ampholyteVolumes,ampholyteResourceRules,
		pIMarkerObjects,pIMarkerVolumes,pIMarkerResourceRules,anodicSpacerObjects,anodicSpacerVolumes,anodicSpacerResourceRules,
		cathodicSpacerObjects,cathodicSpacerVolumes,cathodicSpacerResourceRules,denaturationAgentObjects,denaturationAgentVolumes,
		denaturationAgentResourceRules,electroosmoticFlowBlockerObjects,electroosmoticFlowBlockerVolumes,electroosmoticFlowBlockerResourceRules,
		diluentTuples,diluentsVolumeOptions,diluentObjects,diluentVolumes,diluentResourceRules,runTime,setupTime,exposureTimesToUpload,
		updatedSimulation,simulation,originalSampleObjects,simulatedSamples,numberOfWellsForOBM,

		(* resources *)
		plateContainerResources,plateSealResources,samplesInResources, standardResources,blankResources, cartridgeResource,
		anolyteResource,catholyteResource,electroosmoticConditioningBufferResource,fluorescenceCalibrationStandardResource,
		washSolutionResource,placeholderContainerResource,capResources, assayContainersResource, premadeMastermixResources,
		standardPremadeMasterMixResources,blankPremadeMasterMixResources,premadeMastermixDiluentResources,
		standardPremadeMasterMixDiluentResources,blankPremadeMasterMixDiluentResources,ampholyteResources,standardAmpholyteResources,
		blankAmpholyteResources,pIMarkerResources,standardpIMarkerResources,blankpIMarkerResources,anodicSpacerResources,
		standardAnodicSpacerResources,blankAnodicSpacerResources,cathodicSpacerResources,standardCathodicSpacerResources,
		blankCathodicSpacerResources, denaturationAgentResources,standardDenaturationAgentResources,blankDenaturationAgentResources,
		electroosmoticFlowBlockerResources,standardElectroosmoticFlowBlockerResources,blankElectroosmoticFlowBlockerResources,
		diluentResources,standardDiluentResources,blankDiluentResources,onBoardMixingContainersResource,onBoardMixingWashResource,
		onBoardMixingPrepContainerResource,transferPipette,wasteBeaker
	},
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentCapillaryIsoelectricFocusing, {mySamples}, myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentCapillaryIsoelectricFocusing,
		RemoveHiddenOptions[ExperimentCapillaryIsoelectricFocusing,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache = Lookup[ToList[ops],Cache];
	simulation=Lookup[ToList[ops],Simulation];

	(* Get rid of the links in mySamples. *)
	originalSampleObjects=Download[mySamples,Object];

	(* Get our simulated samples (we have to figure out sample groupings here). *)
	{simulatedSamples,updatedSimulation}=simulateSamplesResourcePacketsNew[ExperimentCapillaryIsoelectricFocusing,originalSampleObjects,myResolvedOptions,Cache->inheritedCache,Simulation->simulation];

	(* --- Make our one big Download call --- *)
	allDownloadValues=Quiet[Download[
		{
			originalSampleObjects
		},
		{
			{
				Packet[Container],
				Packet[Container[{Model}]],
				Packet[Container[Model[{Dimensions}]]]
			}
		},
		Cache->inheritedCache,
		Simulation->updatedSimulation,
		Date->Now
	],{Download::NotLinkField, Download::FieldDoesntExist}];


	(* add what we Downloaded to the new cache *)
	cache = FlattenCachePackets[{inheritedCache, Cases[Flatten[allDownloadValues], PacketP[]]}];

	(* even though Download is currently a single item, pull that one out here *)
	samplePackets = allDownloadValues[[1]];

	(* -- Generate resources for the SamplesIn -- *)
	(* Pull out the number of replicates; make sure all Nulls become 1 *)
	sampleReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(*expand the options based on the number of replicates *)
	{samplesWithReplicates, expandedOptionsWithReplicates} = expandNumberOfReplicates[ExperimentCapillaryIsoelectricFocusing, Download[mySamples, Object], expandedResolvedOptions];

	(* Replicates are injected NumberOfReplicates times, but do not need additional resources (except NumberOfUses for the cartridge), we need to set their reagent volumes to 0 microliter so no additional resources are used *)
	optionsWithVolume = {SampleVolume, TotalVolume, PremadeMasterMixVolume, AmpholyteVolume, IsoelectricPointMarkersVolume, ElectroosmoticFlowBlockerVolume,
		DenaturationReagentVolume, AnodicSpacerVolume, CathodicSpacerVolume};

	(* Build rules for replacing values in expanded options (this isn't very elegant, but it works..) *)
	(* need to check if Aliquot-> True, in which case, dont change anything..  *)
	replaceVolumesForReplicates =
		Rule[
			#,
			(* we use TakeList to make sure the list structure is kept if we have nested lists *)
			If[Depth[Lookup[expandedOptionsWithReplicates, #]]<4,
				(* if not nested, go ahead and flatten *)
				Flatten[MapThread[
						(* replace values that are not the first replicate for each object in samplesIn with 0 Microliter. *)
						(* NOTE: this will only work when replicates are expanded in the following fashion {1,2,...} -> {1,1,1,2,2,2,...} *)
						Function[{values, aliquotBool},
							If[And@@aliquotBool,
								(* if Aliquot->True, don't change things *)
								values,
								(* if Aliquot->False, change volumes to 0Microliter, this is a technical replicate *)
								{First[values], Rest[values] /. VolumeP -> 0 Microliter}]],
							{Partition[Lookup[expandedOptionsWithReplicates, #], sampleReplicates], Partition[Lookup[expandedOptionsWithReplicates, Aliquot], sampleReplicates]}
				]],
				(* if nested, go ahead and flatten but remember you want to unflatten right after *)
				TakeList[
					Flatten[MapThread[
						(* replace values that are not the first replicate for each object in samplesIn with 0 Microliter. *)
						(* NOTE: this will only work when replicates are expanded in the following fashion {1,2,...} -> {1,1,1,2,2,2,...} *)
						Function[{values, aliquotBool},
							If[And@@aliquotBool,
								(* if Aliquot->True, don't change things *)
								values,
								(* if Aliquot->False, change volumes to 0Microliter, this is a technical replicate *)
								{First[values], Rest[values] /. VolumeP -> 0 Microliter}]],
						{Partition[Lookup[expandedOptionsWithReplicates, #], sampleReplicates], Partition[Lookup[expandedOptionsWithReplicates, Aliquot], sampleReplicates]}
					]],
					Length/@Lookup[expandedOptionsWithReplicates, #]
				]
			]
			(* We map this over all relevant options *)
		]& /@ optionsWithVolume;

	(* Now we can replace the volumes in the expandedOptionsWithReplicates to reflect true volume requirements *)
	optionsWithReplicates = ToList @ Join[Association[expandedOptionsWithReplicates], Association[replaceVolumesForReplicates]];

	(* Delete any duplicate input samples to create a single resource per unique sample *)
	(* using the one with replicates because that one already has Object downloaded from it *)
	uniqueSamples = DeleteDuplicates[samplesWithReplicates];

	(* Extract packets for sample objects *)
	uniqueSamplePackets = fetchPacketFromCache[#, cache]& /@ uniqueSamples;

	(* Get the unique sample containers*)
	sampleContainers = Download[Lookup[uniqueSamplePackets, Container], Object];

	uniqueContainers=DeleteDuplicates[sampleContainers];

	(* Get the number of unique plate containers*)
	uniquePlateContainers = DeleteDuplicates[Cases[sampleContainers, ObjectP[Object[Container, Plate]]]];

	plateContainerResources = If[Length[uniquePlateContainers]>0,
		Resource[Sample->#]& /@ uniquePlateContainers];

	(* make a resource for plate seal *)
	plateSealResources = If[Length[uniquePlateContainers]>0,
		Link[Resource[
			Sample -> Model[Item, PlateSeal, "id:Vrbp1jKZJ0Rm"]]
		]];

	(* Get the sample volume; if we're aliquoting, use that amount; otherwise use the minimum volume the experiment will require *)
	{expandedAliquotVolume, resolvedSampleVolume} = Flatten[Lookup[optionsWithReplicates,{AliquotAmount,SampleVolume},Null],1];

	(* Template Note: Only include a volume if the experiment is actually consuming some amount *)

	sampleVolumes = MapThread[
		If[VolumeQ[#1],
			#1,
			#2*1.1
		]&,
		{expandedAliquotVolume, resolvedSampleVolume}
	];

	(* Pair the SamplesIn and their Volumes *)
	pairedSamplesInAndVolumes = MapThread[
		#1 -> #2&,
		{samplesWithReplicates, sampleVolumes}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, Total];

	(* Make replace rules for the samples and its resources;we do not multiply volumes by number of replicates - replicates are merely number of injections from the SAME assay tube *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume ]
		],
		sampleVolumeRules
	];

	(* Use the replace rules to get the sample resources *)
	samplesInResources = Replace[samplesWithReplicates, sampleResourceReplaceRules, {1}];

	(* -- Generate resources for the Ladders, Standards, Blanks -- *)
	(* first, get their index-matched options and expand them; expanding with the expandNumberOfReplicatesIndexMatchingParent function (see above) *)

	standardOptionList=ToExpression[#]&/@("OptionName"/.
		Cases[OptionDefinition[ExperimentCapillaryIsoelectricFocusing],
			KeyValuePattern["IndexMatchingParent"->"Standards"]
		]);

	blankOptionList=ToExpression[#]&/@("OptionName"/.
		Cases[OptionDefinition[ExperimentCapillaryIsoelectricFocusing],
			KeyValuePattern["IndexMatchingParent"->"Blanks"]
		]);

	(* Next, we are grabbing the relevant options, and converting to a list *)
	standardOptions=KeyDrop[KeyTake[myResolvedOptions,standardOptionList],Standards];

	blankOptions=KeyDrop[KeyTake[myResolvedOptions,blankOptionList],Blanks];

	(* now we can expand everything based on their number of replicates (as specified in Frequency options *)
	(* get standards/blanks and thether they should be included *)
	{
		standards,
		includeStandards,
		blanks,
		includeBlanks
	} = Lookup[myResolvedOptions, {Standards, IncludeStandards,	Blanks, IncludeBlanks},Null];

	(* Get number of replicates for each type of sample and convert expressions to an integer number of replicates *)
	numberOfReplicatesRules = {Null:> 1, First:>1, Last:>1, FirstAndLast:>2, frequency_Integer:>Floor[Length[samplesWithReplicates]/frequency]};

	standardsReplicates = If[includeStandards, First@Lookup[myResolvedOptions, StandardFrequency, Null] /. numberOfReplicatesRules];
	blanksReplicates = If[includeBlanks, First@Lookup[myResolvedOptions, BlankFrequency, Null] /. numberOfReplicatesRules];

	(* expand each of blanks/standards *)
	{standardsWithReplicates, standardOptionsWithReplicates} = If[includeStandards,
		expandNumberOfReplicatesIndexMatchingParent[Download[standards, Object], standardOptions, standardsReplicates],
		{{},{}}];
	{blanksWithReplicates, blankOptionsWithReplicates} = If[includeBlanks,
		expandNumberOfReplicatesIndexMatchingParent[Download[blanks, Object], blankOptions,blanksReplicates],
		{{},{}}];

	(* Make resource rules and specify them for each standard or blank replicate *)
	(* make a list of replacement rules for standards*)
	standardResourceRules = sampleResourceRules[standardsWithReplicates, Lookup[standardOptionsWithReplicates, StandardVolume, {}], includeStandards];
	(* if we're including any standards, replace objects with resources. if not, nothing to do here and return an empty list *)
	standardResources = If[includeStandards,
		Replace[standardsWithReplicates, standardResourceRules, {1}],
		{}];

	(* make a list of replacement rules for blanks*)
	blankResourceRules = sampleResourceRules[blanksWithReplicates, Lookup[blankOptionsWithReplicates, BlankVolume, {}], includeBlanks];
	(* if we're including any blanks, replace objects with resources. if not, nothing to do here and return an empty list *)
	blankResources = If[includeBlanks,
		Replace[blanksWithReplicates, blankResourceRules, {1}],
		{}];

	(* --- Make all the resources needed in the experiment --- *)

	(* make general run resources - volumes here are all hard coded since the instrument requires these to run properly regardless of the number of injections to be made *)
	cartridgeResource = Resource[Sample->Lookup[myResolvedOptions,Cartridge], NumberOfUses->Length[Lookup[myResolvedOptions,MatchedInjectionTable]]];
	(* No need to request container here since these will go into the cartridge directly *)
	anolyteResource = Resource[Sample->Lookup[myResolvedOptions,Anolyte], Amount -> 2.1Milliliter];
	catholyteResource = Resource[Sample->Lookup[myResolvedOptions,Catholyte], Amount -> 2.1Milliliter];
	electroosmoticConditioningBufferResource = Resource[Sample->Lookup[myResolvedOptions,ElectroosmoticConditioningBuffer], Amount -> 1.5Milliliter, Container ->Model[Container, Vessel, "id:Y0lXejlqEMNE"]];
	fluorescenceCalibrationStandardResource = Resource[Sample->Lookup[myResolvedOptions,FluorescenceCalibrationStandard], Amount -> 500Microliter, Container ->Model[Container, Vessel, "id:Y0lXejlqEMNE"]];

	(* wash needs to be split two two containers, making two different resources for this *)
	washSolutionResource =  If[Lookup[myResolvedOptions,OnBoardMixing],
		(* OnboardMixing requires an additional water vial *)
		ConstantArray[Resource[Sample->Lookup[myResolvedOptions,WashSolution], Amount -> 1.5Milliliter, Container ->Model[Container, Vessel, "id:Y0lXejlqEMNE"]], 3],
		ConstantArray[Resource[Sample->Lookup[myResolvedOptions,WashSolution], Amount -> 1.5Milliliter, Container ->Model[Container, Vessel, "id:Y0lXejlqEMNE"]], 2]
	];

	placeholderContainerResource = If[Lookup[myResolvedOptions,OnBoardMixing],
		(* OnboardMixing requires an additional empty vial *)
		ConstantArray[Resource[Sample->Lookup[myResolvedOptions,PlaceholderContainer]], 2],
		{Resource[Sample->Lookup[myResolvedOptions,PlaceholderContainer]]}
	];

	capResources = If[Lookup[myResolvedOptions,OnBoardMixing],
		(* OnboardMixing requires additional clear caps *)
		Flatten@{ConstantArray[Resource[Sample->Model[Item, Cap, "Pressure Cap for cIEF"]], 4], ConstantArray[Resource[Sample->Model[Item, Cap, "Maurice Clear Screw Caps"]], 3]},
		Flatten@{ConstantArray[Resource[Sample->Model[Item, Cap, "Pressure Cap for cIEF"]], 4], Resource[Sample->Model[Item, Cap, "Maurice Clear Screw Caps"]]}
	];

	(* at least for the time being, we are using the Biorad 96-well plates as our assay container *)
	assayContainersResource = Resource[Sample->Model[Container, Plate, "96-Well Full-Skirted PCR Plate"]];

	(* resource packets are made for all needed resources for samples, blanks, and standards together. *)

	(* Generally resources are made with the following logic: for each sample type, we match reagent and volume and create
	a resource for each unique reagent across samples, blanks, and standards, by definition, will use every unique combination
	in samplesIn *)
	(* First, we create matched tuples of sample/standard/blank reagent objects, needed volume, and number of replicates based on the rules we created above and filter out nulls *)
	(* the number of replicates applies to each sample/standards/etc so we want to keep it for the ride, hence the constant array. we are replacing 0 with 1 so that the transpose wont break if there are no samples for that category *)

	(* Make expended option lists into associations *)
	{
		optionsWithReplicatesAssociation,
		standardOptionsWithReplicatesAssociation,
		blankOptionsWithReplicatesAssociation
	} = Association[#]& /@ {optionsWithReplicates,standardOptionsWithReplicates,blankOptionsWithReplicates};

	(* below are a couple of functions to help streamline making resources *)
	(* to make adding the prefix to fields easier *)
	prefixToField[prefixToAdd_String, field_Symbol]:=ToExpression[prefixToAdd<>ToString[field]];

	(* to make resources need the reagents, their volumes and number of replicates - we will combine ones from each sample type (samplesIn/Ladders/Blanks/Standards to generate one resource for all *)
	(* to get a single resource for samplesIn, blanks, and standards, we first need to join these fields from each group *)
	joinListsByField[myReagent_Symbol, myReagentVolume_Symbol]:= Module[
		{samplesObjects, volumeObjects, objectVolumeTuples,nestedObjects,unnestedObjects,noNullObjects},

		(* join all object lists fpr this reagent together *)
		samplesObjects = Join[
			MapThread[
				Function[{association, field},ToList[Lookup[association, field,{}]]],
				{
					{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
					{myReagent,prefixToField["Standard", myReagent],prefixToField["Blank", myReagent]}
				}
			]];

		(* join all reagent volume fields together *)
		volumeObjects = Join[
			MapThread[
				Function[{association, field},Lookup[association, field,{}]],
				{
					{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
					{myReagentVolume,prefixToField["Standard", myReagentVolume],prefixToField["Blank", myReagentVolume]}
				}
			]];

		(* transpose all lists and drop whatever is not an object *)
		objectVolumeTuples = Transpose[Flatten[#]&/@ {samplesObjects,volumeObjects}];

		(* return object/volume/replicate lists only for valid objects - need to account for nested index matching cases as well *)

		nestedObjects = Cases[objectVolumeTuples, {{ObjectP[]..}, {VolumeP..}}];

		(* to unnest, first transpose each tuple, then flatten *)
		unnestedObjects = Flatten[Transpose[#]&/@nestedObjects, 1];

		(* join all valid case tuples *)
		noNullObjects = Join[
			Cases[objectVolumeTuples, {ObjectP[], VolumeP}],
			unnestedObjects
		];

		(* if there's anything valid, return a transposed list (so that objects and volumes are separated. otherwiase return empty lists*)
		If[Length[noNullObjects]>0,
			Transpose[noNullObjects],
			{{},{}}
		]
	];

	(* When we use onboardMixing, we need to account for the number of samples. This is a bit tricky, because it depends
	on whether we the user specified aliquot or not, so lets figure this out here *)
	numberOfWellsForOBM = If[MemberQ[Keys[myUnresolvedOptions], Aliquot],
		(* Since Aliquot was specified by user, we need to find out what samples have true replicates and which don't to get a correct count of wells *)
		Length[Flattern[Mapthread[
			If[#2, Table[#1, sampleReplicates],#1]&,
			{mySamples, Lookup[myResolvedOptions, Aliquot]}]]]
			+Length[standardsWithReplicates]+Length[blanksWithReplicates],
		(* When Aliquot isnt user specified, just take the samples they specifies into account. to avoid cases where Aliquot is resolved as True *)
		Length[mySamples]+Length[standardsWithReplicates]+Length[blanksWithReplicates]
	];

	(* Generating resources for PremadeMasterMix *)
	(* combine objects, volumes, and replicates to specific lists for samples/standards/blanks *)
	{premadeMasterMixObjects, premadeMasterMixVolumes} = joinListsByField[PremadeMasterMixReagent, PremadeMasterMixVolume];

	(* Make common resource rules for all *)
	premadeMasterMixResourceRules = reagentResourceRules[premadeMasterMixObjects, premadeMasterMixVolumes,Lookup[myResolvedOptions,OnBoardMixing],numberOfWellsForOBM,Null];

	(* replace objects with resources for each of the samples/standards/blanks *)
	{
		premadeMastermixResources,
		standardPremadeMasterMixResources,
		blankPremadeMasterMixResources
	} = MapThread[
		Replace[Lookup[#1, #2,{}], premadeMasterMixResourceRules,{1}]&,
		{
			{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{PremadeMasterMixReagent,StandardPremadeMasterMixReagent,BlankPremadeMasterMixReagent}
		}
	];

	(* Generate premade mastermix diluent resources *)
	(* unlike most other reagents, this one requires us to calculate the required volumes before making the resource *)
	(* to that end we need to get the reagents, total volume, and sample volume for each sample*)
	premadeMastermixDiluentTuples =
		Cases[Flatten[MapThread[
			Function[{association, field},Transpose[Lookup[association, field,{}]]],
			{
				{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
				{
					{PremadeMasterMixDiluent,PremadeMasterMixVolume,SampleVolume,TotalVolume},
					{StandardPremadeMasterMixDiluent,StandardPremadeMasterMixVolume,StandardVolume,StandardTotalVolume},
					{BlankPremadeMasterMixDiluent,BlankPremadeMasterMixVolume,BlankVolume,BlankTotalVolume}
				}
			}
		],1],{ObjectP[], VolumeP, VolumeP, VolumeP}];

	(* combine objects, and calculated volumes to separate lists for all reagents *)
	{
		premadeMasterMixDiluentObjects,
		premadeMasterMixDiluentVolumes
	} = If[Length[premadeMastermixDiluentTuples]>0,
		Transpose[MapThread[
			Function[
				{masterMixDiluent,masterMixVolume,sampleVolume,totalVolume},
				{masterMixDiluent,totalVolume - (masterMixVolume+sampleVolume)}
			],
			Transpose[premadeMastermixDiluentTuples]
		]],
		{{},{}}
	];

	(* Make common resource rules for all *)
	premadeMasterMixDiluentResourceRules = reagentResourceRules[premadeMasterMixDiluentObjects, premadeMasterMixDiluentVolumes,Lookup[myResolvedOptions,OnBoardMixing],numberOfWellsForOBM,Null];

	(* replace objects with resources for each of the samples/standards/blanks *)
	{
		premadeMastermixDiluentResources,
		standardPremadeMasterMixDiluentResources,
		blankPremadeMasterMixDiluentResources
	} = MapThread[
		Replace[Lookup[#1, #2,{}], premadeMasterMixDiluentResourceRules, {1}]&,
		{
			{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{PremadeMasterMixDiluent,StandardPremadeMasterMixDiluent,BlankPremadeMasterMixDiluent}
		}
	];

	(* Generate Ampholyte resources *)
	(* combine objects, volumes, and replicates to specific lists for samples/standards/blanks *)
	{ampholyteObjects, ampholyteVolumes} = joinListsByField[Ampholytes, AmpholyteVolume];

	(* Make common resource rules for all *)
	(* Require a minimum of 105 uL for each resource since the Ampholyte samples are in Hermetic bottles and the minimum we can transfer is 100 uL with needle *)
	ampholyteResourceRules = reagentResourceRules[ampholyteObjects, ampholyteVolumes,Lookup[myResolvedOptions,OnBoardMixing],numberOfWellsForOBM,105Microliter];

	(* replace objects with resources for each of the samples/standards/blanks - Remember to replace at level 2, since these are nested matching lists*)
	{
		ampholyteResources,
		standardAmpholyteResources,
		blankAmpholyteResources
	} = MapThread[
		Replace[Lookup[#1, #2,{}], ampholyteResourceRules, {2}]&,
		{
			{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{Ampholytes,StandardAmpholytes,BlankAmpholytes}
		}
	];

	(* Generate IsoelectricPointMarkers resources *)
	(* combine objects, volumes, and replicates to specific lists for samples/standards/blanks *)
	{pIMarkerObjects, pIMarkerVolumes} = joinListsByField[IsoelectricPointMarkers, IsoelectricPointMarkersVolume];

	(* Make common resource rules for all *)
	pIMarkerResourceRules = reagentResourceRules[pIMarkerObjects, pIMarkerVolumes,Lookup[myResolvedOptions,OnBoardMixing],numberOfWellsForOBM,Null];

	(* replace objects with resources for each of the samples/standards/blanks - Remember to replace at level 2, since these are nested matching lists*)
	{
		pIMarkerResources,
		standardpIMarkerResources,
		blankpIMarkerResources
	} = MapThread[
		Replace[Lookup[#1, #2,{}], pIMarkerResourceRules, {2}]&,
		{
			{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{IsoelectricPointMarkers,StandardIsoelectricPointMarkers,BlankIsoelectricPointMarkers}
		}
	];

	(* Generate AnodicSpacers resources *)
	(* combine objects, volumes, and replicates to specific lists for samples/standards/blanks *)
	{anodicSpacerObjects, anodicSpacerVolumes} = joinListsByField[AnodicSpacer, AnodicSpacerVolume];

	(* Make common resource rules for all *)
	anodicSpacerResourceRules = reagentResourceRules[anodicSpacerObjects, anodicSpacerVolumes,Lookup[myResolvedOptions,OnBoardMixing],numberOfWellsForOBM,Null];

	(* replace objects with resources for each of the samples/standards/blanks - Remember to replace at level 2, since these are nested matching lists*)
	{
		anodicSpacerResources,
		standardAnodicSpacerResources,
		blankAnodicSpacerResources
	} = MapThread[
		Replace[Lookup[#1, #2,{}], anodicSpacerResourceRules, {1}]&,
		{
			{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{AnodicSpacer,StandardAnodicSpacer,BlankAnodicSpacer}
		}
	];

	(* Generate CathodicSpacers resources *)
	(* combine objects, volumes, and replicates to specific lists for samples/standards/blanks *)
	{cathodicSpacerObjects, cathodicSpacerVolumes} = joinListsByField[CathodicSpacer, CathodicSpacerVolume];

	(* Make common resource rules for all *)
	cathodicSpacerResourceRules = reagentResourceRules[cathodicSpacerObjects, cathodicSpacerVolumes,Lookup[myResolvedOptions,OnBoardMixing],numberOfWellsForOBM,Null];

	(* replace objects with resources for each of the samples/standards/blanks - Remember to replace at level 2, since these are nested matching lists*)
	{
		cathodicSpacerResources,
		standardCathodicSpacerResources,
		blankCathodicSpacerResources
	} = MapThread[
		Replace[Lookup[#1, #2,{}], cathodicSpacerResourceRules, {1}]&,
		{
			{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{CathodicSpacer,StandardCathodicSpacer,BlankCathodicSpacer}
		}
	];

	(* Generate DenaturationAgents resources *)
	(* combine objects, volumes, and replicates to specific lists for samples/standards/blanks *)
	{denaturationAgentObjects, denaturationAgentVolumes} = joinListsByField[DenaturationReagent, DenaturationReagentVolume];

	(* Make common resource rules for all *)
	denaturationAgentResourceRules = reagentResourceRules[denaturationAgentObjects, denaturationAgentVolumes,Lookup[myResolvedOptions,OnBoardMixing],numberOfWellsForOBM,Null];

	(* replace objects with resources for each of the samples/standards/blanks - Remember to replace at level 2, since these are nested matching lists*)
	{
		denaturationAgentResources,
		standardDenaturationAgentResources,
		blankDenaturationAgentResources
	} = MapThread[
		Replace[Lookup[#1, #2,{}], denaturationAgentResourceRules, {1}]&,
		{
			{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{DenaturationReagent,StandardDenaturationReagent,BlankDenaturationReagent}
		}
	];

	(* Generate ElectroosmoticFlowBlockers resources *)
	(* combine objects, volumes, and replicates to specific lists for samples/standards/blanks *)
	{electroosmoticFlowBlockerObjects, electroosmoticFlowBlockerVolumes} = joinListsByField[ElectroosmoticFlowBlocker, ElectroosmoticFlowBlockerVolume];

	(* Make common resource rules for all *)
	electroosmoticFlowBlockerResourceRules = reagentResourceRules[electroosmoticFlowBlockerObjects, electroosmoticFlowBlockerVolumes,Lookup[myResolvedOptions,OnBoardMixing],numberOfWellsForOBM,Null];

	(* replace objects with resources for each of the samples/standards/blanks - Remember to replace at level 2, since these are nested matching lists*)
	{
		electroosmoticFlowBlockerResources,
		standardElectroosmoticFlowBlockerResources,
		blankElectroosmoticFlowBlockerResources
	} = MapThread[
		Replace[Lookup[#1, #2,{}], electroosmoticFlowBlockerResourceRules, {1}]&,
		{
			{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{ElectroosmoticFlowBlocker,StandardElectroosmoticFlowBlocker,BlankElectroosmoticFlowBlocker}
		}
	];

	(* if total volumes don't sum up to TotalVolume, need to top off with a Diluent - in which case we need to generate redources here *)
	(* First, grab all the relevant fields *)
	diluentTuples =
		Cases[Flatten[MapThread[
			Function[{association, field},Transpose[Lookup[association, field,{}]]],
			{
				{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
				{
					{Diluent,SampleVolume,TotalVolume,AmpholyteVolume,IsoelectricPointMarkersVolume,ElectroosmoticFlowBlockerVolume,DenaturationReagentVolume,AnodicSpacerVolume,CathodicSpacerVolume},
					{StandardDiluent, StandardVolume,StandardTotalVolume,StandardAmpholyteVolume,StandardIsoelectricPointMarkersVolume,StandardElectroosmoticFlowBlockerVolume,StandardDenaturationReagentVolume,StandardAnodicSpacerVolume,StandardCathodicSpacerVolume},
					{BlankDiluent, BlankVolume,BlankTotalVolume,BlankAmpholyteVolume,BlankIsoelectricPointMarkersVolume,BlankElectroosmoticFlowBlockerVolume,BlankDenaturationReagentVolume,BlankAnodicSpacerVolume,BlankCathodicSpacerVolume}
				}
			}
		],1],
			{ObjectP[], VolumeP,VolumeP,{VolumeP..},{VolumeP..}, VolumeP, VolumeP|Null,VolumeP|Null,VolumeP|Null}
		];

	diluentsVolumeOptions =	ReplaceAll[diluentTuples, Null -> 0Microliter];

		(* diluent resources *)
		{
			diluentObjects,
			diluentVolumes
		} = If[Length[diluentsVolumeOptions]>0,
			Transpose[
				MapThread[Function[{diluentObject, sampleVolume, totalVolume, ampholyteVolumes, pIMarkerVolumes, eofBlockerVolume, denaturantVolume, anodicSpacerVolume, cathodicSpacerVolume},
					{diluentObject, totalVolume-Total[{sampleVolume, Total@ampholyteVolumes, Total@pIMarkerVolumes, eofBlockerVolume, denaturantVolume, anodicSpacerVolume, cathodicSpacerVolume}]}
				],
					Transpose[diluentsVolumeOptions]
				]],
			(* if no diluent objects exist, return empty lists *)
			{{},{}}
		];

		(* Make common resource rules for all *)
		diluentResourceRules = reagentResourceRules[diluentObjects, diluentVolumes,Lookup[myResolvedOptions,OnBoardMixing],numberOfWellsForOBM,Null];

		(* replace objects with resources for each of the samples/standards/blanks *)
		{
			diluentResources,
			standardDiluentResources,
			blankDiluentResources
		} = MapThread[
			Replace[Lookup[#1, #2,{}], diluentResourceRules, {1}]&,
			{
				{optionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
				{Diluent,StandardDiluent,BlankDiluent}
			}
		];

	(* Generate OBM vial resources *)(* TODO: Make sure these are the correct vials *)
	onBoardMixingContainersResource = If[Lookup[myResolvedOptions,OnBoardMixing],
		ConstantArray[Resource[Sample->Model[Container, Vessel, "6 mL Shorty Vials, Borosilicate Glass"]], 2],
		{Nothing}
	];

	onBoardMixingWashResource = If[Lookup[myResolvedOptions,OnBoardMixing],
		ConstantArray[Resource[Sample->Model[Sample, "Milli-Q water"], Amount-> 5Milliliter, Container -> Model[Container, Vessel, "6 mL Shorty Vials, Borosilicate Glass"]], 2],
		{Nothing}
	];

	(* we will make a mastermix in a 50 ml conical and dispend to the OBM containers after. need to make a resource for it *)
	onBoardMixingPrepContainerResource = If[Lookup[myResolvedOptions,OnBoardMixing],
		Resource[Sample->Model[Container, Vessel, "50mL Tube"]],
		Null
	];

	(* for cleanup - get a transfer pipette and a beaker for waste *)
	transferPipette = Resource[Sample->Model[Item,Consumable,"VWR Disposable Transfer Pipet"]];
	wasteBeaker = Resource[Sample->Model[Container, Vessel, "50mL Pyrex Beaker"], Rent->True];

	(* -- Generate instrument resources -- *)
	(* we need to consider the time the instrument takes between samples, which is approximately 30 seconds *)
	injectionOverheadTime=20Second;

	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important
	that this estimate is accurate this will probably look like set-up time + time/sample + tear-down time *)
	(* to calculate time needed, consider setup time + the sum of injection time and separation time, for each of samples/standards/blanks and add an overhead between samples, and add teh cleanup time at the end. *)
	(* soubling imaging time because each sample is imaged before focusing for background and after for signal *)
	sampleTimes = Total@MapThread[
		Function[{loadTime, focusingTimes, imagingTimes},
			loadTime+Total@focusingTimes+(2*Total@ToList[imagingTimes])],
		{
			Lookup[optionsWithReplicatesAssociation, LoadTime],
			Lookup[optionsWithReplicatesAssociation, VoltageDurationProfile][[All, All, 2]],
			Lookup[optionsWithReplicatesAssociation, NativeFluorescenceExposureTime]/.Null :> 0Second
		}
	];

	standardTimes = If[includeStandards,
		Total@MapThread[
			Function[{loadTime, focusingTimes, imagingTimes},
				loadTime+Total@focusingTimes+(2*Total@ToList[imagingTimes])],
			{
				Lookup[optionsWithReplicatesAssociation, StandardLoadTime],
				Lookup[optionsWithReplicatesAssociation, StandardVoltageDurationProfile][[All, All, 2]],
				Lookup[optionsWithReplicatesAssociation, StandardNativeFluorescenceExposureTime]/.Null :> 0Second
			}
		],
		0Second
	];

	blankTimes = If[includeBlanks,
		Total@MapThread[
			Function[{loadTime, focusingTimes, imagingTimes},
				loadTime+Total@focusingTimes+(2*Total@ToList[imagingTimes])],
			{
				Lookup[optionsWithReplicatesAssociation, BlankLoadTime],
				Lookup[optionsWithReplicatesAssociation, BlankVoltageDurationProfile][[All, All, 2]],
				Lookup[optionsWithReplicatesAssociation, BlankNativeFluorescenceExposureTime]/.Null :> 0Second
			}
		],
		0Second
	];

	(* Instrument time is the sum of this + setup/teardown. need to make sure the time set for cleanup is correct*)
	(* every 12 injections, the fluoresence is calibrated. *)
	setupTime = 25 Minute + 229Second;
	totalInjections = Length[Lookup[myResolvedOptions, MatchedInjectionTable]];
	runTime =  totalInjections * injectionOverheadTime + sampleTimes+ standardTimes + blankTimes;
	instrumentTime = setupTime + runTime + 30Minute;
	instrumentResource = Resource[Instrument -> Lookup[myResolvedOptions, Instrument], Time -> instrumentTime];

	(* Generate an uploadable version of the injection table *)
	injectionTableToUpload = MapThread[
		Function[{type, sample, volume, index},
			Association[
				Type -> type,
				Sample -> Link[sample/.Join[sampleResourceReplaceRules,standardResourceRules,blankResourceRules]],
				Volume -> volume,
				Data -> Null,
				SampleIndex->index
			]
		],
		Transpose[Lookup[myResolvedOptions, MatchedInjectionTable]]
	];

	(* We are uploading the UNIQUE exposure times to their own field because we will loop over these values when we export the data manually *)
	exposureTimesToUpload = DeleteDuplicates[
		Cases[
			Flatten[
				{
					Lookup[optionsWithReplicatesAssociation,NativeFluorescenceExposureTime,{}],
					Lookup[optionsWithReplicatesAssociation,StandardNativeFluorescenceExposureTime,{}],
					Lookup[optionsWithReplicatesAssociation,BlankNativeFluorescenceExposureTime,{}]
				}
			],
			TimeP
		]
	];
	(* --- Generate the protocol packet --- *)
	protocolPacket=<|
		Type -> Object[Protocol,CapillaryIsoelectricFocusing],
		Object -> CreateID[Object[Protocol,CapillaryIsoelectricFocusing]],
		Replace[SamplesIn] -> (Link[#, Protocols]&)/@samplesInResources,
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@uniqueContainers,
		UnresolvedOptions -> RemoveHiddenOptions[ExperimentCapillaryIsoelectricFocusing, myUnresolvedOptions],
		ResolvedOptions -> RemoveHiddenOptions[ExperimentCapillaryIsoelectricFocusing,myResolvedOptions],
		Template -> If[MatchQ[Lookup[myResolvedOptions, Template], FieldReferenceP[]],
			Link[Most[Lookup[myResolvedOptions, Template]], ProtocolsTemplated],
			Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated]],
		Instrument -> Link[instrumentResource],
		Cartridge -> Link[cartridgeResource],
		RunTime->runTime,
		Replace[InjectionTable] -> injectionTableToUpload,
		NumberOfReplicates -> sampleReplicates,
		SampleTemperature -> Lookup[myResolvedOptions, SampleTemperature],

		(* instrument setup *)
		Anolyte -> Link[anolyteResource],
		Catholyte -> Link[catholyteResource],
		ElectroosmoticConditioningBuffer -> Link[electroosmoticConditioningBufferResource],
		FluorescenceCalibrationStandard -> Link[fluorescenceCalibrationStandardResource],
		Replace[WashSolution] -> (Link[#]&)/@washSolutionResource,
		Replace[PlaceholderContainer] ->  (Link[#]&)/@placeholderContainerResource,
		(*PlateSeal -> plateSealResources, *)
		Replace[Caps] -> (Link[#]&)/@ capResources,
		TransferPipette->Link[transferPipette],
		CartridgeCleanupWasteContainer->Link[wasteBeaker],
		AnolyteStorageCondition -> Lookup[myResolvedOptions,AnolyteStorageCondition],
		CatholyteStorageCondition -> Lookup[myResolvedOptions,CatholyteStorageCondition],
		ElectroosmoticConditioningBufferStorageCondition -> Lookup[myResolvedOptions,ElectroosmoticConditioningBufferStorageCondition],
		FluorescenceCalibrationStandardStorageCondition -> Lookup[myResolvedOptions,FluorescenceCalibrationStandardStorageCondition],
		WashSolutionStorageCondition -> Lookup[myResolvedOptions,WashSolutionStorageCondition],
		CartridgeStorageCondition -> Lookup[myResolvedOptions,CartridgeStorageCondition,{}],
		OnBoardMixing -> Lookup[myResolvedOptions,OnBoardMixing],
		Replace[OnBoardMixingContainers]-> (Link[#]&) /@ onBoardMixingContainersResource,
		OnBoardMixingPrepContainer-> Link[onBoardMixingPrepContainerResource],
		Replace[OnBoardMixingWash]-> (Link[#]&) /@ onBoardMixingWashResource,
		AssayContainer -> Link[assayContainersResource],
		Replace[ExposureTimes]->exposureTimesToUpload,
		(* sample prep *)
		Replace[TotalVolumes] -> Lookup[optionsWithReplicatesAssociation,TotalVolume,{}],
		Replace[SampleVolumes] -> Lookup[optionsWithReplicatesAssociation, SampleVolume,{}],
		Replace[PremadeMasterMixReagents] -> (Link[#]&) /@ premadeMastermixResources,
		Replace[PremadeMasterMixDiluents] -> (Link[#]&) /@ premadeMastermixDiluentResources,
		Replace[PremadeMasterMixReagentDilutionFactors] -> Lookup[optionsWithReplicatesAssociation,PremadeMasterMixReagentDilutionFactor,{}],
		Replace[PremadeMasterMixVolumes] -> Lookup[optionsWithReplicatesAssociation,PremadeMasterMixVolume,{}],
		Replace[Diluents] -> (Link[#]&) /@ diluentResources,
		Replace[DenaturationReagents] -> (Link[#]&) /@ denaturationAgentResources,
		Replace[DenaturationReagentTargetConcentrations] -> Lookup[optionsWithReplicatesAssociation,DenaturationReagentTargetConcentration,{}],
		Replace[DenaturationReagentVolumes] -> Lookup[optionsWithReplicatesAssociation,DenaturationReagentVolume,{}],
		Replace[Ampholytes] -> ToList[(Map[Function[resource, Link[resource[Sample]]], #]&) /@ ampholyteResources]/.{Null}:>Null, (* we are using ListedAmpholytes for resources, this one is just for presentation (and list structure) *)
		Replace[ListedAmpholytes] -> (Link[#]&) /@ Flatten[ampholyteResources],
		Replace[AmpholyteTargetConcentrations] -> Lookup[optionsWithReplicatesAssociation,AmpholyteTargetConcentrations,{}]/.{Null}:>Null,
		Replace[AmpholyteVolumes] -> Lookup[optionsWithReplicatesAssociation,AmpholyteVolume,{}]/.{Null}:>Null,
		Replace[IsoelectricPointMarkers] -> ToList[(Map[Function[resource, Link[resource[Sample]]], #]&) /@ pIMarkerResources]/.{Null}:>Null, (* we are using ListedIsoelectricPointMarkers for resources, this one is just for presentation (and list structure) *)
		Replace[ListedIsoelectricPointMarkers] -> (Link[#]&) /@ Flatten[pIMarkerResources],
		Replace[IsoelectricPointMarkersTargetConcentrations] -> Lookup[optionsWithReplicatesAssociation,IsoelectricPointMarkersTargetConcentrations,{}]/.{Null}:>Null,
		Replace[IsoelectricPointMarkersVolumes] -> Lookup[optionsWithReplicatesAssociation,IsoelectricPointMarkersVolume,{}]/.{Null}:>Null,
		Replace[AnodicSpacers] -> (Link[#]&) /@ anodicSpacerResources,
		Replace[AnodicSpacerTargetConcentrations] -> Lookup[optionsWithReplicatesAssociation,AnodicSpacerTargetConcentration,{}],
		Replace[AnodicSpacerVolumes] -> Lookup[optionsWithReplicatesAssociation,AnodicSpacerVolume,{}],
		Replace[CathodicSpacers] -> (Link[#]&) /@ cathodicSpacerResources,
		Replace[CathodicSpacerTargetConcentrations] -> Lookup[optionsWithReplicatesAssociation,CathodicSpacerTargetConcentration,{}],
		Replace[CathodicSpacerVolumes] -> Lookup[optionsWithReplicatesAssociation,CathodicSpacerVolume,{}],
		Replace[ElectroosmoticFlowBlockers] -> (Link[#]&) /@ electroosmoticFlowBlockerResources,
		Replace[ElectroosmoticFlowBlockerTargetConcentrations] -> Lookup[optionsWithReplicatesAssociation,ElectroosmoticFlowBlockerTargetConcentrations,{}],
		Replace[ElectroosmoticFlowBlockerVolumes] -> Lookup[optionsWithReplicatesAssociation,ElectroosmoticFlowBlockerVolume,{}],
		Replace[AmpholytesStorageConditions] -> Lookup[optionsWithReplicatesAssociation,AmpholytesStorageCondition,{}],
		Replace[IsoelectricPointMarkersStorageConditions] -> Lookup[optionsWithReplicatesAssociation,IsoelectricPointMarkersStorageCondition,{}],
		Replace[DenaturationReagentStorageConditions] -> Lookup[optionsWithReplicatesAssociation,DenaturationReagentStorageCondition,{}],
		Replace[AnodicSpacerStorageConditions] -> Lookup[optionsWithReplicatesAssociation,AnodicSpacerStorageCondition,{}],
		Replace[CathodicSpacerStorageConditions] -> Lookup[optionsWithReplicatesAssociation,CathodicSpacerStorageCondition,{}],
		Replace[ElectroosmoticFlowBlockerStorageConditions] -> Lookup[optionsWithReplicatesAssociation,ElectroosmoticFlowBlockerStorageCondition,{}],
		Replace[DiluentStorageConditions] -> Lookup[optionsWithReplicatesAssociation,DiluentStorageCondition,{}],
		Replace[LoadTimes] -> Lookup[optionsWithReplicatesAssociation,LoadTime,{}],
		Replace[VoltageDurationProfiles] -> Lookup[optionsWithReplicatesAssociation,VoltageDurationProfile,{}],
		Replace[ImagingMethods] -> Lookup[optionsWithReplicatesAssociation,ImagingMethods,{}],
		Replace[NativeFluorescenceExposureTimes] -> Lookup[optionsWithReplicatesAssociation,NativeFluorescenceExposureTime,{}],
		(* Standards *)
		Replace[Standards]-> (Link[#]&) /@ standardResources,
		Replace[StandardStorageConditions]->Lookup[standardOptionsWithReplicatesAssociation,StandardStorageCondition,{}],
		Replace[StandardTotalVolumes] -> Lookup[standardOptionsWithReplicatesAssociation,StandardTotalVolume,{}],
		Replace[StandardVolumes] -> Lookup[standardOptionsWithReplicatesAssociation,StandardVolume,{}],
		Replace[StandardPremadeMasterMixReagents] -> (Link[#]&) /@ standardPremadeMasterMixResources,
		Replace[StandardPremadeMasterMixDiluents] -> (Link[#]&) /@ standardPremadeMasterMixDiluentResources,
		Replace[StandardPremadeMasterMixReagentDilutionFactors] -> Lookup[standardOptionsWithReplicatesAssociation,StandardPremadeMasterMixReagentDilutionFactor,{}],
		Replace[StandardPremadeMasterMixVolumes] -> Lookup[standardOptionsWithReplicatesAssociation,StandardPremadeMasterMixVolume,{}],
		Replace[StandardDiluents] -> (Link[#]&) /@ standardDiluentResources,
		Replace[StandardDenaturationReagents] -> (Link[#]&) /@ standardDenaturationAgentResources,
		Replace[StandardDenaturationReagentTargetConcentrations] -> Lookup[standardOptionsWithReplicatesAssociation,StandardDenaturationReagentTargetConcentration,{}],
		Replace[StandardDenaturationReagentVolumes] -> Lookup[standardOptionsWithReplicatesAssociation,StandardDenaturationReagentVolume,{}],
		Replace[StandardAmpholytes] -> Replace[ToList[(Map[Function[resource, If[!MatchQ[resource,Null],Link[resource[Sample]],Null]], #]&) /@ standardAmpholyteResources],{Null}:>Null,1],
		Replace[ListedStandardAmpholytes] -> (Link[#]&) /@ Flatten[standardAmpholyteResources],
		Replace[StandardAmpholyteTargetConcentrations] -> Lookup[standardOptionsWithReplicatesAssociation,StandardAmpholyteTargetConcentrations,{}]/.{Null}:>Null,
		Replace[StandardAmpholyteVolumes] -> Lookup[standardOptionsWithReplicatesAssociation,StandardAmpholyteVolume,{}]/.{Null}:>Null,
		Replace[StandardIsoelectricPointMarkers] -> Replace[ToList[(Map[Function[resource, If[!MatchQ[resource,Null],Link[resource[Sample]],Null]], #]&) /@ standardpIMarkerResources],{Null}:>Null,1],
		Replace[ListedStandardIsoelectricPointMarkers] -> (Link[#]&) /@ Flatten[standardpIMarkerResources],
		Replace[StandardIsoelectricPointMarkersTargetConcentrations] -> Lookup[standardOptionsWithReplicatesAssociation,StandardIsoelectricPointMarkersTargetConcentrations,{}]/.{Null}:>Null,
		Replace[StandardIsoelectricPointMarkersVolumes] -> Lookup[standardOptionsWithReplicatesAssociation,StandardIsoelectricPointMarkersVolume,{}]/.{Null}:>Null,
		Replace[StandardAnodicSpacers] -> (Link[#]&) /@ standardAnodicSpacerResources,
		Replace[StandardAnodicSpacerTargetConcentrations] -> Lookup[standardOptionsWithReplicatesAssociation,StandardAnodicSpacerTargetConcentration,{}],
		Replace[StandardAnodicSpacerVolumes] -> Lookup[standardOptionsWithReplicatesAssociation,StandardAnodicSpacerVolume,{}],
		Replace[StandardCathodicSpacers] -> (Link[#]&) /@ standardCathodicSpacerResources,
		Replace[StandardCathodicSpacerTargetConcentrations] -> Lookup[standardOptionsWithReplicatesAssociation,StandardCathodicSpacerTargetConcentration,{}],
		Replace[StandardCathodicSpacerVolumes] -> Lookup[standardOptionsWithReplicatesAssociation,StandardCathodicSpacerVolume,{}],
		Replace[StandardElectroosmoticFlowBlockers] -> (Link[#]&) /@ standardElectroosmoticFlowBlockerResources,
		Replace[StandardElectroosmoticFlowBlockerTargetConcentrations] -> Lookup[standardOptionsWithReplicatesAssociation,StandardElectroosmoticFlowBlockerTargetConcentrations,{}],
		Replace[StandardElectroosmoticFlowBlockerVolumes] -> Lookup[standardOptionsWithReplicatesAssociation,StandardElectroosmoticFlowBlockerVolume,{}],
		Replace[StandardAmpholytesStorageConditions] -> Lookup[standardOptionsWithReplicatesAssociation,StandardAmpholytesStorageCondition,{}],
		Replace[StandardIsoelectricPointMarkersStorageConditions] -> Lookup[standardOptionsWithReplicatesAssociation,StandardIsoelectricPointMarkersStorageCondition,{}],
		Replace[StandardDenaturationReagentStorageConditions] -> Lookup[standardOptionsWithReplicatesAssociation,StandardDenaturationReagentStorageCondition,{}],
		Replace[StandardAnodicSpacerStorageConditions] -> Lookup[standardOptionsWithReplicatesAssociation,StandardAnodicSpacerStorageCondition,{}],
		Replace[StandardCathodicSpacerStorageConditions] -> Lookup[standardOptionsWithReplicatesAssociation,StandardCathodicSpacerStorageCondition,{}],
		Replace[StandardElectroosmoticFlowBlockerStorageConditions] -> Lookup[standardOptionsWithReplicatesAssociation,StandardElectroosmoticFlowBlockerStorageCondition,{}],
		Replace[StandardDiluentStorageConditions] -> Lookup[standardOptionsWithReplicatesAssociation,StandardDiluentStorageCondition,{}],
		Replace[StandardLoadTimes] -> Lookup[standardOptionsWithReplicatesAssociation,StandardLoadTime,{}],
		Replace[StandardVoltageDurationProfiles] -> Lookup[standardOptionsWithReplicatesAssociation,StandardVoltageDurationProfile,{}],
		Replace[StandardImagingMethods] -> Lookup[standardOptionsWithReplicatesAssociation,StandardImagingMethods,{}],
		Replace[StandardNativeFluorescenceExposureTimes] -> Lookup[standardOptionsWithReplicatesAssociation,StandardNativeFluorescenceExposureTime,{}],
		(* Blanks *)
		Replace[Blanks]-> (Link[#]&) /@ blankResources,
		Replace[BlankStorageConditions]->Lookup[blankOptionsWithReplicatesAssociation,BlankStorageCondition,{}],
		Replace[BlankTotalVolumes] -> Lookup[blankOptionsWithReplicatesAssociation,BlankTotalVolume,{}],
		Replace[BlankVolumes] -> Lookup[blankOptionsWithReplicatesAssociation,BlankVolume,{}],
		Replace[BlankPremadeMasterMixReagents] ->(Link[#]&) /@ blankPremadeMasterMixResources,
		Replace[BlankPremadeMasterMixDiluents] ->(Link[#]&) /@ blankPremadeMasterMixDiluentResources,
		Replace[BlankPremadeMasterMixReagentDilutionFactors] -> Lookup[blankOptionsWithReplicatesAssociation,BlankPremadeMasterMixReagentDilutionFactor,{}],
		Replace[BlankPremadeMasterMixVolumes] -> Lookup[blankOptionsWithReplicatesAssociation,BlankPremadeMasterMixVolume,{}],
		Replace[BlankDiluents] -> (Link[#]&) /@ blankDiluentResources,
		Replace[BlankDenaturationReagents] -> (Link[#]&) /@ blankDenaturationAgentResources,
		Replace[BlankDenaturationReagentTargetConcentrations] -> Lookup[blankOptionsWithReplicatesAssociation,BlankDenaturationReagentTargetConcentration,{}],
		Replace[BlankDenaturationReagentVolumes] -> Lookup[blankOptionsWithReplicatesAssociation,BlankDenaturationReagentVolume,{}],
		Replace[BlankAmpholytes] -> ToList[(Map[Function[resource, Link[resource[Sample]]], #]&) /@ blankAmpholyteResources]/.{Null}:>Null,
		Replace[ListedBlankAmpholytes] ->(Link[#]&) /@ Flatten[blankAmpholyteResources],
		Replace[BlankAmpholyteTargetConcentrations] -> Lookup[blankOptionsWithReplicatesAssociation,BlankAmpholyteTargetConcentrations,{}]/.{Null}:>Null,
		Replace[BlankAmpholyteVolumes] -> Lookup[blankOptionsWithReplicatesAssociation,BlankAmpholyteVolume,{}]/.{Null}:>Null,
		Replace[BlankIsoelectricPointMarkers] -> ToList[(Map[Function[resource, Link[resource[Sample]]], #]&) /@ blankpIMarkerResources]/.{Null}:>Null,
		Replace[ListedBlankIsoelectricPointMarkers] -> (Link[#]&) /@ Flatten[blankpIMarkerResources],
		Replace[BlankIsoelectricPointMarkersTargetConcentrations] -> Lookup[blankOptionsWithReplicatesAssociation,BlankIsoelectricPointMarkersTargetConcentrations,{}]/.{Null}:>Null,
		Replace[BlankIsoelectricPointMarkersVolumes] -> Lookup[blankOptionsWithReplicatesAssociation,BlankIsoelectricPointMarkersVolume,{}]/.{Null}:>Null,
		Replace[BlankAnodicSpacers] -> (Link[#]&) /@ blankAnodicSpacerResources,
		Replace[BlankAnodicSpacerTargetConcentrations] -> Lookup[blankOptionsWithReplicatesAssociation,BlankAnodicSpacerTargetConcentration,{}],
		Replace[BlankAnodicSpacerVolumes] -> Lookup[blankOptionsWithReplicatesAssociation,BlankAnodicSpacerVolume,{}],
		Replace[BlankCathodicSpacers] -> (Link[#]&) /@ blankCathodicSpacerResources,
		Replace[BlankCathodicSpacerTargetConcentrations] -> Lookup[blankOptionsWithReplicatesAssociation,BlankCathodicSpacerTargetConcentration,{}],
		Replace[BlankCathodicSpacerVolumes] -> Lookup[blankOptionsWithReplicatesAssociation,BlankCathodicSpacerVolume,{}],
		Replace[BlankElectroosmoticFlowBlockers] -> (Link[#]&) /@ blankElectroosmoticFlowBlockerResources,
		Replace[BlankElectroosmoticFlowBlockerTargetConcentrations] -> Lookup[blankOptionsWithReplicatesAssociation,BlankElectroosmoticFlowBlockerTargetConcentrations,{}],
		Replace[BlankElectroosmoticFlowBlockerVolumes] -> Lookup[blankOptionsWithReplicatesAssociation,BlankElectroosmoticFlowBlockerVolume,{}],
		Replace[BlankAmpholytesStorageConditions] -> Lookup[blankOptionsWithReplicatesAssociation,BlankAmpholytesStorageCondition,{}],
		Replace[BlankIsoelectricPointMarkersStorageConditions] -> Lookup[blankOptionsWithReplicatesAssociation,BlankIsoelectricPointMarkersStorageCondition,{}],
		Replace[BlankDenaturationReagentStorageConditions] -> Lookup[blankOptionsWithReplicatesAssociation,BlankDenaturationReagentStorageCondition,{}],
		Replace[BlankAnodicSpacerStorageConditions] -> Lookup[blankOptionsWithReplicatesAssociation,BlankAnodicSpacerStorageCondition,{}],
		Replace[BlankCathodicSpacerStorageConditions] -> Lookup[blankOptionsWithReplicatesAssociation,BlankCathodicSpacerStorageCondition,{}],
		Replace[BlankElectroosmoticFlowBlockerStorageConditions] -> Lookup[blankOptionsWithReplicatesAssociation,BlankElectroosmoticFlowBlockerStorageCondition,{}],
		Replace[BlankDiluentStorageConditions] -> Lookup[blankOptionsWithReplicatesAssociation,BlankDiluentStorageCondition,{}],
		Replace[BlankLoadTimes] -> Lookup[blankOptionsWithReplicatesAssociation,BlankLoadTime,{}],
		Replace[BlankVoltageDurationProfiles] -> Lookup[blankOptionsWithReplicatesAssociation,BlankVoltageDurationProfile,{}],
		Replace[BlankImagingMethods] -> Lookup[blankOptionsWithReplicatesAssociation,BlankImagingMethods,{}],
		Replace[BlankNativeFluorescenceExposureTimes] -> Lookup[blankOptionsWithReplicatesAssociation,BlankNativeFluorescenceExposureTime,{}],
		(* checkpoints *)
		Replace[Checkpoints] -> {
			{"Preparing Samples",30 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Minute]]},
			{"Picking Resources",60 Minute,"Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10 Minute]]},
			{"Preparing Mastermix and Assay Plate Setup",1 Hour,"Mixing reagents for each assay tube, denaturing and centrifuging (if applicable), and loading onto the assay plate.",Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 15 Minute]]},
			{"Preparing Instrument",1Hour,"Setting up the instrument by preparing the experiment cartridge and loading required reagents is performed.",Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 5 Minute]]},
			{"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1*Hour]]},
			{"Running Samples",instrumentTime,"Analyzing the loaded samples by capillary isoelectric focusing.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10*Minute]]},
			{"Instrument Cleanup",30 Minute,"The experiment cartridge is cleaned and used reagents are disposed of.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10*Minute]]},
			{"Returning Materials",10 Minute,"Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10*Minute]]}
		}
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cache,Simulation->updatedSimulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

		(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache->cache,Simulation->updatedSimulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache->cache,Simulation->updatedSimulation], Null}
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {resultRule, testsRule}
];


(* To combine a joined list of ObjectToString Outputs to one list  *)
(* Inputs -
	listOfStrings - list of ObjectToString outputs

	Output - String of a single list of all relevant objects,
	we are assuming the order is samples, standards, and blanks and adding headers to make it easier to know what are the issues.
	*)

combineObjectStrings[listOfStrings_List]:=Module[{outputs},
	outputs = ToString/@Flatten[listOfStrings,1];

	(* wherever we have a faulty sample, add the relevant header (but remember it assumes a specific order of checking for failing samples_ *)
	MapThread[
		If[MatchQ[#1, {}|"{}"],
			Nothing,
			#2<>ToString[#1]
		]&,
		(* some instances check only for samples and standards, so we need to grab the right names, otherwise will get a mapthread error *)
		{outputs, {"SamplesIn: ", "Standards: ", "Blanks: "}[[;;Length[listOfStrings]]]}
	]
];

(* to expandOptions for IndexMatchingParent rather than IndexMatching Input *)
expandNumberOfReplicatesIndexMatchingParent[mySamples_List,myOptions_Association, myNumberOfReplicates_Integer]:=Module[
	{expandedOptions,expandedSamples},
	(* we are getting only options that are indexMatched, so we know they'll have to be expanded. since these are not samples, we are expanding in an alternating fashion e.g, {1,2} with 2 replicates becomes {1,2,1,2} *)
	(* Expand Samples *)
	expandedSamples=Join@@{mySamples}[[ConstantArray[1,myNumberOfReplicates]]];

	(* To expand options, we will map over options and expand as above *)
	expandedOptions =KeyValueMap[
		Function[
			{option, values},
			Rule[
				option,
				Join@@{values}[[ConstantArray[1,myNumberOfReplicates]]]]
		],
		myOptions
	];

	(* Return our expanded samples and options. *)
	{expandedSamples,expandedOptions}
];

(* This function is used to create rules for replacing objects with resources in expanded sample lists (for standards, and blanks) *)
sampleResourceRules[mySamplesWithReplicates:{ObjectP[{Model[Sample], Object[Sample]}]...}, myExpandedVolumes:{VolumeP...}, includeSamples_?BooleanQ]:=Module[
	{pairedObjectsVolumes, objectVolumeRules,objectResourceReplaceRules},
	(* NOTE - we dont need to take replicates into account here, since everything has already been expanded and object replace rules will sum up the volume for all replicates *)
	(* first, check if we need to include these samples or not *)
	If[Not[includeSamples],
		(* not including these, return an empty list *)
		{},
		(* Including these samples! we need to make a couple of rules *)
		(* First, pair mySamples with Volumes. Using rules so we can then Merge *)
		pairedObjectsVolumes = MapThread[
			#1 -> #2&,
			{mySamplesWithReplicates, myExpandedVolumes}
		];

		(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
		objectVolumeRules = Merge[pairedObjectsVolumes, Total];

		(* Make replace rules for objects and their resources; we are making one resource per sample, for all replicates (adding volume for one more replicate for good measure, also make sure there's a reasonable minimum volume) *)
		(* We should always ask for a preferred container for liquid handler compatible purpose. We need to make SamplePreparationPrimitives that is done under MicroLiquidHandling scale  *)
		objectResourceReplaceRules = MapThread[
			Function[{object, volume},
				If[(volume*1.05)<20Microliter,
					object -> Resource[Sample -> Download[object, Object], Name -> ToString[Unique[]], Amount -> 20Microliter, Container -> PreferredContainer[20Microliter, LiquidHandlerCompatible->True]],
					object -> Resource[Sample -> Download[object, Object], Name -> ToString[Unique[]], Amount -> volume * 1.05, Container -> PreferredContainer[volume * 1.05, LiquidHandlerCompatible->True]]
				]
			],
			{Keys[objectVolumeRules],Values[objectVolumeRules]}
		]
	]];

(* This function is used to create rules for replacing objects with resources in expanded option lists (for reagents) *)
(*TODO: add OBM dead volume to resources*)
reagentResourceRules[myReagentWithReplicates:{ObjectP[{Model[Sample], Object[Sample]}]...}, myExpandedVolumes:{VolumeP...}, obm_, numberOfInjections_Integer, minAmount:(VolumeP|Null)]:=Module[
	{pairedObjectsVolumes, objectVolumeRules, objectResourceReplaceRules,obmSampleNumberTopoff},

	(* First, pair mySamples with Volumes. Using rules so we can then Merge *)
	pairedObjectsVolumes = MapThread[
		#1 -> #2&,
		{myReagentWithReplicates, myExpandedVolumes}
	];

	(* to make sure we have enough volume when using on-board mixing, we will figure out if and how many dummy samples
	 we need to add to make sure we can get the required volume from the reagent vials - this is ugly, but better to do it here *)
	obmSampleNumberTopoff=If[obm,
		(* add 15 samples or the difference to 48 to the first or the second vial if theres too little volume to
		handle OBM. According to the engineer, there's a 1.5ml dead volume*)
		(* figure out how many samples we want to top off, either add 1.5 ml or whatever the differece is to 48 samples to the last vial (we have two) *)
		Which[
			numberOfInjections<48, Min[15, 48-numberOfInjections],
			numberOfInjections>48&&numberOfInjections>96, Min[15, 96-numberOfInjections],
			True, 0
		],
		0
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	objectVolumeRules = Merge[pairedObjectsVolumes, Total];

	(* Make replace rules for objects and their resources; we are making one resource per reagent, for all sample prep (adding 5% volume for good measure; make sure there's a reasonable minimum volume ) *)
	(* Because some of these may be water, where a container will have to be  *)
	objectResourceReplaceRules = If[obm,
		(* When using on board mixing, we know we have a single mix makeup so we average the volume per sample and multiply by the number of samples we need to top off *)
		Module[{rules},
			rules = Merge[pairedObjectsVolumes, Total];
			(* map over volume rules, divide by number of samples, and add however many needed to calculate how much we need in total *)
			KeyValueMap[
				Function[{object, volume},
					Module[{totalVolume,finalVolume},
						totalVolume = (volume/numberOfInjections)*(numberOfInjections+obmSampleNumberTopoff);
						finalVolume = If[NullQ[minAmount],
							Max[{totalVolume * 1.05, 20Microliter}],
							Max[{minAmount,totalVolume*1.05,20Microliter}]
						];
						object->Resource[Sample->Download[object,Object],Name->ToString[Unique[]],Amount->finalVolume,Container->PreferredContainer[finalVolume]]
				]],
				objectVolumeRules]
		],
		(* No OBM, no problem *)
		KeyValueMap[
			Function[{object, volume},
				Module[
					{finalVolume},
					finalVolume = If[NullQ[minAmount],
						Max[{volume * 1.05, 20Microliter}],
						Max[{minAmount,volume*1.05,20Microliter}]
					];
					object->Resource[Sample->Download[object,Object],Name->ToString[Unique[]],Amount->finalVolume,Container->PreferredContainer[finalVolume]]
				]
			],
			objectVolumeRules
		]
	]
];

(* ::Subsection:: *)
(*simulateExperimentCapillaryIsoelectricFocusing options*)

DefineOptions[
	simulateExperimentCapillaryIsoelectricFocusing,
	Options:>{CacheOption,SimulationOption}
];

(* ::Subsection:: *)
(*simulateExperimentCapillaryIsoelectricFocusing*)

simulateExperimentCapillaryIsoelectricFocusing[
	myResourcePacket:(PacketP[Object[Protocol, CapillaryIsoelectricFocusing], {Object, ResolvedOptions}]|$Failed),
	mySamples:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentCapillaryIsoelectricFocusing]]:=
	Module[
		{
			cache, simulation, samplePackets, multipleMultiples, resourcePacketNoNMultiples, protocolObject, fulfillmentSimulation,
			simulationWithLabels,updatedSimulation,protocolPacket,workingSamplesPackets,workingStandardsPackets,workingBlanksPackets,
			workingSamplesContainerModelPacket,cartridgeType,electroosmoticConditioningBuffer,fluorescenceCalibrationStandard,
			washSolution,placeholderContainer,onBoardMixingContainers,onBoardMixingWash,informedInjectionTable,
			injectionTableWithWells,samplePrepPlate,obmPrepContainer,updatedInjectionTable,reconstructedAmpholytes,
			reconstructedpIMarkers,reconstructedStandardAmpholytes,reconstructedStandardpIMarkers,reconstructedBlankAmpholytes,
			reconstructedBlankpIMarkers,assignedWells,samplePrepPlateDestinationSamples,samplePrepPlateLookupWell,obmPrepSample,
			OBMDestinationSamples,samplePrepSimulation,cartridgeDestinationSamples,cartridgePrepSimulation,cartridgeSimulation,

			(* SM/SP primitives *)
			premadeMastermixPrimitives,premadeMastermixDilutentPrimitives,ampholytePrimitives,isoelectricPointMarkerPrimitives,
			electroosmoticFlowBlockerPrimitives,denaturationPrimitives,anodicSpacerPrimitives,cathodicSpacerPrimitives,
			diluentPrimitives,workingSamplesPrimitives,wellsAndVolumes,obmTransferVolumes,obmContainerPrimitives,
			samplePrepPrimitives,cartridgePrepPrimitives,
			(* Pleacements *)
			exportedCartridgePlacement,exportedInstrumentPressureCapPlacements,exportedInstrumentPlacements,
			exportedOnBoardMixingContainersPlacement,exportedAssayPlatePlacement,objectsToMove,destinations,locationPackets
		},

		(* Lookup our cache and simulation. *)
		cache=Lookup[ToList[myResolutionOptions], Cache, {}];
		simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];

		(* Download containers from our sample packets. *)
		samplePackets=Download[
			mySamples,
			Packet[Container],
			Cache->cache,
			Simulation->simulation
		];

		(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
		protocolObject=If[MatchQ[myResourcePacket, $Failed],
			SimulateCreateID[Object[Protocol,CapillaryIsoelectricFocusing]],
			Lookup[myResourcePacket, Object]
		];

		(* before we simulate resources, we need to remove multiple-multiple fields - we already have a listed version of those, so its not a problem *)
		multipleMultiples = KeyTake[myResourcePacket, {
			Replace[Ampholytes], Replace[IsoelectricPointMarkers],
			Replace[StandardAmpholytes], Replace[StandardIsoelectricPointMarkers],
			Replace[BlankAmpholytes], Replace[BlankIsoelectricPointMarkers]
		}];

		(* remove multiple-multiple fields from the resource packets *)
		resourcePacketNoNMultiples = KeyDrop[myResourcePacket, {
			Replace[Ampholytes], Replace[IsoelectricPointMarkers],
			Replace[StandardAmpholytes], Replace[StandardIsoelectricPointMarkers],
			Replace[BlankAmpholytes], Replace[BlankIsoelectricPointMarkers]
		}];

		(* Simulate the fulfillment of all resources by the procedure. *)
		(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
		(* just make a shell of a protocol object so that we can return something back. *)
		fulfillmentSimulation=If[MatchQ[resourcePacketNoNMultiples, $Failed],
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
				resourcePacketNoNMultiples,
				Cache->cache,
				Simulation->simulation
			]
		];

		(* Update simulation with fulfillment simulation *)
		updatedSimulation = fulfillmentSimulation;

		(* Get the protocol, instrument, and cartridge information we need *)
		{
			protocolPacket,
			workingSamplesPackets,
			workingStandardsPackets,
			workingBlanksPackets,
			workingSamplesContainerModelPacket,
			cartridgeType,
			electroosmoticConditioningBuffer,
			fluorescenceCalibrationStandard,
			washSolution,
			placeholderContainer,
			onBoardMixingContainers,
			onBoardMixingWash
		}=Quiet[Download[protocolObject,
			{
				Packet[Type, Object,AssayContainer,OnBoardMixingPrepContainer,OnBoardMixing,OnBoardMixingContainers,OnBoardMixingWash,InjectionTable,
					LoadTimes,BlankLoadTimes,StandardLoadTimes,VoltageDurationProfiles,BlankVoltageDurationProfiles,
					StandardVoltageDurationProfiles,NativeFluorescenceExposureTimes,BlankNativeFluorescenceExposureTimes,
					StandardNativeFluorescenceExposureTimes,TotalVolumes,BlankTotalVolumes,StandardTotalVolumes,
					SampleVolumes,BlankVolumes,StandardVolumes,PremadeMasterMixReagents,BlankPremadeMasterMixReagents,
					StandardPremadeMasterMixReagents,PremadeMasterMixDiluents,BlankPremadeMasterMixDiluents,
					StandardPremadeMasterMixDiluents,DenaturationReagents,BlankDenaturationReagents,StandardDenaturationReagents,
					DenaturationReagentVolumes,BlankDenaturationReagentVolumes,StandardDenaturationReagentVolumes,
					ListedIsoelectricPointMarkers,ListedBlankIsoelectricPointMarkers,ListedStandardIsoelectricPointMarkers,IsoelectricPointMarkersVolumes,
					BlankIsoelectricPointMarkersVolumes,StandardIsoelectricPointMarkersVolumes,ListedAmpholytes,ListedBlankAmpholytes,
					ListedStandardAmpholytes,AmpholyteVolumes,BlankAmpholyteVolumes,StandardAmpholyteVolumes,AnodicSpacers,
					BlankAnodicSpacers,StandardAnodicSpacers,AnodicSpacerVolumes,BlankAnodicSpacerVolumes,StandardAnodicSpacerVolumes,
					CathodicSpacers,BlankCathodicSpacers,StandardCathodicSpacers,CathodicSpacerVolumes,BlankCathodicSpacerVolumes,
					StandardCathodicSpacerVolumes,ElectroosmoticFlowBlockers,BlankElectroosmoticFlowBlockers,
					StandardElectroosmoticFlowBlockers,ElectroosmoticFlowBlockerVolumes,BlankElectroosmoticFlowBlockerVolumes,
					StandardElectroosmoticFlowBlockerVolumes,Diluents,BlankDiluents,StandardDiluents,Anolyte,Catholyte,OnBoardMixing,
					Cartridge,ElectroosmoticConditioningBuffer,FluorescenceCalibrationStandard,WashSolution,PlaceholderContainer,AssayContainer],
				SamplesIn[Object],
				Standards[Object],
				Blanks[Object],
				Packet[WorkingSamples[Container][Model]],
				Cartridge[ExperimentType],
				ElectroosmoticConditioningBuffer[Container],
				FluorescenceCalibrationStandard[Container],
				WashSolution[Container],
				PlaceholderContainer,
				OnBoardMixingContainers,
				OnBoardMixingWash[Container]
			},
			Cache->cache,
			Simulation->updatedSimulation,
			Date->Now
		],Download::FieldDoesntExist];

		(* Unflatten listed multiple-multiples based on actual structure *)
		reconstructedAmpholytes=TakeList[Lookup[protocolPacket,ListedAmpholytes],Length/@Lookup[multipleMultiples,Replace[Ampholytes]]];
		reconstructedpIMarkers=TakeList[Lookup[protocolPacket,ListedIsoelectricPointMarkers],Length/@Lookup[multipleMultiples,Replace[IsoelectricPointMarkers]]];

		reconstructedStandardAmpholytes=TakeList[Lookup[protocolPacket,ListedStandardAmpholytes],Length/@Lookup[multipleMultiples,Replace[StandardAmpholytes]]];
		reconstructedStandardpIMarkers=TakeList[Lookup[protocolPacket,ListedStandardIsoelectricPointMarkers],Length/@Lookup[multipleMultiples,Replace[StandardIsoelectricPointMarkers]]];

		reconstructedBlankAmpholytes=TakeList[Lookup[protocolPacket,ListedBlankAmpholytes],Length/@Lookup[multipleMultiples,Replace[BlankAmpholytes]]];
		reconstructedBlankpIMarkers=TakeList[Lookup[protocolPacket,ListedBlankIsoelectricPointMarkers],Length/@Lookup[multipleMultiples,Replace[BlankIsoelectricPointMarkers]]];

		(* add multiple multiple lists (now with objects) to the protocol packet *)
		protocolPacket = Join[
			protocolPacket,
			<|
				Ampholytes->reconstructedAmpholytes,
				IsoelectricPointMarkers->reconstructedpIMarkers,
				StandardAmpholytes->reconstructedStandardAmpholytes,
				StandardIsoelectricPointMarkers->reconstructedStandardpIMarkers,
				BlankAmpholytes->reconstructedBlankAmpholytes,
				BlankIsoelectricPointMarkers->reconstructedBlankpIMarkers
			|>
		];

		(* Add useful information to the injection table. Experiment`Private`updateCEInjectionTable lives in the experimentCESDS's compiler but covers both  *)
		informedInjectionTable=Experiment`Private`updateCEInjectionTable[protocolPacket, workingSamplesPackets,{},workingStandardsPackets,workingBlanksPackets];

		(* Designate wells to each of the samples we run. Experiment`Private`assignCEPlateWell lives in the experimentCESDS's compiler but covers both *)
		injectionTableWithWells=Experiment`Private`assignCEPlateWell[protocolPacket, informedInjectionTable];

		(* to avoid using ExperimentSamplePreparation here, we will create sham samples and uploadSampleTransfer instead of using primitives.
		Older commits use ExperimentSamplePreparation is we need to revert *)
		samplePrepPlate=Download[Lookup[protocolPacket, AssayContainer],Object];

		(* Now we need to make a sham sample in each well we transfer reagents to, so we can use UploadSampleTransfer *)
		assignedWells = ToString/@Lookup[injectionTableWithWells, Well];

		(* upload a sample to each well in teh assay plate *)
		samplePrepPlateDestinationSamples =
      		UploadSample[
				ConstantArray[{{Null,Null}}, Length[assignedWells]],
				Transpose[{assignedWells, ConstantArray[samplePrepPlate, Length[assignedWells]]}],
				Simulation -> updatedSimulation,
				UpdatedBy->protocolObject,
				Upload->False,
				SimulationMode -> True
		];

		(* if needed, update simulation *)
		updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[samplePrepPlateDestinationSamples]];

		(* make lookup associations to match well and sample in each container - because we're not really uploading, get positions from the upload packet *)
		samplePrepPlateLookupWell = MapThread[
			#1->#2&,
			Transpose[Cases[Lookup[samplePrepPlateDestinationSamples, {Position, Object}], {WellP,ObjectP[]}]]
		];

		(* if using OnBoradMixing, we will aliquot everything to a 50mL conical tube, and then dispense to vials (up to 5 ml per vial) *)
		(* note that OBM allows a SINGLE mastermix makeup at the moment. *)
		obmPrepContainer=If[Lookup[protocolPacket, OnBoardMixing],
			Download[Lookup[protocolPacket, OnBoardMixingPrepContainer],Object],
			Null
		];

		obmPrepSample = If[Lookup[protocolPacket, OnBoardMixing],
			UploadSample[
				{{Null,Null}},
				{"A1", obmPrepContainer},
				Simulation -> updatedSimulation,
				UpdatedBy->protocolObject,
				Upload->False,
				SimulationMode -> True
			],
			Null
		];

		(* if needed, update simulation *)
		updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[obmPrepSample]];

		(* premadeMasterMix reagent+diluent primitives *)
		{
			premadeMastermixPrimitives,
			premadeMastermixDilutentPrimitives
		} = If[Lookup[protocolPacket, OnBoardMixing],
			Module[{premadeMastermixPrimitive,premadeMastermixDiluentPrimitive,valuesToKeep,premadeMastermixQ,diluentVolume},
				(* We can assume only a single mastermix composition is allowed, since it is checked in the resolver *)
				(* first, make sure we are not taking any repeat injections into account *)
				valuesToKeep = Map[
					(#!=0Microliter)&,
					Lookup[injectionTableWithWells, SampleVolumes]
				];
				(* check if we need to consider premade mastermix or not *)
				premadeMastermixQ = Not[Or@@(NullQ[Lookup[injectionTableWithWells, PremadeMasterMixReagents]])];

				(* if a premade mastermix was used, sum the volumes and transfer all to the prep container (we know  *)
				premadeMastermixPrimitive = If[premadeMastermixQ,
					UploadSampleTransfer[
						Download[First[DeleteDuplicates[PickList[Lookup[injectionTableWithWells, PremadeMasterMixReagents],valuesToKeep]]],Object],
						obmPrepSample,
						Total[PickList[Lookup[injectionTableWithWells, PremadeMasterMixVolumes],valuesToKeep]]*1.05,
						Simulation -> updatedSimulation,
						UpdatedBy->protocolObject,
						Upload->False
					],
					Null
				];

				(* calculate the diluent volume per tube but subtracting the mastermix volume from the known volume of mastermix per sample (100 ul) *)
				diluentVolume = If[premadeMastermixQ,
					RoundOptionPrecision[100Microliter - First[DeleteDuplicates[PickList[Lookup[injectionTableWithWells, PremadeMasterMixVolumes],valuesToKeep]]], 10^-1Microliter],
					0Microliter
				];

				(* based on the number of discrete samples and the required volume, transfer the diluent to the prep container  *)
				premadeMastermixDiluentPrimitive = If[premadeMastermixQ&&diluentVolume>0Microliter,
					UploadSampleTransfer[
						Download[First[DeleteDuplicates[PickList[Lookup[injectionTableWithWells,PremadeMasterMixDiluents],valuesToKeep]]],Object],
						obmPrepSample,
						diluentVolume*Length[PickList[Lookup[injectionTableWithWells,PremadeMasterMixReagents],valuesToKeep]]*1.05,
						Simulation -> updatedSimulation,
						UpdatedBy->protocolObject,
						Upload->False
					],
					Null
				];

				(* return primitives *)
				{premadeMastermixPrimitive, premadeMastermixDiluentPrimitive}
			],
			(* If not using OnBoardMixing *)
			Transpose[MapThread[
				Function[{reagent, reagentVolume, diluent, totalVolume, sampleVolume, well},
					Module[{diluentVolume, premadeMastermixQ, premadeMastermixPrimitive, premadeMastermixDiluentPrimitive},
						(* check if premademastermix options are informed. Even if they are informed, if the sample volume is 0Microliter, it means this is a replicates so we should skip this one *)
						premadeMastermixQ = If[sampleVolume == 0Microliter,
							False,
							Not[Or[NullQ[reagent], NullQ[reagentVolume], NullQ[diluent]]]
						];

						(* if we are using a premademastermix, see if we need to diute anything *)
						diluentVolume = If[premadeMastermixQ,
							totalVolume - sampleVolume - reagentVolume,
							Null
						];

						(* If, indeed we are using a premade mastermix, we can transfer it to the samplePrep plate *)
						premadeMastermixPrimitive = If[premadeMastermixQ,
							UploadSampleTransfer[
								Download[reagent,Object],
								Lookup[samplePrepPlateLookupWell, well],
								reagentVolume,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							],
							Null
						];

						(* now, if we are using a premade mastermix, we need to check if we need a diluent and transfer it to the sample prep tube *)
						premadeMastermixDiluentPrimitive = If[premadeMastermixQ && (diluentVolume > 0Microliter),
							UploadSampleTransfer[
								Download[diluent,Object],
								Lookup[samplePrepPlateLookupWell, well],
								diluentVolume,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							],
							Null
						];

						(* return primitives *)
						{premadeMastermixPrimitive, premadeMastermixDiluentPrimitive}
					]],
				Transpose[Lookup[injectionTableWithWells, {PremadeMasterMixReagents,PremadeMasterMixVolumes,PremadeMasterMixDiluents,TotalVolumes, SampleVolumes, Well}]]
			]]
		];

		{
			ampholytePrimitives,
			isoelectricPointMarkerPrimitives,
			electroosmoticFlowBlockerPrimitives,
			denaturationPrimitives,
			anodicSpacerPrimitives,
			cathodicSpacerPrimitives,
			diluentPrimitives
		} = If[Lookup[protocolPacket, OnBoardMixing],
			Module[
				{
					diluentVolume,denaturationReagentPrimitive,ampholytePrimitive,isoelectricPointMarkerPrimitive,
					anodicSpacerPrimitive,cathodicSpacerPrimitive,electroosmoticFlowBlockerPrimitive,diluentPrimitive,valuesToKeep,
					premadeMastermixQ,amopholytePairs,ampholyteRules,pIMarkerPairs, pIMarkerRules
				},
				(* We can assume only a single mastermix composition is allowed, since it is checked in the resolver *)
				(* first, make sure we are not taking any repeat injections into account *)
				valuesToKeep = Map[
					(#!=0Microliter)&,
					Lookup[injectionTableWithWells, SampleVolumes]
				];
				(* check if we need to consider premade mastermix or not *)
				premadeMastermixQ = Not[Or@@(NullQ[Lookup[injectionTableWithWells, PremadeMasterMixReagents]])];

				(* Ampholytes is a list of lists, so to handle different reagents, we will first match reagents and volumes *)
				amopholytePairs = If[Not[premadeMastermixQ],
					MapThread[
						Function[{key, value}, Rule[key, value]],
						(* it is important not to count repeated injections from the same vial  *)
						{
							Flatten@PickList[Lookup[injectionTableWithWells, Ampholytes],valuesToKeep],
							Flatten@PickList[Lookup[injectionTableWithWells, AmpholyteVolumes],valuesToKeep]
						}
					],
					Null
				];

				(* We now sum the volumes by reagent *)
				ampholyteRules = If[Not[premadeMastermixQ],
					Merge[amopholytePairs, Total],
					Null
				];

				(* Now we can make a Transfer primitive for each reagent *)
				ampholytePrimitive = If[Not[premadeMastermixQ],
					KeyValueMap[
						Function[{key, value},
							UploadSampleTransfer[
								Download[key,Object],
								obmPrepSample,
								value*1.05,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							]
						],
						ampholyteRules],
					Null
				];

				(* Similarly, pI markers are in a list of lists, so to handle different reagents, we will first match reagents and volumes *)
				pIMarkerPairs = If[Not[premadeMastermixQ],
					MapThread[
						Function[{key, value}, Rule[key, value]],
						(* it is important not to count repeated injections from the same vial  *)
						{
							Flatten@PickList[Lookup[injectionTableWithWells, IsoelectricPointMarkers],valuesToKeep],
							Flatten@PickList[Lookup[injectionTableWithWells, IsoelectricPointMarkersVolumes],valuesToKeep]
						}
					],
					Null
				];

				(* We now sum the volumes by reagent *)
				pIMarkerRules = If[Not[premadeMastermixQ],
					Merge[pIMarkerPairs, Total],
					Null
				];

				(* Now we can make a Transfer primitive for each reagent *)
				isoelectricPointMarkerPrimitive = If[Not[premadeMastermixQ],
					KeyValueMap[
						Function[{key, value},
							UploadSampleTransfer[
								Download[key,Object],
								obmPrepSample,
								value*1.05,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							]
						],
						pIMarkerRules],
					Null
				];

				(* if a premade mastermix was not used, sum the volumes of DenaturationReagents and transfer all to the prep container (we know  *)
				denaturationReagentPrimitive = If[Not[premadeMastermixQ]&&Not[Or@@(NullQ[Lookup[injectionTableWithWells, DenaturationReagents]])],
					UploadSampleTransfer[
						First[DeleteDuplicates[PickList[Lookup[injectionTableWithWells,DenaturationReagents],valuesToKeep]]],
						obmPrepSample,
						Total[PickList[Lookup[injectionTableWithWells,DenaturationReagentVolumes],valuesToKeep]]*1.05,
						Simulation -> updatedSimulation,
						UpdatedBy->protocolObject,
						Upload->False
					],
					Null
				];

				(* if a premade mastermix was not used, sum the volumes of ElectroosmoticFlowBlockers and transfer all to the prep container (we know  *)
				electroosmoticFlowBlockerPrimitive = If[Not[premadeMastermixQ],
					UploadSampleTransfer[
						Download[First[DeleteDuplicates[PickList[Lookup[injectionTableWithWells,ElectroosmoticFlowBlockers],valuesToKeep]]],Object],
						obmPrepSample,
						Total[PickList[Lookup[injectionTableWithWells,ElectroosmoticFlowBlockerVolumes],valuesToKeep]]*1.05,
						Simulation -> updatedSimulation,
						UpdatedBy->protocolObject,
						Upload->False
					],
					Null
				];

				(* if a premade mastermix was not used, sum the volumes of CathodicSpacers and transfer all to the prep container (we know  *)
				cathodicSpacerPrimitive = If[Not[premadeMastermixQ]&&Not[Or@@(NullQ[Lookup[injectionTableWithWells, CathodicSpacers]])],
					UploadSampleTransfer[
						Download[First[DeleteDuplicates[PickList[Lookup[injectionTableWithWells,CathodicSpacers],valuesToKeep]]],Object],
						obmPrepSample,
						Total[PickList[Lookup[injectionTableWithWells,CathodicSpacerVolumes],valuesToKeep]]*1.05,
						Simulation -> updatedSimulation,
						UpdatedBy->protocolObject,
						Upload->False
					],
					Null
				];

				(* if a premade mastermix was not used, sum the volumes of AnodicSpacers and transfer all to the prep container (we know  *)
				anodicSpacerPrimitive = If[Not[premadeMastermixQ]&&Not[Or@@(NullQ[Lookup[injectionTableWithWells, AnodicSpacers]])],
					UploadSampleTransfer[
						Download[First[DeleteDuplicates[PickList[Lookup[injectionTableWithWells,AnodicSpacers],valuesToKeep]]],Object],
						obmPrepSample,
						Total[PickList[Lookup[injectionTableWithWells,AnodicSpacerVolumes],valuesToKeep]]*1.05,
						Simulation -> updatedSimulation,
						UpdatedBy->protocolObject,
						Upload->False
					],
					Null
				];

				(* calculate the diluent volume per tube but subtracting reagent volumes from the total known volume of mastermix per sample (100 ul for each) *)
				diluentVolume = If[Not[premadeMastermixQ],
					RoundOptionPrecision[(100Microliter * Length[Select[valuesToKeep, TrueQ]] -
						Total[Values[ampholyteRules]] -
						Total[Values[pIMarkerRules]] -
						Total[PickList[Lookup[injectionTableWithWells, ElectroosmoticFlowBlockerVolumes],valuesToKeep]] -
						Total[PickList[Lookup[injectionTableWithWells, DenaturationReagentVolumes],valuesToKeep]/. Null:> 0Microliter] -
						Total[PickList[Lookup[injectionTableWithWells, CathodicSpacerVolumes],valuesToKeep]/. Null:> 0Microliter] -
						Total[PickList[Lookup[injectionTableWithWells, AnodicSpacerVolumes],valuesToKeep]/. Null:> 0Microliter])*1.05,10^-1],
					0Microliter
				];

				(* based on the number of discrete samples and the required volume, transfer the diluent to the prep container  *)
				diluentPrimitive = If[Not[premadeMastermixQ]&&diluentVolume>0Microliter,
					UploadSampleTransfer[
						Download[First[DeleteDuplicates[PickList[Lookup[injectionTableWithWells,Diluents],valuesToKeep]]],Object],
						obmPrepSample,
						diluentVolume,
						Simulation -> updatedSimulation,
						UpdatedBy->protocolObject,
						Upload->False
					],
					Null
				];

				(* return primitives *)
				{ampholytePrimitive, isoelectricPointMarkerPrimitive, electroosmoticFlowBlockerPrimitive, denaturationReagentPrimitive, anodicSpacerPrimitive, cathodicSpacerPrimitive, diluentPrimitive}
			],
			(* If not using OnBoardMixing *)
			Transpose[MapThread[
				Function[
					{
						denaturationReagent, denaturationReagentVolume, ampholytes, ampholyteVolumes, isoelectricPointMarkers,
						isoelectricPointMarkersVolumes, anodicSpacer, anodicSpacerVolume, cathodicSpacer, cathodicSpacerVolume,
						electroosmoticFlowBlocker, electroosmoticFlowBlockerVolume, diluent, totalVolume, sampleVolume, well
					},
					Module[
						{
							diluentVolume,makeOwnMastermixQ,denaturationReagentPrimitive,ampholytePrimitive,isoelectricPointMarkerPrimitive,
							anodicSpacerPrimitive,cathodicSpacerPrimitive,electroosmoticFlowBlockerPrimitive,diluentPrimitive
						},
						(* If Any of these options are informed,Even if they are informed, if the sample volume is 0Microliter, it means this is a replicates so we should skip this one    *)
						makeOwnMastermixQ = If[sampleVolume == 0Microliter,
							False,
							Or@@(!NullQ[#]&)/@{denaturationReagent, denaturationReagentVolume, ampholytes, ampholyteVolumes, isoelectricPointMarkers,
								isoelectricPointMarkersVolumes, anodicSpacer, anodicSpacerVolume, cathodicSpacer, cathodicSpacerVolume,
								electroosmoticFlowBlocker, electroosmoticFlowBlockerVolume, diluent}
						];

						(* If making our own mastermix , transfer ampholytes to the samplePrep plate, there can be multiple ampholytes so we need to nest a mapthread here *)
						ampholytePrimitive = If[makeOwnMastermixQ,
							MapThread[Function[{ampholyte, volume},
								UploadSampleTransfer[
									Download[ampholyte,Object],
									Lookup[samplePrepPlateLookupWell, well],
									volume,
									Simulation -> updatedSimulation,
									UpdatedBy->protocolObject,
									Upload->False
								]],
								{ampholytes, ampholyteVolumes}
							],
							Null
						];

						(* If making our own mastermix , transfer isoelectric Point Markers to the samplePrep plate, there can be multiple isoelectric Point Markers so we need to nest a mapthread here *)
						isoelectricPointMarkerPrimitive = If[makeOwnMastermixQ,
							MapThread[Function[{isoelectricPointMarker, volume},
								UploadSampleTransfer[
									Download[isoelectricPointMarker,Object],
									Lookup[samplePrepPlateLookupWell, well],
									volume,
									Simulation -> updatedSimulation,
									UpdatedBy->protocolObject,
									Upload->False
								]],
								{isoelectricPointMarkers,isoelectricPointMarkersVolumes}
							],
							Null
						];

						(* If making our own mastermix , transfer the electroosmotic Flow Blocker to the samplePrep plate *)
						electroosmoticFlowBlockerPrimitive = If[makeOwnMastermixQ,
							UploadSampleTransfer[
								Download[electroosmoticFlowBlocker,Object],
								Lookup[samplePrepPlateLookupWell, well],
								electroosmoticFlowBlockerVolume,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							],
							Null
						];

						(* If making our own mastermix and requiring denaturation, transfer a denaturation agent to the samplePrep plate *)
						denaturationReagentPrimitive = If[makeOwnMastermixQ&&!NullQ[denaturationReagent],
							UploadSampleTransfer[
								Download[denaturationReagent,Object],
								Lookup[samplePrepPlateLookupWell, well],
								denaturationReagentVolume,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							],
							Null
						];

						(* If making our own mastermix and requiring an anodicSpacer, transfer the anodic Spacer to the samplePrep plate *)
						anodicSpacerPrimitive = If[makeOwnMastermixQ&&!NullQ[anodicSpacer],
							UploadSampleTransfer[
								Download[anodicSpacer,Object],
								Lookup[samplePrepPlateLookupWell, well],
								anodicSpacerVolume,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							],
							Null
						];

						(* If making our own mastermix and requiring an anodicSpacer, transfer the anodic Spacer to the samplePrep plate *)
						cathodicSpacerPrimitive = If[makeOwnMastermixQ&&!NullQ[cathodicSpacer],
							UploadSampleTransfer[
								Download[cathodicSpacer,Object],
								Lookup[samplePrepPlateLookupWell, well],
								cathodicSpacerVolume,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							],
							Null
						];

						(* If we are making our own mastermix, see if we need to add a diuent *)
						diluentVolume = If[makeOwnMastermixQ,
							RoundOptionPrecision[(totalVolume - sampleVolume - Total@ampholyteVolumes - Total@isoelectricPointMarkersVolumes - electroosmoticFlowBlockerVolume - denaturationReagentVolume /. Null:> 0Microliter - anodicSpacerVolume /. Null:> 0Microliter - cathodicSpacerVolume/. Null:> 0Microliter),10^-1],
							Null
						];

						(* now, if we are using a premade mastermix, we need to check if we need a diluent and transfer it to the sample prep tube *)
						diluentPrimitives = If[makeOwnMastermixQ && (diluentVolume > 0Microliter),
							UploadSampleTransfer[
								Download[diluent,Object],
								Lookup[samplePrepPlateLookupWell, well],
								diluentVolume,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							],
							Null
						];

						(* return primitives *)
						{ampholytePrimitive, isoelectricPointMarkerPrimitive, electroosmoticFlowBlockerPrimitive, denaturationReagentPrimitive, anodicSpacerPrimitive, cathodicSpacerPrimitive, diluentPrimitives}
					]],
				Transpose[Lookup[injectionTableWithWells, {DenaturationReagents, DenaturationReagentVolumes, Ampholytes, AmpholyteVolumes,
					IsoelectricPointMarkers,IsoelectricPointMarkersVolumes, AnodicSpacers, AnodicSpacerVolumes, CathodicSpacers, CathodicSpacerVolumes,
					ElectroosmoticFlowBlockers, ElectroosmoticFlowBlockerVolumes,Diluents,TotalVolumes,SampleVolumes,Well}]]
			]]
		];

		(* sample/standard/blank primitives *)
		(* This relies on adding samples to an already prepared plate, so we can mix again *)
		workingSamplesPrimitives = MapThread[
			Function[{workingSample, sampleVolume, well},
				(* no need to generate primitives if this is a replicate injection --> volume is 0 Microliter *)
				If[sampleVolume>0Microliter,
					UploadSampleTransfer[
						workingSample,
						Lookup[samplePrepPlateLookupWell, well],
						sampleVolume,
						Simulation -> updatedSimulation,
						UpdatedBy->protocolObject,
						Upload->False
					],
					Nothing
				]
			],
			Transpose[Lookup[injectionTableWithWells,{WorkingSample,SampleVolumes,Well}]]
		];

		(* Add another mix for the whole plate for good measure, First get total volumes *)
		wellsAndVolumes = If[Lookup[protocolPacket, OnBoardMixing],
			(* if using onBoardMixing, just grab the total *)
			100Microliter * Length[Select[Map[(#!=0Microliter)&,Lookup[injectionTableWithWells, SampleVolumes]], TrueQ]],
			(* In not using OnBoardMixing, we need to make sure to avoid reinjections, so first get unduplicated wells and volumes *)
			Part[
				SortBy[Last] /@ GatherBy[Lookup[injectionTableWithWells,{Well, TotalVolumes}], #[[1]] &],
				All,
				-1,
				1 ;; 2
			]
		];

		(* to generate primitives to transfer from conical tube to OBM vials, we need to know if we need one or two. each vial can handle 48 injections of 100ul *)
		obmTransferVolumes = If[Lookup[protocolPacket, OnBoardMixing],
			If[wellsAndVolumes >= 4.8Milliliter,
				(* volume greater than 4.8 millliliter, hence we need two vials *)
				{5Milliliter,(wellsAndVolumes*1.04)-5Milliliter},
				(* volume smaller than 4.8 millliliter, grab everything we have (a bit less, actually) *)
				{wellsAndVolumes*1.04,0Microliter}
			],
			(* if not using OBM, no need to worry about this *)
			Null
		];

		(* make sham samples in OBM containers for UploadSampleTransfer *)
		OBMDestinationSamples = If[Lookup[protocolPacket, OnBoardMixing],
			UploadSample[
				ConstantArray[{{Null,Null}}, 2],
				Transpose[{{"A1","A1"}, Download[Flatten@Lookup[protocolPacket, OnBoardMixingContainers], Object]}],
				Simulation -> updatedSimulation,
				UpdatedBy->protocolObject,
				Upload->False,
				SimulationMode -> True
			],
			Null
		];

		(* if needed, update simulation *)
		updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[OBMDestinationSamples]];

		(* if we prepared samples for onBoard mixing, everything is in a 50ml tube and needs to be transferred to the proper container *)
		(* map threading here because we could have one or two vials *)
		obmContainerPrimitives = If[Lookup[protocolPacket, OnBoardMixing],
			MapThread[
				Function[{volume, destination},
					UploadSampleTransfer[
						obmPrepSample,
						destination,
						volume,
						Simulation -> updatedSimulation,
						UpdatedBy->protocolObject,
						Upload->False
					]],
				{obmTransferVolumes, Download[Flatten@Lookup[protocolPacket, OnBoardMixingContainers], Object]}
			],
			Null
		];

		(* order primitives and replace all nulls with Nothing so they're out of the way.. *)
		samplePrepPrimitives = Flatten[Cases[
			{
				premadeMastermixPrimitives,premadeMastermixDilutentPrimitives,ampholytePrimitives,isoelectricPointMarkerPrimitives,electroosmoticFlowBlockerPrimitives,
				denaturationPrimitives,anodicSpacerPrimitives,cathodicSpacerPrimitives,diluentPrimitives,workingSamplesPrimitives,obmContainerPrimitives
			},
			!NullQ[#]&
		],1];

		(* if needed, update simulation *)
		samplePrepSimulation = UpdateSimulation[updatedSimulation,Simulation[samplePrepPrimitives]];

		(* generate sham samples in the cartridge *)
		cartridgeDestinationSamples = UploadSample[
			{{{Null,Null}},{{Null,Null}}},
			{{"H+ Slot",Download[Lookup[protocolPacket,Cartridge],Object]},{"OH- Slot",Download[Lookup[protocolPacket,Cartridge],Object]}},
			Simulation -> samplePrepSimulation,
			UpdatedBy->protocolObject,
			Upload->False,
			SimulationMode -> True
		];

		If[MatchQ[cartridgeDestinationSamples, {_Association ..}],
			(
				(* if needed, update simulation *)
				cartridgeSimulation=UpdateSimulation[samplePrepSimulation,Simulation[cartridgeDestinationSamples]];
				(* Generate transfers to load the catholyte and anolyte on the cartridge *)
				cartridgePrepPrimitives=UploadSampleTransfer[
					{Download[Lookup[protocolPacket,Anolyte],Object], Download[Lookup[protocolPacket,Catholyte],Object]},
					Cases[Lookup[cartridgeDestinationSamples, {Position, Object}], {LocationPositionP,ObjectP[]}][[All, 2]],
					{2Milliliter, 2Milliliter},
					Simulation -> cartridgeSimulation,
					UpdatedBy->protocolObject,
					Upload->False
				]
			),
			(
				cartridgeSimulation=samplePrepSimulation;
				cartridgePrepPrimitives = Null
			)
		];

		(* if needed, update simulation *)
		cartridgePrepSimulation = UpdateSimulation[cartridgeSimulation,Simulation[cartridgePrepPrimitives]];

		(* designate placement for the cartridge loaded on the instrument *)
		exportedCartridgePlacement={{Download[Lookup[protocolPacket,Cartridge],Object],{"Cartridge Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}}};

		(* we are splitting placement tuples here to allow adding elaborate instructions ahead of each one *)
		(* designate placements for reagents loaded on the instrument *)
		exportedInstrumentPressureCapPlacements=
			{
				{Download[electroosmoticConditioningBuffer,Object],{"P1 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
				{Download[fluorescenceCalibrationStandard,Object],{"P2 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
				{Download[washSolution[[1]],Object],{"P3 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
				{Download[placeholderContainer[[1]],Object],{"P6 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}}
			};

		(* OBM requires additional vials for wash, requires difference placements *)
		exportedInstrumentPlacements=If[Lookup[protocolPacket,OnBoardMixing],
			{
				{Download[washSolution[[2]],Object],{"N1 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
				{Download[washSolution[[3]],Object],{"N2 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
				{Download[placeholderContainer[[2]],Object],{"N3 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}}
			},
			{
				{Download[washSolution[[2]],Object],{"N1 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}}
			}
		];

		(* if we have less than 48 samples, only one vial needs to be places for mastermix *)
		exportedOnBoardMixingContainersPlacement=If[Lookup[protocolPacket,OnBoardMixing],
			If[Length[onBoardMixingContainers]>1,
				{
					{Download[onBoardMixingContainers[[1]],Object],{"M1 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
					{Download[onBoardMixingContainers[[2]],Object],{"M2 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
					{Download[onBoardMixingWash[[1]],Object],{"M3 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
					{Download[onBoardMixingWash[[2]],Object],{"M4 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}}
				},
				{
					{Download[onBoardMixingContainers[[1]],Object],{"M1 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
					{Download[onBoardMixingWash[[1]],Object],{"M3 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
					{Download[onBoardMixingWash[[2]],Object],{"M4 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}}
				}
			],
			Null
		];

		(* designate placement for the assay plate loaded on the instrument *)
		(* taking the last because if we incubate or spin, there would be two plates here, the first is a prep plate and the second is teh assay plate *)
		exportedAssayPlatePlacement={{Download[Lookup[protocolPacket,AssayContainer],Object],{"Plate Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}}};

		(* Collate all placements to two lists for UploadLocation *)
		{objectsToMove, destinations} = Transpose[Flatten[
			{
				exportedInstrumentPressureCapPlacements,
				exportedInstrumentPlacements,
				exportedCartridgePlacement,
				exportedAssayPlatePlacement
			},1]];

		(* Upload new locations of all reagents to instrument *)
		locationPackets = UploadLocation[objectsToMove, destinations, Simulation->cartridgePrepSimulation, UpdatedBy->protocolObject, Upload->False];

		(* update Simulation *)
		updatedSimulation = If[MatchQ[locationPackets, {_Association ..}],
			UpdateSimulation[cartridgePrepSimulation,Simulation[locationPackets]],
			cartridgePrepSimulation
		];

		(* if we had any entries in the injection table that were models, replace them with the appropriate objects *)
		updatedInjectionTable = MapThread[
			Function[{type, sample, volume, data, workingSample},
				If[MatchQ[sample, ObjectP[Model[]]],
					<|Type -> type, Sample -> Link[Download[workingSample, Object]],Volume -> volume, Data -> data |>,
					<|Type -> type, Sample -> Link[Download[sample, Object]],Volume -> volume, Data -> data |>]],
			Transpose[Lookup[injectionTableWithWells, {Type, Sample, Volume, Data, WorkingSample}]]
		];

		(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
		(* SamplesIn field. *)
		simulationWithLabels=Simulation[
			Labels->Join[
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
					{_String, ObjectP[]}
				],
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}],
					{_String, ObjectP[]}
				]
			],
			LabelFields->Join[
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
					{_String, _}
				],
				Rule@@@Cases[
					Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
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


(* ::Subsection::Closed:: *)
(*Sister Functions*)

(* ::Subsection::Closed:: *)
(*ExperimentCapillaryIsoelectricFocusingOptions*)

DefineOptions[ExperimentCapillaryIsoelectricFocusingOptions,
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
	SharedOptions:>{ExperimentCapillaryIsoelectricFocusing}
];

(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer pair inputs---*)
ExperimentCapillaryIsoelectricFocusingOptions[
	mySamples:ListableP[ObjectP[Object[Container]]]|ListableP[(ObjectP[Object[Sample]]|_String)],
	myOptions:OptionsPattern[ExperimentCapillaryIsoelectricFocusingOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentCapillaryIsoelectricFocusing[mySamples,preparedOptions];

	(* If options fail, return failure *)
	If[MatchQ[resolvedOptions,$Failed],
		Return[$Failed]
	];

	(*Return the option as a list or table*)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentCapillaryIsoelectricFocusing],
		resolvedOptions
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentCapillaryIsoelectricFocusingQ*)

DefineOptions[ValidExperimentCapillaryIsoelectricFocusingQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{ExperimentCapillaryIsoelectricFocusing}
];

ValidExperimentCapillaryIsoelectricFocusingQ[mySamples:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentCapillaryIsoelectricFocusingQ]]:=Module[
	{listedOptions,preparedOptions,capillaryIsoelectricFocusingTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for ExperimentCapillaryIsoelectricFocusing *)
	capillaryIsoelectricFocusingTests=ExperimentCapillaryIsoelectricFocusing[mySamples,Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails).";

	(*Make a list of all of the tests, including the blanket test *)
	allTests=If[MatchQ[capillaryIsoelectricFocusingTests,$Failed],
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
			Flatten[{initialTest,capillaryIsoelectricFocusingTests,voqWarnings}]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentCapillaryIsoelectricFocusingQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentCapillaryIsoelectricFocusingQ"]
];


(* ::Subsection:: *)
(*ExperimentCapillaryIsoelectricFocusingPreview*)

DefineOptions[ExperimentCapillaryIsoelectricFocusingPreview,
	SharedOptions:>{ExperimentCapillaryIsoelectricFocusing}
];

ExperimentCapillaryIsoelectricFocusingPreview[mySamples:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[ExperimentCapillaryIsoelectricFocusingPreview]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentCapillaryIsoelectricFocusing[mySamples,ReplaceRule[listedOptions,Output->Preview]]
];
