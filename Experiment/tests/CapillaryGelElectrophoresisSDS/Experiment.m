(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentCapillaryGelElectrophoresisSDS*)

DefineTests[ExperimentCapillaryGelElectrophoresisSDS,
	{
		Example[
			{Basic,"Generates and returns a protocol object when given samples:"},
			ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]}],
			ObjectP[Object[Protocol, CapillaryGelElectrophoresisSDS]]
		],
		Example[
			{Basic,"Generates and returns a protocol object when given an unlisted sample:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID]],
			ObjectP[Object[Protocol, CapillaryGelElectrophoresisSDS]]
		],
		Example[
			{Basic,"Generates and returns a protocol object when given a Model-less sample:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test model-less sample 1 (100 uL) "<>$SessionUUID]],
			ObjectP[Object[Protocol, CapillaryGelElectrophoresisSDS]]
		],
		Example[
			{Additional,"Input as {Position,Container}:"},
			ExperimentCapillaryGelElectrophoresisSDS[{"A1",Object[Container,Plate,"Unit Test container for reagents in ExperimentCESDS tests "<>$SessionUUID]}],
			ObjectP[Object[Protocol, CapillaryGelElectrophoresisSDS]],
			Messages:>{Warning::MissingSampleComposition}
		],
		Example[
			{Additional,"Input as a mixture of all kinds of sample types: "},
			ExperimentCapillaryGelElectrophoresisSDS[
				{
					{"A1", Object[Container, Plate, "Unit Test container for reagents in ExperimentCESDS tests "<>$SessionUUID]},
					{"B1", Object[Container, Plate, "Unit Test container for reagents in ExperimentCESDS tests "<>$SessionUUID]},
					Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol, CapillaryGelElectrophoresisSDS]],
			Messages:>{Warning::MissingSampleComposition}
		],
		(* --- OptionTests --- *)
		Example[
			{Options,Instrument,"Specify the capillary electrophoresis instrument that will be used by the protocol:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Instrument->Model[Instrument,ProteinCapillaryElectrophoresis,"Maurice"],
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectReferenceP[Model[Instrument,ProteinCapillaryElectrophoresis,"Maurice"]],
			Variables:>{options}
		],
		Example[
			{Options,Cartridge,"Specify the capillary electrophoresis cartridge Model loaded on the instrument for Capillary gel Electrophoresis-SDS:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Cartridge->Model[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus"],
				Output->Options
			];
			Lookup[options,Cartridge],
			ObjectReferenceP[Model[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus"]],
			Variables:>{options}
		],
		Example[
			{Options,Cartridge,"Specify the capillary electrophoresis cartridge Object loaded on the instrument for Capillary gel Electrophoresis- SDS (CESDS) experiments. The cartridge holds a single capillary and the anode's running buffer. CESDS cartridges can run 100 injections in up to 25 batches under optimal conditions, and up to 200 or 500 injections in total for CESDS and CE-SDS cartridges, respectively:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Cartridge->Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ExperimentCESDS "<>$SessionUUID],
				Output->Options
			];
			Lookup[options,Cartridge],
			ObjectReferenceP[Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ExperimentCESDS "<>$SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,PurgeCartridge,"Specify whether the capillary electrophoresis cartridge Object should be purged before the experiment is run. The instrument prompts when a purge is required (e.g., after 3 months of no use) and the user can either specify to purge, purge if required, or not to purge. Note that a purge is counted towards the batch limit of the cartridge:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PurgeCartridge->IfRequired,
				Output->Options
			];
			Lookup[options,PurgeCartridge],
			IfRequired,
			Variables:>{options}
		],
		Example[
			{Options,SampleTemperature,"Specify the sample tray temperature at which samples are maintained while awaiting injection:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SampleTemperature->Ambient,
				Output->Options
			];
			Lookup[options,SampleTemperature],
			Ambient,
			Variables:>{options}
		],
		Example[
			{Options,TotalVolume,"Specify the final volume in the assay tube prior to loading onto AssayContainer:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				TotalVolume->70 Microliter,
				Output->Options
			];
			Lookup[options,TotalVolume],
			70 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,NumberOfReplicates,"Specify the number of times each sample will be injected:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				NumberOfReplicates->3,
				Output->Options
			];
			Lookup[options,NumberOfReplicates],
			3,
			Variables:>{options}
		],
		Example[{Options,InjectionTable,"Specify the order of sample, Ladder, Standard, and Blank samples loading and populate Blanks/Ladders/Standards accordingly:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID],
				Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID]},
				InjectionTable->{{Ladder,Model[Sample, "Unstained Protein Standard"],10Microliter},
					{Sample,Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],10Microliter},
					{Sample,Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID],5Microliter},
					{Ladder,Model[Sample, "Unstained Protein Standard"],10Microliter}},
				Output->Options];
			Lookup[options,Ladders],
			ObjectReferenceP[Model[Sample, "Unstained Protein Standard"]],
			Variables:>{options}
		],
		Example[{Options,InjectionTable,"Infer the order of sample, Ladder, Standard, and Blank sample loading based on Samples/Blanks/Ladders/Standards and their frequency:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID],
				Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID]},
				InjectionTable->Automatic,
				Ladders->Model[Sample, "Unstained Protein Standard"],LadderFrequency->Last,
				Blanks->Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],BlankFrequency->FirstAndLast,
				SampleVolume->4Microliter,
				BlankVolume->{10Microliter, 5Microliter},
				LadderVolume->5Microliter,
				Output->Options];
			Lookup[options,InjectionTable],
			{
				{Blank, ObjectReferenceP[Model[Sample, "1% SDS in 100mM Tris, pH 9.5"]],10Microliter},
				{Blank,	ObjectReferenceP[Model[Sample, "1% SDS in 100mM Tris, pH 9.5"]], 5Microliter},
				{Sample,ObjectReferenceP[Object[Sample, "ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]],4Microliter},
				{Sample,ObjectReferenceP[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID]],4Microliter},
				{Blank,	ObjectReferenceP[Model[Sample, "1% SDS in 100mM Tris, pH 9.5"]],5Microliter},
				{Blank,	ObjectReferenceP[Model[Sample, "1% SDS in 100mM Tris, pH 9.5"]],10Microliter},
				{Ladder,ObjectReferenceP[Model[Sample, "Unstained Protein Standard"]],5Microliter}
			},
			Variables:>{options}
		],
		Example[
			{Options,ConditioningAcid,"Specify the Conditioning Acid solution:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConditioningAcid->Model[Sample,"CESDS Conditioning Acid"],
				Output->Options
			];
			Lookup[options,ConditioningAcid],
			ObjectReferenceP[Model[Sample,"CESDS Conditioning Acid"]],
			Variables:>{options}
		],
		Example[
			{Options,ConditioningBase,"Specify the Conditioning Base solution:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConditioningBase->Model[Sample,"CESDS Conditioning Base"],
				Output->Options
			];
			Lookup[options,ConditioningBase],
			ObjectReferenceP[Model[Sample,"CESDS Conditioning Base"]],
			Variables:>{options}
		],
		Example[
			{Options,ConditioningWashSolution,"Specify the solution used to wash the capillary:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConditioningWashSolution->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,ConditioningWashSolution],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,SeparationMatrix,"Specify the sieving matrix loaded onto the capillary for separation:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SeparationMatrix->Model[Sample,"CESDS Separation Matrix"],
				Output->Options
			];
			Lookup[options,SeparationMatrix],
			ObjectReferenceP[Model[Sample,"CESDS Separation Matrix"]],
			Variables:>{options}
		],
		Example[
			{Options,SystemWashSolution,"Specify the solution used to wash the capillary after conditioning and, separately, rinse the tip before every injection:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SystemWashSolution->Model[Sample,"CESDS Wash Solution"],
				Output->Options
			];
			Lookup[options,SystemWashSolution],
			ObjectReferenceP[Model[Sample,"CESDS Wash Solution"]],
			Variables:>{options}
		],
		Example[
			{Options,PlaceholderContainer,"Specify the PlaceholderContainer is an empty vial used to dry the capillary after wash:"},
			protocol=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PlaceholderContainer->Model[Container, Vessel, "Maurice Reagent Glass Vials, 2mL"]
			];
			Download[protocol,PlaceholderContainer[Object]],
			ObjectReferenceP[Model[Container, Vessel, "Maurice Reagent Glass Vials, 2mL"]],
			Variables:>{protocol}
		],
		Example[
			{Options,ConditioningAcidStorageCondition,"Specify the non-default storage condition for ConditioningAcid of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConditioningAcidStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,ConditioningAcidStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,ConditioningBaseStorageCondition,"Specify the non-default storage condition for ConditioningBase of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConditioningBaseStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,ConditioningBaseStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,SeparationMatrixStorageCondition,"Specify the non-default storage condition for SeparationMatrix of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SeparationMatrixStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SeparationMatrixStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,SystemWashSolutionStorageCondition,"Specify the non-default storage condition for SystemWashSolution of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SystemWashSolutionStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SystemWashSolutionStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,RunningBufferStorageCondition,"Specify the non-default storage condition for Bottom RunningBuffer of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				RunningBufferStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,RunningBufferStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,SampleVolume,"Specify the volume drawn from the sample to the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SampleVolume->10 Microliter,
				Output->Options
			];
			Lookup[options,SampleVolume],
			10 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,SampleVolume,"Specify the volume drawn from the sample to the assay tube as resolved from protein concentration in composition:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]},
				SampleVolume->Automatic,
				Output->Options
			];
			Lookup[options,SampleVolume],
			1. Microliter,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMix,"Specify if samples should be mixed with PremadeMasterMix that includes an SDS buffer, an internal standard, and reducing and / or alkylating agents:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMix->False,
				Output->Options
			];
			Lookup[options,PremadeMasterMix],
			False,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixReagent,"Specify the premade master mix object/model used for CESDS experiment:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
				Output->Options
			];
			Lookup[options,PremadeMasterMixReagent],
			ObjectReferenceP[Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixDiluent,"Specify the solution used to dilute the premade master mix to its working concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent " <>$SessionUUID],PremadeMasterMixDiluent->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,PremadeMasterMixDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixReagentDilutionFactor,"Specify the factor by which the premade mastermix should be diluted by in the final assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],PremadeMasterMixReagentDilutionFactor->2,
				Output->Options
			];
			Lookup[options,PremadeMasterMixReagentDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixReagentDilutionFactor,"Specify the factor by which the premade mastermix should be diluted and calculate the volume that should be added to the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],PremadeMasterMixReagentDilutionFactor->2,
				Output->Options
			];
			Lookup[options,PremadeMasterMixVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixVolume,"Specify the volume of the premade mastermix required to reach its final concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],PremadeMasterMixVolume->50 Microliter,
				Output->Options
			];
			Lookup[options,PremadeMasterMixVolume],
			50 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixVolume,"Specify the volume of the premade mastermix and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],PremadeMasterMixVolume->50 Microliter,
				Output->Options
			];
			Lookup[options,PremadeMasterMixReagentDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixStorageCondition,"Specify the non-default storage condition for PremadeMasterMix of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMixStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,PremadeMasterMixStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,InternalReference,"Specify the stock solution object/model containing the analyte serving as the internal standard:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				InternalReference->Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"],
				Output->Options
			];
			Lookup[options,InternalReference],
			ObjectReferenceP[Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"]],
			Variables:>{options}
		],
		Example[
			{Options,InternalReferenceDilutionFactor,"Specify Marks how concentrated the internal standard is:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				InternalReferenceDilutionFactor->25,
				Output->Options
			];
			Lookup[options,InternalReferenceDilutionFactor],
			25,
			Variables:>{options}
		],
		Example[
			{Options,InternalReferenceDilutionFactor,"Specify Marks how concentrated the internal standard is and calculate the volume required to reach 1X concentration in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				InternalReferenceDilutionFactor->25,
				Output->Options
			];
			Lookup[options,InternalReferenceVolume],
			4Microliter,
			Variables:>{options}
		],
		Example[
			{Options,InternalReferenceVolume,"Specify the volume of the internal standard added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				InternalReferenceVolume->5Microliter,
				Output->Options
			];
			Lookup[options,InternalReferenceVolume],
			5Microliter,
			Variables:>{options}
		],
		Example[
			{Options,InternalReferenceVolume,"Specify the volume of the internal standard added to each sample and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				InternalReferenceVolume->5Microliter,
				Output->Options
			];
			Lookup[options,InternalReferenceDilutionFactor],
			20,
			Variables:>{options}
		],
		Example[
			{Options,ConcentratedSDSBuffer,"Specify the SDS Buffer used to dilute the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConcentratedSDSBuffer->Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
				Output->Options
			];
			Lookup[options,ConcentratedSDSBuffer],
			ObjectReferenceP[Model[Sample,"1% SDS in 100mM Tris, pH 9.5"]],
			Variables:>{options}
		],
		Example[
			{Options,ConcentratedSDSBufferDilutionFactor,"Specify Marks how concentrated the SDS buffer is:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConcentratedSDSBufferDilutionFactor->2,
				Output->Options
			];
			Lookup[options,ConcentratedSDSBufferDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,ConcentratedSDSBufferDilutionFactor,"Specify Marks how concentrated the SDS buffer is and calculate the volume required to reach 1X in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConcentratedSDSBufferDilutionFactor->2,
				Output->Options
			];
			Lookup[options,ConcentratedSDSBufferVolume],
			50Microliter,
			Variables:>{options}
		],

		Example[
			{Options,Diluent,"Specify the solution used to dilute the ConcentratedSDSBuffer to working concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Diluent->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,Diluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,ConcentratedSDSBufferVolume,"Specify the volume of ConcentratedSDSBuffer added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConcentratedSDSBufferVolume->50Microliter,
				Output->Options
			];
			Lookup[options,ConcentratedSDSBufferVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,ConcentratedSDSBufferVolume,"Specify the volume of ConcentratedSDSBuffer added to each sample and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConcentratedSDSBufferVolume->50Microliter,
				Output->Options
			];
			Lookup[options,ConcentratedSDSBufferDilutionFactor],
			2.,
			Variables:>{options}
		],
		Example[
			{Options,SDSBuffer,"Specify the SDS Buffer used to dilute the sample. The final concentration of SDS in this assay must be equal or greater than 0.5%. If ConcentratedSDSBuffer is set to Null, SDSBuffer will be used to dilute the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SDSBuffer->Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
				Output->Options
			];
			Lookup[options,SDSBuffer],
			ObjectReferenceP[Model[Sample,"1% SDS in 100mM Tris, pH 9.5"]],
			Variables:>{options}
		],
		Example[
			{Options,SDSBufferVolume,"Specify the volume of SDSBuffer added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]},
				SDSBufferVolume->95Microliter,
				Output->Options
			];
			Lookup[options,SDSBufferVolume],
			95Microliter,
			Variables:>{options}
		],
		Example[
			{Options,SDSBufferVolume,"Specify the volume of SDSBuffer and ConcentratedSDSBuffer added to each sample and give priority to the ConcentratedSDS branch:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]},
				SDSBufferVolume->40Microliter,ConcentratedSDSBufferVolume->50Microliter,
				Output->Options
			];
			Lookup[options,SDSBuffer],
			Null,
			Variables:>{options},
			Messages:>{Warning::BothSDSBufferOptionsSet}
		],
		Example[
			{Options,Reduction,"Specify if disulfide bridges should be chemically reduced in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Reduction->True,
				Output->Options
			];
			Lookup[options,Reduction],
			True,
			Variables:>{options}
		],
		Example[
			{Options,ReducingAgent,"Specify the reducing agent used to reduce disulfide bridges in proteins to be added to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ReducingAgent->Model[Sample, "2-Mercaptoethanol"],
				Output->Options
			];
			Lookup[options,ReducingAgent],
			ObjectReferenceP[Model[Sample, "2-Mercaptoethanol"]],
			Variables:>{options}
		],
		Example[
			{Options,ReducingAgentTargetConcentration,"Specify the final concentration of the reducing agent in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ReducingAgentTargetConcentration->4.54545VolumePercent,
				Output->Options
			];
			Lookup[options,ReducingAgentTargetConcentration],
			4.54545VolumePercent,
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,ReducingAgentTargetConcentration,"Specify the final concentration of the reducing agent in the sample and calculate the required volume to reach that volume based on the concentration in the Reducing Agent Object:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ReducingAgentTargetConcentration->3.5VolumePercent,
				Output->Options
			];
			Lookup[options,ReducingAgentVolume],
			3.5Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,ReducingAgentVolume,"Specify the volume of the reducing agent required to reach its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ReducingAgentVolume->4.5Microliter,
				Output->Options
			];
			Lookup[options,ReducingAgentVolume],
			4.5Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,ReducingAgentVolume,"Specify the volume of the reducing agent and calculate its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ReducingAgentVolume->4.5Microliter,
				Output->Options
			];
			Lookup[options,ReducingAgentTargetConcentration],
			4.5VolumePercent,(* BME is in volume percent, this would be 0.6435 Molar if it were a Molar concentration *)
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,Alkylation,"Specify if Alkylation should be applied to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Alkylation->True,
				Output->Options
			];
			Lookup[options,Alkylation],
			True,
			Variables:>{options}
		],
		Example[
			{Options,AlkylatingAgent,"Specify the alkylating agent to be added to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AlkylatingAgent->Model[Sample, StockSolution,"250mM Iodoacetamide"],
				Output->Options
			];
			Lookup[options,AlkylatingAgent],
			ObjectReferenceP[Model[Sample, StockSolution,"250mM Iodoacetamide"]],
			Variables:>{options}
		],
		Example[
			{Options,AlkylatingAgentTargetConcentration,"Specify the final concentration of the alkylating agent in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AlkylatingAgentTargetConcentration->11.5Millimolar,
				Output->Options
			];
			Lookup[options,AlkylatingAgentTargetConcentration],
			11.5Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,AlkylatingAgentTargetConcentration,"Specify the final concentration of the alkylating agent in the sample and calculate the required volume to reach that concentration based on the alkylating agent object concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AlkylatingAgentTargetConcentration->11.5Millimolar,
				Output->Options
			];
			Lookup[options,AlkylatingAgentVolume],
			4.8 Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,AlkylatingAgentVolume,"Specify the volume of the alkylating agent required to reach its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AlkylatingAgentVolume->4.6 Microliter,
				Output->Options
			];
			Lookup[options,AlkylatingAgentVolume],
			4.6 Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,AlkylatingAgentVolume,"Specify the volume of the alkylating agent and calculate its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AlkylatingAgentVolume->4.6 Microliter,
				Output->Options
			];
			Lookup[options,AlkylatingAgentTargetConcentration],
			10.9358 Millimolar,
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,Denature,"Specify whether samples should be heated to in order to linearize proteins:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Denature->True,
				Output->Options
			];
			Lookup[options,Denature],
			True,
			Variables:>{options}
		],
		Example[
			{Options,DenaturingTemperature,"Specify the temperature to which samples will be heated to in order to linearize proteins:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				DenaturingTemperature->70Celsius,
				Output->Options
			];
			Lookup[options,DenaturingTemperature],
			70Celsius,
			Variables:>{options}
		],
		Example[
			{Options,DenaturingTime,"Specify the duration samples should be incubated at the DenaturingTemperature:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				DenaturingTime->10Minute,
				Output->Options
			];
			Lookup[options,DenaturingTime],
			10Minute,
			Variables:>{options}
		],
		Example[
			{Options,CoolingTemperature,"Specify the temperature to which samples will be cooled to after denaturation:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				CoolingTemperature->4Celsius,

				Output->Options
			];
			Lookup[options,CoolingTemperature],
			4Celsius,
			Variables:>{options}
		],
		Example[
			{Options,CoolingTime,"Specify the duration samples should be incubated at the CoolingTemperature:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				CoolingTime->10Minute,
				Output->Options
			];
			Lookup[options,CoolingTime],
			10Minute,
			Variables:>{options}
		],
		Example[
			{Options,PelletSedimentation,"Specify if centrifugation should be applied to the sample to remove precipitates after denaturation:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PelletSedimentation->True,
				Output->Options
			];
			Lookup[options,PelletSedimentation],
			True,
			Variables:>{options}
		],
		Example[
			{Options,SedimentationCentrifugationSpeed,"Specify the speed to which the centrifuge is set to for sedimentation:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SedimentationCentrifugationSpeed->2000RPM,
				Output->Options
			];
			Lookup[options,SedimentationCentrifugationSpeed],
			2000RPM,
			Variables:>{options}
		],
		Example[
			{Options,SedimentationCentrifugationSpeed,"Specify the speed to which the centrifuge is set to for sedimentation and calculate the force it applies on samples (based on radius = 19.5cm):"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SedimentationCentrifugationSpeed->2000RPM,
				Output->Options
			];
			Lookup[options,SedimentationCentrifugationForce],
			870GravitationalAcceleration,
			Variables:>{options}
		],
		Example[
			{Options,SedimentationCentrifugationForce,"Specify the force to which the centrifuge is set to for sedimentation:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SedimentationCentrifugationForce->2000GravitationalAcceleration,
				Output->Options
			];
			Lookup[options,SedimentationCentrifugationForce],
			2000GravitationalAcceleration,
			Variables:>{options}
		],
		Example[
			{Options,SedimentationCentrifugationForce,"Specify the force to which the centrifuge is set to for sedimentation calculate the centrifuge speed (based on radius = 19.5cm):"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SedimentationCentrifugationForce->2000GravitationalAcceleration,
				Output->Options
			];
			Lookup[options,SedimentationCentrifugationSpeed],
			3030RPM,
			Variables:>{options}
		],
		Example[
			{Options,SedimentationCentrifugationTime,"Specify the duration samples should be centrifuged to pellet precipitates:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SedimentationCentrifugationTime->5Minute,
				Output->Options
			];
			Lookup[options,SedimentationCentrifugationTime],
			5Minute,
			Variables:>{options}
		],
		Example[
			{Options,SedimentationCentrifugationTemperature,"Specify the temperature to which samples will be cooled to during centrifugation:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SedimentationCentrifugationTemperature->4Celsius,
				Output->Options
			];
			Lookup[options,SedimentationCentrifugationTemperature],
			4Celsius,
			Variables:>{options}
		],
		Example[
			{Options,SedimentationSupernatantVolume,"Calculate the volume of supernatant to transfer to the assay container from the sample tubes after denaturation and centrifugation based on the total volume in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SedimentationSupernatantVolume->Automatic,
				Output->Options
			];
			Lookup[options,SedimentationSupernatantVolume],
			RangeP[90Microliter, 90Microliter],
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,SedimentationSupernatantVolume,"Specify the volume of supernatant to transfer to the assay container from the sample tubes after denaturation and centrifugation. A minimum of 50 microliters are required for the analysis to proceed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SedimentationSupernatantVolume->100Microliter,
				Output->Options
			];
			Lookup[options,SedimentationSupernatantVolume],
			100Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,InternalReferenceStorageCondition,"Specify the non-default storage condition for InternalReference of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				InternalReferenceStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,InternalReferenceStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,ConcentratedSDSBufferStorageCondition,"Specify the non-default storage condition for ConcentratedSDSBuffer of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConcentratedSDSBufferStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,ConcentratedSDSBufferStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,DiluentStorageCondition,"Specify the non-default storage condition for Diluent of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				DiluentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,DiluentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,SDSBufferStorageCondition,"Specify the non-default storage condition for SDSBuffer of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SDSBufferStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SDSBufferStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,ReducingAgentStorageCondition,"Specify the non-default storage condition for ReducingAgent of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ReducingAgentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,ReducingAgentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,AlkylatingAgentStorageCondition,"Specify the non-default storage condition for AlkylatingAgent of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AlkylatingAgentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,AlkylatingAgentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,RunningBuffer,"Specify the buffer in which the capillary docks for separation:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				RunningBuffer->Model[Sample,"CESDS Running Buffer - Bottom"],
				Output->Options
			];
			Lookup[options,RunningBuffer],
			ObjectReferenceP[Model[Sample,"CESDS Running Buffer - Bottom"]],
			Variables:>{options}
		],
		Example[
			{Options,InjectionVoltageDurationProfile,"Specify Series of voltages and durations to apply onto the capillary for injection:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				InjectionVoltageDurationProfile->{{4600Volt,20Second},{4000Volt,30Second}},
				Output->Options
			];
			Lookup[options,InjectionVoltageDurationProfile],
			{{4600Volt,20Second},{4000Volt,30Second}},
			Variables:>{options}
		],
		Example[
			{Options,SeparationVoltageDurationProfile,"Specify Series of voltages and durations to apply onto the capillary for separation:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SeparationVoltageDurationProfile->{{5600Volt,35 Minute}},
				Output->Options
			];
			Lookup[options,SeparationVoltageDurationProfile],
			{{5600Volt,35 Minute}},
			Variables:>{options}
		],
		Example[
			{Options,UVDetectionWavelength,"Specify the wavelength used for UVAbsorbtion. The hardware is currently only capable of detection at 220 nm:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				UVDetectionWavelength->220Nanometer,
				Output->Options
			];
			Lookup[options,UVDetectionWavelength],
			220Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,IncludeLadders,"Ladders: Specify if mixtures of known analytes should be included in this experiment:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeLadders->True,
				Output->Options
			];
			Lookup[options,IncludeLadders],
			True,
			Variables:>{options}
		],
		Example[
			{Options,Ladders,"Ladders: Specify the object containing a premade mixture of analytes of known molecular weight (MW) to include as reference for MW interpolation in this experiment:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Ladders->Model[Sample, "Unstained Protein Standard"],
				Output->Options
			];
			Lookup[options,Ladders],
			ObjectReferenceP[Model[Sample, "Unstained Protein Standard"]],
			Variables:>{options}
		],
		Example[
			{Options,LadderAnalytes,"Ladders: Specify the analytes included in specified ladder:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Ladders->Model[Sample, "Unstained Protein Standard"],
				Output->Options
			];
			Lookup[options,LadderAnalytes],
			{
				Model[Molecule, Protein, "id:XnlV5jlKo6Ro"],
				Model[Molecule, Protein, "id:lYq9jRqxVL8V"],
				Model[Molecule, Protein, "id:kEJ9mqJRXlG3"],
				Model[Molecule, Protein, "id:mnk9jOkRpEGm"],
				Model[Molecule, Protein, "id:dORYzZRJLqmb"],
				Model[Molecule, Protein, "id:4pO6dMO5V1jX"],
				Model[Molecule, Protein, "id:XnlV5jlKo6O3"],
				Model[Molecule, Protein, "id:O81aEB1ZLDlj"],
				Model[Molecule, Protein, "id:lYq9jRqxVLEV"],
				Model[Molecule, Protein, "id:3em6ZvmLR07L"],
				Model[Molecule, Protein, "id:wqW9BPW7bXdV"],
				Model[Molecule, Protein, "id:jLq9jXqvpzrw"],
				Model[Molecule, Protein, "id:xRO9n3OBNqeq"]
			},
			EquivalenceFunction->ContainsAll,
			Variables:>{options}
		],
		Example[
			{Options,LadderAnalyteMolecularWeights,"Ladders: Specify the molecular weights of analytes included in ladder:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Ladders->Model[Sample, "Unstained Protein Standard"],
				Output->Options
			];
			Lookup[options,LadderAnalyteMolecularWeights],
			{
				10000.` Gram/Mole, 15000.` Gram/Mole, 20000.` Gram/Mole,
				25000.` Gram/Mole, 30000.` Gram/Mole, 40000.` Gram/Mole,
				50000.` Gram/Mole, 60000.` Gram/Mole, 70000.` Gram/Mole,
				85000.` Gram/Mole, 100000.` Gram/Mole, 150000.` Gram/Mole,
				200000.` Gram/Mole
			},
			Variables:>{options}
		],
		Example[
			{Options,LadderAnalyteMolecularWeights,"Ladders: Specify the molecular weights of analytes included in ladder:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderAnalyteMolecularWeights->{
					10000.` Gram/Mole, 15000.` Gram/Mole, 20000.` Gram/Mole,
					25000.` Gram/Mole, 30000.` Gram/Mole, 40000.` Gram/Mole,
					50000.` Gram/Mole, 60000.` Gram/Mole, 70000.` Gram/Mole,
					85000.` Gram/Mole, 100000.` Gram/Mole, 150000.` Gram/Mole,
					200000.` Gram/Mole
				},
				Output->Options
			];
			Lookup[options,LadderAnalyteMolecularWeights],
			{
				10000.` Gram/Mole, 15000.` Gram/Mole, 20000.` Gram/Mole,
				25000.` Gram/Mole, 30000.` Gram/Mole, 40000.` Gram/Mole,
				50000.` Gram/Mole, 60000.` Gram/Mole, 70000.` Gram/Mole,
				85000.` Gram/Mole, 100000.` Gram/Mole, 150000.` Gram/Mole,
				200000.` Gram/Mole
			},
			Variables:>{options}
		],
		Example[
			{Options,LadderAnalyteLabels,"Ladders: Specify the label of each analyte included in ladder:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Ladders->Model[Sample, "Unstained Protein Standard"],
				Output->Options
			];
			Lookup[options,LadderAnalytes],
			{
				Model[Molecule, Protein, "id:XnlV5jlKo6Ro"],
				Model[Molecule, Protein, "id:lYq9jRqxVL8V"],
				Model[Molecule, Protein, "id:kEJ9mqJRXlG3"],
				Model[Molecule, Protein, "id:mnk9jOkRpEGm"],
				Model[Molecule, Protein, "id:dORYzZRJLqmb"],
				Model[Molecule, Protein, "id:4pO6dMO5V1jX"],
				Model[Molecule, Protein, "id:XnlV5jlKo6O3"],
				Model[Molecule, Protein, "id:O81aEB1ZLDlj"],
				Model[Molecule, Protein, "id:lYq9jRqxVLEV"],
				Model[Molecule, Protein, "id:3em6ZvmLR07L"],
				Model[Molecule, Protein, "id:wqW9BPW7bXdV"],
				Model[Molecule, Protein, "id:jLq9jXqvpzrw"],
				Model[Molecule, Protein, "id:xRO9n3OBNqeq"]
			},
			Variables:>{options}
		],
		Example[
			{Options,LadderAnalyteLabels,"Ladders: Specify the analytes included in ladder:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderAnalyteLabels->{{"10 KDa", "15 KDa", "20 KDa", "25 KDa", "30 KDa", "40 KDa", "50 KDa",
					"60 KDa", "70 KDa", "85 KDa", "100 KDa", "150 KDa", "200 KDa"}},
				Output->Options
			];
			Lookup[options,LadderAnalyteLabels],
			{"10 KDa", "15 KDa", "20 KDa", "25 KDa", "30 KDa", "40 KDa", "50 KDa",
				"60 KDa", "70 KDa", "85 KDa", "100 KDa", "150 KDa", "200 KDa"},
			Variables:>{options}
		],
		Example[
			{Options,LadderFrequency,"Ladders: Specify how many injections per permutation of ladder and unique set of separation conditions should be included in this experiment:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderFrequency->FirstAndLast,
				Output->Options
			];
			Lookup[options,LadderFrequency],
			FirstAndLast,
			Variables:>{options}
		],
		Example[
			{Options,LadderTotalVolume,"Ladders: Specify the final volume in the assay tube prior to loading onto AssayContainer:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderTotalVolume->70 Microliter,
				Output->Options
			];
			Lookup[options,LadderTotalVolume],
			70 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,LadderTotalVolume,"Ladders: Infer the final volume in the ladder assay tubes based on the value in samples:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeLadders->True,LadderTotalVolume->Automatic,
				Output->Options
			];
			Lookup[options,LadderTotalVolume],
			100Microliter,
			Variables:>{options}
		],
		Example[
			{Options,LadderDilutionFactor,"Ladders: Specify the factor by which the ladder should be diluted by in the final assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderDilutionFactor->4,
				Output->Options
			];
			Lookup[options,LadderDilutionFactor],
			4,
			Variables:>{options}
		],
		Example[
			{Options,LadderDilutionFactor,"Ladders: Specify the factor by which the ladder should be diluted by in the final assay tube and calculate its volume:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderDilutionFactor->2.5,
				Output->Options
			];
			Lookup[options,LadderVolume],
			RangeP[40Microliter, 40Microliter],
			Variables:>{options}
		],
		Example[
			{Options,LadderVolume,"Ladders: Specify the volume of ladder required to reach its final concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->20Microliter,
				Output->Options
			];
			Lookup[options,LadderVolume],
			20Microliter,
			Variables:>{options}
		],
		Example[
			{Options,LadderVolume,"Ladders: Infer the volume of ladder required to reach its final concentration based on its concentration from its dilution factor:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeLadders->True,LadderVolume->Automatic,
				Output->Options
			];
			Lookup[options,LadderVolume],
			RangeP[40Microliter, 40Microliter],
			Variables:>{options}
		],
		Example[
		{Options,LadderPremadeMasterMix,"Ladders: Specify if samples should be mixed with PremadeMasterMix that includes an SDS buffer, an internal standard, and reducing and / or alkylating agents:"},
		options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
			LadderVolume->25Microliter,LadderPremadeMasterMix->False,
			Output->Options
		];
		Lookup[options,LadderPremadeMasterMix],
		False,
		Variables:>{options}
	],
		Example[
			{Options,LadderPremadeMasterMixReagent,"Ladders: Specify the premade master mix object/model used for CESDS experiment:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
				Output->Options
			];
			Lookup[options,LadderPremadeMasterMixReagent],
			ObjectReferenceP[Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,LadderPremadeMasterMixDiluent,"Ladders: Specify the solution used to dilute the premade master mix to its working concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent " <>$SessionUUID],LadderPremadeMasterMixDiluent->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,LadderPremadeMasterMixDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,LadderPremadeMasterMixReagentDilutionFactor,"Ladders: Specify the factor by which the premade mastermix should be diluted by in the final assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],LadderPremadeMasterMixReagentDilutionFactor->2,
				Output->Options
			];
			Lookup[options,LadderPremadeMasterMixReagentDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,LadderPremadeMasterMixReagentDilutionFactor,"Ladders: Specify the factor by which the premade mastermix should be diluted and calculate the volume that should be added to the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],LadderPremadeMasterMixReagentDilutionFactor->2,
				Output->Options
			];
			Lookup[options,LadderPremadeMasterMixVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,LadderPremadeMasterMixVolume,"Ladders: Specify the volume of the premade mastermix required to reach its final concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],LadderPremadeMasterMixVolume->50 Microliter,
				Output->Options
			];
			Lookup[options,LadderPremadeMasterMixVolume],
			50 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,LadderPremadeMasterMixVolume,"Ladders: Specify the volume of the premade mastermix and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],LadderPremadeMasterMixVolume->50 Microliter,
				Output->Options
			];
			Lookup[options,LadderPremadeMasterMixReagentDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,LadderPremadeMasterMixStorageCondition,"Ladders: Specify the non-default storage condition for PremadeMasterMix of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderPremadeMasterMixStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,LadderPremadeMasterMixStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,LadderInternalReference,"Ladders: Specify the stock solution object/model containing the analyte serving as the internal standard:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderInternalReference->Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"],
				Output->Options
			];
			Lookup[options,LadderInternalReference],
			ObjectReferenceP[Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"]],
			Variables:>{options}
		],
		Example[
			{Options,LadderInternalReferenceDilutionFactor,"Ladders: Specify Marks how concentrated the internal standard is:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderInternalReferenceDilutionFactor->25,
				Output->Options
			];
			Lookup[options,LadderInternalReferenceDilutionFactor],
			25,
			Variables:>{options}
		],
		Example[
			{Options,LadderInternalReferenceDilutionFactor,"Ladders: Specify Marks how concentrated the internal standard is and calculate the volume required to reach 1X concentration in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderInternalReferenceDilutionFactor->25,
				Output->Options
			];
			Lookup[options,LadderInternalReferenceVolume],
			4Microliter,
			Variables:>{options}
		],
		Example[
			{Options,LadderInternalReferenceVolume,"Ladders: Specify the volume of the internal standard added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderInternalReferenceVolume->5Microliter,
				Output->Options
			];
			Lookup[options,LadderInternalReferenceVolume],
			5Microliter,
			Variables:>{options}
		],
		Example[
			{Options,LadderInternalReferenceVolume,"Ladders: Specify the volume of the internal standard added to each ladder and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderInternalReferenceVolume->5Microliter,
				Output->Options
			];
			Lookup[options,LadderInternalReferenceDilutionFactor],
			20,
			Variables:>{options}
		],
		Example[
			{Options,LadderConcentratedSDSBuffer,"Ladders: Specify the SDS Buffer used to dilute the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderConcentratedSDSBuffer->Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
				Output->Options
			];
			Lookup[options,LadderConcentratedSDSBuffer],
			ObjectReferenceP[Model[Sample,"1% SDS in 100mM Tris, pH 9.5"]],
			Variables:>{options}
		],
		Example[
			{Options,LadderConcentratedSDSBufferDilutionFactor,"Ladders: Specify Marks how concentrated the SDS buffer is:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderConcentratedSDSBufferDilutionFactor->2,
				Output->Options
			];
			Lookup[options,LadderConcentratedSDSBufferDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,LadderConcentratedSDSBufferDilutionFactor,"Ladders: Specify Marks how concentrated the SDS buffer is and calculate the volume required to reach 1X in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderConcentratedSDSBufferDilutionFactor->2,
				Output->Options
			];
			Lookup[options,LadderConcentratedSDSBufferVolume],
			50Microliter,
			Variables:>{options}
		],

		Example[
			{Options,LadderDiluent,"Ladders: Specify the solution used to dilute the ConcentratedSDSBuffer to working concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderDiluent->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,LadderDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,LadderConcentratedSDSBufferVolume,"Ladders: Specify the volume of ConcentratedSDSBuffer added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderConcentratedSDSBufferVolume->60Microliter,
				Output->Options
			];
			Lookup[options,LadderConcentratedSDSBufferVolume],
			60Microliter,
			Variables:>{options}
		],
		Example[
			{Options,LadderConcentratedSDSBufferVolume,"Ladders: Specify the volume of ConcentratedSDSBuffer added to each ladder and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderConcentratedSDSBufferVolume->50Microliter,
				Output->Options
			];
			Lookup[options,LadderConcentratedSDSBufferDilutionFactor],
			2.,
			Variables:>{options}
		],
		Example[
			{Options,LadderSDSBuffer,"Ladders: Specify the SDS Buffer used to dilute the sample. The final concentration of SDS in this assay must be equal or greater than 0.5%. If ConcentratedSDSBuffer is set to Null, SDSBuffer will be used to dilute the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderSDSBuffer->Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
				Output->Options
			];
			Lookup[options,LadderSDSBuffer],
			ObjectReferenceP[Model[Sample,"1% SDS in 100mM Tris, pH 9.5"]],
			Variables:>{options}
		],
		Example[
			{Options,LadderSDSBufferVolume,"Ladders: Specify the volume of SDSBuffer added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]},
				LadderVolume->25Microliter,LadderSDSBufferVolume->71Microliter,
				Output->Options
			];
			Lookup[options,LadderSDSBufferVolume],
			71Microliter,
			Variables:>{options}
		],
		Example[
			{Options,LadderSDSBufferVolume,"Ladders: Specify the volume of SDSBuffer and ConcentratedSDSBuffer added to each ladder and give priority to the ConcentratedSDS branch:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]},
				LadderSDSBuffer->Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],LadderVolume->25Microliter,LadderSDSBufferVolume->70Microliter,LadderConcentratedSDSBufferVolume->50Microliter,
				Output->Options
			];
			Lookup[options,LadderConcentratedSDSBufferVolume],
			50Microliter,
			Variables:>{options},
			Messages:>{Warning::BothSDSBufferOptionsSet}
		],
		Example[
			{Options,LadderReduction,"Ladders: Specify if disulfide bridges should be chemically reduced in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderReduction->True,
				Output->Options
			];
			Lookup[options,LadderReduction],
			True,
			Variables:>{options}
		],
		Example[
			{Options,LadderReducingAgent,"Ladders: Specify the reducing agent used to reduce disulfide bridges in proteins to be added to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderReducingAgent->Model[Sample, "2-Mercaptoethanol"],
				Output->Options
			];
			Lookup[options,LadderReducingAgent],
			ObjectReferenceP[Model[Sample, "2-Mercaptoethanol"]],
			Variables:>{options}
		],
		Example[
			{Options,LadderReducingAgentTargetConcentration,"Ladders: Specify the final concentration of the reducing agent in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderReducingAgentTargetConcentration->4.54545VolumePercent,
				Output->Options
			];
			Lookup[options,LadderReducingAgentTargetConcentration],
			4.54545VolumePercent,
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,LadderReducingAgentTargetConcentration,"Ladders: Specify the final concentration of the reducing agent in the ladder and calculate the required volume to reach that volume based on the concentration in the Reducing Agent Object:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderReducingAgentTargetConcentration->3.5VolumePercent,
				Output->Options
			];
			Lookup[options,LadderReducingAgentVolume],
			3.5Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,LadderReducingAgentVolume,"Ladders: Specify the volume of the reducing agent required to reach its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderReducingAgentVolume->4.5Microliter,
				Output->Options
			];
			Lookup[options,LadderReducingAgentVolume],
			4.5Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,LadderReducingAgentVolume,"Ladders: Specify the volume of the reducing agent and calculate its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderReducingAgentVolume->4.5Microliter,
				Output->Options
			];
			Lookup[options,LadderReducingAgentTargetConcentration],
			4.5VolumePercent,(* BME is in volume percent, this would be 0.6435 Molar if it were a Molar concentration *)
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,LadderAlkylation,"Ladders: Specify if Alkylation should be applied to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderAlkylation->True,
				Output->Options
			];
			Lookup[options,LadderAlkylation],
			True,
			Variables:>{options}
		],
		Example[
			{Options,LadderAlkylatingAgent,"Ladders: Specify the alkylating agent to be added to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderAlkylatingAgent->Model[Sample, StockSolution,"250mM Iodoacetamide"],
				Output->Options
			];
			Lookup[options,LadderAlkylatingAgent],
			ObjectReferenceP[Model[Sample, StockSolution,"250mM Iodoacetamide"]],
			Variables:>{options}
		],
		Example[
			{Options,LadderAlkylatingAgentTargetConcentration,"Ladders: Specify the final concentration of the alkylating agent in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderAlkylatingAgentTargetConcentration->11.5Millimolar,
				Output->Options
			];
			Lookup[options,LadderAlkylatingAgentTargetConcentration],
			11.5Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,LadderAlkylatingAgentTargetConcentration,"Ladders: Specify the final concentration of the alkylating agent in the ladder and calculate the required volume to reach that concentration based on the alkylating agent object concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderAlkylatingAgentTargetConcentration->11.5Millimolar,
				Output->Options
			];
			Lookup[options,LadderAlkylatingAgentVolume],
			4.8 Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,LadderAlkylatingAgentVolume,"Ladders: Specify the volume of the alkylating agent required to reach its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderAlkylatingAgentVolume->4.6 Microliter,
				Output->Options
			];
			Lookup[options,LadderAlkylatingAgentVolume],
			4.6 Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,LadderAlkylatingAgentVolume,"Ladders: Specify the volume of the alkylating agent and calculate its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderAlkylatingAgentVolume->4.6 Microliter,
				Output->Options
			];
			Lookup[options,LadderAlkylatingAgentTargetConcentration],
			10.9358 Millimolar,
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,LadderSedimentationSupernatantVolume,"Ladders: Calculate the volume of supernatant to transfer to the assay container from the ladder tubes after denaturation and centrifugation based on the total volume in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderSedimentationSupernatantVolume->Automatic,
				Output->Options
			];
			Lookup[options,LadderSedimentationSupernatantVolume],
			RangeP[90Microliter, 90Microliter],
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,LadderSedimentationSupernatantVolume,"Ladders: Specify the volume of supernatant to transfer to the assay container from the ladder tubes after denaturation and centrifugation. A minimum of 50 microliters are required for the analysis to proceed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderSedimentationSupernatantVolume->100Microliter,
				Output->Options
			];
			Lookup[options,LadderSedimentationSupernatantVolume],
			100Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,LadderInternalReferenceStorageCondition,"Ladders: Specify the non-default storage condition for InternalReference of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderInternalReferenceStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,LadderInternalReferenceStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,LadderStorageCondition,"Ladders: Specify the non-default storage condition for Ladder of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,LadderStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,LadderConcentratedSDSBufferStorageCondition,"Ladders: Specify the non-default storage condition for ConcentratedSDSBuffer of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderConcentratedSDSBufferStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,LadderConcentratedSDSBufferStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,LadderDiluentStorageCondition,"Ladders: Specify the non-default storage condition for Diluent of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderDiluentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,LadderDiluentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,LadderSDSBufferStorageCondition,"Ladders: Specify the non-default storage condition for SDSBuffer of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderSDSBufferStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,LadderSDSBufferStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,LadderReducingAgentStorageCondition,"Ladders: Specify the non-default storage condition for ReducingAgent of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderReducingAgentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,LadderReducingAgentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,LadderAlkylatingAgentStorageCondition,"Ladders: Specify the non-default storage condition for AlkylatingAgent of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderAlkylatingAgentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,LadderAlkylatingAgentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,LadderInjectionVoltageDurationProfile,"Ladders: Specify Series of voltages and durations to apply onto the capillary for injection:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderInjectionVoltageDurationProfile->{{4600Volt,20Second},{4000Volt,30Second}},
				Output->Options
			];
			Lookup[options,LadderInjectionVoltageDurationProfile],
			{{4600Volt,20Second},{4000Volt,30Second}},
			Variables:>{options}
		],
		Example[
			{Options,LadderSeparationVoltageDurationProfile,"Ladders: Specify Series of voltages and durations to apply onto the capillary for separation:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				LadderVolume->25Microliter,LadderSeparationVoltageDurationProfile->{{5600Volt,35 Minute}},
				Output->Options
			];
			Lookup[options,LadderSeparationVoltageDurationProfile],
			{{5600Volt,35 Minute}},
			Variables:>{options}
		],
		Example[
			{Options,IncludeStandards,"Standards: Specify if standards should be included in this experiment. Standards contain identified analytes of known size and Relative Migration Times. Standards are used to both ensure reproducibility within and between Experiments and to interpolate the molecular weight of unknown analytes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeStandards->True,Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],
				Output->Options
			];
			Lookup[options,IncludeStandards],
			True,
			Variables:>{options}
		],
		Example[
			{Options,Standards,"Standards: Specify which standards to include:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],
				Output->Options
			];
			Lookup[options,Standards],
			ObjectReferenceP[Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,StandardTotalVolume,"Standards: Specify the final volume in the assay tube prior to loading onto AssayContainer:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID], Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],
				StandardTotalVolume->70 Microliter,
				Output->Options
			];
			Lookup[options,StandardTotalVolume],
			70 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardFrequency,"Standards: Specify how many injections per standard should be included in this experiment. Sample, Standard, and Blank injection order are resolved according to InjectionTable:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardFrequency->FirstAndLast,
				Output->Options
			];
			Lookup[options,StandardFrequency],
			FirstAndLast,
			Variables:>{options}
		],
		Example[
			{Options,StandardVolume,"Standards: Specify the volume drawn from the standard to the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardVolume->10 Microliter,
				Output->Options
			];
			Lookup[options,StandardVolume],
			10 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardPremadeMasterMix,"Standards: Specify if samples should be mixed with PremadeMasterMix that includes an SDS buffer, an internal standard, and reducing and / or alkylating agents:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardPremadeMasterMix->False,
				Output->Options
			];
			Lookup[options,StandardPremadeMasterMix],
			False,
			Variables:>{options}
		],
		Example[
			{Options,StandardPremadeMasterMixReagent,"Standards: Specify the premade master mix object/model used for CESDS experiment:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
				Output->Options
			];
			Lookup[options,StandardPremadeMasterMixReagent],
			ObjectReferenceP[Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,StandardPremadeMasterMixDiluent,"Standards: Specify the solution used to dilute the premade master mix to its working concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent " <>$SessionUUID],StandardPremadeMasterMixDiluent->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,StandardPremadeMasterMixDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,StandardPremadeMasterMixReagentDilutionFactor,"Standards: Specify the factor by which the premade mastermix should be diluted by in the final assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],StandardPremadeMasterMixReagentDilutionFactor->2,
				Output->Options
			];
			Lookup[options,StandardPremadeMasterMixReagentDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,StandardPremadeMasterMixReagentDilutionFactor,"Standards: Specify the factor by which the premade mastermix should be diluted and calculate the volume that should be added to the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],StandardPremadeMasterMixReagentDilutionFactor->2,
				Output->Options
			];
			Lookup[options,StandardPremadeMasterMixVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardPremadeMasterMixVolume,"Standards: Specify the volume of the premade mastermix required to reach its final concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],StandardPremadeMasterMixVolume->50 Microliter,
				Output->Options
			];
			Lookup[options,StandardPremadeMasterMixVolume],
			50 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardPremadeMasterMixVolume,"Standards: Specify the volume of the premade mastermix and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],StandardPremadeMasterMixVolume->50 Microliter,
				Output->Options
			];
			Lookup[options,StandardPremadeMasterMixReagentDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,StandardPremadeMasterMixStorageCondition,"Standards: Specify the non-default storage condition for PremadeMasterMix of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardPremadeMasterMixStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,StandardPremadeMasterMixStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,StandardInternalReference,"Standards: Specify the stock solution object/model containing the analyte serving as the internal standard:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardInternalReference->Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"],
				Output->Options
			];
			Lookup[options,StandardInternalReference],
			ObjectReferenceP[Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"]],
			Variables:>{options}
		],
		Example[
			{Options,StandardInternalReferenceDilutionFactor,"Standards: Specify Marks how concentrated the internal standard is:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardInternalReferenceDilutionFactor->25,
				Output->Options
			];
			Lookup[options,StandardInternalReferenceDilutionFactor],
			25,
			Variables:>{options}
		],
		Example[
			{Options,StandardInternalReferenceDilutionFactor,"Standards: Specify Marks how concentrated the internal standard is and calculate the volume required to reach 1X concentration in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardInternalReferenceDilutionFactor->25,
				Output->Options
			];
			Lookup[options,StandardInternalReferenceVolume],
			4Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardInternalReferenceVolume,"Standards: Specify the volume of the internal standard added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardInternalReferenceVolume->5Microliter,
				Output->Options
			];
			Lookup[options,StandardInternalReferenceVolume],
			5Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardInternalReferenceVolume,"Standards: Specify the volume of the internal standard added to each standard and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardInternalReferenceVolume->5Microliter,
				Output->Options
			];
			Lookup[options,StandardInternalReferenceDilutionFactor],
			20,
			Variables:>{options}
		],
		Example[
			{Options,StandardConcentratedSDSBuffer,"Standards: Specify the SDS Buffer used to dilute the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardConcentratedSDSBuffer->Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
				Output->Options
			];
			Lookup[options,StandardConcentratedSDSBuffer],
			ObjectReferenceP[Model[Sample,"1% SDS in 100mM Tris, pH 9.5"]],
			Variables:>{options}
		],
		Example[
			{Options,StandardConcentratedSDSBufferDilutionFactor,"Standards: Specify Marks how concentrated the SDS buffer is:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardConcentratedSDSBufferDilutionFactor->2,
				Output->Options
			];
			Lookup[options,StandardConcentratedSDSBufferDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,StandardConcentratedSDSBufferDilutionFactor,"Standards: Specify Marks how concentrated the SDS buffer is and calculate the volume required to reach 1X in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardConcentratedSDSBufferDilutionFactor->2,
				Output->Options
			];
			Lookup[options,StandardConcentratedSDSBufferVolume],
			50Microliter,
			Variables:>{options}
		],

		Example[
			{Options,StandardDiluent,"Standards: Specify the solution used to dilute the ConcentratedSDSBuffer to working concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardDiluent->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,StandardDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,StandardConcentratedSDSBufferVolume,"Standards: Specify the volume of ConcentratedSDSBuffer added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardConcentratedSDSBufferVolume->50Microliter,
				Output->Options
			];
			Lookup[options,StandardConcentratedSDSBufferVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardConcentratedSDSBufferVolume,"Standards: Specify the volume of ConcentratedSDSBuffer added to each standard and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardConcentratedSDSBufferVolume->50Microliter,
				Output->Options
			];
			Lookup[options,StandardConcentratedSDSBufferDilutionFactor],
			2.,
			Variables:>{options}
		],
		Example[
			{Options,StandardSDSBuffer,"Standards: Specify the SDS Buffer used to dilute the sample. The final concentration of SDS in this assay must be equal or greater than 0.5%. If ConcentratedSDSBuffer is set to Null, SDSBuffer will be used to dilute the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardSDSBuffer->Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
				Output->Options
			];
			Lookup[options,StandardSDSBuffer],
			ObjectReferenceP[Model[Sample,"1% SDS in 100mM Tris, pH 9.5"]],
			Variables:>{options}
		],
		Example[
			{Options,StandardSDSBufferVolume,"Standards: Specify the volume of SDSBuffer added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]},
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardVolume->1Microliter, StandardSDSBufferVolume->95Microliter,
				Output->Options
			];
			Lookup[options,StandardSDSBufferVolume],
			95Microliter,
			Variables:>{options}
		],
		Example[
		{Options,StandardSDSBufferVolume,"Standards: Specify the volume of SDSBuffer and ConcentratedSDSBuffer added to each standard and give priority to the ConcentratedSDS branch:"},
		options=ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]},
			Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardSDSBuffer->Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],
			StandardSDSBufferVolume->95Microliter,StandardConcentratedSDSBufferVolume->50Microliter,
			Output->Options
		];
		Lookup[options,StandardConcentratedSDSBufferVolume],
		50Microliter,
		Variables:>{options},
		Messages:>{Warning::BothSDSBufferOptionsSet}
		],
		Example[
			{Options,StandardReduction,"Standards: Specify if disulfide bridges should be chemically reduced in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardReduction->True,
				Output->Options
			];
			Lookup[options,StandardReduction],
			True,
			Variables:>{options}
		],
		Example[
			{Options,StandardReducingAgent,"Standards: Specify the reducing agent used to reduce disulfide bridges in proteins to be added to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardReducingAgent->Model[Sample, "2-Mercaptoethanol"],
				Output->Options
			];
			Lookup[options,StandardReducingAgent],
			ObjectReferenceP[Model[Sample, "2-Mercaptoethanol"]],
			Variables:>{options}
		],
		Example[
			{Options,StandardReducingAgentTargetConcentration,"Standards: Specify the final concentration of the reducing agent in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardReducingAgentTargetConcentration->4.54545VolumePercent,
				Output->Options
			];
			Lookup[options,StandardReducingAgentTargetConcentration],
			4.54545VolumePercent,
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,StandardReducingAgentTargetConcentration,"Standards: Specify the final concentration of the reducing agent in the standard and calculate the required volume to reach that volume based on the concentration in the Reducing Agent Object:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardReducingAgentTargetConcentration->3.5VolumePercent,
				Output->Options
			];
			Lookup[options,StandardReducingAgentVolume],
			3.5Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,StandardReducingAgentVolume,"Standards: Specify the volume of the reducing agent required to reach its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardReducingAgentVolume->4.5Microliter,
				Output->Options
			];
			Lookup[options,StandardReducingAgentVolume],
			4.5Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,StandardReducingAgentVolume,"Standards: Specify the volume of the reducing agent and calculate its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardReducingAgentVolume->4.5Microliter,
				Output->Options
			];
			Lookup[options,StandardReducingAgentTargetConcentration],
			4.5VolumePercent,(* BME is in volume percent, this would be 0.6435 Molar if it were a Molar concentration *)
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,StandardAlkylation,"Standards: Specify if Alkylation should be applied to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardAlkylation->True,
				Output->Options
			];
			Lookup[options,StandardAlkylation],
			True,
			Variables:>{options}
		],
		Example[
			{Options,StandardAlkylatingAgent,"Standards: Specify the alkylating agent to be added to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardAlkylatingAgent->Model[Sample, StockSolution,"250mM Iodoacetamide"],
				Output->Options
			];
			Lookup[options,StandardAlkylatingAgent],
			ObjectReferenceP[Model[Sample, StockSolution,"250mM Iodoacetamide"]],
			Variables:>{options}
		],
		Example[
			{Options,StandardAlkylatingAgentTargetConcentration,"Standards: Specify the final concentration of the alkylating agent in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardAlkylatingAgentTargetConcentration->11.5Millimolar,
				Output->Options
			];
			Lookup[options,StandardAlkylatingAgentTargetConcentration],
			11.5Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,StandardAlkylatingAgentTargetConcentration,"Standards: Specify the final concentration of the alkylating agent in the standard and calculate the required volume to reach that concentration based on the alkylating agent object concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardAlkylatingAgentTargetConcentration->11.5Millimolar,
				Output->Options
			];
			Lookup[options,StandardAlkylatingAgentVolume],
			4.8 Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,StandardAlkylatingAgentVolume,"Standards: Specify the volume of the alkylating agent required to reach its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardAlkylatingAgentVolume->4.6 Microliter,
				Output->Options
			];
			Lookup[options,StandardAlkylatingAgentVolume],
			4.6 Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,StandardAlkylatingAgentVolume,"Standards: Specify the volume of the alkylating agent and calculate its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardAlkylatingAgentVolume->4.6 Microliter,
				Output->Options
			];
			Lookup[options,StandardAlkylatingAgentTargetConcentration],
			10.9358 Millimolar,
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,StandardSedimentationSupernatantVolume,"Standards: Calculate the volume of supernatant to transfer to the assay container from the standard tubes after denaturation and centrifugation based on the total volume in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardSedimentationSupernatantVolume->Automatic,
				Output->Options
			];
			Lookup[options,StandardSedimentationSupernatantVolume],
			RangeP[90Microliter, 90Microliter],
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,StandardSedimentationSupernatantVolume,"Standards: Specify the volume of supernatant to transfer to the assay container from the standard tubes after denaturation and centrifugation. A minimum of 50 microliters are required for the analysis to proceed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardSedimentationSupernatantVolume->100Microliter,
				Output->Options
			];
			Lookup[options,StandardSedimentationSupernatantVolume],
			100Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,StandardInternalReferenceStorageCondition,"Standards: Specify the non-default storage condition for InternalReference of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardInternalReferenceStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,StandardInternalReferenceStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,StandardStorageCondition,"Standard: Specify the non-default storage condition for Standard of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				StandardVolume->25Microliter, StandardStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,StandardStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,StandardConcentratedSDSBufferStorageCondition,"Standards: Specify the non-default storage condition for ConcentratedSDSBuffer of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardConcentratedSDSBufferStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,StandardConcentratedSDSBufferStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,StandardDiluentStorageCondition,"Standards: Specify the non-default storage condition for Diluent of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardDiluentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,StandardDiluentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,StandardSDSBufferStorageCondition,"Standards: Specify the non-default storage condition for SDSBuffer of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardSDSBufferStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,StandardSDSBufferStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,StandardReducingAgentStorageCondition,"Standards: Specify the non-default storage condition for ReducingAgent of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardReducingAgentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,StandardReducingAgentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,StandardAlkylatingAgentStorageCondition,"Standards: Specify the non-default storage condition for AlkylatingAgent of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardAlkylatingAgentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,StandardAlkylatingAgentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,StandardInjectionVoltageDurationProfile,"Standards: Specify Series of voltages and durations to apply onto the capillary for injection:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardInjectionVoltageDurationProfile->{{4600Volt,20Second},{4000Volt,30Second}},
				Output->Options
			];
			Lookup[options,StandardInjectionVoltageDurationProfile],
			{{4600Volt,20Second},{4000Volt,30Second}},
			Variables:>{options}
		],
		Example[
			{Options,StandardSeparationVoltageDurationProfile,"Standards: Specify Series of voltages and durations to apply onto the capillary for separation:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards->Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],StandardSeparationVoltageDurationProfile->{{5600Volt,35 Minute}},
				Output->Options
			];
			Lookup[options,StandardSeparationVoltageDurationProfile],
			{{5600Volt,35 Minute}},
			Variables:>{options}
		],
		(* All blanks have volume set to prevent a warning on missing composition from coming up *)
		Example[
			{Options,IncludeBlanks,"Blanks: Specify if blanks should be included in this experiment. Blanks contain identified analytes of known size and Relative Migration Times. Blanks are used to both ensure reproducibility within and between Experiments and to interpolate the molecular weight of unknown analytes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeBlanks->True,BlankVolume->25Microliter,
				Output->Options
			];
			Lookup[options,IncludeBlanks],
			True,
			Variables:>{options}
		],
		Example[
			{Options,Blanks,"Blanks: Specify which blanks to include:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Blanks->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,Blanks],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankTotalVolume,"Blanks: Specify the final volume in the assay tube prior to loading onto AssayContainer:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID], Blanks->Model[Sample,"Milli-Q water"],
				BlankTotalVolume->70 Microliter,
				Output->Options
			];
			Lookup[options,BlankTotalVolume],
			70 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankFrequency,"Blanks: Specify how many injections per blank should be included in this experiment. Sample, Standard, and Blank injection order are resolved according to InjectionTable:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankFrequency->FirstAndLast,
				Output->Options
			];
			Lookup[options,BlankFrequency],
			FirstAndLast,
			Variables:>{options}
		],
		Example[
			{Options,BlankVolume,"Blanks: Specify the volume drawn from the blank to the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->10 Microliter,
				Output->Options
			];
			Lookup[options,BlankVolume],
			10 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMix,"Blanks: Specify if samples should be mixed with PremadeMasterMix that includes an SDS buffer, an internal standard, and reducing and / or alkylating agents:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankPremadeMasterMix->False,
				Output->Options
			];
			Lookup[options,BlankPremadeMasterMix],
			False,
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixReagent,"Blanks: Specify the premade master mix object/model used for CESDS experiment:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
				Output->Options
			];
			Lookup[options,BlankPremadeMasterMixReagent],
			ObjectReferenceP[Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixDiluent,"Blanks: Specify the solution used to dilute the premade master mix to its working concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent " <>$SessionUUID],BlankPremadeMasterMixDiluent->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,BlankPremadeMasterMixDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixReagentDilutionFactor,"Blanks: Specify the factor by which the premade mastermix should be diluted by in the final assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],BlankPremadeMasterMixReagentDilutionFactor->2,
				Output->Options
			];
			Lookup[options,BlankPremadeMasterMixReagentDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixReagentDilutionFactor,"Blanks: Specify the factor by which the premade mastermix should be diluted and calculate the volume that should be added to the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],BlankPremadeMasterMixReagentDilutionFactor->2,
				Output->Options
			];
			Lookup[options,BlankPremadeMasterMixVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixVolume,"Blanks: Specify the volume of the premade mastermix required to reach its final concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],BlankPremadeMasterMixVolume->50 Microliter,
				Output->Options
			];
			Lookup[options,BlankPremadeMasterMixVolume],
			50 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixVolume,"Blanks: Specify the volume of the premade mastermix and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankPremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],BlankPremadeMasterMixVolume->50 Microliter,
				Output->Options
			];
			Lookup[options,BlankPremadeMasterMixReagentDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixStorageCondition,"Blanks: Specify the non-default storage condition for PremadeMasterMix of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankPremadeMasterMixStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,BlankPremadeMasterMixStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankInternalReference,"Blanks: Specify the stock solution object/model containing the analyte serving as the internal standard:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankInternalReference->Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"],
				Output->Options
			];
			Lookup[options,BlankInternalReference],
			ObjectReferenceP[Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankInternalReferenceDilutionFactor,"Blanks: Specify Marks how concentrated the internal standard is:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankInternalReferenceDilutionFactor->25,
				Output->Options
			];
			Lookup[options,BlankInternalReferenceDilutionFactor],
			25,
			Variables:>{options}
		],
		Example[
			{Options,BlankInternalReferenceDilutionFactor,"Blanks: Specify Marks how concentrated the internal standard is and calculate the volume required to reach 1X concentration in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankInternalReferenceDilutionFactor->25,
				Output->Options
			];
			Lookup[options,BlankInternalReferenceVolume],
			4Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankInternalReferenceVolume,"Blanks: Specify the volume of the internal standard added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankInternalReferenceVolume->5Microliter,
				Output->Options
			];
			Lookup[options,BlankInternalReferenceVolume],
			5Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankInternalReferenceVolume,"Blanks: Specify the volume of the internal standard added to each blank and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankInternalReferenceVolume->5Microliter,
				Output->Options
			];
			Lookup[options,BlankInternalReferenceDilutionFactor],
			20,
			Variables:>{options}
		],
		Example[
			{Options,BlankConcentratedSDSBuffer,"Blanks: Specify the SDS Buffer used to dilute the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankConcentratedSDSBuffer->Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
				Output->Options
			];
			Lookup[options,BlankConcentratedSDSBuffer],
			ObjectReferenceP[Model[Sample,"1% SDS in 100mM Tris, pH 9.5"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankConcentratedSDSBufferDilutionFactor,"Blanks: Specify Marks how concentrated the SDS buffer is:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankConcentratedSDSBufferDilutionFactor->2,
				Output->Options
			];
			Lookup[options,BlankConcentratedSDSBufferDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,BlankConcentratedSDSBufferDilutionFactor,"Blanks: Specify Marks how concentrated the SDS buffer is and calculate the volume required to reach 1X in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankConcentratedSDSBufferDilutionFactor->2,
				Output->Options
			];
			Lookup[options,BlankConcentratedSDSBufferVolume],
			50Microliter,
			Variables:>{options}
		],

		Example[
			{Options,BlankDiluent,"Blanks: Specify the solution used to dilute the ConcentratedSDSBuffer to working concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankDiluent->Model[Sample,"Milli-Q water"],
				Output->Options
			];
			Lookup[options,BlankDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankConcentratedSDSBufferVolume,"Blanks: Specify the volume of ConcentratedSDSBuffer added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankConcentratedSDSBufferVolume->60Microliter,
				Output->Options
			];
			Lookup[options,BlankConcentratedSDSBufferVolume],
			60Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankConcentratedSDSBufferVolume,"Blanks: Specify the volume of ConcentratedSDSBuffer added to each blank and calculate the dilution factor in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankConcentratedSDSBufferVolume->50Microliter,
				Output->Options
			];
			Lookup[options,BlankConcentratedSDSBufferDilutionFactor],
			2.,
			Variables:>{options}
		],
		Example[
			{Options,BlankSDSBuffer,"Blanks: Specify the SDS Buffer used to dilute the sample. The final concentration of SDS in this assay must be equal or greater than 0.5%. If ConcentratedSDSBuffer is set to Null, SDSBuffer will be used to dilute the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankSDSBuffer->Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
				Output->Options
			];
			Lookup[options,BlankSDSBuffer],
			ObjectReferenceP[Model[Sample,"1% SDS in 100mM Tris, pH 9.5"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankSDSBufferVolume,"Blanks: Specify the volume of SDSBuffer added to each sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]},
				BlankVolume->25Microliter,BlankSDSBufferVolume->71Microliter,
				Output->Options
			];
			Lookup[options,BlankSDSBufferVolume],
			71Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankSDSBufferVolume,"Blanks: Specify the volume of SDSBuffer and ConcentratedSDSBuffer added to each blank and give priority to the ConcentratedSDS branch:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]},
				BlankSDSBuffer->Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],BlankVolume->25Microliter,BlankSDSBufferVolume->70Microliter,BlankConcentratedSDSBufferVolume->50Microliter,
				Output->Options
			];
			Lookup[options,BlankConcentratedSDSBufferVolume],
			50Microliter,
			Variables:>{options},
			Messages:>{Warning::BothSDSBufferOptionsSet}
		],
		Example[
			{Options,BlankReduction,"Blanks: Specify if disulfide bridges should be chemically reduced in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankReduction->True,
				Output->Options
			];
			Lookup[options,BlankReduction],
			True,
			Variables:>{options}
		],
		Example[
			{Options,BlankReducingAgent,"Blanks: Specify the reducing agent used to reduce disulfide bridges in proteins to be added to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankReducingAgent->Model[Sample, "2-Mercaptoethanol"],
				Output->Options
			];
			Lookup[options,BlankReducingAgent],
			ObjectReferenceP[Model[Sample, "2-Mercaptoethanol"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankReducingAgentTargetConcentration,"Blanks: Specify the final concentration of the reducing agent in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankReducingAgentTargetConcentration->4.54545VolumePercent,
				Output->Options
			];
			Lookup[options,BlankReducingAgentTargetConcentration],
			4.54545VolumePercent,
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,BlankReducingAgentTargetConcentration,"Blanks: Specify the final concentration of the reducing agent in the blank and calculate the required volume to reach that volume based on the concentration in the Reducing Agent Object:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankReducingAgentTargetConcentration->3.5VolumePercent,
				Output->Options
			];
			Lookup[options,BlankReducingAgentVolume],
			3.5Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,BlankReducingAgentVolume,"Blanks: Specify the volume of the reducing agent required to reach its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankReducingAgentVolume->4.5Microliter,
				Output->Options
			];
			Lookup[options,BlankReducingAgentVolume],
			4.5Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,BlankReducingAgentVolume,"Blanks: Specify the volume of the reducing agent and calculate its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankReducingAgentVolume->4.5Microliter,
				Output->Options
			];
			Lookup[options,BlankReducingAgentTargetConcentration],
			4.5VolumePercent,(* BME is in volume percent, this would be 0.6435 Molar if it were a Molar concentration *)
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,BlankAlkylation,"Blanks: Specify if Alkylation should be applied to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankAlkylation->True,
				Output->Options
			];
			Lookup[options,BlankAlkylation],
			True,
			Variables:>{options}
		],
		Example[
			{Options,BlankAlkylatingAgent,"Blanks: Specify the alkylating agent to be added to the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankAlkylatingAgent->Model[Sample, StockSolution,"250mM Iodoacetamide"],
				Output->Options
			];
			Lookup[options,BlankAlkylatingAgent],
			ObjectReferenceP[Model[Sample, StockSolution,"250mM Iodoacetamide"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankAlkylatingAgentTargetConcentration,"Blanks: Specify the final concentration of the alkylating agent in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankAlkylatingAgentTargetConcentration->11.5Millimolar,
				Output->Options
			];
			Lookup[options,BlankAlkylatingAgentTargetConcentration],
			11.5Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,BlankAlkylatingAgentTargetConcentration,"Blanks: Specify the final concentration of the alkylating agent in the blank and calculate the required volume to reach that concentration based on the alkylating agent object concentration:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankAlkylatingAgentTargetConcentration->11.5Millimolar,
				Output->Options
			];
			Lookup[options,BlankAlkylatingAgentVolume],
			4.8Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,BlankAlkylatingAgentVolume,"Blanks: Specify the volume of the alkylating agent required to reach its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankAlkylatingAgentVolume->4.6 Microliter,
				Output->Options
			];
			Lookup[options,BlankAlkylatingAgentVolume],
			4.6 Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,BlankAlkylatingAgentVolume,"Blanks: Specify the volume of the alkylating agent and calculate its final concentration in the sample:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankAlkylatingAgentVolume->4.6 Microliter,
				Output->Options
			];
			Lookup[options,BlankAlkylatingAgentTargetConcentration],
			10.9358 Millimolar,
			EquivalenceFunction->RoundMatchQ[4],
			Variables:>{options}
		],
		Example[
			{Options,BlankSedimentationSupernatantVolume,"Blanks: Calculate the volume of supernatant to transfer to the assay container from the blank tubes after denaturation and centrifugation based on the total volume in the assay tube:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankSedimentationSupernatantVolume->Automatic,
				Output->Options
			];
			Lookup[options,BlankSedimentationSupernatantVolume],
			RangeP[90Microliter, 90Microliter],
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,BlankSedimentationSupernatantVolume,"Blanks: Specify the volume of supernatant to transfer to the assay container from the blank tubes after denaturation and centrifugation. A minimum of 50 microliters are required for the analysis to proceed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankSedimentationSupernatantVolume->100Microliter,
				Output->Options
			];
			Lookup[options,BlankSedimentationSupernatantVolume],
			100Microliter,
			EquivalenceFunction->RoundMatchQ[2],
			Variables:>{options}
		],
		Example[
			{Options,BlankStorageCondition,"Blank: Specify the non-default storage condition for Blank of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter, BlankStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,BlankStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankInternalReferenceStorageCondition,"Blanks: Specify the non-default storage condition for InternalReference of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankInternalReferenceStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,BlankInternalReferenceStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankConcentratedSDSBufferStorageCondition,"Blanks: Specify the non-default storage condition for ConcentratedSDSBuffer of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankConcentratedSDSBufferStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,BlankConcentratedSDSBufferStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankDiluentStorageCondition,"Blanks: Specify the non-default storage condition for Diluent of this experiment after the protocol is completed:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankDiluentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,BlankDiluentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankSDSBufferStorageCondition,"Blanks: Specify the non-default storage condition for SDSBuffer of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankSDSBufferStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,BlankSDSBufferStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankReducingAgentStorageCondition,"Blanks: Specify the non-default storage condition for ReducingAgent of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankReducingAgentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,BlankReducingAgentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankAlkylatingAgentStorageCondition,"Blanks: Specify the non-default storage condition for AlkylatingAgent of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankAlkylatingAgentStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,BlankAlkylatingAgentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankInjectionVoltageDurationProfile,"Blanks: Specify Series of voltages and durations to apply onto the capillary for injection:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankInjectionVoltageDurationProfile->{{4600Volt,20Second},{4000Volt,30Second}},
				Output->Options
			];
			Lookup[options,BlankInjectionVoltageDurationProfile],
			{{4600Volt,20Second},{4000Volt,30Second}},
			Variables:>{options}
		],
		Example[
			{Options,BlankSeparationVoltageDurationProfile,"Blanks: Specify Series of voltages and durations to apply onto the capillary for separation:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BlankVolume->25Microliter,BlankSeparationVoltageDurationProfile->{{5600Volt,35 Minute}},
				Output->Options
			];
			Lookup[options,BlankSeparationVoltageDurationProfile],
			{{5600Volt,35 Minute}},
			Variables:>{options}
		],
		Example[
			{Options,SamplesInStorageCondition,"Specify the non-default storage condition for SamplesIn of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID],
				SamplesInStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,CartridgeStorageCondition,"Specify the non-default storage condition for the Cartridge of this experiment after samples are transferred to assay tubes:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				CartridgeStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,CartridgeStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		(* --- Messages tests --- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				Quiet[ExperimentCapillaryGelElectrophoresisSDS[sampleID, Simulation -> simulationToPassIn, Output -> Options],{Warning::MissingSampleComposition}]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				Quiet[ExperimentCapillaryGelElectrophoresisSDS[containerID, Simulation -> simulationToPassIn, Output -> Options],{Warning::MissingSampleComposition}]
			],
			{__Rule}
		],
		Example[{Messages,"InputContainsTemporalLinks","Throw a message if given a temporal link:"},
			ExperimentCapillaryGelElectrophoresisSDS[Link[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Now - 1 Minute], Output->Options],
			_List,
			Messages:>{Warning::InputContainsTemporalLinks}
		],
		Example[{Messages,"DiscardedSamples","If the provided sample is discarded, an error will be thrown:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (discarded) "<>$SessionUUID],
				Output->Options],
			_List,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DeprecatedModels","If the provided sample has a deprecated model, an error will be thrown:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test protein 1 (deprecated) "<>$SessionUUID],
				Output->Options],
			_List,
			Messages:>{
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages,"IncompatibleCartridge","If the provided cartridge is not compatible with this experiment, an error will be thrown:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Cartridge->Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCESDS "<>$SessionUUID],
				Output->Options],
			_List,
			Messages:>{
				Error::IncompatibleCartridge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DiscardedCartridge","If a discarded cartridge is set, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
					Cartridge ->Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test discarded Object 1 ExperimentCESDS "<>$SessionUUID],
				Output->Options
			],
			_List,
			Messages:>{
				Error::DiscardedCartridge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InjectionTableMismatch","If an injectionTable is set but is not compatible with samples, ladders, blanks, and standards, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],SampleVolume->5Microliter,
				Ladders -> Model[Sample, "Unstained Protein Standard"],LadderVolume->3Microliter,
				Blanks -> Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],BlankVolume->30Microliter,
				InjectionTable ->
					{{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],30Microliter},
						{Sample, Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],5Microliter},
						{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],30Microliter}},
				Output->Options],
			_List,
			Messages:>{
				Error::InjectionTableMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InjectionTableMismatch","If an injectionTable is set but is not compatible with samples, ladders, blanks, and standards, raise an error but finishes simulation:"},
			ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],Object[Sample, "ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]},
				InjectionTable -> {
					{Sample, Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],5Microliter},
					{Ladder, Object[Sample, "ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID],10Microliter}
				},
				Output->Simulation
			],
			SimulationP,
			Messages:>{
				Error::InjectionTableMismatch,
				Error::MolecularWeightMissing,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InjectionTableReplicatesSpecified","If both an injectionTable and number of replicates are specified, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],SampleVolume->5Microliter,
				Blanks -> Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],BlankVolume->30Microliter,
				NumberOfReplicates->2,
				InjectionTable ->
					{{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],30Microliter},
						{Sample, Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],5Microliter},
						{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],30Microliter}},
				Output->Options],
			_List,
			Messages:>{
				Error::InjectionTableReplicatesSpecified,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InjectionTableVolumeZero","If an injectionTable is specified with volume 0 microliter, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],SampleVolume->5Microliter,
				InjectionTable ->
					{{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],30Microliter},
						{Sample, Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],5Microliter},
						{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],0Microliter}},
				Output->Options],
			_List,
			Messages:>{
				Error::InjectionTableVolumeZero,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TooManyInjectionsCapillaryGelElectrophoresis","If more than 48 injections are required, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				{Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],Object[Sample, "ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]}, NumberOfReplicates->15,
				Ladders -> Model[Sample, "Unstained Protein Standard"], LadderFrequency->3,
				Blanks -> Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],BlankFrequency->3,
				Output->Options],
			_List,
			Messages:>{
				Error::TooManyInjectionsCapillaryGelElectrophoresis,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NotEnoughUsesLeftOnCartridge","If the cartridge object does not have enough uses for the stated samples, blanks, standards, and ladders, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				{Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],Object[Sample, "ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID]}, NumberOfReplicates->5,
				Ladders -> Model[Sample, "Unstained Protein Standard"], LadderFrequency->FirstAndLast,
				Blanks -> Model[Sample, "1% SDS in 100mM Tris, pH 9.5"], BlankFrequency->FirstAndLast,
				Cartridge-> Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 ExperimentCESDS (490 uses) "<>$SessionUUID],
				Output->Options
			],
			_List,
			Messages:>{
				Error::NotEnoughUsesLeftOnCartridge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreMadeMasterMixWithMakeOwnOptions","When options for both PremadeMasterMix and Make-Ones-Own mastermix are passed, raise warning and follow PremadeMaterMix:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMix -> True,PremadeMasterMixReagent ->	Object[Sample, "ExperimentCESDS Test reagent "<>$SessionUUID], Reduction -> True,
				Standards -> Object[Sample, "ExperimentCESDS IgG Standard "<>$SessionUUID],StandardPremadeMasterMix -> True,
				StandardPremadeMasterMixReagent ->Object[Sample, "ExperimentCESDS Test reagent "<>$SessionUUID],StandardReduction -> True,
				Output -> Options
			],
			_List,
			Messages:>{Warning::PreMadeMasterMixWithMakeOwnOptions}
		],
		Example[{Messages, "MissingSampleComposition","When a sample is missing it's composition, forcing a volume estimation, raise warning :"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 5 (100 uL) "<>$SessionUUID],
				Output -> Options
			],
			_List,
			Messages:>{Warning::MissingSampleComposition}
		],
		Example[{Messages, "MissingSampleComposition","When a standard is missing it's composition, forcing a volume estimation, raise warning :"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Standards -> Model[Sample, "Milli-Q water"],
			Output -> Options
			],
			_List,
			Messages:>{Warning::MissingSampleComposition}
		],
		Example[{Messages, "InvalidSupernatantVolume","If PelletSedimentation is True, Supernatatnt volume must be informed:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PelletSedimentation -> True, SedimentationSupernatantVolume -> Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::InvalidSupernatantVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidSupernatantVolume","If PelletSedimentation is True, Supernatatnt volume must be valid:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PelletSedimentation -> True, SedimentationSupernatantVolume -> 150Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::InvalidSupernatantVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CentrifugationForceSpeedMismatch","If SedimentationCentrifugation force and speed aren't compatible, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PelletSedimentation -> True,
				SedimentationCentrifugationSpeed -> 1000 RPM,
				SedimentationCentrifugationForce -> 1000 GravitationalAcceleration,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CentrifugationForceSpeedMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CentrifugationForceSpeedNull","If SedimentationCentrifugation force and speed are Null while PelletSedimentation is True, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PelletSedimentation -> True,
				SedimentationCentrifugationSpeed -> Null,
				SedimentationCentrifugationForce ->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CentrifugationForceSpeedNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PremadeMasterMixReagentNull","If PremadeMasterMix is True and PremadeMasterMixReagent is not informed, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMix -> True, PremadeMasterMixReagent->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::PremadeMasterMixReagentNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PremadeMasterMixDilutionFactorNull","If PremadeMasterMix is True and PremadeMasterMixReagentDilutionFactor is not informed, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMix -> True, PremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
				PremadeMasterMixReagentDilutionFactor-> Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::PremadeMasterMixDilutionFactorNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PremadeMasterMixVolumeNull","If PremadeMasterMix is True and PremadeMasterMixVolume is not informed, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMix -> True, PremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
				PremadeMasterMixVolume-> Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::PremadeMasterMixVolumeNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PremadeMasterMixVolumeDilutionFactorMismatch","If both PremadeMasterMixVolume and PremadeMasterMixReagentDilutionFactor are informed but are not compatible, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				PremadeMasterMix -> True, PremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
				TotalVolume -> 100 Microliter, PremadeMasterMixVolume-> 20Microliter, PremadeMasterMixReagentDilutionFactor->4,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::PremadeMasterMixVolumeDilutionFactorMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PremadeMasterMixInvalidTotalVolume","If both PremadeMasterMixVolume and PremadeMasterMixReagentDilutionFactor are informed but are not compatible, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID], TotalVolume -> 100 Microliter, SampleVolume->50Microliter,
				PremadeMasterMix -> True, PremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
				PremadeMasterMixVolume-> 60Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::PremadeMasterMixInvalidTotalVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PremadeMasterMixDiluentNull","If a PremadeMasterMix diluent is required but set to Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID], TotalVolume -> 100 Microliter, SampleVolume->25Microliter,
				PremadeMasterMix -> True, PremadeMasterMixReagent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
				PremadeMasterMixVolume-> 50Microliter, PremadeMasterMixDiluent->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::PremadeMasterMixDiluentNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InternalReferenceNull","If PremadeMasterMix is False and InternalReference is Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID], InternalReference->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::InternalReferenceNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InternalReferenceDilutionFactorNull","If PremadeMasterMix is False and InternalReferenceDilutionFactor is Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID], InternalReferenceDilutionFactor->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::InternalReferenceDilutionFactorNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InternalReferenceVolumeDilutionFactorMismatch","If PremadeMasterMix is False and InternalReferenceDilutionFactor is Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				TotalVolume-> 100Microliter, InternalReferenceDilutionFactor->25, InternalReferenceVolume->5Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::InternalReferenceVolumeDilutionFactorMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InternalReferenceVolumeNull","If PremadeMasterMix is False and InternalReferenceVolume is Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				InternalReferenceVolume->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::InternalReferenceVolumeNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ReducingAgentNull","If Reduction is True and ReducingAgent is Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Reduction->True, ReducingAgent->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::ReducingAgentNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoReducingAgentIdentified","If Reduction is True and ReducingAgent is unidentified, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Reduction->True, ReducingAgent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID], ReducingAgentVolume->5Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Warning::NoReducingAgentIdentified
			}
		],
		Example[{Messages, "NoReducingAgentIdentified","If Reducing is True and ReducingAgent has no identifiable reducing agent and volume is not given, raise errors:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Alkylation->True, ReducingAgent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],ReducingAgentVolume->Automatic,
				Output -> Options
			],
			_List,
			Messages:>{
				Warning::NoReducingAgentIdentified,
				Error::ReducingAgentTargetConcentrationNull,
				Error::ReducingAgentVolumeNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ReducingAgentTargetConcentrationNull","If Reduction is True and ReducingAgentTargetConcentration is Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Reduction->True, ReducingAgent->Model[Sample, "2-Mercaptoethanol"], ReducingAgentTargetConcentration->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::ReducingAgentTargetConcentrationNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ReducingAgentTargetConcentrationNull","If Reduction is True and ReducingAgentTargetConcentration is Null but volume is specified, don't raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Reduction -> True, ReducingAgent->Model[Sample, "2-Mercaptoethanol"], ReducingAgentTargetConcentration -> Null,ReducingAgentVolume->5 Microliter,
				Output -> Options],
			_List
		],
		Example[{Messages, "ReducingAgentVolumeNull","If Reduction is True and ReducingAgentVolume is Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Reduction -> True, ReducingAgent->Model[Sample, "2-Mercaptoethanol"], ReducingAgentVolume -> Null,
				Output -> Options],
			_List,
			Messages:>{
				Error::ReducingAgentVolumeNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ReducingAgentVolumeConcentrationMismatch","If both ReducingAgentVolume and ReducingAgentTargetConcentration are specified and are not compatible, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Reduction -> True, ReducingAgent->Model[Sample, "2-Mercaptoethanol"], ReducingAgentVolume -> 5 Microliter,ReducingAgentTargetConcentration -> 10VolumePercent,
				Output -> Options],
			_List,
			Messages:>{
				Error::ReducingAgentVolumeConcentrationMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AlkylatingAgentNull","If Alkylation is True and AlkylatingAgent is Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Alkylation->True, AlkylatingAgent->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::AlkylatingAgentNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoAlkylatingAgentIdentified","If Alkylation is True and AlkylatingAgent is unidentified, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Alkylation->True, AlkylatingAgent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID], AlkylatingAgentVolume->5Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Warning::NoAlkylatingAgentIdentified
			}
		],
		Example[{Messages, "NoAlkylatingAgentIdentified","If Alkylating is True and AlkylatingAgent has no identifiable reducing agent and volume is not given, raise errors:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Alkylation->True, AlkylatingAgent->Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],AlkylatingAgentVolume->Automatic,
				Output -> Options
			],
			_List,
			Messages:>{
				Warning::NoAlkylatingAgentIdentified,
				Error::AlkylatingAgentTargetConcentrationNull,
				Error::AlkylatingAgentVolumeNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AlkylatingAgentTargetConcentrationNull","If Alkylation is True and AlkylatingAgentTargetConcentration is Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[
				Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Alkylation->True, AlkylatingAgent->Model[Sample,StockSolution,"250mM Iodoacetamide"], AlkylatingAgentTargetConcentration->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::AlkylatingAgentTargetConcentrationNull,
				Error::AlkylatingAgentVolumeNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AlkylatingAgentTargetConcentrationNull","If Alkylation is True and AlkylatingAgentTargetConcentration is Null but volume is specified, don't raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Alkylation -> True, AlkylatingAgent->Model[Sample,StockSolution,"250mM Iodoacetamide"], AlkylatingAgentTargetConcentration -> Null,AlkylatingAgentVolume->5 Microliter,
				Output -> Options],
			_List
		],
		Example[{Messages, "AlkylatingAgentVolumeNull","If Alkylation is True and AlkylatingAgentVolume is Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Alkylation -> True, AlkylatingAgent->Model[Sample,StockSolution,"250mM Iodoacetamide"], AlkylatingAgentVolume -> Null,
				Output -> Options],
			_List,
			Messages:>{
				Error::AlkylatingAgentVolumeNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AlkylatingAgentVolumeConcentrationMismatch","If both AlkylatingAgentVolume and AlkylatingAgentTargetConcentration are specified and are not compatible, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Alkylation -> True, AlkylatingAgent->Model[Sample,StockSolution,"250mM Iodoacetamide"], AlkylatingAgentVolume -> 5 Microliter,AlkylatingAgentTargetConcentration -> 50Millimolar,
				Output -> Options],
			_List,
			Messages:>{
				Error::AlkylatingAgentVolumeConcentrationMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SDSBufferNull","If both SDSBuffer and ConcentratedSDSBuffer are Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SDSBuffer -> Null, ConcentratedSDSBuffer->Null,
				Output -> Options],
			_List,
			Messages:>{
				Error::SDSBufferNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "BothSDSBufferOptionsSet","If both SDSBuffer and ConcentratedSDSBuffer are set, raise a warning:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				SDSBuffer -> Model[Sample, "1% SDS in 100mM Tris, pH 9.5"], ConcentratedSDSBuffer->Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],
				Output -> Options],
			_List,
			Messages:>{
				Warning::BothSDSBufferOptionsSet
			}
		],
		Example[{Messages, "ConcentratedSDSBufferDilutionFactorNull","If ConcentratedSDSBuffer is set but ConcentratedSDSBufferDilutionFactor is Null, raise a warning and switch to use is as SDSBuffer:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConcentratedSDSBuffer->Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],ConcentratedSDSBufferDilutionFactor->Null,
				Output -> Options],
			_List,
			Messages:>{
				Error::ConcentratedSDSBufferDilutionFactorNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InsufficientSDSinSample","If the SDS final concentration in the assay tube is less than 0.5%, raise a warning:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConcentratedSDSBuffer->Model[Sample, "Milli-Q water"],
				Output -> Options],
			_List,
			Messages:>{
				Warning::InsufficientSDSinSample
			}
		],
		Example[{Messages, "InsufficientSDSinSample","If the SDS final concentration in the assay tube is less than 0.5%, raise a warning:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConcentratedSDSBuffer->Model[Sample,"0.5% SDS in 100mM Tris, pH 9.5 for ExperimentCESDS tests "<>$SessionUUID],
				Output -> Options],
			_List,
			Messages:>{
				Warning::InsufficientSDSinSample
			}
		],
		Example[{Messages, "VolumeGreaterThanTotalVolume","If the sum of all parts does not reach the total volume:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				TotalVolume -> 100 Microliter, SampleVolume -> 30 Microliter,
				InternalReferenceVolume -> 5 Microliter,ReducingAgentVolume -> 5 Microliter,
				AlkylatingAgentVolume -> 5 Microliter,SDSBufferVolume -> 60 Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::VolumeGreaterThanTotalVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ComponentsDontSumToTotalVolume","If the sum of all parts does not reach the total volume:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				TotalVolume -> 100 Microliter, SampleVolume -> 30 Microliter,
				InternalReferenceVolume -> 5 Microliter,ReducingAgentVolume -> 5 Microliter,
				AlkylatingAgentVolume -> 5 Microliter,SDSBufferVolume -> 50 Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::ComponentsDontSumToTotalVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ComponentsDontSumToTotalVolume","If the sum of all parts does not reach the total volume, but used ConcentratedSDSBuffer (difference is filled with Diluent):"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				TotalVolume -> 100 Microliter, SampleVolume -> 30 Microliter,
				InternalReferenceVolume -> 5 Microliter,ReducingAgentVolume -> 5 Microliter,
				AlkylatingAgentVolume -> 5 Microliter,ConcentratedSDSBufferVolume -> 50 Microliter,
				Output -> Options
			],
			_List,
			Messages:>{}
		],
		Example[{Messages, "DiluentNull","If the sum of all parts does not reach the total volume, used ConcentratedSDSBuffer, but Diluent is Null, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				TotalVolume -> 100 Microliter, SampleVolume -> 30 Microliter,
				InternalReferenceVolume -> 5 Microliter,ReducingAgentVolume -> 5 Microliter,
				AlkylatingAgentVolume -> 5 Microliter,ConcentratedSDSBufferVolume -> 50 Microliter,
				Diluent->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::DiluentNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TotalVolumeNull","If the LadderTotalVolume is Null when Ladders are specified, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeLadders->True, LadderVolume -> 10 Microliter, LadderTotalVolume->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::TotalVolumeNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "VolumeNull","If the LadderVolume is Null when Ladders are specified, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeLadders->True, LadderVolume->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::VolumeNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderDilutionFactorNull","If the LadderDilutionFactorNull is Null when Ladders are specified, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeLadders->True, LadderDilutionFactor->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::VolumeNull,
				Error::LadderDilutionFactorNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderDilutionFactorNull","If the LadderDilutionFactorNull is Null when Ladders are specified, but Volume is also passed, don't raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeLadders->True, LadderDilutionFactor->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::VolumeNull,
				Error::LadderDilutionFactorNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FewerLaddersThanUniqueOptionSets","If fewer ladders are specified than distinct separation conditions, warn that it might not apply to all samples:"},
			ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID]},
				Reduction->{True, False},SeparationVoltageDurationProfile->{{{5600Volt,35 Minute}},{{5000Volt,25 Minute}}},
				IncludeLadders->True,Ladders->{Model[Sample, "Unstained Protein Standard"]},
				Output -> Options
			],
			_List,
			Messages:>{
				Warning::FewerLaddersThanUniqueOptionSets
			}
		],
		Example[{Messages, "LadderAnalyteMolecularWeightMismatch","If the LadderAnalyteMolecularWeights are specified but don't match the composition of the ladder, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeLadders->True,
				Ladders->Model[Sample, "Milli-Q water"],
				LadderAnalytes->
						{Model[Molecule, Protein, "id:dORYzZJqX1oE"],
						Model[Molecule, Protein, "id:eGakldJRqjV4"],
						Model[Molecule, Protein, "id:O81aEBZDGPYo"],
						Model[Molecule, Protein, "id:L8kPEjn5qzlE"],
						Model[Molecule, Protein, "id:D8KAEvGL1NXO"],
						Model[Molecule, Protein, "id:KBL5DvwKXNz7"],
						Model[Molecule, Protein, "id:9RdZXv14zmjJ"]},
				LadderAnalyteMolecularWeights->
						{Quantity[10000., ("Grams")/("Moles")],
						Quantity[20000., ("Grams")/("Moles")],
						Quantity[33000., ("Grams")/("Moles")],
						Quantity[55000., ("Grams")/("Moles")],
						Quantity[103000., ("Grams")/("Moles")],
						Quantity[270000., ("Grams")/("Moles")]},
				Output -> Options
			],
			_List,
			Messages:>{
				Error::LadderAnalyteMolecularWeightMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderCompositionMolecularWeightMismatch","If the LadderAnalyteMolecularWeights are specified but don't match the composition of the ladder, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeLadders->True,
				Ladders-> Model[Sample, "Unstained Protein Standard"],
				LadderAnalyteMolecularWeights->
					{Quantity[10000., ("Grams")/("Moles")],
						Quantity[20000., ("Grams")/("Moles")],
						Quantity[33000., ("Grams")/("Moles")],
						Quantity[55000., ("Grams")/("Moles")],
						Quantity[103000., ("Grams")/("Moles")],
						Quantity[270000., ("Grams")/("Moles")]},
				Output -> Options
			],
			_List,
			Messages:>{
				Error::LadderCompositionMolecularWeightMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderAnalytesCompositionMolecularWeightMismatch","If the LadderAnalytes are specified but their molecular weights don't match the composition of the ladder, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeLadders->True,
				Ladders->Model[Sample, "Unstained Protein Standard"],
				LadderAnalytes->
					{Model[Molecule, Protein, "id:dORYzZJqX1oE"],
						Model[Molecule, Protein, "id:eGakldJRqjV4"],
						Model[Molecule, Protein, "id:O81aEBZDGPYo"],
						Model[Molecule, Protein, "id:L8kPEjn5qzlE"],
						Model[Molecule, Protein, "id:D8KAEvGL1NXO"],
						Model[Molecule, Protein, "id:9RdZXv14zmjJ"]},
				Output -> Options
			],
			_List,
			Messages:>{
				Error::LadderAnalytesCompositionMolecularWeightMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MolecularWeightMissing","If the LadderAnalytes are specified but their molecular weights don't match the composition of the ladder, raise an error:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncludeLadders->True,
				Ladders->Model[Sample,"Milli-Q water"],
				Output -> Options
			],
			_List,
			Messages:>{
				Error::MolecularWeightMissing,
				Error::InvalidOption
			}
		],
		(* --- shared options --- *)
		Example[{Options, Template, "Specify a protocol on whose options to Template off of in the new experiment:"},
			ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID]},
				Template -> Object[Protocol, CapillaryGelElectrophoresisSDS, "CESDS Protocol 1 "<>$SessionUUID]],
			ObjectP[Object[Protocol, CapillaryGelElectrophoresisSDS]],
			SetUp:>{ClearMemoization[];}
		],
		Example[{Options, Template, "Specify a protocol on whose options to Template off of in the new experiment:"},
			Download[
				ExperimentCapillaryGelElectrophoresisSDS[{Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID]},
					Template -> Object[Protocol, CapillaryGelElectrophoresisSDS, "CESDS Protocol 1 "<>$SessionUUID]],
				{ReducingAgentTargetConcentrations, TotalVolumes}
			],
			{
				{
					Quantity[4.54545, IndependentUnit["VolumePercent"]],
					Quantity[4.54545, IndependentUnit["VolumePercent"]]
				},
				{
					Quantity[ 200., "Microliters"],
					Quantity[200., "Microliters"]
				}
			},
			EquivalenceFunction -> Equal,
			SetUp:>{ClearMemoization[];}
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			options=ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Name -> "CESDS protocol with Test Sample 1",
				Output->Options
			];
			Lookup[options, Name],
			"CESDS protocol with Test Sample 1",
			Variables :> {options}
		],
		(* --- Sample prep option tests --- *)
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"],
				PreparedModelAmount -> 100 Microliter,
				Output -> Options
			];
			prepUOs = Lookup[options, PreparatoryUnitOperations];
			{
				prepUOs[[-1, 1]][Sample],
				prepUOs[[-1, 1]][Container],
				prepUOs[[-1, 1]][Amount],
				prepUOs[[-1, 1]][Well],
				prepUOs[[-1, 1]][ContainerLabel]
			},
			{
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"]]..},
				{EqualP[100 Microliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs},
			Messages:>{Warning::MissingSampleComposition}
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			options = ExperimentCapillaryGelElectrophoresisSDS["MyProteinMix",
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "MyProteinMix", Container -> Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"]],
					Transfer[Source -> Model[Sample, "Milli-Q water"],Destination -> "MyProteinMix", Amount -> 100 Microliter]},
				Output -> Options
			];
			Lookup[options, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {options},
			Messages:>{Warning::MissingSampleComposition}
		],
		Example[{Options, Incubate, "Set the Incubate option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Set the IncubationTemperature option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Set the IncubationTime option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Set the MaxIncubationTime option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Set the IncubationInstrument option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"],
				Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectReferenceP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Set the AnnealingTime option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "Set the IncubateAliquot option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncubateAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "Set the IncubateAliquotContainer option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
				IncubateAliquotContainer -> Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"],
				Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectReferenceP[Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				IncubateAliquotContainer -> Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"],
				IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, Mix, "Set the Mix option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Set the MixType option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Set the MixUntilDissolved option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],
		(* centrifuge options *)
		Example[{Options, Centrifuge, "Set the Centrifuge option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
					Centrifuge->True,CentrifugeTime -> 40*Minute, CentrifugeTemperature -> 10 Celsius,
					CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "Set the CentrifugeInstrument option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				Centrifuge->True,CentrifugeTime -> 40*Minute, CentrifugeTemperature -> 10 Celsius,
				CentrifugeIntensity -> 1000*RPM,CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"],
				Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectReferenceP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "Set the CentrifugeIntensity option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
					CentrifugeTime -> 40*Minute, CentrifugeTemperature -> 10 Celsius,
					CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "Set the CentrifugeTime option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
					CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "Set the CentrifugeTemperature option:"},
			options =
				ExperimentCapillaryGelElectrophoresisSDS[
					Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
					CentrifugeTime -> 40*Minute, CentrifugeTemperature -> 10 Celsius,
					Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "Set the CentrifugeAliquot option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				Centrifuge->True,CentrifugeTime -> 40*Minute, CentrifugeTemperature -> 10 Celsius,
				CentrifugeIntensity -> 1000*RPM, CentrifugeAliquot -> 1Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			1Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "Set the CentrifugeAliquotContainer option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				CentrifugeAliquotContainer -> Model[Container,Vessel,"1.5mL Tube with 2mL Tube Skirt"],
				Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectReferenceP[Model[Container,Vessel,"1.5mL Tube with 2mL Tube Skirt"]]},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				Centrifuge->True,CentrifugeTime -> 40*Minute, CentrifugeTemperature -> 10 Celsius,
				CentrifugeIntensity -> 1000*RPM, CentrifugeAliquot -> 1Milliliter,CentrifugeAliquotContainer -> Model[Container,Vessel,"1.5mL Tube with 2mL Tube Skirt"],
				CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],

		(* filter options *)
		(* Many options expect an AliquotRequired  warning due to the prefered container in this experiment (a 96-well PCR plate) *)
		Example[{Options, Filtration, "Set the Filtration option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "Set the FiltrationType option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer,PrefilterMaterial->GxF,
				AliquotAmount -> 100*Microliter,FilterPoreSize->0.22Micrometer, FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "Set the FilterInstrument option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				FilterInstrument -> Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],
				Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectReferenceP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "Set the Filter option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Filter -> Model[Item, Filter, "id:n0k9mG8Kqrwp"],
				Output -> Options];
			Lookup[options, Filter],
			ObjectReferenceP[Model[Item, Filter, "id:n0k9mG8Kqrwp"]],
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer,PrefilterMaterial->GxF,
				AliquotAmount -> 100*Microliter,FilterPoreSize->0.22Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "Set the FilterMaterial option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer,PrefilterMaterial->GxF,
				AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, FilterMaterial],
			PTFE,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "Set the PrefilterMaterial option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer,PrefilterMaterial->GxF,
				AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "Set the PrefilterPoreSize option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
					FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer,
					AliquotAmount -> 100*Microliter, Output -> Options];
		Lookup[options, PrefilterPoreSize],
		1.*Micrometer,
		Variables :> {options}
	],
		Example[{Options, FilterSyringe, "Set the FilterSyringe option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer,PrefilterMaterial->GxF,
				AliquotAmount -> 100*Microliter,FilterPoreSize->0.22Micrometer, FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectReferenceP[Model[Container, Syringe]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID], Filtration->True,
				Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "Set the FilterIntensity option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "Set the FilterTime option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "Set the FilterTemperature option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Set the FilterSterile option:"},
			options =ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer,PrefilterMaterial->GxF,
				AliquotAmount -> 100*Microliter, FilterSterile->False, Output -> Options];
			Lookup[options, FilterSterile],
			False,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "Set the FilterAliquot option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				FilterAliquot -> 1Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			1Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "Set the FilterAliquotContainer option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				FilterAliquotContainer -> Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"],
				Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectReferenceP[Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"]]},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 3 (100 uL) "<>$SessionUUID],
				FilterAliquotContainer -> Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"],
				FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "Set the FilterContainerOut option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample, "ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
				FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],
				AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectReferenceP[Model[Container,Vessel,"50mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Set the Aliquot option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "Set the AliquotAmount option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "Set the AssayVolume option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Set the TargetConcentration option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID],
				TargetConcentration -> 10*Milligram/Milliliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			10*Milligram/Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID],
				TargetConcentration -> 10*Milligram/Milliliter, TargetConcentrationAnalyte -> Model[Molecule, Protein, "id:dORYzZJ3l3l5"],
				AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, Protein, "id:dORYzZJ3l3l5"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "Set the ConcentratedBuffer option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "Set the BufferDilutionFactor option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "Set the BufferDiluent option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 0.1 Milliliter,
				AssayVolume -> 0.3 Milliliter,
				Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "Set the AssayBuffer option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "Set the AliquotSampleStorageCondition option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Set the ConsolidateAliquots option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Set the AliquotPreparation option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "Set the AliquotContainer option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				AliquotContainer -> Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"],
				Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"]]}},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				DestinationWell -> "A1", Output -> Options];
			Lookup[options, DestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Set the ImageSample option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Set the MeasureWeight option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Set the MeasureVolume option:"},
			options = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, Output, "Simulation is returned when Output-> Simulation is specified:"},
			ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
				Output -> Simulation],
			SimulationP
		]
	},
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True(*,
		$DeveloperSearch = True*)
	},
	SetUp:>( (* before and after EVERY test *)
		$CreatedObjects={}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp:>( (* create objects for tests, runs once before everything *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::AliquotRequired];
		Off[Error::InsufficientTotalVolume];

		ClearMemoization[];
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container,Bench,"Unit Test bench for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 1 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 2 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 3 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 4 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 5 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 6 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 7 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 8 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 9 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 10 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Plate,"Unit Test container for reagents in ExperimentCESDS tests "<>$SessionUUID],
					Model[Sample,"Unit Test Model for ExperimentCESDS (deprecated) "<>$SessionUUID ],
					Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
					Model[Sample,"Unit Test 100 mg/mL bActin"],
					Model[Sample,"Unit Test 0.24 mM bActin model"],
					Model[Sample,"0.5% SDS in 100mM Tris, pH 9.5 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test protein 1 (deprecated) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 1 (discarded) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test model-less sample 1 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 3 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 4 (250 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 5 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test 14.3M 2-mercaptoethanol "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test 250mM Iodoacetamide "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test 1% SDS in 100mM Tris, pH 9.5 "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test Molecular weight ladder "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS IgG Standard "<>$SessionUUID],
					Object[Item,Consumable,"ExperimentCESDS Test CESDS Running Buffer - Top "<>$SessionUUID],
					Object[Item,Consumable,"test CleanupCartridge "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Running Buffer - Bottom "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Separation Matrix "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Conditioning Acid "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Conditioning Base "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Internal Standard 25X "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Wash Solution "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS 0.5% SDS "<>$SessionUUID],
					Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert,"ExperimentCESDS test CESDS cartridge Insert "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ExperimentCESDS "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test discarded Object 1 ExperimentCESDS "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 ExperimentCESDS (490 uses) "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCESDS "<>$SessionUUID],
					Object[Protocol, CapillaryGelElectrophoresisSDS, "CESDS Protocol 1 "<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
		Block[{$AllowSystemsProtocols=True},(* must use Block here, rather than With, With wont set it back to original value *)
			Module[
				{fakeBench,container,container2,container3,container4,container5,sampleModel4,
					sample,sample2,sample3,sample4,sample5,container6,sample6,container7,sample7,container8,sample8,
					sampleModel,sampleModel1,sampleModel2,sampleModel3,container9,sample9,sample10,sample11,container10,cartridge3,cartridge4,
					cartridge1,cartridge2,allObjects,fakeProtocol1,
					completeTheFakeProtocol,fakeProtSubObjs,reagentContainer, bme,iam,sampleBuffer,ladder,igGStd,runningBufferTop,runningBufferBottom,
					sepMatrix,condAcid,condBase,intStd,washSolution,cartridgeInsert,cleanupCartridge,halfSampleBuffer},

				(* before everything we make sure the instrument is clear of anything. we do that only if we're not on production to avoid unfortunate mistakes *)
				(* TODO: make fake instrument object *)
				If[!ProductionQ[],
					Upload[<|Object->Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"], Replace[Contents]->{}|>]
				];

				sampleModel=UploadSampleModel["Unit Test Model for ExperimentCESDS (deprecated) "<>$SessionUUID,
					Composition->{
						{100 VolumePercent,
							Model[Molecule,Protein,"Unknown Protein - 10 KDa"]}
					},
					SingleUse->True,
					State->Liquid,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					Expires->True,
					ShelfLife->12 Month,
					UnsealedShelfLife->9 Month
				];
				sampleModel1=UploadSampleModel[ "Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID,
					Composition->{
						{100 VolumePercent,Model[Molecule,"Water"]},
						{10 Milligram/Milliliter,Model[Molecule,Protein,"id:o1k9jAGP83Ba"]}
					},
					State->Liquid,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					Expires->True,
					ShelfLife->1 Month,
					UnsealedShelfLife->2 Week,
					MSDSFile -> NotApplicable,
					Flammable->False,
					BiosafetyLevel->"BSL-1",
					IncompatibleMaterials->{None}
				];
				sampleModel2=UploadSampleModel[ "Unit Test 100 mg/mL bActin",
					Composition->{
						{100 VolumePercent,Model[Molecule,"Water"]},
						{100 Milligram/Milliliter,Model[Molecule,Protein,"BActin"]}
					},
					State->Liquid,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					Expires->True,
					ShelfLife->1 Month,
					UnsealedShelfLife->2 Week,
					MSDSFile -> NotApplicable,
					Flammable->False,
					BiosafetyLevel->"BSL-1",
					IncompatibleMaterials->{None}
				];
				sampleModel3=UploadSampleModel[ "Unit Test 0.24 mM bActin model",
					Composition->{
						{100 VolumePercent,Model[Molecule,"Water"]},
						{0.24 Millimolar,Model[Molecule,Protein,"BActin"]}
					},
					State->Liquid,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					Expires->True,
					ShelfLife->1 Month,
					UnsealedShelfLife->2 Week,
					MSDSFile -> NotApplicable,
					Flammable->False,
					BiosafetyLevel->"BSL-1",
					IncompatibleMaterials->{None}
				];
				sampleModel4=UploadSampleModel["0.5% SDS in 100mM Tris, pH 9.5 for ExperimentCESDS tests "<>$SessionUUID,
					Composition->{
						{100Millimolar,Model[Molecule, "id:01G6nvwRWR0d"]},
						{0.5MassPercent,Model[Molecule, "id:Y0lXejMq5eRl"]}},
					State->Liquid,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					Expires->True,
					ShelfLife->1 Month,
					UnsealedShelfLife->2 Week,
					MSDSFile -> NotApplicable,
					Flammable->False,
					BiosafetyLevel->"BSL-1",
					IncompatibleMaterials->{None}
				];
				(* TODO: Combine to one upload *)
				fakeBench=Upload[
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Unit Test bench for ExperimentCESDS tests "<>$SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				cartridge1=
					Upload[<|Name->
						"CESDS-Plus Cartridge test Object 1 for ExperimentCESDS "<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model->
							Link[Model[Container,ProteinCapillaryElectrophoresisCartridge,
								"CESDS-Plus"],Objects],
						NumberOfUses->75,
						DeveloperObject->True, Status->Available,
						Site -> Link[$Site]|>];
				cartridge2=
					Upload[<|Name->"cIEF Cartridge test Object 1 for ExperimentCESDS "<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model->
							Link[Model[Container,ProteinCapillaryElectrophoresisCartridge,
								"cIEF"],Objects],
						NumberOfUses->25,
						DeveloperObject->True, Status->Available,
						Site -> Link[$Site]|>];
				cartridge3=
					Upload[<|Name->
						"CESDS-Plus Cartridge test discarded Object 1 ExperimentCESDS "<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model->
							Link[Model[Container,ProteinCapillaryElectrophoresisCartridge,
								"CESDS-Plus"],Objects],
						NumberOfUses->25,
						Status->Discarded,
						DeveloperObject->True,
						Site -> Link[$Site]|>];
				cartridge4=
					Upload[<|Name->
						"CESDS-Plus Cartridge test Object 1 ExperimentCESDS (490 uses) "<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model->
							Link[Model[Container,ProteinCapillaryElectrophoresisCartridge,
								"CESDS-Plus"],Objects],
						NumberOfUses->490,
						DeveloperObject->True, Status->Available,
						Site -> Link[$Site]|>];
				runningBufferTop= Upload[<|Type -> Object[Item, Consumable],
					Model -> Link[
						Model[Item, Consumable,
							"Prefilled Top Running Buffer Vial"], Objects],
					Name -> "ExperimentCESDS Test CESDS Running Buffer - Top "<>$SessionUUID,
					DeveloperObject -> True,
					StorageCondition ->
						Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfUses -> 0, Status -> Available,
					Site -> Link[$Site]|>];

				cartridgeInsert = Upload@<|
					Type ->Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert],
					Model ->Link[Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert, "CESDS Cartridge Insert"], Objects],
					Name -> "ExperimentCESDS test CESDS cartridge Insert "<>$SessionUUID,
					Status -> Available,
					DeveloperObject->True,
					Site -> Link[$Site]
				|>;

				{
					container,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					container9,
					container10,
					reagentContainer
				}=UploadSample[
					{
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}

					},
					Status->Available,
					Name->{
						"Unit Test container 1 for ExperimentCESDS tests "<>$SessionUUID,
						"Unit Test container 2 for ExperimentCESDS tests "<>$SessionUUID,
						"Unit Test container 3 for ExperimentCESDS tests "<>$SessionUUID,
						"Unit Test container 4 for ExperimentCESDS tests "<>$SessionUUID,
						"Unit Test container 5 for ExperimentCESDS tests "<>$SessionUUID,
						"Unit Test container 6 for ExperimentCESDS tests "<>$SessionUUID,
						"Unit Test container 7 for ExperimentCESDS tests "<>$SessionUUID,
						"Unit Test container 8 for ExperimentCESDS tests "<>$SessionUUID,
						"Unit Test container 9 for ExperimentCESDS tests "<>$SessionUUID,
						"Unit Test container 10 for ExperimentCESDS tests "<>$SessionUUID,
						"Unit Test container for reagents in ExperimentCESDS tests "<>$SessionUUID
					}
				];
				{
					(*1*)sample,
					(*2*)sample2,
					(*3*)sample3,
					(*4*)sample4,
					(*5*)sample5,
					(*6*)sample6,
					(*7*)sample7,
					(*8*)sample8,
					(*9*)sample9,
					(*10*)sample10,
					(*11*)sample11,
					(*12*)bme,
					(*13*)iam,
					(*14*)sampleBuffer,
					(*15*)ladder,
					(*16*)igGStd,
					(*17*)runningBufferBottom,
					(*18*)sepMatrix,
					(*19*)condAcid,
					(*20*)condBase,
					(*21*)intStd,
					(*22*)washSolution,
					(*23*)halfSampleBuffer
				}=UploadSample[
					{
						(*1*)Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
						(*2*)Model[Sample,"Unit Test Model for ExperimentCESDS (deprecated) "<>$SessionUUID],
						(*3*)Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
						(*4*)Model[Sample,"Unit Test 100 mg/mL bActin"],
						(*5*)Model[Sample,"Unit Test 0.24 mM bActin model"],
						(*6*)Model[Sample,"Unit Test 100 mg/mL bActin"],
						(*7*)Model[Sample,StockSolution, "Resuspended CESDS IgG Standard"],
						(*8*)Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
						(*9*)Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
						(*10*)Model[Sample,"Milli-Q water"],
						(*11*)Model[Sample,"Unit Test 100 mg/mL bActin"],
						(*12*)Model[Sample,"2-Mercaptoethanol"],
						(*13*)Model[Sample, StockSolution,"250mM Iodoacetamide"],
						(*15*)Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
						(*16*)Model[Sample, "Unstained Protein Standard"],
						(*17*)Model[Sample,StockSolution, "Resuspended CESDS IgG Standard"],
						(*18*)Model[Sample,"CESDS Running Buffer - Bottom"],
						(*19*)Model[Sample,"CESDS Separation Matrix"],
						(*20*)Model[Sample,"CESDS Conditioning Acid"],
						(*21*)Model[Sample,"CESDS Conditioning Base"],
						(*22*)Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"],
						(*23*)Model[Sample,"CESDS Wash Solution"],
						Model[Sample,"0.5% SDS in 100mM Tris, pH 9.5 for ExperimentCESDS tests "<>$SessionUUID]
					},
					{
						(*1*){"A1",container},
						(*2*){"A1",container2},
						(*3*){"A1",container3},
						(*4*){"A1",container4},
						(*5*){"A1",container5},
						(*6*){"A1",container6},
						(*7*){"A1",container7},
						(*8*){"A1",container8},
						(*9*){"A1",container9},
						(*10*){"B1",reagentContainer},
						(*11*){"A1",container10},
						(*12*){"A1",reagentContainer},
						(*13*){"A2",reagentContainer},
						(*14*){"A3",reagentContainer},
						(*15*){"A4",reagentContainer},
						(*16*){"A5",reagentContainer},
						(*17*){"A7",reagentContainer},
						(*18*){"A8",reagentContainer},
						(*19*){"A9",reagentContainer},
						(*20*){"A10",reagentContainer},
						(*21*){"A11",reagentContainer},
						(*22*){"A12",reagentContainer},
						(*22*){"C12",reagentContainer}
					},
					InitialAmount->{
						(*1*)200*Microliter,
						(*2*)100*Microliter,
						(*3*)100*Microliter,
						(*4*)100*Microliter,
						(*5*)100*Microliter,
						(*6*)500*Microliter,
						(*7*)500*Microliter,
						(*8*)20*Milliliter,
						(*9*)250*Microliter,
						(*10*)100*Microliter,
						(*11*)100*Microliter,
						(*12*)2*Milliliter,
						(*13*)2*Milliliter,
						(*14*)2*Milliliter,
						(*15*)2*Milliliter,
						(*16*)2*Milliliter,
						(*17*)2*Milliliter,
						(*18*)2*Milliliter,
						(*19*)2*Milliliter,
						(*20*)2*Milliliter,
						(*21*)2*Milliliter,
						(*21*)2*Milliliter,
						(*22*)2*Milliliter
					},
					Name->{
						(*1*)"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID,
						(*2*)"ExperimentCESDS Test protein 1 (deprecated) "<>$SessionUUID,
						(*3*)"ExperimentCESDS Test sample 1 (discarded) "<>$SessionUUID ,
						(*4*)"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID,
						(*5*)"ExperimentCESDS Test sample 3 (100 uL) "<>$SessionUUID,
						(*6*)"ExperimentCESDS Test reagent "<>$SessionUUID,
						(*7*)"ExperimentCESDS IgG Standard "<>$SessionUUID,
						(*8*)"ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID,
						(*9*)"ExperimentCESDS Test sample 4 (250 uL) "<>$SessionUUID,
						(*10*)"ExperimentCESDS Test sample 5 (100 uL) "<>$SessionUUID,
						(*11*)"ExperimentCESDS Test model-less sample 1 (100 uL) "<>$SessionUUID,
						(*12*)"ExperimentCESDS Test 14.3M 2-mercaptoethanol "<>$SessionUUID,
						(*13*)"ExperimentCESDS Test 250mM Iodoacetamide "<>$SessionUUID,
						(*14*)"ExperimentCESDS Test 1% SDS in 100mM Tris, pH 9.5 "<>$SessionUUID,
						(*15*)"ExperimentCESDS Test Molecular weight ladder "<>$SessionUUID,
						(*16*)"ExperimentCESDS Test CESDS IgG Standard "<>$SessionUUID,
						(*17*)"ExperimentCESDS Test CESDS Running Buffer - Bottom "<>$SessionUUID,
						(*18*)"ExperimentCESDS Test CESDS Separation Matrix "<>$SessionUUID,
						(*19*)"ExperimentCESDS Test CESDS Conditioning Acid "<>$SessionUUID,
						(*20*)"ExperimentCESDS Test CESDS Conditioning Base "<>$SessionUUID,
						(*21*)"ExperimentCESDS Test CESDS Internal Standard 25X "<>$SessionUUID,
						(*22*)"ExperimentCESDS Test CESDS Wash Solution "<>$SessionUUID,
						(*23*)"ExperimentCESDS Test CESDS 0.5% SDS "<>$SessionUUID
					},
					StorageCondition->{
						(*1*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*2*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*3*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*4*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*5*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*6*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*7*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*8*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*9*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*10*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*11*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*12*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*13*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*14*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*15*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*16*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*17*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*18*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*19*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*20*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*21*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*22*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*22*)Link[Model[StorageCondition,"Ambient Storage"]]
					}
				];

				cleanupCartridge = Upload@<|
					Type -> Object[Item, Consumable],
					Model ->Link[Model[Item, Consumable,"CESDS Cartridge Cleanup Column"], Objects],
					Name ->"test CleanupCartridge "<>$SessionUUID,
					StorageCondition ->Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfUses -> 0,
					Status -> Available,
					Site -> Link[$Site]
				|>;

				(* upload other items needed for testing the protocol All of those are Developer object -> True AwaitingStorageUpdate-> Null so that they are not treated as real objects in lab if messed something up *)
				allObjects=Cases[Flatten[{container,container2,container3,container4,container5,sample,sample2,sample4,sample10,sample11,
					sample5,cartridge1,cartridge2,container6,sample6,container7,sample7,container8,sample8,container9,sample9, reagentContainer,
					bme,iam,sampleBuffer,ladder,igGStd,runningBufferBottom,sepMatrix,condAcid,condBase,intStd,washSolution,cleanupCartridge}],ObjectP[]];
				Upload[<|Object->#,DeveloperObject->True,AwaitingStorageUpdate->Null|> &/@allObjects];
				Upload[<|Object->cleanupCartridge,DeveloperObject->Null|>];
				Upload[Cases[Flatten[{
					<|Object->sample2, Replace[Composition]->{{10 Milligram/Milliliter,Link[Model[Molecule,Protein,"id:n0k9mG8npLLw"]],Now}}|>,
					<|Object->sample3,Status->Discarded,Model->Null|>,
					<|Object->sampleModel,Deprecated->True,DeveloperObject->True|>,
					<|Object->sample11,Model->Null,DeveloperObject->True|>,
					<|Object->sample7,DeveloperObject->True,Replace[Composition]->{{10 Milligram/Milliliter,Link[Model[Molecule,Protein,"id:n0k9mG8npLLw"]],Now}}|>
				}],PacketP[]]];
				fakeProtocol1 = ExperimentCapillaryGelElectrophoresisSDS[Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID], Name -> "CESDS Protocol 1 "<>$SessionUUID, Confirm -> True, Reduction->True, TotalVolume->200Microliter];
				completeTheFakeProtocol = UploadProtocolStatus[fakeProtocol1, Completed, FastTrack -> True];
				fakeProtSubObjs = Flatten[Download[fakeProtocol1, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]];
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ Cases[Flatten[{fakeProtocol1, fakeProtSubObjs}], ObjectP[]]];
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::AliquotRequired];
		ClearMemoization[];

		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container,Bench,"Unit Test bench for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 1 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 2 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 3 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 4 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 5 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 6 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 7 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 8 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 9 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 10 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Container,Plate,"Unit Test container for reagents in ExperimentCESDS tests "<>$SessionUUID],
					Model[Sample,"Unit Test Model for ExperimentCESDS (deprecated) "<>$SessionUUID ],
					Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
					Model[Sample,"Unit Test 100 mg/mL bActin"],
					Model[Sample,"Unit Test 0.24 mM bActin model"],
					Model[Sample,"0.5% SDS in 100mM Tris, pH 9.5 for ExperimentCESDS tests "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test protein 1 (deprecated) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 1 (discarded) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 1 (200 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test model-less sample 1 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 2 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 3 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test reagent "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS IgG Standard "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 1 (20 mL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 4 (250 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test sample 5 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test 14.3M 2-mercaptoethanol "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test 250mM Iodoacetamide "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test 1% SDS in 100mM Tris, pH 9.5 "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test Molecular weight ladder "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS IgG Standard "<>$SessionUUID],
					Object[Item,Consumable,"ExperimentCESDS Test CESDS Running Buffer - Top "<>$SessionUUID],
					Object[Item,Consumable,"test CleanupCartridge "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Running Buffer - Bottom "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Separation Matrix "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Conditioning Acid "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Conditioning Base "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Internal Standard 25X "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS Wash Solution "<>$SessionUUID],
					Object[Sample,"ExperimentCESDS Test CESDS 0.5% SDS "<>$SessionUUID],
					Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert,"ExperimentCESDS test CESDS cartridge Insert "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ExperimentCESDS "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test discarded Object 1 ExperimentCESDS "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 ExperimentCESDS (490 uses) "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCESDS "<>$SessionUUID],
					Object[Protocol, CapillaryGelElectrophoresisSDS, "CESDS Protocol 1 "<>$SessionUUID],
					Lookup[Object[Protocol, CapillaryGelElectrophoresisSDS, "CESDS Protocol 1 "<>$SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
	)
];



(* ::Subsection:: *)
(*ValidExperimentCapillaryGelElectrophoresisSDSQ*)

DefineTests[ValidExperimentCapillaryGelElectrophoresisSDSQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of a capillary gel electrophoresis SDS experiment:"},
			ValidExperimentCapillaryGelElectrophoresisSDSQ[Object[Sample,"ValidExperimentCESDSQ Test sample 1 (100 uL) "<>$SessionUUID]],
			True,
			Stubs:>{
			}
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentCapillaryGelElectrophoresisSDSQ[Object[Sample,"ValidExperimentCESDSQ Test sample 1 (discarded) "<>$SessionUUID]],
			False
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentCapillaryGelElectrophoresisSDSQ[Object[Sample,"ValidExperimentCESDSQ Test sample 1 (discarded) "<>$SessionUUID],
				Verbose->True
			],
			False
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentCapillaryGelElectrophoresisSDSQ[Object[Sample,"ValidExperimentCESDSQ Test sample 1 (discarded) "<>$SessionUUID],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		]
	},
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True,
		$DeveloperSearch = True
	},
	SetUp:>( (* before and after EVERY test *)
		$CreatedObjects={};
		ClearMemoization[];
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp:>( (* create objects for tests, runs once before everything *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::AliquotRequired];
		ClearMemoization[];
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container,Bench,"Unit Test bench for ValidExperimentCESDSQ tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 1 for ValidExperimentCESDSQ tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 2 for ValidExperimentCESDSQ tests "<>$SessionUUID],
					Object[Container,Plate,"Unit Test container for reagents in ValidExperimentCESDSQ tests "<>$SessionUUID],
					Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test sample 1 (discarded) "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test sample 1 (100 uL) "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test 14.3M 2-mercaptoethanol "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test 250mM Iodoacetamide "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test 1% SDS in 100mM Tris, pH 9.5 "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test Molecular weight ladder "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS IgG Standard "<>$SessionUUID],
					Object[Item,Consumable,"ValidExperimentCESDSQ Test CESDS Running Buffer - Top "<>$SessionUUID],
					Object[Item,Consumable,"ValidExperimentCESDSQ test CleanupCartridge "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Running Buffer - Bottom "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Separation Matrix "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Conditioning Acid "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Conditioning Base "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Internal Standard 25X "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Wash Solution "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS 0.5% SDS "<>$SessionUUID],
					Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert,"ValidExperimentCESDSQ test CESDS cartridge Insert "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ValidExperimentCESDSQ  "<>$SessionUUID<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ValidExperimentCESDSQ "<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
		Block[{$AllowSystemsProtocols=True},(* must use Block here, rather than With, With wont set it back to original value *)
			Module[
				{
					fakeBench,container,container2,sample,sample2,cartridge1,cartridge2,reagentContainer,bme,iam,
					sampleBuffer,ladder,igGStd,runningBufferBottom,sepMatrix,condAcid,condBase,intStd,washSolution,
					cleanupCartridge,allObjects,runningBufferTop,cartridgeInsert,sampleModel,sampleModel1
				},

				sampleModel1=UploadSampleModel[ "Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID,
					Composition->{
						{100 VolumePercent,Model[Molecule,"Water"]},
						{10 Milligram/Milliliter,Model[Molecule,Protein,"id:o1k9jAGP83Ba"]}
					},
					State->Liquid,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					Expires->True,
					ShelfLife->1 Month,
					UnsealedShelfLife->2 Week,
					MSDSFile -> NotApplicable,
					Flammable->False,
					BiosafetyLevel->"BSL-1",
					IncompatibleMaterials->{None}
				];

				fakeBench=Upload[
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Unit Test bench for ValidExperimentCESDSQ tests "<>$SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				cartridge1=
					Upload[<|Name->
						"CESDS-Plus Cartridge test Object 1 for ValidExperimentCESDSQ  "<>$SessionUUID<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model->
							Link[Model[Container,ProteinCapillaryElectrophoresisCartridge,
								"CESDS-Plus"],Objects],
						NumberOfUses->75,
						DeveloperObject->True, Status->Available,
						Site -> Link[$Site]|>];
				cartridge2=
					Upload[<|Name->"cIEF Cartridge test Object 1 for ValidExperimentCESDSQ "<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model->
							Link[Model[Container,ProteinCapillaryElectrophoresisCartridge,
								"cIEF"],Objects],
						NumberOfUses->25,
						DeveloperObject->True, Status->Available,
						Site -> Link[$Site]|>];

				cartridgeInsert = Upload@<|
					Type ->Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert],
					Model ->Link[Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert, "CESDS Cartridge Insert"], Objects],
					Name -> "ValidExperimentCESDSQ test CESDS cartridge Insert "<>$SessionUUID,
					Status -> Available,
					DeveloperObject->True,
					Site -> Link[$Site]
				|>;

				{
					container,
					container2,
					reagentContainer
				}=UploadSample[
					{
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}

					},
					Status->Available,
					Name->{
						"Unit Test container 1 for ValidExperimentCESDSQ tests "<>$SessionUUID,
						"Unit Test container 2 for ValidExperimentCESDSQ tests "<>$SessionUUID,
						"Unit Test container for reagents in ValidExperimentCESDSQ tests "<>$SessionUUID
					}
				];

				{
					(*1*)sample,
					(*2*)sample2,
					(*12*)bme,
					(*13*)iam,
					(*14*)sampleBuffer,
					(*15*)ladder,
					(*16*)igGStd,
					(*17*)runningBufferBottom,
					(*18*)sepMatrix,
					(*19*)condAcid,
					(*20*)condBase,
					(*21*)intStd,
					(*22*)washSolution
				}=UploadSample[
					{
						(*1*)Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
						(*1*)Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
						(*12*)Model[Sample,"2-Mercaptoethanol"],
						(*13*)Model[Sample, StockSolution,"250mM Iodoacetamide"],
						(*15*)Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
						(*16*)Model[Sample, "Unstained Protein Standard"],
						(*17*)Model[Sample,StockSolution, "Resuspended CESDS IgG Standard"],
						(*18*)Model[Sample,"CESDS Running Buffer - Bottom"],
						(*19*)Model[Sample,"CESDS Separation Matrix"],
						(*20*)Model[Sample,"CESDS Conditioning Acid"],
						(*21*)Model[Sample,"CESDS Conditioning Base"],
						(*22*)Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"],
						(*23*)Model[Sample,"CESDS Wash Solution"]
					},
					{
						(*1*){"A1",container},
						(*2*){"A1",container2},
						(*12*){"A1",reagentContainer},
						(*13*){"A2",reagentContainer},
						(*14*){"A3",reagentContainer},
						(*15*){"A4",reagentContainer},
						(*16*){"A5",reagentContainer},
						(*17*){"A7",reagentContainer},
						(*18*){"A8",reagentContainer},
						(*19*){"A9",reagentContainer},
						(*20*){"A10",reagentContainer},
						(*21*){"A11",reagentContainer},
						(*22*){"A12",reagentContainer}
					},
					InitialAmount->{
						(*1*)100*Microliter,
						(*2*)100*Microliter,
						(*12*)2*Milliliter,
						(*13*)2*Milliliter,
						(*14*)2*Milliliter,
						(*15*)2*Milliliter,
						(*16*)2*Milliliter,
						(*17*)2*Milliliter,
						(*18*)2*Milliliter,
						(*19*)2*Milliliter,
						(*20*)2*Milliliter,
						(*21*)2*Milliliter,
						(*22*)2*Milliliter
					},
					Name->{
						(*1*)"ValidExperimentCESDSQ Test sample 1 (100 uL) "<>$SessionUUID,
						(*2*)"ValidExperimentCESDSQ Test sample 1 (discarded) "<>$SessionUUID,
						(*12*)"ValidExperimentCESDSQ Test 14.3M 2-mercaptoethanol "<>$SessionUUID,
						(*13*)"ValidExperimentCESDSQ Test 250mM Iodoacetamide "<>$SessionUUID,
						(*14*)"ValidExperimentCESDSQ Test 1% SDS in 100mM Tris, pH 9.5 "<>$SessionUUID,
						(*15*)"ValidExperimentCESDSQ Test Molecular weight ladder "<>$SessionUUID,
						(*16*)"ValidExperimentCESDSQ Test CESDS IgG Standard "<>$SessionUUID,
						(*17*)"ValidExperimentCESDSQ Test CESDS Running Buffer - Bottom "<>$SessionUUID,
						(*18*)"ValidExperimentCESDSQ Test CESDS Separation Matrix "<>$SessionUUID,
						(*19*)"ValidExperimentCESDSQ Test CESDS Conditioning Acid "<>$SessionUUID,
						(*20*)"ValidExperimentCESDSQ Test CESDS Conditioning Base "<>$SessionUUID,
						(*21*)"ValidExperimentCESDSQ Test CESDS Internal Standard 25X "<>$SessionUUID,
						(*22*)"ValidExperimentCESDSQ Test CESDS Wash Solution "<>$SessionUUID
					},
					StorageCondition->{
						(*1*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*2*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*12*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*13*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*14*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*15*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*16*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*17*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*18*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*19*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*20*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*21*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*22*)Link[Model[StorageCondition,"Ambient Storage"]]
					}
				];

				cleanupCartridge = Upload@<|
					Type -> Object[Item, Consumable],
					Model ->Link[Model[Item, Consumable,"CESDS Cartridge Cleanup Column"], Objects],
					Name ->"ValidExperimentCESDSQ test CleanupCartridge "<>$SessionUUID,
					StorageCondition ->Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfUses -> 0,
					Status -> Available,
					Site -> Link[$Site]
				|>;

				runningBufferTop= Upload[<|Type -> Object[Item, Consumable],
					Model -> Link[
						Model[Item, Consumable,
							"Prefilled Top Running Buffer Vial"], Objects],
					Name -> "ValidExperimentCESDSQ Test CESDS Running Buffer - Top "<>$SessionUUID,
					DeveloperObject -> True,
					StorageCondition ->
						Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfUses -> 0, Status -> Available,
					Site -> Link[$Site]|>];

				(* upload other items needed for testing the protocol All of those are Developer object -> True AwaitingStorageUpdate-> Null so that they are not treated as real objects in lab if messed something up *)
				allObjects=Cases[Flatten[{container,container2,sample,sample2,cartridge1,cartridge2,reagentContainer,
					bme,iam,sampleBuffer,ladder,igGStd,runningBufferBottom,sepMatrix,condAcid,condBase,intStd,washSolution,
					cleanupCartridge}],ObjectP[]];
				Upload[<|Object->#,DeveloperObject->True,AwaitingStorageUpdate->Null|> &/@allObjects];
				Upload[Cases[Flatten[{
					<|Object->sample2, Status->Discarded,Model->Null|>
				}],PacketP[]]];
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::AliquotRequired];
		ClearMemoization[];
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container,Bench,"Unit Test bench for ValidExperimentCESDSQ tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 1 for ValidExperimentCESDSQ tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit Test container 2 for ValidExperimentCESDSQ tests "<>$SessionUUID],
					Object[Container,Plate,"Unit Test container for reagents in ValidExperimentCESDSQ tests "<>$SessionUUID],
					Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test sample 1 (discarded) "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test sample 1 (100 uL) "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test 14.3M 2-mercaptoethanol "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test 250mM Iodoacetamide "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test 1% SDS in 100mM Tris, pH 9.5 "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test Molecular weight ladder "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS IgG Standard "<>$SessionUUID],
					Object[Item,Consumable,"ValidExperimentCESDSQ Test CESDS Running Buffer - Top "<>$SessionUUID],
					Object[Item,Consumable,"ValidExperimentCESDSQ test CleanupCartridge "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Running Buffer - Bottom "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Separation Matrix "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Conditioning Acid "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Conditioning Base "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Internal Standard 25X "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS Wash Solution "<>$SessionUUID],
					Object[Sample,"ValidExperimentCESDSQ Test CESDS 0.5% SDS "<>$SessionUUID],
					Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert,"ValidExperimentCESDSQ test CESDS cartridge Insert "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ValidExperimentCESDSQ  "<>$SessionUUID<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ValidExperimentCESDSQ "<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentCapillaryGelElectrophoresisSDSOptions*)


DefineTests[
	ExperimentCapillaryGelElectrophoresisSDSOptions,
	{
		Example[{Basic,"Display the option values which will be used in the capillary Gel Electrophoresis SDS experiment:"},
			ExperimentCapillaryGelElectrophoresisSDSOptions[Object[Sample,"ExperimentCESDSOptions Test sample 1 (100 uL)" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentCapillaryGelElectrophoresisSDSOptions[Object[Sample,"ExperimentCESDSOptions Test sample 1 (discarded)" <> $SessionUUID]],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentCapillaryGelElectrophoresisSDSOptions[Object[Sample,"ExperimentCESDSOptions Test sample 1 (100 uL)" <> $SessionUUID],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True,
		$DeveloperSearch = True
	},
	SetUp:>( (* before and after EVERY test *)
		$CreatedObjects={};
		ClearMemoization[];
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp:>( (* create objects for tests, runs once before everything *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::AliquotRequired];
		ClearMemoization[];
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container,Bench,"Unit Test bench for ExperimentCESDSOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Unit Test container 1 for ExperimentCESDSOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Unit Test container 2 for ExperimentCESDSOptions tests" <> $SessionUUID],
					Object[Container,Plate,"Unit Test container for reagents in ExperimentCESDSOptions tests" <> $SessionUUID],
					Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test sample 1 (discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test sample 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test 14.3M 2-mercaptoethanol" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test 250mM Iodoacetamide" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test 1% SDS in 100mM Tris, pH 9.5" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test Molecular weight ladder" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS IgG Standard" <> $SessionUUID],
					Object[Item,Consumable,"ExperimentCESDSOptions Test CESDS Running Buffer - Top" <> $SessionUUID],
					Object[Item,Consumable,"ExperimentCESDSOptions test CleanupCartridge" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Running Buffer - Bottom" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Separation Matrix" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Conditioning Acid" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Conditioning Base" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Internal Standard 25X" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Wash Solution" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS 0.5% SDS" <> $SessionUUID],
					Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert,"ExperimentCESDSOptions test CESDS cartridge Insert" <> $SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ExperimentCESDSOptions "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCESDSOptions" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
		Block[{$AllowSystemsProtocols=True},(* must use Block here, rather than With, With wont set it back to original value *)
			Module[
				{
					fakeBench,container,container2,sample,sample2,cartridge1,cartridge2,reagentContainer,bme,iam,
					sampleBuffer,ladder,igGStd,runningBufferBottom,sepMatrix,condAcid,condBase,intStd,washSolution,
					cleanupCartridge,allObjects,runningBufferTop,cartridgeInsert,sampleModel,sampleModel1
				},

				sampleModel1=UploadSampleModel[ "Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID,
					Composition->{
						{100 VolumePercent,Model[Molecule,"Water"]},
						{10 Milligram/Milliliter,Model[Molecule,Protein,"id:o1k9jAGP83Ba"]}
					},
					State->Liquid,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					Expires->True,
					ShelfLife->1 Month,
					UnsealedShelfLife->2 Week,
					MSDSFile -> NotApplicable,
					Flammable->False,
					BiosafetyLevel->"BSL-1",
					IncompatibleMaterials->{None}
				];

				fakeBench=Upload[
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Unit Test bench for ExperimentCESDSOptions tests" <> $SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				cartridge1=
					Upload[<|Name->
						"CESDS-Plus Cartridge test Object 1 for ExperimentCESDSOptions "<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model->
							Link[Model[Container,ProteinCapillaryElectrophoresisCartridge,
								"CESDS-Plus"],Objects],
						NumberOfUses->75,
						DeveloperObject->True, Status->Available,
						Site -> Link[$Site]|>];
				cartridge2=
					Upload[<|Name->"cIEF Cartridge test Object 1 for ExperimentCESDSOptions" <> $SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model->
							Link[Model[Container,ProteinCapillaryElectrophoresisCartridge,
								"cIEF"],Objects],
						NumberOfUses->25,
						DeveloperObject->True, Status->Available,
						Site -> Link[$Site]|>];

				cartridgeInsert = Upload@<|
					Type ->Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert],
					Model ->Link[Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert, "CESDS Cartridge Insert"], Objects],
					Name -> "ExperimentCESDSOptions test CESDS cartridge Insert" <> $SessionUUID,
					Status -> Available,
					DeveloperObject->True,
					Site -> Link[$Site]
				|>;

				{
					container,
					container2,
					reagentContainer
				}=UploadSample[
					{
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}

					},
					Status->Available,
					Name->{
						"Unit Test container 1 for ExperimentCESDSOptions tests" <> $SessionUUID,
						"Unit Test container 2 for ExperimentCESDSOptions tests" <> $SessionUUID,
						"Unit Test container for reagents in ExperimentCESDSOptions tests" <> $SessionUUID
					}
				];

				{
					(*1*)sample,
					(*2*)sample2,
					(*12*)bme,
					(*13*)iam,
					(*14*)sampleBuffer,
					(*15*)ladder,
					(*16*)igGStd,
					(*17*)runningBufferBottom,
					(*18*)sepMatrix,
					(*19*)condAcid,
					(*20*)condBase,
					(*21*)intStd,
					(*22*)washSolution
				}=UploadSample[
					{
						(*1*)Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
						(*1*)Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
						(*12*)Model[Sample,"2-Mercaptoethanol"],
						(*13*)Model[Sample, StockSolution,"250mM Iodoacetamide"],
						(*15*)Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
						(*16*)Model[Sample, "Unstained Protein Standard"],
						(*17*)Model[Sample, StockSolution, "Resuspended CESDS IgG Standard"],
						(*18*)Model[Sample,"CESDS Running Buffer - Bottom"],
						(*19*)Model[Sample,"CESDS Separation Matrix"],
						(*20*)Model[Sample,"CESDS Conditioning Acid"],
						(*21*)Model[Sample,"CESDS Conditioning Base"],
						(*22*)Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"],
						(*23*)Model[Sample,"CESDS Wash Solution"]
					},
					{
						(*1*){"A1",container},
						(*2*){"A1",container2},
						(*12*){"A1",reagentContainer},
						(*13*){"A2",reagentContainer},
						(*14*){"A3",reagentContainer},
						(*15*){"A4",reagentContainer},
						(*16*){"A5",reagentContainer},
						(*17*){"A7",reagentContainer},
						(*18*){"A8",reagentContainer},
						(*19*){"A9",reagentContainer},
						(*20*){"A10",reagentContainer},
						(*21*){"A11",reagentContainer},
						(*22*){"A12",reagentContainer}
					},
					InitialAmount->{
						(*1*)100*Microliter,
						(*2*)100*Microliter,
						(*12*)2*Milliliter,
						(*13*)2*Milliliter,
						(*14*)2*Milliliter,
						(*15*)2*Milliliter,
						(*16*)2*Milliliter,
						(*17*)2*Milliliter,
						(*18*)2*Milliliter,
						(*19*)2*Milliliter,
						(*20*)2*Milliliter,
						(*21*)2*Milliliter,
						(*22*)2*Milliliter
					},
					Name->{
						(*1*)"ExperimentCESDSOptions Test sample 1 (100 uL)" <> $SessionUUID,
						(*2*)"ExperimentCESDSOptions Test sample 1 (discarded)" <> $SessionUUID,
						(*12*)"ExperimentCESDSOptions Test 14.3M 2-mercaptoethanol" <> $SessionUUID,
						(*13*)"ExperimentCESDSOptions Test 250mM Iodoacetamide" <> $SessionUUID,
						(*14*)"ExperimentCESDSOptions Test 1% SDS in 100mM Tris, pH 9.5" <> $SessionUUID,
						(*15*)"ExperimentCESDSOptions Test Molecular weight ladder" <> $SessionUUID,
						(*16*)"ExperimentCESDSOptions Test CESDS IgG Standard" <> $SessionUUID,
						(*17*)"ExperimentCESDSOptions Test CESDS Running Buffer - Bottom" <> $SessionUUID,
						(*18*)"ExperimentCESDSOptions Test CESDS Separation Matrix" <> $SessionUUID,
						(*19*)"ExperimentCESDSOptions Test CESDS Conditioning Acid" <> $SessionUUID,
						(*20*)"ExperimentCESDSOptions Test CESDS Conditioning Base" <> $SessionUUID,
						(*21*)"ExperimentCESDSOptions Test CESDS Internal Standard 25X" <> $SessionUUID,
						(*22*)"ExperimentCESDSOptions Test CESDS Wash Solution" <> $SessionUUID
					},
					StorageCondition->{
						(*1*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*2*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*12*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*13*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*14*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*15*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*16*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*17*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*18*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*19*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*20*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*21*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*22*)Link[Model[StorageCondition,"Ambient Storage"]]
					}
				];

				cleanupCartridge = Upload@<|
					Type -> Object[Item, Consumable],
					Model ->Link[Model[Item, Consumable,"CESDS Cartridge Cleanup Column"], Objects],
					Name ->"ExperimentCESDSOptions test CleanupCartridge" <> $SessionUUID,
					StorageCondition ->Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfUses -> 0,
					Status -> Available,
					Site -> Link[$Site]
				|>;

				runningBufferTop= Upload[<|Type -> Object[Item, Consumable],
					Model -> Link[
						Model[Item, Consumable,
							"Prefilled Top Running Buffer Vial"], Objects],
					Name -> "ExperimentCESDSOptions Test CESDS Running Buffer - Top" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition ->
						Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfUses -> 0, Status -> Available,
					Site -> Link[$Site]|>];

				(* upload other items needed for testing the protocol All of those are Developer object -> True AwaitingStorageUpdate-> Null so that they are not treated as real objects in lab if messed something up *)
				allObjects=Cases[Flatten[{container,container2,sample,sample2,cartridge1,cartridge2,reagentContainer,
					bme,iam,sampleBuffer,ladder,igGStd,runningBufferBottom,sepMatrix,condAcid,condBase,intStd,washSolution,
					cleanupCartridge}],ObjectP[]];
				Upload[<|Object->#,DeveloperObject->True,AwaitingStorageUpdate->Null|> &/@allObjects];
				Upload[Cases[Flatten[{
					<|Object->sample2, Status->Discarded,Model->Null|>
				}],PacketP[]]];
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::AliquotRequired];
		ClearMemoization[];
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container,Bench,"Unit Test bench for ExperimentCESDSOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Unit Test container 1 for ExperimentCESDSOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Unit Test container 2 for ExperimentCESDSOptions tests" <> $SessionUUID],
					Object[Container,Plate,"Unit Test container for reagents in ExperimentCESDSOptions tests" <> $SessionUUID],
					Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test sample 1 (discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test sample 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test 14.3M 2-mercaptoethanol" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test 250mM Iodoacetamide" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test 1% SDS in 100mM Tris, pH 9.5" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test Molecular weight ladder" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS IgG Standard" <> $SessionUUID],
					Object[Item,Consumable,"ExperimentCESDSOptions Test CESDS Running Buffer - Top" <> $SessionUUID],
					Object[Item,Consumable,"ExperimentCESDSOptions test CleanupCartridge" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Running Buffer - Bottom" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Separation Matrix" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Conditioning Acid" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Conditioning Base" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Internal Standard 25X" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS Wash Solution" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSOptions Test CESDS 0.5% SDS" <> $SessionUUID],
					Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert,"ExperimentCESDSOptions test CESDS cartridge Insert" <> $SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ExperimentCESDSOptions "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCESDSOptions" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentCapillaryGelElectrophoresisSDSPreview*)

DefineTests[
	ExperimentCapillaryGelElectrophoresisSDSPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentCapillaryGelElectrophoresisSDS:"},
			ExperimentCapillaryGelElectrophoresisSDSPreview[Object[Sample,"ExperimentCESDSPreview Test sample 1 (100 uL)" <> $SessionUUID]],
			Null
		],
		Example[{Basic,"Return Null for multiple samples:"},
			ExperimentCapillaryGelElectrophoresisSDSPreview[{Object[Sample,"ExperimentCESDSPreview Test sample 1 (100 uL)" <> $SessionUUID],Object[Sample,"ExperimentCESDSPreview Test sample 1 (100 uL)" <> $SessionUUID]}],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentCapillaryGelElectrophoresisSDSOptions:"},
			ExperimentCapillaryGelElectrophoresisSDSOptions[Object[Sample,"ExperimentCESDSPreview Test sample 1 (100 uL)" <> $SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentCapillaryGelElectrophoresisSDSQ:"},
			ValidExperimentCapillaryGelElectrophoresisSDSQ[Object[Sample,"ExperimentCESDSPreview Test sample 1 (100 uL)" <> $SessionUUID]],
			True
		]
	},
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True,
		$DeveloperSearch = True
	},
	SetUp:>( (* before and after EVERY test *)
		$CreatedObjects={}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp:>( (* create objects for tests, runs once before everything *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::AliquotRequired];
		ClearMemoization[];ClearDownload[];
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container,Bench,"Unit Test bench for ExperimentCESDSPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Unit Test container 1 for ExperimentCESDSPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Unit Test container 2 for ExperimentCESDSPreview tests" <> $SessionUUID],
					Object[Container,Plate,"Unit Test container for reagents in ExperimentCESDSPreview tests" <> $SessionUUID],
					Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test sample 1 (discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test sample 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test 14.3M 2-mercaptoethanol" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test 250mM Iodoacetamide" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test 1% SDS in 100mM Tris, pH 9.5" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test Molecular weight ladder" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS IgG Standard" <> $SessionUUID],
					Object[Item,Consumable,"ExperimentCESDSPreview Test CESDS Running Buffer - Top" <> $SessionUUID],
					Object[Item,Consumable,"ExperimentCESDSPreview test CleanupCartridge" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Running Buffer - Bottom" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Separation Matrix" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Conditioning Acid" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Conditioning Base" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Internal Standard 25X" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Wash Solution" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS 0.5% SDS" <> $SessionUUID],
					Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert,"ExperimentCESDSPreview test CESDS cartridge Insert" <> $SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ExperimentCESDSPreview "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCESDSPreview" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
		Block[{$AllowSystemsProtocols=True},(* must use Block here, rather than With, With wont set it back to original value *)
			Module[
				{
					fakeBench,container,container2,sample,sample2,cartridge1,cartridge2,reagentContainer,bme,iam,
					sampleBuffer,ladder,igGStd,runningBufferBottom,sepMatrix,condAcid,condBase,intStd,washSolution,
					cleanupCartridge,allObjects,runningBufferTop,cartridgeInsert,sampleModel,sampleModel1
				},

				sampleModel1=UploadSampleModel[ "Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID,
					Composition->{
						{100 VolumePercent,Model[Molecule,"Water"]},
						{10 Milligram/Milliliter,Model[Molecule,Protein,"id:o1k9jAGP83Ba"]}
					},
					State->Liquid,
					DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
					Expires->True,
					ShelfLife->1 Month,
					UnsealedShelfLife->.1 Month,
					MSDSFile -> NotApplicable,
					Flammable->False,
					BiosafetyLevel->"BSL-1",
					IncompatibleMaterials->{None}
				];

				fakeBench=Upload[
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Unit Test bench for ExperimentCESDSPreview tests" <> $SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						Site -> Link[$Site]
					|>];

				cartridge1=
					Upload[
						<|
							Name-> "CESDS-Plus Cartridge test Object 1 for ExperimentCESDSPreview "<>$SessionUUID,
							Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
							Model-> Link[Model[Container,ProteinCapillaryElectrophoresisCartridge, "CESDS-Plus"],Objects],
							NumberOfUses->75,
							DeveloperObject->True,
							Status->Available,
							Site -> Link[$Site]
						|>
					];
				cartridge2=
					Upload[<|Name->"cIEF Cartridge test Object 1 for ExperimentCESDSPreview" <> $SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model->
							Link[Model[Container,ProteinCapillaryElectrophoresisCartridge,
								"cIEF"],Objects],
						NumberOfUses->25,
						DeveloperObject->True, Status->Available,
						Site -> Link[$Site]|>];

				cartridgeInsert = Upload@<|
					Type ->Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert],
					Model ->Link[Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert, "CESDS Cartridge Insert"], Objects],
					Name -> "ExperimentCESDSPreview test CESDS cartridge Insert" <> $SessionUUID,
					Status -> Available,
					DeveloperObject->True,
					Site -> Link[$Site]
				|>;

				{
					container,
					container2,
					reagentContainer
				}=UploadSample[
					{
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}

					},
					Status->Available,
					Name->{
						"Unit Test container 1 for ExperimentCESDSPreview tests" <> $SessionUUID,
						"Unit Test container 2 for ExperimentCESDSPreview tests" <> $SessionUUID,
						"Unit Test container for reagents in ExperimentCESDSPreview tests" <> $SessionUUID
					}
				];

				{
					(*1*)sample,
					(*2*)sample2,
					(*12*)bme,
					(*13*)iam,
					(*14*)sampleBuffer,
					(*15*)ladder,
					(*16*)igGStd,
					(*17*)runningBufferBottom,
					(*18*)sepMatrix,
					(*19*)condAcid,
					(*20*)condBase,
					(*21*)intStd,
					(*22*)washSolution
				}=UploadSample[
					{
						(*1*)Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
						(*1*)Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
						(*12*)Model[Sample,"2-Mercaptoethanol"],
						(*13*)Model[Sample, StockSolution,"250mM Iodoacetamide"],
						(*15*)Model[Sample,"1% SDS in 100mM Tris, pH 9.5"],
						(*16*)Model[Sample, "Unstained Protein Standard"],
						(*17*)Model[Sample,StockSolution, "Resuspended CESDS IgG Standard"],
						(*18*)Model[Sample,"CESDS Running Buffer - Bottom"],
						(*19*)Model[Sample,"CESDS Separation Matrix"],
						(*20*)Model[Sample,"CESDS Conditioning Acid"],
						(*21*)Model[Sample,"CESDS Conditioning Base"],
						(*22*)Model[Sample,StockSolution, "Resuspended CESDS Internal Standard 25X"],
						(*23*)Model[Sample,"CESDS Wash Solution"]
					},
					{
						(*1*){"A1",container},
						(*2*){"A1",container2},
						(*12*){"A1",reagentContainer},
						(*13*){"A2",reagentContainer},
						(*14*){"A3",reagentContainer},
						(*15*){"A4",reagentContainer},
						(*16*){"A5",reagentContainer},
						(*17*){"A7",reagentContainer},
						(*18*){"A8",reagentContainer},
						(*19*){"A9",reagentContainer},
						(*20*){"A10",reagentContainer},
						(*21*){"A11",reagentContainer},
						(*22*){"A12",reagentContainer}
					},
					InitialAmount->{
						(*1*)100*Microliter,
						(*2*)100*Microliter,
						(*12*)2*Milliliter,
						(*13*)2*Milliliter,
						(*14*)2*Milliliter,
						(*15*)2*Milliliter,
						(*16*)2*Milliliter,
						(*17*)2*Milliliter,
						(*18*)2*Milliliter,
						(*19*)2*Milliliter,
						(*20*)2*Milliliter,
						(*21*)2*Milliliter,
						(*22*)2*Milliliter
					},
					Name->{
						(*1*)"ExperimentCESDSPreview Test sample 1 (100 uL)" <> $SessionUUID,
						(*2*)"ExperimentCESDSPreview Test sample 1 (discarded)" <> $SessionUUID,
						(*12*)"ExperimentCESDSPreview Test 14.3M 2-mercaptoethanol" <> $SessionUUID,
						(*13*)"ExperimentCESDSPreview Test 250mM Iodoacetamide" <> $SessionUUID,
						(*14*)"ExperimentCESDSPreview Test 1% SDS in 100mM Tris, pH 9.5" <> $SessionUUID,
						(*15*)"ExperimentCESDSPreview Test Molecular weight ladder" <> $SessionUUID,
						(*16*)"ExperimentCESDSPreview Test CESDS IgG Standard" <> $SessionUUID,
						(*17*)"ExperimentCESDSPreview Test CESDS Running Buffer - Bottom" <> $SessionUUID,
						(*18*)"ExperimentCESDSPreview Test CESDS Separation Matrix" <> $SessionUUID,
						(*19*)"ExperimentCESDSPreview Test CESDS Conditioning Acid" <> $SessionUUID,
						(*20*)"ExperimentCESDSPreview Test CESDS Conditioning Base" <> $SessionUUID,
						(*21*)"ExperimentCESDSPreview Test CESDS Internal Standard 25X" <> $SessionUUID,
						(*22*)"ExperimentCESDSPreview Test CESDS Wash Solution" <> $SessionUUID
					},
					StorageCondition->{
						(*1*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*2*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*12*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*13*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*14*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*15*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*16*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*17*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*18*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*19*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*20*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*21*)Link[Model[StorageCondition,"Ambient Storage"]],
						(*22*)Link[Model[StorageCondition,"Ambient Storage"]]
					}
				];

				cleanupCartridge = Upload@<|
					Type -> Object[Item, Consumable],
					Model ->Link[Model[Item, Consumable,"CESDS Cartridge Cleanup Column"], Objects],
					Name ->"ExperimentCESDSPreview test CleanupCartridge" <> $SessionUUID,
					StorageCondition ->Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfUses -> 0,
					Status -> Available,
					Site -> Link[$Site]
				|>;

				runningBufferTop= Upload[<|Type -> Object[Item, Consumable],
					Model -> Link[
						Model[Item, Consumable,
							"Prefilled Top Running Buffer Vial"], Objects],
					Name -> "ExperimentCESDSPreview Test CESDS Running Buffer - Top" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition ->
						Link[Model[StorageCondition, "Ambient Storage"]],
					NumberOfUses -> 0, Status -> Available,
					Site -> Link[$Site]|>];

				(* upload other items needed for testing the protocol All of those are Developer object -> True AwaitingStorageUpdate-> Null so that they are not treated as real objects in lab if messed something up *)
				allObjects=Cases[Flatten[{container,container2,sample,sample2,cartridge1,cartridge2,reagentContainer,
					bme,iam,sampleBuffer,ladder,igGStd,runningBufferBottom,sepMatrix,condAcid,condBase,intStd,washSolution,
					cleanupCartridge}],ObjectP[]];
				Upload[<|Object->#,DeveloperObject->True,AwaitingStorageUpdate->Null|> &/@allObjects];
				Upload[Cases[Flatten[{
					<|Object->sample2, Status->Discarded,Model->Null|>
				}],PacketP[]]];
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::AliquotRequired];
		ClearMemoization[];
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container,Bench,"Unit Test bench for ExperimentCESDSPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Unit Test container 1 for ExperimentCESDSPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Unit Test container 2 for ExperimentCESDSPreview tests" <> $SessionUUID],
					Object[Container,Plate,"Unit Test container for reagents in ExperimentCESDSPreview tests" <> $SessionUUID],
					Model[Sample,"Unit Test 10 mg/mL BSA Fraction V "<>$SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test sample 1 (discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test sample 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test 14.3M 2-mercaptoethanol" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test 250mM Iodoacetamide" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test 1% SDS in 100mM Tris, pH 9.5" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test Molecular weight ladder" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS IgG Standard" <> $SessionUUID],
					Object[Item,Consumable,"ExperimentCESDSPreview Test CESDS Running Buffer - Top" <> $SessionUUID],
					Object[Item,Consumable,"ExperimentCESDSPreview test CleanupCartridge" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Running Buffer - Bottom" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Separation Matrix" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Conditioning Acid" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Conditioning Base" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Internal Standard 25X" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS Wash Solution" <> $SessionUUID],
					Object[Sample,"ExperimentCESDSPreview Test CESDS 0.5% SDS" <> $SessionUUID],
					Object[Container, ProteinCapillaryElectrophoresisCartridgeInsert,"ExperimentCESDSPreview test CESDS cartridge Insert" <> $SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ExperimentCESDSPreview "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCESDSPreview" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
	)
];
