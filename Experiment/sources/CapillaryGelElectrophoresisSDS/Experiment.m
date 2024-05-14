(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Authors[updateCEInjectionTable]:={"gil.sharon"};
Authors[assignCEPlateWell]:={"gil.sharon"};

(* ::Subsubsection::Closed:: *)
(* ExperimentCapillaryGelElectrophoresisSDS Options *)


DefineOptions[ExperimentCapillaryGelElectrophoresisSDS,
	Options:>{
		(* General Options *)
		{
			OptionName->Instrument,
			Default->Model[Instrument,ProteinCapillaryElectrophoresis,"Maurice"],
			Description->"The capillary electrophoresis instrument that will be used by the protocol. The instrument accepts the cartridge loaded with running buffer and sequentially loads samples and resolves proteins by their size by electrophoresis through a separation matrix.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,ProteinCapillaryElectrophoresis],Object[Instrument,ProteinCapillaryElectrophoresis]}]
			],
			Category->"General"
		},
		{
			OptionName->Cartridge,
			Default->Model[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus"],
			Description->"The capillary electrophoresis cartridge loaded on the instrument for Capillary gel Electrophoresis-SDS (CESDS) experiments. The cartridge holds a single capillary and the anode's running buffer. CESDS cartridges can run 100 injections in up to 25 batches under optimal conditions, and up to 200 or 500 injections in total for CESDS and CESDS-Plus cartridges, respectively.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Container,ProteinCapillaryElectrophoresisCartridge],Object[Container,ProteinCapillaryElectrophoresisCartridge]}]
			],
			Category->"General"
		},
		{
			OptionName->PurgeCartridge,
			Default->IfRequired,
			Description->"Indicates if a Cartridge purge be performed before running the experiment unless there is a single batch left on the cartridge (uses an extra consumable and would count as an extra batch towards the 25 batch limit). When a cartridge has not been used for over 3 months a purge is highly recommended.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[True,False,IfRequired]
			],
			Category->"General"
		},
		{
			OptionName->ReplaceCartridgeInsert,
			Default->True,
			Description->"Indicates if the cartridge insert should be replaced when needed. The cartridge insert can no longer be used and has to be replaced if it has been soaked with running buffer. While this does not prevent the experiment from running, the cartridge can't be used again until the insert is replaced.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"General"
		},
		{
			OptionName->SampleTemperature,
			Default->10*Celsius,
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
			Description->"The order of sample, Ladder, Standard, and Blank sample loading into the Instrument during measurement.",
			ResolutionDescription->"Determined to the order of input samples articulated. Ladder, Standard and Blank samples are inserted based on the determination of LadderFrequency, StandardFrequency and BlankFrequency. For example, StandardFrequency -> FirstAndLast and BlankFrequency -> Null result in Standard samples injected first, then samples, and then the Standard sample set again at the end.  A ladder sample will be loaded for every unique set of conditions (MasterMix and separation conditions) specified for SamplesIn, Standards, and Blanks, in replicates as determined by LadderFrequency.",
			AllowNull->False,
			Widget->Adder[{
				"Type"->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Sample,Ladder,Standard,Blank]],
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
			Description->"The order of sample, Ladder, Standard, and Blank sample loading into the Instrument during measurement withthe index of the respective sample.",
			ResolutionDescription->"Determined to the order of input samples articulated. Standard and Blank samples are inserted based on the determination of StandardFrequency and BlankFrequency. For example, StandardFrequency -> FirstAndLast and BlankFrequency -> Null result in Standard samples injected first, then samples, and then the Standard sample set again at the end.",
			AllowNull->False,
			Widget->Adder[{
				"Type"->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Sample,Ladder,Standard,Blank]],
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
			OptionName->ConditioningAcid,
			Default->Model[Sample,"CESDS Conditioning Acid"],
			Description->"The Conditioning Acid solution used to wash the capillary (every 12 injections).",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->ConditioningBase,
			Default->Model[Sample,"CESDS Conditioning Base"],
			Description->"The Conditioning Base solution used to wash the capillary (every 12 injections).",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->ConditioningWashSolution,
			Default->Model[Sample,"Milli-Q water"],
			Description->"The solution used to wash the capillary (every 12 injections).",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->SeparationMatrix,
			Default->Model[Sample,"CESDS Separation Matrix"],
			Description->"The sieving matrix loaded onto the capillary between samples for separation. The mash-like matrix slows the migration of proteins based on their size.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->SystemWashSolution,
			Default->Model[Sample,"CESDS Wash Solution"],
			Description->"The solution used to wash the capillary after conditioning and, separately, rinse the tip before every injection.",
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
		(* Incubation (for denaturation) and Centrifugation options *)
		{
			OptionName->Denature,
			Default->True,
			Description->"Indicates if heat denaturation should be applied to all samples.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"Denaturation"
		},
		{
			OptionName->DenaturingTemperature,
			Default->Automatic,
			Description->"The temperature to which samples will be heated to in order to linearize proteins.",
			ResolutionDescription->"When Denature is True and DenaturingTemperature is set to Automatic, it will be set to 70 celsius. Alternatively, if Denature is False, it will be set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[$AmbientTemperature,100*Celsius],
				Units->{Celsius,{Celsius,Kelvin}}
			],
			Category->"Denaturation"
		},
		{
			OptionName->DenaturingTime,
			Default->Automatic,
			Description->"The duration samples should be incubated at the DenaturingTemperature.",
			ResolutionDescription->"When Denature is True and DenaturingTime is set to Automatic, it will be set to 10 minutes. Alternatively, if Denature is False, it will be set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Second,$MaxExperimentTime],
				Units->{Minute,{Hour,Minute,Second}}
			],
			Category->"Denaturation"
		},
		{
			OptionName->CoolingTemperature,
			Default->Automatic,
			Description->"The temperature to which samples will be cooled to after denaturation.",
			ResolutionDescription->"When Denature is True and CoolingTemperature is set to Automatic, it will be set to 4 celsius. Alternatively, if Denature is False, it will be set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Celsius,$AmbientTemperature],
				Units->{Celsius,{Celsius,Kelvin}}
			],
			Category->"Denaturation"
		},
		{
			OptionName->CoolingTime,
			Default->Automatic,
			Description->"The duration samples should be incubated at the CoolingTemperature.",
			ResolutionDescription->"When Denature is True and CoolingTime is set to Automatic, it will be set to 5 minutes. Alternatively, if Denature is False, it will be set to Null.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Second,$MaxExperimentTime],
				Units->{Minute,{Hour,Minute,Second}}
			],
			Category->"Denaturation"
		},
		{
			OptionName->PelletSedimentation,
			Default->True,
			Description->"Indicates if centrifugation should be applied to the sample to remove precipitates after denaturation.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"Denaturation"
		},
		{
			OptionName->SedimentationCentrifugationSpeed,
			Default->Automatic,
			Description->"The speed to which the centrifuge is set to for sedimentation.",
			ResolutionDescription->"When PelletSedimentation is True and SedimentationCentrifugationSpeed is set to Automatic, it will be calculated from force based on the rotor's radius.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*RPM,4150*RPM],
				Units->RPM
			],
			Category->"Denaturation"
		},
		{
			OptionName->SedimentationCentrifugationForce,
			Default->Automatic,
			Description->"The force to which the centrifuge is set to for sedimentation.",
			ResolutionDescription->"When PelletSedimentation is True and SedimentationCentrifugationForce is set to Automatic, it will be calculated from Speed based on the rotor's radius, if speed is set to Automatic/Null, will default to 1000xg.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*GravitationalAcceleration,3755*GravitationalAcceleration],
				Units->GravitationalAcceleration
			],
			Category->"Denaturation"
		},
		{
			OptionName->SedimentationCentrifugationTime,
			Default->10Minute,
			Description->"The duration samples should be centrifuged to pellet precipitates.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Second,$MaxExperimentTime],
				Units->{Minute,{Hour,Minute,Second}}
			],
			Category->"Denaturation"
		},
		{
			OptionName->SedimentationCentrifugationTemperature,
			Default->4Celsius,
			Description->"The temperature to which samples will be cooled to during centrifugation.",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Celsius,40*Celsius],
				Units->{Celsius,{Celsius,Fahrenheit,Kelvin}}
			],
			Category->"Denaturation"
		},
		(* Storage Conditions - Instrument Preparation *)
		{
			OptionName->ConditioningAcidStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for ConditioningAcid of this experiment after the protocol is completed. If left unset, samples will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->ConditioningBaseStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for ConditioningBase of this experiment after the protocol is completed. If left unset, samples will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->SeparationMatrixStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for SeparationMatrix of this experiment after the protocol is completed. If left unset, samples will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->SystemWashSolutionStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for SystemWashSolution of this experiment after the protocol is completed. If left unset, samples will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Instrument Preparation"
		},
		{
			OptionName->RunningBufferStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for Bottom RunningBuffer of this experiment after the protocol is completed. If left unset, Bottom RunningBuffer will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Instrument Preparation"
		},
		(* Sample preparation *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			(* Label options for manual primitives *)
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples that are being analyzed by capillary gel electrophoresis SDS, for use in downstream unit operations.",
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
				Description->"A user defined word or phrase used to identify the containers of the samples that are being analyzed by capillary gel electrophoresis SDS, for use in downstream unit operations.",
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
				Description->"Indicates the volume drawn from the sample to the assay tube. Each tube contains a Sample, an InternalReference, an SDSBuffer, and a ReducingAgent and/or an AlkylatingAgent.",
				ResolutionDescription->"When SampleVolume is set to Automatic, the volume is calculated for the composition of the sample to reach 1 mg / ml by 1 Milligram/Milliliter * TotalVolume / Sample [Concentration]. If an injection table is available, volumes will be taken from it.",
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
				Default->100*Microliter,
				Description->"Indicates the final volume in the assay tube prior to loading onto AssayContainer. Each tube contains a Sample, an InternalReference, an SDSBuffer, and a ReducingAgent and/or an AlkylatingAgent.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[50*Microliter,200Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->PremadeMasterMix,
				Default->Automatic,
				Description->"Indicates if samples should be mixed with PremadeMasterMix that includes an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
				ResolutionDescription->"When PremadeMasterMix is set to Automatic, it will resolve to True if any of its downstream options is specified.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP],
				Category->"Sample Preparation"
			},
			{
				OptionName->PremadeMasterMixReagent,
				Default->Null,
				Description->"The premade master mix used for CESDS experiment, containing an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
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
				ResolutionDescription->"When PremadeMasterMix is set to True and PremadeMasterMixDiluent is set to Automatic, Model[Sample,\"Milli-Q water\"] will be set as diluent.",
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
				Description->"The factor by which the premade mastermix should be diluted by in the final assay tube.",
				ResolutionDescription->"When PremadeMasterMix is set to True and PremadeMasterMixReagentDilutionFactor is set to Automatic, it will be set as the ratio of the total volume to premade mastermix volume.",
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
				Description->"The volume of the PremadeMasterMix required to reach its final concentration.",
				ResolutionDescription->"When volume is set to Automatic, the volume is calculated by the division of TotalVolume by PremadeMasterMixReagentDilutionFactor. If PremadeMasterMix is set to False, PremadeMasterMixVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->PremadeMasterMixStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for PremadeMasterMix of this experiment after the protocol is completed. If left unset, Diluent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->InternalReference,
				Default->Automatic,
				Description->"The solution containing the reference analyte by which Relative Migration Time is normalized. By default a 10 KDa marker is used. It is highly recommended to include an internal standard in Sample Preparation.",
				ResolutionDescription->"When PremadeMasterMix is set to False and InternalReference is set to Automatic, InternalReference will be set as Model[Sample, StockSolution, \"Resuspended CESDS Internal Standard 25X\"]. If PremadeMasterMix is set to True, InternalReference is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->InternalReferenceDilutionFactor,
				Default->Automatic,
				Description->"Marks how concentrated the internal standard is. For example, Model[Sample, StockSolution\"Resuspended CESDS Internal Standard 25X\"] is concentrated 25X, hence 2 \[Micro]L should be added in Sample Preparation when final volume is set to 60 microliters.",
				ResolutionDescription->"When PremadeMasterMix is set to False and InternalReferenceDilutionFactor is set to Automatic, InternalReferenceDilutionFactor will be set to 25. If PremadeMasterMix is set to True, InternalReferenceDilutionFactor is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[1]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->InternalReferenceVolume,
				Default->Automatic,
				Description->"The volume of the internal standard added to each sample.",
				ResolutionDescription->"When InternalReferenceVolume is set to Automatic and PremadeMasterMix is set to False, the volume is calculated by the division of TotalVolume by InternalReferenceDilutionFactor. When PremadeMasterMix is set to True, InternalReferenceVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ConcentratedSDSBuffer,
				Default->Automatic,
				Description->"The SDS Buffer used to dilute the sample. The final concentration of SDS in this assay must be equal to or greater than 0.5%.",
				ResolutionDescription->"When PremadeMasterMix is set to False and ConcentratedSDSBuffer is set to Automatic, ConcentratedSDSBuffer will be set as Model[Sample,\"1% SDS in 100mM Tris, pH 9.5\"]. If PremadeMasterMix is set to True, ConcentratedSDSBuffer is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ConcentratedSDSBufferDilutionFactor,
				Default->Automatic,
				Description->"Marks how concentrated the SDS buffer is. For example, a ConcentratedSDSBuffer that contains 1% SDS is concentrated 2X and will constitute half the TotalVolume.",
				ResolutionDescription->"When PremadeMasterMix is set to False and ConcentratedSDSBufferDilutionFactor is set to Automatic, ConcentratedSDSBufferDilutionFactor will be set to 2. If PremadeMasterMix is set to True, ConcentratedSDSBufferDilutionFactor is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[1]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->Diluent,
				Default->Automatic,
				Description->"The solution used to dilute the ConcentratedSDSBuffer to working concentration.",
				ResolutionDescription->"When PremadeMasterMix is set to False and Diluent is set to Automatic, Diluent will be set to Model[Sample,\"Milli-Q water\"]. If PremadeMasterMix is set to True, Diluent is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ConcentratedSDSBufferVolume,
				Default->Automatic,
				Description->"The volume of ConcentratedSDSBuffer added to each sample.",
				ResolutionDescription->"When volume is set to Automatic and PremadeMasterMix is set to False, the volume is calculated by the division of TotalVolume by ConcentratedSDSBufferDilutionFactor. When PremadeMasterMix is set to True, ConcentratedSDSBufferVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->SDSBuffer,
				Default->Automatic,
				Description->"The SDS Buffer used to dilute the sample. The final concentration of SDS in this assay must be equal or greater than 0.5%. If ConcentratedSDSBuffer is set to Null, SDSBuffer will be used to dilute the sample.",
				ResolutionDescription->"When PremadeMasterMix is set to False ,ConcentratedSDSBuffer is set to Null, and SDSBuffer is set to Automatic, SDSBuffer will be set as Model[Sample,\"1% SDS in 100mM Tris, pH 9.5\"]. If PremadeMasterMix or ConcentratedSDSBuffer are set, SDSBuffer is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->SDSBufferVolume,
				Default->Automatic,
				Description->"The volume of SDSBuffer added to each sample.",
				ResolutionDescription->"When SDSBufferVolume is set to Automatic and SDSBuffer is not Null, the volume is calculated by the difference between the TotalVolume and the volume in the tube that includes the Sample, InternalReference, ReducingAgent, and AlkylatingAgent.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->Reduction,
				Default->Automatic,
				Description->"Indicates if disulfide bridges should be chemically reduced in the sample.",
				ResolutionDescription->"When automatic, Reduction will set to True if any of the Reduction options are not Null.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP],
				Category->"Sample Preparation"
			},
			{
				OptionName->ReducingAgent,
				Default->Automatic,
				Description->"The reducing agent used to reduce disulfide bridges in proteins to be added to the sample. for example, \[Beta]-mercaptoethanol or Dithiothreitol.",
				ResolutionDescription->"When PremadeMasterMix is set to False and ReducingAgent is set to Automatic, ReducingAgent will be set to Model[Sample,\"2-mercaptoethanol\"]. If PremadeMasterMix is set to True, ReducingAgent is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ReducingAgentTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of the reducing agent in the sample.",
				ResolutionDescription->"When target concentration is set to Automatic, PremadeMasterMix is set to False, and no ReducingAgentVolume value is given, concentration is set to 650 millimolar if ReducingAgent is BME. If volume is given concentration will be calculated. If PremadeMasterMix is set to True, ReducingAgentTargetConcentration is Null ",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0*Molar],
						Units->{1,{Molar,{Millimolar,Molar}}}
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*VolumePercent,100*VolumePercent],
						Units->VolumePercent]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->ReducingAgentVolume,
				Default->Automatic,
				Description->"The volume of the reducing agent required to reach its final concentration in the sample.",
				ResolutionDescription->"When ReducingAgentVolume is set to Automatic and PremadeMasterMix is set to False, calculate the volume required to reach ReducingAgentTargetConcentration, if set. When ReducingAgentVolume is set to Automatic and ReducingAgentTargetConcentration is set to Null, ReducingAgentVolume is set to Null. When PremadeMasterMix is set to True, ReducingAgentVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->Alkylation,
				Default->Automatic,
				Description->"Indicates if Alkylation should be applied to the sample. Alkylation of free cysteines is useful in mitigating unexpected protein fragmentation and reproducibility issues.",
				ResolutionDescription->"When automatic, Alkylation will set to True if any of the Reduction options are not Null.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->AlkylatingAgent,
				Default->Automatic,
				Description->"The alkylating agent to be added to the sample. For example, Iodoacetamide.",
				ResolutionDescription->"When PremadeMasterMix is set to False and AlkylatingAgent is set to Automatic, AlkylatingAgent will be set to Model[Sample,\"250 mM Iodoacetamide\"]. If PremadeMasterMix is set to True, AlkylatingAgent is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->AlkylatingAgentTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of the alkylating agent in the sample.",
				ResolutionDescription->"When target concentration is set to Automatic, PremadeMasterMix is set to False, and no AlkylatingAgentVolume value is given, concentration is set to 11.5 millimolar. If volume is given concentration will be calculated. If PremadeMasterMix is set to True, AlkylatingAgentTargetConcentration is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Molar]|GreaterP[0*Gram/Liter],
					Units->Alternatives[
						{1,{Micromolar,{Micromolar,Millimolar,Molar}}},
						CompoundUnit[
							{1,{Gram,{Gram,Microgram,Milligram}}},
							{-1,{Liter,{Liter,Microliter,Milliliter}}}
						]
					]
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->AlkylatingAgentVolume,
				Default->Automatic,
				Description->"The volume of the alkylating agent required to reach its final concentration in the sample.",
				ResolutionDescription->"When AlkylatingAgentVolume is set to Automatic and PremadeMasterMix is set to False, calculate the volume required to reach AlkylatingAgentTargetConcentration, if set. When AlkylatingAgentVolume is set to Automatic and AlkylatingAgentTargetConcentration is set to Null, AlkylatingAgentVolume is set to Null. If PremadeMasterMix is set to True, AlkylatingAgentVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Milliliter,Microliter}}
				],
				Category->"Sample Preparation"
			},
			{
				OptionName->SedimentationSupernatantVolume,
				Default->Automatic,
				Description->"The volume of supernatant to transfer to the assay container from the sample tubes after denaturation and centrifugation. A minimum of 50 microliters are required for the analysis to proceed.",
				ResolutionDescription->"When SedimentationSupernatantVolume is set to Automatic, 90% of the TotalVolume is drawn to avoid disturbing the pellet.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[50*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Sample Preparation"
			},
			(* Storage Conditions - Sample preparation *)
			{
				OptionName->InternalReferenceStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for InternalReference of this experiment after samples are transferred to assay tubes. If left unset, InternalReference will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Storage Conditions"
			},
			{
				OptionName->ConcentratedSDSBufferStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for ConcentratedSDSBuffer of this experiment after samples are transferred to assay tubes. If left unset, ConcentratedSDSBuffer will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Storage Conditions"
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
				Category->"Storage Conditions"
			},
			{
				OptionName->SDSBufferStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for SDSBuffer of this experiment after samples are transferred to assay tubes. If left unset, SDSBuffer will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Storage Conditions"
			},
			{
				OptionName->ReducingAgentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for ReducingAgent of this experiment after samples are transferred to assay tubes. If left unset, ReducingAgent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Storage Conditions"
			},
			{
				OptionName->AlkylatingAgentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for AlkylatingAgent of this experiment after samples are transferred to assay tubes. If left unset, AlkylatingAgent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Storage Conditions"
			}
		],
		(* Separation Conditions *)
		{
			OptionName->RunningBuffer,
			Default->Model[Sample,"CESDS Running Buffer - Bottom"],
			Description->"The buffer in which the capillary docks for separation. This buffer must be compatible with the running buffer loaded on the CESDS cartridge (see: CEOnBoardRunningBuffer).",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			],
			Category->"Separation conditions"
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->InjectionVoltageDurationProfile,
				Default->{{4600*Volt,20*Second}},
				Description->"Series of voltages and durations to apply onto the capillary for injection. Supports up to 20 steps.",
				AllowNull->False,
				Widget->Adder[{
					"Voltage"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Volt,6500*Volt],
						Units->Volt],
					"Time"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Second,200*Second],
						Units->{Second,{Second,Minute,Hour}}
					]
				},
					Orientation->Vertical
				],
				Category->"Separation conditions"
			},
			{
				OptionName->SeparationVoltageDurationProfile,
				Default->Automatic,
				Description->"Series of voltages and durations to apply onto the capillary for separation. Supports up to 20 steps.",
				ResolutionDescription->"When SeparationVoltageDurationProfile is set to Automatic, separation time will be set according to whether or not samples are reduced or not, and which Standard is used. If standard is IgG and samples are not reduced, set time to 25 minutes, otherwise set to 35 minutes. For all conditions, voltage is set to 5750 Volts.",
				AllowNull->False,
				Widget->Adder[{
					"Voltage"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Volt,6500*Volt],
						Units->Volt],
					"Time"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,180*Minute],
						Units->{Minute,{Second,Minute,Hour}}
					]
				},
					Orientation->Vertical
				],
				Category->"Separation conditions"
			}
		],
		(* Detection *)
		{
			OptionName->UVDetectionWavelength,
			Default->220*Nanometer,
			Description->"The wavelength used for signal detection. The hardware is currently only capable of detection at 220 nm.",
			AllowNull->False,
			Widget->Widget[
				Type->Expression,
				Pattern:>220*Nanometer,
				Size->Line
			],
			Category->"Detection"
		},
		(* Ladders *)
		{
			OptionName->IncludeLadders,
			Default->Automatic,
			Description->"Indicates if mixtures of known analytes should be included in this experiment. A ladder contains a mixture of analytes of known size and Relative Migration Times and can be used to interpolate the molecular weight of unknown analytes. The ladder will be injected for every unique Separation set of conditions.",
			ResolutionDescription->"If any ladder-related options are set, then this is set True; otherwise, false.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Category->"Ladders"
		},
		IndexMatching[
			IndexMatchingParent->Ladders,
			{
				OptionName->Ladders,
				Default->Automatic,
				Description->"Indicates the premade mixture of analytes of known molecular weight (MW) to include as reference for MW interpolation in this experiment.",
				ResolutionDescription->"If IncludeLadder is True, Ladders is resolved to Model[Sample, \"Unstained Protein Standard\"].",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Ladders"
			},
			{
				OptionName->LadderStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for Ladders of this experiment after the protocol is completed. If left unset, LadderStorageCondition will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Ladders"
			},
			{
				OptionName->LadderAnalytes,
				Default->Automatic,
				Description->"Indicates the analytes included in ladder.",
				ResolutionDescription->"If composition of Ladder is known, will populate LadderAnalytes accordingly. Otherwise, Null.",
				AllowNull->True,
				Widget->Adder[
					Widget[
						Type->Object,
						Pattern:>ObjectP[Model[Molecule]]]
				],
				Category->"Ladders"
			},
			{
				OptionName->LadderAnalyteMolecularWeights,
				Default->Automatic,
				Description->"Indicates the molecular weights of analytes included in ladder.",
				ResolutionDescription->"If composition of Ladder is known, will populate LadderAnalytesMolecularWeights accordingly. Otherwise, Null.",
				AllowNull->True,
				Widget->Adder[
					Widget[
						Type->Quantity,
						Units->Kilodalton,
						Pattern:>GreaterP[0*Kilodalton]]
				],
				Category->"Ladders"
			},
			{
				OptionName->LadderAnalyteLabels,
				Default->Automatic,
				Description->"Indicates the label of each analyte included in ladder.",
				ResolutionDescription->"Will populate LadderAnalyteLabels according to LadderAnalytes, if set. Otherwise, Will populate LadderAnalyteLabels according to LadderAnalyteMolecularWeights.",
				AllowNull->True,
				Widget->Adder[
					Widget[
						Type->String,
						Pattern:>_String,
						Size->Word
					]
				],
				Category->"Ladders"
			},
			{
				OptionName->LadderFrequency,
				Default->Automatic,
				Description->"Indicates how many injections per permutation of ladder and unique set of separation conditions should be included in this experiment.",
				ResolutionDescription->"If LadderFrequency is set to Automatic and Ladders is True, LadderFrequency will be set to FirstAndLast.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>GreaterP[0,1]|FirstAndLast|First|Last
				],
				Category->"Ladders"
			},
			{
				OptionName->LadderTotalVolume,
				Default->Automatic,
				Description->"Indicates the final volume in the assay tube prior to loading onto AssayContainer. Each tube contains a ladder, an InternalReference, and an SDSBuffer.",
				ResolutionDescription->"If Automatic and Ladders is True, will populate LadderTotalVolume according to TotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[50*Microliter,200Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderDilutionFactor,
				Default->Automatic,
				Description->"The factor by which the ladder should be diluted by in the final assay tube.",
				ResolutionDescription->"When LadderDilutionFactor is set to Automatic, it is set to 2.5 by default.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterEqualP[1]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderVolume,
				Default->Automatic,
				Description->"The volume of ladder required to reach its final concentration.",
				ResolutionDescription->"When volume is set to Automatic, the volume is calculated by the division of LadderTotalVolume by LadderDilutionFactor. If LadderDilutionFactor is Null, 40 Microliters will be used. If InjectionTable is informed, specified volumes will be used.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderPremadeMasterMix,
				Default->Automatic,
				Description->"Indicates if Ladders should be mixed with LadderPremadeMasterMix that includes an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
				ResolutionDescription->"When LadderPremadeMasterMix is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderPremadeMasterMixReagent,
				Default->Automatic,
				Description->"The premade master mix used for CESDS experiment, containing an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
				ResolutionDescription->"When LadderPremadeMasterMixReagent is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderPremadeMasterMixDiluent,
				Default->Automatic,
				Description->"The solution used to dilute the premade master mix used to its working concentration.",
				ResolutionDescription->"When LadderPremadeMasterMix is set to True and LadderPremadeMasterMixDiluent is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderPremadeMasterMixReagentDilutionFactor,
				Default->Automatic,
				Description->"The factor by which the premade mastermix should be diluted by in the final assay tube.",
				ResolutionDescription->"When LadderPremadeMasterMix is set to True and LadderPremadeMasterMixReagentDilutionFactor is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterEqualP[1]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderPremadeMasterMixVolume,
				Default->Automatic,
				Description->"The volume of the PremadeMasterMix required to reach its final concentration.",
				ResolutionDescription->"When volume is set to Automatic, and LadderPremadeMasterMix is set to True, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderPremadeMasterMixStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for LadderPremadeMasterMix of this experiment after the protocol is completed. If left unset, LadderPremadeMasterMix will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderInternalReference,
				Default->Automatic,
				Description->"The solution containing the reference analyte by which Relative Migration Time is normalized. By default a 10 KDa marker is used. It is highly recommended to include an internal standard in Sample Preparation.",
				ResolutionDescription->"When LadderPremadeMasterMix is set to False and InternalReference is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderInternalReferenceDilutionFactor,
				Default->Automatic,
				Description->"Marks how concentrated the internal standard is. For example, Model[Sample,\"CESDS Internal Reference 25X\"] is concentrated 25X, hence 2 \[Micro]L should be added in Sample Preparation when final volume is set to 50 \[Micro]L.",
				ResolutionDescription->"When LadderPremadeMasterMix is set to False and LadderInternalReferenceDilutionFactor is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[1]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderInternalReferenceVolume,
				Default->Automatic,
				Description->"The volume of the internal standard added to each sample.",
				ResolutionDescription->"When volume is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderConcentratedSDSBuffer,
				Default->Automatic,
				Description->"The SDS Buffer used to dilute standards. The final concentration of SDS in this assay must be equal to or greater than 0.5%.",
				ResolutionDescription->"When LadderPremadeMasterMix is set to False and LadderConcentratedSDSBuffer is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderConcentratedSDSBufferDilutionFactor,
				Default->Automatic,
				Description->"Marks how concentrated the LadderConcentratedSDSBuffer is. For example, a LadderConcentratedSDSBuffer that contains 1% SDS is concentrated 2X and will constitute half the LadderTotalVolume.",
				ResolutionDescription->"When LadderPremadeMasterMix is set to False and LadderConcentratedSDSBufferDilutionFactor is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[1]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderDiluent,
				Default->Automatic,
				Description->"The solution used to dilute LadderConcentratedSDSBuffer to working concentration.",
				ResolutionDescription->"When LadderPremadeMasterMix is set to False and Diluent is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderConcentratedSDSBufferVolume,
				Default->Automatic,
				Description->"The volume of LadderConcentratedSDSBufferVolume added to each sample.",
				ResolutionDescription->"When volume is set to Automatic and LadderPremadeMasterMix is set to False, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderSDSBuffer,
				Default->Automatic,
				Description->"The SDS Buffer used to dilute the sample. The final concentration of SDS in this assay must be equal or greater than 0.5%.",
				ResolutionDescription->"When SDS Buffer is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderSDSBufferVolume,
				Default->Automatic,
				Description->"The volume of SDSBuffer added to each sample.",
				ResolutionDescription->"When LadderSDSBufferVolume is set to Automatic and LadderSDSBuffer is not Null, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderReduction,
				Default->Automatic,
				Description->"Indicates if disulfide bridges should be chemically reduced in the Ladder.",
				ResolutionDescription->"When automatic, LadderReduction will set to True if any of the Reduction options are not Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderReducingAgent,
				Default->Automatic,
				Description->"The reducing agent to be added to the Ladder. for example, \[Beta]-mercaptoethanol or Dithiothreitol.",
				ResolutionDescription->"When LadderPremadeMasterMix is set to False and LadderReducingAgent is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderReducingAgentTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of the reducing agent in the Ladder.",
				ResolutionDescription->"When target concentration is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0*Molar],
						Units->{1,{Molar,{Millimolar,Molar}}}
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*VolumePercent,100*VolumePercent],
						Units->VolumePercent]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderReducingAgentVolume,
				Default->Automatic,
				Description->"The volume of the reducing agent required to reach its final concentration in the Ladder.",
				ResolutionDescription->"When LadderReducingAgentVolume is set to Automatic and LadderPremadeMasterMix is set to False, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderAlkylation,
				Default->Automatic,
				Description->"Indicates if Alkylation should be applied to the Ladder. Alkylation of free cysteines is useful in mitigating unexpected protein fragmentation and reproducibility issues.",
				ResolutionDescription->"When automatic, LadderAlkylation will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderAlkylatingAgent,
				Default->Automatic,
				Description->"The alkylating agent to be added to the Ladder. For example, Iodoacetamide.",
				ResolutionDescription->"When LadderPremadeMasterMix is set to False and LadderAlkylatingAgent is set to Automatic it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderAlkylatingAgentTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of the alkylating agent in the Ladder.",
				ResolutionDescription->"When target concentration is set to Automatic it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Molar]|GreaterP[0*Gram/Liter],
					Units->Alternatives[
						{1,{Micromolar,{Micromolar,Millimolar,Molar}}},
						CompoundUnit[
							{1,{Gram,{Gram,Microgram,Milligram}}},
							{-1,{Liter,{Liter,Microliter,Milliliter}}}
						]
					]
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderAlkylatingAgentVolume,
				Default->Automatic,
				Description->"The volume of the alkylating agent required to reach its final concentration in the Ladder.",
				ResolutionDescription->"When LadderAlkylatingAgentVolume is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderSedimentationSupernatantVolume,
				Default->Automatic,
				Description->"The volume of supernatant to transfer to the assay container from the Ladder tubes after denaturation and centrifugation. A minimum of 50 \[Micro]L are required for the analysis to proceed.",
				ResolutionDescription->"When SedimentationSupernatantVolume is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[50*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Ladder Preparation"
			},
			(* Separation Conditions *)
			{
				OptionName->LadderInjectionVoltageDurationProfile,
				Default->Automatic,
				Description->"Voltage profile for Injection. Supports up to 20 steps where each step is 0-200 Second, and 0-6500 volts.",
				ResolutionDescription->"When LadderInjectionVoltageDurationProfile is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Adder[{
					"Voltage"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Volt,6500*Volt],
						Units->Volt],
					"Time"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Second,200*Second],
						Units->{Second,{Second,Minute,Hour}}
					]
				},
					Orientation->Vertical
				],
				Category->"Ladder Separation"
			},
			{
				OptionName->LadderSeparationVoltageDurationProfile,
				Default->Automatic,
				Description->"Voltage profile for Injection. Supports up to 20 steps.",
				ResolutionDescription->"When LadderSeparationVoltageDurationProfile is set to Automatic, it will resolve according to each unique set of options applied to SamplesIn.",
				AllowNull->True,
				Widget->Adder[{
					"Voltage"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Volt,6500*Volt],
						Units->Volt],
					"Time"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,180*Minute],
						Units->{Minute,{Second,Minute,Hour}}
					]
				},
					Orientation->Vertical
				],
				Category->"Ladder Separation"
			},
			(* Storage Conditions - Ladders *)
			{
				OptionName->LadderInternalReferenceStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for LadderInternalReference of this experiment after the protocol is completed. If left unset, LadderInternalReferences will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderConcentratedSDSBufferStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for LadderConcentratedSDSBuffer of this experiment after the protocol is completed. If left unset, LadderConcentratedSDSBuffer will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderDiluentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for LadderDiluent of this experiment after the protocol is completed. If left unset, LadderDiluent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderSDSBufferStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for LadderSDSBuffer of this experiment after the protocol is completed. If left unset, LadderSDSBuffer will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderReducingAgentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for LadderReducingAgent of this experiment after the protocol is completed. If left unset, LadderReducingAgent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Ladder Preparation"
			},
			{
				OptionName->LadderAlkylatingAgentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for LadderAlkylatingAgent of this experiment after the protocol is completed. If left unset, LadderAlkylatingAgent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Ladder Preparation"
			}
		],
		(* Standards and Blanks *)
		{
			OptionName->IncludeStandards,
			Default->Automatic,
			Description->"Indicates if standards should be included in this experiment. Standards contain identified analytes of known size and Relative Migration Times. Standards are used to both ensure reproducibility within and between Experiments and to interpolate the molecular weight of unknown analytes.",
			ResolutionDescription->"If any Standard-related options are set, then this is set True; otherwise, false.",
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
				Description->"Indicates which standards to include.",
				ResolutionDescription->"If IncludeStandards is True, Standards is resolved to Model[Sample, StockSolution, \"Resuspended CESDS IgG Standard\"].",
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
				Category->"Standards"
			},
			{
				OptionName->StandardVolume,
				Default->Automatic,
				Description->"Indicates the volume drawn from the standard to the assay tube. Each tube contains a Standard, an InternalReference, an SDSBuffer, and a ReducingAgent and/or an AlkylatingAgent.",
				ResolutionDescription->"When StandardVolume is set to Automatic and IncludeStandards is True, the volume is calculated to reach 1 milligram/milliliter in the assay tube, based on its composition, by StandardTotalVolume / Standard [Concentration]. If InjectionTable is informed, specified volumes will be used.",
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
				ResolutionDescription->"When StandardFrequency is set to Automatic and IncludeStandards is True, Set Frequency to FirstAnLast.",
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
				Description->"Indicates the final volume in the assay tube prior to loading onto AssayContainer. Each tube contains a standard, an InternalReference, an SDSBuffer, and a ReducingAgent and/or an AlkylatingAgent.",
				ResolutionDescription->"When StandardTotalVolume is set to Automatic and IncludeStandards is True, Set StandardTotalVolume to TotalVolume.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[50*Microliter,200Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardPremadeMasterMix,
				Default->Automatic,
				Description->"Indicates if Standards should be mixed with StandardPremadeMasterMix that includes an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
				ResolutionDescription->"When StandardPremadeMasterMix is set to Automatic, it will resolve to True if any of its downstream options is specified.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardPremadeMasterMixReagent,
				Default->Automatic,
				Description->"The premade master mix used for CESDS experiment, containing an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
				ResolutionDescription->"When StandardPremadeMasterMixReagent is set to Automatic, it will resolve to the common premade mastermix reagent in samples in .",
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
				ResolutionDescription->"When StandardPremadeMasterMix is set to True and StandardPremadeMasterMixDiluent is set to Automatic, Model[Sample,\"Milli-Q water\"] will be set as diluent.",
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
				Description->"The factor by which the premade mastermix should be diluted by in the final assay tube.",
				ResolutionDescription->"When StandardPremadeMasterMix is set to True and StandardPremadeMasterMixReagentDilutionFactor is set to Automatic, it will be set as the ratio of the total volume to premade mastermix volume.",
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
				Description->"The volume of the PremadeMasterMix required to reach its final concentration.",
				ResolutionDescription->"When volume is set to Automatic, the volume is calculated by the division of TotalVolume by StandardPremadeMasterMixReagentDilutionFactor. If StandardPremadeMasterMix is set to False, StandardPremadeMasterMixVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardPremadeMasterMixStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for StandardPremadeMasterMix of this experiment after the protocol is completed. If left unset, StandardPremadeMasterMix will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardInternalReference,
				Default->Automatic,
				Description->"The solution containing the reference analyte by which Relative Migration Time is normalized. By default a 10 KDa marker is used. It is highly recommended to include an internal standard in Sample Preparation.",
				ResolutionDescription->"When StandardPremadeMasterMix is set to False and InternalReference is set to Automatic, StandardInternalReference will be set as Model[Sample, StockSolution\"Resuspended CESDS Internal Standard 25X\"]. If StandardPremadeMasterMix is set to True, StandardInternalReference is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardInternalReferenceDilutionFactor,
				Default->Automatic,
				Description->"Marks how concentrated the internal standard is. For example, Model[Sample, StockSolution\"Resuspended CESDS Internal Standard 25X\"] is concentrated 25X, hence 2 \[Micro]L should be added in Sample Preparation when final volume is set to 60 \[Micro]L.",
				ResolutionDescription->"When StandardPremadeMasterMix is set to False and StandardInternalReferenceDilutionFactor is set to Automatic, StandardInternalReferenceDilutionFactor will be set to 25. If StandardPremadeMasterMix is set to True, StandardInternalReferenceDilutionFactor is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[1]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardInternalReferenceVolume,
				Default->Automatic,
				Description->"The volume of the internal standard added to each sample.",
				ResolutionDescription->"When volume is set to Automatic, the volume is calculated by the division of TotalVolume by StandardInternalReferenceVolume. When StandardPremadeMasterMix is set to True, StandardInternalReferenceVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardConcentratedSDSBuffer,
				Default->Automatic,
				Description->"The SDS Buffer used to dilute standards. The final concentration of SDS in this assay must be equal to or greater than 0.5%.",
				ResolutionDescription->"When StandardPremadeMasterMix is set to False and StandardConcentratedSDSBuffer is set to Automatic, StandardConcentratedSDSBuffer will be set as Model[Sample,\"1% SDS in 100mM Tris, pH 9.5\"]. If StandardPremadeMasterMix is set to True, StandardConcentratedSDSBuffer is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardConcentratedSDSBufferDilutionFactor,
				Default->Automatic,
				Description->"Marks how concentrated the StandardConcentratedSDSBuffer is. For example, a StandardConcentratedSDSBuffer that contains 1% SDS is concentrated 2X and will constitute half the StandardTotalVolume.",
				ResolutionDescription->"When StandardPremadeMasterMix is set to False and StandardConcentratedSDSBufferDilutionFactor is set to Automatic, StandardConcentratedSDSBufferDilutionFactor will be set to 2. If StandardPremadeMasterMix is set to True, StandardConcentratedSDSBufferDilutionFactor is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[1]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardDiluent,
				Default->Automatic,
				Description->"The solution used to dilute StandardConcentratedSDSBuffer to working concentration.",
				ResolutionDescription->"When StandardPremadeMasterMix is set to False and Diluent is set to Automatic, Diluent will be set to Model[Sample,\"Milli-Q water\"]. If StandardPremadeMasterMix is set to True, StandardDiluent is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardConcentratedSDSBufferVolume,
				Default->Automatic,
				Description->"The volume of StandardConcentratedSDSBufferVolume added to each sample.",
				ResolutionDescription->"When volume is set to Automatic and StandardPremadeMasterMix is set to False, the volume is calculated by the division of StandardTotalVolume by StandardConcentratedSDSBufferDilutionFactor. When StandardPremadeMasterMix is set to True, StandardConcentratedSDSBufferVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardSDSBuffer,
				Default->Automatic,
				Description->"The SDS Buffer used to dilute the sample. The final concentration of SDS in this assay must be equal or greater than 0.5%.",
				ResolutionDescription->"When StandardSDSBuffer is set to Automaticit is resolved to Null, so that Concentrated SDSBuffer, if set to Automatic, is used.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardSDSBufferVolume,
				Default->Automatic,
				Description->"The volume of SDSBuffer added to each sample.",
				ResolutionDescription->"When StandardSDSBufferVolume is set to Automatic and StandardSDSBuffer is not Null, the volume is calculated by the difference between the StandardTotalVolume and the volume in the tube that includes the Standard, InternalReference, ReducingAgent, and AlkylatingAgent.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardReduction,
				Default->Automatic,
				Description->"Indicates if disulfide bridges should be chemically reduced in the Standard.",
				ResolutionDescription->"When automatic, StandardReduction will set to True if any of the Reduction options are not Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardReducingAgent,
				Default->Automatic,
				Description->"The reducing agent to be added to the Standard. for example, \[Beta]-mercaptoethanol or Dithiothreitol.",
				ResolutionDescription->"When StandardPremadeMasterMix is set to False and StandardReducingAgent is set to Automatic, StandardReducingAgent will be set to Model[Sample,\"2-mercaptoethanol\"]. If StandardPremadeMasterMix is set to True, StandardReducingAgent is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardReducingAgentTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of the reducing agent in the Standard.",
				ResolutionDescription->"When target concentration is set to Automatic, and no StandardReducingAgentVolume value is given, concentration is set to 650 mM. If volume is given concentration will be calculated. If StandardPremadeMasterMix is set to True, StandardReducingAgentTargetConcentration is Null ",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0*Molar],
						Units->{1,{Molar,{Millimolar,Molar}}}
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*VolumePercent,100*VolumePercent],
						Units->VolumePercent]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardReducingAgentVolume,
				Default->Automatic,
				Description->"The volume of the reducing agent required to reach its final concentration in the Standard.",
				ResolutionDescription->"When StandardReducingAgentVolume is set to Automatic and StandardPremadeMasterMix is set to False, calculate the volume required to reach StandardReducingAgentTargetConcentration, if set. When StandardReducingAgentVolume is set to Automatic and StandardReducingAgentTargetConcentration is set to Null, StandardReducingAgentVolume is set to Null. When StandardPremadeMasterMix is set to True, StandardReducingAgentVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardAlkylation,
				Default->Automatic,
				Description->"Indicates if Alkylation should be applied to the Standard. Alkylation of free cysteines is useful in mitigating unexpected protein fragmentation and reproducibility issues.",
				ResolutionDescription->"When automatic, StandardAlkylation will set to True if any of the Reduction options are not Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardAlkylatingAgent,
				Default->Automatic,
				Description->"The alkylating agent to be added to the Standard. For example, Iodoacetamide.",
				ResolutionDescription->"When StandardPremadeMasterMix is set to False and StandardAlkylatingAgent is set to Automatic, StandardAlkylatingAgent will be set to Model[Sample,\"250 mM Iodoacetamide\"]. If StandardPremadeMasterMix is set to True, StandardAlkylatingAgent is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardAlkylatingAgentTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of the alkylating agent in the Standard.",
				ResolutionDescription->"When target concentration is set to Automatic, StandardPremadeMasterMix is set to False, and no StandardAlkylatingAgentVolume value is given, concentration is set to 11.5 millimolar. If volume is given concentration will be calculated. If StandardPremadeMasterMix is set to True, StandardAlkylatingAgentTargetConcentration is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Molar]|GreaterP[0*Gram/Liter],
					Units->Alternatives[
						{1,{Micromolar,{Micromolar,Millimolar,Molar}}},
						CompoundUnit[
							{1,{Gram,{Gram,Microgram,Milligram}}},
							{-1,{Liter,{Liter,Microliter,Milliliter}}}
						]
					]
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardAlkylatingAgentVolume,
				Default->Automatic,
				Description->"The volume of the alkylating agent required to reach its final concentration in the Standard.",
				ResolutionDescription->"When StandardAlkylatingAgentVolume is set to Automatic and StandardPremadeMasterMix is set to False, calculate the volume required to reach StandardAlkylatingAgentTargetConcentration, if set. When StandardAlkylatingAgentVolume is set to Automatic and StandardAlkylatingAgentTargetConcentration is set to Null, StandardAlkylatingAgentVolume is set to Null. If StandardPremadeMasterMix is set to True, StandardAlkylatingAgentVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardSedimentationSupernatantVolume,
				Default->Automatic,
				Description->"The volume of supernatant to transfer to the assay container from the Standard tubes after denaturation and centrifugation. A minimum of 50 \[Micro]L are required for the analysis to proceed.",
				ResolutionDescription->"When StandardPelletSedimentation is True and SedimentationSupernatantVolume is set to Automatic, 90% of the TotalVolume is drawn to avoid disturbing the pellet.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[50*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Standard Preparation"
			},
			(* Separation Conditions *)
			{
				OptionName->StandardInjectionVoltageDurationProfile,
				Default->Automatic,
				Description->"Voltage profile for Injection. Supports up to 20 steps where each step is 0-200 Second, and 0-6500 volts.",
				ResolutionDescription->"When StandardInjectionVoltageDurationProfile is set to Automatic and IncludeStandards is True, StandardInjectionVoltageDurationProfile is set to {{4600*Volt,20*Second}}, otherwise, Null.",
				AllowNull->True,
				Widget->Adder[{
					"Voltage"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Volt,6500*Volt],
						Units->Volt],
					"Time"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Second,200*Second],
						Units->{Second,{Second,Minute,Hour}}
					]
				},
					Orientation->Vertical
				],
				Category->"Standard Separation"
			},
			{
				OptionName->StandardSeparationVoltageDurationProfile,
				Default->Automatic,
				Description->"Voltage profile for Injection. Supports up to 20 steps.",
				ResolutionDescription->"When StandardSeparationVoltageDurationProfile is set to Automatic and IncludeStandards is True, separation time will be set according to whether or not standards are reduced or not, and which Standard is used. If standard is IgG and not reduced, set time to 25 minutes, otherwise set to 35 minutes. For all conditions, voltage is set to 5750 Volts. When IncludeStandards is False, StandardSeparationVoltageDurationProfile is Null.",
				AllowNull->True,
				Widget->Adder[{
					"Voltage"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Volt,6500*Volt],
						Units->Volt],
					"Time"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,180*Minute],
						Units->{Minute,{Second,Minute,Hour}}
					]
				},
					Orientation->Vertical
				],
				Category->"Standard Separation"
			},
			(* Storage Conditions - Standards *)
			{
				OptionName->StandardInternalReferenceStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for StandardInternalReference of this experiment after the protocol is completed. If left unset, StandardInternalReferences will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardConcentratedSDSBufferStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for StandardConcentratedSDSBuffer of this experiment after the protocol is completed. If left unset, StandardConcentratedSDSBuffer will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardDiluentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for StandardDiluent of this experiment after the protocol is completed. If left unset, StandardDiluent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardSDSBufferStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for StandardSDSBuffer of this experiment after the protocol is completed. If left unset, StandardSDSBuffer will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardReducingAgentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for StandardReducingAgent of this experiment after the protocol is completed. If left unset, StandardReducingAgent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Standard Preparation"
			},
			{
				OptionName->StandardAlkylatingAgentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for StandardAlkylatingAgent of this experiment after the protocol is completed. If left unset, StandardAlkylatingAgent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Standard Preparation"
			}
		],
		{
			OptionName->IncludeBlanks,
			Default->Automatic,
			Description->"Indicates if standards should be included in this experiment. Standards contain identified analytes of known size and Relative Migration Times that can be used as reference for unknown analytes.",
			ResolutionDescription->"If any Blank-related options are set, then this is set True; otherwise, false.",
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
				Description->"Indicates which Blanks to include.",
				ResolutionDescription->"If IncludeStandards is True, set to CESDS Sample Buffer.",
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
				Category->"Blanks"
			},
			{
				OptionName->BlankVolume,
				Default->Automatic,
				Description->"Indicates the volume drawn from the blank to the assay tube. Each tube contains a Blank, an InternalReference, an SDSBuffer, and a ReducingAgent and/or an AlkylatingAgent.",
				ResolutionDescription->"When BlankVolume is set to Automatic and IncludeBlanks is True, the volume is calculated to be 25% of the BlankTotalVolume. When IncludeBlanks is False, BlankVolume is Null. If InjectionTable is informed, specified volumes will be used.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankFrequency,
				Default->Automatic,
				Description->"Indicates how many injections per Blank should be included in this experiment. Sample, Standard, and Blank injection order are resolved according to InjectionTable.",
				ResolutionDescription->"When BlankFrequency is set to Automatic and IncludeBlanks is True, Set Frequency to FirstAnLast.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>GreaterP[0,1]|FirstAndLast|First|Last
				],
				Category->"Blanks"
			},
			{
				OptionName->BlankTotalVolume,
				Default->Automatic,
				Description->"Indicates the final volume in the assay tube prior to loading onto AssayContainer. Each tube contains a standard, an InternalReference, an SDSBuffer, and a ReducingAgent and/or an AlkylatingAgent.",
				ResolutionDescription->"When BlankTotalVolume is set to Automatic and IncludeBlanks is True, Set BlankTotalVolume to TotalVolume. When IncludeBlanks is set to False, BlankTotalVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[50*Microliter,200Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankPremadeMasterMix,
				Default->Automatic,
				Description->"Indicates if Blanks should be mixed with StandardPremadeMasterMix that includes an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
				ResolutionDescription->"When BlankPremadeMasterMix is set to Automatic, it will resolve to True if any of its downstream options is specified.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankPremadeMasterMixReagent,
				Default->Automatic,
				Description->"The premade master mix used for CESDS experiment, containing an SDS buffer, an internal standard, and reducing and / or alkylating agents (if applicable).",
				ResolutionDescription->"When BlankPremadeMasterMixReagent is set to Automatic, it will resolve to the common premade mastermix reagent in samples in .",
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
				ResolutionDescription->"When BlankPremadeMasterMix is set to True and BlankPremadeMasterMixDiluent is set to Automatic, Model[Sample,\"Milli-Q water\"] will be set as diluent.",
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
				Description->"The factor by which the premade mastermix should be diluted by in the final assay tube.",
				ResolutionDescription->"When PremadeMasterMix is set to True and PremadeMasterMixReagentDilutionFactor is set to Automatic, it will be set as the ratio of the total volume to premade mastermix volume.",
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
				Description->"The volume of the premade mastermix required to reach its final concentration.",
				ResolutionDescription->"When volume is set to Automatic, the volume is calculated by the division of TotalVolume by BlankPremadeMasterMixReagentDilutionFactor. If BlankPremadeMasterMix is set to False, BlankPremadeMasterMixVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankPremadeMasterMixStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for BlankPremadeMasterMix of this experiment after the protocol is completed. If left unset, BlankPremadeMasterMix will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankInternalReference,
				Default->Automatic,
				Description->"The solution containing the reference analyte by which Relative Migration Time is normalized. By default a 10 KDa marker is used. It is highly recommended to include an internal standard in Sample Preparation.",
				ResolutionDescription->"When BlankPremadeMasterMix is set to False and InternalReference is set to Automatic, BlankInternalReference will be set as Model[Sample, StockSolution\"Resuspended CESDS Internal Standard 25X\"]. If BlankPremadeMasterMix is set to True, BlankInternalReference is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankInternalReferenceDilutionFactor,
				Default->Automatic,
				Description->"Marks how concentrated the internal standard is. For example, Model[Sample, StockSolution\"Resuspended CESDS Internal Standard 25X\"] is concentrated 25X, hence 2 \[Micro]L should be added in Sample Preparation when final volume is set to 60 \[Micro]L.",
				ResolutionDescription->"When BlankPremadeMasterMix is set to False and BlankInternalReferenceDilutionFactor is set to Automatic, BlankInternalReferenceDilutionFactor will be set to 25. If BlankPremadeMasterMix is set to True, BlankInternalReferenceDilutionFactor is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[1]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankInternalReferenceVolume,
				Default->Automatic,
				Description->"The volume of the internal standard added to each blank.",
				ResolutionDescription->"When volume is set to Automatic, the volume is calculated by the division of TotalVolume by StandardInternalReferenceVolume. When BlankPremadeMasterMix is set to True, BlankInternalReferenceVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankConcentratedSDSBuffer,
				Default->Automatic,
				Description->"The SDS Buffer used to dilute blanks. The final concentration of SDS in this assay must be equal to or greater than 0.5%.",
				ResolutionDescription->"When BlankPremadeMasterMix is set to False and BlankConcentratedSDSBuffer is set to Automatic, BlankConcentratedSDSBuffer will be set as Model[Sample,\"1% SDS in 100mM Tris, pH 9.5\"]. If BlankPremadeMasterMix is set to True, BlankConcentratedSDSBuffer is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankConcentratedSDSBufferDilutionFactor,
				Default->Automatic,
				Description->"Marks how concentrated the BlankConcentratedSDSBuffer is. For example, a BlankConcentratedSDSBuffer that contains 1% SDS is concentrated 2X and will constitute half the BlankTotalVolume.",
				ResolutionDescription->"When BlankPremadeMasterMix is set to False and BlankConcentratedSDSBufferDilutionFactor is set to Automatic, BlankConcentratedSDSBufferDilutionFactor will be set to 2. If BlankPremadeMasterMix is set to True, BlankConcentratedSDSBufferDilutionFactor is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[1]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankDiluent,
				Default->Automatic,
				Description->"The solution used to dilute BlankConcentratedSDSBuffer to working concentration.",
				ResolutionDescription->"When BlankPremadeMasterMix is set to False and Diluent is set to Automatic, Diluent will be set to Model[Sample,\"Milli-Q water\"]. If BlankPremadeMasterMix is set to True, BlankDiluent is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankConcentratedSDSBufferVolume,
				Default->Automatic,
				Description->"The volume of BlankConcentratedSDSBufferVolume added to each sample.",
				ResolutionDescription->"When volume is set to Automatic and BlankPremadeMasterMix is set to False, the volume is calculated by the division of BlankTotalVolume by BlankConcentratedSDSBufferDilutionFactor. When BlankPremadeMasterMix is set to True, BlankConcentratedSDSBufferVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankSDSBuffer,
				Default->Automatic,
				Description->"The SDS Buffer used to dilute the sample. The final concentration of SDS in this assay must be equal or greater than 0.5%.",
				ResolutionDescription->"When BlankSDSBuffer is set to Automaticit is resolved to Null, so that Concentrated SDSBuffer, if set to Automatic, is used.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankSDSBufferVolume,
				Default->Automatic,
				Description->"The volume of SDSBuffer added to each sample.",
				ResolutionDescription->"When BlankSDSBufferVolume is set to Automatic and BlankSDSBuffer is not Null, the volume is calculated by the difference between the BlankTotalVolume and the volume in the tube that includes the Blank, InternalReference, ReducingAgent, and AlkylatingAgent.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankReduction,
				Default->Automatic,
				Description->"Indicates if disulfide bridges should be chemically reduced in the Blank.",
				ResolutionDescription->"When automatic, StandardReduction will set to True if any of the Reduction options are not Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankReducingAgent,
				Default->Automatic,
				Description->"The reducing agent to be added to the Blank. for example, \[Beta]-mercaptoethanol or Dithiothreitol.",
				ResolutionDescription->"When BlankPremadeMasterMix is set to False and BlankReducingAgent is set to Automatic, BlankReducingAgent will be set to Model[Sample,\"2-mercaptoethanol\"]. If BlankPremadeMasterMix is set to True, BlankReducingAgent is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankReducingAgentTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of the reducing agent in the Blank.",
				ResolutionDescription->"When target concentration is set to Automatic, and no BlankReducingAgentVolume value is given, concentration is set to 650 mM. If volume is given concentration will be calculated. If BlankPremadeMasterMix is set to True, BlankReducingAgentTargetConcentration is Null ",
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0*Molar],
						Units->{1,{Molar,{Millimolar,Molar}}}
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0*VolumePercent,100*VolumePercent],
						Units->VolumePercent]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankReducingAgentVolume,
				Default->Automatic,
				Description->"The volume of the reducing agent required to reach its final concentration in the Blank.",
				ResolutionDescription->"When BlankReducingAgentVolume is set to Automatic and BlankPremadeMasterMix is set to False, calculate the volume required to reach BlankReducingAgentTargetConcentration, if set. When BlankReducingAgentVolume is set to Automatic and BlankReducingAgentTargetConcentration is set to Null, BlankReducingAgentVolume is set to Null. When BlankPremadeMasterMix is set to True, BlankReducingAgentVolume is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankAlkylation,
				Default->Automatic,
				Description->"Indicates if Alkylation should be applied to the Blank. Alkylation of free cysteines is useful in mitigating unexpected protein fragmentation and reproducibility issues.",
				ResolutionDescription->"When automatic, BlankAlkylation will set to True if any of the Reduction options are not Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankAlkylatingAgent,
				Default->Automatic,
				Description->"The alkylating agent to be added to the Blank. For example, Iodoacetamide.",
				ResolutionDescription->"When BlankPremadeMasterMix is set to False and BlankAlkylatingAgent is set to Automatic, BlankAlkylatingAgent will be set to Model[Sample,\"250 mM Iodoacetamide\"]. If BlankPremadeMasterMix is set to True, BlankAlkylatingAgent is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankAlkylatingAgentTargetConcentration,
				Default->Automatic,
				Description->"The final concentration of the alkylating agent in the Blank.",
				ResolutionDescription->"When BlankPremadeMasterMix is set to False and BlankAlkylatingAgent is set to Automatic, BlankAlkylatingAgent will be set to Model[Sample,\"250 mM Iodoacetamide\"]. If BlankPremadeMasterMix is set to True, BlankAlkylatingAgent is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0*Molar]|GreaterP[0*Gram/Liter],
					Units->Alternatives[
						{1,{Micromolar,{Micromolar,Millimolar,Molar}}},
						CompoundUnit[
							{1,{Gram,{Gram,Microgram,Milligram}}},
							{-1,{Liter,{Liter,Microliter,Milliliter}}}
						]
					]
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankAlkylatingAgentVolume,
				Default->Automatic,
				Description->"The volume of the alkylating agent required to reach its final concentration in the Blank.",
				ResolutionDescription->"When target concentration is set to Automatic, BlankPremadeMasterMix is set to False, and no BlankAlkylatingAgentVolume value is given, concentration is set to 11.5 millimolar. If volume is given concentration will be calculated. If BlankPremadeMasterMix is set to True, BlankAlkylatingAgentTargetConcentration is Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankSedimentationSupernatantVolume,
				Default->Automatic,
				Description->"The volume of supernatant to transfer to the assay container from the Blank tubes after denaturation and centrifugation. A minimum of 50 \[Micro]L are required for the analysis to proceed.",
				ResolutionDescription->"When BlankPelletSedimentation is True and SedimentationSupernatantVolume is set to Automatic, 90% of the TotalVolume is drawn to avoid disturbing the pellet.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[50*Microliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Category->"Blank Preparation"
			},
			(* Separation Conditions *)
			{
				OptionName->BlankInjectionVoltageDurationProfile,
				Default->{{4600*Volt,20*Second}},
				Description->"Voltage profile for Injection. Supports up to 20 steps where each step is 0-200 Second, and 0-6500 volts.",
				ResolutionDescription->"When BlankInjectionVoltageDurationProfile is set to Automatic and IncludeBlanks is True, BlankInjectionVoltageDurationProfile is set to {{4600*Volt,20*Second}}, otherwise, it is set to Null.",
				AllowNull->True,
				Widget->Adder[{
					"Voltage"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Volt,6500*Volt],
						Units->Volt],
					"Time"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Second,200*Second],
						Units->{Second,{Second,Minute,Hour}}
					]
				},
					Orientation->Vertical
				],
				Category->"Blank Separation"
			},
			{
				OptionName->BlankSeparationVoltageDurationProfile,
				Default->Automatic,
				Description->"Voltage profile for Injection. Supports up to 20 steps.",
				ResolutionDescription->"When BlankSeparationVoltageDurationProfile is set to Automatic, separation time will be set according to whether or not standards are reduced or not, and which Blank is used. If standard is IgG and not reduced, set time to 25 minutes, otherwise set to 35 minutes. For all conditions, voltage is set to 5750 Volts. If IncludeBlanks is False, BlankSeparationVoltageDurationProfile is set to Null.",
				AllowNull->True,
				Widget->Adder[{
					"Voltage"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Volt,6500*Volt],
						Units->Volt],
					"Time"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0*Minute,180*Minute],
						Units->{Minute,{Second,Minute,Hour}}
					]
				},
					Orientation->Vertical
				],
				Category->"Blank Separation"
			},
			(* Storage Conditions - Blanks*)
			{
				OptionName->BlankInternalReferenceStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for BlankInternalReference of this experiment after the protocol is completed. If left unset, BlankInternalReferences will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankConcentratedSDSBufferStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for BlankConcentratedSDSBuffer of this experiment after the protocol is completed. If left unset, BlankConcentratedSDSBuffer will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankDiluentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for BlankDiluent of this experiment after the protocol is completed. If left unset, BlankDiluent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankSDSBufferStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for BlankSDSBuffer of this experiment after the protocol is completed. If left unset, BlankSDSBuffer will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankReducingAgentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for BlankReducingAgent of this experiment after the protocol is completed. If left unset, BlankReducingAgent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Blank Preparation"
			},
			{
				OptionName->BlankAlkylatingAgentStorageCondition,
				Default->Null,
				Description->"The non-default storage condition for BlankAlkylatingAgent of this experiment after the protocol is completed. If left unset, BlankAlkylatingAgent will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				],
				Category->"Blank Preparation"
			}
		],
		(* Storage conditions for Cartridge *)
		{
			OptionName->CartridgeStorageCondition,
			Default->Null,
			Description->"The non-default storage condition for the Cartridge after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>SampleStorageTypeP|Disposal
			],
			Category->"Storage Conditions"
		},
		(* Shared Options *)
		AliquotOptions,
		SimulationOption,
		FuntopiaSharedOptions,
		SamplesInStorageOptions
	}
];

(* ::Subsubsection::Closed:: *)
(* Error/Warning messages *)

(* general errors and messages *)
Error::IncompatibleCartridge="The specified experiment cartridge `1` is not compatible with CapillaryGelElectrophoresis. Set Cartridge to an Object or Model that's ExperimentType is CESDS.";
Error::DiscardedCartridge="The specified cartridge `1` for CapillaryGelElectrophoresis experiment has been discarded. Please choose another Cartridge object or model.";
Error::InjectionTableMismatch="The specified injection table is different from the specified SamplesIn, Ladders, Standards, and/or Blanks. The following objects differ (present in either the InjectionTable or inputs, but not both): `1`. Please make sure that all samples, ladders, standards, and blanks in the injection table are also specified in SamplesIn, Standards, and Blanks, or set to Automatic for the InjectionTable to be resolved based of the inputs.";
Error::InjectionTableReplicatesSpecified="Both an injection table and number of replicates were specified. Please specify either InjectionTable or NumberOfReplicates, but not both.";
Error::InjectionTableVolumeZero="An entry in the injection table `1` has been specified with a 0 Microliter volume. Please use the NumberOfReplicates option to set repeated injections.";
Error::TooManyInjectionsCapillaryGelElectrophoresis="The number of injections specified for samples, ladders, standards, and blanks (`1`) exceeds the number of injections possible for each batch (48). Please consider splitting this protocol to multiple protocols.";
Error::NotEnoughUsesLeftOnCartridge="This protocol requires more injections than the cartridge `1` has left (`2` injections). Please consider splitting this protocol or using another cartridge.";
Warning::NotEnoughOptimalUsesLeftOnCartridge="This protocol requires more injections than the cartridge `1` has left for optimal conditions (`2` injections). Please consider splitting this protocol or using another cartridge.";
Warning::PreMadeMasterMixWithMakeOwnOptions="Options for both premade MasterMix and modular MasterMix are specified for `1`. These options are exclusive to each other and only premade master mix options will take effect. If you dont wish to use a PremadeMasterMix, make sure to set this option to False.";
Warning::MissingSampleComposition="Sample composition is missing for `1`. As a result, sample Volume can't be accurately calculated to reach 1 mg/mL protein and defaulted to 25% of the TotalVolume. Please specify the volume if desired.";
Error::InvalidSupernatantVolume="The volume to transfer after centrifugation is invalid for `1`. Please make sure the volume is specified when pellet sedimentation is True, and that it does not exceed the total volume.";
Error::CentrifugationForceSpeedMismatch="The specified centrifugation force and speed are not copacetic. Please Make sure that values are in agreement, or set one to Automatic.";
Error::CentrifugationForceSpeedNull="While pellet sedimentation is set to True, centrifugation force and/or speed is set to Null. Please set these values to a desired force/speed, or to Automatic.";
Warning::NotReplacingInsert="The cartridge insert will not be replaced, even if required. This may affect the reliability of this cartridge the next time it is used. It is recommended to replace the insert if and when needed. Please consider setting ReplaceCartridgeInsert to True.";
(* premade mastermix branch *)
Error::PremadeMasterMixReagentNull="While premade master mix is True, premade master mix reagent is set to Null for `1`. Please make sure to specify the reagent object that should be used or set premade master mix to False.";
Error::PremadeMasterMixDilutionFactorNull="While premade master mix is True, its reagent's dilution factor is set to Null for `1`. Please make sure to specify either the dilution factor or the volume.";
Error::PremadeMasterMixVolumeNull="While premade master mix is set to True, PremadeMasterMixVolume is Null for `1`. Please set a valid volume or Automatic to use premade master mix reagent. Alternatively, Set premade master mix to False.";
Error::PremadeMasterMixVolumeDilutionFactorMismatch="Specified premade master mix volume and dilution factor are not copacetic. Please make sure that their values are in agreement, or set one to Automatic.";
Error::PremadeMasterMixInvalidTotalVolume="Sample Volume and premade master mix volume sum up to more than the total Volume in `1`. Please make sure volumes do not exceed the total volume in the tube.";
Error::PremadeMasterMixDiluentNull="While premade master mix is True, a Diluent is missing for `1`. Please specify the desired diluent or set to Automatic.";
(* Make your own mastermix branch *)
Error::InternalReferenceNull="InternalReference is set to Null while premade master mix is set to False in `1`. Please set InternalReference to the correct object or Automatic.";
Error::InternalReferenceDilutionFactorNull="the internal reference dilution factor is set to Null while premade master mix is set to False in `1`. Please set the dilution factor to a valid value or Automatic.";
Error::InternalReferenceVolumeNull="the internal reference volume is set to Null while premade master mix is set to False in `1`. Please set the volume to a valid value or Automatic.";
Error::InternalReferenceVolumeDilutionFactorMismatch="The specified internal reference dilution factor and volume are not in agreement for `1`. Please make sure the options are copacetic or consider setting one to Automatic.";
Error::ReducingAgentNull="Reducing agent is set to Null while reduction is set to True for `1`. Please make sure to set the reducing agent to the correct object or to Automatic.";
Warning::NoReducingAgentIdentified="A reducing agent was not identified in the composition of the reducing agent object specified for `1`. Please make sure that the object has valid composition or specify the approproate reducing agent volume.";
Error::ReducingAgentTargetConcentrationNull="The reducing agent's target concentration was not specified for `1`. Please specify either reducing agent's target concentration or volume, or set to Automatic.";
Error::ReducingAgentVolumeNull="The reducing agent volume was not specified for `1`. Please specify either the reducing agent's target concentration or volume, or set to Automatic.";
Error::ReducingAgentVolumeConcentrationMismatch="The specified reducing agent's target concentration and volume are not in agreement for `1`. Please make sure the options are copacetic or consider setting one to Automatic.";
Error::AlkylatingAgentNull="The alkylating agent is set to Null while alkylation is set to True for `1`. Please make sure to set the alkylating agent to the correct object or to Automatic.";
Warning::NoAlkylatingAgentIdentified="A alkylating agent was not identified in the composition of the alkylating agent object specified for `1`. Please make sure that the object has valid composition or specify the alkylating agent's volume.";
Error::AlkylatingAgentTargetConcentrationNull="The alkylating agent's target concentration was not specified for `1`. Please specify either AlkylatingAgentTargetConcentration or AlkylatingAgentTargetVolume, or set to Automatic.";
Error::AlkylatingAgentVolumeNull="The alkylating agent volume was not specified for `1`. Please specify either the alkylating agent's target concentration or volume, or set to Automatic.";
Error::AlkylatingAgentVolumeConcentrationMismatch="The specified alkylating agent's target concentration and volume are not in agreement for `1`. Please make sure the options are copacetic or consider setting one to Automatic.";
Error::SDSBufferNull="No buffer containing SDS has been specified for `1`. Please specify an SDS buffer (concentrated or not) to be used in sample preparation, or set to Automatic.";
Warning::BothSDSBufferOptionsSet="Both Concentrated SDS buffer and SDS buffer options were specified for `1`. Please consider setting one or the other. By default, the Concentrated SDS Buffer option will be used when both options are specified.";
Error::ConcentratedSDSBufferDilutionFactorNull="The concentrated SDS buffer's dilution factor is set to Null for `1` while Concentrated SDS buffer is specified. Please specify the appropriate dilution factor or the reagent's volume.";
Warning::InsufficientSDSinSample="The final concentration of SDS in the samples `1` is lower than the recommended 0.5% SDS minimum. Please consider adding more SDSBuffer to your sample or use a more concentrated SDSbuffer.";
Error::ComponentsDontSumToTotalVolume="The sum of components added to the assay tube is smaller than the specified TotalVolume for `1`. Each assay contains SampleVolume, InternalReferenceVolume, ReducingAgentVolume, AlkylatingAgentVolume, and SDSBufferVolume. Make sure volumes sum to Total Volume or consider setting volumes to Automatic.";
Error::VolumeGreaterThanTotalVolume="The sum of components added to the assay tube is larger than the specified TotalVolume for `1`. Each assay contains SampleVolume, InternalReferenceVolume, ReducingAgentVolume, AlkylatingAgentVolume, and SDSBufferVolume. Make sure volumes sum to Total Volume or consider setting volumes to Automatic.";
Error::DiluentNull="Diluent is not specified when using ConcentratedSDSBuffer and components do not sum to the totalVolume for `1`. Please specify teh Diluent, or set to Automatic.";
Error::TotalVolumeNull="Total volume is set as Null for the following objects `1`. Please specify total volume, or set to Automatic.";
Error::VolumeNull="The volume is set as Null for the following objects `1`. Please specify the volume, or set to Automatic.";
Error::LadderDilutionFactorNull="The dilution factor for the ladder reagent is missing for `1`. Please make sure to set either LadderDilutionFactor or LadderVolume.";
Error::LadderAnalyteMolecularWeightMismatch="The LadderAnalyte molecular weight does not match that specified for AnalyteMolecularWeight for `1`. Please make sure AnalyteMolecularWeight is in agreement with the composition of LadderAnalytes.";
Error::LadderCompositionMolecularWeightMismatch="The Ladder composition molecular weight does not match that specified for AnalyteMolecularWeight for `1`. Please make sure AnalyteMolecularWeight is in agreement with the molecular weight of proteins in Ladder composition.";
Error::LadderAnalytesCompositionMolecularWeightMismatch="The Ladder composition molecular weight does not match that specified for LadderAnalyte composition for `1`. Please make sure LaddarAnalytes are is in agreement with proteins in Ladders composition.";
Warning::FewerLaddersThanUniqueOptionSets="Fewer ladders than the number of unique sample preparation and separation conditions applied to Samples (`1`) were specified. Only the most common set of conditions will be applied to the specified ladders. Please consider specifying exactly `1` instance(s) of each unique ladders in order to apply all unique sets of options on these ladders.";
Error::MolecularWeightMissing="Ladder molecular weights could not be extracted from Ladders, LadderAnalytes, or LadderMolecularWeights for `1`. Please set LadderMolecularWeights in order to use the ladders for molecular weight interpolation.";

(* ::Subsubsection::Closed:: *)
(* singleton sample overload *)
ExperimentCapillaryGelElectrophoresisSDS[mySample:ObjectP[Object[Sample]],myOptions:OptionsPattern[ExperimentCapillaryGelElectrophoresisSDS]]:=ExperimentCapillaryGelElectrophoresisSDS[{mySample},myOptions];

(* ExperimentCapillaryGelElectrophoresisSDS Main Function (Sample overload) *)
ExperimentCapillaryGelElectrophoresisSDS[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedSamples,listedOptions,outputSpecification,output,gatherTests,messages,safeOptions,
		safeOptionTests,mySamplesWithPreparedSamplesNamed,safeOptionsNamed, myOptionsWithPreparedSamplesNamed,
		validLengths,validLengthTests,upload,confirm,fastTrack,parentProt,inheritedCache,
		unresolvedOptions,specifiedInjectionTable,applyTemplateOptionTests,combinedOptions,expandedCombinedOptions,
		sampleModelPreparationPacket,samplePreparationPacket,resolveOptionsResult,resolvedOptions,resolutionTests,
		resolvedOptionsNoHidden,returnEarlyQ,cacheBall,finalizedPacket,userSpecifiedAnalytes,
		resourcePacketTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		allTests,protocolObject,testsRule,optionsRule,validQ,specifiedInstrument,
		specifiedCartridge,allContainerModels,allContainerObjects,allInstrumentObjects,containerFields,
		containerModelFieldsThroughLinks,containerModelFields,allSampleObjects,sampleContainerFields,
		sampleContainerModelFields,allReagentsModels,reagentFields,optionsWithObjects,userSpecifiedObjects,simulatedSampleQ,
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
			ExperimentCapillaryGelElectrophoresisSDS,
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
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed,safeOptionTests}=If[gatherTests,
		SafeOptions[ExperimentCapillaryGelElectrophoresisSDS,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentCapillaryGelElectrophoresisSDS,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Call sanitizeInputs to replace named samples with ids *)
	{mySamplesWithPreparedSamples,safeOptions, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed, myOptionsWithPreparedSamplesNamed];

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
		ValidInputLengthsQ[ExperimentCapillaryGelElectrophoresisSDS,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentCapillaryGelElectrophoresisSDS,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1],Null}
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
		ApplyTemplateOptions[ExperimentCapillaryGelElectrophoresisSDS,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentCapillaryGelElectrophoresisSDS,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,1,Output->Result],Null}
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

	(* if a template was applied, we need to make sure not to take its injection table (because it will not apply, by definition) but also need to make sure we dont omit a specified injection table *)
	specifiedInjectionTable = {InjectionTable->Lookup[safeOptions, InjectionTable]};

	(* Replace our safe options with our inherited options from our template. *)
	combinedOptions=ReplaceRule[safeOptions,ReplaceRule[unresolvedOptions, specifiedInjectionTable]];

	(* Expand index-matching options *)
	expandedCombinedOptions=Last[ExpandIndexMatchedInputs[ExperimentCapillaryGelElectrophoresisSDS,{mySamplesWithPreparedSamples},combinedOptions,1]];

	(* get all of the sample objects*)
	(*don't include cache because that's a bad time when simulating with Prep Primitves*)
	allSampleObjects=DeleteDuplicates[Cases[KeyDrop[combinedOptions,{Simulation, Cache}],ObjectReferenceP[Object[Sample]],Infinity]];

	(* mostly for reagents, grab them off of options so we can download *)
	reagentFields={AlkylatingAgent,StandardAlkylatingAgent,BlankAlkylatingAgent,ReducingAgent,StandardReducingAgent,
		BlankReducingAgent,SDSBuffer,BlankSDSBuffer,StandardSDSBuffer,ConcentratedSDSBuffer,BlankConcentratedSDSBuffer,
		StandardConcentratedSDSBuffer};

	allReagentsModels=DeleteDuplicates[
		Join[(* add models to download by default, get their Object ID *)
			Download[{
				Model[Sample,"2-Mercaptoethanol"],
				Model[Sample,StockSolution,"250mM Iodoacetamide"],
				Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
				Model[Sample, "Unstained Protein Standard"],
				Model[Sample,StockSolution, "Resuspended CESDS IgG Standard"],
				Model[Item,Consumable,"Prefilled Top Running Buffer Vial"],
				Model[Item,Consumable,"CESDS Cartridge Cleanup Column"],
				Model[Sample,"CESDS Running Buffer - Bottom"],
				Model[Sample,"CESDS Separation Matrix"],
				Model[Sample,"CESDS Conditioning Acid"],
				Model[Sample,"CESDS Conditioning Base"],
				Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"],
				Model[Sample,"CESDS Wash Solution"],
				Model[Sample,"Milli-Q water"]
			},Object],
			Cases[Lookup[combinedOptions,reagentFields],ObjectReferenceP[Model[Sample]],Infinity]]];

	(* download container models - but make sure you avoid Model[Container,ProteinCapillaryElectrophoresisCartridge] or insert.
	In addition, to make sure cache has packets for any container Aliquot might request (becuase of targetContainer in the resolver, pass hamiltonCompatibleContainers *)
	allContainerModels=DeleteDuplicates[Flatten[{
		Model[Container,Plate,"96-Well Full-Skirted PCR Plate"],
		Model[Container, Vessel, "Maurice Reagent Glass Vials, 2mL"],
		Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling, ContainerType->Model[Container,Vessel]],
		Cases[combinedOptions,ObjectReferenceP[{Model[Container,Plate],Model[Container,Vessel]}],Infinity]
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
	samplePreparationPacket=Packet[SamplePreparationCacheFields[Object[Sample],Format->Sequence],IncompatibleMaterials,LiquidHandlerIncompatible,Tablet,TabletWeight,TransportWarmed,TransportChilled];
	sampleModelPreparationPacket=Packet[Model[Flatten[{Deprecated,Products,ConcentratedBufferDilutionFactor,IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
	sampleContainerFields=Packet[Container[{Model,SamplePreparationCacheFields[Object[Container],Format->Sequence]}]];
	sampleContainerModelFields=Packet[Container[Model][{MaxVolume,Name,Dimensions,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container],Format->Sequence]}]];
	containerFields=Packet[Model,SamplePreparationCacheFields[Object[Container],Format->Sequence]];
	containerModelFieldsThroughLinks=Packet[Model[{Name,MaxVolume,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container],Format->Sequence]}]];
	containerModelFields=Packet[Name,MaxVolume,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container],Format->Sequence]];

	(* - Throw an error and return failed if any of the specified Objects are not members of the database - *)
	(* Any options whose values _could_ be an object *)
	optionsWithObjects={
		Instrument,
		Cartridge,
		InjectionTable,
		ConditioningAcid,
		ConditioningBase,
		ConditioningWashSolution,
		SeparationMatrix,
		SystemWashSolution,
		PremadeMasterMixReagent,
		PremadeMasterMixDiluent,
		InternalReference,
		ConcentratedSDSBuffer,
		Diluent,
		SDSBuffer,
		ReducingAgent,
		AlkylatingAgent,
		RunningBuffer,
		Ladders,
		Standards,
		Blanks,
		LadderPremadeMasterMixReagent,
		LadderPremadeMasterMixDiluent,
		LadderInternalReference,
		LadderConcentratedSDSBuffer,
		LadderDiluent,
		LadderSDSBuffer,
		LadderReducingAgent,
		LadderAlkylatingAgent,
		StandardPremadeMasterMixReagent,
		StandardPremadeMasterMixDiluent,
		StandardInternalReference,
		StandardConcentratedSDSBuffer,
		StandardDiluent,
		StandardSDSBuffer,
		StandardReducingAgent,
		StandardAlkylatingAgent,
		BlankPremadeMasterMixReagent,
		BlankPremadeMasterMixDiluent,
		BlankInternalReference,
		BlankConcentratedSDSBuffer,
		BlankDiluent,
		BlankSDSBuffer,
		BlankReducingAgent,
		BlankAlkylatingAgent
	};

	(* get any specified analytes *)
	userSpecifiedAnalytes = DeleteDuplicates[Cases[Flatten[Lookup[ToList[combinedOptions],{LadderAnalytes},{}]],ObjectP[]]];

	(* Extract any other objects that the user has explicitly specified *)
	userSpecifiedObjects=Complement[
		DeleteDuplicates@Cases[
			Flatten@Join[ToList[mySamplesWithPreparedSamples],Lookup[ToList[combinedOptions],optionsWithObjects,{}]],
			ObjectP[]
		],
		userSpecifiedAnalytes
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
			Preview->Null
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
				userSpecifiedObjects,
				userSpecifiedAnalytes,
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
					Packet[Name,Model,ExperimentType,Status,NumberOfUses,OnBoardRunningBuffer,MaxInjections,MaxNumberOfUses,OptimalMaxInjections,
						MaxInjectionsPerBatch],
					Packet[Model[{Name,ExperimentType,OnBoardRunningBuffer,MaxInjections,MaxNumberOfUses,OptimalMaxInjections,
						MaxInjectionsPerBatch}]]
				},
				{
					Evaluate[Packet[Deprecated,Products,UsedAsSolvent,ConcentratedBufferDiluent,ConcentratedBufferDilutionFactor,BaselineStock,Products,IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample],Format->Sequence]]],
					Packet[Analytes],
					Packet[Composition],
					Packet[Composition[[All,2]][{CAS,InChI,InChIKey,Synonyms,Name,MolecularWeight}]]
				},
				{
					samplePreparationPacket,
					sampleModelPreparationPacket,
					Packet[Analytes],
					Packet[Composition],
					Packet[Composition[[All,2]][{CAS,InChI,InChIKey,Synonyms,Name,MolecularWeight}]],
					sampleContainerFields,
					sampleContainerModelFields
				},
				{
					Packet[Name,MolecularWeight]
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
	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolutionTests}=resolveCapillaryGelElectrophoresisSDSOptions[ToList[mySamplesWithPreparedSamples],expandedCombinedOptions,Output->{Result,Tests},Cache->cacheBall,Simulation->updatedSimulation];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolutionTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolutionTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolutionTests}={resolveCapillaryGelElectrophoresisSDSOptions[ToList[mySamplesWithPreparedSamples],expandedCombinedOptions,Output->Result,Cache->cacheBall,Simulation->updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveCapillaryGelElectrophoresisSDSOptions doesn't have access to listedOptions *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentCapillaryGelElectrophoresisSDS,
		RemoveHiddenOptions[ExperimentCapillaryGelElectrophoresisSDS,resolvedOptions],
		Messages->False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ=Which[
		MatchQ[resolveOptionsResult,$Failed],True,
		gatherTests,Not[RunUnitTest[<|"Tests"->resolutionTests|>,Verbose->False,OutputFormat->SingleBoolean]],
		True,False
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
		capillaryGelElectrophoresisSDSResourcePackets[ToList[mySamplesWithPreparedSamples],unresolvedOptions,
			resolvedOptions,Output->{Result,Tests},Cache->cacheBall,Simulation->updatedSimulation],
		{capillaryGelElectrophoresisSDSResourcePackets[ToList[mySamplesWithPreparedSamples],unresolvedOptions,
			resolvedOptions,Output->Result,Cache->cacheBall,Simulation->updatedSimulation],Null}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentCapillaryGelElectrophoresisSDS[finalizedPacket,ToList[mySamplesWithPreparedSamples],expandedCombinedOptions,Cache->cacheBall,Simulation->updatedSimulation],
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
				ConstellationMessage->Object[Protocol,CapillaryGelElectrophoresisSDS],
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
ExperimentCapillaryGelElectrophoresisSDS[myContainer:(ObjectP[{Object[Container],Object[Sample]}]|_String),myOptions:OptionsPattern[ExperimentCapillaryGelElectrophoresisSDS]]:=ExperimentCapillaryGelElectrophoresisSDS[{myContainer},myOptions];

(* ExperimentCapillaryGelElectrophoresisSDS Main function (container overload). *)
ExperimentCapillaryGelElectrophoresisSDS[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{
		listedContainers,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedSimulation,containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests,containerToSampleSimulation
	},

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
			ExperimentCapillaryGelElectrophoresisSDS,
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
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentCapillaryGelElectrophoresisSDS,
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
				ExperimentCapillaryGelElectrophoresisSDS,
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
		ExperimentCapillaryGelElectrophoresisSDS[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];

(* ::Subsection:: *)
(* CapillaryGelElectrophoresisSDSOptions Resolver *)
DefineOptions[
	resolveCapillaryGelElectrophoresisSDSOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveCapillaryGelElectrophoresisSDSOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveCapillaryGelElectrophoresisSDSOptions]]:=Module[
	{
		aliquotBools,aliquotTests,alkylatingAgentNullErrors,alkylatingAgentNullInvalidOptions,alkylatingAgentNullNullInvalidSamples,alkylatingAgentNullOptions,
		alkylatingAgentNullTests,alkylatingAgentTargetConcentrationNullErrors,alkylatingAgentTargetConcentrationNullInvalidOptions,
		alkylatingAgentTargetConcentrationNullInvalidSamples,alkylatingAgentTargetConcentrationNullOptions,alkylatingAgentTargetConcentrationNullTests,
		alkylatingAgentVolumeConcentrationMismatchErrors,alkylatingAgentVolumeConcentrationMismatchInvalidOptions,alkylatingAgentVolumeConcentrationMismatchNullInvalidSamples,
		alkylatingAgentVolumeConcentrationMismatchOptions,alkylatingAgentVolumeConcentrationMismatchTests,alkylatingAgentVolumeNullErrors,
		alkylatingAgentVolumeNullInvalidOptions,alkylatingAgentVolumeNullInvalidSamples,alkylatingAgentVolumeNullOptions,
		alkylatingAgentVolumeNullTests,blankAlkylatingAgentNullErrors,blankAlkylatingAgentTargetConcentrationNullErrors,
		blankAlkylatingAgentVolumeConcentrationMismatchErrors,blankAlkylatingAgentVolumeNullErrors,
		blankBothSDSBranchesSetWarnings,blankComponentsDontSumToTotalVolumeErrors,blankConcentratedSDSBufferDilutionFactorNullErrors,
		blankDiluentNullErrors,blankInternalReferenceDilutionFactorNullErrors,blankInternalReferenceNullErrors,
		blankInternalReferenceVolumeDilutionFactorMismatchWarnings,blankInternalReferenceVolumeNullErrors,blankMakeMasterMixOptionsSetBool,
		blankMissingSampleCompositionWarnings,blankNoAlkylatingAgentIdentifiedWarnings,blankNoReducingAgentIdentifiedWarnings,
		blankNotEnoughSDSinSampleWarnings,blankOptionList,blankOptions,blankPremadeMasterMixDiluentNullErrors,
		blankPremadeMasterMixDilutionFactorNullErrors,blankPremadeMasterMixNullErrors,blankPremadeMasterMixTotalVolumeErrors,
		blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings,blankPremadeMasterMixVolumeNullErrors,blankPremadeMasterMixWithmakeMasterMixOptionsSetQ,
		blankReducingAgentNullErrors,blankReducingAgentTargetConcentrationNullErrors,blankReducingAgentVolumeConcentrationMismatchErrors,
		blankReducingAgentVolumeNullErrors,blankSDSBufferNullErrors,blanksInInjectionTableBool,blankSupernatantVolumeInvalidErrors,
		blankVolumeGreaterThanTotalVolumeErrors,bothSDSBranchesSetInvalidSamples,bothSDSBranchesSetOptions,bothSDSBranchesSetTest,bothSDSBranchesSetWarnings,
		capillaryGelElectrophoresisSDSOptions,capillaryGelElectrophoresisSDSOptionsAssociation,cartridgeCompatibleQ,cartridgeModelPacket,cartridgeObject,cartridgePacket,centrifugationOptions,
		includeCentrifugationOptionBool,centrifugeForceSpeedNullInvalidSamples,centrifugeSpeedMismatchInvalidSamples,compatibleMaterialsBool,
		compatibleMaterialsInvalidInputs,compatibleMaterialsTests,componentsDontSumToTotalVolumeeNullOptions,componentsDontSumToTotalVolumeErrors,
		componentsDontSumToTotalVolumeInvalidOptions,componentsDontSumToTotalVolumeInvalidSamples,componentsDontSumToTotalVolumeTests,compositionModels,
		concentratedSDSBufferDilutionFactorNullErrors,concentratedSDSBufferDilutionFactorNullInvalidOptions,concentratedSDSBufferDilutionFactorNullInvalidSamples,
		concentratedSDSBufferDilutionFactorNullOptions,concentratedSDSBufferDilutionFactorNullTests,deprecatedInvalidInputs,
		deprecatedModelPackets,deprecatedTest,diluentNullErrors,diluentNullInvalidOptions,diluentNullInvalidSamples,
		diluentNullOptions,diluentNullTests,discardedCartridgeInvalidOption,discardedCartridgeInvalidTest,discardedInvalidInputs,discardedLadderInvalidOptions,
		discardedLadders,discardedLadderTest,discardedSamplePackets,discardedTest,email,engineQ,enoughLaddersForUniqueOptionSetsQ,enoughLaddersForUniqueOptionSetsTest,
		expandedBlanksOptions,expandedLaddersOptions,expandedStandardsOptions,fastTrack,gatherTests,hamiltonCompatibleContainers,includeBlankOptionBool,includeLadderOptionBool,
		includeStandardOptionBool,incompatibleCartridgeInvalidOption,incompatibleCartridgeTest,inheritedCache,injectionPrecisionTests,injectionTableContainsAllQ,injectionTableValidQ,
		injectionTableVolumeZeroInvalidOption,injectionTableVolumeZeroInvalidTest,injectionTableWithReplicatesInvalidOption,injectionTableWithReplicatesInvalidTest,
		instrumentModelPacket,internalReferenceDilutionFactorNullErrors,internalReferenceDilutionFactorNullInvalidOptions,internalReferenceDilutionFactorNullInvalidSamples,
		internalReferenceDilutionFactorNullOptions,internalReferenceDilutionFactorNullTests,internalReferenceNullErrors,internalReferenceNullInvalidOptions,
		internalReferenceNullNullInvalidSamples,internalReferenceNullOptions,internalReferenceNullTests,internalReferenceVolumeDilutionFactorMismatchInvalidOptions,
		internalReferenceVolumeDilutionFactorMismatchOptions,internalReferenceVolumeDilutionFactorMismatchTests,internalReferenceVolumeDilutionFactorMismatchWarnings,
		internalReferenceVolumeNullErrors,internalReferenceVolumeNullInvalidOptions,internalReferenceVolumeNullInvalidSamples,internalReferenceVolumeNullOptions,
		internalReferenceVolumeNullTests,invalidInjectionTableOption,invalidInjectionTableTest,invalidInputs,invalidOptions,keyBlankNames,keyBlankNamesPrependRemoved,
		keyStandardNames,keyStandardNamesPrependRemoved,ladderAlkylatingAgentNullErrors,ladderAlkylatingAgentTargetConcentrationNullErrors,
		ladderAlkylatingAgentVolumeConcentrationMismatchErrors,ladderAlkylatingAgentVolumeNullErrors,ladderAnalyteLabelErrors,
		ladderAnalyteMolecularWeightMismatchInvalidOptions,ladderAnalyteMolecularWeightMismatchs,ladderAnalyteMolecularWeightMismatchTests,
		ladderAnalytesCompositionMolecularWeightMismatchInvalidOptions,ladderAnalytesCompositionMolecularWeightMismatchs,ladderAnalytesCompositionMolecularWeightMismatchTests,
		ladderBothSDSBranchesSetWarnings,ladderComponentsDontSumToTotalVolumeErrors,ladderCompositionMolecularWeightMismatchInvalidOptions,
		ladderCompositionMolecularWeightMismatchs,ladderCompositionMolecularWeightMismatchTests,ladderConcentratedSDSBufferDilutionFactorNullErrors,ladderDiluentNullErrors,
		ladderDilutionFactorNullErrors,ladderDilutionFactorNullInvalidOptions,ladderDilutionFactorNullTests,ladderInternalReferenceDilutionFactorNullErrors,
		ladderInternalReferenceNullErrors,ladderInternalReferenceVolumeDilutionFactorMismatchWarnings,ladderInternalReferenceVolumeNullErrors,
		ladderMakeMasterMixOptionsSetBool,ladderMakeOnesOwnMasterMixOptions,ladderMapFriendlySamplesInResolvedOptions,ladderMissingSampleCompositionWarnings,
		ladderModelPacket,ladderModelPackets,ladderModels,ladderNoAlkylatingAgentIdentifiedWarnings,ladderNoReducingAgentIdentifiedWarnings,ladderNotEnoughSDSinSampleWarnings,
		ladderObjects,ladderOptions,ladderPacket,ladderPackets,ladderPremadeMasterMixDiluentNullErrors,ladderPremadeMasterMixDilutionFactorNullErrors,
		ladderPremadeMasterMixNullErrors,ladderPremadeMasterMixOptions,ladderPremadeMasterMixTotalVolumeErrors,ladderPremadeMasterMixVolumeDilutionFactorMismatchWarnings,
		ladderPremadeMasterMixVolumeNullErrors,ladderPremadeMasterMixWithmakeMasterMixOptionsSetQ,ladderReducingAgentNullErrors,
		ladderReducingAgentTargetConcentrationNullErrors,ladderReducingAgentVolumeConcentrationMismatchErrors,ladderReducingAgentVolumeNullErrors,ladderSDSBufferNullErrors,
		laddersInInjectionTableBool,ladderSupernatantVolumeInvalidErrors,ladderTotalVolumeNullErrors,ladderVolumeGreaterThanTotalVolumeErrors,ladderVolumeNullErrors,
		makeOnesOwnMasterMixOptions,mapFriendlyUniqueOptions,mapThreadFriendlyBlankOptions,mapThreadFriendlyLadderOptions,mapThreadFriendlyOptions,
		mapThreadFriendlyStandardOptions,messages,missingSampleCompositionWarnings,missingSampleCompositionWarningsOptions,missingSampleCompositionWarningsSamples,
		missingSampleCompositionWarningTests,modelPacketsToCheckIfdeprecaded,molecularWeightMissingInModelWarningInvalidOptions,molecularWeightMissingInModelWarnings,
		molecularWeightMissingInModelWarningTests,nameInvalidOptions,noAlkylatingAgentIdentifiedInvalidSamples,noAlkylatingAgentIdentifiedOptions,
		noAlkylatingAgentIdentifiedTest,noAlkylatingAgentIdentifiedWarning,noAlkylatingAgentIdentifiedWarnings,noReducingAgentIdentifiedInvalidSamples,
		noReducingAgentIdentifiedOptions,noReducingAgentIdentifiedTest,noReducingAgentIdentifiedWarning,noReducingAgentIdentifiedWarnings,notEnoughOptimalUsesLeftOption,
		notEnoughOptimalUsesLeftOptionTest,notEnoughSDSinSampleInvalidSamples,notEnoughSDSinSampleNullOptions,notEnoughSDSinSampleTest,notEnoughSDSinSampleWarnings,
		notEnoughUsesLeftOption,notEnoughUsesLeftOptionTest,notReplacingInsertOption,notReplacingInsertTest,opsDef,
		optimalUsesLeftOnCartridge,optionObjectModelComposition,optionObjectModelCompositionPackets,
		optionObjectModelPackets,optionObjectsModels,output,outputSpecification,parentProtocol,precisionTests,preexpandedBlanksOptions,preexpandedLaddersOptions,
		preexpandedStandardsOptions,premadeMasterMixDiluent,premadeMasterMixDiluentNullErrors,premadeMasterMixDiluentNullInvalidOptions,
		premadeMasterMixDiluentNullInvalidSamples,premadeMasterMixDiluentNullOptions,premadeMasterMixDiluentNullTests,premadeMasterMixDilutionFactorNullErrors,
		premadeMasterMixDilutionFactorNullInvalidOptions,premadeMasterMixDilutionFactorNullTests,premadeMasterMixNullErrors,premadeMasterMixNullInvalidOptions,
		premadeMasterMixNullInvalidSamples,premadeMasterMixNullOptions,premadeMasterMixNullTests,premadeMasterMixOptions,
		premadeMasterMixReagentDilutionFactorNullInvalidSamples,premadeMasterMixReagentDilutionFactorNullOptions,premadeMasterMixTotalVolumeErrors,
		premadeMasterMixTotalVolumeErrorsInvalidSamples,premadeMasterMixTotalVolumeErrorsNullOptions,premadeMasterMixTotalVolumeInvalidOptions,
		premadeMasterMixTotalVolumeTests,premadeMasterMixVolumeDilutionFactorMismatchInvalidOptions,premadeMasterMixVolumeDilutionFactorMismatchInvalidSamples,
		premadeMasterMixVolumeDilutionFactorMismatchOptions,premadeMasterMixVolumeDilutionFactorMismatchTests,premadeMasterMixVolumeDilutionFactorMismatchWarnings,
		premadeMasterMixVolumeNullErrors,premadeMasterMixVolumeNullInvalidOptions,premadeMasterMixVolumeNullNullInvalidSamples,premadeMasterMixVolumeNullOptions,
		premadeMasterMixVolumeNullTests,premadeMasterMixWithmakeMasterMixOptionsSetInvalidOption,premadeMasterMixWithmakeMasterMixOptionsSetInvalidOptionTest,
		premadeMasterMixWithmakeMasterMixOptionsSetQ,PreMadeMasterMixWithMakeOwnInvalidOptions,PreMadeMasterMixWithMakeOwnInvalidSamples,reducingAgentNullErrors,
		reducingAgentNullInvalidOptions,reducingAgentNullNullInvalidSamples,reducingAgentNullOptions,reducingAgentNullTests,reducingAgentTargetConcentrationNullErrors,
		reducingAgentTargetConcentrationNullInvalidOptions,reducingAgentTargetConcentrationNullInvalidSamples,reducingAgentTargetConcentrationNullOptions,
		reducingAgentTargetConcentrationNullTests,reducingAgentVolumeConcentrationMismatchErrors,reducingAgentVolumeConcentrationMismatchInvalidOptions,
		reducingAgentVolumeConcentrationMismatchNullInvalidSamples,reducingAgentVolumeConcentrationMismatchOptions,
		reducingAgentVolumeConcentrationMismatchTests,reducingAgentVolumeNullErrors,reducingAgentVolumeNullInvalidOptions,
		reducingAgentVolumeNullInvalidSamples,reducingAgentVolumeNullOptions,reducingAgentVolumeNullTests,renamedBlankOptionSet,
		renamedStandardOptionSet,requiredAliquotAmounts,requiredBlanks,	requiredLadders,requiredStandards,resolvedAliquotOptions,resolvedAlkylatingAgent,
		resolvedAlkylatingAgentTargetConcentration,resolvedAlkylatingAgentVolume,resolvedAlkylation,resolvedBlankAlkylatingAgent,
		resolvedBlankAlkylatingAgentTargetConcentration,resolvedBlankAlkylatingAgentVolume,resolvedBlankAlkylation,resolvedBlankConcentratedSDSBuffer,
		resolvedBlankConcentratedSDSBufferDilutionFactor,resolvedBlankConcentratedSDSBufferVolume,resolvedBlankDiluent,resolvedBlankFrequency,
		resolvedBlankInjectionVoltageDurationProfile,resolvedBlankInternalReference,resolvedBlankInternalReferenceDilutionFactor,
		resolvedBlankInternalReferenceVolume,resolvedBlankPremadeMasterMix,resolvedBlankPremadeMasterMixDiluent,resolvedBlankPremadeMasterMixReagent,
		resolvedBlankPremadeMasterMixReagentDilutionFactor,resolvedBlankPremadeMasterMixVolume,resolvedBlankReducingAgent,resolvedBlankReducingAgentTargetConcentration,
		resolvedBlankReducingAgentVolume,resolvedBlankReduction,resolvedBlanks,resolvedBlankSDSBuffer,resolvedBlankSDSBufferVolume,
		resolvedBlankSedimentationSupernatantVolume,resolvedBlankSeparationVoltageDurationProfile,resolvedBlanksPackets,resolvedBlankTotalVolume,
		resolvedBlankVolume,resolvedConcentratedSDSBuffer,resolvedConcentratedSDSBufferDilutionFactor,resolvedCoolingTemperature,
		resolvedCoolingTime,resolvedConcentratedSDSBufferVolume,resolvedDenaturingTemperature,resolvedDenaturingTime,resolvedDiluent,resolvedEmail,
		resolvedExperimentOptions,resolvedIncludeCentrifugation,resolvedInjectionTable,resolvedInternalReference,
		resolvedInternalReferenceDilutionFactor,resolvedInternalReferenceVolume,resolvedLadderAlkylatingAgent,resolvedLadderAlkylatingAgentTargetConcentration,
		resolvedLadderAlkylatingAgentVolume,resolvedLadderAlkylation,resolvedLadderAnalyteLabels,resolvedLadderAnalyteMolecularWeights,resolvedLadderAnalytes,
		resolvedLadderConcentratedSDSBuffer,resolvedLadderConcentratedSDSBufferDilutionFactor,resolvedLadderConcentratedSDSBufferVolume,resolvedLadderDiluent,
		resolvedLadderDilutionFactor,resolvedLadderFrequency,resolvedLadderInjectionVoltageDurationProfile,resolvedLadderInternalReference,
		resolvedLadderInternalReferenceDilutionFactor,resolvedLadderInternalReferenceVolume,resolvedLadderPremadeMasterMix,resolvedLadderPremadeMasterMixDiluent,
		resolvedLadderPremadeMasterMixReagent,resolvedLadderPremadeMasterMixReagentDilutionFactor,resolvedLadderPremadeMasterMixVolume,resolvedLadderReducingAgent,
		resolvedLadderReducingAgentTargetConcentration,resolvedLadderReducingAgentVolume,resolvedLadderReduction,
		resolvedLadders,resolvedLadderSDSBuffer,resolvedLadderSDSBufferVolume,resolvedLadderSedimentationSupernatantVolume,
		resolvedLadderSeparationVoltageDurationProfile,resolvedLadderTotalVolume,resolvedLadderVolume,resolvedOptions,resolvedPostProcessingOptions,
		resolvedPremadeMasterMix,resolvedPremadeMasterMixDiluent,resolvedPremadeMasterMixReagentDilutionFactor,resolvedPremadeMasterMixVolume,resolvedReducingAgent,
		resolvedReducingAgentTargetConcentration,resolvedReducingAgentVolume,resolvedReduction,resolvedSamplePrepOptions,resolvedSampleVolume,resolvedSDSBuffer,
		resolvedSDSBufferVolume,resolvedSedimentationCentrifugationForce,resolvedSedimentationCentrifugationSpeed,resolvedSedimentationCentrifugationTemperature,
		resolvedSedimentationCentrifugationTime,resolvedSedimentationSupernatantVolume,resolvedSeparationVoltageDurationProfile,resolvedStandardAlkylatingAgent,
		resolvedStandardAlkylatingAgentTargetConcentration,resolvedStandardAlkylatingAgentVolume,resolvedStandardAlkylation,resolvedStandardConcentratedSDSBuffer,
		resolvedStandardConcentratedSDSBufferDilutionFactor,resolvedStandardConcentratedSDSBufferVolume,resolvedStandardDiluent,resolvedStandardFrequency,
		resolvedStandardInjectionVoltageDurationProfile,resolvedStandardInternalReference,
		resolvedStandardInternalReferenceDilutionFactor,resolvedStandardInternalReferenceVolume,resolvedStandardPremadeMasterMix,resolvedStandardPremadeMasterMixDiluent,
		resolvedStandardPremadeMasterMixReagent,resolvedStandardPremadeMasterMixReagentDilutionFactor,resolvedStandardPremadeMasterMixVolume,resolvedStandardReducingAgent,
		resolvedStandardReducingAgentTargetConcentration,resolvedStandardReducingAgentVolume,resolvedStandardReduction,resolvedStandards,resolvedStandardSDSBuffer,
		resolvedStandardSDSBufferVolume,resolvedStandardSedimentationSupernatantVolume,resolvedStandardSeparationVoltageDurationProfile,
		resolvedStandardsPackets,resolvedStandardTotalVolume,resolvedStandardVolume,resolveIncludeBlanks,
		resolveIncludeLadders,resolveIncludeStandards,resolveSedimentationCentrifugationSpeed,resolveSedimentationCentrifugationForce,
		roundedCapillaryGelElectrophoresisSDSOptions,roundedInjectionOptions,roundedSeparationOptions,roundedSingletonOptions,
		sampleCompositionModelPackets,sampleCountInvalidOption,sampleCountQ,sampleCountTest,sampleModelPackets,samplePackets,samplePacketsToCheckIfDiscarded,
		samplePrepContainers,samplePrepModelSamples,samplePrepOptions,samplePrepTests,samplesInOptions,samplesInStorage,samplesMakeMasterMixOptionsSetBool,samplesMissingFromInjectionTables,
		sDSBufferNullErrors,sDSBufferNullInvalidOptions,sDSBufferNullInvalidSamples,sDSBufferNullOptions,sDSBufferNullTests,
		sedimentationForceSpeedMismatchInvalidOptions,sedimentationForceSpeedMismatchs,sedimentationForceSpeedMismatchTests,sedimentationForceSpeedNulls,
		sedimentationForceSpeedNullsInvalidOptions,sedimentationForceSpeedNullsTests,separationPrecisionTests,updatedSimulation,smallCacheBall,
		simulatedSamplePackets,simulatedSampleContainerPackets,simulatedSamples,singletonTests,standardAlkylatingAgentNullErrors,standardAlkylatingAgentTargetConcentrationNullErrors,
		standardAlkylatingAgentVolumeConcentrationMismatchErrors,standardAlkylatingAgentVolumeNullErrors,
		standardBothSDSBranchesSetWarnings,standardComponentsDontSumToTotalVolumeErrors,standardConcentratedSDSBufferDilutionFactorNullErrors,standardDiluentNullErrors,
		standardInInjectionTableBool,standardInternalReferenceDilutionFactorNullErrors,standardInternalReferenceNullErrors,
		standardInternalReferenceVolumeDilutionFactorMismatchWarnings,standardInternalReferenceVolumeNullErrors,
		standardMakeMasterMixOptionsSetBool,standardMissingSampleCompositionWarnings,standardNoAlkylatingAgentIdentifiedWarnings,
		standardNoReducingAgentIdentifiedWarnings,standardNotEnoughSDSinSampleWarnings,standardOptionList,standardOptions,
		standardPremadeMasterMixDiluentNullErrors,standardPremadeMasterMixDilutionFactorNullErrors,standardPremadeMasterMixNullErrors,
		standardPremadeMasterMixTotalVolumeErrors,standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings,standardPremadeMasterMixVolumeNullErrors,
		standardPremadeMasterMixWithmakeMasterMixOptionsSetQ,standardReducingAgentNullErrors,standardReducingAgentTargetConcentrationNullErrors,
		standardReducingAgentVolumeConcentrationMismatchErrors,standardReducingAgentVolumeNullErrors,
		standardSDSBufferNullErrors,standardSupernatantVolumeInvalidErrors,standardVolumeGreaterThanTotalVolumeErrors,
		supernatantVolumeInvalidErrors,supernatantVolumeInvalidOptions,supernatantVolumeInvalidSamples,supernatantVolumeOptions,supernatantVolumeTests,targetContainers,suppliedConsolidation,resolvedConsolidation,aliquotOptions,
		uniqueOptionCombinations,uniqueSamplesInOptionAssociation,upload,usesLeftOnCartridge,validContainerStoragConditionInvalidOptions,validContainerStorageConditionBool,
		validContainerStorageConditionTests,validNameQ,validNameTest,volumeGreaterThanTotalVolumeErrors,volumeGreaterThanTotalVolumeInvalidOptions,
		volumeGreaterThanTotalVolumeInvalidSamples,volumeGreaterThanTotalVolumeNullOptions,volumeGreaterThanTotalVolumeTests,standardTotalVolumeNullErrors,
		standardVolumeNullErrors,blankTotalVolumeNullErrors,blankVolumeNullErrors,totalVolumeNullOptions,totalVolumeNullInvalidSamples,totalVolumeNullInvalidOptions,
		totalVolumeNullTests,volumeNullOptions,volumeNullInvalidSamples,volumeNullInvalidOptions,volumeNullTests,specifiedInjectionTable,specifiedNumberOfReplicates,roundedInjectionTableSampleVolumes,
		injectionTableSampleVolumes,injectionTableLadderVolumes,roundedInjectionTableLadderVolumes,injectionTableStandardVolumes,roundedInjectionTableStandardVolumes,
		roundedInjectionTableBlankVolumes,injectionTableBlankVolumes,lengthCorrectedInjectionTableLadderVolumes,lengthCorrectedInjectionTableStandardVolumes,
		lengthCorrectedInjectionTableBlankVolumes,injectionTableSamplesNotCopaceticQ,injectionTableLaddersNotCopaceticQ,
		injectionTableStandardNotCopaceticQ,injectionTableBlankNotCopaceticQ,incubationOptions,includeIncubationOptionBool,
		resolvedIncludeIncubation,simulation,volumeZeroInjectionTableBool,
		resolvedSampleLabel,resolvedSampleContainerLabel
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
	(* Separate out our CapillaryGelElectrophoresisSDS options from our Sample Prep options. *)
	{samplePrepOptions,capillaryGelElectrophoresisSDSOptions}=splitPrepOptions[myOptions];

	(* Resolve sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentCapillaryGelElectrophoresisSDS,mySamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentCapillaryGelElectrophoresisSDS,mySamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->Result],{}}
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
				{Packet[Container[Model]]},
				{Evaluate[Packet[Name, MaxVolume, DefaultStorageCondition, SamplePreparationCacheFields[Model[Container], Format -> Sequence]]]},
				{Evaluate[Packet[Deprecated, Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample], Format -> Sequence]]]}
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
	capillaryGelElectrophoresisSDSOptionsAssociation=Association[capillaryGelElectrophoresisSDSOptions];

	(* Fetch simulated samples' cached packets *)
	simulatedSamplePackets=fetchPacketFromCache[#,inheritedCache]&/@simulatedSamples;

	(* Fetch simulated sample containers' cached packets *)
	simulatedSampleContainerPackets=fetchPacketFromCache[Download[#,Object],inheritedCache]&/@Lookup[simulatedSamplePackets,Container];

	(* currently the instrument model is always this; in the future this might be a viable option *)
	instrumentModelPacket=FirstCase[inheritedCache,ObjectP[Model[Instrument,ProteinCapillaryElectrophoresis]]];

	(* split out the sample and model packets *)
	samplePackets=fetchPacketFromCache[#,inheritedCache]&/@mySamples;
	sampleModelPackets=fetchPacketFromCache[#,inheritedCache]&/@Lookup[samplePackets,Model,{}];

	(* split out the ladder object and model packets *)
	ladderObjects=DeleteDuplicates[
		Join[
			{Download[Model[Sample, "Unstained Protein Standard"],Object]},
			Download[Flatten[Lookup[capillaryGelElectrophoresisSDSOptionsAssociation,{Ladders,LadderAnalytes}]/.Automatic:>Null],Object]]
	];

	(* remove any Automatic, if ladders or analytes were not set by user and grab the packet*)
	ladderPackets=fetchPacketFromCache[#,inheritedCache]&/@Cases[ToList[ladderObjects],ObjectP[]] ;

	(* get models regardless of whether an object or a model is passed *)
	ladderModels=Cases[Flatten[{Lookup[ladderPackets,Model],Lookup[ladderPackets,Object]}],ObjectP[{Model[Sample],Object[Sample]}]];
	ladderModelPackets=fetchPacketFromCache[#,inheritedCache]&/@ladderModels;

	(* Get composition models for all samples *)
	compositionModels=DeleteDuplicates[Flatten[{#[Composition][[All,2]],#[Analytes]}&/@Join[samplePackets,ladderModelPackets]]];
	sampleCompositionModelPackets=fetchPacketFromCache[#,inheritedCache]&/@compositionModels;

	(* get objects and models for reagents, standards, blanks, and ladders *)
	optionObjectsModels=Join[
		DeleteDuplicates[Cases[KeyDrop[capillaryGelElectrophoresisSDSOptionsAssociation],ObjectReferenceP[{Object[Sample],Model[Sample]}],Infinity]],
		{
			Model[Sample,"2-Mercaptoethanol"],
			Model[Sample,StockSolution,"250mM Iodoacetamide"],
			Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
			Model[Sample, "Unstained Protein Standard"],
			Model[Sample,StockSolution, "Resuspended CESDS IgG Standard"],
			Model[Sample,"CESDS Running Buffer - Bottom"],
			Model[Sample,"CESDS Separation Matrix"],
			Model[Sample,"CESDS Conditioning Acid"],
			Model[Sample,"CESDS Conditioning Base"],
			Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"],
			Model[Sample,"CESDS Wash Solution"]
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
	opsDef=OptionDefinition[ExperimentCapillaryGelElectrophoresisSDS];

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
	cartridgeObject=Download[Lookup[capillaryGelElectrophoresisSDSOptions,Cartridge],Object];
	cartridgePacket=fetchPacketFromCache[cartridgeObject,inheritedCache];
	(* grab the model, in case we got an object *)
	cartridgeModelPacket=If[MatchQ[cartridgePacket[Object],ObjectP[Object[Container,ProteinCapillaryElectrophoresisCartridge]]],
		fetchPacketFromCache[Lookup[cartridgePacket,Model],inheritedCache],
		cartridgePacket];

	(* check if ExperimentType is compatible with experiment*)
	cartridgeCompatibleQ=MatchQ[Lookup[cartridgePacket,ExperimentType],Alternatives[CESDS|CESDSPlus]];

	(* if cartridge is incompatible, throw an error *)
	incompatibleCartridgeInvalidOption=If[MatchQ[cartridgeCompatibleQ,False]&&messages,
		(
			Message[Error::IncompatibleCartridge,ObjectToString[Lookup[capillaryGelElectrophoresisSDSOptions,Cartridge]]];
			{Cartridge}
		),
		{}
	];

	incompatibleCartridgeTest=If[gatherTests,
		Test["Experiment Cartridge is compatible with CapillaryGelElectrophoresisSDS:",
			cartridgeCompatibleQ,
			True
		],
		Nothing
	];


	(** discardedCartridge **)
	discardedCartridgeInvalidOption=If[MatchQ[Lookup[cartridgePacket,Status,Null],Discarded]&&messages,
		(
			Message[Error::DiscardedCartridge,ObjectToString[Lookup[cartridgePacket,Object],Cache->inheritedCache]];
			{Cartridge}
		),
		{}
	];

	(* If we need to gather tests, generate the tests for cartridge check *)
	discardedCartridgeInvalidTest=If[gatherTests,
		Test["Cartridge chosen for CapillaryGelElectrophoresisSDS experiment is not discarded:",
			MatchQ[Lookup[cartridgePacket,Status,Null],Discarded],
			False
		],
		Nothing
	];



	(*-- OPTION PRECISION CHECKS --*)
	(* Since VoltageProfiles are in a tuple, the will have to be split for precision checks and transpose after. The following function does that.*)
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

	(* check precision for injectionVoltegeDurationProfiles *)
	{roundedInjectionOptions,injectionPrecisionTests}=precisionForListedOptions[
		KeyTake[capillaryGelElectrophoresisSDSOptionsAssociation,
			{InjectionVoltageDurationProfile,StandardInjectionVoltageDurationProfile,BlankInjectionVoltageDurationProfile,LadderInjectionVoltageDurationProfile}],
		{1 Volt,10^-4 Second}];
	(* check precision for injectionVoltegeDurationProfiles *)
	{roundedSeparationOptions,separationPrecisionTests}=precisionForListedOptions[
		KeyTake[capillaryGelElectrophoresisSDSOptionsAssociation,
			{SeparationVoltageDurationProfile,StandardSeparationVoltageDurationProfile,BlankSeparationVoltageDurationProfile,LadderSeparationVoltageDurationProfile}],
		{1 Volt,10^-4 Minute}];

	(* run RoundOptionPrecision on all other relevant options, except VoltageDurationProfile options *)
	{roundedSingletonOptions,singletonTests}=If[gatherTests,
		RoundOptionPrecision[capillaryGelElectrophoresisSDSOptionsAssociation,
			{SampleVolume,TotalVolume,PremadeMasterMixVolume,InternalReferenceVolume,ConcentratedSDSBufferVolume,SDSBufferVolume,ReducingAgentVolume,
				AlkylatingAgentVolume,SedimentationSupernatantVolume,LadderTotalVolume,LadderVolume,BlankVolume,BlankTotalVolume,BlankPremadeMasterMixVolume,
				BlankInternalReferenceVolume,BlankConcentratedSDSBufferVolume,BlankSDSBufferVolume,BlankReducingAgentVolume,BlankAlkylatingAgentVolume,
				BlankSedimentationSupernatantVolume,StandardVolume,StandardTotalVolume,StandardPremadeMasterMixVolume,StandardInternalReferenceVolume,
				StandardConcentratedSDSBufferVolume,StandardSDSBufferVolume,StandardReducingAgentVolume,StandardAlkylatingAgentVolume,
				StandardSedimentationSupernatantVolume,LadderPremadeMasterMixVolume,LadderInternalReferenceVolume,LadderConcentratedSDSBufferVolume,
				LadderSDSBufferVolume,LadderReducingAgentVolume,LadderAlkylatingAgentVolume,LadderSedimentationSupernatantVolume},
			{10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,
				10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,
				10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,
				10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter},
			Output->{Result,Tests}],
		{RoundOptionPrecision[capillaryGelElectrophoresisSDSOptionsAssociation,
			{SampleVolume,TotalVolume,PremadeMasterMixVolume,InternalReferenceVolume,ConcentratedSDSBufferVolume,SDSBufferVolume,ReducingAgentVolume,
				AlkylatingAgentVolume,SedimentationSupernatantVolume,LadderTotalVolume,LadderVolume,BlankVolume,BlankTotalVolume,BlankPremadeMasterMixVolume,
				BlankInternalReferenceVolume,BlankConcentratedSDSBufferVolume,BlankSDSBufferVolume,BlankReducingAgentVolume,BlankAlkylatingAgentVolume,
				BlankSedimentationSupernatantVolume,StandardVolume,StandardTotalVolume,StandardPremadeMasterMixVolume,StandardInternalReferenceVolume,
				StandardConcentratedSDSBufferVolume,StandardSDSBufferVolume,StandardReducingAgentVolume,StandardAlkylatingAgentVolume,
				StandardSedimentationSupernatantVolume,LadderPremadeMasterMixVolume,LadderInternalReferenceVolume,LadderConcentratedSDSBufferVolume,
				LadderSDSBufferVolume,LadderReducingAgentVolume,LadderAlkylatingAgentVolume,LadderSedimentationSupernatantVolume},
			{10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,
				10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,
				10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,
				10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter,10^-1Microliter}],
			{}}
	];

	(* gather all rounded options and tests *)
	roundedCapillaryGelElectrophoresisSDSOptions=Join[roundedSingletonOptions,roundedInjectionOptions,roundedSeparationOptions];
	precisionTests=Join[injectionPrecisionTests,separationPrecisionTests,singletonTests];

	(* CompatibleMaterialsQ - Passing cache with updated simulation to account for both cases together *)
	{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Instrument],simulatedSamples,Cache->inheritedCache, Simulation->updatedSimulation,Output->{Result,Tests}],
		{CompatibleMaterialsQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Instrument],simulatedSamples,Cache->inheritedCache, Simulation->updatedSimulation,Messages->messages],{}}
	];

	(* If the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidInputs=If[Not[compatibleMaterialsBool]&&messages,
		Download[mySamples,Object],
		{}
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* before resolving anything, we need to see if the user specified an injection table, and if they did, grab volumes to pass to the mapthread  *)
	specifiedInjectionTable=Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable];

	(* check if both Injection table AND NumberOfReplicates were specified. if they were, error out *)
	(* grab number of replicates *)
	specifiedNumberOfReplicates=Lookup[roundedCapillaryGelElectrophoresisSDSOptions,NumberOfReplicates];

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

	(* Informing volumes from the injection table runs the risk of it not being copacetic with specified samples/ladders/standards/blanks *)
	(* to avoid this breaking the mapthread, make sure ladders are copacetic, and if not, inform volume from sampleVolume *)
	injectionTableSamplesNotCopaceticQ=If[MatchQ[specifiedInjectionTable,Except[Automatic]],
		Not[And[
			ContainsAll[
				Cases[specifiedInjectionTable,{Sample,ObjectP[],VolumeP|Automatic}][[All,2]],
				Cases[mySamples,ObjectP[]]
			],
			ContainsAll[
				Cases[mySamples,ObjectP[]],
				Cases[specifiedInjectionTable,{Sample,ObjectP[],VolumeP|Automatic}][[All,2]]
			]
		]],
		False
	];

	injectionTableSampleVolumes=If[Not[injectionTableSamplesNotCopaceticQ]&&injectionTableValidQ,
		Switch[specifiedInjectionTable,
			{{_,ObjectP[],VolumeP|Automatic}..},Cases[specifiedInjectionTable,{Sample,ObjectP[],VolumeP|Automatic}][[All,3]],
			Automatic,ConstantArray[Automatic,Length[mySamples]]
		],
		(* If samples in injection tables dont match samplesIn, dont inform volume, we'll raise an error a bit later *)
		ToList[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SampleVolume]]
	];

	(* we need to account for a situation where the injection table is not in agreement with samplesIn and options.
	there is an error check later, but we want to make sure we dont break the MapThread *)
	injectionTableSampleVolumes=If[Length[injectionTableSampleVolumes]!=Length[mySamples],
		ConstantArray[Automatic,Length[mySamples]],
		injectionTableSampleVolumes
	];

	(* round volumes *)
	roundedInjectionTableSampleVolumes=RoundOptionPrecision[injectionTableSampleVolumes,10^-1Microliter];

	(* Before going into the mapThread, we need to resolve whether or not we need to centrifuge, to resolve supernatantvolumes *)
	centrifugationOptions={
		SedimentationCentrifugationSpeed,SedimentationCentrifugationForce,SedimentationCentrifugationTime,
		SedimentationCentrifugationTemperature,SedimentationSupernatantVolume} ;

	(*check if any of the centrifugation options are set*)
	includeCentrifugationOptionBool=Map[
		MatchQ[#,Except[Automatic|Null]]&,
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,centrifugationOptions]
	];

	(*resolve the IncludeLadder option based on the setting of the others*)
	resolvedIncludeCentrifugation=Which[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,PelletSedimentation],Except[Automatic]],
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,PelletSedimentation],
		Or@@includeCentrifugationOptionBool,True,
		True,False
	];

	(* Before going into the mapThread, we also need to resolve whether or not we need to incubate samples for denaturation *)
	incubationOptions={
		DenaturingTemperature,DenaturingTime,CoolingTemperature,CoolingTime
	};

	(*check if any of the centrifugation options are set*)
	includeIncubationOptionBool=Map[
		MatchQ[#,Except[Automatic|Null]]&,
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,incubationOptions]
	];

	(*resolve the IncludeLadder option based on the setting of the others*)
	resolvedIncludeIncubation=Which[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Denature],Except[Automatic]],
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Denature],
		Or@@includeIncubationOptionBool,True,
		True,False
	];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentCapillaryGelElectrophoresisSDS,roundedCapillaryGelElectrophoresisSDSOptions];

	(* MapThread over each of our samples. *)
	{
		(*1*)(* general option variables *)
		(*2*)resolvedSampleVolume,
		(*3*)resolvedSedimentationSupernatantVolume,
		(*4*)resolvedSeparationVoltageDurationProfile,
		(*10*)(* general option errors *)
		(*11*)missingSampleCompositionWarnings,
		(*12*)supernatantVolumeInvalidErrors,
		(*15*)(* premade mastermix branch variables *)
		resolvedPremadeMasterMix,
		(*16*)resolvedPremadeMasterMixVolume,
		(*17*)resolvedPremadeMasterMixReagentDilutionFactor,
		(*18*)resolvedPremadeMasterMixDiluent,
		(*19*)(* premade mastermix branch errors *)
		(*20*)premadeMasterMixNullErrors,
		(*21*)premadeMasterMixDilutionFactorNullErrors,
		(*22*)premadeMasterMixVolumeNullErrors,
		(*23*)premadeMasterMixVolumeDilutionFactorMismatchWarnings,
		(*24*)premadeMasterMixTotalVolumeErrors,
		premadeMasterMixDiluentNullErrors,
		(*25*)(* make-ones-own mastermix branch variables *)
		(*26*)resolvedInternalReference,
		(*27*)resolvedInternalReferenceDilutionFactor,
		(*28*)resolvedInternalReferenceVolume,
		(*29*)resolvedConcentratedSDSBuffer,
		(*30*)resolvedConcentratedSDSBufferDilutionFactor,
		(*31*)resolvedDiluent,
		(*32*)resolvedConcentratedSDSBufferVolume,
		(*33*)resolvedSDSBuffer,
		(*34*)resolvedSDSBufferVolume,
		(*35*)resolvedReduction,
		(*36*)resolvedReducingAgent,
		(*37*)resolvedReducingAgentTargetConcentration,
		(*38*)resolvedReducingAgentVolume,
		(*39*)resolvedAlkylation,
		(*40*)resolvedAlkylatingAgent,
		(*41*)resolvedAlkylatingAgentTargetConcentration,
		(*42*)resolvedAlkylatingAgentVolume,
		(*43*)(* make-ones-own mastermix branch errors *)
		(*44*)internalReferenceNullErrors,
		(*45*)internalReferenceDilutionFactorNullErrors,
		internalReferenceVolumeNullErrors,
		(*46*)internalReferenceVolumeDilutionFactorMismatchWarnings,
		(*47*)reducingAgentNullErrors,
		(*48*)noReducingAgentIdentifiedWarnings,
		(*49*)reducingAgentTargetConcentrationNullErrors,
		(*50*)reducingAgentVolumeNullErrors,
		(*51*)reducingAgentVolumeConcentrationMismatchErrors,
		(*52*)alkylatingAgentNullErrors,
		(*53*)noAlkylatingAgentIdentifiedWarnings,
		(*54*)alkylatingAgentTargetConcentrationNullErrors,
		(*55*)alkylatingAgentVolumeNullErrors,
		(*56*)alkylatingAgentVolumeConcentrationMismatchErrors,
		(*57*)sDSBufferNullErrors,
		(*58*)bothSDSBranchesSetWarnings,
		(*59*)concentratedSDSBufferDilutionFactorNullErrors,
		(*60*)notEnoughSDSinSampleWarnings,
		(*61*)volumeGreaterThanTotalVolumeErrors,
		(*62*)componentsDontSumToTotalVolumeErrors,
		(*63*)diluentNullErrors
	}=Transpose[MapThread[
		Function[{mySample,myMapThreadOptions,injectionTableSampleVolume},
			Module[
				{
					sampleVolume,premadeMasterMixVolume,premadeMasterMixDilutionFactor,separationVoltageDurationProfile,
					premadeMasterMixNullError,premadeMasterMixDilutionFactorNullError,
					internalReferenceNullError,internalReferenceDilutionFactorNullError,internalReferenceVolumeNullError,
					concentratedSDSBufferDilutionFactorNullError,
					diluentNullError,sDSBufferNullError,reducingAgentNullError,reducingAgentVolumeConcentrationMismatchError,
					reducingAgentTargetConcentrationNullError,reducingAgentVolumeNullError,alkylatingAgentNullError,alkylatingAgentTargetConcentrationNullError,
					alkylatingAgentVolumeConcentrationMismatchError,
					premadeMasterMixTotalVolumeError,missingSampleCompositionWarning,
					premadeMasterMixVolumeNullError,premadeMasterMixVolumeDilutionFactorMismatchWarning,internalReference,
					internalReferenceDilutionFactor,internalReferenceVolume,concentratedSDSBuffer,
					concentratedSDSBufferDilutionFactor,diluent,concentratedSDSBufferVolume,sDSBufferVolume,reducingAgent,
					reducingAgentTargetConcentration,reducingAgentVolume,alkylatingAgent,alkylatingAgentTargetConcentration,
					alkylatingAgentVolume,internalReferenceVolumeDilutionFactorMismatchWarning,reduction,alkylation,noReducingAgentIdentifiedWarning,
					alkylatingAgentVolumeNullError,alkylatingAgentIdentifiedWarning,sDSBuffer,bothSDSBranchesSetWarning,
					volumeGreaterThanTotalVolumeError,componentsDontSumToTotalVolumeError,supernatantVolume,supernatantVolumeInvalidError,
					notEnoughSDSinSampleWarning,preMadeMasterMixOptions,
					includePremadeMasterMixBool,resolvePremadeMasterMix,premadeMasterMixDiluentNullError
				},
				(* Setup error tracking variables *)
				{
					missingSampleCompositionWarning,
					premadeMasterMixNullError,
					premadeMasterMixDilutionFactorNullError,
					premadeMasterMixDiluentNullError,
					internalReferenceNullError,
					internalReferenceDilutionFactorNullError,
					internalReferenceVolumeNullError,
					reducingAgentNullError,
					reducingAgentVolumeConcentrationMismatchError,
					reducingAgentTargetConcentrationNullError,
					reducingAgentVolumeNullError,
					alkylatingAgentNullError,
					alkylatingAgentTargetConcentrationNullError,
					alkylatingAgentVolumeConcentrationMismatchError,
					premadeMasterMixTotalVolumeError,
					noReducingAgentIdentifiedWarning,
					alkylatingAgentNullError,
					alkylatingAgentTargetConcentrationNullError,
					alkylatingAgentVolumeNullError,
					alkylatingAgentIdentifiedWarning,
					sDSBufferNullError,
					bothSDSBranchesSetWarning,
					concentratedSDSBufferDilutionFactorNullError,
					volumeGreaterThanTotalVolumeError,
					componentsDontSumToTotalVolumeError,
					diluentNullError,
					supernatantVolumeInvalidError,
					notEnoughSDSinSampleWarning
				}=ConstantArray[False,28];

				(* Resolve SampleVolume *)
				sampleVolume=Which[
					MatchQ[Lookup[myMapThreadOptions,SampleVolume],Except[Automatic]],
					(* if informed, use it *)
					Lookup[myMapThreadOptions,SampleVolume],
					(* if not informed, check if there's a value in the injection table *)
					MatchQ[injectionTableSampleVolume,VolumeP],
					injectionTableSampleVolume,
					(* if not informed, pull out composition and resolve volume to reach 1 mg/ml in total volume*)
					True,
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
							(1 Milligram/Milliliter*Lookup[myMapThreadOptions,TotalVolume])/Total[proteinConcentration],
							(*otherwise, return volume that is 25% of the TotalVolume and raise warning *)
							missingSampleCompositionWarning=True;
							Lookup[myMapThreadOptions,TotalVolume]*0.25];
						Convert[RoundOptionPrecision[calculatedVolume,10^-1 Microliter,AvoidZero->True],Microliter]
					]
				];

				(* check if PremadeMasterMix should be True *)
				preMadeMasterMixOptions={
					PremadeMasterMixReagent,PremadeMasterMixDiluent,PremadeMasterMixReagentDilutionFactor,PremadeMasterMixVolume
				};

				includePremadeMasterMixBool=Map[
					MatchQ[#,Except[Automatic|Null|False]]&,
					Lookup[myMapThreadOptions,preMadeMasterMixOptions]
				];

				resolvePremadeMasterMix=Which[
					MatchQ[Lookup[myMapThreadOptions,PremadeMasterMix],Except[Automatic]],
					Lookup[myMapThreadOptions,PremadeMasterMix],
					(* if a standard is specified in the injection table *)
					Or@@includePremadeMasterMixBool,True,
					True,False
				];
				(* PremadeMasterMix split to two branches *)
				{
					(*1*)(* premade mastermix branch variables *)
					(*2*)premadeMasterMixVolume,
					(*3*)premadeMasterMixDilutionFactor,
					(*4*)premadeMasterMixDiluent,
					(*5*)(* premade mastermix branch errors *)
					(*6*)premadeMasterMixNullError,
					(*7*)premadeMasterMixDilutionFactorNullError,
					(*8*)premadeMasterMixVolumeNullError,
					(*9*)premadeMasterMixVolumeDilutionFactorMismatchWarning,
					(*10*)premadeMasterMixTotalVolumeError,
					premadeMasterMixDiluentNullError,
					(*11*)(* make-ones-own mastermix branch variables *)
					(*12*)internalReference,
					(*13*)internalReferenceDilutionFactor,
					(*14*)internalReferenceVolume,
					(*15*)concentratedSDSBuffer,
					(*16*)concentratedSDSBufferDilutionFactor,
					(*17*)diluent,
					(*18*)concentratedSDSBufferVolume,
					(*19*)sDSBuffer,
					(*20*)sDSBufferVolume,
					(*21*)reduction,
					(*22*)reducingAgent,
					(*23*)reducingAgentTargetConcentration,
					(*24*)reducingAgentVolume,
					(*25*)alkylation,
					(*26*)alkylatingAgent,
					(*27*)alkylatingAgentTargetConcentration,
					(*28*)alkylatingAgentVolume,
					(*29*)(* make-ones-own mastermix branch variables *)
					(*30*)internalReferenceNullError,
					(*31*)internalReferenceDilutionFactorNullError,
					internalReferenceVolumeNullError,
					(*32*)internalReferenceVolumeDilutionFactorMismatchWarning,
					(*33*)reducingAgentNullError,
					(*34*)noReducingAgentIdentifiedWarning,
					(*35*)reducingAgentTargetConcentrationNullError,
					(*36*)reducingAgentVolumeNullError,
					(*37*)reducingAgentVolumeConcentrationMismatchError,
					(*38*)alkylatingAgentNullError,
					(*39*)noAlkylatingAgentIdentifiedWarning,
					(*40*)alkylatingAgentTargetConcentrationNullError,
					(*41*)alkylatingAgentVolumeNullError,
					(*42*)alkylatingAgentVolumeConcentrationMismatchError,
					(*43*)sDSBufferNullError,
					(*44*)bothSDSBranchesSetWarning,
					(*45*)concentratedSDSBufferDilutionFactorNullError,
					(*46*)notEnoughSDSinSampleWarning,
					(*47*)volumeGreaterThanTotalVolumeError,
					(*48*)componentsDontSumToTotalVolumeError,
					(*49*)diluentNullError
				}=If[MatchQ[resolvePremadeMasterMix,True],
					(* PremadeMasterMix, no need to get specific reagents *)
					Module[
						{
							masterMixNullError,masterMixDilutionFactorNullError,masterMixVolume,masterMixVolumeNullError,
							masterMixVolumeDilutionFactorMismatchWarning,masterMixTotalVolumeError,totalVolume,mixReagent,mixVolume,
							mixDilutionFactor,masterMixDilutionFactor,masterMixDiluent,masterMixDiluentNullError
						},
						(* gather options *)
						totalVolume=Lookup[myMapThreadOptions,TotalVolume];
						mixReagent=Lookup[myMapThreadOptions,PremadeMasterMixReagent];
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
						}=If[Not[masterMixNullError],
							Switch[mixVolume,
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
								{mixVolume,mixDilutionFactor/.Automatic:>(totalVolume/mixVolume),
									False,False,mixVolume=!=(totalVolume/(mixDilutionFactor/.Automatic:>(totalVolume/mixVolume)))}],
								(* if automatic, make sure DilutionFactor is informed and calculate volume*)
								Automatic,If[
								NullQ[mixDilutionFactor],
								{Null,Null,
									False,True,False},
								{(totalVolume/mixDilutionFactor/.Automatic:>2),mixDilutionFactor/.Automatic:>2,
									False,False,False}]
							],
							{
								mixVolume/.Automatic:>Null,mixDilutionFactor/.Automatic:>Null,
								False,False,False
							}
						];

						masterMixTotalVolumeError=If[Not[Or[masterMixNullError,masterMixVolumeNullError]],
							(sampleVolume+masterMixVolume)>totalVolume,
							False];

						masterMixDiluent=Lookup[myMapThreadOptions,PremadeMasterMixDiluent]/.Automatic:>Model[Sample,"Milli-Q water"];
						(* if masterMix Diluent is Null but no need to top off to total volume, dont raise an error, otherwise raise an error *)
						masterMixDiluentNullError=((totalVolume-sampleVolume-masterMixVolume)>0Microliter)&&MatchQ[masterMixDiluent,Null];


						(* Gather all resolved options and errors to return *)
						{
							(*1*)masterMixVolume,
							(*2*)masterMixDilutionFactor,
							(*3*)masterMixDiluent,
							(*4*)masterMixNullError,
							(*5*)masterMixDilutionFactorNullError,
							(*6*)masterMixVolumeNullError,
							(*7*)masterMixVolumeDilutionFactorMismatchWarning,
							(*8*)masterMixTotalVolumeError,
							masterMixDiluentNullError,
							(*9*)(* other branch's options as Null *)
							(*10*)Lookup[myMapThreadOptions,InternalReference]/.Automatic:>Null,
							(*11*)Lookup[myMapThreadOptions,InternalReferenceDilutionFactor]/.Automatic:>Null,
							(*12*)Lookup[myMapThreadOptions,InternalReferenceVolume]/.Automatic:>Null,
							(*13*)Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
							(*14*)Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
							(*15*)Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null,
							(*16*)Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
							(*17*)Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
							(*18*)Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null,
							(*19*)Lookup[myMapThreadOptions,Reduction]/.Automatic:>True,(* Assume reducing conditions if using mastermix for longer run.. *)
							(*20*)Lookup[myMapThreadOptions,ReducingAgent]/.Automatic:>Null,
							(*21*)Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null,
							(*22*)Lookup[myMapThreadOptions,ReducingAgentVolume]/.Automatic:>Null,
							(*23*)Lookup[myMapThreadOptions,Alkylation]/.Automatic:>False,
							(*24*)Lookup[myMapThreadOptions,AlkylatingAgent]/.Automatic:>Null,
							(*25*)Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null,
							(*26*)Lookup[myMapThreadOptions,AlkylatingAgentVolume]/.Automatic:>Null,
							(*27*)(* Other branch's errors as False *)
							(*28*)False,(* intReferenceNullError *)
							(*29*)False,(* intReferenceDilutionFactorNullError *)
							False,(* intReferenceVolumeNullError *)
							(*30*)False,(* intReferenceVolumeDilutionFactorMismatchWarning *)
							(*31*)False,(* mixReducingAgentNullError *)
							(*32*)False,(* mixNoReducingAgentIdentifiedWarning *)
							(*33*)False,(* mixReducingAgentTargetConcentrationNullError *)
							(*34*)False,(* mixReducingAgentVolumeNullError *)
							(*35*)False,(* mixReducingAgentVolumeConcentrationMismatchError *)
							(*36*)False,(* mixAlkylatingAgentNullError *)
							(*37*)False,(* mixNoAlkylatingAgentIdentifiedWarning *)
							(*38*)False,(* mixAlkylatingAgentTargetConcentrationNullError *)
							(*39*)False,(* mixAlkylatingAgentVolumeNullError *)
							(*40*)False,(* mixAlkylatingAgentVolumeConcentrationMismatchError *)
							(*41*)False,(* mixSDSBufferNullError *)
							(*42*)False,(* mixBothSDSBranchesSetWarning *)
							(*43*)False,(* mixConcentratedSDSBufferDilutionFactorNullError *)
							(*44*)False,(* mixNotEnoughSDSinSampleWarnin *)
							(*45*)False,(* mixVolumeGreaterThanTotalVolumeError *)
							(*46*)False,(* mixComponentsDontSumToTotalVolumeError *)
							(*47*)False (* mixDiluentNullError *)
						}
					],
					(* no PremadeMasterMix, make your own mastermix *)
					Module[
						{
							totalVolume,mixDiluent,mixInternalReference,
							mixInternalReferenceDilutionFactor,mixInternalReferenceVolume,mixConcentratedSDSBuffer,
							mixConcentratedSDSBufferDilutionFactor,mixConcentratedSDSBufferVolume,mixSDSBufferVolume,
							mixReducingAgent,mixReducingAgentTargetConcentration,mixReducingAgentVolume,mixAlkylatingAgent,
							mixAlkylatingAgentTargetConcentration,mixAlkylatingAgentVolume,intReferenceNullError,intReferenceDilutionFactorNullError,
							intReferenceVolumeDilutionFactorMismatchWarning,reductionOptions,includeReductionOptionBool,
							mixReduction,mixAlkylation,mixReducingAgentNullError,tcep,bme,dtt,ian,alkylationOptions,
							includeAlkylationOptionBool,identifyAlkylatingAgent,
							mixReducingAgentTargetConcentrationNullError,mixReducingAgentVolumeNullError,
							mixReducingAgentVolumeConcentrationMismatchError,mixNoReducingAgentIdentifiedWarning,
							mixAlkylatingAgentNullError,mixNoAlkylatingAgentIdentifiedWarning,
							mixAlkylatingAgentTargetConcentrationNullError,mixAlkylatingAgentVolumeNullError,
							mixAlkylatingAgentVolumeConcentrationMismatchError,mixConcentratedSDSBufferDilutionFactorNullError,
							mixVolumeGreaterThanTotalVolumeError,mixDiluentNullError,mixSDSBuffer,mixComponentsDontSumToTotalVolumeError,
							mixSDSBufferNullError,mixBothSDSBranchesSetWarning,volumeLeft,mixConcentratedSDSBool,mixSDSBool,
							resolveMixConcentratedSDSBuffer,resolveMixConcentratedSDSBufferVolume,resolveMixConcentratedSDSBufferDilutionFactor,
							resolveMixConcentratedSDSBufferDilutionFactorNullError,resolveMixSDSBuffer,resolveMixSDSBufferVolume,
							sdsBufferUserDefinedBool,concentratedSDSUserDefinedBool,sampleSDSBuffer,sampleBufferCompositionIDs,identifySDS,
							sds,sdsObject,bufferVolume,mixNotEnoughSDSinSampleWarning,intReferenceVolumeNullError
						},
						totalVolume=Lookup[myMapThreadOptions,TotalVolume];

						(* Check if internalReference is informed, if not raise error *)
						{
							intReferenceNullError,
							mixInternalReference
						}=Switch[Lookup[myMapThreadOptions,InternalReference],
							Automatic,{False,Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"]},
							Null,{True,Null},
							ObjectP[],{False,Lookup[myMapThreadOptions,InternalReference]}
						];

						(* resolve InternalReference Volume *)
						{
							intReferenceDilutionFactorNullError,
							intReferenceVolumeNullError,
							mixInternalReferenceDilutionFactor,
							mixInternalReferenceVolume
						}=Switch[Lookup[myMapThreadOptions,InternalReferenceVolume],
							VolumeP,
							{False,False,Lookup[myMapThreadOptions,InternalReferenceDilutionFactor]/.Automatic:>totalVolume/Lookup[myMapThreadOptions,InternalReferenceVolume],Lookup[myMapThreadOptions,InternalReferenceVolume]},
							Null,
							{False,True,Lookup[myMapThreadOptions,InternalReferenceDilutionFactor]/.Automatic:>25,Lookup[myMapThreadOptions,InternalReferenceVolume]},
							(* If InternalReferenceDilutionFactor is automatic, set to 25 (based on ProteinSimple standard) otherwise check if null and raise an error or use given value *)
							Automatic,
							Switch[Lookup[myMapThreadOptions,InternalReferenceDilutionFactor],
								Null,
								{True,False,Null,Null},
								Automatic,
								{False,False,25,RoundOptionPrecision[totalVolume/25,10^-1Microliter]},
								GreaterP[0],
								{False,False,Lookup[myMapThreadOptions,InternalReferenceDilutionFactor],
									totalVolume/Lookup[myMapThreadOptions,InternalReferenceDilutionFactor]}
							]
						];

						(* if both dilution factor and volume are given, check that they concur *)
						intReferenceVolumeDilutionFactorMismatchWarning=If[NullQ[mixInternalReferenceDilutionFactor]||NullQ[mixInternalReferenceVolume],
							False,
							Abs[mixInternalReferenceVolume-(totalVolume/mixInternalReferenceDilutionFactor)]>0.1Microliter
						];

						(* resolve reduction *)
						reductionOptions={ReducingAgent,ReducingAgentTargetConcentration,ReducingAgentVolume};
						(*check if any of the reduction options are set*)
						includeReductionOptionBool=Map[
							MatchQ[#,Except[Automatic|Null]]&,
							Lookup[myMapThreadOptions,reductionOptions]
						];
						(*resolve the Reduction option based on the setting of the others*)
						mixReduction=Which[
							MatchQ[Lookup[myMapThreadOptions,Reduction],Except[Automatic]],
							Lookup[myMapThreadOptions,Reduction],
							Or@@includeReductionOptionBool,True,
							True,False
						];

						(* if mixReduction is True, resolve related options *)

						{
							mixReducingAgent,
							mixReducingAgentVolume,
							mixReducingAgentTargetConcentration,
							mixReducingAgentNullError,
							mixNoReducingAgentIdentifiedWarning,
							mixReducingAgentTargetConcentrationNullError,
							mixReducingAgentVolumeNullError,
							mixReducingAgentVolumeConcentrationMismatchError
						}=If[mixReduction,
							Module[
								{reducingAgentIdentity,resolveMixReducingAgentNullError,resolveMixReducingAgent,
									resolveMixNoReducingAgentIdentifiedWarning,resolveMixReducingAgentTargetConcentrationNullError,
									resolveMixReducingAgentVolumeNullError,resolveMixReducingAgentTargetConcentration,resolveMixReducingAgentVolume,
									resolveMixReducingAgentVolumeConcentrationMismatchError,targetConcentrationByID
								},
								(* resolve ReducingAgent object *)
								{
									resolveMixReducingAgentNullError,
									resolveMixReducingAgent
								}=Switch[Lookup[myMapThreadOptions,ReducingAgent],
									Automatic,{False,Model[Sample,"2-Mercaptoethanol"]},
									Null,{True,Null},
									_,{False,Lookup[myMapThreadOptions,ReducingAgent]}
								];

								(* to resolve mixReducingAgentTargetConcentration below, need to know which agent is used *)
								reducingAgentIdentity=If[!resolveMixReducingAgentNullError,
									Module[
										{reducingAgentPacket,reducingAgentComposition,reducingAgentCompositionIDs,
											reducingAgentCompositionPackets,identifyReducingAgent},
										reducingAgentPacket=fetchPacketFromCache[Download[resolveMixReducingAgent,Object],optionObjectModelPackets];
										reducingAgentComposition=Lookup[reducingAgentPacket,Composition];
										(* construct list with concentration and molecule composition *)
										reducingAgentCompositionPackets=Map[
											Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
											reducingAgentComposition];
										(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
										reducingAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@reducingAgentCompositionPackets;

										(* Identifiers for DTT,TCEP, and BME based on CAS, synonyms, and InChI *)
										{
											tcep,
											bme,
											dtt
										}={
											{"51805-45-9","Tris(2-carboxyethyl)phosphine hydrochloride","TCEP","TCEP hydrochloride","Tris(2-carboxyethyl)phosphine",
												"InChI=1S/C9H15O6P/c10-7(11)1-4-16(5-2-8(12)13)6-3-9(14)15/h1-6H2,(H,10,11)(H,12,13)(H,14,15)","PZBFGYYEXUXCOF-UHFFFAOYSA-N",
												"InChI=1/C9H15O6P/c10-7(11)1-4-16(5-2-8(12)13)6-3-9(14)15/h1-6H2,(H,10,11)(H,12,13)(H,14,15)","PZBFGYYEXUXCOF-UHFFFAOYAQ"},
											{"60-24-2","2-Mercaptoethanol","2Mercaptoethanol","BME","beta-mercaptoethanol","betamercaptoethanol","Mercaptoethanol",
												"InChI=1S/C2H6OS/c3-1-2-4/h3-4H,1-2H2","DGVVWUTYPXICAM-UHFFFAOYSA-N","2-Thioethanol","Thioglycol","Thioethylene glycol"},
											{"3483-12-3","DTT","1,4-Dithiothreitol ","DL-Dithiothreitol","D,L-Dithiothreitol","Dithiothreitol","Cleland's reagent",
												"1S/C4H10O2S2/c5-3(1-7)4(6)2-8/h3-8H,1-2H2","VHJLVAABSRFDPM-UHFFFAOYSA-N"}
										};
										(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
										(* Note - this assumes a single reducing agent in the sample; if more, user will need to specify volume *)

										identifyReducingAgent=Map[
											Function[compositionMolecule,
												{
													compositionMolecule[[1]] (* ObjectID *),
													compositionMolecule[[2]] (* Concentration *),
													Which[
														ContainsAny[compositionMolecule[[3]],tcep],"TCEP",
														ContainsAny[compositionMolecule[[3]],bme],"BME",
														ContainsAny[compositionMolecule[[3]],dtt],"DTT"
													]
												}
											],
											reducingAgentCompositionIDs];

										(* pick out cases where the second index in teh list is not null *)
										Cases[identifyReducingAgent,{ObjectP[],_,Except[NullP]}]
									],
									{}];

								(* raise error if no reducing agents or more than one reducing agents were identified *)
								resolveMixNoReducingAgentIdentifiedWarning=If[!resolveMixReducingAgentNullError,
									Length[reducingAgentIdentity]=!=1,
									False];

								(* BME is a liquid, so we need to handle volumePercent, others should be okay with molarity (unless they are in MassPercent, which this does not support at the moment) *)
								targetConcentrationByID=Which[
									Or[resolveMixNoReducingAgentIdentifiedWarning,resolveMixReducingAgentNullError],Null,
									StringMatchQ[reducingAgentIdentity[[1]][[3]],"TCEP"|"DTT"],50 Millimolar,
									StringMatchQ[reducingAgentIdentity[[1]][[3]],"BME"],
									If[MatchQ[QuantityUnit[reducingAgentIdentity[[1]][[2]]],IndependentUnit["VolumePercent"]],
										(* stock concentration given in volumePercent *)
										4.54545VolumePercent,
										(* Stock Concentration is in Millimolar (As it really should be, even if we're dealing with a liquid) *)
										650 Millimolar],
									True,Null
								];

								(* resolve ReducingAgentVolume *)
								{
									resolveMixReducingAgentTargetConcentrationNullError,
									resolveMixReducingAgentVolumeNullError,
									resolveMixReducingAgentTargetConcentration,
									resolveMixReducingAgentVolume
									(* first check if the reducing agent was null, if it was, just skip checking the previous error is enough *)
								}=Which[
									resolveMixReducingAgentNullError,
									{False,False,
										Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,ReducingAgentVolume]/.Automatic:>Null},
									(* if no identified reducing Agent, still see if there's a valid volume before rasing other errors *)
									NullQ[targetConcentrationByID],
									Switch[Lookup[myMapThreadOptions,ReducingAgentVolume],
										VolumeP,
										{
											False,False,
											Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,ReducingAgentVolume]
										},
										Except[VolumeP],
										{NullQ[Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null],NullQ[Lookup[myMapThreadOptions,ReducingAgentVolume]/.Automatic:>Null],
											Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,ReducingAgentVolume]/.Automatic:>Null}
									],
									(* if reducingAgentID has a single value, go on.. *)
									!NullQ[targetConcentrationByID],
									Switch[Lookup[myMapThreadOptions,ReducingAgentVolume],
										Null,
										{
											False,True,
											Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>targetConcentrationByID,Null
										},
										VolumeP,
										{
											False,False,
											Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>reducingAgentIdentity[[1]][[2]]*RoundOptionPrecision[Lookup[myMapThreadOptions,ReducingAgentVolume],10^-1Microliter]/totalVolume,
											RoundOptionPrecision[Lookup[myMapThreadOptions,ReducingAgentVolume],10^-1Microliter]
										},
										(* If ReducingAgentTargetConcentration is automatic, set to value based on specified reducing agent; otherwise
											check if null, raise an error or use given value *)
										Automatic,
										Switch[Lookup[myMapThreadOptions,ReducingAgentTargetConcentration],
											Null,
											{
												True,False,Null,Null
											},
											Automatic,
											(* if possible, resolve based on the reducing agent: BME 650mM, DTT 50 mM, TCEP 50 mM *)
											If[Not[resolveMixNoReducingAgentIdentifiedWarning],
												{
													False,False,
													Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>targetConcentrationByID,
													RoundOptionPrecision[(targetConcentrationByID*totalVolume/reducingAgentIdentity[[1]][[2]]),10^-1Microliter]
												},
												(* no reducing agent was identified, can't calculate must get volume *)
												{
													True,False,Null,Null
												}
											],
											Except[Null|Automatic],
											If[Not[resolveMixNoReducingAgentIdentifiedWarning],
												(* TargetConcentration set, and reagent concenteration found *)
												{
													False,False,
													Lookup[myMapThreadOptions,ReducingAgentTargetConcentration],
													RoundOptionPrecision[(Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]*totalVolume/reducingAgentIdentity[[1]][[2]]),10^-1 Microliter,AvoidZero->True]
												},
												(* cant get the reducing agent concentration from object model, can't calculate volume *)
												{
													False,True,Null,Null
												}
											]
										]
									]];
								(* if both dilution factor and volume are resolved or set, and the reagents concentration is known, check that they concur *)
								resolveMixReducingAgentVolumeConcentrationMismatchError=If[
									Not[Or@@(NullQ[#]&/@{resolveMixReducingAgentTargetConcentration,resolveMixReducingAgentVolume})]&&Not[resolveMixNoReducingAgentIdentifiedWarning],
									Abs[resolveMixReducingAgentVolume-resolveMixReducingAgentTargetConcentration*totalVolume/reducingAgentIdentity[[1]][[2]]]>0.1Microliter,
									False
								];

								(* return resolved options *)
								{
									resolveMixReducingAgent,
									resolveMixReducingAgentVolume,
									resolveMixReducingAgentTargetConcentration,
									resolveMixReducingAgentNullError,
									resolveMixNoReducingAgentIdentifiedWarning,
									resolveMixReducingAgentTargetConcentrationNullError,
									resolveMixReducingAgentVolumeNullError,
									resolveMixReducingAgentVolumeConcentrationMismatchError
								}
							],
							(* If reduction is false, return nulls*)
							{
								Lookup[myMapThreadOptions,ReducingAgent]/.Automatic:>Null,(* resolveMixReducingAgent *)
								Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null,(* resolveMixReducingAgentVolume *)
								Lookup[myMapThreadOptions,ReducingAgentVolume]/.Automatic:>Null,(* resolveMixReducingAgentTargetConcentration *)
								False,(* resolveMixReducingAgentNullError *)
								False,(* resolveMixNoReducingAgentIdentifiedWarning *)
								False,(* resolveMixReducingAgentTargetConcentrationNullError *)
								False,(* resolveMixReducingAgentVolumeNullError *)
								False (* resolveMixReducingAgentVolumeConcentrationMismatchError *)
							}
						];


						(* resolve Alkylation *)
						alkylationOptions={AlkylatingAgent,AlkylatingAgentTargetConcentration,AlkylatingAgentVolume};
						(*check if any of the alkylation options are set*)
						includeAlkylationOptionBool=Map[
							MatchQ[#,Except[Automatic|Null]]&,
							Lookup[myMapThreadOptions,alkylationOptions]
						];
						(*resolve the Alkylation option based on the setting of the others*)
						mixAlkylation=Which[
							MatchQ[Lookup[myMapThreadOptions,Alkylation],Except[Automatic]],
							Lookup[myMapThreadOptions,Alkylation],
							Or@@includeAlkylationOptionBool,True,
							True,False
						];

						(* if mixReduction is True, resolve related options *)
						{
							mixAlkylatingAgent,
							mixAlkylatingAgentVolume,
							mixAlkylatingAgentTargetConcentration,
							mixAlkylatingAgentNullError,
							mixNoAlkylatingAgentIdentifiedWarning,
							mixAlkylatingAgentTargetConcentrationNullError,
							mixAlkylatingAgentVolumeNullError,
							mixAlkylatingAgentVolumeConcentrationMismatchError
						}=If[mixAlkylation,
							Module[{alkylatingAgentIdentity,resolveMixAlkylatingAgentNullError,resolveMixAlkylatingAgent,
								resolveMixNoAlkylatingAgentIdentifiedWarning,resolveMixAlkylatingAgentTargetConcentrationNullError,
								resolveMixAlkylatingAgentVolumeNullError,resolveMixAlkylatingAgentTargetConcentration,resolveMixAlkylatingAgentVolume,
								resolveMixAlkylatingAgentVolumeConcentrationMismatchError,targetConcentrationByID
							},
								(* resolve AlkylatingAgent object *)
								{
									resolveMixAlkylatingAgentNullError,
									resolveMixAlkylatingAgent
								}=Switch[Lookup[myMapThreadOptions,AlkylatingAgent],
									Automatic,{False,Model[Sample,StockSolution,"250mM Iodoacetamide"]},
									Null,{True,Null},
									_,{False,Lookup[myMapThreadOptions,AlkylatingAgent]}
								];

								(* to resolve mixAlkylatingAgentTargetConcentration below, need to know which agent is used *)
								alkylatingAgentIdentity=If[!resolveMixAlkylatingAgentNullError,
									Module[
										{alkylatingAgentPacket,alkylatingAgentComposition,alkylatingAgentCompositionIDs,alkylatingAgentCompositionPackets},
										alkylatingAgentPacket=fetchPacketFromCache[Download[resolveMixAlkylatingAgent,Object],optionObjectModelPackets];
										alkylatingAgentComposition=Lookup[alkylatingAgentPacket,Composition];
										(* construct list with concentration and molecule composition *)
										alkylatingAgentCompositionPackets=Map[
											Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
											alkylatingAgentComposition];
										(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
										alkylatingAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@alkylatingAgentCompositionPackets;

										(* Identifiers for IAP based on CAS, synonyms, and InChI *)
										{
											ian
										}={
											{"144-48-9","IAN","2-Iodoacetamide","Iodoacetamide","Iodoacetamide","Monoiodoacetamide","alpha-Iodoacetamide","InChI=1S/C2H4INO/c3-1-2(4)5/h1H2,(H2,4,5)",
												"PGLTVOMIXTUURA-UHFFFAOYSA-N"}
										};
										(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
										(* Note - this assumes a single alkylating agent in the sample; if more, user will need to specify volume *)

										identifyAlkylatingAgent=Map[
											Function[compositionMolecule,
												{
													compositionMolecule[[1]] (* ObjectID *),
													compositionMolecule[[2]] (* Concentration *),
													Which[
														ContainsAny[compositionMolecule[[3]],ian],"IAN"
													]
												}
											],
											alkylatingAgentCompositionIDs];

										(* pick out cases where the second index in teh list is not null *)
										Cases[identifyAlkylatingAgent,{ObjectP[],_,Except[NullP]}]
									],
									{}];


								(* raise error if no or more than one alkylating agents were identified *)
								resolveMixNoAlkylatingAgentIdentifiedWarning=If[!resolveMixAlkylatingAgentNullError,
									Length[alkylatingAgentIdentity]=!=1,
									False];

								(* resolve AlkylatingAgentVolume *)
								targetConcentrationByID=Which[
									Or[resolveMixNoAlkylatingAgentIdentifiedWarning,resolveMixAlkylatingAgentNullError],Null,
									StringMatchQ[alkylatingAgentIdentity[[1]][[3]],"IAN"],11.5 Millimolar,
									True,Null
								];

								{
									resolveMixAlkylatingAgentTargetConcentrationNullError,
									resolveMixAlkylatingAgentVolumeNullError,
									resolveMixAlkylatingAgentTargetConcentration,
									resolveMixAlkylatingAgentVolume
								}=Which[
									resolveMixAlkylatingAgentNullError,
									{False,False,
										Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,AlkylatingAgentVolume]/.Automatic:>Null},
									(* if no identified alkylating Agent, still see if there's a valid volume before rasing other errors *)
									NullQ[targetConcentrationByID],
									Switch[Lookup[myMapThreadOptions,AlkylatingAgentVolume],
										VolumeP,
										{
											False,False,
											Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,AlkylatingAgentVolume]
										},
										Except[VolumeP],
										{NullQ[Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null],NullQ[Lookup[myMapThreadOptions,AlkylatingAgentVolume]/.Automatic:>Null],
											Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,AlkylatingAgentVolume]/.Automatic:>Null}
									],
									(* if alkylatingAgentID has a single value, go on.. *)
									!NullQ[targetConcentrationByID],
									Switch[Lookup[myMapThreadOptions,AlkylatingAgentVolume],
										Null,
										{
											False,True,
											Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>targetConcentrationByID,Null
										},
										VolumeP,
										{
											False,False,
											Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>alkylatingAgentIdentity[[1]][[2]]*RoundOptionPrecision[Lookup[myMapThreadOptions,AlkylatingAgentVolume],10^-1Microliter]/totalVolume,
											RoundOptionPrecision[Lookup[myMapThreadOptions,AlkylatingAgentVolume],10^-1Microliter]
										},
										(* If AlkylatingAgentTargetConcentration is automatic, set to value based on specified reducing agent; otherwise
											check if null, raise an error or use given value *)
										Automatic,
										Switch[Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration],
											Null,
											{
												True,True,Null,Null
											},
											Automatic,
											(* if possible, resolve based on the alkylating *)
											If[Not[resolveMixNoAlkylatingAgentIdentifiedWarning],
												{
													False,False,
													Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>targetConcentrationByID,
													RoundOptionPrecision[(targetConcentrationByID*totalVolume/alkylatingAgentIdentity[[1]][[2]]),10^-1Microliter]
												},
												(* no alkylating agent was identified, can't calculate must get volume *)
												{
													False,True,Null,Null
												}
											],
											Except[Null|Automatic],
											If[Not[resolveMixNoAlkylatingAgentIdentifiedWarning],
												(* TargetConcentration set, and reagent concenteration found *)
												{
													False,False,
													Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration],
													RoundOptionPrecision[(Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]*totalVolume/alkylatingAgentIdentity[[1]][[2]]),10^-1 Microliter,AvoidZero->True]
												},
												(* cant get the reducing agent concentration from object model, can't calculate volume *)
												{
													False,True,Null,Null
												}
											]
										]
									]];

								(* if both TragetConcentration and volume are resolved or set, and the reagents concentration is known, check that they concur *)
								resolveMixAlkylatingAgentVolumeConcentrationMismatchError=If[
									Not[Or@@(NullQ[#]&/@{resolveMixAlkylatingAgentTargetConcentration,resolveMixAlkylatingAgentVolume})]&&Not[resolveMixNoAlkylatingAgentIdentifiedWarning],
									Abs[resolveMixAlkylatingAgentVolume-resolveMixAlkylatingAgentTargetConcentration*totalVolume/alkylatingAgentIdentity[[1]][[2]]]>0.1Microliter,
									False
								];
								(* return resolved options *)
								{
									resolveMixAlkylatingAgent,
									resolveMixAlkylatingAgentVolume,
									resolveMixAlkylatingAgentTargetConcentration,
									resolveMixAlkylatingAgentNullError,
									resolveMixNoAlkylatingAgentIdentifiedWarning,
									resolveMixAlkylatingAgentTargetConcentrationNullError,
									resolveMixAlkylatingAgentVolumeNullError,
									resolveMixAlkylatingAgentVolumeConcentrationMismatchError
								}
							],
							(* If alkylation is false, return nulls*)
							{
								Lookup[myMapThreadOptions,AlkylatingAgent]/.Automatic:>Null,(* resolveMixAlkylatingAgent *)
								Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null,(* resolveMixAlkylatingAgentVolume *)
								Lookup[myMapThreadOptions,AlkylatingAgentVolume]/.Automatic:>Null,(* resolveMixAlkylatingAgentTargetConcentration *)
								False,(* resolveMixAlkylatingAgentNullError *)
								False,(* resolveMixNoAlkylatingAgentIdentifiedWarning *)
								False,(* resolveMixAlkylatingAgentTargetConcentrationNullError *)
								False,(* resolveMixAlkylatingAgentVolumeNullError *)
								False (* resolveMixAlkylatingAgentVolumeConcentrationMismatchError *)
							}
						];

						(* Resolve ConcentratedSDSBuffer vs SDS Buffer *)
						{
							(* concentratedSDSBuffer branch *)
							resolveMixConcentratedSDSBuffer,
							resolveMixConcentratedSDSBufferVolume,
							resolveMixConcentratedSDSBufferDilutionFactor,
							resolveMixConcentratedSDSBufferDilutionFactorNullError
						}=If[MatchQ[Lookup[myMapThreadOptions,ConcentratedSDSBuffer],Except[Null]],
							Switch[Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume],
								(* If ConcentratedSDSBufferVolume is set to value or null, use it *)
								VolumeP,
								{
									Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
									Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume],
									Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>N[totalVolume/Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]],
									False
								},
								Automatic,
								If[MatchQ[Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor],Except[Null]],
									(* Dilution factor is informed or automatic. default value is 2X *)
									{
										Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
										RoundOptionPrecision[totalVolume/(Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>2),10^-1 Microliter,AvoidZero->True],
										Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>2,
										False
									},
									{
										Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
										Null,
										Null,
										True
									}],
								Null,
								{
									Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
									Null,
									Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
									False
								}],
							(* ConcentratedSDSBuffer unresolvable *)
							{
								Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
								Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
								Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
								False
							}];

						(* in order to calculate how much volume needs to be added *)
						volumeLeft=RoundOptionPrecision[totalVolume-Total[ReplaceAll[{sampleVolume,mixInternalReferenceVolume,mixReducingAgentVolume,mixAlkylatingAgentVolume},Null->0Microliter]],10^-1 Microliter,AvoidZero->True];

						{
							(* SDSBuffer branch *)
							resolveMixSDSBuffer,
							resolveMixSDSBufferVolume
						}=If[MatchQ[Lookup[myMapThreadOptions,SDSBuffer],Except[Null]],
							Switch[Lookup[myMapThreadOptions,SDSBufferVolume],
								(* If ConcentratedSDSBufferVolume is set to value or null, use it *)
								VolumeP,
								{
									Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
									Lookup[myMapThreadOptions,SDSBufferVolume]
								},
								Automatic,
								{
									Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
									volumeLeft
								},
								Null,
								{
									Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
									Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
								}],
							{
								Null,
								Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
							}
						];

						(* Figure out which branch to continue with ConcentratedSDSBuffer vs SDSBuffer*)
						(* first, figure out which branch can be resolved, if both can, and all are automatic, choose ConcentratedSDS *)
						mixConcentratedSDSBool=!NullQ[resolveMixConcentratedSDSBuffer]&&!NullQ[resolveMixConcentratedSDSBufferVolume];
						mixSDSBool=!NullQ[resolveMixSDSBuffer]&&!NullQ[resolveMixSDSBufferVolume];

						(* if no SDS buffer specified, raise an error *)
						mixSDSBufferNullError=NullQ[resolveMixConcentratedSDSBuffer]&&NullQ[resolveMixSDSBuffer];

						(* check which branch is user defined *)
						concentratedSDSUserDefinedBool=Or@@(MatchQ[Lookup[myMapThreadOptions,#],Except[Null|Automatic]]&/@{ConcentratedSDSBuffer,ConcentratedSDSBufferVolume,ConcentratedSDSBufferDilutionFactor});
						sdsBufferUserDefinedBool=Or@@(MatchQ[Lookup[myMapThreadOptions,#],Except[Null|Automatic]]&/@{SDSBuffer,SDSBufferVolume});

						(* if both branches can be successfully resolved, raise a warning (would pick either ConcentratedSDSBuffer, or the branch that was filled by user *)
						mixBothSDSBranchesSetWarning=mixConcentratedSDSBool&&mixSDSBool&&concentratedSDSUserDefinedBool&&sdsBufferUserDefinedBool;

						{
							mixConcentratedSDSBuffer,
							mixConcentratedSDSBufferVolume,
							mixConcentratedSDSBufferDilutionFactor,
							mixConcentratedSDSBufferDilutionFactorNullError,
							mixSDSBuffer,
							mixSDSBufferVolume
						}=Which[
							(* both buffers are Null *)
							mixSDSBufferNullError,
							{
								Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
								Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
								Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
								False,
								Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
								Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
							},
							(* If ConcentratedSDS is user informed, but invalid *)
							!mixConcentratedSDSBool&&concentratedSDSUserDefinedBool,
							{
								Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
								Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
								Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
								True,
								Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
								Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
							},
							(* if only concentratedSDS is resolved *)
							mixConcentratedSDSBool&&!mixSDSBool,
							{
								resolveMixConcentratedSDSBuffer,
								resolveMixConcentratedSDSBufferVolume,
								resolveMixConcentratedSDSBufferDilutionFactor,
								resolveMixConcentratedSDSBufferDilutionFactorNullError,
								Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
								Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
							},
							(* if only SDSBuffer is resolved *)
							!mixConcentratedSDSBool&&mixSDSBool,
							{
								Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
								Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
								Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
								False,
								resolveMixSDSBuffer,
								resolveMixSDSBufferVolume
							},
							(* If both branches resolved, check which one is user informed and return that one, alternatively, return ConcentratedSDS *)
							mixConcentratedSDSBool&&mixSDSBool,
							(* ConcentratedSDS is user informed *)
							Which[
								concentratedSDSUserDefinedBool@@!sdsBufferUserDefinedBool,
								{
									resolveMixConcentratedSDSBuffer,
									resolveMixConcentratedSDSBufferVolume,
									resolveMixConcentratedSDSBufferDilutionFactor,
									resolveMixConcentratedSDSBufferDilutionFactorNullError,
									Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
									Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
								},
								(* SDSBuffer is user informed *)
								sdsBufferUserDefinedBool&&!concentratedSDSUserDefinedBool,
								{
									Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
									Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
									Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
									False,
									resolveMixSDSBuffer,
									resolveMixSDSBufferVolume
								},
								(* Neither is user informed, go on with ConcentratedSDS *)
								True,
								{
									resolveMixConcentratedSDSBuffer,
									resolveMixConcentratedSDSBufferVolume,
									resolveMixConcentratedSDSBufferDilutionFactor,
									resolveMixConcentratedSDSBufferDilutionFactorNullError,
									Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
									Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
								}
							]
						];

						(* check the amount of SDS added to sample, warn if below 0.5% *)

						(* grab the SDSbuffer that is not Null, if any.. *)
						sampleSDSBuffer=If[!mixSDSBufferNullError,
							First[Cases[{mixConcentratedSDSBuffer,mixSDSBuffer},ObjectP[]]],
							Null];

						(* fetch packet and pull out SDS *)
						sampleBufferCompositionIDs=If[!mixSDSBufferNullError,
							Module[{sampleBufferPacket,sampleBufferComposition,sampleBufferCompositionPackets},
								sampleBufferPacket=fetchPacketFromCache[Download[sampleSDSBuffer,Object],optionObjectModelPackets];
								sampleBufferComposition=Lookup[sampleBufferPacket,Composition];
								(* construct list with concentration and molecule composition *)
								sampleBufferCompositionPackets=Map[
									Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
									sampleBufferComposition];
								(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
								{Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@sampleBufferCompositionPackets
							],
							{}];

						(* Identifiers for SDS *)
						sds={"Sodium dodecyl sulfate","SDS","Sodium lauryl sulfate","151-21-3",
							"InChI=1S/C12H26O4S.Na/c1-2-3-4-5-6-7-8-9-10-11-12-16-17(13,14)15;/h2-12H2,1H3,(H,13,14,15);/q;+1/p-1",
							"InChI=1S/C12H26O4S.Na/c1-2-3-4-5-6-7-8-9-10-11-12-16-17(13,14)15;/h2-12H2,1H3,(H,13,14,15);/q;+1/p-1",
							"DBMJMQXJHONAFJ-UHFFFAOYSA-M"};

						(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
						(* Note - this assumes a single reducing agent in the sample; if more, user will need to specify volume *)

						identifySDS=If[!MatchQ[sampleBufferCompositionIDs,{}],
							Map[Function[compositionMolecule,
								{
									compositionMolecule[[1]] (* ObjectID *),
									compositionMolecule[[2]] (* Concentration *),
									Which[
										ContainsAny[compositionMolecule[[3]],sds],"SDS"
									]
								}
							],
								sampleBufferCompositionIDs],
							Null
						];

						(* pick out cases where the second index in the list is not null *)
						sdsObject=If[!NullQ[identifySDS],
							Cases[identifySDS,{ObjectP[],_,Except[NullP]}],
							Null];

						bufferVolume=If[And[!NullQ[identifySDS],Or[!NullQ[mixConcentratedSDSBufferVolume],!NullQ[mixSDSBufferVolume]]],
							First[Cases[{mixConcentratedSDSBufferVolume,mixSDSBufferVolume},VolumeP]],
							Null];

						mixNotEnoughSDSinSampleWarning=Which[
							(* no valid buffer *)
							NullQ[mixConcentratedSDSBufferVolume]&&NullQ[mixSDSBufferVolume],False,
							(* no SDS identified in buffer *)
							MatchQ[sdsObject,{}],True,
							QuantityUnit[First[sdsObject][[2]]]==IndependentUnit["MassPercent"],
							First[sdsObject][[2]]*bufferVolume/totalVolume<0.5 MassPercent,
							MatchQ[Convert[First[sdsObject][[2]],Gram/Milliliter],Except[$Failed]],
							First[sdsObject][[2]]*bufferVolume/totalVolume<0.005 Gram/Milliliter,
							MatchQ[Convert[First[sdsObject][[2]],Millimolar],Except[$Failed]],
							(* 17.3 mM is the equivalent of 0.5%..*)
							First[sdsObject][[2]]*bufferVolume/totalVolume<17.3 Millimolar,
							True,False
						];

						{
							mixVolumeGreaterThanTotalVolumeError,
							mixComponentsDontSumToTotalVolumeError,
							mixDiluent
						}=Which[
							(* If no SDS buffer is available *)
							mixSDSBufferNullError,
							{False,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null},
							(* if ConcentratedSDSBuffer is specified but Dilution Factor is Null *)
							mixConcentratedSDSBufferDilutionFactorNullError,
							{False,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null},
							(* if on ConcentratedSDS branch or if both are user defined *)
							Or[(!NullQ[mixConcentratedSDSBuffer]&&NullQ[mixSDSBuffer]),mixBothSDSBranchesSetWarning],
							Which[
								(* if there's no room for more liquid, no need for a diluent *)
								(volumeLeft-mixConcentratedSDSBufferVolume)==0Microliter,{False,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null},
								(* If there's room, use diluent, if not set, use water *)
								(volumeLeft-mixConcentratedSDSBufferVolume)>0Microliter,{False,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Model[Sample,"Milli-Q water"]},
								(* if we're over the TotalVolume, raise an error *)
								(volumeLeft-mixConcentratedSDSBufferVolume)<0Microliter,{True,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null}
							],
							(* if on SDSBuffer branch *)
							NullQ[mixConcentratedSDSBuffer]&&!NullQ[mixSDSBuffer],
							Which[
								(* if we're at the TotalVolume, We're All good *)
								(volumeLeft-mixSDSBufferVolume)==0Microliter,{False,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null},
								(* if we're below the TotalVolume, raise an error (the volume of SDSBuffer is not enough to fill *)
								(volumeLeft-mixSDSBufferVolume)>0Microliter,{False,True,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null},
								(* if we're over the TotalVolume, raise an error *)
								(volumeLeft-mixSDSBufferVolume)<0Microliter,{True,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null}
							]
						];

						(* if need a diluent and it is set to Null, raise Error and set to water *)
						mixDiluentNullError=Which[
							mixConcentratedSDSBufferDilutionFactorNullError,
							False,
							NullQ[mixSDSBuffer]&&!NullQ[mixConcentratedSDSBuffer],
							(volumeLeft-mixConcentratedSDSBufferVolume)>0*Microliter&&MatchQ[mixDiluent,Null],
							!NullQ[mixSDSBuffer]&&NullQ[mixConcentratedSDSBuffer],
							False,
							True,
							False
						];

						(* Gather all resolved options and errors to return *)
						{
							(*1*)(* PremadeMasterMix branch's options as Null *)
							(*2*)Lookup[myMapThreadOptions,PremadeMasterMixVolume]/.Automatic:>Null,
							(*3*)Lookup[myMapThreadOptions,PremadeMasterMixReagentDilutionFactor]/.Automatic:>Null,
							(*4*)Lookup[myMapThreadOptions,PremadeMasterMixDiluent]/.Automatic:>Null,
							(*5*)(* PremadeMasterMix branch's errors as False *)
							(*6*)False,(* masterMixNullError *)
							(*7*)False,(* masterMixDilutionFactorNullError *)
							(*8*)False,(* masterMixVolumeNullError *)
							(*9*)False,(* masterMixVolumeDilutionFactorMismatchWarning *)
							(*10*)False,(* masterMixTotalVolumeError *)
							False,(* masterMixDiluentNullError*)
							(*11*)(* make-your-own mix branch's options *)
							(*12*)mixInternalReference,
							(*13*)mixInternalReferenceDilutionFactor,
							(*14*)mixInternalReferenceVolume,
							(*15*)mixConcentratedSDSBuffer,
							(*16*)mixConcentratedSDSBufferDilutionFactor,
							(*17*)mixDiluent,
							(*18*)mixConcentratedSDSBufferVolume,
							(*19*)mixSDSBuffer,
							(*20*)mixSDSBufferVolume,
							(*21*)mixReduction,
							(*22*)mixReducingAgent,
							(*23*)mixReducingAgentTargetConcentration,
							(*24*)mixReducingAgentVolume,
							(*25*)mixAlkylation,
							(*26*)mixAlkylatingAgent,
							(*27*)mixAlkylatingAgentTargetConcentration,
							(*28*)mixAlkylatingAgentVolume,
							(*29*)(* make-your-own mix branch's errors  *)
							(*30*)intReferenceNullError,
							(*31*)intReferenceDilutionFactorNullError,
							intReferenceVolumeNullError,
							(*32*)intReferenceVolumeDilutionFactorMismatchWarning,
							(*33*)mixReducingAgentNullError,
							(*34*)mixNoReducingAgentIdentifiedWarning,
							(*35*)mixReducingAgentTargetConcentrationNullError,
							(*36*)mixReducingAgentVolumeNullError,
							(*37*)mixReducingAgentVolumeConcentrationMismatchError,
							(*38*)mixAlkylatingAgentNullError,
							(*39*)mixNoAlkylatingAgentIdentifiedWarning,
							(*40*)mixAlkylatingAgentTargetConcentrationNullError,
							(*41*)mixAlkylatingAgentVolumeNullError,
							(*42*)mixAlkylatingAgentVolumeConcentrationMismatchError,
							(*43*)mixSDSBufferNullError,
							(*44*)mixBothSDSBranchesSetWarning,
							(*45*)mixConcentratedSDSBufferDilutionFactorNullError,
							(*46*)mixNotEnoughSDSinSampleWarning,
							(*47*)mixVolumeGreaterThanTotalVolumeError,
							(*48*)mixComponentsDontSumToTotalVolumeError,
							(*49*)mixDiluentNullError
						}
					]
				];

				(* resolve SeparationVoltageDurationProfile *)
				separationVoltageDurationProfile=Which[
					(* if separationProfile is Automatic, and sample is reduced *)
					MatchQ[Lookup[myMapThreadOptions,SeparationVoltageDurationProfile],Automatic]&&TrueQ[reduction],List[{5750 Volt,35 Minute}],
					(* if separationProfile is Automatic, sample is not reduced, and adding a ladder suggests a longer run is required *)
					MatchQ[Lookup[myMapThreadOptions,SeparationVoltageDurationProfile],Automatic]&&!TrueQ[reduction]&&TrueQ[Lookup[myMapThreadOptions,IncludeLadders]],List[{5750 Volt,35 Minute}],
					(* if separationProfile is Automatic, sample is not reduced, and not adding a ladder suggests running mABs so run can be shorter *)
					MatchQ[Lookup[myMapThreadOptions,SeparationVoltageDurationProfile],Automatic]&&!TrueQ[reduction]&&!TrueQ[Lookup[myMapThreadOptions,IncludeLadders]],List[{5750 Volt,25 Minute}],
					(* if separationProfile is user specified, sample is not reduced, and not adding a ladder suggests running mABs so run can be shorter *)
					MatchQ[Lookup[myMapThreadOptions,SeparationVoltageDurationProfile],{{VoltageP,TimeP}..}],Lookup[myMapThreadOptions,SeparationVoltageDurationProfile]
				];

				(* All sample branches gather here; resolve SupernatantVolume *)
				supernatantVolume=If[resolvedIncludeCentrifugation,
					Switch[
						Lookup[myMapThreadOptions,SedimentationSupernatantVolume],
						Automatic,RoundOptionPrecision[0.9*Lookup[myMapThreadOptions,TotalVolume],10^-1 Microliter,AvoidZero->True],
						Except[Automatic],Lookup[myMapThreadOptions,SedimentationSupernatantVolume]
					],
					Lookup[myMapThreadOptions,SedimentationSupernatantVolume]/.Automatic:>Null;
				];

				(* check if resolved value is larger than TotalVolume or Null *)
				supernatantVolumeInvalidError=If[resolvedIncludeCentrifugation,
					Or[NullQ[supernatantVolume],supernatantVolume>Lookup[myMapThreadOptions,TotalVolume]],
					False
				];

				(* Gather MapThread results *)
				{
					(*1*)(* General options variables *)
					(*2*)sampleVolume,
					(*3*)supernatantVolume,
					(*4*)separationVoltageDurationProfile,
					(*10*)(* General options errors *)
					(*11*)missingSampleCompositionWarning,
					(*12*)supernatantVolumeInvalidError,
					(*15*)(* premade mastermix branch variables *)
					resolvePremadeMasterMix,
					(*16*)premadeMasterMixVolume,
					(*17*)premadeMasterMixDilutionFactor,
					(*18*)premadeMasterMixDiluent,
					(*19*)(* premade mastermix branch errors *)
					(*20*)premadeMasterMixNullError,
					(*21*)premadeMasterMixDilutionFactorNullError,
					(*22*)premadeMasterMixVolumeNullError,
					(*23*)premadeMasterMixVolumeDilutionFactorMismatchWarning,
					(*24*)premadeMasterMixTotalVolumeError,
					premadeMasterMixDiluentNullError,
					(*25*)(* make-ones-own mastermix branch variables *)
					(*26*)internalReference,
					(*27*)internalReferenceDilutionFactor,
					(*28*)internalReferenceVolume,
					(*29*)concentratedSDSBuffer,
					(*30*)concentratedSDSBufferDilutionFactor,
					(*31*)diluent,
					(*32*)concentratedSDSBufferVolume,
					(*33*)sDSBuffer,
					(*34*)sDSBufferVolume,
					(*35*)reduction,
					(*36*)reducingAgent,
					(*37*)reducingAgentTargetConcentration,
					(*38*)reducingAgentVolume,
					(*39*)alkylation,
					(*40*)alkylatingAgent,
					(*41*)alkylatingAgentTargetConcentration,
					(*42*)alkylatingAgentVolume,
					(*43*)(* make-ones-own mastermix branch errors *)
					(*44*)internalReferenceNullError,
					(*45*)internalReferenceDilutionFactorNullError,
					internalReferenceVolumeNullError,
					(*46*)internalReferenceVolumeDilutionFactorMismatchWarning,
					(*47*)reducingAgentNullError,
					(*48*)noReducingAgentIdentifiedWarning,
					(*49*)reducingAgentTargetConcentrationNullError,
					(*50*)reducingAgentVolumeNullError,
					(*51*)reducingAgentVolumeConcentrationMismatchError,
					(*52*)alkylatingAgentNullError,
					(*53*)noAlkylatingAgentIdentifiedWarning,
					(*54*)alkylatingAgentTargetConcentrationNullError,
					(*55*)alkylatingAgentVolumeNullError,
					(*56*)alkylatingAgentVolumeConcentrationMismatchError,
					(*57*)sDSBufferNullError,
					(*58*)bothSDSBranchesSetWarning,
					(*59*)concentratedSDSBufferDilutionFactorNullError,
					(*60*)notEnoughSDSinSampleWarning,
					(*61*)volumeGreaterThanTotalVolumeError,
					(*62*)componentsDontSumToTotalVolumeError,
					(*63*)diluentNullError
				}
			]
		],
		(* we are passing the injection table volumes directly to the mapthread to handle sampleVolume resolution in the right sample order *)
		{samplePackets,mapThreadFriendlyOptions,roundedInjectionTableSampleVolumes}
	]];

	(* Resolve Ladders *)
	(*retrieve all of the options that index match to Ladders*)
	ladderOptions=Map[ToExpression,"OptionName"/.Cases[OptionDefinition[ExperimentCapillaryGelElectrophoresisSDS],KeyValuePattern["IndexMatchingParent"->"Ladders"]]];
	(*check if any of the ladder options are set*)
	includeLadderOptionBool=Map[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,#],
			Except[getDefault[#,opsDef]|Automatic|Null|False]]&,
		ladderOptions
	];

	laddersInInjectionTableBool=If[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],Except[Automatic]],
		MemberQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable][[All,1]],Ladder],
		False];

	(*resolve the IncludeLadder option based on the setting of the other options*)
	resolveIncludeLadders=Which[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,IncludeLadders],Except[Automatic]],
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,IncludeLadders],
		(* if a standard is specified in the injection table *)
		laddersInInjectionTableBool,True,
		Or@@includeLadderOptionBool,True,
		True,False
	];

	(* Next, resolve the number of unique sets of options in SamplesIn - first grab all SamplesIn related resolved and specified options *)
	samplesInOptions=Transpose[{
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,TotalVolume],
		resolvedPremadeMasterMix,
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,PremadeMasterMixReagent],
		resolvedPremadeMasterMixDiluent,
		resolvedPremadeMasterMixReagentDilutionFactor,
		resolvedPremadeMasterMixVolume,
		resolvedInternalReference,
		resolvedInternalReferenceDilutionFactor,
		resolvedInternalReferenceVolume,
		resolvedConcentratedSDSBuffer,
		resolvedConcentratedSDSBufferDilutionFactor,
		resolvedDiluent,
		resolvedConcentratedSDSBufferVolume,
		resolvedSDSBuffer,
		resolvedSDSBufferVolume,
		resolvedReduction,
		resolvedReducingAgent,
		resolvedReducingAgentTargetConcentration,
		resolvedReducingAgentVolume,
		resolvedAlkylation,
		resolvedAlkylatingAgent,
		resolvedAlkylatingAgentTargetConcentration,
		resolvedAlkylatingAgentVolume,
		resolvedSedimentationSupernatantVolume,
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionVoltageDurationProfile],
		resolvedSeparationVoltageDurationProfile
	}];

	(* Now grab unique options combination that will be applied to ladders into an association we can work with in a mapthread*)
	uniqueSamplesInOptionAssociation=AssociationThread[
		{
			TotalVolume,PremadeMasterMix,PremadeMasterMixReagent,PremadeMasterMixDiluent,PremadeMasterMixReagentDilutionFactor,
			PremadeMasterMixVolume,InternalReference,InternalReferenceDilutionFactor,InternalReferenceVolume,
			ConcentratedSDSBuffer,ConcentratedSDSBufferDilutionFactor,Diluent,ConcentratedSDSBufferVolume,SDSBuffer,
			SDSBufferVolume,Reduction,ReducingAgent,ReducingAgentTargetConcentration,ReducingAgentVolume,Alkylation,
			AlkylatingAgent,AlkylatingAgentTargetConcentration,AlkylatingAgentVolume,
			SedimentationSupernatantVolume,InjectionVoltageDurationProfile,SeparationVoltageDurationProfile
		},
		Transpose[
			DeleteDuplicates[samplesInOptions]]
	];

	(* now we can count the number of unique conditions *)
	uniqueOptionCombinations=CountDistinct[samplesInOptions];

	(* if ladders are set, grab them, if not, but resolveIncludeLadders = True, grab from injectionTable, if no injection table,
	grab default ladder and duplicate it to the number of unique sets of options.
	if the number of ladders does not match the number of unique sets of options, raise warning and use the most common set in samplesIn (or the first, if its equal), *)

	(* To figure out how many standards we need to have, grab the length of any specified option and use the longest to resolve the number of standards *)
	requiredLadders = If[resolveIncludeLadders,
		(* if we have any relevant options specified, get their length and return the longest or just 1 *)
		Max[
			Flatten[{
				1,
				Map[
					Function[option, Length[ToList[option]]],
					Map[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,#]&,ladderOptions]
				]
			}]
		],
		(* not doing standards, dont worry about it *)
		0
	];

	resolvedLadders=Which[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Ladders],Except[Automatic|{Automatic..}]],
		(* if only one was specified but we actually need more, give them what they want.. *)
		If[MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Ladders],ObjectP[]],
			ConstantArray[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Ladders],Max[requiredLadders,uniqueOptionCombinations]],
			(* still replacing automatics in case theres a mix of objects and automatics *)
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Ladders]/.Automatic:>Model[Sample, "Unstained Protein Standard"]
		],
		resolveIncludeLadders,
		If[MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],Except[Automatic|Null]],
			Select[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],MatchQ[First[#],Ladder]&][[All,2]],
			If[MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Ladders],{Automatic..}],
				Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Ladders]/.Automatic:>Model[Sample, "Unstained Protein Standard"],
				ConstantArray[Model[Sample, "Unstained Protein Standard"],Max[requiredLadders,uniqueOptionCombinations]]
			]
		],
		True,Null
	];

	(* test if ladders are discarded or deprecated *)
	(* get ladders into a packet *)
	ladderPacket=fetchPacketFromCache[Download[#,Object],ladderPackets]&/@ToList[resolvedLadders];
	ladderModelPacket=If[resolveIncludeLadders,
		Cases[fetchPacketFromCache[#,ladderModelPackets]&/@Flatten[{Lookup[ladderPacket,Model,{}],Lookup[ladderPacket,Object,{}]}],ObjectP[Model[Sample]]],
		<||>
	];
	(* grab discarded ladders into a packet *)
	discardedLadders=Cases[ladderPacket,KeyValuePattern[Status->Discarded]] ;

	(* Set discardedLadderInvalidOptions to the input objects whose statuses are Discarded *)
	discardedLadderInvalidOptions=If[MatchQ[discardedLadders,{}],
		{},
		Lookup[discardedLadders,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedLadderInvalidOptions]>0&&messages,
		Message[Error::DiscardedSamples,ObjectToString[discardedLadderInvalidOptions,Cache->ladderPackets]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedLadderTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedLadderInvalidOptions]==0,
				Nothing,
				Test["Provided input samples "<>ObjectToString[discardedLadderInvalidOptions,Cache->ladderPackets]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedLadderInvalidOptions]==Length[discardedLadders],
				Nothing,
				Test["Provided input samples "<>ObjectToString[Complement[Lookup[ladderPackets,Object],discardedLadderInvalidOptions],Cache->ladderPackets]<>" are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* check if number of each unique ladder matches the number of unique conditions *)
	enoughLaddersForUniqueOptionSetsQ=If[resolveIncludeLadders,
		Or@@(#>=uniqueOptionCombinations&/@Tally[ToList[resolvedLadders]][[All,2]]),
		True
	];

	(* to make sure we expend all relevant options in a flexible way, preexpend and then listify accordingly *)
	preexpandedLaddersOptions=If[!resolveIncludeLadders,
		Association[#->Null&/@ladderOptions],
		Last[ExpandIndexMatchedInputs[
			ExperimentCapillaryGelElectrophoresisSDS,
			{mySamples},
			Normal[Append[
				KeyTake[roundedCapillaryGelElectrophoresisSDSOptions,ladderOptions],
				Ladders->resolvedLadders
			]],
			Messages->False
		]]
	];

	{resolvedLadders,expandedLaddersOptions}=If[And[
		Depth[Lookup[preexpandedLaddersOptions,Ladders]]<=2,
		MatchQ[Lookup[preexpandedLaddersOptions,Ladders],Except[{}|Null]]
	],
		{
			ToList[Lookup[preexpandedLaddersOptions,Ladders]],
			Map[(First[#]->List[Last[#]]) &,preexpandedLaddersOptions]
		},
		(*if not the singleton case, then nothing to change*)
		{
			Lookup[preexpandedLaddersOptions,Ladders],
			preexpandedLaddersOptions
		}
	];

	(* Informing volumes from the injection table runs the risk of it not being copacetic with specified samples/ladders/standards/blanks *)
	(* to avoid this breaking the mapthread, make sure ladders are copacetic, and if not, inform volume from sampleVolume *)
	injectionTableLaddersNotCopaceticQ=If[MatchQ[specifiedInjectionTable,Except[Automatic]],
		Not[Or[
			MatchQ[resolvedLadders,Null|Automatic|{Automatic..}],
			And[
				ContainsAll[
					Cases[specifiedInjectionTable,{Ladder,ObjectP[],VolumeP|Automatic}][[All,2]],
					Cases[resolvedLadders,ObjectP[]]
				],
				ContainsAll[
					Cases[resolvedLadders,ObjectP[]],
					Cases[specifiedInjectionTable,{Ladder,ObjectP[],VolumeP|Automatic}][[All,2]]
				]
			]]],
		False
	];

	(* if there is a user specified an injection table, and if they did, grab volumes to pass to the mapthread  *)
	injectionTableLadderVolumes=If[Not[injectionTableLaddersNotCopaceticQ],
		Switch[specifiedInjectionTable,
			{{_,ObjectP[],VolumeP|Automatic}..},Cases[specifiedInjectionTable,{Ladder,ObjectP[],VolumeP|Automatic}][[All,3]],
			Automatic,ConstantArray[Automatic,Length[resolvedLadders]]
		],
		(* If samples in injection tables dont match Ladders, dont inform volume, we'll raise an error a bit later *)
		ToList[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,LadderVolume]]
	];

	(* we need to account for a situation where the injection table is not in agreement with samplesIn and options.
	there is an error check later, but we want to make sure we dont break the MapThread *)
	lengthCorrectedInjectionTableLadderVolumes=If[Length[injectionTableLadderVolumes]!=Length[resolvedLadders],
		ConstantArray[Automatic,Length[resolvedLadders]],
		injectionTableLadderVolumes
	];

	(* round volumes *)
	roundedInjectionTableLadderVolumes=RoundOptionPrecision[lengthCorrectedInjectionTableLadderVolumes,10^-1Microliter];

	(* prep options for mapThread *)
	mapThreadFriendlyLadderOptions=If[resolveIncludeLadders,
		Transpose[Association[expandedLaddersOptions],AllowedHeads->{Association,List}],
		Null
	];

	(* make a mapFriendly version of the unique options *)
	mapFriendlyUniqueOptions=Transpose[Association[uniqueSamplesInOptionAssociation],AllowedHeads->{Association,List}];

	(* we can prepare a matched version where each ladder will get the same list of unique options *)
	ladderMapFriendlySamplesInResolvedOptions=If[resolveIncludeLadders,
		Module[
			{allPositions,positionToOptionsRules},
			(* get positions of each unique ladder *)
			allPositions=Flatten[Position[resolvedLadders,#]&]/@DeleteDuplicates[resolvedLadders];
			(* based on position, use a padded version of the friendly options to assign options to each instance of a ladder *)
			positionToOptionsRules=Map[Module[{paddedOptions},
				(* create a padded version of the uniqueOptions as long as the number of each unique ladder *)
				paddedOptions=PadRight[{},Length[#],mapFriendlyUniqueOptions];
				(* now we can MapThread over positions and optiosn and make rules to replace *)
				MapThread[Function[{position,options},
					position->options
				],
					{#,paddedOptions}]]&,
				allPositions];
			(* We can now replace the ladders with the unique options in their current order for mapThread *)
			ReplacePart[resolvedLadders,Flatten[positionToOptionsRules]]
		],
		{}
	];


	(* Ladders get their own resolver because we automatically resolve to samples in *)
	(* top do so, we will pass a list of samplesIn resolved options as a list of associations that is matched to ladders *)
	(* working based off of volumes, we will correct for changes in total volume and replace automatics with values from samplesIn *)

	(* TODO: add Analytes to look for identity models in ladders and standards *)

	(* ladder Map thread *)
	{
		(*1*)(* ladder specific options *)
		(*2*)resolvedLadderAnalytes,
		(*3*)resolvedLadderAnalyteMolecularWeights,
		(*4*)resolvedLadderAnalyteLabels,
		(*5*)resolvedLadderTotalVolume,
		(*6*)resolvedLadderDilutionFactor,
		(*7*)resolvedLadderVolume,
		(*8*)resolvedLadderFrequency,
		(*9*)(* errors *)
		(*10*)ladderTotalVolumeNullErrors,
		(*11*)ladderVolumeNullErrors,
		(*12*)ladderDilutionFactorNullErrors,
		(*13*)ladderAnalyteMolecularWeightMismatchs,
		(*14*)ladderCompositionMolecularWeightMismatchs,
		(*15*)ladderAnalytesCompositionMolecularWeightMismatchs,
		(*16*)ladderAnalyteLabelErrors,
		(*17*)molecularWeightMissingInModelWarnings,
		(*18*)(* option variables *)
		(*19*)resolvedLadderSedimentationSupernatantVolume,
		(*20*)resolvedLadderSeparationVoltageDurationProfile,
		(*21*)resolvedLadderInjectionVoltageDurationProfile,
		(*31*)(* general option errors *)
		(*32*)ladderMissingSampleCompositionWarnings,
		(*33*)ladderSupernatantVolumeInvalidErrors,
		(*36*)(* premade mastermix branch variables *)
		(*37*)resolvedLadderPremadeMasterMix,
		(*38*)resolvedLadderPremadeMasterMixReagent,
		(*39*)resolvedLadderPremadeMasterMixVolume,
		(*40*)resolvedLadderPremadeMasterMixReagentDilutionFactor,
		(*41*)resolvedLadderPremadeMasterMixDiluent,
		(*42*)(* premade mastermix branch errors *)
		(*43*)ladderPremadeMasterMixNullErrors,
		(*44*)ladderPremadeMasterMixDilutionFactorNullErrors,
		(*45*)ladderPremadeMasterMixVolumeNullErrors,
		(*46*)ladderPremadeMasterMixVolumeDilutionFactorMismatchWarnings,
		(*47*)ladderPremadeMasterMixTotalVolumeErrors,
		(*48*)ladderPremadeMasterMixDiluentNullErrors,
		(*49*)(* make-ones-own mastermix branch variables *)
		(*50*)resolvedLadderInternalReference,
		(*51*)resolvedLadderInternalReferenceDilutionFactor,
		(*52*)resolvedLadderInternalReferenceVolume,
		(*53*)resolvedLadderConcentratedSDSBuffer,
		(*54*)resolvedLadderConcentratedSDSBufferDilutionFactor,
		(*55*)resolvedLadderDiluent,
		(*56*)resolvedLadderConcentratedSDSBufferVolume,
		(*57*)resolvedLadderSDSBuffer,
		(*58*)resolvedLadderSDSBufferVolume,
		(*59*)resolvedLadderReduction,
		(*60*)resolvedLadderReducingAgent,
		(*61*)resolvedLadderReducingAgentTargetConcentration,
		(*62*)resolvedLadderReducingAgentVolume,
		(*63*)resolvedLadderAlkylation,
		(*64*)resolvedLadderAlkylatingAgent,
		(*65*)resolvedLadderAlkylatingAgentTargetConcentration,
		(*66*)resolvedLadderAlkylatingAgentVolume,
		(*67*)(* make-ones-own mastermix branch errors *)
		(*68*)ladderInternalReferenceNullErrors,
		(*69*)ladderInternalReferenceDilutionFactorNullErrors,
		(*70*)ladderInternalReferenceVolumeNullErrors,
		(*71*)ladderInternalReferenceVolumeDilutionFactorMismatchWarnings,
		(*72*)ladderReducingAgentNullErrors,
		(*73*)ladderNoReducingAgentIdentifiedWarnings,
		(*74*)ladderReducingAgentTargetConcentrationNullErrors,
		(*75*)ladderReducingAgentVolumeNullErrors,
		(*76*)ladderReducingAgentVolumeConcentrationMismatchErrors,
		(*77*)ladderAlkylatingAgentNullErrors,
		(*78*)ladderNoAlkylatingAgentIdentifiedWarnings,
		(*79*)ladderAlkylatingAgentTargetConcentrationNullErrors,
		(*80*)ladderAlkylatingAgentVolumeNullErrors,
		(*81*)ladderAlkylatingAgentVolumeConcentrationMismatchErrors,
		(*82*)ladderSDSBufferNullErrors,
		(*83*)ladderBothSDSBranchesSetWarnings,
		(*84*)ladderConcentratedSDSBufferDilutionFactorNullErrors,
		(*85*)ladderNotEnoughSDSinSampleWarnings,
		(*86*)ladderVolumeGreaterThanTotalVolumeErrors,
		(*87*)ladderComponentsDontSumToTotalVolumeErrors,
		(*88*)ladderDiluentNullErrors
	}=If[resolveIncludeLadders,
		Transpose[MapThread[
			Function[{myLadder,myLadderOptions,samplesInOptions,injectionTableLadderVolume},
				Module[{
					ladderAnalytes,ladderAnalyteMolecularWeights,ladderAnalyteLabels,ladderTotalVolume,
					ladderVolume,ladderDilutionFactor,ladderDilutionFactorNullError,ladderAnalyteMolecularWeightMismatch,
					ladderCompositionMolecularWeightMismatch,molecularWeightMissingInModelWarning,
					ladderAnalytesCompositionMolecularWeightMismatch,ladderAnalyteLabelError,ladderTotalVolumeNullError,
					ladderVolumeNullError,compositionProteins,ladderCompositionMW,compositionProteinPacket,compositionInformedBoolean,
					ladderAnalytesProteins,ladderAnalytesPacket,ladderAnalytesMW,ladderAnalytesInformedBoolean,ladderAnalytesLabels,
					ladderAnalytesMWOption,ladderAnalyteLabelsInformedBoolean,ladderAnalyteMWOptionInformedBoolean,
					ladderFrequency,currentLadderPacket,

					premadeMasterMixVolume,separationVoltageDurationProfile,premadeMasterMixNullError,premadeMasterMixDilutionFactorNullError,
					internalReferenceNullError,internalReferenceDilutionFactorNullError,internalReferenceVolumeNullError,
					concentratedSDSBufferDilutionFactorNullError,diluentNullError,sDSBufferNullError,reducingAgentNullError,
					reducingAgentVolumeConcentrationMismatchError,reducingAgentTargetConcentrationNullError,reducingAgentVolumeNullError,
					alkylatingAgentNullError,alkylatingAgentVolumeConcentrationMismatchError,alkylatingAgentTargetConcentrationNullError,
					premadeMasterMixTotalVolumeError,missingSampleCompositionWarning,premadeMasterMixVolumeNullError,
					premadeMasterMixVolumeDilutionFactorMismatchWarning,internalReference,
					internalReferenceDilutionFactor,internalReferenceVolume,concentratedSDSBuffer,
					concentratedSDSBufferDilutionFactor,diluent,concentratedSDSBufferVolume,sDSBufferVolume,reducingAgent,
					reducingAgentTargetConcentration,reducingAgentVolume,alkylatingAgent,alkylatingAgentTargetConcentration,
					alkylatingAgentVolume,internalReferenceVolumeDilutionFactorMismatchWarning,reduction,alkylation,
					alkylatingAgentVolumeNullError,alkylatingAgentIdentifiedWarning,sDSBuffer,bothSDSBranchesSetWarning,
					volumeGreaterThanTotalVolumeError,componentsDontSumToTotalVolumeError,supernatantVolume,supernatantVolumeInvalidError,
					notEnoughSDSinSampleWarning,premadeMasterMixDilutionFactor,masterMixDilutionFactor,totalVolume,
					injectionVoltageDurationProfile,reducingAgentIdentifiedWarning,preMadeMasterMixOptions,
					includePremadeMasterMixBool,resolvePremadeMasterMix,premadeMasterMixDiluentNullError,premadeMasterMixReagent,
					totalVolumeRatio
				},

					(* set up error tracking *)
					{
						ladderTotalVolumeNullError,
						ladderVolumeNullError,
						ladderDilutionFactorNullError,
						ladderAnalyteMolecularWeightMismatch,
						ladderCompositionMolecularWeightMismatch,
						ladderAnalytesCompositionMolecularWeightMismatch,
						ladderAnalyteLabelError,
						molecularWeightMissingInModelWarning,
						missingSampleCompositionWarning,
						premadeMasterMixNullError,
						premadeMasterMixDilutionFactorNullError,
						premadeMasterMixDiluentNullError,
						internalReferenceNullError,
						internalReferenceDilutionFactorNullError,
						internalReferenceVolumeNullError,
						reducingAgentNullError,
						reducingAgentVolumeConcentrationMismatchError,
						reducingAgentTargetConcentrationNullError,
						reducingAgentVolumeNullError,
						alkylatingAgentNullError,
						alkylatingAgentTargetConcentrationNullError,
						alkylatingAgentVolumeConcentrationMismatchError,
						premadeMasterMixTotalVolumeError,
						reducingAgentIdentifiedWarning,
						alkylatingAgentNullError,
						alkylatingAgentTargetConcentrationNullError,
						alkylatingAgentVolumeNullError,
						alkylatingAgentIdentifiedWarning,
						sDSBufferNullError,
						bothSDSBranchesSetWarning,
						concentratedSDSBufferDilutionFactorNullError,
						volumeGreaterThanTotalVolumeError,
						componentsDontSumToTotalVolumeError,
						diluentNullError,
						supernatantVolumeInvalidError,
						notEnoughSDSinSampleWarning
					}=ConstantArray[False,36];

					(*map thread resolution*)

					(* resolve Ladder totalVolume *)
					ladderTotalVolume=Switch[Lookup[myLadderOptions,LadderTotalVolume],
						(* if automatic, set to most common value in sample total Value *)
						Automatic,
						Lookup[samplesInOptions,TotalVolume],
						VolumeP,
						Lookup[myLadderOptions,LadderTotalVolume],
						Null,Null
					];

					totalVolumeRatio=ladderTotalVolume/Lookup[samplesInOptions,TotalVolume];

					ladderTotalVolumeNullError=NullQ[ladderTotalVolume];

					(* resolve ladderFrequency *)
					ladderFrequency=Lookup[myLadderOptions,LadderFrequency]/.Automatic:>FirstAndLast;

					(* Resolve Ladder volume *)
					{
						ladderVolume,
						ladderDilutionFactor,
						ladderDilutionFactorNullError
					}=If[Not[ladderTotalVolumeNullError],
						Switch[Lookup[myLadderOptions,LadderVolume],
							(* If LadderVolume is set to value or null, use it *)
							VolumeP,
							{
								Lookup[myLadderOptions,LadderVolume],
								Lookup[myLadderOptions,LadderDilutionFactor]/.Automatic:>ladderTotalVolume/Lookup[myLadderOptions,LadderVolume],
								False
							},
							Automatic,
							Which[
								MatchQ[Lookup[myLadderOptions,LadderDilutionFactor],NumericP],
								(* Dilution factor is informed *)
								{
									RoundOptionPrecision[ladderTotalVolume/(Lookup[myLadderOptions,LadderDilutionFactor]),10^-1 Microliter,AvoidZero->True],
									Lookup[myLadderOptions,LadderDilutionFactor],
									False
								},
								(* No dilution factor specified, and there's a volume in the injection table *)
								MatchQ[Lookup[myLadderOptions,LadderDilutionFactor],Except[NumericP]]&&MatchQ[injectionTableLadderVolume,VolumeP],
								{
									Lookup[myLadderOptions,LadderVolume]/.Automatic:>injectionTableLadderVolume,
									Lookup[myLadderOptions,LadderDilutionFactor]/.Automatic:>ladderTotalVolume/injectionTableLadderVolume,
									False
								},
								(* dilution factor is automatic, and no injection table value given.. *)
								MatchQ[Lookup[myLadderOptions,LadderDilutionFactor],Automatic],
								{
									Lookup[myLadderOptions,LadderVolume]/.Automatic:>RoundOptionPrecision[ladderTotalVolume/2.5,10^-1Microliter],
									Lookup[myLadderOptions,LadderDilutionFactor]/.Automatic:>2.5,
									False
								},
								(* dilution factor is automatic, and no injection table value given.. *)
								MatchQ[Lookup[myLadderOptions,LadderDilutionFactor],Null],
								{
									Lookup[myLadderOptions,LadderVolume]/.Automatic:>Null,
									Lookup[myLadderOptions,LadderDilutionFactor]/.Automatic:>Null,
									True
								}
							],
							Null,
							(* it's null but volume given in the injection table *)
							If[MatchQ[injectionTableLadderVolume,VolumeP],
								{
									injectionTableLadderVolume,
									Lookup[myLadderOptions,LadderDilutionFactor]/.Automatic:>ladderTotalVolume/injectionTableLadderVolume,
									False
								},
								{
									Null,
									Lookup[myLadderOptions,LadderDilutionFactor]/.Automatic:>2.5,
									False
								}
							]
						],
						{
							Lookup[myLadderOptions,LadderVolume]/.Automatic:>Null,
							Lookup[myLadderOptions,LadderDilutionFactor]/.Automatic:>Null,
							False
						}];

					(* If volume is null raise error *)
					ladderVolumeNullError=NullQ[ladderVolume];
					(* get ladder composition to resolve composition *)
					currentLadderPacket=fetchPacketFromCache[myLadder,ladderPacket];
					compositionProteins=Cases[Flatten[Lookup[currentLadderPacket,Composition]],ObjectP[Model[Molecule,Protein]]];
					compositionProteinPacket=If[Length[compositionProteins]>0,
						fetchPacketFromCache[Download[#,Object],sampleCompositionModelPackets]&/@compositionProteins,
						{}];
					ladderCompositionMW=If[Length[compositionProteinPacket]>0,
						Lookup[compositionProteinPacket,{Object,Name,MolecularWeight}],
						{}];

					(* if ladder analytes are informed, resolve their MW *)
					ladderAnalytesProteins=Cases[Flatten[Lookup[myLadderOptions,ToList[LadderAnalytes/.Automatic:>Null]]],ObjectP[Model[Molecule,Protein]]];
					ladderAnalytesPacket=If[Length[ladderAnalytesProteins]>0,
						fetchPacketFromCache[Download[#,Object],ladderPackets]&/@ToList[ladderAnalytesProteins],
						{}];
					ladderAnalytesMW=If[Length[Cases[ladderAnalytesPacket,PacketP[]]]>0,
						Lookup[ladderAnalytesPacket,{Object,Name,MolecularWeight}],
						{}];

					(* if ladder analyte labels are informed, grab them *)
					ladderAnalytesLabels=Lookup[myLadderOptions,LadderAnalyteLabels]/.Automatic:>Null;

					(* if ladder analyte MWs are informed, grab them *)
					ladderAnalytesMWOption=Lookup[myLadderOptions,LadderAnalyteMolecularWeights]/.Automatic:>Null;

					(* check if all proteins in sample have molecular weight informed *)
					compositionInformedBoolean=MatchQ[ladderCompositionMW,Except[{}|Null]]&&And@@(Not[NullQ[#]] &/@ladderCompositionMW[[All,3]]);
					(* check if all proteins in ladderAnalytes have molecular weight informed *)
					ladderAnalytesInformedBoolean=MatchQ[ladderAnalytesMW,Except[{}|Null]]&&And@@(Not[NullQ[#]] &/@ladderAnalytesMW[[All,3]]);
					(* check if all ladderAnalytesLabels are informed *)
					ladderAnalyteLabelsInformedBoolean=MatchQ[ladderAnalytesLabels,Except[{}|Null]];
					(* check if all ladderAnalytesLabels are informed *)
					ladderAnalyteMWOptionInformedBoolean=MatchQ[ladderAnalytesMWOption,Except[{}|Null]];

					(* raise warning if missing mw information in model *)
					molecularWeightMissingInModelWarning=Not[Or[compositionInformedBoolean,ladderAnalytesInformedBoolean,ladderAnalyteMWOptionInformedBoolean]];

					(* Raise Warning when can't population labels *)
					ladderAnalyteLabelError=And[
						compositionInformedBoolean,
						ladderAnalytesInformedBoolean,
						ladderAnalyteLabelsInformedBoolean,
						ladderAnalyteMWOptionInformedBoolean
					];

					(* MW/composition are informed in model *)
					{
						ladderAnalytes,
						ladderAnalyteMolecularWeights,
						ladderAnalyteLabels
					}=Which[
						(* ladderAnalytes is informed (also applies when both composition and analytes) *)
						ladderAnalytesInformedBoolean,
						{
							ladderAnalytesMW[[All,1]],
							Lookup[myLadderOptions,LadderAnalyteMolecularWeights]/.Automatic:>ladderAnalytesMW[[All,3]],
							Lookup[myLadderOptions,LadderAnalyteLabels]/.Automatic:>ladderAnalytesMW[[All,2]]
						},
						(* only composition is informed *)
						compositionInformedBoolean&&!ladderAnalytesInformedBoolean,
						{
							ladderCompositionMW[[All,1]],
							Lookup[myLadderOptions,LadderAnalyteMolecularWeights]/.Automatic:>ladderCompositionMW[[All,3]],
							Lookup[myLadderOptions,LadderAnalyteLabels]/.Automatic:>ladderCompositionMW[[All,2]]
						},
						(* neither composition nor analytes are informed, User informed MWs option *)
						!compositionInformedBoolean&&!ladderAnalytesInformedBoolean&&ladderAnalyteMWOptionInformedBoolean,
						{
							Lookup[myLadderOptions,LadderAnalytes]/.Automatic:>Null,
							Lookup[myLadderOptions,LadderAnalyteMolecularWeights],
							Lookup[myLadderOptions,LadderAnalyteLabels]/.Automatic:>ToString[ladderAnalytesMWOption]
						},
						(* Only labels are informed *)
						!compositionInformedBoolean&&!ladderAnalytesInformedBoolean&&!ladderAnalyteMWOptionInformedBoolean&&ladderAnalyteLabelsInformedBoolean,
						{
							Lookup[myLadderOptions,LadderAnalytes]/.Automatic:>Null,
							Lookup[myLadderOptions,LadderAnalyteMolecularWeights]/.Automatic:>Null,
							Lookup[myLadderOptions,LadderAnalyteLabels]
						},
						(* catch all option *)
						True,
						{
							Lookup[myLadderOptions,LadderAnalytes]/.Automatic:>Null,
							Lookup[myLadderOptions,LadderAnalyteMolecularWeights]/.Automatic:>Null,
							Lookup[myLadderOptions,LadderAnalyteLabels]/.Automatic:>Null
						}
					];

					(* based on resolution, inform warnings and errors *)
					{
						ladderAnalyteMolecularWeightMismatch,
						ladderCompositionMolecularWeightMismatch,
						ladderAnalytesCompositionMolecularWeightMismatch
					}=Which[
						ladderAnalytesInformedBoolean&&compositionInformedBoolean&&ladderAnalyteMWOptionInformedBoolean,
						{
							!(ContainsAll[ladderAnalyteMolecularWeights,ladderAnalytesMW[[All,3]]]&&
								ContainsAll[ladderAnalytesMW[[All,3]],ladderAnalyteMolecularWeights]),
							!(ContainsAll[ladderAnalyteMolecularWeights,ladderCompositionMW[[All,3]]]&&
								ContainsAll[ladderCompositionMW[[All,3]],ladderAnalyteMolecularWeights]),
							!(ContainsAll[ladderAnalytesMW[[All,3]],ladderCompositionMW[[All,3]]]&&
								ContainsAll[ladderCompositionMW[[All,3]],ladderAnalytesMW[[All,3]]])
						},
						compositionInformedBoolean&&!ladderAnalytesInformedBoolean&&ladderAnalyteMWOptionInformedBoolean,
						{
							False,
							!(ContainsAll[ladderAnalyteMolecularWeights,ladderCompositionMW[[All,3]]]&&
								ContainsAll[ladderCompositionMW[[All,3]],ladderAnalyteMolecularWeights]),
							False
						},
						!compositionInformedBoolean&&ladderAnalytesInformedBoolean&&ladderAnalyteMWOptionInformedBoolean,
						{
							!(ContainsAll[ladderAnalyteMolecularWeights,ladderAnalytesMW[[All,3]]]&&
								ContainsAll[ladderAnalytesMW[[All,3]],ladderAnalyteMolecularWeights]),
							False,
							False
						},
						ladderAnalytesInformedBoolean&&compositionInformedBoolean&&!ladderAnalyteMWOptionInformedBoolean,
						{
							False,
							False,
							!(ContainsAll[ladderAnalytesMW[[All,3]],ladderCompositionMW[[All,3]]]&&
								ContainsAll[ladderCompositionMW[[All,3]],ladderAnalytesMW[[All,3]]])
						},
						True,
						{
							False,
							False,
							False
						}
					];


					(* check if PremadeMasterMix should be True *)
					preMadeMasterMixOptions={
						LadderPremadeMasterMixReagent,LadderPremadeMasterMixDiluent,LadderPremadeMasterMixReagentDilutionFactor,LadderPremadeMasterMixVolume
					};

					includePremadeMasterMixBool=Map[
						MatchQ[#,Except[Automatic|Null|False]]&,
						Lookup[myLadderOptions,preMadeMasterMixOptions]
					];

					resolvePremadeMasterMix=Which[
						MatchQ[Lookup[myLadderOptions,LadderPremadeMasterMix],Except[Automatic]],
						Lookup[myLadderOptions,LadderPremadeMasterMix],
						Or@@includePremadeMasterMixBool,True,
						Lookup[samplesInOptions,PremadeMasterMix],True,
						True,False
					];

					(* PremadeMasterMix split to two branches *)
					{
						(* premade mastermix branch variables *)
						premadeMasterMixReagent,
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
						internalReference,
						internalReferenceDilutionFactor,
						internalReferenceVolume,
						concentratedSDSBuffer,
						concentratedSDSBufferDilutionFactor,
						diluent,
						concentratedSDSBufferVolume,
						sDSBuffer,
						sDSBufferVolume,
						reduction,
						reducingAgent,
						reducingAgentTargetConcentration,
						reducingAgentVolume,
						alkylation,
						alkylatingAgent,
						alkylatingAgentTargetConcentration,
						alkylatingAgentVolume,
						(* make-ones-own mastermix branch variables *)
						internalReferenceNullError,
						internalReferenceDilutionFactorNullError,
						internalReferenceVolumeNullError,
						internalReferenceVolumeDilutionFactorMismatchWarning,
						reducingAgentNullError,
						noReducingAgentIdentifiedWarning,
						reducingAgentTargetConcentrationNullError,
						reducingAgentVolumeNullError,
						reducingAgentVolumeConcentrationMismatchError,
						alkylatingAgentNullError,
						noAlkylatingAgentIdentifiedWarning,
						alkylatingAgentTargetConcentrationNullError,
						alkylatingAgentVolumeNullError,
						alkylatingAgentVolumeConcentrationMismatchError,
						concentratedSDSBufferDilutionFactorNullError,
						sDSBufferNullError,
						bothSDSBranchesSetWarning,
						concentratedSDSBufferDilutionFactorNullError,
						notEnoughSDSinSampleWarning,
						volumeGreaterThanTotalVolumeError,
						componentsDontSumToTotalVolumeError,
						diluentNullError
					}=If[MatchQ[resolvePremadeMasterMix,True],
						(* PremadeMasterMix, no need to get specific reagents *)
						Module[
							{
								masterMixNullError,masterMixDilutionFactorNullError,masterMixVolume,masterMixVolumeNullError,
								masterMixVolumeDilutionFactorMismatchWarning,masterMixTotalVolumeError,mixReagent,mixVolume,
								mixDilutionFactor,masterMixDiluent,masterMixDiluentNullError
							},
							(* gather options *)

							(* check if a reagent was defined for samples and use the same one *)
							mixReagent=Switch[Lookup[myLadderOptions,LadderPremadeMasterMixReagent],
								(* if automatic, set to most common value in sample total Value *)
								Automatic,
								Lookup[samplesInOptions,PremadeMasterMixReagent],
								ObjectP[],
								Lookup[myLadderOptions,LadderPremadeMasterMixReagent],
								Null,Null
							];

							(* gather options and resolve to value in samplesIn, if applicable *)
							mixVolume=Lookup[myLadderOptions,LadderPremadeMasterMixVolume];
							mixDilutionFactor=Lookup[myLadderOptions,LadderPremadeMasterMixReagentDilutionFactor];

							(* check if PremadeMasterMixReagent is informed *)
							masterMixNullError=NullQ[mixReagent];

							(* Resolve PremadeMasterMixVolume *)
							{
								masterMixVolume,
								masterMixDilutionFactor,
								masterMixVolumeNullError,
								masterMixDilutionFactorNullError,
								masterMixVolumeDilutionFactorMismatchWarning
							}=If[Not[masterMixNullError],
								Switch[mixVolume,
									(* If volume is Null, check if Dilution factor is null too, In which case return null and raise errors,*)
									(* If DilutionFactor isnt Null, Raise errors, but return Volume as Automatic would *)
									Null,If[
									NullQ[mixDilutionFactor],
									{Null,Null,
										True,True,False},
									{Null,mixDilutionFactor/.Automatic:>2,
										True,False,False}],
									(* If Volume is passed, all good, if dilution factor is also informed, check that they concur if not, raise warning *)
									VolumeP,
									If[NullQ[mixDilutionFactor],
										{mixVolume,mixDilutionFactor,
											False,False,False},
										{mixVolume,mixDilutionFactor/.Automatic:>(ladderTotalVolume/mixVolume),
											False,False,mixVolume=!=(ladderTotalVolume/(mixDilutionFactor/.Automatic:>(ladderTotalVolume/mixVolume)))}],
									(* if automatic, see if DilutionFactor is informed and calculate volume, if it isnt, grab the volume from samplesIn*)
									Automatic,
									Switch[mixDilutionFactor,
										Null,
										{RoundOptionPrecision[Lookup[samplesInOptions,InternalReferenceVolume]*totalVolumeRatio,10^-1Microliter],
											Null,
											False,False,False},
										Automatic,
										{RoundOptionPrecision[Lookup[samplesInOptions,InternalReferenceVolume]*totalVolumeRatio,10^-1Microliter],
											ladderTotalVolume/RoundOptionPrecision[Lookup[samplesInOptions,InternalReferenceVolume]*totalVolumeRatio,10^-1Microliter],
											False,False,False},
										NumericP,
										{RoundOptionPrecision[(ladderTotalVolume/mixDilutionFactor),10^-1Microliter],
											mixDilutionFactor,
											False,False,False}
									]
								],
								{
									mixVolume/.Automatic:>Null,mixDilutionFactor/.Automatic:>Null,
									False,False,False
								}
							];

							masterMixTotalVolumeError=If[Not[Or[masterMixNullError,masterMixVolumeNullError]],
								(ladderVolume+masterMixVolume)>ladderTotalVolume,
								False];

							(* resolve diluent *)
							masterMixDiluent=Switch[Lookup[myLadderOptions,LadderPremadeMasterMixDiluent],
								Automatic,
								If[NullQ[Lookup[samplesInOptions,PremadeMasterMixDiluent]],
									Model[Sample,"Milli-Q water"],
									Lookup[samplesInOptions,PremadeMasterMixDiluent]
								],
								ObjectP[],
								Lookup[myLadderOptions,LadderPremadeMasterMixDiluent],
								Null,
								Null
							];

							(* if masterMix Diluent is Null but no need to top off to total volume, dont raise an error, otherwise raise an error *)
							masterMixDiluentNullError=(ladderTotalVolume-ladderVolume-masterMixVolume)>0Microliter&&MatchQ[masterMixDiluent,Null];

							(* Gather all resolved options and errors to return *)
							{
								mixReagent,
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
								Lookup[myLadderOptions,LadderInternalReference]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderInternalReferenceDilutionFactor]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderInternalReferenceVolume]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderConcentratedSDSBuffer]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderDiluent]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderConcentratedSDSBufferVolume]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderSDSBuffer]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderSDSBufferVolume]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderReduction]/.Automatic:>True,(* Assume reducing conditions if using mastermix for longer run.. *)
								Lookup[myLadderOptions,LadderReducingAgent]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderReducingAgentTargetConcentration]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderReducingAgentVolume]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderAlkylation]/.Automatic:>False,
								Lookup[myLadderOptions,LadderAlkylatingAgent]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderAlkylatingAgentTargetConcentration]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderAlkylatingAgentVolume]/.Automatic:>Null,
								(* Other branch's errors as False *)
								False,(* intReferenceNullError *)
								False,(* intReferenceDilutionFactorNullError *)
								False,(* intReferenceVolumeNullError *)
								False,(* intReferenceVolumeDilutionFactorMismatchWarning *)
								False,(* mixReducingAgentNullError *)
								False,(* mixNoReducingAgentIdentifiedWarning *)
								False,(* mixReducingAgentTargetConcentrationNullError *)
								False,(* mixReducingAgentVolumeNullError *)
								False,(* mixReducingAgentVolumeConcentrationMismatchError *)
								False,(* mixAlkylatingAgentNullError *)
								False,(* mixNoAlkylatingAgentIdentifiedWarning *)
								False,(* mixAlkylatingAgentTargetConcentrationNullError *)
								False,(* mixAlkylatingAgentVolumeNullError *)
								False,(* mixAlkylatingAgentVolumeConcentrationMismatchError *)
								False,(* resolveMixConcentratedSDSBufferDilutionFactorNullError *)
								False,(* mixSDSBufferNullError *)
								False,(* mixBothSDSBranchesSetWarning *)
								False,(* mixConcentratedSDSBufferDilutionFactorNullError *)
								False,(* mixNotEnoughSDSinSampleWarnin *)
								False,(* mixVolumeGreaterThanTotalVolumeError *)
								False,(* mixComponentsDontSumToTotalVolumeError *)
								False (* mixDiluentNullError *)
							}
						],
						(* no PremadeMasterMix, make your own mastermix *)
						Module[
							{
								mixDiluent,mixInternalReference,
								mixInternalReferenceDilutionFactor,mixInternalReferenceVolume,mixConcentratedSDSBuffer,
								mixConcentratedSDSBufferDilutionFactor,mixConcentratedSDSBufferVolume,mixSDSBufferVolume,
								mixReducingAgent,mixReducingAgentTargetConcentration,mixReducingAgentVolume,mixAlkylatingAgent,
								mixAlkylatingAgentTargetConcentration,mixAlkylatingAgentVolume,intReferenceNullError,intReferenceDilutionFactorNullError,
								intReferenceVolumeDilutionFactorMismatchWarning,reductionOptions,includeReductionOptionBool,
								mixReduction,mixAlkylation,mixReducingAgentNullError,tcep,bme,dtt,ian,alkylationOptions,
								includeAlkylationOptionBool,identifyAlkylatingAgent,
								mixReducingAgentTargetConcentrationNullError,mixReducingAgentVolumeNullError,
								mixReducingAgentVolumeConcentrationMismatchError,mixNoReducingAgentIdentifiedWarning,
								mixAlkylatingAgentNullError,mixNoAlkylatingAgentIdentifiedWarning,
								mixAlkylatingAgentTargetConcentrationNullError,mixAlkylatingAgentVolumeNullError,
								mixAlkylatingAgentVolumeConcentrationMismatchError,mixConcentratedSDSBufferDilutionFactorNullError,
								mixVolumeGreaterThanTotalVolumeError,mixDiluentNullError,mixSDSBuffer,mixComponentsDontSumToTotalVolumeError,
								mixSDSBufferNullError,mixBothSDSBranchesSetWarning,volumeLeft,mixConcentratedSDSBool,mixSDSBool,
								resolveMixConcentratedSDSBuffer,resolveMixConcentratedSDSBufferVolume,resolveMixConcentratedSDSBufferDilutionFactor,
								resolveMixConcentratedSDSBufferDilutionFactorNullError,resolveMixSDSBuffer,resolveMixSDSBufferVolume,
								sdsBufferUserDefinedBool,concentratedSDSUserDefinedBool,sampleSDSBuffer,sampleBufferCompositionIDs,identifySDS,
								sds,sdsObject,bufferVolume,mixNotEnoughSDSinSampleWarning,intReferenceVolumeNullError,internalRefVolume,
								internalRefDilutionFactor,mixReductionVolume,mixAlkylationVolume,mixConcSDSBufferVolume,mixConcSDSBufferDilutionFactor,
								mixReductionConcentration,mixAlkylationConcentration,mixUnconcSDSBufferVolume
							},

							(* Check if internalReference is informed, if not raise error *)
							{
								intReferenceNullError,
								mixInternalReference
							}=Switch[Lookup[myLadderOptions,LadderInternalReference],
								Automatic,{False,Lookup[samplesInOptions,InternalReference]},
								Null,{True,Null},
								ObjectP[],{False,Lookup[myLadderOptions,LadderInternalReference]}
							];

							internalRefVolume=Lookup[myLadderOptions,LadderInternalReferenceVolume];
							internalRefDilutionFactor=Lookup[myLadderOptions,LadderInternalReferenceDilutionFactor];
							(* resolve InternalReference Volume *)
							{
								intReferenceDilutionFactorNullError,
								intReferenceVolumeNullError,
								mixInternalReferenceDilutionFactor,
								mixInternalReferenceVolume
							}=If[Not[ladderTotalVolumeNullError],
								Switch[internalRefVolume,
									VolumeP,
									{False,False,
										internalRefDilutionFactor/.Automatic:>ladderTotalVolume/internalRefVolume,
										internalRefVolume},
									Null,
									{False,True,
										internalRefDilutionFactor/.Automatic:>Null,
										internalRefVolume},
									Automatic,
									Switch[internalRefDilutionFactor,
										Null,
										{False,False,
											Null,
											RoundOptionPrecision[Lookup[samplesInOptions,InternalReferenceVolume]*totalVolumeRatio,10^-1Microliter]},
										Automatic,
										{False,False,
											ladderTotalVolume/(internalRefVolume/.Automatic:>RoundOptionPrecision[Lookup[samplesInOptions,InternalReferenceVolume]*totalVolumeRatio,10^-1Microliter]),
											internalRefVolume/.Automatic:>RoundOptionPrecision[Lookup[samplesInOptions,InternalReferenceVolume]*totalVolumeRatio,10^-1Microliter]},
										GreaterP[0],
										{False,False,internalRefDilutionFactor,
											ladderTotalVolume/internalRefDilutionFactor}
									]
								],
								{False,False,internalRefDilutionFactor/.Automatic:>Null,internalRefVolume/.Automatic:>Null}
							];
							(* if both dilution factor and volume are given, check that they concur *)
							intReferenceVolumeDilutionFactorMismatchWarning=If[NullQ[mixInternalReferenceDilutionFactor]||NullQ[mixInternalReferenceVolume],
								False,
								Abs[mixInternalReferenceVolume-(ladderTotalVolume/mixInternalReferenceDilutionFactor)]>0.1Microliter
							];

							(* resolve reduction *)
							reductionOptions={LadderReducingAgent,LadderReducingAgentTargetConcentration,LadderReducingAgentVolume};
							(*check if any of the reduction options are set*)
							includeReductionOptionBool=Map[
								MatchQ[#,Except[Automatic|Null]]&,
								Lookup[myLadderOptions,reductionOptions]
							];
							(*resolve the Reduction option based on the setting of the others and that of Samples*)
							mixReduction=Which[
								MatchQ[Lookup[myLadderOptions,LadderReduction],Except[Automatic]],
								Lookup[myLadderOptions,LadderReduction],
								Or@@Join[includeReductionOptionBool],True,
								Lookup[samplesInOptions,Reduction],True,
								True,False
							];

							(* if mixReduction is True, resolve related options *)
							{
								mixReducingAgent,
								mixReducingAgentVolume,
								mixReducingAgentTargetConcentration,
								mixReducingAgentNullError,
								mixNoReducingAgentIdentifiedWarning,
								mixReducingAgentTargetConcentrationNullError,
								mixReducingAgentVolumeNullError,
								mixReducingAgentVolumeConcentrationMismatchError
							}=If[mixReduction,
								Module[
									{reducingAgentIdentity,resolveMixReducingAgentNullError,resolveMixReducingAgent,
										resolveMixNoReducingAgentIdentifiedWarning,resolveMixReducingAgentTargetConcentrationNullError,
										resolveMixReducingAgentVolumeNullError,resolveMixReducingAgentTargetConcentration,resolveMixReducingAgentVolume,
										resolveMixReducingAgentVolumeConcentrationMismatchError,targetConcentrationByID
									},
									(* resolve ReducingAgent object - if Automatic, grab whats specified in Samples*)

									{
										resolveMixReducingAgentNullError,
										resolveMixReducingAgent
									}=Switch[Lookup[myLadderOptions,LadderReducingAgent],
										Automatic,
										If[NullQ[Lookup[samplesInOptions,ReducingAgent]],
											{False,Model[Sample,"2-Mercaptoethanol"]},
											{False,Lookup[samplesInOptions,ReducingAgent]}
										],
										ObjectP[],
										{False,Lookup[myLadderOptions,LadderReducingAgent]},
										Null,{True,Null}
									];


									(* to resolve mixReducingAgentTargetConcentration below, need to know which agent is used *)
									reducingAgentIdentity=If[!resolveMixReducingAgentNullError,
										Module[
											{reducingAgentPacket,reducingAgentComposition,reducingAgentCompositionIDs,
												reducingAgentCompositionPackets,identifyReducingAgent},
											reducingAgentPacket=fetchPacketFromCache[Download[resolveMixReducingAgent,Object],optionObjectModelPackets];
											reducingAgentComposition=Lookup[reducingAgentPacket,Composition];
											(* construct list with concentration and molecule composition *)
											reducingAgentCompositionPackets=Map[
												Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
												reducingAgentComposition];
											(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
											reducingAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@reducingAgentCompositionPackets;

											(* Identifiers for DTT,TCEP, and BME based on CAS, synonyms, and InChI *)
											{
												tcep,
												bme,
												dtt
											}={
												{"51805-45-9","Tris(2-carboxyethyl)phosphine hydrochloride","TCEP","TCEP hydrochloride","TCEP-HCl", "Tris(2-carboxyethyl)phosphine",
													"InChI=1S/C9H15O6P/c10-7(11)1-4-16(5-2-8(12)13)6-3-9(14)15/h1-6H2,(H,10,11)(H,12,13)(H,14,15)","PZBFGYYEXUXCOF-UHFFFAOYSA-N",
													"InChI=1/C9H15O6P/c10-7(11)1-4-16(5-2-8(12)13)6-3-9(14)15/h1-6H2,(H,10,11)(H,12,13)(H,14,15)","PZBFGYYEXUXCOF-UHFFFAOYAQ"},
												{"60-24-2","2-Mercaptoethanol","2Mercaptoethanol","BME","beta-mercaptoethanol","betamercaptoethanol","Mercaptoethanol",
													"InChI=1S/C2H6OS/c3-1-2-4/h3-4H,1-2H2","DGVVWUTYPXICAM-UHFFFAOYSA-N","2-Thioethanol","Thioglycol","Thioethylene glycol"},
												{"3483-12-3","DTT","1,4-Dithiothreitol ","DL-Dithiothreitol","D,L-Dithiothreitol","Dithiothreitol","Cleland's reagent",
													"1S/C4H10O2S2/c5-3(1-7)4(6)2-8/h3-8H,1-2H2","VHJLVAABSRFDPM-UHFFFAOYSA-N"}
											};
											(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
											(* Note - this assumes a single reducing agent in the sample; if more, user will need to specify volume *)

											identifyReducingAgent=Map[
												Function[compositionMolecule,
													{
														compositionMolecule[[1]] (* ObjectID *),
														compositionMolecule[[2]] (* Concentration *),
														Which[
															ContainsAny[compositionMolecule[[3]],tcep],"TCEP",
															ContainsAny[compositionMolecule[[3]],bme],"BME",
															ContainsAny[compositionMolecule[[3]],dtt],"DTT"
														]
													}
												],
												reducingAgentCompositionIDs];

											(* pick out cases where the second index in teh list is not null *)
											Cases[identifyReducingAgent,{ObjectP[],_,Except[NullP]}]
										],
										{}];

									(* raise error if no reducing agents or more than one reducing agents were identified *)
									resolveMixNoReducingAgentIdentifiedWarning=If[!resolveMixReducingAgentNullError,
										Length[reducingAgentIdentity]=!=1,
										False];

									(* BME is a liquid, so we need to handle volumePercent, others should be okay with molarity (unless they are in MassPercent, which this does not support at the moment) *)
									targetConcentrationByID=Which[
										Or[resolveMixNoReducingAgentIdentifiedWarning,resolveMixReducingAgentNullError],Null,
										StringMatchQ[reducingAgentIdentity[[1]][[3]],"TCEP"|"DTT"],50 Millimolar,
										(* if BME concentration is stated in volume percent, we need to convert it to molar. assuming 100% is 14.3M *)
										StringMatchQ[reducingAgentIdentity[[1]][[3]],"BME"],
										If[MatchQ[QuantityUnit[reducingAgentIdentity[[1]][[2]]],IndependentUnit["VolumePercent"]],
											(* stock concentration given in volumePercent *)
											4.54545VolumePercent,
											(* Stock Concentration is in Millimolar (As it really should be, even if we're dealing with a liquid) *)
											650 Millimolar],
										True,Null
									];


									mixReductionVolume=Lookup[myLadderOptions,LadderReducingAgentVolume];
									mixReductionConcentration=Lookup[myLadderOptions,LadderReducingAgentTargetConcentration];

									(* resolve ReducingAgentVolume *)
									{
										resolveMixReducingAgentTargetConcentrationNullError,
										resolveMixReducingAgentVolumeNullError,
										resolveMixReducingAgentTargetConcentration,
										resolveMixReducingAgentVolume
										(* first check if the reducing agent was null, if it was, just skip checking the previous error is enough *)
									}=Which[
										resolveMixReducingAgentNullError,
										{False,False,
											mixReductionConcentration/.Automatic:>Null,mixReductionVolume/.Automatic:>Null},
										(* if no identified reducing Agent, still see if there's a valid volume before rasing other errors *)
										NullQ[targetConcentrationByID],
										Switch[mixReductionVolume,
											VolumeP,
											{
												False,False,
												mixReductionConcentration,mixReductionVolume
											},
											Automatic,
											If[Not[NullQ[Lookup[samplesInOptions,ReducingAgentVolume]]],
												{False,False,
													mixReductionConcentration/.Automatic:>Lookup[samplesInOptions,ReducingTargetConcentration],
													mixReductionVolume/.Automatic:>RoundOptionPrecision[Lookup[samplesInOptions,ReducingAgentVolume]*totalVolumeRatio,10^-1Microliter]
												},
												{False,True,
													mixReductionConcentration/.Automatic:>Null,
													mixReductionVolume/.Automatic:>Null
												}],
											Null,
											{
												False,True,
												mixReductionConcentration/.Automatic:>Null,
												Null
											}
											],
										(* if reducingAgentID has a single value, go on.. *)
										!NullQ[targetConcentrationByID],
										Switch[mixReductionVolume,
											Null,
											{
												False,True,
												mixReductionConcentration/.Automatic:>targetConcentrationByID,
												Null
											},
											VolumeP,
											{
												False,False,
												mixReductionConcentration/.Automatic:>reducingAgentIdentity[[1]][[2]]*mixReductionVolume/ladderTotalVolume,
												mixReductionVolume
											},
											Automatic,
											Switch[mixReductionConcentration,
												(* if no target concentration but we can still pull out the volume from Samples In, go for it, assuming we have the same reagent above.. *)
												Null,
												If[Not[NullQ[Lookup[samplesInOptions,ReducingAgentVolume]]]&&MatchQ[Lookup[myLadderOptions,LadderReducingAgent],Lookup[samplesInOptions,ReducingAgent]],
													{
														False,False,
														Null,
														RoundOptionPrecision[Lookup[samplesInOptions,ReducingAgentVolume]*totalVolumeRatio,10^-1Microliter]
													},
													{
														False,False,
														Null,
														Null
													}],
												(* if automatic, we will first check out what the value is in the corresponding samplesIn, if null, grab the value as per usual *)
												Automatic,
												If[Not[resolveMixNoReducingAgentIdentifiedWarning],
													If[Not[NullQ[Lookup[samplesInOptions,ReducingAgentVolume]]]&&MatchQ[Lookup[myLadderOptions,LadderReducingAgent],Lookup[samplesInOptions,ReducingAgent]],
														{
															False,False,
															Lookup[samplesInOptions,ReducingAgentTargetConcentration],
															RoundOptionPrecision[Lookup[samplesInOptions,ReducingAgentVolume]*totalVolumeRatio,10^-1Microliter]
														},
														{
															False,False,
															Lookup[myLadderOptions,LadderReducingAgentTargetConcentration]/.Automatic:>targetConcentrationByID,
															RoundOptionPrecision[(targetConcentrationByID*ladderTotalVolume/reducingAgentIdentity[[1]][[2]]),10^-1Microliter]
														}],
													(* no reducing agent was identified, can't calculate must get volume *)
													{
														True,False,Null,Null
													}
												],
												Except[Null|Automatic],
												If[Not[resolveMixNoReducingAgentIdentifiedWarning],
													(* TargetConcentration set, and reagent concenteration found *)
													{
														False,False,
														mixReductionConcentration,
														RoundOptionPrecision[(mixReductionConcentration*ladderTotalVolume/reducingAgentIdentity[[1]][[2]]),10^-1 Microliter,AvoidZero->True]
													},
													(* cant get the reducing agent concentration from object model, can't calculate volume *)
													{
														False,True,Null,Null
													}
												]
											]
										]];

									(* if both dilution factor and volume are resolved or set, and the reagents concentration is known, check that they concur *)
									resolveMixReducingAgentVolumeConcentrationMismatchError=If[
										Not[Or@@(NullQ[#]&/@{resolveMixReducingAgentTargetConcentration,resolveMixReducingAgentVolume})]&&Not[resolveMixNoReducingAgentIdentifiedWarning],
										Abs[resolveMixReducingAgentVolume-resolveMixReducingAgentTargetConcentration*ladderTotalVolume/reducingAgentIdentity[[1]][[2]]]>0.1Microliter,
										False
									];

									(* return resolved options *)
									{
										resolveMixReducingAgent,
										resolveMixReducingAgentVolume,
										resolveMixReducingAgentTargetConcentration,
										resolveMixReducingAgentNullError,
										resolveMixNoReducingAgentIdentifiedWarning,
										resolveMixReducingAgentTargetConcentrationNullError,
										resolveMixReducingAgentVolumeNullError,
										resolveMixReducingAgentVolumeConcentrationMismatchError
									}
								],
								(* If reduction is false, return nulls*)
								{
									Lookup[myLadderOptions,LadderReducingAgent]/.Automatic:>Null,(* resolveMixReducingAgent *)
									Lookup[myLadderOptions,LadderReducingAgentTargetConcentration]/.Automatic:>Null,(* resolveMixReducingAgentVolume *)
									Lookup[myLadderOptions,LadderReducingAgentVolume]/.Automatic:>Null,(* resolveMixReducingAgentTargetConcentration *)
									False,(* resolveMixReducingAgentNullError *)
									False,(* resolveMixNoReducingAgentIdentifiedWarning *)
									False,(* resolveMixReducingAgentTargetConcentrationNullError *)
									False,(* resolveMixReducingAgentVolumeNullError *)
									False (* resolveMixReducingAgentVolumeConcentrationMismatchError *)
								}
							];


							(* resolve Alkylation *)
							alkylationOptions={LadderAlkylatingAgent,LadderAlkylatingAgentTargetConcentration,LadderAlkylatingAgentVolume};
							(*check if any of the alkylation options are set*)
							includeAlkylationOptionBool=Map[
								MatchQ[#,Except[Automatic|Null]]&,
								Lookup[myLadderOptions,alkylationOptions]
							];
							(*resolve the Alkylation option based on the setting of the others*)
							mixAlkylation=Which[
								MatchQ[Lookup[myLadderOptions,LadderAlkylation],Except[Automatic]],
								Lookup[myLadderOptions,LadderAlkylation],
								Or@@Join[includeAlkylationOptionBool],True,
								Lookup[samplesInOptions,Alkylation],True,
								True,False
							];

							(* if mixAlkylation is True, resolve related options *)
							{
								mixAlkylatingAgent,
								mixAlkylatingAgentVolume,
								mixAlkylatingAgentTargetConcentration,
								mixAlkylatingAgentNullError,
								mixNoAlkylatingAgentIdentifiedWarning,
								mixAlkylatingAgentTargetConcentrationNullError,
								mixAlkylatingAgentVolumeNullError,
								mixAlkylatingAgentVolumeConcentrationMismatchError
							}=If[mixAlkylation,
								Module[{alkylatingAgentIdentity,resolveMixAlkylatingAgentNullError,resolveMixAlkylatingAgent,
									resolveMixNoAlkylatingAgentIdentifiedWarning,resolveMixAlkylatingAgentTargetConcentrationNullError,
									resolveMixAlkylatingAgentVolumeNullError,resolveMixAlkylatingAgentTargetConcentration,resolveMixAlkylatingAgentVolume,
									resolveMixAlkylatingAgentVolumeConcentrationMismatchError,targetConcentrationByID},
									(* resolve AlkylatingAgent object *)
									{
										resolveMixAlkylatingAgentNullError,
										resolveMixAlkylatingAgent
									}=Switch[Lookup[myLadderOptions,LadderAlkylatingAgent],
										Automatic,
										If[NullQ[Lookup[samplesInOptions,AlkylatingAgent]],
											{False,Model[Sample,StockSolution,"250mM Iodoacetamide"]},
											{False,Lookup[samplesInOptions,AlkylatingAgent]}
										],
										ObjectP[],
										{False,Lookup[myLadderOptions,LadderAlkylatingAgent]},
										Null,{True,Null}
									];

									(* to resolve mixAlkylatingAgentTargetConcentration below, need to know which agent is used *)
									alkylatingAgentIdentity=If[!resolveMixAlkylatingAgentNullError,
										Module[
											{alkylatingAgentPacket,alkylatingAgentComposition,alkylatingAgentCompositionIDs,alkylatingAgentCompositionPackets},
											alkylatingAgentPacket=fetchPacketFromCache[Download[resolveMixAlkylatingAgent,Object],optionObjectModelPackets];
											alkylatingAgentComposition=Lookup[alkylatingAgentPacket,Composition];
											(* construct list with concentration and molecule composition *)
											alkylatingAgentCompositionPackets=Map[
												Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
												alkylatingAgentComposition];
											(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
											alkylatingAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@alkylatingAgentCompositionPackets;

											(* Identifiers for IAP based on CAS, synonyms, and InChI *)
											{
												ian
											}={
												{"144-48-9","IAN","2-Iodoacetamide","Iodoacetamide","Iodoacetamide","Monoiodoacetamide","alpha-Iodoacetamide","InChI=1S/C2H4INO/c3-1-2(4)5/h1H2,(H2,4,5)",
													"PGLTVOMIXTUURA-UHFFFAOYSA-N"}
											};
											(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
											(* Note - this assumes a single alkylating agent in the sample; if more, user will need to specify volume *)

											identifyAlkylatingAgent=Map[
												Function[compositionMolecule,
													{
														compositionMolecule[[1]] (* ObjectID *),
														compositionMolecule[[2]] (* Concentration *),
														Which[
															ContainsAny[compositionMolecule[[3]],ian],"IAN"
														]
													}
												],
												alkylatingAgentCompositionIDs];

											(* pick out cases where the second index in teh list is not null *)
											Cases[identifyAlkylatingAgent,{ObjectP[],_,Except[NullP]}]
										],
										{}];


									(* raise error if no reduging agents or more than one Alkylating agents were identified *)
									resolveMixNoAlkylatingAgentIdentifiedWarning=If[!resolveMixAlkylatingAgentNullError,
										Length[alkylatingAgentIdentity]=!=1,
										False];

									(* resolve AlkylatingAgentVolume *)
									targetConcentrationByID=Which[
										Or[resolveMixNoAlkylatingAgentIdentifiedWarning,resolveMixAlkylatingAgentNullError],Null,
										StringMatchQ[alkylatingAgentIdentity[[1]][[3]],"IAN"],11.5 Millimolar,
										True,Null
									];

									mixAlkylationVolume=Lookup[myLadderOptions,LadderAlkylatingAgentVolume];
									mixAlkylationConcentration=Lookup[myLadderOptions,LadderAlkylatingAgentTargetConcentration];

									(* resolve AlkylatingAgentVolume *)
									{
										resolveMixAlkylatingAgentTargetConcentrationNullError,
										resolveMixAlkylatingAgentVolumeNullError,
										resolveMixAlkylatingAgentTargetConcentration,
										resolveMixAlkylatingAgentVolume
										(* first check if the alkylating agent was null, if it was, just skip checking the previous error is enough *)
									}=Which[
										resolveMixAlkylatingAgentNullError,
										{False,False,
											mixAlkylationConcentration/.Automatic:>Null,mixAlkylationVolume/.Automatic:>Null},
										(* if no identified alkylating Agent, still see if there's a valid volume before rasing other errors *)
										NullQ[targetConcentrationByID],
										Switch[mixAlkylationVolume,
											VolumeP,
											{
												False,False,
												mixAlkylationConcentration,mixAlkylationVolume
											},
											Automatic,
											If[Not[NullQ[Lookup[samplesInOptions,AlkylatingAgentVolume]]]&&MatchQ[Lookup[myLadderOptions,LadderAlkylatingAgent],Lookup[samplesInOptions,AlkylatingAgent]],
												{False,False,
													mixAlkylationConcentration/.Automatic:>Lookup[samplesInOptions,AlkylatingTargetConcentration],
													mixAlkylationVolume/.Automatic:>RoundOptionPrecision[Lookup[samplesInOptions,AlkylatingAgentVolume]*totalVolumeRatio,10^-1Microliter]
												},
												{False,True,
													mixAlkylationConcentration/.Automatic:>Null,
													mixAlkylationVolume/.Automatic:>Null
												},
												Null,
												{False,True,
													mixAlkylationConcentration/.Automatic:>Null,
													Null
												}
											]],
										(* if alkylatingAgentID has a single value, go on.. *)
										!NullQ[targetConcentrationByID],
										Switch[mixAlkylationVolume,
											Null,
											{
												False,True,
												mixAlkylationConcentration/.Automatic:>targetConcentrationByID,
												Null
											},
											VolumeP,
											{
												False,False,
												mixAlkylationConcentration/.Automatic:>alkylatingAgentIdentity[[1]][[2]]*mixAlkylationVolume/ladderTotalVolume,
												mixAlkylationVolume
											},
											Automatic,
											Switch[mixAlkylationConcentration,
												(* if no target concentration but we can still pull out the volume from Samples In, go for it, assuming we have the same reagent above.. *)
												Null,
												If[Not[NullQ[Lookup[samplesInOptions,AlkylatingAgentVolume]]]&&MatchQ[Lookup[myLadderOptions,LadderAlkylatingAgent],Lookup[samplesInOptions,AlkylatingAgent]],
													{
														False,False,
														Null,
														RoundOptionPrecision[Lookup[samplesInOptions,AlkylatingAgentVolume]*totalVolumeRatio,10^-1Microliter]
													},
													{
														False,False,
														Null,
														Null
													}],
												(* if automatic, we will first check out what the value is in the corresponding samplesIn, if null, grab the value as per usual *)
												Automatic,
												If[Not[resolveMixNoAlkylatingAgentIdentifiedWarning],
													If[Not[NullQ[Lookup[samplesInOptions,AlkylatingAgentVolume]]],
														{
															False,False,
															alkylatingAgentIdentity[[1]][[2]]*Lookup[samplesInOptions,AlkylatingAgentVolume]/ladderTotalVolume,
															RoundOptionPrecision[Lookup[samplesInOptions,AlkylatingAgentVolume]*totalVolumeRatio,10^-1Microliter]
														},
														{
															False,False,
															Lookup[myLadderOptions,LadderAlkylatingAgentTargetConcentration]/.Automatic:>targetConcentrationByID,
															RoundOptionPrecision[(targetConcentrationByID*ladderTotalVolume/alkylatingAgentIdentity[[1]][[2]]),10^-1Microliter]
														}],
													(* no alkylating agent was identified, can't calculate must get volume *)
													{
														True,False,Null,Null
													}
												],
												Except[Null|Automatic],
												If[Not[resolveMixNoAlkylatingAgentIdentifiedWarning],
													(* TargetConcentration set, and reagent concenteration found *)
													{
														False,False,
														mixAlkylationConcentration,
														RoundOptionPrecision[(mixAlkylationConcentration*ladderTotalVolume/alkylatingAgentIdentity[[1]][[2]]),10^-1 Microliter,AvoidZero->True]
													},
													(* cant get the alkylating agent concentration from object model, can't calculate volume *)
													{
														False,True,Null,Null
													}
												]
											]
										]];

									(* if both TragetConcentration and volume are resolved or set, and the reagents concentration is known, check that they concur *)
									resolveMixAlkylatingAgentVolumeConcentrationMismatchError=If[
										Not[Or@@(NullQ[#]&/@{resolveMixAlkylatingAgentTargetConcentration,resolveMixAlkylatingAgentVolume})]&&Not[resolveMixNoAlkylatingAgentIdentifiedWarning],
										Abs[resolveMixAlkylatingAgentVolume-resolveMixAlkylatingAgentTargetConcentration*ladderTotalVolume/alkylatingAgentIdentity[[1]][[2]]]>0.1Microliter,
										False
									];

									(* return resolved options *)
									{
										resolveMixAlkylatingAgent,
										resolveMixAlkylatingAgentVolume,
										resolveMixAlkylatingAgentTargetConcentration,
										resolveMixAlkylatingAgentNullError,
										resolveMixNoAlkylatingAgentIdentifiedWarning,
										resolveMixAlkylatingAgentTargetConcentrationNullError,
										resolveMixAlkylatingAgentVolumeNullError,
										resolveMixAlkylatingAgentVolumeConcentrationMismatchError
									}
								],
								(* If alkylation is false, return nulls*)
								{
									Lookup[myLadderOptions,LadderAlkylatingAgent]/.Automatic:>Null,(* resolveMixAlkylatingAgent *)
									Lookup[myLadderOptions,LadderAlkylatingAgentTargetConcentration]/.Automatic:>Null,(* resolveMixAlkylatingAgentVolume *)
									Lookup[myLadderOptions,LadderAlkylatingAgentVolume]/.Automatic:>Null,(* resolveMixAlkylatingAgentTargetConcentration *)
									False,(* resolveMixAlkylatingAgentNullError *)
									False,(* resolveMixNoAlkylatingAgentIdentifiedWarning *)
									False,(* resolveMixAlkylatingAgentTargetConcentrationNullError *)
									False,(* resolveMixAlkylatingAgentVolumeNullError *)
									False (* resolveMixAlkylatingAgentVolumeConcentrationMismatchError *)
								}
							];


							(* Resolve ConcentratedSDSBuffer vs SDS Buffer *)
							resolveMixConcentratedSDSBuffer=Switch[Lookup[myLadderOptions,LadderConcentratedSDSBuffer],
								(* if automatic, set to most common value in sample total Value *)
								Automatic,
								If[NullQ[Lookup[samplesInOptions,LadderConcentratedSDSBuffer]],
									Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
									Lookup[samplesInOptions,ConcentratedSDSBuffer]
								],
								ObjectP[],
								Lookup[myLadderOptions,LadderConcentratedSDSBuffer],
								Null,Null
							];

							(* concentratedSDSBuffer branch *)
							mixConcSDSBufferVolume=Lookup[myLadderOptions,LadderConcentratedSDSBufferVolume];
							mixConcSDSBufferDilutionFactor=Lookup[myLadderOptions,LadderConcentratedSDSBufferDilutionFactor];

							{
								resolveMixConcentratedSDSBufferVolume,
								resolveMixConcentratedSDSBufferDilutionFactor,
								resolveMixConcentratedSDSBufferDilutionFactorNullError
							}=If[Not[ladderTotalVolumeNullError]||Not[NullQ[resolveMixConcentratedSDSBuffer]],
								Switch[mixConcSDSBufferVolume,
									Automatic,
									If[Not[NullQ[Lookup[samplesInOptions,ConcentratedSDSBufferVolume]]],
										{
											RoundOptionPrecision[Lookup[samplesInOptions,ConcentratedSDSBufferVolume]*totalVolumeRatio,10^-1Microliter],
											mixConcSDSBufferDilutionFactor/.Automatic:>ladderTotalVolume/RoundOptionPrecision[Lookup[samplesInOptions,ConcentratedSDSBufferVolume]*totalVolumeRatio,10^-1Microliter],
											False
										},
										If[Not[NullQ[mixConcSDSBufferDilutionFactor]],
											{
												RoundOptionPrecision[mixConcSDSBufferVolume/mixConcSDSBufferDilutionFactor,10^-1Microliter],
												mixConcSDSBufferDilutionFactor/.Automatic:>2,
												False
											},
											{
												Null,Null,True
											}]
									],
									(* If ConcentratedSDSBufferVolume is set to value or null, use it *)
									VolumeP,
									{
										mixConcSDSBufferVolume,
										mixConcSDSBufferDilutionFactor/.Automatic:>N[ladderTotalVolume/mixConcSDSBufferVolume],
										False
									},
									Null,
									{
										Null,
										mixConcSDSBufferDilutionFactor/.Automatic:>Null,
										False
									}],
								(* ConcentratedSDSBuffer unresolvable *)
								{
									Lookup[myLadderOptions,LadderConcentratedSDSBufferVolume]/.Automatic:>Null,
									Lookup[myLadderOptions,LadderConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
									False
								}];

							(* SDSBuffer branch *)
							(* in order to calculate how much volume needs to be added *)
							volumeLeft=RoundOptionPrecision[ladderTotalVolume-Total[ReplaceAll[{ladderVolume,mixInternalReferenceVolume,mixReducingAgentVolume,mixAlkylatingAgentVolume},Null->0Microliter]],10^-1 Microliter,AvoidZero->True];                            mixUnconcSDSBufferVolume=Lookup[myLadderOptions,LadderSDSBufferVolume]/.Automatic:>Lookup[samplesInOptions,SDSBufferVolume]*totalVolumeRatio;

							(* resolve LadderSDSBuffer *)
							resolveMixSDSBuffer=Switch[Lookup[myLadderOptions,LadderSDSBuffer],
								(* if automatic, set to most common value in sample total Value *)
								Automatic,
								If[NullQ[Lookup[samplesInOptions,SDSBuffer]],
									Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
									Lookup[samplesInOptions,SDSBuffer]
								],
								ObjectP[],
								Lookup[myLadderOptions,LadderSDSBuffer],
								Null,Null
							];

							(* resolve SDS buffer volume *)
							mixUnconcSDSBufferVolume=Lookup[myLadderOptions,LadderSDSBufferVolume];

							resolveMixSDSBufferVolume=If[Not[NullQ[resolveMixSDSBuffer]],
								Switch[mixUnconcSDSBufferVolume,
									(* If SDSBufferVolume is set to value or null, use it *)
									VolumeP,mixUnconcSDSBufferVolume,
									Automatic,volumeLeft,
									Null,Null
								],
								mixUnconcSDSBufferVolume/.Automatic:>Null
							];

							(* Figure out which branch to continue with ConcentratedSDSBuffer vs SDSBuffer*)
							(* first, figure out which branch can be resolved, if both can, and all are automatic, choose ConcentratedSDS *)
							mixConcentratedSDSBool=!NullQ[resolveMixConcentratedSDSBuffer]&&!NullQ[resolveMixConcentratedSDSBufferVolume];
							mixSDSBool=!NullQ[resolveMixSDSBuffer]&&!NullQ[resolveMixSDSBufferVolume];

							(* if no SDS buffer specified, raise an error *)
							mixSDSBufferNullError=NullQ[resolveMixConcentratedSDSBuffer]&&NullQ[resolveMixSDSBuffer];

							(* check which branch is user defined *)
							concentratedSDSUserDefinedBool=Or@@(MatchQ[Lookup[myLadderOptions,#],Except[Null|Automatic]]&/@{LadderConcentratedSDSBuffer,LadderConcentratedSDSBufferVolume,LadderConcentratedSDSBufferDilutionFactor});
							sdsBufferUserDefinedBool=Or@@(MatchQ[Lookup[myLadderOptions,#],Except[Null|Automatic]]&/@{LadderSDSBuffer,LadderSDSBufferVolume});

							(* if both branches can be successfully resolved, raise a warning (would pick either ConcentratedSDSBuffer, or the branch that was filled by user *)
							mixBothSDSBranchesSetWarning=mixConcentratedSDSBool&&mixSDSBool&&concentratedSDSUserDefinedBool&&sdsBufferUserDefinedBool;

							{
								mixConcentratedSDSBuffer,
								mixConcentratedSDSBufferVolume,
								mixConcentratedSDSBufferDilutionFactor,
								mixConcentratedSDSBufferDilutionFactorNullError,
								mixSDSBuffer,
								mixSDSBufferVolume
							}=Which[
								(* both buffers are Null *)
								mixSDSBufferNullError,
								{
									Lookup[myLadderOptions,LadderConcentratedSDSBuffer]/.Automatic:>Null,
									Lookup[myLadderOptions,LadderConcentratedSDSBufferVolume]/.Automatic:>Null,
									Lookup[myLadderOptions,LadderConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
									False,
									Lookup[myLadderOptions,LadderSDSBuffer]/.Automatic:>Null,
									Lookup[myLadderOptions,LadderSDSBufferVolume]/.Automatic:>Null
								},
								(* If ConcentratedSDS is user informed, but invalid *)
								!mixConcentratedSDSBool&&concentratedSDSUserDefinedBool,
								{
									Lookup[myLadderOptions,LadderConcentratedSDSBuffer]/.Automatic:>Null,
									Lookup[myLadderOptions,LadderConcentratedSDSBufferVolume]/.Automatic:>Null,
									Lookup[myLadderOptions,LadderConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
									True,
									Lookup[myLadderOptions,LadderSDSBuffer]/.Automatic:>Null,
									Lookup[myLadderOptions,LadderSDSBufferVolume]/.Automatic:>Null
								},
								(* if only concentratedSDS is resolved *)
								mixConcentratedSDSBool&&!mixSDSBool,
								{
									resolveMixConcentratedSDSBuffer,
									resolveMixConcentratedSDSBufferVolume,
									resolveMixConcentratedSDSBufferDilutionFactor,
									resolveMixConcentratedSDSBufferDilutionFactorNullError,
									Lookup[myLadderOptions,LadderSDSBuffer]/.Automatic:>Null,
									Lookup[myLadderOptions,LadderSDSBufferVolume]/.Automatic:>Null
								},
								(* if only SDSBuffer is resolved *)
								!mixConcentratedSDSBool&&mixSDSBool,
								{
									Lookup[myLadderOptions,LadderConcentratedSDSBuffer]/.Automatic:>Null,
									Lookup[myLadderOptions,LadderConcentratedSDSBufferVolume]/.Automatic:>Null,
									Lookup[myLadderOptions,LadderConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
									False,
									resolveMixSDSBuffer,
									resolveMixSDSBufferVolume
								},
								(* If both branches resolved, check which one is user informed and return that one, alternatively, return ConcentratedSDS *)
								mixConcentratedSDSBool&&mixSDSBool,
								(* ConcentratedSDS is user informed *)
								Which[
									concentratedSDSUserDefinedBool@@!sdsBufferUserDefinedBool,
									{
										resolveMixConcentratedSDSBuffer,
										resolveMixConcentratedSDSBufferVolume,
										resolveMixConcentratedSDSBufferDilutionFactor,
										resolveMixConcentratedSDSBufferDilutionFactorNullError,
										Lookup[myLadderOptions,LadderSDSBuffer]/.Automatic:>Null,
										Lookup[myLadderOptions,LadderSDSBufferVolume]/.Automatic:>Null
									},
									(* SDSBuffer is user informed *)
									sdsBufferUserDefinedBool&&!concentratedSDSUserDefinedBool,
									{
										Lookup[myLadderOptions,LadderConcentratedSDSBuffer]/.Automatic:>Null,
										Lookup[myLadderOptions,LadderConcentratedSDSBufferVolume]/.Automatic:>Null,
										Lookup[myLadderOptions,LadderConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
										resolveMixConcentratedSDSBufferDilutionFactorNullError,
										resolveMixSDSBuffer,
										resolveMixSDSBufferVolume
									},
									(* Neither is user informed, go on with ConcentratedSDS *)
									True,
									{
										resolveMixConcentratedSDSBuffer,
										resolveMixConcentratedSDSBufferVolume,
										resolveMixConcentratedSDSBufferDilutionFactor,
										resolveMixConcentratedSDSBufferDilutionFactorNullError,
										Lookup[myLadderOptions,LadderSDSBuffer]/.Automatic:>Null,
										Lookup[myLadderOptions,LadderSDSBufferVolume]/.Automatic:>Null
									}
								]
							];

							(* check the amount of SDS added to sample, warn if below 0.5% *)

							(* grab the SDSbuffer that is not Null, if any.. *)
							sampleSDSBuffer=If[!mixSDSBufferNullError&&Not[ladderTotalVolumeNullError],
								First[Cases[{mixConcentratedSDSBuffer,mixSDSBuffer},ObjectP[]]],
								Null];

							(* fetch packet and pull out SDS *)
							sampleBufferCompositionIDs=If[!mixSDSBufferNullError&&Not[ladderTotalVolumeNullError],
								Module[{sampleBufferPacket,sampleBufferComposition,sampleBufferCompositionPackets},
									sampleBufferPacket=fetchPacketFromCache[Download[sampleSDSBuffer,Object],optionObjectModelPackets];
									sampleBufferComposition=Lookup[sampleBufferPacket,Composition,{}];
									(* construct list with concentration and molecule composition *)
									sampleBufferCompositionPackets=Map[
										Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
										sampleBufferComposition];
									(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
									{Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@sampleBufferCompositionPackets
								],
								{}];

							(* Identifiers for SDS *)
							sds={"Sodium dodecyl sulfate","SDS","Sodium lauryl sulfate","151-21-3",
								"InChI=1S/C12H26O4S.Na/c1-2-3-4-5-6-7-8-9-10-11-12-16-17(13,14)15;/h2-12H2,1H3,(H,13,14,15);/q;+1/p-1",
								"InChI=1S/C12H26O4S.Na/c1-2-3-4-5-6-7-8-9-10-11-12-16-17(13,14)15;/h2-12H2,1H3,(H,13,14,15);/q;+1/p-1",
								"DBMJMQXJHONAFJ-UHFFFAOYSA-M"};

							(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
							(* Note - this assumes a single reducing agent in the sample; if more, user will need to specify volume *)

							identifySDS=If[!MatchQ[sampleBufferCompositionIDs,{}],
								Map[Function[compositionMolecule,
									{
										compositionMolecule[[1]] (* ObjectID *),
										compositionMolecule[[2]] (* Concentration *),
										Which[
											ContainsAny[compositionMolecule[[3]],sds],"SDS"
										]
									}
								],
									sampleBufferCompositionIDs],
								Null
							];


							(* pick out cases where the second index in the list is not null *)
							sdsObject=If[!NullQ[identifySDS],
								Cases[identifySDS,{ObjectP[],_,Except[NullP]}],
								Null];

							bufferVolume=If[And[!NullQ[identifySDS],Or[!NullQ[mixConcentratedSDSBufferVolume],!NullQ[mixSDSBufferVolume]]],
								First[Cases[{mixConcentratedSDSBufferVolume,mixSDSBufferVolume},VolumeP]],
								Null];

							mixNotEnoughSDSinSampleWarning=Which[
								(* missing total volume*)
								ladderTotalVolumeNullError,False,
								(* no valid buffer *)
								NullQ[mixConcentratedSDSBufferVolume]&&NullQ[mixSDSBufferVolume],False,
								(* no SDS identified in buffer *)
								MatchQ[sdsObject,{}],True,
								(* there's something there.. *)
								QuantityUnit[First[sdsObject][[2]]]==IndependentUnit["MassPercent"],
								First[sdsObject][[2]]*bufferVolume/ladderTotalVolume<0.5 MassPercent,
								MatchQ[Convert[First[sdsObject][[2]],Gram/Milliliter],Except[$Failed]],
								First[sdsObject][[2]]*bufferVolume/ladderTotalVolume<0.005 Gram/Milliliter,
								MatchQ[Convert[First[sdsObject][[2]],Millimolar],Except[$Failed]],
								First[sdsObject][[2]]*bufferVolume/ladderTotalVolume<17.3 Millimolar,
								True,False
							];

							(* resolve Diluent, if needed *)
							mixDiluent=Which[
								(* missing total volume*)
								ladderTotalVolumeNullError,Lookup[myLadderOptions,LadderDiluent]/.Automatic:>Null,
								(* If no SDS buffer is available *)
								mixSDSBufferNullError,Lookup[myLadderOptions,LadderDiluent]/.Automatic:>Null,
								(* if ConcentratedSDSBuffer is specified but Dilution Factor is Null *)
								mixConcentratedSDSBufferDilutionFactorNullError,Lookup[myLadderOptions,LadderDiluent]/.Automatic:>Null,
								(* if everything else is valid, we can just pick a diluent, regardless of whether or not we
								will end up using it (calculating volume later). This is different from how we resolve for samples and standards/blanks
								 so we can handle either using what samplesIn use or water as a default *)
								True,Switch[Lookup[myLadderOptions,LadderDiluent],
									(* if automatic, set to most common value in sample total Value *)
									Automatic,
									If[NullQ[Lookup[samplesInOptions,Diluent]],
										Model[Sample,"Milli-Q water"],
										Lookup[samplesInOptions,Diluent]
									],
									ObjectP[],
									Lookup[myLadderOptions,LadderDiluent],
									Null,Null
								]];

							{
								mixVolumeGreaterThanTotalVolumeError,
								mixComponentsDontSumToTotalVolumeError
							}=Which[
								(* missing total volume*)
								ladderTotalVolumeNullError,
								{False,False},
								(* If no SDS buffer is available *)
								mixSDSBufferNullError,
								{False,False},
								(* if ConcentratedSDSBuffer is specified but Dilution Factor is Null *)
								mixConcentratedSDSBufferDilutionFactorNullError,
								{False,False},
								(* if on ConcentratedSDS branch or if both are user defined *)
								Or[(!NullQ[mixConcentratedSDSBuffer]&&NullQ[mixSDSBuffer]),mixBothSDSBranchesSetWarning],
								Which[
									(* if there's no room for more liquid, no need for a diluent *)
									(volumeLeft-mixConcentratedSDSBufferVolume)==0Microliter,{False,False},
									(* If there's room, use diluent, if not set, use water *)
									(volumeLeft-mixConcentratedSDSBufferVolume)>0Microliter,{False,False},
									(* if we're over the TotalVolume, raise an error *)
									(volumeLeft-mixConcentratedSDSBufferVolume)<0Microliter,{True,False}
								],
								(* if on SDSBuffer branch *)
								NullQ[mixConcentratedSDSBuffer]&&!NullQ[mixSDSBuffer],
								Which[
									(* if we're at the TotalVolume, We're All good *)
									(volumeLeft-mixSDSBufferVolume)==0Microliter,{False,False},
									(* if we're below the TotalVolume, raise an error (the volume of SDSBuffer is not enough to fill *)
									(volumeLeft-mixSDSBufferVolume)>0Microliter,{False,True},
									(* if we're over the TotalVolume, raise an error *)
									(volumeLeft-mixSDSBufferVolume)<0Microliter,{True,False}
								]
							];

							(* if need a diluent and it is set to Null, raise Error and set to water *)
							mixDiluentNullError=Which[
								mixConcentratedSDSBufferDilutionFactorNullError,
								False,
								NullQ[mixSDSBuffer]&&!NullQ[mixConcentratedSDSBuffer],
								(volumeLeft-mixConcentratedSDSBufferVolume)>0*Microliter&&MatchQ[mixDiluent,Null],
								!NullQ[mixSDSBuffer]&&NullQ[mixConcentratedSDSBuffer],
								False,
								True,
								False
							];

							(* Gather all resolved options and errors to return *)
							{
								(* PremadeMasterMix branch's options as Null *)
								Lookup[myLadderOptions,LadderPremadeMasterMixReagent]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderPremadeMasterMixVolume]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderPremadeMasterMixReagentDilutionFactor]/.Automatic:>Null,
								Lookup[myLadderOptions,LadderPremadeMasterMixDiluent]/.Automatic:>Null,
								(* PremadeMasterMix branch's errors as False *)
								False,(* masterMixNullError *)
								False,(* masterMixDilutionFactorNullError *)
								False,(* masterMixVolumeNullError *)
								False,(* masterMixVolumeDilutionFactorMismatchWarning *)
								False,(* masterMixTotalVolumeError *)
								False,(* masterMixDiluentNullError*)
								(* make-your-own mix branch's options *)
								mixInternalReference,
								mixInternalReferenceDilutionFactor,
								mixInternalReferenceVolume,
								mixConcentratedSDSBuffer,
								mixConcentratedSDSBufferDilutionFactor,
								mixDiluent,
								mixConcentratedSDSBufferVolume,
								mixSDSBuffer,
								mixSDSBufferVolume,
								mixReduction,
								mixReducingAgent,
								mixReducingAgentTargetConcentration,
								mixReducingAgentVolume,
								mixAlkylation,
								mixAlkylatingAgent,
								mixAlkylatingAgentTargetConcentration,
								mixAlkylatingAgentVolume,
								(* make-your-own mix branch's errors  *)
								intReferenceNullError,
								intReferenceDilutionFactorNullError,
								intReferenceVolumeNullError,
								intReferenceVolumeDilutionFactorMismatchWarning,
								mixReducingAgentNullError,
								mixNoReducingAgentIdentifiedWarning,
								mixReducingAgentTargetConcentrationNullError,
								mixReducingAgentVolumeNullError,
								mixReducingAgentVolumeConcentrationMismatchError,
								mixAlkylatingAgentNullError,
								mixNoAlkylatingAgentIdentifiedWarning,
								mixAlkylatingAgentTargetConcentrationNullError,
								mixAlkylatingAgentVolumeNullError,
								mixAlkylatingAgentVolumeConcentrationMismatchError,
								resolveMixConcentratedSDSBufferDilutionFactorNullError,
								mixSDSBufferNullError,
								mixBothSDSBranchesSetWarning,
								mixConcentratedSDSBufferDilutionFactorNullError,
								mixNotEnoughSDSinSampleWarning,
								mixVolumeGreaterThanTotalVolumeError,
								mixComponentsDontSumToTotalVolumeError,
								mixDiluentNullError
							}
						]
					];

					(* InjectoinVoltageProfile *)
					injectionVoltageDurationProfile=Lookup[myLadderOptions,LadderInjectionVoltageDurationProfile]/.
						Automatic:>Lookup[samplesInOptions,InjectionVoltageDurationProfile];

					(* resolve SeparationVoltageDurationProfile *)
					separationVoltageDurationProfile=Which[
						(* if separationProfile is Automatic, grab from samplesIn *)
						MatchQ[Lookup[myLadderOptions,LadderSeparationVoltageDurationProfile],Automatic],Lookup[samplesInOptions,SeparationVoltageDurationProfile],
						(* if separationProfile is user specified, use it *)
						MatchQ[Lookup[myLadderOptions,LadderSeparationVoltageDurationProfile],{{VoltageP,TimeP}..}],Lookup[myLadderOptions,LadderSeparationVoltageDurationProfile]
					];

					(* All sample branches gather here; resolve SupernatantVolume *)
					supernatantVolume=If[resolvedIncludeCentrifugation,
						Switch[
							Lookup[myLadderOptions,LadderSedimentationSupernatantVolume],
							Automatic,RoundOptionPrecision[Lookup[samplesInOptions,SedimentationSupernatantVolume]*totalVolumeRatio,10^-1 Microliter,AvoidZero->True],
							Except[Automatic],Lookup[myLadderOptions,LadderSedimentationSupernatantVolume]
						],
						Lookup[myLadderOptions,LadderSedimentationSupernatantVolume]/.Automatic:>Null;
					];
					(* check if resolved value is larger than TotalVolume or Null *)
					supernatantVolumeInvalidError=If[resolvedIncludeCentrifugation,
						Or[NullQ[supernatantVolume],supernatantVolume>totalVolume],
						False
					];

					(* Gather MapThread results *)
					{
						(*1*)
						(*2*)ladderAnalytes,
						(*3*)ladderAnalyteMolecularWeights,
						(*4*)ladderAnalyteLabels,
						(*5*)ladderTotalVolume,
						(*6*)ladderDilutionFactor,
						(*7*)ladderVolume,
						(*8*)ladderFrequency,
						(*9*)(* errors *)
						(*10*)ladderTotalVolumeNullError,
						(*11*)ladderVolumeNullError,
						(*12*)ladderDilutionFactorNullError,
						(*13*)ladderAnalyteMolecularWeightMismatch,
						(*14*)ladderCompositionMolecularWeightMismatch,
						(*15*)ladderAnalytesCompositionMolecularWeightMismatch,
						(*16*)ladderAnalyteLabelError,
						(*17*)molecularWeightMissingInModelWarning,
						(*18*)(* option variables *)
						(*19*)supernatantVolume,
						(*20*)separationVoltageDurationProfile,
						(*21*)injectionVoltageDurationProfile,
						(*31*)(* General options errors *)
						(*32*)missingSampleCompositionWarning,
						(*33*)supernatantVolumeInvalidError,
						(*36*)(* premade mastermix branch variables *)
						(*37*)resolvePremadeMasterMix,
						(*38*)premadeMasterMixReagent,
						(*39*)premadeMasterMixVolume,
						(*40*)premadeMasterMixDilutionFactor,
						(*41*)premadeMasterMixDiluent,
						(*42*)(* premade mastermix branch errors *)
						(*43*)premadeMasterMixNullError,
						(*44*)premadeMasterMixDilutionFactorNullError,
						(*45*)premadeMasterMixVolumeNullError,
						(*46*)premadeMasterMixVolumeDilutionFactorMismatchWarning,
						(*47*)premadeMasterMixTotalVolumeError,
						(*48*)premadeMasterMixDiluentNullError,
						(*49*)(* make-ones-own mastermix branch variables *)
						(*50*)internalReference,
						(*51*)internalReferenceDilutionFactor,
						(*52*)internalReferenceVolume,
						(*53*)concentratedSDSBuffer,
						(*54*)concentratedSDSBufferDilutionFactor,
						(*55*)diluent,
						(*56*)concentratedSDSBufferVolume,
						(*57*)sDSBuffer,
						(*58*)sDSBufferVolume,
						(*59*)reduction,
						(*60*)reducingAgent,
						(*61*)reducingAgentTargetConcentration,
						(*62*)reducingAgentVolume,
						(*63*)alkylation,
						(*64*)alkylatingAgent,
						(*65*)alkylatingAgentTargetConcentration,
						(*66*)alkylatingAgentVolume,
						(*67*)(* make-ones-own mastermix branch errors *)
						(*68*)internalReferenceNullError,
						(*69*)internalReferenceDilutionFactorNullError,
						(*70*)internalReferenceVolumeNullError,
						(*71*)internalReferenceVolumeDilutionFactorMismatchWarning,
						(*72*)reducingAgentNullError,
						(*73*)noReducingAgentIdentifiedWarning,
						(*74*)reducingAgentTargetConcentrationNullError,
						(*75*)reducingAgentVolumeNullError,
						(*76*)reducingAgentVolumeConcentrationMismatchError,
						(*77*)alkylatingAgentNullError,
						(*78*)noAlkylatingAgentIdentifiedWarning,
						(*79*)alkylatingAgentTargetConcentrationNullError,
						(*80*)alkylatingAgentVolumeNullError,
						(*81*)alkylatingAgentVolumeConcentrationMismatchError,
						(*82*)sDSBufferNullError,
						(*83*)bothSDSBranchesSetWarning,
						(*84*)concentratedSDSBufferDilutionFactorNullError,
						(*85*)notEnoughSDSinSampleWarning,
						(*86*)volumeGreaterThanTotalVolumeError,
						(*87*)componentsDontSumToTotalVolumeError,
						(*88*)diluentNullError
					}
				]
			],
			(* we are passing the injection table volumes directly to the mapthread to handle sampleVolume resolution in the right sample order *)
			{resolvedLadders,mapThreadFriendlyLadderOptions,ladderMapFriendlySamplesInResolvedOptions,roundedInjectionTableLadderVolumes}
		]],
		(* If no Ladders, resolve all options as Null *)
		Join[ReplaceAll[
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,{
				LadderAnalytes,
				LadderAnalyteMolecularWeights,
				LadderAnalyteLabels,
				LadderTotalVolume,
				LadderDilutionFactor,
				LadderVolume,
				LadderFrequency
			}],
			Automatic:>Null
		],
			ConstantArray[False,8],
			ReplaceAll[
				Lookup[roundedCapillaryGelElectrophoresisSDSOptions,{
					LadderSedimentationSupernatantVolume,
					LadderSeparationVoltageDurationProfile,
					LadderInjectionVoltageDurationProfile
				}],
				Automatic:>Null
			],
			ConstantArray[False,2],
			ReplaceAll[
				Lookup[roundedCapillaryGelElectrophoresisSDSOptions,{
					LadderPremadeMasterMix,
					LadderPremadeMasterMixReagent,
					LadderPremadeMasterMixVolume,
					LadderPremadeMasterMixReagentDilutionFactor,
					LadderPremadeMasterMixDiluent
				}],
				Automatic:>Null
			],
			ConstantArray[False,6],
			ReplaceAll[
				Lookup[roundedCapillaryGelElectrophoresisSDSOptions,{
					LadderInternalReference,
					LadderInternalReferenceDilutionFactor,
					LadderInternalReferenceVolume,
					LadderConcentratedSDSBuffer,
					LadderConcentratedSDSBufferDilutionFactor,
					LadderDiluent,
					LadderConcentratedSDSBufferVolume,
					LadderSDSBuffer,
					LadderSDSBufferVolume,
					LadderReduction,
					LadderReducingAgent,
					LadderReducingAgentTargetConcentration,
					LadderReducingAgentVolume,
					LadderAlkylation,
					LadderAlkylatingAgent,
					LadderAlkylatingAgentTargetConcentration,
					LadderAlkylatingAgentVolume
				}],
				Automatic:>Null
			],
			ConstantArray[False,21]
		]
	];


	(* Prepare for Standard and Blank mapThread *)

	(*retrieve all of the options that index match to Standards*)
	(* Making two versions so that only options with Automatic can trigger IncludeStandards *)
	standardOptionList="OptionName"/.
		Cases[OptionDefinition[ExperimentCapillaryGelElectrophoresisSDS],
			KeyValuePattern["IndexMatchingParent"->"Standards"]];

	standardOptionList=ToExpression[#]&/@standardOptionList;


	includeStandardOptionBool=Map[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,#],Except[getDefault[#,opsDef]|Automatic|Null|False]]&,
		standardOptionList
	];

	standardInInjectionTableBool=If[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],Except[Automatic|Null]],
		MemberQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable][[All,1]],Standard],
		False];

	(*resolve the IncludeStandard option based on the setting of the others*)
	resolveIncludeStandards=Which[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,IncludeStandards],Except[Automatic]],
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,IncludeStandards],
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
					Map[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,#]&,standardOptionList]
				]
			}]
		],
		(* not doing standards, dont worry about it *)
		0
	];

	(* if standards are set, grab them, if not, but resolveIncludestandards = True, grab from injectionTable, if no injection table, grab default standard *)
	resolvedStandards=Which[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Standards],Except[Automatic|{Automatic..}]],
		(* if only one was specified but we actually need more, give them what they want.. *)
		If[MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Standards], ObjectP[]],
			ConstantArray[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Standards],requiredStandards],
			(* still replacing automatics in case theres a mix of objects and automatics *)
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Standards]/.Automatic:>Model[Sample,StockSolution, "Resuspended CESDS IgG Standard"]
		],
		resolveIncludeStandards,
		If[MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],Except[Automatic|Null]],
			Select[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],MatchQ[First[#],Standard]&][[All,2]],
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Standards]/.Automatic:>Model[Sample,StockSolution, "Resuspended CESDS IgG Standard"]],
		True,Null
	];

	(* to make sure we expend all relevant options in a flexible way, preexpend and then listify accordingly *)
	preexpandedStandardsOptions=If[!resolveIncludeStandards,
		Association[#->Null&/@standardOptionList],
		Last[ExpandIndexMatchedInputs[
			ExperimentCapillaryGelElectrophoresisSDS,
			{mySamples},
			Normal[Append[
				KeyTake[roundedCapillaryGelElectrophoresisSDSOptions,standardOptionList],
				Standards->resolvedStandards
			]],
			Messages->False
		]]
	];

	{resolvedStandards,expandedStandardsOptions}=If[And[
		Depth[Lookup[preexpandedStandardsOptions,Standards]]<=2,
		MatchQ[Lookup[preexpandedStandardsOptions,Standards],Except[{}|Null]]
	],
		{
			ToList[Lookup[preexpandedStandardsOptions,Standards]],
			Map[(First[#]->List[Last[#]]) &,preexpandedStandardsOptions]
		},
		(*if not the singleton case, then nothing to change*)
		{
			Lookup[preexpandedStandardsOptions,Standards],
			preexpandedStandardsOptions
		}
	];

	(* Informing volumes from the injection table runs the risk of it not being copacetic with specified samples/ladders/standards/blanks *)
	(* to avoid this breaking the mapthread, make sure ladders are copacetic, and if not, inform volume from sampleVolume *)
	injectionTableStandardNotCopaceticQ=If[MatchQ[specifiedInjectionTable,Except[Automatic]],
		Not[Or[
			MatchQ[resolvedStandards,Null|Automatic|{Automatic..}],
			And[
				ContainsAll[
					Cases[specifiedInjectionTable,{Standard,ObjectP[],VolumeP|Automatic}][[All,2]],
					Cases[resolvedStandards,ObjectP[]]
				],
				ContainsAll[
					Cases[resolvedStandards,ObjectP[]],
					Cases[specifiedInjectionTable,{Standard,ObjectP[],VolumeP|Automatic}][[All,2]]
				]
			]]],
		False
	];

	(* if there is a user specified an injection table, and if they did, grab volumes to pass to the mapthread  *)
	injectionTableStandardVolumes=If[Not[injectionTableStandardNotCopaceticQ],
		Switch[specifiedInjectionTable,
			{{_,ObjectP[],VolumeP|Automatic}..},Cases[specifiedInjectionTable,{Standard,ObjectP[],VolumeP|Automatic}][[All,3]],
			Automatic,ConstantArray[Automatic,Length[resolvedStandards]]
		],
		(* If samples in injection tables dont match Standard, dont inform volume, we'll raise an error a bit later *)
		ToList[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,StandardVolume]]
	];

	(* we need to account for a situation where the injection table is not in agreement with samplesIn and options.
there is an error check later, but we want to make sure we dont break the MapThread *)
	lengthCorrectedInjectionTableStandardVolumes=If[Length[injectionTableStandardVolumes]!=Length[resolvedStandards],
		ConstantArray[Automatic,Length[resolvedStandards]],
		injectionTableStandardVolumes
	];

	(* round volumes *)
	roundedInjectionTableStandardVolumes=RoundOptionPrecision[lengthCorrectedInjectionTableStandardVolumes,10^-1Microliter];

	(* now we can figure out the options that are specific for standards *)
	resolvedStandardsPackets=fetchPacketFromCache[#,optionObjectModelPackets]&/@resolvedStandards;

	(*rename the keys in the option set*)
	keyStandardNames=Keys[expandedStandardsOptions];

	(*remove the Standard the Blank prepend for the for the key*)
	keyStandardNamesPrependRemoved=ToExpression/@StringReplace[ToString/@keyStandardNames,{"Standard"->""}];

	renamedStandardOptionSet=Association[MapThread[Rule,{keyStandardNamesPrependRemoved,Values@expandedStandardsOptions}]];

	(* prep options for mapThread *)
	mapThreadFriendlyStandardOptions=If[resolveIncludeStandards,
		Transpose[Association[renamedStandardOptionSet],AllowedHeads->{Association,List}],
		renamedStandardOptionSet
	];


	(*retrieve all of the options that index match to Blanks*)
	(* Making two versions so that only options with Automatic can trigger IncludeBlanks *)


	blankOptionList="OptionName"/.
		Cases[OptionDefinition[ExperimentCapillaryGelElectrophoresisSDS],
			KeyValuePattern["IndexMatchingParent"->"Blanks"]
		];

	blankOptionList=ToExpression[#]&/@blankOptionList;

	(*check if any of the Blank options are set*)
	includeBlankOptionBool=Map[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,#],Except[getDefault[#,opsDef]|Automatic|Null|False]]&,
		blankOptionList
	];


	blanksInInjectionTableBool=If[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],Except[Automatic|Null]],
		MemberQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable][[All,1]],Blank],
		False];

	(*resolve the IncludeBlank option based on the setting of the others*)
	resolveIncludeBlanks=Which[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,IncludeBlanks],Except[Automatic]],
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,IncludeBlanks],
		(* if a standard is specified in the injection table *)
		blanksInInjectionTableBool,True,
		Or@@includeBlankOptionBool,True,
		True,False
	];

	(* To figure out how many standards we need to have, grab the length of any specified option and use the longest to resolve the number of standards *)
	requiredBlanks = If[resolveIncludeBlanks,
		(* if we have any relevant options specified, get their length and return the longest or just 1 *)
		Max[
			Flatten[{
				1,
				Map[
					Function[option, Length[ToList[option]]],
					Map[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,#]&,blankOptionList]
				]
			}]
		],
		(* not doing standards, dont worry about it *)
		0
	];

	(* if blanks are set, grab them, if not, but resolveIncludeBlanks = True, grab from injectionTable, if no injection table, grab default blank *)
	resolvedBlanks=Which[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Blanks],Except[Automatic|{Automatic..}]],
		If[MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Blanks], ObjectP[]],
			ConstantArray[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Blanks],requiredBlanks],
			(* still replacing automatics in case theres a mix of objects and automatics *)
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Blanks]/.Automatic:>Model[Sample,"1% SDS in 100mM Tris, pH 9.5"]
		],
		resolveIncludeBlanks,
		If[MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],Except[Automatic|Null]],
			Select[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],MatchQ[First[#],Blank]&][[All,2]],
			ConstantArray[Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],requiredBlanks]
		],
		True,Null
	];

	(* to make sure we expend all relevant options in a flexible way, preexpend and then listify accordingly *)
	preexpandedBlanksOptions=If[!resolveIncludeBlanks,
		Association[#->Null&/@blankOptionList],
		Last[ExpandIndexMatchedInputs[
			ExperimentCapillaryGelElectrophoresisSDS,
			{mySamples},
			Normal[Append[
				KeyTake[roundedCapillaryGelElectrophoresisSDSOptions,blankOptionList],
				Blanks->resolvedBlanks
			]],
			Messages->False
		]]
	];

	{resolvedBlanks,expandedBlanksOptions}=If[And[
		Depth[Lookup[preexpandedBlanksOptions,Blanks]]<=2,
		MatchQ[Lookup[preexpandedBlanksOptions,Blanks],Except[{}|Null]]
	],
		{
			ToList[Lookup[preexpandedBlanksOptions,Blanks]],
			Map[(First[#]->List[Last[#]]) &,preexpandedBlanksOptions]
		},
		(*if not the singleton case, then nothing to change*)
		{
			Lookup[preexpandedBlanksOptions,Blanks],
			preexpandedBlanksOptions
		}
	];

	(* Informing volumes from the injection table runs the risk of it not being copacetic with specified samples/ladders/standards/blanks *)
	(* to avoid this breaking the mapthread, make sure blanks are copacetic, and if not, inform volume from sampleVolume *)
	injectionTableBlankNotCopaceticQ=If[MatchQ[specifiedInjectionTable,Except[Automatic]],
		Not[Or[
			MatchQ[resolvedBlanks,Null|Automatic|{Automatic..}],
			And[
				ContainsAll[
					Cases[specifiedInjectionTable,{Blank,ObjectP[],VolumeP|Automatic}][[All,2]],
					Cases[resolvedBlanks,ObjectP[]]
				],
				ContainsAll[
					Cases[resolvedBlanks,ObjectP[]],
					Cases[specifiedInjectionTable,{Blank,ObjectP[],VolumeP|Automatic}][[All,2]]
				]
			]]],
		False
	];

	(* if there is a user specified an injection table, and if they did, grab volumes to pass to the mapthread  *)
	injectionTableBlankVolumes=If[Not[injectionTableBlankNotCopaceticQ],
		Switch[specifiedInjectionTable,
			{{_,ObjectP[],VolumeP|Automatic}..},Cases[specifiedInjectionTable,{Blank,ObjectP[],VolumeP|Automatic}][[All,3]],
			Automatic,ConstantArray[Automatic,Length[resolvedBlanks]]
		],
		(* If samples in injection tables dont match Standard, dont inform volume, we'll raise an error a bit later *)
		ToList[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,BlankVolume]]
	];

	(* we need to account for a situation where the injection table is not in agreement with samplesIn and options.
	there is an error check later, but we want to make sure we dont break the MapThread *)
	lengthCorrectedInjectionTableBlankVolumes=If[Length[injectionTableBlankVolumes]!=Length[resolvedBlanks],
		ConstantArray[Automatic,Length[resolvedBlanks]],
		injectionTableBlankVolumes
	];

	(* round volumes *)
	roundedInjectionTableBlankVolumes=RoundOptionPrecision[lengthCorrectedInjectionTableBlankVolumes,10^-1Microliter];

	(* now we can figure out the options that are specific for blanks *)
	resolvedBlanksPackets=fetchPacketFromCache[#,optionObjectModelPackets]&/@resolvedBlanks;

	(*rename the keys in the option set*)
	keyBlankNames=Keys[expandedBlanksOptions];

	(*remove the Blank the Blank prepend for the for the key*)
	keyBlankNamesPrependRemoved=ToExpression/@StringReplace[ToString/@keyBlankNames,{"Blank"->""}];

	renamedBlankOptionSet=Association[MapThread[Rule,{keyBlankNamesPrependRemoved,Values@expandedBlanksOptions}]];

	(* prep options for mapThread *)
	mapThreadFriendlyBlankOptions=If[resolveIncludeBlanks,
		Transpose[Association[renamedBlankOptionSet],AllowedHeads->{Association,List}],
		renamedBlankOptionSet
	];


	{
		{
			(*1*)(* general option variables *)
			(*2*)resolvedStandardTotalVolume,
			(*3*)resolvedStandardVolume,
			(*4*)resolvedStandardFrequency,
			(*5*)resolvedStandardSedimentationSupernatantVolume,
			(*6*)resolvedStandardSeparationVoltageDurationProfile,
			(*7*)resolvedStandardInjectionVoltageDurationProfile,
			(*13*)(* general option errors *)
			standardTotalVolumeNullErrors,
			standardVolumeNullErrors,
			(*14*)standardMissingSampleCompositionWarnings,
			(*15*)standardSupernatantVolumeInvalidErrors,
			(*18*)(* premade mastermix branch variables *)
			resolvedStandardPremadeMasterMix,
			resolvedStandardPremadeMasterMixReagent,
			(*19*)resolvedStandardPremadeMasterMixVolume,
			(*20*)resolvedStandardPremadeMasterMixReagentDilutionFactor,
			(*21*)resolvedStandardPremadeMasterMixDiluent,
			(*22*)(* premade mastermix branch errors *)
			(*23*)standardPremadeMasterMixNullErrors,
			(*24*)standardPremadeMasterMixDilutionFactorNullErrors,
			(*25*)standardPremadeMasterMixVolumeNullErrors,
			(*26*)standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings,
			(*27*)standardPremadeMasterMixTotalVolumeErrors,
			standardPremadeMasterMixDiluentNullErrors,
			(*28*)(* make-ones-own mastermix branch variables *)
			(*29*)resolvedStandardInternalReference,
			(*30*)resolvedStandardInternalReferenceDilutionFactor,
			(*31*)resolvedStandardInternalReferenceVolume,
			(*32*)resolvedStandardConcentratedSDSBuffer,
			(*33*)resolvedStandardConcentratedSDSBufferDilutionFactor,
			(*34*)resolvedStandardDiluent,
			(*35*)resolvedStandardConcentratedSDSBufferVolume,
			(*36*)resolvedStandardSDSBuffer,
			(*37*)resolvedStandardSDSBufferVolume,
			(*38*)resolvedStandardReduction,
			(*39*)resolvedStandardReducingAgent,
			(*40*)resolvedStandardReducingAgentTargetConcentration,
			(*41*)resolvedStandardReducingAgentVolume,
			(*42*)resolvedStandardAlkylation,
			(*43*)resolvedStandardAlkylatingAgent,
			(*44*)resolvedStandardAlkylatingAgentTargetConcentration,
			(*45*)resolvedStandardAlkylatingAgentVolume,
			(*46*)(* make-ones-own mastermix branch errors *)
			(*47*)standardInternalReferenceNullErrors,
			(*48*)standardInternalReferenceDilutionFactorNullErrors,
			standardInternalReferenceVolumeNullErrors,
			(*49*)standardInternalReferenceVolumeDilutionFactorMismatchWarnings,
			(*50*)standardReducingAgentNullErrors,
			(*51*)standardNoReducingAgentIdentifiedWarnings,
			(*52*)standardReducingAgentTargetConcentrationNullErrors,
			(*53*)standardReducingAgentVolumeNullErrors,
			(*54*)standardReducingAgentVolumeConcentrationMismatchErrors,
			(*55*)standardAlkylatingAgentNullErrors,
			(*56*)standardNoAlkylatingAgentIdentifiedWarnings,
			(*57*)standardAlkylatingAgentTargetConcentrationNullErrors,
			(*58*)standardAlkylatingAgentVolumeNullErrors,
			(*59*)standardAlkylatingAgentVolumeConcentrationMismatchErrors,
			(*60*)standardSDSBufferNullErrors,
			(*61*)standardBothSDSBranchesSetWarnings,
			(*62*)standardConcentratedSDSBufferDilutionFactorNullErrors,
			(*63*)standardNotEnoughSDSinSampleWarnings,
			(*64*)standardVolumeGreaterThanTotalVolumeErrors,
			(*65*)standardComponentsDontSumToTotalVolumeErrors,
			(*66*)standardDiluentNullErrors
		},
		{
			(*1*)(* general option variables *)
			(*2*)resolvedBlankTotalVolume,
			(*3*)resolvedBlankVolume,
			(*4*)resolvedBlankFrequency,
			(*5*)resolvedBlankSedimentationSupernatantVolume,
			(*6*)resolvedBlankSeparationVoltageDurationProfile,
			(*7*)resolvedBlankInjectionVoltageDurationProfile,
			(*13*)(* general option errors *)
			blankTotalVolumeNullErrors,
			blankVolumeNullErrors,
			(*14*)blankMissingSampleCompositionWarnings,
			(*15*)blankSupernatantVolumeInvalidErrors,
			(*18*)(* premade mastermix branch variables *)
			resolvedBlankPremadeMasterMix,
			resolvedBlankPremadeMasterMixReagent,
			(*19*)resolvedBlankPremadeMasterMixVolume,
			(*20*)resolvedBlankPremadeMasterMixReagentDilutionFactor,
			(*21*)resolvedBlankPremadeMasterMixDiluent,
			(*22*)(* premade mastermix branch errors *)
			(*23*)blankPremadeMasterMixNullErrors,
			(*24*)blankPremadeMasterMixDilutionFactorNullErrors,
			(*25*)blankPremadeMasterMixVolumeNullErrors,
			(*26*)blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings,
			(*27*)blankPremadeMasterMixTotalVolumeErrors,
			blankPremadeMasterMixDiluentNullErrors,
			(*28*)(* make-ones-own mastermix branch variables *)
			(*29*)resolvedBlankInternalReference,
			(*30*)resolvedBlankInternalReferenceDilutionFactor,
			(*31*)resolvedBlankInternalReferenceVolume,
			(*32*)resolvedBlankConcentratedSDSBuffer,
			(*33*)resolvedBlankConcentratedSDSBufferDilutionFactor,
			(*34*)resolvedBlankDiluent,
			(*35*)resolvedBlankConcentratedSDSBufferVolume,
			(*36*)resolvedBlankSDSBuffer,
			(*37*)resolvedBlankSDSBufferVolume,
			(*38*)resolvedBlankReduction,
			(*39*)resolvedBlankReducingAgent,
			(*40*)resolvedBlankReducingAgentTargetConcentration,
			(*41*)resolvedBlankReducingAgentVolume,
			(*42*)resolvedBlankAlkylation,
			(*43*)resolvedBlankAlkylatingAgent,
			(*44*)resolvedBlankAlkylatingAgentTargetConcentration,
			(*45*)resolvedBlankAlkylatingAgentVolume,
			(*46*)(* make-ones-own mastermix branch errors *)
			(*47*)blankInternalReferenceNullErrors,
			(*48*)blankInternalReferenceDilutionFactorNullErrors,
			blankInternalReferenceVolumeNullErrors,
			(*49*)blankInternalReferenceVolumeDilutionFactorMismatchWarnings,
			(*50*)blankReducingAgentNullErrors,
			(*51*)blankNoReducingAgentIdentifiedWarnings,
			(*52*)blankReducingAgentTargetConcentrationNullErrors,
			(*53*)blankReducingAgentVolumeNullErrors,
			(*54*)blankReducingAgentVolumeConcentrationMismatchErrors,
			(*55*)blankAlkylatingAgentNullErrors,
			(*56*)blankNoAlkylatingAgentIdentifiedWarnings,
			(*57*)blankAlkylatingAgentTargetConcentrationNullErrors,
			(*58*)blankAlkylatingAgentVolumeNullErrors,
			(*59*)blankAlkylatingAgentVolumeConcentrationMismatchErrors,
			(*60*)blankSDSBufferNullErrors,
			(*61*)blankBothSDSBranchesSetWarnings,
			(*62*)blankConcentratedSDSBufferDilutionFactorNullErrors,
			(*63*)blankNotEnoughSDSinSampleWarnings,
			(*64*)blankVolumeGreaterThanTotalVolumeErrors,
			(*65*)blankComponentsDontSumToTotalVolumeErrors,
			(*66*)blankDiluentNullErrors
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
						Lookup[mapThreadFriendlyOptionsLocal,SedimentationSupernatantVolume]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,SeparationVoltageDurationProfile]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,InjectionVoltageDurationProfile]/.Automatic:>Null
					},
					(* general option errors *)
					ConstantArray[False,4],
					(* premade mastermix branch variables *)
					{
						Lookup[mapThreadFriendlyOptionsLocal,PremadeMasterMix]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,PremadeMasterMixReagent]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,PremadeMasterMixVolume]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,PremadeMasterMixReagentDilutionFactor]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,PremadeMasterMixDiluent]/.Automatic:>Null
					},
					(* premade mastermix branch errors *)
					ConstantArray[False,6],
					(* make-ones-own mastermix branch variables *)
					{
						Lookup[mapThreadFriendlyOptionsLocal,InternalReference]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,InternalReferenceDilutionFactor]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,InternalReferenceVolume]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,ConcentratedSDSBuffer]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,Diluent]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,ConcentratedSDSBufferVolume]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,SDSBuffer]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,SDSBufferVolume]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,Reduction]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,ReducingAgent]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,ReducingAgentTargetConcentration]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,ReducingAgentVolume]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,Alkylation]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,AlkylatingAgent]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,AlkylatingAgentTargetConcentration]/.Automatic:>Null,
						Lookup[mapThreadFriendlyOptionsLocal,AlkylatingAgentVolume]/.Automatic:>Null
					},
					(* make-ones-own mastermix branch errors *)
					ConstantArray[False,21]
				}]],
			Transpose@MapThread[
				Function[{mySample,myMapThreadOptions,injectionTableVolume},
					Module[
						{
							sampleVolume,premadeMasterMixVolume,separationVoltageDurationProfile,
							premadeMasterMixNullError,premadeMasterMixDilutionFactorNullError,
							internalReferenceNullError,internalReferenceDilutionFactorNullError,internalReferenceVolumeNullError,
							concentratedSDSBufferDilutionFactorNullError,
							diluentNullError,sDSBufferNullError,reducingAgentNullError,reducingAgentVolumeConcentrationMismatchError,
							reducingAgentTargetConcentrationNullError,reducingAgentVolumeNullError,alkylatingAgentNullError,alkylatingAgentTargetConcentrationNullError,
							alkylatingAgentVolumeConcentrationMismatchError,
							premadeMasterMixTotalVolumeError,missingSampleCompositionWarning,
							premadeMasterMixVolumeNullError,premadeMasterMixVolumeDilutionFactorMismatchWarning,internalReference,
							internalReferenceDilutionFactor,internalReferenceVolume,concentratedSDSBuffer,
							concentratedSDSBufferDilutionFactor,diluent,concentratedSDSBufferVolume,sDSBufferVolume,reducingAgent,
							reducingAgentTargetConcentration,reducingAgentVolume,alkylatingAgent,alkylatingAgentTargetConcentration,
							alkylatingAgentVolume,internalReferenceVolumeDilutionFactorMismatchWarning,reduction,alkylation,reducingAgentIdentifiedWarning,
							alkylatingAgentVolumeNullError,alkylatingAgentIdentifiedWarning,sDSBuffer,bothSDSBranchesSetWarning,
							volumeGreaterThanTotalVolumeError,componentsDontSumToTotalVolumeError,supernatantVolume,supernatantVolumeInvalidError,
							notEnoughSDSinSampleWarning,premadeMasterMixDilutionFactor,masterMixDilutionFactor,totalVolume,sampleFrequency,injectionVoltageDurationProfile,
							preMadeMasterMixOptions,includePremadeMasterMixBool,resolvePremadeMasterMix,premadeMasterMixDiluentNullError,
							premadeMasterMixReagent,totalVolumeNullError,volumeNullError,premadeMasterMixDiluent
						},
						(* Setup error tracking variables *)
						{
							missingSampleCompositionWarning,
							premadeMasterMixNullError,
							premadeMasterMixDilutionFactorNullError,
							premadeMasterMixDiluentNullError,
							internalReferenceNullError,
							internalReferenceDilutionFactorNullError,
							internalReferenceVolumeNullError,
							reducingAgentNullError,
							reducingAgentVolumeConcentrationMismatchError,
							reducingAgentTargetConcentrationNullError,
							reducingAgentVolumeNullError,
							alkylatingAgentNullError,
							alkylatingAgentTargetConcentrationNullError,
							alkylatingAgentVolumeConcentrationMismatchError,
							premadeMasterMixTotalVolumeError,
							reducingAgentIdentifiedWarning,
							alkylatingAgentNullError,
							alkylatingAgentTargetConcentrationNullError,
							alkylatingAgentVolumeNullError,
							alkylatingAgentIdentifiedWarning,
							sDSBufferNullError,
							bothSDSBranchesSetWarning,
							concentratedSDSBufferDilutionFactorNullError,
							volumeGreaterThanTotalVolumeError,
							componentsDontSumToTotalVolumeError,
							diluentNullError,
							supernatantVolumeInvalidError,
							notEnoughSDSinSampleWarning,
							totalVolumeNullError,
							volumeNullError
						}=ConstantArray[False,30];

						(* Resolve SampleVolume *)
						totalVolume=Switch[Lookup[myMapThreadOptions,TotalVolume],
							(* if automatic, set to most common value in sample total Value *)
							Automatic,
							First[Commonest[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,TotalVolume],1]],
							VolumeP,
							Lookup[myMapThreadOptions,TotalVolume],
							Null,Null
						];

						totalVolumeNullError=NullQ[totalVolume];

						sampleVolume=If[Not[totalVolumeNullError],
							Which[
								MatchQ[Lookup[myMapThreadOptions,Volume],VolumeP],
								(* if informed, use it *)
								Lookup[myMapThreadOptions,Volume],
								(* if not informed,check if it was informed in the injection Table*)
								MatchQ[injectionTableVolume,VolumeP],
								injectionTableVolume,
								(* if not informed, pull out composition and resolve volume to reach 1 mg/ml in total volume*)
								True,
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
												moleculeMW=Flatten[Select[Lookup[optionObjectModelCompositionPackets,
													{Object,MolecularWeight}],MatchQ[#[[1]],Download[molecule[[2]],Object]]&]][[2]];
												(* Try to convert units to Milligram/Milliliter *)
												Switch[Quiet[Convert[molecule[[1]],Milligram/Milliliter]],
													Except[Alternatives[$Failed,Null]],Quiet[Convert[molecule[[1]],Milligram/Milliliter]],(* if it works, return this *)
													Null,Null,(* if returns null, there is no value for concentration *)
													$Failed,If[
													(*if returns $Failed,the unit cant be readily converted,so will further investigate if its MassPercent or Molarity]*)
													MatchQ[QuantityUnit[molecule[[1]]],IndependentUnit["MassPercent"]],
													QuantityMagnitude[molecule[[1]]]*1000 Milligram/(100 Milliliter),
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
										(1 Milligram/Milliliter*totalVolume)/Total[proteinConcentration],
										(*otherwise, return volume that is 25% of the TotalVolume and raise warning *)
										missingSampleCompositionWarning=True;
										totalVolume*0.25];
									Convert[RoundOptionPrecision[calculatedVolume,10^-1 Microliter,AvoidZero->True],Microliter]
								]
							],
							Lookup[myMapThreadOptions,Volume]/.Automatic:>Null
						];

						volumeNullError=NullQ[sampleVolume];

						(* if injectionTable is informed, set as null (unless you really want to figure one the frequency, but that's a bit much *)
						sampleFrequency=Switch[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],
							Automatic,
							Lookup[myMapThreadOptions,Frequency]/.Automatic:>FirstAndLast,
							_,
							Lookup[myMapThreadOptions,Frequency]/.Automatic:>Null
						];

						(* check if PremadeMasterMix should be True *)
						preMadeMasterMixOptions={
							PremadeMasterMixReagent,PremadeMasterMixDiluent,PremadeMasterMixReagentDilutionFactor,PremadeMasterMixVolume
						};

						includePremadeMasterMixBool=Map[
							MatchQ[#,Except[Automatic|Null|False]]&,
							Lookup[myMapThreadOptions,preMadeMasterMixOptions]
						];

						resolvePremadeMasterMix=Which[
							MatchQ[Lookup[myMapThreadOptions,PremadeMasterMix],Except[Automatic]],
							Lookup[myMapThreadOptions,PremadeMasterMix],
							Or@@includePremadeMasterMixBool,True,
							True,False
						];

						(* PremadeMasterMix split to two branches *)
						{
							(* premade mastermix branch variables *)
							premadeMasterMixReagent,
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
							internalReference,
							internalReferenceDilutionFactor,
							internalReferenceVolume,
							concentratedSDSBuffer,
							concentratedSDSBufferDilutionFactor,
							diluent,
							concentratedSDSBufferVolume,
							sDSBuffer,
							sDSBufferVolume,
							reduction,
							reducingAgent,
							reducingAgentTargetConcentration,
							reducingAgentVolume,
							alkylation,
							alkylatingAgent,
							alkylatingAgentTargetConcentration,
							alkylatingAgentVolume,
							(* make-ones-own mastermix branch variables *)
							internalReferenceNullError,
							internalReferenceDilutionFactorNullError,
							internalReferenceVolumeNullError,
							internalReferenceVolumeDilutionFactorMismatchWarning,
							reducingAgentNullError,
							noReducingAgentIdentifiedWarning,
							reducingAgentTargetConcentrationNullError,
							reducingAgentVolumeNullError,
							reducingAgentVolumeConcentrationMismatchError,
							alkylatingAgentNullError,
							noAlkylatingAgentIdentifiedWarning,
							alkylatingAgentTargetConcentrationNullError,
							alkylatingAgentVolumeNullError,
							alkylatingAgentVolumeConcentrationMismatchError,
							concentratedSDSBufferDilutionFactorNullError,
							sDSBufferNullError,
							bothSDSBranchesSetWarning,
							concentratedSDSBufferDilutionFactorNullError,
							notEnoughSDSinSampleWarning,
							volumeGreaterThanTotalVolumeError,
							componentsDontSumToTotalVolumeError,
							diluentNullError
						}=If[MatchQ[resolvePremadeMasterMix,True],
							(* PremadeMasterMix, no need to get specific reagents *)
							Module[
								{
									masterMixNullError,masterMixDilutionFactorNullError,masterMixVolume,masterMixVolumeNullError,
									masterMixVolumeDilutionFactorMismatchWarning,masterMixTotalVolumeError,mixReagent,mixVolume,
									mixDilutionFactor,masterMixDiluent,masterMixDiluentNullError
								},
								(* gather options *)

								(* check if a reagent was defined for samples and use the same one *)
								mixReagent=Switch[Lookup[myMapThreadOptions,PremadeMasterMixReagent],
									(* if automatic, set to most common value in sample total Value *)
									Automatic,
									First[Commonest[ToList[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,PremadeMasterMixReagent]],1]],
									ObjectP[],
									Lookup[myMapThreadOptions,PremadeMasterMixReagent],
									Null,Null
								];

								(* gather options *)
								mixVolume=Lookup[myMapThreadOptions,PremadeMasterMixVolume];
								mixDilutionFactor=Lookup[myMapThreadOptions,PremadeMasterMixReagentDilutionFactor]/.Automatic:>2;

								(* check if PremadeMasterMixReagent is informed *)
								masterMixNullError=NullQ[mixReagent];

								(* Resolve PremadeMasterMixVolume *)
								{
									masterMixVolume,
									masterMixDilutionFactor,
									masterMixVolumeNullError,
									masterMixDilutionFactorNullError,
									masterMixVolumeDilutionFactorMismatchWarning
								}=If[Not[masterMixNullError],
									Switch[mixVolume,
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
										{mixVolume,mixDilutionFactor/.Automatic:>(totalVolume/mixVolume),
											False,False,mixVolume=!=(totalVolume/(mixDilutionFactor/.Automatic:>(totalVolume/mixVolume)))}],
										(* if automatic, make sure DilutionFactor is informed and calculate volume*)
										Automatic,If[
										NullQ[mixDilutionFactor],
										{Null,Null,
											False,True,False},
										{(totalVolume/mixDilutionFactor/.Automatic:>2),mixDilutionFactor/.Automatic:>2,
											False,False,False}]
									],
									{
										mixVolume/.Automatic:>Null,mixDilutionFactor/.Automatic:>Null,
										False,False,False
									}
								];

								masterMixTotalVolumeError=If[Not[Or[masterMixNullError,masterMixVolumeNullError]],
									(sampleVolume+masterMixVolume)>totalVolume,
									False];

								(* resolve diluent *)
								masterMixDiluent=Lookup[myMapThreadOptions,PremadeMasterMixDiluent]/.Automatic:>Model[Sample,"Milli-Q water"];
								(* if masterMix Diluent is Null but no need to top off to total volume, dont raise an error, otherwise raise an error *)
								masterMixDiluentNullError=(totalVolume-sampleVolume-masterMixVolume)>0Microliter&&MatchQ[masterMixDiluent,Null];

								(* Gather all resolved options and errors to return *)
								{
									mixReagent,
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
									Lookup[myMapThreadOptions,InternalReference]/.Automatic:>Null,
									Lookup[myMapThreadOptions,InternalReferenceDilutionFactor]/.Automatic:>Null,
									Lookup[myMapThreadOptions,InternalReferenceVolume]/.Automatic:>Null,
									Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
									Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
									Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null,
									Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
									Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
									Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null,
									Lookup[myMapThreadOptions,Reduction]/.Automatic:>True,(* Assume reducing conditions if using mastermix for longer run.. *)
									Lookup[myMapThreadOptions,ReducingAgent]/.Automatic:>Null,
									Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null,
									Lookup[myMapThreadOptions,ReducingAgentVolume]/.Automatic:>Null,
									Lookup[myMapThreadOptions,Alkylation]/.Automatic:>False,
									Lookup[myMapThreadOptions,AlkylatingAgent]/.Automatic:>Null,
									Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null,
									Lookup[myMapThreadOptions,AlkylatingAgentVolume]/.Automatic:>Null,
									(* Other branch's errors as False *)
									False,(* intReferenceNullError *)
									False,(* intReferenceDilutionFactorNullError *)
									False,(* intReferenceVolumeNullError *)
									False,(* intReferenceVolumeDilutionFactorMismatchWarning *)
									False,(* mixReducingAgentNullError *)
									False,(* mixNoReducingAgentIdentifiedWarning *)
									False,(* mixReducingAgentTargetConcentrationNullError *)
									False,(* mixReducingAgentVolumeNullError *)
									False,(* mixReducingAgentVolumeConcentrationMismatchError *)
									False,(* mixAlkylatingAgentNullError *)
									False,(* mixNoAlkylatingAgentIdentifiedWarning *)
									False,(* mixAlkylatingAgentTargetConcentrationNullError *)
									False,(* mixAlkylatingAgentVolumeNullError *)
									False,(* mixAlkylatingAgentVolumeConcentrationMismatchError *)
									False,(* resolveMixConcentratedSDSBufferDilutionFactorNullError *)
									False,(* mixSDSBufferNullError *)
									False,(* mixBothSDSBranchesSetWarning *)
									False,(* mixConcentratedSDSBufferDilutionFactorNullError *)
									False,(* mixNotEnoughSDSinSampleWarnin *)
									False,(* mixVolumeGreaterThanTotalVolumeError *)
									False,(* mixComponentsDontSumToTotalVolumeError *)
									False (* mixDiluentNullError *)
								}
							],
							(* no PremadeMasterMix, make your own mastermix *)
							Module[
								{
									mixDiluent,mixInternalReference,
									mixInternalReferenceDilutionFactor,mixInternalReferenceVolume,mixConcentratedSDSBuffer,
									mixConcentratedSDSBufferDilutionFactor,mixConcentratedSDSBufferVolume,mixSDSBufferVolume,
									mixReducingAgent,mixReducingAgentTargetConcentration,mixReducingAgentVolume,mixAlkylatingAgent,
									mixAlkylatingAgentTargetConcentration,mixAlkylatingAgentVolume,intReferenceNullError,intReferenceDilutionFactorNullError,
									intReferenceVolumeDilutionFactorMismatchWarning,reductionOptions,includeReductionOptionBool,
									mixReduction,mixAlkylation,mixReducingAgentNullError,tcep,bme,dtt,ian,alkylationOptions,
									includeAlkylationOptionBool,identifyAlkylatingAgent,
									mixReducingAgentTargetConcentrationNullError,mixReducingAgentVolumeNullError,
									mixReducingAgentVolumeConcentrationMismatchError,mixNoReducingAgentIdentifiedWarning,
									mixAlkylatingAgentNullError,mixNoAlkylatingAgentIdentifiedWarning,
									mixAlkylatingAgentTargetConcentrationNullError,mixAlkylatingAgentVolumeNullError,
									mixAlkylatingAgentVolumeConcentrationMismatchError,mixConcentratedSDSBufferDilutionFactorNullError,
									mixVolumeGreaterThanTotalVolumeError,mixDiluentNullError,mixSDSBuffer,mixComponentsDontSumToTotalVolumeError,
									mixSDSBufferNullError,mixBothSDSBranchesSetWarning,volumeLeft,mixConcentratedSDSBool,mixSDSBool,
									resolveMixConcentratedSDSBuffer,resolveMixConcentratedSDSBufferVolume,resolveMixConcentratedSDSBufferDilutionFactor,
									resolveMixConcentratedSDSBufferDilutionFactorNullError,resolveMixSDSBuffer,resolveMixSDSBufferVolume,
									sdsBufferUserDefinedBool,concentratedSDSUserDefinedBool,sampleSDSBuffer,sampleBufferCompositionIDs,identifySDS,
									sds,sdsObject,bufferVolume,mixNotEnoughSDSinSampleWarning,intReferenceVolumeNullError
								},

								(* Check if internalReference is informed, if not raise error *)
								{
									intReferenceNullError,
									mixInternalReference
								}=Switch[Lookup[myMapThreadOptions,InternalReference],
									Automatic,{False,Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"]},
									Null,{True,Null},
									ObjectP[],{False,Lookup[myMapThreadOptions,InternalReference]}
								];

								(* resolve InternalReference Volume *)
								{
									intReferenceDilutionFactorNullError,
									intReferenceVolumeNullError,
									mixInternalReferenceDilutionFactor,
									mixInternalReferenceVolume
								}=If[Not[totalVolumeNullError],
									Switch[Lookup[myMapThreadOptions,InternalReferenceVolume],
										VolumeP,
										{False,False,Lookup[myMapThreadOptions,InternalReferenceDilutionFactor]/.Automatic:>totalVolume/Lookup[myMapThreadOptions,InternalReferenceVolume],Lookup[myMapThreadOptions,InternalReferenceVolume]},
										Null,
										{False,True,Lookup[myMapThreadOptions,InternalReferenceDilutionFactor]/.Automatic:>25,Lookup[myMapThreadOptions,InternalReferenceVolume]},
										(* If InternalReferenceDilutionFactor is automatic, set to 25 (based on ProteinSimple standard) otherwise
						check if null and raise an error or use given value *)
										Automatic,
										Switch[Lookup[myMapThreadOptions,InternalReferenceDilutionFactor],
											Null,
											{True,False,Null,Null},
											Automatic,
											{False,False,25,RoundOptionPrecision[totalVolume/25,10^-1Microliter]},
											GreaterP[0],
											{False,False,Lookup[myMapThreadOptions,InternalReferenceDilutionFactor],
												totalVolume/Lookup[myMapThreadOptions,InternalReferenceDilutionFactor]}
										]
									],
									{False,False,
										Lookup[myMapThreadOptions,InternalReferenceDilutionFactor]/.Automatic:>Null,
										Lookup[myMapThreadOptions,InternalReferenceVolume]/.Automatic:>Null}
								];
								(* if both dilution factor and volume are given, check that they concur *)
								intReferenceVolumeDilutionFactorMismatchWarning=If[NullQ[mixInternalReferenceDilutionFactor]||NullQ[mixInternalReferenceVolume],
									False,
									Abs[mixInternalReferenceVolume-(totalVolume/mixInternalReferenceDilutionFactor)]>0.1Microliter
								];

								(* resolve reduction *)
								reductionOptions={ReducingAgent,ReducingAgentTargetConcentration,ReducingAgentVolume};
								(*check if any of the reduction options are set*)
								includeReductionOptionBool=Map[
									MatchQ[#,Except[Automatic|Null]]&,
									Lookup[myMapThreadOptions,reductionOptions]
								];
								(*resolve the Reduction option based on the setting of the others and that of Samples*)
								mixReduction=Which[
									MatchQ[Lookup[myMapThreadOptions,Reduction],Except[Automatic]],
									Lookup[myMapThreadOptions,Reduction],
									Or@@Join[includeReductionOptionBool],True,
									True,False
								];

								(* if mixReduction is True, resolve related options *)
								{
									mixReducingAgent,
									mixReducingAgentVolume,
									mixReducingAgentTargetConcentration,
									mixReducingAgentNullError,
									mixNoReducingAgentIdentifiedWarning,
									mixReducingAgentTargetConcentrationNullError,
									mixReducingAgentVolumeNullError,
									mixReducingAgentVolumeConcentrationMismatchError
								}=If[mixReduction,
									Module[
										{reducingAgentIdentity,resolveMixReducingAgentNullError,resolveMixReducingAgent,
											resolveMixNoReducingAgentIdentifiedWarning,resolveMixReducingAgentTargetConcentrationNullError,
											resolveMixReducingAgentVolumeNullError,resolveMixReducingAgentTargetConcentration,resolveMixReducingAgentVolume,
											resolveMixReducingAgentVolumeConcentrationMismatchError,targetConcentrationByID
										},
										(* resolve ReducingAgent object - if Automatic, grab whats specified in Samples*)
										{
											resolveMixReducingAgentNullError,
											resolveMixReducingAgent
										}=Switch[Lookup[myMapThreadOptions,ReducingAgent],
											Automatic,{False,Model[Sample,"2-Mercaptoethanol"]},
											Null,{True,Null},
											_,{False,Lookup[myMapThreadOptions,ReducingAgent]}
										];

										(* to resolve mixReducingAgentTargetConcentration below, need to know which agent is used *)
										reducingAgentIdentity=If[!resolveMixReducingAgentNullError,
											Module[
												{reducingAgentPacket,reducingAgentComposition,reducingAgentCompositionIDs,
													reducingAgentCompositionPackets,identifyReducingAgent},
												reducingAgentPacket=fetchPacketFromCache[Download[resolveMixReducingAgent,Object],optionObjectModelPackets];
												reducingAgentComposition=Lookup[reducingAgentPacket,Composition];
												(* construct list with concentration and molecule composition *)
												reducingAgentCompositionPackets=Map[
													Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
													reducingAgentComposition];
												(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
												reducingAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@reducingAgentCompositionPackets;

												(* Identifiers for DTT,TCEP, and BME based on CAS, synonyms, and InChI *)
												{
													tcep,
													bme,
													dtt
												}={
													{"51805-45-9","Tris(2-carboxyethyl)phosphine hydrochloride","TCEP","TCEP hydrochloride","Tris(2-carboxyethyl)phosphine",
														"InChI=1S/C9H15O6P/c10-7(11)1-4-16(5-2-8(12)13)6-3-9(14)15/h1-6H2,(H,10,11)(H,12,13)(H,14,15)","PZBFGYYEXUXCOF-UHFFFAOYSA-N",
														"InChI=1/C9H15O6P/c10-7(11)1-4-16(5-2-8(12)13)6-3-9(14)15/h1-6H2,(H,10,11)(H,12,13)(H,14,15)","PZBFGYYEXUXCOF-UHFFFAOYAQ"},
													{"60-24-2","2-Mercaptoethanol","2Mercaptoethanol","BME","beta-mercaptoethanol","betamercaptoethanol","Mercaptoethanol",
														"InChI=1S/C2H6OS/c3-1-2-4/h3-4H,1-2H2","DGVVWUTYPXICAM-UHFFFAOYSA-N","2-Thioethanol","Thioglycol","Thioethylene glycol"},
													{"3483-12-3","DTT","1,4-Dithiothreitol ","DL-Dithiothreitol","D,L-Dithiothreitol","Dithiothreitol","Cleland's reagent",
														"1S/C4H10O2S2/c5-3(1-7)4(6)2-8/h3-8H,1-2H2","VHJLVAABSRFDPM-UHFFFAOYSA-N"}
												};
												(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
												(* Note - this assumes a single reducing agent in the sample; if more, user will need to specify volume *)

												identifyReducingAgent=Map[
													Function[compositionMolecule,
														{
															compositionMolecule[[1]] (* ObjectID *),
															compositionMolecule[[2]] (* Concentration *),
															Which[
																ContainsAny[compositionMolecule[[3]],tcep],"TCEP",
																ContainsAny[compositionMolecule[[3]],bme],"BME",
																ContainsAny[compositionMolecule[[3]],dtt],"DTT"
															]
														}
													],
													reducingAgentCompositionIDs];

												(* pick out cases where the second index in teh list is not null *)
												Cases[identifyReducingAgent,{ObjectP[],_,Except[NullP]}]
											],
											{}];

										(* raise error if no reducing agents or more than one reducing agents were identified *)
										resolveMixNoReducingAgentIdentifiedWarning=If[!resolveMixReducingAgentNullError,
											Length[reducingAgentIdentity]=!=1,
											False];

										(* BME is a liquid, so we need to handle volumePercent, others should be okay with molarity (unless they are in MassPercent, which this does not support at the moment) *)
										targetConcentrationByID=Which[
											Or[resolveMixNoReducingAgentIdentifiedWarning,resolveMixReducingAgentNullError],Null,
											StringMatchQ[reducingAgentIdentity[[1]][[3]],"TCEP"|"DTT"],50 Millimolar,
											StringMatchQ[reducingAgentIdentity[[1]][[3]],"BME"],
											If[MatchQ[QuantityUnit[reducingAgentIdentity[[1]][[2]]],IndependentUnit["VolumePercent"]],
												(* stock concentration given in volumePercent *)
												4.54545VolumePercent,
												(* Stock Concentration is in Millimolar (As it really should be, even if we're dealing with a liquid) *)
												650 Millimolar],
											True,Null
										];

										(* resolve ReducingAgentVolume *)
										{
											resolveMixReducingAgentTargetConcentrationNullError,
											resolveMixReducingAgentVolumeNullError,
											resolveMixReducingAgentTargetConcentration,
											resolveMixReducingAgentVolume
											(* first check if the reducing agent was null, if it was, just skip checking the previous error is enough *)
										}=Which[
											resolveMixReducingAgentNullError,
											{False,False,
												Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,ReducingAgentVolume]/.Automatic:>Null},
											(* if no identified reducing Agent, still see if there's a valid volume before rasing other errors *)
											NullQ[targetConcentrationByID],
											Switch[Lookup[myMapThreadOptions,ReducingAgentVolume],
												VolumeP,
												{
													False,False,
													Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,ReducingAgentVolume]
												},
												Except[VolumeP],
												{NullQ[Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null],NullQ[Lookup[myMapThreadOptions,ReducingAgentVolume]/.Automatic:>Null],
													Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,ReducingAgentVolume]/.Automatic:>Null}
											],
											(* if reducingAgentID has a single value, go on.. *)
											!NullQ[targetConcentrationByID],
											Switch[Lookup[myMapThreadOptions,ReducingAgentVolume],
												Null,
												{
													False,True,
													Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>targetConcentrationByID,Null
												},
												VolumeP,
												{
													False,False,
													Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>reducingAgentIdentity[[1]][[2]]*RoundOptionPrecision[Lookup[myMapThreadOptions,ReducingAgentVolume],10^-1Microliter]/totalVolume,
													RoundOptionPrecision[Lookup[myMapThreadOptions,ReducingAgentVolume],10^-1Microliter]
												},
												(* If ReducingAgentTargetConcentration is automatic, set to value based on specified reducing agent; otherwise
						check if null, raise	 an error or use given value *)
												Automatic,
												Switch[Lookup[myMapThreadOptions,ReducingAgentTargetConcentration],
													Null,
													{
														True,False,Null,Null
													},
													Automatic,
													(* if possible, resolve based on the reducing agent: BME 650mM, DTT 50 mM, TCEP 50 mM *)
													If[Not[resolveMixNoReducingAgentIdentifiedWarning],
														{
															False,False,
															Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>targetConcentrationByID,
															RoundOptionPrecision[(targetConcentrationByID*totalVolume/reducingAgentIdentity[[1]][[2]]),10^-1Microliter]
														},
														(* no reducing agent was identified, can't calculate must get volume *)
														{
															True,False,Null,Null
														}
													],
													Except[Null|Automatic],
													If[Not[resolveMixNoReducingAgentIdentifiedWarning],
														(* TargetConcentration set, and reagent concenteration found *)
														{
															False,False,
															Lookup[myMapThreadOptions,ReducingAgentTargetConcentration],
															RoundOptionPrecision[(Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]*totalVolume/reducingAgentIdentity[[1]][[2]]),10^-1 Microliter,AvoidZero->True]
														},
														(* cant get the reducing agent concentration from object model, can't calculate volume *)
														{
															False,True,Null,Null
														}
													]
												]
											]];
										(* if both dilution factor and volume are resolved or set, and the reagents concentration is known, check that they concur *)
										resolveMixReducingAgentVolumeConcentrationMismatchError=If[
											Not[Or@@(NullQ[#]&/@{resolveMixReducingAgentTargetConcentration,resolveMixReducingAgentVolume})]&&Not[resolveMixNoReducingAgentIdentifiedWarning],
											Abs[resolveMixReducingAgentVolume-resolveMixReducingAgentTargetConcentration*totalVolume/reducingAgentIdentity[[1]][[2]]]>0.1Microliter,
											False
										];

										(* return resolved options *)
										{
											resolveMixReducingAgent,
											resolveMixReducingAgentVolume,
											resolveMixReducingAgentTargetConcentration,
											resolveMixReducingAgentNullError,
											resolveMixNoReducingAgentIdentifiedWarning,
											resolveMixReducingAgentTargetConcentrationNullError,
											resolveMixReducingAgentVolumeNullError,
											resolveMixReducingAgentVolumeConcentrationMismatchError
										}
									],
									(* If reduction is false, return nulls*)
									{
										Lookup[myMapThreadOptions,ReducingAgent]/.Automatic:>Null,(* resolveMixReducingAgent *)
										Lookup[myMapThreadOptions,ReducingAgentTargetConcentration]/.Automatic:>Null,(* resolveMixReducingAgentVolume *)
										Lookup[myMapThreadOptions,ReducingAgentVolume]/.Automatic:>Null,(* resolveMixReducingAgentTargetConcentration *)
										False,(* resolveMixReducingAgentNullError *)
										False,(* resolveMixNoReducingAgentIdentifiedWarning *)
										False,(* resolveMixReducingAgentTargetConcentrationNullError *)
										False,(* resolveMixReducingAgentVolumeNullError *)
										False (* resolveMixReducingAgentVolumeConcentrationMismatchError *)
									}
								];


								(* resolve Alkylation *)
								alkylationOptions={AlkylatingAgent,AlkylatingAgentTargetConcentration,AlkylatingAgentVolume};
								(*check if any of the alkylation options are set*)
								includeAlkylationOptionBool=Map[
									MatchQ[#,Except[Automatic|Null]]&,
									Lookup[myMapThreadOptions,alkylationOptions]
								];
								(*resolve the Alkylation option based on the setting of the others*)
								mixAlkylation=Which[
									MatchQ[Lookup[myMapThreadOptions,Alkylation],Except[Automatic]],
									Lookup[myMapThreadOptions,Alkylation],
									Or@@Join[includeAlkylationOptionBool],True,
									True,False
								];

								(* if mixReduction is True, resolve related options *)
								{
									mixAlkylatingAgent,
									mixAlkylatingAgentVolume,
									mixAlkylatingAgentTargetConcentration,
									mixAlkylatingAgentNullError,
									mixNoAlkylatingAgentIdentifiedWarning,
									mixAlkylatingAgentTargetConcentrationNullError,
									mixAlkylatingAgentVolumeNullError,
									mixAlkylatingAgentVolumeConcentrationMismatchError
								}=If[mixAlkylation,
									Module[{alkylatingAgentIdentity,resolveMixAlkylatingAgentNullError,resolveMixAlkylatingAgent,
										resolveMixNoAlkylatingAgentIdentifiedWarning,resolveMixAlkylatingAgentTargetConcentrationNullError,
										resolveMixAlkylatingAgentVolumeNullError,resolveMixAlkylatingAgentTargetConcentration,resolveMixAlkylatingAgentVolume,
										resolveMixAlkylatingAgentVolumeConcentrationMismatchError,targetConcentrationByID},
										(* resolve AlkylatingAgent object *)
										{
											resolveMixAlkylatingAgentNullError,
											resolveMixAlkylatingAgent
										}=Switch[Lookup[myMapThreadOptions,AlkylatingAgent],
											Automatic,{False,Model[Sample,StockSolution,"250mM Iodoacetamide"]},
											Null,{True,Null},
											_,{False,Lookup[myMapThreadOptions,AlkylatingAgent]}
										];

										(* to resolve mixAlkylatingAgentTargetConcentration below, need to know which agent is used *)
										alkylatingAgentIdentity=If[!resolveMixAlkylatingAgentNullError,
											Module[
												{alkylatingAgentPacket,alkylatingAgentComposition,alkylatingAgentCompositionIDs,alkylatingAgentCompositionPackets},
												alkylatingAgentPacket=fetchPacketFromCache[Download[resolveMixAlkylatingAgent,Object],optionObjectModelPackets];
												alkylatingAgentComposition=Lookup[alkylatingAgentPacket,Composition];
												(* construct list with concentration and molecule composition *)
												alkylatingAgentCompositionPackets=Map[
													Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
													alkylatingAgentComposition];
												(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
												alkylatingAgentCompositionIDs={Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@alkylatingAgentCompositionPackets;

												(* Identifiers for IAP based on CAS, synonyms, and InChI *)
												{
													ian
												}={
													{"144-48-9","IAN","2-Iodoacetamide","Iodoacetamide","Iodoacetamide","Monoiodoacetamide","alpha-Iodoacetamide","InChI=1S/C2H4INO/c3-1-2(4)5/h1H2,(H2,4,5)",
														"PGLTVOMIXTUURA-UHFFFAOYSA-N"}
												};
												(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
												(* Note - this assumes a single alkylating agent in the sample; if more, user will need to specify volume *)

												identifyAlkylatingAgent=Map[
													Function[compositionMolecule,
														{
															compositionMolecule[[1]] (* ObjectID *),
															compositionMolecule[[2]] (* Concentration *),
															Which[
																ContainsAny[compositionMolecule[[3]],ian],"IAN"
															]
														}
													],
													alkylatingAgentCompositionIDs];
												(* pick out cases where the second index in teh list is not null *)
												Cases[identifyAlkylatingAgent,{ObjectP[],_,Except[NullP]}]
											],
											{}];


										(* raise error if no reduging agents or more than one Alkylating agents were identified *)
										resolveMixNoAlkylatingAgentIdentifiedWarning=If[!resolveMixAlkylatingAgentNullError,
											Length[alkylatingAgentIdentity]=!=1,
											False];

										(* resolve AlkylatingAgentVolume *)
										targetConcentrationByID=Which[
											Or[resolveMixNoAlkylatingAgentIdentifiedWarning,resolveMixAlkylatingAgentNullError],Null,
											StringMatchQ[alkylatingAgentIdentity[[1]][[3]],"IAN"],11.5 Millimolar,
											True,Null
										];

										{
											resolveMixAlkylatingAgentTargetConcentrationNullError,
											resolveMixAlkylatingAgentVolumeNullError,
											resolveMixAlkylatingAgentTargetConcentration,
											resolveMixAlkylatingAgentVolume
										}=Which[
											resolveMixAlkylatingAgentNullError,
											{False,False,
												Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,AlkylatingAgentVolume]/.Automatic:>Null},
											(* if no identified alkylating Agent, still see if there's a valid volume before rasing other errors *)
											NullQ[targetConcentrationByID],
											Switch[Lookup[myMapThreadOptions,AlkylatingAgentVolume],
												VolumeP,
												{
													False,False,
													Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,AlkylatingAgentVolume]
												},
												Except[VolumeP],
												{NullQ[Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null],NullQ[Lookup[myMapThreadOptions,AlkylatingAgentVolume]/.Automatic:>Null],
													Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null,Lookup[myMapThreadOptions,AlkylatingAgentVolume]/.Automatic:>Null}
											],
											(* if alkylatingAgentID has a single value, go on.. *)
											!NullQ[targetConcentrationByID],
											Switch[Lookup[myMapThreadOptions,AlkylatingAgentVolume],
												Null,
												{
													False,True,
													Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>targetConcentrationByID,Null
												},
												VolumeP,
												{
													False,False,
													Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>alkylatingAgentIdentity[[1]][[2]]*RoundOptionPrecision[Lookup[myMapThreadOptions,AlkylatingAgentVolume],10^-1Microliter]/totalVolume,
													RoundOptionPrecision[Lookup[myMapThreadOptions,AlkylatingAgentVolume],10^-1Microliter]
												},
												(* If AlkylatingAgentTargetConcentration is automatic, set to value based on specified reducing agent; otherwise
													check if null, raise an error or use given value *)
												Automatic,
												Switch[Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration],
													Null,
													{
														True,True,Null,Null
													},
													Automatic,
													(* if possible, resolve based on the alkylating *)
													If[Not[resolveMixNoAlkylatingAgentIdentifiedWarning],
														{
															False,False,
															Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>targetConcentrationByID,
															RoundOptionPrecision[(targetConcentrationByID*totalVolume/alkylatingAgentIdentity[[1]][[2]]),10^-1Microliter]
														},
														(* no alkylating agent was identified, can't calculate must get volume *)
														{
															False,True,Null,Null
														}
													],
													Except[Null|Automatic],
													If[Not[resolveMixNoAlkylatingAgentIdentifiedWarning],
														(* TargetConcentration set, and reagent concenteration found *)
														{
															False,False,
															Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration],
															RoundOptionPrecision[(Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]*totalVolume/alkylatingAgentIdentity[[1]][[2]]),10^-1 Microliter,AvoidZero->True]
														},
														(* cant get the reducing agent concentration from object model, can't calculate volume *)
														{
															False,True,Null,Null
														}
													]
												]
											]];


										(* if both TragetConcentration and volume are resolved or set, and the reagents concentration is known, check that they concur *)
										resolveMixAlkylatingAgentVolumeConcentrationMismatchError=If[
											Not[Or@@(NullQ[#]&/@{resolveMixAlkylatingAgentTargetConcentration,resolveMixAlkylatingAgentVolume})]&&Not[resolveMixNoAlkylatingAgentIdentifiedWarning],
											Abs[resolveMixAlkylatingAgentVolume-resolveMixAlkylatingAgentTargetConcentration*totalVolume/alkylatingAgentIdentity[[1]][[2]]]>0.1Microliter,
											False
										];

										(* return resolved options *)
										{
											resolveMixAlkylatingAgent,
											resolveMixAlkylatingAgentVolume,
											resolveMixAlkylatingAgentTargetConcentration,
											resolveMixAlkylatingAgentNullError,
											resolveMixNoAlkylatingAgentIdentifiedWarning,
											resolveMixAlkylatingAgentTargetConcentrationNullError,
											resolveMixAlkylatingAgentVolumeNullError,
											resolveMixAlkylatingAgentVolumeConcentrationMismatchError
										}
									],
									(* If alkylation is false, return nulls*)
									{
										Lookup[myMapThreadOptions,AlkylatingAgent]/.Automatic:>Null,(* resolveMixAlkylatingAgent *)
										Lookup[myMapThreadOptions,AlkylatingAgentTargetConcentration]/.Automatic:>Null,(* resolveMixAlkylatingAgentVolume *)
										Lookup[myMapThreadOptions,AlkylatingAgentVolume]/.Automatic:>Null,(* resolveMixAlkylatingAgentTargetConcentration *)
										False,(* resolveMixAlkylatingAgentNullError *)
										False,(* resolveMixNoAlkylatingAgentIdentifiedWarning *)
										False,(* resolveMixAlkylatingAgentTargetConcentrationNullError *)
										False,(* resolveMixAlkylatingAgentVolumeNullError *)
										False (* resolveMixAlkylatingAgentVolumeConcentrationMismatchError *)
									}
								];

								(* Resolve ConcentratedSDSBuffer vs SDS Buffer *)
								{
									(* concentratedSDSBuffer branch *)
									resolveMixConcentratedSDSBuffer,
									resolveMixConcentratedSDSBufferVolume,
									resolveMixConcentratedSDSBufferDilutionFactor,
									resolveMixConcentratedSDSBufferDilutionFactorNullError
								}=If[Not[totalVolumeNullError],
									If[MatchQ[Lookup[myMapThreadOptions,ConcentratedSDSBuffer],Except[Null]],
										Switch[Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume],
											(* If ConcentratedSDSBufferVolume is set to value or null, use it *)
											VolumeP,
											{
												Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
												Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume],
												Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>N[totalVolume/Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]],
												False
											},
											Automatic,
											If[MatchQ[Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor],Except[Null]],
												(* Dilution factor is informed or automatic. default value is 2X *)
												{
													Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
													RoundOptionPrecision[totalVolume/(Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>2),10^-1 Microliter,AvoidZero->True],
													Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>2,
													False
												},
												{
													Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
													Null,
													Null,
													True
												}],
											Null,
											{
												Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
												Null,
												Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
												False
											}],
										(* ConcentratedSDSBuffer unresolvable *)
										{
											Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
											Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
											Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
											False
										}],
									{
										Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
										Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
										Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
										False
									}
								];

								(* in order to calculate how much volume needs to be added *)
								volumeLeft=RoundOptionPrecision[totalVolume-Total[ReplaceAll[{sampleVolume,mixInternalReferenceVolume,mixReducingAgentVolume,mixAlkylatingAgentVolume},Null->0Microliter]],10^-1 Microliter,AvoidZero->True];

								{
									(* SDSBuffer branch *)
									resolveMixSDSBuffer,
									resolveMixSDSBufferVolume
								}=If[MatchQ[Lookup[myMapThreadOptions,SDSBuffer],Except[Null]],
									Switch[Lookup[myMapThreadOptions,SDSBufferVolume],
										(* If ConcentratedSDSBufferVolume is set to value or null, use it *)
										VolumeP,
										{
											Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
											Lookup[myMapThreadOptions,SDSBufferVolume]
										},
										Automatic,
										{
											Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
											volumeLeft
										},
										Null,
										{
											Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
											Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
										}],
									{
										Null,
										Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
									}
								];

								(* Figure out which branch to continue with ConcentratedSDSBuffer vs SDSBuffer*)
								(* first, figure out which branch can be resolved, if both can, and all are automatic, choose ConcentratedSDS *)
								mixConcentratedSDSBool=!NullQ[resolveMixConcentratedSDSBuffer]&&!NullQ[resolveMixConcentratedSDSBufferVolume];
								mixSDSBool=!NullQ[resolveMixSDSBuffer]&&!NullQ[resolveMixSDSBufferVolume];

								(* if no SDS buffer specified, raise an error *)
								mixSDSBufferNullError=NullQ[resolveMixConcentratedSDSBuffer]&&NullQ[resolveMixSDSBuffer];

								(* check which branch is user defined *)
								concentratedSDSUserDefinedBool=Or@@(MatchQ[Lookup[myMapThreadOptions,#],Except[Null|Automatic]]&/@{ConcentratedSDSBuffer,ConcentratedSDSBufferVolume,ConcentratedSDSBufferDilutionFactor});
								sdsBufferUserDefinedBool=Or@@(MatchQ[Lookup[myMapThreadOptions,#],Except[Null|Automatic]]&/@{SDSBuffer,SDSBufferVolume});

								(* if both branches can be successfully resolved, raise a warning (would pick either ConcentratedSDSBuffer, or the branch that was filled by user *)
								mixBothSDSBranchesSetWarning=mixConcentratedSDSBool&&mixSDSBool&&concentratedSDSUserDefinedBool&&sdsBufferUserDefinedBool;

								{
									mixConcentratedSDSBuffer,
									mixConcentratedSDSBufferVolume,
									mixConcentratedSDSBufferDilutionFactor,
									mixConcentratedSDSBufferDilutionFactorNullError,
									mixSDSBuffer,
									mixSDSBufferVolume
								}=Which[
									(* both buffers are Null *)
									mixSDSBufferNullError,
									{
										Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
										Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
										Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
										False,
										Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
										Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
									},
									(* If ConcentratedSDS is user informed, but invalid *)
									!mixConcentratedSDSBool&&concentratedSDSUserDefinedBool,
									{
										Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
										Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
										Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
										True,
										Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
										Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
									},
									(* if only concentratedSDS is resolved *)
									mixConcentratedSDSBool&&!mixSDSBool,
									{
										resolveMixConcentratedSDSBuffer,
										resolveMixConcentratedSDSBufferVolume,
										resolveMixConcentratedSDSBufferDilutionFactor,
										resolveMixConcentratedSDSBufferDilutionFactorNullError,
										Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
										Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
									},
									(* if only SDSBuffer is resolved *)
									!mixConcentratedSDSBool&&mixSDSBool,
									{
										Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
										Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
										Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
										False,
										resolveMixSDSBuffer,
										resolveMixSDSBufferVolume
									},
									(* If both branches resolved, check which one is user informed and return that one, alternatively, return ConcentratedSDS *)
									mixConcentratedSDSBool&&mixSDSBool,
									(* ConcentratedSDS is user informed *)
									Which[
										concentratedSDSUserDefinedBool@@!sdsBufferUserDefinedBool,
										{
											resolveMixConcentratedSDSBuffer,
											resolveMixConcentratedSDSBufferVolume,
											resolveMixConcentratedSDSBufferDilutionFactor,
											resolveMixConcentratedSDSBufferDilutionFactorNullError,
											Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
											Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
										},
										(* SDSBuffer is user informed *)
										sdsBufferUserDefinedBool&&!concentratedSDSUserDefinedBool,
										{
											Lookup[myMapThreadOptions,ConcentratedSDSBuffer]/.Automatic:>Null,
											Lookup[myMapThreadOptions,ConcentratedSDSBufferVolume]/.Automatic:>Null,
											Lookup[myMapThreadOptions,ConcentratedSDSBufferDilutionFactor]/.Automatic:>Null,
											resolveMixConcentratedSDSBufferDilutionFactorNullError,
											resolveMixSDSBuffer,
											resolveMixSDSBufferVolume
										},
										(* Neither is user informed, go on with ConcentratedSDS *)
										True,
										{
											resolveMixConcentratedSDSBuffer,
											resolveMixConcentratedSDSBufferVolume,
											resolveMixConcentratedSDSBufferDilutionFactor,
											resolveMixConcentratedSDSBufferDilutionFactorNullError,
											Lookup[myMapThreadOptions,SDSBuffer]/.Automatic:>Null,
											Lookup[myMapThreadOptions,SDSBufferVolume]/.Automatic:>Null
										}
									]
								];

								(* check the amount of SDS added to sample, warn if below 0.5% *)

								(* grab the SDSbuffer that is not Null, if any.. *)
								sampleSDSBuffer=If[!mixSDSBufferNullError&&Not[totalVolumeNullError],
									First[Cases[{mixConcentratedSDSBuffer,mixSDSBuffer},ObjectP[]]],
									Null];

								(* fetch packet and pull out SDS *)
								sampleBufferCompositionIDs=If[!mixSDSBufferNullError&&Not[totalVolumeNullError],
									Module[{sampleBufferPacket,sampleBufferComposition,sampleBufferCompositionPackets},
										sampleBufferPacket=fetchPacketFromCache[Download[sampleSDSBuffer,Object],optionObjectModelPackets];
										sampleBufferComposition=Lookup[sampleBufferPacket,Composition];
										(* construct list with concentration and molecule composition *)
										sampleBufferCompositionPackets=Map[
											Function[molecule,{molecule[[1]],fetchPacketFromCache[Download[molecule[[2]],Object],optionObjectModelCompositionPackets]}],
											sampleBufferComposition];
										(* get list of identifying strings per model[Molecule in composition, along with the object and concentration to compare *)
										{Object/.#[[2]],#[[1]],Flatten[{CAS,InChI,InChIKey,Synonyms}/.#[[2]]]} &/@sampleBufferCompositionPackets
									],
									{}];

								(* Identifiers for SDS *)
								sds={"Sodium dodecyl sulfate","SDS","Sodium lauryl sulfate","151-21-3",
									"InChI=1S/C12H26O4S.Na/c1-2-3-4-5-6-7-8-9-10-11-12-16-17(13,14)15;/h2-12H2,1H3,(H,13,14,15);/q;+1/p-1",
									"InChI=1S/C12H26O4S.Na/c1-2-3-4-5-6-7-8-9-10-11-12-16-17(13,14)15;/h2-12H2,1H3,(H,13,14,15);/q;+1/p-1",
									"DBMJMQXJHONAFJ-UHFFFAOYSA-M"};

								(* Figure out which we've got - construct a list of lists, with the ID and concentration as collected above *)
								(* Note - this assumes a single reducing agent in the sample; if more, user will need to specify volume *)

								identifySDS=If[!MatchQ[sampleBufferCompositionIDs,{}],
									Map[Function[compositionMolecule,
										{
											compositionMolecule[[1]] (* ObjectID *),
											compositionMolecule[[2]] (* Concentration *),
											Which[
												ContainsAny[compositionMolecule[[3]],sds],"SDS"
											]
										}
									],
										sampleBufferCompositionIDs],
									Null
								];


								(* pick out cases where the second index in the list is not null *)
								sdsObject=If[!NullQ[identifySDS],
									Cases[identifySDS,{ObjectP[],_,Except[NullP]}],
									Null];

								bufferVolume=If[And[!NullQ[identifySDS],Or[!NullQ[mixConcentratedSDSBufferVolume],!NullQ[mixSDSBufferVolume]]],
									First[Cases[{mixConcentratedSDSBufferVolume,mixSDSBufferVolume},VolumeP]],
									Null];

								mixNotEnoughSDSinSampleWarning=Which[
									(* missing total volume*)
									totalVolumeNullError,False,
									(* no valid buffer *)
									NullQ[mixConcentratedSDSBufferVolume]&&NullQ[mixSDSBufferVolume],False,
									(* no SDS identified in buffer *)
									MatchQ[sdsObject,{}],True,
									(* there's something there.. *)
									QuantityUnit[First[sdsObject][[2]]]==IndependentUnit["MassPercent"],
									First[sdsObject][[2]]*bufferVolume/totalVolume<0.5 MassPercent,
									MatchQ[Convert[First[sdsObject][[2]],Gram/Milliliter],Except[$Failed]],
									First[sdsObject][[2]]*bufferVolume/totalVolume<0.005 Gram/Milliliter,
									MatchQ[Convert[First[sdsObject][[2]],Millimolar],Except[$Failed]],
									First[sdsObject][[2]]*bufferVolume/totalVolume<17.3 Millimolar,
									True,False
								];

								{
									mixVolumeGreaterThanTotalVolumeError,
									mixComponentsDontSumToTotalVolumeError,
									mixDiluent
								}=Which[
									(* missing total volume*)
									totalVolumeNullError,
									{False,False,Lookup[myMapThreadOptions,LadderDiluent]/.Automatic:>Null},
									(* If no SDS buffer is available *)
									mixSDSBufferNullError,
									{False,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null},
									(* if ConcentratedSDSBuffer is specified but Dilution Factor is Null *)
									mixConcentratedSDSBufferDilutionFactorNullError,
									{False,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null},
									(* if on ConcentratedSDS branch or if both are user defined *)
									Or[(!NullQ[mixConcentratedSDSBuffer]&&NullQ[mixSDSBuffer]),mixBothSDSBranchesSetWarning],
									Which[
										(* if there's no room for more liquid, no need for a diluent *)
										(volumeLeft-mixConcentratedSDSBufferVolume)==0Microliter,{False,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null},
										(* If there's room, use diluent, if not set, use water *)
										(volumeLeft-mixConcentratedSDSBufferVolume)>0Microliter,{False,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Model[Sample,"Milli-Q water"]},
										(* if we're over the TotalVolume, raise an error *)
										(volumeLeft-mixConcentratedSDSBufferVolume)<0Microliter,{True,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null}
									],
									(* if on SDSBuffer branch *)
									NullQ[mixConcentratedSDSBuffer]&&!NullQ[mixSDSBuffer],
									Which[
										(* if we're at the TotalVolume, We're All good *)
										(volumeLeft-mixSDSBufferVolume)==0Microliter,{False,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null},
										(* if we're below the TotalVolume, raise an error (the volume of SDSBuffer is not enough to fill *)
										(volumeLeft-mixSDSBufferVolume)>0Microliter,{False,True,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null},
										(* if we're over the TotalVolume, raise an error *)
										(volumeLeft-mixSDSBufferVolume)<0Microliter,{True,False,Lookup[myMapThreadOptions,Diluent]/.Automatic:>Null}
									]
								];

								(* if need a diluent and it is set to Null, raise Error and set to water *)
								mixDiluentNullError=Which[
									mixConcentratedSDSBufferDilutionFactorNullError,
									False,
									NullQ[mixSDSBuffer]&&!NullQ[mixConcentratedSDSBuffer],
									(volumeLeft-mixConcentratedSDSBufferVolume)>0*Microliter&&MatchQ[mixDiluent,Null],
									!NullQ[mixSDSBuffer]&&NullQ[mixConcentratedSDSBuffer],
									False,
									True,
									False
								];

								(* Gather all resolved options and errors to return *)
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
									False,(* masterMixDiluentNullError*)
									(* make-your-own mix branch's options *)
									mixInternalReference,
									mixInternalReferenceDilutionFactor,
									mixInternalReferenceVolume,
									mixConcentratedSDSBuffer,
									mixConcentratedSDSBufferDilutionFactor,
									mixDiluent,
									mixConcentratedSDSBufferVolume,
									mixSDSBuffer,
									mixSDSBufferVolume,
									mixReduction,
									mixReducingAgent,
									mixReducingAgentTargetConcentration,
									mixReducingAgentVolume,
									mixAlkylation,
									mixAlkylatingAgent,
									mixAlkylatingAgentTargetConcentration,
									mixAlkylatingAgentVolume,
									(* make-your-own mix branch's errors  *)
									intReferenceNullError,
									intReferenceDilutionFactorNullError,
									intReferenceVolumeNullError,
									intReferenceVolumeDilutionFactorMismatchWarning,
									mixReducingAgentNullError,
									mixNoReducingAgentIdentifiedWarning,
									mixReducingAgentTargetConcentrationNullError,
									mixReducingAgentVolumeNullError,
									mixReducingAgentVolumeConcentrationMismatchError,
									mixAlkylatingAgentNullError,
									mixNoAlkylatingAgentIdentifiedWarning,
									mixAlkylatingAgentTargetConcentrationNullError,
									mixAlkylatingAgentVolumeNullError,
									mixAlkylatingAgentVolumeConcentrationMismatchError,
									resolveMixConcentratedSDSBufferDilutionFactorNullError,
									mixSDSBufferNullError,
									mixBothSDSBranchesSetWarning,
									mixConcentratedSDSBufferDilutionFactorNullError,
									mixNotEnoughSDSinSampleWarning,
									mixVolumeGreaterThanTotalVolumeError,
									mixComponentsDontSumToTotalVolumeError,
									mixDiluentNullError
								}
							]
						];

						(* InjectoinVoltageProfile *)
						injectionVoltageDurationProfile=Lookup[myMapThreadOptions,InjectionVoltageDurationProfile]/.
							Automatic:>First[Commonest[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionVoltageDurationProfile],1]];

						(* resolve SeparationVoltageDurationProfile *)
						separationVoltageDurationProfile=Which[
							(* if separationProfile is Automatic, and sample is reduced *)
							MatchQ[Lookup[myMapThreadOptions,SeparationVoltageDurationProfile],Automatic]&&TrueQ[reduction],List[{5750 Volt,35 Minute}],
							(* if separationProfile is Automatic, sample is not reduced, and adding a ladder suggests a longer run is required *)
							MatchQ[Lookup[myMapThreadOptions,SeparationVoltageDurationProfile],Automatic]&&!TrueQ[reduction]&&TrueQ[Lookup[myMapThreadOptions,IncludeLadders]],List[{5750 Volt,35 Minute}],
							(* if separationProfile is Automatic, sample is not reduced, and not adding a ladder suggests running mABs so run can be shorter *)
							MatchQ[Lookup[myMapThreadOptions,SeparationVoltageDurationProfile],Automatic]&&!TrueQ[reduction]&&!TrueQ[Lookup[myMapThreadOptions,IncludeLadders]],List[{5750 Volt,25 Minute}],
							(* if separationProfile is user specified, sample is not reduced, and not adding a ladder suggests running mABs so run can be shorter *)
							MatchQ[Lookup[myMapThreadOptions,SeparationVoltageDurationProfile],{{VoltageP,TimeP}..}],Lookup[myMapThreadOptions,SeparationVoltageDurationProfile]
						];

						(* All sample branches gather here; resolve SupernatantVolume *)
						supernatantVolume=If[resolvedIncludeCentrifugation,
							Switch[
								Lookup[myMapThreadOptions,SedimentationSupernatantVolume],
								Automatic,RoundOptionPrecision[0.9*totalVolume,10^-1 Microliter,AvoidZero->True],
								Except[Automatic],Lookup[myMapThreadOptions,SedimentationSupernatantVolume]
							],
							Lookup[myMapThreadOptions,SedimentationSupernatantVolume]/.Automatic:>Null;
						];
						(* check if resolved value is larger than TotalVolume or Null *)
						supernatantVolumeInvalidError=If[resolvedIncludeCentrifugation,
							Or[NullQ[supernatantVolume],supernatantVolume>totalVolume],
							False
						];

						(* Gather MapThread results *)
						{
							(*1*)(* General options variables *)
							(*2*)totalVolume,
							(*3*)sampleVolume,
							(*4*)sampleFrequency,
							(*5*)supernatantVolume,
							(*6*)separationVoltageDurationProfile,
							(*7*)injectionVoltageDurationProfile,
							(*13*)(* General options errors *)
							totalVolumeNullError,
							volumeNullError,
							(*14*)missingSampleCompositionWarning,
							(*15*)supernatantVolumeInvalidError,
							(*18*)(* premade mastermix branch variables *)
							resolvePremadeMasterMix,
							premadeMasterMixReagent,
							(*19*)premadeMasterMixVolume,
							(*20*)premadeMasterMixDilutionFactor,
							(*21*)premadeMasterMixDiluent,
							(*22*)(* premade mastermix branch errors *)
							(*23*)premadeMasterMixNullError,
							(*24*)premadeMasterMixDilutionFactorNullError,
							(*25*)premadeMasterMixVolumeNullError,
							(*26*)premadeMasterMixVolumeDilutionFactorMismatchWarning,
							(*27*)premadeMasterMixTotalVolumeError,
							premadeMasterMixDiluentNullError,
							(*28*)(* make-ones-own mastermix branch variables *)
							(*29*)internalReference,
							(*30*)internalReferenceDilutionFactor,
							(*31*)internalReferenceVolume,
							(*32*)concentratedSDSBuffer,
							(*33*)concentratedSDSBufferDilutionFactor,
							(*34*)diluent,
							(*35*)concentratedSDSBufferVolume,
							(*36*)sDSBuffer,
							(*37*)sDSBufferVolume,
							(*38*)reduction,
							(*39*)reducingAgent,
							(*40*)reducingAgentTargetConcentration,
							(*41*)reducingAgentVolume,
							(*42*)alkylation,
							(*43*)alkylatingAgent,
							(*44*)alkylatingAgentTargetConcentration,
							(*45*)alkylatingAgentVolume,
							(*46*)(* make-ones-own mastermix branch errors *)
							(*47*)internalReferenceNullError,
							(*48*)internalReferenceDilutionFactorNullError,
							internalReferenceVolumeNullError,
							(*49*)internalReferenceVolumeDilutionFactorMismatchWarning,
							(*50*)reducingAgentNullError,
							(*51*)noReducingAgentIdentifiedWarning,
							(*52*)reducingAgentTargetConcentrationNullError,
							(*53*)reducingAgentVolumeNullError,
							(*54*)reducingAgentVolumeConcentrationMismatchError,
							(*55*)alkylatingAgentNullError,
							(*56*)noAlkylatingAgentIdentifiedWarning,
							(*57*)alkylatingAgentTargetConcentrationNullError,
							(*58*)alkylatingAgentVolumeNullError,
							(*59*)alkylatingAgentVolumeConcentrationMismatchError,
							(*60*)sDSBufferNullError,
							(*61*)bothSDSBranchesSetWarning,
							(*62*)concentratedSDSBufferDilutionFactorNullError,
							(*63*)notEnoughSDSinSampleWarning,
							(*64*)volumeGreaterThanTotalVolumeError,
							(*65*)componentsDontSumToTotalVolumeError,
							(*66*)diluentNullError
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

	(* If there is a user specified injection table, check if there is agreement between samples on the injection list and in options,
	if not, dont bother trying to populate volumes, we're raising an error a bit later *)

	injectionTableContainsAllQ=If[MatchQ[specifiedInjectionTable,Except[Automatic]]&&NullQ[specifiedNumberOfReplicates],
		Not[Or@@{
			injectionTableSamplesNotCopaceticQ,
			injectionTableLaddersNotCopaceticQ,
			injectionTableStandardNotCopaceticQ,
			injectionTableBlankNotCopaceticQ
		}],
		True
	];

	(* generate an injection Table based on samples, ladders, blanks, and standards *)
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

	resolvedInjectionTable=Which[
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],Automatic]&&injectionTableContainsAllQ&&Not[Or@@volumeZeroInjectionTableBool],
		Module[{samplesInjectionTable,blanksInjectionTable,ladderInjectionTable,replicates,restructuredSamplesList},
			(* add Sample type and repeat as NumberOfReplicates *)
			replicates=Lookup[roundedCapillaryGelElectrophoresisSDSOptions,NumberOfReplicates]/.Null:>1;
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
			(* resolve blanks, ladders, and standards, in this order. ladderReplicates refers to the number of different running conditions used on samples.*)
			blanksInjectionTable=populateInjectionTable[
				Blank,
				resolvedBlanks/.Null|{Null}:>{},
				resolvedBlankVolume/.Null|{Null}:>{},
				restructuredSamplesList,
				resolveIncludeBlanks,
				ToList[resolvedBlankFrequency],1];
			(* Ladders need to be run with all permutations of voltageDuration profiles, so need to count those and replicate *)
			ladderInjectionTable=populateInjectionTable[
				Ladder,
				resolvedLadders/.Null|{Null}:>{},
				resolvedLadderVolume/.Null|{Null}:>{},
				blanksInjectionTable,
				resolveIncludeLadders,
				ToList[resolvedLadderFrequency],1];
			(* to get number of replicates required for ladder, check how many combinations of running conditions there are *)
			populateInjectionTable[
				Standard,
				resolvedStandards/.Null|{Null}:>{},
				resolvedStandardVolume/.Null|{Null}:>{},
				ladderInjectionTable,
				resolveIncludeStandards,
				ToList[resolvedStandardFrequency],1]
		],
		(* If there is a user specified injection table, check if there is agreement between samples on the
		injection list and in options,if not, dont bother trying to populate volumes *)
		(* But first we need to populate the sampleIndex, we can do this by their order *)
		MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable],Except[Automatic]]&&injectionTableContainsAllQ&&Not[Or@@volumeZeroInjectionTableBool]&&MatchQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,NumberOfReplicates], Alternatives[Automatic|Null]],
		Module[{indexedInjectionTable,sampleInjectionPositions,updatedSampleTuples,ladderInjectionPositions,
			updatedLadderTuples,standardInjectionPositions,updatedStandardTuples,blankInjectionPositions,updatedBlankTuples},

			indexedInjectionTable = Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionTable];

			(*for all the sample positions. should be directly index matched to the input samples*)
			sampleInjectionPositions=Flatten@Position[indexedInjectionTable[[All,1]],Sample];

			(*update the tuples with the index information*)
			updatedSampleTuples =MapThread[Append[#1,#2]&,{indexedInjectionTable[[sampleInjectionPositions]],Range[Length[sampleInjectionPositions]]}];
			indexedInjectionTable[[sampleInjectionPositions]]=updatedSampleTuples;

			(*for all the ladder positions. should be directly index matched to the input samples*)
			ladderInjectionPositions=Flatten@Position[indexedInjectionTable[[All,1]],Ladder];

			(*update the tuples with the index information*)
			updatedLadderTuples =MapThread[Append[#1,#2]&,{indexedInjectionTable[[ladderInjectionPositions]],Range[Length[ladderInjectionPositions]]}];
			indexedInjectionTable[[ladderInjectionPositions]]=updatedLadderTuples;

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
				(* if an injection table has been specified, we still need to make sure it has all the right volumes. *)
				replaceAutomaticVolumes[
					indexedInjectionTable,
					{},
					resolvedSampleVolume,
					resolvedStandardVolume/.Null:>{},
					resolvedBlankVolume/.Null:>{},
					resolvedLadderVolume/.Null:>{}
				],
				indexedInjectionTable
			]
		],
		(* else avoid issues.. *)
		True, {}
	];

	(* resolve centrifugation speed *)
	(* resolving based on the Eppendorf 5920R (rotor radius is 19.5cm), which is the preferred device for 96-well pcr plates *)

	{
		resolveSedimentationCentrifugationForce,
		resolveSedimentationCentrifugationSpeed
	}=If[resolvedIncludeCentrifugation,
		Switch[
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationForce],
			Automatic,
			Switch[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationSpeed],
				Automatic,{1000*GravitationalAcceleration,rcfToRPM[1000*GravitationalAcceleration,19.5Centimeter]},
				Null,{1000*GravitationalAcceleration,Null},
				_,{rpmToRCF[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationSpeed],19.5Centimeter],Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationSpeed]}
			],
			Null,
			Switch[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationSpeed],
				Automatic,{Null,rcfToRPM[1000*GravitationalAcceleration,19.5Centimeter]},
				Null,{Null,Null},
				_,{Null,Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationSpeed]}
			],
			_,
			Switch[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationSpeed],
				Automatic,{Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationForce],rcfToRPM[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationForce],19.5Centimeter]},
				Null,{Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationForce],Null},
				_,{Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationForce],Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationSpeed]}
			]],
		{
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationForce]/.Automatic:>Null,
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationSpeed]/.Automatic:>Null
		}
	];

	(* Will round only after error checking and will always round down, to avoid weird mistakes *)
	{
		sedimentationForceSpeedMismatchs,
		sedimentationForceSpeedNulls
	}=If[resolvedIncludeCentrifugation,
		Which[
			(NullQ[resolveSedimentationCentrifugationForce]||NullQ[resolveSedimentationCentrifugationSpeed]),
			{False,True},
			(!NullQ[resolveSedimentationCentrifugationForce]&&!NullQ[resolveSedimentationCentrifugationSpeed]&&
				(Abs[rcfToRPM[resolveSedimentationCentrifugationForce,19.5Centimeter]-resolveSedimentationCentrifugationSpeed]>10RPM)),
			{True,False},
			True,
			{False,False}
		],
		{False,False}
	];

	resolvedSedimentationCentrifugationForce=RoundOptionPrecision[resolveSedimentationCentrifugationForce,10*GravitationalAcceleration,Round->Down];
	resolvedSedimentationCentrifugationSpeed=RoundOptionPrecision[resolveSedimentationCentrifugationSpeed,10*RPM,Round->Down];

	resolvedSedimentationCentrifugationTime=RoundOptionPrecision[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationTime],10*Second,Round->Up];
	resolvedSedimentationCentrifugationTemperature=RoundOptionPrecision[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SedimentationCentrifugationTemperature],1*Celsius,Round->Down];

	(* resolve incubation *)
	resolvedDenaturingTemperature=If[resolvedIncludeIncubation,
		Switch[
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,DenaturingTemperature],
			Automatic,70Celsius,
			Except[Automatic],Lookup[roundedCapillaryGelElectrophoresisSDSOptions,DenaturingTemperature]
		],
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,DenaturingTemperature]/.Automatic:>Null
	];

	resolvedDenaturingTime=If[resolvedIncludeIncubation,
		Switch[
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,DenaturingTime],
			Automatic,10Minute,
			Except[Automatic],Lookup[roundedCapillaryGelElectrophoresisSDSOptions,DenaturingTime]
		],
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,DenaturingTime]/.Automatic:>Null
	];

	resolvedCoolingTemperature=If[resolvedIncludeIncubation,
		Switch[
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,CoolingTemperature],
			Automatic,4Celsius,
			Except[Automatic],Lookup[roundedCapillaryGelElectrophoresisSDSOptions,CoolingTemperature]
		],
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,CoolingTemperature]/.Automatic:>Null
	];

	resolvedCoolingTime=If[resolvedIncludeIncubation,
		Switch[
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,CoolingTime],
			Automatic,5Minute,
			Except[Automatic],Lookup[roundedCapillaryGelElectrophoresisSDSOptions,CoolingTime]
		],
		Lookup[roundedCapillaryGelElectrophoresisSDSOptions,CoolingTime]/.Automatic:>Null
	];


	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* Invalid Name *)
	(* If the Name is not in the database, it is valid *)
	validNameQ=If[MatchQ[name,_String],
		Not[DatabaseMemberQ[Object[Protocol,CapillaryGelElectrophoresisSDS,Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Name]]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions=If[Not[validNameQ]&&messages,
		(
			Message[Error::DuplicateName,"CapillaryGelElectrophoresisSDS protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[name,_String],
		Test["If specified, Name is not already a CapillaryGelElectrophoresisSDS object name:",
			validNameQ,
			True
		],
		Null
	];

	(* TooManySamples *)
	(* Count the number of sample * NumberOfReplicates + number of Standards*Frequency + number of Blanks*Frequency, + # of ladders*Frequency*UniqueInjectionConditions *)

	(* calculate the total number of injections for standards, based on Frequency *)
	sampleCountQ=Length[resolvedInjectionTable]>48;

	(* if sampleCountQ is True AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {injectionCount}; otherwise, {} is fine *)
	sampleCountInvalidOption=If[sampleCountQ&&messages,
		(
			Message[Error::TooManyInjectionsCapillaryGelElectrophoresis,Length[resolvedInjectionTable]];
			{Blanks,Ladders,Standards,NumberOfReplicates,BlankFrequency,LadderFrequency,StandardFrequency}
		),
		{}
	];

	(* Generate Test for sampleCount check *)
	sampleCountTest=If[gatherTests,
		Test["The total number of injections specified for samples, ladders, blanks, and standards can be run in a single batch:",
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
		(Lookup[cartridgeModelPacket,MaxNumberOfUses,500])-(Lookup[cartridgePacket,NumberOfUses,0]),
		(* if Model, grab MaxNumberOfUses *)
		ObjectP[Model[Container,ProteinCapillaryElectrophoresisCartridge]],
		Lookup[cartridgeModelPacket,MaxNumberOfUses,500]
	];

	notEnoughUsesLeftOption=If[usesLeftOnCartridge<Length[resolvedInjectionTable]&&!sampleCountQ&&!engineQ,
		(
			Message[Error::NotEnoughUsesLeftOnCartridge,ObjectToString[Lookup[cartridgePacket,Object],Cache->inheritedCache],usesLeftOnCartridge];
			{Cartridge}
		),
		{}
	];

	(* If we need to gather tests, generate the tests for cartridge check *)
	notEnoughUsesLeftOptionTest=If[gatherTests,
		Test["The number of injections in this protocol does not exceed the total number of uses left on the chosen cartridge:",
			usesLeftOnCartridge>Length[resolvedInjectionTable]&&!sampleCountQ,
			True
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
	notEnoughOptimalUsesLeftOption=If[optimalUsesLeftOnCartridge<Length[resolvedInjectionTable]&&!engineQ&&!(usesLeftOnCartridge<Length[resolvedInjectionTable])&&!sampleCountQ,
		(
			Message[Warning::NotEnoughOptimalUsesLeftOnCartridge,ObjectToString[Lookup[cartridgePacket,Object],Cache->inheritedCache],optimalUsesLeftOnCartridge];
			{Cartridge}
		),
		{}
	];

	(* If we need to gather tests, generate the tests for cartridge check *)
	notEnoughOptimalUsesLeftOptionTest=If[gatherTests,
		Warning["The number of injections in this protocol does not exceed the number of optimal uses left on the chosen cartridge:",
			optimalUsesLeftOnCartridge>Length[resolvedInjectionTable]&&!(usesLeftOnCartridge<Length[resolvedInjectionTable])&&!sampleCountQ,
			True
		],
		Nothing
	];

	(* If ReplaceCartrdigeInsert is False, raise warning that this may be problematic for future experiments with this cartridge *)
	(* make sure not to raise both this warning and the previous error *)
	notReplacingInsertOption=If[!Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ReplaceCartridgeInsert]&&!engineQ,
		(
			Message[Warning::NotReplacingInsert];
			{ReplaceCartridgeInsert}
		),
		{}
	];

	(* If we need to gather tests, generate the tests for cartridge check *)
	notReplacingInsertTest=If[gatherTests,
		Warning["The cartridge insert can be replaced, if needed:",
			Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ReplaceCartridgeInsert],
			True
		],
		Nothing
	];

	(* InjectionTable Missing Samples *)
	(* check that the injection table contains all samples, blanks, standards, and ladders *)
	(* the boolean checking this is before resolving the injection table *)

	samplesMissingFromInjectionTables=If[injectionTableContainsAllQ,
		{},
		Join[
			Complement[specifiedInjectionTable[[All,2]],Cases[Flatten[Join[simulatedSamples,{resolvedLadders},{resolvedStandards},{resolvedBlanks}]],ObjectP[]]],
			Complement[Cases[Flatten[Join[simulatedSamples,{resolvedLadders},{resolvedStandards},{resolvedBlanks}]],ObjectP[]],specifiedInjectionTable[[All,2]]]
		]
	];

	(* if injectionTableContainsAllQ is True AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Length[resolvedInjectionTable]}; otherwise, {} is fine *)
	invalidInjectionTableOption=If[!injectionTableContainsAllQ&&messages,
		(
			Message[Error::InjectionTableMismatch,samplesMissingFromInjectionTables];
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


	(* totalVolumeNullErrors *)

	totalVolumeNullOptions=Flatten@PickList[
		{StandardTotalVolume,BlankTotalVolume,LadderTotalVolume},
		{Or@@standardTotalVolumeNullErrors,
			Or@@blankTotalVolumeNullErrors,
			Or@@ladderTotalVolumeNullErrors}
	];

	totalVolumeNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardTotalVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankTotalVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderTotalVolumeNullErrors]],Cache->inheritedCache]
	}];

	totalVolumeNullInvalidOptions=If[Length[totalVolumeNullOptions]>0&&messages,
		(
			Message[Error::TotalVolumeNull,totalVolumeNullInvalidSamples];
			totalVolumeNullOptions
		),
		{}
	];

	totalVolumeNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[resolvedStandards],ToList[standardTotalVolumeNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankTotalVolumeNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderTotalVolumeNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardTotalVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankTotalVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderTotalVolumeNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[resolvedStandards],standardTotalVolumeNullErrors,False],
				PickList[ToList[resolvedBlanks],blankTotalVolumeNullErrors,False],
				PickList[ToList[resolvedLadders],ladderTotalVolumeNullErrors,False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardTotalVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankTotalVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderTotalVolumeNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided objects "<>failingString<>",the total volume is specified:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided objects "<>passingString<>",the total volume is specified:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* volumeNullErrors *)
	volumeNullOptions=Flatten@PickList[
		{StandardVolume,BlankVolume,LadderVolume},
		{Or@@standardVolumeNullErrors,
			Or@@blankVolumeNullErrors,
			Or@@ladderVolumeNullErrors}
	];

	volumeNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderVolumeNullErrors]],Cache->inheritedCache]
	}];
	volumeNullInvalidOptions=If[Length[volumeNullOptions]>0&&messages,
		(
			Message[Error::VolumeNull,volumeNullInvalidSamples];
			volumeNullOptions
		),
		{}
	];

	volumeNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[resolvedStandards],ToList[standardVolumeNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankVolumeNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderVolumeNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderVolumeNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[resolvedStandards],ToList[standardVolumeNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankVolumeNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderVolumeNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderVolumeNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided objects "<>failingString<>", volume is specified:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided objects "<>passingString<>", volume is specified:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];


	(* ladderDilutionFactorNullError *)
	ladderDilutionFactorNullInvalidOptions=If[Or@@ladderDilutionFactorNullErrors&&messages,
		(
			Message[Error::LadderDilutionFactorNull,ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderDilutionFactorNullErrors]],Cache->inheritedCache]];
			{LadderDilutionFactor}
		),
		{}
	];

	ladderDilutionFactorNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[ToList[resolvedLadders],ToList[ladderDilutionFactorNullErrors]];

			(* get the inputs that pass this test *)
			passingSamples=PickList[ToList[resolvedLadders],ToList[ladderDilutionFactorNullErrors],False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided ladders "<>ObjectToString[failingSamples,Cache->inheritedCache]<>",the dilution factor is informed:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided ladders "<>ObjectToString[passingSamples,Cache->inheritedCache]<>",the dilution factor is informed:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* ladderAnalyteMolecularWeightMismatch *)
	ladderAnalyteMolecularWeightMismatchInvalidOptions=If[Or@@ladderAnalyteMolecularWeightMismatchs&&messages,
		(
			Message[Error::LadderAnalyteMolecularWeightMismatch,ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAnalyteMolecularWeightMismatchs]],Cache->inheritedCache]];
			{LadderAnalytes,LadderAnalyteMolecularWeights}
		),
		{}
	];

	ladderAnalyteMolecularWeightMismatchTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[ToList[resolvedLadders],ToList[ladderAnalyteMolecularWeightMismatchs]];

			(* get the inputs that pass this test *)
			passingSamples=PickList[ToList[resolvedLadders],ToList[ladderAnalyteMolecularWeightMismatchs],False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided ladders "<>ObjectToString[failingSamples,Cache->inheritedCache]<>",the molecular weight of their Analytes and that specified in AnalyteMolecularWeight is copacetic:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided ladders "<>ObjectToString[passingSamples,Cache->inheritedCache]<>",the molecular weight of their Analytes and that specified in AnalyteMolecularWeight is copacetic:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* ladderCompositionMolecularWeightMismatch *)
	ladderCompositionMolecularWeightMismatchInvalidOptions=If[Or@@ladderCompositionMolecularWeightMismatchs&&messages,
		(
			Message[Error::LadderCompositionMolecularWeightMismatch,ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderCompositionMolecularWeightMismatchs]],Cache->inheritedCache]];
			{Ladders,LadderAnalyteMolecularWeights}
		),
		{}
	];

	ladderCompositionMolecularWeightMismatchTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[ToList[resolvedLadders],ToList[ladderCompositionMolecularWeightMismatchs]];

			(* get the inputs that pass this test *)
			passingSamples=PickList[ToList[resolvedLadders],ToList[ladderCompositionMolecularWeightMismatchs],False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided ladders "<>ObjectToString[failingSamples,Cache->inheritedCache]<>",the molecular weight specified in their composition is copacetic with that specified in AnalyteMolecularWeight:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided ladders "<>ObjectToString[passingSamples,Cache->inheritedCache]<>",the molecular weight specified in their composition is copacetic with that specified in AnalyteMolecularWeight:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];


	(* ladderAnalytesCompositionMolecularWeightMismatchs *)
	ladderAnalytesCompositionMolecularWeightMismatchInvalidOptions=If[Or@@ladderAnalytesCompositionMolecularWeightMismatchs&&messages,
		(
			Message[Error::LadderAnalytesCompositionMolecularWeightMismatch,ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAnalytesCompositionMolecularWeightMismatchs]],Cache->inheritedCache]];
			{Ladders,LadderAnalytes}
		),
		{}
	];

	ladderAnalytesCompositionMolecularWeightMismatchTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[ToList[resolvedLadders],ToList[ladderAnalytesCompositionMolecularWeightMismatchs]];

			(* get the inputs that pass this test *)
			passingSamples=PickList[ToList[resolvedLadders],ToList[ladderAnalytesCompositionMolecularWeightMismatchs],False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided ladders "<>ObjectToString[failingSamples,Cache->inheritedCache]<>",the molecular weight specific in their composition is copacetic with that of the specific LadderAnalytes:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided ladders "<>ObjectToString[passingSamples,Cache->inheritedCache]<>",the molecular weight specific in their composition is copacetic with that of the specific LadderAnalytes:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];


	(* molecularWeightMissingInModelWarnings *)
	molecularWeightMissingInModelWarningInvalidOptions=If[Or@@molecularWeightMissingInModelWarnings&&messages,
		(
			Message[Error::MolecularWeightMissing,ObjectToString[PickList[ToList[resolvedLadders],ToList[molecularWeightMissingInModelWarnings]],Cache->inheritedCache]];
			{Ladders,LadderAnalyteMolecularWeights,LadderAnalyte}
		),
		{}
	];

	molecularWeightMissingInModelWarningTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples=PickList[ToList[resolvedLadders],ToList[molecularWeightMissingInModelWarnings]];

			(* get the inputs that pass this test *)
			passingSamples=PickList[ToList[resolvedLadders],ToList[molecularWeightMissingInModelWarnings],False];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided ladders "<>ObjectToString[failingSamples,Cache->inheritedCache]<>",molecular weight is informed by their composition, the Analyte composition, or by the AnalyteMolecularWeight:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided ladders "<>ObjectToString[passingSamples,Cache->inheritedCache]<>",molecular weight is informed by their composition, the Analyte composition, or by the AnalyteMolecularWeight:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	premadeMasterMixOptions={PremadeMasterMix,PremadeMasterMixReagent,PremadeMasterMixDiluent,PremadeMasterMixReagentDilutionFactor,
		PremadeMasterMixVolume};
	makeOnesOwnMasterMixOptions={InternalReference,InternalReferenceDilutionFactor,InternalReferenceVolume,ConcentratedSDSBuffer,
		ConcentratedSDSBufferDilutionFactor,Diluent,ConcentratedSDSBufferVolume,SDSBuffer,SDSBufferVolume,Reduction,ReducingAgent,
		ReducingAgentTargetConcentration,ReducingAgentVolume,Alkylation,AlkylatingAgent,AlkylatingAgentTargetConcentration,
		AlkylatingAgentVolume};
	ladderPremadeMasterMixOptions={LadderPremadeMasterMix,LadderPremadeMasterMixReagent,LadderPremadeMasterMixDiluent,LadderPremadeMasterMixReagentDilutionFactor,
		LadderPremadeMasterMixVolume};
	ladderMakeOnesOwnMasterMixOptions={LadderInternalReference,LadderInternalReferenceDilutionFactor,LadderInternalReferenceVolume,LadderConcentratedSDSBuffer,
		LadderConcentratedSDSBufferDilutionFactor,LadderDiluent,LadderConcentratedSDSBufferVolume,LadderSDSBuffer,LadderSDSBufferVolume,LadderReduction,LadderReducingAgent,
		LadderReducingAgentTargetConcentration,LadderReducingAgentVolume,LadderAlkylation,LadderAlkylatingAgent,LadderAlkylatingAgentTargetConcentration,
		LadderAlkylatingAgentVolume};

	(* PremadeMasterMix True but other branch's options are specified *)
	(* For each sample, check if options are different from default or null *);
	samplesMakeMasterMixOptionsSetBool=
		Map[Function[{preSampleOptions},
			Map[MatchQ[Lookup[preSampleOptions,#],Except[getDefault[#,opsDef]|Automatic|Null|False]]&,
				makeOnesOwnMasterMixOptions]],
			mapThreadFriendlyOptions];

	(* Check which samples are true for both *)
	premadeMasterMixWithmakeMasterMixOptionsSetQ=MapThread[
		And[MatchQ[#1,True],Or@@#2]&,
		{resolvedPremadeMasterMix,samplesMakeMasterMixOptionsSetBool}];

	(* same for standards *)
	standardMakeMasterMixOptionsSetBool=If[resolveIncludeStandards,
		Map[Function[{perStandardOptions},
			Map[MatchQ[Lookup[perStandardOptions,#],Except[getDefault[#,opsDef]|Automatic|Null|False]]&,
				makeOnesOwnMasterMixOptions]],
			mapThreadFriendlyStandardOptions],
		False];

	(* Check which samples are true for both *)
	standardPremadeMasterMixWithmakeMasterMixOptionsSetQ=If[resolveIncludeStandards,
		MapThread[
			And[MatchQ[#1,True],Or@@#2]&,
			{resolvedStandardPremadeMasterMix,standardMakeMasterMixOptionsSetBool}],
		{False}];

	(* And for blanks *)
	blankMakeMasterMixOptionsSetBool=If[resolveIncludeBlanks,
		Map[Function[{perBlankOptions},
			Map[MatchQ[Lookup[perBlankOptions,#],Except[getDefault[#,opsDef]|Automatic|Null|False]]&,
				makeOnesOwnMasterMixOptions]],
			mapThreadFriendlyBlankOptions],
		False];

	(* Check which samples are true for both *)
	blankPremadeMasterMixWithmakeMasterMixOptionsSetQ=If[resolveIncludeBlanks,
		MapThread[
			And[MatchQ[#1,True],Or@@#2]&,
			{resolvedBlankPremadeMasterMix,blankMakeMasterMixOptionsSetBool}],
		{False}];

	(* And... also for ladders *)
	ladderMakeMasterMixOptionsSetBool=If[resolveIncludeLadders,
		Map[Function[{perLadderOptions},
			Map[MatchQ[Lookup[perLadderOptions,#],Except[getDefault[#,opsDef]|Automatic|Null|False]]&,
				ladderMakeOnesOwnMasterMixOptions]],
			mapThreadFriendlyLadderOptions],
		False];

	(* Check which samples are true for both *)
	ladderPremadeMasterMixWithmakeMasterMixOptionsSetQ=If[resolveIncludeLadders,
		MapThread[
			And[MatchQ[#1,True],Or@@#2]&,
			{resolvedLadderPremadeMasterMix,ladderMakeMasterMixOptionsSetBool}],
		{False}];

	(* Grab the options that are indeed invalid between the different samples groups *)
	PreMadeMasterMixWithMakeOwnInvalidOptions=PickList[
		{PremadeMasterMix,StandardPremadeMasterMix,BlankPremadeMasterMix,LadderPremadeMasterMix},
		{
			Or@@premadeMasterMixWithmakeMasterMixOptionsSetQ,
			Or@@standardPremadeMasterMixWithmakeMasterMixOptionsSetQ,
			Or@@blankPremadeMasterMixWithmakeMasterMixOptionsSetQ,
			Or@@ladderPremadeMasterMixWithmakeMasterMixOptionsSetQ
		}
	];

	PreMadeMasterMixWithMakeOwnInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],premadeMasterMixWithmakeMasterMixOptionsSetQ],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],standardPremadeMasterMixWithmakeMasterMixOptionsSetQ],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],blankPremadeMasterMixWithmakeMasterMixOptionsSetQ],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ladderPremadeMasterMixWithmakeMasterMixOptionsSetQ],Cache->inheritedCache]
	}];


	(* if indeed PremadeMasterMix is true and other options are set, raise warning.*)
	premadeMasterMixWithmakeMasterMixOptionsSetInvalidOption=If[Length[PreMadeMasterMixWithMakeOwnInvalidOptions]>0&&messages&&!engineQ,
		(
			Message[Warning::PreMadeMasterMixWithMakeOwnOptions,PreMadeMasterMixWithMakeOwnInvalidSamples];
			PreMadeMasterMixWithMakeOwnInvalidOptions
		),
		{}
	];

	premadeMasterMixWithmakeMasterMixOptionsSetInvalidOptionTest=If[gatherTests,
		Warning["If Options for PremadeMasterMix are specified, no options are set for making master mix:",
			Length[PreMadeMasterMixWithMakeOwnInvalidOptions]>0,
			False
		],
		Nothing
	];


	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* missingSampleCompositionWarnings - raise warning if no composition is found and SampleVolume is automatic  *)

	(* Grab the options that are indeed invalid between the different samples groups *)
	missingSampleCompositionWarningsOptions=PickList[
		{SampleVolume,StandardVolume},
		{
			Or@@missingSampleCompositionWarnings,
			Or@@standardMissingSampleCompositionWarnings
		}
	];

	missingSampleCompositionWarningsSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[missingSampleCompositionWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardMissingSampleCompositionWarnings]],Cache->inheritedCache]
	}];

	If[Length[missingSampleCompositionWarningsOptions]>0&&messages&&Not[engineQ],
		(
			Message[Warning::MissingSampleComposition,missingSampleCompositionWarningsSamples];
			missingSampleCompositionWarningsOptions
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

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[missingSampleCompositionWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardMissingSampleCompositionWarnings]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[simulatedSamples,missingSampleCompositionWarnings,False],
				PickList[ToList[resolvedStandards],ToList[standardMissingSampleCompositionWarnings],False]
			];

			passingString=combineObjectsStrings[{
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


	(* supernatantVolumeInvalidErrors *)

	(* Grab the options that are indeed invalid between the different samples groups *)
	supernatantVolumeOptions=PickList[
		{SedimentationSupernatantVolume,StandardSedimentationSupernatantVolume,BlankSedimentationSupernatantVolume,LadderSedimentationSupernatantVolume},
		{Or@@supernatantVolumeInvalidErrors,
			Or@@standardSupernatantVolumeInvalidErrors,
			Or@@blankSupernatantVolumeInvalidErrors,
			Or@@ladderSupernatantVolumeInvalidErrors}
	];

	supernatantVolumeInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[supernatantVolumeInvalidErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardSupernatantVolumeInvalidErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankSupernatantVolumeInvalidErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderSupernatantVolumeInvalidErrors]],Cache->inheritedCache]
	}];

	supernatantVolumeInvalidOptions=If[Length[supernatantVolumeOptions]>0&&messages,
		(
			Message[Error::InvalidSupernatantVolume,supernatantVolumeInvalidSamples];
			supernatantVolumeOptions
		),
		{}
	];

	supernatantVolumeTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[supernatantVolumeInvalidErrors]],
				PickList[ToList[resolvedStandards],ToList[standardSupernatantVolumeInvalidErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankSupernatantVolumeInvalidErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderSupernatantVolumeInvalidErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[supernatantVolumeInvalidErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardSupernatantVolumeInvalidErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankSupernatantVolumeInvalidErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderSupernatantVolumeInvalidErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[supernatantVolumeInvalidErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardSupernatantVolumeInvalidErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankSupernatantVolumeInvalidErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderSupernatantVolumeInvalidErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[supernatantVolumeInvalidErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardSupernatantVolumeInvalidErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankSupernatantVolumeInvalidErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderSupernatantVolumeInvalidErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>", Supernatant volume is specified and Less than or equal to the Total Volume:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",Supernatant volume is specified and Less than or equal to the Total Volume:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];


	(* sedimentationForceSpeedMismatch *)

	sedimentationForceSpeedMismatchInvalidOptions=If[sedimentationForceSpeedMismatchs&&messages,
		(
			Message[Error::CentrifugationForceSpeedMismatch,centrifugeSpeedMismatchInvalidSamples];
			{SedimentationCentrifugationForce,SedimentationCentrifugationSpeed}
		),
		{}
	];

	sedimentationForceSpeedMismatchTests=If[gatherTests,
		Module[{failingTests,passingTests},


			(* create a test for the non-passing inputs *)
			failingTests=If[sedimentationForceSpeedMismatchs,
				Test["SedimentationCentrifugation Force and Speed are copacetic:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTests=If[!sedimentationForceSpeedMismatchs,
				Test["SedimentationCentrifugation Force and Speed are copacetic:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{failingTests,passingTests}
		]
	];

	(* sedimentationForceSpeedNulls *)
	sedimentationForceSpeedNullsInvalidOptions=If[sedimentationForceSpeedNulls&&messages,
		(
			Message[Error::CentrifugationForceSpeedNull,centrifugeForceSpeedNullInvalidSamples];
			{SedimentationCentrifugationForce,SedimentationCentrifugationSpeed}
		),
		{}
	];

	sedimentationForceSpeedNullsTests=If[gatherTests,
		Module[{failingTests,passingTests},

			(* create a test for the non-passing inputs *)
			failingTests=If[sedimentationForceSpeedNulls,
				Test["Either SedimentationCentrifugationForce or Speed (or both) is defined:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTests=If[!sedimentationForceSpeedNulls,
				Test["Either SedimentationCentrifugationForce or Speed (or both) is defined:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingTests,failingTests}
		]
	];

	(* premadeMasterMixNullErrors *)

	premadeMasterMixNullOptions=Flatten@PickList[
		{PremadeMasterMix,StandardPremadeMasterMix,BlankPremadeMasterMix,LadderPremadeMasterMix},
		{Or@@premadeMasterMixNullErrors,
			Or@@standardPremadeMasterMixNullErrors,
			Or@@blankPremadeMasterMixNullErrors,
			Or@@ladderPremadeMasterMixNullErrors}
	];

	premadeMasterMixNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixNullErrors]],Cache->inheritedCache]
	}];

	premadeMasterMixNullInvalidOptions=If[Length[premadeMasterMixNullOptions]>0&&messages,
		(
			Message[Error::PremadeMasterMixReagentNull,premadeMasterMixNullInvalidSamples];
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
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[premadeMasterMixNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixNullErrors],False],Cache->inheritedCache]
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

	premadeMasterMixReagentDilutionFactorNullOptions=Flatten@PickList[
		{PremadeMasterMixReagentDilutionFactor,StandardPremadeMasterMixReagentDilutionFactor,BlankPremadeMasterMixReagentDilutionFactor,LadderPremadeMasterMixReagentDilutionFactor},
		{Or@@premadeMasterMixDilutionFactorNullErrors,
			Or@@standardPremadeMasterMixDilutionFactorNullErrors,
			Or@@blankPremadeMasterMixDilutionFactorNullErrors,
			Or@@ladderPremadeMasterMixDilutionFactorNullErrors}
	];

	premadeMasterMixReagentDilutionFactorNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache]
	}];
	premadeMasterMixDilutionFactorNullInvalidOptions=If[Length[premadeMasterMixReagentDilutionFactorNullOptions]>0&&messages,
		(
			Message[Error::PremadeMasterMixDilutionFactorNull,premadeMasterMixReagentDilutionFactorNullInvalidSamples];
			premadeMasterMixReagentDilutionFactorNullOptions
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
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDilutionFactorNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixDilutionFactorNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixDilutionFactorNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[premadeMasterMixDilutionFactorNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDilutionFactorNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDilutionFactorNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixDilutionFactorNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDilutionFactorNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDilutionFactorNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDilutionFactorNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixDilutionFactorNullErrors],False],Cache->inheritedCache]
			}];

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
	premadeMasterMixVolumeNullOptions=Flatten@PickList[
		{PremadeMasterMixVolume,StandardPremadeMasterMixVolume,BlankPremadeMasterMixVolume,LadderPremadeMasterMixVolume},
		{Or@@premadeMasterMixVolumeNullErrors,
			Or@@standardPremadeMasterMixVolumeNullErrors,
			Or@@blankPremadeMasterMixVolumeNullErrors,
			Or@@ladderPremadeMasterMixVolumeNullErrors}
	];

	premadeMasterMixVolumeNullNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixVolumeNullErrors]],Cache->inheritedCache]
	}];

	premadeMasterMixVolumeNullInvalidOptions=If[Length[premadeMasterMixVolumeNullOptions]>0&&messages,
		(
			Message[Error::PremadeMasterMixVolumeNull,premadeMasterMixVolumeNullNullInvalidSamples];
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
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixVolumeNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixVolumeNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixVolumeNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixVolumeNullErrors],False],Cache->inheritedCache]
			}];

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

	premadeMasterMixVolumeDilutionFactorMismatchOptions=Flatten@PickList[
		{{PremadeMasterMixVolume,PremadeMasterMixReagentDilutionFactor},{StandardPremadeMasterMixVolume,StandardPremadeMasterMixReagentDilutionFactor},{BlankPremadeMasterMixVolume,BlankPremadeMasterMixReagentDilutionFactor},{LadderPremadeMasterMixVolume,LadderPremadeMasterMixReagentDilutionFactor}},
		{Or@@premadeMasterMixVolumeDilutionFactorMismatchWarnings,
			Or@@standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings,
			Or@@blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings,
			Or@@ladderPremadeMasterMixVolumeDilutionFactorMismatchWarnings}
	];

	premadeMasterMixVolumeDilutionFactorMismatchInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache]
	}];
	premadeMasterMixVolumeDilutionFactorMismatchInvalidOptions=If[Length[premadeMasterMixVolumeDilutionFactorMismatchOptions]>0&&messages,
		(
			Message[Error::PremadeMasterMixVolumeDilutionFactorMismatch,premadeMasterMixVolumeDilutionFactorMismatchInvalidSamples];
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
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixVolumeDilutionFactorMismatchWarnings]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeDilutionFactorMismatchWarnings],False],
				PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings],False],
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings],False],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixVolumeDilutionFactorMismatchWarnings],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixVolumeDilutionFactorMismatchWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixVolumeDilutionFactorMismatchWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixVolumeDilutionFactorMismatchWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixVolumeDilutionFactorMismatchWarnings],False],Cache->inheritedCache]
			}];

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

	premadeMasterMixTotalVolumeErrorsNullOptions=Flatten@PickList[
		{{TotalVolume,SampleVolume,PremadeMasterMixVolume},{StandardTotalVolume,StandardVolume,StandardPremadeMasterMixVolume},{BlankTotalVolume,BlankVolume,BlankPremadeMasterMixVolume},{LadderTotalVolume,LadderVolume,LadderPremadeMasterMixVolume}},
		{Or@@premadeMasterMixTotalVolumeErrors,
			Or@@standardPremadeMasterMixTotalVolumeErrors,
			Or@@blankPremadeMasterMixTotalVolumeErrors,
			Or@@ladderPremadeMasterMixTotalVolumeErrors}
	];

	premadeMasterMixTotalVolumeErrorsInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixTotalVolumeErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixTotalVolumeErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixTotalVolumeErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixTotalVolumeErrors]],Cache->inheritedCache]
	}];
	premadeMasterMixTotalVolumeInvalidOptions=If[Length[premadeMasterMixTotalVolumeErrorsNullOptions]>0&&messages,
		(
			Message[Error::PremadeMasterMixInvalidTotalVolume,premadeMasterMixTotalVolumeErrorsInvalidSamples];
			premadeMasterMixTotalVolumeErrorsNullOptions
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
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixTotalVolumeErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixTotalVolumeErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixTotalVolumeErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixTotalVolumeErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixTotalVolumeErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixTotalVolumeErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[premadeMasterMixTotalVolumeErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixTotalVolumeErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixTotalVolumeErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixTotalVolumeErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixTotalVolumeErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixTotalVolumeErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixTotalVolumeErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixTotalVolumeErrors],False],Cache->inheritedCache]
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

	premadeMasterMixDiluentNullOptions=Flatten@PickList[
		{PremadeMasterMixDiluent,StandardPremadeMasterMixDiluent,BlankPremadeMasterMixDiluent,LadderPremadeMasterMixDiluent},
		{Or@@premadeMasterMixDiluentNullErrors,
			Or@@standardPremadeMasterMixDiluentNullErrors,
			Or@@blankPremadeMasterMixDiluentNullErrors,
			Or@@ladderPremadeMasterMixDiluentNullErrors}
	];

	premadeMasterMixDiluentNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDiluentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDiluentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDiluentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixDiluentNullErrors]],Cache->inheritedCache]
	}];
	premadeMasterMixDiluentNullInvalidOptions=If[Length[premadeMasterMixDiluentNullOptions]>0&&messages,
		(
			Message[Error::PremadeMasterMixDiluentNull,premadeMasterMixDiluentNullInvalidSamples];
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
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDiluentNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixDiluentNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDiluentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDiluentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDiluentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixDiluentNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[premadeMasterMixDiluentNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDiluentNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDiluentNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixDiluentNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[premadeMasterMixDiluentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardPremadeMasterMixDiluentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankPremadeMasterMixDiluentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderPremadeMasterMixDiluentNullErrors],False],Cache->inheritedCache]
			}];

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

	(* internalReferenceNullErrors *)

	internalReferenceNullOptions=Flatten@PickList[
		{InternalReference,StandardInternalReference,BlankInternalReference,LadderInternalReference},
		{Or@@internalReferenceNullErrors,
			Or@@standardInternalReferenceNullErrors,
			Or@@blankInternalReferenceNullErrors,
			Or@@ladderInternalReferenceNullErrors}
	];

	internalReferenceNullNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceNullErrors]],Cache->inheritedCache]
	}];

	internalReferenceNullInvalidOptions=If[Length[internalReferenceNullOptions]>0&&messages,
		(
			Message[Error::InternalReferenceNull,internalReferenceNullNullInvalidSamples];
			internalReferenceNullOptions
		),
		{}
	];

	internalReferenceNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[internalReferenceNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardInternalReferenceNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[internalReferenceNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardInternalReferenceNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",InternalReference is informed where PremadeMasterMix is False:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",InternalReference is informed where PremadeMasterMix is False:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* internalReferenceDilutionFactorNullErrors *)
	internalReferenceDilutionFactorNullOptions=Flatten@PickList[
		{InternalReferenceDilutionFactor,StandardInternalReferenceDilutionFactor,BlankInternalReferenceDilutionFactor,LadderInternalReferenceDilutionFactor},
		{Or@@internalReferenceDilutionFactorNullErrors,
			Or@@standardInternalReferenceDilutionFactorNullErrors,
			Or@@blankInternalReferenceDilutionFactorNullErrors,
			Or@@ladderInternalReferenceDilutionFactorNullErrors}
	];

	internalReferenceDilutionFactorNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceDilutionFactorNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceDilutionFactorNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceDilutionFactorNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceDilutionFactorNullErrors]],Cache->inheritedCache]
	}];

	internalReferenceDilutionFactorNullInvalidOptions=If[Length[internalReferenceDilutionFactorNullOptions]>0&&messages,
		(
			Message[Error::InternalReferenceDilutionFactorNull,internalReferenceDilutionFactorNullInvalidSamples];
			internalReferenceDilutionFactorNullOptions
		),
		{}
	];

	internalReferenceDilutionFactorNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[internalReferenceDilutionFactorNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardInternalReferenceDilutionFactorNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceDilutionFactorNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceDilutionFactorNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceDilutionFactorNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceDilutionFactorNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceDilutionFactorNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceDilutionFactorNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[internalReferenceDilutionFactorNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardInternalReferenceDilutionFactorNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceDilutionFactorNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceDilutionFactorNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceDilutionFactorNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceDilutionFactorNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceDilutionFactorNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceDilutionFactorNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",InternalReferenceDilutionFactor is informed where PremadeMasterMix is False:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",InternalReferenceDilutionFactor is informed where PremadeMasterMix is False:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* internalReferenceVolumeNullErrors *)

	internalReferenceVolumeNullOptions=Flatten@PickList[
		{InternalReferenceVolume,StandardInternalReferenceVolume,BlankInternalReferenceVolume,LadderInternalReferenceVolume},
		{Or@@internalReferenceVolumeNullErrors,
			Or@@standardInternalReferenceVolumeNullErrors,
			Or@@blankInternalReferenceVolumeNullErrors,
			Or@@ladderInternalReferenceVolumeNullErrors}
	];

	internalReferenceVolumeNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceVolumeNullErrors]],Cache->inheritedCache]
	}];

	internalReferenceVolumeNullInvalidOptions=If[Length[internalReferenceVolumeNullOptions]>0&&messages,
		(
			Message[Error::InternalReferenceVolumeNull,internalReferenceVolumeNullOptions];
			internalReferenceVolumeNullOptions
		),
		{}
	];

	internalReferenceVolumeNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[internalReferenceVolumeNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardInternalReferenceVolumeNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceVolumeNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceVolumeNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceVolumeNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[internalReferenceVolumeNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardInternalReferenceVolumeNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceVolumeNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceVolumeNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceVolumeNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",when premadeMasterMix is False, the internal reference volume is not Null:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",when premadeMasterMix is False, the internal reference volume is not Null:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* internalReferenceVolumeDilutionFactorMismatchWarnings *)

	internalReferenceVolumeDilutionFactorMismatchOptions=Flatten@PickList[
		{{InternalReferenceDilutionFactor,InternalReferenceVolume},{StandardInternalReferenceDilutionFactor,StandardInternalReferenceVolume},{BlankInternalReferenceDilutionFactor,BlankInternalReferenceVolume},{LadderInternalReferenceDilutionFactor,LadderInternalReferenceVolume}},
		{Or@@internalReferenceVolumeDilutionFactorMismatchWarnings,
			Or@@standardInternalReferenceVolumeDilutionFactorMismatchWarnings,
			Or@@blankInternalReferenceVolumeDilutionFactorMismatchWarnings,
			Or@@ladderInternalReferenceVolumeDilutionFactorMismatchWarnings}
	];

	internalReferenceNullNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache]
	}];
	internalReferenceVolumeDilutionFactorMismatchInvalidOptions=If[Length[internalReferenceVolumeDilutionFactorMismatchOptions]>0&&messages,
		(
			Message[Error::InternalReferenceVolumeDilutionFactorMismatch,internalReferenceNullNullInvalidSamples];
			internalReferenceVolumeDilutionFactorMismatchOptions
		),
		{}
	];

	internalReferenceVolumeDilutionFactorMismatchTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[internalReferenceVolumeDilutionFactorMismatchWarnings]],
				PickList[ToList[resolvedStandards],ToList[standardInternalReferenceVolumeDilutionFactorMismatchWarnings]],
				PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceVolumeDilutionFactorMismatchWarnings]],
				PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceVolumeDilutionFactorMismatchWarnings]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceVolumeDilutionFactorMismatchWarnings]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[internalReferenceVolumeDilutionFactorMismatchWarnings],False],
				PickList[ToList[resolvedStandards],ToList[standardInternalReferenceVolumeDilutionFactorMismatchWarnings],False],
				PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceVolumeDilutionFactorMismatchWarnings],False],
				PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceVolumeDilutionFactorMismatchWarnings],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[internalReferenceVolumeDilutionFactorMismatchWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardInternalReferenceVolumeDilutionFactorMismatchWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankInternalReferenceVolumeDilutionFactorMismatchWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderInternalReferenceVolumeDilutionFactorMismatchWarnings],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",The InternalReferenceDilutionFactor and Volume are copacetic:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",The InternalReferenceDilutionFactor and Volume are copacetic:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* reducingAgentNullErrors *)

	reducingAgentNullOptions=Flatten@PickList[
		{ReducingAgent,StandardReducingAgent,BlankReducingAgent,LadderReducingAgent},
		{Or@@reducingAgentNullErrors,
			Or@@standardReducingAgentNullErrors,
			Or@@blankReducingAgentNullErrors,
			Or@@ladderReducingAgentNullErrors}
	];

	reducingAgentNullNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentNullErrors]],Cache->inheritedCache]
	}];

	reducingAgentNullInvalidOptions=If[Length[reducingAgentNullOptions]>0&&messages,
		(
			Message[Error::ReducingAgentNull,reducingAgentNullNullInvalidSamples];
			reducingAgentNullOptions
		),
		{}
	];

	reducingAgentNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[reducingAgentNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardReducingAgentNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankReducingAgentNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderReducingAgentNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[reducingAgentNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardReducingAgentNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankReducingAgentNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderReducingAgentNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",ReducingAgent is informed where PremadeMasterMix is False:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",ReducingAgent is informed where PremadeMasterMix is False:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* noReducingAgentIdentifiedWarnings *)

	noReducingAgentIdentifiedOptions=Flatten@PickList[
		{ReducingAgent,StandardReducingAgent,BlankReducingAgent,LadderReducingAgent},
		{Or@@noReducingAgentIdentifiedWarnings,
			Or@@standardNoReducingAgentIdentifiedWarnings,
			Or@@blankNoReducingAgentIdentifiedWarnings,
			Or@@ladderNoReducingAgentIdentifiedWarnings}
	];

	noReducingAgentIdentifiedInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[noReducingAgentIdentifiedWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoReducingAgentIdentifiedWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoReducingAgentIdentifiedWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderNoReducingAgentIdentifiedWarnings]],Cache->inheritedCache]
	}];

	If[Length[noReducingAgentIdentifiedOptions]>0&&messages&&!engineQ,
		Message[Warning::NoReducingAgentIdentified,noReducingAgentIdentifiedInvalidSamples];
	];

	noReducingAgentIdentifiedTest=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[noReducingAgentIdentifiedWarnings]],
				PickList[ToList[resolvedStandards],ToList[standardNoReducingAgentIdentifiedWarnings]],
				PickList[ToList[resolvedBlanks],ToList[blankNoReducingAgentIdentifiedWarnings]],
				PickList[ToList[resolvedLadders],ToList[ladderNoReducingAgentIdentifiedWarnings]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[noReducingAgentIdentifiedWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoReducingAgentIdentifiedWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoReducingAgentIdentifiedWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderNoReducingAgentIdentifiedWarnings]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[noReducingAgentIdentifiedWarnings],False],
				PickList[ToList[resolvedStandards],ToList[standardNoReducingAgentIdentifiedWarnings],False],
				PickList[ToList[resolvedBlanks],ToList[blankNoReducingAgentIdentifiedWarnings],False],
				PickList[ToList[resolvedLadders],ToList[ladderNoReducingAgentIdentifiedWarnings],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[noReducingAgentIdentifiedWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoReducingAgentIdentifiedWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoReducingAgentIdentifiedWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderNoReducingAgentIdentifiedWarnings],False],Cache->inheritedCache]
			}];

			(* create warning for failing samples *)
			failingSampleTests=If[Length[failingSamples]>0,
				Warning["For the provided samples"<>failingString<>",the ReducingAgent's model contains reducing agent in its composition:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Warning["For the provided samples"<>passingString<>",the ReducingAgent's model contains reducing agent in its composition:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* reducingAgentTargetConcentrationNullErrors *)

	reducingAgentTargetConcentrationNullOptions=Flatten@PickList[
		{ReducingAgentTargetConcentration,StandardReducingAgentTargetConcentration,BlankReducingAgentTargetConcentration,LadderReducingAgentTargetConcentration},
		{Or@@reducingAgentTargetConcentrationNullErrors,
			Or@@standardReducingAgentTargetConcentrationNullErrors,
			Or@@blankReducingAgentTargetConcentrationNullErrors,
			Or@@ladderReducingAgentTargetConcentrationNullErrors}
	];

	reducingAgentTargetConcentrationNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentTargetConcentrationNullErrors]],Cache->inheritedCache]
	}];

	reducingAgentTargetConcentrationNullInvalidOptions=If[Length[reducingAgentTargetConcentrationNullOptions]>0&&messages,
		(
			Message[Error::ReducingAgentTargetConcentrationNull,reducingAgentTargetConcentrationNullInvalidSamples];
			reducingAgentTargetConcentrationNullOptions
		),
		{}
	];

	reducingAgentTargetConcentrationNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[reducingAgentTargetConcentrationNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardReducingAgentTargetConcentrationNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankReducingAgentTargetConcentrationNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderReducingAgentTargetConcentrationNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentTargetConcentrationNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[reducingAgentTargetConcentrationNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardReducingAgentTargetConcentrationNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankReducingAgentTargetConcentrationNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderReducingAgentTargetConcentrationNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentTargetConcentrationNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentTargetConcentrationNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentTargetConcentrationNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentTargetConcentrationNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",ReducingAgentTargetConcentration is informed when Reduction is set to True:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",ReducingAgentTargetConcentration is informed when Reduction is set to True:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* reducingAgentVolumeNullErrors *)
	reducingAgentVolumeNullOptions=Flatten@PickList[
		{ReducingAgentVolume,StandardReducingAgentVolume,BlankReducingAgentVolume,LadderReducingAgentVolume},
		{Or@@reducingAgentVolumeNullErrors,
			Or@@standardReducingAgentVolumeNullErrors,
			Or@@blankReducingAgentVolumeNullErrors,
			Or@@ladderReducingAgentVolumeNullErrors}
	];

	reducingAgentVolumeNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentVolumeNullErrors]],Cache->inheritedCache]
	}];
	reducingAgentVolumeNullInvalidOptions=If[Length[reducingAgentVolumeNullOptions]>0,
		(
			Message[Error::ReducingAgentVolumeNull,reducingAgentVolumeNullInvalidSamples];
			reducingAgentVolumeNullOptions
		),
		{}
	];

	reducingAgentVolumeNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[reducingAgentVolumeNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardReducingAgentVolumeNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankReducingAgentVolumeNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderReducingAgentVolumeNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentVolumeNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[reducingAgentVolumeNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardReducingAgentVolumeNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankReducingAgentVolumeNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderReducingAgentVolumeNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentVolumeNullErrors],False],Cache->inheritedCache]
			}];


			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",ReducingAgentVolume is informed when Reduction is set to True:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",ReducingAgentVolume is informed when Reduction is set to True:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* reducingAgentVolumeConcentrationMismatchErrors *)

	reducingAgentVolumeConcentrationMismatchOptions=Flatten@PickList[
		{{ReducingAgentTargetConcentration,ReducingAgentVolume},{StandardReducingAgentTargetConcentration,StandardReducingAgentVolume},{BlankReducingAgentReducingAgentTargetConcentration,BlankReducingAgentVolume},{LadderReducingAgentTargetConcentration,LadderReducingAgentVolume}},
		{Or@@reducingAgentVolumeConcentrationMismatchErrors,
			Or@@standardReducingAgentVolumeConcentrationMismatchErrors,
			Or@@blankReducingAgentVolumeConcentrationMismatchErrors,
			Or@@ladderReducingAgentVolumeConcentrationMismatchErrors}
	];

	reducingAgentVolumeConcentrationMismatchNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache]
	}];

	reducingAgentVolumeConcentrationMismatchInvalidOptions=If[Length[reducingAgentVolumeConcentrationMismatchOptions]>0&&messages,
		(
			Message[Error::ReducingAgentVolumeConcentrationMismatch,reducingAgentVolumeConcentrationMismatchNullInvalidSamples];
			reducingAgentVolumeConcentrationMismatchOptions
		),
		{}
	];

	reducingAgentVolumeConcentrationMismatchTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[reducingAgentVolumeConcentrationMismatchErrors]],
				PickList[ToList[resolvedStandards],ToList[standardReducingAgentVolumeConcentrationMismatchErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankReducingAgentVolumeConcentrationMismatchErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderReducingAgentVolumeConcentrationMismatchErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[reducingAgentVolumeConcentrationMismatchErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardReducingAgentVolumeConcentrationMismatchErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankReducingAgentVolumeConcentrationMismatchErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderReducingAgentVolumeConcentrationMismatchErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[reducingAgentVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardReducingAgentVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankReducingAgentVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderReducingAgentVolumeConcentrationMismatchErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",when both the ReducingAgentTargetConcentration and Volume Are Specified, they are copacetic:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",when both the ReducingAgentTargetConcentration and Volume Are Specified, they are copacetic:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];


	(* alkylatingAgentNullErrors *)

	alkylatingAgentNullOptions=Flatten@PickList[
		{AlkylatingAgent,StandardAlkylatingAgent,BlankAlkylatingAgent,LadderAlkylatingAgent},
		{Or@@alkylatingAgentNullErrors,
			Or@@standardAlkylatingAgentNullErrors,
			Or@@blankAlkylatingAgentNullErrors,
			Or@@ladderAlkylatingAgentNullErrors}
	];

	alkylatingAgentNullNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentNullErrors]],Cache->inheritedCache]
	}];

	alkylatingAgentNullInvalidOptions=If[Length[alkylatingAgentNullOptions]>0&&messages,
		(
			Message[Error::AlkylatingAgentNull,alkylatingAgentNullNullInvalidSamples];
			alkylatingAgentNullOptions
		),
		{}
	];

	alkylatingAgentNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[alkylatingAgentNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[alkylatingAgentNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",AlkylatingAgent is informed where PremadeMasterMix is False:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",AlkylatingAgent is informed where PremadeMasterMix is False:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* noAlkylatingAgentIdentifiedWarnings *)

	noAlkylatingAgentIdentifiedOptions=Flatten@PickList[
		{AlkylatingAgent,StandardAlkylatingAgent,BlankAlkylatingAgent,LadderAlkylatingAgent},
		{Or@@noAlkylatingAgentIdentifiedWarnings,
			Or@@standardNoAlkylatingAgentIdentifiedWarnings,
			Or@@blankNoAlkylatingAgentIdentifiedWarnings,
			Or@@ladderNoAlkylatingAgentIdentifiedWarnings}
	];

	noAlkylatingAgentIdentifiedInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[noAlkylatingAgentIdentifiedWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoAlkylatingAgentIdentifiedWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoAlkylatingAgentIdentifiedWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderNoAlkylatingAgentIdentifiedWarnings]],Cache->inheritedCache]
	}];

	If[Length[noAlkylatingAgentIdentifiedOptions]>0&&messages&&!engineQ,
		Message[Warning::NoAlkylatingAgentIdentified,noAlkylatingAgentIdentifiedInvalidSamples];
	];

	noAlkylatingAgentIdentifiedTest=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[noAlkylatingAgentIdentifiedWarnings]],
				PickList[ToList[resolvedStandards],ToList[standardNoAlkylatingAgentIdentifiedWarnings]],
				PickList[ToList[resolvedBlanks],ToList[blankNoAlkylatingAgentIdentifiedWarnings]],
				PickList[ToList[resolvedLadders],ToList[ladderNoAlkylatingAgentIdentifiedWarnings]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[noAlkylatingAgentIdentifiedWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoAlkylatingAgentIdentifiedWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoAlkylatingAgentIdentifiedWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderNoAlkylatingAgentIdentifiedWarnings]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[noAlkylatingAgentIdentifiedWarnings],False],
				PickList[ToList[resolvedStandards],ToList[standardNoAlkylatingAgentIdentifiedWarnings],False],
				PickList[ToList[resolvedBlanks],ToList[blankNoAlkylatingAgentIdentifiedWarnings],False],
				PickList[ToList[resolvedLadders],ToList[ladderNoAlkylatingAgentIdentifiedWarnings],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[noAlkylatingAgentIdentifiedWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNoAlkylatingAgentIdentifiedWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNoAlkylatingAgentIdentifiedWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderNoAlkylatingAgentIdentifiedWarnings],False],Cache->inheritedCache]
			}];

			(* create warning for failing samples *)
			failingSampleTests=If[Length[failingSamples]>0,
				Warning["For the provided samples"<>failingString<>",the AlkylatingAgent's model contains alkylating agent in its composition:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Warning["For the provided samples"<>passingString<>",the AlkylatingAgent's model contains alkylating agent in its composition:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* alkylatingAgentTargetConcentrationNullErrors *)

	alkylatingAgentTargetConcentrationNullOptions=Flatten@PickList[
		{AlkylatingAgentTargetConcentration,StandardAlkylatingAgentTargetConcentration,BlankAlkylatingAgentTargetConcentration,LadderAlkylatingAgentTargetConcentration},
		{Or@@alkylatingAgentTargetConcentrationNullErrors,
			Or@@standardAlkylatingAgentTargetConcentrationNullErrors,
			Or@@blankAlkylatingAgentTargetConcentrationNullErrors,
			Or@@ladderAlkylatingAgentTargetConcentrationNullErrors}
	];

	alkylatingAgentTargetConcentrationNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentTargetConcentrationNullErrors]],Cache->inheritedCache]
	}];

	alkylatingAgentTargetConcentrationNullInvalidOptions=If[Length[alkylatingAgentTargetConcentrationNullOptions]>0&&messages,
		(
			Message[Error::AlkylatingAgentTargetConcentrationNull,alkylatingAgentTargetConcentrationNullInvalidSamples];
			alkylatingAgentTargetConcentrationNullOptions
		),
		{}
	];

	alkylatingAgentTargetConcentrationNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[alkylatingAgentTargetConcentrationNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentTargetConcentrationNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentTargetConcentrationNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentTargetConcentrationNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentTargetConcentrationNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentTargetConcentrationNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[alkylatingAgentTargetConcentrationNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentTargetConcentrationNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentTargetConcentrationNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentTargetConcentrationNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentTargetConcentrationNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentTargetConcentrationNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentTargetConcentrationNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentTargetConcentrationNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",AlkylatingAgentTargetConcentration is informed when Reduction is set to True:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",AlkylatingAgentTargetConcentration is informed when Reduction is set to True:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* alkylatingAgentVolumeNullErrors *)
	alkylatingAgentVolumeNullOptions=Flatten@PickList[
		{AlkylatingAgentVolume,StandardAlkylatingAgentVolume,BlankAlkylatingAgentVolume,LadderAlkylatingAgentVolume},
		{Or@@alkylatingAgentVolumeNullErrors,
			Or@@standardAlkylatingAgentVolumeNullErrors,
			Or@@blankAlkylatingAgentVolumeNullErrors,
			Or@@ladderAlkylatingAgentVolumeNullErrors}
	];

	alkylatingAgentVolumeNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentVolumeNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentVolumeNullErrors]],Cache->inheritedCache]
	}];
	alkylatingAgentVolumeNullInvalidOptions=If[Length[alkylatingAgentVolumeNullOptions]>0,
		(
			Message[Error::AlkylatingAgentVolumeNull,alkylatingAgentVolumeNullInvalidSamples];
			alkylatingAgentVolumeNullOptions
		),
		{}
	];

	alkylatingAgentVolumeNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[alkylatingAgentVolumeNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentVolumeNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentVolumeNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentVolumeNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentVolumeNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentVolumeNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[alkylatingAgentVolumeNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentVolumeNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentVolumeNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentVolumeNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentVolumeNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentVolumeNullErrors],False],Cache->inheritedCache]
			}];


			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",AlkylatingAgentVolume is informed when Reduction is set to True:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",AlkylatingAgentVolume is informed when Reduction is set to True:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];


	(* alkylatingAgentVolumeConcentrationMismatchErrors *)

	alkylatingAgentVolumeConcentrationMismatchOptions=Flatten@PickList[
		{{AlkylatingAgentTargetConcentration,AlkylatingAgentVolume},{StandardAlkylatingAgentTargetConcentration,StandardAlkylatingAgentVolume},{BlankAlkylatingAgentAlkylatingAgentTargetConcentration,BlankAlkylatingAgentVolume},{LadderAlkylatingAgentTargetConcentration,LadderAlkylatingAgentVolume}},
		{Or@@alkylatingAgentVolumeConcentrationMismatchErrors,
			Or@@standardAlkylatingAgentVolumeConcentrationMismatchErrors,
			Or@@blankAlkylatingAgentVolumeConcentrationMismatchErrors,
			Or@@ladderAlkylatingAgentVolumeConcentrationMismatchErrors}
	];

	alkylatingAgentVolumeConcentrationMismatchNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache]
	}];

	alkylatingAgentVolumeConcentrationMismatchInvalidOptions=If[Length[alkylatingAgentVolumeConcentrationMismatchOptions]>0&&messages,
		(
			Message[Error::AlkylatingAgentVolumeConcentrationMismatch,alkylatingAgentVolumeConcentrationMismatchNullInvalidSamples];
			alkylatingAgentVolumeConcentrationMismatchOptions
		),
		{}
	];

	alkylatingAgentVolumeConcentrationMismatchTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[alkylatingAgentVolumeConcentrationMismatchErrors]],
				PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentVolumeConcentrationMismatchErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentVolumeConcentrationMismatchErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentVolumeConcentrationMismatchErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentVolumeConcentrationMismatchErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[alkylatingAgentVolumeConcentrationMismatchErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentVolumeConcentrationMismatchErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentVolumeConcentrationMismatchErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentVolumeConcentrationMismatchErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[alkylatingAgentVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardAlkylatingAgentVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankAlkylatingAgentVolumeConcentrationMismatchErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderAlkylatingAgentVolumeConcentrationMismatchErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",when both the AlkylatingAgentTargetConcentration and Volume Are Specified, they are copacetic:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",when both the AlkylatingAgentTargetConcentration and Volume Are Specified, they are copacetic:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];


	(* sDSBufferNullErrors *)

	sDSBufferNullOptions=Flatten@PickList[
		{{SDSBuffer,ConcentratedSDSBufferVolume},{StandardSDSBuffer,StandardConcentratedSDSBufferVolume},{BlankSDSBuffer,BlankConcentratedSDSBufferVolume},{LadderSDSBuffer,LadderConcentratedSDSBufferVolume}},
		{Or@@sDSBufferNullErrors,
			Or@@standardSDSBufferNullErrors,
			Or@@blankSDSBufferNullErrors,
			Or@@ladderSDSBufferNullErrors}
	];

	sDSBufferNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[sDSBufferNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardSDSBufferNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankSDSBufferNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderSDSBufferNullErrors]],Cache->inheritedCache]
	}];

	sDSBufferNullInvalidOptions=If[Length[sDSBufferNullOptions]>0&&messages,
		(
			Message[Error::SDSBufferNull,sDSBufferNullInvalidSamples];
			sDSBufferNullOptions
		),
		{}
	];

	sDSBufferNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[sDSBufferNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardSDSBufferNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankSDSBufferNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderSDSBufferNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[sDSBufferNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardSDSBufferNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankSDSBufferNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderSDSBufferNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[sDSBufferNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardSDSBufferNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankSDSBufferNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderSDSBufferNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[sDSBufferNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardSDSBufferNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankSDSBufferNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderSDSBufferNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",a sample buffer containing SDS is specified:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",a sample buffer containing SDS is specified:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* bothSDSBranchesSetWarnings *)

	bothSDSBranchesSetOptions=Flatten@PickList[
		{{SDSBuffer,ConcentratedSDSBufferVolume},{StandardSDSBuffer,StandardConcentratedSDSBufferVolume},{BlankSDSBuffer,BlankConcentratedSDSBufferVolume},{LadderSDSBuffer,LadderConcentratedSDSBufferVolume}},
		{Or@@bothSDSBranchesSetWarnings,
			Or@@standardBothSDSBranchesSetWarnings,
			Or@@blankBothSDSBranchesSetWarnings,
			Or@@ladderBothSDSBranchesSetWarnings}
	];

	bothSDSBranchesSetInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[bothSDSBranchesSetWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardBothSDSBranchesSetWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankBothSDSBranchesSetWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderBothSDSBranchesSetWarnings]],Cache->inheritedCache]
	}];
	If[Length[bothSDSBranchesSetOptions]>0&&messages&&!engineQ,
		Message[Warning::BothSDSBufferOptionsSet,bothSDSBranchesSetInvalidSamples];
	];

	bothSDSBranchesSetTest=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[bothSDSBranchesSetWarnings]],
				PickList[ToList[resolvedStandards],ToList[standardBothSDSBranchesSetWarnings]],
				PickList[ToList[resolvedBlanks],ToList[blankBothSDSBranchesSetWarnings]],
				PickList[ToList[resolvedLadders],ToList[ladderBothSDSBranchesSetWarnings]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[bothSDSBranchesSetWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardBothSDSBranchesSetWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankBothSDSBranchesSetWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderBothSDSBranchesSetWarnings]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[bothSDSBranchesSetWarnings],False],
				PickList[ToList[resolvedStandards],ToList[standardBothSDSBranchesSetWarnings],False],
				PickList[ToList[resolvedBlanks],ToList[blankBothSDSBranchesSetWarnings],False],
				PickList[ToList[resolvedLadders],ToList[ladderBothSDSBranchesSetWarnings],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[bothSDSBranchesSetWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardBothSDSBranchesSetWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankBothSDSBranchesSetWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderBothSDSBranchesSetWarnings],False],Cache->inheritedCache]
			}];

			(* create warning for failing samples *)
			failingSampleTests=If[Length[failingSamples]>0,
				Warning["For the provided samples"<>failingString<>",only one of ConcentratedSDSBuffer and SDSBuffer is specified:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Warning["For the provided samples"<>passingString<>",only one of ConcentratedSDSBuffer and SDSBuffer is specified:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* concentratedSDSBufferDilutionFactorNullErrors *)

	concentratedSDSBufferDilutionFactorNullOptions=Flatten@PickList[
		{ConcentratedSDSBufferVolume,StandardConcentratedSDSBufferVolume,BlankConcentratedSDSBufferVolume,LadderConcentratedSDSBufferVolume},
		{Or@@concentratedSDSBufferDilutionFactorNullErrors,
			Or@@standardConcentratedSDSBufferDilutionFactorNullErrors,
			Or@@blankConcentratedSDSBufferDilutionFactorNullErrors,
			Or@@ladderConcentratedSDSBufferDilutionFactorNullErrors}
	];

	concentratedSDSBufferDilutionFactorNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[concentratedSDSBufferDilutionFactorNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardConcentratedSDSBufferDilutionFactorNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankConcentratedSDSBufferDilutionFactorNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderConcentratedSDSBufferDilutionFactorNullErrors]],Cache->inheritedCache]
	}];

	concentratedSDSBufferDilutionFactorNullInvalidOptions=If[Length[concentratedSDSBufferDilutionFactorNullOptions]>0&&messages,
		(
			Message[Error::ConcentratedSDSBufferDilutionFactorNull,concentratedSDSBufferDilutionFactorNullInvalidSamples];
			concentratedSDSBufferDilutionFactorNullOptions
		),
		{}
	];

	concentratedSDSBufferDilutionFactorNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[concentratedSDSBufferDilutionFactorNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardConcentratedSDSBufferDilutionFactorNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankConcentratedSDSBufferDilutionFactorNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderConcentratedSDSBufferDilutionFactorNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[concentratedSDSBufferDilutionFactorNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardConcentratedSDSBufferDilutionFactorNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankConcentratedSDSBufferDilutionFactorNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderConcentratedSDSBufferDilutionFactorNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[concentratedSDSBufferDilutionFactorNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardConcentratedSDSBufferDilutionFactorNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankConcentratedSDSBufferDilutionFactorNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderConcentratedSDSBufferDilutionFactorNullErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[concentratedSDSBufferDilutionFactorNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardConcentratedSDSBufferDilutionFactorNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankConcentratedSDSBufferDilutionFactorNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderConcentratedSDSBufferDilutionFactorNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",the ConcentratedSDSBufferDilutionFactor is specified when ConcentratedSDSBuffer is specified:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",the ConcentratedSDSBufferDilutionFactor is specified when ConcentratedSDSBuffer is specified:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* notEnoughSDSinSampleWarnings *)

	notEnoughSDSinSampleNullOptions=Flatten@PickList[
		{{SDSBuffer,ConcentratedSDSBufferVolume},{StandardSDSBuffer,StandardConcentratedSDSBufferVolume},{BlankSDSBuffer,BlankConcentratedSDSBufferVolume},{LadderSDSBuffer,LadderConcentratedSDSBufferVolume}},
		{Or@@notEnoughSDSinSampleWarnings,
			Or@@standardNotEnoughSDSinSampleWarnings,
			Or@@blankNotEnoughSDSinSampleWarnings,
			Or@@ladderNotEnoughSDSinSampleWarnings}
	];

	notEnoughSDSinSampleInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[notEnoughSDSinSampleWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNotEnoughSDSinSampleWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNotEnoughSDSinSampleWarnings]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderNotEnoughSDSinSampleWarnings]],Cache->inheritedCache]
	}];

	If[Length[notEnoughSDSinSampleNullOptions]>0&&messages&&!engineQ,
		Message[Warning::InsufficientSDSinSample,notEnoughSDSinSampleInvalidSamples];
	];

	notEnoughSDSinSampleTest=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[notEnoughSDSinSampleWarnings]],
				PickList[ToList[resolvedStandards],ToList[standardNotEnoughSDSinSampleWarnings]],
				PickList[ToList[resolvedBlanks],ToList[blankNotEnoughSDSinSampleWarnings]],
				PickList[ToList[resolvedLadders],ToList[ladderNotEnoughSDSinSampleWarnings]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[notEnoughSDSinSampleWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNotEnoughSDSinSampleWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNotEnoughSDSinSampleWarnings]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderNotEnoughSDSinSampleWarnings]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[notEnoughSDSinSampleWarnings],False],
				PickList[ToList[resolvedStandards],ToList[standardNotEnoughSDSinSampleWarnings],False],
				PickList[ToList[resolvedBlanks],ToList[blankNotEnoughSDSinSampleWarnings],False],
				PickList[ToList[resolvedLadders],ToList[ladderNotEnoughSDSinSampleWarnings],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[notEnoughSDSinSampleWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardNotEnoughSDSinSampleWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankNotEnoughSDSinSampleWarnings],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderNotEnoughSDSinSampleWarnings],False],Cache->inheritedCache]
			}];

			(* create warning for failing samples *)
			failingSampleTests=If[Length[failingSamples]>0,
				Warning["For the provided samples"<>failingString<>",an appropriate amount of SDS is in the sample:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Warning["For the provided samples"<>passingString<>",an appropriate amount of SDS is in the sample:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* volumeGreaterThanTotalVolumeErrors *)

	volumeGreaterThanTotalVolumeNullOptions=Flatten@PickList[
		{{SampleVolume,InternalReferenceVolume,ReducingAgentVolume,AlkylatingAgentVolume,ConcentratedSDSBufferVolume,SDSBufferVolume},
			{StandardVolume,StandardInternalReferenceVolume,StandardReducingAgentVolume,StandardAlkylatingAgentVolume,StandardConcentratedSDSBufferVolume,StandardSDSBufferVolume},
			{BlankVolume,BlankInternalReferenceVolume,BlankReducingAgentVolume,BlankAlkylatingAgentVolume,BlankConcentratedSDSBufferVolume,BlankSDSBufferVolume},
			{LadderVolume,LadderInternalReferenceVolume,LadderReducingAgentVolume,LadderAlkylatingAgentVolume,LadderConcentratedSDSBufferVolume,LadderSDSBufferVolume}},
		{Or@@volumeGreaterThanTotalVolumeErrors,
			Or@@standardVolumeGreaterThanTotalVolumeErrors,
			Or@@blankVolumeGreaterThanTotalVolumeErrors,
			Or@@ladderVolumeGreaterThanTotalVolumeErrors}
	];

	volumeGreaterThanTotalVolumeInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[volumeGreaterThanTotalVolumeErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardVolumeGreaterThanTotalVolumeErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankVolumeGreaterThanTotalVolumeErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderVolumeGreaterThanTotalVolumeErrors]],Cache->inheritedCache]
	}];

	volumeGreaterThanTotalVolumeInvalidOptions=If[Length[volumeGreaterThanTotalVolumeNullOptions]>0&&messages,
		(
			Message[Error::VolumeGreaterThanTotalVolume,volumeGreaterThanTotalVolumeInvalidSamples];
			volumeGreaterThanTotalVolumeNullOptions
		),
		{}
	];

	volumeGreaterThanTotalVolumeTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[volumeGreaterThanTotalVolumeErrors]],
				PickList[ToList[resolvedStandards],ToList[standardVolumeGreaterThanTotalVolumeErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankVolumeGreaterThanTotalVolumeErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderVolumeGreaterThanTotalVolumeErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[volumeGreaterThanTotalVolumeErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardVolumeGreaterThanTotalVolumeErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankVolumeGreaterThanTotalVolumeErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderVolumeGreaterThanTotalVolumeErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[volumeGreaterThanTotalVolumeErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardVolumeGreaterThanTotalVolumeErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankVolumeGreaterThanTotalVolumeErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderVolumeGreaterThanTotalVolumeErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[volumeGreaterThanTotalVolumeErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardVolumeGreaterThanTotalVolumeErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankVolumeGreaterThanTotalVolumeErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderVolumeGreaterThanTotalVolumeErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",the sum of volumes added to sample does not exceed the total volume:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",the sum of volumes added to sample does not exceed the total volume:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* componentsDontSumToTotalVolumeErrors *)
	componentsDontSumToTotalVolumeeNullOptions=Flatten@PickList[
		{{SampleVolume,InternalReferenceVolume,ReducingAgentVolume,AlkylatingAgentVolume,SDSBufferVolume},
			{StandardVolume,StandardInternalReferenceVolume,StandardReducingAgentVolume,StandardAlkylatingAgentVolume,StandardSDSBufferVolume},
			{BlankVolume,BlankInternalReferenceVolume,BlankReducingAgentVolume,BlankAlkylatingAgentVolume,BlankSDSBufferVolume},
			{LadderVolume,LadderInternalReferenceVolume,LadderReducingAgentVolume,LadderAlkylatingAgentVolume,LadderSDSBufferVolume}},
		{Or@@componentsDontSumToTotalVolumeErrors,
			Or@@standardComponentsDontSumToTotalVolumeErrors,
			Or@@blankComponentsDontSumToTotalVolumeErrors,
			Or@@ladderComponentsDontSumToTotalVolumeErrors}
	];

	componentsDontSumToTotalVolumeInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[componentsDontSumToTotalVolumeErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardComponentsDontSumToTotalVolumeErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankComponentsDontSumToTotalVolumeErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderComponentsDontSumToTotalVolumeErrors]],Cache->inheritedCache]
	}];
	componentsDontSumToTotalVolumeInvalidOptions=If[Length[componentsDontSumToTotalVolumeeNullOptions]>0&&messages,
		(
			Message[Error::ComponentsDontSumToTotalVolume,componentsDontSumToTotalVolumeInvalidSamples];
			componentsDontSumToTotalVolumeeNullOptions
		),
		{}
	];

	componentsDontSumToTotalVolumeTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[componentsDontSumToTotalVolumeErrors]],
				PickList[ToList[resolvedStandards],ToList[standardComponentsDontSumToTotalVolumeErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankComponentsDontSumToTotalVolumeErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderComponentsDontSumToTotalVolumeErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[componentsDontSumToTotalVolumeErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardComponentsDontSumToTotalVolumeErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankComponentsDontSumToTotalVolumeErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderComponentsDontSumToTotalVolumeErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[componentsDontSumToTotalVolumeErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardComponentsDontSumToTotalVolumeErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankComponentsDontSumToTotalVolumeErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderComponentsDontSumToTotalVolumeErrors],False]
			];

			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[componentsDontSumToTotalVolumeErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardComponentsDontSumToTotalVolumeErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankComponentsDontSumToTotalVolumeErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderComponentsDontSumToTotalVolumeErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>",when using SDSBuffer, the sum of all components is equal to the total volume:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>",when using SDSBuffer, the sum of all components is equal to the total volume:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* diluentNullErrors *)

	diluentNullOptions=Flatten@PickList[
		{Diluent,StandardDiluent,BlankDiluent,LadderDiluent},
		{Or@@diluentNullErrors,
			Or@@standardDiluentNullErrors,
			Or@@blankDiluentNullErrors,
			Or@@ladderDiluentNullErrors}
	];

	diluentNullInvalidSamples=combineObjectsStrings[{
		ObjectToString[PickList[ToList[simulatedSamples],ToList[diluentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDiluentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDiluentNullErrors]],Cache->inheritedCache],
		ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderDiluentNullErrors]],Cache->inheritedCache]
	}];
	diluentNullInvalidOptions=If[Length[diluentNullOptions]>0&&messages,
		(
			Message[Error::DiluentNull,diluentNullInvalidSamples];
			diluentNullOptions
		),
		{}
	];

	diluentNullTests=If[gatherTests,
		Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests,failingString,
			passingString},

			(* get the inputs that fail this test *)
			failingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[diluentNullErrors]],
				PickList[ToList[resolvedStandards],ToList[standardDiluentNullErrors]],
				PickList[ToList[resolvedBlanks],ToList[blankDiluentNullErrors]],
				PickList[ToList[resolvedLadders],ToList[ladderDiluentNullErrors]]
			];

			failingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[diluentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDiluentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDiluentNullErrors]],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderDiluentNullErrors]],Cache->inheritedCache]
			}];

			(* get the inputs that pass this test *)
			passingSamples=Join[
				PickList[ToList[simulatedSamples],ToList[diluentNullErrors],False],
				PickList[ToList[resolvedStandards],ToList[standardDiluentNullErrors],False],
				PickList[ToList[resolvedBlanks],ToList[blankDiluentNullErrors],False],
				PickList[ToList[resolvedLadders],ToList[ladderDiluentNullErrors],False]
			];
			passingString=combineObjectsStrings[{
				ObjectToString[PickList[ToList[simulatedSamples],ToList[diluentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedStandards],ToList[standardDiluentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedBlanks],ToList[blankDiluentNullErrors],False],Cache->inheritedCache],
				ObjectToString[PickList[ToList[resolvedLadders],ToList[ladderDiluentNullErrors],False],Cache->inheritedCache]
			}];

			(* create a test for the non-passing inputs *)
			failingSampleTests=If[Length[failingSamples]>0,
				Test["For the provided samples "<>failingString<>", Diluent is specified when using Concentrated SDS Buffer:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[Length[passingSamples]>0,
				Test["For the provided samples "<>passingString<>", Diluent is specified when using Concentrated SDS Buffer:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];

	(* Ladders*)

	(* FewerLaddersThanUniqueOptionSets *)
	If[Not[enoughLaddersForUniqueOptionSetsQ]&&messages&&!engineQ,
		Message[Warning::FewerLaddersThanUniqueOptionSets,uniqueOptionCombinations];
	];

	enoughLaddersForUniqueOptionSetsTest=If[gatherTests,
		Module[{failingSampleTests,passingSampleTests},


			(* create warning for failing samples *)
			failingSampleTests=If[Not[enoughLaddersForUniqueOptionSetsQ],
				Warning["For the provided ladders"<>ObjectToString[resolvedLadders,Cache->ladderPackets]<>",exactly "<>ToString[uniqueOptionCombinations]<>" instances for eadh ladder have been specified:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests=If[enoughLaddersForUniqueOptionSetsQ,
				Warning["For the provided ladders"<>ObjectToString[resolvedLadders,Cache->ladderPackets]<>",exactly "<>ToString[uniqueOptionCombinations]<>" instances for eadh ladder have been specified:",
					True,
					True
				],
				Nothing
			];
			(* return the created tests *)
			{passingSampleTests,failingSampleTests}
		]
	];


	(* get whether the SamplesInStorage option is ok *)
	samplesInStorage=Lookup[myOptions,SamplesInStorageCondition];

	(* Check whether the samples are ok *)
	{validContainerStorageConditionBool,validContainerStorageConditionTests}=If[gatherTests,
		ValidContainerStorageConditionQ[mySamples,samplesInStorage,Cache->inheritedCache,Output->{Result,Tests}],
		{ValidContainerStorageConditionQ[mySamples,samplesInStorage,Cache->inheritedCache,Output->Result],{}}
	];
	validContainerStoragConditionInvalidOptions=If[MemberQ[validContainerStorageConditionBool,False],SamplesInStorageCondition,Nothing];

	(* pull out the email, upload, and parentProtocol options *)
	{email,upload,parentProtocol}=Lookup[myOptions,{Email,Upload,ParentProtocol}];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub or Upload -> False *)
	resolvedEmail=Which[
		MatchQ[email,Except[Automatic]],email,
		MatchQ[email,Automatic]&&NullQ[Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ParentProtocol]]&&TrueQ[upload]&&MemberQ[output,Result],True,
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
		invalidInjectionTableOption,
		sampleCountInvalidOption,
		notEnoughUsesLeftOption,
		injectionTableWithReplicatesInvalidOption,
		injectionTableVolumeZeroInvalidOption,
		invalidInjectionTableOption,
		supernatantVolumeInvalidOptions,
		sedimentationForceSpeedMismatchInvalidOptions,
		sedimentationForceSpeedNullsInvalidOptions,
		premadeMasterMixNullInvalidOptions,
		premadeMasterMixDilutionFactorNullInvalidOptions,
		premadeMasterMixVolumeDilutionFactorMismatchInvalidOptions,
		premadeMasterMixVolumeNullInvalidOptions,
		premadeMasterMixTotalVolumeInvalidOptions,
		internalReferenceNullInvalidOptions,
		internalReferenceDilutionFactorNullInvalidOptions,
		internalReferenceVolumeNullInvalidOptions,
		internalReferenceVolumeDilutionFactorMismatchInvalidOptions,
		reducingAgentNullInvalidOptions,
		reducingAgentTargetConcentrationNullInvalidOptions,
		reducingAgentVolumeNullInvalidOptions,
		reducingAgentVolumeConcentrationMismatchInvalidOptions,
		alkylatingAgentNullInvalidOptions,
		alkylatingAgentTargetConcentrationNullInvalidOptions,
		alkylatingAgentVolumeNullInvalidOptions,
		alkylatingAgentVolumeConcentrationMismatchInvalidOptions,
		sDSBufferNullInvalidOptions,
		concentratedSDSBufferDilutionFactorNullInvalidOptions,
		volumeGreaterThanTotalVolumeInvalidOptions,
		componentsDontSumToTotalVolumeInvalidOptions,
		diluentNullInvalidOptions,
		ladderDilutionFactorNullInvalidOptions,
		ladderAnalyteMolecularWeightMismatchInvalidOptions,
		ladderCompositionMolecularWeightMismatchInvalidOptions,
		ladderAnalytesCompositionMolecularWeightMismatchInvalidOptions,
		molecularWeightMissingInModelWarningInvalidOptions,
		validContainerStoragConditionInvalidOptions,
		premadeMasterMixDiluentNullInvalidOptions,
		totalVolumeNullInvalidOptions,
		volumeNullInvalidOptions
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

	(* get the RequiredAliquotAmount. Note that this must always be greater than the specified SampleAmount *)
	requiredAliquotAmounts=If[TrueQ[resolvedConsolidation],
		Map[Function[volume,volume*1.1/(specifiedNumberOfReplicates/.(Null:>1))],resolvedSampleVolume],
		Map[Function[volume,volume*1.1],resolvedSampleVolume]
	];

	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		(* Note: Also include AllowSolids->True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		resolveAliquotOptions[ExperimentCapillaryGelElectrophoresisSDS,Download[mySamples,Object],simulatedSamples,aliquotOptions,Cache->inheritedCache,Simulation->updatedSimulation,RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->requiredAliquotAmounts,Output->{Result,Tests}],
		{resolveAliquotOptions[ExperimentCapillaryGelElectrophoresisSDS,Download[mySamples,Object],simulatedSamples,aliquotOptions,Cache->inheritedCache,Simulation->updatedSimulation,RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->requiredAliquotAmounts,Output->Result],{}}
	];

	(* --- Resolve Label Options *)
	resolvedSampleLabel=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
		suppliedSampleObjects = Download[simulatedSamples, Object];
		uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
		preResolvedSampleLabels = Table[CreateUniqueLabel["capillary gel electrophoresis sample"], Length[uniqueSamples]];
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
			{suppliedSampleObjects, Lookup[roundedCapillaryGelElectrophoresisSDSOptions, SampleLabel]}
		]
	];

	resolvedSampleContainerLabel=Module[
		{suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
		suppliedContainerObjects = Download[Lookup[simulatedSamplePackets, Container, {}], Object];
		uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
		preresolvedSampleContainerLabels = Table[CreateUniqueLabel["capillary gel electrophoresis sample container"], Length[uniqueContainers]];
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
			{suppliedContainerObjects, Lookup[roundedCapillaryGelElectrophoresisSDSOptions, SampleContainerLabel]}
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	resolvedExperimentOptions={
		Instrument->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Instrument],
		Cartridge->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Cartridge],
		PurgeCartridge->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,PurgeCartridge],
		ReplaceCartridgeInsert->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ReplaceCartridgeInsert],
		SampleTemperature->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SampleTemperature]/.Ambient:>$AmbientTemperature,
		InjectionTable->resolvedInjectionTable[[All, ;; -2]],
		MatchedInjectionTable->resolvedInjectionTable,
		NumberOfReplicates->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,NumberOfReplicates],
		ConditioningAcid->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ConditioningAcid],
		ConditioningBase->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ConditioningBase],
		ConditioningWashSolution->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ConditioningWashSolution],
		SeparationMatrix->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SeparationMatrix],
		SystemWashSolution->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SystemWashSolution],
		PlaceholderContainer->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,PlaceholderContainer],
		ConditioningAcidStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ConditioningAcidStorageCondition],
		ConditioningBaseStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ConditioningBaseStorageCondition],
		SeparationMatrixStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SeparationMatrixStorageCondition],
		SystemWashSolutionStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SystemWashSolutionStorageCondition],
		RunningBufferStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,RunningBufferStorageCondition],
		Denature->resolvedIncludeIncubation,
		DenaturingTemperature->resolvedDenaturingTemperature,
		DenaturingTime->resolvedDenaturingTime,
		CoolingTemperature->resolvedCoolingTemperature,
		CoolingTime->resolvedCoolingTime,
		PelletSedimentation->resolvedIncludeCentrifugation,
		SedimentationCentrifugationSpeed->resolvedSedimentationCentrifugationSpeed,
		SedimentationCentrifugationForce->resolvedSedimentationCentrifugationForce,
		SedimentationCentrifugationTime->resolvedSedimentationCentrifugationTime,
		SedimentationCentrifugationTemperature->resolvedSedimentationCentrifugationTemperature,
		SampleVolume->resolvedSampleVolume,
		TotalVolume->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,TotalVolume],
		PremadeMasterMix->resolvedPremadeMasterMix,
		PremadeMasterMixReagent->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,PremadeMasterMixReagent],
		PremadeMasterMixDiluent->resolvedPremadeMasterMixDiluent,
		PremadeMasterMixReagentDilutionFactor->resolvedPremadeMasterMixReagentDilutionFactor,
		PremadeMasterMixVolume->resolvedPremadeMasterMixVolume,
		PremadeMasterMixStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,PremadeMasterMixStorageCondition],
		InternalReference->resolvedInternalReference,
		InternalReferenceDilutionFactor->resolvedInternalReferenceDilutionFactor,
		InternalReferenceVolume->resolvedInternalReferenceVolume,
		ConcentratedSDSBuffer->resolvedConcentratedSDSBuffer,
		ConcentratedSDSBufferDilutionFactor->resolvedConcentratedSDSBufferDilutionFactor,
		Diluent->resolvedDiluent,
		ConcentratedSDSBufferVolume->resolvedConcentratedSDSBufferVolume,
		SDSBuffer->resolvedSDSBuffer,
		SDSBufferVolume->resolvedSDSBufferVolume,
		Reduction->resolvedReduction,
		ReducingAgent->resolvedReducingAgent,
		ReducingAgentTargetConcentration->resolvedReducingAgentTargetConcentration,
		ReducingAgentVolume->resolvedReducingAgentVolume,
		Alkylation->resolvedAlkylation,
		AlkylatingAgent->resolvedAlkylatingAgent,
		AlkylatingAgentTargetConcentration->resolvedAlkylatingAgentTargetConcentration,
		AlkylatingAgentVolume->resolvedAlkylatingAgentVolume,
		SedimentationSupernatantVolume->resolvedSedimentationSupernatantVolume,
		InternalReferenceStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InternalReferenceStorageCondition],
		ConcentratedSDSBufferStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ConcentratedSDSBufferStorageCondition],
		DiluentStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,DiluentStorageCondition],
		SDSBufferStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SDSBufferStorageCondition],
		ReducingAgentStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ReducingAgentStorageCondition],
		AlkylatingAgentStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,AlkylatingAgentStorageCondition],
		RunningBuffer->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,RunningBuffer],
		InjectionVoltageDurationProfile->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,InjectionVoltageDurationProfile],
		SeparationVoltageDurationProfile->resolvedSeparationVoltageDurationProfile,
		UVDetectionWavelength->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,UVDetectionWavelength],
		IncludeLadders->resolveIncludeLadders,
		Ladders->resolvedLadders,
		LadderStorageCondition->Lookup[expandedLaddersOptions,LadderStorageCondition],
		LadderAnalytes->resolvedLadderAnalytes,
		LadderAnalyteMolecularWeights->resolvedLadderAnalyteMolecularWeights,
		LadderAnalyteLabels->resolvedLadderAnalyteLabels,
		LadderFrequency->resolvedLadderFrequency,
		LadderTotalVolume->resolvedLadderTotalVolume,
		LadderDiluent->resolvedLadderDiluent,
		LadderDilutionFactor->resolvedLadderDilutionFactor,
		LadderVolume->resolvedLadderVolume,
		LadderPremadeMasterMix->resolvedLadderPremadeMasterMix,
		LadderPremadeMasterMixReagent->resolvedLadderPremadeMasterMixReagent,
		LadderPremadeMasterMixDiluent->resolvedLadderPremadeMasterMixDiluent,
		LadderPremadeMasterMixReagentDilutionFactor->resolvedLadderPremadeMasterMixReagentDilutionFactor,
		LadderPremadeMasterMixVolume->resolvedLadderPremadeMasterMixVolume,
		LadderPremadeMasterMixStorageCondition->Lookup[expandedLaddersOptions,LadderPremadeMasterMixStorageCondition],
		LadderInternalReference->resolvedLadderInternalReference,
		LadderInternalReferenceDilutionFactor->resolvedLadderInternalReferenceDilutionFactor,
		LadderInternalReferenceVolume->resolvedLadderInternalReferenceVolume,
		LadderConcentratedSDSBuffer->resolvedLadderConcentratedSDSBuffer,
		LadderConcentratedSDSBufferDilutionFactor->resolvedLadderConcentratedSDSBufferDilutionFactor,
		LadderDiluent->resolvedLadderDiluent,
		LadderConcentratedSDSBufferVolume->resolvedLadderConcentratedSDSBufferVolume,
		LadderSDSBuffer->resolvedLadderSDSBuffer,
		LadderSDSBufferVolume->resolvedLadderSDSBufferVolume,
		LadderReduction->resolvedLadderReduction,
		LadderReducingAgent->resolvedLadderReducingAgent,
		LadderReducingAgentTargetConcentration->resolvedLadderReducingAgentTargetConcentration,
		LadderReducingAgentVolume->resolvedLadderReducingAgentVolume,
		LadderAlkylation->resolvedLadderAlkylation,
		LadderAlkylatingAgent->resolvedLadderAlkylatingAgent,
		LadderAlkylatingAgentTargetConcentration->resolvedLadderAlkylatingAgentTargetConcentration,
		LadderAlkylatingAgentVolume->resolvedLadderAlkylatingAgentVolume,
		LadderSedimentationSupernatantVolume->resolvedLadderSedimentationSupernatantVolume,
		LadderInjectionVoltageDurationProfile->resolvedLadderInjectionVoltageDurationProfile,
		LadderSeparationVoltageDurationProfile->resolvedLadderSeparationVoltageDurationProfile,
		LadderInternalReferenceStorageCondition->Lookup[expandedLaddersOptions,LadderInternalReferenceStorageCondition],
		LadderConcentratedSDSBufferStorageCondition->Lookup[expandedLaddersOptions,LadderConcentratedSDSBufferStorageCondition],
		LadderDiluentStorageCondition->Lookup[expandedLaddersOptions,LadderDiluentStorageCondition],
		LadderSDSBufferStorageCondition->Lookup[expandedLaddersOptions,LadderSDSBufferStorageCondition],
		LadderReducingAgentStorageCondition->Lookup[expandedLaddersOptions,LadderReducingAgentStorageCondition],
		LadderAlkylatingAgentStorageCondition->Lookup[expandedLaddersOptions,LadderAlkylatingAgentStorageCondition],
		IncludeStandards->resolveIncludeStandards,
		Standards->resolvedStandards,
		StandardStorageCondition->Lookup[expandedStandardsOptions,StandardStorageCondition],
		StandardVolume->resolvedStandardVolume,
		StandardFrequency->resolvedStandardFrequency,
		StandardTotalVolume->resolvedStandardTotalVolume,
		StandardPremadeMasterMix->resolvedStandardPremadeMasterMix,
		StandardPremadeMasterMixReagent->resolvedStandardPremadeMasterMixReagent,
		StandardPremadeMasterMixDiluent->resolvedStandardPremadeMasterMixDiluent,
		StandardPremadeMasterMixReagentDilutionFactor->resolvedStandardPremadeMasterMixReagentDilutionFactor,
		StandardPremadeMasterMixVolume->resolvedStandardPremadeMasterMixVolume,
		StandardPremadeMasterMixStorageCondition->Lookup[expandedStandardsOptions,StandardPremadeMasterMixStorageCondition],
		StandardInternalReference->resolvedStandardInternalReference,
		StandardInternalReferenceDilutionFactor->resolvedStandardInternalReferenceDilutionFactor,
		StandardInternalReferenceVolume->resolvedStandardInternalReferenceVolume,
		StandardConcentratedSDSBuffer->resolvedStandardConcentratedSDSBuffer,
		StandardConcentratedSDSBufferDilutionFactor->resolvedStandardConcentratedSDSBufferDilutionFactor,
		StandardDiluent->resolvedStandardDiluent,
		StandardConcentratedSDSBufferVolume->resolvedStandardConcentratedSDSBufferVolume,
		StandardSDSBuffer->resolvedStandardSDSBuffer,
		StandardSDSBufferVolume->resolvedStandardSDSBufferVolume,
		StandardReduction->resolvedStandardReduction,
		StandardReducingAgent->resolvedStandardReducingAgent,
		StandardReducingAgentTargetConcentration->resolvedStandardReducingAgentTargetConcentration,
		StandardReducingAgentVolume->resolvedStandardReducingAgentVolume,
		StandardAlkylation->resolvedStandardAlkylation,
		StandardAlkylatingAgent->resolvedStandardAlkylatingAgent,
		StandardAlkylatingAgentTargetConcentration->resolvedStandardAlkylatingAgentTargetConcentration,
		StandardAlkylatingAgentVolume->resolvedStandardAlkylatingAgentVolume,
		StandardSedimentationSupernatantVolume->resolvedStandardSedimentationSupernatantVolume,
		StandardInjectionVoltageDurationProfile->resolvedStandardInjectionVoltageDurationProfile,
		StandardSeparationVoltageDurationProfile->resolvedStandardSeparationVoltageDurationProfile,
		StandardInternalReferenceStorageCondition->Lookup[expandedStandardsOptions,StandardInternalReferenceStorageCondition],
		StandardConcentratedSDSBufferStorageCondition->Lookup[expandedStandardsOptions,StandardConcentratedSDSBufferStorageCondition],
		StandardDiluentStorageCondition->Lookup[expandedStandardsOptions,StandardDiluentStorageCondition],
		StandardSDSBufferStorageCondition->Lookup[expandedStandardsOptions,StandardSDSBufferStorageCondition],
		StandardReducingAgentStorageCondition->Lookup[expandedStandardsOptions,StandardReducingAgentStorageCondition],
		StandardAlkylatingAgentStorageCondition->Lookup[expandedStandardsOptions,StandardAlkylatingAgentStorageCondition],
		IncludeBlanks->resolveIncludeBlanks,
		Blanks->resolvedBlanks,
		BlankStorageCondition->Lookup[expandedBlanksOptions,BlankStorageCondition],
		BlankVolume->resolvedBlankVolume,
		BlankFrequency->resolvedBlankFrequency,
		BlankTotalVolume->resolvedBlankTotalVolume,
		BlankPremadeMasterMix->resolvedBlankPremadeMasterMix,
		BlankPremadeMasterMixReagent->resolvedBlankPremadeMasterMixReagent,
		BlankPremadeMasterMixDiluent->resolvedBlankPremadeMasterMixDiluent,
		BlankPremadeMasterMixReagentDilutionFactor->resolvedBlankPremadeMasterMixReagentDilutionFactor,
		BlankPremadeMasterMixVolume->resolvedBlankPremadeMasterMixVolume,
		BlankPremadeMasterMixStorageCondition->Lookup[expandedBlanksOptions,BlankPremadeMasterMixStorageCondition],
		BlankInternalReference->resolvedBlankInternalReference,
		BlankInternalReferenceDilutionFactor->resolvedBlankInternalReferenceDilutionFactor,
		BlankInternalReferenceVolume->resolvedBlankInternalReferenceVolume,
		BlankConcentratedSDSBuffer->resolvedBlankConcentratedSDSBuffer,
		BlankConcentratedSDSBufferDilutionFactor->resolvedBlankConcentratedSDSBufferDilutionFactor,
		BlankDiluent->resolvedBlankDiluent,
		BlankConcentratedSDSBufferVolume->resolvedBlankConcentratedSDSBufferVolume,
		BlankSDSBuffer->resolvedBlankSDSBuffer,
		BlankSDSBufferVolume->resolvedBlankSDSBufferVolume,
		BlankReduction->resolvedBlankReduction,
		BlankReducingAgent->resolvedBlankReducingAgent,
		BlankReducingAgentTargetConcentration->resolvedBlankReducingAgentTargetConcentration,
		BlankReducingAgentVolume->resolvedBlankReducingAgentVolume,
		BlankAlkylation->resolvedBlankAlkylation,
		BlankAlkylatingAgent->resolvedBlankAlkylatingAgent,
		BlankAlkylatingAgentTargetConcentration->resolvedBlankAlkylatingAgentTargetConcentration,
		BlankAlkylatingAgentVolume->resolvedBlankAlkylatingAgentVolume,
		BlankSedimentationSupernatantVolume->resolvedBlankSedimentationSupernatantVolume,
		BlankInjectionVoltageDurationProfile->resolvedBlankInjectionVoltageDurationProfile,
		BlankSeparationVoltageDurationProfile->resolvedBlankSeparationVoltageDurationProfile,
		BlankInternalReferenceStorageCondition->Lookup[expandedBlanksOptions,BlankInternalReferenceStorageCondition],
		BlankConcentratedSDSBufferStorageCondition->Lookup[expandedBlanksOptions,BlankConcentratedSDSBufferStorageCondition],
		BlankDiluentStorageCondition->Lookup[expandedBlanksOptions,BlankDiluentStorageCondition],
		BlankSDSBufferStorageCondition->Lookup[expandedBlanksOptions,BlankSDSBufferStorageCondition],
		BlankReducingAgentStorageCondition->Lookup[expandedBlanksOptions,BlankReducingAgentStorageCondition],
		BlankAlkylatingAgentStorageCondition->Lookup[expandedBlanksOptions,BlankAlkylatingAgentStorageCondition],
		CartridgeStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,CartridgeStorageCondition],
		SamplesInStorageCondition->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,SamplesInStorageCondition],
		PreparatoryUnitOperations->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,PreparatoryUnitOperations],
		PreparatoryPrimitives->Lookup[roundedCapillaryGelElectrophoresisSDSOptions, PreparatoryPrimitives],
		Cache->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Cache],
		FastTrack->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,FastTrack],
		Template->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Template],
		ParentProtocol->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,ParentProtocol],
		Operator->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Operator],
		Confirm->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Confirm],
		Name->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Name],
		Upload->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Upload],
		Output->Lookup[roundedCapillaryGelElectrophoresisSDSOptions,Output],
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
			precisionTests,
			compatibleMaterialsTests,
			validNameTest,
			sampleCountTest,
			injectionTableWithReplicatesInvalidTest,
			injectionTableVolumeZeroInvalidTest,
			invalidInjectionTableTest,
			notEnoughUsesLeftOptionTest,
			notEnoughOptimalUsesLeftOptionTest,
			notReplacingInsertTest,
			premadeMasterMixWithmakeMasterMixOptionsSetInvalidOptionTest,
			missingSampleCompositionWarningTests,
			supernatantVolumeTests,
			sedimentationForceSpeedMismatchTests,
			premadeMasterMixDilutionFactorNullTests,
			premadeMasterMixVolumeNullTests,
			premadeMasterMixVolumeDilutionFactorMismatchTests,
			premadeMasterMixTotalVolumeTests,
			internalReferenceNullTests,
			internalReferenceDilutionFactorNullTests,
			internalReferenceVolumeNullTests,
			internalReferenceVolumeDilutionFactorMismatchTests,
			reducingAgentNullTests,
			noReducingAgentIdentifiedTest,
			reducingAgentTargetConcentrationNullTests,
			reducingAgentVolumeNullTests,
			reducingAgentVolumeConcentrationMismatchTests,
			alkylatingAgentNullTests,
			noAlkylatingAgentIdentifiedTest,
			alkylatingAgentTargetConcentrationNullTests,
			alkylatingAgentVolumeNullTests,
			alkylatingAgentVolumeConcentrationMismatchTests,
			sDSBufferNullTests,
			concentratedSDSBufferDilutionFactorNullTests,
			volumeGreaterThanTotalVolumeTests,
			componentsDontSumToTotalVolumeTests,
			diluentNullTests,
			ladderDilutionFactorNullTests,
			ladderAnalyteMolecularWeightMismatchTests,
			ladderCompositionMolecularWeightMismatchTests,
			ladderAnalytesCompositionMolecularWeightMismatchTests,
			molecularWeightMissingInModelWarningTests,
			validContainerStorageConditionTests,
			bothSDSBranchesSetTest,
			premadeMasterMixDiluentNullTests,
			totalVolumeNullTests,
			volumeNullTests
		}] (* add test objects for resolved options as they are written, so you can test *)
	}
];

(* ::Subsection:: *)
(* CapillaryGelElectrophoresisSDS Helper Functions *)

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


(* To Convert centrifugation force to speed and vice versa. *)
(* Inputs -
	rpm / rcf - speed or force setting (with units or without).
	radiusCM - the rotor's radius in Cm (with or without units)]

	Output - the converted speed or force

	*)
rpmToRCF[rpm_,radiusCM_]:=
	RoundOptionPrecision[QuantityMagnitude[radiusCM]*10^-5*1.118*QuantityMagnitude[rpm]^2*GravitationalAcceleration,10^1GravitationalAcceleration];

rcfToRPM[rcf_,radiusCM_]:=
	RoundOptionPrecision[Sqrt[(QuantityMagnitude[rcf]/(QuantityMagnitude[radiusCM]*1.118*10^-5))]*RPM, 10^1RPM];


(* To combine a joined list of ObjectToString Outputs to one list  *)
(* Inputs -
	listOfStrings - list of ObjectToString outputs

	Output - String of a single list of all relevant objects
		we are assuming the order is samples, standards, blanks, and ladders, and adding headers to make it easier to know what are the issues.

	*)

combineObjectsStrings[listOfStrings_List]:=Module[{outputs},
	outputs = ToString/@Flatten[listOfStrings,1];

	(* wherever we have a faulty sample, add the relevant header (but remember it assumes a specific order of checking for failing samples_ *)
	MapThread[
		If[MatchQ[#1, {}|"{}"],
			Nothing,
			#2<>ToString[#1]
		]&,
		(* some instances check only for samples and standards, so we need to grab the right names, otherwise will get a mapthread error *)
		{outputs, {"SamplesIn: ", "Standards: ", "Blanks: ", "Ladders: "}[[;;Length[listOfStrings]]]}
	]
];

(* to expandOptions for IndexMatchingParent rather than IndexMatching Input *)
expandNumberOfReplicatesIndexMatchingParent[mySamples_List,myOptions_Association,myNumberOfReplicates_Integer]:=Module[
	{expandedOptions,expandedSamples},
	(* we are getting only options that are indexMatched, so we know they'll have to be expanded. since these are not samples, we are expanding in an alternating fashion e.g, {1,2} with 2 replicates becomes {1,2,1,2} *)
	(* Expand Samples *)
	expandedSamples=Join@@{mySamples}[[ConstantArray[1,myNumberOfReplicates]]];

	(* To expand options, we will map over options and expand as above *)
	expandedOptions=KeyValueMap[
		Function[
			{option,values},
			Rule[
				option,
				Join@@{values}[[ConstantArray[1,myNumberOfReplicates]]]]
		],
		myOptions
	];

	(* Return our expanded samples and options. *)
	{expandedSamples,expandedOptions}
];

(* This function is used to create rules for replacing objects with resources in expanded sample lists (for ladders, standards, and blanks) *)
sampleResourceRules[mySamplesWithReplicates:{ObjectP[{Model[Sample],Object[Sample]}]...},myExpandedVolumes:{VolumeP...},includeSamples_?BooleanQ]:=Module[
	{pairedObjectsVolumes,objectVolumeRules,objectResourceReplaceRules},
	(* NOTE - we dont need to take replicates into account here, since everything has already been expanded and object replace rules will sum up the volume for all replicates *)
	(* first, check if we need to include these samples or not *)
	If[Not[includeSamples],
		(* not including these, return an empty list *)
		{},
		(* Including these samples! we need to make a couple of rules *)
		(* First, pair mySamples with Volumes. Using rules so we can then Merge *)
		pairedObjectsVolumes=MapThread[
			#1->#2&,
			{mySamplesWithReplicates,myExpandedVolumes}
		];

		(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
		objectVolumeRules=Merge[pairedObjectsVolumes,Total];

		(* Make replace rules for objects and their resources; we are making one resource per sample, for all replicates (adding volume for one more replicate for good measure) *)
		(* We should always ask for a preferred container for liquid handler compatible purpose. We need to make SamplePreparationPrimitives that is done under MicroLiquidHandling scale  *)
		objectResourceReplaceRules=MapThread[
			Function[{object,volume},
				If[(volume*1.05)<20Microliter,
					object -> Resource[Sample -> Download[object, Object], Name -> ToString[Unique[]], Amount -> 20Microliter, Container -> PreferredContainer[20Microliter, LiquidHandlerCompatible->True]],
					object -> Resource[Sample -> Download[object, Object], Name -> ToString[Unique[]], Amount -> volume * 1.05, Container -> PreferredContainer[volume * 1.05, LiquidHandlerCompatible->True]]
				]
			],
			{Keys[objectVolumeRules],Values[objectVolumeRules]}
		]
	]];

(* This function is used to create rules for replacing objects with resources in expanded option lists (for reagents) *)
reagentResourceRules[myReagentWithReplicates:{ObjectP[{Model[Sample],Object[Sample]}]...},myExpandedVolumes:{VolumeP...}]:=Module[
	{pairedObjectsVolumes,objectVolumeRules,objectResourceReplaceRules},

	(* First, pair mySamples with Volumes. Using rules so we can then Merge *)
	pairedObjectsVolumes=MapThread[
		#1->#2&,
		{myReagentWithReplicates,myExpandedVolumes}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	objectVolumeRules=Merge[pairedObjectsVolumes,Total];

	(* Make replace rules for objects and their resources; we are making one resource per reagent, for all sample prep (adding 5% volume for good measure, if the volume is smaller than 25 microliter, take 25 microliter) *)
	objectResourceReplaceRules=KeyValueMap[
		Function[{object,volume},
			If[(volume*1.05)<20Microliter,
				object->Resource[Sample->Download[object,Object],Name->ToString[Unique[]],Amount->20Microliter,Container->PreferredContainer[20Microliter]],
				object->Resource[Sample->Download[object,Object],Name->ToString[Unique[]],Amount->volume*1.05,Container->PreferredContainer[volume*1.05]]
			]
		],
		objectVolumeRules
	]
];

(* ::Subsection:: *)
(* capillaryGelElectrophoresisSDSResourcePackets*)

DefineOptions[
	capillaryGelElectrophoresisSDSResourcePackets,
	Options:>{CacheOption,SimulationOption,HelperOutputOption}
];

capillaryGelElectrophoresisSDSResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs,expandedResolvedOptions,outputSpecification,output,gatherTests,messages,
		inheritedCache,sampleReplicates,samplePackets,
		sampleVolumes,pairedSamplesInAndVolumes,sampleVolumeRules,sampleResourceReplaceRules,
		instrumentTime,protocolPacket,sharedFieldPacket,finalizedPacket,optionsWithVolume,replaceVolumesForReplicates,
		allResourceBlobs,fulfillable,frqTests,testsRule,resultRule,allDownloadValues,cartridgeType,cache,samplesWithReplicates,
		expandedOptionsWithReplicates,optionsWithReplicates,uniqueSamples,uniqueSamplePackets,sampleContainers,uniquePlateContainers,
		uniqueContainers,totalInjections,injectionOverheadTime,sampleTimes,ladderTimes,standardTimes,blankTimes,setupTime,
		blanksReplicates,standardsReplicates,
		laddersReplicates,ladderOptionList,ladderOptions,standardOptionList,standardOptions,blankOptionList,blankOptions,
		numberOfReplicatesRules,laddersWithReplicates,ladderOptionsWithReplicates,standardsWithReplicates,standardOptionsWithReplicates,
		blanksWithReplicates,blankOptionsWithReplicates,expandedAliquotVolume,resolvedSampleVolume,
		ladders,standards,blanks,includeLadders,includeStandards,includeBlanks,ladderResourceRules,standardResourceRules,blankResourceRules,
		optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,
		blankOptionsWithReplicatesAssociation,premadeMasterMixObjects,premadeMasterMixVolumes,
		premadeMasterMixResourceRules,premadeMastermixDiluentTuples,premadeMasterMixDiluentObjects,premadeMasterMixDiluentVolumes,
		premadeMasterMixDiluentResourceRules,internalReferenceObjects,internalReferenceVolumes,internalReferenceResourceRules,
		reducingAgentObjects,reducingAgentVolumes,reducingAgentResourceRules,alkylatingAgentObjects,alkylatingAgentVolumes,
		alkylatingAgentResourceRules,sdsBufferTuples,sdsBufferObjects,sdsBufferVolumes,sdsBufferResourceRules,
		cartridgePacket,diluentTuples,diluentObjects,diluentVolumes,diluentResourceRules,sdsBufferChoice,injectionTableToUpload,
		diluentsVolumeOptions,runTime,updatedSimulation,simulation,originalSampleObjects,simulatedSamples,
		(* resources *)
		instrumentResource,plateSealResource,plateContainerResources,plateSealResources,
		samplesInResources,ladderResources,standardResources,blankResources,ladderPremadeMasterMixResources,
		conditioningAcidResource,conditioningBaseResource,conditioningWashSolutionResource,separationMatrixResource,
		systemWashSolutionResource,placeholderContainerResource,cartridgeResource,premadeMastermixResources,
		standardPremadeMasterMixResources,blankPremadeMasterMixResources,premadeMastermixDiluentResources,
		ladderPremadeMasterMixDiluentResources,standardPremadeMasterMixDiluentResources,blankPremadeMasterMixDiluentResources,
		internalReferenceResources,ladderInternalReferenceResources,standardInternalReferenceResources,blankInternalReferenceResources,
		reducingAgentResources,ladderReducingAgentResources,standardReducingAgentResources,blankReducingAgentResources,
		alkylatingAgentResources,ladderAlkylatingAgentResources,standardAlkylatingAgentResources,blankAlkylatingAgentResources,
		sdsBufferResources,ladderSDSBufferResources,standardSDSBufferResources,blankSDSBufferResources,concentratedSDSBufferResources,
		ladderConcentratedSDSBufferResources,standardConcentratedSDSBufferResources,blankConcentratedSDSBufferResources,
		bottomRunningBufferResource,topRunningBufferResource,topRunningBufferBackupResource,diluentResources,ladderDiluentResources,standardDiluentResources,
		blankDiluentResources,assayContainersResource,capResources,waterBeakerResource,cleanupCartridgeResource,
		cleanupCartridgeWashResources,CleanupCartridgeCapResources,cartridgeInsertReplacementResource

	},
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs,expandedResolvedOptions}=ExpandIndexMatchedInputs[ExperimentCapillaryGelElectrophoresisSDS,{mySamples},myResolvedOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache=Lookup[ToList[ops],Cache];
	simulation=Lookup[ToList[ops],Simulation];

	(* Get rid of the links in mySamples. *)
	originalSampleObjects=Download[mySamples,Object];

	(* Get our simulated samples (we have to figure out sample groupings here). *)
	{simulatedSamples,updatedSimulation}=simulateSamplesResourcePacketsNew[ExperimentCapillaryGelElectrophoresisSDS,originalSampleObjects,myResolvedOptions,Cache->inheritedCache,Simulation->simulation];

	(* --- Make our one big Download call for things not already in cache--- *)
	allDownloadValues=Quiet[Download[
		{
			Flatten@expandedInputs,
			{Lookup[myResolvedOptions,Cartridge]}
		},
		{
			{
				Packet[Container],
				Packet[Container[{Model}]],
				Packet[Container[Model[{Dimensions}]]]
			},
			{
				ExperimentType
			}
		},
		Cache->inheritedCache,
		Simulation->updatedSimulation,
		Date->Now
	],{Download::NotLinkField,Download::FieldDoesntExist}];

	(* add what we Downloaded to the new cache *)
	cache=FlattenCachePackets[{inheritedCache,Flatten[allDownloadValues]}];

	(* even though Download is currently a single item, pull that one out here *)
	samplePackets=allDownloadValues[[1]];

	(* -- Generate resources for the SamplesIn -- *)
	(* Pull out the number of replicates; make sure all Nulls become 1 *)
	sampleReplicates=Lookup[myResolvedOptions,NumberOfReplicates]/.{Null->1};

	(*expand the options based on the number of replicates *)
	{samplesWithReplicates,expandedOptionsWithReplicates}=expandNumberOfReplicates[ExperimentCapillaryGelElectrophoresisSDS,Download[mySamples,Object],expandedResolvedOptions];

	(* Replicates are injected NumberOfReplicates times, but do not need additional resources (except NumberOfUses for the cartridge), we need to set their reagent volumes to 0 microliter so no additional resources are used *)
	optionsWithVolume={SampleVolume,TotalVolume,PremadeMasterMixVolume,InternalReferenceVolume,ConcentratedSDSBufferVolume,
		SDSBufferVolume,ReducingAgentVolume,AlkylatingAgentVolume,SedimentationSupernatantVolume};

	(* Build rules for replacing values in expanded options *)
	replaceVolumesForReplicates=Rule[
		#,
		Flatten[MapThread[
			(* replace values that are not the first replicate for each object in samplesIn with 0 Microliter. *)
			(* NOTE: this will only work when replicates are expanded in the following fashion {1,2,...} -> {1,1,1,2,2,2,...} *)
			Function[{values,aliquotBool},
				If[And@@aliquotBool,
					(* if Aliquot->True, don't change things *)
					values,
					(* if Aliquot->False, change volumes to 0Microliter, this is a technical replicate *)
					{First[values],Rest[values]/.VolumeP->0 Microliter}]],
			{Partition[Lookup[expandedOptionsWithReplicates,#],sampleReplicates],Partition[Lookup[expandedOptionsWithReplicates,Aliquot],sampleReplicates]}
		]]
		(* We map this over all relevant options *)
	]&/@optionsWithVolume;

	(* Now we can replace the volumes in the expandedOptionsWithReplicates to reflect true volume requirements *)
	optionsWithReplicates=ToList @ Join[Association[expandedOptionsWithReplicates],Association[replaceVolumesForReplicates]];

	(* Delete any duplicate input samples to create a single resource per unique sample *)
	(* using the one with replicates because that one already has Object downloaded from it *)
	uniqueSamples=DeleteDuplicates[samplesWithReplicates];

	(* Extract packets for sample objects *)
	uniqueSamplePackets=fetchPacketFromCache[#,cache]&/@uniqueSamples;

	(* Get the unique sample containers*)
	sampleContainers=Download[Lookup[uniqueSamplePackets,Container],Object];

	uniqueContainers=DeleteDuplicates[sampleContainers];

	(* Get the number of unique plate containers*)
	uniquePlateContainers=DeleteDuplicates[Cases[sampleContainers,ObjectP[Object[Container,Plate]]]];

	plateContainerResources=If[Length[uniquePlateContainers]>0,
		Resource[Sample->#]&/@uniquePlateContainers];

	(* make a resource for plate seal *)
	plateSealResources=If[Length[uniquePlateContainers]>0,
		ConstantArray[Link[Resource[
			Sample->Model[Item, PlateSeal, "id:Vrbp1jKZJ0Rm"]]],2]];

	(* Get the sample volume; if we're aliquoting, use that amount; otherwise use the minimum volume the experiment will require *)
	{expandedAliquotVolume,resolvedSampleVolume}=Flatten[Lookup[optionsWithReplicates,{AliquotAmount,SampleVolume},Null],1];

	(* Template Note: Only include a volume if the experiment is actually consuming some amount *)

	sampleVolumes=MapThread[
		If[VolumeQ[#1],
			#1,
			#2*1.1
		]&,
		{expandedAliquotVolume,resolvedSampleVolume}
	];

	(* Pair the SamplesIn and their Volumes *)
	pairedSamplesInAndVolumes=MapThread[
		#1->#2&,
		{samplesWithReplicates,sampleVolumes}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleVolumeRules=Merge[pairedSamplesInAndVolumes,Total];

	(* Make replace rules for the samples and its resources;we do not multiply volumes by number of replicates - replicates are merely number of injections from the SAME assay tube *)
	sampleResourceReplaceRules=KeyValueMap[
		Function[{sample,volume},
			sample->Resource[Sample->sample,Name->ToString[Unique[]],Amount->volume ]
		],
		sampleVolumeRules
	];

	(* Use the replace rules to get the sample resources *)
	samplesInResources=Replace[samplesWithReplicates,sampleResourceReplaceRules,{1}];

	(* -- Generate resources for the Ladders, Standards, Blanks -- *)
	(* first, get their index-matched options and expand them; expanding with the expandNumberOfReplicatesIndexMatchingParent function (see above) *)
	ladderOptionList=ToExpression[#]&/@("OptionName"/.
		Cases[OptionDefinition[ExperimentCapillaryGelElectrophoresisSDS],
			KeyValuePattern["IndexMatchingParent"->"Ladders"]
		]);

	(* We are grabbing the relevant options, and converting to a list *)
	ladderOptions=KeyDrop[KeyTake[myResolvedOptions,ladderOptionList],Ladders];

	standardOptionList=ToExpression[#]&/@("OptionName"/.
		Cases[OptionDefinition[ExperimentCapillaryGelElectrophoresisSDS],
			KeyValuePattern["IndexMatchingParent"->"Standards"]
		]);

	standardOptions=KeyDrop[KeyTake[myResolvedOptions,standardOptionList],Standards];

	blankOptionList=ToExpression[#]&/@("OptionName"/.
		Cases[OptionDefinition[ExperimentCapillaryGelElectrophoresisSDS],
			KeyValuePattern["IndexMatchingParent"->"Blanks"]
		]);

	blankOptions=KeyDrop[KeyTake[myResolvedOptions,blankOptionList],Blanks];

	(* now we can expand everything based on their number of replicates (as specified in Frequency options *)

	(* get ladders/standards/blanks and thether they should be included *)
	{
		ladders,
		includeLadders,
		standards,
		includeStandards,
		blanks,
		includeBlanks
	}=Lookup[myResolvedOptions,{Ladders,IncludeLadders,
		Standards,IncludeStandards,
		Blanks,IncludeBlanks},Null];

	(* Get number of replicates for each type of sample and convert expressions to an integer number of replicates *)
	numberOfReplicatesRules={Null:>1,First:>1,Last:>1,FirstAndLast:>2,frequency_Integer:>Floor[Length[samplesWithReplicates]/frequency]};

	laddersReplicates=If[includeLadders,First@Lookup[myResolvedOptions,LadderFrequency,Null]/.numberOfReplicatesRules];
	standardsReplicates=If[includeStandards,First@Lookup[myResolvedOptions,StandardFrequency,Null]/.numberOfReplicatesRules];
	blanksReplicates=If[includeBlanks,First@Lookup[myResolvedOptions,BlankFrequency,Null]/.numberOfReplicatesRules];

	(* expand each of ladders/blanks/standards *)
	{laddersWithReplicates,ladderOptionsWithReplicates}=If[includeLadders,
		expandNumberOfReplicatesIndexMatchingParent[Download[ladders,Object],ladderOptions,laddersReplicates],
		{{},{}}];
	{standardsWithReplicates,standardOptionsWithReplicates}=If[includeStandards,
		expandNumberOfReplicatesIndexMatchingParent[Download[standards,Object],standardOptions,standardsReplicates],
		{{},{}}];
	{blanksWithReplicates,blankOptionsWithReplicates}=If[includeBlanks,
		expandNumberOfReplicatesIndexMatchingParent[Download[blanks,Object],blankOptions,blanksReplicates],
		{{},{}}];

	(* Make resource rules and specify them for each ladder, standard or blank replicate *)
	(* make a list of replacement rules *)
	ladderResourceRules=sampleResourceRules[laddersWithReplicates,Lookup[ladderOptionsWithReplicates,LadderVolume,{}],includeLadders];
	(* if we're including any ladders, replace objects with resources. if not, nothing to do here and return an empty list *)
	ladderResources=If[includeLadders,
		Replace[laddersWithReplicates,ladderResourceRules,{1}],
		{}];

	standardResourceRules=sampleResourceRules[standardsWithReplicates,Lookup[standardOptionsWithReplicates,StandardVolume,{}],includeStandards];
	(* if we're including any standards, replace objects with resources. if not, nothing to do here and return an empty list *)
	standardResources=If[includeStandards,
		Replace[standardsWithReplicates,standardResourceRules,{1}],
		{}];

	blankResourceRules=sampleResourceRules[blanksWithReplicates,Lookup[blankOptionsWithReplicates,BlankVolume,{}],includeBlanks];
	(* if we're including any blanks, replace objects with resources. if not, nothing to do here and return an empty list *)
	blankResources=If[includeBlanks,
		Replace[blanksWithReplicates,blankResourceRules,{1}],
		{}];

	(* --- Make all the resources needed in the experiment --- *)

	(* resource packets are made for all needed resources for samples, blanks, standards, and ladders together. *)
	(* because ladders rely on the unique combinations in samplesIn, we need to first figure out what we need for them, we are grabbing all fields, but will not consider sample and total volumes and diluent *)

	totalInjections=Length[Lookup[myResolvedOptions,MatchedInjectionTable]];

	(* make general run resources - volumes here are all hard coded since the instrument requires these to run properly
regardless of the number of injections to be made *)
	conditioningAcidResource=Resource[Sample->Lookup[myResolvedOptions,ConditioningAcid],Amount->1.5Milliliter,Container->Model[Container,Vessel,"id:Y0lXejlqEMNE"]];
	conditioningBaseResource=Resource[Sample->Lookup[myResolvedOptions,ConditioningBase],Amount->1.5Milliliter,Container->Model[Container,Vessel,"id:Y0lXejlqEMNE"]];
	conditioningWashSolutionResource=Resource[Sample->Lookup[myResolvedOptions,ConditioningWashSolution],Amount->1Milliliter,Container->Model[Container,Vessel,"id:Y0lXejlqEMNE"]];
	separationMatrixResource=Resource[Sample->Lookup[myResolvedOptions,SeparationMatrix],Amount->1Milliliter,Container->Model[Container,Vessel,"id:Y0lXejlqEMNE"]];
	(* system wash needs to be split two two containers, making two different resources for this *)
	systemWashSolutionResource=ConstantArray[(Resource[Sample->Lookup[myResolvedOptions,SystemWashSolution],Amount->1Milliliter,Container->Model[Container,Vessel,"id:Y0lXejlqEMNE"]]),3];
	placeholderContainerResource=Resource[Sample->Lookup[myResolvedOptions,PlaceholderContainer]];
	cartridgeResource=Resource[
		Sample->Lookup[myResolvedOptions,Cartridge],
		NumberOfUses->Max[Length[Lookup[myResolvedOptions,MatchedInjectionTable]], 1] (* set the number of uses to be at least 1, otherwise it will fail simulation*)
	];
	cleanupCartridgeResource=Resource[Sample->Model[Item,Consumable,"CESDS Cartridge Cleanup Column"],NumberOfUses->1];
	cleanupCartridgeWashResources=Resource[Sample->Model[Sample,"Milli-Q water"],Amount->1.5Milliliter,Container->Model[Container,Vessel,"id:Y0lXejlqEMNE"]];
	CleanupCartridgeCapResources=Resource[Sample->Model[Item,Cap,"Pressure Cap for CESDS"],Rent->True];
	capResources=Flatten@{ConstantArray[Resource[Sample->Model[Item,Cap,"Pressure Cap for CESDS"],Rent->True],6],ConstantArray[Resource[Sample->Model[Item,Cap,"Maurice Clear Screw Caps"]],3]};
	(* We need two resources for running buffer, one bottom and one top. The top one is loaded on the cartridge and is present in the cartridge model, the bottom is user specified *)
	bottomRunningBufferResource=Resource[Sample->Lookup[myResolvedOptions,RunningBuffer],Amount->1Milliliter,Container->Model[Container,Vessel,"id:Y0lXejlqEMNE"]];

	(* the top running buffer comes as vials (single use), we need to pick those out of the cartridge model *)
	cartridgePacket=fetchPacketFromCache[Lookup[myResolvedOptions,Cartridge],cache];
	topRunningBufferResource=If[MatchQ[Lookup[cartridgePacket,OnBoardRunningBuffer], Except[Null]],
		Resource[Sample->Download[Lookup[cartridgePacket,OnBoardRunningBuffer],Object]],
		Null
	];
	(* this is a resource the will be picked ONLY if a cartridge purge is required (cartridge has not been used for 3 months or more *)
	topRunningBufferBackupResource=If[
		MatchQ[Lookup[myResolvedOptions,PurgeCartridge],Except[False]]&&MatchQ[Lookup[cartridgePacket,OnBoardRunningBuffer],Except[Null]],
		Resource[Sample->Download[Lookup[cartridgePacket,OnBoardRunningBuffer],Object]],
		Null
	];

	(* Set up assay containers - the first container is used to prepare the samples (including boiling and centrifugation), the second is used to run them after transfer *)
	(* at least for the time being, we are using the Biorad 96-well plates as our assay container *)
	(*assayContainersResource = {Resource[Sample->Model[Container, Plate, "96-well Optical Full-Skirted PCR Plate"]],Resource[Sample->Model[Container, Plate, "Biorad 96-well PCR Plate"]]};*)
	(* If we are denaturing samples, we need a plate that is compatible with the PCR first and transfer to another after, otherwise, use only Maurice compatible plate *)
	assayContainersResource=Which[
		(* sample needs to be incubated *)
		Lookup[myResolvedOptions,Denature],
		{Resource[Sample->Model[Container,Plate,"96-well Optical Full-Skirted PCR Plate"]],Resource[Sample->Model[Container,Plate,"96-Well Full-Skirted PCR Plate"]]},
		(* Spinning samples but not denaturing requires two plates *)
		Lookup[myResolvedOptions,PelletSedimentation],
		{Resource[Sample->Model[Container,Plate,"96-Well Full-Skirted PCR Plate"]],Resource[Sample->Model[Container,Plate,"96-Well Full-Skirted PCR Plate"]]},
		(* no incubation or spin *)
		True,
		{Resource[Sample->Model[Container,Plate,"96-Well Full-Skirted PCR Plate"]]}
	];

	(* this is a resource the will be picked ONLY if the Cartridge Insert needs to be replaced (indicator is red AFTER run *)
	cartridgeInsertReplacementResource=If[
		MatchQ[Lookup[myResolvedOptions,ReplaceCartridgeInsert],True],
		Link[Resource[Sample->Model[Container,ProteinCapillaryElectrophoresisCartridgeInsert,"id:vXl9j57R9wV7"]]],
		Null
	];

	(* Generally resources are made with the following logic: for each sample type, we match reagent and volume and create
	a resource for each unique reagent across samples, blanks, standards and ladders, by definition, will use every unique combination
	in samplesIn *)
	(* First, we create matched tuples of sample/standard/blank/ladder reagent objects, needed volume, and number of replicates based on the rules we created above and filter out nulls *)
	(* the number of replicates applies to each sample/standards/etc so we want to keep it for the ride, hence the constant array. we are replacing 0 with 1 so that the transpose wont break if there are no samples for that category *)

	(* Make expended option lists into associations *)
	{
		optionsWithReplicatesAssociation,
		ladderOptionsWithReplicatesAssociation,
		standardOptionsWithReplicatesAssociation,
		blankOptionsWithReplicatesAssociation
	}=Association[#]&/@{optionsWithReplicates,ladderOptionsWithReplicates,standardOptionsWithReplicates,blankOptionsWithReplicates};

	(* below are a couple of functions to help streamline making resources *)
	(* to make adding the prefix to fields easier *)
	prefixToField[prefixToAdd_String,field_Symbol]:=ToExpression[prefixToAdd<>ToString[field]];

	(* to make resources need the reagents, their volumes and number of replicates - we will combine ones from each sample type (samplesIn/Ladders/Blanks/Standards to generate one resource for all *)
	(* to get a single resource for samplesIn, ladders, blanks, and standards, we first need to join these fields from each group *)
	joinListsByField[myReagent_Symbol,myReagentVolume_Symbol]:=Module[
		{samplesObjects,volumeObjects,objectVolumeTuples,noNullObjects},

		(* join all object lists fpr this reagent together *)
		samplesObjects=Join[
			MapThread[
				Function[{association,field},ToList[Lookup[association,field,{}]]],
				{
					{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
					{myReagent,prefixToField["Ladder",myReagent],prefixToField["Standard",myReagent],prefixToField["Blank",myReagent]}
				}
			]];

		(* join all reagent volume fields together *)
		volumeObjects=Join[
			MapThread[
				Function[{association,field},Lookup[association,field,{}]],
				{
					{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
					{myReagentVolume,prefixToField["Ladder",myReagentVolume],prefixToField["Standard",myReagentVolume],prefixToField["Blank",myReagentVolume]}
				}
			]];

		(* transpose all lists and drop whatever is not an object *)
		objectVolumeTuples=Transpose[Flatten[#]&/@{samplesObjects,volumeObjects}];

		(* return object/volume/replicate lists only for valid objects *)
		noNullObjects=Cases[objectVolumeTuples,{ObjectP[],VolumeP}];

		(* if there's anything valid, return a transposed list (so that objects and volumes are separated. otherwiase return empty lists*)
		If[Length[noNullObjects]>0,
			Transpose[noNullObjects],
			{{},{}}
		]
	];

	(* Generating resources for PremadeMasterMix *)

	(* combine objects, volumes, and replicates to specific lists for samples/ladders/standards/blanks *)
	{premadeMasterMixObjects,premadeMasterMixVolumes}=joinListsByField[PremadeMasterMixReagent,PremadeMasterMixVolume];

	(* Make common resource rules for all *)
	premadeMasterMixResourceRules=reagentResourceRules[premadeMasterMixObjects,premadeMasterMixVolumes];

	(* replace objects with resources for each of the samples/ladders/standards/blanks *)
	{
		premadeMastermixResources,
		ladderPremadeMasterMixResources,
		standardPremadeMasterMixResources,
		blankPremadeMasterMixResources
	}=MapThread[
		Replace[Lookup[#1,#2,{}],premadeMasterMixResourceRules,{1}]&,
		{
			{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{PremadeMasterMixReagent,LadderPremadeMasterMixReagent,StandardPremadeMasterMixReagent,BlankPremadeMasterMixReagent}
		}
	];

	(* Generate premade mastermix diluent resources *)
	(* unlike most other reagents, this one requires us to calculate the required volumes before making the resource *)
	(* to that end we need to get the reagents, total volume, and sample volume for each sample*)
	premadeMastermixDiluentTuples=
		Cases[Flatten[MapThread[
			Function[{association,field},Transpose[Lookup[association,field,{}]]],
			{
				{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
				{
					{PremadeMasterMixDiluent,PremadeMasterMixVolume,SampleVolume,TotalVolume},
					{LadderPremadeMasterMixDiluent,LadderPremadeMasterMixVolume,LadderVolume,LadderTotalVolume},
					{StandardPremadeMasterMixDiluent,StandardPremadeMasterMixVolume,StandardVolume,StandardTotalVolume},
					{BlankPremadeMasterMixDiluent,BlankPremadeMasterMixVolume,BlankVolume,BlankTotalVolume}
				}
			}
		],1],{ObjectP[],VolumeP,VolumeP,VolumeP}];

	(* combine objects, and calculated volumes to separate lists for all reagents *)
	{
		premadeMasterMixDiluentObjects,
		premadeMasterMixDiluentVolumes
	}=If[Length[premadeMastermixDiluentTuples]>0,
		Transpose[MapThread[
			Function[
				{masterMixDiluent,masterMixVolume,sampleVolume,totalVolume},
				{masterMixDiluent,totalVolume-(masterMixVolume+sampleVolume)}
			],
			Transpose[premadeMastermixDiluentTuples]
		]],
		{{},{}}
	];

	(* Make common resource rules for all *)
	premadeMasterMixDiluentResourceRules=reagentResourceRules[premadeMasterMixDiluentObjects,premadeMasterMixDiluentVolumes];

	(* replace objects with resources for each of the samples/ladders/standards/blanks *)
	{
		premadeMastermixDiluentResources,
		ladderPremadeMasterMixDiluentResources,
		standardPremadeMasterMixDiluentResources,
		blankPremadeMasterMixDiluentResources
	}=MapThread[
		Replace[Lookup[#1,#2,{}],premadeMasterMixDiluentResourceRules,{1}]&,
		{
			{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{PremadeMasterMixDiluent,LadderPremadeMasterMixDiluent,StandardPremadeMasterMixDiluent,BlankPremadeMasterMixDiluent}
		}
	];

	(* Generate InternalReferences resources *)
	(* combine objects, volumes, and replicates to specific lists for samples/ladders/standards/blanks *)
	{internalReferenceObjects,internalReferenceVolumes}=joinListsByField[InternalReference,InternalReferenceVolume];

	(* Make common resource rules for all *)
	internalReferenceResourceRules=reagentResourceRules[internalReferenceObjects,internalReferenceVolumes];

	(* replace objects with resources for each of the samples/ladders/standards/blanks *)
	{
		internalReferenceResources,
		ladderInternalReferenceResources,
		standardInternalReferenceResources,
		blankInternalReferenceResources
	}=MapThread[
		Replace[Lookup[#1,#2,{}],internalReferenceResourceRules,{1}]&,
		{
			{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{InternalReference,LadderInternalReference,StandardInternalReference,BlankInternalReference}
		}
	];

	(* Generate reducingAgent resources *)
	(* combine objects, volumes, and replicates to specific lists for samples/ladders/standards/blanks *)
	{reducingAgentObjects,reducingAgentVolumes}=joinListsByField[ReducingAgent,ReducingAgentVolume];

	(* Make common resource rules for all *)
	reducingAgentResourceRules=reagentResourceRules[reducingAgentObjects,reducingAgentVolumes];

	(* replace objects with resources for each of the samples/ladders/standards/blanks *)
	{
		reducingAgentResources,
		ladderReducingAgentResources,
		standardReducingAgentResources,
		blankReducingAgentResources
	}=MapThread[
		Replace[Lookup[#1,#2,{}],reducingAgentResourceRules,{1}]&,
		{
			{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{ReducingAgent,LadderReducingAgent,StandardReducingAgent,BlankReducingAgent}
		}
	];

	(* Generate alkylatingAgent resources *)
	(* combine objects, volumes, and replicates to specific lists for samples/ladders/standards/blanks *)
	{alkylatingAgentObjects,alkylatingAgentVolumes}=joinListsByField[AlkylatingAgent,AlkylatingAgentVolume];

	(* Make common resource rules for all *)
	alkylatingAgentResourceRules=reagentResourceRules[alkylatingAgentObjects,alkylatingAgentVolumes];

	(* replace objects with resources for each of the samples/ladders/standards/blanks *)
	{
		alkylatingAgentResources,
		ladderAlkylatingAgentResources,
		standardAlkylatingAgentResources,
		blankAlkylatingAgentResources
	}=MapThread[
		Replace[Lookup[#1,#2,{}],alkylatingAgentResourceRules,{1}]&,
		{
			{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{AlkylatingAgent,LadderAlkylatingAgent,StandardAlkylatingAgent,BlankAlkylatingAgent}
		}
	];


	(* Generate SDSBuffer resources *)
	(* We need to figure out if both concentrated and nonconcentrated are informed. if they are, a warning is raised and the buffer is defaulted to Concentrated so that's what we need to pick resources for.  *)
	(* Moreover, the reagent might overlap for both, so we need to make sure we acocunt for that as well *)

	(* First, grab all the relevant fields for both SDSBuffer and Concentrated SDSBuffer *)
	sdsBufferTuples=
		Cases[Flatten[MapThread[
			Function[{association,field},Transpose[Lookup[association,field,{}]]],
			{
				{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
				{
					{ConcentratedSDSBuffer,ConcentratedSDSBufferVolume,SDSBuffer,SDSBufferVolume},
					{LadderConcentratedSDSBuffer,LadderConcentratedSDSBufferVolume,LadderSDSBuffer,LadderSDSBufferVolume},
					{StandardConcentratedSDSBuffer,StandardConcentratedSDSBufferVolume,StandardSDSBuffer,StandardSDSBufferVolume},
					{BlankConcentratedSDSBuffer,BlankConcentratedSDSBufferVolume,BlankSDSBuffer,BlankSDSBufferVolume}
				}
			}
		],1],
			Alternatives[
				{ObjectP[],VolumeP,ObjectP[],VolumeP},
				{Null,Null,ObjectP[],VolumeP},
				{ObjectP[],VolumeP,Null,Null}
			]
		];

	(* To handle the different cases where concentratedSDSBuffer AND/OR SDSBuffer is specified and what values to take, we will parse out the relevant information first *)

	sdsBufferChoice=Join[
		(* only concentrated *)
		Cases[sdsBufferTuples,{ObjectP[],VolumeP,Null,Null}][[All,{1,2}]],
		(* only top off *)
		Cases[sdsBufferTuples,{Null,Null,ObjectP[],VolumeP}][[All,{3,4}]],
		(* both are specified by user - we use concentrated, by default*)
		Cases[sdsBufferTuples,{ObjectP[],VolumeP,ObjectP[],VolumeP}][[All,{1,2}]]
	];

	(* transpose the results, unless no results could be extracted, in which case return empty lists *)
	{
		sdsBufferObjects,
		sdsBufferVolumes
	}=If[Length[sdsBufferChoice]>0,
		Transpose[sdsBufferChoice],
		{{},{}}]
	;

	(* Make common resource rules for all *)
	sdsBufferResourceRules=reagentResourceRules[sdsBufferObjects,sdsBufferVolumes];

	(* replace objects with resources for each of the samples/ladders/standards/blanks; we are doing this twice here, once for Concentrated SDSBuffer, and once for SDSBuffer *)
	{
		concentratedSDSBufferResources,
		ladderConcentratedSDSBufferResources,
		standardConcentratedSDSBufferResources,
		blankConcentratedSDSBufferResources
	}=MapThread[
		Replace[Lookup[#1,#2,{}],sdsBufferResourceRules,{1}]&,
		{
			{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{ConcentratedSDSBuffer,LadderConcentratedSDSBuffer,StandardConcentratedSDSBuffer,BlankConcentratedSDSBuffer}
		}
	];

	{
		sdsBufferResources,
		ladderSDSBufferResources,
		standardSDSBufferResources,
		blankSDSBufferResources
	}=MapThread[
		Replace[Lookup[#1,#2,{}],sdsBufferResourceRules,{1}]&,
		{
			{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{SDSBuffer,LadderSDSBuffer,StandardSDSBuffer,BlankSDSBuffer}
		}
	];

	(* in cases where concentratedSDS is used, we will often need a diluent to complete the volume, and we will need to calculate how much that is *)

	(* First, grab all the relevant fields for both SDSBuffer and Concentrated SDSBuffer, as well as sample volumes, alkylatingAgentVolumes, Reducing agent volumes, and internal reference *)
	diluentTuples=
		Cases[Flatten[MapThread[
			Function[{association,field},Transpose[Lookup[association,field,{}]]],
			{
				{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
				{
					{ConcentratedSDSBuffer,ConcentratedSDSBufferVolume,SDSBuffer,SDSBufferVolume,SampleVolume,TotalVolume,ReducingAgentVolume,AlkylatingAgentVolume,InternalReferenceVolume,Diluent},
					{LadderConcentratedSDSBuffer,LadderConcentratedSDSBufferVolume,LadderSDSBuffer,LadderSDSBufferVolume,LadderVolume,LadderTotalVolume,LadderReducingAgentVolume,LadderAlkylatingAgentVolume,LadderInternalReferenceVolume,LadderDiluent},
					{StandardConcentratedSDSBuffer,StandardConcentratedSDSBufferVolume,StandardSDSBuffer,StandardSDSBufferVolume,StandardVolume,StandardTotalVolume,StandardReducingAgentVolume,StandardAlkylatingAgentVolume,StandardInternalReferenceVolume,StandardDiluent},
					{BlankConcentratedSDSBuffer,BlankConcentratedSDSBufferVolume,BlankSDSBuffer,BlankSDSBufferVolume,BlankVolume,BlankTotalVolume,BlankReducingAgentVolume,BlankAlkylatingAgentVolume,BlankInternalReferenceVolume,BlankDiluent}
				}
			}
		],1],
			{ObjectP[]|Null,VolumeP|Null,ObjectP[]|Null,VolumeP|Null,VolumeP,VolumeP,VolumeP|Null,VolumeP|Null,VolumeP,ObjectP[]}
		];

	(* To handle the different cases where concentratedSDSBuffer AND/OR SDSBuffer is specified and what values to take, we will parse out the relevant information first *)
	(* We can now extract the relevant information from options - we have to account for all different cases where one is valid and the other is not *)
	diluentsVolumeOptions=
		ReplaceAll[Join[
			(* only concentrated *)
			Cases[diluentTuples,{ObjectP[],VolumeP,Null,Null,VolumeP,VolumeP,VolumeP|Null,VolumeP|Null,VolumeP,ObjectP[]}][[All,{1,2,5,6,7,8,9,10}]],
			(* only concentrated *)
			Cases[diluentTuples,{ObjectP[],VolumeP,ObjectP[],Null,VolumeP,VolumeP,VolumeP|Null,VolumeP|Null,VolumeP,ObjectP[]}][[All,{1,2,5,6,7,8,9,10}]],
			(* only concentrated *)
			Cases[diluentTuples,{ObjectP[],VolumeP,Null,VolumeP,VolumeP,VolumeP,VolumeP|Null,VolumeP|Null,VolumeP,ObjectP[]}][[All,{1,2,5,6,7,8,9,10}]],
			(* only top off *)
			Cases[diluentTuples,{Null,Null,ObjectP[],VolumeP,VolumeP,VolumeP,VolumeP|Null,VolumeP|Null,VolumeP,ObjectP[]}][[All,{3,4,5,6,7,8,9,10}]],
			(* only top off *)
			Cases[diluentTuples,{ObjectP[],Null,ObjectP[],VolumeP,VolumeP,VolumeP,VolumeP|Null,VolumeP|Null,VolumeP,ObjectP[]}][[All,{3,4,5,6,7,8,9,10}]],
			(* only top off *)
			Cases[diluentTuples,{Null,VolumeP,ObjectP[],VolumeP,VolumeP,VolumeP,VolumeP|Null,VolumeP|Null,VolumeP,ObjectP[]}][[All,{3,4,5,6,7,8,9,10}]],
			(* both are specified by user - we use concentrated, by default *** at the moment, this cant happen, we deal with it in the resolver and warn ** *)
			Cases[diluentTuples,{ObjectP[],VolumeP,ObjectP[],VolumeP,VolumeP,VolumeP,VolumeP|Null,VolumeP|Null,VolumeP,ObjectP[]}][[All,{1,2,5,6,7,8,9,10}]]
		],Null:>0 Microliter];

	(* diluent resources *)
	{
		diluentObjects,
		diluentVolumes
		(* when premadeMastermix is true for all samples, will not have any of these fields informed..  *)
	}=If[Length[diluentsVolumeOptions]>0,
		Transpose[
			MapThread[Function[{bufferObject,bufferVolume,sampleVolume,totalVolume,reducingVolume,alkylatingVolume,internalReferenceVolume,diluentObject},
				{diluentObject,totalVolume-Total[ReplaceAll[{sampleVolume,bufferVolume,internalReferenceVolume,reducingVolume,alkylatingVolume},Null->0Microliter]]}
			],
				Transpose[Cases[diluentsVolumeOptions,{ObjectP[],VolumeP,VolumeP,VolumeP,VolumeP|Null,VolumeP|Null,VolumeP,ObjectP[]}]]
			]],
		{{},{}}
	];

	(* Make common resource rules for all *)
	diluentResourceRules=reagentResourceRules[diluentObjects,diluentVolumes];

	(* replace objects with resources for each of the samples/ladders/standards/blanks; we are doing this twice here, once for Concentrated SDSBuffer, and once for SDSBuffer *)
	{
		diluentResources,
		ladderDiluentResources,
		standardDiluentResources,
		blankDiluentResources
	}=MapThread[
		Replace[Lookup[#1,#2,{}],diluentResourceRules,{1}]&,
		{
			{optionsWithReplicatesAssociation,ladderOptionsWithReplicatesAssociation,standardOptionsWithReplicatesAssociation,blankOptionsWithReplicatesAssociation},
			{Diluent,LadderDiluent,StandardDiluent,BlankDiluent}
		}
	];

	(* -- Generate instrument resources -- *)
	(* setup and overhead times depend on the cartridge type *)
	cartridgeType=First[Flatten[allDownloadValues[[2]]]];

	(* we need to consider the time the instrument takes between samples, which is approximately 3 minutes *)
	injectionOverheadTime=Switch[cartridgeType,
		CESDS,182Second,
		CESDSPlus,321Second,
		_, 0*Second
	];
	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
		this will probably look like set-up time + time/sample + tear-down time *)
	(* to calculate time needed, consider setup time + the sum of injection time and seperation time, for each of samples/standards/blanks/ladders and add an overhead of about 10 seconds in between samples, and add teh cleanup time at the end. *)
	sampleTimes=Total@MapThread[
		Function[{injectionTime,separationTime},
			(* Since we can get up to 20 steps, need to add times for all steps *)
			Total@injectionTime+Total@separationTime],
		{Lookup[optionsWithReplicatesAssociation,InjectionVoltageDurationProfile][[All,All,2]],
			Lookup[optionsWithReplicatesAssociation,SeparationVoltageDurationProfile][[All,All,2]]}
	];

	ladderTimes=If[includeLadders,
		(* we count the number of ladders in the injection table and divide by the number of unique injection/separation profiles since those are accounted for in the mapthread *)
		Total@MapThread[
			Function[{injectionTime,separationTime},
				(* Since we can get up to 20 steps, need to add times for all steps *)
				Total@injectionTime+Total@separationTime],
			{Lookup[ladderOptionsWithReplicatesAssociation,LadderInjectionVoltageDurationProfile][[All,All,2]],
				Lookup[ladderOptionsWithReplicatesAssociation,LadderSeparationVoltageDurationProfile][[All,All,2]]}
		],
		0Second
	];

	standardTimes=If[includeStandards,
		(* we count the number of ladders in the injection table and divide by the number of unique injection/separation profiles since those are accounted for in the mapthread *)
		Total@MapThread[
			Function[{injectionTime,separationTime},
				(* Since we can get up to 20 steps, need to add times for all steps *)
				Total@injectionTime+Total@separationTime],
			{Lookup[standardOptionsWithReplicatesAssociation,StandardInjectionVoltageDurationProfile][[All,All,2]],
				Lookup[standardOptionsWithReplicatesAssociation,StandardSeparationVoltageDurationProfile][[All,All,2]]}
		],
		0Second
	];

	blankTimes=If[includeBlanks,
		(* we count the number of ladders in the injection table and divide by the number of unique injection/separation profiles since those are accounted for in the mapthread *)
		Total@MapThread[
			Function[{injectionTime,separationTime},
				(* Since we can get up to 20 steps, need to add times for all steps *)
				Total@injectionTime+Total@separationTime],
			{Lookup[blankOptionsWithReplicatesAssociation,BlankInjectionVoltageDurationProfile][[All,All,2]],
				Lookup[blankOptionsWithReplicatesAssociation,BlankSeparationVoltageDurationProfile][[All,All,2]]}
		],
		0Second
	];

	(* Instrument time is the sum of this + setup/teardown. need to make sure the time set for cleanup is correct*)
	setupTime=Switch[cartridgeType,
		CESDS,(1100*Second+360*Second),
		CESDSPlus,(1100*Second+600*Second),
		_, 0*Second
	];

	runTime=totalInjections*injectionOverheadTime+sampleTimes+ladderTimes+standardTimes+blankTimes;
	(* runTime is setup + runtime + cleanup time and additional time for movements between positions that isnt calculated above *)
	instrumentTime=setupTime+runTime+60Minute;

	instrumentResource=Resource[Instrument->Lookup[myResolvedOptions,Instrument],Time->instrumentTime];

	(* Generate an uploadable version of the injection table *)
	injectionTableToUpload=If[MatchQ[Lookup[myResolvedOptions,MatchedInjectionTable],{}],
		{},
		MapThread[
			Function[{type, sample, volume, index},
				Association[
					Type -> type,
					Sample -> Link[sample/.Join[sampleResourceReplaceRules,standardResourceRules,blankResourceRules]],
					Volume -> volume,
					Data -> Null,
					SampleIndex->index
				]
			],
			Transpose[Lookup[myResolvedOptions,MatchedInjectionTable]]
		]
	];

	(* generate a resource for water in beaker, in case we need to clean up the cartridge tip *)
	waterBeakerResource=Resource[
		Sample->Model[Sample,"Milli-Q water"],
		Amount->30 Milliliter,
		Container->Model[Container,Vessel,"50mL Pyrex Beaker"]
	];

	(* --- Generate the protocol packet --- *)
	protocolPacket=<|
		Type->Object[Protocol,CapillaryGelElectrophoresisSDS],
		Object->CreateID[Object[Protocol,CapillaryGelElectrophoresisSDS]],
		Replace[SamplesIn]->(Link[#,Protocols]&)/@samplesInResources,
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@uniqueContainers,
		UnresolvedOptions->RemoveHiddenOptions[ExperimentCapillaryGelElectrophoresisSDS,myUnresolvedOptions],
		ResolvedOptions->RemoveHiddenOptions[ExperimentCapillaryGelElectrophoresisSDS,myResolvedOptions],
		Template->If[MatchQ[Lookup[myResolvedOptions,Template],FieldReferenceP[]],
			Link[Most[Lookup[myResolvedOptions,Template]],ProtocolsTemplated],
			Link[Lookup[myResolvedOptions,Template],ProtocolsTemplated]
		],
		Instrument->Link[instrumentResource],
		Cartridge->Link[cartridgeResource],
		RunTime->runTime,
		Replace[InjectionTable]->injectionTableToUpload,
		NumberOfReplicates->sampleReplicates,
		SampleTemperature->Lookup[myResolvedOptions,SampleTemperature],
		(* instrument setup and general options *)
		ConditioningAcid->Link[conditioningAcidResource],
		ConditioningBase->Link[conditioningBaseResource],
		ConditioningWashSolution->Link[conditioningWashSolutionResource],
		SeparationMatrix->Link[separationMatrixResource],
		SeparationMatrix->Link[separationMatrixResource],
		Replace[SystemWashSolution]->(Link[#]&)/@systemWashSolutionResource,
		PlaceholderContainer->Link[placeholderContainerResource],
		ConditioningAcidStorageCondition->Lookup[myResolvedOptions,ConditioningAcidStorageCondition],
		ConditioningBaseStorageCondition->Lookup[myResolvedOptions,ConditioningBaseStorageCondition],
		SeparationMatrixStorageCondition->Lookup[myResolvedOptions,SeparationMatrixStorageCondition],
		SystemWashSolutionStorageCondition->Lookup[myResolvedOptions,SystemWashSolutionStorageCondition],
		CartridgeStorageCondition->Lookup[myResolvedOptions,CartridgeStorageCondition],
		(* the first container is used to prepare the samples (including boiling and centrifugation), the second is used to run them after transfer *)
		Replace[AssayContainers]->(Link[#]&)/@assayContainersResource,
		CleanupCartridge->Link[cleanupCartridgeResource],
		CleanupCartridgeWashSolution->Link[cleanupCartridgeWashResources],
		CleanupCartridgeCap->Link[CleanupCartridgeCapResources],
		Replace[Caps]->(Link[#]&)/@capResources,
		(*)PlateSeal -> Link[plateSealResources],*)
		CartridgeTipCleanup->Link[waterBeakerResource],
		TopRunningBuffer->Link[topRunningBufferResource],
		TopRunningBufferBackup->Link[topRunningBufferBackupResource],
		PurgeCartridge->Lookup[optionsWithReplicatesAssociation,PurgeCartridge],
		CartridgeInsertReplacement->cartridgeInsertReplacementResource,
		BottomRunningBuffer->Link[bottomRunningBufferResource],
		Denature->Lookup[optionsWithReplicatesAssociation,Denature,Null],
		DenaturingTemperature->Lookup[optionsWithReplicatesAssociation,DenaturingTemperature,Null],
		DenaturingTime->Lookup[optionsWithReplicatesAssociation,DenaturingTime,Null],
		CoolingTemperature->Lookup[optionsWithReplicatesAssociation,CoolingTemperature,Null],
		CoolingTime->Lookup[optionsWithReplicatesAssociation,CoolingTime,Null],
		PelletSedimentation->Lookup[optionsWithReplicatesAssociation,PelletSedimentation,Null],
		SedimentationCentrifugationSpeed->Lookup[optionsWithReplicatesAssociation,SedimentationCentrifugationSpeed,Null],
		SedimentationCentrifugationForce->Lookup[optionsWithReplicatesAssociation,SedimentationCentrifugationForce,Null],
		SedimentationCentrifugationTime->Lookup[optionsWithReplicatesAssociation,SedimentationCentrifugationTime,Null],
		SedimentationCentrifugationTemperature->Lookup[optionsWithReplicatesAssociation,SedimentationCentrifugationTemperature,Null],

		(* indexMatched to SamplesIn *)
		Replace[TotalVolumes]->Lookup[optionsWithReplicatesAssociation,TotalVolume,{}],
		Replace[SampleVolumes]->Lookup[optionsWithReplicatesAssociation,SampleVolume,{}],
		Replace[PremadeMasterMixReagents]->(Link[#]&)/@premadeMastermixResources,
		Replace[PremadeMasterMixDiluents]->(Link[#]&)/@premadeMastermixDiluentResources,
		Replace[PremadeMasterMixReagentDilutionFactors]->Lookup[optionsWithReplicatesAssociation,PremadeMasterMixReagentDilutionFactor,{}],
		Replace[PremadeMasterMixVolumes]->Lookup[optionsWithReplicatesAssociation,PremadeMasterMixVolume,{}],
		Replace[InternalReferences]->(Link[#]&)/@internalReferenceResources,
		Replace[InternalReferenceDilutionFactors]->Lookup[optionsWithReplicatesAssociation,InternalReferenceDilutionFactor,{}],
		Replace[InternalReferenceVolumes]->Lookup[optionsWithReplicatesAssociation,InternalReferenceVolume,{}],
		Replace[ConcentratedSDSBuffers]->(Link[#]&)/@concentratedSDSBufferResources,
		Replace[ConcentratedSDSBufferDilutionFactors]->Lookup[optionsWithReplicatesAssociation,ConcentratedSDSBufferDilutionFactor,{}],
		Replace[ConcentratedSDSBufferVolumes]->Lookup[optionsWithReplicatesAssociation,ConcentratedSDSBufferVolume,{}],
		Replace[Diluents]->(Link[#]&)/@diluentResources,
		Replace[SDSBuffers]->(Link[#]&)/@sdsBufferResources,
		Replace[SDSBufferVolumes]->Lookup[optionsWithReplicatesAssociation,SDSBufferVolume,{}],
		Replace[ReducingAgents]->(Link[#]&)/@reducingAgentResources,
		Replace[ReducingAgentTargetConcentrations]->Lookup[optionsWithReplicatesAssociation,ReducingAgentTargetConcentration,{}],
		Replace[ReducingAgentVolumes]->Lookup[optionsWithReplicatesAssociation,ReducingAgentVolume,{}],
		Replace[AlkylatingAgents]->(Link[#]&)/@alkylatingAgentResources,
		Replace[AlkylatingAgentTargetConcentrations]->Lookup[optionsWithReplicatesAssociation,AlkylatingAgentTargetConcentration,{}],
		Replace[AlkylatingAgentVolumes]->Lookup[optionsWithReplicatesAssociation,AlkylatingAgentVolume,{}],
		Replace[SedimentationSupernatantVolumes]->Lookup[optionsWithReplicatesAssociation,SedimentationSupernatantVolume,{}],
		Replace[InternalReferenceStorageConditions]->Lookup[optionsWithReplicatesAssociation,InternalReferenceStorageCondition,{}],
		Replace[ConcentratedSDSBufferStorageConditions]->Lookup[optionsWithReplicatesAssociation,ConcentratedSDSBufferStorageCondition,{}],
		Replace[DiluentStorageConditions]->Lookup[optionsWithReplicatesAssociation,DiluentStorageCondition,{}],
		Replace[SDSBufferStorageConditions]->Lookup[optionsWithReplicatesAssociation,SDSBufferStorageCondition,{}],
		Replace[ReducingAgentStorageConditions]->Lookup[optionsWithReplicatesAssociation,ReducingAgentStorageCondition,{}],
		Replace[AlkylatingAgentStorageConditions]->Lookup[optionsWithReplicatesAssociation,AlkylatingAgentStorageCondition,{}],
		Replace[InjectionVoltageDurationProfiles]->Lookup[optionsWithReplicatesAssociation,InjectionVoltageDurationProfile,{}],
		Replace[SeparationVoltageDurationProfiles]->Lookup[optionsWithReplicatesAssociation,SeparationVoltageDurationProfile,{}],
		(* Matched to Ladders *)
		Replace[Ladders]->(Link[#]&)/@ladderResources,
		Replace[LadderStorageConditions]->Lookup[ladderOptionsWithReplicatesAssociation,LadderStorageCondition,{}],
		Replace[LadderAnalytes]->Lookup[ladderOptionsWithReplicatesAssociation,LadderAnalytes,{}],
		Replace[LadderAnalyteMolecularWeights]->Lookup[ladderOptionsWithReplicatesAssociation,LadderAnalyteMolecularWeights,{}],
		Replace[LadderAnalyteLabels]->Lookup[ladderOptionsWithReplicatesAssociation,LadderAnalyteLabels,{}],
		Replace[LadderTotalVolumes]->Lookup[ladderOptionsWithReplicatesAssociation,LadderTotalVolume,{}],
		Replace[LadderDilutionFactors]->Lookup[ladderOptionsWithReplicatesAssociation,LadderDilutionFactor,{}],
		Replace[LadderVolumes]->Lookup[ladderOptionsWithReplicatesAssociation,LadderVolume,{}],
		Replace[LadderPremadeMasterMixReagents]->(Link[#]&)/@ladderPremadeMasterMixResources,
		Replace[LadderPremadeMasterMixDiluents]->(Link[#]&)/@ladderPremadeMasterMixDiluentResources,
		Replace[LadderPremadeMasterMixReagentDilutionFactors]->Lookup[ladderOptionsWithReplicatesAssociation,LadderPremadeMasterMixReagentDilutionFactors,{}],
		Replace[LadderPremadeMasterMixVolumes]->Lookup[ladderOptionsWithReplicatesAssociation,LadderPremadeMasterMixVolume,{}],
		Replace[LadderInternalReferences]->(Link[#]&)/@ladderInternalReferenceResources,
		Replace[LadderInternalReferenceDilutionFactors]->Lookup[ladderOptionsWithReplicatesAssociation,LadderInternalReferenceDilutionFactor,{}],
		Replace[LadderInternalReferenceVolumes]->Lookup[ladderOptionsWithReplicatesAssociation,LadderInternalReferenceVolume,{}],
		Replace[LadderConcentratedSDSBuffers]->(Link[#]&)/@ladderConcentratedSDSBufferResources,
		Replace[LadderConcentratedSDSBufferDilutionFactors]->Lookup[ladderOptionsWithReplicatesAssociation,LadderConcentratedSDSBufferDilutionFactor,{}],
		Replace[LadderConcentratedSDSBufferVolumes]->Lookup[ladderOptionsWithReplicatesAssociation,LadderConcentratedSDSBufferVolume,{}],
		Replace[LadderDiluents]->(Link[#]&)/@ladderDiluentResources,
		Replace[LadderSDSBuffers]->(Link[#]&)/@ladderSDSBufferResources,
		Replace[LadderSDSBufferVolumes]->Lookup[ladderOptionsWithReplicatesAssociation,LadderSDSBufferVolume,{}],
		Replace[LadderReducingAgents]->(Link[#]&)/@ladderReducingAgentResources,
		Replace[LadderReducingAgentTargetConcentrations]->Lookup[ladderOptionsWithReplicatesAssociation,LadderReducingAgentTargetConcentration,{}],
		Replace[LadderReducingAgentVolumes]->Lookup[ladderOptionsWithReplicatesAssociation,LadderReducingAgentVolume,{}],
		Replace[LadderAlkylatingAgents]->(Link[#]&)/@ladderAlkylatingAgentResources,
		Replace[LadderAlkylatingAgentTargetConcentrations]->Lookup[ladderOptionsWithReplicatesAssociation,LadderAlkylatingAgentTargetConcentration,{}],
		Replace[LadderAlkylatingAgentVolumes]->Lookup[ladderOptionsWithReplicatesAssociation,LadderAlkylatingAgentVolume,{}],
		Replace[LadderSedimentationSupernatantVolumes]->Lookup[ladderOptionsWithReplicatesAssociation,LadderSedimentationSupernatantVolume,{}],
		Replace[LadderInternalReferenceStorageConditions]->Lookup[ladderOptionsWithReplicatesAssociation,LadderInternalReferenceStorageCondition,{}],
		Replace[LadderConcentratedSDSBufferStorageConditions]->Lookup[ladderOptionsWithReplicatesAssociation,LadderConcentratedSDSBufferStorageCondition,{}],
		Replace[LadderDiluentStorageConditions]->Lookup[ladderOptionsWithReplicatesAssociation,LadderDiluentStorageCondition,{}],
		Replace[LadderSDSBufferStorageConditions]->Lookup[ladderOptionsWithReplicatesAssociation,LadderSDSBufferStorageCondition,{}],
		Replace[LadderReducingAgentStorageConditions]->Lookup[ladderOptionsWithReplicatesAssociation,LadderReducingAgentStorageCondition,{}],
		Replace[LadderAlkylatingAgentStorageConditions]->Lookup[ladderOptionsWithReplicatesAssociation,LadderAlkylatingAgentStorageCondition,{}],
		Replace[LadderInjectionVoltageDurationProfiles]->Lookup[ladderOptionsWithReplicatesAssociation,LadderInjectionVoltageDurationProfile,{}],
		Replace[LadderSeparationVoltageDurationProfiles]->Lookup[ladderOptionsWithReplicatesAssociation,LadderSeparationVoltageDurationProfile,{}],
		(* Matched to Standards *)
		Replace[Standards]->(Link[#]&)/@standardResources,
		Replace[StandardStorageConditions]->Lookup[standardOptionsWithReplicatesAssociation,StandardStorageCondition,{}],
		Replace[StandardTotalVolumes]->Lookup[standardOptionsWithReplicatesAssociation,StandardTotalVolume,{}],
		Replace[StandardVolumes]->Lookup[standardOptionsWithReplicatesAssociation,StandardVolume,{}],
		Replace[StandardPremadeMasterMixReagents]->(Link[#]&)/@standardPremadeMasterMixResources,
		Replace[StandardPremadeMasterMixDiluents]->(Link[#]&)/@standardPremadeMasterMixDiluentResources,
		Replace[StandardPremadeMasterMixReagentDilutionFactors]->Lookup[standardOptionsWithReplicatesAssociation,StandardPremadeMasterMixReagentDilutionFactor,{}],
		Replace[StandardPremadeMasterMixVolumes]->Lookup[standardOptionsWithReplicatesAssociation,StandardPremadeMasterMixVolume,{}],
		Replace[StandardInternalReferences]->(Link[#]&)/@standardInternalReferenceResources,
		Replace[StandardInternalReferenceDilutionFactors]->Lookup[standardOptionsWithReplicatesAssociation,StandardInternalReferenceDilutionFactor,{}],
		Replace[StandardInternalReferenceVolumes]->Lookup[standardOptionsWithReplicatesAssociation,StandardInternalReferenceVolume,{}],
		Replace[StandardConcentratedSDSBuffers]->(Link[#]&)/@standardConcentratedSDSBufferResources,
		Replace[StandardConcentratedSDSBufferDilutionFactors]->Lookup[standardOptionsWithReplicatesAssociation,StandardConcentratedSDSBufferDilutionFactor,{}],
		Replace[StandardConcentratedSDSBufferVolumes]->Lookup[standardOptionsWithReplicatesAssociation,StandardConcentratedSDSBufferVolume,{}],
		Replace[StandardDiluents]->(Link[#]&)/@standardDiluentResources,
		Replace[StandardSDSBuffers]->(Link[#]&)/@standardSDSBufferResources,
		Replace[StandardSDSBufferVolumes]->Lookup[standardOptionsWithReplicatesAssociation,StandardSDSBufferVolume,{}],
		Replace[StandardReducingAgents]->(Link[#]&)/@standardReducingAgentResources,
		Replace[StandardReducingAgentTargetConcentrations]->Lookup[standardOptionsWithReplicatesAssociation,StandardReducingAgentTargetConcentration,{}],
		Replace[StandardReducingAgentVolumes]->Lookup[standardOptionsWithReplicatesAssociation,StandardReducingAgentVolume,{}],
		Replace[StandardAlkylatingAgents]->(Link[#]&)/@standardAlkylatingAgentResources,
		Replace[StandardAlkylatingAgentTargetConcentrations]->Lookup[standardOptionsWithReplicatesAssociation,StandardAlkylatingAgentTargetConcentration,{}],
		Replace[StandardAlkylatingAgentVolumes]->Lookup[standardOptionsWithReplicatesAssociation,StandardAlkylatingAgentVolume,{}],
		Replace[StandardSedimentationSupernatantVolumes]->Lookup[standardOptionsWithReplicatesAssociation,StandardSedimentationSupernatantVolume,{}],
		Replace[StandardInternalReferenceStorageConditions]->Lookup[standardOptionsWithReplicatesAssociation,StandardInternalReferenceStorageCondition,{}],
		Replace[StandardConcentratedSDSBufferStorageConditions]->Lookup[standardOptionsWithReplicatesAssociation,StandardConcentratedSDSBufferStorageCondition,{}],
		Replace[StandardDiluentStorageConditions]->Lookup[standardOptionsWithReplicatesAssociation,StandardDiluentStorageCondition,{}],
		Replace[StandardSDSBufferStorageConditions]->Lookup[standardOptionsWithReplicatesAssociation,StandardSDSBufferStorageCondition,{}],
		Replace[StandardReducingAgentStorageConditions]->Lookup[standardOptionsWithReplicatesAssociation,StandardReducingAgentStorageCondition,{}],
		Replace[StandardAlkylatingAgentStorageConditions]->Lookup[standardOptionsWithReplicatesAssociation,StandardAlkylatingAgentStorageCondition,{}],
		Replace[StandardInjectionVoltageDurationProfiles]->Lookup[standardOptionsWithReplicatesAssociation,StandardInjectionVoltageDurationProfile,{}],
		Replace[StandardSeparationVoltageDurationProfiles]->Lookup[standardOptionsWithReplicatesAssociation,StandardSeparationVoltageDurationProfile,{}],
		(* Matched to Blanks *)
		Replace[Blanks]->(Link[#]&)/@blankResources,
		Replace[BlankStorageConditions]->Lookup[blankOptionsWithReplicatesAssociation,BlankStorageCondition,{}],
		Replace[BlankTotalVolumes]->Lookup[blankOptionsWithReplicatesAssociation,BlankTotalVolume,{}],
		Replace[BlankVolumes]->Lookup[blankOptionsWithReplicatesAssociation,BlankVolume,{}],
		Replace[BlankPremadeMasterMixReagents]->(Link[#]&)/@blankPremadeMasterMixResources,
		Replace[BlankPremadeMasterMixDiluents]->(Link[#]&)/@blankPremadeMasterMixDiluentResources,
		Replace[BlankPremadeMasterMixReagentDilutionFactors]->Lookup[blankOptionsWithReplicatesAssociation,BlankPremadeMasterMixReagentDilutionFactor,{}],
		Replace[BlankPremadeMasterMixVolumes]->Lookup[blankOptionsWithReplicatesAssociation,BlankPremadeMasterMixVolume,{}],
		Replace[BlankInternalReferences]->(Link[#]&)/@blankInternalReferenceResources,
		Replace[BlankInternalReferenceDilutionFactors]->Lookup[blankOptionsWithReplicatesAssociation,BlankInternalReferenceDilutionFactor,{}],
		Replace[BlankInternalReferenceVolumes]->Lookup[blankOptionsWithReplicatesAssociation,BlankInternalReferenceVolume,{}],
		Replace[BlankConcentratedSDSBuffers]->(Link[#]&)/@blankConcentratedSDSBufferResources,
		Replace[BlankConcentratedSDSBufferDilutionFactors]->Lookup[blankOptionsWithReplicatesAssociation,BlankConcentratedSDSBufferDilutionFactor,{}],
		Replace[BlankConcentratedSDSBufferVolumes]->Lookup[blankOptionsWithReplicatesAssociation,BlankConcentratedSDSBufferVolume,{}],
		Replace[BlankDiluents]->(Link[#]&)/@blankDiluentResources,
		Replace[BlankSDSBuffers]->(Link[#]&)/@blankSDSBufferResources,
		Replace[BlankSDSBufferVolumes]->Lookup[blankOptionsWithReplicatesAssociation,BlankSDSBufferVolume,{}],
		Replace[BlankReducingAgents]->(Link[#]&)/@blankReducingAgentResources,
		Replace[BlankReducingAgentTargetConcentrations]->Lookup[blankOptionsWithReplicatesAssociation,BlankReducingAgentTargetConcentration,{}],
		Replace[BlankReducingAgentVolumes]->Lookup[blankOptionsWithReplicatesAssociation,BlankReducingAgentVolume,{}],
		Replace[BlankAlkylatingAgents]->(Link[#]&)/@blankAlkylatingAgentResources,
		Replace[BlankAlkylatingAgentTargetConcentrations]->Lookup[blankOptionsWithReplicatesAssociation,BlankAlkylatingAgentTargetConcentration,{}],
		Replace[BlankAlkylatingAgentVolumes]->Lookup[blankOptionsWithReplicatesAssociation,BlankAlkylatingAgentVolume,{}],
		Replace[BlankSedimentationSupernatantVolumes]->Lookup[blankOptionsWithReplicatesAssociation,BlankSedimentationSupernatantVolume,{}],
		Replace[BlankInternalReferenceStorageConditions]->Lookup[blankOptionsWithReplicatesAssociation,BlankInternalReferenceStorageCondition,{}],
		Replace[BlankConcentratedSDSBufferStorageConditions]->Lookup[blankOptionsWithReplicatesAssociation,BlankConcentratedSDSBufferStorageCondition,{}],
		Replace[BlankDiluentStorageConditions]->Lookup[blankOptionsWithReplicatesAssociation,BlankDiluentStorageCondition,{}],
		Replace[BlankSDSBufferStorageConditions]->Lookup[blankOptionsWithReplicatesAssociation,BlankSDSBufferStorageCondition,{}],
		Replace[BlankReducingAgentStorageConditions]->Lookup[blankOptionsWithReplicatesAssociation,BlankReducingAgentStorageCondition,{}],
		Replace[BlankAlkylatingAgentStorageConditions]->Lookup[blankOptionsWithReplicatesAssociation,BlankAlkylatingAgentStorageCondition,{}],
		Replace[BlankInjectionVoltageDurationProfiles]->Lookup[blankOptionsWithReplicatesAssociation,BlankInjectionVoltageDurationProfile,{}],
		Replace[BlankSeparationVoltageDurationProfiles]->Lookup[blankOptionsWithReplicatesAssociation,BlankSeparationVoltageDurationProfile,{}],
		Replace[BlankSeparationVoltageDurationProfiles]->Lookup[blankOptionsWithReplicatesAssociation,BlankSeparationVoltageDurationProfile,{}],
		(*TODO: UPDATE when we have a procedure *)
		Replace[Checkpoints]->{
			{"Preparing Samples",1 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->1 Minute]]},
			{"Picking Resources",30 Minute,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->10 Minute]]},
			{"Preparing Assay Plate",2 Hour,"Reagents such as sample buffer, internal standards, and reducing or alkylating agents, are mixed with samples, ladders, standards, and/or blanks.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->1 Minute]]},
			{"Returning Materials",15 Minute,"Samples and reagents are returned to storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->15*Minute]]},
			{"Preparing Instrument",90Minute,"Setting up the instrument by gathering the required reagents, preparing the experiment cartridge and loading required reagents.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->5 Minute]]},
			{"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->1*Hour]]},
			{"Running Samples",instrumentTime,"Analyzing the loaded samples by capillary gel electrophoresis SDS.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->10*Minute]]},
			{"Instrument Cleanup",60 Minute,"The experiment cartridge is cleaned and stored, and used reagents are disposed of.",Link[Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->10*Minute]]}
		}
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cache,Simulation->updatedSimulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[sharedFieldPacket,protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];
	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache,Simulation->updatedSimulation],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache,Simulation->updatedSimulation],Null}
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification/.{resultRule,testsRule}
];

(* ::Subsection:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentCapillaryGelElectrophoresisSDS,
	Options:>{CacheOption,SimulationOption}
];

(* This simulation function simulates resource picking, sample prep and transfers into the assay plate, and placement of
all reagents into the instrument. No samples are discarded, no caps are placed to cover their containers,
and no containers are moved out of the instrument *)
simulateExperimentCapillaryGelElectrophoresisSDS[
	myResourcePacket:(PacketP[Object[Protocol, CapillaryGelElectrophoresisSDS], {Object, ResolvedOptions}]|$Failed),
	mySamples:{ObjectP[Object[Sample]]...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentCapillaryGelElectrophoresisSDS]]:=
Module[
	{
		cache, simulation, samplePackets, protocolObject, fulfillmentSimulation, simulationWithLabels,
		protocolPacket,workingSamplesPackets,workingLaddersPackets,workingStandardsPackets,workingBlanksPackets,
		workingSamplesContainerModelPacket,cartridgeType,instrumentObject,informedInjectionTable,injectionTableWithWells,
		samplePrepPlate,assayPlate,premadeMastermixPrimitives,premadeMastermixDilutentPrimitives,internalReferencePrimitives,
		sDSBufferPrimitives,reducingAgentPrimitives,alkylatingAgentPrimitives,diluentPrimitives,workingSamplesPrimitives,
		wellsAndVolumes,samplePrepPrimitives,transferPrimitives,updatedInjectionTable,conditioningAcid,
		conditioningBase,conditioningWashSolution,separationMatrix,systemWashSolution,placeholderContainer,bottomRunningBuffer,
		cartridge,exportedInstrumentPressureCapPlacements,exportedInstrumentPlacements,exportedCartridgePlacement,exportedAssayPlatePlacement,
		updatedSimulation,objectsToMove,destinations,locationPackets,assayContainers,assignedWells,assayPlateDestinationSamples,
		samplePrepPlateDestinationSamples,assayPlateLookupWell,samplePrepPlateLookupWell,samplePrepSimulation
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
		SimulateCreateID[Object[Protocol,CapillaryGelElectrophoresisSDS]],
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
	updatedSimulation =  fulfillmentSimulation;

	(* Get resource information off of the simulation packets to simulate the compiler *)
	{
		(*1*)protocolPacket,
		(*2*)workingSamplesPackets,
		(*3*)workingLaddersPackets,
		(*4*)workingStandardsPackets,
		(*5*)workingBlanksPackets,
		(*6*)workingSamplesContainerModelPacket,
		(*7*)cartridgeType,
		(*8*)instrumentObject,
		(*9*)conditioningAcid,
		(*10*)conditioningBase,
		(*11*)conditioningWashSolution,
		(*12*)separationMatrix,
		(*13*)systemWashSolution,
		(*14*)placeholderContainer,
		(*15*)bottomRunningBuffer,
		(*16*)cartridge
	}=Quiet[Download[protocolObject,
		{
			(*1*)Packet[InjectionTable,Type,Object,Cartridge,AssayContainers,PelletSedimentation,InjectionVoltageDurationProfiles,
				BlankInjectionVoltageDurationProfiles,StandardInjectionVoltageDurationProfiles,LadderInjectionVoltageDurationProfiles,
				SeparationVoltageDurationProfiles,BlankSeparationVoltageDurationProfiles,StandardSeparationVoltageDurationProfiles,
				LadderSeparationVoltageDurationProfiles,TotalVolumes,BlankTotalVolumes,StandardTotalVolumes,LadderTotalVolumes,
				SampleVolumes,BlankVolumes,StandardVolumes,LadderVolumes,PremadeMasterMixReagents,BlankPremadeMasterMixReagents,
				StandardPremadeMasterMixReagents,LadderPremadeMasterMixReagents,PremadeMasterMixVolumes,BlankPremadeMasterMixVolumes,
				StandardPremadeMasterMixVolumes,LadderPremadeMasterMixVolumes,PremadeMasterMixDiluents,BlankPremadeMasterMixDiluents,
				StandardPremadeMasterMixDiluents,LadderPremadeMasterMixDiluents,InternalReferences,BlankInternalReferences,
				StandardInternalReferences,LadderInternalReferences,InternalReferenceVolumes,BlankInternalReferenceVolumes,
				StandardInternalReferenceVolumes,LadderInternalReferenceVolumes,ConcentratedSDSBuffers,BlankConcentratedSDSBuffers,
				StandardConcentratedSDSBuffers,LadderConcentratedSDSBuffers,ConcentratedSDSBufferVolumes,BlankConcentratedSDSBufferVolumes,
				StandardConcentratedSDSBufferVolumes,LadderConcentratedSDSBufferVolumes,SDSBuffers,BlankSDSBuffers,StandardSDSBuffers,
				LadderSDSBuffers,SDSBufferVolumes,BlankSDSBufferVolumes,StandardSDSBufferVolumes,LadderSDSBufferVolumes,ReducingAgents,
				BlankReducingAgents,StandardReducingAgents,LadderReducingAgents,ReducingAgentVolumes,BlankReducingAgentVolumes,
				StandardReducingAgentVolumes,LadderReducingAgentVolumes,AlkylatingAgents,BlankAlkylatingAgents,StandardAlkylatingAgents,
				LadderAlkylatingAgents,AlkylatingAgentVolumes,BlankAlkylatingAgentVolumes,StandardAlkylatingAgentVolumes,
				LadderAlkylatingAgentVolumes,Diluents,BlankDiluents,StandardDiluents,LadderDiluents,DenaturingTemperatures,
				BlankDenaturingTemperatures,StandardDenaturingTemperatures,LadderDenaturingTemperatures,DenaturingTimes,
				BlankDenaturingTimes,StandardDenaturingTimes,LadderDenaturingTimes,SedimentationSupernatantVolumes,
				BlankSedimentationSupernatantVolumes,StandardSedimentationSupernatantVolumes,LadderSedimentationSupernatantVolumes,SampleTemperature
			],
			(*2*)SamplesIn[Object],
			(*3*)Ladders[Object],
			(*4*)Standards[Object],
			(*5*)Blanks[Object],
			(*6*)Packet[SamplesIn[Container][Model]],
			(*7*)Cartridge[ExperimentType],
			(*8*)Instrument[Object],
			(*9*)ConditioningAcid[Container],
			(*10*)ConditioningBase[Container],
			(*11*)ConditioningWashSolution[Container],
			(*12*)SeparationMatrix[Container],
			(*13*)SystemWashSolution[Container],
			(*14*)PlaceholderContainer,
			(*15*)BottomRunningBuffer[Container],
			(*16*)Cartridge
		},
		Cache->cache,
		Simulation->updatedSimulation,
		Date->Now
	],Download::FieldDoesntExist];

	(* the parts below are ALL taken from the compiler. make sure changes are propagated to both *)
	(* Propagate fields from the simulated protocol packet to the injection table *)
	informedInjectionTable = updateCEInjectionTable[protocolPacket, workingSamplesPackets,workingLaddersPackets,workingStandardsPackets,workingBlanksPackets];

	(* Designate wells to each of the samples we run *)
	injectionTableWithWells = If[MatchQ[informedInjectionTable, {}],
		{},
		assignCEPlateWell[protocolPacket, informedInjectionTable]
	];

	(* to avoid using ExperimentSamplePreparation here, we will create sham samples and uploadSampleTransfer instead of using primitives.
	Older commits use ExperimentSamplePreparation is we need to revert *)

	(* Get the object ID for prep plate and assay plate objects. If they are models, pull it out of the upload association if not, just grab the container *)
	{samplePrepPlate,assayPlate} = If[Length[Lookup[protocolPacket, AssayContainers]]==2,
			{
				First[Download[Lookup[protocolPacket, AssayContainers],Object]],
				Last[Download[Lookup[protocolPacket, AssayContainers],Object]]
			},
			(* If there's only one plate, it means that prep and assay are in the same plate *)
			{
				First[Download[Lookup[protocolPacket, AssayContainers],Object]],
				First[Download[Lookup[protocolPacket, AssayContainers],Object]]
			}
		];

	(* Now we need to make a sham sample in each well we transfer reagents to, so we can use UploadSampleTransfer *)
	assignedWells = ToString/@Lookup[injectionTableWithWells, Well, {}];

	(* upload a sample to each well in teh assay plate *)
	assayPlateDestinationSamples = UploadSample[
		ConstantArray[{{Null,Null}}, Length[assignedWells]],
		Transpose[{assignedWells, ConstantArray[assayPlate, Length[assignedWells]]}],
		Simulation -> updatedSimulation,
		UpdatedBy->protocolObject,
		Upload->False,
		SimulationMode -> True
	];

	(* if needed, update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[assayPlateDestinationSamples]];

	(* if using a prep plate, upload a different sample to each of its wells *)
	samplePrepPlateDestinationSamples = If[Length[Lookup[protocolPacket, AssayContainers]] == 2,
		UploadSample[
			ConstantArray[{{Null,Null}}, Length[assignedWells]],
			Transpose[{assignedWells, ConstantArray[samplePrepPlate, Length[assignedWells]]}],
			Simulation -> updatedSimulation,
			UpdatedBy->protocolObject,
			Upload->False,
			SimulationMode -> True
		],
		Null
	];

	(* if needed, update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[samplePrepPlateDestinationSamples]];

	(* make lookup associations to match well and sample in each container - because we're not really uploading, get positions from the upload packet *)
	assayPlateLookupWell = If[!MatchQ[Cases[Lookup[assayPlateDestinationSamples, {Position, Object}, {}], {WellP,ObjectP[]}],{}],
		MapThread[
			#1->#2&,
			Transpose[Cases[Lookup[assayPlateDestinationSamples, {Position, Object}], {WellP,ObjectP[]}]]
		],
		{}
	];

	samplePrepPlateLookupWell = If[!NullQ[samplePrepPlateDestinationSamples]&&!MatchQ[Cases[Lookup[samplePrepPlateDestinationSamples, {Position, Object}, {}], {WellP,ObjectP[]}],{}],
		MapThread[
			#1->#2&,
			Transpose[Cases[Lookup[samplePrepPlateDestinationSamples, {Position, Object}], {WellP,ObjectP[]}]]
		],
		assayPlateLookupWell
	];

	(* premadeMasterMix reagent+diluent primitives *)
	{
		premadeMastermixPrimitives,
		premadeMastermixDilutentPrimitives
	} = If[!MatchQ[injectionTableWithWells,{}],
		Transpose[MapThread[
			Function[{reagent, reagentVolume, diluent, totalVolume, sampleVolume, well},
				Module[{diluentVolume, premadeMastermixQ, premadeMastermixPrimitive, premadeMastermixDiluentPrimitive},
					(* check if premademastermix options are informed. Even if they are informed, if the sample volume is 0Microliter, it means this is a replicates so we should skip this one *)
					premadeMastermixQ = If[sampleVolume == 0Microliter,
						False,
						Not[Or[NullQ[reagent], NullQ[reagentVolume], NullQ[diluent]]]
					];

					(* if we are using a premademastermix, see if we need to dilute anything *)
					diluentVolume = If[premadeMastermixQ,
						RoundOptionPrecision[(totalVolume - sampleVolume - reagentVolume), 10^-1Microliter],
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
			Transpose[Lookup[injectionTableWithWells, {PremadeMasterMixReagents,PremadeMasterMixVolumes,PremadeMasterMixDiluents,TotalVolumes, SampleVolumes, Well},Null]]
		]],
		{Null, Null}
	];

	(* make your own mastermix reagents primitives *)
	{
		internalReferencePrimitives,
		sDSBufferPrimitives,
		reducingAgentPrimitives,
		alkylatingAgentPrimitives,
		diluentPrimitives
		} = If[!MatchQ[injectionTableWithWells,{}],
      Transpose[MapThread[
			Function[{
				internalReference,internalReferenceVolume,concentratedSDSBuffer,concentratedSDSBufferVolume,sdsBuffer,sdsBufferVolume,
				reducingAgent,reducingAgentVolume,alkylatingAgent,alkylatingAgentVolume,diluent, totalVolume, sampleVolume, well
			},
				Module[{
					diluentVolume, makeOwnMastermixQ,internalReferencePrimitive,sdsBufferPrimitive,
					reducingAgentPrimitive,alkylatingAgentPrimitive,diluentPrimitive
				},
					(* If Any of these options are informed,Even if they are informed, if the sample volume is 0Microliter, it means this is a replicates so we should skip this one    *)
					makeOwnMastermixQ = If[sampleVolume == 0Microliter,
						False,
						Or@@(!NullQ[#]&)/@{internalReference,internalReferenceVolume,concentratedSDSBuffer,concentratedSDSBufferVolume,sdsBuffer,sdsBufferVolume,
							reducingAgent,reducingAgentVolume,alkylatingAgent,alkylatingAgentVolume,diluent}
					];

					(* If we are making our own mastermix, see if we need to add a diuent *)
					diluentVolume = If[makeOwnMastermixQ,
						RoundOptionPrecision[(totalVolume - sampleVolume - internalReferenceVolume - concentratedSDSBufferVolume /. Null:> 0Microliter - sdsBufferVolume /. Null:> 0Microliter - reducingAgentVolume/. Null:> 0Microliter - alkylatingAgentVolume/. Null:> 0Microliter), 10^-1Microliter],
						Null
					];

					(* If making our own mastermix, transfer an internal standerd to the samplePrep plate *)
					internalReferencePrimitive = If[makeOwnMastermixQ,
						UploadSampleTransfer[
							Download[internalReference,Object],
							Lookup[samplePrepPlateLookupWell, well],
							internalReferenceVolume,
							Simulation -> updatedSimulation,
							UpdatedBy->protocolObject,
							Upload->False
						],
						Null
					];

					(* If making our own mastermix and using a reducing agent, transfer it to the samplePrep plate *)
					reducingAgentPrimitive = If[makeOwnMastermixQ&&!NullQ[reducingAgent],
						UploadSampleTransfer[
							Download[reducingAgent,Object],
							Lookup[samplePrepPlateLookupWell, well],
							reducingAgentVolume,
							Simulation -> updatedSimulation,
							UpdatedBy->protocolObject,
							Upload->False
						],
						Null
					];

					(* If making our own mastermix and using a alkylating agent, transfer it to the samplePrep plate *)
					alkylatingAgentPrimitive = If[makeOwnMastermixQ&&!NullQ[alkylatingAgent],
						UploadSampleTransfer[
							Download[alkylatingAgent,Object],
							Lookup[samplePrepPlateLookupWell, well],
							alkylatingAgentVolume,
							Simulation -> updatedSimulation,
							UpdatedBy->protocolObject,
							Upload->False
						],
						Null
					];

					(* now, if we are using a premade mastermix, we need to check if we need a diluent and transfer it to the sample prep tube *)
					diluentPrimitive = If[makeOwnMastermixQ && (diluentVolume > 0Microliter),
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

					(* Next get your SDS buffer, but it may be either concentrated or not, so we need to figure it out before generating primitives *)
					(* Since this is the largest volume transferred in to the assay tube, we will transfer it last and add Mix *)
					sdsBufferPrimitive = If[makeOwnMastermixQ,
						Which[
							(* we have a concentrated SDSBuffer but not SDSBuffer *)
							!NullQ[concentratedSDSBuffer] && NullQ[sdsBuffer],
							UploadSampleTransfer[
								Download[concentratedSDSBuffer,Object],
								Lookup[samplePrepPlateLookupWell, well],
								concentratedSDSBufferVolume,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							],
							(* we have the SDSBuffer and not ConcentratedSDSBuffer *)
							NullQ[concentratedSDSBuffer] && !NullQ[sdsBuffer],
							UploadSampleTransfer[
								Download[sdsBuffer,Object],
								Lookup[samplePrepPlateLookupWell, well],
								sdsBufferVolume,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							],
							(* we have both for whatever reason, make sure its true for volumes too, if they are, use ConcentratedSDSBuffer *)
							!NullQ[concentratedSDSBuffer] && !NullQ[sdsBuffer] && !NullQ[concentratedSDSBufferVolume],
							UploadSampleTransfer[
								Download[concentratedSDSBuffer,Object],
								Lookup[samplePrepPlateLookupWell, well],
								concentratedSDSBufferVolume,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							],
							(* we have both for whatever reason, make sure its true for volumes too, if they are, use ConcentratedSDSBuffer *)
							!NullQ[concentratedSDSBuffer] && !NullQ[sdsBuffer] && NullQ[concentratedSDSBufferVolume],
							UploadSampleTransfer[
								Download[sdsBuffer,Object],
								Lookup[samplePrepPlateLookupWell, well],
								sdsBufferVolume,
								Simulation -> updatedSimulation,
								UpdatedBy->protocolObject,
								Upload->False
							]
						],
						Null
					];

					(* return primitives *)
					{internalReferencePrimitive,sdsBufferPrimitive,reducingAgentPrimitive,alkylatingAgentPrimitive,diluentPrimitive}
				]],

			Transpose[Lookup[injectionTableWithWells, {InternalReferences,InternalReferenceVolumes,ConcentratedSDSBuffers,ConcentratedSDSBufferVolumes,
				SDSBuffers,SDSBufferVolumes,ReducingAgents,ReducingAgentVolumes,AlkylatingAgents,AlkylatingAgentVolumes,Diluents,
				TotalVolumes,SampleVolumes,Well},Null]]
		]],
		{Null, Null, Null, Null, Null}
	];

	(* sample/ladder/standard/blank primitives *)
	(* This relies on adding samples to an already prepared plate, so we can mix again *)
	workingSamplesPrimitives = If[!MatchQ[injectionTableWithWells,{}],
		MapThread[
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
					Null
				]
			],
			Transpose[Lookup[injectionTableWithWells,{WorkingSample,SampleVolumes,Well},Null]]
		],
		Null
	];

	(* Add another mix for the whole plate for good measure *)
	(* we need to make sure to avoid reinjections, so first get unduplicated wells and volumes *)
	wellsAndVolumes = If[!MatchQ[injectionTableWithWells,{}],
		Part[
			SortBy[Last] /@ GatherBy[Lookup[injectionTableWithWells,{Well, TotalVolumes}], #[[1]] &],
			All,
			-1,
			1 ;; 2],
		{}
	];

	(* Once everything is ready, and after we centrifuge, we will need to transfer  *)
	transferPrimitives = If[!MatchQ[injectionTableWithWells,{}],
		Flatten[
			MapThread[
				Function[{transferVolume,totalVolume,well},
					Which[
						(* there's a specified value, since PelletSedimentation is True *)
						!NullQ[transferVolume]&&transferVolume>0Microliter,
						UploadSampleTransfer[
							Lookup[samplePrepPlateLookupWell, well],
							Lookup[assayPlateLookupWell, well],
							transferVolume,
							Simulation -> updatedSimulation,
							UpdatedBy->protocolObject,
							Upload->False
						],
						(* incubating but not spinning, need to move plates from PCR specific to Maurice specific *)
						Lookup[protocolPacket, Denature]&&!Lookup[protocolPacket, PelletSedimentation],
						UploadSampleTransfer[
							Lookup[samplePrepPlateLookupWell, well],
							Lookup[assayPlateLookupWell, well],
							totalVolume,
							Simulation -> updatedSimulation,
							UpdatedBy->protocolObject,
							Upload->False
						],
						True,Null
					]],
				(* we dont need to transfer again when we have replicates, so we're deleting duplicates *)
				Transpose[DeleteDuplicates[Lookup[injectionTableWithWells,{SedimentationSupernatantVolumes,TotalVolume,Well},Null]]]
			]
		],
		Null
	];

	samplePrepPrimitives = Flatten[Cases[
		{
			premadeMastermixPrimitives,premadeMastermixDilutentPrimitives,
			internalReferencePrimitives,reducingAgentPrimitives,alkylatingAgentPrimitives,
			diluentPrimitives,sDSBufferPrimitives,workingSamplesPrimitives,transferPrimitives
		},
		!NullQ[#]&
	],1];

	(* if needed, update simulation *)
	samplePrepSimulation = UpdateSimulation[updatedSimulation,Simulation[samplePrepPrimitives]];

	(* if we had any entries in the injection table that were models, replace them with the appropriate objects *)
	updatedInjectionTable = If[!MatchQ[injectionTableWithWells,{}],
		MapThread[
			Function[{type, sample, volume, data, workingSample},
				If[MatchQ[sample, ObjectP[Model[]]],
					<|Type -> type, Sample -> Link[Download[workingSample, Object]],Volume -> volume, Data -> data |>,
					<|Type -> type, Sample -> Link[Download[sample, Object]],Volume -> volume, Data -> data |>]],
			Transpose[Lookup[injectionTableWithWells, {Type, Sample, Volume, Data, WorkingSample}]]
		],
		{}
	];

	(* we are splitting placement tuples here to allow adding elaborate instructions ahead of each one *)
	(* designate placements for reagents loaded on the instrument *)
	exportedInstrumentPressureCapPlacements = {
		{Download[conditioningAcid,Object],{"P1 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
		{Download[conditioningBase,Object],{"P2 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
		{Download[conditioningWashSolution,Object],{"P3 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
		{Download[separationMatrix,Object],{"P4 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
		{Download[systemWashSolution[[1]],Object],{"P5 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
		{Download[placeholderContainer,Object],{"P6 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}}
	};

	(* designate placements for reagents loaded on the instrument *)
	exportedInstrumentPlacements = {
		{Download[systemWashSolution[[2]],Object], {"N1 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
		{Download[systemWashSolution[[3]],Object],{"N2 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}},
		{Download[bottomRunningBuffer,Object],{"N4 Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}}
	};

	(* designate placement for the cartridge loaded on the instrument *)
	exportedCartridgePlacement = {{Download[cartridge,Object], {"Cartridge Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}}};

	(* designate placement for the assay plate loaded on the instrument *)
	(* taking the last because if we incubate or spin, there would be two plates here, the first is a prep plate and the second is teh assay plate *)
	exportedAssayPlatePlacement = {{Download[assayPlate,Object],{"Plate Slot", Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"]}}};

	(* Collate all placements to two lists for UploadLocation *)
	{objectsToMove, destinations} = Transpose[Flatten[
			{
				exportedInstrumentPressureCapPlacements,
				exportedInstrumentPlacements,
				exportedCartridgePlacement,
				exportedAssayPlatePlacement
			},1]];

	(* Upload new locations of all reagents to instrument *)
	locationPackets = UploadLocation[objectsToMove, destinations, Simulation->updatedSimulation, UpdatedBy->protocolObject, Upload->False];

	(* update Simulation *)
	updatedSimulation = UpdateSimulation[samplePrepSimulation,Simulation[locationPackets]];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
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



(* ::Subsection::Closed:: *)
(*Sister Functions*)


(* ::Subsection::Closed:: *)
(*ExperimentCapillaryGelElectrophoresisSDSOptions*)

DefineOptions[ExperimentCapillaryGelElectrophoresisSDSOptions,
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
	SharedOptions:>{ExperimentCapillaryGelElectrophoresisSDS}
];


(*---Main function accepting sample/container objects as sample inputs and sample objects or Nulls as primer pair inputs---*)
ExperimentCapillaryGelElectrophoresisSDSOptions[
	mySamples:ListableP[ObjectP[Object[Container]]]|ListableP[(ObjectP[Object[Sample]]|_String)],
	myOptions:OptionsPattern[ExperimentCapillaryGelElectrophoresisSDSOptions]
]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentCapillaryGelElectrophoresisSDS[mySamples,preparedOptions];

	(* If options fail, return failure *)
	If[MatchQ[resolvedOptions,$Failed],
		Return[$Failed]
	];

	(*Return the option as a list or table*)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentCapillaryGelElectrophoresisSDS],
		resolvedOptions
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentCapillaryGelElectrophoresisSDSQ*)

DefineOptions[ValidExperimentCapillaryGelElectrophoresisSDSQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{ExperimentCapillaryGelElectrophoresisSDS}
];

ValidExperimentCapillaryGelElectrophoresisSDSQ[mySamples:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[ValidExperimentCapillaryGelElectrophoresisSDSQ]]:=Module[
	{listedOptions,preparedOptions,capillaryGelElectrophoresisSDSTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for ExperimentCapillaryGelElectrophoresisSDS *)
	capillaryGelElectrophoresisSDSTests=ExperimentCapillaryGelElectrophoresisSDS[mySamples,Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails).";

	(*Make a list of all of the tests, including the blanket test *)
	allTests=If[MatchQ[capillaryGelElectrophoresisSDSTests,$Failed],
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
			Flatten[{initialTest,capillaryGelElectrophoresisSDSTests,voqWarnings}]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentCapillaryGelElectrophoresisSDSQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentCapillaryGelElectrophoresisSDSQ"]

];


(* ::Subsection:: *)
(*ExperimentCapillaryGelElectrophoresisSDSPreview*)

DefineOptions[ExperimentCapillaryGelElectrophoresisSDSPreview,
	SharedOptions:>{ExperimentCapillaryGelElectrophoresisSDS}
];

ExperimentCapillaryGelElectrophoresisSDSPreview[mySamples:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[ExperimentCapillaryGelElectrophoresisSDSPreview]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentCapillaryGelElectrophoresisSDS[mySamples,ReplaceRule[listedOptions,Output->Preview]]
];


(* ::Subsection:: *)
(* ProteinCapillaryElectrophoresis Helper Functions *)

(* helper function to insert objects in specific locations *)
multipleInsertByPosition[inputList_, elementsToAdd_, positionToAdd_] :=
	Module[{expandedList = Riffle[inputList, 0, {1, -1, 2}], extendedPositions = positionToAdd*2 - 1},
		expandedList[[extendedPositions]] = elementsToAdd;
		expandedList[[Sort[Join[extendedPositions, Range[2, 2*Length@inputList, 2]]]]]];

(* Function to recursively add samples to injection list according to frequency and number of replicates *)
(*Base Case*)
populateInjectionTableHelper[itemObjectList:{},parentList:{{_,ObjectP[],VolumeP,_Integer} ..}|{_,ObjectP[],VolumeP,_Integer},
	includeItem:BooleanP,itemFrequency_List,itemReplicates_Integer]:=parentList;

(*inductive case*)
populateInjectionTableHelper[itemObjectList:{{_,ObjectP[],VolumeP,_Integer} ..}|{_,ObjectP[],VolumeP,_Integer},parentList:{{_,ObjectP[],VolumeP,_Integer} ...}|{_,ObjectP[],VolumeP,_Integer},
	includeItem:BooleanP,itemFrequency_List,itemReplicates_Integer]:=
	Module[{resultList,outputList,objectVolumeTuples},
		objectVolumeTuples = If[Depth[itemObjectList]<3,
			{itemObjectList},
			itemObjectList
		];

		resultList=
			If[includeItem,
				Which[MatchQ[Last[ToList[itemFrequency]],First],
					Prepend[parentList,ConstantArray[Last[objectVolumeTuples],itemReplicates]],
					MatchQ[Last[ToList[itemFrequency]],Last],
					Append[parentList,ConstantArray[Last[objectVolumeTuples],itemReplicates]],
					MatchQ[Last[ToList[itemFrequency]],FirstAndLast],
					Append[
						Prepend[parentList,ConstantArray[Last[objectVolumeTuples],itemReplicates]],
						ConstantArray[Last[ToList[objectVolumeTuples]],itemReplicates]],
					(*if an integer is passed,Riffle the list of items into the parent list*)
					MatchQ[Last[ToList[itemFrequency]],_Integer],
					(* in this case we have to make sure this is matched to samples and not to all samples *)
					Module[{samplePositionsToInsert},
						(* get positions of Samples in the parent list every itemFrequency'th Sample, add +Last[itemFrequency] so that it comes after the n'th sample *)
						samplePositionsToInsert = Flatten[Position[parentList, {Sample, _, _, _}][[ ;; ;; Last[itemFrequency]]]]+Last[itemFrequency];
						(* now we can insert multiple objects in multiple positions this list, so that new additions are  *)
						multipleInsertByPosition[
							parentList,
							ConstantArray[Last[objectVolumeTuples],Length[samplePositionsToInsert]],
							samplePositionsToInsert
						]
					]
				],
				parentList];
		(* flatten the list and restructure it to be {type, object}.. *)
		outputList=
			TakeList[Flatten[resultList],
				ConstantArray[4,Length[Flatten[resultList]]/4]];
		(* recursively iterate over items to add *)
		Return[populateInjectionTableHelper[Most[objectVolumeTuples],
			outputList,includeItem,Most[ToList[itemFrequency]],
			itemReplicates]]];

(* main function *)
populateInjectionTable[sampleType_,itemObjectList:{ObjectP[] ..}|ObjectP[], volumes:{VolumeP...},parentList:{{_,ObjectP[],VolumeP,_Integer} ..}|{_,ObjectP[],VolumeP,_Integer},
	includeItem:BooleanP,itemFrequency_List,itemReplicates_Integer]:=
	(* add sample type and call helper function to recurse over items to be adeded *)
	Module[{ObjectVolumeTuples},
		ObjectVolumeTuples=MapThread[
			Function[{object,volume,index},{sampleType,object,volume, index}],
			{
				itemObjectList,
				If[MatchQ[volumes, {}],
					(* when volumes are not informed, something is up. just treat as a replicate *)
					ConstantArray[0Microliter,Length[itemObjectList]],
					volumes
				],
				Range[Length[itemObjectList]]
			}
		];

		populateInjectionTableHelper[ObjectVolumeTuples,parentList,includeItem,
			itemFrequency,itemReplicates]
	];

(* overload for empty input *)
populateInjectionTable[sampleType_,itemObjectList:{}, volumes:{},parentList:{{_,ObjectP[],VolumeP,_Integer} ..}|{_,ObjectP[],VolumeP,_Integer},
	includeItem:BooleanP,itemFrequency_List,itemReplicates_Integer]:=parentList;

(* for cases where the injection table has been specified with Automatic volumes, we need to populate them - which is conveniently enough what the following function does (recursively) *)
(* Base case *)
replaceAutomaticVolumes[injectionTable:{{_,ObjectP[],VolumeP|Automatic, _Integer}},updatedInjectionTable:{{_,ObjectP[],VolumeP, _Integer}..},sampleVolumes_List,standardVolumes_List,blankVolumes_List,ladderVolumes_List]:=
	Module[{output,currentObject},
		(* grab the first item in the injection table, check it's identity, compare volumes and populate the injection table if needed *)
		(* Also, we need to make sure we pass the right volumes on, trimming the one we just used *)
		currentObject=First[injectionTable];

		output = Switch[currentObject[[1]],
			Sample,
			If[MatchQ[currentObject[[3]], Automatic|Null]||First[sampleVolumes]!=currentObject[[3]],
				{currentObject[[1]], currentObject[[2]], First[sampleVolumes], currentObject[[4]]},
				currentObject
			],
			Standard,
			If[MatchQ[currentObject[[3]], Automatic|Null]||First[standardVolumes]!=currentObject[[3]],
				{currentObject[[1]], currentObject[[2]], First[standardVolumes], currentObject[[4]]},
				currentObject
			],
			Ladder,
			If[MatchQ[currentObject[[3]], Automatic|Null]||First[ladderVolumes]!=currentObject[[3]],
				{currentObject[[1]], currentObject[[2]], First[ladderVolumes], currentObject[[4]]},
				currentObject
			],
			Blank,
			If[MatchQ[currentObject[[3]], Automatic|Null]||First[blankVolumes]!=currentObject[[3]],
				{currentObject[[1]], currentObject[[2]], First[blankVolumes], currentObject[[4]]},
				currentObject
			]];

		Append[updatedInjectionTable,output]
	];

(*inductiveCase *)
replaceAutomaticVolumes[injectionTable:{{_,ObjectP[],VolumeP|Automatic,_Integer}..}, updatedInjectionTable:{{_,ObjectP[],VolumeP,_Integer}...}, sampleVolumes_List, standardVolumes_List, blankVolumes_List, ladderVolumes_List]:=
	Module[{sample, standard, blank, ladder, output,currentObject},
		(* grab the first item in the injection table, check it's identity, compare volumes and populate the injection table if needed *)
		(* Also, we need to make sure we pass the right volumes on, trimming the one we just used *)
		currentObject=If[Depth[injectionTable]<4,
			(* in the last object of the list, its depth is 3, in which case we should just take that whole object *)
			injectionTable,
			First[injectionTable]
		];
		{output,sample, standard, blank, ladder} = Switch[currentObject[[1]],
			Sample,
			If[MatchQ[currentObject[[3]], Automatic|Null]||First[sampleVolumes]!=currentObject[[3]],
				{{currentObject[[1]], currentObject[[2]], First[sampleVolumes], currentObject[[4]]},Rest[sampleVolumes],standardVolumes,blankVolumes,ladderVolumes},
				{currentObject,Rest[sampleVolumes],standardVolumes,blankVolumes,ladderVolumes}
			],
			Ladder,
			If[MatchQ[currentObject[[3]], Automatic|Null]||First[ladderVolumes]!=currentObject[[3]],
				{{currentObject[[1]], currentObject[[2]], First[ladderVolumes], currentObject[[4]]},sampleVolumes,Rest[ladderVolumes],blankVolumes,ladderVolumes},
				{currentObject,sampleVolumes,standardVolumes,blankVolumes, Rest[ladderVolumes]}
			],
			Standard,
			If[MatchQ[currentObject[[3]], Automatic|Null]||First[standardVolumes]!=currentObject[[3]],
				{{currentObject[[1]], currentObject[[2]], First[standardVolumes], currentObject[[4]]},sampleVolumes,Rest[standardVolumes],blankVolumes,ladderVolumes},
				{currentObject,sampleVolumes,Rest[standardVolumes],blankVolumes,ladderVolumes}
			],
			Blank,
			If[MatchQ[currentObject[[3]], Automatic|Null]||First[blankVolumes]!=currentObject[[3]],
				{{currentObject[[1]], currentObject[[2]], First[blankVolumes], currentObject[[4]]},sampleVolumes,standardVolumes,Rest[blankVolumes],ladderVolumes},
				{currentObject,sampleVolumes,standardVolumes,Rest[blankVolumes],ladderVolumes}
			]];

		(* next, we run another round, until we get to the very end *)
		replaceAutomaticVolumes[Rest[injectionTable], Append[updatedInjectionTable, output], ToList[sample], ToList[standard], ToList[blank], ToList[ladder]]
	];

(* the three helper functions below really belong in InternalExperiment. They were migrated here to facilitate simulation (as InternalExperiment is not loaded on CC *)
(* ::Subsubsection::Closed:: *)
(*updateCEInjectionTable*)

DefineOptions[
	updateCEInjectionTable,
	Options:>{CacheOption}
];

(*this is a helper function to generate the InjectionTable with all of the protocol related parameters. Based on a similar function in ExperimentHPLC compiler *)
updateCEInjectionTable[
	myProtocolPacket:PacketP[{Object[Protocol, CapillaryGelElectrophoresisSDS],	Object[Protocol, CapillaryIsoelectricFocusing]}],
	myWorkingSamples:{ObjectP[Object[Sample]]..},
	myWorkingLadders:{ObjectP[Object[Sample]]...},
	myWorkingStandards:{ObjectP[Object[Sample]]...},
	myWorkingBlanks:{ObjectP[Object[Sample]]...},
	myOptions:OptionsPattern[]]:=Module[
	{
		injectionTable,injectionTableExtended,sampleInjectionPositions,updatedSampleTuples,ladderInjectionPositions,
		updatedLadderTuples,standardInjectionPositions,updatedStandardTuples,blankInjectionPositions,
		updatedBlankTuples,optionMappingTable,injectionTableWithOptions
	},

	(*first, we need to add the positional information so that it's easy to correspond the detection parameters*)
	injectionTable = Lookup[myProtocolPacket,InjectionTable];

	(* strip Sample id links to make it easier to identify sample objects *)
	injectionTableExtended=Append[#, Sample -> Download[#[Sample], Object]] & /@injectionTable;

	(*for all the sample positions. should be directly index matched to the input samples*)
	sampleInjectionPositions=Flatten@Position[injectionTableExtended,KeyValuePattern[Type->Sample]];

	(*update the tuples with the index information*)
	updatedSampleTuples =MapThread[Merge[{#1,<|Index->#2|>},First]&,{injectionTableExtended[[sampleInjectionPositions]],Range[Length[sampleInjectionPositions]]}];

	injectionTableExtended[[sampleInjectionPositions]]=updatedSampleTuples;

	(*for all the ladder positions. should be directly index matched to the input samples*)
	ladderInjectionPositions=Flatten@Position[injectionTableExtended,KeyValuePattern[Type->Ladder]];

	(*update the tuples with the index information*)
	updatedLadderTuples =MapThread[Merge[{#1,<|Index->#2|>},First]&,{injectionTableExtended[[ladderInjectionPositions]],Range[Length[ladderInjectionPositions]]}];

	injectionTableExtended[[ladderInjectionPositions]]=updatedLadderTuples;

	(*for all the standard positions. should be directly index matched to the input samples*)
	standardInjectionPositions=Flatten@Position[injectionTableExtended,KeyValuePattern[Type->Standard]];

	(*update the tuples with the index information*)
	updatedStandardTuples =	MapThread[Merge[{#1,<|Index->#2|>},First]&,{injectionTableExtended[[standardInjectionPositions]],Range[Length[standardInjectionPositions]]}];

	injectionTableExtended[[standardInjectionPositions]]=updatedStandardTuples;

	(*for all the standard positions. should be directly index matched to the input samples*)
	blankInjectionPositions= Flatten@Position[injectionTableExtended,KeyValuePattern[Type->Blank]];

	(*update the tuples with the index information*)
	updatedBlankTuples = MapThread[Merge[{#1,<|Index->#2|>},First]&,{injectionTableExtended[[blankInjectionPositions]],Range[Length[blankInjectionPositions]]}];

	injectionTableExtended[[blankInjectionPositions]]=updatedBlankTuples;

	(*we then need to populate method fields based on the protocol we are running. *)
	optionMappingTable=Switch[myProtocolPacket[Type],
		Object[Protocol, CapillaryIsoelectricFocusing],
		{
			<|Sample->LoadTimes,Blank->BlankLoadTimes,Standard->StandardLoadTimes|>,
			<|Sample->VoltageDurationProfiles,Blank->BlankVoltageDurationProfiles,Standard->StandardVoltageDurationProfiles|>,
			<|Sample->NativeFluorescenceExposureTimes,Blank->BlankNativeFluorescenceExposureTimes,Standard->StandardNativeFluorescenceExposureTimes|>,
			<|Sample->TotalVolumes,Blank->BlankTotalVolumes,Standard->StandardTotalVolumes|>,
			<|Sample->SampleVolumes,Blank->BlankVolumes,Standard->StandardVolumes|>,
			<|Sample->PremadeMasterMixReagents,Blank->BlankPremadeMasterMixReagents,Standard->StandardPremadeMasterMixReagents|>,
			<|Sample->PremadeMasterMixVolumes,Blank->BlankPremadeMasterMixVolumes,Standard->StandardPremadeMasterMixVolumes|>,
			<|Sample->PremadeMasterMixDiluents,Blank->BlankPremadeMasterMixDiluents,Standard->StandardPremadeMasterMixDiluents|>,
			<|Sample->DenaturationReagents,Blank->BlankDenaturationReagents,Standard->StandardDenaturationReagents|>,
			<|Sample->DenaturationReagentVolumes,Blank->BlankDenaturationReagentVolumes,Standard->StandardDenaturationReagentVolumes|>,
			<|Sample->IsoelectricPointMarkers,Blank->BlankIsoelectricPointMarkers,Standard->StandardIsoelectricPointMarkers|>,
			<|Sample->IsoelectricPointMarkersVolumes,Blank->BlankIsoelectricPointMarkersVolumes,Standard->StandardIsoelectricPointMarkersVolumes|>,
			<|Sample->Ampholytes,Blank->BlankAmpholytes,Standard->StandardAmpholytes|>,
			<|Sample->AmpholyteVolumes,Blank->BlankAmpholyteVolumes,Standard->StandardAmpholyteVolumes|>,
			<|Sample->AnodicSpacers,Blank->BlankAnodicSpacers,Standard->StandardAnodicSpacers|>,
			<|Sample->AnodicSpacerVolumes,Blank->BlankAnodicSpacerVolumes,Standard->StandardAnodicSpacerVolumes|>,
			<|Sample->CathodicSpacers,Blank->BlankCathodicSpacers,Standard->StandardCathodicSpacers|>,
			<|Sample->CathodicSpacerVolumes,Blank->BlankCathodicSpacerVolumes,Standard->StandardCathodicSpacerVolumes|>,
			<|Sample->ElectroosmoticFlowBlockers,Blank->BlankElectroosmoticFlowBlockers,Standard->StandardElectroosmoticFlowBlockers|>,
			<|Sample->ElectroosmoticFlowBlockerVolumes,Blank->BlankElectroosmoticFlowBlockerVolumes,Standard->StandardElectroosmoticFlowBlockerVolumes|>,
			<|Sample->Diluents,Blank->BlankDiluents,Standard->StandardDiluents|>
		},
		Object[Protocol, CapillaryGelElectrophoresisSDS],
		{
			<|Sample->InjectionVoltageDurationProfiles,Blank->BlankInjectionVoltageDurationProfiles,Standard->StandardInjectionVoltageDurationProfiles,Ladder->LadderInjectionVoltageDurationProfiles|>,
			<|Sample->SeparationVoltageDurationProfiles,Blank->BlankSeparationVoltageDurationProfiles,Standard->StandardSeparationVoltageDurationProfiles,Ladder->LadderSeparationVoltageDurationProfiles|>,
			<|Sample->TotalVolumes,Blank->BlankTotalVolumes,Standard->StandardTotalVolumes,Ladder->LadderTotalVolumes|>,
			<|Sample->SampleVolumes,Blank->BlankVolumes,Standard->StandardVolumes,Ladder->LadderVolumes|>,
			<|Sample->PremadeMasterMixReagents,Blank->BlankPremadeMasterMixReagents,Standard->StandardPremadeMasterMixReagents,Ladder->LadderPremadeMasterMixReagents|>,
			<|Sample->PremadeMasterMixVolumes,Blank->BlankPremadeMasterMixVolumes,Standard->StandardPremadeMasterMixVolumes,Ladder->LadderPremadeMasterMixVolumes|>,
			<|Sample->PremadeMasterMixDiluents,Blank->BlankPremadeMasterMixDiluents,Standard->StandardPremadeMasterMixDiluents,Ladder->LadderPremadeMasterMixDiluents|>,
			<|Sample->InternalReferences,Blank->BlankInternalReferences,Standard->StandardInternalReferences,Ladder->LadderInternalReferences|>,
			<|Sample->InternalReferenceVolumes,Blank->BlankInternalReferenceVolumes,Standard->StandardInternalReferenceVolumes,Ladder->LadderInternalReferenceVolumes|>,
			<|Sample->ConcentratedSDSBuffers,Blank->BlankConcentratedSDSBuffers,Standard->StandardConcentratedSDSBuffers,Ladder->LadderConcentratedSDSBuffers|>,
			<|Sample->ConcentratedSDSBufferVolumes,Blank->BlankConcentratedSDSBufferVolumes,Standard->StandardConcentratedSDSBufferVolumes,Ladder->LadderConcentratedSDSBufferVolumes|>,
			<|Sample->SDSBuffers,Blank->BlankSDSBuffers,Standard->StandardSDSBuffers,Ladder->LadderSDSBuffers|>,
			<|Sample->SDSBufferVolumes,Blank->BlankSDSBufferVolumes,Standard->StandardSDSBufferVolumes,Ladder->LadderSDSBufferVolumes|>,
			<|Sample->ReducingAgents,Blank->BlankReducingAgents,Standard->StandardReducingAgents,Ladder->LadderReducingAgents|>,
			<|Sample->ReducingAgentVolumes,Blank->BlankReducingAgentVolumes,Standard->StandardReducingAgentVolumes,Ladder->LadderReducingAgentVolumes|>,
			<|Sample->AlkylatingAgents,Blank->BlankAlkylatingAgents,Standard->StandardAlkylatingAgents,Ladder->LadderAlkylatingAgents|>,
			<|Sample->AlkylatingAgentVolumes,Blank->BlankAlkylatingAgentVolumes,Standard->StandardAlkylatingAgentVolumes,Ladder->LadderAlkylatingAgentVolumes|>,
			<|Sample->Diluents,Blank->BlankDiluents,Standard->StandardDiluents,Ladder->LadderDiluents|>,
			<|Sample->DenaturingTemperatures,Blank->BlankDenaturingTemperatures,Standard->StandardDenaturingTemperatures,Ladder->LadderDenaturingTemperatures|>,
			<|Sample->DenaturingTimes,Blank->BlankDenaturingTimes,Standard->StandardDenaturingTimes,Ladder->LadderDenaturingTimes|>,
			<|Sample->SedimentationSupernatantVolumes,Blank->BlankSedimentationSupernatantVolumes,Standard->StandardSedimentationSupernatantVolumes,Ladder->LadderSedimentationSupernatantVolumes|>
		}
	];

	(*now we map through the injectionTable combine with the new optionMappingTable*)
	injectionTableWithOptions=Map[
		Function[{currentAssociation},
			Module[
				{
					currentType,associationToMerge,fieldToRetrieve,parametersDownloaded,parameterAdd, injectedSample,
					associationWithWorkingSample
				},
				(* Get the type to populate with other fields (e.g. Sample, Blank, etc, *)
				currentType=Lookup[currentAssociation, Type];
				(* Export functions based on their index *)
				associationToMerge=Association@Map[(
					fieldToRetrieve=(currentType /. #);
					(* Retreive the field thats relevant for this type (and avoid empty lists) *)
					parametersDownloaded=Lookup[myProtocolPacket,fieldToRetrieve, Null] /. {}:> Null;
					(* Get the index matched value *)
					parameterAdd=If[ListQ[parametersDownloaded],
						(* If not an empty list, grab value based on index*)
						Switch[currentType,
							Sample,	parametersDownloaded[[Lookup[currentAssociation,Index]]],
							Except[Sample], parametersDownloaded[[Lookup[currentAssociation,SampleIndex]]]
						],
						Null
					];
					(* Make the key value association *)
					Lookup[#,Sample]->parameterAdd
				)&,
					optionMappingTable
				];

				(* Replace samples/standards/blanks/ladders with the actual ones from WorkingSamples or resources picked by model *)
				injectedSample = Switch[currentType,
					Sample,myWorkingSamples[[Lookup[currentAssociation,Index]]],
					Standard,myWorkingStandards[[Lookup[currentAssociation,SampleIndex]]],
					Blank,myWorkingBlanks[[Lookup[currentAssociation,SampleIndex]]],
					Ladder,myWorkingLadders[[Lookup[currentAssociation,SampleIndex]]]];

				associationWithWorkingSample = Append[associationToMerge, <|WorkingSample->injectedSample|>];

				(*merge into the current association*)
				Merge[{currentAssociation,associationWithWorkingSample},First]
			]],injectionTableExtended]
];

(* ::Subsubsection::Closed:: *)
(*assignCEPlateWell*)
assignCEPlateWell[
	myProtocolPacket:PacketP[{Object[Protocol, CapillaryGelElectrophoresisSDS],	Object[Protocol, CapillaryIsoelectricFocusing]}],
	myInjectionTable:{_Association..}
]:=Module[
	{
		samplePositions,repeatedSamplesPos,repeatedSamplesPosAdjustedPosition,positionedSamples,lastPosition,repeatedSamples,
		groupedByposition, repeatedElementsGroupedByPosition,repeatedPositionsGroupedByPosition, numOfReplicates
	},
	(* get number of replicates *)
	numOfReplicates = Lookup[myProtocolPacket, NumberOfReplicates];

	(* First, get positions of true samples and repeated injections *)
	samplePositions = Flatten@Position[myInjectionTable, KeyValuePattern[Volume -> GreaterP[0 Microliter]]];

	(* repeated injections would have a volume = 0 Microliter, so we can pull those out *)
	repeatedSamplesPos = Flatten@Position[myInjectionTable,KeyValuePattern[Volume -> EqualP[0 Microliter]]];

	(* Next, to make sure we know where to put them back, we need to adjust their positions by index *)
	repeatedSamplesPosAdjustedPosition = MapIndexed[#1 - First@#2 &, repeatedSamplesPos];

	(* Now we can allocate a well for each true sample *)
	positionedSamples = MapIndexed[
		Function[{association, index},
			Append[association, {Well -> ConvertWell[First@index], Position->samplePositions[[First@index]]}]
		],
		myInjectionTable[[samplePositions]]
	];

	(* To assign a well for repeated injections, we need to identify a well that is identical to this one in positionedSamples
	from all but the separation conditions (if there are multiple ones, pick the one which has a smaller position. *)

	repeatedSamples = MapThread[
		Function[{repeat,position},
			Module[{sameTypePositions, precedingPosition, precedingElementWellDesignation},
				(* to help make the association a pattern, we will take the relevant keys and convert them to a list of rules *)
				sameTypePositions =	Cases[positionedSamples,KeyValuePattern[Type -> repeat[Type]]];

				(* get the index of the preceding true sample of the same type *)
				precedingPosition = Last[Cases[Lookup[sameTypePositions,Position], _?(#<position&)]];

				(* get the Well in the injectionTable entry for the preceding sample based on its position *)
				precedingElementWellDesignation = Last@Lookup[Cases[positionedSamples,KeyValuePattern[Position -> precedingPosition]],Well];
				(* add the correct well to the repeated sample *)
				Append[repeat, {Well -> precedingElementWellDesignation}]

			]],
		{myInjectionTable[[repeatedSamplesPos]],repeatedSamplesPos}
	];

	(* And, finally, we can insert those back to the injectionTable, without an allocated position (reminder, adding to position+1 because
	we want them *After* that position *)
	Flatten@multipleInsertByPosition[positionedSamples, repeatedSamples, repeatedSamplesPosAdjustedPosition + 1]
];

(* ::Subsubsection::Closed:: *)
(*multipleInsertByPosition*)

(* helper function to insert objects in specific locations (thanks StackExchange!) *)
multipleInsertByPosition[
	inputList_,
	elementsToAdd_,
	positionToAdd_
] :=
	Module[{expandedList = Riffle[inputList, 0, {1, -1, 2}], extendedPositions = positionToAdd*2 - 1},
		expandedList[[extendedPositions]] = elementsToAdd;
		expandedList[[Sort[Join[extendedPositions, Range[2, 2*Length@inputList, 2]]]]]];